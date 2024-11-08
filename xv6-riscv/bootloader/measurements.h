#ifndef MEASUREMENTS_H
#define MEASUREMENTS_H

#if   defined(KERNEL1)
  BYTE trusted_kernel_hash[32] = {0x41,0x9c,0x2f,0x3e,0x4e,0x8e,0x50,0x69,0xa5,0xa5,0x4b,0xde,0x5d,0xf0,0xdb,0x03,0xc8,0x61,0x2a,0x23,0x0f,0xc8,0xf7,0x59,0x6d,0xb1,0x85,0xb2,0x8a,0xdf,0xd6,0x4c,};
#elif defined(KERNEL2)
  BYTE trusted_kernel_hash[32] = {0x25,0x41,0x4d,0xd9,0xc2,0x8b,0x0a,0x83,0xef,0x3d,0x5c,0x3b,0x2f,0xee,0x3a,0x5f,0x99,0x94,0x4b,0x69,0xc2,0xb9,0xda,0x7e,0xe7,0x7a,0xbb,0xac,0xd9,0xfe,0x54,0xe3,};
#elif defined(KERNEL3)
  BYTE trusted_kernel_hash[32] = {0xf5,0x18,0x39,0xc0,0x7b,0x91,0x12,0x97,0x00,0xeb,0xda,0x73,0xc3,0x9e,0xc7,0x84,0xfb,0x5e,0x1b,0xcb,0xea,0x1e,0xb6,0x5e,0x37,0x85,0x3b,0x2a,0xbf,0xfc,0x7c,0x0e,};
#elif defined(KERNEL4)
  BYTE trusted_kernel_hash[32] = {0x4d,0xd2,0x9a,0x68,0x26,0xc1,0x90,0x7a,0xff,0x77,0x1b,0xdb,0xab,0x9c,0x5a,0xc5,0xd8,0xb3,0xe5,0x13,0x75,0xc2,0x01,0x70,0x05,0x7c,0x3d,0x43,0x3b,0xd3,0xff,0x28,};
#elif defined(KERNELPMP1)
  BYTE trusted_kernel_hash[32] = {0x63,0x6d,0xd8,0x66,0xae,0x22,0xea,0x55,0xed,0xb5,0x17,0x8a,0xea,0xdd,0x90,0x50,0xdb,0x6a,0x37,0x86,0x3b,0x75,0x3f,0xb3,0x6f,0x4a,0x00,0x03,0xe1,0x90,0x41,0x36,};
#elif defined(KERNELPMP2)
  BYTE trusted_kernel_hash[32] = {0xe9,0x50,0xa9,0xd9,0xcc,0x12,0xfa,0x9d,0x4e,0xf2,0x23,0x3c,0xa4,0x49,0x4a,0x5e,0xde,0x8b,0x78,0x22,0xe5,0xb1,0xde,0x17,0x6a,0xeb,0xe5,0x54,0xac,0x79,0xfb,0x0b,};
#endif

#endif