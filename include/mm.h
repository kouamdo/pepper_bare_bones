#ifndef _MM_

#include "i386types.h"
#include "init/paging.h"
#include <stddef.h>

#define _MM_

#ifdef KERNEL__PAGE_MM

void init_page_mem_manage();
#define END_LIST ((_address_order_track_*)NULL)

#define KERNEL__PHY_MEM (virtaddr_t)0X100000

typedef struct _address_order_table_ {
    virtaddr_t _address_;
    uint32_t order;
    struct _address_order_table_* previous_;
    struct _address_order_table_* next_;
} __attribute__((packed)) _address_order_track_;

physaddr_t alloc_page(uint32_t order);

/*
    Free pages,
        is a lot of simpler and exists to help remember the order of the
   blocks , to free as one disadvantage of a buddy allocator is that the
   caller has to remember the size of the original allocation.
*/

// Free a page from the given page
void free_page(_address_order_track_ page);

#endif // DEBUG

#ifdef KERNEL__Vir_MM
/*
Virtual memory manager defintion
*/

#define VM__NO_VM_ADDRESS (virtaddr_t)0x0

typedef struct virt_mm {
    virtaddr_t address;
    uint32_t size;
    struct virt_mm* next;
} __attribute__((packed)) _virt_mm_;

void* kmalloc(uint32_t size);
void init_vmm();
void free(virtaddr_t _addr__);

#endif // !Vir_MM

#endif