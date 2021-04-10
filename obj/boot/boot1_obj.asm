
boot1.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00007c00 <entry>:
    7c00:	fa                   	cli    
    7c01:	ea                   	.byte 0xea
    7c02:	06                   	push   %es
    7c03:	7c 00                	jl     7c05 <entry+0x5>
	...

00007c06 <entry.1>:
    7c06:	31 c0                	xor    %eax,%eax
    7c08:	8e d8                	mov    %eax,%ds
    7c0a:	8e d0                	mov    %eax,%ss
    7c0c:	8e c0                	mov    %eax,%es
    7c0e:	8e e8                	mov    %eax,%gs
    7c10:	8e d0                	mov    %eax,%ss
    7c12:	bc 06 8d fc e9       	mov    $0xe9fc8d06,%esp
    7c17:	98                   	cwtl   
	...

00007c19 <call_second_boot>:
    7c19:	ff 36                	pushl  (%esi)
    7c1b:	fc                   	cld    
    7c1c:	7c e9                	jl     7c07 <entry.1+0x1>
    7c1e:	e0 01                	loopne 7c21 <read_sectors+0x1>

00007c20 <read_sectors>:
    7c20:	f8                   	clc    
    7c21:	88 16                	mov    %dl,(%esi)
    7c23:	fc                   	cld    
    7c24:	7c                   	.byte 0x7c

00007c25 <reset_disk>:
    7c25:	31 c0                	xor    %eax,%eax
    7c27:	cd 13                	int    $0x13
    7c29:	72 fa                	jb     7c25 <reset_disk>
    7c2b:	bb 00 7e b6 04       	mov    $0x4b67e00,%ebx
    7c30:	52                   	push   %edx
    7c31:	b4 02                	mov    $0x2,%ah
    7c33:	88 f0                	mov    %dh,%al
    7c35:	b5 00                	mov    $0x0,%ch
    7c37:	b6 00                	mov    $0x0,%dh
    7c39:	b1 02                	mov    $0x2,%cl
    7c3b:	cd 13                	int    $0x13
    7c3d:	72 06                	jb     7c45 <reset_disk.disk_err_>
    7c3f:	5a                   	pop    %edx
    7c40:	38 c6                	cmp    %al,%dh
    7c42:	75 01                	jne    7c45 <reset_disk.disk_err_>
    7c44:	c3                   	ret    

00007c45 <reset_disk.disk_err_>:
    7c45:	66 b8 01 00          	mov    $0x1,%ax
    7c49:	00 00                	add    %al,(%eax)
    7c4b:	66                   	data16
    7c4c:	a3                   	.byte 0xa3
    7c4d:	00 7d c3             	add    %bh,-0x3d(%ebp)

00007c50 <__simple_print_boot__>:
short bootdrive;

int err = 0; // contain 1 if error

void __simple_print_boot__(char* msg)
{
    7c50:	66 55                	push   %bp
    7c52:	66 89 e5             	mov    %sp,%bp
    7c55:	66 53                	push   %bx
    7c57:	66 83 ec 10          	sub    $0x10,%sp
    int i = 0;
    7c5b:	67 66 c7 45 f8 00 00 	movw   $0x0,-0x8(%di)
    7c62:	00 00                	add    %al,(%eax)

    while (msg[i] != '\0') {
    7c64:	eb 2a                	jmp    7c90 <__simple_print_boot__+0x40>
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
    7c66:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7c6b:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7c70:	66 01 d0             	add    %dx,%ax
    7c73:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7c78:	66 0f be c0          	movsbw %al,%ax
    7c7c:	80 cc 0e             	or     $0xe,%ah
    7c7f:	66 ba 07 00          	mov    $0x7,%dx
    7c83:	00 00                	add    %al,(%eax)
    7c85:	66 89 d3             	mov    %dx,%bx
    7c88:	cd 10                	int    $0x10
        ++i;
    7c8a:	67 66 83 45 f8 01    	addw   $0x1,-0x8(%di)
    while (msg[i] != '\0') {
    7c90:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7c95:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7c9a:	66 01 d0             	add    %dx,%ax
    7c9d:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7ca2:	84 c0                	test   %al,%al
    7ca4:	75 c0                	jne    7c66 <__simple_print_boot__+0x16>
    }
}
    7ca6:	90                   	nop
    7ca7:	90                   	nop
    7ca8:	67 66 8b 5d fc       	mov    -0x4(%di),%bx
    7cad:	66 c9                	leavew 
    7caf:	66 c3                	retw   

00007cb1 <main_boot>:

void main_boot(void)
{
    7cb1:	66 55                	push   %bp
    7cb3:	66 89 e5             	mov    %sp,%bp
    7cb6:	66 83 ec 08          	sub    $0x8,%sp
    read_sectors();
    7cba:	66 e8 60 ff          	callw  7c1e <call_second_boot+0x5>
    7cbe:	ff                   	(bad)  
    7cbf:	ff 66 a1             	jmp    *-0x5f(%esi)

    if (err == 1)
    7cc2:	00 7d 66             	add    %bh,0x66(%ebp)
    7cc5:	83 f8 01             	cmp    $0x1,%eax
    7cc8:	75 16                	jne    7ce0 <main_boot+0x2f>
        __simple_print_boot__("Bad boot device\n");
    7cca:	66 83 ec 0c          	sub    $0xc,%sp
    7cce:	66 68 e8 7c          	pushw  $0x7ce8
    7cd2:	00 00                	add    %al,(%eax)
    7cd4:	66 e8 76 ff          	callw  7c4e <reset_disk.disk_err_+0x9>
    7cd8:	ff                   	(bad)  
    7cd9:	ff 66 83             	jmp    *-0x7d(%esi)
    7cdc:	c4 10                	les    (%eax),%edx
    7cde:	eb 06                	jmp    7ce6 <main_boot+0x35>

    else
        call_second_boot();
    7ce0:	66 e8 33 ff          	callw  7c17 <entry.1+0x11>
    7ce4:	ff                   	(bad)  
    7ce5:	ff                   	(bad)  
end:
    goto end;
    7ce6:	eb fe                	jmp    7ce6 <main_boot+0x35>
    7ce8:	42                   	inc    %edx
    7ce9:	61                   	popa   
    7cea:	64 20 62 6f          	and    %ah,%fs:0x6f(%edx)
    7cee:	6f                   	outsl  %ds:(%esi),(%dx)
    7cef:	74 20                	je     7d11 <__stack_bottom+0xb>
    7cf1:	64 65 76 69          	fs gs jbe 7d5e <__stack_bottom+0x58>
    7cf5:	63 65 0a             	arpl   %sp,0xa(%ebp)
	...

00007cf9 <__bss_start>:
    7cf9:	66 90                	xchg   %ax,%ax
    7cfb:	90                   	nop

00007cfc <bootdrive>:
    7cfc:	00 00 00 00                                         ....

00007d00 <err>:
    7d00:	00 00 00 00                                         ....
