#ifndef _GDT_H_

#define _GDT_H_

#include "../../include/i386types.h"

#define GDTBASE 0x0  /* addr. physique ou doit resider la gdt */
#define GDTSIZE 0xFF /* nombre max. de descripteurs dans la table */

/* Present bit. This must be 1 for all valid selectors.*/
#define SEG_PRESENT(x) (x << 7)

/* Contains the ring level, 0 = highest (kernel), 3 = lowest (user applications).*/
#define SEG_PRIVILEGE(x) ((x & 0x03) << 0x05)

/* Descriptor type. This bit should be set for code or data segments and should be cleared for system segments*/
#define SEG_DESCRIPTOR_TYPE(x) (x << 0x04)

/* Executable bit. If 1 code in this segment can be executed, ie. a code selector. If 0 it is a data selector.*/
#define SEG_EXECUTABLE_BIT(x) (x << 0x03)

/*
    Direction bit/Conforming bit.

    ->  Direction bit for data selectors: Tells the direction. 0 the segment grows up. 1 the segment grows down, ie. the offset has to be greater than the limit.

    ->  Conforming bit for code selectors:

        ->  If 1 code in this segment can be executed from an equal or lower privilege
            level. For example, code in ring 3 can far-jump to conforming code in a ring
            2 segment. The privl-bits represent the highest privilege level that is allowed to execute the segment. For example, code in ring 0 cannot far-jump to a conforming code segment with privl==0x2, while code in ring 2 and 3 can. Note that the privilege level remains the same, ie. a far-jump form ring 3 to a privl==2-segment remains in ring 3 after the jump.

        ->  If 0 code in this segment can only be executed from the ring set in privl.
*/

#define SEG_DIRECTION_CONFORMING_BIT(x) (x << 0x02)

/*
    ->  Readable bit for code selectors: Whether read access for this segment is allowed. Write access is never allowed for code segments.

    ->  Writable bit for data selectors: Whether write access for this segment is allowed. Read access is always allowed for data segments.
*/
#define SEG_READABLE_WRITABLE_BIT(x) (x << 0x01)

#define SEG_ACCESSED_BIT(X) \
    (X) /* Accessed bit. Just set to 0. The CPU sets this to 1 when the segment is accessed.*/

// Definition of FLAGS

/*Granularity bit. If 0 the limit is in 1 B blocks (byte granularity), if 1 the limit is in 4 KiB blocks (page granularity). */
#define SEG_GRANULARITY(x) (x << 0x03)

/*

Size bit. If 0 the selector defines 16 bit protected mode. If 1 it defines 32 bit protected mode. You can have both 16 bit and 32 bit selectors at once.
    Conf : Intel Manual page 2881
*/
#define SEG_SIZE(x) (x << 0x02)

// Conf ; Intel manual page 2882
/* Definition of SEGMENT TYPE*/
#define DATA_READ_ONLY 0X0
#define DATA_READ_ONLY_ACCESSED 0X1
#define DATA_READ_WRITE 0X2
#define DATA_READ_WRITE_ACCESSED 0X3
#define DATA_READ_ONLY_EXPAND_DOWN 0x4
#define DATA_READ_ONLY_EXPAND_DOWN_ACCESSED 0x5
#define DATA_READ_WRITE_EXPAND_DOWN 0X6
#define DATA_READ_WRITE_EXPAND_DOWN_ACCESSED 0X7

#define CODE_EXECUTE_ONLY 0x8
#define CODE_EXECUTE_ONLY_ACCESSED 0X9
#define CODE_EXECUTE_READ 0XA
#define CODE_EXECUTE_READ_ACCESSED 0XB
#define CODE_EXECUTE_ONLY_CONFORMING 0XC
#define CODE_EXECUTE_ONLY_CONFORING_ACCESSED 0XD
#define CODE_EXECUTE_READ_CONFORMING 0XE
#define CODE_EXECUTE_READ_CONFORMING_ACCESSED 0XF

#define CODE_PRIVILEGE_0 \
    CODE_EXECUTE_READ | SEG_PRESENT(1) | SEG_PRIVILEGE(0) | SEG_DESCRIPTOR_TYPE(1)

#define DATA_PRIVILEGE_0 \
    DATA_READ_WRITE | SEG_PRESENT(1) | SEG_PRIVILEGE(0) | SEG_DESCRIPTOR_TYPE(1)

/*
    Stack segments are data segments which must be read/write segments.
    If the size of a stack .
    segment needs to be changed dynamically, the stack segment can be an expand-down data segment (expansion-
    direction flag set). Here, dynamically changing the segment limit causes stack space to be added to the bottom of
    the stack. If the size of a stack segment is intended to remain static, the stack segment may be either an expand-
    up or expand-down type.
*/

#define STACK_PRIVILEGE_0                                             \
    DATA_READ_WRITE_EXPAND_DOWN | SEG_PRESENT(1) | SEG_PRIVILEGE(0) | \
        SEG_DESCRIPTOR_TYPE(1)

/*
    The base, limit, and DPL fields and the granularity and
    present flags have functions similar to their use in data-segment descriptors
*/

#define TSS_PRIVILEGE_0                                              \
    CODE_EXECUTE_ONLY_ACCESSED | SEG_PRIVILEGE(0) | SEG_PRESENT(1) | \
        SEG_DESCRIPTOR_TYPE(0)

/* Descripteur de segment */
typedef struct gdtdesc {
    uint16_t lim0_15;
    uint16_t base0_15;
    uint8_t base16_23;
    uint8_t acces_byte;
    uint8_t lim16_19 : 4;
    uint8_t flags : 4;
    uint8_t base24_31;
} __attribute__((packed)) gdt_entry_desc;

void init_gdt(void);

#endif // !_GDT_H_
