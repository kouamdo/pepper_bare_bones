#include <stddef.h>
#include <stdint.h>

#define ES_DI_ptr(__ptr__) __asm__ ("movw %%ax , %%di"::"a"(__ptr__));


void _simple_print_boot__(char* msg)
{
    int i = 0;

    while (msg[i] != '\0') {
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
        ++i;
    }
}