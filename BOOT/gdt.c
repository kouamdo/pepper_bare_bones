#include "gdt.h"

gdt_entry_desc __gdt_entry__[0xFF];

static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    desc->lim0_15 = (limite & 0xFFFF);
    desc->lim16_19 = (limite & 0xF0000) >> 16;

    desc->base0_15 = (base & 0xFFFF);
    desc->base16_23 = (base & 0xFF0000) >> 16;
    desc->base24_31 = (base & 0xFF000000) >> 24;

    desc->flags = flags;
    desc->acces_byte = access;
}

void init_gdt(void)
{
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);
}
