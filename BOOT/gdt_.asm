bits 16
extern __gdt_entry__
global load_gdt , jump_kernel

gdtr dw 0	;for limit
	dd 0	;for base


section .text


load_gdt:
		cli
		cld
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

		jmp 0x08:long_jump_



	bits 32
		 long_jump_:

		;reload segment
		mov ax , 0x10
		mov ds , ax
		mov es , ax
		mov fs , ax
		mov gs , ax

		mov ax , 0x18
		mov ss , ax
		;---------------

		

		end_: jmp end_