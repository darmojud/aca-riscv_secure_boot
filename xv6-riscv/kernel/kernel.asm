
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000081000000 <_entry>:
    81000000:	00008117          	auipc	sp,0x8
    81000004:	9a010113          	addi	sp,sp,-1632 # 810079a0 <stack0>
    81000008:	6505                	lui	a0,0x1
    8100000a:	f14025f3          	csrr	a1,mhartid
    8100000e:	0585                	addi	a1,a1,1
    81000010:	02b50533          	mul	a0,a0,a1
    81000014:	912a                	add	sp,sp,a0
    81000016:	040000ef          	jal	81000056 <start>

000000008100001a <spin>:
    8100001a:	a001                	j	8100001a <spin>

000000008100001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8100001c:	1141                	addi	sp,sp,-16
    8100001e:	e406                	sd	ra,8(sp)
    81000020:	e022                	sd	s0,0(sp)
    81000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    81000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    81000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8100002c:	30479073          	csrw	mie,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    81000030:	306027f3          	csrr	a5,mcounteren
  
  // enable the sstc extension (i.e. stimecmp).
//  w_menvcfg(r_menvcfg() | (1L << 63)); 
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    81000034:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    81000038:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8100003c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    81000040:	000f4737          	lui	a4,0xf4
    81000044:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x80f0bdc0>
    81000048:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8100004a:	14d79073          	csrw	stimecmp,a5
}
    8100004e:	60a2                	ld	ra,8(sp)
    81000050:	6402                	ld	s0,0(sp)
    81000052:	0141                	addi	sp,sp,16
    81000054:	8082                	ret

0000000081000056 <start>:
{
    81000056:	1101                	addi	sp,sp,-32
    81000058:	ec06                	sd	ra,24(sp)
    8100005a:	e822                	sd	s0,16(sp)
    8100005c:	e426                	sd	s1,8(sp)
    8100005e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
    81000060:	300027f3          	csrr	a5,mstatus
  unsigned long privilege_level = (mstatus >> 11) & 0x3;
    81000064:	83ad                	srli	a5,a5,0xb
    81000066:	8b8d                	andi	a5,a5,3
  if (privilege_level == 0) {
    81000068:	10078563          	beqz	a5,81000172 <start+0x11c>
  } else if (privilege_level == 1) {
    8100006c:	4705                	li	a4,1
    8100006e:	10e78963          	beq	a5,a4,81000180 <start+0x12a>
  } else if (privilege_level == 3) {
    81000072:	470d                	li	a4,3
    81000074:	10e78d63          	beq	a5,a4,8100018e <start+0x138>
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    81000078:	300027f3          	csrr	a5,mstatus
    8100007c:	300024f3          	csrr	s1,mstatus
  x1 |= MSTATUS_MPP_M;
    81000080:	6709                	lui	a4,0x2
    81000082:	80070713          	addi	a4,a4,-2048 # 1800 <_entry-0x80ffe800>
    81000086:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    81000088:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
    8100008c:	300027f3          	csrr	a5,mstatus
  privilege_level = (mstatus >> 11) & 0x3;
    81000090:	83ad                	srli	a5,a5,0xb
    81000092:	8b8d                	andi	a5,a5,3
  if (privilege_level == 0) {
    81000094:	10078463          	beqz	a5,8100019c <start+0x146>
  } else if (privilege_level == 1) {
    81000098:	4705                	li	a4,1
    8100009a:	10e78863          	beq	a5,a4,810001aa <start+0x154>
  } else if (privilege_level == 3) {
    8100009e:	470d                	li	a4,3
    810000a0:	10e78c63          	beq	a5,a4,810001b8 <start+0x162>
  asm volatile("csrci mstatus, %0" : : "i" (MSTATUS_MIE));
    810000a4:	30047073          	csrci	mstatus,8
  asm volatile("csrr %0, %1" : "=r" (x) : "i" (MENVCFG));
    810000a8:	30a027f3          	csrr	a5,0x30a
asm volatile("csrci mstatus, %0" : : "i" (MSTATUS_MIE));
    810000ac:	30047073          	csrci	mstatus,8
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    810000b0:	577d                	li	a4,-1
    810000b2:	177e                	slli	a4,a4,0x3f
    810000b4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    810000b6:	30a79073          	csrw	0x30a,a5
  x2 &= ~MSTATUS_MPP_MASK;
    810000ba:	77f9                	lui	a5,0xffffe
    810000bc:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <end+0xffffffff7efdd7ff>
    810000c0:	8cfd                	and	s1,s1,a5
  x2 |= MSTATUS_MPP_S;
    810000c2:	6785                	lui	a5,0x1
    810000c4:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x80fff800>
    810000c8:	8cdd                	or	s1,s1,a5
  asm volatile("csrw mstatus, %0" : : "r" (x));
    810000ca:	30049073          	csrw	mstatus,s1
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
    810000ce:	300027f3          	csrr	a5,mstatus
  privilege_level = (mstatus >> 11) & 0x3;
    810000d2:	83ad                	srli	a5,a5,0xb
    810000d4:	8b8d                	andi	a5,a5,3
  if (privilege_level == 0) {
    810000d6:	0e078863          	beqz	a5,810001c6 <start+0x170>
  } else if (privilege_level == 1) {
    810000da:	4705                	li	a4,1
    810000dc:	0ee78c63          	beq	a5,a4,810001d4 <start+0x17e>
  } else if (privilege_level == 3) {
    810000e0:	470d                	li	a4,3
    810000e2:	10e78063          	beq	a5,a4,810001e2 <start+0x18c>
  asm volatile(
    810000e6:	858a                	mv	a1,sp
    810000e8:	34102673          	csrr	a2,mepc
  printf(" before jump to main Debug: sp = 0x%lx, mepc = 0x%lx\n", sp_value, mepc_value);
    810000ec:	00007517          	auipc	a0,0x7
    810000f0:	f3450513          	addi	a0,a0,-204 # 81007020 <etext+0x20>
    810000f4:	520000ef          	jal	81000614 <printf>
  asm volatile("csrw mepc, %0" : : "r" (x));
    810000f8:	00001797          	auipc	a5,0x1
    810000fc:	ed678793          	addi	a5,a5,-298 # 81000fce <main>
    81000100:	34179073          	csrw	mepc,a5
  asm volatile(
    81000104:	858a                	mv	a1,sp
    81000106:	34102673          	csrr	a2,mepc
  printf(" after jump to main Debug: sp = 0x%lx, mepc = 0x%lx\n", sp_value, mepc_value);
    8100010a:	00007517          	auipc	a0,0x7
    8100010e:	f4e50513          	addi	a0,a0,-178 # 81007058 <etext+0x58>
    81000112:	502000ef          	jal	81000614 <printf>
  asm volatile("csrw satp, %0" : : "r" (x));
    81000116:	4781                	li	a5,0
    81000118:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8100011c:	67c1                	lui	a5,0x10
    8100011e:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x80ff0001>
    81000120:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    81000124:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    81000128:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8100012c:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    81000130:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    81000134:	57fd                	li	a5,-1
    81000136:	83a9                	srli	a5,a5,0xa
    81000138:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8100013c:	47bd                	li	a5,15
    8100013e:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    81000142:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    81000146:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    81000148:	823e                	mv	tp,a5
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
    8100014a:	300027f3          	csrr	a5,mstatus
 privilege_level = (mstatus >> 11) & 0x3;
    8100014e:	83ad                	srli	a5,a5,0xb
    81000150:	8b8d                	andi	a5,a5,3
  if (privilege_level == 0) {
    81000152:	cfd9                	beqz	a5,810001f0 <start+0x19a>
  } else if (privilege_level == 1) {
    81000154:	4705                	li	a4,1
    81000156:	0ae78463          	beq	a5,a4,810001fe <start+0x1a8>
  } else if (privilege_level == 3) {
    8100015a:	470d                	li	a4,3
    8100015c:	0ae78863          	beq	a5,a4,8100020c <start+0x1b6>
  timerinit();
    81000160:	ebdff0ef          	jal	8100001c <timerinit>
  asm volatile("mret");
    81000164:	30200073          	mret
}
    81000168:	60e2                	ld	ra,24(sp)
    8100016a:	6442                	ld	s0,16(sp)
    8100016c:	64a2                	ld	s1,8(sp)
    8100016e:	6105                	addi	sp,sp,32
    81000170:	8082                	ret
	  printf("user");
    81000172:	00007517          	auipc	a0,0x7
    81000176:	e8e50513          	addi	a0,a0,-370 # 81007000 <etext>
    8100017a:	49a000ef          	jal	81000614 <printf>
    8100017e:	bded                	j	81000078 <start+0x22>
	   printf("super");
    81000180:	00007517          	auipc	a0,0x7
    81000184:	e9050513          	addi	a0,a0,-368 # 81007010 <etext+0x10>
    81000188:	48c000ef          	jal	81000614 <printf>
    8100018c:	b5f5                	j	81000078 <start+0x22>
	   printf("machine");
    8100018e:	00007517          	auipc	a0,0x7
    81000192:	e8a50513          	addi	a0,a0,-374 # 81007018 <etext+0x18>
    81000196:	47e000ef          	jal	81000614 <printf>
    8100019a:	bdf9                	j	81000078 <start+0x22>
	  printf("user");
    8100019c:	00007517          	auipc	a0,0x7
    810001a0:	e6450513          	addi	a0,a0,-412 # 81007000 <etext>
    810001a4:	470000ef          	jal	81000614 <printf>
    810001a8:	bdf5                	j	810000a4 <start+0x4e>
	   printf("super");
    810001aa:	00007517          	auipc	a0,0x7
    810001ae:	e6650513          	addi	a0,a0,-410 # 81007010 <etext+0x10>
    810001b2:	462000ef          	jal	81000614 <printf>
    810001b6:	b5fd                	j	810000a4 <start+0x4e>
	   printf("machine");
    810001b8:	00007517          	auipc	a0,0x7
    810001bc:	e6050513          	addi	a0,a0,-416 # 81007018 <etext+0x18>
    810001c0:	454000ef          	jal	81000614 <printf>
    810001c4:	b5c5                	j	810000a4 <start+0x4e>
	  printf("user");
    810001c6:	00007517          	auipc	a0,0x7
    810001ca:	e3a50513          	addi	a0,a0,-454 # 81007000 <etext>
    810001ce:	446000ef          	jal	81000614 <printf>
    810001d2:	bf11                	j	810000e6 <start+0x90>
	   printf("super");
    810001d4:	00007517          	auipc	a0,0x7
    810001d8:	e3c50513          	addi	a0,a0,-452 # 81007010 <etext+0x10>
    810001dc:	438000ef          	jal	81000614 <printf>
    810001e0:	b719                	j	810000e6 <start+0x90>
	   printf("machine");
    810001e2:	00007517          	auipc	a0,0x7
    810001e6:	e3650513          	addi	a0,a0,-458 # 81007018 <etext+0x18>
    810001ea:	42a000ef          	jal	81000614 <printf>
    810001ee:	bde5                	j	810000e6 <start+0x90>
	  printf("user");
    810001f0:	00007517          	auipc	a0,0x7
    810001f4:	e1050513          	addi	a0,a0,-496 # 81007000 <etext>
    810001f8:	41c000ef          	jal	81000614 <printf>
    810001fc:	b795                	j	81000160 <start+0x10a>
	   printf("super");
    810001fe:	00007517          	auipc	a0,0x7
    81000202:	e1250513          	addi	a0,a0,-494 # 81007010 <etext+0x10>
    81000206:	40e000ef          	jal	81000614 <printf>
    8100020a:	bf99                	j	81000160 <start+0x10a>
	   printf("machine");
    8100020c:	00007517          	auipc	a0,0x7
    81000210:	e0c50513          	addi	a0,a0,-500 # 81007018 <etext+0x18>
    81000214:	400000ef          	jal	81000614 <printf>
    81000218:	b7a1                	j	81000160 <start+0x10a>

000000008100021a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8100021a:	711d                	addi	sp,sp,-96
    8100021c:	ec86                	sd	ra,88(sp)
    8100021e:	e8a2                	sd	s0,80(sp)
    81000220:	e0ca                	sd	s2,64(sp)
    81000222:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    81000224:	04c05863          	blez	a2,81000274 <consolewrite+0x5a>
    81000228:	e4a6                	sd	s1,72(sp)
    8100022a:	fc4e                	sd	s3,56(sp)
    8100022c:	f852                	sd	s4,48(sp)
    8100022e:	f456                	sd	s5,40(sp)
    81000230:	f05a                	sd	s6,32(sp)
    81000232:	ec5e                	sd	s7,24(sp)
    81000234:	8a2a                	mv	s4,a0
    81000236:	84ae                	mv	s1,a1
    81000238:	89b2                	mv	s3,a2
    8100023a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8100023c:	faf40b93          	addi	s7,s0,-81
    81000240:	4b05                	li	s6,1
    81000242:	5afd                	li	s5,-1
    81000244:	86da                	mv	a3,s6
    81000246:	8626                	mv	a2,s1
    81000248:	85d2                	mv	a1,s4
    8100024a:	855e                	mv	a0,s7
    8100024c:	158020ef          	jal	810023a4 <either_copyin>
    81000250:	03550463          	beq	a0,s5,81000278 <consolewrite+0x5e>
      break;
    uartputc(c);
    81000254:	faf44503          	lbu	a0,-81(s0)
    81000258:	02d000ef          	jal	81000a84 <uartputc>
  for(i = 0; i < n; i++){
    8100025c:	2905                	addiw	s2,s2,1
    8100025e:	0485                	addi	s1,s1,1
    81000260:	ff2992e3          	bne	s3,s2,81000244 <consolewrite+0x2a>
    81000264:	894e                	mv	s2,s3
    81000266:	64a6                	ld	s1,72(sp)
    81000268:	79e2                	ld	s3,56(sp)
    8100026a:	7a42                	ld	s4,48(sp)
    8100026c:	7aa2                	ld	s5,40(sp)
    8100026e:	7b02                	ld	s6,32(sp)
    81000270:	6be2                	ld	s7,24(sp)
    81000272:	a809                	j	81000284 <consolewrite+0x6a>
    81000274:	4901                	li	s2,0
    81000276:	a039                	j	81000284 <consolewrite+0x6a>
    81000278:	64a6                	ld	s1,72(sp)
    8100027a:	79e2                	ld	s3,56(sp)
    8100027c:	7a42                	ld	s4,48(sp)
    8100027e:	7aa2                	ld	s5,40(sp)
    81000280:	7b02                	ld	s6,32(sp)
    81000282:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    81000284:	854a                	mv	a0,s2
    81000286:	60e6                	ld	ra,88(sp)
    81000288:	6446                	ld	s0,80(sp)
    8100028a:	6906                	ld	s2,64(sp)
    8100028c:	6125                	addi	sp,sp,96
    8100028e:	8082                	ret

0000000081000290 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    81000290:	711d                	addi	sp,sp,-96
    81000292:	ec86                	sd	ra,88(sp)
    81000294:	e8a2                	sd	s0,80(sp)
    81000296:	e4a6                	sd	s1,72(sp)
    81000298:	e0ca                	sd	s2,64(sp)
    8100029a:	fc4e                	sd	s3,56(sp)
    8100029c:	f852                	sd	s4,48(sp)
    8100029e:	f456                	sd	s5,40(sp)
    810002a0:	f05a                	sd	s6,32(sp)
    810002a2:	1080                	addi	s0,sp,96
    810002a4:	8aaa                	mv	s5,a0
    810002a6:	8a2e                	mv	s4,a1
    810002a8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    810002aa:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    810002ac:	0000f517          	auipc	a0,0xf
    810002b0:	6f450513          	addi	a0,a0,1780 # 8100f9a0 <cons>
    810002b4:	295000ef          	jal	81000d48 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    810002b8:	0000f497          	auipc	s1,0xf
    810002bc:	6e848493          	addi	s1,s1,1768 # 8100f9a0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    810002c0:	0000f917          	auipc	s2,0xf
    810002c4:	77890913          	addi	s2,s2,1912 # 8100fa38 <cons+0x98>
  while(n > 0){
    810002c8:	0b305b63          	blez	s3,8100037e <consoleread+0xee>
    while(cons.r == cons.w){
    810002cc:	0984a783          	lw	a5,152(s1)
    810002d0:	09c4a703          	lw	a4,156(s1)
    810002d4:	0af71063          	bne	a4,a5,81000374 <consoleread+0xe4>
      if(killed(myproc())){
    810002d8:	75e010ef          	jal	81001a36 <myproc>
    810002dc:	761010ef          	jal	8100223c <killed>
    810002e0:	e12d                	bnez	a0,81000342 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    810002e2:	85a6                	mv	a1,s1
    810002e4:	854a                	mv	a0,s2
    810002e6:	51f010ef          	jal	81002004 <sleep>
    while(cons.r == cons.w){
    810002ea:	0984a783          	lw	a5,152(s1)
    810002ee:	09c4a703          	lw	a4,156(s1)
    810002f2:	fef703e3          	beq	a4,a5,810002d8 <consoleread+0x48>
    810002f6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    810002f8:	0000f717          	auipc	a4,0xf
    810002fc:	6a870713          	addi	a4,a4,1704 # 8100f9a0 <cons>
    81000300:	0017869b          	addiw	a3,a5,1
    81000304:	08d72c23          	sw	a3,152(a4)
    81000308:	07f7f693          	andi	a3,a5,127
    8100030c:	9736                	add	a4,a4,a3
    8100030e:	01874703          	lbu	a4,24(a4)
    81000312:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    81000316:	4691                	li	a3,4
    81000318:	04db8663          	beq	s7,a3,81000364 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8100031c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    81000320:	4685                	li	a3,1
    81000322:	faf40613          	addi	a2,s0,-81
    81000326:	85d2                	mv	a1,s4
    81000328:	8556                	mv	a0,s5
    8100032a:	030020ef          	jal	8100235a <either_copyout>
    8100032e:	57fd                	li	a5,-1
    81000330:	04f50663          	beq	a0,a5,8100037c <consoleread+0xec>
      break;

    dst++;
    81000334:	0a05                	addi	s4,s4,1
    --n;
    81000336:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    81000338:	47a9                	li	a5,10
    8100033a:	04fb8b63          	beq	s7,a5,81000390 <consoleread+0x100>
    8100033e:	6be2                	ld	s7,24(sp)
    81000340:	b761                	j	810002c8 <consoleread+0x38>
        release(&cons.lock);
    81000342:	0000f517          	auipc	a0,0xf
    81000346:	65e50513          	addi	a0,a0,1630 # 8100f9a0 <cons>
    8100034a:	293000ef          	jal	81000ddc <release>
        return -1;
    8100034e:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    81000350:	60e6                	ld	ra,88(sp)
    81000352:	6446                	ld	s0,80(sp)
    81000354:	64a6                	ld	s1,72(sp)
    81000356:	6906                	ld	s2,64(sp)
    81000358:	79e2                	ld	s3,56(sp)
    8100035a:	7a42                	ld	s4,48(sp)
    8100035c:	7aa2                	ld	s5,40(sp)
    8100035e:	7b02                	ld	s6,32(sp)
    81000360:	6125                	addi	sp,sp,96
    81000362:	8082                	ret
      if(n < target){
    81000364:	0169fa63          	bgeu	s3,s6,81000378 <consoleread+0xe8>
        cons.r--;
    81000368:	0000f717          	auipc	a4,0xf
    8100036c:	6cf72823          	sw	a5,1744(a4) # 8100fa38 <cons+0x98>
    81000370:	6be2                	ld	s7,24(sp)
    81000372:	a031                	j	8100037e <consoleread+0xee>
    81000374:	ec5e                	sd	s7,24(sp)
    81000376:	b749                	j	810002f8 <consoleread+0x68>
    81000378:	6be2                	ld	s7,24(sp)
    8100037a:	a011                	j	8100037e <consoleread+0xee>
    8100037c:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8100037e:	0000f517          	auipc	a0,0xf
    81000382:	62250513          	addi	a0,a0,1570 # 8100f9a0 <cons>
    81000386:	257000ef          	jal	81000ddc <release>
  return target - n;
    8100038a:	413b053b          	subw	a0,s6,s3
    8100038e:	b7c9                	j	81000350 <consoleread+0xc0>
    81000390:	6be2                	ld	s7,24(sp)
    81000392:	b7f5                	j	8100037e <consoleread+0xee>

0000000081000394 <consputc>:
{
    81000394:	1141                	addi	sp,sp,-16
    81000396:	e406                	sd	ra,8(sp)
    81000398:	e022                	sd	s0,0(sp)
    8100039a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8100039c:	10000793          	li	a5,256
    810003a0:	00f50863          	beq	a0,a5,810003b0 <consputc+0x1c>
    uartputc_sync(c);
    810003a4:	5fe000ef          	jal	810009a2 <uartputc_sync>
}
    810003a8:	60a2                	ld	ra,8(sp)
    810003aa:	6402                	ld	s0,0(sp)
    810003ac:	0141                	addi	sp,sp,16
    810003ae:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    810003b0:	4521                	li	a0,8
    810003b2:	5f0000ef          	jal	810009a2 <uartputc_sync>
    810003b6:	02000513          	li	a0,32
    810003ba:	5e8000ef          	jal	810009a2 <uartputc_sync>
    810003be:	4521                	li	a0,8
    810003c0:	5e2000ef          	jal	810009a2 <uartputc_sync>
    810003c4:	b7d5                	j	810003a8 <consputc+0x14>

00000000810003c6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    810003c6:	7179                	addi	sp,sp,-48
    810003c8:	f406                	sd	ra,40(sp)
    810003ca:	f022                	sd	s0,32(sp)
    810003cc:	ec26                	sd	s1,24(sp)
    810003ce:	1800                	addi	s0,sp,48
    810003d0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    810003d2:	0000f517          	auipc	a0,0xf
    810003d6:	5ce50513          	addi	a0,a0,1486 # 8100f9a0 <cons>
    810003da:	16f000ef          	jal	81000d48 <acquire>

  switch(c){
    810003de:	47d5                	li	a5,21
    810003e0:	08f48e63          	beq	s1,a5,8100047c <consoleintr+0xb6>
    810003e4:	0297c563          	blt	a5,s1,8100040e <consoleintr+0x48>
    810003e8:	47a1                	li	a5,8
    810003ea:	0ef48863          	beq	s1,a5,810004da <consoleintr+0x114>
    810003ee:	47c1                	li	a5,16
    810003f0:	10f49963          	bne	s1,a5,81000502 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    810003f4:	7fb010ef          	jal	810023ee <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    810003f8:	0000f517          	auipc	a0,0xf
    810003fc:	5a850513          	addi	a0,a0,1448 # 8100f9a0 <cons>
    81000400:	1dd000ef          	jal	81000ddc <release>
}
    81000404:	70a2                	ld	ra,40(sp)
    81000406:	7402                	ld	s0,32(sp)
    81000408:	64e2                	ld	s1,24(sp)
    8100040a:	6145                	addi	sp,sp,48
    8100040c:	8082                	ret
  switch(c){
    8100040e:	07f00793          	li	a5,127
    81000412:	0cf48463          	beq	s1,a5,810004da <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    81000416:	0000f717          	auipc	a4,0xf
    8100041a:	58a70713          	addi	a4,a4,1418 # 8100f9a0 <cons>
    8100041e:	0a072783          	lw	a5,160(a4)
    81000422:	09872703          	lw	a4,152(a4)
    81000426:	9f99                	subw	a5,a5,a4
    81000428:	07f00713          	li	a4,127
    8100042c:	fcf766e3          	bltu	a4,a5,810003f8 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    81000430:	47b5                	li	a5,13
    81000432:	0cf48b63          	beq	s1,a5,81000508 <consoleintr+0x142>
      consputc(c);
    81000436:	8526                	mv	a0,s1
    81000438:	f5dff0ef          	jal	81000394 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8100043c:	0000f797          	auipc	a5,0xf
    81000440:	56478793          	addi	a5,a5,1380 # 8100f9a0 <cons>
    81000444:	0a07a683          	lw	a3,160(a5)
    81000448:	0016871b          	addiw	a4,a3,1
    8100044c:	863a                	mv	a2,a4
    8100044e:	0ae7a023          	sw	a4,160(a5)
    81000452:	07f6f693          	andi	a3,a3,127
    81000456:	97b6                	add	a5,a5,a3
    81000458:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8100045c:	47a9                	li	a5,10
    8100045e:	0cf48963          	beq	s1,a5,81000530 <consoleintr+0x16a>
    81000462:	4791                	li	a5,4
    81000464:	0cf48663          	beq	s1,a5,81000530 <consoleintr+0x16a>
    81000468:	0000f797          	auipc	a5,0xf
    8100046c:	5d07a783          	lw	a5,1488(a5) # 8100fa38 <cons+0x98>
    81000470:	9f1d                	subw	a4,a4,a5
    81000472:	08000793          	li	a5,128
    81000476:	f8f711e3          	bne	a4,a5,810003f8 <consoleintr+0x32>
    8100047a:	a85d                	j	81000530 <consoleintr+0x16a>
    8100047c:	e84a                	sd	s2,16(sp)
    8100047e:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    81000480:	0000f717          	auipc	a4,0xf
    81000484:	52070713          	addi	a4,a4,1312 # 8100f9a0 <cons>
    81000488:	0a072783          	lw	a5,160(a4)
    8100048c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    81000490:	0000f497          	auipc	s1,0xf
    81000494:	51048493          	addi	s1,s1,1296 # 8100f9a0 <cons>
    while(cons.e != cons.w &&
    81000498:	4929                	li	s2,10
      consputc(BACKSPACE);
    8100049a:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    8100049e:	02f70863          	beq	a4,a5,810004ce <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    810004a2:	37fd                	addiw	a5,a5,-1
    810004a4:	07f7f713          	andi	a4,a5,127
    810004a8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    810004aa:	01874703          	lbu	a4,24(a4)
    810004ae:	03270363          	beq	a4,s2,810004d4 <consoleintr+0x10e>
      cons.e--;
    810004b2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    810004b6:	854e                	mv	a0,s3
    810004b8:	eddff0ef          	jal	81000394 <consputc>
    while(cons.e != cons.w &&
    810004bc:	0a04a783          	lw	a5,160(s1)
    810004c0:	09c4a703          	lw	a4,156(s1)
    810004c4:	fcf71fe3          	bne	a4,a5,810004a2 <consoleintr+0xdc>
    810004c8:	6942                	ld	s2,16(sp)
    810004ca:	69a2                	ld	s3,8(sp)
    810004cc:	b735                	j	810003f8 <consoleintr+0x32>
    810004ce:	6942                	ld	s2,16(sp)
    810004d0:	69a2                	ld	s3,8(sp)
    810004d2:	b71d                	j	810003f8 <consoleintr+0x32>
    810004d4:	6942                	ld	s2,16(sp)
    810004d6:	69a2                	ld	s3,8(sp)
    810004d8:	b705                	j	810003f8 <consoleintr+0x32>
    if(cons.e != cons.w){
    810004da:	0000f717          	auipc	a4,0xf
    810004de:	4c670713          	addi	a4,a4,1222 # 8100f9a0 <cons>
    810004e2:	0a072783          	lw	a5,160(a4)
    810004e6:	09c72703          	lw	a4,156(a4)
    810004ea:	f0f707e3          	beq	a4,a5,810003f8 <consoleintr+0x32>
      cons.e--;
    810004ee:	37fd                	addiw	a5,a5,-1
    810004f0:	0000f717          	auipc	a4,0xf
    810004f4:	54f72823          	sw	a5,1360(a4) # 8100fa40 <cons+0xa0>
      consputc(BACKSPACE);
    810004f8:	10000513          	li	a0,256
    810004fc:	e99ff0ef          	jal	81000394 <consputc>
    81000500:	bde5                	j	810003f8 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    81000502:	ee048be3          	beqz	s1,810003f8 <consoleintr+0x32>
    81000506:	bf01                	j	81000416 <consoleintr+0x50>
      consputc(c);
    81000508:	4529                	li	a0,10
    8100050a:	e8bff0ef          	jal	81000394 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8100050e:	0000f797          	auipc	a5,0xf
    81000512:	49278793          	addi	a5,a5,1170 # 8100f9a0 <cons>
    81000516:	0a07a703          	lw	a4,160(a5)
    8100051a:	0017069b          	addiw	a3,a4,1
    8100051e:	8636                	mv	a2,a3
    81000520:	0ad7a023          	sw	a3,160(a5)
    81000524:	07f77713          	andi	a4,a4,127
    81000528:	97ba                	add	a5,a5,a4
    8100052a:	4729                	li	a4,10
    8100052c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    81000530:	0000f797          	auipc	a5,0xf
    81000534:	50c7a623          	sw	a2,1292(a5) # 8100fa3c <cons+0x9c>
        wakeup(&cons.r);
    81000538:	0000f517          	auipc	a0,0xf
    8100053c:	50050513          	addi	a0,a0,1280 # 8100fa38 <cons+0x98>
    81000540:	311010ef          	jal	81002050 <wakeup>
    81000544:	bd55                	j	810003f8 <consoleintr+0x32>

0000000081000546 <consoleinit>:

void
consoleinit(void)
{
    81000546:	1141                	addi	sp,sp,-16
    81000548:	e406                	sd	ra,8(sp)
    8100054a:	e022                	sd	s0,0(sp)
    8100054c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8100054e:	00007597          	auipc	a1,0x7
    81000552:	b4258593          	addi	a1,a1,-1214 # 81007090 <etext+0x90>
    81000556:	0000f517          	auipc	a0,0xf
    8100055a:	44a50513          	addi	a0,a0,1098 # 8100f9a0 <cons>
    8100055e:	766000ef          	jal	81000cc4 <initlock>

  uartinit();
    81000562:	3ea000ef          	jal	8100094c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    81000566:	0001f797          	auipc	a5,0x1f
    8100056a:	5d278793          	addi	a5,a5,1490 # 8101fb38 <devsw>
    8100056e:	00000717          	auipc	a4,0x0
    81000572:	d2270713          	addi	a4,a4,-734 # 81000290 <consoleread>
    81000576:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    81000578:	00000717          	auipc	a4,0x0
    8100057c:	ca270713          	addi	a4,a4,-862 # 8100021a <consolewrite>
    81000580:	ef98                	sd	a4,24(a5)
}
    81000582:	60a2                	ld	ra,8(sp)
    81000584:	6402                	ld	s0,0(sp)
    81000586:	0141                	addi	sp,sp,16
    81000588:	8082                	ret

000000008100058a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8100058a:	7179                	addi	sp,sp,-48
    8100058c:	f406                	sd	ra,40(sp)
    8100058e:	f022                	sd	s0,32(sp)
    81000590:	ec26                	sd	s1,24(sp)
    81000592:	e84a                	sd	s2,16(sp)
    81000594:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    81000596:	c219                	beqz	a2,8100059c <printint+0x12>
    81000598:	06054a63          	bltz	a0,8100060c <printint+0x82>
    x = -xx;
  else
    x = xx;
    8100059c:	4e01                	li	t3,0

  i = 0;
    8100059e:	fd040313          	addi	t1,s0,-48
    x = xx;
    810005a2:	869a                	mv	a3,t1
  i = 0;
    810005a4:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    810005a6:	00007817          	auipc	a6,0x7
    810005aa:	25280813          	addi	a6,a6,594 # 810077f8 <digits>
    810005ae:	88be                	mv	a7,a5
    810005b0:	0017861b          	addiw	a2,a5,1
    810005b4:	87b2                	mv	a5,a2
    810005b6:	02b57733          	remu	a4,a0,a1
    810005ba:	9742                	add	a4,a4,a6
    810005bc:	00074703          	lbu	a4,0(a4)
    810005c0:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    810005c4:	872a                	mv	a4,a0
    810005c6:	02b55533          	divu	a0,a0,a1
    810005ca:	0685                	addi	a3,a3,1
    810005cc:	feb771e3          	bgeu	a4,a1,810005ae <printint+0x24>

  if(sign)
    810005d0:	000e0c63          	beqz	t3,810005e8 <printint+0x5e>
    buf[i++] = '-';
    810005d4:	fe060793          	addi	a5,a2,-32
    810005d8:	00878633          	add	a2,a5,s0
    810005dc:	02d00793          	li	a5,45
    810005e0:	fef60823          	sb	a5,-16(a2)
    810005e4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    810005e8:	fff7891b          	addiw	s2,a5,-1
    810005ec:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    810005f0:	fff4c503          	lbu	a0,-1(s1)
    810005f4:	da1ff0ef          	jal	81000394 <consputc>
  while(--i >= 0)
    810005f8:	397d                	addiw	s2,s2,-1
    810005fa:	14fd                	addi	s1,s1,-1
    810005fc:	fe095ae3          	bgez	s2,810005f0 <printint+0x66>
}
    81000600:	70a2                	ld	ra,40(sp)
    81000602:	7402                	ld	s0,32(sp)
    81000604:	64e2                	ld	s1,24(sp)
    81000606:	6942                	ld	s2,16(sp)
    81000608:	6145                	addi	sp,sp,48
    8100060a:	8082                	ret
    x = -xx;
    8100060c:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    81000610:	4e05                	li	t3,1
    x = -xx;
    81000612:	b771                	j	8100059e <printint+0x14>

0000000081000614 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    81000614:	7155                	addi	sp,sp,-208
    81000616:	e506                	sd	ra,136(sp)
    81000618:	e122                	sd	s0,128(sp)
    8100061a:	f0d2                	sd	s4,96(sp)
    8100061c:	0900                	addi	s0,sp,144
    8100061e:	8a2a                	mv	s4,a0
    81000620:	e40c                	sd	a1,8(s0)
    81000622:	e810                	sd	a2,16(s0)
    81000624:	ec14                	sd	a3,24(s0)
    81000626:	f018                	sd	a4,32(s0)
    81000628:	f41c                	sd	a5,40(s0)
    8100062a:	03043823          	sd	a6,48(s0)
    8100062e:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    81000632:	0000f797          	auipc	a5,0xf
    81000636:	42e7a783          	lw	a5,1070(a5) # 8100fa60 <pr+0x18>
    8100063a:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8100063e:	e3a1                	bnez	a5,8100067e <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    81000640:	00840793          	addi	a5,s0,8
    81000644:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    81000648:	00054503          	lbu	a0,0(a0)
    8100064c:	26050663          	beqz	a0,810008b8 <printf+0x2a4>
    81000650:	fca6                	sd	s1,120(sp)
    81000652:	f8ca                	sd	s2,112(sp)
    81000654:	f4ce                	sd	s3,104(sp)
    81000656:	ecd6                	sd	s5,88(sp)
    81000658:	e8da                	sd	s6,80(sp)
    8100065a:	e0e2                	sd	s8,64(sp)
    8100065c:	fc66                	sd	s9,56(sp)
    8100065e:	f86a                	sd	s10,48(sp)
    81000660:	f46e                	sd	s11,40(sp)
    81000662:	4981                	li	s3,0
    if(cx != '%'){
    81000664:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    81000668:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8100066c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    81000670:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    81000674:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    81000678:	07000d93          	li	s11,112
    8100067c:	a80d                	j	810006ae <printf+0x9a>
    acquire(&pr.lock);
    8100067e:	0000f517          	auipc	a0,0xf
    81000682:	3ca50513          	addi	a0,a0,970 # 8100fa48 <pr>
    81000686:	6c2000ef          	jal	81000d48 <acquire>
  va_start(ap, fmt);
    8100068a:	00840793          	addi	a5,s0,8
    8100068e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    81000692:	000a4503          	lbu	a0,0(s4)
    81000696:	fd4d                	bnez	a0,81000650 <printf+0x3c>
    81000698:	ac3d                	j	810008d6 <printf+0x2c2>
      consputc(cx);
    8100069a:	cfbff0ef          	jal	81000394 <consputc>
      continue;
    8100069e:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    810006a0:	2485                	addiw	s1,s1,1
    810006a2:	89a6                	mv	s3,s1
    810006a4:	94d2                	add	s1,s1,s4
    810006a6:	0004c503          	lbu	a0,0(s1)
    810006aa:	1e050b63          	beqz	a0,810008a0 <printf+0x28c>
    if(cx != '%'){
    810006ae:	ff5516e3          	bne	a0,s5,8100069a <printf+0x86>
    i++;
    810006b2:	0019879b          	addiw	a5,s3,1
    810006b6:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    810006b8:	00fa0733          	add	a4,s4,a5
    810006bc:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    810006c0:	1e090063          	beqz	s2,810008a0 <printf+0x28c>
    810006c4:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    810006c8:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    810006ca:	c701                	beqz	a4,810006d2 <printf+0xbe>
    810006cc:	97d2                	add	a5,a5,s4
    810006ce:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    810006d2:	03690763          	beq	s2,s6,81000700 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    810006d6:	05890163          	beq	s2,s8,81000718 <printf+0x104>
    } else if(c0 == 'u'){
    810006da:	0d990b63          	beq	s2,s9,810007b0 <printf+0x19c>
    } else if(c0 == 'x'){
    810006de:	13a90163          	beq	s2,s10,81000800 <printf+0x1ec>
    } else if(c0 == 'p'){
    810006e2:	13b90b63          	beq	s2,s11,81000818 <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    810006e6:	07300793          	li	a5,115
    810006ea:	16f90a63          	beq	s2,a5,8100085e <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    810006ee:	1b590463          	beq	s2,s5,81000896 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    810006f2:	8556                	mv	a0,s5
    810006f4:	ca1ff0ef          	jal	81000394 <consputc>
      consputc(c0);
    810006f8:	854a                	mv	a0,s2
    810006fa:	c9bff0ef          	jal	81000394 <consputc>
    810006fe:	b74d                	j	810006a0 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    81000700:	f8843783          	ld	a5,-120(s0)
    81000704:	00878713          	addi	a4,a5,8
    81000708:	f8e43423          	sd	a4,-120(s0)
    8100070c:	4605                	li	a2,1
    8100070e:	45a9                	li	a1,10
    81000710:	4388                	lw	a0,0(a5)
    81000712:	e79ff0ef          	jal	8100058a <printint>
    81000716:	b769                	j	810006a0 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    81000718:	03670663          	beq	a4,s6,81000744 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8100071c:	05870263          	beq	a4,s8,81000760 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    81000720:	0b970463          	beq	a4,s9,810007c8 <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    81000724:	fda717e3          	bne	a4,s10,810006f2 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    81000728:	f8843783          	ld	a5,-120(s0)
    8100072c:	00878713          	addi	a4,a5,8
    81000730:	f8e43423          	sd	a4,-120(s0)
    81000734:	4601                	li	a2,0
    81000736:	45c1                	li	a1,16
    81000738:	6388                	ld	a0,0(a5)
    8100073a:	e51ff0ef          	jal	8100058a <printint>
      i += 1;
    8100073e:	0029849b          	addiw	s1,s3,2
    81000742:	bfb9                	j	810006a0 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    81000744:	f8843783          	ld	a5,-120(s0)
    81000748:	00878713          	addi	a4,a5,8
    8100074c:	f8e43423          	sd	a4,-120(s0)
    81000750:	4605                	li	a2,1
    81000752:	45a9                	li	a1,10
    81000754:	6388                	ld	a0,0(a5)
    81000756:	e35ff0ef          	jal	8100058a <printint>
      i += 1;
    8100075a:	0029849b          	addiw	s1,s3,2
    8100075e:	b789                	j	810006a0 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    81000760:	06400793          	li	a5,100
    81000764:	02f68863          	beq	a3,a5,81000794 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    81000768:	07500793          	li	a5,117
    8100076c:	06f68c63          	beq	a3,a5,810007e4 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    81000770:	07800793          	li	a5,120
    81000774:	f6f69fe3          	bne	a3,a5,810006f2 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    81000778:	f8843783          	ld	a5,-120(s0)
    8100077c:	00878713          	addi	a4,a5,8
    81000780:	f8e43423          	sd	a4,-120(s0)
    81000784:	4601                	li	a2,0
    81000786:	45c1                	li	a1,16
    81000788:	6388                	ld	a0,0(a5)
    8100078a:	e01ff0ef          	jal	8100058a <printint>
      i += 2;
    8100078e:	0039849b          	addiw	s1,s3,3
    81000792:	b739                	j	810006a0 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    81000794:	f8843783          	ld	a5,-120(s0)
    81000798:	00878713          	addi	a4,a5,8
    8100079c:	f8e43423          	sd	a4,-120(s0)
    810007a0:	4605                	li	a2,1
    810007a2:	45a9                	li	a1,10
    810007a4:	6388                	ld	a0,0(a5)
    810007a6:	de5ff0ef          	jal	8100058a <printint>
      i += 2;
    810007aa:	0039849b          	addiw	s1,s3,3
    810007ae:	bdcd                	j	810006a0 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    810007b0:	f8843783          	ld	a5,-120(s0)
    810007b4:	00878713          	addi	a4,a5,8
    810007b8:	f8e43423          	sd	a4,-120(s0)
    810007bc:	4601                	li	a2,0
    810007be:	45a9                	li	a1,10
    810007c0:	4388                	lw	a0,0(a5)
    810007c2:	dc9ff0ef          	jal	8100058a <printint>
    810007c6:	bde9                	j	810006a0 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    810007c8:	f8843783          	ld	a5,-120(s0)
    810007cc:	00878713          	addi	a4,a5,8
    810007d0:	f8e43423          	sd	a4,-120(s0)
    810007d4:	4601                	li	a2,0
    810007d6:	45a9                	li	a1,10
    810007d8:	6388                	ld	a0,0(a5)
    810007da:	db1ff0ef          	jal	8100058a <printint>
      i += 1;
    810007de:	0029849b          	addiw	s1,s3,2
    810007e2:	bd7d                	j	810006a0 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    810007e4:	f8843783          	ld	a5,-120(s0)
    810007e8:	00878713          	addi	a4,a5,8
    810007ec:	f8e43423          	sd	a4,-120(s0)
    810007f0:	4601                	li	a2,0
    810007f2:	45a9                	li	a1,10
    810007f4:	6388                	ld	a0,0(a5)
    810007f6:	d95ff0ef          	jal	8100058a <printint>
      i += 2;
    810007fa:	0039849b          	addiw	s1,s3,3
    810007fe:	b54d                	j	810006a0 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    81000800:	f8843783          	ld	a5,-120(s0)
    81000804:	00878713          	addi	a4,a5,8
    81000808:	f8e43423          	sd	a4,-120(s0)
    8100080c:	4601                	li	a2,0
    8100080e:	45c1                	li	a1,16
    81000810:	4388                	lw	a0,0(a5)
    81000812:	d79ff0ef          	jal	8100058a <printint>
    81000816:	b569                	j	810006a0 <printf+0x8c>
    81000818:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8100081a:	f8843783          	ld	a5,-120(s0)
    8100081e:	00878713          	addi	a4,a5,8
    81000822:	f8e43423          	sd	a4,-120(s0)
    81000826:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8100082a:	03000513          	li	a0,48
    8100082e:	b67ff0ef          	jal	81000394 <consputc>
  consputc('x');
    81000832:	07800513          	li	a0,120
    81000836:	b5fff0ef          	jal	81000394 <consputc>
    8100083a:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8100083c:	00007b97          	auipc	s7,0x7
    81000840:	fbcb8b93          	addi	s7,s7,-68 # 810077f8 <digits>
    81000844:	03c9d793          	srli	a5,s3,0x3c
    81000848:	97de                	add	a5,a5,s7
    8100084a:	0007c503          	lbu	a0,0(a5)
    8100084e:	b47ff0ef          	jal	81000394 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    81000852:	0992                	slli	s3,s3,0x4
    81000854:	397d                	addiw	s2,s2,-1
    81000856:	fe0917e3          	bnez	s2,81000844 <printf+0x230>
    8100085a:	6ba6                	ld	s7,72(sp)
    8100085c:	b591                	j	810006a0 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8100085e:	f8843783          	ld	a5,-120(s0)
    81000862:	00878713          	addi	a4,a5,8
    81000866:	f8e43423          	sd	a4,-120(s0)
    8100086a:	0007b903          	ld	s2,0(a5)
    8100086e:	00090d63          	beqz	s2,81000888 <printf+0x274>
      for(; *s; s++)
    81000872:	00094503          	lbu	a0,0(s2)
    81000876:	e20505e3          	beqz	a0,810006a0 <printf+0x8c>
        consputc(*s);
    8100087a:	b1bff0ef          	jal	81000394 <consputc>
      for(; *s; s++)
    8100087e:	0905                	addi	s2,s2,1
    81000880:	00094503          	lbu	a0,0(s2)
    81000884:	f97d                	bnez	a0,8100087a <printf+0x266>
    81000886:	bd29                	j	810006a0 <printf+0x8c>
        s = "(null)";
    81000888:	00007917          	auipc	s2,0x7
    8100088c:	81090913          	addi	s2,s2,-2032 # 81007098 <etext+0x98>
      for(; *s; s++)
    81000890:	02800513          	li	a0,40
    81000894:	b7dd                	j	8100087a <printf+0x266>
      consputc('%');
    81000896:	02500513          	li	a0,37
    8100089a:	afbff0ef          	jal	81000394 <consputc>
    8100089e:	b509                	j	810006a0 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    810008a0:	f7843783          	ld	a5,-136(s0)
    810008a4:	e385                	bnez	a5,810008c4 <printf+0x2b0>
    810008a6:	74e6                	ld	s1,120(sp)
    810008a8:	7946                	ld	s2,112(sp)
    810008aa:	79a6                	ld	s3,104(sp)
    810008ac:	6ae6                	ld	s5,88(sp)
    810008ae:	6b46                	ld	s6,80(sp)
    810008b0:	6c06                	ld	s8,64(sp)
    810008b2:	7ce2                	ld	s9,56(sp)
    810008b4:	7d42                	ld	s10,48(sp)
    810008b6:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    810008b8:	4501                	li	a0,0
    810008ba:	60aa                	ld	ra,136(sp)
    810008bc:	640a                	ld	s0,128(sp)
    810008be:	7a06                	ld	s4,96(sp)
    810008c0:	6169                	addi	sp,sp,208
    810008c2:	8082                	ret
    810008c4:	74e6                	ld	s1,120(sp)
    810008c6:	7946                	ld	s2,112(sp)
    810008c8:	79a6                	ld	s3,104(sp)
    810008ca:	6ae6                	ld	s5,88(sp)
    810008cc:	6b46                	ld	s6,80(sp)
    810008ce:	6c06                	ld	s8,64(sp)
    810008d0:	7ce2                	ld	s9,56(sp)
    810008d2:	7d42                	ld	s10,48(sp)
    810008d4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    810008d6:	0000f517          	auipc	a0,0xf
    810008da:	17250513          	addi	a0,a0,370 # 8100fa48 <pr>
    810008de:	4fe000ef          	jal	81000ddc <release>
    810008e2:	bfd9                	j	810008b8 <printf+0x2a4>

00000000810008e4 <panic>:

void
panic(char *s)
{
    810008e4:	1101                	addi	sp,sp,-32
    810008e6:	ec06                	sd	ra,24(sp)
    810008e8:	e822                	sd	s0,16(sp)
    810008ea:	e426                	sd	s1,8(sp)
    810008ec:	1000                	addi	s0,sp,32
    810008ee:	84aa                	mv	s1,a0
  pr.locking = 0;
    810008f0:	0000f797          	auipc	a5,0xf
    810008f4:	1607a823          	sw	zero,368(a5) # 8100fa60 <pr+0x18>
  printf("panic: ");
    810008f8:	00006517          	auipc	a0,0x6
    810008fc:	7a850513          	addi	a0,a0,1960 # 810070a0 <etext+0xa0>
    81000900:	d15ff0ef          	jal	81000614 <printf>
  printf("%s\n", s);
    81000904:	85a6                	mv	a1,s1
    81000906:	00006517          	auipc	a0,0x6
    8100090a:	7a250513          	addi	a0,a0,1954 # 810070a8 <etext+0xa8>
    8100090e:	d07ff0ef          	jal	81000614 <printf>
  panicked = 1; // freeze uart output from other CPUs
    81000912:	4785                	li	a5,1
    81000914:	00007717          	auipc	a4,0x7
    81000918:	04f72623          	sw	a5,76(a4) # 81007960 <panicked>
  for(;;)
    8100091c:	a001                	j	8100091c <panic+0x38>

000000008100091e <printfinit>:
    ;
}

void
printfinit(void)
{
    8100091e:	1101                	addi	sp,sp,-32
    81000920:	ec06                	sd	ra,24(sp)
    81000922:	e822                	sd	s0,16(sp)
    81000924:	e426                	sd	s1,8(sp)
    81000926:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    81000928:	0000f497          	auipc	s1,0xf
    8100092c:	12048493          	addi	s1,s1,288 # 8100fa48 <pr>
    81000930:	00006597          	auipc	a1,0x6
    81000934:	78058593          	addi	a1,a1,1920 # 810070b0 <etext+0xb0>
    81000938:	8526                	mv	a0,s1
    8100093a:	38a000ef          	jal	81000cc4 <initlock>
  pr.locking = 1;
    8100093e:	4785                	li	a5,1
    81000940:	cc9c                	sw	a5,24(s1)
}
    81000942:	60e2                	ld	ra,24(sp)
    81000944:	6442                	ld	s0,16(sp)
    81000946:	64a2                	ld	s1,8(sp)
    81000948:	6105                	addi	sp,sp,32
    8100094a:	8082                	ret

000000008100094c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8100094c:	1141                	addi	sp,sp,-16
    8100094e:	e406                	sd	ra,8(sp)
    81000950:	e022                	sd	s0,0(sp)
    81000952:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    81000954:	100007b7          	lui	a5,0x10000
    81000958:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x70ffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8100095c:	10000737          	lui	a4,0x10000
    81000960:	f8000693          	li	a3,-128
    81000964:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x70fffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    81000968:	468d                	li	a3,3
    8100096a:	10000637          	lui	a2,0x10000
    8100096e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x71000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    81000972:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    81000976:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8100097a:	8732                	mv	a4,a2
    8100097c:	461d                	li	a2,7
    8100097e:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    81000982:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    81000986:	00006597          	auipc	a1,0x6
    8100098a:	73258593          	addi	a1,a1,1842 # 810070b8 <etext+0xb8>
    8100098e:	0000f517          	auipc	a0,0xf
    81000992:	0da50513          	addi	a0,a0,218 # 8100fa68 <uart_tx_lock>
    81000996:	32e000ef          	jal	81000cc4 <initlock>
}
    8100099a:	60a2                	ld	ra,8(sp)
    8100099c:	6402                	ld	s0,0(sp)
    8100099e:	0141                	addi	sp,sp,16
    810009a0:	8082                	ret

00000000810009a2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    810009a2:	1101                	addi	sp,sp,-32
    810009a4:	ec06                	sd	ra,24(sp)
    810009a6:	e822                	sd	s0,16(sp)
    810009a8:	e426                	sd	s1,8(sp)
    810009aa:	1000                	addi	s0,sp,32
    810009ac:	84aa                	mv	s1,a0
  push_off();
    810009ae:	35a000ef          	jal	81000d08 <push_off>

  if(panicked){
    810009b2:	00007797          	auipc	a5,0x7
    810009b6:	fae7a783          	lw	a5,-82(a5) # 81007960 <panicked>
    810009ba:	e795                	bnez	a5,810009e6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    810009bc:	10000737          	lui	a4,0x10000
    810009c0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x70fffffb>
    810009c2:	00074783          	lbu	a5,0(a4)
    810009c6:	0207f793          	andi	a5,a5,32
    810009ca:	dfe5                	beqz	a5,810009c2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    810009cc:	0ff4f513          	zext.b	a0,s1
    810009d0:	100007b7          	lui	a5,0x10000
    810009d4:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x71000000>

  pop_off();
    810009d8:	3b4000ef          	jal	81000d8c <pop_off>
}
    810009dc:	60e2                	ld	ra,24(sp)
    810009de:	6442                	ld	s0,16(sp)
    810009e0:	64a2                	ld	s1,8(sp)
    810009e2:	6105                	addi	sp,sp,32
    810009e4:	8082                	ret
    for(;;)
    810009e6:	a001                	j	810009e6 <uartputc_sync+0x44>

00000000810009e8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    810009e8:	00007797          	auipc	a5,0x7
    810009ec:	f807b783          	ld	a5,-128(a5) # 81007968 <uart_tx_r>
    810009f0:	00007717          	auipc	a4,0x7
    810009f4:	f8073703          	ld	a4,-128(a4) # 81007970 <uart_tx_w>
    810009f8:	08f70163          	beq	a4,a5,81000a7a <uartstart+0x92>
{
    810009fc:	7139                	addi	sp,sp,-64
    810009fe:	fc06                	sd	ra,56(sp)
    81000a00:	f822                	sd	s0,48(sp)
    81000a02:	f426                	sd	s1,40(sp)
    81000a04:	f04a                	sd	s2,32(sp)
    81000a06:	ec4e                	sd	s3,24(sp)
    81000a08:	e852                	sd	s4,16(sp)
    81000a0a:	e456                	sd	s5,8(sp)
    81000a0c:	e05a                	sd	s6,0(sp)
    81000a0e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    81000a10:	10000937          	lui	s2,0x10000
    81000a14:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x70fffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    81000a16:	0000fa97          	auipc	s5,0xf
    81000a1a:	052a8a93          	addi	s5,s5,82 # 8100fa68 <uart_tx_lock>
    uart_tx_r += 1;
    81000a1e:	00007497          	auipc	s1,0x7
    81000a22:	f4a48493          	addi	s1,s1,-182 # 81007968 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    81000a26:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    81000a2a:	00007997          	auipc	s3,0x7
    81000a2e:	f4698993          	addi	s3,s3,-186 # 81007970 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    81000a32:	00094703          	lbu	a4,0(s2)
    81000a36:	02077713          	andi	a4,a4,32
    81000a3a:	c715                	beqz	a4,81000a66 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    81000a3c:	01f7f713          	andi	a4,a5,31
    81000a40:	9756                	add	a4,a4,s5
    81000a42:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    81000a46:	0785                	addi	a5,a5,1
    81000a48:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    81000a4a:	8526                	mv	a0,s1
    81000a4c:	604010ef          	jal	81002050 <wakeup>
    WriteReg(THR, c);
    81000a50:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x71000000>
    if(uart_tx_w == uart_tx_r){
    81000a54:	609c                	ld	a5,0(s1)
    81000a56:	0009b703          	ld	a4,0(s3)
    81000a5a:	fcf71ce3          	bne	a4,a5,81000a32 <uartstart+0x4a>
      ReadReg(ISR);
    81000a5e:	100007b7          	lui	a5,0x10000
    81000a62:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x70fffffe>
  }
}
    81000a66:	70e2                	ld	ra,56(sp)
    81000a68:	7442                	ld	s0,48(sp)
    81000a6a:	74a2                	ld	s1,40(sp)
    81000a6c:	7902                	ld	s2,32(sp)
    81000a6e:	69e2                	ld	s3,24(sp)
    81000a70:	6a42                	ld	s4,16(sp)
    81000a72:	6aa2                	ld	s5,8(sp)
    81000a74:	6b02                	ld	s6,0(sp)
    81000a76:	6121                	addi	sp,sp,64
    81000a78:	8082                	ret
      ReadReg(ISR);
    81000a7a:	100007b7          	lui	a5,0x10000
    81000a7e:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x70fffffe>
      return;
    81000a82:	8082                	ret

0000000081000a84 <uartputc>:
{
    81000a84:	7179                	addi	sp,sp,-48
    81000a86:	f406                	sd	ra,40(sp)
    81000a88:	f022                	sd	s0,32(sp)
    81000a8a:	ec26                	sd	s1,24(sp)
    81000a8c:	e84a                	sd	s2,16(sp)
    81000a8e:	e44e                	sd	s3,8(sp)
    81000a90:	e052                	sd	s4,0(sp)
    81000a92:	1800                	addi	s0,sp,48
    81000a94:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    81000a96:	0000f517          	auipc	a0,0xf
    81000a9a:	fd250513          	addi	a0,a0,-46 # 8100fa68 <uart_tx_lock>
    81000a9e:	2aa000ef          	jal	81000d48 <acquire>
  if(panicked){
    81000aa2:	00007797          	auipc	a5,0x7
    81000aa6:	ebe7a783          	lw	a5,-322(a5) # 81007960 <panicked>
    81000aaa:	efbd                	bnez	a5,81000b28 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    81000aac:	00007717          	auipc	a4,0x7
    81000ab0:	ec473703          	ld	a4,-316(a4) # 81007970 <uart_tx_w>
    81000ab4:	00007797          	auipc	a5,0x7
    81000ab8:	eb47b783          	ld	a5,-332(a5) # 81007968 <uart_tx_r>
    81000abc:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    81000ac0:	0000f997          	auipc	s3,0xf
    81000ac4:	fa898993          	addi	s3,s3,-88 # 8100fa68 <uart_tx_lock>
    81000ac8:	00007497          	auipc	s1,0x7
    81000acc:	ea048493          	addi	s1,s1,-352 # 81007968 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    81000ad0:	00007917          	auipc	s2,0x7
    81000ad4:	ea090913          	addi	s2,s2,-352 # 81007970 <uart_tx_w>
    81000ad8:	00e79d63          	bne	a5,a4,81000af2 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    81000adc:	85ce                	mv	a1,s3
    81000ade:	8526                	mv	a0,s1
    81000ae0:	524010ef          	jal	81002004 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    81000ae4:	00093703          	ld	a4,0(s2)
    81000ae8:	609c                	ld	a5,0(s1)
    81000aea:	02078793          	addi	a5,a5,32
    81000aee:	fee787e3          	beq	a5,a4,81000adc <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    81000af2:	0000f497          	auipc	s1,0xf
    81000af6:	f7648493          	addi	s1,s1,-138 # 8100fa68 <uart_tx_lock>
    81000afa:	01f77793          	andi	a5,a4,31
    81000afe:	97a6                	add	a5,a5,s1
    81000b00:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    81000b04:	0705                	addi	a4,a4,1
    81000b06:	00007797          	auipc	a5,0x7
    81000b0a:	e6e7b523          	sd	a4,-406(a5) # 81007970 <uart_tx_w>
  uartstart();
    81000b0e:	edbff0ef          	jal	810009e8 <uartstart>
  release(&uart_tx_lock);
    81000b12:	8526                	mv	a0,s1
    81000b14:	2c8000ef          	jal	81000ddc <release>
}
    81000b18:	70a2                	ld	ra,40(sp)
    81000b1a:	7402                	ld	s0,32(sp)
    81000b1c:	64e2                	ld	s1,24(sp)
    81000b1e:	6942                	ld	s2,16(sp)
    81000b20:	69a2                	ld	s3,8(sp)
    81000b22:	6a02                	ld	s4,0(sp)
    81000b24:	6145                	addi	sp,sp,48
    81000b26:	8082                	ret
    for(;;)
    81000b28:	a001                	j	81000b28 <uartputc+0xa4>

0000000081000b2a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    81000b2a:	1141                	addi	sp,sp,-16
    81000b2c:	e406                	sd	ra,8(sp)
    81000b2e:	e022                	sd	s0,0(sp)
    81000b30:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    81000b32:	100007b7          	lui	a5,0x10000
    81000b36:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x70fffffb>
    81000b3a:	8b85                	andi	a5,a5,1
    81000b3c:	cb89                	beqz	a5,81000b4e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    81000b3e:	100007b7          	lui	a5,0x10000
    81000b42:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x71000000>
  } else {
    return -1;
  }
}
    81000b46:	60a2                	ld	ra,8(sp)
    81000b48:	6402                	ld	s0,0(sp)
    81000b4a:	0141                	addi	sp,sp,16
    81000b4c:	8082                	ret
    return -1;
    81000b4e:	557d                	li	a0,-1
    81000b50:	bfdd                	j	81000b46 <uartgetc+0x1c>

0000000081000b52 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    81000b52:	1101                	addi	sp,sp,-32
    81000b54:	ec06                	sd	ra,24(sp)
    81000b56:	e822                	sd	s0,16(sp)
    81000b58:	e426                	sd	s1,8(sp)
    81000b5a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    81000b5c:	54fd                	li	s1,-1
    int c = uartgetc();
    81000b5e:	fcdff0ef          	jal	81000b2a <uartgetc>
    if(c == -1)
    81000b62:	00950563          	beq	a0,s1,81000b6c <uartintr+0x1a>
      break;
    consoleintr(c);
    81000b66:	861ff0ef          	jal	810003c6 <consoleintr>
  while(1){
    81000b6a:	bfd5                	j	81000b5e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    81000b6c:	0000f497          	auipc	s1,0xf
    81000b70:	efc48493          	addi	s1,s1,-260 # 8100fa68 <uart_tx_lock>
    81000b74:	8526                	mv	a0,s1
    81000b76:	1d2000ef          	jal	81000d48 <acquire>
  uartstart();
    81000b7a:	e6fff0ef          	jal	810009e8 <uartstart>
  release(&uart_tx_lock);
    81000b7e:	8526                	mv	a0,s1
    81000b80:	25c000ef          	jal	81000ddc <release>
}
    81000b84:	60e2                	ld	ra,24(sp)
    81000b86:	6442                	ld	s0,16(sp)
    81000b88:	64a2                	ld	s1,8(sp)
    81000b8a:	6105                	addi	sp,sp,32
    81000b8c:	8082                	ret

0000000081000b8e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    81000b8e:	1101                	addi	sp,sp,-32
    81000b90:	ec06                	sd	ra,24(sp)
    81000b92:	e822                	sd	s0,16(sp)
    81000b94:	e426                	sd	s1,8(sp)
    81000b96:	e04a                	sd	s2,0(sp)
    81000b98:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    81000b9a:	03451793          	slli	a5,a0,0x34
    81000b9e:	e7b1                	bnez	a5,81000bea <kfree+0x5c>
    81000ba0:	84aa                	mv	s1,a0
    81000ba2:	00020797          	auipc	a5,0x20
    81000ba6:	45e78793          	addi	a5,a5,1118 # 81021000 <end>
    81000baa:	04f56063          	bltu	a0,a5,81000bea <kfree+0x5c>
    81000bae:	08900793          	li	a5,137
    81000bb2:	07e2                	slli	a5,a5,0x18
    81000bb4:	02f57b63          	bgeu	a0,a5,81000bea <kfree+0x5c>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    81000bb8:	6605                	lui	a2,0x1
    81000bba:	4585                	li	a1,1
    81000bbc:	25c000ef          	jal	81000e18 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    81000bc0:	0000f917          	auipc	s2,0xf
    81000bc4:	ee090913          	addi	s2,s2,-288 # 8100faa0 <kmem>
    81000bc8:	854a                	mv	a0,s2
    81000bca:	17e000ef          	jal	81000d48 <acquire>
  r->next = kmem.freelist;
    81000bce:	01893783          	ld	a5,24(s2)
    81000bd2:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    81000bd4:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    81000bd8:	854a                	mv	a0,s2
    81000bda:	202000ef          	jal	81000ddc <release>
}
    81000bde:	60e2                	ld	ra,24(sp)
    81000be0:	6442                	ld	s0,16(sp)
    81000be2:	64a2                	ld	s1,8(sp)
    81000be4:	6902                	ld	s2,0(sp)
    81000be6:	6105                	addi	sp,sp,32
    81000be8:	8082                	ret
    panic("kfree");
    81000bea:	00006517          	auipc	a0,0x6
    81000bee:	4d650513          	addi	a0,a0,1238 # 810070c0 <etext+0xc0>
    81000bf2:	cf3ff0ef          	jal	810008e4 <panic>

0000000081000bf6 <freerange>:
{
    81000bf6:	7179                	addi	sp,sp,-48
    81000bf8:	f406                	sd	ra,40(sp)
    81000bfa:	f022                	sd	s0,32(sp)
    81000bfc:	ec26                	sd	s1,24(sp)
    81000bfe:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    81000c00:	6785                	lui	a5,0x1
    81000c02:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x80fff001>
    81000c06:	00e504b3          	add	s1,a0,a4
    81000c0a:	777d                	lui	a4,0xfffff
    81000c0c:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    81000c0e:	94be                	add	s1,s1,a5
    81000c10:	0295e263          	bltu	a1,s1,81000c34 <freerange+0x3e>
    81000c14:	e84a                	sd	s2,16(sp)
    81000c16:	e44e                	sd	s3,8(sp)
    81000c18:	e052                	sd	s4,0(sp)
    81000c1a:	892e                	mv	s2,a1
    kfree(p);
    81000c1c:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    81000c1e:	89be                	mv	s3,a5
    kfree(p);
    81000c20:	01448533          	add	a0,s1,s4
    81000c24:	f6bff0ef          	jal	81000b8e <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    81000c28:	94ce                	add	s1,s1,s3
    81000c2a:	fe997be3          	bgeu	s2,s1,81000c20 <freerange+0x2a>
    81000c2e:	6942                	ld	s2,16(sp)
    81000c30:	69a2                	ld	s3,8(sp)
    81000c32:	6a02                	ld	s4,0(sp)
}
    81000c34:	70a2                	ld	ra,40(sp)
    81000c36:	7402                	ld	s0,32(sp)
    81000c38:	64e2                	ld	s1,24(sp)
    81000c3a:	6145                	addi	sp,sp,48
    81000c3c:	8082                	ret

0000000081000c3e <kinit>:
{
    81000c3e:	1141                	addi	sp,sp,-16
    81000c40:	e406                	sd	ra,8(sp)
    81000c42:	e022                	sd	s0,0(sp)
    81000c44:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    81000c46:	00006597          	auipc	a1,0x6
    81000c4a:	48258593          	addi	a1,a1,1154 # 810070c8 <etext+0xc8>
    81000c4e:	0000f517          	auipc	a0,0xf
    81000c52:	e5250513          	addi	a0,a0,-430 # 8100faa0 <kmem>
    81000c56:	06e000ef          	jal	81000cc4 <initlock>
  freerange(end, (void*)PHYSTOP);
    81000c5a:	08900593          	li	a1,137
    81000c5e:	05e2                	slli	a1,a1,0x18
    81000c60:	00020517          	auipc	a0,0x20
    81000c64:	3a050513          	addi	a0,a0,928 # 81021000 <end>
    81000c68:	f8fff0ef          	jal	81000bf6 <freerange>
}
    81000c6c:	60a2                	ld	ra,8(sp)
    81000c6e:	6402                	ld	s0,0(sp)
    81000c70:	0141                	addi	sp,sp,16
    81000c72:	8082                	ret

0000000081000c74 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    81000c74:	1101                	addi	sp,sp,-32
    81000c76:	ec06                	sd	ra,24(sp)
    81000c78:	e822                	sd	s0,16(sp)
    81000c7a:	e426                	sd	s1,8(sp)
    81000c7c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    81000c7e:	0000f497          	auipc	s1,0xf
    81000c82:	e2248493          	addi	s1,s1,-478 # 8100faa0 <kmem>
    81000c86:	8526                	mv	a0,s1
    81000c88:	0c0000ef          	jal	81000d48 <acquire>
  r = kmem.freelist;
    81000c8c:	6c84                	ld	s1,24(s1)
  if(r)
    81000c8e:	c485                	beqz	s1,81000cb6 <kalloc+0x42>
    kmem.freelist = r->next;
    81000c90:	609c                	ld	a5,0(s1)
    81000c92:	0000f517          	auipc	a0,0xf
    81000c96:	e0e50513          	addi	a0,a0,-498 # 8100faa0 <kmem>
    81000c9a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    81000c9c:	140000ef          	jal	81000ddc <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    81000ca0:	6605                	lui	a2,0x1
    81000ca2:	4595                	li	a1,5
    81000ca4:	8526                	mv	a0,s1
    81000ca6:	172000ef          	jal	81000e18 <memset>
  return (void*)r;
}
    81000caa:	8526                	mv	a0,s1
    81000cac:	60e2                	ld	ra,24(sp)
    81000cae:	6442                	ld	s0,16(sp)
    81000cb0:	64a2                	ld	s1,8(sp)
    81000cb2:	6105                	addi	sp,sp,32
    81000cb4:	8082                	ret
  release(&kmem.lock);
    81000cb6:	0000f517          	auipc	a0,0xf
    81000cba:	dea50513          	addi	a0,a0,-534 # 8100faa0 <kmem>
    81000cbe:	11e000ef          	jal	81000ddc <release>
  if(r)
    81000cc2:	b7e5                	j	81000caa <kalloc+0x36>

0000000081000cc4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    81000cc4:	1141                	addi	sp,sp,-16
    81000cc6:	e406                	sd	ra,8(sp)
    81000cc8:	e022                	sd	s0,0(sp)
    81000cca:	0800                	addi	s0,sp,16
  lk->name = name;
    81000ccc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    81000cce:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    81000cd2:	00053823          	sd	zero,16(a0)
}
    81000cd6:	60a2                	ld	ra,8(sp)
    81000cd8:	6402                	ld	s0,0(sp)
    81000cda:	0141                	addi	sp,sp,16
    81000cdc:	8082                	ret

0000000081000cde <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    81000cde:	411c                	lw	a5,0(a0)
    81000ce0:	e399                	bnez	a5,81000ce6 <holding+0x8>
    81000ce2:	4501                	li	a0,0
  return r;
}
    81000ce4:	8082                	ret
{
    81000ce6:	1101                	addi	sp,sp,-32
    81000ce8:	ec06                	sd	ra,24(sp)
    81000cea:	e822                	sd	s0,16(sp)
    81000cec:	e426                	sd	s1,8(sp)
    81000cee:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    81000cf0:	6904                	ld	s1,16(a0)
    81000cf2:	525000ef          	jal	81001a16 <mycpu>
    81000cf6:	40a48533          	sub	a0,s1,a0
    81000cfa:	00153513          	seqz	a0,a0
}
    81000cfe:	60e2                	ld	ra,24(sp)
    81000d00:	6442                	ld	s0,16(sp)
    81000d02:	64a2                	ld	s1,8(sp)
    81000d04:	6105                	addi	sp,sp,32
    81000d06:	8082                	ret

0000000081000d08 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    81000d08:	1101                	addi	sp,sp,-32
    81000d0a:	ec06                	sd	ra,24(sp)
    81000d0c:	e822                	sd	s0,16(sp)
    81000d0e:	e426                	sd	s1,8(sp)
    81000d10:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81000d12:	100024f3          	csrr	s1,sstatus
    81000d16:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    81000d1a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81000d1c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    81000d20:	4f7000ef          	jal	81001a16 <mycpu>
    81000d24:	5d3c                	lw	a5,120(a0)
    81000d26:	cb99                	beqz	a5,81000d3c <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    81000d28:	4ef000ef          	jal	81001a16 <mycpu>
    81000d2c:	5d3c                	lw	a5,120(a0)
    81000d2e:	2785                	addiw	a5,a5,1
    81000d30:	dd3c                	sw	a5,120(a0)
}
    81000d32:	60e2                	ld	ra,24(sp)
    81000d34:	6442                	ld	s0,16(sp)
    81000d36:	64a2                	ld	s1,8(sp)
    81000d38:	6105                	addi	sp,sp,32
    81000d3a:	8082                	ret
    mycpu()->intena = old;
    81000d3c:	4db000ef          	jal	81001a16 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    81000d40:	8085                	srli	s1,s1,0x1
    81000d42:	8885                	andi	s1,s1,1
    81000d44:	dd64                	sw	s1,124(a0)
    81000d46:	b7cd                	j	81000d28 <push_off+0x20>

0000000081000d48 <acquire>:
{
    81000d48:	1101                	addi	sp,sp,-32
    81000d4a:	ec06                	sd	ra,24(sp)
    81000d4c:	e822                	sd	s0,16(sp)
    81000d4e:	e426                	sd	s1,8(sp)
    81000d50:	1000                	addi	s0,sp,32
    81000d52:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    81000d54:	fb5ff0ef          	jal	81000d08 <push_off>
  if(holding(lk))
    81000d58:	8526                	mv	a0,s1
    81000d5a:	f85ff0ef          	jal	81000cde <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    81000d5e:	4705                	li	a4,1
  if(holding(lk))
    81000d60:	e105                	bnez	a0,81000d80 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    81000d62:	87ba                	mv	a5,a4
    81000d64:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    81000d68:	2781                	sext.w	a5,a5
    81000d6a:	ffe5                	bnez	a5,81000d62 <acquire+0x1a>
  __sync_synchronize();
    81000d6c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    81000d70:	4a7000ef          	jal	81001a16 <mycpu>
    81000d74:	e888                	sd	a0,16(s1)
}
    81000d76:	60e2                	ld	ra,24(sp)
    81000d78:	6442                	ld	s0,16(sp)
    81000d7a:	64a2                	ld	s1,8(sp)
    81000d7c:	6105                	addi	sp,sp,32
    81000d7e:	8082                	ret
    panic("acquire");
    81000d80:	00006517          	auipc	a0,0x6
    81000d84:	35050513          	addi	a0,a0,848 # 810070d0 <etext+0xd0>
    81000d88:	b5dff0ef          	jal	810008e4 <panic>

0000000081000d8c <pop_off>:

void
pop_off(void)
{
    81000d8c:	1141                	addi	sp,sp,-16
    81000d8e:	e406                	sd	ra,8(sp)
    81000d90:	e022                	sd	s0,0(sp)
    81000d92:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    81000d94:	483000ef          	jal	81001a16 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81000d98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    81000d9c:	8b89                	andi	a5,a5,2
  if(intr_get())
    81000d9e:	e39d                	bnez	a5,81000dc4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    81000da0:	5d3c                	lw	a5,120(a0)
    81000da2:	02f05763          	blez	a5,81000dd0 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    81000da6:	37fd                	addiw	a5,a5,-1
    81000da8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    81000daa:	eb89                	bnez	a5,81000dbc <pop_off+0x30>
    81000dac:	5d7c                	lw	a5,124(a0)
    81000dae:	c799                	beqz	a5,81000dbc <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81000db0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    81000db4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81000db8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    81000dbc:	60a2                	ld	ra,8(sp)
    81000dbe:	6402                	ld	s0,0(sp)
    81000dc0:	0141                	addi	sp,sp,16
    81000dc2:	8082                	ret
    panic("pop_off - interruptible");
    81000dc4:	00006517          	auipc	a0,0x6
    81000dc8:	31450513          	addi	a0,a0,788 # 810070d8 <etext+0xd8>
    81000dcc:	b19ff0ef          	jal	810008e4 <panic>
    panic("pop_off");
    81000dd0:	00006517          	auipc	a0,0x6
    81000dd4:	32050513          	addi	a0,a0,800 # 810070f0 <etext+0xf0>
    81000dd8:	b0dff0ef          	jal	810008e4 <panic>

0000000081000ddc <release>:
{
    81000ddc:	1101                	addi	sp,sp,-32
    81000dde:	ec06                	sd	ra,24(sp)
    81000de0:	e822                	sd	s0,16(sp)
    81000de2:	e426                	sd	s1,8(sp)
    81000de4:	1000                	addi	s0,sp,32
    81000de6:	84aa                	mv	s1,a0
  if(!holding(lk))
    81000de8:	ef7ff0ef          	jal	81000cde <holding>
    81000dec:	c105                	beqz	a0,81000e0c <release+0x30>
  lk->cpu = 0;
    81000dee:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    81000df2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    81000df6:	0310000f          	fence	rw,w
    81000dfa:	0004a023          	sw	zero,0(s1)
  pop_off();
    81000dfe:	f8fff0ef          	jal	81000d8c <pop_off>
}
    81000e02:	60e2                	ld	ra,24(sp)
    81000e04:	6442                	ld	s0,16(sp)
    81000e06:	64a2                	ld	s1,8(sp)
    81000e08:	6105                	addi	sp,sp,32
    81000e0a:	8082                	ret
    panic("release");
    81000e0c:	00006517          	auipc	a0,0x6
    81000e10:	2ec50513          	addi	a0,a0,748 # 810070f8 <etext+0xf8>
    81000e14:	ad1ff0ef          	jal	810008e4 <panic>

0000000081000e18 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    81000e18:	1141                	addi	sp,sp,-16
    81000e1a:	e406                	sd	ra,8(sp)
    81000e1c:	e022                	sd	s0,0(sp)
    81000e1e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    81000e20:	ca19                	beqz	a2,81000e36 <memset+0x1e>
    81000e22:	87aa                	mv	a5,a0
    81000e24:	1602                	slli	a2,a2,0x20
    81000e26:	9201                	srli	a2,a2,0x20
    81000e28:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    81000e2c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    81000e30:	0785                	addi	a5,a5,1
    81000e32:	fee79de3          	bne	a5,a4,81000e2c <memset+0x14>
  }
  return dst;
}
    81000e36:	60a2                	ld	ra,8(sp)
    81000e38:	6402                	ld	s0,0(sp)
    81000e3a:	0141                	addi	sp,sp,16
    81000e3c:	8082                	ret

0000000081000e3e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    81000e3e:	1141                	addi	sp,sp,-16
    81000e40:	e406                	sd	ra,8(sp)
    81000e42:	e022                	sd	s0,0(sp)
    81000e44:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    81000e46:	ca0d                	beqz	a2,81000e78 <memcmp+0x3a>
    81000e48:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x80fff001>
    81000e4c:	1682                	slli	a3,a3,0x20
    81000e4e:	9281                	srli	a3,a3,0x20
    81000e50:	0685                	addi	a3,a3,1
    81000e52:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    81000e54:	00054783          	lbu	a5,0(a0)
    81000e58:	0005c703          	lbu	a4,0(a1)
    81000e5c:	00e79863          	bne	a5,a4,81000e6c <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    81000e60:	0505                	addi	a0,a0,1
    81000e62:	0585                	addi	a1,a1,1
  while(n-- > 0){
    81000e64:	fed518e3          	bne	a0,a3,81000e54 <memcmp+0x16>
  }

  return 0;
    81000e68:	4501                	li	a0,0
    81000e6a:	a019                	j	81000e70 <memcmp+0x32>
      return *s1 - *s2;
    81000e6c:	40e7853b          	subw	a0,a5,a4
}
    81000e70:	60a2                	ld	ra,8(sp)
    81000e72:	6402                	ld	s0,0(sp)
    81000e74:	0141                	addi	sp,sp,16
    81000e76:	8082                	ret
  return 0;
    81000e78:	4501                	li	a0,0
    81000e7a:	bfdd                	j	81000e70 <memcmp+0x32>

0000000081000e7c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    81000e7c:	1141                	addi	sp,sp,-16
    81000e7e:	e406                	sd	ra,8(sp)
    81000e80:	e022                	sd	s0,0(sp)
    81000e82:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    81000e84:	c205                	beqz	a2,81000ea4 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    81000e86:	02a5e363          	bltu	a1,a0,81000eac <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    81000e8a:	1602                	slli	a2,a2,0x20
    81000e8c:	9201                	srli	a2,a2,0x20
    81000e8e:	00c587b3          	add	a5,a1,a2
{
    81000e92:	872a                	mv	a4,a0
      *d++ = *s++;
    81000e94:	0585                	addi	a1,a1,1
    81000e96:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7efde001>
    81000e98:	fff5c683          	lbu	a3,-1(a1)
    81000e9c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    81000ea0:	feb79ae3          	bne	a5,a1,81000e94 <memmove+0x18>

  return dst;
}
    81000ea4:	60a2                	ld	ra,8(sp)
    81000ea6:	6402                	ld	s0,0(sp)
    81000ea8:	0141                	addi	sp,sp,16
    81000eaa:	8082                	ret
  if(s < d && s + n > d){
    81000eac:	02061693          	slli	a3,a2,0x20
    81000eb0:	9281                	srli	a3,a3,0x20
    81000eb2:	00d58733          	add	a4,a1,a3
    81000eb6:	fce57ae3          	bgeu	a0,a4,81000e8a <memmove+0xe>
    d += n;
    81000eba:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    81000ebc:	fff6079b          	addiw	a5,a2,-1
    81000ec0:	1782                	slli	a5,a5,0x20
    81000ec2:	9381                	srli	a5,a5,0x20
    81000ec4:	fff7c793          	not	a5,a5
    81000ec8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    81000eca:	177d                	addi	a4,a4,-1
    81000ecc:	16fd                	addi	a3,a3,-1
    81000ece:	00074603          	lbu	a2,0(a4)
    81000ed2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    81000ed6:	fee79ae3          	bne	a5,a4,81000eca <memmove+0x4e>
    81000eda:	b7e9                	j	81000ea4 <memmove+0x28>

0000000081000edc <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    81000edc:	1141                	addi	sp,sp,-16
    81000ede:	e406                	sd	ra,8(sp)
    81000ee0:	e022                	sd	s0,0(sp)
    81000ee2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    81000ee4:	f99ff0ef          	jal	81000e7c <memmove>
}
    81000ee8:	60a2                	ld	ra,8(sp)
    81000eea:	6402                	ld	s0,0(sp)
    81000eec:	0141                	addi	sp,sp,16
    81000eee:	8082                	ret

0000000081000ef0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    81000ef0:	1141                	addi	sp,sp,-16
    81000ef2:	e406                	sd	ra,8(sp)
    81000ef4:	e022                	sd	s0,0(sp)
    81000ef6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    81000ef8:	ce11                	beqz	a2,81000f14 <strncmp+0x24>
    81000efa:	00054783          	lbu	a5,0(a0)
    81000efe:	cf89                	beqz	a5,81000f18 <strncmp+0x28>
    81000f00:	0005c703          	lbu	a4,0(a1)
    81000f04:	00f71a63          	bne	a4,a5,81000f18 <strncmp+0x28>
    n--, p++, q++;
    81000f08:	367d                	addiw	a2,a2,-1
    81000f0a:	0505                	addi	a0,a0,1
    81000f0c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    81000f0e:	f675                	bnez	a2,81000efa <strncmp+0xa>
  if(n == 0)
    return 0;
    81000f10:	4501                	li	a0,0
    81000f12:	a801                	j	81000f22 <strncmp+0x32>
    81000f14:	4501                	li	a0,0
    81000f16:	a031                	j	81000f22 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    81000f18:	00054503          	lbu	a0,0(a0)
    81000f1c:	0005c783          	lbu	a5,0(a1)
    81000f20:	9d1d                	subw	a0,a0,a5
}
    81000f22:	60a2                	ld	ra,8(sp)
    81000f24:	6402                	ld	s0,0(sp)
    81000f26:	0141                	addi	sp,sp,16
    81000f28:	8082                	ret

0000000081000f2a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    81000f2a:	1141                	addi	sp,sp,-16
    81000f2c:	e406                	sd	ra,8(sp)
    81000f2e:	e022                	sd	s0,0(sp)
    81000f30:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    81000f32:	87aa                	mv	a5,a0
    81000f34:	86b2                	mv	a3,a2
    81000f36:	367d                	addiw	a2,a2,-1
    81000f38:	02d05563          	blez	a3,81000f62 <strncpy+0x38>
    81000f3c:	0785                	addi	a5,a5,1
    81000f3e:	0005c703          	lbu	a4,0(a1)
    81000f42:	fee78fa3          	sb	a4,-1(a5)
    81000f46:	0585                	addi	a1,a1,1
    81000f48:	f775                	bnez	a4,81000f34 <strncpy+0xa>
    ;
  while(n-- > 0)
    81000f4a:	873e                	mv	a4,a5
    81000f4c:	00c05b63          	blez	a2,81000f62 <strncpy+0x38>
    81000f50:	9fb5                	addw	a5,a5,a3
    81000f52:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    81000f54:	0705                	addi	a4,a4,1
    81000f56:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    81000f5a:	40e786bb          	subw	a3,a5,a4
    81000f5e:	fed04be3          	bgtz	a3,81000f54 <strncpy+0x2a>
  return os;
}
    81000f62:	60a2                	ld	ra,8(sp)
    81000f64:	6402                	ld	s0,0(sp)
    81000f66:	0141                	addi	sp,sp,16
    81000f68:	8082                	ret

0000000081000f6a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    81000f6a:	1141                	addi	sp,sp,-16
    81000f6c:	e406                	sd	ra,8(sp)
    81000f6e:	e022                	sd	s0,0(sp)
    81000f70:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    81000f72:	02c05363          	blez	a2,81000f98 <safestrcpy+0x2e>
    81000f76:	fff6069b          	addiw	a3,a2,-1
    81000f7a:	1682                	slli	a3,a3,0x20
    81000f7c:	9281                	srli	a3,a3,0x20
    81000f7e:	96ae                	add	a3,a3,a1
    81000f80:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    81000f82:	00d58963          	beq	a1,a3,81000f94 <safestrcpy+0x2a>
    81000f86:	0585                	addi	a1,a1,1
    81000f88:	0785                	addi	a5,a5,1
    81000f8a:	fff5c703          	lbu	a4,-1(a1)
    81000f8e:	fee78fa3          	sb	a4,-1(a5)
    81000f92:	fb65                	bnez	a4,81000f82 <safestrcpy+0x18>
    ;
  *s = 0;
    81000f94:	00078023          	sb	zero,0(a5)
  return os;
}
    81000f98:	60a2                	ld	ra,8(sp)
    81000f9a:	6402                	ld	s0,0(sp)
    81000f9c:	0141                	addi	sp,sp,16
    81000f9e:	8082                	ret

0000000081000fa0 <strlen>:

int
strlen(const char *s)
{
    81000fa0:	1141                	addi	sp,sp,-16
    81000fa2:	e406                	sd	ra,8(sp)
    81000fa4:	e022                	sd	s0,0(sp)
    81000fa6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    81000fa8:	00054783          	lbu	a5,0(a0)
    81000fac:	cf99                	beqz	a5,81000fca <strlen+0x2a>
    81000fae:	0505                	addi	a0,a0,1
    81000fb0:	87aa                	mv	a5,a0
    81000fb2:	86be                	mv	a3,a5
    81000fb4:	0785                	addi	a5,a5,1
    81000fb6:	fff7c703          	lbu	a4,-1(a5)
    81000fba:	ff65                	bnez	a4,81000fb2 <strlen+0x12>
    81000fbc:	40a6853b          	subw	a0,a3,a0
    81000fc0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    81000fc2:	60a2                	ld	ra,8(sp)
    81000fc4:	6402                	ld	s0,0(sp)
    81000fc6:	0141                	addi	sp,sp,16
    81000fc8:	8082                	ret
  for(n = 0; s[n]; n++)
    81000fca:	4501                	li	a0,0
    81000fcc:	bfdd                	j	81000fc2 <strlen+0x22>

0000000081000fce <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    81000fce:	1141                	addi	sp,sp,-16
    81000fd0:	e406                	sd	ra,8(sp)
    81000fd2:	e022                	sd	s0,0(sp)
    81000fd4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    81000fd6:	22d000ef          	jal	81001a02 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    81000fda:	00007717          	auipc	a4,0x7
    81000fde:	99e70713          	addi	a4,a4,-1634 # 81007978 <started>
  if(cpuid() == 0){
    81000fe2:	c51d                	beqz	a0,81001010 <main+0x42>
    while(started == 0)
    81000fe4:	431c                	lw	a5,0(a4)
    81000fe6:	2781                	sext.w	a5,a5
    81000fe8:	dff5                	beqz	a5,81000fe4 <main+0x16>
      ;
    __sync_synchronize();
    81000fea:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    81000fee:	215000ef          	jal	81001a02 <cpuid>
    81000ff2:	85aa                	mv	a1,a0
    81000ff4:	00006517          	auipc	a0,0x6
    81000ff8:	12c50513          	addi	a0,a0,300 # 81007120 <etext+0x120>
    81000ffc:	e18ff0ef          	jal	81000614 <printf>
    kvminithart();    // turn on paging
    81001000:	08c000ef          	jal	8100108c <kvminithart>
    trapinithart();   // install kernel trap vector
    81001004:	51c010ef          	jal	81002520 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    81001008:	3e0040ef          	jal	810053e8 <plicinithart>
  }

  scheduler();        
    8100100c:	65f000ef          	jal	81001e6a <scheduler>
    printf("xv6 kernel is booting\n");
    81001010:	00006517          	auipc	a0,0x6
    81001014:	0f050513          	addi	a0,a0,240 # 81007100 <etext+0x100>
    81001018:	dfcff0ef          	jal	81000614 <printf>
    consoleinit();
    8100101c:	d2aff0ef          	jal	81000546 <consoleinit>
    printfinit();
    81001020:	8ffff0ef          	jal	8100091e <printfinit>
    printf("\n");
    81001024:	00006517          	auipc	a0,0x6
    81001028:	0f450513          	addi	a0,a0,244 # 81007118 <etext+0x118>
    8100102c:	de8ff0ef          	jal	81000614 <printf>
    printf("xv6 kernel is booting\n");
    81001030:	00006517          	auipc	a0,0x6
    81001034:	0d050513          	addi	a0,a0,208 # 81007100 <etext+0x100>
    81001038:	ddcff0ef          	jal	81000614 <printf>
    printf("\n");
    8100103c:	00006517          	auipc	a0,0x6
    81001040:	0dc50513          	addi	a0,a0,220 # 81007118 <etext+0x118>
    81001044:	dd0ff0ef          	jal	81000614 <printf>
    kinit();         // physical page allocator
    81001048:	bf7ff0ef          	jal	81000c3e <kinit>
    kvminit();       // create kernel page table
    8100104c:	2d2000ef          	jal	8100131e <kvminit>
    kvminithart();   // turn on paging
    81001050:	03c000ef          	jal	8100108c <kvminithart>
    procinit();      // process table
    81001054:	0ff000ef          	jal	81001952 <procinit>
    trapinit();      // trap vectors
    81001058:	4a4010ef          	jal	810024fc <trapinit>
    trapinithart();  // install kernel trap vector
    8100105c:	4c4010ef          	jal	81002520 <trapinithart>
    plicinit();      // set up interrupt controller
    81001060:	36e040ef          	jal	810053ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    81001064:	384040ef          	jal	810053e8 <plicinithart>
    binit();         // buffer cache
    81001068:	2e7010ef          	jal	81002b4e <binit>
    iinit();         // inode table
    8100106c:	0b2020ef          	jal	8100311e <iinit>
    fileinit();      // file table
    81001070:	681020ef          	jal	81003ef0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    81001074:	464040ef          	jal	810054d8 <virtio_disk_init>
    userinit();      // first user process
    81001078:	427000ef          	jal	81001c9e <userinit>
    __sync_synchronize();
    8100107c:	0330000f          	fence	rw,rw
    started = 1;
    81001080:	4785                	li	a5,1
    81001082:	00007717          	auipc	a4,0x7
    81001086:	8ef72b23          	sw	a5,-1802(a4) # 81007978 <started>
    8100108a:	b749                	j	8100100c <main+0x3e>

000000008100108c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8100108c:	1141                	addi	sp,sp,-16
    8100108e:	e406                	sd	ra,8(sp)
    81001090:	e022                	sd	s0,0(sp)
    81001092:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    81001094:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    81001098:	00007797          	auipc	a5,0x7
    8100109c:	8e87b783          	ld	a5,-1816(a5) # 81007980 <kernel_pagetable>
    810010a0:	83b1                	srli	a5,a5,0xc
    810010a2:	577d                	li	a4,-1
    810010a4:	177e                	slli	a4,a4,0x3f
    810010a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    810010a8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    810010ac:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    810010b0:	60a2                	ld	ra,8(sp)
    810010b2:	6402                	ld	s0,0(sp)
    810010b4:	0141                	addi	sp,sp,16
    810010b6:	8082                	ret

00000000810010b8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    810010b8:	7139                	addi	sp,sp,-64
    810010ba:	fc06                	sd	ra,56(sp)
    810010bc:	f822                	sd	s0,48(sp)
    810010be:	f426                	sd	s1,40(sp)
    810010c0:	f04a                	sd	s2,32(sp)
    810010c2:	ec4e                	sd	s3,24(sp)
    810010c4:	e852                	sd	s4,16(sp)
    810010c6:	e456                	sd	s5,8(sp)
    810010c8:	e05a                	sd	s6,0(sp)
    810010ca:	0080                	addi	s0,sp,64
    810010cc:	84aa                	mv	s1,a0
    810010ce:	89ae                	mv	s3,a1
    810010d0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    810010d2:	57fd                	li	a5,-1
    810010d4:	83e9                	srli	a5,a5,0x1a
    810010d6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    810010d8:	4b31                	li	s6,12
  if(va >= MAXVA)
    810010da:	04b7e263          	bltu	a5,a1,8100111e <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    810010de:	0149d933          	srl	s2,s3,s4
    810010e2:	1ff97913          	andi	s2,s2,511
    810010e6:	090e                	slli	s2,s2,0x3
    810010e8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    810010ea:	00093483          	ld	s1,0(s2)
    810010ee:	0014f793          	andi	a5,s1,1
    810010f2:	cf85                	beqz	a5,8100112a <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    810010f4:	80a9                	srli	s1,s1,0xa
    810010f6:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    810010f8:	3a5d                	addiw	s4,s4,-9
    810010fa:	ff6a12e3          	bne	s4,s6,810010de <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    810010fe:	00c9d513          	srli	a0,s3,0xc
    81001102:	1ff57513          	andi	a0,a0,511
    81001106:	050e                	slli	a0,a0,0x3
    81001108:	9526                	add	a0,a0,s1
}
    8100110a:	70e2                	ld	ra,56(sp)
    8100110c:	7442                	ld	s0,48(sp)
    8100110e:	74a2                	ld	s1,40(sp)
    81001110:	7902                	ld	s2,32(sp)
    81001112:	69e2                	ld	s3,24(sp)
    81001114:	6a42                	ld	s4,16(sp)
    81001116:	6aa2                	ld	s5,8(sp)
    81001118:	6b02                	ld	s6,0(sp)
    8100111a:	6121                	addi	sp,sp,64
    8100111c:	8082                	ret
    panic("walk");
    8100111e:	00006517          	auipc	a0,0x6
    81001122:	01a50513          	addi	a0,a0,26 # 81007138 <etext+0x138>
    81001126:	fbeff0ef          	jal	810008e4 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8100112a:	020a8263          	beqz	s5,8100114e <walk+0x96>
    8100112e:	b47ff0ef          	jal	81000c74 <kalloc>
    81001132:	84aa                	mv	s1,a0
    81001134:	d979                	beqz	a0,8100110a <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    81001136:	6605                	lui	a2,0x1
    81001138:	4581                	li	a1,0
    8100113a:	cdfff0ef          	jal	81000e18 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8100113e:	00c4d793          	srli	a5,s1,0xc
    81001142:	07aa                	slli	a5,a5,0xa
    81001144:	0017e793          	ori	a5,a5,1
    81001148:	00f93023          	sd	a5,0(s2)
    8100114c:	b775                	j	810010f8 <walk+0x40>
        return 0;
    8100114e:	4501                	li	a0,0
    81001150:	bf6d                	j	8100110a <walk+0x52>

0000000081001152 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    81001152:	57fd                	li	a5,-1
    81001154:	83e9                	srli	a5,a5,0x1a
    81001156:	00b7f463          	bgeu	a5,a1,8100115e <walkaddr+0xc>
    return 0;
    8100115a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8100115c:	8082                	ret
{
    8100115e:	1141                	addi	sp,sp,-16
    81001160:	e406                	sd	ra,8(sp)
    81001162:	e022                	sd	s0,0(sp)
    81001164:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    81001166:	4601                	li	a2,0
    81001168:	f51ff0ef          	jal	810010b8 <walk>
  if(pte == 0)
    8100116c:	c105                	beqz	a0,8100118c <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8100116e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    81001170:	0117f693          	andi	a3,a5,17
    81001174:	4745                	li	a4,17
    return 0;
    81001176:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    81001178:	00e68663          	beq	a3,a4,81001184 <walkaddr+0x32>
}
    8100117c:	60a2                	ld	ra,8(sp)
    8100117e:	6402                	ld	s0,0(sp)
    81001180:	0141                	addi	sp,sp,16
    81001182:	8082                	ret
  pa = PTE2PA(*pte);
    81001184:	83a9                	srli	a5,a5,0xa
    81001186:	00c79513          	slli	a0,a5,0xc
  return pa;
    8100118a:	bfcd                	j	8100117c <walkaddr+0x2a>
    return 0;
    8100118c:	4501                	li	a0,0
    8100118e:	b7fd                	j	8100117c <walkaddr+0x2a>

0000000081001190 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    81001190:	715d                	addi	sp,sp,-80
    81001192:	e486                	sd	ra,72(sp)
    81001194:	e0a2                	sd	s0,64(sp)
    81001196:	fc26                	sd	s1,56(sp)
    81001198:	f84a                	sd	s2,48(sp)
    8100119a:	f44e                	sd	s3,40(sp)
    8100119c:	f052                	sd	s4,32(sp)
    8100119e:	ec56                	sd	s5,24(sp)
    810011a0:	e85a                	sd	s6,16(sp)
    810011a2:	e45e                	sd	s7,8(sp)
    810011a4:	e062                	sd	s8,0(sp)
    810011a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    810011a8:	03459793          	slli	a5,a1,0x34
    810011ac:	e7b1                	bnez	a5,810011f8 <mappages+0x68>
    810011ae:	8aaa                	mv	s5,a0
    810011b0:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    810011b2:	03461793          	slli	a5,a2,0x34
    810011b6:	e7b9                	bnez	a5,81001204 <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    810011b8:	ce21                	beqz	a2,81001210 <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    810011ba:	77fd                	lui	a5,0xfffff
    810011bc:	963e                	add	a2,a2,a5
    810011be:	00b609b3          	add	s3,a2,a1
  a = va;
    810011c2:	892e                	mv	s2,a1
    810011c4:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    810011c8:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    810011ca:	6c05                	lui	s8,0x1
    810011cc:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    810011d0:	865e                	mv	a2,s7
    810011d2:	85ca                	mv	a1,s2
    810011d4:	8556                	mv	a0,s5
    810011d6:	ee3ff0ef          	jal	810010b8 <walk>
    810011da:	c539                	beqz	a0,81001228 <mappages+0x98>
    if(*pte & PTE_V)
    810011dc:	611c                	ld	a5,0(a0)
    810011de:	8b85                	andi	a5,a5,1
    810011e0:	ef95                	bnez	a5,8100121c <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    810011e2:	80b1                	srli	s1,s1,0xc
    810011e4:	04aa                	slli	s1,s1,0xa
    810011e6:	0164e4b3          	or	s1,s1,s6
    810011ea:	0014e493          	ori	s1,s1,1
    810011ee:	e104                	sd	s1,0(a0)
    if(a == last)
    810011f0:	05390963          	beq	s2,s3,81001242 <mappages+0xb2>
    a += PGSIZE;
    810011f4:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    810011f6:	bfd9                	j	810011cc <mappages+0x3c>
    panic("mappages: va not aligned");
    810011f8:	00006517          	auipc	a0,0x6
    810011fc:	f4850513          	addi	a0,a0,-184 # 81007140 <etext+0x140>
    81001200:	ee4ff0ef          	jal	810008e4 <panic>
    panic("mappages: size not aligned");
    81001204:	00006517          	auipc	a0,0x6
    81001208:	f5c50513          	addi	a0,a0,-164 # 81007160 <etext+0x160>
    8100120c:	ed8ff0ef          	jal	810008e4 <panic>
    panic("mappages: size");
    81001210:	00006517          	auipc	a0,0x6
    81001214:	f7050513          	addi	a0,a0,-144 # 81007180 <etext+0x180>
    81001218:	eccff0ef          	jal	810008e4 <panic>
      panic("mappages: remap");
    8100121c:	00006517          	auipc	a0,0x6
    81001220:	f7450513          	addi	a0,a0,-140 # 81007190 <etext+0x190>
    81001224:	ec0ff0ef          	jal	810008e4 <panic>
      return -1;
    81001228:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8100122a:	60a6                	ld	ra,72(sp)
    8100122c:	6406                	ld	s0,64(sp)
    8100122e:	74e2                	ld	s1,56(sp)
    81001230:	7942                	ld	s2,48(sp)
    81001232:	79a2                	ld	s3,40(sp)
    81001234:	7a02                	ld	s4,32(sp)
    81001236:	6ae2                	ld	s5,24(sp)
    81001238:	6b42                	ld	s6,16(sp)
    8100123a:	6ba2                	ld	s7,8(sp)
    8100123c:	6c02                	ld	s8,0(sp)
    8100123e:	6161                	addi	sp,sp,80
    81001240:	8082                	ret
  return 0;
    81001242:	4501                	li	a0,0
    81001244:	b7dd                	j	8100122a <mappages+0x9a>

0000000081001246 <kvmmap>:
{
    81001246:	1141                	addi	sp,sp,-16
    81001248:	e406                	sd	ra,8(sp)
    8100124a:	e022                	sd	s0,0(sp)
    8100124c:	0800                	addi	s0,sp,16
    8100124e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    81001250:	86b2                	mv	a3,a2
    81001252:	863e                	mv	a2,a5
    81001254:	f3dff0ef          	jal	81001190 <mappages>
    81001258:	e509                	bnez	a0,81001262 <kvmmap+0x1c>
}
    8100125a:	60a2                	ld	ra,8(sp)
    8100125c:	6402                	ld	s0,0(sp)
    8100125e:	0141                	addi	sp,sp,16
    81001260:	8082                	ret
    panic("kvmmap");
    81001262:	00006517          	auipc	a0,0x6
    81001266:	f3e50513          	addi	a0,a0,-194 # 810071a0 <etext+0x1a0>
    8100126a:	e7aff0ef          	jal	810008e4 <panic>

000000008100126e <kvmmake>:
{
    8100126e:	1101                	addi	sp,sp,-32
    81001270:	ec06                	sd	ra,24(sp)
    81001272:	e822                	sd	s0,16(sp)
    81001274:	e426                	sd	s1,8(sp)
    81001276:	e04a                	sd	s2,0(sp)
    81001278:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8100127a:	9fbff0ef          	jal	81000c74 <kalloc>
    8100127e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    81001280:	6605                	lui	a2,0x1
    81001282:	4581                	li	a1,0
    81001284:	b95ff0ef          	jal	81000e18 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    81001288:	4719                	li	a4,6
    8100128a:	6685                	lui	a3,0x1
    8100128c:	10000637          	lui	a2,0x10000
    81001290:	85b2                	mv	a1,a2
    81001292:	8526                	mv	a0,s1
    81001294:	fb3ff0ef          	jal	81001246 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    81001298:	4719                	li	a4,6
    8100129a:	6685                	lui	a3,0x1
    8100129c:	10001637          	lui	a2,0x10001
    810012a0:	85b2                	mv	a1,a2
    810012a2:	8526                	mv	a0,s1
    810012a4:	fa3ff0ef          	jal	81001246 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    810012a8:	4719                	li	a4,6
    810012aa:	040006b7          	lui	a3,0x4000
    810012ae:	0c000637          	lui	a2,0xc000
    810012b2:	85b2                	mv	a1,a2
    810012b4:	8526                	mv	a0,s1
    810012b6:	f91ff0ef          	jal	81001246 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    810012ba:	00006917          	auipc	s2,0x6
    810012be:	d4690913          	addi	s2,s2,-698 # 81007000 <etext>
    810012c2:	4729                	li	a4,10
    810012c4:	f7f00693          	li	a3,-129
    810012c8:	06e2                	slli	a3,a3,0x18
    810012ca:	96ca                	add	a3,a3,s2
    810012cc:	08100613          	li	a2,129
    810012d0:	0662                	slli	a2,a2,0x18
    810012d2:	85b2                	mv	a1,a2
    810012d4:	8526                	mv	a0,s1
    810012d6:	f71ff0ef          	jal	81001246 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    810012da:	4719                	li	a4,6
    810012dc:	08900693          	li	a3,137
    810012e0:	06e2                	slli	a3,a3,0x18
    810012e2:	412686b3          	sub	a3,a3,s2
    810012e6:	864a                	mv	a2,s2
    810012e8:	85ca                	mv	a1,s2
    810012ea:	8526                	mv	a0,s1
    810012ec:	f5bff0ef          	jal	81001246 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    810012f0:	4729                	li	a4,10
    810012f2:	6685                	lui	a3,0x1
    810012f4:	00005617          	auipc	a2,0x5
    810012f8:	d0c60613          	addi	a2,a2,-756 # 81006000 <_trampoline>
    810012fc:	040005b7          	lui	a1,0x4000
    81001300:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7d000001>
    81001302:	05b2                	slli	a1,a1,0xc
    81001304:	8526                	mv	a0,s1
    81001306:	f41ff0ef          	jal	81001246 <kvmmap>
  proc_mapstacks(kpgtbl);
    8100130a:	8526                	mv	a0,s1
    8100130c:	5a8000ef          	jal	810018b4 <proc_mapstacks>
}
    81001310:	8526                	mv	a0,s1
    81001312:	60e2                	ld	ra,24(sp)
    81001314:	6442                	ld	s0,16(sp)
    81001316:	64a2                	ld	s1,8(sp)
    81001318:	6902                	ld	s2,0(sp)
    8100131a:	6105                	addi	sp,sp,32
    8100131c:	8082                	ret

000000008100131e <kvminit>:
{
    8100131e:	1141                	addi	sp,sp,-16
    81001320:	e406                	sd	ra,8(sp)
    81001322:	e022                	sd	s0,0(sp)
    81001324:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    81001326:	f49ff0ef          	jal	8100126e <kvmmake>
    8100132a:	00006797          	auipc	a5,0x6
    8100132e:	64a7bb23          	sd	a0,1622(a5) # 81007980 <kernel_pagetable>
}
    81001332:	60a2                	ld	ra,8(sp)
    81001334:	6402                	ld	s0,0(sp)
    81001336:	0141                	addi	sp,sp,16
    81001338:	8082                	ret

000000008100133a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8100133a:	715d                	addi	sp,sp,-80
    8100133c:	e486                	sd	ra,72(sp)
    8100133e:	e0a2                	sd	s0,64(sp)
    81001340:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    81001342:	03459793          	slli	a5,a1,0x34
    81001346:	e39d                	bnez	a5,8100136c <uvmunmap+0x32>
    81001348:	f84a                	sd	s2,48(sp)
    8100134a:	f44e                	sd	s3,40(sp)
    8100134c:	f052                	sd	s4,32(sp)
    8100134e:	ec56                	sd	s5,24(sp)
    81001350:	e85a                	sd	s6,16(sp)
    81001352:	e45e                	sd	s7,8(sp)
    81001354:	8a2a                	mv	s4,a0
    81001356:	892e                	mv	s2,a1
    81001358:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8100135a:	0632                	slli	a2,a2,0xc
    8100135c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    81001360:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    81001362:	6b05                	lui	s6,0x1
    81001364:	0735ff63          	bgeu	a1,s3,810013e2 <uvmunmap+0xa8>
    81001368:	fc26                	sd	s1,56(sp)
    8100136a:	a0a9                	j	810013b4 <uvmunmap+0x7a>
    8100136c:	fc26                	sd	s1,56(sp)
    8100136e:	f84a                	sd	s2,48(sp)
    81001370:	f44e                	sd	s3,40(sp)
    81001372:	f052                	sd	s4,32(sp)
    81001374:	ec56                	sd	s5,24(sp)
    81001376:	e85a                	sd	s6,16(sp)
    81001378:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8100137a:	00006517          	auipc	a0,0x6
    8100137e:	e2e50513          	addi	a0,a0,-466 # 810071a8 <etext+0x1a8>
    81001382:	d62ff0ef          	jal	810008e4 <panic>
      panic("uvmunmap: walk");
    81001386:	00006517          	auipc	a0,0x6
    8100138a:	e3a50513          	addi	a0,a0,-454 # 810071c0 <etext+0x1c0>
    8100138e:	d56ff0ef          	jal	810008e4 <panic>
      panic("uvmunmap: not mapped");
    81001392:	00006517          	auipc	a0,0x6
    81001396:	e3e50513          	addi	a0,a0,-450 # 810071d0 <etext+0x1d0>
    8100139a:	d4aff0ef          	jal	810008e4 <panic>
      panic("uvmunmap: not a leaf");
    8100139e:	00006517          	auipc	a0,0x6
    810013a2:	e4a50513          	addi	a0,a0,-438 # 810071e8 <etext+0x1e8>
    810013a6:	d3eff0ef          	jal	810008e4 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    810013aa:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    810013ae:	995a                	add	s2,s2,s6
    810013b0:	03397863          	bgeu	s2,s3,810013e0 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    810013b4:	4601                	li	a2,0
    810013b6:	85ca                	mv	a1,s2
    810013b8:	8552                	mv	a0,s4
    810013ba:	cffff0ef          	jal	810010b8 <walk>
    810013be:	84aa                	mv	s1,a0
    810013c0:	d179                	beqz	a0,81001386 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    810013c2:	6108                	ld	a0,0(a0)
    810013c4:	00157793          	andi	a5,a0,1
    810013c8:	d7e9                	beqz	a5,81001392 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    810013ca:	3ff57793          	andi	a5,a0,1023
    810013ce:	fd7788e3          	beq	a5,s7,8100139e <uvmunmap+0x64>
    if(do_free){
    810013d2:	fc0a8ce3          	beqz	s5,810013aa <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    810013d6:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    810013d8:	0532                	slli	a0,a0,0xc
    810013da:	fb4ff0ef          	jal	81000b8e <kfree>
    810013de:	b7f1                	j	810013aa <uvmunmap+0x70>
    810013e0:	74e2                	ld	s1,56(sp)
    810013e2:	7942                	ld	s2,48(sp)
    810013e4:	79a2                	ld	s3,40(sp)
    810013e6:	7a02                	ld	s4,32(sp)
    810013e8:	6ae2                	ld	s5,24(sp)
    810013ea:	6b42                	ld	s6,16(sp)
    810013ec:	6ba2                	ld	s7,8(sp)
  }
}
    810013ee:	60a6                	ld	ra,72(sp)
    810013f0:	6406                	ld	s0,64(sp)
    810013f2:	6161                	addi	sp,sp,80
    810013f4:	8082                	ret

00000000810013f6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    810013f6:	1101                	addi	sp,sp,-32
    810013f8:	ec06                	sd	ra,24(sp)
    810013fa:	e822                	sd	s0,16(sp)
    810013fc:	e426                	sd	s1,8(sp)
    810013fe:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    81001400:	875ff0ef          	jal	81000c74 <kalloc>
    81001404:	84aa                	mv	s1,a0
  if(pagetable == 0)
    81001406:	c509                	beqz	a0,81001410 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    81001408:	6605                	lui	a2,0x1
    8100140a:	4581                	li	a1,0
    8100140c:	a0dff0ef          	jal	81000e18 <memset>
  return pagetable;
}
    81001410:	8526                	mv	a0,s1
    81001412:	60e2                	ld	ra,24(sp)
    81001414:	6442                	ld	s0,16(sp)
    81001416:	64a2                	ld	s1,8(sp)
    81001418:	6105                	addi	sp,sp,32
    8100141a:	8082                	ret

000000008100141c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8100141c:	7179                	addi	sp,sp,-48
    8100141e:	f406                	sd	ra,40(sp)
    81001420:	f022                	sd	s0,32(sp)
    81001422:	ec26                	sd	s1,24(sp)
    81001424:	e84a                	sd	s2,16(sp)
    81001426:	e44e                	sd	s3,8(sp)
    81001428:	e052                	sd	s4,0(sp)
    8100142a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8100142c:	6785                	lui	a5,0x1
    8100142e:	04f67063          	bgeu	a2,a5,8100146e <uvmfirst+0x52>
    81001432:	8a2a                	mv	s4,a0
    81001434:	89ae                	mv	s3,a1
    81001436:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    81001438:	83dff0ef          	jal	81000c74 <kalloc>
    8100143c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8100143e:	6605                	lui	a2,0x1
    81001440:	4581                	li	a1,0
    81001442:	9d7ff0ef          	jal	81000e18 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    81001446:	4779                	li	a4,30
    81001448:	86ca                	mv	a3,s2
    8100144a:	6605                	lui	a2,0x1
    8100144c:	4581                	li	a1,0
    8100144e:	8552                	mv	a0,s4
    81001450:	d41ff0ef          	jal	81001190 <mappages>
  memmove(mem, src, sz);
    81001454:	8626                	mv	a2,s1
    81001456:	85ce                	mv	a1,s3
    81001458:	854a                	mv	a0,s2
    8100145a:	a23ff0ef          	jal	81000e7c <memmove>
}
    8100145e:	70a2                	ld	ra,40(sp)
    81001460:	7402                	ld	s0,32(sp)
    81001462:	64e2                	ld	s1,24(sp)
    81001464:	6942                	ld	s2,16(sp)
    81001466:	69a2                	ld	s3,8(sp)
    81001468:	6a02                	ld	s4,0(sp)
    8100146a:	6145                	addi	sp,sp,48
    8100146c:	8082                	ret
    panic("uvmfirst: more than a page");
    8100146e:	00006517          	auipc	a0,0x6
    81001472:	d9250513          	addi	a0,a0,-622 # 81007200 <etext+0x200>
    81001476:	c6eff0ef          	jal	810008e4 <panic>

000000008100147a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8100147a:	1101                	addi	sp,sp,-32
    8100147c:	ec06                	sd	ra,24(sp)
    8100147e:	e822                	sd	s0,16(sp)
    81001480:	e426                	sd	s1,8(sp)
    81001482:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    81001484:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    81001486:	00b67d63          	bgeu	a2,a1,810014a0 <uvmdealloc+0x26>
    8100148a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8100148c:	6785                	lui	a5,0x1
    8100148e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x80fff001>
    81001490:	00f60733          	add	a4,a2,a5
    81001494:	76fd                	lui	a3,0xfffff
    81001496:	8f75                	and	a4,a4,a3
    81001498:	97ae                	add	a5,a5,a1
    8100149a:	8ff5                	and	a5,a5,a3
    8100149c:	00f76863          	bltu	a4,a5,810014ac <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    810014a0:	8526                	mv	a0,s1
    810014a2:	60e2                	ld	ra,24(sp)
    810014a4:	6442                	ld	s0,16(sp)
    810014a6:	64a2                	ld	s1,8(sp)
    810014a8:	6105                	addi	sp,sp,32
    810014aa:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    810014ac:	8f99                	sub	a5,a5,a4
    810014ae:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    810014b0:	4685                	li	a3,1
    810014b2:	0007861b          	sext.w	a2,a5
    810014b6:	85ba                	mv	a1,a4
    810014b8:	e83ff0ef          	jal	8100133a <uvmunmap>
    810014bc:	b7d5                	j	810014a0 <uvmdealloc+0x26>

00000000810014be <uvmalloc>:
  if(newsz < oldsz)
    810014be:	0ab66363          	bltu	a2,a1,81001564 <uvmalloc+0xa6>
{
    810014c2:	715d                	addi	sp,sp,-80
    810014c4:	e486                	sd	ra,72(sp)
    810014c6:	e0a2                	sd	s0,64(sp)
    810014c8:	f052                	sd	s4,32(sp)
    810014ca:	ec56                	sd	s5,24(sp)
    810014cc:	e85a                	sd	s6,16(sp)
    810014ce:	0880                	addi	s0,sp,80
    810014d0:	8b2a                	mv	s6,a0
    810014d2:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    810014d4:	6785                	lui	a5,0x1
    810014d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x80fff001>
    810014d8:	95be                	add	a1,a1,a5
    810014da:	77fd                	lui	a5,0xfffff
    810014dc:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    810014e0:	08ca7463          	bgeu	s4,a2,81001568 <uvmalloc+0xaa>
    810014e4:	fc26                	sd	s1,56(sp)
    810014e6:	f84a                	sd	s2,48(sp)
    810014e8:	f44e                	sd	s3,40(sp)
    810014ea:	e45e                	sd	s7,8(sp)
    810014ec:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    810014ee:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    810014f0:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    810014f4:	f80ff0ef          	jal	81000c74 <kalloc>
    810014f8:	84aa                	mv	s1,a0
    if(mem == 0){
    810014fa:	c515                	beqz	a0,81001526 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    810014fc:	864e                	mv	a2,s3
    810014fe:	4581                	li	a1,0
    81001500:	919ff0ef          	jal	81000e18 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    81001504:	875e                	mv	a4,s7
    81001506:	86a6                	mv	a3,s1
    81001508:	864e                	mv	a2,s3
    8100150a:	85ca                	mv	a1,s2
    8100150c:	855a                	mv	a0,s6
    8100150e:	c83ff0ef          	jal	81001190 <mappages>
    81001512:	e91d                	bnez	a0,81001548 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    81001514:	994e                	add	s2,s2,s3
    81001516:	fd596fe3          	bltu	s2,s5,810014f4 <uvmalloc+0x36>
  return newsz;
    8100151a:	8556                	mv	a0,s5
    8100151c:	74e2                	ld	s1,56(sp)
    8100151e:	7942                	ld	s2,48(sp)
    81001520:	79a2                	ld	s3,40(sp)
    81001522:	6ba2                	ld	s7,8(sp)
    81001524:	a819                	j	8100153a <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    81001526:	8652                	mv	a2,s4
    81001528:	85ca                	mv	a1,s2
    8100152a:	855a                	mv	a0,s6
    8100152c:	f4fff0ef          	jal	8100147a <uvmdealloc>
      return 0;
    81001530:	4501                	li	a0,0
    81001532:	74e2                	ld	s1,56(sp)
    81001534:	7942                	ld	s2,48(sp)
    81001536:	79a2                	ld	s3,40(sp)
    81001538:	6ba2                	ld	s7,8(sp)
}
    8100153a:	60a6                	ld	ra,72(sp)
    8100153c:	6406                	ld	s0,64(sp)
    8100153e:	7a02                	ld	s4,32(sp)
    81001540:	6ae2                	ld	s5,24(sp)
    81001542:	6b42                	ld	s6,16(sp)
    81001544:	6161                	addi	sp,sp,80
    81001546:	8082                	ret
      kfree(mem);
    81001548:	8526                	mv	a0,s1
    8100154a:	e44ff0ef          	jal	81000b8e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8100154e:	8652                	mv	a2,s4
    81001550:	85ca                	mv	a1,s2
    81001552:	855a                	mv	a0,s6
    81001554:	f27ff0ef          	jal	8100147a <uvmdealloc>
      return 0;
    81001558:	4501                	li	a0,0
    8100155a:	74e2                	ld	s1,56(sp)
    8100155c:	7942                	ld	s2,48(sp)
    8100155e:	79a2                	ld	s3,40(sp)
    81001560:	6ba2                	ld	s7,8(sp)
    81001562:	bfe1                	j	8100153a <uvmalloc+0x7c>
    return oldsz;
    81001564:	852e                	mv	a0,a1
}
    81001566:	8082                	ret
  return newsz;
    81001568:	8532                	mv	a0,a2
    8100156a:	bfc1                	j	8100153a <uvmalloc+0x7c>

000000008100156c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8100156c:	7179                	addi	sp,sp,-48
    8100156e:	f406                	sd	ra,40(sp)
    81001570:	f022                	sd	s0,32(sp)
    81001572:	ec26                	sd	s1,24(sp)
    81001574:	e84a                	sd	s2,16(sp)
    81001576:	e44e                	sd	s3,8(sp)
    81001578:	e052                	sd	s4,0(sp)
    8100157a:	1800                	addi	s0,sp,48
    8100157c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8100157e:	84aa                	mv	s1,a0
    81001580:	6905                	lui	s2,0x1
    81001582:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    81001584:	4985                	li	s3,1
    81001586:	a819                	j	8100159c <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    81001588:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8100158a:	00c79513          	slli	a0,a5,0xc
    8100158e:	fdfff0ef          	jal	8100156c <freewalk>
      pagetable[i] = 0;
    81001592:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    81001596:	04a1                	addi	s1,s1,8
    81001598:	01248f63          	beq	s1,s2,810015b6 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8100159c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8100159e:	00f7f713          	andi	a4,a5,15
    810015a2:	ff3703e3          	beq	a4,s3,81001588 <freewalk+0x1c>
    } else if(pte & PTE_V){
    810015a6:	8b85                	andi	a5,a5,1
    810015a8:	d7fd                	beqz	a5,81001596 <freewalk+0x2a>
      panic("freewalk: leaf");
    810015aa:	00006517          	auipc	a0,0x6
    810015ae:	c7650513          	addi	a0,a0,-906 # 81007220 <etext+0x220>
    810015b2:	b32ff0ef          	jal	810008e4 <panic>
    }
  }
  kfree((void*)pagetable);
    810015b6:	8552                	mv	a0,s4
    810015b8:	dd6ff0ef          	jal	81000b8e <kfree>
}
    810015bc:	70a2                	ld	ra,40(sp)
    810015be:	7402                	ld	s0,32(sp)
    810015c0:	64e2                	ld	s1,24(sp)
    810015c2:	6942                	ld	s2,16(sp)
    810015c4:	69a2                	ld	s3,8(sp)
    810015c6:	6a02                	ld	s4,0(sp)
    810015c8:	6145                	addi	sp,sp,48
    810015ca:	8082                	ret

00000000810015cc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    810015cc:	1101                	addi	sp,sp,-32
    810015ce:	ec06                	sd	ra,24(sp)
    810015d0:	e822                	sd	s0,16(sp)
    810015d2:	e426                	sd	s1,8(sp)
    810015d4:	1000                	addi	s0,sp,32
    810015d6:	84aa                	mv	s1,a0
  if(sz > 0)
    810015d8:	e989                	bnez	a1,810015ea <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    810015da:	8526                	mv	a0,s1
    810015dc:	f91ff0ef          	jal	8100156c <freewalk>
}
    810015e0:	60e2                	ld	ra,24(sp)
    810015e2:	6442                	ld	s0,16(sp)
    810015e4:	64a2                	ld	s1,8(sp)
    810015e6:	6105                	addi	sp,sp,32
    810015e8:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    810015ea:	6785                	lui	a5,0x1
    810015ec:	17fd                	addi	a5,a5,-1 # fff <_entry-0x80fff001>
    810015ee:	95be                	add	a1,a1,a5
    810015f0:	4685                	li	a3,1
    810015f2:	00c5d613          	srli	a2,a1,0xc
    810015f6:	4581                	li	a1,0
    810015f8:	d43ff0ef          	jal	8100133a <uvmunmap>
    810015fc:	bff9                	j	810015da <uvmfree+0xe>

00000000810015fe <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    810015fe:	ca4d                	beqz	a2,810016b0 <uvmcopy+0xb2>
{
    81001600:	715d                	addi	sp,sp,-80
    81001602:	e486                	sd	ra,72(sp)
    81001604:	e0a2                	sd	s0,64(sp)
    81001606:	fc26                	sd	s1,56(sp)
    81001608:	f84a                	sd	s2,48(sp)
    8100160a:	f44e                	sd	s3,40(sp)
    8100160c:	f052                	sd	s4,32(sp)
    8100160e:	ec56                	sd	s5,24(sp)
    81001610:	e85a                	sd	s6,16(sp)
    81001612:	e45e                	sd	s7,8(sp)
    81001614:	e062                	sd	s8,0(sp)
    81001616:	0880                	addi	s0,sp,80
    81001618:	8baa                	mv	s7,a0
    8100161a:	8b2e                	mv	s6,a1
    8100161c:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    8100161e:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    81001620:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    81001622:	4601                	li	a2,0
    81001624:	85ce                	mv	a1,s3
    81001626:	855e                	mv	a0,s7
    81001628:	a91ff0ef          	jal	810010b8 <walk>
    8100162c:	cd1d                	beqz	a0,8100166a <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    8100162e:	6118                	ld	a4,0(a0)
    81001630:	00177793          	andi	a5,a4,1
    81001634:	c3a9                	beqz	a5,81001676 <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    81001636:	00a75593          	srli	a1,a4,0xa
    8100163a:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    8100163e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    81001642:	e32ff0ef          	jal	81000c74 <kalloc>
    81001646:	892a                	mv	s2,a0
    81001648:	c121                	beqz	a0,81001688 <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    8100164a:	8652                	mv	a2,s4
    8100164c:	85e2                	mv	a1,s8
    8100164e:	82fff0ef          	jal	81000e7c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    81001652:	8726                	mv	a4,s1
    81001654:	86ca                	mv	a3,s2
    81001656:	8652                	mv	a2,s4
    81001658:	85ce                	mv	a1,s3
    8100165a:	855a                	mv	a0,s6
    8100165c:	b35ff0ef          	jal	81001190 <mappages>
    81001660:	e10d                	bnez	a0,81001682 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    81001662:	99d2                	add	s3,s3,s4
    81001664:	fb59efe3          	bltu	s3,s5,81001622 <uvmcopy+0x24>
    81001668:	a805                	j	81001698 <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    8100166a:	00006517          	auipc	a0,0x6
    8100166e:	bc650513          	addi	a0,a0,-1082 # 81007230 <etext+0x230>
    81001672:	a72ff0ef          	jal	810008e4 <panic>
      panic("uvmcopy: page not present");
    81001676:	00006517          	auipc	a0,0x6
    8100167a:	bda50513          	addi	a0,a0,-1062 # 81007250 <etext+0x250>
    8100167e:	a66ff0ef          	jal	810008e4 <panic>
      kfree(mem);
    81001682:	854a                	mv	a0,s2
    81001684:	d0aff0ef          	jal	81000b8e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    81001688:	4685                	li	a3,1
    8100168a:	00c9d613          	srli	a2,s3,0xc
    8100168e:	4581                	li	a1,0
    81001690:	855a                	mv	a0,s6
    81001692:	ca9ff0ef          	jal	8100133a <uvmunmap>
  return -1;
    81001696:	557d                	li	a0,-1
}
    81001698:	60a6                	ld	ra,72(sp)
    8100169a:	6406                	ld	s0,64(sp)
    8100169c:	74e2                	ld	s1,56(sp)
    8100169e:	7942                	ld	s2,48(sp)
    810016a0:	79a2                	ld	s3,40(sp)
    810016a2:	7a02                	ld	s4,32(sp)
    810016a4:	6ae2                	ld	s5,24(sp)
    810016a6:	6b42                	ld	s6,16(sp)
    810016a8:	6ba2                	ld	s7,8(sp)
    810016aa:	6c02                	ld	s8,0(sp)
    810016ac:	6161                	addi	sp,sp,80
    810016ae:	8082                	ret
  return 0;
    810016b0:	4501                	li	a0,0
}
    810016b2:	8082                	ret

00000000810016b4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    810016b4:	1141                	addi	sp,sp,-16
    810016b6:	e406                	sd	ra,8(sp)
    810016b8:	e022                	sd	s0,0(sp)
    810016ba:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    810016bc:	4601                	li	a2,0
    810016be:	9fbff0ef          	jal	810010b8 <walk>
  if(pte == 0)
    810016c2:	c901                	beqz	a0,810016d2 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    810016c4:	611c                	ld	a5,0(a0)
    810016c6:	9bbd                	andi	a5,a5,-17
    810016c8:	e11c                	sd	a5,0(a0)
}
    810016ca:	60a2                	ld	ra,8(sp)
    810016cc:	6402                	ld	s0,0(sp)
    810016ce:	0141                	addi	sp,sp,16
    810016d0:	8082                	ret
    panic("uvmclear");
    810016d2:	00006517          	auipc	a0,0x6
    810016d6:	b9e50513          	addi	a0,a0,-1122 # 81007270 <etext+0x270>
    810016da:	a0aff0ef          	jal	810008e4 <panic>

00000000810016de <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    810016de:	c2d9                	beqz	a3,81001764 <copyout+0x86>
{
    810016e0:	711d                	addi	sp,sp,-96
    810016e2:	ec86                	sd	ra,88(sp)
    810016e4:	e8a2                	sd	s0,80(sp)
    810016e6:	e4a6                	sd	s1,72(sp)
    810016e8:	e0ca                	sd	s2,64(sp)
    810016ea:	fc4e                	sd	s3,56(sp)
    810016ec:	f852                	sd	s4,48(sp)
    810016ee:	f456                	sd	s5,40(sp)
    810016f0:	f05a                	sd	s6,32(sp)
    810016f2:	ec5e                	sd	s7,24(sp)
    810016f4:	e862                	sd	s8,16(sp)
    810016f6:	e466                	sd	s9,8(sp)
    810016f8:	e06a                	sd	s10,0(sp)
    810016fa:	1080                	addi	s0,sp,96
    810016fc:	8c2a                	mv	s8,a0
    810016fe:	892e                	mv	s2,a1
    81001700:	8ab2                	mv	s5,a2
    81001702:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    81001704:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    81001706:	5bfd                	li	s7,-1
    81001708:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    8100170c:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    8100170e:	6b05                	lui	s6,0x1
    81001710:	a015                	j	81001734 <copyout+0x56>
    pa0 = PTE2PA(*pte);
    81001712:	83a9                	srli	a5,a5,0xa
    81001714:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    81001716:	41390533          	sub	a0,s2,s3
    8100171a:	0004861b          	sext.w	a2,s1
    8100171e:	85d6                	mv	a1,s5
    81001720:	953e                	add	a0,a0,a5
    81001722:	f5aff0ef          	jal	81000e7c <memmove>

    len -= n;
    81001726:	409a0a33          	sub	s4,s4,s1
    src += n;
    8100172a:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    8100172c:	01698933          	add	s2,s3,s6
  while(len > 0){
    81001730:	020a0863          	beqz	s4,81001760 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    81001734:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    81001738:	033be863          	bltu	s7,s3,81001768 <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    8100173c:	4601                	li	a2,0
    8100173e:	85ce                	mv	a1,s3
    81001740:	8562                	mv	a0,s8
    81001742:	977ff0ef          	jal	810010b8 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    81001746:	c121                	beqz	a0,81001786 <copyout+0xa8>
    81001748:	611c                	ld	a5,0(a0)
    8100174a:	0157f713          	andi	a4,a5,21
    8100174e:	03a71e63          	bne	a4,s10,8100178a <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    81001752:	412984b3          	sub	s1,s3,s2
    81001756:	94da                	add	s1,s1,s6
    if(n > len)
    81001758:	fa9a7de3          	bgeu	s4,s1,81001712 <copyout+0x34>
    8100175c:	84d2                	mv	s1,s4
    8100175e:	bf55                	j	81001712 <copyout+0x34>
  }
  return 0;
    81001760:	4501                	li	a0,0
    81001762:	a021                	j	8100176a <copyout+0x8c>
    81001764:	4501                	li	a0,0
}
    81001766:	8082                	ret
      return -1;
    81001768:	557d                	li	a0,-1
}
    8100176a:	60e6                	ld	ra,88(sp)
    8100176c:	6446                	ld	s0,80(sp)
    8100176e:	64a6                	ld	s1,72(sp)
    81001770:	6906                	ld	s2,64(sp)
    81001772:	79e2                	ld	s3,56(sp)
    81001774:	7a42                	ld	s4,48(sp)
    81001776:	7aa2                	ld	s5,40(sp)
    81001778:	7b02                	ld	s6,32(sp)
    8100177a:	6be2                	ld	s7,24(sp)
    8100177c:	6c42                	ld	s8,16(sp)
    8100177e:	6ca2                	ld	s9,8(sp)
    81001780:	6d02                	ld	s10,0(sp)
    81001782:	6125                	addi	sp,sp,96
    81001784:	8082                	ret
      return -1;
    81001786:	557d                	li	a0,-1
    81001788:	b7cd                	j	8100176a <copyout+0x8c>
    8100178a:	557d                	li	a0,-1
    8100178c:	bff9                	j	8100176a <copyout+0x8c>

000000008100178e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8100178e:	c6a5                	beqz	a3,810017f6 <copyin+0x68>
{
    81001790:	715d                	addi	sp,sp,-80
    81001792:	e486                	sd	ra,72(sp)
    81001794:	e0a2                	sd	s0,64(sp)
    81001796:	fc26                	sd	s1,56(sp)
    81001798:	f84a                	sd	s2,48(sp)
    8100179a:	f44e                	sd	s3,40(sp)
    8100179c:	f052                	sd	s4,32(sp)
    8100179e:	ec56                	sd	s5,24(sp)
    810017a0:	e85a                	sd	s6,16(sp)
    810017a2:	e45e                	sd	s7,8(sp)
    810017a4:	e062                	sd	s8,0(sp)
    810017a6:	0880                	addi	s0,sp,80
    810017a8:	8b2a                	mv	s6,a0
    810017aa:	8a2e                	mv	s4,a1
    810017ac:	8c32                	mv	s8,a2
    810017ae:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    810017b0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    810017b2:	6a85                	lui	s5,0x1
    810017b4:	a00d                	j	810017d6 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    810017b6:	018505b3          	add	a1,a0,s8
    810017ba:	0004861b          	sext.w	a2,s1
    810017be:	412585b3          	sub	a1,a1,s2
    810017c2:	8552                	mv	a0,s4
    810017c4:	eb8ff0ef          	jal	81000e7c <memmove>

    len -= n;
    810017c8:	409989b3          	sub	s3,s3,s1
    dst += n;
    810017cc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    810017ce:	01590c33          	add	s8,s2,s5
  while(len > 0){
    810017d2:	02098063          	beqz	s3,810017f2 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    810017d6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    810017da:	85ca                	mv	a1,s2
    810017dc:	855a                	mv	a0,s6
    810017de:	975ff0ef          	jal	81001152 <walkaddr>
    if(pa0 == 0)
    810017e2:	cd01                	beqz	a0,810017fa <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    810017e4:	418904b3          	sub	s1,s2,s8
    810017e8:	94d6                	add	s1,s1,s5
    if(n > len)
    810017ea:	fc99f6e3          	bgeu	s3,s1,810017b6 <copyin+0x28>
    810017ee:	84ce                	mv	s1,s3
    810017f0:	b7d9                	j	810017b6 <copyin+0x28>
  }
  return 0;
    810017f2:	4501                	li	a0,0
    810017f4:	a021                	j	810017fc <copyin+0x6e>
    810017f6:	4501                	li	a0,0
}
    810017f8:	8082                	ret
      return -1;
    810017fa:	557d                	li	a0,-1
}
    810017fc:	60a6                	ld	ra,72(sp)
    810017fe:	6406                	ld	s0,64(sp)
    81001800:	74e2                	ld	s1,56(sp)
    81001802:	7942                	ld	s2,48(sp)
    81001804:	79a2                	ld	s3,40(sp)
    81001806:	7a02                	ld	s4,32(sp)
    81001808:	6ae2                	ld	s5,24(sp)
    8100180a:	6b42                	ld	s6,16(sp)
    8100180c:	6ba2                	ld	s7,8(sp)
    8100180e:	6c02                	ld	s8,0(sp)
    81001810:	6161                	addi	sp,sp,80
    81001812:	8082                	ret

0000000081001814 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    81001814:	715d                	addi	sp,sp,-80
    81001816:	e486                	sd	ra,72(sp)
    81001818:	e0a2                	sd	s0,64(sp)
    8100181a:	fc26                	sd	s1,56(sp)
    8100181c:	f84a                	sd	s2,48(sp)
    8100181e:	f44e                	sd	s3,40(sp)
    81001820:	f052                	sd	s4,32(sp)
    81001822:	ec56                	sd	s5,24(sp)
    81001824:	e85a                	sd	s6,16(sp)
    81001826:	e45e                	sd	s7,8(sp)
    81001828:	0880                	addi	s0,sp,80
    8100182a:	8aaa                	mv	s5,a0
    8100182c:	89ae                	mv	s3,a1
    8100182e:	8bb2                	mv	s7,a2
    81001830:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    81001832:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    81001834:	6a05                	lui	s4,0x1
    81001836:	a02d                	j	81001860 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    81001838:	00078023          	sb	zero,0(a5)
    8100183c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8100183e:	0017c793          	xori	a5,a5,1
    81001842:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    81001846:	60a6                	ld	ra,72(sp)
    81001848:	6406                	ld	s0,64(sp)
    8100184a:	74e2                	ld	s1,56(sp)
    8100184c:	7942                	ld	s2,48(sp)
    8100184e:	79a2                	ld	s3,40(sp)
    81001850:	7a02                	ld	s4,32(sp)
    81001852:	6ae2                	ld	s5,24(sp)
    81001854:	6b42                	ld	s6,16(sp)
    81001856:	6ba2                	ld	s7,8(sp)
    81001858:	6161                	addi	sp,sp,80
    8100185a:	8082                	ret
    srcva = va0 + PGSIZE;
    8100185c:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    81001860:	c4b1                	beqz	s1,810018ac <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    81001862:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    81001866:	85ca                	mv	a1,s2
    81001868:	8556                	mv	a0,s5
    8100186a:	8e9ff0ef          	jal	81001152 <walkaddr>
    if(pa0 == 0)
    8100186e:	c129                	beqz	a0,810018b0 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    81001870:	41790633          	sub	a2,s2,s7
    81001874:	9652                	add	a2,a2,s4
    if(n > max)
    81001876:	00c4f363          	bgeu	s1,a2,8100187c <copyinstr+0x68>
    8100187a:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8100187c:	412b8bb3          	sub	s7,s7,s2
    81001880:	9baa                	add	s7,s7,a0
    while(n > 0){
    81001882:	de69                	beqz	a2,8100185c <copyinstr+0x48>
    81001884:	87ce                	mv	a5,s3
      if(*p == '\0'){
    81001886:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    8100188a:	964e                	add	a2,a2,s3
    8100188c:	85be                	mv	a1,a5
      if(*p == '\0'){
    8100188e:	00f68733          	add	a4,a3,a5
    81001892:	00074703          	lbu	a4,0(a4)
    81001896:	d34d                	beqz	a4,81001838 <copyinstr+0x24>
        *dst = *p;
    81001898:	00e78023          	sb	a4,0(a5)
      dst++;
    8100189c:	0785                	addi	a5,a5,1
    while(n > 0){
    8100189e:	fec797e3          	bne	a5,a2,8100188c <copyinstr+0x78>
    810018a2:	14fd                	addi	s1,s1,-1
    810018a4:	94ce                	add	s1,s1,s3
      --max;
    810018a6:	8c8d                	sub	s1,s1,a1
    810018a8:	89be                	mv	s3,a5
    810018aa:	bf4d                	j	8100185c <copyinstr+0x48>
    810018ac:	4781                	li	a5,0
    810018ae:	bf41                	j	8100183e <copyinstr+0x2a>
      return -1;
    810018b0:	557d                	li	a0,-1
    810018b2:	bf51                	j	81001846 <copyinstr+0x32>

00000000810018b4 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    810018b4:	715d                	addi	sp,sp,-80
    810018b6:	e486                	sd	ra,72(sp)
    810018b8:	e0a2                	sd	s0,64(sp)
    810018ba:	fc26                	sd	s1,56(sp)
    810018bc:	f84a                	sd	s2,48(sp)
    810018be:	f44e                	sd	s3,40(sp)
    810018c0:	f052                	sd	s4,32(sp)
    810018c2:	ec56                	sd	s5,24(sp)
    810018c4:	e85a                	sd	s6,16(sp)
    810018c6:	e45e                	sd	s7,8(sp)
    810018c8:	e062                	sd	s8,0(sp)
    810018ca:	0880                	addi	s0,sp,80
    810018cc:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    810018ce:	0000e497          	auipc	s1,0xe
    810018d2:	62248493          	addi	s1,s1,1570 # 8100fef0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    810018d6:	8c26                	mv	s8,s1
    810018d8:	a4fa57b7          	lui	a5,0xa4fa5
    810018dc:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff23f83fa5>
    810018e0:	4fa50937          	lui	s2,0x4fa50
    810018e4:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x315b05b0>
    810018e8:	1902                	slli	s2,s2,0x20
    810018ea:	993e                	add	s2,s2,a5
    810018ec:	040009b7          	lui	s3,0x4000
    810018f0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7d000001>
    810018f2:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    810018f4:	4b99                	li	s7,6
    810018f6:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    810018f8:	00014a97          	auipc	s5,0x14
    810018fc:	ff8a8a93          	addi	s5,s5,-8 # 810158f0 <tickslock>
    char *pa = kalloc();
    81001900:	b74ff0ef          	jal	81000c74 <kalloc>
    81001904:	862a                	mv	a2,a0
    if(pa == 0)
    81001906:	c121                	beqz	a0,81001946 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    81001908:	418485b3          	sub	a1,s1,s8
    8100190c:	858d                	srai	a1,a1,0x3
    8100190e:	032585b3          	mul	a1,a1,s2
    81001912:	2585                	addiw	a1,a1,1
    81001914:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    81001918:	875e                	mv	a4,s7
    8100191a:	86da                	mv	a3,s6
    8100191c:	40b985b3          	sub	a1,s3,a1
    81001920:	8552                	mv	a0,s4
    81001922:	925ff0ef          	jal	81001246 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    81001926:	16848493          	addi	s1,s1,360
    8100192a:	fd549be3          	bne	s1,s5,81001900 <proc_mapstacks+0x4c>
  }
}
    8100192e:	60a6                	ld	ra,72(sp)
    81001930:	6406                	ld	s0,64(sp)
    81001932:	74e2                	ld	s1,56(sp)
    81001934:	7942                	ld	s2,48(sp)
    81001936:	79a2                	ld	s3,40(sp)
    81001938:	7a02                	ld	s4,32(sp)
    8100193a:	6ae2                	ld	s5,24(sp)
    8100193c:	6b42                	ld	s6,16(sp)
    8100193e:	6ba2                	ld	s7,8(sp)
    81001940:	6c02                	ld	s8,0(sp)
    81001942:	6161                	addi	sp,sp,80
    81001944:	8082                	ret
      panic("kalloc");
    81001946:	00006517          	auipc	a0,0x6
    8100194a:	93a50513          	addi	a0,a0,-1734 # 81007280 <etext+0x280>
    8100194e:	f97fe0ef          	jal	810008e4 <panic>

0000000081001952 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    81001952:	7139                	addi	sp,sp,-64
    81001954:	fc06                	sd	ra,56(sp)
    81001956:	f822                	sd	s0,48(sp)
    81001958:	f426                	sd	s1,40(sp)
    8100195a:	f04a                	sd	s2,32(sp)
    8100195c:	ec4e                	sd	s3,24(sp)
    8100195e:	e852                	sd	s4,16(sp)
    81001960:	e456                	sd	s5,8(sp)
    81001962:	e05a                	sd	s6,0(sp)
    81001964:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    81001966:	00006597          	auipc	a1,0x6
    8100196a:	92258593          	addi	a1,a1,-1758 # 81007288 <etext+0x288>
    8100196e:	0000e517          	auipc	a0,0xe
    81001972:	15250513          	addi	a0,a0,338 # 8100fac0 <pid_lock>
    81001976:	b4eff0ef          	jal	81000cc4 <initlock>
  initlock(&wait_lock, "wait_lock");
    8100197a:	00006597          	auipc	a1,0x6
    8100197e:	91658593          	addi	a1,a1,-1770 # 81007290 <etext+0x290>
    81001982:	0000e517          	auipc	a0,0xe
    81001986:	15650513          	addi	a0,a0,342 # 8100fad8 <wait_lock>
    8100198a:	b3aff0ef          	jal	81000cc4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8100198e:	0000e497          	auipc	s1,0xe
    81001992:	56248493          	addi	s1,s1,1378 # 8100fef0 <proc>
      initlock(&p->lock, "proc");
    81001996:	00006b17          	auipc	s6,0x6
    8100199a:	90ab0b13          	addi	s6,s6,-1782 # 810072a0 <etext+0x2a0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8100199e:	8aa6                	mv	s5,s1
    810019a0:	a4fa57b7          	lui	a5,0xa4fa5
    810019a4:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff23f83fa5>
    810019a8:	4fa50937          	lui	s2,0x4fa50
    810019ac:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x315b05b0>
    810019b0:	1902                	slli	s2,s2,0x20
    810019b2:	993e                	add	s2,s2,a5
    810019b4:	040009b7          	lui	s3,0x4000
    810019b8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7d000001>
    810019ba:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    810019bc:	00014a17          	auipc	s4,0x14
    810019c0:	f34a0a13          	addi	s4,s4,-204 # 810158f0 <tickslock>
      initlock(&p->lock, "proc");
    810019c4:	85da                	mv	a1,s6
    810019c6:	8526                	mv	a0,s1
    810019c8:	afcff0ef          	jal	81000cc4 <initlock>
      p->state = UNUSED;
    810019cc:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    810019d0:	415487b3          	sub	a5,s1,s5
    810019d4:	878d                	srai	a5,a5,0x3
    810019d6:	032787b3          	mul	a5,a5,s2
    810019da:	2785                	addiw	a5,a5,1
    810019dc:	00d7979b          	slliw	a5,a5,0xd
    810019e0:	40f987b3          	sub	a5,s3,a5
    810019e4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    810019e6:	16848493          	addi	s1,s1,360
    810019ea:	fd449de3          	bne	s1,s4,810019c4 <procinit+0x72>
  }
}
    810019ee:	70e2                	ld	ra,56(sp)
    810019f0:	7442                	ld	s0,48(sp)
    810019f2:	74a2                	ld	s1,40(sp)
    810019f4:	7902                	ld	s2,32(sp)
    810019f6:	69e2                	ld	s3,24(sp)
    810019f8:	6a42                	ld	s4,16(sp)
    810019fa:	6aa2                	ld	s5,8(sp)
    810019fc:	6b02                	ld	s6,0(sp)
    810019fe:	6121                	addi	sp,sp,64
    81001a00:	8082                	ret

0000000081001a02 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    81001a02:	1141                	addi	sp,sp,-16
    81001a04:	e406                	sd	ra,8(sp)
    81001a06:	e022                	sd	s0,0(sp)
    81001a08:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    81001a0a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    81001a0c:	2501                	sext.w	a0,a0
    81001a0e:	60a2                	ld	ra,8(sp)
    81001a10:	6402                	ld	s0,0(sp)
    81001a12:	0141                	addi	sp,sp,16
    81001a14:	8082                	ret

0000000081001a16 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    81001a16:	1141                	addi	sp,sp,-16
    81001a18:	e406                	sd	ra,8(sp)
    81001a1a:	e022                	sd	s0,0(sp)
    81001a1c:	0800                	addi	s0,sp,16
    81001a1e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    81001a20:	2781                	sext.w	a5,a5
    81001a22:	079e                	slli	a5,a5,0x7
  return c;
}
    81001a24:	0000e517          	auipc	a0,0xe
    81001a28:	0cc50513          	addi	a0,a0,204 # 8100faf0 <cpus>
    81001a2c:	953e                	add	a0,a0,a5
    81001a2e:	60a2                	ld	ra,8(sp)
    81001a30:	6402                	ld	s0,0(sp)
    81001a32:	0141                	addi	sp,sp,16
    81001a34:	8082                	ret

0000000081001a36 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    81001a36:	1101                	addi	sp,sp,-32
    81001a38:	ec06                	sd	ra,24(sp)
    81001a3a:	e822                	sd	s0,16(sp)
    81001a3c:	e426                	sd	s1,8(sp)
    81001a3e:	1000                	addi	s0,sp,32
  push_off();
    81001a40:	ac8ff0ef          	jal	81000d08 <push_off>
    81001a44:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    81001a46:	2781                	sext.w	a5,a5
    81001a48:	079e                	slli	a5,a5,0x7
    81001a4a:	0000e717          	auipc	a4,0xe
    81001a4e:	07670713          	addi	a4,a4,118 # 8100fac0 <pid_lock>
    81001a52:	97ba                	add	a5,a5,a4
    81001a54:	7b84                	ld	s1,48(a5)
  pop_off();
    81001a56:	b36ff0ef          	jal	81000d8c <pop_off>
  return p;
}
    81001a5a:	8526                	mv	a0,s1
    81001a5c:	60e2                	ld	ra,24(sp)
    81001a5e:	6442                	ld	s0,16(sp)
    81001a60:	64a2                	ld	s1,8(sp)
    81001a62:	6105                	addi	sp,sp,32
    81001a64:	8082                	ret

0000000081001a66 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    81001a66:	1141                	addi	sp,sp,-16
    81001a68:	e406                	sd	ra,8(sp)
    81001a6a:	e022                	sd	s0,0(sp)
    81001a6c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    81001a6e:	fc9ff0ef          	jal	81001a36 <myproc>
    81001a72:	b6aff0ef          	jal	81000ddc <release>

  if (first) {
    81001a76:	00006797          	auipc	a5,0x6
    81001a7a:	e9a7a783          	lw	a5,-358(a5) # 81007910 <first.1>
    81001a7e:	e799                	bnez	a5,81001a8c <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    81001a80:	2bd000ef          	jal	8100253c <usertrapret>
}
    81001a84:	60a2                	ld	ra,8(sp)
    81001a86:	6402                	ld	s0,0(sp)
    81001a88:	0141                	addi	sp,sp,16
    81001a8a:	8082                	ret
    fsinit(ROOTDEV);
    81001a8c:	4505                	li	a0,1
    81001a8e:	624010ef          	jal	810030b2 <fsinit>
    first = 0;
    81001a92:	00006797          	auipc	a5,0x6
    81001a96:	e607af23          	sw	zero,-386(a5) # 81007910 <first.1>
    __sync_synchronize();
    81001a9a:	0330000f          	fence	rw,rw
    81001a9e:	b7cd                	j	81001a80 <forkret+0x1a>

0000000081001aa0 <allocpid>:
{
    81001aa0:	1101                	addi	sp,sp,-32
    81001aa2:	ec06                	sd	ra,24(sp)
    81001aa4:	e822                	sd	s0,16(sp)
    81001aa6:	e426                	sd	s1,8(sp)
    81001aa8:	e04a                	sd	s2,0(sp)
    81001aaa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    81001aac:	0000e917          	auipc	s2,0xe
    81001ab0:	01490913          	addi	s2,s2,20 # 8100fac0 <pid_lock>
    81001ab4:	854a                	mv	a0,s2
    81001ab6:	a92ff0ef          	jal	81000d48 <acquire>
  pid = nextpid;
    81001aba:	00006797          	auipc	a5,0x6
    81001abe:	e5a78793          	addi	a5,a5,-422 # 81007914 <nextpid>
    81001ac2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    81001ac4:	0014871b          	addiw	a4,s1,1
    81001ac8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    81001aca:	854a                	mv	a0,s2
    81001acc:	b10ff0ef          	jal	81000ddc <release>
}
    81001ad0:	8526                	mv	a0,s1
    81001ad2:	60e2                	ld	ra,24(sp)
    81001ad4:	6442                	ld	s0,16(sp)
    81001ad6:	64a2                	ld	s1,8(sp)
    81001ad8:	6902                	ld	s2,0(sp)
    81001ada:	6105                	addi	sp,sp,32
    81001adc:	8082                	ret

0000000081001ade <proc_pagetable>:
{
    81001ade:	1101                	addi	sp,sp,-32
    81001ae0:	ec06                	sd	ra,24(sp)
    81001ae2:	e822                	sd	s0,16(sp)
    81001ae4:	e426                	sd	s1,8(sp)
    81001ae6:	e04a                	sd	s2,0(sp)
    81001ae8:	1000                	addi	s0,sp,32
    81001aea:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    81001aec:	90bff0ef          	jal	810013f6 <uvmcreate>
    81001af0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    81001af2:	cd05                	beqz	a0,81001b2a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    81001af4:	4729                	li	a4,10
    81001af6:	00004697          	auipc	a3,0x4
    81001afa:	50a68693          	addi	a3,a3,1290 # 81006000 <_trampoline>
    81001afe:	6605                	lui	a2,0x1
    81001b00:	040005b7          	lui	a1,0x4000
    81001b04:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7d000001>
    81001b06:	05b2                	slli	a1,a1,0xc
    81001b08:	e88ff0ef          	jal	81001190 <mappages>
    81001b0c:	02054663          	bltz	a0,81001b38 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    81001b10:	4719                	li	a4,6
    81001b12:	05893683          	ld	a3,88(s2)
    81001b16:	6605                	lui	a2,0x1
    81001b18:	020005b7          	lui	a1,0x2000
    81001b1c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7f000001>
    81001b1e:	05b6                	slli	a1,a1,0xd
    81001b20:	8526                	mv	a0,s1
    81001b22:	e6eff0ef          	jal	81001190 <mappages>
    81001b26:	00054f63          	bltz	a0,81001b44 <proc_pagetable+0x66>
}
    81001b2a:	8526                	mv	a0,s1
    81001b2c:	60e2                	ld	ra,24(sp)
    81001b2e:	6442                	ld	s0,16(sp)
    81001b30:	64a2                	ld	s1,8(sp)
    81001b32:	6902                	ld	s2,0(sp)
    81001b34:	6105                	addi	sp,sp,32
    81001b36:	8082                	ret
    uvmfree(pagetable, 0);
    81001b38:	4581                	li	a1,0
    81001b3a:	8526                	mv	a0,s1
    81001b3c:	a91ff0ef          	jal	810015cc <uvmfree>
    return 0;
    81001b40:	4481                	li	s1,0
    81001b42:	b7e5                	j	81001b2a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    81001b44:	4681                	li	a3,0
    81001b46:	4605                	li	a2,1
    81001b48:	040005b7          	lui	a1,0x4000
    81001b4c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7d000001>
    81001b4e:	05b2                	slli	a1,a1,0xc
    81001b50:	8526                	mv	a0,s1
    81001b52:	fe8ff0ef          	jal	8100133a <uvmunmap>
    uvmfree(pagetable, 0);
    81001b56:	4581                	li	a1,0
    81001b58:	8526                	mv	a0,s1
    81001b5a:	a73ff0ef          	jal	810015cc <uvmfree>
    return 0;
    81001b5e:	4481                	li	s1,0
    81001b60:	b7e9                	j	81001b2a <proc_pagetable+0x4c>

0000000081001b62 <proc_freepagetable>:
{
    81001b62:	1101                	addi	sp,sp,-32
    81001b64:	ec06                	sd	ra,24(sp)
    81001b66:	e822                	sd	s0,16(sp)
    81001b68:	e426                	sd	s1,8(sp)
    81001b6a:	e04a                	sd	s2,0(sp)
    81001b6c:	1000                	addi	s0,sp,32
    81001b6e:	84aa                	mv	s1,a0
    81001b70:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    81001b72:	4681                	li	a3,0
    81001b74:	4605                	li	a2,1
    81001b76:	040005b7          	lui	a1,0x4000
    81001b7a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7d000001>
    81001b7c:	05b2                	slli	a1,a1,0xc
    81001b7e:	fbcff0ef          	jal	8100133a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    81001b82:	4681                	li	a3,0
    81001b84:	4605                	li	a2,1
    81001b86:	020005b7          	lui	a1,0x2000
    81001b8a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7f000001>
    81001b8c:	05b6                	slli	a1,a1,0xd
    81001b8e:	8526                	mv	a0,s1
    81001b90:	faaff0ef          	jal	8100133a <uvmunmap>
  uvmfree(pagetable, sz);
    81001b94:	85ca                	mv	a1,s2
    81001b96:	8526                	mv	a0,s1
    81001b98:	a35ff0ef          	jal	810015cc <uvmfree>
}
    81001b9c:	60e2                	ld	ra,24(sp)
    81001b9e:	6442                	ld	s0,16(sp)
    81001ba0:	64a2                	ld	s1,8(sp)
    81001ba2:	6902                	ld	s2,0(sp)
    81001ba4:	6105                	addi	sp,sp,32
    81001ba6:	8082                	ret

0000000081001ba8 <freeproc>:
{
    81001ba8:	1101                	addi	sp,sp,-32
    81001baa:	ec06                	sd	ra,24(sp)
    81001bac:	e822                	sd	s0,16(sp)
    81001bae:	e426                	sd	s1,8(sp)
    81001bb0:	1000                	addi	s0,sp,32
    81001bb2:	84aa                	mv	s1,a0
  if(p->trapframe)
    81001bb4:	6d28                	ld	a0,88(a0)
    81001bb6:	c119                	beqz	a0,81001bbc <freeproc+0x14>
    kfree((void*)p->trapframe);
    81001bb8:	fd7fe0ef          	jal	81000b8e <kfree>
  p->trapframe = 0;
    81001bbc:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    81001bc0:	68a8                	ld	a0,80(s1)
    81001bc2:	c501                	beqz	a0,81001bca <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    81001bc4:	64ac                	ld	a1,72(s1)
    81001bc6:	f9dff0ef          	jal	81001b62 <proc_freepagetable>
  p->pagetable = 0;
    81001bca:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    81001bce:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    81001bd2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    81001bd6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    81001bda:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    81001bde:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    81001be2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    81001be6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    81001bea:	0004ac23          	sw	zero,24(s1)
}
    81001bee:	60e2                	ld	ra,24(sp)
    81001bf0:	6442                	ld	s0,16(sp)
    81001bf2:	64a2                	ld	s1,8(sp)
    81001bf4:	6105                	addi	sp,sp,32
    81001bf6:	8082                	ret

0000000081001bf8 <allocproc>:
{
    81001bf8:	1101                	addi	sp,sp,-32
    81001bfa:	ec06                	sd	ra,24(sp)
    81001bfc:	e822                	sd	s0,16(sp)
    81001bfe:	e426                	sd	s1,8(sp)
    81001c00:	e04a                	sd	s2,0(sp)
    81001c02:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    81001c04:	0000e497          	auipc	s1,0xe
    81001c08:	2ec48493          	addi	s1,s1,748 # 8100fef0 <proc>
    81001c0c:	00014917          	auipc	s2,0x14
    81001c10:	ce490913          	addi	s2,s2,-796 # 810158f0 <tickslock>
    acquire(&p->lock);
    81001c14:	8526                	mv	a0,s1
    81001c16:	932ff0ef          	jal	81000d48 <acquire>
    if(p->state == UNUSED) {
    81001c1a:	4c9c                	lw	a5,24(s1)
    81001c1c:	cb91                	beqz	a5,81001c30 <allocproc+0x38>
      release(&p->lock);
    81001c1e:	8526                	mv	a0,s1
    81001c20:	9bcff0ef          	jal	81000ddc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    81001c24:	16848493          	addi	s1,s1,360
    81001c28:	ff2496e3          	bne	s1,s2,81001c14 <allocproc+0x1c>
  return 0;
    81001c2c:	4481                	li	s1,0
    81001c2e:	a089                	j	81001c70 <allocproc+0x78>
  p->pid = allocpid();
    81001c30:	e71ff0ef          	jal	81001aa0 <allocpid>
    81001c34:	d888                	sw	a0,48(s1)
  p->state = USED;
    81001c36:	4785                	li	a5,1
    81001c38:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    81001c3a:	83aff0ef          	jal	81000c74 <kalloc>
    81001c3e:	892a                	mv	s2,a0
    81001c40:	eca8                	sd	a0,88(s1)
    81001c42:	cd15                	beqz	a0,81001c7e <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    81001c44:	8526                	mv	a0,s1
    81001c46:	e99ff0ef          	jal	81001ade <proc_pagetable>
    81001c4a:	892a                	mv	s2,a0
    81001c4c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    81001c4e:	c121                	beqz	a0,81001c8e <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    81001c50:	07000613          	li	a2,112
    81001c54:	4581                	li	a1,0
    81001c56:	06048513          	addi	a0,s1,96
    81001c5a:	9beff0ef          	jal	81000e18 <memset>
  p->context.ra = (uint64)forkret;
    81001c5e:	00000797          	auipc	a5,0x0
    81001c62:	e0878793          	addi	a5,a5,-504 # 81001a66 <forkret>
    81001c66:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    81001c68:	60bc                	ld	a5,64(s1)
    81001c6a:	6705                	lui	a4,0x1
    81001c6c:	97ba                	add	a5,a5,a4
    81001c6e:	f4bc                	sd	a5,104(s1)
}
    81001c70:	8526                	mv	a0,s1
    81001c72:	60e2                	ld	ra,24(sp)
    81001c74:	6442                	ld	s0,16(sp)
    81001c76:	64a2                	ld	s1,8(sp)
    81001c78:	6902                	ld	s2,0(sp)
    81001c7a:	6105                	addi	sp,sp,32
    81001c7c:	8082                	ret
    freeproc(p);
    81001c7e:	8526                	mv	a0,s1
    81001c80:	f29ff0ef          	jal	81001ba8 <freeproc>
    release(&p->lock);
    81001c84:	8526                	mv	a0,s1
    81001c86:	956ff0ef          	jal	81000ddc <release>
    return 0;
    81001c8a:	84ca                	mv	s1,s2
    81001c8c:	b7d5                	j	81001c70 <allocproc+0x78>
    freeproc(p);
    81001c8e:	8526                	mv	a0,s1
    81001c90:	f19ff0ef          	jal	81001ba8 <freeproc>
    release(&p->lock);
    81001c94:	8526                	mv	a0,s1
    81001c96:	946ff0ef          	jal	81000ddc <release>
    return 0;
    81001c9a:	84ca                	mv	s1,s2
    81001c9c:	bfd1                	j	81001c70 <allocproc+0x78>

0000000081001c9e <userinit>:
{
    81001c9e:	1101                	addi	sp,sp,-32
    81001ca0:	ec06                	sd	ra,24(sp)
    81001ca2:	e822                	sd	s0,16(sp)
    81001ca4:	e426                	sd	s1,8(sp)
    81001ca6:	1000                	addi	s0,sp,32
  p = allocproc();
    81001ca8:	f51ff0ef          	jal	81001bf8 <allocproc>
    81001cac:	84aa                	mv	s1,a0
  initproc = p;
    81001cae:	00006797          	auipc	a5,0x6
    81001cb2:	cca7bd23          	sd	a0,-806(a5) # 81007988 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    81001cb6:	03400613          	li	a2,52
    81001cba:	00006597          	auipc	a1,0x6
    81001cbe:	c6658593          	addi	a1,a1,-922 # 81007920 <initcode>
    81001cc2:	6928                	ld	a0,80(a0)
    81001cc4:	f58ff0ef          	jal	8100141c <uvmfirst>
  p->sz = PGSIZE;
    81001cc8:	6785                	lui	a5,0x1
    81001cca:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    81001ccc:	6cb8                	ld	a4,88(s1)
    81001cce:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x80ffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    81001cd2:	6cb8                	ld	a4,88(s1)
    81001cd4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    81001cd6:	4641                	li	a2,16
    81001cd8:	00005597          	auipc	a1,0x5
    81001cdc:	5d058593          	addi	a1,a1,1488 # 810072a8 <etext+0x2a8>
    81001ce0:	15848513          	addi	a0,s1,344
    81001ce4:	a86ff0ef          	jal	81000f6a <safestrcpy>
  p->cwd = namei("/");
    81001ce8:	00005517          	auipc	a0,0x5
    81001cec:	5d050513          	addi	a0,a0,1488 # 810072b8 <etext+0x2b8>
    81001cf0:	4e7010ef          	jal	810039d6 <namei>
    81001cf4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    81001cf8:	478d                	li	a5,3
    81001cfa:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    81001cfc:	8526                	mv	a0,s1
    81001cfe:	8deff0ef          	jal	81000ddc <release>
}
    81001d02:	60e2                	ld	ra,24(sp)
    81001d04:	6442                	ld	s0,16(sp)
    81001d06:	64a2                	ld	s1,8(sp)
    81001d08:	6105                	addi	sp,sp,32
    81001d0a:	8082                	ret

0000000081001d0c <growproc>:
{
    81001d0c:	1101                	addi	sp,sp,-32
    81001d0e:	ec06                	sd	ra,24(sp)
    81001d10:	e822                	sd	s0,16(sp)
    81001d12:	e426                	sd	s1,8(sp)
    81001d14:	e04a                	sd	s2,0(sp)
    81001d16:	1000                	addi	s0,sp,32
    81001d18:	892a                	mv	s2,a0
  struct proc *p = myproc();
    81001d1a:	d1dff0ef          	jal	81001a36 <myproc>
    81001d1e:	84aa                	mv	s1,a0
  sz = p->sz;
    81001d20:	652c                	ld	a1,72(a0)
  if(n > 0){
    81001d22:	01204c63          	bgtz	s2,81001d3a <growproc+0x2e>
  } else if(n < 0){
    81001d26:	02094463          	bltz	s2,81001d4e <growproc+0x42>
  p->sz = sz;
    81001d2a:	e4ac                	sd	a1,72(s1)
  return 0;
    81001d2c:	4501                	li	a0,0
}
    81001d2e:	60e2                	ld	ra,24(sp)
    81001d30:	6442                	ld	s0,16(sp)
    81001d32:	64a2                	ld	s1,8(sp)
    81001d34:	6902                	ld	s2,0(sp)
    81001d36:	6105                	addi	sp,sp,32
    81001d38:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    81001d3a:	4691                	li	a3,4
    81001d3c:	00b90633          	add	a2,s2,a1
    81001d40:	6928                	ld	a0,80(a0)
    81001d42:	f7cff0ef          	jal	810014be <uvmalloc>
    81001d46:	85aa                	mv	a1,a0
    81001d48:	f16d                	bnez	a0,81001d2a <growproc+0x1e>
      return -1;
    81001d4a:	557d                	li	a0,-1
    81001d4c:	b7cd                	j	81001d2e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    81001d4e:	00b90633          	add	a2,s2,a1
    81001d52:	6928                	ld	a0,80(a0)
    81001d54:	f26ff0ef          	jal	8100147a <uvmdealloc>
    81001d58:	85aa                	mv	a1,a0
    81001d5a:	bfc1                	j	81001d2a <growproc+0x1e>

0000000081001d5c <fork>:
{
    81001d5c:	7139                	addi	sp,sp,-64
    81001d5e:	fc06                	sd	ra,56(sp)
    81001d60:	f822                	sd	s0,48(sp)
    81001d62:	f04a                	sd	s2,32(sp)
    81001d64:	e456                	sd	s5,8(sp)
    81001d66:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    81001d68:	ccfff0ef          	jal	81001a36 <myproc>
    81001d6c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    81001d6e:	e8bff0ef          	jal	81001bf8 <allocproc>
    81001d72:	0e050a63          	beqz	a0,81001e66 <fork+0x10a>
    81001d76:	e852                	sd	s4,16(sp)
    81001d78:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    81001d7a:	048ab603          	ld	a2,72(s5)
    81001d7e:	692c                	ld	a1,80(a0)
    81001d80:	050ab503          	ld	a0,80(s5)
    81001d84:	87bff0ef          	jal	810015fe <uvmcopy>
    81001d88:	04054a63          	bltz	a0,81001ddc <fork+0x80>
    81001d8c:	f426                	sd	s1,40(sp)
    81001d8e:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    81001d90:	048ab783          	ld	a5,72(s5)
    81001d94:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    81001d98:	058ab683          	ld	a3,88(s5)
    81001d9c:	87b6                	mv	a5,a3
    81001d9e:	058a3703          	ld	a4,88(s4)
    81001da2:	12068693          	addi	a3,a3,288
    81001da6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x80fff000>
    81001daa:	6788                	ld	a0,8(a5)
    81001dac:	6b8c                	ld	a1,16(a5)
    81001dae:	6f90                	ld	a2,24(a5)
    81001db0:	01073023          	sd	a6,0(a4)
    81001db4:	e708                	sd	a0,8(a4)
    81001db6:	eb0c                	sd	a1,16(a4)
    81001db8:	ef10                	sd	a2,24(a4)
    81001dba:	02078793          	addi	a5,a5,32
    81001dbe:	02070713          	addi	a4,a4,32
    81001dc2:	fed792e3          	bne	a5,a3,81001da6 <fork+0x4a>
  np->trapframe->a0 = 0;
    81001dc6:	058a3783          	ld	a5,88(s4)
    81001dca:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    81001dce:	0d0a8493          	addi	s1,s5,208
    81001dd2:	0d0a0913          	addi	s2,s4,208
    81001dd6:	150a8993          	addi	s3,s5,336
    81001dda:	a831                	j	81001df6 <fork+0x9a>
    freeproc(np);
    81001ddc:	8552                	mv	a0,s4
    81001dde:	dcbff0ef          	jal	81001ba8 <freeproc>
    release(&np->lock);
    81001de2:	8552                	mv	a0,s4
    81001de4:	ff9fe0ef          	jal	81000ddc <release>
    return -1;
    81001de8:	597d                	li	s2,-1
    81001dea:	6a42                	ld	s4,16(sp)
    81001dec:	a0b5                	j	81001e58 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    81001dee:	04a1                	addi	s1,s1,8
    81001df0:	0921                	addi	s2,s2,8
    81001df2:	01348963          	beq	s1,s3,81001e04 <fork+0xa8>
    if(p->ofile[i])
    81001df6:	6088                	ld	a0,0(s1)
    81001df8:	d97d                	beqz	a0,81001dee <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    81001dfa:	178020ef          	jal	81003f72 <filedup>
    81001dfe:	00a93023          	sd	a0,0(s2)
    81001e02:	b7f5                	j	81001dee <fork+0x92>
  np->cwd = idup(p->cwd);
    81001e04:	150ab503          	ld	a0,336(s5)
    81001e08:	4a8010ef          	jal	810032b0 <idup>
    81001e0c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    81001e10:	4641                	li	a2,16
    81001e12:	158a8593          	addi	a1,s5,344
    81001e16:	158a0513          	addi	a0,s4,344
    81001e1a:	950ff0ef          	jal	81000f6a <safestrcpy>
  pid = np->pid;
    81001e1e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    81001e22:	8552                	mv	a0,s4
    81001e24:	fb9fe0ef          	jal	81000ddc <release>
  acquire(&wait_lock);
    81001e28:	0000e497          	auipc	s1,0xe
    81001e2c:	cb048493          	addi	s1,s1,-848 # 8100fad8 <wait_lock>
    81001e30:	8526                	mv	a0,s1
    81001e32:	f17fe0ef          	jal	81000d48 <acquire>
  np->parent = p;
    81001e36:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    81001e3a:	8526                	mv	a0,s1
    81001e3c:	fa1fe0ef          	jal	81000ddc <release>
  acquire(&np->lock);
    81001e40:	8552                	mv	a0,s4
    81001e42:	f07fe0ef          	jal	81000d48 <acquire>
  np->state = RUNNABLE;
    81001e46:	478d                	li	a5,3
    81001e48:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    81001e4c:	8552                	mv	a0,s4
    81001e4e:	f8ffe0ef          	jal	81000ddc <release>
  return pid;
    81001e52:	74a2                	ld	s1,40(sp)
    81001e54:	69e2                	ld	s3,24(sp)
    81001e56:	6a42                	ld	s4,16(sp)
}
    81001e58:	854a                	mv	a0,s2
    81001e5a:	70e2                	ld	ra,56(sp)
    81001e5c:	7442                	ld	s0,48(sp)
    81001e5e:	7902                	ld	s2,32(sp)
    81001e60:	6aa2                	ld	s5,8(sp)
    81001e62:	6121                	addi	sp,sp,64
    81001e64:	8082                	ret
    return -1;
    81001e66:	597d                	li	s2,-1
    81001e68:	bfc5                	j	81001e58 <fork+0xfc>

0000000081001e6a <scheduler>:
{
    81001e6a:	715d                	addi	sp,sp,-80
    81001e6c:	e486                	sd	ra,72(sp)
    81001e6e:	e0a2                	sd	s0,64(sp)
    81001e70:	fc26                	sd	s1,56(sp)
    81001e72:	f84a                	sd	s2,48(sp)
    81001e74:	f44e                	sd	s3,40(sp)
    81001e76:	f052                	sd	s4,32(sp)
    81001e78:	ec56                	sd	s5,24(sp)
    81001e7a:	e85a                	sd	s6,16(sp)
    81001e7c:	e45e                	sd	s7,8(sp)
    81001e7e:	e062                	sd	s8,0(sp)
    81001e80:	0880                	addi	s0,sp,80
    81001e82:	8792                	mv	a5,tp
  int id = r_tp();
    81001e84:	2781                	sext.w	a5,a5
  c->proc = 0;
    81001e86:	00779b13          	slli	s6,a5,0x7
    81001e8a:	0000e717          	auipc	a4,0xe
    81001e8e:	c3670713          	addi	a4,a4,-970 # 8100fac0 <pid_lock>
    81001e92:	975a                	add	a4,a4,s6
    81001e94:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    81001e98:	0000e717          	auipc	a4,0xe
    81001e9c:	c6070713          	addi	a4,a4,-928 # 8100faf8 <cpus+0x8>
    81001ea0:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    81001ea2:	4c11                	li	s8,4
        c->proc = p;
    81001ea4:	079e                	slli	a5,a5,0x7
    81001ea6:	0000ea17          	auipc	s4,0xe
    81001eaa:	c1aa0a13          	addi	s4,s4,-998 # 8100fac0 <pid_lock>
    81001eae:	9a3e                	add	s4,s4,a5
        found = 1;
    81001eb0:	4b85                	li	s7,1
    81001eb2:	a0a9                	j	81001efc <scheduler+0x92>
      release(&p->lock);
    81001eb4:	8526                	mv	a0,s1
    81001eb6:	f27fe0ef          	jal	81000ddc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    81001eba:	16848493          	addi	s1,s1,360
    81001ebe:	03248563          	beq	s1,s2,81001ee8 <scheduler+0x7e>
      acquire(&p->lock);
    81001ec2:	8526                	mv	a0,s1
    81001ec4:	e85fe0ef          	jal	81000d48 <acquire>
      if(p->state == RUNNABLE) {
    81001ec8:	4c9c                	lw	a5,24(s1)
    81001eca:	ff3795e3          	bne	a5,s3,81001eb4 <scheduler+0x4a>
        p->state = RUNNING;
    81001ece:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    81001ed2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    81001ed6:	06048593          	addi	a1,s1,96
    81001eda:	855a                	mv	a0,s6
    81001edc:	5b6000ef          	jal	81002492 <swtch>
        c->proc = 0;
    81001ee0:	020a3823          	sd	zero,48(s4)
        found = 1;
    81001ee4:	8ade                	mv	s5,s7
    81001ee6:	b7f9                	j	81001eb4 <scheduler+0x4a>
    if(found == 0) {
    81001ee8:	000a9a63          	bnez	s5,81001efc <scheduler+0x92>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81001eec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    81001ef0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81001ef4:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    81001ef8:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81001efc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    81001f00:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81001f04:	10079073          	csrw	sstatus,a5
    int found = 0;
    81001f08:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    81001f0a:	0000e497          	auipc	s1,0xe
    81001f0e:	fe648493          	addi	s1,s1,-26 # 8100fef0 <proc>
      if(p->state == RUNNABLE) {
    81001f12:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    81001f14:	00014917          	auipc	s2,0x14
    81001f18:	9dc90913          	addi	s2,s2,-1572 # 810158f0 <tickslock>
    81001f1c:	b75d                	j	81001ec2 <scheduler+0x58>

0000000081001f1e <sched>:
{
    81001f1e:	7179                	addi	sp,sp,-48
    81001f20:	f406                	sd	ra,40(sp)
    81001f22:	f022                	sd	s0,32(sp)
    81001f24:	ec26                	sd	s1,24(sp)
    81001f26:	e84a                	sd	s2,16(sp)
    81001f28:	e44e                	sd	s3,8(sp)
    81001f2a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    81001f2c:	b0bff0ef          	jal	81001a36 <myproc>
    81001f30:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    81001f32:	dadfe0ef          	jal	81000cde <holding>
    81001f36:	c92d                	beqz	a0,81001fa8 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    81001f38:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    81001f3a:	2781                	sext.w	a5,a5
    81001f3c:	079e                	slli	a5,a5,0x7
    81001f3e:	0000e717          	auipc	a4,0xe
    81001f42:	b8270713          	addi	a4,a4,-1150 # 8100fac0 <pid_lock>
    81001f46:	97ba                	add	a5,a5,a4
    81001f48:	0a87a703          	lw	a4,168(a5)
    81001f4c:	4785                	li	a5,1
    81001f4e:	06f71363          	bne	a4,a5,81001fb4 <sched+0x96>
  if(p->state == RUNNING)
    81001f52:	4c98                	lw	a4,24(s1)
    81001f54:	4791                	li	a5,4
    81001f56:	06f70563          	beq	a4,a5,81001fc0 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81001f5a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    81001f5e:	8b89                	andi	a5,a5,2
  if(intr_get())
    81001f60:	e7b5                	bnez	a5,81001fcc <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    81001f62:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    81001f64:	0000e917          	auipc	s2,0xe
    81001f68:	b5c90913          	addi	s2,s2,-1188 # 8100fac0 <pid_lock>
    81001f6c:	2781                	sext.w	a5,a5
    81001f6e:	079e                	slli	a5,a5,0x7
    81001f70:	97ca                	add	a5,a5,s2
    81001f72:	0ac7a983          	lw	s3,172(a5)
    81001f76:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    81001f78:	2781                	sext.w	a5,a5
    81001f7a:	079e                	slli	a5,a5,0x7
    81001f7c:	0000e597          	auipc	a1,0xe
    81001f80:	b7c58593          	addi	a1,a1,-1156 # 8100faf8 <cpus+0x8>
    81001f84:	95be                	add	a1,a1,a5
    81001f86:	06048513          	addi	a0,s1,96
    81001f8a:	508000ef          	jal	81002492 <swtch>
    81001f8e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    81001f90:	2781                	sext.w	a5,a5
    81001f92:	079e                	slli	a5,a5,0x7
    81001f94:	993e                	add	s2,s2,a5
    81001f96:	0b392623          	sw	s3,172(s2)
}
    81001f9a:	70a2                	ld	ra,40(sp)
    81001f9c:	7402                	ld	s0,32(sp)
    81001f9e:	64e2                	ld	s1,24(sp)
    81001fa0:	6942                	ld	s2,16(sp)
    81001fa2:	69a2                	ld	s3,8(sp)
    81001fa4:	6145                	addi	sp,sp,48
    81001fa6:	8082                	ret
    panic("sched p->lock");
    81001fa8:	00005517          	auipc	a0,0x5
    81001fac:	31850513          	addi	a0,a0,792 # 810072c0 <etext+0x2c0>
    81001fb0:	935fe0ef          	jal	810008e4 <panic>
    panic("sched locks");
    81001fb4:	00005517          	auipc	a0,0x5
    81001fb8:	31c50513          	addi	a0,a0,796 # 810072d0 <etext+0x2d0>
    81001fbc:	929fe0ef          	jal	810008e4 <panic>
    panic("sched running");
    81001fc0:	00005517          	auipc	a0,0x5
    81001fc4:	32050513          	addi	a0,a0,800 # 810072e0 <etext+0x2e0>
    81001fc8:	91dfe0ef          	jal	810008e4 <panic>
    panic("sched interruptible");
    81001fcc:	00005517          	auipc	a0,0x5
    81001fd0:	32450513          	addi	a0,a0,804 # 810072f0 <etext+0x2f0>
    81001fd4:	911fe0ef          	jal	810008e4 <panic>

0000000081001fd8 <yield>:
{
    81001fd8:	1101                	addi	sp,sp,-32
    81001fda:	ec06                	sd	ra,24(sp)
    81001fdc:	e822                	sd	s0,16(sp)
    81001fde:	e426                	sd	s1,8(sp)
    81001fe0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    81001fe2:	a55ff0ef          	jal	81001a36 <myproc>
    81001fe6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    81001fe8:	d61fe0ef          	jal	81000d48 <acquire>
  p->state = RUNNABLE;
    81001fec:	478d                	li	a5,3
    81001fee:	cc9c                	sw	a5,24(s1)
  sched();
    81001ff0:	f2fff0ef          	jal	81001f1e <sched>
  release(&p->lock);
    81001ff4:	8526                	mv	a0,s1
    81001ff6:	de7fe0ef          	jal	81000ddc <release>
}
    81001ffa:	60e2                	ld	ra,24(sp)
    81001ffc:	6442                	ld	s0,16(sp)
    81001ffe:	64a2                	ld	s1,8(sp)
    81002000:	6105                	addi	sp,sp,32
    81002002:	8082                	ret

0000000081002004 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    81002004:	7179                	addi	sp,sp,-48
    81002006:	f406                	sd	ra,40(sp)
    81002008:	f022                	sd	s0,32(sp)
    8100200a:	ec26                	sd	s1,24(sp)
    8100200c:	e84a                	sd	s2,16(sp)
    8100200e:	e44e                	sd	s3,8(sp)
    81002010:	1800                	addi	s0,sp,48
    81002012:	89aa                	mv	s3,a0
    81002014:	892e                	mv	s2,a1
  struct proc *p = myproc();
    81002016:	a21ff0ef          	jal	81001a36 <myproc>
    8100201a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8100201c:	d2dfe0ef          	jal	81000d48 <acquire>
  release(lk);
    81002020:	854a                	mv	a0,s2
    81002022:	dbbfe0ef          	jal	81000ddc <release>

  // Go to sleep.
  p->chan = chan;
    81002026:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8100202a:	4789                	li	a5,2
    8100202c:	cc9c                	sw	a5,24(s1)

  sched();
    8100202e:	ef1ff0ef          	jal	81001f1e <sched>

  // Tidy up.
  p->chan = 0;
    81002032:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    81002036:	8526                	mv	a0,s1
    81002038:	da5fe0ef          	jal	81000ddc <release>
  acquire(lk);
    8100203c:	854a                	mv	a0,s2
    8100203e:	d0bfe0ef          	jal	81000d48 <acquire>
}
    81002042:	70a2                	ld	ra,40(sp)
    81002044:	7402                	ld	s0,32(sp)
    81002046:	64e2                	ld	s1,24(sp)
    81002048:	6942                	ld	s2,16(sp)
    8100204a:	69a2                	ld	s3,8(sp)
    8100204c:	6145                	addi	sp,sp,48
    8100204e:	8082                	ret

0000000081002050 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    81002050:	7139                	addi	sp,sp,-64
    81002052:	fc06                	sd	ra,56(sp)
    81002054:	f822                	sd	s0,48(sp)
    81002056:	f426                	sd	s1,40(sp)
    81002058:	f04a                	sd	s2,32(sp)
    8100205a:	ec4e                	sd	s3,24(sp)
    8100205c:	e852                	sd	s4,16(sp)
    8100205e:	e456                	sd	s5,8(sp)
    81002060:	0080                	addi	s0,sp,64
    81002062:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    81002064:	0000e497          	auipc	s1,0xe
    81002068:	e8c48493          	addi	s1,s1,-372 # 8100fef0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8100206c:	4989                	li	s3,2
        p->state = RUNNABLE;
    8100206e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    81002070:	00014917          	auipc	s2,0x14
    81002074:	88090913          	addi	s2,s2,-1920 # 810158f0 <tickslock>
    81002078:	a801                	j	81002088 <wakeup+0x38>
      }
      release(&p->lock);
    8100207a:	8526                	mv	a0,s1
    8100207c:	d61fe0ef          	jal	81000ddc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    81002080:	16848493          	addi	s1,s1,360
    81002084:	03248263          	beq	s1,s2,810020a8 <wakeup+0x58>
    if(p != myproc()){
    81002088:	9afff0ef          	jal	81001a36 <myproc>
    8100208c:	fea48ae3          	beq	s1,a0,81002080 <wakeup+0x30>
      acquire(&p->lock);
    81002090:	8526                	mv	a0,s1
    81002092:	cb7fe0ef          	jal	81000d48 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    81002096:	4c9c                	lw	a5,24(s1)
    81002098:	ff3791e3          	bne	a5,s3,8100207a <wakeup+0x2a>
    8100209c:	709c                	ld	a5,32(s1)
    8100209e:	fd479ee3          	bne	a5,s4,8100207a <wakeup+0x2a>
        p->state = RUNNABLE;
    810020a2:	0154ac23          	sw	s5,24(s1)
    810020a6:	bfd1                	j	8100207a <wakeup+0x2a>
    }
  }
}
    810020a8:	70e2                	ld	ra,56(sp)
    810020aa:	7442                	ld	s0,48(sp)
    810020ac:	74a2                	ld	s1,40(sp)
    810020ae:	7902                	ld	s2,32(sp)
    810020b0:	69e2                	ld	s3,24(sp)
    810020b2:	6a42                	ld	s4,16(sp)
    810020b4:	6aa2                	ld	s5,8(sp)
    810020b6:	6121                	addi	sp,sp,64
    810020b8:	8082                	ret

00000000810020ba <reparent>:
{
    810020ba:	7179                	addi	sp,sp,-48
    810020bc:	f406                	sd	ra,40(sp)
    810020be:	f022                	sd	s0,32(sp)
    810020c0:	ec26                	sd	s1,24(sp)
    810020c2:	e84a                	sd	s2,16(sp)
    810020c4:	e44e                	sd	s3,8(sp)
    810020c6:	e052                	sd	s4,0(sp)
    810020c8:	1800                	addi	s0,sp,48
    810020ca:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    810020cc:	0000e497          	auipc	s1,0xe
    810020d0:	e2448493          	addi	s1,s1,-476 # 8100fef0 <proc>
      pp->parent = initproc;
    810020d4:	00006a17          	auipc	s4,0x6
    810020d8:	8b4a0a13          	addi	s4,s4,-1868 # 81007988 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    810020dc:	00014997          	auipc	s3,0x14
    810020e0:	81498993          	addi	s3,s3,-2028 # 810158f0 <tickslock>
    810020e4:	a029                	j	810020ee <reparent+0x34>
    810020e6:	16848493          	addi	s1,s1,360
    810020ea:	01348b63          	beq	s1,s3,81002100 <reparent+0x46>
    if(pp->parent == p){
    810020ee:	7c9c                	ld	a5,56(s1)
    810020f0:	ff279be3          	bne	a5,s2,810020e6 <reparent+0x2c>
      pp->parent = initproc;
    810020f4:	000a3503          	ld	a0,0(s4)
    810020f8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    810020fa:	f57ff0ef          	jal	81002050 <wakeup>
    810020fe:	b7e5                	j	810020e6 <reparent+0x2c>
}
    81002100:	70a2                	ld	ra,40(sp)
    81002102:	7402                	ld	s0,32(sp)
    81002104:	64e2                	ld	s1,24(sp)
    81002106:	6942                	ld	s2,16(sp)
    81002108:	69a2                	ld	s3,8(sp)
    8100210a:	6a02                	ld	s4,0(sp)
    8100210c:	6145                	addi	sp,sp,48
    8100210e:	8082                	ret

0000000081002110 <exit>:
{
    81002110:	7179                	addi	sp,sp,-48
    81002112:	f406                	sd	ra,40(sp)
    81002114:	f022                	sd	s0,32(sp)
    81002116:	ec26                	sd	s1,24(sp)
    81002118:	e84a                	sd	s2,16(sp)
    8100211a:	e44e                	sd	s3,8(sp)
    8100211c:	e052                	sd	s4,0(sp)
    8100211e:	1800                	addi	s0,sp,48
    81002120:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    81002122:	915ff0ef          	jal	81001a36 <myproc>
    81002126:	89aa                	mv	s3,a0
  if(p == initproc)
    81002128:	00006797          	auipc	a5,0x6
    8100212c:	8607b783          	ld	a5,-1952(a5) # 81007988 <initproc>
    81002130:	0d050493          	addi	s1,a0,208
    81002134:	15050913          	addi	s2,a0,336
    81002138:	00a79b63          	bne	a5,a0,8100214e <exit+0x3e>
    panic("init exiting");
    8100213c:	00005517          	auipc	a0,0x5
    81002140:	1cc50513          	addi	a0,a0,460 # 81007308 <etext+0x308>
    81002144:	fa0fe0ef          	jal	810008e4 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    81002148:	04a1                	addi	s1,s1,8
    8100214a:	01248963          	beq	s1,s2,8100215c <exit+0x4c>
    if(p->ofile[fd]){
    8100214e:	6088                	ld	a0,0(s1)
    81002150:	dd65                	beqz	a0,81002148 <exit+0x38>
      fileclose(f);
    81002152:	667010ef          	jal	81003fb8 <fileclose>
      p->ofile[fd] = 0;
    81002156:	0004b023          	sd	zero,0(s1)
    8100215a:	b7fd                	j	81002148 <exit+0x38>
  begin_op();
    8100215c:	23d010ef          	jal	81003b98 <begin_op>
  iput(p->cwd);
    81002160:	1509b503          	ld	a0,336(s3)
    81002164:	304010ef          	jal	81003468 <iput>
  end_op();
    81002168:	29b010ef          	jal	81003c02 <end_op>
  p->cwd = 0;
    8100216c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    81002170:	0000e497          	auipc	s1,0xe
    81002174:	96848493          	addi	s1,s1,-1688 # 8100fad8 <wait_lock>
    81002178:	8526                	mv	a0,s1
    8100217a:	bcffe0ef          	jal	81000d48 <acquire>
  reparent(p);
    8100217e:	854e                	mv	a0,s3
    81002180:	f3bff0ef          	jal	810020ba <reparent>
  wakeup(p->parent);
    81002184:	0389b503          	ld	a0,56(s3)
    81002188:	ec9ff0ef          	jal	81002050 <wakeup>
  acquire(&p->lock);
    8100218c:	854e                	mv	a0,s3
    8100218e:	bbbfe0ef          	jal	81000d48 <acquire>
  p->xstate = status;
    81002192:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    81002196:	4795                	li	a5,5
    81002198:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8100219c:	8526                	mv	a0,s1
    8100219e:	c3ffe0ef          	jal	81000ddc <release>
  sched();
    810021a2:	d7dff0ef          	jal	81001f1e <sched>
  panic("zombie exit");
    810021a6:	00005517          	auipc	a0,0x5
    810021aa:	17250513          	addi	a0,a0,370 # 81007318 <etext+0x318>
    810021ae:	f36fe0ef          	jal	810008e4 <panic>

00000000810021b2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    810021b2:	7179                	addi	sp,sp,-48
    810021b4:	f406                	sd	ra,40(sp)
    810021b6:	f022                	sd	s0,32(sp)
    810021b8:	ec26                	sd	s1,24(sp)
    810021ba:	e84a                	sd	s2,16(sp)
    810021bc:	e44e                	sd	s3,8(sp)
    810021be:	1800                	addi	s0,sp,48
    810021c0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    810021c2:	0000e497          	auipc	s1,0xe
    810021c6:	d2e48493          	addi	s1,s1,-722 # 8100fef0 <proc>
    810021ca:	00013997          	auipc	s3,0x13
    810021ce:	72698993          	addi	s3,s3,1830 # 810158f0 <tickslock>
    acquire(&p->lock);
    810021d2:	8526                	mv	a0,s1
    810021d4:	b75fe0ef          	jal	81000d48 <acquire>
    if(p->pid == pid){
    810021d8:	589c                	lw	a5,48(s1)
    810021da:	01278b63          	beq	a5,s2,810021f0 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    810021de:	8526                	mv	a0,s1
    810021e0:	bfdfe0ef          	jal	81000ddc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    810021e4:	16848493          	addi	s1,s1,360
    810021e8:	ff3495e3          	bne	s1,s3,810021d2 <kill+0x20>
  }
  return -1;
    810021ec:	557d                	li	a0,-1
    810021ee:	a819                	j	81002204 <kill+0x52>
      p->killed = 1;
    810021f0:	4785                	li	a5,1
    810021f2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    810021f4:	4c98                	lw	a4,24(s1)
    810021f6:	4789                	li	a5,2
    810021f8:	00f70d63          	beq	a4,a5,81002212 <kill+0x60>
      release(&p->lock);
    810021fc:	8526                	mv	a0,s1
    810021fe:	bdffe0ef          	jal	81000ddc <release>
      return 0;
    81002202:	4501                	li	a0,0
}
    81002204:	70a2                	ld	ra,40(sp)
    81002206:	7402                	ld	s0,32(sp)
    81002208:	64e2                	ld	s1,24(sp)
    8100220a:	6942                	ld	s2,16(sp)
    8100220c:	69a2                	ld	s3,8(sp)
    8100220e:	6145                	addi	sp,sp,48
    81002210:	8082                	ret
        p->state = RUNNABLE;
    81002212:	478d                	li	a5,3
    81002214:	cc9c                	sw	a5,24(s1)
    81002216:	b7dd                	j	810021fc <kill+0x4a>

0000000081002218 <setkilled>:

void
setkilled(struct proc *p)
{
    81002218:	1101                	addi	sp,sp,-32
    8100221a:	ec06                	sd	ra,24(sp)
    8100221c:	e822                	sd	s0,16(sp)
    8100221e:	e426                	sd	s1,8(sp)
    81002220:	1000                	addi	s0,sp,32
    81002222:	84aa                	mv	s1,a0
  acquire(&p->lock);
    81002224:	b25fe0ef          	jal	81000d48 <acquire>
  p->killed = 1;
    81002228:	4785                	li	a5,1
    8100222a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8100222c:	8526                	mv	a0,s1
    8100222e:	baffe0ef          	jal	81000ddc <release>
}
    81002232:	60e2                	ld	ra,24(sp)
    81002234:	6442                	ld	s0,16(sp)
    81002236:	64a2                	ld	s1,8(sp)
    81002238:	6105                	addi	sp,sp,32
    8100223a:	8082                	ret

000000008100223c <killed>:

int
killed(struct proc *p)
{
    8100223c:	1101                	addi	sp,sp,-32
    8100223e:	ec06                	sd	ra,24(sp)
    81002240:	e822                	sd	s0,16(sp)
    81002242:	e426                	sd	s1,8(sp)
    81002244:	e04a                	sd	s2,0(sp)
    81002246:	1000                	addi	s0,sp,32
    81002248:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8100224a:	afffe0ef          	jal	81000d48 <acquire>
  k = p->killed;
    8100224e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    81002252:	8526                	mv	a0,s1
    81002254:	b89fe0ef          	jal	81000ddc <release>
  return k;
}
    81002258:	854a                	mv	a0,s2
    8100225a:	60e2                	ld	ra,24(sp)
    8100225c:	6442                	ld	s0,16(sp)
    8100225e:	64a2                	ld	s1,8(sp)
    81002260:	6902                	ld	s2,0(sp)
    81002262:	6105                	addi	sp,sp,32
    81002264:	8082                	ret

0000000081002266 <wait>:
{
    81002266:	715d                	addi	sp,sp,-80
    81002268:	e486                	sd	ra,72(sp)
    8100226a:	e0a2                	sd	s0,64(sp)
    8100226c:	fc26                	sd	s1,56(sp)
    8100226e:	f84a                	sd	s2,48(sp)
    81002270:	f44e                	sd	s3,40(sp)
    81002272:	f052                	sd	s4,32(sp)
    81002274:	ec56                	sd	s5,24(sp)
    81002276:	e85a                	sd	s6,16(sp)
    81002278:	e45e                	sd	s7,8(sp)
    8100227a:	0880                	addi	s0,sp,80
    8100227c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8100227e:	fb8ff0ef          	jal	81001a36 <myproc>
    81002282:	892a                	mv	s2,a0
  acquire(&wait_lock);
    81002284:	0000e517          	auipc	a0,0xe
    81002288:	85450513          	addi	a0,a0,-1964 # 8100fad8 <wait_lock>
    8100228c:	abdfe0ef          	jal	81000d48 <acquire>
        if(pp->state == ZOMBIE){
    81002290:	4a15                	li	s4,5
        havekids = 1;
    81002292:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    81002294:	00013997          	auipc	s3,0x13
    81002298:	65c98993          	addi	s3,s3,1628 # 810158f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8100229c:	0000eb97          	auipc	s7,0xe
    810022a0:	83cb8b93          	addi	s7,s7,-1988 # 8100fad8 <wait_lock>
    810022a4:	a869                	j	8100233e <wait+0xd8>
          pid = pp->pid;
    810022a6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    810022aa:	000b0c63          	beqz	s6,810022c2 <wait+0x5c>
    810022ae:	4691                	li	a3,4
    810022b0:	02c48613          	addi	a2,s1,44
    810022b4:	85da                	mv	a1,s6
    810022b6:	05093503          	ld	a0,80(s2)
    810022ba:	c24ff0ef          	jal	810016de <copyout>
    810022be:	02054a63          	bltz	a0,810022f2 <wait+0x8c>
          freeproc(pp);
    810022c2:	8526                	mv	a0,s1
    810022c4:	8e5ff0ef          	jal	81001ba8 <freeproc>
          release(&pp->lock);
    810022c8:	8526                	mv	a0,s1
    810022ca:	b13fe0ef          	jal	81000ddc <release>
          release(&wait_lock);
    810022ce:	0000e517          	auipc	a0,0xe
    810022d2:	80a50513          	addi	a0,a0,-2038 # 8100fad8 <wait_lock>
    810022d6:	b07fe0ef          	jal	81000ddc <release>
}
    810022da:	854e                	mv	a0,s3
    810022dc:	60a6                	ld	ra,72(sp)
    810022de:	6406                	ld	s0,64(sp)
    810022e0:	74e2                	ld	s1,56(sp)
    810022e2:	7942                	ld	s2,48(sp)
    810022e4:	79a2                	ld	s3,40(sp)
    810022e6:	7a02                	ld	s4,32(sp)
    810022e8:	6ae2                	ld	s5,24(sp)
    810022ea:	6b42                	ld	s6,16(sp)
    810022ec:	6ba2                	ld	s7,8(sp)
    810022ee:	6161                	addi	sp,sp,80
    810022f0:	8082                	ret
            release(&pp->lock);
    810022f2:	8526                	mv	a0,s1
    810022f4:	ae9fe0ef          	jal	81000ddc <release>
            release(&wait_lock);
    810022f8:	0000d517          	auipc	a0,0xd
    810022fc:	7e050513          	addi	a0,a0,2016 # 8100fad8 <wait_lock>
    81002300:	addfe0ef          	jal	81000ddc <release>
            return -1;
    81002304:	59fd                	li	s3,-1
    81002306:	bfd1                	j	810022da <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    81002308:	16848493          	addi	s1,s1,360
    8100230c:	03348063          	beq	s1,s3,8100232c <wait+0xc6>
      if(pp->parent == p){
    81002310:	7c9c                	ld	a5,56(s1)
    81002312:	ff279be3          	bne	a5,s2,81002308 <wait+0xa2>
        acquire(&pp->lock);
    81002316:	8526                	mv	a0,s1
    81002318:	a31fe0ef          	jal	81000d48 <acquire>
        if(pp->state == ZOMBIE){
    8100231c:	4c9c                	lw	a5,24(s1)
    8100231e:	f94784e3          	beq	a5,s4,810022a6 <wait+0x40>
        release(&pp->lock);
    81002322:	8526                	mv	a0,s1
    81002324:	ab9fe0ef          	jal	81000ddc <release>
        havekids = 1;
    81002328:	8756                	mv	a4,s5
    8100232a:	bff9                	j	81002308 <wait+0xa2>
    if(!havekids || killed(p)){
    8100232c:	cf19                	beqz	a4,8100234a <wait+0xe4>
    8100232e:	854a                	mv	a0,s2
    81002330:	f0dff0ef          	jal	8100223c <killed>
    81002334:	e919                	bnez	a0,8100234a <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    81002336:	85de                	mv	a1,s7
    81002338:	854a                	mv	a0,s2
    8100233a:	ccbff0ef          	jal	81002004 <sleep>
    havekids = 0;
    8100233e:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    81002340:	0000e497          	auipc	s1,0xe
    81002344:	bb048493          	addi	s1,s1,-1104 # 8100fef0 <proc>
    81002348:	b7e1                	j	81002310 <wait+0xaa>
      release(&wait_lock);
    8100234a:	0000d517          	auipc	a0,0xd
    8100234e:	78e50513          	addi	a0,a0,1934 # 8100fad8 <wait_lock>
    81002352:	a8bfe0ef          	jal	81000ddc <release>
      return -1;
    81002356:	59fd                	li	s3,-1
    81002358:	b749                	j	810022da <wait+0x74>

000000008100235a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8100235a:	7179                	addi	sp,sp,-48
    8100235c:	f406                	sd	ra,40(sp)
    8100235e:	f022                	sd	s0,32(sp)
    81002360:	ec26                	sd	s1,24(sp)
    81002362:	e84a                	sd	s2,16(sp)
    81002364:	e44e                	sd	s3,8(sp)
    81002366:	e052                	sd	s4,0(sp)
    81002368:	1800                	addi	s0,sp,48
    8100236a:	84aa                	mv	s1,a0
    8100236c:	892e                	mv	s2,a1
    8100236e:	89b2                	mv	s3,a2
    81002370:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    81002372:	ec4ff0ef          	jal	81001a36 <myproc>
  if(user_dst){
    81002376:	cc99                	beqz	s1,81002394 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    81002378:	86d2                	mv	a3,s4
    8100237a:	864e                	mv	a2,s3
    8100237c:	85ca                	mv	a1,s2
    8100237e:	6928                	ld	a0,80(a0)
    81002380:	b5eff0ef          	jal	810016de <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    81002384:	70a2                	ld	ra,40(sp)
    81002386:	7402                	ld	s0,32(sp)
    81002388:	64e2                	ld	s1,24(sp)
    8100238a:	6942                	ld	s2,16(sp)
    8100238c:	69a2                	ld	s3,8(sp)
    8100238e:	6a02                	ld	s4,0(sp)
    81002390:	6145                	addi	sp,sp,48
    81002392:	8082                	ret
    memmove((char *)dst, src, len);
    81002394:	000a061b          	sext.w	a2,s4
    81002398:	85ce                	mv	a1,s3
    8100239a:	854a                	mv	a0,s2
    8100239c:	ae1fe0ef          	jal	81000e7c <memmove>
    return 0;
    810023a0:	8526                	mv	a0,s1
    810023a2:	b7cd                	j	81002384 <either_copyout+0x2a>

00000000810023a4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    810023a4:	7179                	addi	sp,sp,-48
    810023a6:	f406                	sd	ra,40(sp)
    810023a8:	f022                	sd	s0,32(sp)
    810023aa:	ec26                	sd	s1,24(sp)
    810023ac:	e84a                	sd	s2,16(sp)
    810023ae:	e44e                	sd	s3,8(sp)
    810023b0:	e052                	sd	s4,0(sp)
    810023b2:	1800                	addi	s0,sp,48
    810023b4:	892a                	mv	s2,a0
    810023b6:	84ae                	mv	s1,a1
    810023b8:	89b2                	mv	s3,a2
    810023ba:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    810023bc:	e7aff0ef          	jal	81001a36 <myproc>
  if(user_src){
    810023c0:	cc99                	beqz	s1,810023de <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    810023c2:	86d2                	mv	a3,s4
    810023c4:	864e                	mv	a2,s3
    810023c6:	85ca                	mv	a1,s2
    810023c8:	6928                	ld	a0,80(a0)
    810023ca:	bc4ff0ef          	jal	8100178e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    810023ce:	70a2                	ld	ra,40(sp)
    810023d0:	7402                	ld	s0,32(sp)
    810023d2:	64e2                	ld	s1,24(sp)
    810023d4:	6942                	ld	s2,16(sp)
    810023d6:	69a2                	ld	s3,8(sp)
    810023d8:	6a02                	ld	s4,0(sp)
    810023da:	6145                	addi	sp,sp,48
    810023dc:	8082                	ret
    memmove(dst, (char*)src, len);
    810023de:	000a061b          	sext.w	a2,s4
    810023e2:	85ce                	mv	a1,s3
    810023e4:	854a                	mv	a0,s2
    810023e6:	a97fe0ef          	jal	81000e7c <memmove>
    return 0;
    810023ea:	8526                	mv	a0,s1
    810023ec:	b7cd                	j	810023ce <either_copyin+0x2a>

00000000810023ee <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    810023ee:	715d                	addi	sp,sp,-80
    810023f0:	e486                	sd	ra,72(sp)
    810023f2:	e0a2                	sd	s0,64(sp)
    810023f4:	fc26                	sd	s1,56(sp)
    810023f6:	f84a                	sd	s2,48(sp)
    810023f8:	f44e                	sd	s3,40(sp)
    810023fa:	f052                	sd	s4,32(sp)
    810023fc:	ec56                	sd	s5,24(sp)
    810023fe:	e85a                	sd	s6,16(sp)
    81002400:	e45e                	sd	s7,8(sp)
    81002402:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    81002404:	00005517          	auipc	a0,0x5
    81002408:	d1450513          	addi	a0,a0,-748 # 81007118 <etext+0x118>
    8100240c:	a08fe0ef          	jal	81000614 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    81002410:	0000e497          	auipc	s1,0xe
    81002414:	c3848493          	addi	s1,s1,-968 # 81010048 <proc+0x158>
    81002418:	00013917          	auipc	s2,0x13
    8100241c:	63090913          	addi	s2,s2,1584 # 81015a48 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    81002420:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    81002422:	00005997          	auipc	s3,0x5
    81002426:	f0698993          	addi	s3,s3,-250 # 81007328 <etext+0x328>
    printf("%d %s %s", p->pid, state, p->name);
    8100242a:	00005a97          	auipc	s5,0x5
    8100242e:	f06a8a93          	addi	s5,s5,-250 # 81007330 <etext+0x330>
    printf("\n");
    81002432:	00005a17          	auipc	s4,0x5
    81002436:	ce6a0a13          	addi	s4,s4,-794 # 81007118 <etext+0x118>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8100243a:	00005b97          	auipc	s7,0x5
    8100243e:	3d6b8b93          	addi	s7,s7,982 # 81007810 <states.0>
    81002442:	a829                	j	8100245c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    81002444:	ed86a583          	lw	a1,-296(a3)
    81002448:	8556                	mv	a0,s5
    8100244a:	9cafe0ef          	jal	81000614 <printf>
    printf("\n");
    8100244e:	8552                	mv	a0,s4
    81002450:	9c4fe0ef          	jal	81000614 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    81002454:	16848493          	addi	s1,s1,360
    81002458:	03248263          	beq	s1,s2,8100247c <procdump+0x8e>
    if(p->state == UNUSED)
    8100245c:	86a6                	mv	a3,s1
    8100245e:	ec04a783          	lw	a5,-320(s1)
    81002462:	dbed                	beqz	a5,81002454 <procdump+0x66>
      state = "???";
    81002464:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    81002466:	fcfb6fe3          	bltu	s6,a5,81002444 <procdump+0x56>
    8100246a:	02079713          	slli	a4,a5,0x20
    8100246e:	01d75793          	srli	a5,a4,0x1d
    81002472:	97de                	add	a5,a5,s7
    81002474:	6390                	ld	a2,0(a5)
    81002476:	f679                	bnez	a2,81002444 <procdump+0x56>
      state = "???";
    81002478:	864e                	mv	a2,s3
    8100247a:	b7e9                	j	81002444 <procdump+0x56>
  }
}
    8100247c:	60a6                	ld	ra,72(sp)
    8100247e:	6406                	ld	s0,64(sp)
    81002480:	74e2                	ld	s1,56(sp)
    81002482:	7942                	ld	s2,48(sp)
    81002484:	79a2                	ld	s3,40(sp)
    81002486:	7a02                	ld	s4,32(sp)
    81002488:	6ae2                	ld	s5,24(sp)
    8100248a:	6b42                	ld	s6,16(sp)
    8100248c:	6ba2                	ld	s7,8(sp)
    8100248e:	6161                	addi	sp,sp,80
    81002490:	8082                	ret

0000000081002492 <swtch>:
    81002492:	00153023          	sd	ra,0(a0)
    81002496:	00253423          	sd	sp,8(a0)
    8100249a:	e900                	sd	s0,16(a0)
    8100249c:	ed04                	sd	s1,24(a0)
    8100249e:	03253023          	sd	s2,32(a0)
    810024a2:	03353423          	sd	s3,40(a0)
    810024a6:	03453823          	sd	s4,48(a0)
    810024aa:	03553c23          	sd	s5,56(a0)
    810024ae:	05653023          	sd	s6,64(a0)
    810024b2:	05753423          	sd	s7,72(a0)
    810024b6:	05853823          	sd	s8,80(a0)
    810024ba:	05953c23          	sd	s9,88(a0)
    810024be:	07a53023          	sd	s10,96(a0)
    810024c2:	07b53423          	sd	s11,104(a0)
    810024c6:	0005b083          	ld	ra,0(a1)
    810024ca:	0085b103          	ld	sp,8(a1)
    810024ce:	6980                	ld	s0,16(a1)
    810024d0:	6d84                	ld	s1,24(a1)
    810024d2:	0205b903          	ld	s2,32(a1)
    810024d6:	0285b983          	ld	s3,40(a1)
    810024da:	0305ba03          	ld	s4,48(a1)
    810024de:	0385ba83          	ld	s5,56(a1)
    810024e2:	0405bb03          	ld	s6,64(a1)
    810024e6:	0485bb83          	ld	s7,72(a1)
    810024ea:	0505bc03          	ld	s8,80(a1)
    810024ee:	0585bc83          	ld	s9,88(a1)
    810024f2:	0605bd03          	ld	s10,96(a1)
    810024f6:	0685bd83          	ld	s11,104(a1)
    810024fa:	8082                	ret

00000000810024fc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    810024fc:	1141                	addi	sp,sp,-16
    810024fe:	e406                	sd	ra,8(sp)
    81002500:	e022                	sd	s0,0(sp)
    81002502:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    81002504:	00005597          	auipc	a1,0x5
    81002508:	e6c58593          	addi	a1,a1,-404 # 81007370 <etext+0x370>
    8100250c:	00013517          	auipc	a0,0x13
    81002510:	3e450513          	addi	a0,a0,996 # 810158f0 <tickslock>
    81002514:	fb0fe0ef          	jal	81000cc4 <initlock>
}
    81002518:	60a2                	ld	ra,8(sp)
    8100251a:	6402                	ld	s0,0(sp)
    8100251c:	0141                	addi	sp,sp,16
    8100251e:	8082                	ret

0000000081002520 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    81002520:	1141                	addi	sp,sp,-16
    81002522:	e406                	sd	ra,8(sp)
    81002524:	e022                	sd	s0,0(sp)
    81002526:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    81002528:	00003797          	auipc	a5,0x3
    8100252c:	e4878793          	addi	a5,a5,-440 # 81005370 <kernelvec>
    81002530:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    81002534:	60a2                	ld	ra,8(sp)
    81002536:	6402                	ld	s0,0(sp)
    81002538:	0141                	addi	sp,sp,16
    8100253a:	8082                	ret

000000008100253c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8100253c:	1141                	addi	sp,sp,-16
    8100253e:	e406                	sd	ra,8(sp)
    81002540:	e022                	sd	s0,0(sp)
    81002542:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    81002544:	cf2ff0ef          	jal	81001a36 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81002548:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8100254c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8100254e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    81002552:	00004697          	auipc	a3,0x4
    81002556:	aae68693          	addi	a3,a3,-1362 # 81006000 <_trampoline>
    8100255a:	00004717          	auipc	a4,0x4
    8100255e:	aa670713          	addi	a4,a4,-1370 # 81006000 <_trampoline>
    81002562:	8f15                	sub	a4,a4,a3
    81002564:	040007b7          	lui	a5,0x4000
    81002568:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7d000001>
    8100256a:	07b2                	slli	a5,a5,0xc
    8100256c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8100256e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    81002572:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    81002574:	18002673          	csrr	a2,satp
    81002578:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8100257a:	6d30                	ld	a2,88(a0)
    8100257c:	6138                	ld	a4,64(a0)
    8100257e:	6585                	lui	a1,0x1
    81002580:	972e                	add	a4,a4,a1
    81002582:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    81002584:	6d38                	ld	a4,88(a0)
    81002586:	00000617          	auipc	a2,0x0
    8100258a:	11060613          	addi	a2,a2,272 # 81002696 <usertrap>
    8100258e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    81002590:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    81002592:	8612                	mv	a2,tp
    81002594:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81002596:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8100259a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8100259e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    810025a2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    810025a6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    810025a8:	6f18                	ld	a4,24(a4)
    810025aa:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    810025ae:	6928                	ld	a0,80(a0)
    810025b0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    810025b2:	00004717          	auipc	a4,0x4
    810025b6:	aea70713          	addi	a4,a4,-1302 # 8100609c <userret>
    810025ba:	8f15                	sub	a4,a4,a3
    810025bc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    810025be:	577d                	li	a4,-1
    810025c0:	177e                	slli	a4,a4,0x3f
    810025c2:	8d59                	or	a0,a0,a4
    810025c4:	9782                	jalr	a5
}
    810025c6:	60a2                	ld	ra,8(sp)
    810025c8:	6402                	ld	s0,0(sp)
    810025ca:	0141                	addi	sp,sp,16
    810025cc:	8082                	ret

00000000810025ce <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    810025ce:	1101                	addi	sp,sp,-32
    810025d0:	ec06                	sd	ra,24(sp)
    810025d2:	e822                	sd	s0,16(sp)
    810025d4:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    810025d6:	c2cff0ef          	jal	81001a02 <cpuid>
    810025da:	cd11                	beqz	a0,810025f6 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    810025dc:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    810025e0:	000f4737          	lui	a4,0xf4
    810025e4:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x80f0bdc0>
    810025e8:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    810025ea:	14d79073          	csrw	stimecmp,a5
}
    810025ee:	60e2                	ld	ra,24(sp)
    810025f0:	6442                	ld	s0,16(sp)
    810025f2:	6105                	addi	sp,sp,32
    810025f4:	8082                	ret
    810025f6:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    810025f8:	00013497          	auipc	s1,0x13
    810025fc:	2f848493          	addi	s1,s1,760 # 810158f0 <tickslock>
    81002600:	8526                	mv	a0,s1
    81002602:	f46fe0ef          	jal	81000d48 <acquire>
    ticks++;
    81002606:	00005517          	auipc	a0,0x5
    8100260a:	38a50513          	addi	a0,a0,906 # 81007990 <ticks>
    8100260e:	411c                	lw	a5,0(a0)
    81002610:	2785                	addiw	a5,a5,1
    81002612:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    81002614:	a3dff0ef          	jal	81002050 <wakeup>
    release(&tickslock);
    81002618:	8526                	mv	a0,s1
    8100261a:	fc2fe0ef          	jal	81000ddc <release>
    8100261e:	64a2                	ld	s1,8(sp)
    81002620:	bf75                	j	810025dc <clockintr+0xe>

0000000081002622 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    81002622:	1101                	addi	sp,sp,-32
    81002624:	ec06                	sd	ra,24(sp)
    81002626:	e822                	sd	s0,16(sp)
    81002628:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8100262a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8100262e:	57fd                	li	a5,-1
    81002630:	17fe                	slli	a5,a5,0x3f
    81002632:	07a5                	addi	a5,a5,9
    81002634:	00f70c63          	beq	a4,a5,8100264c <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    81002638:	57fd                	li	a5,-1
    8100263a:	17fe                	slli	a5,a5,0x3f
    8100263c:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8100263e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    81002640:	04f70763          	beq	a4,a5,8100268e <devintr+0x6c>
  }
}
    81002644:	60e2                	ld	ra,24(sp)
    81002646:	6442                	ld	s0,16(sp)
    81002648:	6105                	addi	sp,sp,32
    8100264a:	8082                	ret
    8100264c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8100264e:	5cf020ef          	jal	8100541c <plic_claim>
    81002652:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    81002654:	47a9                	li	a5,10
    81002656:	00f50963          	beq	a0,a5,81002668 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8100265a:	4785                	li	a5,1
    8100265c:	00f50963          	beq	a0,a5,8100266e <devintr+0x4c>
    return 1;
    81002660:	4505                	li	a0,1
    } else if(irq){
    81002662:	e889                	bnez	s1,81002674 <devintr+0x52>
    81002664:	64a2                	ld	s1,8(sp)
    81002666:	bff9                	j	81002644 <devintr+0x22>
      uartintr();
    81002668:	ceafe0ef          	jal	81000b52 <uartintr>
    if(irq)
    8100266c:	a819                	j	81002682 <devintr+0x60>
      virtio_disk_intr();
    8100266e:	23e030ef          	jal	810058ac <virtio_disk_intr>
    if(irq)
    81002672:	a801                	j	81002682 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    81002674:	85a6                	mv	a1,s1
    81002676:	00005517          	auipc	a0,0x5
    8100267a:	d0250513          	addi	a0,a0,-766 # 81007378 <etext+0x378>
    8100267e:	f97fd0ef          	jal	81000614 <printf>
      plic_complete(irq);
    81002682:	8526                	mv	a0,s1
    81002684:	5b9020ef          	jal	8100543c <plic_complete>
    return 1;
    81002688:	4505                	li	a0,1
    8100268a:	64a2                	ld	s1,8(sp)
    8100268c:	bf65                	j	81002644 <devintr+0x22>
    clockintr();
    8100268e:	f41ff0ef          	jal	810025ce <clockintr>
    return 2;
    81002692:	4509                	li	a0,2
    81002694:	bf45                	j	81002644 <devintr+0x22>

0000000081002696 <usertrap>:
{
    81002696:	1101                	addi	sp,sp,-32
    81002698:	ec06                	sd	ra,24(sp)
    8100269a:	e822                	sd	s0,16(sp)
    8100269c:	e426                	sd	s1,8(sp)
    8100269e:	e04a                	sd	s2,0(sp)
    810026a0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    810026a2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    810026a6:	1007f793          	andi	a5,a5,256
    810026aa:	ef85                	bnez	a5,810026e2 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    810026ac:	00003797          	auipc	a5,0x3
    810026b0:	cc478793          	addi	a5,a5,-828 # 81005370 <kernelvec>
    810026b4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    810026b8:	b7eff0ef          	jal	81001a36 <myproc>
    810026bc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    810026be:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    810026c0:	14102773          	csrr	a4,sepc
    810026c4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    810026c6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    810026ca:	47a1                	li	a5,8
    810026cc:	02f70163          	beq	a4,a5,810026ee <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    810026d0:	f53ff0ef          	jal	81002622 <devintr>
    810026d4:	892a                	mv	s2,a0
    810026d6:	c135                	beqz	a0,8100273a <usertrap+0xa4>
  if(killed(p))
    810026d8:	8526                	mv	a0,s1
    810026da:	b63ff0ef          	jal	8100223c <killed>
    810026de:	cd1d                	beqz	a0,8100271c <usertrap+0x86>
    810026e0:	a81d                	j	81002716 <usertrap+0x80>
    panic("usertrap: not from user mode");
    810026e2:	00005517          	auipc	a0,0x5
    810026e6:	cb650513          	addi	a0,a0,-842 # 81007398 <etext+0x398>
    810026ea:	9fafe0ef          	jal	810008e4 <panic>
    if(killed(p))
    810026ee:	b4fff0ef          	jal	8100223c <killed>
    810026f2:	e121                	bnez	a0,81002732 <usertrap+0x9c>
    p->trapframe->epc += 4;
    810026f4:	6cb8                	ld	a4,88(s1)
    810026f6:	6f1c                	ld	a5,24(a4)
    810026f8:	0791                	addi	a5,a5,4
    810026fa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    810026fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    81002700:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    81002704:	10079073          	csrw	sstatus,a5
    syscall();
    81002708:	240000ef          	jal	81002948 <syscall>
  if(killed(p))
    8100270c:	8526                	mv	a0,s1
    8100270e:	b2fff0ef          	jal	8100223c <killed>
    81002712:	c901                	beqz	a0,81002722 <usertrap+0x8c>
    81002714:	4901                	li	s2,0
    exit(-1);
    81002716:	557d                	li	a0,-1
    81002718:	9f9ff0ef          	jal	81002110 <exit>
  if(which_dev == 2)
    8100271c:	4789                	li	a5,2
    8100271e:	04f90563          	beq	s2,a5,81002768 <usertrap+0xd2>
  usertrapret();
    81002722:	e1bff0ef          	jal	8100253c <usertrapret>
}
    81002726:	60e2                	ld	ra,24(sp)
    81002728:	6442                	ld	s0,16(sp)
    8100272a:	64a2                	ld	s1,8(sp)
    8100272c:	6902                	ld	s2,0(sp)
    8100272e:	6105                	addi	sp,sp,32
    81002730:	8082                	ret
      exit(-1);
    81002732:	557d                	li	a0,-1
    81002734:	9ddff0ef          	jal	81002110 <exit>
    81002738:	bf75                	j	810026f4 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8100273a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8100273e:	5890                	lw	a2,48(s1)
    81002740:	00005517          	auipc	a0,0x5
    81002744:	c7850513          	addi	a0,a0,-904 # 810073b8 <etext+0x3b8>
    81002748:	ecdfd0ef          	jal	81000614 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8100274c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    81002750:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    81002754:	00005517          	auipc	a0,0x5
    81002758:	c9450513          	addi	a0,a0,-876 # 810073e8 <etext+0x3e8>
    8100275c:	eb9fd0ef          	jal	81000614 <printf>
    setkilled(p);
    81002760:	8526                	mv	a0,s1
    81002762:	ab7ff0ef          	jal	81002218 <setkilled>
    81002766:	b75d                	j	8100270c <usertrap+0x76>
    yield();
    81002768:	871ff0ef          	jal	81001fd8 <yield>
    8100276c:	bf5d                	j	81002722 <usertrap+0x8c>

000000008100276e <kerneltrap>:
{
    8100276e:	7179                	addi	sp,sp,-48
    81002770:	f406                	sd	ra,40(sp)
    81002772:	f022                	sd	s0,32(sp)
    81002774:	ec26                	sd	s1,24(sp)
    81002776:	e84a                	sd	s2,16(sp)
    81002778:	e44e                	sd	s3,8(sp)
    8100277a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8100277c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    81002780:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    81002784:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    81002788:	1004f793          	andi	a5,s1,256
    8100278c:	c795                	beqz	a5,810027b8 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8100278e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    81002792:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    81002794:	eb85                	bnez	a5,810027c4 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    81002796:	e8dff0ef          	jal	81002622 <devintr>
    8100279a:	c91d                	beqz	a0,810027d0 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    8100279c:	4789                	li	a5,2
    8100279e:	04f50a63          	beq	a0,a5,810027f2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    810027a2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    810027a6:	10049073          	csrw	sstatus,s1
}
    810027aa:	70a2                	ld	ra,40(sp)
    810027ac:	7402                	ld	s0,32(sp)
    810027ae:	64e2                	ld	s1,24(sp)
    810027b0:	6942                	ld	s2,16(sp)
    810027b2:	69a2                	ld	s3,8(sp)
    810027b4:	6145                	addi	sp,sp,48
    810027b6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    810027b8:	00005517          	auipc	a0,0x5
    810027bc:	c5850513          	addi	a0,a0,-936 # 81007410 <etext+0x410>
    810027c0:	924fe0ef          	jal	810008e4 <panic>
    panic("kerneltrap: interrupts enabled");
    810027c4:	00005517          	auipc	a0,0x5
    810027c8:	c7450513          	addi	a0,a0,-908 # 81007438 <etext+0x438>
    810027cc:	918fe0ef          	jal	810008e4 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    810027d0:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    810027d4:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    810027d8:	85ce                	mv	a1,s3
    810027da:	00005517          	auipc	a0,0x5
    810027de:	c7e50513          	addi	a0,a0,-898 # 81007458 <etext+0x458>
    810027e2:	e33fd0ef          	jal	81000614 <printf>
    panic("kerneltrap");
    810027e6:	00005517          	auipc	a0,0x5
    810027ea:	c9a50513          	addi	a0,a0,-870 # 81007480 <etext+0x480>
    810027ee:	8f6fe0ef          	jal	810008e4 <panic>
  if(which_dev == 2 && myproc() != 0)
    810027f2:	a44ff0ef          	jal	81001a36 <myproc>
    810027f6:	d555                	beqz	a0,810027a2 <kerneltrap+0x34>
    yield();
    810027f8:	fe0ff0ef          	jal	81001fd8 <yield>
    810027fc:	b75d                	j	810027a2 <kerneltrap+0x34>

00000000810027fe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    810027fe:	1101                	addi	sp,sp,-32
    81002800:	ec06                	sd	ra,24(sp)
    81002802:	e822                	sd	s0,16(sp)
    81002804:	e426                	sd	s1,8(sp)
    81002806:	1000                	addi	s0,sp,32
    81002808:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8100280a:	a2cff0ef          	jal	81001a36 <myproc>
  switch (n) {
    8100280e:	4795                	li	a5,5
    81002810:	0497e163          	bltu	a5,s1,81002852 <argraw+0x54>
    81002814:	048a                	slli	s1,s1,0x2
    81002816:	00005717          	auipc	a4,0x5
    8100281a:	02a70713          	addi	a4,a4,42 # 81007840 <states.0+0x30>
    8100281e:	94ba                	add	s1,s1,a4
    81002820:	409c                	lw	a5,0(s1)
    81002822:	97ba                	add	a5,a5,a4
    81002824:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    81002826:	6d3c                	ld	a5,88(a0)
    81002828:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8100282a:	60e2                	ld	ra,24(sp)
    8100282c:	6442                	ld	s0,16(sp)
    8100282e:	64a2                	ld	s1,8(sp)
    81002830:	6105                	addi	sp,sp,32
    81002832:	8082                	ret
    return p->trapframe->a1;
    81002834:	6d3c                	ld	a5,88(a0)
    81002836:	7fa8                	ld	a0,120(a5)
    81002838:	bfcd                	j	8100282a <argraw+0x2c>
    return p->trapframe->a2;
    8100283a:	6d3c                	ld	a5,88(a0)
    8100283c:	63c8                	ld	a0,128(a5)
    8100283e:	b7f5                	j	8100282a <argraw+0x2c>
    return p->trapframe->a3;
    81002840:	6d3c                	ld	a5,88(a0)
    81002842:	67c8                	ld	a0,136(a5)
    81002844:	b7dd                	j	8100282a <argraw+0x2c>
    return p->trapframe->a4;
    81002846:	6d3c                	ld	a5,88(a0)
    81002848:	6bc8                	ld	a0,144(a5)
    8100284a:	b7c5                	j	8100282a <argraw+0x2c>
    return p->trapframe->a5;
    8100284c:	6d3c                	ld	a5,88(a0)
    8100284e:	6fc8                	ld	a0,152(a5)
    81002850:	bfe9                	j	8100282a <argraw+0x2c>
  panic("argraw");
    81002852:	00005517          	auipc	a0,0x5
    81002856:	c3e50513          	addi	a0,a0,-962 # 81007490 <etext+0x490>
    8100285a:	88afe0ef          	jal	810008e4 <panic>

000000008100285e <fetchaddr>:
{
    8100285e:	1101                	addi	sp,sp,-32
    81002860:	ec06                	sd	ra,24(sp)
    81002862:	e822                	sd	s0,16(sp)
    81002864:	e426                	sd	s1,8(sp)
    81002866:	e04a                	sd	s2,0(sp)
    81002868:	1000                	addi	s0,sp,32
    8100286a:	84aa                	mv	s1,a0
    8100286c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8100286e:	9c8ff0ef          	jal	81001a36 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    81002872:	653c                	ld	a5,72(a0)
    81002874:	02f4f663          	bgeu	s1,a5,810028a0 <fetchaddr+0x42>
    81002878:	00848713          	addi	a4,s1,8
    8100287c:	02e7e463          	bltu	a5,a4,810028a4 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    81002880:	46a1                	li	a3,8
    81002882:	8626                	mv	a2,s1
    81002884:	85ca                	mv	a1,s2
    81002886:	6928                	ld	a0,80(a0)
    81002888:	f07fe0ef          	jal	8100178e <copyin>
    8100288c:	00a03533          	snez	a0,a0
    81002890:	40a0053b          	negw	a0,a0
}
    81002894:	60e2                	ld	ra,24(sp)
    81002896:	6442                	ld	s0,16(sp)
    81002898:	64a2                	ld	s1,8(sp)
    8100289a:	6902                	ld	s2,0(sp)
    8100289c:	6105                	addi	sp,sp,32
    8100289e:	8082                	ret
    return -1;
    810028a0:	557d                	li	a0,-1
    810028a2:	bfcd                	j	81002894 <fetchaddr+0x36>
    810028a4:	557d                	li	a0,-1
    810028a6:	b7fd                	j	81002894 <fetchaddr+0x36>

00000000810028a8 <fetchstr>:
{
    810028a8:	7179                	addi	sp,sp,-48
    810028aa:	f406                	sd	ra,40(sp)
    810028ac:	f022                	sd	s0,32(sp)
    810028ae:	ec26                	sd	s1,24(sp)
    810028b0:	e84a                	sd	s2,16(sp)
    810028b2:	e44e                	sd	s3,8(sp)
    810028b4:	1800                	addi	s0,sp,48
    810028b6:	892a                	mv	s2,a0
    810028b8:	84ae                	mv	s1,a1
    810028ba:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    810028bc:	97aff0ef          	jal	81001a36 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    810028c0:	86ce                	mv	a3,s3
    810028c2:	864a                	mv	a2,s2
    810028c4:	85a6                	mv	a1,s1
    810028c6:	6928                	ld	a0,80(a0)
    810028c8:	f4dfe0ef          	jal	81001814 <copyinstr>
    810028cc:	00054c63          	bltz	a0,810028e4 <fetchstr+0x3c>
  return strlen(buf);
    810028d0:	8526                	mv	a0,s1
    810028d2:	ecefe0ef          	jal	81000fa0 <strlen>
}
    810028d6:	70a2                	ld	ra,40(sp)
    810028d8:	7402                	ld	s0,32(sp)
    810028da:	64e2                	ld	s1,24(sp)
    810028dc:	6942                	ld	s2,16(sp)
    810028de:	69a2                	ld	s3,8(sp)
    810028e0:	6145                	addi	sp,sp,48
    810028e2:	8082                	ret
    return -1;
    810028e4:	557d                	li	a0,-1
    810028e6:	bfc5                	j	810028d6 <fetchstr+0x2e>

00000000810028e8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    810028e8:	1101                	addi	sp,sp,-32
    810028ea:	ec06                	sd	ra,24(sp)
    810028ec:	e822                	sd	s0,16(sp)
    810028ee:	e426                	sd	s1,8(sp)
    810028f0:	1000                	addi	s0,sp,32
    810028f2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    810028f4:	f0bff0ef          	jal	810027fe <argraw>
    810028f8:	c088                	sw	a0,0(s1)
}
    810028fa:	60e2                	ld	ra,24(sp)
    810028fc:	6442                	ld	s0,16(sp)
    810028fe:	64a2                	ld	s1,8(sp)
    81002900:	6105                	addi	sp,sp,32
    81002902:	8082                	ret

0000000081002904 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    81002904:	1101                	addi	sp,sp,-32
    81002906:	ec06                	sd	ra,24(sp)
    81002908:	e822                	sd	s0,16(sp)
    8100290a:	e426                	sd	s1,8(sp)
    8100290c:	1000                	addi	s0,sp,32
    8100290e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    81002910:	eefff0ef          	jal	810027fe <argraw>
    81002914:	e088                	sd	a0,0(s1)
}
    81002916:	60e2                	ld	ra,24(sp)
    81002918:	6442                	ld	s0,16(sp)
    8100291a:	64a2                	ld	s1,8(sp)
    8100291c:	6105                	addi	sp,sp,32
    8100291e:	8082                	ret

0000000081002920 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    81002920:	1101                	addi	sp,sp,-32
    81002922:	ec06                	sd	ra,24(sp)
    81002924:	e822                	sd	s0,16(sp)
    81002926:	e426                	sd	s1,8(sp)
    81002928:	e04a                	sd	s2,0(sp)
    8100292a:	1000                	addi	s0,sp,32
    8100292c:	84ae                	mv	s1,a1
    8100292e:	8932                	mv	s2,a2
  *ip = argraw(n);
    81002930:	ecfff0ef          	jal	810027fe <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    81002934:	864a                	mv	a2,s2
    81002936:	85a6                	mv	a1,s1
    81002938:	f71ff0ef          	jal	810028a8 <fetchstr>
}
    8100293c:	60e2                	ld	ra,24(sp)
    8100293e:	6442                	ld	s0,16(sp)
    81002940:	64a2                	ld	s1,8(sp)
    81002942:	6902                	ld	s2,0(sp)
    81002944:	6105                	addi	sp,sp,32
    81002946:	8082                	ret

0000000081002948 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    81002948:	1101                	addi	sp,sp,-32
    8100294a:	ec06                	sd	ra,24(sp)
    8100294c:	e822                	sd	s0,16(sp)
    8100294e:	e426                	sd	s1,8(sp)
    81002950:	e04a                	sd	s2,0(sp)
    81002952:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    81002954:	8e2ff0ef          	jal	81001a36 <myproc>
    81002958:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8100295a:	05853903          	ld	s2,88(a0)
    8100295e:	0a893783          	ld	a5,168(s2)
    81002962:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    81002966:	37fd                	addiw	a5,a5,-1
    81002968:	4751                	li	a4,20
    8100296a:	00f76f63          	bltu	a4,a5,81002988 <syscall+0x40>
    8100296e:	00369713          	slli	a4,a3,0x3
    81002972:	00005797          	auipc	a5,0x5
    81002976:	ee678793          	addi	a5,a5,-282 # 81007858 <syscalls>
    8100297a:	97ba                	add	a5,a5,a4
    8100297c:	639c                	ld	a5,0(a5)
    8100297e:	c789                	beqz	a5,81002988 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    81002980:	9782                	jalr	a5
    81002982:	06a93823          	sd	a0,112(s2)
    81002986:	a829                	j	810029a0 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    81002988:	15848613          	addi	a2,s1,344
    8100298c:	588c                	lw	a1,48(s1)
    8100298e:	00005517          	auipc	a0,0x5
    81002992:	b0a50513          	addi	a0,a0,-1270 # 81007498 <etext+0x498>
    81002996:	c7ffd0ef          	jal	81000614 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8100299a:	6cbc                	ld	a5,88(s1)
    8100299c:	577d                	li	a4,-1
    8100299e:	fbb8                	sd	a4,112(a5)
  }
}
    810029a0:	60e2                	ld	ra,24(sp)
    810029a2:	6442                	ld	s0,16(sp)
    810029a4:	64a2                	ld	s1,8(sp)
    810029a6:	6902                	ld	s2,0(sp)
    810029a8:	6105                	addi	sp,sp,32
    810029aa:	8082                	ret

00000000810029ac <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    810029ac:	1101                	addi	sp,sp,-32
    810029ae:	ec06                	sd	ra,24(sp)
    810029b0:	e822                	sd	s0,16(sp)
    810029b2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    810029b4:	fec40593          	addi	a1,s0,-20
    810029b8:	4501                	li	a0,0
    810029ba:	f2fff0ef          	jal	810028e8 <argint>
  exit(n);
    810029be:	fec42503          	lw	a0,-20(s0)
    810029c2:	f4eff0ef          	jal	81002110 <exit>
  return 0;  // not reached
}
    810029c6:	4501                	li	a0,0
    810029c8:	60e2                	ld	ra,24(sp)
    810029ca:	6442                	ld	s0,16(sp)
    810029cc:	6105                	addi	sp,sp,32
    810029ce:	8082                	ret

00000000810029d0 <sys_getpid>:

uint64
sys_getpid(void)
{
    810029d0:	1141                	addi	sp,sp,-16
    810029d2:	e406                	sd	ra,8(sp)
    810029d4:	e022                	sd	s0,0(sp)
    810029d6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    810029d8:	85eff0ef          	jal	81001a36 <myproc>
}
    810029dc:	5908                	lw	a0,48(a0)
    810029de:	60a2                	ld	ra,8(sp)
    810029e0:	6402                	ld	s0,0(sp)
    810029e2:	0141                	addi	sp,sp,16
    810029e4:	8082                	ret

00000000810029e6 <sys_fork>:

uint64
sys_fork(void)
{
    810029e6:	1141                	addi	sp,sp,-16
    810029e8:	e406                	sd	ra,8(sp)
    810029ea:	e022                	sd	s0,0(sp)
    810029ec:	0800                	addi	s0,sp,16
  return fork();
    810029ee:	b6eff0ef          	jal	81001d5c <fork>
}
    810029f2:	60a2                	ld	ra,8(sp)
    810029f4:	6402                	ld	s0,0(sp)
    810029f6:	0141                	addi	sp,sp,16
    810029f8:	8082                	ret

00000000810029fa <sys_wait>:

uint64
sys_wait(void)
{
    810029fa:	1101                	addi	sp,sp,-32
    810029fc:	ec06                	sd	ra,24(sp)
    810029fe:	e822                	sd	s0,16(sp)
    81002a00:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    81002a02:	fe840593          	addi	a1,s0,-24
    81002a06:	4501                	li	a0,0
    81002a08:	efdff0ef          	jal	81002904 <argaddr>
  return wait(p);
    81002a0c:	fe843503          	ld	a0,-24(s0)
    81002a10:	857ff0ef          	jal	81002266 <wait>
}
    81002a14:	60e2                	ld	ra,24(sp)
    81002a16:	6442                	ld	s0,16(sp)
    81002a18:	6105                	addi	sp,sp,32
    81002a1a:	8082                	ret

0000000081002a1c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    81002a1c:	7179                	addi	sp,sp,-48
    81002a1e:	f406                	sd	ra,40(sp)
    81002a20:	f022                	sd	s0,32(sp)
    81002a22:	ec26                	sd	s1,24(sp)
    81002a24:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    81002a26:	fdc40593          	addi	a1,s0,-36
    81002a2a:	4501                	li	a0,0
    81002a2c:	ebdff0ef          	jal	810028e8 <argint>
  addr = myproc()->sz;
    81002a30:	806ff0ef          	jal	81001a36 <myproc>
    81002a34:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    81002a36:	fdc42503          	lw	a0,-36(s0)
    81002a3a:	ad2ff0ef          	jal	81001d0c <growproc>
    81002a3e:	00054863          	bltz	a0,81002a4e <sys_sbrk+0x32>
    return -1;
  return addr;
}
    81002a42:	8526                	mv	a0,s1
    81002a44:	70a2                	ld	ra,40(sp)
    81002a46:	7402                	ld	s0,32(sp)
    81002a48:	64e2                	ld	s1,24(sp)
    81002a4a:	6145                	addi	sp,sp,48
    81002a4c:	8082                	ret
    return -1;
    81002a4e:	54fd                	li	s1,-1
    81002a50:	bfcd                	j	81002a42 <sys_sbrk+0x26>

0000000081002a52 <sys_sleep>:

uint64
sys_sleep(void)
{
    81002a52:	7139                	addi	sp,sp,-64
    81002a54:	fc06                	sd	ra,56(sp)
    81002a56:	f822                	sd	s0,48(sp)
    81002a58:	f04a                	sd	s2,32(sp)
    81002a5a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    81002a5c:	fcc40593          	addi	a1,s0,-52
    81002a60:	4501                	li	a0,0
    81002a62:	e87ff0ef          	jal	810028e8 <argint>
  if(n < 0)
    81002a66:	fcc42783          	lw	a5,-52(s0)
    81002a6a:	0607c763          	bltz	a5,81002ad8 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    81002a6e:	00013517          	auipc	a0,0x13
    81002a72:	e8250513          	addi	a0,a0,-382 # 810158f0 <tickslock>
    81002a76:	ad2fe0ef          	jal	81000d48 <acquire>
  ticks0 = ticks;
    81002a7a:	00005917          	auipc	s2,0x5
    81002a7e:	f1692903          	lw	s2,-234(s2) # 81007990 <ticks>
  while(ticks - ticks0 < n){
    81002a82:	fcc42783          	lw	a5,-52(s0)
    81002a86:	cf8d                	beqz	a5,81002ac0 <sys_sleep+0x6e>
    81002a88:	f426                	sd	s1,40(sp)
    81002a8a:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    81002a8c:	00013997          	auipc	s3,0x13
    81002a90:	e6498993          	addi	s3,s3,-412 # 810158f0 <tickslock>
    81002a94:	00005497          	auipc	s1,0x5
    81002a98:	efc48493          	addi	s1,s1,-260 # 81007990 <ticks>
    if(killed(myproc())){
    81002a9c:	f9bfe0ef          	jal	81001a36 <myproc>
    81002aa0:	f9cff0ef          	jal	8100223c <killed>
    81002aa4:	ed0d                	bnez	a0,81002ade <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    81002aa6:	85ce                	mv	a1,s3
    81002aa8:	8526                	mv	a0,s1
    81002aaa:	d5aff0ef          	jal	81002004 <sleep>
  while(ticks - ticks0 < n){
    81002aae:	409c                	lw	a5,0(s1)
    81002ab0:	412787bb          	subw	a5,a5,s2
    81002ab4:	fcc42703          	lw	a4,-52(s0)
    81002ab8:	fee7e2e3          	bltu	a5,a4,81002a9c <sys_sleep+0x4a>
    81002abc:	74a2                	ld	s1,40(sp)
    81002abe:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    81002ac0:	00013517          	auipc	a0,0x13
    81002ac4:	e3050513          	addi	a0,a0,-464 # 810158f0 <tickslock>
    81002ac8:	b14fe0ef          	jal	81000ddc <release>
  return 0;
    81002acc:	4501                	li	a0,0
}
    81002ace:	70e2                	ld	ra,56(sp)
    81002ad0:	7442                	ld	s0,48(sp)
    81002ad2:	7902                	ld	s2,32(sp)
    81002ad4:	6121                	addi	sp,sp,64
    81002ad6:	8082                	ret
    n = 0;
    81002ad8:	fc042623          	sw	zero,-52(s0)
    81002adc:	bf49                	j	81002a6e <sys_sleep+0x1c>
      release(&tickslock);
    81002ade:	00013517          	auipc	a0,0x13
    81002ae2:	e1250513          	addi	a0,a0,-494 # 810158f0 <tickslock>
    81002ae6:	af6fe0ef          	jal	81000ddc <release>
      return -1;
    81002aea:	557d                	li	a0,-1
    81002aec:	74a2                	ld	s1,40(sp)
    81002aee:	69e2                	ld	s3,24(sp)
    81002af0:	bff9                	j	81002ace <sys_sleep+0x7c>

0000000081002af2 <sys_kill>:

uint64
sys_kill(void)
{
    81002af2:	1101                	addi	sp,sp,-32
    81002af4:	ec06                	sd	ra,24(sp)
    81002af6:	e822                	sd	s0,16(sp)
    81002af8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    81002afa:	fec40593          	addi	a1,s0,-20
    81002afe:	4501                	li	a0,0
    81002b00:	de9ff0ef          	jal	810028e8 <argint>
  return kill(pid);
    81002b04:	fec42503          	lw	a0,-20(s0)
    81002b08:	eaaff0ef          	jal	810021b2 <kill>
}
    81002b0c:	60e2                	ld	ra,24(sp)
    81002b0e:	6442                	ld	s0,16(sp)
    81002b10:	6105                	addi	sp,sp,32
    81002b12:	8082                	ret

0000000081002b14 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    81002b14:	1101                	addi	sp,sp,-32
    81002b16:	ec06                	sd	ra,24(sp)
    81002b18:	e822                	sd	s0,16(sp)
    81002b1a:	e426                	sd	s1,8(sp)
    81002b1c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    81002b1e:	00013517          	auipc	a0,0x13
    81002b22:	dd250513          	addi	a0,a0,-558 # 810158f0 <tickslock>
    81002b26:	a22fe0ef          	jal	81000d48 <acquire>
  xticks = ticks;
    81002b2a:	00005497          	auipc	s1,0x5
    81002b2e:	e664a483          	lw	s1,-410(s1) # 81007990 <ticks>
  release(&tickslock);
    81002b32:	00013517          	auipc	a0,0x13
    81002b36:	dbe50513          	addi	a0,a0,-578 # 810158f0 <tickslock>
    81002b3a:	aa2fe0ef          	jal	81000ddc <release>
  return xticks;
}
    81002b3e:	02049513          	slli	a0,s1,0x20
    81002b42:	9101                	srli	a0,a0,0x20
    81002b44:	60e2                	ld	ra,24(sp)
    81002b46:	6442                	ld	s0,16(sp)
    81002b48:	64a2                	ld	s1,8(sp)
    81002b4a:	6105                	addi	sp,sp,32
    81002b4c:	8082                	ret

0000000081002b4e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    81002b4e:	7179                	addi	sp,sp,-48
    81002b50:	f406                	sd	ra,40(sp)
    81002b52:	f022                	sd	s0,32(sp)
    81002b54:	ec26                	sd	s1,24(sp)
    81002b56:	e84a                	sd	s2,16(sp)
    81002b58:	e44e                	sd	s3,8(sp)
    81002b5a:	e052                	sd	s4,0(sp)
    81002b5c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    81002b5e:	00005597          	auipc	a1,0x5
    81002b62:	95a58593          	addi	a1,a1,-1702 # 810074b8 <etext+0x4b8>
    81002b66:	00013517          	auipc	a0,0x13
    81002b6a:	da250513          	addi	a0,a0,-606 # 81015908 <bcache>
    81002b6e:	956fe0ef          	jal	81000cc4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    81002b72:	0001b797          	auipc	a5,0x1b
    81002b76:	d9678793          	addi	a5,a5,-618 # 8101d908 <bcache+0x8000>
    81002b7a:	0001b717          	auipc	a4,0x1b
    81002b7e:	ff670713          	addi	a4,a4,-10 # 8101db70 <bcache+0x8268>
    81002b82:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    81002b86:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    81002b8a:	00013497          	auipc	s1,0x13
    81002b8e:	d9648493          	addi	s1,s1,-618 # 81015920 <bcache+0x18>
    b->next = bcache.head.next;
    81002b92:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    81002b94:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    81002b96:	00005a17          	auipc	s4,0x5
    81002b9a:	92aa0a13          	addi	s4,s4,-1750 # 810074c0 <etext+0x4c0>
    b->next = bcache.head.next;
    81002b9e:	2b893783          	ld	a5,696(s2)
    81002ba2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    81002ba4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    81002ba8:	85d2                	mv	a1,s4
    81002baa:	01048513          	addi	a0,s1,16
    81002bae:	244010ef          	jal	81003df2 <initsleeplock>
    bcache.head.next->prev = b;
    81002bb2:	2b893783          	ld	a5,696(s2)
    81002bb6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    81002bb8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    81002bbc:	45848493          	addi	s1,s1,1112
    81002bc0:	fd349fe3          	bne	s1,s3,81002b9e <binit+0x50>
  }
}
    81002bc4:	70a2                	ld	ra,40(sp)
    81002bc6:	7402                	ld	s0,32(sp)
    81002bc8:	64e2                	ld	s1,24(sp)
    81002bca:	6942                	ld	s2,16(sp)
    81002bcc:	69a2                	ld	s3,8(sp)
    81002bce:	6a02                	ld	s4,0(sp)
    81002bd0:	6145                	addi	sp,sp,48
    81002bd2:	8082                	ret

0000000081002bd4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    81002bd4:	7179                	addi	sp,sp,-48
    81002bd6:	f406                	sd	ra,40(sp)
    81002bd8:	f022                	sd	s0,32(sp)
    81002bda:	ec26                	sd	s1,24(sp)
    81002bdc:	e84a                	sd	s2,16(sp)
    81002bde:	e44e                	sd	s3,8(sp)
    81002be0:	1800                	addi	s0,sp,48
    81002be2:	892a                	mv	s2,a0
    81002be4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    81002be6:	00013517          	auipc	a0,0x13
    81002bea:	d2250513          	addi	a0,a0,-734 # 81015908 <bcache>
    81002bee:	95afe0ef          	jal	81000d48 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    81002bf2:	0001b497          	auipc	s1,0x1b
    81002bf6:	fce4b483          	ld	s1,-50(s1) # 8101dbc0 <bcache+0x82b8>
    81002bfa:	0001b797          	auipc	a5,0x1b
    81002bfe:	f7678793          	addi	a5,a5,-138 # 8101db70 <bcache+0x8268>
    81002c02:	02f48b63          	beq	s1,a5,81002c38 <bread+0x64>
    81002c06:	873e                	mv	a4,a5
    81002c08:	a021                	j	81002c10 <bread+0x3c>
    81002c0a:	68a4                	ld	s1,80(s1)
    81002c0c:	02e48663          	beq	s1,a4,81002c38 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    81002c10:	449c                	lw	a5,8(s1)
    81002c12:	ff279ce3          	bne	a5,s2,81002c0a <bread+0x36>
    81002c16:	44dc                	lw	a5,12(s1)
    81002c18:	ff3799e3          	bne	a5,s3,81002c0a <bread+0x36>
      b->refcnt++;
    81002c1c:	40bc                	lw	a5,64(s1)
    81002c1e:	2785                	addiw	a5,a5,1
    81002c20:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    81002c22:	00013517          	auipc	a0,0x13
    81002c26:	ce650513          	addi	a0,a0,-794 # 81015908 <bcache>
    81002c2a:	9b2fe0ef          	jal	81000ddc <release>
      acquiresleep(&b->lock);
    81002c2e:	01048513          	addi	a0,s1,16
    81002c32:	1f6010ef          	jal	81003e28 <acquiresleep>
      return b;
    81002c36:	a889                	j	81002c88 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    81002c38:	0001b497          	auipc	s1,0x1b
    81002c3c:	f804b483          	ld	s1,-128(s1) # 8101dbb8 <bcache+0x82b0>
    81002c40:	0001b797          	auipc	a5,0x1b
    81002c44:	f3078793          	addi	a5,a5,-208 # 8101db70 <bcache+0x8268>
    81002c48:	00f48863          	beq	s1,a5,81002c58 <bread+0x84>
    81002c4c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    81002c4e:	40bc                	lw	a5,64(s1)
    81002c50:	cb91                	beqz	a5,81002c64 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    81002c52:	64a4                	ld	s1,72(s1)
    81002c54:	fee49de3          	bne	s1,a4,81002c4e <bread+0x7a>
  panic("bget: no buffers");
    81002c58:	00005517          	auipc	a0,0x5
    81002c5c:	87050513          	addi	a0,a0,-1936 # 810074c8 <etext+0x4c8>
    81002c60:	c85fd0ef          	jal	810008e4 <panic>
      b->dev = dev;
    81002c64:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    81002c68:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    81002c6c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    81002c70:	4785                	li	a5,1
    81002c72:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    81002c74:	00013517          	auipc	a0,0x13
    81002c78:	c9450513          	addi	a0,a0,-876 # 81015908 <bcache>
    81002c7c:	960fe0ef          	jal	81000ddc <release>
      acquiresleep(&b->lock);
    81002c80:	01048513          	addi	a0,s1,16
    81002c84:	1a4010ef          	jal	81003e28 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    81002c88:	409c                	lw	a5,0(s1)
    81002c8a:	cb89                	beqz	a5,81002c9c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    81002c8c:	8526                	mv	a0,s1
    81002c8e:	70a2                	ld	ra,40(sp)
    81002c90:	7402                	ld	s0,32(sp)
    81002c92:	64e2                	ld	s1,24(sp)
    81002c94:	6942                	ld	s2,16(sp)
    81002c96:	69a2                	ld	s3,8(sp)
    81002c98:	6145                	addi	sp,sp,48
    81002c9a:	8082                	ret
    virtio_disk_rw(b, 0);
    81002c9c:	4581                	li	a1,0
    81002c9e:	8526                	mv	a0,s1
    81002ca0:	201020ef          	jal	810056a0 <virtio_disk_rw>
    b->valid = 1;
    81002ca4:	4785                	li	a5,1
    81002ca6:	c09c                	sw	a5,0(s1)
  return b;
    81002ca8:	b7d5                	j	81002c8c <bread+0xb8>

0000000081002caa <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    81002caa:	1101                	addi	sp,sp,-32
    81002cac:	ec06                	sd	ra,24(sp)
    81002cae:	e822                	sd	s0,16(sp)
    81002cb0:	e426                	sd	s1,8(sp)
    81002cb2:	1000                	addi	s0,sp,32
    81002cb4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    81002cb6:	0541                	addi	a0,a0,16
    81002cb8:	1ee010ef          	jal	81003ea6 <holdingsleep>
    81002cbc:	c911                	beqz	a0,81002cd0 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    81002cbe:	4585                	li	a1,1
    81002cc0:	8526                	mv	a0,s1
    81002cc2:	1df020ef          	jal	810056a0 <virtio_disk_rw>
}
    81002cc6:	60e2                	ld	ra,24(sp)
    81002cc8:	6442                	ld	s0,16(sp)
    81002cca:	64a2                	ld	s1,8(sp)
    81002ccc:	6105                	addi	sp,sp,32
    81002cce:	8082                	ret
    panic("bwrite");
    81002cd0:	00005517          	auipc	a0,0x5
    81002cd4:	81050513          	addi	a0,a0,-2032 # 810074e0 <etext+0x4e0>
    81002cd8:	c0dfd0ef          	jal	810008e4 <panic>

0000000081002cdc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    81002cdc:	1101                	addi	sp,sp,-32
    81002cde:	ec06                	sd	ra,24(sp)
    81002ce0:	e822                	sd	s0,16(sp)
    81002ce2:	e426                	sd	s1,8(sp)
    81002ce4:	e04a                	sd	s2,0(sp)
    81002ce6:	1000                	addi	s0,sp,32
    81002ce8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    81002cea:	01050913          	addi	s2,a0,16
    81002cee:	854a                	mv	a0,s2
    81002cf0:	1b6010ef          	jal	81003ea6 <holdingsleep>
    81002cf4:	c125                	beqz	a0,81002d54 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    81002cf6:	854a                	mv	a0,s2
    81002cf8:	176010ef          	jal	81003e6e <releasesleep>

  acquire(&bcache.lock);
    81002cfc:	00013517          	auipc	a0,0x13
    81002d00:	c0c50513          	addi	a0,a0,-1012 # 81015908 <bcache>
    81002d04:	844fe0ef          	jal	81000d48 <acquire>
  b->refcnt--;
    81002d08:	40bc                	lw	a5,64(s1)
    81002d0a:	37fd                	addiw	a5,a5,-1
    81002d0c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    81002d0e:	e79d                	bnez	a5,81002d3c <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    81002d10:	68b8                	ld	a4,80(s1)
    81002d12:	64bc                	ld	a5,72(s1)
    81002d14:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    81002d16:	68b8                	ld	a4,80(s1)
    81002d18:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    81002d1a:	0001b797          	auipc	a5,0x1b
    81002d1e:	bee78793          	addi	a5,a5,-1042 # 8101d908 <bcache+0x8000>
    81002d22:	2b87b703          	ld	a4,696(a5)
    81002d26:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    81002d28:	0001b717          	auipc	a4,0x1b
    81002d2c:	e4870713          	addi	a4,a4,-440 # 8101db70 <bcache+0x8268>
    81002d30:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    81002d32:	2b87b703          	ld	a4,696(a5)
    81002d36:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    81002d38:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    81002d3c:	00013517          	auipc	a0,0x13
    81002d40:	bcc50513          	addi	a0,a0,-1076 # 81015908 <bcache>
    81002d44:	898fe0ef          	jal	81000ddc <release>
}
    81002d48:	60e2                	ld	ra,24(sp)
    81002d4a:	6442                	ld	s0,16(sp)
    81002d4c:	64a2                	ld	s1,8(sp)
    81002d4e:	6902                	ld	s2,0(sp)
    81002d50:	6105                	addi	sp,sp,32
    81002d52:	8082                	ret
    panic("brelse");
    81002d54:	00004517          	auipc	a0,0x4
    81002d58:	79450513          	addi	a0,a0,1940 # 810074e8 <etext+0x4e8>
    81002d5c:	b89fd0ef          	jal	810008e4 <panic>

0000000081002d60 <bpin>:

void
bpin(struct buf *b) {
    81002d60:	1101                	addi	sp,sp,-32
    81002d62:	ec06                	sd	ra,24(sp)
    81002d64:	e822                	sd	s0,16(sp)
    81002d66:	e426                	sd	s1,8(sp)
    81002d68:	1000                	addi	s0,sp,32
    81002d6a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    81002d6c:	00013517          	auipc	a0,0x13
    81002d70:	b9c50513          	addi	a0,a0,-1124 # 81015908 <bcache>
    81002d74:	fd5fd0ef          	jal	81000d48 <acquire>
  b->refcnt++;
    81002d78:	40bc                	lw	a5,64(s1)
    81002d7a:	2785                	addiw	a5,a5,1
    81002d7c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    81002d7e:	00013517          	auipc	a0,0x13
    81002d82:	b8a50513          	addi	a0,a0,-1142 # 81015908 <bcache>
    81002d86:	856fe0ef          	jal	81000ddc <release>
}
    81002d8a:	60e2                	ld	ra,24(sp)
    81002d8c:	6442                	ld	s0,16(sp)
    81002d8e:	64a2                	ld	s1,8(sp)
    81002d90:	6105                	addi	sp,sp,32
    81002d92:	8082                	ret

0000000081002d94 <bunpin>:

void
bunpin(struct buf *b) {
    81002d94:	1101                	addi	sp,sp,-32
    81002d96:	ec06                	sd	ra,24(sp)
    81002d98:	e822                	sd	s0,16(sp)
    81002d9a:	e426                	sd	s1,8(sp)
    81002d9c:	1000                	addi	s0,sp,32
    81002d9e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    81002da0:	00013517          	auipc	a0,0x13
    81002da4:	b6850513          	addi	a0,a0,-1176 # 81015908 <bcache>
    81002da8:	fa1fd0ef          	jal	81000d48 <acquire>
  b->refcnt--;
    81002dac:	40bc                	lw	a5,64(s1)
    81002dae:	37fd                	addiw	a5,a5,-1
    81002db0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    81002db2:	00013517          	auipc	a0,0x13
    81002db6:	b5650513          	addi	a0,a0,-1194 # 81015908 <bcache>
    81002dba:	822fe0ef          	jal	81000ddc <release>
}
    81002dbe:	60e2                	ld	ra,24(sp)
    81002dc0:	6442                	ld	s0,16(sp)
    81002dc2:	64a2                	ld	s1,8(sp)
    81002dc4:	6105                	addi	sp,sp,32
    81002dc6:	8082                	ret

0000000081002dc8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    81002dc8:	1101                	addi	sp,sp,-32
    81002dca:	ec06                	sd	ra,24(sp)
    81002dcc:	e822                	sd	s0,16(sp)
    81002dce:	e426                	sd	s1,8(sp)
    81002dd0:	e04a                	sd	s2,0(sp)
    81002dd2:	1000                	addi	s0,sp,32
    81002dd4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    81002dd6:	00d5d79b          	srliw	a5,a1,0xd
    81002dda:	0001b597          	auipc	a1,0x1b
    81002dde:	20a5a583          	lw	a1,522(a1) # 8101dfe4 <sb+0x1c>
    81002de2:	9dbd                	addw	a1,a1,a5
    81002de4:	df1ff0ef          	jal	81002bd4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    81002de8:	0074f713          	andi	a4,s1,7
    81002dec:	4785                	li	a5,1
    81002dee:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    81002df2:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    81002df4:	90d9                	srli	s1,s1,0x36
    81002df6:	00950733          	add	a4,a0,s1
    81002dfa:	05874703          	lbu	a4,88(a4)
    81002dfe:	00e7f6b3          	and	a3,a5,a4
    81002e02:	c29d                	beqz	a3,81002e28 <bfree+0x60>
    81002e04:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    81002e06:	94aa                	add	s1,s1,a0
    81002e08:	fff7c793          	not	a5,a5
    81002e0c:	8f7d                	and	a4,a4,a5
    81002e0e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    81002e12:	711000ef          	jal	81003d22 <log_write>
  brelse(bp);
    81002e16:	854a                	mv	a0,s2
    81002e18:	ec5ff0ef          	jal	81002cdc <brelse>
}
    81002e1c:	60e2                	ld	ra,24(sp)
    81002e1e:	6442                	ld	s0,16(sp)
    81002e20:	64a2                	ld	s1,8(sp)
    81002e22:	6902                	ld	s2,0(sp)
    81002e24:	6105                	addi	sp,sp,32
    81002e26:	8082                	ret
    panic("freeing free block");
    81002e28:	00004517          	auipc	a0,0x4
    81002e2c:	6c850513          	addi	a0,a0,1736 # 810074f0 <etext+0x4f0>
    81002e30:	ab5fd0ef          	jal	810008e4 <panic>

0000000081002e34 <balloc>:
{
    81002e34:	715d                	addi	sp,sp,-80
    81002e36:	e486                	sd	ra,72(sp)
    81002e38:	e0a2                	sd	s0,64(sp)
    81002e3a:	fc26                	sd	s1,56(sp)
    81002e3c:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    81002e3e:	0001b797          	auipc	a5,0x1b
    81002e42:	18e7a783          	lw	a5,398(a5) # 8101dfcc <sb+0x4>
    81002e46:	0e078863          	beqz	a5,81002f36 <balloc+0x102>
    81002e4a:	f84a                	sd	s2,48(sp)
    81002e4c:	f44e                	sd	s3,40(sp)
    81002e4e:	f052                	sd	s4,32(sp)
    81002e50:	ec56                	sd	s5,24(sp)
    81002e52:	e85a                	sd	s6,16(sp)
    81002e54:	e45e                	sd	s7,8(sp)
    81002e56:	e062                	sd	s8,0(sp)
    81002e58:	8baa                	mv	s7,a0
    81002e5a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    81002e5c:	0001bb17          	auipc	s6,0x1b
    81002e60:	16cb0b13          	addi	s6,s6,364 # 8101dfc8 <sb>
      m = 1 << (bi % 8);
    81002e64:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    81002e66:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    81002e68:	6c09                	lui	s8,0x2
    81002e6a:	a09d                	j	81002ed0 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    81002e6c:	97ca                	add	a5,a5,s2
    81002e6e:	8e55                	or	a2,a2,a3
    81002e70:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    81002e74:	854a                	mv	a0,s2
    81002e76:	6ad000ef          	jal	81003d22 <log_write>
        brelse(bp);
    81002e7a:	854a                	mv	a0,s2
    81002e7c:	e61ff0ef          	jal	81002cdc <brelse>
  bp = bread(dev, bno);
    81002e80:	85a6                	mv	a1,s1
    81002e82:	855e                	mv	a0,s7
    81002e84:	d51ff0ef          	jal	81002bd4 <bread>
    81002e88:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    81002e8a:	40000613          	li	a2,1024
    81002e8e:	4581                	li	a1,0
    81002e90:	05850513          	addi	a0,a0,88
    81002e94:	f85fd0ef          	jal	81000e18 <memset>
  log_write(bp);
    81002e98:	854a                	mv	a0,s2
    81002e9a:	689000ef          	jal	81003d22 <log_write>
  brelse(bp);
    81002e9e:	854a                	mv	a0,s2
    81002ea0:	e3dff0ef          	jal	81002cdc <brelse>
}
    81002ea4:	7942                	ld	s2,48(sp)
    81002ea6:	79a2                	ld	s3,40(sp)
    81002ea8:	7a02                	ld	s4,32(sp)
    81002eaa:	6ae2                	ld	s5,24(sp)
    81002eac:	6b42                	ld	s6,16(sp)
    81002eae:	6ba2                	ld	s7,8(sp)
    81002eb0:	6c02                	ld	s8,0(sp)
}
    81002eb2:	8526                	mv	a0,s1
    81002eb4:	60a6                	ld	ra,72(sp)
    81002eb6:	6406                	ld	s0,64(sp)
    81002eb8:	74e2                	ld	s1,56(sp)
    81002eba:	6161                	addi	sp,sp,80
    81002ebc:	8082                	ret
    brelse(bp);
    81002ebe:	854a                	mv	a0,s2
    81002ec0:	e1dff0ef          	jal	81002cdc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    81002ec4:	015c0abb          	addw	s5,s8,s5
    81002ec8:	004b2783          	lw	a5,4(s6)
    81002ecc:	04fafe63          	bgeu	s5,a5,81002f28 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    81002ed0:	41fad79b          	sraiw	a5,s5,0x1f
    81002ed4:	0137d79b          	srliw	a5,a5,0x13
    81002ed8:	015787bb          	addw	a5,a5,s5
    81002edc:	40d7d79b          	sraiw	a5,a5,0xd
    81002ee0:	01cb2583          	lw	a1,28(s6)
    81002ee4:	9dbd                	addw	a1,a1,a5
    81002ee6:	855e                	mv	a0,s7
    81002ee8:	cedff0ef          	jal	81002bd4 <bread>
    81002eec:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    81002eee:	004b2503          	lw	a0,4(s6)
    81002ef2:	84d6                	mv	s1,s5
    81002ef4:	4701                	li	a4,0
    81002ef6:	fca4f4e3          	bgeu	s1,a0,81002ebe <balloc+0x8a>
      m = 1 << (bi % 8);
    81002efa:	00777693          	andi	a3,a4,7
    81002efe:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    81002f02:	41f7579b          	sraiw	a5,a4,0x1f
    81002f06:	01d7d79b          	srliw	a5,a5,0x1d
    81002f0a:	9fb9                	addw	a5,a5,a4
    81002f0c:	4037d79b          	sraiw	a5,a5,0x3
    81002f10:	00f90633          	add	a2,s2,a5
    81002f14:	05864603          	lbu	a2,88(a2)
    81002f18:	00c6f5b3          	and	a1,a3,a2
    81002f1c:	d9a1                	beqz	a1,81002e6c <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    81002f1e:	2705                	addiw	a4,a4,1
    81002f20:	2485                	addiw	s1,s1,1
    81002f22:	fd471ae3          	bne	a4,s4,81002ef6 <balloc+0xc2>
    81002f26:	bf61                	j	81002ebe <balloc+0x8a>
    81002f28:	7942                	ld	s2,48(sp)
    81002f2a:	79a2                	ld	s3,40(sp)
    81002f2c:	7a02                	ld	s4,32(sp)
    81002f2e:	6ae2                	ld	s5,24(sp)
    81002f30:	6b42                	ld	s6,16(sp)
    81002f32:	6ba2                	ld	s7,8(sp)
    81002f34:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    81002f36:	00004517          	auipc	a0,0x4
    81002f3a:	5d250513          	addi	a0,a0,1490 # 81007508 <etext+0x508>
    81002f3e:	ed6fd0ef          	jal	81000614 <printf>
  return 0;
    81002f42:	4481                	li	s1,0
    81002f44:	b7bd                	j	81002eb2 <balloc+0x7e>

0000000081002f46 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    81002f46:	7179                	addi	sp,sp,-48
    81002f48:	f406                	sd	ra,40(sp)
    81002f4a:	f022                	sd	s0,32(sp)
    81002f4c:	ec26                	sd	s1,24(sp)
    81002f4e:	e84a                	sd	s2,16(sp)
    81002f50:	e44e                	sd	s3,8(sp)
    81002f52:	1800                	addi	s0,sp,48
    81002f54:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    81002f56:	47ad                	li	a5,11
    81002f58:	02b7e363          	bltu	a5,a1,81002f7e <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    81002f5c:	02059793          	slli	a5,a1,0x20
    81002f60:	01e7d593          	srli	a1,a5,0x1e
    81002f64:	00b504b3          	add	s1,a0,a1
    81002f68:	0504a903          	lw	s2,80(s1)
    81002f6c:	06091363          	bnez	s2,81002fd2 <bmap+0x8c>
      addr = balloc(ip->dev);
    81002f70:	4108                	lw	a0,0(a0)
    81002f72:	ec3ff0ef          	jal	81002e34 <balloc>
    81002f76:	892a                	mv	s2,a0
      if(addr == 0)
    81002f78:	cd29                	beqz	a0,81002fd2 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    81002f7a:	c8a8                	sw	a0,80(s1)
    81002f7c:	a899                	j	81002fd2 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    81002f7e:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    81002f82:	0ff00793          	li	a5,255
    81002f86:	0697e963          	bltu	a5,s1,81002ff8 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    81002f8a:	08052903          	lw	s2,128(a0)
    81002f8e:	00091b63          	bnez	s2,81002fa4 <bmap+0x5e>
      addr = balloc(ip->dev);
    81002f92:	4108                	lw	a0,0(a0)
    81002f94:	ea1ff0ef          	jal	81002e34 <balloc>
    81002f98:	892a                	mv	s2,a0
      if(addr == 0)
    81002f9a:	cd05                	beqz	a0,81002fd2 <bmap+0x8c>
    81002f9c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    81002f9e:	08a9a023          	sw	a0,128(s3)
    81002fa2:	a011                	j	81002fa6 <bmap+0x60>
    81002fa4:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    81002fa6:	85ca                	mv	a1,s2
    81002fa8:	0009a503          	lw	a0,0(s3)
    81002fac:	c29ff0ef          	jal	81002bd4 <bread>
    81002fb0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    81002fb2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    81002fb6:	02049713          	slli	a4,s1,0x20
    81002fba:	01e75593          	srli	a1,a4,0x1e
    81002fbe:	00b784b3          	add	s1,a5,a1
    81002fc2:	0004a903          	lw	s2,0(s1)
    81002fc6:	00090e63          	beqz	s2,81002fe2 <bmap+0x9c>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    81002fca:	8552                	mv	a0,s4
    81002fcc:	d11ff0ef          	jal	81002cdc <brelse>
    return addr;
    81002fd0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    81002fd2:	854a                	mv	a0,s2
    81002fd4:	70a2                	ld	ra,40(sp)
    81002fd6:	7402                	ld	s0,32(sp)
    81002fd8:	64e2                	ld	s1,24(sp)
    81002fda:	6942                	ld	s2,16(sp)
    81002fdc:	69a2                	ld	s3,8(sp)
    81002fde:	6145                	addi	sp,sp,48
    81002fe0:	8082                	ret
      addr = balloc(ip->dev);
    81002fe2:	0009a503          	lw	a0,0(s3)
    81002fe6:	e4fff0ef          	jal	81002e34 <balloc>
    81002fea:	892a                	mv	s2,a0
      if(addr){
    81002fec:	dd79                	beqz	a0,81002fca <bmap+0x84>
        a[bn] = addr;
    81002fee:	c088                	sw	a0,0(s1)
        log_write(bp);
    81002ff0:	8552                	mv	a0,s4
    81002ff2:	531000ef          	jal	81003d22 <log_write>
    81002ff6:	bfd1                	j	81002fca <bmap+0x84>
    81002ff8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    81002ffa:	00004517          	auipc	a0,0x4
    81002ffe:	52650513          	addi	a0,a0,1318 # 81007520 <etext+0x520>
    81003002:	8e3fd0ef          	jal	810008e4 <panic>

0000000081003006 <iget>:
{
    81003006:	7179                	addi	sp,sp,-48
    81003008:	f406                	sd	ra,40(sp)
    8100300a:	f022                	sd	s0,32(sp)
    8100300c:	ec26                	sd	s1,24(sp)
    8100300e:	e84a                	sd	s2,16(sp)
    81003010:	e44e                	sd	s3,8(sp)
    81003012:	e052                	sd	s4,0(sp)
    81003014:	1800                	addi	s0,sp,48
    81003016:	89aa                	mv	s3,a0
    81003018:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8100301a:	0001b517          	auipc	a0,0x1b
    8100301e:	fce50513          	addi	a0,a0,-50 # 8101dfe8 <itable>
    81003022:	d27fd0ef          	jal	81000d48 <acquire>
  empty = 0;
    81003026:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    81003028:	0001b497          	auipc	s1,0x1b
    8100302c:	fd848493          	addi	s1,s1,-40 # 8101e000 <itable+0x18>
    81003030:	0001d697          	auipc	a3,0x1d
    81003034:	a6068693          	addi	a3,a3,-1440 # 8101fa90 <log>
    81003038:	a039                	j	81003046 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8100303a:	02090963          	beqz	s2,8100306c <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8100303e:	08848493          	addi	s1,s1,136
    81003042:	02d48863          	beq	s1,a3,81003072 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    81003046:	449c                	lw	a5,8(s1)
    81003048:	fef059e3          	blez	a5,8100303a <iget+0x34>
    8100304c:	4098                	lw	a4,0(s1)
    8100304e:	ff3716e3          	bne	a4,s3,8100303a <iget+0x34>
    81003052:	40d8                	lw	a4,4(s1)
    81003054:	ff4713e3          	bne	a4,s4,8100303a <iget+0x34>
      ip->ref++;
    81003058:	2785                	addiw	a5,a5,1
    8100305a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8100305c:	0001b517          	auipc	a0,0x1b
    81003060:	f8c50513          	addi	a0,a0,-116 # 8101dfe8 <itable>
    81003064:	d79fd0ef          	jal	81000ddc <release>
      return ip;
    81003068:	8926                	mv	s2,s1
    8100306a:	a02d                	j	81003094 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8100306c:	fbe9                	bnez	a5,8100303e <iget+0x38>
      empty = ip;
    8100306e:	8926                	mv	s2,s1
    81003070:	b7f9                	j	8100303e <iget+0x38>
  if(empty == 0)
    81003072:	02090a63          	beqz	s2,810030a6 <iget+0xa0>
  ip->dev = dev;
    81003076:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8100307a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8100307e:	4785                	li	a5,1
    81003080:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    81003084:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    81003088:	0001b517          	auipc	a0,0x1b
    8100308c:	f6050513          	addi	a0,a0,-160 # 8101dfe8 <itable>
    81003090:	d4dfd0ef          	jal	81000ddc <release>
}
    81003094:	854a                	mv	a0,s2
    81003096:	70a2                	ld	ra,40(sp)
    81003098:	7402                	ld	s0,32(sp)
    8100309a:	64e2                	ld	s1,24(sp)
    8100309c:	6942                	ld	s2,16(sp)
    8100309e:	69a2                	ld	s3,8(sp)
    810030a0:	6a02                	ld	s4,0(sp)
    810030a2:	6145                	addi	sp,sp,48
    810030a4:	8082                	ret
    panic("iget: no inodes");
    810030a6:	00004517          	auipc	a0,0x4
    810030aa:	49250513          	addi	a0,a0,1170 # 81007538 <etext+0x538>
    810030ae:	837fd0ef          	jal	810008e4 <panic>

00000000810030b2 <fsinit>:
fsinit(int dev) {
    810030b2:	7179                	addi	sp,sp,-48
    810030b4:	f406                	sd	ra,40(sp)
    810030b6:	f022                	sd	s0,32(sp)
    810030b8:	ec26                	sd	s1,24(sp)
    810030ba:	e84a                	sd	s2,16(sp)
    810030bc:	e44e                	sd	s3,8(sp)
    810030be:	1800                	addi	s0,sp,48
    810030c0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    810030c2:	4585                	li	a1,1
    810030c4:	b11ff0ef          	jal	81002bd4 <bread>
    810030c8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    810030ca:	0001b997          	auipc	s3,0x1b
    810030ce:	efe98993          	addi	s3,s3,-258 # 8101dfc8 <sb>
    810030d2:	02000613          	li	a2,32
    810030d6:	05850593          	addi	a1,a0,88
    810030da:	854e                	mv	a0,s3
    810030dc:	da1fd0ef          	jal	81000e7c <memmove>
  brelse(bp);
    810030e0:	8526                	mv	a0,s1
    810030e2:	bfbff0ef          	jal	81002cdc <brelse>
  if(sb.magic != FSMAGIC)
    810030e6:	0009a703          	lw	a4,0(s3)
    810030ea:	102037b7          	lui	a5,0x10203
    810030ee:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x70dfcfc0>
    810030f2:	02f71063          	bne	a4,a5,81003112 <fsinit+0x60>
  initlog(dev, &sb);
    810030f6:	0001b597          	auipc	a1,0x1b
    810030fa:	ed258593          	addi	a1,a1,-302 # 8101dfc8 <sb>
    810030fe:	854a                	mv	a0,s2
    81003100:	215000ef          	jal	81003b14 <initlog>
}
    81003104:	70a2                	ld	ra,40(sp)
    81003106:	7402                	ld	s0,32(sp)
    81003108:	64e2                	ld	s1,24(sp)
    8100310a:	6942                	ld	s2,16(sp)
    8100310c:	69a2                	ld	s3,8(sp)
    8100310e:	6145                	addi	sp,sp,48
    81003110:	8082                	ret
    panic("invalid file system");
    81003112:	00004517          	auipc	a0,0x4
    81003116:	43650513          	addi	a0,a0,1078 # 81007548 <etext+0x548>
    8100311a:	fcafd0ef          	jal	810008e4 <panic>

000000008100311e <iinit>:
{
    8100311e:	7179                	addi	sp,sp,-48
    81003120:	f406                	sd	ra,40(sp)
    81003122:	f022                	sd	s0,32(sp)
    81003124:	ec26                	sd	s1,24(sp)
    81003126:	e84a                	sd	s2,16(sp)
    81003128:	e44e                	sd	s3,8(sp)
    8100312a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8100312c:	00004597          	auipc	a1,0x4
    81003130:	43458593          	addi	a1,a1,1076 # 81007560 <etext+0x560>
    81003134:	0001b517          	auipc	a0,0x1b
    81003138:	eb450513          	addi	a0,a0,-332 # 8101dfe8 <itable>
    8100313c:	b89fd0ef          	jal	81000cc4 <initlock>
  for(i = 0; i < NINODE; i++) {
    81003140:	0001b497          	auipc	s1,0x1b
    81003144:	ed048493          	addi	s1,s1,-304 # 8101e010 <itable+0x28>
    81003148:	0001d997          	auipc	s3,0x1d
    8100314c:	95898993          	addi	s3,s3,-1704 # 8101faa0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    81003150:	00004917          	auipc	s2,0x4
    81003154:	41890913          	addi	s2,s2,1048 # 81007568 <etext+0x568>
    81003158:	85ca                	mv	a1,s2
    8100315a:	8526                	mv	a0,s1
    8100315c:	497000ef          	jal	81003df2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    81003160:	08848493          	addi	s1,s1,136
    81003164:	ff349ae3          	bne	s1,s3,81003158 <iinit+0x3a>
}
    81003168:	70a2                	ld	ra,40(sp)
    8100316a:	7402                	ld	s0,32(sp)
    8100316c:	64e2                	ld	s1,24(sp)
    8100316e:	6942                	ld	s2,16(sp)
    81003170:	69a2                	ld	s3,8(sp)
    81003172:	6145                	addi	sp,sp,48
    81003174:	8082                	ret

0000000081003176 <ialloc>:
{
    81003176:	7139                	addi	sp,sp,-64
    81003178:	fc06                	sd	ra,56(sp)
    8100317a:	f822                	sd	s0,48(sp)
    8100317c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8100317e:	0001b717          	auipc	a4,0x1b
    81003182:	e5672703          	lw	a4,-426(a4) # 8101dfd4 <sb+0xc>
    81003186:	4785                	li	a5,1
    81003188:	06e7f063          	bgeu	a5,a4,810031e8 <ialloc+0x72>
    8100318c:	f426                	sd	s1,40(sp)
    8100318e:	f04a                	sd	s2,32(sp)
    81003190:	ec4e                	sd	s3,24(sp)
    81003192:	e852                	sd	s4,16(sp)
    81003194:	e456                	sd	s5,8(sp)
    81003196:	e05a                	sd	s6,0(sp)
    81003198:	8aaa                	mv	s5,a0
    8100319a:	8b2e                	mv	s6,a1
    8100319c:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8100319e:	0001ba17          	auipc	s4,0x1b
    810031a2:	e2aa0a13          	addi	s4,s4,-470 # 8101dfc8 <sb>
    810031a6:	00495593          	srli	a1,s2,0x4
    810031aa:	018a2783          	lw	a5,24(s4)
    810031ae:	9dbd                	addw	a1,a1,a5
    810031b0:	8556                	mv	a0,s5
    810031b2:	a23ff0ef          	jal	81002bd4 <bread>
    810031b6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    810031b8:	05850993          	addi	s3,a0,88
    810031bc:	00f97793          	andi	a5,s2,15
    810031c0:	079a                	slli	a5,a5,0x6
    810031c2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    810031c4:	00099783          	lh	a5,0(s3)
    810031c8:	cb9d                	beqz	a5,810031fe <ialloc+0x88>
    brelse(bp);
    810031ca:	b13ff0ef          	jal	81002cdc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    810031ce:	0905                	addi	s2,s2,1
    810031d0:	00ca2703          	lw	a4,12(s4)
    810031d4:	0009079b          	sext.w	a5,s2
    810031d8:	fce7e7e3          	bltu	a5,a4,810031a6 <ialloc+0x30>
    810031dc:	74a2                	ld	s1,40(sp)
    810031de:	7902                	ld	s2,32(sp)
    810031e0:	69e2                	ld	s3,24(sp)
    810031e2:	6a42                	ld	s4,16(sp)
    810031e4:	6aa2                	ld	s5,8(sp)
    810031e6:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    810031e8:	00004517          	auipc	a0,0x4
    810031ec:	38850513          	addi	a0,a0,904 # 81007570 <etext+0x570>
    810031f0:	c24fd0ef          	jal	81000614 <printf>
  return 0;
    810031f4:	4501                	li	a0,0
}
    810031f6:	70e2                	ld	ra,56(sp)
    810031f8:	7442                	ld	s0,48(sp)
    810031fa:	6121                	addi	sp,sp,64
    810031fc:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    810031fe:	04000613          	li	a2,64
    81003202:	4581                	li	a1,0
    81003204:	854e                	mv	a0,s3
    81003206:	c13fd0ef          	jal	81000e18 <memset>
      dip->type = type;
    8100320a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8100320e:	8526                	mv	a0,s1
    81003210:	313000ef          	jal	81003d22 <log_write>
      brelse(bp);
    81003214:	8526                	mv	a0,s1
    81003216:	ac7ff0ef          	jal	81002cdc <brelse>
      return iget(dev, inum);
    8100321a:	0009059b          	sext.w	a1,s2
    8100321e:	8556                	mv	a0,s5
    81003220:	de7ff0ef          	jal	81003006 <iget>
    81003224:	74a2                	ld	s1,40(sp)
    81003226:	7902                	ld	s2,32(sp)
    81003228:	69e2                	ld	s3,24(sp)
    8100322a:	6a42                	ld	s4,16(sp)
    8100322c:	6aa2                	ld	s5,8(sp)
    8100322e:	6b02                	ld	s6,0(sp)
    81003230:	b7d9                	j	810031f6 <ialloc+0x80>

0000000081003232 <iupdate>:
{
    81003232:	1101                	addi	sp,sp,-32
    81003234:	ec06                	sd	ra,24(sp)
    81003236:	e822                	sd	s0,16(sp)
    81003238:	e426                	sd	s1,8(sp)
    8100323a:	e04a                	sd	s2,0(sp)
    8100323c:	1000                	addi	s0,sp,32
    8100323e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    81003240:	415c                	lw	a5,4(a0)
    81003242:	0047d79b          	srliw	a5,a5,0x4
    81003246:	0001b597          	auipc	a1,0x1b
    8100324a:	d9a5a583          	lw	a1,-614(a1) # 8101dfe0 <sb+0x18>
    8100324e:	9dbd                	addw	a1,a1,a5
    81003250:	4108                	lw	a0,0(a0)
    81003252:	983ff0ef          	jal	81002bd4 <bread>
    81003256:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    81003258:	05850793          	addi	a5,a0,88
    8100325c:	40d8                	lw	a4,4(s1)
    8100325e:	8b3d                	andi	a4,a4,15
    81003260:	071a                	slli	a4,a4,0x6
    81003262:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    81003264:	04449703          	lh	a4,68(s1)
    81003268:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8100326c:	04649703          	lh	a4,70(s1)
    81003270:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    81003274:	04849703          	lh	a4,72(s1)
    81003278:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8100327c:	04a49703          	lh	a4,74(s1)
    81003280:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    81003284:	44f8                	lw	a4,76(s1)
    81003286:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    81003288:	03400613          	li	a2,52
    8100328c:	05048593          	addi	a1,s1,80
    81003290:	00c78513          	addi	a0,a5,12
    81003294:	be9fd0ef          	jal	81000e7c <memmove>
  log_write(bp);
    81003298:	854a                	mv	a0,s2
    8100329a:	289000ef          	jal	81003d22 <log_write>
  brelse(bp);
    8100329e:	854a                	mv	a0,s2
    810032a0:	a3dff0ef          	jal	81002cdc <brelse>
}
    810032a4:	60e2                	ld	ra,24(sp)
    810032a6:	6442                	ld	s0,16(sp)
    810032a8:	64a2                	ld	s1,8(sp)
    810032aa:	6902                	ld	s2,0(sp)
    810032ac:	6105                	addi	sp,sp,32
    810032ae:	8082                	ret

00000000810032b0 <idup>:
{
    810032b0:	1101                	addi	sp,sp,-32
    810032b2:	ec06                	sd	ra,24(sp)
    810032b4:	e822                	sd	s0,16(sp)
    810032b6:	e426                	sd	s1,8(sp)
    810032b8:	1000                	addi	s0,sp,32
    810032ba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    810032bc:	0001b517          	auipc	a0,0x1b
    810032c0:	d2c50513          	addi	a0,a0,-724 # 8101dfe8 <itable>
    810032c4:	a85fd0ef          	jal	81000d48 <acquire>
  ip->ref++;
    810032c8:	449c                	lw	a5,8(s1)
    810032ca:	2785                	addiw	a5,a5,1
    810032cc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    810032ce:	0001b517          	auipc	a0,0x1b
    810032d2:	d1a50513          	addi	a0,a0,-742 # 8101dfe8 <itable>
    810032d6:	b07fd0ef          	jal	81000ddc <release>
}
    810032da:	8526                	mv	a0,s1
    810032dc:	60e2                	ld	ra,24(sp)
    810032de:	6442                	ld	s0,16(sp)
    810032e0:	64a2                	ld	s1,8(sp)
    810032e2:	6105                	addi	sp,sp,32
    810032e4:	8082                	ret

00000000810032e6 <ilock>:
{
    810032e6:	1101                	addi	sp,sp,-32
    810032e8:	ec06                	sd	ra,24(sp)
    810032ea:	e822                	sd	s0,16(sp)
    810032ec:	e426                	sd	s1,8(sp)
    810032ee:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    810032f0:	cd19                	beqz	a0,8100330e <ilock+0x28>
    810032f2:	84aa                	mv	s1,a0
    810032f4:	451c                	lw	a5,8(a0)
    810032f6:	00f05c63          	blez	a5,8100330e <ilock+0x28>
  acquiresleep(&ip->lock);
    810032fa:	0541                	addi	a0,a0,16
    810032fc:	32d000ef          	jal	81003e28 <acquiresleep>
  if(ip->valid == 0){
    81003300:	40bc                	lw	a5,64(s1)
    81003302:	cf89                	beqz	a5,8100331c <ilock+0x36>
}
    81003304:	60e2                	ld	ra,24(sp)
    81003306:	6442                	ld	s0,16(sp)
    81003308:	64a2                	ld	s1,8(sp)
    8100330a:	6105                	addi	sp,sp,32
    8100330c:	8082                	ret
    8100330e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    81003310:	00004517          	auipc	a0,0x4
    81003314:	27850513          	addi	a0,a0,632 # 81007588 <etext+0x588>
    81003318:	dccfd0ef          	jal	810008e4 <panic>
    8100331c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8100331e:	40dc                	lw	a5,4(s1)
    81003320:	0047d79b          	srliw	a5,a5,0x4
    81003324:	0001b597          	auipc	a1,0x1b
    81003328:	cbc5a583          	lw	a1,-836(a1) # 8101dfe0 <sb+0x18>
    8100332c:	9dbd                	addw	a1,a1,a5
    8100332e:	4088                	lw	a0,0(s1)
    81003330:	8a5ff0ef          	jal	81002bd4 <bread>
    81003334:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    81003336:	05850593          	addi	a1,a0,88
    8100333a:	40dc                	lw	a5,4(s1)
    8100333c:	8bbd                	andi	a5,a5,15
    8100333e:	079a                	slli	a5,a5,0x6
    81003340:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    81003342:	00059783          	lh	a5,0(a1)
    81003346:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8100334a:	00259783          	lh	a5,2(a1)
    8100334e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    81003352:	00459783          	lh	a5,4(a1)
    81003356:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8100335a:	00659783          	lh	a5,6(a1)
    8100335e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    81003362:	459c                	lw	a5,8(a1)
    81003364:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    81003366:	03400613          	li	a2,52
    8100336a:	05b1                	addi	a1,a1,12
    8100336c:	05048513          	addi	a0,s1,80
    81003370:	b0dfd0ef          	jal	81000e7c <memmove>
    brelse(bp);
    81003374:	854a                	mv	a0,s2
    81003376:	967ff0ef          	jal	81002cdc <brelse>
    ip->valid = 1;
    8100337a:	4785                	li	a5,1
    8100337c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8100337e:	04449783          	lh	a5,68(s1)
    81003382:	c399                	beqz	a5,81003388 <ilock+0xa2>
    81003384:	6902                	ld	s2,0(sp)
    81003386:	bfbd                	j	81003304 <ilock+0x1e>
      panic("ilock: no type");
    81003388:	00004517          	auipc	a0,0x4
    8100338c:	20850513          	addi	a0,a0,520 # 81007590 <etext+0x590>
    81003390:	d54fd0ef          	jal	810008e4 <panic>

0000000081003394 <iunlock>:
{
    81003394:	1101                	addi	sp,sp,-32
    81003396:	ec06                	sd	ra,24(sp)
    81003398:	e822                	sd	s0,16(sp)
    8100339a:	e426                	sd	s1,8(sp)
    8100339c:	e04a                	sd	s2,0(sp)
    8100339e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    810033a0:	c505                	beqz	a0,810033c8 <iunlock+0x34>
    810033a2:	84aa                	mv	s1,a0
    810033a4:	01050913          	addi	s2,a0,16
    810033a8:	854a                	mv	a0,s2
    810033aa:	2fd000ef          	jal	81003ea6 <holdingsleep>
    810033ae:	cd09                	beqz	a0,810033c8 <iunlock+0x34>
    810033b0:	449c                	lw	a5,8(s1)
    810033b2:	00f05b63          	blez	a5,810033c8 <iunlock+0x34>
  releasesleep(&ip->lock);
    810033b6:	854a                	mv	a0,s2
    810033b8:	2b7000ef          	jal	81003e6e <releasesleep>
}
    810033bc:	60e2                	ld	ra,24(sp)
    810033be:	6442                	ld	s0,16(sp)
    810033c0:	64a2                	ld	s1,8(sp)
    810033c2:	6902                	ld	s2,0(sp)
    810033c4:	6105                	addi	sp,sp,32
    810033c6:	8082                	ret
    panic("iunlock");
    810033c8:	00004517          	auipc	a0,0x4
    810033cc:	1d850513          	addi	a0,a0,472 # 810075a0 <etext+0x5a0>
    810033d0:	d14fd0ef          	jal	810008e4 <panic>

00000000810033d4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    810033d4:	7179                	addi	sp,sp,-48
    810033d6:	f406                	sd	ra,40(sp)
    810033d8:	f022                	sd	s0,32(sp)
    810033da:	ec26                	sd	s1,24(sp)
    810033dc:	e84a                	sd	s2,16(sp)
    810033de:	e44e                	sd	s3,8(sp)
    810033e0:	1800                	addi	s0,sp,48
    810033e2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    810033e4:	05050493          	addi	s1,a0,80
    810033e8:	08050913          	addi	s2,a0,128
    810033ec:	a021                	j	810033f4 <itrunc+0x20>
    810033ee:	0491                	addi	s1,s1,4
    810033f0:	01248b63          	beq	s1,s2,81003406 <itrunc+0x32>
    if(ip->addrs[i]){
    810033f4:	408c                	lw	a1,0(s1)
    810033f6:	dde5                	beqz	a1,810033ee <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    810033f8:	0009a503          	lw	a0,0(s3)
    810033fc:	9cdff0ef          	jal	81002dc8 <bfree>
      ip->addrs[i] = 0;
    81003400:	0004a023          	sw	zero,0(s1)
    81003404:	b7ed                	j	810033ee <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    81003406:	0809a583          	lw	a1,128(s3)
    8100340a:	ed89                	bnez	a1,81003424 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8100340c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    81003410:	854e                	mv	a0,s3
    81003412:	e21ff0ef          	jal	81003232 <iupdate>
}
    81003416:	70a2                	ld	ra,40(sp)
    81003418:	7402                	ld	s0,32(sp)
    8100341a:	64e2                	ld	s1,24(sp)
    8100341c:	6942                	ld	s2,16(sp)
    8100341e:	69a2                	ld	s3,8(sp)
    81003420:	6145                	addi	sp,sp,48
    81003422:	8082                	ret
    81003424:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    81003426:	0009a503          	lw	a0,0(s3)
    8100342a:	faaff0ef          	jal	81002bd4 <bread>
    8100342e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    81003430:	05850493          	addi	s1,a0,88
    81003434:	45850913          	addi	s2,a0,1112
    81003438:	a021                	j	81003440 <itrunc+0x6c>
    8100343a:	0491                	addi	s1,s1,4
    8100343c:	01248963          	beq	s1,s2,8100344e <itrunc+0x7a>
      if(a[j])
    81003440:	408c                	lw	a1,0(s1)
    81003442:	dde5                	beqz	a1,8100343a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    81003444:	0009a503          	lw	a0,0(s3)
    81003448:	981ff0ef          	jal	81002dc8 <bfree>
    8100344c:	b7fd                	j	8100343a <itrunc+0x66>
    brelse(bp);
    8100344e:	8552                	mv	a0,s4
    81003450:	88dff0ef          	jal	81002cdc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    81003454:	0809a583          	lw	a1,128(s3)
    81003458:	0009a503          	lw	a0,0(s3)
    8100345c:	96dff0ef          	jal	81002dc8 <bfree>
    ip->addrs[NDIRECT] = 0;
    81003460:	0809a023          	sw	zero,128(s3)
    81003464:	6a02                	ld	s4,0(sp)
    81003466:	b75d                	j	8100340c <itrunc+0x38>

0000000081003468 <iput>:
{
    81003468:	1101                	addi	sp,sp,-32
    8100346a:	ec06                	sd	ra,24(sp)
    8100346c:	e822                	sd	s0,16(sp)
    8100346e:	e426                	sd	s1,8(sp)
    81003470:	1000                	addi	s0,sp,32
    81003472:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    81003474:	0001b517          	auipc	a0,0x1b
    81003478:	b7450513          	addi	a0,a0,-1164 # 8101dfe8 <itable>
    8100347c:	8cdfd0ef          	jal	81000d48 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    81003480:	4498                	lw	a4,8(s1)
    81003482:	4785                	li	a5,1
    81003484:	02f70063          	beq	a4,a5,810034a4 <iput+0x3c>
  ip->ref--;
    81003488:	449c                	lw	a5,8(s1)
    8100348a:	37fd                	addiw	a5,a5,-1
    8100348c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8100348e:	0001b517          	auipc	a0,0x1b
    81003492:	b5a50513          	addi	a0,a0,-1190 # 8101dfe8 <itable>
    81003496:	947fd0ef          	jal	81000ddc <release>
}
    8100349a:	60e2                	ld	ra,24(sp)
    8100349c:	6442                	ld	s0,16(sp)
    8100349e:	64a2                	ld	s1,8(sp)
    810034a0:	6105                	addi	sp,sp,32
    810034a2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    810034a4:	40bc                	lw	a5,64(s1)
    810034a6:	d3ed                	beqz	a5,81003488 <iput+0x20>
    810034a8:	04a49783          	lh	a5,74(s1)
    810034ac:	fff1                	bnez	a5,81003488 <iput+0x20>
    810034ae:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    810034b0:	01048913          	addi	s2,s1,16
    810034b4:	854a                	mv	a0,s2
    810034b6:	173000ef          	jal	81003e28 <acquiresleep>
    release(&itable.lock);
    810034ba:	0001b517          	auipc	a0,0x1b
    810034be:	b2e50513          	addi	a0,a0,-1234 # 8101dfe8 <itable>
    810034c2:	91bfd0ef          	jal	81000ddc <release>
    itrunc(ip);
    810034c6:	8526                	mv	a0,s1
    810034c8:	f0dff0ef          	jal	810033d4 <itrunc>
    ip->type = 0;
    810034cc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    810034d0:	8526                	mv	a0,s1
    810034d2:	d61ff0ef          	jal	81003232 <iupdate>
    ip->valid = 0;
    810034d6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    810034da:	854a                	mv	a0,s2
    810034dc:	193000ef          	jal	81003e6e <releasesleep>
    acquire(&itable.lock);
    810034e0:	0001b517          	auipc	a0,0x1b
    810034e4:	b0850513          	addi	a0,a0,-1272 # 8101dfe8 <itable>
    810034e8:	861fd0ef          	jal	81000d48 <acquire>
    810034ec:	6902                	ld	s2,0(sp)
    810034ee:	bf69                	j	81003488 <iput+0x20>

00000000810034f0 <iunlockput>:
{
    810034f0:	1101                	addi	sp,sp,-32
    810034f2:	ec06                	sd	ra,24(sp)
    810034f4:	e822                	sd	s0,16(sp)
    810034f6:	e426                	sd	s1,8(sp)
    810034f8:	1000                	addi	s0,sp,32
    810034fa:	84aa                	mv	s1,a0
  iunlock(ip);
    810034fc:	e99ff0ef          	jal	81003394 <iunlock>
  iput(ip);
    81003500:	8526                	mv	a0,s1
    81003502:	f67ff0ef          	jal	81003468 <iput>
}
    81003506:	60e2                	ld	ra,24(sp)
    81003508:	6442                	ld	s0,16(sp)
    8100350a:	64a2                	ld	s1,8(sp)
    8100350c:	6105                	addi	sp,sp,32
    8100350e:	8082                	ret

0000000081003510 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    81003510:	1141                	addi	sp,sp,-16
    81003512:	e406                	sd	ra,8(sp)
    81003514:	e022                	sd	s0,0(sp)
    81003516:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    81003518:	411c                	lw	a5,0(a0)
    8100351a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8100351c:	415c                	lw	a5,4(a0)
    8100351e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    81003520:	04451783          	lh	a5,68(a0)
    81003524:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    81003528:	04a51783          	lh	a5,74(a0)
    8100352c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    81003530:	04c56783          	lwu	a5,76(a0)
    81003534:	e99c                	sd	a5,16(a1)
}
    81003536:	60a2                	ld	ra,8(sp)
    81003538:	6402                	ld	s0,0(sp)
    8100353a:	0141                	addi	sp,sp,16
    8100353c:	8082                	ret

000000008100353e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8100353e:	457c                	lw	a5,76(a0)
    81003540:	0ed7e663          	bltu	a5,a3,8100362c <readi+0xee>
{
    81003544:	7159                	addi	sp,sp,-112
    81003546:	f486                	sd	ra,104(sp)
    81003548:	f0a2                	sd	s0,96(sp)
    8100354a:	eca6                	sd	s1,88(sp)
    8100354c:	e0d2                	sd	s4,64(sp)
    8100354e:	fc56                	sd	s5,56(sp)
    81003550:	f85a                	sd	s6,48(sp)
    81003552:	f45e                	sd	s7,40(sp)
    81003554:	1880                	addi	s0,sp,112
    81003556:	8b2a                	mv	s6,a0
    81003558:	8bae                	mv	s7,a1
    8100355a:	8a32                	mv	s4,a2
    8100355c:	84b6                	mv	s1,a3
    8100355e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    81003560:	9f35                	addw	a4,a4,a3
    return 0;
    81003562:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    81003564:	0ad76b63          	bltu	a4,a3,8100361a <readi+0xdc>
    81003568:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8100356a:	00e7f463          	bgeu	a5,a4,81003572 <readi+0x34>
    n = ip->size - off;
    8100356e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    81003572:	080a8b63          	beqz	s5,81003608 <readi+0xca>
    81003576:	e8ca                	sd	s2,80(sp)
    81003578:	f062                	sd	s8,32(sp)
    8100357a:	ec66                	sd	s9,24(sp)
    8100357c:	e86a                	sd	s10,16(sp)
    8100357e:	e46e                	sd	s11,8(sp)
    81003580:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    81003582:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    81003586:	5c7d                	li	s8,-1
    81003588:	a80d                	j	810035ba <readi+0x7c>
    8100358a:	020d1d93          	slli	s11,s10,0x20
    8100358e:	020ddd93          	srli	s11,s11,0x20
    81003592:	05890613          	addi	a2,s2,88
    81003596:	86ee                	mv	a3,s11
    81003598:	963e                	add	a2,a2,a5
    8100359a:	85d2                	mv	a1,s4
    8100359c:	855e                	mv	a0,s7
    8100359e:	dbdfe0ef          	jal	8100235a <either_copyout>
    810035a2:	05850363          	beq	a0,s8,810035e8 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    810035a6:	854a                	mv	a0,s2
    810035a8:	f34ff0ef          	jal	81002cdc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    810035ac:	013d09bb          	addw	s3,s10,s3
    810035b0:	009d04bb          	addw	s1,s10,s1
    810035b4:	9a6e                	add	s4,s4,s11
    810035b6:	0559f363          	bgeu	s3,s5,810035fc <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    810035ba:	00a4d59b          	srliw	a1,s1,0xa
    810035be:	855a                	mv	a0,s6
    810035c0:	987ff0ef          	jal	81002f46 <bmap>
    810035c4:	85aa                	mv	a1,a0
    if(addr == 0)
    810035c6:	c139                	beqz	a0,8100360c <readi+0xce>
    bp = bread(ip->dev, addr);
    810035c8:	000b2503          	lw	a0,0(s6)
    810035cc:	e08ff0ef          	jal	81002bd4 <bread>
    810035d0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    810035d2:	3ff4f793          	andi	a5,s1,1023
    810035d6:	40fc873b          	subw	a4,s9,a5
    810035da:	413a86bb          	subw	a3,s5,s3
    810035de:	8d3a                	mv	s10,a4
    810035e0:	fae6f5e3          	bgeu	a3,a4,8100358a <readi+0x4c>
    810035e4:	8d36                	mv	s10,a3
    810035e6:	b755                	j	8100358a <readi+0x4c>
      brelse(bp);
    810035e8:	854a                	mv	a0,s2
    810035ea:	ef2ff0ef          	jal	81002cdc <brelse>
      tot = -1;
    810035ee:	59fd                	li	s3,-1
      break;
    810035f0:	6946                	ld	s2,80(sp)
    810035f2:	7c02                	ld	s8,32(sp)
    810035f4:	6ce2                	ld	s9,24(sp)
    810035f6:	6d42                	ld	s10,16(sp)
    810035f8:	6da2                	ld	s11,8(sp)
    810035fa:	a831                	j	81003616 <readi+0xd8>
    810035fc:	6946                	ld	s2,80(sp)
    810035fe:	7c02                	ld	s8,32(sp)
    81003600:	6ce2                	ld	s9,24(sp)
    81003602:	6d42                	ld	s10,16(sp)
    81003604:	6da2                	ld	s11,8(sp)
    81003606:	a801                	j	81003616 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    81003608:	89d6                	mv	s3,s5
    8100360a:	a031                	j	81003616 <readi+0xd8>
    8100360c:	6946                	ld	s2,80(sp)
    8100360e:	7c02                	ld	s8,32(sp)
    81003610:	6ce2                	ld	s9,24(sp)
    81003612:	6d42                	ld	s10,16(sp)
    81003614:	6da2                	ld	s11,8(sp)
  }
  return tot;
    81003616:	854e                	mv	a0,s3
    81003618:	69a6                	ld	s3,72(sp)
}
    8100361a:	70a6                	ld	ra,104(sp)
    8100361c:	7406                	ld	s0,96(sp)
    8100361e:	64e6                	ld	s1,88(sp)
    81003620:	6a06                	ld	s4,64(sp)
    81003622:	7ae2                	ld	s5,56(sp)
    81003624:	7b42                	ld	s6,48(sp)
    81003626:	7ba2                	ld	s7,40(sp)
    81003628:	6165                	addi	sp,sp,112
    8100362a:	8082                	ret
    return 0;
    8100362c:	4501                	li	a0,0
}
    8100362e:	8082                	ret

0000000081003630 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    81003630:	457c                	lw	a5,76(a0)
    81003632:	0ed7eb63          	bltu	a5,a3,81003728 <writei+0xf8>
{
    81003636:	7159                	addi	sp,sp,-112
    81003638:	f486                	sd	ra,104(sp)
    8100363a:	f0a2                	sd	s0,96(sp)
    8100363c:	e8ca                	sd	s2,80(sp)
    8100363e:	e0d2                	sd	s4,64(sp)
    81003640:	fc56                	sd	s5,56(sp)
    81003642:	f85a                	sd	s6,48(sp)
    81003644:	f45e                	sd	s7,40(sp)
    81003646:	1880                	addi	s0,sp,112
    81003648:	8aaa                	mv	s5,a0
    8100364a:	8bae                	mv	s7,a1
    8100364c:	8a32                	mv	s4,a2
    8100364e:	8936                	mv	s2,a3
    81003650:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    81003652:	00e687bb          	addw	a5,a3,a4
    81003656:	0cd7eb63          	bltu	a5,a3,8100372c <writei+0xfc>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8100365a:	00043737          	lui	a4,0x43
    8100365e:	0cf76963          	bltu	a4,a5,81003730 <writei+0x100>
    81003662:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    81003664:	0a0b0a63          	beqz	s6,81003718 <writei+0xe8>
    81003668:	eca6                	sd	s1,88(sp)
    8100366a:	f062                	sd	s8,32(sp)
    8100366c:	ec66                	sd	s9,24(sp)
    8100366e:	e86a                	sd	s10,16(sp)
    81003670:	e46e                	sd	s11,8(sp)
    81003672:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    81003674:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    81003678:	5c7d                	li	s8,-1
    8100367a:	a825                	j	810036b2 <writei+0x82>
    8100367c:	020d1d93          	slli	s11,s10,0x20
    81003680:	020ddd93          	srli	s11,s11,0x20
    81003684:	05848513          	addi	a0,s1,88
    81003688:	86ee                	mv	a3,s11
    8100368a:	8652                	mv	a2,s4
    8100368c:	85de                	mv	a1,s7
    8100368e:	953e                	add	a0,a0,a5
    81003690:	d15fe0ef          	jal	810023a4 <either_copyin>
    81003694:	05850663          	beq	a0,s8,810036e0 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    81003698:	8526                	mv	a0,s1
    8100369a:	688000ef          	jal	81003d22 <log_write>
    brelse(bp);
    8100369e:	8526                	mv	a0,s1
    810036a0:	e3cff0ef          	jal	81002cdc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    810036a4:	013d09bb          	addw	s3,s10,s3
    810036a8:	012d093b          	addw	s2,s10,s2
    810036ac:	9a6e                	add	s4,s4,s11
    810036ae:	0369fc63          	bgeu	s3,s6,810036e6 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    810036b2:	00a9559b          	srliw	a1,s2,0xa
    810036b6:	8556                	mv	a0,s5
    810036b8:	88fff0ef          	jal	81002f46 <bmap>
    810036bc:	85aa                	mv	a1,a0
    if(addr == 0)
    810036be:	c505                	beqz	a0,810036e6 <writei+0xb6>
    bp = bread(ip->dev, addr);
    810036c0:	000aa503          	lw	a0,0(s5)
    810036c4:	d10ff0ef          	jal	81002bd4 <bread>
    810036c8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    810036ca:	3ff97793          	andi	a5,s2,1023
    810036ce:	40fc873b          	subw	a4,s9,a5
    810036d2:	413b06bb          	subw	a3,s6,s3
    810036d6:	8d3a                	mv	s10,a4
    810036d8:	fae6f2e3          	bgeu	a3,a4,8100367c <writei+0x4c>
    810036dc:	8d36                	mv	s10,a3
    810036de:	bf79                	j	8100367c <writei+0x4c>
      brelse(bp);
    810036e0:	8526                	mv	a0,s1
    810036e2:	dfaff0ef          	jal	81002cdc <brelse>
  }

  if(off > ip->size)
    810036e6:	04caa783          	lw	a5,76(s5)
    810036ea:	0327f963          	bgeu	a5,s2,8100371c <writei+0xec>
    ip->size = off;
    810036ee:	052aa623          	sw	s2,76(s5)
    810036f2:	64e6                	ld	s1,88(sp)
    810036f4:	7c02                	ld	s8,32(sp)
    810036f6:	6ce2                	ld	s9,24(sp)
    810036f8:	6d42                	ld	s10,16(sp)
    810036fa:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    810036fc:	8556                	mv	a0,s5
    810036fe:	b35ff0ef          	jal	81003232 <iupdate>

  return tot;
    81003702:	854e                	mv	a0,s3
    81003704:	69a6                	ld	s3,72(sp)
}
    81003706:	70a6                	ld	ra,104(sp)
    81003708:	7406                	ld	s0,96(sp)
    8100370a:	6946                	ld	s2,80(sp)
    8100370c:	6a06                	ld	s4,64(sp)
    8100370e:	7ae2                	ld	s5,56(sp)
    81003710:	7b42                	ld	s6,48(sp)
    81003712:	7ba2                	ld	s7,40(sp)
    81003714:	6165                	addi	sp,sp,112
    81003716:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    81003718:	89da                	mv	s3,s6
    8100371a:	b7cd                	j	810036fc <writei+0xcc>
    8100371c:	64e6                	ld	s1,88(sp)
    8100371e:	7c02                	ld	s8,32(sp)
    81003720:	6ce2                	ld	s9,24(sp)
    81003722:	6d42                	ld	s10,16(sp)
    81003724:	6da2                	ld	s11,8(sp)
    81003726:	bfd9                	j	810036fc <writei+0xcc>
    return -1;
    81003728:	557d                	li	a0,-1
}
    8100372a:	8082                	ret
    return -1;
    8100372c:	557d                	li	a0,-1
    8100372e:	bfe1                	j	81003706 <writei+0xd6>
    return -1;
    81003730:	557d                	li	a0,-1
    81003732:	bfd1                	j	81003706 <writei+0xd6>

0000000081003734 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    81003734:	1141                	addi	sp,sp,-16
    81003736:	e406                	sd	ra,8(sp)
    81003738:	e022                	sd	s0,0(sp)
    8100373a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8100373c:	4639                	li	a2,14
    8100373e:	fb2fd0ef          	jal	81000ef0 <strncmp>
}
    81003742:	60a2                	ld	ra,8(sp)
    81003744:	6402                	ld	s0,0(sp)
    81003746:	0141                	addi	sp,sp,16
    81003748:	8082                	ret

000000008100374a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8100374a:	711d                	addi	sp,sp,-96
    8100374c:	ec86                	sd	ra,88(sp)
    8100374e:	e8a2                	sd	s0,80(sp)
    81003750:	e4a6                	sd	s1,72(sp)
    81003752:	e0ca                	sd	s2,64(sp)
    81003754:	fc4e                	sd	s3,56(sp)
    81003756:	f852                	sd	s4,48(sp)
    81003758:	f456                	sd	s5,40(sp)
    8100375a:	f05a                	sd	s6,32(sp)
    8100375c:	ec5e                	sd	s7,24(sp)
    8100375e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    81003760:	04451703          	lh	a4,68(a0)
    81003764:	4785                	li	a5,1
    81003766:	00f71f63          	bne	a4,a5,81003784 <dirlookup+0x3a>
    8100376a:	892a                	mv	s2,a0
    8100376c:	8aae                	mv	s5,a1
    8100376e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    81003770:	457c                	lw	a5,76(a0)
    81003772:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    81003774:	fa040a13          	addi	s4,s0,-96
    81003778:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8100377a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8100377e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    81003780:	e39d                	bnez	a5,810037a6 <dirlookup+0x5c>
    81003782:	a8b9                	j	810037e0 <dirlookup+0x96>
    panic("dirlookup not DIR");
    81003784:	00004517          	auipc	a0,0x4
    81003788:	e2450513          	addi	a0,a0,-476 # 810075a8 <etext+0x5a8>
    8100378c:	958fd0ef          	jal	810008e4 <panic>
      panic("dirlookup read");
    81003790:	00004517          	auipc	a0,0x4
    81003794:	e3050513          	addi	a0,a0,-464 # 810075c0 <etext+0x5c0>
    81003798:	94cfd0ef          	jal	810008e4 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8100379c:	24c1                	addiw	s1,s1,16
    8100379e:	04c92783          	lw	a5,76(s2)
    810037a2:	02f4fe63          	bgeu	s1,a5,810037de <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    810037a6:	874e                	mv	a4,s3
    810037a8:	86a6                	mv	a3,s1
    810037aa:	8652                	mv	a2,s4
    810037ac:	4581                	li	a1,0
    810037ae:	854a                	mv	a0,s2
    810037b0:	d8fff0ef          	jal	8100353e <readi>
    810037b4:	fd351ee3          	bne	a0,s3,81003790 <dirlookup+0x46>
    if(de.inum == 0)
    810037b8:	fa045783          	lhu	a5,-96(s0)
    810037bc:	d3e5                	beqz	a5,8100379c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    810037be:	85da                	mv	a1,s6
    810037c0:	8556                	mv	a0,s5
    810037c2:	f73ff0ef          	jal	81003734 <namecmp>
    810037c6:	f979                	bnez	a0,8100379c <dirlookup+0x52>
      if(poff)
    810037c8:	000b8463          	beqz	s7,810037d0 <dirlookup+0x86>
        *poff = off;
    810037cc:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    810037d0:	fa045583          	lhu	a1,-96(s0)
    810037d4:	00092503          	lw	a0,0(s2)
    810037d8:	82fff0ef          	jal	81003006 <iget>
    810037dc:	a011                	j	810037e0 <dirlookup+0x96>
  return 0;
    810037de:	4501                	li	a0,0
}
    810037e0:	60e6                	ld	ra,88(sp)
    810037e2:	6446                	ld	s0,80(sp)
    810037e4:	64a6                	ld	s1,72(sp)
    810037e6:	6906                	ld	s2,64(sp)
    810037e8:	79e2                	ld	s3,56(sp)
    810037ea:	7a42                	ld	s4,48(sp)
    810037ec:	7aa2                	ld	s5,40(sp)
    810037ee:	7b02                	ld	s6,32(sp)
    810037f0:	6be2                	ld	s7,24(sp)
    810037f2:	6125                	addi	sp,sp,96
    810037f4:	8082                	ret

00000000810037f6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    810037f6:	711d                	addi	sp,sp,-96
    810037f8:	ec86                	sd	ra,88(sp)
    810037fa:	e8a2                	sd	s0,80(sp)
    810037fc:	e4a6                	sd	s1,72(sp)
    810037fe:	e0ca                	sd	s2,64(sp)
    81003800:	fc4e                	sd	s3,56(sp)
    81003802:	f852                	sd	s4,48(sp)
    81003804:	f456                	sd	s5,40(sp)
    81003806:	f05a                	sd	s6,32(sp)
    81003808:	ec5e                	sd	s7,24(sp)
    8100380a:	e862                	sd	s8,16(sp)
    8100380c:	e466                	sd	s9,8(sp)
    8100380e:	e06a                	sd	s10,0(sp)
    81003810:	1080                	addi	s0,sp,96
    81003812:	84aa                	mv	s1,a0
    81003814:	8b2e                	mv	s6,a1
    81003816:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    81003818:	00054703          	lbu	a4,0(a0)
    8100381c:	02f00793          	li	a5,47
    81003820:	00f70f63          	beq	a4,a5,8100383e <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    81003824:	a12fe0ef          	jal	81001a36 <myproc>
    81003828:	15053503          	ld	a0,336(a0)
    8100382c:	a85ff0ef          	jal	810032b0 <idup>
    81003830:	8a2a                	mv	s4,a0
  while(*path == '/')
    81003832:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    81003836:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    81003838:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8100383a:	4b85                	li	s7,1
    8100383c:	a879                	j	810038da <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    8100383e:	4585                	li	a1,1
    81003840:	852e                	mv	a0,a1
    81003842:	fc4ff0ef          	jal	81003006 <iget>
    81003846:	8a2a                	mv	s4,a0
    81003848:	b7ed                	j	81003832 <namex+0x3c>
      iunlockput(ip);
    8100384a:	8552                	mv	a0,s4
    8100384c:	ca5ff0ef          	jal	810034f0 <iunlockput>
      return 0;
    81003850:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    81003852:	8552                	mv	a0,s4
    81003854:	60e6                	ld	ra,88(sp)
    81003856:	6446                	ld	s0,80(sp)
    81003858:	64a6                	ld	s1,72(sp)
    8100385a:	6906                	ld	s2,64(sp)
    8100385c:	79e2                	ld	s3,56(sp)
    8100385e:	7a42                	ld	s4,48(sp)
    81003860:	7aa2                	ld	s5,40(sp)
    81003862:	7b02                	ld	s6,32(sp)
    81003864:	6be2                	ld	s7,24(sp)
    81003866:	6c42                	ld	s8,16(sp)
    81003868:	6ca2                	ld	s9,8(sp)
    8100386a:	6d02                	ld	s10,0(sp)
    8100386c:	6125                	addi	sp,sp,96
    8100386e:	8082                	ret
      iunlock(ip);
    81003870:	8552                	mv	a0,s4
    81003872:	b23ff0ef          	jal	81003394 <iunlock>
      return ip;
    81003876:	bff1                	j	81003852 <namex+0x5c>
      iunlockput(ip);
    81003878:	8552                	mv	a0,s4
    8100387a:	c77ff0ef          	jal	810034f0 <iunlockput>
      return 0;
    8100387e:	8a4e                	mv	s4,s3
    81003880:	bfc9                	j	81003852 <namex+0x5c>
  len = path - s;
    81003882:	40998633          	sub	a2,s3,s1
    81003886:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8100388a:	09ac5063          	bge	s8,s10,8100390a <namex+0x114>
    memmove(name, s, DIRSIZ);
    8100388e:	8666                	mv	a2,s9
    81003890:	85a6                	mv	a1,s1
    81003892:	8556                	mv	a0,s5
    81003894:	de8fd0ef          	jal	81000e7c <memmove>
    81003898:	84ce                	mv	s1,s3
  while(*path == '/')
    8100389a:	0004c783          	lbu	a5,0(s1)
    8100389e:	01279763          	bne	a5,s2,810038ac <namex+0xb6>
    path++;
    810038a2:	0485                	addi	s1,s1,1
  while(*path == '/')
    810038a4:	0004c783          	lbu	a5,0(s1)
    810038a8:	ff278de3          	beq	a5,s2,810038a2 <namex+0xac>
    ilock(ip);
    810038ac:	8552                	mv	a0,s4
    810038ae:	a39ff0ef          	jal	810032e6 <ilock>
    if(ip->type != T_DIR){
    810038b2:	044a1783          	lh	a5,68(s4)
    810038b6:	f9779ae3          	bne	a5,s7,8100384a <namex+0x54>
    if(nameiparent && *path == '\0'){
    810038ba:	000b0563          	beqz	s6,810038c4 <namex+0xce>
    810038be:	0004c783          	lbu	a5,0(s1)
    810038c2:	d7dd                	beqz	a5,81003870 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    810038c4:	4601                	li	a2,0
    810038c6:	85d6                	mv	a1,s5
    810038c8:	8552                	mv	a0,s4
    810038ca:	e81ff0ef          	jal	8100374a <dirlookup>
    810038ce:	89aa                	mv	s3,a0
    810038d0:	d545                	beqz	a0,81003878 <namex+0x82>
    iunlockput(ip);
    810038d2:	8552                	mv	a0,s4
    810038d4:	c1dff0ef          	jal	810034f0 <iunlockput>
    ip = next;
    810038d8:	8a4e                	mv	s4,s3
  while(*path == '/')
    810038da:	0004c783          	lbu	a5,0(s1)
    810038de:	01279763          	bne	a5,s2,810038ec <namex+0xf6>
    path++;
    810038e2:	0485                	addi	s1,s1,1
  while(*path == '/')
    810038e4:	0004c783          	lbu	a5,0(s1)
    810038e8:	ff278de3          	beq	a5,s2,810038e2 <namex+0xec>
  if(*path == 0)
    810038ec:	cb8d                	beqz	a5,8100391e <namex+0x128>
  while(*path != '/' && *path != 0)
    810038ee:	0004c783          	lbu	a5,0(s1)
    810038f2:	89a6                	mv	s3,s1
  len = path - s;
    810038f4:	4d01                	li	s10,0
    810038f6:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    810038f8:	01278963          	beq	a5,s2,8100390a <namex+0x114>
    810038fc:	d3d9                	beqz	a5,81003882 <namex+0x8c>
    path++;
    810038fe:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    81003900:	0009c783          	lbu	a5,0(s3)
    81003904:	ff279ce3          	bne	a5,s2,810038fc <namex+0x106>
    81003908:	bfad                	j	81003882 <namex+0x8c>
    memmove(name, s, len);
    8100390a:	2601                	sext.w	a2,a2
    8100390c:	85a6                	mv	a1,s1
    8100390e:	8556                	mv	a0,s5
    81003910:	d6cfd0ef          	jal	81000e7c <memmove>
    name[len] = 0;
    81003914:	9d56                	add	s10,s10,s5
    81003916:	000d0023          	sb	zero,0(s10)
    8100391a:	84ce                	mv	s1,s3
    8100391c:	bfbd                	j	8100389a <namex+0xa4>
  if(nameiparent){
    8100391e:	f20b0ae3          	beqz	s6,81003852 <namex+0x5c>
    iput(ip);
    81003922:	8552                	mv	a0,s4
    81003924:	b45ff0ef          	jal	81003468 <iput>
    return 0;
    81003928:	4a01                	li	s4,0
    8100392a:	b725                	j	81003852 <namex+0x5c>

000000008100392c <dirlink>:
{
    8100392c:	715d                	addi	sp,sp,-80
    8100392e:	e486                	sd	ra,72(sp)
    81003930:	e0a2                	sd	s0,64(sp)
    81003932:	f84a                	sd	s2,48(sp)
    81003934:	ec56                	sd	s5,24(sp)
    81003936:	e85a                	sd	s6,16(sp)
    81003938:	0880                	addi	s0,sp,80
    8100393a:	892a                	mv	s2,a0
    8100393c:	8aae                	mv	s5,a1
    8100393e:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    81003940:	4601                	li	a2,0
    81003942:	e09ff0ef          	jal	8100374a <dirlookup>
    81003946:	ed1d                	bnez	a0,81003984 <dirlink+0x58>
    81003948:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8100394a:	04c92483          	lw	s1,76(s2)
    8100394e:	c4b9                	beqz	s1,8100399c <dirlink+0x70>
    81003950:	f44e                	sd	s3,40(sp)
    81003952:	f052                	sd	s4,32(sp)
    81003954:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    81003956:	fb040a13          	addi	s4,s0,-80
    8100395a:	49c1                	li	s3,16
    8100395c:	874e                	mv	a4,s3
    8100395e:	86a6                	mv	a3,s1
    81003960:	8652                	mv	a2,s4
    81003962:	4581                	li	a1,0
    81003964:	854a                	mv	a0,s2
    81003966:	bd9ff0ef          	jal	8100353e <readi>
    8100396a:	03351163          	bne	a0,s3,8100398c <dirlink+0x60>
    if(de.inum == 0)
    8100396e:	fb045783          	lhu	a5,-80(s0)
    81003972:	c39d                	beqz	a5,81003998 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    81003974:	24c1                	addiw	s1,s1,16
    81003976:	04c92783          	lw	a5,76(s2)
    8100397a:	fef4e1e3          	bltu	s1,a5,8100395c <dirlink+0x30>
    8100397e:	79a2                	ld	s3,40(sp)
    81003980:	7a02                	ld	s4,32(sp)
    81003982:	a829                	j	8100399c <dirlink+0x70>
    iput(ip);
    81003984:	ae5ff0ef          	jal	81003468 <iput>
    return -1;
    81003988:	557d                	li	a0,-1
    8100398a:	a83d                	j	810039c8 <dirlink+0x9c>
      panic("dirlink read");
    8100398c:	00004517          	auipc	a0,0x4
    81003990:	c4450513          	addi	a0,a0,-956 # 810075d0 <etext+0x5d0>
    81003994:	f51fc0ef          	jal	810008e4 <panic>
    81003998:	79a2                	ld	s3,40(sp)
    8100399a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8100399c:	4639                	li	a2,14
    8100399e:	85d6                	mv	a1,s5
    810039a0:	fb240513          	addi	a0,s0,-78
    810039a4:	d86fd0ef          	jal	81000f2a <strncpy>
  de.inum = inum;
    810039a8:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    810039ac:	4741                	li	a4,16
    810039ae:	86a6                	mv	a3,s1
    810039b0:	fb040613          	addi	a2,s0,-80
    810039b4:	4581                	li	a1,0
    810039b6:	854a                	mv	a0,s2
    810039b8:	c79ff0ef          	jal	81003630 <writei>
    810039bc:	1541                	addi	a0,a0,-16
    810039be:	00a03533          	snez	a0,a0
    810039c2:	40a0053b          	negw	a0,a0
    810039c6:	74e2                	ld	s1,56(sp)
}
    810039c8:	60a6                	ld	ra,72(sp)
    810039ca:	6406                	ld	s0,64(sp)
    810039cc:	7942                	ld	s2,48(sp)
    810039ce:	6ae2                	ld	s5,24(sp)
    810039d0:	6b42                	ld	s6,16(sp)
    810039d2:	6161                	addi	sp,sp,80
    810039d4:	8082                	ret

00000000810039d6 <namei>:

struct inode*
namei(char *path)
{
    810039d6:	1101                	addi	sp,sp,-32
    810039d8:	ec06                	sd	ra,24(sp)
    810039da:	e822                	sd	s0,16(sp)
    810039dc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    810039de:	fe040613          	addi	a2,s0,-32
    810039e2:	4581                	li	a1,0
    810039e4:	e13ff0ef          	jal	810037f6 <namex>
}
    810039e8:	60e2                	ld	ra,24(sp)
    810039ea:	6442                	ld	s0,16(sp)
    810039ec:	6105                	addi	sp,sp,32
    810039ee:	8082                	ret

00000000810039f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    810039f0:	1141                	addi	sp,sp,-16
    810039f2:	e406                	sd	ra,8(sp)
    810039f4:	e022                	sd	s0,0(sp)
    810039f6:	0800                	addi	s0,sp,16
    810039f8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    810039fa:	4585                	li	a1,1
    810039fc:	dfbff0ef          	jal	810037f6 <namex>
}
    81003a00:	60a2                	ld	ra,8(sp)
    81003a02:	6402                	ld	s0,0(sp)
    81003a04:	0141                	addi	sp,sp,16
    81003a06:	8082                	ret

0000000081003a08 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    81003a08:	1101                	addi	sp,sp,-32
    81003a0a:	ec06                	sd	ra,24(sp)
    81003a0c:	e822                	sd	s0,16(sp)
    81003a0e:	e426                	sd	s1,8(sp)
    81003a10:	e04a                	sd	s2,0(sp)
    81003a12:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    81003a14:	0001c917          	auipc	s2,0x1c
    81003a18:	07c90913          	addi	s2,s2,124 # 8101fa90 <log>
    81003a1c:	01892583          	lw	a1,24(s2)
    81003a20:	02892503          	lw	a0,40(s2)
    81003a24:	9b0ff0ef          	jal	81002bd4 <bread>
    81003a28:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    81003a2a:	02c92603          	lw	a2,44(s2)
    81003a2e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    81003a30:	00c05f63          	blez	a2,81003a4e <write_head+0x46>
    81003a34:	0001c717          	auipc	a4,0x1c
    81003a38:	08c70713          	addi	a4,a4,140 # 8101fac0 <log+0x30>
    81003a3c:	87aa                	mv	a5,a0
    81003a3e:	060a                	slli	a2,a2,0x2
    81003a40:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    81003a42:	4314                	lw	a3,0(a4)
    81003a44:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    81003a46:	0711                	addi	a4,a4,4
    81003a48:	0791                	addi	a5,a5,4
    81003a4a:	fec79ce3          	bne	a5,a2,81003a42 <write_head+0x3a>
  }
  bwrite(buf);
    81003a4e:	8526                	mv	a0,s1
    81003a50:	a5aff0ef          	jal	81002caa <bwrite>
  brelse(buf);
    81003a54:	8526                	mv	a0,s1
    81003a56:	a86ff0ef          	jal	81002cdc <brelse>
}
    81003a5a:	60e2                	ld	ra,24(sp)
    81003a5c:	6442                	ld	s0,16(sp)
    81003a5e:	64a2                	ld	s1,8(sp)
    81003a60:	6902                	ld	s2,0(sp)
    81003a62:	6105                	addi	sp,sp,32
    81003a64:	8082                	ret

0000000081003a66 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    81003a66:	0001c797          	auipc	a5,0x1c
    81003a6a:	0567a783          	lw	a5,86(a5) # 8101fabc <log+0x2c>
    81003a6e:	0af05263          	blez	a5,81003b12 <install_trans+0xac>
{
    81003a72:	715d                	addi	sp,sp,-80
    81003a74:	e486                	sd	ra,72(sp)
    81003a76:	e0a2                	sd	s0,64(sp)
    81003a78:	fc26                	sd	s1,56(sp)
    81003a7a:	f84a                	sd	s2,48(sp)
    81003a7c:	f44e                	sd	s3,40(sp)
    81003a7e:	f052                	sd	s4,32(sp)
    81003a80:	ec56                	sd	s5,24(sp)
    81003a82:	e85a                	sd	s6,16(sp)
    81003a84:	e45e                	sd	s7,8(sp)
    81003a86:	0880                	addi	s0,sp,80
    81003a88:	8b2a                	mv	s6,a0
    81003a8a:	0001ca97          	auipc	s5,0x1c
    81003a8e:	036a8a93          	addi	s5,s5,54 # 8101fac0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    81003a92:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    81003a94:	0001c997          	auipc	s3,0x1c
    81003a98:	ffc98993          	addi	s3,s3,-4 # 8101fa90 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    81003a9c:	40000b93          	li	s7,1024
    81003aa0:	a829                	j	81003aba <install_trans+0x54>
    brelse(lbuf);
    81003aa2:	854a                	mv	a0,s2
    81003aa4:	a38ff0ef          	jal	81002cdc <brelse>
    brelse(dbuf);
    81003aa8:	8526                	mv	a0,s1
    81003aaa:	a32ff0ef          	jal	81002cdc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    81003aae:	2a05                	addiw	s4,s4,1
    81003ab0:	0a91                	addi	s5,s5,4
    81003ab2:	02c9a783          	lw	a5,44(s3)
    81003ab6:	04fa5363          	bge	s4,a5,81003afc <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    81003aba:	0189a583          	lw	a1,24(s3)
    81003abe:	014585bb          	addw	a1,a1,s4
    81003ac2:	2585                	addiw	a1,a1,1
    81003ac4:	0289a503          	lw	a0,40(s3)
    81003ac8:	90cff0ef          	jal	81002bd4 <bread>
    81003acc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    81003ace:	000aa583          	lw	a1,0(s5)
    81003ad2:	0289a503          	lw	a0,40(s3)
    81003ad6:	8feff0ef          	jal	81002bd4 <bread>
    81003ada:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    81003adc:	865e                	mv	a2,s7
    81003ade:	05890593          	addi	a1,s2,88
    81003ae2:	05850513          	addi	a0,a0,88
    81003ae6:	b96fd0ef          	jal	81000e7c <memmove>
    bwrite(dbuf);  // write dst to disk
    81003aea:	8526                	mv	a0,s1
    81003aec:	9beff0ef          	jal	81002caa <bwrite>
    if(recovering == 0)
    81003af0:	fa0b19e3          	bnez	s6,81003aa2 <install_trans+0x3c>
      bunpin(dbuf);
    81003af4:	8526                	mv	a0,s1
    81003af6:	a9eff0ef          	jal	81002d94 <bunpin>
    81003afa:	b765                	j	81003aa2 <install_trans+0x3c>
}
    81003afc:	60a6                	ld	ra,72(sp)
    81003afe:	6406                	ld	s0,64(sp)
    81003b00:	74e2                	ld	s1,56(sp)
    81003b02:	7942                	ld	s2,48(sp)
    81003b04:	79a2                	ld	s3,40(sp)
    81003b06:	7a02                	ld	s4,32(sp)
    81003b08:	6ae2                	ld	s5,24(sp)
    81003b0a:	6b42                	ld	s6,16(sp)
    81003b0c:	6ba2                	ld	s7,8(sp)
    81003b0e:	6161                	addi	sp,sp,80
    81003b10:	8082                	ret
    81003b12:	8082                	ret

0000000081003b14 <initlog>:
{
    81003b14:	7179                	addi	sp,sp,-48
    81003b16:	f406                	sd	ra,40(sp)
    81003b18:	f022                	sd	s0,32(sp)
    81003b1a:	ec26                	sd	s1,24(sp)
    81003b1c:	e84a                	sd	s2,16(sp)
    81003b1e:	e44e                	sd	s3,8(sp)
    81003b20:	1800                	addi	s0,sp,48
    81003b22:	892a                	mv	s2,a0
    81003b24:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    81003b26:	0001c497          	auipc	s1,0x1c
    81003b2a:	f6a48493          	addi	s1,s1,-150 # 8101fa90 <log>
    81003b2e:	00004597          	auipc	a1,0x4
    81003b32:	ab258593          	addi	a1,a1,-1358 # 810075e0 <etext+0x5e0>
    81003b36:	8526                	mv	a0,s1
    81003b38:	98cfd0ef          	jal	81000cc4 <initlock>
  log.start = sb->logstart;
    81003b3c:	0149a583          	lw	a1,20(s3)
    81003b40:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    81003b42:	0109a783          	lw	a5,16(s3)
    81003b46:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    81003b48:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    81003b4c:	854a                	mv	a0,s2
    81003b4e:	886ff0ef          	jal	81002bd4 <bread>
  log.lh.n = lh->n;
    81003b52:	4d30                	lw	a2,88(a0)
    81003b54:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    81003b56:	00c05f63          	blez	a2,81003b74 <initlog+0x60>
    81003b5a:	87aa                	mv	a5,a0
    81003b5c:	0001c717          	auipc	a4,0x1c
    81003b60:	f6470713          	addi	a4,a4,-156 # 8101fac0 <log+0x30>
    81003b64:	060a                	slli	a2,a2,0x2
    81003b66:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    81003b68:	4ff4                	lw	a3,92(a5)
    81003b6a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    81003b6c:	0791                	addi	a5,a5,4
    81003b6e:	0711                	addi	a4,a4,4
    81003b70:	fec79ce3          	bne	a5,a2,81003b68 <initlog+0x54>
  brelse(buf);
    81003b74:	968ff0ef          	jal	81002cdc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    81003b78:	4505                	li	a0,1
    81003b7a:	eedff0ef          	jal	81003a66 <install_trans>
  log.lh.n = 0;
    81003b7e:	0001c797          	auipc	a5,0x1c
    81003b82:	f207af23          	sw	zero,-194(a5) # 8101fabc <log+0x2c>
  write_head(); // clear the log
    81003b86:	e83ff0ef          	jal	81003a08 <write_head>
}
    81003b8a:	70a2                	ld	ra,40(sp)
    81003b8c:	7402                	ld	s0,32(sp)
    81003b8e:	64e2                	ld	s1,24(sp)
    81003b90:	6942                	ld	s2,16(sp)
    81003b92:	69a2                	ld	s3,8(sp)
    81003b94:	6145                	addi	sp,sp,48
    81003b96:	8082                	ret

0000000081003b98 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    81003b98:	1101                	addi	sp,sp,-32
    81003b9a:	ec06                	sd	ra,24(sp)
    81003b9c:	e822                	sd	s0,16(sp)
    81003b9e:	e426                	sd	s1,8(sp)
    81003ba0:	e04a                	sd	s2,0(sp)
    81003ba2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    81003ba4:	0001c517          	auipc	a0,0x1c
    81003ba8:	eec50513          	addi	a0,a0,-276 # 8101fa90 <log>
    81003bac:	99cfd0ef          	jal	81000d48 <acquire>
  while(1){
    if(log.committing){
    81003bb0:	0001c497          	auipc	s1,0x1c
    81003bb4:	ee048493          	addi	s1,s1,-288 # 8101fa90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    81003bb8:	4979                	li	s2,30
    81003bba:	a029                	j	81003bc4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    81003bbc:	85a6                	mv	a1,s1
    81003bbe:	8526                	mv	a0,s1
    81003bc0:	c44fe0ef          	jal	81002004 <sleep>
    if(log.committing){
    81003bc4:	50dc                	lw	a5,36(s1)
    81003bc6:	fbfd                	bnez	a5,81003bbc <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    81003bc8:	5098                	lw	a4,32(s1)
    81003bca:	2705                	addiw	a4,a4,1
    81003bcc:	0027179b          	slliw	a5,a4,0x2
    81003bd0:	9fb9                	addw	a5,a5,a4
    81003bd2:	0017979b          	slliw	a5,a5,0x1
    81003bd6:	54d4                	lw	a3,44(s1)
    81003bd8:	9fb5                	addw	a5,a5,a3
    81003bda:	00f95763          	bge	s2,a5,81003be8 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    81003bde:	85a6                	mv	a1,s1
    81003be0:	8526                	mv	a0,s1
    81003be2:	c22fe0ef          	jal	81002004 <sleep>
    81003be6:	bff9                	j	81003bc4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    81003be8:	0001c517          	auipc	a0,0x1c
    81003bec:	ea850513          	addi	a0,a0,-344 # 8101fa90 <log>
    81003bf0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    81003bf2:	9eafd0ef          	jal	81000ddc <release>
      break;
    }
  }
}
    81003bf6:	60e2                	ld	ra,24(sp)
    81003bf8:	6442                	ld	s0,16(sp)
    81003bfa:	64a2                	ld	s1,8(sp)
    81003bfc:	6902                	ld	s2,0(sp)
    81003bfe:	6105                	addi	sp,sp,32
    81003c00:	8082                	ret

0000000081003c02 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    81003c02:	7139                	addi	sp,sp,-64
    81003c04:	fc06                	sd	ra,56(sp)
    81003c06:	f822                	sd	s0,48(sp)
    81003c08:	f426                	sd	s1,40(sp)
    81003c0a:	f04a                	sd	s2,32(sp)
    81003c0c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    81003c0e:	0001c497          	auipc	s1,0x1c
    81003c12:	e8248493          	addi	s1,s1,-382 # 8101fa90 <log>
    81003c16:	8526                	mv	a0,s1
    81003c18:	930fd0ef          	jal	81000d48 <acquire>
  log.outstanding -= 1;
    81003c1c:	509c                	lw	a5,32(s1)
    81003c1e:	37fd                	addiw	a5,a5,-1
    81003c20:	893e                	mv	s2,a5
    81003c22:	d09c                	sw	a5,32(s1)
  if(log.committing)
    81003c24:	50dc                	lw	a5,36(s1)
    81003c26:	ef9d                	bnez	a5,81003c64 <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    81003c28:	04091863          	bnez	s2,81003c78 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    81003c2c:	0001c497          	auipc	s1,0x1c
    81003c30:	e6448493          	addi	s1,s1,-412 # 8101fa90 <log>
    81003c34:	4785                	li	a5,1
    81003c36:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    81003c38:	8526                	mv	a0,s1
    81003c3a:	9a2fd0ef          	jal	81000ddc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    81003c3e:	54dc                	lw	a5,44(s1)
    81003c40:	04f04c63          	bgtz	a5,81003c98 <end_op+0x96>
    acquire(&log.lock);
    81003c44:	0001c497          	auipc	s1,0x1c
    81003c48:	e4c48493          	addi	s1,s1,-436 # 8101fa90 <log>
    81003c4c:	8526                	mv	a0,s1
    81003c4e:	8fafd0ef          	jal	81000d48 <acquire>
    log.committing = 0;
    81003c52:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    81003c56:	8526                	mv	a0,s1
    81003c58:	bf8fe0ef          	jal	81002050 <wakeup>
    release(&log.lock);
    81003c5c:	8526                	mv	a0,s1
    81003c5e:	97efd0ef          	jal	81000ddc <release>
}
    81003c62:	a02d                	j	81003c8c <end_op+0x8a>
    81003c64:	ec4e                	sd	s3,24(sp)
    81003c66:	e852                	sd	s4,16(sp)
    81003c68:	e456                	sd	s5,8(sp)
    81003c6a:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    81003c6c:	00004517          	auipc	a0,0x4
    81003c70:	97c50513          	addi	a0,a0,-1668 # 810075e8 <etext+0x5e8>
    81003c74:	c71fc0ef          	jal	810008e4 <panic>
    wakeup(&log);
    81003c78:	0001c497          	auipc	s1,0x1c
    81003c7c:	e1848493          	addi	s1,s1,-488 # 8101fa90 <log>
    81003c80:	8526                	mv	a0,s1
    81003c82:	bcefe0ef          	jal	81002050 <wakeup>
  release(&log.lock);
    81003c86:	8526                	mv	a0,s1
    81003c88:	954fd0ef          	jal	81000ddc <release>
}
    81003c8c:	70e2                	ld	ra,56(sp)
    81003c8e:	7442                	ld	s0,48(sp)
    81003c90:	74a2                	ld	s1,40(sp)
    81003c92:	7902                	ld	s2,32(sp)
    81003c94:	6121                	addi	sp,sp,64
    81003c96:	8082                	ret
    81003c98:	ec4e                	sd	s3,24(sp)
    81003c9a:	e852                	sd	s4,16(sp)
    81003c9c:	e456                	sd	s5,8(sp)
    81003c9e:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    81003ca0:	0001ca97          	auipc	s5,0x1c
    81003ca4:	e20a8a93          	addi	s5,s5,-480 # 8101fac0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    81003ca8:	0001ca17          	auipc	s4,0x1c
    81003cac:	de8a0a13          	addi	s4,s4,-536 # 8101fa90 <log>
    memmove(to->data, from->data, BSIZE);
    81003cb0:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    81003cb4:	018a2583          	lw	a1,24(s4)
    81003cb8:	012585bb          	addw	a1,a1,s2
    81003cbc:	2585                	addiw	a1,a1,1
    81003cbe:	028a2503          	lw	a0,40(s4)
    81003cc2:	f13fe0ef          	jal	81002bd4 <bread>
    81003cc6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    81003cc8:	000aa583          	lw	a1,0(s5)
    81003ccc:	028a2503          	lw	a0,40(s4)
    81003cd0:	f05fe0ef          	jal	81002bd4 <bread>
    81003cd4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    81003cd6:	865a                	mv	a2,s6
    81003cd8:	05850593          	addi	a1,a0,88
    81003cdc:	05848513          	addi	a0,s1,88
    81003ce0:	99cfd0ef          	jal	81000e7c <memmove>
    bwrite(to);  // write the log
    81003ce4:	8526                	mv	a0,s1
    81003ce6:	fc5fe0ef          	jal	81002caa <bwrite>
    brelse(from);
    81003cea:	854e                	mv	a0,s3
    81003cec:	ff1fe0ef          	jal	81002cdc <brelse>
    brelse(to);
    81003cf0:	8526                	mv	a0,s1
    81003cf2:	febfe0ef          	jal	81002cdc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    81003cf6:	2905                	addiw	s2,s2,1
    81003cf8:	0a91                	addi	s5,s5,4
    81003cfa:	02ca2783          	lw	a5,44(s4)
    81003cfe:	faf94be3          	blt	s2,a5,81003cb4 <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    81003d02:	d07ff0ef          	jal	81003a08 <write_head>
    install_trans(0); // Now install writes to home locations
    81003d06:	4501                	li	a0,0
    81003d08:	d5fff0ef          	jal	81003a66 <install_trans>
    log.lh.n = 0;
    81003d0c:	0001c797          	auipc	a5,0x1c
    81003d10:	da07a823          	sw	zero,-592(a5) # 8101fabc <log+0x2c>
    write_head();    // Erase the transaction from the log
    81003d14:	cf5ff0ef          	jal	81003a08 <write_head>
    81003d18:	69e2                	ld	s3,24(sp)
    81003d1a:	6a42                	ld	s4,16(sp)
    81003d1c:	6aa2                	ld	s5,8(sp)
    81003d1e:	6b02                	ld	s6,0(sp)
    81003d20:	b715                	j	81003c44 <end_op+0x42>

0000000081003d22 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    81003d22:	1101                	addi	sp,sp,-32
    81003d24:	ec06                	sd	ra,24(sp)
    81003d26:	e822                	sd	s0,16(sp)
    81003d28:	e426                	sd	s1,8(sp)
    81003d2a:	e04a                	sd	s2,0(sp)
    81003d2c:	1000                	addi	s0,sp,32
    81003d2e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    81003d30:	0001c917          	auipc	s2,0x1c
    81003d34:	d6090913          	addi	s2,s2,-672 # 8101fa90 <log>
    81003d38:	854a                	mv	a0,s2
    81003d3a:	80efd0ef          	jal	81000d48 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    81003d3e:	02c92603          	lw	a2,44(s2)
    81003d42:	47f5                	li	a5,29
    81003d44:	06c7c363          	blt	a5,a2,81003daa <log_write+0x88>
    81003d48:	0001c797          	auipc	a5,0x1c
    81003d4c:	d647a783          	lw	a5,-668(a5) # 8101faac <log+0x1c>
    81003d50:	37fd                	addiw	a5,a5,-1
    81003d52:	04f65c63          	bge	a2,a5,81003daa <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    81003d56:	0001c797          	auipc	a5,0x1c
    81003d5a:	d5a7a783          	lw	a5,-678(a5) # 8101fab0 <log+0x20>
    81003d5e:	04f05c63          	blez	a5,81003db6 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    81003d62:	4781                	li	a5,0
    81003d64:	04c05f63          	blez	a2,81003dc2 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    81003d68:	44cc                	lw	a1,12(s1)
    81003d6a:	0001c717          	auipc	a4,0x1c
    81003d6e:	d5670713          	addi	a4,a4,-682 # 8101fac0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    81003d72:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    81003d74:	4314                	lw	a3,0(a4)
    81003d76:	04b68663          	beq	a3,a1,81003dc2 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    81003d7a:	2785                	addiw	a5,a5,1
    81003d7c:	0711                	addi	a4,a4,4
    81003d7e:	fef61be3          	bne	a2,a5,81003d74 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    81003d82:	0621                	addi	a2,a2,8
    81003d84:	060a                	slli	a2,a2,0x2
    81003d86:	0001c797          	auipc	a5,0x1c
    81003d8a:	d0a78793          	addi	a5,a5,-758 # 8101fa90 <log>
    81003d8e:	97b2                	add	a5,a5,a2
    81003d90:	44d8                	lw	a4,12(s1)
    81003d92:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    81003d94:	8526                	mv	a0,s1
    81003d96:	fcbfe0ef          	jal	81002d60 <bpin>
    log.lh.n++;
    81003d9a:	0001c717          	auipc	a4,0x1c
    81003d9e:	cf670713          	addi	a4,a4,-778 # 8101fa90 <log>
    81003da2:	575c                	lw	a5,44(a4)
    81003da4:	2785                	addiw	a5,a5,1
    81003da6:	d75c                	sw	a5,44(a4)
    81003da8:	a80d                	j	81003dda <log_write+0xb8>
    panic("too big a transaction");
    81003daa:	00004517          	auipc	a0,0x4
    81003dae:	84e50513          	addi	a0,a0,-1970 # 810075f8 <etext+0x5f8>
    81003db2:	b33fc0ef          	jal	810008e4 <panic>
    panic("log_write outside of trans");
    81003db6:	00004517          	auipc	a0,0x4
    81003dba:	85a50513          	addi	a0,a0,-1958 # 81007610 <etext+0x610>
    81003dbe:	b27fc0ef          	jal	810008e4 <panic>
  log.lh.block[i] = b->blockno;
    81003dc2:	00878693          	addi	a3,a5,8
    81003dc6:	068a                	slli	a3,a3,0x2
    81003dc8:	0001c717          	auipc	a4,0x1c
    81003dcc:	cc870713          	addi	a4,a4,-824 # 8101fa90 <log>
    81003dd0:	9736                	add	a4,a4,a3
    81003dd2:	44d4                	lw	a3,12(s1)
    81003dd4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    81003dd6:	faf60fe3          	beq	a2,a5,81003d94 <log_write+0x72>
  }
  release(&log.lock);
    81003dda:	0001c517          	auipc	a0,0x1c
    81003dde:	cb650513          	addi	a0,a0,-842 # 8101fa90 <log>
    81003de2:	ffbfc0ef          	jal	81000ddc <release>
}
    81003de6:	60e2                	ld	ra,24(sp)
    81003de8:	6442                	ld	s0,16(sp)
    81003dea:	64a2                	ld	s1,8(sp)
    81003dec:	6902                	ld	s2,0(sp)
    81003dee:	6105                	addi	sp,sp,32
    81003df0:	8082                	ret

0000000081003df2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    81003df2:	1101                	addi	sp,sp,-32
    81003df4:	ec06                	sd	ra,24(sp)
    81003df6:	e822                	sd	s0,16(sp)
    81003df8:	e426                	sd	s1,8(sp)
    81003dfa:	e04a                	sd	s2,0(sp)
    81003dfc:	1000                	addi	s0,sp,32
    81003dfe:	84aa                	mv	s1,a0
    81003e00:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    81003e02:	00004597          	auipc	a1,0x4
    81003e06:	82e58593          	addi	a1,a1,-2002 # 81007630 <etext+0x630>
    81003e0a:	0521                	addi	a0,a0,8
    81003e0c:	eb9fc0ef          	jal	81000cc4 <initlock>
  lk->name = name;
    81003e10:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    81003e14:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    81003e18:	0204a423          	sw	zero,40(s1)
}
    81003e1c:	60e2                	ld	ra,24(sp)
    81003e1e:	6442                	ld	s0,16(sp)
    81003e20:	64a2                	ld	s1,8(sp)
    81003e22:	6902                	ld	s2,0(sp)
    81003e24:	6105                	addi	sp,sp,32
    81003e26:	8082                	ret

0000000081003e28 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    81003e28:	1101                	addi	sp,sp,-32
    81003e2a:	ec06                	sd	ra,24(sp)
    81003e2c:	e822                	sd	s0,16(sp)
    81003e2e:	e426                	sd	s1,8(sp)
    81003e30:	e04a                	sd	s2,0(sp)
    81003e32:	1000                	addi	s0,sp,32
    81003e34:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    81003e36:	00850913          	addi	s2,a0,8
    81003e3a:	854a                	mv	a0,s2
    81003e3c:	f0dfc0ef          	jal	81000d48 <acquire>
  while (lk->locked) {
    81003e40:	409c                	lw	a5,0(s1)
    81003e42:	c799                	beqz	a5,81003e50 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    81003e44:	85ca                	mv	a1,s2
    81003e46:	8526                	mv	a0,s1
    81003e48:	9bcfe0ef          	jal	81002004 <sleep>
  while (lk->locked) {
    81003e4c:	409c                	lw	a5,0(s1)
    81003e4e:	fbfd                	bnez	a5,81003e44 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    81003e50:	4785                	li	a5,1
    81003e52:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    81003e54:	be3fd0ef          	jal	81001a36 <myproc>
    81003e58:	591c                	lw	a5,48(a0)
    81003e5a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    81003e5c:	854a                	mv	a0,s2
    81003e5e:	f7ffc0ef          	jal	81000ddc <release>
}
    81003e62:	60e2                	ld	ra,24(sp)
    81003e64:	6442                	ld	s0,16(sp)
    81003e66:	64a2                	ld	s1,8(sp)
    81003e68:	6902                	ld	s2,0(sp)
    81003e6a:	6105                	addi	sp,sp,32
    81003e6c:	8082                	ret

0000000081003e6e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    81003e6e:	1101                	addi	sp,sp,-32
    81003e70:	ec06                	sd	ra,24(sp)
    81003e72:	e822                	sd	s0,16(sp)
    81003e74:	e426                	sd	s1,8(sp)
    81003e76:	e04a                	sd	s2,0(sp)
    81003e78:	1000                	addi	s0,sp,32
    81003e7a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    81003e7c:	00850913          	addi	s2,a0,8
    81003e80:	854a                	mv	a0,s2
    81003e82:	ec7fc0ef          	jal	81000d48 <acquire>
  lk->locked = 0;
    81003e86:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    81003e8a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    81003e8e:	8526                	mv	a0,s1
    81003e90:	9c0fe0ef          	jal	81002050 <wakeup>
  release(&lk->lk);
    81003e94:	854a                	mv	a0,s2
    81003e96:	f47fc0ef          	jal	81000ddc <release>
}
    81003e9a:	60e2                	ld	ra,24(sp)
    81003e9c:	6442                	ld	s0,16(sp)
    81003e9e:	64a2                	ld	s1,8(sp)
    81003ea0:	6902                	ld	s2,0(sp)
    81003ea2:	6105                	addi	sp,sp,32
    81003ea4:	8082                	ret

0000000081003ea6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    81003ea6:	7179                	addi	sp,sp,-48
    81003ea8:	f406                	sd	ra,40(sp)
    81003eaa:	f022                	sd	s0,32(sp)
    81003eac:	ec26                	sd	s1,24(sp)
    81003eae:	e84a                	sd	s2,16(sp)
    81003eb0:	1800                	addi	s0,sp,48
    81003eb2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    81003eb4:	00850913          	addi	s2,a0,8
    81003eb8:	854a                	mv	a0,s2
    81003eba:	e8ffc0ef          	jal	81000d48 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    81003ebe:	409c                	lw	a5,0(s1)
    81003ec0:	ef81                	bnez	a5,81003ed8 <holdingsleep+0x32>
    81003ec2:	4481                	li	s1,0
  release(&lk->lk);
    81003ec4:	854a                	mv	a0,s2
    81003ec6:	f17fc0ef          	jal	81000ddc <release>
  return r;
}
    81003eca:	8526                	mv	a0,s1
    81003ecc:	70a2                	ld	ra,40(sp)
    81003ece:	7402                	ld	s0,32(sp)
    81003ed0:	64e2                	ld	s1,24(sp)
    81003ed2:	6942                	ld	s2,16(sp)
    81003ed4:	6145                	addi	sp,sp,48
    81003ed6:	8082                	ret
    81003ed8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    81003eda:	0284a983          	lw	s3,40(s1)
    81003ede:	b59fd0ef          	jal	81001a36 <myproc>
    81003ee2:	5904                	lw	s1,48(a0)
    81003ee4:	413484b3          	sub	s1,s1,s3
    81003ee8:	0014b493          	seqz	s1,s1
    81003eec:	69a2                	ld	s3,8(sp)
    81003eee:	bfd9                	j	81003ec4 <holdingsleep+0x1e>

0000000081003ef0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    81003ef0:	1141                	addi	sp,sp,-16
    81003ef2:	e406                	sd	ra,8(sp)
    81003ef4:	e022                	sd	s0,0(sp)
    81003ef6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    81003ef8:	00003597          	auipc	a1,0x3
    81003efc:	74858593          	addi	a1,a1,1864 # 81007640 <etext+0x640>
    81003f00:	0001c517          	auipc	a0,0x1c
    81003f04:	cd850513          	addi	a0,a0,-808 # 8101fbd8 <ftable>
    81003f08:	dbdfc0ef          	jal	81000cc4 <initlock>
}
    81003f0c:	60a2                	ld	ra,8(sp)
    81003f0e:	6402                	ld	s0,0(sp)
    81003f10:	0141                	addi	sp,sp,16
    81003f12:	8082                	ret

0000000081003f14 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    81003f14:	1101                	addi	sp,sp,-32
    81003f16:	ec06                	sd	ra,24(sp)
    81003f18:	e822                	sd	s0,16(sp)
    81003f1a:	e426                	sd	s1,8(sp)
    81003f1c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    81003f1e:	0001c517          	auipc	a0,0x1c
    81003f22:	cba50513          	addi	a0,a0,-838 # 8101fbd8 <ftable>
    81003f26:	e23fc0ef          	jal	81000d48 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    81003f2a:	0001c497          	auipc	s1,0x1c
    81003f2e:	cc648493          	addi	s1,s1,-826 # 8101fbf0 <ftable+0x18>
    81003f32:	0001d717          	auipc	a4,0x1d
    81003f36:	c5e70713          	addi	a4,a4,-930 # 81020b90 <disk>
    if(f->ref == 0){
    81003f3a:	40dc                	lw	a5,4(s1)
    81003f3c:	cf89                	beqz	a5,81003f56 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    81003f3e:	02848493          	addi	s1,s1,40
    81003f42:	fee49ce3          	bne	s1,a4,81003f3a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    81003f46:	0001c517          	auipc	a0,0x1c
    81003f4a:	c9250513          	addi	a0,a0,-878 # 8101fbd8 <ftable>
    81003f4e:	e8ffc0ef          	jal	81000ddc <release>
  return 0;
    81003f52:	4481                	li	s1,0
    81003f54:	a809                	j	81003f66 <filealloc+0x52>
      f->ref = 1;
    81003f56:	4785                	li	a5,1
    81003f58:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    81003f5a:	0001c517          	auipc	a0,0x1c
    81003f5e:	c7e50513          	addi	a0,a0,-898 # 8101fbd8 <ftable>
    81003f62:	e7bfc0ef          	jal	81000ddc <release>
}
    81003f66:	8526                	mv	a0,s1
    81003f68:	60e2                	ld	ra,24(sp)
    81003f6a:	6442                	ld	s0,16(sp)
    81003f6c:	64a2                	ld	s1,8(sp)
    81003f6e:	6105                	addi	sp,sp,32
    81003f70:	8082                	ret

0000000081003f72 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    81003f72:	1101                	addi	sp,sp,-32
    81003f74:	ec06                	sd	ra,24(sp)
    81003f76:	e822                	sd	s0,16(sp)
    81003f78:	e426                	sd	s1,8(sp)
    81003f7a:	1000                	addi	s0,sp,32
    81003f7c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    81003f7e:	0001c517          	auipc	a0,0x1c
    81003f82:	c5a50513          	addi	a0,a0,-934 # 8101fbd8 <ftable>
    81003f86:	dc3fc0ef          	jal	81000d48 <acquire>
  if(f->ref < 1)
    81003f8a:	40dc                	lw	a5,4(s1)
    81003f8c:	02f05063          	blez	a5,81003fac <filedup+0x3a>
    panic("filedup");
  f->ref++;
    81003f90:	2785                	addiw	a5,a5,1
    81003f92:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    81003f94:	0001c517          	auipc	a0,0x1c
    81003f98:	c4450513          	addi	a0,a0,-956 # 8101fbd8 <ftable>
    81003f9c:	e41fc0ef          	jal	81000ddc <release>
  return f;
}
    81003fa0:	8526                	mv	a0,s1
    81003fa2:	60e2                	ld	ra,24(sp)
    81003fa4:	6442                	ld	s0,16(sp)
    81003fa6:	64a2                	ld	s1,8(sp)
    81003fa8:	6105                	addi	sp,sp,32
    81003faa:	8082                	ret
    panic("filedup");
    81003fac:	00003517          	auipc	a0,0x3
    81003fb0:	69c50513          	addi	a0,a0,1692 # 81007648 <etext+0x648>
    81003fb4:	931fc0ef          	jal	810008e4 <panic>

0000000081003fb8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    81003fb8:	7139                	addi	sp,sp,-64
    81003fba:	fc06                	sd	ra,56(sp)
    81003fbc:	f822                	sd	s0,48(sp)
    81003fbe:	f426                	sd	s1,40(sp)
    81003fc0:	0080                	addi	s0,sp,64
    81003fc2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    81003fc4:	0001c517          	auipc	a0,0x1c
    81003fc8:	c1450513          	addi	a0,a0,-1004 # 8101fbd8 <ftable>
    81003fcc:	d7dfc0ef          	jal	81000d48 <acquire>
  if(f->ref < 1)
    81003fd0:	40dc                	lw	a5,4(s1)
    81003fd2:	04f05863          	blez	a5,81004022 <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    81003fd6:	37fd                	addiw	a5,a5,-1
    81003fd8:	c0dc                	sw	a5,4(s1)
    81003fda:	04f04e63          	bgtz	a5,81004036 <fileclose+0x7e>
    81003fde:	f04a                	sd	s2,32(sp)
    81003fe0:	ec4e                	sd	s3,24(sp)
    81003fe2:	e852                	sd	s4,16(sp)
    81003fe4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    81003fe6:	0004a903          	lw	s2,0(s1)
    81003fea:	0094ca83          	lbu	s5,9(s1)
    81003fee:	0104ba03          	ld	s4,16(s1)
    81003ff2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    81003ff6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    81003ffa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    81003ffe:	0001c517          	auipc	a0,0x1c
    81004002:	bda50513          	addi	a0,a0,-1062 # 8101fbd8 <ftable>
    81004006:	dd7fc0ef          	jal	81000ddc <release>

  if(ff.type == FD_PIPE){
    8100400a:	4785                	li	a5,1
    8100400c:	04f90063          	beq	s2,a5,8100404c <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    81004010:	3979                	addiw	s2,s2,-2
    81004012:	4785                	li	a5,1
    81004014:	0527f563          	bgeu	a5,s2,8100405e <fileclose+0xa6>
    81004018:	7902                	ld	s2,32(sp)
    8100401a:	69e2                	ld	s3,24(sp)
    8100401c:	6a42                	ld	s4,16(sp)
    8100401e:	6aa2                	ld	s5,8(sp)
    81004020:	a00d                	j	81004042 <fileclose+0x8a>
    81004022:	f04a                	sd	s2,32(sp)
    81004024:	ec4e                	sd	s3,24(sp)
    81004026:	e852                	sd	s4,16(sp)
    81004028:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8100402a:	00003517          	auipc	a0,0x3
    8100402e:	62650513          	addi	a0,a0,1574 # 81007650 <etext+0x650>
    81004032:	8b3fc0ef          	jal	810008e4 <panic>
    release(&ftable.lock);
    81004036:	0001c517          	auipc	a0,0x1c
    8100403a:	ba250513          	addi	a0,a0,-1118 # 8101fbd8 <ftable>
    8100403e:	d9ffc0ef          	jal	81000ddc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    81004042:	70e2                	ld	ra,56(sp)
    81004044:	7442                	ld	s0,48(sp)
    81004046:	74a2                	ld	s1,40(sp)
    81004048:	6121                	addi	sp,sp,64
    8100404a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8100404c:	85d6                	mv	a1,s5
    8100404e:	8552                	mv	a0,s4
    81004050:	340000ef          	jal	81004390 <pipeclose>
    81004054:	7902                	ld	s2,32(sp)
    81004056:	69e2                	ld	s3,24(sp)
    81004058:	6a42                	ld	s4,16(sp)
    8100405a:	6aa2                	ld	s5,8(sp)
    8100405c:	b7dd                	j	81004042 <fileclose+0x8a>
    begin_op();
    8100405e:	b3bff0ef          	jal	81003b98 <begin_op>
    iput(ff.ip);
    81004062:	854e                	mv	a0,s3
    81004064:	c04ff0ef          	jal	81003468 <iput>
    end_op();
    81004068:	b9bff0ef          	jal	81003c02 <end_op>
    8100406c:	7902                	ld	s2,32(sp)
    8100406e:	69e2                	ld	s3,24(sp)
    81004070:	6a42                	ld	s4,16(sp)
    81004072:	6aa2                	ld	s5,8(sp)
    81004074:	b7f9                	j	81004042 <fileclose+0x8a>

0000000081004076 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    81004076:	715d                	addi	sp,sp,-80
    81004078:	e486                	sd	ra,72(sp)
    8100407a:	e0a2                	sd	s0,64(sp)
    8100407c:	fc26                	sd	s1,56(sp)
    8100407e:	f44e                	sd	s3,40(sp)
    81004080:	0880                	addi	s0,sp,80
    81004082:	84aa                	mv	s1,a0
    81004084:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    81004086:	9b1fd0ef          	jal	81001a36 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8100408a:	409c                	lw	a5,0(s1)
    8100408c:	37f9                	addiw	a5,a5,-2
    8100408e:	4705                	li	a4,1
    81004090:	04f76263          	bltu	a4,a5,810040d4 <filestat+0x5e>
    81004094:	f84a                	sd	s2,48(sp)
    81004096:	f052                	sd	s4,32(sp)
    81004098:	892a                	mv	s2,a0
    ilock(f->ip);
    8100409a:	6c88                	ld	a0,24(s1)
    8100409c:	a4aff0ef          	jal	810032e6 <ilock>
    stati(f->ip, &st);
    810040a0:	fb840a13          	addi	s4,s0,-72
    810040a4:	85d2                	mv	a1,s4
    810040a6:	6c88                	ld	a0,24(s1)
    810040a8:	c68ff0ef          	jal	81003510 <stati>
    iunlock(f->ip);
    810040ac:	6c88                	ld	a0,24(s1)
    810040ae:	ae6ff0ef          	jal	81003394 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    810040b2:	46e1                	li	a3,24
    810040b4:	8652                	mv	a2,s4
    810040b6:	85ce                	mv	a1,s3
    810040b8:	05093503          	ld	a0,80(s2)
    810040bc:	e22fd0ef          	jal	810016de <copyout>
    810040c0:	41f5551b          	sraiw	a0,a0,0x1f
    810040c4:	7942                	ld	s2,48(sp)
    810040c6:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    810040c8:	60a6                	ld	ra,72(sp)
    810040ca:	6406                	ld	s0,64(sp)
    810040cc:	74e2                	ld	s1,56(sp)
    810040ce:	79a2                	ld	s3,40(sp)
    810040d0:	6161                	addi	sp,sp,80
    810040d2:	8082                	ret
  return -1;
    810040d4:	557d                	li	a0,-1
    810040d6:	bfcd                	j	810040c8 <filestat+0x52>

00000000810040d8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    810040d8:	7179                	addi	sp,sp,-48
    810040da:	f406                	sd	ra,40(sp)
    810040dc:	f022                	sd	s0,32(sp)
    810040de:	e84a                	sd	s2,16(sp)
    810040e0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    810040e2:	00854783          	lbu	a5,8(a0)
    810040e6:	cfd1                	beqz	a5,81004182 <fileread+0xaa>
    810040e8:	ec26                	sd	s1,24(sp)
    810040ea:	e44e                	sd	s3,8(sp)
    810040ec:	84aa                	mv	s1,a0
    810040ee:	89ae                	mv	s3,a1
    810040f0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    810040f2:	411c                	lw	a5,0(a0)
    810040f4:	4705                	li	a4,1
    810040f6:	04e78363          	beq	a5,a4,8100413c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    810040fa:	470d                	li	a4,3
    810040fc:	04e78763          	beq	a5,a4,8100414a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    81004100:	4709                	li	a4,2
    81004102:	06e79a63          	bne	a5,a4,81004176 <fileread+0x9e>
    ilock(f->ip);
    81004106:	6d08                	ld	a0,24(a0)
    81004108:	9deff0ef          	jal	810032e6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8100410c:	874a                	mv	a4,s2
    8100410e:	5094                	lw	a3,32(s1)
    81004110:	864e                	mv	a2,s3
    81004112:	4585                	li	a1,1
    81004114:	6c88                	ld	a0,24(s1)
    81004116:	c28ff0ef          	jal	8100353e <readi>
    8100411a:	892a                	mv	s2,a0
    8100411c:	00a05563          	blez	a0,81004126 <fileread+0x4e>
      f->off += r;
    81004120:	509c                	lw	a5,32(s1)
    81004122:	9fa9                	addw	a5,a5,a0
    81004124:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    81004126:	6c88                	ld	a0,24(s1)
    81004128:	a6cff0ef          	jal	81003394 <iunlock>
    8100412c:	64e2                	ld	s1,24(sp)
    8100412e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    81004130:	854a                	mv	a0,s2
    81004132:	70a2                	ld	ra,40(sp)
    81004134:	7402                	ld	s0,32(sp)
    81004136:	6942                	ld	s2,16(sp)
    81004138:	6145                	addi	sp,sp,48
    8100413a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8100413c:	6908                	ld	a0,16(a0)
    8100413e:	3a2000ef          	jal	810044e0 <piperead>
    81004142:	892a                	mv	s2,a0
    81004144:	64e2                	ld	s1,24(sp)
    81004146:	69a2                	ld	s3,8(sp)
    81004148:	b7e5                	j	81004130 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8100414a:	02451783          	lh	a5,36(a0)
    8100414e:	03079693          	slli	a3,a5,0x30
    81004152:	92c1                	srli	a3,a3,0x30
    81004154:	4725                	li	a4,9
    81004156:	02d76863          	bltu	a4,a3,81004186 <fileread+0xae>
    8100415a:	0792                	slli	a5,a5,0x4
    8100415c:	0001c717          	auipc	a4,0x1c
    81004160:	9dc70713          	addi	a4,a4,-1572 # 8101fb38 <devsw>
    81004164:	97ba                	add	a5,a5,a4
    81004166:	639c                	ld	a5,0(a5)
    81004168:	c39d                	beqz	a5,8100418e <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8100416a:	4505                	li	a0,1
    8100416c:	9782                	jalr	a5
    8100416e:	892a                	mv	s2,a0
    81004170:	64e2                	ld	s1,24(sp)
    81004172:	69a2                	ld	s3,8(sp)
    81004174:	bf75                	j	81004130 <fileread+0x58>
    panic("fileread");
    81004176:	00003517          	auipc	a0,0x3
    8100417a:	4ea50513          	addi	a0,a0,1258 # 81007660 <etext+0x660>
    8100417e:	f66fc0ef          	jal	810008e4 <panic>
    return -1;
    81004182:	597d                	li	s2,-1
    81004184:	b775                	j	81004130 <fileread+0x58>
      return -1;
    81004186:	597d                	li	s2,-1
    81004188:	64e2                	ld	s1,24(sp)
    8100418a:	69a2                	ld	s3,8(sp)
    8100418c:	b755                	j	81004130 <fileread+0x58>
    8100418e:	597d                	li	s2,-1
    81004190:	64e2                	ld	s1,24(sp)
    81004192:	69a2                	ld	s3,8(sp)
    81004194:	bf71                	j	81004130 <fileread+0x58>

0000000081004196 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    81004196:	00954783          	lbu	a5,9(a0)
    8100419a:	10078e63          	beqz	a5,810042b6 <filewrite+0x120>
{
    8100419e:	711d                	addi	sp,sp,-96
    810041a0:	ec86                	sd	ra,88(sp)
    810041a2:	e8a2                	sd	s0,80(sp)
    810041a4:	e0ca                	sd	s2,64(sp)
    810041a6:	f456                	sd	s5,40(sp)
    810041a8:	f05a                	sd	s6,32(sp)
    810041aa:	1080                	addi	s0,sp,96
    810041ac:	892a                	mv	s2,a0
    810041ae:	8b2e                	mv	s6,a1
    810041b0:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    810041b2:	411c                	lw	a5,0(a0)
    810041b4:	4705                	li	a4,1
    810041b6:	02e78963          	beq	a5,a4,810041e8 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    810041ba:	470d                	li	a4,3
    810041bc:	02e78a63          	beq	a5,a4,810041f0 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    810041c0:	4709                	li	a4,2
    810041c2:	0ce79e63          	bne	a5,a4,8100429e <filewrite+0x108>
    810041c6:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    810041c8:	0ac05963          	blez	a2,8100427a <filewrite+0xe4>
    810041cc:	e4a6                	sd	s1,72(sp)
    810041ce:	fc4e                	sd	s3,56(sp)
    810041d0:	ec5e                	sd	s7,24(sp)
    810041d2:	e862                	sd	s8,16(sp)
    810041d4:	e466                	sd	s9,8(sp)
    int i = 0;
    810041d6:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    810041d8:	6b85                	lui	s7,0x1
    810041da:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x80fff400>
    810041de:	6c85                	lui	s9,0x1
    810041e0:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x80fff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    810041e4:	4c05                	li	s8,1
    810041e6:	a8ad                	j	81004260 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    810041e8:	6908                	ld	a0,16(a0)
    810041ea:	1fe000ef          	jal	810043e8 <pipewrite>
    810041ee:	a04d                	j	81004290 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    810041f0:	02451783          	lh	a5,36(a0)
    810041f4:	03079693          	slli	a3,a5,0x30
    810041f8:	92c1                	srli	a3,a3,0x30
    810041fa:	4725                	li	a4,9
    810041fc:	0ad76f63          	bltu	a4,a3,810042ba <filewrite+0x124>
    81004200:	0792                	slli	a5,a5,0x4
    81004202:	0001c717          	auipc	a4,0x1c
    81004206:	93670713          	addi	a4,a4,-1738 # 8101fb38 <devsw>
    8100420a:	97ba                	add	a5,a5,a4
    8100420c:	679c                	ld	a5,8(a5)
    8100420e:	cbc5                	beqz	a5,810042be <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    81004210:	4505                	li	a0,1
    81004212:	9782                	jalr	a5
    81004214:	a8b5                	j	81004290 <filewrite+0xfa>
      if(n1 > max)
    81004216:	2981                	sext.w	s3,s3
      begin_op();
    81004218:	981ff0ef          	jal	81003b98 <begin_op>
      ilock(f->ip);
    8100421c:	01893503          	ld	a0,24(s2)
    81004220:	8c6ff0ef          	jal	810032e6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    81004224:	874e                	mv	a4,s3
    81004226:	02092683          	lw	a3,32(s2)
    8100422a:	016a0633          	add	a2,s4,s6
    8100422e:	85e2                	mv	a1,s8
    81004230:	01893503          	ld	a0,24(s2)
    81004234:	bfcff0ef          	jal	81003630 <writei>
    81004238:	84aa                	mv	s1,a0
    8100423a:	00a05763          	blez	a0,81004248 <filewrite+0xb2>
        f->off += r;
    8100423e:	02092783          	lw	a5,32(s2)
    81004242:	9fa9                	addw	a5,a5,a0
    81004244:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    81004248:	01893503          	ld	a0,24(s2)
    8100424c:	948ff0ef          	jal	81003394 <iunlock>
      end_op();
    81004250:	9b3ff0ef          	jal	81003c02 <end_op>

      if(r != n1){
    81004254:	02999563          	bne	s3,s1,8100427e <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    81004258:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    8100425c:	015a5963          	bge	s4,s5,8100426e <filewrite+0xd8>
      int n1 = n - i;
    81004260:	414a87bb          	subw	a5,s5,s4
    81004264:	89be                	mv	s3,a5
      if(n1 > max)
    81004266:	fafbd8e3          	bge	s7,a5,81004216 <filewrite+0x80>
    8100426a:	89e6                	mv	s3,s9
    8100426c:	b76d                	j	81004216 <filewrite+0x80>
    8100426e:	64a6                	ld	s1,72(sp)
    81004270:	79e2                	ld	s3,56(sp)
    81004272:	6be2                	ld	s7,24(sp)
    81004274:	6c42                	ld	s8,16(sp)
    81004276:	6ca2                	ld	s9,8(sp)
    81004278:	a801                	j	81004288 <filewrite+0xf2>
    int i = 0;
    8100427a:	4a01                	li	s4,0
    8100427c:	a031                	j	81004288 <filewrite+0xf2>
    8100427e:	64a6                	ld	s1,72(sp)
    81004280:	79e2                	ld	s3,56(sp)
    81004282:	6be2                	ld	s7,24(sp)
    81004284:	6c42                	ld	s8,16(sp)
    81004286:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    81004288:	034a9d63          	bne	s5,s4,810042c2 <filewrite+0x12c>
    8100428c:	8556                	mv	a0,s5
    8100428e:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    81004290:	60e6                	ld	ra,88(sp)
    81004292:	6446                	ld	s0,80(sp)
    81004294:	6906                	ld	s2,64(sp)
    81004296:	7aa2                	ld	s5,40(sp)
    81004298:	7b02                	ld	s6,32(sp)
    8100429a:	6125                	addi	sp,sp,96
    8100429c:	8082                	ret
    8100429e:	e4a6                	sd	s1,72(sp)
    810042a0:	fc4e                	sd	s3,56(sp)
    810042a2:	f852                	sd	s4,48(sp)
    810042a4:	ec5e                	sd	s7,24(sp)
    810042a6:	e862                	sd	s8,16(sp)
    810042a8:	e466                	sd	s9,8(sp)
    panic("filewrite");
    810042aa:	00003517          	auipc	a0,0x3
    810042ae:	3c650513          	addi	a0,a0,966 # 81007670 <etext+0x670>
    810042b2:	e32fc0ef          	jal	810008e4 <panic>
    return -1;
    810042b6:	557d                	li	a0,-1
}
    810042b8:	8082                	ret
      return -1;
    810042ba:	557d                	li	a0,-1
    810042bc:	bfd1                	j	81004290 <filewrite+0xfa>
    810042be:	557d                	li	a0,-1
    810042c0:	bfc1                	j	81004290 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    810042c2:	557d                	li	a0,-1
    810042c4:	7a42                	ld	s4,48(sp)
    810042c6:	b7e9                	j	81004290 <filewrite+0xfa>

00000000810042c8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    810042c8:	7179                	addi	sp,sp,-48
    810042ca:	f406                	sd	ra,40(sp)
    810042cc:	f022                	sd	s0,32(sp)
    810042ce:	ec26                	sd	s1,24(sp)
    810042d0:	e052                	sd	s4,0(sp)
    810042d2:	1800                	addi	s0,sp,48
    810042d4:	84aa                	mv	s1,a0
    810042d6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    810042d8:	0005b023          	sd	zero,0(a1)
    810042dc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    810042e0:	c35ff0ef          	jal	81003f14 <filealloc>
    810042e4:	e088                	sd	a0,0(s1)
    810042e6:	c549                	beqz	a0,81004370 <pipealloc+0xa8>
    810042e8:	c2dff0ef          	jal	81003f14 <filealloc>
    810042ec:	00aa3023          	sd	a0,0(s4)
    810042f0:	cd25                	beqz	a0,81004368 <pipealloc+0xa0>
    810042f2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    810042f4:	981fc0ef          	jal	81000c74 <kalloc>
    810042f8:	892a                	mv	s2,a0
    810042fa:	c12d                	beqz	a0,8100435c <pipealloc+0x94>
    810042fc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    810042fe:	4985                	li	s3,1
    81004300:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    81004304:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    81004308:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8100430c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    81004310:	00003597          	auipc	a1,0x3
    81004314:	37058593          	addi	a1,a1,880 # 81007680 <etext+0x680>
    81004318:	9adfc0ef          	jal	81000cc4 <initlock>
  (*f0)->type = FD_PIPE;
    8100431c:	609c                	ld	a5,0(s1)
    8100431e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    81004322:	609c                	ld	a5,0(s1)
    81004324:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    81004328:	609c                	ld	a5,0(s1)
    8100432a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8100432e:	609c                	ld	a5,0(s1)
    81004330:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    81004334:	000a3783          	ld	a5,0(s4)
    81004338:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8100433c:	000a3783          	ld	a5,0(s4)
    81004340:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    81004344:	000a3783          	ld	a5,0(s4)
    81004348:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8100434c:	000a3783          	ld	a5,0(s4)
    81004350:	0127b823          	sd	s2,16(a5)
  return 0;
    81004354:	4501                	li	a0,0
    81004356:	6942                	ld	s2,16(sp)
    81004358:	69a2                	ld	s3,8(sp)
    8100435a:	a01d                	j	81004380 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8100435c:	6088                	ld	a0,0(s1)
    8100435e:	c119                	beqz	a0,81004364 <pipealloc+0x9c>
    81004360:	6942                	ld	s2,16(sp)
    81004362:	a029                	j	8100436c <pipealloc+0xa4>
    81004364:	6942                	ld	s2,16(sp)
    81004366:	a029                	j	81004370 <pipealloc+0xa8>
    81004368:	6088                	ld	a0,0(s1)
    8100436a:	c10d                	beqz	a0,8100438c <pipealloc+0xc4>
    fileclose(*f0);
    8100436c:	c4dff0ef          	jal	81003fb8 <fileclose>
  if(*f1)
    81004370:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    81004374:	557d                	li	a0,-1
  if(*f1)
    81004376:	c789                	beqz	a5,81004380 <pipealloc+0xb8>
    fileclose(*f1);
    81004378:	853e                	mv	a0,a5
    8100437a:	c3fff0ef          	jal	81003fb8 <fileclose>
  return -1;
    8100437e:	557d                	li	a0,-1
}
    81004380:	70a2                	ld	ra,40(sp)
    81004382:	7402                	ld	s0,32(sp)
    81004384:	64e2                	ld	s1,24(sp)
    81004386:	6a02                	ld	s4,0(sp)
    81004388:	6145                	addi	sp,sp,48
    8100438a:	8082                	ret
  return -1;
    8100438c:	557d                	li	a0,-1
    8100438e:	bfcd                	j	81004380 <pipealloc+0xb8>

0000000081004390 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    81004390:	1101                	addi	sp,sp,-32
    81004392:	ec06                	sd	ra,24(sp)
    81004394:	e822                	sd	s0,16(sp)
    81004396:	e426                	sd	s1,8(sp)
    81004398:	e04a                	sd	s2,0(sp)
    8100439a:	1000                	addi	s0,sp,32
    8100439c:	84aa                	mv	s1,a0
    8100439e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    810043a0:	9a9fc0ef          	jal	81000d48 <acquire>
  if(writable){
    810043a4:	02090763          	beqz	s2,810043d2 <pipeclose+0x42>
    pi->writeopen = 0;
    810043a8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    810043ac:	21848513          	addi	a0,s1,536
    810043b0:	ca1fd0ef          	jal	81002050 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    810043b4:	2204b783          	ld	a5,544(s1)
    810043b8:	e785                	bnez	a5,810043e0 <pipeclose+0x50>
    release(&pi->lock);
    810043ba:	8526                	mv	a0,s1
    810043bc:	a21fc0ef          	jal	81000ddc <release>
    kfree((char*)pi);
    810043c0:	8526                	mv	a0,s1
    810043c2:	fccfc0ef          	jal	81000b8e <kfree>
  } else
    release(&pi->lock);
}
    810043c6:	60e2                	ld	ra,24(sp)
    810043c8:	6442                	ld	s0,16(sp)
    810043ca:	64a2                	ld	s1,8(sp)
    810043cc:	6902                	ld	s2,0(sp)
    810043ce:	6105                	addi	sp,sp,32
    810043d0:	8082                	ret
    pi->readopen = 0;
    810043d2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    810043d6:	21c48513          	addi	a0,s1,540
    810043da:	c77fd0ef          	jal	81002050 <wakeup>
    810043de:	bfd9                	j	810043b4 <pipeclose+0x24>
    release(&pi->lock);
    810043e0:	8526                	mv	a0,s1
    810043e2:	9fbfc0ef          	jal	81000ddc <release>
}
    810043e6:	b7c5                	j	810043c6 <pipeclose+0x36>

00000000810043e8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    810043e8:	7159                	addi	sp,sp,-112
    810043ea:	f486                	sd	ra,104(sp)
    810043ec:	f0a2                	sd	s0,96(sp)
    810043ee:	eca6                	sd	s1,88(sp)
    810043f0:	e8ca                	sd	s2,80(sp)
    810043f2:	e4ce                	sd	s3,72(sp)
    810043f4:	e0d2                	sd	s4,64(sp)
    810043f6:	fc56                	sd	s5,56(sp)
    810043f8:	1880                	addi	s0,sp,112
    810043fa:	84aa                	mv	s1,a0
    810043fc:	8aae                	mv	s5,a1
    810043fe:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    81004400:	e36fd0ef          	jal	81001a36 <myproc>
    81004404:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    81004406:	8526                	mv	a0,s1
    81004408:	941fc0ef          	jal	81000d48 <acquire>
  while(i < n){
    8100440c:	0d405263          	blez	s4,810044d0 <pipewrite+0xe8>
    81004410:	f85a                	sd	s6,48(sp)
    81004412:	f45e                	sd	s7,40(sp)
    81004414:	f062                	sd	s8,32(sp)
    81004416:	ec66                	sd	s9,24(sp)
    81004418:	e86a                	sd	s10,16(sp)
  int i = 0;
    8100441a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8100441c:	f9f40c13          	addi	s8,s0,-97
    81004420:	4b85                	li	s7,1
    81004422:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    81004424:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    81004428:	21c48c93          	addi	s9,s1,540
    8100442c:	a82d                	j	81004466 <pipewrite+0x7e>
      release(&pi->lock);
    8100442e:	8526                	mv	a0,s1
    81004430:	9adfc0ef          	jal	81000ddc <release>
      return -1;
    81004434:	597d                	li	s2,-1
    81004436:	7b42                	ld	s6,48(sp)
    81004438:	7ba2                	ld	s7,40(sp)
    8100443a:	7c02                	ld	s8,32(sp)
    8100443c:	6ce2                	ld	s9,24(sp)
    8100443e:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    81004440:	854a                	mv	a0,s2
    81004442:	70a6                	ld	ra,104(sp)
    81004444:	7406                	ld	s0,96(sp)
    81004446:	64e6                	ld	s1,88(sp)
    81004448:	6946                	ld	s2,80(sp)
    8100444a:	69a6                	ld	s3,72(sp)
    8100444c:	6a06                	ld	s4,64(sp)
    8100444e:	7ae2                	ld	s5,56(sp)
    81004450:	6165                	addi	sp,sp,112
    81004452:	8082                	ret
      wakeup(&pi->nread);
    81004454:	856a                	mv	a0,s10
    81004456:	bfbfd0ef          	jal	81002050 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8100445a:	85a6                	mv	a1,s1
    8100445c:	8566                	mv	a0,s9
    8100445e:	ba7fd0ef          	jal	81002004 <sleep>
  while(i < n){
    81004462:	05495a63          	bge	s2,s4,810044b6 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    81004466:	2204a783          	lw	a5,544(s1)
    8100446a:	d3f1                	beqz	a5,8100442e <pipewrite+0x46>
    8100446c:	854e                	mv	a0,s3
    8100446e:	dcffd0ef          	jal	8100223c <killed>
    81004472:	fd55                	bnez	a0,8100442e <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    81004474:	2184a783          	lw	a5,536(s1)
    81004478:	21c4a703          	lw	a4,540(s1)
    8100447c:	2007879b          	addiw	a5,a5,512
    81004480:	fcf70ae3          	beq	a4,a5,81004454 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    81004484:	86de                	mv	a3,s7
    81004486:	01590633          	add	a2,s2,s5
    8100448a:	85e2                	mv	a1,s8
    8100448c:	0509b503          	ld	a0,80(s3)
    81004490:	afefd0ef          	jal	8100178e <copyin>
    81004494:	05650063          	beq	a0,s6,810044d4 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    81004498:	21c4a783          	lw	a5,540(s1)
    8100449c:	0017871b          	addiw	a4,a5,1
    810044a0:	20e4ae23          	sw	a4,540(s1)
    810044a4:	1ff7f793          	andi	a5,a5,511
    810044a8:	97a6                	add	a5,a5,s1
    810044aa:	f9f44703          	lbu	a4,-97(s0)
    810044ae:	00e78c23          	sb	a4,24(a5)
      i++;
    810044b2:	2905                	addiw	s2,s2,1
    810044b4:	b77d                	j	81004462 <pipewrite+0x7a>
    810044b6:	7b42                	ld	s6,48(sp)
    810044b8:	7ba2                	ld	s7,40(sp)
    810044ba:	7c02                	ld	s8,32(sp)
    810044bc:	6ce2                	ld	s9,24(sp)
    810044be:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    810044c0:	21848513          	addi	a0,s1,536
    810044c4:	b8dfd0ef          	jal	81002050 <wakeup>
  release(&pi->lock);
    810044c8:	8526                	mv	a0,s1
    810044ca:	913fc0ef          	jal	81000ddc <release>
  return i;
    810044ce:	bf8d                	j	81004440 <pipewrite+0x58>
  int i = 0;
    810044d0:	4901                	li	s2,0
    810044d2:	b7fd                	j	810044c0 <pipewrite+0xd8>
    810044d4:	7b42                	ld	s6,48(sp)
    810044d6:	7ba2                	ld	s7,40(sp)
    810044d8:	7c02                	ld	s8,32(sp)
    810044da:	6ce2                	ld	s9,24(sp)
    810044dc:	6d42                	ld	s10,16(sp)
    810044de:	b7cd                	j	810044c0 <pipewrite+0xd8>

00000000810044e0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    810044e0:	711d                	addi	sp,sp,-96
    810044e2:	ec86                	sd	ra,88(sp)
    810044e4:	e8a2                	sd	s0,80(sp)
    810044e6:	e4a6                	sd	s1,72(sp)
    810044e8:	e0ca                	sd	s2,64(sp)
    810044ea:	fc4e                	sd	s3,56(sp)
    810044ec:	f852                	sd	s4,48(sp)
    810044ee:	f456                	sd	s5,40(sp)
    810044f0:	1080                	addi	s0,sp,96
    810044f2:	84aa                	mv	s1,a0
    810044f4:	892e                	mv	s2,a1
    810044f6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    810044f8:	d3efd0ef          	jal	81001a36 <myproc>
    810044fc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    810044fe:	8526                	mv	a0,s1
    81004500:	849fc0ef          	jal	81000d48 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    81004504:	2184a703          	lw	a4,536(s1)
    81004508:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8100450c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    81004510:	02f71763          	bne	a4,a5,8100453e <piperead+0x5e>
    81004514:	2244a783          	lw	a5,548(s1)
    81004518:	cf85                	beqz	a5,81004550 <piperead+0x70>
    if(killed(pr)){
    8100451a:	8552                	mv	a0,s4
    8100451c:	d21fd0ef          	jal	8100223c <killed>
    81004520:	e11d                	bnez	a0,81004546 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    81004522:	85a6                	mv	a1,s1
    81004524:	854e                	mv	a0,s3
    81004526:	adffd0ef          	jal	81002004 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8100452a:	2184a703          	lw	a4,536(s1)
    8100452e:	21c4a783          	lw	a5,540(s1)
    81004532:	fef701e3          	beq	a4,a5,81004514 <piperead+0x34>
    81004536:	f05a                	sd	s6,32(sp)
    81004538:	ec5e                	sd	s7,24(sp)
    8100453a:	e862                	sd	s8,16(sp)
    8100453c:	a829                	j	81004556 <piperead+0x76>
    8100453e:	f05a                	sd	s6,32(sp)
    81004540:	ec5e                	sd	s7,24(sp)
    81004542:	e862                	sd	s8,16(sp)
    81004544:	a809                	j	81004556 <piperead+0x76>
      release(&pi->lock);
    81004546:	8526                	mv	a0,s1
    81004548:	895fc0ef          	jal	81000ddc <release>
      return -1;
    8100454c:	59fd                	li	s3,-1
    8100454e:	a0a5                	j	810045b6 <piperead+0xd6>
    81004550:	f05a                	sd	s6,32(sp)
    81004552:	ec5e                	sd	s7,24(sp)
    81004554:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    81004556:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    81004558:	faf40c13          	addi	s8,s0,-81
    8100455c:	4b85                	li	s7,1
    8100455e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    81004560:	05505163          	blez	s5,810045a2 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    81004564:	2184a783          	lw	a5,536(s1)
    81004568:	21c4a703          	lw	a4,540(s1)
    8100456c:	02f70b63          	beq	a4,a5,810045a2 <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    81004570:	0017871b          	addiw	a4,a5,1
    81004574:	20e4ac23          	sw	a4,536(s1)
    81004578:	1ff7f793          	andi	a5,a5,511
    8100457c:	97a6                	add	a5,a5,s1
    8100457e:	0187c783          	lbu	a5,24(a5)
    81004582:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    81004586:	86de                	mv	a3,s7
    81004588:	8662                	mv	a2,s8
    8100458a:	85ca                	mv	a1,s2
    8100458c:	050a3503          	ld	a0,80(s4)
    81004590:	94efd0ef          	jal	810016de <copyout>
    81004594:	01650763          	beq	a0,s6,810045a2 <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    81004598:	2985                	addiw	s3,s3,1
    8100459a:	0905                	addi	s2,s2,1
    8100459c:	fd3a94e3          	bne	s5,s3,81004564 <piperead+0x84>
    810045a0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    810045a2:	21c48513          	addi	a0,s1,540
    810045a6:	aabfd0ef          	jal	81002050 <wakeup>
  release(&pi->lock);
    810045aa:	8526                	mv	a0,s1
    810045ac:	831fc0ef          	jal	81000ddc <release>
    810045b0:	7b02                	ld	s6,32(sp)
    810045b2:	6be2                	ld	s7,24(sp)
    810045b4:	6c42                	ld	s8,16(sp)
  return i;
}
    810045b6:	854e                	mv	a0,s3
    810045b8:	60e6                	ld	ra,88(sp)
    810045ba:	6446                	ld	s0,80(sp)
    810045bc:	64a6                	ld	s1,72(sp)
    810045be:	6906                	ld	s2,64(sp)
    810045c0:	79e2                	ld	s3,56(sp)
    810045c2:	7a42                	ld	s4,48(sp)
    810045c4:	7aa2                	ld	s5,40(sp)
    810045c6:	6125                	addi	sp,sp,96
    810045c8:	8082                	ret

00000000810045ca <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    810045ca:	1141                	addi	sp,sp,-16
    810045cc:	e406                	sd	ra,8(sp)
    810045ce:	e022                	sd	s0,0(sp)
    810045d0:	0800                	addi	s0,sp,16
    810045d2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    810045d4:	0035151b          	slliw	a0,a0,0x3
    810045d8:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    810045da:	8b89                	andi	a5,a5,2
    810045dc:	c399                	beqz	a5,810045e2 <flags2perm+0x18>
      perm |= PTE_W;
    810045de:	00456513          	ori	a0,a0,4
    return perm;
}
    810045e2:	60a2                	ld	ra,8(sp)
    810045e4:	6402                	ld	s0,0(sp)
    810045e6:	0141                	addi	sp,sp,16
    810045e8:	8082                	ret

00000000810045ea <exec>:

int
exec(char *path, char **argv)
{
    810045ea:	de010113          	addi	sp,sp,-544
    810045ee:	20113c23          	sd	ra,536(sp)
    810045f2:	20813823          	sd	s0,528(sp)
    810045f6:	20913423          	sd	s1,520(sp)
    810045fa:	21213023          	sd	s2,512(sp)
    810045fe:	1400                	addi	s0,sp,544
    81004600:	892a                	mv	s2,a0
    81004602:	dea43823          	sd	a0,-528(s0)
    81004606:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8100460a:	c2cfd0ef          	jal	81001a36 <myproc>
    8100460e:	84aa                	mv	s1,a0

  begin_op();
    81004610:	d88ff0ef          	jal	81003b98 <begin_op>

  if((ip = namei(path)) == 0){
    81004614:	854a                	mv	a0,s2
    81004616:	bc0ff0ef          	jal	810039d6 <namei>
    8100461a:	cd21                	beqz	a0,81004672 <exec+0x88>
    8100461c:	fbd2                	sd	s4,496(sp)
    8100461e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    81004620:	cc7fe0ef          	jal	810032e6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    81004624:	04000713          	li	a4,64
    81004628:	4681                	li	a3,0
    8100462a:	e5040613          	addi	a2,s0,-432
    8100462e:	4581                	li	a1,0
    81004630:	8552                	mv	a0,s4
    81004632:	f0dfe0ef          	jal	8100353e <readi>
    81004636:	04000793          	li	a5,64
    8100463a:	00f51a63          	bne	a0,a5,8100464e <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8100463e:	e5042703          	lw	a4,-432(s0)
    81004642:	464c47b7          	lui	a5,0x464c4
    81004646:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x3ab3ba81>
    8100464a:	02f70863          	beq	a4,a5,8100467a <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8100464e:	8552                	mv	a0,s4
    81004650:	ea1fe0ef          	jal	810034f0 <iunlockput>
    end_op();
    81004654:	daeff0ef          	jal	81003c02 <end_op>
  }
  return -1;
    81004658:	557d                	li	a0,-1
    8100465a:	7a5e                	ld	s4,496(sp)
}
    8100465c:	21813083          	ld	ra,536(sp)
    81004660:	21013403          	ld	s0,528(sp)
    81004664:	20813483          	ld	s1,520(sp)
    81004668:	20013903          	ld	s2,512(sp)
    8100466c:	22010113          	addi	sp,sp,544
    81004670:	8082                	ret
    end_op();
    81004672:	d90ff0ef          	jal	81003c02 <end_op>
    return -1;
    81004676:	557d                	li	a0,-1
    81004678:	b7d5                	j	8100465c <exec+0x72>
    8100467a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8100467c:	8526                	mv	a0,s1
    8100467e:	c60fd0ef          	jal	81001ade <proc_pagetable>
    81004682:	8b2a                	mv	s6,a0
    81004684:	26050d63          	beqz	a0,810048fe <exec+0x314>
    81004688:	ffce                	sd	s3,504(sp)
    8100468a:	f7d6                	sd	s5,488(sp)
    8100468c:	efde                	sd	s7,472(sp)
    8100468e:	ebe2                	sd	s8,464(sp)
    81004690:	e7e6                	sd	s9,456(sp)
    81004692:	e3ea                	sd	s10,448(sp)
    81004694:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    81004696:	e7042683          	lw	a3,-400(s0)
    8100469a:	e8845783          	lhu	a5,-376(s0)
    8100469e:	0e078763          	beqz	a5,8100478c <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    810046a2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    810046a4:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    810046a6:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    810046aa:	6c85                	lui	s9,0x1
    810046ac:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x80fff001>
    810046b0:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    810046b4:	6a85                	lui	s5,0x1
    810046b6:	a085                	j	81004716 <exec+0x12c>
      panic("loadseg: address should exist");
    810046b8:	00003517          	auipc	a0,0x3
    810046bc:	fd050513          	addi	a0,a0,-48 # 81007688 <etext+0x688>
    810046c0:	a24fc0ef          	jal	810008e4 <panic>
    if(sz - i < PGSIZE)
    810046c4:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    810046c6:	874a                	mv	a4,s2
    810046c8:	009c06bb          	addw	a3,s8,s1
    810046cc:	4581                	li	a1,0
    810046ce:	8552                	mv	a0,s4
    810046d0:	e6ffe0ef          	jal	8100353e <readi>
    810046d4:	22a91963          	bne	s2,a0,81004906 <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    810046d8:	009a84bb          	addw	s1,s5,s1
    810046dc:	0334f263          	bgeu	s1,s3,81004700 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    810046e0:	02049593          	slli	a1,s1,0x20
    810046e4:	9181                	srli	a1,a1,0x20
    810046e6:	95de                	add	a1,a1,s7
    810046e8:	855a                	mv	a0,s6
    810046ea:	a69fc0ef          	jal	81001152 <walkaddr>
    810046ee:	862a                	mv	a2,a0
    if(pa == 0)
    810046f0:	d561                	beqz	a0,810046b8 <exec+0xce>
    if(sz - i < PGSIZE)
    810046f2:	409987bb          	subw	a5,s3,s1
    810046f6:	893e                	mv	s2,a5
    810046f8:	fcfcf6e3          	bgeu	s9,a5,810046c4 <exec+0xda>
    810046fc:	8956                	mv	s2,s5
    810046fe:	b7d9                	j	810046c4 <exec+0xda>
    sz = sz1;
    81004700:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    81004704:	2d05                	addiw	s10,s10,1
    81004706:	e0843783          	ld	a5,-504(s0)
    8100470a:	0387869b          	addiw	a3,a5,56
    8100470e:	e8845783          	lhu	a5,-376(s0)
    81004712:	06fd5e63          	bge	s10,a5,8100478e <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    81004716:	e0d43423          	sd	a3,-504(s0)
    8100471a:	876e                	mv	a4,s11
    8100471c:	e1840613          	addi	a2,s0,-488
    81004720:	4581                	li	a1,0
    81004722:	8552                	mv	a0,s4
    81004724:	e1bfe0ef          	jal	8100353e <readi>
    81004728:	1db51d63          	bne	a0,s11,81004902 <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    8100472c:	e1842783          	lw	a5,-488(s0)
    81004730:	4705                	li	a4,1
    81004732:	fce799e3          	bne	a5,a4,81004704 <exec+0x11a>
    if(ph.memsz < ph.filesz)
    81004736:	e4043483          	ld	s1,-448(s0)
    8100473a:	e3843783          	ld	a5,-456(s0)
    8100473e:	1ef4e263          	bltu	s1,a5,81004922 <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    81004742:	e2843783          	ld	a5,-472(s0)
    81004746:	94be                	add	s1,s1,a5
    81004748:	1ef4e063          	bltu	s1,a5,81004928 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    8100474c:	de843703          	ld	a4,-536(s0)
    81004750:	8ff9                	and	a5,a5,a4
    81004752:	1c079e63          	bnez	a5,8100492e <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    81004756:	e1c42503          	lw	a0,-484(s0)
    8100475a:	e71ff0ef          	jal	810045ca <flags2perm>
    8100475e:	86aa                	mv	a3,a0
    81004760:	8626                	mv	a2,s1
    81004762:	85ca                	mv	a1,s2
    81004764:	855a                	mv	a0,s6
    81004766:	d59fc0ef          	jal	810014be <uvmalloc>
    8100476a:	dea43c23          	sd	a0,-520(s0)
    8100476e:	1c050363          	beqz	a0,81004934 <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    81004772:	e2843b83          	ld	s7,-472(s0)
    81004776:	e2042c03          	lw	s8,-480(s0)
    8100477a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8100477e:	00098463          	beqz	s3,81004786 <exec+0x19c>
    81004782:	4481                	li	s1,0
    81004784:	bfb1                	j	810046e0 <exec+0xf6>
    sz = sz1;
    81004786:	df843903          	ld	s2,-520(s0)
    8100478a:	bfad                	j	81004704 <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8100478c:	4901                	li	s2,0
  iunlockput(ip);
    8100478e:	8552                	mv	a0,s4
    81004790:	d61fe0ef          	jal	810034f0 <iunlockput>
  end_op();
    81004794:	c6eff0ef          	jal	81003c02 <end_op>
  p = myproc();
    81004798:	a9efd0ef          	jal	81001a36 <myproc>
    8100479c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8100479e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    810047a2:	6985                	lui	s3,0x1
    810047a4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x80fff001>
    810047a6:	99ca                	add	s3,s3,s2
    810047a8:	77fd                	lui	a5,0xfffff
    810047aa:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    810047ae:	4691                	li	a3,4
    810047b0:	6609                	lui	a2,0x2
    810047b2:	964e                	add	a2,a2,s3
    810047b4:	85ce                	mv	a1,s3
    810047b6:	855a                	mv	a0,s6
    810047b8:	d07fc0ef          	jal	810014be <uvmalloc>
    810047bc:	8a2a                	mv	s4,a0
    810047be:	e105                	bnez	a0,810047de <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    810047c0:	85ce                	mv	a1,s3
    810047c2:	855a                	mv	a0,s6
    810047c4:	b9efd0ef          	jal	81001b62 <proc_freepagetable>
  return -1;
    810047c8:	557d                	li	a0,-1
    810047ca:	79fe                	ld	s3,504(sp)
    810047cc:	7a5e                	ld	s4,496(sp)
    810047ce:	7abe                	ld	s5,488(sp)
    810047d0:	7b1e                	ld	s6,480(sp)
    810047d2:	6bfe                	ld	s7,472(sp)
    810047d4:	6c5e                	ld	s8,464(sp)
    810047d6:	6cbe                	ld	s9,456(sp)
    810047d8:	6d1e                	ld	s10,448(sp)
    810047da:	7dfa                	ld	s11,440(sp)
    810047dc:	b541                	j	8100465c <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    810047de:	75f9                	lui	a1,0xffffe
    810047e0:	95aa                	add	a1,a1,a0
    810047e2:	855a                	mv	a0,s6
    810047e4:	ed1fc0ef          	jal	810016b4 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    810047e8:	7bfd                	lui	s7,0xfffff
    810047ea:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    810047ec:	e0043783          	ld	a5,-512(s0)
    810047f0:	6388                	ld	a0,0(a5)
  sp = sz;
    810047f2:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    810047f4:	4481                	li	s1,0
    ustack[argc] = sp;
    810047f6:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    810047fa:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    810047fe:	cd21                	beqz	a0,81004856 <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    81004800:	fa0fc0ef          	jal	81000fa0 <strlen>
    81004804:	0015079b          	addiw	a5,a0,1
    81004808:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8100480c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    81004810:	13796563          	bltu	s2,s7,8100493a <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    81004814:	e0043d83          	ld	s11,-512(s0)
    81004818:	000db983          	ld	s3,0(s11)
    8100481c:	854e                	mv	a0,s3
    8100481e:	f82fc0ef          	jal	81000fa0 <strlen>
    81004822:	0015069b          	addiw	a3,a0,1
    81004826:	864e                	mv	a2,s3
    81004828:	85ca                	mv	a1,s2
    8100482a:	855a                	mv	a0,s6
    8100482c:	eb3fc0ef          	jal	810016de <copyout>
    81004830:	10054763          	bltz	a0,8100493e <exec+0x354>
    ustack[argc] = sp;
    81004834:	00349793          	slli	a5,s1,0x3
    81004838:	97e6                	add	a5,a5,s9
    8100483a:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7efde000>
  for(argc = 0; argv[argc]; argc++) {
    8100483e:	0485                	addi	s1,s1,1
    81004840:	008d8793          	addi	a5,s11,8
    81004844:	e0f43023          	sd	a5,-512(s0)
    81004848:	008db503          	ld	a0,8(s11)
    8100484c:	c509                	beqz	a0,81004856 <exec+0x26c>
    if(argc >= MAXARG)
    8100484e:	fb8499e3          	bne	s1,s8,81004800 <exec+0x216>
  sz = sz1;
    81004852:	89d2                	mv	s3,s4
    81004854:	b7b5                	j	810047c0 <exec+0x1d6>
  ustack[argc] = 0;
    81004856:	00349793          	slli	a5,s1,0x3
    8100485a:	f9078793          	addi	a5,a5,-112
    8100485e:	97a2                	add	a5,a5,s0
    81004860:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    81004864:	00148693          	addi	a3,s1,1
    81004868:	068e                	slli	a3,a3,0x3
    8100486a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8100486e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    81004872:	89d2                	mv	s3,s4
  if(sp < stackbase)
    81004874:	f57966e3          	bltu	s2,s7,810047c0 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    81004878:	e9040613          	addi	a2,s0,-368
    8100487c:	85ca                	mv	a1,s2
    8100487e:	855a                	mv	a0,s6
    81004880:	e5ffc0ef          	jal	810016de <copyout>
    81004884:	f2054ee3          	bltz	a0,810047c0 <exec+0x1d6>
  p->trapframe->a1 = sp;
    81004888:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x80ffefa8>
    8100488c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    81004890:	df043783          	ld	a5,-528(s0)
    81004894:	0007c703          	lbu	a4,0(a5)
    81004898:	cf11                	beqz	a4,810048b4 <exec+0x2ca>
    8100489a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8100489c:	02f00693          	li	a3,47
    810048a0:	a029                	j	810048aa <exec+0x2c0>
  for(last=s=path; *s; s++)
    810048a2:	0785                	addi	a5,a5,1
    810048a4:	fff7c703          	lbu	a4,-1(a5)
    810048a8:	c711                	beqz	a4,810048b4 <exec+0x2ca>
    if(*s == '/')
    810048aa:	fed71ce3          	bne	a4,a3,810048a2 <exec+0x2b8>
      last = s+1;
    810048ae:	def43823          	sd	a5,-528(s0)
    810048b2:	bfc5                	j	810048a2 <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    810048b4:	4641                	li	a2,16
    810048b6:	df043583          	ld	a1,-528(s0)
    810048ba:	158a8513          	addi	a0,s5,344
    810048be:	eacfc0ef          	jal	81000f6a <safestrcpy>
  oldpagetable = p->pagetable;
    810048c2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    810048c6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    810048ca:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    810048ce:	058ab783          	ld	a5,88(s5)
    810048d2:	e6843703          	ld	a4,-408(s0)
    810048d6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    810048d8:	058ab783          	ld	a5,88(s5)
    810048dc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    810048e0:	85ea                	mv	a1,s10
    810048e2:	a80fd0ef          	jal	81001b62 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    810048e6:	0004851b          	sext.w	a0,s1
    810048ea:	79fe                	ld	s3,504(sp)
    810048ec:	7a5e                	ld	s4,496(sp)
    810048ee:	7abe                	ld	s5,488(sp)
    810048f0:	7b1e                	ld	s6,480(sp)
    810048f2:	6bfe                	ld	s7,472(sp)
    810048f4:	6c5e                	ld	s8,464(sp)
    810048f6:	6cbe                	ld	s9,456(sp)
    810048f8:	6d1e                	ld	s10,448(sp)
    810048fa:	7dfa                	ld	s11,440(sp)
    810048fc:	b385                	j	8100465c <exec+0x72>
    810048fe:	7b1e                	ld	s6,480(sp)
    81004900:	b3b9                	j	8100464e <exec+0x64>
    81004902:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    81004906:	df843583          	ld	a1,-520(s0)
    8100490a:	855a                	mv	a0,s6
    8100490c:	a56fd0ef          	jal	81001b62 <proc_freepagetable>
  if(ip){
    81004910:	79fe                	ld	s3,504(sp)
    81004912:	7abe                	ld	s5,488(sp)
    81004914:	7b1e                	ld	s6,480(sp)
    81004916:	6bfe                	ld	s7,472(sp)
    81004918:	6c5e                	ld	s8,464(sp)
    8100491a:	6cbe                	ld	s9,456(sp)
    8100491c:	6d1e                	ld	s10,448(sp)
    8100491e:	7dfa                	ld	s11,440(sp)
    81004920:	b33d                	j	8100464e <exec+0x64>
    81004922:	df243c23          	sd	s2,-520(s0)
    81004926:	b7c5                	j	81004906 <exec+0x31c>
    81004928:	df243c23          	sd	s2,-520(s0)
    8100492c:	bfe9                	j	81004906 <exec+0x31c>
    8100492e:	df243c23          	sd	s2,-520(s0)
    81004932:	bfd1                	j	81004906 <exec+0x31c>
    81004934:	df243c23          	sd	s2,-520(s0)
    81004938:	b7f9                	j	81004906 <exec+0x31c>
  sz = sz1;
    8100493a:	89d2                	mv	s3,s4
    8100493c:	b551                	j	810047c0 <exec+0x1d6>
    8100493e:	89d2                	mv	s3,s4
    81004940:	b541                	j	810047c0 <exec+0x1d6>

0000000081004942 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    81004942:	7179                	addi	sp,sp,-48
    81004944:	f406                	sd	ra,40(sp)
    81004946:	f022                	sd	s0,32(sp)
    81004948:	ec26                	sd	s1,24(sp)
    8100494a:	e84a                	sd	s2,16(sp)
    8100494c:	1800                	addi	s0,sp,48
    8100494e:	892e                	mv	s2,a1
    81004950:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    81004952:	fdc40593          	addi	a1,s0,-36
    81004956:	f93fd0ef          	jal	810028e8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8100495a:	fdc42703          	lw	a4,-36(s0)
    8100495e:	47bd                	li	a5,15
    81004960:	02e7e963          	bltu	a5,a4,81004992 <argfd+0x50>
    81004964:	8d2fd0ef          	jal	81001a36 <myproc>
    81004968:	fdc42703          	lw	a4,-36(s0)
    8100496c:	01a70793          	addi	a5,a4,26
    81004970:	078e                	slli	a5,a5,0x3
    81004972:	953e                	add	a0,a0,a5
    81004974:	611c                	ld	a5,0(a0)
    81004976:	c385                	beqz	a5,81004996 <argfd+0x54>
    return -1;
  if(pfd)
    81004978:	00090463          	beqz	s2,81004980 <argfd+0x3e>
    *pfd = fd;
    8100497c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    81004980:	4501                	li	a0,0
  if(pf)
    81004982:	c091                	beqz	s1,81004986 <argfd+0x44>
    *pf = f;
    81004984:	e09c                	sd	a5,0(s1)
}
    81004986:	70a2                	ld	ra,40(sp)
    81004988:	7402                	ld	s0,32(sp)
    8100498a:	64e2                	ld	s1,24(sp)
    8100498c:	6942                	ld	s2,16(sp)
    8100498e:	6145                	addi	sp,sp,48
    81004990:	8082                	ret
    return -1;
    81004992:	557d                	li	a0,-1
    81004994:	bfcd                	j	81004986 <argfd+0x44>
    81004996:	557d                	li	a0,-1
    81004998:	b7fd                	j	81004986 <argfd+0x44>

000000008100499a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8100499a:	1101                	addi	sp,sp,-32
    8100499c:	ec06                	sd	ra,24(sp)
    8100499e:	e822                	sd	s0,16(sp)
    810049a0:	e426                	sd	s1,8(sp)
    810049a2:	1000                	addi	s0,sp,32
    810049a4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    810049a6:	890fd0ef          	jal	81001a36 <myproc>
    810049aa:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    810049ac:	0d050793          	addi	a5,a0,208
    810049b0:	4501                	li	a0,0
    810049b2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    810049b4:	6398                	ld	a4,0(a5)
    810049b6:	cb19                	beqz	a4,810049cc <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    810049b8:	2505                	addiw	a0,a0,1
    810049ba:	07a1                	addi	a5,a5,8
    810049bc:	fed51ce3          	bne	a0,a3,810049b4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    810049c0:	557d                	li	a0,-1
}
    810049c2:	60e2                	ld	ra,24(sp)
    810049c4:	6442                	ld	s0,16(sp)
    810049c6:	64a2                	ld	s1,8(sp)
    810049c8:	6105                	addi	sp,sp,32
    810049ca:	8082                	ret
      p->ofile[fd] = f;
    810049cc:	01a50793          	addi	a5,a0,26
    810049d0:	078e                	slli	a5,a5,0x3
    810049d2:	963e                	add	a2,a2,a5
    810049d4:	e204                	sd	s1,0(a2)
      return fd;
    810049d6:	b7f5                	j	810049c2 <fdalloc+0x28>

00000000810049d8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    810049d8:	715d                	addi	sp,sp,-80
    810049da:	e486                	sd	ra,72(sp)
    810049dc:	e0a2                	sd	s0,64(sp)
    810049de:	fc26                	sd	s1,56(sp)
    810049e0:	f84a                	sd	s2,48(sp)
    810049e2:	f44e                	sd	s3,40(sp)
    810049e4:	ec56                	sd	s5,24(sp)
    810049e6:	e85a                	sd	s6,16(sp)
    810049e8:	0880                	addi	s0,sp,80
    810049ea:	8b2e                	mv	s6,a1
    810049ec:	89b2                	mv	s3,a2
    810049ee:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    810049f0:	fb040593          	addi	a1,s0,-80
    810049f4:	ffdfe0ef          	jal	810039f0 <nameiparent>
    810049f8:	84aa                	mv	s1,a0
    810049fa:	10050a63          	beqz	a0,81004b0e <create+0x136>
    return 0;

  ilock(dp);
    810049fe:	8e9fe0ef          	jal	810032e6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    81004a02:	4601                	li	a2,0
    81004a04:	fb040593          	addi	a1,s0,-80
    81004a08:	8526                	mv	a0,s1
    81004a0a:	d41fe0ef          	jal	8100374a <dirlookup>
    81004a0e:	8aaa                	mv	s5,a0
    81004a10:	c129                	beqz	a0,81004a52 <create+0x7a>
    iunlockput(dp);
    81004a12:	8526                	mv	a0,s1
    81004a14:	addfe0ef          	jal	810034f0 <iunlockput>
    ilock(ip);
    81004a18:	8556                	mv	a0,s5
    81004a1a:	8cdfe0ef          	jal	810032e6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    81004a1e:	4789                	li	a5,2
    81004a20:	02fb1463          	bne	s6,a5,81004a48 <create+0x70>
    81004a24:	044ad783          	lhu	a5,68(s5)
    81004a28:	37f9                	addiw	a5,a5,-2
    81004a2a:	17c2                	slli	a5,a5,0x30
    81004a2c:	93c1                	srli	a5,a5,0x30
    81004a2e:	4705                	li	a4,1
    81004a30:	00f76c63          	bltu	a4,a5,81004a48 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    81004a34:	8556                	mv	a0,s5
    81004a36:	60a6                	ld	ra,72(sp)
    81004a38:	6406                	ld	s0,64(sp)
    81004a3a:	74e2                	ld	s1,56(sp)
    81004a3c:	7942                	ld	s2,48(sp)
    81004a3e:	79a2                	ld	s3,40(sp)
    81004a40:	6ae2                	ld	s5,24(sp)
    81004a42:	6b42                	ld	s6,16(sp)
    81004a44:	6161                	addi	sp,sp,80
    81004a46:	8082                	ret
    iunlockput(ip);
    81004a48:	8556                	mv	a0,s5
    81004a4a:	aa7fe0ef          	jal	810034f0 <iunlockput>
    return 0;
    81004a4e:	4a81                	li	s5,0
    81004a50:	b7d5                	j	81004a34 <create+0x5c>
    81004a52:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    81004a54:	85da                	mv	a1,s6
    81004a56:	4088                	lw	a0,0(s1)
    81004a58:	f1efe0ef          	jal	81003176 <ialloc>
    81004a5c:	8a2a                	mv	s4,a0
    81004a5e:	cd15                	beqz	a0,81004a9a <create+0xc2>
  ilock(ip);
    81004a60:	887fe0ef          	jal	810032e6 <ilock>
  ip->major = major;
    81004a64:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    81004a68:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    81004a6c:	4905                	li	s2,1
    81004a6e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    81004a72:	8552                	mv	a0,s4
    81004a74:	fbefe0ef          	jal	81003232 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    81004a78:	032b0763          	beq	s6,s2,81004aa6 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    81004a7c:	004a2603          	lw	a2,4(s4)
    81004a80:	fb040593          	addi	a1,s0,-80
    81004a84:	8526                	mv	a0,s1
    81004a86:	ea7fe0ef          	jal	8100392c <dirlink>
    81004a8a:	06054563          	bltz	a0,81004af4 <create+0x11c>
  iunlockput(dp);
    81004a8e:	8526                	mv	a0,s1
    81004a90:	a61fe0ef          	jal	810034f0 <iunlockput>
  return ip;
    81004a94:	8ad2                	mv	s5,s4
    81004a96:	7a02                	ld	s4,32(sp)
    81004a98:	bf71                	j	81004a34 <create+0x5c>
    iunlockput(dp);
    81004a9a:	8526                	mv	a0,s1
    81004a9c:	a55fe0ef          	jal	810034f0 <iunlockput>
    return 0;
    81004aa0:	8ad2                	mv	s5,s4
    81004aa2:	7a02                	ld	s4,32(sp)
    81004aa4:	bf41                	j	81004a34 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    81004aa6:	004a2603          	lw	a2,4(s4)
    81004aaa:	00003597          	auipc	a1,0x3
    81004aae:	bfe58593          	addi	a1,a1,-1026 # 810076a8 <etext+0x6a8>
    81004ab2:	8552                	mv	a0,s4
    81004ab4:	e79fe0ef          	jal	8100392c <dirlink>
    81004ab8:	02054e63          	bltz	a0,81004af4 <create+0x11c>
    81004abc:	40d0                	lw	a2,4(s1)
    81004abe:	00003597          	auipc	a1,0x3
    81004ac2:	bf258593          	addi	a1,a1,-1038 # 810076b0 <etext+0x6b0>
    81004ac6:	8552                	mv	a0,s4
    81004ac8:	e65fe0ef          	jal	8100392c <dirlink>
    81004acc:	02054463          	bltz	a0,81004af4 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    81004ad0:	004a2603          	lw	a2,4(s4)
    81004ad4:	fb040593          	addi	a1,s0,-80
    81004ad8:	8526                	mv	a0,s1
    81004ada:	e53fe0ef          	jal	8100392c <dirlink>
    81004ade:	00054b63          	bltz	a0,81004af4 <create+0x11c>
    dp->nlink++;  // for ".."
    81004ae2:	04a4d783          	lhu	a5,74(s1)
    81004ae6:	2785                	addiw	a5,a5,1
    81004ae8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    81004aec:	8526                	mv	a0,s1
    81004aee:	f44fe0ef          	jal	81003232 <iupdate>
    81004af2:	bf71                	j	81004a8e <create+0xb6>
  ip->nlink = 0;
    81004af4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    81004af8:	8552                	mv	a0,s4
    81004afa:	f38fe0ef          	jal	81003232 <iupdate>
  iunlockput(ip);
    81004afe:	8552                	mv	a0,s4
    81004b00:	9f1fe0ef          	jal	810034f0 <iunlockput>
  iunlockput(dp);
    81004b04:	8526                	mv	a0,s1
    81004b06:	9ebfe0ef          	jal	810034f0 <iunlockput>
  return 0;
    81004b0a:	7a02                	ld	s4,32(sp)
    81004b0c:	b725                	j	81004a34 <create+0x5c>
    return 0;
    81004b0e:	8aaa                	mv	s5,a0
    81004b10:	b715                	j	81004a34 <create+0x5c>

0000000081004b12 <sys_dup>:
{
    81004b12:	7179                	addi	sp,sp,-48
    81004b14:	f406                	sd	ra,40(sp)
    81004b16:	f022                	sd	s0,32(sp)
    81004b18:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    81004b1a:	fd840613          	addi	a2,s0,-40
    81004b1e:	4581                	li	a1,0
    81004b20:	4501                	li	a0,0
    81004b22:	e21ff0ef          	jal	81004942 <argfd>
    return -1;
    81004b26:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    81004b28:	02054363          	bltz	a0,81004b4e <sys_dup+0x3c>
    81004b2c:	ec26                	sd	s1,24(sp)
    81004b2e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    81004b30:	fd843903          	ld	s2,-40(s0)
    81004b34:	854a                	mv	a0,s2
    81004b36:	e65ff0ef          	jal	8100499a <fdalloc>
    81004b3a:	84aa                	mv	s1,a0
    return -1;
    81004b3c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    81004b3e:	00054d63          	bltz	a0,81004b58 <sys_dup+0x46>
  filedup(f);
    81004b42:	854a                	mv	a0,s2
    81004b44:	c2eff0ef          	jal	81003f72 <filedup>
  return fd;
    81004b48:	87a6                	mv	a5,s1
    81004b4a:	64e2                	ld	s1,24(sp)
    81004b4c:	6942                	ld	s2,16(sp)
}
    81004b4e:	853e                	mv	a0,a5
    81004b50:	70a2                	ld	ra,40(sp)
    81004b52:	7402                	ld	s0,32(sp)
    81004b54:	6145                	addi	sp,sp,48
    81004b56:	8082                	ret
    81004b58:	64e2                	ld	s1,24(sp)
    81004b5a:	6942                	ld	s2,16(sp)
    81004b5c:	bfcd                	j	81004b4e <sys_dup+0x3c>

0000000081004b5e <sys_read>:
{
    81004b5e:	7179                	addi	sp,sp,-48
    81004b60:	f406                	sd	ra,40(sp)
    81004b62:	f022                	sd	s0,32(sp)
    81004b64:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    81004b66:	fd840593          	addi	a1,s0,-40
    81004b6a:	4505                	li	a0,1
    81004b6c:	d99fd0ef          	jal	81002904 <argaddr>
  argint(2, &n);
    81004b70:	fe440593          	addi	a1,s0,-28
    81004b74:	4509                	li	a0,2
    81004b76:	d73fd0ef          	jal	810028e8 <argint>
  if(argfd(0, 0, &f) < 0)
    81004b7a:	fe840613          	addi	a2,s0,-24
    81004b7e:	4581                	li	a1,0
    81004b80:	4501                	li	a0,0
    81004b82:	dc1ff0ef          	jal	81004942 <argfd>
    81004b86:	87aa                	mv	a5,a0
    return -1;
    81004b88:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    81004b8a:	0007ca63          	bltz	a5,81004b9e <sys_read+0x40>
  return fileread(f, p, n);
    81004b8e:	fe442603          	lw	a2,-28(s0)
    81004b92:	fd843583          	ld	a1,-40(s0)
    81004b96:	fe843503          	ld	a0,-24(s0)
    81004b9a:	d3eff0ef          	jal	810040d8 <fileread>
}
    81004b9e:	70a2                	ld	ra,40(sp)
    81004ba0:	7402                	ld	s0,32(sp)
    81004ba2:	6145                	addi	sp,sp,48
    81004ba4:	8082                	ret

0000000081004ba6 <sys_write>:
{
    81004ba6:	7179                	addi	sp,sp,-48
    81004ba8:	f406                	sd	ra,40(sp)
    81004baa:	f022                	sd	s0,32(sp)
    81004bac:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    81004bae:	fd840593          	addi	a1,s0,-40
    81004bb2:	4505                	li	a0,1
    81004bb4:	d51fd0ef          	jal	81002904 <argaddr>
  argint(2, &n);
    81004bb8:	fe440593          	addi	a1,s0,-28
    81004bbc:	4509                	li	a0,2
    81004bbe:	d2bfd0ef          	jal	810028e8 <argint>
  if(argfd(0, 0, &f) < 0)
    81004bc2:	fe840613          	addi	a2,s0,-24
    81004bc6:	4581                	li	a1,0
    81004bc8:	4501                	li	a0,0
    81004bca:	d79ff0ef          	jal	81004942 <argfd>
    81004bce:	87aa                	mv	a5,a0
    return -1;
    81004bd0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    81004bd2:	0007ca63          	bltz	a5,81004be6 <sys_write+0x40>
  return filewrite(f, p, n);
    81004bd6:	fe442603          	lw	a2,-28(s0)
    81004bda:	fd843583          	ld	a1,-40(s0)
    81004bde:	fe843503          	ld	a0,-24(s0)
    81004be2:	db4ff0ef          	jal	81004196 <filewrite>
}
    81004be6:	70a2                	ld	ra,40(sp)
    81004be8:	7402                	ld	s0,32(sp)
    81004bea:	6145                	addi	sp,sp,48
    81004bec:	8082                	ret

0000000081004bee <sys_close>:
{
    81004bee:	1101                	addi	sp,sp,-32
    81004bf0:	ec06                	sd	ra,24(sp)
    81004bf2:	e822                	sd	s0,16(sp)
    81004bf4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    81004bf6:	fe040613          	addi	a2,s0,-32
    81004bfa:	fec40593          	addi	a1,s0,-20
    81004bfe:	4501                	li	a0,0
    81004c00:	d43ff0ef          	jal	81004942 <argfd>
    return -1;
    81004c04:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    81004c06:	02054063          	bltz	a0,81004c26 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    81004c0a:	e2dfc0ef          	jal	81001a36 <myproc>
    81004c0e:	fec42783          	lw	a5,-20(s0)
    81004c12:	07e9                	addi	a5,a5,26
    81004c14:	078e                	slli	a5,a5,0x3
    81004c16:	953e                	add	a0,a0,a5
    81004c18:	00053023          	sd	zero,0(a0)
  fileclose(f);
    81004c1c:	fe043503          	ld	a0,-32(s0)
    81004c20:	b98ff0ef          	jal	81003fb8 <fileclose>
  return 0;
    81004c24:	4781                	li	a5,0
}
    81004c26:	853e                	mv	a0,a5
    81004c28:	60e2                	ld	ra,24(sp)
    81004c2a:	6442                	ld	s0,16(sp)
    81004c2c:	6105                	addi	sp,sp,32
    81004c2e:	8082                	ret

0000000081004c30 <sys_fstat>:
{
    81004c30:	1101                	addi	sp,sp,-32
    81004c32:	ec06                	sd	ra,24(sp)
    81004c34:	e822                	sd	s0,16(sp)
    81004c36:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    81004c38:	fe040593          	addi	a1,s0,-32
    81004c3c:	4505                	li	a0,1
    81004c3e:	cc7fd0ef          	jal	81002904 <argaddr>
  if(argfd(0, 0, &f) < 0)
    81004c42:	fe840613          	addi	a2,s0,-24
    81004c46:	4581                	li	a1,0
    81004c48:	4501                	li	a0,0
    81004c4a:	cf9ff0ef          	jal	81004942 <argfd>
    81004c4e:	87aa                	mv	a5,a0
    return -1;
    81004c50:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    81004c52:	0007c863          	bltz	a5,81004c62 <sys_fstat+0x32>
  return filestat(f, st);
    81004c56:	fe043583          	ld	a1,-32(s0)
    81004c5a:	fe843503          	ld	a0,-24(s0)
    81004c5e:	c18ff0ef          	jal	81004076 <filestat>
}
    81004c62:	60e2                	ld	ra,24(sp)
    81004c64:	6442                	ld	s0,16(sp)
    81004c66:	6105                	addi	sp,sp,32
    81004c68:	8082                	ret

0000000081004c6a <sys_link>:
{
    81004c6a:	7169                	addi	sp,sp,-304
    81004c6c:	f606                	sd	ra,296(sp)
    81004c6e:	f222                	sd	s0,288(sp)
    81004c70:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    81004c72:	08000613          	li	a2,128
    81004c76:	ed040593          	addi	a1,s0,-304
    81004c7a:	4501                	li	a0,0
    81004c7c:	ca5fd0ef          	jal	81002920 <argstr>
    return -1;
    81004c80:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    81004c82:	0c054e63          	bltz	a0,81004d5e <sys_link+0xf4>
    81004c86:	08000613          	li	a2,128
    81004c8a:	f5040593          	addi	a1,s0,-176
    81004c8e:	4505                	li	a0,1
    81004c90:	c91fd0ef          	jal	81002920 <argstr>
    return -1;
    81004c94:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    81004c96:	0c054463          	bltz	a0,81004d5e <sys_link+0xf4>
    81004c9a:	ee26                	sd	s1,280(sp)
  begin_op();
    81004c9c:	efdfe0ef          	jal	81003b98 <begin_op>
  if((ip = namei(old)) == 0){
    81004ca0:	ed040513          	addi	a0,s0,-304
    81004ca4:	d33fe0ef          	jal	810039d6 <namei>
    81004ca8:	84aa                	mv	s1,a0
    81004caa:	c53d                	beqz	a0,81004d18 <sys_link+0xae>
  ilock(ip);
    81004cac:	e3afe0ef          	jal	810032e6 <ilock>
  if(ip->type == T_DIR){
    81004cb0:	04449703          	lh	a4,68(s1)
    81004cb4:	4785                	li	a5,1
    81004cb6:	06f70663          	beq	a4,a5,81004d22 <sys_link+0xb8>
    81004cba:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    81004cbc:	04a4d783          	lhu	a5,74(s1)
    81004cc0:	2785                	addiw	a5,a5,1
    81004cc2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    81004cc6:	8526                	mv	a0,s1
    81004cc8:	d6afe0ef          	jal	81003232 <iupdate>
  iunlock(ip);
    81004ccc:	8526                	mv	a0,s1
    81004cce:	ec6fe0ef          	jal	81003394 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    81004cd2:	fd040593          	addi	a1,s0,-48
    81004cd6:	f5040513          	addi	a0,s0,-176
    81004cda:	d17fe0ef          	jal	810039f0 <nameiparent>
    81004cde:	892a                	mv	s2,a0
    81004ce0:	cd21                	beqz	a0,81004d38 <sys_link+0xce>
  ilock(dp);
    81004ce2:	e04fe0ef          	jal	810032e6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    81004ce6:	00092703          	lw	a4,0(s2)
    81004cea:	409c                	lw	a5,0(s1)
    81004cec:	04f71363          	bne	a4,a5,81004d32 <sys_link+0xc8>
    81004cf0:	40d0                	lw	a2,4(s1)
    81004cf2:	fd040593          	addi	a1,s0,-48
    81004cf6:	854a                	mv	a0,s2
    81004cf8:	c35fe0ef          	jal	8100392c <dirlink>
    81004cfc:	02054b63          	bltz	a0,81004d32 <sys_link+0xc8>
  iunlockput(dp);
    81004d00:	854a                	mv	a0,s2
    81004d02:	feefe0ef          	jal	810034f0 <iunlockput>
  iput(ip);
    81004d06:	8526                	mv	a0,s1
    81004d08:	f60fe0ef          	jal	81003468 <iput>
  end_op();
    81004d0c:	ef7fe0ef          	jal	81003c02 <end_op>
  return 0;
    81004d10:	4781                	li	a5,0
    81004d12:	64f2                	ld	s1,280(sp)
    81004d14:	6952                	ld	s2,272(sp)
    81004d16:	a0a1                	j	81004d5e <sys_link+0xf4>
    end_op();
    81004d18:	eebfe0ef          	jal	81003c02 <end_op>
    return -1;
    81004d1c:	57fd                	li	a5,-1
    81004d1e:	64f2                	ld	s1,280(sp)
    81004d20:	a83d                	j	81004d5e <sys_link+0xf4>
    iunlockput(ip);
    81004d22:	8526                	mv	a0,s1
    81004d24:	fccfe0ef          	jal	810034f0 <iunlockput>
    end_op();
    81004d28:	edbfe0ef          	jal	81003c02 <end_op>
    return -1;
    81004d2c:	57fd                	li	a5,-1
    81004d2e:	64f2                	ld	s1,280(sp)
    81004d30:	a03d                	j	81004d5e <sys_link+0xf4>
    iunlockput(dp);
    81004d32:	854a                	mv	a0,s2
    81004d34:	fbcfe0ef          	jal	810034f0 <iunlockput>
  ilock(ip);
    81004d38:	8526                	mv	a0,s1
    81004d3a:	dacfe0ef          	jal	810032e6 <ilock>
  ip->nlink--;
    81004d3e:	04a4d783          	lhu	a5,74(s1)
    81004d42:	37fd                	addiw	a5,a5,-1
    81004d44:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    81004d48:	8526                	mv	a0,s1
    81004d4a:	ce8fe0ef          	jal	81003232 <iupdate>
  iunlockput(ip);
    81004d4e:	8526                	mv	a0,s1
    81004d50:	fa0fe0ef          	jal	810034f0 <iunlockput>
  end_op();
    81004d54:	eaffe0ef          	jal	81003c02 <end_op>
  return -1;
    81004d58:	57fd                	li	a5,-1
    81004d5a:	64f2                	ld	s1,280(sp)
    81004d5c:	6952                	ld	s2,272(sp)
}
    81004d5e:	853e                	mv	a0,a5
    81004d60:	70b2                	ld	ra,296(sp)
    81004d62:	7412                	ld	s0,288(sp)
    81004d64:	6155                	addi	sp,sp,304
    81004d66:	8082                	ret

0000000081004d68 <sys_unlink>:
{
    81004d68:	7111                	addi	sp,sp,-256
    81004d6a:	fd86                	sd	ra,248(sp)
    81004d6c:	f9a2                	sd	s0,240(sp)
    81004d6e:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    81004d70:	08000613          	li	a2,128
    81004d74:	f2040593          	addi	a1,s0,-224
    81004d78:	4501                	li	a0,0
    81004d7a:	ba7fd0ef          	jal	81002920 <argstr>
    81004d7e:	16054663          	bltz	a0,81004eea <sys_unlink+0x182>
    81004d82:	f5a6                	sd	s1,232(sp)
  begin_op();
    81004d84:	e15fe0ef          	jal	81003b98 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    81004d88:	fa040593          	addi	a1,s0,-96
    81004d8c:	f2040513          	addi	a0,s0,-224
    81004d90:	c61fe0ef          	jal	810039f0 <nameiparent>
    81004d94:	84aa                	mv	s1,a0
    81004d96:	c955                	beqz	a0,81004e4a <sys_unlink+0xe2>
  ilock(dp);
    81004d98:	d4efe0ef          	jal	810032e6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    81004d9c:	00003597          	auipc	a1,0x3
    81004da0:	90c58593          	addi	a1,a1,-1780 # 810076a8 <etext+0x6a8>
    81004da4:	fa040513          	addi	a0,s0,-96
    81004da8:	98dfe0ef          	jal	81003734 <namecmp>
    81004dac:	12050463          	beqz	a0,81004ed4 <sys_unlink+0x16c>
    81004db0:	00003597          	auipc	a1,0x3
    81004db4:	90058593          	addi	a1,a1,-1792 # 810076b0 <etext+0x6b0>
    81004db8:	fa040513          	addi	a0,s0,-96
    81004dbc:	979fe0ef          	jal	81003734 <namecmp>
    81004dc0:	10050a63          	beqz	a0,81004ed4 <sys_unlink+0x16c>
    81004dc4:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    81004dc6:	f1c40613          	addi	a2,s0,-228
    81004dca:	fa040593          	addi	a1,s0,-96
    81004dce:	8526                	mv	a0,s1
    81004dd0:	97bfe0ef          	jal	8100374a <dirlookup>
    81004dd4:	892a                	mv	s2,a0
    81004dd6:	0e050e63          	beqz	a0,81004ed2 <sys_unlink+0x16a>
    81004dda:	edce                	sd	s3,216(sp)
  ilock(ip);
    81004ddc:	d0afe0ef          	jal	810032e6 <ilock>
  if(ip->nlink < 1)
    81004de0:	04a91783          	lh	a5,74(s2)
    81004de4:	06f05863          	blez	a5,81004e54 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    81004de8:	04491703          	lh	a4,68(s2)
    81004dec:	4785                	li	a5,1
    81004dee:	06f70b63          	beq	a4,a5,81004e64 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    81004df2:	fb040993          	addi	s3,s0,-80
    81004df6:	4641                	li	a2,16
    81004df8:	4581                	li	a1,0
    81004dfa:	854e                	mv	a0,s3
    81004dfc:	81cfc0ef          	jal	81000e18 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    81004e00:	4741                	li	a4,16
    81004e02:	f1c42683          	lw	a3,-228(s0)
    81004e06:	864e                	mv	a2,s3
    81004e08:	4581                	li	a1,0
    81004e0a:	8526                	mv	a0,s1
    81004e0c:	825fe0ef          	jal	81003630 <writei>
    81004e10:	47c1                	li	a5,16
    81004e12:	08f51f63          	bne	a0,a5,81004eb0 <sys_unlink+0x148>
  if(ip->type == T_DIR){
    81004e16:	04491703          	lh	a4,68(s2)
    81004e1a:	4785                	li	a5,1
    81004e1c:	0af70263          	beq	a4,a5,81004ec0 <sys_unlink+0x158>
  iunlockput(dp);
    81004e20:	8526                	mv	a0,s1
    81004e22:	ecefe0ef          	jal	810034f0 <iunlockput>
  ip->nlink--;
    81004e26:	04a95783          	lhu	a5,74(s2)
    81004e2a:	37fd                	addiw	a5,a5,-1
    81004e2c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    81004e30:	854a                	mv	a0,s2
    81004e32:	c00fe0ef          	jal	81003232 <iupdate>
  iunlockput(ip);
    81004e36:	854a                	mv	a0,s2
    81004e38:	eb8fe0ef          	jal	810034f0 <iunlockput>
  end_op();
    81004e3c:	dc7fe0ef          	jal	81003c02 <end_op>
  return 0;
    81004e40:	4501                	li	a0,0
    81004e42:	74ae                	ld	s1,232(sp)
    81004e44:	790e                	ld	s2,224(sp)
    81004e46:	69ee                	ld	s3,216(sp)
    81004e48:	a869                	j	81004ee2 <sys_unlink+0x17a>
    end_op();
    81004e4a:	db9fe0ef          	jal	81003c02 <end_op>
    return -1;
    81004e4e:	557d                	li	a0,-1
    81004e50:	74ae                	ld	s1,232(sp)
    81004e52:	a841                	j	81004ee2 <sys_unlink+0x17a>
    81004e54:	e9d2                	sd	s4,208(sp)
    81004e56:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    81004e58:	00003517          	auipc	a0,0x3
    81004e5c:	86050513          	addi	a0,a0,-1952 # 810076b8 <etext+0x6b8>
    81004e60:	a85fb0ef          	jal	810008e4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    81004e64:	04c92703          	lw	a4,76(s2)
    81004e68:	02000793          	li	a5,32
    81004e6c:	f8e7f3e3          	bgeu	a5,a4,81004df2 <sys_unlink+0x8a>
    81004e70:	e9d2                	sd	s4,208(sp)
    81004e72:	e5d6                	sd	s5,200(sp)
    81004e74:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    81004e76:	f0840a93          	addi	s5,s0,-248
    81004e7a:	4a41                	li	s4,16
    81004e7c:	8752                	mv	a4,s4
    81004e7e:	86ce                	mv	a3,s3
    81004e80:	8656                	mv	a2,s5
    81004e82:	4581                	li	a1,0
    81004e84:	854a                	mv	a0,s2
    81004e86:	eb8fe0ef          	jal	8100353e <readi>
    81004e8a:	01451d63          	bne	a0,s4,81004ea4 <sys_unlink+0x13c>
    if(de.inum != 0)
    81004e8e:	f0845783          	lhu	a5,-248(s0)
    81004e92:	efb1                	bnez	a5,81004eee <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    81004e94:	29c1                	addiw	s3,s3,16
    81004e96:	04c92783          	lw	a5,76(s2)
    81004e9a:	fef9e1e3          	bltu	s3,a5,81004e7c <sys_unlink+0x114>
    81004e9e:	6a4e                	ld	s4,208(sp)
    81004ea0:	6aae                	ld	s5,200(sp)
    81004ea2:	bf81                	j	81004df2 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    81004ea4:	00003517          	auipc	a0,0x3
    81004ea8:	82c50513          	addi	a0,a0,-2004 # 810076d0 <etext+0x6d0>
    81004eac:	a39fb0ef          	jal	810008e4 <panic>
    81004eb0:	e9d2                	sd	s4,208(sp)
    81004eb2:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    81004eb4:	00003517          	auipc	a0,0x3
    81004eb8:	83450513          	addi	a0,a0,-1996 # 810076e8 <etext+0x6e8>
    81004ebc:	a29fb0ef          	jal	810008e4 <panic>
    dp->nlink--;
    81004ec0:	04a4d783          	lhu	a5,74(s1)
    81004ec4:	37fd                	addiw	a5,a5,-1
    81004ec6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    81004eca:	8526                	mv	a0,s1
    81004ecc:	b66fe0ef          	jal	81003232 <iupdate>
    81004ed0:	bf81                	j	81004e20 <sys_unlink+0xb8>
    81004ed2:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    81004ed4:	8526                	mv	a0,s1
    81004ed6:	e1afe0ef          	jal	810034f0 <iunlockput>
  end_op();
    81004eda:	d29fe0ef          	jal	81003c02 <end_op>
  return -1;
    81004ede:	557d                	li	a0,-1
    81004ee0:	74ae                	ld	s1,232(sp)
}
    81004ee2:	70ee                	ld	ra,248(sp)
    81004ee4:	744e                	ld	s0,240(sp)
    81004ee6:	6111                	addi	sp,sp,256
    81004ee8:	8082                	ret
    return -1;
    81004eea:	557d                	li	a0,-1
    81004eec:	bfdd                	j	81004ee2 <sys_unlink+0x17a>
    iunlockput(ip);
    81004eee:	854a                	mv	a0,s2
    81004ef0:	e00fe0ef          	jal	810034f0 <iunlockput>
    goto bad;
    81004ef4:	790e                	ld	s2,224(sp)
    81004ef6:	69ee                	ld	s3,216(sp)
    81004ef8:	6a4e                	ld	s4,208(sp)
    81004efa:	6aae                	ld	s5,200(sp)
    81004efc:	bfe1                	j	81004ed4 <sys_unlink+0x16c>

0000000081004efe <sys_open>:

uint64
sys_open(void)
{
    81004efe:	7131                	addi	sp,sp,-192
    81004f00:	fd06                	sd	ra,184(sp)
    81004f02:	f922                	sd	s0,176(sp)
    81004f04:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    81004f06:	f4c40593          	addi	a1,s0,-180
    81004f0a:	4505                	li	a0,1
    81004f0c:	9ddfd0ef          	jal	810028e8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    81004f10:	08000613          	li	a2,128
    81004f14:	f5040593          	addi	a1,s0,-176
    81004f18:	4501                	li	a0,0
    81004f1a:	a07fd0ef          	jal	81002920 <argstr>
    81004f1e:	87aa                	mv	a5,a0
    return -1;
    81004f20:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    81004f22:	0a07c363          	bltz	a5,81004fc8 <sys_open+0xca>
    81004f26:	f526                	sd	s1,168(sp)

  begin_op();
    81004f28:	c71fe0ef          	jal	81003b98 <begin_op>

  if(omode & O_CREATE){
    81004f2c:	f4c42783          	lw	a5,-180(s0)
    81004f30:	2007f793          	andi	a5,a5,512
    81004f34:	c3dd                	beqz	a5,81004fda <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    81004f36:	4681                	li	a3,0
    81004f38:	4601                	li	a2,0
    81004f3a:	4589                	li	a1,2
    81004f3c:	f5040513          	addi	a0,s0,-176
    81004f40:	a99ff0ef          	jal	810049d8 <create>
    81004f44:	84aa                	mv	s1,a0
    if(ip == 0){
    81004f46:	c549                	beqz	a0,81004fd0 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    81004f48:	04449703          	lh	a4,68(s1)
    81004f4c:	478d                	li	a5,3
    81004f4e:	00f71763          	bne	a4,a5,81004f5c <sys_open+0x5e>
    81004f52:	0464d703          	lhu	a4,70(s1)
    81004f56:	47a5                	li	a5,9
    81004f58:	0ae7ee63          	bltu	a5,a4,81005014 <sys_open+0x116>
    81004f5c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    81004f5e:	fb7fe0ef          	jal	81003f14 <filealloc>
    81004f62:	892a                	mv	s2,a0
    81004f64:	c561                	beqz	a0,8100502c <sys_open+0x12e>
    81004f66:	ed4e                	sd	s3,152(sp)
    81004f68:	a33ff0ef          	jal	8100499a <fdalloc>
    81004f6c:	89aa                	mv	s3,a0
    81004f6e:	0a054b63          	bltz	a0,81005024 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    81004f72:	04449703          	lh	a4,68(s1)
    81004f76:	478d                	li	a5,3
    81004f78:	0cf70363          	beq	a4,a5,8100503e <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    81004f7c:	4789                	li	a5,2
    81004f7e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    81004f82:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    81004f86:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    81004f8a:	f4c42783          	lw	a5,-180(s0)
    81004f8e:	0017f713          	andi	a4,a5,1
    81004f92:	00174713          	xori	a4,a4,1
    81004f96:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    81004f9a:	0037f713          	andi	a4,a5,3
    81004f9e:	00e03733          	snez	a4,a4
    81004fa2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    81004fa6:	4007f793          	andi	a5,a5,1024
    81004faa:	c791                	beqz	a5,81004fb6 <sys_open+0xb8>
    81004fac:	04449703          	lh	a4,68(s1)
    81004fb0:	4789                	li	a5,2
    81004fb2:	08f70d63          	beq	a4,a5,8100504c <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    81004fb6:	8526                	mv	a0,s1
    81004fb8:	bdcfe0ef          	jal	81003394 <iunlock>
  end_op();
    81004fbc:	c47fe0ef          	jal	81003c02 <end_op>

  return fd;
    81004fc0:	854e                	mv	a0,s3
    81004fc2:	74aa                	ld	s1,168(sp)
    81004fc4:	790a                	ld	s2,160(sp)
    81004fc6:	69ea                	ld	s3,152(sp)
}
    81004fc8:	70ea                	ld	ra,184(sp)
    81004fca:	744a                	ld	s0,176(sp)
    81004fcc:	6129                	addi	sp,sp,192
    81004fce:	8082                	ret
      end_op();
    81004fd0:	c33fe0ef          	jal	81003c02 <end_op>
      return -1;
    81004fd4:	557d                	li	a0,-1
    81004fd6:	74aa                	ld	s1,168(sp)
    81004fd8:	bfc5                	j	81004fc8 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    81004fda:	f5040513          	addi	a0,s0,-176
    81004fde:	9f9fe0ef          	jal	810039d6 <namei>
    81004fe2:	84aa                	mv	s1,a0
    81004fe4:	c11d                	beqz	a0,8100500a <sys_open+0x10c>
    ilock(ip);
    81004fe6:	b00fe0ef          	jal	810032e6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    81004fea:	04449703          	lh	a4,68(s1)
    81004fee:	4785                	li	a5,1
    81004ff0:	f4f71ce3          	bne	a4,a5,81004f48 <sys_open+0x4a>
    81004ff4:	f4c42783          	lw	a5,-180(s0)
    81004ff8:	d3b5                	beqz	a5,81004f5c <sys_open+0x5e>
      iunlockput(ip);
    81004ffa:	8526                	mv	a0,s1
    81004ffc:	cf4fe0ef          	jal	810034f0 <iunlockput>
      end_op();
    81005000:	c03fe0ef          	jal	81003c02 <end_op>
      return -1;
    81005004:	557d                	li	a0,-1
    81005006:	74aa                	ld	s1,168(sp)
    81005008:	b7c1                	j	81004fc8 <sys_open+0xca>
      end_op();
    8100500a:	bf9fe0ef          	jal	81003c02 <end_op>
      return -1;
    8100500e:	557d                	li	a0,-1
    81005010:	74aa                	ld	s1,168(sp)
    81005012:	bf5d                	j	81004fc8 <sys_open+0xca>
    iunlockput(ip);
    81005014:	8526                	mv	a0,s1
    81005016:	cdafe0ef          	jal	810034f0 <iunlockput>
    end_op();
    8100501a:	be9fe0ef          	jal	81003c02 <end_op>
    return -1;
    8100501e:	557d                	li	a0,-1
    81005020:	74aa                	ld	s1,168(sp)
    81005022:	b75d                	j	81004fc8 <sys_open+0xca>
      fileclose(f);
    81005024:	854a                	mv	a0,s2
    81005026:	f93fe0ef          	jal	81003fb8 <fileclose>
    8100502a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8100502c:	8526                	mv	a0,s1
    8100502e:	cc2fe0ef          	jal	810034f0 <iunlockput>
    end_op();
    81005032:	bd1fe0ef          	jal	81003c02 <end_op>
    return -1;
    81005036:	557d                	li	a0,-1
    81005038:	74aa                	ld	s1,168(sp)
    8100503a:	790a                	ld	s2,160(sp)
    8100503c:	b771                	j	81004fc8 <sys_open+0xca>
    f->type = FD_DEVICE;
    8100503e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    81005042:	04649783          	lh	a5,70(s1)
    81005046:	02f91223          	sh	a5,36(s2)
    8100504a:	bf35                	j	81004f86 <sys_open+0x88>
    itrunc(ip);
    8100504c:	8526                	mv	a0,s1
    8100504e:	b86fe0ef          	jal	810033d4 <itrunc>
    81005052:	b795                	j	81004fb6 <sys_open+0xb8>

0000000081005054 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    81005054:	7175                	addi	sp,sp,-144
    81005056:	e506                	sd	ra,136(sp)
    81005058:	e122                	sd	s0,128(sp)
    8100505a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8100505c:	b3dfe0ef          	jal	81003b98 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    81005060:	08000613          	li	a2,128
    81005064:	f7040593          	addi	a1,s0,-144
    81005068:	4501                	li	a0,0
    8100506a:	8b7fd0ef          	jal	81002920 <argstr>
    8100506e:	02054363          	bltz	a0,81005094 <sys_mkdir+0x40>
    81005072:	4681                	li	a3,0
    81005074:	4601                	li	a2,0
    81005076:	4585                	li	a1,1
    81005078:	f7040513          	addi	a0,s0,-144
    8100507c:	95dff0ef          	jal	810049d8 <create>
    81005080:	c911                	beqz	a0,81005094 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    81005082:	c6efe0ef          	jal	810034f0 <iunlockput>
  end_op();
    81005086:	b7dfe0ef          	jal	81003c02 <end_op>
  return 0;
    8100508a:	4501                	li	a0,0
}
    8100508c:	60aa                	ld	ra,136(sp)
    8100508e:	640a                	ld	s0,128(sp)
    81005090:	6149                	addi	sp,sp,144
    81005092:	8082                	ret
    end_op();
    81005094:	b6ffe0ef          	jal	81003c02 <end_op>
    return -1;
    81005098:	557d                	li	a0,-1
    8100509a:	bfcd                	j	8100508c <sys_mkdir+0x38>

000000008100509c <sys_mknod>:

uint64
sys_mknod(void)
{
    8100509c:	7135                	addi	sp,sp,-160
    8100509e:	ed06                	sd	ra,152(sp)
    810050a0:	e922                	sd	s0,144(sp)
    810050a2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    810050a4:	af5fe0ef          	jal	81003b98 <begin_op>
  argint(1, &major);
    810050a8:	f6c40593          	addi	a1,s0,-148
    810050ac:	4505                	li	a0,1
    810050ae:	83bfd0ef          	jal	810028e8 <argint>
  argint(2, &minor);
    810050b2:	f6840593          	addi	a1,s0,-152
    810050b6:	4509                	li	a0,2
    810050b8:	831fd0ef          	jal	810028e8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    810050bc:	08000613          	li	a2,128
    810050c0:	f7040593          	addi	a1,s0,-144
    810050c4:	4501                	li	a0,0
    810050c6:	85bfd0ef          	jal	81002920 <argstr>
    810050ca:	02054563          	bltz	a0,810050f4 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    810050ce:	f6841683          	lh	a3,-152(s0)
    810050d2:	f6c41603          	lh	a2,-148(s0)
    810050d6:	458d                	li	a1,3
    810050d8:	f7040513          	addi	a0,s0,-144
    810050dc:	8fdff0ef          	jal	810049d8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    810050e0:	c911                	beqz	a0,810050f4 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    810050e2:	c0efe0ef          	jal	810034f0 <iunlockput>
  end_op();
    810050e6:	b1dfe0ef          	jal	81003c02 <end_op>
  return 0;
    810050ea:	4501                	li	a0,0
}
    810050ec:	60ea                	ld	ra,152(sp)
    810050ee:	644a                	ld	s0,144(sp)
    810050f0:	610d                	addi	sp,sp,160
    810050f2:	8082                	ret
    end_op();
    810050f4:	b0ffe0ef          	jal	81003c02 <end_op>
    return -1;
    810050f8:	557d                	li	a0,-1
    810050fa:	bfcd                	j	810050ec <sys_mknod+0x50>

00000000810050fc <sys_chdir>:

uint64
sys_chdir(void)
{
    810050fc:	7135                	addi	sp,sp,-160
    810050fe:	ed06                	sd	ra,152(sp)
    81005100:	e922                	sd	s0,144(sp)
    81005102:	e14a                	sd	s2,128(sp)
    81005104:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    81005106:	931fc0ef          	jal	81001a36 <myproc>
    8100510a:	892a                	mv	s2,a0
  
  begin_op();
    8100510c:	a8dfe0ef          	jal	81003b98 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    81005110:	08000613          	li	a2,128
    81005114:	f6040593          	addi	a1,s0,-160
    81005118:	4501                	li	a0,0
    8100511a:	807fd0ef          	jal	81002920 <argstr>
    8100511e:	04054363          	bltz	a0,81005164 <sys_chdir+0x68>
    81005122:	e526                	sd	s1,136(sp)
    81005124:	f6040513          	addi	a0,s0,-160
    81005128:	8affe0ef          	jal	810039d6 <namei>
    8100512c:	84aa                	mv	s1,a0
    8100512e:	c915                	beqz	a0,81005162 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    81005130:	9b6fe0ef          	jal	810032e6 <ilock>
  if(ip->type != T_DIR){
    81005134:	04449703          	lh	a4,68(s1)
    81005138:	4785                	li	a5,1
    8100513a:	02f71963          	bne	a4,a5,8100516c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8100513e:	8526                	mv	a0,s1
    81005140:	a54fe0ef          	jal	81003394 <iunlock>
  iput(p->cwd);
    81005144:	15093503          	ld	a0,336(s2)
    81005148:	b20fe0ef          	jal	81003468 <iput>
  end_op();
    8100514c:	ab7fe0ef          	jal	81003c02 <end_op>
  p->cwd = ip;
    81005150:	14993823          	sd	s1,336(s2)
  return 0;
    81005154:	4501                	li	a0,0
    81005156:	64aa                	ld	s1,136(sp)
}
    81005158:	60ea                	ld	ra,152(sp)
    8100515a:	644a                	ld	s0,144(sp)
    8100515c:	690a                	ld	s2,128(sp)
    8100515e:	610d                	addi	sp,sp,160
    81005160:	8082                	ret
    81005162:	64aa                	ld	s1,136(sp)
    end_op();
    81005164:	a9ffe0ef          	jal	81003c02 <end_op>
    return -1;
    81005168:	557d                	li	a0,-1
    8100516a:	b7fd                	j	81005158 <sys_chdir+0x5c>
    iunlockput(ip);
    8100516c:	8526                	mv	a0,s1
    8100516e:	b82fe0ef          	jal	810034f0 <iunlockput>
    end_op();
    81005172:	a91fe0ef          	jal	81003c02 <end_op>
    return -1;
    81005176:	557d                	li	a0,-1
    81005178:	64aa                	ld	s1,136(sp)
    8100517a:	bff9                	j	81005158 <sys_chdir+0x5c>

000000008100517c <sys_exec>:

uint64
sys_exec(void)
{
    8100517c:	7105                	addi	sp,sp,-480
    8100517e:	ef86                	sd	ra,472(sp)
    81005180:	eba2                	sd	s0,464(sp)
    81005182:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    81005184:	e2840593          	addi	a1,s0,-472
    81005188:	4505                	li	a0,1
    8100518a:	f7afd0ef          	jal	81002904 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8100518e:	08000613          	li	a2,128
    81005192:	f3040593          	addi	a1,s0,-208
    81005196:	4501                	li	a0,0
    81005198:	f88fd0ef          	jal	81002920 <argstr>
    8100519c:	87aa                	mv	a5,a0
    return -1;
    8100519e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    810051a0:	0e07c063          	bltz	a5,81005280 <sys_exec+0x104>
    810051a4:	e7a6                	sd	s1,456(sp)
    810051a6:	e3ca                	sd	s2,448(sp)
    810051a8:	ff4e                	sd	s3,440(sp)
    810051aa:	fb52                	sd	s4,432(sp)
    810051ac:	f756                	sd	s5,424(sp)
    810051ae:	f35a                	sd	s6,416(sp)
    810051b0:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    810051b2:	e3040a13          	addi	s4,s0,-464
    810051b6:	10000613          	li	a2,256
    810051ba:	4581                	li	a1,0
    810051bc:	8552                	mv	a0,s4
    810051be:	c5bfb0ef          	jal	81000e18 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    810051c2:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    810051c4:	89d2                	mv	s3,s4
    810051c6:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    810051c8:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    810051cc:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    810051ce:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    810051d2:	00391513          	slli	a0,s2,0x3
    810051d6:	85d6                	mv	a1,s5
    810051d8:	e2843783          	ld	a5,-472(s0)
    810051dc:	953e                	add	a0,a0,a5
    810051de:	e80fd0ef          	jal	8100285e <fetchaddr>
    810051e2:	02054663          	bltz	a0,8100520e <sys_exec+0x92>
    if(uarg == 0){
    810051e6:	e2043783          	ld	a5,-480(s0)
    810051ea:	c7a1                	beqz	a5,81005232 <sys_exec+0xb6>
    argv[i] = kalloc();
    810051ec:	a89fb0ef          	jal	81000c74 <kalloc>
    810051f0:	85aa                	mv	a1,a0
    810051f2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    810051f6:	cd01                	beqz	a0,8100520e <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    810051f8:	865a                	mv	a2,s6
    810051fa:	e2043503          	ld	a0,-480(s0)
    810051fe:	eaafd0ef          	jal	810028a8 <fetchstr>
    81005202:	00054663          	bltz	a0,8100520e <sys_exec+0x92>
    if(i >= NELEM(argv)){
    81005206:	0905                	addi	s2,s2,1
    81005208:	09a1                	addi	s3,s3,8
    8100520a:	fd7914e3          	bne	s2,s7,810051d2 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8100520e:	100a0a13          	addi	s4,s4,256
    81005212:	6088                	ld	a0,0(s1)
    81005214:	cd31                	beqz	a0,81005270 <sys_exec+0xf4>
    kfree(argv[i]);
    81005216:	979fb0ef          	jal	81000b8e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8100521a:	04a1                	addi	s1,s1,8
    8100521c:	ff449be3          	bne	s1,s4,81005212 <sys_exec+0x96>
  return -1;
    81005220:	557d                	li	a0,-1
    81005222:	64be                	ld	s1,456(sp)
    81005224:	691e                	ld	s2,448(sp)
    81005226:	79fa                	ld	s3,440(sp)
    81005228:	7a5a                	ld	s4,432(sp)
    8100522a:	7aba                	ld	s5,424(sp)
    8100522c:	7b1a                	ld	s6,416(sp)
    8100522e:	6bfa                	ld	s7,408(sp)
    81005230:	a881                	j	81005280 <sys_exec+0x104>
      argv[i] = 0;
    81005232:	0009079b          	sext.w	a5,s2
    81005236:	e3040593          	addi	a1,s0,-464
    8100523a:	078e                	slli	a5,a5,0x3
    8100523c:	97ae                	add	a5,a5,a1
    8100523e:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    81005242:	f3040513          	addi	a0,s0,-208
    81005246:	ba4ff0ef          	jal	810045ea <exec>
    8100524a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8100524c:	100a0a13          	addi	s4,s4,256
    81005250:	6088                	ld	a0,0(s1)
    81005252:	c511                	beqz	a0,8100525e <sys_exec+0xe2>
    kfree(argv[i]);
    81005254:	93bfb0ef          	jal	81000b8e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    81005258:	04a1                	addi	s1,s1,8
    8100525a:	ff449be3          	bne	s1,s4,81005250 <sys_exec+0xd4>
  return ret;
    8100525e:	854a                	mv	a0,s2
    81005260:	64be                	ld	s1,456(sp)
    81005262:	691e                	ld	s2,448(sp)
    81005264:	79fa                	ld	s3,440(sp)
    81005266:	7a5a                	ld	s4,432(sp)
    81005268:	7aba                	ld	s5,424(sp)
    8100526a:	7b1a                	ld	s6,416(sp)
    8100526c:	6bfa                	ld	s7,408(sp)
    8100526e:	a809                	j	81005280 <sys_exec+0x104>
  return -1;
    81005270:	557d                	li	a0,-1
    81005272:	64be                	ld	s1,456(sp)
    81005274:	691e                	ld	s2,448(sp)
    81005276:	79fa                	ld	s3,440(sp)
    81005278:	7a5a                	ld	s4,432(sp)
    8100527a:	7aba                	ld	s5,424(sp)
    8100527c:	7b1a                	ld	s6,416(sp)
    8100527e:	6bfa                	ld	s7,408(sp)
}
    81005280:	60fe                	ld	ra,472(sp)
    81005282:	645e                	ld	s0,464(sp)
    81005284:	613d                	addi	sp,sp,480
    81005286:	8082                	ret

0000000081005288 <sys_pipe>:

uint64
sys_pipe(void)
{
    81005288:	7139                	addi	sp,sp,-64
    8100528a:	fc06                	sd	ra,56(sp)
    8100528c:	f822                	sd	s0,48(sp)
    8100528e:	f426                	sd	s1,40(sp)
    81005290:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    81005292:	fa4fc0ef          	jal	81001a36 <myproc>
    81005296:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    81005298:	fd840593          	addi	a1,s0,-40
    8100529c:	4501                	li	a0,0
    8100529e:	e66fd0ef          	jal	81002904 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    810052a2:	fc840593          	addi	a1,s0,-56
    810052a6:	fd040513          	addi	a0,s0,-48
    810052aa:	81eff0ef          	jal	810042c8 <pipealloc>
    return -1;
    810052ae:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    810052b0:	0a054463          	bltz	a0,81005358 <sys_pipe+0xd0>
  fd0 = -1;
    810052b4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    810052b8:	fd043503          	ld	a0,-48(s0)
    810052bc:	edeff0ef          	jal	8100499a <fdalloc>
    810052c0:	fca42223          	sw	a0,-60(s0)
    810052c4:	08054163          	bltz	a0,81005346 <sys_pipe+0xbe>
    810052c8:	fc843503          	ld	a0,-56(s0)
    810052cc:	eceff0ef          	jal	8100499a <fdalloc>
    810052d0:	fca42023          	sw	a0,-64(s0)
    810052d4:	06054063          	bltz	a0,81005334 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    810052d8:	4691                	li	a3,4
    810052da:	fc440613          	addi	a2,s0,-60
    810052de:	fd843583          	ld	a1,-40(s0)
    810052e2:	68a8                	ld	a0,80(s1)
    810052e4:	bfafc0ef          	jal	810016de <copyout>
    810052e8:	00054e63          	bltz	a0,81005304 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    810052ec:	4691                	li	a3,4
    810052ee:	fc040613          	addi	a2,s0,-64
    810052f2:	fd843583          	ld	a1,-40(s0)
    810052f6:	95b6                	add	a1,a1,a3
    810052f8:	68a8                	ld	a0,80(s1)
    810052fa:	be4fc0ef          	jal	810016de <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    810052fe:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    81005300:	04055c63          	bgez	a0,81005358 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    81005304:	fc442783          	lw	a5,-60(s0)
    81005308:	07e9                	addi	a5,a5,26
    8100530a:	078e                	slli	a5,a5,0x3
    8100530c:	97a6                	add	a5,a5,s1
    8100530e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    81005312:	fc042783          	lw	a5,-64(s0)
    81005316:	07e9                	addi	a5,a5,26
    81005318:	078e                	slli	a5,a5,0x3
    8100531a:	94be                	add	s1,s1,a5
    8100531c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    81005320:	fd043503          	ld	a0,-48(s0)
    81005324:	c95fe0ef          	jal	81003fb8 <fileclose>
    fileclose(wf);
    81005328:	fc843503          	ld	a0,-56(s0)
    8100532c:	c8dfe0ef          	jal	81003fb8 <fileclose>
    return -1;
    81005330:	57fd                	li	a5,-1
    81005332:	a01d                	j	81005358 <sys_pipe+0xd0>
    if(fd0 >= 0)
    81005334:	fc442783          	lw	a5,-60(s0)
    81005338:	0007c763          	bltz	a5,81005346 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8100533c:	07e9                	addi	a5,a5,26
    8100533e:	078e                	slli	a5,a5,0x3
    81005340:	97a6                	add	a5,a5,s1
    81005342:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    81005346:	fd043503          	ld	a0,-48(s0)
    8100534a:	c6ffe0ef          	jal	81003fb8 <fileclose>
    fileclose(wf);
    8100534e:	fc843503          	ld	a0,-56(s0)
    81005352:	c67fe0ef          	jal	81003fb8 <fileclose>
    return -1;
    81005356:	57fd                	li	a5,-1
}
    81005358:	853e                	mv	a0,a5
    8100535a:	70e2                	ld	ra,56(sp)
    8100535c:	7442                	ld	s0,48(sp)
    8100535e:	74a2                	ld	s1,40(sp)
    81005360:	6121                	addi	sp,sp,64
    81005362:	8082                	ret
	...

0000000081005370 <kernelvec>:
    81005370:	7111                	addi	sp,sp,-256
    81005372:	e006                	sd	ra,0(sp)
    81005374:	e40a                	sd	sp,8(sp)
    81005376:	e80e                	sd	gp,16(sp)
    81005378:	ec12                	sd	tp,24(sp)
    8100537a:	f016                	sd	t0,32(sp)
    8100537c:	f41a                	sd	t1,40(sp)
    8100537e:	f81e                	sd	t2,48(sp)
    81005380:	e4aa                	sd	a0,72(sp)
    81005382:	e8ae                	sd	a1,80(sp)
    81005384:	ecb2                	sd	a2,88(sp)
    81005386:	f0b6                	sd	a3,96(sp)
    81005388:	f4ba                	sd	a4,104(sp)
    8100538a:	f8be                	sd	a5,112(sp)
    8100538c:	fcc2                	sd	a6,120(sp)
    8100538e:	e146                	sd	a7,128(sp)
    81005390:	edf2                	sd	t3,216(sp)
    81005392:	f1f6                	sd	t4,224(sp)
    81005394:	f5fa                	sd	t5,232(sp)
    81005396:	f9fe                	sd	t6,240(sp)
    81005398:	bd6fd0ef          	jal	8100276e <kerneltrap>
    8100539c:	6082                	ld	ra,0(sp)
    8100539e:	6122                	ld	sp,8(sp)
    810053a0:	61c2                	ld	gp,16(sp)
    810053a2:	7282                	ld	t0,32(sp)
    810053a4:	7322                	ld	t1,40(sp)
    810053a6:	73c2                	ld	t2,48(sp)
    810053a8:	6526                	ld	a0,72(sp)
    810053aa:	65c6                	ld	a1,80(sp)
    810053ac:	6666                	ld	a2,88(sp)
    810053ae:	7686                	ld	a3,96(sp)
    810053b0:	7726                	ld	a4,104(sp)
    810053b2:	77c6                	ld	a5,112(sp)
    810053b4:	7866                	ld	a6,120(sp)
    810053b6:	688a                	ld	a7,128(sp)
    810053b8:	6e6e                	ld	t3,216(sp)
    810053ba:	7e8e                	ld	t4,224(sp)
    810053bc:	7f2e                	ld	t5,232(sp)
    810053be:	7fce                	ld	t6,240(sp)
    810053c0:	6111                	addi	sp,sp,256
    810053c2:	10200073          	sret
	...

00000000810053ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    810053ce:	1141                	addi	sp,sp,-16
    810053d0:	e406                	sd	ra,8(sp)
    810053d2:	e022                	sd	s0,0(sp)
    810053d4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    810053d6:	0c000737          	lui	a4,0xc000
    810053da:	4785                	li	a5,1
    810053dc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    810053de:	c35c                	sw	a5,4(a4)
}
    810053e0:	60a2                	ld	ra,8(sp)
    810053e2:	6402                	ld	s0,0(sp)
    810053e4:	0141                	addi	sp,sp,16
    810053e6:	8082                	ret

00000000810053e8 <plicinithart>:

void
plicinithart(void)
{
    810053e8:	1141                	addi	sp,sp,-16
    810053ea:	e406                	sd	ra,8(sp)
    810053ec:	e022                	sd	s0,0(sp)
    810053ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    810053f0:	e12fc0ef          	jal	81001a02 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    810053f4:	0085171b          	slliw	a4,a0,0x8
    810053f8:	0c0027b7          	lui	a5,0xc002
    810053fc:	97ba                	add	a5,a5,a4
    810053fe:	40200713          	li	a4,1026
    81005402:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x74ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    81005406:	00d5151b          	slliw	a0,a0,0xd
    8100540a:	0c2017b7          	lui	a5,0xc201
    8100540e:	97aa                	add	a5,a5,a0
    81005410:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x74dff000>
}
    81005414:	60a2                	ld	ra,8(sp)
    81005416:	6402                	ld	s0,0(sp)
    81005418:	0141                	addi	sp,sp,16
    8100541a:	8082                	ret

000000008100541c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8100541c:	1141                	addi	sp,sp,-16
    8100541e:	e406                	sd	ra,8(sp)
    81005420:	e022                	sd	s0,0(sp)
    81005422:	0800                	addi	s0,sp,16
  int hart = cpuid();
    81005424:	ddefc0ef          	jal	81001a02 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    81005428:	00d5151b          	slliw	a0,a0,0xd
    8100542c:	0c2017b7          	lui	a5,0xc201
    81005430:	97aa                	add	a5,a5,a0
  return irq;
}
    81005432:	43c8                	lw	a0,4(a5)
    81005434:	60a2                	ld	ra,8(sp)
    81005436:	6402                	ld	s0,0(sp)
    81005438:	0141                	addi	sp,sp,16
    8100543a:	8082                	ret

000000008100543c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8100543c:	1101                	addi	sp,sp,-32
    8100543e:	ec06                	sd	ra,24(sp)
    81005440:	e822                	sd	s0,16(sp)
    81005442:	e426                	sd	s1,8(sp)
    81005444:	1000                	addi	s0,sp,32
    81005446:	84aa                	mv	s1,a0
  int hart = cpuid();
    81005448:	dbafc0ef          	jal	81001a02 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8100544c:	00d5179b          	slliw	a5,a0,0xd
    81005450:	0c201737          	lui	a4,0xc201
    81005454:	97ba                	add	a5,a5,a4
    81005456:	c3c4                	sw	s1,4(a5)
}
    81005458:	60e2                	ld	ra,24(sp)
    8100545a:	6442                	ld	s0,16(sp)
    8100545c:	64a2                	ld	s1,8(sp)
    8100545e:	6105                	addi	sp,sp,32
    81005460:	8082                	ret

0000000081005462 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    81005462:	1141                	addi	sp,sp,-16
    81005464:	e406                	sd	ra,8(sp)
    81005466:	e022                	sd	s0,0(sp)
    81005468:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8100546a:	479d                	li	a5,7
    8100546c:	04a7ca63          	blt	a5,a0,810054c0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    81005470:	0001b797          	auipc	a5,0x1b
    81005474:	72078793          	addi	a5,a5,1824 # 81020b90 <disk>
    81005478:	97aa                	add	a5,a5,a0
    8100547a:	0187c783          	lbu	a5,24(a5)
    8100547e:	e7b9                	bnez	a5,810054cc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    81005480:	00451693          	slli	a3,a0,0x4
    81005484:	0001b797          	auipc	a5,0x1b
    81005488:	70c78793          	addi	a5,a5,1804 # 81020b90 <disk>
    8100548c:	6398                	ld	a4,0(a5)
    8100548e:	9736                	add	a4,a4,a3
    81005490:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x74dff000>
  disk.desc[i].len = 0;
    81005494:	6398                	ld	a4,0(a5)
    81005496:	9736                	add	a4,a4,a3
    81005498:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8100549c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    810054a0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    810054a4:	97aa                	add	a5,a5,a0
    810054a6:	4705                	li	a4,1
    810054a8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    810054ac:	0001b517          	auipc	a0,0x1b
    810054b0:	6fc50513          	addi	a0,a0,1788 # 81020ba8 <disk+0x18>
    810054b4:	b9dfc0ef          	jal	81002050 <wakeup>
}
    810054b8:	60a2                	ld	ra,8(sp)
    810054ba:	6402                	ld	s0,0(sp)
    810054bc:	0141                	addi	sp,sp,16
    810054be:	8082                	ret
    panic("free_desc 1");
    810054c0:	00002517          	auipc	a0,0x2
    810054c4:	23850513          	addi	a0,a0,568 # 810076f8 <etext+0x6f8>
    810054c8:	c1cfb0ef          	jal	810008e4 <panic>
    panic("free_desc 2");
    810054cc:	00002517          	auipc	a0,0x2
    810054d0:	23c50513          	addi	a0,a0,572 # 81007708 <etext+0x708>
    810054d4:	c10fb0ef          	jal	810008e4 <panic>

00000000810054d8 <virtio_disk_init>:
{
    810054d8:	1101                	addi	sp,sp,-32
    810054da:	ec06                	sd	ra,24(sp)
    810054dc:	e822                	sd	s0,16(sp)
    810054de:	e426                	sd	s1,8(sp)
    810054e0:	e04a                	sd	s2,0(sp)
    810054e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    810054e4:	00002597          	auipc	a1,0x2
    810054e8:	23458593          	addi	a1,a1,564 # 81007718 <etext+0x718>
    810054ec:	0001b517          	auipc	a0,0x1b
    810054f0:	7cc50513          	addi	a0,a0,1996 # 81020cb8 <disk+0x128>
    810054f4:	fd0fb0ef          	jal	81000cc4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    810054f8:	100017b7          	lui	a5,0x10001
    810054fc:	4398                	lw	a4,0(a5)
    810054fe:	2701                	sext.w	a4,a4
    81005500:	747277b7          	lui	a5,0x74727
    81005504:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xc8d968a>
    81005508:	14f71863          	bne	a4,a5,81005658 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8100550c:	100017b7          	lui	a5,0x10001
    81005510:	43dc                	lw	a5,4(a5)
    81005512:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    81005514:	4709                	li	a4,2
    81005516:	14e79163          	bne	a5,a4,81005658 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8100551a:	100017b7          	lui	a5,0x10001
    8100551e:	479c                	lw	a5,8(a5)
    81005520:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    81005522:	12e79b63          	bne	a5,a4,81005658 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    81005526:	100017b7          	lui	a5,0x10001
    8100552a:	47d8                	lw	a4,12(a5)
    8100552c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8100552e:	554d47b7          	lui	a5,0x554d4
    81005532:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2bb2baaf>
    81005536:	12f71163          	bne	a4,a5,81005658 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8100553a:	100017b7          	lui	a5,0x10001
    8100553e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x70ffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    81005542:	4705                	li	a4,1
    81005544:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    81005546:	470d                	li	a4,3
    81005548:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8100554a:	10001737          	lui	a4,0x10001
    8100554e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    81005550:	c7ffe6b7          	lui	a3,0xc7ffe
    81005554:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff46fdd75f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    81005558:	8f75                	and	a4,a4,a3
    8100555a:	100016b7          	lui	a3,0x10001
    8100555e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    81005560:	472d                	li	a4,11
    81005562:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    81005564:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    81005568:	439c                	lw	a5,0(a5)
    8100556a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8100556e:	8ba1                	andi	a5,a5,8
    81005570:	0e078a63          	beqz	a5,81005664 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    81005574:	100017b7          	lui	a5,0x10001
    81005578:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x70ffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8100557c:	43fc                	lw	a5,68(a5)
    8100557e:	2781                	sext.w	a5,a5
    81005580:	0e079863          	bnez	a5,81005670 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    81005584:	100017b7          	lui	a5,0x10001
    81005588:	5bdc                	lw	a5,52(a5)
    8100558a:	2781                	sext.w	a5,a5
  if(max == 0)
    8100558c:	0e078863          	beqz	a5,8100567c <virtio_disk_init+0x1a4>
  if(max < NUM)
    81005590:	471d                	li	a4,7
    81005592:	0ef77b63          	bgeu	a4,a5,81005688 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    81005596:	edefb0ef          	jal	81000c74 <kalloc>
    8100559a:	0001b497          	auipc	s1,0x1b
    8100559e:	5f648493          	addi	s1,s1,1526 # 81020b90 <disk>
    810055a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    810055a4:	ed0fb0ef          	jal	81000c74 <kalloc>
    810055a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    810055aa:	ecafb0ef          	jal	81000c74 <kalloc>
    810055ae:	87aa                	mv	a5,a0
    810055b0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    810055b2:	6088                	ld	a0,0(s1)
    810055b4:	0e050063          	beqz	a0,81005694 <virtio_disk_init+0x1bc>
    810055b8:	0001b717          	auipc	a4,0x1b
    810055bc:	5e073703          	ld	a4,1504(a4) # 81020b98 <disk+0x8>
    810055c0:	cb71                	beqz	a4,81005694 <virtio_disk_init+0x1bc>
    810055c2:	cbe9                	beqz	a5,81005694 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    810055c4:	6605                	lui	a2,0x1
    810055c6:	4581                	li	a1,0
    810055c8:	851fb0ef          	jal	81000e18 <memset>
  memset(disk.avail, 0, PGSIZE);
    810055cc:	0001b497          	auipc	s1,0x1b
    810055d0:	5c448493          	addi	s1,s1,1476 # 81020b90 <disk>
    810055d4:	6605                	lui	a2,0x1
    810055d6:	4581                	li	a1,0
    810055d8:	6488                	ld	a0,8(s1)
    810055da:	83ffb0ef          	jal	81000e18 <memset>
  memset(disk.used, 0, PGSIZE);
    810055de:	6605                	lui	a2,0x1
    810055e0:	4581                	li	a1,0
    810055e2:	6888                	ld	a0,16(s1)
    810055e4:	835fb0ef          	jal	81000e18 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    810055e8:	100017b7          	lui	a5,0x10001
    810055ec:	4721                	li	a4,8
    810055ee:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    810055f0:	4098                	lw	a4,0(s1)
    810055f2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x70ffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    810055f6:	40d8                	lw	a4,4(s1)
    810055f8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    810055fc:	649c                	ld	a5,8(s1)
    810055fe:	0007869b          	sext.w	a3,a5
    81005602:	10001737          	lui	a4,0x10001
    81005606:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x70ffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8100560a:	9781                	srai	a5,a5,0x20
    8100560c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    81005610:	689c                	ld	a5,16(s1)
    81005612:	0007869b          	sext.w	a3,a5
    81005616:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8100561a:	9781                	srai	a5,a5,0x20
    8100561c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    81005620:	4785                	li	a5,1
    81005622:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    81005624:	00f48c23          	sb	a5,24(s1)
    81005628:	00f48ca3          	sb	a5,25(s1)
    8100562c:	00f48d23          	sb	a5,26(s1)
    81005630:	00f48da3          	sb	a5,27(s1)
    81005634:	00f48e23          	sb	a5,28(s1)
    81005638:	00f48ea3          	sb	a5,29(s1)
    8100563c:	00f48f23          	sb	a5,30(s1)
    81005640:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    81005644:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    81005648:	07272823          	sw	s2,112(a4)
}
    8100564c:	60e2                	ld	ra,24(sp)
    8100564e:	6442                	ld	s0,16(sp)
    81005650:	64a2                	ld	s1,8(sp)
    81005652:	6902                	ld	s2,0(sp)
    81005654:	6105                	addi	sp,sp,32
    81005656:	8082                	ret
    panic("could not find virtio disk");
    81005658:	00002517          	auipc	a0,0x2
    8100565c:	0d050513          	addi	a0,a0,208 # 81007728 <etext+0x728>
    81005660:	a84fb0ef          	jal	810008e4 <panic>
    panic("virtio disk FEATURES_OK unset");
    81005664:	00002517          	auipc	a0,0x2
    81005668:	0e450513          	addi	a0,a0,228 # 81007748 <etext+0x748>
    8100566c:	a78fb0ef          	jal	810008e4 <panic>
    panic("virtio disk should not be ready");
    81005670:	00002517          	auipc	a0,0x2
    81005674:	0f850513          	addi	a0,a0,248 # 81007768 <etext+0x768>
    81005678:	a6cfb0ef          	jal	810008e4 <panic>
    panic("virtio disk has no queue 0");
    8100567c:	00002517          	auipc	a0,0x2
    81005680:	10c50513          	addi	a0,a0,268 # 81007788 <etext+0x788>
    81005684:	a60fb0ef          	jal	810008e4 <panic>
    panic("virtio disk max queue too short");
    81005688:	00002517          	auipc	a0,0x2
    8100568c:	12050513          	addi	a0,a0,288 # 810077a8 <etext+0x7a8>
    81005690:	a54fb0ef          	jal	810008e4 <panic>
    panic("virtio disk kalloc");
    81005694:	00002517          	auipc	a0,0x2
    81005698:	13450513          	addi	a0,a0,308 # 810077c8 <etext+0x7c8>
    8100569c:	a48fb0ef          	jal	810008e4 <panic>

00000000810056a0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    810056a0:	711d                	addi	sp,sp,-96
    810056a2:	ec86                	sd	ra,88(sp)
    810056a4:	e8a2                	sd	s0,80(sp)
    810056a6:	e4a6                	sd	s1,72(sp)
    810056a8:	e0ca                	sd	s2,64(sp)
    810056aa:	fc4e                	sd	s3,56(sp)
    810056ac:	f852                	sd	s4,48(sp)
    810056ae:	f456                	sd	s5,40(sp)
    810056b0:	f05a                	sd	s6,32(sp)
    810056b2:	ec5e                	sd	s7,24(sp)
    810056b4:	e862                	sd	s8,16(sp)
    810056b6:	1080                	addi	s0,sp,96
    810056b8:	89aa                	mv	s3,a0
    810056ba:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    810056bc:	00c52b83          	lw	s7,12(a0)
    810056c0:	001b9b9b          	slliw	s7,s7,0x1
    810056c4:	1b82                	slli	s7,s7,0x20
    810056c6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    810056ca:	0001b517          	auipc	a0,0x1b
    810056ce:	5ee50513          	addi	a0,a0,1518 # 81020cb8 <disk+0x128>
    810056d2:	e76fb0ef          	jal	81000d48 <acquire>
  for(int i = 0; i < NUM; i++){
    810056d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    810056d8:	0001ba97          	auipc	s5,0x1b
    810056dc:	4b8a8a93          	addi	s5,s5,1208 # 81020b90 <disk>
  for(int i = 0; i < 3; i++){
    810056e0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    810056e2:	5c7d                	li	s8,-1
    810056e4:	a095                	j	81005748 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    810056e6:	00fa8733          	add	a4,s5,a5
    810056ea:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    810056ee:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    810056f0:	0207c563          	bltz	a5,8100571a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    810056f4:	2905                	addiw	s2,s2,1
    810056f6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x80ffeffc>
    810056f8:	05490c63          	beq	s2,s4,81005750 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    810056fc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    810056fe:	0001b717          	auipc	a4,0x1b
    81005702:	49270713          	addi	a4,a4,1170 # 81020b90 <disk>
    81005706:	4781                	li	a5,0
    if(disk.free[i]){
    81005708:	01874683          	lbu	a3,24(a4)
    8100570c:	fee9                	bnez	a3,810056e6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8100570e:	2785                	addiw	a5,a5,1
    81005710:	0705                	addi	a4,a4,1
    81005712:	fe979be3          	bne	a5,s1,81005708 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    81005716:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8100571a:	01205d63          	blez	s2,81005734 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8100571e:	fa042503          	lw	a0,-96(s0)
    81005722:	d41ff0ef          	jal	81005462 <free_desc>
      for(int j = 0; j < i; j++)
    81005726:	4785                	li	a5,1
    81005728:	0127d663          	bge	a5,s2,81005734 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8100572c:	fa442503          	lw	a0,-92(s0)
    81005730:	d33ff0ef          	jal	81005462 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    81005734:	0001b597          	auipc	a1,0x1b
    81005738:	58458593          	addi	a1,a1,1412 # 81020cb8 <disk+0x128>
    8100573c:	0001b517          	auipc	a0,0x1b
    81005740:	46c50513          	addi	a0,a0,1132 # 81020ba8 <disk+0x18>
    81005744:	8c1fc0ef          	jal	81002004 <sleep>
  for(int i = 0; i < 3; i++){
    81005748:	fa040613          	addi	a2,s0,-96
    8100574c:	4901                	li	s2,0
    8100574e:	b77d                	j	810056fc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    81005750:	fa042503          	lw	a0,-96(s0)
    81005754:	00451693          	slli	a3,a0,0x4

  if(write)
    81005758:	0001b797          	auipc	a5,0x1b
    8100575c:	43878793          	addi	a5,a5,1080 # 81020b90 <disk>
    81005760:	00a50713          	addi	a4,a0,10
    81005764:	0712                	slli	a4,a4,0x4
    81005766:	973e                	add	a4,a4,a5
    81005768:	01603633          	snez	a2,s6
    8100576c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8100576e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    81005772:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    81005776:	6398                	ld	a4,0(a5)
    81005778:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8100577a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x70ffef58>
    8100577e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    81005780:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    81005782:	6390                	ld	a2,0(a5)
    81005784:	00d605b3          	add	a1,a2,a3
    81005788:	4741                	li	a4,16
    8100578a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8100578c:	4805                	li	a6,1
    8100578e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    81005792:	fa442703          	lw	a4,-92(s0)
    81005796:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8100579a:	0712                	slli	a4,a4,0x4
    8100579c:	963a                	add	a2,a2,a4
    8100579e:	05898593          	addi	a1,s3,88
    810057a2:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    810057a4:	0007b883          	ld	a7,0(a5)
    810057a8:	9746                	add	a4,a4,a7
    810057aa:	40000613          	li	a2,1024
    810057ae:	c710                	sw	a2,8(a4)
  if(write)
    810057b0:	001b3613          	seqz	a2,s6
    810057b4:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    810057b8:	01066633          	or	a2,a2,a6
    810057bc:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    810057c0:	fa842583          	lw	a1,-88(s0)
    810057c4:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    810057c8:	00250613          	addi	a2,a0,2
    810057cc:	0612                	slli	a2,a2,0x4
    810057ce:	963e                	add	a2,a2,a5
    810057d0:	577d                	li	a4,-1
    810057d2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    810057d6:	0592                	slli	a1,a1,0x4
    810057d8:	98ae                	add	a7,a7,a1
    810057da:	03068713          	addi	a4,a3,48
    810057de:	973e                	add	a4,a4,a5
    810057e0:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    810057e4:	6398                	ld	a4,0(a5)
    810057e6:	972e                	add	a4,a4,a1
    810057e8:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    810057ec:	4689                	li	a3,2
    810057ee:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    810057f2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    810057f6:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    810057fa:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    810057fe:	6794                	ld	a3,8(a5)
    81005800:	0026d703          	lhu	a4,2(a3)
    81005804:	8b1d                	andi	a4,a4,7
    81005806:	0706                	slli	a4,a4,0x1
    81005808:	96ba                	add	a3,a3,a4
    8100580a:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8100580e:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    81005812:	6798                	ld	a4,8(a5)
    81005814:	00275783          	lhu	a5,2(a4)
    81005818:	2785                	addiw	a5,a5,1
    8100581a:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8100581e:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    81005822:	100017b7          	lui	a5,0x10001
    81005826:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x70ffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8100582a:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    8100582e:	0001b917          	auipc	s2,0x1b
    81005832:	48a90913          	addi	s2,s2,1162 # 81020cb8 <disk+0x128>
  while(b->disk == 1) {
    81005836:	84c2                	mv	s1,a6
    81005838:	01079a63          	bne	a5,a6,8100584c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    8100583c:	85ca                	mv	a1,s2
    8100583e:	854e                	mv	a0,s3
    81005840:	fc4fc0ef          	jal	81002004 <sleep>
  while(b->disk == 1) {
    81005844:	0049a783          	lw	a5,4(s3)
    81005848:	fe978ae3          	beq	a5,s1,8100583c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    8100584c:	fa042903          	lw	s2,-96(s0)
    81005850:	00290713          	addi	a4,s2,2
    81005854:	0712                	slli	a4,a4,0x4
    81005856:	0001b797          	auipc	a5,0x1b
    8100585a:	33a78793          	addi	a5,a5,826 # 81020b90 <disk>
    8100585e:	97ba                	add	a5,a5,a4
    81005860:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    81005864:	0001b997          	auipc	s3,0x1b
    81005868:	32c98993          	addi	s3,s3,812 # 81020b90 <disk>
    8100586c:	00491713          	slli	a4,s2,0x4
    81005870:	0009b783          	ld	a5,0(s3)
    81005874:	97ba                	add	a5,a5,a4
    81005876:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8100587a:	854a                	mv	a0,s2
    8100587c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    81005880:	be3ff0ef          	jal	81005462 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    81005884:	8885                	andi	s1,s1,1
    81005886:	f0fd                	bnez	s1,8100586c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    81005888:	0001b517          	auipc	a0,0x1b
    8100588c:	43050513          	addi	a0,a0,1072 # 81020cb8 <disk+0x128>
    81005890:	d4cfb0ef          	jal	81000ddc <release>
}
    81005894:	60e6                	ld	ra,88(sp)
    81005896:	6446                	ld	s0,80(sp)
    81005898:	64a6                	ld	s1,72(sp)
    8100589a:	6906                	ld	s2,64(sp)
    8100589c:	79e2                	ld	s3,56(sp)
    8100589e:	7a42                	ld	s4,48(sp)
    810058a0:	7aa2                	ld	s5,40(sp)
    810058a2:	7b02                	ld	s6,32(sp)
    810058a4:	6be2                	ld	s7,24(sp)
    810058a6:	6c42                	ld	s8,16(sp)
    810058a8:	6125                	addi	sp,sp,96
    810058aa:	8082                	ret

00000000810058ac <virtio_disk_intr>:

void
virtio_disk_intr()
{
    810058ac:	1101                	addi	sp,sp,-32
    810058ae:	ec06                	sd	ra,24(sp)
    810058b0:	e822                	sd	s0,16(sp)
    810058b2:	e426                	sd	s1,8(sp)
    810058b4:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    810058b6:	0001b497          	auipc	s1,0x1b
    810058ba:	2da48493          	addi	s1,s1,730 # 81020b90 <disk>
    810058be:	0001b517          	auipc	a0,0x1b
    810058c2:	3fa50513          	addi	a0,a0,1018 # 81020cb8 <disk+0x128>
    810058c6:	c82fb0ef          	jal	81000d48 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    810058ca:	100017b7          	lui	a5,0x10001
    810058ce:	53bc                	lw	a5,96(a5)
    810058d0:	8b8d                	andi	a5,a5,3
    810058d2:	10001737          	lui	a4,0x10001
    810058d6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    810058d8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    810058dc:	689c                	ld	a5,16(s1)
    810058de:	0204d703          	lhu	a4,32(s1)
    810058e2:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x70ffeffe>
    810058e6:	04f70663          	beq	a4,a5,81005932 <virtio_disk_intr+0x86>
    __sync_synchronize();
    810058ea:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    810058ee:	6898                	ld	a4,16(s1)
    810058f0:	0204d783          	lhu	a5,32(s1)
    810058f4:	8b9d                	andi	a5,a5,7
    810058f6:	078e                	slli	a5,a5,0x3
    810058f8:	97ba                	add	a5,a5,a4
    810058fa:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    810058fc:	00278713          	addi	a4,a5,2
    81005900:	0712                	slli	a4,a4,0x4
    81005902:	9726                	add	a4,a4,s1
    81005904:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x70ffeff0>
    81005908:	e321                	bnez	a4,81005948 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8100590a:	0789                	addi	a5,a5,2
    8100590c:	0792                	slli	a5,a5,0x4
    8100590e:	97a6                	add	a5,a5,s1
    81005910:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    81005912:	00052223          	sw	zero,4(a0)
    wakeup(b);
    81005916:	f3afc0ef          	jal	81002050 <wakeup>

    disk.used_idx += 1;
    8100591a:	0204d783          	lhu	a5,32(s1)
    8100591e:	2785                	addiw	a5,a5,1
    81005920:	17c2                	slli	a5,a5,0x30
    81005922:	93c1                	srli	a5,a5,0x30
    81005924:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    81005928:	6898                	ld	a4,16(s1)
    8100592a:	00275703          	lhu	a4,2(a4)
    8100592e:	faf71ee3          	bne	a4,a5,810058ea <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    81005932:	0001b517          	auipc	a0,0x1b
    81005936:	38650513          	addi	a0,a0,902 # 81020cb8 <disk+0x128>
    8100593a:	ca2fb0ef          	jal	81000ddc <release>
}
    8100593e:	60e2                	ld	ra,24(sp)
    81005940:	6442                	ld	s0,16(sp)
    81005942:	64a2                	ld	s1,8(sp)
    81005944:	6105                	addi	sp,sp,32
    81005946:	8082                	ret
      panic("virtio_disk_intr status");
    81005948:	00002517          	auipc	a0,0x2
    8100594c:	e9850513          	addi	a0,a0,-360 # 810077e0 <etext+0x7e0>
    81005950:	f95fa0ef          	jal	810008e4 <panic>
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
