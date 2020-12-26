#ifndef _APIC_H_

#define _APIC_H_

#include <i386types.h>
#include <init/msr.h>

#define APIC_DETECTION ((cpuid(1) & 0x200) >> 9)

// Indicates if the processor is the bootstrap processor
#define BSP_FLAG(x) (x << 8)

// Enables or disables the local APIC
#define APIC_GLOBAL(x) (x << 11)

// Specifies the base address of the APIC registers
#define APIC_BASE(x) (x << 12)

#define IA32_APIC_BASE_MSR_ENABLE APIC_GLOBAL(1) | BSP_FLAG(0)

void enable_local_apic();

#endif // !_APIC_H_