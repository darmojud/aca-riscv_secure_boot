
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00007797          	auipc	a5,0x7
      14:	63878793          	addi	a5,a5,1592 # 7648 <malloc+0x248a>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	739c                	ld	a5,32(a5)
      22:	fab43423          	sd	a1,-88(s0)
      26:	fac43823          	sd	a2,-80(s0)
      2a:	fad43c23          	sd	a3,-72(s0)
      2e:	fce43023          	sd	a4,-64(s0)
      32:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	4fb040ef          	jal	4d44 <open>
    if(fd >= 0){
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00005517          	auipc	a0,0x5
      70:	24450513          	addi	a0,a0,580 # 52b0 <malloc+0xf2>
      74:	092050ef          	jal	5106 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	48b040ef          	jal	4d04 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      7e:	00009797          	auipc	a5,0x9
      82:	4ea78793          	addi	a5,a5,1258 # 9568 <uninit>
      86:	0000c697          	auipc	a3,0xc
      8a:	bf268693          	addi	a3,a3,-1038 # bc78 <buf>
    if(uninit[i] != '\0'){
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00005517          	auipc	a0,0x5
      aa:	22a50513          	addi	a0,a0,554 # 52d0 <malloc+0x112>
      ae:	058050ef          	jal	5106 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	451040ef          	jal	4d04 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00005517          	auipc	a0,0x5
      ca:	22250513          	addi	a0,a0,546 # 52e8 <malloc+0x12a>
      ce:	477040ef          	jal	4d44 <open>
  if(fd < 0){
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	457040ef          	jal	4d2c <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	22c50513          	addi	a0,a0,556 # 5308 <malloc+0x14a>
      e4:	461040ef          	jal	4d44 <open>
  if(fd >= 0){
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00005517          	auipc	a0,0x5
      fc:	1f850513          	addi	a0,a0,504 # 52f0 <malloc+0x132>
     100:	006050ef          	jal	5106 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	3ff040ef          	jal	4d04 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	20c50513          	addi	a0,a0,524 # 5318 <malloc+0x15a>
     114:	7f3040ef          	jal	5106 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	3eb040ef          	jal	4d04 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00005517          	auipc	a0,0x5
     132:	21250513          	addi	a0,a0,530 # 5340 <malloc+0x182>
     136:	41f040ef          	jal	4d54 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	20250513          	addi	a0,a0,514 # 5340 <malloc+0x182>
     146:	3ff040ef          	jal	4d44 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	20258593          	addi	a1,a1,514 # 5350 <malloc+0x192>
     156:	3cf040ef          	jal	4d24 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	1e250513          	addi	a0,a0,482 # 5340 <malloc+0x182>
     166:	3df040ef          	jal	4d44 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	1ea58593          	addi	a1,a1,490 # 5358 <malloc+0x19a>
     176:	8526                	mv	a0,s1
     178:	3ad040ef          	jal	4d24 <write>
  if(n != -1){
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	1be50513          	addi	a0,a0,446 # 5340 <malloc+0x182>
     18a:	3cb040ef          	jal	4d54 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	39d040ef          	jal	4d2c <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	397040ef          	jal	4d2c <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00005517          	auipc	a0,0x5
     1b0:	1b450513          	addi	a0,a0,436 # 5360 <malloc+0x1a2>
     1b4:	753040ef          	jal	5106 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	34b040ef          	jal	4d04 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	353040ef          	jal	4d44 <open>
    close(fd);
     1f6:	337040ef          	jal	4d2c <close>
  for(i = 0; i < N; i++){
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	333040ef          	jal	4d54 <unlink>
  for(i = 0; i < N; i++){
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	715d                	addi	sp,sp,-80
     242:	e486                	sd	ra,72(sp)
     244:	e0a2                	sd	s0,64(sp)
     246:	fc26                	sd	s1,56(sp)
     248:	f84a                	sd	s2,48(sp)
     24a:	f44e                	sd	s3,40(sp)
     24c:	f052                	sd	s4,32(sp)
     24e:	ec56                	sd	s5,24(sp)
     250:	e85a                	sd	s6,16(sp)
     252:	e45e                	sd	s7,8(sp)
     254:	e062                	sd	s8,0(sp)
     256:	0880                	addi	s0,sp,80
     258:	8c2a                	mv	s8,a0
  unlink("bigwrite");
     25a:	00005517          	auipc	a0,0x5
     25e:	12e50513          	addi	a0,a0,302 # 5388 <malloc+0x1ca>
     262:	2f3040ef          	jal	4d54 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     266:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200b93          	li	s7,514
     26e:	00005a97          	auipc	s5,0x5
     272:	11aa8a93          	addi	s5,s5,282 # 5388 <malloc+0x1ca>
      int cc = write(fd, buf, sz);
     276:	0000ca17          	auipc	s4,0xc
     27a:	a02a0a13          	addi	s4,s4,-1534 # bc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     27e:	6b0d                	lui	s6,0x3
     280:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x4cb>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     284:	85de                	mv	a1,s7
     286:	8556                	mv	a0,s5
     288:	2bd040ef          	jal	4d44 <open>
     28c:	892a                	mv	s2,a0
    if(fd < 0){
     28e:	04054663          	bltz	a0,2da <bigwrite+0x9a>
      int cc = write(fd, buf, sz);
     292:	8626                	mv	a2,s1
     294:	85d2                	mv	a1,s4
     296:	28f040ef          	jal	4d24 <write>
     29a:	89aa                	mv	s3,a0
      if(cc != sz){
     29c:	04a49963          	bne	s1,a0,2ee <bigwrite+0xae>
      int cc = write(fd, buf, sz);
     2a0:	8626                	mv	a2,s1
     2a2:	85d2                	mv	a1,s4
     2a4:	854a                	mv	a0,s2
     2a6:	27f040ef          	jal	4d24 <write>
      if(cc != sz){
     2aa:	04951363          	bne	a0,s1,2f0 <bigwrite+0xb0>
    close(fd);
     2ae:	854a                	mv	a0,s2
     2b0:	27d040ef          	jal	4d2c <close>
    unlink("bigwrite");
     2b4:	8556                	mv	a0,s5
     2b6:	29f040ef          	jal	4d54 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2ba:	1d74849b          	addiw	s1,s1,471
     2be:	fd6493e3          	bne	s1,s6,284 <bigwrite+0x44>
}
     2c2:	60a6                	ld	ra,72(sp)
     2c4:	6406                	ld	s0,64(sp)
     2c6:	74e2                	ld	s1,56(sp)
     2c8:	7942                	ld	s2,48(sp)
     2ca:	79a2                	ld	s3,40(sp)
     2cc:	7a02                	ld	s4,32(sp)
     2ce:	6ae2                	ld	s5,24(sp)
     2d0:	6b42                	ld	s6,16(sp)
     2d2:	6ba2                	ld	s7,8(sp)
     2d4:	6c02                	ld	s8,0(sp)
     2d6:	6161                	addi	sp,sp,80
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e2                	mv	a1,s8
     2dc:	00005517          	auipc	a0,0x5
     2e0:	0bc50513          	addi	a0,a0,188 # 5398 <malloc+0x1da>
     2e4:	623040ef          	jal	5106 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	21b040ef          	jal	4d04 <exit>
      if(cc != sz){
     2ee:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2f0:	86aa                	mv	a3,a0
     2f2:	864e                	mv	a2,s3
     2f4:	85e2                	mv	a1,s8
     2f6:	00005517          	auipc	a0,0x5
     2fa:	0c250513          	addi	a0,a0,194 # 53b8 <malloc+0x1fa>
     2fe:	609040ef          	jal	5106 <printf>
        exit(1);
     302:	4505                	li	a0,1
     304:	201040ef          	jal	4d04 <exit>

0000000000000308 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     308:	7139                	addi	sp,sp,-64
     30a:	fc06                	sd	ra,56(sp)
     30c:	f822                	sd	s0,48(sp)
     30e:	f426                	sd	s1,40(sp)
     310:	f04a                	sd	s2,32(sp)
     312:	ec4e                	sd	s3,24(sp)
     314:	e852                	sd	s4,16(sp)
     316:	e456                	sd	s5,8(sp)
     318:	e05a                	sd	s6,0(sp)
     31a:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
     31c:	00005517          	auipc	a0,0x5
     320:	0b450513          	addi	a0,a0,180 # 53d0 <malloc+0x212>
     324:	231040ef          	jal	4d54 <unlink>
     328:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     32c:	20100a93          	li	s5,513
     330:	00005997          	auipc	s3,0x5
     334:	0a098993          	addi	s3,s3,160 # 53d0 <malloc+0x212>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     338:	4b05                	li	s6,1
     33a:	5a7d                	li	s4,-1
     33c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     340:	85d6                	mv	a1,s5
     342:	854e                	mv	a0,s3
     344:	201040ef          	jal	4d44 <open>
     348:	84aa                	mv	s1,a0
    if(fd < 0){
     34a:	04054d63          	bltz	a0,3a4 <badwrite+0x9c>
    write(fd, (char*)0xffffffffffL, 1);
     34e:	865a                	mv	a2,s6
     350:	85d2                	mv	a1,s4
     352:	1d3040ef          	jal	4d24 <write>
    close(fd);
     356:	8526                	mv	a0,s1
     358:	1d5040ef          	jal	4d2c <close>
    unlink("junk");
     35c:	854e                	mv	a0,s3
     35e:	1f7040ef          	jal	4d54 <unlink>
  for(int i = 0; i < assumed_free; i++){
     362:	397d                	addiw	s2,s2,-1
     364:	fc091ee3          	bnez	s2,340 <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     368:	20100593          	li	a1,513
     36c:	00005517          	auipc	a0,0x5
     370:	06450513          	addi	a0,a0,100 # 53d0 <malloc+0x212>
     374:	1d1040ef          	jal	4d44 <open>
     378:	84aa                	mv	s1,a0
  if(fd < 0){
     37a:	02054e63          	bltz	a0,3b6 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     37e:	4605                	li	a2,1
     380:	00005597          	auipc	a1,0x5
     384:	fd858593          	addi	a1,a1,-40 # 5358 <malloc+0x19a>
     388:	19d040ef          	jal	4d24 <write>
     38c:	4785                	li	a5,1
     38e:	02f50d63          	beq	a0,a5,3c8 <badwrite+0xc0>
    printf("write failed\n");
     392:	00005517          	auipc	a0,0x5
     396:	05e50513          	addi	a0,a0,94 # 53f0 <malloc+0x232>
     39a:	56d040ef          	jal	5106 <printf>
    exit(1);
     39e:	4505                	li	a0,1
     3a0:	165040ef          	jal	4d04 <exit>
      printf("open junk failed\n");
     3a4:	00005517          	auipc	a0,0x5
     3a8:	03450513          	addi	a0,a0,52 # 53d8 <malloc+0x21a>
     3ac:	55b040ef          	jal	5106 <printf>
      exit(1);
     3b0:	4505                	li	a0,1
     3b2:	153040ef          	jal	4d04 <exit>
    printf("open junk failed\n");
     3b6:	00005517          	auipc	a0,0x5
     3ba:	02250513          	addi	a0,a0,34 # 53d8 <malloc+0x21a>
     3be:	549040ef          	jal	5106 <printf>
    exit(1);
     3c2:	4505                	li	a0,1
     3c4:	141040ef          	jal	4d04 <exit>
  }
  close(fd);
     3c8:	8526                	mv	a0,s1
     3ca:	163040ef          	jal	4d2c <close>
  unlink("junk");
     3ce:	00005517          	auipc	a0,0x5
     3d2:	00250513          	addi	a0,a0,2 # 53d0 <malloc+0x212>
     3d6:	17f040ef          	jal	4d54 <unlink>

  exit(0);
     3da:	4501                	li	a0,0
     3dc:	129040ef          	jal	4d04 <exit>

00000000000003e0 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3e0:	711d                	addi	sp,sp,-96
     3e2:	ec86                	sd	ra,88(sp)
     3e4:	e8a2                	sd	s0,80(sp)
     3e6:	e4a6                	sd	s1,72(sp)
     3e8:	e0ca                	sd	s2,64(sp)
     3ea:	fc4e                	sd	s3,56(sp)
     3ec:	f852                	sd	s4,48(sp)
     3ee:	f456                	sd	s5,40(sp)
     3f0:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3f2:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f4:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f8:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     3fc:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     400:	40000a93          	li	s5,1024
    name[0] = 'z';
     404:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     408:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40c:	41f4d71b          	sraiw	a4,s1,0x1f
     410:	01b7571b          	srliw	a4,a4,0x1b
     414:	009707bb          	addw	a5,a4,s1
     418:	4057d69b          	sraiw	a3,a5,0x5
     41c:	0306869b          	addiw	a3,a3,48
     420:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     424:	8bfd                	andi	a5,a5,31
     426:	9f99                	subw	a5,a5,a4
     428:	0307879b          	addiw	a5,a5,48
     42c:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     430:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     434:	854a                	mv	a0,s2
     436:	11f040ef          	jal	4d54 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     43a:	85d2                	mv	a1,s4
     43c:	854a                	mv	a0,s2
     43e:	107040ef          	jal	4d44 <open>
    if(fd < 0){
     442:	00054763          	bltz	a0,450 <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     446:	0e7040ef          	jal	4d2c <close>
  for(int i = 0; i < nzz; i++){
     44a:	2485                	addiw	s1,s1,1
     44c:	fb549ce3          	bne	s1,s5,404 <outofinodes+0x24>
     450:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     452:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     456:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     45a:	40000993          	li	s3,1024
    name[0] = 'z';
     45e:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     462:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     466:	41f4d71b          	sraiw	a4,s1,0x1f
     46a:	01b7571b          	srliw	a4,a4,0x1b
     46e:	009707bb          	addw	a5,a4,s1
     472:	4057d69b          	sraiw	a3,a5,0x5
     476:	0306869b          	addiw	a3,a3,48
     47a:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47e:	8bfd                	andi	a5,a5,31
     480:	9f99                	subw	a5,a5,a4
     482:	0307879b          	addiw	a5,a5,48
     486:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     48a:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48e:	8552                	mv	a0,s4
     490:	0c5040ef          	jal	4d54 <unlink>
  for(int i = 0; i < nzz; i++){
     494:	2485                	addiw	s1,s1,1
     496:	fd3494e3          	bne	s1,s3,45e <outofinodes+0x7e>
  }
}
     49a:	60e6                	ld	ra,88(sp)
     49c:	6446                	ld	s0,80(sp)
     49e:	64a6                	ld	s1,72(sp)
     4a0:	6906                	ld	s2,64(sp)
     4a2:	79e2                	ld	s3,56(sp)
     4a4:	7a42                	ld	s4,48(sp)
     4a6:	7aa2                	ld	s5,40(sp)
     4a8:	6125                	addi	sp,sp,96
     4aa:	8082                	ret

00000000000004ac <copyin>:
{
     4ac:	7175                	addi	sp,sp,-144
     4ae:	e506                	sd	ra,136(sp)
     4b0:	e122                	sd	s0,128(sp)
     4b2:	fca6                	sd	s1,120(sp)
     4b4:	f8ca                	sd	s2,112(sp)
     4b6:	f4ce                	sd	s3,104(sp)
     4b8:	f0d2                	sd	s4,96(sp)
     4ba:	ecd6                	sd	s5,88(sp)
     4bc:	e8da                	sd	s6,80(sp)
     4be:	e4de                	sd	s7,72(sp)
     4c0:	e0e2                	sd	s8,64(sp)
     4c2:	fc66                	sd	s9,56(sp)
     4c4:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c6:	00007797          	auipc	a5,0x7
     4ca:	18278793          	addi	a5,a5,386 # 7648 <malloc+0x248a>
     4ce:	638c                	ld	a1,0(a5)
     4d0:	6790                	ld	a2,8(a5)
     4d2:	6b94                	ld	a3,16(a5)
     4d4:	6f98                	ld	a4,24(a5)
     4d6:	739c                	ld	a5,32(a5)
     4d8:	f6b43c23          	sd	a1,-136(s0)
     4dc:	f8c43023          	sd	a2,-128(s0)
     4e0:	f8d43423          	sd	a3,-120(s0)
     4e4:	f8e43823          	sd	a4,-112(s0)
     4e8:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4ec:	f7840913          	addi	s2,s0,-136
     4f0:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4f4:	20100b13          	li	s6,513
     4f8:	00005a97          	auipc	s5,0x5
     4fc:	f08a8a93          	addi	s5,s5,-248 # 5400 <malloc+0x242>
    int n = write(fd, (void*)addr, 8192);
     500:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     502:	4c05                	li	s8,1
    if(pipe(fds) < 0){
     504:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     508:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     50c:	85da                	mv	a1,s6
     50e:	8556                	mv	a0,s5
     510:	035040ef          	jal	4d44 <open>
     514:	84aa                	mv	s1,a0
    if(fd < 0){
     516:	06054a63          	bltz	a0,58a <copyin+0xde>
    int n = write(fd, (void*)addr, 8192);
     51a:	8652                	mv	a2,s4
     51c:	85ce                	mv	a1,s3
     51e:	007040ef          	jal	4d24 <write>
    if(n >= 0){
     522:	06055d63          	bgez	a0,59c <copyin+0xf0>
    close(fd);
     526:	8526                	mv	a0,s1
     528:	005040ef          	jal	4d2c <close>
    unlink("copyin1");
     52c:	8556                	mv	a0,s5
     52e:	027040ef          	jal	4d54 <unlink>
    n = write(1, (char*)addr, 8192);
     532:	8652                	mv	a2,s4
     534:	85ce                	mv	a1,s3
     536:	8562                	mv	a0,s8
     538:	7ec040ef          	jal	4d24 <write>
    if(n > 0){
     53c:	06a04b63          	bgtz	a0,5b2 <copyin+0x106>
    if(pipe(fds) < 0){
     540:	855e                	mv	a0,s7
     542:	7d2040ef          	jal	4d14 <pipe>
     546:	08054163          	bltz	a0,5c8 <copyin+0x11c>
    n = write(fds[1], (char*)addr, 8192);
     54a:	8652                	mv	a2,s4
     54c:	85ce                	mv	a1,s3
     54e:	f7442503          	lw	a0,-140(s0)
     552:	7d2040ef          	jal	4d24 <write>
    if(n > 0){
     556:	08a04263          	bgtz	a0,5da <copyin+0x12e>
    close(fds[0]);
     55a:	f7042503          	lw	a0,-144(s0)
     55e:	7ce040ef          	jal	4d2c <close>
    close(fds[1]);
     562:	f7442503          	lw	a0,-140(s0)
     566:	7c6040ef          	jal	4d2c <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     56a:	0921                	addi	s2,s2,8
     56c:	f9991ee3          	bne	s2,s9,508 <copyin+0x5c>
}
     570:	60aa                	ld	ra,136(sp)
     572:	640a                	ld	s0,128(sp)
     574:	74e6                	ld	s1,120(sp)
     576:	7946                	ld	s2,112(sp)
     578:	79a6                	ld	s3,104(sp)
     57a:	7a06                	ld	s4,96(sp)
     57c:	6ae6                	ld	s5,88(sp)
     57e:	6b46                	ld	s6,80(sp)
     580:	6ba6                	ld	s7,72(sp)
     582:	6c06                	ld	s8,64(sp)
     584:	7ce2                	ld	s9,56(sp)
     586:	6149                	addi	sp,sp,144
     588:	8082                	ret
      printf("open(copyin1) failed\n");
     58a:	00005517          	auipc	a0,0x5
     58e:	e7e50513          	addi	a0,a0,-386 # 5408 <malloc+0x24a>
     592:	375040ef          	jal	5106 <printf>
      exit(1);
     596:	4505                	li	a0,1
     598:	76c040ef          	jal	4d04 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     59c:	862a                	mv	a2,a0
     59e:	85ce                	mv	a1,s3
     5a0:	00005517          	auipc	a0,0x5
     5a4:	e8050513          	addi	a0,a0,-384 # 5420 <malloc+0x262>
     5a8:	35f040ef          	jal	5106 <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	756040ef          	jal	4d04 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5b2:	862a                	mv	a2,a0
     5b4:	85ce                	mv	a1,s3
     5b6:	00005517          	auipc	a0,0x5
     5ba:	e9a50513          	addi	a0,a0,-358 # 5450 <malloc+0x292>
     5be:	349040ef          	jal	5106 <printf>
      exit(1);
     5c2:	4505                	li	a0,1
     5c4:	740040ef          	jal	4d04 <exit>
      printf("pipe() failed\n");
     5c8:	00005517          	auipc	a0,0x5
     5cc:	eb850513          	addi	a0,a0,-328 # 5480 <malloc+0x2c2>
     5d0:	337040ef          	jal	5106 <printf>
      exit(1);
     5d4:	4505                	li	a0,1
     5d6:	72e040ef          	jal	4d04 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5da:	862a                	mv	a2,a0
     5dc:	85ce                	mv	a1,s3
     5de:	00005517          	auipc	a0,0x5
     5e2:	eb250513          	addi	a0,a0,-334 # 5490 <malloc+0x2d2>
     5e6:	321040ef          	jal	5106 <printf>
      exit(1);
     5ea:	4505                	li	a0,1
     5ec:	718040ef          	jal	4d04 <exit>

00000000000005f0 <copyout>:
{
     5f0:	7135                	addi	sp,sp,-160
     5f2:	ed06                	sd	ra,152(sp)
     5f4:	e922                	sd	s0,144(sp)
     5f6:	e526                	sd	s1,136(sp)
     5f8:	e14a                	sd	s2,128(sp)
     5fa:	fcce                	sd	s3,120(sp)
     5fc:	f8d2                	sd	s4,112(sp)
     5fe:	f4d6                	sd	s5,104(sp)
     600:	f0da                	sd	s6,96(sp)
     602:	ecde                	sd	s7,88(sp)
     604:	e8e2                	sd	s8,80(sp)
     606:	e4e6                	sd	s9,72(sp)
     608:	1100                	addi	s0,sp,160
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     60a:	00007797          	auipc	a5,0x7
     60e:	03e78793          	addi	a5,a5,62 # 7648 <malloc+0x248a>
     612:	7788                	ld	a0,40(a5)
     614:	7b8c                	ld	a1,48(a5)
     616:	7f90                	ld	a2,56(a5)
     618:	63b4                	ld	a3,64(a5)
     61a:	67b8                	ld	a4,72(a5)
     61c:	6bbc                	ld	a5,80(a5)
     61e:	f6a43823          	sd	a0,-144(s0)
     622:	f6b43c23          	sd	a1,-136(s0)
     626:	f8c43023          	sd	a2,-128(s0)
     62a:	f8d43423          	sd	a3,-120(s0)
     62e:	f8e43823          	sd	a4,-112(s0)
     632:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     636:	f7040913          	addi	s2,s0,-144
     63a:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63e:	00005b17          	auipc	s6,0x5
     642:	e82b0b13          	addi	s6,s6,-382 # 54c0 <malloc+0x302>
    int n = read(fd, (void*)addr, 8192);
     646:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     648:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64c:	4a05                	li	s4,1
     64e:	00005b97          	auipc	s7,0x5
     652:	d0ab8b93          	addi	s7,s7,-758 # 5358 <malloc+0x19a>
    uint64 addr = addrs[ai];
     656:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     65a:	4581                	li	a1,0
     65c:	855a                	mv	a0,s6
     65e:	6e6040ef          	jal	4d44 <open>
     662:	84aa                	mv	s1,a0
    if(fd < 0){
     664:	06054863          	bltz	a0,6d4 <copyout+0xe4>
    int n = read(fd, (void*)addr, 8192);
     668:	8656                	mv	a2,s5
     66a:	85ce                	mv	a1,s3
     66c:	6b0040ef          	jal	4d1c <read>
    if(n > 0){
     670:	06a04b63          	bgtz	a0,6e6 <copyout+0xf6>
    close(fd);
     674:	8526                	mv	a0,s1
     676:	6b6040ef          	jal	4d2c <close>
    if(pipe(fds) < 0){
     67a:	8562                	mv	a0,s8
     67c:	698040ef          	jal	4d14 <pipe>
     680:	06054e63          	bltz	a0,6fc <copyout+0x10c>
    n = write(fds[1], "x", 1);
     684:	8652                	mv	a2,s4
     686:	85de                	mv	a1,s7
     688:	f6c42503          	lw	a0,-148(s0)
     68c:	698040ef          	jal	4d24 <write>
    if(n != 1){
     690:	07451f63          	bne	a0,s4,70e <copyout+0x11e>
    n = read(fds[0], (void*)addr, 8192);
     694:	8656                	mv	a2,s5
     696:	85ce                	mv	a1,s3
     698:	f6842503          	lw	a0,-152(s0)
     69c:	680040ef          	jal	4d1c <read>
    if(n > 0){
     6a0:	08a04063          	bgtz	a0,720 <copyout+0x130>
    close(fds[0]);
     6a4:	f6842503          	lw	a0,-152(s0)
     6a8:	684040ef          	jal	4d2c <close>
    close(fds[1]);
     6ac:	f6c42503          	lw	a0,-148(s0)
     6b0:	67c040ef          	jal	4d2c <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     6b4:	0921                	addi	s2,s2,8
     6b6:	fb9910e3          	bne	s2,s9,656 <copyout+0x66>
}
     6ba:	60ea                	ld	ra,152(sp)
     6bc:	644a                	ld	s0,144(sp)
     6be:	64aa                	ld	s1,136(sp)
     6c0:	690a                	ld	s2,128(sp)
     6c2:	79e6                	ld	s3,120(sp)
     6c4:	7a46                	ld	s4,112(sp)
     6c6:	7aa6                	ld	s5,104(sp)
     6c8:	7b06                	ld	s6,96(sp)
     6ca:	6be6                	ld	s7,88(sp)
     6cc:	6c46                	ld	s8,80(sp)
     6ce:	6ca6                	ld	s9,72(sp)
     6d0:	610d                	addi	sp,sp,160
     6d2:	8082                	ret
      printf("open(README) failed\n");
     6d4:	00005517          	auipc	a0,0x5
     6d8:	df450513          	addi	a0,a0,-524 # 54c8 <malloc+0x30a>
     6dc:	22b040ef          	jal	5106 <printf>
      exit(1);
     6e0:	4505                	li	a0,1
     6e2:	622040ef          	jal	4d04 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6e6:	862a                	mv	a2,a0
     6e8:	85ce                	mv	a1,s3
     6ea:	00005517          	auipc	a0,0x5
     6ee:	df650513          	addi	a0,a0,-522 # 54e0 <malloc+0x322>
     6f2:	215040ef          	jal	5106 <printf>
      exit(1);
     6f6:	4505                	li	a0,1
     6f8:	60c040ef          	jal	4d04 <exit>
      printf("pipe() failed\n");
     6fc:	00005517          	auipc	a0,0x5
     700:	d8450513          	addi	a0,a0,-636 # 5480 <malloc+0x2c2>
     704:	203040ef          	jal	5106 <printf>
      exit(1);
     708:	4505                	li	a0,1
     70a:	5fa040ef          	jal	4d04 <exit>
      printf("pipe write failed\n");
     70e:	00005517          	auipc	a0,0x5
     712:	e0250513          	addi	a0,a0,-510 # 5510 <malloc+0x352>
     716:	1f1040ef          	jal	5106 <printf>
      exit(1);
     71a:	4505                	li	a0,1
     71c:	5e8040ef          	jal	4d04 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     720:	862a                	mv	a2,a0
     722:	85ce                	mv	a1,s3
     724:	00005517          	auipc	a0,0x5
     728:	e0450513          	addi	a0,a0,-508 # 5528 <malloc+0x36a>
     72c:	1db040ef          	jal	5106 <printf>
      exit(1);
     730:	4505                	li	a0,1
     732:	5d2040ef          	jal	4d04 <exit>

0000000000000736 <truncate1>:
{
     736:	711d                	addi	sp,sp,-96
     738:	ec86                	sd	ra,88(sp)
     73a:	e8a2                	sd	s0,80(sp)
     73c:	e4a6                	sd	s1,72(sp)
     73e:	e0ca                	sd	s2,64(sp)
     740:	fc4e                	sd	s3,56(sp)
     742:	f852                	sd	s4,48(sp)
     744:	f456                	sd	s5,40(sp)
     746:	1080                	addi	s0,sp,96
     748:	8aaa                	mv	s5,a0
  unlink("truncfile");
     74a:	00005517          	auipc	a0,0x5
     74e:	bf650513          	addi	a0,a0,-1034 # 5340 <malloc+0x182>
     752:	602040ef          	jal	4d54 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     756:	60100593          	li	a1,1537
     75a:	00005517          	auipc	a0,0x5
     75e:	be650513          	addi	a0,a0,-1050 # 5340 <malloc+0x182>
     762:	5e2040ef          	jal	4d44 <open>
     766:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     768:	4611                	li	a2,4
     76a:	00005597          	auipc	a1,0x5
     76e:	be658593          	addi	a1,a1,-1050 # 5350 <malloc+0x192>
     772:	5b2040ef          	jal	4d24 <write>
  close(fd1);
     776:	8526                	mv	a0,s1
     778:	5b4040ef          	jal	4d2c <close>
  int fd2 = open("truncfile", O_RDONLY);
     77c:	4581                	li	a1,0
     77e:	00005517          	auipc	a0,0x5
     782:	bc250513          	addi	a0,a0,-1086 # 5340 <malloc+0x182>
     786:	5be040ef          	jal	4d44 <open>
     78a:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78c:	02000613          	li	a2,32
     790:	fa040593          	addi	a1,s0,-96
     794:	588040ef          	jal	4d1c <read>
  if(n != 4){
     798:	4791                	li	a5,4
     79a:	0af51863          	bne	a0,a5,84a <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     79e:	40100593          	li	a1,1025
     7a2:	00005517          	auipc	a0,0x5
     7a6:	b9e50513          	addi	a0,a0,-1122 # 5340 <malloc+0x182>
     7aa:	59a040ef          	jal	4d44 <open>
     7ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7b0:	4581                	li	a1,0
     7b2:	00005517          	auipc	a0,0x5
     7b6:	b8e50513          	addi	a0,a0,-1138 # 5340 <malloc+0x182>
     7ba:	58a040ef          	jal	4d44 <open>
     7be:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7c0:	02000613          	li	a2,32
     7c4:	fa040593          	addi	a1,s0,-96
     7c8:	554040ef          	jal	4d1c <read>
     7cc:	8a2a                	mv	s4,a0
  if(n != 0){
     7ce:	e949                	bnez	a0,860 <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7d0:	02000613          	li	a2,32
     7d4:	fa040593          	addi	a1,s0,-96
     7d8:	8526                	mv	a0,s1
     7da:	542040ef          	jal	4d1c <read>
     7de:	8a2a                	mv	s4,a0
  if(n != 0){
     7e0:	e155                	bnez	a0,884 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e2:	4619                	li	a2,6
     7e4:	00005597          	auipc	a1,0x5
     7e8:	dd458593          	addi	a1,a1,-556 # 55b8 <malloc+0x3fa>
     7ec:	854e                	mv	a0,s3
     7ee:	536040ef          	jal	4d24 <write>
  n = read(fd3, buf, sizeof(buf));
     7f2:	02000613          	li	a2,32
     7f6:	fa040593          	addi	a1,s0,-96
     7fa:	854a                	mv	a0,s2
     7fc:	520040ef          	jal	4d1c <read>
  if(n != 6){
     800:	4799                	li	a5,6
     802:	0af51363          	bne	a0,a5,8a8 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     806:	02000613          	li	a2,32
     80a:	fa040593          	addi	a1,s0,-96
     80e:	8526                	mv	a0,s1
     810:	50c040ef          	jal	4d1c <read>
  if(n != 2){
     814:	4789                	li	a5,2
     816:	0af51463          	bne	a0,a5,8be <truncate1+0x188>
  unlink("truncfile");
     81a:	00005517          	auipc	a0,0x5
     81e:	b2650513          	addi	a0,a0,-1242 # 5340 <malloc+0x182>
     822:	532040ef          	jal	4d54 <unlink>
  close(fd1);
     826:	854e                	mv	a0,s3
     828:	504040ef          	jal	4d2c <close>
  close(fd2);
     82c:	8526                	mv	a0,s1
     82e:	4fe040ef          	jal	4d2c <close>
  close(fd3);
     832:	854a                	mv	a0,s2
     834:	4f8040ef          	jal	4d2c <close>
}
     838:	60e6                	ld	ra,88(sp)
     83a:	6446                	ld	s0,80(sp)
     83c:	64a6                	ld	s1,72(sp)
     83e:	6906                	ld	s2,64(sp)
     840:	79e2                	ld	s3,56(sp)
     842:	7a42                	ld	s4,48(sp)
     844:	7aa2                	ld	s5,40(sp)
     846:	6125                	addi	sp,sp,96
     848:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     84a:	862a                	mv	a2,a0
     84c:	85d6                	mv	a1,s5
     84e:	00005517          	auipc	a0,0x5
     852:	d0a50513          	addi	a0,a0,-758 # 5558 <malloc+0x39a>
     856:	0b1040ef          	jal	5106 <printf>
    exit(1);
     85a:	4505                	li	a0,1
     85c:	4a8040ef          	jal	4d04 <exit>
    printf("aaa fd3=%d\n", fd3);
     860:	85ca                	mv	a1,s2
     862:	00005517          	auipc	a0,0x5
     866:	d1650513          	addi	a0,a0,-746 # 5578 <malloc+0x3ba>
     86a:	09d040ef          	jal	5106 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86e:	8652                	mv	a2,s4
     870:	85d6                	mv	a1,s5
     872:	00005517          	auipc	a0,0x5
     876:	d1650513          	addi	a0,a0,-746 # 5588 <malloc+0x3ca>
     87a:	08d040ef          	jal	5106 <printf>
    exit(1);
     87e:	4505                	li	a0,1
     880:	484040ef          	jal	4d04 <exit>
    printf("bbb fd2=%d\n", fd2);
     884:	85a6                	mv	a1,s1
     886:	00005517          	auipc	a0,0x5
     88a:	d2250513          	addi	a0,a0,-734 # 55a8 <malloc+0x3ea>
     88e:	079040ef          	jal	5106 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     892:	8652                	mv	a2,s4
     894:	85d6                	mv	a1,s5
     896:	00005517          	auipc	a0,0x5
     89a:	cf250513          	addi	a0,a0,-782 # 5588 <malloc+0x3ca>
     89e:	069040ef          	jal	5106 <printf>
    exit(1);
     8a2:	4505                	li	a0,1
     8a4:	460040ef          	jal	4d04 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a8:	862a                	mv	a2,a0
     8aa:	85d6                	mv	a1,s5
     8ac:	00005517          	auipc	a0,0x5
     8b0:	d1450513          	addi	a0,a0,-748 # 55c0 <malloc+0x402>
     8b4:	053040ef          	jal	5106 <printf>
    exit(1);
     8b8:	4505                	li	a0,1
     8ba:	44a040ef          	jal	4d04 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8be:	862a                	mv	a2,a0
     8c0:	85d6                	mv	a1,s5
     8c2:	00005517          	auipc	a0,0x5
     8c6:	d1e50513          	addi	a0,a0,-738 # 55e0 <malloc+0x422>
     8ca:	03d040ef          	jal	5106 <printf>
    exit(1);
     8ce:	4505                	li	a0,1
     8d0:	434040ef          	jal	4d04 <exit>

00000000000008d4 <writetest>:
{
     8d4:	715d                	addi	sp,sp,-80
     8d6:	e486                	sd	ra,72(sp)
     8d8:	e0a2                	sd	s0,64(sp)
     8da:	fc26                	sd	s1,56(sp)
     8dc:	f84a                	sd	s2,48(sp)
     8de:	f44e                	sd	s3,40(sp)
     8e0:	f052                	sd	s4,32(sp)
     8e2:	ec56                	sd	s5,24(sp)
     8e4:	e85a                	sd	s6,16(sp)
     8e6:	e45e                	sd	s7,8(sp)
     8e8:	0880                	addi	s0,sp,80
     8ea:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     8ec:	20200593          	li	a1,514
     8f0:	00005517          	auipc	a0,0x5
     8f4:	d1050513          	addi	a0,a0,-752 # 5600 <malloc+0x442>
     8f8:	44c040ef          	jal	4d44 <open>
  if(fd < 0){
     8fc:	08054f63          	bltz	a0,99a <writetest+0xc6>
     900:	89aa                	mv	s3,a0
     902:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     904:	44a9                	li	s1,10
     906:	00005a17          	auipc	s4,0x5
     90a:	d22a0a13          	addi	s4,s4,-734 # 5628 <malloc+0x46a>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     90e:	00005b17          	auipc	s6,0x5
     912:	d52b0b13          	addi	s6,s6,-686 # 5660 <malloc+0x4a2>
  for(i = 0; i < N; i++){
     916:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     91a:	8626                	mv	a2,s1
     91c:	85d2                	mv	a1,s4
     91e:	854e                	mv	a0,s3
     920:	404040ef          	jal	4d24 <write>
     924:	08951563          	bne	a0,s1,9ae <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     928:	8626                	mv	a2,s1
     92a:	85da                	mv	a1,s6
     92c:	854e                	mv	a0,s3
     92e:	3f6040ef          	jal	4d24 <write>
     932:	08951963          	bne	a0,s1,9c4 <writetest+0xf0>
  for(i = 0; i < N; i++){
     936:	2905                	addiw	s2,s2,1
     938:	ff5911e3          	bne	s2,s5,91a <writetest+0x46>
  close(fd);
     93c:	854e                	mv	a0,s3
     93e:	3ee040ef          	jal	4d2c <close>
  fd = open("small", O_RDONLY);
     942:	4581                	li	a1,0
     944:	00005517          	auipc	a0,0x5
     948:	cbc50513          	addi	a0,a0,-836 # 5600 <malloc+0x442>
     94c:	3f8040ef          	jal	4d44 <open>
     950:	84aa                	mv	s1,a0
  if(fd < 0){
     952:	08054463          	bltz	a0,9da <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
     956:	7d000613          	li	a2,2000
     95a:	0000b597          	auipc	a1,0xb
     95e:	31e58593          	addi	a1,a1,798 # bc78 <buf>
     962:	3ba040ef          	jal	4d1c <read>
  if(i != N*SZ*2){
     966:	7d000793          	li	a5,2000
     96a:	08f51263          	bne	a0,a5,9ee <writetest+0x11a>
  close(fd);
     96e:	8526                	mv	a0,s1
     970:	3bc040ef          	jal	4d2c <close>
  if(unlink("small") < 0){
     974:	00005517          	auipc	a0,0x5
     978:	c8c50513          	addi	a0,a0,-884 # 5600 <malloc+0x442>
     97c:	3d8040ef          	jal	4d54 <unlink>
     980:	08054163          	bltz	a0,a02 <writetest+0x12e>
}
     984:	60a6                	ld	ra,72(sp)
     986:	6406                	ld	s0,64(sp)
     988:	74e2                	ld	s1,56(sp)
     98a:	7942                	ld	s2,48(sp)
     98c:	79a2                	ld	s3,40(sp)
     98e:	7a02                	ld	s4,32(sp)
     990:	6ae2                	ld	s5,24(sp)
     992:	6b42                	ld	s6,16(sp)
     994:	6ba2                	ld	s7,8(sp)
     996:	6161                	addi	sp,sp,80
     998:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     99a:	85de                	mv	a1,s7
     99c:	00005517          	auipc	a0,0x5
     9a0:	c6c50513          	addi	a0,a0,-916 # 5608 <malloc+0x44a>
     9a4:	762040ef          	jal	5106 <printf>
    exit(1);
     9a8:	4505                	li	a0,1
     9aa:	35a040ef          	jal	4d04 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ae:	864a                	mv	a2,s2
     9b0:	85de                	mv	a1,s7
     9b2:	00005517          	auipc	a0,0x5
     9b6:	c8650513          	addi	a0,a0,-890 # 5638 <malloc+0x47a>
     9ba:	74c040ef          	jal	5106 <printf>
      exit(1);
     9be:	4505                	li	a0,1
     9c0:	344040ef          	jal	4d04 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c4:	864a                	mv	a2,s2
     9c6:	85de                	mv	a1,s7
     9c8:	00005517          	auipc	a0,0x5
     9cc:	ca850513          	addi	a0,a0,-856 # 5670 <malloc+0x4b2>
     9d0:	736040ef          	jal	5106 <printf>
      exit(1);
     9d4:	4505                	li	a0,1
     9d6:	32e040ef          	jal	4d04 <exit>
    printf("%s: error: open small failed!\n", s);
     9da:	85de                	mv	a1,s7
     9dc:	00005517          	auipc	a0,0x5
     9e0:	cbc50513          	addi	a0,a0,-836 # 5698 <malloc+0x4da>
     9e4:	722040ef          	jal	5106 <printf>
    exit(1);
     9e8:	4505                	li	a0,1
     9ea:	31a040ef          	jal	4d04 <exit>
    printf("%s: read failed\n", s);
     9ee:	85de                	mv	a1,s7
     9f0:	00005517          	auipc	a0,0x5
     9f4:	cc850513          	addi	a0,a0,-824 # 56b8 <malloc+0x4fa>
     9f8:	70e040ef          	jal	5106 <printf>
    exit(1);
     9fc:	4505                	li	a0,1
     9fe:	306040ef          	jal	4d04 <exit>
    printf("%s: unlink small failed\n", s);
     a02:	85de                	mv	a1,s7
     a04:	00005517          	auipc	a0,0x5
     a08:	ccc50513          	addi	a0,a0,-820 # 56d0 <malloc+0x512>
     a0c:	6fa040ef          	jal	5106 <printf>
    exit(1);
     a10:	4505                	li	a0,1
     a12:	2f2040ef          	jal	4d04 <exit>

0000000000000a16 <writebig>:
{
     a16:	7139                	addi	sp,sp,-64
     a18:	fc06                	sd	ra,56(sp)
     a1a:	f822                	sd	s0,48(sp)
     a1c:	f426                	sd	s1,40(sp)
     a1e:	f04a                	sd	s2,32(sp)
     a20:	ec4e                	sd	s3,24(sp)
     a22:	e852                	sd	s4,16(sp)
     a24:	e456                	sd	s5,8(sp)
     a26:	e05a                	sd	s6,0(sp)
     a28:	0080                	addi	s0,sp,64
     a2a:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     a2c:	20200593          	li	a1,514
     a30:	00005517          	auipc	a0,0x5
     a34:	cc050513          	addi	a0,a0,-832 # 56f0 <malloc+0x532>
     a38:	30c040ef          	jal	4d44 <open>
  if(fd < 0){
     a3c:	06054a63          	bltz	a0,ab0 <writebig+0x9a>
     a40:	8a2a                	mv	s4,a0
     a42:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     a44:	0000b997          	auipc	s3,0xb
     a48:	23498993          	addi	s3,s3,564 # bc78 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     a4c:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     a50:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
     a54:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     a58:	864a                	mv	a2,s2
     a5a:	85ce                	mv	a1,s3
     a5c:	8552                	mv	a0,s4
     a5e:	2c6040ef          	jal	4d24 <write>
     a62:	07251163          	bne	a0,s2,ac4 <writebig+0xae>
  for(i = 0; i < MAXFILE; i++){
     a66:	2485                	addiw	s1,s1,1
     a68:	ff5496e3          	bne	s1,s5,a54 <writebig+0x3e>
  close(fd);
     a6c:	8552                	mv	a0,s4
     a6e:	2be040ef          	jal	4d2c <close>
  fd = open("big", O_RDONLY);
     a72:	4581                	li	a1,0
     a74:	00005517          	auipc	a0,0x5
     a78:	c7c50513          	addi	a0,a0,-900 # 56f0 <malloc+0x532>
     a7c:	2c8040ef          	jal	4d44 <open>
     a80:	8a2a                	mv	s4,a0
  n = 0;
     a82:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a84:	40000993          	li	s3,1024
     a88:	0000b917          	auipc	s2,0xb
     a8c:	1f090913          	addi	s2,s2,496 # bc78 <buf>
  if(fd < 0){
     a90:	04054563          	bltz	a0,ada <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a94:	864e                	mv	a2,s3
     a96:	85ca                	mv	a1,s2
     a98:	8552                	mv	a0,s4
     a9a:	282040ef          	jal	4d1c <read>
    if(i == 0){
     a9e:	c921                	beqz	a0,aee <writebig+0xd8>
    } else if(i != BSIZE){
     aa0:	09351b63          	bne	a0,s3,b36 <writebig+0x120>
    if(((int*)buf)[0] != n){
     aa4:	00092683          	lw	a3,0(s2)
     aa8:	0a969263          	bne	a3,s1,b4c <writebig+0x136>
    n++;
     aac:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aae:	b7dd                	j	a94 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     ab0:	85da                	mv	a1,s6
     ab2:	00005517          	auipc	a0,0x5
     ab6:	c4650513          	addi	a0,a0,-954 # 56f8 <malloc+0x53a>
     aba:	64c040ef          	jal	5106 <printf>
    exit(1);
     abe:	4505                	li	a0,1
     ac0:	244040ef          	jal	4d04 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac4:	8626                	mv	a2,s1
     ac6:	85da                	mv	a1,s6
     ac8:	00005517          	auipc	a0,0x5
     acc:	c5050513          	addi	a0,a0,-944 # 5718 <malloc+0x55a>
     ad0:	636040ef          	jal	5106 <printf>
      exit(1);
     ad4:	4505                	li	a0,1
     ad6:	22e040ef          	jal	4d04 <exit>
    printf("%s: error: open big failed!\n", s);
     ada:	85da                	mv	a1,s6
     adc:	00005517          	auipc	a0,0x5
     ae0:	c6450513          	addi	a0,a0,-924 # 5740 <malloc+0x582>
     ae4:	622040ef          	jal	5106 <printf>
    exit(1);
     ae8:	4505                	li	a0,1
     aea:	21a040ef          	jal	4d04 <exit>
      if(n != MAXFILE){
     aee:	10c00793          	li	a5,268
     af2:	02f49763          	bne	s1,a5,b20 <writebig+0x10a>
  close(fd);
     af6:	8552                	mv	a0,s4
     af8:	234040ef          	jal	4d2c <close>
  if(unlink("big") < 0){
     afc:	00005517          	auipc	a0,0x5
     b00:	bf450513          	addi	a0,a0,-1036 # 56f0 <malloc+0x532>
     b04:	250040ef          	jal	4d54 <unlink>
     b08:	04054d63          	bltz	a0,b62 <writebig+0x14c>
}
     b0c:	70e2                	ld	ra,56(sp)
     b0e:	7442                	ld	s0,48(sp)
     b10:	74a2                	ld	s1,40(sp)
     b12:	7902                	ld	s2,32(sp)
     b14:	69e2                	ld	s3,24(sp)
     b16:	6a42                	ld	s4,16(sp)
     b18:	6aa2                	ld	s5,8(sp)
     b1a:	6b02                	ld	s6,0(sp)
     b1c:	6121                	addi	sp,sp,64
     b1e:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b20:	8626                	mv	a2,s1
     b22:	85da                	mv	a1,s6
     b24:	00005517          	auipc	a0,0x5
     b28:	c3c50513          	addi	a0,a0,-964 # 5760 <malloc+0x5a2>
     b2c:	5da040ef          	jal	5106 <printf>
        exit(1);
     b30:	4505                	li	a0,1
     b32:	1d2040ef          	jal	4d04 <exit>
      printf("%s: read failed %d\n", s, i);
     b36:	862a                	mv	a2,a0
     b38:	85da                	mv	a1,s6
     b3a:	00005517          	auipc	a0,0x5
     b3e:	c4e50513          	addi	a0,a0,-946 # 5788 <malloc+0x5ca>
     b42:	5c4040ef          	jal	5106 <printf>
      exit(1);
     b46:	4505                	li	a0,1
     b48:	1bc040ef          	jal	4d04 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b4c:	8626                	mv	a2,s1
     b4e:	85da                	mv	a1,s6
     b50:	00005517          	auipc	a0,0x5
     b54:	c5050513          	addi	a0,a0,-944 # 57a0 <malloc+0x5e2>
     b58:	5ae040ef          	jal	5106 <printf>
      exit(1);
     b5c:	4505                	li	a0,1
     b5e:	1a6040ef          	jal	4d04 <exit>
    printf("%s: unlink big failed\n", s);
     b62:	85da                	mv	a1,s6
     b64:	00005517          	auipc	a0,0x5
     b68:	c6450513          	addi	a0,a0,-924 # 57c8 <malloc+0x60a>
     b6c:	59a040ef          	jal	5106 <printf>
    exit(1);
     b70:	4505                	li	a0,1
     b72:	192040ef          	jal	4d04 <exit>

0000000000000b76 <unlinkread>:
{
     b76:	7179                	addi	sp,sp,-48
     b78:	f406                	sd	ra,40(sp)
     b7a:	f022                	sd	s0,32(sp)
     b7c:	ec26                	sd	s1,24(sp)
     b7e:	e84a                	sd	s2,16(sp)
     b80:	e44e                	sd	s3,8(sp)
     b82:	1800                	addi	s0,sp,48
     b84:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b86:	20200593          	li	a1,514
     b8a:	00005517          	auipc	a0,0x5
     b8e:	c5650513          	addi	a0,a0,-938 # 57e0 <malloc+0x622>
     b92:	1b2040ef          	jal	4d44 <open>
  if(fd < 0){
     b96:	0a054f63          	bltz	a0,c54 <unlinkread+0xde>
     b9a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9c:	4615                	li	a2,5
     b9e:	00005597          	auipc	a1,0x5
     ba2:	c7258593          	addi	a1,a1,-910 # 5810 <malloc+0x652>
     ba6:	17e040ef          	jal	4d24 <write>
  close(fd);
     baa:	8526                	mv	a0,s1
     bac:	180040ef          	jal	4d2c <close>
  fd = open("unlinkread", O_RDWR);
     bb0:	4589                	li	a1,2
     bb2:	00005517          	auipc	a0,0x5
     bb6:	c2e50513          	addi	a0,a0,-978 # 57e0 <malloc+0x622>
     bba:	18a040ef          	jal	4d44 <open>
     bbe:	84aa                	mv	s1,a0
  if(fd < 0){
     bc0:	0a054463          	bltz	a0,c68 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     bc4:	00005517          	auipc	a0,0x5
     bc8:	c1c50513          	addi	a0,a0,-996 # 57e0 <malloc+0x622>
     bcc:	188040ef          	jal	4d54 <unlink>
     bd0:	e555                	bnez	a0,c7c <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd2:	20200593          	li	a1,514
     bd6:	00005517          	auipc	a0,0x5
     bda:	c0a50513          	addi	a0,a0,-1014 # 57e0 <malloc+0x622>
     bde:	166040ef          	jal	4d44 <open>
     be2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be4:	460d                	li	a2,3
     be6:	00005597          	auipc	a1,0x5
     bea:	c7258593          	addi	a1,a1,-910 # 5858 <malloc+0x69a>
     bee:	136040ef          	jal	4d24 <write>
  close(fd1);
     bf2:	854a                	mv	a0,s2
     bf4:	138040ef          	jal	4d2c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     bf8:	660d                	lui	a2,0x3
     bfa:	0000b597          	auipc	a1,0xb
     bfe:	07e58593          	addi	a1,a1,126 # bc78 <buf>
     c02:	8526                	mv	a0,s1
     c04:	118040ef          	jal	4d1c <read>
     c08:	4795                	li	a5,5
     c0a:	08f51363          	bne	a0,a5,c90 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     c0e:	0000b717          	auipc	a4,0xb
     c12:	06a74703          	lbu	a4,106(a4) # bc78 <buf>
     c16:	06800793          	li	a5,104
     c1a:	08f71563          	bne	a4,a5,ca4 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     c1e:	4629                	li	a2,10
     c20:	0000b597          	auipc	a1,0xb
     c24:	05858593          	addi	a1,a1,88 # bc78 <buf>
     c28:	8526                	mv	a0,s1
     c2a:	0fa040ef          	jal	4d24 <write>
     c2e:	47a9                	li	a5,10
     c30:	08f51463          	bne	a0,a5,cb8 <unlinkread+0x142>
  close(fd);
     c34:	8526                	mv	a0,s1
     c36:	0f6040ef          	jal	4d2c <close>
  unlink("unlinkread");
     c3a:	00005517          	auipc	a0,0x5
     c3e:	ba650513          	addi	a0,a0,-1114 # 57e0 <malloc+0x622>
     c42:	112040ef          	jal	4d54 <unlink>
}
     c46:	70a2                	ld	ra,40(sp)
     c48:	7402                	ld	s0,32(sp)
     c4a:	64e2                	ld	s1,24(sp)
     c4c:	6942                	ld	s2,16(sp)
     c4e:	69a2                	ld	s3,8(sp)
     c50:	6145                	addi	sp,sp,48
     c52:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c54:	85ce                	mv	a1,s3
     c56:	00005517          	auipc	a0,0x5
     c5a:	b9a50513          	addi	a0,a0,-1126 # 57f0 <malloc+0x632>
     c5e:	4a8040ef          	jal	5106 <printf>
    exit(1);
     c62:	4505                	li	a0,1
     c64:	0a0040ef          	jal	4d04 <exit>
    printf("%s: open unlinkread failed\n", s);
     c68:	85ce                	mv	a1,s3
     c6a:	00005517          	auipc	a0,0x5
     c6e:	bae50513          	addi	a0,a0,-1106 # 5818 <malloc+0x65a>
     c72:	494040ef          	jal	5106 <printf>
    exit(1);
     c76:	4505                	li	a0,1
     c78:	08c040ef          	jal	4d04 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7c:	85ce                	mv	a1,s3
     c7e:	00005517          	auipc	a0,0x5
     c82:	bba50513          	addi	a0,a0,-1094 # 5838 <malloc+0x67a>
     c86:	480040ef          	jal	5106 <printf>
    exit(1);
     c8a:	4505                	li	a0,1
     c8c:	078040ef          	jal	4d04 <exit>
    printf("%s: unlinkread read failed", s);
     c90:	85ce                	mv	a1,s3
     c92:	00005517          	auipc	a0,0x5
     c96:	bce50513          	addi	a0,a0,-1074 # 5860 <malloc+0x6a2>
     c9a:	46c040ef          	jal	5106 <printf>
    exit(1);
     c9e:	4505                	li	a0,1
     ca0:	064040ef          	jal	4d04 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	bda50513          	addi	a0,a0,-1062 # 5880 <malloc+0x6c2>
     cae:	458040ef          	jal	5106 <printf>
    exit(1);
     cb2:	4505                	li	a0,1
     cb4:	050040ef          	jal	4d04 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb8:	85ce                	mv	a1,s3
     cba:	00005517          	auipc	a0,0x5
     cbe:	be650513          	addi	a0,a0,-1050 # 58a0 <malloc+0x6e2>
     cc2:	444040ef          	jal	5106 <printf>
    exit(1);
     cc6:	4505                	li	a0,1
     cc8:	03c040ef          	jal	4d04 <exit>

0000000000000ccc <linktest>:
{
     ccc:	1101                	addi	sp,sp,-32
     cce:	ec06                	sd	ra,24(sp)
     cd0:	e822                	sd	s0,16(sp)
     cd2:	e426                	sd	s1,8(sp)
     cd4:	e04a                	sd	s2,0(sp)
     cd6:	1000                	addi	s0,sp,32
     cd8:	892a                	mv	s2,a0
  unlink("lf1");
     cda:	00005517          	auipc	a0,0x5
     cde:	be650513          	addi	a0,a0,-1050 # 58c0 <malloc+0x702>
     ce2:	072040ef          	jal	4d54 <unlink>
  unlink("lf2");
     ce6:	00005517          	auipc	a0,0x5
     cea:	be250513          	addi	a0,a0,-1054 # 58c8 <malloc+0x70a>
     cee:	066040ef          	jal	4d54 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     cf2:	20200593          	li	a1,514
     cf6:	00005517          	auipc	a0,0x5
     cfa:	bca50513          	addi	a0,a0,-1078 # 58c0 <malloc+0x702>
     cfe:	046040ef          	jal	4d44 <open>
  if(fd < 0){
     d02:	0c054f63          	bltz	a0,de0 <linktest+0x114>
     d06:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d08:	4615                	li	a2,5
     d0a:	00005597          	auipc	a1,0x5
     d0e:	b0658593          	addi	a1,a1,-1274 # 5810 <malloc+0x652>
     d12:	012040ef          	jal	4d24 <write>
     d16:	4795                	li	a5,5
     d18:	0cf51e63          	bne	a0,a5,df4 <linktest+0x128>
  close(fd);
     d1c:	8526                	mv	a0,s1
     d1e:	00e040ef          	jal	4d2c <close>
  if(link("lf1", "lf2") < 0){
     d22:	00005597          	auipc	a1,0x5
     d26:	ba658593          	addi	a1,a1,-1114 # 58c8 <malloc+0x70a>
     d2a:	00005517          	auipc	a0,0x5
     d2e:	b9650513          	addi	a0,a0,-1130 # 58c0 <malloc+0x702>
     d32:	032040ef          	jal	4d64 <link>
     d36:	0c054963          	bltz	a0,e08 <linktest+0x13c>
  unlink("lf1");
     d3a:	00005517          	auipc	a0,0x5
     d3e:	b8650513          	addi	a0,a0,-1146 # 58c0 <malloc+0x702>
     d42:	012040ef          	jal	4d54 <unlink>
  if(open("lf1", 0) >= 0){
     d46:	4581                	li	a1,0
     d48:	00005517          	auipc	a0,0x5
     d4c:	b7850513          	addi	a0,a0,-1160 # 58c0 <malloc+0x702>
     d50:	7f5030ef          	jal	4d44 <open>
     d54:	0c055463          	bgez	a0,e1c <linktest+0x150>
  fd = open("lf2", 0);
     d58:	4581                	li	a1,0
     d5a:	00005517          	auipc	a0,0x5
     d5e:	b6e50513          	addi	a0,a0,-1170 # 58c8 <malloc+0x70a>
     d62:	7e3030ef          	jal	4d44 <open>
     d66:	84aa                	mv	s1,a0
  if(fd < 0){
     d68:	0c054463          	bltz	a0,e30 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d6c:	660d                	lui	a2,0x3
     d6e:	0000b597          	auipc	a1,0xb
     d72:	f0a58593          	addi	a1,a1,-246 # bc78 <buf>
     d76:	7a7030ef          	jal	4d1c <read>
     d7a:	4795                	li	a5,5
     d7c:	0cf51463          	bne	a0,a5,e44 <linktest+0x178>
  close(fd);
     d80:	8526                	mv	a0,s1
     d82:	7ab030ef          	jal	4d2c <close>
  if(link("lf2", "lf2") >= 0){
     d86:	00005597          	auipc	a1,0x5
     d8a:	b4258593          	addi	a1,a1,-1214 # 58c8 <malloc+0x70a>
     d8e:	852e                	mv	a0,a1
     d90:	7d5030ef          	jal	4d64 <link>
     d94:	0c055263          	bgez	a0,e58 <linktest+0x18c>
  unlink("lf2");
     d98:	00005517          	auipc	a0,0x5
     d9c:	b3050513          	addi	a0,a0,-1232 # 58c8 <malloc+0x70a>
     da0:	7b5030ef          	jal	4d54 <unlink>
  if(link("lf2", "lf1") >= 0){
     da4:	00005597          	auipc	a1,0x5
     da8:	b1c58593          	addi	a1,a1,-1252 # 58c0 <malloc+0x702>
     dac:	00005517          	auipc	a0,0x5
     db0:	b1c50513          	addi	a0,a0,-1252 # 58c8 <malloc+0x70a>
     db4:	7b1030ef          	jal	4d64 <link>
     db8:	0a055a63          	bgez	a0,e6c <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     dbc:	00005597          	auipc	a1,0x5
     dc0:	b0458593          	addi	a1,a1,-1276 # 58c0 <malloc+0x702>
     dc4:	00005517          	auipc	a0,0x5
     dc8:	c0c50513          	addi	a0,a0,-1012 # 59d0 <malloc+0x812>
     dcc:	799030ef          	jal	4d64 <link>
     dd0:	0a055863          	bgez	a0,e80 <linktest+0x1b4>
}
     dd4:	60e2                	ld	ra,24(sp)
     dd6:	6442                	ld	s0,16(sp)
     dd8:	64a2                	ld	s1,8(sp)
     dda:	6902                	ld	s2,0(sp)
     ddc:	6105                	addi	sp,sp,32
     dde:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     de0:	85ca                	mv	a1,s2
     de2:	00005517          	auipc	a0,0x5
     de6:	aee50513          	addi	a0,a0,-1298 # 58d0 <malloc+0x712>
     dea:	31c040ef          	jal	5106 <printf>
    exit(1);
     dee:	4505                	li	a0,1
     df0:	715030ef          	jal	4d04 <exit>
    printf("%s: write lf1 failed\n", s);
     df4:	85ca                	mv	a1,s2
     df6:	00005517          	auipc	a0,0x5
     dfa:	af250513          	addi	a0,a0,-1294 # 58e8 <malloc+0x72a>
     dfe:	308040ef          	jal	5106 <printf>
    exit(1);
     e02:	4505                	li	a0,1
     e04:	701030ef          	jal	4d04 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e08:	85ca                	mv	a1,s2
     e0a:	00005517          	auipc	a0,0x5
     e0e:	af650513          	addi	a0,a0,-1290 # 5900 <malloc+0x742>
     e12:	2f4040ef          	jal	5106 <printf>
    exit(1);
     e16:	4505                	li	a0,1
     e18:	6ed030ef          	jal	4d04 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1c:	85ca                	mv	a1,s2
     e1e:	00005517          	auipc	a0,0x5
     e22:	b0250513          	addi	a0,a0,-1278 # 5920 <malloc+0x762>
     e26:	2e0040ef          	jal	5106 <printf>
    exit(1);
     e2a:	4505                	li	a0,1
     e2c:	6d9030ef          	jal	4d04 <exit>
    printf("%s: open lf2 failed\n", s);
     e30:	85ca                	mv	a1,s2
     e32:	00005517          	auipc	a0,0x5
     e36:	b1e50513          	addi	a0,a0,-1250 # 5950 <malloc+0x792>
     e3a:	2cc040ef          	jal	5106 <printf>
    exit(1);
     e3e:	4505                	li	a0,1
     e40:	6c5030ef          	jal	4d04 <exit>
    printf("%s: read lf2 failed\n", s);
     e44:	85ca                	mv	a1,s2
     e46:	00005517          	auipc	a0,0x5
     e4a:	b2250513          	addi	a0,a0,-1246 # 5968 <malloc+0x7aa>
     e4e:	2b8040ef          	jal	5106 <printf>
    exit(1);
     e52:	4505                	li	a0,1
     e54:	6b1030ef          	jal	4d04 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e58:	85ca                	mv	a1,s2
     e5a:	00005517          	auipc	a0,0x5
     e5e:	b2650513          	addi	a0,a0,-1242 # 5980 <malloc+0x7c2>
     e62:	2a4040ef          	jal	5106 <printf>
    exit(1);
     e66:	4505                	li	a0,1
     e68:	69d030ef          	jal	4d04 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6c:	85ca                	mv	a1,s2
     e6e:	00005517          	auipc	a0,0x5
     e72:	b3a50513          	addi	a0,a0,-1222 # 59a8 <malloc+0x7ea>
     e76:	290040ef          	jal	5106 <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	689030ef          	jal	4d04 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e80:	85ca                	mv	a1,s2
     e82:	00005517          	auipc	a0,0x5
     e86:	b5650513          	addi	a0,a0,-1194 # 59d8 <malloc+0x81a>
     e8a:	27c040ef          	jal	5106 <printf>
    exit(1);
     e8e:	4505                	li	a0,1
     e90:	675030ef          	jal	4d04 <exit>

0000000000000e94 <validatetest>:
{
     e94:	7139                	addi	sp,sp,-64
     e96:	fc06                	sd	ra,56(sp)
     e98:	f822                	sd	s0,48(sp)
     e9a:	f426                	sd	s1,40(sp)
     e9c:	f04a                	sd	s2,32(sp)
     e9e:	ec4e                	sd	s3,24(sp)
     ea0:	e852                	sd	s4,16(sp)
     ea2:	e456                	sd	s5,8(sp)
     ea4:	e05a                	sd	s6,0(sp)
     ea6:	0080                	addi	s0,sp,64
     ea8:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eaa:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     eac:	00005997          	auipc	s3,0x5
     eb0:	b4c98993          	addi	s3,s3,-1204 # 59f8 <malloc+0x83a>
     eb4:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eb6:	6a85                	lui	s5,0x1
     eb8:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     ebc:	85a6                	mv	a1,s1
     ebe:	854e                	mv	a0,s3
     ec0:	6a5030ef          	jal	4d64 <link>
     ec4:	01251f63          	bne	a0,s2,ee2 <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ec8:	94d6                	add	s1,s1,s5
     eca:	ff4499e3          	bne	s1,s4,ebc <validatetest+0x28>
}
     ece:	70e2                	ld	ra,56(sp)
     ed0:	7442                	ld	s0,48(sp)
     ed2:	74a2                	ld	s1,40(sp)
     ed4:	7902                	ld	s2,32(sp)
     ed6:	69e2                	ld	s3,24(sp)
     ed8:	6a42                	ld	s4,16(sp)
     eda:	6aa2                	ld	s5,8(sp)
     edc:	6b02                	ld	s6,0(sp)
     ede:	6121                	addi	sp,sp,64
     ee0:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee2:	85da                	mv	a1,s6
     ee4:	00005517          	auipc	a0,0x5
     ee8:	b2450513          	addi	a0,a0,-1244 # 5a08 <malloc+0x84a>
     eec:	21a040ef          	jal	5106 <printf>
      exit(1);
     ef0:	4505                	li	a0,1
     ef2:	613030ef          	jal	4d04 <exit>

0000000000000ef6 <bigdir>:
{
     ef6:	711d                	addi	sp,sp,-96
     ef8:	ec86                	sd	ra,88(sp)
     efa:	e8a2                	sd	s0,80(sp)
     efc:	e4a6                	sd	s1,72(sp)
     efe:	e0ca                	sd	s2,64(sp)
     f00:	fc4e                	sd	s3,56(sp)
     f02:	f852                	sd	s4,48(sp)
     f04:	f456                	sd	s5,40(sp)
     f06:	f05a                	sd	s6,32(sp)
     f08:	ec5e                	sd	s7,24(sp)
     f0a:	1080                	addi	s0,sp,96
     f0c:	89aa                	mv	s3,a0
  unlink("bd");
     f0e:	00005517          	auipc	a0,0x5
     f12:	b1a50513          	addi	a0,a0,-1254 # 5a28 <malloc+0x86a>
     f16:	63f030ef          	jal	4d54 <unlink>
  fd = open("bd", O_CREATE);
     f1a:	20000593          	li	a1,512
     f1e:	00005517          	auipc	a0,0x5
     f22:	b0a50513          	addi	a0,a0,-1270 # 5a28 <malloc+0x86a>
     f26:	61f030ef          	jal	4d44 <open>
  if(fd < 0){
     f2a:	0c054463          	bltz	a0,ff2 <bigdir+0xfc>
  close(fd);
     f2e:	5ff030ef          	jal	4d2c <close>
  for(i = 0; i < N; i++){
     f32:	4901                	li	s2,0
    name[0] = 'x';
     f34:	07800b13          	li	s6,120
    if(link("bd", name) != 0){
     f38:	fa040a93          	addi	s5,s0,-96
     f3c:	00005a17          	auipc	s4,0x5
     f40:	aeca0a13          	addi	s4,s4,-1300 # 5a28 <malloc+0x86a>
  for(i = 0; i < N; i++){
     f44:	1f400b93          	li	s7,500
    name[0] = 'x';
     f48:	fb640023          	sb	s6,-96(s0)
    name[1] = '0' + (i / 64);
     f4c:	41f9571b          	sraiw	a4,s2,0x1f
     f50:	01a7571b          	srliw	a4,a4,0x1a
     f54:	012707bb          	addw	a5,a4,s2
     f58:	4067d69b          	sraiw	a3,a5,0x6
     f5c:	0306869b          	addiw	a3,a3,48
     f60:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f64:	03f7f793          	andi	a5,a5,63
     f68:	9f99                	subw	a5,a5,a4
     f6a:	0307879b          	addiw	a5,a5,48
     f6e:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f72:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
     f76:	85d6                	mv	a1,s5
     f78:	8552                	mv	a0,s4
     f7a:	5eb030ef          	jal	4d64 <link>
     f7e:	84aa                	mv	s1,a0
     f80:	e159                	bnez	a0,1006 <bigdir+0x110>
  for(i = 0; i < N; i++){
     f82:	2905                	addiw	s2,s2,1
     f84:	fd7912e3          	bne	s2,s7,f48 <bigdir+0x52>
  unlink("bd");
     f88:	00005517          	auipc	a0,0x5
     f8c:	aa050513          	addi	a0,a0,-1376 # 5a28 <malloc+0x86a>
     f90:	5c5030ef          	jal	4d54 <unlink>
    name[0] = 'x';
     f94:	07800a13          	li	s4,120
    if(unlink(name) != 0){
     f98:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
     f9c:	1f400a93          	li	s5,500
    name[0] = 'x';
     fa0:	fb440023          	sb	s4,-96(s0)
    name[1] = '0' + (i / 64);
     fa4:	41f4d71b          	sraiw	a4,s1,0x1f
     fa8:	01a7571b          	srliw	a4,a4,0x1a
     fac:	009707bb          	addw	a5,a4,s1
     fb0:	4067d69b          	sraiw	a3,a5,0x6
     fb4:	0306869b          	addiw	a3,a3,48
     fb8:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fbc:	03f7f793          	andi	a5,a5,63
     fc0:	9f99                	subw	a5,a5,a4
     fc2:	0307879b          	addiw	a5,a5,48
     fc6:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fca:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
     fce:	854a                	mv	a0,s2
     fd0:	585030ef          	jal	4d54 <unlink>
     fd4:	e531                	bnez	a0,1020 <bigdir+0x12a>
  for(i = 0; i < N; i++){
     fd6:	2485                	addiw	s1,s1,1
     fd8:	fd5494e3          	bne	s1,s5,fa0 <bigdir+0xaa>
}
     fdc:	60e6                	ld	ra,88(sp)
     fde:	6446                	ld	s0,80(sp)
     fe0:	64a6                	ld	s1,72(sp)
     fe2:	6906                	ld	s2,64(sp)
     fe4:	79e2                	ld	s3,56(sp)
     fe6:	7a42                	ld	s4,48(sp)
     fe8:	7aa2                	ld	s5,40(sp)
     fea:	7b02                	ld	s6,32(sp)
     fec:	6be2                	ld	s7,24(sp)
     fee:	6125                	addi	sp,sp,96
     ff0:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff2:	85ce                	mv	a1,s3
     ff4:	00005517          	auipc	a0,0x5
     ff8:	a3c50513          	addi	a0,a0,-1476 # 5a30 <malloc+0x872>
     ffc:	10a040ef          	jal	5106 <printf>
    exit(1);
    1000:	4505                	li	a0,1
    1002:	503030ef          	jal	4d04 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1006:	fa040693          	addi	a3,s0,-96
    100a:	864a                	mv	a2,s2
    100c:	85ce                	mv	a1,s3
    100e:	00005517          	auipc	a0,0x5
    1012:	a4250513          	addi	a0,a0,-1470 # 5a50 <malloc+0x892>
    1016:	0f0040ef          	jal	5106 <printf>
      exit(1);
    101a:	4505                	li	a0,1
    101c:	4e9030ef          	jal	4d04 <exit>
      printf("%s: bigdir unlink failed", s);
    1020:	85ce                	mv	a1,s3
    1022:	00005517          	auipc	a0,0x5
    1026:	a5650513          	addi	a0,a0,-1450 # 5a78 <malloc+0x8ba>
    102a:	0dc040ef          	jal	5106 <printf>
      exit(1);
    102e:	4505                	li	a0,1
    1030:	4d5030ef          	jal	4d04 <exit>

0000000000001034 <pgbug>:
{
    1034:	7179                	addi	sp,sp,-48
    1036:	f406                	sd	ra,40(sp)
    1038:	f022                	sd	s0,32(sp)
    103a:	ec26                	sd	s1,24(sp)
    103c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1042:	00007497          	auipc	s1,0x7
    1046:	fbe48493          	addi	s1,s1,-66 # 8000 <big>
    104a:	fd840593          	addi	a1,s0,-40
    104e:	6088                	ld	a0,0(s1)
    1050:	4ed030ef          	jal	4d3c <exec>
  pipe(big);
    1054:	6088                	ld	a0,0(s1)
    1056:	4bf030ef          	jal	4d14 <pipe>
  exit(0);
    105a:	4501                	li	a0,0
    105c:	4a9030ef          	jal	4d04 <exit>

0000000000001060 <badarg>:
{
    1060:	7139                	addi	sp,sp,-64
    1062:	fc06                	sd	ra,56(sp)
    1064:	f822                	sd	s0,48(sp)
    1066:	f426                	sd	s1,40(sp)
    1068:	f04a                	sd	s2,32(sp)
    106a:	ec4e                	sd	s3,24(sp)
    106c:	e852                	sd	s4,16(sp)
    106e:	0080                	addi	s0,sp,64
    1070:	64b1                	lui	s1,0xc
    1072:	35048493          	addi	s1,s1,848 # c350 <buf+0x6d8>
    argv[0] = (char*)0xffffffff;
    1076:	597d                	li	s2,-1
    1078:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107c:	fc040a13          	addi	s4,s0,-64
    1080:	00004997          	auipc	s3,0x4
    1084:	26898993          	addi	s3,s3,616 # 52e8 <malloc+0x12a>
    argv[0] = (char*)0xffffffff;
    1088:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108c:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1090:	85d2                	mv	a1,s4
    1092:	854e                	mv	a0,s3
    1094:	4a9030ef          	jal	4d3c <exec>
  for(int i = 0; i < 50000; i++){
    1098:	34fd                	addiw	s1,s1,-1
    109a:	f4fd                	bnez	s1,1088 <badarg+0x28>
  exit(0);
    109c:	4501                	li	a0,0
    109e:	467030ef          	jal	4d04 <exit>

00000000000010a2 <copyinstr2>:
{
    10a2:	7155                	addi	sp,sp,-208
    10a4:	e586                	sd	ra,200(sp)
    10a6:	e1a2                	sd	s0,192(sp)
    10a8:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    10aa:	f6840793          	addi	a5,s0,-152
    10ae:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b2:	07800713          	li	a4,120
    10b6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    10ba:	0785                	addi	a5,a5,1
    10bc:	fed79de3          	bne	a5,a3,10b6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10c0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c4:	f6840513          	addi	a0,s0,-152
    10c8:	48d030ef          	jal	4d54 <unlink>
  if(ret != -1){
    10cc:	57fd                	li	a5,-1
    10ce:	0cf51263          	bne	a0,a5,1192 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d2:	20100593          	li	a1,513
    10d6:	f6840513          	addi	a0,s0,-152
    10da:	46b030ef          	jal	4d44 <open>
  if(fd != -1){
    10de:	57fd                	li	a5,-1
    10e0:	0cf51563          	bne	a0,a5,11aa <copyinstr2+0x108>
  ret = link(b, b);
    10e4:	f6840513          	addi	a0,s0,-152
    10e8:	85aa                	mv	a1,a0
    10ea:	47b030ef          	jal	4d64 <link>
  if(ret != -1){
    10ee:	57fd                	li	a5,-1
    10f0:	0cf51963          	bne	a0,a5,11c2 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    10f4:	00006797          	auipc	a5,0x6
    10f8:	ad478793          	addi	a5,a5,-1324 # 6bc8 <malloc+0x1a0a>
    10fc:	f4f43c23          	sd	a5,-168(s0)
    1100:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1104:	f5840593          	addi	a1,s0,-168
    1108:	f6840513          	addi	a0,s0,-152
    110c:	431030ef          	jal	4d3c <exec>
  if(ret != -1){
    1110:	57fd                	li	a5,-1
    1112:	0cf51563          	bne	a0,a5,11dc <copyinstr2+0x13a>
  int pid = fork();
    1116:	3e7030ef          	jal	4cfc <fork>
  if(pid < 0){
    111a:	0c054d63          	bltz	a0,11f4 <copyinstr2+0x152>
  if(pid == 0){
    111e:	0e051863          	bnez	a0,120e <copyinstr2+0x16c>
    1122:	00007797          	auipc	a5,0x7
    1126:	43e78793          	addi	a5,a5,1086 # 8560 <big.0>
    112a:	00008697          	auipc	a3,0x8
    112e:	43668693          	addi	a3,a3,1078 # 9560 <big.0+0x1000>
      big[i] = 'x';
    1132:	07800713          	li	a4,120
    1136:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    113a:	0785                	addi	a5,a5,1
    113c:	fed79de3          	bne	a5,a3,1136 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    1140:	00008797          	auipc	a5,0x8
    1144:	42078023          	sb	zero,1056(a5) # 9560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1148:	00006797          	auipc	a5,0x6
    114c:	50078793          	addi	a5,a5,1280 # 7648 <malloc+0x248a>
    1150:	6fb0                	ld	a2,88(a5)
    1152:	73b4                	ld	a3,96(a5)
    1154:	77b8                	ld	a4,104(a5)
    1156:	7bbc                	ld	a5,112(a5)
    1158:	f2c43823          	sd	a2,-208(s0)
    115c:	f2d43c23          	sd	a3,-200(s0)
    1160:	f4e43023          	sd	a4,-192(s0)
    1164:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1168:	f3040593          	addi	a1,s0,-208
    116c:	00004517          	auipc	a0,0x4
    1170:	17c50513          	addi	a0,a0,380 # 52e8 <malloc+0x12a>
    1174:	3c9030ef          	jal	4d3c <exec>
    if(ret != -1){
    1178:	57fd                	li	a5,-1
    117a:	08f50663          	beq	a0,a5,1206 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117e:	85be                	mv	a1,a5
    1180:	00005517          	auipc	a0,0x5
    1184:	9a050513          	addi	a0,a0,-1632 # 5b20 <malloc+0x962>
    1188:	77f030ef          	jal	5106 <printf>
      exit(1);
    118c:	4505                	li	a0,1
    118e:	377030ef          	jal	4d04 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1192:	862a                	mv	a2,a0
    1194:	f6840593          	addi	a1,s0,-152
    1198:	00005517          	auipc	a0,0x5
    119c:	90050513          	addi	a0,a0,-1792 # 5a98 <malloc+0x8da>
    11a0:	767030ef          	jal	5106 <printf>
    exit(1);
    11a4:	4505                	li	a0,1
    11a6:	35f030ef          	jal	4d04 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11aa:	862a                	mv	a2,a0
    11ac:	f6840593          	addi	a1,s0,-152
    11b0:	00005517          	auipc	a0,0x5
    11b4:	90850513          	addi	a0,a0,-1784 # 5ab8 <malloc+0x8fa>
    11b8:	74f030ef          	jal	5106 <printf>
    exit(1);
    11bc:	4505                	li	a0,1
    11be:	347030ef          	jal	4d04 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c2:	f6840593          	addi	a1,s0,-152
    11c6:	86aa                	mv	a3,a0
    11c8:	862e                	mv	a2,a1
    11ca:	00005517          	auipc	a0,0x5
    11ce:	90e50513          	addi	a0,a0,-1778 # 5ad8 <malloc+0x91a>
    11d2:	735030ef          	jal	5106 <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	32d030ef          	jal	4d04 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11dc:	863e                	mv	a2,a5
    11de:	f6840593          	addi	a1,s0,-152
    11e2:	00005517          	auipc	a0,0x5
    11e6:	91e50513          	addi	a0,a0,-1762 # 5b00 <malloc+0x942>
    11ea:	71d030ef          	jal	5106 <printf>
    exit(1);
    11ee:	4505                	li	a0,1
    11f0:	315030ef          	jal	4d04 <exit>
    printf("fork failed\n");
    11f4:	00006517          	auipc	a0,0x6
    11f8:	ef450513          	addi	a0,a0,-268 # 70e8 <malloc+0x1f2a>
    11fc:	70b030ef          	jal	5106 <printf>
    exit(1);
    1200:	4505                	li	a0,1
    1202:	303030ef          	jal	4d04 <exit>
    exit(747); // OK
    1206:	2eb00513          	li	a0,747
    120a:	2fb030ef          	jal	4d04 <exit>
  int st = 0;
    120e:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1212:	f5440513          	addi	a0,s0,-172
    1216:	2f7030ef          	jal	4d0c <wait>
  if(st != 747){
    121a:	f5442703          	lw	a4,-172(s0)
    121e:	2eb00793          	li	a5,747
    1222:	00f71663          	bne	a4,a5,122e <copyinstr2+0x18c>
}
    1226:	60ae                	ld	ra,200(sp)
    1228:	640e                	ld	s0,192(sp)
    122a:	6169                	addi	sp,sp,208
    122c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122e:	00005517          	auipc	a0,0x5
    1232:	91a50513          	addi	a0,a0,-1766 # 5b48 <malloc+0x98a>
    1236:	6d1030ef          	jal	5106 <printf>
    exit(1);
    123a:	4505                	li	a0,1
    123c:	2c9030ef          	jal	4d04 <exit>

0000000000001240 <truncate3>:
{
    1240:	7175                	addi	sp,sp,-144
    1242:	e506                	sd	ra,136(sp)
    1244:	e122                	sd	s0,128(sp)
    1246:	ecd6                	sd	s5,88(sp)
    1248:	0900                	addi	s0,sp,144
    124a:	8aaa                	mv	s5,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    124c:	60100593          	li	a1,1537
    1250:	00004517          	auipc	a0,0x4
    1254:	0f050513          	addi	a0,a0,240 # 5340 <malloc+0x182>
    1258:	2ed030ef          	jal	4d44 <open>
    125c:	2d1030ef          	jal	4d2c <close>
  pid = fork();
    1260:	29d030ef          	jal	4cfc <fork>
  if(pid < 0){
    1264:	06054d63          	bltz	a0,12de <truncate3+0x9e>
  if(pid == 0){
    1268:	e171                	bnez	a0,132c <truncate3+0xec>
    126a:	fca6                	sd	s1,120(sp)
    126c:	f8ca                	sd	s2,112(sp)
    126e:	f4ce                	sd	s3,104(sp)
    1270:	f0d2                	sd	s4,96(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	fc66                	sd	s9,56(sp)
    127a:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127e:	4b05                	li	s6,1
    1280:	00004997          	auipc	s3,0x4
    1284:	0c098993          	addi	s3,s3,192 # 5340 <malloc+0x182>
      int n = write(fd, "1234567890", 10);
    1288:	4a29                	li	s4,10
    128a:	00005b97          	auipc	s7,0x5
    128e:	91eb8b93          	addi	s7,s7,-1762 # 5ba8 <malloc+0x9ea>
      read(fd, buf, sizeof(buf));
    1292:	f7840c93          	addi	s9,s0,-136
    1296:	02000c13          	li	s8,32
      int fd = open("truncfile", O_WRONLY);
    129a:	85da                	mv	a1,s6
    129c:	854e                	mv	a0,s3
    129e:	2a7030ef          	jal	4d44 <open>
    12a2:	84aa                	mv	s1,a0
      if(fd < 0){
    12a4:	04054f63          	bltz	a0,1302 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a8:	8652                	mv	a2,s4
    12aa:	85de                	mv	a1,s7
    12ac:	279030ef          	jal	4d24 <write>
      if(n != 10){
    12b0:	07451363          	bne	a0,s4,1316 <truncate3+0xd6>
      close(fd);
    12b4:	8526                	mv	a0,s1
    12b6:	277030ef          	jal	4d2c <close>
      fd = open("truncfile", O_RDONLY);
    12ba:	4581                	li	a1,0
    12bc:	854e                	mv	a0,s3
    12be:	287030ef          	jal	4d44 <open>
    12c2:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c4:	8662                	mv	a2,s8
    12c6:	85e6                	mv	a1,s9
    12c8:	255030ef          	jal	4d1c <read>
      close(fd);
    12cc:	8526                	mv	a0,s1
    12ce:	25f030ef          	jal	4d2c <close>
    for(int i = 0; i < 100; i++){
    12d2:	397d                	addiw	s2,s2,-1
    12d4:	fc0913e3          	bnez	s2,129a <truncate3+0x5a>
    exit(0);
    12d8:	4501                	li	a0,0
    12da:	22b030ef          	jal	4d04 <exit>
    12de:	fca6                	sd	s1,120(sp)
    12e0:	f8ca                	sd	s2,112(sp)
    12e2:	f4ce                	sd	s3,104(sp)
    12e4:	f0d2                	sd	s4,96(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    12ec:	fc66                	sd	s9,56(sp)
    printf("%s: fork failed\n", s);
    12ee:	85d6                	mv	a1,s5
    12f0:	00005517          	auipc	a0,0x5
    12f4:	88850513          	addi	a0,a0,-1912 # 5b78 <malloc+0x9ba>
    12f8:	60f030ef          	jal	5106 <printf>
    exit(1);
    12fc:	4505                	li	a0,1
    12fe:	207030ef          	jal	4d04 <exit>
        printf("%s: open failed\n", s);
    1302:	85d6                	mv	a1,s5
    1304:	00005517          	auipc	a0,0x5
    1308:	88c50513          	addi	a0,a0,-1908 # 5b90 <malloc+0x9d2>
    130c:	5fb030ef          	jal	5106 <printf>
        exit(1);
    1310:	4505                	li	a0,1
    1312:	1f3030ef          	jal	4d04 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1316:	862a                	mv	a2,a0
    1318:	85d6                	mv	a1,s5
    131a:	00005517          	auipc	a0,0x5
    131e:	89e50513          	addi	a0,a0,-1890 # 5bb8 <malloc+0x9fa>
    1322:	5e5030ef          	jal	5106 <printf>
        exit(1);
    1326:	4505                	li	a0,1
    1328:	1dd030ef          	jal	4d04 <exit>
    132c:	fca6                	sd	s1,120(sp)
    132e:	f8ca                	sd	s2,112(sp)
    1330:	f4ce                	sd	s3,104(sp)
    1332:	f0d2                	sd	s4,96(sp)
    1334:	e8da                	sd	s6,80(sp)
    1336:	e4de                	sd	s7,72(sp)
    1338:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    133c:	60100b13          	li	s6,1537
    1340:	00004a17          	auipc	s4,0x4
    1344:	000a0a13          	mv	s4,s4
    int n = write(fd, "xxx", 3);
    1348:	498d                	li	s3,3
    134a:	00005b97          	auipc	s7,0x5
    134e:	88eb8b93          	addi	s7,s7,-1906 # 5bd8 <malloc+0xa1a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1352:	85da                	mv	a1,s6
    1354:	8552                	mv	a0,s4
    1356:	1ef030ef          	jal	4d44 <open>
    135a:	84aa                	mv	s1,a0
    if(fd < 0){
    135c:	02054e63          	bltz	a0,1398 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    1360:	864e                	mv	a2,s3
    1362:	85de                	mv	a1,s7
    1364:	1c1030ef          	jal	4d24 <write>
    if(n != 3){
    1368:	05351463          	bne	a0,s3,13b0 <truncate3+0x170>
    close(fd);
    136c:	8526                	mv	a0,s1
    136e:	1bf030ef          	jal	4d2c <close>
  for(int i = 0; i < 150; i++){
    1372:	397d                	addiw	s2,s2,-1
    1374:	fc091fe3          	bnez	s2,1352 <truncate3+0x112>
    1378:	e0e2                	sd	s8,64(sp)
    137a:	fc66                	sd	s9,56(sp)
  wait(&xstatus);
    137c:	f9c40513          	addi	a0,s0,-100
    1380:	18d030ef          	jal	4d0c <wait>
  unlink("truncfile");
    1384:	00004517          	auipc	a0,0x4
    1388:	fbc50513          	addi	a0,a0,-68 # 5340 <malloc+0x182>
    138c:	1c9030ef          	jal	4d54 <unlink>
  exit(xstatus);
    1390:	f9c42503          	lw	a0,-100(s0)
    1394:	171030ef          	jal	4d04 <exit>
    1398:	e0e2                	sd	s8,64(sp)
    139a:	fc66                	sd	s9,56(sp)
      printf("%s: open failed\n", s);
    139c:	85d6                	mv	a1,s5
    139e:	00004517          	auipc	a0,0x4
    13a2:	7f250513          	addi	a0,a0,2034 # 5b90 <malloc+0x9d2>
    13a6:	561030ef          	jal	5106 <printf>
      exit(1);
    13aa:	4505                	li	a0,1
    13ac:	159030ef          	jal	4d04 <exit>
    13b0:	e0e2                	sd	s8,64(sp)
    13b2:	fc66                	sd	s9,56(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b4:	862a                	mv	a2,a0
    13b6:	85d6                	mv	a1,s5
    13b8:	00005517          	auipc	a0,0x5
    13bc:	82850513          	addi	a0,a0,-2008 # 5be0 <malloc+0xa22>
    13c0:	547030ef          	jal	5106 <printf>
      exit(1);
    13c4:	4505                	li	a0,1
    13c6:	13f030ef          	jal	4d04 <exit>

00000000000013ca <exectest>:
{
    13ca:	715d                	addi	sp,sp,-80
    13cc:	e486                	sd	ra,72(sp)
    13ce:	e0a2                	sd	s0,64(sp)
    13d0:	f84a                	sd	s2,48(sp)
    13d2:	0880                	addi	s0,sp,80
    13d4:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    13d6:	00004797          	auipc	a5,0x4
    13da:	f1278793          	addi	a5,a5,-238 # 52e8 <malloc+0x12a>
    13de:	fcf43023          	sd	a5,-64(s0)
    13e2:	00005797          	auipc	a5,0x5
    13e6:	81e78793          	addi	a5,a5,-2018 # 5c00 <malloc+0xa42>
    13ea:	fcf43423          	sd	a5,-56(s0)
    13ee:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    13f2:	00005517          	auipc	a0,0x5
    13f6:	81650513          	addi	a0,a0,-2026 # 5c08 <malloc+0xa4a>
    13fa:	15b030ef          	jal	4d54 <unlink>
  pid = fork();
    13fe:	0ff030ef          	jal	4cfc <fork>
  if(pid < 0) {
    1402:	02054f63          	bltz	a0,1440 <exectest+0x76>
    1406:	fc26                	sd	s1,56(sp)
    1408:	84aa                	mv	s1,a0
  if(pid == 0) {
    140a:	e935                	bnez	a0,147e <exectest+0xb4>
    close(1);
    140c:	4505                	li	a0,1
    140e:	11f030ef          	jal	4d2c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1412:	20100593          	li	a1,513
    1416:	00004517          	auipc	a0,0x4
    141a:	7f250513          	addi	a0,a0,2034 # 5c08 <malloc+0xa4a>
    141e:	127030ef          	jal	4d44 <open>
    if(fd < 0) {
    1422:	02054a63          	bltz	a0,1456 <exectest+0x8c>
    if(fd != 1) {
    1426:	4785                	li	a5,1
    1428:	04f50163          	beq	a0,a5,146a <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    142c:	85ca                	mv	a1,s2
    142e:	00004517          	auipc	a0,0x4
    1432:	7fa50513          	addi	a0,a0,2042 # 5c28 <malloc+0xa6a>
    1436:	4d1030ef          	jal	5106 <printf>
      exit(1);
    143a:	4505                	li	a0,1
    143c:	0c9030ef          	jal	4d04 <exit>
    1440:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1442:	85ca                	mv	a1,s2
    1444:	00004517          	auipc	a0,0x4
    1448:	73450513          	addi	a0,a0,1844 # 5b78 <malloc+0x9ba>
    144c:	4bb030ef          	jal	5106 <printf>
     exit(1);
    1450:	4505                	li	a0,1
    1452:	0b3030ef          	jal	4d04 <exit>
      printf("%s: create failed\n", s);
    1456:	85ca                	mv	a1,s2
    1458:	00004517          	auipc	a0,0x4
    145c:	7b850513          	addi	a0,a0,1976 # 5c10 <malloc+0xa52>
    1460:	4a7030ef          	jal	5106 <printf>
      exit(1);
    1464:	4505                	li	a0,1
    1466:	09f030ef          	jal	4d04 <exit>
    if(exec("echo", echoargv) < 0){
    146a:	fc040593          	addi	a1,s0,-64
    146e:	00004517          	auipc	a0,0x4
    1472:	e7a50513          	addi	a0,a0,-390 # 52e8 <malloc+0x12a>
    1476:	0c7030ef          	jal	4d3c <exec>
    147a:	00054d63          	bltz	a0,1494 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    147e:	fdc40513          	addi	a0,s0,-36
    1482:	08b030ef          	jal	4d0c <wait>
    1486:	02951163          	bne	a0,s1,14a8 <exectest+0xde>
  if(xstatus != 0)
    148a:	fdc42503          	lw	a0,-36(s0)
    148e:	c50d                	beqz	a0,14b8 <exectest+0xee>
    exit(xstatus);
    1490:	075030ef          	jal	4d04 <exit>
      printf("%s: exec echo failed\n", s);
    1494:	85ca                	mv	a1,s2
    1496:	00004517          	auipc	a0,0x4
    149a:	7a250513          	addi	a0,a0,1954 # 5c38 <malloc+0xa7a>
    149e:	469030ef          	jal	5106 <printf>
      exit(1);
    14a2:	4505                	li	a0,1
    14a4:	061030ef          	jal	4d04 <exit>
    printf("%s: wait failed!\n", s);
    14a8:	85ca                	mv	a1,s2
    14aa:	00004517          	auipc	a0,0x4
    14ae:	7a650513          	addi	a0,a0,1958 # 5c50 <malloc+0xa92>
    14b2:	455030ef          	jal	5106 <printf>
    14b6:	bfd1                	j	148a <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    14b8:	4581                	li	a1,0
    14ba:	00004517          	auipc	a0,0x4
    14be:	74e50513          	addi	a0,a0,1870 # 5c08 <malloc+0xa4a>
    14c2:	083030ef          	jal	4d44 <open>
  if(fd < 0) {
    14c6:	02054463          	bltz	a0,14ee <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    14ca:	4609                	li	a2,2
    14cc:	fb840593          	addi	a1,s0,-72
    14d0:	04d030ef          	jal	4d1c <read>
    14d4:	4789                	li	a5,2
    14d6:	02f50663          	beq	a0,a5,1502 <exectest+0x138>
    printf("%s: read failed\n", s);
    14da:	85ca                	mv	a1,s2
    14dc:	00004517          	auipc	a0,0x4
    14e0:	1dc50513          	addi	a0,a0,476 # 56b8 <malloc+0x4fa>
    14e4:	423030ef          	jal	5106 <printf>
    exit(1);
    14e8:	4505                	li	a0,1
    14ea:	01b030ef          	jal	4d04 <exit>
    printf("%s: open failed\n", s);
    14ee:	85ca                	mv	a1,s2
    14f0:	00004517          	auipc	a0,0x4
    14f4:	6a050513          	addi	a0,a0,1696 # 5b90 <malloc+0x9d2>
    14f8:	40f030ef          	jal	5106 <printf>
    exit(1);
    14fc:	4505                	li	a0,1
    14fe:	007030ef          	jal	4d04 <exit>
  unlink("echo-ok");
    1502:	00004517          	auipc	a0,0x4
    1506:	70650513          	addi	a0,a0,1798 # 5c08 <malloc+0xa4a>
    150a:	04b030ef          	jal	4d54 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    150e:	fb844703          	lbu	a4,-72(s0)
    1512:	04f00793          	li	a5,79
    1516:	00f71863          	bne	a4,a5,1526 <exectest+0x15c>
    151a:	fb944703          	lbu	a4,-71(s0)
    151e:	04b00793          	li	a5,75
    1522:	00f70c63          	beq	a4,a5,153a <exectest+0x170>
    printf("%s: wrong output\n", s);
    1526:	85ca                	mv	a1,s2
    1528:	00004517          	auipc	a0,0x4
    152c:	74050513          	addi	a0,a0,1856 # 5c68 <malloc+0xaaa>
    1530:	3d7030ef          	jal	5106 <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	7ce030ef          	jal	4d04 <exit>
    exit(0);
    153a:	4501                	li	a0,0
    153c:	7c8030ef          	jal	4d04 <exit>

0000000000001540 <pipe1>:
{
    1540:	711d                	addi	sp,sp,-96
    1542:	ec86                	sd	ra,88(sp)
    1544:	e8a2                	sd	s0,80(sp)
    1546:	e0ca                	sd	s2,64(sp)
    1548:	1080                	addi	s0,sp,96
    154a:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    154c:	fa840513          	addi	a0,s0,-88
    1550:	7c4030ef          	jal	4d14 <pipe>
    1554:	e53d                	bnez	a0,15c2 <pipe1+0x82>
    1556:	e4a6                	sd	s1,72(sp)
    1558:	f852                	sd	s4,48(sp)
    155a:	84aa                	mv	s1,a0
  pid = fork();
    155c:	7a0030ef          	jal	4cfc <fork>
    1560:	8a2a                	mv	s4,a0
  if(pid == 0){
    1562:	c149                	beqz	a0,15e4 <pipe1+0xa4>
  } else if(pid > 0){
    1564:	14a05f63          	blez	a0,16c2 <pipe1+0x182>
    1568:	fc4e                	sd	s3,56(sp)
    156a:	f456                	sd	s5,40(sp)
    close(fds[1]);
    156c:	fac42503          	lw	a0,-84(s0)
    1570:	7bc030ef          	jal	4d2c <close>
    total = 0;
    1574:	8a26                	mv	s4,s1
    cc = 1;
    1576:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1578:	0000aa97          	auipc	s5,0xa
    157c:	700a8a93          	addi	s5,s5,1792 # bc78 <buf>
    1580:	864e                	mv	a2,s3
    1582:	85d6                	mv	a1,s5
    1584:	fa842503          	lw	a0,-88(s0)
    1588:	794030ef          	jal	4d1c <read>
    158c:	0ea05963          	blez	a0,167e <pipe1+0x13e>
    1590:	0000a717          	auipc	a4,0xa
    1594:	6e870713          	addi	a4,a4,1768 # bc78 <buf>
    1598:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    159c:	00074683          	lbu	a3,0(a4)
    15a0:	0ff4f793          	zext.b	a5,s1
    15a4:	2485                	addiw	s1,s1,1
    15a6:	0af69c63          	bne	a3,a5,165e <pipe1+0x11e>
      for(i = 0; i < n; i++){
    15aa:	0705                	addi	a4,a4,1
    15ac:	fec498e3          	bne	s1,a2,159c <pipe1+0x5c>
      total += n;
    15b0:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    15b4:	0019999b          	slliw	s3,s3,0x1
      if(cc > sizeof(buf))
    15b8:	678d                	lui	a5,0x3
    15ba:	fd37f3e3          	bgeu	a5,s3,1580 <pipe1+0x40>
        cc = sizeof(buf);
    15be:	89be                	mv	s3,a5
    15c0:	b7c1                	j	1580 <pipe1+0x40>
    15c2:	e4a6                	sd	s1,72(sp)
    15c4:	fc4e                	sd	s3,56(sp)
    15c6:	f852                	sd	s4,48(sp)
    15c8:	f456                	sd	s5,40(sp)
    15ca:	f05a                	sd	s6,32(sp)
    15cc:	ec5e                	sd	s7,24(sp)
    15ce:	e862                	sd	s8,16(sp)
    printf("%s: pipe() failed\n", s);
    15d0:	85ca                	mv	a1,s2
    15d2:	00004517          	auipc	a0,0x4
    15d6:	6ae50513          	addi	a0,a0,1710 # 5c80 <malloc+0xac2>
    15da:	32d030ef          	jal	5106 <printf>
    exit(1);
    15de:	4505                	li	a0,1
    15e0:	724030ef          	jal	4d04 <exit>
    15e4:	fc4e                	sd	s3,56(sp)
    15e6:	f456                	sd	s5,40(sp)
    15e8:	f05a                	sd	s6,32(sp)
    15ea:	ec5e                	sd	s7,24(sp)
    15ec:	e862                	sd	s8,16(sp)
    close(fds[0]);
    15ee:	fa842503          	lw	a0,-88(s0)
    15f2:	73a030ef          	jal	4d2c <close>
    for(n = 0; n < N; n++){
    15f6:	0000ab97          	auipc	s7,0xa
    15fa:	682b8b93          	addi	s7,s7,1666 # bc78 <buf>
    15fe:	417004bb          	negw	s1,s7
    1602:	0ff4f493          	zext.b	s1,s1
    1606:	409b8993          	addi	s3,s7,1033
      if(write(fds[1], buf, SZ) != SZ){
    160a:	40900a93          	li	s5,1033
    160e:	8c5e                	mv	s8,s7
    for(n = 0; n < N; n++){
    1610:	6b05                	lui	s6,0x1
    1612:	42db0b13          	addi	s6,s6,1069 # 142d <exectest+0x63>
{
    1616:	87de                	mv	a5,s7
        buf[i] = seq++;
    1618:	0097873b          	addw	a4,a5,s1
    161c:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x302>
      for(i = 0; i < SZ; i++)
    1620:	0785                	addi	a5,a5,1
    1622:	ff379be3          	bne	a5,s3,1618 <pipe1+0xd8>
    1626:	409a0a1b          	addiw	s4,s4,1033 # 5749 <malloc+0x58b>
      if(write(fds[1], buf, SZ) != SZ){
    162a:	8656                	mv	a2,s5
    162c:	85e2                	mv	a1,s8
    162e:	fac42503          	lw	a0,-84(s0)
    1632:	6f2030ef          	jal	4d24 <write>
    1636:	01551a63          	bne	a0,s5,164a <pipe1+0x10a>
    for(n = 0; n < N; n++){
    163a:	24a5                	addiw	s1,s1,9
    163c:	0ff4f493          	zext.b	s1,s1
    1640:	fd6a1be3          	bne	s4,s6,1616 <pipe1+0xd6>
    exit(0);
    1644:	4501                	li	a0,0
    1646:	6be030ef          	jal	4d04 <exit>
        printf("%s: pipe1 oops 1\n", s);
    164a:	85ca                	mv	a1,s2
    164c:	00004517          	auipc	a0,0x4
    1650:	64c50513          	addi	a0,a0,1612 # 5c98 <malloc+0xada>
    1654:	2b3030ef          	jal	5106 <printf>
        exit(1);
    1658:	4505                	li	a0,1
    165a:	6aa030ef          	jal	4d04 <exit>
          printf("%s: pipe1 oops 2\n", s);
    165e:	85ca                	mv	a1,s2
    1660:	00004517          	auipc	a0,0x4
    1664:	65050513          	addi	a0,a0,1616 # 5cb0 <malloc+0xaf2>
    1668:	29f030ef          	jal	5106 <printf>
          return;
    166c:	64a6                	ld	s1,72(sp)
    166e:	79e2                	ld	s3,56(sp)
    1670:	7a42                	ld	s4,48(sp)
    1672:	7aa2                	ld	s5,40(sp)
}
    1674:	60e6                	ld	ra,88(sp)
    1676:	6446                	ld	s0,80(sp)
    1678:	6906                	ld	s2,64(sp)
    167a:	6125                	addi	sp,sp,96
    167c:	8082                	ret
    if(total != N * SZ){
    167e:	6785                	lui	a5,0x1
    1680:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0x63>
    1684:	02fa0063          	beq	s4,a5,16a4 <pipe1+0x164>
    1688:	f05a                	sd	s6,32(sp)
    168a:	ec5e                	sd	s7,24(sp)
    168c:	e862                	sd	s8,16(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    168e:	8652                	mv	a2,s4
    1690:	85ca                	mv	a1,s2
    1692:	00004517          	auipc	a0,0x4
    1696:	63650513          	addi	a0,a0,1590 # 5cc8 <malloc+0xb0a>
    169a:	26d030ef          	jal	5106 <printf>
      exit(1);
    169e:	4505                	li	a0,1
    16a0:	664030ef          	jal	4d04 <exit>
    16a4:	f05a                	sd	s6,32(sp)
    16a6:	ec5e                	sd	s7,24(sp)
    16a8:	e862                	sd	s8,16(sp)
    close(fds[0]);
    16aa:	fa842503          	lw	a0,-88(s0)
    16ae:	67e030ef          	jal	4d2c <close>
    wait(&xstatus);
    16b2:	fa440513          	addi	a0,s0,-92
    16b6:	656030ef          	jal	4d0c <wait>
    exit(xstatus);
    16ba:	fa442503          	lw	a0,-92(s0)
    16be:	646030ef          	jal	4d04 <exit>
    16c2:	fc4e                	sd	s3,56(sp)
    16c4:	f456                	sd	s5,40(sp)
    16c6:	f05a                	sd	s6,32(sp)
    16c8:	ec5e                	sd	s7,24(sp)
    16ca:	e862                	sd	s8,16(sp)
    printf("%s: fork() failed\n", s);
    16cc:	85ca                	mv	a1,s2
    16ce:	00004517          	auipc	a0,0x4
    16d2:	61a50513          	addi	a0,a0,1562 # 5ce8 <malloc+0xb2a>
    16d6:	231030ef          	jal	5106 <printf>
    exit(1);
    16da:	4505                	li	a0,1
    16dc:	628030ef          	jal	4d04 <exit>

00000000000016e0 <exitwait>:
{
    16e0:	715d                	addi	sp,sp,-80
    16e2:	e486                	sd	ra,72(sp)
    16e4:	e0a2                	sd	s0,64(sp)
    16e6:	fc26                	sd	s1,56(sp)
    16e8:	f84a                	sd	s2,48(sp)
    16ea:	f44e                	sd	s3,40(sp)
    16ec:	f052                	sd	s4,32(sp)
    16ee:	ec56                	sd	s5,24(sp)
    16f0:	0880                	addi	s0,sp,80
    16f2:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    16f4:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    16f6:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    16fa:	06400a13          	li	s4,100
    pid = fork();
    16fe:	5fe030ef          	jal	4cfc <fork>
    1702:	84aa                	mv	s1,a0
    if(pid < 0){
    1704:	02054863          	bltz	a0,1734 <exitwait+0x54>
    if(pid){
    1708:	c525                	beqz	a0,1770 <exitwait+0x90>
      if(wait(&xstate) != pid){
    170a:	854e                	mv	a0,s3
    170c:	600030ef          	jal	4d0c <wait>
    1710:	02951c63          	bne	a0,s1,1748 <exitwait+0x68>
      if(i != xstate) {
    1714:	fbc42783          	lw	a5,-68(s0)
    1718:	05279263          	bne	a5,s2,175c <exitwait+0x7c>
  for(i = 0; i < 100; i++){
    171c:	2905                	addiw	s2,s2,1
    171e:	ff4910e3          	bne	s2,s4,16fe <exitwait+0x1e>
}
    1722:	60a6                	ld	ra,72(sp)
    1724:	6406                	ld	s0,64(sp)
    1726:	74e2                	ld	s1,56(sp)
    1728:	7942                	ld	s2,48(sp)
    172a:	79a2                	ld	s3,40(sp)
    172c:	7a02                	ld	s4,32(sp)
    172e:	6ae2                	ld	s5,24(sp)
    1730:	6161                	addi	sp,sp,80
    1732:	8082                	ret
      printf("%s: fork failed\n", s);
    1734:	85d6                	mv	a1,s5
    1736:	00004517          	auipc	a0,0x4
    173a:	44250513          	addi	a0,a0,1090 # 5b78 <malloc+0x9ba>
    173e:	1c9030ef          	jal	5106 <printf>
      exit(1);
    1742:	4505                	li	a0,1
    1744:	5c0030ef          	jal	4d04 <exit>
        printf("%s: wait wrong pid\n", s);
    1748:	85d6                	mv	a1,s5
    174a:	00004517          	auipc	a0,0x4
    174e:	5b650513          	addi	a0,a0,1462 # 5d00 <malloc+0xb42>
    1752:	1b5030ef          	jal	5106 <printf>
        exit(1);
    1756:	4505                	li	a0,1
    1758:	5ac030ef          	jal	4d04 <exit>
        printf("%s: wait wrong exit status\n", s);
    175c:	85d6                	mv	a1,s5
    175e:	00004517          	auipc	a0,0x4
    1762:	5ba50513          	addi	a0,a0,1466 # 5d18 <malloc+0xb5a>
    1766:	1a1030ef          	jal	5106 <printf>
        exit(1);
    176a:	4505                	li	a0,1
    176c:	598030ef          	jal	4d04 <exit>
      exit(i);
    1770:	854a                	mv	a0,s2
    1772:	592030ef          	jal	4d04 <exit>

0000000000001776 <twochildren>:
{
    1776:	1101                	addi	sp,sp,-32
    1778:	ec06                	sd	ra,24(sp)
    177a:	e822                	sd	s0,16(sp)
    177c:	e426                	sd	s1,8(sp)
    177e:	e04a                	sd	s2,0(sp)
    1780:	1000                	addi	s0,sp,32
    1782:	892a                	mv	s2,a0
    1784:	3e800493          	li	s1,1000
    int pid1 = fork();
    1788:	574030ef          	jal	4cfc <fork>
    if(pid1 < 0){
    178c:	02054663          	bltz	a0,17b8 <twochildren+0x42>
    if(pid1 == 0){
    1790:	cd15                	beqz	a0,17cc <twochildren+0x56>
      int pid2 = fork();
    1792:	56a030ef          	jal	4cfc <fork>
      if(pid2 < 0){
    1796:	02054d63          	bltz	a0,17d0 <twochildren+0x5a>
      if(pid2 == 0){
    179a:	c529                	beqz	a0,17e4 <twochildren+0x6e>
        wait(0);
    179c:	4501                	li	a0,0
    179e:	56e030ef          	jal	4d0c <wait>
        wait(0);
    17a2:	4501                	li	a0,0
    17a4:	568030ef          	jal	4d0c <wait>
  for(int i = 0; i < 1000; i++){
    17a8:	34fd                	addiw	s1,s1,-1
    17aa:	fcf9                	bnez	s1,1788 <twochildren+0x12>
}
    17ac:	60e2                	ld	ra,24(sp)
    17ae:	6442                	ld	s0,16(sp)
    17b0:	64a2                	ld	s1,8(sp)
    17b2:	6902                	ld	s2,0(sp)
    17b4:	6105                	addi	sp,sp,32
    17b6:	8082                	ret
      printf("%s: fork failed\n", s);
    17b8:	85ca                	mv	a1,s2
    17ba:	00004517          	auipc	a0,0x4
    17be:	3be50513          	addi	a0,a0,958 # 5b78 <malloc+0x9ba>
    17c2:	145030ef          	jal	5106 <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	53c030ef          	jal	4d04 <exit>
      exit(0);
    17cc:	538030ef          	jal	4d04 <exit>
        printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00004517          	auipc	a0,0x4
    17d6:	3a650513          	addi	a0,a0,934 # 5b78 <malloc+0x9ba>
    17da:	12d030ef          	jal	5106 <printf>
        exit(1);
    17de:	4505                	li	a0,1
    17e0:	524030ef          	jal	4d04 <exit>
        exit(0);
    17e4:	520030ef          	jal	4d04 <exit>

00000000000017e8 <forkfork>:
{
    17e8:	7179                	addi	sp,sp,-48
    17ea:	f406                	sd	ra,40(sp)
    17ec:	f022                	sd	s0,32(sp)
    17ee:	ec26                	sd	s1,24(sp)
    17f0:	1800                	addi	s0,sp,48
    17f2:	84aa                	mv	s1,a0
    int pid = fork();
    17f4:	508030ef          	jal	4cfc <fork>
    if(pid < 0){
    17f8:	02054b63          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    17fc:	c139                	beqz	a0,1842 <forkfork+0x5a>
    int pid = fork();
    17fe:	4fe030ef          	jal	4cfc <fork>
    if(pid < 0){
    1802:	02054663          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    1806:	cd15                	beqz	a0,1842 <forkfork+0x5a>
    wait(&xstatus);
    1808:	fdc40513          	addi	a0,s0,-36
    180c:	500030ef          	jal	4d0c <wait>
    if(xstatus != 0) {
    1810:	fdc42783          	lw	a5,-36(s0)
    1814:	ebb9                	bnez	a5,186a <forkfork+0x82>
    wait(&xstatus);
    1816:	fdc40513          	addi	a0,s0,-36
    181a:	4f2030ef          	jal	4d0c <wait>
    if(xstatus != 0) {
    181e:	fdc42783          	lw	a5,-36(s0)
    1822:	e7a1                	bnez	a5,186a <forkfork+0x82>
}
    1824:	70a2                	ld	ra,40(sp)
    1826:	7402                	ld	s0,32(sp)
    1828:	64e2                	ld	s1,24(sp)
    182a:	6145                	addi	sp,sp,48
    182c:	8082                	ret
      printf("%s: fork failed", s);
    182e:	85a6                	mv	a1,s1
    1830:	00004517          	auipc	a0,0x4
    1834:	50850513          	addi	a0,a0,1288 # 5d38 <malloc+0xb7a>
    1838:	0cf030ef          	jal	5106 <printf>
      exit(1);
    183c:	4505                	li	a0,1
    183e:	4c6030ef          	jal	4d04 <exit>
{
    1842:	0c800493          	li	s1,200
        int pid1 = fork();
    1846:	4b6030ef          	jal	4cfc <fork>
        if(pid1 < 0){
    184a:	00054b63          	bltz	a0,1860 <forkfork+0x78>
        if(pid1 == 0){
    184e:	cd01                	beqz	a0,1866 <forkfork+0x7e>
        wait(0);
    1850:	4501                	li	a0,0
    1852:	4ba030ef          	jal	4d0c <wait>
      for(int j = 0; j < 200; j++){
    1856:	34fd                	addiw	s1,s1,-1
    1858:	f4fd                	bnez	s1,1846 <forkfork+0x5e>
      exit(0);
    185a:	4501                	li	a0,0
    185c:	4a8030ef          	jal	4d04 <exit>
          exit(1);
    1860:	4505                	li	a0,1
    1862:	4a2030ef          	jal	4d04 <exit>
          exit(0);
    1866:	49e030ef          	jal	4d04 <exit>
      printf("%s: fork in child failed", s);
    186a:	85a6                	mv	a1,s1
    186c:	00004517          	auipc	a0,0x4
    1870:	4dc50513          	addi	a0,a0,1244 # 5d48 <malloc+0xb8a>
    1874:	093030ef          	jal	5106 <printf>
      exit(1);
    1878:	4505                	li	a0,1
    187a:	48a030ef          	jal	4d04 <exit>

000000000000187e <reparent2>:
{
    187e:	1101                	addi	sp,sp,-32
    1880:	ec06                	sd	ra,24(sp)
    1882:	e822                	sd	s0,16(sp)
    1884:	e426                	sd	s1,8(sp)
    1886:	1000                	addi	s0,sp,32
    1888:	32000493          	li	s1,800
    int pid1 = fork();
    188c:	470030ef          	jal	4cfc <fork>
    if(pid1 < 0){
    1890:	00054b63          	bltz	a0,18a6 <reparent2+0x28>
    if(pid1 == 0){
    1894:	c115                	beqz	a0,18b8 <reparent2+0x3a>
    wait(0);
    1896:	4501                	li	a0,0
    1898:	474030ef          	jal	4d0c <wait>
  for(int i = 0; i < 800; i++){
    189c:	34fd                	addiw	s1,s1,-1
    189e:	f4fd                	bnez	s1,188c <reparent2+0xe>
  exit(0);
    18a0:	4501                	li	a0,0
    18a2:	462030ef          	jal	4d04 <exit>
      printf("fork failed\n");
    18a6:	00006517          	auipc	a0,0x6
    18aa:	84250513          	addi	a0,a0,-1982 # 70e8 <malloc+0x1f2a>
    18ae:	059030ef          	jal	5106 <printf>
      exit(1);
    18b2:	4505                	li	a0,1
    18b4:	450030ef          	jal	4d04 <exit>
      fork();
    18b8:	444030ef          	jal	4cfc <fork>
      fork();
    18bc:	440030ef          	jal	4cfc <fork>
      exit(0);
    18c0:	4501                	li	a0,0
    18c2:	442030ef          	jal	4d04 <exit>

00000000000018c6 <createdelete>:
{
    18c6:	7175                	addi	sp,sp,-144
    18c8:	e506                	sd	ra,136(sp)
    18ca:	e122                	sd	s0,128(sp)
    18cc:	fca6                	sd	s1,120(sp)
    18ce:	f8ca                	sd	s2,112(sp)
    18d0:	f4ce                	sd	s3,104(sp)
    18d2:	f0d2                	sd	s4,96(sp)
    18d4:	ecd6                	sd	s5,88(sp)
    18d6:	e8da                	sd	s6,80(sp)
    18d8:	e4de                	sd	s7,72(sp)
    18da:	e0e2                	sd	s8,64(sp)
    18dc:	fc66                	sd	s9,56(sp)
    18de:	f86a                	sd	s10,48(sp)
    18e0:	0900                	addi	s0,sp,144
    18e2:	8d2a                	mv	s10,a0
  for(pi = 0; pi < NCHILD; pi++){
    18e4:	4901                	li	s2,0
    18e6:	4991                	li	s3,4
    pid = fork();
    18e8:	414030ef          	jal	4cfc <fork>
    18ec:	84aa                	mv	s1,a0
    if(pid < 0){
    18ee:	02054e63          	bltz	a0,192a <createdelete+0x64>
    if(pid == 0){
    18f2:	c531                	beqz	a0,193e <createdelete+0x78>
  for(pi = 0; pi < NCHILD; pi++){
    18f4:	2905                	addiw	s2,s2,1
    18f6:	ff3919e3          	bne	s2,s3,18e8 <createdelete+0x22>
    18fa:	4491                	li	s1,4
    wait(&xstatus);
    18fc:	f7c40993          	addi	s3,s0,-132
    1900:	854e                	mv	a0,s3
    1902:	40a030ef          	jal	4d0c <wait>
    if(xstatus != 0)
    1906:	f7c42903          	lw	s2,-132(s0)
    190a:	0c091063          	bnez	s2,19ca <createdelete+0x104>
  for(pi = 0; pi < NCHILD; pi++){
    190e:	34fd                	addiw	s1,s1,-1
    1910:	f8e5                	bnez	s1,1900 <createdelete+0x3a>
  name[0] = name[1] = name[2] = 0;
    1912:	f8040123          	sb	zero,-126(s0)
    1916:	03000993          	li	s3,48
    191a:	5afd                	li	s5,-1
    191c:	07000c93          	li	s9,112
      if((i == 0 || i >= N/2) && fd < 0){
    1920:	4ba5                	li	s7,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1922:	4c21                	li	s8,8
    for(pi = 0; pi < NCHILD; pi++){
    1924:	07400b13          	li	s6,116
    1928:	a205                	j	1a48 <createdelete+0x182>
      printf("%s: fork failed\n", s);
    192a:	85ea                	mv	a1,s10
    192c:	00004517          	auipc	a0,0x4
    1930:	24c50513          	addi	a0,a0,588 # 5b78 <malloc+0x9ba>
    1934:	7d2030ef          	jal	5106 <printf>
      exit(1);
    1938:	4505                	li	a0,1
    193a:	3ca030ef          	jal	4d04 <exit>
      name[0] = 'p' + pi;
    193e:	0709091b          	addiw	s2,s2,112
    1942:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1946:	f8040123          	sb	zero,-126(s0)
        fd = open(name, O_CREATE | O_RDWR);
    194a:	f8040913          	addi	s2,s0,-128
    194e:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1952:	4a51                	li	s4,20
    1954:	a815                	j	1988 <createdelete+0xc2>
          printf("%s: create failed\n", s);
    1956:	85ea                	mv	a1,s10
    1958:	00004517          	auipc	a0,0x4
    195c:	2b850513          	addi	a0,a0,696 # 5c10 <malloc+0xa52>
    1960:	7a6030ef          	jal	5106 <printf>
          exit(1);
    1964:	4505                	li	a0,1
    1966:	39e030ef          	jal	4d04 <exit>
          name[1] = '0' + (i / 2);
    196a:	01f4d79b          	srliw	a5,s1,0x1f
    196e:	9fa5                	addw	a5,a5,s1
    1970:	4017d79b          	sraiw	a5,a5,0x1
    1974:	0307879b          	addiw	a5,a5,48
    1978:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    197c:	854a                	mv	a0,s2
    197e:	3d6030ef          	jal	4d54 <unlink>
    1982:	02054a63          	bltz	a0,19b6 <createdelete+0xf0>
      for(i = 0; i < N; i++){
    1986:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1988:	0304879b          	addiw	a5,s1,48
    198c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1990:	85ce                	mv	a1,s3
    1992:	854a                	mv	a0,s2
    1994:	3b0030ef          	jal	4d44 <open>
        if(fd < 0){
    1998:	fa054fe3          	bltz	a0,1956 <createdelete+0x90>
        close(fd);
    199c:	390030ef          	jal	4d2c <close>
        if(i > 0 && (i % 2 ) == 0){
    19a0:	fe9053e3          	blez	s1,1986 <createdelete+0xc0>
    19a4:	0014f793          	andi	a5,s1,1
    19a8:	d3e9                	beqz	a5,196a <createdelete+0xa4>
      for(i = 0; i < N; i++){
    19aa:	2485                	addiw	s1,s1,1
    19ac:	fd449ee3          	bne	s1,s4,1988 <createdelete+0xc2>
      exit(0);
    19b0:	4501                	li	a0,0
    19b2:	352030ef          	jal	4d04 <exit>
            printf("%s: unlink failed\n", s);
    19b6:	85ea                	mv	a1,s10
    19b8:	00004517          	auipc	a0,0x4
    19bc:	3b050513          	addi	a0,a0,944 # 5d68 <malloc+0xbaa>
    19c0:	746030ef          	jal	5106 <printf>
            exit(1);
    19c4:	4505                	li	a0,1
    19c6:	33e030ef          	jal	4d04 <exit>
      exit(1);
    19ca:	4505                	li	a0,1
    19cc:	338030ef          	jal	4d04 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    19d0:	f8040613          	addi	a2,s0,-128
    19d4:	85ea                	mv	a1,s10
    19d6:	00004517          	auipc	a0,0x4
    19da:	3aa50513          	addi	a0,a0,938 # 5d80 <malloc+0xbc2>
    19de:	728030ef          	jal	5106 <printf>
        exit(1);
    19e2:	4505                	li	a0,1
    19e4:	320030ef          	jal	4d04 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    19e8:	035c7a63          	bgeu	s8,s5,1a1c <createdelete+0x156>
      if(fd >= 0)
    19ec:	02055563          	bgez	a0,1a16 <createdelete+0x150>
    for(pi = 0; pi < NCHILD; pi++){
    19f0:	2485                	addiw	s1,s1,1
    19f2:	0ff4f493          	zext.b	s1,s1
    19f6:	05648163          	beq	s1,s6,1a38 <createdelete+0x172>
      name[0] = 'p' + pi;
    19fa:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19fe:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1a02:	4581                	li	a1,0
    1a04:	8552                	mv	a0,s4
    1a06:	33e030ef          	jal	4d44 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1a0a:	00090463          	beqz	s2,1a12 <createdelete+0x14c>
    1a0e:	fd2bdde3          	bge	s7,s2,19e8 <createdelete+0x122>
    1a12:	fa054fe3          	bltz	a0,19d0 <createdelete+0x10a>
        close(fd);
    1a16:	316030ef          	jal	4d2c <close>
    1a1a:	bfd9                	j	19f0 <createdelete+0x12a>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a1c:	fc054ae3          	bltz	a0,19f0 <createdelete+0x12a>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1a20:	f8040613          	addi	a2,s0,-128
    1a24:	85ea                	mv	a1,s10
    1a26:	00004517          	auipc	a0,0x4
    1a2a:	38250513          	addi	a0,a0,898 # 5da8 <malloc+0xbea>
    1a2e:	6d8030ef          	jal	5106 <printf>
        exit(1);
    1a32:	4505                	li	a0,1
    1a34:	2d0030ef          	jal	4d04 <exit>
  for(i = 0; i < N; i++){
    1a38:	2905                	addiw	s2,s2,1
    1a3a:	2a85                	addiw	s5,s5,1
    1a3c:	2985                	addiw	s3,s3,1
    1a3e:	0ff9f993          	zext.b	s3,s3
    1a42:	47d1                	li	a5,20
    1a44:	00f90663          	beq	s2,a5,1a50 <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1a48:	84e6                	mv	s1,s9
      fd = open(name, 0);
    1a4a:	f8040a13          	addi	s4,s0,-128
    1a4e:	b775                	j	19fa <createdelete+0x134>
    1a50:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    1a54:	07000b13          	li	s6,112
      unlink(name);
    1a58:	f8040a13          	addi	s4,s0,-128
    for(pi = 0; pi < NCHILD; pi++){
    1a5c:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1a60:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    1a64:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    1a66:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1a6a:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    1a6e:	8552                	mv	a0,s4
    1a70:	2e4030ef          	jal	4d54 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1a74:	2485                	addiw	s1,s1,1
    1a76:	0ff4f493          	zext.b	s1,s1
    1a7a:	ff3496e3          	bne	s1,s3,1a66 <createdelete+0x1a0>
  for(i = 0; i < N; i++){
    1a7e:	2905                	addiw	s2,s2,1
    1a80:	0ff97913          	zext.b	s2,s2
    1a84:	ff5910e3          	bne	s2,s5,1a64 <createdelete+0x19e>
}
    1a88:	60aa                	ld	ra,136(sp)
    1a8a:	640a                	ld	s0,128(sp)
    1a8c:	74e6                	ld	s1,120(sp)
    1a8e:	7946                	ld	s2,112(sp)
    1a90:	79a6                	ld	s3,104(sp)
    1a92:	7a06                	ld	s4,96(sp)
    1a94:	6ae6                	ld	s5,88(sp)
    1a96:	6b46                	ld	s6,80(sp)
    1a98:	6ba6                	ld	s7,72(sp)
    1a9a:	6c06                	ld	s8,64(sp)
    1a9c:	7ce2                	ld	s9,56(sp)
    1a9e:	7d42                	ld	s10,48(sp)
    1aa0:	6149                	addi	sp,sp,144
    1aa2:	8082                	ret

0000000000001aa4 <linkunlink>:
{
    1aa4:	711d                	addi	sp,sp,-96
    1aa6:	ec86                	sd	ra,88(sp)
    1aa8:	e8a2                	sd	s0,80(sp)
    1aaa:	e4a6                	sd	s1,72(sp)
    1aac:	e0ca                	sd	s2,64(sp)
    1aae:	fc4e                	sd	s3,56(sp)
    1ab0:	f852                	sd	s4,48(sp)
    1ab2:	f456                	sd	s5,40(sp)
    1ab4:	f05a                	sd	s6,32(sp)
    1ab6:	ec5e                	sd	s7,24(sp)
    1ab8:	e862                	sd	s8,16(sp)
    1aba:	e466                	sd	s9,8(sp)
    1abc:	e06a                	sd	s10,0(sp)
    1abe:	1080                	addi	s0,sp,96
    1ac0:	84aa                	mv	s1,a0
  unlink("x");
    1ac2:	00004517          	auipc	a0,0x4
    1ac6:	89650513          	addi	a0,a0,-1898 # 5358 <malloc+0x19a>
    1aca:	28a030ef          	jal	4d54 <unlink>
  pid = fork();
    1ace:	22e030ef          	jal	4cfc <fork>
  if(pid < 0){
    1ad2:	04054363          	bltz	a0,1b18 <linkunlink+0x74>
    1ad6:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1ad8:	06100913          	li	s2,97
    1adc:	c111                	beqz	a0,1ae0 <linkunlink+0x3c>
    1ade:	4905                	li	s2,1
    1ae0:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1ae4:	41c65ab7          	lui	s5,0x41c65
    1ae8:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c561f5>
    1aec:	6a0d                	lui	s4,0x3
    1aee:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x33b>
    if((x % 3) == 0){
    1af2:	000ab9b7          	lui	s3,0xab
    1af6:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9be33>
    1afa:	09b2                	slli	s3,s3,0xc
    1afc:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1b00:	4b85                	li	s7,1
      unlink("x");
    1b02:	00004b17          	auipc	s6,0x4
    1b06:	856b0b13          	addi	s6,s6,-1962 # 5358 <malloc+0x19a>
      link("cat", "x");
    1b0a:	00004c97          	auipc	s9,0x4
    1b0e:	2c6c8c93          	addi	s9,s9,710 # 5dd0 <malloc+0xc12>
      close(open("x", O_RDWR | O_CREATE));
    1b12:	20200c13          	li	s8,514
    1b16:	a03d                	j	1b44 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1b18:	85a6                	mv	a1,s1
    1b1a:	00004517          	auipc	a0,0x4
    1b1e:	05e50513          	addi	a0,a0,94 # 5b78 <malloc+0x9ba>
    1b22:	5e4030ef          	jal	5106 <printf>
    exit(1);
    1b26:	4505                	li	a0,1
    1b28:	1dc030ef          	jal	4d04 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1b2c:	85e2                	mv	a1,s8
    1b2e:	855a                	mv	a0,s6
    1b30:	214030ef          	jal	4d44 <open>
    1b34:	1f8030ef          	jal	4d2c <close>
    1b38:	a021                	j	1b40 <linkunlink+0x9c>
      unlink("x");
    1b3a:	855a                	mv	a0,s6
    1b3c:	218030ef          	jal	4d54 <unlink>
  for(i = 0; i < 100; i++){
    1b40:	34fd                	addiw	s1,s1,-1
    1b42:	c885                	beqz	s1,1b72 <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    1b44:	035907bb          	mulw	a5,s2,s5
    1b48:	00fa07bb          	addw	a5,s4,a5
    1b4c:	893e                	mv	s2,a5
    if((x % 3) == 0){
    1b4e:	02079713          	slli	a4,a5,0x20
    1b52:	9301                	srli	a4,a4,0x20
    1b54:	03370733          	mul	a4,a4,s3
    1b58:	9305                	srli	a4,a4,0x21
    1b5a:	0017169b          	slliw	a3,a4,0x1
    1b5e:	9f35                	addw	a4,a4,a3
    1b60:	9f99                	subw	a5,a5,a4
    1b62:	d7e9                	beqz	a5,1b2c <linkunlink+0x88>
    } else if((x % 3) == 1){
    1b64:	fd779be3          	bne	a5,s7,1b3a <linkunlink+0x96>
      link("cat", "x");
    1b68:	85da                	mv	a1,s6
    1b6a:	8566                	mv	a0,s9
    1b6c:	1f8030ef          	jal	4d64 <link>
    1b70:	bfc1                	j	1b40 <linkunlink+0x9c>
  if(pid)
    1b72:	020d0363          	beqz	s10,1b98 <linkunlink+0xf4>
    wait(0);
    1b76:	4501                	li	a0,0
    1b78:	194030ef          	jal	4d0c <wait>
}
    1b7c:	60e6                	ld	ra,88(sp)
    1b7e:	6446                	ld	s0,80(sp)
    1b80:	64a6                	ld	s1,72(sp)
    1b82:	6906                	ld	s2,64(sp)
    1b84:	79e2                	ld	s3,56(sp)
    1b86:	7a42                	ld	s4,48(sp)
    1b88:	7aa2                	ld	s5,40(sp)
    1b8a:	7b02                	ld	s6,32(sp)
    1b8c:	6be2                	ld	s7,24(sp)
    1b8e:	6c42                	ld	s8,16(sp)
    1b90:	6ca2                	ld	s9,8(sp)
    1b92:	6d02                	ld	s10,0(sp)
    1b94:	6125                	addi	sp,sp,96
    1b96:	8082                	ret
    exit(0);
    1b98:	4501                	li	a0,0
    1b9a:	16a030ef          	jal	4d04 <exit>

0000000000001b9e <forktest>:
{
    1b9e:	7179                	addi	sp,sp,-48
    1ba0:	f406                	sd	ra,40(sp)
    1ba2:	f022                	sd	s0,32(sp)
    1ba4:	ec26                	sd	s1,24(sp)
    1ba6:	e84a                	sd	s2,16(sp)
    1ba8:	e44e                	sd	s3,8(sp)
    1baa:	1800                	addi	s0,sp,48
    1bac:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1bae:	4481                	li	s1,0
    1bb0:	3e800913          	li	s2,1000
    pid = fork();
    1bb4:	148030ef          	jal	4cfc <fork>
    if(pid < 0)
    1bb8:	06054063          	bltz	a0,1c18 <forktest+0x7a>
    if(pid == 0)
    1bbc:	cd11                	beqz	a0,1bd8 <forktest+0x3a>
  for(n=0; n<N; n++){
    1bbe:	2485                	addiw	s1,s1,1
    1bc0:	ff249ae3          	bne	s1,s2,1bb4 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1bc4:	85ce                	mv	a1,s3
    1bc6:	00004517          	auipc	a0,0x4
    1bca:	25a50513          	addi	a0,a0,602 # 5e20 <malloc+0xc62>
    1bce:	538030ef          	jal	5106 <printf>
    exit(1);
    1bd2:	4505                	li	a0,1
    1bd4:	130030ef          	jal	4d04 <exit>
      exit(0);
    1bd8:	12c030ef          	jal	4d04 <exit>
    printf("%s: no fork at all!\n", s);
    1bdc:	85ce                	mv	a1,s3
    1bde:	00004517          	auipc	a0,0x4
    1be2:	1fa50513          	addi	a0,a0,506 # 5dd8 <malloc+0xc1a>
    1be6:	520030ef          	jal	5106 <printf>
    exit(1);
    1bea:	4505                	li	a0,1
    1bec:	118030ef          	jal	4d04 <exit>
      printf("%s: wait stopped early\n", s);
    1bf0:	85ce                	mv	a1,s3
    1bf2:	00004517          	auipc	a0,0x4
    1bf6:	1fe50513          	addi	a0,a0,510 # 5df0 <malloc+0xc32>
    1bfa:	50c030ef          	jal	5106 <printf>
      exit(1);
    1bfe:	4505                	li	a0,1
    1c00:	104030ef          	jal	4d04 <exit>
    printf("%s: wait got too many\n", s);
    1c04:	85ce                	mv	a1,s3
    1c06:	00004517          	auipc	a0,0x4
    1c0a:	20250513          	addi	a0,a0,514 # 5e08 <malloc+0xc4a>
    1c0e:	4f8030ef          	jal	5106 <printf>
    exit(1);
    1c12:	4505                	li	a0,1
    1c14:	0f0030ef          	jal	4d04 <exit>
  if (n == 0) {
    1c18:	d0f1                	beqz	s1,1bdc <forktest+0x3e>
    if(wait(0) < 0){
    1c1a:	4501                	li	a0,0
    1c1c:	0f0030ef          	jal	4d0c <wait>
    1c20:	fc0548e3          	bltz	a0,1bf0 <forktest+0x52>
  for(; n > 0; n--){
    1c24:	34fd                	addiw	s1,s1,-1
    1c26:	fe904ae3          	bgtz	s1,1c1a <forktest+0x7c>
  if(wait(0) != -1){
    1c2a:	4501                	li	a0,0
    1c2c:	0e0030ef          	jal	4d0c <wait>
    1c30:	57fd                	li	a5,-1
    1c32:	fcf519e3          	bne	a0,a5,1c04 <forktest+0x66>
}
    1c36:	70a2                	ld	ra,40(sp)
    1c38:	7402                	ld	s0,32(sp)
    1c3a:	64e2                	ld	s1,24(sp)
    1c3c:	6942                	ld	s2,16(sp)
    1c3e:	69a2                	ld	s3,8(sp)
    1c40:	6145                	addi	sp,sp,48
    1c42:	8082                	ret

0000000000001c44 <kernmem>:
{
    1c44:	715d                	addi	sp,sp,-80
    1c46:	e486                	sd	ra,72(sp)
    1c48:	e0a2                	sd	s0,64(sp)
    1c4a:	fc26                	sd	s1,56(sp)
    1c4c:	f84a                	sd	s2,48(sp)
    1c4e:	f44e                	sd	s3,40(sp)
    1c50:	f052                	sd	s4,32(sp)
    1c52:	ec56                	sd	s5,24(sp)
    1c54:	e85a                	sd	s6,16(sp)
    1c56:	0880                	addi	s0,sp,80
    1c58:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c5a:	08100493          	li	s1,129
    1c5e:	04e2                	slli	s1,s1,0x18
    wait(&xstatus);
    1c60:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    1c64:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c66:	69b1                	lui	s3,0xc
    1c68:	35098993          	addi	s3,s3,848 # c350 <buf+0x6d8>
    1c6c:	1023d937          	lui	s2,0x1023d
    1c70:	090e                	slli	s2,s2,0x3
    1c72:	48090913          	addi	s2,s2,1152 # 1023d480 <base+0x1022e808>
    pid = fork();
    1c76:	086030ef          	jal	4cfc <fork>
    if(pid < 0){
    1c7a:	02054763          	bltz	a0,1ca8 <kernmem+0x64>
    if(pid == 0){
    1c7e:	cd1d                	beqz	a0,1cbc <kernmem+0x78>
    wait(&xstatus);
    1c80:	8556                	mv	a0,s5
    1c82:	08a030ef          	jal	4d0c <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c86:	fbc42783          	lw	a5,-68(s0)
    1c8a:	05479663          	bne	a5,s4,1cd6 <kernmem+0x92>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c8e:	94ce                	add	s1,s1,s3
    1c90:	ff2493e3          	bne	s1,s2,1c76 <kernmem+0x32>
}
    1c94:	60a6                	ld	ra,72(sp)
    1c96:	6406                	ld	s0,64(sp)
    1c98:	74e2                	ld	s1,56(sp)
    1c9a:	7942                	ld	s2,48(sp)
    1c9c:	79a2                	ld	s3,40(sp)
    1c9e:	7a02                	ld	s4,32(sp)
    1ca0:	6ae2                	ld	s5,24(sp)
    1ca2:	6b42                	ld	s6,16(sp)
    1ca4:	6161                	addi	sp,sp,80
    1ca6:	8082                	ret
      printf("%s: fork failed\n", s);
    1ca8:	85da                	mv	a1,s6
    1caa:	00004517          	auipc	a0,0x4
    1cae:	ece50513          	addi	a0,a0,-306 # 5b78 <malloc+0x9ba>
    1cb2:	454030ef          	jal	5106 <printf>
      exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	04c030ef          	jal	4d04 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1cbc:	0004c683          	lbu	a3,0(s1)
    1cc0:	8626                	mv	a2,s1
    1cc2:	85da                	mv	a1,s6
    1cc4:	00004517          	auipc	a0,0x4
    1cc8:	18450513          	addi	a0,a0,388 # 5e48 <malloc+0xc8a>
    1ccc:	43a030ef          	jal	5106 <printf>
      exit(1);
    1cd0:	4505                	li	a0,1
    1cd2:	032030ef          	jal	4d04 <exit>
      exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	02c030ef          	jal	4d04 <exit>

0000000000001cdc <MAXVAplus>:
{
    1cdc:	7139                	addi	sp,sp,-64
    1cde:	fc06                	sd	ra,56(sp)
    1ce0:	f822                	sd	s0,48(sp)
    1ce2:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1ce4:	4785                	li	a5,1
    1ce6:	179a                	slli	a5,a5,0x26
    1ce8:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    1cec:	fc843783          	ld	a5,-56(s0)
    1cf0:	cf9d                	beqz	a5,1d2e <MAXVAplus+0x52>
    1cf2:	f426                	sd	s1,40(sp)
    1cf4:	f04a                	sd	s2,32(sp)
    1cf6:	ec4e                	sd	s3,24(sp)
    1cf8:	89aa                	mv	s3,a0
    wait(&xstatus);
    1cfa:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    1cfe:	54fd                	li	s1,-1
    pid = fork();
    1d00:	7fd020ef          	jal	4cfc <fork>
    if(pid < 0){
    1d04:	02054963          	bltz	a0,1d36 <MAXVAplus+0x5a>
    if(pid == 0){
    1d08:	c129                	beqz	a0,1d4a <MAXVAplus+0x6e>
    wait(&xstatus);
    1d0a:	854a                	mv	a0,s2
    1d0c:	000030ef          	jal	4d0c <wait>
    if(xstatus != -1)  // did kernel kill child?
    1d10:	fc442783          	lw	a5,-60(s0)
    1d14:	04979d63          	bne	a5,s1,1d6e <MAXVAplus+0x92>
  for( ; a != 0; a <<= 1){
    1d18:	fc843783          	ld	a5,-56(s0)
    1d1c:	0786                	slli	a5,a5,0x1
    1d1e:	fcf43423          	sd	a5,-56(s0)
    1d22:	fc843783          	ld	a5,-56(s0)
    1d26:	ffe9                	bnez	a5,1d00 <MAXVAplus+0x24>
    1d28:	74a2                	ld	s1,40(sp)
    1d2a:	7902                	ld	s2,32(sp)
    1d2c:	69e2                	ld	s3,24(sp)
}
    1d2e:	70e2                	ld	ra,56(sp)
    1d30:	7442                	ld	s0,48(sp)
    1d32:	6121                	addi	sp,sp,64
    1d34:	8082                	ret
      printf("%s: fork failed\n", s);
    1d36:	85ce                	mv	a1,s3
    1d38:	00004517          	auipc	a0,0x4
    1d3c:	e4050513          	addi	a0,a0,-448 # 5b78 <malloc+0x9ba>
    1d40:	3c6030ef          	jal	5106 <printf>
      exit(1);
    1d44:	4505                	li	a0,1
    1d46:	7bf020ef          	jal	4d04 <exit>
      *(char*)a = 99;
    1d4a:	fc843783          	ld	a5,-56(s0)
    1d4e:	06300713          	li	a4,99
    1d52:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1d56:	fc843603          	ld	a2,-56(s0)
    1d5a:	85ce                	mv	a1,s3
    1d5c:	00004517          	auipc	a0,0x4
    1d60:	10c50513          	addi	a0,a0,268 # 5e68 <malloc+0xcaa>
    1d64:	3a2030ef          	jal	5106 <printf>
      exit(1);
    1d68:	4505                	li	a0,1
    1d6a:	79b020ef          	jal	4d04 <exit>
      exit(1);
    1d6e:	4505                	li	a0,1
    1d70:	795020ef          	jal	4d04 <exit>

0000000000001d74 <stacktest>:
{
    1d74:	7179                	addi	sp,sp,-48
    1d76:	f406                	sd	ra,40(sp)
    1d78:	f022                	sd	s0,32(sp)
    1d7a:	ec26                	sd	s1,24(sp)
    1d7c:	1800                	addi	s0,sp,48
    1d7e:	84aa                	mv	s1,a0
  pid = fork();
    1d80:	77d020ef          	jal	4cfc <fork>
  if(pid == 0) {
    1d84:	cd11                	beqz	a0,1da0 <stacktest+0x2c>
  } else if(pid < 0){
    1d86:	02054c63          	bltz	a0,1dbe <stacktest+0x4a>
  wait(&xstatus);
    1d8a:	fdc40513          	addi	a0,s0,-36
    1d8e:	77f020ef          	jal	4d0c <wait>
  if(xstatus == -1)  // kernel killed child?
    1d92:	fdc42503          	lw	a0,-36(s0)
    1d96:	57fd                	li	a5,-1
    1d98:	02f50d63          	beq	a0,a5,1dd2 <stacktest+0x5e>
    exit(xstatus);
    1d9c:	769020ef          	jal	4d04 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1da0:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1da2:	77fd                	lui	a5,0xfffff
    1da4:	97ba                	add	a5,a5,a4
    1da6:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0388>
    1daa:	85a6                	mv	a1,s1
    1dac:	00004517          	auipc	a0,0x4
    1db0:	0d450513          	addi	a0,a0,212 # 5e80 <malloc+0xcc2>
    1db4:	352030ef          	jal	5106 <printf>
    exit(1);
    1db8:	4505                	li	a0,1
    1dba:	74b020ef          	jal	4d04 <exit>
    printf("%s: fork failed\n", s);
    1dbe:	85a6                	mv	a1,s1
    1dc0:	00004517          	auipc	a0,0x4
    1dc4:	db850513          	addi	a0,a0,-584 # 5b78 <malloc+0x9ba>
    1dc8:	33e030ef          	jal	5106 <printf>
    exit(1);
    1dcc:	4505                	li	a0,1
    1dce:	737020ef          	jal	4d04 <exit>
    exit(0);
    1dd2:	4501                	li	a0,0
    1dd4:	731020ef          	jal	4d04 <exit>

0000000000001dd8 <nowrite>:
{
    1dd8:	7159                	addi	sp,sp,-112
    1dda:	f486                	sd	ra,104(sp)
    1ddc:	f0a2                	sd	s0,96(sp)
    1dde:	eca6                	sd	s1,88(sp)
    1de0:	e8ca                	sd	s2,80(sp)
    1de2:	e4ce                	sd	s3,72(sp)
    1de4:	e0d2                	sd	s4,64(sp)
    1de6:	1880                	addi	s0,sp,112
    1de8:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1dea:	00006797          	auipc	a5,0x6
    1dee:	85e78793          	addi	a5,a5,-1954 # 7648 <malloc+0x248a>
    1df2:	7788                	ld	a0,40(a5)
    1df4:	7b8c                	ld	a1,48(a5)
    1df6:	7f90                	ld	a2,56(a5)
    1df8:	63b4                	ld	a3,64(a5)
    1dfa:	67b8                	ld	a4,72(a5)
    1dfc:	6bbc                	ld	a5,80(a5)
    1dfe:	f8a43c23          	sd	a0,-104(s0)
    1e02:	fab43023          	sd	a1,-96(s0)
    1e06:	fac43423          	sd	a2,-88(s0)
    1e0a:	fad43823          	sd	a3,-80(s0)
    1e0e:	fae43c23          	sd	a4,-72(s0)
    1e12:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e16:	4481                	li	s1,0
    wait(&xstatus);
    1e18:	fcc40913          	addi	s2,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e1c:	4999                	li	s3,6
    pid = fork();
    1e1e:	6df020ef          	jal	4cfc <fork>
    if(pid == 0) {
    1e22:	cd19                	beqz	a0,1e40 <nowrite+0x68>
    } else if(pid < 0){
    1e24:	04054163          	bltz	a0,1e66 <nowrite+0x8e>
    wait(&xstatus);
    1e28:	854a                	mv	a0,s2
    1e2a:	6e3020ef          	jal	4d0c <wait>
    if(xstatus == 0){
    1e2e:	fcc42783          	lw	a5,-52(s0)
    1e32:	c7a1                	beqz	a5,1e7a <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e34:	2485                	addiw	s1,s1,1
    1e36:	ff3494e3          	bne	s1,s3,1e1e <nowrite+0x46>
  exit(0);
    1e3a:	4501                	li	a0,0
    1e3c:	6c9020ef          	jal	4d04 <exit>
      volatile int *addr = (int *) addrs[ai];
    1e40:	048e                	slli	s1,s1,0x3
    1e42:	fd048793          	addi	a5,s1,-48
    1e46:	008784b3          	add	s1,a5,s0
    1e4a:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1e4e:	47a9                	li	a5,10
    1e50:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1e52:	85d2                	mv	a1,s4
    1e54:	00004517          	auipc	a0,0x4
    1e58:	05450513          	addi	a0,a0,84 # 5ea8 <malloc+0xcea>
    1e5c:	2aa030ef          	jal	5106 <printf>
      exit(0);
    1e60:	4501                	li	a0,0
    1e62:	6a3020ef          	jal	4d04 <exit>
      printf("%s: fork failed\n", s);
    1e66:	85d2                	mv	a1,s4
    1e68:	00004517          	auipc	a0,0x4
    1e6c:	d1050513          	addi	a0,a0,-752 # 5b78 <malloc+0x9ba>
    1e70:	296030ef          	jal	5106 <printf>
      exit(1);
    1e74:	4505                	li	a0,1
    1e76:	68f020ef          	jal	4d04 <exit>
      exit(1);
    1e7a:	4505                	li	a0,1
    1e7c:	689020ef          	jal	4d04 <exit>

0000000000001e80 <manywrites>:
{
    1e80:	7159                	addi	sp,sp,-112
    1e82:	f486                	sd	ra,104(sp)
    1e84:	f0a2                	sd	s0,96(sp)
    1e86:	eca6                	sd	s1,88(sp)
    1e88:	e8ca                	sd	s2,80(sp)
    1e8a:	e4ce                	sd	s3,72(sp)
    1e8c:	fc56                	sd	s5,56(sp)
    1e8e:	1880                	addi	s0,sp,112
    1e90:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1e92:	4901                	li	s2,0
    1e94:	4991                	li	s3,4
    int pid = fork();
    1e96:	667020ef          	jal	4cfc <fork>
    1e9a:	84aa                	mv	s1,a0
    if(pid < 0){
    1e9c:	02054d63          	bltz	a0,1ed6 <manywrites+0x56>
    if(pid == 0){
    1ea0:	c931                	beqz	a0,1ef4 <manywrites+0x74>
  for(int ci = 0; ci < nchildren; ci++){
    1ea2:	2905                	addiw	s2,s2,1
    1ea4:	ff3919e3          	bne	s2,s3,1e96 <manywrites+0x16>
    1ea8:	4491                	li	s1,4
    wait(&st);
    1eaa:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1eae:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1eb2:	854a                	mv	a0,s2
    1eb4:	659020ef          	jal	4d0c <wait>
    if(st != 0)
    1eb8:	f9842503          	lw	a0,-104(s0)
    1ebc:	0e051463          	bnez	a0,1fa4 <manywrites+0x124>
  for(int ci = 0; ci < nchildren; ci++){
    1ec0:	34fd                	addiw	s1,s1,-1
    1ec2:	f4f5                	bnez	s1,1eae <manywrites+0x2e>
    1ec4:	e0d2                	sd	s4,64(sp)
    1ec6:	f85a                	sd	s6,48(sp)
    1ec8:	f45e                	sd	s7,40(sp)
    1eca:	f062                	sd	s8,32(sp)
    1ecc:	ec66                	sd	s9,24(sp)
    1ece:	e86a                	sd	s10,16(sp)
  exit(0);
    1ed0:	4501                	li	a0,0
    1ed2:	633020ef          	jal	4d04 <exit>
    1ed6:	e0d2                	sd	s4,64(sp)
    1ed8:	f85a                	sd	s6,48(sp)
    1eda:	f45e                	sd	s7,40(sp)
    1edc:	f062                	sd	s8,32(sp)
    1ede:	ec66                	sd	s9,24(sp)
    1ee0:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1ee2:	00005517          	auipc	a0,0x5
    1ee6:	20650513          	addi	a0,a0,518 # 70e8 <malloc+0x1f2a>
    1eea:	21c030ef          	jal	5106 <printf>
      exit(1);
    1eee:	4505                	li	a0,1
    1ef0:	615020ef          	jal	4d04 <exit>
    1ef4:	e0d2                	sd	s4,64(sp)
    1ef6:	f85a                	sd	s6,48(sp)
    1ef8:	f45e                	sd	s7,40(sp)
    1efa:	f062                	sd	s8,32(sp)
    1efc:	ec66                	sd	s9,24(sp)
    1efe:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1f00:	06200793          	li	a5,98
    1f04:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1f08:	0619079b          	addiw	a5,s2,97
    1f0c:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1f10:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1f14:	f9840513          	addi	a0,s0,-104
    1f18:	63d020ef          	jal	4d54 <unlink>
    1f1c:	4d79                	li	s10,30
          int fd = open(name, O_CREATE | O_RDWR);
    1f1e:	f9840c13          	addi	s8,s0,-104
    1f22:	20200b93          	li	s7,514
          int cc = write(fd, buf, sz);
    1f26:	6b0d                	lui	s6,0x3
    1f28:	0000ac97          	auipc	s9,0xa
    1f2c:	d50c8c93          	addi	s9,s9,-688 # bc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1f30:	8a26                	mv	s4,s1
          int fd = open(name, O_CREATE | O_RDWR);
    1f32:	85de                	mv	a1,s7
    1f34:	8562                	mv	a0,s8
    1f36:	60f020ef          	jal	4d44 <open>
    1f3a:	89aa                	mv	s3,a0
          if(fd < 0){
    1f3c:	02054c63          	bltz	a0,1f74 <manywrites+0xf4>
          int cc = write(fd, buf, sz);
    1f40:	865a                	mv	a2,s6
    1f42:	85e6                	mv	a1,s9
    1f44:	5e1020ef          	jal	4d24 <write>
          if(cc != sz){
    1f48:	05651263          	bne	a0,s6,1f8c <manywrites+0x10c>
          close(fd);
    1f4c:	854e                	mv	a0,s3
    1f4e:	5df020ef          	jal	4d2c <close>
        for(int i = 0; i < ci+1; i++){
    1f52:	2a05                	addiw	s4,s4,1
    1f54:	fd495fe3          	bge	s2,s4,1f32 <manywrites+0xb2>
        unlink(name);
    1f58:	f9840513          	addi	a0,s0,-104
    1f5c:	5f9020ef          	jal	4d54 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f60:	3d7d                	addiw	s10,s10,-1
    1f62:	fc0d17e3          	bnez	s10,1f30 <manywrites+0xb0>
      unlink(name);
    1f66:	f9840513          	addi	a0,s0,-104
    1f6a:	5eb020ef          	jal	4d54 <unlink>
      exit(0);
    1f6e:	4501                	li	a0,0
    1f70:	595020ef          	jal	4d04 <exit>
            printf("%s: cannot create %s\n", s, name);
    1f74:	f9840613          	addi	a2,s0,-104
    1f78:	85d6                	mv	a1,s5
    1f7a:	00004517          	auipc	a0,0x4
    1f7e:	f4e50513          	addi	a0,a0,-178 # 5ec8 <malloc+0xd0a>
    1f82:	184030ef          	jal	5106 <printf>
            exit(1);
    1f86:	4505                	li	a0,1
    1f88:	57d020ef          	jal	4d04 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1f8c:	86aa                	mv	a3,a0
    1f8e:	660d                	lui	a2,0x3
    1f90:	85d6                	mv	a1,s5
    1f92:	00003517          	auipc	a0,0x3
    1f96:	42650513          	addi	a0,a0,1062 # 53b8 <malloc+0x1fa>
    1f9a:	16c030ef          	jal	5106 <printf>
            exit(1);
    1f9e:	4505                	li	a0,1
    1fa0:	565020ef          	jal	4d04 <exit>
    1fa4:	e0d2                	sd	s4,64(sp)
    1fa6:	f85a                	sd	s6,48(sp)
    1fa8:	f45e                	sd	s7,40(sp)
    1faa:	f062                	sd	s8,32(sp)
    1fac:	ec66                	sd	s9,24(sp)
    1fae:	e86a                	sd	s10,16(sp)
      exit(st);
    1fb0:	555020ef          	jal	4d04 <exit>

0000000000001fb4 <copyinstr3>:
{
    1fb4:	7179                	addi	sp,sp,-48
    1fb6:	f406                	sd	ra,40(sp)
    1fb8:	f022                	sd	s0,32(sp)
    1fba:	ec26                	sd	s1,24(sp)
    1fbc:	1800                	addi	s0,sp,48
  sbrk(8192);
    1fbe:	6509                	lui	a0,0x2
    1fc0:	5cd020ef          	jal	4d8c <sbrk>
  uint64 top = (uint64) sbrk(0);
    1fc4:	4501                	li	a0,0
    1fc6:	5c7020ef          	jal	4d8c <sbrk>
  if((top % PGSIZE) != 0){
    1fca:	03451793          	slli	a5,a0,0x34
    1fce:	e7bd                	bnez	a5,203c <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1fd0:	4501                	li	a0,0
    1fd2:	5bb020ef          	jal	4d8c <sbrk>
  if(top % PGSIZE){
    1fd6:	03451793          	slli	a5,a0,0x34
    1fda:	ebb5                	bnez	a5,204e <copyinstr3+0x9a>
  char *b = (char *) (top - 1);
    1fdc:	fff50493          	addi	s1,a0,-1 # 1fff <copyinstr3+0x4b>
  *b = 'x';
    1fe0:	07800793          	li	a5,120
    1fe4:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1fe8:	8526                	mv	a0,s1
    1fea:	56b020ef          	jal	4d54 <unlink>
  if(ret != -1){
    1fee:	57fd                	li	a5,-1
    1ff0:	06f51863          	bne	a0,a5,2060 <copyinstr3+0xac>
  int fd = open(b, O_CREATE | O_WRONLY);
    1ff4:	20100593          	li	a1,513
    1ff8:	8526                	mv	a0,s1
    1ffa:	54b020ef          	jal	4d44 <open>
  if(fd != -1){
    1ffe:	57fd                	li	a5,-1
    2000:	06f51b63          	bne	a0,a5,2076 <copyinstr3+0xc2>
  ret = link(b, b);
    2004:	85a6                	mv	a1,s1
    2006:	8526                	mv	a0,s1
    2008:	55d020ef          	jal	4d64 <link>
  if(ret != -1){
    200c:	57fd                	li	a5,-1
    200e:	06f51f63          	bne	a0,a5,208c <copyinstr3+0xd8>
  char *args[] = { "xx", 0 };
    2012:	00005797          	auipc	a5,0x5
    2016:	bb678793          	addi	a5,a5,-1098 # 6bc8 <malloc+0x1a0a>
    201a:	fcf43823          	sd	a5,-48(s0)
    201e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2022:	fd040593          	addi	a1,s0,-48
    2026:	8526                	mv	a0,s1
    2028:	515020ef          	jal	4d3c <exec>
  if(ret != -1){
    202c:	57fd                	li	a5,-1
    202e:	06f51b63          	bne	a0,a5,20a4 <copyinstr3+0xf0>
}
    2032:	70a2                	ld	ra,40(sp)
    2034:	7402                	ld	s0,32(sp)
    2036:	64e2                	ld	s1,24(sp)
    2038:	6145                	addi	sp,sp,48
    203a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    203c:	6785                	lui	a5,0x1
    203e:	fff78713          	addi	a4,a5,-1 # fff <bigdir+0x109>
    2042:	8d79                	and	a0,a0,a4
    2044:	40a7853b          	subw	a0,a5,a0
    2048:	545020ef          	jal	4d8c <sbrk>
    204c:	b751                	j	1fd0 <copyinstr3+0x1c>
    printf("oops\n");
    204e:	00004517          	auipc	a0,0x4
    2052:	e9250513          	addi	a0,a0,-366 # 5ee0 <malloc+0xd22>
    2056:	0b0030ef          	jal	5106 <printf>
    exit(1);
    205a:	4505                	li	a0,1
    205c:	4a9020ef          	jal	4d04 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2060:	862a                	mv	a2,a0
    2062:	85a6                	mv	a1,s1
    2064:	00004517          	auipc	a0,0x4
    2068:	a3450513          	addi	a0,a0,-1484 # 5a98 <malloc+0x8da>
    206c:	09a030ef          	jal	5106 <printf>
    exit(1);
    2070:	4505                	li	a0,1
    2072:	493020ef          	jal	4d04 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2076:	862a                	mv	a2,a0
    2078:	85a6                	mv	a1,s1
    207a:	00004517          	auipc	a0,0x4
    207e:	a3e50513          	addi	a0,a0,-1474 # 5ab8 <malloc+0x8fa>
    2082:	084030ef          	jal	5106 <printf>
    exit(1);
    2086:	4505                	li	a0,1
    2088:	47d020ef          	jal	4d04 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    208c:	86aa                	mv	a3,a0
    208e:	8626                	mv	a2,s1
    2090:	85a6                	mv	a1,s1
    2092:	00004517          	auipc	a0,0x4
    2096:	a4650513          	addi	a0,a0,-1466 # 5ad8 <malloc+0x91a>
    209a:	06c030ef          	jal	5106 <printf>
    exit(1);
    209e:	4505                	li	a0,1
    20a0:	465020ef          	jal	4d04 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    20a4:	863e                	mv	a2,a5
    20a6:	85a6                	mv	a1,s1
    20a8:	00004517          	auipc	a0,0x4
    20ac:	a5850513          	addi	a0,a0,-1448 # 5b00 <malloc+0x942>
    20b0:	056030ef          	jal	5106 <printf>
    exit(1);
    20b4:	4505                	li	a0,1
    20b6:	44f020ef          	jal	4d04 <exit>

00000000000020ba <rwsbrk>:
{
    20ba:	1101                	addi	sp,sp,-32
    20bc:	ec06                	sd	ra,24(sp)
    20be:	e822                	sd	s0,16(sp)
    20c0:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    20c2:	6509                	lui	a0,0x2
    20c4:	4c9020ef          	jal	4d8c <sbrk>
  if(a == 0xffffffffffffffffLL) {
    20c8:	57fd                	li	a5,-1
    20ca:	04f50a63          	beq	a0,a5,211e <rwsbrk+0x64>
    20ce:	e426                	sd	s1,8(sp)
    20d0:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    20d2:	7579                	lui	a0,0xffffe
    20d4:	4b9020ef          	jal	4d8c <sbrk>
    20d8:	57fd                	li	a5,-1
    20da:	04f50d63          	beq	a0,a5,2134 <rwsbrk+0x7a>
    20de:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    20e0:	20100593          	li	a1,513
    20e4:	00004517          	auipc	a0,0x4
    20e8:	e3c50513          	addi	a0,a0,-452 # 5f20 <malloc+0xd62>
    20ec:	459020ef          	jal	4d44 <open>
    20f0:	892a                	mv	s2,a0
  if(fd < 0){
    20f2:	04054b63          	bltz	a0,2148 <rwsbrk+0x8e>
  n = write(fd, (void*)(a+4096), 1024);
    20f6:	6785                	lui	a5,0x1
    20f8:	94be                	add	s1,s1,a5
    20fa:	40000613          	li	a2,1024
    20fe:	85a6                	mv	a1,s1
    2100:	425020ef          	jal	4d24 <write>
    2104:	862a                	mv	a2,a0
  if(n >= 0){
    2106:	04054a63          	bltz	a0,215a <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    210a:	85a6                	mv	a1,s1
    210c:	00004517          	auipc	a0,0x4
    2110:	e3450513          	addi	a0,a0,-460 # 5f40 <malloc+0xd82>
    2114:	7f3020ef          	jal	5106 <printf>
    exit(1);
    2118:	4505                	li	a0,1
    211a:	3eb020ef          	jal	4d04 <exit>
    211e:	e426                	sd	s1,8(sp)
    2120:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2122:	00004517          	auipc	a0,0x4
    2126:	dc650513          	addi	a0,a0,-570 # 5ee8 <malloc+0xd2a>
    212a:	7dd020ef          	jal	5106 <printf>
    exit(1);
    212e:	4505                	li	a0,1
    2130:	3d5020ef          	jal	4d04 <exit>
    2134:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2136:	00004517          	auipc	a0,0x4
    213a:	dca50513          	addi	a0,a0,-566 # 5f00 <malloc+0xd42>
    213e:	7c9020ef          	jal	5106 <printf>
    exit(1);
    2142:	4505                	li	a0,1
    2144:	3c1020ef          	jal	4d04 <exit>
    printf("open(rwsbrk) failed\n");
    2148:	00004517          	auipc	a0,0x4
    214c:	de050513          	addi	a0,a0,-544 # 5f28 <malloc+0xd6a>
    2150:	7b7020ef          	jal	5106 <printf>
    exit(1);
    2154:	4505                	li	a0,1
    2156:	3af020ef          	jal	4d04 <exit>
  close(fd);
    215a:	854a                	mv	a0,s2
    215c:	3d1020ef          	jal	4d2c <close>
  unlink("rwsbrk");
    2160:	00004517          	auipc	a0,0x4
    2164:	dc050513          	addi	a0,a0,-576 # 5f20 <malloc+0xd62>
    2168:	3ed020ef          	jal	4d54 <unlink>
  fd = open("README", O_RDONLY);
    216c:	4581                	li	a1,0
    216e:	00003517          	auipc	a0,0x3
    2172:	35250513          	addi	a0,a0,850 # 54c0 <malloc+0x302>
    2176:	3cf020ef          	jal	4d44 <open>
    217a:	892a                	mv	s2,a0
  if(fd < 0){
    217c:	02054363          	bltz	a0,21a2 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+4096), 10);
    2180:	4629                	li	a2,10
    2182:	85a6                	mv	a1,s1
    2184:	399020ef          	jal	4d1c <read>
    2188:	862a                	mv	a2,a0
  if(n >= 0){
    218a:	02054563          	bltz	a0,21b4 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    218e:	85a6                	mv	a1,s1
    2190:	00004517          	auipc	a0,0x4
    2194:	de050513          	addi	a0,a0,-544 # 5f70 <malloc+0xdb2>
    2198:	76f020ef          	jal	5106 <printf>
    exit(1);
    219c:	4505                	li	a0,1
    219e:	367020ef          	jal	4d04 <exit>
    printf("open(rwsbrk) failed\n");
    21a2:	00004517          	auipc	a0,0x4
    21a6:	d8650513          	addi	a0,a0,-634 # 5f28 <malloc+0xd6a>
    21aa:	75d020ef          	jal	5106 <printf>
    exit(1);
    21ae:	4505                	li	a0,1
    21b0:	355020ef          	jal	4d04 <exit>
  close(fd);
    21b4:	854a                	mv	a0,s2
    21b6:	377020ef          	jal	4d2c <close>
  exit(0);
    21ba:	4501                	li	a0,0
    21bc:	349020ef          	jal	4d04 <exit>

00000000000021c0 <sbrkbasic>:
{
    21c0:	715d                	addi	sp,sp,-80
    21c2:	e486                	sd	ra,72(sp)
    21c4:	e0a2                	sd	s0,64(sp)
    21c6:	ec56                	sd	s5,24(sp)
    21c8:	0880                	addi	s0,sp,80
    21ca:	8aaa                	mv	s5,a0
  pid = fork();
    21cc:	331020ef          	jal	4cfc <fork>
  if(pid < 0){
    21d0:	02054c63          	bltz	a0,2208 <sbrkbasic+0x48>
  if(pid == 0){
    21d4:	ed31                	bnez	a0,2230 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    21d6:	40000537          	lui	a0,0x40000
    21da:	3b3020ef          	jal	4d8c <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    21de:	57fd                	li	a5,-1
    21e0:	04f50163          	beq	a0,a5,2222 <sbrkbasic+0x62>
    21e4:	fc26                	sd	s1,56(sp)
    21e6:	f84a                	sd	s2,48(sp)
    21e8:	f44e                	sd	s3,40(sp)
    21ea:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    21ec:	400007b7          	lui	a5,0x40000
    21f0:	97aa                	add	a5,a5,a0
      *b = 99;
    21f2:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    21f6:	6705                	lui	a4,0x1
      *b = 99;
    21f8:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    21fc:	953a                	add	a0,a0,a4
    21fe:	fef51de3          	bne	a0,a5,21f8 <sbrkbasic+0x38>
    exit(1);
    2202:	4505                	li	a0,1
    2204:	301020ef          	jal	4d04 <exit>
    2208:	fc26                	sd	s1,56(sp)
    220a:	f84a                	sd	s2,48(sp)
    220c:	f44e                	sd	s3,40(sp)
    220e:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2210:	00004517          	auipc	a0,0x4
    2214:	d8850513          	addi	a0,a0,-632 # 5f98 <malloc+0xdda>
    2218:	6ef020ef          	jal	5106 <printf>
    exit(1);
    221c:	4505                	li	a0,1
    221e:	2e7020ef          	jal	4d04 <exit>
    2222:	fc26                	sd	s1,56(sp)
    2224:	f84a                	sd	s2,48(sp)
    2226:	f44e                	sd	s3,40(sp)
    2228:	f052                	sd	s4,32(sp)
      exit(0);
    222a:	4501                	li	a0,0
    222c:	2d9020ef          	jal	4d04 <exit>
  wait(&xstatus);
    2230:	fbc40513          	addi	a0,s0,-68
    2234:	2d9020ef          	jal	4d0c <wait>
  if(xstatus == 1){
    2238:	fbc42703          	lw	a4,-68(s0)
    223c:	4785                	li	a5,1
    223e:	02f70063          	beq	a4,a5,225e <sbrkbasic+0x9e>
    2242:	fc26                	sd	s1,56(sp)
    2244:	f84a                	sd	s2,48(sp)
    2246:	f44e                	sd	s3,40(sp)
    2248:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    224a:	4501                	li	a0,0
    224c:	341020ef          	jal	4d8c <sbrk>
    2250:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2252:	4901                	li	s2,0
    b = sbrk(1);
    2254:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    2256:	6a05                	lui	s4,0x1
    2258:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x148>
    225c:	a005                	j	227c <sbrkbasic+0xbc>
    225e:	fc26                	sd	s1,56(sp)
    2260:	f84a                	sd	s2,48(sp)
    2262:	f44e                	sd	s3,40(sp)
    2264:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2266:	85d6                	mv	a1,s5
    2268:	00004517          	auipc	a0,0x4
    226c:	d5050513          	addi	a0,a0,-688 # 5fb8 <malloc+0xdfa>
    2270:	697020ef          	jal	5106 <printf>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	28f020ef          	jal	4d04 <exit>
    227a:	84be                	mv	s1,a5
    b = sbrk(1);
    227c:	854e                	mv	a0,s3
    227e:	30f020ef          	jal	4d8c <sbrk>
    if(b != a){
    2282:	04951163          	bne	a0,s1,22c4 <sbrkbasic+0x104>
    *b = 1;
    2286:	01348023          	sb	s3,0(s1)
    a = b + 1;
    228a:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    228e:	2905                	addiw	s2,s2,1
    2290:	ff4915e3          	bne	s2,s4,227a <sbrkbasic+0xba>
  pid = fork();
    2294:	269020ef          	jal	4cfc <fork>
    2298:	892a                	mv	s2,a0
  if(pid < 0){
    229a:	04054263          	bltz	a0,22de <sbrkbasic+0x11e>
  c = sbrk(1);
    229e:	4505                	li	a0,1
    22a0:	2ed020ef          	jal	4d8c <sbrk>
  c = sbrk(1);
    22a4:	4505                	li	a0,1
    22a6:	2e7020ef          	jal	4d8c <sbrk>
  if(c != a + 1){
    22aa:	0489                	addi	s1,s1,2
    22ac:	04a48363          	beq	s1,a0,22f2 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    22b0:	85d6                	mv	a1,s5
    22b2:	00004517          	auipc	a0,0x4
    22b6:	d6650513          	addi	a0,a0,-666 # 6018 <malloc+0xe5a>
    22ba:	64d020ef          	jal	5106 <printf>
    exit(1);
    22be:	4505                	li	a0,1
    22c0:	245020ef          	jal	4d04 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    22c4:	872a                	mv	a4,a0
    22c6:	86a6                	mv	a3,s1
    22c8:	864a                	mv	a2,s2
    22ca:	85d6                	mv	a1,s5
    22cc:	00004517          	auipc	a0,0x4
    22d0:	d0c50513          	addi	a0,a0,-756 # 5fd8 <malloc+0xe1a>
    22d4:	633020ef          	jal	5106 <printf>
      exit(1);
    22d8:	4505                	li	a0,1
    22da:	22b020ef          	jal	4d04 <exit>
    printf("%s: sbrk test fork failed\n", s);
    22de:	85d6                	mv	a1,s5
    22e0:	00004517          	auipc	a0,0x4
    22e4:	d1850513          	addi	a0,a0,-744 # 5ff8 <malloc+0xe3a>
    22e8:	61f020ef          	jal	5106 <printf>
    exit(1);
    22ec:	4505                	li	a0,1
    22ee:	217020ef          	jal	4d04 <exit>
  if(pid == 0)
    22f2:	00091563          	bnez	s2,22fc <sbrkbasic+0x13c>
    exit(0);
    22f6:	4501                	li	a0,0
    22f8:	20d020ef          	jal	4d04 <exit>
  wait(&xstatus);
    22fc:	fbc40513          	addi	a0,s0,-68
    2300:	20d020ef          	jal	4d0c <wait>
  exit(xstatus);
    2304:	fbc42503          	lw	a0,-68(s0)
    2308:	1fd020ef          	jal	4d04 <exit>

000000000000230c <sbrkmuch>:
{
    230c:	7179                	addi	sp,sp,-48
    230e:	f406                	sd	ra,40(sp)
    2310:	f022                	sd	s0,32(sp)
    2312:	ec26                	sd	s1,24(sp)
    2314:	e84a                	sd	s2,16(sp)
    2316:	e44e                	sd	s3,8(sp)
    2318:	e052                	sd	s4,0(sp)
    231a:	1800                	addi	s0,sp,48
    231c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    231e:	4501                	li	a0,0
    2320:	26d020ef          	jal	4d8c <sbrk>
    2324:	892a                	mv	s2,a0
  a = sbrk(0);
    2326:	4501                	li	a0,0
    2328:	265020ef          	jal	4d8c <sbrk>
    232c:	84aa                	mv	s1,a0
  p = sbrk(amt);
    232e:	06400537          	lui	a0,0x6400
    2332:	9d05                	subw	a0,a0,s1
    2334:	259020ef          	jal	4d8c <sbrk>
  if (p != a) {
    2338:	0aa49463          	bne	s1,a0,23e0 <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    233c:	4501                	li	a0,0
    233e:	24f020ef          	jal	4d8c <sbrk>
    2342:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2344:	00a4f963          	bgeu	s1,a0,2356 <sbrkmuch+0x4a>
    *pp = 1;
    2348:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    234a:	6705                	lui	a4,0x1
    *pp = 1;
    234c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2350:	94ba                	add	s1,s1,a4
    2352:	fef4ede3          	bltu	s1,a5,234c <sbrkmuch+0x40>
  *lastaddr = 99;
    2356:	064007b7          	lui	a5,0x6400
    235a:	06300713          	li	a4,99
    235e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1387>
  a = sbrk(0);
    2362:	4501                	li	a0,0
    2364:	229020ef          	jal	4d8c <sbrk>
    2368:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    236a:	757d                	lui	a0,0xfffff
    236c:	221020ef          	jal	4d8c <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2370:	57fd                	li	a5,-1
    2372:	08f50163          	beq	a0,a5,23f4 <sbrkmuch+0xe8>
  c = sbrk(0);
    2376:	4501                	li	a0,0
    2378:	215020ef          	jal	4d8c <sbrk>
  if(c != a - PGSIZE){
    237c:	77fd                	lui	a5,0xfffff
    237e:	97a6                	add	a5,a5,s1
    2380:	08f51463          	bne	a0,a5,2408 <sbrkmuch+0xfc>
  a = sbrk(0);
    2384:	4501                	li	a0,0
    2386:	207020ef          	jal	4d8c <sbrk>
    238a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    238c:	6505                	lui	a0,0x1
    238e:	1ff020ef          	jal	4d8c <sbrk>
    2392:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2394:	08a49663          	bne	s1,a0,2420 <sbrkmuch+0x114>
    2398:	4501                	li	a0,0
    239a:	1f3020ef          	jal	4d8c <sbrk>
    239e:	6785                	lui	a5,0x1
    23a0:	97a6                	add	a5,a5,s1
    23a2:	06f51f63          	bne	a0,a5,2420 <sbrkmuch+0x114>
  if(*lastaddr == 99){
    23a6:	064007b7          	lui	a5,0x6400
    23aa:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1387>
    23ae:	06300793          	li	a5,99
    23b2:	08f70363          	beq	a4,a5,2438 <sbrkmuch+0x12c>
  a = sbrk(0);
    23b6:	4501                	li	a0,0
    23b8:	1d5020ef          	jal	4d8c <sbrk>
    23bc:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    23be:	4501                	li	a0,0
    23c0:	1cd020ef          	jal	4d8c <sbrk>
    23c4:	40a9053b          	subw	a0,s2,a0
    23c8:	1c5020ef          	jal	4d8c <sbrk>
  if(c != a){
    23cc:	08a49063          	bne	s1,a0,244c <sbrkmuch+0x140>
}
    23d0:	70a2                	ld	ra,40(sp)
    23d2:	7402                	ld	s0,32(sp)
    23d4:	64e2                	ld	s1,24(sp)
    23d6:	6942                	ld	s2,16(sp)
    23d8:	69a2                	ld	s3,8(sp)
    23da:	6a02                	ld	s4,0(sp)
    23dc:	6145                	addi	sp,sp,48
    23de:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    23e0:	85ce                	mv	a1,s3
    23e2:	00004517          	auipc	a0,0x4
    23e6:	c5650513          	addi	a0,a0,-938 # 6038 <malloc+0xe7a>
    23ea:	51d020ef          	jal	5106 <printf>
    exit(1);
    23ee:	4505                	li	a0,1
    23f0:	115020ef          	jal	4d04 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    23f4:	85ce                	mv	a1,s3
    23f6:	00004517          	auipc	a0,0x4
    23fa:	c8a50513          	addi	a0,a0,-886 # 6080 <malloc+0xec2>
    23fe:	509020ef          	jal	5106 <printf>
    exit(1);
    2402:	4505                	li	a0,1
    2404:	101020ef          	jal	4d04 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2408:	86aa                	mv	a3,a0
    240a:	8626                	mv	a2,s1
    240c:	85ce                	mv	a1,s3
    240e:	00004517          	auipc	a0,0x4
    2412:	c9250513          	addi	a0,a0,-878 # 60a0 <malloc+0xee2>
    2416:	4f1020ef          	jal	5106 <printf>
    exit(1);
    241a:	4505                	li	a0,1
    241c:	0e9020ef          	jal	4d04 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2420:	86d2                	mv	a3,s4
    2422:	8626                	mv	a2,s1
    2424:	85ce                	mv	a1,s3
    2426:	00004517          	auipc	a0,0x4
    242a:	cba50513          	addi	a0,a0,-838 # 60e0 <malloc+0xf22>
    242e:	4d9020ef          	jal	5106 <printf>
    exit(1);
    2432:	4505                	li	a0,1
    2434:	0d1020ef          	jal	4d04 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2438:	85ce                	mv	a1,s3
    243a:	00004517          	auipc	a0,0x4
    243e:	cd650513          	addi	a0,a0,-810 # 6110 <malloc+0xf52>
    2442:	4c5020ef          	jal	5106 <printf>
    exit(1);
    2446:	4505                	li	a0,1
    2448:	0bd020ef          	jal	4d04 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    244c:	86aa                	mv	a3,a0
    244e:	8626                	mv	a2,s1
    2450:	85ce                	mv	a1,s3
    2452:	00004517          	auipc	a0,0x4
    2456:	cf650513          	addi	a0,a0,-778 # 6148 <malloc+0xf8a>
    245a:	4ad020ef          	jal	5106 <printf>
    exit(1);
    245e:	4505                	li	a0,1
    2460:	0a5020ef          	jal	4d04 <exit>

0000000000002464 <sbrkarg>:
{
    2464:	7179                	addi	sp,sp,-48
    2466:	f406                	sd	ra,40(sp)
    2468:	f022                	sd	s0,32(sp)
    246a:	ec26                	sd	s1,24(sp)
    246c:	e84a                	sd	s2,16(sp)
    246e:	e44e                	sd	s3,8(sp)
    2470:	1800                	addi	s0,sp,48
    2472:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2474:	6505                	lui	a0,0x1
    2476:	117020ef          	jal	4d8c <sbrk>
    247a:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    247c:	20100593          	li	a1,513
    2480:	00004517          	auipc	a0,0x4
    2484:	cf050513          	addi	a0,a0,-784 # 6170 <malloc+0xfb2>
    2488:	0bd020ef          	jal	4d44 <open>
    248c:	84aa                	mv	s1,a0
  unlink("sbrk");
    248e:	00004517          	auipc	a0,0x4
    2492:	ce250513          	addi	a0,a0,-798 # 6170 <malloc+0xfb2>
    2496:	0bf020ef          	jal	4d54 <unlink>
  if(fd < 0)  {
    249a:	0204c963          	bltz	s1,24cc <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    249e:	6605                	lui	a2,0x1
    24a0:	85ca                	mv	a1,s2
    24a2:	8526                	mv	a0,s1
    24a4:	081020ef          	jal	4d24 <write>
    24a8:	02054c63          	bltz	a0,24e0 <sbrkarg+0x7c>
  close(fd);
    24ac:	8526                	mv	a0,s1
    24ae:	07f020ef          	jal	4d2c <close>
  a = sbrk(PGSIZE);
    24b2:	6505                	lui	a0,0x1
    24b4:	0d9020ef          	jal	4d8c <sbrk>
  if(pipe((int *) a) != 0){
    24b8:	05d020ef          	jal	4d14 <pipe>
    24bc:	ed05                	bnez	a0,24f4 <sbrkarg+0x90>
}
    24be:	70a2                	ld	ra,40(sp)
    24c0:	7402                	ld	s0,32(sp)
    24c2:	64e2                	ld	s1,24(sp)
    24c4:	6942                	ld	s2,16(sp)
    24c6:	69a2                	ld	s3,8(sp)
    24c8:	6145                	addi	sp,sp,48
    24ca:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    24cc:	85ce                	mv	a1,s3
    24ce:	00004517          	auipc	a0,0x4
    24d2:	caa50513          	addi	a0,a0,-854 # 6178 <malloc+0xfba>
    24d6:	431020ef          	jal	5106 <printf>
    exit(1);
    24da:	4505                	li	a0,1
    24dc:	029020ef          	jal	4d04 <exit>
    printf("%s: write sbrk failed\n", s);
    24e0:	85ce                	mv	a1,s3
    24e2:	00004517          	auipc	a0,0x4
    24e6:	cae50513          	addi	a0,a0,-850 # 6190 <malloc+0xfd2>
    24ea:	41d020ef          	jal	5106 <printf>
    exit(1);
    24ee:	4505                	li	a0,1
    24f0:	015020ef          	jal	4d04 <exit>
    printf("%s: pipe() failed\n", s);
    24f4:	85ce                	mv	a1,s3
    24f6:	00003517          	auipc	a0,0x3
    24fa:	78a50513          	addi	a0,a0,1930 # 5c80 <malloc+0xac2>
    24fe:	409020ef          	jal	5106 <printf>
    exit(1);
    2502:	4505                	li	a0,1
    2504:	001020ef          	jal	4d04 <exit>

0000000000002508 <argptest>:
{
    2508:	1101                	addi	sp,sp,-32
    250a:	ec06                	sd	ra,24(sp)
    250c:	e822                	sd	s0,16(sp)
    250e:	e426                	sd	s1,8(sp)
    2510:	e04a                	sd	s2,0(sp)
    2512:	1000                	addi	s0,sp,32
    2514:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2516:	4581                	li	a1,0
    2518:	00004517          	auipc	a0,0x4
    251c:	c9050513          	addi	a0,a0,-880 # 61a8 <malloc+0xfea>
    2520:	025020ef          	jal	4d44 <open>
  if (fd < 0) {
    2524:	02054563          	bltz	a0,254e <argptest+0x46>
    2528:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    252a:	4501                	li	a0,0
    252c:	061020ef          	jal	4d8c <sbrk>
    2530:	567d                	li	a2,-1
    2532:	00c505b3          	add	a1,a0,a2
    2536:	8526                	mv	a0,s1
    2538:	7e4020ef          	jal	4d1c <read>
  close(fd);
    253c:	8526                	mv	a0,s1
    253e:	7ee020ef          	jal	4d2c <close>
}
    2542:	60e2                	ld	ra,24(sp)
    2544:	6442                	ld	s0,16(sp)
    2546:	64a2                	ld	s1,8(sp)
    2548:	6902                	ld	s2,0(sp)
    254a:	6105                	addi	sp,sp,32
    254c:	8082                	ret
    printf("%s: open failed\n", s);
    254e:	85ca                	mv	a1,s2
    2550:	00003517          	auipc	a0,0x3
    2554:	64050513          	addi	a0,a0,1600 # 5b90 <malloc+0x9d2>
    2558:	3af020ef          	jal	5106 <printf>
    exit(1);
    255c:	4505                	li	a0,1
    255e:	7a6020ef          	jal	4d04 <exit>

0000000000002562 <sbrkbugs>:
{
    2562:	1141                	addi	sp,sp,-16
    2564:	e406                	sd	ra,8(sp)
    2566:	e022                	sd	s0,0(sp)
    2568:	0800                	addi	s0,sp,16
  int pid = fork();
    256a:	792020ef          	jal	4cfc <fork>
  if(pid < 0){
    256e:	00054c63          	bltz	a0,2586 <sbrkbugs+0x24>
  if(pid == 0){
    2572:	e11d                	bnez	a0,2598 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2574:	019020ef          	jal	4d8c <sbrk>
    sbrk(-sz);
    2578:	40a0053b          	negw	a0,a0
    257c:	011020ef          	jal	4d8c <sbrk>
    exit(0);
    2580:	4501                	li	a0,0
    2582:	782020ef          	jal	4d04 <exit>
    printf("fork failed\n");
    2586:	00005517          	auipc	a0,0x5
    258a:	b6250513          	addi	a0,a0,-1182 # 70e8 <malloc+0x1f2a>
    258e:	379020ef          	jal	5106 <printf>
    exit(1);
    2592:	4505                	li	a0,1
    2594:	770020ef          	jal	4d04 <exit>
  wait(0);
    2598:	4501                	li	a0,0
    259a:	772020ef          	jal	4d0c <wait>
  pid = fork();
    259e:	75e020ef          	jal	4cfc <fork>
  if(pid < 0){
    25a2:	00054f63          	bltz	a0,25c0 <sbrkbugs+0x5e>
  if(pid == 0){
    25a6:	e515                	bnez	a0,25d2 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    25a8:	7e4020ef          	jal	4d8c <sbrk>
    sbrk(-(sz - 3500));
    25ac:	6785                	lui	a5,0x1
    25ae:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe0>
    25b2:	40a7853b          	subw	a0,a5,a0
    25b6:	7d6020ef          	jal	4d8c <sbrk>
    exit(0);
    25ba:	4501                	li	a0,0
    25bc:	748020ef          	jal	4d04 <exit>
    printf("fork failed\n");
    25c0:	00005517          	auipc	a0,0x5
    25c4:	b2850513          	addi	a0,a0,-1240 # 70e8 <malloc+0x1f2a>
    25c8:	33f020ef          	jal	5106 <printf>
    exit(1);
    25cc:	4505                	li	a0,1
    25ce:	736020ef          	jal	4d04 <exit>
  wait(0);
    25d2:	4501                	li	a0,0
    25d4:	738020ef          	jal	4d0c <wait>
  pid = fork();
    25d8:	724020ef          	jal	4cfc <fork>
  if(pid < 0){
    25dc:	02054263          	bltz	a0,2600 <sbrkbugs+0x9e>
  if(pid == 0){
    25e0:	e90d                	bnez	a0,2612 <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    25e2:	7aa020ef          	jal	4d8c <sbrk>
    25e6:	67ad                	lui	a5,0xb
    25e8:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1298>
    25ec:	40a7853b          	subw	a0,a5,a0
    25f0:	79c020ef          	jal	4d8c <sbrk>
    sbrk(-10);
    25f4:	5559                	li	a0,-10
    25f6:	796020ef          	jal	4d8c <sbrk>
    exit(0);
    25fa:	4501                	li	a0,0
    25fc:	708020ef          	jal	4d04 <exit>
    printf("fork failed\n");
    2600:	00005517          	auipc	a0,0x5
    2604:	ae850513          	addi	a0,a0,-1304 # 70e8 <malloc+0x1f2a>
    2608:	2ff020ef          	jal	5106 <printf>
    exit(1);
    260c:	4505                	li	a0,1
    260e:	6f6020ef          	jal	4d04 <exit>
  wait(0);
    2612:	4501                	li	a0,0
    2614:	6f8020ef          	jal	4d0c <wait>
  exit(0);
    2618:	4501                	li	a0,0
    261a:	6ea020ef          	jal	4d04 <exit>

000000000000261e <sbrklast>:
{
    261e:	7179                	addi	sp,sp,-48
    2620:	f406                	sd	ra,40(sp)
    2622:	f022                	sd	s0,32(sp)
    2624:	ec26                	sd	s1,24(sp)
    2626:	e84a                	sd	s2,16(sp)
    2628:	e44e                	sd	s3,8(sp)
    262a:	e052                	sd	s4,0(sp)
    262c:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    262e:	4501                	li	a0,0
    2630:	75c020ef          	jal	4d8c <sbrk>
  if((top % 4096) != 0)
    2634:	03451793          	slli	a5,a0,0x34
    2638:	ebad                	bnez	a5,26aa <sbrklast+0x8c>
  sbrk(4096);
    263a:	6505                	lui	a0,0x1
    263c:	750020ef          	jal	4d8c <sbrk>
  sbrk(10);
    2640:	4529                	li	a0,10
    2642:	74a020ef          	jal	4d8c <sbrk>
  sbrk(-20);
    2646:	5531                	li	a0,-20
    2648:	744020ef          	jal	4d8c <sbrk>
  top = (uint64) sbrk(0);
    264c:	4501                	li	a0,0
    264e:	73e020ef          	jal	4d8c <sbrk>
    2652:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2654:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xca>
  p[0] = 'x';
    2658:	07800a13          	li	s4,120
    265c:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2660:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2664:	20200593          	li	a1,514
    2668:	854a                	mv	a0,s2
    266a:	6da020ef          	jal	4d44 <open>
    266e:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2670:	4605                	li	a2,1
    2672:	85ca                	mv	a1,s2
    2674:	6b0020ef          	jal	4d24 <write>
  close(fd);
    2678:	854e                	mv	a0,s3
    267a:	6b2020ef          	jal	4d2c <close>
  fd = open(p, O_RDWR);
    267e:	4589                	li	a1,2
    2680:	854a                	mv	a0,s2
    2682:	6c2020ef          	jal	4d44 <open>
  p[0] = '\0';
    2686:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    268a:	4605                	li	a2,1
    268c:	85ca                	mv	a1,s2
    268e:	68e020ef          	jal	4d1c <read>
  if(p[0] != 'x')
    2692:	fc04c783          	lbu	a5,-64(s1)
    2696:	03479363          	bne	a5,s4,26bc <sbrklast+0x9e>
}
    269a:	70a2                	ld	ra,40(sp)
    269c:	7402                	ld	s0,32(sp)
    269e:	64e2                	ld	s1,24(sp)
    26a0:	6942                	ld	s2,16(sp)
    26a2:	69a2                	ld	s3,8(sp)
    26a4:	6a02                	ld	s4,0(sp)
    26a6:	6145                	addi	sp,sp,48
    26a8:	8082                	ret
    sbrk(4096 - (top % 4096));
    26aa:	6785                	lui	a5,0x1
    26ac:	fff78713          	addi	a4,a5,-1 # fff <bigdir+0x109>
    26b0:	8d79                	and	a0,a0,a4
    26b2:	40a7853b          	subw	a0,a5,a0
    26b6:	6d6020ef          	jal	4d8c <sbrk>
    26ba:	b741                	j	263a <sbrklast+0x1c>
    exit(1);
    26bc:	4505                	li	a0,1
    26be:	646020ef          	jal	4d04 <exit>

00000000000026c2 <sbrk8000>:
{
    26c2:	1141                	addi	sp,sp,-16
    26c4:	e406                	sd	ra,8(sp)
    26c6:	e022                	sd	s0,0(sp)
    26c8:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    26ca:	80000537          	lui	a0,0x80000
    26ce:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff138c>
    26d0:	6bc020ef          	jal	4d8c <sbrk>
  volatile char *top = sbrk(0);
    26d4:	4501                	li	a0,0
    26d6:	6b6020ef          	jal	4d8c <sbrk>
  *(top-1) = *(top-1) + 1;
    26da:	fff54783          	lbu	a5,-1(a0)
    26de:	0785                	addi	a5,a5,1
    26e0:	0ff7f793          	zext.b	a5,a5
    26e4:	fef50fa3          	sb	a5,-1(a0)
}
    26e8:	60a2                	ld	ra,8(sp)
    26ea:	6402                	ld	s0,0(sp)
    26ec:	0141                	addi	sp,sp,16
    26ee:	8082                	ret

00000000000026f0 <execout>:
{
    26f0:	711d                	addi	sp,sp,-96
    26f2:	ec86                	sd	ra,88(sp)
    26f4:	e8a2                	sd	s0,80(sp)
    26f6:	e4a6                	sd	s1,72(sp)
    26f8:	e0ca                	sd	s2,64(sp)
    26fa:	fc4e                	sd	s3,56(sp)
    26fc:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    26fe:	4901                	li	s2,0
    2700:	49bd                	li	s3,15
    int pid = fork();
    2702:	5fa020ef          	jal	4cfc <fork>
    2706:	84aa                	mv	s1,a0
    if(pid < 0){
    2708:	00054e63          	bltz	a0,2724 <execout+0x34>
    } else if(pid == 0){
    270c:	c51d                	beqz	a0,273a <execout+0x4a>
      wait((int*)0);
    270e:	4501                	li	a0,0
    2710:	5fc020ef          	jal	4d0c <wait>
  for(int avail = 0; avail < 15; avail++){
    2714:	2905                	addiw	s2,s2,1
    2716:	ff3916e3          	bne	s2,s3,2702 <execout+0x12>
    271a:	f852                	sd	s4,48(sp)
    271c:	f456                	sd	s5,40(sp)
  exit(0);
    271e:	4501                	li	a0,0
    2720:	5e4020ef          	jal	4d04 <exit>
    2724:	f852                	sd	s4,48(sp)
    2726:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    2728:	00005517          	auipc	a0,0x5
    272c:	9c050513          	addi	a0,a0,-1600 # 70e8 <malloc+0x1f2a>
    2730:	1d7020ef          	jal	5106 <printf>
      exit(1);
    2734:	4505                	li	a0,1
    2736:	5ce020ef          	jal	4d04 <exit>
    273a:	f852                	sd	s4,48(sp)
    273c:	f456                	sd	s5,40(sp)
        uint64 a = (uint64) sbrk(4096);
    273e:	6985                	lui	s3,0x1
        if(a == 0xffffffffffffffffLL)
    2740:	5a7d                	li	s4,-1
        *(char*)(a + 4096 - 1) = 1;
    2742:	4a85                	li	s5,1
        uint64 a = (uint64) sbrk(4096);
    2744:	854e                	mv	a0,s3
    2746:	646020ef          	jal	4d8c <sbrk>
        if(a == 0xffffffffffffffffLL)
    274a:	01450663          	beq	a0,s4,2756 <execout+0x66>
        *(char*)(a + 4096 - 1) = 1;
    274e:	954e                	add	a0,a0,s3
    2750:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    2754:	bfc5                	j	2744 <execout+0x54>
        sbrk(-4096);
    2756:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    2758:	01205863          	blez	s2,2768 <execout+0x78>
        sbrk(-4096);
    275c:	854e                	mv	a0,s3
    275e:	62e020ef          	jal	4d8c <sbrk>
      for(int i = 0; i < avail; i++)
    2762:	2485                	addiw	s1,s1,1
    2764:	ff249ce3          	bne	s1,s2,275c <execout+0x6c>
      close(1);
    2768:	4505                	li	a0,1
    276a:	5c2020ef          	jal	4d2c <close>
      char *args[] = { "echo", "x", 0 };
    276e:	00003517          	auipc	a0,0x3
    2772:	b7a50513          	addi	a0,a0,-1158 # 52e8 <malloc+0x12a>
    2776:	faa43423          	sd	a0,-88(s0)
    277a:	00003797          	auipc	a5,0x3
    277e:	bde78793          	addi	a5,a5,-1058 # 5358 <malloc+0x19a>
    2782:	faf43823          	sd	a5,-80(s0)
    2786:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    278a:	fa840593          	addi	a1,s0,-88
    278e:	5ae020ef          	jal	4d3c <exec>
      exit(0);
    2792:	4501                	li	a0,0
    2794:	570020ef          	jal	4d04 <exit>

0000000000002798 <fourteen>:
{
    2798:	1101                	addi	sp,sp,-32
    279a:	ec06                	sd	ra,24(sp)
    279c:	e822                	sd	s0,16(sp)
    279e:	e426                	sd	s1,8(sp)
    27a0:	1000                	addi	s0,sp,32
    27a2:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    27a4:	00004517          	auipc	a0,0x4
    27a8:	bdc50513          	addi	a0,a0,-1060 # 6380 <malloc+0x11c2>
    27ac:	5c0020ef          	jal	4d6c <mkdir>
    27b0:	e555                	bnez	a0,285c <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    27b2:	00004517          	auipc	a0,0x4
    27b6:	a2650513          	addi	a0,a0,-1498 # 61d8 <malloc+0x101a>
    27ba:	5b2020ef          	jal	4d6c <mkdir>
    27be:	e94d                	bnez	a0,2870 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27c0:	20000593          	li	a1,512
    27c4:	00004517          	auipc	a0,0x4
    27c8:	a6c50513          	addi	a0,a0,-1428 # 6230 <malloc+0x1072>
    27cc:	578020ef          	jal	4d44 <open>
  if(fd < 0){
    27d0:	0a054a63          	bltz	a0,2884 <fourteen+0xec>
  close(fd);
    27d4:	558020ef          	jal	4d2c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27d8:	4581                	li	a1,0
    27da:	00004517          	auipc	a0,0x4
    27de:	ace50513          	addi	a0,a0,-1330 # 62a8 <malloc+0x10ea>
    27e2:	562020ef          	jal	4d44 <open>
  if(fd < 0){
    27e6:	0a054963          	bltz	a0,2898 <fourteen+0x100>
  close(fd);
    27ea:	542020ef          	jal	4d2c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    27ee:	00004517          	auipc	a0,0x4
    27f2:	b2a50513          	addi	a0,a0,-1238 # 6318 <malloc+0x115a>
    27f6:	576020ef          	jal	4d6c <mkdir>
    27fa:	c94d                	beqz	a0,28ac <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    27fc:	00004517          	auipc	a0,0x4
    2800:	b7450513          	addi	a0,a0,-1164 # 6370 <malloc+0x11b2>
    2804:	568020ef          	jal	4d6c <mkdir>
    2808:	cd45                	beqz	a0,28c0 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    280a:	00004517          	auipc	a0,0x4
    280e:	b6650513          	addi	a0,a0,-1178 # 6370 <malloc+0x11b2>
    2812:	542020ef          	jal	4d54 <unlink>
  unlink("12345678901234/12345678901234");
    2816:	00004517          	auipc	a0,0x4
    281a:	b0250513          	addi	a0,a0,-1278 # 6318 <malloc+0x115a>
    281e:	536020ef          	jal	4d54 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2822:	00004517          	auipc	a0,0x4
    2826:	a8650513          	addi	a0,a0,-1402 # 62a8 <malloc+0x10ea>
    282a:	52a020ef          	jal	4d54 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    282e:	00004517          	auipc	a0,0x4
    2832:	a0250513          	addi	a0,a0,-1534 # 6230 <malloc+0x1072>
    2836:	51e020ef          	jal	4d54 <unlink>
  unlink("12345678901234/123456789012345");
    283a:	00004517          	auipc	a0,0x4
    283e:	99e50513          	addi	a0,a0,-1634 # 61d8 <malloc+0x101a>
    2842:	512020ef          	jal	4d54 <unlink>
  unlink("12345678901234");
    2846:	00004517          	auipc	a0,0x4
    284a:	b3a50513          	addi	a0,a0,-1222 # 6380 <malloc+0x11c2>
    284e:	506020ef          	jal	4d54 <unlink>
}
    2852:	60e2                	ld	ra,24(sp)
    2854:	6442                	ld	s0,16(sp)
    2856:	64a2                	ld	s1,8(sp)
    2858:	6105                	addi	sp,sp,32
    285a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    285c:	85a6                	mv	a1,s1
    285e:	00004517          	auipc	a0,0x4
    2862:	95250513          	addi	a0,a0,-1710 # 61b0 <malloc+0xff2>
    2866:	0a1020ef          	jal	5106 <printf>
    exit(1);
    286a:	4505                	li	a0,1
    286c:	498020ef          	jal	4d04 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2870:	85a6                	mv	a1,s1
    2872:	00004517          	auipc	a0,0x4
    2876:	98650513          	addi	a0,a0,-1658 # 61f8 <malloc+0x103a>
    287a:	08d020ef          	jal	5106 <printf>
    exit(1);
    287e:	4505                	li	a0,1
    2880:	484020ef          	jal	4d04 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2884:	85a6                	mv	a1,s1
    2886:	00004517          	auipc	a0,0x4
    288a:	9da50513          	addi	a0,a0,-1574 # 6260 <malloc+0x10a2>
    288e:	079020ef          	jal	5106 <printf>
    exit(1);
    2892:	4505                	li	a0,1
    2894:	470020ef          	jal	4d04 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2898:	85a6                	mv	a1,s1
    289a:	00004517          	auipc	a0,0x4
    289e:	a3e50513          	addi	a0,a0,-1474 # 62d8 <malloc+0x111a>
    28a2:	065020ef          	jal	5106 <printf>
    exit(1);
    28a6:	4505                	li	a0,1
    28a8:	45c020ef          	jal	4d04 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    28ac:	85a6                	mv	a1,s1
    28ae:	00004517          	auipc	a0,0x4
    28b2:	a8a50513          	addi	a0,a0,-1398 # 6338 <malloc+0x117a>
    28b6:	051020ef          	jal	5106 <printf>
    exit(1);
    28ba:	4505                	li	a0,1
    28bc:	448020ef          	jal	4d04 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    28c0:	85a6                	mv	a1,s1
    28c2:	00004517          	auipc	a0,0x4
    28c6:	ace50513          	addi	a0,a0,-1330 # 6390 <malloc+0x11d2>
    28ca:	03d020ef          	jal	5106 <printf>
    exit(1);
    28ce:	4505                	li	a0,1
    28d0:	434020ef          	jal	4d04 <exit>

00000000000028d4 <diskfull>:
{
    28d4:	b6010113          	addi	sp,sp,-1184
    28d8:	48113c23          	sd	ra,1176(sp)
    28dc:	48813823          	sd	s0,1168(sp)
    28e0:	48913423          	sd	s1,1160(sp)
    28e4:	49213023          	sd	s2,1152(sp)
    28e8:	47313c23          	sd	s3,1144(sp)
    28ec:	47413823          	sd	s4,1136(sp)
    28f0:	47513423          	sd	s5,1128(sp)
    28f4:	47613023          	sd	s6,1120(sp)
    28f8:	45713c23          	sd	s7,1112(sp)
    28fc:	45813823          	sd	s8,1104(sp)
    2900:	45913423          	sd	s9,1096(sp)
    2904:	45a13023          	sd	s10,1088(sp)
    2908:	43b13c23          	sd	s11,1080(sp)
    290c:	4a010413          	addi	s0,sp,1184
    2910:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    2914:	00004517          	auipc	a0,0x4
    2918:	ab450513          	addi	a0,a0,-1356 # 63c8 <malloc+0x120a>
    291c:	438020ef          	jal	4d54 <unlink>
    2920:	03000a93          	li	s5,48
    name[0] = 'b';
    2924:	06200d13          	li	s10,98
    name[1] = 'i';
    2928:	06900c93          	li	s9,105
    name[2] = 'g';
    292c:	06700c13          	li	s8,103
    unlink(name);
    2930:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2934:	60200b93          	li	s7,1538
    2938:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    293c:	b9040a13          	addi	s4,s0,-1136
    2940:	aa8d                	j	2ab2 <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    2942:	b7040613          	addi	a2,s0,-1168
    2946:	b6843583          	ld	a1,-1176(s0)
    294a:	00004517          	auipc	a0,0x4
    294e:	a8e50513          	addi	a0,a0,-1394 # 63d8 <malloc+0x121a>
    2952:	7b4020ef          	jal	5106 <printf>
      break;
    2956:	a039                	j	2964 <diskfull+0x90>
        close(fd);
    2958:	854e                	mv	a0,s3
    295a:	3d2020ef          	jal	4d2c <close>
    close(fd);
    295e:	854e                	mv	a0,s3
    2960:	3cc020ef          	jal	4d2c <close>
  for(int i = 0; i < nzz; i++){
    2964:	4481                	li	s1,0
    name[0] = 'z';
    2966:	07a00993          	li	s3,122
    unlink(name);
    296a:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    296e:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    2972:	08000a93          	li	s5,128
    name[0] = 'z';
    2976:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    297a:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    297e:	41f4d71b          	sraiw	a4,s1,0x1f
    2982:	01b7571b          	srliw	a4,a4,0x1b
    2986:	009707bb          	addw	a5,a4,s1
    298a:	4057d69b          	sraiw	a3,a5,0x5
    298e:	0306869b          	addiw	a3,a3,48
    2992:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2996:	8bfd                	andi	a5,a5,31
    2998:	9f99                	subw	a5,a5,a4
    299a:	0307879b          	addiw	a5,a5,48
    299e:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    29a2:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    29a6:	854a                	mv	a0,s2
    29a8:	3ac020ef          	jal	4d54 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29ac:	85d2                	mv	a1,s4
    29ae:	854a                	mv	a0,s2
    29b0:	394020ef          	jal	4d44 <open>
    if(fd < 0)
    29b4:	00054763          	bltz	a0,29c2 <diskfull+0xee>
    close(fd);
    29b8:	374020ef          	jal	4d2c <close>
  for(int i = 0; i < nzz; i++){
    29bc:	2485                	addiw	s1,s1,1
    29be:	fb549ce3          	bne	s1,s5,2976 <diskfull+0xa2>
  if(mkdir("diskfulldir") == 0)
    29c2:	00004517          	auipc	a0,0x4
    29c6:	a0650513          	addi	a0,a0,-1530 # 63c8 <malloc+0x120a>
    29ca:	3a2020ef          	jal	4d6c <mkdir>
    29ce:	12050363          	beqz	a0,2af4 <diskfull+0x220>
  unlink("diskfulldir");
    29d2:	00004517          	auipc	a0,0x4
    29d6:	9f650513          	addi	a0,a0,-1546 # 63c8 <malloc+0x120a>
    29da:	37a020ef          	jal	4d54 <unlink>
  for(int i = 0; i < nzz; i++){
    29de:	4481                	li	s1,0
    name[0] = 'z';
    29e0:	07a00913          	li	s2,122
    unlink(name);
    29e4:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    29e8:	08000993          	li	s3,128
    name[0] = 'z';
    29ec:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    29f0:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    29f4:	41f4d71b          	sraiw	a4,s1,0x1f
    29f8:	01b7571b          	srliw	a4,a4,0x1b
    29fc:	009707bb          	addw	a5,a4,s1
    2a00:	4057d69b          	sraiw	a3,a5,0x5
    2a04:	0306869b          	addiw	a3,a3,48
    2a08:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2a0c:	8bfd                	andi	a5,a5,31
    2a0e:	9f99                	subw	a5,a5,a4
    2a10:	0307879b          	addiw	a5,a5,48
    2a14:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2a18:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a1c:	8552                	mv	a0,s4
    2a1e:	336020ef          	jal	4d54 <unlink>
  for(int i = 0; i < nzz; i++){
    2a22:	2485                	addiw	s1,s1,1
    2a24:	fd3494e3          	bne	s1,s3,29ec <diskfull+0x118>
    2a28:	03000493          	li	s1,48
    name[0] = 'b';
    2a2c:	06200b13          	li	s6,98
    name[1] = 'i';
    2a30:	06900a93          	li	s5,105
    name[2] = 'g';
    2a34:	06700a13          	li	s4,103
    unlink(name);
    2a38:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    2a3c:	07f00913          	li	s2,127
    name[0] = 'b';
    2a40:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2a44:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    2a48:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    2a4c:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    2a50:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a54:	854e                	mv	a0,s3
    2a56:	2fe020ef          	jal	4d54 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2a5a:	2485                	addiw	s1,s1,1
    2a5c:	0ff4f493          	zext.b	s1,s1
    2a60:	ff2490e3          	bne	s1,s2,2a40 <diskfull+0x16c>
}
    2a64:	49813083          	ld	ra,1176(sp)
    2a68:	49013403          	ld	s0,1168(sp)
    2a6c:	48813483          	ld	s1,1160(sp)
    2a70:	48013903          	ld	s2,1152(sp)
    2a74:	47813983          	ld	s3,1144(sp)
    2a78:	47013a03          	ld	s4,1136(sp)
    2a7c:	46813a83          	ld	s5,1128(sp)
    2a80:	46013b03          	ld	s6,1120(sp)
    2a84:	45813b83          	ld	s7,1112(sp)
    2a88:	45013c03          	ld	s8,1104(sp)
    2a8c:	44813c83          	ld	s9,1096(sp)
    2a90:	44013d03          	ld	s10,1088(sp)
    2a94:	43813d83          	ld	s11,1080(sp)
    2a98:	4a010113          	addi	sp,sp,1184
    2a9c:	8082                	ret
    close(fd);
    2a9e:	854e                	mv	a0,s3
    2aa0:	28c020ef          	jal	4d2c <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2aa4:	2a85                	addiw	s5,s5,1
    2aa6:	0ffafa93          	zext.b	s5,s5
    2aaa:	07f00793          	li	a5,127
    2aae:	eafa8be3          	beq	s5,a5,2964 <diskfull+0x90>
    name[0] = 'b';
    2ab2:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2ab6:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2aba:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2abe:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2ac2:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2ac6:	855a                	mv	a0,s6
    2ac8:	28c020ef          	jal	4d54 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2acc:	85de                	mv	a1,s7
    2ace:	855a                	mv	a0,s6
    2ad0:	274020ef          	jal	4d44 <open>
    2ad4:	89aa                	mv	s3,a0
    if(fd < 0){
    2ad6:	e60546e3          	bltz	a0,2942 <diskfull+0x6e>
    2ada:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    2adc:	40000913          	li	s2,1024
    2ae0:	864a                	mv	a2,s2
    2ae2:	85d2                	mv	a1,s4
    2ae4:	854e                	mv	a0,s3
    2ae6:	23e020ef          	jal	4d24 <write>
    2aea:	e72517e3          	bne	a0,s2,2958 <diskfull+0x84>
    for(int i = 0; i < MAXFILE; i++){
    2aee:	34fd                	addiw	s1,s1,-1
    2af0:	f8e5                	bnez	s1,2ae0 <diskfull+0x20c>
    2af2:	b775                	j	2a9e <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2af4:	b6843583          	ld	a1,-1176(s0)
    2af8:	00004517          	auipc	a0,0x4
    2afc:	90050513          	addi	a0,a0,-1792 # 63f8 <malloc+0x123a>
    2b00:	606020ef          	jal	5106 <printf>
    2b04:	b5f9                	j	29d2 <diskfull+0xfe>

0000000000002b06 <iputtest>:
{
    2b06:	1101                	addi	sp,sp,-32
    2b08:	ec06                	sd	ra,24(sp)
    2b0a:	e822                	sd	s0,16(sp)
    2b0c:	e426                	sd	s1,8(sp)
    2b0e:	1000                	addi	s0,sp,32
    2b10:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b12:	00004517          	auipc	a0,0x4
    2b16:	91650513          	addi	a0,a0,-1770 # 6428 <malloc+0x126a>
    2b1a:	252020ef          	jal	4d6c <mkdir>
    2b1e:	02054f63          	bltz	a0,2b5c <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2b22:	00004517          	auipc	a0,0x4
    2b26:	90650513          	addi	a0,a0,-1786 # 6428 <malloc+0x126a>
    2b2a:	24a020ef          	jal	4d74 <chdir>
    2b2e:	04054163          	bltz	a0,2b70 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2b32:	00004517          	auipc	a0,0x4
    2b36:	93650513          	addi	a0,a0,-1738 # 6468 <malloc+0x12aa>
    2b3a:	21a020ef          	jal	4d54 <unlink>
    2b3e:	04054363          	bltz	a0,2b84 <iputtest+0x7e>
  if(chdir("/") < 0){
    2b42:	00004517          	auipc	a0,0x4
    2b46:	95650513          	addi	a0,a0,-1706 # 6498 <malloc+0x12da>
    2b4a:	22a020ef          	jal	4d74 <chdir>
    2b4e:	04054563          	bltz	a0,2b98 <iputtest+0x92>
}
    2b52:	60e2                	ld	ra,24(sp)
    2b54:	6442                	ld	s0,16(sp)
    2b56:	64a2                	ld	s1,8(sp)
    2b58:	6105                	addi	sp,sp,32
    2b5a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b5c:	85a6                	mv	a1,s1
    2b5e:	00004517          	auipc	a0,0x4
    2b62:	8d250513          	addi	a0,a0,-1838 # 6430 <malloc+0x1272>
    2b66:	5a0020ef          	jal	5106 <printf>
    exit(1);
    2b6a:	4505                	li	a0,1
    2b6c:	198020ef          	jal	4d04 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b70:	85a6                	mv	a1,s1
    2b72:	00004517          	auipc	a0,0x4
    2b76:	8d650513          	addi	a0,a0,-1834 # 6448 <malloc+0x128a>
    2b7a:	58c020ef          	jal	5106 <printf>
    exit(1);
    2b7e:	4505                	li	a0,1
    2b80:	184020ef          	jal	4d04 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2b84:	85a6                	mv	a1,s1
    2b86:	00004517          	auipc	a0,0x4
    2b8a:	8f250513          	addi	a0,a0,-1806 # 6478 <malloc+0x12ba>
    2b8e:	578020ef          	jal	5106 <printf>
    exit(1);
    2b92:	4505                	li	a0,1
    2b94:	170020ef          	jal	4d04 <exit>
    printf("%s: chdir / failed\n", s);
    2b98:	85a6                	mv	a1,s1
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	90650513          	addi	a0,a0,-1786 # 64a0 <malloc+0x12e2>
    2ba2:	564020ef          	jal	5106 <printf>
    exit(1);
    2ba6:	4505                	li	a0,1
    2ba8:	15c020ef          	jal	4d04 <exit>

0000000000002bac <exitiputtest>:
{
    2bac:	7179                	addi	sp,sp,-48
    2bae:	f406                	sd	ra,40(sp)
    2bb0:	f022                	sd	s0,32(sp)
    2bb2:	ec26                	sd	s1,24(sp)
    2bb4:	1800                	addi	s0,sp,48
    2bb6:	84aa                	mv	s1,a0
  pid = fork();
    2bb8:	144020ef          	jal	4cfc <fork>
  if(pid < 0){
    2bbc:	02054e63          	bltz	a0,2bf8 <exitiputtest+0x4c>
  if(pid == 0){
    2bc0:	e541                	bnez	a0,2c48 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2bc2:	00004517          	auipc	a0,0x4
    2bc6:	86650513          	addi	a0,a0,-1946 # 6428 <malloc+0x126a>
    2bca:	1a2020ef          	jal	4d6c <mkdir>
    2bce:	02054f63          	bltz	a0,2c0c <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2bd2:	00004517          	auipc	a0,0x4
    2bd6:	85650513          	addi	a0,a0,-1962 # 6428 <malloc+0x126a>
    2bda:	19a020ef          	jal	4d74 <chdir>
    2bde:	04054163          	bltz	a0,2c20 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2be2:	00004517          	auipc	a0,0x4
    2be6:	88650513          	addi	a0,a0,-1914 # 6468 <malloc+0x12aa>
    2bea:	16a020ef          	jal	4d54 <unlink>
    2bee:	04054363          	bltz	a0,2c34 <exitiputtest+0x88>
    exit(0);
    2bf2:	4501                	li	a0,0
    2bf4:	110020ef          	jal	4d04 <exit>
    printf("%s: fork failed\n", s);
    2bf8:	85a6                	mv	a1,s1
    2bfa:	00003517          	auipc	a0,0x3
    2bfe:	f7e50513          	addi	a0,a0,-130 # 5b78 <malloc+0x9ba>
    2c02:	504020ef          	jal	5106 <printf>
    exit(1);
    2c06:	4505                	li	a0,1
    2c08:	0fc020ef          	jal	4d04 <exit>
      printf("%s: mkdir failed\n", s);
    2c0c:	85a6                	mv	a1,s1
    2c0e:	00004517          	auipc	a0,0x4
    2c12:	82250513          	addi	a0,a0,-2014 # 6430 <malloc+0x1272>
    2c16:	4f0020ef          	jal	5106 <printf>
      exit(1);
    2c1a:	4505                	li	a0,1
    2c1c:	0e8020ef          	jal	4d04 <exit>
      printf("%s: child chdir failed\n", s);
    2c20:	85a6                	mv	a1,s1
    2c22:	00004517          	auipc	a0,0x4
    2c26:	89650513          	addi	a0,a0,-1898 # 64b8 <malloc+0x12fa>
    2c2a:	4dc020ef          	jal	5106 <printf>
      exit(1);
    2c2e:	4505                	li	a0,1
    2c30:	0d4020ef          	jal	4d04 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2c34:	85a6                	mv	a1,s1
    2c36:	00004517          	auipc	a0,0x4
    2c3a:	84250513          	addi	a0,a0,-1982 # 6478 <malloc+0x12ba>
    2c3e:	4c8020ef          	jal	5106 <printf>
      exit(1);
    2c42:	4505                	li	a0,1
    2c44:	0c0020ef          	jal	4d04 <exit>
  wait(&xstatus);
    2c48:	fdc40513          	addi	a0,s0,-36
    2c4c:	0c0020ef          	jal	4d0c <wait>
  exit(xstatus);
    2c50:	fdc42503          	lw	a0,-36(s0)
    2c54:	0b0020ef          	jal	4d04 <exit>

0000000000002c58 <dirtest>:
{
    2c58:	1101                	addi	sp,sp,-32
    2c5a:	ec06                	sd	ra,24(sp)
    2c5c:	e822                	sd	s0,16(sp)
    2c5e:	e426                	sd	s1,8(sp)
    2c60:	1000                	addi	s0,sp,32
    2c62:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2c64:	00004517          	auipc	a0,0x4
    2c68:	86c50513          	addi	a0,a0,-1940 # 64d0 <malloc+0x1312>
    2c6c:	100020ef          	jal	4d6c <mkdir>
    2c70:	02054f63          	bltz	a0,2cae <dirtest+0x56>
  if(chdir("dir0") < 0){
    2c74:	00004517          	auipc	a0,0x4
    2c78:	85c50513          	addi	a0,a0,-1956 # 64d0 <malloc+0x1312>
    2c7c:	0f8020ef          	jal	4d74 <chdir>
    2c80:	04054163          	bltz	a0,2cc2 <dirtest+0x6a>
  if(chdir("..") < 0){
    2c84:	00004517          	auipc	a0,0x4
    2c88:	86c50513          	addi	a0,a0,-1940 # 64f0 <malloc+0x1332>
    2c8c:	0e8020ef          	jal	4d74 <chdir>
    2c90:	04054363          	bltz	a0,2cd6 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2c94:	00004517          	auipc	a0,0x4
    2c98:	83c50513          	addi	a0,a0,-1988 # 64d0 <malloc+0x1312>
    2c9c:	0b8020ef          	jal	4d54 <unlink>
    2ca0:	04054563          	bltz	a0,2cea <dirtest+0x92>
}
    2ca4:	60e2                	ld	ra,24(sp)
    2ca6:	6442                	ld	s0,16(sp)
    2ca8:	64a2                	ld	s1,8(sp)
    2caa:	6105                	addi	sp,sp,32
    2cac:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cae:	85a6                	mv	a1,s1
    2cb0:	00003517          	auipc	a0,0x3
    2cb4:	78050513          	addi	a0,a0,1920 # 6430 <malloc+0x1272>
    2cb8:	44e020ef          	jal	5106 <printf>
    exit(1);
    2cbc:	4505                	li	a0,1
    2cbe:	046020ef          	jal	4d04 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2cc2:	85a6                	mv	a1,s1
    2cc4:	00004517          	auipc	a0,0x4
    2cc8:	81450513          	addi	a0,a0,-2028 # 64d8 <malloc+0x131a>
    2ccc:	43a020ef          	jal	5106 <printf>
    exit(1);
    2cd0:	4505                	li	a0,1
    2cd2:	032020ef          	jal	4d04 <exit>
    printf("%s: chdir .. failed\n", s);
    2cd6:	85a6                	mv	a1,s1
    2cd8:	00004517          	auipc	a0,0x4
    2cdc:	82050513          	addi	a0,a0,-2016 # 64f8 <malloc+0x133a>
    2ce0:	426020ef          	jal	5106 <printf>
    exit(1);
    2ce4:	4505                	li	a0,1
    2ce6:	01e020ef          	jal	4d04 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2cea:	85a6                	mv	a1,s1
    2cec:	00004517          	auipc	a0,0x4
    2cf0:	82450513          	addi	a0,a0,-2012 # 6510 <malloc+0x1352>
    2cf4:	412020ef          	jal	5106 <printf>
    exit(1);
    2cf8:	4505                	li	a0,1
    2cfa:	00a020ef          	jal	4d04 <exit>

0000000000002cfe <subdir>:
{
    2cfe:	1101                	addi	sp,sp,-32
    2d00:	ec06                	sd	ra,24(sp)
    2d02:	e822                	sd	s0,16(sp)
    2d04:	e426                	sd	s1,8(sp)
    2d06:	e04a                	sd	s2,0(sp)
    2d08:	1000                	addi	s0,sp,32
    2d0a:	892a                	mv	s2,a0
  unlink("ff");
    2d0c:	00004517          	auipc	a0,0x4
    2d10:	94c50513          	addi	a0,a0,-1716 # 6658 <malloc+0x149a>
    2d14:	040020ef          	jal	4d54 <unlink>
  if(mkdir("dd") != 0){
    2d18:	00004517          	auipc	a0,0x4
    2d1c:	81050513          	addi	a0,a0,-2032 # 6528 <malloc+0x136a>
    2d20:	04c020ef          	jal	4d6c <mkdir>
    2d24:	2e051263          	bnez	a0,3008 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d28:	20200593          	li	a1,514
    2d2c:	00004517          	auipc	a0,0x4
    2d30:	81c50513          	addi	a0,a0,-2020 # 6548 <malloc+0x138a>
    2d34:	010020ef          	jal	4d44 <open>
    2d38:	84aa                	mv	s1,a0
  if(fd < 0){
    2d3a:	2e054163          	bltz	a0,301c <subdir+0x31e>
  write(fd, "ff", 2);
    2d3e:	4609                	li	a2,2
    2d40:	00004597          	auipc	a1,0x4
    2d44:	91858593          	addi	a1,a1,-1768 # 6658 <malloc+0x149a>
    2d48:	7dd010ef          	jal	4d24 <write>
  close(fd);
    2d4c:	8526                	mv	a0,s1
    2d4e:	7df010ef          	jal	4d2c <close>
  if(unlink("dd") >= 0){
    2d52:	00003517          	auipc	a0,0x3
    2d56:	7d650513          	addi	a0,a0,2006 # 6528 <malloc+0x136a>
    2d5a:	7fb010ef          	jal	4d54 <unlink>
    2d5e:	2c055963          	bgez	a0,3030 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2d62:	00004517          	auipc	a0,0x4
    2d66:	83e50513          	addi	a0,a0,-1986 # 65a0 <malloc+0x13e2>
    2d6a:	002020ef          	jal	4d6c <mkdir>
    2d6e:	2c051b63          	bnez	a0,3044 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d72:	20200593          	li	a1,514
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	85250513          	addi	a0,a0,-1966 # 65c8 <malloc+0x140a>
    2d7e:	7c7010ef          	jal	4d44 <open>
    2d82:	84aa                	mv	s1,a0
  if(fd < 0){
    2d84:	2c054a63          	bltz	a0,3058 <subdir+0x35a>
  write(fd, "FF", 2);
    2d88:	4609                	li	a2,2
    2d8a:	00004597          	auipc	a1,0x4
    2d8e:	86e58593          	addi	a1,a1,-1938 # 65f8 <malloc+0x143a>
    2d92:	793010ef          	jal	4d24 <write>
  close(fd);
    2d96:	8526                	mv	a0,s1
    2d98:	795010ef          	jal	4d2c <close>
  fd = open("dd/dd/../ff", 0);
    2d9c:	4581                	li	a1,0
    2d9e:	00004517          	auipc	a0,0x4
    2da2:	86250513          	addi	a0,a0,-1950 # 6600 <malloc+0x1442>
    2da6:	79f010ef          	jal	4d44 <open>
    2daa:	84aa                	mv	s1,a0
  if(fd < 0){
    2dac:	2c054063          	bltz	a0,306c <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2db0:	660d                	lui	a2,0x3
    2db2:	00009597          	auipc	a1,0x9
    2db6:	ec658593          	addi	a1,a1,-314 # bc78 <buf>
    2dba:	763010ef          	jal	4d1c <read>
  if(cc != 2 || buf[0] != 'f'){
    2dbe:	4789                	li	a5,2
    2dc0:	2cf51063          	bne	a0,a5,3080 <subdir+0x382>
    2dc4:	00009717          	auipc	a4,0x9
    2dc8:	eb474703          	lbu	a4,-332(a4) # bc78 <buf>
    2dcc:	06600793          	li	a5,102
    2dd0:	2af71863          	bne	a4,a5,3080 <subdir+0x382>
  close(fd);
    2dd4:	8526                	mv	a0,s1
    2dd6:	757010ef          	jal	4d2c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2dda:	00004597          	auipc	a1,0x4
    2dde:	87658593          	addi	a1,a1,-1930 # 6650 <malloc+0x1492>
    2de2:	00003517          	auipc	a0,0x3
    2de6:	7e650513          	addi	a0,a0,2022 # 65c8 <malloc+0x140a>
    2dea:	77b010ef          	jal	4d64 <link>
    2dee:	2a051363          	bnez	a0,3094 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2df2:	00003517          	auipc	a0,0x3
    2df6:	7d650513          	addi	a0,a0,2006 # 65c8 <malloc+0x140a>
    2dfa:	75b010ef          	jal	4d54 <unlink>
    2dfe:	2a051563          	bnez	a0,30a8 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e02:	4581                	li	a1,0
    2e04:	00003517          	auipc	a0,0x3
    2e08:	7c450513          	addi	a0,a0,1988 # 65c8 <malloc+0x140a>
    2e0c:	739010ef          	jal	4d44 <open>
    2e10:	2a055663          	bgez	a0,30bc <subdir+0x3be>
  if(chdir("dd") != 0){
    2e14:	00003517          	auipc	a0,0x3
    2e18:	71450513          	addi	a0,a0,1812 # 6528 <malloc+0x136a>
    2e1c:	759010ef          	jal	4d74 <chdir>
    2e20:	2a051863          	bnez	a0,30d0 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2e24:	00004517          	auipc	a0,0x4
    2e28:	8c450513          	addi	a0,a0,-1852 # 66e8 <malloc+0x152a>
    2e2c:	749010ef          	jal	4d74 <chdir>
    2e30:	2a051a63          	bnez	a0,30e4 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2e34:	00004517          	auipc	a0,0x4
    2e38:	8e450513          	addi	a0,a0,-1820 # 6718 <malloc+0x155a>
    2e3c:	739010ef          	jal	4d74 <chdir>
    2e40:	2a051c63          	bnez	a0,30f8 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2e44:	00004517          	auipc	a0,0x4
    2e48:	90c50513          	addi	a0,a0,-1780 # 6750 <malloc+0x1592>
    2e4c:	729010ef          	jal	4d74 <chdir>
    2e50:	2a051e63          	bnez	a0,310c <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2e54:	4581                	li	a1,0
    2e56:	00003517          	auipc	a0,0x3
    2e5a:	7fa50513          	addi	a0,a0,2042 # 6650 <malloc+0x1492>
    2e5e:	6e7010ef          	jal	4d44 <open>
    2e62:	84aa                	mv	s1,a0
  if(fd < 0){
    2e64:	2a054e63          	bltz	a0,3120 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e68:	660d                	lui	a2,0x3
    2e6a:	00009597          	auipc	a1,0x9
    2e6e:	e0e58593          	addi	a1,a1,-498 # bc78 <buf>
    2e72:	6ab010ef          	jal	4d1c <read>
    2e76:	4789                	li	a5,2
    2e78:	2af51e63          	bne	a0,a5,3134 <subdir+0x436>
  close(fd);
    2e7c:	8526                	mv	a0,s1
    2e7e:	6af010ef          	jal	4d2c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e82:	4581                	li	a1,0
    2e84:	00003517          	auipc	a0,0x3
    2e88:	74450513          	addi	a0,a0,1860 # 65c8 <malloc+0x140a>
    2e8c:	6b9010ef          	jal	4d44 <open>
    2e90:	2a055c63          	bgez	a0,3148 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2e94:	20200593          	li	a1,514
    2e98:	00004517          	auipc	a0,0x4
    2e9c:	94850513          	addi	a0,a0,-1720 # 67e0 <malloc+0x1622>
    2ea0:	6a5010ef          	jal	4d44 <open>
    2ea4:	2a055c63          	bgez	a0,315c <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2ea8:	20200593          	li	a1,514
    2eac:	00004517          	auipc	a0,0x4
    2eb0:	96450513          	addi	a0,a0,-1692 # 6810 <malloc+0x1652>
    2eb4:	691010ef          	jal	4d44 <open>
    2eb8:	2a055c63          	bgez	a0,3170 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2ebc:	20000593          	li	a1,512
    2ec0:	00003517          	auipc	a0,0x3
    2ec4:	66850513          	addi	a0,a0,1640 # 6528 <malloc+0x136a>
    2ec8:	67d010ef          	jal	4d44 <open>
    2ecc:	2a055c63          	bgez	a0,3184 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2ed0:	4589                	li	a1,2
    2ed2:	00003517          	auipc	a0,0x3
    2ed6:	65650513          	addi	a0,a0,1622 # 6528 <malloc+0x136a>
    2eda:	66b010ef          	jal	4d44 <open>
    2ede:	2a055d63          	bgez	a0,3198 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2ee2:	4585                	li	a1,1
    2ee4:	00003517          	auipc	a0,0x3
    2ee8:	64450513          	addi	a0,a0,1604 # 6528 <malloc+0x136a>
    2eec:	659010ef          	jal	4d44 <open>
    2ef0:	2a055e63          	bgez	a0,31ac <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2ef4:	00004597          	auipc	a1,0x4
    2ef8:	9ac58593          	addi	a1,a1,-1620 # 68a0 <malloc+0x16e2>
    2efc:	00004517          	auipc	a0,0x4
    2f00:	8e450513          	addi	a0,a0,-1820 # 67e0 <malloc+0x1622>
    2f04:	661010ef          	jal	4d64 <link>
    2f08:	2a050c63          	beqz	a0,31c0 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f0c:	00004597          	auipc	a1,0x4
    2f10:	99458593          	addi	a1,a1,-1644 # 68a0 <malloc+0x16e2>
    2f14:	00004517          	auipc	a0,0x4
    2f18:	8fc50513          	addi	a0,a0,-1796 # 6810 <malloc+0x1652>
    2f1c:	649010ef          	jal	4d64 <link>
    2f20:	2a050a63          	beqz	a0,31d4 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f24:	00003597          	auipc	a1,0x3
    2f28:	72c58593          	addi	a1,a1,1836 # 6650 <malloc+0x1492>
    2f2c:	00003517          	auipc	a0,0x3
    2f30:	61c50513          	addi	a0,a0,1564 # 6548 <malloc+0x138a>
    2f34:	631010ef          	jal	4d64 <link>
    2f38:	2a050863          	beqz	a0,31e8 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2f3c:	00004517          	auipc	a0,0x4
    2f40:	8a450513          	addi	a0,a0,-1884 # 67e0 <malloc+0x1622>
    2f44:	629010ef          	jal	4d6c <mkdir>
    2f48:	2a050a63          	beqz	a0,31fc <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2f4c:	00004517          	auipc	a0,0x4
    2f50:	8c450513          	addi	a0,a0,-1852 # 6810 <malloc+0x1652>
    2f54:	619010ef          	jal	4d6c <mkdir>
    2f58:	2a050c63          	beqz	a0,3210 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2f5c:	00003517          	auipc	a0,0x3
    2f60:	6f450513          	addi	a0,a0,1780 # 6650 <malloc+0x1492>
    2f64:	609010ef          	jal	4d6c <mkdir>
    2f68:	2a050e63          	beqz	a0,3224 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2f6c:	00004517          	auipc	a0,0x4
    2f70:	8a450513          	addi	a0,a0,-1884 # 6810 <malloc+0x1652>
    2f74:	5e1010ef          	jal	4d54 <unlink>
    2f78:	2c050063          	beqz	a0,3238 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2f7c:	00004517          	auipc	a0,0x4
    2f80:	86450513          	addi	a0,a0,-1948 # 67e0 <malloc+0x1622>
    2f84:	5d1010ef          	jal	4d54 <unlink>
    2f88:	2c050263          	beqz	a0,324c <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2f8c:	00003517          	auipc	a0,0x3
    2f90:	5bc50513          	addi	a0,a0,1468 # 6548 <malloc+0x138a>
    2f94:	5e1010ef          	jal	4d74 <chdir>
    2f98:	2c050463          	beqz	a0,3260 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2f9c:	00004517          	auipc	a0,0x4
    2fa0:	a5450513          	addi	a0,a0,-1452 # 69f0 <malloc+0x1832>
    2fa4:	5d1010ef          	jal	4d74 <chdir>
    2fa8:	2c050663          	beqz	a0,3274 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2fac:	00003517          	auipc	a0,0x3
    2fb0:	6a450513          	addi	a0,a0,1700 # 6650 <malloc+0x1492>
    2fb4:	5a1010ef          	jal	4d54 <unlink>
    2fb8:	2c051863          	bnez	a0,3288 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2fbc:	00003517          	auipc	a0,0x3
    2fc0:	58c50513          	addi	a0,a0,1420 # 6548 <malloc+0x138a>
    2fc4:	591010ef          	jal	4d54 <unlink>
    2fc8:	2c051a63          	bnez	a0,329c <subdir+0x59e>
  if(unlink("dd") == 0){
    2fcc:	00003517          	auipc	a0,0x3
    2fd0:	55c50513          	addi	a0,a0,1372 # 6528 <malloc+0x136a>
    2fd4:	581010ef          	jal	4d54 <unlink>
    2fd8:	2c050c63          	beqz	a0,32b0 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2fdc:	00004517          	auipc	a0,0x4
    2fe0:	a8450513          	addi	a0,a0,-1404 # 6a60 <malloc+0x18a2>
    2fe4:	571010ef          	jal	4d54 <unlink>
    2fe8:	2c054e63          	bltz	a0,32c4 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2fec:	00003517          	auipc	a0,0x3
    2ff0:	53c50513          	addi	a0,a0,1340 # 6528 <malloc+0x136a>
    2ff4:	561010ef          	jal	4d54 <unlink>
    2ff8:	2e054063          	bltz	a0,32d8 <subdir+0x5da>
}
    2ffc:	60e2                	ld	ra,24(sp)
    2ffe:	6442                	ld	s0,16(sp)
    3000:	64a2                	ld	s1,8(sp)
    3002:	6902                	ld	s2,0(sp)
    3004:	6105                	addi	sp,sp,32
    3006:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3008:	85ca                	mv	a1,s2
    300a:	00003517          	auipc	a0,0x3
    300e:	52650513          	addi	a0,a0,1318 # 6530 <malloc+0x1372>
    3012:	0f4020ef          	jal	5106 <printf>
    exit(1);
    3016:	4505                	li	a0,1
    3018:	4ed010ef          	jal	4d04 <exit>
    printf("%s: create dd/ff failed\n", s);
    301c:	85ca                	mv	a1,s2
    301e:	00003517          	auipc	a0,0x3
    3022:	53250513          	addi	a0,a0,1330 # 6550 <malloc+0x1392>
    3026:	0e0020ef          	jal	5106 <printf>
    exit(1);
    302a:	4505                	li	a0,1
    302c:	4d9010ef          	jal	4d04 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3030:	85ca                	mv	a1,s2
    3032:	00003517          	auipc	a0,0x3
    3036:	53e50513          	addi	a0,a0,1342 # 6570 <malloc+0x13b2>
    303a:	0cc020ef          	jal	5106 <printf>
    exit(1);
    303e:	4505                	li	a0,1
    3040:	4c5010ef          	jal	4d04 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3044:	85ca                	mv	a1,s2
    3046:	00003517          	auipc	a0,0x3
    304a:	56250513          	addi	a0,a0,1378 # 65a8 <malloc+0x13ea>
    304e:	0b8020ef          	jal	5106 <printf>
    exit(1);
    3052:	4505                	li	a0,1
    3054:	4b1010ef          	jal	4d04 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3058:	85ca                	mv	a1,s2
    305a:	00003517          	auipc	a0,0x3
    305e:	57e50513          	addi	a0,a0,1406 # 65d8 <malloc+0x141a>
    3062:	0a4020ef          	jal	5106 <printf>
    exit(1);
    3066:	4505                	li	a0,1
    3068:	49d010ef          	jal	4d04 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    306c:	85ca                	mv	a1,s2
    306e:	00003517          	auipc	a0,0x3
    3072:	5a250513          	addi	a0,a0,1442 # 6610 <malloc+0x1452>
    3076:	090020ef          	jal	5106 <printf>
    exit(1);
    307a:	4505                	li	a0,1
    307c:	489010ef          	jal	4d04 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3080:	85ca                	mv	a1,s2
    3082:	00003517          	auipc	a0,0x3
    3086:	5ae50513          	addi	a0,a0,1454 # 6630 <malloc+0x1472>
    308a:	07c020ef          	jal	5106 <printf>
    exit(1);
    308e:	4505                	li	a0,1
    3090:	475010ef          	jal	4d04 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    3094:	85ca                	mv	a1,s2
    3096:	00003517          	auipc	a0,0x3
    309a:	5ca50513          	addi	a0,a0,1482 # 6660 <malloc+0x14a2>
    309e:	068020ef          	jal	5106 <printf>
    exit(1);
    30a2:	4505                	li	a0,1
    30a4:	461010ef          	jal	4d04 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30a8:	85ca                	mv	a1,s2
    30aa:	00003517          	auipc	a0,0x3
    30ae:	5de50513          	addi	a0,a0,1502 # 6688 <malloc+0x14ca>
    30b2:	054020ef          	jal	5106 <printf>
    exit(1);
    30b6:	4505                	li	a0,1
    30b8:	44d010ef          	jal	4d04 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    30bc:	85ca                	mv	a1,s2
    30be:	00003517          	auipc	a0,0x3
    30c2:	5ea50513          	addi	a0,a0,1514 # 66a8 <malloc+0x14ea>
    30c6:	040020ef          	jal	5106 <printf>
    exit(1);
    30ca:	4505                	li	a0,1
    30cc:	439010ef          	jal	4d04 <exit>
    printf("%s: chdir dd failed\n", s);
    30d0:	85ca                	mv	a1,s2
    30d2:	00003517          	auipc	a0,0x3
    30d6:	5fe50513          	addi	a0,a0,1534 # 66d0 <malloc+0x1512>
    30da:	02c020ef          	jal	5106 <printf>
    exit(1);
    30de:	4505                	li	a0,1
    30e0:	425010ef          	jal	4d04 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    30e4:	85ca                	mv	a1,s2
    30e6:	00003517          	auipc	a0,0x3
    30ea:	61250513          	addi	a0,a0,1554 # 66f8 <malloc+0x153a>
    30ee:	018020ef          	jal	5106 <printf>
    exit(1);
    30f2:	4505                	li	a0,1
    30f4:	411010ef          	jal	4d04 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    30f8:	85ca                	mv	a1,s2
    30fa:	00003517          	auipc	a0,0x3
    30fe:	62e50513          	addi	a0,a0,1582 # 6728 <malloc+0x156a>
    3102:	004020ef          	jal	5106 <printf>
    exit(1);
    3106:	4505                	li	a0,1
    3108:	3fd010ef          	jal	4d04 <exit>
    printf("%s: chdir ./.. failed\n", s);
    310c:	85ca                	mv	a1,s2
    310e:	00003517          	auipc	a0,0x3
    3112:	64a50513          	addi	a0,a0,1610 # 6758 <malloc+0x159a>
    3116:	7f1010ef          	jal	5106 <printf>
    exit(1);
    311a:	4505                	li	a0,1
    311c:	3e9010ef          	jal	4d04 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3120:	85ca                	mv	a1,s2
    3122:	00003517          	auipc	a0,0x3
    3126:	64e50513          	addi	a0,a0,1614 # 6770 <malloc+0x15b2>
    312a:	7dd010ef          	jal	5106 <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	3d5010ef          	jal	4d04 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3134:	85ca                	mv	a1,s2
    3136:	00003517          	auipc	a0,0x3
    313a:	65a50513          	addi	a0,a0,1626 # 6790 <malloc+0x15d2>
    313e:	7c9010ef          	jal	5106 <printf>
    exit(1);
    3142:	4505                	li	a0,1
    3144:	3c1010ef          	jal	4d04 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3148:	85ca                	mv	a1,s2
    314a:	00003517          	auipc	a0,0x3
    314e:	66650513          	addi	a0,a0,1638 # 67b0 <malloc+0x15f2>
    3152:	7b5010ef          	jal	5106 <printf>
    exit(1);
    3156:	4505                	li	a0,1
    3158:	3ad010ef          	jal	4d04 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    315c:	85ca                	mv	a1,s2
    315e:	00003517          	auipc	a0,0x3
    3162:	69250513          	addi	a0,a0,1682 # 67f0 <malloc+0x1632>
    3166:	7a1010ef          	jal	5106 <printf>
    exit(1);
    316a:	4505                	li	a0,1
    316c:	399010ef          	jal	4d04 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3170:	85ca                	mv	a1,s2
    3172:	00003517          	auipc	a0,0x3
    3176:	6ae50513          	addi	a0,a0,1710 # 6820 <malloc+0x1662>
    317a:	78d010ef          	jal	5106 <printf>
    exit(1);
    317e:	4505                	li	a0,1
    3180:	385010ef          	jal	4d04 <exit>
    printf("%s: create dd succeeded!\n", s);
    3184:	85ca                	mv	a1,s2
    3186:	00003517          	auipc	a0,0x3
    318a:	6ba50513          	addi	a0,a0,1722 # 6840 <malloc+0x1682>
    318e:	779010ef          	jal	5106 <printf>
    exit(1);
    3192:	4505                	li	a0,1
    3194:	371010ef          	jal	4d04 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3198:	85ca                	mv	a1,s2
    319a:	00003517          	auipc	a0,0x3
    319e:	6c650513          	addi	a0,a0,1734 # 6860 <malloc+0x16a2>
    31a2:	765010ef          	jal	5106 <printf>
    exit(1);
    31a6:	4505                	li	a0,1
    31a8:	35d010ef          	jal	4d04 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    31ac:	85ca                	mv	a1,s2
    31ae:	00003517          	auipc	a0,0x3
    31b2:	6d250513          	addi	a0,a0,1746 # 6880 <malloc+0x16c2>
    31b6:	751010ef          	jal	5106 <printf>
    exit(1);
    31ba:	4505                	li	a0,1
    31bc:	349010ef          	jal	4d04 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    31c0:	85ca                	mv	a1,s2
    31c2:	00003517          	auipc	a0,0x3
    31c6:	6ee50513          	addi	a0,a0,1774 # 68b0 <malloc+0x16f2>
    31ca:	73d010ef          	jal	5106 <printf>
    exit(1);
    31ce:	4505                	li	a0,1
    31d0:	335010ef          	jal	4d04 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    31d4:	85ca                	mv	a1,s2
    31d6:	00003517          	auipc	a0,0x3
    31da:	70250513          	addi	a0,a0,1794 # 68d8 <malloc+0x171a>
    31de:	729010ef          	jal	5106 <printf>
    exit(1);
    31e2:	4505                	li	a0,1
    31e4:	321010ef          	jal	4d04 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    31e8:	85ca                	mv	a1,s2
    31ea:	00003517          	auipc	a0,0x3
    31ee:	71650513          	addi	a0,a0,1814 # 6900 <malloc+0x1742>
    31f2:	715010ef          	jal	5106 <printf>
    exit(1);
    31f6:	4505                	li	a0,1
    31f8:	30d010ef          	jal	4d04 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    31fc:	85ca                	mv	a1,s2
    31fe:	00003517          	auipc	a0,0x3
    3202:	72a50513          	addi	a0,a0,1834 # 6928 <malloc+0x176a>
    3206:	701010ef          	jal	5106 <printf>
    exit(1);
    320a:	4505                	li	a0,1
    320c:	2f9010ef          	jal	4d04 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3210:	85ca                	mv	a1,s2
    3212:	00003517          	auipc	a0,0x3
    3216:	73650513          	addi	a0,a0,1846 # 6948 <malloc+0x178a>
    321a:	6ed010ef          	jal	5106 <printf>
    exit(1);
    321e:	4505                	li	a0,1
    3220:	2e5010ef          	jal	4d04 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3224:	85ca                	mv	a1,s2
    3226:	00003517          	auipc	a0,0x3
    322a:	74250513          	addi	a0,a0,1858 # 6968 <malloc+0x17aa>
    322e:	6d9010ef          	jal	5106 <printf>
    exit(1);
    3232:	4505                	li	a0,1
    3234:	2d1010ef          	jal	4d04 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3238:	85ca                	mv	a1,s2
    323a:	00003517          	auipc	a0,0x3
    323e:	75650513          	addi	a0,a0,1878 # 6990 <malloc+0x17d2>
    3242:	6c5010ef          	jal	5106 <printf>
    exit(1);
    3246:	4505                	li	a0,1
    3248:	2bd010ef          	jal	4d04 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    324c:	85ca                	mv	a1,s2
    324e:	00003517          	auipc	a0,0x3
    3252:	76250513          	addi	a0,a0,1890 # 69b0 <malloc+0x17f2>
    3256:	6b1010ef          	jal	5106 <printf>
    exit(1);
    325a:	4505                	li	a0,1
    325c:	2a9010ef          	jal	4d04 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3260:	85ca                	mv	a1,s2
    3262:	00003517          	auipc	a0,0x3
    3266:	76e50513          	addi	a0,a0,1902 # 69d0 <malloc+0x1812>
    326a:	69d010ef          	jal	5106 <printf>
    exit(1);
    326e:	4505                	li	a0,1
    3270:	295010ef          	jal	4d04 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3274:	85ca                	mv	a1,s2
    3276:	00003517          	auipc	a0,0x3
    327a:	78250513          	addi	a0,a0,1922 # 69f8 <malloc+0x183a>
    327e:	689010ef          	jal	5106 <printf>
    exit(1);
    3282:	4505                	li	a0,1
    3284:	281010ef          	jal	4d04 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3288:	85ca                	mv	a1,s2
    328a:	00003517          	auipc	a0,0x3
    328e:	3fe50513          	addi	a0,a0,1022 # 6688 <malloc+0x14ca>
    3292:	675010ef          	jal	5106 <printf>
    exit(1);
    3296:	4505                	li	a0,1
    3298:	26d010ef          	jal	4d04 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    329c:	85ca                	mv	a1,s2
    329e:	00003517          	auipc	a0,0x3
    32a2:	77a50513          	addi	a0,a0,1914 # 6a18 <malloc+0x185a>
    32a6:	661010ef          	jal	5106 <printf>
    exit(1);
    32aa:	4505                	li	a0,1
    32ac:	259010ef          	jal	4d04 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    32b0:	85ca                	mv	a1,s2
    32b2:	00003517          	auipc	a0,0x3
    32b6:	78650513          	addi	a0,a0,1926 # 6a38 <malloc+0x187a>
    32ba:	64d010ef          	jal	5106 <printf>
    exit(1);
    32be:	4505                	li	a0,1
    32c0:	245010ef          	jal	4d04 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    32c4:	85ca                	mv	a1,s2
    32c6:	00003517          	auipc	a0,0x3
    32ca:	7a250513          	addi	a0,a0,1954 # 6a68 <malloc+0x18aa>
    32ce:	639010ef          	jal	5106 <printf>
    exit(1);
    32d2:	4505                	li	a0,1
    32d4:	231010ef          	jal	4d04 <exit>
    printf("%s: unlink dd failed\n", s);
    32d8:	85ca                	mv	a1,s2
    32da:	00003517          	auipc	a0,0x3
    32de:	7ae50513          	addi	a0,a0,1966 # 6a88 <malloc+0x18ca>
    32e2:	625010ef          	jal	5106 <printf>
    exit(1);
    32e6:	4505                	li	a0,1
    32e8:	21d010ef          	jal	4d04 <exit>

00000000000032ec <rmdot>:
{
    32ec:	1101                	addi	sp,sp,-32
    32ee:	ec06                	sd	ra,24(sp)
    32f0:	e822                	sd	s0,16(sp)
    32f2:	e426                	sd	s1,8(sp)
    32f4:	1000                	addi	s0,sp,32
    32f6:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    32f8:	00003517          	auipc	a0,0x3
    32fc:	7a850513          	addi	a0,a0,1960 # 6aa0 <malloc+0x18e2>
    3300:	26d010ef          	jal	4d6c <mkdir>
    3304:	e53d                	bnez	a0,3372 <rmdot+0x86>
  if(chdir("dots") != 0){
    3306:	00003517          	auipc	a0,0x3
    330a:	79a50513          	addi	a0,a0,1946 # 6aa0 <malloc+0x18e2>
    330e:	267010ef          	jal	4d74 <chdir>
    3312:	e935                	bnez	a0,3386 <rmdot+0x9a>
  if(unlink(".") == 0){
    3314:	00002517          	auipc	a0,0x2
    3318:	6bc50513          	addi	a0,a0,1724 # 59d0 <malloc+0x812>
    331c:	239010ef          	jal	4d54 <unlink>
    3320:	cd2d                	beqz	a0,339a <rmdot+0xae>
  if(unlink("..") == 0){
    3322:	00003517          	auipc	a0,0x3
    3326:	1ce50513          	addi	a0,a0,462 # 64f0 <malloc+0x1332>
    332a:	22b010ef          	jal	4d54 <unlink>
    332e:	c141                	beqz	a0,33ae <rmdot+0xc2>
  if(chdir("/") != 0){
    3330:	00003517          	auipc	a0,0x3
    3334:	16850513          	addi	a0,a0,360 # 6498 <malloc+0x12da>
    3338:	23d010ef          	jal	4d74 <chdir>
    333c:	e159                	bnez	a0,33c2 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    333e:	00003517          	auipc	a0,0x3
    3342:	7ca50513          	addi	a0,a0,1994 # 6b08 <malloc+0x194a>
    3346:	20f010ef          	jal	4d54 <unlink>
    334a:	c551                	beqz	a0,33d6 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    334c:	00003517          	auipc	a0,0x3
    3350:	7e450513          	addi	a0,a0,2020 # 6b30 <malloc+0x1972>
    3354:	201010ef          	jal	4d54 <unlink>
    3358:	c949                	beqz	a0,33ea <rmdot+0xfe>
  if(unlink("dots") != 0){
    335a:	00003517          	auipc	a0,0x3
    335e:	74650513          	addi	a0,a0,1862 # 6aa0 <malloc+0x18e2>
    3362:	1f3010ef          	jal	4d54 <unlink>
    3366:	ed41                	bnez	a0,33fe <rmdot+0x112>
}
    3368:	60e2                	ld	ra,24(sp)
    336a:	6442                	ld	s0,16(sp)
    336c:	64a2                	ld	s1,8(sp)
    336e:	6105                	addi	sp,sp,32
    3370:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3372:	85a6                	mv	a1,s1
    3374:	00003517          	auipc	a0,0x3
    3378:	73450513          	addi	a0,a0,1844 # 6aa8 <malloc+0x18ea>
    337c:	58b010ef          	jal	5106 <printf>
    exit(1);
    3380:	4505                	li	a0,1
    3382:	183010ef          	jal	4d04 <exit>
    printf("%s: chdir dots failed\n", s);
    3386:	85a6                	mv	a1,s1
    3388:	00003517          	auipc	a0,0x3
    338c:	73850513          	addi	a0,a0,1848 # 6ac0 <malloc+0x1902>
    3390:	577010ef          	jal	5106 <printf>
    exit(1);
    3394:	4505                	li	a0,1
    3396:	16f010ef          	jal	4d04 <exit>
    printf("%s: rm . worked!\n", s);
    339a:	85a6                	mv	a1,s1
    339c:	00003517          	auipc	a0,0x3
    33a0:	73c50513          	addi	a0,a0,1852 # 6ad8 <malloc+0x191a>
    33a4:	563010ef          	jal	5106 <printf>
    exit(1);
    33a8:	4505                	li	a0,1
    33aa:	15b010ef          	jal	4d04 <exit>
    printf("%s: rm .. worked!\n", s);
    33ae:	85a6                	mv	a1,s1
    33b0:	00003517          	auipc	a0,0x3
    33b4:	74050513          	addi	a0,a0,1856 # 6af0 <malloc+0x1932>
    33b8:	54f010ef          	jal	5106 <printf>
    exit(1);
    33bc:	4505                	li	a0,1
    33be:	147010ef          	jal	4d04 <exit>
    printf("%s: chdir / failed\n", s);
    33c2:	85a6                	mv	a1,s1
    33c4:	00003517          	auipc	a0,0x3
    33c8:	0dc50513          	addi	a0,a0,220 # 64a0 <malloc+0x12e2>
    33cc:	53b010ef          	jal	5106 <printf>
    exit(1);
    33d0:	4505                	li	a0,1
    33d2:	133010ef          	jal	4d04 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    33d6:	85a6                	mv	a1,s1
    33d8:	00003517          	auipc	a0,0x3
    33dc:	73850513          	addi	a0,a0,1848 # 6b10 <malloc+0x1952>
    33e0:	527010ef          	jal	5106 <printf>
    exit(1);
    33e4:	4505                	li	a0,1
    33e6:	11f010ef          	jal	4d04 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    33ea:	85a6                	mv	a1,s1
    33ec:	00003517          	auipc	a0,0x3
    33f0:	74c50513          	addi	a0,a0,1868 # 6b38 <malloc+0x197a>
    33f4:	513010ef          	jal	5106 <printf>
    exit(1);
    33f8:	4505                	li	a0,1
    33fa:	10b010ef          	jal	4d04 <exit>
    printf("%s: unlink dots failed!\n", s);
    33fe:	85a6                	mv	a1,s1
    3400:	00003517          	auipc	a0,0x3
    3404:	75850513          	addi	a0,a0,1880 # 6b58 <malloc+0x199a>
    3408:	4ff010ef          	jal	5106 <printf>
    exit(1);
    340c:	4505                	li	a0,1
    340e:	0f7010ef          	jal	4d04 <exit>

0000000000003412 <dirfile>:
{
    3412:	1101                	addi	sp,sp,-32
    3414:	ec06                	sd	ra,24(sp)
    3416:	e822                	sd	s0,16(sp)
    3418:	e426                	sd	s1,8(sp)
    341a:	e04a                	sd	s2,0(sp)
    341c:	1000                	addi	s0,sp,32
    341e:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3420:	20000593          	li	a1,512
    3424:	00003517          	auipc	a0,0x3
    3428:	75450513          	addi	a0,a0,1876 # 6b78 <malloc+0x19ba>
    342c:	119010ef          	jal	4d44 <open>
  if(fd < 0){
    3430:	0c054563          	bltz	a0,34fa <dirfile+0xe8>
  close(fd);
    3434:	0f9010ef          	jal	4d2c <close>
  if(chdir("dirfile") == 0){
    3438:	00003517          	auipc	a0,0x3
    343c:	74050513          	addi	a0,a0,1856 # 6b78 <malloc+0x19ba>
    3440:	135010ef          	jal	4d74 <chdir>
    3444:	c569                	beqz	a0,350e <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3446:	4581                	li	a1,0
    3448:	00003517          	auipc	a0,0x3
    344c:	77850513          	addi	a0,a0,1912 # 6bc0 <malloc+0x1a02>
    3450:	0f5010ef          	jal	4d44 <open>
  if(fd >= 0){
    3454:	0c055763          	bgez	a0,3522 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    3458:	20000593          	li	a1,512
    345c:	00003517          	auipc	a0,0x3
    3460:	76450513          	addi	a0,a0,1892 # 6bc0 <malloc+0x1a02>
    3464:	0e1010ef          	jal	4d44 <open>
  if(fd >= 0){
    3468:	0c055763          	bgez	a0,3536 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    346c:	00003517          	auipc	a0,0x3
    3470:	75450513          	addi	a0,a0,1876 # 6bc0 <malloc+0x1a02>
    3474:	0f9010ef          	jal	4d6c <mkdir>
    3478:	0c050963          	beqz	a0,354a <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    347c:	00003517          	auipc	a0,0x3
    3480:	74450513          	addi	a0,a0,1860 # 6bc0 <malloc+0x1a02>
    3484:	0d1010ef          	jal	4d54 <unlink>
    3488:	0c050b63          	beqz	a0,355e <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    348c:	00003597          	auipc	a1,0x3
    3490:	73458593          	addi	a1,a1,1844 # 6bc0 <malloc+0x1a02>
    3494:	00002517          	auipc	a0,0x2
    3498:	02c50513          	addi	a0,a0,44 # 54c0 <malloc+0x302>
    349c:	0c9010ef          	jal	4d64 <link>
    34a0:	0c050963          	beqz	a0,3572 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    34a4:	00003517          	auipc	a0,0x3
    34a8:	6d450513          	addi	a0,a0,1748 # 6b78 <malloc+0x19ba>
    34ac:	0a9010ef          	jal	4d54 <unlink>
    34b0:	0c051b63          	bnez	a0,3586 <dirfile+0x174>
  fd = open(".", O_RDWR);
    34b4:	4589                	li	a1,2
    34b6:	00002517          	auipc	a0,0x2
    34ba:	51a50513          	addi	a0,a0,1306 # 59d0 <malloc+0x812>
    34be:	087010ef          	jal	4d44 <open>
  if(fd >= 0){
    34c2:	0c055c63          	bgez	a0,359a <dirfile+0x188>
  fd = open(".", 0);
    34c6:	4581                	li	a1,0
    34c8:	00002517          	auipc	a0,0x2
    34cc:	50850513          	addi	a0,a0,1288 # 59d0 <malloc+0x812>
    34d0:	075010ef          	jal	4d44 <open>
    34d4:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    34d6:	4605                	li	a2,1
    34d8:	00002597          	auipc	a1,0x2
    34dc:	e8058593          	addi	a1,a1,-384 # 5358 <malloc+0x19a>
    34e0:	045010ef          	jal	4d24 <write>
    34e4:	0ca04563          	bgtz	a0,35ae <dirfile+0x19c>
  close(fd);
    34e8:	8526                	mv	a0,s1
    34ea:	043010ef          	jal	4d2c <close>
}
    34ee:	60e2                	ld	ra,24(sp)
    34f0:	6442                	ld	s0,16(sp)
    34f2:	64a2                	ld	s1,8(sp)
    34f4:	6902                	ld	s2,0(sp)
    34f6:	6105                	addi	sp,sp,32
    34f8:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    34fa:	85ca                	mv	a1,s2
    34fc:	00003517          	auipc	a0,0x3
    3500:	68450513          	addi	a0,a0,1668 # 6b80 <malloc+0x19c2>
    3504:	403010ef          	jal	5106 <printf>
    exit(1);
    3508:	4505                	li	a0,1
    350a:	7fa010ef          	jal	4d04 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    350e:	85ca                	mv	a1,s2
    3510:	00003517          	auipc	a0,0x3
    3514:	69050513          	addi	a0,a0,1680 # 6ba0 <malloc+0x19e2>
    3518:	3ef010ef          	jal	5106 <printf>
    exit(1);
    351c:	4505                	li	a0,1
    351e:	7e6010ef          	jal	4d04 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3522:	85ca                	mv	a1,s2
    3524:	00003517          	auipc	a0,0x3
    3528:	6ac50513          	addi	a0,a0,1708 # 6bd0 <malloc+0x1a12>
    352c:	3db010ef          	jal	5106 <printf>
    exit(1);
    3530:	4505                	li	a0,1
    3532:	7d2010ef          	jal	4d04 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3536:	85ca                	mv	a1,s2
    3538:	00003517          	auipc	a0,0x3
    353c:	69850513          	addi	a0,a0,1688 # 6bd0 <malloc+0x1a12>
    3540:	3c7010ef          	jal	5106 <printf>
    exit(1);
    3544:	4505                	li	a0,1
    3546:	7be010ef          	jal	4d04 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    354a:	85ca                	mv	a1,s2
    354c:	00003517          	auipc	a0,0x3
    3550:	6ac50513          	addi	a0,a0,1708 # 6bf8 <malloc+0x1a3a>
    3554:	3b3010ef          	jal	5106 <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	7aa010ef          	jal	4d04 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    355e:	85ca                	mv	a1,s2
    3560:	00003517          	auipc	a0,0x3
    3564:	6c050513          	addi	a0,a0,1728 # 6c20 <malloc+0x1a62>
    3568:	39f010ef          	jal	5106 <printf>
    exit(1);
    356c:	4505                	li	a0,1
    356e:	796010ef          	jal	4d04 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3572:	85ca                	mv	a1,s2
    3574:	00003517          	auipc	a0,0x3
    3578:	6d450513          	addi	a0,a0,1748 # 6c48 <malloc+0x1a8a>
    357c:	38b010ef          	jal	5106 <printf>
    exit(1);
    3580:	4505                	li	a0,1
    3582:	782010ef          	jal	4d04 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3586:	85ca                	mv	a1,s2
    3588:	00003517          	auipc	a0,0x3
    358c:	6e850513          	addi	a0,a0,1768 # 6c70 <malloc+0x1ab2>
    3590:	377010ef          	jal	5106 <printf>
    exit(1);
    3594:	4505                	li	a0,1
    3596:	76e010ef          	jal	4d04 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    359a:	85ca                	mv	a1,s2
    359c:	00003517          	auipc	a0,0x3
    35a0:	6f450513          	addi	a0,a0,1780 # 6c90 <malloc+0x1ad2>
    35a4:	363010ef          	jal	5106 <printf>
    exit(1);
    35a8:	4505                	li	a0,1
    35aa:	75a010ef          	jal	4d04 <exit>
    printf("%s: write . succeeded!\n", s);
    35ae:	85ca                	mv	a1,s2
    35b0:	00003517          	auipc	a0,0x3
    35b4:	70850513          	addi	a0,a0,1800 # 6cb8 <malloc+0x1afa>
    35b8:	34f010ef          	jal	5106 <printf>
    exit(1);
    35bc:	4505                	li	a0,1
    35be:	746010ef          	jal	4d04 <exit>

00000000000035c2 <iref>:
{
    35c2:	715d                	addi	sp,sp,-80
    35c4:	e486                	sd	ra,72(sp)
    35c6:	e0a2                	sd	s0,64(sp)
    35c8:	fc26                	sd	s1,56(sp)
    35ca:	f84a                	sd	s2,48(sp)
    35cc:	f44e                	sd	s3,40(sp)
    35ce:	f052                	sd	s4,32(sp)
    35d0:	ec56                	sd	s5,24(sp)
    35d2:	e85a                	sd	s6,16(sp)
    35d4:	e45e                	sd	s7,8(sp)
    35d6:	0880                	addi	s0,sp,80
    35d8:	8baa                	mv	s7,a0
    35da:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    35de:	00003a97          	auipc	s5,0x3
    35e2:	6f2a8a93          	addi	s5,s5,1778 # 6cd0 <malloc+0x1b12>
    mkdir("");
    35e6:	00003497          	auipc	s1,0x3
    35ea:	1f248493          	addi	s1,s1,498 # 67d8 <malloc+0x161a>
    link("README", "");
    35ee:	00002b17          	auipc	s6,0x2
    35f2:	ed2b0b13          	addi	s6,s6,-302 # 54c0 <malloc+0x302>
    fd = open("", O_CREATE);
    35f6:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    35fa:	00003997          	auipc	s3,0x3
    35fe:	5ce98993          	addi	s3,s3,1486 # 6bc8 <malloc+0x1a0a>
    3602:	a835                	j	363e <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3604:	85de                	mv	a1,s7
    3606:	00003517          	auipc	a0,0x3
    360a:	6d250513          	addi	a0,a0,1746 # 6cd8 <malloc+0x1b1a>
    360e:	2f9010ef          	jal	5106 <printf>
      exit(1);
    3612:	4505                	li	a0,1
    3614:	6f0010ef          	jal	4d04 <exit>
      printf("%s: chdir irefd failed\n", s);
    3618:	85de                	mv	a1,s7
    361a:	00003517          	auipc	a0,0x3
    361e:	6d650513          	addi	a0,a0,1750 # 6cf0 <malloc+0x1b32>
    3622:	2e5010ef          	jal	5106 <printf>
      exit(1);
    3626:	4505                	li	a0,1
    3628:	6dc010ef          	jal	4d04 <exit>
      close(fd);
    362c:	700010ef          	jal	4d2c <close>
    3630:	a825                	j	3668 <iref+0xa6>
    unlink("xx");
    3632:	854e                	mv	a0,s3
    3634:	720010ef          	jal	4d54 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3638:	397d                	addiw	s2,s2,-1
    363a:	04090063          	beqz	s2,367a <iref+0xb8>
    if(mkdir("irefd") != 0){
    363e:	8556                	mv	a0,s5
    3640:	72c010ef          	jal	4d6c <mkdir>
    3644:	f161                	bnez	a0,3604 <iref+0x42>
    if(chdir("irefd") != 0){
    3646:	8556                	mv	a0,s5
    3648:	72c010ef          	jal	4d74 <chdir>
    364c:	f571                	bnez	a0,3618 <iref+0x56>
    mkdir("");
    364e:	8526                	mv	a0,s1
    3650:	71c010ef          	jal	4d6c <mkdir>
    link("README", "");
    3654:	85a6                	mv	a1,s1
    3656:	855a                	mv	a0,s6
    3658:	70c010ef          	jal	4d64 <link>
    fd = open("", O_CREATE);
    365c:	85d2                	mv	a1,s4
    365e:	8526                	mv	a0,s1
    3660:	6e4010ef          	jal	4d44 <open>
    if(fd >= 0)
    3664:	fc0554e3          	bgez	a0,362c <iref+0x6a>
    fd = open("xx", O_CREATE);
    3668:	85d2                	mv	a1,s4
    366a:	854e                	mv	a0,s3
    366c:	6d8010ef          	jal	4d44 <open>
    if(fd >= 0)
    3670:	fc0541e3          	bltz	a0,3632 <iref+0x70>
      close(fd);
    3674:	6b8010ef          	jal	4d2c <close>
    3678:	bf6d                	j	3632 <iref+0x70>
    367a:	03300493          	li	s1,51
    chdir("..");
    367e:	00003997          	auipc	s3,0x3
    3682:	e7298993          	addi	s3,s3,-398 # 64f0 <malloc+0x1332>
    unlink("irefd");
    3686:	00003917          	auipc	s2,0x3
    368a:	64a90913          	addi	s2,s2,1610 # 6cd0 <malloc+0x1b12>
    chdir("..");
    368e:	854e                	mv	a0,s3
    3690:	6e4010ef          	jal	4d74 <chdir>
    unlink("irefd");
    3694:	854a                	mv	a0,s2
    3696:	6be010ef          	jal	4d54 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    369a:	34fd                	addiw	s1,s1,-1
    369c:	f8ed                	bnez	s1,368e <iref+0xcc>
  chdir("/");
    369e:	00003517          	auipc	a0,0x3
    36a2:	dfa50513          	addi	a0,a0,-518 # 6498 <malloc+0x12da>
    36a6:	6ce010ef          	jal	4d74 <chdir>
}
    36aa:	60a6                	ld	ra,72(sp)
    36ac:	6406                	ld	s0,64(sp)
    36ae:	74e2                	ld	s1,56(sp)
    36b0:	7942                	ld	s2,48(sp)
    36b2:	79a2                	ld	s3,40(sp)
    36b4:	7a02                	ld	s4,32(sp)
    36b6:	6ae2                	ld	s5,24(sp)
    36b8:	6b42                	ld	s6,16(sp)
    36ba:	6ba2                	ld	s7,8(sp)
    36bc:	6161                	addi	sp,sp,80
    36be:	8082                	ret

00000000000036c0 <openiputtest>:
{
    36c0:	7179                	addi	sp,sp,-48
    36c2:	f406                	sd	ra,40(sp)
    36c4:	f022                	sd	s0,32(sp)
    36c6:	ec26                	sd	s1,24(sp)
    36c8:	1800                	addi	s0,sp,48
    36ca:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    36cc:	00003517          	auipc	a0,0x3
    36d0:	63c50513          	addi	a0,a0,1596 # 6d08 <malloc+0x1b4a>
    36d4:	698010ef          	jal	4d6c <mkdir>
    36d8:	02054a63          	bltz	a0,370c <openiputtest+0x4c>
  pid = fork();
    36dc:	620010ef          	jal	4cfc <fork>
  if(pid < 0){
    36e0:	04054063          	bltz	a0,3720 <openiputtest+0x60>
  if(pid == 0){
    36e4:	e939                	bnez	a0,373a <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    36e6:	4589                	li	a1,2
    36e8:	00003517          	auipc	a0,0x3
    36ec:	62050513          	addi	a0,a0,1568 # 6d08 <malloc+0x1b4a>
    36f0:	654010ef          	jal	4d44 <open>
    if(fd >= 0){
    36f4:	04054063          	bltz	a0,3734 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    36f8:	85a6                	mv	a1,s1
    36fa:	00003517          	auipc	a0,0x3
    36fe:	62e50513          	addi	a0,a0,1582 # 6d28 <malloc+0x1b6a>
    3702:	205010ef          	jal	5106 <printf>
      exit(1);
    3706:	4505                	li	a0,1
    3708:	5fc010ef          	jal	4d04 <exit>
    printf("%s: mkdir oidir failed\n", s);
    370c:	85a6                	mv	a1,s1
    370e:	00003517          	auipc	a0,0x3
    3712:	60250513          	addi	a0,a0,1538 # 6d10 <malloc+0x1b52>
    3716:	1f1010ef          	jal	5106 <printf>
    exit(1);
    371a:	4505                	li	a0,1
    371c:	5e8010ef          	jal	4d04 <exit>
    printf("%s: fork failed\n", s);
    3720:	85a6                	mv	a1,s1
    3722:	00002517          	auipc	a0,0x2
    3726:	45650513          	addi	a0,a0,1110 # 5b78 <malloc+0x9ba>
    372a:	1dd010ef          	jal	5106 <printf>
    exit(1);
    372e:	4505                	li	a0,1
    3730:	5d4010ef          	jal	4d04 <exit>
    exit(0);
    3734:	4501                	li	a0,0
    3736:	5ce010ef          	jal	4d04 <exit>
  sleep(1);
    373a:	4505                	li	a0,1
    373c:	658010ef          	jal	4d94 <sleep>
  if(unlink("oidir") != 0){
    3740:	00003517          	auipc	a0,0x3
    3744:	5c850513          	addi	a0,a0,1480 # 6d08 <malloc+0x1b4a>
    3748:	60c010ef          	jal	4d54 <unlink>
    374c:	c919                	beqz	a0,3762 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    374e:	85a6                	mv	a1,s1
    3750:	00002517          	auipc	a0,0x2
    3754:	61850513          	addi	a0,a0,1560 # 5d68 <malloc+0xbaa>
    3758:	1af010ef          	jal	5106 <printf>
    exit(1);
    375c:	4505                	li	a0,1
    375e:	5a6010ef          	jal	4d04 <exit>
  wait(&xstatus);
    3762:	fdc40513          	addi	a0,s0,-36
    3766:	5a6010ef          	jal	4d0c <wait>
  exit(xstatus);
    376a:	fdc42503          	lw	a0,-36(s0)
    376e:	596010ef          	jal	4d04 <exit>

0000000000003772 <forkforkfork>:
{
    3772:	1101                	addi	sp,sp,-32
    3774:	ec06                	sd	ra,24(sp)
    3776:	e822                	sd	s0,16(sp)
    3778:	e426                	sd	s1,8(sp)
    377a:	1000                	addi	s0,sp,32
    377c:	84aa                	mv	s1,a0
  unlink("stopforking");
    377e:	00003517          	auipc	a0,0x3
    3782:	5d250513          	addi	a0,a0,1490 # 6d50 <malloc+0x1b92>
    3786:	5ce010ef          	jal	4d54 <unlink>
  int pid = fork();
    378a:	572010ef          	jal	4cfc <fork>
  if(pid < 0){
    378e:	02054b63          	bltz	a0,37c4 <forkforkfork+0x52>
  if(pid == 0){
    3792:	c139                	beqz	a0,37d8 <forkforkfork+0x66>
  sleep(20); // two seconds
    3794:	4551                	li	a0,20
    3796:	5fe010ef          	jal	4d94 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    379a:	20200593          	li	a1,514
    379e:	00003517          	auipc	a0,0x3
    37a2:	5b250513          	addi	a0,a0,1458 # 6d50 <malloc+0x1b92>
    37a6:	59e010ef          	jal	4d44 <open>
    37aa:	582010ef          	jal	4d2c <close>
  wait(0);
    37ae:	4501                	li	a0,0
    37b0:	55c010ef          	jal	4d0c <wait>
  sleep(10); // one second
    37b4:	4529                	li	a0,10
    37b6:	5de010ef          	jal	4d94 <sleep>
}
    37ba:	60e2                	ld	ra,24(sp)
    37bc:	6442                	ld	s0,16(sp)
    37be:	64a2                	ld	s1,8(sp)
    37c0:	6105                	addi	sp,sp,32
    37c2:	8082                	ret
    printf("%s: fork failed", s);
    37c4:	85a6                	mv	a1,s1
    37c6:	00002517          	auipc	a0,0x2
    37ca:	57250513          	addi	a0,a0,1394 # 5d38 <malloc+0xb7a>
    37ce:	139010ef          	jal	5106 <printf>
    exit(1);
    37d2:	4505                	li	a0,1
    37d4:	530010ef          	jal	4d04 <exit>
      int fd = open("stopforking", 0);
    37d8:	00003497          	auipc	s1,0x3
    37dc:	57848493          	addi	s1,s1,1400 # 6d50 <malloc+0x1b92>
    37e0:	4581                	li	a1,0
    37e2:	8526                	mv	a0,s1
    37e4:	560010ef          	jal	4d44 <open>
      if(fd >= 0){
    37e8:	02055163          	bgez	a0,380a <forkforkfork+0x98>
      if(fork() < 0){
    37ec:	510010ef          	jal	4cfc <fork>
    37f0:	fe0558e3          	bgez	a0,37e0 <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    37f4:	20200593          	li	a1,514
    37f8:	00003517          	auipc	a0,0x3
    37fc:	55850513          	addi	a0,a0,1368 # 6d50 <malloc+0x1b92>
    3800:	544010ef          	jal	4d44 <open>
    3804:	528010ef          	jal	4d2c <close>
    3808:	bfe1                	j	37e0 <forkforkfork+0x6e>
        exit(0);
    380a:	4501                	li	a0,0
    380c:	4f8010ef          	jal	4d04 <exit>

0000000000003810 <killstatus>:
{
    3810:	715d                	addi	sp,sp,-80
    3812:	e486                	sd	ra,72(sp)
    3814:	e0a2                	sd	s0,64(sp)
    3816:	fc26                	sd	s1,56(sp)
    3818:	f84a                	sd	s2,48(sp)
    381a:	f44e                	sd	s3,40(sp)
    381c:	f052                	sd	s4,32(sp)
    381e:	ec56                	sd	s5,24(sp)
    3820:	e85a                	sd	s6,16(sp)
    3822:	0880                	addi	s0,sp,80
    3824:	8b2a                	mv	s6,a0
    3826:	06400913          	li	s2,100
    sleep(1);
    382a:	4a85                	li	s5,1
    wait(&xst);
    382c:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    3830:	59fd                	li	s3,-1
    int pid1 = fork();
    3832:	4ca010ef          	jal	4cfc <fork>
    3836:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3838:	02054663          	bltz	a0,3864 <killstatus+0x54>
    if(pid1 == 0){
    383c:	cd15                	beqz	a0,3878 <killstatus+0x68>
    sleep(1);
    383e:	8556                	mv	a0,s5
    3840:	554010ef          	jal	4d94 <sleep>
    kill(pid1);
    3844:	8526                	mv	a0,s1
    3846:	4ee010ef          	jal	4d34 <kill>
    wait(&xst);
    384a:	8552                	mv	a0,s4
    384c:	4c0010ef          	jal	4d0c <wait>
    if(xst != -1) {
    3850:	fbc42783          	lw	a5,-68(s0)
    3854:	03379563          	bne	a5,s3,387e <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
    3858:	397d                	addiw	s2,s2,-1
    385a:	fc091ce3          	bnez	s2,3832 <killstatus+0x22>
  exit(0);
    385e:	4501                	li	a0,0
    3860:	4a4010ef          	jal	4d04 <exit>
      printf("%s: fork failed\n", s);
    3864:	85da                	mv	a1,s6
    3866:	00002517          	auipc	a0,0x2
    386a:	31250513          	addi	a0,a0,786 # 5b78 <malloc+0x9ba>
    386e:	099010ef          	jal	5106 <printf>
      exit(1);
    3872:	4505                	li	a0,1
    3874:	490010ef          	jal	4d04 <exit>
        getpid();
    3878:	50c010ef          	jal	4d84 <getpid>
      while(1) {
    387c:	bff5                	j	3878 <killstatus+0x68>
       printf("%s: status should be -1\n", s);
    387e:	85da                	mv	a1,s6
    3880:	00003517          	auipc	a0,0x3
    3884:	4e050513          	addi	a0,a0,1248 # 6d60 <malloc+0x1ba2>
    3888:	07f010ef          	jal	5106 <printf>
       exit(1);
    388c:	4505                	li	a0,1
    388e:	476010ef          	jal	4d04 <exit>

0000000000003892 <preempt>:
{
    3892:	7139                	addi	sp,sp,-64
    3894:	fc06                	sd	ra,56(sp)
    3896:	f822                	sd	s0,48(sp)
    3898:	f426                	sd	s1,40(sp)
    389a:	f04a                	sd	s2,32(sp)
    389c:	ec4e                	sd	s3,24(sp)
    389e:	e852                	sd	s4,16(sp)
    38a0:	0080                	addi	s0,sp,64
    38a2:	892a                	mv	s2,a0
  pid1 = fork();
    38a4:	458010ef          	jal	4cfc <fork>
  if(pid1 < 0) {
    38a8:	00054563          	bltz	a0,38b2 <preempt+0x20>
    38ac:	84aa                	mv	s1,a0
  if(pid1 == 0)
    38ae:	ed01                	bnez	a0,38c6 <preempt+0x34>
    for(;;)
    38b0:	a001                	j	38b0 <preempt+0x1e>
    printf("%s: fork failed", s);
    38b2:	85ca                	mv	a1,s2
    38b4:	00002517          	auipc	a0,0x2
    38b8:	48450513          	addi	a0,a0,1156 # 5d38 <malloc+0xb7a>
    38bc:	04b010ef          	jal	5106 <printf>
    exit(1);
    38c0:	4505                	li	a0,1
    38c2:	442010ef          	jal	4d04 <exit>
  pid2 = fork();
    38c6:	436010ef          	jal	4cfc <fork>
    38ca:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    38cc:	00054463          	bltz	a0,38d4 <preempt+0x42>
  if(pid2 == 0)
    38d0:	ed01                	bnez	a0,38e8 <preempt+0x56>
    for(;;)
    38d2:	a001                	j	38d2 <preempt+0x40>
    printf("%s: fork failed\n", s);
    38d4:	85ca                	mv	a1,s2
    38d6:	00002517          	auipc	a0,0x2
    38da:	2a250513          	addi	a0,a0,674 # 5b78 <malloc+0x9ba>
    38de:	029010ef          	jal	5106 <printf>
    exit(1);
    38e2:	4505                	li	a0,1
    38e4:	420010ef          	jal	4d04 <exit>
  pipe(pfds);
    38e8:	fc840513          	addi	a0,s0,-56
    38ec:	428010ef          	jal	4d14 <pipe>
  pid3 = fork();
    38f0:	40c010ef          	jal	4cfc <fork>
    38f4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    38f6:	02054863          	bltz	a0,3926 <preempt+0x94>
  if(pid3 == 0){
    38fa:	e921                	bnez	a0,394a <preempt+0xb8>
    close(pfds[0]);
    38fc:	fc842503          	lw	a0,-56(s0)
    3900:	42c010ef          	jal	4d2c <close>
    if(write(pfds[1], "x", 1) != 1)
    3904:	4605                	li	a2,1
    3906:	00002597          	auipc	a1,0x2
    390a:	a5258593          	addi	a1,a1,-1454 # 5358 <malloc+0x19a>
    390e:	fcc42503          	lw	a0,-52(s0)
    3912:	412010ef          	jal	4d24 <write>
    3916:	4785                	li	a5,1
    3918:	02f51163          	bne	a0,a5,393a <preempt+0xa8>
    close(pfds[1]);
    391c:	fcc42503          	lw	a0,-52(s0)
    3920:	40c010ef          	jal	4d2c <close>
    for(;;)
    3924:	a001                	j	3924 <preempt+0x92>
     printf("%s: fork failed\n", s);
    3926:	85ca                	mv	a1,s2
    3928:	00002517          	auipc	a0,0x2
    392c:	25050513          	addi	a0,a0,592 # 5b78 <malloc+0x9ba>
    3930:	7d6010ef          	jal	5106 <printf>
     exit(1);
    3934:	4505                	li	a0,1
    3936:	3ce010ef          	jal	4d04 <exit>
      printf("%s: preempt write error", s);
    393a:	85ca                	mv	a1,s2
    393c:	00003517          	auipc	a0,0x3
    3940:	44450513          	addi	a0,a0,1092 # 6d80 <malloc+0x1bc2>
    3944:	7c2010ef          	jal	5106 <printf>
    3948:	bfd1                	j	391c <preempt+0x8a>
  close(pfds[1]);
    394a:	fcc42503          	lw	a0,-52(s0)
    394e:	3de010ef          	jal	4d2c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3952:	660d                	lui	a2,0x3
    3954:	00008597          	auipc	a1,0x8
    3958:	32458593          	addi	a1,a1,804 # bc78 <buf>
    395c:	fc842503          	lw	a0,-56(s0)
    3960:	3bc010ef          	jal	4d1c <read>
    3964:	4785                	li	a5,1
    3966:	02f50163          	beq	a0,a5,3988 <preempt+0xf6>
    printf("%s: preempt read error", s);
    396a:	85ca                	mv	a1,s2
    396c:	00003517          	auipc	a0,0x3
    3970:	42c50513          	addi	a0,a0,1068 # 6d98 <malloc+0x1bda>
    3974:	792010ef          	jal	5106 <printf>
}
    3978:	70e2                	ld	ra,56(sp)
    397a:	7442                	ld	s0,48(sp)
    397c:	74a2                	ld	s1,40(sp)
    397e:	7902                	ld	s2,32(sp)
    3980:	69e2                	ld	s3,24(sp)
    3982:	6a42                	ld	s4,16(sp)
    3984:	6121                	addi	sp,sp,64
    3986:	8082                	ret
  close(pfds[0]);
    3988:	fc842503          	lw	a0,-56(s0)
    398c:	3a0010ef          	jal	4d2c <close>
  printf("kill... ");
    3990:	00003517          	auipc	a0,0x3
    3994:	42050513          	addi	a0,a0,1056 # 6db0 <malloc+0x1bf2>
    3998:	76e010ef          	jal	5106 <printf>
  kill(pid1);
    399c:	8526                	mv	a0,s1
    399e:	396010ef          	jal	4d34 <kill>
  kill(pid2);
    39a2:	854e                	mv	a0,s3
    39a4:	390010ef          	jal	4d34 <kill>
  kill(pid3);
    39a8:	8552                	mv	a0,s4
    39aa:	38a010ef          	jal	4d34 <kill>
  printf("wait... ");
    39ae:	00003517          	auipc	a0,0x3
    39b2:	41250513          	addi	a0,a0,1042 # 6dc0 <malloc+0x1c02>
    39b6:	750010ef          	jal	5106 <printf>
  wait(0);
    39ba:	4501                	li	a0,0
    39bc:	350010ef          	jal	4d0c <wait>
  wait(0);
    39c0:	4501                	li	a0,0
    39c2:	34a010ef          	jal	4d0c <wait>
  wait(0);
    39c6:	4501                	li	a0,0
    39c8:	344010ef          	jal	4d0c <wait>
    39cc:	b775                	j	3978 <preempt+0xe6>

00000000000039ce <reparent>:
{
    39ce:	7179                	addi	sp,sp,-48
    39d0:	f406                	sd	ra,40(sp)
    39d2:	f022                	sd	s0,32(sp)
    39d4:	ec26                	sd	s1,24(sp)
    39d6:	e84a                	sd	s2,16(sp)
    39d8:	e44e                	sd	s3,8(sp)
    39da:	e052                	sd	s4,0(sp)
    39dc:	1800                	addi	s0,sp,48
    39de:	89aa                	mv	s3,a0
  int master_pid = getpid();
    39e0:	3a4010ef          	jal	4d84 <getpid>
    39e4:	8a2a                	mv	s4,a0
    39e6:	0c800913          	li	s2,200
    int pid = fork();
    39ea:	312010ef          	jal	4cfc <fork>
    39ee:	84aa                	mv	s1,a0
    if(pid < 0){
    39f0:	00054e63          	bltz	a0,3a0c <reparent+0x3e>
    if(pid){
    39f4:	c121                	beqz	a0,3a34 <reparent+0x66>
      if(wait(0) != pid){
    39f6:	4501                	li	a0,0
    39f8:	314010ef          	jal	4d0c <wait>
    39fc:	02951263          	bne	a0,s1,3a20 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3a00:	397d                	addiw	s2,s2,-1
    3a02:	fe0914e3          	bnez	s2,39ea <reparent+0x1c>
  exit(0);
    3a06:	4501                	li	a0,0
    3a08:	2fc010ef          	jal	4d04 <exit>
      printf("%s: fork failed\n", s);
    3a0c:	85ce                	mv	a1,s3
    3a0e:	00002517          	auipc	a0,0x2
    3a12:	16a50513          	addi	a0,a0,362 # 5b78 <malloc+0x9ba>
    3a16:	6f0010ef          	jal	5106 <printf>
      exit(1);
    3a1a:	4505                	li	a0,1
    3a1c:	2e8010ef          	jal	4d04 <exit>
        printf("%s: wait wrong pid\n", s);
    3a20:	85ce                	mv	a1,s3
    3a22:	00002517          	auipc	a0,0x2
    3a26:	2de50513          	addi	a0,a0,734 # 5d00 <malloc+0xb42>
    3a2a:	6dc010ef          	jal	5106 <printf>
        exit(1);
    3a2e:	4505                	li	a0,1
    3a30:	2d4010ef          	jal	4d04 <exit>
      int pid2 = fork();
    3a34:	2c8010ef          	jal	4cfc <fork>
      if(pid2 < 0){
    3a38:	00054563          	bltz	a0,3a42 <reparent+0x74>
      exit(0);
    3a3c:	4501                	li	a0,0
    3a3e:	2c6010ef          	jal	4d04 <exit>
        kill(master_pid);
    3a42:	8552                	mv	a0,s4
    3a44:	2f0010ef          	jal	4d34 <kill>
        exit(1);
    3a48:	4505                	li	a0,1
    3a4a:	2ba010ef          	jal	4d04 <exit>

0000000000003a4e <sbrkfail>:
{
    3a4e:	7175                	addi	sp,sp,-144
    3a50:	e506                	sd	ra,136(sp)
    3a52:	e122                	sd	s0,128(sp)
    3a54:	fca6                	sd	s1,120(sp)
    3a56:	f8ca                	sd	s2,112(sp)
    3a58:	f4ce                	sd	s3,104(sp)
    3a5a:	f0d2                	sd	s4,96(sp)
    3a5c:	ecd6                	sd	s5,88(sp)
    3a5e:	e8da                	sd	s6,80(sp)
    3a60:	e4de                	sd	s7,72(sp)
    3a62:	0900                	addi	s0,sp,144
    3a64:	8baa                	mv	s7,a0
  if(pipe(fds) != 0){
    3a66:	fa040513          	addi	a0,s0,-96
    3a6a:	2aa010ef          	jal	4d14 <pipe>
    3a6e:	e919                	bnez	a0,3a84 <sbrkfail+0x36>
    3a70:	f7040493          	addi	s1,s0,-144
    3a74:	f9840993          	addi	s3,s0,-104
    3a78:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3a7a:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3a7c:	f9f40b13          	addi	s6,s0,-97
    3a80:	4a85                	li	s5,1
    3a82:	a0a9                	j	3acc <sbrkfail+0x7e>
    printf("%s: pipe() failed\n", s);
    3a84:	85de                	mv	a1,s7
    3a86:	00002517          	auipc	a0,0x2
    3a8a:	1fa50513          	addi	a0,a0,506 # 5c80 <malloc+0xac2>
    3a8e:	678010ef          	jal	5106 <printf>
    exit(1);
    3a92:	4505                	li	a0,1
    3a94:	270010ef          	jal	4d04 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3a98:	2f4010ef          	jal	4d8c <sbrk>
    3a9c:	064007b7          	lui	a5,0x6400
    3aa0:	40a7853b          	subw	a0,a5,a0
    3aa4:	2e8010ef          	jal	4d8c <sbrk>
      write(fds[1], "x", 1);
    3aa8:	4605                	li	a2,1
    3aaa:	00002597          	auipc	a1,0x2
    3aae:	8ae58593          	addi	a1,a1,-1874 # 5358 <malloc+0x19a>
    3ab2:	fa442503          	lw	a0,-92(s0)
    3ab6:	26e010ef          	jal	4d24 <write>
      for(;;) sleep(1000);
    3aba:	3e800493          	li	s1,1000
    3abe:	8526                	mv	a0,s1
    3ac0:	2d4010ef          	jal	4d94 <sleep>
    3ac4:	bfed                	j	3abe <sbrkfail+0x70>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3ac6:	0911                	addi	s2,s2,4
    3ac8:	03390063          	beq	s2,s3,3ae8 <sbrkfail+0x9a>
    if((pids[i] = fork()) == 0){
    3acc:	230010ef          	jal	4cfc <fork>
    3ad0:	00a92023          	sw	a0,0(s2)
    3ad4:	d171                	beqz	a0,3a98 <sbrkfail+0x4a>
    if(pids[i] != -1)
    3ad6:	ff4508e3          	beq	a0,s4,3ac6 <sbrkfail+0x78>
      read(fds[0], &scratch, 1);
    3ada:	8656                	mv	a2,s5
    3adc:	85da                	mv	a1,s6
    3ade:	fa042503          	lw	a0,-96(s0)
    3ae2:	23a010ef          	jal	4d1c <read>
    3ae6:	b7c5                	j	3ac6 <sbrkfail+0x78>
  c = sbrk(PGSIZE);
    3ae8:	6505                	lui	a0,0x1
    3aea:	2a2010ef          	jal	4d8c <sbrk>
    3aee:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3af0:	597d                	li	s2,-1
    3af2:	a021                	j	3afa <sbrkfail+0xac>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3af4:	0491                	addi	s1,s1,4
    3af6:	01348b63          	beq	s1,s3,3b0c <sbrkfail+0xbe>
    if(pids[i] == -1)
    3afa:	4088                	lw	a0,0(s1)
    3afc:	ff250ce3          	beq	a0,s2,3af4 <sbrkfail+0xa6>
    kill(pids[i]);
    3b00:	234010ef          	jal	4d34 <kill>
    wait(0);
    3b04:	4501                	li	a0,0
    3b06:	206010ef          	jal	4d0c <wait>
    3b0a:	b7ed                	j	3af4 <sbrkfail+0xa6>
  if(c == (char*)0xffffffffffffffffL){
    3b0c:	57fd                	li	a5,-1
    3b0e:	02fa0f63          	beq	s4,a5,3b4c <sbrkfail+0xfe>
  pid = fork();
    3b12:	1ea010ef          	jal	4cfc <fork>
    3b16:	84aa                	mv	s1,a0
  if(pid < 0){
    3b18:	04054463          	bltz	a0,3b60 <sbrkfail+0x112>
  if(pid == 0){
    3b1c:	cd21                	beqz	a0,3b74 <sbrkfail+0x126>
  wait(&xstatus);
    3b1e:	fac40513          	addi	a0,s0,-84
    3b22:	1ea010ef          	jal	4d0c <wait>
  if(xstatus != -1 && xstatus != 2)
    3b26:	fac42783          	lw	a5,-84(s0)
    3b2a:	577d                	li	a4,-1
    3b2c:	00e78563          	beq	a5,a4,3b36 <sbrkfail+0xe8>
    3b30:	4709                	li	a4,2
    3b32:	06e79f63          	bne	a5,a4,3bb0 <sbrkfail+0x162>
}
    3b36:	60aa                	ld	ra,136(sp)
    3b38:	640a                	ld	s0,128(sp)
    3b3a:	74e6                	ld	s1,120(sp)
    3b3c:	7946                	ld	s2,112(sp)
    3b3e:	79a6                	ld	s3,104(sp)
    3b40:	7a06                	ld	s4,96(sp)
    3b42:	6ae6                	ld	s5,88(sp)
    3b44:	6b46                	ld	s6,80(sp)
    3b46:	6ba6                	ld	s7,72(sp)
    3b48:	6149                	addi	sp,sp,144
    3b4a:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3b4c:	85de                	mv	a1,s7
    3b4e:	00003517          	auipc	a0,0x3
    3b52:	28250513          	addi	a0,a0,642 # 6dd0 <malloc+0x1c12>
    3b56:	5b0010ef          	jal	5106 <printf>
    exit(1);
    3b5a:	4505                	li	a0,1
    3b5c:	1a8010ef          	jal	4d04 <exit>
    printf("%s: fork failed\n", s);
    3b60:	85de                	mv	a1,s7
    3b62:	00002517          	auipc	a0,0x2
    3b66:	01650513          	addi	a0,a0,22 # 5b78 <malloc+0x9ba>
    3b6a:	59c010ef          	jal	5106 <printf>
    exit(1);
    3b6e:	4505                	li	a0,1
    3b70:	194010ef          	jal	4d04 <exit>
    a = sbrk(0);
    3b74:	4501                	li	a0,0
    3b76:	216010ef          	jal	4d8c <sbrk>
    3b7a:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3b7c:	3e800537          	lui	a0,0x3e800
    3b80:	20c010ef          	jal	4d8c <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3b84:	87ca                	mv	a5,s2
    3b86:	3e800737          	lui	a4,0x3e800
    3b8a:	993a                	add	s2,s2,a4
    3b8c:	6705                	lui	a4,0x1
      n += *(a+i);
    3b8e:	0007c603          	lbu	a2,0(a5) # 6400000 <base+0x63f1388>
    3b92:	9e25                	addw	a2,a2,s1
    3b94:	84b2                	mv	s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3b96:	97ba                	add	a5,a5,a4
    3b98:	fef91be3          	bne	s2,a5,3b8e <sbrkfail+0x140>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3b9c:	85de                	mv	a1,s7
    3b9e:	00003517          	auipc	a0,0x3
    3ba2:	25250513          	addi	a0,a0,594 # 6df0 <malloc+0x1c32>
    3ba6:	560010ef          	jal	5106 <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	158010ef          	jal	4d04 <exit>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	152010ef          	jal	4d04 <exit>

0000000000003bb6 <mem>:
{
    3bb6:	7139                	addi	sp,sp,-64
    3bb8:	fc06                	sd	ra,56(sp)
    3bba:	f822                	sd	s0,48(sp)
    3bbc:	f426                	sd	s1,40(sp)
    3bbe:	f04a                	sd	s2,32(sp)
    3bc0:	ec4e                	sd	s3,24(sp)
    3bc2:	0080                	addi	s0,sp,64
    3bc4:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3bc6:	136010ef          	jal	4cfc <fork>
    m1 = 0;
    3bca:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3bcc:	6909                	lui	s2,0x2
    3bce:	71190913          	addi	s2,s2,1809 # 2711 <execout+0x21>
  if((pid = fork()) == 0){
    3bd2:	cd11                	beqz	a0,3bee <mem+0x38>
    wait(&xstatus);
    3bd4:	fcc40513          	addi	a0,s0,-52
    3bd8:	134010ef          	jal	4d0c <wait>
    if(xstatus == -1){
    3bdc:	fcc42503          	lw	a0,-52(s0)
    3be0:	57fd                	li	a5,-1
    3be2:	04f50363          	beq	a0,a5,3c28 <mem+0x72>
    exit(xstatus);
    3be6:	11e010ef          	jal	4d04 <exit>
      *(char**)m2 = m1;
    3bea:	e104                	sd	s1,0(a0)
      m1 = m2;
    3bec:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3bee:	854a                	mv	a0,s2
    3bf0:	5ce010ef          	jal	51be <malloc>
    3bf4:	f97d                	bnez	a0,3bea <mem+0x34>
    while(m1){
    3bf6:	c491                	beqz	s1,3c02 <mem+0x4c>
      m2 = *(char**)m1;
    3bf8:	8526                	mv	a0,s1
    3bfa:	6084                	ld	s1,0(s1)
      free(m1);
    3bfc:	53c010ef          	jal	5138 <free>
    while(m1){
    3c00:	fce5                	bnez	s1,3bf8 <mem+0x42>
    m1 = malloc(1024*20);
    3c02:	6515                	lui	a0,0x5
    3c04:	5ba010ef          	jal	51be <malloc>
    if(m1 == 0){
    3c08:	c511                	beqz	a0,3c14 <mem+0x5e>
    free(m1);
    3c0a:	52e010ef          	jal	5138 <free>
    exit(0);
    3c0e:	4501                	li	a0,0
    3c10:	0f4010ef          	jal	4d04 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3c14:	85ce                	mv	a1,s3
    3c16:	00003517          	auipc	a0,0x3
    3c1a:	20a50513          	addi	a0,a0,522 # 6e20 <malloc+0x1c62>
    3c1e:	4e8010ef          	jal	5106 <printf>
      exit(1);
    3c22:	4505                	li	a0,1
    3c24:	0e0010ef          	jal	4d04 <exit>
      exit(0);
    3c28:	4501                	li	a0,0
    3c2a:	0da010ef          	jal	4d04 <exit>

0000000000003c2e <sharedfd>:
{
    3c2e:	7119                	addi	sp,sp,-128
    3c30:	fc86                	sd	ra,120(sp)
    3c32:	f8a2                	sd	s0,112(sp)
    3c34:	e0da                	sd	s6,64(sp)
    3c36:	0100                	addi	s0,sp,128
    3c38:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3c3a:	00003517          	auipc	a0,0x3
    3c3e:	20650513          	addi	a0,a0,518 # 6e40 <malloc+0x1c82>
    3c42:	112010ef          	jal	4d54 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3c46:	20200593          	li	a1,514
    3c4a:	00003517          	auipc	a0,0x3
    3c4e:	1f650513          	addi	a0,a0,502 # 6e40 <malloc+0x1c82>
    3c52:	0f2010ef          	jal	4d44 <open>
  if(fd < 0){
    3c56:	04054b63          	bltz	a0,3cac <sharedfd+0x7e>
    3c5a:	f4a6                	sd	s1,104(sp)
    3c5c:	f0ca                	sd	s2,96(sp)
    3c5e:	ecce                	sd	s3,88(sp)
    3c60:	e8d2                	sd	s4,80(sp)
    3c62:	e4d6                	sd	s5,72(sp)
    3c64:	89aa                	mv	s3,a0
  pid = fork();
    3c66:	096010ef          	jal	4cfc <fork>
    3c6a:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3c6c:	07000593          	li	a1,112
    3c70:	e119                	bnez	a0,3c76 <sharedfd+0x48>
    3c72:	06300593          	li	a1,99
    3c76:	4629                	li	a2,10
    3c78:	f9040513          	addi	a0,s0,-112
    3c7c:	67b000ef          	jal	4af6 <memset>
    3c80:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3c84:	f9040a13          	addi	s4,s0,-112
    3c88:	4929                	li	s2,10
    3c8a:	864a                	mv	a2,s2
    3c8c:	85d2                	mv	a1,s4
    3c8e:	854e                	mv	a0,s3
    3c90:	094010ef          	jal	4d24 <write>
    3c94:	03251e63          	bne	a0,s2,3cd0 <sharedfd+0xa2>
  for(i = 0; i < N; i++){
    3c98:	34fd                	addiw	s1,s1,-1
    3c9a:	f8e5                	bnez	s1,3c8a <sharedfd+0x5c>
  if(pid == 0) {
    3c9c:	040a9763          	bnez	s5,3cea <sharedfd+0xbc>
    3ca0:	fc5e                	sd	s7,56(sp)
    3ca2:	f862                	sd	s8,48(sp)
    3ca4:	f466                	sd	s9,40(sp)
    exit(0);
    3ca6:	4501                	li	a0,0
    3ca8:	05c010ef          	jal	4d04 <exit>
    3cac:	f4a6                	sd	s1,104(sp)
    3cae:	f0ca                	sd	s2,96(sp)
    3cb0:	ecce                	sd	s3,88(sp)
    3cb2:	e8d2                	sd	s4,80(sp)
    3cb4:	e4d6                	sd	s5,72(sp)
    3cb6:	fc5e                	sd	s7,56(sp)
    3cb8:	f862                	sd	s8,48(sp)
    3cba:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3cbc:	85da                	mv	a1,s6
    3cbe:	00003517          	auipc	a0,0x3
    3cc2:	19250513          	addi	a0,a0,402 # 6e50 <malloc+0x1c92>
    3cc6:	440010ef          	jal	5106 <printf>
    exit(1);
    3cca:	4505                	li	a0,1
    3ccc:	038010ef          	jal	4d04 <exit>
    3cd0:	fc5e                	sd	s7,56(sp)
    3cd2:	f862                	sd	s8,48(sp)
    3cd4:	f466                	sd	s9,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3cd6:	85da                	mv	a1,s6
    3cd8:	00003517          	auipc	a0,0x3
    3cdc:	1a050513          	addi	a0,a0,416 # 6e78 <malloc+0x1cba>
    3ce0:	426010ef          	jal	5106 <printf>
      exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	01e010ef          	jal	4d04 <exit>
    wait(&xstatus);
    3cea:	f8c40513          	addi	a0,s0,-116
    3cee:	01e010ef          	jal	4d0c <wait>
    if(xstatus != 0)
    3cf2:	f8c42a03          	lw	s4,-116(s0)
    3cf6:	000a0863          	beqz	s4,3d06 <sharedfd+0xd8>
    3cfa:	fc5e                	sd	s7,56(sp)
    3cfc:	f862                	sd	s8,48(sp)
    3cfe:	f466                	sd	s9,40(sp)
      exit(xstatus);
    3d00:	8552                	mv	a0,s4
    3d02:	002010ef          	jal	4d04 <exit>
    3d06:	fc5e                	sd	s7,56(sp)
  close(fd);
    3d08:	854e                	mv	a0,s3
    3d0a:	022010ef          	jal	4d2c <close>
  fd = open("sharedfd", 0);
    3d0e:	4581                	li	a1,0
    3d10:	00003517          	auipc	a0,0x3
    3d14:	13050513          	addi	a0,a0,304 # 6e40 <malloc+0x1c82>
    3d18:	02c010ef          	jal	4d44 <open>
    3d1c:	8baa                	mv	s7,a0
  nc = np = 0;
    3d1e:	89d2                	mv	s3,s4
  if(fd < 0){
    3d20:	02054763          	bltz	a0,3d4e <sharedfd+0x120>
    3d24:	f862                	sd	s8,48(sp)
    3d26:	f466                	sd	s9,40(sp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d28:	f9040c93          	addi	s9,s0,-112
    3d2c:	4c29                	li	s8,10
    3d2e:	f9a40913          	addi	s2,s0,-102
      if(buf[i] == 'c')
    3d32:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3d36:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d3a:	8662                	mv	a2,s8
    3d3c:	85e6                	mv	a1,s9
    3d3e:	855e                	mv	a0,s7
    3d40:	7dd000ef          	jal	4d1c <read>
    3d44:	02a05d63          	blez	a0,3d7e <sharedfd+0x150>
    3d48:	f9040793          	addi	a5,s0,-112
    3d4c:	a00d                	j	3d6e <sharedfd+0x140>
    3d4e:	f862                	sd	s8,48(sp)
    3d50:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for reading\n", s);
    3d52:	85da                	mv	a1,s6
    3d54:	00003517          	auipc	a0,0x3
    3d58:	14450513          	addi	a0,a0,324 # 6e98 <malloc+0x1cda>
    3d5c:	3aa010ef          	jal	5106 <printf>
    exit(1);
    3d60:	4505                	li	a0,1
    3d62:	7a3000ef          	jal	4d04 <exit>
        nc++;
    3d66:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    3d68:	0785                	addi	a5,a5,1
    3d6a:	fd2788e3          	beq	a5,s2,3d3a <sharedfd+0x10c>
      if(buf[i] == 'c')
    3d6e:	0007c703          	lbu	a4,0(a5)
    3d72:	fe970ae3          	beq	a4,s1,3d66 <sharedfd+0x138>
      if(buf[i] == 'p')
    3d76:	ff5719e3          	bne	a4,s5,3d68 <sharedfd+0x13a>
        np++;
    3d7a:	2985                	addiw	s3,s3,1
    3d7c:	b7f5                	j	3d68 <sharedfd+0x13a>
  close(fd);
    3d7e:	855e                	mv	a0,s7
    3d80:	7ad000ef          	jal	4d2c <close>
  unlink("sharedfd");
    3d84:	00003517          	auipc	a0,0x3
    3d88:	0bc50513          	addi	a0,a0,188 # 6e40 <malloc+0x1c82>
    3d8c:	7c9000ef          	jal	4d54 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3d90:	6789                	lui	a5,0x2
    3d92:	71078793          	addi	a5,a5,1808 # 2710 <execout+0x20>
    3d96:	00fa1763          	bne	s4,a5,3da4 <sharedfd+0x176>
    3d9a:	6789                	lui	a5,0x2
    3d9c:	71078793          	addi	a5,a5,1808 # 2710 <execout+0x20>
    3da0:	00f98c63          	beq	s3,a5,3db8 <sharedfd+0x18a>
    printf("%s: nc/np test fails\n", s);
    3da4:	85da                	mv	a1,s6
    3da6:	00003517          	auipc	a0,0x3
    3daa:	11a50513          	addi	a0,a0,282 # 6ec0 <malloc+0x1d02>
    3dae:	358010ef          	jal	5106 <printf>
    exit(1);
    3db2:	4505                	li	a0,1
    3db4:	751000ef          	jal	4d04 <exit>
    exit(0);
    3db8:	4501                	li	a0,0
    3dba:	74b000ef          	jal	4d04 <exit>

0000000000003dbe <fourfiles>:
{
    3dbe:	7135                	addi	sp,sp,-160
    3dc0:	ed06                	sd	ra,152(sp)
    3dc2:	e922                	sd	s0,144(sp)
    3dc4:	e526                	sd	s1,136(sp)
    3dc6:	e14a                	sd	s2,128(sp)
    3dc8:	fcce                	sd	s3,120(sp)
    3dca:	f8d2                	sd	s4,112(sp)
    3dcc:	f4d6                	sd	s5,104(sp)
    3dce:	f0da                	sd	s6,96(sp)
    3dd0:	ecde                	sd	s7,88(sp)
    3dd2:	e8e2                	sd	s8,80(sp)
    3dd4:	e4e6                	sd	s9,72(sp)
    3dd6:	e0ea                	sd	s10,64(sp)
    3dd8:	fc6e                	sd	s11,56(sp)
    3dda:	1100                	addi	s0,sp,160
    3ddc:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3dde:	00003797          	auipc	a5,0x3
    3de2:	0fa78793          	addi	a5,a5,250 # 6ed8 <malloc+0x1d1a>
    3de6:	f6f43823          	sd	a5,-144(s0)
    3dea:	00003797          	auipc	a5,0x3
    3dee:	0f678793          	addi	a5,a5,246 # 6ee0 <malloc+0x1d22>
    3df2:	f6f43c23          	sd	a5,-136(s0)
    3df6:	00003797          	auipc	a5,0x3
    3dfa:	0f278793          	addi	a5,a5,242 # 6ee8 <malloc+0x1d2a>
    3dfe:	f8f43023          	sd	a5,-128(s0)
    3e02:	00003797          	auipc	a5,0x3
    3e06:	0ee78793          	addi	a5,a5,238 # 6ef0 <malloc+0x1d32>
    3e0a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3e0e:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3e12:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3e14:	4481                	li	s1,0
    3e16:	4a11                	li	s4,4
    fname = names[pi];
    3e18:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3e1c:	854e                	mv	a0,s3
    3e1e:	737000ef          	jal	4d54 <unlink>
    pid = fork();
    3e22:	6db000ef          	jal	4cfc <fork>
    if(pid < 0){
    3e26:	04054063          	bltz	a0,3e66 <fourfiles+0xa8>
    if(pid == 0){
    3e2a:	c921                	beqz	a0,3e7a <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    3e2c:	2485                	addiw	s1,s1,1
    3e2e:	0921                	addi	s2,s2,8
    3e30:	ff4494e3          	bne	s1,s4,3e18 <fourfiles+0x5a>
    3e34:	4491                	li	s1,4
    wait(&xstatus);
    3e36:	f6c40913          	addi	s2,s0,-148
    3e3a:	854a                	mv	a0,s2
    3e3c:	6d1000ef          	jal	4d0c <wait>
    if(xstatus != 0)
    3e40:	f6c42b03          	lw	s6,-148(s0)
    3e44:	0a0b1463          	bnez	s6,3eec <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3e48:	34fd                	addiw	s1,s1,-1
    3e4a:	f8e5                	bnez	s1,3e3a <fourfiles+0x7c>
    3e4c:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e50:	6a8d                	lui	s5,0x3
    3e52:	00008a17          	auipc	s4,0x8
    3e56:	e26a0a13          	addi	s4,s4,-474 # bc78 <buf>
    if(total != N*SZ){
    3e5a:	6d05                	lui	s10,0x1
    3e5c:	770d0d13          	addi	s10,s10,1904 # 1770 <exitwait+0x90>
  for(i = 0; i < NCHILD; i++){
    3e60:	03400d93          	li	s11,52
    3e64:	a86d                	j	3f1e <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3e66:	85e6                	mv	a1,s9
    3e68:	00002517          	auipc	a0,0x2
    3e6c:	d1050513          	addi	a0,a0,-752 # 5b78 <malloc+0x9ba>
    3e70:	296010ef          	jal	5106 <printf>
      exit(1);
    3e74:	4505                	li	a0,1
    3e76:	68f000ef          	jal	4d04 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3e7a:	20200593          	li	a1,514
    3e7e:	854e                	mv	a0,s3
    3e80:	6c5000ef          	jal	4d44 <open>
    3e84:	892a                	mv	s2,a0
      if(fd < 0){
    3e86:	04054063          	bltz	a0,3ec6 <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3e8a:	1f400613          	li	a2,500
    3e8e:	0304859b          	addiw	a1,s1,48
    3e92:	00008517          	auipc	a0,0x8
    3e96:	de650513          	addi	a0,a0,-538 # bc78 <buf>
    3e9a:	45d000ef          	jal	4af6 <memset>
    3e9e:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3ea0:	1f400993          	li	s3,500
    3ea4:	00008a17          	auipc	s4,0x8
    3ea8:	dd4a0a13          	addi	s4,s4,-556 # bc78 <buf>
    3eac:	864e                	mv	a2,s3
    3eae:	85d2                	mv	a1,s4
    3eb0:	854a                	mv	a0,s2
    3eb2:	673000ef          	jal	4d24 <write>
    3eb6:	85aa                	mv	a1,a0
    3eb8:	03351163          	bne	a0,s3,3eda <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3ebc:	34fd                	addiw	s1,s1,-1
    3ebe:	f4fd                	bnez	s1,3eac <fourfiles+0xee>
      exit(0);
    3ec0:	4501                	li	a0,0
    3ec2:	643000ef          	jal	4d04 <exit>
        printf("%s: create failed\n", s);
    3ec6:	85e6                	mv	a1,s9
    3ec8:	00002517          	auipc	a0,0x2
    3ecc:	d4850513          	addi	a0,a0,-696 # 5c10 <malloc+0xa52>
    3ed0:	236010ef          	jal	5106 <printf>
        exit(1);
    3ed4:	4505                	li	a0,1
    3ed6:	62f000ef          	jal	4d04 <exit>
          printf("write failed %d\n", n);
    3eda:	00003517          	auipc	a0,0x3
    3ede:	01e50513          	addi	a0,a0,30 # 6ef8 <malloc+0x1d3a>
    3ee2:	224010ef          	jal	5106 <printf>
          exit(1);
    3ee6:	4505                	li	a0,1
    3ee8:	61d000ef          	jal	4d04 <exit>
      exit(xstatus);
    3eec:	855a                	mv	a0,s6
    3eee:	617000ef          	jal	4d04 <exit>
          printf("%s: wrong char\n", s);
    3ef2:	85e6                	mv	a1,s9
    3ef4:	00003517          	auipc	a0,0x3
    3ef8:	01c50513          	addi	a0,a0,28 # 6f10 <malloc+0x1d52>
    3efc:	20a010ef          	jal	5106 <printf>
          exit(1);
    3f00:	4505                	li	a0,1
    3f02:	603000ef          	jal	4d04 <exit>
    close(fd);
    3f06:	854e                	mv	a0,s3
    3f08:	625000ef          	jal	4d2c <close>
    if(total != N*SZ){
    3f0c:	05a91863          	bne	s2,s10,3f5c <fourfiles+0x19e>
    unlink(fname);
    3f10:	8562                	mv	a0,s8
    3f12:	643000ef          	jal	4d54 <unlink>
  for(i = 0; i < NCHILD; i++){
    3f16:	0ba1                	addi	s7,s7,8
    3f18:	2485                	addiw	s1,s1,1
    3f1a:	05b48b63          	beq	s1,s11,3f70 <fourfiles+0x1b2>
    fname = names[i];
    3f1e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3f22:	4581                	li	a1,0
    3f24:	8562                	mv	a0,s8
    3f26:	61f000ef          	jal	4d44 <open>
    3f2a:	89aa                	mv	s3,a0
    total = 0;
    3f2c:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3f2e:	8656                	mv	a2,s5
    3f30:	85d2                	mv	a1,s4
    3f32:	854e                	mv	a0,s3
    3f34:	5e9000ef          	jal	4d1c <read>
    3f38:	fca057e3          	blez	a0,3f06 <fourfiles+0x148>
    3f3c:	00008797          	auipc	a5,0x8
    3f40:	d3c78793          	addi	a5,a5,-708 # bc78 <buf>
    3f44:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3f48:	0007c703          	lbu	a4,0(a5)
    3f4c:	fa9713e3          	bne	a4,s1,3ef2 <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3f50:	0785                	addi	a5,a5,1
    3f52:	fed79be3          	bne	a5,a3,3f48 <fourfiles+0x18a>
      total += n;
    3f56:	00a9093b          	addw	s2,s2,a0
    3f5a:	bfd1                	j	3f2e <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3f5c:	85ca                	mv	a1,s2
    3f5e:	00003517          	auipc	a0,0x3
    3f62:	fc250513          	addi	a0,a0,-62 # 6f20 <malloc+0x1d62>
    3f66:	1a0010ef          	jal	5106 <printf>
      exit(1);
    3f6a:	4505                	li	a0,1
    3f6c:	599000ef          	jal	4d04 <exit>
}
    3f70:	60ea                	ld	ra,152(sp)
    3f72:	644a                	ld	s0,144(sp)
    3f74:	64aa                	ld	s1,136(sp)
    3f76:	690a                	ld	s2,128(sp)
    3f78:	79e6                	ld	s3,120(sp)
    3f7a:	7a46                	ld	s4,112(sp)
    3f7c:	7aa6                	ld	s5,104(sp)
    3f7e:	7b06                	ld	s6,96(sp)
    3f80:	6be6                	ld	s7,88(sp)
    3f82:	6c46                	ld	s8,80(sp)
    3f84:	6ca6                	ld	s9,72(sp)
    3f86:	6d06                	ld	s10,64(sp)
    3f88:	7de2                	ld	s11,56(sp)
    3f8a:	610d                	addi	sp,sp,160
    3f8c:	8082                	ret

0000000000003f8e <concreate>:
{
    3f8e:	7171                	addi	sp,sp,-176
    3f90:	f506                	sd	ra,168(sp)
    3f92:	f122                	sd	s0,160(sp)
    3f94:	ed26                	sd	s1,152(sp)
    3f96:	e94a                	sd	s2,144(sp)
    3f98:	e54e                	sd	s3,136(sp)
    3f9a:	e152                	sd	s4,128(sp)
    3f9c:	fcd6                	sd	s5,120(sp)
    3f9e:	f8da                	sd	s6,112(sp)
    3fa0:	f4de                	sd	s7,104(sp)
    3fa2:	f0e2                	sd	s8,96(sp)
    3fa4:	ece6                	sd	s9,88(sp)
    3fa6:	e8ea                	sd	s10,80(sp)
    3fa8:	1900                	addi	s0,sp,176
    3faa:	8baa                	mv	s7,a0
  file[0] = 'C';
    3fac:	04300793          	li	a5,67
    3fb0:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3fb4:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    3fb8:	4901                	li	s2,0
    unlink(file);
    3fba:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    3fbe:	55555b37          	lui	s6,0x55555
    3fc2:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x555468de>
    3fc6:	4c05                	li	s8,1
      fd = open(file, O_CREATE | O_RDWR);
    3fc8:	20200c93          	li	s9,514
      link("C0", file);
    3fcc:	00003d17          	auipc	s10,0x3
    3fd0:	f6cd0d13          	addi	s10,s10,-148 # 6f38 <malloc+0x1d7a>
      wait(&xstatus);
    3fd4:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    3fd8:	02800a13          	li	s4,40
    3fdc:	ac2d                	j	4216 <concreate+0x288>
      link("C0", file);
    3fde:	85ce                	mv	a1,s3
    3fe0:	856a                	mv	a0,s10
    3fe2:	583000ef          	jal	4d64 <link>
    if(pid == 0) {
    3fe6:	ac31                	j	4202 <concreate+0x274>
    } else if(pid == 0 && (i % 5) == 1){
    3fe8:	666667b7          	lui	a5,0x66666
    3fec:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666579ef>
    3ff0:	02f907b3          	mul	a5,s2,a5
    3ff4:	9785                	srai	a5,a5,0x21
    3ff6:	41f9571b          	sraiw	a4,s2,0x1f
    3ffa:	9f99                	subw	a5,a5,a4
    3ffc:	0027971b          	slliw	a4,a5,0x2
    4000:	9fb9                	addw	a5,a5,a4
    4002:	40f9093b          	subw	s2,s2,a5
    4006:	4785                	li	a5,1
    4008:	02f90563          	beq	s2,a5,4032 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    400c:	20200593          	li	a1,514
    4010:	f9840513          	addi	a0,s0,-104
    4014:	531000ef          	jal	4d44 <open>
      if(fd < 0){
    4018:	1e055063          	bgez	a0,41f8 <concreate+0x26a>
        printf("concreate create %s failed\n", file);
    401c:	f9840593          	addi	a1,s0,-104
    4020:	00003517          	auipc	a0,0x3
    4024:	f2050513          	addi	a0,a0,-224 # 6f40 <malloc+0x1d82>
    4028:	0de010ef          	jal	5106 <printf>
        exit(1);
    402c:	4505                	li	a0,1
    402e:	4d7000ef          	jal	4d04 <exit>
      link("C0", file);
    4032:	f9840593          	addi	a1,s0,-104
    4036:	00003517          	auipc	a0,0x3
    403a:	f0250513          	addi	a0,a0,-254 # 6f38 <malloc+0x1d7a>
    403e:	527000ef          	jal	4d64 <link>
      exit(0);
    4042:	4501                	li	a0,0
    4044:	4c1000ef          	jal	4d04 <exit>
        exit(1);
    4048:	4505                	li	a0,1
    404a:	4bb000ef          	jal	4d04 <exit>
  memset(fa, 0, sizeof(fa));
    404e:	02800613          	li	a2,40
    4052:	4581                	li	a1,0
    4054:	f7040513          	addi	a0,s0,-144
    4058:	29f000ef          	jal	4af6 <memset>
  fd = open(".", 0);
    405c:	4581                	li	a1,0
    405e:	00002517          	auipc	a0,0x2
    4062:	97250513          	addi	a0,a0,-1678 # 59d0 <malloc+0x812>
    4066:	4df000ef          	jal	4d44 <open>
    406a:	892a                	mv	s2,a0
  n = 0;
    406c:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    406e:	f6040a13          	addi	s4,s0,-160
    4072:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4074:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    4078:	02700c13          	li	s8,39
      fa[i] = 1;
    407c:	4c85                	li	s9,1
  while(read(fd, &de, sizeof(de)) > 0){
    407e:	864e                	mv	a2,s3
    4080:	85d2                	mv	a1,s4
    4082:	854a                	mv	a0,s2
    4084:	499000ef          	jal	4d1c <read>
    4088:	06a05763          	blez	a0,40f6 <concreate+0x168>
    if(de.inum == 0)
    408c:	f6045783          	lhu	a5,-160(s0)
    4090:	d7fd                	beqz	a5,407e <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4092:	f6244783          	lbu	a5,-158(s0)
    4096:	ff5794e3          	bne	a5,s5,407e <concreate+0xf0>
    409a:	f6444783          	lbu	a5,-156(s0)
    409e:	f3e5                	bnez	a5,407e <concreate+0xf0>
      i = de.name[1] - '0';
    40a0:	f6344783          	lbu	a5,-157(s0)
    40a4:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    40a8:	00fc6f63          	bltu	s8,a5,40c6 <concreate+0x138>
      if(fa[i]){
    40ac:	fa078713          	addi	a4,a5,-96
    40b0:	9722                	add	a4,a4,s0
    40b2:	fd074703          	lbu	a4,-48(a4) # fd0 <bigdir+0xda>
    40b6:	e705                	bnez	a4,40de <concreate+0x150>
      fa[i] = 1;
    40b8:	fa078793          	addi	a5,a5,-96
    40bc:	97a2                	add	a5,a5,s0
    40be:	fd978823          	sb	s9,-48(a5)
      n++;
    40c2:	2b05                	addiw	s6,s6,1
    40c4:	bf6d                	j	407e <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    40c6:	f6240613          	addi	a2,s0,-158
    40ca:	85de                	mv	a1,s7
    40cc:	00003517          	auipc	a0,0x3
    40d0:	e9450513          	addi	a0,a0,-364 # 6f60 <malloc+0x1da2>
    40d4:	032010ef          	jal	5106 <printf>
        exit(1);
    40d8:	4505                	li	a0,1
    40da:	42b000ef          	jal	4d04 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    40de:	f6240613          	addi	a2,s0,-158
    40e2:	85de                	mv	a1,s7
    40e4:	00003517          	auipc	a0,0x3
    40e8:	e9c50513          	addi	a0,a0,-356 # 6f80 <malloc+0x1dc2>
    40ec:	01a010ef          	jal	5106 <printf>
        exit(1);
    40f0:	4505                	li	a0,1
    40f2:	413000ef          	jal	4d04 <exit>
  close(fd);
    40f6:	854a                	mv	a0,s2
    40f8:	435000ef          	jal	4d2c <close>
  if(n != N){
    40fc:	02800793          	li	a5,40
    4100:	00fb1b63          	bne	s6,a5,4116 <concreate+0x188>
    if(((i % 3) == 0 && pid == 0) ||
    4104:	55555a37          	lui	s4,0x55555
    4108:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x555468de>
      close(open(file, 0));
    410c:	f9840993          	addi	s3,s0,-104
    if(((i % 3) == 0 && pid == 0) ||
    4110:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4112:	8abe                	mv	s5,a5
    4114:	a049                	j	4196 <concreate+0x208>
    printf("%s: concreate not enough files in directory listing\n", s);
    4116:	85de                	mv	a1,s7
    4118:	00003517          	auipc	a0,0x3
    411c:	e9050513          	addi	a0,a0,-368 # 6fa8 <malloc+0x1dea>
    4120:	7e7000ef          	jal	5106 <printf>
    exit(1);
    4124:	4505                	li	a0,1
    4126:	3df000ef          	jal	4d04 <exit>
      printf("%s: fork failed\n", s);
    412a:	85de                	mv	a1,s7
    412c:	00002517          	auipc	a0,0x2
    4130:	a4c50513          	addi	a0,a0,-1460 # 5b78 <malloc+0x9ba>
    4134:	7d3000ef          	jal	5106 <printf>
      exit(1);
    4138:	4505                	li	a0,1
    413a:	3cb000ef          	jal	4d04 <exit>
      close(open(file, 0));
    413e:	4581                	li	a1,0
    4140:	854e                	mv	a0,s3
    4142:	403000ef          	jal	4d44 <open>
    4146:	3e7000ef          	jal	4d2c <close>
      close(open(file, 0));
    414a:	4581                	li	a1,0
    414c:	854e                	mv	a0,s3
    414e:	3f7000ef          	jal	4d44 <open>
    4152:	3db000ef          	jal	4d2c <close>
      close(open(file, 0));
    4156:	4581                	li	a1,0
    4158:	854e                	mv	a0,s3
    415a:	3eb000ef          	jal	4d44 <open>
    415e:	3cf000ef          	jal	4d2c <close>
      close(open(file, 0));
    4162:	4581                	li	a1,0
    4164:	854e                	mv	a0,s3
    4166:	3df000ef          	jal	4d44 <open>
    416a:	3c3000ef          	jal	4d2c <close>
      close(open(file, 0));
    416e:	4581                	li	a1,0
    4170:	854e                	mv	a0,s3
    4172:	3d3000ef          	jal	4d44 <open>
    4176:	3b7000ef          	jal	4d2c <close>
      close(open(file, 0));
    417a:	4581                	li	a1,0
    417c:	854e                	mv	a0,s3
    417e:	3c7000ef          	jal	4d44 <open>
    4182:	3ab000ef          	jal	4d2c <close>
    if(pid == 0)
    4186:	06090663          	beqz	s2,41f2 <concreate+0x264>
      wait(0);
    418a:	4501                	li	a0,0
    418c:	381000ef          	jal	4d0c <wait>
  for(i = 0; i < N; i++){
    4190:	2485                	addiw	s1,s1,1
    4192:	0d548163          	beq	s1,s5,4254 <concreate+0x2c6>
    file[1] = '0' + i;
    4196:	0304879b          	addiw	a5,s1,48
    419a:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    419e:	35f000ef          	jal	4cfc <fork>
    41a2:	892a                	mv	s2,a0
    if(pid < 0){
    41a4:	f80543e3          	bltz	a0,412a <concreate+0x19c>
    if(((i % 3) == 0 && pid == 0) ||
    41a8:	03448733          	mul	a4,s1,s4
    41ac:	9301                	srli	a4,a4,0x20
    41ae:	41f4d79b          	sraiw	a5,s1,0x1f
    41b2:	9f1d                	subw	a4,a4,a5
    41b4:	0017179b          	slliw	a5,a4,0x1
    41b8:	9fb9                	addw	a5,a5,a4
    41ba:	40f487bb          	subw	a5,s1,a5
    41be:	873e                	mv	a4,a5
    41c0:	8fc9                	or	a5,a5,a0
    41c2:	2781                	sext.w	a5,a5
    41c4:	dfad                	beqz	a5,413e <concreate+0x1b0>
    41c6:	01671363          	bne	a4,s6,41cc <concreate+0x23e>
       ((i % 3) == 1 && pid != 0)){
    41ca:	f935                	bnez	a0,413e <concreate+0x1b0>
      unlink(file);
    41cc:	854e                	mv	a0,s3
    41ce:	387000ef          	jal	4d54 <unlink>
      unlink(file);
    41d2:	854e                	mv	a0,s3
    41d4:	381000ef          	jal	4d54 <unlink>
      unlink(file);
    41d8:	854e                	mv	a0,s3
    41da:	37b000ef          	jal	4d54 <unlink>
      unlink(file);
    41de:	854e                	mv	a0,s3
    41e0:	375000ef          	jal	4d54 <unlink>
      unlink(file);
    41e4:	854e                	mv	a0,s3
    41e6:	36f000ef          	jal	4d54 <unlink>
      unlink(file);
    41ea:	854e                	mv	a0,s3
    41ec:	369000ef          	jal	4d54 <unlink>
    41f0:	bf59                	j	4186 <concreate+0x1f8>
      exit(0);
    41f2:	4501                	li	a0,0
    41f4:	311000ef          	jal	4d04 <exit>
      close(fd);
    41f8:	335000ef          	jal	4d2c <close>
    if(pid == 0) {
    41fc:	b599                	j	4042 <concreate+0xb4>
      close(fd);
    41fe:	32f000ef          	jal	4d2c <close>
      wait(&xstatus);
    4202:	8556                	mv	a0,s5
    4204:	309000ef          	jal	4d0c <wait>
      if(xstatus != 0)
    4208:	f5c42483          	lw	s1,-164(s0)
    420c:	e2049ee3          	bnez	s1,4048 <concreate+0xba>
  for(i = 0; i < N; i++){
    4210:	2905                	addiw	s2,s2,1
    4212:	e3490ee3          	beq	s2,s4,404e <concreate+0xc0>
    file[1] = '0' + i;
    4216:	0309079b          	addiw	a5,s2,48
    421a:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    421e:	854e                	mv	a0,s3
    4220:	335000ef          	jal	4d54 <unlink>
    pid = fork();
    4224:	2d9000ef          	jal	4cfc <fork>
    if(pid && (i % 3) == 1){
    4228:	dc0500e3          	beqz	a0,3fe8 <concreate+0x5a>
    422c:	036907b3          	mul	a5,s2,s6
    4230:	9381                	srli	a5,a5,0x20
    4232:	41f9571b          	sraiw	a4,s2,0x1f
    4236:	9f99                	subw	a5,a5,a4
    4238:	0017971b          	slliw	a4,a5,0x1
    423c:	9fb9                	addw	a5,a5,a4
    423e:	40f907bb          	subw	a5,s2,a5
    4242:	d9878ee3          	beq	a5,s8,3fde <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    4246:	85e6                	mv	a1,s9
    4248:	854e                	mv	a0,s3
    424a:	2fb000ef          	jal	4d44 <open>
      if(fd < 0){
    424e:	fa0558e3          	bgez	a0,41fe <concreate+0x270>
    4252:	b3e9                	j	401c <concreate+0x8e>
}
    4254:	70aa                	ld	ra,168(sp)
    4256:	740a                	ld	s0,160(sp)
    4258:	64ea                	ld	s1,152(sp)
    425a:	694a                	ld	s2,144(sp)
    425c:	69aa                	ld	s3,136(sp)
    425e:	6a0a                	ld	s4,128(sp)
    4260:	7ae6                	ld	s5,120(sp)
    4262:	7b46                	ld	s6,112(sp)
    4264:	7ba6                	ld	s7,104(sp)
    4266:	7c06                	ld	s8,96(sp)
    4268:	6ce6                	ld	s9,88(sp)
    426a:	6d46                	ld	s10,80(sp)
    426c:	614d                	addi	sp,sp,176
    426e:	8082                	ret

0000000000004270 <bigfile>:
{
    4270:	7139                	addi	sp,sp,-64
    4272:	fc06                	sd	ra,56(sp)
    4274:	f822                	sd	s0,48(sp)
    4276:	f426                	sd	s1,40(sp)
    4278:	f04a                	sd	s2,32(sp)
    427a:	ec4e                	sd	s3,24(sp)
    427c:	e852                	sd	s4,16(sp)
    427e:	e456                	sd	s5,8(sp)
    4280:	e05a                	sd	s6,0(sp)
    4282:	0080                	addi	s0,sp,64
    4284:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    4286:	00003517          	auipc	a0,0x3
    428a:	d5a50513          	addi	a0,a0,-678 # 6fe0 <malloc+0x1e22>
    428e:	2c7000ef          	jal	4d54 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4292:	20200593          	li	a1,514
    4296:	00003517          	auipc	a0,0x3
    429a:	d4a50513          	addi	a0,a0,-694 # 6fe0 <malloc+0x1e22>
    429e:	2a7000ef          	jal	4d44 <open>
  if(fd < 0){
    42a2:	08054a63          	bltz	a0,4336 <bigfile+0xc6>
    42a6:	8a2a                	mv	s4,a0
    42a8:	4481                	li	s1,0
    memset(buf, i, SZ);
    42aa:	25800913          	li	s2,600
    42ae:	00008997          	auipc	s3,0x8
    42b2:	9ca98993          	addi	s3,s3,-1590 # bc78 <buf>
  for(i = 0; i < N; i++){
    42b6:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    42b8:	864a                	mv	a2,s2
    42ba:	85a6                	mv	a1,s1
    42bc:	854e                	mv	a0,s3
    42be:	039000ef          	jal	4af6 <memset>
    if(write(fd, buf, SZ) != SZ){
    42c2:	864a                	mv	a2,s2
    42c4:	85ce                	mv	a1,s3
    42c6:	8552                	mv	a0,s4
    42c8:	25d000ef          	jal	4d24 <write>
    42cc:	07251f63          	bne	a0,s2,434a <bigfile+0xda>
  for(i = 0; i < N; i++){
    42d0:	2485                	addiw	s1,s1,1
    42d2:	ff5493e3          	bne	s1,s5,42b8 <bigfile+0x48>
  close(fd);
    42d6:	8552                	mv	a0,s4
    42d8:	255000ef          	jal	4d2c <close>
  fd = open("bigfile.dat", 0);
    42dc:	4581                	li	a1,0
    42de:	00003517          	auipc	a0,0x3
    42e2:	d0250513          	addi	a0,a0,-766 # 6fe0 <malloc+0x1e22>
    42e6:	25f000ef          	jal	4d44 <open>
    42ea:	8aaa                	mv	s5,a0
  total = 0;
    42ec:	4a01                	li	s4,0
  for(i = 0; ; i++){
    42ee:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    42f0:	12c00993          	li	s3,300
    42f4:	00008917          	auipc	s2,0x8
    42f8:	98490913          	addi	s2,s2,-1660 # bc78 <buf>
  if(fd < 0){
    42fc:	06054163          	bltz	a0,435e <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    4300:	864e                	mv	a2,s3
    4302:	85ca                	mv	a1,s2
    4304:	8556                	mv	a0,s5
    4306:	217000ef          	jal	4d1c <read>
    if(cc < 0){
    430a:	06054463          	bltz	a0,4372 <bigfile+0x102>
    if(cc == 0)
    430e:	c145                	beqz	a0,43ae <bigfile+0x13e>
    if(cc != SZ/2){
    4310:	07351b63          	bne	a0,s3,4386 <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4314:	01f4d79b          	srliw	a5,s1,0x1f
    4318:	9fa5                	addw	a5,a5,s1
    431a:	4017d79b          	sraiw	a5,a5,0x1
    431e:	00094703          	lbu	a4,0(s2)
    4322:	06f71c63          	bne	a4,a5,439a <bigfile+0x12a>
    4326:	12b94703          	lbu	a4,299(s2)
    432a:	06f71863          	bne	a4,a5,439a <bigfile+0x12a>
    total += cc;
    432e:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    4332:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4334:	b7f1                	j	4300 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    4336:	85da                	mv	a1,s6
    4338:	00003517          	auipc	a0,0x3
    433c:	cb850513          	addi	a0,a0,-840 # 6ff0 <malloc+0x1e32>
    4340:	5c7000ef          	jal	5106 <printf>
    exit(1);
    4344:	4505                	li	a0,1
    4346:	1bf000ef          	jal	4d04 <exit>
      printf("%s: write bigfile failed\n", s);
    434a:	85da                	mv	a1,s6
    434c:	00003517          	auipc	a0,0x3
    4350:	cc450513          	addi	a0,a0,-828 # 7010 <malloc+0x1e52>
    4354:	5b3000ef          	jal	5106 <printf>
      exit(1);
    4358:	4505                	li	a0,1
    435a:	1ab000ef          	jal	4d04 <exit>
    printf("%s: cannot open bigfile\n", s);
    435e:	85da                	mv	a1,s6
    4360:	00003517          	auipc	a0,0x3
    4364:	cd050513          	addi	a0,a0,-816 # 7030 <malloc+0x1e72>
    4368:	59f000ef          	jal	5106 <printf>
    exit(1);
    436c:	4505                	li	a0,1
    436e:	197000ef          	jal	4d04 <exit>
      printf("%s: read bigfile failed\n", s);
    4372:	85da                	mv	a1,s6
    4374:	00003517          	auipc	a0,0x3
    4378:	cdc50513          	addi	a0,a0,-804 # 7050 <malloc+0x1e92>
    437c:	58b000ef          	jal	5106 <printf>
      exit(1);
    4380:	4505                	li	a0,1
    4382:	183000ef          	jal	4d04 <exit>
      printf("%s: short read bigfile\n", s);
    4386:	85da                	mv	a1,s6
    4388:	00003517          	auipc	a0,0x3
    438c:	ce850513          	addi	a0,a0,-792 # 7070 <malloc+0x1eb2>
    4390:	577000ef          	jal	5106 <printf>
      exit(1);
    4394:	4505                	li	a0,1
    4396:	16f000ef          	jal	4d04 <exit>
      printf("%s: read bigfile wrong data\n", s);
    439a:	85da                	mv	a1,s6
    439c:	00003517          	auipc	a0,0x3
    43a0:	cec50513          	addi	a0,a0,-788 # 7088 <malloc+0x1eca>
    43a4:	563000ef          	jal	5106 <printf>
      exit(1);
    43a8:	4505                	li	a0,1
    43aa:	15b000ef          	jal	4d04 <exit>
  close(fd);
    43ae:	8556                	mv	a0,s5
    43b0:	17d000ef          	jal	4d2c <close>
  if(total != N*SZ){
    43b4:	678d                	lui	a5,0x3
    43b6:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x1e2>
    43ba:	02fa1263          	bne	s4,a5,43de <bigfile+0x16e>
  unlink("bigfile.dat");
    43be:	00003517          	auipc	a0,0x3
    43c2:	c2250513          	addi	a0,a0,-990 # 6fe0 <malloc+0x1e22>
    43c6:	18f000ef          	jal	4d54 <unlink>
}
    43ca:	70e2                	ld	ra,56(sp)
    43cc:	7442                	ld	s0,48(sp)
    43ce:	74a2                	ld	s1,40(sp)
    43d0:	7902                	ld	s2,32(sp)
    43d2:	69e2                	ld	s3,24(sp)
    43d4:	6a42                	ld	s4,16(sp)
    43d6:	6aa2                	ld	s5,8(sp)
    43d8:	6b02                	ld	s6,0(sp)
    43da:	6121                	addi	sp,sp,64
    43dc:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    43de:	85da                	mv	a1,s6
    43e0:	00003517          	auipc	a0,0x3
    43e4:	cc850513          	addi	a0,a0,-824 # 70a8 <malloc+0x1eea>
    43e8:	51f000ef          	jal	5106 <printf>
    exit(1);
    43ec:	4505                	li	a0,1
    43ee:	117000ef          	jal	4d04 <exit>

00000000000043f2 <bigargtest>:
{
    43f2:	7121                	addi	sp,sp,-448
    43f4:	ff06                	sd	ra,440(sp)
    43f6:	fb22                	sd	s0,432(sp)
    43f8:	f726                	sd	s1,424(sp)
    43fa:	0380                	addi	s0,sp,448
    43fc:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    43fe:	00003517          	auipc	a0,0x3
    4402:	cca50513          	addi	a0,a0,-822 # 70c8 <malloc+0x1f0a>
    4406:	14f000ef          	jal	4d54 <unlink>
  pid = fork();
    440a:	0f3000ef          	jal	4cfc <fork>
  if(pid == 0){
    440e:	c915                	beqz	a0,4442 <bigargtest+0x50>
  } else if(pid < 0){
    4410:	08054a63          	bltz	a0,44a4 <bigargtest+0xb2>
  wait(&xstatus);
    4414:	fdc40513          	addi	a0,s0,-36
    4418:	0f5000ef          	jal	4d0c <wait>
  if(xstatus != 0)
    441c:	fdc42503          	lw	a0,-36(s0)
    4420:	ed41                	bnez	a0,44b8 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    4422:	4581                	li	a1,0
    4424:	00003517          	auipc	a0,0x3
    4428:	ca450513          	addi	a0,a0,-860 # 70c8 <malloc+0x1f0a>
    442c:	119000ef          	jal	4d44 <open>
  if(fd < 0){
    4430:	08054663          	bltz	a0,44bc <bigargtest+0xca>
  close(fd);
    4434:	0f9000ef          	jal	4d2c <close>
}
    4438:	70fa                	ld	ra,440(sp)
    443a:	745a                	ld	s0,432(sp)
    443c:	74ba                	ld	s1,424(sp)
    443e:	6139                	addi	sp,sp,448
    4440:	8082                	ret
    memset(big, ' ', sizeof(big));
    4442:	19000613          	li	a2,400
    4446:	02000593          	li	a1,32
    444a:	e4840513          	addi	a0,s0,-440
    444e:	6a8000ef          	jal	4af6 <memset>
    big[sizeof(big)-1] = '\0';
    4452:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    4456:	00004797          	auipc	a5,0x4
    445a:	00a78793          	addi	a5,a5,10 # 8460 <args.1>
    445e:	00004697          	auipc	a3,0x4
    4462:	0fa68693          	addi	a3,a3,250 # 8558 <args.1+0xf8>
      args[i] = big;
    4466:	e4840713          	addi	a4,s0,-440
    446a:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    446c:	07a1                	addi	a5,a5,8
    446e:	fed79ee3          	bne	a5,a3,446a <bigargtest+0x78>
    args[MAXARG-1] = 0;
    4472:	00004597          	auipc	a1,0x4
    4476:	fee58593          	addi	a1,a1,-18 # 8460 <args.1>
    447a:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    447e:	00001517          	auipc	a0,0x1
    4482:	e6a50513          	addi	a0,a0,-406 # 52e8 <malloc+0x12a>
    4486:	0b7000ef          	jal	4d3c <exec>
    fd = open("bigarg-ok", O_CREATE);
    448a:	20000593          	li	a1,512
    448e:	00003517          	auipc	a0,0x3
    4492:	c3a50513          	addi	a0,a0,-966 # 70c8 <malloc+0x1f0a>
    4496:	0af000ef          	jal	4d44 <open>
    close(fd);
    449a:	093000ef          	jal	4d2c <close>
    exit(0);
    449e:	4501                	li	a0,0
    44a0:	065000ef          	jal	4d04 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    44a4:	85a6                	mv	a1,s1
    44a6:	00003517          	auipc	a0,0x3
    44aa:	c3250513          	addi	a0,a0,-974 # 70d8 <malloc+0x1f1a>
    44ae:	459000ef          	jal	5106 <printf>
    exit(1);
    44b2:	4505                	li	a0,1
    44b4:	051000ef          	jal	4d04 <exit>
    exit(xstatus);
    44b8:	04d000ef          	jal	4d04 <exit>
    printf("%s: bigarg test failed!\n", s);
    44bc:	85a6                	mv	a1,s1
    44be:	00003517          	auipc	a0,0x3
    44c2:	c3a50513          	addi	a0,a0,-966 # 70f8 <malloc+0x1f3a>
    44c6:	441000ef          	jal	5106 <printf>
    exit(1);
    44ca:	4505                	li	a0,1
    44cc:	039000ef          	jal	4d04 <exit>

00000000000044d0 <fsfull>:
{
    44d0:	7171                	addi	sp,sp,-176
    44d2:	f506                	sd	ra,168(sp)
    44d4:	f122                	sd	s0,160(sp)
    44d6:	ed26                	sd	s1,152(sp)
    44d8:	e94a                	sd	s2,144(sp)
    44da:	e54e                	sd	s3,136(sp)
    44dc:	e152                	sd	s4,128(sp)
    44de:	fcd6                	sd	s5,120(sp)
    44e0:	f8da                	sd	s6,112(sp)
    44e2:	f4de                	sd	s7,104(sp)
    44e4:	f0e2                	sd	s8,96(sp)
    44e6:	ece6                	sd	s9,88(sp)
    44e8:	e8ea                	sd	s10,80(sp)
    44ea:	e4ee                	sd	s11,72(sp)
    44ec:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    44ee:	00003517          	auipc	a0,0x3
    44f2:	c2a50513          	addi	a0,a0,-982 # 7118 <malloc+0x1f5a>
    44f6:	411000ef          	jal	5106 <printf>
  for(nfiles = 0; ; nfiles++){
    44fa:	4481                	li	s1,0
    name[0] = 'f';
    44fc:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4500:	10625cb7          	lui	s9,0x10625
    4504:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061615b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4508:	51eb8ab7          	lui	s5,0x51eb8
    450c:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea98a7>
    name[3] = '0' + (nfiles % 100) / 10;
    4510:	66666a37          	lui	s4,0x66666
    4514:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666579ef>
    printf("writing %s\n", name);
    4518:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    451c:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4520:	039487b3          	mul	a5,s1,s9
    4524:	9799                	srai	a5,a5,0x26
    4526:	41f4d69b          	sraiw	a3,s1,0x1f
    452a:	9f95                	subw	a5,a5,a3
    452c:	0307871b          	addiw	a4,a5,48
    4530:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4534:	3e800713          	li	a4,1000
    4538:	02f707bb          	mulw	a5,a4,a5
    453c:	40f487bb          	subw	a5,s1,a5
    4540:	03578733          	mul	a4,a5,s5
    4544:	9715                	srai	a4,a4,0x25
    4546:	41f7d79b          	sraiw	a5,a5,0x1f
    454a:	40f707bb          	subw	a5,a4,a5
    454e:	0307879b          	addiw	a5,a5,48
    4552:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4556:	035487b3          	mul	a5,s1,s5
    455a:	9795                	srai	a5,a5,0x25
    455c:	9f95                	subw	a5,a5,a3
    455e:	06400713          	li	a4,100
    4562:	02f707bb          	mulw	a5,a4,a5
    4566:	40f487bb          	subw	a5,s1,a5
    456a:	03478733          	mul	a4,a5,s4
    456e:	9709                	srai	a4,a4,0x22
    4570:	41f7d79b          	sraiw	a5,a5,0x1f
    4574:	40f707bb          	subw	a5,a4,a5
    4578:	0307879b          	addiw	a5,a5,48
    457c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4580:	03448733          	mul	a4,s1,s4
    4584:	9709                	srai	a4,a4,0x22
    4586:	9f15                	subw	a4,a4,a3
    4588:	0027179b          	slliw	a5,a4,0x2
    458c:	9fb9                	addw	a5,a5,a4
    458e:	0017979b          	slliw	a5,a5,0x1
    4592:	40f487bb          	subw	a5,s1,a5
    4596:	0307879b          	addiw	a5,a5,48
    459a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    459e:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    45a2:	85ea                	mv	a1,s10
    45a4:	00003517          	auipc	a0,0x3
    45a8:	b8450513          	addi	a0,a0,-1148 # 7128 <malloc+0x1f6a>
    45ac:	35b000ef          	jal	5106 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    45b0:	20200593          	li	a1,514
    45b4:	856a                	mv	a0,s10
    45b6:	78e000ef          	jal	4d44 <open>
    45ba:	892a                	mv	s2,a0
    if(fd < 0){
    45bc:	0e055863          	bgez	a0,46ac <fsfull+0x1dc>
      printf("open %s failed\n", name);
    45c0:	f5040593          	addi	a1,s0,-176
    45c4:	00003517          	auipc	a0,0x3
    45c8:	b7450513          	addi	a0,a0,-1164 # 7138 <malloc+0x1f7a>
    45cc:	33b000ef          	jal	5106 <printf>
    name[0] = 'f';
    45d0:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    45d4:	10625a37          	lui	s4,0x10625
    45d8:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061615b>
    name[2] = '0' + (nfiles % 1000) / 100;
    45dc:	3e800b93          	li	s7,1000
    45e0:	51eb89b7          	lui	s3,0x51eb8
    45e4:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea98a7>
    name[3] = '0' + (nfiles % 100) / 10;
    45e8:	06400b13          	li	s6,100
    45ec:	66666937          	lui	s2,0x66666
    45f0:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666579ef>
    unlink(name);
    45f4:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    45f8:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    45fc:	034487b3          	mul	a5,s1,s4
    4600:	9799                	srai	a5,a5,0x26
    4602:	41f4d69b          	sraiw	a3,s1,0x1f
    4606:	9f95                	subw	a5,a5,a3
    4608:	0307871b          	addiw	a4,a5,48
    460c:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4610:	02fb87bb          	mulw	a5,s7,a5
    4614:	40f487bb          	subw	a5,s1,a5
    4618:	03378733          	mul	a4,a5,s3
    461c:	9715                	srai	a4,a4,0x25
    461e:	41f7d79b          	sraiw	a5,a5,0x1f
    4622:	40f707bb          	subw	a5,a4,a5
    4626:	0307879b          	addiw	a5,a5,48
    462a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    462e:	033487b3          	mul	a5,s1,s3
    4632:	9795                	srai	a5,a5,0x25
    4634:	9f95                	subw	a5,a5,a3
    4636:	02fb07bb          	mulw	a5,s6,a5
    463a:	40f487bb          	subw	a5,s1,a5
    463e:	03278733          	mul	a4,a5,s2
    4642:	9709                	srai	a4,a4,0x22
    4644:	41f7d79b          	sraiw	a5,a5,0x1f
    4648:	40f707bb          	subw	a5,a4,a5
    464c:	0307879b          	addiw	a5,a5,48
    4650:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4654:	03248733          	mul	a4,s1,s2
    4658:	9709                	srai	a4,a4,0x22
    465a:	9f15                	subw	a4,a4,a3
    465c:	0027179b          	slliw	a5,a4,0x2
    4660:	9fb9                	addw	a5,a5,a4
    4662:	0017979b          	slliw	a5,a5,0x1
    4666:	40f487bb          	subw	a5,s1,a5
    466a:	0307879b          	addiw	a5,a5,48
    466e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4672:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4676:	8556                	mv	a0,s5
    4678:	6dc000ef          	jal	4d54 <unlink>
    nfiles--;
    467c:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    467e:	f604dde3          	bgez	s1,45f8 <fsfull+0x128>
  printf("fsfull test finished\n");
    4682:	00003517          	auipc	a0,0x3
    4686:	ad650513          	addi	a0,a0,-1322 # 7158 <malloc+0x1f9a>
    468a:	27d000ef          	jal	5106 <printf>
}
    468e:	70aa                	ld	ra,168(sp)
    4690:	740a                	ld	s0,160(sp)
    4692:	64ea                	ld	s1,152(sp)
    4694:	694a                	ld	s2,144(sp)
    4696:	69aa                	ld	s3,136(sp)
    4698:	6a0a                	ld	s4,128(sp)
    469a:	7ae6                	ld	s5,120(sp)
    469c:	7b46                	ld	s6,112(sp)
    469e:	7ba6                	ld	s7,104(sp)
    46a0:	7c06                	ld	s8,96(sp)
    46a2:	6ce6                	ld	s9,88(sp)
    46a4:	6d46                	ld	s10,80(sp)
    46a6:	6da6                	ld	s11,72(sp)
    46a8:	614d                	addi	sp,sp,176
    46aa:	8082                	ret
    int total = 0;
    46ac:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    46ae:	40000c13          	li	s8,1024
    46b2:	00007b97          	auipc	s7,0x7
    46b6:	5c6b8b93          	addi	s7,s7,1478 # bc78 <buf>
      if(cc < BSIZE)
    46ba:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    46be:	8662                	mv	a2,s8
    46c0:	85de                	mv	a1,s7
    46c2:	854a                	mv	a0,s2
    46c4:	660000ef          	jal	4d24 <write>
      if(cc < BSIZE)
    46c8:	00ab5563          	bge	s6,a0,46d2 <fsfull+0x202>
      total += cc;
    46cc:	00a989bb          	addw	s3,s3,a0
    while(1){
    46d0:	b7fd                	j	46be <fsfull+0x1ee>
    printf("wrote %d bytes\n", total);
    46d2:	85ce                	mv	a1,s3
    46d4:	00003517          	auipc	a0,0x3
    46d8:	a7450513          	addi	a0,a0,-1420 # 7148 <malloc+0x1f8a>
    46dc:	22b000ef          	jal	5106 <printf>
    close(fd);
    46e0:	854a                	mv	a0,s2
    46e2:	64a000ef          	jal	4d2c <close>
    if(total == 0)
    46e6:	ee0985e3          	beqz	s3,45d0 <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
    46ea:	2485                	addiw	s1,s1,1
    46ec:	bd05                	j	451c <fsfull+0x4c>

00000000000046ee <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    46ee:	7179                	addi	sp,sp,-48
    46f0:	f406                	sd	ra,40(sp)
    46f2:	f022                	sd	s0,32(sp)
    46f4:	ec26                	sd	s1,24(sp)
    46f6:	e84a                	sd	s2,16(sp)
    46f8:	1800                	addi	s0,sp,48
    46fa:	84aa                	mv	s1,a0
    46fc:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    46fe:	00003517          	auipc	a0,0x3
    4702:	a7250513          	addi	a0,a0,-1422 # 7170 <malloc+0x1fb2>
    4706:	201000ef          	jal	5106 <printf>
  if((pid = fork()) < 0) {
    470a:	5f2000ef          	jal	4cfc <fork>
    470e:	02054a63          	bltz	a0,4742 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4712:	c129                	beqz	a0,4754 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4714:	fdc40513          	addi	a0,s0,-36
    4718:	5f4000ef          	jal	4d0c <wait>
    if(xstatus != 0) 
    471c:	fdc42783          	lw	a5,-36(s0)
    4720:	cf9d                	beqz	a5,475e <run+0x70>
      printf("FAILED\n");
    4722:	00003517          	auipc	a0,0x3
    4726:	a7650513          	addi	a0,a0,-1418 # 7198 <malloc+0x1fda>
    472a:	1dd000ef          	jal	5106 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    472e:	fdc42503          	lw	a0,-36(s0)
  }
}
    4732:	00153513          	seqz	a0,a0
    4736:	70a2                	ld	ra,40(sp)
    4738:	7402                	ld	s0,32(sp)
    473a:	64e2                	ld	s1,24(sp)
    473c:	6942                	ld	s2,16(sp)
    473e:	6145                	addi	sp,sp,48
    4740:	8082                	ret
    printf("runtest: fork error\n");
    4742:	00003517          	auipc	a0,0x3
    4746:	a3e50513          	addi	a0,a0,-1474 # 7180 <malloc+0x1fc2>
    474a:	1bd000ef          	jal	5106 <printf>
    exit(1);
    474e:	4505                	li	a0,1
    4750:	5b4000ef          	jal	4d04 <exit>
    f(s);
    4754:	854a                	mv	a0,s2
    4756:	9482                	jalr	s1
    exit(0);
    4758:	4501                	li	a0,0
    475a:	5aa000ef          	jal	4d04 <exit>
      printf("OK\n");
    475e:	00003517          	auipc	a0,0x3
    4762:	a4250513          	addi	a0,a0,-1470 # 71a0 <malloc+0x1fe2>
    4766:	1a1000ef          	jal	5106 <printf>
    476a:	b7d1                	j	472e <run+0x40>

000000000000476c <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    476c:	7139                	addi	sp,sp,-64
    476e:	fc06                	sd	ra,56(sp)
    4770:	f822                	sd	s0,48(sp)
    4772:	f04a                	sd	s2,32(sp)
    4774:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    4776:	00853903          	ld	s2,8(a0)
    477a:	06090463          	beqz	s2,47e2 <runtests+0x76>
    477e:	f426                	sd	s1,40(sp)
    4780:	ec4e                	sd	s3,24(sp)
    4782:	e852                	sd	s4,16(sp)
    4784:	e456                	sd	s5,8(sp)
    4786:	84aa                	mv	s1,a0
    4788:	89ae                	mv	s3,a1
    478a:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    478c:	4a89                	li	s5,2
    478e:	a031                	j	479a <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    4790:	04c1                	addi	s1,s1,16
    4792:	0084b903          	ld	s2,8(s1)
    4796:	02090c63          	beqz	s2,47ce <runtests+0x62>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    479a:	00098763          	beqz	s3,47a8 <runtests+0x3c>
    479e:	85ce                	mv	a1,s3
    47a0:	854a                	mv	a0,s2
    47a2:	2f6000ef          	jal	4a98 <strcmp>
    47a6:	f56d                	bnez	a0,4790 <runtests+0x24>
      if(!run(t->f, t->s)){
    47a8:	85ca                	mv	a1,s2
    47aa:	6088                	ld	a0,0(s1)
    47ac:	f43ff0ef          	jal	46ee <run>
    47b0:	f165                	bnez	a0,4790 <runtests+0x24>
        if(continuous != 2){
    47b2:	fd5a0fe3          	beq	s4,s5,4790 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    47b6:	00003517          	auipc	a0,0x3
    47ba:	9f250513          	addi	a0,a0,-1550 # 71a8 <malloc+0x1fea>
    47be:	149000ef          	jal	5106 <printf>
          return 1;
    47c2:	4505                	li	a0,1
    47c4:	74a2                	ld	s1,40(sp)
    47c6:	69e2                	ld	s3,24(sp)
    47c8:	6a42                	ld	s4,16(sp)
    47ca:	6aa2                	ld	s5,8(sp)
    47cc:	a031                	j	47d8 <runtests+0x6c>
        }
      }
    }
  }
  return 0;
    47ce:	4501                	li	a0,0
    47d0:	74a2                	ld	s1,40(sp)
    47d2:	69e2                	ld	s3,24(sp)
    47d4:	6a42                	ld	s4,16(sp)
    47d6:	6aa2                	ld	s5,8(sp)
}
    47d8:	70e2                	ld	ra,56(sp)
    47da:	7442                	ld	s0,48(sp)
    47dc:	7902                	ld	s2,32(sp)
    47de:	6121                	addi	sp,sp,64
    47e0:	8082                	ret
  return 0;
    47e2:	4501                	li	a0,0
    47e4:	bfd5                	j	47d8 <runtests+0x6c>

00000000000047e6 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    47e6:	7139                	addi	sp,sp,-64
    47e8:	fc06                	sd	ra,56(sp)
    47ea:	f822                	sd	s0,48(sp)
    47ec:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    47ee:	fc840513          	addi	a0,s0,-56
    47f2:	522000ef          	jal	4d14 <pipe>
    47f6:	04054f63          	bltz	a0,4854 <countfree+0x6e>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    47fa:	502000ef          	jal	4cfc <fork>

  if(pid < 0){
    47fe:	06054863          	bltz	a0,486e <countfree+0x88>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4802:	e551                	bnez	a0,488e <countfree+0xa8>
    4804:	f426                	sd	s1,40(sp)
    4806:	f04a                	sd	s2,32(sp)
    4808:	ec4e                	sd	s3,24(sp)
    480a:	e852                	sd	s4,16(sp)
    close(fds[0]);
    480c:	fc842503          	lw	a0,-56(s0)
    4810:	51c000ef          	jal	4d2c <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    4814:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
    4816:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4818:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    481a:	00001a17          	auipc	s4,0x1
    481e:	b3ea0a13          	addi	s4,s4,-1218 # 5358 <malloc+0x19a>
      uint64 a = (uint64) sbrk(4096);
    4822:	854a                	mv	a0,s2
    4824:	568000ef          	jal	4d8c <sbrk>
      if(a == 0xffffffffffffffff){
    4828:	07350063          	beq	a0,s3,4888 <countfree+0xa2>
      *(char *)(a + 4096 - 1) = 1;
    482c:	954a                	add	a0,a0,s2
    482e:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
    4832:	8626                	mv	a2,s1
    4834:	85d2                	mv	a1,s4
    4836:	fcc42503          	lw	a0,-52(s0)
    483a:	4ea000ef          	jal	4d24 <write>
    483e:	fe9502e3          	beq	a0,s1,4822 <countfree+0x3c>
        printf("write() failed in countfree()\n");
    4842:	00003517          	auipc	a0,0x3
    4846:	9be50513          	addi	a0,a0,-1602 # 7200 <malloc+0x2042>
    484a:	0bd000ef          	jal	5106 <printf>
        exit(1);
    484e:	4505                	li	a0,1
    4850:	4b4000ef          	jal	4d04 <exit>
    4854:	f426                	sd	s1,40(sp)
    4856:	f04a                	sd	s2,32(sp)
    4858:	ec4e                	sd	s3,24(sp)
    485a:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
    485c:	00003517          	auipc	a0,0x3
    4860:	96450513          	addi	a0,a0,-1692 # 71c0 <malloc+0x2002>
    4864:	0a3000ef          	jal	5106 <printf>
    exit(1);
    4868:	4505                	li	a0,1
    486a:	49a000ef          	jal	4d04 <exit>
    486e:	f426                	sd	s1,40(sp)
    4870:	f04a                	sd	s2,32(sp)
    4872:	ec4e                	sd	s3,24(sp)
    4874:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
    4876:	00003517          	auipc	a0,0x3
    487a:	96a50513          	addi	a0,a0,-1686 # 71e0 <malloc+0x2022>
    487e:	089000ef          	jal	5106 <printf>
    exit(1);
    4882:	4505                	li	a0,1
    4884:	480000ef          	jal	4d04 <exit>
      }
    }

    exit(0);
    4888:	4501                	li	a0,0
    488a:	47a000ef          	jal	4d04 <exit>
    488e:	f426                	sd	s1,40(sp)
    4890:	f04a                	sd	s2,32(sp)
    4892:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
    4894:	fcc42503          	lw	a0,-52(s0)
    4898:	494000ef          	jal	4d2c <close>

  int n = 0;
    489c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    489e:	fc740993          	addi	s3,s0,-57
    48a2:	4905                	li	s2,1
    48a4:	864a                	mv	a2,s2
    48a6:	85ce                	mv	a1,s3
    48a8:	fc842503          	lw	a0,-56(s0)
    48ac:	470000ef          	jal	4d1c <read>
    if(cc < 0){
    48b0:	00054563          	bltz	a0,48ba <countfree+0xd4>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    48b4:	cd09                	beqz	a0,48ce <countfree+0xe8>
      break;
    n += 1;
    48b6:	2485                	addiw	s1,s1,1
  while(1){
    48b8:	b7f5                	j	48a4 <countfree+0xbe>
    48ba:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
    48bc:	00003517          	auipc	a0,0x3
    48c0:	96450513          	addi	a0,a0,-1692 # 7220 <malloc+0x2062>
    48c4:	043000ef          	jal	5106 <printf>
      exit(1);
    48c8:	4505                	li	a0,1
    48ca:	43a000ef          	jal	4d04 <exit>
  }

  close(fds[0]);
    48ce:	fc842503          	lw	a0,-56(s0)
    48d2:	45a000ef          	jal	4d2c <close>
  wait((int*)0);
    48d6:	4501                	li	a0,0
    48d8:	434000ef          	jal	4d0c <wait>
  
  return n;
}
    48dc:	8526                	mv	a0,s1
    48de:	74a2                	ld	s1,40(sp)
    48e0:	7902                	ld	s2,32(sp)
    48e2:	69e2                	ld	s3,24(sp)
    48e4:	70e2                	ld	ra,56(sp)
    48e6:	7442                	ld	s0,48(sp)
    48e8:	6121                	addi	sp,sp,64
    48ea:	8082                	ret

00000000000048ec <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    48ec:	711d                	addi	sp,sp,-96
    48ee:	ec86                	sd	ra,88(sp)
    48f0:	e8a2                	sd	s0,80(sp)
    48f2:	e4a6                	sd	s1,72(sp)
    48f4:	e0ca                	sd	s2,64(sp)
    48f6:	fc4e                	sd	s3,56(sp)
    48f8:	f852                	sd	s4,48(sp)
    48fa:	f456                	sd	s5,40(sp)
    48fc:	f05a                	sd	s6,32(sp)
    48fe:	ec5e                	sd	s7,24(sp)
    4900:	e862                	sd	s8,16(sp)
    4902:	e466                	sd	s9,8(sp)
    4904:	e06a                	sd	s10,0(sp)
    4906:	1080                	addi	s0,sp,96
    4908:	8aaa                	mv	s5,a0
    490a:	892e                	mv	s2,a1
    490c:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    490e:	00003b97          	auipc	s7,0x3
    4912:	932b8b93          	addi	s7,s7,-1742 # 7240 <malloc+0x2082>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    4916:	00003b17          	auipc	s6,0x3
    491a:	6fab0b13          	addi	s6,s6,1786 # 8010 <quicktests>
      if(continuous != 2) {
    491e:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    4920:	00004c17          	auipc	s8,0x4
    4924:	ac0c0c13          	addi	s8,s8,-1344 # 83e0 <slowtests>
        printf("usertests slow tests starting\n");
    4928:	00003d17          	auipc	s10,0x3
    492c:	930d0d13          	addi	s10,s10,-1744 # 7258 <malloc+0x209a>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4930:	00003c97          	auipc	s9,0x3
    4934:	948c8c93          	addi	s9,s9,-1720 # 7278 <malloc+0x20ba>
    4938:	a819                	j	494e <drivetests+0x62>
        printf("usertests slow tests starting\n");
    493a:	856a                	mv	a0,s10
    493c:	7ca000ef          	jal	5106 <printf>
    4940:	a80d                	j	4972 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    4942:	ea5ff0ef          	jal	47e6 <countfree>
    4946:	04954063          	blt	a0,s1,4986 <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    494a:	04090963          	beqz	s2,499c <drivetests+0xb0>
    printf("usertests starting\n");
    494e:	855e                	mv	a0,s7
    4950:	7b6000ef          	jal	5106 <printf>
    int free0 = countfree();
    4954:	e93ff0ef          	jal	47e6 <countfree>
    4958:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    495a:	864a                	mv	a2,s2
    495c:	85ce                	mv	a1,s3
    495e:	855a                	mv	a0,s6
    4960:	e0dff0ef          	jal	476c <runtests>
    4964:	c119                	beqz	a0,496a <drivetests+0x7e>
      if(continuous != 2) {
    4966:	03491963          	bne	s2,s4,4998 <drivetests+0xac>
    if(!quick) {
    496a:	fc0a9ce3          	bnez	s5,4942 <drivetests+0x56>
      if (justone == 0)
    496e:	fc0986e3          	beqz	s3,493a <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    4972:	864a                	mv	a2,s2
    4974:	85ce                	mv	a1,s3
    4976:	8562                	mv	a0,s8
    4978:	df5ff0ef          	jal	476c <runtests>
    497c:	d179                	beqz	a0,4942 <drivetests+0x56>
        if(continuous != 2) {
    497e:	fd4902e3          	beq	s2,s4,4942 <drivetests+0x56>
          return 1;
    4982:	4505                	li	a0,1
    4984:	a829                	j	499e <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4986:	8626                	mv	a2,s1
    4988:	85aa                	mv	a1,a0
    498a:	8566                	mv	a0,s9
    498c:	77a000ef          	jal	5106 <printf>
      if(continuous != 2) {
    4990:	fb490fe3          	beq	s2,s4,494e <drivetests+0x62>
        return 1;
    4994:	4505                	li	a0,1
    4996:	a021                	j	499e <drivetests+0xb2>
        return 1;
    4998:	4505                	li	a0,1
    499a:	a011                	j	499e <drivetests+0xb2>
  return 0;
    499c:	854a                	mv	a0,s2
}
    499e:	60e6                	ld	ra,88(sp)
    49a0:	6446                	ld	s0,80(sp)
    49a2:	64a6                	ld	s1,72(sp)
    49a4:	6906                	ld	s2,64(sp)
    49a6:	79e2                	ld	s3,56(sp)
    49a8:	7a42                	ld	s4,48(sp)
    49aa:	7aa2                	ld	s5,40(sp)
    49ac:	7b02                	ld	s6,32(sp)
    49ae:	6be2                	ld	s7,24(sp)
    49b0:	6c42                	ld	s8,16(sp)
    49b2:	6ca2                	ld	s9,8(sp)
    49b4:	6d02                	ld	s10,0(sp)
    49b6:	6125                	addi	sp,sp,96
    49b8:	8082                	ret

00000000000049ba <main>:

int
main(int argc, char *argv[])
{
    49ba:	1101                	addi	sp,sp,-32
    49bc:	ec06                	sd	ra,24(sp)
    49be:	e822                	sd	s0,16(sp)
    49c0:	e426                	sd	s1,8(sp)
    49c2:	e04a                	sd	s2,0(sp)
    49c4:	1000                	addi	s0,sp,32
    49c6:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    49c8:	4789                	li	a5,2
    49ca:	00f50f63          	beq	a0,a5,49e8 <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    49ce:	4785                	li	a5,1
    49d0:	06a7c063          	blt	a5,a0,4a30 <main+0x76>
  char *justone = 0;
    49d4:	4901                	li	s2,0
  int quick = 0;
    49d6:	4501                	li	a0,0
  int continuous = 0;
    49d8:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    49da:	864a                	mv	a2,s2
    49dc:	f11ff0ef          	jal	48ec <drivetests>
    49e0:	c935                	beqz	a0,4a54 <main+0x9a>
    exit(1);
    49e2:	4505                	li	a0,1
    49e4:	320000ef          	jal	4d04 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    49e8:	0085b903          	ld	s2,8(a1)
    49ec:	00003597          	auipc	a1,0x3
    49f0:	8bc58593          	addi	a1,a1,-1860 # 72a8 <malloc+0x20ea>
    49f4:	854a                	mv	a0,s2
    49f6:	0a2000ef          	jal	4a98 <strcmp>
    49fa:	85aa                	mv	a1,a0
    49fc:	c139                	beqz	a0,4a42 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    49fe:	00003597          	auipc	a1,0x3
    4a02:	8b258593          	addi	a1,a1,-1870 # 72b0 <malloc+0x20f2>
    4a06:	854a                	mv	a0,s2
    4a08:	090000ef          	jal	4a98 <strcmp>
    4a0c:	cd15                	beqz	a0,4a48 <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4a0e:	00003597          	auipc	a1,0x3
    4a12:	8aa58593          	addi	a1,a1,-1878 # 72b8 <malloc+0x20fa>
    4a16:	854a                	mv	a0,s2
    4a18:	080000ef          	jal	4a98 <strcmp>
    4a1c:	c90d                	beqz	a0,4a4e <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    4a1e:	00094703          	lbu	a4,0(s2) # 1000 <bigdir+0x10a>
    4a22:	02d00793          	li	a5,45
    4a26:	00f70563          	beq	a4,a5,4a30 <main+0x76>
  int quick = 0;
    4a2a:	4501                	li	a0,0
  int continuous = 0;
    4a2c:	4581                	li	a1,0
    4a2e:	b775                	j	49da <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4a30:	00003517          	auipc	a0,0x3
    4a34:	89050513          	addi	a0,a0,-1904 # 72c0 <malloc+0x2102>
    4a38:	6ce000ef          	jal	5106 <printf>
    exit(1);
    4a3c:	4505                	li	a0,1
    4a3e:	2c6000ef          	jal	4d04 <exit>
  char *justone = 0;
    4a42:	4901                	li	s2,0
    quick = 1;
    4a44:	4505                	li	a0,1
    4a46:	bf51                	j	49da <main+0x20>
  char *justone = 0;
    4a48:	4901                	li	s2,0
    continuous = 1;
    4a4a:	4585                	li	a1,1
    4a4c:	b779                	j	49da <main+0x20>
    continuous = 2;
    4a4e:	85a6                	mv	a1,s1
  char *justone = 0;
    4a50:	4901                	li	s2,0
    4a52:	b761                	j	49da <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4a54:	00003517          	auipc	a0,0x3
    4a58:	89c50513          	addi	a0,a0,-1892 # 72f0 <malloc+0x2132>
    4a5c:	6aa000ef          	jal	5106 <printf>
  exit(0);
    4a60:	4501                	li	a0,0
    4a62:	2a2000ef          	jal	4d04 <exit>

0000000000004a66 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    4a66:	1141                	addi	sp,sp,-16
    4a68:	e406                	sd	ra,8(sp)
    4a6a:	e022                	sd	s0,0(sp)
    4a6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
    4a6e:	f4dff0ef          	jal	49ba <main>
  exit(0);
    4a72:	4501                	li	a0,0
    4a74:	290000ef          	jal	4d04 <exit>

0000000000004a78 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4a78:	1141                	addi	sp,sp,-16
    4a7a:	e406                	sd	ra,8(sp)
    4a7c:	e022                	sd	s0,0(sp)
    4a7e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4a80:	87aa                	mv	a5,a0
    4a82:	0585                	addi	a1,a1,1
    4a84:	0785                	addi	a5,a5,1
    4a86:	fff5c703          	lbu	a4,-1(a1)
    4a8a:	fee78fa3          	sb	a4,-1(a5)
    4a8e:	fb75                	bnez	a4,4a82 <strcpy+0xa>
    ;
  return os;
}
    4a90:	60a2                	ld	ra,8(sp)
    4a92:	6402                	ld	s0,0(sp)
    4a94:	0141                	addi	sp,sp,16
    4a96:	8082                	ret

0000000000004a98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4a98:	1141                	addi	sp,sp,-16
    4a9a:	e406                	sd	ra,8(sp)
    4a9c:	e022                	sd	s0,0(sp)
    4a9e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4aa0:	00054783          	lbu	a5,0(a0)
    4aa4:	cb91                	beqz	a5,4ab8 <strcmp+0x20>
    4aa6:	0005c703          	lbu	a4,0(a1)
    4aaa:	00f71763          	bne	a4,a5,4ab8 <strcmp+0x20>
    p++, q++;
    4aae:	0505                	addi	a0,a0,1
    4ab0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4ab2:	00054783          	lbu	a5,0(a0)
    4ab6:	fbe5                	bnez	a5,4aa6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4ab8:	0005c503          	lbu	a0,0(a1)
}
    4abc:	40a7853b          	subw	a0,a5,a0
    4ac0:	60a2                	ld	ra,8(sp)
    4ac2:	6402                	ld	s0,0(sp)
    4ac4:	0141                	addi	sp,sp,16
    4ac6:	8082                	ret

0000000000004ac8 <strlen>:

uint
strlen(const char *s)
{
    4ac8:	1141                	addi	sp,sp,-16
    4aca:	e406                	sd	ra,8(sp)
    4acc:	e022                	sd	s0,0(sp)
    4ace:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4ad0:	00054783          	lbu	a5,0(a0)
    4ad4:	cf99                	beqz	a5,4af2 <strlen+0x2a>
    4ad6:	0505                	addi	a0,a0,1
    4ad8:	87aa                	mv	a5,a0
    4ada:	86be                	mv	a3,a5
    4adc:	0785                	addi	a5,a5,1
    4ade:	fff7c703          	lbu	a4,-1(a5)
    4ae2:	ff65                	bnez	a4,4ada <strlen+0x12>
    4ae4:	40a6853b          	subw	a0,a3,a0
    4ae8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4aea:	60a2                	ld	ra,8(sp)
    4aec:	6402                	ld	s0,0(sp)
    4aee:	0141                	addi	sp,sp,16
    4af0:	8082                	ret
  for(n = 0; s[n]; n++)
    4af2:	4501                	li	a0,0
    4af4:	bfdd                	j	4aea <strlen+0x22>

0000000000004af6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4af6:	1141                	addi	sp,sp,-16
    4af8:	e406                	sd	ra,8(sp)
    4afa:	e022                	sd	s0,0(sp)
    4afc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4afe:	ca19                	beqz	a2,4b14 <memset+0x1e>
    4b00:	87aa                	mv	a5,a0
    4b02:	1602                	slli	a2,a2,0x20
    4b04:	9201                	srli	a2,a2,0x20
    4b06:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4b0a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4b0e:	0785                	addi	a5,a5,1
    4b10:	fee79de3          	bne	a5,a4,4b0a <memset+0x14>
  }
  return dst;
}
    4b14:	60a2                	ld	ra,8(sp)
    4b16:	6402                	ld	s0,0(sp)
    4b18:	0141                	addi	sp,sp,16
    4b1a:	8082                	ret

0000000000004b1c <strchr>:

char*
strchr(const char *s, char c)
{
    4b1c:	1141                	addi	sp,sp,-16
    4b1e:	e406                	sd	ra,8(sp)
    4b20:	e022                	sd	s0,0(sp)
    4b22:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4b24:	00054783          	lbu	a5,0(a0)
    4b28:	cf81                	beqz	a5,4b40 <strchr+0x24>
    if(*s == c)
    4b2a:	00f58763          	beq	a1,a5,4b38 <strchr+0x1c>
  for(; *s; s++)
    4b2e:	0505                	addi	a0,a0,1
    4b30:	00054783          	lbu	a5,0(a0)
    4b34:	fbfd                	bnez	a5,4b2a <strchr+0xe>
      return (char*)s;
  return 0;
    4b36:	4501                	li	a0,0
}
    4b38:	60a2                	ld	ra,8(sp)
    4b3a:	6402                	ld	s0,0(sp)
    4b3c:	0141                	addi	sp,sp,16
    4b3e:	8082                	ret
  return 0;
    4b40:	4501                	li	a0,0
    4b42:	bfdd                	j	4b38 <strchr+0x1c>

0000000000004b44 <gets>:

char*
gets(char *buf, int max)
{
    4b44:	7159                	addi	sp,sp,-112
    4b46:	f486                	sd	ra,104(sp)
    4b48:	f0a2                	sd	s0,96(sp)
    4b4a:	eca6                	sd	s1,88(sp)
    4b4c:	e8ca                	sd	s2,80(sp)
    4b4e:	e4ce                	sd	s3,72(sp)
    4b50:	e0d2                	sd	s4,64(sp)
    4b52:	fc56                	sd	s5,56(sp)
    4b54:	f85a                	sd	s6,48(sp)
    4b56:	f45e                	sd	s7,40(sp)
    4b58:	f062                	sd	s8,32(sp)
    4b5a:	ec66                	sd	s9,24(sp)
    4b5c:	e86a                	sd	s10,16(sp)
    4b5e:	1880                	addi	s0,sp,112
    4b60:	8caa                	mv	s9,a0
    4b62:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4b64:	892a                	mv	s2,a0
    4b66:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4b68:	f9f40b13          	addi	s6,s0,-97
    4b6c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4b6e:	4ba9                	li	s7,10
    4b70:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
    4b72:	8d26                	mv	s10,s1
    4b74:	0014899b          	addiw	s3,s1,1
    4b78:	84ce                	mv	s1,s3
    4b7a:	0349d563          	bge	s3,s4,4ba4 <gets+0x60>
    cc = read(0, &c, 1);
    4b7e:	8656                	mv	a2,s5
    4b80:	85da                	mv	a1,s6
    4b82:	4501                	li	a0,0
    4b84:	198000ef          	jal	4d1c <read>
    if(cc < 1)
    4b88:	00a05e63          	blez	a0,4ba4 <gets+0x60>
    buf[i++] = c;
    4b8c:	f9f44783          	lbu	a5,-97(s0)
    4b90:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4b94:	01778763          	beq	a5,s7,4ba2 <gets+0x5e>
    4b98:	0905                	addi	s2,s2,1
    4b9a:	fd879ce3          	bne	a5,s8,4b72 <gets+0x2e>
    buf[i++] = c;
    4b9e:	8d4e                	mv	s10,s3
    4ba0:	a011                	j	4ba4 <gets+0x60>
    4ba2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
    4ba4:	9d66                	add	s10,s10,s9
    4ba6:	000d0023          	sb	zero,0(s10)
  return buf;
}
    4baa:	8566                	mv	a0,s9
    4bac:	70a6                	ld	ra,104(sp)
    4bae:	7406                	ld	s0,96(sp)
    4bb0:	64e6                	ld	s1,88(sp)
    4bb2:	6946                	ld	s2,80(sp)
    4bb4:	69a6                	ld	s3,72(sp)
    4bb6:	6a06                	ld	s4,64(sp)
    4bb8:	7ae2                	ld	s5,56(sp)
    4bba:	7b42                	ld	s6,48(sp)
    4bbc:	7ba2                	ld	s7,40(sp)
    4bbe:	7c02                	ld	s8,32(sp)
    4bc0:	6ce2                	ld	s9,24(sp)
    4bc2:	6d42                	ld	s10,16(sp)
    4bc4:	6165                	addi	sp,sp,112
    4bc6:	8082                	ret

0000000000004bc8 <stat>:

int
stat(const char *n, struct stat *st)
{
    4bc8:	1101                	addi	sp,sp,-32
    4bca:	ec06                	sd	ra,24(sp)
    4bcc:	e822                	sd	s0,16(sp)
    4bce:	e04a                	sd	s2,0(sp)
    4bd0:	1000                	addi	s0,sp,32
    4bd2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4bd4:	4581                	li	a1,0
    4bd6:	16e000ef          	jal	4d44 <open>
  if(fd < 0)
    4bda:	02054263          	bltz	a0,4bfe <stat+0x36>
    4bde:	e426                	sd	s1,8(sp)
    4be0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4be2:	85ca                	mv	a1,s2
    4be4:	178000ef          	jal	4d5c <fstat>
    4be8:	892a                	mv	s2,a0
  close(fd);
    4bea:	8526                	mv	a0,s1
    4bec:	140000ef          	jal	4d2c <close>
  return r;
    4bf0:	64a2                	ld	s1,8(sp)
}
    4bf2:	854a                	mv	a0,s2
    4bf4:	60e2                	ld	ra,24(sp)
    4bf6:	6442                	ld	s0,16(sp)
    4bf8:	6902                	ld	s2,0(sp)
    4bfa:	6105                	addi	sp,sp,32
    4bfc:	8082                	ret
    return -1;
    4bfe:	597d                	li	s2,-1
    4c00:	bfcd                	j	4bf2 <stat+0x2a>

0000000000004c02 <atoi>:

int
atoi(const char *s)
{
    4c02:	1141                	addi	sp,sp,-16
    4c04:	e406                	sd	ra,8(sp)
    4c06:	e022                	sd	s0,0(sp)
    4c08:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4c0a:	00054683          	lbu	a3,0(a0)
    4c0e:	fd06879b          	addiw	a5,a3,-48
    4c12:	0ff7f793          	zext.b	a5,a5
    4c16:	4625                	li	a2,9
    4c18:	02f66963          	bltu	a2,a5,4c4a <atoi+0x48>
    4c1c:	872a                	mv	a4,a0
  n = 0;
    4c1e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4c20:	0705                	addi	a4,a4,1
    4c22:	0025179b          	slliw	a5,a0,0x2
    4c26:	9fa9                	addw	a5,a5,a0
    4c28:	0017979b          	slliw	a5,a5,0x1
    4c2c:	9fb5                	addw	a5,a5,a3
    4c2e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4c32:	00074683          	lbu	a3,0(a4)
    4c36:	fd06879b          	addiw	a5,a3,-48
    4c3a:	0ff7f793          	zext.b	a5,a5
    4c3e:	fef671e3          	bgeu	a2,a5,4c20 <atoi+0x1e>
  return n;
}
    4c42:	60a2                	ld	ra,8(sp)
    4c44:	6402                	ld	s0,0(sp)
    4c46:	0141                	addi	sp,sp,16
    4c48:	8082                	ret
  n = 0;
    4c4a:	4501                	li	a0,0
    4c4c:	bfdd                	j	4c42 <atoi+0x40>

0000000000004c4e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4c4e:	1141                	addi	sp,sp,-16
    4c50:	e406                	sd	ra,8(sp)
    4c52:	e022                	sd	s0,0(sp)
    4c54:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4c56:	02b57563          	bgeu	a0,a1,4c80 <memmove+0x32>
    while(n-- > 0)
    4c5a:	00c05f63          	blez	a2,4c78 <memmove+0x2a>
    4c5e:	1602                	slli	a2,a2,0x20
    4c60:	9201                	srli	a2,a2,0x20
    4c62:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4c66:	872a                	mv	a4,a0
      *dst++ = *src++;
    4c68:	0585                	addi	a1,a1,1
    4c6a:	0705                	addi	a4,a4,1
    4c6c:	fff5c683          	lbu	a3,-1(a1)
    4c70:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4c74:	fee79ae3          	bne	a5,a4,4c68 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4c78:	60a2                	ld	ra,8(sp)
    4c7a:	6402                	ld	s0,0(sp)
    4c7c:	0141                	addi	sp,sp,16
    4c7e:	8082                	ret
    dst += n;
    4c80:	00c50733          	add	a4,a0,a2
    src += n;
    4c84:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4c86:	fec059e3          	blez	a2,4c78 <memmove+0x2a>
    4c8a:	fff6079b          	addiw	a5,a2,-1 # 2fff <subdir+0x301>
    4c8e:	1782                	slli	a5,a5,0x20
    4c90:	9381                	srli	a5,a5,0x20
    4c92:	fff7c793          	not	a5,a5
    4c96:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4c98:	15fd                	addi	a1,a1,-1
    4c9a:	177d                	addi	a4,a4,-1
    4c9c:	0005c683          	lbu	a3,0(a1)
    4ca0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4ca4:	fef71ae3          	bne	a4,a5,4c98 <memmove+0x4a>
    4ca8:	bfc1                	j	4c78 <memmove+0x2a>

0000000000004caa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4caa:	1141                	addi	sp,sp,-16
    4cac:	e406                	sd	ra,8(sp)
    4cae:	e022                	sd	s0,0(sp)
    4cb0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4cb2:	ca0d                	beqz	a2,4ce4 <memcmp+0x3a>
    4cb4:	fff6069b          	addiw	a3,a2,-1
    4cb8:	1682                	slli	a3,a3,0x20
    4cba:	9281                	srli	a3,a3,0x20
    4cbc:	0685                	addi	a3,a3,1
    4cbe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4cc0:	00054783          	lbu	a5,0(a0)
    4cc4:	0005c703          	lbu	a4,0(a1)
    4cc8:	00e79863          	bne	a5,a4,4cd8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
    4ccc:	0505                	addi	a0,a0,1
    p2++;
    4cce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4cd0:	fed518e3          	bne	a0,a3,4cc0 <memcmp+0x16>
  }
  return 0;
    4cd4:	4501                	li	a0,0
    4cd6:	a019                	j	4cdc <memcmp+0x32>
      return *p1 - *p2;
    4cd8:	40e7853b          	subw	a0,a5,a4
}
    4cdc:	60a2                	ld	ra,8(sp)
    4cde:	6402                	ld	s0,0(sp)
    4ce0:	0141                	addi	sp,sp,16
    4ce2:	8082                	ret
  return 0;
    4ce4:	4501                	li	a0,0
    4ce6:	bfdd                	j	4cdc <memcmp+0x32>

0000000000004ce8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4ce8:	1141                	addi	sp,sp,-16
    4cea:	e406                	sd	ra,8(sp)
    4cec:	e022                	sd	s0,0(sp)
    4cee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4cf0:	f5fff0ef          	jal	4c4e <memmove>
}
    4cf4:	60a2                	ld	ra,8(sp)
    4cf6:	6402                	ld	s0,0(sp)
    4cf8:	0141                	addi	sp,sp,16
    4cfa:	8082                	ret

0000000000004cfc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4cfc:	4885                	li	a7,1
 ecall
    4cfe:	00000073          	ecall
 ret
    4d02:	8082                	ret

0000000000004d04 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4d04:	4889                	li	a7,2
 ecall
    4d06:	00000073          	ecall
 ret
    4d0a:	8082                	ret

0000000000004d0c <wait>:
.global wait
wait:
 li a7, SYS_wait
    4d0c:	488d                	li	a7,3
 ecall
    4d0e:	00000073          	ecall
 ret
    4d12:	8082                	ret

0000000000004d14 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4d14:	4891                	li	a7,4
 ecall
    4d16:	00000073          	ecall
 ret
    4d1a:	8082                	ret

0000000000004d1c <read>:
.global read
read:
 li a7, SYS_read
    4d1c:	4895                	li	a7,5
 ecall
    4d1e:	00000073          	ecall
 ret
    4d22:	8082                	ret

0000000000004d24 <write>:
.global write
write:
 li a7, SYS_write
    4d24:	48c1                	li	a7,16
 ecall
    4d26:	00000073          	ecall
 ret
    4d2a:	8082                	ret

0000000000004d2c <close>:
.global close
close:
 li a7, SYS_close
    4d2c:	48d5                	li	a7,21
 ecall
    4d2e:	00000073          	ecall
 ret
    4d32:	8082                	ret

0000000000004d34 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4d34:	4899                	li	a7,6
 ecall
    4d36:	00000073          	ecall
 ret
    4d3a:	8082                	ret

0000000000004d3c <exec>:
.global exec
exec:
 li a7, SYS_exec
    4d3c:	489d                	li	a7,7
 ecall
    4d3e:	00000073          	ecall
 ret
    4d42:	8082                	ret

0000000000004d44 <open>:
.global open
open:
 li a7, SYS_open
    4d44:	48bd                	li	a7,15
 ecall
    4d46:	00000073          	ecall
 ret
    4d4a:	8082                	ret

0000000000004d4c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4d4c:	48c5                	li	a7,17
 ecall
    4d4e:	00000073          	ecall
 ret
    4d52:	8082                	ret

0000000000004d54 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4d54:	48c9                	li	a7,18
 ecall
    4d56:	00000073          	ecall
 ret
    4d5a:	8082                	ret

0000000000004d5c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4d5c:	48a1                	li	a7,8
 ecall
    4d5e:	00000073          	ecall
 ret
    4d62:	8082                	ret

0000000000004d64 <link>:
.global link
link:
 li a7, SYS_link
    4d64:	48cd                	li	a7,19
 ecall
    4d66:	00000073          	ecall
 ret
    4d6a:	8082                	ret

0000000000004d6c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4d6c:	48d1                	li	a7,20
 ecall
    4d6e:	00000073          	ecall
 ret
    4d72:	8082                	ret

0000000000004d74 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4d74:	48a5                	li	a7,9
 ecall
    4d76:	00000073          	ecall
 ret
    4d7a:	8082                	ret

0000000000004d7c <dup>:
.global dup
dup:
 li a7, SYS_dup
    4d7c:	48a9                	li	a7,10
 ecall
    4d7e:	00000073          	ecall
 ret
    4d82:	8082                	ret

0000000000004d84 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4d84:	48ad                	li	a7,11
 ecall
    4d86:	00000073          	ecall
 ret
    4d8a:	8082                	ret

0000000000004d8c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4d8c:	48b1                	li	a7,12
 ecall
    4d8e:	00000073          	ecall
 ret
    4d92:	8082                	ret

0000000000004d94 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4d94:	48b5                	li	a7,13
 ecall
    4d96:	00000073          	ecall
 ret
    4d9a:	8082                	ret

0000000000004d9c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4d9c:	48b9                	li	a7,14
 ecall
    4d9e:	00000073          	ecall
 ret
    4da2:	8082                	ret

0000000000004da4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4da4:	1101                	addi	sp,sp,-32
    4da6:	ec06                	sd	ra,24(sp)
    4da8:	e822                	sd	s0,16(sp)
    4daa:	1000                	addi	s0,sp,32
    4dac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4db0:	4605                	li	a2,1
    4db2:	fef40593          	addi	a1,s0,-17
    4db6:	f6fff0ef          	jal	4d24 <write>
}
    4dba:	60e2                	ld	ra,24(sp)
    4dbc:	6442                	ld	s0,16(sp)
    4dbe:	6105                	addi	sp,sp,32
    4dc0:	8082                	ret

0000000000004dc2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4dc2:	7139                	addi	sp,sp,-64
    4dc4:	fc06                	sd	ra,56(sp)
    4dc6:	f822                	sd	s0,48(sp)
    4dc8:	f426                	sd	s1,40(sp)
    4dca:	f04a                	sd	s2,32(sp)
    4dcc:	ec4e                	sd	s3,24(sp)
    4dce:	0080                	addi	s0,sp,64
    4dd0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4dd2:	c299                	beqz	a3,4dd8 <printint+0x16>
    4dd4:	0605ce63          	bltz	a1,4e50 <printint+0x8e>
  neg = 0;
    4dd8:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    4dda:	fc040313          	addi	t1,s0,-64
  neg = 0;
    4dde:	869a                	mv	a3,t1
  i = 0;
    4de0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    4de2:	00003817          	auipc	a6,0x3
    4de6:	8de80813          	addi	a6,a6,-1826 # 76c0 <digits>
    4dea:	88be                	mv	a7,a5
    4dec:	0017851b          	addiw	a0,a5,1
    4df0:	87aa                	mv	a5,a0
    4df2:	02c5f73b          	remuw	a4,a1,a2
    4df6:	1702                	slli	a4,a4,0x20
    4df8:	9301                	srli	a4,a4,0x20
    4dfa:	9742                	add	a4,a4,a6
    4dfc:	00074703          	lbu	a4,0(a4)
    4e00:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    4e04:	872e                	mv	a4,a1
    4e06:	02c5d5bb          	divuw	a1,a1,a2
    4e0a:	0685                	addi	a3,a3,1
    4e0c:	fcc77fe3          	bgeu	a4,a2,4dea <printint+0x28>
  if(neg)
    4e10:	000e0c63          	beqz	t3,4e28 <printint+0x66>
    buf[i++] = '-';
    4e14:	fd050793          	addi	a5,a0,-48
    4e18:	00878533          	add	a0,a5,s0
    4e1c:	02d00793          	li	a5,45
    4e20:	fef50823          	sb	a5,-16(a0)
    4e24:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    4e28:	fff7899b          	addiw	s3,a5,-1
    4e2c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    4e30:	fff4c583          	lbu	a1,-1(s1)
    4e34:	854a                	mv	a0,s2
    4e36:	f6fff0ef          	jal	4da4 <putc>
  while(--i >= 0)
    4e3a:	39fd                	addiw	s3,s3,-1
    4e3c:	14fd                	addi	s1,s1,-1
    4e3e:	fe09d9e3          	bgez	s3,4e30 <printint+0x6e>
}
    4e42:	70e2                	ld	ra,56(sp)
    4e44:	7442                	ld	s0,48(sp)
    4e46:	74a2                	ld	s1,40(sp)
    4e48:	7902                	ld	s2,32(sp)
    4e4a:	69e2                	ld	s3,24(sp)
    4e4c:	6121                	addi	sp,sp,64
    4e4e:	8082                	ret
    x = -xx;
    4e50:	40b005bb          	negw	a1,a1
    neg = 1;
    4e54:	4e05                	li	t3,1
    x = -xx;
    4e56:	b751                	j	4dda <printint+0x18>

0000000000004e58 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4e58:	711d                	addi	sp,sp,-96
    4e5a:	ec86                	sd	ra,88(sp)
    4e5c:	e8a2                	sd	s0,80(sp)
    4e5e:	e4a6                	sd	s1,72(sp)
    4e60:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4e62:	0005c483          	lbu	s1,0(a1)
    4e66:	26048663          	beqz	s1,50d2 <vprintf+0x27a>
    4e6a:	e0ca                	sd	s2,64(sp)
    4e6c:	fc4e                	sd	s3,56(sp)
    4e6e:	f852                	sd	s4,48(sp)
    4e70:	f456                	sd	s5,40(sp)
    4e72:	f05a                	sd	s6,32(sp)
    4e74:	ec5e                	sd	s7,24(sp)
    4e76:	e862                	sd	s8,16(sp)
    4e78:	e466                	sd	s9,8(sp)
    4e7a:	8b2a                	mv	s6,a0
    4e7c:	8a2e                	mv	s4,a1
    4e7e:	8bb2                	mv	s7,a2
  state = 0;
    4e80:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4e82:	4901                	li	s2,0
    4e84:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4e86:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4e8a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4e8e:	06c00c93          	li	s9,108
    4e92:	a00d                	j	4eb4 <vprintf+0x5c>
        putc(fd, c0);
    4e94:	85a6                	mv	a1,s1
    4e96:	855a                	mv	a0,s6
    4e98:	f0dff0ef          	jal	4da4 <putc>
    4e9c:	a019                	j	4ea2 <vprintf+0x4a>
    } else if(state == '%'){
    4e9e:	03598363          	beq	s3,s5,4ec4 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
    4ea2:	0019079b          	addiw	a5,s2,1
    4ea6:	893e                	mv	s2,a5
    4ea8:	873e                	mv	a4,a5
    4eaa:	97d2                	add	a5,a5,s4
    4eac:	0007c483          	lbu	s1,0(a5)
    4eb0:	20048963          	beqz	s1,50c2 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
    4eb4:	0004879b          	sext.w	a5,s1
    if(state == 0){
    4eb8:	fe0993e3          	bnez	s3,4e9e <vprintf+0x46>
      if(c0 == '%'){
    4ebc:	fd579ce3          	bne	a5,s5,4e94 <vprintf+0x3c>
        state = '%';
    4ec0:	89be                	mv	s3,a5
    4ec2:	b7c5                	j	4ea2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4ec4:	00ea06b3          	add	a3,s4,a4
    4ec8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4ecc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4ece:	c681                	beqz	a3,4ed6 <vprintf+0x7e>
    4ed0:	9752                	add	a4,a4,s4
    4ed2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4ed6:	03878e63          	beq	a5,s8,4f12 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    4eda:	05978863          	beq	a5,s9,4f2a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4ede:	07500713          	li	a4,117
    4ee2:	0ee78263          	beq	a5,a4,4fc6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4ee6:	07800713          	li	a4,120
    4eea:	12e78463          	beq	a5,a4,5012 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4eee:	07000713          	li	a4,112
    4ef2:	14e78963          	beq	a5,a4,5044 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4ef6:	07300713          	li	a4,115
    4efa:	18e78863          	beq	a5,a4,508a <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4efe:	02500713          	li	a4,37
    4f02:	04e79463          	bne	a5,a4,4f4a <vprintf+0xf2>
        putc(fd, '%');
    4f06:	85ba                	mv	a1,a4
    4f08:	855a                	mv	a0,s6
    4f0a:	e9bff0ef          	jal	4da4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4f0e:	4981                	li	s3,0
    4f10:	bf49                	j	4ea2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4f12:	008b8493          	addi	s1,s7,8
    4f16:	4685                	li	a3,1
    4f18:	4629                	li	a2,10
    4f1a:	000ba583          	lw	a1,0(s7)
    4f1e:	855a                	mv	a0,s6
    4f20:	ea3ff0ef          	jal	4dc2 <printint>
    4f24:	8ba6                	mv	s7,s1
      state = 0;
    4f26:	4981                	li	s3,0
    4f28:	bfad                	j	4ea2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4f2a:	06400793          	li	a5,100
    4f2e:	02f68963          	beq	a3,a5,4f60 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4f32:	06c00793          	li	a5,108
    4f36:	04f68263          	beq	a3,a5,4f7a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    4f3a:	07500793          	li	a5,117
    4f3e:	0af68063          	beq	a3,a5,4fde <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    4f42:	07800793          	li	a5,120
    4f46:	0ef68263          	beq	a3,a5,502a <vprintf+0x1d2>
        putc(fd, '%');
    4f4a:	02500593          	li	a1,37
    4f4e:	855a                	mv	a0,s6
    4f50:	e55ff0ef          	jal	4da4 <putc>
        putc(fd, c0);
    4f54:	85a6                	mv	a1,s1
    4f56:	855a                	mv	a0,s6
    4f58:	e4dff0ef          	jal	4da4 <putc>
      state = 0;
    4f5c:	4981                	li	s3,0
    4f5e:	b791                	j	4ea2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f60:	008b8493          	addi	s1,s7,8
    4f64:	4685                	li	a3,1
    4f66:	4629                	li	a2,10
    4f68:	000ba583          	lw	a1,0(s7)
    4f6c:	855a                	mv	a0,s6
    4f6e:	e55ff0ef          	jal	4dc2 <printint>
        i += 1;
    4f72:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f74:	8ba6                	mv	s7,s1
      state = 0;
    4f76:	4981                	li	s3,0
        i += 1;
    4f78:	b72d                	j	4ea2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4f7a:	06400793          	li	a5,100
    4f7e:	02f60763          	beq	a2,a5,4fac <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4f82:	07500793          	li	a5,117
    4f86:	06f60963          	beq	a2,a5,4ff8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4f8a:	07800793          	li	a5,120
    4f8e:	faf61ee3          	bne	a2,a5,4f4a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f92:	008b8493          	addi	s1,s7,8
    4f96:	4681                	li	a3,0
    4f98:	4641                	li	a2,16
    4f9a:	000ba583          	lw	a1,0(s7)
    4f9e:	855a                	mv	a0,s6
    4fa0:	e23ff0ef          	jal	4dc2 <printint>
        i += 2;
    4fa4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4fa6:	8ba6                	mv	s7,s1
      state = 0;
    4fa8:	4981                	li	s3,0
        i += 2;
    4faa:	bde5                	j	4ea2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4fac:	008b8493          	addi	s1,s7,8
    4fb0:	4685                	li	a3,1
    4fb2:	4629                	li	a2,10
    4fb4:	000ba583          	lw	a1,0(s7)
    4fb8:	855a                	mv	a0,s6
    4fba:	e09ff0ef          	jal	4dc2 <printint>
        i += 2;
    4fbe:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4fc0:	8ba6                	mv	s7,s1
      state = 0;
    4fc2:	4981                	li	s3,0
        i += 2;
    4fc4:	bdf9                	j	4ea2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    4fc6:	008b8493          	addi	s1,s7,8
    4fca:	4681                	li	a3,0
    4fcc:	4629                	li	a2,10
    4fce:	000ba583          	lw	a1,0(s7)
    4fd2:	855a                	mv	a0,s6
    4fd4:	defff0ef          	jal	4dc2 <printint>
    4fd8:	8ba6                	mv	s7,s1
      state = 0;
    4fda:	4981                	li	s3,0
    4fdc:	b5d9                	j	4ea2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4fde:	008b8493          	addi	s1,s7,8
    4fe2:	4681                	li	a3,0
    4fe4:	4629                	li	a2,10
    4fe6:	000ba583          	lw	a1,0(s7)
    4fea:	855a                	mv	a0,s6
    4fec:	dd7ff0ef          	jal	4dc2 <printint>
        i += 1;
    4ff0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4ff2:	8ba6                	mv	s7,s1
      state = 0;
    4ff4:	4981                	li	s3,0
        i += 1;
    4ff6:	b575                	j	4ea2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4ff8:	008b8493          	addi	s1,s7,8
    4ffc:	4681                	li	a3,0
    4ffe:	4629                	li	a2,10
    5000:	000ba583          	lw	a1,0(s7)
    5004:	855a                	mv	a0,s6
    5006:	dbdff0ef          	jal	4dc2 <printint>
        i += 2;
    500a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    500c:	8ba6                	mv	s7,s1
      state = 0;
    500e:	4981                	li	s3,0
        i += 2;
    5010:	bd49                	j	4ea2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    5012:	008b8493          	addi	s1,s7,8
    5016:	4681                	li	a3,0
    5018:	4641                	li	a2,16
    501a:	000ba583          	lw	a1,0(s7)
    501e:	855a                	mv	a0,s6
    5020:	da3ff0ef          	jal	4dc2 <printint>
    5024:	8ba6                	mv	s7,s1
      state = 0;
    5026:	4981                	li	s3,0
    5028:	bdad                	j	4ea2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    502a:	008b8493          	addi	s1,s7,8
    502e:	4681                	li	a3,0
    5030:	4641                	li	a2,16
    5032:	000ba583          	lw	a1,0(s7)
    5036:	855a                	mv	a0,s6
    5038:	d8bff0ef          	jal	4dc2 <printint>
        i += 1;
    503c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    503e:	8ba6                	mv	s7,s1
      state = 0;
    5040:	4981                	li	s3,0
        i += 1;
    5042:	b585                	j	4ea2 <vprintf+0x4a>
    5044:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5046:	008b8d13          	addi	s10,s7,8
    504a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    504e:	03000593          	li	a1,48
    5052:	855a                	mv	a0,s6
    5054:	d51ff0ef          	jal	4da4 <putc>
  putc(fd, 'x');
    5058:	07800593          	li	a1,120
    505c:	855a                	mv	a0,s6
    505e:	d47ff0ef          	jal	4da4 <putc>
    5062:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5064:	00002b97          	auipc	s7,0x2
    5068:	65cb8b93          	addi	s7,s7,1628 # 76c0 <digits>
    506c:	03c9d793          	srli	a5,s3,0x3c
    5070:	97de                	add	a5,a5,s7
    5072:	0007c583          	lbu	a1,0(a5)
    5076:	855a                	mv	a0,s6
    5078:	d2dff0ef          	jal	4da4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    507c:	0992                	slli	s3,s3,0x4
    507e:	34fd                	addiw	s1,s1,-1
    5080:	f4f5                	bnez	s1,506c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    5082:	8bea                	mv	s7,s10
      state = 0;
    5084:	4981                	li	s3,0
    5086:	6d02                	ld	s10,0(sp)
    5088:	bd29                	j	4ea2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    508a:	008b8993          	addi	s3,s7,8
    508e:	000bb483          	ld	s1,0(s7)
    5092:	cc91                	beqz	s1,50ae <vprintf+0x256>
        for(; *s; s++)
    5094:	0004c583          	lbu	a1,0(s1)
    5098:	c195                	beqz	a1,50bc <vprintf+0x264>
          putc(fd, *s);
    509a:	855a                	mv	a0,s6
    509c:	d09ff0ef          	jal	4da4 <putc>
        for(; *s; s++)
    50a0:	0485                	addi	s1,s1,1
    50a2:	0004c583          	lbu	a1,0(s1)
    50a6:	f9f5                	bnez	a1,509a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    50a8:	8bce                	mv	s7,s3
      state = 0;
    50aa:	4981                	li	s3,0
    50ac:	bbdd                	j	4ea2 <vprintf+0x4a>
          s = "(null)";
    50ae:	00002497          	auipc	s1,0x2
    50b2:	59248493          	addi	s1,s1,1426 # 7640 <malloc+0x2482>
        for(; *s; s++)
    50b6:	02800593          	li	a1,40
    50ba:	b7c5                	j	509a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    50bc:	8bce                	mv	s7,s3
      state = 0;
    50be:	4981                	li	s3,0
    50c0:	b3cd                	j	4ea2 <vprintf+0x4a>
    50c2:	6906                	ld	s2,64(sp)
    50c4:	79e2                	ld	s3,56(sp)
    50c6:	7a42                	ld	s4,48(sp)
    50c8:	7aa2                	ld	s5,40(sp)
    50ca:	7b02                	ld	s6,32(sp)
    50cc:	6be2                	ld	s7,24(sp)
    50ce:	6c42                	ld	s8,16(sp)
    50d0:	6ca2                	ld	s9,8(sp)
    }
  }
}
    50d2:	60e6                	ld	ra,88(sp)
    50d4:	6446                	ld	s0,80(sp)
    50d6:	64a6                	ld	s1,72(sp)
    50d8:	6125                	addi	sp,sp,96
    50da:	8082                	ret

00000000000050dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    50dc:	715d                	addi	sp,sp,-80
    50de:	ec06                	sd	ra,24(sp)
    50e0:	e822                	sd	s0,16(sp)
    50e2:	1000                	addi	s0,sp,32
    50e4:	e010                	sd	a2,0(s0)
    50e6:	e414                	sd	a3,8(s0)
    50e8:	e818                	sd	a4,16(s0)
    50ea:	ec1c                	sd	a5,24(s0)
    50ec:	03043023          	sd	a6,32(s0)
    50f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    50f4:	8622                	mv	a2,s0
    50f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    50fa:	d5fff0ef          	jal	4e58 <vprintf>
}
    50fe:	60e2                	ld	ra,24(sp)
    5100:	6442                	ld	s0,16(sp)
    5102:	6161                	addi	sp,sp,80
    5104:	8082                	ret

0000000000005106 <printf>:

void
printf(const char *fmt, ...)
{
    5106:	711d                	addi	sp,sp,-96
    5108:	ec06                	sd	ra,24(sp)
    510a:	e822                	sd	s0,16(sp)
    510c:	1000                	addi	s0,sp,32
    510e:	e40c                	sd	a1,8(s0)
    5110:	e810                	sd	a2,16(s0)
    5112:	ec14                	sd	a3,24(s0)
    5114:	f018                	sd	a4,32(s0)
    5116:	f41c                	sd	a5,40(s0)
    5118:	03043823          	sd	a6,48(s0)
    511c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5120:	00840613          	addi	a2,s0,8
    5124:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5128:	85aa                	mv	a1,a0
    512a:	4505                	li	a0,1
    512c:	d2dff0ef          	jal	4e58 <vprintf>
}
    5130:	60e2                	ld	ra,24(sp)
    5132:	6442                	ld	s0,16(sp)
    5134:	6125                	addi	sp,sp,96
    5136:	8082                	ret

0000000000005138 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5138:	1141                	addi	sp,sp,-16
    513a:	e406                	sd	ra,8(sp)
    513c:	e022                	sd	s0,0(sp)
    513e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5140:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5144:	00003797          	auipc	a5,0x3
    5148:	30c7b783          	ld	a5,780(a5) # 8450 <freep>
    514c:	a02d                	j	5176 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    514e:	4618                	lw	a4,8(a2)
    5150:	9f2d                	addw	a4,a4,a1
    5152:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5156:	6398                	ld	a4,0(a5)
    5158:	6310                	ld	a2,0(a4)
    515a:	a83d                	j	5198 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    515c:	ff852703          	lw	a4,-8(a0)
    5160:	9f31                	addw	a4,a4,a2
    5162:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5164:	ff053683          	ld	a3,-16(a0)
    5168:	a091                	j	51ac <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    516a:	6398                	ld	a4,0(a5)
    516c:	00e7e463          	bltu	a5,a4,5174 <free+0x3c>
    5170:	00e6ea63          	bltu	a3,a4,5184 <free+0x4c>
{
    5174:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5176:	fed7fae3          	bgeu	a5,a3,516a <free+0x32>
    517a:	6398                	ld	a4,0(a5)
    517c:	00e6e463          	bltu	a3,a4,5184 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5180:	fee7eae3          	bltu	a5,a4,5174 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    5184:	ff852583          	lw	a1,-8(a0)
    5188:	6390                	ld	a2,0(a5)
    518a:	02059813          	slli	a6,a1,0x20
    518e:	01c85713          	srli	a4,a6,0x1c
    5192:	9736                	add	a4,a4,a3
    5194:	fae60de3          	beq	a2,a4,514e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    5198:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    519c:	4790                	lw	a2,8(a5)
    519e:	02061593          	slli	a1,a2,0x20
    51a2:	01c5d713          	srli	a4,a1,0x1c
    51a6:	973e                	add	a4,a4,a5
    51a8:	fae68ae3          	beq	a3,a4,515c <free+0x24>
    p->s.ptr = bp->s.ptr;
    51ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    51ae:	00003717          	auipc	a4,0x3
    51b2:	2af73123          	sd	a5,674(a4) # 8450 <freep>
}
    51b6:	60a2                	ld	ra,8(sp)
    51b8:	6402                	ld	s0,0(sp)
    51ba:	0141                	addi	sp,sp,16
    51bc:	8082                	ret

00000000000051be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    51be:	7139                	addi	sp,sp,-64
    51c0:	fc06                	sd	ra,56(sp)
    51c2:	f822                	sd	s0,48(sp)
    51c4:	f04a                	sd	s2,32(sp)
    51c6:	ec4e                	sd	s3,24(sp)
    51c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    51ca:	02051993          	slli	s3,a0,0x20
    51ce:	0209d993          	srli	s3,s3,0x20
    51d2:	09bd                	addi	s3,s3,15
    51d4:	0049d993          	srli	s3,s3,0x4
    51d8:	2985                	addiw	s3,s3,1
    51da:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    51dc:	00003517          	auipc	a0,0x3
    51e0:	27453503          	ld	a0,628(a0) # 8450 <freep>
    51e4:	c905                	beqz	a0,5214 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    51e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    51e8:	4798                	lw	a4,8(a5)
    51ea:	09377663          	bgeu	a4,s3,5276 <malloc+0xb8>
    51ee:	f426                	sd	s1,40(sp)
    51f0:	e852                	sd	s4,16(sp)
    51f2:	e456                	sd	s5,8(sp)
    51f4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    51f6:	8a4e                	mv	s4,s3
    51f8:	6705                	lui	a4,0x1
    51fa:	00e9f363          	bgeu	s3,a4,5200 <malloc+0x42>
    51fe:	6a05                	lui	s4,0x1
    5200:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5204:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5208:	00003497          	auipc	s1,0x3
    520c:	24848493          	addi	s1,s1,584 # 8450 <freep>
  if(p == (char*)-1)
    5210:	5afd                	li	s5,-1
    5212:	a83d                	j	5250 <malloc+0x92>
    5214:	f426                	sd	s1,40(sp)
    5216:	e852                	sd	s4,16(sp)
    5218:	e456                	sd	s5,8(sp)
    521a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    521c:	0000a797          	auipc	a5,0xa
    5220:	a5c78793          	addi	a5,a5,-1444 # ec78 <base>
    5224:	00003717          	auipc	a4,0x3
    5228:	22f73623          	sd	a5,556(a4) # 8450 <freep>
    522c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    522e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5232:	b7d1                	j	51f6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5234:	6398                	ld	a4,0(a5)
    5236:	e118                	sd	a4,0(a0)
    5238:	a899                	j	528e <malloc+0xd0>
  hp->s.size = nu;
    523a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    523e:	0541                	addi	a0,a0,16
    5240:	ef9ff0ef          	jal	5138 <free>
  return freep;
    5244:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5246:	c125                	beqz	a0,52a6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5248:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    524a:	4798                	lw	a4,8(a5)
    524c:	03277163          	bgeu	a4,s2,526e <malloc+0xb0>
    if(p == freep)
    5250:	6098                	ld	a4,0(s1)
    5252:	853e                	mv	a0,a5
    5254:	fef71ae3          	bne	a4,a5,5248 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5258:	8552                	mv	a0,s4
    525a:	b33ff0ef          	jal	4d8c <sbrk>
  if(p == (char*)-1)
    525e:	fd551ee3          	bne	a0,s5,523a <malloc+0x7c>
        return 0;
    5262:	4501                	li	a0,0
    5264:	74a2                	ld	s1,40(sp)
    5266:	6a42                	ld	s4,16(sp)
    5268:	6aa2                	ld	s5,8(sp)
    526a:	6b02                	ld	s6,0(sp)
    526c:	a03d                	j	529a <malloc+0xdc>
    526e:	74a2                	ld	s1,40(sp)
    5270:	6a42                	ld	s4,16(sp)
    5272:	6aa2                	ld	s5,8(sp)
    5274:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5276:	fae90fe3          	beq	s2,a4,5234 <malloc+0x76>
        p->s.size -= nunits;
    527a:	4137073b          	subw	a4,a4,s3
    527e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5280:	02071693          	slli	a3,a4,0x20
    5284:	01c6d713          	srli	a4,a3,0x1c
    5288:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    528a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    528e:	00003717          	auipc	a4,0x3
    5292:	1ca73123          	sd	a0,450(a4) # 8450 <freep>
      return (void*)(p + 1);
    5296:	01078513          	addi	a0,a5,16
  }
}
    529a:	70e2                	ld	ra,56(sp)
    529c:	7442                	ld	s0,48(sp)
    529e:	7902                	ld	s2,32(sp)
    52a0:	69e2                	ld	s3,24(sp)
    52a2:	6121                	addi	sp,sp,64
    52a4:	8082                	ret
    52a6:	74a2                	ld	s1,40(sp)
    52a8:	6a42                	ld	s4,16(sp)
    52aa:	6aa2                	ld	s5,8(sp)
    52ac:	6b02                	ld	s6,0(sp)
    52ae:	b7f5                	j	529a <malloc+0xdc>
