bits 32

gloabal kernel_link
extern bios_info_begin , bios_info_end

kernel_link:

	mov eax , bios_info_end
	sub eax , bios_info_begin

	mov ecx , 0x9000

	sub ecx , eax

	mov edi , ecx

	mov esi , bios_info_begin 

	cld

	rep movsb

	jmp 0x9000