bits 16
extern __gdt_entry__ , kern_init , bootdrive , err_
global load_gdt

gdtr dw 0	;for limit
	dd 0	;for base


section .text


load_gdt:
	cli
	push eax
	push ecx
		mov ecx , 4*255
		mov eax , __gdt_entry__
		add eax , ecx
		mov word[gdtr] , ax

		mov ecx , __gdt_entry__
		mov dword[gdtr+2] , ecx

		lgdt [gdtr]

		mov eax, cr0
    	or al, 1
 		mov cr0, eax


		jmp 0x08:next_

	bits 32
	next_:

		mov ax , 0x10
		mov ds , ax
		mov es , ax
		mov fs , ax
		mov gs , ax

		mov ax , 0x18
		mov ss , ax


		pop ecx
		pop eax

		 mov ebp, 0x90000
    	mov esp, ebp

		call 0x9000