#include "../../include/init//pic.h"
#include "../../include/init/io.h"
#include "../../include/init/video.h"

extern void spurious_IRQ(unsigned char irq);

void irq0_handler(void)
{
    spurious_IRQ(0);
    PIC_sendEOI(0);
}

void irq1_handler(void)
{
    spurious_IRQ(1);

    PIC_sendEOI(1);
}

void irq2_handler(void)
{
    spurious_IRQ(2);

    PIC_sendEOI(2);
}

void irq3_handler(void)
{
    spurious_IRQ(3);

    PIC_sendEOI(3);
}

void irq4_handler(void)
{
    spurious_IRQ(4);

    PIC_sendEOI(4);
}

void irq5_handler(void)
{
    spurious_IRQ(5);

    PIC_sendEOI(5);
}

void irq6_handler(void)
{
    spurious_IRQ(6);

    PIC_sendEOI(6);
}

void irq7_handler(void)
{
    spurious_IRQ(7);

    PIC_sendEOI(7);
}

void irq8_handler(void)
{
    spurious_IRQ(8);

    PIC_sendEOI(8);
}

void irq9_handler(void)
{
    spurious_IRQ(9);

    PIC_sendEOI(9);
}

void irq10_handler(void)
{
    spurious_IRQ(10);

    PIC_sendEOI(10);
}

void irq11_handler(void)
{
    spurious_IRQ(11);

    PIC_sendEOI(11);
}

void irq12_handler(void)
{
    spurious_IRQ(12);

    PIC_sendEOI(12);
}

void irq13_handler(void)
{
    spurious_IRQ(13);

    PIC_sendEOI(13);
}

void irq14_handler(void)
{
    spurious_IRQ(14);

    PIC_sendEOI(14);
}

void irq15_handler(void)
{
    spurious_IRQ(15);

    PIC_sendEOI(15);
}