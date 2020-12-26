

/*
    string.h

    *Definitions for string functions
*/

#ifndef _STRING_H_

#define _STRING_H_

#include "i386types.h"

bool _strcmp_(char* str1, char* str2); // Return 0 if st1 os the same as str2
void* _strcpy_(char* dest, char* src); // Copies src into dest
uint8_t _strlen_(char* str);           // Gives the length of str

void* memcpy(void* dest, const void* src, uint32_t size); // Copy specify number of bytes to null or any other value in the buffer
void* memset(void* mem, void* data, uint32_t size);
bool _memcmp_(void* src_1, void* src_2, uint32_t size); // Compare two memory area
#endif                                                  // !_STRING_H
