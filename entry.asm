global entry_kernel
extern main

section .text

;Config kernel after long jump

entry_kernel:

	;Config the stack
	mov ebp , 0x100000
	mov esp , ebp
	add esp , 0x1000*10



	;After all config , jump to the kernel
	jmp dword 0x8:main