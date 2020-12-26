#ifndef _PIC_H_
#define _PIC_H_

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

void PIC_sendEOI(unsigned int irq);

/*
 *       Réinitialisations des controleurs PIC
 * Données sur les décalages de vecteurs
 */

void PIC_remap(unsigned int offset1, unsigned int offset2);

void IRQ_set_mask(unsigned char irqline);
void IRQ_clear_mask(unsigned char irqline);

static unsigned short int __pic_get_irq_reg(int icw3);
unsigned short int pic_get_isr(void), __pic_get_irr(void);

void spurious_IRQ(unsigned char irq);

#endif