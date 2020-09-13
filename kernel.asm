
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 d5 10 80       	mov    $0x8010d5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 36 10 80       	mov    $0x80103690,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 d5 10 80       	mov    $0x8010d5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 87 10 80       	push   $0x801087c0
80100051:	68 c0 d5 10 80       	push   $0x8010d5c0
80100056:	e8 15 52 00 00       	call   80105270 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 1d 11 80 bc 	movl   $0x80111cbc,0x80111d0c
80100062:	1c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 1d 11 80 bc 	movl   $0x80111cbc,0x80111d10
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 1c 11 80       	mov    $0x80111cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 87 10 80       	push   $0x801087c7
80100097:	50                   	push   %eax
80100098:	e8 a3 50 00 00       	call   80105140 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 1d 11 80       	mov    0x80111d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 d5 10 80       	push   $0x8010d5c0
801000e4:	e8 c7 52 00 00       	call   801053b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 1d 11 80    	mov    0x80111d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 1d 11 80    	mov    0x80111d0c,%ebx
80100126:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 d5 10 80       	push   $0x8010d5c0
80100162:	e8 09 53 00 00       	call   80105470 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 50 00 00       	call   80105180 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 26 00 00       	call   80102790 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 87 10 80       	push   $0x801087ce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 6d 50 00 00       	call   80105220 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 c7 25 00 00       	jmp    80102790 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 87 10 80       	push   $0x801087df
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 2c 50 00 00       	call   80105220 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 4f 00 00       	call   801051e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
8010020b:	e8 a0 51 00 00       	call   801053b0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 1d 11 80       	mov    0x80111d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 1d 11 80       	mov    0x80111d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 d5 10 80 	movl   $0x8010d5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 0f 52 00 00       	jmp    80105470 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 87 10 80       	push   $0x801087e6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 bb 17 00 00       	call   80101a40 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 1f 51 00 00       	call   801053b0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 1f 11 80    	mov    0x80111fa0,%edx
801002a7:	39 15 a4 1f 11 80    	cmp    %edx,0x80111fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 a0 1f 11 80       	push   $0x80111fa0
801002c5:	e8 96 44 00 00       	call   80104760 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 1f 11 80    	mov    0x80111fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 1f 11 80    	cmp    0x80111fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 80 3d 00 00       	call   80104060 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 7c 51 00 00       	call   80105470 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 64 16 00 00       	call   80101960 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 1f 11 80       	mov    %eax,0x80111fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 1f 11 80 	movsbl -0x7feee0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 1e 51 00 00       	call   80105470 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 06 16 00 00       	call   80101960 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 1f 11 80    	mov    %edx,0x80111fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 72 2b 00 00       	call   80102f20 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 87 10 80       	push   $0x801087ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 1c 8e 10 80 	movl   $0x80108e1c,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 b3 4e 00 00       	call   80105290 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 88 10 80       	push   $0x80108801
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 41 6a 00 00       	call   80106e80 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 8f 69 00 00       	call   80106e80 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 83 69 00 00       	call   80106e80 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 77 69 00 00       	call   80106e80 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 47 50 00 00       	call   80105570 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 7a 4f 00 00       	call   801054c0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 88 10 80       	push   $0x80108805
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 88 10 80 	movzbl -0x7fef77d0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 2c 14 00 00       	call   80101a40 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 90 4d 00 00       	call   801053b0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 c5 10 80       	push   $0x8010c520
80100647:	e8 24 4e 00 00       	call   80105470 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 0b 13 00 00       	call   80101960 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 c5 10 80       	push   $0x8010c520
8010071f:	e8 4c 4d 00 00       	call   80105470 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 88 10 80       	mov    $0x80108818,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 bb 4b 00 00       	call   801053b0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 88 10 80       	push   $0x8010881f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 c5 10 80       	push   $0x8010c520
80100823:	e8 88 4b 00 00       	call   801053b0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100856:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 c5 10 80       	push   $0x8010c520
80100888:	e8 e3 4b 00 00       	call   80105470 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 1f 11 80    	sub    0x80111fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 1f 11 80    	mov    %edx,0x80111fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 1f 11 80    	mov    %cl,-0x7feee0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 1f 11 80       	mov    0x80111fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 1f 11 80    	cmp    %eax,0x80111fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 1f 11 80       	mov    %eax,0x80111fa4
          wakeup(&input.r);
80100911:	68 a0 1f 11 80       	push   $0x80111fa0
80100916:	e8 05 40 00 00       	call   80104920 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
8010093d:	39 05 a4 1f 11 80    	cmp    %eax,0x80111fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100964:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 1f 11 80 0a 	cmpb   $0xa,-0x7feee0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 84 40 00 00       	jmp    80104a20 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 1f 11 80 0a 	movb   $0xa,-0x7feee0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 88 10 80       	push   $0x80108828
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 9b 48 00 00       	call   80105270 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 29 11 80 00 	movl   $0x80100600,0x8011296c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 29 11 80 70 	movl   $0x80100270,0x80112968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 42 1f 00 00       	call   80102940 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <backup_and_reset_all>:
}



//////////////////////HELPER FUNCTION FOR ASS3/////////////////////////
void backup_and_reset_all(struct page* backup_pages, int* indexes_backup, int* in_RAM_backup, int* offset_arr_backup){
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	83 ec 1c             	sub    $0x1c,%esp
80100a19:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100a1c:	8b 75 14             	mov    0x14(%ebp),%esi
  struct proc* curproc = myproc();
80100a1f:	e8 3c 36 00 00       	call   80104060 <myproc>
80100a24:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100a27:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100a2d:	8d b8 80 03 00 00    	lea    0x380(%eax),%edi
80100a33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100a36:	8d 76 00             	lea    0x0(%esi),%esi
80100a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
    /**backup everything from 'pages' in curproc**/
    backup_pages[i].offset_in_swapfile = curproc->pages[i].offset_in_swapfile;
80100a40:	8b 42 04             	mov    0x4(%edx),%eax
80100a43:	83 c2 18             	add    $0x18,%edx
80100a46:	83 c1 18             	add    $0x18,%ecx
80100a49:	89 41 ec             	mov    %eax,-0x14(%ecx)
    backup_pages[i].in_RAM = curproc->pages[i].in_RAM;  
80100a4c:	8b 42 fc             	mov    -0x4(%edx),%eax
80100a4f:	89 41 fc             	mov    %eax,-0x4(%ecx)
    backup_pages[i].virtual_addr = curproc->pages[i].virtual_addr;
80100a52:	8b 42 e8             	mov    -0x18(%edx),%eax
80100a55:	89 41 e8             	mov    %eax,-0x18(%ecx)
    backup_pages[i].allocated = curproc->pages[i].allocated;
80100a58:	8b 42 f8             	mov    -0x8(%edx),%eax
80100a5b:	89 41 f8             	mov    %eax,-0x8(%ecx)

    /**  clean everything in 'pages' **/
    curproc->pages[i].virtual_addr = 0;
80100a5e:	c7 42 e8 00 00 00 00 	movl   $0x0,-0x18(%edx)
    curproc->pages[i].offset_in_swapfile = -1;
80100a65:	c7 42 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%edx)
    curproc->pages[i].in_RAM = 0;
80100a6c:	c7 42 fc 00 00 00 00 	movl   $0x0,-0x4(%edx)
    curproc->pages[i].allocated = 0;
80100a73:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
80100a7a:	39 fa                	cmp    %edi,%edx
80100a7c:	75 c2                	jne    80100a40 <backup_and_reset_all+0x30>
80100a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
    for (i = 0; i < MAX_PYSC_PAGES; ++i) {
80100a81:	31 d2                	xor    %edx,%edx
80100a83:	90                   	nop
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    /**  backup pages array (in_RAM) **/
      in_RAM_backup[i] = curproc->inRAM[i];
80100a88:	8b 8c 90 80 03 00 00 	mov    0x380(%eax,%edx,4),%ecx
80100a8f:	89 0c 93             	mov    %ecx,(%ebx,%edx,4)
      offset_arr_backup[i] = curproc->free_swapfile_offsets[i];
80100a92:	8b 8c 90 c0 03 00 00 	mov    0x3c0(%eax,%edx,4),%ecx
80100a99:	89 0c 96             	mov    %ecx,(%esi,%edx,4)
    
      /**  clear 'pages' **/
      curproc->inRAM[i] = -1;
80100a9c:	c7 84 90 80 03 00 00 	movl   $0xffffffff,0x380(%eax,%edx,4)
80100aa3:	ff ff ff ff 
      curproc->free_swapfile_offsets[i] = -1;
80100aa7:	c7 84 90 c0 03 00 00 	movl   $0xffffffff,0x3c0(%eax,%edx,4)
80100aae:	ff ff ff ff 
    for (i = 0; i < MAX_PYSC_PAGES; ++i) {
80100ab2:	83 c2 01             	add    $0x1,%edx
80100ab5:	83 fa 10             	cmp    $0x10,%edx
80100ab8:	75 ce                	jne    80100a88 <backup_and_reset_all+0x78>
  }



    /**  'index' is like this special array to save special fields from curproc. we could've not use it but the signature of the function would have been much longer **/
  indexes_backup[0] = curproc->free_swapfile_offset;
80100aba:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
80100ac0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100ac3:	89 13                	mov    %edx,(%ebx)
  indexes_backup[1] = curproc->swapped_pages_now;
80100ac5:	8b 90 0c 04 00 00    	mov    0x40c(%eax),%edx
80100acb:	89 53 04             	mov    %edx,0x4(%ebx)
  indexes_backup[2] = curproc->page_faults_now;
80100ace:	8b 90 08 04 00 00    	mov    0x408(%eax),%edx
80100ad4:	89 53 08             	mov    %edx,0x8(%ebx)
  indexes_backup[3] = curproc->total_swaps;
80100ad7:	8b 90 10 04 00 00    	mov    0x410(%eax),%edx
80100add:	89 53 0c             	mov    %edx,0xc(%ebx)
  indexes_backup[4] = curproc->total_allocated_pages;
80100ae0:	8b 90 04 04 00 00    	mov    0x404(%eax),%edx
80100ae6:	89 53 10             	mov    %edx,0x10(%ebx)

    /**  now clear everything **/
  curproc->free_swapfile_offset = 0;
80100ae9:	c7 80 00 04 00 00 00 	movl   $0x0,0x400(%eax)
80100af0:	00 00 00 
  curproc->swapped_pages_now = 0;
80100af3:	c7 80 0c 04 00 00 00 	movl   $0x0,0x40c(%eax)
80100afa:	00 00 00 
  curproc->page_faults_now = 0;
80100afd:	c7 80 08 04 00 00 00 	movl   $0x0,0x408(%eax)
80100b04:	00 00 00 
  curproc->total_swaps = 0;
80100b07:	c7 80 10 04 00 00 00 	movl   $0x0,0x410(%eax)
80100b0e:	00 00 00 
  curproc->total_allocated_pages = 0;
80100b11:	c7 80 04 04 00 00 00 	movl   $0x0,0x404(%eax)
80100b18:	00 00 00 

  

}
80100b1b:	83 c4 1c             	add    $0x1c,%esp
80100b1e:	5b                   	pop    %ebx
80100b1f:	5e                   	pop    %esi
80100b20:	5f                   	pop    %edi
80100b21:	5d                   	pop    %ebp
80100b22:	c3                   	ret    
80100b23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100b30 <restore>:

void
restore(struct page* backup_pages, int* indexes_backup, int* in_RAM_backup, int* offset_arr_backup)
{ //this function is calles only if exec has failed. if that happend, we need to restore everything we backed up
80100b30:	55                   	push   %ebp
80100b31:	89 e5                	mov    %esp,%ebp
80100b33:	57                   	push   %edi
80100b34:	56                   	push   %esi
80100b35:	53                   	push   %ebx
80100b36:	83 ec 1c             	sub    $0x1c,%esp
80100b39:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100b3c:	8b 75 14             	mov    0x14(%ebp),%esi
  struct proc *curproc = myproc();
80100b3f:	e8 1c 35 00 00       	call   80104060 <myproc>
80100b44:	8b 55 08             	mov    0x8(%ebp),%edx
80100b47:	8d 88 80 00 00 00    	lea    0x80(%eax),%ecx
80100b4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b50:	8d ba 00 03 00 00    	lea    0x300(%edx),%edi
80100b56:	8d 76 00             	lea    0x0(%esi),%esi
80100b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;
  for (i = 0; i < MAX_TOTAL_PAGES; ++i) {
    /**  restore everything in 'pages' **/
    curproc->pages[i].virtual_addr = backup_pages[i].virtual_addr;
80100b60:	8b 02                	mov    (%edx),%eax
80100b62:	83 c2 18             	add    $0x18,%edx
80100b65:	83 c1 18             	add    $0x18,%ecx
80100b68:	89 41 e8             	mov    %eax,-0x18(%ecx)
    curproc->pages[i].offset_in_swapfile = backup_pages[i].offset_in_swapfile;
80100b6b:	8b 42 ec             	mov    -0x14(%edx),%eax
80100b6e:	89 41 ec             	mov    %eax,-0x14(%ecx)
    curproc->pages[i].in_RAM = backup_pages[i].in_RAM;
80100b71:	8b 42 fc             	mov    -0x4(%edx),%eax
80100b74:	89 41 fc             	mov    %eax,-0x4(%ecx)
    curproc->pages[i].allocated = backup_pages[i].allocated;
80100b77:	8b 42 f8             	mov    -0x8(%edx),%eax
80100b7a:	89 41 f8             	mov    %eax,-0x8(%ecx)
  for (i = 0; i < MAX_TOTAL_PAGES; ++i) {
80100b7d:	39 fa                	cmp    %edi,%edx
80100b7f:	75 df                	jne    80100b60 <restore+0x30>
80100b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }

  for (i = 0 ; i < MAX_PYSC_PAGES; ++i) {
80100b84:	31 d2                	xor    %edx,%edx
80100b86:	8d 76 00             	lea    0x0(%esi),%esi
80100b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    curproc->inRAM[i] = in_RAM_backup[i];
80100b90:	8b 0c 93             	mov    (%ebx,%edx,4),%ecx
80100b93:	89 8c 90 80 03 00 00 	mov    %ecx,0x380(%eax,%edx,4)
    curproc->free_swapfile_offsets[i] = offset_arr_backup[i];
80100b9a:	8b 0c 96             	mov    (%esi,%edx,4),%ecx
80100b9d:	89 8c 90 c0 03 00 00 	mov    %ecx,0x3c0(%eax,%edx,4)
  for (i = 0 ; i < MAX_PYSC_PAGES; ++i) {
80100ba4:	83 c2 01             	add    $0x1,%edx
80100ba7:	83 fa 10             	cmp    $0x10,%edx
80100baa:	75 e4                	jne    80100b90 <restore+0x60>
  }


  /**  restore the special indexes we wrote about **/
  curproc->free_swapfile_offset = indexes_backup[0] ;
80100bac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100baf:	8b 13                	mov    (%ebx),%edx
80100bb1:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
  curproc->swapped_pages_now = indexes_backup[1];
80100bb7:	8b 53 04             	mov    0x4(%ebx),%edx
80100bba:	89 90 0c 04 00 00    	mov    %edx,0x40c(%eax)
  curproc->page_faults_now = indexes_backup[2];
80100bc0:	8b 53 08             	mov    0x8(%ebx),%edx
80100bc3:	89 90 08 04 00 00    	mov    %edx,0x408(%eax)
  curproc->total_swaps = indexes_backup[3];
80100bc9:	8b 53 0c             	mov    0xc(%ebx),%edx
80100bcc:	89 90 10 04 00 00    	mov    %edx,0x410(%eax)
  curproc->total_allocated_pages = indexes_backup[4];
80100bd2:	8b 53 10             	mov    0x10(%ebx),%edx
80100bd5:	89 90 04 04 00 00    	mov    %edx,0x404(%eax)
80100bdb:	83 c4 1c             	add    $0x1c,%esp
80100bde:	5b                   	pop    %ebx
80100bdf:	5e                   	pop    %esi
80100be0:	5f                   	pop    %edi
80100be1:	5d                   	pop    %ebp
80100be2:	c3                   	ret    
80100be3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100bf0 <exec>:
{
80100bf0:	55                   	push   %ebp
80100bf1:	89 e5                	mov    %esp,%ebp
80100bf3:	57                   	push   %edi
80100bf4:	56                   	push   %esi
80100bf5:	53                   	push   %ebx
80100bf6:	81 ec ac 04 00 00    	sub    $0x4ac,%esp
  struct proc *curproc = myproc();
80100bfc:	e8 5f 34 00 00       	call   80104060 <myproc>
80100c01:	89 85 5c fb ff ff    	mov    %eax,-0x4a4(%ebp)
  begin_op();
80100c07:	e8 84 27 00 00       	call   80103390 <begin_op>
  if((ip = namei(path)) == 0){
80100c0c:	83 ec 0c             	sub    $0xc,%esp
80100c0f:	ff 75 08             	pushl  0x8(%ebp)
80100c12:	e8 a9 15 00 00       	call   801021c0 <namei>
80100c17:	83 c4 10             	add    $0x10,%esp
80100c1a:	85 c0                	test   %eax,%eax
80100c1c:	0f 84 4b 02 00 00    	je     80100e6d <exec+0x27d>
  ilock(ip);
80100c22:	83 ec 0c             	sub    $0xc,%esp
80100c25:	89 c3                	mov    %eax,%ebx
    backup_and_reset_all(pages_backup, indexes_backup, ram_queue_backup, offsets_queue_backup);
80100c27:	8d b5 70 fb ff ff    	lea    -0x490(%ebp),%esi
  ilock(ip);
80100c2d:	50                   	push   %eax
    backup_and_reset_all(pages_backup, indexes_backup, ram_queue_backup, offsets_queue_backup);
80100c2e:	8d bd e8 fc ff ff    	lea    -0x318(%ebp),%edi
  ilock(ip);
80100c34:	e8 27 0d 00 00       	call   80101960 <ilock>
    backup_and_reset_all(pages_backup, indexes_backup, ram_queue_backup, offsets_queue_backup);
80100c39:	8d 85 18 fc ff ff    	lea    -0x3e8(%ebp),%eax
80100c3f:	50                   	push   %eax
80100c40:	8d 85 d8 fb ff ff    	lea    -0x428(%ebp),%eax
80100c46:	50                   	push   %eax
80100c47:	56                   	push   %esi
80100c48:	57                   	push   %edi
80100c49:	e8 c2 fd ff ff       	call   80100a10 <backup_and_reset_all>
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c4e:	8d 85 a4 fb ff ff    	lea    -0x45c(%ebp),%eax
80100c54:	83 c4 20             	add    $0x20,%esp
80100c57:	6a 34                	push   $0x34
80100c59:	6a 00                	push   $0x0
80100c5b:	50                   	push   %eax
80100c5c:	53                   	push   %ebx
80100c5d:	e8 de 0f 00 00       	call   80101c40 <readi>
80100c62:	83 c4 10             	add    $0x10,%esp
80100c65:	83 f8 34             	cmp    $0x34,%eax
80100c68:	75 0c                	jne    80100c76 <exec+0x86>
  if(elf.magic != ELF_MAGIC)
80100c6a:	81 bd a4 fb ff ff 7f 	cmpl   $0x464c457f,-0x45c(%ebp)
80100c71:	45 4c 46 
80100c74:	74 3a                	je     80100cb0 <exec+0xc0>
    restore(pages_backup, indexes_backup, ram_queue_backup, offsets_queue_backup);
80100c76:	8d 85 18 fc ff ff    	lea    -0x3e8(%ebp),%eax
80100c7c:	50                   	push   %eax
80100c7d:	8d 85 d8 fb ff ff    	lea    -0x428(%ebp),%eax
80100c83:	50                   	push   %eax
80100c84:	56                   	push   %esi
80100c85:	57                   	push   %edi
80100c86:	e8 a5 fe ff ff       	call   80100b30 <restore>
80100c8b:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c8e:	83 ec 0c             	sub    $0xc,%esp
80100c91:	53                   	push   %ebx
80100c92:	e8 59 0f 00 00       	call   80101bf0 <iunlockput>
    end_op();
80100c97:	e8 64 27 00 00       	call   80103400 <end_op>
80100c9c:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ca7:	5b                   	pop    %ebx
80100ca8:	5e                   	pop    %esi
80100ca9:	5f                   	pop    %edi
80100caa:	5d                   	pop    %ebp
80100cab:	c3                   	ret    
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((pgdir = setupkvm()) == 0)
80100cb0:	e8 4b 72 00 00       	call   80107f00 <setupkvm>
80100cb5:	85 c0                	test   %eax,%eax
80100cb7:	89 85 60 fb ff ff    	mov    %eax,-0x4a0(%ebp)
80100cbd:	74 b7                	je     80100c76 <exec+0x86>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cbf:	66 83 bd d0 fb ff ff 	cmpw   $0x0,-0x430(%ebp)
80100cc6:	00 
80100cc7:	8b 85 c0 fb ff ff    	mov    -0x440(%ebp),%eax
80100ccd:	89 85 58 fb ff ff    	mov    %eax,-0x4a8(%ebp)
80100cd3:	0f 84 47 03 00 00    	je     80101020 <exec+0x430>
80100cd9:	31 c0                	xor    %eax,%eax
80100cdb:	89 9d 64 fb ff ff    	mov    %ebx,-0x49c(%ebp)
  sz = 0;
80100ce1:	c7 85 54 fb ff ff 00 	movl   $0x0,-0x4ac(%ebp)
80100ce8:	00 00 00 
80100ceb:	89 c3                	mov    %eax,%ebx
80100ced:	e9 92 00 00 00       	jmp    80100d84 <exec+0x194>
80100cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ph.type != ELF_PROG_LOAD)
80100cf8:	83 bd 84 fb ff ff 01 	cmpl   $0x1,-0x47c(%ebp)
80100cff:	75 75                	jne    80100d76 <exec+0x186>
    if(ph.memsz < ph.filesz)
80100d01:	8b 85 98 fb ff ff    	mov    -0x468(%ebp),%eax
80100d07:	3b 85 94 fb ff ff    	cmp    -0x46c(%ebp),%eax
80100d0d:	0f 82 9d 00 00 00    	jb     80100db0 <exec+0x1c0>
80100d13:	03 85 8c fb ff ff    	add    -0x474(%ebp),%eax
80100d19:	0f 82 91 00 00 00    	jb     80100db0 <exec+0x1c0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d1f:	83 ec 04             	sub    $0x4,%esp
80100d22:	50                   	push   %eax
80100d23:	ff b5 54 fb ff ff    	pushl  -0x4ac(%ebp)
80100d29:	ff b5 60 fb ff ff    	pushl  -0x4a0(%ebp)
80100d2f:	e8 7c 75 00 00       	call   801082b0 <allocuvm>
80100d34:	83 c4 10             	add    $0x10,%esp
80100d37:	85 c0                	test   %eax,%eax
80100d39:	89 85 54 fb ff ff    	mov    %eax,-0x4ac(%ebp)
80100d3f:	74 6f                	je     80100db0 <exec+0x1c0>
    if(ph.vaddr % PGSIZE != 0)
80100d41:	8b 85 8c fb ff ff    	mov    -0x474(%ebp),%eax
80100d47:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d4c:	75 62                	jne    80100db0 <exec+0x1c0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d4e:	83 ec 0c             	sub    $0xc,%esp
80100d51:	ff b5 94 fb ff ff    	pushl  -0x46c(%ebp)
80100d57:	ff b5 88 fb ff ff    	pushl  -0x478(%ebp)
80100d5d:	ff b5 64 fb ff ff    	pushl  -0x49c(%ebp)
80100d63:	50                   	push   %eax
80100d64:	ff b5 60 fb ff ff    	pushl  -0x4a0(%ebp)
80100d6a:	e8 21 6f 00 00       	call   80107c90 <loaduvm>
80100d6f:	83 c4 20             	add    $0x20,%esp
80100d72:	85 c0                	test   %eax,%eax
80100d74:	78 3a                	js     80100db0 <exec+0x1c0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d76:	0f b7 85 d0 fb ff ff 	movzwl -0x430(%ebp),%eax
80100d7d:	83 c3 01             	add    $0x1,%ebx
80100d80:	39 d8                	cmp    %ebx,%eax
80100d82:	7e 5c                	jle    80100de0 <exec+0x1f0>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d84:	89 d8                	mov    %ebx,%eax
80100d86:	6a 20                	push   $0x20
80100d88:	c1 e0 05             	shl    $0x5,%eax
80100d8b:	03 85 58 fb ff ff    	add    -0x4a8(%ebp),%eax
80100d91:	50                   	push   %eax
80100d92:	8d 85 84 fb ff ff    	lea    -0x47c(%ebp),%eax
80100d98:	50                   	push   %eax
80100d99:	ff b5 64 fb ff ff    	pushl  -0x49c(%ebp)
80100d9f:	e8 9c 0e 00 00       	call   80101c40 <readi>
80100da4:	83 c4 10             	add    $0x10,%esp
80100da7:	83 f8 20             	cmp    $0x20,%eax
80100daa:	0f 84 48 ff ff ff    	je     80100cf8 <exec+0x108>
    restore(pages_backup, indexes_backup, ram_queue_backup, offsets_queue_backup);
80100db0:	8d 85 18 fc ff ff    	lea    -0x3e8(%ebp),%eax
80100db6:	8b 9d 64 fb ff ff    	mov    -0x49c(%ebp),%ebx
80100dbc:	50                   	push   %eax
80100dbd:	8d 85 d8 fb ff ff    	lea    -0x428(%ebp),%eax
80100dc3:	50                   	push   %eax
80100dc4:	56                   	push   %esi
80100dc5:	57                   	push   %edi
80100dc6:	e8 65 fd ff ff       	call   80100b30 <restore>
    freevm(pgdir);
80100dcb:	58                   	pop    %eax
80100dcc:	ff b5 60 fb ff ff    	pushl  -0x4a0(%ebp)
80100dd2:	e8 a9 70 00 00       	call   80107e80 <freevm>
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	e9 af fe ff ff       	jmp    80100c8e <exec+0x9e>
80100ddf:	90                   	nop
80100de0:	8b 85 54 fb ff ff    	mov    -0x4ac(%ebp),%eax
80100de6:	8b 9d 64 fb ff ff    	mov    -0x49c(%ebp),%ebx
80100dec:	05 ff 0f 00 00       	add    $0xfff,%eax
80100df1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100df6:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
  iunlockput(ip);
80100dfc:	83 ec 0c             	sub    $0xc,%esp
80100dff:	89 85 58 fb ff ff    	mov    %eax,-0x4a8(%ebp)
80100e05:	89 95 64 fb ff ff    	mov    %edx,-0x49c(%ebp)
80100e0b:	53                   	push   %ebx
80100e0c:	e8 df 0d 00 00       	call   80101bf0 <iunlockput>
  end_op();
80100e11:	e8 ea 25 00 00       	call   80103400 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e16:	8b 95 64 fb ff ff    	mov    -0x49c(%ebp),%edx
80100e1c:	8b 85 58 fb ff ff    	mov    -0x4a8(%ebp),%eax
80100e22:	83 c4 0c             	add    $0xc,%esp
80100e25:	52                   	push   %edx
80100e26:	50                   	push   %eax
80100e27:	ff b5 60 fb ff ff    	pushl  -0x4a0(%ebp)
80100e2d:	e8 7e 74 00 00       	call   801082b0 <allocuvm>
80100e32:	83 c4 10             	add    $0x10,%esp
80100e35:	85 c0                	test   %eax,%eax
80100e37:	89 85 58 fb ff ff    	mov    %eax,-0x4a8(%ebp)
80100e3d:	75 4d                	jne    80100e8c <exec+0x29c>
    restore(pages_backup, indexes_backup, ram_queue_backup, offsets_queue_backup);
80100e3f:	8d 85 18 fc ff ff    	lea    -0x3e8(%ebp),%eax
80100e45:	50                   	push   %eax
80100e46:	8d 85 d8 fb ff ff    	lea    -0x428(%ebp),%eax
80100e4c:	50                   	push   %eax
80100e4d:	56                   	push   %esi
80100e4e:	57                   	push   %edi
80100e4f:	e8 dc fc ff ff       	call   80100b30 <restore>
    freevm(pgdir);
80100e54:	5a                   	pop    %edx
80100e55:	ff b5 60 fb ff ff    	pushl  -0x4a0(%ebp)
80100e5b:	e8 20 70 00 00       	call   80107e80 <freevm>
80100e60:	83 c4 10             	add    $0x10,%esp
  return -1;
80100e63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e68:	e9 37 fe ff ff       	jmp    80100ca4 <exec+0xb4>
    end_op();
80100e6d:	e8 8e 25 00 00       	call   80103400 <end_op>
    cprintf("exec: fail\n");
80100e72:	83 ec 0c             	sub    $0xc,%esp
80100e75:	68 41 88 10 80       	push   $0x80108841
80100e7a:	e8 e1 f7 ff ff       	call   80100660 <cprintf>
    return -1;
80100e7f:	83 c4 10             	add    $0x10,%esp
80100e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e87:	e9 18 fe ff ff       	jmp    80100ca4 <exec+0xb4>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e8c:	89 c3                	mov    %eax,%ebx
80100e8e:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100e94:	83 ec 08             	sub    $0x8,%esp
80100e97:	50                   	push   %eax
80100e98:	ff b5 60 fb ff ff    	pushl  -0x4a0(%ebp)
80100e9e:	e8 fd 70 00 00       	call   80107fa0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	31 c9                	xor    %ecx,%ecx
80100eab:	8b 00                	mov    (%eax),%eax
80100ead:	85 c0                	test   %eax,%eax
80100eaf:	75 18                	jne    80100ec9 <exec+0x2d9>
80100eb1:	e9 76 01 00 00       	jmp    8010102c <exec+0x43c>
80100eb6:	8d 76 00             	lea    0x0(%esi),%esi
80100eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100ec0:	83 f9 20             	cmp    $0x20,%ecx
80100ec3:	0f 84 76 ff ff ff    	je     80100e3f <exec+0x24f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ec9:	83 ec 0c             	sub    $0xc,%esp
80100ecc:	89 8d 64 fb ff ff    	mov    %ecx,-0x49c(%ebp)
80100ed2:	50                   	push   %eax
80100ed3:	e8 08 48 00 00       	call   801056e0 <strlen>
80100ed8:	f7 d0                	not    %eax
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100eda:	59                   	pop    %ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100edb:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100edd:	8b 8d 64 fb ff ff    	mov    -0x49c(%ebp),%ecx
80100ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ee6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ee9:	ff 34 88             	pushl  (%eax,%ecx,4)
80100eec:	e8 ef 47 00 00       	call   801056e0 <strlen>
80100ef1:	83 c0 01             	add    $0x1,%eax
80100ef4:	8b 8d 64 fb ff ff    	mov    -0x49c(%ebp),%ecx
80100efa:	50                   	push   %eax
80100efb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100efe:	ff 34 88             	pushl  (%eax,%ecx,4)
80100f01:	53                   	push   %ebx
80100f02:	ff b5 60 fb ff ff    	pushl  -0x4a0(%ebp)
80100f08:	e8 03 72 00 00       	call   80108110 <copyout>
80100f0d:	83 c4 20             	add    $0x20,%esp
80100f10:	85 c0                	test   %eax,%eax
80100f12:	0f 88 27 ff ff ff    	js     80100e3f <exec+0x24f>
    ustack[3+argc] = sp;
80100f18:	8b 8d 64 fb ff ff    	mov    -0x49c(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100f21:	8d 95 58 fc ff ff    	lea    -0x3a8(%ebp),%edx
80100f27:	89 9c 8d 64 fc ff ff 	mov    %ebx,-0x39c(%ebp,%ecx,4)
  for(argc = 0; argv[argc]; argc++) {
80100f2e:	83 c1 01             	add    $0x1,%ecx
80100f31:	8b 04 88             	mov    (%eax,%ecx,4),%eax
80100f34:	85 c0                	test   %eax,%eax
80100f36:	75 88                	jne    80100ec0 <exec+0x2d0>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f38:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
  ustack[3+argc] = 0;
80100f3f:	c7 84 8d 64 fc ff ff 	movl   $0x0,-0x39c(%ebp,%ecx,4)
80100f46:	00 00 00 00 
  ustack[1] = argc;
80100f4a:	89 8d 5c fc ff ff    	mov    %ecx,-0x3a4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f50:	89 d9                	mov    %ebx,%ecx
  ustack[0] = 0xffffffff;  // fake return PC
80100f52:	c7 85 58 fc ff ff ff 	movl   $0xffffffff,-0x3a8(%ebp)
80100f59:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f5c:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100f5e:	83 c0 0c             	add    $0xc,%eax
80100f61:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f63:	50                   	push   %eax
80100f64:	52                   	push   %edx
80100f65:	53                   	push   %ebx
80100f66:	ff b5 60 fb ff ff    	pushl  -0x4a0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f6c:	89 8d 60 fc ff ff    	mov    %ecx,-0x3a0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f72:	e8 99 71 00 00       	call   80108110 <copyout>
80100f77:	83 c4 10             	add    $0x10,%esp
80100f7a:	85 c0                	test   %eax,%eax
80100f7c:	0f 88 bd fe ff ff    	js     80100e3f <exec+0x24f>
  for(last=s=path; *s; s++)
80100f82:	8b 45 08             	mov    0x8(%ebp),%eax
80100f85:	8b 55 08             	mov    0x8(%ebp),%edx
80100f88:	0f b6 00             	movzbl (%eax),%eax
80100f8b:	84 c0                	test   %al,%al
80100f8d:	74 11                	je     80100fa0 <exec+0x3b0>
80100f8f:	89 d1                	mov    %edx,%ecx
80100f91:	83 c1 01             	add    $0x1,%ecx
80100f94:	3c 2f                	cmp    $0x2f,%al
80100f96:	0f b6 01             	movzbl (%ecx),%eax
80100f99:	0f 44 d1             	cmove  %ecx,%edx
80100f9c:	84 c0                	test   %al,%al
80100f9e:	75 f1                	jne    80100f91 <exec+0x3a1>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100fa0:	8b bd 5c fb ff ff    	mov    -0x4a4(%ebp),%edi
80100fa6:	83 ec 04             	sub    $0x4,%esp
80100fa9:	6a 10                	push   $0x10
80100fab:	52                   	push   %edx
80100fac:	89 f8                	mov    %edi,%eax
80100fae:	83 c0 6c             	add    $0x6c,%eax
80100fb1:	50                   	push   %eax
80100fb2:	e8 e9 46 00 00       	call   801056a0 <safestrcpy>
  curproc->pgdir = pgdir;
80100fb7:	8b 8d 60 fb ff ff    	mov    -0x4a0(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100fbd:	8b 77 04             	mov    0x4(%edi),%esi
    if(curproc->pid > 2){
80100fc0:	83 c4 10             	add    $0x10,%esp
  curproc->tf->eip = elf.entry;  // main
80100fc3:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100fc6:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100fc9:	8b 8d 58 fb ff ff    	mov    -0x4a8(%ebp),%ecx
80100fcf:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100fd1:	8b 95 bc fb ff ff    	mov    -0x444(%ebp),%edx
80100fd7:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100fda:	8b 47 18             	mov    0x18(%edi),%eax
80100fdd:	89 58 44             	mov    %ebx,0x44(%eax)
    if(curproc->pid > 2){
80100fe0:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100fe4:	7e 1a                	jle    80101000 <exec+0x410>
      removeSwapFile(curproc);
80100fe6:	8b bd 5c fb ff ff    	mov    -0x4a4(%ebp),%edi
80100fec:	83 ec 0c             	sub    $0xc,%esp
80100fef:	57                   	push   %edi
80100ff0:	e8 9b 12 00 00       	call   80102290 <removeSwapFile>
      createSwapFile(curproc);
80100ff5:	89 3c 24             	mov    %edi,(%esp)
80100ff8:	e8 93 14 00 00       	call   80102490 <createSwapFile>
80100ffd:	83 c4 10             	add    $0x10,%esp
  switchuvm(curproc);
80101000:	83 ec 0c             	sub    $0xc,%esp
80101003:	ff b5 5c fb ff ff    	pushl  -0x4a4(%ebp)
80101009:	e8 f2 6a 00 00       	call   80107b00 <switchuvm>
  freevm(oldpgdir);
8010100e:	89 34 24             	mov    %esi,(%esp)
80101011:	e8 6a 6e 00 00       	call   80107e80 <freevm>
  return 0;
80101016:	83 c4 10             	add    $0x10,%esp
80101019:	31 c0                	xor    %eax,%eax
8010101b:	e9 84 fc ff ff       	jmp    80100ca4 <exec+0xb4>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101020:	31 c0                	xor    %eax,%eax
80101022:	ba 00 20 00 00       	mov    $0x2000,%edx
80101027:	e9 d0 fd ff ff       	jmp    80100dfc <exec+0x20c>
  for(argc = 0; argv[argc]; argc++) {
8010102c:	8b 9d 58 fb ff ff    	mov    -0x4a8(%ebp),%ebx
80101032:	8d 95 58 fc ff ff    	lea    -0x3a8(%ebp),%edx
80101038:	e9 fb fe ff ff       	jmp    80100f38 <exec+0x348>
8010103d:	66 90                	xchg   %ax,%ax
8010103f:	90                   	nop

80101040 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101046:	68 4d 88 10 80       	push   $0x8010884d
8010104b:	68 c0 1f 11 80       	push   $0x80111fc0
80101050:	e8 1b 42 00 00       	call   80105270 <initlock>
}
80101055:	83 c4 10             	add    $0x10,%esp
80101058:	c9                   	leave  
80101059:	c3                   	ret    
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101060 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101064:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
{
80101069:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010106c:	68 c0 1f 11 80       	push   $0x80111fc0
80101071:	e8 3a 43 00 00       	call   801053b0 <acquire>
80101076:	83 c4 10             	add    $0x10,%esp
80101079:	eb 10                	jmp    8010108b <filealloc+0x2b>
8010107b:	90                   	nop
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101080:	83 c3 18             	add    $0x18,%ebx
80101083:	81 fb 54 29 11 80    	cmp    $0x80112954,%ebx
80101089:	73 25                	jae    801010b0 <filealloc+0x50>
    if(f->ref == 0){
8010108b:	8b 43 04             	mov    0x4(%ebx),%eax
8010108e:	85 c0                	test   %eax,%eax
80101090:	75 ee                	jne    80101080 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101092:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101095:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010109c:	68 c0 1f 11 80       	push   $0x80111fc0
801010a1:	e8 ca 43 00 00       	call   80105470 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801010a6:	89 d8                	mov    %ebx,%eax
      return f;
801010a8:	83 c4 10             	add    $0x10,%esp
}
801010ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010ae:	c9                   	leave  
801010af:	c3                   	ret    
  release(&ftable.lock);
801010b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801010b3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801010b5:	68 c0 1f 11 80       	push   $0x80111fc0
801010ba:	e8 b1 43 00 00       	call   80105470 <release>
}
801010bf:	89 d8                	mov    %ebx,%eax
  return 0;
801010c1:	83 c4 10             	add    $0x10,%esp
}
801010c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010c7:	c9                   	leave  
801010c8:	c3                   	ret    
801010c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	53                   	push   %ebx
801010d4:	83 ec 10             	sub    $0x10,%esp
801010d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801010da:	68 c0 1f 11 80       	push   $0x80111fc0
801010df:	e8 cc 42 00 00       	call   801053b0 <acquire>
  if(f->ref < 1)
801010e4:	8b 43 04             	mov    0x4(%ebx),%eax
801010e7:	83 c4 10             	add    $0x10,%esp
801010ea:	85 c0                	test   %eax,%eax
801010ec:	7e 1a                	jle    80101108 <filedup+0x38>
    panic("filedup");
  f->ref++;
801010ee:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801010f1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801010f4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801010f7:	68 c0 1f 11 80       	push   $0x80111fc0
801010fc:	e8 6f 43 00 00       	call   80105470 <release>
  return f;
}
80101101:	89 d8                	mov    %ebx,%eax
80101103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101106:	c9                   	leave  
80101107:	c3                   	ret    
    panic("filedup");
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	68 54 88 10 80       	push   $0x80108854
80101110:	e8 7b f2 ff ff       	call   80100390 <panic>
80101115:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101120 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 28             	sub    $0x28,%esp
80101129:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010112c:	68 c0 1f 11 80       	push   $0x80111fc0
80101131:	e8 7a 42 00 00       	call   801053b0 <acquire>
  if(f->ref < 1)
80101136:	8b 43 04             	mov    0x4(%ebx),%eax
80101139:	83 c4 10             	add    $0x10,%esp
8010113c:	85 c0                	test   %eax,%eax
8010113e:	0f 8e 9b 00 00 00    	jle    801011df <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101144:	83 e8 01             	sub    $0x1,%eax
80101147:	85 c0                	test   %eax,%eax
80101149:	89 43 04             	mov    %eax,0x4(%ebx)
8010114c:	74 1a                	je     80101168 <fileclose+0x48>
    release(&ftable.lock);
8010114e:	c7 45 08 c0 1f 11 80 	movl   $0x80111fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101155:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101158:	5b                   	pop    %ebx
80101159:	5e                   	pop    %esi
8010115a:	5f                   	pop    %edi
8010115b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010115c:	e9 0f 43 00 00       	jmp    80105470 <release>
80101161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101168:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010116c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010116e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101171:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101174:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010117a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010117d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101180:	68 c0 1f 11 80       	push   $0x80111fc0
  ff = *f;
80101185:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101188:	e8 e3 42 00 00       	call   80105470 <release>
  if(ff.type == FD_PIPE)
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	83 ff 01             	cmp    $0x1,%edi
80101193:	74 13                	je     801011a8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101195:	83 ff 02             	cmp    $0x2,%edi
80101198:	74 26                	je     801011c0 <fileclose+0xa0>
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
801011a1:	c3                   	ret    
801011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
801011a8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801011ac:	83 ec 08             	sub    $0x8,%esp
801011af:	53                   	push   %ebx
801011b0:	56                   	push   %esi
801011b1:	e8 8a 29 00 00       	call   80103b40 <pipeclose>
801011b6:	83 c4 10             	add    $0x10,%esp
801011b9:	eb df                	jmp    8010119a <fileclose+0x7a>
801011bb:	90                   	nop
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
801011c0:	e8 cb 21 00 00       	call   80103390 <begin_op>
    iput(ff.ip);
801011c5:	83 ec 0c             	sub    $0xc,%esp
801011c8:	ff 75 e0             	pushl  -0x20(%ebp)
801011cb:	e8 c0 08 00 00       	call   80101a90 <iput>
    end_op();
801011d0:	83 c4 10             	add    $0x10,%esp
}
801011d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d6:	5b                   	pop    %ebx
801011d7:	5e                   	pop    %esi
801011d8:	5f                   	pop    %edi
801011d9:	5d                   	pop    %ebp
    end_op();
801011da:	e9 21 22 00 00       	jmp    80103400 <end_op>
    panic("fileclose");
801011df:	83 ec 0c             	sub    $0xc,%esp
801011e2:	68 5c 88 10 80       	push   $0x8010885c
801011e7:	e8 a4 f1 ff ff       	call   80100390 <panic>
801011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	53                   	push   %ebx
801011f4:	83 ec 04             	sub    $0x4,%esp
801011f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801011fa:	83 3b 02             	cmpl   $0x2,(%ebx)
801011fd:	75 31                	jne    80101230 <filestat+0x40>
    ilock(f->ip);
801011ff:	83 ec 0c             	sub    $0xc,%esp
80101202:	ff 73 10             	pushl  0x10(%ebx)
80101205:	e8 56 07 00 00       	call   80101960 <ilock>
    stati(f->ip, st);
8010120a:	58                   	pop    %eax
8010120b:	5a                   	pop    %edx
8010120c:	ff 75 0c             	pushl  0xc(%ebp)
8010120f:	ff 73 10             	pushl  0x10(%ebx)
80101212:	e8 f9 09 00 00       	call   80101c10 <stati>
    iunlock(f->ip);
80101217:	59                   	pop    %ecx
80101218:	ff 73 10             	pushl  0x10(%ebx)
8010121b:	e8 20 08 00 00       	call   80101a40 <iunlock>
    return 0;
80101220:	83 c4 10             	add    $0x10,%esp
80101223:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101228:	c9                   	leave  
80101229:	c3                   	ret    
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101235:	eb ee                	jmp    80101225 <filestat+0x35>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101240 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 0c             	sub    $0xc,%esp
80101249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010124c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010124f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101252:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101256:	74 60                	je     801012b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101258:	8b 03                	mov    (%ebx),%eax
8010125a:	83 f8 01             	cmp    $0x1,%eax
8010125d:	74 41                	je     801012a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010125f:	83 f8 02             	cmp    $0x2,%eax
80101262:	75 5b                	jne    801012bf <fileread+0x7f>
    ilock(f->ip);
80101264:	83 ec 0c             	sub    $0xc,%esp
80101267:	ff 73 10             	pushl  0x10(%ebx)
8010126a:	e8 f1 06 00 00       	call   80101960 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010126f:	57                   	push   %edi
80101270:	ff 73 14             	pushl  0x14(%ebx)
80101273:	56                   	push   %esi
80101274:	ff 73 10             	pushl  0x10(%ebx)
80101277:	e8 c4 09 00 00       	call   80101c40 <readi>
8010127c:	83 c4 20             	add    $0x20,%esp
8010127f:	85 c0                	test   %eax,%eax
80101281:	89 c6                	mov    %eax,%esi
80101283:	7e 03                	jle    80101288 <fileread+0x48>
      f->off += r;
80101285:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101288:	83 ec 0c             	sub    $0xc,%esp
8010128b:	ff 73 10             	pushl  0x10(%ebx)
8010128e:	e8 ad 07 00 00       	call   80101a40 <iunlock>
    return r;
80101293:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101296:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101299:	89 f0                	mov    %esi,%eax
8010129b:	5b                   	pop    %ebx
8010129c:	5e                   	pop    %esi
8010129d:	5f                   	pop    %edi
8010129e:	5d                   	pop    %ebp
8010129f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801012a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801012a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a9:	5b                   	pop    %ebx
801012aa:	5e                   	pop    %esi
801012ab:	5f                   	pop    %edi
801012ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801012ad:	e9 3e 2a 00 00       	jmp    80103cf0 <piperead>
801012b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801012b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801012bd:	eb d7                	jmp    80101296 <fileread+0x56>
  panic("fileread");
801012bf:	83 ec 0c             	sub    $0xc,%esp
801012c2:	68 66 88 10 80       	push   $0x80108866
801012c7:	e8 c4 f0 ff ff       	call   80100390 <panic>
801012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	83 ec 1c             	sub    $0x1c,%esp
801012d9:	8b 75 08             	mov    0x8(%ebp),%esi
801012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801012df:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801012e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801012e6:	8b 45 10             	mov    0x10(%ebp),%eax
801012e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801012ec:	0f 84 aa 00 00 00    	je     8010139c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801012f2:	8b 06                	mov    (%esi),%eax
801012f4:	83 f8 01             	cmp    $0x1,%eax
801012f7:	0f 84 c3 00 00 00    	je     801013c0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801012fd:	83 f8 02             	cmp    $0x2,%eax
80101300:	0f 85 d9 00 00 00    	jne    801013df <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101309:	31 ff                	xor    %edi,%edi
    while(i < n){
8010130b:	85 c0                	test   %eax,%eax
8010130d:	7f 34                	jg     80101343 <filewrite+0x73>
8010130f:	e9 9c 00 00 00       	jmp    801013b0 <filewrite+0xe0>
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101318:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010131b:	83 ec 0c             	sub    $0xc,%esp
8010131e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101321:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101324:	e8 17 07 00 00       	call   80101a40 <iunlock>
      end_op();
80101329:	e8 d2 20 00 00       	call   80103400 <end_op>
8010132e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101331:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101334:	39 c3                	cmp    %eax,%ebx
80101336:	0f 85 96 00 00 00    	jne    801013d2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010133c:	01 df                	add    %ebx,%edi
    while(i < n){
8010133e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101341:	7e 6d                	jle    801013b0 <filewrite+0xe0>
      int n1 = n - i;
80101343:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101346:	b8 00 06 00 00       	mov    $0x600,%eax
8010134b:	29 fb                	sub    %edi,%ebx
8010134d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101353:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101356:	e8 35 20 00 00       	call   80103390 <begin_op>
      ilock(f->ip);
8010135b:	83 ec 0c             	sub    $0xc,%esp
8010135e:	ff 76 10             	pushl  0x10(%esi)
80101361:	e8 fa 05 00 00       	call   80101960 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101366:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101369:	53                   	push   %ebx
8010136a:	ff 76 14             	pushl  0x14(%esi)
8010136d:	01 f8                	add    %edi,%eax
8010136f:	50                   	push   %eax
80101370:	ff 76 10             	pushl  0x10(%esi)
80101373:	e8 c8 09 00 00       	call   80101d40 <writei>
80101378:	83 c4 20             	add    $0x20,%esp
8010137b:	85 c0                	test   %eax,%eax
8010137d:	7f 99                	jg     80101318 <filewrite+0x48>
      iunlock(f->ip);
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	ff 76 10             	pushl  0x10(%esi)
80101385:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101388:	e8 b3 06 00 00       	call   80101a40 <iunlock>
      end_op();
8010138d:	e8 6e 20 00 00       	call   80103400 <end_op>
      if(r < 0)
80101392:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101395:	83 c4 10             	add    $0x10,%esp
80101398:	85 c0                	test   %eax,%eax
8010139a:	74 98                	je     80101334 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010139c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010139f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801013a4:	89 f8                	mov    %edi,%eax
801013a6:	5b                   	pop    %ebx
801013a7:	5e                   	pop    %esi
801013a8:	5f                   	pop    %edi
801013a9:	5d                   	pop    %ebp
801013aa:	c3                   	ret    
801013ab:	90                   	nop
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801013b0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801013b3:	75 e7                	jne    8010139c <filewrite+0xcc>
}
801013b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b8:	89 f8                	mov    %edi,%eax
801013ba:	5b                   	pop    %ebx
801013bb:	5e                   	pop    %esi
801013bc:	5f                   	pop    %edi
801013bd:	5d                   	pop    %ebp
801013be:	c3                   	ret    
801013bf:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801013c0:	8b 46 0c             	mov    0xc(%esi),%eax
801013c3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013c9:	5b                   	pop    %ebx
801013ca:	5e                   	pop    %esi
801013cb:	5f                   	pop    %edi
801013cc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801013cd:	e9 0e 28 00 00       	jmp    80103be0 <pipewrite>
        panic("short filewrite");
801013d2:	83 ec 0c             	sub    $0xc,%esp
801013d5:	68 6f 88 10 80       	push   $0x8010886f
801013da:	e8 b1 ef ff ff       	call   80100390 <panic>
  panic("filewrite");
801013df:	83 ec 0c             	sub    $0xc,%esp
801013e2:	68 75 88 10 80       	push   $0x80108875
801013e7:	e8 a4 ef ff ff       	call   80100390 <panic>
801013ec:	66 90                	xchg   %ax,%ax
801013ee:	66 90                	xchg   %ax,%ax

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801013f7:	c1 ea 0c             	shr    $0xc,%edx
801013fa:	03 15 d8 29 11 80    	add    0x801129d8,%edx
80101400:	83 ec 08             	sub    $0x8,%esp
80101403:	52                   	push   %edx
80101404:	50                   	push   %eax
80101405:	e8 c6 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010140a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010140c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010140f:	ba 01 00 00 00       	mov    $0x1,%edx
80101414:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101417:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010141d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101420:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101422:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101427:	85 d1                	test   %edx,%ecx
80101429:	74 25                	je     80101450 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010142b:	f7 d2                	not    %edx
8010142d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010142f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101432:	21 ca                	and    %ecx,%edx
80101434:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101438:	56                   	push   %esi
80101439:	e8 22 21 00 00       	call   80103560 <log_write>
  brelse(bp);
8010143e:	89 34 24             	mov    %esi,(%esp)
80101441:	e8 9a ed ff ff       	call   801001e0 <brelse>
}
80101446:	83 c4 10             	add    $0x10,%esp
80101449:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010144c:	5b                   	pop    %ebx
8010144d:	5e                   	pop    %esi
8010144e:	5d                   	pop    %ebp
8010144f:	c3                   	ret    
    panic("freeing free block");
80101450:	83 ec 0c             	sub    $0xc,%esp
80101453:	68 7f 88 10 80       	push   $0x8010887f
80101458:	e8 33 ef ff ff       	call   80100390 <panic>
8010145d:	8d 76 00             	lea    0x0(%esi),%esi

80101460 <balloc>:
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	53                   	push   %ebx
80101466:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101469:	8b 0d c0 29 11 80    	mov    0x801129c0,%ecx
{
8010146f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101472:	85 c9                	test   %ecx,%ecx
80101474:	0f 84 87 00 00 00    	je     80101501 <balloc+0xa1>
8010147a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101481:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101484:	83 ec 08             	sub    $0x8,%esp
80101487:	89 f0                	mov    %esi,%eax
80101489:	c1 f8 0c             	sar    $0xc,%eax
8010148c:	03 05 d8 29 11 80    	add    0x801129d8,%eax
80101492:	50                   	push   %eax
80101493:	ff 75 d8             	pushl  -0x28(%ebp)
80101496:	e8 35 ec ff ff       	call   801000d0 <bread>
8010149b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010149e:	a1 c0 29 11 80       	mov    0x801129c0,%eax
801014a3:	83 c4 10             	add    $0x10,%esp
801014a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014a9:	31 c0                	xor    %eax,%eax
801014ab:	eb 2f                	jmp    801014dc <balloc+0x7c>
801014ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801014b0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801014b5:	bb 01 00 00 00       	mov    $0x1,%ebx
801014ba:	83 e1 07             	and    $0x7,%ecx
801014bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014bf:	89 c1                	mov    %eax,%ecx
801014c1:	c1 f9 03             	sar    $0x3,%ecx
801014c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801014c9:	85 df                	test   %ebx,%edi
801014cb:	89 fa                	mov    %edi,%edx
801014cd:	74 41                	je     80101510 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014cf:	83 c0 01             	add    $0x1,%eax
801014d2:	83 c6 01             	add    $0x1,%esi
801014d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801014da:	74 05                	je     801014e1 <balloc+0x81>
801014dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801014df:	77 cf                	ja     801014b0 <balloc+0x50>
    brelse(bp);
801014e1:	83 ec 0c             	sub    $0xc,%esp
801014e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801014e7:	e8 f4 ec ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801014ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801014f3:	83 c4 10             	add    $0x10,%esp
801014f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014f9:	39 05 c0 29 11 80    	cmp    %eax,0x801129c0
801014ff:	77 80                	ja     80101481 <balloc+0x21>
  panic("balloc: out of blocks");
80101501:	83 ec 0c             	sub    $0xc,%esp
80101504:	68 92 88 10 80       	push   $0x80108892
80101509:	e8 82 ee ff ff       	call   80100390 <panic>
8010150e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101513:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101516:	09 da                	or     %ebx,%edx
80101518:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010151c:	57                   	push   %edi
8010151d:	e8 3e 20 00 00       	call   80103560 <log_write>
        brelse(bp);
80101522:	89 3c 24             	mov    %edi,(%esp)
80101525:	e8 b6 ec ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010152a:	58                   	pop    %eax
8010152b:	5a                   	pop    %edx
8010152c:	56                   	push   %esi
8010152d:	ff 75 d8             	pushl  -0x28(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
80101535:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101537:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153a:	83 c4 0c             	add    $0xc,%esp
8010153d:	68 00 02 00 00       	push   $0x200
80101542:	6a 00                	push   $0x0
80101544:	50                   	push   %eax
80101545:	e8 76 3f 00 00       	call   801054c0 <memset>
  log_write(bp);
8010154a:	89 1c 24             	mov    %ebx,(%esp)
8010154d:	e8 0e 20 00 00       	call   80103560 <log_write>
  brelse(bp);
80101552:	89 1c 24             	mov    %ebx,(%esp)
80101555:	e8 86 ec ff ff       	call   801001e0 <brelse>
}
8010155a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155d:	89 f0                	mov    %esi,%eax
8010155f:	5b                   	pop    %ebx
80101560:	5e                   	pop    %esi
80101561:	5f                   	pop    %edi
80101562:	5d                   	pop    %ebp
80101563:	c3                   	ret    
80101564:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010156a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101570 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	57                   	push   %edi
80101574:	56                   	push   %esi
80101575:	53                   	push   %ebx
80101576:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101578:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010157a:	bb 14 2a 11 80       	mov    $0x80112a14,%ebx
{
8010157f:	83 ec 28             	sub    $0x28,%esp
80101582:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101585:	68 e0 29 11 80       	push   $0x801129e0
8010158a:	e8 21 3e 00 00       	call   801053b0 <acquire>
8010158f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101592:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101595:	eb 17                	jmp    801015ae <iget+0x3e>
80101597:	89 f6                	mov    %esi,%esi
80101599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801015a0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015a6:	81 fb 34 46 11 80    	cmp    $0x80114634,%ebx
801015ac:	73 22                	jae    801015d0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801015b1:	85 c9                	test   %ecx,%ecx
801015b3:	7e 04                	jle    801015b9 <iget+0x49>
801015b5:	39 3b                	cmp    %edi,(%ebx)
801015b7:	74 4f                	je     80101608 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801015b9:	85 f6                	test   %esi,%esi
801015bb:	75 e3                	jne    801015a0 <iget+0x30>
801015bd:	85 c9                	test   %ecx,%ecx
801015bf:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015c2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015c8:	81 fb 34 46 11 80    	cmp    $0x80114634,%ebx
801015ce:	72 de                	jb     801015ae <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801015d0:	85 f6                	test   %esi,%esi
801015d2:	74 5b                	je     8010162f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801015d4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801015d7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801015d9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801015dc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801015e3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801015ea:	68 e0 29 11 80       	push   $0x801129e0
801015ef:	e8 7c 3e 00 00       	call   80105470 <release>

  return ip;
801015f4:	83 c4 10             	add    $0x10,%esp
}
801015f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015fa:	89 f0                	mov    %esi,%eax
801015fc:	5b                   	pop    %ebx
801015fd:	5e                   	pop    %esi
801015fe:	5f                   	pop    %edi
801015ff:	5d                   	pop    %ebp
80101600:	c3                   	ret    
80101601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101608:	39 53 04             	cmp    %edx,0x4(%ebx)
8010160b:	75 ac                	jne    801015b9 <iget+0x49>
      release(&icache.lock);
8010160d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101610:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101613:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101615:	68 e0 29 11 80       	push   $0x801129e0
      ip->ref++;
8010161a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010161d:	e8 4e 3e 00 00       	call   80105470 <release>
      return ip;
80101622:	83 c4 10             	add    $0x10,%esp
}
80101625:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101628:	89 f0                	mov    %esi,%eax
8010162a:	5b                   	pop    %ebx
8010162b:	5e                   	pop    %esi
8010162c:	5f                   	pop    %edi
8010162d:	5d                   	pop    %ebp
8010162e:	c3                   	ret    
    panic("iget: no inodes");
8010162f:	83 ec 0c             	sub    $0xc,%esp
80101632:	68 a8 88 10 80       	push   $0x801088a8
80101637:	e8 54 ed ff ff       	call   80100390 <panic>
8010163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101640 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	57                   	push   %edi
80101644:	56                   	push   %esi
80101645:	53                   	push   %ebx
80101646:	89 c6                	mov    %eax,%esi
80101648:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010164b:	83 fa 0b             	cmp    $0xb,%edx
8010164e:	77 18                	ja     80101668 <bmap+0x28>
80101650:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101653:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101656:	85 db                	test   %ebx,%ebx
80101658:	74 76                	je     801016d0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010165a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010165d:	89 d8                	mov    %ebx,%eax
8010165f:	5b                   	pop    %ebx
80101660:	5e                   	pop    %esi
80101661:	5f                   	pop    %edi
80101662:	5d                   	pop    %ebp
80101663:	c3                   	ret    
80101664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101668:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010166b:	83 fb 7f             	cmp    $0x7f,%ebx
8010166e:	0f 87 90 00 00 00    	ja     80101704 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101674:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010167a:	8b 00                	mov    (%eax),%eax
8010167c:	85 d2                	test   %edx,%edx
8010167e:	74 70                	je     801016f0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101680:	83 ec 08             	sub    $0x8,%esp
80101683:	52                   	push   %edx
80101684:	50                   	push   %eax
80101685:	e8 46 ea ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010168a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010168e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101691:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101693:	8b 1a                	mov    (%edx),%ebx
80101695:	85 db                	test   %ebx,%ebx
80101697:	75 1d                	jne    801016b6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101699:	8b 06                	mov    (%esi),%eax
8010169b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010169e:	e8 bd fd ff ff       	call   80101460 <balloc>
801016a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801016a6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801016a9:	89 c3                	mov    %eax,%ebx
801016ab:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801016ad:	57                   	push   %edi
801016ae:	e8 ad 1e 00 00       	call   80103560 <log_write>
801016b3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801016b6:	83 ec 0c             	sub    $0xc,%esp
801016b9:	57                   	push   %edi
801016ba:	e8 21 eb ff ff       	call   801001e0 <brelse>
801016bf:	83 c4 10             	add    $0x10,%esp
}
801016c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016c5:	89 d8                	mov    %ebx,%eax
801016c7:	5b                   	pop    %ebx
801016c8:	5e                   	pop    %esi
801016c9:	5f                   	pop    %edi
801016ca:	5d                   	pop    %ebp
801016cb:	c3                   	ret    
801016cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801016d0:	8b 00                	mov    (%eax),%eax
801016d2:	e8 89 fd ff ff       	call   80101460 <balloc>
801016d7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801016da:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801016dd:	89 c3                	mov    %eax,%ebx
}
801016df:	89 d8                	mov    %ebx,%eax
801016e1:	5b                   	pop    %ebx
801016e2:	5e                   	pop    %esi
801016e3:	5f                   	pop    %edi
801016e4:	5d                   	pop    %ebp
801016e5:	c3                   	ret    
801016e6:	8d 76 00             	lea    0x0(%esi),%esi
801016e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801016f0:	e8 6b fd ff ff       	call   80101460 <balloc>
801016f5:	89 c2                	mov    %eax,%edx
801016f7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801016fd:	8b 06                	mov    (%esi),%eax
801016ff:	e9 7c ff ff ff       	jmp    80101680 <bmap+0x40>
  panic("bmap: out of range");
80101704:	83 ec 0c             	sub    $0xc,%esp
80101707:	68 b8 88 10 80       	push   $0x801088b8
8010170c:	e8 7f ec ff ff       	call   80100390 <panic>
80101711:	eb 0d                	jmp    80101720 <readsb>
80101713:	90                   	nop
80101714:	90                   	nop
80101715:	90                   	nop
80101716:	90                   	nop
80101717:	90                   	nop
80101718:	90                   	nop
80101719:	90                   	nop
8010171a:	90                   	nop
8010171b:	90                   	nop
8010171c:	90                   	nop
8010171d:	90                   	nop
8010171e:	90                   	nop
8010171f:	90                   	nop

80101720 <readsb>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101728:	83 ec 08             	sub    $0x8,%esp
8010172b:	6a 01                	push   $0x1
8010172d:	ff 75 08             	pushl  0x8(%ebp)
80101730:	e8 9b e9 ff ff       	call   801000d0 <bread>
80101735:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101737:	8d 40 5c             	lea    0x5c(%eax),%eax
8010173a:	83 c4 0c             	add    $0xc,%esp
8010173d:	6a 1c                	push   $0x1c
8010173f:	50                   	push   %eax
80101740:	56                   	push   %esi
80101741:	e8 2a 3e 00 00       	call   80105570 <memmove>
  brelse(bp);
80101746:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101749:	83 c4 10             	add    $0x10,%esp
}
8010174c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010174f:	5b                   	pop    %ebx
80101750:	5e                   	pop    %esi
80101751:	5d                   	pop    %ebp
  brelse(bp);
80101752:	e9 89 ea ff ff       	jmp    801001e0 <brelse>
80101757:	89 f6                	mov    %esi,%esi
80101759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101760 <iinit>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	bb 20 2a 11 80       	mov    $0x80112a20,%ebx
80101769:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010176c:	68 cb 88 10 80       	push   $0x801088cb
80101771:	68 e0 29 11 80       	push   $0x801129e0
80101776:	e8 f5 3a 00 00       	call   80105270 <initlock>
8010177b:	83 c4 10             	add    $0x10,%esp
8010177e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101780:	83 ec 08             	sub    $0x8,%esp
80101783:	68 d2 88 10 80       	push   $0x801088d2
80101788:	53                   	push   %ebx
80101789:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010178f:	e8 ac 39 00 00       	call   80105140 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101794:	83 c4 10             	add    $0x10,%esp
80101797:	81 fb 40 46 11 80    	cmp    $0x80114640,%ebx
8010179d:	75 e1                	jne    80101780 <iinit+0x20>
  readsb(dev, &sb);
8010179f:	83 ec 08             	sub    $0x8,%esp
801017a2:	68 c0 29 11 80       	push   $0x801129c0
801017a7:	ff 75 08             	pushl  0x8(%ebp)
801017aa:	e8 71 ff ff ff       	call   80101720 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017af:	ff 35 d8 29 11 80    	pushl  0x801129d8
801017b5:	ff 35 d4 29 11 80    	pushl  0x801129d4
801017bb:	ff 35 d0 29 11 80    	pushl  0x801129d0
801017c1:	ff 35 cc 29 11 80    	pushl  0x801129cc
801017c7:	ff 35 c8 29 11 80    	pushl  0x801129c8
801017cd:	ff 35 c4 29 11 80    	pushl  0x801129c4
801017d3:	ff 35 c0 29 11 80    	pushl  0x801129c0
801017d9:	68 7c 89 10 80       	push   $0x8010897c
801017de:	e8 7d ee ff ff       	call   80100660 <cprintf>
}
801017e3:	83 c4 30             	add    $0x30,%esp
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave  
801017ea:	c3                   	ret    
801017eb:	90                   	nop
801017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017f0 <ialloc>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017f9:	83 3d c8 29 11 80 01 	cmpl   $0x1,0x801129c8
{
80101800:	8b 45 0c             	mov    0xc(%ebp),%eax
80101803:	8b 75 08             	mov    0x8(%ebp),%esi
80101806:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101809:	0f 86 91 00 00 00    	jbe    801018a0 <ialloc+0xb0>
8010180f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101814:	eb 21                	jmp    80101837 <ialloc+0x47>
80101816:	8d 76 00             	lea    0x0(%esi),%esi
80101819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101820:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101823:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101826:	57                   	push   %edi
80101827:	e8 b4 e9 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010182c:	83 c4 10             	add    $0x10,%esp
8010182f:	39 1d c8 29 11 80    	cmp    %ebx,0x801129c8
80101835:	76 69                	jbe    801018a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101837:	89 d8                	mov    %ebx,%eax
80101839:	83 ec 08             	sub    $0x8,%esp
8010183c:	c1 e8 03             	shr    $0x3,%eax
8010183f:	03 05 d4 29 11 80    	add    0x801129d4,%eax
80101845:	50                   	push   %eax
80101846:	56                   	push   %esi
80101847:	e8 84 e8 ff ff       	call   801000d0 <bread>
8010184c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010184e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101850:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101853:	83 e0 07             	and    $0x7,%eax
80101856:	c1 e0 06             	shl    $0x6,%eax
80101859:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010185d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101861:	75 bd                	jne    80101820 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101863:	83 ec 04             	sub    $0x4,%esp
80101866:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101869:	6a 40                	push   $0x40
8010186b:	6a 00                	push   $0x0
8010186d:	51                   	push   %ecx
8010186e:	e8 4d 3c 00 00       	call   801054c0 <memset>
      dip->type = type;
80101873:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101877:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010187a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010187d:	89 3c 24             	mov    %edi,(%esp)
80101880:	e8 db 1c 00 00       	call   80103560 <log_write>
      brelse(bp);
80101885:	89 3c 24             	mov    %edi,(%esp)
80101888:	e8 53 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010188d:	83 c4 10             	add    $0x10,%esp
}
80101890:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101893:	89 da                	mov    %ebx,%edx
80101895:	89 f0                	mov    %esi,%eax
}
80101897:	5b                   	pop    %ebx
80101898:	5e                   	pop    %esi
80101899:	5f                   	pop    %edi
8010189a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010189b:	e9 d0 fc ff ff       	jmp    80101570 <iget>
  panic("ialloc: no inodes");
801018a0:	83 ec 0c             	sub    $0xc,%esp
801018a3:	68 d8 88 10 80       	push   $0x801088d8
801018a8:	e8 e3 ea ff ff       	call   80100390 <panic>
801018ad:	8d 76 00             	lea    0x0(%esi),%esi

801018b0 <iupdate>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018b8:	83 ec 08             	sub    $0x8,%esp
801018bb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018be:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018c1:	c1 e8 03             	shr    $0x3,%eax
801018c4:	03 05 d4 29 11 80    	add    0x801129d4,%eax
801018ca:	50                   	push   %eax
801018cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801018ce:	e8 fd e7 ff ff       	call   801000d0 <bread>
801018d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801018d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018dc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018df:	83 e0 07             	and    $0x7,%eax
801018e2:	c1 e0 06             	shl    $0x6,%eax
801018e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801018e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018f0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801018f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801018f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801018fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801018ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101903:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101907:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010190a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010190d:	6a 34                	push   $0x34
8010190f:	53                   	push   %ebx
80101910:	50                   	push   %eax
80101911:	e8 5a 3c 00 00       	call   80105570 <memmove>
  log_write(bp);
80101916:	89 34 24             	mov    %esi,(%esp)
80101919:	e8 42 1c 00 00       	call   80103560 <log_write>
  brelse(bp);
8010191e:	89 75 08             	mov    %esi,0x8(%ebp)
80101921:	83 c4 10             	add    $0x10,%esp
}
80101924:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101927:	5b                   	pop    %ebx
80101928:	5e                   	pop    %esi
80101929:	5d                   	pop    %ebp
  brelse(bp);
8010192a:	e9 b1 e8 ff ff       	jmp    801001e0 <brelse>
8010192f:	90                   	nop

80101930 <idup>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 10             	sub    $0x10,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010193a:	68 e0 29 11 80       	push   $0x801129e0
8010193f:	e8 6c 3a 00 00       	call   801053b0 <acquire>
  ip->ref++;
80101944:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101948:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
8010194f:	e8 1c 3b 00 00       	call   80105470 <release>
}
80101954:	89 d8                	mov    %ebx,%eax
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <ilock>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	56                   	push   %esi
80101964:	53                   	push   %ebx
80101965:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101968:	85 db                	test   %ebx,%ebx
8010196a:	0f 84 b7 00 00 00    	je     80101a27 <ilock+0xc7>
80101970:	8b 53 08             	mov    0x8(%ebx),%edx
80101973:	85 d2                	test   %edx,%edx
80101975:	0f 8e ac 00 00 00    	jle    80101a27 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010197b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010197e:	83 ec 0c             	sub    $0xc,%esp
80101981:	50                   	push   %eax
80101982:	e8 f9 37 00 00       	call   80105180 <acquiresleep>
  if(ip->valid == 0){
80101987:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	85 c0                	test   %eax,%eax
8010198f:	74 0f                	je     801019a0 <ilock+0x40>
}
80101991:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101994:	5b                   	pop    %ebx
80101995:	5e                   	pop    %esi
80101996:	5d                   	pop    %ebp
80101997:	c3                   	ret    
80101998:	90                   	nop
80101999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019a0:	8b 43 04             	mov    0x4(%ebx),%eax
801019a3:	83 ec 08             	sub    $0x8,%esp
801019a6:	c1 e8 03             	shr    $0x3,%eax
801019a9:	03 05 d4 29 11 80    	add    0x801129d4,%eax
801019af:	50                   	push   %eax
801019b0:	ff 33                	pushl  (%ebx)
801019b2:	e8 19 e7 ff ff       	call   801000d0 <bread>
801019b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019b9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019bc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019bf:	83 e0 07             	and    $0x7,%eax
801019c2:	c1 e0 06             	shl    $0x6,%eax
801019c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801019c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801019cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801019d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801019d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801019db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801019df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801019e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801019e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801019eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801019ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019f1:	6a 34                	push   $0x34
801019f3:	50                   	push   %eax
801019f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801019f7:	50                   	push   %eax
801019f8:	e8 73 3b 00 00       	call   80105570 <memmove>
    brelse(bp);
801019fd:	89 34 24             	mov    %esi,(%esp)
80101a00:	e8 db e7 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101a05:	83 c4 10             	add    $0x10,%esp
80101a08:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101a0d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a14:	0f 85 77 ff ff ff    	jne    80101991 <ilock+0x31>
      panic("ilock: no type");
80101a1a:	83 ec 0c             	sub    $0xc,%esp
80101a1d:	68 f0 88 10 80       	push   $0x801088f0
80101a22:	e8 69 e9 ff ff       	call   80100390 <panic>
    panic("ilock");
80101a27:	83 ec 0c             	sub    $0xc,%esp
80101a2a:	68 ea 88 10 80       	push   $0x801088ea
80101a2f:	e8 5c e9 ff ff       	call   80100390 <panic>
80101a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101a40 <iunlock>:
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	56                   	push   %esi
80101a44:	53                   	push   %ebx
80101a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a48:	85 db                	test   %ebx,%ebx
80101a4a:	74 28                	je     80101a74 <iunlock+0x34>
80101a4c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a4f:	83 ec 0c             	sub    $0xc,%esp
80101a52:	56                   	push   %esi
80101a53:	e8 c8 37 00 00       	call   80105220 <holdingsleep>
80101a58:	83 c4 10             	add    $0x10,%esp
80101a5b:	85 c0                	test   %eax,%eax
80101a5d:	74 15                	je     80101a74 <iunlock+0x34>
80101a5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a62:	85 c0                	test   %eax,%eax
80101a64:	7e 0e                	jle    80101a74 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a66:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a6c:	5b                   	pop    %ebx
80101a6d:	5e                   	pop    %esi
80101a6e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a6f:	e9 6c 37 00 00       	jmp    801051e0 <releasesleep>
    panic("iunlock");
80101a74:	83 ec 0c             	sub    $0xc,%esp
80101a77:	68 ff 88 10 80       	push   $0x801088ff
80101a7c:	e8 0f e9 ff ff       	call   80100390 <panic>
80101a81:	eb 0d                	jmp    80101a90 <iput>
80101a83:	90                   	nop
80101a84:	90                   	nop
80101a85:	90                   	nop
80101a86:	90                   	nop
80101a87:	90                   	nop
80101a88:	90                   	nop
80101a89:	90                   	nop
80101a8a:	90                   	nop
80101a8b:	90                   	nop
80101a8c:	90                   	nop
80101a8d:	90                   	nop
80101a8e:	90                   	nop
80101a8f:	90                   	nop

80101a90 <iput>:
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 28             	sub    $0x28,%esp
80101a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a9c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a9f:	57                   	push   %edi
80101aa0:	e8 db 36 00 00       	call   80105180 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101aa5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101aa8:	83 c4 10             	add    $0x10,%esp
80101aab:	85 d2                	test   %edx,%edx
80101aad:	74 07                	je     80101ab6 <iput+0x26>
80101aaf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101ab4:	74 32                	je     80101ae8 <iput+0x58>
  releasesleep(&ip->lock);
80101ab6:	83 ec 0c             	sub    $0xc,%esp
80101ab9:	57                   	push   %edi
80101aba:	e8 21 37 00 00       	call   801051e0 <releasesleep>
  acquire(&icache.lock);
80101abf:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80101ac6:	e8 e5 38 00 00       	call   801053b0 <acquire>
  ip->ref--;
80101acb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	c7 45 08 e0 29 11 80 	movl   $0x801129e0,0x8(%ebp)
}
80101ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adc:	5b                   	pop    %ebx
80101add:	5e                   	pop    %esi
80101ade:	5f                   	pop    %edi
80101adf:	5d                   	pop    %ebp
  release(&icache.lock);
80101ae0:	e9 8b 39 00 00       	jmp    80105470 <release>
80101ae5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ae8:	83 ec 0c             	sub    $0xc,%esp
80101aeb:	68 e0 29 11 80       	push   $0x801129e0
80101af0:	e8 bb 38 00 00       	call   801053b0 <acquire>
    int r = ip->ref;
80101af5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101af8:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80101aff:	e8 6c 39 00 00       	call   80105470 <release>
    if(r == 1){
80101b04:	83 c4 10             	add    $0x10,%esp
80101b07:	83 fe 01             	cmp    $0x1,%esi
80101b0a:	75 aa                	jne    80101ab6 <iput+0x26>
80101b0c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b12:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b15:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b18:	89 cf                	mov    %ecx,%edi
80101b1a:	eb 0b                	jmp    80101b27 <iput+0x97>
80101b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b20:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b23:	39 fe                	cmp    %edi,%esi
80101b25:	74 19                	je     80101b40 <iput+0xb0>
    if(ip->addrs[i]){
80101b27:	8b 16                	mov    (%esi),%edx
80101b29:	85 d2                	test   %edx,%edx
80101b2b:	74 f3                	je     80101b20 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b2d:	8b 03                	mov    (%ebx),%eax
80101b2f:	e8 bc f8 ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101b34:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b3a:	eb e4                	jmp    80101b20 <iput+0x90>
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b40:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b46:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b49:	85 c0                	test   %eax,%eax
80101b4b:	75 33                	jne    80101b80 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b4d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b50:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b57:	53                   	push   %ebx
80101b58:	e8 53 fd ff ff       	call   801018b0 <iupdate>
      ip->type = 0;
80101b5d:	31 c0                	xor    %eax,%eax
80101b5f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b63:	89 1c 24             	mov    %ebx,(%esp)
80101b66:	e8 45 fd ff ff       	call   801018b0 <iupdate>
      ip->valid = 0;
80101b6b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b72:	83 c4 10             	add    $0x10,%esp
80101b75:	e9 3c ff ff ff       	jmp    80101ab6 <iput+0x26>
80101b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b80:	83 ec 08             	sub    $0x8,%esp
80101b83:	50                   	push   %eax
80101b84:	ff 33                	pushl  (%ebx)
80101b86:	e8 45 e5 ff ff       	call   801000d0 <bread>
80101b8b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b91:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101b97:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	89 cf                	mov    %ecx,%edi
80101b9f:	eb 0e                	jmp    80101baf <iput+0x11f>
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ba8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101bab:	39 fe                	cmp    %edi,%esi
80101bad:	74 0f                	je     80101bbe <iput+0x12e>
      if(a[j])
80101baf:	8b 16                	mov    (%esi),%edx
80101bb1:	85 d2                	test   %edx,%edx
80101bb3:	74 f3                	je     80101ba8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101bb5:	8b 03                	mov    (%ebx),%eax
80101bb7:	e8 34 f8 ff ff       	call   801013f0 <bfree>
80101bbc:	eb ea                	jmp    80101ba8 <iput+0x118>
    brelse(bp);
80101bbe:	83 ec 0c             	sub    $0xc,%esp
80101bc1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bc4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc7:	e8 14 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101bcc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101bd2:	8b 03                	mov    (%ebx),%eax
80101bd4:	e8 17 f8 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101bd9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101be0:	00 00 00 
80101be3:	83 c4 10             	add    $0x10,%esp
80101be6:	e9 62 ff ff ff       	jmp    80101b4d <iput+0xbd>
80101beb:	90                   	nop
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bf0 <iunlockput>:
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	53                   	push   %ebx
80101bf4:	83 ec 10             	sub    $0x10,%esp
80101bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101bfa:	53                   	push   %ebx
80101bfb:	e8 40 fe ff ff       	call   80101a40 <iunlock>
  iput(ip);
80101c00:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c03:	83 c4 10             	add    $0x10,%esp
}
80101c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c09:	c9                   	leave  
  iput(ip);
80101c0a:	e9 81 fe ff ff       	jmp    80101a90 <iput>
80101c0f:	90                   	nop

80101c10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	8b 55 08             	mov    0x8(%ebp),%edx
80101c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c19:	8b 0a                	mov    (%edx),%ecx
80101c1b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c1e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c21:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c24:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c28:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c2b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c2f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c33:	8b 52 58             	mov    0x58(%edx),%edx
80101c36:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c39:	5d                   	pop    %ebp
80101c3a:	c3                   	ret    
80101c3b:	90                   	nop
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c40 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	83 ec 1c             	sub    $0x1c,%esp
80101c49:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c57:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c60:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c63:	0f 84 a7 00 00 00    	je     80101d10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	8b 40 58             	mov    0x58(%eax),%eax
80101c6f:	39 c6                	cmp    %eax,%esi
80101c71:	0f 87 ba 00 00 00    	ja     80101d31 <readi+0xf1>
80101c77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c7a:	89 f9                	mov    %edi,%ecx
80101c7c:	01 f1                	add    %esi,%ecx
80101c7e:	0f 82 ad 00 00 00    	jb     80101d31 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c84:	89 c2                	mov    %eax,%edx
80101c86:	29 f2                	sub    %esi,%edx
80101c88:	39 c8                	cmp    %ecx,%eax
80101c8a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c8d:	31 ff                	xor    %edi,%edi
80101c8f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101c91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c94:	74 6c                	je     80101d02 <readi+0xc2>
80101c96:	8d 76 00             	lea    0x0(%esi),%esi
80101c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ca0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ca3:	89 f2                	mov    %esi,%edx
80101ca5:	c1 ea 09             	shr    $0x9,%edx
80101ca8:	89 d8                	mov    %ebx,%eax
80101caa:	e8 91 f9 ff ff       	call   80101640 <bmap>
80101caf:	83 ec 08             	sub    $0x8,%esp
80101cb2:	50                   	push   %eax
80101cb3:	ff 33                	pushl  (%ebx)
80101cb5:	e8 16 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cbd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101cbf:	89 f0                	mov    %esi,%eax
80101cc1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cc6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ccb:	83 c4 0c             	add    $0xc,%esp
80101cce:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101cd0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101cd4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101cd7:	29 fb                	sub    %edi,%ebx
80101cd9:	39 d9                	cmp    %ebx,%ecx
80101cdb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101cde:	53                   	push   %ebx
80101cdf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ce0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ce2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ce5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ce7:	e8 84 38 00 00       	call   80105570 <memmove>
    brelse(bp);
80101cec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101cef:	89 14 24             	mov    %edx,(%esp)
80101cf2:	e8 e9 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cf7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d00:	77 9e                	ja     80101ca0 <readi+0x60>
  }
  return n;
80101d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d08:	5b                   	pop    %ebx
80101d09:	5e                   	pop    %esi
80101d0a:	5f                   	pop    %edi
80101d0b:	5d                   	pop    %ebp
80101d0c:	c3                   	ret    
80101d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d14:	66 83 f8 09          	cmp    $0x9,%ax
80101d18:	77 17                	ja     80101d31 <readi+0xf1>
80101d1a:	8b 04 c5 60 29 11 80 	mov    -0x7feed6a0(,%eax,8),%eax
80101d21:	85 c0                	test   %eax,%eax
80101d23:	74 0c                	je     80101d31 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d2b:	5b                   	pop    %ebx
80101d2c:	5e                   	pop    %esi
80101d2d:	5f                   	pop    %edi
80101d2e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d2f:	ff e0                	jmp    *%eax
      return -1;
80101d31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d36:	eb cd                	jmp    80101d05 <readi+0xc5>
80101d38:	90                   	nop
80101d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d63:	0f 84 b7 00 00 00    	je     80101e20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d6f:	0f 82 eb 00 00 00    	jb     80101e60 <writei+0x120>
80101d75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d78:	31 d2                	xor    %edx,%edx
80101d7a:	89 f8                	mov    %edi,%eax
80101d7c:	01 f0                	add    %esi,%eax
80101d7e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d81:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d86:	0f 87 d4 00 00 00    	ja     80101e60 <writei+0x120>
80101d8c:	85 d2                	test   %edx,%edx
80101d8e:	0f 85 cc 00 00 00    	jne    80101e60 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d94:	85 ff                	test   %edi,%edi
80101d96:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d9d:	74 72                	je     80101e11 <writei+0xd1>
80101d9f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101da0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101da3:	89 f2                	mov    %esi,%edx
80101da5:	c1 ea 09             	shr    $0x9,%edx
80101da8:	89 f8                	mov    %edi,%eax
80101daa:	e8 91 f8 ff ff       	call   80101640 <bmap>
80101daf:	83 ec 08             	sub    $0x8,%esp
80101db2:	50                   	push   %eax
80101db3:	ff 37                	pushl  (%edi)
80101db5:	e8 16 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101dba:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101dbd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dc0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101dc9:	83 c4 0c             	add    $0xc,%esp
80101dcc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101dd1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101dd3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101dd7:	39 d9                	cmp    %ebx,%ecx
80101dd9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ddc:	53                   	push   %ebx
80101ddd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101de0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101de2:	50                   	push   %eax
80101de3:	e8 88 37 00 00       	call   80105570 <memmove>
    log_write(bp);
80101de8:	89 3c 24             	mov    %edi,(%esp)
80101deb:	e8 70 17 00 00       	call   80103560 <log_write>
    brelse(bp);
80101df0:	89 3c 24             	mov    %edi,(%esp)
80101df3:	e8 e8 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101df8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101dfb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101dfe:	83 c4 10             	add    $0x10,%esp
80101e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e04:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e07:	77 97                	ja     80101da0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e0c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e0f:	77 37                	ja     80101e48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e24:	66 83 f8 09          	cmp    $0x9,%ax
80101e28:	77 36                	ja     80101e60 <writei+0x120>
80101e2a:	8b 04 c5 64 29 11 80 	mov    -0x7feed69c(,%eax,8),%eax
80101e31:	85 c0                	test   %eax,%eax
80101e33:	74 2b                	je     80101e60 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101e35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e3b:	5b                   	pop    %ebx
80101e3c:	5e                   	pop    %esi
80101e3d:	5f                   	pop    %edi
80101e3e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e3f:	ff e0                	jmp    *%eax
80101e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e4b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e51:	50                   	push   %eax
80101e52:	e8 59 fa ff ff       	call   801018b0 <iupdate>
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	eb b5                	jmp    80101e11 <writei+0xd1>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e65:	eb ad                	jmp    80101e14 <writei+0xd4>
80101e67:	89 f6                	mov    %esi,%esi
80101e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e76:	6a 0e                	push   $0xe
80101e78:	ff 75 0c             	pushl  0xc(%ebp)
80101e7b:	ff 75 08             	pushl  0x8(%ebp)
80101e7e:	e8 5d 37 00 00       	call   801055e0 <strncmp>
}
80101e83:	c9                   	leave  
80101e84:	c3                   	ret    
80101e85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	83 ec 1c             	sub    $0x1c,%esp
80101e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ea1:	0f 85 85 00 00 00    	jne    80101f2c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ea7:	8b 53 58             	mov    0x58(%ebx),%edx
80101eaa:	31 ff                	xor    %edi,%edi
80101eac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	74 3e                	je     80101ef1 <dirlookup+0x61>
80101eb3:	90                   	nop
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb8:	6a 10                	push   $0x10
80101eba:	57                   	push   %edi
80101ebb:	56                   	push   %esi
80101ebc:	53                   	push   %ebx
80101ebd:	e8 7e fd ff ff       	call   80101c40 <readi>
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	83 f8 10             	cmp    $0x10,%eax
80101ec8:	75 55                	jne    80101f1f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101eca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ecf:	74 18                	je     80101ee9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101ed1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ed4:	83 ec 04             	sub    $0x4,%esp
80101ed7:	6a 0e                	push   $0xe
80101ed9:	50                   	push   %eax
80101eda:	ff 75 0c             	pushl  0xc(%ebp)
80101edd:	e8 fe 36 00 00       	call   801055e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ee2:	83 c4 10             	add    $0x10,%esp
80101ee5:	85 c0                	test   %eax,%eax
80101ee7:	74 17                	je     80101f00 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ee9:	83 c7 10             	add    $0x10,%edi
80101eec:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101eef:	72 c7                	jb     80101eb8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ef4:	31 c0                	xor    %eax,%eax
}
80101ef6:	5b                   	pop    %ebx
80101ef7:	5e                   	pop    %esi
80101ef8:	5f                   	pop    %edi
80101ef9:	5d                   	pop    %ebp
80101efa:	c3                   	ret    
80101efb:	90                   	nop
80101efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101f00:	8b 45 10             	mov    0x10(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	74 05                	je     80101f0c <dirlookup+0x7c>
        *poff = off;
80101f07:	8b 45 10             	mov    0x10(%ebp),%eax
80101f0a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f0c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f10:	8b 03                	mov    (%ebx),%eax
80101f12:	e8 59 f6 ff ff       	call   80101570 <iget>
}
80101f17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1a:	5b                   	pop    %ebx
80101f1b:	5e                   	pop    %esi
80101f1c:	5f                   	pop    %edi
80101f1d:	5d                   	pop    %ebp
80101f1e:	c3                   	ret    
      panic("dirlookup read");
80101f1f:	83 ec 0c             	sub    $0xc,%esp
80101f22:	68 19 89 10 80       	push   $0x80108919
80101f27:	e8 64 e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101f2c:	83 ec 0c             	sub    $0xc,%esp
80101f2f:	68 07 89 10 80       	push   $0x80108907
80101f34:	e8 57 e4 ff ff       	call   80100390 <panic>
80101f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	57                   	push   %edi
80101f44:	56                   	push   %esi
80101f45:	53                   	push   %ebx
80101f46:	89 cf                	mov    %ecx,%edi
80101f48:	89 c3                	mov    %eax,%ebx
80101f4a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f4d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101f53:	0f 84 67 01 00 00    	je     801020c0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f59:	e8 02 21 00 00       	call   80104060 <myproc>
  acquire(&icache.lock);
80101f5e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f61:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f64:	68 e0 29 11 80       	push   $0x801129e0
80101f69:	e8 42 34 00 00       	call   801053b0 <acquire>
  ip->ref++;
80101f6e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f72:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80101f79:	e8 f2 34 00 00       	call   80105470 <release>
80101f7e:	83 c4 10             	add    $0x10,%esp
80101f81:	eb 08                	jmp    80101f8b <namex+0x4b>
80101f83:	90                   	nop
80101f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f88:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f8b:	0f b6 03             	movzbl (%ebx),%eax
80101f8e:	3c 2f                	cmp    $0x2f,%al
80101f90:	74 f6                	je     80101f88 <namex+0x48>
  if(*path == 0)
80101f92:	84 c0                	test   %al,%al
80101f94:	0f 84 ee 00 00 00    	je     80102088 <namex+0x148>
  while(*path != '/' && *path != 0)
80101f9a:	0f b6 03             	movzbl (%ebx),%eax
80101f9d:	3c 2f                	cmp    $0x2f,%al
80101f9f:	0f 84 b3 00 00 00    	je     80102058 <namex+0x118>
80101fa5:	84 c0                	test   %al,%al
80101fa7:	89 da                	mov    %ebx,%edx
80101fa9:	75 09                	jne    80101fb4 <namex+0x74>
80101fab:	e9 a8 00 00 00       	jmp    80102058 <namex+0x118>
80101fb0:	84 c0                	test   %al,%al
80101fb2:	74 0a                	je     80101fbe <namex+0x7e>
    path++;
80101fb4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101fb7:	0f b6 02             	movzbl (%edx),%eax
80101fba:	3c 2f                	cmp    $0x2f,%al
80101fbc:	75 f2                	jne    80101fb0 <namex+0x70>
80101fbe:	89 d1                	mov    %edx,%ecx
80101fc0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101fc2:	83 f9 0d             	cmp    $0xd,%ecx
80101fc5:	0f 8e 91 00 00 00    	jle    8010205c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101fcb:	83 ec 04             	sub    $0x4,%esp
80101fce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fd1:	6a 0e                	push   $0xe
80101fd3:	53                   	push   %ebx
80101fd4:	57                   	push   %edi
80101fd5:	e8 96 35 00 00       	call   80105570 <memmove>
    path++;
80101fda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101fdd:	83 c4 10             	add    $0x10,%esp
    path++;
80101fe0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101fe2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101fe5:	75 11                	jne    80101ff8 <namex+0xb8>
80101fe7:	89 f6                	mov    %esi,%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ff0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ff3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ff6:	74 f8                	je     80101ff0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	56                   	push   %esi
80101ffc:	e8 5f f9 ff ff       	call   80101960 <ilock>
    if(ip->type != T_DIR){
80102001:	83 c4 10             	add    $0x10,%esp
80102004:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102009:	0f 85 91 00 00 00    	jne    801020a0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010200f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102012:	85 d2                	test   %edx,%edx
80102014:	74 09                	je     8010201f <namex+0xdf>
80102016:	80 3b 00             	cmpb   $0x0,(%ebx)
80102019:	0f 84 b7 00 00 00    	je     801020d6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010201f:	83 ec 04             	sub    $0x4,%esp
80102022:	6a 00                	push   $0x0
80102024:	57                   	push   %edi
80102025:	56                   	push   %esi
80102026:	e8 65 fe ff ff       	call   80101e90 <dirlookup>
8010202b:	83 c4 10             	add    $0x10,%esp
8010202e:	85 c0                	test   %eax,%eax
80102030:	74 6e                	je     801020a0 <namex+0x160>
  iunlock(ip);
80102032:	83 ec 0c             	sub    $0xc,%esp
80102035:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102038:	56                   	push   %esi
80102039:	e8 02 fa ff ff       	call   80101a40 <iunlock>
  iput(ip);
8010203e:	89 34 24             	mov    %esi,(%esp)
80102041:	e8 4a fa ff ff       	call   80101a90 <iput>
80102046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102049:	83 c4 10             	add    $0x10,%esp
8010204c:	89 c6                	mov    %eax,%esi
8010204e:	e9 38 ff ff ff       	jmp    80101f8b <namex+0x4b>
80102053:	90                   	nop
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102058:	89 da                	mov    %ebx,%edx
8010205a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010205c:	83 ec 04             	sub    $0x4,%esp
8010205f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102062:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102065:	51                   	push   %ecx
80102066:	53                   	push   %ebx
80102067:	57                   	push   %edi
80102068:	e8 03 35 00 00       	call   80105570 <memmove>
    name[len] = 0;
8010206d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102070:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102073:	83 c4 10             	add    $0x10,%esp
80102076:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010207a:	89 d3                	mov    %edx,%ebx
8010207c:	e9 61 ff ff ff       	jmp    80101fe2 <namex+0xa2>
80102081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102088:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010208b:	85 c0                	test   %eax,%eax
8010208d:	75 5d                	jne    801020ec <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010208f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102092:	89 f0                	mov    %esi,%eax
80102094:	5b                   	pop    %ebx
80102095:	5e                   	pop    %esi
80102096:	5f                   	pop    %edi
80102097:	5d                   	pop    %ebp
80102098:	c3                   	ret    
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801020a0:	83 ec 0c             	sub    $0xc,%esp
801020a3:	56                   	push   %esi
801020a4:	e8 97 f9 ff ff       	call   80101a40 <iunlock>
  iput(ip);
801020a9:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020ac:	31 f6                	xor    %esi,%esi
  iput(ip);
801020ae:	e8 dd f9 ff ff       	call   80101a90 <iput>
      return 0;
801020b3:	83 c4 10             	add    $0x10,%esp
}
801020b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b9:	89 f0                	mov    %esi,%eax
801020bb:	5b                   	pop    %ebx
801020bc:	5e                   	pop    %esi
801020bd:	5f                   	pop    %edi
801020be:	5d                   	pop    %ebp
801020bf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
801020c0:	ba 01 00 00 00       	mov    $0x1,%edx
801020c5:	b8 01 00 00 00       	mov    $0x1,%eax
801020ca:	e8 a1 f4 ff ff       	call   80101570 <iget>
801020cf:	89 c6                	mov    %eax,%esi
801020d1:	e9 b5 fe ff ff       	jmp    80101f8b <namex+0x4b>
      iunlock(ip);
801020d6:	83 ec 0c             	sub    $0xc,%esp
801020d9:	56                   	push   %esi
801020da:	e8 61 f9 ff ff       	call   80101a40 <iunlock>
      return ip;
801020df:	83 c4 10             	add    $0x10,%esp
}
801020e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e5:	89 f0                	mov    %esi,%eax
801020e7:	5b                   	pop    %ebx
801020e8:	5e                   	pop    %esi
801020e9:	5f                   	pop    %edi
801020ea:	5d                   	pop    %ebp
801020eb:	c3                   	ret    
    iput(ip);
801020ec:	83 ec 0c             	sub    $0xc,%esp
801020ef:	56                   	push   %esi
    return 0;
801020f0:	31 f6                	xor    %esi,%esi
    iput(ip);
801020f2:	e8 99 f9 ff ff       	call   80101a90 <iput>
    return 0;
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	eb 93                	jmp    8010208f <namex+0x14f>
801020fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102100 <dirlink>:
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 20             	sub    $0x20,%esp
80102109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010210c:	6a 00                	push   $0x0
8010210e:	ff 75 0c             	pushl  0xc(%ebp)
80102111:	53                   	push   %ebx
80102112:	e8 79 fd ff ff       	call   80101e90 <dirlookup>
80102117:	83 c4 10             	add    $0x10,%esp
8010211a:	85 c0                	test   %eax,%eax
8010211c:	75 67                	jne    80102185 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010211e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102121:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102124:	85 ff                	test   %edi,%edi
80102126:	74 29                	je     80102151 <dirlink+0x51>
80102128:	31 ff                	xor    %edi,%edi
8010212a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010212d:	eb 09                	jmp    80102138 <dirlink+0x38>
8010212f:	90                   	nop
80102130:	83 c7 10             	add    $0x10,%edi
80102133:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102136:	73 19                	jae    80102151 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102138:	6a 10                	push   $0x10
8010213a:	57                   	push   %edi
8010213b:	56                   	push   %esi
8010213c:	53                   	push   %ebx
8010213d:	e8 fe fa ff ff       	call   80101c40 <readi>
80102142:	83 c4 10             	add    $0x10,%esp
80102145:	83 f8 10             	cmp    $0x10,%eax
80102148:	75 4e                	jne    80102198 <dirlink+0x98>
    if(de.inum == 0)
8010214a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010214f:	75 df                	jne    80102130 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102151:	8d 45 da             	lea    -0x26(%ebp),%eax
80102154:	83 ec 04             	sub    $0x4,%esp
80102157:	6a 0e                	push   $0xe
80102159:	ff 75 0c             	pushl  0xc(%ebp)
8010215c:	50                   	push   %eax
8010215d:	e8 de 34 00 00       	call   80105640 <strncpy>
  de.inum = inum;
80102162:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102165:	6a 10                	push   $0x10
80102167:	57                   	push   %edi
80102168:	56                   	push   %esi
80102169:	53                   	push   %ebx
  de.inum = inum;
8010216a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010216e:	e8 cd fb ff ff       	call   80101d40 <writei>
80102173:	83 c4 20             	add    $0x20,%esp
80102176:	83 f8 10             	cmp    $0x10,%eax
80102179:	75 2a                	jne    801021a5 <dirlink+0xa5>
  return 0;
8010217b:	31 c0                	xor    %eax,%eax
}
8010217d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102180:	5b                   	pop    %ebx
80102181:	5e                   	pop    %esi
80102182:	5f                   	pop    %edi
80102183:	5d                   	pop    %ebp
80102184:	c3                   	ret    
    iput(ip);
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	50                   	push   %eax
80102189:	e8 02 f9 ff ff       	call   80101a90 <iput>
    return -1;
8010218e:	83 c4 10             	add    $0x10,%esp
80102191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102196:	eb e5                	jmp    8010217d <dirlink+0x7d>
      panic("dirlink read");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 28 89 10 80       	push   $0x80108928
801021a0:	e8 eb e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 51 90 10 80       	push   $0x80109051
801021ad:	e8 de e1 ff ff       	call   80100390 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <namei>:

struct inode*
namei(char *path)
{
801021c0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021c1:	31 d2                	xor    %edx,%edx
{
801021c3:	89 e5                	mov    %esp,%ebp
801021c5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021c8:	8b 45 08             	mov    0x8(%ebp),%eax
801021cb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021ce:	e8 6d fd ff ff       	call   80101f40 <namex>
}
801021d3:	c9                   	leave  
801021d4:	c3                   	ret    
801021d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021e0:	55                   	push   %ebp
  return namex(path, 1, name);
801021e1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021e6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021ee:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021ef:	e9 4c fd ff ff       	jmp    80101f40 <namex>
801021f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102200 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102200:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102201:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80102206:	89 e5                	mov    %esp,%ebp
80102208:	57                   	push   %edi
80102209:	56                   	push   %esi
8010220a:	53                   	push   %ebx
8010220b:	83 ec 10             	sub    $0x10,%esp
8010220e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102211:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80102218:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
8010221f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80102223:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80102227:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
8010222a:	85 c9                	test   %ecx,%ecx
8010222c:	79 0a                	jns    80102238 <itoa+0x38>
8010222e:	89 f0                	mov    %esi,%eax
80102230:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102233:	f7 d9                	neg    %ecx
        *p++ = '-';
80102235:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102238:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010223a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010223f:	90                   	nop
80102240:	89 d8                	mov    %ebx,%eax
80102242:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102245:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102248:	f7 ef                	imul   %edi
8010224a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010224d:	29 da                	sub    %ebx,%edx
8010224f:	89 d3                	mov    %edx,%ebx
80102251:	75 ed                	jne    80102240 <itoa+0x40>
    *p = '\0';
80102253:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102256:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010225b:	90                   	nop
8010225c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102260:	89 c8                	mov    %ecx,%eax
80102262:	83 ee 01             	sub    $0x1,%esi
80102265:	f7 eb                	imul   %ebx
80102267:	89 c8                	mov    %ecx,%eax
80102269:	c1 f8 1f             	sar    $0x1f,%eax
8010226c:	c1 fa 02             	sar    $0x2,%edx
8010226f:	29 c2                	sub    %eax,%edx
80102271:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102274:	01 c0                	add    %eax,%eax
80102276:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102278:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010227a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010227f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102281:	88 06                	mov    %al,(%esi)
    }while(i);
80102283:	75 db                	jne    80102260 <itoa+0x60>
    return b;
}
80102285:	8b 45 0c             	mov    0xc(%ebp),%eax
80102288:	83 c4 10             	add    $0x10,%esp
8010228b:	5b                   	pop    %ebx
8010228c:	5e                   	pop    %esi
8010228d:	5f                   	pop    %edi
8010228e:	5d                   	pop    %ebp
8010228f:	c3                   	ret    

80102290 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102296:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102299:	83 ec 40             	sub    $0x40,%esp
8010229c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010229f:	6a 06                	push   $0x6
801022a1:	68 35 89 10 80       	push   $0x80108935
801022a6:	56                   	push   %esi
801022a7:	e8 c4 32 00 00       	call   80105570 <memmove>
  itoa(p->pid, path+ 6);
801022ac:	58                   	pop    %eax
801022ad:	8d 45 c2             	lea    -0x3e(%ebp),%eax
801022b0:	5a                   	pop    %edx
801022b1:	50                   	push   %eax
801022b2:	ff 73 10             	pushl  0x10(%ebx)
801022b5:	e8 46 ff ff ff       	call   80102200 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
801022ba:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022bd:	83 c4 10             	add    $0x10,%esp
801022c0:	85 c0                	test   %eax,%eax
801022c2:	0f 84 88 01 00 00    	je     80102450 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
801022c8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801022cb:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801022ce:	50                   	push   %eax
801022cf:	e8 4c ee ff ff       	call   80101120 <fileclose>

  begin_op();
801022d4:	e8 b7 10 00 00       	call   80103390 <begin_op>
  return namex(path, 1, name);
801022d9:	89 f0                	mov    %esi,%eax
801022db:	89 d9                	mov    %ebx,%ecx
801022dd:	ba 01 00 00 00       	mov    $0x1,%edx
801022e2:	e8 59 fc ff ff       	call   80101f40 <namex>
  if((dp = nameiparent(path, name)) == 0)
801022e7:	83 c4 10             	add    $0x10,%esp
801022ea:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801022ec:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801022ee:	0f 84 66 01 00 00    	je     8010245a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801022f4:	83 ec 0c             	sub    $0xc,%esp
801022f7:	50                   	push   %eax
801022f8:	e8 63 f6 ff ff       	call   80101960 <ilock>
  return strncmp(s, t, DIRSIZ);
801022fd:	83 c4 0c             	add    $0xc,%esp
80102300:	6a 0e                	push   $0xe
80102302:	68 3d 89 10 80       	push   $0x8010893d
80102307:	53                   	push   %ebx
80102308:	e8 d3 32 00 00       	call   801055e0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 c0                	test   %eax,%eax
80102312:	0f 84 f8 00 00 00    	je     80102410 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102318:	83 ec 04             	sub    $0x4,%esp
8010231b:	6a 0e                	push   $0xe
8010231d:	68 3c 89 10 80       	push   $0x8010893c
80102322:	53                   	push   %ebx
80102323:	e8 b8 32 00 00       	call   801055e0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102328:	83 c4 10             	add    $0x10,%esp
8010232b:	85 c0                	test   %eax,%eax
8010232d:	0f 84 dd 00 00 00    	je     80102410 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102333:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102336:	83 ec 04             	sub    $0x4,%esp
80102339:	50                   	push   %eax
8010233a:	53                   	push   %ebx
8010233b:	56                   	push   %esi
8010233c:	e8 4f fb ff ff       	call   80101e90 <dirlookup>
80102341:	83 c4 10             	add    $0x10,%esp
80102344:	85 c0                	test   %eax,%eax
80102346:	89 c3                	mov    %eax,%ebx
80102348:	0f 84 c2 00 00 00    	je     80102410 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010234e:	83 ec 0c             	sub    $0xc,%esp
80102351:	50                   	push   %eax
80102352:	e8 09 f6 ff ff       	call   80101960 <ilock>

  if(ip->nlink < 1)
80102357:	83 c4 10             	add    $0x10,%esp
8010235a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010235f:	0f 8e 11 01 00 00    	jle    80102476 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102365:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010236a:	74 74                	je     801023e0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010236c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010236f:	83 ec 04             	sub    $0x4,%esp
80102372:	6a 10                	push   $0x10
80102374:	6a 00                	push   $0x0
80102376:	57                   	push   %edi
80102377:	e8 44 31 00 00       	call   801054c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010237c:	6a 10                	push   $0x10
8010237e:	ff 75 b8             	pushl  -0x48(%ebp)
80102381:	57                   	push   %edi
80102382:	56                   	push   %esi
80102383:	e8 b8 f9 ff ff       	call   80101d40 <writei>
80102388:	83 c4 20             	add    $0x20,%esp
8010238b:	83 f8 10             	cmp    $0x10,%eax
8010238e:	0f 85 d5 00 00 00    	jne    80102469 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102394:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102399:	0f 84 91 00 00 00    	je     80102430 <removeSwapFile+0x1a0>
  iunlock(ip);
8010239f:	83 ec 0c             	sub    $0xc,%esp
801023a2:	56                   	push   %esi
801023a3:	e8 98 f6 ff ff       	call   80101a40 <iunlock>
  iput(ip);
801023a8:	89 34 24             	mov    %esi,(%esp)
801023ab:	e8 e0 f6 ff ff       	call   80101a90 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801023b0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801023b5:	89 1c 24             	mov    %ebx,(%esp)
801023b8:	e8 f3 f4 ff ff       	call   801018b0 <iupdate>
  iunlock(ip);
801023bd:	89 1c 24             	mov    %ebx,(%esp)
801023c0:	e8 7b f6 ff ff       	call   80101a40 <iunlock>
  iput(ip);
801023c5:	89 1c 24             	mov    %ebx,(%esp)
801023c8:	e8 c3 f6 ff ff       	call   80101a90 <iput>
  iunlockput(ip);

  end_op();
801023cd:	e8 2e 10 00 00       	call   80103400 <end_op>

  return 0;
801023d2:	83 c4 10             	add    $0x10,%esp
801023d5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801023d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023da:	5b                   	pop    %ebx
801023db:	5e                   	pop    %esi
801023dc:	5f                   	pop    %edi
801023dd:	5d                   	pop    %ebp
801023de:	c3                   	ret    
801023df:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801023e0:	83 ec 0c             	sub    $0xc,%esp
801023e3:	53                   	push   %ebx
801023e4:	e8 b7 38 00 00       	call   80105ca0 <isdirempty>
801023e9:	83 c4 10             	add    $0x10,%esp
801023ec:	85 c0                	test   %eax,%eax
801023ee:	0f 85 78 ff ff ff    	jne    8010236c <removeSwapFile+0xdc>
  iunlock(ip);
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	53                   	push   %ebx
801023f8:	e8 43 f6 ff ff       	call   80101a40 <iunlock>
  iput(ip);
801023fd:	89 1c 24             	mov    %ebx,(%esp)
80102400:	e8 8b f6 ff ff       	call   80101a90 <iput>
80102405:	83 c4 10             	add    $0x10,%esp
80102408:	90                   	nop
80102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	56                   	push   %esi
80102414:	e8 27 f6 ff ff       	call   80101a40 <iunlock>
  iput(ip);
80102419:	89 34 24             	mov    %esi,(%esp)
8010241c:	e8 6f f6 ff ff       	call   80101a90 <iput>
    end_op();
80102421:	e8 da 0f 00 00       	call   80103400 <end_op>
    return -1;
80102426:	83 c4 10             	add    $0x10,%esp
80102429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010242e:	eb a7                	jmp    801023d7 <removeSwapFile+0x147>
    dp->nlink--;
80102430:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102435:	83 ec 0c             	sub    $0xc,%esp
80102438:	56                   	push   %esi
80102439:	e8 72 f4 ff ff       	call   801018b0 <iupdate>
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	e9 59 ff ff ff       	jmp    8010239f <removeSwapFile+0x10f>
80102446:	8d 76 00             	lea    0x0(%esi),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102455:	e9 7d ff ff ff       	jmp    801023d7 <removeSwapFile+0x147>
    end_op();
8010245a:	e8 a1 0f 00 00       	call   80103400 <end_op>
    return -1;
8010245f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102464:	e9 6e ff ff ff       	jmp    801023d7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102469:	83 ec 0c             	sub    $0xc,%esp
8010246c:	68 51 89 10 80       	push   $0x80108951
80102471:	e8 1a df ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102476:	83 ec 0c             	sub    $0xc,%esp
80102479:	68 3f 89 10 80       	push   $0x8010893f
8010247e:	e8 0d df ff ff       	call   80100390 <panic>
80102483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102495:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102498:	83 ec 14             	sub    $0x14,%esp
8010249b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010249e:	6a 06                	push   $0x6
801024a0:	68 35 89 10 80       	push   $0x80108935
801024a5:	56                   	push   %esi
801024a6:	e8 c5 30 00 00       	call   80105570 <memmove>
  itoa(p->pid, path+ 6);
801024ab:	58                   	pop    %eax
801024ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
801024af:	5a                   	pop    %edx
801024b0:	50                   	push   %eax
801024b1:	ff 73 10             	pushl  0x10(%ebx)
801024b4:	e8 47 fd ff ff       	call   80102200 <itoa>

    begin_op();
801024b9:	e8 d2 0e 00 00       	call   80103390 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801024be:	6a 00                	push   $0x0
801024c0:	6a 00                	push   $0x0
801024c2:	6a 02                	push   $0x2
801024c4:	56                   	push   %esi
801024c5:	e8 e6 39 00 00       	call   80105eb0 <create>
  iunlock(in);
801024ca:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
801024cd:	89 c6                	mov    %eax,%esi
  iunlock(in);
801024cf:	50                   	push   %eax
801024d0:	e8 6b f5 ff ff       	call   80101a40 <iunlock>

  p->swapFile = filealloc();
801024d5:	e8 86 eb ff ff       	call   80101060 <filealloc>
  if (p->swapFile == 0)
801024da:	83 c4 10             	add    $0x10,%esp
801024dd:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
801024df:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801024e2:	74 32                	je     80102516 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801024e4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801024e7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024ea:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801024f0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024f3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801024fa:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024fd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102501:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102504:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102508:	e8 f3 0e 00 00       	call   80103400 <end_op>

    return 0;
}
8010250d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102510:	31 c0                	xor    %eax,%eax
80102512:	5b                   	pop    %ebx
80102513:	5e                   	pop    %esi
80102514:	5d                   	pop    %ebp
80102515:	c3                   	ret    
    panic("no slot for files on /store");
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	68 60 89 10 80       	push   $0x80108960
8010251e:	e8 6d de ff ff       	call   80100390 <panic>
80102523:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102530 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102536:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102539:	8b 50 7c             	mov    0x7c(%eax),%edx
8010253c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010253f:	8b 55 14             	mov    0x14(%ebp),%edx
80102542:	89 55 10             	mov    %edx,0x10(%ebp)
80102545:	8b 40 7c             	mov    0x7c(%eax),%eax
80102548:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010254b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010254c:	e9 7f ed ff ff       	jmp    801012d0 <filewrite>
80102551:	eb 0d                	jmp    80102560 <readFromSwapFile>
80102553:	90                   	nop
80102554:	90                   	nop
80102555:	90                   	nop
80102556:	90                   	nop
80102557:	90                   	nop
80102558:	90                   	nop
80102559:	90                   	nop
8010255a:	90                   	nop
8010255b:	90                   	nop
8010255c:	90                   	nop
8010255d:	90                   	nop
8010255e:	90                   	nop
8010255f:	90                   	nop

80102560 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102566:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102569:	8b 50 7c             	mov    0x7c(%eax),%edx
8010256c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010256f:	8b 55 14             	mov    0x14(%ebp),%edx
80102572:	89 55 10             	mov    %edx,0x10(%ebp)
80102575:	8b 40 7c             	mov    0x7c(%eax),%eax
80102578:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010257b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010257c:	e9 bf ec ff ff       	jmp    80101240 <fileread>
80102581:	66 90                	xchg   %ax,%ax
80102583:	66 90                	xchg   %ax,%ax
80102585:	66 90                	xchg   %ax,%ax
80102587:	66 90                	xchg   %ax,%ax
80102589:	66 90                	xchg   %ax,%ax
8010258b:	66 90                	xchg   %ax,%ax
8010258d:	66 90                	xchg   %ax,%ax
8010258f:	90                   	nop

80102590 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	57                   	push   %edi
80102594:	56                   	push   %esi
80102595:	53                   	push   %ebx
80102596:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102599:	85 c0                	test   %eax,%eax
8010259b:	0f 84 b4 00 00 00    	je     80102655 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801025a1:	8b 58 08             	mov    0x8(%eax),%ebx
801025a4:	89 c6                	mov    %eax,%esi
801025a6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801025ac:	0f 87 96 00 00 00    	ja     80102648 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801025b7:	89 f6                	mov    %esi,%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801025c0:	89 ca                	mov    %ecx,%edx
801025c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025c3:	83 e0 c0             	and    $0xffffffc0,%eax
801025c6:	3c 40                	cmp    $0x40,%al
801025c8:	75 f6                	jne    801025c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025ca:	31 ff                	xor    %edi,%edi
801025cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801025d1:	89 f8                	mov    %edi,%eax
801025d3:	ee                   	out    %al,(%dx)
801025d4:	b8 01 00 00 00       	mov    $0x1,%eax
801025d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801025de:	ee                   	out    %al,(%dx)
801025df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025e4:	89 d8                	mov    %ebx,%eax
801025e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025e7:	89 d8                	mov    %ebx,%eax
801025e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025ee:	c1 f8 08             	sar    $0x8,%eax
801025f1:	ee                   	out    %al,(%dx)
801025f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025f7:	89 f8                	mov    %edi,%eax
801025f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025fa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801025fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102603:	c1 e0 04             	shl    $0x4,%eax
80102606:	83 e0 10             	and    $0x10,%eax
80102609:	83 c8 e0             	or     $0xffffffe0,%eax
8010260c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010260d:	f6 06 04             	testb  $0x4,(%esi)
80102610:	75 16                	jne    80102628 <idestart+0x98>
80102612:	b8 20 00 00 00       	mov    $0x20,%eax
80102617:	89 ca                	mov    %ecx,%edx
80102619:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010261a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010261d:	5b                   	pop    %ebx
8010261e:	5e                   	pop    %esi
8010261f:	5f                   	pop    %edi
80102620:	5d                   	pop    %ebp
80102621:	c3                   	ret    
80102622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102628:	b8 30 00 00 00       	mov    $0x30,%eax
8010262d:	89 ca                	mov    %ecx,%edx
8010262f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102630:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102635:	83 c6 5c             	add    $0x5c,%esi
80102638:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010263d:	fc                   	cld    
8010263e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102640:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102643:	5b                   	pop    %ebx
80102644:	5e                   	pop    %esi
80102645:	5f                   	pop    %edi
80102646:	5d                   	pop    %ebp
80102647:	c3                   	ret    
    panic("incorrect blockno");
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	68 d8 89 10 80       	push   $0x801089d8
80102650:	e8 3b dd ff ff       	call   80100390 <panic>
    panic("idestart");
80102655:	83 ec 0c             	sub    $0xc,%esp
80102658:	68 cf 89 10 80       	push   $0x801089cf
8010265d:	e8 2e dd ff ff       	call   80100390 <panic>
80102662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <ideinit>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102676:	68 ea 89 10 80       	push   $0x801089ea
8010267b:	68 80 c5 10 80       	push   $0x8010c580
80102680:	e8 eb 2b 00 00       	call   80105270 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102685:	58                   	pop    %eax
80102686:	a1 20 4d 18 80       	mov    0x80184d20,%eax
8010268b:	5a                   	pop    %edx
8010268c:	83 e8 01             	sub    $0x1,%eax
8010268f:	50                   	push   %eax
80102690:	6a 0e                	push   $0xe
80102692:	e8 a9 02 00 00       	call   80102940 <ioapicenable>
80102697:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010269a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010269f:	90                   	nop
801026a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026a1:	83 e0 c0             	and    $0xffffffc0,%eax
801026a4:	3c 40                	cmp    $0x40,%al
801026a6:	75 f8                	jne    801026a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801026ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026b2:	ee                   	out    %al,(%dx)
801026b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026bd:	eb 06                	jmp    801026c5 <ideinit+0x55>
801026bf:	90                   	nop
  for(i=0; i<1000; i++){
801026c0:	83 e9 01             	sub    $0x1,%ecx
801026c3:	74 0f                	je     801026d4 <ideinit+0x64>
801026c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026c6:	84 c0                	test   %al,%al
801026c8:	74 f6                	je     801026c0 <ideinit+0x50>
      havedisk1 = 1;
801026ca:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
801026d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801026d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026de:	ee                   	out    %al,(%dx)
}
801026df:	c9                   	leave  
801026e0:	c3                   	ret    
801026e1:	eb 0d                	jmp    801026f0 <ideintr>
801026e3:	90                   	nop
801026e4:	90                   	nop
801026e5:	90                   	nop
801026e6:	90                   	nop
801026e7:	90                   	nop
801026e8:	90                   	nop
801026e9:	90                   	nop
801026ea:	90                   	nop
801026eb:	90                   	nop
801026ec:	90                   	nop
801026ed:	90                   	nop
801026ee:	90                   	nop
801026ef:	90                   	nop

801026f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	57                   	push   %edi
801026f4:	56                   	push   %esi
801026f5:	53                   	push   %ebx
801026f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026f9:	68 80 c5 10 80       	push   $0x8010c580
801026fe:	e8 ad 2c 00 00       	call   801053b0 <acquire>

  if((b = idequeue) == 0){
80102703:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102709:	83 c4 10             	add    $0x10,%esp
8010270c:	85 db                	test   %ebx,%ebx
8010270e:	74 67                	je     80102777 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102710:	8b 43 58             	mov    0x58(%ebx),%eax
80102713:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102718:	8b 3b                	mov    (%ebx),%edi
8010271a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102720:	75 31                	jne    80102753 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102722:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102730:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102731:	89 c6                	mov    %eax,%esi
80102733:	83 e6 c0             	and    $0xffffffc0,%esi
80102736:	89 f1                	mov    %esi,%ecx
80102738:	80 f9 40             	cmp    $0x40,%cl
8010273b:	75 f3                	jne    80102730 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010273d:	a8 21                	test   $0x21,%al
8010273f:	75 12                	jne    80102753 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102741:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102744:	b9 80 00 00 00       	mov    $0x80,%ecx
80102749:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010274e:	fc                   	cld    
8010274f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102751:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102753:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102756:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102759:	89 f9                	mov    %edi,%ecx
8010275b:	83 c9 02             	or     $0x2,%ecx
8010275e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102760:	53                   	push   %ebx
80102761:	e8 ba 21 00 00       	call   80104920 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102766:	a1 64 c5 10 80       	mov    0x8010c564,%eax
8010276b:	83 c4 10             	add    $0x10,%esp
8010276e:	85 c0                	test   %eax,%eax
80102770:	74 05                	je     80102777 <ideintr+0x87>
    idestart(idequeue);
80102772:	e8 19 fe ff ff       	call   80102590 <idestart>
    release(&idelock);
80102777:	83 ec 0c             	sub    $0xc,%esp
8010277a:	68 80 c5 10 80       	push   $0x8010c580
8010277f:	e8 ec 2c 00 00       	call   80105470 <release>

  release(&idelock);
}
80102784:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102787:	5b                   	pop    %ebx
80102788:	5e                   	pop    %esi
80102789:	5f                   	pop    %edi
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	53                   	push   %ebx
80102794:	83 ec 10             	sub    $0x10,%esp
80102797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010279a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010279d:	50                   	push   %eax
8010279e:	e8 7d 2a 00 00       	call   80105220 <holdingsleep>
801027a3:	83 c4 10             	add    $0x10,%esp
801027a6:	85 c0                	test   %eax,%eax
801027a8:	0f 84 c6 00 00 00    	je     80102874 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027ae:	8b 03                	mov    (%ebx),%eax
801027b0:	83 e0 06             	and    $0x6,%eax
801027b3:	83 f8 02             	cmp    $0x2,%eax
801027b6:	0f 84 ab 00 00 00    	je     80102867 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801027bc:	8b 53 04             	mov    0x4(%ebx),%edx
801027bf:	85 d2                	test   %edx,%edx
801027c1:	74 0d                	je     801027d0 <iderw+0x40>
801027c3:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801027c8:	85 c0                	test   %eax,%eax
801027ca:	0f 84 b1 00 00 00    	je     80102881 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 80 c5 10 80       	push   $0x8010c580
801027d8:	e8 d3 2b 00 00       	call   801053b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027dd:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
801027e3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801027e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ed:	85 d2                	test   %edx,%edx
801027ef:	75 09                	jne    801027fa <iderw+0x6a>
801027f1:	eb 6d                	jmp    80102860 <iderw+0xd0>
801027f3:	90                   	nop
801027f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027f8:	89 c2                	mov    %eax,%edx
801027fa:	8b 42 58             	mov    0x58(%edx),%eax
801027fd:	85 c0                	test   %eax,%eax
801027ff:	75 f7                	jne    801027f8 <iderw+0x68>
80102801:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102804:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102806:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010280c:	74 42                	je     80102850 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010280e:	8b 03                	mov    (%ebx),%eax
80102810:	83 e0 06             	and    $0x6,%eax
80102813:	83 f8 02             	cmp    $0x2,%eax
80102816:	74 23                	je     8010283b <iderw+0xab>
80102818:	90                   	nop
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102820:	83 ec 08             	sub    $0x8,%esp
80102823:	68 80 c5 10 80       	push   $0x8010c580
80102828:	53                   	push   %ebx
80102829:	e8 32 1f 00 00       	call   80104760 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010282e:	8b 03                	mov    (%ebx),%eax
80102830:	83 c4 10             	add    $0x10,%esp
80102833:	83 e0 06             	and    $0x6,%eax
80102836:	83 f8 02             	cmp    $0x2,%eax
80102839:	75 e5                	jne    80102820 <iderw+0x90>
  }


  release(&idelock);
8010283b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102842:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102845:	c9                   	leave  
  release(&idelock);
80102846:	e9 25 2c 00 00       	jmp    80105470 <release>
8010284b:	90                   	nop
8010284c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102850:	89 d8                	mov    %ebx,%eax
80102852:	e8 39 fd ff ff       	call   80102590 <idestart>
80102857:	eb b5                	jmp    8010280e <iderw+0x7e>
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102860:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102865:	eb 9d                	jmp    80102804 <iderw+0x74>
    panic("iderw: nothing to do");
80102867:	83 ec 0c             	sub    $0xc,%esp
8010286a:	68 04 8a 10 80       	push   $0x80108a04
8010286f:	e8 1c db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102874:	83 ec 0c             	sub    $0xc,%esp
80102877:	68 ee 89 10 80       	push   $0x801089ee
8010287c:	e8 0f db ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102881:	83 ec 0c             	sub    $0xc,%esp
80102884:	68 19 8a 10 80       	push   $0x80108a19
80102889:	e8 02 db ff ff       	call   80100390 <panic>
8010288e:	66 90                	xchg   %ax,%ax

80102890 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102890:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102891:	c7 05 34 46 11 80 00 	movl   $0xfec00000,0x80114634
80102898:	00 c0 fe 
{
8010289b:	89 e5                	mov    %esp,%ebp
8010289d:	56                   	push   %esi
8010289e:	53                   	push   %ebx
  ioapic->reg = reg;
8010289f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801028a6:	00 00 00 
  return ioapic->data;
801028a9:	a1 34 46 11 80       	mov    0x80114634,%eax
801028ae:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801028b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801028b7:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801028bd:	0f b6 15 80 47 18 80 	movzbl 0x80184780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028c4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801028c7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028ca:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801028cd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801028d0:	39 c2                	cmp    %eax,%edx
801028d2:	74 16                	je     801028ea <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028d4:	83 ec 0c             	sub    $0xc,%esp
801028d7:	68 38 8a 10 80       	push   $0x80108a38
801028dc:	e8 7f dd ff ff       	call   80100660 <cprintf>
801028e1:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
801028e7:	83 c4 10             	add    $0x10,%esp
801028ea:	83 c3 21             	add    $0x21,%ebx
{
801028ed:	ba 10 00 00 00       	mov    $0x10,%edx
801028f2:	b8 20 00 00 00       	mov    $0x20,%eax
801028f7:	89 f6                	mov    %esi,%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102900:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102902:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102908:	89 c6                	mov    %eax,%esi
8010290a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102910:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102913:	89 71 10             	mov    %esi,0x10(%ecx)
80102916:	8d 72 01             	lea    0x1(%edx),%esi
80102919:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010291c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010291e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102920:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
80102926:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010292d:	75 d1                	jne    80102900 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010292f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102932:	5b                   	pop    %ebx
80102933:	5e                   	pop    %esi
80102934:	5d                   	pop    %ebp
80102935:	c3                   	ret    
80102936:	8d 76 00             	lea    0x0(%esi),%esi
80102939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102940 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102940:	55                   	push   %ebp
  ioapic->reg = reg;
80102941:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
{
80102947:	89 e5                	mov    %esp,%ebp
80102949:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010294c:	8d 50 20             	lea    0x20(%eax),%edx
8010294f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102953:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102955:	8b 0d 34 46 11 80    	mov    0x80114634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010295b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010295e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102961:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102964:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102966:	a1 34 46 11 80       	mov    0x80114634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010296b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010296e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102971:	5d                   	pop    %ebp
80102972:	c3                   	ret    
80102973:	66 90                	xchg   %ax,%ax
80102975:	66 90                	xchg   %ax,%ax
80102977:	66 90                	xchg   %ax,%ax
80102979:	66 90                	xchg   %ax,%ax
8010297b:	66 90                	xchg   %ax,%ax
8010297d:	66 90                	xchg   %ax,%ax
8010297f:	90                   	nop

80102980 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	53                   	push   %ebx
80102984:	83 ec 04             	sub    $0x4,%esp
80102987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;
  kmem.numFreePages=kmem.numFreePages+1;
8010298a:	83 05 7c 46 18 80 01 	addl   $0x1,0x8018467c
  
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102991:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102997:	75 79                	jne    80102a12 <kfree+0x92>
80102999:	81 fb 18 3c 1a 80    	cmp    $0x801a3c18,%ebx
8010299f:	72 71                	jb     80102a12 <kfree+0x92>
801029a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801029a7:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801029ac:	77 64                	ja     80102a12 <kfree+0x92>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801029ae:	83 ec 04             	sub    $0x4,%esp
801029b1:	68 00 10 00 00       	push   $0x1000
801029b6:	6a 01                	push   $0x1
801029b8:	53                   	push   %ebx
801029b9:	e8 02 2b 00 00       	call   801054c0 <memset>

  if(kmem.use_lock)
801029be:	8b 15 74 46 11 80    	mov    0x80114674,%edx
801029c4:	83 c4 10             	add    $0x10,%esp
801029c7:	85 d2                	test   %edx,%edx
801029c9:	75 35                	jne    80102a00 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801029cb:	a1 78 46 11 80       	mov    0x80114678,%eax
801029d0:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801029d2:	a1 74 46 11 80       	mov    0x80114674,%eax
  kmem.freelist = r;
801029d7:	89 1d 78 46 11 80    	mov    %ebx,0x80114678
  if(kmem.use_lock)
801029dd:	85 c0                	test   %eax,%eax
801029df:	75 0f                	jne    801029f0 <kfree+0x70>
    release(&kmem.lock);
}
801029e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029e4:	c9                   	leave  
801029e5:	c3                   	ret    
801029e6:	8d 76 00             	lea    0x0(%esi),%esi
801029e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&kmem.lock);
801029f0:	c7 45 08 40 46 11 80 	movl   $0x80114640,0x8(%ebp)
}
801029f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029fa:	c9                   	leave  
    release(&kmem.lock);
801029fb:	e9 70 2a 00 00       	jmp    80105470 <release>
    acquire(&kmem.lock);
80102a00:	83 ec 0c             	sub    $0xc,%esp
80102a03:	68 40 46 11 80       	push   $0x80114640
80102a08:	e8 a3 29 00 00       	call   801053b0 <acquire>
80102a0d:	83 c4 10             	add    $0x10,%esp
80102a10:	eb b9                	jmp    801029cb <kfree+0x4b>
    panic("kfree");
80102a12:	83 ec 0c             	sub    $0xc,%esp
80102a15:	68 6a 8a 10 80       	push   $0x80108a6a
80102a1a:	e8 71 d9 ff ff       	call   80100390 <panic>
80102a1f:	90                   	nop

80102a20 <freerange>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
80102a24:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a25:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a28:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a3d:	39 de                	cmp    %ebx,%esi
80102a3f:	72 23                	jb     80102a64 <freerange+0x44>
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a48:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102a4e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a57:	50                   	push   %eax
80102a58:	e8 23 ff ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a5d:	83 c4 10             	add    $0x10,%esp
80102a60:	39 f3                	cmp    %esi,%ebx
80102a62:	76 e4                	jbe    80102a48 <freerange+0x28>
}
80102a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a67:	5b                   	pop    %ebx
80102a68:	5e                   	pop    %esi
80102a69:	5d                   	pop    %ebp
80102a6a:	c3                   	ret    
80102a6b:	90                   	nop
80102a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a70 <kinit1>:
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a78:	83 ec 08             	sub    $0x8,%esp
80102a7b:	68 70 8a 10 80       	push   $0x80108a70
80102a80:	68 40 46 11 80       	push   $0x80114640
80102a85:	e8 e6 27 00 00       	call   80105270 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a8d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a90:	c7 05 74 46 11 80 00 	movl   $0x0,0x80114674
80102a97:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a9a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102aa0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aa6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aac:	39 de                	cmp    %ebx,%esi
80102aae:	72 1c                	jb     80102acc <kinit1+0x5c>
    kfree(p);
80102ab0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102ab6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ab9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102abf:	50                   	push   %eax
80102ac0:	e8 bb fe ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ac5:	83 c4 10             	add    $0x10,%esp
80102ac8:	39 de                	cmp    %ebx,%esi
80102aca:	73 e4                	jae    80102ab0 <kinit1+0x40>
  kmem.numFreePages=0;
80102acc:	c7 05 7c 46 18 80 00 	movl   $0x0,0x8018467c
80102ad3:	00 00 00 
}
80102ad6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ad9:	5b                   	pop    %ebx
80102ada:	5e                   	pop    %esi
80102adb:	5d                   	pop    %ebp
80102adc:	c3                   	ret    
80102add:	8d 76 00             	lea    0x0(%esi),%esi

80102ae0 <kinit2>:
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102ae5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102ae8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102aeb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102af1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102af7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102afd:	39 de                	cmp    %ebx,%esi
80102aff:	72 23                	jb     80102b24 <kinit2+0x44>
80102b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102b08:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102b0e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b17:	50                   	push   %eax
80102b18:	e8 63 fe ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b1d:	83 c4 10             	add    $0x10,%esp
80102b20:	39 de                	cmp    %ebx,%esi
80102b22:	73 e4                	jae    80102b08 <kinit2+0x28>
  kmem.use_lock = 1;
80102b24:	c7 05 74 46 11 80 01 	movl   $0x1,0x80114674
80102b2b:	00 00 00 
}
80102b2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b31:	5b                   	pop    %ebx
80102b32:	5e                   	pop    %esi
80102b33:	5d                   	pop    %ebp
80102b34:	c3                   	ret    
80102b35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b40 <kalloc>:
kalloc(void)
{
  struct run *r;
   kmem.numFreePages=kmem.numFreePages-1;
   
  if(kmem.use_lock)
80102b40:	a1 74 46 11 80       	mov    0x80114674,%eax
   kmem.numFreePages=kmem.numFreePages-1;
80102b45:	83 2d 7c 46 18 80 01 	subl   $0x1,0x8018467c
  if(kmem.use_lock)
80102b4c:	85 c0                	test   %eax,%eax
80102b4e:	75 20                	jne    80102b70 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b50:	a1 78 46 11 80       	mov    0x80114678,%eax
  if(r)
80102b55:	85 c0                	test   %eax,%eax
80102b57:	74 0f                	je     80102b68 <kalloc+0x28>
    kmem.freelist = r->next;
80102b59:	8b 10                	mov    (%eax),%edx
80102b5b:	89 15 78 46 11 80    	mov    %edx,0x80114678
80102b61:	c3                   	ret    
80102b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102b68:	f3 c3                	repz ret 
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b76:	68 40 46 11 80       	push   $0x80114640
80102b7b:	e8 30 28 00 00       	call   801053b0 <acquire>
  r = kmem.freelist;
80102b80:	a1 78 46 11 80       	mov    0x80114678,%eax
  if(r)
80102b85:	83 c4 10             	add    $0x10,%esp
80102b88:	8b 15 74 46 11 80    	mov    0x80114674,%edx
80102b8e:	85 c0                	test   %eax,%eax
80102b90:	74 08                	je     80102b9a <kalloc+0x5a>
    kmem.freelist = r->next;
80102b92:	8b 08                	mov    (%eax),%ecx
80102b94:	89 0d 78 46 11 80    	mov    %ecx,0x80114678
  if(kmem.use_lock)
80102b9a:	85 d2                	test   %edx,%edx
80102b9c:	74 16                	je     80102bb4 <kalloc+0x74>
    release(&kmem.lock);
80102b9e:	83 ec 0c             	sub    $0xc,%esp
80102ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102ba4:	68 40 46 11 80       	push   $0x80114640
80102ba9:	e8 c2 28 00 00       	call   80105470 <release>
  return (char*)r;
80102bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102bb1:	83 c4 10             	add    $0x10,%esp
}
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    
80102bb6:	8d 76 00             	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <kinc>:

/////////////////ASSIGNMENT 3////////////////////////
void
kinc(char *v) //increase number of 'links' to the page
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	53                   	push   %ebx
80102bc4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102bc7:	8b 15 74 46 11 80    	mov    0x80114674,%edx
{
80102bcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102bd0:	85 d2                	test   %edx,%edx
80102bd2:	75 1c                	jne    80102bf0 <kinc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102bd4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102bda:	c1 e8 0c             	shr    $0xc,%eax
  r->ref += 1;
80102bdd:	83 04 c5 80 46 11 80 	addl   $0x1,-0x7feeb980(,%eax,8)
80102be4:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102be8:	c9                   	leave  
80102be9:	c3                   	ret    
80102bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102bf0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102bf3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102bf9:	68 40 46 11 80       	push   $0x80114640
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102bfe:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102c01:	e8 aa 27 00 00       	call   801053b0 <acquire>
  if(kmem.use_lock)
80102c06:	a1 74 46 11 80       	mov    0x80114674,%eax
  r->ref += 1;
80102c0b:	83 04 dd 80 46 11 80 	addl   $0x1,-0x7feeb980(,%ebx,8)
80102c12:	01 
  if(kmem.use_lock)
80102c13:	83 c4 10             	add    $0x10,%esp
80102c16:	85 c0                	test   %eax,%eax
80102c18:	74 cb                	je     80102be5 <kinc+0x25>
    release(&kmem.lock);
80102c1a:	c7 45 08 40 46 11 80 	movl   $0x80114640,0x8(%ebp)
}
80102c21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c24:	c9                   	leave  
    release(&kmem.lock);
80102c25:	e9 46 28 00 00       	jmp    80105470 <release>
80102c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c30 <kdec>:

void kdec(char* v){ //decrease number of 'links' to the page
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102c37:	8b 15 74 46 11 80    	mov    0x80114674,%edx
void kdec(char* v){ //decrease number of 'links' to the page
80102c3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102c40:	85 d2                	test   %edx,%edx
80102c42:	75 1c                	jne    80102c60 <kdec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c44:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102c4a:	c1 e8 0c             	shr    $0xc,%eax
  r->ref -= 1;
80102c4d:	83 2c c5 80 46 11 80 	subl   $0x1,-0x7feeb980(,%eax,8)
80102c54:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c58:	c9                   	leave  
80102c59:	c3                   	ret    
80102c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102c60:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c63:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102c69:	68 40 46 11 80       	push   $0x80114640
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102c6e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102c71:	e8 3a 27 00 00       	call   801053b0 <acquire>
  if(kmem.use_lock)
80102c76:	a1 74 46 11 80       	mov    0x80114674,%eax
  r->ref -= 1;
80102c7b:	83 2c dd 80 46 11 80 	subl   $0x1,-0x7feeb980(,%ebx,8)
80102c82:	01 
  if(kmem.use_lock)
80102c83:	83 c4 10             	add    $0x10,%esp
80102c86:	85 c0                	test   %eax,%eax
80102c88:	74 cb                	je     80102c55 <kdec+0x25>
    release(&kmem.lock);
80102c8a:	c7 45 08 40 46 11 80 	movl   $0x80114640,0x8(%ebp)
}
80102c91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c94:	c9                   	leave  
    release(&kmem.lock);
80102c95:	e9 d6 27 00 00       	jmp    80105470 <release>
80102c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ca0 <getRefs>:

int getRefs(char* v){
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
  struct run* r;
  r = &kmem.runs[(V2P(v)/PGSIZE)];
80102ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->ref; 
}
80102ca6:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v)/PGSIZE)];
80102ca7:	05 00 00 00 80       	add    $0x80000000,%eax
80102cac:	c1 e8 0c             	shr    $0xc,%eax
  return r->ref; 
80102caf:	8b 04 c5 80 46 11 80 	mov    -0x7feeb980(,%eax,8),%eax
}
80102cb6:	c3                   	ret    
80102cb7:	89 f6                	mov    %esi,%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cc0 <getNumFreePages>:
////////////////END/////////////////////////
int
getNumFreePages(void)
{
if(kmem.use_lock)
80102cc0:	8b 0d 74 46 11 80    	mov    0x80114674,%ecx
acquire(&kmem.lock);
int r = kmem.numFreePages;
80102cc6:	a1 7c 46 18 80       	mov    0x8018467c,%eax
if(kmem.use_lock)
80102ccb:	85 c9                	test   %ecx,%ecx
80102ccd:	75 09                	jne    80102cd8 <getNumFreePages+0x18>
if(kmem.use_lock)
release(&kmem.lock);
return (r);
80102ccf:	f3 c3                	repz ret 
80102cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102cd8:	55                   	push   %ebp
80102cd9:	89 e5                	mov    %esp,%ebp
80102cdb:	83 ec 24             	sub    $0x24,%esp
acquire(&kmem.lock);
80102cde:	68 40 46 11 80       	push   $0x80114640
80102ce3:	e8 c8 26 00 00       	call   801053b0 <acquire>
if(kmem.use_lock)
80102ce8:	8b 15 74 46 11 80    	mov    0x80114674,%edx
80102cee:	83 c4 10             	add    $0x10,%esp
int r = kmem.numFreePages;
80102cf1:	a1 7c 46 18 80       	mov    0x8018467c,%eax
if(kmem.use_lock)
80102cf6:	85 d2                	test   %edx,%edx
80102cf8:	74 16                	je     80102d10 <getNumFreePages+0x50>
release(&kmem.lock);
80102cfa:	83 ec 0c             	sub    $0xc,%esp
80102cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d00:	68 40 46 11 80       	push   $0x80114640
80102d05:	e8 66 27 00 00       	call   80105470 <release>
80102d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d0d:	83 c4 10             	add    $0x10,%esp
80102d10:	c9                   	leave  
80102d11:	c3                   	ret    
80102d12:	66 90                	xchg   %ax,%ax
80102d14:	66 90                	xchg   %ax,%ax
80102d16:	66 90                	xchg   %ax,%ax
80102d18:	66 90                	xchg   %ax,%ax
80102d1a:	66 90                	xchg   %ax,%ax
80102d1c:	66 90                	xchg   %ax,%ax
80102d1e:	66 90                	xchg   %ax,%ax

80102d20 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d20:	ba 64 00 00 00       	mov    $0x64,%edx
80102d25:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d26:	a8 01                	test   $0x1,%al
80102d28:	0f 84 c2 00 00 00    	je     80102df0 <kbdgetc+0xd0>
80102d2e:	ba 60 00 00 00       	mov    $0x60,%edx
80102d33:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102d34:	0f b6 d0             	movzbl %al,%edx
80102d37:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
80102d3d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102d43:	0f 84 7f 00 00 00    	je     80102dc8 <kbdgetc+0xa8>
{
80102d49:	55                   	push   %ebp
80102d4a:	89 e5                	mov    %esp,%ebp
80102d4c:	53                   	push   %ebx
80102d4d:	89 cb                	mov    %ecx,%ebx
80102d4f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102d52:	84 c0                	test   %al,%al
80102d54:	78 4a                	js     80102da0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102d56:	85 db                	test   %ebx,%ebx
80102d58:	74 09                	je     80102d63 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d5a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102d5d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102d60:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102d63:	0f b6 82 a0 8b 10 80 	movzbl -0x7fef7460(%edx),%eax
80102d6a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102d6c:	0f b6 82 a0 8a 10 80 	movzbl -0x7fef7560(%edx),%eax
80102d73:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d75:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102d77:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102d7d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102d80:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d83:	8b 04 85 80 8a 10 80 	mov    -0x7fef7580(,%eax,4),%eax
80102d8a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102d8e:	74 31                	je     80102dc1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102d90:	8d 50 9f             	lea    -0x61(%eax),%edx
80102d93:	83 fa 19             	cmp    $0x19,%edx
80102d96:	77 40                	ja     80102dd8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102d98:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102d9b:	5b                   	pop    %ebx
80102d9c:	5d                   	pop    %ebp
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102da0:	83 e0 7f             	and    $0x7f,%eax
80102da3:	85 db                	test   %ebx,%ebx
80102da5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102da8:	0f b6 82 a0 8b 10 80 	movzbl -0x7fef7460(%edx),%eax
80102daf:	83 c8 40             	or     $0x40,%eax
80102db2:	0f b6 c0             	movzbl %al,%eax
80102db5:	f7 d0                	not    %eax
80102db7:	21 c1                	and    %eax,%ecx
    return 0;
80102db9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102dbb:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102dc1:	5b                   	pop    %ebx
80102dc2:	5d                   	pop    %ebp
80102dc3:	c3                   	ret    
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102dc8:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102dcb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102dcd:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102dd3:	c3                   	ret    
80102dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102dd8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102ddb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102dde:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102ddf:	83 f9 1a             	cmp    $0x1a,%ecx
80102de2:	0f 42 c2             	cmovb  %edx,%eax
}
80102de5:	5d                   	pop    %ebp
80102de6:	c3                   	ret    
80102de7:	89 f6                	mov    %esi,%esi
80102de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102df5:	c3                   	ret    
80102df6:	8d 76 00             	lea    0x0(%esi),%esi
80102df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e00 <kbdintr>:

void
kbdintr(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e06:	68 20 2d 10 80       	push   $0x80102d20
80102e0b:	e8 00 da ff ff       	call   80100810 <consoleintr>
}
80102e10:	83 c4 10             	add    $0x10,%esp
80102e13:	c9                   	leave  
80102e14:	c3                   	ret    
80102e15:	66 90                	xchg   %ax,%ax
80102e17:	66 90                	xchg   %ax,%ax
80102e19:	66 90                	xchg   %ax,%ax
80102e1b:	66 90                	xchg   %ax,%ax
80102e1d:	66 90                	xchg   %ax,%ax
80102e1f:	90                   	nop

80102e20 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102e20:	a1 80 46 18 80       	mov    0x80184680,%eax
{
80102e25:	55                   	push   %ebp
80102e26:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102e28:	85 c0                	test   %eax,%eax
80102e2a:	0f 84 c8 00 00 00    	je     80102ef8 <lapicinit+0xd8>
  lapic[index] = value;
80102e30:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e37:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e3d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102e44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e4a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102e51:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102e54:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e57:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102e5e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102e61:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e64:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102e6b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e71:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102e78:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e7b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e7e:	8b 50 30             	mov    0x30(%eax),%edx
80102e81:	c1 ea 10             	shr    $0x10,%edx
80102e84:	80 fa 03             	cmp    $0x3,%dl
80102e87:	77 77                	ja     80102f00 <lapicinit+0xe0>
  lapic[index] = value;
80102e89:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102e90:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e93:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e96:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e9d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ea0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ea3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102eaa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ead:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eb0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102eb7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ebd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ec4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ed1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ed4:	8b 50 20             	mov    0x20(%eax),%edx
80102ed7:	89 f6                	mov    %esi,%esi
80102ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ee0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ee6:	80 e6 10             	and    $0x10,%dh
80102ee9:	75 f5                	jne    80102ee0 <lapicinit+0xc0>
  lapic[index] = value;
80102eeb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ef2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ef8:	5d                   	pop    %ebp
80102ef9:	c3                   	ret    
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102f00:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f07:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f0a:	8b 50 20             	mov    0x20(%eax),%edx
80102f0d:	e9 77 ff ff ff       	jmp    80102e89 <lapicinit+0x69>
80102f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f20 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102f20:	8b 15 80 46 18 80    	mov    0x80184680,%edx
{
80102f26:	55                   	push   %ebp
80102f27:	31 c0                	xor    %eax,%eax
80102f29:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f2b:	85 d2                	test   %edx,%edx
80102f2d:	74 06                	je     80102f35 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102f2f:	8b 42 20             	mov    0x20(%edx),%eax
80102f32:	c1 e8 18             	shr    $0x18,%eax
}
80102f35:	5d                   	pop    %ebp
80102f36:	c3                   	ret    
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102f40:	a1 80 46 18 80       	mov    0x80184680,%eax
{
80102f45:	55                   	push   %ebp
80102f46:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f48:	85 c0                	test   %eax,%eax
80102f4a:	74 0d                	je     80102f59 <lapiceoi+0x19>
  lapic[index] = value;
80102f4c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f53:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f56:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102f59:	5d                   	pop    %ebp
80102f5a:	c3                   	ret    
80102f5b:	90                   	nop
80102f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f60 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
}
80102f63:	5d                   	pop    %ebp
80102f64:	c3                   	ret    
80102f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f70 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f71:	b8 0f 00 00 00       	mov    $0xf,%eax
80102f76:	ba 70 00 00 00       	mov    $0x70,%edx
80102f7b:	89 e5                	mov    %esp,%ebp
80102f7d:	53                   	push   %ebx
80102f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102f81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f84:	ee                   	out    %al,(%dx)
80102f85:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f8a:	ba 71 00 00 00       	mov    $0x71,%edx
80102f8f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102f90:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f92:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102f95:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102f9b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f9d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102fa0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102fa3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fa5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102fa8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102fae:	a1 80 46 18 80       	mov    0x80184680,%eax
80102fb3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fb9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fbc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102fc3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fc6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fc9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102fd0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fd3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fd6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fdc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fdf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fe5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fe8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ff1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ff7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102ffa:	5b                   	pop    %ebx
80102ffb:	5d                   	pop    %ebp
80102ffc:	c3                   	ret    
80102ffd:	8d 76 00             	lea    0x0(%esi),%esi

80103000 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103000:	55                   	push   %ebp
80103001:	b8 0b 00 00 00       	mov    $0xb,%eax
80103006:	ba 70 00 00 00       	mov    $0x70,%edx
8010300b:	89 e5                	mov    %esp,%ebp
8010300d:	57                   	push   %edi
8010300e:	56                   	push   %esi
8010300f:	53                   	push   %ebx
80103010:	83 ec 4c             	sub    $0x4c,%esp
80103013:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103014:	ba 71 00 00 00       	mov    $0x71,%edx
80103019:	ec                   	in     (%dx),%al
8010301a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010301d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103022:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103025:	8d 76 00             	lea    0x0(%esi),%esi
80103028:	31 c0                	xor    %eax,%eax
8010302a:	89 da                	mov    %ebx,%edx
8010302c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010302d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103032:	89 ca                	mov    %ecx,%edx
80103034:	ec                   	in     (%dx),%al
80103035:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103038:	89 da                	mov    %ebx,%edx
8010303a:	b8 02 00 00 00       	mov    $0x2,%eax
8010303f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103040:	89 ca                	mov    %ecx,%edx
80103042:	ec                   	in     (%dx),%al
80103043:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103046:	89 da                	mov    %ebx,%edx
80103048:	b8 04 00 00 00       	mov    $0x4,%eax
8010304d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010304e:	89 ca                	mov    %ecx,%edx
80103050:	ec                   	in     (%dx),%al
80103051:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103054:	89 da                	mov    %ebx,%edx
80103056:	b8 07 00 00 00       	mov    $0x7,%eax
8010305b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010305c:	89 ca                	mov    %ecx,%edx
8010305e:	ec                   	in     (%dx),%al
8010305f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103062:	89 da                	mov    %ebx,%edx
80103064:	b8 08 00 00 00       	mov    $0x8,%eax
80103069:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010306a:	89 ca                	mov    %ecx,%edx
8010306c:	ec                   	in     (%dx),%al
8010306d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010306f:	89 da                	mov    %ebx,%edx
80103071:	b8 09 00 00 00       	mov    $0x9,%eax
80103076:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103077:	89 ca                	mov    %ecx,%edx
80103079:	ec                   	in     (%dx),%al
8010307a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010307c:	89 da                	mov    %ebx,%edx
8010307e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103083:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103084:	89 ca                	mov    %ecx,%edx
80103086:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103087:	84 c0                	test   %al,%al
80103089:	78 9d                	js     80103028 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010308b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010308f:	89 fa                	mov    %edi,%edx
80103091:	0f b6 fa             	movzbl %dl,%edi
80103094:	89 f2                	mov    %esi,%edx
80103096:	0f b6 f2             	movzbl %dl,%esi
80103099:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309c:	89 da                	mov    %ebx,%edx
8010309e:	89 75 cc             	mov    %esi,-0x34(%ebp)
801030a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801030a4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801030a8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801030ab:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801030af:	89 45 c0             	mov    %eax,-0x40(%ebp)
801030b2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801030b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801030b9:	31 c0                	xor    %eax,%eax
801030bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030bc:	89 ca                	mov    %ecx,%edx
801030be:	ec                   	in     (%dx),%al
801030bf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c2:	89 da                	mov    %ebx,%edx
801030c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801030c7:	b8 02 00 00 00       	mov    $0x2,%eax
801030cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030cd:	89 ca                	mov    %ecx,%edx
801030cf:	ec                   	in     (%dx),%al
801030d0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030d3:	89 da                	mov    %ebx,%edx
801030d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801030d8:	b8 04 00 00 00       	mov    $0x4,%eax
801030dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030de:	89 ca                	mov    %ecx,%edx
801030e0:	ec                   	in     (%dx),%al
801030e1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030e4:	89 da                	mov    %ebx,%edx
801030e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801030e9:	b8 07 00 00 00       	mov    $0x7,%eax
801030ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ef:	89 ca                	mov    %ecx,%edx
801030f1:	ec                   	in     (%dx),%al
801030f2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f5:	89 da                	mov    %ebx,%edx
801030f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801030fa:	b8 08 00 00 00       	mov    $0x8,%eax
801030ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103100:	89 ca                	mov    %ecx,%edx
80103102:	ec                   	in     (%dx),%al
80103103:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103106:	89 da                	mov    %ebx,%edx
80103108:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010310b:	b8 09 00 00 00       	mov    $0x9,%eax
80103110:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103111:	89 ca                	mov    %ecx,%edx
80103113:	ec                   	in     (%dx),%al
80103114:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103117:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010311a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010311d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103120:	6a 18                	push   $0x18
80103122:	50                   	push   %eax
80103123:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103126:	50                   	push   %eax
80103127:	e8 e4 23 00 00       	call   80105510 <memcmp>
8010312c:	83 c4 10             	add    $0x10,%esp
8010312f:	85 c0                	test   %eax,%eax
80103131:	0f 85 f1 fe ff ff    	jne    80103028 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103137:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010313b:	75 78                	jne    801031b5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010313d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103140:	89 c2                	mov    %eax,%edx
80103142:	83 e0 0f             	and    $0xf,%eax
80103145:	c1 ea 04             	shr    $0x4,%edx
80103148:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010314b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010314e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103151:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103154:	89 c2                	mov    %eax,%edx
80103156:	83 e0 0f             	and    $0xf,%eax
80103159:	c1 ea 04             	shr    $0x4,%edx
8010315c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010315f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103162:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103165:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103168:	89 c2                	mov    %eax,%edx
8010316a:	83 e0 0f             	and    $0xf,%eax
8010316d:	c1 ea 04             	shr    $0x4,%edx
80103170:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103173:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103176:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103179:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010317c:	89 c2                	mov    %eax,%edx
8010317e:	83 e0 0f             	and    $0xf,%eax
80103181:	c1 ea 04             	shr    $0x4,%edx
80103184:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103187:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010318a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010318d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103190:	89 c2                	mov    %eax,%edx
80103192:	83 e0 0f             	and    $0xf,%eax
80103195:	c1 ea 04             	shr    $0x4,%edx
80103198:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010319b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010319e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801031a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031a4:	89 c2                	mov    %eax,%edx
801031a6:	83 e0 0f             	and    $0xf,%eax
801031a9:	c1 ea 04             	shr    $0x4,%edx
801031ac:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031af:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031b2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801031b5:	8b 75 08             	mov    0x8(%ebp),%esi
801031b8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031bb:	89 06                	mov    %eax,(%esi)
801031bd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031c0:	89 46 04             	mov    %eax,0x4(%esi)
801031c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031c6:	89 46 08             	mov    %eax,0x8(%esi)
801031c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031cc:	89 46 0c             	mov    %eax,0xc(%esi)
801031cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031d2:	89 46 10             	mov    %eax,0x10(%esi)
801031d5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801031d8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801031db:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801031e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031e5:	5b                   	pop    %ebx
801031e6:	5e                   	pop    %esi
801031e7:	5f                   	pop    %edi
801031e8:	5d                   	pop    %ebp
801031e9:	c3                   	ret    
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031f0:	8b 0d e8 46 18 80    	mov    0x801846e8,%ecx
801031f6:	85 c9                	test   %ecx,%ecx
801031f8:	0f 8e 8a 00 00 00    	jle    80103288 <install_trans+0x98>
{
801031fe:	55                   	push   %ebp
801031ff:	89 e5                	mov    %esp,%ebp
80103201:	57                   	push   %edi
80103202:	56                   	push   %esi
80103203:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103204:	31 db                	xor    %ebx,%ebx
{
80103206:	83 ec 0c             	sub    $0xc,%esp
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103210:	a1 d4 46 18 80       	mov    0x801846d4,%eax
80103215:	83 ec 08             	sub    $0x8,%esp
80103218:	01 d8                	add    %ebx,%eax
8010321a:	83 c0 01             	add    $0x1,%eax
8010321d:	50                   	push   %eax
8010321e:	ff 35 e4 46 18 80    	pushl  0x801846e4
80103224:	e8 a7 ce ff ff       	call   801000d0 <bread>
80103229:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010322b:	58                   	pop    %eax
8010322c:	5a                   	pop    %edx
8010322d:	ff 34 9d ec 46 18 80 	pushl  -0x7fe7b914(,%ebx,4)
80103234:	ff 35 e4 46 18 80    	pushl  0x801846e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010323a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010323d:	e8 8e ce ff ff       	call   801000d0 <bread>
80103242:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103244:	8d 47 5c             	lea    0x5c(%edi),%eax
80103247:	83 c4 0c             	add    $0xc,%esp
8010324a:	68 00 02 00 00       	push   $0x200
8010324f:	50                   	push   %eax
80103250:	8d 46 5c             	lea    0x5c(%esi),%eax
80103253:	50                   	push   %eax
80103254:	e8 17 23 00 00       	call   80105570 <memmove>
    bwrite(dbuf);  // write dst to disk
80103259:	89 34 24             	mov    %esi,(%esp)
8010325c:	e8 3f cf ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103261:	89 3c 24             	mov    %edi,(%esp)
80103264:	e8 77 cf ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103269:	89 34 24             	mov    %esi,(%esp)
8010326c:	e8 6f cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103271:	83 c4 10             	add    $0x10,%esp
80103274:	39 1d e8 46 18 80    	cmp    %ebx,0x801846e8
8010327a:	7f 94                	jg     80103210 <install_trans+0x20>
  }
}
8010327c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010327f:	5b                   	pop    %ebx
80103280:	5e                   	pop    %esi
80103281:	5f                   	pop    %edi
80103282:	5d                   	pop    %ebp
80103283:	c3                   	ret    
80103284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103288:	f3 c3                	repz ret 
8010328a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103290 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	56                   	push   %esi
80103294:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103295:	83 ec 08             	sub    $0x8,%esp
80103298:	ff 35 d4 46 18 80    	pushl  0x801846d4
8010329e:	ff 35 e4 46 18 80    	pushl  0x801846e4
801032a4:	e8 27 ce ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801032a9:	8b 1d e8 46 18 80    	mov    0x801846e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
801032af:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801032b2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
801032b4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
801032b6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801032b9:	7e 16                	jle    801032d1 <write_head+0x41>
801032bb:	c1 e3 02             	shl    $0x2,%ebx
801032be:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
801032c0:	8b 8a ec 46 18 80    	mov    -0x7fe7b914(%edx),%ecx
801032c6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
801032ca:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
801032cd:	39 da                	cmp    %ebx,%edx
801032cf:	75 ef                	jne    801032c0 <write_head+0x30>
  }
  bwrite(buf);
801032d1:	83 ec 0c             	sub    $0xc,%esp
801032d4:	56                   	push   %esi
801032d5:	e8 c6 ce ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801032da:	89 34 24             	mov    %esi,(%esp)
801032dd:	e8 fe ce ff ff       	call   801001e0 <brelse>
}
801032e2:	83 c4 10             	add    $0x10,%esp
801032e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032e8:	5b                   	pop    %ebx
801032e9:	5e                   	pop    %esi
801032ea:	5d                   	pop    %ebp
801032eb:	c3                   	ret    
801032ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032f0 <initlog>:
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	53                   	push   %ebx
801032f4:	83 ec 2c             	sub    $0x2c,%esp
801032f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801032fa:	68 a0 8c 10 80       	push   $0x80108ca0
801032ff:	68 a0 46 18 80       	push   $0x801846a0
80103304:	e8 67 1f 00 00       	call   80105270 <initlock>
  readsb(dev, &sb);
80103309:	58                   	pop    %eax
8010330a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010330d:	5a                   	pop    %edx
8010330e:	50                   	push   %eax
8010330f:	53                   	push   %ebx
80103310:	e8 0b e4 ff ff       	call   80101720 <readsb>
  log.size = sb.nlog;
80103315:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103318:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010331b:	59                   	pop    %ecx
  log.dev = dev;
8010331c:	89 1d e4 46 18 80    	mov    %ebx,0x801846e4
  log.size = sb.nlog;
80103322:	89 15 d8 46 18 80    	mov    %edx,0x801846d8
  log.start = sb.logstart;
80103328:	a3 d4 46 18 80       	mov    %eax,0x801846d4
  struct buf *buf = bread(log.dev, log.start);
8010332d:	5a                   	pop    %edx
8010332e:	50                   	push   %eax
8010332f:	53                   	push   %ebx
80103330:	e8 9b cd ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103335:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103338:	83 c4 10             	add    $0x10,%esp
8010333b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010333d:	89 1d e8 46 18 80    	mov    %ebx,0x801846e8
  for (i = 0; i < log.lh.n; i++) {
80103343:	7e 1c                	jle    80103361 <initlog+0x71>
80103345:	c1 e3 02             	shl    $0x2,%ebx
80103348:	31 d2                	xor    %edx,%edx
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103350:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103354:	83 c2 04             	add    $0x4,%edx
80103357:	89 8a e8 46 18 80    	mov    %ecx,-0x7fe7b918(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010335d:	39 d3                	cmp    %edx,%ebx
8010335f:	75 ef                	jne    80103350 <initlog+0x60>
  brelse(buf);
80103361:	83 ec 0c             	sub    $0xc,%esp
80103364:	50                   	push   %eax
80103365:	e8 76 ce ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010336a:	e8 81 fe ff ff       	call   801031f0 <install_trans>
  log.lh.n = 0;
8010336f:	c7 05 e8 46 18 80 00 	movl   $0x0,0x801846e8
80103376:	00 00 00 
  write_head(); // clear the log
80103379:	e8 12 ff ff ff       	call   80103290 <write_head>
}
8010337e:	83 c4 10             	add    $0x10,%esp
80103381:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103384:	c9                   	leave  
80103385:	c3                   	ret    
80103386:	8d 76 00             	lea    0x0(%esi),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103396:	68 a0 46 18 80       	push   $0x801846a0
8010339b:	e8 10 20 00 00       	call   801053b0 <acquire>
801033a0:	83 c4 10             	add    $0x10,%esp
801033a3:	eb 18                	jmp    801033bd <begin_op+0x2d>
801033a5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801033a8:	83 ec 08             	sub    $0x8,%esp
801033ab:	68 a0 46 18 80       	push   $0x801846a0
801033b0:	68 a0 46 18 80       	push   $0x801846a0
801033b5:	e8 a6 13 00 00       	call   80104760 <sleep>
801033ba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801033bd:	a1 e0 46 18 80       	mov    0x801846e0,%eax
801033c2:	85 c0                	test   %eax,%eax
801033c4:	75 e2                	jne    801033a8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801033c6:	a1 dc 46 18 80       	mov    0x801846dc,%eax
801033cb:	8b 15 e8 46 18 80    	mov    0x801846e8,%edx
801033d1:	83 c0 01             	add    $0x1,%eax
801033d4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801033d7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801033da:	83 fa 1e             	cmp    $0x1e,%edx
801033dd:	7f c9                	jg     801033a8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801033df:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801033e2:	a3 dc 46 18 80       	mov    %eax,0x801846dc
      release(&log.lock);
801033e7:	68 a0 46 18 80       	push   $0x801846a0
801033ec:	e8 7f 20 00 00       	call   80105470 <release>
      break;
    }
  }
}
801033f1:	83 c4 10             	add    $0x10,%esp
801033f4:	c9                   	leave  
801033f5:	c3                   	ret    
801033f6:	8d 76 00             	lea    0x0(%esi),%esi
801033f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103400 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103409:	68 a0 46 18 80       	push   $0x801846a0
8010340e:	e8 9d 1f 00 00       	call   801053b0 <acquire>
  log.outstanding -= 1;
80103413:	a1 dc 46 18 80       	mov    0x801846dc,%eax
  if(log.committing)
80103418:	8b 35 e0 46 18 80    	mov    0x801846e0,%esi
8010341e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103421:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103424:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103426:	89 1d dc 46 18 80    	mov    %ebx,0x801846dc
  if(log.committing)
8010342c:	0f 85 1a 01 00 00    	jne    8010354c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103432:	85 db                	test   %ebx,%ebx
80103434:	0f 85 ee 00 00 00    	jne    80103528 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010343a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010343d:	c7 05 e0 46 18 80 01 	movl   $0x1,0x801846e0
80103444:	00 00 00 
  release(&log.lock);
80103447:	68 a0 46 18 80       	push   $0x801846a0
8010344c:	e8 1f 20 00 00       	call   80105470 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103451:	8b 0d e8 46 18 80    	mov    0x801846e8,%ecx
80103457:	83 c4 10             	add    $0x10,%esp
8010345a:	85 c9                	test   %ecx,%ecx
8010345c:	0f 8e 85 00 00 00    	jle    801034e7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103462:	a1 d4 46 18 80       	mov    0x801846d4,%eax
80103467:	83 ec 08             	sub    $0x8,%esp
8010346a:	01 d8                	add    %ebx,%eax
8010346c:	83 c0 01             	add    $0x1,%eax
8010346f:	50                   	push   %eax
80103470:	ff 35 e4 46 18 80    	pushl  0x801846e4
80103476:	e8 55 cc ff ff       	call   801000d0 <bread>
8010347b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010347d:	58                   	pop    %eax
8010347e:	5a                   	pop    %edx
8010347f:	ff 34 9d ec 46 18 80 	pushl  -0x7fe7b914(,%ebx,4)
80103486:	ff 35 e4 46 18 80    	pushl  0x801846e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010348c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010348f:	e8 3c cc ff ff       	call   801000d0 <bread>
80103494:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103496:	8d 40 5c             	lea    0x5c(%eax),%eax
80103499:	83 c4 0c             	add    $0xc,%esp
8010349c:	68 00 02 00 00       	push   $0x200
801034a1:	50                   	push   %eax
801034a2:	8d 46 5c             	lea    0x5c(%esi),%eax
801034a5:	50                   	push   %eax
801034a6:	e8 c5 20 00 00       	call   80105570 <memmove>
    bwrite(to);  // write the log
801034ab:	89 34 24             	mov    %esi,(%esp)
801034ae:	e8 ed cc ff ff       	call   801001a0 <bwrite>
    brelse(from);
801034b3:	89 3c 24             	mov    %edi,(%esp)
801034b6:	e8 25 cd ff ff       	call   801001e0 <brelse>
    brelse(to);
801034bb:	89 34 24             	mov    %esi,(%esp)
801034be:	e8 1d cd ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801034c3:	83 c4 10             	add    $0x10,%esp
801034c6:	3b 1d e8 46 18 80    	cmp    0x801846e8,%ebx
801034cc:	7c 94                	jl     80103462 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801034ce:	e8 bd fd ff ff       	call   80103290 <write_head>
    install_trans(); // Now install writes to home locations
801034d3:	e8 18 fd ff ff       	call   801031f0 <install_trans>
    log.lh.n = 0;
801034d8:	c7 05 e8 46 18 80 00 	movl   $0x0,0x801846e8
801034df:	00 00 00 
    write_head();    // Erase the transaction from the log
801034e2:	e8 a9 fd ff ff       	call   80103290 <write_head>
    acquire(&log.lock);
801034e7:	83 ec 0c             	sub    $0xc,%esp
801034ea:	68 a0 46 18 80       	push   $0x801846a0
801034ef:	e8 bc 1e 00 00       	call   801053b0 <acquire>
    wakeup(&log);
801034f4:	c7 04 24 a0 46 18 80 	movl   $0x801846a0,(%esp)
    log.committing = 0;
801034fb:	c7 05 e0 46 18 80 00 	movl   $0x0,0x801846e0
80103502:	00 00 00 
    wakeup(&log);
80103505:	e8 16 14 00 00       	call   80104920 <wakeup>
    release(&log.lock);
8010350a:	c7 04 24 a0 46 18 80 	movl   $0x801846a0,(%esp)
80103511:	e8 5a 1f 00 00       	call   80105470 <release>
80103516:	83 c4 10             	add    $0x10,%esp
}
80103519:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	68 a0 46 18 80       	push   $0x801846a0
80103530:	e8 eb 13 00 00       	call   80104920 <wakeup>
  release(&log.lock);
80103535:	c7 04 24 a0 46 18 80 	movl   $0x801846a0,(%esp)
8010353c:	e8 2f 1f 00 00       	call   80105470 <release>
80103541:	83 c4 10             	add    $0x10,%esp
}
80103544:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103547:	5b                   	pop    %ebx
80103548:	5e                   	pop    %esi
80103549:	5f                   	pop    %edi
8010354a:	5d                   	pop    %ebp
8010354b:	c3                   	ret    
    panic("log.committing");
8010354c:	83 ec 0c             	sub    $0xc,%esp
8010354f:	68 a4 8c 10 80       	push   $0x80108ca4
80103554:	e8 37 ce ff ff       	call   80100390 <panic>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103560 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	53                   	push   %ebx
80103564:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103567:	8b 15 e8 46 18 80    	mov    0x801846e8,%edx
{
8010356d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103570:	83 fa 1d             	cmp    $0x1d,%edx
80103573:	0f 8f 9d 00 00 00    	jg     80103616 <log_write+0xb6>
80103579:	a1 d8 46 18 80       	mov    0x801846d8,%eax
8010357e:	83 e8 01             	sub    $0x1,%eax
80103581:	39 c2                	cmp    %eax,%edx
80103583:	0f 8d 8d 00 00 00    	jge    80103616 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103589:	a1 dc 46 18 80       	mov    0x801846dc,%eax
8010358e:	85 c0                	test   %eax,%eax
80103590:	0f 8e 8d 00 00 00    	jle    80103623 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103596:	83 ec 0c             	sub    $0xc,%esp
80103599:	68 a0 46 18 80       	push   $0x801846a0
8010359e:	e8 0d 1e 00 00       	call   801053b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801035a3:	8b 0d e8 46 18 80    	mov    0x801846e8,%ecx
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	83 f9 00             	cmp    $0x0,%ecx
801035af:	7e 57                	jle    80103608 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035b1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801035b4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801035b6:	3b 15 ec 46 18 80    	cmp    0x801846ec,%edx
801035bc:	75 0b                	jne    801035c9 <log_write+0x69>
801035be:	eb 38                	jmp    801035f8 <log_write+0x98>
801035c0:	39 14 85 ec 46 18 80 	cmp    %edx,-0x7fe7b914(,%eax,4)
801035c7:	74 2f                	je     801035f8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801035c9:	83 c0 01             	add    $0x1,%eax
801035cc:	39 c1                	cmp    %eax,%ecx
801035ce:	75 f0                	jne    801035c0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801035d0:	89 14 85 ec 46 18 80 	mov    %edx,-0x7fe7b914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801035d7:	83 c0 01             	add    $0x1,%eax
801035da:	a3 e8 46 18 80       	mov    %eax,0x801846e8
  b->flags |= B_DIRTY; // prevent eviction
801035df:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801035e2:	c7 45 08 a0 46 18 80 	movl   $0x801846a0,0x8(%ebp)
}
801035e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035ec:	c9                   	leave  
  release(&log.lock);
801035ed:	e9 7e 1e 00 00       	jmp    80105470 <release>
801035f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801035f8:	89 14 85 ec 46 18 80 	mov    %edx,-0x7fe7b914(,%eax,4)
801035ff:	eb de                	jmp    801035df <log_write+0x7f>
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	8b 43 08             	mov    0x8(%ebx),%eax
8010360b:	a3 ec 46 18 80       	mov    %eax,0x801846ec
  if (i == log.lh.n)
80103610:	75 cd                	jne    801035df <log_write+0x7f>
80103612:	31 c0                	xor    %eax,%eax
80103614:	eb c1                	jmp    801035d7 <log_write+0x77>
    panic("too big a transaction");
80103616:	83 ec 0c             	sub    $0xc,%esp
80103619:	68 b3 8c 10 80       	push   $0x80108cb3
8010361e:	e8 6d cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103623:	83 ec 0c             	sub    $0xc,%esp
80103626:	68 c9 8c 10 80       	push   $0x80108cc9
8010362b:	e8 60 cd ff ff       	call   80100390 <panic>

80103630 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	53                   	push   %ebx
80103634:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103637:	e8 04 0a 00 00       	call   80104040 <cpuid>
8010363c:	89 c3                	mov    %eax,%ebx
8010363e:	e8 fd 09 00 00       	call   80104040 <cpuid>
80103643:	83 ec 04             	sub    $0x4,%esp
80103646:	53                   	push   %ebx
80103647:	50                   	push   %eax
80103648:	68 e4 8c 10 80       	push   $0x80108ce4
8010364d:	e8 0e d0 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103652:	e8 59 31 00 00       	call   801067b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103657:	e8 64 09 00 00       	call   80103fc0 <mycpu>
8010365c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010365e:	b8 01 00 00 00       	mov    $0x1,%eax
80103663:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010366a:	e8 01 0e 00 00       	call   80104470 <scheduler>
8010366f:	90                   	nop

80103670 <mpenter>:
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103676:	e8 65 44 00 00       	call   80107ae0 <switchkvm>
  seginit();
8010367b:	e8 d0 43 00 00       	call   80107a50 <seginit>
  lapicinit();
80103680:	e8 9b f7 ff ff       	call   80102e20 <lapicinit>
  mpmain();
80103685:	e8 a6 ff ff ff       	call   80103630 <mpmain>
8010368a:	66 90                	xchg   %ax,%ax
8010368c:	66 90                	xchg   %ax,%ax
8010368e:	66 90                	xchg   %ax,%ax

80103690 <main>:
{
80103690:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103694:	83 e4 f0             	and    $0xfffffff0,%esp
80103697:	ff 71 fc             	pushl  -0x4(%ecx)
8010369a:	55                   	push   %ebp
8010369b:	89 e5                	mov    %esp,%ebp
8010369d:	53                   	push   %ebx
8010369e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010369f:	83 ec 08             	sub    $0x8,%esp
801036a2:	68 00 00 40 80       	push   $0x80400000
801036a7:	68 18 3c 1a 80       	push   $0x801a3c18
801036ac:	e8 bf f3 ff ff       	call   80102a70 <kinit1>
  kvmalloc();      // kernel page table
801036b1:	e8 ca 48 00 00       	call   80107f80 <kvmalloc>
  mpinit();        // detect other processors
801036b6:	e8 75 01 00 00       	call   80103830 <mpinit>
  lapicinit();     // interrupt controller
801036bb:	e8 60 f7 ff ff       	call   80102e20 <lapicinit>
  seginit();       // segment descriptors
801036c0:	e8 8b 43 00 00       	call   80107a50 <seginit>
  picinit();       // disable pic
801036c5:	e8 46 03 00 00       	call   80103a10 <picinit>
  ioapicinit();    // another interrupt controller
801036ca:	e8 c1 f1 ff ff       	call   80102890 <ioapicinit>
  consoleinit();   // console hardware
801036cf:	e8 ec d2 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801036d4:	e8 e7 36 00 00       	call   80106dc0 <uartinit>
  pinit();         // process table
801036d9:	e8 c2 08 00 00       	call   80103fa0 <pinit>
  tvinit();        // trap vectors
801036de:	e8 4d 30 00 00       	call   80106730 <tvinit>
  binit();         // buffer cache
801036e3:	e8 58 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801036e8:	e8 53 d9 ff ff       	call   80101040 <fileinit>
  ideinit();       // disk 
801036ed:	e8 7e ef ff ff       	call   80102670 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801036f2:	83 c4 0c             	add    $0xc,%esp
801036f5:	68 8a 00 00 00       	push   $0x8a
801036fa:	68 8c c4 10 80       	push   $0x8010c48c
801036ff:	68 00 70 00 80       	push   $0x80007000
80103704:	e8 67 1e 00 00       	call   80105570 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103709:	69 05 20 4d 18 80 b0 	imul   $0xb0,0x80184d20,%eax
80103710:	00 00 00 
80103713:	83 c4 10             	add    $0x10,%esp
80103716:	05 a0 47 18 80       	add    $0x801847a0,%eax
8010371b:	3d a0 47 18 80       	cmp    $0x801847a0,%eax
80103720:	76 71                	jbe    80103793 <main+0x103>
80103722:	bb a0 47 18 80       	mov    $0x801847a0,%ebx
80103727:	89 f6                	mov    %esi,%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103730:	e8 8b 08 00 00       	call   80103fc0 <mycpu>
80103735:	39 d8                	cmp    %ebx,%eax
80103737:	74 41                	je     8010377a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103739:	e8 02 f4 ff ff       	call   80102b40 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010373e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103743:	c7 05 f8 6f 00 80 70 	movl   $0x80103670,0x80006ff8
8010374a:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010374d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103754:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103757:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010375c:	0f b6 03             	movzbl (%ebx),%eax
8010375f:	83 ec 08             	sub    $0x8,%esp
80103762:	68 00 70 00 00       	push   $0x7000
80103767:	50                   	push   %eax
80103768:	e8 03 f8 ff ff       	call   80102f70 <lapicstartap>
8010376d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103770:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103776:	85 c0                	test   %eax,%eax
80103778:	74 f6                	je     80103770 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010377a:	69 05 20 4d 18 80 b0 	imul   $0xb0,0x80184d20,%eax
80103781:	00 00 00 
80103784:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010378a:	05 a0 47 18 80       	add    $0x801847a0,%eax
8010378f:	39 c3                	cmp    %eax,%ebx
80103791:	72 9d                	jb     80103730 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103793:	83 ec 08             	sub    $0x8,%esp
80103796:	68 00 00 00 8e       	push   $0x8e000000
8010379b:	68 00 00 40 80       	push   $0x80400000
801037a0:	e8 3b f3 ff ff       	call   80102ae0 <kinit2>
  userinit();      // first user process
801037a5:	e8 e6 08 00 00       	call   80104090 <userinit>
  mpmain();        // finish this processor's setup
801037aa:	e8 81 fe ff ff       	call   80103630 <mpmain>
801037af:	90                   	nop

801037b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	57                   	push   %edi
801037b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801037b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801037bb:	53                   	push   %ebx
  e = addr+len;
801037bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801037bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801037c2:	39 de                	cmp    %ebx,%esi
801037c4:	72 10                	jb     801037d6 <mpsearch1+0x26>
801037c6:	eb 50                	jmp    80103818 <mpsearch1+0x68>
801037c8:	90                   	nop
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037d0:	39 fb                	cmp    %edi,%ebx
801037d2:	89 fe                	mov    %edi,%esi
801037d4:	76 42                	jbe    80103818 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801037d6:	83 ec 04             	sub    $0x4,%esp
801037d9:	8d 7e 10             	lea    0x10(%esi),%edi
801037dc:	6a 04                	push   $0x4
801037de:	68 f8 8c 10 80       	push   $0x80108cf8
801037e3:	56                   	push   %esi
801037e4:	e8 27 1d 00 00       	call   80105510 <memcmp>
801037e9:	83 c4 10             	add    $0x10,%esp
801037ec:	85 c0                	test   %eax,%eax
801037ee:	75 e0                	jne    801037d0 <mpsearch1+0x20>
801037f0:	89 f1                	mov    %esi,%ecx
801037f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801037f8:	0f b6 11             	movzbl (%ecx),%edx
801037fb:	83 c1 01             	add    $0x1,%ecx
801037fe:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103800:	39 f9                	cmp    %edi,%ecx
80103802:	75 f4                	jne    801037f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103804:	84 c0                	test   %al,%al
80103806:	75 c8                	jne    801037d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103808:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010380b:	89 f0                	mov    %esi,%eax
8010380d:	5b                   	pop    %ebx
8010380e:	5e                   	pop    %esi
8010380f:	5f                   	pop    %edi
80103810:	5d                   	pop    %ebp
80103811:	c3                   	ret    
80103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103818:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010381b:	31 f6                	xor    %esi,%esi
}
8010381d:	89 f0                	mov    %esi,%eax
8010381f:	5b                   	pop    %ebx
80103820:	5e                   	pop    %esi
80103821:	5f                   	pop    %edi
80103822:	5d                   	pop    %ebp
80103823:	c3                   	ret    
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
80103835:	53                   	push   %ebx
80103836:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103839:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103840:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103847:	c1 e0 08             	shl    $0x8,%eax
8010384a:	09 d0                	or     %edx,%eax
8010384c:	c1 e0 04             	shl    $0x4,%eax
8010384f:	85 c0                	test   %eax,%eax
80103851:	75 1b                	jne    8010386e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103853:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010385a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103861:	c1 e0 08             	shl    $0x8,%eax
80103864:	09 d0                	or     %edx,%eax
80103866:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103869:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010386e:	ba 00 04 00 00       	mov    $0x400,%edx
80103873:	e8 38 ff ff ff       	call   801037b0 <mpsearch1>
80103878:	85 c0                	test   %eax,%eax
8010387a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010387d:	0f 84 3d 01 00 00    	je     801039c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103886:	8b 58 04             	mov    0x4(%eax),%ebx
80103889:	85 db                	test   %ebx,%ebx
8010388b:	0f 84 4f 01 00 00    	je     801039e0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103891:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103897:	83 ec 04             	sub    $0x4,%esp
8010389a:	6a 04                	push   $0x4
8010389c:	68 15 8d 10 80       	push   $0x80108d15
801038a1:	56                   	push   %esi
801038a2:	e8 69 1c 00 00       	call   80105510 <memcmp>
801038a7:	83 c4 10             	add    $0x10,%esp
801038aa:	85 c0                	test   %eax,%eax
801038ac:	0f 85 2e 01 00 00    	jne    801039e0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801038b2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801038b9:	3c 01                	cmp    $0x1,%al
801038bb:	0f 95 c2             	setne  %dl
801038be:	3c 04                	cmp    $0x4,%al
801038c0:	0f 95 c0             	setne  %al
801038c3:	20 c2                	and    %al,%dl
801038c5:	0f 85 15 01 00 00    	jne    801039e0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801038cb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801038d2:	66 85 ff             	test   %di,%di
801038d5:	74 1a                	je     801038f1 <mpinit+0xc1>
801038d7:	89 f0                	mov    %esi,%eax
801038d9:	01 f7                	add    %esi,%edi
  sum = 0;
801038db:	31 d2                	xor    %edx,%edx
801038dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801038e0:	0f b6 08             	movzbl (%eax),%ecx
801038e3:	83 c0 01             	add    $0x1,%eax
801038e6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801038e8:	39 c7                	cmp    %eax,%edi
801038ea:	75 f4                	jne    801038e0 <mpinit+0xb0>
801038ec:	84 d2                	test   %dl,%dl
801038ee:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801038f1:	85 f6                	test   %esi,%esi
801038f3:	0f 84 e7 00 00 00    	je     801039e0 <mpinit+0x1b0>
801038f9:	84 d2                	test   %dl,%dl
801038fb:	0f 85 df 00 00 00    	jne    801039e0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103901:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103907:	a3 80 46 18 80       	mov    %eax,0x80184680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010390c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103913:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103919:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010391e:	01 d6                	add    %edx,%esi
80103920:	39 c6                	cmp    %eax,%esi
80103922:	76 23                	jbe    80103947 <mpinit+0x117>
    switch(*p){
80103924:	0f b6 10             	movzbl (%eax),%edx
80103927:	80 fa 04             	cmp    $0x4,%dl
8010392a:	0f 87 ca 00 00 00    	ja     801039fa <mpinit+0x1ca>
80103930:	ff 24 95 3c 8d 10 80 	jmp    *-0x7fef72c4(,%edx,4)
80103937:	89 f6                	mov    %esi,%esi
80103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103940:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103943:	39 c6                	cmp    %eax,%esi
80103945:	77 dd                	ja     80103924 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103947:	85 db                	test   %ebx,%ebx
80103949:	0f 84 9e 00 00 00    	je     801039ed <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010394f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103952:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103956:	74 15                	je     8010396d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103958:	b8 70 00 00 00       	mov    $0x70,%eax
8010395d:	ba 22 00 00 00       	mov    $0x22,%edx
80103962:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103963:	ba 23 00 00 00       	mov    $0x23,%edx
80103968:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103969:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010396c:	ee                   	out    %al,(%dx)
  }
}
8010396d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103970:	5b                   	pop    %ebx
80103971:	5e                   	pop    %esi
80103972:	5f                   	pop    %edi
80103973:	5d                   	pop    %ebp
80103974:	c3                   	ret    
80103975:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103978:	8b 0d 20 4d 18 80    	mov    0x80184d20,%ecx
8010397e:	83 f9 07             	cmp    $0x7,%ecx
80103981:	7f 19                	jg     8010399c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103983:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103987:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010398d:	83 c1 01             	add    $0x1,%ecx
80103990:	89 0d 20 4d 18 80    	mov    %ecx,0x80184d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103996:	88 97 a0 47 18 80    	mov    %dl,-0x7fe7b860(%edi)
      p += sizeof(struct mpproc);
8010399c:	83 c0 14             	add    $0x14,%eax
      continue;
8010399f:	e9 7c ff ff ff       	jmp    80103920 <mpinit+0xf0>
801039a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801039a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801039ac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801039af:	88 15 80 47 18 80    	mov    %dl,0x80184780
      continue;
801039b5:	e9 66 ff ff ff       	jmp    80103920 <mpinit+0xf0>
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801039c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801039c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801039ca:	e8 e1 fd ff ff       	call   801037b0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801039cf:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801039d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801039d4:	0f 85 a9 fe ff ff    	jne    80103883 <mpinit+0x53>
801039da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801039e0:	83 ec 0c             	sub    $0xc,%esp
801039e3:	68 fd 8c 10 80       	push   $0x80108cfd
801039e8:	e8 a3 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801039ed:	83 ec 0c             	sub    $0xc,%esp
801039f0:	68 1c 8d 10 80       	push   $0x80108d1c
801039f5:	e8 96 c9 ff ff       	call   80100390 <panic>
      ismp = 0;
801039fa:	31 db                	xor    %ebx,%ebx
801039fc:	e9 26 ff ff ff       	jmp    80103927 <mpinit+0xf7>
80103a01:	66 90                	xchg   %ax,%ax
80103a03:	66 90                	xchg   %ax,%ax
80103a05:	66 90                	xchg   %ax,%ax
80103a07:	66 90                	xchg   %ax,%ax
80103a09:	66 90                	xchg   %ax,%ax
80103a0b:	66 90                	xchg   %ax,%ax
80103a0d:	66 90                	xchg   %ax,%ax
80103a0f:	90                   	nop

80103a10 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a10:	55                   	push   %ebp
80103a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a16:	ba 21 00 00 00       	mov    $0x21,%edx
80103a1b:	89 e5                	mov    %esp,%ebp
80103a1d:	ee                   	out    %al,(%dx)
80103a1e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a23:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a24:	5d                   	pop    %ebp
80103a25:	c3                   	ret    
80103a26:	66 90                	xchg   %ax,%ax
80103a28:	66 90                	xchg   %ax,%ax
80103a2a:	66 90                	xchg   %ax,%ax
80103a2c:	66 90                	xchg   %ax,%ax
80103a2e:	66 90                	xchg   %ax,%ax

80103a30 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	56                   	push   %esi
80103a35:	53                   	push   %ebx
80103a36:	83 ec 0c             	sub    $0xc,%esp
80103a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a3f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103a45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103a4b:	e8 10 d6 ff ff       	call   80101060 <filealloc>
80103a50:	85 c0                	test   %eax,%eax
80103a52:	89 03                	mov    %eax,(%ebx)
80103a54:	74 22                	je     80103a78 <pipealloc+0x48>
80103a56:	e8 05 d6 ff ff       	call   80101060 <filealloc>
80103a5b:	85 c0                	test   %eax,%eax
80103a5d:	89 06                	mov    %eax,(%esi)
80103a5f:	74 3f                	je     80103aa0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103a61:	e8 da f0 ff ff       	call   80102b40 <kalloc>
80103a66:	85 c0                	test   %eax,%eax
80103a68:	89 c7                	mov    %eax,%edi
80103a6a:	75 54                	jne    80103ac0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103a6c:	8b 03                	mov    (%ebx),%eax
80103a6e:	85 c0                	test   %eax,%eax
80103a70:	75 34                	jne    80103aa6 <pipealloc+0x76>
80103a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103a78:	8b 06                	mov    (%esi),%eax
80103a7a:	85 c0                	test   %eax,%eax
80103a7c:	74 0c                	je     80103a8a <pipealloc+0x5a>
    fileclose(*f1);
80103a7e:	83 ec 0c             	sub    $0xc,%esp
80103a81:	50                   	push   %eax
80103a82:	e8 99 d6 ff ff       	call   80101120 <fileclose>
80103a87:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103a8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a92:	5b                   	pop    %ebx
80103a93:	5e                   	pop    %esi
80103a94:	5f                   	pop    %edi
80103a95:	5d                   	pop    %ebp
80103a96:	c3                   	ret    
80103a97:	89 f6                	mov    %esi,%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103aa0:	8b 03                	mov    (%ebx),%eax
80103aa2:	85 c0                	test   %eax,%eax
80103aa4:	74 e4                	je     80103a8a <pipealloc+0x5a>
    fileclose(*f0);
80103aa6:	83 ec 0c             	sub    $0xc,%esp
80103aa9:	50                   	push   %eax
80103aaa:	e8 71 d6 ff ff       	call   80101120 <fileclose>
  if(*f1)
80103aaf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103ab1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103ab4:	85 c0                	test   %eax,%eax
80103ab6:	75 c6                	jne    80103a7e <pipealloc+0x4e>
80103ab8:	eb d0                	jmp    80103a8a <pipealloc+0x5a>
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103ac0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103ac3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103aca:	00 00 00 
  p->writeopen = 1;
80103acd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ad4:	00 00 00 
  p->nwrite = 0;
80103ad7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103ade:	00 00 00 
  p->nread = 0;
80103ae1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ae8:	00 00 00 
  initlock(&p->lock, "pipe");
80103aeb:	68 50 8d 10 80       	push   $0x80108d50
80103af0:	50                   	push   %eax
80103af1:	e8 7a 17 00 00       	call   80105270 <initlock>
  (*f0)->type = FD_PIPE;
80103af6:	8b 03                	mov    (%ebx),%eax
  return 0;
80103af8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103afb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b01:	8b 03                	mov    (%ebx),%eax
80103b03:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b07:	8b 03                	mov    (%ebx),%eax
80103b09:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b0d:	8b 03                	mov    (%ebx),%eax
80103b0f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b12:	8b 06                	mov    (%esi),%eax
80103b14:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b1a:	8b 06                	mov    (%esi),%eax
80103b1c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b20:	8b 06                	mov    (%esi),%eax
80103b22:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b26:	8b 06                	mov    (%esi),%eax
80103b28:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b2e:	31 c0                	xor    %eax,%eax
}
80103b30:	5b                   	pop    %ebx
80103b31:	5e                   	pop    %esi
80103b32:	5f                   	pop    %edi
80103b33:	5d                   	pop    %ebp
80103b34:	c3                   	ret    
80103b35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b40 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
80103b45:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b48:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103b4b:	83 ec 0c             	sub    $0xc,%esp
80103b4e:	53                   	push   %ebx
80103b4f:	e8 5c 18 00 00       	call   801053b0 <acquire>
  if(writable){
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	85 f6                	test   %esi,%esi
80103b59:	74 45                	je     80103ba0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103b5b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b61:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103b64:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103b6b:	00 00 00 
    wakeup(&p->nread);
80103b6e:	50                   	push   %eax
80103b6f:	e8 ac 0d 00 00       	call   80104920 <wakeup>
80103b74:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103b77:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103b7d:	85 d2                	test   %edx,%edx
80103b7f:	75 0a                	jne    80103b8b <pipeclose+0x4b>
80103b81:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103b87:	85 c0                	test   %eax,%eax
80103b89:	74 35                	je     80103bc0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103b8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103b8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b91:	5b                   	pop    %ebx
80103b92:	5e                   	pop    %esi
80103b93:	5d                   	pop    %ebp
    release(&p->lock);
80103b94:	e9 d7 18 00 00       	jmp    80105470 <release>
80103b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103ba0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103ba6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103ba9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103bb0:	00 00 00 
    wakeup(&p->nwrite);
80103bb3:	50                   	push   %eax
80103bb4:	e8 67 0d 00 00       	call   80104920 <wakeup>
80103bb9:	83 c4 10             	add    $0x10,%esp
80103bbc:	eb b9                	jmp    80103b77 <pipeclose+0x37>
80103bbe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	53                   	push   %ebx
80103bc4:	e8 a7 18 00 00       	call   80105470 <release>
    kfree((char*)p);
80103bc9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103bcc:	83 c4 10             	add    $0x10,%esp
}
80103bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bd2:	5b                   	pop    %ebx
80103bd3:	5e                   	pop    %esi
80103bd4:	5d                   	pop    %ebp
    kfree((char*)p);
80103bd5:	e9 a6 ed ff ff       	jmp    80102980 <kfree>
80103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103be0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 28             	sub    $0x28,%esp
80103be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103bec:	53                   	push   %ebx
80103bed:	e8 be 17 00 00       	call   801053b0 <acquire>
  for(i = 0; i < n; i++){
80103bf2:	8b 45 10             	mov    0x10(%ebp),%eax
80103bf5:	83 c4 10             	add    $0x10,%esp
80103bf8:	85 c0                	test   %eax,%eax
80103bfa:	0f 8e c9 00 00 00    	jle    80103cc9 <pipewrite+0xe9>
80103c00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c03:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c09:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c0f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103c12:	03 4d 10             	add    0x10(%ebp),%ecx
80103c15:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c18:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103c1e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103c24:	39 d0                	cmp    %edx,%eax
80103c26:	75 71                	jne    80103c99 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103c28:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c2e:	85 c0                	test   %eax,%eax
80103c30:	74 4e                	je     80103c80 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c32:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103c38:	eb 3a                	jmp    80103c74 <pipewrite+0x94>
80103c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	57                   	push   %edi
80103c44:	e8 d7 0c 00 00       	call   80104920 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c49:	5a                   	pop    %edx
80103c4a:	59                   	pop    %ecx
80103c4b:	53                   	push   %ebx
80103c4c:	56                   	push   %esi
80103c4d:	e8 0e 0b 00 00       	call   80104760 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c52:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103c58:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103c5e:	83 c4 10             	add    $0x10,%esp
80103c61:	05 00 02 00 00       	add    $0x200,%eax
80103c66:	39 c2                	cmp    %eax,%edx
80103c68:	75 36                	jne    80103ca0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103c6a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c70:	85 c0                	test   %eax,%eax
80103c72:	74 0c                	je     80103c80 <pipewrite+0xa0>
80103c74:	e8 e7 03 00 00       	call   80104060 <myproc>
80103c79:	8b 40 24             	mov    0x24(%eax),%eax
80103c7c:	85 c0                	test   %eax,%eax
80103c7e:	74 c0                	je     80103c40 <pipewrite+0x60>
        release(&p->lock);
80103c80:	83 ec 0c             	sub    $0xc,%esp
80103c83:	53                   	push   %ebx
80103c84:	e8 e7 17 00 00       	call   80105470 <release>
        return -1;
80103c89:	83 c4 10             	add    $0x10,%esp
80103c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c94:	5b                   	pop    %ebx
80103c95:	5e                   	pop    %esi
80103c96:	5f                   	pop    %edi
80103c97:	5d                   	pop    %ebp
80103c98:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c99:	89 c2                	mov    %eax,%edx
80103c9b:	90                   	nop
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ca0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ca3:	8d 42 01             	lea    0x1(%edx),%eax
80103ca6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103cac:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103cb2:	83 c6 01             	add    $0x1,%esi
80103cb5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103cb9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103cbc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103cbf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103cc3:	0f 85 4f ff ff ff    	jne    80103c18 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103cc9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103ccf:	83 ec 0c             	sub    $0xc,%esp
80103cd2:	50                   	push   %eax
80103cd3:	e8 48 0c 00 00       	call   80104920 <wakeup>
  release(&p->lock);
80103cd8:	89 1c 24             	mov    %ebx,(%esp)
80103cdb:	e8 90 17 00 00       	call   80105470 <release>
  return n;
80103ce0:	83 c4 10             	add    $0x10,%esp
80103ce3:	8b 45 10             	mov    0x10(%ebp),%eax
80103ce6:	eb a9                	jmp    80103c91 <pipewrite+0xb1>
80103ce8:	90                   	nop
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 18             	sub    $0x18,%esp
80103cf9:	8b 75 08             	mov    0x8(%ebp),%esi
80103cfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103cff:	56                   	push   %esi
80103d00:	e8 ab 16 00 00       	call   801053b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d05:	83 c4 10             	add    $0x10,%esp
80103d08:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d0e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d14:	75 6a                	jne    80103d80 <piperead+0x90>
80103d16:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103d1c:	85 db                	test   %ebx,%ebx
80103d1e:	0f 84 c4 00 00 00    	je     80103de8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d24:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d2a:	eb 2d                	jmp    80103d59 <piperead+0x69>
80103d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d30:	83 ec 08             	sub    $0x8,%esp
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
80103d35:	e8 26 0a 00 00       	call   80104760 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d3a:	83 c4 10             	add    $0x10,%esp
80103d3d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d43:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d49:	75 35                	jne    80103d80 <piperead+0x90>
80103d4b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103d51:	85 d2                	test   %edx,%edx
80103d53:	0f 84 8f 00 00 00    	je     80103de8 <piperead+0xf8>
    if(myproc()->killed){
80103d59:	e8 02 03 00 00       	call   80104060 <myproc>
80103d5e:	8b 48 24             	mov    0x24(%eax),%ecx
80103d61:	85 c9                	test   %ecx,%ecx
80103d63:	74 cb                	je     80103d30 <piperead+0x40>
      release(&p->lock);
80103d65:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103d68:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103d6d:	56                   	push   %esi
80103d6e:	e8 fd 16 00 00       	call   80105470 <release>
      return -1;
80103d73:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d79:	89 d8                	mov    %ebx,%eax
80103d7b:	5b                   	pop    %ebx
80103d7c:	5e                   	pop    %esi
80103d7d:	5f                   	pop    %edi
80103d7e:	5d                   	pop    %ebp
80103d7f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d80:	8b 45 10             	mov    0x10(%ebp),%eax
80103d83:	85 c0                	test   %eax,%eax
80103d85:	7e 61                	jle    80103de8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103d87:	31 db                	xor    %ebx,%ebx
80103d89:	eb 13                	jmp    80103d9e <piperead+0xae>
80103d8b:	90                   	nop
80103d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d90:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d96:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d9c:	74 1f                	je     80103dbd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103d9e:	8d 41 01             	lea    0x1(%ecx),%eax
80103da1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103da7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103dad:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103db2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103db5:	83 c3 01             	add    $0x1,%ebx
80103db8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103dbb:	75 d3                	jne    80103d90 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103dbd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103dc3:	83 ec 0c             	sub    $0xc,%esp
80103dc6:	50                   	push   %eax
80103dc7:	e8 54 0b 00 00       	call   80104920 <wakeup>
  release(&p->lock);
80103dcc:	89 34 24             	mov    %esi,(%esp)
80103dcf:	e8 9c 16 00 00       	call   80105470 <release>
  return i;
80103dd4:	83 c4 10             	add    $0x10,%esp
}
80103dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dda:	89 d8                	mov    %ebx,%eax
80103ddc:	5b                   	pop    %ebx
80103ddd:	5e                   	pop    %esi
80103dde:	5f                   	pop    %edi
80103ddf:	5d                   	pop    %ebp
80103de0:	c3                   	ret    
80103de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103de8:	31 db                	xor    %ebx,%ebx
80103dea:	eb d1                	jmp    80103dbd <piperead+0xcd>
80103dec:	66 90                	xchg   %ax,%ax
80103dee:	66 90                	xchg   %ax,%ax

80103df0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df4:	bb 74 4d 18 80       	mov    $0x80184d74,%ebx
{
80103df9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103dfc:	68 40 4d 18 80       	push   $0x80184d40
80103e01:	e8 aa 15 00 00       	call   801053b0 <acquire>
80103e06:	83 c4 10             	add    $0x10,%esp
80103e09:	eb 17                	jmp    80103e22 <allocproc+0x32>
80103e0b:	90                   	nop
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e10:	81 c3 18 04 00 00    	add    $0x418,%ebx
80103e16:	81 fb 74 53 19 80    	cmp    $0x80195374,%ebx
80103e1c:	0f 83 09 01 00 00    	jae    80103f2b <allocproc+0x13b>
    if(p->state == UNUSED)
80103e22:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e25:	85 c0                	test   %eax,%eax
80103e27:	75 e7                	jne    80103e10 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e29:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103e2e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103e31:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103e38:	8d 50 01             	lea    0x1(%eax),%edx
80103e3b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103e3e:	68 40 4d 18 80       	push   $0x80184d40
  p->pid = nextpid++;
80103e43:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103e49:	e8 22 16 00 00       	call   80105470 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103e4e:	e8 ed ec ff ff       	call   80102b40 <kalloc>
80103e53:	83 c4 10             	add    $0x10,%esp
80103e56:	85 c0                	test   %eax,%eax
80103e58:	89 43 08             	mov    %eax,0x8(%ebx)
80103e5b:	0f 84 e3 00 00 00    	je     80103f44 <allocproc+0x154>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e61:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103e67:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e6a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103e6f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103e72:	c7 40 14 22 67 10 80 	movl   $0x80106722,0x14(%eax)
  p->context = (struct context*)sp;
80103e79:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103e7c:	6a 14                	push   $0x14
80103e7e:	6a 00                	push   $0x0
80103e80:	50                   	push   %eax
80103e81:	e8 3a 16 00 00       	call   801054c0 <memset>
  p->context->eip = (uint)forkret;
80103e86:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e89:	8d 93 80 03 00 00    	lea    0x380(%ebx),%edx
80103e8f:	83 c4 10             	add    $0x10,%esp
80103e92:	c7 40 10 50 3f 10 80 	movl   $0x80103f50,0x10(%eax)
80103e99:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  
  //////////////////////////ASSIGNMENT 3////////////
  /**initialization of all the fields**/
  p->free_swapfile_offset = 0;
80103e9f:	c7 83 00 04 00 00 00 	movl   $0x0,0x400(%ebx)
80103ea6:	00 00 00 
  p->swapped_pages_now = 0;
80103ea9:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80103eb0:	00 00 00 
  p->total_swaps = 0;
80103eb3:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80103eba:	00 00 00 
  p->page_faults_now = 0;
80103ebd:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
80103ec4:	00 00 00 
  p->total_page_faults = 0;
80103ec7:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80103ece:	00 00 00 
  p->total_allocated_pages = 0;
80103ed1:	c7 83 04 04 00 00 00 	movl   $0x0,0x404(%ebx)
80103ed8:	00 00 00 
80103edb:	90                   	nop
80103edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  int i;
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
    p->pages[i].virtual_addr = 0;
80103ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    p->pages[i].offset_in_swapfile = -1;
80103ee6:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
80103eed:	83 c0 18             	add    $0x18,%eax
    p->pages[i].in_RAM = 0;
80103ef0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    p->pages[i].allocated = 0;
80103ef7:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    
    #if defined(LAPA)// in this policy, we want to initialize the age to be the largest number there is..
      p->pages[i].age = 0xFFFFFFFF;
    #else
      p->pages[i].age = 0x00000000;
80103efe:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
80103f05:	39 d0                	cmp    %edx,%eax
80103f07:	75 d7                	jne    80103ee0 <allocproc+0xf0>
80103f09:	8d 93 c0 03 00 00    	lea    0x3c0(%ebx),%edx
80103f0f:	90                   	nop
    #endif
  }
  int j;
  for(j = 0; j<MAX_PYSC_PAGES;j++){ //there is nothing and the ram, and there is no need to use the queue for the swapfile's offsets
    p->inRAM[j] = -1;
80103f10:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    p->free_swapfile_offsets[j] = -1;
80103f16:	c7 40 40 ff ff ff ff 	movl   $0xffffffff,0x40(%eax)
80103f1d:	83 c0 04             	add    $0x4,%eax
  for(j = 0; j<MAX_PYSC_PAGES;j++){ //there is nothing and the ram, and there is no need to use the queue for the swapfile's offsets
80103f20:	39 c2                	cmp    %eax,%edx
80103f22:	75 ec                	jne    80103f10 <allocproc+0x120>
  }
  //createSwapFile(p);  //new swap file for a new process
//////////////////END///////////////////
  return p;
}
80103f24:	89 d8                	mov    %ebx,%eax
80103f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f29:	c9                   	leave  
80103f2a:	c3                   	ret    
  release(&ptable.lock);
80103f2b:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103f2e:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103f30:	68 40 4d 18 80       	push   $0x80184d40
80103f35:	e8 36 15 00 00       	call   80105470 <release>
}
80103f3a:	89 d8                	mov    %ebx,%eax
  return 0;
80103f3c:	83 c4 10             	add    $0x10,%esp
}
80103f3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f42:	c9                   	leave  
80103f43:	c3                   	ret    
    p->state = UNUSED;
80103f44:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103f4b:	31 db                	xor    %ebx,%ebx
80103f4d:	eb d5                	jmp    80103f24 <allocproc+0x134>
80103f4f:	90                   	nop

80103f50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103f56:	68 40 4d 18 80       	push   $0x80184d40
80103f5b:	e8 10 15 00 00       	call   80105470 <release>

  if (first) {
80103f60:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	85 c0                	test   %eax,%eax
80103f6a:	75 04                	jne    80103f70 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f6c:	c9                   	leave  
80103f6d:	c3                   	ret    
80103f6e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103f70:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103f73:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103f7a:	00 00 00 
    iinit(ROOTDEV);
80103f7d:	6a 01                	push   $0x1
80103f7f:	e8 dc d7 ff ff       	call   80101760 <iinit>
    initlog(ROOTDEV);
80103f84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f8b:	e8 60 f3 ff ff       	call   801032f0 <initlog>
80103f90:	83 c4 10             	add    $0x10,%esp
}
80103f93:	c9                   	leave  
80103f94:	c3                   	ret    
80103f95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <pinit>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103fa6:	68 55 8d 10 80       	push   $0x80108d55
80103fab:	68 40 4d 18 80       	push   $0x80184d40
80103fb0:	e8 bb 12 00 00       	call   80105270 <initlock>
}
80103fb5:	83 c4 10             	add    $0x10,%esp
80103fb8:	c9                   	leave  
80103fb9:	c3                   	ret    
80103fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fc0 <mycpu>:
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	56                   	push   %esi
80103fc4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fc5:	9c                   	pushf  
80103fc6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fc7:	f6 c4 02             	test   $0x2,%ah
80103fca:	75 5e                	jne    8010402a <mycpu+0x6a>
  apicid = lapicid();
80103fcc:	e8 4f ef ff ff       	call   80102f20 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103fd1:	8b 35 20 4d 18 80    	mov    0x80184d20,%esi
80103fd7:	85 f6                	test   %esi,%esi
80103fd9:	7e 42                	jle    8010401d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103fdb:	0f b6 15 a0 47 18 80 	movzbl 0x801847a0,%edx
80103fe2:	39 d0                	cmp    %edx,%eax
80103fe4:	74 30                	je     80104016 <mycpu+0x56>
80103fe6:	b9 50 48 18 80       	mov    $0x80184850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103feb:	31 d2                	xor    %edx,%edx
80103fed:	8d 76 00             	lea    0x0(%esi),%esi
80103ff0:	83 c2 01             	add    $0x1,%edx
80103ff3:	39 f2                	cmp    %esi,%edx
80103ff5:	74 26                	je     8010401d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103ff7:	0f b6 19             	movzbl (%ecx),%ebx
80103ffa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104000:	39 c3                	cmp    %eax,%ebx
80104002:	75 ec                	jne    80103ff0 <mycpu+0x30>
80104004:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010400a:	05 a0 47 18 80       	add    $0x801847a0,%eax
}
8010400f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104012:	5b                   	pop    %ebx
80104013:	5e                   	pop    %esi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104016:	b8 a0 47 18 80       	mov    $0x801847a0,%eax
      return &cpus[i];
8010401b:	eb f2                	jmp    8010400f <mycpu+0x4f>
  panic("unknown apicid\n");
8010401d:	83 ec 0c             	sub    $0xc,%esp
80104020:	68 5c 8d 10 80       	push   $0x80108d5c
80104025:	e8 66 c3 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 48 8e 10 80       	push   $0x80108e48
80104032:	e8 59 c3 ff ff       	call   80100390 <panic>
80104037:	89 f6                	mov    %esi,%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104040 <cpuid>:
cpuid() {
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104046:	e8 75 ff ff ff       	call   80103fc0 <mycpu>
8010404b:	2d a0 47 18 80       	sub    $0x801847a0,%eax
}
80104050:	c9                   	leave  
  return mycpu()-cpus;
80104051:	c1 f8 04             	sar    $0x4,%eax
80104054:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010405a:	c3                   	ret    
8010405b:	90                   	nop
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104060 <myproc>:
myproc(void) {
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104067:	e8 74 12 00 00       	call   801052e0 <pushcli>
  c = mycpu();
8010406c:	e8 4f ff ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104071:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104077:	e8 a4 12 00 00       	call   80105320 <popcli>
}
8010407c:	83 c4 04             	add    $0x4,%esp
8010407f:	89 d8                	mov    %ebx,%eax
80104081:	5b                   	pop    %ebx
80104082:	5d                   	pop    %ebp
80104083:	c3                   	ret    
80104084:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010408a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104090 <userinit>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	53                   	push   %ebx
80104094:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104097:	e8 54 fd ff ff       	call   80103df0 <allocproc>
8010409c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010409e:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
801040a3:	e8 58 3e 00 00       	call   80107f00 <setupkvm>
801040a8:	85 c0                	test   %eax,%eax
801040aa:	89 43 04             	mov    %eax,0x4(%ebx)
801040ad:	0f 84 bd 00 00 00    	je     80104170 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801040b3:	83 ec 04             	sub    $0x4,%esp
801040b6:	68 2c 00 00 00       	push   $0x2c
801040bb:	68 60 c4 10 80       	push   $0x8010c460
801040c0:	50                   	push   %eax
801040c1:	e8 4a 3b 00 00       	call   80107c10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801040c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801040c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801040cf:	6a 4c                	push   $0x4c
801040d1:	6a 00                	push   $0x0
801040d3:	ff 73 18             	pushl  0x18(%ebx)
801040d6:	e8 e5 13 00 00       	call   801054c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040db:	8b 43 18             	mov    0x18(%ebx),%eax
801040de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040e3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801040e8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040ef:	8b 43 18             	mov    0x18(%ebx),%eax
801040f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040f6:	8b 43 18             	mov    0x18(%ebx),%eax
801040f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104101:	8b 43 18             	mov    0x18(%ebx),%eax
80104104:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104108:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010410c:	8b 43 18             	mov    0x18(%ebx),%eax
8010410f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104116:	8b 43 18             	mov    0x18(%ebx),%eax
80104119:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104120:	8b 43 18             	mov    0x18(%ebx),%eax
80104123:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010412a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010412d:	6a 10                	push   $0x10
8010412f:	68 85 8d 10 80       	push   $0x80108d85
80104134:	50                   	push   %eax
80104135:	e8 66 15 00 00       	call   801056a0 <safestrcpy>
  p->cwd = namei("/");
8010413a:	c7 04 24 8e 8d 10 80 	movl   $0x80108d8e,(%esp)
80104141:	e8 7a e0 ff ff       	call   801021c0 <namei>
80104146:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104149:	c7 04 24 40 4d 18 80 	movl   $0x80184d40,(%esp)
80104150:	e8 5b 12 00 00       	call   801053b0 <acquire>
  p->state = RUNNABLE;
80104155:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010415c:	c7 04 24 40 4d 18 80 	movl   $0x80184d40,(%esp)
80104163:	e8 08 13 00 00       	call   80105470 <release>
}
80104168:	83 c4 10             	add    $0x10,%esp
8010416b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010416e:	c9                   	leave  
8010416f:	c3                   	ret    
    panic("userinit: out of memory?");
80104170:	83 ec 0c             	sub    $0xc,%esp
80104173:	68 6c 8d 10 80       	push   $0x80108d6c
80104178:	e8 13 c2 ff ff       	call   80100390 <panic>
8010417d:	8d 76 00             	lea    0x0(%esi),%esi

80104180 <growproc>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
80104185:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104188:	e8 53 11 00 00       	call   801052e0 <pushcli>
  c = mycpu();
8010418d:	e8 2e fe ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104192:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104198:	e8 83 11 00 00       	call   80105320 <popcli>
  if(n > 0){
8010419d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801041a0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801041a2:	7f 1c                	jg     801041c0 <growproc+0x40>
  } else if(n < 0){
801041a4:	75 3a                	jne    801041e0 <growproc+0x60>
  switchuvm(curproc);
801041a6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801041a9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801041ab:	53                   	push   %ebx
801041ac:	e8 4f 39 00 00       	call   80107b00 <switchuvm>
  return 0;
801041b1:	83 c4 10             	add    $0x10,%esp
801041b4:	31 c0                	xor    %eax,%eax
}
801041b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041b9:	5b                   	pop    %ebx
801041ba:	5e                   	pop    %esi
801041bb:	5d                   	pop    %ebp
801041bc:	c3                   	ret    
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041c0:	83 ec 04             	sub    $0x4,%esp
801041c3:	01 c6                	add    %eax,%esi
801041c5:	56                   	push   %esi
801041c6:	50                   	push   %eax
801041c7:	ff 73 04             	pushl  0x4(%ebx)
801041ca:	e8 e1 40 00 00       	call   801082b0 <allocuvm>
801041cf:	83 c4 10             	add    $0x10,%esp
801041d2:	85 c0                	test   %eax,%eax
801041d4:	75 d0                	jne    801041a6 <growproc+0x26>
      return -1;
801041d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041db:	eb d9                	jmp    801041b6 <growproc+0x36>
801041dd:	8d 76 00             	lea    0x0(%esi),%esi
    curproc->total_allocated_pages += (PGROUNDUP(n)/PGSIZE);//subtracts the number of allocated pages (if the number is positive, it will be done in allocuvm)
801041e0:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n,  1)) == 0)  //we do want deallocate_page to be called
801041e6:	01 c6                	add    %eax,%esi
    curproc->total_allocated_pages += (PGROUNDUP(n)/PGSIZE);//subtracts the number of allocated pages (if the number is positive, it will be done in allocuvm)
801041e8:	c1 fa 0c             	sar    $0xc,%edx
801041eb:	01 93 04 04 00 00    	add    %edx,0x404(%ebx)
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n,  1)) == 0)  //we do want deallocate_page to be called
801041f1:	6a 01                	push   $0x1
801041f3:	56                   	push   %esi
801041f4:	50                   	push   %eax
801041f5:	ff 73 04             	pushl  0x4(%ebx)
801041f8:	e8 53 3b 00 00       	call   80107d50 <deallocuvm>
801041fd:	83 c4 10             	add    $0x10,%esp
80104200:	85 c0                	test   %eax,%eax
80104202:	75 a2                	jne    801041a6 <growproc+0x26>
80104204:	eb d0                	jmp    801041d6 <growproc+0x56>
80104206:	8d 76 00             	lea    0x0(%esi),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104210 <fork>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104219:	e8 c2 10 00 00       	call   801052e0 <pushcli>
  c = mycpu();
8010421e:	e8 9d fd ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104223:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104229:	e8 f2 10 00 00       	call   80105320 <popcli>
  if((np = allocproc()) == 0){
8010422e:	e8 bd fb ff ff       	call   80103df0 <allocproc>
80104233:	85 c0                	test   %eax,%eax
80104235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104238:	0f 84 f5 01 00 00    	je     80104433 <fork+0x223>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){ // we call the COW function instead of copyuvm
8010423e:	83 ec 08             	sub    $0x8,%esp
80104241:	ff 33                	pushl  (%ebx)
80104243:	ff 73 04             	pushl  0x4(%ebx)
80104246:	e8 85 3d 00 00       	call   80107fd0 <copyuvm>
8010424b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010424e:	83 c4 10             	add    $0x10,%esp
80104251:	85 c0                	test   %eax,%eax
80104253:	89 42 04             	mov    %eax,0x4(%edx)
80104256:	0f 84 e3 01 00 00    	je     8010443f <fork+0x22f>
  np->sz = curproc->sz;
8010425c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
8010425e:	8b 7a 18             	mov    0x18(%edx),%edi
80104261:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80104266:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
80104269:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010426b:	8b 73 18             	mov    0x18(%ebx),%esi
8010426e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104270:	31 f6                	xor    %esi,%esi
80104272:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80104274:	8b 42 18             	mov    0x18(%edx),%eax
80104277:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010427e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80104280:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104284:	85 c0                	test   %eax,%eax
80104286:	74 10                	je     80104298 <fork+0x88>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104288:	83 ec 0c             	sub    $0xc,%esp
8010428b:	50                   	push   %eax
8010428c:	e8 3f ce ff ff       	call   801010d0 <filedup>
80104291:	83 c4 10             	add    $0x10,%esp
80104294:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104298:	83 c6 01             	add    $0x1,%esi
8010429b:	83 fe 10             	cmp    $0x10,%esi
8010429e:	75 e0                	jne    80104280 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801042a0:	83 ec 0c             	sub    $0xc,%esp
801042a3:	ff 73 68             	pushl  0x68(%ebx)
801042a6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801042a9:	e8 82 d6 ff ff       	call   80101930 <idup>
801042ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042b1:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801042b4:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042b7:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042ba:	6a 10                	push   $0x10
801042bc:	50                   	push   %eax
801042bd:	8d 42 6c             	lea    0x6c(%edx),%eax
801042c0:	50                   	push   %eax
801042c1:	e8 da 13 00 00       	call   801056a0 <safestrcpy>
  pid = np->pid;
801042c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if(np->pid > 2){ //if so, then we can copy everything to np (in case of course, we are in one of the policies)
801042c9:	83 c4 10             	add    $0x10,%esp
  pid = np->pid;
801042cc:	8b 42 10             	mov    0x10(%edx),%eax
  if(np->pid > 2){ //if so, then we can copy everything to np (in case of course, we are in one of the policies)
801042cf:	83 f8 02             	cmp    $0x2,%eax
  pid = np->pid;
801042d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(np->pid > 2){ //if so, then we can copy everything to np (in case of course, we are in one of the policies)
801042d5:	7f 39                	jg     80104310 <fork+0x100>
  acquire(&ptable.lock);
801042d7:	83 ec 0c             	sub    $0xc,%esp
801042da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801042dd:	68 40 4d 18 80       	push   $0x80184d40
801042e2:	e8 c9 10 00 00       	call   801053b0 <acquire>
  np->state = RUNNABLE;
801042e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042ea:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801042f1:	c7 04 24 40 4d 18 80 	movl   $0x80184d40,(%esp)
801042f8:	e8 73 11 00 00       	call   80105470 <release>
  return pid;
801042fd:	83 c4 10             	add    $0x10,%esp
}
80104300:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104303:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104306:	5b                   	pop    %ebx
80104307:	5e                   	pop    %esi
80104308:	5f                   	pop    %edi
80104309:	5d                   	pop    %ebp
8010430a:	c3                   	ret    
8010430b:	90                   	nop
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    createSwapFile(np);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	8d b3 80 03 00 00    	lea    0x380(%ebx),%esi
80104319:	52                   	push   %edx
8010431a:	e8 71 e1 ff ff       	call   80102490 <createSwapFile>
    np->free_swapfile_offset = curproc->free_swapfile_offset;
8010431f:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
80104325:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
    np->swapped_pages_now = curproc->swapped_pages_now;
80104331:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
80104337:	8d 8a 80 00 00 00    	lea    0x80(%edx),%ecx
    np->total_swaps = 0;
8010433d:	c7 82 10 04 00 00 00 	movl   $0x0,0x410(%edx)
80104344:	00 00 00 
    np->swapped_pages_now = curproc->swapped_pages_now;
80104347:	89 82 0c 04 00 00    	mov    %eax,0x40c(%edx)
    np->total_allocated_pages = curproc->total_allocated_pages;
8010434d:	8b 83 04 04 00 00    	mov    0x404(%ebx),%eax
    np->page_faults_now = 0;
80104353:	c7 82 08 04 00 00 00 	movl   $0x0,0x408(%edx)
8010435a:	00 00 00 
    np->total_allocated_pages = curproc->total_allocated_pages;
8010435d:	89 82 04 04 00 00    	mov    %eax,0x404(%edx)
80104363:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80104369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      np->pages[i].virtual_addr = curproc->pages[i].virtual_addr;
80104370:	8b 38                	mov    (%eax),%edi
80104372:	83 c0 18             	add    $0x18,%eax
80104375:	83 c1 18             	add    $0x18,%ecx
80104378:	89 79 e8             	mov    %edi,-0x18(%ecx)
      np->pages[i].offset_in_swapfile = curproc->pages[i].offset_in_swapfile;
8010437b:	8b 78 ec             	mov    -0x14(%eax),%edi
8010437e:	89 79 ec             	mov    %edi,-0x14(%ecx)
      np->pages[i].age = curproc->pages[i].age;
80104381:	8b 78 f0             	mov    -0x10(%eax),%edi
80104384:	89 79 f0             	mov    %edi,-0x10(%ecx)
      np->pages[i].allocated = curproc->pages[i].allocated;
80104387:	8b 78 f8             	mov    -0x8(%eax),%edi
8010438a:	89 79 f8             	mov    %edi,-0x8(%ecx)
      np->pages[i].in_RAM = curproc->pages[i].in_RAM;
8010438d:	8b 78 fc             	mov    -0x4(%eax),%edi
80104390:	89 79 fc             	mov    %edi,-0x4(%ecx)
    for(i = 0; i < MAX_TOTAL_PAGES; i++){ // we want to deep copy the 'pages' field from the father proccess
80104393:	39 f0                	cmp    %esi,%eax
80104395:	75 d9                	jne    80104370 <fork+0x160>
80104397:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    char* page_for_copying = kalloc(); // this is the address for the page we are going to use in the readFromSwapFile and WriteToSwapFile functions (which pretty much require a page)
8010439a:	e8 a1 e7 ff ff       	call   80102b40 <kalloc>
8010439f:	89 c7                	mov    %eax,%edi
    for(k = 0; k < curproc->swapped_pages_now; k++){// we want the np's swap file to be identical to the curproc's swap file
801043a1:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
801043a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043aa:	85 c0                	test   %eax,%eax
801043ac:	74 42                	je     801043f0 <fork+0x1e0>
801043ae:	31 f6                	xor    %esi,%esi
801043b0:	89 55 e0             	mov    %edx,-0x20(%ebp)
801043b3:	90                   	nop
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b8:	89 f2                	mov    %esi,%edx
      readFromSwapFile(curproc, page_for_copying, offset, PGSIZE);  //copy from curproc
801043ba:	68 00 10 00 00       	push   $0x1000
    for(k = 0; k < curproc->swapped_pages_now; k++){// we want the np's swap file to be identical to the curproc's swap file
801043bf:	83 c6 01             	add    $0x1,%esi
801043c2:	c1 e2 0c             	shl    $0xc,%edx
      readFromSwapFile(curproc, page_for_copying, offset, PGSIZE);  //copy from curproc
801043c5:	52                   	push   %edx
801043c6:	57                   	push   %edi
801043c7:	53                   	push   %ebx
801043c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801043cb:	e8 90 e1 ff ff       	call   80102560 <readFromSwapFile>
      writeToSwapFile(np, page_for_copying, offset, PGSIZE);  // paste in np
801043d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043d3:	68 00 10 00 00       	push   $0x1000
801043d8:	52                   	push   %edx
801043d9:	57                   	push   %edi
801043da:	ff 75 e0             	pushl  -0x20(%ebp)
801043dd:	e8 4e e1 ff ff       	call   80102530 <writeToSwapFile>
    for(k = 0; k < curproc->swapped_pages_now; k++){// we want the np's swap file to be identical to the curproc's swap file
801043e2:	83 c4 20             	add    $0x20,%esp
801043e5:	39 b3 0c 04 00 00    	cmp    %esi,0x40c(%ebx)
801043eb:	77 cb                	ja     801043b8 <fork+0x1a8>
801043ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
    for(j = 0; j<MAX_PYSC_PAGES; j++){
801043f0:	31 c0                	xor    %eax,%eax
801043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      np->free_swapfile_offsets[j] = curproc->free_swapfile_offsets[j];
801043f8:	8b 8c 83 c0 03 00 00 	mov    0x3c0(%ebx,%eax,4),%ecx
801043ff:	89 8c 82 c0 03 00 00 	mov    %ecx,0x3c0(%edx,%eax,4)
      np->inRAM[j] = curproc->inRAM[j];
80104406:	8b 8c 83 80 03 00 00 	mov    0x380(%ebx,%eax,4),%ecx
8010440d:	89 8c 82 80 03 00 00 	mov    %ecx,0x380(%edx,%eax,4)
    for(j = 0; j<MAX_PYSC_PAGES; j++){
80104414:	83 c0 01             	add    $0x1,%eax
80104417:	83 f8 10             	cmp    $0x10,%eax
8010441a:	75 dc                	jne    801043f8 <fork+0x1e8>
    kfree(page_for_copying); // we finished copying so we don't need the page anymore
8010441c:	83 ec 0c             	sub    $0xc,%esp
8010441f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104422:	57                   	push   %edi
80104423:	e8 58 e5 ff ff       	call   80102980 <kfree>
80104428:	83 c4 10             	add    $0x10,%esp
8010442b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010442e:	e9 a4 fe ff ff       	jmp    801042d7 <fork+0xc7>
    return -1;
80104433:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
8010443a:	e9 c1 fe ff ff       	jmp    80104300 <fork+0xf0>
    kfree(np->kstack);
8010443f:	83 ec 0c             	sub    $0xc,%esp
80104442:	ff 72 08             	pushl  0x8(%edx)
80104445:	e8 36 e5 ff ff       	call   80102980 <kfree>
    np->kstack = 0;
8010444a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
8010444d:	83 c4 10             	add    $0x10,%esp
80104450:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
    np->kstack = 0;
80104457:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010445e:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104465:	e9 96 fe ff ff       	jmp    80104300 <fork+0xf0>
8010446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104470 <scheduler>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104479:	e8 42 fb ff ff       	call   80103fc0 <mycpu>
8010447e:	8d 78 04             	lea    0x4(%eax),%edi
80104481:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104483:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010448a:	00 00 00 
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104490:	fb                   	sti    
    acquire(&ptable.lock);
80104491:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104494:	bb 74 4d 18 80       	mov    $0x80184d74,%ebx
    acquire(&ptable.lock);
80104499:	68 40 4d 18 80       	push   $0x80184d40
8010449e:	e8 0d 0f 00 00       	call   801053b0 <acquire>
801044a3:	83 c4 10             	add    $0x10,%esp
801044a6:	8d 76 00             	lea    0x0(%esi),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801044b0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801044b4:	75 33                	jne    801044e9 <scheduler+0x79>
      switchuvm(p);
801044b6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801044b9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801044bf:	53                   	push   %ebx
801044c0:	e8 3b 36 00 00       	call   80107b00 <switchuvm>
      swtch(&(c->scheduler), p->context);
801044c5:	58                   	pop    %eax
801044c6:	5a                   	pop    %edx
801044c7:	ff 73 1c             	pushl  0x1c(%ebx)
801044ca:	57                   	push   %edi
      p->state = RUNNING;
801044cb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801044d2:	e8 24 12 00 00       	call   801056fb <swtch>
      switchkvm();
801044d7:	e8 04 36 00 00       	call   80107ae0 <switchkvm>
      c->proc = 0;
801044dc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801044e3:	00 00 00 
801044e6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e9:	81 c3 18 04 00 00    	add    $0x418,%ebx
801044ef:	81 fb 74 53 19 80    	cmp    $0x80195374,%ebx
801044f5:	72 b9                	jb     801044b0 <scheduler+0x40>
    release(&ptable.lock);
801044f7:	83 ec 0c             	sub    $0xc,%esp
801044fa:	68 40 4d 18 80       	push   $0x80184d40
801044ff:	e8 6c 0f 00 00       	call   80105470 <release>
    sti();
80104504:	83 c4 10             	add    $0x10,%esp
80104507:	eb 87                	jmp    80104490 <scheduler+0x20>
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104510 <sched>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
  pushcli();
80104515:	e8 c6 0d 00 00       	call   801052e0 <pushcli>
  c = mycpu();
8010451a:	e8 a1 fa ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
8010451f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104525:	e8 f6 0d 00 00       	call   80105320 <popcli>
  if(!holding(&ptable.lock))
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	68 40 4d 18 80       	push   $0x80184d40
80104532:	e8 49 0e 00 00       	call   80105380 <holding>
80104537:	83 c4 10             	add    $0x10,%esp
8010453a:	85 c0                	test   %eax,%eax
8010453c:	74 4f                	je     8010458d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010453e:	e8 7d fa ff ff       	call   80103fc0 <mycpu>
80104543:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010454a:	75 68                	jne    801045b4 <sched+0xa4>
  if(p->state == RUNNING)
8010454c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104550:	74 55                	je     801045a7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104552:	9c                   	pushf  
80104553:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104554:	f6 c4 02             	test   $0x2,%ah
80104557:	75 41                	jne    8010459a <sched+0x8a>
  intena = mycpu()->intena;
80104559:	e8 62 fa ff ff       	call   80103fc0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010455e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104561:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104567:	e8 54 fa ff ff       	call   80103fc0 <mycpu>
8010456c:	83 ec 08             	sub    $0x8,%esp
8010456f:	ff 70 04             	pushl  0x4(%eax)
80104572:	53                   	push   %ebx
80104573:	e8 83 11 00 00       	call   801056fb <swtch>
  mycpu()->intena = intena;
80104578:	e8 43 fa ff ff       	call   80103fc0 <mycpu>
}
8010457d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104580:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104586:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104589:	5b                   	pop    %ebx
8010458a:	5e                   	pop    %esi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret    
    panic("sched ptable.lock");
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	68 90 8d 10 80       	push   $0x80108d90
80104595:	e8 f6 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010459a:	83 ec 0c             	sub    $0xc,%esp
8010459d:	68 bc 8d 10 80       	push   $0x80108dbc
801045a2:	e8 e9 bd ff ff       	call   80100390 <panic>
    panic("sched running");
801045a7:	83 ec 0c             	sub    $0xc,%esp
801045aa:	68 ae 8d 10 80       	push   $0x80108dae
801045af:	e8 dc bd ff ff       	call   80100390 <panic>
    panic("sched locks");
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	68 a2 8d 10 80       	push   $0x80108da2
801045bc:	e8 cf bd ff ff       	call   80100390 <panic>
801045c1:	eb 0d                	jmp    801045d0 <exit>
801045c3:	90                   	nop
801045c4:	90                   	nop
801045c5:	90                   	nop
801045c6:	90                   	nop
801045c7:	90                   	nop
801045c8:	90                   	nop
801045c9:	90                   	nop
801045ca:	90                   	nop
801045cb:	90                   	nop
801045cc:	90                   	nop
801045cd:	90                   	nop
801045ce:	90                   	nop
801045cf:	90                   	nop

801045d0 <exit>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045d9:	e8 02 0d 00 00       	call   801052e0 <pushcli>
  c = mycpu();
801045de:	e8 dd f9 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
801045e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e9:	e8 32 0d 00 00       	call   80105320 <popcli>
  if(curproc == initproc)
801045ee:	39 1d b8 c5 10 80    	cmp    %ebx,0x8010c5b8
801045f4:	8d 73 28             	lea    0x28(%ebx),%esi
801045f7:	8d 7b 68             	lea    0x68(%ebx),%edi
801045fa:	0f 84 01 01 00 00    	je     80104701 <exit+0x131>
    if(curproc->ofile[fd]){
80104600:	8b 06                	mov    (%esi),%eax
80104602:	85 c0                	test   %eax,%eax
80104604:	74 12                	je     80104618 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104606:	83 ec 0c             	sub    $0xc,%esp
80104609:	50                   	push   %eax
8010460a:	e8 11 cb ff ff       	call   80101120 <fileclose>
      curproc->ofile[fd] = 0;
8010460f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104615:	83 c4 10             	add    $0x10,%esp
80104618:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010461b:	39 fe                	cmp    %edi,%esi
8010461d:	75 e1                	jne    80104600 <exit+0x30>
  begin_op();
8010461f:	e8 6c ed ff ff       	call   80103390 <begin_op>
  iput(curproc->cwd);
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	ff 73 68             	pushl  0x68(%ebx)
8010462a:	e8 61 d4 ff ff       	call   80101a90 <iput>
  end_op();
8010462f:	e8 cc ed ff ff       	call   80103400 <end_op>
  curproc->cwd = 0;
80104634:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    removeSwapFile(curproc);
8010463b:	89 1c 24             	mov    %ebx,(%esp)
8010463e:	e8 4d dc ff ff       	call   80102290 <removeSwapFile>
  acquire(&ptable.lock);
80104643:	c7 04 24 40 4d 18 80 	movl   $0x80184d40,(%esp)
8010464a:	e8 61 0d 00 00       	call   801053b0 <acquire>
  wakeup1(curproc->parent);
8010464f:	8b 53 14             	mov    0x14(%ebx),%edx
80104652:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104655:	b8 74 4d 18 80       	mov    $0x80184d74,%eax
8010465a:	eb 10                	jmp    8010466c <exit+0x9c>
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104660:	05 18 04 00 00       	add    $0x418,%eax
80104665:	3d 74 53 19 80       	cmp    $0x80195374,%eax
8010466a:	73 1e                	jae    8010468a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010466c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104670:	75 ee                	jne    80104660 <exit+0x90>
80104672:	3b 50 20             	cmp    0x20(%eax),%edx
80104675:	75 e9                	jne    80104660 <exit+0x90>
      p->state = RUNNABLE;
80104677:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010467e:	05 18 04 00 00       	add    $0x418,%eax
80104683:	3d 74 53 19 80       	cmp    $0x80195374,%eax
80104688:	72 e2                	jb     8010466c <exit+0x9c>
      p->parent = initproc;
8010468a:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104690:	ba 74 4d 18 80       	mov    $0x80184d74,%edx
80104695:	eb 17                	jmp    801046ae <exit+0xde>
80104697:	89 f6                	mov    %esi,%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801046a0:	81 c2 18 04 00 00    	add    $0x418,%edx
801046a6:	81 fa 74 53 19 80    	cmp    $0x80195374,%edx
801046ac:	73 3a                	jae    801046e8 <exit+0x118>
    if(p->parent == curproc){
801046ae:	39 5a 14             	cmp    %ebx,0x14(%edx)
801046b1:	75 ed                	jne    801046a0 <exit+0xd0>
      if(p->state == ZOMBIE)
801046b3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801046b7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801046ba:	75 e4                	jne    801046a0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046bc:	b8 74 4d 18 80       	mov    $0x80184d74,%eax
801046c1:	eb 11                	jmp    801046d4 <exit+0x104>
801046c3:	90                   	nop
801046c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046c8:	05 18 04 00 00       	add    $0x418,%eax
801046cd:	3d 74 53 19 80       	cmp    $0x80195374,%eax
801046d2:	73 cc                	jae    801046a0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801046d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046d8:	75 ee                	jne    801046c8 <exit+0xf8>
801046da:	3b 48 20             	cmp    0x20(%eax),%ecx
801046dd:	75 e9                	jne    801046c8 <exit+0xf8>
      p->state = RUNNABLE;
801046df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046e6:	eb e0                	jmp    801046c8 <exit+0xf8>
  curproc->state = ZOMBIE;
801046e8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801046ef:	e8 1c fe ff ff       	call   80104510 <sched>
  panic("zombie exit");
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	68 dd 8d 10 80       	push   $0x80108ddd
801046fc:	e8 8f bc ff ff       	call   80100390 <panic>
    panic("init exiting");
80104701:	83 ec 0c             	sub    $0xc,%esp
80104704:	68 d0 8d 10 80       	push   $0x80108dd0
80104709:	e8 82 bc ff ff       	call   80100390 <panic>
8010470e:	66 90                	xchg   %ax,%ax

80104710 <yield>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104717:	68 40 4d 18 80       	push   $0x80184d40
8010471c:	e8 8f 0c 00 00       	call   801053b0 <acquire>
  pushcli();
80104721:	e8 ba 0b 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104726:	e8 95 f8 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
8010472b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104731:	e8 ea 0b 00 00       	call   80105320 <popcli>
  myproc()->state = RUNNABLE;
80104736:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010473d:	e8 ce fd ff ff       	call   80104510 <sched>
  release(&ptable.lock);
80104742:	c7 04 24 40 4d 18 80 	movl   $0x80184d40,(%esp)
80104749:	e8 22 0d 00 00       	call   80105470 <release>
}
8010474e:	83 c4 10             	add    $0x10,%esp
80104751:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104754:	c9                   	leave  
80104755:	c3                   	ret    
80104756:	8d 76 00             	lea    0x0(%esi),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <sleep>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	56                   	push   %esi
80104765:	53                   	push   %ebx
80104766:	83 ec 0c             	sub    $0xc,%esp
80104769:	8b 7d 08             	mov    0x8(%ebp),%edi
8010476c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010476f:	e8 6c 0b 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104774:	e8 47 f8 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104779:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010477f:	e8 9c 0b 00 00       	call   80105320 <popcli>
  if(p == 0)
80104784:	85 db                	test   %ebx,%ebx
80104786:	0f 84 87 00 00 00    	je     80104813 <sleep+0xb3>
  if(lk == 0)
8010478c:	85 f6                	test   %esi,%esi
8010478e:	74 76                	je     80104806 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104790:	81 fe 40 4d 18 80    	cmp    $0x80184d40,%esi
80104796:	74 50                	je     801047e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 40 4d 18 80       	push   $0x80184d40
801047a0:	e8 0b 0c 00 00       	call   801053b0 <acquire>
    release(lk);
801047a5:	89 34 24             	mov    %esi,(%esp)
801047a8:	e8 c3 0c 00 00       	call   80105470 <release>
  p->chan = chan;
801047ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047b7:	e8 54 fd ff ff       	call   80104510 <sched>
  p->chan = 0;
801047bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801047c3:	c7 04 24 40 4d 18 80 	movl   $0x80184d40,(%esp)
801047ca:	e8 a1 0c 00 00       	call   80105470 <release>
    acquire(lk);
801047cf:	89 75 08             	mov    %esi,0x8(%ebp)
801047d2:	83 c4 10             	add    $0x10,%esp
}
801047d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047d8:	5b                   	pop    %ebx
801047d9:	5e                   	pop    %esi
801047da:	5f                   	pop    %edi
801047db:	5d                   	pop    %ebp
    acquire(lk);
801047dc:	e9 cf 0b 00 00       	jmp    801053b0 <acquire>
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801047e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047f2:	e8 19 fd ff ff       	call   80104510 <sched>
  p->chan = 0;
801047f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801047fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104801:	5b                   	pop    %ebx
80104802:	5e                   	pop    %esi
80104803:	5f                   	pop    %edi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
    panic("sleep without lk");
80104806:	83 ec 0c             	sub    $0xc,%esp
80104809:	68 ef 8d 10 80       	push   $0x80108def
8010480e:	e8 7d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104813:	83 ec 0c             	sub    $0xc,%esp
80104816:	68 e9 8d 10 80       	push   $0x80108de9
8010481b:	e8 70 bb ff ff       	call   80100390 <panic>

80104820 <wait>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
  pushcli();
80104825:	e8 b6 0a 00 00       	call   801052e0 <pushcli>
  c = mycpu();
8010482a:	e8 91 f7 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
8010482f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104835:	e8 e6 0a 00 00       	call   80105320 <popcli>
  acquire(&ptable.lock);
8010483a:	83 ec 0c             	sub    $0xc,%esp
8010483d:	68 40 4d 18 80       	push   $0x80184d40
80104842:	e8 69 0b 00 00       	call   801053b0 <acquire>
80104847:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010484a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010484c:	bb 74 4d 18 80       	mov    $0x80184d74,%ebx
80104851:	eb 13                	jmp    80104866 <wait+0x46>
80104853:	90                   	nop
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104858:	81 c3 18 04 00 00    	add    $0x418,%ebx
8010485e:	81 fb 74 53 19 80    	cmp    $0x80195374,%ebx
80104864:	73 1e                	jae    80104884 <wait+0x64>
      if(p->parent != curproc)
80104866:	39 73 14             	cmp    %esi,0x14(%ebx)
80104869:	75 ed                	jne    80104858 <wait+0x38>
      if(p->state == ZOMBIE){
8010486b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010486f:	74 37                	je     801048a8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104871:	81 c3 18 04 00 00    	add    $0x418,%ebx
      havekids = 1;
80104877:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010487c:	81 fb 74 53 19 80    	cmp    $0x80195374,%ebx
80104882:	72 e2                	jb     80104866 <wait+0x46>
    if(!havekids || curproc->killed){
80104884:	85 c0                	test   %eax,%eax
80104886:	74 76                	je     801048fe <wait+0xde>
80104888:	8b 46 24             	mov    0x24(%esi),%eax
8010488b:	85 c0                	test   %eax,%eax
8010488d:	75 6f                	jne    801048fe <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010488f:	83 ec 08             	sub    $0x8,%esp
80104892:	68 40 4d 18 80       	push   $0x80184d40
80104897:	56                   	push   %esi
80104898:	e8 c3 fe ff ff       	call   80104760 <sleep>
    havekids = 0;
8010489d:	83 c4 10             	add    $0x10,%esp
801048a0:	eb a8                	jmp    8010484a <wait+0x2a>
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801048ae:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801048b1:	e8 ca e0 ff ff       	call   80102980 <kfree>
        freevm(p->pgdir);
801048b6:	5a                   	pop    %edx
801048b7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801048ba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801048c1:	e8 ba 35 00 00       	call   80107e80 <freevm>
        release(&ptable.lock);
801048c6:	c7 04 24 40 4d 18 80 	movl   $0x80184d40,(%esp)
        p->pid = 0;
801048cd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801048d4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801048db:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801048df:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801048e6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801048ed:	e8 7e 0b 00 00       	call   80105470 <release>
        return pid;
801048f2:	83 c4 10             	add    $0x10,%esp
}
801048f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048f8:	89 f0                	mov    %esi,%eax
801048fa:	5b                   	pop    %ebx
801048fb:	5e                   	pop    %esi
801048fc:	5d                   	pop    %ebp
801048fd:	c3                   	ret    
      release(&ptable.lock);
801048fe:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104901:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104906:	68 40 4d 18 80       	push   $0x80184d40
8010490b:	e8 60 0b 00 00       	call   80105470 <release>
      return -1;
80104910:	83 c4 10             	add    $0x10,%esp
80104913:	eb e0                	jmp    801048f5 <wait+0xd5>
80104915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 10             	sub    $0x10,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010492a:	68 40 4d 18 80       	push   $0x80184d40
8010492f:	e8 7c 0a 00 00       	call   801053b0 <acquire>
80104934:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104937:	b8 74 4d 18 80       	mov    $0x80184d74,%eax
8010493c:	eb 0e                	jmp    8010494c <wakeup+0x2c>
8010493e:	66 90                	xchg   %ax,%ax
80104940:	05 18 04 00 00       	add    $0x418,%eax
80104945:	3d 74 53 19 80       	cmp    $0x80195374,%eax
8010494a:	73 1e                	jae    8010496a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010494c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104950:	75 ee                	jne    80104940 <wakeup+0x20>
80104952:	3b 58 20             	cmp    0x20(%eax),%ebx
80104955:	75 e9                	jne    80104940 <wakeup+0x20>
      p->state = RUNNABLE;
80104957:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010495e:	05 18 04 00 00       	add    $0x418,%eax
80104963:	3d 74 53 19 80       	cmp    $0x80195374,%eax
80104968:	72 e2                	jb     8010494c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010496a:	c7 45 08 40 4d 18 80 	movl   $0x80184d40,0x8(%ebp)
}
80104971:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104974:	c9                   	leave  
  release(&ptable.lock);
80104975:	e9 f6 0a 00 00       	jmp    80105470 <release>
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <getNumPhysPages>:
80104980:	55                   	push   %ebp
80104981:	b8 01 00 00 00       	mov    $0x1,%eax
80104986:	89 e5                	mov    %esp,%ebp
80104988:	5d                   	pop    %ebp
80104989:	c3                   	ret    
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <getNumVirtPages>:

int getNumPhysPages(){
  return 1;
}

int getNumVirtPages(){
80104990:	55                   	push   %ebp
  return 1;
}
80104991:	b8 01 00 00 00       	mov    $0x1,%eax
int getNumVirtPages(){
80104996:	89 e5                	mov    %esp,%ebp
}
80104998:	5d                   	pop    %ebp
80104999:	c3                   	ret    
8010499a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049a0 <kill>:

int
kill(int pid)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 10             	sub    $0x10,%esp
801049a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801049aa:	68 40 4d 18 80       	push   $0x80184d40
801049af:	e8 fc 09 00 00       	call   801053b0 <acquire>
801049b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b7:	b8 74 4d 18 80       	mov    $0x80184d74,%eax
801049bc:	eb 0e                	jmp    801049cc <kill+0x2c>
801049be:	66 90                	xchg   %ax,%ax
801049c0:	05 18 04 00 00       	add    $0x418,%eax
801049c5:	3d 74 53 19 80       	cmp    $0x80195374,%eax
801049ca:	73 34                	jae    80104a00 <kill+0x60>
    if(p->pid == pid){
801049cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801049cf:	75 ef                	jne    801049c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801049d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801049dc:	75 07                	jne    801049e5 <kill+0x45>
        p->state = RUNNABLE;
801049de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049e5:	83 ec 0c             	sub    $0xc,%esp
801049e8:	68 40 4d 18 80       	push   $0x80184d40
801049ed:	e8 7e 0a 00 00       	call   80105470 <release>
      return 0;
801049f2:	83 c4 10             	add    $0x10,%esp
801049f5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801049f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049fa:	c9                   	leave  
801049fb:	c3                   	ret    
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104a00:	83 ec 0c             	sub    $0xc,%esp
80104a03:	68 40 4d 18 80       	push   $0x80184d40
80104a08:	e8 63 0a 00 00       	call   80105470 <release>
  return -1;
80104a0d:	83 c4 10             	add    $0x10,%esp
80104a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a18:	c9                   	leave  
80104a19:	c3                   	ret    
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	53                   	push   %ebx
80104a26:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a29:	bb 74 4d 18 80       	mov    $0x80184d74,%ebx
{
80104a2e:	83 ec 3c             	sub    $0x3c,%esp
80104a31:	eb 27                	jmp    80104a5a <procdump+0x3a>
80104a33:	90                   	nop
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a38:	83 ec 0c             	sub    $0xc,%esp
80104a3b:	68 1c 8e 10 80       	push   $0x80108e1c
80104a40:	e8 1b bc ff ff       	call   80100660 <cprintf>
80104a45:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a48:	81 c3 18 04 00 00    	add    $0x418,%ebx
80104a4e:	81 fb 74 53 19 80    	cmp    $0x80195374,%ebx
80104a54:	0f 83 a6 00 00 00    	jae    80104b00 <procdump+0xe0>
    if(p->state == UNUSED)
80104a5a:	8b 43 0c             	mov    0xc(%ebx),%eax
80104a5d:	85 c0                	test   %eax,%eax
80104a5f:	74 e7                	je     80104a48 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a61:	83 f8 05             	cmp    $0x5,%eax
    else{  state = "???";}
80104a64:	ba 00 8e 10 80       	mov    $0x80108e00,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a69:	77 11                	ja     80104a7c <procdump+0x5c>
80104a6b:	8b 14 85 48 8f 10 80 	mov    -0x7fef70b8(,%eax,4),%edx
    else{  state = "???";}
80104a72:	b8 00 8e 10 80       	mov    $0x80108e00,%eax
80104a77:	85 d2                	test   %edx,%edx
80104a79:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d  %s   Allocated MemPages:%d    Paged Out:%d     Page Faults:%d     Total num Paged Out:%d      %s\n", 
80104a7c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104a7f:	50                   	push   %eax
    p->pid, state, (PGROUNDUP(p->sz)/PGSIZE) , p->swapped_pages_now, p->page_faults_now,p->total_swaps, p->name  );
80104a80:	8b 03                	mov    (%ebx),%eax
    cprintf("%d  %s   Allocated MemPages:%d    Paged Out:%d     Page Faults:%d     Total num Paged Out:%d      %s\n", 
80104a82:	ff b3 10 04 00 00    	pushl  0x410(%ebx)
80104a88:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104a8e:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
    p->pid, state, (PGROUNDUP(p->sz)/PGSIZE) , p->swapped_pages_now, p->page_faults_now,p->total_swaps, p->name  );
80104a94:	05 ff 0f 00 00       	add    $0xfff,%eax
    cprintf("%d  %s   Allocated MemPages:%d    Paged Out:%d     Page Faults:%d     Total num Paged Out:%d      %s\n", 
80104a99:	c1 e8 0c             	shr    $0xc,%eax
80104a9c:	50                   	push   %eax
80104a9d:	52                   	push   %edx
80104a9e:	ff 73 10             	pushl  0x10(%ebx)
80104aa1:	68 70 8e 10 80       	push   $0x80108e70
80104aa6:	e8 b5 bb ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104aab:	83 c4 20             	add    $0x20,%esp
80104aae:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104ab2:	75 84                	jne    80104a38 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ab4:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104ab7:	83 ec 08             	sub    $0x8,%esp
80104aba:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104abd:	50                   	push   %eax
80104abe:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104ac1:	8b 40 0c             	mov    0xc(%eax),%eax
80104ac4:	83 c0 08             	add    $0x8,%eax
80104ac7:	50                   	push   %eax
80104ac8:	e8 c3 07 00 00       	call   80105290 <getcallerpcs>
80104acd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104ad0:	8b 17                	mov    (%edi),%edx
80104ad2:	85 d2                	test   %edx,%edx
80104ad4:	0f 84 5e ff ff ff    	je     80104a38 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104ada:	83 ec 08             	sub    $0x8,%esp
80104add:	83 c7 04             	add    $0x4,%edi
80104ae0:	52                   	push   %edx
80104ae1:	68 01 88 10 80       	push   $0x80108801
80104ae6:	e8 75 bb ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104aeb:	83 c4 10             	add    $0x10,%esp
80104aee:	39 fe                	cmp    %edi,%esi
80104af0:	75 de                	jne    80104ad0 <procdump+0xb0>
80104af2:	e9 41 ff ff ff       	jmp    80104a38 <procdump+0x18>
80104af7:	89 f6                	mov    %esi,%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
  cprintf("Number of free pages:%d \n",getNumFreePages()); 
80104b00:	e8 bb e1 ff ff       	call   80102cc0 <getNumFreePages>
80104b05:	83 ec 08             	sub    $0x8,%esp
80104b08:	50                   	push   %eax
80104b09:	68 04 8e 10 80       	push   $0x80108e04
80104b0e:	e8 4d bb ff ff       	call   80100660 <cprintf>
}
80104b13:	83 c4 10             	add    $0x10,%esp
80104b16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b19:	5b                   	pop    %ebx
80104b1a:	5e                   	pop    %esi
80104b1b:	5f                   	pop    %edi
80104b1c:	5d                   	pop    %ebp
80104b1d:	c3                   	ret    
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <insert_to_RAM_queue>:

void insert_to_RAM_queue(int page_index){
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104b27:	e8 b4 07 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104b2c:	e8 8f f4 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104b31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b37:	e8 e4 07 00 00       	call   80105320 <popcli>
  struct proc *curproc = myproc();
  int i;
  for (i = 0; curproc->inRAM[i] != -1; i++) {
80104b3c:	31 c0                	xor    %eax,%eax
80104b3e:	83 bb 80 03 00 00 ff 	cmpl   $0xffffffff,0x380(%ebx)
80104b45:	74 16                	je     80104b5d <insert_to_RAM_queue+0x3d>
80104b47:	89 f6                	mov    %esi,%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b50:	83 c0 01             	add    $0x1,%eax
80104b53:	83 bc 83 80 03 00 00 	cmpl   $0xffffffff,0x380(%ebx,%eax,4)
80104b5a:	ff 
80104b5b:	75 f3                	jne    80104b50 <insert_to_RAM_queue+0x30>
    if (i == MAX_PYSC_PAGES)
      panic("insert to RAM queue: error in inerstion- FULL!!");
  }
  curproc->inRAM[i] = page_index;
80104b5d:	8b 55 08             	mov    0x8(%ebp),%edx
80104b60:	89 94 83 80 03 00 00 	mov    %edx,0x380(%ebx,%eax,4)
}
80104b67:	83 c4 04             	add    $0x4,%esp
80104b6a:	5b                   	pop    %ebx
80104b6b:	5d                   	pop    %ebp
80104b6c:	c3                   	ret    
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi

80104b70 <insert_to_offsets_queue>:

void insert_to_offsets_queue(int page_index){
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104b77:	e8 64 07 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104b7c:	e8 3f f4 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104b81:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b87:	e8 94 07 00 00       	call   80105320 <popcli>
  struct proc *curproc = myproc();
  int i;
  for (i = 0; curproc->free_swapfile_offsets[i] != -1; i++) {
80104b8c:	31 c0                	xor    %eax,%eax
80104b8e:	83 bb c0 03 00 00 ff 	cmpl   $0xffffffff,0x3c0(%ebx)
80104b95:	74 16                	je     80104bad <insert_to_offsets_queue+0x3d>
80104b97:	89 f6                	mov    %esi,%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ba0:	83 c0 01             	add    $0x1,%eax
80104ba3:	83 bc 83 c0 03 00 00 	cmpl   $0xffffffff,0x3c0(%ebx,%eax,4)
80104baa:	ff 
80104bab:	75 f3                	jne    80104ba0 <insert_to_offsets_queue+0x30>
    if (i == MAX_PYSC_PAGES)
      panic("insert to offsets queue: error in inerstion!");
  }
  curproc->free_swapfile_offsets[i] = page_index;
80104bad:	8b 55 08             	mov    0x8(%ebp),%edx
80104bb0:	89 94 83 c0 03 00 00 	mov    %edx,0x3c0(%ebx,%eax,4)
}
80104bb7:	83 c4 04             	add    $0x4,%esp
80104bba:	5b                   	pop    %ebx
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret    
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi

80104bc0 <move_forward_in_offsets_queue>:



void move_forward_in_offsets_queue(){//moves all the other offsets forward in line in the free offsets queue
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104bc7:	e8 14 07 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104bcc:	e8 ef f3 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104bd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104bd7:	e8 44 07 00 00       	call   80105320 <popcli>
80104bdc:	8d 83 c0 03 00 00    	lea    0x3c0(%ebx),%eax
80104be2:	8d 8b fc 03 00 00    	lea    0x3fc(%ebx),%ecx
80104be8:	90                   	nop
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc* curproc = myproc();
  int i;
  for(i = 0; i < MAX_PYSC_PAGES-1; i++){
    curproc->free_swapfile_offsets[i] = curproc->free_swapfile_offsets[i+1]; // moves everything to the left- one step closer
80104bf0:	8b 50 04             	mov    0x4(%eax),%edx
80104bf3:	83 c0 04             	add    $0x4,%eax
80104bf6:	89 50 fc             	mov    %edx,-0x4(%eax)
  for(i = 0; i < MAX_PYSC_PAGES-1; i++){
80104bf9:	39 c8                	cmp    %ecx,%eax
80104bfb:	75 f3                	jne    80104bf0 <move_forward_in_offsets_queue+0x30>
  }
  curproc->free_swapfile_offsets[MAX_PYSC_PAGES-1] = -1; //clear the last slot
80104bfd:	c7 83 fc 03 00 00 ff 	movl   $0xffffffff,0x3fc(%ebx)
80104c04:	ff ff ff 
}
80104c07:	83 c4 04             	add    $0x4,%esp
80104c0a:	5b                   	pop    %ebx
80104c0b:	5d                   	pop    %ebp
80104c0c:	c3                   	ret    
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi

80104c10 <move_forward_in_inRAM_queue>:

void move_forward_in_inRAM_queue(int index){//moves all the other offsets forward in line in the inRAM queue from a certain point
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104c17:	e8 c4 06 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104c1c:	e8 9f f3 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104c21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c27:	e8 f4 06 00 00       	call   80105320 <popcli>
  struct proc* curproc = myproc();
  while(index < MAX_PYSC_PAGES-1){
80104c2c:	83 7d 08 0e          	cmpl   $0xe,0x8(%ebp)
80104c30:	7f 06                	jg     80104c38 <move_forward_in_inRAM_queue+0x28>
80104c32:	eb fe                	jmp    80104c32 <move_forward_in_inRAM_queue+0x22>
80104c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    curproc->inRAM[index] = curproc->inRAM[index+1]; // moves everything to the left- one step closer
  }
  curproc->inRAM[MAX_PYSC_PAGES-1] = -1; //clear the last slot
80104c38:	c7 83 bc 03 00 00 ff 	movl   $0xffffffff,0x3bc(%ebx)
80104c3f:	ff ff ff 
}
80104c42:	83 c4 04             	add    $0x4,%esp
80104c45:	5b                   	pop    %ebx
80104c46:	5d                   	pop    %ebp
80104c47:	c3                   	ret    
80104c48:	90                   	nop
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c50 <next_in_line>:

int next_in_line(){
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104c57:	e8 84 06 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104c5c:	e8 5f f3 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104c61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c67:	e8 b4 06 00 00       	call   80105320 <popcli>
  struct proc* curproc = myproc();
  int offset = curproc->free_swapfile_offsets[0]; // get the first in line
80104c6c:	8b 9b c0 03 00 00    	mov    0x3c0(%ebx),%ebx
  
  if(offset != -1) // we need to move the others closer
80104c72:	83 fb ff             	cmp    $0xffffffff,%ebx
80104c75:	74 05                	je     80104c7c <next_in_line+0x2c>
    move_forward_in_offsets_queue();
80104c77:	e8 44 ff ff ff       	call   80104bc0 <move_forward_in_offsets_queue>
  
  return offset;
}
80104c7c:	83 c4 04             	add    $0x4,%esp
80104c7f:	89 d8                	mov    %ebx,%eax
80104c81:	5b                   	pop    %ebx
80104c82:	5d                   	pop    %ebp
80104c83:	c3                   	ret    
80104c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c90 <get_free_offset>:

int get_free_offset() {
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104c97:	e8 44 06 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104c9c:	e8 1f f3 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104ca1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ca7:	e8 74 06 00 00       	call   80105320 <popcli>
  struct proc* curproc = myproc();
  int offset = next_in_line();
80104cac:	e8 9f ff ff ff       	call   80104c50 <next_in_line>
  if(offset == -1){ //queue is empty - first time
80104cb1:	83 f8 ff             	cmp    $0xffffffff,%eax
80104cb4:	75 12                	jne    80104cc8 <get_free_offset+0x38>
    offset =curproc->free_swapfile_offset;
80104cb6:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
    curproc->free_swapfile_offset = curproc->free_swapfile_offset + PGSIZE;
80104cbc:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80104cc2:	89 93 00 04 00 00    	mov    %edx,0x400(%ebx)
  }
  return offset;
}
80104cc8:	83 c4 04             	add    $0x4,%esp
80104ccb:	5b                   	pop    %ebx
80104ccc:	5d                   	pop    %ebp
80104ccd:	c3                   	ret    
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <deallocate_page>:


///////////////////////ASSIGNMENT 3/////////////////////////////
void deallocate_page(uint virtual_addr){  // this function is used in order to clear our 'pages' field in the proc struct. will be called only if allocation happend successfully!
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
  struct proc* curproc = myproc();

  int i;
  int j;
  for (i = 0; i < MAX_TOTAL_PAGES; i++) {
80104cd6:	31 db                	xor    %ebx,%ebx
void deallocate_page(uint virtual_addr){  // this function is used in order to clear our 'pages' field in the proc struct. will be called only if allocation happend successfully!
80104cd8:	83 ec 0c             	sub    $0xc,%esp
80104cdb:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80104cde:	e8 fd 05 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104ce3:	e8 d8 f2 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104ce8:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104cee:	e8 2d 06 00 00       	call   80105320 <popcli>
80104cf3:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
80104cf9:	eb 14                	jmp    80104d0f <deallocate_page+0x3f>
80104cfb:	90                   	nop
80104cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < MAX_TOTAL_PAGES; i++) {
80104d00:	83 c3 01             	add    $0x1,%ebx
80104d03:	83 c0 18             	add    $0x18,%eax
80104d06:	83 fb 20             	cmp    $0x20,%ebx
80104d09:	0f 84 81 00 00 00    	je     80104d90 <deallocate_page+0xc0>
    if ((curproc->pages[i].allocated != 0) && (curproc->pages[i].virtual_addr ==  virtual_addr)) {// finding the page we want to remove
80104d0f:	8b 48 10             	mov    0x10(%eax),%ecx
80104d12:	85 c9                	test   %ecx,%ecx
80104d14:	74 ea                	je     80104d00 <deallocate_page+0x30>
80104d16:	39 38                	cmp    %edi,(%eax)
80104d18:	75 e6                	jne    80104d00 <deallocate_page+0x30>
      curproc->pages[i].virtual_addr = 0;
80104d1a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
80104d1d:	8d 04 c6             	lea    (%esi,%eax,8),%eax
      #endif

      curproc->pages[i].allocated = 0;

      /** If the page we want to remove is in the swap file, we want to remember it's offset, for future use **/
      if(curproc->pages[i].in_RAM == 0)
80104d20:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
      curproc->pages[i].virtual_addr = 0;
80104d26:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104d2d:	00 00 00 
        curproc->pages[i].age = 0x00000000;
80104d30:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104d37:	00 00 00 
      curproc->pages[i].allocated = 0;
80104d3a:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104d41:	00 00 00 
      if(curproc->pages[i].in_RAM == 0)
80104d44:	85 d2                	test   %edx,%edx
80104d46:	74 68                	je     80104db0 <deallocate_page+0xe0>
        insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);

      curproc->pages[i].in_RAM = 0;
80104d48:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
80104d4b:	8d 04 c6             	lea    (%esi,%eax,8),%eax
80104d4e:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104d55:	00 00 00 
      curproc->pages[i].offset_in_swapfile = -1;
80104d58:	c7 80 84 00 00 00 ff 	movl   $0xffffffff,0x84(%eax)
80104d5f:	ff ff ff 
    }
  }
  if (i == MAX_TOTAL_PAGES)
    panic("page does not exist in our pages field!");

  for (j = 0; j < MAX_PYSC_PAGES; j++) {  // find the page in the inRAM queue we added
80104d62:	31 c0                	xor    %eax,%eax
80104d64:	eb 12                	jmp    80104d78 <deallocate_page+0xa8>
80104d66:	8d 76 00             	lea    0x0(%esi),%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d70:	83 c0 01             	add    $0x1,%eax
80104d73:	83 f8 10             	cmp    $0x10,%eax
80104d76:	74 28                	je     80104da0 <deallocate_page+0xd0>
    if (curproc->inRAM[j] == i) {
80104d78:	39 9c 86 80 03 00 00 	cmp    %ebx,0x380(%esi,%eax,4)
80104d7f:	75 ef                	jne    80104d70 <deallocate_page+0xa0>
      move_forward_in_inRAM_queue(j); 
80104d81:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    }
  }
}
80104d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d87:	5b                   	pop    %ebx
80104d88:	5e                   	pop    %esi
80104d89:	5f                   	pop    %edi
80104d8a:	5d                   	pop    %ebp
      move_forward_in_inRAM_queue(j); 
80104d8b:	e9 80 fe ff ff       	jmp    80104c10 <move_forward_in_inRAM_queue>
    panic("page does not exist in our pages field!");
80104d90:	83 ec 0c             	sub    $0xc,%esp
80104d93:	68 d8 8e 10 80       	push   $0x80108ed8
80104d98:	e8 f3 b5 ff ff       	call   80100390 <panic>
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
}
80104da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104da3:	5b                   	pop    %ebx
80104da4:	5e                   	pop    %esi
80104da5:	5f                   	pop    %edi
80104da6:	5d                   	pop    %ebp
80104da7:	c3                   	ret    
80104da8:	90                   	nop
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);
80104db0:	83 ec 0c             	sub    $0xc,%esp
80104db3:	ff b0 84 00 00 00    	pushl  0x84(%eax)
80104db9:	e8 b2 fd ff ff       	call   80104b70 <insert_to_offsets_queue>
80104dbe:	83 c4 10             	add    $0x10,%esp
80104dc1:	eb 85                	jmp    80104d48 <deallocate_page+0x78>
80104dc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <select_for_NFUA>:

///////////////////ASSIGNMENT 3- SELECT THE PAGE DEPENDING ON THE POLICY//////////////////////
/** they all return an index to a cell in the 'pages' field of a proccess**/

int select_for_NFUA(){  //with aging mechanism
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
80104dd6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104dd9:	e8 02 05 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104dde:	e8 dd f1 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104de3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104de9:	e8 32 05 00 00       	call   80105320 <popcli>
  struct proc* curproc = myproc();
  int i;
  int oldest = 0;
80104dee:	31 c0                	xor    %eax,%eax
  for(i = 1; i < MAX_PYSC_PAGES; i++){
80104df0:	ba 01 00 00 00       	mov    $0x1,%edx
80104df5:	8b 9e 80 03 00 00    	mov    0x380(%esi),%ebx
80104dfb:	90                   	nop
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->pages[curproc->inRAM[i]].age < curproc->pages[curproc->inRAM[oldest]].age)  //  compare each page to the one next to him in order to save the oldest one
80104e00:	8b 8c 96 80 03 00 00 	mov    0x380(%esi,%edx,4),%ecx
80104e07:	8d 3c 49             	lea    (%ecx,%ecx,2),%edi
80104e0a:	8d 0c 5b             	lea    (%ebx,%ebx,2),%ecx
80104e0d:	8d 0c ce             	lea    (%esi,%ecx,8),%ecx
80104e10:	8b bc fe 88 00 00 00 	mov    0x88(%esi,%edi,8),%edi
80104e17:	3b b9 88 00 00 00    	cmp    0x88(%ecx),%edi
80104e1d:	0f 42 9c 96 80 03 00 	cmovb  0x380(%esi,%edx,4),%ebx
80104e24:	00 
80104e25:	0f 42 c2             	cmovb  %edx,%eax
  for(i = 1; i < MAX_PYSC_PAGES; i++){
80104e28:	83 c2 01             	add    $0x1,%edx
80104e2b:	83 fa 10             	cmp    $0x10,%edx
80104e2e:	75 d0                	jne    80104e00 <select_for_NFUA+0x30>
      oldest = i;
  }
  int page_to_swap_index = curproc->inRAM[oldest];  // the index of the actual page
  move_forward_in_inRAM_queue(oldest);  //  oldest is the cell number in inRAM array (we need it for the 'move forward' function in order to know from where to start moving the line)
80104e30:	83 ec 0c             	sub    $0xc,%esp
80104e33:	50                   	push   %eax
80104e34:	e8 d7 fd ff ff       	call   80104c10 <move_forward_in_inRAM_queue>
  return page_to_swap_index;
}
80104e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e3c:	89 d8                	mov    %ebx,%eax
80104e3e:	5b                   	pop    %ebx
80104e3f:	5e                   	pop    %esi
80104e40:	5f                   	pop    %edi
80104e41:	5d                   	pop    %ebp
80104e42:	c3                   	ret    
80104e43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <select_for_LAPA>:

int select_for_LAPA(){
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	56                   	push   %esi
80104e55:	53                   	push   %ebx
  struct proc* curproc = myproc();
  int oldest = 0xFFFFFFFF;
  int i;
  int index = -1;
  int least_ones = 33; // more than the count of the bits (uint- 32 bit), just to catch the first one and then compare between all the others
  for(i = 0; i<MAX_PYSC_PAGES; i++){
80104e56:	31 db                	xor    %ebx,%ebx
int select_for_LAPA(){
80104e58:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104e5b:	e8 80 04 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104e60:	e8 5b f1 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104e65:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104e6b:	e8 b0 04 00 00       	call   80105320 <popcli>
  int least_ones = 33; // more than the count of the bits (uint- 32 bit), just to catch the first one and then compare between all the others
80104e70:	c7 45 e4 21 00 00 00 	movl   $0x21,-0x1c(%ebp)
  int index = -1;
80104e77:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  int oldest = 0xFFFFFFFF;
80104e7e:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
80104e85:	8d 76 00             	lea    0x0(%esi),%esi
    int count = 0;
    int age = curproc->pages[curproc->inRAM[i]].age;
80104e88:	8b 84 9e 80 03 00 00 	mov    0x380(%esi,%ebx,4),%eax
    /**now, we count the number of the '1' in the age:**/
    int j;
    for(j = 0; j<32; j++){
80104e8f:	31 c9                	xor    %ecx,%ecx
    int age = curproc->pages[curproc->inRAM[i]].age;
80104e91:	8d 04 40             	lea    (%eax,%eax,2),%eax
80104e94:	8b 94 c6 88 00 00 00 	mov    0x88(%esi,%eax,8),%edx
    int count = 0;
80104e9b:	31 c0                	xor    %eax,%eax
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
      if((1<<j) & (age))  // if there is '1' (xor-and)
80104ea0:	89 d7                	mov    %edx,%edi
80104ea2:	d3 ff                	sar    %cl,%edi
80104ea4:	83 e7 01             	and    $0x1,%edi
        count++;
80104ea7:	83 ff 01             	cmp    $0x1,%edi
80104eaa:	83 d8 ff             	sbb    $0xffffffff,%eax
    for(j = 0; j<32; j++){
80104ead:	83 c1 01             	add    $0x1,%ecx
80104eb0:	83 f9 20             	cmp    $0x20,%ecx
80104eb3:	75 eb                	jne    80104ea0 <select_for_LAPA+0x50>
    }
    if(count < least_ones){
80104eb5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80104eb8:	7c 46                	jl     80104f00 <select_for_LAPA+0xb0>
      least_ones = count;
      index = i;
      oldest = age;
    }
    else if(count == least_ones && age < oldest){  // maybe they have the same amount of '1's but this page is older..
80104eba:	75 14                	jne    80104ed0 <select_for_LAPA+0x80>
80104ebc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ebf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80104ec2:	39 c2                	cmp    %eax,%edx
80104ec4:	0f 4c cb             	cmovl  %ebx,%ecx
80104ec7:	0f 4d d0             	cmovge %eax,%edx
80104eca:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80104ecd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  for(i = 0; i<MAX_PYSC_PAGES; i++){
80104ed0:	83 c3 01             	add    $0x1,%ebx
80104ed3:	83 fb 10             	cmp    $0x10,%ebx
80104ed6:	75 b0                	jne    80104e88 <select_for_LAPA+0x38>
      index = i;
      oldest = age;
    }
  }
  if(index == -1)  // weird case, but just to make sure
80104ed8:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
80104edc:	74 2d                	je     80104f0b <select_for_LAPA+0xbb>
    panic("in LAPA: couldn't find any page!!");

  /**now, lets collect everything we got**/
  int page_to_swap_index = curproc->inRAM[index];
80104ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  move_forward_in_inRAM_queue(index);
80104ee1:	83 ec 0c             	sub    $0xc,%esp
  int page_to_swap_index = curproc->inRAM[index];
80104ee4:	8b 9c 86 80 03 00 00 	mov    0x380(%esi,%eax,4),%ebx
  move_forward_in_inRAM_queue(index);
80104eeb:	50                   	push   %eax
80104eec:	e8 1f fd ff ff       	call   80104c10 <move_forward_in_inRAM_queue>
  return page_to_swap_index;
}
80104ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef4:	89 d8                	mov    %ebx,%eax
80104ef6:	5b                   	pop    %ebx
80104ef7:	5e                   	pop    %esi
80104ef8:	5f                   	pop    %edi
80104ef9:	5d                   	pop    %ebp
80104efa:	c3                   	ret    
80104efb:	90                   	nop
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104f03:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    int age = curproc->pages[curproc->inRAM[i]].age;
80104f06:	89 55 dc             	mov    %edx,-0x24(%ebp)
80104f09:	eb c5                	jmp    80104ed0 <select_for_LAPA+0x80>
    panic("in LAPA: couldn't find any page!!");
80104f0b:	83 ec 0c             	sub    $0xc,%esp
80104f0e:	68 00 8f 10 80       	push   $0x80108f00
80104f13:	e8 78 b4 ff ff       	call   80100390 <panic>
80104f18:	90                   	nop
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f20 <select_for_SCFIFO>:

int select_for_SCFIFO(){
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
80104f26:	83 ec 5c             	sub    $0x5c,%esp
  pushcli();
80104f29:	e8 b2 03 00 00       	call   801052e0 <pushcli>
  c = mycpu();
80104f2e:	e8 8d f0 ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80104f33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104f39:	e8 e2 03 00 00       	call   80105320 <popcli>
80104f3e:	8d 45 a8             	lea    -0x58(%ebp),%eax
80104f41:	8d 55 e8             	lea    -0x18(%ebp),%edx
80104f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int inRAM_index = 0;

  /**initialization**/
  int i;
  for(i = 0; i<MAX_PYSC_PAGES; i++)
    accessed_inRAM[i] = -1;
80104f48:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
80104f4e:	83 c0 04             	add    $0x4,%eax
  for(i = 0; i<MAX_PYSC_PAGES; i++)
80104f51:	39 c2                	cmp    %eax,%edx
80104f53:	75 f3                	jne    80104f48 <select_for_SCFIFO+0x28>
  int inRAM_index = 0;
80104f55:	31 db                	xor    %ebx,%ebx
80104f57:	eb 23                	jmp    80104f7c <select_for_SCFIFO+0x5c>
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int page_to_swap_index = -1;
  for(i = 0; (i<MAX_PYSC_PAGES) && (page_to_swap_index == -1); i++){
    pte_t *pte = (pte_t*)global_walkpgdir(curproc->pgdir, (char*) curproc->pages[curproc->inRAM[i]].virtual_addr, 0);  // the virtual address of a page that is in the RAM
    /**first, we check if the page was accessed**/
    if(*pte & PTE_AC){
      *pte = TURN_OFF_PTE_AC(*pte);
80104f60:	83 e2 df             	and    $0xffffffdf,%edx
80104f63:	89 10                	mov    %edx,(%eax)
      accessed_inRAM[inRAM_index] = curproc->inRAM[i];  //  if it was accessed, add it to the array
80104f65:	8b 84 9e 80 03 00 00 	mov    0x380(%esi,%ebx,4),%eax
80104f6c:	89 44 9d a8          	mov    %eax,-0x58(%ebp,%ebx,4)
      inRAM_index++;
80104f70:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; (i<MAX_PYSC_PAGES) && (page_to_swap_index == -1); i++){
80104f73:	83 fb 10             	cmp    $0x10,%ebx
80104f76:	0f 84 a4 00 00 00    	je     80105020 <select_for_SCFIFO+0x100>
    pte_t *pte = (pte_t*)global_walkpgdir(curproc->pgdir, (char*) curproc->pages[curproc->inRAM[i]].virtual_addr, 0);  // the virtual address of a page that is in the RAM
80104f7c:	83 ec 04             	sub    $0x4,%esp
80104f7f:	6a 00                	push   $0x0
80104f81:	8b 84 9e 80 03 00 00 	mov    0x380(%esi,%ebx,4),%eax
80104f88:	8d 04 40             	lea    (%eax,%eax,2),%eax
80104f8b:	ff b4 c6 80 00 00 00 	pushl  0x80(%esi,%eax,8)
80104f92:	ff 76 04             	pushl  0x4(%esi)
80104f95:	e8 d6 37 00 00       	call   80108770 <global_walkpgdir>
    if(*pte & PTE_AC){
80104f9a:	8b 10                	mov    (%eax),%edx
80104f9c:	83 c4 10             	add    $0x10,%esp
80104f9f:	f6 c2 20             	test   $0x20,%dl
80104fa2:	75 bc                	jne    80104f60 <select_for_SCFIFO+0x40>
80104fa4:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
    }
    else{ // page was not accessed
      page_to_swap_index = curproc->inRAM[i];  // we save that particular page and there is no reason to keep looking for another one
80104fa7:	8b b8 80 03 00 00    	mov    0x380(%eax),%edi
      break;
    }  
  } 
  if(page_to_swap_index == -1){  // if each one of them was accessed, we go back to the beginning. not the interesting part :/
80104fad:	83 ff ff             	cmp    $0xffffffff,%edi
      page_to_swap_index = curproc->inRAM[i];  // we save that particular page and there is no reason to keep looking for another one
80104fb0:	89 7d a4             	mov    %edi,-0x5c(%ebp)
  if(page_to_swap_index == -1){  // if each one of them was accessed, we go back to the beginning. not the interesting part :/
80104fb3:	74 6b                	je     80105020 <select_for_SCFIFO+0x100>

  /** if we got here, it means we got a page from the ram that was not accessed**/
  /** here, we implement the 'clock' second chance fifo we learned in class- pretty much just reorginizing everything so that the 'arm' will now point at the next page**/
  i++;  //start from the next page in the queue
  int j = 0;
  while((i < MAX_PYSC_PAGES) && (curproc->inRAM[i] != -1)){
80104fb5:	83 fb 0f             	cmp    $0xf,%ebx
80104fb8:	0f 84 96 00 00 00    	je     80105054 <select_for_SCFIFO+0x134>
80104fbe:	8b b8 84 03 00 00    	mov    0x384(%eax),%edi
80104fc4:	83 ff ff             	cmp    $0xffffffff,%edi
80104fc7:	0f 84 87 00 00 00    	je     80105054 <select_for_SCFIFO+0x134>
80104fcd:	b8 0f 00 00 00       	mov    $0xf,%eax
80104fd2:	8d 96 80 03 00 00    	lea    0x380(%esi),%edx
  int j = 0;
80104fd8:	31 c9                	xor    %ecx,%ecx
80104fda:	29 d8                	sub    %ebx,%eax
80104fdc:	eb 0e                	jmp    80104fec <select_for_SCFIFO+0xcc>
80104fde:	66 90                	xchg   %ax,%ax
80104fe0:	83 c2 04             	add    $0x4,%edx
  while((i < MAX_PYSC_PAGES) && (curproc->inRAM[i] != -1)){
80104fe3:	8b 7c 9a 04          	mov    0x4(%edx,%ebx,4),%edi
80104fe7:	83 ff ff             	cmp    $0xffffffff,%edi
80104fea:	74 64                	je     80105050 <select_for_SCFIFO+0x130>
    curproc->inRAM[j] = curproc->inRAM[i];
    i++;
    j++;
80104fec:	83 c1 01             	add    $0x1,%ecx
    curproc->inRAM[j] = curproc->inRAM[i];
80104fef:	89 3a                	mov    %edi,(%edx)
  while((i < MAX_PYSC_PAGES) && (curproc->inRAM[i] != -1)){
80104ff1:	39 c8                	cmp    %ecx,%eax
80104ff3:	75 eb                	jne    80104fe0 <select_for_SCFIFO+0xc0>
80104ff5:	89 c2                	mov    %eax,%edx
80104ff7:	f7 da                	neg    %edx
80104ff9:	8d 4c 95 a8          	lea    -0x58(%ebp,%edx,4),%ecx
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
  }
  int k = 0;
  while(j < MAX_PYSC_PAGES){
    curproc->inRAM[j] = accessed_inRAM[k];
80105000:	8b 14 81             	mov    (%ecx,%eax,4),%edx
80105003:	89 94 86 80 03 00 00 	mov    %edx,0x380(%esi,%eax,4)
    j++;
8010500a:	83 c0 01             	add    $0x1,%eax
  while(j < MAX_PYSC_PAGES){
8010500d:	83 f8 10             	cmp    $0x10,%eax
80105010:	75 ee                	jne    80105000 <select_for_SCFIFO+0xe0>
    k++;
  }
  return page_to_swap_index;
}
80105012:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80105015:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105018:	5b                   	pop    %ebx
80105019:	5e                   	pop    %esi
8010501a:	5f                   	pop    %edi
8010501b:	5d                   	pop    %ebp
8010501c:	c3                   	ret    
8010501d:	8d 76 00             	lea    0x0(%esi),%esi
    page_to_swap_index = curproc->inRAM[0];
80105020:	8b 86 80 03 00 00    	mov    0x380(%esi),%eax
    if(page_to_swap_index != -1) //we have the first page, now we can move all the others further in the queue
80105026:	83 f8 ff             	cmp    $0xffffffff,%eax
    page_to_swap_index = curproc->inRAM[0];
80105029:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    if(page_to_swap_index != -1) //we have the first page, now we can move all the others further in the queue
8010502c:	74 2a                	je     80105058 <select_for_SCFIFO+0x138>
      move_forward_in_inRAM_queue(0);
8010502e:	83 ec 0c             	sub    $0xc,%esp
80105031:	6a 00                	push   $0x0
80105033:	e8 d8 fb ff ff       	call   80104c10 <move_forward_in_inRAM_queue>
}
80105038:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    return page_to_swap_index;
8010503b:	83 c4 10             	add    $0x10,%esp
}
8010503e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105041:	5b                   	pop    %ebx
80105042:	5e                   	pop    %esi
80105043:	5f                   	pop    %edi
80105044:	5d                   	pop    %ebp
80105045:	c3                   	ret    
80105046:	8d 76 00             	lea    0x0(%esi),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105050:	89 c8                	mov    %ecx,%eax
80105052:	eb a1                	jmp    80104ff5 <select_for_SCFIFO+0xd5>
  int j = 0;
80105054:	31 c0                	xor    %eax,%eax
80105056:	eb 9d                	jmp    80104ff5 <select_for_SCFIFO+0xd5>
      panic("in SCFIFO: no pages in ram queue!!");
80105058:	83 ec 0c             	sub    $0xc,%esp
8010505b:	68 24 8f 10 80       	push   $0x80108f24
80105060:	e8 2b b3 ff ff       	call   80100390 <panic>
80105065:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <select_for_AQ>:

int select_for_AQ(){  // the most simple one- just tale the first in line
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	53                   	push   %ebx
80105074:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80105077:	e8 64 02 00 00       	call   801052e0 <pushcli>
  c = mycpu();
8010507c:	e8 3f ef ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
80105081:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105087:	e8 94 02 00 00       	call   80105320 <popcli>
  struct proc* curproc = myproc();
  int page_to_swap_index = curproc->inRAM[0];
  move_forward_in_inRAM_queue(0);
8010508c:	83 ec 0c             	sub    $0xc,%esp
  int page_to_swap_index = curproc->inRAM[0];
8010508f:	8b 9b 80 03 00 00    	mov    0x380(%ebx),%ebx
  move_forward_in_inRAM_queue(0);
80105095:	6a 00                	push   $0x0
80105097:	e8 74 fb ff ff       	call   80104c10 <move_forward_in_inRAM_queue>
  return page_to_swap_index;
}
8010509c:	89 d8                	mov    %ebx,%eax
8010509e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050a1:	c9                   	leave  
801050a2:	c3                   	ret    
801050a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <aging>:


void aging(){
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
801050b5:	53                   	push   %ebx
801050b6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801050b9:	e8 22 02 00 00       	call   801052e0 <pushcli>
  c = mycpu();
801050be:	e8 fd ee ff ff       	call   80103fc0 <mycpu>
  p = c->proc;
801050c3:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801050c9:	e8 52 02 00 00       	call   80105320 <popcli>
801050ce:	8d 9f 80 00 00 00    	lea    0x80(%edi),%ebx
801050d4:	8d b7 80 03 00 00    	lea    0x380(%edi),%esi
801050da:	eb 0b                	jmp    801050e7 <aging+0x37>
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050e0:	83 c3 18             	add    $0x18,%ebx
  struct proc *curproc = myproc();
  int i;
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
801050e3:	39 f3                	cmp    %esi,%ebx
801050e5:	74 31                	je     80105118 <aging+0x68>
    if(curproc->pages[i].allocated == 1){
801050e7:	83 7b 10 01          	cmpl   $0x1,0x10(%ebx)
801050eb:	75 f3                	jne    801050e0 <aging+0x30>
      curproc->pages[i].age= curproc->pages[i].age >> 1; //right shift
801050ed:	d1 6b 08             	shrl   0x8(%ebx)
      pte_t* pte = (pte_t*) global_walkpgdir(curproc->pgdir, (void*)curproc->pages[i].virtual_addr, 0);
801050f0:	83 ec 04             	sub    $0x4,%esp
801050f3:	6a 00                	push   $0x0
801050f5:	ff 33                	pushl  (%ebx)
801050f7:	ff 77 04             	pushl  0x4(%edi)
801050fa:	e8 71 36 00 00       	call   80108770 <global_walkpgdir>
      if(*pte & PTE_AC){    //if page was accessed
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	f6 00 20             	testb  $0x20,(%eax)
80105105:	74 d9                	je     801050e0 <aging+0x30>
        uint new_age = curproc->pages[i].age | 0x80000000;//adds '1' to the left
80105107:	81 4b 08 00 00 00 80 	orl    $0x80000000,0x8(%ebx)
8010510e:	83 c3 18             	add    $0x18,%ebx
        curproc->pages[i].age = new_age;
        *pte = TURN_OFF_PTE_AC(*pte); //  turn off the accessed bit
80105111:	83 20 df             	andl   $0xffffffdf,(%eax)
  for(i = 0; i<MAX_TOTAL_PAGES; i++){
80105114:	39 f3                	cmp    %esi,%ebx
80105116:	75 cf                	jne    801050e7 <aging+0x37>
      }
    }
  }
}
80105118:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010511b:	5b                   	pop    %ebx
8010511c:	5e                   	pop    %esi
8010511d:	5f                   	pop    %edi
8010511e:	5d                   	pop    %ebp
8010511f:	c3                   	ret    

80105120 <advance_for_AQ>:

void advance_for_AQ(){
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	83 ec 08             	sub    $0x8,%esp
  pushcli();
80105126:	e8 b5 01 00 00       	call   801052e0 <pushcli>
  c = mycpu();
8010512b:	e8 90 ee ff ff       	call   80103fc0 <mycpu>
        curproc->inRAM[i] = prev;
        curproc->inRAM[i-1] = curr;
      }
    }
  }
}
80105130:	c9                   	leave  
  popcli();
80105131:	e9 ea 01 00 00       	jmp    80105320 <popcli>
80105136:	66 90                	xchg   %ax,%ax
80105138:	66 90                	xchg   %ax,%ax
8010513a:	66 90                	xchg   %ax,%ax
8010513c:	66 90                	xchg   %ax,%ax
8010513e:	66 90                	xchg   %ax,%ax

80105140 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	53                   	push   %ebx
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010514a:	68 60 8f 10 80       	push   $0x80108f60
8010514f:	8d 43 04             	lea    0x4(%ebx),%eax
80105152:	50                   	push   %eax
80105153:	e8 18 01 00 00       	call   80105270 <initlock>
  lk->name = name;
80105158:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010515b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105161:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105164:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010516b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010516e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105171:	c9                   	leave  
80105172:	c3                   	ret    
80105173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	56                   	push   %esi
80105184:	53                   	push   %ebx
80105185:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105188:	83 ec 0c             	sub    $0xc,%esp
8010518b:	8d 73 04             	lea    0x4(%ebx),%esi
8010518e:	56                   	push   %esi
8010518f:	e8 1c 02 00 00       	call   801053b0 <acquire>
  while (lk->locked) {
80105194:	8b 13                	mov    (%ebx),%edx
80105196:	83 c4 10             	add    $0x10,%esp
80105199:	85 d2                	test   %edx,%edx
8010519b:	74 16                	je     801051b3 <acquiresleep+0x33>
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801051a0:	83 ec 08             	sub    $0x8,%esp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
801051a5:	e8 b6 f5 ff ff       	call   80104760 <sleep>
  while (lk->locked) {
801051aa:	8b 03                	mov    (%ebx),%eax
801051ac:	83 c4 10             	add    $0x10,%esp
801051af:	85 c0                	test   %eax,%eax
801051b1:	75 ed                	jne    801051a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801051b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801051b9:	e8 a2 ee ff ff       	call   80104060 <myproc>
801051be:	8b 40 10             	mov    0x10(%eax),%eax
801051c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801051c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801051c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ca:	5b                   	pop    %ebx
801051cb:	5e                   	pop    %esi
801051cc:	5d                   	pop    %ebp
  release(&lk->lk);
801051cd:	e9 9e 02 00 00       	jmp    80105470 <release>
801051d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
801051e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801051e8:	83 ec 0c             	sub    $0xc,%esp
801051eb:	8d 73 04             	lea    0x4(%ebx),%esi
801051ee:	56                   	push   %esi
801051ef:	e8 bc 01 00 00       	call   801053b0 <acquire>
  lk->locked = 0;
801051f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801051fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105201:	89 1c 24             	mov    %ebx,(%esp)
80105204:	e8 17 f7 ff ff       	call   80104920 <wakeup>
  release(&lk->lk);
80105209:	89 75 08             	mov    %esi,0x8(%ebp)
8010520c:	83 c4 10             	add    $0x10,%esp
}
8010520f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105212:	5b                   	pop    %ebx
80105213:	5e                   	pop    %esi
80105214:	5d                   	pop    %ebp
  release(&lk->lk);
80105215:	e9 56 02 00 00       	jmp    80105470 <release>
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105220 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	57                   	push   %edi
80105224:	56                   	push   %esi
80105225:	53                   	push   %ebx
80105226:	31 ff                	xor    %edi,%edi
80105228:	83 ec 18             	sub    $0x18,%esp
8010522b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010522e:	8d 73 04             	lea    0x4(%ebx),%esi
80105231:	56                   	push   %esi
80105232:	e8 79 01 00 00       	call   801053b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105237:	8b 03                	mov    (%ebx),%eax
80105239:	83 c4 10             	add    $0x10,%esp
8010523c:	85 c0                	test   %eax,%eax
8010523e:	74 13                	je     80105253 <holdingsleep+0x33>
80105240:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105243:	e8 18 ee ff ff       	call   80104060 <myproc>
80105248:	39 58 10             	cmp    %ebx,0x10(%eax)
8010524b:	0f 94 c0             	sete   %al
8010524e:	0f b6 c0             	movzbl %al,%eax
80105251:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80105253:	83 ec 0c             	sub    $0xc,%esp
80105256:	56                   	push   %esi
80105257:	e8 14 02 00 00       	call   80105470 <release>
  return r;
}
8010525c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010525f:	89 f8                	mov    %edi,%eax
80105261:	5b                   	pop    %ebx
80105262:	5e                   	pop    %esi
80105263:	5f                   	pop    %edi
80105264:	5d                   	pop    %ebp
80105265:	c3                   	ret    
80105266:	66 90                	xchg   %ax,%ax
80105268:	66 90                	xchg   %ax,%ax
8010526a:	66 90                	xchg   %ax,%ax
8010526c:	66 90                	xchg   %ax,%ax
8010526e:	66 90                	xchg   %ax,%ax

80105270 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105276:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010527f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105282:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105289:	5d                   	pop    %ebp
8010528a:	c3                   	ret    
8010528b:	90                   	nop
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105290:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105291:	31 d2                	xor    %edx,%edx
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105296:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105299:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010529c:	83 e8 08             	sub    $0x8,%eax
8010529f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801052a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801052ac:	77 1a                	ja     801052c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801052ae:	8b 58 04             	mov    0x4(%eax),%ebx
801052b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801052b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801052b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801052b9:	83 fa 0a             	cmp    $0xa,%edx
801052bc:	75 e2                	jne    801052a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801052be:	5b                   	pop    %ebx
801052bf:	5d                   	pop    %ebp
801052c0:	c3                   	ret    
801052c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801052cb:	83 c1 28             	add    $0x28,%ecx
801052ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801052d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801052d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801052d9:	39 c1                	cmp    %eax,%ecx
801052db:	75 f3                	jne    801052d0 <getcallerpcs+0x40>
}
801052dd:	5b                   	pop    %ebx
801052de:	5d                   	pop    %ebp
801052df:	c3                   	ret    

801052e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	53                   	push   %ebx
801052e4:	83 ec 04             	sub    $0x4,%esp
801052e7:	9c                   	pushf  
801052e8:	5b                   	pop    %ebx
  asm volatile("cli");
801052e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801052ea:	e8 d1 ec ff ff       	call   80103fc0 <mycpu>
801052ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801052f5:	85 c0                	test   %eax,%eax
801052f7:	75 11                	jne    8010530a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801052f9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801052ff:	e8 bc ec ff ff       	call   80103fc0 <mycpu>
80105304:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010530a:	e8 b1 ec ff ff       	call   80103fc0 <mycpu>
8010530f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105316:	83 c4 04             	add    $0x4,%esp
80105319:	5b                   	pop    %ebx
8010531a:	5d                   	pop    %ebp
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <popcli>:

void
popcli(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105326:	9c                   	pushf  
80105327:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105328:	f6 c4 02             	test   $0x2,%ah
8010532b:	75 35                	jne    80105362 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010532d:	e8 8e ec ff ff       	call   80103fc0 <mycpu>
80105332:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105339:	78 34                	js     8010536f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010533b:	e8 80 ec ff ff       	call   80103fc0 <mycpu>
80105340:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105346:	85 d2                	test   %edx,%edx
80105348:	74 06                	je     80105350 <popcli+0x30>
    sti();
}
8010534a:	c9                   	leave  
8010534b:	c3                   	ret    
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105350:	e8 6b ec ff ff       	call   80103fc0 <mycpu>
80105355:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010535b:	85 c0                	test   %eax,%eax
8010535d:	74 eb                	je     8010534a <popcli+0x2a>
  asm volatile("sti");
8010535f:	fb                   	sti    
}
80105360:	c9                   	leave  
80105361:	c3                   	ret    
    panic("popcli - interruptible");
80105362:	83 ec 0c             	sub    $0xc,%esp
80105365:	68 6b 8f 10 80       	push   $0x80108f6b
8010536a:	e8 21 b0 ff ff       	call   80100390 <panic>
    panic("popcli");
8010536f:	83 ec 0c             	sub    $0xc,%esp
80105372:	68 82 8f 10 80       	push   $0x80108f82
80105377:	e8 14 b0 ff ff       	call   80100390 <panic>
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <holding>:
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	53                   	push   %ebx
80105385:	8b 75 08             	mov    0x8(%ebp),%esi
80105388:	31 db                	xor    %ebx,%ebx
  pushcli();
8010538a:	e8 51 ff ff ff       	call   801052e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010538f:	8b 06                	mov    (%esi),%eax
80105391:	85 c0                	test   %eax,%eax
80105393:	74 10                	je     801053a5 <holding+0x25>
80105395:	8b 5e 08             	mov    0x8(%esi),%ebx
80105398:	e8 23 ec ff ff       	call   80103fc0 <mycpu>
8010539d:	39 c3                	cmp    %eax,%ebx
8010539f:	0f 94 c3             	sete   %bl
801053a2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801053a5:	e8 76 ff ff ff       	call   80105320 <popcli>
}
801053aa:	89 d8                	mov    %ebx,%eax
801053ac:	5b                   	pop    %ebx
801053ad:	5e                   	pop    %esi
801053ae:	5d                   	pop    %ebp
801053af:	c3                   	ret    

801053b0 <acquire>:
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	56                   	push   %esi
801053b4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801053b5:	e8 26 ff ff ff       	call   801052e0 <pushcli>
  if(holding(lk))
801053ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	53                   	push   %ebx
801053c1:	e8 ba ff ff ff       	call   80105380 <holding>
801053c6:	83 c4 10             	add    $0x10,%esp
801053c9:	85 c0                	test   %eax,%eax
801053cb:	0f 85 83 00 00 00    	jne    80105454 <acquire+0xa4>
801053d1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801053d3:	ba 01 00 00 00       	mov    $0x1,%edx
801053d8:	eb 09                	jmp    801053e3 <acquire+0x33>
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053e3:	89 d0                	mov    %edx,%eax
801053e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801053e8:	85 c0                	test   %eax,%eax
801053ea:	75 f4                	jne    801053e0 <acquire+0x30>
  __sync_synchronize();
801053ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801053f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801053f4:	e8 c7 eb ff ff       	call   80103fc0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801053f9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801053fc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801053ff:	89 e8                	mov    %ebp,%eax
80105401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105408:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010540e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105414:	77 1a                	ja     80105430 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105416:	8b 48 04             	mov    0x4(%eax),%ecx
80105419:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010541c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010541f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105421:	83 fe 0a             	cmp    $0xa,%esi
80105424:	75 e2                	jne    80105408 <acquire+0x58>
}
80105426:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105429:	5b                   	pop    %ebx
8010542a:	5e                   	pop    %esi
8010542b:	5d                   	pop    %ebp
8010542c:	c3                   	ret    
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
80105430:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105433:	83 c2 28             	add    $0x28,%edx
80105436:	8d 76 00             	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105446:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105449:	39 d0                	cmp    %edx,%eax
8010544b:	75 f3                	jne    80105440 <acquire+0x90>
}
8010544d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105450:	5b                   	pop    %ebx
80105451:	5e                   	pop    %esi
80105452:	5d                   	pop    %ebp
80105453:	c3                   	ret    
    panic("acquire");
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	68 89 8f 10 80       	push   $0x80108f89
8010545c:	e8 2f af ff ff       	call   80100390 <panic>
80105461:	eb 0d                	jmp    80105470 <release>
80105463:	90                   	nop
80105464:	90                   	nop
80105465:	90                   	nop
80105466:	90                   	nop
80105467:	90                   	nop
80105468:	90                   	nop
80105469:	90                   	nop
8010546a:	90                   	nop
8010546b:	90                   	nop
8010546c:	90                   	nop
8010546d:	90                   	nop
8010546e:	90                   	nop
8010546f:	90                   	nop

80105470 <release>:
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	53                   	push   %ebx
80105474:	83 ec 10             	sub    $0x10,%esp
80105477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010547a:	53                   	push   %ebx
8010547b:	e8 00 ff ff ff       	call   80105380 <holding>
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	85 c0                	test   %eax,%eax
80105485:	74 22                	je     801054a9 <release+0x39>
  lk->pcs[0] = 0;
80105487:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010548e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105495:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010549a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801054a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054a3:	c9                   	leave  
  popcli();
801054a4:	e9 77 fe ff ff       	jmp    80105320 <popcli>
    panic("release");
801054a9:	83 ec 0c             	sub    $0xc,%esp
801054ac:	68 91 8f 10 80       	push   $0x80108f91
801054b1:	e8 da ae ff ff       	call   80100390 <panic>
801054b6:	66 90                	xchg   %ax,%ax
801054b8:	66 90                	xchg   %ax,%ax
801054ba:	66 90                	xchg   %ax,%ax
801054bc:	66 90                	xchg   %ax,%ax
801054be:	66 90                	xchg   %ax,%ax

801054c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	53                   	push   %ebx
801054c5:	8b 55 08             	mov    0x8(%ebp),%edx
801054c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801054cb:	f6 c2 03             	test   $0x3,%dl
801054ce:	75 05                	jne    801054d5 <memset+0x15>
801054d0:	f6 c1 03             	test   $0x3,%cl
801054d3:	74 13                	je     801054e8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801054d5:	89 d7                	mov    %edx,%edi
801054d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054da:	fc                   	cld    
801054db:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801054dd:	5b                   	pop    %ebx
801054de:	89 d0                	mov    %edx,%eax
801054e0:	5f                   	pop    %edi
801054e1:	5d                   	pop    %ebp
801054e2:	c3                   	ret    
801054e3:	90                   	nop
801054e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801054e8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801054ec:	c1 e9 02             	shr    $0x2,%ecx
801054ef:	89 f8                	mov    %edi,%eax
801054f1:	89 fb                	mov    %edi,%ebx
801054f3:	c1 e0 18             	shl    $0x18,%eax
801054f6:	c1 e3 10             	shl    $0x10,%ebx
801054f9:	09 d8                	or     %ebx,%eax
801054fb:	09 f8                	or     %edi,%eax
801054fd:	c1 e7 08             	shl    $0x8,%edi
80105500:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105502:	89 d7                	mov    %edx,%edi
80105504:	fc                   	cld    
80105505:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105507:	5b                   	pop    %ebx
80105508:	89 d0                	mov    %edx,%eax
8010550a:	5f                   	pop    %edi
8010550b:	5d                   	pop    %ebp
8010550c:	c3                   	ret    
8010550d:	8d 76 00             	lea    0x0(%esi),%esi

80105510 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
80105516:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105519:	8b 75 08             	mov    0x8(%ebp),%esi
8010551c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010551f:	85 db                	test   %ebx,%ebx
80105521:	74 29                	je     8010554c <memcmp+0x3c>
    if(*s1 != *s2)
80105523:	0f b6 16             	movzbl (%esi),%edx
80105526:	0f b6 0f             	movzbl (%edi),%ecx
80105529:	38 d1                	cmp    %dl,%cl
8010552b:	75 2b                	jne    80105558 <memcmp+0x48>
8010552d:	b8 01 00 00 00       	mov    $0x1,%eax
80105532:	eb 14                	jmp    80105548 <memcmp+0x38>
80105534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105538:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010553c:	83 c0 01             	add    $0x1,%eax
8010553f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105544:	38 ca                	cmp    %cl,%dl
80105546:	75 10                	jne    80105558 <memcmp+0x48>
  while(n-- > 0){
80105548:	39 d8                	cmp    %ebx,%eax
8010554a:	75 ec                	jne    80105538 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010554c:	5b                   	pop    %ebx
  return 0;
8010554d:	31 c0                	xor    %eax,%eax
}
8010554f:	5e                   	pop    %esi
80105550:	5f                   	pop    %edi
80105551:	5d                   	pop    %ebp
80105552:	c3                   	ret    
80105553:	90                   	nop
80105554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105558:	0f b6 c2             	movzbl %dl,%eax
}
8010555b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010555c:	29 c8                	sub    %ecx,%eax
}
8010555e:	5e                   	pop    %esi
8010555f:	5f                   	pop    %edi
80105560:	5d                   	pop    %ebp
80105561:	c3                   	ret    
80105562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	56                   	push   %esi
80105574:	53                   	push   %ebx
80105575:	8b 45 08             	mov    0x8(%ebp),%eax
80105578:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010557b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010557e:	39 c3                	cmp    %eax,%ebx
80105580:	73 26                	jae    801055a8 <memmove+0x38>
80105582:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105585:	39 c8                	cmp    %ecx,%eax
80105587:	73 1f                	jae    801055a8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105589:	85 f6                	test   %esi,%esi
8010558b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010558e:	74 0f                	je     8010559f <memmove+0x2f>
      *--d = *--s;
80105590:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105594:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105597:	83 ea 01             	sub    $0x1,%edx
8010559a:	83 fa ff             	cmp    $0xffffffff,%edx
8010559d:	75 f1                	jne    80105590 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010559f:	5b                   	pop    %ebx
801055a0:	5e                   	pop    %esi
801055a1:	5d                   	pop    %ebp
801055a2:	c3                   	ret    
801055a3:	90                   	nop
801055a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801055a8:	31 d2                	xor    %edx,%edx
801055aa:	85 f6                	test   %esi,%esi
801055ac:	74 f1                	je     8010559f <memmove+0x2f>
801055ae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801055b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801055b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801055b7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801055ba:	39 d6                	cmp    %edx,%esi
801055bc:	75 f2                	jne    801055b0 <memmove+0x40>
}
801055be:	5b                   	pop    %ebx
801055bf:	5e                   	pop    %esi
801055c0:	5d                   	pop    %ebp
801055c1:	c3                   	ret    
801055c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801055d3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801055d4:	eb 9a                	jmp    80105570 <memmove>
801055d6:	8d 76 00             	lea    0x0(%esi),%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
801055e5:	8b 7d 10             	mov    0x10(%ebp),%edi
801055e8:	53                   	push   %ebx
801055e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801055ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801055ef:	85 ff                	test   %edi,%edi
801055f1:	74 2f                	je     80105622 <strncmp+0x42>
801055f3:	0f b6 01             	movzbl (%ecx),%eax
801055f6:	0f b6 1e             	movzbl (%esi),%ebx
801055f9:	84 c0                	test   %al,%al
801055fb:	74 37                	je     80105634 <strncmp+0x54>
801055fd:	38 c3                	cmp    %al,%bl
801055ff:	75 33                	jne    80105634 <strncmp+0x54>
80105601:	01 f7                	add    %esi,%edi
80105603:	eb 13                	jmp    80105618 <strncmp+0x38>
80105605:	8d 76 00             	lea    0x0(%esi),%esi
80105608:	0f b6 01             	movzbl (%ecx),%eax
8010560b:	84 c0                	test   %al,%al
8010560d:	74 21                	je     80105630 <strncmp+0x50>
8010560f:	0f b6 1a             	movzbl (%edx),%ebx
80105612:	89 d6                	mov    %edx,%esi
80105614:	38 d8                	cmp    %bl,%al
80105616:	75 1c                	jne    80105634 <strncmp+0x54>
    n--, p++, q++;
80105618:	8d 56 01             	lea    0x1(%esi),%edx
8010561b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010561e:	39 fa                	cmp    %edi,%edx
80105620:	75 e6                	jne    80105608 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105622:	5b                   	pop    %ebx
    return 0;
80105623:	31 c0                	xor    %eax,%eax
}
80105625:	5e                   	pop    %esi
80105626:	5f                   	pop    %edi
80105627:	5d                   	pop    %ebp
80105628:	c3                   	ret    
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105630:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105634:	29 d8                	sub    %ebx,%eax
}
80105636:	5b                   	pop    %ebx
80105637:	5e                   	pop    %esi
80105638:	5f                   	pop    %edi
80105639:	5d                   	pop    %ebp
8010563a:	c3                   	ret    
8010563b:	90                   	nop
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	56                   	push   %esi
80105644:	53                   	push   %ebx
80105645:	8b 45 08             	mov    0x8(%ebp),%eax
80105648:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010564b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010564e:	89 c2                	mov    %eax,%edx
80105650:	eb 19                	jmp    8010566b <strncpy+0x2b>
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105658:	83 c3 01             	add    $0x1,%ebx
8010565b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010565f:	83 c2 01             	add    $0x1,%edx
80105662:	84 c9                	test   %cl,%cl
80105664:	88 4a ff             	mov    %cl,-0x1(%edx)
80105667:	74 09                	je     80105672 <strncpy+0x32>
80105669:	89 f1                	mov    %esi,%ecx
8010566b:	85 c9                	test   %ecx,%ecx
8010566d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105670:	7f e6                	jg     80105658 <strncpy+0x18>
    ;
  while(n-- > 0)
80105672:	31 c9                	xor    %ecx,%ecx
80105674:	85 f6                	test   %esi,%esi
80105676:	7e 17                	jle    8010568f <strncpy+0x4f>
80105678:	90                   	nop
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105680:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105684:	89 f3                	mov    %esi,%ebx
80105686:	83 c1 01             	add    $0x1,%ecx
80105689:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010568b:	85 db                	test   %ebx,%ebx
8010568d:	7f f1                	jg     80105680 <strncpy+0x40>
  return os;
}
8010568f:	5b                   	pop    %ebx
80105690:	5e                   	pop    %esi
80105691:	5d                   	pop    %ebp
80105692:	c3                   	ret    
80105693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	56                   	push   %esi
801056a4:	53                   	push   %ebx
801056a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801056a8:	8b 45 08             	mov    0x8(%ebp),%eax
801056ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801056ae:	85 c9                	test   %ecx,%ecx
801056b0:	7e 26                	jle    801056d8 <safestrcpy+0x38>
801056b2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801056b6:	89 c1                	mov    %eax,%ecx
801056b8:	eb 17                	jmp    801056d1 <safestrcpy+0x31>
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801056c0:	83 c2 01             	add    $0x1,%edx
801056c3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801056c7:	83 c1 01             	add    $0x1,%ecx
801056ca:	84 db                	test   %bl,%bl
801056cc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801056cf:	74 04                	je     801056d5 <safestrcpy+0x35>
801056d1:	39 f2                	cmp    %esi,%edx
801056d3:	75 eb                	jne    801056c0 <safestrcpy+0x20>
    ;
  *s = 0;
801056d5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801056d8:	5b                   	pop    %ebx
801056d9:	5e                   	pop    %esi
801056da:	5d                   	pop    %ebp
801056db:	c3                   	ret    
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <strlen>:

int
strlen(const char *s)
{
801056e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801056e1:	31 c0                	xor    %eax,%eax
{
801056e3:	89 e5                	mov    %esp,%ebp
801056e5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801056e8:	80 3a 00             	cmpb   $0x0,(%edx)
801056eb:	74 0c                	je     801056f9 <strlen+0x19>
801056ed:	8d 76 00             	lea    0x0(%esi),%esi
801056f0:	83 c0 01             	add    $0x1,%eax
801056f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801056f7:	75 f7                	jne    801056f0 <strlen+0x10>
    ;
  return n;
}
801056f9:	5d                   	pop    %ebp
801056fa:	c3                   	ret    

801056fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801056fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801056ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105703:	55                   	push   %ebp
  pushl %ebx
80105704:	53                   	push   %ebx
  pushl %esi
80105705:	56                   	push   %esi
  pushl %edi
80105706:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105707:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105709:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010570b:	5f                   	pop    %edi
  popl %esi
8010570c:	5e                   	pop    %esi
  popl %ebx
8010570d:	5b                   	pop    %ebx
  popl %ebp
8010570e:	5d                   	pop    %ebp
  ret
8010570f:	c3                   	ret    

80105710 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	53                   	push   %ebx
80105714:	83 ec 04             	sub    $0x4,%esp
80105717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010571a:	e8 41 e9 ff ff       	call   80104060 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010571f:	8b 00                	mov    (%eax),%eax
80105721:	39 d8                	cmp    %ebx,%eax
80105723:	76 1b                	jbe    80105740 <fetchint+0x30>
80105725:	8d 53 04             	lea    0x4(%ebx),%edx
80105728:	39 d0                	cmp    %edx,%eax
8010572a:	72 14                	jb     80105740 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010572c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010572f:	8b 13                	mov    (%ebx),%edx
80105731:	89 10                	mov    %edx,(%eax)
  return 0;
80105733:	31 c0                	xor    %eax,%eax
}
80105735:	83 c4 04             	add    $0x4,%esp
80105738:	5b                   	pop    %ebx
80105739:	5d                   	pop    %ebp
8010573a:	c3                   	ret    
8010573b:	90                   	nop
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105745:	eb ee                	jmp    80105735 <fetchint+0x25>
80105747:	89 f6                	mov    %esi,%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105750 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	53                   	push   %ebx
80105754:	83 ec 04             	sub    $0x4,%esp
80105757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010575a:	e8 01 e9 ff ff       	call   80104060 <myproc>

  if(addr >= curproc->sz)
8010575f:	39 18                	cmp    %ebx,(%eax)
80105761:	76 29                	jbe    8010578c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105763:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105766:	89 da                	mov    %ebx,%edx
80105768:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010576a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010576c:	39 c3                	cmp    %eax,%ebx
8010576e:	73 1c                	jae    8010578c <fetchstr+0x3c>
    if(*s == 0)
80105770:	80 3b 00             	cmpb   $0x0,(%ebx)
80105773:	75 10                	jne    80105785 <fetchstr+0x35>
80105775:	eb 39                	jmp    801057b0 <fetchstr+0x60>
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105780:	80 3a 00             	cmpb   $0x0,(%edx)
80105783:	74 1b                	je     801057a0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105785:	83 c2 01             	add    $0x1,%edx
80105788:	39 d0                	cmp    %edx,%eax
8010578a:	77 f4                	ja     80105780 <fetchstr+0x30>
    return -1;
8010578c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105791:	83 c4 04             	add    $0x4,%esp
80105794:	5b                   	pop    %ebx
80105795:	5d                   	pop    %ebp
80105796:	c3                   	ret    
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801057a0:	83 c4 04             	add    $0x4,%esp
801057a3:	89 d0                	mov    %edx,%eax
801057a5:	29 d8                	sub    %ebx,%eax
801057a7:	5b                   	pop    %ebx
801057a8:	5d                   	pop    %ebp
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801057b0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801057b2:	eb dd                	jmp    80105791 <fetchstr+0x41>
801057b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801057c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	56                   	push   %esi
801057c4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801057c5:	e8 96 e8 ff ff       	call   80104060 <myproc>
801057ca:	8b 40 18             	mov    0x18(%eax),%eax
801057cd:	8b 55 08             	mov    0x8(%ebp),%edx
801057d0:	8b 40 44             	mov    0x44(%eax),%eax
801057d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801057d6:	e8 85 e8 ff ff       	call   80104060 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801057db:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801057dd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801057e0:	39 c6                	cmp    %eax,%esi
801057e2:	73 1c                	jae    80105800 <argint+0x40>
801057e4:	8d 53 08             	lea    0x8(%ebx),%edx
801057e7:	39 d0                	cmp    %edx,%eax
801057e9:	72 15                	jb     80105800 <argint+0x40>
  *ip = *(int*)(addr);
801057eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ee:	8b 53 04             	mov    0x4(%ebx),%edx
801057f1:	89 10                	mov    %edx,(%eax)
  return 0;
801057f3:	31 c0                	xor    %eax,%eax
}
801057f5:	5b                   	pop    %ebx
801057f6:	5e                   	pop    %esi
801057f7:	5d                   	pop    %ebp
801057f8:	c3                   	ret    
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105805:	eb ee                	jmp    801057f5 <argint+0x35>
80105807:	89 f6                	mov    %esi,%esi
80105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105810 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	56                   	push   %esi
80105814:	53                   	push   %ebx
80105815:	83 ec 10             	sub    $0x10,%esp
80105818:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010581b:	e8 40 e8 ff ff       	call   80104060 <myproc>
80105820:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105822:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105825:	83 ec 08             	sub    $0x8,%esp
80105828:	50                   	push   %eax
80105829:	ff 75 08             	pushl  0x8(%ebp)
8010582c:	e8 8f ff ff ff       	call   801057c0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105831:	83 c4 10             	add    $0x10,%esp
80105834:	85 c0                	test   %eax,%eax
80105836:	78 28                	js     80105860 <argptr+0x50>
80105838:	85 db                	test   %ebx,%ebx
8010583a:	78 24                	js     80105860 <argptr+0x50>
8010583c:	8b 16                	mov    (%esi),%edx
8010583e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105841:	39 c2                	cmp    %eax,%edx
80105843:	76 1b                	jbe    80105860 <argptr+0x50>
80105845:	01 c3                	add    %eax,%ebx
80105847:	39 da                	cmp    %ebx,%edx
80105849:	72 15                	jb     80105860 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010584b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010584e:	89 02                	mov    %eax,(%edx)
  return 0;
80105850:	31 c0                	xor    %eax,%eax
}
80105852:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105855:	5b                   	pop    %ebx
80105856:	5e                   	pop    %esi
80105857:	5d                   	pop    %ebp
80105858:	c3                   	ret    
80105859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105865:	eb eb                	jmp    80105852 <argptr+0x42>
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105870 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105876:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105879:	50                   	push   %eax
8010587a:	ff 75 08             	pushl  0x8(%ebp)
8010587d:	e8 3e ff ff ff       	call   801057c0 <argint>
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	85 c0                	test   %eax,%eax
80105887:	78 17                	js     801058a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105889:	83 ec 08             	sub    $0x8,%esp
8010588c:	ff 75 0c             	pushl  0xc(%ebp)
8010588f:	ff 75 f4             	pushl  -0xc(%ebp)
80105892:	e8 b9 fe ff ff       	call   80105750 <fetchstr>
80105897:	83 c4 10             	add    $0x10,%esp
}
8010589a:	c9                   	leave  
8010589b:	c3                   	ret    
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    
801058a7:	89 f6                	mov    %esi,%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058b0 <syscall>:
[SYS_getNumFreePages] sys_getNumFreePages,
};

void
syscall(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
801058b4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801058b7:	e8 a4 e7 ff ff       	call   80104060 <myproc>
801058bc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801058be:	8b 40 18             	mov    0x18(%eax),%eax
801058c1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801058c4:	8d 50 ff             	lea    -0x1(%eax),%edx
801058c7:	83 fa 15             	cmp    $0x15,%edx
801058ca:	77 1c                	ja     801058e8 <syscall+0x38>
801058cc:	8b 14 85 c0 8f 10 80 	mov    -0x7fef7040(,%eax,4),%edx
801058d3:	85 d2                	test   %edx,%edx
801058d5:	74 11                	je     801058e8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801058d7:	ff d2                	call   *%edx
801058d9:	8b 53 18             	mov    0x18(%ebx),%edx
801058dc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801058df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058e2:	c9                   	leave  
801058e3:	c3                   	ret    
801058e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801058e8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801058e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801058ec:	50                   	push   %eax
801058ed:	ff 73 10             	pushl  0x10(%ebx)
801058f0:	68 99 8f 10 80       	push   $0x80108f99
801058f5:	e8 66 ad ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801058fa:	8b 43 18             	mov    0x18(%ebx),%eax
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010590a:	c9                   	leave  
8010590b:	c3                   	ret    
8010590c:	66 90                	xchg   %ax,%ax
8010590e:	66 90                	xchg   %ax,%ax

80105910 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	56                   	push   %esi
80105914:	53                   	push   %ebx
80105915:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105917:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010591a:	89 d6                	mov    %edx,%esi
8010591c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010591f:	50                   	push   %eax
80105920:	6a 00                	push   $0x0
80105922:	e8 99 fe ff ff       	call   801057c0 <argint>
80105927:	83 c4 10             	add    $0x10,%esp
8010592a:	85 c0                	test   %eax,%eax
8010592c:	78 2a                	js     80105958 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010592e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105932:	77 24                	ja     80105958 <argfd.constprop.0+0x48>
80105934:	e8 27 e7 ff ff       	call   80104060 <myproc>
80105939:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010593c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105940:	85 c0                	test   %eax,%eax
80105942:	74 14                	je     80105958 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105944:	85 db                	test   %ebx,%ebx
80105946:	74 02                	je     8010594a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105948:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010594a:	89 06                	mov    %eax,(%esi)
  return 0;
8010594c:	31 c0                	xor    %eax,%eax
}
8010594e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105951:	5b                   	pop    %ebx
80105952:	5e                   	pop    %esi
80105953:	5d                   	pop    %ebp
80105954:	c3                   	ret    
80105955:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595d:	eb ef                	jmp    8010594e <argfd.constprop.0+0x3e>
8010595f:	90                   	nop

80105960 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105960:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105961:	31 c0                	xor    %eax,%eax
{
80105963:	89 e5                	mov    %esp,%ebp
80105965:	56                   	push   %esi
80105966:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105967:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010596a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010596d:	e8 9e ff ff ff       	call   80105910 <argfd.constprop.0>
80105972:	85 c0                	test   %eax,%eax
80105974:	78 42                	js     801059b8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105976:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105979:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010597b:	e8 e0 e6 ff ff       	call   80104060 <myproc>
80105980:	eb 0e                	jmp    80105990 <sys_dup+0x30>
80105982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105988:	83 c3 01             	add    $0x1,%ebx
8010598b:	83 fb 10             	cmp    $0x10,%ebx
8010598e:	74 28                	je     801059b8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105990:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105994:	85 d2                	test   %edx,%edx
80105996:	75 f0                	jne    80105988 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105998:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010599c:	83 ec 0c             	sub    $0xc,%esp
8010599f:	ff 75 f4             	pushl  -0xc(%ebp)
801059a2:	e8 29 b7 ff ff       	call   801010d0 <filedup>
  return fd;
801059a7:	83 c4 10             	add    $0x10,%esp
}
801059aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059ad:	89 d8                	mov    %ebx,%eax
801059af:	5b                   	pop    %ebx
801059b0:	5e                   	pop    %esi
801059b1:	5d                   	pop    %ebp
801059b2:	c3                   	ret    
801059b3:	90                   	nop
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801059bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801059c0:	89 d8                	mov    %ebx,%eax
801059c2:	5b                   	pop    %ebx
801059c3:	5e                   	pop    %esi
801059c4:	5d                   	pop    %ebp
801059c5:	c3                   	ret    
801059c6:	8d 76 00             	lea    0x0(%esi),%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_read>:

int
sys_read(void)
{
801059d0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059d1:	31 c0                	xor    %eax,%eax
{
801059d3:	89 e5                	mov    %esp,%ebp
801059d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801059d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801059db:	e8 30 ff ff ff       	call   80105910 <argfd.constprop.0>
801059e0:	85 c0                	test   %eax,%eax
801059e2:	78 4c                	js     80105a30 <sys_read+0x60>
801059e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059e7:	83 ec 08             	sub    $0x8,%esp
801059ea:	50                   	push   %eax
801059eb:	6a 02                	push   $0x2
801059ed:	e8 ce fd ff ff       	call   801057c0 <argint>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 37                	js     80105a30 <sys_read+0x60>
801059f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059fc:	83 ec 04             	sub    $0x4,%esp
801059ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105a02:	50                   	push   %eax
80105a03:	6a 01                	push   $0x1
80105a05:	e8 06 fe ff ff       	call   80105810 <argptr>
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	78 1f                	js     80105a30 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105a11:	83 ec 04             	sub    $0x4,%esp
80105a14:	ff 75 f0             	pushl  -0x10(%ebp)
80105a17:	ff 75 f4             	pushl  -0xc(%ebp)
80105a1a:	ff 75 ec             	pushl  -0x14(%ebp)
80105a1d:	e8 1e b8 ff ff       	call   80101240 <fileread>
80105a22:	83 c4 10             	add    $0x10,%esp
}
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_write>:

int
sys_write(void)
{
80105a40:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a41:	31 c0                	xor    %eax,%eax
{
80105a43:	89 e5                	mov    %esp,%ebp
80105a45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80105a4b:	e8 c0 fe ff ff       	call   80105910 <argfd.constprop.0>
80105a50:	85 c0                	test   %eax,%eax
80105a52:	78 4c                	js     80105aa0 <sys_write+0x60>
80105a54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a57:	83 ec 08             	sub    $0x8,%esp
80105a5a:	50                   	push   %eax
80105a5b:	6a 02                	push   $0x2
80105a5d:	e8 5e fd ff ff       	call   801057c0 <argint>
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	85 c0                	test   %eax,%eax
80105a67:	78 37                	js     80105aa0 <sys_write+0x60>
80105a69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a6c:	83 ec 04             	sub    $0x4,%esp
80105a6f:	ff 75 f0             	pushl  -0x10(%ebp)
80105a72:	50                   	push   %eax
80105a73:	6a 01                	push   $0x1
80105a75:	e8 96 fd ff ff       	call   80105810 <argptr>
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	85 c0                	test   %eax,%eax
80105a7f:	78 1f                	js     80105aa0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105a81:	83 ec 04             	sub    $0x4,%esp
80105a84:	ff 75 f0             	pushl  -0x10(%ebp)
80105a87:	ff 75 f4             	pushl  -0xc(%ebp)
80105a8a:	ff 75 ec             	pushl  -0x14(%ebp)
80105a8d:	e8 3e b8 ff ff       	call   801012d0 <filewrite>
80105a92:	83 c4 10             	add    $0x10,%esp
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa5:	c9                   	leave  
80105aa6:	c3                   	ret    
80105aa7:	89 f6                	mov    %esi,%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ab0 <sys_close>:

int
sys_close(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105ab6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105ab9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105abc:	e8 4f fe ff ff       	call   80105910 <argfd.constprop.0>
80105ac1:	85 c0                	test   %eax,%eax
80105ac3:	78 2b                	js     80105af0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105ac5:	e8 96 e5 ff ff       	call   80104060 <myproc>
80105aca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105acd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105ad0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105ad7:	00 
  fileclose(f);
80105ad8:	ff 75 f4             	pushl  -0xc(%ebp)
80105adb:	e8 40 b6 ff ff       	call   80101120 <fileclose>
  return 0;
80105ae0:	83 c4 10             	add    $0x10,%esp
80105ae3:	31 c0                	xor    %eax,%eax
}
80105ae5:	c9                   	leave  
80105ae6:	c3                   	ret    
80105ae7:	89 f6                	mov    %esi,%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b00 <sys_fstat>:

int
sys_fstat(void)
{
80105b00:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b01:	31 c0                	xor    %eax,%eax
{
80105b03:	89 e5                	mov    %esp,%ebp
80105b05:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105b08:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105b0b:	e8 00 fe ff ff       	call   80105910 <argfd.constprop.0>
80105b10:	85 c0                	test   %eax,%eax
80105b12:	78 2c                	js     80105b40 <sys_fstat+0x40>
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b17:	83 ec 04             	sub    $0x4,%esp
80105b1a:	6a 14                	push   $0x14
80105b1c:	50                   	push   %eax
80105b1d:	6a 01                	push   $0x1
80105b1f:	e8 ec fc ff ff       	call   80105810 <argptr>
80105b24:	83 c4 10             	add    $0x10,%esp
80105b27:	85 c0                	test   %eax,%eax
80105b29:	78 15                	js     80105b40 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80105b2b:	83 ec 08             	sub    $0x8,%esp
80105b2e:	ff 75 f4             	pushl  -0xc(%ebp)
80105b31:	ff 75 f0             	pushl  -0x10(%ebp)
80105b34:	e8 b7 b6 ff ff       	call   801011f0 <filestat>
80105b39:	83 c4 10             	add    $0x10,%esp
}
80105b3c:	c9                   	leave  
80105b3d:	c3                   	ret    
80105b3e:	66 90                	xchg   %ax,%ax
    return -1;
80105b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b45:	c9                   	leave  
80105b46:	c3                   	ret    
80105b47:	89 f6                	mov    %esi,%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b50 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	57                   	push   %edi
80105b54:	56                   	push   %esi
80105b55:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b56:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105b59:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105b5c:	50                   	push   %eax
80105b5d:	6a 00                	push   $0x0
80105b5f:	e8 0c fd ff ff       	call   80105870 <argstr>
80105b64:	83 c4 10             	add    $0x10,%esp
80105b67:	85 c0                	test   %eax,%eax
80105b69:	0f 88 fb 00 00 00    	js     80105c6a <sys_link+0x11a>
80105b6f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105b72:	83 ec 08             	sub    $0x8,%esp
80105b75:	50                   	push   %eax
80105b76:	6a 01                	push   $0x1
80105b78:	e8 f3 fc ff ff       	call   80105870 <argstr>
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	85 c0                	test   %eax,%eax
80105b82:	0f 88 e2 00 00 00    	js     80105c6a <sys_link+0x11a>
    return -1;

  begin_op();
80105b88:	e8 03 d8 ff ff       	call   80103390 <begin_op>
  if((ip = namei(old)) == 0){
80105b8d:	83 ec 0c             	sub    $0xc,%esp
80105b90:	ff 75 d4             	pushl  -0x2c(%ebp)
80105b93:	e8 28 c6 ff ff       	call   801021c0 <namei>
80105b98:	83 c4 10             	add    $0x10,%esp
80105b9b:	85 c0                	test   %eax,%eax
80105b9d:	89 c3                	mov    %eax,%ebx
80105b9f:	0f 84 ea 00 00 00    	je     80105c8f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105ba5:	83 ec 0c             	sub    $0xc,%esp
80105ba8:	50                   	push   %eax
80105ba9:	e8 b2 bd ff ff       	call   80101960 <ilock>
  if(ip->type == T_DIR){
80105bae:	83 c4 10             	add    $0x10,%esp
80105bb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bb6:	0f 84 bb 00 00 00    	je     80105c77 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105bbc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105bc1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105bc4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105bc7:	53                   	push   %ebx
80105bc8:	e8 e3 bc ff ff       	call   801018b0 <iupdate>
  iunlock(ip);
80105bcd:	89 1c 24             	mov    %ebx,(%esp)
80105bd0:	e8 6b be ff ff       	call   80101a40 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105bd5:	58                   	pop    %eax
80105bd6:	5a                   	pop    %edx
80105bd7:	57                   	push   %edi
80105bd8:	ff 75 d0             	pushl  -0x30(%ebp)
80105bdb:	e8 00 c6 ff ff       	call   801021e0 <nameiparent>
80105be0:	83 c4 10             	add    $0x10,%esp
80105be3:	85 c0                	test   %eax,%eax
80105be5:	89 c6                	mov    %eax,%esi
80105be7:	74 5b                	je     80105c44 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105be9:	83 ec 0c             	sub    $0xc,%esp
80105bec:	50                   	push   %eax
80105bed:	e8 6e bd ff ff       	call   80101960 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105bf2:	83 c4 10             	add    $0x10,%esp
80105bf5:	8b 03                	mov    (%ebx),%eax
80105bf7:	39 06                	cmp    %eax,(%esi)
80105bf9:	75 3d                	jne    80105c38 <sys_link+0xe8>
80105bfb:	83 ec 04             	sub    $0x4,%esp
80105bfe:	ff 73 04             	pushl  0x4(%ebx)
80105c01:	57                   	push   %edi
80105c02:	56                   	push   %esi
80105c03:	e8 f8 c4 ff ff       	call   80102100 <dirlink>
80105c08:	83 c4 10             	add    $0x10,%esp
80105c0b:	85 c0                	test   %eax,%eax
80105c0d:	78 29                	js     80105c38 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105c0f:	83 ec 0c             	sub    $0xc,%esp
80105c12:	56                   	push   %esi
80105c13:	e8 d8 bf ff ff       	call   80101bf0 <iunlockput>
  iput(ip);
80105c18:	89 1c 24             	mov    %ebx,(%esp)
80105c1b:	e8 70 be ff ff       	call   80101a90 <iput>

  end_op();
80105c20:	e8 db d7 ff ff       	call   80103400 <end_op>

  return 0;
80105c25:	83 c4 10             	add    $0x10,%esp
80105c28:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c2d:	5b                   	pop    %ebx
80105c2e:	5e                   	pop    %esi
80105c2f:	5f                   	pop    %edi
80105c30:	5d                   	pop    %ebp
80105c31:	c3                   	ret    
80105c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105c38:	83 ec 0c             	sub    $0xc,%esp
80105c3b:	56                   	push   %esi
80105c3c:	e8 af bf ff ff       	call   80101bf0 <iunlockput>
    goto bad;
80105c41:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105c44:	83 ec 0c             	sub    $0xc,%esp
80105c47:	53                   	push   %ebx
80105c48:	e8 13 bd ff ff       	call   80101960 <ilock>
  ip->nlink--;
80105c4d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c52:	89 1c 24             	mov    %ebx,(%esp)
80105c55:	e8 56 bc ff ff       	call   801018b0 <iupdate>
  iunlockput(ip);
80105c5a:	89 1c 24             	mov    %ebx,(%esp)
80105c5d:	e8 8e bf ff ff       	call   80101bf0 <iunlockput>
  end_op();
80105c62:	e8 99 d7 ff ff       	call   80103400 <end_op>
  return -1;
80105c67:	83 c4 10             	add    $0x10,%esp
}
80105c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c72:	5b                   	pop    %ebx
80105c73:	5e                   	pop    %esi
80105c74:	5f                   	pop    %edi
80105c75:	5d                   	pop    %ebp
80105c76:	c3                   	ret    
    iunlockput(ip);
80105c77:	83 ec 0c             	sub    $0xc,%esp
80105c7a:	53                   	push   %ebx
80105c7b:	e8 70 bf ff ff       	call   80101bf0 <iunlockput>
    end_op();
80105c80:	e8 7b d7 ff ff       	call   80103400 <end_op>
    return -1;
80105c85:	83 c4 10             	add    $0x10,%esp
80105c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8d:	eb 9b                	jmp    80105c2a <sys_link+0xda>
    end_op();
80105c8f:	e8 6c d7 ff ff       	call   80103400 <end_op>
    return -1;
80105c94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c99:	eb 8f                	jmp    80105c2a <sys_link+0xda>
80105c9b:	90                   	nop
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ca0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	57                   	push   %edi
80105ca4:	56                   	push   %esi
80105ca5:	53                   	push   %ebx
80105ca6:	83 ec 1c             	sub    $0x1c,%esp
80105ca9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105cac:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105cb0:	76 3e                	jbe    80105cf0 <isdirempty+0x50>
80105cb2:	bb 20 00 00 00       	mov    $0x20,%ebx
80105cb7:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105cba:	eb 0c                	jmp    80105cc8 <isdirempty+0x28>
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cc0:	83 c3 10             	add    $0x10,%ebx
80105cc3:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105cc6:	73 28                	jae    80105cf0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cc8:	6a 10                	push   $0x10
80105cca:	53                   	push   %ebx
80105ccb:	57                   	push   %edi
80105ccc:	56                   	push   %esi
80105ccd:	e8 6e bf ff ff       	call   80101c40 <readi>
80105cd2:	83 c4 10             	add    $0x10,%esp
80105cd5:	83 f8 10             	cmp    $0x10,%eax
80105cd8:	75 23                	jne    80105cfd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105cda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105cdf:	74 df                	je     80105cc0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105ce4:	31 c0                	xor    %eax,%eax
}
80105ce6:	5b                   	pop    %ebx
80105ce7:	5e                   	pop    %esi
80105ce8:	5f                   	pop    %edi
80105ce9:	5d                   	pop    %ebp
80105cea:	c3                   	ret    
80105ceb:	90                   	nop
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105cf3:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105cf8:	5b                   	pop    %ebx
80105cf9:	5e                   	pop    %esi
80105cfa:	5f                   	pop    %edi
80105cfb:	5d                   	pop    %ebp
80105cfc:	c3                   	ret    
      panic("isdirempty: readi");
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	68 1c 90 10 80       	push   $0x8010901c
80105d05:	e8 86 a6 ff ff       	call   80100390 <panic>
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d10 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
80105d15:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105d16:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105d19:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105d1c:	50                   	push   %eax
80105d1d:	6a 00                	push   $0x0
80105d1f:	e8 4c fb ff ff       	call   80105870 <argstr>
80105d24:	83 c4 10             	add    $0x10,%esp
80105d27:	85 c0                	test   %eax,%eax
80105d29:	0f 88 51 01 00 00    	js     80105e80 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105d2f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105d32:	e8 59 d6 ff ff       	call   80103390 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105d37:	83 ec 08             	sub    $0x8,%esp
80105d3a:	53                   	push   %ebx
80105d3b:	ff 75 c0             	pushl  -0x40(%ebp)
80105d3e:	e8 9d c4 ff ff       	call   801021e0 <nameiparent>
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	85 c0                	test   %eax,%eax
80105d48:	89 c6                	mov    %eax,%esi
80105d4a:	0f 84 37 01 00 00    	je     80105e87 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	50                   	push   %eax
80105d54:	e8 07 bc ff ff       	call   80101960 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d59:	58                   	pop    %eax
80105d5a:	5a                   	pop    %edx
80105d5b:	68 3d 89 10 80       	push   $0x8010893d
80105d60:	53                   	push   %ebx
80105d61:	e8 0a c1 ff ff       	call   80101e70 <namecmp>
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	85 c0                	test   %eax,%eax
80105d6b:	0f 84 d7 00 00 00    	je     80105e48 <sys_unlink+0x138>
80105d71:	83 ec 08             	sub    $0x8,%esp
80105d74:	68 3c 89 10 80       	push   $0x8010893c
80105d79:	53                   	push   %ebx
80105d7a:	e8 f1 c0 ff ff       	call   80101e70 <namecmp>
80105d7f:	83 c4 10             	add    $0x10,%esp
80105d82:	85 c0                	test   %eax,%eax
80105d84:	0f 84 be 00 00 00    	je     80105e48 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105d8a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105d8d:	83 ec 04             	sub    $0x4,%esp
80105d90:	50                   	push   %eax
80105d91:	53                   	push   %ebx
80105d92:	56                   	push   %esi
80105d93:	e8 f8 c0 ff ff       	call   80101e90 <dirlookup>
80105d98:	83 c4 10             	add    $0x10,%esp
80105d9b:	85 c0                	test   %eax,%eax
80105d9d:	89 c3                	mov    %eax,%ebx
80105d9f:	0f 84 a3 00 00 00    	je     80105e48 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105da5:	83 ec 0c             	sub    $0xc,%esp
80105da8:	50                   	push   %eax
80105da9:	e8 b2 bb ff ff       	call   80101960 <ilock>

  if(ip->nlink < 1)
80105dae:	83 c4 10             	add    $0x10,%esp
80105db1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105db6:	0f 8e e4 00 00 00    	jle    80105ea0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105dbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105dc1:	74 65                	je     80105e28 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105dc3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105dc6:	83 ec 04             	sub    $0x4,%esp
80105dc9:	6a 10                	push   $0x10
80105dcb:	6a 00                	push   $0x0
80105dcd:	57                   	push   %edi
80105dce:	e8 ed f6 ff ff       	call   801054c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105dd3:	6a 10                	push   $0x10
80105dd5:	ff 75 c4             	pushl  -0x3c(%ebp)
80105dd8:	57                   	push   %edi
80105dd9:	56                   	push   %esi
80105dda:	e8 61 bf ff ff       	call   80101d40 <writei>
80105ddf:	83 c4 20             	add    $0x20,%esp
80105de2:	83 f8 10             	cmp    $0x10,%eax
80105de5:	0f 85 a8 00 00 00    	jne    80105e93 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105deb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105df0:	74 6e                	je     80105e60 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105df2:	83 ec 0c             	sub    $0xc,%esp
80105df5:	56                   	push   %esi
80105df6:	e8 f5 bd ff ff       	call   80101bf0 <iunlockput>

  ip->nlink--;
80105dfb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105e00:	89 1c 24             	mov    %ebx,(%esp)
80105e03:	e8 a8 ba ff ff       	call   801018b0 <iupdate>
  iunlockput(ip);
80105e08:	89 1c 24             	mov    %ebx,(%esp)
80105e0b:	e8 e0 bd ff ff       	call   80101bf0 <iunlockput>

  end_op();
80105e10:	e8 eb d5 ff ff       	call   80103400 <end_op>

  return 0;
80105e15:	83 c4 10             	add    $0x10,%esp
80105e18:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e1d:	5b                   	pop    %ebx
80105e1e:	5e                   	pop    %esi
80105e1f:	5f                   	pop    %edi
80105e20:	5d                   	pop    %ebp
80105e21:	c3                   	ret    
80105e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105e28:	83 ec 0c             	sub    $0xc,%esp
80105e2b:	53                   	push   %ebx
80105e2c:	e8 6f fe ff ff       	call   80105ca0 <isdirempty>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	85 c0                	test   %eax,%eax
80105e36:	75 8b                	jne    80105dc3 <sys_unlink+0xb3>
    iunlockput(ip);
80105e38:	83 ec 0c             	sub    $0xc,%esp
80105e3b:	53                   	push   %ebx
80105e3c:	e8 af bd ff ff       	call   80101bf0 <iunlockput>
    goto bad;
80105e41:	83 c4 10             	add    $0x10,%esp
80105e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105e48:	83 ec 0c             	sub    $0xc,%esp
80105e4b:	56                   	push   %esi
80105e4c:	e8 9f bd ff ff       	call   80101bf0 <iunlockput>
  end_op();
80105e51:	e8 aa d5 ff ff       	call   80103400 <end_op>
  return -1;
80105e56:	83 c4 10             	add    $0x10,%esp
80105e59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5e:	eb ba                	jmp    80105e1a <sys_unlink+0x10a>
    dp->nlink--;
80105e60:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105e65:	83 ec 0c             	sub    $0xc,%esp
80105e68:	56                   	push   %esi
80105e69:	e8 42 ba ff ff       	call   801018b0 <iupdate>
80105e6e:	83 c4 10             	add    $0x10,%esp
80105e71:	e9 7c ff ff ff       	jmp    80105df2 <sys_unlink+0xe2>
80105e76:	8d 76 00             	lea    0x0(%esi),%esi
80105e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e85:	eb 93                	jmp    80105e1a <sys_unlink+0x10a>
    end_op();
80105e87:	e8 74 d5 ff ff       	call   80103400 <end_op>
    return -1;
80105e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e91:	eb 87                	jmp    80105e1a <sys_unlink+0x10a>
    panic("unlink: writei");
80105e93:	83 ec 0c             	sub    $0xc,%esp
80105e96:	68 51 89 10 80       	push   $0x80108951
80105e9b:	e8 f0 a4 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	68 3f 89 10 80       	push   $0x8010893f
80105ea8:	e8 e3 a4 ff ff       	call   80100390 <panic>
80105ead:	8d 76 00             	lea    0x0(%esi),%esi

80105eb0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	57                   	push   %edi
80105eb4:	56                   	push   %esi
80105eb5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105eb6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105eb9:	83 ec 34             	sub    $0x34,%esp
80105ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ebf:	8b 55 10             	mov    0x10(%ebp),%edx
80105ec2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105ec5:	56                   	push   %esi
80105ec6:	ff 75 08             	pushl  0x8(%ebp)
{
80105ec9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105ecc:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105ecf:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105ed2:	e8 09 c3 ff ff       	call   801021e0 <nameiparent>
80105ed7:	83 c4 10             	add    $0x10,%esp
80105eda:	85 c0                	test   %eax,%eax
80105edc:	0f 84 4e 01 00 00    	je     80106030 <create+0x180>
    return 0;
  ilock(dp);
80105ee2:	83 ec 0c             	sub    $0xc,%esp
80105ee5:	89 c3                	mov    %eax,%ebx
80105ee7:	50                   	push   %eax
80105ee8:	e8 73 ba ff ff       	call   80101960 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105eed:	83 c4 0c             	add    $0xc,%esp
80105ef0:	6a 00                	push   $0x0
80105ef2:	56                   	push   %esi
80105ef3:	53                   	push   %ebx
80105ef4:	e8 97 bf ff ff       	call   80101e90 <dirlookup>
80105ef9:	83 c4 10             	add    $0x10,%esp
80105efc:	85 c0                	test   %eax,%eax
80105efe:	89 c7                	mov    %eax,%edi
80105f00:	74 3e                	je     80105f40 <create+0x90>
    iunlockput(dp);
80105f02:	83 ec 0c             	sub    $0xc,%esp
80105f05:	53                   	push   %ebx
80105f06:	e8 e5 bc ff ff       	call   80101bf0 <iunlockput>
    ilock(ip);
80105f0b:	89 3c 24             	mov    %edi,(%esp)
80105f0e:	e8 4d ba ff ff       	call   80101960 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105f13:	83 c4 10             	add    $0x10,%esp
80105f16:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105f1b:	0f 85 9f 00 00 00    	jne    80105fc0 <create+0x110>
80105f21:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105f26:	0f 85 94 00 00 00    	jne    80105fc0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f2f:	89 f8                	mov    %edi,%eax
80105f31:	5b                   	pop    %ebx
80105f32:	5e                   	pop    %esi
80105f33:	5f                   	pop    %edi
80105f34:	5d                   	pop    %ebp
80105f35:	c3                   	ret    
80105f36:	8d 76 00             	lea    0x0(%esi),%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105f40:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105f44:	83 ec 08             	sub    $0x8,%esp
80105f47:	50                   	push   %eax
80105f48:	ff 33                	pushl  (%ebx)
80105f4a:	e8 a1 b8 ff ff       	call   801017f0 <ialloc>
80105f4f:	83 c4 10             	add    $0x10,%esp
80105f52:	85 c0                	test   %eax,%eax
80105f54:	89 c7                	mov    %eax,%edi
80105f56:	0f 84 e8 00 00 00    	je     80106044 <create+0x194>
  ilock(ip);
80105f5c:	83 ec 0c             	sub    $0xc,%esp
80105f5f:	50                   	push   %eax
80105f60:	e8 fb b9 ff ff       	call   80101960 <ilock>
  ip->major = major;
80105f65:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105f69:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105f6d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105f71:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105f75:	b8 01 00 00 00       	mov    $0x1,%eax
80105f7a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105f7e:	89 3c 24             	mov    %edi,(%esp)
80105f81:	e8 2a b9 ff ff       	call   801018b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105f86:	83 c4 10             	add    $0x10,%esp
80105f89:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f8e:	74 50                	je     80105fe0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105f90:	83 ec 04             	sub    $0x4,%esp
80105f93:	ff 77 04             	pushl  0x4(%edi)
80105f96:	56                   	push   %esi
80105f97:	53                   	push   %ebx
80105f98:	e8 63 c1 ff ff       	call   80102100 <dirlink>
80105f9d:	83 c4 10             	add    $0x10,%esp
80105fa0:	85 c0                	test   %eax,%eax
80105fa2:	0f 88 8f 00 00 00    	js     80106037 <create+0x187>
  iunlockput(dp);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	53                   	push   %ebx
80105fac:	e8 3f bc ff ff       	call   80101bf0 <iunlockput>
  return ip;
80105fb1:	83 c4 10             	add    $0x10,%esp
}
80105fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb7:	89 f8                	mov    %edi,%eax
80105fb9:	5b                   	pop    %ebx
80105fba:	5e                   	pop    %esi
80105fbb:	5f                   	pop    %edi
80105fbc:	5d                   	pop    %ebp
80105fbd:	c3                   	ret    
80105fbe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	57                   	push   %edi
    return 0;
80105fc4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105fc6:	e8 25 bc ff ff       	call   80101bf0 <iunlockput>
    return 0;
80105fcb:	83 c4 10             	add    $0x10,%esp
}
80105fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fd1:	89 f8                	mov    %edi,%eax
80105fd3:	5b                   	pop    %ebx
80105fd4:	5e                   	pop    %esi
80105fd5:	5f                   	pop    %edi
80105fd6:	5d                   	pop    %ebp
80105fd7:	c3                   	ret    
80105fd8:	90                   	nop
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105fe0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105fe5:	83 ec 0c             	sub    $0xc,%esp
80105fe8:	53                   	push   %ebx
80105fe9:	e8 c2 b8 ff ff       	call   801018b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105fee:	83 c4 0c             	add    $0xc,%esp
80105ff1:	ff 77 04             	pushl  0x4(%edi)
80105ff4:	68 3d 89 10 80       	push   $0x8010893d
80105ff9:	57                   	push   %edi
80105ffa:	e8 01 c1 ff ff       	call   80102100 <dirlink>
80105fff:	83 c4 10             	add    $0x10,%esp
80106002:	85 c0                	test   %eax,%eax
80106004:	78 1c                	js     80106022 <create+0x172>
80106006:	83 ec 04             	sub    $0x4,%esp
80106009:	ff 73 04             	pushl  0x4(%ebx)
8010600c:	68 3c 89 10 80       	push   $0x8010893c
80106011:	57                   	push   %edi
80106012:	e8 e9 c0 ff ff       	call   80102100 <dirlink>
80106017:	83 c4 10             	add    $0x10,%esp
8010601a:	85 c0                	test   %eax,%eax
8010601c:	0f 89 6e ff ff ff    	jns    80105f90 <create+0xe0>
      panic("create dots");
80106022:	83 ec 0c             	sub    $0xc,%esp
80106025:	68 3d 90 10 80       	push   $0x8010903d
8010602a:	e8 61 a3 ff ff       	call   80100390 <panic>
8010602f:	90                   	nop
    return 0;
80106030:	31 ff                	xor    %edi,%edi
80106032:	e9 f5 fe ff ff       	jmp    80105f2c <create+0x7c>
    panic("create: dirlink");
80106037:	83 ec 0c             	sub    $0xc,%esp
8010603a:	68 49 90 10 80       	push   $0x80109049
8010603f:	e8 4c a3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80106044:	83 ec 0c             	sub    $0xc,%esp
80106047:	68 2e 90 10 80       	push   $0x8010902e
8010604c:	e8 3f a3 ff ff       	call   80100390 <panic>
80106051:	eb 0d                	jmp    80106060 <sys_open>
80106053:	90                   	nop
80106054:	90                   	nop
80106055:	90                   	nop
80106056:	90                   	nop
80106057:	90                   	nop
80106058:	90                   	nop
80106059:	90                   	nop
8010605a:	90                   	nop
8010605b:	90                   	nop
8010605c:	90                   	nop
8010605d:	90                   	nop
8010605e:	90                   	nop
8010605f:	90                   	nop

80106060 <sys_open>:

int
sys_open(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	57                   	push   %edi
80106064:	56                   	push   %esi
80106065:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106066:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106069:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010606c:	50                   	push   %eax
8010606d:	6a 00                	push   $0x0
8010606f:	e8 fc f7 ff ff       	call   80105870 <argstr>
80106074:	83 c4 10             	add    $0x10,%esp
80106077:	85 c0                	test   %eax,%eax
80106079:	0f 88 1d 01 00 00    	js     8010619c <sys_open+0x13c>
8010607f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106082:	83 ec 08             	sub    $0x8,%esp
80106085:	50                   	push   %eax
80106086:	6a 01                	push   $0x1
80106088:	e8 33 f7 ff ff       	call   801057c0 <argint>
8010608d:	83 c4 10             	add    $0x10,%esp
80106090:	85 c0                	test   %eax,%eax
80106092:	0f 88 04 01 00 00    	js     8010619c <sys_open+0x13c>
    return -1;

  begin_op();
80106098:	e8 f3 d2 ff ff       	call   80103390 <begin_op>

  if(omode & O_CREATE){
8010609d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801060a1:	0f 85 a9 00 00 00    	jne    80106150 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801060a7:	83 ec 0c             	sub    $0xc,%esp
801060aa:	ff 75 e0             	pushl  -0x20(%ebp)
801060ad:	e8 0e c1 ff ff       	call   801021c0 <namei>
801060b2:	83 c4 10             	add    $0x10,%esp
801060b5:	85 c0                	test   %eax,%eax
801060b7:	89 c6                	mov    %eax,%esi
801060b9:	0f 84 ac 00 00 00    	je     8010616b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
801060bf:	83 ec 0c             	sub    $0xc,%esp
801060c2:	50                   	push   %eax
801060c3:	e8 98 b8 ff ff       	call   80101960 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801060c8:	83 c4 10             	add    $0x10,%esp
801060cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801060d0:	0f 84 aa 00 00 00    	je     80106180 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060d6:	e8 85 af ff ff       	call   80101060 <filealloc>
801060db:	85 c0                	test   %eax,%eax
801060dd:	89 c7                	mov    %eax,%edi
801060df:	0f 84 a6 00 00 00    	je     8010618b <sys_open+0x12b>
  struct proc *curproc = myproc();
801060e5:	e8 76 df ff ff       	call   80104060 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060ea:	31 db                	xor    %ebx,%ebx
801060ec:	eb 0e                	jmp    801060fc <sys_open+0x9c>
801060ee:	66 90                	xchg   %ax,%ax
801060f0:	83 c3 01             	add    $0x1,%ebx
801060f3:	83 fb 10             	cmp    $0x10,%ebx
801060f6:	0f 84 ac 00 00 00    	je     801061a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801060fc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106100:	85 d2                	test   %edx,%edx
80106102:	75 ec                	jne    801060f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106104:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106107:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010610b:	56                   	push   %esi
8010610c:	e8 2f b9 ff ff       	call   80101a40 <iunlock>
  end_op();
80106111:	e8 ea d2 ff ff       	call   80103400 <end_op>

  f->type = FD_INODE;
80106116:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010611c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010611f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106122:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80106125:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010612c:	89 d0                	mov    %edx,%eax
8010612e:	f7 d0                	not    %eax
80106130:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106133:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106136:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106139:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010613d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106140:	89 d8                	mov    %ebx,%eax
80106142:	5b                   	pop    %ebx
80106143:	5e                   	pop    %esi
80106144:	5f                   	pop    %edi
80106145:	5d                   	pop    %ebp
80106146:	c3                   	ret    
80106147:	89 f6                	mov    %esi,%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80106150:	6a 00                	push   $0x0
80106152:	6a 00                	push   $0x0
80106154:	6a 02                	push   $0x2
80106156:	ff 75 e0             	pushl  -0x20(%ebp)
80106159:	e8 52 fd ff ff       	call   80105eb0 <create>
    if(ip == 0){
8010615e:	83 c4 10             	add    $0x10,%esp
80106161:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106163:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106165:	0f 85 6b ff ff ff    	jne    801060d6 <sys_open+0x76>
      end_op();
8010616b:	e8 90 d2 ff ff       	call   80103400 <end_op>
      return -1;
80106170:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106175:	eb c6                	jmp    8010613d <sys_open+0xdd>
80106177:	89 f6                	mov    %esi,%esi
80106179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106180:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106183:	85 c9                	test   %ecx,%ecx
80106185:	0f 84 4b ff ff ff    	je     801060d6 <sys_open+0x76>
    iunlockput(ip);
8010618b:	83 ec 0c             	sub    $0xc,%esp
8010618e:	56                   	push   %esi
8010618f:	e8 5c ba ff ff       	call   80101bf0 <iunlockput>
    end_op();
80106194:	e8 67 d2 ff ff       	call   80103400 <end_op>
    return -1;
80106199:	83 c4 10             	add    $0x10,%esp
8010619c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801061a1:	eb 9a                	jmp    8010613d <sys_open+0xdd>
801061a3:	90                   	nop
801061a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801061a8:	83 ec 0c             	sub    $0xc,%esp
801061ab:	57                   	push   %edi
801061ac:	e8 6f af ff ff       	call   80101120 <fileclose>
801061b1:	83 c4 10             	add    $0x10,%esp
801061b4:	eb d5                	jmp    8010618b <sys_open+0x12b>
801061b6:	8d 76 00             	lea    0x0(%esi),%esi
801061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801061c6:	e8 c5 d1 ff ff       	call   80103390 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801061cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061ce:	83 ec 08             	sub    $0x8,%esp
801061d1:	50                   	push   %eax
801061d2:	6a 00                	push   $0x0
801061d4:	e8 97 f6 ff ff       	call   80105870 <argstr>
801061d9:	83 c4 10             	add    $0x10,%esp
801061dc:	85 c0                	test   %eax,%eax
801061de:	78 30                	js     80106210 <sys_mkdir+0x50>
801061e0:	6a 00                	push   $0x0
801061e2:	6a 00                	push   $0x0
801061e4:	6a 01                	push   $0x1
801061e6:	ff 75 f4             	pushl  -0xc(%ebp)
801061e9:	e8 c2 fc ff ff       	call   80105eb0 <create>
801061ee:	83 c4 10             	add    $0x10,%esp
801061f1:	85 c0                	test   %eax,%eax
801061f3:	74 1b                	je     80106210 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801061f5:	83 ec 0c             	sub    $0xc,%esp
801061f8:	50                   	push   %eax
801061f9:	e8 f2 b9 ff ff       	call   80101bf0 <iunlockput>
  end_op();
801061fe:	e8 fd d1 ff ff       	call   80103400 <end_op>
  return 0;
80106203:	83 c4 10             	add    $0x10,%esp
80106206:	31 c0                	xor    %eax,%eax
}
80106208:	c9                   	leave  
80106209:	c3                   	ret    
8010620a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106210:	e8 eb d1 ff ff       	call   80103400 <end_op>
    return -1;
80106215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010621a:	c9                   	leave  
8010621b:	c3                   	ret    
8010621c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106220 <sys_mknod>:

int
sys_mknod(void)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106226:	e8 65 d1 ff ff       	call   80103390 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010622b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010622e:	83 ec 08             	sub    $0x8,%esp
80106231:	50                   	push   %eax
80106232:	6a 00                	push   $0x0
80106234:	e8 37 f6 ff ff       	call   80105870 <argstr>
80106239:	83 c4 10             	add    $0x10,%esp
8010623c:	85 c0                	test   %eax,%eax
8010623e:	78 60                	js     801062a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106240:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106243:	83 ec 08             	sub    $0x8,%esp
80106246:	50                   	push   %eax
80106247:	6a 01                	push   $0x1
80106249:	e8 72 f5 ff ff       	call   801057c0 <argint>
  if((argstr(0, &path)) < 0 ||
8010624e:	83 c4 10             	add    $0x10,%esp
80106251:	85 c0                	test   %eax,%eax
80106253:	78 4b                	js     801062a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106255:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106258:	83 ec 08             	sub    $0x8,%esp
8010625b:	50                   	push   %eax
8010625c:	6a 02                	push   $0x2
8010625e:	e8 5d f5 ff ff       	call   801057c0 <argint>
     argint(1, &major) < 0 ||
80106263:	83 c4 10             	add    $0x10,%esp
80106266:	85 c0                	test   %eax,%eax
80106268:	78 36                	js     801062a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010626a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010626e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010626f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80106273:	50                   	push   %eax
80106274:	6a 03                	push   $0x3
80106276:	ff 75 ec             	pushl  -0x14(%ebp)
80106279:	e8 32 fc ff ff       	call   80105eb0 <create>
8010627e:	83 c4 10             	add    $0x10,%esp
80106281:	85 c0                	test   %eax,%eax
80106283:	74 1b                	je     801062a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106285:	83 ec 0c             	sub    $0xc,%esp
80106288:	50                   	push   %eax
80106289:	e8 62 b9 ff ff       	call   80101bf0 <iunlockput>
  end_op();
8010628e:	e8 6d d1 ff ff       	call   80103400 <end_op>
  return 0;
80106293:	83 c4 10             	add    $0x10,%esp
80106296:	31 c0                	xor    %eax,%eax
}
80106298:	c9                   	leave  
80106299:	c3                   	ret    
8010629a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801062a0:	e8 5b d1 ff ff       	call   80103400 <end_op>
    return -1;
801062a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062aa:	c9                   	leave  
801062ab:	c3                   	ret    
801062ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062b0 <sys_chdir>:

int
sys_chdir(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	56                   	push   %esi
801062b4:	53                   	push   %ebx
801062b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801062b8:	e8 a3 dd ff ff       	call   80104060 <myproc>
801062bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801062bf:	e8 cc d0 ff ff       	call   80103390 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801062c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062c7:	83 ec 08             	sub    $0x8,%esp
801062ca:	50                   	push   %eax
801062cb:	6a 00                	push   $0x0
801062cd:	e8 9e f5 ff ff       	call   80105870 <argstr>
801062d2:	83 c4 10             	add    $0x10,%esp
801062d5:	85 c0                	test   %eax,%eax
801062d7:	78 77                	js     80106350 <sys_chdir+0xa0>
801062d9:	83 ec 0c             	sub    $0xc,%esp
801062dc:	ff 75 f4             	pushl  -0xc(%ebp)
801062df:	e8 dc be ff ff       	call   801021c0 <namei>
801062e4:	83 c4 10             	add    $0x10,%esp
801062e7:	85 c0                	test   %eax,%eax
801062e9:	89 c3                	mov    %eax,%ebx
801062eb:	74 63                	je     80106350 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801062ed:	83 ec 0c             	sub    $0xc,%esp
801062f0:	50                   	push   %eax
801062f1:	e8 6a b6 ff ff       	call   80101960 <ilock>
  if(ip->type != T_DIR){
801062f6:	83 c4 10             	add    $0x10,%esp
801062f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801062fe:	75 30                	jne    80106330 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106300:	83 ec 0c             	sub    $0xc,%esp
80106303:	53                   	push   %ebx
80106304:	e8 37 b7 ff ff       	call   80101a40 <iunlock>
  iput(curproc->cwd);
80106309:	58                   	pop    %eax
8010630a:	ff 76 68             	pushl  0x68(%esi)
8010630d:	e8 7e b7 ff ff       	call   80101a90 <iput>
  end_op();
80106312:	e8 e9 d0 ff ff       	call   80103400 <end_op>
  curproc->cwd = ip;
80106317:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010631a:	83 c4 10             	add    $0x10,%esp
8010631d:	31 c0                	xor    %eax,%eax
}
8010631f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106322:	5b                   	pop    %ebx
80106323:	5e                   	pop    %esi
80106324:	5d                   	pop    %ebp
80106325:	c3                   	ret    
80106326:	8d 76 00             	lea    0x0(%esi),%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	53                   	push   %ebx
80106334:	e8 b7 b8 ff ff       	call   80101bf0 <iunlockput>
    end_op();
80106339:	e8 c2 d0 ff ff       	call   80103400 <end_op>
    return -1;
8010633e:	83 c4 10             	add    $0x10,%esp
80106341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106346:	eb d7                	jmp    8010631f <sys_chdir+0x6f>
80106348:	90                   	nop
80106349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106350:	e8 ab d0 ff ff       	call   80103400 <end_op>
    return -1;
80106355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635a:	eb c3                	jmp    8010631f <sys_chdir+0x6f>
8010635c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106360 <sys_exec>:

int
sys_exec(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	57                   	push   %edi
80106364:	56                   	push   %esi
80106365:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106366:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010636c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106372:	50                   	push   %eax
80106373:	6a 00                	push   $0x0
80106375:	e8 f6 f4 ff ff       	call   80105870 <argstr>
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	85 c0                	test   %eax,%eax
8010637f:	0f 88 87 00 00 00    	js     8010640c <sys_exec+0xac>
80106385:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010638b:	83 ec 08             	sub    $0x8,%esp
8010638e:	50                   	push   %eax
8010638f:	6a 01                	push   $0x1
80106391:	e8 2a f4 ff ff       	call   801057c0 <argint>
80106396:	83 c4 10             	add    $0x10,%esp
80106399:	85 c0                	test   %eax,%eax
8010639b:	78 6f                	js     8010640c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010639d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063a3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801063a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801063a8:	68 80 00 00 00       	push   $0x80
801063ad:	6a 00                	push   $0x0
801063af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801063b5:	50                   	push   %eax
801063b6:	e8 05 f1 ff ff       	call   801054c0 <memset>
801063bb:	83 c4 10             	add    $0x10,%esp
801063be:	eb 2c                	jmp    801063ec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801063c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801063c6:	85 c0                	test   %eax,%eax
801063c8:	74 56                	je     80106420 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801063ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801063d0:	83 ec 08             	sub    $0x8,%esp
801063d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801063d6:	52                   	push   %edx
801063d7:	50                   	push   %eax
801063d8:	e8 73 f3 ff ff       	call   80105750 <fetchstr>
801063dd:	83 c4 10             	add    $0x10,%esp
801063e0:	85 c0                	test   %eax,%eax
801063e2:	78 28                	js     8010640c <sys_exec+0xac>
  for(i=0;; i++){
801063e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801063e7:	83 fb 20             	cmp    $0x20,%ebx
801063ea:	74 20                	je     8010640c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801063f2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801063f9:	83 ec 08             	sub    $0x8,%esp
801063fc:	57                   	push   %edi
801063fd:	01 f0                	add    %esi,%eax
801063ff:	50                   	push   %eax
80106400:	e8 0b f3 ff ff       	call   80105710 <fetchint>
80106405:	83 c4 10             	add    $0x10,%esp
80106408:	85 c0                	test   %eax,%eax
8010640a:	79 b4                	jns    801063c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010640c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010640f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106414:	5b                   	pop    %ebx
80106415:	5e                   	pop    %esi
80106416:	5f                   	pop    %edi
80106417:	5d                   	pop    %ebp
80106418:	c3                   	ret    
80106419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106420:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106426:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106429:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106430:	00 00 00 00 
  return exec(path, argv);
80106434:	50                   	push   %eax
80106435:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010643b:	e8 b0 a7 ff ff       	call   80100bf0 <exec>
80106440:	83 c4 10             	add    $0x10,%esp
}
80106443:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106446:	5b                   	pop    %ebx
80106447:	5e                   	pop    %esi
80106448:	5f                   	pop    %edi
80106449:	5d                   	pop    %ebp
8010644a:	c3                   	ret    
8010644b:	90                   	nop
8010644c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106450 <sys_pipe>:

int
sys_pipe(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	57                   	push   %edi
80106454:	56                   	push   %esi
80106455:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106456:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106459:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010645c:	6a 08                	push   $0x8
8010645e:	50                   	push   %eax
8010645f:	6a 00                	push   $0x0
80106461:	e8 aa f3 ff ff       	call   80105810 <argptr>
80106466:	83 c4 10             	add    $0x10,%esp
80106469:	85 c0                	test   %eax,%eax
8010646b:	0f 88 ae 00 00 00    	js     8010651f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106471:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106474:	83 ec 08             	sub    $0x8,%esp
80106477:	50                   	push   %eax
80106478:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010647b:	50                   	push   %eax
8010647c:	e8 af d5 ff ff       	call   80103a30 <pipealloc>
80106481:	83 c4 10             	add    $0x10,%esp
80106484:	85 c0                	test   %eax,%eax
80106486:	0f 88 93 00 00 00    	js     8010651f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010648c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010648f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106491:	e8 ca db ff ff       	call   80104060 <myproc>
80106496:	eb 10                	jmp    801064a8 <sys_pipe+0x58>
80106498:	90                   	nop
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801064a0:	83 c3 01             	add    $0x1,%ebx
801064a3:	83 fb 10             	cmp    $0x10,%ebx
801064a6:	74 60                	je     80106508 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801064a8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801064ac:	85 f6                	test   %esi,%esi
801064ae:	75 f0                	jne    801064a0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801064b0:	8d 73 08             	lea    0x8(%ebx),%esi
801064b3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801064b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801064ba:	e8 a1 db ff ff       	call   80104060 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064bf:	31 d2                	xor    %edx,%edx
801064c1:	eb 0d                	jmp    801064d0 <sys_pipe+0x80>
801064c3:	90                   	nop
801064c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064c8:	83 c2 01             	add    $0x1,%edx
801064cb:	83 fa 10             	cmp    $0x10,%edx
801064ce:	74 28                	je     801064f8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801064d0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801064d4:	85 c9                	test   %ecx,%ecx
801064d6:	75 f0                	jne    801064c8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801064d8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801064dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064df:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801064e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064e4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801064e7:	31 c0                	xor    %eax,%eax
}
801064e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064ec:	5b                   	pop    %ebx
801064ed:	5e                   	pop    %esi
801064ee:	5f                   	pop    %edi
801064ef:	5d                   	pop    %ebp
801064f0:	c3                   	ret    
801064f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801064f8:	e8 63 db ff ff       	call   80104060 <myproc>
801064fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106504:	00 
80106505:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106508:	83 ec 0c             	sub    $0xc,%esp
8010650b:	ff 75 e0             	pushl  -0x20(%ebp)
8010650e:	e8 0d ac ff ff       	call   80101120 <fileclose>
    fileclose(wf);
80106513:	58                   	pop    %eax
80106514:	ff 75 e4             	pushl  -0x1c(%ebp)
80106517:	e8 04 ac ff ff       	call   80101120 <fileclose>
    return -1;
8010651c:	83 c4 10             	add    $0x10,%esp
8010651f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106524:	eb c3                	jmp    801064e9 <sys_pipe+0x99>
80106526:	66 90                	xchg   %ax,%ax
80106528:	66 90                	xchg   %ax,%ax
8010652a:	66 90                	xchg   %ax,%ax
8010652c:	66 90                	xchg   %ax,%ax
8010652e:	66 90                	xchg   %ax,%ax

80106530 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106533:	5d                   	pop    %ebp
  return fork();
80106534:	e9 d7 dc ff ff       	jmp    80104210 <fork>
80106539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106540 <sys_exit>:

int
sys_exit(void)
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	83 ec 08             	sub    $0x8,%esp
  exit();
80106546:	e8 85 e0 ff ff       	call   801045d0 <exit>
  return 0;  // not reached
}
8010654b:	31 c0                	xor    %eax,%eax
8010654d:	c9                   	leave  
8010654e:	c3                   	ret    
8010654f:	90                   	nop

80106550 <sys_wait>:

int
sys_wait(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106553:	5d                   	pop    %ebp
  return wait();
80106554:	e9 c7 e2 ff ff       	jmp    80104820 <wait>
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106560 <sys_kill>:

int
sys_kill(void)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106566:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106569:	50                   	push   %eax
8010656a:	6a 00                	push   $0x0
8010656c:	e8 4f f2 ff ff       	call   801057c0 <argint>
80106571:	83 c4 10             	add    $0x10,%esp
80106574:	85 c0                	test   %eax,%eax
80106576:	78 18                	js     80106590 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106578:	83 ec 0c             	sub    $0xc,%esp
8010657b:	ff 75 f4             	pushl  -0xc(%ebp)
8010657e:	e8 1d e4 ff ff       	call   801049a0 <kill>
80106583:	83 c4 10             	add    $0x10,%esp
}
80106586:	c9                   	leave  
80106587:	c3                   	ret    
80106588:	90                   	nop
80106589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106595:	c9                   	leave  
80106596:	c3                   	ret    
80106597:	89 f6                	mov    %esi,%esi
80106599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065a0 <sys_getNumFreePages>:

int sys_getNumFreePages(void){
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
  return getNumFreePages();
}
801065a3:	5d                   	pop    %ebp
  return getNumFreePages();
801065a4:	e9 17 c7 ff ff       	jmp    80102cc0 <getNumFreePages>
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065b0 <sys_getNumPhysPages>:


int sys_getNumPhysPages(void){
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
  return getNumPhysPages();
}
801065b3:	5d                   	pop    %ebp
  return getNumPhysPages();
801065b4:	e9 c7 e3 ff ff       	jmp    80104980 <getNumPhysPages>
801065b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065c0 <sys_getNumVirtPages>:

int sys_getNumVirtPages(void){
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
  return getNumVirtPages();
}
801065c3:	5d                   	pop    %ebp
  return getNumVirtPages();
801065c4:	e9 c7 e3 ff ff       	jmp    80104990 <getNumVirtPages>
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065d0 <sys_getpid>:

int
sys_getpid(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801065d6:	e8 85 da ff ff       	call   80104060 <myproc>
801065db:	8b 40 10             	mov    0x10(%eax),%eax
}
801065de:	c9                   	leave  
801065df:	c3                   	ret    

801065e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801065e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801065e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801065ea:	50                   	push   %eax
801065eb:	6a 00                	push   $0x0
801065ed:	e8 ce f1 ff ff       	call   801057c0 <argint>
801065f2:	83 c4 10             	add    $0x10,%esp
801065f5:	85 c0                	test   %eax,%eax
801065f7:	78 27                	js     80106620 <sys_sbrk+0x40>
    return -1;
  
  addr = myproc()->sz;
801065f9:	e8 62 da ff ff       	call   80104060 <myproc>
  if(growproc(n) < 0)
801065fe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106601:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106603:	ff 75 f4             	pushl  -0xc(%ebp)
80106606:	e8 75 db ff ff       	call   80104180 <growproc>
8010660b:	83 c4 10             	add    $0x10,%esp
8010660e:	85 c0                	test   %eax,%eax
80106610:	78 0e                	js     80106620 <sys_sbrk+0x40>
    return -1;

  return addr;
}
80106612:	89 d8                	mov    %ebx,%eax
80106614:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106617:	c9                   	leave  
80106618:	c3                   	ret    
80106619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106620:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106625:	eb eb                	jmp    80106612 <sys_sbrk+0x32>
80106627:	89 f6                	mov    %esi,%esi
80106629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106630 <sys_sleep>:

int
sys_sleep(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106634:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106637:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010663a:	50                   	push   %eax
8010663b:	6a 00                	push   $0x0
8010663d:	e8 7e f1 ff ff       	call   801057c0 <argint>
80106642:	83 c4 10             	add    $0x10,%esp
80106645:	85 c0                	test   %eax,%eax
80106647:	0f 88 8a 00 00 00    	js     801066d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010664d:	83 ec 0c             	sub    $0xc,%esp
80106650:	68 80 53 19 80       	push   $0x80195380
80106655:	e8 56 ed ff ff       	call   801053b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010665a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010665d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106660:	8b 1d c0 5b 19 80    	mov    0x80195bc0,%ebx
  while(ticks - ticks0 < n){
80106666:	85 d2                	test   %edx,%edx
80106668:	75 27                	jne    80106691 <sys_sleep+0x61>
8010666a:	eb 54                	jmp    801066c0 <sys_sleep+0x90>
8010666c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106670:	83 ec 08             	sub    $0x8,%esp
80106673:	68 80 53 19 80       	push   $0x80195380
80106678:	68 c0 5b 19 80       	push   $0x80195bc0
8010667d:	e8 de e0 ff ff       	call   80104760 <sleep>
  while(ticks - ticks0 < n){
80106682:	a1 c0 5b 19 80       	mov    0x80195bc0,%eax
80106687:	83 c4 10             	add    $0x10,%esp
8010668a:	29 d8                	sub    %ebx,%eax
8010668c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010668f:	73 2f                	jae    801066c0 <sys_sleep+0x90>
    if(myproc()->killed){
80106691:	e8 ca d9 ff ff       	call   80104060 <myproc>
80106696:	8b 40 24             	mov    0x24(%eax),%eax
80106699:	85 c0                	test   %eax,%eax
8010669b:	74 d3                	je     80106670 <sys_sleep+0x40>
      release(&tickslock);
8010669d:	83 ec 0c             	sub    $0xc,%esp
801066a0:	68 80 53 19 80       	push   $0x80195380
801066a5:	e8 c6 ed ff ff       	call   80105470 <release>
      return -1;
801066aa:	83 c4 10             	add    $0x10,%esp
801066ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801066b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066b5:	c9                   	leave  
801066b6:	c3                   	ret    
801066b7:	89 f6                	mov    %esi,%esi
801066b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801066c0:	83 ec 0c             	sub    $0xc,%esp
801066c3:	68 80 53 19 80       	push   $0x80195380
801066c8:	e8 a3 ed ff ff       	call   80105470 <release>
  return 0;
801066cd:	83 c4 10             	add    $0x10,%esp
801066d0:	31 c0                	xor    %eax,%eax
}
801066d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066d5:	c9                   	leave  
801066d6:	c3                   	ret    
    return -1;
801066d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066dc:	eb f4                	jmp    801066d2 <sys_sleep+0xa2>
801066de:	66 90                	xchg   %ax,%ax

801066e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	53                   	push   %ebx
801066e4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801066e7:	68 80 53 19 80       	push   $0x80195380
801066ec:	e8 bf ec ff ff       	call   801053b0 <acquire>
  xticks = ticks;
801066f1:	8b 1d c0 5b 19 80    	mov    0x80195bc0,%ebx
  release(&tickslock);
801066f7:	c7 04 24 80 53 19 80 	movl   $0x80195380,(%esp)
801066fe:	e8 6d ed ff ff       	call   80105470 <release>
  return xticks;
}
80106703:	89 d8                	mov    %ebx,%eax
80106705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106708:	c9                   	leave  
80106709:	c3                   	ret    

8010670a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010670a:	1e                   	push   %ds
  pushl %es
8010670b:	06                   	push   %es
  pushl %fs
8010670c:	0f a0                	push   %fs
  pushl %gs
8010670e:	0f a8                	push   %gs
  pushal
80106710:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106711:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106715:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106717:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106719:	54                   	push   %esp
  call trap
8010671a:	e8 51 02 00 00       	call   80106970 <trap>
  addl $4, %esp
8010671f:	83 c4 04             	add    $0x4,%esp

80106722 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106722:	61                   	popa   
  popl %gs
80106723:	0f a9                	pop    %gs
  popl %fs
80106725:	0f a1                	pop    %fs
  popl %es
80106727:	07                   	pop    %es
  popl %ds
80106728:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106729:	83 c4 08             	add    $0x8,%esp
  iret
8010672c:	cf                   	iret   
8010672d:	66 90                	xchg   %ax,%ax
8010672f:	90                   	nop

80106730 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106730:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106731:	31 c0                	xor    %eax,%eax
{
80106733:	89 e5                	mov    %esp,%ebp
80106735:	83 ec 08             	sub    $0x8,%esp
80106738:	90                   	nop
80106739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106740:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106747:	c7 04 c5 c2 53 19 80 	movl   $0x8e000008,-0x7fe6ac3e(,%eax,8)
8010674e:	08 00 00 8e 
80106752:	66 89 14 c5 c0 53 19 	mov    %dx,-0x7fe6ac40(,%eax,8)
80106759:	80 
8010675a:	c1 ea 10             	shr    $0x10,%edx
8010675d:	66 89 14 c5 c6 53 19 	mov    %dx,-0x7fe6ac3a(,%eax,8)
80106764:	80 
  for(i = 0; i < 256; i++)
80106765:	83 c0 01             	add    $0x1,%eax
80106768:	3d 00 01 00 00       	cmp    $0x100,%eax
8010676d:	75 d1                	jne    80106740 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010676f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106774:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106777:	c7 05 c2 55 19 80 08 	movl   $0xef000008,0x801955c2
8010677e:	00 00 ef 
  initlock(&tickslock, "time");
80106781:	68 59 90 10 80       	push   $0x80109059
80106786:	68 80 53 19 80       	push   $0x80195380
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010678b:	66 a3 c0 55 19 80    	mov    %ax,0x801955c0
80106791:	c1 e8 10             	shr    $0x10,%eax
80106794:	66 a3 c6 55 19 80    	mov    %ax,0x801955c6
  initlock(&tickslock, "time");
8010679a:	e8 d1 ea ff ff       	call   80105270 <initlock>
}
8010679f:	83 c4 10             	add    $0x10,%esp
801067a2:	c9                   	leave  
801067a3:	c3                   	ret    
801067a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801067b0 <idtinit>:

void
idtinit(void)
{
801067b0:	55                   	push   %ebp
  pd[0] = size-1;
801067b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801067b6:	89 e5                	mov    %esp,%ebp
801067b8:	83 ec 10             	sub    $0x10,%esp
801067bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801067bf:	b8 c0 53 19 80       	mov    $0x801953c0,%eax
801067c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801067c8:	c1 e8 10             	shr    $0x10,%eax
801067cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801067cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801067d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801067d5:	c9                   	leave  
801067d6:	c3                   	ret    
801067d7:	89 f6                	mov    %esi,%esi
801067d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067e0 <COW_helper>:

int COW_helper(uint va){
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
    return pagefault(va);
}
801067e3:	5d                   	pop    %ebp
    return pagefault(va);
801067e4:	e9 57 1d 00 00       	jmp    80108540 <pagefault>
801067e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067f0 <policies_helper>:

int policies_helper(uint va){
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	56                   	push   %esi
801067f5:	53                   	push   %ebx
801067f6:	83 ec 1c             	sub    $0x1c,%esp
    struct proc* curproc = myproc();
801067f9:	e8 62 d8 ff ff       	call   80104060 <myproc>
801067fe:	89 c7                	mov    %eax,%edi
80106800:	8d 80 90 00 00 00    	lea    0x90(%eax),%eax
    uint my_page = PGROUNDDOWN(va);
    int counter = 0;
80106806:	31 c9                	xor    %ecx,%ecx
80106808:	8d 97 90 03 00 00    	lea    0x390(%edi),%edx
8010680e:	66 90                	xchg   %ax,%ax
    int i;
      for(i = 0; i < MAX_TOTAL_PAGES; i++){
        if((curproc->pages[i].allocated == 1) && (curproc->pages[i].in_RAM) )
80106810:	83 38 01             	cmpl   $0x1,(%eax)
80106813:	75 07                	jne    8010681c <policies_helper+0x2c>
          counter++;
80106815:	83 78 04 01          	cmpl   $0x1,0x4(%eax)
80106819:	83 d9 ff             	sbb    $0xffffffff,%ecx
8010681c:	83 c0 18             	add    $0x18,%eax
      for(i = 0; i < MAX_TOTAL_PAGES; i++){
8010681f:	39 c2                	cmp    %eax,%edx
80106821:	75 ed                	jne    80106810 <policies_helper+0x20>
      }
    if(counter == MAX_PYSC_PAGES)
80106823:	83 f9 10             	cmp    $0x10,%ecx
80106826:	0f 84 2c 01 00 00    	je     80106958 <policies_helper+0x168>
      swap_out(curproc->pgdir);

    char* new_page_addr = kalloc();
8010682c:	e8 0f c3 ff ff       	call   80102b40 <kalloc>
    if(new_page_addr == 0){  //meaning kalloc has failed!
80106831:	85 c0                	test   %eax,%eax
80106833:	0f 84 f8 00 00 00    	je     80106931 <policies_helper+0x141>
      /**  no need to call dealloc because no allocation happend **/
      cprintf("in trap: kalloc failed!\n");    
      return 0;//indicating something failed
    }
    memset(new_page_addr, 0, PGSIZE);
80106839:	83 ec 04             	sub    $0x4,%esp
    uint my_page = PGROUNDDOWN(va);
8010683c:	8b 75 08             	mov    0x8(%ebp),%esi
    memset(new_page_addr, 0, PGSIZE);
8010683f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106842:	68 00 10 00 00       	push   $0x1000
80106847:	6a 00                	push   $0x0
    i=0;
80106849:	31 db                	xor    %ebx,%ebx
    memset(new_page_addr, 0, PGSIZE);
8010684b:	50                   	push   %eax
    uint my_page = PGROUNDDOWN(va);
8010684c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memset(new_page_addr, 0, PGSIZE);
80106852:	e8 69 ec ff ff       	call   801054c0 <memset>
80106857:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
8010685d:	83 c4 10             	add    $0x10,%esp
80106860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106863:	eb 12                	jmp    80106877 <policies_helper+0x87>
80106865:	8d 76 00             	lea    0x0(%esi),%esi
    while((i<MAX_TOTAL_PAGES) && (curproc->pages[i].virtual_addr != my_page))
      i++;
80106868:	83 c3 01             	add    $0x1,%ebx
8010686b:	83 c0 18             	add    $0x18,%eax
    while((i<MAX_TOTAL_PAGES) && (curproc->pages[i].virtual_addr != my_page))
8010686e:	83 fb 20             	cmp    $0x20,%ebx
80106871:	0f 84 d4 00 00 00    	je     8010694b <policies_helper+0x15b>
80106877:	39 30                	cmp    %esi,(%eax)
80106879:	75 ed                	jne    80106868 <policies_helper+0x78>
    if(i==MAX_TOTAL_PAGES){//we reached the end
      panic("in trap: couldn't find the page");
      return 0;
    }
    
    uint offset = curproc->pages[i].offset_in_swapfile;
8010687b:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
    /** 'populate' the page starting at new_page with everything related from the swap file **/
    readFromSwapFile(curproc, new_page_addr, offset, PGSIZE);
8010687e:	68 00 10 00 00       	push   $0x1000
80106883:	89 55 dc             	mov    %edx,-0x24(%ebp)
    uint offset = curproc->pages[i].offset_in_swapfile;
80106886:	8d 04 c7             	lea    (%edi,%eax,8),%eax
    readFromSwapFile(curproc, new_page_addr, offset, PGSIZE);
80106889:	ff b0 84 00 00 00    	pushl  0x84(%eax)
8010688f:	52                   	push   %edx
80106890:	57                   	push   %edi
80106891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106894:	e8 c7 bc ff ff       	call   80102560 <readFromSwapFile>
    pte_t *pte = (pte_t*)global_walkpgdir(curproc->pgdir,(char *) va,  0);
80106899:	83 c4 0c             	add    $0xc,%esp
8010689c:	6a 00                	push   $0x0
8010689e:	ff 75 08             	pushl  0x8(%ebp)
801068a1:	ff 77 04             	pushl  0x4(%edi)
801068a4:	e8 c7 1e 00 00       	call   80108770 <global_walkpgdir>
    *pte = TURN_OFF_PTE_P(*pte);
801068a9:	8b 10                	mov    (%eax),%edx
    pte_t *pte = (pte_t*)global_walkpgdir(curproc->pgdir,(char *) va,  0);
801068ab:	89 c1                	mov    %eax,%ecx
    *pte = TURN_ON_PTE_PG(*pte);
801068ad:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    *pte = TURN_OFF_PTE_P(*pte);
801068b0:	83 e2 fe             	and    $0xfffffffe,%edx
801068b3:	89 d0                	mov    %edx,%eax
    global_mappages(curproc->pgdir, (void *) my_page, PGSIZE, V2P(new_page_addr), PTE_W | PTE_U );
801068b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
    *pte = TURN_ON_PTE_PG(*pte);
801068b8:	80 cc 02             	or     $0x2,%ah
801068bb:	89 01                	mov    %eax,(%ecx)
    global_mappages(curproc->pgdir, (void *) my_page, PGSIZE, V2P(new_page_addr), PTE_W | PTE_U );
801068bd:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801068c4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801068ca:	52                   	push   %edx
801068cb:	68 00 10 00 00       	push   $0x1000
801068d0:	56                   	push   %esi
801068d1:	ff 77 04             	pushl  0x4(%edi)
801068d4:	e8 b7 1e 00 00       	call   80108790 <global_mappages>

    *pte = TURN_ON_PTE_P(*pte);
    *pte = TURN_OFF_PTE_PG(*pte);
801068d9:	8b 4d e0             	mov    -0x20(%ebp),%ecx

    curproc->pages[i].in_RAM = 1;
801068dc:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);
801068df:	83 c4 14             	add    $0x14,%esp
    *pte = TURN_OFF_PTE_PG(*pte);
801068e2:	8b 11                	mov    (%ecx),%edx
801068e4:	80 e6 fd             	and    $0xfd,%dh
801068e7:	89 d0                	mov    %edx,%eax
801068e9:	83 c8 01             	or     $0x1,%eax
801068ec:	89 01                	mov    %eax,(%ecx)
    curproc->pages[i].in_RAM = 1;
801068ee:	c7 86 94 00 00 00 01 	movl   $0x1,0x94(%esi)
801068f5:	00 00 00 
    insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);
801068f8:	ff b6 84 00 00 00    	pushl  0x84(%esi)
801068fe:	e8 6d e2 ff ff       	call   80104b70 <insert_to_offsets_queue>
    curproc->pages[i].offset_in_swapfile = -1;
80106903:	c7 86 84 00 00 00 ff 	movl   $0xffffffff,0x84(%esi)
8010690a:	ff ff ff 
    
    insert_to_RAM_queue(i);
8010690d:	89 1c 24             	mov    %ebx,(%esp)
80106910:	e8 0b e2 ff ff       	call   80104b20 <insert_to_RAM_queue>
    /**  REMOVED a page from the swap file, decrement the number of pages in the file ! **/
    curproc->swapped_pages_now--;
80106915:	83 af 0c 04 00 00 01 	subl   $0x1,0x40c(%edi)
    
    lapiceoi();
8010691c:	e8 1f c6 ff ff       	call   80102f40 <lapiceoi>
    return 1; // PGFLT case break- success
80106921:	83 c4 10             	add    $0x10,%esp
}
80106924:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 1; // PGFLT case break- success
80106927:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010692c:	5b                   	pop    %ebx
8010692d:	5e                   	pop    %esi
8010692e:	5f                   	pop    %edi
8010692f:	5d                   	pop    %ebp
80106930:	c3                   	ret    
      cprintf("in trap: kalloc failed!\n");    
80106931:	83 ec 0c             	sub    $0xc,%esp
80106934:	68 5e 90 10 80       	push   $0x8010905e
80106939:	e8 22 9d ff ff       	call   80100660 <cprintf>
      return 0;//indicating something failed
8010693e:	83 c4 10             	add    $0x10,%esp
}
80106941:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;//indicating something failed
80106944:	31 c0                	xor    %eax,%eax
}
80106946:	5b                   	pop    %ebx
80106947:	5e                   	pop    %esi
80106948:	5f                   	pop    %edi
80106949:	5d                   	pop    %ebp
8010694a:	c3                   	ret    
      panic("in trap: couldn't find the page");
8010694b:	83 ec 0c             	sub    $0xc,%esp
8010694e:	68 7c 90 10 80       	push   $0x8010907c
80106953:	e8 38 9a ff ff       	call   80100390 <panic>
      swap_out(curproc->pgdir);
80106958:	83 ec 0c             	sub    $0xc,%esp
8010695b:	ff 77 04             	pushl  0x4(%edi)
8010695e:	e8 7d 18 00 00       	call   801081e0 <swap_out>
80106963:	83 c4 10             	add    $0x10,%esp
80106966:	e9 c1 fe ff ff       	jmp    8010682c <policies_helper+0x3c>
8010696b:	90                   	nop
8010696c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106970 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	57                   	push   %edi
80106974:	56                   	push   %esi
80106975:	53                   	push   %ebx
80106976:	83 ec 1c             	sub    $0x1c,%esp
80106979:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc* curproc = myproc();
8010697c:	e8 df d6 ff ff       	call   80104060 <myproc>
80106981:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
80106983:	8b 47 30             	mov    0x30(%edi),%eax
80106986:	83 f8 40             	cmp    $0x40,%eax
80106989:	0f 84 e9 00 00 00    	je     80106a78 <trap+0x108>
      exit();
    return;
  }


  switch(tf->trapno){
8010698f:	83 e8 0e             	sub    $0xe,%eax
80106992:	83 f8 31             	cmp    $0x31,%eax
80106995:	77 09                	ja     801069a0 <trap+0x30>
80106997:	ff 24 85 38 91 10 80 	jmp    *-0x7fef6ec8(,%eax,4)
8010699e:	66 90                	xchg   %ax,%ax
      break; // PGFLT case break
  #endif

//PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801069a0:	e8 bb d6 ff ff       	call   80104060 <myproc>
801069a5:	85 c0                	test   %eax,%eax
801069a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801069aa:	0f 84 59 03 00 00    	je     80106d09 <trap+0x399>
801069b0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801069b4:	0f 84 4f 03 00 00    	je     80106d09 <trap+0x399>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801069ba:	0f 20 d1             	mov    %cr2,%ecx
801069bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069c0:	e8 7b d6 ff ff       	call   80104040 <cpuid>
801069c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069c8:	8b 47 34             	mov    0x34(%edi),%eax
801069cb:	8b 77 30             	mov    0x30(%edi),%esi
801069ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801069d1:	e8 8a d6 ff ff       	call   80104060 <myproc>
801069d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801069d9:	e8 82 d6 ff ff       	call   80104060 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801069e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801069e4:	51                   	push   %ecx
801069e5:	53                   	push   %ebx
801069e6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801069e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801069ed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801069ee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069f1:	52                   	push   %edx
801069f2:	ff 70 10             	pushl  0x10(%eax)
801069f5:	68 f4 90 10 80       	push   $0x801090f4
801069fa:	e8 61 9c ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801069ff:	83 c4 20             	add    $0x20,%esp
80106a02:	e8 59 d6 ff ff       	call   80104060 <myproc>
80106a07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106a0e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a10:	e8 4b d6 ff ff       	call   80104060 <myproc>
80106a15:	85 c0                	test   %eax,%eax
80106a17:	74 1d                	je     80106a36 <trap+0xc6>
80106a19:	e8 42 d6 ff ff       	call   80104060 <myproc>
80106a1e:	8b 50 24             	mov    0x24(%eax),%edx
80106a21:	85 d2                	test   %edx,%edx
80106a23:	74 11                	je     80106a36 <trap+0xc6>
80106a25:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106a29:	83 e0 03             	and    $0x3,%eax
80106a2c:	66 83 f8 03          	cmp    $0x3,%ax
80106a30:	0f 84 5a 02 00 00    	je     80106c90 <trap+0x320>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106a36:	e8 25 d6 ff ff       	call   80104060 <myproc>
80106a3b:	85 c0                	test   %eax,%eax
80106a3d:	74 0b                	je     80106a4a <trap+0xda>
80106a3f:	e8 1c d6 ff ff       	call   80104060 <myproc>
80106a44:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106a48:	74 5e                	je     80106aa8 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a4a:	e8 11 d6 ff ff       	call   80104060 <myproc>
80106a4f:	85 c0                	test   %eax,%eax
80106a51:	74 19                	je     80106a6c <trap+0xfc>
80106a53:	e8 08 d6 ff ff       	call   80104060 <myproc>
80106a58:	8b 40 24             	mov    0x24(%eax),%eax
80106a5b:	85 c0                	test   %eax,%eax
80106a5d:	74 0d                	je     80106a6c <trap+0xfc>
80106a5f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106a63:	83 e0 03             	and    $0x3,%eax
80106a66:	66 83 f8 03          	cmp    $0x3,%ax
80106a6a:	74 2b                	je     80106a97 <trap+0x127>
    exit();
}
80106a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a6f:	5b                   	pop    %ebx
80106a70:	5e                   	pop    %esi
80106a71:	5f                   	pop    %edi
80106a72:	5d                   	pop    %ebp
80106a73:	c3                   	ret    
80106a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
80106a78:	8b 73 24             	mov    0x24(%ebx),%esi
80106a7b:	85 f6                	test   %esi,%esi
80106a7d:	0f 85 fd 01 00 00    	jne    80106c80 <trap+0x310>
    myproc()->tf = tf;
80106a83:	e8 d8 d5 ff ff       	call   80104060 <myproc>
80106a88:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106a8b:	e8 20 ee ff ff       	call   801058b0 <syscall>
    if(curproc->killed)
80106a90:	8b 4b 24             	mov    0x24(%ebx),%ecx
80106a93:	85 c9                	test   %ecx,%ecx
80106a95:	74 d5                	je     80106a6c <trap+0xfc>
}
80106a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a9a:	5b                   	pop    %ebx
80106a9b:	5e                   	pop    %esi
80106a9c:	5f                   	pop    %edi
80106a9d:	5d                   	pop    %ebp
      exit();
80106a9e:	e9 2d db ff ff       	jmp    801045d0 <exit>
80106aa3:	90                   	nop
80106aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106aa8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106aac:	75 9c                	jne    80106a4a <trap+0xda>
    yield();
80106aae:	e8 5d dc ff ff       	call   80104710 <yield>
80106ab3:	eb 95                	jmp    80106a4a <trap+0xda>
80106ab5:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->page_faults_now++;
80106ab8:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
80106abf:	0f 20 d0             	mov    %cr2,%eax
80106ac2:	89 45 dc             	mov    %eax,-0x24(%ebp)
      uint my_page = PGROUNDDOWN(va);
80106ac5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aca:	8d 93 90 03 00 00    	lea    0x390(%ebx),%edx
80106ad0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ad3:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
      int counter = 0;
80106ad9:	31 c9                	xor    %ecx,%ecx
80106adb:	90                   	nop
80106adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if((curproc->pages[i].allocated == 1) && (curproc->pages[i].in_RAM))
80106ae0:	83 38 01             	cmpl   $0x1,(%eax)
80106ae3:	75 07                	jne    80106aec <trap+0x17c>
          counter++;
80106ae5:	83 78 04 01          	cmpl   $0x1,0x4(%eax)
80106ae9:	83 d9 ff             	sbb    $0xffffffff,%ecx
80106aec:	83 c0 18             	add    $0x18,%eax
      for(i = 0; i < MAX_TOTAL_PAGES; i++){
80106aef:	39 c2                	cmp    %eax,%edx
80106af1:	75 ed                	jne    80106ae0 <trap+0x170>
      if(counter == MAX_PYSC_PAGES)
80106af3:	83 f9 10             	cmp    $0x10,%ecx
80106af6:	0f 84 e5 01 00 00    	je     80106ce1 <trap+0x371>
      char* new_page_addr = kalloc();
80106afc:	e8 3f c0 ff ff       	call   80102b40 <kalloc>
      if(new_page_addr == 0){  //meaning kalloc has failed!
80106b01:	85 c0                	test   %eax,%eax
      char* new_page_addr = kalloc();
80106b03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(new_page_addr == 0){  //meaning kalloc has failed!
80106b06:	0f 84 e8 01 00 00    	je     80106cf4 <trap+0x384>
      memset(new_page_addr, 0, PGSIZE);
80106b0c:	83 ec 04             	sub    $0x4,%esp
      i=0;
80106b0f:	31 f6                	xor    %esi,%esi
      memset(new_page_addr, 0, PGSIZE);
80106b11:	68 00 10 00 00       	push   $0x1000
80106b16:	6a 00                	push   $0x0
80106b18:	ff 75 e4             	pushl  -0x1c(%ebp)
80106b1b:	e8 a0 e9 ff ff       	call   801054c0 <memset>
80106b20:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80106b26:	83 c4 10             	add    $0x10,%esp
80106b29:	8b 55 e0             	mov    -0x20(%ebp),%edx
80106b2c:	eb 11                	jmp    80106b3f <trap+0x1cf>
80106b2e:	66 90                	xchg   %ax,%ax
        i++;
80106b30:	83 c6 01             	add    $0x1,%esi
80106b33:	83 c0 18             	add    $0x18,%eax
      while((i<MAX_TOTAL_PAGES) && (curproc->pages[i].virtual_addr != my_page))
80106b36:	83 fe 20             	cmp    $0x20,%esi
80106b39:	0f 84 95 01 00 00    	je     80106cd4 <trap+0x364>
80106b3f:	39 10                	cmp    %edx,(%eax)
80106b41:	75 ed                	jne    80106b30 <trap+0x1c0>
      uint offset = curproc->pages[i].offset_in_swapfile;
80106b43:	8d 04 76             	lea    (%esi,%esi,2),%eax
      readFromSwapFile(curproc, new_page_addr, offset, PGSIZE);
80106b46:	68 00 10 00 00       	push   $0x1000
      uint offset = curproc->pages[i].offset_in_swapfile;
80106b4b:	8d 0c c3             	lea    (%ebx,%eax,8),%ecx
      readFromSwapFile(curproc, new_page_addr, offset, PGSIZE);
80106b4e:	ff b1 84 00 00 00    	pushl  0x84(%ecx)
80106b54:	ff 75 e4             	pushl  -0x1c(%ebp)
80106b57:	53                   	push   %ebx
80106b58:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106b5b:	e8 00 ba ff ff       	call   80102560 <readFromSwapFile>
      pte_t *pte = (pte_t*)global_walkpgdir(curproc->pgdir,(char *) va,  0);
80106b60:	83 c4 0c             	add    $0xc,%esp
80106b63:	6a 00                	push   $0x0
80106b65:	ff 75 dc             	pushl  -0x24(%ebp)
80106b68:	ff 73 04             	pushl  0x4(%ebx)
80106b6b:	e8 00 1c 00 00       	call   80108770 <global_walkpgdir>
80106b70:	89 c2                	mov    %eax,%edx
      *pte = TURN_OFF_PTE_P(*pte);
80106b72:	8b 00                	mov    (%eax),%eax
      *pte = TURN_ON_PTE_PG(*pte);
80106b74:	89 55 dc             	mov    %edx,-0x24(%ebp)
      *pte = TURN_OFF_PTE_P(*pte);
80106b77:	83 e0 fe             	and    $0xfffffffe,%eax
      *pte = TURN_ON_PTE_PG(*pte);
80106b7a:	80 cc 02             	or     $0x2,%ah
80106b7d:	89 02                	mov    %eax,(%edx)
      global_mappages(curproc->pgdir, (void *) my_page, PGSIZE, V2P(new_page_addr), PTE_W | PTE_U );
80106b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b82:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106b89:	05 00 00 00 80       	add    $0x80000000,%eax
80106b8e:	50                   	push   %eax
80106b8f:	68 00 10 00 00       	push   $0x1000
80106b94:	ff 75 e0             	pushl  -0x20(%ebp)
80106b97:	ff 73 04             	pushl  0x4(%ebx)
80106b9a:	e8 f1 1b 00 00       	call   80108790 <global_mappages>
      *pte = TURN_OFF_PTE_PG(*pte);
80106b9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
      curproc->pages[i].in_RAM = 1;
80106ba2:	8b 4d d8             	mov    -0x28(%ebp),%ecx
      insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);
80106ba5:	83 c4 14             	add    $0x14,%esp
      *pte = TURN_OFF_PTE_PG(*pte);
80106ba8:	8b 02                	mov    (%edx),%eax
      insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);
80106baa:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      *pte = TURN_OFF_PTE_PG(*pte);
80106bad:	80 e4 fd             	and    $0xfd,%ah
80106bb0:	83 c8 01             	or     $0x1,%eax
80106bb3:	89 02                	mov    %eax,(%edx)
      curproc->pages[i].in_RAM = 1;
80106bb5:	c7 81 94 00 00 00 01 	movl   $0x1,0x94(%ecx)
80106bbc:	00 00 00 
      insert_to_offsets_queue(curproc->pages[i].offset_in_swapfile);
80106bbf:	ff b1 84 00 00 00    	pushl  0x84(%ecx)
80106bc5:	e8 a6 df ff ff       	call   80104b70 <insert_to_offsets_queue>
      curproc->pages[i].offset_in_swapfile = -1;
80106bca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106bcd:	c7 81 84 00 00 00 ff 	movl   $0xffffffff,0x84(%ecx)
80106bd4:	ff ff ff 
      insert_to_RAM_queue(i);
80106bd7:	89 34 24             	mov    %esi,(%esp)
80106bda:	e8 41 df ff ff       	call   80104b20 <insert_to_RAM_queue>
      curproc->swapped_pages_now--;
80106bdf:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
      lapiceoi();
80106be6:	e8 55 c3 ff ff       	call   80102f40 <lapiceoi>
      break; // PGFLT case break
80106beb:	83 c4 10             	add    $0x10,%esp
80106bee:	e9 1d fe ff ff       	jmp    80106a10 <trap+0xa0>
80106bf3:	90                   	nop
80106bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106bf8:	e8 43 d4 ff ff       	call   80104040 <cpuid>
80106bfd:	85 c0                	test   %eax,%eax
80106bff:	0f 84 9b 00 00 00    	je     80106ca0 <trap+0x330>
    lapiceoi();
80106c05:	e8 36 c3 ff ff       	call   80102f40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c0a:	e8 51 d4 ff ff       	call   80104060 <myproc>
80106c0f:	85 c0                	test   %eax,%eax
80106c11:	0f 85 02 fe ff ff    	jne    80106a19 <trap+0xa9>
80106c17:	e9 1a fe ff ff       	jmp    80106a36 <trap+0xc6>
80106c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106c20:	e8 db c1 ff ff       	call   80102e00 <kbdintr>
    lapiceoi();
80106c25:	e8 16 c3 ff ff       	call   80102f40 <lapiceoi>
    break;
80106c2a:	e9 e1 fd ff ff       	jmp    80106a10 <trap+0xa0>
80106c2f:	90                   	nop
    uartintr();
80106c30:	e8 7b 02 00 00       	call   80106eb0 <uartintr>
    lapiceoi();
80106c35:	e8 06 c3 ff ff       	call   80102f40 <lapiceoi>
    break;
80106c3a:	e9 d1 fd ff ff       	jmp    80106a10 <trap+0xa0>
80106c3f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106c40:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106c44:	8b 77 38             	mov    0x38(%edi),%esi
80106c47:	e8 f4 d3 ff ff       	call   80104040 <cpuid>
80106c4c:	56                   	push   %esi
80106c4d:	53                   	push   %ebx
80106c4e:	50                   	push   %eax
80106c4f:	68 9c 90 10 80       	push   $0x8010909c
80106c54:	e8 07 9a ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106c59:	e8 e2 c2 ff ff       	call   80102f40 <lapiceoi>
    break;
80106c5e:	83 c4 10             	add    $0x10,%esp
80106c61:	e9 aa fd ff ff       	jmp    80106a10 <trap+0xa0>
80106c66:	8d 76 00             	lea    0x0(%esi),%esi
80106c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106c70:	e8 7b ba ff ff       	call   801026f0 <ideintr>
80106c75:	eb 8e                	jmp    80106c05 <trap+0x295>
80106c77:	89 f6                	mov    %esi,%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106c80:	e8 4b d9 ff ff       	call   801045d0 <exit>
80106c85:	e9 f9 fd ff ff       	jmp    80106a83 <trap+0x113>
80106c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106c90:	e8 3b d9 ff ff       	call   801045d0 <exit>
80106c95:	e9 9c fd ff ff       	jmp    80106a36 <trap+0xc6>
80106c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106ca0:	83 ec 0c             	sub    $0xc,%esp
80106ca3:	68 80 53 19 80       	push   $0x80195380
80106ca8:	e8 03 e7 ff ff       	call   801053b0 <acquire>
      wakeup(&ticks);
80106cad:	c7 04 24 c0 5b 19 80 	movl   $0x80195bc0,(%esp)
      ticks++;
80106cb4:	83 05 c0 5b 19 80 01 	addl   $0x1,0x80195bc0
      wakeup(&ticks);
80106cbb:	e8 60 dc ff ff       	call   80104920 <wakeup>
      release(&tickslock);
80106cc0:	c7 04 24 80 53 19 80 	movl   $0x80195380,(%esp)
80106cc7:	e8 a4 e7 ff ff       	call   80105470 <release>
80106ccc:	83 c4 10             	add    $0x10,%esp
80106ccf:	e9 31 ff ff ff       	jmp    80106c05 <trap+0x295>
        panic("in trap: couldn't find the page");
80106cd4:	83 ec 0c             	sub    $0xc,%esp
80106cd7:	68 7c 90 10 80       	push   $0x8010907c
80106cdc:	e8 af 96 ff ff       	call   80100390 <panic>
        swap_out(curproc->pgdir);
80106ce1:	83 ec 0c             	sub    $0xc,%esp
80106ce4:	ff 73 04             	pushl  0x4(%ebx)
80106ce7:	e8 f4 14 00 00       	call   801081e0 <swap_out>
80106cec:	83 c4 10             	add    $0x10,%esp
80106cef:	e9 08 fe ff ff       	jmp    80106afc <trap+0x18c>
        cprintf("in trap: kalloc failed!\n");   
80106cf4:	83 ec 0c             	sub    $0xc,%esp
80106cf7:	68 5e 90 10 80       	push   $0x8010905e
80106cfc:	e8 5f 99 ff ff       	call   80100660 <cprintf>
80106d01:	83 c4 10             	add    $0x10,%esp
80106d04:	e9 03 fe ff ff       	jmp    80106b0c <trap+0x19c>
80106d09:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106d0c:	e8 2f d3 ff ff       	call   80104040 <cpuid>
80106d11:	83 ec 0c             	sub    $0xc,%esp
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	50                   	push   %eax
80106d17:	ff 77 30             	pushl  0x30(%edi)
80106d1a:	68 c0 90 10 80       	push   $0x801090c0
80106d1f:	e8 3c 99 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106d24:	83 c4 14             	add    $0x14,%esp
80106d27:	68 77 90 10 80       	push   $0x80109077
80106d2c:	e8 5f 96 ff ff       	call   80100390 <panic>
80106d31:	66 90                	xchg   %ax,%ax
80106d33:	66 90                	xchg   %ax,%ax
80106d35:	66 90                	xchg   %ax,%ax
80106d37:	66 90                	xchg   %ax,%ax
80106d39:	66 90                	xchg   %ax,%ax
80106d3b:	66 90                	xchg   %ax,%ax
80106d3d:	66 90                	xchg   %ax,%ax
80106d3f:	90                   	nop

80106d40 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106d40:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
{
80106d45:	55                   	push   %ebp
80106d46:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106d48:	85 c0                	test   %eax,%eax
80106d4a:	74 1c                	je     80106d68 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d4c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106d51:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106d52:	a8 01                	test   $0x1,%al
80106d54:	74 12                	je     80106d68 <uartgetc+0x28>
80106d56:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d5b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106d5c:	0f b6 c0             	movzbl %al,%eax
}
80106d5f:	5d                   	pop    %ebp
80106d60:	c3                   	ret    
80106d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106d68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d6d:	5d                   	pop    %ebp
80106d6e:	c3                   	ret    
80106d6f:	90                   	nop

80106d70 <uartputc.part.0>:
uartputc(int c)
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	89 c7                	mov    %eax,%edi
80106d78:	bb 80 00 00 00       	mov    $0x80,%ebx
80106d7d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106d82:	83 ec 0c             	sub    $0xc,%esp
80106d85:	eb 1b                	jmp    80106da2 <uartputc.part.0+0x32>
80106d87:	89 f6                	mov    %esi,%esi
80106d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106d90:	83 ec 0c             	sub    $0xc,%esp
80106d93:	6a 0a                	push   $0xa
80106d95:	e8 c6 c1 ff ff       	call   80102f60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106d9a:	83 c4 10             	add    $0x10,%esp
80106d9d:	83 eb 01             	sub    $0x1,%ebx
80106da0:	74 07                	je     80106da9 <uartputc.part.0+0x39>
80106da2:	89 f2                	mov    %esi,%edx
80106da4:	ec                   	in     (%dx),%al
80106da5:	a8 20                	test   $0x20,%al
80106da7:	74 e7                	je     80106d90 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106da9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106dae:	89 f8                	mov    %edi,%eax
80106db0:	ee                   	out    %al,(%dx)
}
80106db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db4:	5b                   	pop    %ebx
80106db5:	5e                   	pop    %esi
80106db6:	5f                   	pop    %edi
80106db7:	5d                   	pop    %ebp
80106db8:	c3                   	ret    
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dc0 <uartinit>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	31 c9                	xor    %ecx,%ecx
80106dc3:	89 c8                	mov    %ecx,%eax
80106dc5:	89 e5                	mov    %esp,%ebp
80106dc7:	57                   	push   %edi
80106dc8:	56                   	push   %esi
80106dc9:	53                   	push   %ebx
80106dca:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106dcf:	89 da                	mov    %ebx,%edx
80106dd1:	83 ec 0c             	sub    $0xc,%esp
80106dd4:	ee                   	out    %al,(%dx)
80106dd5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106dda:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106ddf:	89 fa                	mov    %edi,%edx
80106de1:	ee                   	out    %al,(%dx)
80106de2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106de7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106dec:	ee                   	out    %al,(%dx)
80106ded:	be f9 03 00 00       	mov    $0x3f9,%esi
80106df2:	89 c8                	mov    %ecx,%eax
80106df4:	89 f2                	mov    %esi,%edx
80106df6:	ee                   	out    %al,(%dx)
80106df7:	b8 03 00 00 00       	mov    $0x3,%eax
80106dfc:	89 fa                	mov    %edi,%edx
80106dfe:	ee                   	out    %al,(%dx)
80106dff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106e04:	89 c8                	mov    %ecx,%eax
80106e06:	ee                   	out    %al,(%dx)
80106e07:	b8 01 00 00 00       	mov    $0x1,%eax
80106e0c:	89 f2                	mov    %esi,%edx
80106e0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e0f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e14:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106e15:	3c ff                	cmp    $0xff,%al
80106e17:	74 5a                	je     80106e73 <uartinit+0xb3>
  uart = 1;
80106e19:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
80106e20:	00 00 00 
80106e23:	89 da                	mov    %ebx,%edx
80106e25:	ec                   	in     (%dx),%al
80106e26:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e2b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106e2c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106e2f:	bb 00 92 10 80       	mov    $0x80109200,%ebx
  ioapicenable(IRQ_COM1, 0);
80106e34:	6a 00                	push   $0x0
80106e36:	6a 04                	push   $0x4
80106e38:	e8 03 bb ff ff       	call   80102940 <ioapicenable>
80106e3d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106e40:	b8 78 00 00 00       	mov    $0x78,%eax
80106e45:	eb 13                	jmp    80106e5a <uartinit+0x9a>
80106e47:	89 f6                	mov    %esi,%esi
80106e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e50:	83 c3 01             	add    $0x1,%ebx
80106e53:	0f be 03             	movsbl (%ebx),%eax
80106e56:	84 c0                	test   %al,%al
80106e58:	74 19                	je     80106e73 <uartinit+0xb3>
  if(!uart)
80106e5a:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
80106e60:	85 d2                	test   %edx,%edx
80106e62:	74 ec                	je     80106e50 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106e64:	83 c3 01             	add    $0x1,%ebx
80106e67:	e8 04 ff ff ff       	call   80106d70 <uartputc.part.0>
80106e6c:	0f be 03             	movsbl (%ebx),%eax
80106e6f:	84 c0                	test   %al,%al
80106e71:	75 e7                	jne    80106e5a <uartinit+0x9a>
}
80106e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e76:	5b                   	pop    %ebx
80106e77:	5e                   	pop    %esi
80106e78:	5f                   	pop    %edi
80106e79:	5d                   	pop    %ebp
80106e7a:	c3                   	ret    
80106e7b:	90                   	nop
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <uartputc>:
  if(!uart)
80106e80:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
80106e86:	55                   	push   %ebp
80106e87:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106e89:	85 d2                	test   %edx,%edx
{
80106e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106e8e:	74 10                	je     80106ea0 <uartputc+0x20>
}
80106e90:	5d                   	pop    %ebp
80106e91:	e9 da fe ff ff       	jmp    80106d70 <uartputc.part.0>
80106e96:	8d 76 00             	lea    0x0(%esi),%esi
80106e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106ea0:	5d                   	pop    %ebp
80106ea1:	c3                   	ret    
80106ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106eb0 <uartintr>:

void
uartintr(void)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106eb6:	68 40 6d 10 80       	push   $0x80106d40
80106ebb:	e8 50 99 ff ff       	call   80100810 <consoleintr>
}
80106ec0:	83 c4 10             	add    $0x10,%esp
80106ec3:	c9                   	leave  
80106ec4:	c3                   	ret    

80106ec5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ec5:	6a 00                	push   $0x0
  pushl $0
80106ec7:	6a 00                	push   $0x0
  jmp alltraps
80106ec9:	e9 3c f8 ff ff       	jmp    8010670a <alltraps>

80106ece <vector1>:
.globl vector1
vector1:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $1
80106ed0:	6a 01                	push   $0x1
  jmp alltraps
80106ed2:	e9 33 f8 ff ff       	jmp    8010670a <alltraps>

80106ed7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $2
80106ed9:	6a 02                	push   $0x2
  jmp alltraps
80106edb:	e9 2a f8 ff ff       	jmp    8010670a <alltraps>

80106ee0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106ee0:	6a 00                	push   $0x0
  pushl $3
80106ee2:	6a 03                	push   $0x3
  jmp alltraps
80106ee4:	e9 21 f8 ff ff       	jmp    8010670a <alltraps>

80106ee9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $4
80106eeb:	6a 04                	push   $0x4
  jmp alltraps
80106eed:	e9 18 f8 ff ff       	jmp    8010670a <alltraps>

80106ef2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $5
80106ef4:	6a 05                	push   $0x5
  jmp alltraps
80106ef6:	e9 0f f8 ff ff       	jmp    8010670a <alltraps>

80106efb <vector6>:
.globl vector6
vector6:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $6
80106efd:	6a 06                	push   $0x6
  jmp alltraps
80106eff:	e9 06 f8 ff ff       	jmp    8010670a <alltraps>

80106f04 <vector7>:
.globl vector7
vector7:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $7
80106f06:	6a 07                	push   $0x7
  jmp alltraps
80106f08:	e9 fd f7 ff ff       	jmp    8010670a <alltraps>

80106f0d <vector8>:
.globl vector8
vector8:
  pushl $8
80106f0d:	6a 08                	push   $0x8
  jmp alltraps
80106f0f:	e9 f6 f7 ff ff       	jmp    8010670a <alltraps>

80106f14 <vector9>:
.globl vector9
vector9:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $9
80106f16:	6a 09                	push   $0x9
  jmp alltraps
80106f18:	e9 ed f7 ff ff       	jmp    8010670a <alltraps>

80106f1d <vector10>:
.globl vector10
vector10:
  pushl $10
80106f1d:	6a 0a                	push   $0xa
  jmp alltraps
80106f1f:	e9 e6 f7 ff ff       	jmp    8010670a <alltraps>

80106f24 <vector11>:
.globl vector11
vector11:
  pushl $11
80106f24:	6a 0b                	push   $0xb
  jmp alltraps
80106f26:	e9 df f7 ff ff       	jmp    8010670a <alltraps>

80106f2b <vector12>:
.globl vector12
vector12:
  pushl $12
80106f2b:	6a 0c                	push   $0xc
  jmp alltraps
80106f2d:	e9 d8 f7 ff ff       	jmp    8010670a <alltraps>

80106f32 <vector13>:
.globl vector13
vector13:
  pushl $13
80106f32:	6a 0d                	push   $0xd
  jmp alltraps
80106f34:	e9 d1 f7 ff ff       	jmp    8010670a <alltraps>

80106f39 <vector14>:
.globl vector14
vector14:
  pushl $14
80106f39:	6a 0e                	push   $0xe
  jmp alltraps
80106f3b:	e9 ca f7 ff ff       	jmp    8010670a <alltraps>

80106f40 <vector15>:
.globl vector15
vector15:
  pushl $0
80106f40:	6a 00                	push   $0x0
  pushl $15
80106f42:	6a 0f                	push   $0xf
  jmp alltraps
80106f44:	e9 c1 f7 ff ff       	jmp    8010670a <alltraps>

80106f49 <vector16>:
.globl vector16
vector16:
  pushl $0
80106f49:	6a 00                	push   $0x0
  pushl $16
80106f4b:	6a 10                	push   $0x10
  jmp alltraps
80106f4d:	e9 b8 f7 ff ff       	jmp    8010670a <alltraps>

80106f52 <vector17>:
.globl vector17
vector17:
  pushl $17
80106f52:	6a 11                	push   $0x11
  jmp alltraps
80106f54:	e9 b1 f7 ff ff       	jmp    8010670a <alltraps>

80106f59 <vector18>:
.globl vector18
vector18:
  pushl $0
80106f59:	6a 00                	push   $0x0
  pushl $18
80106f5b:	6a 12                	push   $0x12
  jmp alltraps
80106f5d:	e9 a8 f7 ff ff       	jmp    8010670a <alltraps>

80106f62 <vector19>:
.globl vector19
vector19:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $19
80106f64:	6a 13                	push   $0x13
  jmp alltraps
80106f66:	e9 9f f7 ff ff       	jmp    8010670a <alltraps>

80106f6b <vector20>:
.globl vector20
vector20:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $20
80106f6d:	6a 14                	push   $0x14
  jmp alltraps
80106f6f:	e9 96 f7 ff ff       	jmp    8010670a <alltraps>

80106f74 <vector21>:
.globl vector21
vector21:
  pushl $0
80106f74:	6a 00                	push   $0x0
  pushl $21
80106f76:	6a 15                	push   $0x15
  jmp alltraps
80106f78:	e9 8d f7 ff ff       	jmp    8010670a <alltraps>

80106f7d <vector22>:
.globl vector22
vector22:
  pushl $0
80106f7d:	6a 00                	push   $0x0
  pushl $22
80106f7f:	6a 16                	push   $0x16
  jmp alltraps
80106f81:	e9 84 f7 ff ff       	jmp    8010670a <alltraps>

80106f86 <vector23>:
.globl vector23
vector23:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $23
80106f88:	6a 17                	push   $0x17
  jmp alltraps
80106f8a:	e9 7b f7 ff ff       	jmp    8010670a <alltraps>

80106f8f <vector24>:
.globl vector24
vector24:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $24
80106f91:	6a 18                	push   $0x18
  jmp alltraps
80106f93:	e9 72 f7 ff ff       	jmp    8010670a <alltraps>

80106f98 <vector25>:
.globl vector25
vector25:
  pushl $0
80106f98:	6a 00                	push   $0x0
  pushl $25
80106f9a:	6a 19                	push   $0x19
  jmp alltraps
80106f9c:	e9 69 f7 ff ff       	jmp    8010670a <alltraps>

80106fa1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106fa1:	6a 00                	push   $0x0
  pushl $26
80106fa3:	6a 1a                	push   $0x1a
  jmp alltraps
80106fa5:	e9 60 f7 ff ff       	jmp    8010670a <alltraps>

80106faa <vector27>:
.globl vector27
vector27:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $27
80106fac:	6a 1b                	push   $0x1b
  jmp alltraps
80106fae:	e9 57 f7 ff ff       	jmp    8010670a <alltraps>

80106fb3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $28
80106fb5:	6a 1c                	push   $0x1c
  jmp alltraps
80106fb7:	e9 4e f7 ff ff       	jmp    8010670a <alltraps>

80106fbc <vector29>:
.globl vector29
vector29:
  pushl $0
80106fbc:	6a 00                	push   $0x0
  pushl $29
80106fbe:	6a 1d                	push   $0x1d
  jmp alltraps
80106fc0:	e9 45 f7 ff ff       	jmp    8010670a <alltraps>

80106fc5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106fc5:	6a 00                	push   $0x0
  pushl $30
80106fc7:	6a 1e                	push   $0x1e
  jmp alltraps
80106fc9:	e9 3c f7 ff ff       	jmp    8010670a <alltraps>

80106fce <vector31>:
.globl vector31
vector31:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $31
80106fd0:	6a 1f                	push   $0x1f
  jmp alltraps
80106fd2:	e9 33 f7 ff ff       	jmp    8010670a <alltraps>

80106fd7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $32
80106fd9:	6a 20                	push   $0x20
  jmp alltraps
80106fdb:	e9 2a f7 ff ff       	jmp    8010670a <alltraps>

80106fe0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106fe0:	6a 00                	push   $0x0
  pushl $33
80106fe2:	6a 21                	push   $0x21
  jmp alltraps
80106fe4:	e9 21 f7 ff ff       	jmp    8010670a <alltraps>

80106fe9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106fe9:	6a 00                	push   $0x0
  pushl $34
80106feb:	6a 22                	push   $0x22
  jmp alltraps
80106fed:	e9 18 f7 ff ff       	jmp    8010670a <alltraps>

80106ff2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $35
80106ff4:	6a 23                	push   $0x23
  jmp alltraps
80106ff6:	e9 0f f7 ff ff       	jmp    8010670a <alltraps>

80106ffb <vector36>:
.globl vector36
vector36:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $36
80106ffd:	6a 24                	push   $0x24
  jmp alltraps
80106fff:	e9 06 f7 ff ff       	jmp    8010670a <alltraps>

80107004 <vector37>:
.globl vector37
vector37:
  pushl $0
80107004:	6a 00                	push   $0x0
  pushl $37
80107006:	6a 25                	push   $0x25
  jmp alltraps
80107008:	e9 fd f6 ff ff       	jmp    8010670a <alltraps>

8010700d <vector38>:
.globl vector38
vector38:
  pushl $0
8010700d:	6a 00                	push   $0x0
  pushl $38
8010700f:	6a 26                	push   $0x26
  jmp alltraps
80107011:	e9 f4 f6 ff ff       	jmp    8010670a <alltraps>

80107016 <vector39>:
.globl vector39
vector39:
  pushl $0
80107016:	6a 00                	push   $0x0
  pushl $39
80107018:	6a 27                	push   $0x27
  jmp alltraps
8010701a:	e9 eb f6 ff ff       	jmp    8010670a <alltraps>

8010701f <vector40>:
.globl vector40
vector40:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $40
80107021:	6a 28                	push   $0x28
  jmp alltraps
80107023:	e9 e2 f6 ff ff       	jmp    8010670a <alltraps>

80107028 <vector41>:
.globl vector41
vector41:
  pushl $0
80107028:	6a 00                	push   $0x0
  pushl $41
8010702a:	6a 29                	push   $0x29
  jmp alltraps
8010702c:	e9 d9 f6 ff ff       	jmp    8010670a <alltraps>

80107031 <vector42>:
.globl vector42
vector42:
  pushl $0
80107031:	6a 00                	push   $0x0
  pushl $42
80107033:	6a 2a                	push   $0x2a
  jmp alltraps
80107035:	e9 d0 f6 ff ff       	jmp    8010670a <alltraps>

8010703a <vector43>:
.globl vector43
vector43:
  pushl $0
8010703a:	6a 00                	push   $0x0
  pushl $43
8010703c:	6a 2b                	push   $0x2b
  jmp alltraps
8010703e:	e9 c7 f6 ff ff       	jmp    8010670a <alltraps>

80107043 <vector44>:
.globl vector44
vector44:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $44
80107045:	6a 2c                	push   $0x2c
  jmp alltraps
80107047:	e9 be f6 ff ff       	jmp    8010670a <alltraps>

8010704c <vector45>:
.globl vector45
vector45:
  pushl $0
8010704c:	6a 00                	push   $0x0
  pushl $45
8010704e:	6a 2d                	push   $0x2d
  jmp alltraps
80107050:	e9 b5 f6 ff ff       	jmp    8010670a <alltraps>

80107055 <vector46>:
.globl vector46
vector46:
  pushl $0
80107055:	6a 00                	push   $0x0
  pushl $46
80107057:	6a 2e                	push   $0x2e
  jmp alltraps
80107059:	e9 ac f6 ff ff       	jmp    8010670a <alltraps>

8010705e <vector47>:
.globl vector47
vector47:
  pushl $0
8010705e:	6a 00                	push   $0x0
  pushl $47
80107060:	6a 2f                	push   $0x2f
  jmp alltraps
80107062:	e9 a3 f6 ff ff       	jmp    8010670a <alltraps>

80107067 <vector48>:
.globl vector48
vector48:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $48
80107069:	6a 30                	push   $0x30
  jmp alltraps
8010706b:	e9 9a f6 ff ff       	jmp    8010670a <alltraps>

80107070 <vector49>:
.globl vector49
vector49:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $49
80107072:	6a 31                	push   $0x31
  jmp alltraps
80107074:	e9 91 f6 ff ff       	jmp    8010670a <alltraps>

80107079 <vector50>:
.globl vector50
vector50:
  pushl $0
80107079:	6a 00                	push   $0x0
  pushl $50
8010707b:	6a 32                	push   $0x32
  jmp alltraps
8010707d:	e9 88 f6 ff ff       	jmp    8010670a <alltraps>

80107082 <vector51>:
.globl vector51
vector51:
  pushl $0
80107082:	6a 00                	push   $0x0
  pushl $51
80107084:	6a 33                	push   $0x33
  jmp alltraps
80107086:	e9 7f f6 ff ff       	jmp    8010670a <alltraps>

8010708b <vector52>:
.globl vector52
vector52:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $52
8010708d:	6a 34                	push   $0x34
  jmp alltraps
8010708f:	e9 76 f6 ff ff       	jmp    8010670a <alltraps>

80107094 <vector53>:
.globl vector53
vector53:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $53
80107096:	6a 35                	push   $0x35
  jmp alltraps
80107098:	e9 6d f6 ff ff       	jmp    8010670a <alltraps>

8010709d <vector54>:
.globl vector54
vector54:
  pushl $0
8010709d:	6a 00                	push   $0x0
  pushl $54
8010709f:	6a 36                	push   $0x36
  jmp alltraps
801070a1:	e9 64 f6 ff ff       	jmp    8010670a <alltraps>

801070a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801070a6:	6a 00                	push   $0x0
  pushl $55
801070a8:	6a 37                	push   $0x37
  jmp alltraps
801070aa:	e9 5b f6 ff ff       	jmp    8010670a <alltraps>

801070af <vector56>:
.globl vector56
vector56:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $56
801070b1:	6a 38                	push   $0x38
  jmp alltraps
801070b3:	e9 52 f6 ff ff       	jmp    8010670a <alltraps>

801070b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $57
801070ba:	6a 39                	push   $0x39
  jmp alltraps
801070bc:	e9 49 f6 ff ff       	jmp    8010670a <alltraps>

801070c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801070c1:	6a 00                	push   $0x0
  pushl $58
801070c3:	6a 3a                	push   $0x3a
  jmp alltraps
801070c5:	e9 40 f6 ff ff       	jmp    8010670a <alltraps>

801070ca <vector59>:
.globl vector59
vector59:
  pushl $0
801070ca:	6a 00                	push   $0x0
  pushl $59
801070cc:	6a 3b                	push   $0x3b
  jmp alltraps
801070ce:	e9 37 f6 ff ff       	jmp    8010670a <alltraps>

801070d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $60
801070d5:	6a 3c                	push   $0x3c
  jmp alltraps
801070d7:	e9 2e f6 ff ff       	jmp    8010670a <alltraps>

801070dc <vector61>:
.globl vector61
vector61:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $61
801070de:	6a 3d                	push   $0x3d
  jmp alltraps
801070e0:	e9 25 f6 ff ff       	jmp    8010670a <alltraps>

801070e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801070e5:	6a 00                	push   $0x0
  pushl $62
801070e7:	6a 3e                	push   $0x3e
  jmp alltraps
801070e9:	e9 1c f6 ff ff       	jmp    8010670a <alltraps>

801070ee <vector63>:
.globl vector63
vector63:
  pushl $0
801070ee:	6a 00                	push   $0x0
  pushl $63
801070f0:	6a 3f                	push   $0x3f
  jmp alltraps
801070f2:	e9 13 f6 ff ff       	jmp    8010670a <alltraps>

801070f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $64
801070f9:	6a 40                	push   $0x40
  jmp alltraps
801070fb:	e9 0a f6 ff ff       	jmp    8010670a <alltraps>

80107100 <vector65>:
.globl vector65
vector65:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $65
80107102:	6a 41                	push   $0x41
  jmp alltraps
80107104:	e9 01 f6 ff ff       	jmp    8010670a <alltraps>

80107109 <vector66>:
.globl vector66
vector66:
  pushl $0
80107109:	6a 00                	push   $0x0
  pushl $66
8010710b:	6a 42                	push   $0x42
  jmp alltraps
8010710d:	e9 f8 f5 ff ff       	jmp    8010670a <alltraps>

80107112 <vector67>:
.globl vector67
vector67:
  pushl $0
80107112:	6a 00                	push   $0x0
  pushl $67
80107114:	6a 43                	push   $0x43
  jmp alltraps
80107116:	e9 ef f5 ff ff       	jmp    8010670a <alltraps>

8010711b <vector68>:
.globl vector68
vector68:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $68
8010711d:	6a 44                	push   $0x44
  jmp alltraps
8010711f:	e9 e6 f5 ff ff       	jmp    8010670a <alltraps>

80107124 <vector69>:
.globl vector69
vector69:
  pushl $0
80107124:	6a 00                	push   $0x0
  pushl $69
80107126:	6a 45                	push   $0x45
  jmp alltraps
80107128:	e9 dd f5 ff ff       	jmp    8010670a <alltraps>

8010712d <vector70>:
.globl vector70
vector70:
  pushl $0
8010712d:	6a 00                	push   $0x0
  pushl $70
8010712f:	6a 46                	push   $0x46
  jmp alltraps
80107131:	e9 d4 f5 ff ff       	jmp    8010670a <alltraps>

80107136 <vector71>:
.globl vector71
vector71:
  pushl $0
80107136:	6a 00                	push   $0x0
  pushl $71
80107138:	6a 47                	push   $0x47
  jmp alltraps
8010713a:	e9 cb f5 ff ff       	jmp    8010670a <alltraps>

8010713f <vector72>:
.globl vector72
vector72:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $72
80107141:	6a 48                	push   $0x48
  jmp alltraps
80107143:	e9 c2 f5 ff ff       	jmp    8010670a <alltraps>

80107148 <vector73>:
.globl vector73
vector73:
  pushl $0
80107148:	6a 00                	push   $0x0
  pushl $73
8010714a:	6a 49                	push   $0x49
  jmp alltraps
8010714c:	e9 b9 f5 ff ff       	jmp    8010670a <alltraps>

80107151 <vector74>:
.globl vector74
vector74:
  pushl $0
80107151:	6a 00                	push   $0x0
  pushl $74
80107153:	6a 4a                	push   $0x4a
  jmp alltraps
80107155:	e9 b0 f5 ff ff       	jmp    8010670a <alltraps>

8010715a <vector75>:
.globl vector75
vector75:
  pushl $0
8010715a:	6a 00                	push   $0x0
  pushl $75
8010715c:	6a 4b                	push   $0x4b
  jmp alltraps
8010715e:	e9 a7 f5 ff ff       	jmp    8010670a <alltraps>

80107163 <vector76>:
.globl vector76
vector76:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $76
80107165:	6a 4c                	push   $0x4c
  jmp alltraps
80107167:	e9 9e f5 ff ff       	jmp    8010670a <alltraps>

8010716c <vector77>:
.globl vector77
vector77:
  pushl $0
8010716c:	6a 00                	push   $0x0
  pushl $77
8010716e:	6a 4d                	push   $0x4d
  jmp alltraps
80107170:	e9 95 f5 ff ff       	jmp    8010670a <alltraps>

80107175 <vector78>:
.globl vector78
vector78:
  pushl $0
80107175:	6a 00                	push   $0x0
  pushl $78
80107177:	6a 4e                	push   $0x4e
  jmp alltraps
80107179:	e9 8c f5 ff ff       	jmp    8010670a <alltraps>

8010717e <vector79>:
.globl vector79
vector79:
  pushl $0
8010717e:	6a 00                	push   $0x0
  pushl $79
80107180:	6a 4f                	push   $0x4f
  jmp alltraps
80107182:	e9 83 f5 ff ff       	jmp    8010670a <alltraps>

80107187 <vector80>:
.globl vector80
vector80:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $80
80107189:	6a 50                	push   $0x50
  jmp alltraps
8010718b:	e9 7a f5 ff ff       	jmp    8010670a <alltraps>

80107190 <vector81>:
.globl vector81
vector81:
  pushl $0
80107190:	6a 00                	push   $0x0
  pushl $81
80107192:	6a 51                	push   $0x51
  jmp alltraps
80107194:	e9 71 f5 ff ff       	jmp    8010670a <alltraps>

80107199 <vector82>:
.globl vector82
vector82:
  pushl $0
80107199:	6a 00                	push   $0x0
  pushl $82
8010719b:	6a 52                	push   $0x52
  jmp alltraps
8010719d:	e9 68 f5 ff ff       	jmp    8010670a <alltraps>

801071a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801071a2:	6a 00                	push   $0x0
  pushl $83
801071a4:	6a 53                	push   $0x53
  jmp alltraps
801071a6:	e9 5f f5 ff ff       	jmp    8010670a <alltraps>

801071ab <vector84>:
.globl vector84
vector84:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $84
801071ad:	6a 54                	push   $0x54
  jmp alltraps
801071af:	e9 56 f5 ff ff       	jmp    8010670a <alltraps>

801071b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801071b4:	6a 00                	push   $0x0
  pushl $85
801071b6:	6a 55                	push   $0x55
  jmp alltraps
801071b8:	e9 4d f5 ff ff       	jmp    8010670a <alltraps>

801071bd <vector86>:
.globl vector86
vector86:
  pushl $0
801071bd:	6a 00                	push   $0x0
  pushl $86
801071bf:	6a 56                	push   $0x56
  jmp alltraps
801071c1:	e9 44 f5 ff ff       	jmp    8010670a <alltraps>

801071c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801071c6:	6a 00                	push   $0x0
  pushl $87
801071c8:	6a 57                	push   $0x57
  jmp alltraps
801071ca:	e9 3b f5 ff ff       	jmp    8010670a <alltraps>

801071cf <vector88>:
.globl vector88
vector88:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $88
801071d1:	6a 58                	push   $0x58
  jmp alltraps
801071d3:	e9 32 f5 ff ff       	jmp    8010670a <alltraps>

801071d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801071d8:	6a 00                	push   $0x0
  pushl $89
801071da:	6a 59                	push   $0x59
  jmp alltraps
801071dc:	e9 29 f5 ff ff       	jmp    8010670a <alltraps>

801071e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801071e1:	6a 00                	push   $0x0
  pushl $90
801071e3:	6a 5a                	push   $0x5a
  jmp alltraps
801071e5:	e9 20 f5 ff ff       	jmp    8010670a <alltraps>

801071ea <vector91>:
.globl vector91
vector91:
  pushl $0
801071ea:	6a 00                	push   $0x0
  pushl $91
801071ec:	6a 5b                	push   $0x5b
  jmp alltraps
801071ee:	e9 17 f5 ff ff       	jmp    8010670a <alltraps>

801071f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $92
801071f5:	6a 5c                	push   $0x5c
  jmp alltraps
801071f7:	e9 0e f5 ff ff       	jmp    8010670a <alltraps>

801071fc <vector93>:
.globl vector93
vector93:
  pushl $0
801071fc:	6a 00                	push   $0x0
  pushl $93
801071fe:	6a 5d                	push   $0x5d
  jmp alltraps
80107200:	e9 05 f5 ff ff       	jmp    8010670a <alltraps>

80107205 <vector94>:
.globl vector94
vector94:
  pushl $0
80107205:	6a 00                	push   $0x0
  pushl $94
80107207:	6a 5e                	push   $0x5e
  jmp alltraps
80107209:	e9 fc f4 ff ff       	jmp    8010670a <alltraps>

8010720e <vector95>:
.globl vector95
vector95:
  pushl $0
8010720e:	6a 00                	push   $0x0
  pushl $95
80107210:	6a 5f                	push   $0x5f
  jmp alltraps
80107212:	e9 f3 f4 ff ff       	jmp    8010670a <alltraps>

80107217 <vector96>:
.globl vector96
vector96:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $96
80107219:	6a 60                	push   $0x60
  jmp alltraps
8010721b:	e9 ea f4 ff ff       	jmp    8010670a <alltraps>

80107220 <vector97>:
.globl vector97
vector97:
  pushl $0
80107220:	6a 00                	push   $0x0
  pushl $97
80107222:	6a 61                	push   $0x61
  jmp alltraps
80107224:	e9 e1 f4 ff ff       	jmp    8010670a <alltraps>

80107229 <vector98>:
.globl vector98
vector98:
  pushl $0
80107229:	6a 00                	push   $0x0
  pushl $98
8010722b:	6a 62                	push   $0x62
  jmp alltraps
8010722d:	e9 d8 f4 ff ff       	jmp    8010670a <alltraps>

80107232 <vector99>:
.globl vector99
vector99:
  pushl $0
80107232:	6a 00                	push   $0x0
  pushl $99
80107234:	6a 63                	push   $0x63
  jmp alltraps
80107236:	e9 cf f4 ff ff       	jmp    8010670a <alltraps>

8010723b <vector100>:
.globl vector100
vector100:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $100
8010723d:	6a 64                	push   $0x64
  jmp alltraps
8010723f:	e9 c6 f4 ff ff       	jmp    8010670a <alltraps>

80107244 <vector101>:
.globl vector101
vector101:
  pushl $0
80107244:	6a 00                	push   $0x0
  pushl $101
80107246:	6a 65                	push   $0x65
  jmp alltraps
80107248:	e9 bd f4 ff ff       	jmp    8010670a <alltraps>

8010724d <vector102>:
.globl vector102
vector102:
  pushl $0
8010724d:	6a 00                	push   $0x0
  pushl $102
8010724f:	6a 66                	push   $0x66
  jmp alltraps
80107251:	e9 b4 f4 ff ff       	jmp    8010670a <alltraps>

80107256 <vector103>:
.globl vector103
vector103:
  pushl $0
80107256:	6a 00                	push   $0x0
  pushl $103
80107258:	6a 67                	push   $0x67
  jmp alltraps
8010725a:	e9 ab f4 ff ff       	jmp    8010670a <alltraps>

8010725f <vector104>:
.globl vector104
vector104:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $104
80107261:	6a 68                	push   $0x68
  jmp alltraps
80107263:	e9 a2 f4 ff ff       	jmp    8010670a <alltraps>

80107268 <vector105>:
.globl vector105
vector105:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $105
8010726a:	6a 69                	push   $0x69
  jmp alltraps
8010726c:	e9 99 f4 ff ff       	jmp    8010670a <alltraps>

80107271 <vector106>:
.globl vector106
vector106:
  pushl $0
80107271:	6a 00                	push   $0x0
  pushl $106
80107273:	6a 6a                	push   $0x6a
  jmp alltraps
80107275:	e9 90 f4 ff ff       	jmp    8010670a <alltraps>

8010727a <vector107>:
.globl vector107
vector107:
  pushl $0
8010727a:	6a 00                	push   $0x0
  pushl $107
8010727c:	6a 6b                	push   $0x6b
  jmp alltraps
8010727e:	e9 87 f4 ff ff       	jmp    8010670a <alltraps>

80107283 <vector108>:
.globl vector108
vector108:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $108
80107285:	6a 6c                	push   $0x6c
  jmp alltraps
80107287:	e9 7e f4 ff ff       	jmp    8010670a <alltraps>

8010728c <vector109>:
.globl vector109
vector109:
  pushl $0
8010728c:	6a 00                	push   $0x0
  pushl $109
8010728e:	6a 6d                	push   $0x6d
  jmp alltraps
80107290:	e9 75 f4 ff ff       	jmp    8010670a <alltraps>

80107295 <vector110>:
.globl vector110
vector110:
  pushl $0
80107295:	6a 00                	push   $0x0
  pushl $110
80107297:	6a 6e                	push   $0x6e
  jmp alltraps
80107299:	e9 6c f4 ff ff       	jmp    8010670a <alltraps>

8010729e <vector111>:
.globl vector111
vector111:
  pushl $0
8010729e:	6a 00                	push   $0x0
  pushl $111
801072a0:	6a 6f                	push   $0x6f
  jmp alltraps
801072a2:	e9 63 f4 ff ff       	jmp    8010670a <alltraps>

801072a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $112
801072a9:	6a 70                	push   $0x70
  jmp alltraps
801072ab:	e9 5a f4 ff ff       	jmp    8010670a <alltraps>

801072b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $113
801072b2:	6a 71                	push   $0x71
  jmp alltraps
801072b4:	e9 51 f4 ff ff       	jmp    8010670a <alltraps>

801072b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801072b9:	6a 00                	push   $0x0
  pushl $114
801072bb:	6a 72                	push   $0x72
  jmp alltraps
801072bd:	e9 48 f4 ff ff       	jmp    8010670a <alltraps>

801072c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801072c2:	6a 00                	push   $0x0
  pushl $115
801072c4:	6a 73                	push   $0x73
  jmp alltraps
801072c6:	e9 3f f4 ff ff       	jmp    8010670a <alltraps>

801072cb <vector116>:
.globl vector116
vector116:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $116
801072cd:	6a 74                	push   $0x74
  jmp alltraps
801072cf:	e9 36 f4 ff ff       	jmp    8010670a <alltraps>

801072d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801072d4:	6a 00                	push   $0x0
  pushl $117
801072d6:	6a 75                	push   $0x75
  jmp alltraps
801072d8:	e9 2d f4 ff ff       	jmp    8010670a <alltraps>

801072dd <vector118>:
.globl vector118
vector118:
  pushl $0
801072dd:	6a 00                	push   $0x0
  pushl $118
801072df:	6a 76                	push   $0x76
  jmp alltraps
801072e1:	e9 24 f4 ff ff       	jmp    8010670a <alltraps>

801072e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $119
801072e8:	6a 77                	push   $0x77
  jmp alltraps
801072ea:	e9 1b f4 ff ff       	jmp    8010670a <alltraps>

801072ef <vector120>:
.globl vector120
vector120:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $120
801072f1:	6a 78                	push   $0x78
  jmp alltraps
801072f3:	e9 12 f4 ff ff       	jmp    8010670a <alltraps>

801072f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $121
801072fa:	6a 79                	push   $0x79
  jmp alltraps
801072fc:	e9 09 f4 ff ff       	jmp    8010670a <alltraps>

80107301 <vector122>:
.globl vector122
vector122:
  pushl $0
80107301:	6a 00                	push   $0x0
  pushl $122
80107303:	6a 7a                	push   $0x7a
  jmp alltraps
80107305:	e9 00 f4 ff ff       	jmp    8010670a <alltraps>

8010730a <vector123>:
.globl vector123
vector123:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $123
8010730c:	6a 7b                	push   $0x7b
  jmp alltraps
8010730e:	e9 f7 f3 ff ff       	jmp    8010670a <alltraps>

80107313 <vector124>:
.globl vector124
vector124:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $124
80107315:	6a 7c                	push   $0x7c
  jmp alltraps
80107317:	e9 ee f3 ff ff       	jmp    8010670a <alltraps>

8010731c <vector125>:
.globl vector125
vector125:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $125
8010731e:	6a 7d                	push   $0x7d
  jmp alltraps
80107320:	e9 e5 f3 ff ff       	jmp    8010670a <alltraps>

80107325 <vector126>:
.globl vector126
vector126:
  pushl $0
80107325:	6a 00                	push   $0x0
  pushl $126
80107327:	6a 7e                	push   $0x7e
  jmp alltraps
80107329:	e9 dc f3 ff ff       	jmp    8010670a <alltraps>

8010732e <vector127>:
.globl vector127
vector127:
  pushl $0
8010732e:	6a 00                	push   $0x0
  pushl $127
80107330:	6a 7f                	push   $0x7f
  jmp alltraps
80107332:	e9 d3 f3 ff ff       	jmp    8010670a <alltraps>

80107337 <vector128>:
.globl vector128
vector128:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $128
80107339:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010733e:	e9 c7 f3 ff ff       	jmp    8010670a <alltraps>

80107343 <vector129>:
.globl vector129
vector129:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $129
80107345:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010734a:	e9 bb f3 ff ff       	jmp    8010670a <alltraps>

8010734f <vector130>:
.globl vector130
vector130:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $130
80107351:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107356:	e9 af f3 ff ff       	jmp    8010670a <alltraps>

8010735b <vector131>:
.globl vector131
vector131:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $131
8010735d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107362:	e9 a3 f3 ff ff       	jmp    8010670a <alltraps>

80107367 <vector132>:
.globl vector132
vector132:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $132
80107369:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010736e:	e9 97 f3 ff ff       	jmp    8010670a <alltraps>

80107373 <vector133>:
.globl vector133
vector133:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $133
80107375:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010737a:	e9 8b f3 ff ff       	jmp    8010670a <alltraps>

8010737f <vector134>:
.globl vector134
vector134:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $134
80107381:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107386:	e9 7f f3 ff ff       	jmp    8010670a <alltraps>

8010738b <vector135>:
.globl vector135
vector135:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $135
8010738d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107392:	e9 73 f3 ff ff       	jmp    8010670a <alltraps>

80107397 <vector136>:
.globl vector136
vector136:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $136
80107399:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010739e:	e9 67 f3 ff ff       	jmp    8010670a <alltraps>

801073a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $137
801073a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801073aa:	e9 5b f3 ff ff       	jmp    8010670a <alltraps>

801073af <vector138>:
.globl vector138
vector138:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $138
801073b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801073b6:	e9 4f f3 ff ff       	jmp    8010670a <alltraps>

801073bb <vector139>:
.globl vector139
vector139:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $139
801073bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801073c2:	e9 43 f3 ff ff       	jmp    8010670a <alltraps>

801073c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $140
801073c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801073ce:	e9 37 f3 ff ff       	jmp    8010670a <alltraps>

801073d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $141
801073d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801073da:	e9 2b f3 ff ff       	jmp    8010670a <alltraps>

801073df <vector142>:
.globl vector142
vector142:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $142
801073e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801073e6:	e9 1f f3 ff ff       	jmp    8010670a <alltraps>

801073eb <vector143>:
.globl vector143
vector143:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $143
801073ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801073f2:	e9 13 f3 ff ff       	jmp    8010670a <alltraps>

801073f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $144
801073f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801073fe:	e9 07 f3 ff ff       	jmp    8010670a <alltraps>

80107403 <vector145>:
.globl vector145
vector145:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $145
80107405:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010740a:	e9 fb f2 ff ff       	jmp    8010670a <alltraps>

8010740f <vector146>:
.globl vector146
vector146:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $146
80107411:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107416:	e9 ef f2 ff ff       	jmp    8010670a <alltraps>

8010741b <vector147>:
.globl vector147
vector147:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $147
8010741d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107422:	e9 e3 f2 ff ff       	jmp    8010670a <alltraps>

80107427 <vector148>:
.globl vector148
vector148:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $148
80107429:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010742e:	e9 d7 f2 ff ff       	jmp    8010670a <alltraps>

80107433 <vector149>:
.globl vector149
vector149:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $149
80107435:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010743a:	e9 cb f2 ff ff       	jmp    8010670a <alltraps>

8010743f <vector150>:
.globl vector150
vector150:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $150
80107441:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107446:	e9 bf f2 ff ff       	jmp    8010670a <alltraps>

8010744b <vector151>:
.globl vector151
vector151:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $151
8010744d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107452:	e9 b3 f2 ff ff       	jmp    8010670a <alltraps>

80107457 <vector152>:
.globl vector152
vector152:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $152
80107459:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010745e:	e9 a7 f2 ff ff       	jmp    8010670a <alltraps>

80107463 <vector153>:
.globl vector153
vector153:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $153
80107465:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010746a:	e9 9b f2 ff ff       	jmp    8010670a <alltraps>

8010746f <vector154>:
.globl vector154
vector154:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $154
80107471:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107476:	e9 8f f2 ff ff       	jmp    8010670a <alltraps>

8010747b <vector155>:
.globl vector155
vector155:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $155
8010747d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107482:	e9 83 f2 ff ff       	jmp    8010670a <alltraps>

80107487 <vector156>:
.globl vector156
vector156:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $156
80107489:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010748e:	e9 77 f2 ff ff       	jmp    8010670a <alltraps>

80107493 <vector157>:
.globl vector157
vector157:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $157
80107495:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010749a:	e9 6b f2 ff ff       	jmp    8010670a <alltraps>

8010749f <vector158>:
.globl vector158
vector158:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $158
801074a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801074a6:	e9 5f f2 ff ff       	jmp    8010670a <alltraps>

801074ab <vector159>:
.globl vector159
vector159:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $159
801074ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801074b2:	e9 53 f2 ff ff       	jmp    8010670a <alltraps>

801074b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $160
801074b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801074be:	e9 47 f2 ff ff       	jmp    8010670a <alltraps>

801074c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $161
801074c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801074ca:	e9 3b f2 ff ff       	jmp    8010670a <alltraps>

801074cf <vector162>:
.globl vector162
vector162:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $162
801074d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801074d6:	e9 2f f2 ff ff       	jmp    8010670a <alltraps>

801074db <vector163>:
.globl vector163
vector163:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $163
801074dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801074e2:	e9 23 f2 ff ff       	jmp    8010670a <alltraps>

801074e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $164
801074e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801074ee:	e9 17 f2 ff ff       	jmp    8010670a <alltraps>

801074f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $165
801074f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801074fa:	e9 0b f2 ff ff       	jmp    8010670a <alltraps>

801074ff <vector166>:
.globl vector166
vector166:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $166
80107501:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107506:	e9 ff f1 ff ff       	jmp    8010670a <alltraps>

8010750b <vector167>:
.globl vector167
vector167:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $167
8010750d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107512:	e9 f3 f1 ff ff       	jmp    8010670a <alltraps>

80107517 <vector168>:
.globl vector168
vector168:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $168
80107519:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010751e:	e9 e7 f1 ff ff       	jmp    8010670a <alltraps>

80107523 <vector169>:
.globl vector169
vector169:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $169
80107525:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010752a:	e9 db f1 ff ff       	jmp    8010670a <alltraps>

8010752f <vector170>:
.globl vector170
vector170:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $170
80107531:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107536:	e9 cf f1 ff ff       	jmp    8010670a <alltraps>

8010753b <vector171>:
.globl vector171
vector171:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $171
8010753d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107542:	e9 c3 f1 ff ff       	jmp    8010670a <alltraps>

80107547 <vector172>:
.globl vector172
vector172:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $172
80107549:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010754e:	e9 b7 f1 ff ff       	jmp    8010670a <alltraps>

80107553 <vector173>:
.globl vector173
vector173:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $173
80107555:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010755a:	e9 ab f1 ff ff       	jmp    8010670a <alltraps>

8010755f <vector174>:
.globl vector174
vector174:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $174
80107561:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107566:	e9 9f f1 ff ff       	jmp    8010670a <alltraps>

8010756b <vector175>:
.globl vector175
vector175:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $175
8010756d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107572:	e9 93 f1 ff ff       	jmp    8010670a <alltraps>

80107577 <vector176>:
.globl vector176
vector176:
  pushl $0
80107577:	6a 00                	push   $0x0
  pushl $176
80107579:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010757e:	e9 87 f1 ff ff       	jmp    8010670a <alltraps>

80107583 <vector177>:
.globl vector177
vector177:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $177
80107585:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010758a:	e9 7b f1 ff ff       	jmp    8010670a <alltraps>

8010758f <vector178>:
.globl vector178
vector178:
  pushl $0
8010758f:	6a 00                	push   $0x0
  pushl $178
80107591:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107596:	e9 6f f1 ff ff       	jmp    8010670a <alltraps>

8010759b <vector179>:
.globl vector179
vector179:
  pushl $0
8010759b:	6a 00                	push   $0x0
  pushl $179
8010759d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801075a2:	e9 63 f1 ff ff       	jmp    8010670a <alltraps>

801075a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $180
801075a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801075ae:	e9 57 f1 ff ff       	jmp    8010670a <alltraps>

801075b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801075b3:	6a 00                	push   $0x0
  pushl $181
801075b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801075ba:	e9 4b f1 ff ff       	jmp    8010670a <alltraps>

801075bf <vector182>:
.globl vector182
vector182:
  pushl $0
801075bf:	6a 00                	push   $0x0
  pushl $182
801075c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801075c6:	e9 3f f1 ff ff       	jmp    8010670a <alltraps>

801075cb <vector183>:
.globl vector183
vector183:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $183
801075cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801075d2:	e9 33 f1 ff ff       	jmp    8010670a <alltraps>

801075d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801075d7:	6a 00                	push   $0x0
  pushl $184
801075d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801075de:	e9 27 f1 ff ff       	jmp    8010670a <alltraps>

801075e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801075e3:	6a 00                	push   $0x0
  pushl $185
801075e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801075ea:	e9 1b f1 ff ff       	jmp    8010670a <alltraps>

801075ef <vector186>:
.globl vector186
vector186:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $186
801075f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801075f6:	e9 0f f1 ff ff       	jmp    8010670a <alltraps>

801075fb <vector187>:
.globl vector187
vector187:
  pushl $0
801075fb:	6a 00                	push   $0x0
  pushl $187
801075fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107602:	e9 03 f1 ff ff       	jmp    8010670a <alltraps>

80107607 <vector188>:
.globl vector188
vector188:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $188
80107609:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010760e:	e9 f7 f0 ff ff       	jmp    8010670a <alltraps>

80107613 <vector189>:
.globl vector189
vector189:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $189
80107615:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010761a:	e9 eb f0 ff ff       	jmp    8010670a <alltraps>

8010761f <vector190>:
.globl vector190
vector190:
  pushl $0
8010761f:	6a 00                	push   $0x0
  pushl $190
80107621:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107626:	e9 df f0 ff ff       	jmp    8010670a <alltraps>

8010762b <vector191>:
.globl vector191
vector191:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $191
8010762d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107632:	e9 d3 f0 ff ff       	jmp    8010670a <alltraps>

80107637 <vector192>:
.globl vector192
vector192:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $192
80107639:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010763e:	e9 c7 f0 ff ff       	jmp    8010670a <alltraps>

80107643 <vector193>:
.globl vector193
vector193:
  pushl $0
80107643:	6a 00                	push   $0x0
  pushl $193
80107645:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010764a:	e9 bb f0 ff ff       	jmp    8010670a <alltraps>

8010764f <vector194>:
.globl vector194
vector194:
  pushl $0
8010764f:	6a 00                	push   $0x0
  pushl $194
80107651:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107656:	e9 af f0 ff ff       	jmp    8010670a <alltraps>

8010765b <vector195>:
.globl vector195
vector195:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $195
8010765d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107662:	e9 a3 f0 ff ff       	jmp    8010670a <alltraps>

80107667 <vector196>:
.globl vector196
vector196:
  pushl $0
80107667:	6a 00                	push   $0x0
  pushl $196
80107669:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010766e:	e9 97 f0 ff ff       	jmp    8010670a <alltraps>

80107673 <vector197>:
.globl vector197
vector197:
  pushl $0
80107673:	6a 00                	push   $0x0
  pushl $197
80107675:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010767a:	e9 8b f0 ff ff       	jmp    8010670a <alltraps>

8010767f <vector198>:
.globl vector198
vector198:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $198
80107681:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107686:	e9 7f f0 ff ff       	jmp    8010670a <alltraps>

8010768b <vector199>:
.globl vector199
vector199:
  pushl $0
8010768b:	6a 00                	push   $0x0
  pushl $199
8010768d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107692:	e9 73 f0 ff ff       	jmp    8010670a <alltraps>

80107697 <vector200>:
.globl vector200
vector200:
  pushl $0
80107697:	6a 00                	push   $0x0
  pushl $200
80107699:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010769e:	e9 67 f0 ff ff       	jmp    8010670a <alltraps>

801076a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $201
801076a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801076aa:	e9 5b f0 ff ff       	jmp    8010670a <alltraps>

801076af <vector202>:
.globl vector202
vector202:
  pushl $0
801076af:	6a 00                	push   $0x0
  pushl $202
801076b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801076b6:	e9 4f f0 ff ff       	jmp    8010670a <alltraps>

801076bb <vector203>:
.globl vector203
vector203:
  pushl $0
801076bb:	6a 00                	push   $0x0
  pushl $203
801076bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801076c2:	e9 43 f0 ff ff       	jmp    8010670a <alltraps>

801076c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $204
801076c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801076ce:	e9 37 f0 ff ff       	jmp    8010670a <alltraps>

801076d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801076d3:	6a 00                	push   $0x0
  pushl $205
801076d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801076da:	e9 2b f0 ff ff       	jmp    8010670a <alltraps>

801076df <vector206>:
.globl vector206
vector206:
  pushl $0
801076df:	6a 00                	push   $0x0
  pushl $206
801076e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801076e6:	e9 1f f0 ff ff       	jmp    8010670a <alltraps>

801076eb <vector207>:
.globl vector207
vector207:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $207
801076ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801076f2:	e9 13 f0 ff ff       	jmp    8010670a <alltraps>

801076f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801076f7:	6a 00                	push   $0x0
  pushl $208
801076f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801076fe:	e9 07 f0 ff ff       	jmp    8010670a <alltraps>

80107703 <vector209>:
.globl vector209
vector209:
  pushl $0
80107703:	6a 00                	push   $0x0
  pushl $209
80107705:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010770a:	e9 fb ef ff ff       	jmp    8010670a <alltraps>

8010770f <vector210>:
.globl vector210
vector210:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $210
80107711:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107716:	e9 ef ef ff ff       	jmp    8010670a <alltraps>

8010771b <vector211>:
.globl vector211
vector211:
  pushl $0
8010771b:	6a 00                	push   $0x0
  pushl $211
8010771d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107722:	e9 e3 ef ff ff       	jmp    8010670a <alltraps>

80107727 <vector212>:
.globl vector212
vector212:
  pushl $0
80107727:	6a 00                	push   $0x0
  pushl $212
80107729:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010772e:	e9 d7 ef ff ff       	jmp    8010670a <alltraps>

80107733 <vector213>:
.globl vector213
vector213:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $213
80107735:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010773a:	e9 cb ef ff ff       	jmp    8010670a <alltraps>

8010773f <vector214>:
.globl vector214
vector214:
  pushl $0
8010773f:	6a 00                	push   $0x0
  pushl $214
80107741:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107746:	e9 bf ef ff ff       	jmp    8010670a <alltraps>

8010774b <vector215>:
.globl vector215
vector215:
  pushl $0
8010774b:	6a 00                	push   $0x0
  pushl $215
8010774d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107752:	e9 b3 ef ff ff       	jmp    8010670a <alltraps>

80107757 <vector216>:
.globl vector216
vector216:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $216
80107759:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010775e:	e9 a7 ef ff ff       	jmp    8010670a <alltraps>

80107763 <vector217>:
.globl vector217
vector217:
  pushl $0
80107763:	6a 00                	push   $0x0
  pushl $217
80107765:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010776a:	e9 9b ef ff ff       	jmp    8010670a <alltraps>

8010776f <vector218>:
.globl vector218
vector218:
  pushl $0
8010776f:	6a 00                	push   $0x0
  pushl $218
80107771:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107776:	e9 8f ef ff ff       	jmp    8010670a <alltraps>

8010777b <vector219>:
.globl vector219
vector219:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $219
8010777d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107782:	e9 83 ef ff ff       	jmp    8010670a <alltraps>

80107787 <vector220>:
.globl vector220
vector220:
  pushl $0
80107787:	6a 00                	push   $0x0
  pushl $220
80107789:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010778e:	e9 77 ef ff ff       	jmp    8010670a <alltraps>

80107793 <vector221>:
.globl vector221
vector221:
  pushl $0
80107793:	6a 00                	push   $0x0
  pushl $221
80107795:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010779a:	e9 6b ef ff ff       	jmp    8010670a <alltraps>

8010779f <vector222>:
.globl vector222
vector222:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $222
801077a1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801077a6:	e9 5f ef ff ff       	jmp    8010670a <alltraps>

801077ab <vector223>:
.globl vector223
vector223:
  pushl $0
801077ab:	6a 00                	push   $0x0
  pushl $223
801077ad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801077b2:	e9 53 ef ff ff       	jmp    8010670a <alltraps>

801077b7 <vector224>:
.globl vector224
vector224:
  pushl $0
801077b7:	6a 00                	push   $0x0
  pushl $224
801077b9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801077be:	e9 47 ef ff ff       	jmp    8010670a <alltraps>

801077c3 <vector225>:
.globl vector225
vector225:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $225
801077c5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801077ca:	e9 3b ef ff ff       	jmp    8010670a <alltraps>

801077cf <vector226>:
.globl vector226
vector226:
  pushl $0
801077cf:	6a 00                	push   $0x0
  pushl $226
801077d1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801077d6:	e9 2f ef ff ff       	jmp    8010670a <alltraps>

801077db <vector227>:
.globl vector227
vector227:
  pushl $0
801077db:	6a 00                	push   $0x0
  pushl $227
801077dd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801077e2:	e9 23 ef ff ff       	jmp    8010670a <alltraps>

801077e7 <vector228>:
.globl vector228
vector228:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $228
801077e9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801077ee:	e9 17 ef ff ff       	jmp    8010670a <alltraps>

801077f3 <vector229>:
.globl vector229
vector229:
  pushl $0
801077f3:	6a 00                	push   $0x0
  pushl $229
801077f5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801077fa:	e9 0b ef ff ff       	jmp    8010670a <alltraps>

801077ff <vector230>:
.globl vector230
vector230:
  pushl $0
801077ff:	6a 00                	push   $0x0
  pushl $230
80107801:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107806:	e9 ff ee ff ff       	jmp    8010670a <alltraps>

8010780b <vector231>:
.globl vector231
vector231:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $231
8010780d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107812:	e9 f3 ee ff ff       	jmp    8010670a <alltraps>

80107817 <vector232>:
.globl vector232
vector232:
  pushl $0
80107817:	6a 00                	push   $0x0
  pushl $232
80107819:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010781e:	e9 e7 ee ff ff       	jmp    8010670a <alltraps>

80107823 <vector233>:
.globl vector233
vector233:
  pushl $0
80107823:	6a 00                	push   $0x0
  pushl $233
80107825:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010782a:	e9 db ee ff ff       	jmp    8010670a <alltraps>

8010782f <vector234>:
.globl vector234
vector234:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $234
80107831:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107836:	e9 cf ee ff ff       	jmp    8010670a <alltraps>

8010783b <vector235>:
.globl vector235
vector235:
  pushl $0
8010783b:	6a 00                	push   $0x0
  pushl $235
8010783d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107842:	e9 c3 ee ff ff       	jmp    8010670a <alltraps>

80107847 <vector236>:
.globl vector236
vector236:
  pushl $0
80107847:	6a 00                	push   $0x0
  pushl $236
80107849:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010784e:	e9 b7 ee ff ff       	jmp    8010670a <alltraps>

80107853 <vector237>:
.globl vector237
vector237:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $237
80107855:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010785a:	e9 ab ee ff ff       	jmp    8010670a <alltraps>

8010785f <vector238>:
.globl vector238
vector238:
  pushl $0
8010785f:	6a 00                	push   $0x0
  pushl $238
80107861:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107866:	e9 9f ee ff ff       	jmp    8010670a <alltraps>

8010786b <vector239>:
.globl vector239
vector239:
  pushl $0
8010786b:	6a 00                	push   $0x0
  pushl $239
8010786d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107872:	e9 93 ee ff ff       	jmp    8010670a <alltraps>

80107877 <vector240>:
.globl vector240
vector240:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $240
80107879:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010787e:	e9 87 ee ff ff       	jmp    8010670a <alltraps>

80107883 <vector241>:
.globl vector241
vector241:
  pushl $0
80107883:	6a 00                	push   $0x0
  pushl $241
80107885:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010788a:	e9 7b ee ff ff       	jmp    8010670a <alltraps>

8010788f <vector242>:
.globl vector242
vector242:
  pushl $0
8010788f:	6a 00                	push   $0x0
  pushl $242
80107891:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107896:	e9 6f ee ff ff       	jmp    8010670a <alltraps>

8010789b <vector243>:
.globl vector243
vector243:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $243
8010789d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801078a2:	e9 63 ee ff ff       	jmp    8010670a <alltraps>

801078a7 <vector244>:
.globl vector244
vector244:
  pushl $0
801078a7:	6a 00                	push   $0x0
  pushl $244
801078a9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801078ae:	e9 57 ee ff ff       	jmp    8010670a <alltraps>

801078b3 <vector245>:
.globl vector245
vector245:
  pushl $0
801078b3:	6a 00                	push   $0x0
  pushl $245
801078b5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801078ba:	e9 4b ee ff ff       	jmp    8010670a <alltraps>

801078bf <vector246>:
.globl vector246
vector246:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $246
801078c1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801078c6:	e9 3f ee ff ff       	jmp    8010670a <alltraps>

801078cb <vector247>:
.globl vector247
vector247:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $247
801078cd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801078d2:	e9 33 ee ff ff       	jmp    8010670a <alltraps>

801078d7 <vector248>:
.globl vector248
vector248:
  pushl $0
801078d7:	6a 00                	push   $0x0
  pushl $248
801078d9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801078de:	e9 27 ee ff ff       	jmp    8010670a <alltraps>

801078e3 <vector249>:
.globl vector249
vector249:
  pushl $0
801078e3:	6a 00                	push   $0x0
  pushl $249
801078e5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801078ea:	e9 1b ee ff ff       	jmp    8010670a <alltraps>

801078ef <vector250>:
.globl vector250
vector250:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $250
801078f1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801078f6:	e9 0f ee ff ff       	jmp    8010670a <alltraps>

801078fb <vector251>:
.globl vector251
vector251:
  pushl $0
801078fb:	6a 00                	push   $0x0
  pushl $251
801078fd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107902:	e9 03 ee ff ff       	jmp    8010670a <alltraps>

80107907 <vector252>:
.globl vector252
vector252:
  pushl $0
80107907:	6a 00                	push   $0x0
  pushl $252
80107909:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010790e:	e9 f7 ed ff ff       	jmp    8010670a <alltraps>

80107913 <vector253>:
.globl vector253
vector253:
  pushl $0
80107913:	6a 00                	push   $0x0
  pushl $253
80107915:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010791a:	e9 eb ed ff ff       	jmp    8010670a <alltraps>

8010791f <vector254>:
.globl vector254
vector254:
  pushl $0
8010791f:	6a 00                	push   $0x0
  pushl $254
80107921:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107926:	e9 df ed ff ff       	jmp    8010670a <alltraps>

8010792b <vector255>:
.globl vector255
vector255:
  pushl $0
8010792b:	6a 00                	push   $0x0
  pushl $255
8010792d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107932:	e9 d3 ed ff ff       	jmp    8010670a <alltraps>
80107937:	66 90                	xchg   %ax,%ax
80107939:	66 90                	xchg   %ax,%ax
8010793b:	66 90                	xchg   %ax,%ax
8010793d:	66 90                	xchg   %ax,%ax
8010793f:	90                   	nop

80107940 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107946:	89 d3                	mov    %edx,%ebx
{
80107948:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010794a:	c1 eb 16             	shr    $0x16,%ebx
8010794d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107950:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107953:	8b 06                	mov    (%esi),%eax
80107955:	a8 01                	test   $0x1,%al
80107957:	74 27                	je     80107980 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107959:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010795e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107964:	c1 ef 0a             	shr    $0xa,%edi
}
80107967:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010796a:	89 fa                	mov    %edi,%edx
8010796c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107972:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107975:	5b                   	pop    %ebx
80107976:	5e                   	pop    %esi
80107977:	5f                   	pop    %edi
80107978:	5d                   	pop    %ebp
80107979:	c3                   	ret    
8010797a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107980:	85 c9                	test   %ecx,%ecx
80107982:	74 2c                	je     801079b0 <walkpgdir+0x70>
80107984:	e8 b7 b1 ff ff       	call   80102b40 <kalloc>
80107989:	85 c0                	test   %eax,%eax
8010798b:	89 c3                	mov    %eax,%ebx
8010798d:	74 21                	je     801079b0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010798f:	83 ec 04             	sub    $0x4,%esp
80107992:	68 00 10 00 00       	push   $0x1000
80107997:	6a 00                	push   $0x0
80107999:	50                   	push   %eax
8010799a:	e8 21 db ff ff       	call   801054c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010799f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079a5:	83 c4 10             	add    $0x10,%esp
801079a8:	83 c8 07             	or     $0x7,%eax
801079ab:	89 06                	mov    %eax,(%esi)
801079ad:	eb b5                	jmp    80107964 <walkpgdir+0x24>
801079af:	90                   	nop
}
801079b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801079b3:	31 c0                	xor    %eax,%eax
}
801079b5:	5b                   	pop    %ebx
801079b6:	5e                   	pop    %esi
801079b7:	5f                   	pop    %edi
801079b8:	5d                   	pop    %ebp
801079b9:	c3                   	ret    
801079ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079c0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801079c6:	89 d3                	mov    %edx,%ebx
801079c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801079ce:	83 ec 1c             	sub    $0x1c,%esp
801079d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801079d4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801079d8:	8b 7d 08             	mov    0x8(%ebp),%edi
801079db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801079e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801079e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801079e6:	29 df                	sub    %ebx,%edi
801079e8:	83 c8 01             	or     $0x1,%eax
801079eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801079ee:	eb 15                	jmp    80107a05 <mappages+0x45>
    if(*pte & PTE_P)
801079f0:	f6 00 01             	testb  $0x1,(%eax)
801079f3:	75 45                	jne    80107a3a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801079f5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801079f8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801079fb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801079fd:	74 31                	je     80107a30 <mappages+0x70>
      break;
    a += PGSIZE;
801079ff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a08:	b9 01 00 00 00       	mov    $0x1,%ecx
80107a0d:	89 da                	mov    %ebx,%edx
80107a0f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107a12:	e8 29 ff ff ff       	call   80107940 <walkpgdir>
80107a17:	85 c0                	test   %eax,%eax
80107a19:	75 d5                	jne    801079f0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107a1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a23:	5b                   	pop    %ebx
80107a24:	5e                   	pop    %esi
80107a25:	5f                   	pop    %edi
80107a26:	5d                   	pop    %ebp
80107a27:	c3                   	ret    
80107a28:	90                   	nop
80107a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a33:	31 c0                	xor    %eax,%eax
}
80107a35:	5b                   	pop    %ebx
80107a36:	5e                   	pop    %esi
80107a37:	5f                   	pop    %edi
80107a38:	5d                   	pop    %ebp
80107a39:	c3                   	ret    
      panic("remap");
80107a3a:	83 ec 0c             	sub    $0xc,%esp
80107a3d:	68 08 92 10 80       	push   $0x80109208
80107a42:	e8 49 89 ff ff       	call   80100390 <panic>
80107a47:	89 f6                	mov    %esi,%esi
80107a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a50 <seginit>:
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107a56:	e8 e5 c5 ff ff       	call   80104040 <cpuid>
80107a5b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107a61:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107a66:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a6a:	c7 80 18 48 18 80 ff 	movl   $0xffff,-0x7fe7b7e8(%eax)
80107a71:	ff 00 00 
80107a74:	c7 80 1c 48 18 80 00 	movl   $0xcf9a00,-0x7fe7b7e4(%eax)
80107a7b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107a7e:	c7 80 20 48 18 80 ff 	movl   $0xffff,-0x7fe7b7e0(%eax)
80107a85:	ff 00 00 
80107a88:	c7 80 24 48 18 80 00 	movl   $0xcf9200,-0x7fe7b7dc(%eax)
80107a8f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107a92:	c7 80 28 48 18 80 ff 	movl   $0xffff,-0x7fe7b7d8(%eax)
80107a99:	ff 00 00 
80107a9c:	c7 80 2c 48 18 80 00 	movl   $0xcffa00,-0x7fe7b7d4(%eax)
80107aa3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107aa6:	c7 80 30 48 18 80 ff 	movl   $0xffff,-0x7fe7b7d0(%eax)
80107aad:	ff 00 00 
80107ab0:	c7 80 34 48 18 80 00 	movl   $0xcff200,-0x7fe7b7cc(%eax)
80107ab7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107aba:	05 10 48 18 80       	add    $0x80184810,%eax
  pd[1] = (uint)p;
80107abf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107ac3:	c1 e8 10             	shr    $0x10,%eax
80107ac6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107aca:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107acd:	0f 01 10             	lgdtl  (%eax)
}
80107ad0:	c9                   	leave  
80107ad1:	c3                   	ret    
80107ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ae0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107ae0:	a1 14 3c 1a 80       	mov    0x801a3c14,%eax
{
80107ae5:	55                   	push   %ebp
80107ae6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107ae8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107aed:	0f 22 d8             	mov    %eax,%cr3
}
80107af0:	5d                   	pop    %ebp
80107af1:	c3                   	ret    
80107af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b00 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107b00:	55                   	push   %ebp
80107b01:	89 e5                	mov    %esp,%ebp
80107b03:	57                   	push   %edi
80107b04:	56                   	push   %esi
80107b05:	53                   	push   %ebx
80107b06:	83 ec 1c             	sub    $0x1c,%esp
80107b09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80107b0c:	85 db                	test   %ebx,%ebx
80107b0e:	0f 84 cb 00 00 00    	je     80107bdf <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107b14:	8b 43 08             	mov    0x8(%ebx),%eax
80107b17:	85 c0                	test   %eax,%eax
80107b19:	0f 84 da 00 00 00    	je     80107bf9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107b1f:	8b 43 04             	mov    0x4(%ebx),%eax
80107b22:	85 c0                	test   %eax,%eax
80107b24:	0f 84 c2 00 00 00    	je     80107bec <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
80107b2a:	e8 b1 d7 ff ff       	call   801052e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b2f:	e8 8c c4 ff ff       	call   80103fc0 <mycpu>
80107b34:	89 c6                	mov    %eax,%esi
80107b36:	e8 85 c4 ff ff       	call   80103fc0 <mycpu>
80107b3b:	89 c7                	mov    %eax,%edi
80107b3d:	e8 7e c4 ff ff       	call   80103fc0 <mycpu>
80107b42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b45:	83 c7 08             	add    $0x8,%edi
80107b48:	e8 73 c4 ff ff       	call   80103fc0 <mycpu>
80107b4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b50:	83 c0 08             	add    $0x8,%eax
80107b53:	ba 67 00 00 00       	mov    $0x67,%edx
80107b58:	c1 e8 18             	shr    $0x18,%eax
80107b5b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107b62:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107b69:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b6f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b74:	83 c1 08             	add    $0x8,%ecx
80107b77:	c1 e9 10             	shr    $0x10,%ecx
80107b7a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107b80:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107b85:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b8c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107b91:	e8 2a c4 ff ff       	call   80103fc0 <mycpu>
80107b96:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b9d:	e8 1e c4 ff ff       	call   80103fc0 <mycpu>
80107ba2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107ba6:	8b 73 08             	mov    0x8(%ebx),%esi
80107ba9:	e8 12 c4 ff ff       	call   80103fc0 <mycpu>
80107bae:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107bb4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107bb7:	e8 04 c4 ff ff       	call   80103fc0 <mycpu>
80107bbc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107bc0:	b8 28 00 00 00       	mov    $0x28,%eax
80107bc5:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107bc8:	8b 43 04             	mov    0x4(%ebx),%eax
80107bcb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bd0:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bd6:	5b                   	pop    %ebx
80107bd7:	5e                   	pop    %esi
80107bd8:	5f                   	pop    %edi
80107bd9:	5d                   	pop    %ebp
  popcli();
80107bda:	e9 41 d7 ff ff       	jmp    80105320 <popcli>
    panic("switchuvm: no process");
80107bdf:	83 ec 0c             	sub    $0xc,%esp
80107be2:	68 0e 92 10 80       	push   $0x8010920e
80107be7:	e8 a4 87 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107bec:	83 ec 0c             	sub    $0xc,%esp
80107bef:	68 39 92 10 80       	push   $0x80109239
80107bf4:	e8 97 87 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107bf9:	83 ec 0c             	sub    $0xc,%esp
80107bfc:	68 24 92 10 80       	push   $0x80109224
80107c01:	e8 8a 87 ff ff       	call   80100390 <panic>
80107c06:	8d 76 00             	lea    0x0(%esi),%esi
80107c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c10 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107c10:	55                   	push   %ebp
80107c11:	89 e5                	mov    %esp,%ebp
80107c13:	57                   	push   %edi
80107c14:	56                   	push   %esi
80107c15:	53                   	push   %ebx
80107c16:	83 ec 1c             	sub    $0x1c,%esp
80107c19:	8b 75 10             	mov    0x10(%ebp),%esi
80107c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107c1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107c22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107c28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107c2b:	77 49                	ja     80107c76 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80107c2d:	e8 0e af ff ff       	call   80102b40 <kalloc>
/** after initializing, one link is established**/
  //acquire(&lock);
  //pg_refcount[V2P(mem) >>PTXSHIFT] = pg_refcount[V2P(mem)>> PTXSHIFT] + 1 ; //for COW
  //release(&lock);
  memset(mem, 0, PGSIZE);
80107c32:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107c35:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107c37:	68 00 10 00 00       	push   $0x1000
80107c3c:	6a 00                	push   $0x0
80107c3e:	50                   	push   %eax
80107c3f:	e8 7c d8 ff ff       	call   801054c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107c44:	58                   	pop    %eax
80107c45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c50:	5a                   	pop    %edx
80107c51:	6a 06                	push   $0x6
80107c53:	50                   	push   %eax
80107c54:	31 d2                	xor    %edx,%edx
80107c56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c59:	e8 62 fd ff ff       	call   801079c0 <mappages>
  memmove(mem, init, sz);
80107c5e:	89 75 10             	mov    %esi,0x10(%ebp)
80107c61:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107c64:	83 c4 10             	add    $0x10,%esp
80107c67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c6d:	5b                   	pop    %ebx
80107c6e:	5e                   	pop    %esi
80107c6f:	5f                   	pop    %edi
80107c70:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107c71:	e9 fa d8 ff ff       	jmp    80105570 <memmove>
    panic("inituvm: more than a page");
80107c76:	83 ec 0c             	sub    $0xc,%esp
80107c79:	68 4d 92 10 80       	push   $0x8010924d
80107c7e:	e8 0d 87 ff ff       	call   80100390 <panic>
80107c83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c90 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107c90:	55                   	push   %ebp
80107c91:	89 e5                	mov    %esp,%ebp
80107c93:	57                   	push   %edi
80107c94:	56                   	push   %esi
80107c95:	53                   	push   %ebx
80107c96:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107c99:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107ca0:	0f 85 91 00 00 00    	jne    80107d37 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107ca6:	8b 75 18             	mov    0x18(%ebp),%esi
80107ca9:	31 db                	xor    %ebx,%ebx
80107cab:	85 f6                	test   %esi,%esi
80107cad:	75 1a                	jne    80107cc9 <loaduvm+0x39>
80107caf:	eb 6f                	jmp    80107d20 <loaduvm+0x90>
80107cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cb8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107cbe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107cc4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107cc7:	76 57                	jbe    80107d20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80107ccf:	31 c9                	xor    %ecx,%ecx
80107cd1:	01 da                	add    %ebx,%edx
80107cd3:	e8 68 fc ff ff       	call   80107940 <walkpgdir>
80107cd8:	85 c0                	test   %eax,%eax
80107cda:	74 4e                	je     80107d2a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107cdc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cde:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107ce1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107ce6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107ceb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107cf1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cf4:	01 d9                	add    %ebx,%ecx
80107cf6:	05 00 00 00 80       	add    $0x80000000,%eax
80107cfb:	57                   	push   %edi
80107cfc:	51                   	push   %ecx
80107cfd:	50                   	push   %eax
80107cfe:	ff 75 10             	pushl  0x10(%ebp)
80107d01:	e8 3a 9f ff ff       	call   80101c40 <readi>
80107d06:	83 c4 10             	add    $0x10,%esp
80107d09:	39 f8                	cmp    %edi,%eax
80107d0b:	74 ab                	je     80107cb8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d15:	5b                   	pop    %ebx
80107d16:	5e                   	pop    %esi
80107d17:	5f                   	pop    %edi
80107d18:	5d                   	pop    %ebp
80107d19:	c3                   	ret    
80107d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d23:	31 c0                	xor    %eax,%eax
}
80107d25:	5b                   	pop    %ebx
80107d26:	5e                   	pop    %esi
80107d27:	5f                   	pop    %edi
80107d28:	5d                   	pop    %ebp
80107d29:	c3                   	ret    
      panic("loaduvm: address should exist");
80107d2a:	83 ec 0c             	sub    $0xc,%esp
80107d2d:	68 67 92 10 80       	push   $0x80109267
80107d32:	e8 59 86 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107d37:	83 ec 0c             	sub    $0xc,%esp
80107d3a:	68 38 93 10 80       	push   $0x80109338
80107d3f:	e8 4c 86 ff ff       	call   80100390 <panic>
80107d44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107d50 <deallocuvm>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
//the flag was added for ASSIGNMENT 3 in order to know whether we need to call deallocatepages or not (depends on whether allocation succeeded or not)
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int flag)
{
80107d50:	55                   	push   %ebp
80107d51:	89 e5                	mov    %esp,%ebp
80107d53:	57                   	push   %edi
80107d54:	56                   	push   %esi
80107d55:	53                   	push   %ebx
80107d56:	83 ec 1c             	sub    $0x1c,%esp
80107d59:	8b 75 0c             	mov    0xc(%ebp),%esi
  #if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
    struct proc* curproc = myproc();
80107d5c:	e8 ff c2 ff ff       	call   80104060 <myproc>
  #endif
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107d61:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d64:	0f 83 d6 00 00 00    	jae    80107e40 <deallocuvm+0xf0>
80107d6a:	89 c7                	mov    %eax,%edi
    return oldsz;

  a = PGROUNDUP(newsz);
80107d6c:	8b 45 10             	mov    0x10(%ebp),%eax
80107d6f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107d75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107d7b:	39 de                	cmp    %ebx,%esi
80107d7d:	77 4a                	ja     80107dc9 <deallocuvm+0x79>
80107d7f:	e9 85 00 00 00       	jmp    80107e09 <deallocuvm+0xb9>
80107d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107d88:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107d8e:	0f 84 d0 00 00 00    	je     80107e64 <deallocuvm+0x114>
        panic("kfree");

#if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
      if(curproc->pid > 2 && flag)  // the flag indicates if we should to deallocate the pages as well. in this case, we should!
80107d94:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107d98:	7e 07                	jle    80107da1 <deallocuvm+0x51>
80107d9a:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107d9d:	85 c9                	test   %ecx,%ecx
80107d9f:	75 7f                	jne    80107e20 <deallocuvm+0xd0>
        deallocate_page(a);
#endif
    char *va = P2V(pa);
    kfree(va);
80107da1:	83 ec 0c             	sub    $0xc,%esp
    char *va = P2V(pa);
80107da4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107daa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    kfree(va);
80107dad:	52                   	push   %edx
80107dae:	e8 cd ab ff ff       	call   80102980 <kfree>
    *pte = 0;
80107db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107db6:	83 c4 10             	add    $0x10,%esp
80107db9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107dbf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107dc5:	39 de                	cmp    %ebx,%esi
80107dc7:	76 40                	jbe    80107e09 <deallocuvm+0xb9>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107dc9:	8b 45 08             	mov    0x8(%ebp),%eax
80107dcc:	31 c9                	xor    %ecx,%ecx
80107dce:	89 da                	mov    %ebx,%edx
80107dd0:	e8 6b fb ff ff       	call   80107940 <walkpgdir>
    if(!pte)
80107dd5:	85 c0                	test   %eax,%eax
80107dd7:	74 3f                	je     80107e18 <deallocuvm+0xc8>
    else if((*pte & PTE_P) != 0){
80107dd9:	8b 10                	mov    (%eax),%edx
80107ddb:	f6 c2 01             	test   $0x1,%dl
80107dde:	75 a8                	jne    80107d88 <deallocuvm+0x38>
    }
    else{
#if(defined(NFUA) || defined(LAPA) || defined(SCFIFO) || defined(AQ))
        if(curproc->pid > 2 && ((*pte & PTE_PG) != 0)){
80107de0:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107de4:	7e d9                	jle    80107dbf <deallocuvm+0x6f>
80107de6:	f6 c6 02             	test   $0x2,%dh
80107de9:	74 d4                	je     80107dbf <deallocuvm+0x6f>
          pa = PTE_ADDR(*pte);
          if(pa == 0)
80107deb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107df1:	74 7e                	je     80107e71 <deallocuvm+0x121>
            panic("in deallocuvm: no such address!");
          if(curproc->pid > 2 && flag == 1)
80107df3:	83 7d 14 01          	cmpl   $0x1,0x14(%ebp)
80107df7:	74 57                	je     80107e50 <deallocuvm+0x100>
  for(; a  < oldsz; a += PGSIZE){
80107df9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
            deallocate_page(a);
          *pte = 0;
80107dff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107e05:	39 de                	cmp    %ebx,%esi
80107e07:	77 c0                	ja     80107dc9 <deallocuvm+0x79>

  
     
     
  }
  return newsz;
80107e09:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e0f:	5b                   	pop    %ebx
80107e10:	5e                   	pop    %esi
80107e11:	5f                   	pop    %edi
80107e12:	5d                   	pop    %ebp
80107e13:	c3                   	ret    
80107e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      a += (NPTENTRIES - 1) * PGSIZE;
80107e18:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80107e1e:	eb 9f                	jmp    80107dbf <deallocuvm+0x6f>
        deallocate_page(a);
80107e20:	83 ec 0c             	sub    $0xc,%esp
80107e23:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107e26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e29:	53                   	push   %ebx
80107e2a:	e8 a1 ce ff ff       	call   80104cd0 <deallocate_page>
80107e2f:	83 c4 10             	add    $0x10,%esp
80107e32:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e38:	e9 64 ff ff ff       	jmp    80107da1 <deallocuvm+0x51>
80107e3d:	8d 76 00             	lea    0x0(%esi),%esi
}
80107e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return oldsz;
80107e43:	89 f0                	mov    %esi,%eax
}
80107e45:	5b                   	pop    %ebx
80107e46:	5e                   	pop    %esi
80107e47:	5f                   	pop    %edi
80107e48:	5d                   	pop    %ebp
80107e49:	c3                   	ret    
80107e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            deallocate_page(a);
80107e50:	83 ec 0c             	sub    $0xc,%esp
80107e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e56:	53                   	push   %ebx
80107e57:	e8 74 ce ff ff       	call   80104cd0 <deallocate_page>
80107e5c:	83 c4 10             	add    $0x10,%esp
80107e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e62:	eb 95                	jmp    80107df9 <deallocuvm+0xa9>
        panic("kfree");
80107e64:	83 ec 0c             	sub    $0xc,%esp
80107e67:	68 6a 8a 10 80       	push   $0x80108a6a
80107e6c:	e8 1f 85 ff ff       	call   80100390 <panic>
            panic("in deallocuvm: no such address!");
80107e71:	83 ec 0c             	sub    $0xc,%esp
80107e74:	68 5c 93 10 80       	push   $0x8010935c
80107e79:	e8 12 85 ff ff       	call   80100390 <panic>
80107e7e:	66 90                	xchg   %ax,%ax

80107e80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	57                   	push   %edi
80107e84:	56                   	push   %esi
80107e85:	53                   	push   %ebx
80107e86:	83 ec 0c             	sub    $0xc,%esp
80107e89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107e8c:	85 f6                	test   %esi,%esi
80107e8e:	74 59                	je     80107ee9 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0, 0);  // no need to call deallocate_page
80107e90:	6a 00                	push   $0x0
80107e92:	6a 00                	push   $0x0
80107e94:	89 f3                	mov    %esi,%ebx
80107e96:	68 00 00 00 80       	push   $0x80000000
80107e9b:	56                   	push   %esi
80107e9c:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107ea2:	e8 a9 fe ff ff       	call   80107d50 <deallocuvm>
80107ea7:	83 c4 10             	add    $0x10,%esp
80107eaa:	eb 0b                	jmp    80107eb7 <freevm+0x37>
80107eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107eb0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107eb3:	39 fb                	cmp    %edi,%ebx
80107eb5:	74 23                	je     80107eda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107eb7:	8b 03                	mov    (%ebx),%eax
80107eb9:	a8 01                	test   $0x1,%al
80107ebb:	74 f3                	je     80107eb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ebd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107ec2:	83 ec 0c             	sub    $0xc,%esp
80107ec5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ec8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107ecd:	50                   	push   %eax
80107ece:	e8 ad aa ff ff       	call   80102980 <kfree>
80107ed3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107ed6:	39 fb                	cmp    %edi,%ebx
80107ed8:	75 dd                	jne    80107eb7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107eda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ee0:	5b                   	pop    %ebx
80107ee1:	5e                   	pop    %esi
80107ee2:	5f                   	pop    %edi
80107ee3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107ee4:	e9 97 aa ff ff       	jmp    80102980 <kfree>
    panic("freevm: no pgdir");
80107ee9:	83 ec 0c             	sub    $0xc,%esp
80107eec:	68 85 92 10 80       	push   $0x80109285
80107ef1:	e8 9a 84 ff ff       	call   80100390 <panic>
80107ef6:	8d 76 00             	lea    0x0(%esi),%esi
80107ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f00 <setupkvm>:
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	56                   	push   %esi
80107f04:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107f05:	e8 36 ac ff ff       	call   80102b40 <kalloc>
80107f0a:	85 c0                	test   %eax,%eax
80107f0c:	89 c6                	mov    %eax,%esi
80107f0e:	74 42                	je     80107f52 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107f10:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f13:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107f18:	68 00 10 00 00       	push   $0x1000
80107f1d:	6a 00                	push   $0x0
80107f1f:	50                   	push   %eax
80107f20:	e8 9b d5 ff ff       	call   801054c0 <memset>
80107f25:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107f28:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107f2b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107f2e:	83 ec 08             	sub    $0x8,%esp
80107f31:	8b 13                	mov    (%ebx),%edx
80107f33:	ff 73 0c             	pushl  0xc(%ebx)
80107f36:	50                   	push   %eax
80107f37:	29 c1                	sub    %eax,%ecx
80107f39:	89 f0                	mov    %esi,%eax
80107f3b:	e8 80 fa ff ff       	call   801079c0 <mappages>
80107f40:	83 c4 10             	add    $0x10,%esp
80107f43:	85 c0                	test   %eax,%eax
80107f45:	78 19                	js     80107f60 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f47:	83 c3 10             	add    $0x10,%ebx
80107f4a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107f50:	75 d6                	jne    80107f28 <setupkvm+0x28>
}
80107f52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107f55:	89 f0                	mov    %esi,%eax
80107f57:	5b                   	pop    %ebx
80107f58:	5e                   	pop    %esi
80107f59:	5d                   	pop    %ebp
80107f5a:	c3                   	ret    
80107f5b:	90                   	nop
80107f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107f60:	83 ec 0c             	sub    $0xc,%esp
80107f63:	56                   	push   %esi
      return 0;
80107f64:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107f66:	e8 15 ff ff ff       	call   80107e80 <freevm>
      return 0;
80107f6b:	83 c4 10             	add    $0x10,%esp
}
80107f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107f71:	89 f0                	mov    %esi,%eax
80107f73:	5b                   	pop    %ebx
80107f74:	5e                   	pop    %esi
80107f75:	5d                   	pop    %ebp
80107f76:	c3                   	ret    
80107f77:	89 f6                	mov    %esi,%esi
80107f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f80 <kvmalloc>:
{
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107f86:	e8 75 ff ff ff       	call   80107f00 <setupkvm>
80107f8b:	a3 14 3c 1a 80       	mov    %eax,0x801a3c14
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107f90:	05 00 00 00 80       	add    $0x80000000,%eax
80107f95:	0f 22 d8             	mov    %eax,%cr3
}
80107f98:	c9                   	leave  
80107f99:	c3                   	ret    
80107f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107fa0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107fa0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107fa1:	31 c9                	xor    %ecx,%ecx
{
80107fa3:	89 e5                	mov    %esp,%ebp
80107fa5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fab:	8b 45 08             	mov    0x8(%ebp),%eax
80107fae:	e8 8d f9 ff ff       	call   80107940 <walkpgdir>
  if(pte == 0)
80107fb3:	85 c0                	test   %eax,%eax
80107fb5:	74 05                	je     80107fbc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107fb7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107fba:	c9                   	leave  
80107fbb:	c3                   	ret    
    panic("clearpteu");
80107fbc:	83 ec 0c             	sub    $0xc,%esp
80107fbf:	68 96 92 10 80       	push   $0x80109296
80107fc4:	e8 c7 83 ff ff       	call   80100390 <panic>
80107fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107fd0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107fd0:	55                   	push   %ebp
80107fd1:	89 e5                	mov    %esp,%ebp
80107fd3:	57                   	push   %edi
80107fd4:	56                   	push   %esi
80107fd5:	53                   	push   %ebx
80107fd6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107fd9:	e8 22 ff ff ff       	call   80107f00 <setupkvm>
80107fde:	85 c0                	test   %eax,%eax
80107fe0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107fe3:	0f 84 ab 00 00 00    	je     80108094 <copyuvm+0xc4>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107fe9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107fec:	85 c9                	test   %ecx,%ecx
80107fee:	0f 84 ac 00 00 00    	je     801080a0 <copyuvm+0xd0>
80107ff4:	31 f6                	xor    %esi,%esi
80107ff6:	eb 4e                	jmp    80108046 <copyuvm+0x76>
80107ff8:	90                   	nop
80107ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108000:	83 ec 04             	sub    $0x4,%esp
80108003:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010800c:	68 00 10 00 00       	push   $0x1000
80108011:	57                   	push   %edi
80108012:	50                   	push   %eax
80108013:	e8 58 d5 ff ff       	call   80105570 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108018:	58                   	pop    %eax
80108019:	5a                   	pop    %edx
8010801a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010801d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108020:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108025:	53                   	push   %ebx
80108026:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010802c:	52                   	push   %edx
8010802d:	89 f2                	mov    %esi,%edx
8010802f:	e8 8c f9 ff ff       	call   801079c0 <mappages>
80108034:	83 c4 10             	add    $0x10,%esp
80108037:	85 c0                	test   %eax,%eax
80108039:	78 39                	js     80108074 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010803b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108041:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108044:	76 5a                	jbe    801080a0 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108046:	8b 45 08             	mov    0x8(%ebp),%eax
80108049:	31 c9                	xor    %ecx,%ecx
8010804b:	89 f2                	mov    %esi,%edx
8010804d:	e8 ee f8 ff ff       	call   80107940 <walkpgdir>
80108052:	85 c0                	test   %eax,%eax
80108054:	74 6d                	je     801080c3 <copyuvm+0xf3>
    if(!(*pte & PTE_P))
80108056:	8b 18                	mov    (%eax),%ebx
80108058:	f6 c3 01             	test   $0x1,%bl
8010805b:	74 59                	je     801080b6 <copyuvm+0xe6>
    pa = PTE_ADDR(*pte);
8010805d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010805f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80108065:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010806b:	e8 d0 aa ff ff       	call   80102b40 <kalloc>
80108070:	85 c0                	test   %eax,%eax
80108072:	75 8c                	jne    80108000 <copyuvm+0x30>
  }
  lcr3(V2P(pgdir));
  return d;

bad:
  freevm(d);
80108074:	83 ec 0c             	sub    $0xc,%esp
80108077:	ff 75 e0             	pushl  -0x20(%ebp)
8010807a:	e8 01 fe ff ff       	call   80107e80 <freevm>
  lcr3(V2P(pgdir));
8010807f:	8b 45 08             	mov    0x8(%ebp),%eax
80108082:	05 00 00 00 80       	add    $0x80000000,%eax
80108087:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010808a:	83 c4 10             	add    $0x10,%esp
8010808d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80108094:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010809a:	5b                   	pop    %ebx
8010809b:	5e                   	pop    %esi
8010809c:	5f                   	pop    %edi
8010809d:	5d                   	pop    %ebp
8010809e:	c3                   	ret    
8010809f:	90                   	nop
  lcr3(V2P(pgdir));
801080a0:	8b 45 08             	mov    0x8(%ebp),%eax
801080a3:	05 00 00 00 80       	add    $0x80000000,%eax
801080a8:	0f 22 d8             	mov    %eax,%cr3
}
801080ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080b1:	5b                   	pop    %ebx
801080b2:	5e                   	pop    %esi
801080b3:	5f                   	pop    %edi
801080b4:	5d                   	pop    %ebp
801080b5:	c3                   	ret    
      panic("copyuvm: page not present");
801080b6:	83 ec 0c             	sub    $0xc,%esp
801080b9:	68 ba 92 10 80       	push   $0x801092ba
801080be:	e8 cd 82 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801080c3:	83 ec 0c             	sub    $0xc,%esp
801080c6:	68 a0 92 10 80       	push   $0x801092a0
801080cb:	e8 c0 82 ff ff       	call   80100390 <panic>

801080d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801080d0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080d1:	31 c9                	xor    %ecx,%ecx
{
801080d3:	89 e5                	mov    %esp,%ebp
801080d5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801080d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801080db:	8b 45 08             	mov    0x8(%ebp),%eax
801080de:	e8 5d f8 ff ff       	call   80107940 <walkpgdir>
  if((*pte & PTE_P) == 0)
801080e3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801080e5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801080e6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801080e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801080ed:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801080f0:	05 00 00 00 80       	add    $0x80000000,%eax
801080f5:	83 fa 05             	cmp    $0x5,%edx
801080f8:	ba 00 00 00 00       	mov    $0x0,%edx
801080fd:	0f 45 c2             	cmovne %edx,%eax
}
80108100:	c3                   	ret    
80108101:	eb 0d                	jmp    80108110 <copyout>
80108103:	90                   	nop
80108104:	90                   	nop
80108105:	90                   	nop
80108106:	90                   	nop
80108107:	90                   	nop
80108108:	90                   	nop
80108109:	90                   	nop
8010810a:	90                   	nop
8010810b:	90                   	nop
8010810c:	90                   	nop
8010810d:	90                   	nop
8010810e:	90                   	nop
8010810f:	90                   	nop

80108110 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108110:	55                   	push   %ebp
80108111:	89 e5                	mov    %esp,%ebp
80108113:	57                   	push   %edi
80108114:	56                   	push   %esi
80108115:	53                   	push   %ebx
80108116:	83 ec 1c             	sub    $0x1c,%esp
80108119:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010811c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010811f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108122:	85 db                	test   %ebx,%ebx
80108124:	75 40                	jne    80108166 <copyout+0x56>
80108126:	eb 70                	jmp    80108198 <copyout+0x88>
80108128:	90                   	nop
80108129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108130:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108133:	89 f1                	mov    %esi,%ecx
80108135:	29 d1                	sub    %edx,%ecx
80108137:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010813d:	39 d9                	cmp    %ebx,%ecx
8010813f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108142:	29 f2                	sub    %esi,%edx
80108144:	83 ec 04             	sub    $0x4,%esp
80108147:	01 d0                	add    %edx,%eax
80108149:	51                   	push   %ecx
8010814a:	57                   	push   %edi
8010814b:	50                   	push   %eax
8010814c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010814f:	e8 1c d4 ff ff       	call   80105570 <memmove>
    len -= n;
    buf += n;
80108154:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108157:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010815a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108160:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108162:	29 cb                	sub    %ecx,%ebx
80108164:	74 32                	je     80108198 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108166:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108168:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010816b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010816e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108174:	56                   	push   %esi
80108175:	ff 75 08             	pushl  0x8(%ebp)
80108178:	e8 53 ff ff ff       	call   801080d0 <uva2ka>
    if(pa0 == 0)
8010817d:	83 c4 10             	add    $0x10,%esp
80108180:	85 c0                	test   %eax,%eax
80108182:	75 ac                	jne    80108130 <copyout+0x20>
  }
  return 0;
}
80108184:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010818c:	5b                   	pop    %ebx
8010818d:	5e                   	pop    %esi
8010818e:	5f                   	pop    %edi
8010818f:	5d                   	pop    %ebp
80108190:	c3                   	ret    
80108191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010819b:	31 c0                	xor    %eax,%eax
}
8010819d:	5b                   	pop    %ebx
8010819e:	5e                   	pop    %esi
8010819f:	5f                   	pop    %edi
801081a0:	5d                   	pop    %ebp
801081a1:	c3                   	ret    
801081a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801081b0 <select_page>:

uint select_page(){ //depending on the policy, returns the address of the page that needs to be swapped
801081b0:	55                   	push   %ebp
801081b1:	89 e5                	mov    %esp,%ebp
801081b3:	53                   	push   %ebx
801081b4:	83 ec 04             	sub    $0x4,%esp
  struct proc* curproc = myproc();
801081b7:	e8 a4 be ff ff       	call   80104060 <myproc>
801081bc:	89 c3                	mov    %eax,%ebx
  #if defined(LAPA)
    page_to_return_index = select_for_LAPA();
  #endif

  #if defined(SCFIFO)
    page_to_return_index = select_for_SCFIFO();
801081be:	e8 5d cd ff ff       	call   80104f20 <select_for_SCFIFO>
  #endif

  #if defined(AQ)
    page_to_return_index = select_for_AQ();
  #endif
  uint final_page = curproc->pages[page_to_return_index].virtual_addr;
801081c3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  int k;
  for(k=0;k<MAX_TOTAL_PAGES;k++){
  }
  return final_page;
801081c6:	8b 84 c3 80 00 00 00 	mov    0x80(%ebx,%eax,8),%eax
}
801081cd:	83 c4 04             	add    $0x4,%esp
801081d0:	5b                   	pop    %ebx
801081d1:	5d                   	pop    %ebp
801081d2:	c3                   	ret    
801081d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801081d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801081e0 <swap_out>:

char* swap_out(pde_t* pgdir){
801081e0:	55                   	push   %ebp
801081e1:	89 e5                	mov    %esp,%ebp
801081e3:	57                   	push   %edi
801081e4:	56                   	push   %esi
801081e5:	53                   	push   %ebx
801081e6:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
801081e9:	e8 72 be ff ff       	call   80104060 <myproc>
801081ee:	89 c3                	mov    %eax,%ebx
  struct proc* curproc = myproc();
801081f0:	e8 6b be ff ff       	call   80104060 <myproc>
801081f5:	89 c6                	mov    %eax,%esi
    page_to_return_index = select_for_SCFIFO();
801081f7:	e8 24 cd ff ff       	call   80104f20 <select_for_SCFIFO>
  uint final_page = curproc->pages[page_to_return_index].virtual_addr;
801081fc:	8d 04 40             	lea    (%eax,%eax,2),%eax
801081ff:	8b b4 c6 80 00 00 00 	mov    0x80(%esi,%eax,8),%esi
  pte_t *pte;
  uint page_to_swap_addr =select_page();
  int offset_to_write = get_free_offset();
80108206:	e8 85 ca ff ff       	call   80104c90 <get_free_offset>
  writeToSwapFile(curproc, (char*) page_to_swap_addr, offset_to_write, PGSIZE); // write the page in the free space in the swap file
8010820b:	68 00 10 00 00       	push   $0x1000
80108210:	50                   	push   %eax
  int offset_to_write = get_free_offset();
80108211:	89 c7                	mov    %eax,%edi
  writeToSwapFile(curproc, (char*) page_to_swap_addr, offset_to_write, PGSIZE); // write the page in the free space in the swap file
80108213:	56                   	push   %esi
80108214:	53                   	push   %ebx
80108215:	e8 16 a3 ff ff       	call   80102530 <writeToSwapFile>
8010821a:	8d 8b 80 00 00 00    	lea    0x80(%ebx),%ecx
80108220:	83 c4 10             	add    $0x10,%esp

  int i = 0;
80108223:	31 c0                	xor    %eax,%eax
80108225:	eb 14                	jmp    8010823b <swap_out+0x5b>
80108227:	89 f6                	mov    %esi,%esi
80108229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while(i < MAX_TOTAL_PAGES &&curproc->pages[i].virtual_addr != page_to_swap_addr)
    i++;
80108230:	83 c0 01             	add    $0x1,%eax
80108233:	83 c1 18             	add    $0x18,%ecx
  while(i < MAX_TOTAL_PAGES &&curproc->pages[i].virtual_addr != page_to_swap_addr)
80108236:	83 f8 20             	cmp    $0x20,%eax
80108239:	74 04                	je     8010823f <swap_out+0x5f>
8010823b:	39 31                	cmp    %esi,(%ecx)
8010823d:	75 f1                	jne    80108230 <swap_out+0x50>

      /** we wrote it in the swap file, now we need to update it in the proc's pages array**/
      curproc->pages[i].offset_in_swapfile = offset_to_write;
8010823f:	8d 04 40             	lea    (%eax,%eax,2),%eax
      //curproc->pages[i].is_swapped = 1;
     
  curproc->swapped_pages_now++;
  curproc->total_swaps++;

  pte = walkpgdir(pgdir, (char *) page_to_swap_addr, 0); // getting the page table entry for this page
80108242:	31 c9                	xor    %ecx,%ecx
80108244:	89 f2                	mov    %esi,%edx
      curproc->pages[i].offset_in_swapfile = offset_to_write;
80108246:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
80108249:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
      curproc->pages[i].in_RAM = 0;
8010824f:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80108256:	00 00 00 
  curproc->swapped_pages_now++;
80108259:	83 83 0c 04 00 00 01 	addl   $0x1,0x40c(%ebx)
  curproc->total_swaps++;
80108260:	83 83 10 04 00 00 01 	addl   $0x1,0x410(%ebx)
  pte = walkpgdir(pgdir, (char *) page_to_swap_addr, 0); // getting the page table entry for this page
80108267:	8b 45 08             	mov    0x8(%ebp),%eax
8010826a:	e8 d1 f6 ff ff       	call   80107940 <walkpgdir>
  *pte = TURN_OFF_PTE_P(*pte); // the bit is not present anymore
8010826f:	8b 30                	mov    (%eax),%esi
  *pte = TURN_ON_PTE_PG(*pte); // paging has accured and the page is swapped
  uint p_address = PTE_ADDR(*pte);
  char* virtual_addr = P2V(p_address);
  kfree(virtual_addr); //opposite of malloc()- frees the memory of a desireable address
80108271:	83 ec 0c             	sub    $0xc,%esp
  *pte = TURN_OFF_PTE_P(*pte); // the bit is not present anymore
80108274:	89 f2                	mov    %esi,%edx
  char* virtual_addr = P2V(p_address);
80108276:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  *pte = TURN_OFF_PTE_P(*pte); // the bit is not present anymore
8010827c:	83 e2 fe             	and    $0xfffffffe,%edx
  char* virtual_addr = P2V(p_address);
8010827f:	81 c6 00 00 00 80    	add    $0x80000000,%esi
  *pte = TURN_ON_PTE_PG(*pte); // paging has accured and the page is swapped
80108285:	80 ce 02             	or     $0x2,%dh
80108288:	89 10                	mov    %edx,(%eax)
  kfree(virtual_addr); //opposite of malloc()- frees the memory of a desireable address
8010828a:	56                   	push   %esi
8010828b:	e8 f0 a6 ff ff       	call   80102980 <kfree>
  lcr3(V2P(curproc->pgdir)); // refreshing TLB==refreshing the CR3 register
80108290:	8b 43 04             	mov    0x4(%ebx),%eax
80108293:	05 00 00 00 80       	add    $0x80000000,%eax
80108298:	0f 22 d8             	mov    %eax,%cr3
  return virtual_addr;
}
8010829b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010829e:	89 f0                	mov    %esi,%eax
801082a0:	5b                   	pop    %ebx
801082a1:	5e                   	pop    %esi
801082a2:	5f                   	pop    %edi
801082a3:	5d                   	pop    %ebp
801082a4:	c3                   	ret    
801082a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801082b0 <allocuvm>:
{
801082b0:	55                   	push   %ebp
801082b1:	89 e5                	mov    %esp,%ebp
801082b3:	57                   	push   %edi
801082b4:	56                   	push   %esi
801082b5:	53                   	push   %ebx
801082b6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801082b9:	e8 a2 bd ff ff       	call   80104060 <myproc>
801082be:	89 c6                	mov    %eax,%esi
  if(newsz >= KERNBASE)
801082c0:	8b 45 10             	mov    0x10(%ebp),%eax
801082c3:	85 c0                	test   %eax,%eax
801082c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801082c8:	0f 88 7a 01 00 00    	js     80108448 <allocuvm+0x198>
  if(newsz < oldsz)
801082ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801082d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801082d4:	0f 82 06 01 00 00    	jb     801083e0 <allocuvm+0x130>
  a = PGROUNDUP(oldsz);
801082da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801082e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801082e6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801082e9:	77 14                	ja     801082ff <allocuvm+0x4f>
801082eb:	e9 f3 00 00 00       	jmp    801083e3 <allocuvm+0x133>
801082f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801082f6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801082f9:	0f 86 e4 00 00 00    	jbe    801083e3 <allocuvm+0x133>
      if((curproc->pid > 2) && (a >= PGSIZE * MAX_PYSC_PAGES)){ //we do not allow to have more than [PGSIZE * MAX_PYSC_PAGES] space for each proccess, except for the first 2 proccess (init and sh)
801082ff:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80108303:	7e 0c                	jle    80108311 <allocuvm+0x61>
80108305:	81 fb ff ff 00 00    	cmp    $0xffff,%ebx
8010830b:	0f 87 df 00 00 00    	ja     801083f0 <allocuvm+0x140>
    mem = kalloc();
80108311:	e8 2a a8 ff ff       	call   80102b40 <kalloc>
    if(mem == 0){
80108316:	85 c0                	test   %eax,%eax
    mem = kalloc();
80108318:	89 c7                	mov    %eax,%edi
    if(mem == 0){
8010831a:	0f 84 f0 00 00 00    	je     80108410 <allocuvm+0x160>
  memset(mem, 0, PGSIZE);
80108320:	83 ec 04             	sub    $0x4,%esp
80108323:	68 00 10 00 00       	push   $0x1000
80108328:	6a 00                	push   $0x0
8010832a:	50                   	push   %eax
8010832b:	e8 90 d1 ff ff       	call   801054c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108330:	58                   	pop    %eax
80108331:	5a                   	pop    %edx
80108332:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80108338:	8b 45 08             	mov    0x8(%ebp),%eax
8010833b:	6a 06                	push   $0x6
8010833d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108342:	52                   	push   %edx
80108343:	89 da                	mov    %ebx,%edx
80108345:	e8 76 f6 ff ff       	call   801079c0 <mappages>
8010834a:	83 c4 10             	add    $0x10,%esp
8010834d:	85 c0                	test   %eax,%eax
8010834f:	0f 88 0b 01 00 00    	js     80108460 <allocuvm+0x1b0>
      int page_index = 0;
80108355:	31 c0                	xor    %eax,%eax
    if(curproc->pid > 2) // again, this is only allowed for the first 2 proccess' (init and sh). any other proccess will get in the 'if'
80108357:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
8010835b:	8d 96 90 00 00 00    	lea    0x90(%esi),%edx
80108361:	7e 8d                	jle    801082f0 <allocuvm+0x40>
      while((page_index < MAX_TOTAL_PAGES) && (curproc->pages[page_index].allocated == 1))
80108363:	83 3a 01             	cmpl   $0x1,(%edx)
80108366:	75 18                	jne    80108380 <allocuvm+0xd0>
80108368:	90                   	nop
80108369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        page_index++;
80108370:	83 c0 01             	add    $0x1,%eax
80108373:	83 c2 18             	add    $0x18,%edx
      while((page_index < MAX_TOTAL_PAGES) && (curproc->pages[page_index].allocated == 1))
80108376:	83 f8 20             	cmp    $0x20,%eax
80108379:	74 05                	je     80108380 <allocuvm+0xd0>
8010837b:	83 3a 01             	cmpl   $0x1,(%edx)
8010837e:	74 f0                	je     80108370 <allocuvm+0xc0>
          curproc->pages[page_index].virtual_addr = a; 
80108380:	8d 14 40             	lea    (%eax,%eax,2),%edx
      insert_to_RAM_queue(page_index);
80108383:	83 ec 0c             	sub    $0xc,%esp
          curproc->pages[page_index].virtual_addr = a; 
80108386:	8d 14 d6             	lea    (%esi,%edx,8),%edx
80108389:	89 9a 80 00 00 00    	mov    %ebx,0x80(%edx)
          curproc->pages[page_index].allocated = 1;
8010838f:	c7 82 90 00 00 00 01 	movl   $0x1,0x90(%edx)
80108396:	00 00 00 
          curproc->pages[page_index].in_RAM = 1; //  the new page is inside the main memory
80108399:	c7 82 94 00 00 00 01 	movl   $0x1,0x94(%edx)
801083a0:	00 00 00 
          curproc->pages[page_index].offset_in_swapfile = -1; // the page is NOT in the swap file
801083a3:	c7 82 84 00 00 00 ff 	movl   $0xffffffff,0x84(%edx)
801083aa:	ff ff ff 
      insert_to_RAM_queue(page_index);
801083ad:	50                   	push   %eax
801083ae:	e8 6d c7 ff ff       	call   80104b20 <insert_to_RAM_queue>
      curproc->total_allocated_pages++;
801083b3:	83 86 04 04 00 00 01 	addl   $0x1,0x404(%esi)
      pte = walkpgdir(pgdir, (char *)a , 0);
801083ba:	8b 45 08             	mov    0x8(%ebp),%eax
801083bd:	89 da                	mov    %ebx,%edx
801083bf:	31 c9                	xor    %ecx,%ecx
801083c1:	e8 7a f5 ff ff       	call   80107940 <walkpgdir>
      *pte=TURN_OFF_PTE_PG(*pte); // no paging on this page 
801083c6:	8b 10                	mov    (%eax),%edx
801083c8:	83 c4 10             	add    $0x10,%esp
801083cb:	80 e6 fd             	and    $0xfd,%dh
801083ce:	83 ca 01             	or     $0x1,%edx
801083d1:	89 10                	mov    %edx,(%eax)
801083d3:	e9 18 ff ff ff       	jmp    801082f0 <allocuvm+0x40>
801083d8:	90                   	nop
801083d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801083e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801083e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801083e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083e9:	5b                   	pop    %ebx
801083ea:	5e                   	pop    %esi
801083eb:	5f                   	pop    %edi
801083ec:	5d                   	pop    %ebp
801083ed:	c3                   	ret    
801083ee:	66 90                	xchg   %ax,%ax
        swap_out(pgdir);
801083f0:	83 ec 0c             	sub    $0xc,%esp
801083f3:	ff 75 08             	pushl  0x8(%ebp)
801083f6:	e8 e5 fd ff ff       	call   801081e0 <swap_out>
801083fb:	83 c4 10             	add    $0x10,%esp
    mem = kalloc();
801083fe:	e8 3d a7 ff ff       	call   80102b40 <kalloc>
    if(mem == 0){
80108403:	85 c0                	test   %eax,%eax
    mem = kalloc();
80108405:	89 c7                	mov    %eax,%edi
    if(mem == 0){
80108407:	0f 85 13 ff ff ff    	jne    80108320 <allocuvm+0x70>
8010840d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80108410:	83 ec 0c             	sub    $0xc,%esp
80108413:	68 d4 92 10 80       	push   $0x801092d4
      cprintf("in allocuvm: out of memory!");
80108418:	e8 43 82 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz, 0);
8010841d:	6a 00                	push   $0x0
8010841f:	ff 75 0c             	pushl  0xc(%ebp)
80108422:	ff 75 10             	pushl  0x10(%ebp)
80108425:	ff 75 08             	pushl  0x8(%ebp)
80108428:	e8 23 f9 ff ff       	call   80107d50 <deallocuvm>
      return 0;
8010842d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108434:	83 c4 20             	add    $0x20,%esp
}
80108437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010843a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010843d:	5b                   	pop    %ebx
8010843e:	5e                   	pop    %esi
8010843f:	5f                   	pop    %edi
80108440:	5d                   	pop    %ebp
80108441:	c3                   	ret    
80108442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return 0;
80108448:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
8010844f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108452:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108455:	5b                   	pop    %ebx
80108456:	5e                   	pop    %esi
80108457:	5f                   	pop    %edi
80108458:	5d                   	pop    %ebp
80108459:	c3                   	ret    
8010845a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("in allocuvm: out of memory!");
80108460:	83 ec 0c             	sub    $0xc,%esp
80108463:	68 ec 92 10 80       	push   $0x801092ec
80108468:	eb ae                	jmp    80108418 <allocuvm+0x168>
8010846a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108470 <cowuvm>:


////////////////////////ASSIGNMENT 3-TASK 2/////////////////////
pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80108470:	55                   	push   %ebp
80108471:	89 e5                	mov    %esp,%ebp
80108473:	57                   	push   %edi
80108474:	56                   	push   %esi
80108475:	53                   	push   %ebx
80108476:	83 ec 0c             	sub    $0xc,%esp
80108479:	8b 7d 08             	mov    0x8(%ebp),%edi
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
8010847c:	e8 7f fa ff ff       	call   80107f00 <setupkvm>
80108481:	85 c0                	test   %eax,%eax
80108483:	89 c6                	mov    %eax,%esi
80108485:	74 7f                	je     80108506 <cowuvm+0x96>
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
80108487:	8b 45 0c             	mov    0xc(%ebp),%eax
8010848a:	85 c0                	test   %eax,%eax
8010848c:	0f 84 7e 00 00 00    	je     80108510 <cowuvm+0xa0>
80108492:	31 db                	xor    %ebx,%ebx
80108494:	eb 15                	jmp    801084ab <cowuvm+0x3b>
80108496:	8d 76 00             	lea    0x0(%esi),%esi
80108499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801084a0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801084a6:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801084a9:	76 65                	jbe    80108510 <cowuvm+0xa0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801084ab:	31 c9                	xor    %ecx,%ecx
801084ad:	89 da                	mov    %ebx,%edx
801084af:	89 f8                	mov    %edi,%eax
801084b1:	e8 8a f4 ff ff       	call   80107940 <walkpgdir>
801084b6:	85 c0                	test   %eax,%eax
801084b8:	74 76                	je     80108530 <cowuvm+0xc0>
      panic("cowuvm: pte should exist");
    if(!(*pte & PTE_P))
801084ba:	8b 10                	mov    (%eax),%edx
801084bc:	f6 c2 01             	test   $0x1,%dl
801084bf:	74 62                	je     80108523 <cowuvm+0xb3>
      panic("copyuvm: page not present");

    // make the permissions for the parent_page read only
    *pte &= ~PTE_W;
801084c1:	89 d1                	mov    %edx,%ecx
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
801084c3:	83 ec 08             	sub    $0x8,%esp
    *pte &= ~PTE_W;
801084c6:	83 e1 fd             	and    $0xfffffffd,%ecx
801084c9:	89 08                	mov    %ecx,(%eax)
    flags = PTE_FLAGS(*pte);
801084cb:	89 d0                	mov    %edx,%eax
    pa = PTE_ADDR(*pte);
801084cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    flags = PTE_FLAGS(*pte);
801084d3:	25 fd 0f 00 00       	and    $0xffd,%eax
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
801084d8:	b9 00 10 00 00       	mov    $0x1000,%ecx
801084dd:	50                   	push   %eax
801084de:	52                   	push   %edx
801084df:	89 f0                	mov    %esi,%eax
801084e1:	89 da                	mov    %ebx,%edx
801084e3:	e8 d8 f4 ff ff       	call   801079c0 <mappages>
801084e8:	83 c4 10             	add    $0x10,%esp
801084eb:	85 c0                	test   %eax,%eax
801084ed:	79 b1                	jns    801084a0 <cowuvm+0x30>
  }
  lcr3(V2P(pgdir)); // Flush TLB for original process
  return d;

bad:
  freevm(d);
801084ef:	83 ec 0c             	sub    $0xc,%esp
  // Even though we failed to copy, we should flush TLB, since
  // some entries in the original process page table have been changed
  lcr3(V2P(pgdir));
801084f2:	81 c7 00 00 00 80    	add    $0x80000000,%edi
  freevm(d);
801084f8:	56                   	push   %esi
801084f9:	e8 82 f9 ff ff       	call   80107e80 <freevm>
801084fe:	0f 22 df             	mov    %edi,%cr3
  return 0;
80108501:	31 f6                	xor    %esi,%esi
80108503:	83 c4 10             	add    $0x10,%esp
}
80108506:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108509:	89 f0                	mov    %esi,%eax
8010850b:	5b                   	pop    %ebx
8010850c:	5e                   	pop    %esi
8010850d:	5f                   	pop    %edi
8010850e:	5d                   	pop    %ebp
8010850f:	c3                   	ret    
  lcr3(V2P(pgdir)); // Flush TLB for original process
80108510:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108516:	0f 22 df             	mov    %edi,%cr3
}
80108519:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010851c:	89 f0                	mov    %esi,%eax
8010851e:	5b                   	pop    %ebx
8010851f:	5e                   	pop    %esi
80108520:	5f                   	pop    %edi
80108521:	5d                   	pop    %ebp
80108522:	c3                   	ret    
      panic("copyuvm: page not present");
80108523:	83 ec 0c             	sub    $0xc,%esp
80108526:	68 ba 92 10 80       	push   $0x801092ba
8010852b:	e8 60 7e ff ff       	call   80100390 <panic>
      panic("cowuvm: pte should exist");
80108530:	83 ec 0c             	sub    $0xc,%esp
80108533:	68 08 93 10 80       	push   $0x80109308
80108538:	e8 53 7e ff ff       	call   80100390 <panic>
8010853d:	8d 76 00             	lea    0x0(%esi),%esi

80108540 <pagefault>:
}
*/

int 
pagefault(uint err_code)
{
80108540:	55                   	push   %ebp
80108541:	89 e5                	mov    %esp,%ebp
80108543:	57                   	push   %edi
80108544:	56                   	push   %esi
80108545:	53                   	push   %ebx
80108546:	83 ec 1c             	sub    $0x1c,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108549:	0f 20 d6             	mov    %cr2,%esi
  // get the faulting virtual address from the CR2 register
  uint va = rcr2();
  uint pa;
  pte_t *pte;
  char *mem;
  struct proc* proc = myproc();
8010854c:	e8 0f bb ff ff       	call   80104060 <myproc>

  if(va >= KERNBASE)
80108551:	85 f6                	test   %esi,%esi
  struct proc* proc = myproc();
80108553:	89 c3                	mov    %eax,%ebx
  if(va >= KERNBASE)
80108555:	0f 88 f5 00 00 00    	js     80108650 <pagefault+0x110>
    cprintf("Illegal memory access on cpu addr  kill proc  with pid \n"
                                            );
    proc->killed = 1;
    return 1;
  }
  if((pte = walkpgdir(proc->pgdir, (void*)va, 0))==0)
8010855b:	8b 40 04             	mov    0x4(%eax),%eax
8010855e:	31 c9                	xor    %ecx,%ecx
80108560:	89 f2                	mov    %esi,%edx
80108562:	e8 d9 f3 ff ff       	call   80107940 <walkpgdir>
80108567:	85 c0                	test   %eax,%eax
80108569:	89 c7                	mov    %eax,%edi
8010856b:	0f 84 87 01 00 00    	je     801086f8 <pagefault+0x1b8>
    cprintf("1Illegal memory access on cpu addr 0x%x, kill proc %s with pid %d\n",
                                          va, proc->name, proc->pid);
    proc->killed = 1;
    return 1;
  }
  if(!(*pte & PTE_U))
80108571:	8b 00                	mov    (%eax),%eax
80108573:	a8 04                	test   $0x4,%al
80108575:	0f 84 fd 00 00 00    	je     80108678 <pagefault+0x138>
    cprintf("2Illegal memory access on cpu addr 0x%x, kill proc %s with pid %d\n",
                                           va, proc->name, proc->pid);
    proc->killed = 1;
    return 1;
  }
    if(!(*pte & PTE_P))
8010857b:	a8 01                	test   $0x1,%al
8010857d:	0f 84 45 01 00 00    	je     801086c8 <pagefault+0x188>
    cprintf("3Illegal memory access on cpu  addr 0x%x, kill proc %s with pid %d\n",
                                            va, proc->name, proc->pid);
    proc->killed = 1;
    return 1;
  }
  if(*pte & PTE_W)
80108583:	a8 02                	test   $0x2,%al
80108585:	0f 85 ce 01 00 00    	jne    80108759 <pagefault+0x219>
    panic("Unknown page fault due to a writable pte");
  }
  else
  {
    // get the physical address from the  given page table entry
    pa = PTE_ADDR(*pte);
8010858b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    acquire(&lock);
80108590:	83 ec 0c             	sub    $0xc,%esp
    pa = PTE_ADDR(*pte);
80108593:	89 c6                	mov    %eax,%esi
    acquire(&lock);
80108595:	68 e0 3b 1a 80       	push   $0x801a3be0
    pa = PTE_ADDR(*pte);
8010859a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pg_refcount[pa >> PTXSHIFT] == 1)
8010859d:	c1 ee 0c             	shr    $0xc,%esi
    acquire(&lock);
801085a0:	e8 0b ce ff ff       	call   801053b0 <acquire>
    if(pg_refcount[pa >> PTXSHIFT] == 1)
801085a5:	83 c4 10             	add    $0x10,%esp
801085a8:	80 be e0 5b 19 80 01 	cmpb   $0x1,-0x7fe6a420(%esi)
801085af:	0f 84 73 01 00 00    	je     80108728 <pagefault+0x1e8>
      *pte |= PTE_W;  // remove the read-only restriction on the trapping page
    }
    else
    {
      // Current process is the first one that tries to write to this page
      if(pg_refcount[pa >> PTXSHIFT] > 1)
801085b5:	0f 8e 85 01 00 00    	jle    80108740 <pagefault+0x200>
      {
        release(&lock);
801085bb:	83 ec 0c             	sub    $0xc,%esp
801085be:	68 e0 3b 1a 80       	push   $0x801a3be0
801085c3:	e8 a8 ce ff ff       	call   80105470 <release>
        if((mem = kalloc()) == 0)
801085c8:	e8 73 a5 ff ff       	call   80102b40 <kalloc>
801085cd:	83 c4 10             	add    $0x10,%esp
801085d0:	85 c0                	test   %eax,%eax
801085d2:	89 c2                	mov    %eax,%edx
801085d4:	0f 84 ce 00 00 00    	je     801086a8 <pagefault+0x168>
          cprintf("Illegal memory access");
          proc->killed = 1;
          return 1;
        }
        // copy the contents from the original memory page pointed the virtual address
        memmove(mem, (char*)P2V(pa), PGSIZE);
801085da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801085dd:	83 ec 04             	sub    $0x4,%esp
801085e0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801085e3:	68 00 10 00 00       	push   $0x1000
801085e8:	05 00 00 00 80       	add    $0x80000000,%eax
801085ed:	50                   	push   %eax
801085ee:	52                   	push   %edx
801085ef:	e8 7c cf ff ff       	call   80105570 <memmove>
        acquire(&lock);
801085f4:	c7 04 24 e0 3b 1a 80 	movl   $0x801a3be0,(%esp)
801085fb:	e8 b0 cd ff ff       	call   801053b0 <acquire>
        pg_refcount[pa >> PTXSHIFT] = pg_refcount[pa >> PTXSHIFT] - 1;
        pg_refcount[V2P(mem) >> PTXSHIFT] = pg_refcount[V2P(mem) >> PTXSHIFT] + 1;
80108600:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        pg_refcount[pa >> PTXSHIFT] = pg_refcount[pa >> PTXSHIFT] - 1;
80108603:	80 ae e0 5b 19 80 01 	subb   $0x1,-0x7fe6a420(%esi)
        release(&lock);
8010860a:	c7 04 24 e0 3b 1a 80 	movl   $0x801a3be0,(%esp)
        pg_refcount[V2P(mem) >> PTXSHIFT] = pg_refcount[V2P(mem) >> PTXSHIFT] + 1;
80108611:	8d b2 00 00 00 80    	lea    -0x80000000(%edx),%esi
80108617:	89 f0                	mov    %esi,%eax
80108619:	c1 e8 0c             	shr    $0xc,%eax
8010861c:	80 80 e0 5b 19 80 01 	addb   $0x1,-0x7fe6a420(%eax)
        release(&lock);
80108623:	e8 48 ce ff ff       	call   80105470 <release>
        *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;  // point the given page table entry to the new page
80108628:	89 f2                	mov    %esi,%edx
8010862a:	83 c4 10             	add    $0x10,%esp
8010862d:	83 ca 07             	or     $0x7,%edx
80108630:	89 17                	mov    %edx,(%edi)
        release(&lock);
        panic("Pagefault due to wrong ref count");
      }
    }
    // Flush TLB for process since page table entries changed
    lcr3(V2P(proc->pgdir));
80108632:	8b 43 04             	mov    0x4(%ebx),%eax
80108635:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010863a:	0f 22 d8             	mov    %eax,%cr3
    return 1;
  }
  return 1;
}
8010863d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108640:	b8 01 00 00 00       	mov    $0x1,%eax
80108645:	5b                   	pop    %ebx
80108646:	5e                   	pop    %esi
80108647:	5f                   	pop    %edi
80108648:	5d                   	pop    %ebp
80108649:	c3                   	ret    
8010864a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("Illegal memory access on cpu addr  kill proc  with pid \n"
80108650:	83 ec 0c             	sub    $0xc,%esp
80108653:	68 7c 93 10 80       	push   $0x8010937c
80108658:	e8 03 80 ff ff       	call   80100660 <cprintf>
    proc->killed = 1;
8010865d:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
    return 1;
80108664:	83 c4 10             	add    $0x10,%esp
}
80108667:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010866a:	b8 01 00 00 00       	mov    $0x1,%eax
8010866f:	5b                   	pop    %ebx
80108670:	5e                   	pop    %esi
80108671:	5f                   	pop    %edi
80108672:	5d                   	pop    %ebp
80108673:	c3                   	ret    
80108674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                                           va, proc->name, proc->pid);
80108678:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("2Illegal memory access on cpu addr 0x%x, kill proc %s with pid %d\n",
8010867b:	ff 73 10             	pushl  0x10(%ebx)
8010867e:	50                   	push   %eax
8010867f:	56                   	push   %esi
80108680:	68 fc 93 10 80       	push   $0x801093fc
80108685:	e8 d6 7f ff ff       	call   80100660 <cprintf>
    proc->killed = 1;
8010868a:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
    return 1;
80108691:	83 c4 10             	add    $0x10,%esp
}
80108694:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108697:	b8 01 00 00 00       	mov    $0x1,%eax
8010869c:	5b                   	pop    %ebx
8010869d:	5e                   	pop    %esi
8010869e:	5f                   	pop    %edi
8010869f:	5d                   	pop    %ebp
801086a0:	c3                   	ret    
801086a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          cprintf("Illegal memory access");
801086a8:	83 ec 0c             	sub    $0xc,%esp
801086ab:	68 21 93 10 80       	push   $0x80109321
801086b0:	e8 ab 7f ff ff       	call   80100660 <cprintf>
          proc->killed = 1;
801086b5:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
          return 1;
801086bc:	83 c4 10             	add    $0x10,%esp
801086bf:	eb a6                	jmp    80108667 <pagefault+0x127>
801086c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                                            va, proc->name, proc->pid);
801086c8:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("3Illegal memory access on cpu  addr 0x%x, kill proc %s with pid %d\n",
801086cb:	ff 73 10             	pushl  0x10(%ebx)
801086ce:	50                   	push   %eax
801086cf:	56                   	push   %esi
801086d0:	68 40 94 10 80       	push   $0x80109440
801086d5:	e8 86 7f ff ff       	call   80100660 <cprintf>
    proc->killed = 1;
801086da:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
    return 1;
801086e1:	83 c4 10             	add    $0x10,%esp
}
801086e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086e7:	b8 01 00 00 00       	mov    $0x1,%eax
801086ec:	5b                   	pop    %ebx
801086ed:	5e                   	pop    %esi
801086ee:	5f                   	pop    %edi
801086ef:	5d                   	pop    %ebp
801086f0:	c3                   	ret    
801086f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                                          va, proc->name, proc->pid);
801086f8:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("1Illegal memory access on cpu addr 0x%x, kill proc %s with pid %d\n",
801086fb:	ff 73 10             	pushl  0x10(%ebx)
801086fe:	50                   	push   %eax
801086ff:	56                   	push   %esi
80108700:	68 b8 93 10 80       	push   $0x801093b8
80108705:	e8 56 7f ff ff       	call   80100660 <cprintf>
    proc->killed = 1;
8010870a:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
    return 1;
80108711:	83 c4 10             	add    $0x10,%esp
}
80108714:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108717:	b8 01 00 00 00       	mov    $0x1,%eax
8010871c:	5b                   	pop    %ebx
8010871d:	5e                   	pop    %esi
8010871e:	5f                   	pop    %edi
8010871f:	5d                   	pop    %ebp
80108720:	c3                   	ret    
80108721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&lock);
80108728:	83 ec 0c             	sub    $0xc,%esp
8010872b:	68 e0 3b 1a 80       	push   $0x801a3be0
80108730:	e8 3b cd ff ff       	call   80105470 <release>
      *pte |= PTE_W;  // remove the read-only restriction on the trapping page
80108735:	83 0f 02             	orl    $0x2,(%edi)
80108738:	83 c4 10             	add    $0x10,%esp
8010873b:	e9 f2 fe ff ff       	jmp    80108632 <pagefault+0xf2>
        release(&lock);
80108740:	83 ec 0c             	sub    $0xc,%esp
80108743:	68 e0 3b 1a 80       	push   $0x801a3be0
80108748:	e8 23 cd ff ff       	call   80105470 <release>
        panic("Pagefault due to wrong ref count");
8010874d:	c7 04 24 b0 94 10 80 	movl   $0x801094b0,(%esp)
80108754:	e8 37 7c ff ff       	call   80100390 <panic>
    panic("Unknown page fault due to a writable pte");
80108759:	83 ec 0c             	sub    $0xc,%esp
8010875c:	68 84 94 10 80       	push   $0x80109484
80108761:	e8 2a 7c ff ff       	call   80100390 <panic>
80108766:	8d 76 00             	lea    0x0(%esi),%esi
80108769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108770 <global_walkpgdir>:


/** no idea why, but you can't call walkpgdir and mappages on their own... --\_('_')_/-- **/
uint global_walkpgdir(pde_t* pgdir, void* va, int alloc){
80108770:	55                   	push   %ebp
80108771:	89 e5                	mov    %esp,%ebp
  return (uint) walkpgdir(pgdir, va, alloc);
80108773:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108776:	8b 55 0c             	mov    0xc(%ebp),%edx
80108779:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010877c:	5d                   	pop    %ebp
  return (uint) walkpgdir(pgdir, va, alloc);
8010877d:	e9 be f1 ff ff       	jmp    80107940 <walkpgdir>
80108782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108790 <global_mappages>:
int global_mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm){
80108790:	55                   	push   %ebp
80108791:	89 e5                	mov    %esp,%ebp
  return mappages(pgdir, va, size, pa, perm);
80108793:	8b 4d 18             	mov    0x18(%ebp),%ecx
int global_mappages(pde_t* pgdir, void* va, uint size, uint pa, int perm){
80108796:	8b 55 0c             	mov    0xc(%ebp),%edx
80108799:	8b 45 08             	mov    0x8(%ebp),%eax
  return mappages(pgdir, va, size, pa, perm);
8010879c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010879f:	8b 4d 14             	mov    0x14(%ebp),%ecx
801087a2:	89 4d 08             	mov    %ecx,0x8(%ebp)
801087a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801087a8:	5d                   	pop    %ebp
  return mappages(pgdir, va, size, pa, perm);
801087a9:	e9 12 f2 ff ff       	jmp    801079c0 <mappages>
