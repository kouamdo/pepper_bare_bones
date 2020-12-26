/*

    *   Test memory allocation
*/

#define TEST_H
#define TEST_M
#define KERNEL__Vir_MM

#include "../../../../include/mm.h"
#include "../../../../include/test.h"
#include <stddef.h>

extern _virt_mm_* _head_vmm_;
extern uint32_t compteur;

TEST_UNIT_FUNC(mm_test_func__1);
TEST_UNIT_FUNC(mm_test_func__2);
TEST_UNIT_FUNC(mm_test_func__3);
TEST_UNIT_FUNC(mm_test_func__4);

TEST_UNIT(mm_test__1) = {

    true,
    "1 -> Call alloc memory chunk for different chunk of memory chunk",
    "Call alloc memory chunk for different chunk of memory chunk and verify "
    "the correct "
    "address",
    &mm_test_func__1,
    NULL,
    NULL};

TEST_UNIT(mm_test__2) = {true,
                         "2 -> Make multiple free memory chunk",
                         "Make sure that multiple free memory chunk with the "
                         "same address doesn't break",
                         &mm_test_func__2,
                         NULL,
                         NULL};

TEST_UNIT(mm_test__3) = {
    true,
    "3 -> Allocate all available memory with the same junk size in the loop",
    "Allocate all available memory with the same junk size in the loop Then "
    "free them in random order, make sure there are no errors.",
    &mm_test_func__3,
    NULL,
    NULL};

TEST_UNIT(mm_test__4) = {
    true,
    "4 -> Allocate all available memory with random chunk sizes",
    " Allocate all available memory with random chunk sizes, then free",
    &mm_test_func__4,
    NULL,
    NULL};

TEST_UNIT_FUNC(mm_test_func__1)
{
    uint32_t i;
    mm_test__1.passed = true;

    for (i = 0; i < 0x400; i++)
        kmalloc(i);

    _virt_mm_ *tmp, *tmp_prev;

    tmp = _head_vmm_->next;
    tmp_prev = _head_vmm_;

    while (tmp->next != (_virt_mm_*)NULL) {
        if (tmp->address != tmp_prev->address + tmp_prev->size) {
            mm_test__1.passed = false;
            return;
        }
        tmp_prev = tmp;
        tmp = tmp->next;
    }

    if (mm_test__1.passed == true)
        mm_test_func__2();
}

TEST_UNIT_FUNC(mm_test_func__2)
{
    uint32_t i;
    for (i = 0; i < 0x400; i++)
        free(_head_vmm_->address);
    if (_head_vmm_->next == (_virt_mm_*)NULL)
        mm_test__2.passed = true;

    else
        mm_test__2.passed = false;
}

TEST_UNIT_FUNC(mm_test_func__3)
{
    if (mm_test__2.passed == false || mm_test__3.passed == false) {
        mm_test__3.passed = false;
        return;
    }

    uint32_t i;
    for (i = 0; i < 0x400; i++)
        kmalloc(i);

    for (i = 0; i < 0x400; i++) {
        int j = compteur % (0x400 - i), k = 1;

        _virt_mm_* tmp;

        tmp = _head_vmm_;

        while (tmp->next != (_virt_mm_*)NULL && k < j) {
            tmp = tmp->next;
            k++;
        }

        free(tmp->address);
    }

    if (_head_vmm_->address == VM__NO_VM_ADDRESS)
        mm_test__3.passed = true;
}

TEST_UNIT_FUNC(mm_test_func__4)
{
    uint32_t i, j;

    for (i = 1; i < 10; i++) {
        j = compteur % (i + 1);

        kmalloc(j);
    }

    _virt_mm_ *tmp, *tmp_prev;
    tmp = _head_vmm_->next;
    tmp_prev = _head_vmm_;

    while (tmp->next != (_virt_mm_*)NULL) {
        if (tmp->address < tmp_prev->address + tmp_prev->size) {
            mm_test__4.passed = false;
            return;
        }
        tmp_prev = tmp;
        tmp = tmp->next;
    }
}

TEST_CASE(__vm_mm_manager__) = {true,
                                "Test physical memory manager",
                                "Test physical memory manager",
                                {&mm_test__1, &mm_test__3, &mm_test__4},
                                3};