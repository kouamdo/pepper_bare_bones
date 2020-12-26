#define TEST_H
#define TEST_M

#include "../../../include/test.h"
#include <stddef.h>

extern void create_page_table(uint32_t* page_table, uint8_t index);
extern void map_linear_address(uint32_t* virtual_address);

TEST_UNIT_FUNC(__test_paging_1);
TEST_UNIT_FUNC(__test_paging_2);

TEST_UNIT(test_write_page) = {
    true,
    "test to write through the page whitout mapping \n",
    "Verify if we can wtite directly in the page\n",
    &__test_paging_1,
    NULL,
    NULL};

TEST_UNIT(test_write_page_2) = {
    true,
    "test to write through the page after mapping \n",
    "Verify if we can wtite directly in the page\n",
    &__test_paging_2,
    NULL,
    NULL};

TEST_UNIT_FUNC(__test_paging_2)
{
    uint32_t page_table[500];
    create_page_table(page_table, 1);

    uint8_t* ptr;

    ptr = (uint8_t*)0x400000;
    map_linear_address((uint32_t*)0x400000);

    *ptr = '\t';

    test_write_page_2.passed = true;
}

TEST_UNIT_FUNC(__test_paging_1)
{
    test_write_page.passed = true;
    uint32_t page_table[500];
    create_page_table(page_table, 1);

    uint8_t* ptr;

    ptr = (uint8_t*)0x400000;

    *ptr = '\t';
    test_write_page.passed = false;
}

TEST_CASE(paging_test) = {
    true, "Test paging\n\t", "Test paging features\n\t", {&test_write_page, &test_write_page_2}, 2};
