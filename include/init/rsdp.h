#ifndef _RSDP_H_

#include <i386types.h>

typedef struct RSDPDesc {
    char signature[8];
    uint8_t checksum;
    char OEMID[6];
    uint8_t revision;
    uint32_t RSDTAddr;
} __attribute__((packed)) RSDPDesc_t;

typedef struct RSDPDesc_ext {
    RSDPDesc_t first_part;

    uint32_t length;
    uint64_t XsdtAddr;
    uint8_t Extend_checksum;
    uint8_t reserved[3];
} __attribute__((packed)) RSDPDesc_ext_t;

RSDPDesc_ext_t* detecting_RSDP();

#endif
