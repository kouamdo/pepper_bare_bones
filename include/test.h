#ifdef TEST_H

#define TEST_H

#include "i386types.h"

extern void volatile kprintf(int nmber_param, ...);

#define __test_frame__code__ __attribute__((section(".test_section__code")))
#define __test_frame__data__ __attribute__((section(".test_section__data")))
// Test Unit Data Structure
typedef struct test_unit_result {
    bool passed;                           // 0 if the test was failed
    char test_unit_name[0xFF];             // Unit test name
    char test_unit_message[0xFF];          // Unit test message
    void* test_unit_function;              // Code of test unit
    struct test_unit_result* valid_test;   // Run test if this test was succed
    struct test_unit_result* unvalid_test; // Run test if this test was failed
} __attribute__((packed)) test_unit_result;

// Test Case Data Structure
typedef struct test_case_result {
    bool passed; // 0 if the test was failed , 1 if not

    char test_case_name[0xFF]; // Execute test case

    char test_case_message[0xFF]; // Test Case Message

    test_unit_result* tests_units[0xF]; // Repertory of unit test

    uint8_t nmber_test : 4; // Number of unit test

} __attribute__((packed)) test_case_result;

#ifdef TEST_M
#define TEST_CASE(var) __test_frame__data__ struct test_case_result var
#define TEST_UNIT(var) __test_frame__data__ struct test_unit_result var
#define TEST_UNIT_FUNC(func) __test_frame__code__ void func()

#endif // TEST_M

#ifdef _TEST_
#define __RUN_TEST__(test)                                                      \
    ({                                                                          \
        uint32_t i = 0;                                                         \
        int (*func_ptr)(void) = (void*)test.tests_units[i]->test_unit_function; \
        (*func_ptr)();                                                          \
        if (test.tests_units[i]->passed == false)                               \
            kprintf(2, 4, test.tests_units[i]->test_unit_name);                 \
        for (i = 1; i < test.nmber_test; i++) {                                 \
            func_ptr = test.tests_units[i]->test_unit_function;                 \
            (*func_ptr)();                                                      \
            if (test.tests_units[i]->passed == false)                           \
                kprintf(2, 4, test.tests_units[i]->test_unit_name);             \
        }                                                                       \
    })
#endif

#endif // !TEST_H
