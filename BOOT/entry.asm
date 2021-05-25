bits 16

section .text

global entry
global read_sectors
global call_second_boot

extern err , main_boot


extern bootdrive , second_boot


entry:
	cli
	jmp 0:.1

.1:
	xor ax , ax
	mov ds , ax
	mov ss , ax
	mov es , ax
	mov sp , 0
	cld
	jmp main_boot

call_second_boot:

	push dword[bootdrive]	;push the bootdrive id of the hard disk
	jmp 0x7e00


read_sectors:

	clc
	mov [bootdrive] , dl

	reset_disk:

	xor ax , ax
	int 0x13
	jc reset_disk
	

	mov bx , 0x7E00

	mov dh , 5

	push dx

	mov ah , 0x02       ; BIOS read sector function
    mov al , dh         ; Read DH sectors
    mov ch , 0x00       ; Select cylinder 0
    mov dh , 0x00       ; Select head 0
    mov cl , 0x02       ; Start reading from second sector ( i.e.
                        ; after the boot sector )

	int 0x13

	jc .disk_err_

	pop dx

	cmp dh , al
	jne .disk_err_
	ret

.disk_err_:
		mov eax , 1
		mov dword[err] , eax
		ret