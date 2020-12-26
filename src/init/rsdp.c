#include <i386types.h>
#include <init/paging.h>
#include <init/rsdp.h>
#include <init/video.h>
#include <string.h>

volatile uint32_t do_checksum(RSDPDesc_ext_t* tableHeader)
{
    unsigned char sum = 0;

    for (int i = 0; i < tableHeader->length; i++) {
        sum += ((char*)tableHeader)[i];
    }

    return sum == 0;
}

// Decting the RSDP In the extended BIOS Data Area
// SO we should validate some field and deduce it

// Only for BIOS systems
RSDPDesc_ext_t* detecting_RSDP()
{
    int* t = (int*)0x000E0000;

    char signature[] = "RSD PTR ";

    while (t <= (int*)0x000FFFFF) {
        if (_memcmp_(t, signature, sizeof(signature))) {
            kprintf(2, 11, "RSDP Detected\n");
        }
        t++;
    }
    if (t > (int*)0x000FFFFF)
        kprintf(4, ADVICE_COLOR, "RSDP doesn't exist on this area : [% ... %]\n",
                0x000E0000, 0x000FFFFF);
}