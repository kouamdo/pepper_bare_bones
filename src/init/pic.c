#include "../../include/init/pic.h"
#include "../../include/init/io.h"

/*
 *	Suivre le Manuel Intel pour les Controlleur PIC
 *	Ou se rendre sur le site OSDEV
 *	https://wiki.osdev.org/Interrupt_Vector_Table
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(unsigned int irq)
{
    // IRQ for Slaves PIC
    if (irq >= 0x8)
        outb(PIC2_COMMAND, PIC_EOI);

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
}

void PIC_remap(unsigned int offset1, unsigned int offset2)
{
    unsigned char a1, a2;

    /*
                *	les registres ICW (Initialization Command Word), qui
       réinitialisent le contrôleur ; *	les registres OCW (Operation Control
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a2 = inb(PIC2_DATA);

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    io_wait;                                   //
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    io_wait;                                   //
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    io_wait;
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    io_wait;
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    io_wait;
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    io_wait;
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    io_wait;

    outb(PIC2_DATA, ICW4_8086);
    io_wait;
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    outb(PIC2_DATA, a2);
}

void IRQ_set_mask(unsigned char irqline)
{
    unsigned short port;
    unsigned char value;

    if (irqline < 8)
        port = PIC1_DATA;

    else {
        port = PIC2_DATA;
        irqline -= 8;
    }

    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);

    outb(port, value);
}

void IRQ_clear_mask(unsigned char irqline)
{
    unsigned char value;
    unsigned int port;

    if (irqline < 8)
        port = PIC1_DATA;
    else {
        port = PIC2_DATA;
        irqline -= 8;
    }
    value = inb(port) & (~(1 << irqline));

    outb(port, value);
}

static unsigned short int __pic_get_irq_reg(int ocw3)
{
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    outb(PIC2_COMMAND, ocw3);

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
}

/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

unsigned short int(pic_get_isr)()
{
    return __pic_get_irq_reg(PIC_READ_ISR);
}

unsigned short int(__pic_get_irr)()
{
    return __pic_get_irq_reg(PIC_READ_IRR);
}

void spurious_IRQ(unsigned char irq)
{
    unsigned char request1, request2;
    unsigned short request;

    request = __pic_get_irr();

    request1 = request & 0x00FF;

    if (irq < 8 && request1 != irq)
        IRQ_set_mask(irq);

    request2 = (request & 0xFF00) >> 8;

    if (irq >= 8 && request2 != irq)
        PIC_sendEOI(irq - 8);
}