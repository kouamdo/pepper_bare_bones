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