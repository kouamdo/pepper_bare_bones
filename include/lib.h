
#ifndef LIB_h

#define LIB_h

#include "i386types.h"

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

#endif // !LIB_h
