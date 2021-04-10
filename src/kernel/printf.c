#include <stdarg.h>
#include <stdint.h>

extern void printf(const char* fmt, ...);

void kprintf(const char* frmt, ...)
{
    va_list arg;
    va_start(arg, frmt);
    printf(frmt, arg);
    va_end(arg);
}

void kputs(const char* frmt, ...)
{
    va_list arg;
    va_start(arg, frmt);
    printf(frmt, arg);
    va_end(arg);
    printf("\n");
}