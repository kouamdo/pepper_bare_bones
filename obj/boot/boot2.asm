
bin/boot2.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00007e00 <entry>:
section .text



entry:
	cli
    7e00:	fa                   	cli    

	;Take disk drive id
	pop eax
    7e01:	66 58                	pop    %ax
	mov dl , al
    7e03:	88 c2                	mov    %al,%dl
	mov dword[bootdrive] , eax
    7e05:	66 a3 08 85 e9 7e    	mov    %ax,0x7ee98508
	;-----

	jmp main
    7e0b:	01                   	.byte 0x1

00007e0c <read_sectors>:

read_sectors:
	clc
    7e0c:	f8                   	clc    

00007e0d <reset_disk>:

	reset_disk:
	xor ax , ax
    7e0d:	31 c0                	xor    %eax,%eax
	int 0x13
    7e0f:	cd 13                	int    $0x13
	jc reset_disk
    7e11:	72 fa                	jb     7e0d <reset_disk>
	cli
    7e13:	fa                   	cli    
	

	mov bx , 0x9000
    7e14:	bb 00 90 b6 32       	mov    $0x32b69000,%ebx

	mov dh , 50

	push dx
    7e19:	52                   	push   %edx

	mov ah , 0x02       ; BIOS read sector function
    7e1a:	b4 02                	mov    $0x2,%ah
    mov al , dh         ; Read DH sectors
    7e1c:	88 f0                	mov    %dh,%al
    mov ch , 0x00       ; Select cylinder 0
    7e1e:	b5 00                	mov    $0x0,%ch
    mov dh , 0x00       ; Select head 0
    7e20:	b6 00                	mov    $0x0,%dh
    mov cl , 0x05       ; Start reading from second sector ( i.e.
    7e22:	b1 05                	mov    $0x5,%cl
                        ; after the boot sector )

	int 0x13
    7e24:	cd 13                	int    $0x13

	jc .disk_err_
    7e26:	72 07                	jb     7e2f <reset_disk.disk_err_>

	pop dx
    7e28:	5a                   	pop    %edx

	cmp dh , al
    7e29:	38 c6                	cmp    %al,%dh
	jne .disk_err_
    7e2b:	75 02                	jne    7e2f <reset_disk.disk_err_>

	cli
    7e2d:	fa                   	cli    

	ret
    7e2e:	c3                   	ret    

00007e2f <reset_disk.disk_err_>:

.disk_err_:
		mov eax , 1
    7e2f:	66 b8 01 00          	mov    $0x1,%ax
    7e33:	00 00                	add    %al,(%eax)
		mov dword[err_] , eax
    7e35:	66                   	data16
    7e36:	a3                   	.byte 0xa3
    7e37:	80                   	.byte 0x80
    7e38:	83                   	.byte 0x83
    7e39:	c3                   	ret    

00007e3a <_simple_print_boot__>:
    uint32_t type;
    uint32_t ext_attrib;
} __attribute__((packed)) e820_mem;

void _simple_print_boot__(char* msg)
{
    7e3a:	66 55                	push   %bp
    7e3c:	66 89 e5             	mov    %sp,%bp
    7e3f:	66 53                	push   %bx
    7e41:	66 83 ec 10          	sub    $0x10,%sp
    int i = 0;
    7e45:	67 66 c7 45 f8 00 00 	movw   $0x0,-0x8(%di)
    7e4c:	00 00                	add    %al,(%eax)

    while (msg[i] != '\0') {
    7e4e:	eb 2a                	jmp    7e7a <_simple_print_boot__+0x40>
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
    7e50:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7e55:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7e5a:	66 01 d0             	add    %dx,%ax
    7e5d:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7e62:	66 0f be c0          	movsbw %al,%ax
    7e66:	80 cc 0e             	or     $0xe,%ah
    7e69:	66 ba 07 00          	mov    $0x7,%dx
    7e6d:	00 00                	add    %al,(%eax)
    7e6f:	66 89 d3             	mov    %dx,%bx
    7e72:	cd 10                	int    $0x10
        ++i;
    7e74:	67 66 83 45 f8 01    	addw   $0x1,-0x8(%di)
    while (msg[i] != '\0') {
    7e7a:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7e7f:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7e84:	66 01 d0             	add    %dx,%ax
    7e87:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7e8c:	84 c0                	test   %al,%al
    7e8e:	75 c0                	jne    7e50 <_simple_print_boot__+0x16>
    }
}
    7e90:	90                   	nop
    7e91:	90                   	nop
    7e92:	67 66 8b 5d fc       	mov    -0x4(%di),%bx
    7e97:	66 c9                	leavew 
    7e99:	66 c3                	retw   

00007e9b <memset>:

void* memset(void* addr, uint8_t data, size_t size)
{
    7e9b:	66 55                	push   %bp
    7e9d:	66 89 e5             	mov    %sp,%bp
    7ea0:	66 57                	push   %di
    7ea2:	66 83 ec 04          	sub    $0x4,%sp
    7ea6:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    7eab:	67 88 45 f8          	mov    %al,-0x8(%di)
    __asm__("cld; rep stosb\n" ::"D"(addr), "a"(data), "c"(size)
    7eaf:	67 66 8b 55 08       	mov    0x8(%di),%dx
    7eb4:	67 66 0f b6 45 f8    	movzbw -0x8(%di),%ax
    7eba:	67 66 8b 4d 10       	mov    0x10(%di),%cx
    7ebf:	66 89 d7             	mov    %dx,%di
    7ec2:	fc                   	cld    
    7ec3:	f3 aa                	rep stos %al,%es:(%edi)
            : "cc", "memory");

    return addr;
    7ec5:	67 66 8b 45 08       	mov    0x8(%di),%ax
}
    7eca:	67 66 8b 7d fc       	mov    -0x4(%di),%di
    7ecf:	66 c9                	leavew 
    7ed1:	66 c3                	retw   

00007ed3 <memcpy>:

void* memcpy(void* dest, void* src, size_t size)
{
    7ed3:	66 55                	push   %bp
    7ed5:	66 89 e5             	mov    %sp,%bp
    7ed8:	66 83 ec 10          	sub    $0x10,%sp
    int i = 0;
    7edc:	67 66 c7 45 fc 00 00 	movw   $0x0,-0x4(%di)
    7ee3:	00 00                	add    %al,(%eax)

    char *d = (char*)dest, *s = (char*)src;
    7ee5:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7eea:	67 66 89 45 f8       	mov    %ax,-0x8(%di)
    7eef:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    7ef4:	67 66 89 45 f4       	mov    %ax,-0xc(%di)

    while (i < size) {
    7ef9:	eb 28                	jmp    7f23 <memcpy+0x50>
        d[i] = s[i];
    7efb:	67 66 8b 55 fc       	mov    -0x4(%di),%dx
    7f00:	67 66 8b 45 f4       	mov    -0xc(%di),%ax
    7f05:	66 01 d0             	add    %dx,%ax
    7f08:	67 66 8b 4d fc       	mov    -0x4(%di),%cx
    7f0d:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7f12:	66 01 ca             	add    %cx,%dx
    7f15:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7f1a:	67 88 02             	mov    %al,(%bp,%si)
        i++;
    7f1d:	67 66 83 45 fc 01    	addw   $0x1,-0x4(%di)
    while (i < size) {
    7f23:	67 66 8b 45 fc       	mov    -0x4(%di),%ax
    7f28:	67 66 39 45 10       	cmp    %ax,0x10(%di)
    7f2d:	77 cc                	ja     7efb <memcpy+0x28>
    }
    return dest;
    7f2f:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7f34:	66 c9                	leavew 
    7f36:	66 c3                	retw   

00007f38 <error_message>:
bios_info int bootdrive;

void* kernel_link;

void error_message(char* message)
{
    7f38:	66 55                	push   %bp
    7f3a:	66 89 e5             	mov    %sp,%bp
    _simple_print_boot__(message);
    7f3d:	67 66 ff 75 08       	pushw  0x8(%di)
    7f42:	66 e8 f2 fe          	callw  7e38 <reset_disk.disk_err_+0x9>
    7f46:	ff                   	(bad)  
    7f47:	ff 66 83             	jmp    *-0x7d(%esi)
    7f4a:	c4 04 66             	les    (%esi,%eiz,2),%eax
    err_ = 0;
    7f4d:	c7 06 80 83 00 00    	movl   $0x8380,(%esi)
    7f53:	00 00                	add    %al,(%eax)
    __asm__("hlt");
    7f55:	f4                   	hlt    
}
    7f56:	90                   	nop
    7f57:	66 c9                	leavew 
    7f59:	66 c3                	retw   

00007f5b <free_mem_bios_info>:

void free_mem_bios_info()
{
    7f5b:	66 55                	push   %bp
    7f5d:	66 89 e5             	mov    %sp,%bp
    memset((void*)(&bios_info_begin), 0, (&bios_info_end - &bios_info_begin));
    7f60:	66 b8 0e 85          	mov    $0x850e,%ax
    7f64:	00 00                	add    %al,(%eax)
    7f66:	66 2d 84 83          	sub    $0x8384,%ax
    7f6a:	00 00                	add    %al,(%eax)
    7f6c:	66 c1 f8 02          	sar    $0x2,%ax
    7f70:	66 50                	push   %ax
    7f72:	66 6a 00             	pushw  $0x0
    7f75:	66 68 84 83          	pushw  $0x8384
    7f79:	00 00                	add    %al,(%eax)
    7f7b:	66 e8 1a ff          	callw  7e99 <_simple_print_boot__+0x5f>
    7f7f:	ff                   	(bad)  
    7f80:	ff 66 83             	jmp    *-0x7d(%esi)
    7f83:	c4 0c 90             	les    (%eax,%edx,4),%ecx
}
    7f86:	66 c9                	leavew 
    7f88:	66 c3                	retw   

00007f8a <main>:

void main()
{
    7f8a:	67 66 8d 4c 24       	lea    0x24(%si),%cx
    7f8f:	04 66                	add    $0x66,%al
    7f91:	83 e4 f0             	and    $0xfffffff0,%esp
    7f94:	67 66 ff 71 fc       	pushw  -0x4(%bx,%di)
    7f99:	66 55                	push   %bp
    7f9b:	66 89 e5             	mov    %sp,%bp
    7f9e:	66 51                	push   %cx
    7fa0:	66 83 ec 04          	sub    $0x4,%sp

    err_ = 0;
    7fa4:	66 c7 06 80 83       	movw   $0x8380,(%esi)
    7fa9:	00 00                	add    %al,(%eax)
    7fab:	00 00                	add    %al,(%eax)

    enable_a20();
    7fad:	66 e8 8d 00          	callw  803e <main+0xb4>
    7fb1:	00 00                	add    %al,(%eax)

    if (err_ == 1) error_message("A20 disabled\n");
    7fb3:	66 a1 80 83 66 83    	mov    0x83668380,%ax
    7fb9:	f8                   	clc    
    7fba:	01 75 14             	add    %esi,0x14(%ebp)
    7fbd:	66 83 ec 0c          	sub    $0xc,%sp
    7fc1:	66 68 10 85          	pushw  $0x8510
    7fc5:	00 00                	add    %al,(%eax)
    7fc7:	66 e8 6b ff          	callw  7f36 <memcpy+0x63>
    7fcb:	ff                   	(bad)  
    7fcc:	ff 66 83             	jmp    *-0x7d(%esi)
    7fcf:	c4 10                	les    (%eax),%edx

    init_gdt();
    7fd1:	66 e8 ff 01          	callw  81d4 <init_gdt_entry+0xcc>
    7fd5:	00 00                	add    %al,(%eax)

    load_gdt();
    7fd7:	66 e8 99 02          	callw  8274 <gdtr+0x4>
    7fdb:	00 00                	add    %al,(%eax)

    load_e820_mem_table();
    7fdd:	66 e8 e1 02          	callw  82c2 <int_loop+0x2>
    7fe1:	00 00                	add    %al,(%eax)

    if (err_ == 1) error_message("E820 doesn't enable\n");
    7fe3:	66 a1 80 83 66 83    	mov    0x83668380,%ax
    7fe9:	f8                   	clc    
    7fea:	01 75 14             	add    %esi,0x14(%ebp)
    7fed:	66 83 ec 0c          	sub    $0xc,%sp
    7ff1:	66 68 1e 85          	pushw  $0x851e
    7ff5:	00 00                	add    %al,(%eax)
    7ff7:	66 e8 3b ff          	callw  7f36 <memcpy+0x63>
    7ffb:	ff                   	(bad)  
    7ffc:	ff 66 83             	jmp    *-0x7d(%esi)
    7fff:	c4 10                	les    (%eax),%edx

    read_sectors(); //Load kernel at the good space
    8001:	66 e8 05 fe          	callw  7e0a <entry+0xa>
    8005:	ff                   	(bad)  
    8006:	ff 66 a1             	jmp    *-0x5f(%esi)

    //Load some information of BIOS In kernel memory

    if (err_ == 1) error_message("E820 doesn't supported by your firmware");
    8009:	80 83 66 83 f8 01 75 	addb   $0x75,0x1f88366(%ebx)
    8010:	14 66                	adc    $0x66,%al
    8012:	83 ec 0c             	sub    $0xc,%esp
    8015:	66 68 34 85          	pushw  $0x8534
    8019:	00 00                	add    %al,(%eax)
    801b:	66 e8 17 ff          	callw  7f36 <memcpy+0x63>
    801f:	ff                   	(bad)  
    8020:	ff 66 83             	jmp    *-0x7d(%esi)
    8023:	c4 10                	les    (%eax),%edx

    //-----------------------------------------------

    _simple_print_boot__("_");
    8025:	66 83 ec 0c          	sub    $0xc,%sp
    8029:	66 68 5c 85          	pushw  $0x855c
    802d:	00 00                	add    %al,(%eax)
    802f:	66 e8 05 fe          	callw  7e38 <reset_disk.disk_err_+0x9>
    8033:	ff                   	(bad)  
    8034:	ff 66 83             	jmp    *-0x7d(%esi)
    8037:	c4 10                	les    (%eax),%edx

end:
    goto end;
    8039:	eb fe                	jmp    8039 <main+0xaf>
    803b:	66 90                	xchg   %ax,%ax
    803d:	66 90                	xchg   %ax,%ax
    803f:	90                   	nop

00008040 <enable_a20>:
extern err_

section .text

enable_a20:
    call check_a20
    8040:	e8 27 00 83 f8       	call   f883806c <END_SECOND_BOOT+0xf882f06c>
    cmp ax, 1
    8045:	01 74 6d e8          	add    %esi,-0x18(%ebp,%ebp,2)
    je enabled
    call a20_bios
    8049:	5d                   	pop    %ebp
    804a:	00 e8                	add    %ch,%al
    call check_a20
    804c:	1c 00                	sbb    $0x0,%al
    cmp ax, 1
    804e:	83 f8 01             	cmp    $0x1,%eax
    je enabled
    8051:	74 62                	je     80b5 <enabled>
    call a20_keyboard
    8053:	e8 66 00 e8 11       	call   11e880be <END_SECOND_BOOT+0x11e7f0be>
    call check_a20
    8058:	00 83 f8 01 74 57    	add    %al,0x577401f8(%ebx)
    cmp ax, 1
    je enabled
    call a20_fast
    805e:	e8 4d 00 e8 06       	call   6e880b0 <END_SECOND_BOOT+0x6e7f0b0>
    call check_a20
    8063:	00 83 f8 01 74 4c    	add    %al,0x4c7401f8(%ebx)
    cmp ax, 1
    je enabled
	ret
    8069:	c3                   	ret    

0000806a <check_a20>:

check_a20:
    pushf
    806a:	9c                   	pushf  
    push ds
    806b:	1e                   	push   %ds
    push es
    806c:	06                   	push   %es
    push di
    806d:	57                   	push   %edi
    push si
    806e:	56                   	push   %esi

    cli
    806f:	fa                   	cli    
    xor ax, ax ; ax = 0
    8070:	31 c0                	xor    %eax,%eax
    mov es, ax
    8072:	8e c0                	mov    %eax,%es
    not ax ; ax = 0xFFFF
    8074:	f7 d0                	not    %eax
    mov ds, ax
    8076:	8e d8                	mov    %eax,%ds
    mov di, 0x0500
    8078:	bf 00 05 be 10       	mov    $0x10be0500,%edi
    mov si, 0x0510
    807d:	05 26 8a 05 50       	add    $0x50058a26,%eax
    mov al, byte [es:di]
    push ax
    mov al, byte [ds:si]
    8082:	3e 8a 04 50          	mov    %ds:(%eax,%edx,2),%al
    push ax
    mov byte [es:di], 0x00
    8086:	26 c6 05 00 3e c6 04 	movb   $0xff,%es:0x4c63e00
    808d:	ff 
    mov byte [ds:si], 0xFF
    cmp byte [es:di], 0xFF
    808e:	26 80 3d ff 58 3e 88 	cmpb   $0x4,%es:0x883e58ff
    8095:	04 
    pop ax
    mov byte [ds:si], al
    pop ax
    8096:	58                   	pop    %eax
    mov byte [es:di], al
    8097:	26 88 05 b8 00 00 74 	mov    %al,%es:0x740000b8
    mov ax, 0
    je check_a20__exit
    809e:	03                   	.byte 0x3
    mov ax, 1   ;A20 is enabled
    809f:	b8                   	.byte 0xb8
    80a0:	01 00                	add    %eax,(%eax)

000080a2 <check_a20__exit>:

check_a20__exit:
    pop si
    80a2:	5e                   	pop    %esi
    pop di
    80a3:	5f                   	pop    %edi
    pop es
    80a4:	07                   	pop    %es
    pop ds
    80a5:	1f                   	pop    %ds
    popf
    80a6:	9d                   	popf   
    ret
    80a7:	c3                   	ret    

000080a8 <a20_bios>:

a20_bios:
    mov ax, 0x2401
    80a8:	b8 01 24 cd 15       	mov    $0x15cd2401,%eax
    int 0x15
    ret
    80ad:	c3                   	ret    

000080ae <a20_fast>:

a20_fast:
    in al, 0x92
    80ae:	e4 92                	in     $0x92,%al
    or al, 2
    80b0:	0c 02                	or     $0x2,%al
    out 0x92, al
    80b2:	e6 92                	out    %al,$0x92
    ret
    80b4:	c3                   	ret    

000080b5 <enabled>:

enabled:

	mov ax , 0
    80b5:	b8 00 00 a3 80       	mov    $0x80a30000,%eax
	mov word[err_] , ax
    80ba:	83                   	.byte 0x83
    ret
    80bb:	c3                   	ret    

000080bc <a20_keyboard>:

[bits 32]
    

a20_keyboard:
    cli
    80bc:	fa                   	cli    

    call    a20wait
    80bd:	e8 38 00 00 00       	call   80fa <a20wait>
    mov     al,0xAD
    80c2:	b0 ad                	mov    $0xad,%al
    out     0x64,al
    80c4:	e6 64                	out    %al,$0x64
    call    a20wait
    80c6:	e8 2f 00 00 00       	call   80fa <a20wait>
    mov     al,0xD0
    80cb:	b0 d0                	mov    $0xd0,%al
    out     0x64,al
    80cd:	e6 64                	out    %al,$0x64
    call    a20wait2
    80cf:	e8 2d 00 00 00       	call   8101 <a20wait2>
    in      al,0x60
    80d4:	e4 60                	in     $0x60,%al
    push    eax
    80d6:	50                   	push   %eax
    call    a20wait
    80d7:	e8 1e 00 00 00       	call   80fa <a20wait>
    mov     al,0xD1
    80dc:	b0 d1                	mov    $0xd1,%al
    out     0x64,al
    80de:	e6 64                	out    %al,$0x64
    call    a20wait
    80e0:	e8 15 00 00 00       	call   80fa <a20wait>
    pop     eax
    80e5:	58                   	pop    %eax
    or      al,2
    80e6:	0c 02                	or     $0x2,%al
    out     0x60,al
    80e8:	e6 60                	out    %al,$0x60
    call    a20wait
    80ea:	e8 0b 00 00 00       	call   80fa <a20wait>
    mov     al,0xAE
    80ef:	b0 ae                	mov    $0xae,%al
    out     0x64,al
    80f1:	e6 64                	out    %al,$0x64
    call    a20wait
    80f3:	e8 02 00 00 00       	call   80fa <a20wait>
    sti
    80f8:	fb                   	sti    
    ret
    80f9:	c3                   	ret    

000080fa <a20wait>:

a20wait:
    in      al,0x64
    80fa:	e4 64                	in     $0x64,%al
    test    al,2
    80fc:	a8 02                	test   $0x2,%al
    jnz     a20wait
    80fe:	75 fa                	jne    80fa <a20wait>
    ret
    8100:	c3                   	ret    

00008101 <a20wait2>:

a20wait2:
    in      al,0x64
    8101:	e4 64                	in     $0x64,%al
    test    al,1
    8103:	a8 01                	test   $0x1,%al
    jz      a20wait2
    8105:	74 fa                	je     8101 <a20wait2>
    8107:	c3                   	ret    

00008108 <init_gdt_entry>:
#include "gdt.h"

gdt_entry_desc __gdt_entry__[0xFF];

static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    8108:	66 55                	push   %bp
    810a:	66 89 e5             	mov    %sp,%bp
    810d:	66 83 ec 08          	sub    $0x8,%sp
    8111:	67 66 8b 55 10       	mov    0x10(%di),%dx
    8116:	67 66 8b 45 14       	mov    0x14(%di),%ax
    811b:	67 88 55 fc          	mov    %dl,-0x4(%di)
    811f:	67 88 45 f8          	mov    %al,-0x8(%di)
    desc->lim0_15 = (limite & 0xFFFF);
    8123:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    8128:	66 89 c2             	mov    %ax,%dx
    812b:	67 66 8b 45 18       	mov    0x18(%di),%ax
    8130:	67 89 10             	mov    %edx,(%bx,%si)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    8133:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    8138:	66 c1 e8 10          	shr    $0x10,%ax
    813c:	66 83 e0 0f          	and    $0xf,%ax
    8140:	67 66 8b 55 18       	mov    0x18(%di),%dx
    8145:	66 83 e0 0f          	and    $0xf,%ax
    8149:	66 89 c1             	mov    %ax,%cx
    814c:	67 66 0f b6 42 06    	movzbw 0x6(%bp,%si),%ax
    8152:	66 83 e0 f0          	and    $0xfff0,%ax
    8156:	66 09 c8             	or     %cx,%ax
    8159:	67 88 42 06          	mov    %al,0x6(%bp,%si)

    desc->base0_15 = (base & 0xFFFF);
    815d:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8162:	66 89 c2             	mov    %ax,%dx
    8165:	67 66 8b 45 18       	mov    0x18(%di),%ax
    816a:	67 89 50 02          	mov    %edx,0x2(%bx,%si)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    816e:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8173:	66 c1 e8 10          	shr    $0x10,%ax
    8177:	66 89 c2             	mov    %ax,%dx
    817a:	67 66 8b 45 18       	mov    0x18(%di),%ax
    817f:	67 88 50 04          	mov    %dl,0x4(%bx,%si)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    8183:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8188:	66 c1 e8 18          	shr    $0x18,%ax
    818c:	66 89 c2             	mov    %ax,%dx
    818f:	67 66 8b 45 18       	mov    0x18(%di),%ax
    8194:	67 88 50 07          	mov    %dl,0x7(%bx,%si)

    desc->flags = flags;
    8198:	67 66 0f b6 45 f8    	movzbw -0x8(%di),%ax
    819e:	66 83 e0 0f          	and    $0xf,%ax
    81a2:	66 89 c2             	mov    %ax,%dx
    81a5:	67 66 8b 45 18       	mov    0x18(%di),%ax
    81aa:	66 89 d1             	mov    %dx,%cx
    81ad:	66 c1 e1 04          	shl    $0x4,%cx
    81b1:	67 66 0f b6 50 06    	movzbw 0x6(%bx,%si),%dx
    81b7:	66 83 e2 0f          	and    $0xf,%dx
    81bb:	66 09 ca             	or     %cx,%dx
    81be:	67 88 50 06          	mov    %dl,0x6(%bx,%si)
    desc->acces_byte = access;
    81c2:	67 66 8b 45 18       	mov    0x18(%di),%ax
    81c7:	67 66 0f b6 55 fc    	movzbw -0x4(%di),%dx
    81cd:	67 88 50 05          	mov    %dl,0x5(%bx,%si)
}
    81d1:	90                   	nop
    81d2:	66 c9                	leavew 
    81d4:	66 c3                	retw   

000081d6 <init_gdt>:

void init_gdt(void)
{
    81d6:	66 55                	push   %bp
    81d8:	66 89 e5             	mov    %sp,%bp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    81db:	66 68 c0 86          	pushw  $0x86c0
    81df:	00 00                	add    %al,(%eax)
    81e1:	66 6a 00             	pushw  $0x0
    81e4:	66 6a 00             	pushw  $0x0
    81e7:	66 6a 00             	pushw  $0x0
    81ea:	66 6a 00             	pushw  $0x0
    81ed:	66 e8 15 ff          	callw  8106 <a20wait2+0x5>
    81f1:	ff                   	(bad)  
    81f2:	ff 66 83             	jmp    *-0x7d(%esi)
    81f5:	c4 14 66             	les    (%esi,%eiz,2),%edx

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    81f8:	68 c8 86 00 00       	push   $0x86c8
    81fd:	66 6a 04             	pushw  $0x4
    8200:	66 68 9a 00          	pushw  $0x9a
    8204:	00 00                	add    %al,(%eax)
    8206:	66 68 ff ff          	pushw  $0xffff
    820a:	0f 00 66 6a          	verr   0x6a(%esi)
    820e:	00 66 e8             	add    %ah,-0x18(%esi)
    8211:	f3 fe                	repz (bad) 
    8213:	ff                   	(bad)  
    8214:	ff 66 83             	jmp    *-0x7d(%esi)
    8217:	c4 14 66             	les    (%esi,%eiz,2),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    821a:	68 d0 86 00 00       	push   $0x86d0
    821f:	66 6a 04             	pushw  $0x4
    8222:	66 68 92 00          	pushw  $0x92
    8226:	00 00                	add    %al,(%eax)
    8228:	66 68 ff ff          	pushw  $0xffff
    822c:	0f 00 66 6a          	verr   0x6a(%esi)
    8230:	00 66 e8             	add    %ah,-0x18(%esi)
    8233:	d1 fe                	sar    %esi
    8235:	ff                   	(bad)  
    8236:	ff 66 83             	jmp    *-0x7d(%esi)
    8239:	c4 14 66             	les    (%esi,%eiz,2),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    823c:	68 d8 86 00 00       	push   $0x86d8
    8241:	66 6a 04             	pushw  $0x4
    8244:	66 68 96 00          	pushw  $0x96
    8248:	00 00                	add    %al,(%eax)
    824a:	66 68 ff ff          	pushw  $0xffff
    824e:	0f 00 66 6a          	verr   0x6a(%esi)
    8252:	00 66 e8             	add    %ah,-0x18(%esi)
    8255:	af                   	scas   %es:(%edi),%eax
    8256:	fe                   	(bad)  
    8257:	ff                   	(bad)  
    8258:	ff 66 83             	jmp    *-0x7d(%esi)
    825b:	c4 14 90             	les    (%eax,%edx,4),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);
}
    825e:	66 c9                	leavew 
    8260:	66 c3                	retw   
    8262:	66 90                	xchg   %ax,%ax
    8264:	66 90                	xchg   %ax,%ax
    8266:	66 90                	xchg   %ax,%ax
    8268:	66 90                	xchg   %ax,%ax
    826a:	66 90                	xchg   %ax,%ax
    826c:	66 90                	xchg   %ax,%ax
    826e:	66 90                	xchg   %ax,%ax

00008270 <gdtr>:
bits 16
extern __gdt_entry__
global load_gdt , jump_kernel

gdtr dw 0	;for limit
    8270:	00 00 00 00 00 00                                   ......

00008276 <load_gdt>:

section .text


load_gdt:
		cli
    8276:	fa                   	cli    
		cld
    8277:	fc                   	cld    
		mov ecx , 4*255
    8278:	66 b9 fc 03          	mov    $0x3fc,%cx
    827c:	00 00                	add    %al,(%eax)
		mov eax , __gdt_entry__
    827e:	66 b8 c0 86          	mov    $0x86c0,%ax
    8282:	00 00                	add    %al,(%eax)
		add eax , ecx
    8284:	66 01 c8             	add    %cx,%ax
		mov word[gdtr] , ax
    8287:	a3 70 82 66 b9       	mov    %eax,0xb9668270

		mov ecx , __gdt_entry__
    828c:	c0 86 00 00 66 89 0e 	rolb   $0xe,-0x769a0000(%esi)
		mov dword[gdtr+2] , ecx
    8293:	72 82                	jb     8217 <init_gdt+0x41>

		lgdt [gdtr]
    8295:	0f 01 16             	lgdtl  (%esi)
    8298:	70 82                	jo     821c <init_gdt+0x46>

		mov eax, cr0
    829a:	0f 20 c0             	mov    %cr0,%eax
    	or al, 1
    829d:	0c 01                	or     $0x1,%al
 		mov cr0, eax
    829f:	0f 22 c0             	mov    %eax,%cr0

		jmp 0x08:long_jump_
    82a2:	ea                   	.byte 0xea
    82a3:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
    82a4:	82 08 00             	orb    $0x0,(%eax)

000082a7 <long_jump_>:

	bits 32
		 long_jump_:

		;reload segment
		mov ax , 0x10
    82a7:	66 b8 10 00          	mov    $0x10,%ax
		mov ds , ax
    82ab:	8e d8                	mov    %eax,%ds
		mov es , ax
    82ad:	8e c0                	mov    %eax,%es
		mov fs , ax
    82af:	8e e0                	mov    %eax,%fs
		mov gs , ax
    82b1:	8e e8                	mov    %eax,%gs

		mov ax , 0x18
    82b3:	66 b8 18 00          	mov    $0x18,%ax
		mov ss , ax
    82b7:	8e d0                	mov    %eax,%ss

000082b9 <end_>:
		;---------------

		

    82b9:	eb fe                	jmp    82b9 <end_>
    82bb:	66 90                	xchg   %ax,%ax
    82bd:	66 90                	xchg   %ax,%ax
    82bf:	90                   	nop

000082c0 <int_loop>:

extern err_ , e820_mem_table

global load_e820_mem_table , int_loop

int_loop dd 0
    82c0:	00 00                	add    %al,(%eax)
	...

000082c4 <load_e820_mem_table>:


section .text

load_e820_mem_table:
	mov di, e820_mem_table         ; Set di to e820_mem_table address. Otherwise this code will get stuck in `int 0x15` after some entries are fetched 
    82c4:	bf a0 83 83 c7       	mov    $0xc78383a0,%edi
	add di , 24
    82c9:	18 66 31             	sbb    %ah,0x31(%esi)
	xor ebx, ebx		; ebx must be 0 to start
    82cc:	db 31                	(bad)  (%ecx)
	xor bp, bp		; keep an entry count in bp
    82ce:	ed                   	in     (%dx),%eax
	mov edx, 0x0534D4150	; Place "SMAP" into edx
    82cf:	66 ba 50 41          	mov    $0x4150,%dx
    82d3:	4d                   	dec    %ebp
    82d4:	53                   	push   %ebx
	mov eax, 0xe820
    82d5:	66 b8 20 e8          	mov    $0xe820,%ax
    82d9:	00 00                	add    %al,(%eax)
	mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
    82db:	26 66 c7 45 14 01 00 	movw   $0x1,%es:0x14(%ebp)
    82e2:	00 00                	add    %al,(%eax)
	mov ecx, 24		; ask for 24 bytes
    82e4:	66 b9 18 00          	mov    $0x18,%cx
    82e8:	00 00                	add    %al,(%eax)
	int 0x15
    82ea:	cd 15                	int    $0x15
	jc short .failed	; carry set on first call means "unsupported function"
    82ec:	72 71                	jb     835f <load_e820_mem_table.failed>
	mov edx, 0x0534D4150	; Some BIOSes apparently trash this register?
    82ee:	66 ba 50 41          	mov    $0x4150,%dx
    82f2:	4d                   	dec    %ebp
    82f3:	53                   	push   %ebx
	cmp eax, edx		; on success, eax must have been reset to "SMAP"
    82f4:	66 39 d0             	cmp    %dx,%ax
	jne short .failed
    82f7:	75 66                	jne    835f <load_e820_mem_table.failed>
	test ebx, ebx		; ebx = 0 implies list is only 1 entry long (worthless)
    82f9:	66 85 db             	test   %bx,%bx
	je short .failed
    82fc:	74 61                	je     835f <load_e820_mem_table.failed>
	jmp short .jmpin
    82fe:	eb 1f                	jmp    831f <load_e820_mem_table.jmpin>

00008300 <load_e820_mem_table.e820lp>:
.e820lp:
	mov eax, 0xe820		; eax, ecx get trashed on every int 0x15 call
    8300:	66 b8 20 e8          	mov    $0xe820,%ax
    8304:	00 00                	add    %al,(%eax)
	mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
    8306:	26 66 c7 45 14 01 00 	movw   $0x1,%es:0x14(%ebp)
    830d:	00 00                	add    %al,(%eax)
	mov ecx, 24		; ask for 24 bytes again
    830f:	66 b9 18 00          	mov    $0x18,%cx
    8313:	00 00                	add    %al,(%eax)
	int 0x15
    8315:	cd 15                	int    $0x15
	jc short .e820f		; carry set means "end of list already reached"
    8317:	72 44                	jb     835d <load_e820_mem_table.e820f>
	mov edx, 0x0534D4150	; repair potentially trashed register
    8319:	66 ba 50 41          	mov    $0x4150,%dx
    831d:	4d                   	dec    %ebp
    831e:	53                   	push   %ebx

0000831f <load_e820_mem_table.jmpin>:
.jmpin:
	jcxz .skipent		; skip any 0 length entries
    831f:	e3 1c                	jecxz  833d <load_e820_mem_table.skipent>
	cmp cl, 20		; got a 24 byte ACPI 3.X response?
    8321:	80 f9 14             	cmp    $0x14,%cl
	jbe short .notext
    8324:	76 07                	jbe    832d <load_e820_mem_table.notext>
	test byte [es:di + 20], 1	; if so: is the "ignore this data" bit clear?
    8326:	26 f6 45 14 01       	testb  $0x1,%es:0x14(%ebp)
	je short .skipent
    832b:	74 10                	je     833d <load_e820_mem_table.skipent>

0000832d <load_e820_mem_table.notext>:
.notext:
	mov ecx, [es:di + 8]	; get lower uint32_t of memory region length
    832d:	26 66 8b 4d 08       	mov    %es:0x8(%ebp),%cx
	or ecx, [es:di + 12]	; "or" it with upper uint32_t to test for zero
    8332:	26 66 0b 4d 0c       	or     %es:0xc(%ebp),%cx
	jz .skipent		; if length uint64_t is 0, skip entry
    8337:	74 04                	je     833d <load_e820_mem_table.skipent>
	inc bp			; got a good entry: ++count, move to next storage spot
    8339:	45                   	inc    %ebp
	add di, 24
    833a:	83 c7 18             	add    $0x18,%edi

0000833d <load_e820_mem_table.skipent>:
.skipent:

	;check if we have at the end of the memory
	mov ecx , dword[es:di]
    833d:	26 66 8b 0d 26 66 03 	mov    %es:0x4d036626,%cx
    8344:	4d 
	add ecx , dword[es:di+8]
    8345:	08 66 83             	or     %ah,-0x7d(%esi)
	cmp ecx , 0xFFFFFFFF
    8348:	f9                   	stc    
    8349:	ff 74 11 66          	pushl  0x66(%ecx,%edx,1)
	jz .e820f

	mov ecx , dword[int_loop]
    834d:	8b 0e                	mov    (%esi),%ecx
    834f:	c0 82 66 41 66 89 0e 	rolb   $0xe,-0x7699be9a(%edx)
	inc ecx
	mov dword[int_loop] , ecx
    8356:	c0 82 66 85 db 75 a3 	rolb   $0xa3,0x75db8566(%edx)

0000835d <load_e820_mem_table.e820f>:

	test ebx, ebx		; if ebx resets to 0, list is complete
	jne short .e820lp
.e820f:
	clc			; there is "jc" on end of list to this point, so the carry must be cleared
    835d:	f8                   	clc    
	ret
    835e:	c3                   	ret    

0000835f <load_e820_mem_table.failed>:
.failed:
	stc			; "function unsupported" error exit
    835f:	f9                   	stc    
	mov eax , 1
    8360:	66 b8 01 00          	mov    $0x1,%ax
    8364:	00 00                	add    %al,(%eax)
	mov dword[err_] , eax
    8366:	66                   	data16
    8367:	a3                   	.byte 0xa3
    8368:	80                   	.byte 0x80
    8369:	83                   	.byte 0x83
    836a:	c3                   	ret    
