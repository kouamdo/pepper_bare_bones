#include "gdt.h"
#include "lib.h"
#include <stddef.h>

extern void enable_a20();

extern char *bios_info_begin, *bios_info_end;
extern void  load_gdt(), read_sectors();

extern int int_loop;

extern void load_e820_mem_table();

bios_info e820_mem e820_mem_table[0xF]; //Contain all the memory frame

int err_ = 1; // contain 1 if error

bios_info int bootdrive;

void* kernel_link;

void error_message(char* message)
{
    _simple_print_boot__(message);
    err_ = 0;
    __asm__("hlt");
}

void main()
{

    err_ = 0;

    enable_a20();

    if (err_ == 1) error_message("A20 disabled");

    //Load some information of BIOS In kernel memory

    load_e820_mem_table();

    if (err_ == 1) error_message("E820 doesn't supported by your firmware");

    err_ = 0;

    init_gdt();

    read_sectors();

    if (err_ == 1) error_message("Kernel doesn't loaded\n");

    //-----------------------------------------------

    load_gdt(); //Load gdt and jump to kernel initializations
}
