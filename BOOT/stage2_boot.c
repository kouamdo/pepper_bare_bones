#include "gdt.h"
extern void enable_a20();
extern void load_gdt(), read_sectors();

int err_ = 1; // contain 1 if error

short bootdrive ;

void _simple_print_boot__(char* msg)
{
    int i = 0;

    while (msg[i] != '\0') {
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
        ++i;
    }
}

void main()
{
    err_ = 1;
    _simple_print_boot__("_");
    enable_a20();
    if (err_ == 1)
        _simple_print_boot__("A20 was not supported by your firmware\n");

    init_gdt();

    read_sectors();

    load_gdt();

end:
    goto end;
}