
bin/boot1.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00007c00 <entry>:

extern bootdrive , second_boot


entry:
	cli
    7c00:	fa                   	cli    
	jmp 0:.1
    7c01:	ea                   	.byte 0xea
    7c02:	06                   	push   %es
    7c03:	7c 00                	jl     7c05 <entry+0x5>
	...

00007c06 <entry.1>:

.1:
	xor ax , ax
    7c06:	31 c0                	xor    %eax,%eax
	mov ds , ax
    7c08:	8e d8                	mov    %eax,%ds
	mov ss , ax
    7c0a:	8e d0                	mov    %eax,%ss
	mov es , ax
    7c0c:	8e c0                	mov    %eax,%es
	mov sp , 0
    7c0e:	bc 00 00 fc e9       	mov    $0xe9fc0000,%esp
	cld
	jmp main_boot
    7c13:	99                   	cltd   
	...

00007c15 <call_second_boot>:

call_second_boot:

	push dword[bootdrive]	;push the bootdrive id of the hard disk
    7c15:	66 ff 36             	pushw  (%esi)
    7c18:	50                   	push   %eax
    7c19:	7d e9                	jge    7c04 <entry+0x4>
	jmp 0x7e00
    7c1b:	e3 01                	jecxz  7c1e <read_sectors+0x1>

00007c1d <read_sectors>:


read_sectors:

	clc
    7c1d:	f8                   	clc    
	mov [bootdrive] , dl
    7c1e:	88 16                	mov    %dl,(%esi)
    7c20:	50                   	push   %eax
    7c21:	7d                   	.byte 0x7d

00007c22 <reset_disk>:

	reset_disk:

	xor ax , ax
    7c22:	31 c0                	xor    %eax,%eax
	int 0x13
    7c24:	cd 13                	int    $0x13
	jc reset_disk
    7c26:	72 fa                	jb     7c22 <reset_disk>
	

	mov bx , 0x7E00
    7c28:	bb 00 7e b6 05       	mov    $0x5b67e00,%ebx

	mov dh , 5

	push dx
    7c2d:	52                   	push   %edx

	mov ah , 0x02       ; BIOS read sector function
    7c2e:	b4 02                	mov    $0x2,%ah
    mov al , dh         ; Read DH sectors
    7c30:	88 f0                	mov    %dh,%al
    mov ch , 0x00       ; Select cylinder 0
    7c32:	b5 00                	mov    $0x0,%ch
    mov dh , 0x00       ; Select head 0
    7c34:	b6 00                	mov    $0x0,%dh
    mov cl , 0x02       ; Start reading from second sector ( i.e.
    7c36:	b1 02                	mov    $0x2,%cl
                        ; after the boot sector )

	int 0x13
    7c38:	cd 13                	int    $0x13

	jc .disk_err_
    7c3a:	72 06                	jb     7c42 <reset_disk.disk_err_>

	pop dx
    7c3c:	5a                   	pop    %edx

	cmp dh , al
    7c3d:	38 c6                	cmp    %al,%dh
	jne .disk_err_
    7c3f:	75 01                	jne    7c42 <reset_disk.disk_err_>
	ret
    7c41:	c3                   	ret    

00007c42 <reset_disk.disk_err_>:

.disk_err_:
		mov eax , 1
    7c42:	66 b8 01 00          	mov    $0x1,%ax
    7c46:	00 00                	add    %al,(%eax)
		mov dword[err] , eax
    7c48:	66                   	data16
    7c49:	a3                   	.byte 0xa3
    7c4a:	54                   	push   %esp
    7c4b:	7d c3                	jge    7c10 <entry.1+0xa>

00007c4d <__simple_print_boot__>:
int bootdrive;

int err = 0; // contain 1 if error

void __simple_print_boot__(char* msg)
{
    7c4d:	66 55                	push   %bp
    7c4f:	66 89 e5             	mov    %sp,%bp
    7c52:	66 53                	push   %bx
    7c54:	66 83 ec 10          	sub    $0x10,%sp
    int i = 0;
    7c58:	67 66 c7 45 f8 00 00 	movw   $0x0,-0x8(%di)
    7c5f:	00 00                	add    %al,(%eax)

    while (msg[i] != '\0') {
    7c61:	eb 2a                	jmp    7c8d <__simple_print_boot__+0x40>
        __asm__("int $0x10" ::"a"((0x0E << 8) | msg[i]), "b"(0x07));
    7c63:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7c68:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7c6d:	66 01 d0             	add    %dx,%ax
    7c70:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7c75:	66 0f be c0          	movsbw %al,%ax
    7c79:	80 cc 0e             	or     $0xe,%ah
    7c7c:	66 ba 07 00          	mov    $0x7,%dx
    7c80:	00 00                	add    %al,(%eax)
    7c82:	66 89 d3             	mov    %dx,%bx
    7c85:	cd 10                	int    $0x10
        ++i;
    7c87:	67 66 83 45 f8 01    	addw   $0x1,-0x8(%di)
    while (msg[i] != '\0') {
    7c8d:	67 66 8b 55 f8       	mov    -0x8(%di),%dx
    7c92:	67 66 8b 45 08       	mov    0x8(%di),%ax
    7c97:	66 01 d0             	add    %dx,%ax
    7c9a:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    7c9f:	84 c0                	test   %al,%al
    7ca1:	75 c0                	jne    7c63 <__simple_print_boot__+0x16>
    }
}
    7ca3:	90                   	nop
    7ca4:	90                   	nop
    7ca5:	67 66 8b 5d fc       	mov    -0x4(%di),%bx
    7caa:	66 c9                	leavew 
    7cac:	66 c3                	retw   

00007cae <main_boot>:

void main_boot(void)
{
    7cae:	66 55                	push   %bp
    7cb0:	66 89 e5             	mov    %sp,%bp
    7cb3:	66 83 ec 08          	sub    $0x8,%sp
    read_sectors();
    7cb7:	66 e8 60 ff          	callw  7c1b <call_second_boot+0x6>
    7cbb:	ff                   	(bad)  
    7cbc:	ff 66 a1             	jmp    *-0x5f(%esi)

    if (err == 1)
    7cbf:	54                   	push   %esp
    7cc0:	7d 66                	jge    7d28 <main_boot+0x7a>
    7cc2:	83 f8 01             	cmp    $0x1,%eax
    7cc5:	75 16                	jne    7cdd <main_boot+0x2f>
        __simple_print_boot__("Bad boot device\n");
    7cc7:	66 83 ec 0c          	sub    $0xc,%sp
    7ccb:	66 68 e5 7c          	pushw  $0x7ce5
    7ccf:	00 00                	add    %al,(%eax)
    7cd1:	66 e8 76 ff          	callw  7c4b <reset_disk.disk_err_+0x9>
    7cd5:	ff                   	(bad)  
    7cd6:	ff 66 83             	jmp    *-0x7d(%esi)
    7cd9:	c4 10                	les    (%eax),%edx
    7cdb:	eb 06                	jmp    7ce3 <main_boot+0x35>

    else
        call_second_boot();
    7cdd:	66 e8 32 ff          	callw  7c13 <entry.1+0xd>
    7ce1:	ff                   	(bad)  
    7ce2:	ff                   	(bad)  
end:
    goto end;
    7ce3:	eb fe                	jmp    7ce3 <main_boot+0x35>
