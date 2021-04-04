#define TEST_H
#define _TEST_
#include <init/paging.h>
#include <init/video.h>
#include <test.h>

uint32_t page_directory[PAGE_DIRECTORY_OFFSET]
    __attribute__((aligned(PAGE_DIRECTORY_SIZE)));

__page_table_frame__ uint32_t first_page_table[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

extern test_case_result paging_test;

extern uint32_t error_code;
extern void _FlushPagingCache_();
extern void init_phymem_manage();

/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
}

void init_paging()
{
    uint16_t i = 0;

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
        page_directory[i] =
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    // __RUN_TEST__(paging_test);
}

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;

    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
                                (((uint32_t)virtualaddr) & 0xFFF));

        else
            return NO_PHYSICAL_ADDRESS;
    }
    else
        return NO_PHYSICAL_ADDRESS;
}

/*
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
                                             PAGE_ACCESSED(1) | PAGE_SUPERVISOR);
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
}

void Paging_fault()
{
}
