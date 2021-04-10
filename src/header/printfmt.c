
#include <init/console.h>
#include <stdarg.h>
#include <stdint.h>
/*
 * Print a number (base <= 16) in reverse order,
 */

void putchar(uint8_t c)
{
    cputchar(READY_COLOR, c);
}

void puts(const char* string)
{
    if (*string != '\0') {
        putchar(*string);
        puts(string++);
    }
}

static void printnum(uint32_t num, uint8_t base)
{
    if (num >= base) printnum((uint32_t)(num / base), base);

    putchar("0123456789abcdef"[num % base]);
}

void printf(const char* fmt, ...)
{
    uint32_t i;
    char*    s;
    va_list  arg;
    va_start(arg, fmt);

    const char* chr_tmp;

    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
        while (*chr_tmp != '%') {
            putchar(*chr_tmp);
            chr_tmp++;
        }

        chr_tmp++;

        switch (*chr_tmp) {
        case 'c':
            i = va_arg(arg, uint32_t);
            putchar(i);
            break;
        case 'd':
            i = va_arg(arg, uint32_t);
            printnum(i, 10);
            break;
        case 'o':
            i = va_arg(arg, uint32_t);
            printnum(i, 8);
            break;
        case 'b':
            i = va_arg(arg, uint32_t);
            printnum(i, 2);
            break;
        case 'x':
            i = va_arg(arg, uint32_t);
            printnum(i, 16);
            break;
        case 's':
            s = va_arg(arg, char*);
            puts(s);
            break;
        default:
            break;
        }
    }

    va_end(arg);
}