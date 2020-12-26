
#ifndef _I386_TYPES_H

#define _I386_TYPES_H

#include <stdint.h>

typedef enum boolean { true = (uint8_t)0, false = (uint8_t)1 } bool;

typedef unsigned long physaddr_t;

typedef uintptr_t virtaddr_t;

#endif // !TYPES_H
