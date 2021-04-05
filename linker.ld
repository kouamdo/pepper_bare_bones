OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
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
        PROVIDE(__EDATA__ = .);
        *(COMMON)
        *(.bss)
        PROVIDE(__END_DATA__ = .);
        BYTE(0)
    }

    .page_table_section :
    {
        PROVIDE(__PAGE_TABLE_BEGIN__ = .);
        *.(page_table_section)
        PROVIDE(__PAGE_TABLE_END__ = .);
        BYTE(0)
    }

    /* Include debugging information in kernel memory */
	.stab : {
		PROVIDE(__STAB_BEGIN__ = .);
		*(.stab);
		PROVIDE(__STAB_END__ = .);
		BYTE(0)		/* Force the linker to allocate space
				   for this section */
	}

	.stabstr : {
		PROVIDE(__STABSTR_BEGIN__ = .);
		*(.stabstr);
		PROVIDE(__STABSTR_END__ = .);
		BYTE(0)		/* Force the linker to allocate space
				   for this section */
	}


    end = .;
}
