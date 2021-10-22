#ifndef _PAGING_H_
#define _PAGING_H_

#include <lib/i386types.h>
#define PAGE_DIRECTORY_OFFSET 0x400
#define PAGE_DIRECTORY_SIZE   0X1000

#define PAGE_TABLE_OFFSET   0X400
#define PAGE_TABLE_SIZE     0X1000
#define NO_PHYSICAL_ADDRESS ((physaddr_t)("NoPhysAddr"))
#define PAGE_SIZE           (uint32_t)(0x1000)

#define PAGE_PRESENT(x)        (x)        // Page present in table or directory
#define PAGE_READ_WRITE        (1 << 1)   // Page read or write in table or directory
#define PAGE_READ_ONLY         (0 << 1)   // Page read only
#define PAGE_USER_SUPERVISOR   (1 << 2)   // Access for all
#define PAGE_SUPERVISOR        (0 << 2)   // Acces only by supervisor
#define PAGE_WRITE_THROUGH     (1 << 3)   // Write through the page
#define PAGE_WRITE_BACK        (0 << 3)   // Write back the page
#define PAGE_CACHE_DISABLED(x) ((x) << 4) // Page will not be cached
#define PAGE_ACCESSED(x)       ((x) << 5) // Page accessed
#define PAGE_SIZE_4KiB         (0 << 6)   // Page for 4Kib
#define PAGE_SIZE_4MiB         (1 << 6)   // Page for 4Mib
#define PAGE_DIRTY(x)          ((x) << 6) //  Page with dirty flag
#define PAGE_GLOBAL(x)         ((x) << 7)

#define PAGE_VALID \
    (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR)

// locate all page table frame
#define __page_table_frame__ __attribute__((section(".page_table_section")))

void create_page_table(uint32_t* page_table, uint32_t index);

// Initialiation de la pagination
void init_paging();

/*
 *   ELle permet de modifier les options d'une page
 *   Retourne 'NoAddress' si il n'est pas paginé
 */
physaddr_t get_phyaddr(virtaddr_t virtualaddr);

// Activer la pagination
extern void _EnablingPaging_();

// ELle permet de maper une page
/*
    Elle renvoie l'adresse physique si la page existe
    SI la page n'existe pas , on lui attribuera un flag au choix
*/
physaddr_t map_page(virtaddr_t virtual_address, uint16_t flag_directory, uint16_t flag_table);

#include "../lib/lib.h"
// Determiner la technologie de Pagination
// Detecté le PSE
/*
    PSE: page-size extensions for 32-bit paging.
    If CPUID.01H:EDX.PSE [bit 3] = 1, CR4.PSE may be set to 1, enabling support
   for 4-MByte pages with 32-bit paging
*/
#define DetectPSE32bit ((cpuid(0x1) & 0x08) >> 0x3)

// Detecté le PGE
/*
    PGE: global-page support.
    If CPUID.01H:EDX.PGE [bit 13] = 1, CR4.PGE may be set to 1, enabling the
   global-page feature
*/
#define DetectPGE ((cpuid(0x1) & 0x2000) >> 13)

// Detecté le PAT
/*
    PAT: page-attribute table.
    If CPUID.01H:EDX.PAT [bit 16] = 1, the 8-entry page-attribute table (PAT) is
   supported. When the PAT is supported, three bits in certain paging-structure
   entries select a memory type (used to determine type of caching used) from
   the PAT
*/
#define DetectPAT ((cpuid(0x1) & 0x10000) >> 16)

// Detecté le support d'addresse linéaire
/*
   CPUID.80000008H:EAX[15:8] reports the linear-address width supported by the
   processor. Generally, this value is 48 if CPUID.80000001H:EDX.LM [bit 29] = 1
   and 32 otherwise. (Processors that do not support CPUID function 80000008H,
   support a linear-address width of 32.)
*/
#define LinearAddress ((cpuid(0x80000001) & 0x20000000) >> 29)

// Detecté le support d'adressage physique
/*
    CPUID.80000008H:EAX[7:0] reports the physical-address width supported by the
   processor. (For processors that do not support CPUID function 80000008H, the
   width is generally 36 if CPUID.01H:EDX.PAE [bit 6] = 1 and 32 otherwise.)
   This width is referred to as MAXPHYADDR. MAXPHYADDR is at most 52.
*/
#define PhysicalAddress ((cpuid(0x1) & 0x40) >> 6)

/*
    Detect MTRRs

    The MTRRs are used to assign memory types to regions of
    memory.
    If the MTRR flag is set (indicating that the processor implements MTRRs)

    The availability of the MTRR feature is model-specific. Software can
   determine if MTRRs are supported on a processor by executing the CPUID
   instruction and reading the state of the MTRR flag (bit 12) in the feature
   infor- mation register (EDX).

    SYSENTER and SYSEXIT Instructions.
    The SYSENTER and SYSEXIT and associated MSRs are supported.
    12 MTRR Memory Type Range Registers. MTRRs are supported.
    The MTRRcap MSR contains feature bits that describe what memory types are
   supported, how many variable MTRRs are supported, and whether fixed MTRRs are
   supported.
*/
#define DetectMTRR ((cpuid(0x1) & 0x800) >> 11)

#define NUMBER_PROCESSORS (((cpuid_string(0x4))[0]) >> 16)

// 32-bit paging may map linear addresses to either 4-KByte pages

// The following items describe the 32-bit paging process in more detail as
// well has how the page size is determined:

/*
     A 4-KByte naturally aligned page directory is located at the physical
     address specified in bits 31:12 of CR3
     A page directory comprises 1024 32-bit entries (PDEs). A PDE is selected
   using the physical address defined as follows:

        bits  39:32 are all 0
        bits 31:12 are for CR3
        Bits 11:2 are bits 31:22 of the linear address
        bits 1:0 are all 0

        If CR4.PSE = 0 or the PDE’s PS flag is 0, a 4-KByte naturally aligned
   page table is located at the physical address specified in bits 31:12 of the
   PDE bits 39:32 are all 0 bits 31:32 are from the PDE bits 11:2 are bits 21:12
   of the linear address bits 1:0 are all 0

    Because the PTE is identified using bits 31:12 of the linear address , every
   PTE maps a 4Kbytes page. the final physical address is computed as follow:
            bits 39:32 are all 0
            bits 31:12 are from the PTE
            bits 11:0 are from the oiginal linear address

*/

#endif
