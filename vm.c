#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"
#include "spinlock.h"
extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

struct spinlock lock;
char pg_refcount[PHYSTOP >> PTXSHIFT]; // array to store refcount

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
/** after initializing, one link is established**/
  //acquire(&lock);
  //pg_refcount[V2P(mem) >>PTXSHIFT] = pg_refcount[V2P(mem)>> PTXSHIFT] + 1 ; //for COW
  //release(&lock);
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  struct proc *curproc = myproc();
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);


  //////////ASSIGNMENT 3///////////////////////
  for(; a < newsz; a += PGSIZE){
#if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
      if((curproc->pid > 2) && (a >= PGSIZE * MAX_PYSC_PAGES)){ //we do not allow to have more than [PGSIZE * MAX_PYSC_PAGES] space for each proccess, except for the first 2 proccess (init and sh)
        swap_out(pgdir);
      }
#endif
//////////////////////////////////////////////
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz, 0); // if something failed, there is no reason to call deallocate_pages as well
      return 0;
    }

  memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("in allocuvm: out of memory!");
      deallocuvm(pgdir, newsz, oldsz, 0);
      return 0;
    }

    //acquire(&lock);
    //pg_refcount[V2P(mem) >> 12] = pg_refcount[V2P(mem) >> 12] + 1 ;
//release(&lock);

    ////////ASSIGNMENT 3//////////////////////
#if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
    pte_t *pte;
    if(curproc->pid > 2) // again, this is only allowed for the first 2 proccess' (init and sh). any other proccess will get in the 'if'
    {
      int page_index = 0;

      while((page_index < MAX_TOTAL_PAGES) && (curproc->pages[page_index].allocated == 1))
        page_index++;

          curproc->pages[page_index].virtual_addr = a; 
          curproc->pages[page_index].allocated = 1;
          curproc->pages[page_index].in_RAM = 1; //  the new page is inside the main memory
          curproc->pages[page_index].offset_in_swapfile = -1; // the page is NOT in the swap file

      insert_to_RAM_queue(page_index);
       
      curproc->total_allocated_pages++;

      pte = walkpgdir(pgdir, (char *)a , 0);
      *pte=TURN_ON_PTE_P(*pte); //  the new page is inside the main memory
      *pte=TURN_OFF_PTE_PG(*pte); // no paging on this page 
    }
#endif
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
//the flag was added for ASSIGNMENT 3 in order to know whether we need to call deallocatepages or not (depends on whether allocation succeeded or not)
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int flag)
{
  #if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
    struct proc* curproc = myproc();
  #endif
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");

#if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
      if(curproc->pid > 2 && flag)  // the flag indicates if we should to deallocate the pages as well. in this case, we should!
        deallocate_page(a);
#endif
    char *va = P2V(pa);
    kfree(va);
    *pte = 0;
    }
    else{
#if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
        if(curproc->pid > 2 && ((*pte & PTE_PG) != 0)){
          pa = PTE_ADDR(*pte);
          if(pa == 0)
            panic("in deallocuvm: no such address!");
          if(curproc->pid > 2 && flag == 1)
            deallocate_page(a);
          *pte = 0;
        }
#endif
    }

      
      ////////////////////// our failed try to implement COW.. I hope youll see the logic//////////
      //acquire(&lock);
      // if no other page table is pointing to the page,remove it
      //if(--pg_refcount[pa >> PTXSHIFT] == 0)
      //{
      //char *v = P2V(pa);
      //kfree(v);
      //}
      //release(&lock);
///////////////////////////////////

  
     
     
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0, 0);  // no need to call deallocate_page
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      goto bad;
      //kfree(mem);
    }
     //acquire(&lock);
    //pg_refcount[pa >> PTXSHIFT] = pg_refcount[pa >> PTXSHIFT] + 1; // increase ref count
//release(&lock);
  }
  lcr3(V2P(pgdir));
  return d;

bad:
  freevm(d);
  lcr3(V2P(pgdir));
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

uint select_page(){ //depending on the policy, returns the address of the page that needs to be swapped
  struct proc* curproc = myproc();

  int page_to_return_index = 0;
  #if defined(NFUA)
    page_to_return_index = select_for_NFUA();
  #endif

  #if defined(LAPA)
    page_to_return_index = select_for_LAPA();
  #endif

  #if defined(SCFIFO)
    page_to_return_index = select_for_SCFIFO();
  #endif

  #if defined(AQ)
    page_to_return_index = select_for_AQ();
  #endif
  uint final_page = curproc->pages[page_to_return_index].virtual_addr;
  int k;
  for(k=0;k<MAX_TOTAL_PAGES;k++){
  }
  return final_page;
}

char* swap_out(pde_t* pgdir){
  struct proc* curproc = myproc();
  pte_t *pte;
  uint page_to_swap_addr =select_page();
  int offset_to_write = get_free_offset();
  writeToSwapFile(curproc, (char*) page_to_swap_addr, offset_to_write, PGSIZE); // write the page in the free space in the swap file

  int i = 0;
  while(i < MAX_TOTAL_PAGES &&curproc->pages[i].virtual_addr != page_to_swap_addr)
    i++;

      /** we wrote it in the swap file, now we need to update it in the proc's pages array**/
      curproc->pages[i].offset_in_swapfile = offset_to_write;
      curproc->pages[i].in_RAM = 0;
      //curproc->pages[i].is_swapped = 1;
     
  curproc->swapped_pages_now++;
  curproc->total_swaps++;

  pte = walkpgdir(pgdir, (char *) page_to_swap_addr, 0); // getting the page table entry for this page
  *pte = TURN_OFF_PTE_P(*pte); // the bit is not present anymore
  *pte = TURN_ON_PTE_PG(*pte); // paging has accured and the page is swapped
  uint p_address = PTE_ADDR(*pte);
  char* virtual_addr = P2V(p_address);
  kfree(virtual_addr); //opposite of malloc()- frees the memory of a desireable address
  lcr3(V2P(curproc->pgdir)); // refreshing TLB==refreshing the CR3 register
  return virtual_addr;
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.


////////////////////////ASSIGNMENT 3-TASK 2/////////////////////
pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("cowuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");

    // make the permissions for the parent_page read only
    *pte &= ~PTE_W;
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
      goto bad;
    //acquire(&lock);
    //pg_refcount[pa >> PTXSHIFT] = pg_refcount[pa >> PTXSHIFT] + 1; // increase reference count of that permanent page.
    //release(&lock);
  }
  lcr3(V2P(pgdir)); // Flush TLB for original process
  return d;

bad:
  freevm(d);
  // Even though we failed to copy, we should flush TLB, since
  // some entries in the original process page table have been changed
  lcr3(V2P(pgdir));
  return 0;
}
///////////////////END////////////////////

/*
int
pagefault(uint va)  // va is the faulty address which we want to 'fix'
{
  pte_t *pte;
  struct proc* curproc = myproc();
  uint pa, npa, er = curproc->tf->err, flags;
  char *mem;

  // Obtain the start of the page that the faulty virtual address belongs to
  char *a = (char*)PGROUNDDOWN((uint)va);

  // fault is not for user address - kill process
  if(va >= KERNBASE || (pte = walkpgdir(curproc->pgdir, a, 0)) == 0){
    cprintf("pid %d %s: Page fault--access to invalid address.\n", curproc->pid, curproc->name);
    return 0;
  }

  // write fault for a user address
  if(er & FEC_WR){
    // Check if the fault is for an address whose page table includes the PTE_COW flag
    // If not, kill the program as usual
    if(!(*pte & PTE_COW)){
      return 0;
    } else {
      pa = PTE_ADDR(*pte);  //physical address
      char *v = P2V(pa);
      flags = PTE_FLAGS(*pte);

      // get reference count for faulty page (how many are linked)
      int refs = getRefs(v);

      // page has more than one reference
      if(refs > 1){
        // allocate a new page
        mem = kalloc();

        // Copies memory from the virtual address gotten from fauly pte and copies PGSIZE bytes to mem
        memmove(mem, v, PGSIZE);

        // virtual address for new page
        npa = V2P(mem);
        // Point the PTE pointer to the newly allocated page
        *pte = npa | flags | PTE_P | PTE_W;

        // invalidate TLB
        lcr3(V2P(curproc->pgdir)); 

        // decrement ref count for old page
        kdec(v);
      }
      // page has only one reference, so we can safely write to the page as well (so we'll change the flag to 'write' as well)
      else {
        *pte |= PTE_W;
        *pte &= ~PTE_COW;

        lcr3(V2P(curproc->pgdir)); 
      }
    }
  } else{ // not a write fault
    return 0;
  }
  return 1; //success!
}
*/

int 
pagefault(uint err_code)
{
  // get the faulting virtual address from the CR2 register
  uint va = rcr2();
  uint pa;
  pte_t *pte;
  char *mem;
  struct proc* proc = myproc();

  if(va >= KERNBASE)
  {
    //Mapped to kernel code
    cprintf("Illegal memory access on cpu addr  kill proc  with pid \n"
                                            );
    proc->killed = 1;
    return 1;
  }
  if((pte = walkpgdir(proc->pgdir, (void*)va, 0))==0)
  {
    //Point to null
    cprintf("1Illegal memory access on cpu addr 0x%x, kill proc %s with pid %d\n",
                                          va, proc->name, proc->pid);
    proc->killed = 1;
    return 1;
  }
  if(!(*pte & PTE_U))
  {
    // User cannot access
    cprintf("2Illegal memory access on cpu addr 0x%x, kill proc %s with pid %d\n",
                                           va, proc->name, proc->pid);
    proc->killed = 1;
    return 1;
  }
    if(!(*pte & PTE_P))
  {
    //Not present
    cprintf("3Illegal memory access on cpu  addr 0x%x, kill proc %s with pid %d\n",
                                            va, proc->name, proc->pid);
    proc->killed = 1;
    return 1;
  }
  if(*pte & PTE_W)
  {
    panic("Unknown page fault due to a writable pte");
  }
  else
  {
    // get the physical address from the  given page table entry
    pa = PTE_ADDR(*pte);
    acquire(&lock);
    if(pg_refcount[pa >> PTXSHIFT] == 1)
    {
      release(&lock);
      *pte |= PTE_W;  // remove the read-only restriction on the trapping page
    }
    else
    {
      // Current process is the first one that tries to write to this page
      if(pg_refcount[pa >> PTXSHIFT] > 1)
      {
        release(&lock);
        if((mem = kalloc()) == 0)
        {
          // Out of memory
          cprintf("Illegal memory access");
          proc->killed = 1;
          return 1;
        }
        // copy the contents from the original memory page pointed the virtual address
        memmove(mem, (char*)P2V(pa), PGSIZE);
        acquire(&lock);
        pg_refcount[pa >> PTXSHIFT] = pg_refcount[pa >> PTXSHIFT] - 1;
        pg_refcount[V2P(mem) >> PTXSHIFT] = pg_refcount[V2P(mem) >> PTXSHIFT] + 1;
        release(&lock);
        *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;  // point the given page table entry to the new page
      }
      else
      {
        release(&lock);
        panic("Pagefault due to wrong ref count");
      }
    }
    // Flush TLB for process since page table entries changed
    lcr3(V2P(proc->pgdir));
    return 1;
  }
  return 1;
}


/** no idea why, but you can't call walkpgdir and mappages on their own... --\_('_')_/-- **/
uint global_walkpgdir(pde_t* pgdir, void* va, int alloc){
  return (uint) walkpgdir(pgdir, va, alloc);
}
int global_mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm){
  return mappages(pgdir, va, size, pa, perm);
}