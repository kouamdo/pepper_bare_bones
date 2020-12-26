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
    pepper_screen();

    cli;

    init_gdt();

    init_idt();

    init_paging();

    sti;

    init_page_mem_manage();

    init_vmm();

    init_multitasking();

    enable_local_apic();

    program_IOAPIC();

    while (1)
        ;
}
