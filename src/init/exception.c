#include <kdebug.h>
#include <kernel/printf.h>

extern unsigned int __error_code__;

void kpanic()
{
    kprintf("Kernel panic: \n Error code : %d \n", __error_code__);

    backtrace();
    asm("hlt");
}
void __exception__(void)
{
    kpanic();
}
void __exception_no_ERRCODE__(void)
{
    kpanic();
}