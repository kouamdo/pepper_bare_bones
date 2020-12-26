#ifndef IDT_H

#define IDTSIZE 0xFF /* nombre max. de descripteurs dans la table */

#define INTGATE_PRIVILEGE_0 0x8E /* utilise pour gerer les interruptions */
#define IDTBASE 0x800

#include <i386types.h>
#include <init/pic.h>
#include <init/pit.h>

extern /* use IRQ 0 to accurately keep track of
    real time in milliseconds since the PIT was configured .
        cette interruption permettra d'eviter certaines incohérences
        pour la définitionsd e la fréquence
    */
    unsigned long
    PIT_handler(),
    __exception_handler__(), __exception_no_ERRCODE__();

extern void Paging_fault();

// Descripteur de segment:
typedef struct IDT_entry {
    uint16_t offset_lowerbits;
    uint16_t selector;
    uint8_t zero;
    uint8_t type_attr;
    uint16_t offset_higherbits;
} __attribute__((__packed__)) __idt_entry__;

extern int irq0();
extern int irq1();
extern int irq2();
extern int irq3();
extern int irq4();
extern int irq5();
extern int irq6();
extern int irq7();
extern int irq8();
extern int irq9();
extern int irq10();
extern int irq11();
extern int irq12();
extern int irq13();
extern int irq14();
extern int irq15();

void init_idt();

#endif // !IDT_H