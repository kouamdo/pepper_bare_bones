#ifndef _PEPPER_ELF_H_

#define ELF_MAGIC_big_endian    0x464C457FU
#define ELF_MAGIC_little_endian 0x7FELF

#include <stdint.h>

typedef struct Elf {
    uint32_t e_magic; // must equal ELF_MAGIC
    uint8_t  e_elf[12];
    uint16_t e_type;
    uint16_t e_machine;
    uint32_t e_version;
    uint32_t e_entry;
    uint32_t e_phoff;
    uint32_t e_shoff;
    uint32_t e_flags;
    uint16_t e_ehsize;
    uint16_t e_phentsize;
    uint16_t e_phnum;
    uint16_t e_shentsize;
    uint16_t e_shnum;
    uint16_t e_shstrndx;

} __attribute((__packed__)) Elf_t;

typedef struct Proghdr {
    uint32_t p_type;
    uint32_t p_offset;
    uint32_t p_va;
    uint32_t p_pa;
    uint32_t p_filesz;
    uint32_t p_memsz;
    uint32_t p_flags;
    uint32_t p_align;
} __attribute((__packed__)) Proghdr_t;

typedef struct Secthdr {
    uint32_t sh_name;
    uint32_t sh_type;
    uint32_t sh_flags;
    uint32_t sh_addr;
    uint32_t sh_offset;
    uint32_t sh_size;
    uint32_t sh_link;
    uint32_t sh_info;
    uint32_t sh_addralign;
    uint32_t sh_entsize;
} __attribute((__packed__)) Secthdr_t;

#endif // !_PEPPER_ELF_H_