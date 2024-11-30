#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"

void main();
void timerinit();

// entry.S needs one stack per CPU.
//__attribute__ ((aligned (16))) char stack0[4096 * NCPU];

// entry.S jumps here in machine mode on stack0.
void
start()
{
  unsigned long mstatus;
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
  //unsigned long privilege_level = (mstatus >> 11) & 0x3;
/*  if (privilege_level == 0) {
	  printf("user");
  } else if (privilege_level == 1) {
	   printf("super");
	  // Supervisor Mode
  } else if (privilege_level == 3) {
	   printf("machine");
	  // Machine Mode
  }*/
  // set M Previous Privilege mode to machine
  unsigned long x1 = r_mstatus();
  unsigned long x2 = r_mstatus();
  x1 &= ~MSTATUS_MPP_MASK;
  x1 |= MSTATUS_MPP_M;
  //w_mstatus(x1);
  

  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
 // privilege_level = (mstatus >> 11) & 0x3;
  /*if (privilege_level == 0) {
	  printf("user");
  } else if (privilege_level == 1) {
	   printf("super");
	  // Supervisor Mode
  } else if (privilege_level == 3) {
	   printf("machine");
	  // Machine Mode
  }*/

  w_menvcfg(r_menvcfg() | (1L << 63)); 
  
  // set M Previous Privilege mode to Supervisor, for mret.
  x2 &= ~MSTATUS_MPP_MASK;
  x2 |= MSTATUS_MPP_S;
  w_mstatus(x2);

  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
  //privilege_level = (mstatus >> 11) & 0x3;
  /*if (privilege_level == 0) {
	  printf("user");
  } else if (privilege_level == 1) {
	   printf("super");
	  // Supervisor Mode
  } else if (privilege_level == 3) {
	   printf("machine");
	  // Machine Mode
  }*/

  unsigned long sp_value, mepc_value;
  // Debug print of sp and mepc
  asm volatile(
		  "mv %0, sp\n"            // Move the value of sp into sp_value
		  "csrr %1, mepc\n"        // Read mepc into mepc_value
		  : "=r" (sp_value), "=r" (mepc_value) // Output operands
	      );
  //printf(" before jump to main Debug: sp = 0x%lx, mepc = 0x%lx\n", sp_value, mepc_value);
  // set M Exception Program Counter to main, for mret.
  // requires gcc -mcmodel=medany
  w_mepc((uint64)main);

  // Debug print of sp and mepc
  asm volatile(
		  "mv %0, sp\n"            // Move the value of sp into sp_value
		  "csrr %1, mepc\n"        // Read mepc into mepc_value
		  : "=r" (sp_value), "=r" (mepc_value) // Output operands
	      );
  //printf(" after jump to main Debug: sp = 0x%lx, mepc = 0x%lx\n", sp_value, mepc_value);

  // disable paging for now.
  w_satp(0);

  // delegate all interrupts and exceptions to supervisor mode.
  w_medeleg(0xffff);
  w_mideleg(0xffff);
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);

  // configure Physical Memory Protection to give supervisor mode
  // access to all of physical memory.
  w_pmpaddr0(0x3fffffffffffffull);
  w_pmpcfg0(0xf);

  // ask for clock interrupts.
  //int id = r_mhartid();
  //`w_tp(id);

//  unsigned long mstatus;
  asm volatile("csrr %0, mstatus" : "=r" (mstatus));
 //privilege_level = (mstatus >> 11) & 0x3;
  /*if (privilege_level == 0) {
	  printf("user");
  } else if (privilege_level == 1) {
	   printf("super");
	  // Supervisor Mode
  } else if (privilege_level == 3) {
	   printf("machine");
	  // Machine Mode
  }*/
  timerinit();
  // keep each CPU's hartid in its tp register, for cpuid().

  // switch to supervisor mode and jump to main().
  asm volatile("mret");
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
  
  // enable the sstc extension (i.e. stimecmp).
//  w_menvcfg(r_menvcfg() | (1L << 63)); 
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
}
