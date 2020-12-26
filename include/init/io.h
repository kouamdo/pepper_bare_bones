
#ifndef _IO_H
#define _IO_H

#include "../i386types.h"

/* desactive les interruptions */
#define cli __asm__ __volatile__("cli" ::)

/* reactive les interruptions */
#define sti __asm__ __volatile__("sti" ::)

/*Crée une interruption*/
#define interrupt(x) __asm__ __volatile__("int %0" ::"m"(x) : "memory")

/* ecrit un octet sur un port */
#define outb(port, value) \
    __asm__ __volatile__("outb %%al, %%dx" ::"d"(port), "a"(value))

/* ecrit un octet sur un port et marque une temporisation  */
#define outbp(port, value) \
    asm volatile("outb %%al, %%dx; jmp 1f; 1:" ::"d"(port), "a"(value))

/* lit un octet sur un port */
#define inb(port)                                              \
    ({                                                         \
        unsigned char _v;                                      \
        asm volatile("inb %%dx, %%al" : "=a"(_v) : "d"(port)); \
        _v;                                                    \
    })

// Forcer le CPU à attendre une opération E/S
#define io_wait __asm__ __volatile__("jmp 1f;1:jmp 2f;2:")

// Si nous voulons utiliser le APIC ou le IOAPIC
#define disabling         \
    __asm__ __volatile__( \
        "movw $0xFF , %%ax ; outb %%al , $0xA1 ; outb %%al , $0x21;" ::)

/*Lit un octet avec temporiasation*/

#define inbp(port)                                                             \
    ({                                                                         \
        unsigned char _v;                                                      \
        asm volatile("inb %%dx , %%al ; jmp 1f ; 1: " : "=a"(_v) : "d"(port)); \
        _v;                                                                    \
    })

#endif // !_IO_H