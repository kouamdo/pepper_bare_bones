#ifndef _PIC_H_
#define _PIC_H_

    #include <stdint.h>

#define ICW1_ICW4 0x01
#define ICW1_SINGLE 0x02
#define ICW1_INTERVAL4 0X04
#define ICW1_INIT 0X10

#define ICW4_8086 0X01
#define ICW4_AUTO 0X02
#define ICW4_BUF_SLAVE 0X08
#define ICW4_BUF_MASTER 0X0C
#define ICW4_SFNM 0X10

#define PIC1 0X20
#define PIC2 0XA0
#define PIC1_COMMAND PIC1
#define PIC1_DATA (PIC1 + 1)
#define PIC2_COMMAND PIC2
#define PIC2_DATA (PIC2 + 1)
#define PIC_EOI 0x20

#define PIC_READ_IRR 0x0A // OCW3 irq ready next cmd read
#define PIC_READ_ISR 0x0B // OCW3 irq service next cmd read

// Diseable 
#define disabling         \
    __asm__ __volatile__( \
        "movw $0xFF , %%ax ; outb %%al , $0xA1 ; outb %%al , $0x21;" ::)

void PIC_sendEOI(uint8_t irq);

/*
 *       Réinitialisations des controleurs PIC
 * Données sur les décalages de vecteurs
 */

void PIC_remap(uint8_t offset1, uint8_t offset2);

void IRQ_set_mask(uint8_t irqline);
void IRQ_clear_mask(uint8_t irqline);

static uint16_t  __pic_get_irq_reg(uint8_t icw3);
uint16_t pic_get_isr(void), __pic_get_irr(void);

void spurious_IRQ(uint8_t irq);

#endif