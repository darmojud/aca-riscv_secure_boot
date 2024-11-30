
bootloader/bootloader:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	f14022f3          	csrr	t0,mhartid
    80000004:	6305                	lui	t1,0x1
    80000006:	026282b3          	mul	t0,t0,t1
    8000000a:	929a                	add	t0,t0,t1
    8000000c:	00001397          	auipc	t2,0x1
    80000010:	c8438393          	addi	t2,t2,-892 # 80000c90 <bl_stack>
    80000014:	9396                	add	t2,t2,t0
    80000016:	811e                	mv	sp,t2
    80000018:	23a000ef          	jal	80000252 <start>

000000008000001c <panic>:
};
struct sys_info *sys_info_ptr;

extern void _entry(void);
void panic(char *s)
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
  for (;;)
    80000024:	a001                	j	80000024 <panic+0x8>

0000000080000026 <setup_recovery_kernel>:
}

/* CSE 536: Boot into the RECOVERY kernel instead of NORMAL kernel
 * when hash verification fails. */
void setup_recovery_kernel(void)
{
    80000026:	b7010113          	addi	sp,sp,-1168
    8000002a:	48113423          	sd	ra,1160(sp)
    8000002e:	48813023          	sd	s0,1152(sp)
    80000032:	45513c23          	sd	s5,1112(sp)
    80000036:	49010413          	addi	s0,sp,1168
  uint64 rec_kernel_load_addr = find_kernel_load_addr(RECOVERY);
    8000003a:	4505                	li	a0,1
    8000003c:	570000ef          	jal	800005ac <find_kernel_load_addr>
    80000040:	8aaa                	mv	s5,a0
  uint64 rec_kernel_binary_size = find_kernel_size(RECOVERY);
    80000042:	4505                	li	a0,1
    80000044:	5cc000ef          	jal	80000610 <find_kernel_size>

  struct buf b;
  uint64 rec_num_blocks = rec_kernel_binary_size / BSIZE;
  for (int i = 0; i < rec_num_blocks; i++)
    80000048:	3ff00793          	li	a5,1023
    8000004c:	08a7f563          	bgeu	a5,a0,800000d6 <setup_recovery_kernel+0xb0>
    80000050:	46913c23          	sd	s1,1144(sp)
    80000054:	47213823          	sd	s2,1136(sp)
    80000058:	47313423          	sd	s3,1128(sp)
    8000005c:	47413023          	sd	s4,1120(sp)
    80000060:	45613823          	sd	s6,1104(sp)
    80000064:	45713423          	sd	s7,1096(sp)
    80000068:	45813023          	sd	s8,1088(sp)
    8000006c:	43913c23          	sd	s9,1080(sp)
    80000070:	00a55993          	srli	s3,a0,0xa
    80000074:	797d                	lui	s2,0xfffff
    80000076:	4481                	li	s1,0
  {
    // ignoring the first 4 (4*1024) blocks as it is elf headers
    if (i < 4)
    80000078:	4a0d                	li	s4,3
      continue;
    b.blockno = i;
    kernel_copy(RECOVERY, &b);
    8000007a:	b7840c93          	addi	s9,s0,-1160
    8000007e:	4c05                	li	s8,1
    memmove((void *)rec_kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    80000080:	ba040b93          	addi	s7,s0,-1120
    80000084:	40000b13          	li	s6,1024
    80000088:	a031                	j	80000094 <setup_recovery_kernel+0x6e>
  for (int i = 0; i < rec_num_blocks; i++)
    8000008a:	0485                	addi	s1,s1,1
    8000008c:	4009091b          	addiw	s2,s2,1024 # fffffffffffff400 <kernel_elfhdr+0xffffffff7fff6760>
    80000090:	0334f363          	bgeu	s1,s3,800000b6 <setup_recovery_kernel+0x90>
    if (i < 4)
    80000094:	0004879b          	sext.w	a5,s1
    80000098:	fefa59e3          	bge	s4,a5,8000008a <setup_recovery_kernel+0x64>
    b.blockno = i;
    8000009c:	b8942223          	sw	s1,-1148(s0)
    kernel_copy(RECOVERY, &b);
    800000a0:	85e6                	mv	a1,s9
    800000a2:	8562                	mv	a0,s8
    800000a4:	2e6000ef          	jal	8000038a <kernel_copy>
    memmove((void *)rec_kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    800000a8:	865a                	mv	a2,s6
    800000aa:	85de                	mv	a1,s7
    800000ac:	01590533          	add	a0,s2,s5
    800000b0:	3aa000ef          	jal	8000045a <memmove>
    800000b4:	bfd9                	j	8000008a <setup_recovery_kernel+0x64>
    800000b6:	47813483          	ld	s1,1144(sp)
    800000ba:	47013903          	ld	s2,1136(sp)
    800000be:	46813983          	ld	s3,1128(sp)
    800000c2:	46013a03          	ld	s4,1120(sp)
    800000c6:	45013b03          	ld	s6,1104(sp)
    800000ca:	44813b83          	ld	s7,1096(sp)
    800000ce:	44013c03          	ld	s8,1088(sp)
    800000d2:	43813c83          	ld	s9,1080(sp)
  }

  uint64 rec_kernel_entry = find_kernel_entry_addr(RECOVERY);
    800000d6:	4505                	li	a0,1
    800000d8:	586000ef          	jal	8000065e <find_kernel_entry_addr>
// instruction address to which a return from
// exception will go.
static inline void
w_mepc(uint64 x)
{
  asm volatile("csrw mepc, %0"
    800000dc:	34151073          	csrw	mepc,a0

  /* CSE 536: Write the correct kernel entry point */
  w_mepc((uint64)rec_kernel_entry);
}
    800000e0:	48813083          	ld	ra,1160(sp)
    800000e4:	48013403          	ld	s0,1152(sp)
    800000e8:	45813a83          	ld	s5,1112(sp)
    800000ec:	49010113          	addi	sp,sp,1168
    800000f0:	8082                	ret

00000000800000f2 <is_secure_boot>:

/* CSE 536: Function verifies if NORMAL kernel is expected or tampered. */
bool is_secure_boot(void)
{
    800000f2:	b7010113          	addi	sp,sp,-1168
    800000f6:	48113423          	sd	ra,1160(sp)
    800000fa:	48813023          	sd	s0,1152(sp)
    800000fe:	46913c23          	sd	s1,1144(sp)
    80000102:	47213823          	sd	s2,1136(sp)
    80000106:	45513c23          	sd	s5,1112(sp)
    8000010a:	43913c23          	sd	s9,1080(sp)
    8000010e:	43a13823          	sd	s10,1072(sp)
    80000112:	49010413          	addi	s0,sp,1168
  bool verification = true;

  /* Read the binary and update the observed measurement
   * (simplified template provided below) */
  sha256_init(&sha256_ctx);
    80000116:	00001517          	auipc	a0,0x1
    8000011a:	b0a50513          	addi	a0,a0,-1270 # 80000c20 <sha256_ctx>
    8000011e:	762000ef          	jal	80000880 <sha256_init>
  struct buf b;
  uint64 kernel_load_addr = find_kernel_load_addr(NORMAL);
    80000122:	4501                	li	a0,0
    80000124:	488000ef          	jal	800005ac <find_kernel_load_addr>
    80000128:	8caa                	mv	s9,a0
  uint64 kernel_binary_size = find_kernel_size(NORMAL);
    8000012a:	4501                	li	a0,0
    8000012c:	4e4000ef          	jal	80000610 <find_kernel_size>
    80000130:	8d2a                	mv	s10,a0
  uint64 num_blocks = kernel_binary_size / BSIZE;
    80000132:	00a55a93          	srli	s5,a0,0xa
  for (int i = 0; i < num_blocks; i++)
    80000136:	3ff00793          	li	a5,1023
    8000013a:	08a7fa63          	bgeu	a5,a0,800001ce <is_secure_boot+0xdc>
    8000013e:	47313423          	sd	s3,1128(sp)
    80000142:	47413023          	sd	s4,1120(sp)
    80000146:	45613823          	sd	s6,1104(sp)
    8000014a:	45713423          	sd	s7,1096(sp)
    8000014e:	45813023          	sd	s8,1088(sp)
    80000152:	797d                	lui	s2,0xfffff
    80000154:	4481                	li	s1,0
  {
    // ignoring the first 4 (4*1024) blocks as it is elf headers
    if (i < 4)
    80000156:	4b0d                	li	s6,3
      kernel_copy(NORMAL, &b);
      sha256_update(&sha256_ctx, (const unsigned char *)b.data, BSIZE);
      continue;
    }
    b.blockno = i;
    kernel_copy(NORMAL, &b);
    80000158:	b7840c13          	addi	s8,s0,-1160
    memmove((void *)kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    8000015c:	ba040a13          	addi	s4,s0,-1120
    80000160:	40000993          	li	s3,1024
    sha256_update(&sha256_ctx, (const unsigned char *)b.data, BSIZE);
    80000164:	00001b97          	auipc	s7,0x1
    80000168:	abcb8b93          	addi	s7,s7,-1348 # 80000c20 <sha256_ctx>
    8000016c:	a00d                	j	8000018e <is_secure_boot+0x9c>
      b.blockno = i;
    8000016e:	b8942223          	sw	s1,-1148(s0)
      kernel_copy(NORMAL, &b);
    80000172:	85e2                	mv	a1,s8
    80000174:	4501                	li	a0,0
    80000176:	214000ef          	jal	8000038a <kernel_copy>
      sha256_update(&sha256_ctx, (const unsigned char *)b.data, BSIZE);
    8000017a:	864e                	mv	a2,s3
    8000017c:	85d2                	mv	a1,s4
    8000017e:	855e                	mv	a0,s7
    80000180:	768000ef          	jal	800008e8 <sha256_update>
  for (int i = 0; i < num_blocks; i++)
    80000184:	0485                	addi	s1,s1,1
    80000186:	4009091b          	addiw	s2,s2,1024 # fffffffffffff400 <kernel_elfhdr+0xffffffff7fff6760>
    8000018a:	0354f863          	bgeu	s1,s5,800001ba <is_secure_boot+0xc8>
    if (i < 4)
    8000018e:	0004879b          	sext.w	a5,s1
    80000192:	fcfb5ee3          	bge	s6,a5,8000016e <is_secure_boot+0x7c>
    b.blockno = i;
    80000196:	b8942223          	sw	s1,-1148(s0)
    kernel_copy(NORMAL, &b);
    8000019a:	85e2                	mv	a1,s8
    8000019c:	4501                	li	a0,0
    8000019e:	1ec000ef          	jal	8000038a <kernel_copy>
    memmove((void *)kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    800001a2:	864e                	mv	a2,s3
    800001a4:	85d2                	mv	a1,s4
    800001a6:	01990533          	add	a0,s2,s9
    800001aa:	2b0000ef          	jal	8000045a <memmove>
    sha256_update(&sha256_ctx, (const unsigned char *)b.data, BSIZE);
    800001ae:	864e                	mv	a2,s3
    800001b0:	85d2                	mv	a1,s4
    800001b2:	855e                	mv	a0,s7
    800001b4:	734000ef          	jal	800008e8 <sha256_update>
    800001b8:	b7f1                	j	80000184 <is_secure_boot+0x92>
    800001ba:	46813983          	ld	s3,1128(sp)
    800001be:	46013a03          	ld	s4,1120(sp)
    800001c2:	45013b03          	ld	s6,1104(sp)
    800001c6:	44813b83          	ld	s7,1096(sp)
    800001ca:	44013c03          	ld	s8,1088(sp)
  }
  uint64 rem_size = kernel_binary_size - BSIZE * num_blocks;
  b.blockno = num_blocks;
    800001ce:	b9542223          	sw	s5,-1148(s0)
  kernel_copy(NORMAL, &b);
    800001d2:	b7840593          	addi	a1,s0,-1160
    800001d6:	4501                	li	a0,0
    800001d8:	1b2000ef          	jal	8000038a <kernel_copy>
  sha256_update(&sha256_ctx, (const unsigned char *)b.data, rem_size);
    800001dc:	00001917          	auipc	s2,0x1
    800001e0:	a4490913          	addi	s2,s2,-1468 # 80000c20 <sha256_ctx>
    800001e4:	3ffd7613          	andi	a2,s10,1023
    800001e8:	ba040593          	addi	a1,s0,-1120
    800001ec:	854a                	mv	a0,s2
    800001ee:	6fa000ef          	jal	800008e8 <sha256_update>
  sha256_final(&sha256_ctx, sys_info_ptr->observed_kernel_measurement);
    800001f2:	00009497          	auipc	s1,0x9
    800001f6:	a9e48493          	addi	s1,s1,-1378 # 80008c90 <sys_info_ptr>
    800001fa:	608c                	ld	a1,0(s1)
    800001fc:	04058593          	addi	a1,a1,64
    80000200:	854a                	mv	a0,s2
    80000202:	760000ef          	jal	80000962 <sha256_final>

  /* Three more tasks required below:
   *  1. Compare observed measurement with expected hash
   *  2. Setup the recovery kernel if comparison fails
   *  3. Copy expected kernel hash to the system information table */
  memcpy(sys_info_ptr->expected_kernel_measurement, trusted_kernel_hash, sizeof(sys_info_ptr->expected_kernel_measurement));
    80000206:	6088                	ld	a0,0(s1)
    80000208:	02000613          	li	a2,32
    8000020c:	00001597          	auipc	a1,0x1
    80000210:	8cc58593          	addi	a1,a1,-1844 # 80000ad8 <trusted_kernel_hash>
    80000214:	9532                	add	a0,a0,a2
    80000216:	2a4000ef          	jal	800004ba <memcpy>

  if (memcmp(sys_info_ptr->observed_kernel_measurement, sys_info_ptr->expected_kernel_measurement, sizeof(sys_info_ptr->expected_kernel_measurement)) != 0)
    8000021a:	6088                	ld	a0,0(s1)
    8000021c:	02000613          	li	a2,32
    80000220:	00c505b3          	add	a1,a0,a2
    80000224:	04050513          	addi	a0,a0,64
    80000228:	1f4000ef          	jal	8000041c <memcmp>
  {
    verification = false;
  }

  return verification;
}
    8000022c:	00153513          	seqz	a0,a0
    80000230:	48813083          	ld	ra,1160(sp)
    80000234:	48013403          	ld	s0,1152(sp)
    80000238:	47813483          	ld	s1,1144(sp)
    8000023c:	47013903          	ld	s2,1136(sp)
    80000240:	45813a83          	ld	s5,1112(sp)
    80000244:	43813c83          	ld	s9,1080(sp)
    80000248:	43013d03          	ld	s10,1072(sp)
    8000024c:	49010113          	addi	sp,sp,1168
    80000250:	8082                	ret

0000000080000252 <start>:

// entry.S jumps here in machine mode on stack0.
void start()
{
    80000252:	b8010113          	addi	sp,sp,-1152
    80000256:	46113c23          	sd	ra,1144(sp)
    8000025a:	46813823          	sd	s0,1136(sp)
    8000025e:	48010413          	addi	s0,sp,1152
  /* CSE 536: Define the system information table's location. */
  sys_info_ptr = (struct sys_info *)0x80080000;
    80000262:	010017b7          	lui	a5,0x1001
    80000266:	079e                	slli	a5,a5,0x7
    80000268:	00009717          	auipc	a4,0x9
    8000026c:	a2f73423          	sd	a5,-1496(a4) # 80008c90 <sys_info_ptr>
  asm volatile("csrr %0, mhartid"
    80000270:	f14027f3          	csrr	a5,mhartid

  // keep each CPU's hartid in its tp register, for cpuid().
  int id = r_mhartid();
  w_tp(id);
    80000274:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0"
    80000276:	823e                	mv	tp,a5

  // set M Previous Privilege mode to Supervisor, for mret.

  /* CSE 536: Verify if the kernel is untampered for secure boot */
  if (!is_secure_boot())
    80000278:	e7bff0ef          	jal	800000f2 <is_secure_boot>
    8000027c:	e901                	bnez	a0,8000028c <start+0x3a>

  // switch to supervisor mode and jump to main().
  //asm volatile("mret");
  kernel_entry = find_kernel_entry_addr(NORMAL);
  asm volatile("jalr zero, %0" : : "r"(kernel_entry));
}
    8000027e:	47813083          	ld	ra,1144(sp)
    80000282:	47013403          	ld	s0,1136(sp)
    80000286:	48010113          	addi	sp,sp,1152
    8000028a:	8082                	ret
    8000028c:	45313c23          	sd	s3,1112(sp)
    80000290:	45513423          	sd	s5,1096(sp)
   uint64 kernel_load_addr = find_kernel_load_addr(NORMAL);
    80000294:	4501                	li	a0,0
    80000296:	316000ef          	jal	800005ac <find_kernel_load_addr>
    8000029a:	8aaa                	mv	s5,a0
   uint64 kernel_binary_size = find_kernel_size(NORMAL);
    8000029c:	4501                	li	a0,0
    8000029e:	372000ef          	jal	80000610 <find_kernel_size>
   uint64 num_blocks = kernel_binary_size / FSSIZE;
    800002a2:	00455993          	srli	s3,a0,0x4
    800002a6:	5e354737          	lui	a4,0x5e354
    800002aa:	f7d70713          	addi	a4,a4,-131 # 5e353f7d <_entry-0x21cac083>
    800002ae:	020c57b7          	lui	a5,0x20c5
    800002b2:	9ba78793          	addi	a5,a5,-1606 # 20c49ba <_entry-0x7df3b646>
    800002b6:	1782                	slli	a5,a5,0x20
    800002b8:	97ba                	add	a5,a5,a4
    800002ba:	02f9b9b3          	mulhu	s3,s3,a5
   for (int i = 0; i < num_blocks; i++)
    800002be:	7cf00793          	li	a5,1999
    800002c2:	06a7fa63          	bgeu	a5,a0,80000336 <start+0xe4>
    800002c6:	46913423          	sd	s1,1128(sp)
    800002ca:	47213023          	sd	s2,1120(sp)
    800002ce:	45413823          	sd	s4,1104(sp)
    800002d2:	45613023          	sd	s6,1088(sp)
    800002d6:	43713c23          	sd	s7,1080(sp)
    800002da:	43813823          	sd	s8,1072(sp)
    800002de:	797d                	lui	s2,0xfffff
    800002e0:	4481                	li	s1,0
   if (i < 4)
    800002e2:	4a0d                	li	s4,3
   kernel_copy(NORMAL, &b);
    800002e4:	b8840c13          	addi	s8,s0,-1144
   memmove((void *)kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    800002e8:	bb040b93          	addi	s7,s0,-1104
    800002ec:	40000b13          	li	s6,1024
    800002f0:	a031                	j	800002fc <start+0xaa>
   for (int i = 0; i < num_blocks; i++)
    800002f2:	0485                	addi	s1,s1,1
    800002f4:	4009091b          	addiw	s2,s2,1024 # fffffffffffff400 <kernel_elfhdr+0xffffffff7fff6760>
    800002f8:	0334f363          	bgeu	s1,s3,8000031e <start+0xcc>
   if (i < 4)
    800002fc:	0004879b          	sext.w	a5,s1
    80000300:	fefa59e3          	bge	s4,a5,800002f2 <start+0xa0>
   b.blockno = i;
    80000304:	b8942a23          	sw	s1,-1132(s0)
   kernel_copy(NORMAL, &b);
    80000308:	85e2                	mv	a1,s8
    8000030a:	4501                	li	a0,0
    8000030c:	07e000ef          	jal	8000038a <kernel_copy>
   memmove((void *)kernel_load_addr + ((i - 4) * BSIZE), b.data, BSIZE);
    80000310:	865a                	mv	a2,s6
    80000312:	85de                	mv	a1,s7
    80000314:	01590533          	add	a0,s2,s5
    80000318:	142000ef          	jal	8000045a <memmove>
    8000031c:	bfd9                	j	800002f2 <start+0xa0>
    8000031e:	46813483          	ld	s1,1128(sp)
    80000322:	46013903          	ld	s2,1120(sp)
    80000326:	45013a03          	ld	s4,1104(sp)
    8000032a:	44013b03          	ld	s6,1088(sp)
    8000032e:	43813b83          	ld	s7,1080(sp)
    80000332:	43013c03          	ld	s8,1072(sp)
  uint64 kernel_entry = find_kernel_entry_addr(NORMAL);
    80000336:	4501                	li	a0,0
    80000338:	326000ef          	jal	8000065e <find_kernel_entry_addr>
  asm volatile("csrw mepc, %0"
    8000033c:	34151073          	csrw	mepc,a0
  sys_info_ptr->bl_start = (uint64)&_entry;
    80000340:	00009797          	auipc	a5,0x9
    80000344:	95078793          	addi	a5,a5,-1712 # 80008c90 <sys_info_ptr>
    80000348:	6398                	ld	a4,0(a5)
    8000034a:	00000697          	auipc	a3,0x0
    8000034e:	cb668693          	addi	a3,a3,-842 # 80000000 <_entry>
    80000352:	e314                	sd	a3,0(a4)
  sys_info_ptr->bl_end = (uint64)end;
    80000354:	639c                	ld	a5,0(a5)
    80000356:	00009717          	auipc	a4,0x9
    8000035a:	93a73703          	ld	a4,-1734(a4) # 80008c90 <sys_info_ptr>
    8000035e:	e798                	sd	a4,8(a5)
  sys_info_ptr->dr_start = 0x80000000;
    80000360:	4705                	li	a4,1
    80000362:	077e                	slli	a4,a4,0x1f
    80000364:	eb98                	sd	a4,16(a5)
  sys_info_ptr->dr_end = PHYSTOP;
    80000366:	4745                	li	a4,17
    80000368:	076e                	slli	a4,a4,0x1b
    8000036a:	ef98                	sd	a4,24(a5)
  asm volatile("mv ra, %0"
    8000036c:	00000797          	auipc	a5,0x0
    80000370:	cb078793          	addi	a5,a5,-848 # 8000001c <panic>
    80000374:	80be                	mv	ra,a5
  kernel_entry = find_kernel_entry_addr(NORMAL);
    80000376:	4501                	li	a0,0
    80000378:	2e6000ef          	jal	8000065e <find_kernel_entry_addr>
  asm volatile("jalr zero, %0" : : "r"(kernel_entry));
    8000037c:	00050067          	jr	a0
    80000380:	45813983          	ld	s3,1112(sp)
    80000384:	44813a83          	ld	s5,1096(sp)
    80000388:	bddd                	j	8000027e <start+0x2c>

000000008000038a <kernel_copy>:
#include "layout.h"
#include "buf.h"

/* In-built function to load NORMAL/RECOVERY kernels */
void kernel_copy(enum kernel ktype, struct buf *b)
{
    8000038a:	1101                	addi	sp,sp,-32
    8000038c:	ec06                	sd	ra,24(sp)
    8000038e:	e822                	sd	s0,16(sp)
    80000390:	e426                	sd	s1,8(sp)
    80000392:	e04a                	sd	s2,0(sp)
    80000394:	1000                	addi	s0,sp,32
    80000396:	892a                	mv	s2,a0
    80000398:	84ae                	mv	s1,a1
  if(b->blockno >= FSSIZE)
    8000039a:	45d8                	lw	a4,12(a1)
    8000039c:	7cf00793          	li	a5,1999
    800003a0:	02e7eb63          	bltu	a5,a4,800003d6 <kernel_copy+0x4c>
    panic("ramdiskrw: blockno too big");

  uint64 diskaddr = b->blockno * BSIZE;
    800003a4:	44dc                	lw	a5,12(s1)
    800003a6:	00a7979b          	slliw	a5,a5,0xa
    800003aa:	1782                	slli	a5,a5,0x20
    800003ac:	9381                	srli	a5,a5,0x20
  char* addr = 0x0; 
  
  if (ktype == NORMAL)
    800003ae:	02091b63          	bnez	s2,800003e4 <kernel_copy+0x5a>
    addr = (char *)RAMDISK + diskaddr;
    800003b2:	02100593          	li	a1,33
    800003b6:	05ea                	slli	a1,a1,0x1a
    800003b8:	95be                	add	a1,a1,a5
  else if (ktype == RECOVERY)
    addr = (char *)RECOVERYDISK + diskaddr;

  memmove(b->data, addr, BSIZE);
    800003ba:	40000613          	li	a2,1024
    800003be:	02848513          	addi	a0,s1,40
    800003c2:	098000ef          	jal	8000045a <memmove>
  b->valid = 1;
    800003c6:	4785                	li	a5,1
    800003c8:	c09c                	sw	a5,0(s1)
    800003ca:	60e2                	ld	ra,24(sp)
    800003cc:	6442                	ld	s0,16(sp)
    800003ce:	64a2                	ld	s1,8(sp)
    800003d0:	6902                	ld	s2,0(sp)
    800003d2:	6105                	addi	sp,sp,32
    800003d4:	8082                	ret
    panic("ramdiskrw: blockno too big");
    800003d6:	00001517          	auipc	a0,0x1
    800003da:	82250513          	addi	a0,a0,-2014 # 80000bf8 <erodata>
    800003de:	c3fff0ef          	jal	8000001c <panic>
    800003e2:	b7c9                	j	800003a4 <kernel_copy+0x1a>
  else if (ktype == RECOVERY)
    800003e4:	4705                	li	a4,1
  char* addr = 0x0; 
    800003e6:	4581                	li	a1,0
  else if (ktype == RECOVERY)
    800003e8:	fce919e3          	bne	s2,a4,800003ba <kernel_copy+0x30>
    addr = (char *)RECOVERYDISK + diskaddr;
    800003ec:	008455b7          	lui	a1,0x845
    800003f0:	05a2                	slli	a1,a1,0x8
    800003f2:	95be                	add	a1,a1,a5
    800003f4:	b7d9                	j	800003ba <kernel_copy+0x30>

00000000800003f6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800003f6:	1141                	addi	sp,sp,-16
    800003f8:	e406                	sd	ra,8(sp)
    800003fa:	e022                	sd	s0,0(sp)
    800003fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800003fe:	ca19                	beqz	a2,80000414 <memset+0x1e>
    80000400:	87aa                	mv	a5,a0
    80000402:	1602                	slli	a2,a2,0x20
    80000404:	9201                	srli	a2,a2,0x20
    80000406:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000040a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000040e:	0785                	addi	a5,a5,1
    80000410:	fee79de3          	bne	a5,a4,8000040a <memset+0x14>
  }
  return dst;
}
    80000414:	60a2                	ld	ra,8(sp)
    80000416:	6402                	ld	s0,0(sp)
    80000418:	0141                	addi	sp,sp,16
    8000041a:	8082                	ret

000000008000041c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000041c:	1141                	addi	sp,sp,-16
    8000041e:	e406                	sd	ra,8(sp)
    80000420:	e022                	sd	s0,0(sp)
    80000422:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000424:	ca0d                	beqz	a2,80000456 <memcmp+0x3a>
    80000426:	fff6069b          	addiw	a3,a2,-1
    8000042a:	1682                	slli	a3,a3,0x20
    8000042c:	9281                	srli	a3,a3,0x20
    8000042e:	0685                	addi	a3,a3,1
    80000430:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000432:	00054783          	lbu	a5,0(a0)
    80000436:	0005c703          	lbu	a4,0(a1) # 845000 <_entry-0x7f7bb000>
    8000043a:	00e79863          	bne	a5,a4,8000044a <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    8000043e:	0505                	addi	a0,a0,1
    80000440:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000442:	fed518e3          	bne	a0,a3,80000432 <memcmp+0x16>
  }

  return 0;
    80000446:	4501                	li	a0,0
    80000448:	a019                	j	8000044e <memcmp+0x32>
      return *s1 - *s2;
    8000044a:	40e7853b          	subw	a0,a5,a4
}
    8000044e:	60a2                	ld	ra,8(sp)
    80000450:	6402                	ld	s0,0(sp)
    80000452:	0141                	addi	sp,sp,16
    80000454:	8082                	ret
  return 0;
    80000456:	4501                	li	a0,0
    80000458:	bfdd                	j	8000044e <memcmp+0x32>

000000008000045a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e406                	sd	ra,8(sp)
    8000045e:	e022                	sd	s0,0(sp)
    80000460:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000462:	c205                	beqz	a2,80000482 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000464:	02a5e363          	bltu	a1,a0,8000048a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000468:	1602                	slli	a2,a2,0x20
    8000046a:	9201                	srli	a2,a2,0x20
    8000046c:	00c587b3          	add	a5,a1,a2
{
    80000470:	872a                	mv	a4,a0
      *d++ = *s++;
    80000472:	0585                	addi	a1,a1,1
    80000474:	0705                	addi	a4,a4,1
    80000476:	fff5c683          	lbu	a3,-1(a1)
    8000047a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000047e:	feb79ae3          	bne	a5,a1,80000472 <memmove+0x18>

  return dst;
}
    80000482:	60a2                	ld	ra,8(sp)
    80000484:	6402                	ld	s0,0(sp)
    80000486:	0141                	addi	sp,sp,16
    80000488:	8082                	ret
  if(s < d && s + n > d){
    8000048a:	02061693          	slli	a3,a2,0x20
    8000048e:	9281                	srli	a3,a3,0x20
    80000490:	00d58733          	add	a4,a1,a3
    80000494:	fce57ae3          	bgeu	a0,a4,80000468 <memmove+0xe>
    d += n;
    80000498:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000049a:	fff6079b          	addiw	a5,a2,-1
    8000049e:	1782                	slli	a5,a5,0x20
    800004a0:	9381                	srli	a5,a5,0x20
    800004a2:	fff7c793          	not	a5,a5
    800004a6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800004a8:	177d                	addi	a4,a4,-1
    800004aa:	16fd                	addi	a3,a3,-1
    800004ac:	00074603          	lbu	a2,0(a4)
    800004b0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800004b4:	fee79ae3          	bne	a5,a4,800004a8 <memmove+0x4e>
    800004b8:	b7e9                	j	80000482 <memmove+0x28>

00000000800004ba <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800004ba:	1141                	addi	sp,sp,-16
    800004bc:	e406                	sd	ra,8(sp)
    800004be:	e022                	sd	s0,0(sp)
    800004c0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800004c2:	f99ff0ef          	jal	8000045a <memmove>
}
    800004c6:	60a2                	ld	ra,8(sp)
    800004c8:	6402                	ld	s0,0(sp)
    800004ca:	0141                	addi	sp,sp,16
    800004cc:	8082                	ret

00000000800004ce <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800004ce:	1141                	addi	sp,sp,-16
    800004d0:	e406                	sd	ra,8(sp)
    800004d2:	e022                	sd	s0,0(sp)
    800004d4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800004d6:	ce11                	beqz	a2,800004f2 <strncmp+0x24>
    800004d8:	00054783          	lbu	a5,0(a0)
    800004dc:	cf89                	beqz	a5,800004f6 <strncmp+0x28>
    800004de:	0005c703          	lbu	a4,0(a1)
    800004e2:	00f71a63          	bne	a4,a5,800004f6 <strncmp+0x28>
    n--, p++, q++;
    800004e6:	367d                	addiw	a2,a2,-1
    800004e8:	0505                	addi	a0,a0,1
    800004ea:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800004ec:	f675                	bnez	a2,800004d8 <strncmp+0xa>
  if(n == 0)
    return 0;
    800004ee:	4501                	li	a0,0
    800004f0:	a801                	j	80000500 <strncmp+0x32>
    800004f2:	4501                	li	a0,0
    800004f4:	a031                	j	80000500 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	0005c783          	lbu	a5,0(a1)
    800004fe:	9d1d                	subw	a0,a0,a5
}
    80000500:	60a2                	ld	ra,8(sp)
    80000502:	6402                	ld	s0,0(sp)
    80000504:	0141                	addi	sp,sp,16
    80000506:	8082                	ret

0000000080000508 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000508:	1141                	addi	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000510:	87aa                	mv	a5,a0
    80000512:	86b2                	mv	a3,a2
    80000514:	367d                	addiw	a2,a2,-1
    80000516:	02d05563          	blez	a3,80000540 <strncpy+0x38>
    8000051a:	0785                	addi	a5,a5,1
    8000051c:	0005c703          	lbu	a4,0(a1)
    80000520:	fee78fa3          	sb	a4,-1(a5)
    80000524:	0585                	addi	a1,a1,1
    80000526:	f775                	bnez	a4,80000512 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000528:	873e                	mv	a4,a5
    8000052a:	00c05b63          	blez	a2,80000540 <strncpy+0x38>
    8000052e:	9fb5                	addw	a5,a5,a3
    80000530:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000532:	0705                	addi	a4,a4,1
    80000534:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000538:	40e786bb          	subw	a3,a5,a4
    8000053c:	fed04be3          	bgtz	a3,80000532 <strncpy+0x2a>
  return os;
}
    80000540:	60a2                	ld	ra,8(sp)
    80000542:	6402                	ld	s0,0(sp)
    80000544:	0141                	addi	sp,sp,16
    80000546:	8082                	ret

0000000080000548 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000548:	1141                	addi	sp,sp,-16
    8000054a:	e406                	sd	ra,8(sp)
    8000054c:	e022                	sd	s0,0(sp)
    8000054e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000550:	02c05363          	blez	a2,80000576 <safestrcpy+0x2e>
    80000554:	fff6069b          	addiw	a3,a2,-1
    80000558:	1682                	slli	a3,a3,0x20
    8000055a:	9281                	srli	a3,a3,0x20
    8000055c:	96ae                	add	a3,a3,a1
    8000055e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000560:	00d58963          	beq	a1,a3,80000572 <safestrcpy+0x2a>
    80000564:	0585                	addi	a1,a1,1
    80000566:	0785                	addi	a5,a5,1
    80000568:	fff5c703          	lbu	a4,-1(a1)
    8000056c:	fee78fa3          	sb	a4,-1(a5)
    80000570:	fb65                	bnez	a4,80000560 <safestrcpy+0x18>
    ;
  *s = 0;
    80000572:	00078023          	sb	zero,0(a5)
  return os;
}
    80000576:	60a2                	ld	ra,8(sp)
    80000578:	6402                	ld	s0,0(sp)
    8000057a:	0141                	addi	sp,sp,16
    8000057c:	8082                	ret

000000008000057e <strlen>:

int
strlen(const char *s)
{
    8000057e:	1141                	addi	sp,sp,-16
    80000580:	e406                	sd	ra,8(sp)
    80000582:	e022                	sd	s0,0(sp)
    80000584:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000586:	00054783          	lbu	a5,0(a0)
    8000058a:	cf99                	beqz	a5,800005a8 <strlen+0x2a>
    8000058c:	0505                	addi	a0,a0,1
    8000058e:	87aa                	mv	a5,a0
    80000590:	86be                	mv	a3,a5
    80000592:	0785                	addi	a5,a5,1
    80000594:	fff7c703          	lbu	a4,-1(a5)
    80000598:	ff65                	bnez	a4,80000590 <strlen+0x12>
    8000059a:	40a6853b          	subw	a0,a3,a0
    8000059e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800005a0:	60a2                	ld	ra,8(sp)
    800005a2:	6402                	ld	s0,0(sp)
    800005a4:	0141                	addi	sp,sp,16
    800005a6:	8082                	ret
  for(n = 0; s[n]; n++)
    800005a8:	4501                	li	a0,0
    800005aa:	bfdd                	j	800005a0 <strlen+0x22>

00000000800005ac <find_kernel_load_addr>:

struct elfhdr *kernel_elfhdr;
struct proghdr *kernel_phdr;

uint64 find_kernel_load_addr(enum kernel ktype)
{
    800005ac:	1141                	addi	sp,sp,-16
    800005ae:	e406                	sd	ra,8(sp)
    800005b0:	e022                	sd	s0,0(sp)
    800005b2:	0800                	addi	s0,sp,16
    /* CSE 536: Get kernel load address from headers */
    if (ktype == NORMAL)
    800005b4:	c911                	beqz	a0,800005c8 <find_kernel_load_addr+0x1c>
    800005b6:	87aa                	mv	a5,a0

        kernel_phdr = (struct proghdr *)text_phdr_addr;

        return kernel_phdr->vaddr;
    }
    else if (ktype == RECOVERY)
    800005b8:	4705                	li	a4,1

        return kernel_phdr->vaddr;
    }
    else
    {
        return 0;
    800005ba:	4501                	li	a0,0
    else if (ktype == RECOVERY)
    800005bc:	02e78863          	beq	a5,a4,800005ec <find_kernel_load_addr+0x40>
    }
}
    800005c0:	60a2                	ld	ra,8(sp)
    800005c2:	6402                	ld	s0,0(sp)
    800005c4:	0141                	addi	sp,sp,16
    800005c6:	8082                	ret
        kernel_elfhdr = (struct elfhdr *)RAMDISK;
    800005c8:	02100713          	li	a4,33
    800005cc:	076a                	slli	a4,a4,0x1a
    800005ce:	00008797          	auipc	a5,0x8
    800005d2:	6ce7b923          	sd	a4,1746(a5) # 80008ca0 <kernel_elfhdr>
        uint64 text_phdr_addr = RAMDISK + phoff + phsize;
    800005d6:	731c                	ld	a5,32(a4)
    800005d8:	97ba                	add	a5,a5,a4
        uint64 phsize = kernel_elfhdr->phentsize;
    800005da:	03675703          	lhu	a4,54(a4)
        uint64 text_phdr_addr = RAMDISK + phoff + phsize;
    800005de:	97ba                	add	a5,a5,a4
        kernel_phdr = (struct proghdr *)text_phdr_addr;
    800005e0:	00008717          	auipc	a4,0x8
    800005e4:	6af73c23          	sd	a5,1720(a4) # 80008c98 <kernel_phdr>
        return kernel_phdr->vaddr;
    800005e8:	6b88                	ld	a0,16(a5)
    800005ea:	bfd9                	j	800005c0 <find_kernel_load_addr+0x14>
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    800005ec:	00845737          	lui	a4,0x845
    800005f0:	0722                	slli	a4,a4,0x8
    800005f2:	00008797          	auipc	a5,0x8
    800005f6:	6ae7b723          	sd	a4,1710(a5) # 80008ca0 <kernel_elfhdr>
        uint64 text_phdr_addr = RECOVERYDISK + phoff + phsize;
    800005fa:	731c                	ld	a5,32(a4)
    800005fc:	97ba                	add	a5,a5,a4
        uint64 phsize = kernel_elfhdr->phentsize;
    800005fe:	03675703          	lhu	a4,54(a4) # 845036 <_entry-0x7f7bafca>
        uint64 text_phdr_addr = RECOVERYDISK + phoff + phsize;
    80000602:	97ba                	add	a5,a5,a4
        kernel_phdr = (struct proghdr *)text_phdr_addr;
    80000604:	00008717          	auipc	a4,0x8
    80000608:	68f73a23          	sd	a5,1684(a4) # 80008c98 <kernel_phdr>
        return kernel_phdr->vaddr;
    8000060c:	6b88                	ld	a0,16(a5)
    8000060e:	bf4d                	j	800005c0 <find_kernel_load_addr+0x14>

0000000080000610 <find_kernel_size>:

uint64 find_kernel_size(enum kernel ktype)
{
    80000610:	1141                	addi	sp,sp,-16
    80000612:	e406                	sd	ra,8(sp)
    80000614:	e022                	sd	s0,0(sp)
    80000616:	0800                	addi	s0,sp,16
    /* CSE 536: Get kernel binary size from headers */
    if (ktype == NORMAL)
    80000618:	e905                	bnez	a0,80000648 <find_kernel_size+0x38>
    {
        kernel_elfhdr = (struct elfhdr *)RAMDISK;
    8000061a:	02100793          	li	a5,33
    8000061e:	07ea                	slli	a5,a5,0x1a
    80000620:	00008717          	auipc	a4,0x8
    80000624:	68f73023          	sd	a5,1664(a4) # 80008ca0 <kernel_elfhdr>
    }
    else if (ktype == RECOVERY)
    {
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    }
    uint64 start_of_section_headers = kernel_elfhdr->shoff;
    80000628:	00008717          	auipc	a4,0x8
    8000062c:	67873703          	ld	a4,1656(a4) # 80008ca0 <kernel_elfhdr>
    uint64 size_of_section_headers = kernel_elfhdr->shentsize * kernel_elfhdr->shnum;
    80000630:	03a75783          	lhu	a5,58(a4)
    80000634:	03c75683          	lhu	a3,60(a4)
    80000638:	02d787bb          	mulw	a5,a5,a3
    uint64 total_size = start_of_section_headers + size_of_section_headers;
    8000063c:	7708                	ld	a0,40(a4)

    return total_size;
}
    8000063e:	953e                	add	a0,a0,a5
    80000640:	60a2                	ld	ra,8(sp)
    80000642:	6402                	ld	s0,0(sp)
    80000644:	0141                	addi	sp,sp,16
    80000646:	8082                	ret
    else if (ktype == RECOVERY)
    80000648:	4785                	li	a5,1
    8000064a:	fcf51fe3          	bne	a0,a5,80000628 <find_kernel_size+0x18>
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    8000064e:	008457b7          	lui	a5,0x845
    80000652:	07a2                	slli	a5,a5,0x8
    80000654:	00008717          	auipc	a4,0x8
    80000658:	64f73623          	sd	a5,1612(a4) # 80008ca0 <kernel_elfhdr>
    8000065c:	b7f1                	j	80000628 <find_kernel_size+0x18>

000000008000065e <find_kernel_entry_addr>:

uint64 find_kernel_entry_addr(enum kernel ktype)
{
    8000065e:	1141                	addi	sp,sp,-16
    80000660:	e406                	sd	ra,8(sp)
    80000662:	e022                	sd	s0,0(sp)
    80000664:	0800                	addi	s0,sp,16
    /* CSE 536: Get kernel entry point from headers */
    if (ktype == NORMAL)
    80000666:	e10d                	bnez	a0,80000688 <find_kernel_entry_addr+0x2a>
    {
        kernel_elfhdr = (struct elfhdr *)RAMDISK;
    80000668:	02100793          	li	a5,33
    8000066c:	07ea                	slli	a5,a5,0x1a
    8000066e:	00008717          	auipc	a4,0x8
    80000672:	62f73923          	sd	a5,1586(a4) # 80008ca0 <kernel_elfhdr>
    {
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    }
    // return entry point
    return kernel_elfhdr->entry;
}
    80000676:	00008797          	auipc	a5,0x8
    8000067a:	62a7b783          	ld	a5,1578(a5) # 80008ca0 <kernel_elfhdr>
    8000067e:	6f88                	ld	a0,24(a5)
    80000680:	60a2                	ld	ra,8(sp)
    80000682:	6402                	ld	s0,0(sp)
    80000684:	0141                	addi	sp,sp,16
    80000686:	8082                	ret
    else if (ktype == RECOVERY)
    80000688:	4785                	li	a5,1
    8000068a:	fef516e3          	bne	a0,a5,80000676 <find_kernel_entry_addr+0x18>
        kernel_elfhdr = (struct elfhdr *)RECOVERYDISK;
    8000068e:	008457b7          	lui	a5,0x845
    80000692:	07a2                	slli	a5,a5,0x8
    80000694:	00008717          	auipc	a4,0x8
    80000698:	60f73623          	sd	a5,1548(a4) # 80008ca0 <kernel_elfhdr>
    8000069c:	bfe9                	j	80000676 <find_kernel_entry_addr+0x18>

000000008000069e <sha256_transform>:
	0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};

/*********************** FUNCTION DEFINITIONS ***********************/
void sha256_transform(SHA256_CTX *ctx, const BYTE data[])
{
    8000069e:	714d                	addi	sp,sp,-336
    800006a0:	e686                	sd	ra,328(sp)
    800006a2:	e2a2                	sd	s0,320(sp)
    800006a4:	fe26                	sd	s1,312(sp)
    800006a6:	fa4a                	sd	s2,304(sp)
    800006a8:	f64e                	sd	s3,296(sp)
    800006aa:	f252                	sd	s4,288(sp)
    800006ac:	ee56                	sd	s5,280(sp)
    800006ae:	ea5a                	sd	s6,272(sp)
    800006b0:	e65e                	sd	s7,264(sp)
    800006b2:	e262                	sd	s8,256(sp)
    800006b4:	0a80                	addi	s0,sp,336
	WORD a, b, c, d, e, f, g, h, i, j, t1, t2, m[64];

	for (i = 0, j = 0; i < 16; ++i, j += 4)
    800006b6:	eb040313          	addi	t1,s0,-336
    800006ba:	ef040613          	addi	a2,s0,-272
{
    800006be:	869a                	mv	a3,t1
		m[i] = (data[j] << 24) | (data[j + 1] << 16) | (data[j + 2] << 8) | (data[j + 3]);
    800006c0:	0005c783          	lbu	a5,0(a1)
    800006c4:	0187979b          	slliw	a5,a5,0x18
    800006c8:	0015c703          	lbu	a4,1(a1)
    800006cc:	0107171b          	slliw	a4,a4,0x10
    800006d0:	8fd9                	or	a5,a5,a4
    800006d2:	0035c703          	lbu	a4,3(a1)
    800006d6:	8fd9                	or	a5,a5,a4
    800006d8:	0025c703          	lbu	a4,2(a1)
    800006dc:	0087171b          	slliw	a4,a4,0x8
    800006e0:	8fd9                	or	a5,a5,a4
    800006e2:	c29c                	sw	a5,0(a3)
	for (i = 0, j = 0; i < 16; ++i, j += 4)
    800006e4:	0591                	addi	a1,a1,4
    800006e6:	0691                	addi	a3,a3,4
    800006e8:	fcc69ce3          	bne	a3,a2,800006c0 <sha256_transform+0x22>
	for ( ; i < 64; ++i)
    800006ec:	0c030893          	addi	a7,t1,192 # 10c0 <_entry-0x7fffef40>
	for (i = 0, j = 0; i < 16; ++i, j += 4)
    800006f0:	869a                	mv	a3,t1
		m[i] = SIG1(m[i - 2]) + m[i - 7] + SIG0(m[i - 15]) + m[i - 16];
    800006f2:	5e98                	lw	a4,56(a3)
    800006f4:	42dc                	lw	a5,4(a3)
    800006f6:	0117561b          	srliw	a2,a4,0x11
    800006fa:	00f7159b          	slliw	a1,a4,0xf
    800006fe:	8e4d                	or	a2,a2,a1
    80000700:	0137559b          	srliw	a1,a4,0x13
    80000704:	00d7181b          	slliw	a6,a4,0xd
    80000708:	0105e5b3          	or	a1,a1,a6
    8000070c:	8e2d                	xor	a2,a2,a1
    8000070e:	00a7571b          	srliw	a4,a4,0xa
    80000712:	8f31                	xor	a4,a4,a2
    80000714:	52cc                	lw	a1,36(a3)
    80000716:	4290                	lw	a2,0(a3)
    80000718:	9e2d                	addw	a2,a2,a1
    8000071a:	9f31                	addw	a4,a4,a2
    8000071c:	0077d61b          	srliw	a2,a5,0x7
    80000720:	0197959b          	slliw	a1,a5,0x19
    80000724:	8e4d                	or	a2,a2,a1
    80000726:	0127d59b          	srliw	a1,a5,0x12
    8000072a:	00e7981b          	slliw	a6,a5,0xe
    8000072e:	0105e5b3          	or	a1,a1,a6
    80000732:	8e2d                	xor	a2,a2,a1
    80000734:	0037d79b          	srliw	a5,a5,0x3
    80000738:	8fb1                	xor	a5,a5,a2
    8000073a:	9fb9                	addw	a5,a5,a4
    8000073c:	c2bc                	sw	a5,64(a3)
	for ( ; i < 64; ++i)
    8000073e:	0691                	addi	a3,a3,4
    80000740:	fad899e3          	bne	a7,a3,800006f2 <sha256_transform+0x54>

	a = ctx->state[0];
    80000744:	05052b03          	lw	s6,80(a0)
	b = ctx->state[1];
    80000748:	05452a83          	lw	s5,84(a0)
	c = ctx->state[2];
    8000074c:	05852a03          	lw	s4,88(a0)
	d = ctx->state[3];
    80000750:	05c52983          	lw	s3,92(a0)
	e = ctx->state[4];
    80000754:	06052903          	lw	s2,96(a0)
	f = ctx->state[5];
    80000758:	5164                	lw	s1,100(a0)
	g = ctx->state[6];
    8000075a:	06852383          	lw	t2,104(a0)
	h = ctx->state[7];
    8000075e:	06c52283          	lw	t0,108(a0)

	for (i = 0; i < 64; ++i) {
    80000762:	00000817          	auipc	a6,0x0
    80000766:	39680813          	addi	a6,a6,918 # 80000af8 <k>
    8000076a:	00000f97          	auipc	t6,0x0
    8000076e:	48ef8f93          	addi	t6,t6,1166 # 80000bf8 <erodata>
	h = ctx->state[7];
    80000772:	8b96                	mv	s7,t0
	g = ctx->state[6];
    80000774:	8e1e                	mv	t3,t2
	f = ctx->state[5];
    80000776:	8ea6                	mv	t4,s1
	e = ctx->state[4];
    80000778:	86ca                	mv	a3,s2
	d = ctx->state[3];
    8000077a:	8f4e                	mv	t5,s3
	c = ctx->state[2];
    8000077c:	85d2                	mv	a1,s4
	b = ctx->state[1];
    8000077e:	88d6                	mv	a7,s5
	a = ctx->state[0];
    80000780:	865a                	mv	a2,s6
    80000782:	a039                	j	80000790 <sha256_transform+0xf2>
    80000784:	8e76                	mv	t3,t4
    80000786:	8eb6                	mv	t4,a3
    80000788:	86e2                	mv	a3,s8
    8000078a:	85c6                	mv	a1,a7
    8000078c:	88b2                	mv	a7,a2
    8000078e:	863e                	mv	a2,a5
		t1 = h + EP1(e) + CH(e,f,g) + k[i] + m[i];
    80000790:	0066d71b          	srliw	a4,a3,0x6
    80000794:	01a6979b          	slliw	a5,a3,0x1a
    80000798:	8f5d                	or	a4,a4,a5
    8000079a:	00b6d79b          	srliw	a5,a3,0xb
    8000079e:	01569c1b          	slliw	s8,a3,0x15
    800007a2:	0187e7b3          	or	a5,a5,s8
    800007a6:	8f3d                	xor	a4,a4,a5
    800007a8:	0196d79b          	srliw	a5,a3,0x19
    800007ac:	00769c1b          	slliw	s8,a3,0x7
    800007b0:	0187e7b3          	or	a5,a5,s8
    800007b4:	8f3d                	xor	a4,a4,a5
    800007b6:	00082c03          	lw	s8,0(a6)
    800007ba:	00032783          	lw	a5,0(t1)
    800007be:	018787bb          	addw	a5,a5,s8
    800007c2:	9fb9                	addw	a5,a5,a4
    800007c4:	fff6c713          	not	a4,a3
    800007c8:	01c77733          	and	a4,a4,t3
    800007cc:	01d6fc33          	and	s8,a3,t4
    800007d0:	01874733          	xor	a4,a4,s8
    800007d4:	9fb9                	addw	a5,a5,a4
    800007d6:	017787bb          	addw	a5,a5,s7
		t2 = EP0(a) + MAJ(a,b,c);
    800007da:	0026571b          	srliw	a4,a2,0x2
    800007de:	01e61b9b          	slliw	s7,a2,0x1e
    800007e2:	01776733          	or	a4,a4,s7
    800007e6:	00d65b9b          	srliw	s7,a2,0xd
    800007ea:	01361c1b          	slliw	s8,a2,0x13
    800007ee:	018bebb3          	or	s7,s7,s8
    800007f2:	01774733          	xor	a4,a4,s7
    800007f6:	01665b9b          	srliw	s7,a2,0x16
    800007fa:	00a61c1b          	slliw	s8,a2,0xa
    800007fe:	018bebb3          	or	s7,s7,s8
    80000802:	01774733          	xor	a4,a4,s7
    80000806:	00b8cbb3          	xor	s7,a7,a1
    8000080a:	01767bb3          	and	s7,a2,s7
    8000080e:	00b8fc33          	and	s8,a7,a1
    80000812:	018bcbb3          	xor	s7,s7,s8
    80000816:	0177073b          	addw	a4,a4,s7
		h = g;
		g = f;
		f = e;
		e = d + t1;
    8000081a:	01e78c3b          	addw	s8,a5,t5
		d = c;
		c = b;
		b = a;
		a = t1 + t2;
    8000081e:	9fb9                	addw	a5,a5,a4
	for (i = 0; i < 64; ++i) {
    80000820:	0811                	addi	a6,a6,4
    80000822:	0311                	addi	t1,t1,4
    80000824:	8f2e                	mv	t5,a1
    80000826:	8bf2                	mv	s7,t3
    80000828:	f5f81ee3          	bne	a6,t6,80000784 <sha256_transform+0xe6>
	}

	ctx->state[0] += a;
    8000082c:	00fb0b3b          	addw	s6,s6,a5
    80000830:	05652823          	sw	s6,80(a0)
	ctx->state[1] += b;
    80000834:	00ca8abb          	addw	s5,s5,a2
    80000838:	05552a23          	sw	s5,84(a0)
	ctx->state[2] += c;
    8000083c:	011a0a3b          	addw	s4,s4,a7
    80000840:	05452c23          	sw	s4,88(a0)
	ctx->state[3] += d;
    80000844:	00b989bb          	addw	s3,s3,a1
    80000848:	05352e23          	sw	s3,92(a0)
	ctx->state[4] += e;
    8000084c:	0189093b          	addw	s2,s2,s8
    80000850:	07252023          	sw	s2,96(a0)
	ctx->state[5] += f;
    80000854:	9cb5                	addw	s1,s1,a3
    80000856:	d164                	sw	s1,100(a0)
	ctx->state[6] += g;
    80000858:	01d383bb          	addw	t2,t2,t4
    8000085c:	06752423          	sw	t2,104(a0)
	ctx->state[7] += h;
    80000860:	01c282bb          	addw	t0,t0,t3
    80000864:	06552623          	sw	t0,108(a0)
}
    80000868:	60b6                	ld	ra,328(sp)
    8000086a:	6416                	ld	s0,320(sp)
    8000086c:	74f2                	ld	s1,312(sp)
    8000086e:	7952                	ld	s2,304(sp)
    80000870:	79b2                	ld	s3,296(sp)
    80000872:	7a12                	ld	s4,288(sp)
    80000874:	6af2                	ld	s5,280(sp)
    80000876:	6b52                	ld	s6,272(sp)
    80000878:	6bb2                	ld	s7,264(sp)
    8000087a:	6c12                	ld	s8,256(sp)
    8000087c:	6171                	addi	sp,sp,336
    8000087e:	8082                	ret

0000000080000880 <sha256_init>:

void sha256_init(SHA256_CTX *ctx)
{
    80000880:	1141                	addi	sp,sp,-16
    80000882:	e406                	sd	ra,8(sp)
    80000884:	e022                	sd	s0,0(sp)
    80000886:	0800                	addi	s0,sp,16
	ctx->datalen = 0;
    80000888:	04052023          	sw	zero,64(a0)
	ctx->bitlen = 0;
    8000088c:	04053423          	sd	zero,72(a0)
	ctx->state[0] = 0x6a09e667;
    80000890:	6a09e7b7          	lui	a5,0x6a09e
    80000894:	66778793          	addi	a5,a5,1639 # 6a09e667 <_entry-0x15f61999>
    80000898:	c93c                	sw	a5,80(a0)
	ctx->state[1] = 0xbb67ae85;
    8000089a:	bb67b7b7          	lui	a5,0xbb67b
    8000089e:	e8578793          	addi	a5,a5,-379 # ffffffffbb67ae85 <kernel_elfhdr+0xffffffff3b6721e5>
    800008a2:	c97c                	sw	a5,84(a0)
	ctx->state[2] = 0x3c6ef372;
    800008a4:	3c6ef7b7          	lui	a5,0x3c6ef
    800008a8:	37278793          	addi	a5,a5,882 # 3c6ef372 <_entry-0x43910c8e>
    800008ac:	cd3c                	sw	a5,88(a0)
	ctx->state[3] = 0xa54ff53a;
    800008ae:	a54ff7b7          	lui	a5,0xa54ff
    800008b2:	53a78793          	addi	a5,a5,1338 # ffffffffa54ff53a <kernel_elfhdr+0xffffffff254f689a>
    800008b6:	cd7c                	sw	a5,92(a0)
	ctx->state[4] = 0x510e527f;
    800008b8:	510e57b7          	lui	a5,0x510e5
    800008bc:	27f78793          	addi	a5,a5,639 # 510e527f <_entry-0x2ef1ad81>
    800008c0:	d13c                	sw	a5,96(a0)
	ctx->state[5] = 0x9b05688c;
    800008c2:	9b0577b7          	lui	a5,0x9b057
    800008c6:	88c78793          	addi	a5,a5,-1908 # ffffffff9b05688c <kernel_elfhdr+0xffffffff1b04dbec>
    800008ca:	d17c                	sw	a5,100(a0)
	ctx->state[6] = 0x1f83d9ab;
    800008cc:	1f83e7b7          	lui	a5,0x1f83e
    800008d0:	9ab78793          	addi	a5,a5,-1621 # 1f83d9ab <_entry-0x607c2655>
    800008d4:	d53c                	sw	a5,104(a0)
	ctx->state[7] = 0x5be0cd19;
    800008d6:	5be0d7b7          	lui	a5,0x5be0d
    800008da:	d1978793          	addi	a5,a5,-743 # 5be0cd19 <_entry-0x241f32e7>
    800008de:	d57c                	sw	a5,108(a0)
}
    800008e0:	60a2                	ld	ra,8(sp)
    800008e2:	6402                	ld	s0,0(sp)
    800008e4:	0141                	addi	sp,sp,16
    800008e6:	8082                	ret

00000000800008e8 <sha256_update>:

void sha256_update(SHA256_CTX *ctx, const BYTE data[], size_t len)
{
	WORD i;

	for (i = 0; i < len; ++i) {
    800008e8:	ce25                	beqz	a2,80000960 <sha256_update+0x78>
{
    800008ea:	7139                	addi	sp,sp,-64
    800008ec:	fc06                	sd	ra,56(sp)
    800008ee:	f822                	sd	s0,48(sp)
    800008f0:	f426                	sd	s1,40(sp)
    800008f2:	f04a                	sd	s2,32(sp)
    800008f4:	ec4e                	sd	s3,24(sp)
    800008f6:	e852                	sd	s4,16(sp)
    800008f8:	e456                	sd	s5,8(sp)
    800008fa:	0080                	addi	s0,sp,64
    800008fc:	84aa                	mv	s1,a0
    800008fe:	8a2e                	mv	s4,a1
    80000900:	89b2                	mv	s3,a2
	for (i = 0; i < len; ++i) {
    80000902:	4901                	li	s2,0
    80000904:	4781                	li	a5,0
		ctx->data[ctx->datalen] = data[i];
		ctx->datalen++;
		if (ctx->datalen == 64) {
    80000906:	04000a93          	li	s5,64
    8000090a:	a801                	j	8000091a <sha256_update+0x32>
	for (i = 0; i < len; ++i) {
    8000090c:	0019079b          	addiw	a5,s2,1
    80000910:	893e                	mv	s2,a5
    80000912:	1782                	slli	a5,a5,0x20
    80000914:	9381                	srli	a5,a5,0x20
    80000916:	0337fc63          	bgeu	a5,s3,8000094e <sha256_update+0x66>
		ctx->data[ctx->datalen] = data[i];
    8000091a:	40b8                	lw	a4,64(s1)
    8000091c:	97d2                	add	a5,a5,s4
    8000091e:	0007c683          	lbu	a3,0(a5)
    80000922:	02071793          	slli	a5,a4,0x20
    80000926:	9381                	srli	a5,a5,0x20
    80000928:	97a6                	add	a5,a5,s1
    8000092a:	00d78023          	sb	a3,0(a5)
		ctx->datalen++;
    8000092e:	0017079b          	addiw	a5,a4,1
    80000932:	c0bc                	sw	a5,64(s1)
		if (ctx->datalen == 64) {
    80000934:	fd579ce3          	bne	a5,s5,8000090c <sha256_update+0x24>
			sha256_transform(ctx, ctx->data);
    80000938:	85a6                	mv	a1,s1
    8000093a:	8526                	mv	a0,s1
    8000093c:	d63ff0ef          	jal	8000069e <sha256_transform>
			ctx->bitlen += 512;
    80000940:	64bc                	ld	a5,72(s1)
    80000942:	20078793          	addi	a5,a5,512
    80000946:	e4bc                	sd	a5,72(s1)
			ctx->datalen = 0;
    80000948:	0404a023          	sw	zero,64(s1)
    8000094c:	b7c1                	j	8000090c <sha256_update+0x24>
		}
	}
}
    8000094e:	70e2                	ld	ra,56(sp)
    80000950:	7442                	ld	s0,48(sp)
    80000952:	74a2                	ld	s1,40(sp)
    80000954:	7902                	ld	s2,32(sp)
    80000956:	69e2                	ld	s3,24(sp)
    80000958:	6a42                	ld	s4,16(sp)
    8000095a:	6aa2                	ld	s5,8(sp)
    8000095c:	6121                	addi	sp,sp,64
    8000095e:	8082                	ret
    80000960:	8082                	ret

0000000080000962 <sha256_final>:

void sha256_final(SHA256_CTX *ctx, BYTE hash[])
{
    80000962:	1101                	addi	sp,sp,-32
    80000964:	ec06                	sd	ra,24(sp)
    80000966:	e822                	sd	s0,16(sp)
    80000968:	e426                	sd	s1,8(sp)
    8000096a:	e04a                	sd	s2,0(sp)
    8000096c:	1000                	addi	s0,sp,32
    8000096e:	84aa                	mv	s1,a0
    80000970:	892e                	mv	s2,a1
	WORD i;

	i = ctx->datalen;
    80000972:	4134                	lw	a3,64(a0)

	// Pad whatever data is left in the buffer.
	if (ctx->datalen < 56) {
    80000974:	03700793          	li	a5,55
    80000978:	04d7e563          	bltu	a5,a3,800009c2 <sha256_final+0x60>
		ctx->data[i++] = 0x80;
    8000097c:	0016879b          	addiw	a5,a3,1
    80000980:	02069713          	slli	a4,a3,0x20
    80000984:	9301                	srli	a4,a4,0x20
    80000986:	972a                	add	a4,a4,a0
    80000988:	f8000613          	li	a2,-128
    8000098c:	00c70023          	sb	a2,0(a4)
		while (i < 56)
    80000990:	03700713          	li	a4,55
    80000994:	08f76363          	bltu	a4,a5,80000a1a <sha256_final+0xb8>
    80000998:	02079613          	slli	a2,a5,0x20
    8000099c:	9201                	srli	a2,a2,0x20
    8000099e:	00c507b3          	add	a5,a0,a2
    800009a2:	00150713          	addi	a4,a0,1
    800009a6:	9732                	add	a4,a4,a2
    800009a8:	03600613          	li	a2,54
    800009ac:	40d606bb          	subw	a3,a2,a3
    800009b0:	1682                	slli	a3,a3,0x20
    800009b2:	9281                	srli	a3,a3,0x20
    800009b4:	9736                	add	a4,a4,a3
			ctx->data[i++] = 0x00;
    800009b6:	00078023          	sb	zero,0(a5)
		while (i < 56)
    800009ba:	0785                	addi	a5,a5,1
    800009bc:	fee79de3          	bne	a5,a4,800009b6 <sha256_final+0x54>
    800009c0:	a8a9                	j	80000a1a <sha256_final+0xb8>
	}
	else {
		ctx->data[i++] = 0x80;
    800009c2:	0016879b          	addiw	a5,a3,1
    800009c6:	02069713          	slli	a4,a3,0x20
    800009ca:	9301                	srli	a4,a4,0x20
    800009cc:	972a                	add	a4,a4,a0
    800009ce:	f8000613          	li	a2,-128
    800009d2:	00c70023          	sb	a2,0(a4)
		while (i < 64)
    800009d6:	03f00713          	li	a4,63
    800009da:	02f76663          	bltu	a4,a5,80000a06 <sha256_final+0xa4>
    800009de:	02079613          	slli	a2,a5,0x20
    800009e2:	9201                	srli	a2,a2,0x20
    800009e4:	00c507b3          	add	a5,a0,a2
    800009e8:	00150713          	addi	a4,a0,1
    800009ec:	9732                	add	a4,a4,a2
    800009ee:	03e00613          	li	a2,62
    800009f2:	40d606bb          	subw	a3,a2,a3
    800009f6:	1682                	slli	a3,a3,0x20
    800009f8:	9281                	srli	a3,a3,0x20
    800009fa:	9736                	add	a4,a4,a3
			ctx->data[i++] = 0x00;
    800009fc:	00078023          	sb	zero,0(a5)
		while (i < 64)
    80000a00:	0785                	addi	a5,a5,1
    80000a02:	fee79de3          	bne	a5,a4,800009fc <sha256_final+0x9a>
		sha256_transform(ctx, ctx->data);
    80000a06:	85a6                	mv	a1,s1
    80000a08:	8526                	mv	a0,s1
    80000a0a:	c95ff0ef          	jal	8000069e <sha256_transform>
		memset(ctx->data, 0, 56);
    80000a0e:	03800613          	li	a2,56
    80000a12:	4581                	li	a1,0
    80000a14:	8526                	mv	a0,s1
    80000a16:	9e1ff0ef          	jal	800003f6 <memset>
	}

	// Append to the padding the total message's length in bits and transform.
	ctx->bitlen += ctx->datalen * 8;
    80000a1a:	40bc                	lw	a5,64(s1)
    80000a1c:	0037979b          	slliw	a5,a5,0x3
    80000a20:	1782                	slli	a5,a5,0x20
    80000a22:	9381                	srli	a5,a5,0x20
    80000a24:	64b8                	ld	a4,72(s1)
    80000a26:	97ba                	add	a5,a5,a4
    80000a28:	e4bc                	sd	a5,72(s1)
	ctx->data[63] = ctx->bitlen;
    80000a2a:	02f48fa3          	sb	a5,63(s1)
	ctx->data[62] = ctx->bitlen >> 8;
    80000a2e:	0087d713          	srli	a4,a5,0x8
    80000a32:	02e48f23          	sb	a4,62(s1)
	ctx->data[61] = ctx->bitlen >> 16;
    80000a36:	0107d713          	srli	a4,a5,0x10
    80000a3a:	02e48ea3          	sb	a4,61(s1)
	ctx->data[60] = ctx->bitlen >> 24;
    80000a3e:	0187d713          	srli	a4,a5,0x18
    80000a42:	02e48e23          	sb	a4,60(s1)
	ctx->data[59] = ctx->bitlen >> 32;
    80000a46:	0207d713          	srli	a4,a5,0x20
    80000a4a:	02e48da3          	sb	a4,59(s1)
	ctx->data[58] = ctx->bitlen >> 40;
    80000a4e:	0287d713          	srli	a4,a5,0x28
    80000a52:	02e48d23          	sb	a4,58(s1)
	ctx->data[57] = ctx->bitlen >> 48;
    80000a56:	0307d713          	srli	a4,a5,0x30
    80000a5a:	02e48ca3          	sb	a4,57(s1)
	ctx->data[56] = ctx->bitlen >> 56;
    80000a5e:	93e1                	srli	a5,a5,0x38
    80000a60:	02f48c23          	sb	a5,56(s1)
	sha256_transform(ctx, ctx->data);
    80000a64:	85a6                	mv	a1,s1
    80000a66:	8526                	mv	a0,s1
    80000a68:	c37ff0ef          	jal	8000069e <sha256_transform>

	// Since this implementation uses little endian byte ordering and SHA uses big endian,
	// reverse all the bytes when copying the final state to the output hash.
	for (i = 0; i < 4; ++i) {
    80000a6c:	85ca                	mv	a1,s2
	sha256_transform(ctx, ctx->data);
    80000a6e:	47e1                	li	a5,24
	for (i = 0; i < 4; ++i) {
    80000a70:	56e1                	li	a3,-8
		hash[i]      = (ctx->state[0] >> (24 - i * 8)) & 0x000000ff;
    80000a72:	48b8                	lw	a4,80(s1)
    80000a74:	00f7573b          	srlw	a4,a4,a5
    80000a78:	00e58023          	sb	a4,0(a1)
		hash[i + 4]  = (ctx->state[1] >> (24 - i * 8)) & 0x000000ff;
    80000a7c:	48f8                	lw	a4,84(s1)
    80000a7e:	00f7573b          	srlw	a4,a4,a5
    80000a82:	00e58223          	sb	a4,4(a1)
		hash[i + 8]  = (ctx->state[2] >> (24 - i * 8)) & 0x000000ff;
    80000a86:	4cb8                	lw	a4,88(s1)
    80000a88:	00f7573b          	srlw	a4,a4,a5
    80000a8c:	00e58423          	sb	a4,8(a1)
		hash[i + 12] = (ctx->state[3] >> (24 - i * 8)) & 0x000000ff;
    80000a90:	4cf8                	lw	a4,92(s1)
    80000a92:	00f7573b          	srlw	a4,a4,a5
    80000a96:	00e58623          	sb	a4,12(a1)
		hash[i + 16] = (ctx->state[4] >> (24 - i * 8)) & 0x000000ff;
    80000a9a:	50b8                	lw	a4,96(s1)
    80000a9c:	00f7573b          	srlw	a4,a4,a5
    80000aa0:	00e58823          	sb	a4,16(a1)
		hash[i + 20] = (ctx->state[5] >> (24 - i * 8)) & 0x000000ff;
    80000aa4:	50f8                	lw	a4,100(s1)
    80000aa6:	00f7573b          	srlw	a4,a4,a5
    80000aaa:	00e58a23          	sb	a4,20(a1)
		hash[i + 24] = (ctx->state[6] >> (24 - i * 8)) & 0x000000ff;
    80000aae:	54b8                	lw	a4,104(s1)
    80000ab0:	00f7573b          	srlw	a4,a4,a5
    80000ab4:	00e58c23          	sb	a4,24(a1)
		hash[i + 28] = (ctx->state[7] >> (24 - i * 8)) & 0x000000ff;
    80000ab8:	54f8                	lw	a4,108(s1)
    80000aba:	00f7573b          	srlw	a4,a4,a5
    80000abe:	00e58e23          	sb	a4,28(a1)
	for (i = 0; i < 4; ++i) {
    80000ac2:	37e1                	addiw	a5,a5,-8
    80000ac4:	0585                	addi	a1,a1,1
    80000ac6:	fad796e3          	bne	a5,a3,80000a72 <sha256_final+0x110>
	}
    80000aca:	60e2                	ld	ra,24(sp)
    80000acc:	6442                	ld	s0,16(sp)
    80000ace:	64a2                	ld	s1,8(sp)
    80000ad0:	6902                	ld	s2,0(sp)
    80000ad2:	6105                	addi	sp,sp,32
    80000ad4:	8082                	ret
