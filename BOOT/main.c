#include <elf.h>
#include <init/io.h>
#include <stdint.h>

#define SECTSIZE             0x200
#define PAGESIZE             0x4096
#define KERNEL_START_SECTORS 0X5
#define ELFHDR               ((Elf_t*)0x10000) // scratch space

void readsect(uint32_t, uint32_t); //Function to read sectors
void readseg(uint32_t pa, uint32_t count, uint32_t offset);

/*
	*	Assuming that free section was detected
	*	Mapping kernel memory
	*	Load the kernel stack
	*	Load the kernel and jump to it

*/
void bootmain()
{
    Proghdr_t *ph, *eph;

    cli;
    cld;

    //Read the first page of the disk  and check if it is a valid ELF
    readseg((uint32_t)ELFHDR, SECTSIZE * 8, KERNEL_START_SECTORS);

    if (ELFHDR->e_magic != ELF_MAGIC_big_endian) {

        while (1)
            ;
    }

    while (1)
        ;
}

static void waitdisk()
{
    //Wait for disk ready
    while ((inb(0x1F7) & 0xC0) != 0x40) /*Do nothing*/
        ;
}

//	Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
/*
	offset : Logical Block Address of sector
	dest : The address of buffer to put data obtained from disk 
	count : Number of sectors to read
*/
void readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    uint32_t end_pa;
    end_pa = pa + count;

    while (pa < end_pa) {
        readsect(pa, offset);
        pa += SECTSIZE;
        offset++;
    }
}

//Read sector of disk
//Read in LBA mode
/*
	offset : Logical Block Address of sector
	dest : The address of buffer to put data obtained from disk 
*/
void readsect(uint32_t dest, uint32_t offset)
{
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);
    outb(0x1F3, offset);
    outb(0x1F4, offset >> 8);
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20); // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, (int*)dest, SECTSIZE / 4);
}