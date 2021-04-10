#define KERNEL__PAGE_MM
#define KERNEL__Vir_MM

#include <init/apic/apic.h>
#include <init/apic/ioapic.h>
#include <init/console.h>
#include <init/gdt.h>
#include <init/idt.h>
#include <init/io.h>
#include <init/paging.h>
#include <lib.h>
#include <mm.h>
#include <task.h>

void main()
{
    //On initialise le necessaire avant de lancer la console

    cli;

    cclean();

    init_gdt();

    init_idt();

    sti;

    while (1)
        ;
}