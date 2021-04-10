#include <init/apic/apic.h>
#include <init/paging.h>

__page_table_frame__ uint32_t __3fb_index_page_directory__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

static uint16_t* __ioapic_reg__;

#define IA32_APIC_BASE_MSR 0x1B

/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
}

static void set_apic_base(uintptr_t apic)
{
    uint32_t data[2];

    data[1] = 0;
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;

    SetMSR(IA32_APIC_BASE_MSR, data);
}

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    return __ioapic_reg__[offset];
}

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    __ioapic_reg__[offset] = data;
}

void enable_local_apic()
{
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);

    __ioapic_reg__ = (uint16_t*)get_apic_base();

    set_apic_base(get_apic_base());

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);

    cpu_SetLocalAPICReg(0x20, 2);
}
