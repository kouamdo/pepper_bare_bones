#include "gdt.h"
#include "lib.h"

extern void enable_a20();
extern void load_gdt(), read_sectors();

extern void load_e820_mem_table();

typedef struct e820_mem
{
    uint64_t base_addr ;
    uint64_t length ;
    uint32_t type;
    uint32_t ext_attrib ;
}__attribute__((packed)) e820_mem ;

e820_mem e820_mem_table[0x6] ;

int err_ = 1; // contain 1 if error

short bootdrive ;

void main()
{
    err_ = 1;
    _simple_print_boot__("_");
    enable_a20();
    if (err_ == 1)
        _simple_print_boot__("A20 was not supported by your firmware\n");

    init_gdt();

    read_sectors();

    load_e820_mem_table();

    if (err_ == 1)_simple_print_boot__("Getting E820 memory Map error\n") ;

    load_gdt();

end:
    goto end;   
}