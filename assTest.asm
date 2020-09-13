
_assTest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#define N_PAGES 24

char* data[N_PAGES];

volatile int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx

	int i = 0;
	int n = N_PAGES;

	for (i = 0; i < n ;)
  10:	31 db                	xor    %ebx,%ebx
volatile int main(int argc, char *argv[]) {
  12:	83 ec 0c             	sub    $0xc,%esp
  15:	8d 76 00             	lea    0x0(%esi),%esi
	{
		data[i] = sbrk(PGSIZE);
  18:	83 ec 0c             	sub    $0xc,%esp
  1b:	68 00 10 00 00       	push   $0x1000
  20:	e8 25 05 00 00       	call   54a <sbrk>
  25:	89 04 9d a0 0c 00 00 	mov    %eax,0xca0(,%ebx,4)
		data[i][0] = 00 + i;
  2c:	88 18                	mov    %bl,(%eax)
		data[i][1] = 10 + i;
  2e:	8d 53 0a             	lea    0xa(%ebx),%edx
  31:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
  38:	88 50 01             	mov    %dl,0x1(%eax)
		data[i][2] = 20 + i;
  3b:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
  42:	8d 53 14             	lea    0x14(%ebx),%edx
  45:	88 50 02             	mov    %dl,0x2(%eax)
		data[i][3] = 30 + i;
  48:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
  4f:	8d 53 1e             	lea    0x1e(%ebx),%edx
  52:	88 50 03             	mov    %dl,0x3(%eax)
		data[i][4] = 40 + i;
  55:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
  5c:	8d 53 28             	lea    0x28(%ebx),%edx
  5f:	88 50 04             	mov    %dl,0x4(%eax)
		data[i][5] = 50 + i;
  62:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
  69:	8d 53 32             	lea    0x32(%ebx),%edx
  6c:	88 50 05             	mov    %dl,0x5(%eax)
		data[i][6] = 60 + i;
  6f:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
  76:	8d 53 3c             	lea    0x3c(%ebx),%edx
  79:	88 50 06             	mov    %dl,0x6(%eax)
		data[i][7] = 70 + i;
  7c:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
  83:	8d 53 46             	lea    0x46(%ebx),%edx
  86:	88 50 07             	mov    %dl,0x7(%eax)
		printf(1, "allocated new page #%d in: %x\n", i, data[i]);
  89:	ff 34 9d a0 0c 00 00 	pushl  0xca0(,%ebx,4)
  90:	53                   	push   %ebx
  91:	68 68 09 00 00       	push   $0x968
		i++;
  96:	83 c3 01             	add    $0x1,%ebx
		printf(1, "allocated new page #%d in: %x\n", i, data[i]);
  99:	6a 01                	push   $0x1
  9b:	e8 70 05 00 00       	call   610 <printf>
	for (i = 0; i < n ;)
  a0:	83 c4 20             	add    $0x20,%esp
  a3:	83 fb 18             	cmp    $0x18,%ebx
  a6:	0f 85 6c ff ff ff    	jne    18 <main+0x18>
	}

	
	int j;
	for(j = 1; j < n; j++)
  ac:	be 01 00 00 00       	mov    $0x1,%esi
  b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	{
		printf(1,"j:  %d\n",j);
  b8:	83 ec 04             	sub    $0x4,%esp

		for(i = 0; i < j; i++) {
  bb:	31 db                	xor    %ebx,%ebx
		printf(1,"j:  %d\n",j);
  bd:	56                   	push   %esi
  be:	68 bc 09 00 00       	push   $0x9bc
  c3:	6a 01                	push   $0x1
  c5:	e8 46 05 00 00       	call   610 <printf>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	8d 76 00             	lea    0x0(%esi),%esi
			data[i][10] = 2; // access to the i-th page
  d0:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
			printf(1,"%d, ",i);
  d7:	83 ec 04             	sub    $0x4,%esp
			data[i][10] = 2; // access to the i-th page
  da:	c6 40 0a 02          	movb   $0x2,0xa(%eax)
			printf(1,"%d, ",i);
  de:	53                   	push   %ebx
		for(i = 0; i < j; i++) {
  df:	83 c3 01             	add    $0x1,%ebx
			printf(1,"%d, ",i);
  e2:	68 c4 09 00 00       	push   $0x9c4
  e7:	6a 01                	push   $0x1
  e9:	e8 22 05 00 00       	call   610 <printf>
		for(i = 0; i < j; i++) {
  ee:	83 c4 10             	add    $0x10,%esp
  f1:	39 f3                	cmp    %esi,%ebx
  f3:	75 db                	jne    d0 <main+0xd0>
		}
		printf(1,"\n");
  f5:	83 ec 08             	sub    $0x8,%esp
	for(j = 1; j < n; j++)
  f8:	8d 73 01             	lea    0x1(%ebx),%esi
		printf(1,"\n");
  fb:	68 c2 09 00 00       	push   $0x9c2
 100:	6a 01                	push   $0x1
 102:	e8 09 05 00 00       	call   610 <printf>
	for(j = 1; j < n; j++)
 107:	83 c4 10             	add    $0x10,%esp
 10a:	83 fe 18             	cmp    $0x18,%esi
 10d:	75 a9                	jne    b8 <main+0xb8>
	}

	int k;
	int pid = fork();
 10f:	e8 a6 03 00 00       	call   4ba <fork>
	if (pid)
 114:	85 c0                	test   %eax,%eax
 116:	74 0a                	je     122 <main+0x122>
		wait();
 118:	e8 ad 03 00 00       	call   4ca <wait>
			// data[j][10] = 0;
			// printf(1,"%d, ",j);
			printf(1,"\n");
		}
	}
	exit();
 11d:	e8 a0 03 00 00       	call   4c2 <exit>
		printf(1, "\nGo through same 8 pages and different 8 others\n");
 122:	50                   	push   %eax
 123:	50                   	push   %eax
		for(j = 0; j < 8; j++){
 124:	31 f6                	xor    %esi,%esi
		printf(1, "\nGo through same 8 pages and different 8 others\n");
 126:	68 88 09 00 00       	push   $0x988
 12b:	6a 01                	push   $0x1
 12d:	e8 de 04 00 00       	call   610 <printf>
 132:	83 c4 10             	add    $0x10,%esp
 135:	8d 76 00             	lea    0x0(%esi),%esi
			for(i = 20; i < 24; i++) {
 138:	bb 14 00 00 00       	mov    $0x14,%ebx
				data[i][10] = 1;
 13d:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
				printf(1,"%d, ",i);
 144:	83 ec 04             	sub    $0x4,%esp
				data[i][10] = 1;
 147:	c6 40 0a 01          	movb   $0x1,0xa(%eax)
				printf(1,"%d, ",i);
 14b:	53                   	push   %ebx
			for(i = 20; i < 24; i++) {
 14c:	83 c3 01             	add    $0x1,%ebx
				printf(1,"%d, ",i);
 14f:	68 c4 09 00 00       	push   $0x9c4
 154:	6a 01                	push   $0x1
 156:	e8 b5 04 00 00       	call   610 <printf>
			for(i = 20; i < 24; i++) {
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	83 fb 18             	cmp    $0x18,%ebx
 161:	75 da                	jne    13d <main+0x13d>
			printf(1,"\n");
 163:	83 ec 08             	sub    $0x8,%esp
 166:	68 c2 09 00 00       	push   $0x9c2
 16b:	6a 01                	push   $0x1
 16d:	e8 9e 04 00 00       	call   610 <printf>
			switch (j%4) {
 172:	89 f0                	mov    %esi,%eax
 174:	83 c4 10             	add    $0x10,%esp
 177:	83 e0 03             	and    $0x3,%eax
 17a:	83 f8 02             	cmp    $0x2,%eax
 17d:	0f 84 af 00 00 00    	je     232 <main+0x232>
 183:	83 f8 03             	cmp    $0x3,%eax
 186:	74 7d                	je     205 <main+0x205>
 188:	83 f8 01             	cmp    $0x1,%eax
 18b:	74 4b                	je     1d8 <main+0x1d8>
				for(k = 0; k < 4; k++) {
 18d:	31 db                	xor    %ebx,%ebx
					data[k][10] = 1;
 18f:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
					printf(1,"%d, ",k);
 196:	83 ec 04             	sub    $0x4,%esp
					data[k][10] = 1;
 199:	c6 40 0a 01          	movb   $0x1,0xa(%eax)
					printf(1,"%d, ",k);
 19d:	53                   	push   %ebx
				for(k = 0; k < 4; k++) {
 19e:	83 c3 01             	add    $0x1,%ebx
					printf(1,"%d, ",k);
 1a1:	68 c4 09 00 00       	push   $0x9c4
 1a6:	6a 01                	push   $0x1
 1a8:	e8 63 04 00 00       	call   610 <printf>
				for(k = 0; k < 4; k++) {
 1ad:	83 c4 10             	add    $0x10,%esp
 1b0:	83 fb 04             	cmp    $0x4,%ebx
 1b3:	75 da                	jne    18f <main+0x18f>
			printf(1,"\n");
 1b5:	83 ec 08             	sub    $0x8,%esp
		for(j = 0; j < 8; j++){
 1b8:	83 c6 01             	add    $0x1,%esi
			printf(1,"\n");
 1bb:	68 c2 09 00 00       	push   $0x9c2
 1c0:	6a 01                	push   $0x1
 1c2:	e8 49 04 00 00       	call   610 <printf>
		for(j = 0; j < 8; j++){
 1c7:	83 c4 10             	add    $0x10,%esp
 1ca:	83 fe 08             	cmp    $0x8,%esi
 1cd:	0f 85 65 ff ff ff    	jne    138 <main+0x138>
 1d3:	e9 45 ff ff ff       	jmp    11d <main+0x11d>
				for(k = 4; k < 8; k++) {
 1d8:	bb 04 00 00 00       	mov    $0x4,%ebx
					data[k][10] = 1;
 1dd:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
					printf(1,"%d, ",k);
 1e4:	83 ec 04             	sub    $0x4,%esp
					data[k][10] = 1;
 1e7:	c6 40 0a 01          	movb   $0x1,0xa(%eax)
					printf(1,"%d, ",k);
 1eb:	53                   	push   %ebx
				for(k = 4; k < 8; k++) {
 1ec:	83 c3 01             	add    $0x1,%ebx
					printf(1,"%d, ",k);
 1ef:	68 c4 09 00 00       	push   $0x9c4
 1f4:	6a 01                	push   $0x1
 1f6:	e8 15 04 00 00       	call   610 <printf>
				for(k = 4; k < 8; k++) {
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	83 fb 08             	cmp    $0x8,%ebx
 201:	75 da                	jne    1dd <main+0x1dd>
 203:	eb b0                	jmp    1b5 <main+0x1b5>
				for(k = 12; k < 16; k++) {
 205:	bb 0c 00 00 00       	mov    $0xc,%ebx
					data[k][10] = 1;
 20a:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
					printf(1,"%d, ",k);
 211:	83 ec 04             	sub    $0x4,%esp
					data[k][10] = 1;
 214:	c6 40 0a 01          	movb   $0x1,0xa(%eax)
					printf(1,"%d, ",k);
 218:	53                   	push   %ebx
				for(k = 12; k < 16; k++) {
 219:	83 c3 01             	add    $0x1,%ebx
					printf(1,"%d, ",k);
 21c:	68 c4 09 00 00       	push   $0x9c4
 221:	6a 01                	push   $0x1
 223:	e8 e8 03 00 00       	call   610 <printf>
				for(k = 12; k < 16; k++) {
 228:	83 c4 10             	add    $0x10,%esp
 22b:	83 fb 10             	cmp    $0x10,%ebx
 22e:	75 da                	jne    20a <main+0x20a>
 230:	eb 83                	jmp    1b5 <main+0x1b5>
				for(k = 8; k < 12; k++) {
 232:	bb 08 00 00 00       	mov    $0x8,%ebx
					data[k][10] = 1;
 237:	8b 04 9d a0 0c 00 00 	mov    0xca0(,%ebx,4),%eax
					printf(1,"%d, ",k);
 23e:	83 ec 04             	sub    $0x4,%esp
					data[k][10] = 1;
 241:	c6 40 0a 01          	movb   $0x1,0xa(%eax)
					printf(1,"%d, ",k);
 245:	53                   	push   %ebx
				for(k = 8; k < 12; k++) {
 246:	83 c3 01             	add    $0x1,%ebx
					printf(1,"%d, ",k);
 249:	68 c4 09 00 00       	push   $0x9c4
 24e:	6a 01                	push   $0x1
 250:	e8 bb 03 00 00       	call   610 <printf>
				for(k = 8; k < 12; k++) {
 255:	83 c4 10             	add    $0x10,%esp
 258:	83 fb 0c             	cmp    $0xc,%ebx
 25b:	75 da                	jne    237 <main+0x237>
 25d:	e9 53 ff ff ff       	jmp    1b5 <main+0x1b5>
 262:	66 90                	xchg   %ax,%ax
 264:	66 90                	xchg   %ax,%ax
 266:	66 90                	xchg   %ax,%ax
 268:	66 90                	xchg   %ax,%ax
 26a:	66 90                	xchg   %ax,%ax
 26c:	66 90                	xchg   %ax,%ax
 26e:	66 90                	xchg   %ax,%ax

00000270 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27a:	89 c2                	mov    %eax,%edx
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 280:	83 c1 01             	add    $0x1,%ecx
 283:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 287:	83 c2 01             	add    $0x1,%edx
 28a:	84 db                	test   %bl,%bl
 28c:	88 5a ff             	mov    %bl,-0x1(%edx)
 28f:	75 ef                	jne    280 <strcpy+0x10>
    ;
  return os;
}
 291:	5b                   	pop    %ebx
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    
 294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 29a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2aa:	0f b6 02             	movzbl (%edx),%eax
 2ad:	0f b6 19             	movzbl (%ecx),%ebx
 2b0:	84 c0                	test   %al,%al
 2b2:	75 1c                	jne    2d0 <strcmp+0x30>
 2b4:	eb 2a                	jmp    2e0 <strcmp+0x40>
 2b6:	8d 76 00             	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2c6:	83 c1 01             	add    $0x1,%ecx
 2c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2cc:	84 c0                	test   %al,%al
 2ce:	74 10                	je     2e0 <strcmp+0x40>
 2d0:	38 d8                	cmp    %bl,%al
 2d2:	74 ec                	je     2c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2d4:	29 d8                	sub    %ebx,%eax
}
 2d6:	5b                   	pop    %ebx
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2e2:	29 d8                	sub    %ebx,%eax
}
 2e4:	5b                   	pop    %ebx
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret    
 2e7:	89 f6                	mov    %esi,%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2f6:	80 39 00             	cmpb   $0x0,(%ecx)
 2f9:	74 15                	je     310 <strlen+0x20>
 2fb:	31 d2                	xor    %edx,%edx
 2fd:	8d 76 00             	lea    0x0(%esi),%esi
 300:	83 c2 01             	add    $0x1,%edx
 303:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 307:	89 d0                	mov    %edx,%eax
 309:	75 f5                	jne    300 <strlen+0x10>
    ;
  return n;
}
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    
 30d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 310:	31 c0                	xor    %eax,%eax
}
 312:	5d                   	pop    %ebp
 313:	c3                   	ret    
 314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 31a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000320 <memset>:

void*
memset(void *dst, int c, uint n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 327:	8b 4d 10             	mov    0x10(%ebp),%ecx
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 d7                	mov    %edx,%edi
 32f:	fc                   	cld    
 330:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 332:	89 d0                	mov    %edx,%eax
 334:	5f                   	pop    %edi
 335:	5d                   	pop    %ebp
 336:	c3                   	ret    
 337:	89 f6                	mov    %esi,%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 34a:	0f b6 10             	movzbl (%eax),%edx
 34d:	84 d2                	test   %dl,%dl
 34f:	74 1d                	je     36e <strchr+0x2e>
    if(*s == c)
 351:	38 d3                	cmp    %dl,%bl
 353:	89 d9                	mov    %ebx,%ecx
 355:	75 0d                	jne    364 <strchr+0x24>
 357:	eb 17                	jmp    370 <strchr+0x30>
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 360:	38 ca                	cmp    %cl,%dl
 362:	74 0c                	je     370 <strchr+0x30>
  for(; *s; s++)
 364:	83 c0 01             	add    $0x1,%eax
 367:	0f b6 10             	movzbl (%eax),%edx
 36a:	84 d2                	test   %dl,%dl
 36c:	75 f2                	jne    360 <strchr+0x20>
      return (char*)s;
  return 0;
 36e:	31 c0                	xor    %eax,%eax
}
 370:	5b                   	pop    %ebx
 371:	5d                   	pop    %ebp
 372:	c3                   	ret    
 373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000380 <gets>:

char*
gets(char *buf, int max)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 386:	31 f6                	xor    %esi,%esi
 388:	89 f3                	mov    %esi,%ebx
{
 38a:	83 ec 1c             	sub    $0x1c,%esp
 38d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 390:	eb 2f                	jmp    3c1 <gets+0x41>
 392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 398:	8d 45 e7             	lea    -0x19(%ebp),%eax
 39b:	83 ec 04             	sub    $0x4,%esp
 39e:	6a 01                	push   $0x1
 3a0:	50                   	push   %eax
 3a1:	6a 00                	push   $0x0
 3a3:	e8 32 01 00 00       	call   4da <read>
    if(cc < 1)
 3a8:	83 c4 10             	add    $0x10,%esp
 3ab:	85 c0                	test   %eax,%eax
 3ad:	7e 1c                	jle    3cb <gets+0x4b>
      break;
    buf[i++] = c;
 3af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3b3:	83 c7 01             	add    $0x1,%edi
 3b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3b9:	3c 0a                	cmp    $0xa,%al
 3bb:	74 23                	je     3e0 <gets+0x60>
 3bd:	3c 0d                	cmp    $0xd,%al
 3bf:	74 1f                	je     3e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 3c1:	83 c3 01             	add    $0x1,%ebx
 3c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3c7:	89 fe                	mov    %edi,%esi
 3c9:	7c cd                	jl     398 <gets+0x18>
 3cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    
 3db:	90                   	nop
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3e0:	8b 75 08             	mov    0x8(%ebp),%esi
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	01 de                	add    %ebx,%esi
 3e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 3ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f0:	5b                   	pop    %ebx
 3f1:	5e                   	pop    %esi
 3f2:	5f                   	pop    %edi
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    
 3f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	pushl  0x8(%ebp)
 40d:	e8 f0 00 00 00       	call   502 <open>
  if(fd < 0)
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 419:	83 ec 08             	sub    $0x8,%esp
 41c:	ff 75 0c             	pushl  0xc(%ebp)
 41f:	89 c3                	mov    %eax,%ebx
 421:	50                   	push   %eax
 422:	e8 f3 00 00 00       	call   51a <fstat>
  close(fd);
 427:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 42a:	89 c6                	mov    %eax,%esi
  close(fd);
 42c:	e8 b9 00 00 00       	call   4ea <close>
  return r;
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	8d 65 f8             	lea    -0x8(%ebp),%esp
 437:	89 f0                	mov    %esi,%eax
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	89 f6                	mov    %esi,%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <atoi>:

int
atoi(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 457:	0f be 11             	movsbl (%ecx),%edx
 45a:	8d 42 d0             	lea    -0x30(%edx),%eax
 45d:	3c 09                	cmp    $0x9,%al
  n = 0;
 45f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 464:	77 1f                	ja     485 <atoi+0x35>
 466:	8d 76 00             	lea    0x0(%esi),%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 470:	8d 04 80             	lea    (%eax,%eax,4),%eax
 473:	83 c1 01             	add    $0x1,%ecx
 476:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 47a:	0f be 11             	movsbl (%ecx),%edx
 47d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x20>
  return n;
}
 485:	5b                   	pop    %ebx
 486:	5d                   	pop    %ebp
 487:	c3                   	ret    
 488:	90                   	nop
 489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	56                   	push   %esi
 494:	53                   	push   %ebx
 495:	8b 5d 10             	mov    0x10(%ebp),%ebx
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49e:	85 db                	test   %ebx,%ebx
 4a0:	7e 14                	jle    4b6 <memmove+0x26>
 4a2:	31 d2                	xor    %edx,%edx
 4a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4b2:	39 d3                	cmp    %edx,%ebx
 4b4:	75 f2                	jne    4a8 <memmove+0x18>
  return vdst;
}
 4b6:	5b                   	pop    %ebx
 4b7:	5e                   	pop    %esi
 4b8:	5d                   	pop    %ebp
 4b9:	c3                   	ret    

000004ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ba:	b8 01 00 00 00       	mov    $0x1,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <exit>:
SYSCALL(exit)
 4c2:	b8 02 00 00 00       	mov    $0x2,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <wait>:
SYSCALL(wait)
 4ca:	b8 03 00 00 00       	mov    $0x3,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <pipe>:
SYSCALL(pipe)
 4d2:	b8 04 00 00 00       	mov    $0x4,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <read>:
SYSCALL(read)
 4da:	b8 05 00 00 00       	mov    $0x5,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <write>:
SYSCALL(write)
 4e2:	b8 10 00 00 00       	mov    $0x10,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <close>:
SYSCALL(close)
 4ea:	b8 15 00 00 00       	mov    $0x15,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <kill>:
SYSCALL(kill)
 4f2:	b8 06 00 00 00       	mov    $0x6,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <exec>:
SYSCALL(exec)
 4fa:	b8 07 00 00 00       	mov    $0x7,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <open>:
SYSCALL(open)
 502:	b8 0f 00 00 00       	mov    $0xf,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <mknod>:
SYSCALL(mknod)
 50a:	b8 11 00 00 00       	mov    $0x11,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <unlink>:
SYSCALL(unlink)
 512:	b8 12 00 00 00       	mov    $0x12,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <fstat>:
SYSCALL(fstat)
 51a:	b8 08 00 00 00       	mov    $0x8,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <link>:
SYSCALL(link)
 522:	b8 13 00 00 00       	mov    $0x13,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <mkdir>:
SYSCALL(mkdir)
 52a:	b8 14 00 00 00       	mov    $0x14,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <chdir>:
SYSCALL(chdir)
 532:	b8 09 00 00 00       	mov    $0x9,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <dup>:
SYSCALL(dup)
 53a:	b8 0a 00 00 00       	mov    $0xa,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <getpid>:
SYSCALL(getpid)
 542:	b8 0b 00 00 00       	mov    $0xb,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <sbrk>:
SYSCALL(sbrk)
 54a:	b8 0c 00 00 00       	mov    $0xc,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <sleep>:
SYSCALL(sleep)
 552:	b8 0d 00 00 00       	mov    $0xd,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <uptime>:
SYSCALL(uptime)
 55a:	b8 0e 00 00 00       	mov    $0xe,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    
 562:	66 90                	xchg   %ax,%ax
 564:	66 90                	xchg   %ax,%ax
 566:	66 90                	xchg   %ax,%ax
 568:	66 90                	xchg   %ax,%ax
 56a:	66 90                	xchg   %ax,%ax
 56c:	66 90                	xchg   %ax,%ax
 56e:	66 90                	xchg   %ax,%ax

00000570 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 579:	85 d2                	test   %edx,%edx
{
 57b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 57e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 580:	79 76                	jns    5f8 <printint+0x88>
 582:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 586:	74 70                	je     5f8 <printint+0x88>
    x = -xx;
 588:	f7 d8                	neg    %eax
    neg = 1;
 58a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 591:	31 f6                	xor    %esi,%esi
 593:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 596:	eb 0a                	jmp    5a2 <printint+0x32>
 598:	90                   	nop
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 5a0:	89 fe                	mov    %edi,%esi
 5a2:	31 d2                	xor    %edx,%edx
 5a4:	8d 7e 01             	lea    0x1(%esi),%edi
 5a7:	f7 f1                	div    %ecx
 5a9:	0f b6 92 d0 09 00 00 	movzbl 0x9d0(%edx),%edx
  }while((x /= base) != 0);
 5b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5b2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 5b5:	75 e9                	jne    5a0 <printint+0x30>
  if(neg)
 5b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5ba:	85 c0                	test   %eax,%eax
 5bc:	74 08                	je     5c6 <printint+0x56>
    buf[i++] = '-';
 5be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5c3:	8d 7e 02             	lea    0x2(%esi),%edi
 5c6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5ca:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
 5d0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
 5d6:	83 ee 01             	sub    $0x1,%esi
 5d9:	6a 01                	push   $0x1
 5db:	53                   	push   %ebx
 5dc:	57                   	push   %edi
 5dd:	88 45 d7             	mov    %al,-0x29(%ebp)
 5e0:	e8 fd fe ff ff       	call   4e2 <write>

  while(--i >= 0)
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	39 de                	cmp    %ebx,%esi
 5ea:	75 e4                	jne    5d0 <printint+0x60>
    putc(fd, buf[i]);
}
 5ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5f                   	pop    %edi
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5f8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5ff:	eb 90                	jmp    591 <printint+0x21>
 601:	eb 0d                	jmp    610 <printf>
 603:	90                   	nop
 604:	90                   	nop
 605:	90                   	nop
 606:	90                   	nop
 607:	90                   	nop
 608:	90                   	nop
 609:	90                   	nop
 60a:	90                   	nop
 60b:	90                   	nop
 60c:	90                   	nop
 60d:	90                   	nop
 60e:	90                   	nop
 60f:	90                   	nop

00000610 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 619:	8b 75 0c             	mov    0xc(%ebp),%esi
 61c:	0f b6 1e             	movzbl (%esi),%ebx
 61f:	84 db                	test   %bl,%bl
 621:	0f 84 b3 00 00 00    	je     6da <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 627:	8d 45 10             	lea    0x10(%ebp),%eax
 62a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 62d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 62f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 632:	eb 2f                	jmp    663 <printf+0x53>
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 638:	83 f8 25             	cmp    $0x25,%eax
 63b:	0f 84 a7 00 00 00    	je     6e8 <printf+0xd8>
  write(fd, &c, 1);
 641:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 644:	83 ec 04             	sub    $0x4,%esp
 647:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 64a:	6a 01                	push   $0x1
 64c:	50                   	push   %eax
 64d:	ff 75 08             	pushl  0x8(%ebp)
 650:	e8 8d fe ff ff       	call   4e2 <write>
 655:	83 c4 10             	add    $0x10,%esp
 658:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 65b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 65f:	84 db                	test   %bl,%bl
 661:	74 77                	je     6da <printf+0xca>
    if(state == 0){
 663:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 665:	0f be cb             	movsbl %bl,%ecx
 668:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 66b:	74 cb                	je     638 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 66d:	83 ff 25             	cmp    $0x25,%edi
 670:	75 e6                	jne    658 <printf+0x48>
      if(c == 'd'){
 672:	83 f8 64             	cmp    $0x64,%eax
 675:	0f 84 05 01 00 00    	je     780 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 67b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 681:	83 f9 70             	cmp    $0x70,%ecx
 684:	74 72                	je     6f8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 686:	83 f8 73             	cmp    $0x73,%eax
 689:	0f 84 99 00 00 00    	je     728 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 68f:	83 f8 63             	cmp    $0x63,%eax
 692:	0f 84 08 01 00 00    	je     7a0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 698:	83 f8 25             	cmp    $0x25,%eax
 69b:	0f 84 ef 00 00 00    	je     790 <printf+0x180>
  write(fd, &c, 1);
 6a1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6a4:	83 ec 04             	sub    $0x4,%esp
 6a7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6ab:	6a 01                	push   $0x1
 6ad:	50                   	push   %eax
 6ae:	ff 75 08             	pushl  0x8(%ebp)
 6b1:	e8 2c fe ff ff       	call   4e2 <write>
 6b6:	83 c4 0c             	add    $0xc,%esp
 6b9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6bc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6bf:	6a 01                	push   $0x1
 6c1:	50                   	push   %eax
 6c2:	ff 75 08             	pushl  0x8(%ebp)
 6c5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6c8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6ca:	e8 13 fe ff ff       	call   4e2 <write>
  for(i = 0; fmt[i]; i++){
 6cf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 6d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6d6:	84 db                	test   %bl,%bl
 6d8:	75 89                	jne    663 <printf+0x53>
    }
  }
}
 6da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6dd:	5b                   	pop    %ebx
 6de:	5e                   	pop    %esi
 6df:	5f                   	pop    %edi
 6e0:	5d                   	pop    %ebp
 6e1:	c3                   	ret    
 6e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 6e8:	bf 25 00 00 00       	mov    $0x25,%edi
 6ed:	e9 66 ff ff ff       	jmp    658 <printf+0x48>
 6f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6f8:	83 ec 0c             	sub    $0xc,%esp
 6fb:	b9 10 00 00 00       	mov    $0x10,%ecx
 700:	6a 00                	push   $0x0
 702:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 705:	8b 45 08             	mov    0x8(%ebp),%eax
 708:	8b 17                	mov    (%edi),%edx
 70a:	e8 61 fe ff ff       	call   570 <printint>
        ap++;
 70f:	89 f8                	mov    %edi,%eax
 711:	83 c4 10             	add    $0x10,%esp
      state = 0;
 714:	31 ff                	xor    %edi,%edi
        ap++;
 716:	83 c0 04             	add    $0x4,%eax
 719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 71c:	e9 37 ff ff ff       	jmp    658 <printf+0x48>
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 72b:	8b 08                	mov    (%eax),%ecx
        ap++;
 72d:	83 c0 04             	add    $0x4,%eax
 730:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 733:	85 c9                	test   %ecx,%ecx
 735:	0f 84 8e 00 00 00    	je     7c9 <printf+0x1b9>
        while(*s != 0){
 73b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 73e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 740:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 742:	84 c0                	test   %al,%al
 744:	0f 84 0e ff ff ff    	je     658 <printf+0x48>
 74a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 74d:	89 de                	mov    %ebx,%esi
 74f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 752:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 755:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 758:	83 ec 04             	sub    $0x4,%esp
          s++;
 75b:	83 c6 01             	add    $0x1,%esi
 75e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 761:	6a 01                	push   $0x1
 763:	57                   	push   %edi
 764:	53                   	push   %ebx
 765:	e8 78 fd ff ff       	call   4e2 <write>
        while(*s != 0){
 76a:	0f b6 06             	movzbl (%esi),%eax
 76d:	83 c4 10             	add    $0x10,%esp
 770:	84 c0                	test   %al,%al
 772:	75 e4                	jne    758 <printf+0x148>
 774:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 777:	31 ff                	xor    %edi,%edi
 779:	e9 da fe ff ff       	jmp    658 <printf+0x48>
 77e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	b9 0a 00 00 00       	mov    $0xa,%ecx
 788:	6a 01                	push   $0x1
 78a:	e9 73 ff ff ff       	jmp    702 <printf+0xf2>
 78f:	90                   	nop
  write(fd, &c, 1);
 790:	83 ec 04             	sub    $0x4,%esp
 793:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 796:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 799:	6a 01                	push   $0x1
 79b:	e9 21 ff ff ff       	jmp    6c1 <printf+0xb1>
        putc(fd, *ap);
 7a0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 7a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7a6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 7a8:	6a 01                	push   $0x1
        ap++;
 7aa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 7ad:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7b3:	50                   	push   %eax
 7b4:	ff 75 08             	pushl  0x8(%ebp)
 7b7:	e8 26 fd ff ff       	call   4e2 <write>
        ap++;
 7bc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7bf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7c2:	31 ff                	xor    %edi,%edi
 7c4:	e9 8f fe ff ff       	jmp    658 <printf+0x48>
          s = "(null)";
 7c9:	bb c9 09 00 00       	mov    $0x9c9,%ebx
        while(*s != 0){
 7ce:	b8 28 00 00 00       	mov    $0x28,%eax
 7d3:	e9 72 ff ff ff       	jmp    74a <printf+0x13a>
 7d8:	66 90                	xchg   %ax,%ax
 7da:	66 90                	xchg   %ax,%ax
 7dc:	66 90                	xchg   %ax,%ax
 7de:	66 90                	xchg   %ax,%ax

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 80 0c 00 00       	mov    0xc80,%eax
{
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	57                   	push   %edi
 7e9:	56                   	push   %esi
 7ea:	53                   	push   %ebx
 7eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f8:	39 c8                	cmp    %ecx,%eax
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	73 32                	jae    830 <free+0x50>
 7fe:	39 d1                	cmp    %edx,%ecx
 800:	72 04                	jb     806 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	39 d0                	cmp    %edx,%eax
 804:	72 32                	jb     838 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 806:	8b 73 fc             	mov    -0x4(%ebx),%esi
 809:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 80c:	39 fa                	cmp    %edi,%edx
 80e:	74 30                	je     840 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 810:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 819:	39 f1                	cmp    %esi,%ecx
 81b:	74 3a                	je     857 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 81d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 81f:	a3 80 0c 00 00       	mov    %eax,0xc80
}
 824:	5b                   	pop    %ebx
 825:	5e                   	pop    %esi
 826:	5f                   	pop    %edi
 827:	5d                   	pop    %ebp
 828:	c3                   	ret    
 829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	39 d0                	cmp    %edx,%eax
 832:	72 04                	jb     838 <free+0x58>
 834:	39 d1                	cmp    %edx,%ecx
 836:	72 ce                	jb     806 <free+0x26>
{
 838:	89 d0                	mov    %edx,%eax
 83a:	eb bc                	jmp    7f8 <free+0x18>
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 840:	03 72 04             	add    0x4(%edx),%esi
 843:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 12                	mov    (%edx),%edx
 84a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 853:	39 f1                	cmp    %esi,%ecx
 855:	75 c6                	jne    81d <free+0x3d>
    p->s.size += bp->s.size;
 857:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 85a:	a3 80 0c 00 00       	mov    %eax,0xc80
    p->s.size += bp->s.size;
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 53 f8             	mov    -0x8(%ebx),%edx
 865:	89 10                	mov    %edx,(%eax)
}
 867:	5b                   	pop    %ebx
 868:	5e                   	pop    %esi
 869:	5f                   	pop    %edi
 86a:	5d                   	pop    %ebp
 86b:	c3                   	ret    
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 87c:	8b 15 80 0c 00 00    	mov    0xc80,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	8d 78 07             	lea    0x7(%eax),%edi
 885:	c1 ef 03             	shr    $0x3,%edi
 888:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 88b:	85 d2                	test   %edx,%edx
 88d:	0f 84 9d 00 00 00    	je     930 <malloc+0xc0>
 893:	8b 02                	mov    (%edx),%eax
 895:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 898:	39 cf                	cmp    %ecx,%edi
 89a:	76 6c                	jbe    908 <malloc+0x98>
 89c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 8a2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8a7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8aa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8b1:	eb 0e                	jmp    8c1 <malloc+0x51>
 8b3:	90                   	nop
 8b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ba:	8b 48 04             	mov    0x4(%eax),%ecx
 8bd:	39 f9                	cmp    %edi,%ecx
 8bf:	73 47                	jae    908 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c1:	39 05 80 0c 00 00    	cmp    %eax,0xc80
 8c7:	89 c2                	mov    %eax,%edx
 8c9:	75 ed                	jne    8b8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8cb:	83 ec 0c             	sub    $0xc,%esp
 8ce:	56                   	push   %esi
 8cf:	e8 76 fc ff ff       	call   54a <sbrk>
  if(p == (char*)-1)
 8d4:	83 c4 10             	add    $0x10,%esp
 8d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8da:	74 1c                	je     8f8 <malloc+0x88>
  hp->s.size = nu;
 8dc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8df:	83 ec 0c             	sub    $0xc,%esp
 8e2:	83 c0 08             	add    $0x8,%eax
 8e5:	50                   	push   %eax
 8e6:	e8 f5 fe ff ff       	call   7e0 <free>
  return freep;
 8eb:	8b 15 80 0c 00 00    	mov    0xc80,%edx
      if((p = morecore(nunits)) == 0)
 8f1:	83 c4 10             	add    $0x10,%esp
 8f4:	85 d2                	test   %edx,%edx
 8f6:	75 c0                	jne    8b8 <malloc+0x48>
        return 0;
  }
}
 8f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8fb:	31 c0                	xor    %eax,%eax
}
 8fd:	5b                   	pop    %ebx
 8fe:	5e                   	pop    %esi
 8ff:	5f                   	pop    %edi
 900:	5d                   	pop    %ebp
 901:	c3                   	ret    
 902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 908:	39 cf                	cmp    %ecx,%edi
 90a:	74 54                	je     960 <malloc+0xf0>
        p->s.size -= nunits;
 90c:	29 f9                	sub    %edi,%ecx
 90e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 911:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 914:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 917:	89 15 80 0c 00 00    	mov    %edx,0xc80
}
 91d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 920:	83 c0 08             	add    $0x8,%eax
}
 923:	5b                   	pop    %ebx
 924:	5e                   	pop    %esi
 925:	5f                   	pop    %edi
 926:	5d                   	pop    %ebp
 927:	c3                   	ret    
 928:	90                   	nop
 929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 930:	c7 05 80 0c 00 00 84 	movl   $0xc84,0xc80
 937:	0c 00 00 
 93a:	c7 05 84 0c 00 00 84 	movl   $0xc84,0xc84
 941:	0c 00 00 
    base.s.size = 0;
 944:	b8 84 0c 00 00       	mov    $0xc84,%eax
 949:	c7 05 88 0c 00 00 00 	movl   $0x0,0xc88
 950:	00 00 00 
 953:	e9 44 ff ff ff       	jmp    89c <malloc+0x2c>
 958:	90                   	nop
 959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 960:	8b 08                	mov    (%eax),%ecx
 962:	89 0a                	mov    %ecx,(%edx)
 964:	eb b1                	jmp    917 <malloc+0xa7>
