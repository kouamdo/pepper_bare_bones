#include <driver/console.h>
#include <init/gdt.h>
#include <init/idt.h>
#include <init/io.h>
#include <kernel/memlayout.h>
#include <kernel/printf.h>
#include <lib.h>

extern void* end;
char *       bios_info_begin, bios_info_end;

void *detect_bios_info(), *detect_bios_info_end();

void main()
{
    cli;
    cld;

    init_console();

    init_gdt_kernel();

    init_idt();

    //Kernel Mapping
    kprintf("Pepper kernel info : \n");
    kprintf("PEPPER_Kernel init at [%p] length [%d] bytes \n", main, &end - (void**)main);
    kprintf("Firmware variables at [%p] length [%d] bytes \n", detect_bios_info(), detect_bios_info_end() - detect_bios_info());
    //--------------

    while (1)
        ;
}

//detect BIOS info--------------------------
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
//----------------------------------------------