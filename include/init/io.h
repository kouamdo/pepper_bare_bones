
#ifndef _IO_H
#define _IO_H

#include "../lib/i386types.h"

/* desactive les interruptions */
#define cli __asm__ __volatile__("cli" ::)

#define cld __asm__ __volatile__("cld" ::)

/* reactive les interruptions */
#define sti __asm__ __volatile__("sti" ::)

/*Crée une interruption*/
#define interrupt(x) __asm__ __volatile__("int %0" ::"m"(x) \
                                          : "memory")

/* ecrit un octet sur un port */
#define outb(port, value) \
    __asm__ __volatile__("outb %%al, %%dx" ::"d"(port), "a"(value))

/* ecrit un octet sur un port et marque une temporisation  */
#define outbp(port, value) \
    asm volatile("outb %%al, %%dx; jmp 1f; 1:" ::"d"(port), "a"(value))

/* lit un octet sur un port */
#define inb(port)                     \
    ({                                \
        int16_t _v;                   \
        asm volatile("inb %%dx, %%al" \
                     : "=a"(_v)       \
                     : "d"(port));    \
        _v;                           \
    })

// Forcer le CPU à attendre une opération E/S
#define io_wait __asm__ __volatile__("jmp 1f;1:jmp 2f;2:")

/*Lit un octet avec temporiasation*/

#define inbp(port)                                    \
    ({                                                \
        unsigned short _v;                            \
        asm volatile("inb %%dx , %%al ; jmp 1f ; 1: " \
                     : "=a"(_v)                       \
                     : "d"(port));                    \
        _v;                                           \
    })
static inline uint32_t
inl(int port)
{
    uint32_t data;
    asm volatile("inl %w1,%0"
                 : "=a"(data)
                 : "d"(port));
    return data;
}

static inline void
insl(int port, void* addr, int cnt)
{
    asm volatile("cld\n\trepne\n\tinsl"
                 : "=D"(addr), "=c"(cnt)
                 : "d"(port), "0"(addr), "1"(cnt)
                 : "memory", "cc");
}
#endif // !_IO_H