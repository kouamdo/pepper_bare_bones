#include <stddef.h>
#include <stdint.h>

#define ES_DI_ptr(__ptr__) __asm__ ("movw %%ax , %%di"::"a"(__ptr__));
