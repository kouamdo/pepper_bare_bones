OUTPUT_FORMAT(elf32-i386)
ENTRY(entry)
SECTIONS
{
  . = 0x7c00;
  
  .text : {
        *(.text);
    }

    .data : {*(.data)}

    .rodata : {*(.rodata)}

    .bss : {*(.bss)}

  .sig : AT(ADDR(.text) + 510)
  {
      SHORT(0xaa55);
  }
}