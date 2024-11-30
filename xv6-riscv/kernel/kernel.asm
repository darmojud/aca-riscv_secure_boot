
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000081000000 <_entry>:
    81000000:	040000ef          	jal	81000040 <start>

0000000081000004 <spin>:
    81000004:	a001                	j	81000004 <spin>

0000000081000006 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    81000006:	1141                	addi	sp,sp,-16
    81000008:	e406                	sd	ra,8(sp)
    8100000a:	e022                	sd	s0,0(sp)
    8100000c:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    8100000e:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    81000012:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    81000016:	30479073          	csrw	mie,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8100001a:	306027f3          	csrr	a5,mcounteren
  
  // enable the sstc extension (i.e. stimecmp).
//  w_menvcfg(r_menvcfg() | (1L << 63)); 
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    8100001e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    81000022:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    81000026:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8100002a:	000f4737          	lui	a4,0xf4
    8100002e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x80f0bdc0>
    81000032:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    81000034:	14d79073          	csrw	stimecmp,a5
}
    81000038:	60a2                	ld	ra,8(sp)
    8100003a:	6402                	ld	s0,0(sp)
    8100003c:	0141                	addi	sp,sp,16
    8100003e:	8082                	ret

0000000081000040 <start>:
{
    81000040:	1141                	addi	sp,sp,-16
    81000042:	e406                	sd	ra,8(sp)
    81000044:	e022                	sd	s0,0(sp)
    81000046:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
    81000048:	300027f3          	csrr	a5,mstatus
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8100004c:	300027f3          	csrr	a5,mstatus
    81000050:	300027f3          	csrr	a5,mstatus
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
    81000054:	30002773          	csrr	a4,mstatus
  asm volatile("csrci mstatus, %0" : : "i" (MSTATUS_MIE));
    81000058:	30047073          	csrci	mstatus,8
  asm volatile("csrr %0, %1" : "=r" (x) : "i" (MENVCFG));
    8100005c:	30a026f3          	csrr	a3,0x30a
asm volatile("csrci mstatus, %0" : : "i" (MSTATUS_MIE));
    81000060:	30047073          	csrci	mstatus,8
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    81000064:	577d                	li	a4,-1
    81000066:	03f71613          	slli	a2,a4,0x3f
    8100006a:	8ed1                	or	a3,a3,a2
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8100006c:	30a69073          	csrw	0x30a,a3
  x2 &= ~MSTATUS_MPP_MASK;
    81000070:	76f9                	lui	a3,0xffffe
    81000072:	7ff68693          	addi	a3,a3,2047 # ffffffffffffe7ff <end+0xffffffff7efe57ff>
    81000076:	8ff5                	and	a5,a5,a3
  x2 |= MSTATUS_MPP_S;
    81000078:	6685                	lui	a3,0x1
    8100007a:	80068693          	addi	a3,a3,-2048 # 800 <_entry-0x80fff800>
    8100007e:	8fd5                	or	a5,a5,a3
  asm volatile("csrw mstatus, %0" : : "r" (x));
    81000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
    81000084:	300027f3          	csrr	a5,mstatus
  asm volatile(
    81000088:	878a                	mv	a5,sp
    8100008a:	341026f3          	csrr	a3,mepc
  asm volatile("csrw mepc, %0" : : "r" (x));
    8100008e:	00001797          	auipc	a5,0x1
    81000092:	e0478793          	addi	a5,a5,-508 # 81000e92 <main>
    81000096:	34179073          	csrw	mepc,a5
  asm volatile(
    8100009a:	878a                	mv	a5,sp
    8100009c:	341026f3          	csrr	a3,mepc
  asm volatile("csrw satp, %0" : : "r" (x));
    810000a0:	4781                	li	a5,0
    810000a2:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    810000a6:	67c1                	lui	a5,0x10
    810000a8:	97ba                	add	a5,a5,a4
    810000aa:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    810000ae:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    810000b2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    810000b6:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    810000ba:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    810000be:	8329                	srli	a4,a4,0xa
    810000c0:	3b071073          	csrw	pmpaddr0,a4
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    810000c4:	47bd                	li	a5,15
    810000c6:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
    810000ca:	300027f3          	csrr	a5,mstatus
  timerinit();
    810000ce:	f39ff0ef          	jal	81000006 <timerinit>
  asm volatile("mret");
    810000d2:	30200073          	mret
}
    810000d6:	60a2                	ld	ra,8(sp)
    810000d8:	6402                	ld	s0,0(sp)
    810000da:	0141                	addi	sp,sp,16
    810000dc:	8082                	ret

00000000810000de <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    810000de:	711d                	addi	sp,sp,-96
    810000e0:	ec86                	sd	ra,88(sp)
    810000e2:	e8a2                	sd	s0,80(sp)
    810000e4:	e0ca                	sd	s2,64(sp)
    810000e6:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    810000e8:	04c05863          	blez	a2,81000138 <consolewrite+0x5a>
    810000ec:	e4a6                	sd	s1,72(sp)
    810000ee:	fc4e                	sd	s3,56(sp)
    810000f0:	f852                	sd	s4,48(sp)
    810000f2:	f456                	sd	s5,40(sp)
    810000f4:	f05a                	sd	s6,32(sp)
    810000f6:	ec5e                	sd	s7,24(sp)
    810000f8:	8a2a                	mv	s4,a0
    810000fa:	84ae                	mv	s1,a1
    810000fc:	89b2                	mv	s3,a2
    810000fe:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    81000100:	faf40b93          	addi	s7,s0,-81
    81000104:	4b05                	li	s6,1
    81000106:	5afd                	li	s5,-1
    81000108:	86da                	mv	a3,s6
    8100010a:	8626                	mv	a2,s1
    8100010c:	85d2                	mv	a1,s4
    8100010e:	855e                	mv	a0,s7
    81000110:	134020ef          	jal	81002244 <either_copyin>
    81000114:	03550463          	beq	a0,s5,8100013c <consolewrite+0x5e>
      break;
    uartputc(c);
    81000118:	faf44503          	lbu	a0,-81(s0)
    8100011c:	02d000ef          	jal	81000948 <uartputc>
  for(i = 0; i < n; i++){
    81000120:	2905                	addiw	s2,s2,1
    81000122:	0485                	addi	s1,s1,1
    81000124:	ff2992e3          	bne	s3,s2,81000108 <consolewrite+0x2a>
    81000128:	894e                	mv	s2,s3
    8100012a:	64a6                	ld	s1,72(sp)
    8100012c:	79e2                	ld	s3,56(sp)
    8100012e:	7a42                	ld	s4,48(sp)
    81000130:	7aa2                	ld	s5,40(sp)
    81000132:	7b02                	ld	s6,32(sp)
    81000134:	6be2                	ld	s7,24(sp)
    81000136:	a809                	j	81000148 <consolewrite+0x6a>
    81000138:	4901                	li	s2,0
    8100013a:	a039                	j	81000148 <consolewrite+0x6a>
    8100013c:	64a6                	ld	s1,72(sp)
    8100013e:	79e2                	ld	s3,56(sp)
    81000140:	7a42                	ld	s4,48(sp)
    81000142:	7aa2                	ld	s5,40(sp)
    81000144:	7b02                	ld	s6,32(sp)
    81000146:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    81000148:	854a                	mv	a0,s2
    8100014a:	60e6                	ld	ra,88(sp)
    8100014c:	6446                	ld	s0,80(sp)
    8100014e:	6906                	ld	s2,64(sp)
    81000150:	6125                	addi	sp,sp,96
    81000152:	8082                	ret

0000000081000154 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    81000154:	711d                	addi	sp,sp,-96
    81000156:	ec86                	sd	ra,88(sp)
    81000158:	e8a2                	sd	s0,80(sp)
    8100015a:	e4a6                	sd	s1,72(sp)
    8100015c:	e0ca                	sd	s2,64(sp)
    8100015e:	fc4e                	sd	s3,56(sp)
    81000160:	f852                	sd	s4,48(sp)
    81000162:	f456                	sd	s5,40(sp)
    81000164:	f05a                	sd	s6,32(sp)
    81000166:	1080                	addi	s0,sp,96
    81000168:	8aaa                	mv	s5,a0
    8100016a:	8a2e                	mv	s4,a1
    8100016c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8100016e:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    81000170:	00007517          	auipc	a0,0x7
    81000174:	7a050513          	addi	a0,a0,1952 # 81007910 <cons>
    81000178:	295000ef          	jal	81000c0c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8100017c:	00007497          	auipc	s1,0x7
    81000180:	79448493          	addi	s1,s1,1940 # 81007910 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    81000184:	00008917          	auipc	s2,0x8
    81000188:	82490913          	addi	s2,s2,-2012 # 810079a8 <cons+0x98>
  while(n > 0){
    8100018c:	0b305b63          	blez	s3,81000242 <consoleread+0xee>
    while(cons.r == cons.w){
    81000190:	0984a783          	lw	a5,152(s1)
    81000194:	09c4a703          	lw	a4,156(s1)
    81000198:	0af71063          	bne	a4,a5,81000238 <consoleread+0xe4>
      if(killed(myproc())){
    8100019c:	73a010ef          	jal	810018d6 <myproc>
    810001a0:	73d010ef          	jal	810020dc <killed>
    810001a4:	e12d                	bnez	a0,81000206 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    810001a6:	85a6                	mv	a1,s1
    810001a8:	854a                	mv	a0,s2
    810001aa:	4fb010ef          	jal	81001ea4 <sleep>
    while(cons.r == cons.w){
    810001ae:	0984a783          	lw	a5,152(s1)
    810001b2:	09c4a703          	lw	a4,156(s1)
    810001b6:	fef703e3          	beq	a4,a5,8100019c <consoleread+0x48>
    810001ba:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    810001bc:	00007717          	auipc	a4,0x7
    810001c0:	75470713          	addi	a4,a4,1876 # 81007910 <cons>
    810001c4:	0017869b          	addiw	a3,a5,1 # 10001 <_entry-0x80feffff>
    810001c8:	08d72c23          	sw	a3,152(a4)
    810001cc:	07f7f693          	andi	a3,a5,127
    810001d0:	9736                	add	a4,a4,a3
    810001d2:	01874703          	lbu	a4,24(a4)
    810001d6:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    810001da:	4691                	li	a3,4
    810001dc:	04db8663          	beq	s7,a3,81000228 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    810001e0:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    810001e4:	4685                	li	a3,1
    810001e6:	faf40613          	addi	a2,s0,-81
    810001ea:	85d2                	mv	a1,s4
    810001ec:	8556                	mv	a0,s5
    810001ee:	00c020ef          	jal	810021fa <either_copyout>
    810001f2:	57fd                	li	a5,-1
    810001f4:	04f50663          	beq	a0,a5,81000240 <consoleread+0xec>
      break;

    dst++;
    810001f8:	0a05                	addi	s4,s4,1
    --n;
    810001fa:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    810001fc:	47a9                	li	a5,10
    810001fe:	04fb8b63          	beq	s7,a5,81000254 <consoleread+0x100>
    81000202:	6be2                	ld	s7,24(sp)
    81000204:	b761                	j	8100018c <consoleread+0x38>
        release(&cons.lock);
    81000206:	00007517          	auipc	a0,0x7
    8100020a:	70a50513          	addi	a0,a0,1802 # 81007910 <cons>
    8100020e:	293000ef          	jal	81000ca0 <release>
        return -1;
    81000212:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    81000214:	60e6                	ld	ra,88(sp)
    81000216:	6446                	ld	s0,80(sp)
    81000218:	64a6                	ld	s1,72(sp)
    8100021a:	6906                	ld	s2,64(sp)
    8100021c:	79e2                	ld	s3,56(sp)
    8100021e:	7a42                	ld	s4,48(sp)
    81000220:	7aa2                	ld	s5,40(sp)
    81000222:	7b02                	ld	s6,32(sp)
    81000224:	6125                	addi	sp,sp,96
    81000226:	8082                	ret
      if(n < target){
    81000228:	0169fa63          	bgeu	s3,s6,8100023c <consoleread+0xe8>
        cons.r--;
    8100022c:	00007717          	auipc	a4,0x7
    81000230:	76f72e23          	sw	a5,1916(a4) # 810079a8 <cons+0x98>
    81000234:	6be2                	ld	s7,24(sp)
    81000236:	a031                	j	81000242 <consoleread+0xee>
    81000238:	ec5e                	sd	s7,24(sp)
    8100023a:	b749                	j	810001bc <consoleread+0x68>
    8100023c:	6be2                	ld	s7,24(sp)
    8100023e:	a011                	j	81000242 <consoleread+0xee>
    81000240:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    81000242:	00007517          	auipc	a0,0x7
    81000246:	6ce50513          	addi	a0,a0,1742 # 81007910 <cons>
    8100024a:	257000ef          	jal	81000ca0 <release>
  return target - n;
    8100024e:	413b053b          	subw	a0,s6,s3
    81000252:	b7c9                	j	81000214 <consoleread+0xc0>
    81000254:	6be2                	ld	s7,24(sp)
    81000256:	b7f5                	j	81000242 <consoleread+0xee>

0000000081000258 <consputc>:
{
    81000258:	1141                	addi	sp,sp,-16
    8100025a:	e406                	sd	ra,8(sp)
    8100025c:	e022                	sd	s0,0(sp)
    8100025e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    81000260:	10000793          	li	a5,256
    81000264:	00f50863          	beq	a0,a5,81000274 <consputc+0x1c>
    uartputc_sync(c);
    81000268:	5fe000ef          	jal	81000866 <uartputc_sync>
}
    8100026c:	60a2                	ld	ra,8(sp)
    8100026e:	6402                	ld	s0,0(sp)
    81000270:	0141                	addi	sp,sp,16
    81000272:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    81000274:	4521                	li	a0,8
    81000276:	5f0000ef          	jal	81000866 <uartputc_sync>
    8100027a:	02000513          	li	a0,32
    8100027e:	5e8000ef          	jal	81000866 <uartputc_sync>
    81000282:	4521                	li	a0,8
    81000284:	5e2000ef          	jal	81000866 <uartputc_sync>
    81000288:	b7d5                	j	8100026c <consputc+0x14>

000000008100028a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8100028a:	7179                	addi	sp,sp,-48
    8100028c:	f406                	sd	ra,40(sp)
    8100028e:	f022                	sd	s0,32(sp)
    81000290:	ec26                	sd	s1,24(sp)
    81000292:	1800                	addi	s0,sp,48
    81000294:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    81000296:	00007517          	auipc	a0,0x7
    8100029a:	67a50513          	addi	a0,a0,1658 # 81007910 <cons>
    8100029e:	16f000ef          	jal	81000c0c <acquire>

  switch(c){
    810002a2:	47d5                	li	a5,21
    810002a4:	08f48e63          	beq	s1,a5,81000340 <consoleintr+0xb6>
    810002a8:	0297c563          	blt	a5,s1,810002d2 <consoleintr+0x48>
    810002ac:	47a1                	li	a5,8
    810002ae:	0ef48863          	beq	s1,a5,8100039e <consoleintr+0x114>
    810002b2:	47c1                	li	a5,16
    810002b4:	10f49963          	bne	s1,a5,810003c6 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    810002b8:	7d7010ef          	jal	8100228e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    810002bc:	00007517          	auipc	a0,0x7
    810002c0:	65450513          	addi	a0,a0,1620 # 81007910 <cons>
    810002c4:	1dd000ef          	jal	81000ca0 <release>
}
    810002c8:	70a2                	ld	ra,40(sp)
    810002ca:	7402                	ld	s0,32(sp)
    810002cc:	64e2                	ld	s1,24(sp)
    810002ce:	6145                	addi	sp,sp,48
    810002d0:	8082                	ret
  switch(c){
    810002d2:	07f00793          	li	a5,127
    810002d6:	0cf48463          	beq	s1,a5,8100039e <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    810002da:	00007717          	auipc	a4,0x7
    810002de:	63670713          	addi	a4,a4,1590 # 81007910 <cons>
    810002e2:	0a072783          	lw	a5,160(a4)
    810002e6:	09872703          	lw	a4,152(a4)
    810002ea:	9f99                	subw	a5,a5,a4
    810002ec:	07f00713          	li	a4,127
    810002f0:	fcf766e3          	bltu	a4,a5,810002bc <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    810002f4:	47b5                	li	a5,13
    810002f6:	0cf48b63          	beq	s1,a5,810003cc <consoleintr+0x142>
      consputc(c);
    810002fa:	8526                	mv	a0,s1
    810002fc:	f5dff0ef          	jal	81000258 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    81000300:	00007797          	auipc	a5,0x7
    81000304:	61078793          	addi	a5,a5,1552 # 81007910 <cons>
    81000308:	0a07a683          	lw	a3,160(a5)
    8100030c:	0016871b          	addiw	a4,a3,1
    81000310:	863a                	mv	a2,a4
    81000312:	0ae7a023          	sw	a4,160(a5)
    81000316:	07f6f693          	andi	a3,a3,127
    8100031a:	97b6                	add	a5,a5,a3
    8100031c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    81000320:	47a9                	li	a5,10
    81000322:	0cf48963          	beq	s1,a5,810003f4 <consoleintr+0x16a>
    81000326:	4791                	li	a5,4
    81000328:	0cf48663          	beq	s1,a5,810003f4 <consoleintr+0x16a>
    8100032c:	00007797          	auipc	a5,0x7
    81000330:	67c7a783          	lw	a5,1660(a5) # 810079a8 <cons+0x98>
    81000334:	9f1d                	subw	a4,a4,a5
    81000336:	08000793          	li	a5,128
    8100033a:	f8f711e3          	bne	a4,a5,810002bc <consoleintr+0x32>
    8100033e:	a85d                	j	810003f4 <consoleintr+0x16a>
    81000340:	e84a                	sd	s2,16(sp)
    81000342:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    81000344:	00007717          	auipc	a4,0x7
    81000348:	5cc70713          	addi	a4,a4,1484 # 81007910 <cons>
    8100034c:	0a072783          	lw	a5,160(a4)
    81000350:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    81000354:	00007497          	auipc	s1,0x7
    81000358:	5bc48493          	addi	s1,s1,1468 # 81007910 <cons>
    while(cons.e != cons.w &&
    8100035c:	4929                	li	s2,10
      consputc(BACKSPACE);
    8100035e:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    81000362:	02f70863          	beq	a4,a5,81000392 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    81000366:	37fd                	addiw	a5,a5,-1
    81000368:	07f7f713          	andi	a4,a5,127
    8100036c:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8100036e:	01874703          	lbu	a4,24(a4)
    81000372:	03270363          	beq	a4,s2,81000398 <consoleintr+0x10e>
      cons.e--;
    81000376:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8100037a:	854e                	mv	a0,s3
    8100037c:	eddff0ef          	jal	81000258 <consputc>
    while(cons.e != cons.w &&
    81000380:	0a04a783          	lw	a5,160(s1)
    81000384:	09c4a703          	lw	a4,156(s1)
    81000388:	fcf71fe3          	bne	a4,a5,81000366 <consoleintr+0xdc>
    8100038c:	6942                	ld	s2,16(sp)
    8100038e:	69a2                	ld	s3,8(sp)
    81000390:	b735                	j	810002bc <consoleintr+0x32>
    81000392:	6942                	ld	s2,16(sp)
    81000394:	69a2                	ld	s3,8(sp)
    81000396:	b71d                	j	810002bc <consoleintr+0x32>
    81000398:	6942                	ld	s2,16(sp)
    8100039a:	69a2                	ld	s3,8(sp)
    8100039c:	b705                	j	810002bc <consoleintr+0x32>
    if(cons.e != cons.w){
    8100039e:	00007717          	auipc	a4,0x7
    810003a2:	57270713          	addi	a4,a4,1394 # 81007910 <cons>
    810003a6:	0a072783          	lw	a5,160(a4)
    810003aa:	09c72703          	lw	a4,156(a4)
    810003ae:	f0f707e3          	beq	a4,a5,810002bc <consoleintr+0x32>
      cons.e--;
    810003b2:	37fd                	addiw	a5,a5,-1
    810003b4:	00007717          	auipc	a4,0x7
    810003b8:	5ef72e23          	sw	a5,1532(a4) # 810079b0 <cons+0xa0>
      consputc(BACKSPACE);
    810003bc:	10000513          	li	a0,256
    810003c0:	e99ff0ef          	jal	81000258 <consputc>
    810003c4:	bde5                	j	810002bc <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    810003c6:	ee048be3          	beqz	s1,810002bc <consoleintr+0x32>
    810003ca:	bf01                	j	810002da <consoleintr+0x50>
      consputc(c);
    810003cc:	4529                	li	a0,10
    810003ce:	e8bff0ef          	jal	81000258 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    810003d2:	00007797          	auipc	a5,0x7
    810003d6:	53e78793          	addi	a5,a5,1342 # 81007910 <cons>
    810003da:	0a07a703          	lw	a4,160(a5)
    810003de:	0017069b          	addiw	a3,a4,1
    810003e2:	8636                	mv	a2,a3
    810003e4:	0ad7a023          	sw	a3,160(a5)
    810003e8:	07f77713          	andi	a4,a4,127
    810003ec:	97ba                	add	a5,a5,a4
    810003ee:	4729                	li	a4,10
    810003f0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    810003f4:	00007797          	auipc	a5,0x7
    810003f8:	5ac7ac23          	sw	a2,1464(a5) # 810079ac <cons+0x9c>
        wakeup(&cons.r);
    810003fc:	00007517          	auipc	a0,0x7
    81000400:	5ac50513          	addi	a0,a0,1452 # 810079a8 <cons+0x98>
    81000404:	2ed010ef          	jal	81001ef0 <wakeup>
    81000408:	bd55                	j	810002bc <consoleintr+0x32>

000000008100040a <consoleinit>:

void
consoleinit(void)
{
    8100040a:	1141                	addi	sp,sp,-16
    8100040c:	e406                	sd	ra,8(sp)
    8100040e:	e022                	sd	s0,0(sp)
    81000410:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    81000412:	00007597          	auipc	a1,0x7
    81000416:	bee58593          	addi	a1,a1,-1042 # 81007000 <etext>
    8100041a:	00007517          	auipc	a0,0x7
    8100041e:	4f650513          	addi	a0,a0,1270 # 81007910 <cons>
    81000422:	766000ef          	jal	81000b88 <initlock>

  uartinit();
    81000426:	3ea000ef          	jal	81000810 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8100042a:	00017797          	auipc	a5,0x17
    8100042e:	67e78793          	addi	a5,a5,1662 # 81017aa8 <devsw>
    81000432:	00000717          	auipc	a4,0x0
    81000436:	d2270713          	addi	a4,a4,-734 # 81000154 <consoleread>
    8100043a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8100043c:	00000717          	auipc	a4,0x0
    81000440:	ca270713          	addi	a4,a4,-862 # 810000de <consolewrite>
    81000444:	ef98                	sd	a4,24(a5)
}
    81000446:	60a2                	ld	ra,8(sp)
    81000448:	6402                	ld	s0,0(sp)
    8100044a:	0141                	addi	sp,sp,16
    8100044c:	8082                	ret

000000008100044e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8100044e:	7179                	addi	sp,sp,-48
    81000450:	f406                	sd	ra,40(sp)
    81000452:	f022                	sd	s0,32(sp)
    81000454:	ec26                	sd	s1,24(sp)
    81000456:	e84a                	sd	s2,16(sp)
    81000458:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8100045a:	c219                	beqz	a2,81000460 <printint+0x12>
    8100045c:	06054a63          	bltz	a0,810004d0 <printint+0x82>
    x = -xx;
  else
    x = xx;
    81000460:	4e01                	li	t3,0

  i = 0;
    81000462:	fd040313          	addi	t1,s0,-48
    x = xx;
    81000466:	869a                	mv	a3,t1
  i = 0;
    81000468:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8100046a:	00007817          	auipc	a6,0x7
    8100046e:	30680813          	addi	a6,a6,774 # 81007770 <digits>
    81000472:	88be                	mv	a7,a5
    81000474:	0017861b          	addiw	a2,a5,1
    81000478:	87b2                	mv	a5,a2
    8100047a:	02b57733          	remu	a4,a0,a1
    8100047e:	9742                	add	a4,a4,a6
    81000480:	00074703          	lbu	a4,0(a4)
    81000484:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    81000488:	872a                	mv	a4,a0
    8100048a:	02b55533          	divu	a0,a0,a1
    8100048e:	0685                	addi	a3,a3,1
    81000490:	feb771e3          	bgeu	a4,a1,81000472 <printint+0x24>

  if(sign)
    81000494:	000e0c63          	beqz	t3,810004ac <printint+0x5e>
    buf[i++] = '-';
    81000498:	fe060793          	addi	a5,a2,-32
    8100049c:	00878633          	add	a2,a5,s0
    810004a0:	02d00793          	li	a5,45
    810004a4:	fef60823          	sb	a5,-16(a2)
    810004a8:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    810004ac:	fff7891b          	addiw	s2,a5,-1
    810004b0:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    810004b4:	fff4c503          	lbu	a0,-1(s1)
    810004b8:	da1ff0ef          	jal	81000258 <consputc>
  while(--i >= 0)
    810004bc:	397d                	addiw	s2,s2,-1
    810004be:	14fd                	addi	s1,s1,-1
    810004c0:	fe095ae3          	bgez	s2,810004b4 <printint+0x66>
}
    810004c4:	70a2                	ld	ra,40(sp)
    810004c6:	7402                	ld	s0,32(sp)
    810004c8:	64e2                	ld	s1,24(sp)
    810004ca:	6942                	ld	s2,16(sp)
    810004cc:	6145                	addi	sp,sp,48
    810004ce:	8082                	ret
    x = -xx;
    810004d0:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    810004d4:	4e05                	li	t3,1
    x = -xx;
    810004d6:	b771                	j	81000462 <printint+0x14>

00000000810004d8 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    810004d8:	7155                	addi	sp,sp,-208
    810004da:	e506                	sd	ra,136(sp)
    810004dc:	e122                	sd	s0,128(sp)
    810004de:	f0d2                	sd	s4,96(sp)
    810004e0:	0900                	addi	s0,sp,144
    810004e2:	8a2a                	mv	s4,a0
    810004e4:	e40c                	sd	a1,8(s0)
    810004e6:	e810                	sd	a2,16(s0)
    810004e8:	ec14                	sd	a3,24(s0)
    810004ea:	f018                	sd	a4,32(s0)
    810004ec:	f41c                	sd	a5,40(s0)
    810004ee:	03043823          	sd	a6,48(s0)
    810004f2:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    810004f6:	00007797          	auipc	a5,0x7
    810004fa:	4da7a783          	lw	a5,1242(a5) # 810079d0 <pr+0x18>
    810004fe:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    81000502:	e3a1                	bnez	a5,81000542 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    81000504:	00840793          	addi	a5,s0,8
    81000508:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8100050c:	00054503          	lbu	a0,0(a0)
    81000510:	26050663          	beqz	a0,8100077c <printf+0x2a4>
    81000514:	fca6                	sd	s1,120(sp)
    81000516:	f8ca                	sd	s2,112(sp)
    81000518:	f4ce                	sd	s3,104(sp)
    8100051a:	ecd6                	sd	s5,88(sp)
    8100051c:	e8da                	sd	s6,80(sp)
    8100051e:	e0e2                	sd	s8,64(sp)
    81000520:	fc66                	sd	s9,56(sp)
    81000522:	f86a                	sd	s10,48(sp)
    81000524:	f46e                	sd	s11,40(sp)
    81000526:	4981                	li	s3,0
    if(cx != '%'){
    81000528:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8100052c:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    81000530:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    81000534:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    81000538:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8100053c:	07000d93          	li	s11,112
    81000540:	a80d                	j	81000572 <printf+0x9a>
    acquire(&pr.lock);
    81000542:	00007517          	auipc	a0,0x7
    81000546:	47650513          	addi	a0,a0,1142 # 810079b8 <pr>
    8100054a:	6c2000ef          	jal	81000c0c <acquire>
  va_start(ap, fmt);
    8100054e:	00840793          	addi	a5,s0,8
    81000552:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    81000556:	000a4503          	lbu	a0,0(s4)
    8100055a:	fd4d                	bnez	a0,81000514 <printf+0x3c>
    8100055c:	ac3d                	j	8100079a <printf+0x2c2>
      consputc(cx);
    8100055e:	cfbff0ef          	jal	81000258 <consputc>
      continue;
    81000562:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    81000564:	2485                	addiw	s1,s1,1
    81000566:	89a6                	mv	s3,s1
    81000568:	94d2                	add	s1,s1,s4
    8100056a:	0004c503          	lbu	a0,0(s1)
    8100056e:	1e050b63          	beqz	a0,81000764 <printf+0x28c>
    if(cx != '%'){
    81000572:	ff5516e3          	bne	a0,s5,8100055e <printf+0x86>
    i++;
    81000576:	0019879b          	addiw	a5,s3,1
    8100057a:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8100057c:	00fa0733          	add	a4,s4,a5
    81000580:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    81000584:	1e090063          	beqz	s2,81000764 <printf+0x28c>
    81000588:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    8100058c:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    8100058e:	c701                	beqz	a4,81000596 <printf+0xbe>
    81000590:	97d2                	add	a5,a5,s4
    81000592:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    81000596:	03690763          	beq	s2,s6,810005c4 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    8100059a:	05890163          	beq	s2,s8,810005dc <printf+0x104>
    } else if(c0 == 'u'){
    8100059e:	0d990b63          	beq	s2,s9,81000674 <printf+0x19c>
    } else if(c0 == 'x'){
    810005a2:	13a90163          	beq	s2,s10,810006c4 <printf+0x1ec>
    } else if(c0 == 'p'){
    810005a6:	13b90b63          	beq	s2,s11,810006dc <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    810005aa:	07300793          	li	a5,115
    810005ae:	16f90a63          	beq	s2,a5,81000722 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    810005b2:	1b590463          	beq	s2,s5,8100075a <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    810005b6:	8556                	mv	a0,s5
    810005b8:	ca1ff0ef          	jal	81000258 <consputc>
      consputc(c0);
    810005bc:	854a                	mv	a0,s2
    810005be:	c9bff0ef          	jal	81000258 <consputc>
    810005c2:	b74d                	j	81000564 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    810005c4:	f8843783          	ld	a5,-120(s0)
    810005c8:	00878713          	addi	a4,a5,8
    810005cc:	f8e43423          	sd	a4,-120(s0)
    810005d0:	4605                	li	a2,1
    810005d2:	45a9                	li	a1,10
    810005d4:	4388                	lw	a0,0(a5)
    810005d6:	e79ff0ef          	jal	8100044e <printint>
    810005da:	b769                	j	81000564 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    810005dc:	03670663          	beq	a4,s6,81000608 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    810005e0:	05870263          	beq	a4,s8,81000624 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    810005e4:	0b970463          	beq	a4,s9,8100068c <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    810005e8:	fda717e3          	bne	a4,s10,810005b6 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    810005ec:	f8843783          	ld	a5,-120(s0)
    810005f0:	00878713          	addi	a4,a5,8
    810005f4:	f8e43423          	sd	a4,-120(s0)
    810005f8:	4601                	li	a2,0
    810005fa:	45c1                	li	a1,16
    810005fc:	6388                	ld	a0,0(a5)
    810005fe:	e51ff0ef          	jal	8100044e <printint>
      i += 1;
    81000602:	0029849b          	addiw	s1,s3,2
    81000606:	bfb9                	j	81000564 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    81000608:	f8843783          	ld	a5,-120(s0)
    8100060c:	00878713          	addi	a4,a5,8
    81000610:	f8e43423          	sd	a4,-120(s0)
    81000614:	4605                	li	a2,1
    81000616:	45a9                	li	a1,10
    81000618:	6388                	ld	a0,0(a5)
    8100061a:	e35ff0ef          	jal	8100044e <printint>
      i += 1;
    8100061e:	0029849b          	addiw	s1,s3,2
    81000622:	b789                	j	81000564 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    81000624:	06400793          	li	a5,100
    81000628:	02f68863          	beq	a3,a5,81000658 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8100062c:	07500793          	li	a5,117
    81000630:	06f68c63          	beq	a3,a5,810006a8 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    81000634:	07800793          	li	a5,120
    81000638:	f6f69fe3          	bne	a3,a5,810005b6 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8100063c:	f8843783          	ld	a5,-120(s0)
    81000640:	00878713          	addi	a4,a5,8
    81000644:	f8e43423          	sd	a4,-120(s0)
    81000648:	4601                	li	a2,0
    8100064a:	45c1                	li	a1,16
    8100064c:	6388                	ld	a0,0(a5)
    8100064e:	e01ff0ef          	jal	8100044e <printint>
      i += 2;
    81000652:	0039849b          	addiw	s1,s3,3
    81000656:	b739                	j	81000564 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    81000658:	f8843783          	ld	a5,-120(s0)
    8100065c:	00878713          	addi	a4,a5,8
    81000660:	f8e43423          	sd	a4,-120(s0)
    81000664:	4605                	li	a2,1
    81000666:	45a9                	li	a1,10
    81000668:	6388                	ld	a0,0(a5)
    8100066a:	de5ff0ef          	jal	8100044e <printint>
      i += 2;
    8100066e:	0039849b          	addiw	s1,s3,3
    81000672:	bdcd                	j	81000564 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    81000674:	f8843783          	ld	a5,-120(s0)
    81000678:	00878713          	addi	a4,a5,8
    8100067c:	f8e43423          	sd	a4,-120(s0)
    81000680:	4601                	li	a2,0
    81000682:	45a9                	li	a1,10
    81000684:	4388                	lw	a0,0(a5)
    81000686:	dc9ff0ef          	jal	8100044e <printint>
    8100068a:	bde9                	j	81000564 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8100068c:	f8843783          	ld	a5,-120(s0)
    81000690:	00878713          	addi	a4,a5,8
    81000694:	f8e43423          	sd	a4,-120(s0)
    81000698:	4601                	li	a2,0
    8100069a:	45a9                	li	a1,10
    8100069c:	6388                	ld	a0,0(a5)
    8100069e:	db1ff0ef          	jal	8100044e <printint>
      i += 1;
    810006a2:	0029849b          	addiw	s1,s3,2
    810006a6:	bd7d                	j	81000564 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    810006a8:	f8843783          	ld	a5,-120(s0)
    810006ac:	00878713          	addi	a4,a5,8
    810006b0:	f8e43423          	sd	a4,-120(s0)
    810006b4:	4601                	li	a2,0
    810006b6:	45a9                	li	a1,10
    810006b8:	6388                	ld	a0,0(a5)
    810006ba:	d95ff0ef          	jal	8100044e <printint>
      i += 2;
    810006be:	0039849b          	addiw	s1,s3,3
    810006c2:	b54d                	j	81000564 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    810006c4:	f8843783          	ld	a5,-120(s0)
    810006c8:	00878713          	addi	a4,a5,8
    810006cc:	f8e43423          	sd	a4,-120(s0)
    810006d0:	4601                	li	a2,0
    810006d2:	45c1                	li	a1,16
    810006d4:	4388                	lw	a0,0(a5)
    810006d6:	d79ff0ef          	jal	8100044e <printint>
    810006da:	b569                	j	81000564 <printf+0x8c>
    810006dc:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    810006de:	f8843783          	ld	a5,-120(s0)
    810006e2:	00878713          	addi	a4,a5,8
    810006e6:	f8e43423          	sd	a4,-120(s0)
    810006ea:	0007b983          	ld	s3,0(a5)
  consputc('0');
    810006ee:	03000513          	li	a0,48
    810006f2:	b67ff0ef          	jal	81000258 <consputc>
  consputc('x');
    810006f6:	07800513          	li	a0,120
    810006fa:	b5fff0ef          	jal	81000258 <consputc>
    810006fe:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    81000700:	00007b97          	auipc	s7,0x7
    81000704:	070b8b93          	addi	s7,s7,112 # 81007770 <digits>
    81000708:	03c9d793          	srli	a5,s3,0x3c
    8100070c:	97de                	add	a5,a5,s7
    8100070e:	0007c503          	lbu	a0,0(a5)
    81000712:	b47ff0ef          	jal	81000258 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    81000716:	0992                	slli	s3,s3,0x4
    81000718:	397d                	addiw	s2,s2,-1
    8100071a:	fe0917e3          	bnez	s2,81000708 <printf+0x230>
    8100071e:	6ba6                	ld	s7,72(sp)
    81000720:	b591                	j	81000564 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    81000722:	f8843783          	ld	a5,-120(s0)
    81000726:	00878713          	addi	a4,a5,8
    8100072a:	f8e43423          	sd	a4,-120(s0)
    8100072e:	0007b903          	ld	s2,0(a5)
    81000732:	00090d63          	beqz	s2,8100074c <printf+0x274>
      for(; *s; s++)
    81000736:	00094503          	lbu	a0,0(s2)
    8100073a:	e20505e3          	beqz	a0,81000564 <printf+0x8c>
        consputc(*s);
    8100073e:	b1bff0ef          	jal	81000258 <consputc>
      for(; *s; s++)
    81000742:	0905                	addi	s2,s2,1
    81000744:	00094503          	lbu	a0,0(s2)
    81000748:	f97d                	bnez	a0,8100073e <printf+0x266>
    8100074a:	bd29                	j	81000564 <printf+0x8c>
        s = "(null)";
    8100074c:	00007917          	auipc	s2,0x7
    81000750:	8bc90913          	addi	s2,s2,-1860 # 81007008 <etext+0x8>
      for(; *s; s++)
    81000754:	02800513          	li	a0,40
    81000758:	b7dd                	j	8100073e <printf+0x266>
      consputc('%');
    8100075a:	02500513          	li	a0,37
    8100075e:	afbff0ef          	jal	81000258 <consputc>
    81000762:	b509                	j	81000564 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    81000764:	f7843783          	ld	a5,-136(s0)
    81000768:	e385                	bnez	a5,81000788 <printf+0x2b0>
    8100076a:	74e6                	ld	s1,120(sp)
    8100076c:	7946                	ld	s2,112(sp)
    8100076e:	79a6                	ld	s3,104(sp)
    81000770:	6ae6                	ld	s5,88(sp)
    81000772:	6b46                	ld	s6,80(sp)
    81000774:	6c06                	ld	s8,64(sp)
    81000776:	7ce2                	ld	s9,56(sp)
    81000778:	7d42                	ld	s10,48(sp)
    8100077a:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    8100077c:	4501                	li	a0,0
    8100077e:	60aa                	ld	ra,136(sp)
    81000780:	640a                	ld	s0,128(sp)
    81000782:	7a06                	ld	s4,96(sp)
    81000784:	6169                	addi	sp,sp,208
    81000786:	8082                	ret
    81000788:	74e6                	ld	s1,120(sp)
    8100078a:	7946                	ld	s2,112(sp)
    8100078c:	79a6                	ld	s3,104(sp)
    8100078e:	6ae6                	ld	s5,88(sp)
    81000790:	6b46                	ld	s6,80(sp)
    81000792:	6c06                	ld	s8,64(sp)
    81000794:	7ce2                	ld	s9,56(sp)
    81000796:	7d42                	ld	s10,48(sp)
    81000798:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    8100079a:	00007517          	auipc	a0,0x7
    8100079e:	21e50513          	addi	a0,a0,542 # 810079b8 <pr>
    810007a2:	4fe000ef          	jal	81000ca0 <release>
    810007a6:	bfd9                	j	8100077c <printf+0x2a4>

00000000810007a8 <panic>:

void
panic(char *s)
{
    810007a8:	1101                	addi	sp,sp,-32
    810007aa:	ec06                	sd	ra,24(sp)
    810007ac:	e822                	sd	s0,16(sp)
    810007ae:	e426                	sd	s1,8(sp)
    810007b0:	1000                	addi	s0,sp,32
    810007b2:	84aa                	mv	s1,a0
  pr.locking = 0;
    810007b4:	00007797          	auipc	a5,0x7
    810007b8:	2007ae23          	sw	zero,540(a5) # 810079d0 <pr+0x18>
  printf("panic: ");
    810007bc:	00007517          	auipc	a0,0x7
    810007c0:	85c50513          	addi	a0,a0,-1956 # 81007018 <etext+0x18>
    810007c4:	d15ff0ef          	jal	810004d8 <printf>
  printf("%s\n", s);
    810007c8:	85a6                	mv	a1,s1
    810007ca:	00007517          	auipc	a0,0x7
    810007ce:	85650513          	addi	a0,a0,-1962 # 81007020 <etext+0x20>
    810007d2:	d07ff0ef          	jal	810004d8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    810007d6:	4785                	li	a5,1
    810007d8:	00007717          	auipc	a4,0x7
    810007dc:	0ef72c23          	sw	a5,248(a4) # 810078d0 <panicked>
  for(;;)
    810007e0:	a001                	j	810007e0 <panic+0x38>

00000000810007e2 <printfinit>:
    ;
}

void
printfinit(void)
{
    810007e2:	1101                	addi	sp,sp,-32
    810007e4:	ec06                	sd	ra,24(sp)
    810007e6:	e822                	sd	s0,16(sp)
    810007e8:	e426                	sd	s1,8(sp)
    810007ea:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    810007ec:	00007497          	auipc	s1,0x7
    810007f0:	1cc48493          	addi	s1,s1,460 # 810079b8 <pr>
    810007f4:	00007597          	auipc	a1,0x7
    810007f8:	83458593          	addi	a1,a1,-1996 # 81007028 <etext+0x28>
    810007fc:	8526                	mv	a0,s1
    810007fe:	38a000ef          	jal	81000b88 <initlock>
  pr.locking = 1;
    81000802:	4785                	li	a5,1
    81000804:	cc9c                	sw	a5,24(s1)
}
    81000806:	60e2                	ld	ra,24(sp)
    81000808:	6442                	ld	s0,16(sp)
    8100080a:	64a2                	ld	s1,8(sp)
    8100080c:	6105                	addi	sp,sp,32
    8100080e:	8082                	ret

0000000081000810 <uartinit>:

void uartstart();

void
uartinit(void)
{
    81000810:	1141                	addi	sp,sp,-16
    81000812:	e406                	sd	ra,8(sp)
    81000814:	e022                	sd	s0,0(sp)
    81000816:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    81000818:	100007b7          	lui	a5,0x10000
    8100081c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x70ffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    81000820:	10000737          	lui	a4,0x10000
    81000824:	f8000693          	li	a3,-128
    81000828:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x70fffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8100082c:	468d                	li	a3,3
    8100082e:	10000637          	lui	a2,0x10000
    81000832:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x71000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    81000836:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8100083a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8100083e:	8732                	mv	a4,a2
    81000840:	461d                	li	a2,7
    81000842:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    81000846:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8100084a:	00006597          	auipc	a1,0x6
    8100084e:	7e658593          	addi	a1,a1,2022 # 81007030 <etext+0x30>
    81000852:	00007517          	auipc	a0,0x7
    81000856:	18650513          	addi	a0,a0,390 # 810079d8 <uart_tx_lock>
    8100085a:	32e000ef          	jal	81000b88 <initlock>
}
    8100085e:	60a2                	ld	ra,8(sp)
    81000860:	6402                	ld	s0,0(sp)
    81000862:	0141                	addi	sp,sp,16
    81000864:	8082                	ret

0000000081000866 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    81000866:	1101                	addi	sp,sp,-32
    81000868:	ec06                	sd	ra,24(sp)
    8100086a:	e822                	sd	s0,16(sp)
    8100086c:	e426                	sd	s1,8(sp)
    8100086e:	1000                	addi	s0,sp,32
    81000870:	84aa                	mv	s1,a0
  push_off();
    81000872:	35a000ef          	jal	81000bcc <push_off>

  if(panicked){
    81000876:	00007797          	auipc	a5,0x7
    8100087a:	05a7a783          	lw	a5,90(a5) # 810078d0 <panicked>
    8100087e:	e795                	bnez	a5,810008aa <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    81000880:	10000737          	lui	a4,0x10000
    81000884:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x70fffffb>
    81000886:	00074783          	lbu	a5,0(a4)
    8100088a:	0207f793          	andi	a5,a5,32
    8100088e:	dfe5                	beqz	a5,81000886 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    81000890:	0ff4f513          	zext.b	a0,s1
    81000894:	100007b7          	lui	a5,0x10000
    81000898:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x71000000>

  pop_off();
    8100089c:	3b4000ef          	jal	81000c50 <pop_off>
}
    810008a0:	60e2                	ld	ra,24(sp)
    810008a2:	6442                	ld	s0,16(sp)
    810008a4:	64a2                	ld	s1,8(sp)
    810008a6:	6105                	addi	sp,sp,32
    810008a8:	8082                	ret
    for(;;)
    810008aa:	a001                	j	810008aa <uartputc_sync+0x44>

00000000810008ac <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    810008ac:	00007797          	auipc	a5,0x7
    810008b0:	02c7b783          	ld	a5,44(a5) # 810078d8 <uart_tx_r>
    810008b4:	00007717          	auipc	a4,0x7
    810008b8:	02c73703          	ld	a4,44(a4) # 810078e0 <uart_tx_w>
    810008bc:	08f70163          	beq	a4,a5,8100093e <uartstart+0x92>
{
    810008c0:	7139                	addi	sp,sp,-64
    810008c2:	fc06                	sd	ra,56(sp)
    810008c4:	f822                	sd	s0,48(sp)
    810008c6:	f426                	sd	s1,40(sp)
    810008c8:	f04a                	sd	s2,32(sp)
    810008ca:	ec4e                	sd	s3,24(sp)
    810008cc:	e852                	sd	s4,16(sp)
    810008ce:	e456                	sd	s5,8(sp)
    810008d0:	e05a                	sd	s6,0(sp)
    810008d2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    810008d4:	10000937          	lui	s2,0x10000
    810008d8:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x70fffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    810008da:	00007a97          	auipc	s5,0x7
    810008de:	0fea8a93          	addi	s5,s5,254 # 810079d8 <uart_tx_lock>
    uart_tx_r += 1;
    810008e2:	00007497          	auipc	s1,0x7
    810008e6:	ff648493          	addi	s1,s1,-10 # 810078d8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    810008ea:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    810008ee:	00007997          	auipc	s3,0x7
    810008f2:	ff298993          	addi	s3,s3,-14 # 810078e0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    810008f6:	00094703          	lbu	a4,0(s2)
    810008fa:	02077713          	andi	a4,a4,32
    810008fe:	c715                	beqz	a4,8100092a <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    81000900:	01f7f713          	andi	a4,a5,31
    81000904:	9756                	add	a4,a4,s5
    81000906:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8100090a:	0785                	addi	a5,a5,1
    8100090c:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8100090e:	8526                	mv	a0,s1
    81000910:	5e0010ef          	jal	81001ef0 <wakeup>
    WriteReg(THR, c);
    81000914:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x71000000>
    if(uart_tx_w == uart_tx_r){
    81000918:	609c                	ld	a5,0(s1)
    8100091a:	0009b703          	ld	a4,0(s3)
    8100091e:	fcf71ce3          	bne	a4,a5,810008f6 <uartstart+0x4a>
      ReadReg(ISR);
    81000922:	100007b7          	lui	a5,0x10000
    81000926:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x70fffffe>
  }
}
    8100092a:	70e2                	ld	ra,56(sp)
    8100092c:	7442                	ld	s0,48(sp)
    8100092e:	74a2                	ld	s1,40(sp)
    81000930:	7902                	ld	s2,32(sp)
    81000932:	69e2                	ld	s3,24(sp)
    81000934:	6a42                	ld	s4,16(sp)
    81000936:	6aa2                	ld	s5,8(sp)
    81000938:	6b02                	ld	s6,0(sp)
    8100093a:	6121                	addi	sp,sp,64
    8100093c:	8082                	ret
      ReadReg(ISR);
    8100093e:	100007b7          	lui	a5,0x10000
    81000942:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x70fffffe>
      return;
    81000946:	8082                	ret

0000000081000948 <uartputc>:
{
    81000948:	7179                	addi	sp,sp,-48
    8100094a:	f406                	sd	ra,40(sp)
    8100094c:	f022                	sd	s0,32(sp)
    8100094e:	ec26                	sd	s1,24(sp)
    81000950:	e84a                	sd	s2,16(sp)
    81000952:	e44e                	sd	s3,8(sp)
    81000954:	e052                	sd	s4,0(sp)
    81000956:	1800                	addi	s0,sp,48
    81000958:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8100095a:	00007517          	auipc	a0,0x7
    8100095e:	07e50513          	addi	a0,a0,126 # 810079d8 <uart_tx_lock>
    81000962:	2aa000ef          	jal	81000c0c <acquire>
  if(panicked){
    81000966:	00007797          	auipc	a5,0x7
    8100096a:	f6a7a783          	lw	a5,-150(a5) # 810078d0 <panicked>
    8100096e:	efbd                	bnez	a5,810009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    81000970:	00007717          	auipc	a4,0x7
    81000974:	f7073703          	ld	a4,-144(a4) # 810078e0 <uart_tx_w>
    81000978:	00007797          	auipc	a5,0x7
    8100097c:	f607b783          	ld	a5,-160(a5) # 810078d8 <uart_tx_r>
    81000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    81000984:	00007997          	auipc	s3,0x7
    81000988:	05498993          	addi	s3,s3,84 # 810079d8 <uart_tx_lock>
    8100098c:	00007497          	auipc	s1,0x7
    81000990:	f4c48493          	addi	s1,s1,-180 # 810078d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    81000994:	00007917          	auipc	s2,0x7
    81000998:	f4c90913          	addi	s2,s2,-180 # 810078e0 <uart_tx_w>
    8100099c:	00e79d63          	bne	a5,a4,810009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    810009a0:	85ce                	mv	a1,s3
    810009a2:	8526                	mv	a0,s1
    810009a4:	500010ef          	jal	81001ea4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    810009a8:	00093703          	ld	a4,0(s2)
    810009ac:	609c                	ld	a5,0(s1)
    810009ae:	02078793          	addi	a5,a5,32
    810009b2:	fee787e3          	beq	a5,a4,810009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    810009b6:	00007497          	auipc	s1,0x7
    810009ba:	02248493          	addi	s1,s1,34 # 810079d8 <uart_tx_lock>
    810009be:	01f77793          	andi	a5,a4,31
    810009c2:	97a6                	add	a5,a5,s1
    810009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    810009c8:	0705                	addi	a4,a4,1
    810009ca:	00007797          	auipc	a5,0x7
    810009ce:	f0e7bb23          	sd	a4,-234(a5) # 810078e0 <uart_tx_w>
  uartstart();
    810009d2:	edbff0ef          	jal	810008ac <uartstart>
  release(&uart_tx_lock);
    810009d6:	8526                	mv	a0,s1
    810009d8:	2c8000ef          	jal	81000ca0 <release>
}
    810009dc:	70a2                	ld	ra,40(sp)
    810009de:	7402                	ld	s0,32(sp)
    810009e0:	64e2                	ld	s1,24(sp)
    810009e2:	6942                	ld	s2,16(sp)
    810009e4:	69a2                	ld	s3,8(sp)
    810009e6:	6a02                	ld	s4,0(sp)
    810009e8:	6145                	addi	sp,sp,48
    810009ea:	8082                	ret
    for(;;)
    810009ec:	a001                	j	810009ec <uartputc+0xa4>

00000000810009ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    810009ee:	1141                	addi	sp,sp,-16
    810009f0:	e406                	sd	ra,8(sp)
    810009f2:	e022                	sd	s0,0(sp)
    810009f4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    810009f6:	100007b7          	lui	a5,0x10000
    810009fa:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x70fffffb>
    810009fe:	8b85                	andi	a5,a5,1
    81000a00:	cb89                	beqz	a5,81000a12 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    81000a02:	100007b7          	lui	a5,0x10000
    81000a06:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x71000000>
  } else {
    return -1;
  }
}
    81000a0a:	60a2                	ld	ra,8(sp)
    81000a0c:	6402                	ld	s0,0(sp)
    81000a0e:	0141                	addi	sp,sp,16
    81000a10:	8082                	ret
    return -1;
    81000a12:	557d                	li	a0,-1
    81000a14:	bfdd                	j	81000a0a <uartgetc+0x1c>

0000000081000a16 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    81000a16:	1101                	addi	sp,sp,-32
    81000a18:	ec06                	sd	ra,24(sp)
    81000a1a:	e822                	sd	s0,16(sp)
    81000a1c:	e426                	sd	s1,8(sp)
    81000a1e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    81000a20:	54fd                	li	s1,-1
    int c = uartgetc();
    81000a22:	fcdff0ef          	jal	810009ee <uartgetc>
    if(c == -1)
    81000a26:	00950563          	beq	a0,s1,81000a30 <uartintr+0x1a>
      break;
    consoleintr(c);
    81000a2a:	861ff0ef          	jal	8100028a <consoleintr>
  while(1){
    81000a2e:	bfd5                	j	81000a22 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    81000a30:	00007497          	auipc	s1,0x7
    81000a34:	fa848493          	addi	s1,s1,-88 # 810079d8 <uart_tx_lock>
    81000a38:	8526                	mv	a0,s1
    81000a3a:	1d2000ef          	jal	81000c0c <acquire>
  uartstart();
    81000a3e:	e6fff0ef          	jal	810008ac <uartstart>
  release(&uart_tx_lock);
    81000a42:	8526                	mv	a0,s1
    81000a44:	25c000ef          	jal	81000ca0 <release>
}
    81000a48:	60e2                	ld	ra,24(sp)
    81000a4a:	6442                	ld	s0,16(sp)
    81000a4c:	64a2                	ld	s1,8(sp)
    81000a4e:	6105                	addi	sp,sp,32
    81000a50:	8082                	ret

0000000081000a52 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    81000a52:	1101                	addi	sp,sp,-32
    81000a54:	ec06                	sd	ra,24(sp)
    81000a56:	e822                	sd	s0,16(sp)
    81000a58:	e426                	sd	s1,8(sp)
    81000a5a:	e04a                	sd	s2,0(sp)
    81000a5c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    81000a5e:	03451793          	slli	a5,a0,0x34
    81000a62:	e7b1                	bnez	a5,81000aae <kfree+0x5c>
    81000a64:	84aa                	mv	s1,a0
    81000a66:	00018797          	auipc	a5,0x18
    81000a6a:	59a78793          	addi	a5,a5,1434 # 81019000 <end>
    81000a6e:	04f56063          	bltu	a0,a5,81000aae <kfree+0x5c>
    81000a72:	08900793          	li	a5,137
    81000a76:	07e2                	slli	a5,a5,0x18
    81000a78:	02f57b63          	bgeu	a0,a5,81000aae <kfree+0x5c>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    81000a7c:	6605                	lui	a2,0x1
    81000a7e:	4585                	li	a1,1
    81000a80:	25c000ef          	jal	81000cdc <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    81000a84:	00007917          	auipc	s2,0x7
    81000a88:	f8c90913          	addi	s2,s2,-116 # 81007a10 <kmem>
    81000a8c:	854a                	mv	a0,s2
    81000a8e:	17e000ef          	jal	81000c0c <acquire>
  r->next = kmem.freelist;
    81000a92:	01893783          	ld	a5,24(s2)
    81000a96:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    81000a98:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    81000a9c:	854a                	mv	a0,s2
    81000a9e:	202000ef          	jal	81000ca0 <release>
}
    81000aa2:	60e2                	ld	ra,24(sp)
    81000aa4:	6442                	ld	s0,16(sp)
    81000aa6:	64a2                	ld	s1,8(sp)
    81000aa8:	6902                	ld	s2,0(sp)
    81000aaa:	6105                	addi	sp,sp,32
    81000aac:	8082                	ret
    panic("kfree");
    81000aae:	00006517          	auipc	a0,0x6
    81000ab2:	58a50513          	addi	a0,a0,1418 # 81007038 <etext+0x38>
    81000ab6:	cf3ff0ef          	jal	810007a8 <panic>

0000000081000aba <freerange>:
{
    81000aba:	7179                	addi	sp,sp,-48
    81000abc:	f406                	sd	ra,40(sp)
    81000abe:	f022                	sd	s0,32(sp)
    81000ac0:	ec26                	sd	s1,24(sp)
    81000ac2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    81000ac4:	6785                	lui	a5,0x1
    81000ac6:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x80fff001>
    81000aca:	00e504b3          	add	s1,a0,a4
    81000ace:	777d                	lui	a4,0xfffff
    81000ad0:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    81000ad2:	94be                	add	s1,s1,a5
    81000ad4:	0295e263          	bltu	a1,s1,81000af8 <freerange+0x3e>
    81000ad8:	e84a                	sd	s2,16(sp)
    81000ada:	e44e                	sd	s3,8(sp)
    81000adc:	e052                	sd	s4,0(sp)
    81000ade:	892e                	mv	s2,a1
    kfree(p);
    81000ae0:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    81000ae2:	89be                	mv	s3,a5
    kfree(p);
    81000ae4:	01448533          	add	a0,s1,s4
    81000ae8:	f6bff0ef          	jal	81000a52 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    81000aec:	94ce                	add	s1,s1,s3
    81000aee:	fe997be3          	bgeu	s2,s1,81000ae4 <freerange+0x2a>
    81000af2:	6942                	ld	s2,16(sp)
    81000af4:	69a2                	ld	s3,8(sp)
    81000af6:	6a02                	ld	s4,0(sp)
}
    81000af8:	70a2                	ld	ra,40(sp)
    81000afa:	7402                	ld	s0,32(sp)
    81000afc:	64e2                	ld	s1,24(sp)
    81000afe:	6145                	addi	sp,sp,48
    81000b00:	8082                	ret

0000000081000b02 <kinit>:
{
    81000b02:	1141                	addi	sp,sp,-16
    81000b04:	e406                	sd	ra,8(sp)
    81000b06:	e022                	sd	s0,0(sp)
    81000b08:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    81000b0a:	00006597          	auipc	a1,0x6
    81000b0e:	53658593          	addi	a1,a1,1334 # 81007040 <etext+0x40>
    81000b12:	00007517          	auipc	a0,0x7
    81000b16:	efe50513          	addi	a0,a0,-258 # 81007a10 <kmem>
    81000b1a:	06e000ef          	jal	81000b88 <initlock>
  freerange(end, (void*)PHYSTOP);
    81000b1e:	08900593          	li	a1,137
    81000b22:	05e2                	slli	a1,a1,0x18
    81000b24:	00018517          	auipc	a0,0x18
    81000b28:	4dc50513          	addi	a0,a0,1244 # 81019000 <end>
    81000b2c:	f8fff0ef          	jal	81000aba <freerange>
}
    81000b30:	60a2                	ld	ra,8(sp)
    81000b32:	6402                	ld	s0,0(sp)
    81000b34:	0141                	addi	sp,sp,16
    81000b36:	8082                	ret

0000000081000b38 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    81000b38:	1101                	addi	sp,sp,-32
    81000b3a:	ec06                	sd	ra,24(sp)
    81000b3c:	e822                	sd	s0,16(sp)
    81000b3e:	e426                	sd	s1,8(sp)
    81000b40:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    81000b42:	00007497          	auipc	s1,0x7
    81000b46:	ece48493          	addi	s1,s1,-306 # 81007a10 <kmem>
    81000b4a:	8526                	mv	a0,s1
    81000b4c:	0c0000ef          	jal	81000c0c <acquire>
  r = kmem.freelist;
    81000b50:	6c84                	ld	s1,24(s1)
  if(r)
    81000b52:	c485                	beqz	s1,81000b7a <kalloc+0x42>
    kmem.freelist = r->next;
    81000b54:	609c                	ld	a5,0(s1)
    81000b56:	00007517          	auipc	a0,0x7
    81000b5a:	eba50513          	addi	a0,a0,-326 # 81007a10 <kmem>
    81000b5e:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    81000b60:	140000ef          	jal	81000ca0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    81000b64:	6605                	lui	a2,0x1
    81000b66:	4595                	li	a1,5
    81000b68:	8526                	mv	a0,s1
    81000b6a:	172000ef          	jal	81000cdc <memset>
  return (void*)r;
}
    81000b6e:	8526                	mv	a0,s1
    81000b70:	60e2                	ld	ra,24(sp)
    81000b72:	6442                	ld	s0,16(sp)
    81000b74:	64a2                	ld	s1,8(sp)
    81000b76:	6105                	addi	sp,sp,32
    81000b78:	8082                	ret
  release(&kmem.lock);
    81000b7a:	00007517          	auipc	a0,0x7
    81000b7e:	e9650513          	addi	a0,a0,-362 # 81007a10 <kmem>
    81000b82:	11e000ef          	jal	81000ca0 <release>
  if(r)
    81000b86:	b7e5                	j	81000b6e <kalloc+0x36>

0000000081000b88 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    81000b88:	1141                	addi	sp,sp,-16
    81000b8a:	e406                	sd	ra,8(sp)
    81000b8c:	e022                	sd	s0,0(sp)
    81000b8e:	0800                	addi	s0,sp,16
  lk->name = name;
    81000b90:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    81000b92:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    81000b96:	00053823          	sd	zero,16(a0)
}
    81000b9a:	60a2                	ld	ra,8(sp)
    81000b9c:	6402                	ld	s0,0(sp)
    81000b9e:	0141                	addi	sp,sp,16
    81000ba0:	8082                	ret

0000000081000ba2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    81000ba2:	411c                	lw	a5,0(a0)
    81000ba4:	e399                	bnez	a5,81000baa <holding+0x8>
    81000ba6:	4501                	li	a0,0
  return r;
}
    81000ba8:	8082                	ret
{
    81000baa:	1101                	addi	sp,sp,-32
    81000bac:	ec06                	sd	ra,24(sp)
    81000bae:	e822                	sd	s0,16(sp)
    81000bb0:	e426                	sd	s1,8(sp)
    81000bb2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    81000bb4:	6904                	ld	s1,16(a0)
    81000bb6:	501000ef          	jal	810018b6 <mycpu>
    81000bba:	40a48533          	sub	a0,s1,a0
    81000bbe:	00153513          	seqz	a0,a0
}
    81000bc2:	60e2                	ld	ra,24(sp)
    81000bc4:	6442                	ld	s0,16(sp)
    81000bc6:	64a2                	ld	s1,8(sp)
    81000bc8:	6105                	addi	sp,sp,32
    81000bca:	8082                	ret

0000000081000bcc <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    81000bcc:	1101                	addi	sp,sp,-32
    81000bce:	ec06                	sd	ra,24(sp)
    81000bd0:	e822                	sd	s0,16(sp)
    81000bd2:	e426                	sd	s1,8(sp)
    81000bd4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81000bd6:	100024f3          	csrr	s1,sstatus
    81000bda:	100027f3          	csrr	a5,sstatus

// disable device interrupts
static inline void
intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    81000bde:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81000be0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    81000be4:	4d3000ef          	jal	810018b6 <mycpu>
    81000be8:	5d3c                	lw	a5,120(a0)
    81000bea:	cb99                	beqz	a5,81000c00 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    81000bec:	4cb000ef          	jal	810018b6 <mycpu>
    81000bf0:	5d3c                	lw	a5,120(a0)
    81000bf2:	2785                	addiw	a5,a5,1
    81000bf4:	dd3c                	sw	a5,120(a0)
}
    81000bf6:	60e2                	ld	ra,24(sp)
    81000bf8:	6442                	ld	s0,16(sp)
    81000bfa:	64a2                	ld	s1,8(sp)
    81000bfc:	6105                	addi	sp,sp,32
    81000bfe:	8082                	ret
    mycpu()->intena = old;
    81000c00:	4b7000ef          	jal	810018b6 <mycpu>
// are device interrupts enabled?
static inline int
intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    81000c04:	8085                	srli	s1,s1,0x1
    81000c06:	8885                	andi	s1,s1,1
    81000c08:	dd64                	sw	s1,124(a0)
    81000c0a:	b7cd                	j	81000bec <push_off+0x20>

0000000081000c0c <acquire>:
{
    81000c0c:	1101                	addi	sp,sp,-32
    81000c0e:	ec06                	sd	ra,24(sp)
    81000c10:	e822                	sd	s0,16(sp)
    81000c12:	e426                	sd	s1,8(sp)
    81000c14:	1000                	addi	s0,sp,32
    81000c16:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    81000c18:	fb5ff0ef          	jal	81000bcc <push_off>
  if(holding(lk))
    81000c1c:	8526                	mv	a0,s1
    81000c1e:	f85ff0ef          	jal	81000ba2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    81000c22:	4705                	li	a4,1
  if(holding(lk))
    81000c24:	e105                	bnez	a0,81000c44 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    81000c26:	87ba                	mv	a5,a4
    81000c28:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    81000c2c:	2781                	sext.w	a5,a5
    81000c2e:	ffe5                	bnez	a5,81000c26 <acquire+0x1a>
  __sync_synchronize();
    81000c30:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    81000c34:	483000ef          	jal	810018b6 <mycpu>
    81000c38:	e888                	sd	a0,16(s1)
}
    81000c3a:	60e2                	ld	ra,24(sp)
    81000c3c:	6442                	ld	s0,16(sp)
    81000c3e:	64a2                	ld	s1,8(sp)
    81000c40:	6105                	addi	sp,sp,32
    81000c42:	8082                	ret
    panic("acquire");
    81000c44:	00006517          	auipc	a0,0x6
    81000c48:	40450513          	addi	a0,a0,1028 # 81007048 <etext+0x48>
    81000c4c:	b5dff0ef          	jal	810007a8 <panic>

0000000081000c50 <pop_off>:

void
pop_off(void)
{
    81000c50:	1141                	addi	sp,sp,-16
    81000c52:	e406                	sd	ra,8(sp)
    81000c54:	e022                	sd	s0,0(sp)
    81000c56:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    81000c58:	45f000ef          	jal	810018b6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81000c5c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    81000c60:	8b89                	andi	a5,a5,2
  if(intr_get())
    81000c62:	e39d                	bnez	a5,81000c88 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    81000c64:	5d3c                	lw	a5,120(a0)
    81000c66:	02f05763          	blez	a5,81000c94 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    81000c6a:	37fd                	addiw	a5,a5,-1
    81000c6c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    81000c6e:	eb89                	bnez	a5,81000c80 <pop_off+0x30>
    81000c70:	5d7c                	lw	a5,124(a0)
    81000c72:	c799                	beqz	a5,81000c80 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81000c74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    81000c78:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81000c7c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    81000c80:	60a2                	ld	ra,8(sp)
    81000c82:	6402                	ld	s0,0(sp)
    81000c84:	0141                	addi	sp,sp,16
    81000c86:	8082                	ret
    panic("pop_off - interruptible");
    81000c88:	00006517          	auipc	a0,0x6
    81000c8c:	3c850513          	addi	a0,a0,968 # 81007050 <etext+0x50>
    81000c90:	b19ff0ef          	jal	810007a8 <panic>
    panic("pop_off");
    81000c94:	00006517          	auipc	a0,0x6
    81000c98:	3d450513          	addi	a0,a0,980 # 81007068 <etext+0x68>
    81000c9c:	b0dff0ef          	jal	810007a8 <panic>

0000000081000ca0 <release>:
{
    81000ca0:	1101                	addi	sp,sp,-32
    81000ca2:	ec06                	sd	ra,24(sp)
    81000ca4:	e822                	sd	s0,16(sp)
    81000ca6:	e426                	sd	s1,8(sp)
    81000ca8:	1000                	addi	s0,sp,32
    81000caa:	84aa                	mv	s1,a0
  if(!holding(lk))
    81000cac:	ef7ff0ef          	jal	81000ba2 <holding>
    81000cb0:	c105                	beqz	a0,81000cd0 <release+0x30>
  lk->cpu = 0;
    81000cb2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    81000cb6:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    81000cba:	0310000f          	fence	rw,w
    81000cbe:	0004a023          	sw	zero,0(s1)
  pop_off();
    81000cc2:	f8fff0ef          	jal	81000c50 <pop_off>
}
    81000cc6:	60e2                	ld	ra,24(sp)
    81000cc8:	6442                	ld	s0,16(sp)
    81000cca:	64a2                	ld	s1,8(sp)
    81000ccc:	6105                	addi	sp,sp,32
    81000cce:	8082                	ret
    panic("release");
    81000cd0:	00006517          	auipc	a0,0x6
    81000cd4:	3a050513          	addi	a0,a0,928 # 81007070 <etext+0x70>
    81000cd8:	ad1ff0ef          	jal	810007a8 <panic>

0000000081000cdc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    81000cdc:	1141                	addi	sp,sp,-16
    81000cde:	e406                	sd	ra,8(sp)
    81000ce0:	e022                	sd	s0,0(sp)
    81000ce2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    81000ce4:	ca19                	beqz	a2,81000cfa <memset+0x1e>
    81000ce6:	87aa                	mv	a5,a0
    81000ce8:	1602                	slli	a2,a2,0x20
    81000cea:	9201                	srli	a2,a2,0x20
    81000cec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    81000cf0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    81000cf4:	0785                	addi	a5,a5,1
    81000cf6:	fee79de3          	bne	a5,a4,81000cf0 <memset+0x14>
  }
  return dst;
}
    81000cfa:	60a2                	ld	ra,8(sp)
    81000cfc:	6402                	ld	s0,0(sp)
    81000cfe:	0141                	addi	sp,sp,16
    81000d00:	8082                	ret

0000000081000d02 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    81000d02:	1141                	addi	sp,sp,-16
    81000d04:	e406                	sd	ra,8(sp)
    81000d06:	e022                	sd	s0,0(sp)
    81000d08:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    81000d0a:	ca0d                	beqz	a2,81000d3c <memcmp+0x3a>
    81000d0c:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x80fff001>
    81000d10:	1682                	slli	a3,a3,0x20
    81000d12:	9281                	srli	a3,a3,0x20
    81000d14:	0685                	addi	a3,a3,1
    81000d16:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    81000d18:	00054783          	lbu	a5,0(a0)
    81000d1c:	0005c703          	lbu	a4,0(a1)
    81000d20:	00e79863          	bne	a5,a4,81000d30 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    81000d24:	0505                	addi	a0,a0,1
    81000d26:	0585                	addi	a1,a1,1
  while(n-- > 0){
    81000d28:	fed518e3          	bne	a0,a3,81000d18 <memcmp+0x16>
  }

  return 0;
    81000d2c:	4501                	li	a0,0
    81000d2e:	a019                	j	81000d34 <memcmp+0x32>
      return *s1 - *s2;
    81000d30:	40e7853b          	subw	a0,a5,a4
}
    81000d34:	60a2                	ld	ra,8(sp)
    81000d36:	6402                	ld	s0,0(sp)
    81000d38:	0141                	addi	sp,sp,16
    81000d3a:	8082                	ret
  return 0;
    81000d3c:	4501                	li	a0,0
    81000d3e:	bfdd                	j	81000d34 <memcmp+0x32>

0000000081000d40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    81000d40:	1141                	addi	sp,sp,-16
    81000d42:	e406                	sd	ra,8(sp)
    81000d44:	e022                	sd	s0,0(sp)
    81000d46:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    81000d48:	c205                	beqz	a2,81000d68 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    81000d4a:	02a5e363          	bltu	a1,a0,81000d70 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    81000d4e:	1602                	slli	a2,a2,0x20
    81000d50:	9201                	srli	a2,a2,0x20
    81000d52:	00c587b3          	add	a5,a1,a2
{
    81000d56:	872a                	mv	a4,a0
      *d++ = *s++;
    81000d58:	0585                	addi	a1,a1,1
    81000d5a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7efe6001>
    81000d5c:	fff5c683          	lbu	a3,-1(a1)
    81000d60:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    81000d64:	feb79ae3          	bne	a5,a1,81000d58 <memmove+0x18>

  return dst;
}
    81000d68:	60a2                	ld	ra,8(sp)
    81000d6a:	6402                	ld	s0,0(sp)
    81000d6c:	0141                	addi	sp,sp,16
    81000d6e:	8082                	ret
  if(s < d && s + n > d){
    81000d70:	02061693          	slli	a3,a2,0x20
    81000d74:	9281                	srli	a3,a3,0x20
    81000d76:	00d58733          	add	a4,a1,a3
    81000d7a:	fce57ae3          	bgeu	a0,a4,81000d4e <memmove+0xe>
    d += n;
    81000d7e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    81000d80:	fff6079b          	addiw	a5,a2,-1
    81000d84:	1782                	slli	a5,a5,0x20
    81000d86:	9381                	srli	a5,a5,0x20
    81000d88:	fff7c793          	not	a5,a5
    81000d8c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    81000d8e:	177d                	addi	a4,a4,-1
    81000d90:	16fd                	addi	a3,a3,-1
    81000d92:	00074603          	lbu	a2,0(a4)
    81000d96:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    81000d9a:	fee79ae3          	bne	a5,a4,81000d8e <memmove+0x4e>
    81000d9e:	b7e9                	j	81000d68 <memmove+0x28>

0000000081000da0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    81000da0:	1141                	addi	sp,sp,-16
    81000da2:	e406                	sd	ra,8(sp)
    81000da4:	e022                	sd	s0,0(sp)
    81000da6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    81000da8:	f99ff0ef          	jal	81000d40 <memmove>
}
    81000dac:	60a2                	ld	ra,8(sp)
    81000dae:	6402                	ld	s0,0(sp)
    81000db0:	0141                	addi	sp,sp,16
    81000db2:	8082                	ret

0000000081000db4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    81000db4:	1141                	addi	sp,sp,-16
    81000db6:	e406                	sd	ra,8(sp)
    81000db8:	e022                	sd	s0,0(sp)
    81000dba:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    81000dbc:	ce11                	beqz	a2,81000dd8 <strncmp+0x24>
    81000dbe:	00054783          	lbu	a5,0(a0)
    81000dc2:	cf89                	beqz	a5,81000ddc <strncmp+0x28>
    81000dc4:	0005c703          	lbu	a4,0(a1)
    81000dc8:	00f71a63          	bne	a4,a5,81000ddc <strncmp+0x28>
    n--, p++, q++;
    81000dcc:	367d                	addiw	a2,a2,-1
    81000dce:	0505                	addi	a0,a0,1
    81000dd0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    81000dd2:	f675                	bnez	a2,81000dbe <strncmp+0xa>
  if(n == 0)
    return 0;
    81000dd4:	4501                	li	a0,0
    81000dd6:	a801                	j	81000de6 <strncmp+0x32>
    81000dd8:	4501                	li	a0,0
    81000dda:	a031                	j	81000de6 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    81000ddc:	00054503          	lbu	a0,0(a0)
    81000de0:	0005c783          	lbu	a5,0(a1)
    81000de4:	9d1d                	subw	a0,a0,a5
}
    81000de6:	60a2                	ld	ra,8(sp)
    81000de8:	6402                	ld	s0,0(sp)
    81000dea:	0141                	addi	sp,sp,16
    81000dec:	8082                	ret

0000000081000dee <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    81000dee:	1141                	addi	sp,sp,-16
    81000df0:	e406                	sd	ra,8(sp)
    81000df2:	e022                	sd	s0,0(sp)
    81000df4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    81000df6:	87aa                	mv	a5,a0
    81000df8:	86b2                	mv	a3,a2
    81000dfa:	367d                	addiw	a2,a2,-1
    81000dfc:	02d05563          	blez	a3,81000e26 <strncpy+0x38>
    81000e00:	0785                	addi	a5,a5,1
    81000e02:	0005c703          	lbu	a4,0(a1)
    81000e06:	fee78fa3          	sb	a4,-1(a5)
    81000e0a:	0585                	addi	a1,a1,1
    81000e0c:	f775                	bnez	a4,81000df8 <strncpy+0xa>
    ;
  while(n-- > 0)
    81000e0e:	873e                	mv	a4,a5
    81000e10:	00c05b63          	blez	a2,81000e26 <strncpy+0x38>
    81000e14:	9fb5                	addw	a5,a5,a3
    81000e16:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    81000e18:	0705                	addi	a4,a4,1
    81000e1a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    81000e1e:	40e786bb          	subw	a3,a5,a4
    81000e22:	fed04be3          	bgtz	a3,81000e18 <strncpy+0x2a>
  return os;
}
    81000e26:	60a2                	ld	ra,8(sp)
    81000e28:	6402                	ld	s0,0(sp)
    81000e2a:	0141                	addi	sp,sp,16
    81000e2c:	8082                	ret

0000000081000e2e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    81000e2e:	1141                	addi	sp,sp,-16
    81000e30:	e406                	sd	ra,8(sp)
    81000e32:	e022                	sd	s0,0(sp)
    81000e34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    81000e36:	02c05363          	blez	a2,81000e5c <safestrcpy+0x2e>
    81000e3a:	fff6069b          	addiw	a3,a2,-1
    81000e3e:	1682                	slli	a3,a3,0x20
    81000e40:	9281                	srli	a3,a3,0x20
    81000e42:	96ae                	add	a3,a3,a1
    81000e44:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    81000e46:	00d58963          	beq	a1,a3,81000e58 <safestrcpy+0x2a>
    81000e4a:	0585                	addi	a1,a1,1
    81000e4c:	0785                	addi	a5,a5,1
    81000e4e:	fff5c703          	lbu	a4,-1(a1)
    81000e52:	fee78fa3          	sb	a4,-1(a5)
    81000e56:	fb65                	bnez	a4,81000e46 <safestrcpy+0x18>
    ;
  *s = 0;
    81000e58:	00078023          	sb	zero,0(a5)
  return os;
}
    81000e5c:	60a2                	ld	ra,8(sp)
    81000e5e:	6402                	ld	s0,0(sp)
    81000e60:	0141                	addi	sp,sp,16
    81000e62:	8082                	ret

0000000081000e64 <strlen>:

int
strlen(const char *s)
{
    81000e64:	1141                	addi	sp,sp,-16
    81000e66:	e406                	sd	ra,8(sp)
    81000e68:	e022                	sd	s0,0(sp)
    81000e6a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    81000e6c:	00054783          	lbu	a5,0(a0)
    81000e70:	cf99                	beqz	a5,81000e8e <strlen+0x2a>
    81000e72:	0505                	addi	a0,a0,1
    81000e74:	87aa                	mv	a5,a0
    81000e76:	86be                	mv	a3,a5
    81000e78:	0785                	addi	a5,a5,1
    81000e7a:	fff7c703          	lbu	a4,-1(a5)
    81000e7e:	ff65                	bnez	a4,81000e76 <strlen+0x12>
    81000e80:	40a6853b          	subw	a0,a3,a0
    81000e84:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    81000e86:	60a2                	ld	ra,8(sp)
    81000e88:	6402                	ld	s0,0(sp)
    81000e8a:	0141                	addi	sp,sp,16
    81000e8c:	8082                	ret
  for(n = 0; s[n]; n++)
    81000e8e:	4501                	li	a0,0
    81000e90:	bfdd                	j	81000e86 <strlen+0x22>

0000000081000e92 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    81000e92:	1141                	addi	sp,sp,-16
    81000e94:	e406                	sd	ra,8(sp)
    81000e96:	e022                	sd	s0,0(sp)
    81000e98:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    81000e9a:	209000ef          	jal	810018a2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    81000e9e:	00007717          	auipc	a4,0x7
    81000ea2:	a4a70713          	addi	a4,a4,-1462 # 810078e8 <started>
  if(cpuid() == 0){
    81000ea6:	c51d                	beqz	a0,81000ed4 <main+0x42>
    while(started == 0)
    81000ea8:	431c                	lw	a5,0(a4)
    81000eaa:	2781                	sext.w	a5,a5
    81000eac:	dff5                	beqz	a5,81000ea8 <main+0x16>
      ;
    __sync_synchronize();
    81000eae:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    81000eb2:	1f1000ef          	jal	810018a2 <cpuid>
    81000eb6:	85aa                	mv	a1,a0
    81000eb8:	00006517          	auipc	a0,0x6
    81000ebc:	1d850513          	addi	a0,a0,472 # 81007090 <etext+0x90>
    81000ec0:	e18ff0ef          	jal	810004d8 <printf>
    kvminithart();    // turn on paging
    81000ec4:	068000ef          	jal	81000f2c <kvminithart>
    trapinithart();   // install kernel trap vector
    81000ec8:	4f8010ef          	jal	810023c0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    81000ecc:	3bc040ef          	jal	81005288 <plicinithart>
  }

  scheduler();        
    81000ed0:	63b000ef          	jal	81001d0a <scheduler>
    printf("xv6 kernel is booting\n");
    81000ed4:	00006517          	auipc	a0,0x6
    81000ed8:	1a450513          	addi	a0,a0,420 # 81007078 <etext+0x78>
    81000edc:	dfcff0ef          	jal	810004d8 <printf>
    consoleinit();
    81000ee0:	d2aff0ef          	jal	8100040a <consoleinit>
    printfinit();
    81000ee4:	8ffff0ef          	jal	810007e2 <printfinit>
    kinit();         // physical page allocator
    81000ee8:	c1bff0ef          	jal	81000b02 <kinit>
    kvminit();       // create kernel page table
    81000eec:	2d2000ef          	jal	810011be <kvminit>
    kvminithart();   // turn on paging
    81000ef0:	03c000ef          	jal	81000f2c <kvminithart>
    procinit();      // process table
    81000ef4:	0ff000ef          	jal	810017f2 <procinit>
    trapinit();      // trap vectors
    81000ef8:	4a4010ef          	jal	8100239c <trapinit>
    trapinithart();  // install kernel trap vector
    81000efc:	4c4010ef          	jal	810023c0 <trapinithart>
    plicinit();      // set up interrupt controller
    81000f00:	36e040ef          	jal	8100526e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    81000f04:	384040ef          	jal	81005288 <plicinithart>
    binit();         // buffer cache
    81000f08:	2e7010ef          	jal	810029ee <binit>
    iinit();         // inode table
    81000f0c:	0b2020ef          	jal	81002fbe <iinit>
    fileinit();      // file table
    81000f10:	681020ef          	jal	81003d90 <fileinit>
    virtio_disk_init(); // emulated hard disk
    81000f14:	464040ef          	jal	81005378 <virtio_disk_init>
    userinit();      // first user process
    81000f18:	427000ef          	jal	81001b3e <userinit>
    __sync_synchronize();
    81000f1c:	0330000f          	fence	rw,rw
    started = 1;
    81000f20:	4785                	li	a5,1
    81000f22:	00007717          	auipc	a4,0x7
    81000f26:	9cf72323          	sw	a5,-1594(a4) # 810078e8 <started>
    81000f2a:	b75d                	j	81000ed0 <main+0x3e>

0000000081000f2c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    81000f2c:	1141                	addi	sp,sp,-16
    81000f2e:	e406                	sd	ra,8(sp)
    81000f30:	e022                	sd	s0,0(sp)
    81000f32:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    81000f34:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    81000f38:	00007797          	auipc	a5,0x7
    81000f3c:	9b87b783          	ld	a5,-1608(a5) # 810078f0 <kernel_pagetable>
    81000f40:	83b1                	srli	a5,a5,0xc
    81000f42:	577d                	li	a4,-1
    81000f44:	177e                	slli	a4,a4,0x3f
    81000f46:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    81000f48:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    81000f4c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    81000f50:	60a2                	ld	ra,8(sp)
    81000f52:	6402                	ld	s0,0(sp)
    81000f54:	0141                	addi	sp,sp,16
    81000f56:	8082                	ret

0000000081000f58 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    81000f58:	7139                	addi	sp,sp,-64
    81000f5a:	fc06                	sd	ra,56(sp)
    81000f5c:	f822                	sd	s0,48(sp)
    81000f5e:	f426                	sd	s1,40(sp)
    81000f60:	f04a                	sd	s2,32(sp)
    81000f62:	ec4e                	sd	s3,24(sp)
    81000f64:	e852                	sd	s4,16(sp)
    81000f66:	e456                	sd	s5,8(sp)
    81000f68:	e05a                	sd	s6,0(sp)
    81000f6a:	0080                	addi	s0,sp,64
    81000f6c:	84aa                	mv	s1,a0
    81000f6e:	89ae                	mv	s3,a1
    81000f70:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    81000f72:	57fd                	li	a5,-1
    81000f74:	83e9                	srli	a5,a5,0x1a
    81000f76:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    81000f78:	4b31                	li	s6,12
  if(va >= MAXVA)
    81000f7a:	04b7e263          	bltu	a5,a1,81000fbe <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    81000f7e:	0149d933          	srl	s2,s3,s4
    81000f82:	1ff97913          	andi	s2,s2,511
    81000f86:	090e                	slli	s2,s2,0x3
    81000f88:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    81000f8a:	00093483          	ld	s1,0(s2)
    81000f8e:	0014f793          	andi	a5,s1,1
    81000f92:	cf85                	beqz	a5,81000fca <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    81000f94:	80a9                	srli	s1,s1,0xa
    81000f96:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    81000f98:	3a5d                	addiw	s4,s4,-9
    81000f9a:	ff6a12e3          	bne	s4,s6,81000f7e <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    81000f9e:	00c9d513          	srli	a0,s3,0xc
    81000fa2:	1ff57513          	andi	a0,a0,511
    81000fa6:	050e                	slli	a0,a0,0x3
    81000fa8:	9526                	add	a0,a0,s1
}
    81000faa:	70e2                	ld	ra,56(sp)
    81000fac:	7442                	ld	s0,48(sp)
    81000fae:	74a2                	ld	s1,40(sp)
    81000fb0:	7902                	ld	s2,32(sp)
    81000fb2:	69e2                	ld	s3,24(sp)
    81000fb4:	6a42                	ld	s4,16(sp)
    81000fb6:	6aa2                	ld	s5,8(sp)
    81000fb8:	6b02                	ld	s6,0(sp)
    81000fba:	6121                	addi	sp,sp,64
    81000fbc:	8082                	ret
    panic("walk");
    81000fbe:	00006517          	auipc	a0,0x6
    81000fc2:	0ea50513          	addi	a0,a0,234 # 810070a8 <etext+0xa8>
    81000fc6:	fe2ff0ef          	jal	810007a8 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    81000fca:	020a8263          	beqz	s5,81000fee <walk+0x96>
    81000fce:	b6bff0ef          	jal	81000b38 <kalloc>
    81000fd2:	84aa                	mv	s1,a0
    81000fd4:	d979                	beqz	a0,81000faa <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    81000fd6:	6605                	lui	a2,0x1
    81000fd8:	4581                	li	a1,0
    81000fda:	d03ff0ef          	jal	81000cdc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    81000fde:	00c4d793          	srli	a5,s1,0xc
    81000fe2:	07aa                	slli	a5,a5,0xa
    81000fe4:	0017e793          	ori	a5,a5,1
    81000fe8:	00f93023          	sd	a5,0(s2)
    81000fec:	b775                	j	81000f98 <walk+0x40>
        return 0;
    81000fee:	4501                	li	a0,0
    81000ff0:	bf6d                	j	81000faa <walk+0x52>

0000000081000ff2 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    81000ff2:	57fd                	li	a5,-1
    81000ff4:	83e9                	srli	a5,a5,0x1a
    81000ff6:	00b7f463          	bgeu	a5,a1,81000ffe <walkaddr+0xc>
    return 0;
    81000ffa:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    81000ffc:	8082                	ret
{
    81000ffe:	1141                	addi	sp,sp,-16
    81001000:	e406                	sd	ra,8(sp)
    81001002:	e022                	sd	s0,0(sp)
    81001004:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    81001006:	4601                	li	a2,0
    81001008:	f51ff0ef          	jal	81000f58 <walk>
  if(pte == 0)
    8100100c:	c105                	beqz	a0,8100102c <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8100100e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    81001010:	0117f693          	andi	a3,a5,17
    81001014:	4745                	li	a4,17
    return 0;
    81001016:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    81001018:	00e68663          	beq	a3,a4,81001024 <walkaddr+0x32>
}
    8100101c:	60a2                	ld	ra,8(sp)
    8100101e:	6402                	ld	s0,0(sp)
    81001020:	0141                	addi	sp,sp,16
    81001022:	8082                	ret
  pa = PTE2PA(*pte);
    81001024:	83a9                	srli	a5,a5,0xa
    81001026:	00c79513          	slli	a0,a5,0xc
  return pa;
    8100102a:	bfcd                	j	8100101c <walkaddr+0x2a>
    return 0;
    8100102c:	4501                	li	a0,0
    8100102e:	b7fd                	j	8100101c <walkaddr+0x2a>

0000000081001030 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    81001030:	715d                	addi	sp,sp,-80
    81001032:	e486                	sd	ra,72(sp)
    81001034:	e0a2                	sd	s0,64(sp)
    81001036:	fc26                	sd	s1,56(sp)
    81001038:	f84a                	sd	s2,48(sp)
    8100103a:	f44e                	sd	s3,40(sp)
    8100103c:	f052                	sd	s4,32(sp)
    8100103e:	ec56                	sd	s5,24(sp)
    81001040:	e85a                	sd	s6,16(sp)
    81001042:	e45e                	sd	s7,8(sp)
    81001044:	e062                	sd	s8,0(sp)
    81001046:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    81001048:	03459793          	slli	a5,a1,0x34
    8100104c:	e7b1                	bnez	a5,81001098 <mappages+0x68>
    8100104e:	8aaa                	mv	s5,a0
    81001050:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    81001052:	03461793          	slli	a5,a2,0x34
    81001056:	e7b9                	bnez	a5,810010a4 <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    81001058:	ce21                	beqz	a2,810010b0 <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8100105a:	77fd                	lui	a5,0xfffff
    8100105c:	963e                	add	a2,a2,a5
    8100105e:	00b609b3          	add	s3,a2,a1
  a = va;
    81001062:	892e                	mv	s2,a1
    81001064:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    81001068:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8100106a:	6c05                	lui	s8,0x1
    8100106c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    81001070:	865e                	mv	a2,s7
    81001072:	85ca                	mv	a1,s2
    81001074:	8556                	mv	a0,s5
    81001076:	ee3ff0ef          	jal	81000f58 <walk>
    8100107a:	c539                	beqz	a0,810010c8 <mappages+0x98>
    if(*pte & PTE_V)
    8100107c:	611c                	ld	a5,0(a0)
    8100107e:	8b85                	andi	a5,a5,1
    81001080:	ef95                	bnez	a5,810010bc <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    81001082:	80b1                	srli	s1,s1,0xc
    81001084:	04aa                	slli	s1,s1,0xa
    81001086:	0164e4b3          	or	s1,s1,s6
    8100108a:	0014e493          	ori	s1,s1,1
    8100108e:	e104                	sd	s1,0(a0)
    if(a == last)
    81001090:	05390963          	beq	s2,s3,810010e2 <mappages+0xb2>
    a += PGSIZE;
    81001094:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    81001096:	bfd9                	j	8100106c <mappages+0x3c>
    panic("mappages: va not aligned");
    81001098:	00006517          	auipc	a0,0x6
    8100109c:	01850513          	addi	a0,a0,24 # 810070b0 <etext+0xb0>
    810010a0:	f08ff0ef          	jal	810007a8 <panic>
    panic("mappages: size not aligned");
    810010a4:	00006517          	auipc	a0,0x6
    810010a8:	02c50513          	addi	a0,a0,44 # 810070d0 <etext+0xd0>
    810010ac:	efcff0ef          	jal	810007a8 <panic>
    panic("mappages: size");
    810010b0:	00006517          	auipc	a0,0x6
    810010b4:	04050513          	addi	a0,a0,64 # 810070f0 <etext+0xf0>
    810010b8:	ef0ff0ef          	jal	810007a8 <panic>
      panic("mappages: remap");
    810010bc:	00006517          	auipc	a0,0x6
    810010c0:	04450513          	addi	a0,a0,68 # 81007100 <etext+0x100>
    810010c4:	ee4ff0ef          	jal	810007a8 <panic>
      return -1;
    810010c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    810010ca:	60a6                	ld	ra,72(sp)
    810010cc:	6406                	ld	s0,64(sp)
    810010ce:	74e2                	ld	s1,56(sp)
    810010d0:	7942                	ld	s2,48(sp)
    810010d2:	79a2                	ld	s3,40(sp)
    810010d4:	7a02                	ld	s4,32(sp)
    810010d6:	6ae2                	ld	s5,24(sp)
    810010d8:	6b42                	ld	s6,16(sp)
    810010da:	6ba2                	ld	s7,8(sp)
    810010dc:	6c02                	ld	s8,0(sp)
    810010de:	6161                	addi	sp,sp,80
    810010e0:	8082                	ret
  return 0;
    810010e2:	4501                	li	a0,0
    810010e4:	b7dd                	j	810010ca <mappages+0x9a>

00000000810010e6 <kvmmap>:
{
    810010e6:	1141                	addi	sp,sp,-16
    810010e8:	e406                	sd	ra,8(sp)
    810010ea:	e022                	sd	s0,0(sp)
    810010ec:	0800                	addi	s0,sp,16
    810010ee:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    810010f0:	86b2                	mv	a3,a2
    810010f2:	863e                	mv	a2,a5
    810010f4:	f3dff0ef          	jal	81001030 <mappages>
    810010f8:	e509                	bnez	a0,81001102 <kvmmap+0x1c>
}
    810010fa:	60a2                	ld	ra,8(sp)
    810010fc:	6402                	ld	s0,0(sp)
    810010fe:	0141                	addi	sp,sp,16
    81001100:	8082                	ret
    panic("kvmmap");
    81001102:	00006517          	auipc	a0,0x6
    81001106:	00e50513          	addi	a0,a0,14 # 81007110 <etext+0x110>
    8100110a:	e9eff0ef          	jal	810007a8 <panic>

000000008100110e <kvmmake>:
{
    8100110e:	1101                	addi	sp,sp,-32
    81001110:	ec06                	sd	ra,24(sp)
    81001112:	e822                	sd	s0,16(sp)
    81001114:	e426                	sd	s1,8(sp)
    81001116:	e04a                	sd	s2,0(sp)
    81001118:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8100111a:	a1fff0ef          	jal	81000b38 <kalloc>
    8100111e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    81001120:	6605                	lui	a2,0x1
    81001122:	4581                	li	a1,0
    81001124:	bb9ff0ef          	jal	81000cdc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    81001128:	4719                	li	a4,6
    8100112a:	6685                	lui	a3,0x1
    8100112c:	10000637          	lui	a2,0x10000
    81001130:	85b2                	mv	a1,a2
    81001132:	8526                	mv	a0,s1
    81001134:	fb3ff0ef          	jal	810010e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    81001138:	4719                	li	a4,6
    8100113a:	6685                	lui	a3,0x1
    8100113c:	10001637          	lui	a2,0x10001
    81001140:	85b2                	mv	a1,a2
    81001142:	8526                	mv	a0,s1
    81001144:	fa3ff0ef          	jal	810010e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    81001148:	4719                	li	a4,6
    8100114a:	040006b7          	lui	a3,0x4000
    8100114e:	0c000637          	lui	a2,0xc000
    81001152:	85b2                	mv	a1,a2
    81001154:	8526                	mv	a0,s1
    81001156:	f91ff0ef          	jal	810010e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8100115a:	00006917          	auipc	s2,0x6
    8100115e:	ea690913          	addi	s2,s2,-346 # 81007000 <etext>
    81001162:	4729                	li	a4,10
    81001164:	f7f00693          	li	a3,-129
    81001168:	06e2                	slli	a3,a3,0x18
    8100116a:	96ca                	add	a3,a3,s2
    8100116c:	08100613          	li	a2,129
    81001170:	0662                	slli	a2,a2,0x18
    81001172:	85b2                	mv	a1,a2
    81001174:	8526                	mv	a0,s1
    81001176:	f71ff0ef          	jal	810010e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8100117a:	4719                	li	a4,6
    8100117c:	08900693          	li	a3,137
    81001180:	06e2                	slli	a3,a3,0x18
    81001182:	412686b3          	sub	a3,a3,s2
    81001186:	864a                	mv	a2,s2
    81001188:	85ca                	mv	a1,s2
    8100118a:	8526                	mv	a0,s1
    8100118c:	f5bff0ef          	jal	810010e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    81001190:	4729                	li	a4,10
    81001192:	6685                	lui	a3,0x1
    81001194:	00005617          	auipc	a2,0x5
    81001198:	e6c60613          	addi	a2,a2,-404 # 81006000 <_trampoline>
    8100119c:	040005b7          	lui	a1,0x4000
    810011a0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7d000001>
    810011a2:	05b2                	slli	a1,a1,0xc
    810011a4:	8526                	mv	a0,s1
    810011a6:	f41ff0ef          	jal	810010e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    810011aa:	8526                	mv	a0,s1
    810011ac:	5a8000ef          	jal	81001754 <proc_mapstacks>
}
    810011b0:	8526                	mv	a0,s1
    810011b2:	60e2                	ld	ra,24(sp)
    810011b4:	6442                	ld	s0,16(sp)
    810011b6:	64a2                	ld	s1,8(sp)
    810011b8:	6902                	ld	s2,0(sp)
    810011ba:	6105                	addi	sp,sp,32
    810011bc:	8082                	ret

00000000810011be <kvminit>:
{
    810011be:	1141                	addi	sp,sp,-16
    810011c0:	e406                	sd	ra,8(sp)
    810011c2:	e022                	sd	s0,0(sp)
    810011c4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    810011c6:	f49ff0ef          	jal	8100110e <kvmmake>
    810011ca:	00006797          	auipc	a5,0x6
    810011ce:	72a7b323          	sd	a0,1830(a5) # 810078f0 <kernel_pagetable>
}
    810011d2:	60a2                	ld	ra,8(sp)
    810011d4:	6402                	ld	s0,0(sp)
    810011d6:	0141                	addi	sp,sp,16
    810011d8:	8082                	ret

00000000810011da <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    810011da:	715d                	addi	sp,sp,-80
    810011dc:	e486                	sd	ra,72(sp)
    810011de:	e0a2                	sd	s0,64(sp)
    810011e0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    810011e2:	03459793          	slli	a5,a1,0x34
    810011e6:	e39d                	bnez	a5,8100120c <uvmunmap+0x32>
    810011e8:	f84a                	sd	s2,48(sp)
    810011ea:	f44e                	sd	s3,40(sp)
    810011ec:	f052                	sd	s4,32(sp)
    810011ee:	ec56                	sd	s5,24(sp)
    810011f0:	e85a                	sd	s6,16(sp)
    810011f2:	e45e                	sd	s7,8(sp)
    810011f4:	8a2a                	mv	s4,a0
    810011f6:	892e                	mv	s2,a1
    810011f8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    810011fa:	0632                	slli	a2,a2,0xc
    810011fc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    81001200:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    81001202:	6b05                	lui	s6,0x1
    81001204:	0735ff63          	bgeu	a1,s3,81001282 <uvmunmap+0xa8>
    81001208:	fc26                	sd	s1,56(sp)
    8100120a:	a0a9                	j	81001254 <uvmunmap+0x7a>
    8100120c:	fc26                	sd	s1,56(sp)
    8100120e:	f84a                	sd	s2,48(sp)
    81001210:	f44e                	sd	s3,40(sp)
    81001212:	f052                	sd	s4,32(sp)
    81001214:	ec56                	sd	s5,24(sp)
    81001216:	e85a                	sd	s6,16(sp)
    81001218:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8100121a:	00006517          	auipc	a0,0x6
    8100121e:	efe50513          	addi	a0,a0,-258 # 81007118 <etext+0x118>
    81001222:	d86ff0ef          	jal	810007a8 <panic>
      panic("uvmunmap: walk");
    81001226:	00006517          	auipc	a0,0x6
    8100122a:	f0a50513          	addi	a0,a0,-246 # 81007130 <etext+0x130>
    8100122e:	d7aff0ef          	jal	810007a8 <panic>
      panic("uvmunmap: not mapped");
    81001232:	00006517          	auipc	a0,0x6
    81001236:	f0e50513          	addi	a0,a0,-242 # 81007140 <etext+0x140>
    8100123a:	d6eff0ef          	jal	810007a8 <panic>
      panic("uvmunmap: not a leaf");
    8100123e:	00006517          	auipc	a0,0x6
    81001242:	f1a50513          	addi	a0,a0,-230 # 81007158 <etext+0x158>
    81001246:	d62ff0ef          	jal	810007a8 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8100124a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8100124e:	995a                	add	s2,s2,s6
    81001250:	03397863          	bgeu	s2,s3,81001280 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    81001254:	4601                	li	a2,0
    81001256:	85ca                	mv	a1,s2
    81001258:	8552                	mv	a0,s4
    8100125a:	cffff0ef          	jal	81000f58 <walk>
    8100125e:	84aa                	mv	s1,a0
    81001260:	d179                	beqz	a0,81001226 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    81001262:	6108                	ld	a0,0(a0)
    81001264:	00157793          	andi	a5,a0,1
    81001268:	d7e9                	beqz	a5,81001232 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8100126a:	3ff57793          	andi	a5,a0,1023
    8100126e:	fd7788e3          	beq	a5,s7,8100123e <uvmunmap+0x64>
    if(do_free){
    81001272:	fc0a8ce3          	beqz	s5,8100124a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    81001276:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    81001278:	0532                	slli	a0,a0,0xc
    8100127a:	fd8ff0ef          	jal	81000a52 <kfree>
    8100127e:	b7f1                	j	8100124a <uvmunmap+0x70>
    81001280:	74e2                	ld	s1,56(sp)
    81001282:	7942                	ld	s2,48(sp)
    81001284:	79a2                	ld	s3,40(sp)
    81001286:	7a02                	ld	s4,32(sp)
    81001288:	6ae2                	ld	s5,24(sp)
    8100128a:	6b42                	ld	s6,16(sp)
    8100128c:	6ba2                	ld	s7,8(sp)
  }
}
    8100128e:	60a6                	ld	ra,72(sp)
    81001290:	6406                	ld	s0,64(sp)
    81001292:	6161                	addi	sp,sp,80
    81001294:	8082                	ret

0000000081001296 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    81001296:	1101                	addi	sp,sp,-32
    81001298:	ec06                	sd	ra,24(sp)
    8100129a:	e822                	sd	s0,16(sp)
    8100129c:	e426                	sd	s1,8(sp)
    8100129e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    810012a0:	899ff0ef          	jal	81000b38 <kalloc>
    810012a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    810012a6:	c509                	beqz	a0,810012b0 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    810012a8:	6605                	lui	a2,0x1
    810012aa:	4581                	li	a1,0
    810012ac:	a31ff0ef          	jal	81000cdc <memset>
  return pagetable;
}
    810012b0:	8526                	mv	a0,s1
    810012b2:	60e2                	ld	ra,24(sp)
    810012b4:	6442                	ld	s0,16(sp)
    810012b6:	64a2                	ld	s1,8(sp)
    810012b8:	6105                	addi	sp,sp,32
    810012ba:	8082                	ret

00000000810012bc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    810012bc:	7179                	addi	sp,sp,-48
    810012be:	f406                	sd	ra,40(sp)
    810012c0:	f022                	sd	s0,32(sp)
    810012c2:	ec26                	sd	s1,24(sp)
    810012c4:	e84a                	sd	s2,16(sp)
    810012c6:	e44e                	sd	s3,8(sp)
    810012c8:	e052                	sd	s4,0(sp)
    810012ca:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    810012cc:	6785                	lui	a5,0x1
    810012ce:	04f67063          	bgeu	a2,a5,8100130e <uvmfirst+0x52>
    810012d2:	8a2a                	mv	s4,a0
    810012d4:	89ae                	mv	s3,a1
    810012d6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    810012d8:	861ff0ef          	jal	81000b38 <kalloc>
    810012dc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    810012de:	6605                	lui	a2,0x1
    810012e0:	4581                	li	a1,0
    810012e2:	9fbff0ef          	jal	81000cdc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    810012e6:	4779                	li	a4,30
    810012e8:	86ca                	mv	a3,s2
    810012ea:	6605                	lui	a2,0x1
    810012ec:	4581                	li	a1,0
    810012ee:	8552                	mv	a0,s4
    810012f0:	d41ff0ef          	jal	81001030 <mappages>
  memmove(mem, src, sz);
    810012f4:	8626                	mv	a2,s1
    810012f6:	85ce                	mv	a1,s3
    810012f8:	854a                	mv	a0,s2
    810012fa:	a47ff0ef          	jal	81000d40 <memmove>
}
    810012fe:	70a2                	ld	ra,40(sp)
    81001300:	7402                	ld	s0,32(sp)
    81001302:	64e2                	ld	s1,24(sp)
    81001304:	6942                	ld	s2,16(sp)
    81001306:	69a2                	ld	s3,8(sp)
    81001308:	6a02                	ld	s4,0(sp)
    8100130a:	6145                	addi	sp,sp,48
    8100130c:	8082                	ret
    panic("uvmfirst: more than a page");
    8100130e:	00006517          	auipc	a0,0x6
    81001312:	e6250513          	addi	a0,a0,-414 # 81007170 <etext+0x170>
    81001316:	c92ff0ef          	jal	810007a8 <panic>

000000008100131a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8100131a:	1101                	addi	sp,sp,-32
    8100131c:	ec06                	sd	ra,24(sp)
    8100131e:	e822                	sd	s0,16(sp)
    81001320:	e426                	sd	s1,8(sp)
    81001322:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    81001324:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    81001326:	00b67d63          	bgeu	a2,a1,81001340 <uvmdealloc+0x26>
    8100132a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8100132c:	6785                	lui	a5,0x1
    8100132e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x80fff001>
    81001330:	00f60733          	add	a4,a2,a5
    81001334:	76fd                	lui	a3,0xfffff
    81001336:	8f75                	and	a4,a4,a3
    81001338:	97ae                	add	a5,a5,a1
    8100133a:	8ff5                	and	a5,a5,a3
    8100133c:	00f76863          	bltu	a4,a5,8100134c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    81001340:	8526                	mv	a0,s1
    81001342:	60e2                	ld	ra,24(sp)
    81001344:	6442                	ld	s0,16(sp)
    81001346:	64a2                	ld	s1,8(sp)
    81001348:	6105                	addi	sp,sp,32
    8100134a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8100134c:	8f99                	sub	a5,a5,a4
    8100134e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    81001350:	4685                	li	a3,1
    81001352:	0007861b          	sext.w	a2,a5
    81001356:	85ba                	mv	a1,a4
    81001358:	e83ff0ef          	jal	810011da <uvmunmap>
    8100135c:	b7d5                	j	81001340 <uvmdealloc+0x26>

000000008100135e <uvmalloc>:
  if(newsz < oldsz)
    8100135e:	0ab66363          	bltu	a2,a1,81001404 <uvmalloc+0xa6>
{
    81001362:	715d                	addi	sp,sp,-80
    81001364:	e486                	sd	ra,72(sp)
    81001366:	e0a2                	sd	s0,64(sp)
    81001368:	f052                	sd	s4,32(sp)
    8100136a:	ec56                	sd	s5,24(sp)
    8100136c:	e85a                	sd	s6,16(sp)
    8100136e:	0880                	addi	s0,sp,80
    81001370:	8b2a                	mv	s6,a0
    81001372:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    81001374:	6785                	lui	a5,0x1
    81001376:	17fd                	addi	a5,a5,-1 # fff <_entry-0x80fff001>
    81001378:	95be                	add	a1,a1,a5
    8100137a:	77fd                	lui	a5,0xfffff
    8100137c:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    81001380:	08ca7463          	bgeu	s4,a2,81001408 <uvmalloc+0xaa>
    81001384:	fc26                	sd	s1,56(sp)
    81001386:	f84a                	sd	s2,48(sp)
    81001388:	f44e                	sd	s3,40(sp)
    8100138a:	e45e                	sd	s7,8(sp)
    8100138c:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    8100138e:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    81001390:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    81001394:	fa4ff0ef          	jal	81000b38 <kalloc>
    81001398:	84aa                	mv	s1,a0
    if(mem == 0){
    8100139a:	c515                	beqz	a0,810013c6 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    8100139c:	864e                	mv	a2,s3
    8100139e:	4581                	li	a1,0
    810013a0:	93dff0ef          	jal	81000cdc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    810013a4:	875e                	mv	a4,s7
    810013a6:	86a6                	mv	a3,s1
    810013a8:	864e                	mv	a2,s3
    810013aa:	85ca                	mv	a1,s2
    810013ac:	855a                	mv	a0,s6
    810013ae:	c83ff0ef          	jal	81001030 <mappages>
    810013b2:	e91d                	bnez	a0,810013e8 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    810013b4:	994e                	add	s2,s2,s3
    810013b6:	fd596fe3          	bltu	s2,s5,81001394 <uvmalloc+0x36>
  return newsz;
    810013ba:	8556                	mv	a0,s5
    810013bc:	74e2                	ld	s1,56(sp)
    810013be:	7942                	ld	s2,48(sp)
    810013c0:	79a2                	ld	s3,40(sp)
    810013c2:	6ba2                	ld	s7,8(sp)
    810013c4:	a819                	j	810013da <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    810013c6:	8652                	mv	a2,s4
    810013c8:	85ca                	mv	a1,s2
    810013ca:	855a                	mv	a0,s6
    810013cc:	f4fff0ef          	jal	8100131a <uvmdealloc>
      return 0;
    810013d0:	4501                	li	a0,0
    810013d2:	74e2                	ld	s1,56(sp)
    810013d4:	7942                	ld	s2,48(sp)
    810013d6:	79a2                	ld	s3,40(sp)
    810013d8:	6ba2                	ld	s7,8(sp)
}
    810013da:	60a6                	ld	ra,72(sp)
    810013dc:	6406                	ld	s0,64(sp)
    810013de:	7a02                	ld	s4,32(sp)
    810013e0:	6ae2                	ld	s5,24(sp)
    810013e2:	6b42                	ld	s6,16(sp)
    810013e4:	6161                	addi	sp,sp,80
    810013e6:	8082                	ret
      kfree(mem);
    810013e8:	8526                	mv	a0,s1
    810013ea:	e68ff0ef          	jal	81000a52 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    810013ee:	8652                	mv	a2,s4
    810013f0:	85ca                	mv	a1,s2
    810013f2:	855a                	mv	a0,s6
    810013f4:	f27ff0ef          	jal	8100131a <uvmdealloc>
      return 0;
    810013f8:	4501                	li	a0,0
    810013fa:	74e2                	ld	s1,56(sp)
    810013fc:	7942                	ld	s2,48(sp)
    810013fe:	79a2                	ld	s3,40(sp)
    81001400:	6ba2                	ld	s7,8(sp)
    81001402:	bfe1                	j	810013da <uvmalloc+0x7c>
    return oldsz;
    81001404:	852e                	mv	a0,a1
}
    81001406:	8082                	ret
  return newsz;
    81001408:	8532                	mv	a0,a2
    8100140a:	bfc1                	j	810013da <uvmalloc+0x7c>

000000008100140c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8100140c:	7179                	addi	sp,sp,-48
    8100140e:	f406                	sd	ra,40(sp)
    81001410:	f022                	sd	s0,32(sp)
    81001412:	ec26                	sd	s1,24(sp)
    81001414:	e84a                	sd	s2,16(sp)
    81001416:	e44e                	sd	s3,8(sp)
    81001418:	e052                	sd	s4,0(sp)
    8100141a:	1800                	addi	s0,sp,48
    8100141c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8100141e:	84aa                	mv	s1,a0
    81001420:	6905                	lui	s2,0x1
    81001422:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    81001424:	4985                	li	s3,1
    81001426:	a819                	j	8100143c <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    81001428:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8100142a:	00c79513          	slli	a0,a5,0xc
    8100142e:	fdfff0ef          	jal	8100140c <freewalk>
      pagetable[i] = 0;
    81001432:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    81001436:	04a1                	addi	s1,s1,8
    81001438:	01248f63          	beq	s1,s2,81001456 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8100143c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8100143e:	00f7f713          	andi	a4,a5,15
    81001442:	ff3703e3          	beq	a4,s3,81001428 <freewalk+0x1c>
    } else if(pte & PTE_V){
    81001446:	8b85                	andi	a5,a5,1
    81001448:	d7fd                	beqz	a5,81001436 <freewalk+0x2a>
      panic("freewalk: leaf");
    8100144a:	00006517          	auipc	a0,0x6
    8100144e:	d4650513          	addi	a0,a0,-698 # 81007190 <etext+0x190>
    81001452:	b56ff0ef          	jal	810007a8 <panic>
    }
  }
  kfree((void*)pagetable);
    81001456:	8552                	mv	a0,s4
    81001458:	dfaff0ef          	jal	81000a52 <kfree>
}
    8100145c:	70a2                	ld	ra,40(sp)
    8100145e:	7402                	ld	s0,32(sp)
    81001460:	64e2                	ld	s1,24(sp)
    81001462:	6942                	ld	s2,16(sp)
    81001464:	69a2                	ld	s3,8(sp)
    81001466:	6a02                	ld	s4,0(sp)
    81001468:	6145                	addi	sp,sp,48
    8100146a:	8082                	ret

000000008100146c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8100146c:	1101                	addi	sp,sp,-32
    8100146e:	ec06                	sd	ra,24(sp)
    81001470:	e822                	sd	s0,16(sp)
    81001472:	e426                	sd	s1,8(sp)
    81001474:	1000                	addi	s0,sp,32
    81001476:	84aa                	mv	s1,a0
  if(sz > 0)
    81001478:	e989                	bnez	a1,8100148a <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8100147a:	8526                	mv	a0,s1
    8100147c:	f91ff0ef          	jal	8100140c <freewalk>
}
    81001480:	60e2                	ld	ra,24(sp)
    81001482:	6442                	ld	s0,16(sp)
    81001484:	64a2                	ld	s1,8(sp)
    81001486:	6105                	addi	sp,sp,32
    81001488:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8100148a:	6785                	lui	a5,0x1
    8100148c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x80fff001>
    8100148e:	95be                	add	a1,a1,a5
    81001490:	4685                	li	a3,1
    81001492:	00c5d613          	srli	a2,a1,0xc
    81001496:	4581                	li	a1,0
    81001498:	d43ff0ef          	jal	810011da <uvmunmap>
    8100149c:	bff9                	j	8100147a <uvmfree+0xe>

000000008100149e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8100149e:	ca4d                	beqz	a2,81001550 <uvmcopy+0xb2>
{
    810014a0:	715d                	addi	sp,sp,-80
    810014a2:	e486                	sd	ra,72(sp)
    810014a4:	e0a2                	sd	s0,64(sp)
    810014a6:	fc26                	sd	s1,56(sp)
    810014a8:	f84a                	sd	s2,48(sp)
    810014aa:	f44e                	sd	s3,40(sp)
    810014ac:	f052                	sd	s4,32(sp)
    810014ae:	ec56                	sd	s5,24(sp)
    810014b0:	e85a                	sd	s6,16(sp)
    810014b2:	e45e                	sd	s7,8(sp)
    810014b4:	e062                	sd	s8,0(sp)
    810014b6:	0880                	addi	s0,sp,80
    810014b8:	8baa                	mv	s7,a0
    810014ba:	8b2e                	mv	s6,a1
    810014bc:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    810014be:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    810014c0:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    810014c2:	4601                	li	a2,0
    810014c4:	85ce                	mv	a1,s3
    810014c6:	855e                	mv	a0,s7
    810014c8:	a91ff0ef          	jal	81000f58 <walk>
    810014cc:	cd1d                	beqz	a0,8100150a <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    810014ce:	6118                	ld	a4,0(a0)
    810014d0:	00177793          	andi	a5,a4,1
    810014d4:	c3a9                	beqz	a5,81001516 <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    810014d6:	00a75593          	srli	a1,a4,0xa
    810014da:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    810014de:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    810014e2:	e56ff0ef          	jal	81000b38 <kalloc>
    810014e6:	892a                	mv	s2,a0
    810014e8:	c121                	beqz	a0,81001528 <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    810014ea:	8652                	mv	a2,s4
    810014ec:	85e2                	mv	a1,s8
    810014ee:	853ff0ef          	jal	81000d40 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    810014f2:	8726                	mv	a4,s1
    810014f4:	86ca                	mv	a3,s2
    810014f6:	8652                	mv	a2,s4
    810014f8:	85ce                	mv	a1,s3
    810014fa:	855a                	mv	a0,s6
    810014fc:	b35ff0ef          	jal	81001030 <mappages>
    81001500:	e10d                	bnez	a0,81001522 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    81001502:	99d2                	add	s3,s3,s4
    81001504:	fb59efe3          	bltu	s3,s5,810014c2 <uvmcopy+0x24>
    81001508:	a805                	j	81001538 <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    8100150a:	00006517          	auipc	a0,0x6
    8100150e:	c9650513          	addi	a0,a0,-874 # 810071a0 <etext+0x1a0>
    81001512:	a96ff0ef          	jal	810007a8 <panic>
      panic("uvmcopy: page not present");
    81001516:	00006517          	auipc	a0,0x6
    8100151a:	caa50513          	addi	a0,a0,-854 # 810071c0 <etext+0x1c0>
    8100151e:	a8aff0ef          	jal	810007a8 <panic>
      kfree(mem);
    81001522:	854a                	mv	a0,s2
    81001524:	d2eff0ef          	jal	81000a52 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    81001528:	4685                	li	a3,1
    8100152a:	00c9d613          	srli	a2,s3,0xc
    8100152e:	4581                	li	a1,0
    81001530:	855a                	mv	a0,s6
    81001532:	ca9ff0ef          	jal	810011da <uvmunmap>
  return -1;
    81001536:	557d                	li	a0,-1
}
    81001538:	60a6                	ld	ra,72(sp)
    8100153a:	6406                	ld	s0,64(sp)
    8100153c:	74e2                	ld	s1,56(sp)
    8100153e:	7942                	ld	s2,48(sp)
    81001540:	79a2                	ld	s3,40(sp)
    81001542:	7a02                	ld	s4,32(sp)
    81001544:	6ae2                	ld	s5,24(sp)
    81001546:	6b42                	ld	s6,16(sp)
    81001548:	6ba2                	ld	s7,8(sp)
    8100154a:	6c02                	ld	s8,0(sp)
    8100154c:	6161                	addi	sp,sp,80
    8100154e:	8082                	ret
  return 0;
    81001550:	4501                	li	a0,0
}
    81001552:	8082                	ret

0000000081001554 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    81001554:	1141                	addi	sp,sp,-16
    81001556:	e406                	sd	ra,8(sp)
    81001558:	e022                	sd	s0,0(sp)
    8100155a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8100155c:	4601                	li	a2,0
    8100155e:	9fbff0ef          	jal	81000f58 <walk>
  if(pte == 0)
    81001562:	c901                	beqz	a0,81001572 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    81001564:	611c                	ld	a5,0(a0)
    81001566:	9bbd                	andi	a5,a5,-17
    81001568:	e11c                	sd	a5,0(a0)
}
    8100156a:	60a2                	ld	ra,8(sp)
    8100156c:	6402                	ld	s0,0(sp)
    8100156e:	0141                	addi	sp,sp,16
    81001570:	8082                	ret
    panic("uvmclear");
    81001572:	00006517          	auipc	a0,0x6
    81001576:	c6e50513          	addi	a0,a0,-914 # 810071e0 <etext+0x1e0>
    8100157a:	a2eff0ef          	jal	810007a8 <panic>

000000008100157e <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    8100157e:	c2d9                	beqz	a3,81001604 <copyout+0x86>
{
    81001580:	711d                	addi	sp,sp,-96
    81001582:	ec86                	sd	ra,88(sp)
    81001584:	e8a2                	sd	s0,80(sp)
    81001586:	e4a6                	sd	s1,72(sp)
    81001588:	e0ca                	sd	s2,64(sp)
    8100158a:	fc4e                	sd	s3,56(sp)
    8100158c:	f852                	sd	s4,48(sp)
    8100158e:	f456                	sd	s5,40(sp)
    81001590:	f05a                	sd	s6,32(sp)
    81001592:	ec5e                	sd	s7,24(sp)
    81001594:	e862                	sd	s8,16(sp)
    81001596:	e466                	sd	s9,8(sp)
    81001598:	e06a                	sd	s10,0(sp)
    8100159a:	1080                	addi	s0,sp,96
    8100159c:	8c2a                	mv	s8,a0
    8100159e:	892e                	mv	s2,a1
    810015a0:	8ab2                	mv	s5,a2
    810015a2:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    810015a4:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    810015a6:	5bfd                	li	s7,-1
    810015a8:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    810015ac:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    810015ae:	6b05                	lui	s6,0x1
    810015b0:	a015                	j	810015d4 <copyout+0x56>
    pa0 = PTE2PA(*pte);
    810015b2:	83a9                	srli	a5,a5,0xa
    810015b4:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    810015b6:	41390533          	sub	a0,s2,s3
    810015ba:	0004861b          	sext.w	a2,s1
    810015be:	85d6                	mv	a1,s5
    810015c0:	953e                	add	a0,a0,a5
    810015c2:	f7eff0ef          	jal	81000d40 <memmove>

    len -= n;
    810015c6:	409a0a33          	sub	s4,s4,s1
    src += n;
    810015ca:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    810015cc:	01698933          	add	s2,s3,s6
  while(len > 0){
    810015d0:	020a0863          	beqz	s4,81001600 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    810015d4:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    810015d8:	033be863          	bltu	s7,s3,81001608 <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    810015dc:	4601                	li	a2,0
    810015de:	85ce                	mv	a1,s3
    810015e0:	8562                	mv	a0,s8
    810015e2:	977ff0ef          	jal	81000f58 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    810015e6:	c121                	beqz	a0,81001626 <copyout+0xa8>
    810015e8:	611c                	ld	a5,0(a0)
    810015ea:	0157f713          	andi	a4,a5,21
    810015ee:	03a71e63          	bne	a4,s10,8100162a <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    810015f2:	412984b3          	sub	s1,s3,s2
    810015f6:	94da                	add	s1,s1,s6
    if(n > len)
    810015f8:	fa9a7de3          	bgeu	s4,s1,810015b2 <copyout+0x34>
    810015fc:	84d2                	mv	s1,s4
    810015fe:	bf55                	j	810015b2 <copyout+0x34>
  }
  return 0;
    81001600:	4501                	li	a0,0
    81001602:	a021                	j	8100160a <copyout+0x8c>
    81001604:	4501                	li	a0,0
}
    81001606:	8082                	ret
      return -1;
    81001608:	557d                	li	a0,-1
}
    8100160a:	60e6                	ld	ra,88(sp)
    8100160c:	6446                	ld	s0,80(sp)
    8100160e:	64a6                	ld	s1,72(sp)
    81001610:	6906                	ld	s2,64(sp)
    81001612:	79e2                	ld	s3,56(sp)
    81001614:	7a42                	ld	s4,48(sp)
    81001616:	7aa2                	ld	s5,40(sp)
    81001618:	7b02                	ld	s6,32(sp)
    8100161a:	6be2                	ld	s7,24(sp)
    8100161c:	6c42                	ld	s8,16(sp)
    8100161e:	6ca2                	ld	s9,8(sp)
    81001620:	6d02                	ld	s10,0(sp)
    81001622:	6125                	addi	sp,sp,96
    81001624:	8082                	ret
      return -1;
    81001626:	557d                	li	a0,-1
    81001628:	b7cd                	j	8100160a <copyout+0x8c>
    8100162a:	557d                	li	a0,-1
    8100162c:	bff9                	j	8100160a <copyout+0x8c>

000000008100162e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8100162e:	c6a5                	beqz	a3,81001696 <copyin+0x68>
{
    81001630:	715d                	addi	sp,sp,-80
    81001632:	e486                	sd	ra,72(sp)
    81001634:	e0a2                	sd	s0,64(sp)
    81001636:	fc26                	sd	s1,56(sp)
    81001638:	f84a                	sd	s2,48(sp)
    8100163a:	f44e                	sd	s3,40(sp)
    8100163c:	f052                	sd	s4,32(sp)
    8100163e:	ec56                	sd	s5,24(sp)
    81001640:	e85a                	sd	s6,16(sp)
    81001642:	e45e                	sd	s7,8(sp)
    81001644:	e062                	sd	s8,0(sp)
    81001646:	0880                	addi	s0,sp,80
    81001648:	8b2a                	mv	s6,a0
    8100164a:	8a2e                	mv	s4,a1
    8100164c:	8c32                	mv	s8,a2
    8100164e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    81001650:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    81001652:	6a85                	lui	s5,0x1
    81001654:	a00d                	j	81001676 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    81001656:	018505b3          	add	a1,a0,s8
    8100165a:	0004861b          	sext.w	a2,s1
    8100165e:	412585b3          	sub	a1,a1,s2
    81001662:	8552                	mv	a0,s4
    81001664:	edcff0ef          	jal	81000d40 <memmove>

    len -= n;
    81001668:	409989b3          	sub	s3,s3,s1
    dst += n;
    8100166c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8100166e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    81001672:	02098063          	beqz	s3,81001692 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    81001676:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8100167a:	85ca                	mv	a1,s2
    8100167c:	855a                	mv	a0,s6
    8100167e:	975ff0ef          	jal	81000ff2 <walkaddr>
    if(pa0 == 0)
    81001682:	cd01                	beqz	a0,8100169a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    81001684:	418904b3          	sub	s1,s2,s8
    81001688:	94d6                	add	s1,s1,s5
    if(n > len)
    8100168a:	fc99f6e3          	bgeu	s3,s1,81001656 <copyin+0x28>
    8100168e:	84ce                	mv	s1,s3
    81001690:	b7d9                	j	81001656 <copyin+0x28>
  }
  return 0;
    81001692:	4501                	li	a0,0
    81001694:	a021                	j	8100169c <copyin+0x6e>
    81001696:	4501                	li	a0,0
}
    81001698:	8082                	ret
      return -1;
    8100169a:	557d                	li	a0,-1
}
    8100169c:	60a6                	ld	ra,72(sp)
    8100169e:	6406                	ld	s0,64(sp)
    810016a0:	74e2                	ld	s1,56(sp)
    810016a2:	7942                	ld	s2,48(sp)
    810016a4:	79a2                	ld	s3,40(sp)
    810016a6:	7a02                	ld	s4,32(sp)
    810016a8:	6ae2                	ld	s5,24(sp)
    810016aa:	6b42                	ld	s6,16(sp)
    810016ac:	6ba2                	ld	s7,8(sp)
    810016ae:	6c02                	ld	s8,0(sp)
    810016b0:	6161                	addi	sp,sp,80
    810016b2:	8082                	ret

00000000810016b4 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    810016b4:	715d                	addi	sp,sp,-80
    810016b6:	e486                	sd	ra,72(sp)
    810016b8:	e0a2                	sd	s0,64(sp)
    810016ba:	fc26                	sd	s1,56(sp)
    810016bc:	f84a                	sd	s2,48(sp)
    810016be:	f44e                	sd	s3,40(sp)
    810016c0:	f052                	sd	s4,32(sp)
    810016c2:	ec56                	sd	s5,24(sp)
    810016c4:	e85a                	sd	s6,16(sp)
    810016c6:	e45e                	sd	s7,8(sp)
    810016c8:	0880                	addi	s0,sp,80
    810016ca:	8aaa                	mv	s5,a0
    810016cc:	89ae                	mv	s3,a1
    810016ce:	8bb2                	mv	s7,a2
    810016d0:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    810016d2:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    810016d4:	6a05                	lui	s4,0x1
    810016d6:	a02d                	j	81001700 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    810016d8:	00078023          	sb	zero,0(a5)
    810016dc:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    810016de:	0017c793          	xori	a5,a5,1
    810016e2:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    810016e6:	60a6                	ld	ra,72(sp)
    810016e8:	6406                	ld	s0,64(sp)
    810016ea:	74e2                	ld	s1,56(sp)
    810016ec:	7942                	ld	s2,48(sp)
    810016ee:	79a2                	ld	s3,40(sp)
    810016f0:	7a02                	ld	s4,32(sp)
    810016f2:	6ae2                	ld	s5,24(sp)
    810016f4:	6b42                	ld	s6,16(sp)
    810016f6:	6ba2                	ld	s7,8(sp)
    810016f8:	6161                	addi	sp,sp,80
    810016fa:	8082                	ret
    srcva = va0 + PGSIZE;
    810016fc:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    81001700:	c4b1                	beqz	s1,8100174c <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    81001702:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    81001706:	85ca                	mv	a1,s2
    81001708:	8556                	mv	a0,s5
    8100170a:	8e9ff0ef          	jal	81000ff2 <walkaddr>
    if(pa0 == 0)
    8100170e:	c129                	beqz	a0,81001750 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    81001710:	41790633          	sub	a2,s2,s7
    81001714:	9652                	add	a2,a2,s4
    if(n > max)
    81001716:	00c4f363          	bgeu	s1,a2,8100171c <copyinstr+0x68>
    8100171a:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8100171c:	412b8bb3          	sub	s7,s7,s2
    81001720:	9baa                	add	s7,s7,a0
    while(n > 0){
    81001722:	de69                	beqz	a2,810016fc <copyinstr+0x48>
    81001724:	87ce                	mv	a5,s3
      if(*p == '\0'){
    81001726:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    8100172a:	964e                	add	a2,a2,s3
    8100172c:	85be                	mv	a1,a5
      if(*p == '\0'){
    8100172e:	00f68733          	add	a4,a3,a5
    81001732:	00074703          	lbu	a4,0(a4)
    81001736:	d34d                	beqz	a4,810016d8 <copyinstr+0x24>
        *dst = *p;
    81001738:	00e78023          	sb	a4,0(a5)
      dst++;
    8100173c:	0785                	addi	a5,a5,1
    while(n > 0){
    8100173e:	fec797e3          	bne	a5,a2,8100172c <copyinstr+0x78>
    81001742:	14fd                	addi	s1,s1,-1
    81001744:	94ce                	add	s1,s1,s3
      --max;
    81001746:	8c8d                	sub	s1,s1,a1
    81001748:	89be                	mv	s3,a5
    8100174a:	bf4d                	j	810016fc <copyinstr+0x48>
    8100174c:	4781                	li	a5,0
    8100174e:	bf41                	j	810016de <copyinstr+0x2a>
      return -1;
    81001750:	557d                	li	a0,-1
    81001752:	bf51                	j	810016e6 <copyinstr+0x32>

0000000081001754 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    81001754:	715d                	addi	sp,sp,-80
    81001756:	e486                	sd	ra,72(sp)
    81001758:	e0a2                	sd	s0,64(sp)
    8100175a:	fc26                	sd	s1,56(sp)
    8100175c:	f84a                	sd	s2,48(sp)
    8100175e:	f44e                	sd	s3,40(sp)
    81001760:	f052                	sd	s4,32(sp)
    81001762:	ec56                	sd	s5,24(sp)
    81001764:	e85a                	sd	s6,16(sp)
    81001766:	e45e                	sd	s7,8(sp)
    81001768:	e062                	sd	s8,0(sp)
    8100176a:	0880                	addi	s0,sp,80
    8100176c:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8100176e:	00006497          	auipc	s1,0x6
    81001772:	6f248493          	addi	s1,s1,1778 # 81007e60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    81001776:	8c26                	mv	s8,s1
    81001778:	a4fa57b7          	lui	a5,0xa4fa5
    8100177c:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff23f8bfa5>
    81001780:	4fa50937          	lui	s2,0x4fa50
    81001784:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x315b05b0>
    81001788:	1902                	slli	s2,s2,0x20
    8100178a:	993e                	add	s2,s2,a5
    8100178c:	040009b7          	lui	s3,0x4000
    81001790:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7d000001>
    81001792:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    81001794:	4b99                	li	s7,6
    81001796:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    81001798:	0000ca97          	auipc	s5,0xc
    8100179c:	0c8a8a93          	addi	s5,s5,200 # 8100d860 <tickslock>
    char *pa = kalloc();
    810017a0:	b98ff0ef          	jal	81000b38 <kalloc>
    810017a4:	862a                	mv	a2,a0
    if(pa == 0)
    810017a6:	c121                	beqz	a0,810017e6 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    810017a8:	418485b3          	sub	a1,s1,s8
    810017ac:	858d                	srai	a1,a1,0x3
    810017ae:	032585b3          	mul	a1,a1,s2
    810017b2:	2585                	addiw	a1,a1,1
    810017b4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    810017b8:	875e                	mv	a4,s7
    810017ba:	86da                	mv	a3,s6
    810017bc:	40b985b3          	sub	a1,s3,a1
    810017c0:	8552                	mv	a0,s4
    810017c2:	925ff0ef          	jal	810010e6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    810017c6:	16848493          	addi	s1,s1,360
    810017ca:	fd549be3          	bne	s1,s5,810017a0 <proc_mapstacks+0x4c>
  }
}
    810017ce:	60a6                	ld	ra,72(sp)
    810017d0:	6406                	ld	s0,64(sp)
    810017d2:	74e2                	ld	s1,56(sp)
    810017d4:	7942                	ld	s2,48(sp)
    810017d6:	79a2                	ld	s3,40(sp)
    810017d8:	7a02                	ld	s4,32(sp)
    810017da:	6ae2                	ld	s5,24(sp)
    810017dc:	6b42                	ld	s6,16(sp)
    810017de:	6ba2                	ld	s7,8(sp)
    810017e0:	6c02                	ld	s8,0(sp)
    810017e2:	6161                	addi	sp,sp,80
    810017e4:	8082                	ret
      panic("kalloc");
    810017e6:	00006517          	auipc	a0,0x6
    810017ea:	a0a50513          	addi	a0,a0,-1526 # 810071f0 <etext+0x1f0>
    810017ee:	fbbfe0ef          	jal	810007a8 <panic>

00000000810017f2 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    810017f2:	7139                	addi	sp,sp,-64
    810017f4:	fc06                	sd	ra,56(sp)
    810017f6:	f822                	sd	s0,48(sp)
    810017f8:	f426                	sd	s1,40(sp)
    810017fa:	f04a                	sd	s2,32(sp)
    810017fc:	ec4e                	sd	s3,24(sp)
    810017fe:	e852                	sd	s4,16(sp)
    81001800:	e456                	sd	s5,8(sp)
    81001802:	e05a                	sd	s6,0(sp)
    81001804:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    81001806:	00006597          	auipc	a1,0x6
    8100180a:	9f258593          	addi	a1,a1,-1550 # 810071f8 <etext+0x1f8>
    8100180e:	00006517          	auipc	a0,0x6
    81001812:	22250513          	addi	a0,a0,546 # 81007a30 <pid_lock>
    81001816:	b72ff0ef          	jal	81000b88 <initlock>
  initlock(&wait_lock, "wait_lock");
    8100181a:	00006597          	auipc	a1,0x6
    8100181e:	9e658593          	addi	a1,a1,-1562 # 81007200 <etext+0x200>
    81001822:	00006517          	auipc	a0,0x6
    81001826:	22650513          	addi	a0,a0,550 # 81007a48 <wait_lock>
    8100182a:	b5eff0ef          	jal	81000b88 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8100182e:	00006497          	auipc	s1,0x6
    81001832:	63248493          	addi	s1,s1,1586 # 81007e60 <proc>
      initlock(&p->lock, "proc");
    81001836:	00006b17          	auipc	s6,0x6
    8100183a:	9dab0b13          	addi	s6,s6,-1574 # 81007210 <etext+0x210>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8100183e:	8aa6                	mv	s5,s1
    81001840:	a4fa57b7          	lui	a5,0xa4fa5
    81001844:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff23f8bfa5>
    81001848:	4fa50937          	lui	s2,0x4fa50
    8100184c:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x315b05b0>
    81001850:	1902                	slli	s2,s2,0x20
    81001852:	993e                	add	s2,s2,a5
    81001854:	040009b7          	lui	s3,0x4000
    81001858:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7d000001>
    8100185a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8100185c:	0000ca17          	auipc	s4,0xc
    81001860:	004a0a13          	addi	s4,s4,4 # 8100d860 <tickslock>
      initlock(&p->lock, "proc");
    81001864:	85da                	mv	a1,s6
    81001866:	8526                	mv	a0,s1
    81001868:	b20ff0ef          	jal	81000b88 <initlock>
      p->state = UNUSED;
    8100186c:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    81001870:	415487b3          	sub	a5,s1,s5
    81001874:	878d                	srai	a5,a5,0x3
    81001876:	032787b3          	mul	a5,a5,s2
    8100187a:	2785                	addiw	a5,a5,1
    8100187c:	00d7979b          	slliw	a5,a5,0xd
    81001880:	40f987b3          	sub	a5,s3,a5
    81001884:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    81001886:	16848493          	addi	s1,s1,360
    8100188a:	fd449de3          	bne	s1,s4,81001864 <procinit+0x72>
  }
}
    8100188e:	70e2                	ld	ra,56(sp)
    81001890:	7442                	ld	s0,48(sp)
    81001892:	74a2                	ld	s1,40(sp)
    81001894:	7902                	ld	s2,32(sp)
    81001896:	69e2                	ld	s3,24(sp)
    81001898:	6a42                	ld	s4,16(sp)
    8100189a:	6aa2                	ld	s5,8(sp)
    8100189c:	6b02                	ld	s6,0(sp)
    8100189e:	6121                	addi	sp,sp,64
    810018a0:	8082                	ret

00000000810018a2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    810018a2:	1141                	addi	sp,sp,-16
    810018a4:	e406                	sd	ra,8(sp)
    810018a6:	e022                	sd	s0,0(sp)
    810018a8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    810018aa:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    810018ac:	2501                	sext.w	a0,a0
    810018ae:	60a2                	ld	ra,8(sp)
    810018b0:	6402                	ld	s0,0(sp)
    810018b2:	0141                	addi	sp,sp,16
    810018b4:	8082                	ret

00000000810018b6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    810018b6:	1141                	addi	sp,sp,-16
    810018b8:	e406                	sd	ra,8(sp)
    810018ba:	e022                	sd	s0,0(sp)
    810018bc:	0800                	addi	s0,sp,16
    810018be:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    810018c0:	2781                	sext.w	a5,a5
    810018c2:	079e                	slli	a5,a5,0x7
  return c;
}
    810018c4:	00006517          	auipc	a0,0x6
    810018c8:	19c50513          	addi	a0,a0,412 # 81007a60 <cpus>
    810018cc:	953e                	add	a0,a0,a5
    810018ce:	60a2                	ld	ra,8(sp)
    810018d0:	6402                	ld	s0,0(sp)
    810018d2:	0141                	addi	sp,sp,16
    810018d4:	8082                	ret

00000000810018d6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    810018d6:	1101                	addi	sp,sp,-32
    810018d8:	ec06                	sd	ra,24(sp)
    810018da:	e822                	sd	s0,16(sp)
    810018dc:	e426                	sd	s1,8(sp)
    810018de:	1000                	addi	s0,sp,32
  push_off();
    810018e0:	aecff0ef          	jal	81000bcc <push_off>
    810018e4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    810018e6:	2781                	sext.w	a5,a5
    810018e8:	079e                	slli	a5,a5,0x7
    810018ea:	00006717          	auipc	a4,0x6
    810018ee:	14670713          	addi	a4,a4,326 # 81007a30 <pid_lock>
    810018f2:	97ba                	add	a5,a5,a4
    810018f4:	7b84                	ld	s1,48(a5)
  pop_off();
    810018f6:	b5aff0ef          	jal	81000c50 <pop_off>
  return p;
}
    810018fa:	8526                	mv	a0,s1
    810018fc:	60e2                	ld	ra,24(sp)
    810018fe:	6442                	ld	s0,16(sp)
    81001900:	64a2                	ld	s1,8(sp)
    81001902:	6105                	addi	sp,sp,32
    81001904:	8082                	ret

0000000081001906 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    81001906:	1141                	addi	sp,sp,-16
    81001908:	e406                	sd	ra,8(sp)
    8100190a:	e022                	sd	s0,0(sp)
    8100190c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8100190e:	fc9ff0ef          	jal	810018d6 <myproc>
    81001912:	b8eff0ef          	jal	81000ca0 <release>

  if (first) {
    81001916:	00006797          	auipc	a5,0x6
    8100191a:	f6a7a783          	lw	a5,-150(a5) # 81007880 <first.1>
    8100191e:	e799                	bnez	a5,8100192c <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    81001920:	2bd000ef          	jal	810023dc <usertrapret>
}
    81001924:	60a2                	ld	ra,8(sp)
    81001926:	6402                	ld	s0,0(sp)
    81001928:	0141                	addi	sp,sp,16
    8100192a:	8082                	ret
    fsinit(ROOTDEV);
    8100192c:	4505                	li	a0,1
    8100192e:	624010ef          	jal	81002f52 <fsinit>
    first = 0;
    81001932:	00006797          	auipc	a5,0x6
    81001936:	f407a723          	sw	zero,-178(a5) # 81007880 <first.1>
    __sync_synchronize();
    8100193a:	0330000f          	fence	rw,rw
    8100193e:	b7cd                	j	81001920 <forkret+0x1a>

0000000081001940 <allocpid>:
{
    81001940:	1101                	addi	sp,sp,-32
    81001942:	ec06                	sd	ra,24(sp)
    81001944:	e822                	sd	s0,16(sp)
    81001946:	e426                	sd	s1,8(sp)
    81001948:	e04a                	sd	s2,0(sp)
    8100194a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8100194c:	00006917          	auipc	s2,0x6
    81001950:	0e490913          	addi	s2,s2,228 # 81007a30 <pid_lock>
    81001954:	854a                	mv	a0,s2
    81001956:	ab6ff0ef          	jal	81000c0c <acquire>
  pid = nextpid;
    8100195a:	00006797          	auipc	a5,0x6
    8100195e:	f2a78793          	addi	a5,a5,-214 # 81007884 <nextpid>
    81001962:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    81001964:	0014871b          	addiw	a4,s1,1
    81001968:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8100196a:	854a                	mv	a0,s2
    8100196c:	b34ff0ef          	jal	81000ca0 <release>
}
    81001970:	8526                	mv	a0,s1
    81001972:	60e2                	ld	ra,24(sp)
    81001974:	6442                	ld	s0,16(sp)
    81001976:	64a2                	ld	s1,8(sp)
    81001978:	6902                	ld	s2,0(sp)
    8100197a:	6105                	addi	sp,sp,32
    8100197c:	8082                	ret

000000008100197e <proc_pagetable>:
{
    8100197e:	1101                	addi	sp,sp,-32
    81001980:	ec06                	sd	ra,24(sp)
    81001982:	e822                	sd	s0,16(sp)
    81001984:	e426                	sd	s1,8(sp)
    81001986:	e04a                	sd	s2,0(sp)
    81001988:	1000                	addi	s0,sp,32
    8100198a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8100198c:	90bff0ef          	jal	81001296 <uvmcreate>
    81001990:	84aa                	mv	s1,a0
  if(pagetable == 0)
    81001992:	cd05                	beqz	a0,810019ca <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    81001994:	4729                	li	a4,10
    81001996:	00004697          	auipc	a3,0x4
    8100199a:	66a68693          	addi	a3,a3,1642 # 81006000 <_trampoline>
    8100199e:	6605                	lui	a2,0x1
    810019a0:	040005b7          	lui	a1,0x4000
    810019a4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7d000001>
    810019a6:	05b2                	slli	a1,a1,0xc
    810019a8:	e88ff0ef          	jal	81001030 <mappages>
    810019ac:	02054663          	bltz	a0,810019d8 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    810019b0:	4719                	li	a4,6
    810019b2:	05893683          	ld	a3,88(s2)
    810019b6:	6605                	lui	a2,0x1
    810019b8:	020005b7          	lui	a1,0x2000
    810019bc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7f000001>
    810019be:	05b6                	slli	a1,a1,0xd
    810019c0:	8526                	mv	a0,s1
    810019c2:	e6eff0ef          	jal	81001030 <mappages>
    810019c6:	00054f63          	bltz	a0,810019e4 <proc_pagetable+0x66>
}
    810019ca:	8526                	mv	a0,s1
    810019cc:	60e2                	ld	ra,24(sp)
    810019ce:	6442                	ld	s0,16(sp)
    810019d0:	64a2                	ld	s1,8(sp)
    810019d2:	6902                	ld	s2,0(sp)
    810019d4:	6105                	addi	sp,sp,32
    810019d6:	8082                	ret
    uvmfree(pagetable, 0);
    810019d8:	4581                	li	a1,0
    810019da:	8526                	mv	a0,s1
    810019dc:	a91ff0ef          	jal	8100146c <uvmfree>
    return 0;
    810019e0:	4481                	li	s1,0
    810019e2:	b7e5                	j	810019ca <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    810019e4:	4681                	li	a3,0
    810019e6:	4605                	li	a2,1
    810019e8:	040005b7          	lui	a1,0x4000
    810019ec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7d000001>
    810019ee:	05b2                	slli	a1,a1,0xc
    810019f0:	8526                	mv	a0,s1
    810019f2:	fe8ff0ef          	jal	810011da <uvmunmap>
    uvmfree(pagetable, 0);
    810019f6:	4581                	li	a1,0
    810019f8:	8526                	mv	a0,s1
    810019fa:	a73ff0ef          	jal	8100146c <uvmfree>
    return 0;
    810019fe:	4481                	li	s1,0
    81001a00:	b7e9                	j	810019ca <proc_pagetable+0x4c>

0000000081001a02 <proc_freepagetable>:
{
    81001a02:	1101                	addi	sp,sp,-32
    81001a04:	ec06                	sd	ra,24(sp)
    81001a06:	e822                	sd	s0,16(sp)
    81001a08:	e426                	sd	s1,8(sp)
    81001a0a:	e04a                	sd	s2,0(sp)
    81001a0c:	1000                	addi	s0,sp,32
    81001a0e:	84aa                	mv	s1,a0
    81001a10:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    81001a12:	4681                	li	a3,0
    81001a14:	4605                	li	a2,1
    81001a16:	040005b7          	lui	a1,0x4000
    81001a1a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7d000001>
    81001a1c:	05b2                	slli	a1,a1,0xc
    81001a1e:	fbcff0ef          	jal	810011da <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    81001a22:	4681                	li	a3,0
    81001a24:	4605                	li	a2,1
    81001a26:	020005b7          	lui	a1,0x2000
    81001a2a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7f000001>
    81001a2c:	05b6                	slli	a1,a1,0xd
    81001a2e:	8526                	mv	a0,s1
    81001a30:	faaff0ef          	jal	810011da <uvmunmap>
  uvmfree(pagetable, sz);
    81001a34:	85ca                	mv	a1,s2
    81001a36:	8526                	mv	a0,s1
    81001a38:	a35ff0ef          	jal	8100146c <uvmfree>
}
    81001a3c:	60e2                	ld	ra,24(sp)
    81001a3e:	6442                	ld	s0,16(sp)
    81001a40:	64a2                	ld	s1,8(sp)
    81001a42:	6902                	ld	s2,0(sp)
    81001a44:	6105                	addi	sp,sp,32
    81001a46:	8082                	ret

0000000081001a48 <freeproc>:
{
    81001a48:	1101                	addi	sp,sp,-32
    81001a4a:	ec06                	sd	ra,24(sp)
    81001a4c:	e822                	sd	s0,16(sp)
    81001a4e:	e426                	sd	s1,8(sp)
    81001a50:	1000                	addi	s0,sp,32
    81001a52:	84aa                	mv	s1,a0
  if(p->trapframe)
    81001a54:	6d28                	ld	a0,88(a0)
    81001a56:	c119                	beqz	a0,81001a5c <freeproc+0x14>
    kfree((void*)p->trapframe);
    81001a58:	ffbfe0ef          	jal	81000a52 <kfree>
  p->trapframe = 0;
    81001a5c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    81001a60:	68a8                	ld	a0,80(s1)
    81001a62:	c501                	beqz	a0,81001a6a <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    81001a64:	64ac                	ld	a1,72(s1)
    81001a66:	f9dff0ef          	jal	81001a02 <proc_freepagetable>
  p->pagetable = 0;
    81001a6a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    81001a6e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    81001a72:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    81001a76:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    81001a7a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    81001a7e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    81001a82:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    81001a86:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    81001a8a:	0004ac23          	sw	zero,24(s1)
}
    81001a8e:	60e2                	ld	ra,24(sp)
    81001a90:	6442                	ld	s0,16(sp)
    81001a92:	64a2                	ld	s1,8(sp)
    81001a94:	6105                	addi	sp,sp,32
    81001a96:	8082                	ret

0000000081001a98 <allocproc>:
{
    81001a98:	1101                	addi	sp,sp,-32
    81001a9a:	ec06                	sd	ra,24(sp)
    81001a9c:	e822                	sd	s0,16(sp)
    81001a9e:	e426                	sd	s1,8(sp)
    81001aa0:	e04a                	sd	s2,0(sp)
    81001aa2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    81001aa4:	00006497          	auipc	s1,0x6
    81001aa8:	3bc48493          	addi	s1,s1,956 # 81007e60 <proc>
    81001aac:	0000c917          	auipc	s2,0xc
    81001ab0:	db490913          	addi	s2,s2,-588 # 8100d860 <tickslock>
    acquire(&p->lock);
    81001ab4:	8526                	mv	a0,s1
    81001ab6:	956ff0ef          	jal	81000c0c <acquire>
    if(p->state == UNUSED) {
    81001aba:	4c9c                	lw	a5,24(s1)
    81001abc:	cb91                	beqz	a5,81001ad0 <allocproc+0x38>
      release(&p->lock);
    81001abe:	8526                	mv	a0,s1
    81001ac0:	9e0ff0ef          	jal	81000ca0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    81001ac4:	16848493          	addi	s1,s1,360
    81001ac8:	ff2496e3          	bne	s1,s2,81001ab4 <allocproc+0x1c>
  return 0;
    81001acc:	4481                	li	s1,0
    81001ace:	a089                	j	81001b10 <allocproc+0x78>
  p->pid = allocpid();
    81001ad0:	e71ff0ef          	jal	81001940 <allocpid>
    81001ad4:	d888                	sw	a0,48(s1)
  p->state = USED;
    81001ad6:	4785                	li	a5,1
    81001ad8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    81001ada:	85eff0ef          	jal	81000b38 <kalloc>
    81001ade:	892a                	mv	s2,a0
    81001ae0:	eca8                	sd	a0,88(s1)
    81001ae2:	cd15                	beqz	a0,81001b1e <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    81001ae4:	8526                	mv	a0,s1
    81001ae6:	e99ff0ef          	jal	8100197e <proc_pagetable>
    81001aea:	892a                	mv	s2,a0
    81001aec:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    81001aee:	c121                	beqz	a0,81001b2e <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    81001af0:	07000613          	li	a2,112
    81001af4:	4581                	li	a1,0
    81001af6:	06048513          	addi	a0,s1,96
    81001afa:	9e2ff0ef          	jal	81000cdc <memset>
  p->context.ra = (uint64)forkret;
    81001afe:	00000797          	auipc	a5,0x0
    81001b02:	e0878793          	addi	a5,a5,-504 # 81001906 <forkret>
    81001b06:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    81001b08:	60bc                	ld	a5,64(s1)
    81001b0a:	6705                	lui	a4,0x1
    81001b0c:	97ba                	add	a5,a5,a4
    81001b0e:	f4bc                	sd	a5,104(s1)
}
    81001b10:	8526                	mv	a0,s1
    81001b12:	60e2                	ld	ra,24(sp)
    81001b14:	6442                	ld	s0,16(sp)
    81001b16:	64a2                	ld	s1,8(sp)
    81001b18:	6902                	ld	s2,0(sp)
    81001b1a:	6105                	addi	sp,sp,32
    81001b1c:	8082                	ret
    freeproc(p);
    81001b1e:	8526                	mv	a0,s1
    81001b20:	f29ff0ef          	jal	81001a48 <freeproc>
    release(&p->lock);
    81001b24:	8526                	mv	a0,s1
    81001b26:	97aff0ef          	jal	81000ca0 <release>
    return 0;
    81001b2a:	84ca                	mv	s1,s2
    81001b2c:	b7d5                	j	81001b10 <allocproc+0x78>
    freeproc(p);
    81001b2e:	8526                	mv	a0,s1
    81001b30:	f19ff0ef          	jal	81001a48 <freeproc>
    release(&p->lock);
    81001b34:	8526                	mv	a0,s1
    81001b36:	96aff0ef          	jal	81000ca0 <release>
    return 0;
    81001b3a:	84ca                	mv	s1,s2
    81001b3c:	bfd1                	j	81001b10 <allocproc+0x78>

0000000081001b3e <userinit>:
{
    81001b3e:	1101                	addi	sp,sp,-32
    81001b40:	ec06                	sd	ra,24(sp)
    81001b42:	e822                	sd	s0,16(sp)
    81001b44:	e426                	sd	s1,8(sp)
    81001b46:	1000                	addi	s0,sp,32
  p = allocproc();
    81001b48:	f51ff0ef          	jal	81001a98 <allocproc>
    81001b4c:	84aa                	mv	s1,a0
  initproc = p;
    81001b4e:	00006797          	auipc	a5,0x6
    81001b52:	daa7b523          	sd	a0,-598(a5) # 810078f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    81001b56:	03400613          	li	a2,52
    81001b5a:	00006597          	auipc	a1,0x6
    81001b5e:	d3658593          	addi	a1,a1,-714 # 81007890 <initcode>
    81001b62:	6928                	ld	a0,80(a0)
    81001b64:	f58ff0ef          	jal	810012bc <uvmfirst>
  p->sz = PGSIZE;
    81001b68:	6785                	lui	a5,0x1
    81001b6a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    81001b6c:	6cb8                	ld	a4,88(s1)
    81001b6e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x80ffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    81001b72:	6cb8                	ld	a4,88(s1)
    81001b74:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    81001b76:	4641                	li	a2,16
    81001b78:	00005597          	auipc	a1,0x5
    81001b7c:	6a058593          	addi	a1,a1,1696 # 81007218 <etext+0x218>
    81001b80:	15848513          	addi	a0,s1,344
    81001b84:	aaaff0ef          	jal	81000e2e <safestrcpy>
  p->cwd = namei("/");
    81001b88:	00005517          	auipc	a0,0x5
    81001b8c:	6a050513          	addi	a0,a0,1696 # 81007228 <etext+0x228>
    81001b90:	4e7010ef          	jal	81003876 <namei>
    81001b94:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    81001b98:	478d                	li	a5,3
    81001b9a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    81001b9c:	8526                	mv	a0,s1
    81001b9e:	902ff0ef          	jal	81000ca0 <release>
}
    81001ba2:	60e2                	ld	ra,24(sp)
    81001ba4:	6442                	ld	s0,16(sp)
    81001ba6:	64a2                	ld	s1,8(sp)
    81001ba8:	6105                	addi	sp,sp,32
    81001baa:	8082                	ret

0000000081001bac <growproc>:
{
    81001bac:	1101                	addi	sp,sp,-32
    81001bae:	ec06                	sd	ra,24(sp)
    81001bb0:	e822                	sd	s0,16(sp)
    81001bb2:	e426                	sd	s1,8(sp)
    81001bb4:	e04a                	sd	s2,0(sp)
    81001bb6:	1000                	addi	s0,sp,32
    81001bb8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    81001bba:	d1dff0ef          	jal	810018d6 <myproc>
    81001bbe:	84aa                	mv	s1,a0
  sz = p->sz;
    81001bc0:	652c                	ld	a1,72(a0)
  if(n > 0){
    81001bc2:	01204c63          	bgtz	s2,81001bda <growproc+0x2e>
  } else if(n < 0){
    81001bc6:	02094463          	bltz	s2,81001bee <growproc+0x42>
  p->sz = sz;
    81001bca:	e4ac                	sd	a1,72(s1)
  return 0;
    81001bcc:	4501                	li	a0,0
}
    81001bce:	60e2                	ld	ra,24(sp)
    81001bd0:	6442                	ld	s0,16(sp)
    81001bd2:	64a2                	ld	s1,8(sp)
    81001bd4:	6902                	ld	s2,0(sp)
    81001bd6:	6105                	addi	sp,sp,32
    81001bd8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    81001bda:	4691                	li	a3,4
    81001bdc:	00b90633          	add	a2,s2,a1
    81001be0:	6928                	ld	a0,80(a0)
    81001be2:	f7cff0ef          	jal	8100135e <uvmalloc>
    81001be6:	85aa                	mv	a1,a0
    81001be8:	f16d                	bnez	a0,81001bca <growproc+0x1e>
      return -1;
    81001bea:	557d                	li	a0,-1
    81001bec:	b7cd                	j	81001bce <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    81001bee:	00b90633          	add	a2,s2,a1
    81001bf2:	6928                	ld	a0,80(a0)
    81001bf4:	f26ff0ef          	jal	8100131a <uvmdealloc>
    81001bf8:	85aa                	mv	a1,a0
    81001bfa:	bfc1                	j	81001bca <growproc+0x1e>

0000000081001bfc <fork>:
{
    81001bfc:	7139                	addi	sp,sp,-64
    81001bfe:	fc06                	sd	ra,56(sp)
    81001c00:	f822                	sd	s0,48(sp)
    81001c02:	f04a                	sd	s2,32(sp)
    81001c04:	e456                	sd	s5,8(sp)
    81001c06:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    81001c08:	ccfff0ef          	jal	810018d6 <myproc>
    81001c0c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    81001c0e:	e8bff0ef          	jal	81001a98 <allocproc>
    81001c12:	0e050a63          	beqz	a0,81001d06 <fork+0x10a>
    81001c16:	e852                	sd	s4,16(sp)
    81001c18:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    81001c1a:	048ab603          	ld	a2,72(s5)
    81001c1e:	692c                	ld	a1,80(a0)
    81001c20:	050ab503          	ld	a0,80(s5)
    81001c24:	87bff0ef          	jal	8100149e <uvmcopy>
    81001c28:	04054a63          	bltz	a0,81001c7c <fork+0x80>
    81001c2c:	f426                	sd	s1,40(sp)
    81001c2e:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    81001c30:	048ab783          	ld	a5,72(s5)
    81001c34:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    81001c38:	058ab683          	ld	a3,88(s5)
    81001c3c:	87b6                	mv	a5,a3
    81001c3e:	058a3703          	ld	a4,88(s4)
    81001c42:	12068693          	addi	a3,a3,288
    81001c46:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x80fff000>
    81001c4a:	6788                	ld	a0,8(a5)
    81001c4c:	6b8c                	ld	a1,16(a5)
    81001c4e:	6f90                	ld	a2,24(a5)
    81001c50:	01073023          	sd	a6,0(a4)
    81001c54:	e708                	sd	a0,8(a4)
    81001c56:	eb0c                	sd	a1,16(a4)
    81001c58:	ef10                	sd	a2,24(a4)
    81001c5a:	02078793          	addi	a5,a5,32
    81001c5e:	02070713          	addi	a4,a4,32
    81001c62:	fed792e3          	bne	a5,a3,81001c46 <fork+0x4a>
  np->trapframe->a0 = 0;
    81001c66:	058a3783          	ld	a5,88(s4)
    81001c6a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    81001c6e:	0d0a8493          	addi	s1,s5,208
    81001c72:	0d0a0913          	addi	s2,s4,208
    81001c76:	150a8993          	addi	s3,s5,336
    81001c7a:	a831                	j	81001c96 <fork+0x9a>
    freeproc(np);
    81001c7c:	8552                	mv	a0,s4
    81001c7e:	dcbff0ef          	jal	81001a48 <freeproc>
    release(&np->lock);
    81001c82:	8552                	mv	a0,s4
    81001c84:	81cff0ef          	jal	81000ca0 <release>
    return -1;
    81001c88:	597d                	li	s2,-1
    81001c8a:	6a42                	ld	s4,16(sp)
    81001c8c:	a0b5                	j	81001cf8 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    81001c8e:	04a1                	addi	s1,s1,8
    81001c90:	0921                	addi	s2,s2,8
    81001c92:	01348963          	beq	s1,s3,81001ca4 <fork+0xa8>
    if(p->ofile[i])
    81001c96:	6088                	ld	a0,0(s1)
    81001c98:	d97d                	beqz	a0,81001c8e <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    81001c9a:	178020ef          	jal	81003e12 <filedup>
    81001c9e:	00a93023          	sd	a0,0(s2)
    81001ca2:	b7f5                	j	81001c8e <fork+0x92>
  np->cwd = idup(p->cwd);
    81001ca4:	150ab503          	ld	a0,336(s5)
    81001ca8:	4a8010ef          	jal	81003150 <idup>
    81001cac:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    81001cb0:	4641                	li	a2,16
    81001cb2:	158a8593          	addi	a1,s5,344
    81001cb6:	158a0513          	addi	a0,s4,344
    81001cba:	974ff0ef          	jal	81000e2e <safestrcpy>
  pid = np->pid;
    81001cbe:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    81001cc2:	8552                	mv	a0,s4
    81001cc4:	fddfe0ef          	jal	81000ca0 <release>
  acquire(&wait_lock);
    81001cc8:	00006497          	auipc	s1,0x6
    81001ccc:	d8048493          	addi	s1,s1,-640 # 81007a48 <wait_lock>
    81001cd0:	8526                	mv	a0,s1
    81001cd2:	f3bfe0ef          	jal	81000c0c <acquire>
  np->parent = p;
    81001cd6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    81001cda:	8526                	mv	a0,s1
    81001cdc:	fc5fe0ef          	jal	81000ca0 <release>
  acquire(&np->lock);
    81001ce0:	8552                	mv	a0,s4
    81001ce2:	f2bfe0ef          	jal	81000c0c <acquire>
  np->state = RUNNABLE;
    81001ce6:	478d                	li	a5,3
    81001ce8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    81001cec:	8552                	mv	a0,s4
    81001cee:	fb3fe0ef          	jal	81000ca0 <release>
  return pid;
    81001cf2:	74a2                	ld	s1,40(sp)
    81001cf4:	69e2                	ld	s3,24(sp)
    81001cf6:	6a42                	ld	s4,16(sp)
}
    81001cf8:	854a                	mv	a0,s2
    81001cfa:	70e2                	ld	ra,56(sp)
    81001cfc:	7442                	ld	s0,48(sp)
    81001cfe:	7902                	ld	s2,32(sp)
    81001d00:	6aa2                	ld	s5,8(sp)
    81001d02:	6121                	addi	sp,sp,64
    81001d04:	8082                	ret
    return -1;
    81001d06:	597d                	li	s2,-1
    81001d08:	bfc5                	j	81001cf8 <fork+0xfc>

0000000081001d0a <scheduler>:
{
    81001d0a:	715d                	addi	sp,sp,-80
    81001d0c:	e486                	sd	ra,72(sp)
    81001d0e:	e0a2                	sd	s0,64(sp)
    81001d10:	fc26                	sd	s1,56(sp)
    81001d12:	f84a                	sd	s2,48(sp)
    81001d14:	f44e                	sd	s3,40(sp)
    81001d16:	f052                	sd	s4,32(sp)
    81001d18:	ec56                	sd	s5,24(sp)
    81001d1a:	e85a                	sd	s6,16(sp)
    81001d1c:	e45e                	sd	s7,8(sp)
    81001d1e:	e062                	sd	s8,0(sp)
    81001d20:	0880                	addi	s0,sp,80
    81001d22:	8792                	mv	a5,tp
  int id = r_tp();
    81001d24:	2781                	sext.w	a5,a5
  c->proc = 0;
    81001d26:	00779b13          	slli	s6,a5,0x7
    81001d2a:	00006717          	auipc	a4,0x6
    81001d2e:	d0670713          	addi	a4,a4,-762 # 81007a30 <pid_lock>
    81001d32:	975a                	add	a4,a4,s6
    81001d34:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    81001d38:	00006717          	auipc	a4,0x6
    81001d3c:	d3070713          	addi	a4,a4,-720 # 81007a68 <cpus+0x8>
    81001d40:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    81001d42:	4c11                	li	s8,4
        c->proc = p;
    81001d44:	079e                	slli	a5,a5,0x7
    81001d46:	00006a17          	auipc	s4,0x6
    81001d4a:	ceaa0a13          	addi	s4,s4,-790 # 81007a30 <pid_lock>
    81001d4e:	9a3e                	add	s4,s4,a5
        found = 1;
    81001d50:	4b85                	li	s7,1
    81001d52:	a0a9                	j	81001d9c <scheduler+0x92>
      release(&p->lock);
    81001d54:	8526                	mv	a0,s1
    81001d56:	f4bfe0ef          	jal	81000ca0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    81001d5a:	16848493          	addi	s1,s1,360
    81001d5e:	03248563          	beq	s1,s2,81001d88 <scheduler+0x7e>
      acquire(&p->lock);
    81001d62:	8526                	mv	a0,s1
    81001d64:	ea9fe0ef          	jal	81000c0c <acquire>
      if(p->state == RUNNABLE) {
    81001d68:	4c9c                	lw	a5,24(s1)
    81001d6a:	ff3795e3          	bne	a5,s3,81001d54 <scheduler+0x4a>
        p->state = RUNNING;
    81001d6e:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    81001d72:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    81001d76:	06048593          	addi	a1,s1,96
    81001d7a:	855a                	mv	a0,s6
    81001d7c:	5b6000ef          	jal	81002332 <swtch>
        c->proc = 0;
    81001d80:	020a3823          	sd	zero,48(s4)
        found = 1;
    81001d84:	8ade                	mv	s5,s7
    81001d86:	b7f9                	j	81001d54 <scheduler+0x4a>
    if(found == 0) {
    81001d88:	000a9a63          	bnez	s5,81001d9c <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81001d8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    81001d90:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81001d94:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    81001d98:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81001d9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    81001da0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81001da4:	10079073          	csrw	sstatus,a5
    int found = 0;
    81001da8:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    81001daa:	00006497          	auipc	s1,0x6
    81001dae:	0b648493          	addi	s1,s1,182 # 81007e60 <proc>
      if(p->state == RUNNABLE) {
    81001db2:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    81001db4:	0000c917          	auipc	s2,0xc
    81001db8:	aac90913          	addi	s2,s2,-1364 # 8100d860 <tickslock>
    81001dbc:	b75d                	j	81001d62 <scheduler+0x58>

0000000081001dbe <sched>:
{
    81001dbe:	7179                	addi	sp,sp,-48
    81001dc0:	f406                	sd	ra,40(sp)
    81001dc2:	f022                	sd	s0,32(sp)
    81001dc4:	ec26                	sd	s1,24(sp)
    81001dc6:	e84a                	sd	s2,16(sp)
    81001dc8:	e44e                	sd	s3,8(sp)
    81001dca:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    81001dcc:	b0bff0ef          	jal	810018d6 <myproc>
    81001dd0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    81001dd2:	dd1fe0ef          	jal	81000ba2 <holding>
    81001dd6:	c92d                	beqz	a0,81001e48 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    81001dd8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    81001dda:	2781                	sext.w	a5,a5
    81001ddc:	079e                	slli	a5,a5,0x7
    81001dde:	00006717          	auipc	a4,0x6
    81001de2:	c5270713          	addi	a4,a4,-942 # 81007a30 <pid_lock>
    81001de6:	97ba                	add	a5,a5,a4
    81001de8:	0a87a703          	lw	a4,168(a5)
    81001dec:	4785                	li	a5,1
    81001dee:	06f71363          	bne	a4,a5,81001e54 <sched+0x96>
  if(p->state == RUNNING)
    81001df2:	4c98                	lw	a4,24(s1)
    81001df4:	4791                	li	a5,4
    81001df6:	06f70563          	beq	a4,a5,81001e60 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81001dfa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    81001dfe:	8b89                	andi	a5,a5,2
  if(intr_get())
    81001e00:	e7b5                	bnez	a5,81001e6c <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    81001e02:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    81001e04:	00006917          	auipc	s2,0x6
    81001e08:	c2c90913          	addi	s2,s2,-980 # 81007a30 <pid_lock>
    81001e0c:	2781                	sext.w	a5,a5
    81001e0e:	079e                	slli	a5,a5,0x7
    81001e10:	97ca                	add	a5,a5,s2
    81001e12:	0ac7a983          	lw	s3,172(a5)
    81001e16:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    81001e18:	2781                	sext.w	a5,a5
    81001e1a:	079e                	slli	a5,a5,0x7
    81001e1c:	00006597          	auipc	a1,0x6
    81001e20:	c4c58593          	addi	a1,a1,-948 # 81007a68 <cpus+0x8>
    81001e24:	95be                	add	a1,a1,a5
    81001e26:	06048513          	addi	a0,s1,96
    81001e2a:	508000ef          	jal	81002332 <swtch>
    81001e2e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    81001e30:	2781                	sext.w	a5,a5
    81001e32:	079e                	slli	a5,a5,0x7
    81001e34:	993e                	add	s2,s2,a5
    81001e36:	0b392623          	sw	s3,172(s2)
}
    81001e3a:	70a2                	ld	ra,40(sp)
    81001e3c:	7402                	ld	s0,32(sp)
    81001e3e:	64e2                	ld	s1,24(sp)
    81001e40:	6942                	ld	s2,16(sp)
    81001e42:	69a2                	ld	s3,8(sp)
    81001e44:	6145                	addi	sp,sp,48
    81001e46:	8082                	ret
    panic("sched p->lock");
    81001e48:	00005517          	auipc	a0,0x5
    81001e4c:	3e850513          	addi	a0,a0,1000 # 81007230 <etext+0x230>
    81001e50:	959fe0ef          	jal	810007a8 <panic>
    panic("sched locks");
    81001e54:	00005517          	auipc	a0,0x5
    81001e58:	3ec50513          	addi	a0,a0,1004 # 81007240 <etext+0x240>
    81001e5c:	94dfe0ef          	jal	810007a8 <panic>
    panic("sched running");
    81001e60:	00005517          	auipc	a0,0x5
    81001e64:	3f050513          	addi	a0,a0,1008 # 81007250 <etext+0x250>
    81001e68:	941fe0ef          	jal	810007a8 <panic>
    panic("sched interruptible");
    81001e6c:	00005517          	auipc	a0,0x5
    81001e70:	3f450513          	addi	a0,a0,1012 # 81007260 <etext+0x260>
    81001e74:	935fe0ef          	jal	810007a8 <panic>

0000000081001e78 <yield>:
{
    81001e78:	1101                	addi	sp,sp,-32
    81001e7a:	ec06                	sd	ra,24(sp)
    81001e7c:	e822                	sd	s0,16(sp)
    81001e7e:	e426                	sd	s1,8(sp)
    81001e80:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    81001e82:	a55ff0ef          	jal	810018d6 <myproc>
    81001e86:	84aa                	mv	s1,a0
  acquire(&p->lock);
    81001e88:	d85fe0ef          	jal	81000c0c <acquire>
  p->state = RUNNABLE;
    81001e8c:	478d                	li	a5,3
    81001e8e:	cc9c                	sw	a5,24(s1)
  sched();
    81001e90:	f2fff0ef          	jal	81001dbe <sched>
  release(&p->lock);
    81001e94:	8526                	mv	a0,s1
    81001e96:	e0bfe0ef          	jal	81000ca0 <release>
}
    81001e9a:	60e2                	ld	ra,24(sp)
    81001e9c:	6442                	ld	s0,16(sp)
    81001e9e:	64a2                	ld	s1,8(sp)
    81001ea0:	6105                	addi	sp,sp,32
    81001ea2:	8082                	ret

0000000081001ea4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    81001ea4:	7179                	addi	sp,sp,-48
    81001ea6:	f406                	sd	ra,40(sp)
    81001ea8:	f022                	sd	s0,32(sp)
    81001eaa:	ec26                	sd	s1,24(sp)
    81001eac:	e84a                	sd	s2,16(sp)
    81001eae:	e44e                	sd	s3,8(sp)
    81001eb0:	1800                	addi	s0,sp,48
    81001eb2:	89aa                	mv	s3,a0
    81001eb4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    81001eb6:	a21ff0ef          	jal	810018d6 <myproc>
    81001eba:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    81001ebc:	d51fe0ef          	jal	81000c0c <acquire>
  release(lk);
    81001ec0:	854a                	mv	a0,s2
    81001ec2:	ddffe0ef          	jal	81000ca0 <release>

  // Go to sleep.
  p->chan = chan;
    81001ec6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    81001eca:	4789                	li	a5,2
    81001ecc:	cc9c                	sw	a5,24(s1)

  sched();
    81001ece:	ef1ff0ef          	jal	81001dbe <sched>

  // Tidy up.
  p->chan = 0;
    81001ed2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    81001ed6:	8526                	mv	a0,s1
    81001ed8:	dc9fe0ef          	jal	81000ca0 <release>
  acquire(lk);
    81001edc:	854a                	mv	a0,s2
    81001ede:	d2ffe0ef          	jal	81000c0c <acquire>
}
    81001ee2:	70a2                	ld	ra,40(sp)
    81001ee4:	7402                	ld	s0,32(sp)
    81001ee6:	64e2                	ld	s1,24(sp)
    81001ee8:	6942                	ld	s2,16(sp)
    81001eea:	69a2                	ld	s3,8(sp)
    81001eec:	6145                	addi	sp,sp,48
    81001eee:	8082                	ret

0000000081001ef0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    81001ef0:	7139                	addi	sp,sp,-64
    81001ef2:	fc06                	sd	ra,56(sp)
    81001ef4:	f822                	sd	s0,48(sp)
    81001ef6:	f426                	sd	s1,40(sp)
    81001ef8:	f04a                	sd	s2,32(sp)
    81001efa:	ec4e                	sd	s3,24(sp)
    81001efc:	e852                	sd	s4,16(sp)
    81001efe:	e456                	sd	s5,8(sp)
    81001f00:	0080                	addi	s0,sp,64
    81001f02:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    81001f04:	00006497          	auipc	s1,0x6
    81001f08:	f5c48493          	addi	s1,s1,-164 # 81007e60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    81001f0c:	4989                	li	s3,2
        p->state = RUNNABLE;
    81001f0e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    81001f10:	0000c917          	auipc	s2,0xc
    81001f14:	95090913          	addi	s2,s2,-1712 # 8100d860 <tickslock>
    81001f18:	a801                	j	81001f28 <wakeup+0x38>
      }
      release(&p->lock);
    81001f1a:	8526                	mv	a0,s1
    81001f1c:	d85fe0ef          	jal	81000ca0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    81001f20:	16848493          	addi	s1,s1,360
    81001f24:	03248263          	beq	s1,s2,81001f48 <wakeup+0x58>
    if(p != myproc()){
    81001f28:	9afff0ef          	jal	810018d6 <myproc>
    81001f2c:	fea48ae3          	beq	s1,a0,81001f20 <wakeup+0x30>
      acquire(&p->lock);
    81001f30:	8526                	mv	a0,s1
    81001f32:	cdbfe0ef          	jal	81000c0c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    81001f36:	4c9c                	lw	a5,24(s1)
    81001f38:	ff3791e3          	bne	a5,s3,81001f1a <wakeup+0x2a>
    81001f3c:	709c                	ld	a5,32(s1)
    81001f3e:	fd479ee3          	bne	a5,s4,81001f1a <wakeup+0x2a>
        p->state = RUNNABLE;
    81001f42:	0154ac23          	sw	s5,24(s1)
    81001f46:	bfd1                	j	81001f1a <wakeup+0x2a>
    }
  }
}
    81001f48:	70e2                	ld	ra,56(sp)
    81001f4a:	7442                	ld	s0,48(sp)
    81001f4c:	74a2                	ld	s1,40(sp)
    81001f4e:	7902                	ld	s2,32(sp)
    81001f50:	69e2                	ld	s3,24(sp)
    81001f52:	6a42                	ld	s4,16(sp)
    81001f54:	6aa2                	ld	s5,8(sp)
    81001f56:	6121                	addi	sp,sp,64
    81001f58:	8082                	ret

0000000081001f5a <reparent>:
{
    81001f5a:	7179                	addi	sp,sp,-48
    81001f5c:	f406                	sd	ra,40(sp)
    81001f5e:	f022                	sd	s0,32(sp)
    81001f60:	ec26                	sd	s1,24(sp)
    81001f62:	e84a                	sd	s2,16(sp)
    81001f64:	e44e                	sd	s3,8(sp)
    81001f66:	e052                	sd	s4,0(sp)
    81001f68:	1800                	addi	s0,sp,48
    81001f6a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    81001f6c:	00006497          	auipc	s1,0x6
    81001f70:	ef448493          	addi	s1,s1,-268 # 81007e60 <proc>
      pp->parent = initproc;
    81001f74:	00006a17          	auipc	s4,0x6
    81001f78:	984a0a13          	addi	s4,s4,-1660 # 810078f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    81001f7c:	0000c997          	auipc	s3,0xc
    81001f80:	8e498993          	addi	s3,s3,-1820 # 8100d860 <tickslock>
    81001f84:	a029                	j	81001f8e <reparent+0x34>
    81001f86:	16848493          	addi	s1,s1,360
    81001f8a:	01348b63          	beq	s1,s3,81001fa0 <reparent+0x46>
    if(pp->parent == p){
    81001f8e:	7c9c                	ld	a5,56(s1)
    81001f90:	ff279be3          	bne	a5,s2,81001f86 <reparent+0x2c>
      pp->parent = initproc;
    81001f94:	000a3503          	ld	a0,0(s4)
    81001f98:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    81001f9a:	f57ff0ef          	jal	81001ef0 <wakeup>
    81001f9e:	b7e5                	j	81001f86 <reparent+0x2c>
}
    81001fa0:	70a2                	ld	ra,40(sp)
    81001fa2:	7402                	ld	s0,32(sp)
    81001fa4:	64e2                	ld	s1,24(sp)
    81001fa6:	6942                	ld	s2,16(sp)
    81001fa8:	69a2                	ld	s3,8(sp)
    81001faa:	6a02                	ld	s4,0(sp)
    81001fac:	6145                	addi	sp,sp,48
    81001fae:	8082                	ret

0000000081001fb0 <exit>:
{
    81001fb0:	7179                	addi	sp,sp,-48
    81001fb2:	f406                	sd	ra,40(sp)
    81001fb4:	f022                	sd	s0,32(sp)
    81001fb6:	ec26                	sd	s1,24(sp)
    81001fb8:	e84a                	sd	s2,16(sp)
    81001fba:	e44e                	sd	s3,8(sp)
    81001fbc:	e052                	sd	s4,0(sp)
    81001fbe:	1800                	addi	s0,sp,48
    81001fc0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    81001fc2:	915ff0ef          	jal	810018d6 <myproc>
    81001fc6:	89aa                	mv	s3,a0
  if(p == initproc)
    81001fc8:	00006797          	auipc	a5,0x6
    81001fcc:	9307b783          	ld	a5,-1744(a5) # 810078f8 <initproc>
    81001fd0:	0d050493          	addi	s1,a0,208
    81001fd4:	15050913          	addi	s2,a0,336
    81001fd8:	00a79b63          	bne	a5,a0,81001fee <exit+0x3e>
    panic("init exiting");
    81001fdc:	00005517          	auipc	a0,0x5
    81001fe0:	29c50513          	addi	a0,a0,668 # 81007278 <etext+0x278>
    81001fe4:	fc4fe0ef          	jal	810007a8 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    81001fe8:	04a1                	addi	s1,s1,8
    81001fea:	01248963          	beq	s1,s2,81001ffc <exit+0x4c>
    if(p->ofile[fd]){
    81001fee:	6088                	ld	a0,0(s1)
    81001ff0:	dd65                	beqz	a0,81001fe8 <exit+0x38>
      fileclose(f);
    81001ff2:	667010ef          	jal	81003e58 <fileclose>
      p->ofile[fd] = 0;
    81001ff6:	0004b023          	sd	zero,0(s1)
    81001ffa:	b7fd                	j	81001fe8 <exit+0x38>
  begin_op();
    81001ffc:	23d010ef          	jal	81003a38 <begin_op>
  iput(p->cwd);
    81002000:	1509b503          	ld	a0,336(s3)
    81002004:	304010ef          	jal	81003308 <iput>
  end_op();
    81002008:	29b010ef          	jal	81003aa2 <end_op>
  p->cwd = 0;
    8100200c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    81002010:	00006497          	auipc	s1,0x6
    81002014:	a3848493          	addi	s1,s1,-1480 # 81007a48 <wait_lock>
    81002018:	8526                	mv	a0,s1
    8100201a:	bf3fe0ef          	jal	81000c0c <acquire>
  reparent(p);
    8100201e:	854e                	mv	a0,s3
    81002020:	f3bff0ef          	jal	81001f5a <reparent>
  wakeup(p->parent);
    81002024:	0389b503          	ld	a0,56(s3)
    81002028:	ec9ff0ef          	jal	81001ef0 <wakeup>
  acquire(&p->lock);
    8100202c:	854e                	mv	a0,s3
    8100202e:	bdffe0ef          	jal	81000c0c <acquire>
  p->xstate = status;
    81002032:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    81002036:	4795                	li	a5,5
    81002038:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8100203c:	8526                	mv	a0,s1
    8100203e:	c63fe0ef          	jal	81000ca0 <release>
  sched();
    81002042:	d7dff0ef          	jal	81001dbe <sched>
  panic("zombie exit");
    81002046:	00005517          	auipc	a0,0x5
    8100204a:	24250513          	addi	a0,a0,578 # 81007288 <etext+0x288>
    8100204e:	f5afe0ef          	jal	810007a8 <panic>

0000000081002052 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    81002052:	7179                	addi	sp,sp,-48
    81002054:	f406                	sd	ra,40(sp)
    81002056:	f022                	sd	s0,32(sp)
    81002058:	ec26                	sd	s1,24(sp)
    8100205a:	e84a                	sd	s2,16(sp)
    8100205c:	e44e                	sd	s3,8(sp)
    8100205e:	1800                	addi	s0,sp,48
    81002060:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    81002062:	00006497          	auipc	s1,0x6
    81002066:	dfe48493          	addi	s1,s1,-514 # 81007e60 <proc>
    8100206a:	0000b997          	auipc	s3,0xb
    8100206e:	7f698993          	addi	s3,s3,2038 # 8100d860 <tickslock>
    acquire(&p->lock);
    81002072:	8526                	mv	a0,s1
    81002074:	b99fe0ef          	jal	81000c0c <acquire>
    if(p->pid == pid){
    81002078:	589c                	lw	a5,48(s1)
    8100207a:	01278b63          	beq	a5,s2,81002090 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8100207e:	8526                	mv	a0,s1
    81002080:	c21fe0ef          	jal	81000ca0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    81002084:	16848493          	addi	s1,s1,360
    81002088:	ff3495e3          	bne	s1,s3,81002072 <kill+0x20>
  }
  return -1;
    8100208c:	557d                	li	a0,-1
    8100208e:	a819                	j	810020a4 <kill+0x52>
      p->killed = 1;
    81002090:	4785                	li	a5,1
    81002092:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    81002094:	4c98                	lw	a4,24(s1)
    81002096:	4789                	li	a5,2
    81002098:	00f70d63          	beq	a4,a5,810020b2 <kill+0x60>
      release(&p->lock);
    8100209c:	8526                	mv	a0,s1
    8100209e:	c03fe0ef          	jal	81000ca0 <release>
      return 0;
    810020a2:	4501                	li	a0,0
}
    810020a4:	70a2                	ld	ra,40(sp)
    810020a6:	7402                	ld	s0,32(sp)
    810020a8:	64e2                	ld	s1,24(sp)
    810020aa:	6942                	ld	s2,16(sp)
    810020ac:	69a2                	ld	s3,8(sp)
    810020ae:	6145                	addi	sp,sp,48
    810020b0:	8082                	ret
        p->state = RUNNABLE;
    810020b2:	478d                	li	a5,3
    810020b4:	cc9c                	sw	a5,24(s1)
    810020b6:	b7dd                	j	8100209c <kill+0x4a>

00000000810020b8 <setkilled>:

void
setkilled(struct proc *p)
{
    810020b8:	1101                	addi	sp,sp,-32
    810020ba:	ec06                	sd	ra,24(sp)
    810020bc:	e822                	sd	s0,16(sp)
    810020be:	e426                	sd	s1,8(sp)
    810020c0:	1000                	addi	s0,sp,32
    810020c2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    810020c4:	b49fe0ef          	jal	81000c0c <acquire>
  p->killed = 1;
    810020c8:	4785                	li	a5,1
    810020ca:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    810020cc:	8526                	mv	a0,s1
    810020ce:	bd3fe0ef          	jal	81000ca0 <release>
}
    810020d2:	60e2                	ld	ra,24(sp)
    810020d4:	6442                	ld	s0,16(sp)
    810020d6:	64a2                	ld	s1,8(sp)
    810020d8:	6105                	addi	sp,sp,32
    810020da:	8082                	ret

00000000810020dc <killed>:

int
killed(struct proc *p)
{
    810020dc:	1101                	addi	sp,sp,-32
    810020de:	ec06                	sd	ra,24(sp)
    810020e0:	e822                	sd	s0,16(sp)
    810020e2:	e426                	sd	s1,8(sp)
    810020e4:	e04a                	sd	s2,0(sp)
    810020e6:	1000                	addi	s0,sp,32
    810020e8:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    810020ea:	b23fe0ef          	jal	81000c0c <acquire>
  k = p->killed;
    810020ee:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    810020f2:	8526                	mv	a0,s1
    810020f4:	badfe0ef          	jal	81000ca0 <release>
  return k;
}
    810020f8:	854a                	mv	a0,s2
    810020fa:	60e2                	ld	ra,24(sp)
    810020fc:	6442                	ld	s0,16(sp)
    810020fe:	64a2                	ld	s1,8(sp)
    81002100:	6902                	ld	s2,0(sp)
    81002102:	6105                	addi	sp,sp,32
    81002104:	8082                	ret

0000000081002106 <wait>:
{
    81002106:	715d                	addi	sp,sp,-80
    81002108:	e486                	sd	ra,72(sp)
    8100210a:	e0a2                	sd	s0,64(sp)
    8100210c:	fc26                	sd	s1,56(sp)
    8100210e:	f84a                	sd	s2,48(sp)
    81002110:	f44e                	sd	s3,40(sp)
    81002112:	f052                	sd	s4,32(sp)
    81002114:	ec56                	sd	s5,24(sp)
    81002116:	e85a                	sd	s6,16(sp)
    81002118:	e45e                	sd	s7,8(sp)
    8100211a:	0880                	addi	s0,sp,80
    8100211c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8100211e:	fb8ff0ef          	jal	810018d6 <myproc>
    81002122:	892a                	mv	s2,a0
  acquire(&wait_lock);
    81002124:	00006517          	auipc	a0,0x6
    81002128:	92450513          	addi	a0,a0,-1756 # 81007a48 <wait_lock>
    8100212c:	ae1fe0ef          	jal	81000c0c <acquire>
        if(pp->state == ZOMBIE){
    81002130:	4a15                	li	s4,5
        havekids = 1;
    81002132:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    81002134:	0000b997          	auipc	s3,0xb
    81002138:	72c98993          	addi	s3,s3,1836 # 8100d860 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8100213c:	00006b97          	auipc	s7,0x6
    81002140:	90cb8b93          	addi	s7,s7,-1780 # 81007a48 <wait_lock>
    81002144:	a869                	j	810021de <wait+0xd8>
          pid = pp->pid;
    81002146:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8100214a:	000b0c63          	beqz	s6,81002162 <wait+0x5c>
    8100214e:	4691                	li	a3,4
    81002150:	02c48613          	addi	a2,s1,44
    81002154:	85da                	mv	a1,s6
    81002156:	05093503          	ld	a0,80(s2)
    8100215a:	c24ff0ef          	jal	8100157e <copyout>
    8100215e:	02054a63          	bltz	a0,81002192 <wait+0x8c>
          freeproc(pp);
    81002162:	8526                	mv	a0,s1
    81002164:	8e5ff0ef          	jal	81001a48 <freeproc>
          release(&pp->lock);
    81002168:	8526                	mv	a0,s1
    8100216a:	b37fe0ef          	jal	81000ca0 <release>
          release(&wait_lock);
    8100216e:	00006517          	auipc	a0,0x6
    81002172:	8da50513          	addi	a0,a0,-1830 # 81007a48 <wait_lock>
    81002176:	b2bfe0ef          	jal	81000ca0 <release>
}
    8100217a:	854e                	mv	a0,s3
    8100217c:	60a6                	ld	ra,72(sp)
    8100217e:	6406                	ld	s0,64(sp)
    81002180:	74e2                	ld	s1,56(sp)
    81002182:	7942                	ld	s2,48(sp)
    81002184:	79a2                	ld	s3,40(sp)
    81002186:	7a02                	ld	s4,32(sp)
    81002188:	6ae2                	ld	s5,24(sp)
    8100218a:	6b42                	ld	s6,16(sp)
    8100218c:	6ba2                	ld	s7,8(sp)
    8100218e:	6161                	addi	sp,sp,80
    81002190:	8082                	ret
            release(&pp->lock);
    81002192:	8526                	mv	a0,s1
    81002194:	b0dfe0ef          	jal	81000ca0 <release>
            release(&wait_lock);
    81002198:	00006517          	auipc	a0,0x6
    8100219c:	8b050513          	addi	a0,a0,-1872 # 81007a48 <wait_lock>
    810021a0:	b01fe0ef          	jal	81000ca0 <release>
            return -1;
    810021a4:	59fd                	li	s3,-1
    810021a6:	bfd1                	j	8100217a <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    810021a8:	16848493          	addi	s1,s1,360
    810021ac:	03348063          	beq	s1,s3,810021cc <wait+0xc6>
      if(pp->parent == p){
    810021b0:	7c9c                	ld	a5,56(s1)
    810021b2:	ff279be3          	bne	a5,s2,810021a8 <wait+0xa2>
        acquire(&pp->lock);
    810021b6:	8526                	mv	a0,s1
    810021b8:	a55fe0ef          	jal	81000c0c <acquire>
        if(pp->state == ZOMBIE){
    810021bc:	4c9c                	lw	a5,24(s1)
    810021be:	f94784e3          	beq	a5,s4,81002146 <wait+0x40>
        release(&pp->lock);
    810021c2:	8526                	mv	a0,s1
    810021c4:	addfe0ef          	jal	81000ca0 <release>
        havekids = 1;
    810021c8:	8756                	mv	a4,s5
    810021ca:	bff9                	j	810021a8 <wait+0xa2>
    if(!havekids || killed(p)){
    810021cc:	cf19                	beqz	a4,810021ea <wait+0xe4>
    810021ce:	854a                	mv	a0,s2
    810021d0:	f0dff0ef          	jal	810020dc <killed>
    810021d4:	e919                	bnez	a0,810021ea <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    810021d6:	85de                	mv	a1,s7
    810021d8:	854a                	mv	a0,s2
    810021da:	ccbff0ef          	jal	81001ea4 <sleep>
    havekids = 0;
    810021de:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    810021e0:	00006497          	auipc	s1,0x6
    810021e4:	c8048493          	addi	s1,s1,-896 # 81007e60 <proc>
    810021e8:	b7e1                	j	810021b0 <wait+0xaa>
      release(&wait_lock);
    810021ea:	00006517          	auipc	a0,0x6
    810021ee:	85e50513          	addi	a0,a0,-1954 # 81007a48 <wait_lock>
    810021f2:	aaffe0ef          	jal	81000ca0 <release>
      return -1;
    810021f6:	59fd                	li	s3,-1
    810021f8:	b749                	j	8100217a <wait+0x74>

00000000810021fa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    810021fa:	7179                	addi	sp,sp,-48
    810021fc:	f406                	sd	ra,40(sp)
    810021fe:	f022                	sd	s0,32(sp)
    81002200:	ec26                	sd	s1,24(sp)
    81002202:	e84a                	sd	s2,16(sp)
    81002204:	e44e                	sd	s3,8(sp)
    81002206:	e052                	sd	s4,0(sp)
    81002208:	1800                	addi	s0,sp,48
    8100220a:	84aa                	mv	s1,a0
    8100220c:	892e                	mv	s2,a1
    8100220e:	89b2                	mv	s3,a2
    81002210:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    81002212:	ec4ff0ef          	jal	810018d6 <myproc>
  if(user_dst){
    81002216:	cc99                	beqz	s1,81002234 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    81002218:	86d2                	mv	a3,s4
    8100221a:	864e                	mv	a2,s3
    8100221c:	85ca                	mv	a1,s2
    8100221e:	6928                	ld	a0,80(a0)
    81002220:	b5eff0ef          	jal	8100157e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    81002224:	70a2                	ld	ra,40(sp)
    81002226:	7402                	ld	s0,32(sp)
    81002228:	64e2                	ld	s1,24(sp)
    8100222a:	6942                	ld	s2,16(sp)
    8100222c:	69a2                	ld	s3,8(sp)
    8100222e:	6a02                	ld	s4,0(sp)
    81002230:	6145                	addi	sp,sp,48
    81002232:	8082                	ret
    memmove((char *)dst, src, len);
    81002234:	000a061b          	sext.w	a2,s4
    81002238:	85ce                	mv	a1,s3
    8100223a:	854a                	mv	a0,s2
    8100223c:	b05fe0ef          	jal	81000d40 <memmove>
    return 0;
    81002240:	8526                	mv	a0,s1
    81002242:	b7cd                	j	81002224 <either_copyout+0x2a>

0000000081002244 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    81002244:	7179                	addi	sp,sp,-48
    81002246:	f406                	sd	ra,40(sp)
    81002248:	f022                	sd	s0,32(sp)
    8100224a:	ec26                	sd	s1,24(sp)
    8100224c:	e84a                	sd	s2,16(sp)
    8100224e:	e44e                	sd	s3,8(sp)
    81002250:	e052                	sd	s4,0(sp)
    81002252:	1800                	addi	s0,sp,48
    81002254:	892a                	mv	s2,a0
    81002256:	84ae                	mv	s1,a1
    81002258:	89b2                	mv	s3,a2
    8100225a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8100225c:	e7aff0ef          	jal	810018d6 <myproc>
  if(user_src){
    81002260:	cc99                	beqz	s1,8100227e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    81002262:	86d2                	mv	a3,s4
    81002264:	864e                	mv	a2,s3
    81002266:	85ca                	mv	a1,s2
    81002268:	6928                	ld	a0,80(a0)
    8100226a:	bc4ff0ef          	jal	8100162e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8100226e:	70a2                	ld	ra,40(sp)
    81002270:	7402                	ld	s0,32(sp)
    81002272:	64e2                	ld	s1,24(sp)
    81002274:	6942                	ld	s2,16(sp)
    81002276:	69a2                	ld	s3,8(sp)
    81002278:	6a02                	ld	s4,0(sp)
    8100227a:	6145                	addi	sp,sp,48
    8100227c:	8082                	ret
    memmove(dst, (char*)src, len);
    8100227e:	000a061b          	sext.w	a2,s4
    81002282:	85ce                	mv	a1,s3
    81002284:	854a                	mv	a0,s2
    81002286:	abbfe0ef          	jal	81000d40 <memmove>
    return 0;
    8100228a:	8526                	mv	a0,s1
    8100228c:	b7cd                	j	8100226e <either_copyin+0x2a>

000000008100228e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8100228e:	715d                	addi	sp,sp,-80
    81002290:	e486                	sd	ra,72(sp)
    81002292:	e0a2                	sd	s0,64(sp)
    81002294:	fc26                	sd	s1,56(sp)
    81002296:	f84a                	sd	s2,48(sp)
    81002298:	f44e                	sd	s3,40(sp)
    8100229a:	f052                	sd	s4,32(sp)
    8100229c:	ec56                	sd	s5,24(sp)
    8100229e:	e85a                	sd	s6,16(sp)
    810022a0:	e45e                	sd	s7,8(sp)
    810022a2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    810022a4:	00005517          	auipc	a0,0x5
    810022a8:	ffc50513          	addi	a0,a0,-4 # 810072a0 <etext+0x2a0>
    810022ac:	a2cfe0ef          	jal	810004d8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    810022b0:	00006497          	auipc	s1,0x6
    810022b4:	d0848493          	addi	s1,s1,-760 # 81007fb8 <proc+0x158>
    810022b8:	0000b917          	auipc	s2,0xb
    810022bc:	70090913          	addi	s2,s2,1792 # 8100d9b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    810022c0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    810022c2:	00005997          	auipc	s3,0x5
    810022c6:	fd698993          	addi	s3,s3,-42 # 81007298 <etext+0x298>
    printf("%d %s %s", p->pid, state, p->name);
    810022ca:	00005a97          	auipc	s5,0x5
    810022ce:	fdea8a93          	addi	s5,s5,-34 # 810072a8 <etext+0x2a8>
    printf("\n");
    810022d2:	00005a17          	auipc	s4,0x5
    810022d6:	fcea0a13          	addi	s4,s4,-50 # 810072a0 <etext+0x2a0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    810022da:	00005b97          	auipc	s7,0x5
    810022de:	4aeb8b93          	addi	s7,s7,1198 # 81007788 <states.0>
    810022e2:	a829                	j	810022fc <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    810022e4:	ed86a583          	lw	a1,-296(a3)
    810022e8:	8556                	mv	a0,s5
    810022ea:	9eefe0ef          	jal	810004d8 <printf>
    printf("\n");
    810022ee:	8552                	mv	a0,s4
    810022f0:	9e8fe0ef          	jal	810004d8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    810022f4:	16848493          	addi	s1,s1,360
    810022f8:	03248263          	beq	s1,s2,8100231c <procdump+0x8e>
    if(p->state == UNUSED)
    810022fc:	86a6                	mv	a3,s1
    810022fe:	ec04a783          	lw	a5,-320(s1)
    81002302:	dbed                	beqz	a5,810022f4 <procdump+0x66>
      state = "???";
    81002304:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    81002306:	fcfb6fe3          	bltu	s6,a5,810022e4 <procdump+0x56>
    8100230a:	02079713          	slli	a4,a5,0x20
    8100230e:	01d75793          	srli	a5,a4,0x1d
    81002312:	97de                	add	a5,a5,s7
    81002314:	6390                	ld	a2,0(a5)
    81002316:	f679                	bnez	a2,810022e4 <procdump+0x56>
      state = "???";
    81002318:	864e                	mv	a2,s3
    8100231a:	b7e9                	j	810022e4 <procdump+0x56>
  }
}
    8100231c:	60a6                	ld	ra,72(sp)
    8100231e:	6406                	ld	s0,64(sp)
    81002320:	74e2                	ld	s1,56(sp)
    81002322:	7942                	ld	s2,48(sp)
    81002324:	79a2                	ld	s3,40(sp)
    81002326:	7a02                	ld	s4,32(sp)
    81002328:	6ae2                	ld	s5,24(sp)
    8100232a:	6b42                	ld	s6,16(sp)
    8100232c:	6ba2                	ld	s7,8(sp)
    8100232e:	6161                	addi	sp,sp,80
    81002330:	8082                	ret

0000000081002332 <swtch>:
    81002332:	00153023          	sd	ra,0(a0)
    81002336:	00253423          	sd	sp,8(a0)
    8100233a:	e900                	sd	s0,16(a0)
    8100233c:	ed04                	sd	s1,24(a0)
    8100233e:	03253023          	sd	s2,32(a0)
    81002342:	03353423          	sd	s3,40(a0)
    81002346:	03453823          	sd	s4,48(a0)
    8100234a:	03553c23          	sd	s5,56(a0)
    8100234e:	05653023          	sd	s6,64(a0)
    81002352:	05753423          	sd	s7,72(a0)
    81002356:	05853823          	sd	s8,80(a0)
    8100235a:	05953c23          	sd	s9,88(a0)
    8100235e:	07a53023          	sd	s10,96(a0)
    81002362:	07b53423          	sd	s11,104(a0)
    81002366:	0005b083          	ld	ra,0(a1)
    8100236a:	0085b103          	ld	sp,8(a1)
    8100236e:	6980                	ld	s0,16(a1)
    81002370:	6d84                	ld	s1,24(a1)
    81002372:	0205b903          	ld	s2,32(a1)
    81002376:	0285b983          	ld	s3,40(a1)
    8100237a:	0305ba03          	ld	s4,48(a1)
    8100237e:	0385ba83          	ld	s5,56(a1)
    81002382:	0405bb03          	ld	s6,64(a1)
    81002386:	0485bb83          	ld	s7,72(a1)
    8100238a:	0505bc03          	ld	s8,80(a1)
    8100238e:	0585bc83          	ld	s9,88(a1)
    81002392:	0605bd03          	ld	s10,96(a1)
    81002396:	0685bd83          	ld	s11,104(a1)
    8100239a:	8082                	ret

000000008100239c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8100239c:	1141                	addi	sp,sp,-16
    8100239e:	e406                	sd	ra,8(sp)
    810023a0:	e022                	sd	s0,0(sp)
    810023a2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    810023a4:	00005597          	auipc	a1,0x5
    810023a8:	f4458593          	addi	a1,a1,-188 # 810072e8 <etext+0x2e8>
    810023ac:	0000b517          	auipc	a0,0xb
    810023b0:	4b450513          	addi	a0,a0,1204 # 8100d860 <tickslock>
    810023b4:	fd4fe0ef          	jal	81000b88 <initlock>
}
    810023b8:	60a2                	ld	ra,8(sp)
    810023ba:	6402                	ld	s0,0(sp)
    810023bc:	0141                	addi	sp,sp,16
    810023be:	8082                	ret

00000000810023c0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    810023c0:	1141                	addi	sp,sp,-16
    810023c2:	e406                	sd	ra,8(sp)
    810023c4:	e022                	sd	s0,0(sp)
    810023c6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    810023c8:	00003797          	auipc	a5,0x3
    810023cc:	e4878793          	addi	a5,a5,-440 # 81005210 <kernelvec>
    810023d0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    810023d4:	60a2                	ld	ra,8(sp)
    810023d6:	6402                	ld	s0,0(sp)
    810023d8:	0141                	addi	sp,sp,16
    810023da:	8082                	ret

00000000810023dc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    810023dc:	1141                	addi	sp,sp,-16
    810023de:	e406                	sd	ra,8(sp)
    810023e0:	e022                	sd	s0,0(sp)
    810023e2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    810023e4:	cf2ff0ef          	jal	810018d6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    810023e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    810023ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    810023ee:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    810023f2:	00004697          	auipc	a3,0x4
    810023f6:	c0e68693          	addi	a3,a3,-1010 # 81006000 <_trampoline>
    810023fa:	00004717          	auipc	a4,0x4
    810023fe:	c0670713          	addi	a4,a4,-1018 # 81006000 <_trampoline>
    81002402:	8f15                	sub	a4,a4,a3
    81002404:	040007b7          	lui	a5,0x4000
    81002408:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7d000001>
    8100240a:	07b2                	slli	a5,a5,0xc
    8100240c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8100240e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    81002412:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    81002414:	18002673          	csrr	a2,satp
    81002418:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8100241a:	6d30                	ld	a2,88(a0)
    8100241c:	6138                	ld	a4,64(a0)
    8100241e:	6585                	lui	a1,0x1
    81002420:	972e                	add	a4,a4,a1
    81002422:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    81002424:	6d38                	ld	a4,88(a0)
    81002426:	00000617          	auipc	a2,0x0
    8100242a:	11060613          	addi	a2,a2,272 # 81002536 <usertrap>
    8100242e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    81002430:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    81002432:	8612                	mv	a2,tp
    81002434:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81002436:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8100243a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8100243e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81002442:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    81002446:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    81002448:	6f18                	ld	a4,24(a4)
    8100244a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8100244e:	6928                	ld	a0,80(a0)
    81002450:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    81002452:	00004717          	auipc	a4,0x4
    81002456:	c4a70713          	addi	a4,a4,-950 # 8100609c <userret>
    8100245a:	8f15                	sub	a4,a4,a3
    8100245c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8100245e:	577d                	li	a4,-1
    81002460:	177e                	slli	a4,a4,0x3f
    81002462:	8d59                	or	a0,a0,a4
    81002464:	9782                	jalr	a5
}
    81002466:	60a2                	ld	ra,8(sp)
    81002468:	6402                	ld	s0,0(sp)
    8100246a:	0141                	addi	sp,sp,16
    8100246c:	8082                	ret

000000008100246e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8100246e:	1101                	addi	sp,sp,-32
    81002470:	ec06                	sd	ra,24(sp)
    81002472:	e822                	sd	s0,16(sp)
    81002474:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    81002476:	c2cff0ef          	jal	810018a2 <cpuid>
    8100247a:	cd11                	beqz	a0,81002496 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8100247c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    81002480:	000f4737          	lui	a4,0xf4
    81002484:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x80f0bdc0>
    81002488:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8100248a:	14d79073          	csrw	stimecmp,a5
}
    8100248e:	60e2                	ld	ra,24(sp)
    81002490:	6442                	ld	s0,16(sp)
    81002492:	6105                	addi	sp,sp,32
    81002494:	8082                	ret
    81002496:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    81002498:	0000b497          	auipc	s1,0xb
    8100249c:	3c848493          	addi	s1,s1,968 # 8100d860 <tickslock>
    810024a0:	8526                	mv	a0,s1
    810024a2:	f6afe0ef          	jal	81000c0c <acquire>
    ticks++;
    810024a6:	00005517          	auipc	a0,0x5
    810024aa:	45a50513          	addi	a0,a0,1114 # 81007900 <ticks>
    810024ae:	411c                	lw	a5,0(a0)
    810024b0:	2785                	addiw	a5,a5,1
    810024b2:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    810024b4:	a3dff0ef          	jal	81001ef0 <wakeup>
    release(&tickslock);
    810024b8:	8526                	mv	a0,s1
    810024ba:	fe6fe0ef          	jal	81000ca0 <release>
    810024be:	64a2                	ld	s1,8(sp)
    810024c0:	bf75                	j	8100247c <clockintr+0xe>

00000000810024c2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    810024c2:	1101                	addi	sp,sp,-32
    810024c4:	ec06                	sd	ra,24(sp)
    810024c6:	e822                	sd	s0,16(sp)
    810024c8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    810024ca:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    810024ce:	57fd                	li	a5,-1
    810024d0:	17fe                	slli	a5,a5,0x3f
    810024d2:	07a5                	addi	a5,a5,9
    810024d4:	00f70c63          	beq	a4,a5,810024ec <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    810024d8:	57fd                	li	a5,-1
    810024da:	17fe                	slli	a5,a5,0x3f
    810024dc:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    810024de:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    810024e0:	04f70763          	beq	a4,a5,8100252e <devintr+0x6c>
  }
}
    810024e4:	60e2                	ld	ra,24(sp)
    810024e6:	6442                	ld	s0,16(sp)
    810024e8:	6105                	addi	sp,sp,32
    810024ea:	8082                	ret
    810024ec:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    810024ee:	5cf020ef          	jal	810052bc <plic_claim>
    810024f2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    810024f4:	47a9                	li	a5,10
    810024f6:	00f50963          	beq	a0,a5,81002508 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    810024fa:	4785                	li	a5,1
    810024fc:	00f50963          	beq	a0,a5,8100250e <devintr+0x4c>
    return 1;
    81002500:	4505                	li	a0,1
    } else if(irq){
    81002502:	e889                	bnez	s1,81002514 <devintr+0x52>
    81002504:	64a2                	ld	s1,8(sp)
    81002506:	bff9                	j	810024e4 <devintr+0x22>
      uartintr();
    81002508:	d0efe0ef          	jal	81000a16 <uartintr>
    if(irq)
    8100250c:	a819                	j	81002522 <devintr+0x60>
      virtio_disk_intr();
    8100250e:	23e030ef          	jal	8100574c <virtio_disk_intr>
    if(irq)
    81002512:	a801                	j	81002522 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    81002514:	85a6                	mv	a1,s1
    81002516:	00005517          	auipc	a0,0x5
    8100251a:	dda50513          	addi	a0,a0,-550 # 810072f0 <etext+0x2f0>
    8100251e:	fbbfd0ef          	jal	810004d8 <printf>
      plic_complete(irq);
    81002522:	8526                	mv	a0,s1
    81002524:	5b9020ef          	jal	810052dc <plic_complete>
    return 1;
    81002528:	4505                	li	a0,1
    8100252a:	64a2                	ld	s1,8(sp)
    8100252c:	bf65                	j	810024e4 <devintr+0x22>
    clockintr();
    8100252e:	f41ff0ef          	jal	8100246e <clockintr>
    return 2;
    81002532:	4509                	li	a0,2
    81002534:	bf45                	j	810024e4 <devintr+0x22>

0000000081002536 <usertrap>:
{
    81002536:	1101                	addi	sp,sp,-32
    81002538:	ec06                	sd	ra,24(sp)
    8100253a:	e822                	sd	s0,16(sp)
    8100253c:	e426                	sd	s1,8(sp)
    8100253e:	e04a                	sd	s2,0(sp)
    81002540:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81002542:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    81002546:	1007f793          	andi	a5,a5,256
    8100254a:	ef85                	bnez	a5,81002582 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8100254c:	00003797          	auipc	a5,0x3
    81002550:	cc478793          	addi	a5,a5,-828 # 81005210 <kernelvec>
    81002554:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    81002558:	b7eff0ef          	jal	810018d6 <myproc>
    8100255c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8100255e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    81002560:	14102773          	csrr	a4,sepc
    81002564:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    81002566:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8100256a:	47a1                	li	a5,8
    8100256c:	02f70163          	beq	a4,a5,8100258e <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    81002570:	f53ff0ef          	jal	810024c2 <devintr>
    81002574:	892a                	mv	s2,a0
    81002576:	c135                	beqz	a0,810025da <usertrap+0xa4>
  if(killed(p))
    81002578:	8526                	mv	a0,s1
    8100257a:	b63ff0ef          	jal	810020dc <killed>
    8100257e:	cd1d                	beqz	a0,810025bc <usertrap+0x86>
    81002580:	a81d                	j	810025b6 <usertrap+0x80>
    panic("usertrap: not from user mode");
    81002582:	00005517          	auipc	a0,0x5
    81002586:	d8e50513          	addi	a0,a0,-626 # 81007310 <etext+0x310>
    8100258a:	a1efe0ef          	jal	810007a8 <panic>
    if(killed(p))
    8100258e:	b4fff0ef          	jal	810020dc <killed>
    81002592:	e121                	bnez	a0,810025d2 <usertrap+0x9c>
    p->trapframe->epc += 4;
    81002594:	6cb8                	ld	a4,88(s1)
    81002596:	6f1c                	ld	a5,24(a4)
    81002598:	0791                	addi	a5,a5,4
    8100259a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8100259c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    810025a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    810025a4:	10079073          	csrw	sstatus,a5
    syscall();
    810025a8:	240000ef          	jal	810027e8 <syscall>
  if(killed(p))
    810025ac:	8526                	mv	a0,s1
    810025ae:	b2fff0ef          	jal	810020dc <killed>
    810025b2:	c901                	beqz	a0,810025c2 <usertrap+0x8c>
    810025b4:	4901                	li	s2,0
    exit(-1);
    810025b6:	557d                	li	a0,-1
    810025b8:	9f9ff0ef          	jal	81001fb0 <exit>
  if(which_dev == 2)
    810025bc:	4789                	li	a5,2
    810025be:	04f90563          	beq	s2,a5,81002608 <usertrap+0xd2>
  usertrapret();
    810025c2:	e1bff0ef          	jal	810023dc <usertrapret>
}
    810025c6:	60e2                	ld	ra,24(sp)
    810025c8:	6442                	ld	s0,16(sp)
    810025ca:	64a2                	ld	s1,8(sp)
    810025cc:	6902                	ld	s2,0(sp)
    810025ce:	6105                	addi	sp,sp,32
    810025d0:	8082                	ret
      exit(-1);
    810025d2:	557d                	li	a0,-1
    810025d4:	9ddff0ef          	jal	81001fb0 <exit>
    810025d8:	bf75                	j	81002594 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    810025da:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    810025de:	5890                	lw	a2,48(s1)
    810025e0:	00005517          	auipc	a0,0x5
    810025e4:	d5050513          	addi	a0,a0,-688 # 81007330 <etext+0x330>
    810025e8:	ef1fd0ef          	jal	810004d8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    810025ec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    810025f0:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    810025f4:	00005517          	auipc	a0,0x5
    810025f8:	d6c50513          	addi	a0,a0,-660 # 81007360 <etext+0x360>
    810025fc:	eddfd0ef          	jal	810004d8 <printf>
    setkilled(p);
    81002600:	8526                	mv	a0,s1
    81002602:	ab7ff0ef          	jal	810020b8 <setkilled>
    81002606:	b75d                	j	810025ac <usertrap+0x76>
    yield();
    81002608:	871ff0ef          	jal	81001e78 <yield>
    8100260c:	bf5d                	j	810025c2 <usertrap+0x8c>

000000008100260e <kerneltrap>:
{
    8100260e:	7179                	addi	sp,sp,-48
    81002610:	f406                	sd	ra,40(sp)
    81002612:	f022                	sd	s0,32(sp)
    81002614:	ec26                	sd	s1,24(sp)
    81002616:	e84a                	sd	s2,16(sp)
    81002618:	e44e                	sd	s3,8(sp)
    8100261a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8100261c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81002620:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    81002624:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    81002628:	1004f793          	andi	a5,s1,256
    8100262c:	c795                	beqz	a5,81002658 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8100262e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    81002632:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    81002634:	eb85                	bnez	a5,81002664 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    81002636:	e8dff0ef          	jal	810024c2 <devintr>
    8100263a:	c91d                	beqz	a0,81002670 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8100263c:	4789                	li	a5,2
    8100263e:	04f50a63          	beq	a0,a5,81002692 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    81002642:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81002646:	10049073          	csrw	sstatus,s1
}
    8100264a:	70a2                	ld	ra,40(sp)
    8100264c:	7402                	ld	s0,32(sp)
    8100264e:	64e2                	ld	s1,24(sp)
    81002650:	6942                	ld	s2,16(sp)
    81002652:	69a2                	ld	s3,8(sp)
    81002654:	6145                	addi	sp,sp,48
    81002656:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    81002658:	00005517          	auipc	a0,0x5
    8100265c:	d3050513          	addi	a0,a0,-720 # 81007388 <etext+0x388>
    81002660:	948fe0ef          	jal	810007a8 <panic>
    panic("kerneltrap: interrupts enabled");
    81002664:	00005517          	auipc	a0,0x5
    81002668:	d4c50513          	addi	a0,a0,-692 # 810073b0 <etext+0x3b0>
    8100266c:	93cfe0ef          	jal	810007a8 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    81002670:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    81002674:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    81002678:	85ce                	mv	a1,s3
    8100267a:	00005517          	auipc	a0,0x5
    8100267e:	d5650513          	addi	a0,a0,-682 # 810073d0 <etext+0x3d0>
    81002682:	e57fd0ef          	jal	810004d8 <printf>
    panic("kerneltrap");
    81002686:	00005517          	auipc	a0,0x5
    8100268a:	d7250513          	addi	a0,a0,-654 # 810073f8 <etext+0x3f8>
    8100268e:	91afe0ef          	jal	810007a8 <panic>
  if(which_dev == 2 && myproc() != 0)
    81002692:	a44ff0ef          	jal	810018d6 <myproc>
    81002696:	d555                	beqz	a0,81002642 <kerneltrap+0x34>
    yield();
    81002698:	fe0ff0ef          	jal	81001e78 <yield>
    8100269c:	b75d                	j	81002642 <kerneltrap+0x34>

000000008100269e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8100269e:	1101                	addi	sp,sp,-32
    810026a0:	ec06                	sd	ra,24(sp)
    810026a2:	e822                	sd	s0,16(sp)
    810026a4:	e426                	sd	s1,8(sp)
    810026a6:	1000                	addi	s0,sp,32
    810026a8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    810026aa:	a2cff0ef          	jal	810018d6 <myproc>
  switch (n) {
    810026ae:	4795                	li	a5,5
    810026b0:	0497e163          	bltu	a5,s1,810026f2 <argraw+0x54>
    810026b4:	048a                	slli	s1,s1,0x2
    810026b6:	00005717          	auipc	a4,0x5
    810026ba:	10270713          	addi	a4,a4,258 # 810077b8 <states.0+0x30>
    810026be:	94ba                	add	s1,s1,a4
    810026c0:	409c                	lw	a5,0(s1)
    810026c2:	97ba                	add	a5,a5,a4
    810026c4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    810026c6:	6d3c                	ld	a5,88(a0)
    810026c8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    810026ca:	60e2                	ld	ra,24(sp)
    810026cc:	6442                	ld	s0,16(sp)
    810026ce:	64a2                	ld	s1,8(sp)
    810026d0:	6105                	addi	sp,sp,32
    810026d2:	8082                	ret
    return p->trapframe->a1;
    810026d4:	6d3c                	ld	a5,88(a0)
    810026d6:	7fa8                	ld	a0,120(a5)
    810026d8:	bfcd                	j	810026ca <argraw+0x2c>
    return p->trapframe->a2;
    810026da:	6d3c                	ld	a5,88(a0)
    810026dc:	63c8                	ld	a0,128(a5)
    810026de:	b7f5                	j	810026ca <argraw+0x2c>
    return p->trapframe->a3;
    810026e0:	6d3c                	ld	a5,88(a0)
    810026e2:	67c8                	ld	a0,136(a5)
    810026e4:	b7dd                	j	810026ca <argraw+0x2c>
    return p->trapframe->a4;
    810026e6:	6d3c                	ld	a5,88(a0)
    810026e8:	6bc8                	ld	a0,144(a5)
    810026ea:	b7c5                	j	810026ca <argraw+0x2c>
    return p->trapframe->a5;
    810026ec:	6d3c                	ld	a5,88(a0)
    810026ee:	6fc8                	ld	a0,152(a5)
    810026f0:	bfe9                	j	810026ca <argraw+0x2c>
  panic("argraw");
    810026f2:	00005517          	auipc	a0,0x5
    810026f6:	d1650513          	addi	a0,a0,-746 # 81007408 <etext+0x408>
    810026fa:	8aefe0ef          	jal	810007a8 <panic>

00000000810026fe <fetchaddr>:
{
    810026fe:	1101                	addi	sp,sp,-32
    81002700:	ec06                	sd	ra,24(sp)
    81002702:	e822                	sd	s0,16(sp)
    81002704:	e426                	sd	s1,8(sp)
    81002706:	e04a                	sd	s2,0(sp)
    81002708:	1000                	addi	s0,sp,32
    8100270a:	84aa                	mv	s1,a0
    8100270c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8100270e:	9c8ff0ef          	jal	810018d6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    81002712:	653c                	ld	a5,72(a0)
    81002714:	02f4f663          	bgeu	s1,a5,81002740 <fetchaddr+0x42>
    81002718:	00848713          	addi	a4,s1,8
    8100271c:	02e7e463          	bltu	a5,a4,81002744 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    81002720:	46a1                	li	a3,8
    81002722:	8626                	mv	a2,s1
    81002724:	85ca                	mv	a1,s2
    81002726:	6928                	ld	a0,80(a0)
    81002728:	f07fe0ef          	jal	8100162e <copyin>
    8100272c:	00a03533          	snez	a0,a0
    81002730:	40a0053b          	negw	a0,a0
}
    81002734:	60e2                	ld	ra,24(sp)
    81002736:	6442                	ld	s0,16(sp)
    81002738:	64a2                	ld	s1,8(sp)
    8100273a:	6902                	ld	s2,0(sp)
    8100273c:	6105                	addi	sp,sp,32
    8100273e:	8082                	ret
    return -1;
    81002740:	557d                	li	a0,-1
    81002742:	bfcd                	j	81002734 <fetchaddr+0x36>
    81002744:	557d                	li	a0,-1
    81002746:	b7fd                	j	81002734 <fetchaddr+0x36>

0000000081002748 <fetchstr>:
{
    81002748:	7179                	addi	sp,sp,-48
    8100274a:	f406                	sd	ra,40(sp)
    8100274c:	f022                	sd	s0,32(sp)
    8100274e:	ec26                	sd	s1,24(sp)
    81002750:	e84a                	sd	s2,16(sp)
    81002752:	e44e                	sd	s3,8(sp)
    81002754:	1800                	addi	s0,sp,48
    81002756:	892a                	mv	s2,a0
    81002758:	84ae                	mv	s1,a1
    8100275a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8100275c:	97aff0ef          	jal	810018d6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    81002760:	86ce                	mv	a3,s3
    81002762:	864a                	mv	a2,s2
    81002764:	85a6                	mv	a1,s1
    81002766:	6928                	ld	a0,80(a0)
    81002768:	f4dfe0ef          	jal	810016b4 <copyinstr>
    8100276c:	00054c63          	bltz	a0,81002784 <fetchstr+0x3c>
  return strlen(buf);
    81002770:	8526                	mv	a0,s1
    81002772:	ef2fe0ef          	jal	81000e64 <strlen>
}
    81002776:	70a2                	ld	ra,40(sp)
    81002778:	7402                	ld	s0,32(sp)
    8100277a:	64e2                	ld	s1,24(sp)
    8100277c:	6942                	ld	s2,16(sp)
    8100277e:	69a2                	ld	s3,8(sp)
    81002780:	6145                	addi	sp,sp,48
    81002782:	8082                	ret
    return -1;
    81002784:	557d                	li	a0,-1
    81002786:	bfc5                	j	81002776 <fetchstr+0x2e>

0000000081002788 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    81002788:	1101                	addi	sp,sp,-32
    8100278a:	ec06                	sd	ra,24(sp)
    8100278c:	e822                	sd	s0,16(sp)
    8100278e:	e426                	sd	s1,8(sp)
    81002790:	1000                	addi	s0,sp,32
    81002792:	84ae                	mv	s1,a1
  *ip = argraw(n);
    81002794:	f0bff0ef          	jal	8100269e <argraw>
    81002798:	c088                	sw	a0,0(s1)
}
    8100279a:	60e2                	ld	ra,24(sp)
    8100279c:	6442                	ld	s0,16(sp)
    8100279e:	64a2                	ld	s1,8(sp)
    810027a0:	6105                	addi	sp,sp,32
    810027a2:	8082                	ret

00000000810027a4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    810027a4:	1101                	addi	sp,sp,-32
    810027a6:	ec06                	sd	ra,24(sp)
    810027a8:	e822                	sd	s0,16(sp)
    810027aa:	e426                	sd	s1,8(sp)
    810027ac:	1000                	addi	s0,sp,32
    810027ae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    810027b0:	eefff0ef          	jal	8100269e <argraw>
    810027b4:	e088                	sd	a0,0(s1)
}
    810027b6:	60e2                	ld	ra,24(sp)
    810027b8:	6442                	ld	s0,16(sp)
    810027ba:	64a2                	ld	s1,8(sp)
    810027bc:	6105                	addi	sp,sp,32
    810027be:	8082                	ret

00000000810027c0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    810027c0:	1101                	addi	sp,sp,-32
    810027c2:	ec06                	sd	ra,24(sp)
    810027c4:	e822                	sd	s0,16(sp)
    810027c6:	e426                	sd	s1,8(sp)
    810027c8:	e04a                	sd	s2,0(sp)
    810027ca:	1000                	addi	s0,sp,32
    810027cc:	84ae                	mv	s1,a1
    810027ce:	8932                	mv	s2,a2
  *ip = argraw(n);
    810027d0:	ecfff0ef          	jal	8100269e <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    810027d4:	864a                	mv	a2,s2
    810027d6:	85a6                	mv	a1,s1
    810027d8:	f71ff0ef          	jal	81002748 <fetchstr>
}
    810027dc:	60e2                	ld	ra,24(sp)
    810027de:	6442                	ld	s0,16(sp)
    810027e0:	64a2                	ld	s1,8(sp)
    810027e2:	6902                	ld	s2,0(sp)
    810027e4:	6105                	addi	sp,sp,32
    810027e6:	8082                	ret

00000000810027e8 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    810027e8:	1101                	addi	sp,sp,-32
    810027ea:	ec06                	sd	ra,24(sp)
    810027ec:	e822                	sd	s0,16(sp)
    810027ee:	e426                	sd	s1,8(sp)
    810027f0:	e04a                	sd	s2,0(sp)
    810027f2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    810027f4:	8e2ff0ef          	jal	810018d6 <myproc>
    810027f8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    810027fa:	05853903          	ld	s2,88(a0)
    810027fe:	0a893783          	ld	a5,168(s2)
    81002802:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    81002806:	37fd                	addiw	a5,a5,-1
    81002808:	4751                	li	a4,20
    8100280a:	00f76f63          	bltu	a4,a5,81002828 <syscall+0x40>
    8100280e:	00369713          	slli	a4,a3,0x3
    81002812:	00005797          	auipc	a5,0x5
    81002816:	fbe78793          	addi	a5,a5,-66 # 810077d0 <syscalls>
    8100281a:	97ba                	add	a5,a5,a4
    8100281c:	639c                	ld	a5,0(a5)
    8100281e:	c789                	beqz	a5,81002828 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    81002820:	9782                	jalr	a5
    81002822:	06a93823          	sd	a0,112(s2)
    81002826:	a829                	j	81002840 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    81002828:	15848613          	addi	a2,s1,344
    8100282c:	588c                	lw	a1,48(s1)
    8100282e:	00005517          	auipc	a0,0x5
    81002832:	be250513          	addi	a0,a0,-1054 # 81007410 <etext+0x410>
    81002836:	ca3fd0ef          	jal	810004d8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8100283a:	6cbc                	ld	a5,88(s1)
    8100283c:	577d                	li	a4,-1
    8100283e:	fbb8                	sd	a4,112(a5)
  }
}
    81002840:	60e2                	ld	ra,24(sp)
    81002842:	6442                	ld	s0,16(sp)
    81002844:	64a2                	ld	s1,8(sp)
    81002846:	6902                	ld	s2,0(sp)
    81002848:	6105                	addi	sp,sp,32
    8100284a:	8082                	ret

000000008100284c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8100284c:	1101                	addi	sp,sp,-32
    8100284e:	ec06                	sd	ra,24(sp)
    81002850:	e822                	sd	s0,16(sp)
    81002852:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    81002854:	fec40593          	addi	a1,s0,-20
    81002858:	4501                	li	a0,0
    8100285a:	f2fff0ef          	jal	81002788 <argint>
  exit(n);
    8100285e:	fec42503          	lw	a0,-20(s0)
    81002862:	f4eff0ef          	jal	81001fb0 <exit>
  return 0;  // not reached
}
    81002866:	4501                	li	a0,0
    81002868:	60e2                	ld	ra,24(sp)
    8100286a:	6442                	ld	s0,16(sp)
    8100286c:	6105                	addi	sp,sp,32
    8100286e:	8082                	ret

0000000081002870 <sys_getpid>:

uint64
sys_getpid(void)
{
    81002870:	1141                	addi	sp,sp,-16
    81002872:	e406                	sd	ra,8(sp)
    81002874:	e022                	sd	s0,0(sp)
    81002876:	0800                	addi	s0,sp,16
  return myproc()->pid;
    81002878:	85eff0ef          	jal	810018d6 <myproc>
}
    8100287c:	5908                	lw	a0,48(a0)
    8100287e:	60a2                	ld	ra,8(sp)
    81002880:	6402                	ld	s0,0(sp)
    81002882:	0141                	addi	sp,sp,16
    81002884:	8082                	ret

0000000081002886 <sys_fork>:

uint64
sys_fork(void)
{
    81002886:	1141                	addi	sp,sp,-16
    81002888:	e406                	sd	ra,8(sp)
    8100288a:	e022                	sd	s0,0(sp)
    8100288c:	0800                	addi	s0,sp,16
  return fork();
    8100288e:	b6eff0ef          	jal	81001bfc <fork>
}
    81002892:	60a2                	ld	ra,8(sp)
    81002894:	6402                	ld	s0,0(sp)
    81002896:	0141                	addi	sp,sp,16
    81002898:	8082                	ret

000000008100289a <sys_wait>:

uint64
sys_wait(void)
{
    8100289a:	1101                	addi	sp,sp,-32
    8100289c:	ec06                	sd	ra,24(sp)
    8100289e:	e822                	sd	s0,16(sp)
    810028a0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    810028a2:	fe840593          	addi	a1,s0,-24
    810028a6:	4501                	li	a0,0
    810028a8:	efdff0ef          	jal	810027a4 <argaddr>
  return wait(p);
    810028ac:	fe843503          	ld	a0,-24(s0)
    810028b0:	857ff0ef          	jal	81002106 <wait>
}
    810028b4:	60e2                	ld	ra,24(sp)
    810028b6:	6442                	ld	s0,16(sp)
    810028b8:	6105                	addi	sp,sp,32
    810028ba:	8082                	ret

00000000810028bc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    810028bc:	7179                	addi	sp,sp,-48
    810028be:	f406                	sd	ra,40(sp)
    810028c0:	f022                	sd	s0,32(sp)
    810028c2:	ec26                	sd	s1,24(sp)
    810028c4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    810028c6:	fdc40593          	addi	a1,s0,-36
    810028ca:	4501                	li	a0,0
    810028cc:	ebdff0ef          	jal	81002788 <argint>
  addr = myproc()->sz;
    810028d0:	806ff0ef          	jal	810018d6 <myproc>
    810028d4:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    810028d6:	fdc42503          	lw	a0,-36(s0)
    810028da:	ad2ff0ef          	jal	81001bac <growproc>
    810028de:	00054863          	bltz	a0,810028ee <sys_sbrk+0x32>
    return -1;
  return addr;
}
    810028e2:	8526                	mv	a0,s1
    810028e4:	70a2                	ld	ra,40(sp)
    810028e6:	7402                	ld	s0,32(sp)
    810028e8:	64e2                	ld	s1,24(sp)
    810028ea:	6145                	addi	sp,sp,48
    810028ec:	8082                	ret
    return -1;
    810028ee:	54fd                	li	s1,-1
    810028f0:	bfcd                	j	810028e2 <sys_sbrk+0x26>

00000000810028f2 <sys_sleep>:

uint64
sys_sleep(void)
{
    810028f2:	7139                	addi	sp,sp,-64
    810028f4:	fc06                	sd	ra,56(sp)
    810028f6:	f822                	sd	s0,48(sp)
    810028f8:	f04a                	sd	s2,32(sp)
    810028fa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    810028fc:	fcc40593          	addi	a1,s0,-52
    81002900:	4501                	li	a0,0
    81002902:	e87ff0ef          	jal	81002788 <argint>
  if(n < 0)
    81002906:	fcc42783          	lw	a5,-52(s0)
    8100290a:	0607c763          	bltz	a5,81002978 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8100290e:	0000b517          	auipc	a0,0xb
    81002912:	f5250513          	addi	a0,a0,-174 # 8100d860 <tickslock>
    81002916:	af6fe0ef          	jal	81000c0c <acquire>
  ticks0 = ticks;
    8100291a:	00005917          	auipc	s2,0x5
    8100291e:	fe692903          	lw	s2,-26(s2) # 81007900 <ticks>
  while(ticks - ticks0 < n){
    81002922:	fcc42783          	lw	a5,-52(s0)
    81002926:	cf8d                	beqz	a5,81002960 <sys_sleep+0x6e>
    81002928:	f426                	sd	s1,40(sp)
    8100292a:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8100292c:	0000b997          	auipc	s3,0xb
    81002930:	f3498993          	addi	s3,s3,-204 # 8100d860 <tickslock>
    81002934:	00005497          	auipc	s1,0x5
    81002938:	fcc48493          	addi	s1,s1,-52 # 81007900 <ticks>
    if(killed(myproc())){
    8100293c:	f9bfe0ef          	jal	810018d6 <myproc>
    81002940:	f9cff0ef          	jal	810020dc <killed>
    81002944:	ed0d                	bnez	a0,8100297e <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    81002946:	85ce                	mv	a1,s3
    81002948:	8526                	mv	a0,s1
    8100294a:	d5aff0ef          	jal	81001ea4 <sleep>
  while(ticks - ticks0 < n){
    8100294e:	409c                	lw	a5,0(s1)
    81002950:	412787bb          	subw	a5,a5,s2
    81002954:	fcc42703          	lw	a4,-52(s0)
    81002958:	fee7e2e3          	bltu	a5,a4,8100293c <sys_sleep+0x4a>
    8100295c:	74a2                	ld	s1,40(sp)
    8100295e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    81002960:	0000b517          	auipc	a0,0xb
    81002964:	f0050513          	addi	a0,a0,-256 # 8100d860 <tickslock>
    81002968:	b38fe0ef          	jal	81000ca0 <release>
  return 0;
    8100296c:	4501                	li	a0,0
}
    8100296e:	70e2                	ld	ra,56(sp)
    81002970:	7442                	ld	s0,48(sp)
    81002972:	7902                	ld	s2,32(sp)
    81002974:	6121                	addi	sp,sp,64
    81002976:	8082                	ret
    n = 0;
    81002978:	fc042623          	sw	zero,-52(s0)
    8100297c:	bf49                	j	8100290e <sys_sleep+0x1c>
      release(&tickslock);
    8100297e:	0000b517          	auipc	a0,0xb
    81002982:	ee250513          	addi	a0,a0,-286 # 8100d860 <tickslock>
    81002986:	b1afe0ef          	jal	81000ca0 <release>
      return -1;
    8100298a:	557d                	li	a0,-1
    8100298c:	74a2                	ld	s1,40(sp)
    8100298e:	69e2                	ld	s3,24(sp)
    81002990:	bff9                	j	8100296e <sys_sleep+0x7c>

0000000081002992 <sys_kill>:

uint64
sys_kill(void)
{
    81002992:	1101                	addi	sp,sp,-32
    81002994:	ec06                	sd	ra,24(sp)
    81002996:	e822                	sd	s0,16(sp)
    81002998:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8100299a:	fec40593          	addi	a1,s0,-20
    8100299e:	4501                	li	a0,0
    810029a0:	de9ff0ef          	jal	81002788 <argint>
  return kill(pid);
    810029a4:	fec42503          	lw	a0,-20(s0)
    810029a8:	eaaff0ef          	jal	81002052 <kill>
}
    810029ac:	60e2                	ld	ra,24(sp)
    810029ae:	6442                	ld	s0,16(sp)
    810029b0:	6105                	addi	sp,sp,32
    810029b2:	8082                	ret

00000000810029b4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    810029b4:	1101                	addi	sp,sp,-32
    810029b6:	ec06                	sd	ra,24(sp)
    810029b8:	e822                	sd	s0,16(sp)
    810029ba:	e426                	sd	s1,8(sp)
    810029bc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    810029be:	0000b517          	auipc	a0,0xb
    810029c2:	ea250513          	addi	a0,a0,-350 # 8100d860 <tickslock>
    810029c6:	a46fe0ef          	jal	81000c0c <acquire>
  xticks = ticks;
    810029ca:	00005497          	auipc	s1,0x5
    810029ce:	f364a483          	lw	s1,-202(s1) # 81007900 <ticks>
  release(&tickslock);
    810029d2:	0000b517          	auipc	a0,0xb
    810029d6:	e8e50513          	addi	a0,a0,-370 # 8100d860 <tickslock>
    810029da:	ac6fe0ef          	jal	81000ca0 <release>
  return xticks;
}
    810029de:	02049513          	slli	a0,s1,0x20
    810029e2:	9101                	srli	a0,a0,0x20
    810029e4:	60e2                	ld	ra,24(sp)
    810029e6:	6442                	ld	s0,16(sp)
    810029e8:	64a2                	ld	s1,8(sp)
    810029ea:	6105                	addi	sp,sp,32
    810029ec:	8082                	ret

00000000810029ee <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    810029ee:	7179                	addi	sp,sp,-48
    810029f0:	f406                	sd	ra,40(sp)
    810029f2:	f022                	sd	s0,32(sp)
    810029f4:	ec26                	sd	s1,24(sp)
    810029f6:	e84a                	sd	s2,16(sp)
    810029f8:	e44e                	sd	s3,8(sp)
    810029fa:	e052                	sd	s4,0(sp)
    810029fc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    810029fe:	00005597          	auipc	a1,0x5
    81002a02:	a3258593          	addi	a1,a1,-1486 # 81007430 <etext+0x430>
    81002a06:	0000b517          	auipc	a0,0xb
    81002a0a:	e7250513          	addi	a0,a0,-398 # 8100d878 <bcache>
    81002a0e:	97afe0ef          	jal	81000b88 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    81002a12:	00013797          	auipc	a5,0x13
    81002a16:	e6678793          	addi	a5,a5,-410 # 81015878 <bcache+0x8000>
    81002a1a:	00013717          	auipc	a4,0x13
    81002a1e:	0c670713          	addi	a4,a4,198 # 81015ae0 <bcache+0x8268>
    81002a22:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    81002a26:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    81002a2a:	0000b497          	auipc	s1,0xb
    81002a2e:	e6648493          	addi	s1,s1,-410 # 8100d890 <bcache+0x18>
    b->next = bcache.head.next;
    81002a32:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    81002a34:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    81002a36:	00005a17          	auipc	s4,0x5
    81002a3a:	a02a0a13          	addi	s4,s4,-1534 # 81007438 <etext+0x438>
    b->next = bcache.head.next;
    81002a3e:	2b893783          	ld	a5,696(s2)
    81002a42:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    81002a44:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    81002a48:	85d2                	mv	a1,s4
    81002a4a:	01048513          	addi	a0,s1,16
    81002a4e:	244010ef          	jal	81003c92 <initsleeplock>
    bcache.head.next->prev = b;
    81002a52:	2b893783          	ld	a5,696(s2)
    81002a56:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    81002a58:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    81002a5c:	45848493          	addi	s1,s1,1112
    81002a60:	fd349fe3          	bne	s1,s3,81002a3e <binit+0x50>
  }
}
    81002a64:	70a2                	ld	ra,40(sp)
    81002a66:	7402                	ld	s0,32(sp)
    81002a68:	64e2                	ld	s1,24(sp)
    81002a6a:	6942                	ld	s2,16(sp)
    81002a6c:	69a2                	ld	s3,8(sp)
    81002a6e:	6a02                	ld	s4,0(sp)
    81002a70:	6145                	addi	sp,sp,48
    81002a72:	8082                	ret

0000000081002a74 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    81002a74:	7179                	addi	sp,sp,-48
    81002a76:	f406                	sd	ra,40(sp)
    81002a78:	f022                	sd	s0,32(sp)
    81002a7a:	ec26                	sd	s1,24(sp)
    81002a7c:	e84a                	sd	s2,16(sp)
    81002a7e:	e44e                	sd	s3,8(sp)
    81002a80:	1800                	addi	s0,sp,48
    81002a82:	892a                	mv	s2,a0
    81002a84:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    81002a86:	0000b517          	auipc	a0,0xb
    81002a8a:	df250513          	addi	a0,a0,-526 # 8100d878 <bcache>
    81002a8e:	97efe0ef          	jal	81000c0c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    81002a92:	00013497          	auipc	s1,0x13
    81002a96:	09e4b483          	ld	s1,158(s1) # 81015b30 <bcache+0x82b8>
    81002a9a:	00013797          	auipc	a5,0x13
    81002a9e:	04678793          	addi	a5,a5,70 # 81015ae0 <bcache+0x8268>
    81002aa2:	02f48b63          	beq	s1,a5,81002ad8 <bread+0x64>
    81002aa6:	873e                	mv	a4,a5
    81002aa8:	a021                	j	81002ab0 <bread+0x3c>
    81002aaa:	68a4                	ld	s1,80(s1)
    81002aac:	02e48663          	beq	s1,a4,81002ad8 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    81002ab0:	449c                	lw	a5,8(s1)
    81002ab2:	ff279ce3          	bne	a5,s2,81002aaa <bread+0x36>
    81002ab6:	44dc                	lw	a5,12(s1)
    81002ab8:	ff3799e3          	bne	a5,s3,81002aaa <bread+0x36>
      b->refcnt++;
    81002abc:	40bc                	lw	a5,64(s1)
    81002abe:	2785                	addiw	a5,a5,1
    81002ac0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    81002ac2:	0000b517          	auipc	a0,0xb
    81002ac6:	db650513          	addi	a0,a0,-586 # 8100d878 <bcache>
    81002aca:	9d6fe0ef          	jal	81000ca0 <release>
      acquiresleep(&b->lock);
    81002ace:	01048513          	addi	a0,s1,16
    81002ad2:	1f6010ef          	jal	81003cc8 <acquiresleep>
      return b;
    81002ad6:	a889                	j	81002b28 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    81002ad8:	00013497          	auipc	s1,0x13
    81002adc:	0504b483          	ld	s1,80(s1) # 81015b28 <bcache+0x82b0>
    81002ae0:	00013797          	auipc	a5,0x13
    81002ae4:	00078793          	mv	a5,a5
    81002ae8:	00f48863          	beq	s1,a5,81002af8 <bread+0x84>
    81002aec:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    81002aee:	40bc                	lw	a5,64(s1)
    81002af0:	cb91                	beqz	a5,81002b04 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    81002af2:	64a4                	ld	s1,72(s1)
    81002af4:	fee49de3          	bne	s1,a4,81002aee <bread+0x7a>
  panic("bget: no buffers");
    81002af8:	00005517          	auipc	a0,0x5
    81002afc:	94850513          	addi	a0,a0,-1720 # 81007440 <etext+0x440>
    81002b00:	ca9fd0ef          	jal	810007a8 <panic>
      b->dev = dev;
    81002b04:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    81002b08:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    81002b0c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    81002b10:	4785                	li	a5,1
    81002b12:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    81002b14:	0000b517          	auipc	a0,0xb
    81002b18:	d6450513          	addi	a0,a0,-668 # 8100d878 <bcache>
    81002b1c:	984fe0ef          	jal	81000ca0 <release>
      acquiresleep(&b->lock);
    81002b20:	01048513          	addi	a0,s1,16
    81002b24:	1a4010ef          	jal	81003cc8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    81002b28:	409c                	lw	a5,0(s1)
    81002b2a:	cb89                	beqz	a5,81002b3c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    81002b2c:	8526                	mv	a0,s1
    81002b2e:	70a2                	ld	ra,40(sp)
    81002b30:	7402                	ld	s0,32(sp)
    81002b32:	64e2                	ld	s1,24(sp)
    81002b34:	6942                	ld	s2,16(sp)
    81002b36:	69a2                	ld	s3,8(sp)
    81002b38:	6145                	addi	sp,sp,48
    81002b3a:	8082                	ret
    virtio_disk_rw(b, 0);
    81002b3c:	4581                	li	a1,0
    81002b3e:	8526                	mv	a0,s1
    81002b40:	201020ef          	jal	81005540 <virtio_disk_rw>
    b->valid = 1;
    81002b44:	4785                	li	a5,1
    81002b46:	c09c                	sw	a5,0(s1)
  return b;
    81002b48:	b7d5                	j	81002b2c <bread+0xb8>

0000000081002b4a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    81002b4a:	1101                	addi	sp,sp,-32
    81002b4c:	ec06                	sd	ra,24(sp)
    81002b4e:	e822                	sd	s0,16(sp)
    81002b50:	e426                	sd	s1,8(sp)
    81002b52:	1000                	addi	s0,sp,32
    81002b54:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    81002b56:	0541                	addi	a0,a0,16
    81002b58:	1ee010ef          	jal	81003d46 <holdingsleep>
    81002b5c:	c911                	beqz	a0,81002b70 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    81002b5e:	4585                	li	a1,1
    81002b60:	8526                	mv	a0,s1
    81002b62:	1df020ef          	jal	81005540 <virtio_disk_rw>
}
    81002b66:	60e2                	ld	ra,24(sp)
    81002b68:	6442                	ld	s0,16(sp)
    81002b6a:	64a2                	ld	s1,8(sp)
    81002b6c:	6105                	addi	sp,sp,32
    81002b6e:	8082                	ret
    panic("bwrite");
    81002b70:	00005517          	auipc	a0,0x5
    81002b74:	8e850513          	addi	a0,a0,-1816 # 81007458 <etext+0x458>
    81002b78:	c31fd0ef          	jal	810007a8 <panic>

0000000081002b7c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    81002b7c:	1101                	addi	sp,sp,-32
    81002b7e:	ec06                	sd	ra,24(sp)
    81002b80:	e822                	sd	s0,16(sp)
    81002b82:	e426                	sd	s1,8(sp)
    81002b84:	e04a                	sd	s2,0(sp)
    81002b86:	1000                	addi	s0,sp,32
    81002b88:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    81002b8a:	01050913          	addi	s2,a0,16
    81002b8e:	854a                	mv	a0,s2
    81002b90:	1b6010ef          	jal	81003d46 <holdingsleep>
    81002b94:	c125                	beqz	a0,81002bf4 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    81002b96:	854a                	mv	a0,s2
    81002b98:	176010ef          	jal	81003d0e <releasesleep>

  acquire(&bcache.lock);
    81002b9c:	0000b517          	auipc	a0,0xb
    81002ba0:	cdc50513          	addi	a0,a0,-804 # 8100d878 <bcache>
    81002ba4:	868fe0ef          	jal	81000c0c <acquire>
  b->refcnt--;
    81002ba8:	40bc                	lw	a5,64(s1)
    81002baa:	37fd                	addiw	a5,a5,-1 # ffffffff81015adf <end+0xfffffffeffffcadf>
    81002bac:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    81002bae:	e79d                	bnez	a5,81002bdc <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    81002bb0:	68b8                	ld	a4,80(s1)
    81002bb2:	64bc                	ld	a5,72(s1)
    81002bb4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    81002bb6:	68b8                	ld	a4,80(s1)
    81002bb8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    81002bba:	00013797          	auipc	a5,0x13
    81002bbe:	cbe78793          	addi	a5,a5,-834 # 81015878 <bcache+0x8000>
    81002bc2:	2b87b703          	ld	a4,696(a5)
    81002bc6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    81002bc8:	00013717          	auipc	a4,0x13
    81002bcc:	f1870713          	addi	a4,a4,-232 # 81015ae0 <bcache+0x8268>
    81002bd0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    81002bd2:	2b87b703          	ld	a4,696(a5)
    81002bd6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    81002bd8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    81002bdc:	0000b517          	auipc	a0,0xb
    81002be0:	c9c50513          	addi	a0,a0,-868 # 8100d878 <bcache>
    81002be4:	8bcfe0ef          	jal	81000ca0 <release>
}
    81002be8:	60e2                	ld	ra,24(sp)
    81002bea:	6442                	ld	s0,16(sp)
    81002bec:	64a2                	ld	s1,8(sp)
    81002bee:	6902                	ld	s2,0(sp)
    81002bf0:	6105                	addi	sp,sp,32
    81002bf2:	8082                	ret
    panic("brelse");
    81002bf4:	00005517          	auipc	a0,0x5
    81002bf8:	86c50513          	addi	a0,a0,-1940 # 81007460 <etext+0x460>
    81002bfc:	badfd0ef          	jal	810007a8 <panic>

0000000081002c00 <bpin>:

void
bpin(struct buf *b) {
    81002c00:	1101                	addi	sp,sp,-32
    81002c02:	ec06                	sd	ra,24(sp)
    81002c04:	e822                	sd	s0,16(sp)
    81002c06:	e426                	sd	s1,8(sp)
    81002c08:	1000                	addi	s0,sp,32
    81002c0a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    81002c0c:	0000b517          	auipc	a0,0xb
    81002c10:	c6c50513          	addi	a0,a0,-916 # 8100d878 <bcache>
    81002c14:	ff9fd0ef          	jal	81000c0c <acquire>
  b->refcnt++;
    81002c18:	40bc                	lw	a5,64(s1)
    81002c1a:	2785                	addiw	a5,a5,1
    81002c1c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    81002c1e:	0000b517          	auipc	a0,0xb
    81002c22:	c5a50513          	addi	a0,a0,-934 # 8100d878 <bcache>
    81002c26:	87afe0ef          	jal	81000ca0 <release>
}
    81002c2a:	60e2                	ld	ra,24(sp)
    81002c2c:	6442                	ld	s0,16(sp)
    81002c2e:	64a2                	ld	s1,8(sp)
    81002c30:	6105                	addi	sp,sp,32
    81002c32:	8082                	ret

0000000081002c34 <bunpin>:

void
bunpin(struct buf *b) {
    81002c34:	1101                	addi	sp,sp,-32
    81002c36:	ec06                	sd	ra,24(sp)
    81002c38:	e822                	sd	s0,16(sp)
    81002c3a:	e426                	sd	s1,8(sp)
    81002c3c:	1000                	addi	s0,sp,32
    81002c3e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    81002c40:	0000b517          	auipc	a0,0xb
    81002c44:	c3850513          	addi	a0,a0,-968 # 8100d878 <bcache>
    81002c48:	fc5fd0ef          	jal	81000c0c <acquire>
  b->refcnt--;
    81002c4c:	40bc                	lw	a5,64(s1)
    81002c4e:	37fd                	addiw	a5,a5,-1
    81002c50:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    81002c52:	0000b517          	auipc	a0,0xb
    81002c56:	c2650513          	addi	a0,a0,-986 # 8100d878 <bcache>
    81002c5a:	846fe0ef          	jal	81000ca0 <release>
}
    81002c5e:	60e2                	ld	ra,24(sp)
    81002c60:	6442                	ld	s0,16(sp)
    81002c62:	64a2                	ld	s1,8(sp)
    81002c64:	6105                	addi	sp,sp,32
    81002c66:	8082                	ret

0000000081002c68 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    81002c68:	1101                	addi	sp,sp,-32
    81002c6a:	ec06                	sd	ra,24(sp)
    81002c6c:	e822                	sd	s0,16(sp)
    81002c6e:	e426                	sd	s1,8(sp)
    81002c70:	e04a                	sd	s2,0(sp)
    81002c72:	1000                	addi	s0,sp,32
    81002c74:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    81002c76:	00d5d79b          	srliw	a5,a1,0xd
    81002c7a:	00013597          	auipc	a1,0x13
    81002c7e:	2da5a583          	lw	a1,730(a1) # 81015f54 <sb+0x1c>
    81002c82:	9dbd                	addw	a1,a1,a5
    81002c84:	df1ff0ef          	jal	81002a74 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    81002c88:	0074f713          	andi	a4,s1,7
    81002c8c:	4785                	li	a5,1
    81002c8e:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    81002c92:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    81002c94:	90d9                	srli	s1,s1,0x36
    81002c96:	00950733          	add	a4,a0,s1
    81002c9a:	05874703          	lbu	a4,88(a4)
    81002c9e:	00e7f6b3          	and	a3,a5,a4
    81002ca2:	c29d                	beqz	a3,81002cc8 <bfree+0x60>
    81002ca4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    81002ca6:	94aa                	add	s1,s1,a0
    81002ca8:	fff7c793          	not	a5,a5
    81002cac:	8f7d                	and	a4,a4,a5
    81002cae:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    81002cb2:	711000ef          	jal	81003bc2 <log_write>
  brelse(bp);
    81002cb6:	854a                	mv	a0,s2
    81002cb8:	ec5ff0ef          	jal	81002b7c <brelse>
}
    81002cbc:	60e2                	ld	ra,24(sp)
    81002cbe:	6442                	ld	s0,16(sp)
    81002cc0:	64a2                	ld	s1,8(sp)
    81002cc2:	6902                	ld	s2,0(sp)
    81002cc4:	6105                	addi	sp,sp,32
    81002cc6:	8082                	ret
    panic("freeing free block");
    81002cc8:	00004517          	auipc	a0,0x4
    81002ccc:	7a050513          	addi	a0,a0,1952 # 81007468 <etext+0x468>
    81002cd0:	ad9fd0ef          	jal	810007a8 <panic>

0000000081002cd4 <balloc>:
{
    81002cd4:	715d                	addi	sp,sp,-80
    81002cd6:	e486                	sd	ra,72(sp)
    81002cd8:	e0a2                	sd	s0,64(sp)
    81002cda:	fc26                	sd	s1,56(sp)
    81002cdc:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    81002cde:	00013797          	auipc	a5,0x13
    81002ce2:	25e7a783          	lw	a5,606(a5) # 81015f3c <sb+0x4>
    81002ce6:	0e078863          	beqz	a5,81002dd6 <balloc+0x102>
    81002cea:	f84a                	sd	s2,48(sp)
    81002cec:	f44e                	sd	s3,40(sp)
    81002cee:	f052                	sd	s4,32(sp)
    81002cf0:	ec56                	sd	s5,24(sp)
    81002cf2:	e85a                	sd	s6,16(sp)
    81002cf4:	e45e                	sd	s7,8(sp)
    81002cf6:	e062                	sd	s8,0(sp)
    81002cf8:	8baa                	mv	s7,a0
    81002cfa:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    81002cfc:	00013b17          	auipc	s6,0x13
    81002d00:	23cb0b13          	addi	s6,s6,572 # 81015f38 <sb>
      m = 1 << (bi % 8);
    81002d04:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    81002d06:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    81002d08:	6c09                	lui	s8,0x2
    81002d0a:	a09d                	j	81002d70 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    81002d0c:	97ca                	add	a5,a5,s2
    81002d0e:	8e55                	or	a2,a2,a3
    81002d10:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    81002d14:	854a                	mv	a0,s2
    81002d16:	6ad000ef          	jal	81003bc2 <log_write>
        brelse(bp);
    81002d1a:	854a                	mv	a0,s2
    81002d1c:	e61ff0ef          	jal	81002b7c <brelse>
  bp = bread(dev, bno);
    81002d20:	85a6                	mv	a1,s1
    81002d22:	855e                	mv	a0,s7
    81002d24:	d51ff0ef          	jal	81002a74 <bread>
    81002d28:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    81002d2a:	40000613          	li	a2,1024
    81002d2e:	4581                	li	a1,0
    81002d30:	05850513          	addi	a0,a0,88
    81002d34:	fa9fd0ef          	jal	81000cdc <memset>
  log_write(bp);
    81002d38:	854a                	mv	a0,s2
    81002d3a:	689000ef          	jal	81003bc2 <log_write>
  brelse(bp);
    81002d3e:	854a                	mv	a0,s2
    81002d40:	e3dff0ef          	jal	81002b7c <brelse>
}
    81002d44:	7942                	ld	s2,48(sp)
    81002d46:	79a2                	ld	s3,40(sp)
    81002d48:	7a02                	ld	s4,32(sp)
    81002d4a:	6ae2                	ld	s5,24(sp)
    81002d4c:	6b42                	ld	s6,16(sp)
    81002d4e:	6ba2                	ld	s7,8(sp)
    81002d50:	6c02                	ld	s8,0(sp)
}
    81002d52:	8526                	mv	a0,s1
    81002d54:	60a6                	ld	ra,72(sp)
    81002d56:	6406                	ld	s0,64(sp)
    81002d58:	74e2                	ld	s1,56(sp)
    81002d5a:	6161                	addi	sp,sp,80
    81002d5c:	8082                	ret
    brelse(bp);
    81002d5e:	854a                	mv	a0,s2
    81002d60:	e1dff0ef          	jal	81002b7c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    81002d64:	015c0abb          	addw	s5,s8,s5
    81002d68:	004b2783          	lw	a5,4(s6)
    81002d6c:	04fafe63          	bgeu	s5,a5,81002dc8 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    81002d70:	41fad79b          	sraiw	a5,s5,0x1f
    81002d74:	0137d79b          	srliw	a5,a5,0x13
    81002d78:	015787bb          	addw	a5,a5,s5
    81002d7c:	40d7d79b          	sraiw	a5,a5,0xd
    81002d80:	01cb2583          	lw	a1,28(s6)
    81002d84:	9dbd                	addw	a1,a1,a5
    81002d86:	855e                	mv	a0,s7
    81002d88:	cedff0ef          	jal	81002a74 <bread>
    81002d8c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    81002d8e:	004b2503          	lw	a0,4(s6)
    81002d92:	84d6                	mv	s1,s5
    81002d94:	4701                	li	a4,0
    81002d96:	fca4f4e3          	bgeu	s1,a0,81002d5e <balloc+0x8a>
      m = 1 << (bi % 8);
    81002d9a:	00777693          	andi	a3,a4,7
    81002d9e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    81002da2:	41f7579b          	sraiw	a5,a4,0x1f
    81002da6:	01d7d79b          	srliw	a5,a5,0x1d
    81002daa:	9fb9                	addw	a5,a5,a4
    81002dac:	4037d79b          	sraiw	a5,a5,0x3
    81002db0:	00f90633          	add	a2,s2,a5
    81002db4:	05864603          	lbu	a2,88(a2)
    81002db8:	00c6f5b3          	and	a1,a3,a2
    81002dbc:	d9a1                	beqz	a1,81002d0c <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    81002dbe:	2705                	addiw	a4,a4,1
    81002dc0:	2485                	addiw	s1,s1,1
    81002dc2:	fd471ae3          	bne	a4,s4,81002d96 <balloc+0xc2>
    81002dc6:	bf61                	j	81002d5e <balloc+0x8a>
    81002dc8:	7942                	ld	s2,48(sp)
    81002dca:	79a2                	ld	s3,40(sp)
    81002dcc:	7a02                	ld	s4,32(sp)
    81002dce:	6ae2                	ld	s5,24(sp)
    81002dd0:	6b42                	ld	s6,16(sp)
    81002dd2:	6ba2                	ld	s7,8(sp)
    81002dd4:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    81002dd6:	00004517          	auipc	a0,0x4
    81002dda:	6aa50513          	addi	a0,a0,1706 # 81007480 <etext+0x480>
    81002dde:	efafd0ef          	jal	810004d8 <printf>
  return 0;
    81002de2:	4481                	li	s1,0
    81002de4:	b7bd                	j	81002d52 <balloc+0x7e>

0000000081002de6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    81002de6:	7179                	addi	sp,sp,-48
    81002de8:	f406                	sd	ra,40(sp)
    81002dea:	f022                	sd	s0,32(sp)
    81002dec:	ec26                	sd	s1,24(sp)
    81002dee:	e84a                	sd	s2,16(sp)
    81002df0:	e44e                	sd	s3,8(sp)
    81002df2:	1800                	addi	s0,sp,48
    81002df4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    81002df6:	47ad                	li	a5,11
    81002df8:	02b7e363          	bltu	a5,a1,81002e1e <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    81002dfc:	02059793          	slli	a5,a1,0x20
    81002e00:	01e7d593          	srli	a1,a5,0x1e
    81002e04:	00b504b3          	add	s1,a0,a1
    81002e08:	0504a903          	lw	s2,80(s1)
    81002e0c:	06091363          	bnez	s2,81002e72 <bmap+0x8c>
      addr = balloc(ip->dev);
    81002e10:	4108                	lw	a0,0(a0)
    81002e12:	ec3ff0ef          	jal	81002cd4 <balloc>
    81002e16:	892a                	mv	s2,a0
      if(addr == 0)
    81002e18:	cd29                	beqz	a0,81002e72 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    81002e1a:	c8a8                	sw	a0,80(s1)
    81002e1c:	a899                	j	81002e72 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    81002e1e:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    81002e22:	0ff00793          	li	a5,255
    81002e26:	0697e963          	bltu	a5,s1,81002e98 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    81002e2a:	08052903          	lw	s2,128(a0)
    81002e2e:	00091b63          	bnez	s2,81002e44 <bmap+0x5e>
      addr = balloc(ip->dev);
    81002e32:	4108                	lw	a0,0(a0)
    81002e34:	ea1ff0ef          	jal	81002cd4 <balloc>
    81002e38:	892a                	mv	s2,a0
      if(addr == 0)
    81002e3a:	cd05                	beqz	a0,81002e72 <bmap+0x8c>
    81002e3c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    81002e3e:	08a9a023          	sw	a0,128(s3)
    81002e42:	a011                	j	81002e46 <bmap+0x60>
    81002e44:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    81002e46:	85ca                	mv	a1,s2
    81002e48:	0009a503          	lw	a0,0(s3)
    81002e4c:	c29ff0ef          	jal	81002a74 <bread>
    81002e50:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    81002e52:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    81002e56:	02049713          	slli	a4,s1,0x20
    81002e5a:	01e75593          	srli	a1,a4,0x1e
    81002e5e:	00b784b3          	add	s1,a5,a1
    81002e62:	0004a903          	lw	s2,0(s1)
    81002e66:	00090e63          	beqz	s2,81002e82 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    81002e6a:	8552                	mv	a0,s4
    81002e6c:	d11ff0ef          	jal	81002b7c <brelse>
    return addr;
    81002e70:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    81002e72:	854a                	mv	a0,s2
    81002e74:	70a2                	ld	ra,40(sp)
    81002e76:	7402                	ld	s0,32(sp)
    81002e78:	64e2                	ld	s1,24(sp)
    81002e7a:	6942                	ld	s2,16(sp)
    81002e7c:	69a2                	ld	s3,8(sp)
    81002e7e:	6145                	addi	sp,sp,48
    81002e80:	8082                	ret
      addr = balloc(ip->dev);
    81002e82:	0009a503          	lw	a0,0(s3)
    81002e86:	e4fff0ef          	jal	81002cd4 <balloc>
    81002e8a:	892a                	mv	s2,a0
      if(addr){
    81002e8c:	dd79                	beqz	a0,81002e6a <bmap+0x84>
        a[bn] = addr;
    81002e8e:	c088                	sw	a0,0(s1)
        log_write(bp);
    81002e90:	8552                	mv	a0,s4
    81002e92:	531000ef          	jal	81003bc2 <log_write>
    81002e96:	bfd1                	j	81002e6a <bmap+0x84>
    81002e98:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    81002e9a:	00004517          	auipc	a0,0x4
    81002e9e:	5fe50513          	addi	a0,a0,1534 # 81007498 <etext+0x498>
    81002ea2:	907fd0ef          	jal	810007a8 <panic>

0000000081002ea6 <iget>:
{
    81002ea6:	7179                	addi	sp,sp,-48
    81002ea8:	f406                	sd	ra,40(sp)
    81002eaa:	f022                	sd	s0,32(sp)
    81002eac:	ec26                	sd	s1,24(sp)
    81002eae:	e84a                	sd	s2,16(sp)
    81002eb0:	e44e                	sd	s3,8(sp)
    81002eb2:	e052                	sd	s4,0(sp)
    81002eb4:	1800                	addi	s0,sp,48
    81002eb6:	89aa                	mv	s3,a0
    81002eb8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    81002eba:	00013517          	auipc	a0,0x13
    81002ebe:	09e50513          	addi	a0,a0,158 # 81015f58 <itable>
    81002ec2:	d4bfd0ef          	jal	81000c0c <acquire>
  empty = 0;
    81002ec6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    81002ec8:	00013497          	auipc	s1,0x13
    81002ecc:	0a848493          	addi	s1,s1,168 # 81015f70 <itable+0x18>
    81002ed0:	00015697          	auipc	a3,0x15
    81002ed4:	b3068693          	addi	a3,a3,-1232 # 81017a00 <log>
    81002ed8:	a039                	j	81002ee6 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    81002eda:	02090963          	beqz	s2,81002f0c <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    81002ede:	08848493          	addi	s1,s1,136
    81002ee2:	02d48863          	beq	s1,a3,81002f12 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    81002ee6:	449c                	lw	a5,8(s1)
    81002ee8:	fef059e3          	blez	a5,81002eda <iget+0x34>
    81002eec:	4098                	lw	a4,0(s1)
    81002eee:	ff3716e3          	bne	a4,s3,81002eda <iget+0x34>
    81002ef2:	40d8                	lw	a4,4(s1)
    81002ef4:	ff4713e3          	bne	a4,s4,81002eda <iget+0x34>
      ip->ref++;
    81002ef8:	2785                	addiw	a5,a5,1
    81002efa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    81002efc:	00013517          	auipc	a0,0x13
    81002f00:	05c50513          	addi	a0,a0,92 # 81015f58 <itable>
    81002f04:	d9dfd0ef          	jal	81000ca0 <release>
      return ip;
    81002f08:	8926                	mv	s2,s1
    81002f0a:	a02d                	j	81002f34 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    81002f0c:	fbe9                	bnez	a5,81002ede <iget+0x38>
      empty = ip;
    81002f0e:	8926                	mv	s2,s1
    81002f10:	b7f9                	j	81002ede <iget+0x38>
  if(empty == 0)
    81002f12:	02090a63          	beqz	s2,81002f46 <iget+0xa0>
  ip->dev = dev;
    81002f16:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    81002f1a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    81002f1e:	4785                	li	a5,1
    81002f20:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    81002f24:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    81002f28:	00013517          	auipc	a0,0x13
    81002f2c:	03050513          	addi	a0,a0,48 # 81015f58 <itable>
    81002f30:	d71fd0ef          	jal	81000ca0 <release>
}
    81002f34:	854a                	mv	a0,s2
    81002f36:	70a2                	ld	ra,40(sp)
    81002f38:	7402                	ld	s0,32(sp)
    81002f3a:	64e2                	ld	s1,24(sp)
    81002f3c:	6942                	ld	s2,16(sp)
    81002f3e:	69a2                	ld	s3,8(sp)
    81002f40:	6a02                	ld	s4,0(sp)
    81002f42:	6145                	addi	sp,sp,48
    81002f44:	8082                	ret
    panic("iget: no inodes");
    81002f46:	00004517          	auipc	a0,0x4
    81002f4a:	56a50513          	addi	a0,a0,1386 # 810074b0 <etext+0x4b0>
    81002f4e:	85bfd0ef          	jal	810007a8 <panic>

0000000081002f52 <fsinit>:
fsinit(int dev) {
    81002f52:	7179                	addi	sp,sp,-48
    81002f54:	f406                	sd	ra,40(sp)
    81002f56:	f022                	sd	s0,32(sp)
    81002f58:	ec26                	sd	s1,24(sp)
    81002f5a:	e84a                	sd	s2,16(sp)
    81002f5c:	e44e                	sd	s3,8(sp)
    81002f5e:	1800                	addi	s0,sp,48
    81002f60:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    81002f62:	4585                	li	a1,1
    81002f64:	b11ff0ef          	jal	81002a74 <bread>
    81002f68:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    81002f6a:	00013997          	auipc	s3,0x13
    81002f6e:	fce98993          	addi	s3,s3,-50 # 81015f38 <sb>
    81002f72:	02000613          	li	a2,32
    81002f76:	05850593          	addi	a1,a0,88
    81002f7a:	854e                	mv	a0,s3
    81002f7c:	dc5fd0ef          	jal	81000d40 <memmove>
  brelse(bp);
    81002f80:	8526                	mv	a0,s1
    81002f82:	bfbff0ef          	jal	81002b7c <brelse>
  if(sb.magic != FSMAGIC)
    81002f86:	0009a703          	lw	a4,0(s3)
    81002f8a:	102037b7          	lui	a5,0x10203
    81002f8e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x70dfcfc0>
    81002f92:	02f71063          	bne	a4,a5,81002fb2 <fsinit+0x60>
  initlog(dev, &sb);
    81002f96:	00013597          	auipc	a1,0x13
    81002f9a:	fa258593          	addi	a1,a1,-94 # 81015f38 <sb>
    81002f9e:	854a                	mv	a0,s2
    81002fa0:	215000ef          	jal	810039b4 <initlog>
}
    81002fa4:	70a2                	ld	ra,40(sp)
    81002fa6:	7402                	ld	s0,32(sp)
    81002fa8:	64e2                	ld	s1,24(sp)
    81002faa:	6942                	ld	s2,16(sp)
    81002fac:	69a2                	ld	s3,8(sp)
    81002fae:	6145                	addi	sp,sp,48
    81002fb0:	8082                	ret
    panic("invalid file system");
    81002fb2:	00004517          	auipc	a0,0x4
    81002fb6:	50e50513          	addi	a0,a0,1294 # 810074c0 <etext+0x4c0>
    81002fba:	feefd0ef          	jal	810007a8 <panic>

0000000081002fbe <iinit>:
{
    81002fbe:	7179                	addi	sp,sp,-48
    81002fc0:	f406                	sd	ra,40(sp)
    81002fc2:	f022                	sd	s0,32(sp)
    81002fc4:	ec26                	sd	s1,24(sp)
    81002fc6:	e84a                	sd	s2,16(sp)
    81002fc8:	e44e                	sd	s3,8(sp)
    81002fca:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    81002fcc:	00004597          	auipc	a1,0x4
    81002fd0:	50c58593          	addi	a1,a1,1292 # 810074d8 <etext+0x4d8>
    81002fd4:	00013517          	auipc	a0,0x13
    81002fd8:	f8450513          	addi	a0,a0,-124 # 81015f58 <itable>
    81002fdc:	badfd0ef          	jal	81000b88 <initlock>
  for(i = 0; i < NINODE; i++) {
    81002fe0:	00013497          	auipc	s1,0x13
    81002fe4:	fa048493          	addi	s1,s1,-96 # 81015f80 <itable+0x28>
    81002fe8:	00015997          	auipc	s3,0x15
    81002fec:	a2898993          	addi	s3,s3,-1496 # 81017a10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    81002ff0:	00004917          	auipc	s2,0x4
    81002ff4:	4f090913          	addi	s2,s2,1264 # 810074e0 <etext+0x4e0>
    81002ff8:	85ca                	mv	a1,s2
    81002ffa:	8526                	mv	a0,s1
    81002ffc:	497000ef          	jal	81003c92 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    81003000:	08848493          	addi	s1,s1,136
    81003004:	ff349ae3          	bne	s1,s3,81002ff8 <iinit+0x3a>
}
    81003008:	70a2                	ld	ra,40(sp)
    8100300a:	7402                	ld	s0,32(sp)
    8100300c:	64e2                	ld	s1,24(sp)
    8100300e:	6942                	ld	s2,16(sp)
    81003010:	69a2                	ld	s3,8(sp)
    81003012:	6145                	addi	sp,sp,48
    81003014:	8082                	ret

0000000081003016 <ialloc>:
{
    81003016:	7139                	addi	sp,sp,-64
    81003018:	fc06                	sd	ra,56(sp)
    8100301a:	f822                	sd	s0,48(sp)
    8100301c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8100301e:	00013717          	auipc	a4,0x13
    81003022:	f2672703          	lw	a4,-218(a4) # 81015f44 <sb+0xc>
    81003026:	4785                	li	a5,1
    81003028:	06e7f063          	bgeu	a5,a4,81003088 <ialloc+0x72>
    8100302c:	f426                	sd	s1,40(sp)
    8100302e:	f04a                	sd	s2,32(sp)
    81003030:	ec4e                	sd	s3,24(sp)
    81003032:	e852                	sd	s4,16(sp)
    81003034:	e456                	sd	s5,8(sp)
    81003036:	e05a                	sd	s6,0(sp)
    81003038:	8aaa                	mv	s5,a0
    8100303a:	8b2e                	mv	s6,a1
    8100303c:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8100303e:	00013a17          	auipc	s4,0x13
    81003042:	efaa0a13          	addi	s4,s4,-262 # 81015f38 <sb>
    81003046:	00495593          	srli	a1,s2,0x4
    8100304a:	018a2783          	lw	a5,24(s4)
    8100304e:	9dbd                	addw	a1,a1,a5
    81003050:	8556                	mv	a0,s5
    81003052:	a23ff0ef          	jal	81002a74 <bread>
    81003056:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    81003058:	05850993          	addi	s3,a0,88
    8100305c:	00f97793          	andi	a5,s2,15
    81003060:	079a                	slli	a5,a5,0x6
    81003062:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    81003064:	00099783          	lh	a5,0(s3)
    81003068:	cb9d                	beqz	a5,8100309e <ialloc+0x88>
    brelse(bp);
    8100306a:	b13ff0ef          	jal	81002b7c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8100306e:	0905                	addi	s2,s2,1
    81003070:	00ca2703          	lw	a4,12(s4)
    81003074:	0009079b          	sext.w	a5,s2
    81003078:	fce7e7e3          	bltu	a5,a4,81003046 <ialloc+0x30>
    8100307c:	74a2                	ld	s1,40(sp)
    8100307e:	7902                	ld	s2,32(sp)
    81003080:	69e2                	ld	s3,24(sp)
    81003082:	6a42                	ld	s4,16(sp)
    81003084:	6aa2                	ld	s5,8(sp)
    81003086:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    81003088:	00004517          	auipc	a0,0x4
    8100308c:	46050513          	addi	a0,a0,1120 # 810074e8 <etext+0x4e8>
    81003090:	c48fd0ef          	jal	810004d8 <printf>
  return 0;
    81003094:	4501                	li	a0,0
}
    81003096:	70e2                	ld	ra,56(sp)
    81003098:	7442                	ld	s0,48(sp)
    8100309a:	6121                	addi	sp,sp,64
    8100309c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8100309e:	04000613          	li	a2,64
    810030a2:	4581                	li	a1,0
    810030a4:	854e                	mv	a0,s3
    810030a6:	c37fd0ef          	jal	81000cdc <memset>
      dip->type = type;
    810030aa:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    810030ae:	8526                	mv	a0,s1
    810030b0:	313000ef          	jal	81003bc2 <log_write>
      brelse(bp);
    810030b4:	8526                	mv	a0,s1
    810030b6:	ac7ff0ef          	jal	81002b7c <brelse>
      return iget(dev, inum);
    810030ba:	0009059b          	sext.w	a1,s2
    810030be:	8556                	mv	a0,s5
    810030c0:	de7ff0ef          	jal	81002ea6 <iget>
    810030c4:	74a2                	ld	s1,40(sp)
    810030c6:	7902                	ld	s2,32(sp)
    810030c8:	69e2                	ld	s3,24(sp)
    810030ca:	6a42                	ld	s4,16(sp)
    810030cc:	6aa2                	ld	s5,8(sp)
    810030ce:	6b02                	ld	s6,0(sp)
    810030d0:	b7d9                	j	81003096 <ialloc+0x80>

00000000810030d2 <iupdate>:
{
    810030d2:	1101                	addi	sp,sp,-32
    810030d4:	ec06                	sd	ra,24(sp)
    810030d6:	e822                	sd	s0,16(sp)
    810030d8:	e426                	sd	s1,8(sp)
    810030da:	e04a                	sd	s2,0(sp)
    810030dc:	1000                	addi	s0,sp,32
    810030de:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    810030e0:	415c                	lw	a5,4(a0)
    810030e2:	0047d79b          	srliw	a5,a5,0x4
    810030e6:	00013597          	auipc	a1,0x13
    810030ea:	e6a5a583          	lw	a1,-406(a1) # 81015f50 <sb+0x18>
    810030ee:	9dbd                	addw	a1,a1,a5
    810030f0:	4108                	lw	a0,0(a0)
    810030f2:	983ff0ef          	jal	81002a74 <bread>
    810030f6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    810030f8:	05850793          	addi	a5,a0,88
    810030fc:	40d8                	lw	a4,4(s1)
    810030fe:	8b3d                	andi	a4,a4,15
    81003100:	071a                	slli	a4,a4,0x6
    81003102:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    81003104:	04449703          	lh	a4,68(s1)
    81003108:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8100310c:	04649703          	lh	a4,70(s1)
    81003110:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    81003114:	04849703          	lh	a4,72(s1)
    81003118:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8100311c:	04a49703          	lh	a4,74(s1)
    81003120:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    81003124:	44f8                	lw	a4,76(s1)
    81003126:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    81003128:	03400613          	li	a2,52
    8100312c:	05048593          	addi	a1,s1,80
    81003130:	00c78513          	addi	a0,a5,12
    81003134:	c0dfd0ef          	jal	81000d40 <memmove>
  log_write(bp);
    81003138:	854a                	mv	a0,s2
    8100313a:	289000ef          	jal	81003bc2 <log_write>
  brelse(bp);
    8100313e:	854a                	mv	a0,s2
    81003140:	a3dff0ef          	jal	81002b7c <brelse>
}
    81003144:	60e2                	ld	ra,24(sp)
    81003146:	6442                	ld	s0,16(sp)
    81003148:	64a2                	ld	s1,8(sp)
    8100314a:	6902                	ld	s2,0(sp)
    8100314c:	6105                	addi	sp,sp,32
    8100314e:	8082                	ret

0000000081003150 <idup>:
{
    81003150:	1101                	addi	sp,sp,-32
    81003152:	ec06                	sd	ra,24(sp)
    81003154:	e822                	sd	s0,16(sp)
    81003156:	e426                	sd	s1,8(sp)
    81003158:	1000                	addi	s0,sp,32
    8100315a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8100315c:	00013517          	auipc	a0,0x13
    81003160:	dfc50513          	addi	a0,a0,-516 # 81015f58 <itable>
    81003164:	aa9fd0ef          	jal	81000c0c <acquire>
  ip->ref++;
    81003168:	449c                	lw	a5,8(s1)
    8100316a:	2785                	addiw	a5,a5,1
    8100316c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8100316e:	00013517          	auipc	a0,0x13
    81003172:	dea50513          	addi	a0,a0,-534 # 81015f58 <itable>
    81003176:	b2bfd0ef          	jal	81000ca0 <release>
}
    8100317a:	8526                	mv	a0,s1
    8100317c:	60e2                	ld	ra,24(sp)
    8100317e:	6442                	ld	s0,16(sp)
    81003180:	64a2                	ld	s1,8(sp)
    81003182:	6105                	addi	sp,sp,32
    81003184:	8082                	ret

0000000081003186 <ilock>:
{
    81003186:	1101                	addi	sp,sp,-32
    81003188:	ec06                	sd	ra,24(sp)
    8100318a:	e822                	sd	s0,16(sp)
    8100318c:	e426                	sd	s1,8(sp)
    8100318e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    81003190:	cd19                	beqz	a0,810031ae <ilock+0x28>
    81003192:	84aa                	mv	s1,a0
    81003194:	451c                	lw	a5,8(a0)
    81003196:	00f05c63          	blez	a5,810031ae <ilock+0x28>
  acquiresleep(&ip->lock);
    8100319a:	0541                	addi	a0,a0,16
    8100319c:	32d000ef          	jal	81003cc8 <acquiresleep>
  if(ip->valid == 0){
    810031a0:	40bc                	lw	a5,64(s1)
    810031a2:	cf89                	beqz	a5,810031bc <ilock+0x36>
}
    810031a4:	60e2                	ld	ra,24(sp)
    810031a6:	6442                	ld	s0,16(sp)
    810031a8:	64a2                	ld	s1,8(sp)
    810031aa:	6105                	addi	sp,sp,32
    810031ac:	8082                	ret
    810031ae:	e04a                	sd	s2,0(sp)
    panic("ilock");
    810031b0:	00004517          	auipc	a0,0x4
    810031b4:	35050513          	addi	a0,a0,848 # 81007500 <etext+0x500>
    810031b8:	df0fd0ef          	jal	810007a8 <panic>
    810031bc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    810031be:	40dc                	lw	a5,4(s1)
    810031c0:	0047d79b          	srliw	a5,a5,0x4
    810031c4:	00013597          	auipc	a1,0x13
    810031c8:	d8c5a583          	lw	a1,-628(a1) # 81015f50 <sb+0x18>
    810031cc:	9dbd                	addw	a1,a1,a5
    810031ce:	4088                	lw	a0,0(s1)
    810031d0:	8a5ff0ef          	jal	81002a74 <bread>
    810031d4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    810031d6:	05850593          	addi	a1,a0,88
    810031da:	40dc                	lw	a5,4(s1)
    810031dc:	8bbd                	andi	a5,a5,15
    810031de:	079a                	slli	a5,a5,0x6
    810031e0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    810031e2:	00059783          	lh	a5,0(a1)
    810031e6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    810031ea:	00259783          	lh	a5,2(a1)
    810031ee:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    810031f2:	00459783          	lh	a5,4(a1)
    810031f6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    810031fa:	00659783          	lh	a5,6(a1)
    810031fe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    81003202:	459c                	lw	a5,8(a1)
    81003204:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    81003206:	03400613          	li	a2,52
    8100320a:	05b1                	addi	a1,a1,12
    8100320c:	05048513          	addi	a0,s1,80
    81003210:	b31fd0ef          	jal	81000d40 <memmove>
    brelse(bp);
    81003214:	854a                	mv	a0,s2
    81003216:	967ff0ef          	jal	81002b7c <brelse>
    ip->valid = 1;
    8100321a:	4785                	li	a5,1
    8100321c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8100321e:	04449783          	lh	a5,68(s1)
    81003222:	c399                	beqz	a5,81003228 <ilock+0xa2>
    81003224:	6902                	ld	s2,0(sp)
    81003226:	bfbd                	j	810031a4 <ilock+0x1e>
      panic("ilock: no type");
    81003228:	00004517          	auipc	a0,0x4
    8100322c:	2e050513          	addi	a0,a0,736 # 81007508 <etext+0x508>
    81003230:	d78fd0ef          	jal	810007a8 <panic>

0000000081003234 <iunlock>:
{
    81003234:	1101                	addi	sp,sp,-32
    81003236:	ec06                	sd	ra,24(sp)
    81003238:	e822                	sd	s0,16(sp)
    8100323a:	e426                	sd	s1,8(sp)
    8100323c:	e04a                	sd	s2,0(sp)
    8100323e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    81003240:	c505                	beqz	a0,81003268 <iunlock+0x34>
    81003242:	84aa                	mv	s1,a0
    81003244:	01050913          	addi	s2,a0,16
    81003248:	854a                	mv	a0,s2
    8100324a:	2fd000ef          	jal	81003d46 <holdingsleep>
    8100324e:	cd09                	beqz	a0,81003268 <iunlock+0x34>
    81003250:	449c                	lw	a5,8(s1)
    81003252:	00f05b63          	blez	a5,81003268 <iunlock+0x34>
  releasesleep(&ip->lock);
    81003256:	854a                	mv	a0,s2
    81003258:	2b7000ef          	jal	81003d0e <releasesleep>
}
    8100325c:	60e2                	ld	ra,24(sp)
    8100325e:	6442                	ld	s0,16(sp)
    81003260:	64a2                	ld	s1,8(sp)
    81003262:	6902                	ld	s2,0(sp)
    81003264:	6105                	addi	sp,sp,32
    81003266:	8082                	ret
    panic("iunlock");
    81003268:	00004517          	auipc	a0,0x4
    8100326c:	2b050513          	addi	a0,a0,688 # 81007518 <etext+0x518>
    81003270:	d38fd0ef          	jal	810007a8 <panic>

0000000081003274 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    81003274:	7179                	addi	sp,sp,-48
    81003276:	f406                	sd	ra,40(sp)
    81003278:	f022                	sd	s0,32(sp)
    8100327a:	ec26                	sd	s1,24(sp)
    8100327c:	e84a                	sd	s2,16(sp)
    8100327e:	e44e                	sd	s3,8(sp)
    81003280:	1800                	addi	s0,sp,48
    81003282:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    81003284:	05050493          	addi	s1,a0,80
    81003288:	08050913          	addi	s2,a0,128
    8100328c:	a021                	j	81003294 <itrunc+0x20>
    8100328e:	0491                	addi	s1,s1,4
    81003290:	01248b63          	beq	s1,s2,810032a6 <itrunc+0x32>
    if(ip->addrs[i]){
    81003294:	408c                	lw	a1,0(s1)
    81003296:	dde5                	beqz	a1,8100328e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    81003298:	0009a503          	lw	a0,0(s3)
    8100329c:	9cdff0ef          	jal	81002c68 <bfree>
      ip->addrs[i] = 0;
    810032a0:	0004a023          	sw	zero,0(s1)
    810032a4:	b7ed                	j	8100328e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    810032a6:	0809a583          	lw	a1,128(s3)
    810032aa:	ed89                	bnez	a1,810032c4 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    810032ac:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    810032b0:	854e                	mv	a0,s3
    810032b2:	e21ff0ef          	jal	810030d2 <iupdate>
}
    810032b6:	70a2                	ld	ra,40(sp)
    810032b8:	7402                	ld	s0,32(sp)
    810032ba:	64e2                	ld	s1,24(sp)
    810032bc:	6942                	ld	s2,16(sp)
    810032be:	69a2                	ld	s3,8(sp)
    810032c0:	6145                	addi	sp,sp,48
    810032c2:	8082                	ret
    810032c4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    810032c6:	0009a503          	lw	a0,0(s3)
    810032ca:	faaff0ef          	jal	81002a74 <bread>
    810032ce:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    810032d0:	05850493          	addi	s1,a0,88
    810032d4:	45850913          	addi	s2,a0,1112
    810032d8:	a021                	j	810032e0 <itrunc+0x6c>
    810032da:	0491                	addi	s1,s1,4
    810032dc:	01248963          	beq	s1,s2,810032ee <itrunc+0x7a>
      if(a[j])
    810032e0:	408c                	lw	a1,0(s1)
    810032e2:	dde5                	beqz	a1,810032da <itrunc+0x66>
        bfree(ip->dev, a[j]);
    810032e4:	0009a503          	lw	a0,0(s3)
    810032e8:	981ff0ef          	jal	81002c68 <bfree>
    810032ec:	b7fd                	j	810032da <itrunc+0x66>
    brelse(bp);
    810032ee:	8552                	mv	a0,s4
    810032f0:	88dff0ef          	jal	81002b7c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    810032f4:	0809a583          	lw	a1,128(s3)
    810032f8:	0009a503          	lw	a0,0(s3)
    810032fc:	96dff0ef          	jal	81002c68 <bfree>
    ip->addrs[NDIRECT] = 0;
    81003300:	0809a023          	sw	zero,128(s3)
    81003304:	6a02                	ld	s4,0(sp)
    81003306:	b75d                	j	810032ac <itrunc+0x38>

0000000081003308 <iput>:
{
    81003308:	1101                	addi	sp,sp,-32
    8100330a:	ec06                	sd	ra,24(sp)
    8100330c:	e822                	sd	s0,16(sp)
    8100330e:	e426                	sd	s1,8(sp)
    81003310:	1000                	addi	s0,sp,32
    81003312:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    81003314:	00013517          	auipc	a0,0x13
    81003318:	c4450513          	addi	a0,a0,-956 # 81015f58 <itable>
    8100331c:	8f1fd0ef          	jal	81000c0c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    81003320:	4498                	lw	a4,8(s1)
    81003322:	4785                	li	a5,1
    81003324:	02f70063          	beq	a4,a5,81003344 <iput+0x3c>
  ip->ref--;
    81003328:	449c                	lw	a5,8(s1)
    8100332a:	37fd                	addiw	a5,a5,-1
    8100332c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8100332e:	00013517          	auipc	a0,0x13
    81003332:	c2a50513          	addi	a0,a0,-982 # 81015f58 <itable>
    81003336:	96bfd0ef          	jal	81000ca0 <release>
}
    8100333a:	60e2                	ld	ra,24(sp)
    8100333c:	6442                	ld	s0,16(sp)
    8100333e:	64a2                	ld	s1,8(sp)
    81003340:	6105                	addi	sp,sp,32
    81003342:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    81003344:	40bc                	lw	a5,64(s1)
    81003346:	d3ed                	beqz	a5,81003328 <iput+0x20>
    81003348:	04a49783          	lh	a5,74(s1)
    8100334c:	fff1                	bnez	a5,81003328 <iput+0x20>
    8100334e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    81003350:	01048913          	addi	s2,s1,16
    81003354:	854a                	mv	a0,s2
    81003356:	173000ef          	jal	81003cc8 <acquiresleep>
    release(&itable.lock);
    8100335a:	00013517          	auipc	a0,0x13
    8100335e:	bfe50513          	addi	a0,a0,-1026 # 81015f58 <itable>
    81003362:	93ffd0ef          	jal	81000ca0 <release>
    itrunc(ip);
    81003366:	8526                	mv	a0,s1
    81003368:	f0dff0ef          	jal	81003274 <itrunc>
    ip->type = 0;
    8100336c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    81003370:	8526                	mv	a0,s1
    81003372:	d61ff0ef          	jal	810030d2 <iupdate>
    ip->valid = 0;
    81003376:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8100337a:	854a                	mv	a0,s2
    8100337c:	193000ef          	jal	81003d0e <releasesleep>
    acquire(&itable.lock);
    81003380:	00013517          	auipc	a0,0x13
    81003384:	bd850513          	addi	a0,a0,-1064 # 81015f58 <itable>
    81003388:	885fd0ef          	jal	81000c0c <acquire>
    8100338c:	6902                	ld	s2,0(sp)
    8100338e:	bf69                	j	81003328 <iput+0x20>

0000000081003390 <iunlockput>:
{
    81003390:	1101                	addi	sp,sp,-32
    81003392:	ec06                	sd	ra,24(sp)
    81003394:	e822                	sd	s0,16(sp)
    81003396:	e426                	sd	s1,8(sp)
    81003398:	1000                	addi	s0,sp,32
    8100339a:	84aa                	mv	s1,a0
  iunlock(ip);
    8100339c:	e99ff0ef          	jal	81003234 <iunlock>
  iput(ip);
    810033a0:	8526                	mv	a0,s1
    810033a2:	f67ff0ef          	jal	81003308 <iput>
}
    810033a6:	60e2                	ld	ra,24(sp)
    810033a8:	6442                	ld	s0,16(sp)
    810033aa:	64a2                	ld	s1,8(sp)
    810033ac:	6105                	addi	sp,sp,32
    810033ae:	8082                	ret

00000000810033b0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    810033b0:	1141                	addi	sp,sp,-16
    810033b2:	e406                	sd	ra,8(sp)
    810033b4:	e022                	sd	s0,0(sp)
    810033b6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    810033b8:	411c                	lw	a5,0(a0)
    810033ba:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    810033bc:	415c                	lw	a5,4(a0)
    810033be:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    810033c0:	04451783          	lh	a5,68(a0)
    810033c4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    810033c8:	04a51783          	lh	a5,74(a0)
    810033cc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    810033d0:	04c56783          	lwu	a5,76(a0)
    810033d4:	e99c                	sd	a5,16(a1)
}
    810033d6:	60a2                	ld	ra,8(sp)
    810033d8:	6402                	ld	s0,0(sp)
    810033da:	0141                	addi	sp,sp,16
    810033dc:	8082                	ret

00000000810033de <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    810033de:	457c                	lw	a5,76(a0)
    810033e0:	0ed7e663          	bltu	a5,a3,810034cc <readi+0xee>
{
    810033e4:	7159                	addi	sp,sp,-112
    810033e6:	f486                	sd	ra,104(sp)
    810033e8:	f0a2                	sd	s0,96(sp)
    810033ea:	eca6                	sd	s1,88(sp)
    810033ec:	e0d2                	sd	s4,64(sp)
    810033ee:	fc56                	sd	s5,56(sp)
    810033f0:	f85a                	sd	s6,48(sp)
    810033f2:	f45e                	sd	s7,40(sp)
    810033f4:	1880                	addi	s0,sp,112
    810033f6:	8b2a                	mv	s6,a0
    810033f8:	8bae                	mv	s7,a1
    810033fa:	8a32                	mv	s4,a2
    810033fc:	84b6                	mv	s1,a3
    810033fe:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    81003400:	9f35                	addw	a4,a4,a3
    return 0;
    81003402:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    81003404:	0ad76b63          	bltu	a4,a3,810034ba <readi+0xdc>
    81003408:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8100340a:	00e7f463          	bgeu	a5,a4,81003412 <readi+0x34>
    n = ip->size - off;
    8100340e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    81003412:	080a8b63          	beqz	s5,810034a8 <readi+0xca>
    81003416:	e8ca                	sd	s2,80(sp)
    81003418:	f062                	sd	s8,32(sp)
    8100341a:	ec66                	sd	s9,24(sp)
    8100341c:	e86a                	sd	s10,16(sp)
    8100341e:	e46e                	sd	s11,8(sp)
    81003420:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    81003422:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    81003426:	5c7d                	li	s8,-1
    81003428:	a80d                	j	8100345a <readi+0x7c>
    8100342a:	020d1d93          	slli	s11,s10,0x20
    8100342e:	020ddd93          	srli	s11,s11,0x20
    81003432:	05890613          	addi	a2,s2,88
    81003436:	86ee                	mv	a3,s11
    81003438:	963e                	add	a2,a2,a5
    8100343a:	85d2                	mv	a1,s4
    8100343c:	855e                	mv	a0,s7
    8100343e:	dbdfe0ef          	jal	810021fa <either_copyout>
    81003442:	05850363          	beq	a0,s8,81003488 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    81003446:	854a                	mv	a0,s2
    81003448:	f34ff0ef          	jal	81002b7c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8100344c:	013d09bb          	addw	s3,s10,s3
    81003450:	009d04bb          	addw	s1,s10,s1
    81003454:	9a6e                	add	s4,s4,s11
    81003456:	0559f363          	bgeu	s3,s5,8100349c <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8100345a:	00a4d59b          	srliw	a1,s1,0xa
    8100345e:	855a                	mv	a0,s6
    81003460:	987ff0ef          	jal	81002de6 <bmap>
    81003464:	85aa                	mv	a1,a0
    if(addr == 0)
    81003466:	c139                	beqz	a0,810034ac <readi+0xce>
    bp = bread(ip->dev, addr);
    81003468:	000b2503          	lw	a0,0(s6)
    8100346c:	e08ff0ef          	jal	81002a74 <bread>
    81003470:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    81003472:	3ff4f793          	andi	a5,s1,1023
    81003476:	40fc873b          	subw	a4,s9,a5
    8100347a:	413a86bb          	subw	a3,s5,s3
    8100347e:	8d3a                	mv	s10,a4
    81003480:	fae6f5e3          	bgeu	a3,a4,8100342a <readi+0x4c>
    81003484:	8d36                	mv	s10,a3
    81003486:	b755                	j	8100342a <readi+0x4c>
      brelse(bp);
    81003488:	854a                	mv	a0,s2
    8100348a:	ef2ff0ef          	jal	81002b7c <brelse>
      tot = -1;
    8100348e:	59fd                	li	s3,-1
      break;
    81003490:	6946                	ld	s2,80(sp)
    81003492:	7c02                	ld	s8,32(sp)
    81003494:	6ce2                	ld	s9,24(sp)
    81003496:	6d42                	ld	s10,16(sp)
    81003498:	6da2                	ld	s11,8(sp)
    8100349a:	a831                	j	810034b6 <readi+0xd8>
    8100349c:	6946                	ld	s2,80(sp)
    8100349e:	7c02                	ld	s8,32(sp)
    810034a0:	6ce2                	ld	s9,24(sp)
    810034a2:	6d42                	ld	s10,16(sp)
    810034a4:	6da2                	ld	s11,8(sp)
    810034a6:	a801                	j	810034b6 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    810034a8:	89d6                	mv	s3,s5
    810034aa:	a031                	j	810034b6 <readi+0xd8>
    810034ac:	6946                	ld	s2,80(sp)
    810034ae:	7c02                	ld	s8,32(sp)
    810034b0:	6ce2                	ld	s9,24(sp)
    810034b2:	6d42                	ld	s10,16(sp)
    810034b4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    810034b6:	854e                	mv	a0,s3
    810034b8:	69a6                	ld	s3,72(sp)
}
    810034ba:	70a6                	ld	ra,104(sp)
    810034bc:	7406                	ld	s0,96(sp)
    810034be:	64e6                	ld	s1,88(sp)
    810034c0:	6a06                	ld	s4,64(sp)
    810034c2:	7ae2                	ld	s5,56(sp)
    810034c4:	7b42                	ld	s6,48(sp)
    810034c6:	7ba2                	ld	s7,40(sp)
    810034c8:	6165                	addi	sp,sp,112
    810034ca:	8082                	ret
    return 0;
    810034cc:	4501                	li	a0,0
}
    810034ce:	8082                	ret

00000000810034d0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    810034d0:	457c                	lw	a5,76(a0)
    810034d2:	0ed7eb63          	bltu	a5,a3,810035c8 <writei+0xf8>
{
    810034d6:	7159                	addi	sp,sp,-112
    810034d8:	f486                	sd	ra,104(sp)
    810034da:	f0a2                	sd	s0,96(sp)
    810034dc:	e8ca                	sd	s2,80(sp)
    810034de:	e0d2                	sd	s4,64(sp)
    810034e0:	fc56                	sd	s5,56(sp)
    810034e2:	f85a                	sd	s6,48(sp)
    810034e4:	f45e                	sd	s7,40(sp)
    810034e6:	1880                	addi	s0,sp,112
    810034e8:	8aaa                	mv	s5,a0
    810034ea:	8bae                	mv	s7,a1
    810034ec:	8a32                	mv	s4,a2
    810034ee:	8936                	mv	s2,a3
    810034f0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    810034f2:	00e687bb          	addw	a5,a3,a4
    810034f6:	0cd7eb63          	bltu	a5,a3,810035cc <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    810034fa:	00043737          	lui	a4,0x43
    810034fe:	0cf76963          	bltu	a4,a5,810035d0 <writei+0x100>
    81003502:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    81003504:	0a0b0a63          	beqz	s6,810035b8 <writei+0xe8>
    81003508:	eca6                	sd	s1,88(sp)
    8100350a:	f062                	sd	s8,32(sp)
    8100350c:	ec66                	sd	s9,24(sp)
    8100350e:	e86a                	sd	s10,16(sp)
    81003510:	e46e                	sd	s11,8(sp)
    81003512:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    81003514:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    81003518:	5c7d                	li	s8,-1
    8100351a:	a825                	j	81003552 <writei+0x82>
    8100351c:	020d1d93          	slli	s11,s10,0x20
    81003520:	020ddd93          	srli	s11,s11,0x20
    81003524:	05848513          	addi	a0,s1,88
    81003528:	86ee                	mv	a3,s11
    8100352a:	8652                	mv	a2,s4
    8100352c:	85de                	mv	a1,s7
    8100352e:	953e                	add	a0,a0,a5
    81003530:	d15fe0ef          	jal	81002244 <either_copyin>
    81003534:	05850663          	beq	a0,s8,81003580 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    81003538:	8526                	mv	a0,s1
    8100353a:	688000ef          	jal	81003bc2 <log_write>
    brelse(bp);
    8100353e:	8526                	mv	a0,s1
    81003540:	e3cff0ef          	jal	81002b7c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    81003544:	013d09bb          	addw	s3,s10,s3
    81003548:	012d093b          	addw	s2,s10,s2
    8100354c:	9a6e                	add	s4,s4,s11
    8100354e:	0369fc63          	bgeu	s3,s6,81003586 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    81003552:	00a9559b          	srliw	a1,s2,0xa
    81003556:	8556                	mv	a0,s5
    81003558:	88fff0ef          	jal	81002de6 <bmap>
    8100355c:	85aa                	mv	a1,a0
    if(addr == 0)
    8100355e:	c505                	beqz	a0,81003586 <writei+0xb6>
    bp = bread(ip->dev, addr);
    81003560:	000aa503          	lw	a0,0(s5)
    81003564:	d10ff0ef          	jal	81002a74 <bread>
    81003568:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8100356a:	3ff97793          	andi	a5,s2,1023
    8100356e:	40fc873b          	subw	a4,s9,a5
    81003572:	413b06bb          	subw	a3,s6,s3
    81003576:	8d3a                	mv	s10,a4
    81003578:	fae6f2e3          	bgeu	a3,a4,8100351c <writei+0x4c>
    8100357c:	8d36                	mv	s10,a3
    8100357e:	bf79                	j	8100351c <writei+0x4c>
      brelse(bp);
    81003580:	8526                	mv	a0,s1
    81003582:	dfaff0ef          	jal	81002b7c <brelse>
  }

  if(off > ip->size)
    81003586:	04caa783          	lw	a5,76(s5)
    8100358a:	0327f963          	bgeu	a5,s2,810035bc <writei+0xec>
    ip->size = off;
    8100358e:	052aa623          	sw	s2,76(s5)
    81003592:	64e6                	ld	s1,88(sp)
    81003594:	7c02                	ld	s8,32(sp)
    81003596:	6ce2                	ld	s9,24(sp)
    81003598:	6d42                	ld	s10,16(sp)
    8100359a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8100359c:	8556                	mv	a0,s5
    8100359e:	b35ff0ef          	jal	810030d2 <iupdate>

  return tot;
    810035a2:	854e                	mv	a0,s3
    810035a4:	69a6                	ld	s3,72(sp)
}
    810035a6:	70a6                	ld	ra,104(sp)
    810035a8:	7406                	ld	s0,96(sp)
    810035aa:	6946                	ld	s2,80(sp)
    810035ac:	6a06                	ld	s4,64(sp)
    810035ae:	7ae2                	ld	s5,56(sp)
    810035b0:	7b42                	ld	s6,48(sp)
    810035b2:	7ba2                	ld	s7,40(sp)
    810035b4:	6165                	addi	sp,sp,112
    810035b6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    810035b8:	89da                	mv	s3,s6
    810035ba:	b7cd                	j	8100359c <writei+0xcc>
    810035bc:	64e6                	ld	s1,88(sp)
    810035be:	7c02                	ld	s8,32(sp)
    810035c0:	6ce2                	ld	s9,24(sp)
    810035c2:	6d42                	ld	s10,16(sp)
    810035c4:	6da2                	ld	s11,8(sp)
    810035c6:	bfd9                	j	8100359c <writei+0xcc>
    return -1;
    810035c8:	557d                	li	a0,-1
}
    810035ca:	8082                	ret
    return -1;
    810035cc:	557d                	li	a0,-1
    810035ce:	bfe1                	j	810035a6 <writei+0xd6>
    return -1;
    810035d0:	557d                	li	a0,-1
    810035d2:	bfd1                	j	810035a6 <writei+0xd6>

00000000810035d4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    810035d4:	1141                	addi	sp,sp,-16
    810035d6:	e406                	sd	ra,8(sp)
    810035d8:	e022                	sd	s0,0(sp)
    810035da:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    810035dc:	4639                	li	a2,14
    810035de:	fd6fd0ef          	jal	81000db4 <strncmp>
}
    810035e2:	60a2                	ld	ra,8(sp)
    810035e4:	6402                	ld	s0,0(sp)
    810035e6:	0141                	addi	sp,sp,16
    810035e8:	8082                	ret

00000000810035ea <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    810035ea:	711d                	addi	sp,sp,-96
    810035ec:	ec86                	sd	ra,88(sp)
    810035ee:	e8a2                	sd	s0,80(sp)
    810035f0:	e4a6                	sd	s1,72(sp)
    810035f2:	e0ca                	sd	s2,64(sp)
    810035f4:	fc4e                	sd	s3,56(sp)
    810035f6:	f852                	sd	s4,48(sp)
    810035f8:	f456                	sd	s5,40(sp)
    810035fa:	f05a                	sd	s6,32(sp)
    810035fc:	ec5e                	sd	s7,24(sp)
    810035fe:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    81003600:	04451703          	lh	a4,68(a0)
    81003604:	4785                	li	a5,1
    81003606:	00f71f63          	bne	a4,a5,81003624 <dirlookup+0x3a>
    8100360a:	892a                	mv	s2,a0
    8100360c:	8aae                	mv	s5,a1
    8100360e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    81003610:	457c                	lw	a5,76(a0)
    81003612:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    81003614:	fa040a13          	addi	s4,s0,-96
    81003618:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8100361a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8100361e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    81003620:	e39d                	bnez	a5,81003646 <dirlookup+0x5c>
    81003622:	a8b9                	j	81003680 <dirlookup+0x96>
    panic("dirlookup not DIR");
    81003624:	00004517          	auipc	a0,0x4
    81003628:	efc50513          	addi	a0,a0,-260 # 81007520 <etext+0x520>
    8100362c:	97cfd0ef          	jal	810007a8 <panic>
      panic("dirlookup read");
    81003630:	00004517          	auipc	a0,0x4
    81003634:	f0850513          	addi	a0,a0,-248 # 81007538 <etext+0x538>
    81003638:	970fd0ef          	jal	810007a8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8100363c:	24c1                	addiw	s1,s1,16
    8100363e:	04c92783          	lw	a5,76(s2)
    81003642:	02f4fe63          	bgeu	s1,a5,8100367e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    81003646:	874e                	mv	a4,s3
    81003648:	86a6                	mv	a3,s1
    8100364a:	8652                	mv	a2,s4
    8100364c:	4581                	li	a1,0
    8100364e:	854a                	mv	a0,s2
    81003650:	d8fff0ef          	jal	810033de <readi>
    81003654:	fd351ee3          	bne	a0,s3,81003630 <dirlookup+0x46>
    if(de.inum == 0)
    81003658:	fa045783          	lhu	a5,-96(s0)
    8100365c:	d3e5                	beqz	a5,8100363c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    8100365e:	85da                	mv	a1,s6
    81003660:	8556                	mv	a0,s5
    81003662:	f73ff0ef          	jal	810035d4 <namecmp>
    81003666:	f979                	bnez	a0,8100363c <dirlookup+0x52>
      if(poff)
    81003668:	000b8463          	beqz	s7,81003670 <dirlookup+0x86>
        *poff = off;
    8100366c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    81003670:	fa045583          	lhu	a1,-96(s0)
    81003674:	00092503          	lw	a0,0(s2)
    81003678:	82fff0ef          	jal	81002ea6 <iget>
    8100367c:	a011                	j	81003680 <dirlookup+0x96>
  return 0;
    8100367e:	4501                	li	a0,0
}
    81003680:	60e6                	ld	ra,88(sp)
    81003682:	6446                	ld	s0,80(sp)
    81003684:	64a6                	ld	s1,72(sp)
    81003686:	6906                	ld	s2,64(sp)
    81003688:	79e2                	ld	s3,56(sp)
    8100368a:	7a42                	ld	s4,48(sp)
    8100368c:	7aa2                	ld	s5,40(sp)
    8100368e:	7b02                	ld	s6,32(sp)
    81003690:	6be2                	ld	s7,24(sp)
    81003692:	6125                	addi	sp,sp,96
    81003694:	8082                	ret

0000000081003696 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    81003696:	711d                	addi	sp,sp,-96
    81003698:	ec86                	sd	ra,88(sp)
    8100369a:	e8a2                	sd	s0,80(sp)
    8100369c:	e4a6                	sd	s1,72(sp)
    8100369e:	e0ca                	sd	s2,64(sp)
    810036a0:	fc4e                	sd	s3,56(sp)
    810036a2:	f852                	sd	s4,48(sp)
    810036a4:	f456                	sd	s5,40(sp)
    810036a6:	f05a                	sd	s6,32(sp)
    810036a8:	ec5e                	sd	s7,24(sp)
    810036aa:	e862                	sd	s8,16(sp)
    810036ac:	e466                	sd	s9,8(sp)
    810036ae:	e06a                	sd	s10,0(sp)
    810036b0:	1080                	addi	s0,sp,96
    810036b2:	84aa                	mv	s1,a0
    810036b4:	8b2e                	mv	s6,a1
    810036b6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    810036b8:	00054703          	lbu	a4,0(a0)
    810036bc:	02f00793          	li	a5,47
    810036c0:	00f70f63          	beq	a4,a5,810036de <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    810036c4:	a12fe0ef          	jal	810018d6 <myproc>
    810036c8:	15053503          	ld	a0,336(a0)
    810036cc:	a85ff0ef          	jal	81003150 <idup>
    810036d0:	8a2a                	mv	s4,a0
  while(*path == '/')
    810036d2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    810036d6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    810036d8:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    810036da:	4b85                	li	s7,1
    810036dc:	a879                	j	8100377a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    810036de:	4585                	li	a1,1
    810036e0:	852e                	mv	a0,a1
    810036e2:	fc4ff0ef          	jal	81002ea6 <iget>
    810036e6:	8a2a                	mv	s4,a0
    810036e8:	b7ed                	j	810036d2 <namex+0x3c>
      iunlockput(ip);
    810036ea:	8552                	mv	a0,s4
    810036ec:	ca5ff0ef          	jal	81003390 <iunlockput>
      return 0;
    810036f0:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    810036f2:	8552                	mv	a0,s4
    810036f4:	60e6                	ld	ra,88(sp)
    810036f6:	6446                	ld	s0,80(sp)
    810036f8:	64a6                	ld	s1,72(sp)
    810036fa:	6906                	ld	s2,64(sp)
    810036fc:	79e2                	ld	s3,56(sp)
    810036fe:	7a42                	ld	s4,48(sp)
    81003700:	7aa2                	ld	s5,40(sp)
    81003702:	7b02                	ld	s6,32(sp)
    81003704:	6be2                	ld	s7,24(sp)
    81003706:	6c42                	ld	s8,16(sp)
    81003708:	6ca2                	ld	s9,8(sp)
    8100370a:	6d02                	ld	s10,0(sp)
    8100370c:	6125                	addi	sp,sp,96
    8100370e:	8082                	ret
      iunlock(ip);
    81003710:	8552                	mv	a0,s4
    81003712:	b23ff0ef          	jal	81003234 <iunlock>
      return ip;
    81003716:	bff1                	j	810036f2 <namex+0x5c>
      iunlockput(ip);
    81003718:	8552                	mv	a0,s4
    8100371a:	c77ff0ef          	jal	81003390 <iunlockput>
      return 0;
    8100371e:	8a4e                	mv	s4,s3
    81003720:	bfc9                	j	810036f2 <namex+0x5c>
  len = path - s;
    81003722:	40998633          	sub	a2,s3,s1
    81003726:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8100372a:	09ac5063          	bge	s8,s10,810037aa <namex+0x114>
    memmove(name, s, DIRSIZ);
    8100372e:	8666                	mv	a2,s9
    81003730:	85a6                	mv	a1,s1
    81003732:	8556                	mv	a0,s5
    81003734:	e0cfd0ef          	jal	81000d40 <memmove>
    81003738:	84ce                	mv	s1,s3
  while(*path == '/')
    8100373a:	0004c783          	lbu	a5,0(s1)
    8100373e:	01279763          	bne	a5,s2,8100374c <namex+0xb6>
    path++;
    81003742:	0485                	addi	s1,s1,1
  while(*path == '/')
    81003744:	0004c783          	lbu	a5,0(s1)
    81003748:	ff278de3          	beq	a5,s2,81003742 <namex+0xac>
    ilock(ip);
    8100374c:	8552                	mv	a0,s4
    8100374e:	a39ff0ef          	jal	81003186 <ilock>
    if(ip->type != T_DIR){
    81003752:	044a1783          	lh	a5,68(s4)
    81003756:	f9779ae3          	bne	a5,s7,810036ea <namex+0x54>
    if(nameiparent && *path == '\0'){
    8100375a:	000b0563          	beqz	s6,81003764 <namex+0xce>
    8100375e:	0004c783          	lbu	a5,0(s1)
    81003762:	d7dd                	beqz	a5,81003710 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    81003764:	4601                	li	a2,0
    81003766:	85d6                	mv	a1,s5
    81003768:	8552                	mv	a0,s4
    8100376a:	e81ff0ef          	jal	810035ea <dirlookup>
    8100376e:	89aa                	mv	s3,a0
    81003770:	d545                	beqz	a0,81003718 <namex+0x82>
    iunlockput(ip);
    81003772:	8552                	mv	a0,s4
    81003774:	c1dff0ef          	jal	81003390 <iunlockput>
    ip = next;
    81003778:	8a4e                	mv	s4,s3
  while(*path == '/')
    8100377a:	0004c783          	lbu	a5,0(s1)
    8100377e:	01279763          	bne	a5,s2,8100378c <namex+0xf6>
    path++;
    81003782:	0485                	addi	s1,s1,1
  while(*path == '/')
    81003784:	0004c783          	lbu	a5,0(s1)
    81003788:	ff278de3          	beq	a5,s2,81003782 <namex+0xec>
  if(*path == 0)
    8100378c:	cb8d                	beqz	a5,810037be <namex+0x128>
  while(*path != '/' && *path != 0)
    8100378e:	0004c783          	lbu	a5,0(s1)
    81003792:	89a6                	mv	s3,s1
  len = path - s;
    81003794:	4d01                	li	s10,0
    81003796:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    81003798:	01278963          	beq	a5,s2,810037aa <namex+0x114>
    8100379c:	d3d9                	beqz	a5,81003722 <namex+0x8c>
    path++;
    8100379e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    810037a0:	0009c783          	lbu	a5,0(s3)
    810037a4:	ff279ce3          	bne	a5,s2,8100379c <namex+0x106>
    810037a8:	bfad                	j	81003722 <namex+0x8c>
    memmove(name, s, len);
    810037aa:	2601                	sext.w	a2,a2
    810037ac:	85a6                	mv	a1,s1
    810037ae:	8556                	mv	a0,s5
    810037b0:	d90fd0ef          	jal	81000d40 <memmove>
    name[len] = 0;
    810037b4:	9d56                	add	s10,s10,s5
    810037b6:	000d0023          	sb	zero,0(s10)
    810037ba:	84ce                	mv	s1,s3
    810037bc:	bfbd                	j	8100373a <namex+0xa4>
  if(nameiparent){
    810037be:	f20b0ae3          	beqz	s6,810036f2 <namex+0x5c>
    iput(ip);
    810037c2:	8552                	mv	a0,s4
    810037c4:	b45ff0ef          	jal	81003308 <iput>
    return 0;
    810037c8:	4a01                	li	s4,0
    810037ca:	b725                	j	810036f2 <namex+0x5c>

00000000810037cc <dirlink>:
{
    810037cc:	715d                	addi	sp,sp,-80
    810037ce:	e486                	sd	ra,72(sp)
    810037d0:	e0a2                	sd	s0,64(sp)
    810037d2:	f84a                	sd	s2,48(sp)
    810037d4:	ec56                	sd	s5,24(sp)
    810037d6:	e85a                	sd	s6,16(sp)
    810037d8:	0880                	addi	s0,sp,80
    810037da:	892a                	mv	s2,a0
    810037dc:	8aae                	mv	s5,a1
    810037de:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    810037e0:	4601                	li	a2,0
    810037e2:	e09ff0ef          	jal	810035ea <dirlookup>
    810037e6:	ed1d                	bnez	a0,81003824 <dirlink+0x58>
    810037e8:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    810037ea:	04c92483          	lw	s1,76(s2)
    810037ee:	c4b9                	beqz	s1,8100383c <dirlink+0x70>
    810037f0:	f44e                	sd	s3,40(sp)
    810037f2:	f052                	sd	s4,32(sp)
    810037f4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    810037f6:	fb040a13          	addi	s4,s0,-80
    810037fa:	49c1                	li	s3,16
    810037fc:	874e                	mv	a4,s3
    810037fe:	86a6                	mv	a3,s1
    81003800:	8652                	mv	a2,s4
    81003802:	4581                	li	a1,0
    81003804:	854a                	mv	a0,s2
    81003806:	bd9ff0ef          	jal	810033de <readi>
    8100380a:	03351163          	bne	a0,s3,8100382c <dirlink+0x60>
    if(de.inum == 0)
    8100380e:	fb045783          	lhu	a5,-80(s0)
    81003812:	c39d                	beqz	a5,81003838 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    81003814:	24c1                	addiw	s1,s1,16
    81003816:	04c92783          	lw	a5,76(s2)
    8100381a:	fef4e1e3          	bltu	s1,a5,810037fc <dirlink+0x30>
    8100381e:	79a2                	ld	s3,40(sp)
    81003820:	7a02                	ld	s4,32(sp)
    81003822:	a829                	j	8100383c <dirlink+0x70>
    iput(ip);
    81003824:	ae5ff0ef          	jal	81003308 <iput>
    return -1;
    81003828:	557d                	li	a0,-1
    8100382a:	a83d                	j	81003868 <dirlink+0x9c>
      panic("dirlink read");
    8100382c:	00004517          	auipc	a0,0x4
    81003830:	d1c50513          	addi	a0,a0,-740 # 81007548 <etext+0x548>
    81003834:	f75fc0ef          	jal	810007a8 <panic>
    81003838:	79a2                	ld	s3,40(sp)
    8100383a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8100383c:	4639                	li	a2,14
    8100383e:	85d6                	mv	a1,s5
    81003840:	fb240513          	addi	a0,s0,-78
    81003844:	daafd0ef          	jal	81000dee <strncpy>
  de.inum = inum;
    81003848:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8100384c:	4741                	li	a4,16
    8100384e:	86a6                	mv	a3,s1
    81003850:	fb040613          	addi	a2,s0,-80
    81003854:	4581                	li	a1,0
    81003856:	854a                	mv	a0,s2
    81003858:	c79ff0ef          	jal	810034d0 <writei>
    8100385c:	1541                	addi	a0,a0,-16
    8100385e:	00a03533          	snez	a0,a0
    81003862:	40a0053b          	negw	a0,a0
    81003866:	74e2                	ld	s1,56(sp)
}
    81003868:	60a6                	ld	ra,72(sp)
    8100386a:	6406                	ld	s0,64(sp)
    8100386c:	7942                	ld	s2,48(sp)
    8100386e:	6ae2                	ld	s5,24(sp)
    81003870:	6b42                	ld	s6,16(sp)
    81003872:	6161                	addi	sp,sp,80
    81003874:	8082                	ret

0000000081003876 <namei>:

struct inode*
namei(char *path)
{
    81003876:	1101                	addi	sp,sp,-32
    81003878:	ec06                	sd	ra,24(sp)
    8100387a:	e822                	sd	s0,16(sp)
    8100387c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8100387e:	fe040613          	addi	a2,s0,-32
    81003882:	4581                	li	a1,0
    81003884:	e13ff0ef          	jal	81003696 <namex>
}
    81003888:	60e2                	ld	ra,24(sp)
    8100388a:	6442                	ld	s0,16(sp)
    8100388c:	6105                	addi	sp,sp,32
    8100388e:	8082                	ret

0000000081003890 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    81003890:	1141                	addi	sp,sp,-16
    81003892:	e406                	sd	ra,8(sp)
    81003894:	e022                	sd	s0,0(sp)
    81003896:	0800                	addi	s0,sp,16
    81003898:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8100389a:	4585                	li	a1,1
    8100389c:	dfbff0ef          	jal	81003696 <namex>
}
    810038a0:	60a2                	ld	ra,8(sp)
    810038a2:	6402                	ld	s0,0(sp)
    810038a4:	0141                	addi	sp,sp,16
    810038a6:	8082                	ret

00000000810038a8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    810038a8:	1101                	addi	sp,sp,-32
    810038aa:	ec06                	sd	ra,24(sp)
    810038ac:	e822                	sd	s0,16(sp)
    810038ae:	e426                	sd	s1,8(sp)
    810038b0:	e04a                	sd	s2,0(sp)
    810038b2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    810038b4:	00014917          	auipc	s2,0x14
    810038b8:	14c90913          	addi	s2,s2,332 # 81017a00 <log>
    810038bc:	01892583          	lw	a1,24(s2)
    810038c0:	02892503          	lw	a0,40(s2)
    810038c4:	9b0ff0ef          	jal	81002a74 <bread>
    810038c8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    810038ca:	02c92603          	lw	a2,44(s2)
    810038ce:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    810038d0:	00c05f63          	blez	a2,810038ee <write_head+0x46>
    810038d4:	00014717          	auipc	a4,0x14
    810038d8:	15c70713          	addi	a4,a4,348 # 81017a30 <log+0x30>
    810038dc:	87aa                	mv	a5,a0
    810038de:	060a                	slli	a2,a2,0x2
    810038e0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    810038e2:	4314                	lw	a3,0(a4)
    810038e4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    810038e6:	0711                	addi	a4,a4,4
    810038e8:	0791                	addi	a5,a5,4
    810038ea:	fec79ce3          	bne	a5,a2,810038e2 <write_head+0x3a>
  }
  bwrite(buf);
    810038ee:	8526                	mv	a0,s1
    810038f0:	a5aff0ef          	jal	81002b4a <bwrite>
  brelse(buf);
    810038f4:	8526                	mv	a0,s1
    810038f6:	a86ff0ef          	jal	81002b7c <brelse>
}
    810038fa:	60e2                	ld	ra,24(sp)
    810038fc:	6442                	ld	s0,16(sp)
    810038fe:	64a2                	ld	s1,8(sp)
    81003900:	6902                	ld	s2,0(sp)
    81003902:	6105                	addi	sp,sp,32
    81003904:	8082                	ret

0000000081003906 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    81003906:	00014797          	auipc	a5,0x14
    8100390a:	1267a783          	lw	a5,294(a5) # 81017a2c <log+0x2c>
    8100390e:	0af05263          	blez	a5,810039b2 <install_trans+0xac>
{
    81003912:	715d                	addi	sp,sp,-80
    81003914:	e486                	sd	ra,72(sp)
    81003916:	e0a2                	sd	s0,64(sp)
    81003918:	fc26                	sd	s1,56(sp)
    8100391a:	f84a                	sd	s2,48(sp)
    8100391c:	f44e                	sd	s3,40(sp)
    8100391e:	f052                	sd	s4,32(sp)
    81003920:	ec56                	sd	s5,24(sp)
    81003922:	e85a                	sd	s6,16(sp)
    81003924:	e45e                	sd	s7,8(sp)
    81003926:	0880                	addi	s0,sp,80
    81003928:	8b2a                	mv	s6,a0
    8100392a:	00014a97          	auipc	s5,0x14
    8100392e:	106a8a93          	addi	s5,s5,262 # 81017a30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    81003932:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    81003934:	00014997          	auipc	s3,0x14
    81003938:	0cc98993          	addi	s3,s3,204 # 81017a00 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8100393c:	40000b93          	li	s7,1024
    81003940:	a829                	j	8100395a <install_trans+0x54>
    brelse(lbuf);
    81003942:	854a                	mv	a0,s2
    81003944:	a38ff0ef          	jal	81002b7c <brelse>
    brelse(dbuf);
    81003948:	8526                	mv	a0,s1
    8100394a:	a32ff0ef          	jal	81002b7c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8100394e:	2a05                	addiw	s4,s4,1
    81003950:	0a91                	addi	s5,s5,4
    81003952:	02c9a783          	lw	a5,44(s3)
    81003956:	04fa5363          	bge	s4,a5,8100399c <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8100395a:	0189a583          	lw	a1,24(s3)
    8100395e:	014585bb          	addw	a1,a1,s4
    81003962:	2585                	addiw	a1,a1,1
    81003964:	0289a503          	lw	a0,40(s3)
    81003968:	90cff0ef          	jal	81002a74 <bread>
    8100396c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8100396e:	000aa583          	lw	a1,0(s5)
    81003972:	0289a503          	lw	a0,40(s3)
    81003976:	8feff0ef          	jal	81002a74 <bread>
    8100397a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8100397c:	865e                	mv	a2,s7
    8100397e:	05890593          	addi	a1,s2,88
    81003982:	05850513          	addi	a0,a0,88
    81003986:	bbafd0ef          	jal	81000d40 <memmove>
    bwrite(dbuf);  // write dst to disk
    8100398a:	8526                	mv	a0,s1
    8100398c:	9beff0ef          	jal	81002b4a <bwrite>
    if(recovering == 0)
    81003990:	fa0b19e3          	bnez	s6,81003942 <install_trans+0x3c>
      bunpin(dbuf);
    81003994:	8526                	mv	a0,s1
    81003996:	a9eff0ef          	jal	81002c34 <bunpin>
    8100399a:	b765                	j	81003942 <install_trans+0x3c>
}
    8100399c:	60a6                	ld	ra,72(sp)
    8100399e:	6406                	ld	s0,64(sp)
    810039a0:	74e2                	ld	s1,56(sp)
    810039a2:	7942                	ld	s2,48(sp)
    810039a4:	79a2                	ld	s3,40(sp)
    810039a6:	7a02                	ld	s4,32(sp)
    810039a8:	6ae2                	ld	s5,24(sp)
    810039aa:	6b42                	ld	s6,16(sp)
    810039ac:	6ba2                	ld	s7,8(sp)
    810039ae:	6161                	addi	sp,sp,80
    810039b0:	8082                	ret
    810039b2:	8082                	ret

00000000810039b4 <initlog>:
{
    810039b4:	7179                	addi	sp,sp,-48
    810039b6:	f406                	sd	ra,40(sp)
    810039b8:	f022                	sd	s0,32(sp)
    810039ba:	ec26                	sd	s1,24(sp)
    810039bc:	e84a                	sd	s2,16(sp)
    810039be:	e44e                	sd	s3,8(sp)
    810039c0:	1800                	addi	s0,sp,48
    810039c2:	892a                	mv	s2,a0
    810039c4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    810039c6:	00014497          	auipc	s1,0x14
    810039ca:	03a48493          	addi	s1,s1,58 # 81017a00 <log>
    810039ce:	00004597          	auipc	a1,0x4
    810039d2:	b8a58593          	addi	a1,a1,-1142 # 81007558 <etext+0x558>
    810039d6:	8526                	mv	a0,s1
    810039d8:	9b0fd0ef          	jal	81000b88 <initlock>
  log.start = sb->logstart;
    810039dc:	0149a583          	lw	a1,20(s3)
    810039e0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    810039e2:	0109a783          	lw	a5,16(s3)
    810039e6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    810039e8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    810039ec:	854a                	mv	a0,s2
    810039ee:	886ff0ef          	jal	81002a74 <bread>
  log.lh.n = lh->n;
    810039f2:	4d30                	lw	a2,88(a0)
    810039f4:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    810039f6:	00c05f63          	blez	a2,81003a14 <initlog+0x60>
    810039fa:	87aa                	mv	a5,a0
    810039fc:	00014717          	auipc	a4,0x14
    81003a00:	03470713          	addi	a4,a4,52 # 81017a30 <log+0x30>
    81003a04:	060a                	slli	a2,a2,0x2
    81003a06:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    81003a08:	4ff4                	lw	a3,92(a5)
    81003a0a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    81003a0c:	0791                	addi	a5,a5,4
    81003a0e:	0711                	addi	a4,a4,4
    81003a10:	fec79ce3          	bne	a5,a2,81003a08 <initlog+0x54>
  brelse(buf);
    81003a14:	968ff0ef          	jal	81002b7c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    81003a18:	4505                	li	a0,1
    81003a1a:	eedff0ef          	jal	81003906 <install_trans>
  log.lh.n = 0;
    81003a1e:	00014797          	auipc	a5,0x14
    81003a22:	0007a723          	sw	zero,14(a5) # 81017a2c <log+0x2c>
  write_head(); // clear the log
    81003a26:	e83ff0ef          	jal	810038a8 <write_head>
}
    81003a2a:	70a2                	ld	ra,40(sp)
    81003a2c:	7402                	ld	s0,32(sp)
    81003a2e:	64e2                	ld	s1,24(sp)
    81003a30:	6942                	ld	s2,16(sp)
    81003a32:	69a2                	ld	s3,8(sp)
    81003a34:	6145                	addi	sp,sp,48
    81003a36:	8082                	ret

0000000081003a38 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    81003a38:	1101                	addi	sp,sp,-32
    81003a3a:	ec06                	sd	ra,24(sp)
    81003a3c:	e822                	sd	s0,16(sp)
    81003a3e:	e426                	sd	s1,8(sp)
    81003a40:	e04a                	sd	s2,0(sp)
    81003a42:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    81003a44:	00014517          	auipc	a0,0x14
    81003a48:	fbc50513          	addi	a0,a0,-68 # 81017a00 <log>
    81003a4c:	9c0fd0ef          	jal	81000c0c <acquire>
  while(1){
    if(log.committing){
    81003a50:	00014497          	auipc	s1,0x14
    81003a54:	fb048493          	addi	s1,s1,-80 # 81017a00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    81003a58:	4979                	li	s2,30
    81003a5a:	a029                	j	81003a64 <begin_op+0x2c>
      sleep(&log, &log.lock);
    81003a5c:	85a6                	mv	a1,s1
    81003a5e:	8526                	mv	a0,s1
    81003a60:	c44fe0ef          	jal	81001ea4 <sleep>
    if(log.committing){
    81003a64:	50dc                	lw	a5,36(s1)
    81003a66:	fbfd                	bnez	a5,81003a5c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    81003a68:	5098                	lw	a4,32(s1)
    81003a6a:	2705                	addiw	a4,a4,1
    81003a6c:	0027179b          	slliw	a5,a4,0x2
    81003a70:	9fb9                	addw	a5,a5,a4
    81003a72:	0017979b          	slliw	a5,a5,0x1
    81003a76:	54d4                	lw	a3,44(s1)
    81003a78:	9fb5                	addw	a5,a5,a3
    81003a7a:	00f95763          	bge	s2,a5,81003a88 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    81003a7e:	85a6                	mv	a1,s1
    81003a80:	8526                	mv	a0,s1
    81003a82:	c22fe0ef          	jal	81001ea4 <sleep>
    81003a86:	bff9                	j	81003a64 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    81003a88:	00014517          	auipc	a0,0x14
    81003a8c:	f7850513          	addi	a0,a0,-136 # 81017a00 <log>
    81003a90:	d118                	sw	a4,32(a0)
      release(&log.lock);
    81003a92:	a0efd0ef          	jal	81000ca0 <release>
      break;
    }
  }
}
    81003a96:	60e2                	ld	ra,24(sp)
    81003a98:	6442                	ld	s0,16(sp)
    81003a9a:	64a2                	ld	s1,8(sp)
    81003a9c:	6902                	ld	s2,0(sp)
    81003a9e:	6105                	addi	sp,sp,32
    81003aa0:	8082                	ret

0000000081003aa2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    81003aa2:	7139                	addi	sp,sp,-64
    81003aa4:	fc06                	sd	ra,56(sp)
    81003aa6:	f822                	sd	s0,48(sp)
    81003aa8:	f426                	sd	s1,40(sp)
    81003aaa:	f04a                	sd	s2,32(sp)
    81003aac:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    81003aae:	00014497          	auipc	s1,0x14
    81003ab2:	f5248493          	addi	s1,s1,-174 # 81017a00 <log>
    81003ab6:	8526                	mv	a0,s1
    81003ab8:	954fd0ef          	jal	81000c0c <acquire>
  log.outstanding -= 1;
    81003abc:	509c                	lw	a5,32(s1)
    81003abe:	37fd                	addiw	a5,a5,-1
    81003ac0:	893e                	mv	s2,a5
    81003ac2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    81003ac4:	50dc                	lw	a5,36(s1)
    81003ac6:	ef9d                	bnez	a5,81003b04 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    81003ac8:	04091863          	bnez	s2,81003b18 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    81003acc:	00014497          	auipc	s1,0x14
    81003ad0:	f3448493          	addi	s1,s1,-204 # 81017a00 <log>
    81003ad4:	4785                	li	a5,1
    81003ad6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    81003ad8:	8526                	mv	a0,s1
    81003ada:	9c6fd0ef          	jal	81000ca0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    81003ade:	54dc                	lw	a5,44(s1)
    81003ae0:	04f04c63          	bgtz	a5,81003b38 <end_op+0x96>
    acquire(&log.lock);
    81003ae4:	00014497          	auipc	s1,0x14
    81003ae8:	f1c48493          	addi	s1,s1,-228 # 81017a00 <log>
    81003aec:	8526                	mv	a0,s1
    81003aee:	91efd0ef          	jal	81000c0c <acquire>
    log.committing = 0;
    81003af2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    81003af6:	8526                	mv	a0,s1
    81003af8:	bf8fe0ef          	jal	81001ef0 <wakeup>
    release(&log.lock);
    81003afc:	8526                	mv	a0,s1
    81003afe:	9a2fd0ef          	jal	81000ca0 <release>
}
    81003b02:	a02d                	j	81003b2c <end_op+0x8a>
    81003b04:	ec4e                	sd	s3,24(sp)
    81003b06:	e852                	sd	s4,16(sp)
    81003b08:	e456                	sd	s5,8(sp)
    81003b0a:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    81003b0c:	00004517          	auipc	a0,0x4
    81003b10:	a5450513          	addi	a0,a0,-1452 # 81007560 <etext+0x560>
    81003b14:	c95fc0ef          	jal	810007a8 <panic>
    wakeup(&log);
    81003b18:	00014497          	auipc	s1,0x14
    81003b1c:	ee848493          	addi	s1,s1,-280 # 81017a00 <log>
    81003b20:	8526                	mv	a0,s1
    81003b22:	bcefe0ef          	jal	81001ef0 <wakeup>
  release(&log.lock);
    81003b26:	8526                	mv	a0,s1
    81003b28:	978fd0ef          	jal	81000ca0 <release>
}
    81003b2c:	70e2                	ld	ra,56(sp)
    81003b2e:	7442                	ld	s0,48(sp)
    81003b30:	74a2                	ld	s1,40(sp)
    81003b32:	7902                	ld	s2,32(sp)
    81003b34:	6121                	addi	sp,sp,64
    81003b36:	8082                	ret
    81003b38:	ec4e                	sd	s3,24(sp)
    81003b3a:	e852                	sd	s4,16(sp)
    81003b3c:	e456                	sd	s5,8(sp)
    81003b3e:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    81003b40:	00014a97          	auipc	s5,0x14
    81003b44:	ef0a8a93          	addi	s5,s5,-272 # 81017a30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    81003b48:	00014a17          	auipc	s4,0x14
    81003b4c:	eb8a0a13          	addi	s4,s4,-328 # 81017a00 <log>
    memmove(to->data, from->data, BSIZE);
    81003b50:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    81003b54:	018a2583          	lw	a1,24(s4)
    81003b58:	012585bb          	addw	a1,a1,s2
    81003b5c:	2585                	addiw	a1,a1,1
    81003b5e:	028a2503          	lw	a0,40(s4)
    81003b62:	f13fe0ef          	jal	81002a74 <bread>
    81003b66:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    81003b68:	000aa583          	lw	a1,0(s5)
    81003b6c:	028a2503          	lw	a0,40(s4)
    81003b70:	f05fe0ef          	jal	81002a74 <bread>
    81003b74:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    81003b76:	865a                	mv	a2,s6
    81003b78:	05850593          	addi	a1,a0,88
    81003b7c:	05848513          	addi	a0,s1,88
    81003b80:	9c0fd0ef          	jal	81000d40 <memmove>
    bwrite(to);  // write the log
    81003b84:	8526                	mv	a0,s1
    81003b86:	fc5fe0ef          	jal	81002b4a <bwrite>
    brelse(from);
    81003b8a:	854e                	mv	a0,s3
    81003b8c:	ff1fe0ef          	jal	81002b7c <brelse>
    brelse(to);
    81003b90:	8526                	mv	a0,s1
    81003b92:	febfe0ef          	jal	81002b7c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    81003b96:	2905                	addiw	s2,s2,1
    81003b98:	0a91                	addi	s5,s5,4
    81003b9a:	02ca2783          	lw	a5,44(s4)
    81003b9e:	faf94be3          	blt	s2,a5,81003b54 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    81003ba2:	d07ff0ef          	jal	810038a8 <write_head>
    install_trans(0); // Now install writes to home locations
    81003ba6:	4501                	li	a0,0
    81003ba8:	d5fff0ef          	jal	81003906 <install_trans>
    log.lh.n = 0;
    81003bac:	00014797          	auipc	a5,0x14
    81003bb0:	e807a023          	sw	zero,-384(a5) # 81017a2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    81003bb4:	cf5ff0ef          	jal	810038a8 <write_head>
    81003bb8:	69e2                	ld	s3,24(sp)
    81003bba:	6a42                	ld	s4,16(sp)
    81003bbc:	6aa2                	ld	s5,8(sp)
    81003bbe:	6b02                	ld	s6,0(sp)
    81003bc0:	b715                	j	81003ae4 <end_op+0x42>

0000000081003bc2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    81003bc2:	1101                	addi	sp,sp,-32
    81003bc4:	ec06                	sd	ra,24(sp)
    81003bc6:	e822                	sd	s0,16(sp)
    81003bc8:	e426                	sd	s1,8(sp)
    81003bca:	e04a                	sd	s2,0(sp)
    81003bcc:	1000                	addi	s0,sp,32
    81003bce:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    81003bd0:	00014917          	auipc	s2,0x14
    81003bd4:	e3090913          	addi	s2,s2,-464 # 81017a00 <log>
    81003bd8:	854a                	mv	a0,s2
    81003bda:	832fd0ef          	jal	81000c0c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    81003bde:	02c92603          	lw	a2,44(s2)
    81003be2:	47f5                	li	a5,29
    81003be4:	06c7c363          	blt	a5,a2,81003c4a <log_write+0x88>
    81003be8:	00014797          	auipc	a5,0x14
    81003bec:	e347a783          	lw	a5,-460(a5) # 81017a1c <log+0x1c>
    81003bf0:	37fd                	addiw	a5,a5,-1
    81003bf2:	04f65c63          	bge	a2,a5,81003c4a <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    81003bf6:	00014797          	auipc	a5,0x14
    81003bfa:	e2a7a783          	lw	a5,-470(a5) # 81017a20 <log+0x20>
    81003bfe:	04f05c63          	blez	a5,81003c56 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    81003c02:	4781                	li	a5,0
    81003c04:	04c05f63          	blez	a2,81003c62 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    81003c08:	44cc                	lw	a1,12(s1)
    81003c0a:	00014717          	auipc	a4,0x14
    81003c0e:	e2670713          	addi	a4,a4,-474 # 81017a30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    81003c12:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    81003c14:	4314                	lw	a3,0(a4)
    81003c16:	04b68663          	beq	a3,a1,81003c62 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    81003c1a:	2785                	addiw	a5,a5,1
    81003c1c:	0711                	addi	a4,a4,4
    81003c1e:	fef61be3          	bne	a2,a5,81003c14 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    81003c22:	0621                	addi	a2,a2,8
    81003c24:	060a                	slli	a2,a2,0x2
    81003c26:	00014797          	auipc	a5,0x14
    81003c2a:	dda78793          	addi	a5,a5,-550 # 81017a00 <log>
    81003c2e:	97b2                	add	a5,a5,a2
    81003c30:	44d8                	lw	a4,12(s1)
    81003c32:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    81003c34:	8526                	mv	a0,s1
    81003c36:	fcbfe0ef          	jal	81002c00 <bpin>
    log.lh.n++;
    81003c3a:	00014717          	auipc	a4,0x14
    81003c3e:	dc670713          	addi	a4,a4,-570 # 81017a00 <log>
    81003c42:	575c                	lw	a5,44(a4)
    81003c44:	2785                	addiw	a5,a5,1
    81003c46:	d75c                	sw	a5,44(a4)
    81003c48:	a80d                	j	81003c7a <log_write+0xb8>
    panic("too big a transaction");
    81003c4a:	00004517          	auipc	a0,0x4
    81003c4e:	92650513          	addi	a0,a0,-1754 # 81007570 <etext+0x570>
    81003c52:	b57fc0ef          	jal	810007a8 <panic>
    panic("log_write outside of trans");
    81003c56:	00004517          	auipc	a0,0x4
    81003c5a:	93250513          	addi	a0,a0,-1742 # 81007588 <etext+0x588>
    81003c5e:	b4bfc0ef          	jal	810007a8 <panic>
  log.lh.block[i] = b->blockno;
    81003c62:	00878693          	addi	a3,a5,8
    81003c66:	068a                	slli	a3,a3,0x2
    81003c68:	00014717          	auipc	a4,0x14
    81003c6c:	d9870713          	addi	a4,a4,-616 # 81017a00 <log>
    81003c70:	9736                	add	a4,a4,a3
    81003c72:	44d4                	lw	a3,12(s1)
    81003c74:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    81003c76:	faf60fe3          	beq	a2,a5,81003c34 <log_write+0x72>
  }
  release(&log.lock);
    81003c7a:	00014517          	auipc	a0,0x14
    81003c7e:	d8650513          	addi	a0,a0,-634 # 81017a00 <log>
    81003c82:	81efd0ef          	jal	81000ca0 <release>
}
    81003c86:	60e2                	ld	ra,24(sp)
    81003c88:	6442                	ld	s0,16(sp)
    81003c8a:	64a2                	ld	s1,8(sp)
    81003c8c:	6902                	ld	s2,0(sp)
    81003c8e:	6105                	addi	sp,sp,32
    81003c90:	8082                	ret

0000000081003c92 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    81003c92:	1101                	addi	sp,sp,-32
    81003c94:	ec06                	sd	ra,24(sp)
    81003c96:	e822                	sd	s0,16(sp)
    81003c98:	e426                	sd	s1,8(sp)
    81003c9a:	e04a                	sd	s2,0(sp)
    81003c9c:	1000                	addi	s0,sp,32
    81003c9e:	84aa                	mv	s1,a0
    81003ca0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    81003ca2:	00004597          	auipc	a1,0x4
    81003ca6:	90658593          	addi	a1,a1,-1786 # 810075a8 <etext+0x5a8>
    81003caa:	0521                	addi	a0,a0,8
    81003cac:	eddfc0ef          	jal	81000b88 <initlock>
  lk->name = name;
    81003cb0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    81003cb4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    81003cb8:	0204a423          	sw	zero,40(s1)
}
    81003cbc:	60e2                	ld	ra,24(sp)
    81003cbe:	6442                	ld	s0,16(sp)
    81003cc0:	64a2                	ld	s1,8(sp)
    81003cc2:	6902                	ld	s2,0(sp)
    81003cc4:	6105                	addi	sp,sp,32
    81003cc6:	8082                	ret

0000000081003cc8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    81003cc8:	1101                	addi	sp,sp,-32
    81003cca:	ec06                	sd	ra,24(sp)
    81003ccc:	e822                	sd	s0,16(sp)
    81003cce:	e426                	sd	s1,8(sp)
    81003cd0:	e04a                	sd	s2,0(sp)
    81003cd2:	1000                	addi	s0,sp,32
    81003cd4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    81003cd6:	00850913          	addi	s2,a0,8
    81003cda:	854a                	mv	a0,s2
    81003cdc:	f31fc0ef          	jal	81000c0c <acquire>
  while (lk->locked) {
    81003ce0:	409c                	lw	a5,0(s1)
    81003ce2:	c799                	beqz	a5,81003cf0 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    81003ce4:	85ca                	mv	a1,s2
    81003ce6:	8526                	mv	a0,s1
    81003ce8:	9bcfe0ef          	jal	81001ea4 <sleep>
  while (lk->locked) {
    81003cec:	409c                	lw	a5,0(s1)
    81003cee:	fbfd                	bnez	a5,81003ce4 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    81003cf0:	4785                	li	a5,1
    81003cf2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    81003cf4:	be3fd0ef          	jal	810018d6 <myproc>
    81003cf8:	591c                	lw	a5,48(a0)
    81003cfa:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    81003cfc:	854a                	mv	a0,s2
    81003cfe:	fa3fc0ef          	jal	81000ca0 <release>
}
    81003d02:	60e2                	ld	ra,24(sp)
    81003d04:	6442                	ld	s0,16(sp)
    81003d06:	64a2                	ld	s1,8(sp)
    81003d08:	6902                	ld	s2,0(sp)
    81003d0a:	6105                	addi	sp,sp,32
    81003d0c:	8082                	ret

0000000081003d0e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    81003d0e:	1101                	addi	sp,sp,-32
    81003d10:	ec06                	sd	ra,24(sp)
    81003d12:	e822                	sd	s0,16(sp)
    81003d14:	e426                	sd	s1,8(sp)
    81003d16:	e04a                	sd	s2,0(sp)
    81003d18:	1000                	addi	s0,sp,32
    81003d1a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    81003d1c:	00850913          	addi	s2,a0,8
    81003d20:	854a                	mv	a0,s2
    81003d22:	eebfc0ef          	jal	81000c0c <acquire>
  lk->locked = 0;
    81003d26:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    81003d2a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    81003d2e:	8526                	mv	a0,s1
    81003d30:	9c0fe0ef          	jal	81001ef0 <wakeup>
  release(&lk->lk);
    81003d34:	854a                	mv	a0,s2
    81003d36:	f6bfc0ef          	jal	81000ca0 <release>
}
    81003d3a:	60e2                	ld	ra,24(sp)
    81003d3c:	6442                	ld	s0,16(sp)
    81003d3e:	64a2                	ld	s1,8(sp)
    81003d40:	6902                	ld	s2,0(sp)
    81003d42:	6105                	addi	sp,sp,32
    81003d44:	8082                	ret

0000000081003d46 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    81003d46:	7179                	addi	sp,sp,-48
    81003d48:	f406                	sd	ra,40(sp)
    81003d4a:	f022                	sd	s0,32(sp)
    81003d4c:	ec26                	sd	s1,24(sp)
    81003d4e:	e84a                	sd	s2,16(sp)
    81003d50:	1800                	addi	s0,sp,48
    81003d52:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    81003d54:	00850913          	addi	s2,a0,8
    81003d58:	854a                	mv	a0,s2
    81003d5a:	eb3fc0ef          	jal	81000c0c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    81003d5e:	409c                	lw	a5,0(s1)
    81003d60:	ef81                	bnez	a5,81003d78 <holdingsleep+0x32>
    81003d62:	4481                	li	s1,0
  release(&lk->lk);
    81003d64:	854a                	mv	a0,s2
    81003d66:	f3bfc0ef          	jal	81000ca0 <release>
  return r;
}
    81003d6a:	8526                	mv	a0,s1
    81003d6c:	70a2                	ld	ra,40(sp)
    81003d6e:	7402                	ld	s0,32(sp)
    81003d70:	64e2                	ld	s1,24(sp)
    81003d72:	6942                	ld	s2,16(sp)
    81003d74:	6145                	addi	sp,sp,48
    81003d76:	8082                	ret
    81003d78:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    81003d7a:	0284a983          	lw	s3,40(s1)
    81003d7e:	b59fd0ef          	jal	810018d6 <myproc>
    81003d82:	5904                	lw	s1,48(a0)
    81003d84:	413484b3          	sub	s1,s1,s3
    81003d88:	0014b493          	seqz	s1,s1
    81003d8c:	69a2                	ld	s3,8(sp)
    81003d8e:	bfd9                	j	81003d64 <holdingsleep+0x1e>

0000000081003d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    81003d90:	1141                	addi	sp,sp,-16
    81003d92:	e406                	sd	ra,8(sp)
    81003d94:	e022                	sd	s0,0(sp)
    81003d96:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    81003d98:	00004597          	auipc	a1,0x4
    81003d9c:	82058593          	addi	a1,a1,-2016 # 810075b8 <etext+0x5b8>
    81003da0:	00014517          	auipc	a0,0x14
    81003da4:	da850513          	addi	a0,a0,-600 # 81017b48 <ftable>
    81003da8:	de1fc0ef          	jal	81000b88 <initlock>
}
    81003dac:	60a2                	ld	ra,8(sp)
    81003dae:	6402                	ld	s0,0(sp)
    81003db0:	0141                	addi	sp,sp,16
    81003db2:	8082                	ret

0000000081003db4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    81003db4:	1101                	addi	sp,sp,-32
    81003db6:	ec06                	sd	ra,24(sp)
    81003db8:	e822                	sd	s0,16(sp)
    81003dba:	e426                	sd	s1,8(sp)
    81003dbc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    81003dbe:	00014517          	auipc	a0,0x14
    81003dc2:	d8a50513          	addi	a0,a0,-630 # 81017b48 <ftable>
    81003dc6:	e47fc0ef          	jal	81000c0c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    81003dca:	00014497          	auipc	s1,0x14
    81003dce:	d9648493          	addi	s1,s1,-618 # 81017b60 <ftable+0x18>
    81003dd2:	00015717          	auipc	a4,0x15
    81003dd6:	d2e70713          	addi	a4,a4,-722 # 81018b00 <disk>
    if(f->ref == 0){
    81003dda:	40dc                	lw	a5,4(s1)
    81003ddc:	cf89                	beqz	a5,81003df6 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    81003dde:	02848493          	addi	s1,s1,40
    81003de2:	fee49ce3          	bne	s1,a4,81003dda <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    81003de6:	00014517          	auipc	a0,0x14
    81003dea:	d6250513          	addi	a0,a0,-670 # 81017b48 <ftable>
    81003dee:	eb3fc0ef          	jal	81000ca0 <release>
  return 0;
    81003df2:	4481                	li	s1,0
    81003df4:	a809                	j	81003e06 <filealloc+0x52>
      f->ref = 1;
    81003df6:	4785                	li	a5,1
    81003df8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    81003dfa:	00014517          	auipc	a0,0x14
    81003dfe:	d4e50513          	addi	a0,a0,-690 # 81017b48 <ftable>
    81003e02:	e9ffc0ef          	jal	81000ca0 <release>
}
    81003e06:	8526                	mv	a0,s1
    81003e08:	60e2                	ld	ra,24(sp)
    81003e0a:	6442                	ld	s0,16(sp)
    81003e0c:	64a2                	ld	s1,8(sp)
    81003e0e:	6105                	addi	sp,sp,32
    81003e10:	8082                	ret

0000000081003e12 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    81003e12:	1101                	addi	sp,sp,-32
    81003e14:	ec06                	sd	ra,24(sp)
    81003e16:	e822                	sd	s0,16(sp)
    81003e18:	e426                	sd	s1,8(sp)
    81003e1a:	1000                	addi	s0,sp,32
    81003e1c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    81003e1e:	00014517          	auipc	a0,0x14
    81003e22:	d2a50513          	addi	a0,a0,-726 # 81017b48 <ftable>
    81003e26:	de7fc0ef          	jal	81000c0c <acquire>
  if(f->ref < 1)
    81003e2a:	40dc                	lw	a5,4(s1)
    81003e2c:	02f05063          	blez	a5,81003e4c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    81003e30:	2785                	addiw	a5,a5,1
    81003e32:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    81003e34:	00014517          	auipc	a0,0x14
    81003e38:	d1450513          	addi	a0,a0,-748 # 81017b48 <ftable>
    81003e3c:	e65fc0ef          	jal	81000ca0 <release>
  return f;
}
    81003e40:	8526                	mv	a0,s1
    81003e42:	60e2                	ld	ra,24(sp)
    81003e44:	6442                	ld	s0,16(sp)
    81003e46:	64a2                	ld	s1,8(sp)
    81003e48:	6105                	addi	sp,sp,32
    81003e4a:	8082                	ret
    panic("filedup");
    81003e4c:	00003517          	auipc	a0,0x3
    81003e50:	77450513          	addi	a0,a0,1908 # 810075c0 <etext+0x5c0>
    81003e54:	955fc0ef          	jal	810007a8 <panic>

0000000081003e58 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    81003e58:	7139                	addi	sp,sp,-64
    81003e5a:	fc06                	sd	ra,56(sp)
    81003e5c:	f822                	sd	s0,48(sp)
    81003e5e:	f426                	sd	s1,40(sp)
    81003e60:	0080                	addi	s0,sp,64
    81003e62:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    81003e64:	00014517          	auipc	a0,0x14
    81003e68:	ce450513          	addi	a0,a0,-796 # 81017b48 <ftable>
    81003e6c:	da1fc0ef          	jal	81000c0c <acquire>
  if(f->ref < 1)
    81003e70:	40dc                	lw	a5,4(s1)
    81003e72:	04f05863          	blez	a5,81003ec2 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    81003e76:	37fd                	addiw	a5,a5,-1
    81003e78:	c0dc                	sw	a5,4(s1)
    81003e7a:	04f04e63          	bgtz	a5,81003ed6 <fileclose+0x7e>
    81003e7e:	f04a                	sd	s2,32(sp)
    81003e80:	ec4e                	sd	s3,24(sp)
    81003e82:	e852                	sd	s4,16(sp)
    81003e84:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    81003e86:	0004a903          	lw	s2,0(s1)
    81003e8a:	0094ca83          	lbu	s5,9(s1)
    81003e8e:	0104ba03          	ld	s4,16(s1)
    81003e92:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    81003e96:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    81003e9a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    81003e9e:	00014517          	auipc	a0,0x14
    81003ea2:	caa50513          	addi	a0,a0,-854 # 81017b48 <ftable>
    81003ea6:	dfbfc0ef          	jal	81000ca0 <release>

  if(ff.type == FD_PIPE){
    81003eaa:	4785                	li	a5,1
    81003eac:	04f90063          	beq	s2,a5,81003eec <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    81003eb0:	3979                	addiw	s2,s2,-2
    81003eb2:	4785                	li	a5,1
    81003eb4:	0527f563          	bgeu	a5,s2,81003efe <fileclose+0xa6>
    81003eb8:	7902                	ld	s2,32(sp)
    81003eba:	69e2                	ld	s3,24(sp)
    81003ebc:	6a42                	ld	s4,16(sp)
    81003ebe:	6aa2                	ld	s5,8(sp)
    81003ec0:	a00d                	j	81003ee2 <fileclose+0x8a>
    81003ec2:	f04a                	sd	s2,32(sp)
    81003ec4:	ec4e                	sd	s3,24(sp)
    81003ec6:	e852                	sd	s4,16(sp)
    81003ec8:	e456                	sd	s5,8(sp)
    panic("fileclose");
    81003eca:	00003517          	auipc	a0,0x3
    81003ece:	6fe50513          	addi	a0,a0,1790 # 810075c8 <etext+0x5c8>
    81003ed2:	8d7fc0ef          	jal	810007a8 <panic>
    release(&ftable.lock);
    81003ed6:	00014517          	auipc	a0,0x14
    81003eda:	c7250513          	addi	a0,a0,-910 # 81017b48 <ftable>
    81003ede:	dc3fc0ef          	jal	81000ca0 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    81003ee2:	70e2                	ld	ra,56(sp)
    81003ee4:	7442                	ld	s0,48(sp)
    81003ee6:	74a2                	ld	s1,40(sp)
    81003ee8:	6121                	addi	sp,sp,64
    81003eea:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    81003eec:	85d6                	mv	a1,s5
    81003eee:	8552                	mv	a0,s4
    81003ef0:	340000ef          	jal	81004230 <pipeclose>
    81003ef4:	7902                	ld	s2,32(sp)
    81003ef6:	69e2                	ld	s3,24(sp)
    81003ef8:	6a42                	ld	s4,16(sp)
    81003efa:	6aa2                	ld	s5,8(sp)
    81003efc:	b7dd                	j	81003ee2 <fileclose+0x8a>
    begin_op();
    81003efe:	b3bff0ef          	jal	81003a38 <begin_op>
    iput(ff.ip);
    81003f02:	854e                	mv	a0,s3
    81003f04:	c04ff0ef          	jal	81003308 <iput>
    end_op();
    81003f08:	b9bff0ef          	jal	81003aa2 <end_op>
    81003f0c:	7902                	ld	s2,32(sp)
    81003f0e:	69e2                	ld	s3,24(sp)
    81003f10:	6a42                	ld	s4,16(sp)
    81003f12:	6aa2                	ld	s5,8(sp)
    81003f14:	b7f9                	j	81003ee2 <fileclose+0x8a>

0000000081003f16 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    81003f16:	715d                	addi	sp,sp,-80
    81003f18:	e486                	sd	ra,72(sp)
    81003f1a:	e0a2                	sd	s0,64(sp)
    81003f1c:	fc26                	sd	s1,56(sp)
    81003f1e:	f44e                	sd	s3,40(sp)
    81003f20:	0880                	addi	s0,sp,80
    81003f22:	84aa                	mv	s1,a0
    81003f24:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    81003f26:	9b1fd0ef          	jal	810018d6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    81003f2a:	409c                	lw	a5,0(s1)
    81003f2c:	37f9                	addiw	a5,a5,-2
    81003f2e:	4705                	li	a4,1
    81003f30:	04f76263          	bltu	a4,a5,81003f74 <filestat+0x5e>
    81003f34:	f84a                	sd	s2,48(sp)
    81003f36:	f052                	sd	s4,32(sp)
    81003f38:	892a                	mv	s2,a0
    ilock(f->ip);
    81003f3a:	6c88                	ld	a0,24(s1)
    81003f3c:	a4aff0ef          	jal	81003186 <ilock>
    stati(f->ip, &st);
    81003f40:	fb840a13          	addi	s4,s0,-72
    81003f44:	85d2                	mv	a1,s4
    81003f46:	6c88                	ld	a0,24(s1)
    81003f48:	c68ff0ef          	jal	810033b0 <stati>
    iunlock(f->ip);
    81003f4c:	6c88                	ld	a0,24(s1)
    81003f4e:	ae6ff0ef          	jal	81003234 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    81003f52:	46e1                	li	a3,24
    81003f54:	8652                	mv	a2,s4
    81003f56:	85ce                	mv	a1,s3
    81003f58:	05093503          	ld	a0,80(s2)
    81003f5c:	e22fd0ef          	jal	8100157e <copyout>
    81003f60:	41f5551b          	sraiw	a0,a0,0x1f
    81003f64:	7942                	ld	s2,48(sp)
    81003f66:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    81003f68:	60a6                	ld	ra,72(sp)
    81003f6a:	6406                	ld	s0,64(sp)
    81003f6c:	74e2                	ld	s1,56(sp)
    81003f6e:	79a2                	ld	s3,40(sp)
    81003f70:	6161                	addi	sp,sp,80
    81003f72:	8082                	ret
  return -1;
    81003f74:	557d                	li	a0,-1
    81003f76:	bfcd                	j	81003f68 <filestat+0x52>

0000000081003f78 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    81003f78:	7179                	addi	sp,sp,-48
    81003f7a:	f406                	sd	ra,40(sp)
    81003f7c:	f022                	sd	s0,32(sp)
    81003f7e:	e84a                	sd	s2,16(sp)
    81003f80:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    81003f82:	00854783          	lbu	a5,8(a0)
    81003f86:	cfd1                	beqz	a5,81004022 <fileread+0xaa>
    81003f88:	ec26                	sd	s1,24(sp)
    81003f8a:	e44e                	sd	s3,8(sp)
    81003f8c:	84aa                	mv	s1,a0
    81003f8e:	89ae                	mv	s3,a1
    81003f90:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    81003f92:	411c                	lw	a5,0(a0)
    81003f94:	4705                	li	a4,1
    81003f96:	04e78363          	beq	a5,a4,81003fdc <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    81003f9a:	470d                	li	a4,3
    81003f9c:	04e78763          	beq	a5,a4,81003fea <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    81003fa0:	4709                	li	a4,2
    81003fa2:	06e79a63          	bne	a5,a4,81004016 <fileread+0x9e>
    ilock(f->ip);
    81003fa6:	6d08                	ld	a0,24(a0)
    81003fa8:	9deff0ef          	jal	81003186 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    81003fac:	874a                	mv	a4,s2
    81003fae:	5094                	lw	a3,32(s1)
    81003fb0:	864e                	mv	a2,s3
    81003fb2:	4585                	li	a1,1
    81003fb4:	6c88                	ld	a0,24(s1)
    81003fb6:	c28ff0ef          	jal	810033de <readi>
    81003fba:	892a                	mv	s2,a0
    81003fbc:	00a05563          	blez	a0,81003fc6 <fileread+0x4e>
      f->off += r;
    81003fc0:	509c                	lw	a5,32(s1)
    81003fc2:	9fa9                	addw	a5,a5,a0
    81003fc4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    81003fc6:	6c88                	ld	a0,24(s1)
    81003fc8:	a6cff0ef          	jal	81003234 <iunlock>
    81003fcc:	64e2                	ld	s1,24(sp)
    81003fce:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    81003fd0:	854a                	mv	a0,s2
    81003fd2:	70a2                	ld	ra,40(sp)
    81003fd4:	7402                	ld	s0,32(sp)
    81003fd6:	6942                	ld	s2,16(sp)
    81003fd8:	6145                	addi	sp,sp,48
    81003fda:	8082                	ret
    r = piperead(f->pipe, addr, n);
    81003fdc:	6908                	ld	a0,16(a0)
    81003fde:	3a2000ef          	jal	81004380 <piperead>
    81003fe2:	892a                	mv	s2,a0
    81003fe4:	64e2                	ld	s1,24(sp)
    81003fe6:	69a2                	ld	s3,8(sp)
    81003fe8:	b7e5                	j	81003fd0 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    81003fea:	02451783          	lh	a5,36(a0)
    81003fee:	03079693          	slli	a3,a5,0x30
    81003ff2:	92c1                	srli	a3,a3,0x30
    81003ff4:	4725                	li	a4,9
    81003ff6:	02d76863          	bltu	a4,a3,81004026 <fileread+0xae>
    81003ffa:	0792                	slli	a5,a5,0x4
    81003ffc:	00014717          	auipc	a4,0x14
    81004000:	aac70713          	addi	a4,a4,-1364 # 81017aa8 <devsw>
    81004004:	97ba                	add	a5,a5,a4
    81004006:	639c                	ld	a5,0(a5)
    81004008:	c39d                	beqz	a5,8100402e <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8100400a:	4505                	li	a0,1
    8100400c:	9782                	jalr	a5
    8100400e:	892a                	mv	s2,a0
    81004010:	64e2                	ld	s1,24(sp)
    81004012:	69a2                	ld	s3,8(sp)
    81004014:	bf75                	j	81003fd0 <fileread+0x58>
    panic("fileread");
    81004016:	00003517          	auipc	a0,0x3
    8100401a:	5c250513          	addi	a0,a0,1474 # 810075d8 <etext+0x5d8>
    8100401e:	f8afc0ef          	jal	810007a8 <panic>
    return -1;
    81004022:	597d                	li	s2,-1
    81004024:	b775                	j	81003fd0 <fileread+0x58>
      return -1;
    81004026:	597d                	li	s2,-1
    81004028:	64e2                	ld	s1,24(sp)
    8100402a:	69a2                	ld	s3,8(sp)
    8100402c:	b755                	j	81003fd0 <fileread+0x58>
    8100402e:	597d                	li	s2,-1
    81004030:	64e2                	ld	s1,24(sp)
    81004032:	69a2                	ld	s3,8(sp)
    81004034:	bf71                	j	81003fd0 <fileread+0x58>

0000000081004036 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    81004036:	00954783          	lbu	a5,9(a0)
    8100403a:	10078e63          	beqz	a5,81004156 <filewrite+0x120>
{
    8100403e:	711d                	addi	sp,sp,-96
    81004040:	ec86                	sd	ra,88(sp)
    81004042:	e8a2                	sd	s0,80(sp)
    81004044:	e0ca                	sd	s2,64(sp)
    81004046:	f456                	sd	s5,40(sp)
    81004048:	f05a                	sd	s6,32(sp)
    8100404a:	1080                	addi	s0,sp,96
    8100404c:	892a                	mv	s2,a0
    8100404e:	8b2e                	mv	s6,a1
    81004050:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    81004052:	411c                	lw	a5,0(a0)
    81004054:	4705                	li	a4,1
    81004056:	02e78963          	beq	a5,a4,81004088 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8100405a:	470d                	li	a4,3
    8100405c:	02e78a63          	beq	a5,a4,81004090 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    81004060:	4709                	li	a4,2
    81004062:	0ce79e63          	bne	a5,a4,8100413e <filewrite+0x108>
    81004066:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    81004068:	0ac05963          	blez	a2,8100411a <filewrite+0xe4>
    8100406c:	e4a6                	sd	s1,72(sp)
    8100406e:	fc4e                	sd	s3,56(sp)
    81004070:	ec5e                	sd	s7,24(sp)
    81004072:	e862                	sd	s8,16(sp)
    81004074:	e466                	sd	s9,8(sp)
    int i = 0;
    81004076:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    81004078:	6b85                	lui	s7,0x1
    8100407a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x80fff400>
    8100407e:	6c85                	lui	s9,0x1
    81004080:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x80fff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    81004084:	4c05                	li	s8,1
    81004086:	a8ad                	j	81004100 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    81004088:	6908                	ld	a0,16(a0)
    8100408a:	1fe000ef          	jal	81004288 <pipewrite>
    8100408e:	a04d                	j	81004130 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    81004090:	02451783          	lh	a5,36(a0)
    81004094:	03079693          	slli	a3,a5,0x30
    81004098:	92c1                	srli	a3,a3,0x30
    8100409a:	4725                	li	a4,9
    8100409c:	0ad76f63          	bltu	a4,a3,8100415a <filewrite+0x124>
    810040a0:	0792                	slli	a5,a5,0x4
    810040a2:	00014717          	auipc	a4,0x14
    810040a6:	a0670713          	addi	a4,a4,-1530 # 81017aa8 <devsw>
    810040aa:	97ba                	add	a5,a5,a4
    810040ac:	679c                	ld	a5,8(a5)
    810040ae:	cbc5                	beqz	a5,8100415e <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    810040b0:	4505                	li	a0,1
    810040b2:	9782                	jalr	a5
    810040b4:	a8b5                	j	81004130 <filewrite+0xfa>
      if(n1 > max)
    810040b6:	2981                	sext.w	s3,s3
      begin_op();
    810040b8:	981ff0ef          	jal	81003a38 <begin_op>
      ilock(f->ip);
    810040bc:	01893503          	ld	a0,24(s2)
    810040c0:	8c6ff0ef          	jal	81003186 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    810040c4:	874e                	mv	a4,s3
    810040c6:	02092683          	lw	a3,32(s2)
    810040ca:	016a0633          	add	a2,s4,s6
    810040ce:	85e2                	mv	a1,s8
    810040d0:	01893503          	ld	a0,24(s2)
    810040d4:	bfcff0ef          	jal	810034d0 <writei>
    810040d8:	84aa                	mv	s1,a0
    810040da:	00a05763          	blez	a0,810040e8 <filewrite+0xb2>
        f->off += r;
    810040de:	02092783          	lw	a5,32(s2)
    810040e2:	9fa9                	addw	a5,a5,a0
    810040e4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    810040e8:	01893503          	ld	a0,24(s2)
    810040ec:	948ff0ef          	jal	81003234 <iunlock>
      end_op();
    810040f0:	9b3ff0ef          	jal	81003aa2 <end_op>

      if(r != n1){
    810040f4:	02999563          	bne	s3,s1,8100411e <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    810040f8:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    810040fc:	015a5963          	bge	s4,s5,8100410e <filewrite+0xd8>
      int n1 = n - i;
    81004100:	414a87bb          	subw	a5,s5,s4
    81004104:	89be                	mv	s3,a5
      if(n1 > max)
    81004106:	fafbd8e3          	bge	s7,a5,810040b6 <filewrite+0x80>
    8100410a:	89e6                	mv	s3,s9
    8100410c:	b76d                	j	810040b6 <filewrite+0x80>
    8100410e:	64a6                	ld	s1,72(sp)
    81004110:	79e2                	ld	s3,56(sp)
    81004112:	6be2                	ld	s7,24(sp)
    81004114:	6c42                	ld	s8,16(sp)
    81004116:	6ca2                	ld	s9,8(sp)
    81004118:	a801                	j	81004128 <filewrite+0xf2>
    int i = 0;
    8100411a:	4a01                	li	s4,0
    8100411c:	a031                	j	81004128 <filewrite+0xf2>
    8100411e:	64a6                	ld	s1,72(sp)
    81004120:	79e2                	ld	s3,56(sp)
    81004122:	6be2                	ld	s7,24(sp)
    81004124:	6c42                	ld	s8,16(sp)
    81004126:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    81004128:	034a9d63          	bne	s5,s4,81004162 <filewrite+0x12c>
    8100412c:	8556                	mv	a0,s5
    8100412e:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    81004130:	60e6                	ld	ra,88(sp)
    81004132:	6446                	ld	s0,80(sp)
    81004134:	6906                	ld	s2,64(sp)
    81004136:	7aa2                	ld	s5,40(sp)
    81004138:	7b02                	ld	s6,32(sp)
    8100413a:	6125                	addi	sp,sp,96
    8100413c:	8082                	ret
    8100413e:	e4a6                	sd	s1,72(sp)
    81004140:	fc4e                	sd	s3,56(sp)
    81004142:	f852                	sd	s4,48(sp)
    81004144:	ec5e                	sd	s7,24(sp)
    81004146:	e862                	sd	s8,16(sp)
    81004148:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8100414a:	00003517          	auipc	a0,0x3
    8100414e:	49e50513          	addi	a0,a0,1182 # 810075e8 <etext+0x5e8>
    81004152:	e56fc0ef          	jal	810007a8 <panic>
    return -1;
    81004156:	557d                	li	a0,-1
}
    81004158:	8082                	ret
      return -1;
    8100415a:	557d                	li	a0,-1
    8100415c:	bfd1                	j	81004130 <filewrite+0xfa>
    8100415e:	557d                	li	a0,-1
    81004160:	bfc1                	j	81004130 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    81004162:	557d                	li	a0,-1
    81004164:	7a42                	ld	s4,48(sp)
    81004166:	b7e9                	j	81004130 <filewrite+0xfa>

0000000081004168 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    81004168:	7179                	addi	sp,sp,-48
    8100416a:	f406                	sd	ra,40(sp)
    8100416c:	f022                	sd	s0,32(sp)
    8100416e:	ec26                	sd	s1,24(sp)
    81004170:	e052                	sd	s4,0(sp)
    81004172:	1800                	addi	s0,sp,48
    81004174:	84aa                	mv	s1,a0
    81004176:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    81004178:	0005b023          	sd	zero,0(a1)
    8100417c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    81004180:	c35ff0ef          	jal	81003db4 <filealloc>
    81004184:	e088                	sd	a0,0(s1)
    81004186:	c549                	beqz	a0,81004210 <pipealloc+0xa8>
    81004188:	c2dff0ef          	jal	81003db4 <filealloc>
    8100418c:	00aa3023          	sd	a0,0(s4)
    81004190:	cd25                	beqz	a0,81004208 <pipealloc+0xa0>
    81004192:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    81004194:	9a5fc0ef          	jal	81000b38 <kalloc>
    81004198:	892a                	mv	s2,a0
    8100419a:	c12d                	beqz	a0,810041fc <pipealloc+0x94>
    8100419c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8100419e:	4985                	li	s3,1
    810041a0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    810041a4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    810041a8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    810041ac:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    810041b0:	00003597          	auipc	a1,0x3
    810041b4:	44858593          	addi	a1,a1,1096 # 810075f8 <etext+0x5f8>
    810041b8:	9d1fc0ef          	jal	81000b88 <initlock>
  (*f0)->type = FD_PIPE;
    810041bc:	609c                	ld	a5,0(s1)
    810041be:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    810041c2:	609c                	ld	a5,0(s1)
    810041c4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    810041c8:	609c                	ld	a5,0(s1)
    810041ca:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    810041ce:	609c                	ld	a5,0(s1)
    810041d0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    810041d4:	000a3783          	ld	a5,0(s4)
    810041d8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    810041dc:	000a3783          	ld	a5,0(s4)
    810041e0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    810041e4:	000a3783          	ld	a5,0(s4)
    810041e8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    810041ec:	000a3783          	ld	a5,0(s4)
    810041f0:	0127b823          	sd	s2,16(a5)
  return 0;
    810041f4:	4501                	li	a0,0
    810041f6:	6942                	ld	s2,16(sp)
    810041f8:	69a2                	ld	s3,8(sp)
    810041fa:	a01d                	j	81004220 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    810041fc:	6088                	ld	a0,0(s1)
    810041fe:	c119                	beqz	a0,81004204 <pipealloc+0x9c>
    81004200:	6942                	ld	s2,16(sp)
    81004202:	a029                	j	8100420c <pipealloc+0xa4>
    81004204:	6942                	ld	s2,16(sp)
    81004206:	a029                	j	81004210 <pipealloc+0xa8>
    81004208:	6088                	ld	a0,0(s1)
    8100420a:	c10d                	beqz	a0,8100422c <pipealloc+0xc4>
    fileclose(*f0);
    8100420c:	c4dff0ef          	jal	81003e58 <fileclose>
  if(*f1)
    81004210:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    81004214:	557d                	li	a0,-1
  if(*f1)
    81004216:	c789                	beqz	a5,81004220 <pipealloc+0xb8>
    fileclose(*f1);
    81004218:	853e                	mv	a0,a5
    8100421a:	c3fff0ef          	jal	81003e58 <fileclose>
  return -1;
    8100421e:	557d                	li	a0,-1
}
    81004220:	70a2                	ld	ra,40(sp)
    81004222:	7402                	ld	s0,32(sp)
    81004224:	64e2                	ld	s1,24(sp)
    81004226:	6a02                	ld	s4,0(sp)
    81004228:	6145                	addi	sp,sp,48
    8100422a:	8082                	ret
  return -1;
    8100422c:	557d                	li	a0,-1
    8100422e:	bfcd                	j	81004220 <pipealloc+0xb8>

0000000081004230 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    81004230:	1101                	addi	sp,sp,-32
    81004232:	ec06                	sd	ra,24(sp)
    81004234:	e822                	sd	s0,16(sp)
    81004236:	e426                	sd	s1,8(sp)
    81004238:	e04a                	sd	s2,0(sp)
    8100423a:	1000                	addi	s0,sp,32
    8100423c:	84aa                	mv	s1,a0
    8100423e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    81004240:	9cdfc0ef          	jal	81000c0c <acquire>
  if(writable){
    81004244:	02090763          	beqz	s2,81004272 <pipeclose+0x42>
    pi->writeopen = 0;
    81004248:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8100424c:	21848513          	addi	a0,s1,536
    81004250:	ca1fd0ef          	jal	81001ef0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    81004254:	2204b783          	ld	a5,544(s1)
    81004258:	e785                	bnez	a5,81004280 <pipeclose+0x50>
    release(&pi->lock);
    8100425a:	8526                	mv	a0,s1
    8100425c:	a45fc0ef          	jal	81000ca0 <release>
    kfree((char*)pi);
    81004260:	8526                	mv	a0,s1
    81004262:	ff0fc0ef          	jal	81000a52 <kfree>
  } else
    release(&pi->lock);
}
    81004266:	60e2                	ld	ra,24(sp)
    81004268:	6442                	ld	s0,16(sp)
    8100426a:	64a2                	ld	s1,8(sp)
    8100426c:	6902                	ld	s2,0(sp)
    8100426e:	6105                	addi	sp,sp,32
    81004270:	8082                	ret
    pi->readopen = 0;
    81004272:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    81004276:	21c48513          	addi	a0,s1,540
    8100427a:	c77fd0ef          	jal	81001ef0 <wakeup>
    8100427e:	bfd9                	j	81004254 <pipeclose+0x24>
    release(&pi->lock);
    81004280:	8526                	mv	a0,s1
    81004282:	a1ffc0ef          	jal	81000ca0 <release>
}
    81004286:	b7c5                	j	81004266 <pipeclose+0x36>

0000000081004288 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    81004288:	7159                	addi	sp,sp,-112
    8100428a:	f486                	sd	ra,104(sp)
    8100428c:	f0a2                	sd	s0,96(sp)
    8100428e:	eca6                	sd	s1,88(sp)
    81004290:	e8ca                	sd	s2,80(sp)
    81004292:	e4ce                	sd	s3,72(sp)
    81004294:	e0d2                	sd	s4,64(sp)
    81004296:	fc56                	sd	s5,56(sp)
    81004298:	1880                	addi	s0,sp,112
    8100429a:	84aa                	mv	s1,a0
    8100429c:	8aae                	mv	s5,a1
    8100429e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    810042a0:	e36fd0ef          	jal	810018d6 <myproc>
    810042a4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    810042a6:	8526                	mv	a0,s1
    810042a8:	965fc0ef          	jal	81000c0c <acquire>
  while(i < n){
    810042ac:	0d405263          	blez	s4,81004370 <pipewrite+0xe8>
    810042b0:	f85a                	sd	s6,48(sp)
    810042b2:	f45e                	sd	s7,40(sp)
    810042b4:	f062                	sd	s8,32(sp)
    810042b6:	ec66                	sd	s9,24(sp)
    810042b8:	e86a                	sd	s10,16(sp)
  int i = 0;
    810042ba:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    810042bc:	f9f40c13          	addi	s8,s0,-97
    810042c0:	4b85                	li	s7,1
    810042c2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    810042c4:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    810042c8:	21c48c93          	addi	s9,s1,540
    810042cc:	a82d                	j	81004306 <pipewrite+0x7e>
      release(&pi->lock);
    810042ce:	8526                	mv	a0,s1
    810042d0:	9d1fc0ef          	jal	81000ca0 <release>
      return -1;
    810042d4:	597d                	li	s2,-1
    810042d6:	7b42                	ld	s6,48(sp)
    810042d8:	7ba2                	ld	s7,40(sp)
    810042da:	7c02                	ld	s8,32(sp)
    810042dc:	6ce2                	ld	s9,24(sp)
    810042de:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    810042e0:	854a                	mv	a0,s2
    810042e2:	70a6                	ld	ra,104(sp)
    810042e4:	7406                	ld	s0,96(sp)
    810042e6:	64e6                	ld	s1,88(sp)
    810042e8:	6946                	ld	s2,80(sp)
    810042ea:	69a6                	ld	s3,72(sp)
    810042ec:	6a06                	ld	s4,64(sp)
    810042ee:	7ae2                	ld	s5,56(sp)
    810042f0:	6165                	addi	sp,sp,112
    810042f2:	8082                	ret
      wakeup(&pi->nread);
    810042f4:	856a                	mv	a0,s10
    810042f6:	bfbfd0ef          	jal	81001ef0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    810042fa:	85a6                	mv	a1,s1
    810042fc:	8566                	mv	a0,s9
    810042fe:	ba7fd0ef          	jal	81001ea4 <sleep>
  while(i < n){
    81004302:	05495a63          	bge	s2,s4,81004356 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    81004306:	2204a783          	lw	a5,544(s1)
    8100430a:	d3f1                	beqz	a5,810042ce <pipewrite+0x46>
    8100430c:	854e                	mv	a0,s3
    8100430e:	dcffd0ef          	jal	810020dc <killed>
    81004312:	fd55                	bnez	a0,810042ce <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    81004314:	2184a783          	lw	a5,536(s1)
    81004318:	21c4a703          	lw	a4,540(s1)
    8100431c:	2007879b          	addiw	a5,a5,512
    81004320:	fcf70ae3          	beq	a4,a5,810042f4 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    81004324:	86de                	mv	a3,s7
    81004326:	01590633          	add	a2,s2,s5
    8100432a:	85e2                	mv	a1,s8
    8100432c:	0509b503          	ld	a0,80(s3)
    81004330:	afefd0ef          	jal	8100162e <copyin>
    81004334:	05650063          	beq	a0,s6,81004374 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    81004338:	21c4a783          	lw	a5,540(s1)
    8100433c:	0017871b          	addiw	a4,a5,1
    81004340:	20e4ae23          	sw	a4,540(s1)
    81004344:	1ff7f793          	andi	a5,a5,511
    81004348:	97a6                	add	a5,a5,s1
    8100434a:	f9f44703          	lbu	a4,-97(s0)
    8100434e:	00e78c23          	sb	a4,24(a5)
      i++;
    81004352:	2905                	addiw	s2,s2,1
    81004354:	b77d                	j	81004302 <pipewrite+0x7a>
    81004356:	7b42                	ld	s6,48(sp)
    81004358:	7ba2                	ld	s7,40(sp)
    8100435a:	7c02                	ld	s8,32(sp)
    8100435c:	6ce2                	ld	s9,24(sp)
    8100435e:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    81004360:	21848513          	addi	a0,s1,536
    81004364:	b8dfd0ef          	jal	81001ef0 <wakeup>
  release(&pi->lock);
    81004368:	8526                	mv	a0,s1
    8100436a:	937fc0ef          	jal	81000ca0 <release>
  return i;
    8100436e:	bf8d                	j	810042e0 <pipewrite+0x58>
  int i = 0;
    81004370:	4901                	li	s2,0
    81004372:	b7fd                	j	81004360 <pipewrite+0xd8>
    81004374:	7b42                	ld	s6,48(sp)
    81004376:	7ba2                	ld	s7,40(sp)
    81004378:	7c02                	ld	s8,32(sp)
    8100437a:	6ce2                	ld	s9,24(sp)
    8100437c:	6d42                	ld	s10,16(sp)
    8100437e:	b7cd                	j	81004360 <pipewrite+0xd8>

0000000081004380 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    81004380:	711d                	addi	sp,sp,-96
    81004382:	ec86                	sd	ra,88(sp)
    81004384:	e8a2                	sd	s0,80(sp)
    81004386:	e4a6                	sd	s1,72(sp)
    81004388:	e0ca                	sd	s2,64(sp)
    8100438a:	fc4e                	sd	s3,56(sp)
    8100438c:	f852                	sd	s4,48(sp)
    8100438e:	f456                	sd	s5,40(sp)
    81004390:	1080                	addi	s0,sp,96
    81004392:	84aa                	mv	s1,a0
    81004394:	892e                	mv	s2,a1
    81004396:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    81004398:	d3efd0ef          	jal	810018d6 <myproc>
    8100439c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8100439e:	8526                	mv	a0,s1
    810043a0:	86dfc0ef          	jal	81000c0c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    810043a4:	2184a703          	lw	a4,536(s1)
    810043a8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    810043ac:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    810043b0:	02f71763          	bne	a4,a5,810043de <piperead+0x5e>
    810043b4:	2244a783          	lw	a5,548(s1)
    810043b8:	cf85                	beqz	a5,810043f0 <piperead+0x70>
    if(killed(pr)){
    810043ba:	8552                	mv	a0,s4
    810043bc:	d21fd0ef          	jal	810020dc <killed>
    810043c0:	e11d                	bnez	a0,810043e6 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    810043c2:	85a6                	mv	a1,s1
    810043c4:	854e                	mv	a0,s3
    810043c6:	adffd0ef          	jal	81001ea4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    810043ca:	2184a703          	lw	a4,536(s1)
    810043ce:	21c4a783          	lw	a5,540(s1)
    810043d2:	fef701e3          	beq	a4,a5,810043b4 <piperead+0x34>
    810043d6:	f05a                	sd	s6,32(sp)
    810043d8:	ec5e                	sd	s7,24(sp)
    810043da:	e862                	sd	s8,16(sp)
    810043dc:	a829                	j	810043f6 <piperead+0x76>
    810043de:	f05a                	sd	s6,32(sp)
    810043e0:	ec5e                	sd	s7,24(sp)
    810043e2:	e862                	sd	s8,16(sp)
    810043e4:	a809                	j	810043f6 <piperead+0x76>
      release(&pi->lock);
    810043e6:	8526                	mv	a0,s1
    810043e8:	8b9fc0ef          	jal	81000ca0 <release>
      return -1;
    810043ec:	59fd                	li	s3,-1
    810043ee:	a0a5                	j	81004456 <piperead+0xd6>
    810043f0:	f05a                	sd	s6,32(sp)
    810043f2:	ec5e                	sd	s7,24(sp)
    810043f4:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    810043f6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    810043f8:	faf40c13          	addi	s8,s0,-81
    810043fc:	4b85                	li	s7,1
    810043fe:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    81004400:	05505163          	blez	s5,81004442 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    81004404:	2184a783          	lw	a5,536(s1)
    81004408:	21c4a703          	lw	a4,540(s1)
    8100440c:	02f70b63          	beq	a4,a5,81004442 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    81004410:	0017871b          	addiw	a4,a5,1
    81004414:	20e4ac23          	sw	a4,536(s1)
    81004418:	1ff7f793          	andi	a5,a5,511
    8100441c:	97a6                	add	a5,a5,s1
    8100441e:	0187c783          	lbu	a5,24(a5)
    81004422:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    81004426:	86de                	mv	a3,s7
    81004428:	8662                	mv	a2,s8
    8100442a:	85ca                	mv	a1,s2
    8100442c:	050a3503          	ld	a0,80(s4)
    81004430:	94efd0ef          	jal	8100157e <copyout>
    81004434:	01650763          	beq	a0,s6,81004442 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    81004438:	2985                	addiw	s3,s3,1
    8100443a:	0905                	addi	s2,s2,1
    8100443c:	fd3a94e3          	bne	s5,s3,81004404 <piperead+0x84>
    81004440:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    81004442:	21c48513          	addi	a0,s1,540
    81004446:	aabfd0ef          	jal	81001ef0 <wakeup>
  release(&pi->lock);
    8100444a:	8526                	mv	a0,s1
    8100444c:	855fc0ef          	jal	81000ca0 <release>
    81004450:	7b02                	ld	s6,32(sp)
    81004452:	6be2                	ld	s7,24(sp)
    81004454:	6c42                	ld	s8,16(sp)
  return i;
}
    81004456:	854e                	mv	a0,s3
    81004458:	60e6                	ld	ra,88(sp)
    8100445a:	6446                	ld	s0,80(sp)
    8100445c:	64a6                	ld	s1,72(sp)
    8100445e:	6906                	ld	s2,64(sp)
    81004460:	79e2                	ld	s3,56(sp)
    81004462:	7a42                	ld	s4,48(sp)
    81004464:	7aa2                	ld	s5,40(sp)
    81004466:	6125                	addi	sp,sp,96
    81004468:	8082                	ret

000000008100446a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8100446a:	1141                	addi	sp,sp,-16
    8100446c:	e406                	sd	ra,8(sp)
    8100446e:	e022                	sd	s0,0(sp)
    81004470:	0800                	addi	s0,sp,16
    81004472:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    81004474:	0035151b          	slliw	a0,a0,0x3
    81004478:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    8100447a:	8b89                	andi	a5,a5,2
    8100447c:	c399                	beqz	a5,81004482 <flags2perm+0x18>
      perm |= PTE_W;
    8100447e:	00456513          	ori	a0,a0,4
    return perm;
}
    81004482:	60a2                	ld	ra,8(sp)
    81004484:	6402                	ld	s0,0(sp)
    81004486:	0141                	addi	sp,sp,16
    81004488:	8082                	ret

000000008100448a <exec>:

int
exec(char *path, char **argv)
{
    8100448a:	de010113          	addi	sp,sp,-544
    8100448e:	20113c23          	sd	ra,536(sp)
    81004492:	20813823          	sd	s0,528(sp)
    81004496:	20913423          	sd	s1,520(sp)
    8100449a:	21213023          	sd	s2,512(sp)
    8100449e:	1400                	addi	s0,sp,544
    810044a0:	892a                	mv	s2,a0
    810044a2:	dea43823          	sd	a0,-528(s0)
    810044a6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    810044aa:	c2cfd0ef          	jal	810018d6 <myproc>
    810044ae:	84aa                	mv	s1,a0

  begin_op();
    810044b0:	d88ff0ef          	jal	81003a38 <begin_op>

  if((ip = namei(path)) == 0){
    810044b4:	854a                	mv	a0,s2
    810044b6:	bc0ff0ef          	jal	81003876 <namei>
    810044ba:	cd21                	beqz	a0,81004512 <exec+0x88>
    810044bc:	fbd2                	sd	s4,496(sp)
    810044be:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    810044c0:	cc7fe0ef          	jal	81003186 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    810044c4:	04000713          	li	a4,64
    810044c8:	4681                	li	a3,0
    810044ca:	e5040613          	addi	a2,s0,-432
    810044ce:	4581                	li	a1,0
    810044d0:	8552                	mv	a0,s4
    810044d2:	f0dfe0ef          	jal	810033de <readi>
    810044d6:	04000793          	li	a5,64
    810044da:	00f51a63          	bne	a0,a5,810044ee <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    810044de:	e5042703          	lw	a4,-432(s0)
    810044e2:	464c47b7          	lui	a5,0x464c4
    810044e6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x3ab3ba81>
    810044ea:	02f70863          	beq	a4,a5,8100451a <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    810044ee:	8552                	mv	a0,s4
    810044f0:	ea1fe0ef          	jal	81003390 <iunlockput>
    end_op();
    810044f4:	daeff0ef          	jal	81003aa2 <end_op>
  }
  return -1;
    810044f8:	557d                	li	a0,-1
    810044fa:	7a5e                	ld	s4,496(sp)
}
    810044fc:	21813083          	ld	ra,536(sp)
    81004500:	21013403          	ld	s0,528(sp)
    81004504:	20813483          	ld	s1,520(sp)
    81004508:	20013903          	ld	s2,512(sp)
    8100450c:	22010113          	addi	sp,sp,544
    81004510:	8082                	ret
    end_op();
    81004512:	d90ff0ef          	jal	81003aa2 <end_op>
    return -1;
    81004516:	557d                	li	a0,-1
    81004518:	b7d5                	j	810044fc <exec+0x72>
    8100451a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8100451c:	8526                	mv	a0,s1
    8100451e:	c60fd0ef          	jal	8100197e <proc_pagetable>
    81004522:	8b2a                	mv	s6,a0
    81004524:	26050d63          	beqz	a0,8100479e <exec+0x314>
    81004528:	ffce                	sd	s3,504(sp)
    8100452a:	f7d6                	sd	s5,488(sp)
    8100452c:	efde                	sd	s7,472(sp)
    8100452e:	ebe2                	sd	s8,464(sp)
    81004530:	e7e6                	sd	s9,456(sp)
    81004532:	e3ea                	sd	s10,448(sp)
    81004534:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    81004536:	e7042683          	lw	a3,-400(s0)
    8100453a:	e8845783          	lhu	a5,-376(s0)
    8100453e:	0e078763          	beqz	a5,8100462c <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    81004542:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    81004544:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    81004546:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8100454a:	6c85                	lui	s9,0x1
    8100454c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x80fff001>
    81004550:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    81004554:	6a85                	lui	s5,0x1
    81004556:	a085                	j	810045b6 <exec+0x12c>
      panic("loadseg: address should exist");
    81004558:	00003517          	auipc	a0,0x3
    8100455c:	0a850513          	addi	a0,a0,168 # 81007600 <etext+0x600>
    81004560:	a48fc0ef          	jal	810007a8 <panic>
    if(sz - i < PGSIZE)
    81004564:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    81004566:	874a                	mv	a4,s2
    81004568:	009c06bb          	addw	a3,s8,s1
    8100456c:	4581                	li	a1,0
    8100456e:	8552                	mv	a0,s4
    81004570:	e6ffe0ef          	jal	810033de <readi>
    81004574:	22a91963          	bne	s2,a0,810047a6 <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    81004578:	009a84bb          	addw	s1,s5,s1
    8100457c:	0334f263          	bgeu	s1,s3,810045a0 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    81004580:	02049593          	slli	a1,s1,0x20
    81004584:	9181                	srli	a1,a1,0x20
    81004586:	95de                	add	a1,a1,s7
    81004588:	855a                	mv	a0,s6
    8100458a:	a69fc0ef          	jal	81000ff2 <walkaddr>
    8100458e:	862a                	mv	a2,a0
    if(pa == 0)
    81004590:	d561                	beqz	a0,81004558 <exec+0xce>
    if(sz - i < PGSIZE)
    81004592:	409987bb          	subw	a5,s3,s1
    81004596:	893e                	mv	s2,a5
    81004598:	fcfcf6e3          	bgeu	s9,a5,81004564 <exec+0xda>
    8100459c:	8956                	mv	s2,s5
    8100459e:	b7d9                	j	81004564 <exec+0xda>
    sz = sz1;
    810045a0:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    810045a4:	2d05                	addiw	s10,s10,1
    810045a6:	e0843783          	ld	a5,-504(s0)
    810045aa:	0387869b          	addiw	a3,a5,56
    810045ae:	e8845783          	lhu	a5,-376(s0)
    810045b2:	06fd5e63          	bge	s10,a5,8100462e <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    810045b6:	e0d43423          	sd	a3,-504(s0)
    810045ba:	876e                	mv	a4,s11
    810045bc:	e1840613          	addi	a2,s0,-488
    810045c0:	4581                	li	a1,0
    810045c2:	8552                	mv	a0,s4
    810045c4:	e1bfe0ef          	jal	810033de <readi>
    810045c8:	1db51d63          	bne	a0,s11,810047a2 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    810045cc:	e1842783          	lw	a5,-488(s0)
    810045d0:	4705                	li	a4,1
    810045d2:	fce799e3          	bne	a5,a4,810045a4 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    810045d6:	e4043483          	ld	s1,-448(s0)
    810045da:	e3843783          	ld	a5,-456(s0)
    810045de:	1ef4e263          	bltu	s1,a5,810047c2 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    810045e2:	e2843783          	ld	a5,-472(s0)
    810045e6:	94be                	add	s1,s1,a5
    810045e8:	1ef4e063          	bltu	s1,a5,810047c8 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    810045ec:	de843703          	ld	a4,-536(s0)
    810045f0:	8ff9                	and	a5,a5,a4
    810045f2:	1c079e63          	bnez	a5,810047ce <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    810045f6:	e1c42503          	lw	a0,-484(s0)
    810045fa:	e71ff0ef          	jal	8100446a <flags2perm>
    810045fe:	86aa                	mv	a3,a0
    81004600:	8626                	mv	a2,s1
    81004602:	85ca                	mv	a1,s2
    81004604:	855a                	mv	a0,s6
    81004606:	d59fc0ef          	jal	8100135e <uvmalloc>
    8100460a:	dea43c23          	sd	a0,-520(s0)
    8100460e:	1c050363          	beqz	a0,810047d4 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    81004612:	e2843b83          	ld	s7,-472(s0)
    81004616:	e2042c03          	lw	s8,-480(s0)
    8100461a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8100461e:	00098463          	beqz	s3,81004626 <exec+0x19c>
    81004622:	4481                	li	s1,0
    81004624:	bfb1                	j	81004580 <exec+0xf6>
    sz = sz1;
    81004626:	df843903          	ld	s2,-520(s0)
    8100462a:	bfad                	j	810045a4 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8100462c:	4901                	li	s2,0
  iunlockput(ip);
    8100462e:	8552                	mv	a0,s4
    81004630:	d61fe0ef          	jal	81003390 <iunlockput>
  end_op();
    81004634:	c6eff0ef          	jal	81003aa2 <end_op>
  p = myproc();
    81004638:	a9efd0ef          	jal	810018d6 <myproc>
    8100463c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8100463e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    81004642:	6985                	lui	s3,0x1
    81004644:	19fd                	addi	s3,s3,-1 # fff <_entry-0x80fff001>
    81004646:	99ca                	add	s3,s3,s2
    81004648:	77fd                	lui	a5,0xfffff
    8100464a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8100464e:	4691                	li	a3,4
    81004650:	6609                	lui	a2,0x2
    81004652:	964e                	add	a2,a2,s3
    81004654:	85ce                	mv	a1,s3
    81004656:	855a                	mv	a0,s6
    81004658:	d07fc0ef          	jal	8100135e <uvmalloc>
    8100465c:	8a2a                	mv	s4,a0
    8100465e:	e105                	bnez	a0,8100467e <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    81004660:	85ce                	mv	a1,s3
    81004662:	855a                	mv	a0,s6
    81004664:	b9efd0ef          	jal	81001a02 <proc_freepagetable>
  return -1;
    81004668:	557d                	li	a0,-1
    8100466a:	79fe                	ld	s3,504(sp)
    8100466c:	7a5e                	ld	s4,496(sp)
    8100466e:	7abe                	ld	s5,488(sp)
    81004670:	7b1e                	ld	s6,480(sp)
    81004672:	6bfe                	ld	s7,472(sp)
    81004674:	6c5e                	ld	s8,464(sp)
    81004676:	6cbe                	ld	s9,456(sp)
    81004678:	6d1e                	ld	s10,448(sp)
    8100467a:	7dfa                	ld	s11,440(sp)
    8100467c:	b541                	j	810044fc <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8100467e:	75f9                	lui	a1,0xffffe
    81004680:	95aa                	add	a1,a1,a0
    81004682:	855a                	mv	a0,s6
    81004684:	ed1fc0ef          	jal	81001554 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    81004688:	7bfd                	lui	s7,0xfffff
    8100468a:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    8100468c:	e0043783          	ld	a5,-512(s0)
    81004690:	6388                	ld	a0,0(a5)
  sp = sz;
    81004692:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    81004694:	4481                	li	s1,0
    ustack[argc] = sp;
    81004696:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    8100469a:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    8100469e:	cd21                	beqz	a0,810046f6 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    810046a0:	fc4fc0ef          	jal	81000e64 <strlen>
    810046a4:	0015079b          	addiw	a5,a0,1
    810046a8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    810046ac:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    810046b0:	13796563          	bltu	s2,s7,810047da <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    810046b4:	e0043d83          	ld	s11,-512(s0)
    810046b8:	000db983          	ld	s3,0(s11)
    810046bc:	854e                	mv	a0,s3
    810046be:	fa6fc0ef          	jal	81000e64 <strlen>
    810046c2:	0015069b          	addiw	a3,a0,1
    810046c6:	864e                	mv	a2,s3
    810046c8:	85ca                	mv	a1,s2
    810046ca:	855a                	mv	a0,s6
    810046cc:	eb3fc0ef          	jal	8100157e <copyout>
    810046d0:	10054763          	bltz	a0,810047de <exec+0x354>
    ustack[argc] = sp;
    810046d4:	00349793          	slli	a5,s1,0x3
    810046d8:	97e6                	add	a5,a5,s9
    810046da:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7efe6000>
  for(argc = 0; argv[argc]; argc++) {
    810046de:	0485                	addi	s1,s1,1
    810046e0:	008d8793          	addi	a5,s11,8
    810046e4:	e0f43023          	sd	a5,-512(s0)
    810046e8:	008db503          	ld	a0,8(s11)
    810046ec:	c509                	beqz	a0,810046f6 <exec+0x26c>
    if(argc >= MAXARG)
    810046ee:	fb8499e3          	bne	s1,s8,810046a0 <exec+0x216>
  sz = sz1;
    810046f2:	89d2                	mv	s3,s4
    810046f4:	b7b5                	j	81004660 <exec+0x1d6>
  ustack[argc] = 0;
    810046f6:	00349793          	slli	a5,s1,0x3
    810046fa:	f9078793          	addi	a5,a5,-112
    810046fe:	97a2                	add	a5,a5,s0
    81004700:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    81004704:	00148693          	addi	a3,s1,1
    81004708:	068e                	slli	a3,a3,0x3
    8100470a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8100470e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    81004712:	89d2                	mv	s3,s4
  if(sp < stackbase)
    81004714:	f57966e3          	bltu	s2,s7,81004660 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    81004718:	e9040613          	addi	a2,s0,-368
    8100471c:	85ca                	mv	a1,s2
    8100471e:	855a                	mv	a0,s6
    81004720:	e5ffc0ef          	jal	8100157e <copyout>
    81004724:	f2054ee3          	bltz	a0,81004660 <exec+0x1d6>
  p->trapframe->a1 = sp;
    81004728:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x80ffefa8>
    8100472c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    81004730:	df043783          	ld	a5,-528(s0)
    81004734:	0007c703          	lbu	a4,0(a5)
    81004738:	cf11                	beqz	a4,81004754 <exec+0x2ca>
    8100473a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8100473c:	02f00693          	li	a3,47
    81004740:	a029                	j	8100474a <exec+0x2c0>
  for(last=s=path; *s; s++)
    81004742:	0785                	addi	a5,a5,1
    81004744:	fff7c703          	lbu	a4,-1(a5)
    81004748:	c711                	beqz	a4,81004754 <exec+0x2ca>
    if(*s == '/')
    8100474a:	fed71ce3          	bne	a4,a3,81004742 <exec+0x2b8>
      last = s+1;
    8100474e:	def43823          	sd	a5,-528(s0)
    81004752:	bfc5                	j	81004742 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    81004754:	4641                	li	a2,16
    81004756:	df043583          	ld	a1,-528(s0)
    8100475a:	158a8513          	addi	a0,s5,344
    8100475e:	ed0fc0ef          	jal	81000e2e <safestrcpy>
  oldpagetable = p->pagetable;
    81004762:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    81004766:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8100476a:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8100476e:	058ab783          	ld	a5,88(s5)
    81004772:	e6843703          	ld	a4,-408(s0)
    81004776:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    81004778:	058ab783          	ld	a5,88(s5)
    8100477c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    81004780:	85ea                	mv	a1,s10
    81004782:	a80fd0ef          	jal	81001a02 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    81004786:	0004851b          	sext.w	a0,s1
    8100478a:	79fe                	ld	s3,504(sp)
    8100478c:	7a5e                	ld	s4,496(sp)
    8100478e:	7abe                	ld	s5,488(sp)
    81004790:	7b1e                	ld	s6,480(sp)
    81004792:	6bfe                	ld	s7,472(sp)
    81004794:	6c5e                	ld	s8,464(sp)
    81004796:	6cbe                	ld	s9,456(sp)
    81004798:	6d1e                	ld	s10,448(sp)
    8100479a:	7dfa                	ld	s11,440(sp)
    8100479c:	b385                	j	810044fc <exec+0x72>
    8100479e:	7b1e                	ld	s6,480(sp)
    810047a0:	b3b9                	j	810044ee <exec+0x64>
    810047a2:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    810047a6:	df843583          	ld	a1,-520(s0)
    810047aa:	855a                	mv	a0,s6
    810047ac:	a56fd0ef          	jal	81001a02 <proc_freepagetable>
  if(ip){
    810047b0:	79fe                	ld	s3,504(sp)
    810047b2:	7abe                	ld	s5,488(sp)
    810047b4:	7b1e                	ld	s6,480(sp)
    810047b6:	6bfe                	ld	s7,472(sp)
    810047b8:	6c5e                	ld	s8,464(sp)
    810047ba:	6cbe                	ld	s9,456(sp)
    810047bc:	6d1e                	ld	s10,448(sp)
    810047be:	7dfa                	ld	s11,440(sp)
    810047c0:	b33d                	j	810044ee <exec+0x64>
    810047c2:	df243c23          	sd	s2,-520(s0)
    810047c6:	b7c5                	j	810047a6 <exec+0x31c>
    810047c8:	df243c23          	sd	s2,-520(s0)
    810047cc:	bfe9                	j	810047a6 <exec+0x31c>
    810047ce:	df243c23          	sd	s2,-520(s0)
    810047d2:	bfd1                	j	810047a6 <exec+0x31c>
    810047d4:	df243c23          	sd	s2,-520(s0)
    810047d8:	b7f9                	j	810047a6 <exec+0x31c>
  sz = sz1;
    810047da:	89d2                	mv	s3,s4
    810047dc:	b551                	j	81004660 <exec+0x1d6>
    810047de:	89d2                	mv	s3,s4
    810047e0:	b541                	j	81004660 <exec+0x1d6>

00000000810047e2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    810047e2:	7179                	addi	sp,sp,-48
    810047e4:	f406                	sd	ra,40(sp)
    810047e6:	f022                	sd	s0,32(sp)
    810047e8:	ec26                	sd	s1,24(sp)
    810047ea:	e84a                	sd	s2,16(sp)
    810047ec:	1800                	addi	s0,sp,48
    810047ee:	892e                	mv	s2,a1
    810047f0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    810047f2:	fdc40593          	addi	a1,s0,-36
    810047f6:	f93fd0ef          	jal	81002788 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    810047fa:	fdc42703          	lw	a4,-36(s0)
    810047fe:	47bd                	li	a5,15
    81004800:	02e7e963          	bltu	a5,a4,81004832 <argfd+0x50>
    81004804:	8d2fd0ef          	jal	810018d6 <myproc>
    81004808:	fdc42703          	lw	a4,-36(s0)
    8100480c:	01a70793          	addi	a5,a4,26
    81004810:	078e                	slli	a5,a5,0x3
    81004812:	953e                	add	a0,a0,a5
    81004814:	611c                	ld	a5,0(a0)
    81004816:	c385                	beqz	a5,81004836 <argfd+0x54>
    return -1;
  if(pfd)
    81004818:	00090463          	beqz	s2,81004820 <argfd+0x3e>
    *pfd = fd;
    8100481c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    81004820:	4501                	li	a0,0
  if(pf)
    81004822:	c091                	beqz	s1,81004826 <argfd+0x44>
    *pf = f;
    81004824:	e09c                	sd	a5,0(s1)
}
    81004826:	70a2                	ld	ra,40(sp)
    81004828:	7402                	ld	s0,32(sp)
    8100482a:	64e2                	ld	s1,24(sp)
    8100482c:	6942                	ld	s2,16(sp)
    8100482e:	6145                	addi	sp,sp,48
    81004830:	8082                	ret
    return -1;
    81004832:	557d                	li	a0,-1
    81004834:	bfcd                	j	81004826 <argfd+0x44>
    81004836:	557d                	li	a0,-1
    81004838:	b7fd                	j	81004826 <argfd+0x44>

000000008100483a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8100483a:	1101                	addi	sp,sp,-32
    8100483c:	ec06                	sd	ra,24(sp)
    8100483e:	e822                	sd	s0,16(sp)
    81004840:	e426                	sd	s1,8(sp)
    81004842:	1000                	addi	s0,sp,32
    81004844:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    81004846:	890fd0ef          	jal	810018d6 <myproc>
    8100484a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8100484c:	0d050793          	addi	a5,a0,208
    81004850:	4501                	li	a0,0
    81004852:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    81004854:	6398                	ld	a4,0(a5)
    81004856:	cb19                	beqz	a4,8100486c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    81004858:	2505                	addiw	a0,a0,1
    8100485a:	07a1                	addi	a5,a5,8
    8100485c:	fed51ce3          	bne	a0,a3,81004854 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    81004860:	557d                	li	a0,-1
}
    81004862:	60e2                	ld	ra,24(sp)
    81004864:	6442                	ld	s0,16(sp)
    81004866:	64a2                	ld	s1,8(sp)
    81004868:	6105                	addi	sp,sp,32
    8100486a:	8082                	ret
      p->ofile[fd] = f;
    8100486c:	01a50793          	addi	a5,a0,26
    81004870:	078e                	slli	a5,a5,0x3
    81004872:	963e                	add	a2,a2,a5
    81004874:	e204                	sd	s1,0(a2)
      return fd;
    81004876:	b7f5                	j	81004862 <fdalloc+0x28>

0000000081004878 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    81004878:	715d                	addi	sp,sp,-80
    8100487a:	e486                	sd	ra,72(sp)
    8100487c:	e0a2                	sd	s0,64(sp)
    8100487e:	fc26                	sd	s1,56(sp)
    81004880:	f84a                	sd	s2,48(sp)
    81004882:	f44e                	sd	s3,40(sp)
    81004884:	ec56                	sd	s5,24(sp)
    81004886:	e85a                	sd	s6,16(sp)
    81004888:	0880                	addi	s0,sp,80
    8100488a:	8b2e                	mv	s6,a1
    8100488c:	89b2                	mv	s3,a2
    8100488e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    81004890:	fb040593          	addi	a1,s0,-80
    81004894:	ffdfe0ef          	jal	81003890 <nameiparent>
    81004898:	84aa                	mv	s1,a0
    8100489a:	10050a63          	beqz	a0,810049ae <create+0x136>
    return 0;

  ilock(dp);
    8100489e:	8e9fe0ef          	jal	81003186 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    810048a2:	4601                	li	a2,0
    810048a4:	fb040593          	addi	a1,s0,-80
    810048a8:	8526                	mv	a0,s1
    810048aa:	d41fe0ef          	jal	810035ea <dirlookup>
    810048ae:	8aaa                	mv	s5,a0
    810048b0:	c129                	beqz	a0,810048f2 <create+0x7a>
    iunlockput(dp);
    810048b2:	8526                	mv	a0,s1
    810048b4:	addfe0ef          	jal	81003390 <iunlockput>
    ilock(ip);
    810048b8:	8556                	mv	a0,s5
    810048ba:	8cdfe0ef          	jal	81003186 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    810048be:	4789                	li	a5,2
    810048c0:	02fb1463          	bne	s6,a5,810048e8 <create+0x70>
    810048c4:	044ad783          	lhu	a5,68(s5)
    810048c8:	37f9                	addiw	a5,a5,-2
    810048ca:	17c2                	slli	a5,a5,0x30
    810048cc:	93c1                	srli	a5,a5,0x30
    810048ce:	4705                	li	a4,1
    810048d0:	00f76c63          	bltu	a4,a5,810048e8 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    810048d4:	8556                	mv	a0,s5
    810048d6:	60a6                	ld	ra,72(sp)
    810048d8:	6406                	ld	s0,64(sp)
    810048da:	74e2                	ld	s1,56(sp)
    810048dc:	7942                	ld	s2,48(sp)
    810048de:	79a2                	ld	s3,40(sp)
    810048e0:	6ae2                	ld	s5,24(sp)
    810048e2:	6b42                	ld	s6,16(sp)
    810048e4:	6161                	addi	sp,sp,80
    810048e6:	8082                	ret
    iunlockput(ip);
    810048e8:	8556                	mv	a0,s5
    810048ea:	aa7fe0ef          	jal	81003390 <iunlockput>
    return 0;
    810048ee:	4a81                	li	s5,0
    810048f0:	b7d5                	j	810048d4 <create+0x5c>
    810048f2:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    810048f4:	85da                	mv	a1,s6
    810048f6:	4088                	lw	a0,0(s1)
    810048f8:	f1efe0ef          	jal	81003016 <ialloc>
    810048fc:	8a2a                	mv	s4,a0
    810048fe:	cd15                	beqz	a0,8100493a <create+0xc2>
  ilock(ip);
    81004900:	887fe0ef          	jal	81003186 <ilock>
  ip->major = major;
    81004904:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    81004908:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8100490c:	4905                	li	s2,1
    8100490e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    81004912:	8552                	mv	a0,s4
    81004914:	fbefe0ef          	jal	810030d2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    81004918:	032b0763          	beq	s6,s2,81004946 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8100491c:	004a2603          	lw	a2,4(s4)
    81004920:	fb040593          	addi	a1,s0,-80
    81004924:	8526                	mv	a0,s1
    81004926:	ea7fe0ef          	jal	810037cc <dirlink>
    8100492a:	06054563          	bltz	a0,81004994 <create+0x11c>
  iunlockput(dp);
    8100492e:	8526                	mv	a0,s1
    81004930:	a61fe0ef          	jal	81003390 <iunlockput>
  return ip;
    81004934:	8ad2                	mv	s5,s4
    81004936:	7a02                	ld	s4,32(sp)
    81004938:	bf71                	j	810048d4 <create+0x5c>
    iunlockput(dp);
    8100493a:	8526                	mv	a0,s1
    8100493c:	a55fe0ef          	jal	81003390 <iunlockput>
    return 0;
    81004940:	8ad2                	mv	s5,s4
    81004942:	7a02                	ld	s4,32(sp)
    81004944:	bf41                	j	810048d4 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    81004946:	004a2603          	lw	a2,4(s4)
    8100494a:	00003597          	auipc	a1,0x3
    8100494e:	cd658593          	addi	a1,a1,-810 # 81007620 <etext+0x620>
    81004952:	8552                	mv	a0,s4
    81004954:	e79fe0ef          	jal	810037cc <dirlink>
    81004958:	02054e63          	bltz	a0,81004994 <create+0x11c>
    8100495c:	40d0                	lw	a2,4(s1)
    8100495e:	00003597          	auipc	a1,0x3
    81004962:	cca58593          	addi	a1,a1,-822 # 81007628 <etext+0x628>
    81004966:	8552                	mv	a0,s4
    81004968:	e65fe0ef          	jal	810037cc <dirlink>
    8100496c:	02054463          	bltz	a0,81004994 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    81004970:	004a2603          	lw	a2,4(s4)
    81004974:	fb040593          	addi	a1,s0,-80
    81004978:	8526                	mv	a0,s1
    8100497a:	e53fe0ef          	jal	810037cc <dirlink>
    8100497e:	00054b63          	bltz	a0,81004994 <create+0x11c>
    dp->nlink++;  // for ".."
    81004982:	04a4d783          	lhu	a5,74(s1)
    81004986:	2785                	addiw	a5,a5,1
    81004988:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8100498c:	8526                	mv	a0,s1
    8100498e:	f44fe0ef          	jal	810030d2 <iupdate>
    81004992:	bf71                	j	8100492e <create+0xb6>
  ip->nlink = 0;
    81004994:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    81004998:	8552                	mv	a0,s4
    8100499a:	f38fe0ef          	jal	810030d2 <iupdate>
  iunlockput(ip);
    8100499e:	8552                	mv	a0,s4
    810049a0:	9f1fe0ef          	jal	81003390 <iunlockput>
  iunlockput(dp);
    810049a4:	8526                	mv	a0,s1
    810049a6:	9ebfe0ef          	jal	81003390 <iunlockput>
  return 0;
    810049aa:	7a02                	ld	s4,32(sp)
    810049ac:	b725                	j	810048d4 <create+0x5c>
    return 0;
    810049ae:	8aaa                	mv	s5,a0
    810049b0:	b715                	j	810048d4 <create+0x5c>

00000000810049b2 <sys_dup>:
{
    810049b2:	7179                	addi	sp,sp,-48
    810049b4:	f406                	sd	ra,40(sp)
    810049b6:	f022                	sd	s0,32(sp)
    810049b8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    810049ba:	fd840613          	addi	a2,s0,-40
    810049be:	4581                	li	a1,0
    810049c0:	4501                	li	a0,0
    810049c2:	e21ff0ef          	jal	810047e2 <argfd>
    return -1;
    810049c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    810049c8:	02054363          	bltz	a0,810049ee <sys_dup+0x3c>
    810049cc:	ec26                	sd	s1,24(sp)
    810049ce:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    810049d0:	fd843903          	ld	s2,-40(s0)
    810049d4:	854a                	mv	a0,s2
    810049d6:	e65ff0ef          	jal	8100483a <fdalloc>
    810049da:	84aa                	mv	s1,a0
    return -1;
    810049dc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    810049de:	00054d63          	bltz	a0,810049f8 <sys_dup+0x46>
  filedup(f);
    810049e2:	854a                	mv	a0,s2
    810049e4:	c2eff0ef          	jal	81003e12 <filedup>
  return fd;
    810049e8:	87a6                	mv	a5,s1
    810049ea:	64e2                	ld	s1,24(sp)
    810049ec:	6942                	ld	s2,16(sp)
}
    810049ee:	853e                	mv	a0,a5
    810049f0:	70a2                	ld	ra,40(sp)
    810049f2:	7402                	ld	s0,32(sp)
    810049f4:	6145                	addi	sp,sp,48
    810049f6:	8082                	ret
    810049f8:	64e2                	ld	s1,24(sp)
    810049fa:	6942                	ld	s2,16(sp)
    810049fc:	bfcd                	j	810049ee <sys_dup+0x3c>

00000000810049fe <sys_read>:
{
    810049fe:	7179                	addi	sp,sp,-48
    81004a00:	f406                	sd	ra,40(sp)
    81004a02:	f022                	sd	s0,32(sp)
    81004a04:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    81004a06:	fd840593          	addi	a1,s0,-40
    81004a0a:	4505                	li	a0,1
    81004a0c:	d99fd0ef          	jal	810027a4 <argaddr>
  argint(2, &n);
    81004a10:	fe440593          	addi	a1,s0,-28
    81004a14:	4509                	li	a0,2
    81004a16:	d73fd0ef          	jal	81002788 <argint>
  if(argfd(0, 0, &f) < 0)
    81004a1a:	fe840613          	addi	a2,s0,-24
    81004a1e:	4581                	li	a1,0
    81004a20:	4501                	li	a0,0
    81004a22:	dc1ff0ef          	jal	810047e2 <argfd>
    81004a26:	87aa                	mv	a5,a0
    return -1;
    81004a28:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    81004a2a:	0007ca63          	bltz	a5,81004a3e <sys_read+0x40>
  return fileread(f, p, n);
    81004a2e:	fe442603          	lw	a2,-28(s0)
    81004a32:	fd843583          	ld	a1,-40(s0)
    81004a36:	fe843503          	ld	a0,-24(s0)
    81004a3a:	d3eff0ef          	jal	81003f78 <fileread>
}
    81004a3e:	70a2                	ld	ra,40(sp)
    81004a40:	7402                	ld	s0,32(sp)
    81004a42:	6145                	addi	sp,sp,48
    81004a44:	8082                	ret

0000000081004a46 <sys_write>:
{
    81004a46:	7179                	addi	sp,sp,-48
    81004a48:	f406                	sd	ra,40(sp)
    81004a4a:	f022                	sd	s0,32(sp)
    81004a4c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    81004a4e:	fd840593          	addi	a1,s0,-40
    81004a52:	4505                	li	a0,1
    81004a54:	d51fd0ef          	jal	810027a4 <argaddr>
  argint(2, &n);
    81004a58:	fe440593          	addi	a1,s0,-28
    81004a5c:	4509                	li	a0,2
    81004a5e:	d2bfd0ef          	jal	81002788 <argint>
  if(argfd(0, 0, &f) < 0)
    81004a62:	fe840613          	addi	a2,s0,-24
    81004a66:	4581                	li	a1,0
    81004a68:	4501                	li	a0,0
    81004a6a:	d79ff0ef          	jal	810047e2 <argfd>
    81004a6e:	87aa                	mv	a5,a0
    return -1;
    81004a70:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    81004a72:	0007ca63          	bltz	a5,81004a86 <sys_write+0x40>
  return filewrite(f, p, n);
    81004a76:	fe442603          	lw	a2,-28(s0)
    81004a7a:	fd843583          	ld	a1,-40(s0)
    81004a7e:	fe843503          	ld	a0,-24(s0)
    81004a82:	db4ff0ef          	jal	81004036 <filewrite>
}
    81004a86:	70a2                	ld	ra,40(sp)
    81004a88:	7402                	ld	s0,32(sp)
    81004a8a:	6145                	addi	sp,sp,48
    81004a8c:	8082                	ret

0000000081004a8e <sys_close>:
{
    81004a8e:	1101                	addi	sp,sp,-32
    81004a90:	ec06                	sd	ra,24(sp)
    81004a92:	e822                	sd	s0,16(sp)
    81004a94:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    81004a96:	fe040613          	addi	a2,s0,-32
    81004a9a:	fec40593          	addi	a1,s0,-20
    81004a9e:	4501                	li	a0,0
    81004aa0:	d43ff0ef          	jal	810047e2 <argfd>
    return -1;
    81004aa4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    81004aa6:	02054063          	bltz	a0,81004ac6 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    81004aaa:	e2dfc0ef          	jal	810018d6 <myproc>
    81004aae:	fec42783          	lw	a5,-20(s0)
    81004ab2:	07e9                	addi	a5,a5,26
    81004ab4:	078e                	slli	a5,a5,0x3
    81004ab6:	953e                	add	a0,a0,a5
    81004ab8:	00053023          	sd	zero,0(a0)
  fileclose(f);
    81004abc:	fe043503          	ld	a0,-32(s0)
    81004ac0:	b98ff0ef          	jal	81003e58 <fileclose>
  return 0;
    81004ac4:	4781                	li	a5,0
}
    81004ac6:	853e                	mv	a0,a5
    81004ac8:	60e2                	ld	ra,24(sp)
    81004aca:	6442                	ld	s0,16(sp)
    81004acc:	6105                	addi	sp,sp,32
    81004ace:	8082                	ret

0000000081004ad0 <sys_fstat>:
{
    81004ad0:	1101                	addi	sp,sp,-32
    81004ad2:	ec06                	sd	ra,24(sp)
    81004ad4:	e822                	sd	s0,16(sp)
    81004ad6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    81004ad8:	fe040593          	addi	a1,s0,-32
    81004adc:	4505                	li	a0,1
    81004ade:	cc7fd0ef          	jal	810027a4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    81004ae2:	fe840613          	addi	a2,s0,-24
    81004ae6:	4581                	li	a1,0
    81004ae8:	4501                	li	a0,0
    81004aea:	cf9ff0ef          	jal	810047e2 <argfd>
    81004aee:	87aa                	mv	a5,a0
    return -1;
    81004af0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    81004af2:	0007c863          	bltz	a5,81004b02 <sys_fstat+0x32>
  return filestat(f, st);
    81004af6:	fe043583          	ld	a1,-32(s0)
    81004afa:	fe843503          	ld	a0,-24(s0)
    81004afe:	c18ff0ef          	jal	81003f16 <filestat>
}
    81004b02:	60e2                	ld	ra,24(sp)
    81004b04:	6442                	ld	s0,16(sp)
    81004b06:	6105                	addi	sp,sp,32
    81004b08:	8082                	ret

0000000081004b0a <sys_link>:
{
    81004b0a:	7169                	addi	sp,sp,-304
    81004b0c:	f606                	sd	ra,296(sp)
    81004b0e:	f222                	sd	s0,288(sp)
    81004b10:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    81004b12:	08000613          	li	a2,128
    81004b16:	ed040593          	addi	a1,s0,-304
    81004b1a:	4501                	li	a0,0
    81004b1c:	ca5fd0ef          	jal	810027c0 <argstr>
    return -1;
    81004b20:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    81004b22:	0c054e63          	bltz	a0,81004bfe <sys_link+0xf4>
    81004b26:	08000613          	li	a2,128
    81004b2a:	f5040593          	addi	a1,s0,-176
    81004b2e:	4505                	li	a0,1
    81004b30:	c91fd0ef          	jal	810027c0 <argstr>
    return -1;
    81004b34:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    81004b36:	0c054463          	bltz	a0,81004bfe <sys_link+0xf4>
    81004b3a:	ee26                	sd	s1,280(sp)
  begin_op();
    81004b3c:	efdfe0ef          	jal	81003a38 <begin_op>
  if((ip = namei(old)) == 0){
    81004b40:	ed040513          	addi	a0,s0,-304
    81004b44:	d33fe0ef          	jal	81003876 <namei>
    81004b48:	84aa                	mv	s1,a0
    81004b4a:	c53d                	beqz	a0,81004bb8 <sys_link+0xae>
  ilock(ip);
    81004b4c:	e3afe0ef          	jal	81003186 <ilock>
  if(ip->type == T_DIR){
    81004b50:	04449703          	lh	a4,68(s1)
    81004b54:	4785                	li	a5,1
    81004b56:	06f70663          	beq	a4,a5,81004bc2 <sys_link+0xb8>
    81004b5a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    81004b5c:	04a4d783          	lhu	a5,74(s1)
    81004b60:	2785                	addiw	a5,a5,1
    81004b62:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    81004b66:	8526                	mv	a0,s1
    81004b68:	d6afe0ef          	jal	810030d2 <iupdate>
  iunlock(ip);
    81004b6c:	8526                	mv	a0,s1
    81004b6e:	ec6fe0ef          	jal	81003234 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    81004b72:	fd040593          	addi	a1,s0,-48
    81004b76:	f5040513          	addi	a0,s0,-176
    81004b7a:	d17fe0ef          	jal	81003890 <nameiparent>
    81004b7e:	892a                	mv	s2,a0
    81004b80:	cd21                	beqz	a0,81004bd8 <sys_link+0xce>
  ilock(dp);
    81004b82:	e04fe0ef          	jal	81003186 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    81004b86:	00092703          	lw	a4,0(s2)
    81004b8a:	409c                	lw	a5,0(s1)
    81004b8c:	04f71363          	bne	a4,a5,81004bd2 <sys_link+0xc8>
    81004b90:	40d0                	lw	a2,4(s1)
    81004b92:	fd040593          	addi	a1,s0,-48
    81004b96:	854a                	mv	a0,s2
    81004b98:	c35fe0ef          	jal	810037cc <dirlink>
    81004b9c:	02054b63          	bltz	a0,81004bd2 <sys_link+0xc8>
  iunlockput(dp);
    81004ba0:	854a                	mv	a0,s2
    81004ba2:	feefe0ef          	jal	81003390 <iunlockput>
  iput(ip);
    81004ba6:	8526                	mv	a0,s1
    81004ba8:	f60fe0ef          	jal	81003308 <iput>
  end_op();
    81004bac:	ef7fe0ef          	jal	81003aa2 <end_op>
  return 0;
    81004bb0:	4781                	li	a5,0
    81004bb2:	64f2                	ld	s1,280(sp)
    81004bb4:	6952                	ld	s2,272(sp)
    81004bb6:	a0a1                	j	81004bfe <sys_link+0xf4>
    end_op();
    81004bb8:	eebfe0ef          	jal	81003aa2 <end_op>
    return -1;
    81004bbc:	57fd                	li	a5,-1
    81004bbe:	64f2                	ld	s1,280(sp)
    81004bc0:	a83d                	j	81004bfe <sys_link+0xf4>
    iunlockput(ip);
    81004bc2:	8526                	mv	a0,s1
    81004bc4:	fccfe0ef          	jal	81003390 <iunlockput>
    end_op();
    81004bc8:	edbfe0ef          	jal	81003aa2 <end_op>
    return -1;
    81004bcc:	57fd                	li	a5,-1
    81004bce:	64f2                	ld	s1,280(sp)
    81004bd0:	a03d                	j	81004bfe <sys_link+0xf4>
    iunlockput(dp);
    81004bd2:	854a                	mv	a0,s2
    81004bd4:	fbcfe0ef          	jal	81003390 <iunlockput>
  ilock(ip);
    81004bd8:	8526                	mv	a0,s1
    81004bda:	dacfe0ef          	jal	81003186 <ilock>
  ip->nlink--;
    81004bde:	04a4d783          	lhu	a5,74(s1)
    81004be2:	37fd                	addiw	a5,a5,-1
    81004be4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    81004be8:	8526                	mv	a0,s1
    81004bea:	ce8fe0ef          	jal	810030d2 <iupdate>
  iunlockput(ip);
    81004bee:	8526                	mv	a0,s1
    81004bf0:	fa0fe0ef          	jal	81003390 <iunlockput>
  end_op();
    81004bf4:	eaffe0ef          	jal	81003aa2 <end_op>
  return -1;
    81004bf8:	57fd                	li	a5,-1
    81004bfa:	64f2                	ld	s1,280(sp)
    81004bfc:	6952                	ld	s2,272(sp)
}
    81004bfe:	853e                	mv	a0,a5
    81004c00:	70b2                	ld	ra,296(sp)
    81004c02:	7412                	ld	s0,288(sp)
    81004c04:	6155                	addi	sp,sp,304
    81004c06:	8082                	ret

0000000081004c08 <sys_unlink>:
{
    81004c08:	7111                	addi	sp,sp,-256
    81004c0a:	fd86                	sd	ra,248(sp)
    81004c0c:	f9a2                	sd	s0,240(sp)
    81004c0e:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    81004c10:	08000613          	li	a2,128
    81004c14:	f2040593          	addi	a1,s0,-224
    81004c18:	4501                	li	a0,0
    81004c1a:	ba7fd0ef          	jal	810027c0 <argstr>
    81004c1e:	16054663          	bltz	a0,81004d8a <sys_unlink+0x182>
    81004c22:	f5a6                	sd	s1,232(sp)
  begin_op();
    81004c24:	e15fe0ef          	jal	81003a38 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    81004c28:	fa040593          	addi	a1,s0,-96
    81004c2c:	f2040513          	addi	a0,s0,-224
    81004c30:	c61fe0ef          	jal	81003890 <nameiparent>
    81004c34:	84aa                	mv	s1,a0
    81004c36:	c955                	beqz	a0,81004cea <sys_unlink+0xe2>
  ilock(dp);
    81004c38:	d4efe0ef          	jal	81003186 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    81004c3c:	00003597          	auipc	a1,0x3
    81004c40:	9e458593          	addi	a1,a1,-1564 # 81007620 <etext+0x620>
    81004c44:	fa040513          	addi	a0,s0,-96
    81004c48:	98dfe0ef          	jal	810035d4 <namecmp>
    81004c4c:	12050463          	beqz	a0,81004d74 <sys_unlink+0x16c>
    81004c50:	00003597          	auipc	a1,0x3
    81004c54:	9d858593          	addi	a1,a1,-1576 # 81007628 <etext+0x628>
    81004c58:	fa040513          	addi	a0,s0,-96
    81004c5c:	979fe0ef          	jal	810035d4 <namecmp>
    81004c60:	10050a63          	beqz	a0,81004d74 <sys_unlink+0x16c>
    81004c64:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    81004c66:	f1c40613          	addi	a2,s0,-228
    81004c6a:	fa040593          	addi	a1,s0,-96
    81004c6e:	8526                	mv	a0,s1
    81004c70:	97bfe0ef          	jal	810035ea <dirlookup>
    81004c74:	892a                	mv	s2,a0
    81004c76:	0e050e63          	beqz	a0,81004d72 <sys_unlink+0x16a>
    81004c7a:	edce                	sd	s3,216(sp)
  ilock(ip);
    81004c7c:	d0afe0ef          	jal	81003186 <ilock>
  if(ip->nlink < 1)
    81004c80:	04a91783          	lh	a5,74(s2)
    81004c84:	06f05863          	blez	a5,81004cf4 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    81004c88:	04491703          	lh	a4,68(s2)
    81004c8c:	4785                	li	a5,1
    81004c8e:	06f70b63          	beq	a4,a5,81004d04 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    81004c92:	fb040993          	addi	s3,s0,-80
    81004c96:	4641                	li	a2,16
    81004c98:	4581                	li	a1,0
    81004c9a:	854e                	mv	a0,s3
    81004c9c:	840fc0ef          	jal	81000cdc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    81004ca0:	4741                	li	a4,16
    81004ca2:	f1c42683          	lw	a3,-228(s0)
    81004ca6:	864e                	mv	a2,s3
    81004ca8:	4581                	li	a1,0
    81004caa:	8526                	mv	a0,s1
    81004cac:	825fe0ef          	jal	810034d0 <writei>
    81004cb0:	47c1                	li	a5,16
    81004cb2:	08f51f63          	bne	a0,a5,81004d50 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    81004cb6:	04491703          	lh	a4,68(s2)
    81004cba:	4785                	li	a5,1
    81004cbc:	0af70263          	beq	a4,a5,81004d60 <sys_unlink+0x158>
  iunlockput(dp);
    81004cc0:	8526                	mv	a0,s1
    81004cc2:	ecefe0ef          	jal	81003390 <iunlockput>
  ip->nlink--;
    81004cc6:	04a95783          	lhu	a5,74(s2)
    81004cca:	37fd                	addiw	a5,a5,-1
    81004ccc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    81004cd0:	854a                	mv	a0,s2
    81004cd2:	c00fe0ef          	jal	810030d2 <iupdate>
  iunlockput(ip);
    81004cd6:	854a                	mv	a0,s2
    81004cd8:	eb8fe0ef          	jal	81003390 <iunlockput>
  end_op();
    81004cdc:	dc7fe0ef          	jal	81003aa2 <end_op>
  return 0;
    81004ce0:	4501                	li	a0,0
    81004ce2:	74ae                	ld	s1,232(sp)
    81004ce4:	790e                	ld	s2,224(sp)
    81004ce6:	69ee                	ld	s3,216(sp)
    81004ce8:	a869                	j	81004d82 <sys_unlink+0x17a>
    end_op();
    81004cea:	db9fe0ef          	jal	81003aa2 <end_op>
    return -1;
    81004cee:	557d                	li	a0,-1
    81004cf0:	74ae                	ld	s1,232(sp)
    81004cf2:	a841                	j	81004d82 <sys_unlink+0x17a>
    81004cf4:	e9d2                	sd	s4,208(sp)
    81004cf6:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    81004cf8:	00003517          	auipc	a0,0x3
    81004cfc:	93850513          	addi	a0,a0,-1736 # 81007630 <etext+0x630>
    81004d00:	aa9fb0ef          	jal	810007a8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    81004d04:	04c92703          	lw	a4,76(s2)
    81004d08:	02000793          	li	a5,32
    81004d0c:	f8e7f3e3          	bgeu	a5,a4,81004c92 <sys_unlink+0x8a>
    81004d10:	e9d2                	sd	s4,208(sp)
    81004d12:	e5d6                	sd	s5,200(sp)
    81004d14:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    81004d16:	f0840a93          	addi	s5,s0,-248
    81004d1a:	4a41                	li	s4,16
    81004d1c:	8752                	mv	a4,s4
    81004d1e:	86ce                	mv	a3,s3
    81004d20:	8656                	mv	a2,s5
    81004d22:	4581                	li	a1,0
    81004d24:	854a                	mv	a0,s2
    81004d26:	eb8fe0ef          	jal	810033de <readi>
    81004d2a:	01451d63          	bne	a0,s4,81004d44 <sys_unlink+0x13c>
    if(de.inum != 0)
    81004d2e:	f0845783          	lhu	a5,-248(s0)
    81004d32:	efb1                	bnez	a5,81004d8e <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    81004d34:	29c1                	addiw	s3,s3,16
    81004d36:	04c92783          	lw	a5,76(s2)
    81004d3a:	fef9e1e3          	bltu	s3,a5,81004d1c <sys_unlink+0x114>
    81004d3e:	6a4e                	ld	s4,208(sp)
    81004d40:	6aae                	ld	s5,200(sp)
    81004d42:	bf81                	j	81004c92 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    81004d44:	00003517          	auipc	a0,0x3
    81004d48:	90450513          	addi	a0,a0,-1788 # 81007648 <etext+0x648>
    81004d4c:	a5dfb0ef          	jal	810007a8 <panic>
    81004d50:	e9d2                	sd	s4,208(sp)
    81004d52:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    81004d54:	00003517          	auipc	a0,0x3
    81004d58:	90c50513          	addi	a0,a0,-1780 # 81007660 <etext+0x660>
    81004d5c:	a4dfb0ef          	jal	810007a8 <panic>
    dp->nlink--;
    81004d60:	04a4d783          	lhu	a5,74(s1)
    81004d64:	37fd                	addiw	a5,a5,-1
    81004d66:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    81004d6a:	8526                	mv	a0,s1
    81004d6c:	b66fe0ef          	jal	810030d2 <iupdate>
    81004d70:	bf81                	j	81004cc0 <sys_unlink+0xb8>
    81004d72:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    81004d74:	8526                	mv	a0,s1
    81004d76:	e1afe0ef          	jal	81003390 <iunlockput>
  end_op();
    81004d7a:	d29fe0ef          	jal	81003aa2 <end_op>
  return -1;
    81004d7e:	557d                	li	a0,-1
    81004d80:	74ae                	ld	s1,232(sp)
}
    81004d82:	70ee                	ld	ra,248(sp)
    81004d84:	744e                	ld	s0,240(sp)
    81004d86:	6111                	addi	sp,sp,256
    81004d88:	8082                	ret
    return -1;
    81004d8a:	557d                	li	a0,-1
    81004d8c:	bfdd                	j	81004d82 <sys_unlink+0x17a>
    iunlockput(ip);
    81004d8e:	854a                	mv	a0,s2
    81004d90:	e00fe0ef          	jal	81003390 <iunlockput>
    goto bad;
    81004d94:	790e                	ld	s2,224(sp)
    81004d96:	69ee                	ld	s3,216(sp)
    81004d98:	6a4e                	ld	s4,208(sp)
    81004d9a:	6aae                	ld	s5,200(sp)
    81004d9c:	bfe1                	j	81004d74 <sys_unlink+0x16c>

0000000081004d9e <sys_open>:

uint64
sys_open(void)
{
    81004d9e:	7131                	addi	sp,sp,-192
    81004da0:	fd06                	sd	ra,184(sp)
    81004da2:	f922                	sd	s0,176(sp)
    81004da4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    81004da6:	f4c40593          	addi	a1,s0,-180
    81004daa:	4505                	li	a0,1
    81004dac:	9ddfd0ef          	jal	81002788 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    81004db0:	08000613          	li	a2,128
    81004db4:	f5040593          	addi	a1,s0,-176
    81004db8:	4501                	li	a0,0
    81004dba:	a07fd0ef          	jal	810027c0 <argstr>
    81004dbe:	87aa                	mv	a5,a0
    return -1;
    81004dc0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    81004dc2:	0a07c363          	bltz	a5,81004e68 <sys_open+0xca>
    81004dc6:	f526                	sd	s1,168(sp)

  begin_op();
    81004dc8:	c71fe0ef          	jal	81003a38 <begin_op>

  if(omode & O_CREATE){
    81004dcc:	f4c42783          	lw	a5,-180(s0)
    81004dd0:	2007f793          	andi	a5,a5,512
    81004dd4:	c3dd                	beqz	a5,81004e7a <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    81004dd6:	4681                	li	a3,0
    81004dd8:	4601                	li	a2,0
    81004dda:	4589                	li	a1,2
    81004ddc:	f5040513          	addi	a0,s0,-176
    81004de0:	a99ff0ef          	jal	81004878 <create>
    81004de4:	84aa                	mv	s1,a0
    if(ip == 0){
    81004de6:	c549                	beqz	a0,81004e70 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    81004de8:	04449703          	lh	a4,68(s1)
    81004dec:	478d                	li	a5,3
    81004dee:	00f71763          	bne	a4,a5,81004dfc <sys_open+0x5e>
    81004df2:	0464d703          	lhu	a4,70(s1)
    81004df6:	47a5                	li	a5,9
    81004df8:	0ae7ee63          	bltu	a5,a4,81004eb4 <sys_open+0x116>
    81004dfc:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    81004dfe:	fb7fe0ef          	jal	81003db4 <filealloc>
    81004e02:	892a                	mv	s2,a0
    81004e04:	c561                	beqz	a0,81004ecc <sys_open+0x12e>
    81004e06:	ed4e                	sd	s3,152(sp)
    81004e08:	a33ff0ef          	jal	8100483a <fdalloc>
    81004e0c:	89aa                	mv	s3,a0
    81004e0e:	0a054b63          	bltz	a0,81004ec4 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    81004e12:	04449703          	lh	a4,68(s1)
    81004e16:	478d                	li	a5,3
    81004e18:	0cf70363          	beq	a4,a5,81004ede <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    81004e1c:	4789                	li	a5,2
    81004e1e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    81004e22:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    81004e26:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    81004e2a:	f4c42783          	lw	a5,-180(s0)
    81004e2e:	0017f713          	andi	a4,a5,1
    81004e32:	00174713          	xori	a4,a4,1
    81004e36:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    81004e3a:	0037f713          	andi	a4,a5,3
    81004e3e:	00e03733          	snez	a4,a4
    81004e42:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    81004e46:	4007f793          	andi	a5,a5,1024
    81004e4a:	c791                	beqz	a5,81004e56 <sys_open+0xb8>
    81004e4c:	04449703          	lh	a4,68(s1)
    81004e50:	4789                	li	a5,2
    81004e52:	08f70d63          	beq	a4,a5,81004eec <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    81004e56:	8526                	mv	a0,s1
    81004e58:	bdcfe0ef          	jal	81003234 <iunlock>
  end_op();
    81004e5c:	c47fe0ef          	jal	81003aa2 <end_op>

  return fd;
    81004e60:	854e                	mv	a0,s3
    81004e62:	74aa                	ld	s1,168(sp)
    81004e64:	790a                	ld	s2,160(sp)
    81004e66:	69ea                	ld	s3,152(sp)
}
    81004e68:	70ea                	ld	ra,184(sp)
    81004e6a:	744a                	ld	s0,176(sp)
    81004e6c:	6129                	addi	sp,sp,192
    81004e6e:	8082                	ret
      end_op();
    81004e70:	c33fe0ef          	jal	81003aa2 <end_op>
      return -1;
    81004e74:	557d                	li	a0,-1
    81004e76:	74aa                	ld	s1,168(sp)
    81004e78:	bfc5                	j	81004e68 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    81004e7a:	f5040513          	addi	a0,s0,-176
    81004e7e:	9f9fe0ef          	jal	81003876 <namei>
    81004e82:	84aa                	mv	s1,a0
    81004e84:	c11d                	beqz	a0,81004eaa <sys_open+0x10c>
    ilock(ip);
    81004e86:	b00fe0ef          	jal	81003186 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    81004e8a:	04449703          	lh	a4,68(s1)
    81004e8e:	4785                	li	a5,1
    81004e90:	f4f71ce3          	bne	a4,a5,81004de8 <sys_open+0x4a>
    81004e94:	f4c42783          	lw	a5,-180(s0)
    81004e98:	d3b5                	beqz	a5,81004dfc <sys_open+0x5e>
      iunlockput(ip);
    81004e9a:	8526                	mv	a0,s1
    81004e9c:	cf4fe0ef          	jal	81003390 <iunlockput>
      end_op();
    81004ea0:	c03fe0ef          	jal	81003aa2 <end_op>
      return -1;
    81004ea4:	557d                	li	a0,-1
    81004ea6:	74aa                	ld	s1,168(sp)
    81004ea8:	b7c1                	j	81004e68 <sys_open+0xca>
      end_op();
    81004eaa:	bf9fe0ef          	jal	81003aa2 <end_op>
      return -1;
    81004eae:	557d                	li	a0,-1
    81004eb0:	74aa                	ld	s1,168(sp)
    81004eb2:	bf5d                	j	81004e68 <sys_open+0xca>
    iunlockput(ip);
    81004eb4:	8526                	mv	a0,s1
    81004eb6:	cdafe0ef          	jal	81003390 <iunlockput>
    end_op();
    81004eba:	be9fe0ef          	jal	81003aa2 <end_op>
    return -1;
    81004ebe:	557d                	li	a0,-1
    81004ec0:	74aa                	ld	s1,168(sp)
    81004ec2:	b75d                	j	81004e68 <sys_open+0xca>
      fileclose(f);
    81004ec4:	854a                	mv	a0,s2
    81004ec6:	f93fe0ef          	jal	81003e58 <fileclose>
    81004eca:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    81004ecc:	8526                	mv	a0,s1
    81004ece:	cc2fe0ef          	jal	81003390 <iunlockput>
    end_op();
    81004ed2:	bd1fe0ef          	jal	81003aa2 <end_op>
    return -1;
    81004ed6:	557d                	li	a0,-1
    81004ed8:	74aa                	ld	s1,168(sp)
    81004eda:	790a                	ld	s2,160(sp)
    81004edc:	b771                	j	81004e68 <sys_open+0xca>
    f->type = FD_DEVICE;
    81004ede:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    81004ee2:	04649783          	lh	a5,70(s1)
    81004ee6:	02f91223          	sh	a5,36(s2)
    81004eea:	bf35                	j	81004e26 <sys_open+0x88>
    itrunc(ip);
    81004eec:	8526                	mv	a0,s1
    81004eee:	b86fe0ef          	jal	81003274 <itrunc>
    81004ef2:	b795                	j	81004e56 <sys_open+0xb8>

0000000081004ef4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    81004ef4:	7175                	addi	sp,sp,-144
    81004ef6:	e506                	sd	ra,136(sp)
    81004ef8:	e122                	sd	s0,128(sp)
    81004efa:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    81004efc:	b3dfe0ef          	jal	81003a38 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    81004f00:	08000613          	li	a2,128
    81004f04:	f7040593          	addi	a1,s0,-144
    81004f08:	4501                	li	a0,0
    81004f0a:	8b7fd0ef          	jal	810027c0 <argstr>
    81004f0e:	02054363          	bltz	a0,81004f34 <sys_mkdir+0x40>
    81004f12:	4681                	li	a3,0
    81004f14:	4601                	li	a2,0
    81004f16:	4585                	li	a1,1
    81004f18:	f7040513          	addi	a0,s0,-144
    81004f1c:	95dff0ef          	jal	81004878 <create>
    81004f20:	c911                	beqz	a0,81004f34 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    81004f22:	c6efe0ef          	jal	81003390 <iunlockput>
  end_op();
    81004f26:	b7dfe0ef          	jal	81003aa2 <end_op>
  return 0;
    81004f2a:	4501                	li	a0,0
}
    81004f2c:	60aa                	ld	ra,136(sp)
    81004f2e:	640a                	ld	s0,128(sp)
    81004f30:	6149                	addi	sp,sp,144
    81004f32:	8082                	ret
    end_op();
    81004f34:	b6ffe0ef          	jal	81003aa2 <end_op>
    return -1;
    81004f38:	557d                	li	a0,-1
    81004f3a:	bfcd                	j	81004f2c <sys_mkdir+0x38>

0000000081004f3c <sys_mknod>:

uint64
sys_mknod(void)
{
    81004f3c:	7135                	addi	sp,sp,-160
    81004f3e:	ed06                	sd	ra,152(sp)
    81004f40:	e922                	sd	s0,144(sp)
    81004f42:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    81004f44:	af5fe0ef          	jal	81003a38 <begin_op>
  argint(1, &major);
    81004f48:	f6c40593          	addi	a1,s0,-148
    81004f4c:	4505                	li	a0,1
    81004f4e:	83bfd0ef          	jal	81002788 <argint>
  argint(2, &minor);
    81004f52:	f6840593          	addi	a1,s0,-152
    81004f56:	4509                	li	a0,2
    81004f58:	831fd0ef          	jal	81002788 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    81004f5c:	08000613          	li	a2,128
    81004f60:	f7040593          	addi	a1,s0,-144
    81004f64:	4501                	li	a0,0
    81004f66:	85bfd0ef          	jal	810027c0 <argstr>
    81004f6a:	02054563          	bltz	a0,81004f94 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    81004f6e:	f6841683          	lh	a3,-152(s0)
    81004f72:	f6c41603          	lh	a2,-148(s0)
    81004f76:	458d                	li	a1,3
    81004f78:	f7040513          	addi	a0,s0,-144
    81004f7c:	8fdff0ef          	jal	81004878 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    81004f80:	c911                	beqz	a0,81004f94 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    81004f82:	c0efe0ef          	jal	81003390 <iunlockput>
  end_op();
    81004f86:	b1dfe0ef          	jal	81003aa2 <end_op>
  return 0;
    81004f8a:	4501                	li	a0,0
}
    81004f8c:	60ea                	ld	ra,152(sp)
    81004f8e:	644a                	ld	s0,144(sp)
    81004f90:	610d                	addi	sp,sp,160
    81004f92:	8082                	ret
    end_op();
    81004f94:	b0ffe0ef          	jal	81003aa2 <end_op>
    return -1;
    81004f98:	557d                	li	a0,-1
    81004f9a:	bfcd                	j	81004f8c <sys_mknod+0x50>

0000000081004f9c <sys_chdir>:

uint64
sys_chdir(void)
{
    81004f9c:	7135                	addi	sp,sp,-160
    81004f9e:	ed06                	sd	ra,152(sp)
    81004fa0:	e922                	sd	s0,144(sp)
    81004fa2:	e14a                	sd	s2,128(sp)
    81004fa4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    81004fa6:	931fc0ef          	jal	810018d6 <myproc>
    81004faa:	892a                	mv	s2,a0
  
  begin_op();
    81004fac:	a8dfe0ef          	jal	81003a38 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    81004fb0:	08000613          	li	a2,128
    81004fb4:	f6040593          	addi	a1,s0,-160
    81004fb8:	4501                	li	a0,0
    81004fba:	807fd0ef          	jal	810027c0 <argstr>
    81004fbe:	04054363          	bltz	a0,81005004 <sys_chdir+0x68>
    81004fc2:	e526                	sd	s1,136(sp)
    81004fc4:	f6040513          	addi	a0,s0,-160
    81004fc8:	8affe0ef          	jal	81003876 <namei>
    81004fcc:	84aa                	mv	s1,a0
    81004fce:	c915                	beqz	a0,81005002 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    81004fd0:	9b6fe0ef          	jal	81003186 <ilock>
  if(ip->type != T_DIR){
    81004fd4:	04449703          	lh	a4,68(s1)
    81004fd8:	4785                	li	a5,1
    81004fda:	02f71963          	bne	a4,a5,8100500c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    81004fde:	8526                	mv	a0,s1
    81004fe0:	a54fe0ef          	jal	81003234 <iunlock>
  iput(p->cwd);
    81004fe4:	15093503          	ld	a0,336(s2)
    81004fe8:	b20fe0ef          	jal	81003308 <iput>
  end_op();
    81004fec:	ab7fe0ef          	jal	81003aa2 <end_op>
  p->cwd = ip;
    81004ff0:	14993823          	sd	s1,336(s2)
  return 0;
    81004ff4:	4501                	li	a0,0
    81004ff6:	64aa                	ld	s1,136(sp)
}
    81004ff8:	60ea                	ld	ra,152(sp)
    81004ffa:	644a                	ld	s0,144(sp)
    81004ffc:	690a                	ld	s2,128(sp)
    81004ffe:	610d                	addi	sp,sp,160
    81005000:	8082                	ret
    81005002:	64aa                	ld	s1,136(sp)
    end_op();
    81005004:	a9ffe0ef          	jal	81003aa2 <end_op>
    return -1;
    81005008:	557d                	li	a0,-1
    8100500a:	b7fd                	j	81004ff8 <sys_chdir+0x5c>
    iunlockput(ip);
    8100500c:	8526                	mv	a0,s1
    8100500e:	b82fe0ef          	jal	81003390 <iunlockput>
    end_op();
    81005012:	a91fe0ef          	jal	81003aa2 <end_op>
    return -1;
    81005016:	557d                	li	a0,-1
    81005018:	64aa                	ld	s1,136(sp)
    8100501a:	bff9                	j	81004ff8 <sys_chdir+0x5c>

000000008100501c <sys_exec>:

uint64
sys_exec(void)
{
    8100501c:	7105                	addi	sp,sp,-480
    8100501e:	ef86                	sd	ra,472(sp)
    81005020:	eba2                	sd	s0,464(sp)
    81005022:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    81005024:	e2840593          	addi	a1,s0,-472
    81005028:	4505                	li	a0,1
    8100502a:	f7afd0ef          	jal	810027a4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8100502e:	08000613          	li	a2,128
    81005032:	f3040593          	addi	a1,s0,-208
    81005036:	4501                	li	a0,0
    81005038:	f88fd0ef          	jal	810027c0 <argstr>
    8100503c:	87aa                	mv	a5,a0
    return -1;
    8100503e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    81005040:	0e07c063          	bltz	a5,81005120 <sys_exec+0x104>
    81005044:	e7a6                	sd	s1,456(sp)
    81005046:	e3ca                	sd	s2,448(sp)
    81005048:	ff4e                	sd	s3,440(sp)
    8100504a:	fb52                	sd	s4,432(sp)
    8100504c:	f756                	sd	s5,424(sp)
    8100504e:	f35a                	sd	s6,416(sp)
    81005050:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    81005052:	e3040a13          	addi	s4,s0,-464
    81005056:	10000613          	li	a2,256
    8100505a:	4581                	li	a1,0
    8100505c:	8552                	mv	a0,s4
    8100505e:	c7ffb0ef          	jal	81000cdc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    81005062:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    81005064:	89d2                	mv	s3,s4
    81005066:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    81005068:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8100506c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8100506e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    81005072:	00391513          	slli	a0,s2,0x3
    81005076:	85d6                	mv	a1,s5
    81005078:	e2843783          	ld	a5,-472(s0)
    8100507c:	953e                	add	a0,a0,a5
    8100507e:	e80fd0ef          	jal	810026fe <fetchaddr>
    81005082:	02054663          	bltz	a0,810050ae <sys_exec+0x92>
    if(uarg == 0){
    81005086:	e2043783          	ld	a5,-480(s0)
    8100508a:	c7a1                	beqz	a5,810050d2 <sys_exec+0xb6>
    argv[i] = kalloc();
    8100508c:	aadfb0ef          	jal	81000b38 <kalloc>
    81005090:	85aa                	mv	a1,a0
    81005092:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    81005096:	cd01                	beqz	a0,810050ae <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    81005098:	865a                	mv	a2,s6
    8100509a:	e2043503          	ld	a0,-480(s0)
    8100509e:	eaafd0ef          	jal	81002748 <fetchstr>
    810050a2:	00054663          	bltz	a0,810050ae <sys_exec+0x92>
    if(i >= NELEM(argv)){
    810050a6:	0905                	addi	s2,s2,1
    810050a8:	09a1                	addi	s3,s3,8
    810050aa:	fd7914e3          	bne	s2,s7,81005072 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    810050ae:	100a0a13          	addi	s4,s4,256
    810050b2:	6088                	ld	a0,0(s1)
    810050b4:	cd31                	beqz	a0,81005110 <sys_exec+0xf4>
    kfree(argv[i]);
    810050b6:	99dfb0ef          	jal	81000a52 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    810050ba:	04a1                	addi	s1,s1,8
    810050bc:	ff449be3          	bne	s1,s4,810050b2 <sys_exec+0x96>
  return -1;
    810050c0:	557d                	li	a0,-1
    810050c2:	64be                	ld	s1,456(sp)
    810050c4:	691e                	ld	s2,448(sp)
    810050c6:	79fa                	ld	s3,440(sp)
    810050c8:	7a5a                	ld	s4,432(sp)
    810050ca:	7aba                	ld	s5,424(sp)
    810050cc:	7b1a                	ld	s6,416(sp)
    810050ce:	6bfa                	ld	s7,408(sp)
    810050d0:	a881                	j	81005120 <sys_exec+0x104>
      argv[i] = 0;
    810050d2:	0009079b          	sext.w	a5,s2
    810050d6:	e3040593          	addi	a1,s0,-464
    810050da:	078e                	slli	a5,a5,0x3
    810050dc:	97ae                	add	a5,a5,a1
    810050de:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    810050e2:	f3040513          	addi	a0,s0,-208
    810050e6:	ba4ff0ef          	jal	8100448a <exec>
    810050ea:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    810050ec:	100a0a13          	addi	s4,s4,256
    810050f0:	6088                	ld	a0,0(s1)
    810050f2:	c511                	beqz	a0,810050fe <sys_exec+0xe2>
    kfree(argv[i]);
    810050f4:	95ffb0ef          	jal	81000a52 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    810050f8:	04a1                	addi	s1,s1,8
    810050fa:	ff449be3          	bne	s1,s4,810050f0 <sys_exec+0xd4>
  return ret;
    810050fe:	854a                	mv	a0,s2
    81005100:	64be                	ld	s1,456(sp)
    81005102:	691e                	ld	s2,448(sp)
    81005104:	79fa                	ld	s3,440(sp)
    81005106:	7a5a                	ld	s4,432(sp)
    81005108:	7aba                	ld	s5,424(sp)
    8100510a:	7b1a                	ld	s6,416(sp)
    8100510c:	6bfa                	ld	s7,408(sp)
    8100510e:	a809                	j	81005120 <sys_exec+0x104>
  return -1;
    81005110:	557d                	li	a0,-1
    81005112:	64be                	ld	s1,456(sp)
    81005114:	691e                	ld	s2,448(sp)
    81005116:	79fa                	ld	s3,440(sp)
    81005118:	7a5a                	ld	s4,432(sp)
    8100511a:	7aba                	ld	s5,424(sp)
    8100511c:	7b1a                	ld	s6,416(sp)
    8100511e:	6bfa                	ld	s7,408(sp)
}
    81005120:	60fe                	ld	ra,472(sp)
    81005122:	645e                	ld	s0,464(sp)
    81005124:	613d                	addi	sp,sp,480
    81005126:	8082                	ret

0000000081005128 <sys_pipe>:

uint64
sys_pipe(void)
{
    81005128:	7139                	addi	sp,sp,-64
    8100512a:	fc06                	sd	ra,56(sp)
    8100512c:	f822                	sd	s0,48(sp)
    8100512e:	f426                	sd	s1,40(sp)
    81005130:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    81005132:	fa4fc0ef          	jal	810018d6 <myproc>
    81005136:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    81005138:	fd840593          	addi	a1,s0,-40
    8100513c:	4501                	li	a0,0
    8100513e:	e66fd0ef          	jal	810027a4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    81005142:	fc840593          	addi	a1,s0,-56
    81005146:	fd040513          	addi	a0,s0,-48
    8100514a:	81eff0ef          	jal	81004168 <pipealloc>
    return -1;
    8100514e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    81005150:	0a054463          	bltz	a0,810051f8 <sys_pipe+0xd0>
  fd0 = -1;
    81005154:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    81005158:	fd043503          	ld	a0,-48(s0)
    8100515c:	edeff0ef          	jal	8100483a <fdalloc>
    81005160:	fca42223          	sw	a0,-60(s0)
    81005164:	08054163          	bltz	a0,810051e6 <sys_pipe+0xbe>
    81005168:	fc843503          	ld	a0,-56(s0)
    8100516c:	eceff0ef          	jal	8100483a <fdalloc>
    81005170:	fca42023          	sw	a0,-64(s0)
    81005174:	06054063          	bltz	a0,810051d4 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    81005178:	4691                	li	a3,4
    8100517a:	fc440613          	addi	a2,s0,-60
    8100517e:	fd843583          	ld	a1,-40(s0)
    81005182:	68a8                	ld	a0,80(s1)
    81005184:	bfafc0ef          	jal	8100157e <copyout>
    81005188:	00054e63          	bltz	a0,810051a4 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8100518c:	4691                	li	a3,4
    8100518e:	fc040613          	addi	a2,s0,-64
    81005192:	fd843583          	ld	a1,-40(s0)
    81005196:	95b6                	add	a1,a1,a3
    81005198:	68a8                	ld	a0,80(s1)
    8100519a:	be4fc0ef          	jal	8100157e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8100519e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    810051a0:	04055c63          	bgez	a0,810051f8 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    810051a4:	fc442783          	lw	a5,-60(s0)
    810051a8:	07e9                	addi	a5,a5,26
    810051aa:	078e                	slli	a5,a5,0x3
    810051ac:	97a6                	add	a5,a5,s1
    810051ae:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    810051b2:	fc042783          	lw	a5,-64(s0)
    810051b6:	07e9                	addi	a5,a5,26
    810051b8:	078e                	slli	a5,a5,0x3
    810051ba:	94be                	add	s1,s1,a5
    810051bc:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    810051c0:	fd043503          	ld	a0,-48(s0)
    810051c4:	c95fe0ef          	jal	81003e58 <fileclose>
    fileclose(wf);
    810051c8:	fc843503          	ld	a0,-56(s0)
    810051cc:	c8dfe0ef          	jal	81003e58 <fileclose>
    return -1;
    810051d0:	57fd                	li	a5,-1
    810051d2:	a01d                	j	810051f8 <sys_pipe+0xd0>
    if(fd0 >= 0)
    810051d4:	fc442783          	lw	a5,-60(s0)
    810051d8:	0007c763          	bltz	a5,810051e6 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    810051dc:	07e9                	addi	a5,a5,26
    810051de:	078e                	slli	a5,a5,0x3
    810051e0:	97a6                	add	a5,a5,s1
    810051e2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    810051e6:	fd043503          	ld	a0,-48(s0)
    810051ea:	c6ffe0ef          	jal	81003e58 <fileclose>
    fileclose(wf);
    810051ee:	fc843503          	ld	a0,-56(s0)
    810051f2:	c67fe0ef          	jal	81003e58 <fileclose>
    return -1;
    810051f6:	57fd                	li	a5,-1
}
    810051f8:	853e                	mv	a0,a5
    810051fa:	70e2                	ld	ra,56(sp)
    810051fc:	7442                	ld	s0,48(sp)
    810051fe:	74a2                	ld	s1,40(sp)
    81005200:	6121                	addi	sp,sp,64
    81005202:	8082                	ret
	...

0000000081005210 <kernelvec>:
    81005210:	7111                	addi	sp,sp,-256
    81005212:	e006                	sd	ra,0(sp)
    81005214:	e40a                	sd	sp,8(sp)
    81005216:	e80e                	sd	gp,16(sp)
    81005218:	ec12                	sd	tp,24(sp)
    8100521a:	f016                	sd	t0,32(sp)
    8100521c:	f41a                	sd	t1,40(sp)
    8100521e:	f81e                	sd	t2,48(sp)
    81005220:	e4aa                	sd	a0,72(sp)
    81005222:	e8ae                	sd	a1,80(sp)
    81005224:	ecb2                	sd	a2,88(sp)
    81005226:	f0b6                	sd	a3,96(sp)
    81005228:	f4ba                	sd	a4,104(sp)
    8100522a:	f8be                	sd	a5,112(sp)
    8100522c:	fcc2                	sd	a6,120(sp)
    8100522e:	e146                	sd	a7,128(sp)
    81005230:	edf2                	sd	t3,216(sp)
    81005232:	f1f6                	sd	t4,224(sp)
    81005234:	f5fa                	sd	t5,232(sp)
    81005236:	f9fe                	sd	t6,240(sp)
    81005238:	bd6fd0ef          	jal	8100260e <kerneltrap>
    8100523c:	6082                	ld	ra,0(sp)
    8100523e:	6122                	ld	sp,8(sp)
    81005240:	61c2                	ld	gp,16(sp)
    81005242:	7282                	ld	t0,32(sp)
    81005244:	7322                	ld	t1,40(sp)
    81005246:	73c2                	ld	t2,48(sp)
    81005248:	6526                	ld	a0,72(sp)
    8100524a:	65c6                	ld	a1,80(sp)
    8100524c:	6666                	ld	a2,88(sp)
    8100524e:	7686                	ld	a3,96(sp)
    81005250:	7726                	ld	a4,104(sp)
    81005252:	77c6                	ld	a5,112(sp)
    81005254:	7866                	ld	a6,120(sp)
    81005256:	688a                	ld	a7,128(sp)
    81005258:	6e6e                	ld	t3,216(sp)
    8100525a:	7e8e                	ld	t4,224(sp)
    8100525c:	7f2e                	ld	t5,232(sp)
    8100525e:	7fce                	ld	t6,240(sp)
    81005260:	6111                	addi	sp,sp,256
    81005262:	10200073          	sret
	...

000000008100526e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8100526e:	1141                	addi	sp,sp,-16
    81005270:	e406                	sd	ra,8(sp)
    81005272:	e022                	sd	s0,0(sp)
    81005274:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    81005276:	0c000737          	lui	a4,0xc000
    8100527a:	4785                	li	a5,1
    8100527c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8100527e:	c35c                	sw	a5,4(a4)
}
    81005280:	60a2                	ld	ra,8(sp)
    81005282:	6402                	ld	s0,0(sp)
    81005284:	0141                	addi	sp,sp,16
    81005286:	8082                	ret

0000000081005288 <plicinithart>:

void
plicinithart(void)
{
    81005288:	1141                	addi	sp,sp,-16
    8100528a:	e406                	sd	ra,8(sp)
    8100528c:	e022                	sd	s0,0(sp)
    8100528e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    81005290:	e12fc0ef          	jal	810018a2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    81005294:	0085171b          	slliw	a4,a0,0x8
    81005298:	0c0027b7          	lui	a5,0xc002
    8100529c:	97ba                	add	a5,a5,a4
    8100529e:	40200713          	li	a4,1026
    810052a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x74ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    810052a6:	00d5151b          	slliw	a0,a0,0xd
    810052aa:	0c2017b7          	lui	a5,0xc201
    810052ae:	97aa                	add	a5,a5,a0
    810052b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x74dff000>
}
    810052b4:	60a2                	ld	ra,8(sp)
    810052b6:	6402                	ld	s0,0(sp)
    810052b8:	0141                	addi	sp,sp,16
    810052ba:	8082                	ret

00000000810052bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    810052bc:	1141                	addi	sp,sp,-16
    810052be:	e406                	sd	ra,8(sp)
    810052c0:	e022                	sd	s0,0(sp)
    810052c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    810052c4:	ddefc0ef          	jal	810018a2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    810052c8:	00d5151b          	slliw	a0,a0,0xd
    810052cc:	0c2017b7          	lui	a5,0xc201
    810052d0:	97aa                	add	a5,a5,a0
  return irq;
}
    810052d2:	43c8                	lw	a0,4(a5)
    810052d4:	60a2                	ld	ra,8(sp)
    810052d6:	6402                	ld	s0,0(sp)
    810052d8:	0141                	addi	sp,sp,16
    810052da:	8082                	ret

00000000810052dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    810052dc:	1101                	addi	sp,sp,-32
    810052de:	ec06                	sd	ra,24(sp)
    810052e0:	e822                	sd	s0,16(sp)
    810052e2:	e426                	sd	s1,8(sp)
    810052e4:	1000                	addi	s0,sp,32
    810052e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    810052e8:	dbafc0ef          	jal	810018a2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    810052ec:	00d5179b          	slliw	a5,a0,0xd
    810052f0:	0c201737          	lui	a4,0xc201
    810052f4:	97ba                	add	a5,a5,a4
    810052f6:	c3c4                	sw	s1,4(a5)
}
    810052f8:	60e2                	ld	ra,24(sp)
    810052fa:	6442                	ld	s0,16(sp)
    810052fc:	64a2                	ld	s1,8(sp)
    810052fe:	6105                	addi	sp,sp,32
    81005300:	8082                	ret

0000000081005302 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    81005302:	1141                	addi	sp,sp,-16
    81005304:	e406                	sd	ra,8(sp)
    81005306:	e022                	sd	s0,0(sp)
    81005308:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8100530a:	479d                	li	a5,7
    8100530c:	04a7ca63          	blt	a5,a0,81005360 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    81005310:	00013797          	auipc	a5,0x13
    81005314:	7f078793          	addi	a5,a5,2032 # 81018b00 <disk>
    81005318:	97aa                	add	a5,a5,a0
    8100531a:	0187c783          	lbu	a5,24(a5)
    8100531e:	e7b9                	bnez	a5,8100536c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    81005320:	00451693          	slli	a3,a0,0x4
    81005324:	00013797          	auipc	a5,0x13
    81005328:	7dc78793          	addi	a5,a5,2012 # 81018b00 <disk>
    8100532c:	6398                	ld	a4,0(a5)
    8100532e:	9736                	add	a4,a4,a3
    81005330:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x74dff000>
  disk.desc[i].len = 0;
    81005334:	6398                	ld	a4,0(a5)
    81005336:	9736                	add	a4,a4,a3
    81005338:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8100533c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    81005340:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    81005344:	97aa                	add	a5,a5,a0
    81005346:	4705                	li	a4,1
    81005348:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8100534c:	00013517          	auipc	a0,0x13
    81005350:	7cc50513          	addi	a0,a0,1996 # 81018b18 <disk+0x18>
    81005354:	b9dfc0ef          	jal	81001ef0 <wakeup>
}
    81005358:	60a2                	ld	ra,8(sp)
    8100535a:	6402                	ld	s0,0(sp)
    8100535c:	0141                	addi	sp,sp,16
    8100535e:	8082                	ret
    panic("free_desc 1");
    81005360:	00002517          	auipc	a0,0x2
    81005364:	31050513          	addi	a0,a0,784 # 81007670 <etext+0x670>
    81005368:	c40fb0ef          	jal	810007a8 <panic>
    panic("free_desc 2");
    8100536c:	00002517          	auipc	a0,0x2
    81005370:	31450513          	addi	a0,a0,788 # 81007680 <etext+0x680>
    81005374:	c34fb0ef          	jal	810007a8 <panic>

0000000081005378 <virtio_disk_init>:
{
    81005378:	1101                	addi	sp,sp,-32
    8100537a:	ec06                	sd	ra,24(sp)
    8100537c:	e822                	sd	s0,16(sp)
    8100537e:	e426                	sd	s1,8(sp)
    81005380:	e04a                	sd	s2,0(sp)
    81005382:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    81005384:	00002597          	auipc	a1,0x2
    81005388:	30c58593          	addi	a1,a1,780 # 81007690 <etext+0x690>
    8100538c:	00014517          	auipc	a0,0x14
    81005390:	89c50513          	addi	a0,a0,-1892 # 81018c28 <disk+0x128>
    81005394:	ff4fb0ef          	jal	81000b88 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    81005398:	100017b7          	lui	a5,0x10001
    8100539c:	4398                	lw	a4,0(a5)
    8100539e:	2701                	sext.w	a4,a4
    810053a0:	747277b7          	lui	a5,0x74727
    810053a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xc8d968a>
    810053a8:	14f71863          	bne	a4,a5,810054f8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    810053ac:	100017b7          	lui	a5,0x10001
    810053b0:	43dc                	lw	a5,4(a5)
    810053b2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    810053b4:	4709                	li	a4,2
    810053b6:	14e79163          	bne	a5,a4,810054f8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    810053ba:	100017b7          	lui	a5,0x10001
    810053be:	479c                	lw	a5,8(a5)
    810053c0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    810053c2:	12e79b63          	bne	a5,a4,810054f8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    810053c6:	100017b7          	lui	a5,0x10001
    810053ca:	47d8                	lw	a4,12(a5)
    810053cc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    810053ce:	554d47b7          	lui	a5,0x554d4
    810053d2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2bb2baaf>
    810053d6:	12f71163          	bne	a4,a5,810054f8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    810053da:	100017b7          	lui	a5,0x10001
    810053de:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x70ffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    810053e2:	4705                	li	a4,1
    810053e4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    810053e6:	470d                	li	a4,3
    810053e8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    810053ea:	10001737          	lui	a4,0x10001
    810053ee:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    810053f0:	c7ffe6b7          	lui	a3,0xc7ffe
    810053f4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff46fe575f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    810053f8:	8f75                	and	a4,a4,a3
    810053fa:	100016b7          	lui	a3,0x10001
    810053fe:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    81005400:	472d                	li	a4,11
    81005402:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    81005404:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    81005408:	439c                	lw	a5,0(a5)
    8100540a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8100540e:	8ba1                	andi	a5,a5,8
    81005410:	0e078a63          	beqz	a5,81005504 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    81005414:	100017b7          	lui	a5,0x10001
    81005418:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x70ffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8100541c:	43fc                	lw	a5,68(a5)
    8100541e:	2781                	sext.w	a5,a5
    81005420:	0e079863          	bnez	a5,81005510 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    81005424:	100017b7          	lui	a5,0x10001
    81005428:	5bdc                	lw	a5,52(a5)
    8100542a:	2781                	sext.w	a5,a5
  if(max == 0)
    8100542c:	0e078863          	beqz	a5,8100551c <virtio_disk_init+0x1a4>
  if(max < NUM)
    81005430:	471d                	li	a4,7
    81005432:	0ef77b63          	bgeu	a4,a5,81005528 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    81005436:	f02fb0ef          	jal	81000b38 <kalloc>
    8100543a:	00013497          	auipc	s1,0x13
    8100543e:	6c648493          	addi	s1,s1,1734 # 81018b00 <disk>
    81005442:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    81005444:	ef4fb0ef          	jal	81000b38 <kalloc>
    81005448:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8100544a:	eeefb0ef          	jal	81000b38 <kalloc>
    8100544e:	87aa                	mv	a5,a0
    81005450:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    81005452:	6088                	ld	a0,0(s1)
    81005454:	0e050063          	beqz	a0,81005534 <virtio_disk_init+0x1bc>
    81005458:	00013717          	auipc	a4,0x13
    8100545c:	6b073703          	ld	a4,1712(a4) # 81018b08 <disk+0x8>
    81005460:	cb71                	beqz	a4,81005534 <virtio_disk_init+0x1bc>
    81005462:	cbe9                	beqz	a5,81005534 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    81005464:	6605                	lui	a2,0x1
    81005466:	4581                	li	a1,0
    81005468:	875fb0ef          	jal	81000cdc <memset>
  memset(disk.avail, 0, PGSIZE);
    8100546c:	00013497          	auipc	s1,0x13
    81005470:	69448493          	addi	s1,s1,1684 # 81018b00 <disk>
    81005474:	6605                	lui	a2,0x1
    81005476:	4581                	li	a1,0
    81005478:	6488                	ld	a0,8(s1)
    8100547a:	863fb0ef          	jal	81000cdc <memset>
  memset(disk.used, 0, PGSIZE);
    8100547e:	6605                	lui	a2,0x1
    81005480:	4581                	li	a1,0
    81005482:	6888                	ld	a0,16(s1)
    81005484:	859fb0ef          	jal	81000cdc <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    81005488:	100017b7          	lui	a5,0x10001
    8100548c:	4721                	li	a4,8
    8100548e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    81005490:	4098                	lw	a4,0(s1)
    81005492:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x70ffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    81005496:	40d8                	lw	a4,4(s1)
    81005498:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8100549c:	649c                	ld	a5,8(s1)
    8100549e:	0007869b          	sext.w	a3,a5
    810054a2:	10001737          	lui	a4,0x10001
    810054a6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x70ffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    810054aa:	9781                	srai	a5,a5,0x20
    810054ac:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    810054b0:	689c                	ld	a5,16(s1)
    810054b2:	0007869b          	sext.w	a3,a5
    810054b6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    810054ba:	9781                	srai	a5,a5,0x20
    810054bc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    810054c0:	4785                	li	a5,1
    810054c2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    810054c4:	00f48c23          	sb	a5,24(s1)
    810054c8:	00f48ca3          	sb	a5,25(s1)
    810054cc:	00f48d23          	sb	a5,26(s1)
    810054d0:	00f48da3          	sb	a5,27(s1)
    810054d4:	00f48e23          	sb	a5,28(s1)
    810054d8:	00f48ea3          	sb	a5,29(s1)
    810054dc:	00f48f23          	sb	a5,30(s1)
    810054e0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    810054e4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    810054e8:	07272823          	sw	s2,112(a4)
}
    810054ec:	60e2                	ld	ra,24(sp)
    810054ee:	6442                	ld	s0,16(sp)
    810054f0:	64a2                	ld	s1,8(sp)
    810054f2:	6902                	ld	s2,0(sp)
    810054f4:	6105                	addi	sp,sp,32
    810054f6:	8082                	ret
    panic("could not find virtio disk");
    810054f8:	00002517          	auipc	a0,0x2
    810054fc:	1a850513          	addi	a0,a0,424 # 810076a0 <etext+0x6a0>
    81005500:	aa8fb0ef          	jal	810007a8 <panic>
    panic("virtio disk FEATURES_OK unset");
    81005504:	00002517          	auipc	a0,0x2
    81005508:	1bc50513          	addi	a0,a0,444 # 810076c0 <etext+0x6c0>
    8100550c:	a9cfb0ef          	jal	810007a8 <panic>
    panic("virtio disk should not be ready");
    81005510:	00002517          	auipc	a0,0x2
    81005514:	1d050513          	addi	a0,a0,464 # 810076e0 <etext+0x6e0>
    81005518:	a90fb0ef          	jal	810007a8 <panic>
    panic("virtio disk has no queue 0");
    8100551c:	00002517          	auipc	a0,0x2
    81005520:	1e450513          	addi	a0,a0,484 # 81007700 <etext+0x700>
    81005524:	a84fb0ef          	jal	810007a8 <panic>
    panic("virtio disk max queue too short");
    81005528:	00002517          	auipc	a0,0x2
    8100552c:	1f850513          	addi	a0,a0,504 # 81007720 <etext+0x720>
    81005530:	a78fb0ef          	jal	810007a8 <panic>
    panic("virtio disk kalloc");
    81005534:	00002517          	auipc	a0,0x2
    81005538:	20c50513          	addi	a0,a0,524 # 81007740 <etext+0x740>
    8100553c:	a6cfb0ef          	jal	810007a8 <panic>

0000000081005540 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    81005540:	711d                	addi	sp,sp,-96
    81005542:	ec86                	sd	ra,88(sp)
    81005544:	e8a2                	sd	s0,80(sp)
    81005546:	e4a6                	sd	s1,72(sp)
    81005548:	e0ca                	sd	s2,64(sp)
    8100554a:	fc4e                	sd	s3,56(sp)
    8100554c:	f852                	sd	s4,48(sp)
    8100554e:	f456                	sd	s5,40(sp)
    81005550:	f05a                	sd	s6,32(sp)
    81005552:	ec5e                	sd	s7,24(sp)
    81005554:	e862                	sd	s8,16(sp)
    81005556:	1080                	addi	s0,sp,96
    81005558:	89aa                	mv	s3,a0
    8100555a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8100555c:	00c52b83          	lw	s7,12(a0)
    81005560:	001b9b9b          	slliw	s7,s7,0x1
    81005564:	1b82                	slli	s7,s7,0x20
    81005566:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8100556a:	00013517          	auipc	a0,0x13
    8100556e:	6be50513          	addi	a0,a0,1726 # 81018c28 <disk+0x128>
    81005572:	e9afb0ef          	jal	81000c0c <acquire>
  for(int i = 0; i < NUM; i++){
    81005576:	44a1                	li	s1,8
      disk.free[i] = 0;
    81005578:	00013a97          	auipc	s5,0x13
    8100557c:	588a8a93          	addi	s5,s5,1416 # 81018b00 <disk>
  for(int i = 0; i < 3; i++){
    81005580:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    81005582:	5c7d                	li	s8,-1
    81005584:	a095                	j	810055e8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    81005586:	00fa8733          	add	a4,s5,a5
    8100558a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8100558e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    81005590:	0207c563          	bltz	a5,810055ba <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    81005594:	2905                	addiw	s2,s2,1
    81005596:	0611                	addi	a2,a2,4 # 1004 <_entry-0x80ffeffc>
    81005598:	05490c63          	beq	s2,s4,810055f0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8100559c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8100559e:	00013717          	auipc	a4,0x13
    810055a2:	56270713          	addi	a4,a4,1378 # 81018b00 <disk>
    810055a6:	4781                	li	a5,0
    if(disk.free[i]){
    810055a8:	01874683          	lbu	a3,24(a4)
    810055ac:	fee9                	bnez	a3,81005586 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    810055ae:	2785                	addiw	a5,a5,1
    810055b0:	0705                	addi	a4,a4,1
    810055b2:	fe979be3          	bne	a5,s1,810055a8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    810055b6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    810055ba:	01205d63          	blez	s2,810055d4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    810055be:	fa042503          	lw	a0,-96(s0)
    810055c2:	d41ff0ef          	jal	81005302 <free_desc>
      for(int j = 0; j < i; j++)
    810055c6:	4785                	li	a5,1
    810055c8:	0127d663          	bge	a5,s2,810055d4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    810055cc:	fa442503          	lw	a0,-92(s0)
    810055d0:	d33ff0ef          	jal	81005302 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    810055d4:	00013597          	auipc	a1,0x13
    810055d8:	65458593          	addi	a1,a1,1620 # 81018c28 <disk+0x128>
    810055dc:	00013517          	auipc	a0,0x13
    810055e0:	53c50513          	addi	a0,a0,1340 # 81018b18 <disk+0x18>
    810055e4:	8c1fc0ef          	jal	81001ea4 <sleep>
  for(int i = 0; i < 3; i++){
    810055e8:	fa040613          	addi	a2,s0,-96
    810055ec:	4901                	li	s2,0
    810055ee:	b77d                	j	8100559c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    810055f0:	fa042503          	lw	a0,-96(s0)
    810055f4:	00451693          	slli	a3,a0,0x4

  if(write)
    810055f8:	00013797          	auipc	a5,0x13
    810055fc:	50878793          	addi	a5,a5,1288 # 81018b00 <disk>
    81005600:	00a50713          	addi	a4,a0,10
    81005604:	0712                	slli	a4,a4,0x4
    81005606:	973e                	add	a4,a4,a5
    81005608:	01603633          	snez	a2,s6
    8100560c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8100560e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    81005612:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    81005616:	6398                	ld	a4,0(a5)
    81005618:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8100561a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x70ffef58>
    8100561e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    81005620:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    81005622:	6390                	ld	a2,0(a5)
    81005624:	00d605b3          	add	a1,a2,a3
    81005628:	4741                	li	a4,16
    8100562a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8100562c:	4805                	li	a6,1
    8100562e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    81005632:	fa442703          	lw	a4,-92(s0)
    81005636:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8100563a:	0712                	slli	a4,a4,0x4
    8100563c:	963a                	add	a2,a2,a4
    8100563e:	05898593          	addi	a1,s3,88
    81005642:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    81005644:	0007b883          	ld	a7,0(a5)
    81005648:	9746                	add	a4,a4,a7
    8100564a:	40000613          	li	a2,1024
    8100564e:	c710                	sw	a2,8(a4)
  if(write)
    81005650:	001b3613          	seqz	a2,s6
    81005654:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    81005658:	01066633          	or	a2,a2,a6
    8100565c:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    81005660:	fa842583          	lw	a1,-88(s0)
    81005664:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    81005668:	00250613          	addi	a2,a0,2
    8100566c:	0612                	slli	a2,a2,0x4
    8100566e:	963e                	add	a2,a2,a5
    81005670:	577d                	li	a4,-1
    81005672:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    81005676:	0592                	slli	a1,a1,0x4
    81005678:	98ae                	add	a7,a7,a1
    8100567a:	03068713          	addi	a4,a3,48
    8100567e:	973e                	add	a4,a4,a5
    81005680:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    81005684:	6398                	ld	a4,0(a5)
    81005686:	972e                	add	a4,a4,a1
    81005688:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8100568c:	4689                	li	a3,2
    8100568e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    81005692:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    81005696:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    8100569a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8100569e:	6794                	ld	a3,8(a5)
    810056a0:	0026d703          	lhu	a4,2(a3)
    810056a4:	8b1d                	andi	a4,a4,7
    810056a6:	0706                	slli	a4,a4,0x1
    810056a8:	96ba                	add	a3,a3,a4
    810056aa:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    810056ae:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    810056b2:	6798                	ld	a4,8(a5)
    810056b4:	00275783          	lhu	a5,2(a4)
    810056b8:	2785                	addiw	a5,a5,1
    810056ba:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    810056be:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    810056c2:	100017b7          	lui	a5,0x10001
    810056c6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x70ffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    810056ca:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    810056ce:	00013917          	auipc	s2,0x13
    810056d2:	55a90913          	addi	s2,s2,1370 # 81018c28 <disk+0x128>
  while(b->disk == 1) {
    810056d6:	84c2                	mv	s1,a6
    810056d8:	01079a63          	bne	a5,a6,810056ec <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    810056dc:	85ca                	mv	a1,s2
    810056de:	854e                	mv	a0,s3
    810056e0:	fc4fc0ef          	jal	81001ea4 <sleep>
  while(b->disk == 1) {
    810056e4:	0049a783          	lw	a5,4(s3)
    810056e8:	fe978ae3          	beq	a5,s1,810056dc <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    810056ec:	fa042903          	lw	s2,-96(s0)
    810056f0:	00290713          	addi	a4,s2,2
    810056f4:	0712                	slli	a4,a4,0x4
    810056f6:	00013797          	auipc	a5,0x13
    810056fa:	40a78793          	addi	a5,a5,1034 # 81018b00 <disk>
    810056fe:	97ba                	add	a5,a5,a4
    81005700:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    81005704:	00013997          	auipc	s3,0x13
    81005708:	3fc98993          	addi	s3,s3,1020 # 81018b00 <disk>
    8100570c:	00491713          	slli	a4,s2,0x4
    81005710:	0009b783          	ld	a5,0(s3)
    81005714:	97ba                	add	a5,a5,a4
    81005716:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8100571a:	854a                	mv	a0,s2
    8100571c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    81005720:	be3ff0ef          	jal	81005302 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    81005724:	8885                	andi	s1,s1,1
    81005726:	f0fd                	bnez	s1,8100570c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    81005728:	00013517          	auipc	a0,0x13
    8100572c:	50050513          	addi	a0,a0,1280 # 81018c28 <disk+0x128>
    81005730:	d70fb0ef          	jal	81000ca0 <release>
}
    81005734:	60e6                	ld	ra,88(sp)
    81005736:	6446                	ld	s0,80(sp)
    81005738:	64a6                	ld	s1,72(sp)
    8100573a:	6906                	ld	s2,64(sp)
    8100573c:	79e2                	ld	s3,56(sp)
    8100573e:	7a42                	ld	s4,48(sp)
    81005740:	7aa2                	ld	s5,40(sp)
    81005742:	7b02                	ld	s6,32(sp)
    81005744:	6be2                	ld	s7,24(sp)
    81005746:	6c42                	ld	s8,16(sp)
    81005748:	6125                	addi	sp,sp,96
    8100574a:	8082                	ret

000000008100574c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8100574c:	1101                	addi	sp,sp,-32
    8100574e:	ec06                	sd	ra,24(sp)
    81005750:	e822                	sd	s0,16(sp)
    81005752:	e426                	sd	s1,8(sp)
    81005754:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    81005756:	00013497          	auipc	s1,0x13
    8100575a:	3aa48493          	addi	s1,s1,938 # 81018b00 <disk>
    8100575e:	00013517          	auipc	a0,0x13
    81005762:	4ca50513          	addi	a0,a0,1226 # 81018c28 <disk+0x128>
    81005766:	ca6fb0ef          	jal	81000c0c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8100576a:	100017b7          	lui	a5,0x10001
    8100576e:	53bc                	lw	a5,96(a5)
    81005770:	8b8d                	andi	a5,a5,3
    81005772:	10001737          	lui	a4,0x10001
    81005776:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    81005778:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8100577c:	689c                	ld	a5,16(s1)
    8100577e:	0204d703          	lhu	a4,32(s1)
    81005782:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x70ffeffe>
    81005786:	04f70663          	beq	a4,a5,810057d2 <virtio_disk_intr+0x86>
    __sync_synchronize();
    8100578a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8100578e:	6898                	ld	a4,16(s1)
    81005790:	0204d783          	lhu	a5,32(s1)
    81005794:	8b9d                	andi	a5,a5,7
    81005796:	078e                	slli	a5,a5,0x3
    81005798:	97ba                	add	a5,a5,a4
    8100579a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8100579c:	00278713          	addi	a4,a5,2
    810057a0:	0712                	slli	a4,a4,0x4
    810057a2:	9726                	add	a4,a4,s1
    810057a4:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x70ffeff0>
    810057a8:	e321                	bnez	a4,810057e8 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    810057aa:	0789                	addi	a5,a5,2
    810057ac:	0792                	slli	a5,a5,0x4
    810057ae:	97a6                	add	a5,a5,s1
    810057b0:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    810057b2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    810057b6:	f3afc0ef          	jal	81001ef0 <wakeup>

    disk.used_idx += 1;
    810057ba:	0204d783          	lhu	a5,32(s1)
    810057be:	2785                	addiw	a5,a5,1
    810057c0:	17c2                	slli	a5,a5,0x30
    810057c2:	93c1                	srli	a5,a5,0x30
    810057c4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    810057c8:	6898                	ld	a4,16(s1)
    810057ca:	00275703          	lhu	a4,2(a4)
    810057ce:	faf71ee3          	bne	a4,a5,8100578a <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    810057d2:	00013517          	auipc	a0,0x13
    810057d6:	45650513          	addi	a0,a0,1110 # 81018c28 <disk+0x128>
    810057da:	cc6fb0ef          	jal	81000ca0 <release>
}
    810057de:	60e2                	ld	ra,24(sp)
    810057e0:	6442                	ld	s0,16(sp)
    810057e2:	64a2                	ld	s1,8(sp)
    810057e4:	6105                	addi	sp,sp,32
    810057e6:	8082                	ret
      panic("virtio_disk_intr status");
    810057e8:	00002517          	auipc	a0,0x2
    810057ec:	f7050513          	addi	a0,a0,-144 # 81007758 <etext+0x758>
    810057f0:	fb9fa0ef          	jal	810007a8 <panic>
	...

0000000081006000 <_trampoline>:
    81006000:	14051073          	csrw	sscratch,a0
    81006004:	02000537          	lui	a0,0x2000
    81006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7f000001>
    8100600a:	0536                	slli	a0,a0,0xd
    8100600c:	02153423          	sd	ra,40(a0)
    81006010:	02253823          	sd	sp,48(a0)
    81006014:	02353c23          	sd	gp,56(a0)
    81006018:	04453023          	sd	tp,64(a0)
    8100601c:	04553423          	sd	t0,72(a0)
    81006020:	04653823          	sd	t1,80(a0)
    81006024:	04753c23          	sd	t2,88(a0)
    81006028:	f120                	sd	s0,96(a0)
    8100602a:	f524                	sd	s1,104(a0)
    8100602c:	fd2c                	sd	a1,120(a0)
    8100602e:	e150                	sd	a2,128(a0)
    81006030:	e554                	sd	a3,136(a0)
    81006032:	e958                	sd	a4,144(a0)
    81006034:	ed5c                	sd	a5,152(a0)
    81006036:	0b053023          	sd	a6,160(a0)
    8100603a:	0b153423          	sd	a7,168(a0)
    8100603e:	0b253823          	sd	s2,176(a0)
    81006042:	0b353c23          	sd	s3,184(a0)
    81006046:	0d453023          	sd	s4,192(a0)
    8100604a:	0d553423          	sd	s5,200(a0)
    8100604e:	0d653823          	sd	s6,208(a0)
    81006052:	0d753c23          	sd	s7,216(a0)
    81006056:	0f853023          	sd	s8,224(a0)
    8100605a:	0f953423          	sd	s9,232(a0)
    8100605e:	0fa53823          	sd	s10,240(a0)
    81006062:	0fb53c23          	sd	s11,248(a0)
    81006066:	11c53023          	sd	t3,256(a0)
    8100606a:	11d53423          	sd	t4,264(a0)
    8100606e:	11e53823          	sd	t5,272(a0)
    81006072:	11f53c23          	sd	t6,280(a0)
    81006076:	140022f3          	csrr	t0,sscratch
    8100607a:	06553823          	sd	t0,112(a0)
    8100607e:	00853103          	ld	sp,8(a0)
    81006082:	02053203          	ld	tp,32(a0)
    81006086:	01053283          	ld	t0,16(a0)
    8100608a:	00053303          	ld	t1,0(a0)
    8100608e:	12000073          	sfence.vma
    81006092:	18031073          	csrw	satp,t1
    81006096:	12000073          	sfence.vma
    8100609a:	8282                	jr	t0

000000008100609c <userret>:
    8100609c:	12000073          	sfence.vma
    810060a0:	18051073          	csrw	satp,a0
    810060a4:	12000073          	sfence.vma
    810060a8:	02000537          	lui	a0,0x2000
    810060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7f000001>
    810060ae:	0536                	slli	a0,a0,0xd
    810060b0:	02853083          	ld	ra,40(a0)
    810060b4:	03053103          	ld	sp,48(a0)
    810060b8:	03853183          	ld	gp,56(a0)
    810060bc:	04053203          	ld	tp,64(a0)
    810060c0:	04853283          	ld	t0,72(a0)
    810060c4:	05053303          	ld	t1,80(a0)
    810060c8:	05853383          	ld	t2,88(a0)
    810060cc:	7120                	ld	s0,96(a0)
    810060ce:	7524                	ld	s1,104(a0)
    810060d0:	7d2c                	ld	a1,120(a0)
    810060d2:	6150                	ld	a2,128(a0)
    810060d4:	6554                	ld	a3,136(a0)
    810060d6:	6958                	ld	a4,144(a0)
    810060d8:	6d5c                	ld	a5,152(a0)
    810060da:	0a053803          	ld	a6,160(a0)
    810060de:	0a853883          	ld	a7,168(a0)
    810060e2:	0b053903          	ld	s2,176(a0)
    810060e6:	0b853983          	ld	s3,184(a0)
    810060ea:	0c053a03          	ld	s4,192(a0)
    810060ee:	0c853a83          	ld	s5,200(a0)
    810060f2:	0d053b03          	ld	s6,208(a0)
    810060f6:	0d853b83          	ld	s7,216(a0)
    810060fa:	0e053c03          	ld	s8,224(a0)
    810060fe:	0e853c83          	ld	s9,232(a0)
    81006102:	0f053d03          	ld	s10,240(a0)
    81006106:	0f853d83          	ld	s11,248(a0)
    8100610a:	10053e03          	ld	t3,256(a0)
    8100610e:	10853e83          	ld	t4,264(a0)
    81006112:	11053f03          	ld	t5,272(a0)
    81006116:	11853f83          	ld	t6,280(a0)
    8100611a:	7928                	ld	a0,112(a0)
    8100611c:	10200073          	sret
	...
