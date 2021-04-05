
bin/boot2.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00007e00 <entry>:
section .text



entry:
	cli
    7e00:	fa                   	cli    
	jmp main
    7e01:	e9                   	.byte 0xe9
    7e02:	98                   	cwtl   
	...

00007e04 <read_sectors>:

read_sectors:

	;load the bootdrive 
	mov ax , word[esp-2]
    7e04:	67 8b 44 24          	mov    0x24(%si),%eax
    7e08:	fe                   	(bad)  
	mov word[bootdrive] , ax
    7e09:	a3                   	.byte 0xa3
    7e0a:	f0                   	lock
    7e0b:	83                   	.byte 0x83

00007e0c <reset_disk>:

	reset_disk:
	mov dl ,[bootdrive]
    7e0c:	8a 16                	mov    (%esi),%dl
    7e0e:	f0 83 31 c0          	lock xorl $0xffffffc0,(%ecx)
	xor ax , ax
	int 0x13
    7e12:	cd 13                	int    $0x13
	jc reset_disk
    7e14:	72 f6                	jb     7e0c <reset_disk>
	

	mov bx , 0x9000
    7e16:	bb 00 90 b6 32       	mov    $0x32b69000,%ebx

	mov dh , 50

	push dx
    7e1b:	52                   	push   %edx

	mov ah , 0x02       ; BIOS read sector function
    7e1c:	b4 02                	mov    $0x2,%ah
    mov al , dh         ; Read DH sectors
    7e1e:	88 f0                	mov    %dh,%al
    mov ch , 0x00       ; Select cylinder 0
    7e20:	b5 00                	mov    $0x0,%ch
    mov dh , 0x00       ; Select head 0
    7e22:	b6 00                	mov    $0x0,%dh
    mov cl , 0x05       ; Start reading from second sector ( i.e.
    7e24:	b1 05                	mov    $0x5,%cl
                        ; after the boot sector )

	int 0x13
    7e26:	cd 13                	int    $0x13

	jc .disk_err_
    7e28:	72 06                	jb     7e30 <reset_disk.disk_err_>

	pop dx
    7e2a:	5a                   	pop    %edx

	cmp dh , al
    7e2b:	38 c6                	cmp    %al,%dh
	jne .disk_err_
    7e2d:	75 01                	jne    7e30 <reset_disk.disk_err_>

	ret
    7e2f:	c3                   	ret    

00007e30 <reset_disk.disk_err_>:

.disk_err_:
		mov eax , 1
    7e30:	66 b8 01 00          	mov    $0x1,%ax
    7e34:	00 00                	add    %al,(%eax)
		mov dword[err_] , eax
    7e36:	66                   	data16
    7e37:	a3                   	.byte 0xa3
    7e38:	64                   	fs
    7e39:	82                   	.byte 0x82
    7e3a:	c3                   	ret    

00007e3b <_simple_print_boot__>:

#define ES_DI_ptr(__ptr__) __asm__ ("movw %%ax , %%di"::"a"(__ptr__));


void _simple_print_boot__(char* msg)
{
    7e3b:	66 55                	push   %bp
    7e3d:	66 89 e5             	mov    %sp,%bp
    7e40:	66 53                	push   %bx
    7e42:	66 83 ec 10          	sub    $0x10,%sp
    int i = 0;
    7e46:	67 66 c7 45 f8 00 00 	movw   $0x0,-0x8(%di)
    7e4d:	00 00                	add    %al,(%eax)

    while (msg[i] != '\0') {
    7e4f:	eb 2a                	jmp    7e7b <_simple_print_boot__+0x40>
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
    7e51:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7e56:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7e5b:	66 01 d0             	add    %dx,%ax
    7e5e:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7e63:	66 0f be c0          	movsbw %al,%ax
    7e67:	80 cc 0e             	or     $0xe,%ah
    7e6a:	66 ba 07 00          	mov    $0x7,%dx
    7e6e:	00 00                	add    %al,(%eax)
    7e70:	66 89 d3             	mov    %dx,%bx
    7e73:	cd 10                	int    $0x10
        ++i;
    7e75:	67 66 83 45 f8 01    	addw   $0x1,-0x8(%di)
    while (msg[i] != '\0') {
    7e7b:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7e80:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7e85:	66 01 d0             	add    %dx,%ax
    7e88:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7e8d:	84 c0                	test   %al,%al
    7e8f:	75 c0                	jne    7e51 <_simple_print_boot__+0x16>
    }
    7e91:	90                   	nop
    7e92:	90                   	nop
    7e93:	67 66 8b 5d fc       	mov    -0x4(%di),%bx
    7e98:	66 c9                	leavew 
    7e9a:	66 c3                	retw   

00007e9c <main>:
int err_ = 1; // contain 1 if error

short bootdrive ;

void main()
{
    7e9c:	67 66 8d 4c 24       	lea    0x24(%si),%cx
    7ea1:	04 66                	add    $0x66,%al
    7ea3:	83 e4 f0             	and    $0xfffffff0,%esp
    7ea6:	67 66 ff 71 fc       	pushw  -0x4(%bx,%di)
    7eab:	66 55                	push   %bp
    7ead:	66 89 e5             	mov    %sp,%bp
    7eb0:	66 51                	push   %cx
    7eb2:	66 83 ec 04          	sub    $0x4,%sp
    err_ = 1;
    7eb6:	66 c7 06 64 82       	movw   $0x8264,(%esi)
    7ebb:	01 00                	add    %eax,(%eax)
    7ebd:	00 00                	add    %al,(%eax)
    _simple_print_boot__("_");
    7ebf:	66 68 68 82          	pushw  $0x8268
    7ec3:	00 00                	add    %al,(%eax)
    7ec5:	66 e8 70 ff          	callw  7e39 <reset_disk.disk_err_+0x9>
    7ec9:	ff                   	(bad)  
    7eca:	ff 66 83             	jmp    *-0x7d(%esi)
    7ecd:	c4 04 66             	les    (%esi,%eiz,2),%eax
    enable_a20();
    7ed0:	e8 5b 00 00 00       	call   7f30 <enable_a20>
    if (err_ == 1)
    7ed5:	66 a1 64 82 66 83    	mov    0x83668264,%ax
    7edb:	f8                   	clc    
    7edc:	01 75 14             	add    %esi,0x14(%ebp)
        _simple_print_boot__("A20 was not supported by your firmware\n");
    7edf:	66 83 ec 0c          	sub    $0xc,%sp
    7ee3:	66 68 6c 82          	pushw  $0x826c
    7ee7:	00 00                	add    %al,(%eax)
    7ee9:	66 e8 4c ff          	callw  7e39 <reset_disk.disk_err_+0x9>
    7eed:	ff                   	(bad)  
    7eee:	ff 66 83             	jmp    *-0x7d(%esi)
    7ef1:	c4 10                	les    (%eax),%edx

    init_gdt();
    7ef3:	66 e8 cd 01          	callw  80c4 <init_gdt_entry+0xcc>
    7ef7:	00 00                	add    %al,(%eax)

    read_sectors();
    7ef9:	66 e8 05 ff          	callw  7e02 <entry+0x2>
    7efd:	ff                   	(bad)  
    7efe:	ff 66 e8             	jmp    *-0x18(%esi)

    load_e820_mem_table();
    7f01:	bf 02 00 00 66       	mov    $0x66000002,%edi

    if (err_ == 1)_simple_print_boot__("Getting E820 memory Map error\n") ;
    7f06:	a1 64 82 66 83       	mov    0x83668264,%eax
    7f0b:	f8                   	clc    
    7f0c:	01 75 14             	add    %esi,0x14(%ebp)
    7f0f:	66 83 ec 0c          	sub    $0xc,%sp
    7f13:	66 68 94 82          	pushw  $0x8294
    7f17:	00 00                	add    %al,(%eax)
    7f19:	66 e8 1c ff          	callw  7e39 <reset_disk.disk_err_+0x9>
    7f1d:	ff                   	(bad)  
    7f1e:	ff 66 83             	jmp    *-0x7d(%esi)
    7f21:	c4 10                	les    (%eax),%edx

    load_gdt();
    7f23:	66 e8 3d 02          	callw  8164 <gdtr+0x4>
    7f27:	00 00                	add    %al,(%eax)

end:
    goto end;   
    7f29:	eb fe                	jmp    7f29 <main+0x8d>
    7f2b:	66 90                	xchg   %ax,%ax
    7f2d:	66 90                	xchg   %ax,%ax
    7f2f:	90                   	nop

00007f30 <enable_a20>:
extern err_

section .text

enable_a20:
    call check_a20
    7f30:	e8 27 00 83 f8       	call   f8837f5c <__gdt_entry__+0xf882fb5c>
    cmp ax, 1
    7f35:	01 74 6d e8          	add    %esi,-0x18(%ebp,%ebp,2)
    je enabled
    call a20_bios
    7f39:	5d                   	pop    %ebp
    7f3a:	00 e8                	add    %ch,%al
    call check_a20
    7f3c:	1c 00                	sbb    $0x0,%al
    cmp ax, 1
    7f3e:	83 f8 01             	cmp    $0x1,%eax
    je enabled
    7f41:	74 62                	je     7fa5 <enabled>
    call a20_keyboard
    7f43:	e8 66 00 e8 11       	call   11e87fae <__gdt_entry__+0x11e7fbae>
    call check_a20
    7f48:	00 83 f8 01 74 57    	add    %al,0x577401f8(%ebx)
    cmp ax, 1
    je enabled
    call a20_fast
    7f4e:	e8 4d 00 e8 06       	call   6e87fa0 <__gdt_entry__+0x6e7fba0>
    call check_a20
    7f53:	00 83 f8 01 74 4c    	add    %al,0x4c7401f8(%ebx)
    cmp ax, 1
    je enabled
	ret
    7f59:	c3                   	ret    

00007f5a <check_a20>:

check_a20:
    pushf
    7f5a:	9c                   	pushf  
    push ds
    7f5b:	1e                   	push   %ds
    push es
    7f5c:	06                   	push   %es
    push di
    7f5d:	57                   	push   %edi
    push si
    7f5e:	56                   	push   %esi

    cli
    7f5f:	fa                   	cli    
    xor ax, ax ; ax = 0
    7f60:	31 c0                	xor    %eax,%eax
    mov es, ax
    7f62:	8e c0                	mov    %eax,%es
    not ax ; ax = 0xFFFF
    7f64:	f7 d0                	not    %eax
    mov ds, ax
    7f66:	8e d8                	mov    %eax,%ds
    mov di, 0x0500
    7f68:	bf 00 05 be 10       	mov    $0x10be0500,%edi
    mov si, 0x0510
    7f6d:	05 26 8a 05 50       	add    $0x50058a26,%eax
    mov al, byte [es:di]
    push ax
    mov al, byte [ds:si]
    7f72:	3e 8a 04 50          	mov    %ds:(%eax,%edx,2),%al
    push ax
    mov byte [es:di], 0x00
    7f76:	26 c6 05 00 3e c6 04 	movb   $0xff,%es:0x4c63e00
    7f7d:	ff 
    mov byte [ds:si], 0xFF
    cmp byte [es:di], 0xFF
    7f7e:	26 80 3d ff 58 3e 88 	cmpb   $0x4,%es:0x883e58ff
    7f85:	04 
    pop ax
    mov byte [ds:si], al
    pop ax
    7f86:	58                   	pop    %eax
    mov byte [es:di], al
    7f87:	26 88 05 b8 00 00 74 	mov    %al,%es:0x740000b8
    mov ax, 0
    je check_a20__exit
    7f8e:	03                   	.byte 0x3
    mov ax, 1
    7f8f:	b8                   	.byte 0xb8
    7f90:	01 00                	add    %eax,(%eax)

00007f92 <check_a20__exit>:

check_a20__exit:
    pop si
    7f92:	5e                   	pop    %esi
    pop di
    7f93:	5f                   	pop    %edi
    pop es
    7f94:	07                   	pop    %es
    pop ds
    7f95:	1f                   	pop    %ds
    popf
    7f96:	9d                   	popf   
    ret
    7f97:	c3                   	ret    

00007f98 <a20_bios>:

a20_bios:
    mov ax, 0x2401
    7f98:	b8 01 24 cd 15       	mov    $0x15cd2401,%eax
    int 0x15
    ret
    7f9d:	c3                   	ret    

00007f9e <a20_fast>:

a20_fast:
    in al, 0x92
    7f9e:	e4 92                	in     $0x92,%al
    or al, 2
    7fa0:	0c 02                	or     $0x2,%al
    out 0x92, al
    7fa2:	e6 92                	out    %al,$0x92
    ret
    7fa4:	c3                   	ret    

00007fa5 <enabled>:

enabled:

	mov ax , 0
    7fa5:	b8 00 00 a3 64       	mov    $0x64a30000,%eax
	mov word[err_] , ax
    7faa:	82                   	.byte 0x82
    ret
    7fab:	c3                   	ret    

00007fac <a20_keyboard>:

[bits 32]
    

a20_keyboard:
    cli
    7fac:	fa                   	cli    

    call    a20wait
    7fad:	e8 38 00 00 00       	call   7fea <a20wait>
    mov     al,0xAD
    7fb2:	b0 ad                	mov    $0xad,%al
    out     0x64,al
    7fb4:	e6 64                	out    %al,$0x64
    call    a20wait
    7fb6:	e8 2f 00 00 00       	call   7fea <a20wait>
    mov     al,0xD0
    7fbb:	b0 d0                	mov    $0xd0,%al
    out     0x64,al
    7fbd:	e6 64                	out    %al,$0x64
    call    a20wait2
    7fbf:	e8 2d 00 00 00       	call   7ff1 <a20wait2>
    in      al,0x60
    7fc4:	e4 60                	in     $0x60,%al
    push    eax
    7fc6:	50                   	push   %eax
    call    a20wait
    7fc7:	e8 1e 00 00 00       	call   7fea <a20wait>
    mov     al,0xD1
    7fcc:	b0 d1                	mov    $0xd1,%al
    out     0x64,al
    7fce:	e6 64                	out    %al,$0x64
    call    a20wait
    7fd0:	e8 15 00 00 00       	call   7fea <a20wait>
    pop     eax
    7fd5:	58                   	pop    %eax
    or      al,2
    7fd6:	0c 02                	or     $0x2,%al
    out     0x60,al
    7fd8:	e6 60                	out    %al,$0x60
    call    a20wait
    7fda:	e8 0b 00 00 00       	call   7fea <a20wait>
    mov     al,0xAE
    7fdf:	b0 ae                	mov    $0xae,%al
    out     0x64,al
    7fe1:	e6 64                	out    %al,$0x64
    call    a20wait
    7fe3:	e8 02 00 00 00       	call   7fea <a20wait>
    sti
    7fe8:	fb                   	sti    
    ret
    7fe9:	c3                   	ret    

00007fea <a20wait>:

a20wait:
    in      al,0x64
    7fea:	e4 64                	in     $0x64,%al
    test    al,2
    7fec:	a8 02                	test   $0x2,%al
    jnz     a20wait
    7fee:	75 fa                	jne    7fea <a20wait>
    ret
    7ff0:	c3                   	ret    

00007ff1 <a20wait2>:

a20wait2:
    in      al,0x64
    7ff1:	e4 64                	in     $0x64,%al
    test    al,1
    7ff3:	a8 01                	test   $0x1,%al
    jz      a20wait2
    7ff5:	74 fa                	je     7ff1 <a20wait2>
    7ff7:	c3                   	ret    

00007ff8 <init_gdt_entry>:
#include "gdt.h"

gdt_entry_desc __gdt_entry__[0xFF];

static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    7ff8:	66 55                	push   %bp
    7ffa:	66 89 e5             	mov    %sp,%bp
    7ffd:	66 83 ec 08          	sub    $0x8,%sp
    8001:	67 66 8b 55 10       	mov    0x10(%di),%dx
    8006:	67 66 8b 45 14       	mov    0x14(%di),%ax
    800b:	67 88 55 fc          	mov    %dl,-0x4(%di)
    800f:	67 88 45 f8          	mov    %al,-0x8(%di)
    desc->lim0_15 = (limite & 0xFFFF);
    8013:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    8018:	66 89 c2             	mov    %ax,%dx
    801b:	67 66 8b 45 18       	mov    0x18(%di),%ax
    8020:	67 89 10             	mov    %edx,(%bx,%si)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    8023:	67 66 8b 45 0c       	mov    0xc(%di),%ax
    8028:	66 c1 e8 10          	shr    $0x10,%ax
    802c:	66 83 e0 0f          	and    $0xf,%ax
    8030:	67 66 8b 55 18       	mov    0x18(%di),%dx
    8035:	66 83 e0 0f          	and    $0xf,%ax
    8039:	66 89 c1             	mov    %ax,%cx
    803c:	67 66 0f b6 42 06    	movzbw 0x6(%bp,%si),%ax
    8042:	66 83 e0 f0          	and    $0xfff0,%ax
    8046:	66 09 c8             	or     %cx,%ax
    8049:	67 88 42 06          	mov    %al,0x6(%bp,%si)

    desc->base0_15 = (base & 0xFFFF);
    804d:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8052:	66 89 c2             	mov    %ax,%dx
    8055:	67 66 8b 45 18       	mov    0x18(%di),%ax
    805a:	67 89 50 02          	mov    %edx,0x2(%bx,%si)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    805e:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8063:	66 c1 e8 10          	shr    $0x10,%ax
    8067:	66 89 c2             	mov    %ax,%dx
    806a:	67 66 8b 45 18       	mov    0x18(%di),%ax
    806f:	67 88 50 04          	mov    %dl,0x4(%bx,%si)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    8073:	67 66 8b 45 08       	mov    0x8(%di),%ax
    8078:	66 c1 e8 18          	shr    $0x18,%ax
    807c:	66 89 c2             	mov    %ax,%dx
    807f:	67 66 8b 45 18       	mov    0x18(%di),%ax
    8084:	67 88 50 07          	mov    %dl,0x7(%bx,%si)

    desc->flags = flags;
    8088:	67 66 0f b6 45 f8    	movzbw -0x8(%di),%ax
    808e:	66 83 e0 0f          	and    $0xf,%ax
    8092:	66 89 c2             	mov    %ax,%dx
    8095:	67 66 8b 45 18       	mov    0x18(%di),%ax
    809a:	66 89 d1             	mov    %dx,%cx
    809d:	66 c1 e1 04          	shl    $0x4,%cx
    80a1:	67 66 0f b6 50 06    	movzbw 0x6(%bx,%si),%dx
    80a7:	66 83 e2 0f          	and    $0xf,%dx
    80ab:	66 09 ca             	or     %cx,%dx
    80ae:	67 88 50 06          	mov    %dl,0x6(%bx,%si)
    desc->acces_byte = access;
    80b2:	67 66 8b 45 18       	mov    0x18(%di),%ax
    80b7:	67 66 0f b6 55 fc    	movzbw -0x4(%di),%dx
    80bd:	67 88 50 05          	mov    %dl,0x5(%bx,%si)
}
    80c1:	90                   	nop
    80c2:	66 c9                	leavew 
    80c4:	66 c3                	retw   

000080c6 <init_gdt>:

void init_gdt(void)
{
    80c6:	66 55                	push   %bp
    80c8:	66 89 e5             	mov    %sp,%bp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    80cb:	66 68 00 84          	pushw  $0x8400
    80cf:	00 00                	add    %al,(%eax)
    80d1:	66 6a 00             	pushw  $0x0
    80d4:	66 6a 00             	pushw  $0x0
    80d7:	66 6a 00             	pushw  $0x0
    80da:	66 6a 00             	pushw  $0x0
    80dd:	66 e8 15 ff          	callw  7ff6 <a20wait2+0x5>
    80e1:	ff                   	(bad)  
    80e2:	ff 66 83             	jmp    *-0x7d(%esi)
    80e5:	c4 14 66             	les    (%esi,%eiz,2),%edx

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    80e8:	68 08 84 00 00       	push   $0x8408
    80ed:	66 6a 04             	pushw  $0x4
    80f0:	66 68 9a 00          	pushw  $0x9a
    80f4:	00 00                	add    %al,(%eax)
    80f6:	66 68 ff ff          	pushw  $0xffff
    80fa:	0f 00 66 6a          	verr   0x6a(%esi)
    80fe:	00 66 e8             	add    %ah,-0x18(%esi)
    8101:	f3 fe                	repz (bad) 
    8103:	ff                   	(bad)  
    8104:	ff 66 83             	jmp    *-0x7d(%esi)
    8107:	c4 14 66             	les    (%esi,%eiz,2),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    810a:	68 10 84 00 00       	push   $0x8410
    810f:	66 6a 04             	pushw  $0x4
    8112:	66 68 92 00          	pushw  $0x92
    8116:	00 00                	add    %al,(%eax)
    8118:	66 68 ff ff          	pushw  $0xffff
    811c:	0f 00 66 6a          	verr   0x6a(%esi)
    8120:	00 66 e8             	add    %ah,-0x18(%esi)
    8123:	d1 fe                	sar    %esi
    8125:	ff                   	(bad)  
    8126:	ff 66 83             	jmp    *-0x7d(%esi)
    8129:	c4 14 66             	les    (%esi,%eiz,2),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    812c:	68 18 84 00 00       	push   $0x8418
    8131:	66 6a 04             	pushw  $0x4
    8134:	66 68 96 00          	pushw  $0x96
    8138:	00 00                	add    %al,(%eax)
    813a:	66 68 ff ff          	pushw  $0xffff
    813e:	0f 00 66 6a          	verr   0x6a(%esi)
    8142:	00 66 e8             	add    %ah,-0x18(%esi)
    8145:	af                   	scas   %es:(%edi),%eax
    8146:	fe                   	(bad)  
    8147:	ff                   	(bad)  
    8148:	ff 66 83             	jmp    *-0x7d(%esi)
    814b:	c4 14 90             	les    (%eax,%edx,4),%edx
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);
}
    814e:	66 c9                	leavew 
    8150:	66 c3                	retw   
    8152:	66 90                	xchg   %ax,%ax
    8154:	66 90                	xchg   %ax,%ax
    8156:	66 90                	xchg   %ax,%ax
    8158:	66 90                	xchg   %ax,%ax
    815a:	66 90                	xchg   %ax,%ax
    815c:	66 90                	xchg   %ax,%ax
    815e:	66 90                	xchg   %ax,%ax

00008160 <gdtr>:
bits 16
extern __gdt_entry__
global load_gdt

gdtr dw 0	;for limit
    8160:	00 00 00 00 00 00                                   ......

00008166 <load_gdt>:

section .text


load_gdt:
	cli
    8166:	fa                   	cli    
	push eax
    8167:	66 50                	push   %ax
	push ecx
    8169:	66 51                	push   %cx
		mov ecx , 4*255
    816b:	66 b9 fc 03          	mov    $0x3fc,%cx
    816f:	00 00                	add    %al,(%eax)
		mov eax , __gdt_entry__
    8171:	66 b8 00 84          	mov    $0x8400,%ax
    8175:	00 00                	add    %al,(%eax)
		add eax , ecx
    8177:	66 01 c8             	add    %cx,%ax
		mov word[gdtr] , ax
    817a:	a3 60 81 66 b9       	mov    %eax,0xb9668160

		mov ecx , __gdt_entry__
    817f:	00 84 00 00 66 89 0e 	add    %al,0xe896600(%eax,%eax,1)
		mov dword[gdtr+2] , ecx
    8186:	62 81 0f 01 16 60    	bound  %eax,0x6016010f(%ecx)

		lgdt [gdtr]
    818c:	81 0f 20 c0 0c 01    	orl    $0x10cc020,(%edi)

		mov eax, cr0
    	or al, 1
 		mov cr0, eax
    8192:	0f 22 c0             	mov    %eax,%cr0


		jmp 0x08:next_
    8195:	ea                   	.byte 0xea
    8196:	9a                   	.byte 0x9a
    8197:	81                   	.byte 0x81
    8198:	08 00                	or     %al,(%eax)

0000819a <next_>:

	bits 32
		 next_:

		mov ax , 0x10
    819a:	66 b8 10 00          	mov    $0x10,%ax
		mov ds , ax
    819e:	8e d8                	mov    %eax,%ds
		mov es , ax
    81a0:	8e c0                	mov    %eax,%es
		mov fs , ax
    81a2:	8e e0                	mov    %eax,%fs
		mov gs , ax
    81a4:	8e e8                	mov    %eax,%gs

		mov ax , 0x18
    81a6:	66 b8 18 00          	mov    $0x18,%ax
		mov ss , ax
    81aa:	8e d0                	mov    %eax,%ss

		mov esp , 0x90000
    81ac:	bc 00 00 09 00       	mov    $0x90000,%esp
	 	

	

    81b1:	e9 4a 0e 00 00       	jmp    9000 <__gdt_entry__+0xc00>
    81b6:	66 90                	xchg   %ax,%ax
    81b8:	66 90                	xchg   %ax,%ax
    81ba:	66 90                	xchg   %ax,%ax
    81bc:	66 90                	xchg   %ax,%ax
    81be:	66 90                	xchg   %ax,%ax

000081c0 <int_loop>:

extern err_ , e820_mem_table

global load_e820_mem_table

int_loop dd 6
    81c0:	06 00 00 00                                         ....

000081c4 <load_e820_mem_table>:


section .text

load_e820_mem_table:
	mov di, e820_mem_table         ; Set di to e820_mem_table address. Otherwise this code will get stuck in `int 0x15` after some entries are fetched 
    81c4:	bf 60 83 83 c7       	mov    $0xc7838360,%edi
	add di , 24
    81c9:	18 66 31             	sbb    %ah,0x31(%esi)
	xor ebx, ebx		; ebx must be 0 to start
    81cc:	db 31                	(bad)  (%ecx)
	xor bp, bp		; keep an entry count in bp
    81ce:	ed                   	in     (%dx),%eax
	mov edx, 0x0534D4150	; Place "SMAP" into edx
    81cf:	66 ba 50 41          	mov    $0x4150,%dx
    81d3:	4d                   	dec    %ebp
    81d4:	53                   	push   %ebx
	mov eax, 0xe820
    81d5:	66 b8 20 e8          	mov    $0xe820,%ax
    81d9:	00 00                	add    %al,(%eax)
	mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
    81db:	26 66 c7 45 14 01 00 	movw   $0x1,%es:0x14(%ebp)
    81e2:	00 00                	add    %al,(%eax)
	mov ecx, 24		; ask for 24 bytes
    81e4:	66 b9 18 00          	mov    $0x18,%cx
    81e8:	00 00                	add    %al,(%eax)
	int 0x15
    81ea:	cd 15                	int    $0x15
	jc short .failed	; carry set on first call means "unsupported function"
    81ec:	72 68                	jb     8256 <load_e820_mem_table.failed>
	mov edx, 0x0534D4150	; Some BIOSes apparently trash this register?
    81ee:	66 ba 50 41          	mov    $0x4150,%dx
    81f2:	4d                   	dec    %ebp
    81f3:	53                   	push   %ebx
	cmp eax, edx		; on success, eax must have been reset to "SMAP"
    81f4:	66 39 d0             	cmp    %dx,%ax
	jne short .failed
    81f7:	75 5d                	jne    8256 <load_e820_mem_table.failed>
	test ebx, ebx		; ebx = 0 implies list is only 1 entry long (worthless)
    81f9:	66 85 db             	test   %bx,%bx
	je short .failed
    81fc:	74 58                	je     8256 <load_e820_mem_table.failed>
	jmp short .jmpin
    81fe:	eb 1f                	jmp    821f <load_e820_mem_table.jmpin>

00008200 <load_e820_mem_table.e820lp>:
.e820lp:
	mov eax, 0xe820		; eax, ecx get trashed on every int 0x15 call
    8200:	66 b8 20 e8          	mov    $0xe820,%ax
    8204:	00 00                	add    %al,(%eax)
	mov [es:di + 20], dword 1	; force a valid ACPI 3.X entry
    8206:	26 66 c7 45 14 01 00 	movw   $0x1,%es:0x14(%ebp)
    820d:	00 00                	add    %al,(%eax)
	mov ecx, 24		; ask for 24 bytes again
    820f:	66 b9 18 00          	mov    $0x18,%cx
    8213:	00 00                	add    %al,(%eax)
	int 0x15
    8215:	cd 15                	int    $0x15
	jc short .e820f		; carry set means "end of list already reached"
    8217:	72 3b                	jb     8254 <load_e820_mem_table.e820f>
	mov edx, 0x0534D4150	; repair potentially trashed register
    8219:	66 ba 50 41          	mov    $0x4150,%dx
    821d:	4d                   	dec    %ebp
    821e:	53                   	push   %ebx

0000821f <load_e820_mem_table.jmpin>:
.jmpin:
	jcxz .skipent		; skip any 0 length entries
    821f:	e3 1c                	jecxz  823d <load_e820_mem_table.skipent>
	cmp cl, 20		; got a 24 byte ACPI 3.X response?
    8221:	80 f9 14             	cmp    $0x14,%cl
	jbe short .notext
    8224:	76 07                	jbe    822d <load_e820_mem_table.notext>
	test byte [es:di + 20], 1	; if so: is the "ignore this data" bit clear?
    8226:	26 f6 45 14 01       	testb  $0x1,%es:0x14(%ebp)
	je short .skipent
    822b:	74 10                	je     823d <load_e820_mem_table.skipent>

0000822d <load_e820_mem_table.notext>:
.notext:
	mov ecx, [es:di + 8]	; get lower uint32_t of memory region length
    822d:	26 66 8b 4d 08       	mov    %es:0x8(%ebp),%cx
	or ecx, [es:di + 12]	; "or" it with upper uint32_t to test for zero
    8232:	26 66 0b 4d 0c       	or     %es:0xc(%ebp),%cx
	jz .skipent		; if length uint64_t is 0, skip entry
    8237:	74 04                	je     823d <load_e820_mem_table.skipent>
	inc bp			; got a good entry: ++count, move to next storage spot
    8239:	45                   	inc    %ebp
	add di, 24
    823a:	83 c7 18             	add    $0x18,%edi

0000823d <load_e820_mem_table.skipent>:
.skipent:
	mov ecx , dword[int_loop]
    823d:	66 8b 0e             	mov    (%esi),%cx
    8240:	c0 81 66 83 f9 00 74 	rolb   $0x74,0xf98366(%ecx)
	cmp ecx , 0
	je .e820f
    8247:	0c 66                	or     $0x66,%al
	dec ecx
    8249:	49                   	dec    %ecx

	mov dword[int_loop] , ecx
    824a:	66 89 0e             	mov    %cx,(%esi)
    824d:	c0 81 66 85 db 75 ac 	rolb   $0xac,0x75db8566(%ecx)

00008254 <load_e820_mem_table.e820f>:
	test ebx, ebx		; if ebx resets to 0, list is complete
	jne short .e820lp
.e820f:
	clc			; there is "jc" on end of list to this point, so the carry must be cleared
    8254:	f8                   	clc    
	ret
    8255:	c3                   	ret    

00008256 <load_e820_mem_table.failed>:
.failed:
	stc			; "function unsupported" error exit
    8256:	f9                   	stc    
	mov eax , 1
    8257:	66 b8 01 00          	mov    $0x1,%ax
    825b:	00 00                	add    %al,(%eax)
	mov dword[err_] , eax
    825d:	66                   	data16
    825e:	a3                   	.byte 0xa3
    825f:	64                   	fs
    8260:	82                   	.byte 0x82
    8261:	c3                   	ret    
