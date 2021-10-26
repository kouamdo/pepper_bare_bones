#include <kdebug.h>
#include <kernel/printf.h>
#include <lib/stab.h>
#include <lib/x86.h>
#include <string.h>

extern const struct Stab __STAB_BEGIN__[];    // Beginning of stabs table
extern const struct Stab __STAB_END__[];      // End of stabs table
extern const char        __STABSTR_BEGIN__[]; // Beginning of string table
extern const char        __STABSTR_END__[];   // End of string table

static void
stab_binsearch(const struct Stab* stabs, int* region_left, int* region_right,
               int type, uintptr_t addr)
{
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type)
            m--;
        if (m < l) { // no match in [l, m]
            l = true_m + 1;
            continue;
        }

        // actual binary search
        any_matches = 1;
        if (stabs[m].n_value < addr) {
            *region_left = m;
            l            = true_m + 1;
        } else if (stabs[m].n_value > addr) {
            *region_right = m - 1;
            r             = m - 1;
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
            l            = m;
            addr++;
        }
    }

    if (!any_matches)
        *region_right = *region_left - 1;
    else {
        // find rightmost region containing 'addr'
        for (l = *region_right;
             l > *region_left && stabs[l].n_type != type;
             l--)
            /* do nothing */;
        *region_left = l;
    }
}

// debuginfo_eip(addr, info)
//
//	Fill in the 'info' structure with information about the specified
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int debuginfo_eip(uintptr_t addr, EIPdebuginfo* info)
{
    const struct Stab *stabs, *stab_end;
    const char *       stabstr, *stabstr_end;
    int                lfile, rfile, lfun, rfun, lline, rline;

    // Initialize *info
    info->eip_file       = "<unknown>";
    info->eip_line       = 0;
    info->eip_fn_name    = "<unknown>";
    info->eip_fn_namelen = 9;
    info->eip_fn_addr    = addr;
    info->eip_fn_narg    = 0;

    // Find the relevant set of stabs

    stabs       = __STAB_BEGIN__;
    stab_end    = __STAB_END__;
    stabstr     = __STABSTR_BEGIN__;
    stabstr_end = __STABSTR_END__;

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
        return -1;

    // Now we find the right stabs that define the function containing
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    lfile = 0;
    rfile = (stab_end - stabs) - 1;
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
    if (lfile == 0)
        return -1;

    // Search within that file's stabs for the function definition
    // (N_FUN).
    lfun = lfile;
    rfun = rfile;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);

    if (lfun <= rfun) {
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr)
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
        info->eip_fn_addr = stabs[lfun].n_value;
        addr -= info->eip_fn_addr;
        // Search within the function definition for the line number.
        lline = lfun;
        rline = rfun;
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
        lline             = lfile;
        rline             = rfile;
    }
    // Ignore stuff after the colon.
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    //
    // Hint:
    //	There's a particular stabs type used for line numbers.
    //	Look at the STABS documentation and <inc/stab.h> to find
    //	which one.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline)
        info->eip_line = stabs[lline].n_desc;

    else
        return -1;

    // Search backwards from the line number for the relevant filename
    // stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
        lline--;
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
        info->eip_file = stabstr + stabs[lline].n_strx;

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun)
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline++)
            info->eip_fn_narg++;

    return 0;
}

int backtrace()
{
    // Your code here.
    uint32_t*    ebp;
    EIPdebuginfo info;

    ebp = (uint32_t*)read_ebp();

    kprintf("Stack backtrace:\n");
    while (1) {
        kprintf("  ebp %x", ebp);
        kprintf("  eip %x", *(ebp + 1));
        kprintf("  args %x %x %x %x %x\n", *(ebp + 2), *(ebp + 3), *(ebp + 4), *(ebp + 5), *(ebp + 6));
        if (!debuginfo_eip((uintptr_t) * (ebp + 1), &info)) {
            kprintf("        file %s: line %d:", info.eip_file, info.eip_line);
            kprintf(" function length : %s function name : %s", info.eip_fn_namelen, info.eip_fn_name);
            kprintf("+%d\n", (*(ebp + 1) - info.eip_fn_addr));
        }
        ebp = (uint32_t*)(*ebp);
        if (ebp == 0)
            break;
    }

    return 0;
}