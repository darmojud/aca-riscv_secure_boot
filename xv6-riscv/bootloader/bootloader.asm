
bootloader/bootloader:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	f14022f3          	csrr	t0,mhartid
    80000004:	6305                	lui	t1,0x1
    80000006:	026282b3          	mul	t0,t0,t1
    8000000a:	929a                	add	t0,t0,t1
    8000000c:	00001397          	auipc	t2,0x1
    80000010:	cc438393          	addi	t2,t2,-828 # 80000cd0 <bl_stack>
    80000014:	9396                	add	t2,t2,t0
    80000016:	811e                	mv	sp,t2
    80000018:	246000ef          	jal	8000025e <start>

000000008000001c <spin>:
    8000001c:	a001                	j	8000001c <spin>

000000008000001e <panic>:
};
struct sys_info *sys_info_ptr;

extern void _entry(void);
void panic(char *s)
{
    8000001e:	1141                	addi	sp,sp,-16
    80000020:	e406                	sd	ra,8(sp)
    80000022:	e022                	sd	s0,0(sp)
    80000024:	0800                	addi	s0,sp,16
  for (;;)
    80000026:	a001                	j	80000026 <panic+0x8>

0000000080000028 <setup_recovery_kernel>:
}

/* CSE 536: Boot into the RECOVERY kernel instead of NORMAL kernel
 * when hash verification fails. */
void setup_recovery_kernel(void)
{
    80000028:	b7010113          	addi	sp,sp,-1168
    8000002c:	48113423          	sd	ra,1160(sp)
    80000030:	48813023          	sd	s0,1152(sp)
    80000034:	45513c23          	sd	s5,1112(sp)
    80000038:	49010413          	addi	s0,sp,1168
  uint64 rec_kernel_load_addr = find_kernel_load_addr(RECOVERY);
    8000003c:	4505                	li	a0,1
    8000003e:	5b6000ef          	jal	800005f4 <find_kernel_load_addr>
    80000042:	8aaa                	mv	s5,a0
  uint64 rec_kernel_binary_size = find_kernel_size(RECOVERY);
    80000044:	4505                	li	a0,1
    80000046:	612000ef          	jal	80000658 <find_kernel_size>

  struct buf b;
  uint64 rec_num_blocks = rec_kernel_binary_size / BSIZE;
  for (int i = 0; i < rec_num_blocks; i++)
    8000004a:	3ff00793          	li	a5,1023
    8000004e:	08a7f563          	bgeu	a5,a0,800000d8 <setup_recovery_kernel+0xb0>
    80000052:	46913c23          	sd	s1,1144(sp)
    80000056:	47213823          	sd	s2,1136(sp)
    8000005a:	47313423          	sd	s3,1128(sp)
    8000005e:	47413023          	sd	s4,1120(sp)
    80000062:	45613823          	sd	s6,1104(sp)
    80000066:	45713423          	sd	s7,1096(sp)
    8000006a:	45813023          	sd	s8,1088(sp)
    8000006e:	43913c23          	sd	s9,1080(sp)
    80000072:	00a55993          	srli	s3,a0,0xa
    80000076:	797d                	lui	s2,0xfffff
    80000078:	4481                	li	s1,0
  {
    // ignoring the first 4 (4*1024) blocks as it is elf headers
    if (i < 4)
    8000007a:	4a0d                	li	s4,3
      continue;
    b.blockno = i;
    kernel_copy(RECOVERY, &b);
    8000007c:	b7840c93          	addi	s9,s0,-1160
    80000080:	4c05                	li	s8,1
    memmove((void *)rec_kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    80000082:	ba040b93          	addi	s7,s0,-1120
    80000086:	40000b13          	li	s6,1024
    8000008a:	a031                	j	80000096 <setup_recovery_kernel+0x6e>
  for (int i = 0; i < rec_num_blocks; i++)
    8000008c:	0485                	addi	s1,s1,1
    8000008e:	4009091b          	addiw	s2,s2,1024 # fffffffffffff400 <kernel_elfhdr+0xffffffff7fff6720>
    80000092:	0334f363          	bgeu	s1,s3,800000b8 <setup_recovery_kernel+0x90>
    if (i < 4)
    80000096:	0004879b          	sext.w	a5,s1
    8000009a:	fefa59e3          	bge	s4,a5,8000008c <setup_recovery_kernel+0x64>
    b.blockno = i;
    8000009e:	b8942223          	sw	s1,-1148(s0)
    kernel_copy(RECOVERY, &b);
    800000a2:	85e6                	mv	a1,s9
    800000a4:	8562                	mv	a0,s8
    800000a6:	32c000ef          	jal	800003d2 <kernel_copy>
    memmove((void *)rec_kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    800000aa:	865a                	mv	a2,s6
    800000ac:	85de                	mv	a1,s7
    800000ae:	01590533          	add	a0,s2,s5
    800000b2:	3f0000ef          	jal	800004a2 <memmove>
    800000b6:	bfd9                	j	8000008c <setup_recovery_kernel+0x64>
    800000b8:	47813483          	ld	s1,1144(sp)
    800000bc:	47013903          	ld	s2,1136(sp)
    800000c0:	46813983          	ld	s3,1128(sp)
    800000c4:	46013a03          	ld	s4,1120(sp)
    800000c8:	45013b03          	ld	s6,1104(sp)
    800000cc:	44813b83          	ld	s7,1096(sp)
    800000d0:	44013c03          	ld	s8,1088(sp)
    800000d4:	43813c83          	ld	s9,1080(sp)
  }

  uint64 rec_kernel_entry = find_kernel_entry_addr(RECOVERY);
    800000d8:	4505                	li	a0,1
    800000da:	5cc000ef          	jal	800006a6 <find_kernel_entry_addr>
// instruction address to which a return from
// exception will go.
static inline void
w_mepc(uint64 x)
{
  asm volatile("csrw mepc, %0"
    800000de:	34151073          	csrw	mepc,a0

  /* CSE 536: Write the correct kernel entry point */
  w_mepc((uint64)rec_kernel_entry);
}
    800000e2:	48813083          	ld	ra,1160(sp)
    800000e6:	48013403          	ld	s0,1152(sp)
    800000ea:	45813a83          	ld	s5,1112(sp)
    800000ee:	49010113          	addi	sp,sp,1168
    800000f2:	8082                	ret

00000000800000f4 <is_secure_boot>:

/* CSE 536: Function verifies if NORMAL kernel is expected or tampered. */
bool is_secure_boot(void)
{
    800000f4:	b7010113          	addi	sp,sp,-1168
    800000f8:	48113423          	sd	ra,1160(sp)
    800000fc:	48813023          	sd	s0,1152(sp)
    80000100:	46913c23          	sd	s1,1144(sp)
    80000104:	47213823          	sd	s2,1136(sp)
    80000108:	45513c23          	sd	s5,1112(sp)
    8000010c:	43913c23          	sd	s9,1080(sp)
    80000110:	43a13823          	sd	s10,1072(sp)
    80000114:	49010413          	addi	s0,sp,1168
  bool verification = true;

  /* Read the binary and update the observed measurement
   * (simplified template provided below) */
  sha256_init(&sha256_ctx);
    80000118:	00001517          	auipc	a0,0x1
    8000011c:	b4850513          	addi	a0,a0,-1208 # 80000c60 <sha256_ctx>
    80000120:	7a8000ef          	jal	800008c8 <sha256_init>
  struct buf b;
  uint64 kernel_load_addr = find_kernel_load_addr(NORMAL);
    80000124:	4501                	li	a0,0
    80000126:	4ce000ef          	jal	800005f4 <find_kernel_load_addr>
    8000012a:	8caa                	mv	s9,a0
  uint64 kernel_binary_size = find_kernel_size(NORMAL);
    8000012c:	4501                	li	a0,0
    8000012e:	52a000ef          	jal	80000658 <find_kernel_size>
    80000132:	8d2a                	mv	s10,a0
  uint64 num_blocks = kernel_binary_size / BSIZE;
    80000134:	00a55a93          	srli	s5,a0,0xa
  for (int i = 0; i < num_blocks; i++)
    80000138:	3ff00793          	li	a5,1023
    8000013c:	08a7fa63          	bgeu	a5,a0,800001d0 <is_secure_boot+0xdc>
    80000140:	47313423          	sd	s3,1128(sp)
    80000144:	47413023          	sd	s4,1120(sp)
    80000148:	45613823          	sd	s6,1104(sp)
    8000014c:	45713423          	sd	s7,1096(sp)
    80000150:	45813023          	sd	s8,1088(sp)
    80000154:	797d                	lui	s2,0xfffff
    80000156:	4481                	li	s1,0
  {
    // ignoring the first 4 (4*1024) blocks as it is elf headers
    if (i < 4)
    80000158:	4b0d                	li	s6,3
      kernel_copy(NORMAL, &b);
      sha256_update(&sha256_ctx, (const unsigned char *)b.data, BSIZE);
      continue;
    }
    b.blockno = i;
    kernel_copy(NORMAL, &b);
    8000015a:	b7840c13          	addi	s8,s0,-1160
    memmove((void *)kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    8000015e:	ba040a13          	addi	s4,s0,-1120
    80000162:	40000993          	li	s3,1024
    sha256_update(&sha256_ctx, (const unsigned char *)b.data, BSIZE);
    80000166:	00001b97          	auipc	s7,0x1
    8000016a:	afab8b93          	addi	s7,s7,-1286 # 80000c60 <sha256_ctx>
    8000016e:	a00d                	j	80000190 <is_secure_boot+0x9c>
      b.blockno = i;
    80000170:	b8942223          	sw	s1,-1148(s0)
      kernel_copy(NORMAL, &b);
    80000174:	85e2                	mv	a1,s8
    80000176:	4501                	li	a0,0
    80000178:	25a000ef          	jal	800003d2 <kernel_copy>
      sha256_update(&sha256_ctx, (const unsigned char *)b.data, BSIZE);
    8000017c:	864e                	mv	a2,s3
    8000017e:	85d2                	mv	a1,s4
    80000180:	855e                	mv	a0,s7
    80000182:	7ae000ef          	jal	80000930 <sha256_update>
  for (int i = 0; i < num_blocks; i++)
    80000186:	0485                	addi	s1,s1,1
    80000188:	4009091b          	addiw	s2,s2,1024 # fffffffffffff400 <kernel_elfhdr+0xffffffff7fff6720>
    8000018c:	0354f863          	bgeu	s1,s5,800001bc <is_secure_boot+0xc8>
    if (i < 4)
    80000190:	0004879b          	sext.w	a5,s1
    80000194:	fcfb5ee3          	bge	s6,a5,80000170 <is_secure_boot+0x7c>
    b.blockno = i;
    80000198:	b8942223          	sw	s1,-1148(s0)
    kernel_copy(NORMAL, &b);
    8000019c:	85e2                	mv	a1,s8
    8000019e:	4501                	li	a0,0
    800001a0:	232000ef          	jal	800003d2 <kernel_copy>
    memmove((void *)kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    800001a4:	864e                	mv	a2,s3
    800001a6:	85d2                	mv	a1,s4
    800001a8:	01990533          	add	a0,s2,s9
    800001ac:	2f6000ef          	jal	800004a2 <memmove>
    sha256_update(&sha256_ctx, (const unsigned char *)b.data, BSIZE);
    800001b0:	864e                	mv	a2,s3
    800001b2:	85d2                	mv	a1,s4
    800001b4:	855e                	mv	a0,s7
    800001b6:	77a000ef          	jal	80000930 <sha256_update>
    800001ba:	b7f1                	j	80000186 <is_secure_boot+0x92>
    800001bc:	46813983          	ld	s3,1128(sp)
    800001c0:	46013a03          	ld	s4,1120(sp)
    800001c4:	45013b03          	ld	s6,1104(sp)
    800001c8:	44813b83          	ld	s7,1096(sp)
    800001cc:	44013c03          	ld	s8,1088(sp)
  }
  uint64 rem_size = kernel_binary_size - BSIZE * num_blocks;
  b.blockno = num_blocks;
    800001d0:	b9542223          	sw	s5,-1148(s0)
  kernel_copy(NORMAL, &b);
    800001d4:	b7840593          	addi	a1,s0,-1160
    800001d8:	4501                	li	a0,0
    800001da:	1f8000ef          	jal	800003d2 <kernel_copy>
  sha256_update(&sha256_ctx, (const unsigned char *)b.data, rem_size);
    800001de:	00001917          	auipc	s2,0x1
    800001e2:	a8290913          	addi	s2,s2,-1406 # 80000c60 <sha256_ctx>
    800001e6:	3ffd7613          	andi	a2,s10,1023
    800001ea:	ba040593          	addi	a1,s0,-1120
    800001ee:	854a                	mv	a0,s2
    800001f0:	740000ef          	jal	80000930 <sha256_update>
  sha256_final(&sha256_ctx, sys_info_ptr->observed_kernel_measurement);
    800001f4:	00009497          	auipc	s1,0x9
    800001f8:	adc48493          	addi	s1,s1,-1316 # 80008cd0 <sys_info_ptr>
    800001fc:	608c                	ld	a1,0(s1)
    800001fe:	04058593          	addi	a1,a1,64
    80000202:	854a                	mv	a0,s2
    80000204:	7a6000ef          	jal	800009aa <sha256_final>

  /* Three more tasks required below:
   *  1. Compare observed measurement with expected hash
   *  2. Setup the recovery kernel if comparison fails
   *  3. Copy expected kernel hash to the system information table */
  memcpy(sys_info_ptr->expected_kernel_measurement, trusted_kernel_hash, sizeof(sys_info_ptr->expected_kernel_measurement));
    80000208:	6088                	ld	a0,0(s1)
    8000020a:	02000613          	li	a2,32
    8000020e:	00001597          	auipc	a1,0x1
    80000212:	91258593          	addi	a1,a1,-1774 # 80000b20 <trusted_kernel_hash>
    80000216:	9532                	add	a0,a0,a2
    80000218:	2ea000ef          	jal	80000502 <memcpy>

  if (memcmp(sys_info_ptr->observed_kernel_measurement, sys_info_ptr->expected_kernel_measurement, sizeof(sys_info_ptr->expected_kernel_measurement)) != 0)
    8000021c:	6088                	ld	a0,0(s1)
    8000021e:	02000613          	li	a2,32
    80000222:	00c505b3          	add	a1,a0,a2
    80000226:	04050513          	addi	a0,a0,64
    8000022a:	23a000ef          	jal	80000464 <memcmp>
  bool verification = true;
    8000022e:	4785                	li	a5,1
  if (memcmp(sys_info_ptr->observed_kernel_measurement, sys_info_ptr->expected_kernel_measurement, sizeof(sys_info_ptr->expected_kernel_measurement)) != 0)
    80000230:	e11d                	bnez	a0,80000256 <is_secure_boot+0x162>

  if (!verification)
    setup_recovery_kernel();

  return verification;
}
    80000232:	853e                	mv	a0,a5
    80000234:	48813083          	ld	ra,1160(sp)
    80000238:	48013403          	ld	s0,1152(sp)
    8000023c:	47813483          	ld	s1,1144(sp)
    80000240:	47013903          	ld	s2,1136(sp)
    80000244:	45813a83          	ld	s5,1112(sp)
    80000248:	43813c83          	ld	s9,1080(sp)
    8000024c:	43013d03          	ld	s10,1072(sp)
    80000250:	49010113          	addi	sp,sp,1168
    80000254:	8082                	ret
    setup_recovery_kernel();
    80000256:	dd3ff0ef          	jal	80000028 <setup_recovery_kernel>
    verification = false;
    8000025a:	4781                	li	a5,0
    8000025c:	bfd9                	j	80000232 <is_secure_boot+0x13e>

000000008000025e <start>:

// entry.S jumps here in machine mode on stack0.
void start()
{
    8000025e:	b8010113          	addi	sp,sp,-1152
    80000262:	46113c23          	sd	ra,1144(sp)
    80000266:	46813823          	sd	s0,1136(sp)
    8000026a:	48010413          	addi	s0,sp,1152
  /* CSE 536: Define the system information table's location. */
  sys_info_ptr = (struct sys_info *)0x80080000;
    8000026e:	010017b7          	lui	a5,0x1001
    80000272:	079e                	slli	a5,a5,0x7
    80000274:	00009717          	auipc	a4,0x9
    80000278:	a4f73e23          	sd	a5,-1444(a4) # 80008cd0 <sys_info_ptr>
  asm volatile("csrr %0, mhartid"
    8000027c:	f14027f3          	csrr	a5,mhartid

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
  w_tp(id);
    80000280:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0"
    80000282:	823e                	mv	tp,a5
  asm volatile("csrr %0, mstatus"
    80000284:	300027f3          	csrr	a5,mstatus

  // set M Previous Privilege mode to Supervisor, for mret.
  unsigned long x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
    80000288:	7779                	lui	a4,0xffffe
    8000028a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <kernel_elfhdr+0xffffffff7fff5b1f>
    8000028e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000290:	6705                	lui	a4,0x1
    80000292:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000296:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0"
    80000298:	30079073          	csrw	mstatus,a5
  asm volatile("csrw satp, %0"
    8000029c:	4781                	li	a5,0
    8000029e:	18079073          	csrw	satp,a5
  asm volatile("csrw pmpaddr0, %0"
    800002a2:	57fd                	li	a5,-1
    800002a4:	83a9                	srli	a5,a5,0xa
    800002a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0"
    800002aa:	47bd                	li	a5,15
    800002ac:	3a079073          	csrw	pmpcfg0,a5
  w_pmpaddr2(pmpaddr2_value);
  w_pmpcfg0((1 << 16) | (1 << 17) | (1 << 18) | (1 << 19) | (1 << 20) | (1 << 8) | (1 << 9) | (1 << 10) | (1 << 11) | (1 << 12) | (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3));
#endif

  /* CSE 536: Verify if the kernel is untampered for secure boot */
  if (!is_secure_boot())
    800002b0:	e45ff0ef          	jal	800000f4 <is_secure_boot>
    800002b4:	e12d                	bnez	a0,80000316 <start+0xb8>
  //printf("Kernel Entry Address: 0x%lx\n", kernel_entry);
  w_mepc((uint64)kernel_entry);

out:
  /* CSE 536: Provide system information to the kernel. */
  sys_info_ptr->bl_start = (uint64)&_entry;
    800002b6:	00009797          	auipc	a5,0x9
    800002ba:	a1a78793          	addi	a5,a5,-1510 # 80008cd0 <sys_info_ptr>
    800002be:	6398                	ld	a4,0(a5)
    800002c0:	00000697          	auipc	a3,0x0
    800002c4:	d4068693          	addi	a3,a3,-704 # 80000000 <_entry>
    800002c8:	e314                	sd	a3,0(a4)
  sys_info_ptr->bl_end = (uint64)end;
    800002ca:	639c                	ld	a5,0(a5)
    800002cc:	00009717          	auipc	a4,0x9
    800002d0:	a0473703          	ld	a4,-1532(a4) # 80008cd0 <sys_info_ptr>
    800002d4:	e798                	sd	a4,8(a5)

  sys_info_ptr->dr_start = 0x80000000;
    800002d6:	4705                	li	a4,1
    800002d8:	077e                	slli	a4,a4,0x1f
    800002da:	eb98                	sd	a4,16(a5)
  sys_info_ptr->dr_end = PHYSTOP;
    800002dc:	4745                	li	a4,17
    800002de:	076e                	slli	a4,a4,0x1b
    800002e0:	ef98                	sd	a4,24(a5)
  asm volatile("csrw medeleg, %0"
    800002e2:	67c1                	lui	a5,0x10
    800002e4:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800002e6:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0"
    800002ea:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie"
    800002ee:	104027f3          	csrr	a5,sie
  /* CSE 536: Send the observed hash value to the kernel (using sys_info_ptr) */

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
  w_mideleg(0xffff);
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800002f2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0"
    800002f6:	10479073          	csrw	sie,a5

  // return address fix
  uint64 addr = (uint64)panic;
  asm volatile("mv ra, %0"
    800002fa:	00000797          	auipc	a5,0x0
    800002fe:	d2478793          	addi	a5,a5,-732 # 8000001e <panic>
    80000302:	80be                	mv	ra,a5
               :
               : "r"(addr));

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
    80000304:	30200073          	mret
}
    80000308:	47813083          	ld	ra,1144(sp)
    8000030c:	47013403          	ld	s0,1136(sp)
    80000310:	48010113          	addi	sp,sp,1152
    80000314:	8082                	ret
    80000316:	45313c23          	sd	s3,1112(sp)
    8000031a:	45513423          	sd	s5,1096(sp)
   uint64 kernel_load_addr = find_kernel_load_addr(NORMAL);
    8000031e:	4501                	li	a0,0
    80000320:	2d4000ef          	jal	800005f4 <find_kernel_load_addr>
    80000324:	8aaa                	mv	s5,a0
   uint64 kernel_binary_size = find_kernel_size(NORMAL);
    80000326:	4501                	li	a0,0
    80000328:	330000ef          	jal	80000658 <find_kernel_size>
   uint64 num_blocks = kernel_binary_size / FSSIZE;
    8000032c:	00455993          	srli	s3,a0,0x4
    80000330:	5e354737          	lui	a4,0x5e354
    80000334:	f7d70713          	addi	a4,a4,-131 # 5e353f7d <_entry-0x21cac083>
    80000338:	020c57b7          	lui	a5,0x20c5
    8000033c:	9ba78793          	addi	a5,a5,-1606 # 20c49ba <_entry-0x7df3b646>
    80000340:	1782                	slli	a5,a5,0x20
    80000342:	97ba                	add	a5,a5,a4
    80000344:	02f9b9b3          	mulhu	s3,s3,a5
   for (int i = 0; i < num_blocks; i++)
    80000348:	7cf00793          	li	a5,1999
    8000034c:	06a7fa63          	bgeu	a5,a0,800003c0 <start+0x162>
    80000350:	46913423          	sd	s1,1128(sp)
    80000354:	47213023          	sd	s2,1120(sp)
    80000358:	45413823          	sd	s4,1104(sp)
    8000035c:	45613023          	sd	s6,1088(sp)
    80000360:	43713c23          	sd	s7,1080(sp)
    80000364:	43813823          	sd	s8,1072(sp)
    80000368:	797d                	lui	s2,0xfffff
    8000036a:	4481                	li	s1,0
   if (i < 4)
    8000036c:	4a0d                	li	s4,3
   kernel_copy(NORMAL, &b);
    8000036e:	b8840c13          	addi	s8,s0,-1144
   memmove((void *)kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    80000372:	bb040b93          	addi	s7,s0,-1104
    80000376:	40000b13          	li	s6,1024
    8000037a:	a031                	j	80000386 <start+0x128>
   for (int i = 0; i < num_blocks; i++)
    8000037c:	0485                	addi	s1,s1,1
    8000037e:	4009091b          	addiw	s2,s2,1024 # fffffffffffff400 <kernel_elfhdr+0xffffffff7fff6720>
    80000382:	0334f363          	bgeu	s1,s3,800003a8 <start+0x14a>
   if (i < 4)
    80000386:	0004879b          	sext.w	a5,s1
    8000038a:	fefa59e3          	bge	s4,a5,8000037c <start+0x11e>
   b.blockno = i;
    8000038e:	b8942a23          	sw	s1,-1132(s0)
   kernel_copy(NORMAL, &b);
    80000392:	85e2                	mv	a1,s8
    80000394:	4501                	li	a0,0
    80000396:	03c000ef          	jal	800003d2 <kernel_copy>
   memmove((void *)kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    8000039a:	865a                	mv	a2,s6
    8000039c:	85de                	mv	a1,s7
    8000039e:	01590533          	add	a0,s2,s5
    800003a2:	100000ef          	jal	800004a2 <memmove>
    800003a6:	bfd9                	j	8000037c <start+0x11e>
    800003a8:	46813483          	ld	s1,1128(sp)
    800003ac:	46013903          	ld	s2,1120(sp)
    800003b0:	45013a03          	ld	s4,1104(sp)
    800003b4:	44013b03          	ld	s6,1088(sp)
    800003b8:	43813b83          	ld	s7,1080(sp)
    800003bc:	43013c03          	ld	s8,1072(sp)
  asm volatile("csrw mepc, %0"
    800003c0:	4785                	li	a5,1
    800003c2:	07fe                	slli	a5,a5,0x1f
    800003c4:	34179073          	csrw	mepc,a5
    800003c8:	45813983          	ld	s3,1112(sp)
    800003cc:	44813a83          	ld	s5,1096(sp)
}
    800003d0:	b5dd                	j	800002b6 <start+0x58>

00000000800003d2 <kernel_copy>:
#include "layout.h"
#include "buf.h"

/* In-built function to load NORMAL/RECOVERY kernels */
void kernel_copy(enum kernel ktype, struct buf *b)
{
    800003d2:	1101                	addi	sp,sp,-32
    800003d4:	ec06                	sd	ra,24(sp)
    800003d6:	e822                	sd	s0,16(sp)
    800003d8:	e426                	sd	s1,8(sp)
    800003da:	e04a                	sd	s2,0(sp)
    800003dc:	1000                	addi	s0,sp,32
    800003de:	892a                	mv	s2,a0
    800003e0:	84ae                	mv	s1,a1
  if(b->blockno >= FSSIZE)
    800003e2:	45d8                	lw	a4,12(a1)
    800003e4:	7cf00793          	li	a5,1999
    800003e8:	02e7eb63          	bltu	a5,a4,8000041e <kernel_copy+0x4c>
    panic("ramdiskrw: blockno too big");

  uint64 diskaddr = b->blockno * BSIZE;
    800003ec:	44dc                	lw	a5,12(s1)
    800003ee:	00a7979b          	slliw	a5,a5,0xa
    800003f2:	1782                	slli	a5,a5,0x20
    800003f4:	9381                	srli	a5,a5,0x20
  char* addr = 0x0; 
  
  if (ktype == NORMAL)
    800003f6:	02091b63          	bnez	s2,8000042c <kernel_copy+0x5a>
    addr = (char *)RAMDISK + diskaddr;
    800003fa:	02100593          	li	a1,33
    800003fe:	05ea                	slli	a1,a1,0x1a
    80000400:	95be                	add	a1,a1,a5
  else if (ktype == RECOVERY)
    addr = (char *)RECOVERYDISK + diskaddr;

  memmove(b->data, addr, BSIZE);
    80000402:	40000613          	li	a2,1024
    80000406:	02848513          	addi	a0,s1,40
    8000040a:	098000ef          	jal	800004a2 <memmove>
  b->valid = 1;
    8000040e:	4785                	li	a5,1
    80000410:	c09c                	sw	a5,0(s1)
    80000412:	60e2                	ld	ra,24(sp)
    80000414:	6442                	ld	s0,16(sp)
    80000416:	64a2                	ld	s1,8(sp)
    80000418:	6902                	ld	s2,0(sp)
    8000041a:	6105                	addi	sp,sp,32
    8000041c:	8082                	ret
    panic("ramdiskrw: blockno too big");
    8000041e:	00001517          	auipc	a0,0x1
    80000422:	82250513          	addi	a0,a0,-2014 # 80000c40 <erodata>
    80000426:	bf9ff0ef          	jal	8000001e <panic>
    8000042a:	b7c9                	j	800003ec <kernel_copy+0x1a>
  else if (ktype == RECOVERY)
    8000042c:	4705                	li	a4,1
  char* addr = 0x0; 
    8000042e:	4581                	li	a1,0
  else if (ktype == RECOVERY)
    80000430:	fce919e3          	bne	s2,a4,80000402 <kernel_copy+0x30>
    addr = (char *)RECOVERYDISK + diskaddr;
    80000434:	008455b7          	lui	a1,0x845
    80000438:	05a2                	slli	a1,a1,0x8
    8000043a:	95be                	add	a1,a1,a5
    8000043c:	b7d9                	j	80000402 <kernel_copy+0x30>

000000008000043e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000043e:	1141                	addi	sp,sp,-16
    80000440:	e406                	sd	ra,8(sp)
    80000442:	e022                	sd	s0,0(sp)
    80000444:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000446:	ca19                	beqz	a2,8000045c <memset+0x1e>
    80000448:	87aa                	mv	a5,a0
    8000044a:	1602                	slli	a2,a2,0x20
    8000044c:	9201                	srli	a2,a2,0x20
    8000044e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000452:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000456:	0785                	addi	a5,a5,1
    80000458:	fee79de3          	bne	a5,a4,80000452 <memset+0x14>
  }
  return dst;
}
    8000045c:	60a2                	ld	ra,8(sp)
    8000045e:	6402                	ld	s0,0(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000464:	1141                	addi	sp,sp,-16
    80000466:	e406                	sd	ra,8(sp)
    80000468:	e022                	sd	s0,0(sp)
    8000046a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000046c:	ca0d                	beqz	a2,8000049e <memcmp+0x3a>
    8000046e:	fff6069b          	addiw	a3,a2,-1
    80000472:	1682                	slli	a3,a3,0x20
    80000474:	9281                	srli	a3,a3,0x20
    80000476:	0685                	addi	a3,a3,1
    80000478:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000047a:	00054783          	lbu	a5,0(a0)
    8000047e:	0005c703          	lbu	a4,0(a1) # 845000 <_entry-0x7f7bb000>
    80000482:	00e79863          	bne	a5,a4,80000492 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000486:	0505                	addi	a0,a0,1
    80000488:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000048a:	fed518e3          	bne	a0,a3,8000047a <memcmp+0x16>
  }

  return 0;
    8000048e:	4501                	li	a0,0
    80000490:	a019                	j	80000496 <memcmp+0x32>
      return *s1 - *s2;
    80000492:	40e7853b          	subw	a0,a5,a4
}
    80000496:	60a2                	ld	ra,8(sp)
    80000498:	6402                	ld	s0,0(sp)
    8000049a:	0141                	addi	sp,sp,16
    8000049c:	8082                	ret
  return 0;
    8000049e:	4501                	li	a0,0
    800004a0:	bfdd                	j	80000496 <memcmp+0x32>

00000000800004a2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800004a2:	1141                	addi	sp,sp,-16
    800004a4:	e406                	sd	ra,8(sp)
    800004a6:	e022                	sd	s0,0(sp)
    800004a8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800004aa:	c205                	beqz	a2,800004ca <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800004ac:	02a5e363          	bltu	a1,a0,800004d2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800004b0:	1602                	slli	a2,a2,0x20
    800004b2:	9201                	srli	a2,a2,0x20
    800004b4:	00c587b3          	add	a5,a1,a2
{
    800004b8:	872a                	mv	a4,a0
      *d++ = *s++;
    800004ba:	0585                	addi	a1,a1,1
    800004bc:	0705                	addi	a4,a4,1
    800004be:	fff5c683          	lbu	a3,-1(a1)
    800004c2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800004c6:	feb79ae3          	bne	a5,a1,800004ba <memmove+0x18>

  return dst;
}
    800004ca:	60a2                	ld	ra,8(sp)
    800004cc:	6402                	ld	s0,0(sp)
    800004ce:	0141                	addi	sp,sp,16
    800004d0:	8082                	ret
  if(s < d && s + n > d){
    800004d2:	02061693          	slli	a3,a2,0x20
    800004d6:	9281                	srli	a3,a3,0x20
    800004d8:	00d58733          	add	a4,a1,a3
    800004dc:	fce57ae3          	bgeu	a0,a4,800004b0 <memmove+0xe>
    d += n;
    800004e0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800004e2:	fff6079b          	addiw	a5,a2,-1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	fff7c793          	not	a5,a5
    800004ee:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800004f0:	177d                	addi	a4,a4,-1
    800004f2:	16fd                	addi	a3,a3,-1
    800004f4:	00074603          	lbu	a2,0(a4)
    800004f8:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800004fc:	fee79ae3          	bne	a5,a4,800004f0 <memmove+0x4e>
    80000500:	b7e9                	j	800004ca <memmove+0x28>

0000000080000502 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000502:	1141                	addi	sp,sp,-16
    80000504:	e406                	sd	ra,8(sp)
    80000506:	e022                	sd	s0,0(sp)
    80000508:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000050a:	f99ff0ef          	jal	800004a2 <memmove>
}
    8000050e:	60a2                	ld	ra,8(sp)
    80000510:	6402                	ld	s0,0(sp)
    80000512:	0141                	addi	sp,sp,16
    80000514:	8082                	ret

0000000080000516 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000051e:	ce11                	beqz	a2,8000053a <strncmp+0x24>
    80000520:	00054783          	lbu	a5,0(a0)
    80000524:	cf89                	beqz	a5,8000053e <strncmp+0x28>
    80000526:	0005c703          	lbu	a4,0(a1)
    8000052a:	00f71a63          	bne	a4,a5,8000053e <strncmp+0x28>
    n--, p++, q++;
    8000052e:	367d                	addiw	a2,a2,-1
    80000530:	0505                	addi	a0,a0,1
    80000532:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000534:	f675                	bnez	a2,80000520 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000536:	4501                	li	a0,0
    80000538:	a801                	j	80000548 <strncmp+0x32>
    8000053a:	4501                	li	a0,0
    8000053c:	a031                	j	80000548 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000053e:	00054503          	lbu	a0,0(a0)
    80000542:	0005c783          	lbu	a5,0(a1)
    80000546:	9d1d                	subw	a0,a0,a5
}
    80000548:	60a2                	ld	ra,8(sp)
    8000054a:	6402                	ld	s0,0(sp)
    8000054c:	0141                	addi	sp,sp,16
    8000054e:	8082                	ret

0000000080000550 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000550:	1141                	addi	sp,sp,-16
    80000552:	e406                	sd	ra,8(sp)
    80000554:	e022                	sd	s0,0(sp)
    80000556:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000558:	87aa                	mv	a5,a0
    8000055a:	86b2                	mv	a3,a2
    8000055c:	367d                	addiw	a2,a2,-1
    8000055e:	02d05563          	blez	a3,80000588 <strncpy+0x38>
    80000562:	0785                	addi	a5,a5,1
    80000564:	0005c703          	lbu	a4,0(a1)
    80000568:	fee78fa3          	sb	a4,-1(a5)
    8000056c:	0585                	addi	a1,a1,1
    8000056e:	f775                	bnez	a4,8000055a <strncpy+0xa>
    ;
  while(n-- > 0)
    80000570:	873e                	mv	a4,a5
    80000572:	00c05b63          	blez	a2,80000588 <strncpy+0x38>
    80000576:	9fb5                	addw	a5,a5,a3
    80000578:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000057a:	0705                	addi	a4,a4,1
    8000057c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000580:	40e786bb          	subw	a3,a5,a4
    80000584:	fed04be3          	bgtz	a3,8000057a <strncpy+0x2a>
  return os;
}
    80000588:	60a2                	ld	ra,8(sp)
    8000058a:	6402                	ld	s0,0(sp)
    8000058c:	0141                	addi	sp,sp,16
    8000058e:	8082                	ret

0000000080000590 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000590:	1141                	addi	sp,sp,-16
    80000592:	e406                	sd	ra,8(sp)
    80000594:	e022                	sd	s0,0(sp)
    80000596:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000598:	02c05363          	blez	a2,800005be <safestrcpy+0x2e>
    8000059c:	fff6069b          	addiw	a3,a2,-1
    800005a0:	1682                	slli	a3,a3,0x20
    800005a2:	9281                	srli	a3,a3,0x20
    800005a4:	96ae                	add	a3,a3,a1
    800005a6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800005a8:	00d58963          	beq	a1,a3,800005ba <safestrcpy+0x2a>
    800005ac:	0585                	addi	a1,a1,1
    800005ae:	0785                	addi	a5,a5,1
    800005b0:	fff5c703          	lbu	a4,-1(a1)
    800005b4:	fee78fa3          	sb	a4,-1(a5)
    800005b8:	fb65                	bnez	a4,800005a8 <safestrcpy+0x18>
    ;
  *s = 0;
    800005ba:	00078023          	sb	zero,0(a5)
  return os;
}
    800005be:	60a2                	ld	ra,8(sp)
    800005c0:	6402                	ld	s0,0(sp)
    800005c2:	0141                	addi	sp,sp,16
    800005c4:	8082                	ret

00000000800005c6 <strlen>:

int
strlen(const char *s)
{
    800005c6:	1141                	addi	sp,sp,-16
    800005c8:	e406                	sd	ra,8(sp)
    800005ca:	e022                	sd	s0,0(sp)
    800005cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800005ce:	00054783          	lbu	a5,0(a0)
    800005d2:	cf99                	beqz	a5,800005f0 <strlen+0x2a>
    800005d4:	0505                	addi	a0,a0,1
    800005d6:	87aa                	mv	a5,a0
    800005d8:	86be                	mv	a3,a5
    800005da:	0785                	addi	a5,a5,1
    800005dc:	fff7c703          	lbu	a4,-1(a5)
    800005e0:	ff65                	bnez	a4,800005d8 <strlen+0x12>
    800005e2:	40a6853b          	subw	a0,a3,a0
    800005e6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800005e8:	60a2                	ld	ra,8(sp)
    800005ea:	6402                	ld	s0,0(sp)
    800005ec:	0141                	addi	sp,sp,16
    800005ee:	8082                	ret
  for(n = 0; s[n]; n++)
    800005f0:	4501                	li	a0,0
    800005f2:	bfdd                	j	800005e8 <strlen+0x22>

00000000800005f4 <find_kernel_load_addr>:

struct elfhdr *kernel_elfhdr;
struct proghdr *kernel_phdr;

uint64 find_kernel_load_addr(enum kernel ktype)
{
    800005f4:	1141                	addi	sp,sp,-16
    800005f6:	e406                	sd	ra,8(sp)
    800005f8:	e022                	sd	s0,0(sp)
    800005fa:	0800                	addi	s0,sp,16
    /* CSE 536: Get kernel load address from headers */
    if (ktype == NORMAL)
    800005fc:	c911                	beqz	a0,80000610 <find_kernel_load_addr+0x1c>
    800005fe:	87aa                	mv	a5,a0

        kernel_phdr = (struct proghdr *)text_phdr_addr;

        return kernel_phdr->vaddr;
    }
    else if (ktype == RECOVERY)
    80000600:	4705                	li	a4,1

        return kernel_phdr->vaddr;
    }
    else
    {
        return 0;
    80000602:	4501                	li	a0,0
    else if (ktype == RECOVERY)
    80000604:	02e78863          	beq	a5,a4,80000634 <find_kernel_load_addr+0x40>
    }
}
    80000608:	60a2                	ld	ra,8(sp)
    8000060a:	6402                	ld	s0,0(sp)
    8000060c:	0141                	addi	sp,sp,16
    8000060e:	8082                	ret
        kernel_elfhdr = (struct elfhdr *)RAMDISK;
    80000610:	02100713          	li	a4,33
    80000614:	076a                	slli	a4,a4,0x1a
    80000616:	00008797          	auipc	a5,0x8
    8000061a:	6ce7b523          	sd	a4,1738(a5) # 80008ce0 <kernel_elfhdr>
        uint64 text_phdr_addr = RAMDISK + phoff + phsize;
    8000061e:	731c                	ld	a5,32(a4)
    80000620:	97ba                	add	a5,a5,a4
        uint64 phsize = kernel_elfhdr->phentsize;
    80000622:	03675703          	lhu	a4,54(a4)
        uint64 text_phdr_addr = RAMDISK + phoff + phsize;
    80000626:	97ba                	add	a5,a5,a4
        kernel_phdr = (struct proghdr *)text_phdr_addr;
    80000628:	00008717          	auipc	a4,0x8
    8000062c:	6af73823          	sd	a5,1712(a4) # 80008cd8 <kernel_phdr>
        return kernel_phdr->vaddr;
    80000630:	6b88                	ld	a0,16(a5)
    80000632:	bfd9                	j	80000608 <find_kernel_load_addr+0x14>
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    80000634:	00845737          	lui	a4,0x845
    80000638:	0722                	slli	a4,a4,0x8
    8000063a:	00008797          	auipc	a5,0x8
    8000063e:	6ae7b323          	sd	a4,1702(a5) # 80008ce0 <kernel_elfhdr>
        uint64 text_phdr_addr = RECOVERYDISK + phoff + phsize;
    80000642:	731c                	ld	a5,32(a4)
    80000644:	97ba                	add	a5,a5,a4
        uint64 phsize = kernel_elfhdr->phentsize;
    80000646:	03675703          	lhu	a4,54(a4) # 845036 <_entry-0x7f7bafca>
        uint64 text_phdr_addr = RECOVERYDISK + phoff + phsize;
    8000064a:	97ba                	add	a5,a5,a4
        kernel_phdr = (struct proghdr *)text_phdr_addr;
    8000064c:	00008717          	auipc	a4,0x8
    80000650:	68f73623          	sd	a5,1676(a4) # 80008cd8 <kernel_phdr>
        return kernel_phdr->vaddr;
    80000654:	6b88                	ld	a0,16(a5)
    80000656:	bf4d                	j	80000608 <find_kernel_load_addr+0x14>

0000000080000658 <find_kernel_size>:

uint64 find_kernel_size(enum kernel ktype)
{
    80000658:	1141                	addi	sp,sp,-16
    8000065a:	e406                	sd	ra,8(sp)
    8000065c:	e022                	sd	s0,0(sp)
    8000065e:	0800                	addi	s0,sp,16
    /* CSE 536: Get kernel binary size from headers */
    if (ktype == NORMAL)
    80000660:	e905                	bnez	a0,80000690 <find_kernel_size+0x38>
    {
        kernel_elfhdr = (struct elfhdr *)RAMDISK;
    80000662:	02100793          	li	a5,33
    80000666:	07ea                	slli	a5,a5,0x1a
    80000668:	00008717          	auipc	a4,0x8
    8000066c:	66f73c23          	sd	a5,1656(a4) # 80008ce0 <kernel_elfhdr>
    }
    else if (ktype == RECOVERY)
    {
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    }
    uint64 start_of_section_headers = kernel_elfhdr->shoff;
    80000670:	00008717          	auipc	a4,0x8
    80000674:	67073703          	ld	a4,1648(a4) # 80008ce0 <kernel_elfhdr>
    uint64 size_of_section_headers = kernel_elfhdr->shentsize * kernel_elfhdr->shnum;
    80000678:	03a75783          	lhu	a5,58(a4)
    8000067c:	03c75683          	lhu	a3,60(a4)
    80000680:	02d787bb          	mulw	a5,a5,a3
    uint64 total_size = start_of_section_headers + size_of_section_headers;
    80000684:	7708                	ld	a0,40(a4)

    return total_size;
}
    80000686:	953e                	add	a0,a0,a5
    80000688:	60a2                	ld	ra,8(sp)
    8000068a:	6402                	ld	s0,0(sp)
    8000068c:	0141                	addi	sp,sp,16
    8000068e:	8082                	ret
    else if (ktype == RECOVERY)
    80000690:	4785                	li	a5,1
    80000692:	fcf51fe3          	bne	a0,a5,80000670 <find_kernel_size+0x18>
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    80000696:	008457b7          	lui	a5,0x845
    8000069a:	07a2                	slli	a5,a5,0x8
    8000069c:	00008717          	auipc	a4,0x8
    800006a0:	64f73223          	sd	a5,1604(a4) # 80008ce0 <kernel_elfhdr>
    800006a4:	b7f1                	j	80000670 <find_kernel_size+0x18>

00000000800006a6 <find_kernel_entry_addr>:

uint64 find_kernel_entry_addr(enum kernel ktype)
{
    800006a6:	1141                	addi	sp,sp,-16
    800006a8:	e406                	sd	ra,8(sp)
    800006aa:	e022                	sd	s0,0(sp)
    800006ac:	0800                	addi	s0,sp,16
    /* CSE 536: Get kernel entry point from headers */
    if (ktype == NORMAL)
    800006ae:	e10d                	bnez	a0,800006d0 <find_kernel_entry_addr+0x2a>
    {
        kernel_elfhdr = (struct elfhdr *)RAMDISK;
    800006b0:	02100793          	li	a5,33
    800006b4:	07ea                	slli	a5,a5,0x1a
    800006b6:	00008717          	auipc	a4,0x8
    800006ba:	62f73523          	sd	a5,1578(a4) # 80008ce0 <kernel_elfhdr>
    {
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    }
    // return entry point
    return kernel_elfhdr->entry;
}
    800006be:	00008797          	auipc	a5,0x8
    800006c2:	6227b783          	ld	a5,1570(a5) # 80008ce0 <kernel_elfhdr>
    800006c6:	6f88                	ld	a0,24(a5)
    800006c8:	60a2                	ld	ra,8(sp)
    800006ca:	6402                	ld	s0,0(sp)
    800006cc:	0141                	addi	sp,sp,16
    800006ce:	8082                	ret
    else if (ktype == RECOVERY)
    800006d0:	4785                	li	a5,1
    800006d2:	fef516e3          	bne	a0,a5,800006be <find_kernel_entry_addr+0x18>
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    800006d6:	008457b7          	lui	a5,0x845
    800006da:	07a2                	slli	a5,a5,0x8
    800006dc:	00008717          	auipc	a4,0x8
    800006e0:	60f73223          	sd	a5,1540(a4) # 80008ce0 <kernel_elfhdr>
    800006e4:	bfe9                	j	800006be <find_kernel_entry_addr+0x18>

00000000800006e6 <sha256_transform>:
	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

/*********************** FUNCTION DEFINITIONS ***********************/
void sha256_transform(SHA256_CTX *ctx, const BYTE data[])
{
    800006e6:	714d                	addi	sp,sp,-336
    800006e8:	e686                	sd	ra,328(sp)
    800006ea:	e2a2                	sd	s0,320(sp)
    800006ec:	fe26                	sd	s1,312(sp)
    800006ee:	fa4a                	sd	s2,304(sp)
    800006f0:	f64e                	sd	s3,296(sp)
    800006f2:	f252                	sd	s4,288(sp)
    800006f4:	ee56                	sd	s5,280(sp)
    800006f6:	ea5a                	sd	s6,272(sp)
    800006f8:	e65e                	sd	s7,264(sp)
    800006fa:	e262                	sd	s8,256(sp)
    800006fc:	0a80                	addi	s0,sp,336
	WORD a, b, c, d, e, f, g, h, i, j, t1, t2, m[64];

	for (i = 0, j = 0; i < 16; ++i, j += 4)
    800006fe:	eb040313          	addi	t1,s0,-336
    80000702:	ef040613          	addi	a2,s0,-272
{
    80000706:	869a                	mv	a3,t1
		m[i] = (data[j] << 24) | (data[j + 1] << 16) | (data[j + 2] << 8) | (data[j + 3]);
    80000708:	0005c783          	lbu	a5,0(a1)
    8000070c:	0187979b          	slliw	a5,a5,0x18
    80000710:	0015c703          	lbu	a4,1(a1)
    80000714:	0107171b          	slliw	a4,a4,0x10
    80000718:	8fd9                	or	a5,a5,a4
    8000071a:	0035c703          	lbu	a4,3(a1)
    8000071e:	8fd9                	or	a5,a5,a4
    80000720:	0025c703          	lbu	a4,2(a1)
    80000724:	0087171b          	slliw	a4,a4,0x8
    80000728:	8fd9                	or	a5,a5,a4
    8000072a:	c29c                	sw	a5,0(a3)
	for (i = 0, j = 0; i < 16; ++i, j += 4)
    8000072c:	0591                	addi	a1,a1,4
    8000072e:	0691                	addi	a3,a3,4
    80000730:	fcc69ce3          	bne	a3,a2,80000708 <sha256_transform+0x22>
	for ( ; i < 64; ++i)
    80000734:	0c030893          	addi	a7,t1,192 # 10c0 <_entry-0x7fffef40>
	for (i = 0, j = 0; i < 16; ++i, j += 4)
    80000738:	869a                	mv	a3,t1
		m[i] = SIG1(m[i - 2]) + m[i - 7] + SIG0(m[i - 15]) + m[i - 16];
    8000073a:	5e98                	lw	a4,56(a3)
    8000073c:	42dc                	lw	a5,4(a3)
    8000073e:	0117561b          	srliw	a2,a4,0x11
    80000742:	00f7159b          	slliw	a1,a4,0xf
    80000746:	8e4d                	or	a2,a2,a1
    80000748:	0137559b          	srliw	a1,a4,0x13
    8000074c:	00d7181b          	slliw	a6,a4,0xd
    80000750:	0105e5b3          	or	a1,a1,a6
    80000754:	8e2d                	xor	a2,a2,a1
    80000756:	00a7571b          	srliw	a4,a4,0xa
    8000075a:	8f31                	xor	a4,a4,a2
    8000075c:	52cc                	lw	a1,36(a3)
    8000075e:	4290                	lw	a2,0(a3)
    80000760:	9e2d                	addw	a2,a2,a1
    80000762:	9f31                	addw	a4,a4,a2
    80000764:	0077d61b          	srliw	a2,a5,0x7
    80000768:	0197959b          	slliw	a1,a5,0x19
    8000076c:	8e4d                	or	a2,a2,a1
    8000076e:	0127d59b          	srliw	a1,a5,0x12
    80000772:	00e7981b          	slliw	a6,a5,0xe
    80000776:	0105e5b3          	or	a1,a1,a6
    8000077a:	8e2d                	xor	a2,a2,a1
    8000077c:	0037d79b          	srliw	a5,a5,0x3
    80000780:	8fb1                	xor	a5,a5,a2
    80000782:	9fb9                	addw	a5,a5,a4
    80000784:	c2bc                	sw	a5,64(a3)
	for ( ; i < 64; ++i)
    80000786:	0691                	addi	a3,a3,4
    80000788:	fad899e3          	bne	a7,a3,8000073a <sha256_transform+0x54>

	a = ctx->state[0];
    8000078c:	05052b03          	lw	s6,80(a0)
	b = ctx->state[1];
    80000790:	05452a83          	lw	s5,84(a0)
	c = ctx->state[2];
    80000794:	05852a03          	lw	s4,88(a0)
	d = ctx->state[3];
    80000798:	05c52983          	lw	s3,92(a0)
	e = ctx->state[4];
    8000079c:	06052903          	lw	s2,96(a0)
	f = ctx->state[5];
    800007a0:	5164                	lw	s1,100(a0)
	g = ctx->state[6];
    800007a2:	06852383          	lw	t2,104(a0)
	h = ctx->state[7];
    800007a6:	06c52283          	lw	t0,108(a0)

	for (i = 0; i < 64; ++i) {
    800007aa:	00000817          	auipc	a6,0x0
    800007ae:	39680813          	addi	a6,a6,918 # 80000b40 <k>
    800007b2:	00000f97          	auipc	t6,0x0
    800007b6:	48ef8f93          	addi	t6,t6,1166 # 80000c40 <erodata>
	h = ctx->state[7];
    800007ba:	8b96                	mv	s7,t0
	g = ctx->state[6];
    800007bc:	8e1e                	mv	t3,t2
	f = ctx->state[5];
    800007be:	8ea6                	mv	t4,s1
	e = ctx->state[4];
    800007c0:	86ca                	mv	a3,s2
	d = ctx->state[3];
    800007c2:	8f4e                	mv	t5,s3
	c = ctx->state[2];
    800007c4:	85d2                	mv	a1,s4
	b = ctx->state[1];
    800007c6:	88d6                	mv	a7,s5
	a = ctx->state[0];
    800007c8:	865a                	mv	a2,s6
    800007ca:	a039                	j	800007d8 <sha256_transform+0xf2>
    800007cc:	8e76                	mv	t3,t4
    800007ce:	8eb6                	mv	t4,a3
    800007d0:	86e2                	mv	a3,s8
    800007d2:	85c6                	mv	a1,a7
    800007d4:	88b2                	mv	a7,a2
    800007d6:	863e                	mv	a2,a5
		t1 = h + EP1(e) + CH(e,f,g) + k[i] + m[i];
    800007d8:	0066d71b          	srliw	a4,a3,0x6
    800007dc:	01a6979b          	slliw	a5,a3,0x1a
    800007e0:	8f5d                	or	a4,a4,a5
    800007e2:	00b6d79b          	srliw	a5,a3,0xb
    800007e6:	01569c1b          	slliw	s8,a3,0x15
    800007ea:	0187e7b3          	or	a5,a5,s8
    800007ee:	8f3d                	xor	a4,a4,a5
    800007f0:	0196d79b          	srliw	a5,a3,0x19
    800007f4:	00769c1b          	slliw	s8,a3,0x7
    800007f8:	0187e7b3          	or	a5,a5,s8
    800007fc:	8f3d                	xor	a4,a4,a5
    800007fe:	00082c03          	lw	s8,0(a6)
    80000802:	00032783          	lw	a5,0(t1)
    80000806:	018787bb          	addw	a5,a5,s8
    8000080a:	9fb9                	addw	a5,a5,a4
    8000080c:	fff6c713          	not	a4,a3
    80000810:	01c77733          	and	a4,a4,t3
    80000814:	01d6fc33          	and	s8,a3,t4
    80000818:	01874733          	xor	a4,a4,s8
    8000081c:	9fb9                	addw	a5,a5,a4
    8000081e:	017787bb          	addw	a5,a5,s7
		t2 = EP0(a) + MAJ(a,b,c);
    80000822:	0026571b          	srliw	a4,a2,0x2
    80000826:	01e61b9b          	slliw	s7,a2,0x1e
    8000082a:	01776733          	or	a4,a4,s7
    8000082e:	00d65b9b          	srliw	s7,a2,0xd
    80000832:	01361c1b          	slliw	s8,a2,0x13
    80000836:	018bebb3          	or	s7,s7,s8
    8000083a:	01774733          	xor	a4,a4,s7
    8000083e:	01665b9b          	srliw	s7,a2,0x16
    80000842:	00a61c1b          	slliw	s8,a2,0xa
    80000846:	018bebb3          	or	s7,s7,s8
    8000084a:	01774733          	xor	a4,a4,s7
    8000084e:	00b8cbb3          	xor	s7,a7,a1
    80000852:	01767bb3          	and	s7,a2,s7
    80000856:	00b8fc33          	and	s8,a7,a1
    8000085a:	018bcbb3          	xor	s7,s7,s8
    8000085e:	0177073b          	addw	a4,a4,s7
		h = g;
		g = f;
		f = e;
		e = d + t1;
    80000862:	01e78c3b          	addw	s8,a5,t5
		d = c;
		c = b;
		b = a;
		a = t1 + t2;
    80000866:	9fb9                	addw	a5,a5,a4
	for (i = 0; i < 64; ++i) {
    80000868:	0811                	addi	a6,a6,4
    8000086a:	0311                	addi	t1,t1,4
    8000086c:	8f2e                	mv	t5,a1
    8000086e:	8bf2                	mv	s7,t3
    80000870:	f5f81ee3          	bne	a6,t6,800007cc <sha256_transform+0xe6>
	}

	ctx->state[0] += a;
    80000874:	00fb0b3b          	addw	s6,s6,a5
    80000878:	05652823          	sw	s6,80(a0)
	ctx->state[1] += b;
    8000087c:	00ca8abb          	addw	s5,s5,a2
    80000880:	05552a23          	sw	s5,84(a0)
	ctx->state[2] += c;
    80000884:	011a0a3b          	addw	s4,s4,a7
    80000888:	05452c23          	sw	s4,88(a0)
	ctx->state[3] += d;
    8000088c:	00b989bb          	addw	s3,s3,a1
    80000890:	05352e23          	sw	s3,92(a0)
	ctx->state[4] += e;
    80000894:	0189093b          	addw	s2,s2,s8
    80000898:	07252023          	sw	s2,96(a0)
	ctx->state[5] += f;
    8000089c:	9cb5                	addw	s1,s1,a3
    8000089e:	d164                	sw	s1,100(a0)
	ctx->state[6] += g;
    800008a0:	01d383bb          	addw	t2,t2,t4
    800008a4:	06752423          	sw	t2,104(a0)
	ctx->state[7] += h;
    800008a8:	01c282bb          	addw	t0,t0,t3
    800008ac:	06552623          	sw	t0,108(a0)
}
    800008b0:	60b6                	ld	ra,328(sp)
    800008b2:	6416                	ld	s0,320(sp)
    800008b4:	74f2                	ld	s1,312(sp)
    800008b6:	7952                	ld	s2,304(sp)
    800008b8:	79b2                	ld	s3,296(sp)
    800008ba:	7a12                	ld	s4,288(sp)
    800008bc:	6af2                	ld	s5,280(sp)
    800008be:	6b52                	ld	s6,272(sp)
    800008c0:	6bb2                	ld	s7,264(sp)
    800008c2:	6c12                	ld	s8,256(sp)
    800008c4:	6171                	addi	sp,sp,336
    800008c6:	8082                	ret

00000000800008c8 <sha256_init>:

void sha256_init(SHA256_CTX *ctx)
{
    800008c8:	1141                	addi	sp,sp,-16
    800008ca:	e406                	sd	ra,8(sp)
    800008cc:	e022                	sd	s0,0(sp)
    800008ce:	0800                	addi	s0,sp,16
	ctx->datalen = 0;
    800008d0:	04052023          	sw	zero,64(a0)
	ctx->bitlen = 0;
    800008d4:	04053423          	sd	zero,72(a0)
	ctx->state[0] = 0x6a09e667;
    800008d8:	6a09e7b7          	lui	a5,0x6a09e
    800008dc:	66778793          	addi	a5,a5,1639 # 6a09e667 <_entry-0x15f61999>
    800008e0:	c93c                	sw	a5,80(a0)
	ctx->state[1] = 0xbb67ae85;
    800008e2:	bb67b7b7          	lui	a5,0xbb67b
    800008e6:	e8578793          	addi	a5,a5,-379 # ffffffffbb67ae85 <kernel_elfhdr+0xffffffff3b6721a5>
    800008ea:	c97c                	sw	a5,84(a0)
	ctx->state[2] = 0x3c6ef372;
    800008ec:	3c6ef7b7          	lui	a5,0x3c6ef
    800008f0:	37278793          	addi	a5,a5,882 # 3c6ef372 <_entry-0x43910c8e>
    800008f4:	cd3c                	sw	a5,88(a0)
	ctx->state[3] = 0xa54ff53a;
    800008f6:	a54ff7b7          	lui	a5,0xa54ff
    800008fa:	53a78793          	addi	a5,a5,1338 # ffffffffa54ff53a <kernel_elfhdr+0xffffffff254f685a>
    800008fe:	cd7c                	sw	a5,92(a0)
	ctx->state[4] = 0x510e527f;
    80000900:	510e57b7          	lui	a5,0x510e5
    80000904:	27f78793          	addi	a5,a5,639 # 510e527f <_entry-0x2ef1ad81>
    80000908:	d13c                	sw	a5,96(a0)
	ctx->state[5] = 0x9b05688c;
    8000090a:	9b0577b7          	lui	a5,0x9b057
    8000090e:	88c78793          	addi	a5,a5,-1908 # ffffffff9b05688c <kernel_elfhdr+0xffffffff1b04dbac>
    80000912:	d17c                	sw	a5,100(a0)
	ctx->state[6] = 0x1f83d9ab;
    80000914:	1f83e7b7          	lui	a5,0x1f83e
    80000918:	9ab78793          	addi	a5,a5,-1621 # 1f83d9ab <_entry-0x607c2655>
    8000091c:	d53c                	sw	a5,104(a0)
	ctx->state[7] = 0x5be0cd19;
    8000091e:	5be0d7b7          	lui	a5,0x5be0d
    80000922:	d1978793          	addi	a5,a5,-743 # 5be0cd19 <_entry-0x241f32e7>
    80000926:	d57c                	sw	a5,108(a0)
}
    80000928:	60a2                	ld	ra,8(sp)
    8000092a:	6402                	ld	s0,0(sp)
    8000092c:	0141                	addi	sp,sp,16
    8000092e:	8082                	ret

0000000080000930 <sha256_update>:

void sha256_update(SHA256_CTX *ctx, const BYTE data[], size_t len)
{
	WORD i;

	for (i = 0; i < len; ++i) {
    80000930:	ce25                	beqz	a2,800009a8 <sha256_update+0x78>
{
    80000932:	7139                	addi	sp,sp,-64
    80000934:	fc06                	sd	ra,56(sp)
    80000936:	f822                	sd	s0,48(sp)
    80000938:	f426                	sd	s1,40(sp)
    8000093a:	f04a                	sd	s2,32(sp)
    8000093c:	ec4e                	sd	s3,24(sp)
    8000093e:	e852                	sd	s4,16(sp)
    80000940:	e456                	sd	s5,8(sp)
    80000942:	0080                	addi	s0,sp,64
    80000944:	84aa                	mv	s1,a0
    80000946:	8a2e                	mv	s4,a1
    80000948:	89b2                	mv	s3,a2
	for (i = 0; i < len; ++i) {
    8000094a:	4901                	li	s2,0
    8000094c:	4781                	li	a5,0
		ctx->data[ctx->datalen] = data[i];
		ctx->datalen++;
		if (ctx->datalen == 64) {
    8000094e:	04000a93          	li	s5,64
    80000952:	a801                	j	80000962 <sha256_update+0x32>
	for (i = 0; i < len; ++i) {
    80000954:	0019079b          	addiw	a5,s2,1
    80000958:	893e                	mv	s2,a5
    8000095a:	1782                	slli	a5,a5,0x20
    8000095c:	9381                	srli	a5,a5,0x20
    8000095e:	0337fc63          	bgeu	a5,s3,80000996 <sha256_update+0x66>
		ctx->data[ctx->datalen] = data[i];
    80000962:	40b8                	lw	a4,64(s1)
    80000964:	97d2                	add	a5,a5,s4
    80000966:	0007c683          	lbu	a3,0(a5)
    8000096a:	02071793          	slli	a5,a4,0x20
    8000096e:	9381                	srli	a5,a5,0x20
    80000970:	97a6                	add	a5,a5,s1
    80000972:	00d78023          	sb	a3,0(a5)
		ctx->datalen++;
    80000976:	0017079b          	addiw	a5,a4,1
    8000097a:	c0bc                	sw	a5,64(s1)
		if (ctx->datalen == 64) {
    8000097c:	fd579ce3          	bne	a5,s5,80000954 <sha256_update+0x24>
			sha256_transform(ctx, ctx->data);
    80000980:	85a6                	mv	a1,s1
    80000982:	8526                	mv	a0,s1
    80000984:	d63ff0ef          	jal	800006e6 <sha256_transform>
			ctx->bitlen += 512;
    80000988:	64bc                	ld	a5,72(s1)
    8000098a:	20078793          	addi	a5,a5,512
    8000098e:	e4bc                	sd	a5,72(s1)
			ctx->datalen = 0;
    80000990:	0404a023          	sw	zero,64(s1)
    80000994:	b7c1                	j	80000954 <sha256_update+0x24>
		}
	}
}
    80000996:	70e2                	ld	ra,56(sp)
    80000998:	7442                	ld	s0,48(sp)
    8000099a:	74a2                	ld	s1,40(sp)
    8000099c:	7902                	ld	s2,32(sp)
    8000099e:	69e2                	ld	s3,24(sp)
    800009a0:	6a42                	ld	s4,16(sp)
    800009a2:	6aa2                	ld	s5,8(sp)
    800009a4:	6121                	addi	sp,sp,64
    800009a6:	8082                	ret
    800009a8:	8082                	ret

00000000800009aa <sha256_final>:

void sha256_final(SHA256_CTX *ctx, BYTE hash[])
{
    800009aa:	1101                	addi	sp,sp,-32
    800009ac:	ec06                	sd	ra,24(sp)
    800009ae:	e822                	sd	s0,16(sp)
    800009b0:	e426                	sd	s1,8(sp)
    800009b2:	e04a                	sd	s2,0(sp)
    800009b4:	1000                	addi	s0,sp,32
    800009b6:	84aa                	mv	s1,a0
    800009b8:	892e                	mv	s2,a1
	WORD i;

	i = ctx->datalen;
    800009ba:	4134                	lw	a3,64(a0)

	// Pad whatever data is left in the buffer.
	if (ctx->datalen < 56) {
    800009bc:	03700793          	li	a5,55
    800009c0:	04d7e563          	bltu	a5,a3,80000a0a <sha256_final+0x60>
		ctx->data[i++] = 0x80;
    800009c4:	0016879b          	addiw	a5,a3,1
    800009c8:	02069713          	slli	a4,a3,0x20
    800009cc:	9301                	srli	a4,a4,0x20
    800009ce:	972a                	add	a4,a4,a0
    800009d0:	f8000613          	li	a2,-128
    800009d4:	00c70023          	sb	a2,0(a4)
		while (i < 56)
    800009d8:	03700713          	li	a4,55
    800009dc:	08f76363          	bltu	a4,a5,80000a62 <sha256_final+0xb8>
    800009e0:	02079613          	slli	a2,a5,0x20
    800009e4:	9201                	srli	a2,a2,0x20
    800009e6:	00c507b3          	add	a5,a0,a2
    800009ea:	00150713          	addi	a4,a0,1
    800009ee:	9732                	add	a4,a4,a2
    800009f0:	03600613          	li	a2,54
    800009f4:	40d606bb          	subw	a3,a2,a3
    800009f8:	1682                	slli	a3,a3,0x20
    800009fa:	9281                	srli	a3,a3,0x20
    800009fc:	9736                	add	a4,a4,a3
			ctx->data[i++] = 0x00;
    800009fe:	00078023          	sb	zero,0(a5)
		while (i < 56)
    80000a02:	0785                	addi	a5,a5,1
    80000a04:	fee79de3          	bne	a5,a4,800009fe <sha256_final+0x54>
    80000a08:	a8a9                	j	80000a62 <sha256_final+0xb8>
	}
	else {
		ctx->data[i++] = 0x80;
    80000a0a:	0016879b          	addiw	a5,a3,1
    80000a0e:	02069713          	slli	a4,a3,0x20
    80000a12:	9301                	srli	a4,a4,0x20
    80000a14:	972a                	add	a4,a4,a0
    80000a16:	f8000613          	li	a2,-128
    80000a1a:	00c70023          	sb	a2,0(a4)
		while (i < 64)
    80000a1e:	03f00713          	li	a4,63
    80000a22:	02f76663          	bltu	a4,a5,80000a4e <sha256_final+0xa4>
    80000a26:	02079613          	slli	a2,a5,0x20
    80000a2a:	9201                	srli	a2,a2,0x20
    80000a2c:	00c507b3          	add	a5,a0,a2
    80000a30:	00150713          	addi	a4,a0,1
    80000a34:	9732                	add	a4,a4,a2
    80000a36:	03e00613          	li	a2,62
    80000a3a:	40d606bb          	subw	a3,a2,a3
    80000a3e:	1682                	slli	a3,a3,0x20
    80000a40:	9281                	srli	a3,a3,0x20
    80000a42:	9736                	add	a4,a4,a3
			ctx->data[i++] = 0x00;
    80000a44:	00078023          	sb	zero,0(a5)
		while (i < 64)
    80000a48:	0785                	addi	a5,a5,1
    80000a4a:	fee79de3          	bne	a5,a4,80000a44 <sha256_final+0x9a>
		sha256_transform(ctx, ctx->data);
    80000a4e:	85a6                	mv	a1,s1
    80000a50:	8526                	mv	a0,s1
    80000a52:	c95ff0ef          	jal	800006e6 <sha256_transform>
		memset(ctx->data, 0, 56);
    80000a56:	03800613          	li	a2,56
    80000a5a:	4581                	li	a1,0
    80000a5c:	8526                	mv	a0,s1
    80000a5e:	9e1ff0ef          	jal	8000043e <memset>
	}

	// Append to the padding the total message's length in bits and transform.
	ctx->bitlen += ctx->datalen * 8;
    80000a62:	40bc                	lw	a5,64(s1)
    80000a64:	0037979b          	slliw	a5,a5,0x3
    80000a68:	1782                	slli	a5,a5,0x20
    80000a6a:	9381                	srli	a5,a5,0x20
    80000a6c:	64b8                	ld	a4,72(s1)
    80000a6e:	97ba                	add	a5,a5,a4
    80000a70:	e4bc                	sd	a5,72(s1)
	ctx->data[63] = ctx->bitlen;
    80000a72:	02f48fa3          	sb	a5,63(s1)
	ctx->data[62] = ctx->bitlen >> 8;
    80000a76:	0087d713          	srli	a4,a5,0x8
    80000a7a:	02e48f23          	sb	a4,62(s1)
	ctx->data[61] = ctx->bitlen >> 16;
    80000a7e:	0107d713          	srli	a4,a5,0x10
    80000a82:	02e48ea3          	sb	a4,61(s1)
	ctx->data[60] = ctx->bitlen >> 24;
    80000a86:	0187d713          	srli	a4,a5,0x18
    80000a8a:	02e48e23          	sb	a4,60(s1)
	ctx->data[59] = ctx->bitlen >> 32;
    80000a8e:	0207d713          	srli	a4,a5,0x20
    80000a92:	02e48da3          	sb	a4,59(s1)
	ctx->data[58] = ctx->bitlen >> 40;
    80000a96:	0287d713          	srli	a4,a5,0x28
    80000a9a:	02e48d23          	sb	a4,58(s1)
	ctx->data[57] = ctx->bitlen >> 48;
    80000a9e:	0307d713          	srli	a4,a5,0x30
    80000aa2:	02e48ca3          	sb	a4,57(s1)
	ctx->data[56] = ctx->bitlen >> 56;
    80000aa6:	93e1                	srli	a5,a5,0x38
    80000aa8:	02f48c23          	sb	a5,56(s1)
	sha256_transform(ctx, ctx->data);
    80000aac:	85a6                	mv	a1,s1
    80000aae:	8526                	mv	a0,s1
    80000ab0:	c37ff0ef          	jal	800006e6 <sha256_transform>

	// Since this implementation uses little endian byte ordering and SHA uses big endian,
	// reverse all the bytes when copying the final state to the output hash.
	for (i = 0; i < 4; ++i) {
    80000ab4:	85ca                	mv	a1,s2
	sha256_transform(ctx, ctx->data);
    80000ab6:	47e1                	li	a5,24
	for (i = 0; i < 4; ++i) {
    80000ab8:	56e1                	li	a3,-8
		hash[i]      = (ctx->state[0] >> (24 - i * 8)) & 0x000000ff;
    80000aba:	48b8                	lw	a4,80(s1)
    80000abc:	00f7573b          	srlw	a4,a4,a5
    80000ac0:	00e58023          	sb	a4,0(a1)
		hash[i + 4]  = (ctx->state[1] >> (24 - i * 8)) & 0x000000ff;
    80000ac4:	48f8                	lw	a4,84(s1)
    80000ac6:	00f7573b          	srlw	a4,a4,a5
    80000aca:	00e58223          	sb	a4,4(a1)
		hash[i + 8]  = (ctx->state[2] >> (24 - i * 8)) & 0x000000ff;
    80000ace:	4cb8                	lw	a4,88(s1)
    80000ad0:	00f7573b          	srlw	a4,a4,a5
    80000ad4:	00e58423          	sb	a4,8(a1)
		hash[i + 12] = (ctx->state[3] >> (24 - i * 8)) & 0x000000ff;
    80000ad8:	4cf8                	lw	a4,92(s1)
    80000ada:	00f7573b          	srlw	a4,a4,a5
    80000ade:	00e58623          	sb	a4,12(a1)
		hash[i + 16] = (ctx->state[4] >> (24 - i * 8)) & 0x000000ff;
    80000ae2:	50b8                	lw	a4,96(s1)
    80000ae4:	00f7573b          	srlw	a4,a4,a5
    80000ae8:	00e58823          	sb	a4,16(a1)
		hash[i + 20] = (ctx->state[5] >> (24 - i * 8)) & 0x000000ff;
    80000aec:	50f8                	lw	a4,100(s1)
    80000aee:	00f7573b          	srlw	a4,a4,a5
    80000af2:	00e58a23          	sb	a4,20(a1)
		hash[i + 24] = (ctx->state[6] >> (24 - i * 8)) & 0x000000ff;
    80000af6:	54b8                	lw	a4,104(s1)
    80000af8:	00f7573b          	srlw	a4,a4,a5
    80000afc:	00e58c23          	sb	a4,24(a1)
		hash[i + 28] = (ctx->state[7] >> (24 - i * 8)) & 0x000000ff;
    80000b00:	54f8                	lw	a4,108(s1)
    80000b02:	00f7573b          	srlw	a4,a4,a5
    80000b06:	00e58e23          	sb	a4,28(a1)
	for (i = 0; i < 4; ++i) {
    80000b0a:	37e1                	addiw	a5,a5,-8
    80000b0c:	0585                	addi	a1,a1,1
    80000b0e:	fad796e3          	bne	a5,a3,80000aba <sha256_final+0x110>
	}
    80000b12:	60e2                	ld	ra,24(sp)
    80000b14:	6442                	ld	s0,16(sp)
    80000b16:	64a2                	ld	s1,8(sp)
    80000b18:	6902                	ld	s2,0(sp)
    80000b1a:	6105                	addi	sp,sp,32
    80000b1c:	8082                	ret
