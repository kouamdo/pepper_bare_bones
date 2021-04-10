#define KERNEL__Vir_MM

#define TEST_H
#define _TEST_

#include <kernel/mm.h>
#include <string.h>
#include <test.h>

static char VMM_ZONE[4024];

#define KERNEL__VM_BASE (virtaddr_t) VMM_ZONE

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    int i;

    for (i = 0; i < 0x1000; i++) {
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
        MM_BLOCK[i].size = 0;
    }
    _head_vmm_ = MM_BLOCK;

    // __RUN_TEST__(__vm_mm_manager__);
}

void* kmalloc(uint32_t size)
{
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
        _head_vmm_->address = KERNEL__VM_BASE;
        _head_vmm_->size = size;
        memset((void*)KERNEL__VM_BASE, 0, size);

        return (void*)KERNEL__VM_BASE;
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
        i++;

    _new_item_ = &MM_BLOCK[i];

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
        _new_item_->address = KERNEL__VM_BASE;
        _new_item_->size = size;
        _new_item_->next = _head_vmm_;

        _head_vmm_ = _new_item_;

        memset((void*)_new_item_->address, 0, size);

        return (void*)_new_item_->address;
    }

    tmp = _head_vmm_;

    while (tmp->next != (_virt_mm_*)NULL) {
        if (tmp->next->address >= tmp->address + tmp->size + size)
            break;

        tmp = tmp->next;
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
        _new_item_->size = size;
        _new_item_->address = tmp->address + tmp->size;
        _new_item_->next = (_virt_mm_*)NULL;

        tmp->next = _new_item_;

        memset((void*)_new_item_->address, 0, size);

        return (void*)_new_item_->address;
    }

    else {
        _new_item_->size = size;
        _new_item_->address = tmp->address + tmp->size;

        _new_item_->next = tmp->next;
        tmp->next = _new_item_;

        memset((void*)_new_item_->address, 0, size);

        return (void*)_new_item_->address;
    }
}

void free(virtaddr_t _addr__)
{
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
        _head_vmm_->size = 0;

        _head_vmm_ = _head_vmm_->next;
        return;
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
        init_vmm();
        return;
    }

    tmp = _head_vmm_;

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
        tmp_prev = tmp;
        tmp = tmp->next;
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
        tmp->size = 0;

        tmp_prev->next = (_virt_mm_*)NULL;
        return;
    }

    if (tmp->address == _addr__) {
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
        tmp->size = 0;

        tmp_prev->next = tmp->next;
        return;
    }
}