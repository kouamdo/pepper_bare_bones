#include "../../include/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    if (_strlen_(str2) != _strlen_(str1))
        return 0;

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
        str2++;
    }

    return *str1 == *str2;
}

uint8_t _strlen_(char* str)
{
    if (*str == '\000')
        return 0;

    uint8_t i = 1;

    while (*str != '\000') {
        str++;
        i++;
    }

    return i;
}

void* _strcpy_(char* dest, char* src)
{
    if (dest == NULL)
        return (void*)NULL;

    uint8_t i = 0;

    while (src[i] != '\000') {
        dest[i] = src[i];
        i++;
    }

    dest[i] = '\000';

    return (void*)dest;
}

void* memcpy(void* dest, const void* src, uint32_t size)
{
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    _src_ = (char*)src;

    while (size) {
        *(_dest_++) = *(_src_++);
        size--;
    }

    return (void*)dest;
}

void* memset(void* mem, void* data, uint32_t size)
{
    if (!mem)
        return NULL;

    uint32_t* dest = mem;

    while (size) {
        *dest = (uint32_t)data;
        size--;
        dest += 4;
    }

    return (void*)mem;
}

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    char* mem_1 = (char*)src_1;

    char* mem_2 = (char*)src_2;

    uint32_t i = 0;

    while (i < size && *mem_1 == *mem_2) {
        i++;
        mem_1++;
        mem_2++;
    }

    return i == size;
}