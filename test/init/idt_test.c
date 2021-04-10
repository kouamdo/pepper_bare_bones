#define TEST_H
#define TEST_M

/*


All testing funtionnaity for idt segments should be implemennt here


*/

// IDT testing functionnality

#include "../../../include/init/io.h"
#include "../../../include/test.h"
#include <stddef.h>

extern void volatile kprintf(int nmber_param, ...);

TEST_UNIT_FUNC(func__test_all_interrupt);

TEST_UNIT(test_all_interrupt) = {
    true, "test all interrupt", "Test all interrrupt", &func__test_all_interrupt, NULL, NULL

};

TEST_UNIT_FUNC(func__test_all_interrupt)
{
    uint8_t i;

    for (i = 32; i <= 48; i++) {
        // asm("int %0" ::"m"(i) : "memory");

        kprintf(3, 0x7, "[K:Int]\tInterrupt request query % has done \n", i);
    }
}

TEST_CASE(__idt_testing__) = {
    true, "Idt testing", "Test all interrupt", {&test_all_interrupt}, 1};