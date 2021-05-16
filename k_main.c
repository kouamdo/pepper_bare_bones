#define KERNEL__PAGE_MM
#define KERNEL__Vir_MM

#include <init/console.h>
#include <init/gdt.h>
#include <init/idt.h>
#include <kernel/printf.h>

extern void* end;
char *       bios_info_begin, bios_info_end;

void *detect_bios_info(), *detect_bios_info_end();

void main()
{
    cli;

    init_console();

    //Kernel Mapping
    kprintf("PEPPER_Kernel init at [%p] length [%d] bytes \n", main, &end - (void**)main);
    kprintf("Allocate [16384] bytes of stacks\n");
    kprintf("Firmware variables at [%p] length [%d] bytes \n", detect_bios_info(), detect_bios_info_end() - detect_bios_info());

    //load Memory detection

    //------------

    init_gdt(); //Init GDT secondly

    init_idt();

    sti;

    while (1)
        ;
}

//detect BIOS info
void* detect_bios_info()
{
    int       i = 0;
    uint16_t* bios_info;

    bios_info = (int16_t*)(0x7e00);

    while (bios_info[i] != 0xB00B)
        i++;

    bios_info_begin = (char*)(&bios_info[i]);

    return (void*)(&bios_info[i]);
}

void* detect_bios_info_end()
{
    int       i = 0;
    uint16_t* bios_info;

    bios_info = (int16_t*)(bios_info_begin);

    while (bios_info[i] != 0xB00E)
        i++;

    return (void*)(&bios_info[i]);
}