#define KERNEL__PAGE_MM
#define KERNEL__Vir_MM

#include <init/console.h>
#include <init/gdt.h>
#include <init/idt.h>
#include <kernel/printf.h>

extern void printf(const char* fmt, ...);

void main()
{
    //On initialise le necessaire avant de lancer la console

    cli;

    init_gdt();

    init_idt();

    init_console();

    sti;

    while (1)
        ;
}