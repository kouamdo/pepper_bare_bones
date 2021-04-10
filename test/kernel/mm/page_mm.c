/*

    *   Test page allocation
*/
#define KERNEL__PAGE_MM

#define TEST_H
#define TEST_M

#include <mm.h>
#include <stddef.h>
#include <test.h>

extern _address_order_track_* _page_area_track_;
extern uint32_t compteur;

TEST_UNIT_FUNC(page_mm_test_func__1);
TEST_UNIT_FUNC(page_mm_test_func__2);
TEST_UNIT_FUNC(page_mm_test_func__3);
TEST_UNIT_FUNC(page_mm_test_func__4);

TEST_UNIT(page_mm_test__1) = {

    true,
    "1 -> Call alloc page for different chunk of page",
    "Call alloc page for different chunk of page and verify the correct "
    "address",
    &page_mm_test_func__1,
    NULL,
    NULL};

TEST_UNIT(page_mm_test__2) = {
    true,
    "2 -> Make multiple free page",
    "Make sure that multiple free page with the same address doesn't break",
    &page_mm_test_func__2,
    NULL,
    NULL};

TEST_UNIT(page_mm_test__3) = {
    true,
    "3 -> Allocate all available memory with the same junk size in the loop",
    "Allocate all available memory with the same junk size in the loop Then "
    "free them in random order, make sure there are no errors.",
    &page_mm_test_func__3,
    NULL,
    NULL};

TEST_UNIT(page_mm_test__4) = {
    true,
    "4 -> Allocate all available memory with random chunk sizes",
    " Allocate all available memory with random chunk sizes, then free",
    &page_mm_test_func__4,
    NULL,
    NULL};

TEST_UNIT_FUNC(page_mm_test_func__1)
{
    uint32_t i;
    page_mm_test__1.passed = true;

    for (i = 0; i < 0x400; i++)
        alloc_page(i);

    _address_order_track_* tmp;

    tmp = _page_area_track_->next_;

    while (tmp->next_ != END_LIST) {
        if (tmp->_address_ != tmp->previous_->_address_ + (tmp->previous_->order * PAGE_SIZE)) {
            page_mm_test__1.passed = false;
            return;
        }
        tmp = tmp->next_;
    }

    if (page_mm_test__1.passed == true)
        page_mm_test_func__2();
}
TEST_UNIT_FUNC(page_mm_test_func__2)
{
    uint32_t i;

    for (i = 0; i < 0x400; i++)
        free_page(*_page_area_track_);

    if (_page_area_track_->next_ == END_LIST)
        page_mm_test__2.passed = true;

    else
        page_mm_test__2.passed = false;
}

TEST_UNIT_FUNC(page_mm_test_func__3)
{
    if (page_mm_test__2.passed == false || page_mm_test__1.passed == false) {
        page_mm_test__3.passed = false;
        return;
    }

    uint32_t i;

    // Begin by allocate some page
    for (i = 0; i < 0x400; i++)
        alloc_page(i);

    // Remove it randomly
    for (i = 0; i < 0x400; i++) {
        int j = compteur % (0x400 - i), k = 1;

        _address_order_track_* tmp;

        tmp = _page_area_track_;

        while (tmp->next_ != END_LIST && k < j) {
            tmp = tmp->next_;
            k++;
        }

        free_page(*tmp);
    }

    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS)
        page_mm_test__3.passed = true;
}
TEST_UNIT_FUNC(page_mm_test_func__4)
{
    uint32_t i, j;

    for (i = 1; i < 10; i++) {
        j = compteur % (i + 1);

        alloc_page(j);
    }

    _address_order_track_* tmp;

    tmp = _page_area_track_->next_;

    while (tmp->next_ != END_LIST) {
        if (tmp->_address_ < tmp->previous_->_address_ + (tmp->previous_->order * PAGE_SIZE)) {
            page_mm_test__4.passed = false;
            return;
        }
        tmp = tmp->next_;
    }
}

TEST_CASE(__page_mm_manager__) = {true,
                                  "Test physical memory manager",
                                  "Test physical memory manager",
                                  {&page_mm_test__1, &page_mm_test__3, &page_mm_test__4},
                                  3};