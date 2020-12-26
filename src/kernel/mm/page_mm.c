#define KERNEL__PAGE_MM
#include <i386types.h>
#include <stdint.h>
#define TEST_H
#define _TEST_

#include <init/paging.h>
#include <init/video.h>
#include <mm.h>
#include <string.h>
#include <test.h>

/*
  Memory space to put our nodes (pages)
*/
static _address_order_track_ MEMORY_SPACES_PAGES[0x400]; // Able to take 0x400 pages
extern test_case_result __phy_mem_manager__;

_address_order_track_* _page_area_track_;
uint32_t NMBER_PAGES_ALLOC;

/*
  _page_area_track_ is one variable , at the head , it is the linked list
  each element of the list point to his next and to his previos element
  we should integrate a good stuff to insert pages , we a good optimisation
*/

/*/
  this function allows to initiate the physical memory manager
  the manager is called _page_area_track
*/
/*
    page Table for mapping request of kernel(kernel allocation)
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
        MEMORY_SPACES_PAGES[i].order = 0;
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    }

    create_page_table(__kernel_phys_mem_manager__, 1);

    _page_area_track_ = MEMORY_SPACES_PAGES;

    kprintf(2, 15, "[K:PHY_MEM]\tInitialsation of physical memory manager\n");

    // __RUN_TEST__(__phy_mem_manager__);
}

physaddr_t alloc_page(uint32_t order)
{
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
        _page_area_track_->order = order;
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);

        return (*_page_area_track_)._address_;
    }

    // FInd the free address space
    uint32_t i = 0;
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
        i++;

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
        new_page->_address_ = KERNEL__PHY_MEM;
        new_page->order = order;
        new_page->next_ = _page_area_track_;
        _page_area_track_ = new_page;

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
        return (*new_page)._address_;
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
            break;
        else
            tmp = tmp->next_;
    }

    if (tmp->next_ == END_LIST) {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
        new_page->order = order;

        new_page->next_ = END_LIST;
        new_page->previous_ = tmp;

        tmp->next_ = new_page;

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
        return (*new_page)._address_;
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
        new_page->order = order;

        new_page->next_ = tmp->next_;
        new_page->previous_ = tmp;
        tmp->next_ = new_page;
        tmp->next_->previous_ = new_page;

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
        return (*new_page)._address_;
    }
    NMBER_PAGES_ALLOC++;
}

void free_page(_address_order_track_ page)
{
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
        _page_area_track_ = _page_area_track_->next_; // point to the second item
        _page_area_track_->previous_ = END_LIST;
        return;
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
            MEMORY_SPACES_PAGES[i].order = 0;
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
        }
        return;
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
            tmp = tmp->next_;

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
            tmp->previous_->next_ = END_LIST;
            return;
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
            tmp->previous_->next_ = tmp->next_;
            tmp->next_->previous_ = tmp->previous_;
            return;
        }
    }
    NMBER_PAGES_ALLOC--;
}