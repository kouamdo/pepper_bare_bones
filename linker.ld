OUTPUT_FORMAT(elf32-i386)
ENTRY(main)

SECTIONS
{
    . = 0x9000;
    .text : {
        *(.text);
    }

    .data : {*(.data)}

    .rodata : {*(.rodata)}

    .bss :
    {
        *(COMMON)
        *(.bss)
    }

    .page_table_section :
    {
        *.(page_table_section)
    }


    end = .;
}
