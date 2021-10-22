
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
    7e05:	66 a3 e8 84 e9 51    	mov    %ax,0x51e984e8
	;-----

	jmp main
    7e0b:	01                   	.byte 0x1

00007e0c <read_sectors>:

read_sectors:
		clc
    7e0c:	f8                   	clc    
		mov dl , [bootdrive]
    7e0d:	8a 16                	mov    (%esi),%dl
    7e0f:	e8                   	.byte 0xe8
    7e10:	84                   	.byte 0x84

00007e11 <reset_disk>:
		
	reset_disk:

		xor ax , ax
    7e11:	31 c0                	xor    %eax,%eax
		int 0x13
    7e13:	cd 13                	int    $0x13
		jc reset_disk
    7e15:	72 fa                	jb     7e11 <reset_disk>
		

		mov bx , 0x9000
    7e17:	bb 00 90 b6 28       	mov    $0x28b69000,%ebx

		mov dh , 40

		push dx
    7e1c:	52                   	push   %edx

		mov ah , 0x02       ; BIOS read sector function
    7e1d:	b4 02                	mov    $0x2,%ah
		mov al , dh         ; Read DH sectors
    7e1f:	88 f0                	mov    %dh,%al
		mov ch , 0x00       ; Select cylinder 0
    7e21:	b5 00                	mov    $0x0,%ch
		mov dh , 0x00       ; Select head 0
    7e23:	b6 00                	mov    $0x0,%dh
		mov cl , 0x06       ; Start reading from second sector ( i.e.
    7e25:	b1 06                	mov    $0x6,%cl
							; after the boot sector )

		int 0x13
    7e27:	cd 13                	int    $0x13

		jc .disk_err_
    7e29:	72 06                	jb     7e31 <reset_disk.disk_err_>

		pop dx
    7e2b:	5a                   	pop    %edx

		cmp dh , al
    7e2c:	38 c6                	cmp    %al,%dh
		jne .disk_err_
    7e2e:	75 01                	jne    7e31 <reset_disk.disk_err_>
		ret
    7e30:	c3                   	ret    

00007e31 <reset_disk.disk_err_>:

	.disk_err_:
		mov eax , 1
    7e31:	66 b8 01 00          	mov    $0x1,%ax
    7e35:	00 00                	add    %al,(%eax)
		mov dword[err_] , eax
    7e37:	66                   	data16
    7e38:	a3                   	.byte 0xa3
    7e39:	60                   	pusha  
    7e3a:	83                   	.byte 0x83
    7e3b:	c3                   	ret    

00007e3c <_simple_print_boot__>:
    uint32_t type;
    uint32_t ext_attrib;
} __attribute__((packed)) e820_mem;

void _simple_print_boot__(char* msg)
{
    7e3c:	66 55                	push   %bp
    7e3e:	66 89 e5             	mov    %sp,%bp
    7e41:	66 53                	push   %bx
    7e43:	66 83 ec 10          	sub    $0x10,%sp
    int i = 0;
    7e47:	67 66 c7 45 f8 00 00 	movw   $0x0,-0x8(%di)
    7e4e:	00 00                	add    %al,(%eax)

    while (msg[i] != '\0') {
    7e50:	eb 2a                	jmp    7e7c <_simple_print_boot__+0x40>
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
    7e52:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7e57:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7e5c:	66 01 d0             	add    %dx,%ax
    7e5f:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7e64:	66 0f be c0          	movsbw %al,%ax
    7e68:	80 cc 0e             	or     $0xe,%ah
    7e6b:	66 ba 07 00          	mov    $0x7,%dx
    7e6f:	00 00                	add    %al,(%eax)
    7e71:	66 89 d3             	mov    %dx,%bx
    7e74:	cd 10                	int    $0x10
        ++i;
    7e76:	67 66 83 45 f8 01    	addw   $0x1,-0x8(%di)
    while (msg[i] != '\0') {
    7e7c:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7e81:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7e86:	66 01 d0             	add    %dx,%ax
    7e89:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7e8e:	84 c0                	test   %al,%al
    7e90:	75 c0                	jne    7e52 <_simple_print_boot__+0x16>
    }
}
    7e92:	90                   	nop
    7e93:	90                   	nop
    7e94:	67 66 8b 5d fc       	mov    -0x4(%di),%bx
    7e99:	66 c9                	leavew 
    7e9b:	66 c3                	retw   

00007e9d <memset>:

void* memset(void* addr, uint8_t data, size_t size)
{
    7e9d:	66 55                	push   %bp
    7e9f:	66 89 e5             	mov    %sp,%bp
    7ea2:	66 57                	push   %di
    7ea4:	66 83 ec 04          	sub    $0x4,%sp
    7ea8:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    7ead:	67 88 45 f8          	mov    %al,-0x8(%di)
    __asm__("cld; rep stosb\n" ::"D"(addr), "a"(data), "c"(size)
    7eb1:	67 66 8b 55 08       	mov    0x8(%di),%dx
    7eb6:	67 66 0f b6 45 f8    	movzbw -0x8(%di),%ax
    7ebc:	67 66 8b 4d 10       	mov    0x10(%di),%cx
    7ec1:	66 89 d7             	mov    %dx,%di
    7ec4:	fc                   	cld    
    7ec5:	f3 aa                	rep stos %al,%es:(%edi)
            : "cc", "memory");

    return addr;
    7ec7:	67 66 8b 45 08       	mov    0x8(%di),%ax
}
    7ecc:	67 66 8b 7d fc       	mov    -0x4(%di),%di
    7ed1:	66 c9                	leavew 
    7ed3:	66 c3                	retw   

00007ed5 <memcpy>:

void* memcpy(void* dest, void* src, size_t size)
{
    7ed5:	66 55                	push   %bp
    7ed7:	66 89 e5             	mov    %sp,%bp
    7eda:	66 83 ec 10          	sub    $0x10,%sp
    int i = 0;
    7ede:	67 66 c7 45 fc 00 00 	movw   $0x0,-0x4(%di)
    7ee5:	00 00                	add    %al,(%eax)

    char *d = (char*)dest, *s = (char*)src;
    7ee7:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7eec:	67 66 89 45 f8       	mov    %ax,-0x8(%di)
    7ef1:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    7ef6:	67 66 89 45 f4       	mov    %ax,-0xc(%di)

    while (i < size) {
    7efb:	eb 28                	jmp    7f25 <memcpy+0x50>
        d[i] = s[i];
    7efd:	67 66 8b 55 fc       	mov    -0x4(%di),%dx
    7f02:	67 66 8b 45 f4       	mov    -0xc(%di),%ax
    7f07:	66 01 d0             	add    %dx,%ax
    7f0a:	67 66 8b 4d fc       	mov    -0x4(%di),%cx
    7f0f:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7f14:	66 01 ca             	add    %cx,%dx
    7f17:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7f1c:	67 88 02             	mov    %al,(%bp,%si)
        i++;
    7f1f:	67 66 83 45 fc 01    	addw   $0x1,-0x4(%di)
    while (i < size) {
    7f25:	67 66 8b 45 fc       	mov    -0x4(%di),%ax
    7f2a:	67 66 39 45 10       	cmp    %ax,0x10(%di)
    7f2f:	77 cc                	ja     7efd <memcpy+0x28>
    }
    return dest;
    7f31:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7f36:	66 c9                	leavew 
    7f38:	66 c3                	retw   

00007f3a <error_message>:
bios_info int bootdrive;

void* kernel_link;

void error_message(char* message)
{
    7f3a:	66 55                	push   %bp
    7f3c:	66 89 e5             	mov    %sp,%bp
    _simple_print_boot__(message);
    7f3f:	67 66 ff 75 08       	pushw  0x8(%di)
    7f44:	66 e8 f2 fe          	callw  7e3a <reset_disk.disk_err_+0x9>
    7f48:	ff                   	(bad)  
    7f49:	ff 66 83             	jmp    *-0x7d(%esi)
    7f4c:	c4 04 66             	les    (%esi,%eiz,2),%eax
    err_ = 0;
    7f4f:	c7 06 60 83 00 00    	movl   $0x8360,(%esi)
    7f55:	00 00                	add    %al,(%eax)
    __asm__("hlt");
    7f57:	f4                   	hlt    
}
    7f58:	90                   	nop
    7f59:	66 c9                	leavew 
    7f5b:	66 c3                	retw   

00007f5d <main>:

void main()
{
    7f5d:	67 66 8d 4c 24       	lea    0x24(%si),%cx
    7f62:	04 66                	add    $0x66,%al
    7f64:	83 e4 f0             	and    $0xfffffff0,%esp
    7f67:	67 66 ff 71 fc       	pushw  -0x4(%bx,%di)
    7f6c:	66 55                	push   %bp
    7f6e:	66 89 e5             	mov    %sp,%bp
    7f71:	66 51                	push   %cx
    7f73:	66 83 ec 04          	sub    $0x4,%sp

    err_ = 0;
    7f77:	66 c7 06 60 83       	movw   $0x8360,(%esi)
    7f7c:	00 00                	add    %al,(%eax)
    7f7e:	00 00                	add    %al,(%eax)

    enable_a20();
    7f80:	66 e8 8a 00          	callw  800e <main+0xb1>
    7f84:	00 00                	add    %al,(%eax)

    if (err_ == 1) error_message("A20 disabled");
    7f86:	66 a1 60 83 66 83    	mov    0x83668360,%ax
    7f8c:	f8                   	clc    
    7f8d:	01 75 14             	add    %esi,0x14(%ebp)
    7f90:	66 83 ec 0c          	sub    $0xc,%sp
    7f94:	66 68 f0 84          	pushw  $0x84f0
    7f98:	00 00                	add    %al,(%eax)
    7f9a:	66 e8 9a ff          	callw  7f38 <memcpy+0x63>
    7f9e:	ff                   	(bad)  
    7f9f:	ff 66 83             	jmp    *-0x7d(%esi)
    7fa2:	c4 10                	les    (%eax),%edx

    //Load some information of BIOS In kernel memory

    load_e820_mem_table();
    7fa4:	66 e8 fa 02          	callw  82a2 <int_loop+0x2>
    7fa8:	00 00                	add    %al,(%eax)

    if (err_ == 1) error_message("E820 doesn't supported by your firmware");
    7faa:	66 a1 60 83 66 83    	mov    0x83668360,%ax
    7fb0:	f8                   	clc    
    7fb1:	01 75 14             	add    %esi,0x14(%ebp)
    7fb4:	66 83 ec 0c          	sub    $0xc,%sp
    7fb8:	66 68 00 85          	pushw  $0x8500
    7fbc:	00 00                	add    %al,(%eax)
    7fbe:	66 e8 76 ff          	callw  7f38 <memcpy+0x63>
    7fc2:	ff                   	(bad)  
    7fc3:	ff 66 83             	jmp    *-0x7d(%esi)
    7fc6:	c4 10                	les    (%eax),%edx

    err_ = 0;
    7fc8:	66 c7 06 60 83       	movw   $0x8360,(%esi)
    7fcd:	00 00                	add    %al,(%eax)
    7fcf:	00 00                	add    %al,(%eax)

    init_gdt();
    7fd1:	66 e8 cf 01          	callw  81a4 <init_gdt_entry+0xcc>
    7fd5:	00 00                	add    %al,(%eax)

    read_sectors();
    7fd7:	66 e8 2f fe          	callw  7e0a <entry+0xa>
    7fdb:	ff                   	(bad)  
    7fdc:	ff 66 a1             	jmp    *-0x5f(%esi)

    if (err_ == 1) error_message("Kernel doesn't loaded\n");
    7fdf:	60                   	pusha  
    7fe0:	83 66 83 f8          	andl   $0xfffffff8,-0x7d(%esi)
    7fe4:	01 75 14             	add    %esi,0x14(%ebp)
    7fe7:	66 83 ec 0c          	sub    $0xc,%sp
    7feb:	66 68 28 85          	pushw  $0x8528
    7fef:	00 00                	add    %al,(%eax)
    7ff1:	66 e8 43 ff          	callw  7f38 <memcpy+0x63>
    7ff5:	ff                   	(bad)  
    7ff6:	ff 66 83             	jmp    *-0x7d(%esi)
    7ff9:	c4 10                	les    (%eax),%edx

    //-----------------------------------------------

    load_gdt(); //Load gdt and jump to kernel initializations
    7ffb:	66 e8 45 02          	callw  8244 <gdtr+0x4>
    7fff:	00 00                	add    %al,(%eax)
}
    8001:	90                   	nop
    8002:	67 66 8b 4d fc       	mov    -0x4(%di),%cx
    8007:	66 c9                	leavew 
    8009:	67 66 8d 61 fc       	lea    -0x4(%bx,%di),%sp
    800e:	66 c3                	retw   

00008010 <enable_a20>:
extern err_

section .text

enable_a20:
    call check_a20
    8010:	e8 27 00 83 f8       	call   f883803c <END_SECOND_BOOT+0xf882f03c>
    cmp ax, 1
    8015:	01 74 6d e8          	add    %esi,-0x18(%ebp,%ebp,2)
    je enabled
    call a20_bios
    8019:	5d                   	pop    %ebp
    801a:	00 e8                	add    %ch,%al
    call check_a20
    801c:	1c 00                	sbb    $0x0,%al
    cmp ax, 1
    801e:	83 f8 01             	cmp    $0x1,%eax
    je enabled
    8021:	74 62                	je     8085 <enabled>
    call a20_keyboard
    8023:	e8 66 00 e8 11       	call   11e8808e <END_SECOND_BOOT+0x11e7f08e>
    call check_a20
    8028:	00 83 f8 01 74 57    	add    %al,0x577401f8(%ebx)
    cmp ax, 1
    je enabled
    call a20_fast
    802e:	e8 4d 00 e8 06       	call   6e88080 <END_SECOND_BOOT+0x6e7f080>
    call check_a20
    8033:	00 83 f8 01 74 4c    	add    %al,0x4c7401f8(%ebx)
    cmp ax, 1
    je enabled
	ret
    8039:	c3                   	ret    

0000803a <check_a20>:

check_a20:
    pushf
    803a:	9c                   	pushf  
    push ds
    803b:	1e                   	push   %ds
    push es
    803c:	06                   	push   %es
    push di
    803d:	57                   	push   %edi
    push si
    803e:	56                   	push   %esi

    cli
    803f:	fa                   	cli    
    xor ax, ax ; ax = 0
    8040:	31 c0                	xor    %eax,%eax
    mov es, ax
    8042:	8e c0                	mov    %eax,%es
    not ax ; ax = 0xFFFF
    8044:	f7 d0                	not    %eax
    mov ds, ax
    8046:	8e d8                	mov    %eax,%ds
    mov di, 0x0500
    8048:	bf 00 05 be 10       	mov    $0x10be0500,%edi
    mov si, 0x0510
    804d:	05 26 8a 05 50       	add    $0x50058a26,%eax
    mov al, byte [es:di]
    push ax
    mov al, byte [ds:si]
    8052:	3e 8a 04 50          	mov    %ds:(%eax,%edx,2),%al
    push ax
    mov byte [es:di], 0x00
    8056:	26 c6 05 00 3e c6 04 	movb   $0xff,%es:0x4c63e00
    805d:	ff 
    mov byte [ds:si], 0xFF
    cmp byte [es:di], 0xFF
    805e:	26 80 3d ff 58 3e 88 	cmpb   $0x4,%es:0x883e58ff
    8065:	04 
    pop ax
    mov byte [ds:si], al
    pop ax
    8066:	58                   	pop    %eax
    mov byte [es:di], al
    8067:	26 88 05 b8 00 00 74 	mov    %al,%es:0x740000b8
    mov ax, 0
    je check_a20__exit
    806e:	03                   	.byte 0x3
    mov ax, 1   ;A20 is enabled
    806f:	b8                   	.byte 0xb8
    8070:	01 00                	add    %eax,(%eax)

00008072 <check_a20__exit>:

check_a20__exit:
    pop si
    8072:	5e                   	pop    %esi
    pop di
    8073:	5f                   	pop    %edi
    pop es
    8074:	07                   	pop    %es
    pop ds
    8075:	1f                   	pop    %ds
    popf
    8076:	9d                   	popf   
    ret
    8077:	c3                   	ret    

00008078 <a20_bios>:

a20_bios:
    mov ax, 0x2401
    8078:	b8 01 24 cd 15       	mov    $0x15cd2401,%eax
    int 0x15
    ret
    807d:	c3                   	ret    

0000807e <a20_fast>:

a20_fast:
    in al, 0x92
    807e:	e4 92                	in     $0x92,%al
    or al, 2
    8080:	0c 02                	or     $0x2,%al
    out 0x92, al
    8082:	e6 92                	out    %al,$0x92
    ret
    8084:	c3                   	ret    

00008085 <enabled>:

enabled:

	mov ax , 0
    8085:	b8 00 00 a3 60       	mov    $0x60a30000,%eax
	mov word[err_] , ax
    808a:	83                   	.byte 0x83
    ret
    808b:	c3                   	ret    

0000808c <a20_keyboard>:

[bits 32]
    

a20_keyboard:
    cli
    808c:	fa                   	cli    

    call    a20wait
    808d:	e8 38 00 00 00       	call   80ca <a20wait>
    mov     al,0xAD
    8092:	b0 ad                	mov    $0xad,%al
    out     0x64,al
    8094:	e6 64                	out    %al,$0x64
    call    a20wait
    8096:	e8 2f 00 00 00       	call   80ca <a20wait>
    mov     al,0xD0
    809b:	b0 d0                	mov    $0xd0,%al
    out     0x64,al
    809d:	e6 64                	out    %al,$0x64
    call    a20wait2
    809f:	e8 2d 00 00 00       	call   80d1 <a20wait2>
    in      al,0x60
    80a4:	e4 60                	in     $0x60,%al
    push    eax
    80a6:	50                   	push   %eax
    call    a20wait
    80a7:	e8 1e 00 00 00       	call   80ca <a20wait>
    mov     al,0xD1
    80ac:	b0 d1                	mov    $0xd1,%al
    out     0x64,al
    80ae:	e6 64                	out    %al,$0x64
    call    a20wait
    80b0:	e8 15 00 00 00       	call   80ca <a20wait>
    pop     eax
    80b5:	58                   	pop    %eax
    or      al,2
    80b6:	0c 02                	or     $0x2,%al
    out     0x60,al
    80b8:	e6 60                	out    %al,$0x60
    call    a20wait
    80ba:	e8 0b 00 00 00       	call   80ca <a20wait>
    mov     al,0xAE
    80bf:	b0 ae                	mov    $0xae,%al
    out     0x64,al
    80c1:	e6 64                	out    %al,$0x64
    call    a20wait
    80c3:	e8 02 00 00 00       	call   80ca <a20wait>
    sti
    80c8:	fb                   	sti    
    ret
    80c9:	c3                   	ret    

000080ca <a20wait>:

a20wait:
    in      al,0x64
    80ca:	e4 64                	in     $0x64,%al
    test    al,2
    80cc:	a8 02                	test   $0x2,%al
    jnz     a20wait
    80ce:	75 fa                	jne    80ca <a20wait>
    ret
    80d0:	c3                   	ret    

000080d1 <a20wait2>:

a20wait2:
    in      al,0x64
    80d1:	e4 64                	in     $0x64,%al
    test    al,1
    80d3:	a8 01                	test   $0x1,%al
    jz      a20wait2
    80d5:	74 fa                	je     80d1 <a20wait2>
    80d7:	c3                   	ret    

000080d8 <init_gdt_entry>:
#include "gdt.h"

gdt_entry_desc __gdt_entry__[0xFF];

static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    80d8:	66 55                	push   %bp
    80da:	66 89 e5             	mov    %sp,%bp
    80dd:	66 83 ec 08          	sub    $0x8,%sp
    80e1:	67 66 8b 55 10       	mov    0x10(%di),%dx
    80e6:	67 66 8b 45 14       	mov    0x14(%di),%ax
    80eb:	67 88 55 fc          	mov    %dl,-0x4(%di)
    80ef:	67 88 45 f8          	mov    %al,-0x8(%di)
    desc->lim0_15 = (limite & 0xFFFF);
    80f3:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    80f8:	66 89 c2             	mov    %ax,%dx
    80fb:	67 66 8b 45 18       	mov    0x18(%di),%ax
    8100:	67 89 10             	mov    %edx,(%bx,%si)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    8103:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    8108:	66 c1 e8 10          	shr    $0x10,%ax
    810c:	66 83 e0 0f          	and    $0xf,%ax
    8110:	67 66 8b 55 18       	mov    0x18(%di),%dx
    8115:	66 83 e0 0f          	and    $0xf,%ax
    8119:	66 89 c1             	mov    %ax,%cx
    811c:	67 66 0f b6 42 06    	movzbw 0x6(%bp,%si),%ax
    8122:	66 83 e0 f0          	and    $0xfff0,%ax
    8126:	66 09 c8             	or     %cx,%ax
    8129:	67 88 42 06          	mov    %al,0x6(%bp,%si)

    desc->base0_15 = (base & 0xFFFF);
    812d:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8132:	66 89 c2             	mov    %ax,%dx
    8135:	67 66 8b 45 18       	mov    0x18(%di),%ax
    813a:	67 89 50 02          	mov    %edx,0x2(%bx,%si)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    813e:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8143:	66 c1 e8 10          	shr    $0x10,%ax
    8147:	66 89 c2             	mov    %ax,%dx
    814a:	67 66 8b 45 18       	mov    0x18(%di),%ax
    814f:	67 88 50 04          	mov    %dl,0x4(%bx,%si)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    8153:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8158:	66 c1 e8 18          	shr    $0x18,%ax
    815c:	66 89 c2             	mov    %ax,%dx
    815f:	67 66 8b 45 18       	mov    0x18(%di),%ax
    8164:	67 88 50 07          	mov    %dl,0x7(%bx,%si)

    desc->flags = flags;
    8168:	67 66 0f b6 45 f8    	movzbw -0x8(%di),%ax
    816e:	66 83 e0 0f          	and    $0xf,%ax
    8172:	66 89 c2             	mov    %ax,%dx
    8175:	67 66 8b 45 18       	mov    0x18(%di),%ax
    817a:	66 89 d1             	mov    %dx,%cx
    817d:	66 c1 e1 04          	shl    $0x4,%cx
    8181:	67 66 0f b6 50 06    	movzbw 0x6(%bx,%si),%dx
    8187:	66 83 e2 0f          	and    $0xf,%dx
    818b:	66 09 ca             	or     %cx,%dx
    818e:	67 88 50 06          	mov    %dl,0x6(%bx,%si)
    desc->acces_byte = access;
    8192:	67 66 8b 45 18       	mov    0x18(%di),%ax
    8197:	67 66 0f b6 55 fc    	movzbw -0x4(%di),%dx
    819d:	67 88 50 05          	mov    %dl,0x5(%bx,%si)
}
    81a1:	90                   	nop
    81a2:	66 c9                	leavew 
    81a4:	66 c3                	retw   

000081a6 <init_gdt>:

void init_gdt(void)
{
    81a6:	66 55                	push   %bp
    81a8:	66 89 e5             	mov    %sp,%bp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    81ab:	66 68 a0 86          	pushw  $0x86a0
    81af:	00 00                	add    %al,(%eax)
    81b1:	66 6a 00             	pushw  $0x0
    81b4:	66 6a 00             	pushw  $0x0
    81b7:	66 6a 00             	pushw  $0x0
    81ba:	66 6a 00             	pushw  $0x0
    81bd:	66 e8 15 ff          	callw  80d6 <a20wait2+0x5>
    81c1:	ff                   	(bad)  
    81c2:	ff 66 83             	jmp    *-0x7d(%esi)
    81c5:	c4 14 66             	les    (%esi,%eiz,2),%edx

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    81c8:	68 a8 86 00 00       	push   $0x86a8
    81cd:	66 6a 04             	pushw  $0x4
    81d0:	66 68 9a 00          	pushw  $0x9a
    81d4:	00 00                	add    %al,(%eax)
    81d6:	66 68 ff ff          	pushw  $0xffff
    81da:	0f 00 66 6a          	verr   0x6a(%esi)
    81de:	00 66 e8             	add    %ah,-0x18(%esi)
    81e1:	f3 fe                	repz (bad) 
    81e3:	ff                   	(bad)  
    81e4:	ff 66 83             	jmp    *-0x7d(%esi)
    81e7:	c4 14 66             	les    (%esi,%eiz,2),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    81ea:	68 b0 86 00 00       	push   $0x86b0
    81ef:	66 6a 04             	pushw  $0x4
    81f2:	66 68 92 00          	pushw  $0x92
    81f6:	00 00                	add    %al,(%eax)
    81f8:	66 68 ff ff          	pushw  $0xffff
    81fc:	0f 00 66 6a          	verr   0x6a(%esi)
    8200:	00 66 e8             	add    %ah,-0x18(%esi)
    8203:	d1 fe                	sar    %esi
    8205:	ff                   	(bad)  
    8206:	ff 66 83             	jmp    *-0x7d(%esi)
    8209:	c4 14 66             	les    (%esi,%eiz,2),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    820c:	68 b8 86 00 00       	push   $0x86b8
    8211:	66 6a 04             	pushw  $0x4
    8214:	66 68 96 00          	pushw  $0x96
    8218:	00 00                	add    %al,(%eax)
    821a:	66 68 ff ff          	pushw  $0xffff
    821e:	0f 00 66 6a          	verr   0x6a(%esi)
    8222:	00 66 e8             	add    %ah,-0x18(%esi)
    8225:	af                   	scas   %es:(%edi),%eax
    8226:	fe                   	(bad)  
    8227:	ff                   	(bad)  
    8228:	ff 66 83             	jmp    *-0x7d(%esi)
    822b:	c4 14 90             	les    (%eax,%edx,4),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);
}
    822e:	66 c9                	leavew 
    8230:	66 c3                	retw   
    8232:	66 90                	xchg   %ax,%ax
    8234:	66 90                	xchg   %ax,%ax
    8236:	66 90                	xchg   %ax,%ax
    8238:	66 90                	xchg   %ax,%ax
    823a:	66 90                	xchg   %ax,%ax
    823c:	66 90                	xchg   %ax,%ax
    823e:	66 90                	xchg   %ax,%ax

00008240 <gdtr>:
bits 16
extern __gdt_entry__ , kern_init , bootdrive , err_
global load_gdt

gdtr dw 0	;for limit
    8240:	00 00 00 00 00 00                                   ......

00008246 <load_gdt>:

section .text


load_gdt:
	cli
    8246:	fa                   	cli    
	push eax
    8247:	66 50                	push   %ax
	push ecx
    8249:	66 51                	push   %cx
		mov ecx , 4*255
    824b:	66 b9 fc 03          	mov    $0x3fc,%cx
    824f:	00 00                	add    %al,(%eax)
		mov eax , __gdt_entry__
    8251:	66 b8 a0 86          	mov    $0x86a0,%ax
    8255:	00 00                	add    %al,(%eax)
		add eax , ecx
    8257:	66 01 c8             	add    %cx,%ax
		mov word[gdtr] , ax
    825a:	a3 40 82 66 b9       	mov    %eax,0xb9668240

		mov ecx , __gdt_entry__
    825f:	a0 86 00 00 66       	mov    0x66000086,%al
		mov dword[gdtr+2] , ecx
    8264:	89 0e                	mov    %ecx,(%esi)
    8266:	42                   	inc    %edx
    8267:	82 0f 01             	orb    $0x1,(%edi)

		lgdt [gdtr]
    826a:	16                   	push   %ss
    826b:	40                   	inc    %eax
    826c:	82 0f 20             	orb    $0x20,(%edi)

		mov eax, cr0
    826f:	c0 0c 01 0f          	rorb   $0xf,(%ecx,%eax,1)
    	or al, 1
 		mov cr0, eax
    8273:	22 c0                	and    %al,%al


		jmp 0x08:next_
    8275:	ea                   	.byte 0xea
    8276:	7a 82                	jp     81fa <init_gdt+0x54>
    8278:	08 00                	or     %al,(%eax)

0000827a <next_>:

	bits 32
	next_:

		mov ax , 0x10
    827a:	66 b8 10 00          	mov    $0x10,%ax
		mov ds , ax
    827e:	8e d8                	mov    %eax,%ds
		mov es , ax
    8280:	8e c0                	mov    %eax,%es
		mov fs , ax
    8282:	8e e0                	mov    %eax,%fs
		mov gs , ax
    8284:	8e e8                	mov    %eax,%gs

		mov ax , 0x18
    8286:	66 b8 18 00          	mov    $0x18,%ax
		mov ss , ax
    828a:	8e d0                	mov    %eax,%ss


		pop ecx
    828c:	59                   	pop    %ecx
		pop eax
    828d:	58                   	pop    %eax

		 mov ebp, 0x90000
    828e:	bd 00 00 09 00       	mov    $0x90000,%ebp
    	mov esp, ebp
    8293:	89 ec                	mov    %ebp,%esp

    8295:	e8 66 0d 00 00       	call   9000 <END_SECOND_BOOT>
    829a:	66 90                	xchg   %ax,%ax
    829c:	66 90                	xchg   %ax,%ax
    829e:	66 90                	xchg   %ax,%ax

000082a0 <int_loop>:

extern err_ , e820_mem_table

global load_e820_mem_table , int_loop

int_loop dd 0
    82a0:	00 00                	add    %al,(%eax)
	...

000082a4 <load_e820_mem_table>:


section .text

load_e820_mem_table:
	mov di, e820_mem_table         ; Set di to e820_mem_table address. Otherwise this code will get stuck in `int 0x15` after some entries are fetched 
    82a4:	bf 80 83 83 c7       	mov    $0xc7838380,%edi
	add di , 24
    82a9:	18 66 31             	sbb    %ah,0x31(%esi)
	xor ebx, ebx		; ebx must be 0 to start
    82ac:	db 31                	(bad)  (%ecx)
	xor bp, bp		; keep an entry count in bp
    82ae:	ed                   	in     (%dx),%eax
	mov edx, 0x0534D4150	; Place "SMAP" into edx
    82af:	66 ba 50 41          	mov    $0x4150,%dx
    82b3:	4d                   	dec    %ebp
    82b4:	53                   	push   %ebx
	mov eax, 0xe820
    82b5:	66 b8 20 e8          	mov    $0xe820,%ax
    82b9:	00 00                	add    %al,(%eax)
	mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
    82bb:	26 66 c7 45 14 01 00 	movw   $0x1,%es:0x14(%ebp)
    82c2:	00 00                	add    %al,(%eax)
	mov ecx, 24		; ask for 24 bytes
    82c4:	66 b9 18 00          	mov    $0x18,%cx
    82c8:	00 00                	add    %al,(%eax)
	int 0x15
    82ca:	cd 15                	int    $0x15
	jc short .failed	; carry set on first call means "unsupported function"
    82cc:	72 71                	jb     833f <load_e820_mem_table.failed>
	mov edx, 0x0534D4150	; Some BIOSes apparently trash this register?
    82ce:	66 ba 50 41          	mov    $0x4150,%dx
    82d2:	4d                   	dec    %ebp
    82d3:	53                   	push   %ebx
	cmp eax, edx		; on success, eax must have been reset to "SMAP"
    82d4:	66 39 d0             	cmp    %dx,%ax
	jne short .failed
    82d7:	75 66                	jne    833f <load_e820_mem_table.failed>
	test ebx, ebx		; ebx = 0 implies list is only 1 entry long (worthless)
    82d9:	66 85 db             	test   %bx,%bx
	je short .failed
    82dc:	74 61                	je     833f <load_e820_mem_table.failed>
	jmp short .jmpin
    82de:	eb 1f                	jmp    82ff <load_e820_mem_table.jmpin>

000082e0 <load_e820_mem_table.e820lp>:
.e820lp:
	mov eax, 0xe820		; eax, ecx get trashed on every int 0x15 call
    82e0:	66 b8 20 e8          	mov    $0xe820,%ax
    82e4:	00 00                	add    %al,(%eax)
	mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
    82e6:	26 66 c7 45 14 01 00 	movw   $0x1,%es:0x14(%ebp)
    82ed:	00 00                	add    %al,(%eax)
	mov ecx, 24		; ask for 24 bytes again
    82ef:	66 b9 18 00          	mov    $0x18,%cx
    82f3:	00 00                	add    %al,(%eax)
	int 0x15
    82f5:	cd 15                	int    $0x15
	jc short .e820f		; carry set means "end of list already reached"
    82f7:	72 44                	jb     833d <load_e820_mem_table.e820f>
	mov edx, 0x0534D4150	; repair potentially trashed register
    82f9:	66 ba 50 41          	mov    $0x4150,%dx
    82fd:	4d                   	dec    %ebp
    82fe:	53                   	push   %ebx

000082ff <load_e820_mem_table.jmpin>:
.jmpin:
	jcxz .skipent		; skip any 0 length entries
    82ff:	e3 1c                	jecxz  831d <load_e820_mem_table.skipent>
	cmp cl, 20		; got a 24 byte ACPI 3.X response?
    8301:	80 f9 14             	cmp    $0x14,%cl
	jbe short .notext
    8304:	76 07                	jbe    830d <load_e820_mem_table.notext>
	test byte [es:di + 20], 1	; if so: is the "ignore this data" bit clear?
    8306:	26 f6 45 14 01       	testb  $0x1,%es:0x14(%ebp)
	je short .skipent
    830b:	74 10                	je     831d <load_e820_mem_table.skipent>

0000830d <load_e820_mem_table.notext>:
.notext:
	mov ecx, [es:di + 8]	; get lower uint32_t of memory region length
    830d:	26 66 8b 4d 08       	mov    %es:0x8(%ebp),%cx
	or ecx, [es:di + 12]	; "or" it with upper uint32_t to test for zero
    8312:	26 66 0b 4d 0c       	or     %es:0xc(%ebp),%cx
	jz .skipent		; if length uint64_t is 0, skip entry
    8317:	74 04                	je     831d <load_e820_mem_table.skipent>
	inc bp			; got a good entry: ++count, move to next storage spot
    8319:	45                   	inc    %ebp
	add di, 24
    831a:	83 c7 18             	add    $0x18,%edi

0000831d <load_e820_mem_table.skipent>:
.skipent:

	;check if we have at the end of the memory
	mov ecx , dword[es:di]
    831d:	26 66 8b 0d 26 66 03 	mov    %es:0x4d036626,%cx
    8324:	4d 
	add ecx , dword[es:di+8]
    8325:	08 66 83             	or     %ah,-0x7d(%esi)
	cmp ecx , 0xFFFFFFFF
    8328:	f9                   	stc    
    8329:	ff 74 11 66          	push   0x66(%ecx,%edx,1)
	jz .e820f

	mov ecx , dword[int_loop]
    832d:	8b 0e                	mov    (%esi),%ecx
    832f:	a0 82 66 41 66       	mov    0x66416682,%al
	inc ecx
	mov dword[int_loop] , ecx
    8334:	89 0e                	mov    %ecx,(%esi)
    8336:	a0 82 66 85 db       	mov    0xdb856682,%al

	test ebx, ebx		; if ebx resets to 0, list is complete
	jne short .e820lp
    833b:	75 a3                	jne    82e0 <load_e820_mem_table.e820lp>

0000833d <load_e820_mem_table.e820f>:
.e820f:
	clc			; there is "jc" on end of list to this point, so the carry must be cleared
    833d:	f8                   	clc    
	ret
    833e:	c3                   	ret    

0000833f <load_e820_mem_table.failed>:
.failed:
	stc			; "function unsupported" error exit
    833f:	f9                   	stc    
	mov eax , 1
    8340:	66 b8 01 00          	mov    $0x1,%ax
    8344:	00 00                	add    %al,(%eax)
	mov dword[err_] , eax
    8346:	66                   	data16
    8347:	a3                   	.byte 0xa3
    8348:	60                   	pusha  
    8349:	83                   	.byte 0x83
    834a:	c3                   	ret    

0000834b <bootmain>:
    834b:	55                   	push   %ebp
    834c:	89 e5                	mov    %esp,%ebp
    834e:	90                   	nop
    834f:	5d                   	pop    %ebp
    8350:	c3                   	ret    
