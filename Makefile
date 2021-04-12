CC		:= gcc
CFLAGS	:= -m32 -g -ffreestanding -fno-PIC -fno-stack-protector -Wstringop-overflow -Werror
LDFLAGS := ld -m elf_i386 --oformat=binary -Tlinker.ld

BIN		:= bin
SRC		:= src
INCLUDE	:= include
LIB		:= lib

LIBRARIES	:=

ifeq ($(OS),Windows_NT)
EXECUTABLE	:= k_main.o
SOURCEDIRS	:= $(SRC)
INCLUDEDIRS	:= $(INCLUDE)
LIBDIRS		:= $(LIB)
else
EXECUTABLE	:= main
SOURCEDIRS	:= $(shell find $(SRC) -type d)
INCLUDEDIRS	:= $(shell find $(INCLUDE) -type d)
LIBDIRS		:= $(shell find $(LIB) -type d)
endif

CINCLUDES	:= $(patsubst %,-I%, $(INCLUDEDIRS:%/=%))
CLIBS		:= $(patsubst %,-L%, $(LIBDIRS:%/=%))

SOURCES		:= $(wildcard $(patsubst %,%/*.c, $(SOURCEDIRS)))
OBJECTS		:= $(SOURCES:.c=.o)

SOURCES_ASM := $(wildcard $(patsubst %,%/*.asm, $(SOURCEDIRS)))
OBJECTS_ASM := $(SOURCES_ASM:.asm=.o)

all: boot mixt disk cpy_obj_file

boot:
	nasm -g -f elf32 -F dwarf -o $(BIN)/entry.o BOOT/entry.asm
	gcc -c  -ggdb3 -m16 -ffreestanding -fno-PIE -nostartfiles -nostdlib -o $(BIN)/stage1_boot.o -std=c99 BOOT/stage1_boot.c
	ld -m elf_i386 -o $(BIN)/boot1.elf -T BOOT/linker.ld $(BIN)/entry.o $(BIN)/stage1_boot.o
	objcopy -O binary bin/boot1.elf bin/boot1.img


	nasm -g -f elf32 -F dwarf -o $(BIN)/entry2.o BOOT/entry2.asm
	nasm -g -f elf32 -F dwarf -o $(BIN)/gdt_.o BOOT/gdt_.asm
	nasm -g -f elf32 -F dwarf -o $(BIN)/e820.o BOOT/e820.asm

	gcc -c -m16 -ggdb3 -ffreestanding -fno-PIE -nostartfiles -nostdlib -o $(BIN)/stage2_boot.o -std=c99 BOOT/stage2_boot.c
	gcc -c -m16 -ggdb3 -ffreestanding -fno-PIE -nostartfiles -nostdlib -o $(BIN)/gdt.o -std=c99 BOOT/gdt.c
	nasm  -felf32 -F dwarf -o $(BIN)/a20.o BOOT/a20.asm
	ld -m elf_i386 -o $(BIN)/boot2.elf -T BOOT/linker2.ld $(BIN)/entry2.o $(BIN)/stage2_boot.o $(BIN)/a20.o $(BIN)/gdt.o $(BIN)/gdt_.o $(BIN)/e820.o
	objcopy -O binary bin/boot2.elf bin/boot2.img

run_boot:
	make boot
	dd if=/dev/zero of=disk.img bs=512 count=2880
	dd if=bin/boot1.img of=disk.img bs=512 conv=notrunc
	dd if=bin/boot2.img of=disk.img seek=1 bs=512 conv=notrunc
	clear
	qemu-system-x86_64 -fda disk.img -d cpu_reset -d int file:serial.log


disk:
	dd if=/dev/zero of=disk.img bs=512 count=2880
	dd if=bin/boot1.img of=disk.img bs=512 conv=notrunc
	dd if=bin/boot2.img of=disk.img seek=1 bs=512 conv=notrunc
	dd if=bin/kernel.bin of=disk.img bs=512 seek=4 conv=notrunc

%.o : %.c
	@$(CC) -o $@ -c $< $(CFLAGS) $(CINCLUDES)

%.o:%.asm		
	nasm -felf32 $< -o $@

qemu:
	clear
	qemu-system-x86_64 -fda disk.img -d cpu_reset -d int file:serial.log

debug_first_boot:
	make boot
	qemu-system-i386 -fda disk.img -no-reboot -S -s &
	gdb bin/boot1.elf  \
        -ex 'target remote localhost:1234' \
        -ex 'layout src' \
        -ex 'layout reg' \
        -ex 'break entry' \
	-ex 'continue'

debug_second_boot:
	make boot
	qemu-system-i386 -fda disk.img -no-reboot -S -s &
	gdb bin/boot2.elf  \
        -ex 'target remote localhost:1234' \
        -ex 'layout src' \
        -ex 'layout reg' \
        -ex 'break entry' \
	-ex 'continue'


debug_link_file: k_main.o $(OBJECTS) $(OBJECTS_ASM)
	@echo "$(OBJECTS)"
	@echo "$(OBJECTS_ASM)"
	ld -m elf_i386 --oformat=elf32-i386 -Tlinker.ld k_main.o $(OBJECTS) $(OBJECTS_ASM) -o bin/kernel.elf
	rm $(OBJECTS)
	rm $(OBJECTS_ASM)

debug_kernel:
	qemu-system-i386 -fda disk.img -S -s &
	gdb bin/kernel.elf  \
        -ex 'target remote localhost:1234' \
        -ex 'layout src' \
        -ex 'layout reg' \
        -ex 'break main' \
-ex 'continue' 

cpy_obj_file: debug_link_file
	objdump -S bin/boot1.elf > obj/boot/boot1.asm
	objdump -S bin/boot2.elf > obj/boot/boot2.asm
	objdump -S bin/kernel.elf > obj/kernel/kernel.asm

mixt: k_main.o $(OBJECTS) $(OBJECTS_ASM)
	clear
	@echo "$(OBJECTS)"
	@echo "$(OBJECTS_ASM)"
	$(LDFLAGS) k_main.o $(OBJECTS) $(OBJECTS_ASM) -o bin/kernel.bin
	

clean:
	rm  $(OBJECTS)
	rm  $(OBJECTS_ASM)
	cd bin
	rm *.o *.img *.elf
	cd ..