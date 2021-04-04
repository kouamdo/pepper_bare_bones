#include "include/init/video.h"
#define KERNEL__PAGE_MM
#define KERNEL__Vir_MM

#include <init/apic/apic.h>
#include <init/apic/ioapic.h>
#include <init/gdt.h>
#include <init/idt.h>
#include <init/io.h>
#include <init/paging.h>
#include <init/video.h>
#include <lib.h>
#include <mm.h>
#include <task.h>

void main()
{
    //On initialise le necessaire avant de lancer la console
    pepper_screen();

    cli;

    init_idt();

    init_paging();
    kprintf(2 ,READY_COLOR ,"pepper kernel IA32bits laboratory\n\n");

    kprintf(2 ,READY_COLOR ,"K > ");

    sti;

    // init_page_mem_manage();

    // init_vmm();

    // init_multitasking();

    // enable_local_apic();

    // program_IOAPIC();

    while (1)
        ;
}
