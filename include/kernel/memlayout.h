#ifndef _PEPPER_KERNEL_MEMLAYOUT_H_

// Global descriptor numbers
#define GDT_Kernel_Code  0x08 // kernel text
#define GDT_Kernel_Data  0x10 // kernel data
#define GDT_Kernel_Stack 0x18 //Kernel stack

// All physical memory mapped at this address
#define KERNBASE 0x9000

#define PGSIZE 4096

// Kernel stack.
#define KSTACKTOP (0x100000)
#define KSTKSIZE  (0xa000) // size of a kernel stack

#endif // !_PEPPER_KERNEL_MEMLAYOUT_H_