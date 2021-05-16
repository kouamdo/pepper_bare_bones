#include <stddef.h>
#include <stdint.h>

#define ES_DI_ptr(__ptr__) __asm__("movw %%ax , %%di" ::"a"(__ptr__));
#define bios_info          __attribute__((section(".BIOS_INFO_section")))

typedef struct e820_mem {
    uint64_t base_addr;
    uint64_t length;
    uint32_t type;
    uint32_t ext_attrib;
} __attribute__((packed)) e820_mem;

void _simple_print_boot__(char* msg)
{
    int i = 0;

    while (msg[i] != '\0') {
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
        ++i;
    }
}

void* memset(void* addr, uint8_t data, size_t size)
{
    __asm__("cld; rep stosb\n" ::"D"(addr), "a"(data), "c"(size)
            : "cc", "memory");

    return addr;
}

void* memcpy(void* dest, void* src, size_t size)
{
    int i = 0;

    char *d = (char*)dest, *s = (char*)src;

    while (i < size) {
        d[i] = s[i];
        i++;
    }
    return dest;
}