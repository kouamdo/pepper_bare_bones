#ifndef _MSR_H_

/*
    The machine-check global control MSRs
*/
#define _MSR_H_

#include <lib.h>

#define DetectMSR ((cpuid(0x1) & 0x20) >> 5)

#define ReadMSR(MSR, _output_)                                      \
    ({                                                              \
        __asm__ __volatile__("rdmsr"                                \
                             : "=a"(_output_[0]), "=d"(_output_[1]) \
                             : "c"(MSR));                           \
    })

#define SetMSR(MSRinput, _data_)                                       \
    ({                                                                 \
        __asm__ __volatile__("wrmsr" ::"a"((uint32_t)_data_[0]),       \
                             "d"((uint32_t)_data_[1]), "c"(MSRinput)); \
    })

#endif // !_MSR_H_