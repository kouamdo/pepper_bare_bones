#ifndef PEPPER_X86_H
#define PEPPER_X86_H

#include <stddef.h>
//Put breakpoint
static inline void
breakpoint(void)
{
    asm volatile("int3");
}

//Load CR0
static inline void
lcr0(uint32_t val)
{
    asm volatile("movl %0,%%cr0"
                 :
                 : "r"(val));
}

//Read CR0
static inline uint32_t
rcr0(void)
{
    uint32_t val;
    asm volatile("movl %%cr0,%0"
                 : "=r"(val));
    return val;
}

static inline uint32_t
rcr2(void)
{
    uint32_t val;
    asm volatile("movl %%cr2,%0"
                 : "=r"(val));
    return val;
}

static inline void
lcr3(uint32_t val)
{
    asm volatile("movl %0,%%cr3"
                 :
                 : "r"(val));
}

static inline uint32_t
rcr3(void)
{
    uint32_t val;
    asm volatile("movl %%cr3,%0"
                 : "=r"(val));
    return val;
}

static inline void
lcr4(uint32_t val)
{
    asm volatile("movl %0,%%cr4"
                 :
                 : "r"(val));
}

static inline uint32_t
rcr4(void)
{
    uint32_t cr4;
    asm volatile("movl %%cr4,%0"
                 : "=r"(cr4));
    return cr4;
}

static inline void
tlbflush(void)
{
    uint32_t cr3;
    asm volatile("movl %%cr3,%0"
                 : "=r"(cr3));
    asm volatile("movl %0,%%cr3"
                 :
                 : "r"(cr3));
}

static inline uint32_t
read_eflags(void)
{
    uint32_t eflags;
    asm volatile("pushfl; popl %0"
                 : "=r"(eflags));
    return eflags;
}

static inline void
write_eflags(uint32_t eflags)
{
    asm volatile("pushl %0; popfl"
                 :
                 : "r"(eflags));
}

static inline uint32_t
read_ebp(void)
{
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
                 : "=r"(ebp));
    return ebp;
}

static inline uint32_t
read_esp(void)
{
    uint32_t esp;
    asm volatile("movl %%esp,%0"
                 : "=r"(esp));
    return esp;
}

static inline void
set_ebp(int32_t ebp)
{
    asm volatile("movl %0 , %%ebp" ::"r"(ebp));
}

static inline void
set_esp(int32_t esp)
{
    asm volatile("movl %0 , %%esp" ::"r"(esp));
}

void* x86_memset(void* addr, uint8_t data, size_t size)
{
    __asm__("cld; rep stosb\n" ::"D"(addr), "a"(data), "c"(size)
            : "cc", "memory");

    return addr;
}

#define cpuid(code)                        \
    ({                                     \
        uint32_t edx;                      \
        __asm__ __volatile__("cpuid"       \
                             : "=d"(edx)   \
                             : "a"(code)); \
        edx;                               \
    })

#define cpuid_string(code)                                             \
    ({                                                                 \
        uint32_t registers[0x4];                                       \
        __asm__ __volatile__("cpuid"                                   \
                             : "=a"(registers[0]), "=b"(registers[1]), \
                               "=c"(registers[2]), "=d"(registers[3])  \
                             : "a"(code));                             \
        registers;                                                     \
    })

#endif // !PEPPER_X86_H