bits 16


global entry, read_sectors
extern main
extern err_ , bootdrive

section .text



entry:
	cli
	jmp main

read_sectors:

	;load the bootdrive 
	mov ax , word[esp-2]
	mov word[bootdrive] , ax

	reset_disk:
	mov dl ,[bootdrive]
	xor ax , ax
	int 0x13
	jc reset_disk
	

	mov bx , 0x9000

	mov dh , 50

	push dx

	mov ah , 0x02       ; BIOS read sector function
    mov al , dh         ; Read DH sectors
    mov ch , 0x00       ; Select cylinder 0
    mov dh , 0x00       ; Select head 0
    mov cl , 0x05       ; Start reading from second sector ( i.e.
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