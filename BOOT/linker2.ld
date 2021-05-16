OUTPUT_FORMAT(elf32-i386)
ENTRY(entry)
SECTIONS
{
    . = 0x7E00;

	.text : {
        *(.text);
    }

    .data : 
    {
        *(.data);
        bios_info_begin = .;
        SHORT(0xB00B);
        *(.BIOS_INFO_section)
        SHORT(0xB00E);
        bios_info_end = .;
    }

    .rodata : {*(.rodata)}

    .bss :
    {
        *(COMMON);
        *(.bss);
    }
    . = ALIGN(200);

    END_SECOND_BOOT = . ;

  .sig : AT(END_SECOND_BOOT - 2)
  {
      SHORT(0xAA56);
  }

}