#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

int COW_helper(uint va){
    return pagefault(va);
}

int policies_helper(uint va){
    struct proc* curproc = myproc();
    uint my_page = PGROUNDDOWN(va);
    int counter = 0;
    int i;
      for(i = 0; i < MAX_TOTAL_PAGES; i++){
        if((curproc->pages[i].allocated == 1) && (curproc->pages[i].in_RAM) )
          counter++;
      }
    if(counter == MAX_PYSC_PAGES)
      swap_out(curproc->pgdir);

    char* new_page_addr = kalloc();
    if(new_page_addr == 0){  //meaning kalloc has failed!
      /**  no need to call dealloc because no allocation happend **/
      cprintf("in trap: kalloc failed!\n");    
      return 0;//indicating something failed
    }
    memset(new_page_addr, 0, PGSIZE);
    i=0;
    while((i<MAX_TOTAL_PAGES) && (curproc->pages[i].virtual_addr != my_page))
      i++;
    
    if(i==MAX_TOTAL_PAGES){//we reached the end
      panic("in trap: couldn't find the page");
      return 0;
    }
    
    uint offset = curproc->pages[i].offset_in_swapfile;
    /** 'populate' the page starting at new_page with everything related from the swap file **/
    readFromSwapFile(curproc, new_page_addr, offset, PGSIZE);
    pte_t *pte = (pte_t*)global_walkpgdir(curproc->pgdir,(char *) va,  0);
    *pte = TURN_OFF_PTE_P(*pte);
    *pte = TURN_ON_PTE_PG(*pte);
    global_mappages(curproc->pgdir, (void *) my_page, PGSIZE, V2P(new_page_addr), PTE_W | PTE_U );

    *pte = TURN_ON_PTE_P(*pte);
    *pte = TURN_OFF_PTE_PG(*pte);

    curproc->pages[i].in_RAM = 1;
    insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);
    curproc->pages[i].offset_in_swapfile = -1;
    
    insert_to_RAM_queue(i);
    /**  REMOVED a page from the swap file, decrement the number of pages in the file ! **/
    curproc->swapped_pages_now--;
    
    lapiceoi();
    return 1; // PGFLT case break- success
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  struct proc* curproc = myproc();
  if(tf->trapno == T_SYSCALL){
    if(curproc->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(curproc->killed)
      exit();
    return;
  }


  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:

    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

 
  ///////////////////////////ASSIGNMENT 3//////////////////////
  #if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
    case T_PGFLT:
      curproc->page_faults_now++;
      uint va = rcr2();
      uint my_page = PGROUNDDOWN(va);

      int counter = 0;
      int i;
      for(i = 0; i < MAX_TOTAL_PAGES; i++){
        if((curproc->pages[i].allocated == 1) && (curproc->pages[i].in_RAM))
          counter++;
        }
      if(counter == MAX_PYSC_PAGES)
        swap_out(curproc->pgdir);

      char* new_page_addr = kalloc();
      if(new_page_addr == 0){  //meaning kalloc has failed!
      /**  no need to call dealloc because no allocation happend **/
        cprintf("in trap: kalloc failed!\n");   
      }
      memset(new_page_addr, 0, PGSIZE);
      i=0;
      while((i<MAX_TOTAL_PAGES) && (curproc->pages[i].virtual_addr != my_page))
        i++;
    
      if(i==MAX_TOTAL_PAGES){//we reached the end
        panic("in trap: couldn't find the page");
      }
    
      uint offset = curproc->pages[i].offset_in_swapfile;
      /** 'populate' the page starting at new_page with everything related from the swap file **/
      readFromSwapFile(curproc, new_page_addr, offset, PGSIZE);
      pte_t *pte = (pte_t*)global_walkpgdir(curproc->pgdir,(char *) va,  0);
      *pte = TURN_OFF_PTE_P(*pte);
      *pte = TURN_ON_PTE_PG(*pte);
      global_mappages(curproc->pgdir, (void *) my_page, PGSIZE, V2P(new_page_addr), PTE_W | PTE_U );

      *pte = TURN_ON_PTE_P(*pte);
      *pte = TURN_OFF_PTE_PG(*pte);

      curproc->pages[i].in_RAM = 1;
      insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);
      curproc->pages[i].offset_in_swapfile = -1;
    
      insert_to_RAM_queue(i);
    /**  REMOVED a page from the swap file, decrement the number of pages in the file ! **/
      curproc->swapped_pages_now--;
    
      lapiceoi();
      break; // PGFLT case break
  #endif

//PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
