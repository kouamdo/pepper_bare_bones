OUTPUT_FORMAT(elf32-i386)
ENTRY(entry)
SECTIONS
{
    . = 0x7E00;
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
}