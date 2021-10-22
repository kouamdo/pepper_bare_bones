bits 16


global entry, read_sectors
extern main, err_ , bootdrive

section .text



entry:
	cli

	;Take disk drive id
	pop eax
	mov dl , al
	mov dword[bootdrive] , eax
	;-----

	jmp main

read_sectors:
		clc
		mov dl , [bootdrive]
		
	reset_disk:

		xor ax , ax
		int 0x13
		jc reset_disk
		

		mov bx , 0x9000

		mov dh , 40

		push dx

		mov ah , 0x02       ; BIOS read sector function
		mov al , dh         ; Read DH sectors
		mov ch , 0x00       ; Select cylinder 0
		mov dh , 0x00       ; Select head 0
		mov cl , 0x06       ; Start reading from second sector ( i.e.
							; after the boot sector )

		int 0x13

		jc .disk_err_

		pop dx

		cmp dh , al
		jne .disk_err_
		ret

	.disk_err_:
		mov eax , 1
		mov dword[err_] , eax
		ret