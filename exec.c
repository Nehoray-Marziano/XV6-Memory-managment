#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct inode *ip;
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
  pgdir = 0;

////////////////////ASSIGNMENT 3////////////////////////
/**going to initialize all the fields for the new program**/
  #if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
    struct page pages_backup[MAX_TOTAL_PAGES];
    int indexes_backup[5];
    int ram_queue_backup[MAX_PYSC_PAGES];
    int offsets_queue_backup[MAX_PYSC_PAGES];
    backup_and_reset_all(pages_backup, indexes_backup, ram_queue_backup, offsets_queue_backup);
  #endif
  /////////////////////////END//////////////////////

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
      }
  iunlockput(ip);
  end_op();
  
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;

  /////////// ASSIGNMENT 3////////////
  #if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
  /**make the new swapfile for the proccess**/
    if(curproc->pid > 2){
      removeSwapFile(curproc);
      createSwapFile(curproc);
    }
  #endif
  //////////////////END///////////////////

  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  #if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
    restore(pages_backup, indexes_backup, ram_queue_backup, offsets_queue_backup);
  #endif
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}



//////////////////////HELPER FUNCTION FOR ASS3/////////////////////////
void backup_and_reset_all(struct page* backup_pages, int* indexes_backup, int* in_RAM_backup, int* offset_arr_backup){
  struct proc* curproc = myproc();
  int i;
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
    /**backup everything from 'pages' in curproc**/
    backup_pages[i].offset_in_swapfile = curproc->pages[i].offset_in_swapfile;
    backup_pages[i].in_RAM = curproc->pages[i].in_RAM;  
    backup_pages[i].virtual_addr = curproc->pages[i].virtual_addr;
    backup_pages[i].allocated = curproc->pages[i].allocated;

    /**  clean everything in 'pages' **/
    curproc->pages[i].virtual_addr = 0;
    curproc->pages[i].offset_in_swapfile = -1;
    curproc->pages[i].in_RAM = 0;
    curproc->pages[i].allocated = 0;
  }
    for (i = 0; i < MAX_PYSC_PAGES; ++i) {
    /**  backup pages array (in_RAM) **/
      in_RAM_backup[i] = curproc->inRAM[i];
      offset_arr_backup[i] = curproc->free_swapfile_offsets[i];
    
      /**  clear 'pages' **/
      curproc->inRAM[i] = -1;
      curproc->free_swapfile_offsets[i] = -1;
  }



    /**  'index' is like this special array to save special fields from curproc. we could've not use it but the signature of the function would have been much longer **/
  indexes_backup[0] = curproc->free_swapfile_offset;
  indexes_backup[1] = curproc->swapped_pages_now;
  indexes_backup[2] = curproc->page_faults_now;
  indexes_backup[3] = curproc->total_swaps;
  indexes_backup[4] = curproc->total_allocated_pages;

    /**  now clear everything **/
  curproc->free_swapfile_offset = 0;
  curproc->swapped_pages_now = 0;
  curproc->page_faults_now = 0;
  curproc->total_swaps = 0;
  curproc->total_allocated_pages = 0;

  

}

void
restore(struct page* backup_pages, int* indexes_backup, int* in_RAM_backup, int* offset_arr_backup)
{ //this function is calles only if exec has failed. if that happend, we need to restore everything we backed up
  struct proc *curproc = myproc();
  int i;
  for (i = 0; i < MAX_TOTAL_PAGES; ++i) {
    /**  restore everything in 'pages' **/
    curproc->pages[i].virtual_addr = backup_pages[i].virtual_addr;
    curproc->pages[i].offset_in_swapfile = backup_pages[i].offset_in_swapfile;
    curproc->pages[i].in_RAM = backup_pages[i].in_RAM;
    curproc->pages[i].allocated = backup_pages[i].allocated;
  }

  for (i = 0 ; i < MAX_PYSC_PAGES; ++i) {
    curproc->inRAM[i] = in_RAM_backup[i];
    curproc->free_swapfile_offsets[i] = offset_arr_backup[i];
  }


  /**  restore the special indexes we wrote about **/
  curproc->free_swapfile_offset = indexes_backup[0] ;
  curproc->swapped_pages_now = indexes_backup[1];
  curproc->page_faults_now = indexes_backup[2];
  curproc->total_swaps = indexes_backup[3];
  curproc->total_allocated_pages = indexes_backup[4];
}