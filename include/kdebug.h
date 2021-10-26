#ifndef PEPPER_KDEBUG_H

#define PEPPER_KDEBUG_H

#include <stdint.h>

//Debug information about a particular instruction pointer
typedef struct EIPdebuginfo {
    const char* eip_file; // Source code filename for EIP
    int         eip_line; // Source code linenumber for EIP

    const char* eip_fn_name; // Name of function containing EIP
        //  - Note: not null terminated!
    int       eip_fn_namelen; // Length of function name
    uintptr_t eip_fn_addr;    // Address of start of function
    int       eip_fn_narg;    // Number of function arguments
} __attribute__((__packed__)) EIPdebuginfo;

int debuginfo_eip(uintptr_t eip, EIPdebuginfo* info);
int backtrace();

#endif // !PEPPER_KDEBUG_H
