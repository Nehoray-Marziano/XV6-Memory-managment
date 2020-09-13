#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
int get_free_offset();

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  
  //////////////////////////ASSIGNMENT 3////////////
  /**initialization of all the fields**/
  p->free_swapfile_offset = 0;
  p->swapped_pages_now = 0;
  p->total_swaps = 0;
  p->page_faults_now = 0;
  p->total_page_faults = 0;
  p->total_allocated_pages = 0;

  int i;
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
    p->pages[i].virtual_addr = 0;
    p->pages[i].offset_in_swapfile = -1;
    p->pages[i].in_RAM = 0;
    p->pages[i].allocated = 0;
    
    #if defined(LAPA)// in this policy, we want to initialize the age to be the largest number there is..
      p->pages[i].age = 0xFFFFFFFF;
    #else
      p->pages[i].age = 0x00000000;
    #endif
  }
  int j;
  for(j = 0; j<MAX_PYSC_PAGES;j++){ //there is nothing and the ram, and there is no need to use the queue for the swapfile's offsets
    p->inRAM[j] = -1;
    p->free_swapfile_offsets[j] = -1;
  }
  //createSwapFile(p);  //new swap file for a new process
//////////////////END///////////////////
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    curproc->total_allocated_pages += (PGROUNDUP(n)/PGSIZE);//subtracts the number of allocated pages (if the number is positive, it will be done in allocuvm)

    if((sz = deallocuvm(curproc->pgdir, sz, sz + n,  1)) == 0)  //we do want deallocate_page to be called
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){ // we call the COW function instead of copyuvm
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

////////////////ASSIGNMENT 3///////////////////
#if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
  /**first, we will check if the proccess we have is not init or sh, because if so, we don't want to copy all the data from it (might be too big or something like that)**/
  if(np->pid > 2){ //if so, then we can copy everything to np (in case of course, we are in one of the policies)
    createSwapFile(np);
    np->free_swapfile_offset = curproc->free_swapfile_offset;
    np->swapped_pages_now = curproc->swapped_pages_now;
    np->total_swaps = 0;
    np->total_allocated_pages = curproc->total_allocated_pages;
    np->page_faults_now = 0;
    
    int i;
    for(i = 0; i < MAX_TOTAL_PAGES; i++){ // we want to deep copy the 'pages' field from the father proccess
      np->pages[i].virtual_addr = curproc->pages[i].virtual_addr;
      np->pages[i].offset_in_swapfile = curproc->pages[i].offset_in_swapfile;
      np->pages[i].age = curproc->pages[i].age;
      np->pages[i].allocated = curproc->pages[i].allocated;
      np->pages[i].in_RAM = curproc->pages[i].in_RAM;
    }
    /**copy which pages are in the main memory, and what free offsets we have in the swapfile (according to what we already know from curproc)**/
    char* page_for_copying = kalloc(); // this is the address for the page we are going to use in the readFromSwapFile and WriteToSwapFile functions (which pretty much require a page)
    int k;
    for(k = 0; k < curproc->swapped_pages_now; k++){// we want the np's swap file to be identical to the curproc's swap file
      uint offset = k*PGSIZE; // in order to have the offset for the readFromSwapFile and WriteToSwapFile functions
      readFromSwapFile(curproc, page_for_copying, offset, PGSIZE);  //copy from curproc
      writeToSwapFile(np, page_for_copying, offset, PGSIZE);  // paste in np
    }
    int j;
    for(j = 0; j<MAX_PYSC_PAGES; j++){
      np->free_swapfile_offsets[j] = curproc->free_swapfile_offsets[j];
      np->inRAM[j] = curproc->inRAM[j];
    }
    /**now, we want to copy everything from curproc's swap file into np's swap file (using readFromSwapFile and WriteToSwapFile)**/
    
    kfree(page_for_copying); // we finished copying so we don't need the page anymore
  }
  #endif
////////////////////////END//////////////////////
  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  #if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
    removeSwapFile(curproc);
  #endif

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      ///////////////////ASSIGNMENT 3///////////////////////////
      #if defined(AQ) // we need to advance the queue if we took the first (AQ policy)
        advance_for_AQ();
  
      #elif (defined(NFUA) || defined(LAPA))  //  both policies use the aging mechanism, so we keep aging each proccess!
        aging();
      #endif
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).


int getNumPhysPages(){
  return 1;
}

int getNumVirtPages(){
  return 1;
}

int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else{  state = "???";}
    
    cprintf("%d  %s   Allocated MemPages:%d    Paged Out:%d     Page Faults:%d     Total num Paged Out:%d      %s\n", 
    p->pid, state, (PGROUNDUP(p->sz)/PGSIZE) , p->swapped_pages_now, p->page_faults_now,p->total_swaps, p->name  );
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
  cprintf("Number of free pages:%d \n",getNumFreePages()); 
}

void insert_to_RAM_queue(int page_index){
  struct proc *curproc = myproc();
  int i;
  for (i = 0; curproc->inRAM[i] != -1; i++) {
    if (i == MAX_PYSC_PAGES)
      panic("insert to RAM queue: error in inerstion- FULL!!");
  }
  curproc->inRAM[i] = page_index;
}

void insert_to_offsets_queue(int page_index){
  struct proc *curproc = myproc();
  int i;
  for (i = 0; curproc->free_swapfile_offsets[i] != -1; i++) {
    if (i == MAX_PYSC_PAGES)
      panic("insert to offsets queue: error in inerstion!");
  }
  curproc->free_swapfile_offsets[i] = page_index;
}



void move_forward_in_offsets_queue(){//moves all the other offsets forward in line in the free offsets queue
  struct proc* curproc = myproc();
  int i;
  for(i = 0; i < MAX_PYSC_PAGES-1; i++){
    curproc->free_swapfile_offsets[i] = curproc->free_swapfile_offsets[i+1]; // moves everything to the left- one step closer
  }
  curproc->free_swapfile_offsets[MAX_PYSC_PAGES-1] = -1; //clear the last slot
}

void move_forward_in_inRAM_queue(int index){//moves all the other offsets forward in line in the inRAM queue from a certain point
  struct proc* curproc = myproc();
  while(index < MAX_PYSC_PAGES-1){
    curproc->inRAM[index] = curproc->inRAM[index+1]; // moves everything to the left- one step closer
  }
  curproc->inRAM[MAX_PYSC_PAGES-1] = -1; //clear the last slot
}

int next_in_line(){
  struct proc* curproc = myproc();
  int offset = curproc->free_swapfile_offsets[0]; // get the first in line
  
  if(offset != -1) // we need to move the others closer
    move_forward_in_offsets_queue();
  
  return offset;
}

int get_free_offset() {
  struct proc* curproc = myproc();
  int offset = next_in_line();
  if(offset == -1){ //queue is empty - first time
    offset =curproc->free_swapfile_offset;
    curproc->free_swapfile_offset = curproc->free_swapfile_offset + PGSIZE;
  }
  return offset;
}


///////////////////////ASSIGNMENT 3/////////////////////////////
void deallocate_page(uint virtual_addr){  // this function is used in order to clear our 'pages' field in the proc struct. will be called only if allocation happend successfully!
  struct proc* curproc = myproc();

  int i;
  int j;
  for (i = 0; i < MAX_TOTAL_PAGES; i++) {
    if ((curproc->pages[i].allocated != 0) && (curproc->pages[i].virtual_addr ==  virtual_addr)) {// finding the page we want to remove
      curproc->pages[i].virtual_addr = 0;

      #if defined(LAPA)
        curproc->pages[i].age = 0xFFFFFFFF; // like we were asked
      #else
        curproc->pages[i].age = 0x00000000;
      #endif

      curproc->pages[i].allocated = 0;

      /** If the page we want to remove is in the swap file, we want to remember it's offset, for future use **/
      if(curproc->pages[i].in_RAM == 0)
        insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);

      curproc->pages[i].in_RAM = 0;
      curproc->pages[i].offset_in_swapfile = -1;
      break;
    }
  }
  if (i == MAX_TOTAL_PAGES)
    panic("page does not exist in our pages field!");

  for (j = 0; j < MAX_PYSC_PAGES; j++) {  // find the page in the inRAM queue we added
    if (curproc->inRAM[j] == i) {
      move_forward_in_inRAM_queue(j); 
      break;
    }
  }
}

///////////////////ASSIGNMENT 3- SELECT THE PAGE DEPENDING ON THE POLICY//////////////////////
/** they all return an index to a cell in the 'pages' field of a proccess**/

int select_for_NFUA(){  //with aging mechanism
  struct proc* curproc = myproc();
  int i;
  int oldest = 0;
  for(i = 1; i < MAX_PYSC_PAGES; i++){
    if(curproc->pages[curproc->inRAM[i]].age < curproc->pages[curproc->inRAM[oldest]].age)  //  compare each page to the one next to him in order to save the oldest one
      oldest = i;
  }
  int page_to_swap_index = curproc->inRAM[oldest];  // the index of the actual page
  move_forward_in_inRAM_queue(oldest);  //  oldest is the cell number in inRAM array (we need it for the 'move forward' function in order to know from where to start moving the line)
  return page_to_swap_index;
}

int select_for_LAPA(){
  struct proc* curproc = myproc();
  int oldest = 0xFFFFFFFF;
  int i;
  int index = -1;
  int least_ones = 33; // more than the count of the bits (uint- 32 bit), just to catch the first one and then compare between all the others
  for(i = 0; i<MAX_PYSC_PAGES; i++){
    int count = 0;
    int age = curproc->pages[curproc->inRAM[i]].age;
    /**now, we count the number of the '1' in the age:**/
    int j;
    for(j = 0; j<32; j++){
      if((1<<j) & (age))  // if there is '1' (xor-and)
        count++;
    }
    if(count < least_ones){
      least_ones = count;
      index = i;
      oldest = age;
    }
    else if(count == least_ones && age < oldest){  // maybe they have the same amount of '1's but this page is older..
      index = i;
      oldest = age;
    }
  }
  if(index == -1)  // weird case, but just to make sure
    panic("in LAPA: couldn't find any page!!");

  /**now, lets collect everything we got**/
  int page_to_swap_index = curproc->inRAM[index];
  move_forward_in_inRAM_queue(index);
  return page_to_swap_index;
}

int select_for_SCFIFO(){
  struct proc* curproc = myproc();
  int accessed_inRAM[MAX_PYSC_PAGES]; // save here all the pages in-ram that are 'accessed'
  int inRAM_index = 0;

  /**initialization**/
  int i;
  for(i = 0; i<MAX_PYSC_PAGES; i++)
    accessed_inRAM[i] = -1;

  int page_to_swap_index = -1;
  for(i = 0; (i<MAX_PYSC_PAGES) && (page_to_swap_index == -1); i++){
    pte_t *pte = (pte_t*)global_walkpgdir(curproc->pgdir, (char*) curproc->pages[curproc->inRAM[i]].virtual_addr, 0);  // the virtual address of a page that is in the RAM
    /**first, we check if the page was accessed**/
    if(*pte & PTE_AC){
      *pte = TURN_OFF_PTE_AC(*pte);
      accessed_inRAM[inRAM_index] = curproc->inRAM[i];  //  if it was accessed, add it to the array
      inRAM_index++;
    }
    else{ // page was not accessed
      page_to_swap_index = curproc->inRAM[i];  // we save that particular page and there is no reason to keep looking for another one
      break;
    }  
  } 
  if(page_to_swap_index == -1){  // if each one of them was accessed, we go back to the beginning. not the interesting part :/
    page_to_swap_index = curproc->inRAM[0];
    if(page_to_swap_index != -1) //we have the first page, now we can move all the others further in the queue
      move_forward_in_inRAM_queue(0);
    
    else // there isn't even one page in the ram!
      panic("in SCFIFO: no pages in ram queue!!");
    return page_to_swap_index;
  } 

  /** if we got here, it means we got a page from the ram that was not accessed**/
  /** here, we implement the 'clock' second chance fifo we learned in class- pretty much just reorginizing everything so that the 'arm' will now point at the next page**/
  i++;  //start from the next page in the queue
  int j = 0;
  while((i < MAX_PYSC_PAGES) && (curproc->inRAM[i] != -1)){
    curproc->inRAM[j] = curproc->inRAM[i];
    i++;
    j++;
  }
  int k = 0;
  while(j < MAX_PYSC_PAGES){
    curproc->inRAM[j] = accessed_inRAM[k];
    j++;
    k++;
  }
  return page_to_swap_index;
}

int select_for_AQ(){  // the most simple one- just tale the first in line
  struct proc* curproc = myproc();
  int page_to_swap_index = curproc->inRAM[0];
  move_forward_in_inRAM_queue(0);
  return page_to_swap_index;
}


void aging(){
  struct proc *curproc = myproc();
  int i;
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
    if(curproc->pages[i].allocated == 1){
      curproc->pages[i].age= curproc->pages[i].age >> 1; //right shift
      pte_t* pte = (pte_t*) global_walkpgdir(curproc->pgdir, (void*)curproc->pages[i].virtual_addr, 0);
      if(*pte & PTE_AC){    //if page was accessed
        uint new_age = curproc->pages[i].age | 0x80000000;//adds '1' to the left
        curproc->pages[i].age = new_age;
        *pte = TURN_OFF_PTE_AC(*pte); //  turn off the accessed bit
      }
    }
  }
}

void advance_for_AQ(){
  struct proc* curproc = myproc();
  int i;
  for( i = MAX_PYSC_PAGES-1; i < 0; i--){
    if(curproc->inRAM[i]!=-1){
      int curr = curproc->inRAM[i];
      int prev = curproc->inRAM[i-1];
      pte_t* curr_pte = (pte_t*) global_walkpgdir(curproc->pgdir,(void*) curproc->pages[curr].virtual_addr,0);
      pte_t* prev_pte = (pte_t*) global_walkpgdir(curproc->pgdir, (void*) curproc->pages[prev].virtual_addr,0);
      /**now, we compare each 2 following pages: if the further one was not accessed but the one before him was, we should swap their places!**/
      if(((*curr_pte & PTE_AC) == 0) && ((*prev_pte & PTE_AC) !=0)){
        curproc->inRAM[i] = prev;
        curproc->inRAM[i-1] = curr;
      }
    }
  }
}
///////////////////////////END/////////////////////////////////////