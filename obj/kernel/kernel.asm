
bin/kernel.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00009000 <main>:
char *       bios_info_begin, bios_info_end;

void *detect_bios_info(), *detect_bios_info_end();

void main()
{
    9000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    9004:	83 e4 f0             	and    $0xfffffff0,%esp
    9007:	ff 71 fc             	push   -0x4(%ecx)
    900a:	55                   	push   %ebp
    900b:	89 e5                	mov    %esp,%ebp
    900d:	53                   	push   %ebx
    900e:	51                   	push   %ecx
    cli;
    900f:	fa                   	cli    
    cld;
    9010:	fc                   	cld    

    init_console();
    9011:	e8 58 03 00 00       	call   936e <init_console>

    init_gdt_kernel();
    9016:	e8 55 06 00 00       	call   9670 <init_gdt_kernel>

    init_idt();
    901b:	e8 6a 07 00 00       	call   978a <init_idt>

    //Kernel Mapping
    kprintf("Pepper kernel info : \n");
    9020:	83 ec 0c             	sub    $0xc,%esp
    9023:	68 dc b4 00 00       	push   $0xb4dc
    9028:	e8 0f 16 00 00       	call   a63c <kprintf>
    902d:	83 c4 10             	add    $0x10,%esp
    kprintf("PEPPER_Kernel init at [%p] length [%d] bytes \n", main, &end - (void**)main);
    9030:	b8 01 30 02 00       	mov    $0x23001,%eax
    9035:	2d 00 90 00 00       	sub    $0x9000,%eax
    903a:	c1 f8 02             	sar    $0x2,%eax
    903d:	83 ec 04             	sub    $0x4,%esp
    9040:	50                   	push   %eax
    9041:	68 00 90 00 00       	push   $0x9000
    9046:	68 f4 b4 00 00       	push   $0xb4f4
    904b:	e8 ec 15 00 00       	call   a63c <kprintf>
    9050:	83 c4 10             	add    $0x10,%esp
    kprintf("Firmware variables at [%p] length [%d] bytes \n", detect_bios_info(), detect_bios_info_end() - detect_bios_info());
    9053:	e8 6d 00 00 00       	call   90c5 <detect_bios_info_end>
    9058:	89 c3                	mov    %eax,%ebx
    905a:	e8 1b 00 00 00       	call   907a <detect_bios_info>
    905f:	29 c3                	sub    %eax,%ebx
    9061:	e8 14 00 00 00       	call   907a <detect_bios_info>
    9066:	83 ec 04             	sub    $0x4,%esp
    9069:	53                   	push   %ebx
    906a:	50                   	push   %eax
    906b:	68 24 b5 00 00       	push   $0xb524
    9070:	e8 c7 15 00 00       	call   a63c <kprintf>
    9075:	83 c4 10             	add    $0x10,%esp
    //--------------

    while (1)
    9078:	eb fe                	jmp    9078 <main+0x78>

0000907a <detect_bios_info>:
        ;
}

//detect BIOS info--------------------------
void* detect_bios_info()
{
    907a:	55                   	push   %ebp
    907b:	89 e5                	mov    %esp,%ebp
    907d:	83 ec 10             	sub    $0x10,%esp
    int       i = 0;
    9080:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    uint16_t* bios_info;

    bios_info = (int16_t*)(0x7e00);
    9087:	c7 45 f8 00 7e 00 00 	movl   $0x7e00,-0x8(%ebp)

    while (bios_info[i] != 0xB00B)
    908e:	eb 04                	jmp    9094 <detect_bios_info+0x1a>
        i++;
    9090:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (bios_info[i] != 0xB00B)
    9094:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9097:	8d 14 00             	lea    (%eax,%eax,1),%edx
    909a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    909d:	01 d0                	add    %edx,%eax
    909f:	0f b7 00             	movzwl (%eax),%eax
    90a2:	66 3d 0b b0          	cmp    $0xb00b,%ax
    90a6:	75 e8                	jne    9090 <detect_bios_info+0x16>

    bios_info_begin = (char*)(&bios_info[i]);
    90a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90ab:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90b1:	01 d0                	add    %edx,%eax
    90b3:	a3 00 f0 00 00       	mov    %eax,0xf000

    return (void*)(&bios_info[i]);
    90b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90bb:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90be:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90c1:	01 d0                	add    %edx,%eax
}
    90c3:	c9                   	leave  
    90c4:	c3                   	ret    

000090c5 <detect_bios_info_end>:

void* detect_bios_info_end()
{
    90c5:	55                   	push   %ebp
    90c6:	89 e5                	mov    %esp,%ebp
    90c8:	83 ec 10             	sub    $0x10,%esp
    int       i = 0;
    90cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    uint16_t* bios_info;

    bios_info = (int16_t*)(bios_info_begin);
    90d2:	a1 00 f0 00 00       	mov    0xf000,%eax
    90d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (bios_info[i] != 0xB00E)
    90da:	eb 04                	jmp    90e0 <detect_bios_info_end+0x1b>
        i++;
    90dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (bios_info[i] != 0xB00E)
    90e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90e3:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90e9:	01 d0                	add    %edx,%eax
    90eb:	0f b7 00             	movzwl (%eax),%eax
    90ee:	66 3d 0e b0          	cmp    $0xb00e,%ax
    90f2:	75 e8                	jne    90dc <detect_bios_info_end+0x17>

    return (void*)(&bios_info[i]);
    90f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90f7:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90fd:	01 d0                	add    %edx,%eax
}
    90ff:	c9                   	leave  
    9100:	c3                   	ret    

00009101 <cclean>:

void move_cursor(uint8_t x, uint8_t y);
void show_cursor(void);

void volatile cclean()
{
    9101:	55                   	push   %ebp
    9102:	89 e5                	mov    %esp,%ebp
    9104:	83 ec 10             	sub    $0x10,%esp
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    9107:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
    int            i      = 0;
    910e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (i <= 160 * 25) {
    9115:	eb 1d                	jmp    9134 <cclean+0x33>
        screen[i]     = ' ';
    9117:	8b 55 fc             	mov    -0x4(%ebp),%edx
    911a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    911d:	01 d0                	add    %edx,%eax
    911f:	c6 00 20             	movb   $0x20,(%eax)
        screen[i + 1] = 0x0;
    9122:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9125:	8d 50 01             	lea    0x1(%eax),%edx
    9128:	8b 45 f8             	mov    -0x8(%ebp),%eax
    912b:	01 d0                	add    %edx,%eax
    912d:	c6 00 00             	movb   $0x0,(%eax)
        i += 2;
    9130:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    while (i <= 160 * 25) {
    9134:	81 7d fc a0 0f 00 00 	cmpl   $0xfa0,-0x4(%ebp)
    913b:	7e da                	jle    9117 <cclean+0x16>
    }

    CURSOR_X = 0;
    913d:	c7 05 0c f0 00 00 00 	movl   $0x0,0xf00c
    9144:	00 00 00 
    CURSOR_Y = 0;
    9147:	c7 05 08 f0 00 00 00 	movl   $0x0,0xf008
    914e:	00 00 00 
}
    9151:	90                   	nop
    9152:	c9                   	leave  
    9153:	c3                   	ret    

00009154 <cscrollup>:

void volatile cscrollup()
{
    9154:	55                   	push   %ebp
    9155:	89 e5                	mov    %esp,%ebp
    9157:	81 ec b0 00 00 00    	sub    $0xb0,%esp
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    915d:	c7 45 f8 00 8f 0b 00 	movl   $0xb8f00,-0x8(%ebp)
    unsigned char  b[160];
    int            i;
    for (i = 0; i < 160; i++)
    9164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    916b:	eb 1c                	jmp    9189 <cscrollup+0x35>
        b[i] = v[i];
    916d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    9170:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9173:	01 d0                	add    %edx,%eax
    9175:	0f b6 00             	movzbl (%eax),%eax
    9178:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    917e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    9181:	01 ca                	add    %ecx,%edx
    9183:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    9185:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    9189:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    9190:	7e db                	jle    916d <cscrollup+0x19>

    cclean();
    9192:	e8 6a ff ff ff       	call   9101 <cclean>

    v = (unsigned char*)(VIDEO_MEM);
    9197:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)

    for (i = 0; i < 160; i++)
    919e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    91a5:	eb 1c                	jmp    91c3 <cscrollup+0x6f>
        v[i] = b[i];
    91a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    91aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    91ad:	01 c2                	add    %eax,%edx
    91af:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    91b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    91b8:	01 c8                	add    %ecx,%eax
    91ba:	0f b6 00             	movzbl (%eax),%eax
    91bd:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    91bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    91c3:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    91ca:	7e db                	jle    91a7 <cscrollup+0x53>

    CURSOR_Y++;
    91cc:	a1 08 f0 00 00       	mov    0xf008,%eax
    91d1:	83 c0 01             	add    $0x1,%eax
    91d4:	a3 08 f0 00 00       	mov    %eax,0xf008
}
    91d9:	90                   	nop
    91da:	c9                   	leave  
    91db:	c3                   	ret    

000091dc <cputchar>:

void volatile cputchar(char color, const char c)
{
    91dc:	55                   	push   %ebp
    91dd:	89 e5                	mov    %esp,%ebp
    91df:	83 ec 18             	sub    $0x18,%esp
    91e2:	8b 55 08             	mov    0x8(%ebp),%edx
    91e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    91e8:	88 55 ec             	mov    %dl,-0x14(%ebp)
    91eb:	88 45 e8             	mov    %al,-0x18(%ebp)

    if ((CURSOR_Y) <= (25)) {
    91ee:	a1 08 f0 00 00       	mov    0xf008,%eax
    91f3:	83 f8 19             	cmp    $0x19,%eax
    91f6:	0f 8f c0 00 00 00    	jg     92bc <cputchar+0xe0>
        if (c == '\n') {
    91fc:	80 7d e8 0a          	cmpb   $0xa,-0x18(%ebp)
    9200:	75 1c                	jne    921e <cputchar+0x42>
            CURSOR_X = 0;
    9202:	c7 05 0c f0 00 00 00 	movl   $0x0,0xf00c
    9209:	00 00 00 
            CURSOR_Y++;
    920c:	a1 08 f0 00 00       	mov    0xf008,%eax
    9211:	83 c0 01             	add    $0x1,%eax
    9214:	a3 08 f0 00 00       	mov    %eax,0xf008
        }
    }

    else
        cclean();
}
    9219:	e9 a3 00 00 00       	jmp    92c1 <cputchar+0xe5>
        else if (c == '\t')
    921e:	80 7d e8 09          	cmpb   $0x9,-0x18(%ebp)
    9222:	75 12                	jne    9236 <cputchar+0x5a>
            CURSOR_X += 5;
    9224:	a1 0c f0 00 00       	mov    0xf00c,%eax
    9229:	83 c0 05             	add    $0x5,%eax
    922c:	a3 0c f0 00 00       	mov    %eax,0xf00c
}
    9231:	e9 8b 00 00 00       	jmp    92c1 <cputchar+0xe5>
        else if (c == 0x08)
    9236:	80 7d e8 08          	cmpb   $0x8,-0x18(%ebp)
    923a:	75 3a                	jne    9276 <cputchar+0x9a>
            CURSOR_X--;
    923c:	a1 0c f0 00 00       	mov    0xf00c,%eax
    9241:	83 e8 01             	sub    $0x1,%eax
    9244:	a3 0c f0 00 00       	mov    %eax,0xf00c
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9249:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    9250:	8b 15 08 f0 00 00    	mov    0xf008,%edx
    9256:	89 d0                	mov    %edx,%eax
    9258:	c1 e0 02             	shl    $0x2,%eax
    925b:	01 d0                	add    %edx,%eax
    925d:	c1 e0 04             	shl    $0x4,%eax
    9260:	89 c2                	mov    %eax,%edx
    9262:	a1 0c f0 00 00       	mov    0xf00c,%eax
    9267:	01 d0                	add    %edx,%eax
    9269:	01 c0                	add    %eax,%eax
    926b:	01 45 f8             	add    %eax,-0x8(%ebp)
            *v = ' ';
    926e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9271:	c6 00 20             	movb   $0x20,(%eax)
}
    9274:	eb 4b                	jmp    92c1 <cputchar+0xe5>
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9276:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    927d:	8b 15 08 f0 00 00    	mov    0xf008,%edx
    9283:	89 d0                	mov    %edx,%eax
    9285:	c1 e0 02             	shl    $0x2,%eax
    9288:	01 d0                	add    %edx,%eax
    928a:	c1 e0 04             	shl    $0x4,%eax
    928d:	89 c2                	mov    %eax,%edx
    928f:	a1 0c f0 00 00       	mov    0xf00c,%eax
    9294:	01 d0                	add    %edx,%eax
    9296:	01 c0                	add    %eax,%eax
    9298:	01 45 fc             	add    %eax,-0x4(%ebp)
            *v = c;
    929b:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    929f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    92a2:	88 10                	mov    %dl,(%eax)
            *(v + 1) = READY_COLOR;
    92a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    92a7:	83 c0 01             	add    $0x1,%eax
    92aa:	c6 00 07             	movb   $0x7,(%eax)
            CURSOR_X++;
    92ad:	a1 0c f0 00 00       	mov    0xf00c,%eax
    92b2:	83 c0 01             	add    $0x1,%eax
    92b5:	a3 0c f0 00 00       	mov    %eax,0xf00c
}
    92ba:	eb 05                	jmp    92c1 <cputchar+0xe5>
        cclean();
    92bc:	e8 40 fe ff ff       	call   9101 <cclean>
}
    92c1:	90                   	nop
    92c2:	c9                   	leave  
    92c3:	c3                   	ret    

000092c4 <move_cursor>:

void move_cursor(uint8_t x, uint8_t y)
{
    92c4:	55                   	push   %ebp
    92c5:	89 e5                	mov    %esp,%ebp
    92c7:	83 ec 18             	sub    $0x18,%esp
    92ca:	8b 55 08             	mov    0x8(%ebp),%edx
    92cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    92d0:	88 55 ec             	mov    %dl,-0x14(%ebp)
    92d3:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t c_pos;

    c_pos = y * 80 + x;
    92d6:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    92da:	89 d0                	mov    %edx,%eax
    92dc:	c1 e0 02             	shl    $0x2,%eax
    92df:	01 d0                	add    %edx,%eax
    92e1:	c1 e0 04             	shl    $0x4,%eax
    92e4:	89 c2                	mov    %eax,%edx
    92e6:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    92ea:	01 d0                	add    %edx,%eax
    92ec:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    outb(0x3d4, 0x0f);
    92f0:	ba d4 03 00 00       	mov    $0x3d4,%edx
    92f5:	b8 0f 00 00 00       	mov    $0xf,%eax
    92fa:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)c_pos);
    92fb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    92ff:	ba d5 03 00 00       	mov    $0x3d5,%edx
    9304:	ee                   	out    %al,(%dx)
    outb(0x3d4, 0x0e);
    9305:	ba d4 03 00 00       	mov    $0x3d4,%edx
    930a:	b8 0e 00 00 00       	mov    $0xe,%eax
    930f:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)(c_pos >> 8));
    9310:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    9314:	66 c1 e8 08          	shr    $0x8,%ax
    9318:	ba d5 03 00 00       	mov    $0x3d5,%edx
    931d:	ee                   	out    %al,(%dx)
}
    931e:	90                   	nop
    931f:	c9                   	leave  
    9320:	c3                   	ret    

00009321 <show_cursor>:

void show_cursor(void)
{
    9321:	55                   	push   %ebp
    9322:	89 e5                	mov    %esp,%ebp
    move_cursor(CURSOR_X, CURSOR_Y);
    9324:	a1 08 f0 00 00       	mov    0xf008,%eax
    9329:	0f b6 d0             	movzbl %al,%edx
    932c:	a1 0c f0 00 00       	mov    0xf00c,%eax
    9331:	0f b6 c0             	movzbl %al,%eax
    9334:	52                   	push   %edx
    9335:	50                   	push   %eax
    9336:	e8 89 ff ff ff       	call   92c4 <move_cursor>
    933b:	83 c4 08             	add    $0x8,%esp
}
    933e:	90                   	nop
    933f:	c9                   	leave  
    9340:	c3                   	ret    

00009341 <console_service_keyboard>:

void console_service_keyboard()
{
    9341:	55                   	push   %ebp
    9342:	89 e5                	mov    %esp,%ebp
    9344:	83 ec 08             	sub    $0x8,%esp
    if (get_ASCII_code_keyboard() != 0) {
    9347:	e8 7b 02 00 00       	call   95c7 <get_ASCII_code_keyboard>
    934c:	84 c0                	test   %al,%al
    934e:	74 1b                	je     936b <console_service_keyboard+0x2a>
        cputchar(READY_COLOR, get_ASCII_code_keyboard());
    9350:	e8 72 02 00 00       	call   95c7 <get_ASCII_code_keyboard>
    9355:	0f be c0             	movsbl %al,%eax
    9358:	83 ec 08             	sub    $0x8,%esp
    935b:	50                   	push   %eax
    935c:	6a 07                	push   $0x7
    935e:	e8 79 fe ff ff       	call   91dc <cputchar>
    9363:	83 c4 10             	add    $0x10,%esp
        show_cursor();
    9366:	e8 b6 ff ff ff       	call   9321 <show_cursor>
    }
}
    936b:	90                   	nop
    936c:	c9                   	leave  
    936d:	c3                   	ret    

0000936e <init_console>:

void init_console()
{
    936e:	55                   	push   %ebp
    936f:	89 e5                	mov    %esp,%ebp
    9371:	83 ec 08             	sub    $0x8,%esp
    cclean();
    9374:	e8 88 fd ff ff       	call   9101 <cclean>
    kbd_init(); //Init keyboard
    9379:	e8 2c 00 00 00       	call   93aa <kbd_init>
    //init Video graphics here
    937e:	90                   	nop
    937f:	c9                   	leave  
    9380:	c3                   	ret    

00009381 <keyboard_add_service>:
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x60)  */
          0xFF, 0xFF, 0xFF, 0xFF  /*      (0x61)  */
      };

void keyboard_add_service(void (*func)())
{
    9381:	55                   	push   %ebp
    9382:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service[keyboard_ctrl.kbd_service_num] = func;
    9384:	0f b6 05 21 f0 00 00 	movzbl 0xf021,%eax
    938b:	0f be c0             	movsbl %al,%eax
    938e:	8b 55 08             	mov    0x8(%ebp),%edx
    9391:	89 14 85 22 f0 00 00 	mov    %edx,0xf022(,%eax,4)
    keyboard_ctrl.kbd_service_num++;
    9398:	0f b6 05 21 f0 00 00 	movzbl 0xf021,%eax
    939f:	83 c0 01             	add    $0x1,%eax
    93a2:	a2 21 f0 00 00       	mov    %al,0xf021
}
    93a7:	90                   	nop
    93a8:	5d                   	pop    %ebp
    93a9:	c3                   	ret    

000093aa <kbd_init>:

void kbd_init()
{
    93aa:	55                   	push   %ebp
    93ab:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service_num = 0;
    93ad:	c6 05 21 f0 00 00 00 	movb   $0x0,0xf021
    keyboard_add_service(console_service_keyboard);
    93b4:	68 41 93 00 00       	push   $0x9341
    93b9:	e8 c3 ff ff ff       	call   9381 <keyboard_add_service>
    93be:	83 c4 04             	add    $0x4,%esp
    keyboard_add_service(monitor_service_keyboard);
    93c1:	68 af a5 00 00       	push   $0xa5af
    93c6:	e8 b6 ff ff ff       	call   9381 <keyboard_add_service>
    93cb:	83 c4 04             	add    $0x4,%esp
}
    93ce:	90                   	nop
    93cf:	c9                   	leave  
    93d0:	c3                   	ret    

000093d1 <keyboard_irq>:

void keyboard_irq()
{
    93d1:	55                   	push   %ebp
    93d2:	89 e5                	mov    %esp,%ebp
    93d4:	83 ec 18             	sub    $0x18,%esp

    int i;
    void (*func)(void);

    do {
        keyboard_ctrl.code = _8042_get_status;
    93d7:	b8 64 00 00 00       	mov    $0x64,%eax
    93dc:	89 c2                	mov    %eax,%edx
    93de:	ec                   	in     (%dx),%al
    93df:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    93e3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    93e7:	66 a3 1e f4 00 00    	mov    %ax,0xf41e
    } while ((keyboard_ctrl.code & 0x01) == _8042_BUFFER_OVERRUN);
    93ed:	0f b7 05 1e f4 00 00 	movzwl 0xf41e,%eax
    93f4:	98                   	cwtl   
    93f5:	83 e0 01             	and    $0x1,%eax
    93f8:	85 c0                	test   %eax,%eax
    93fa:	74 db                	je     93d7 <keyboard_irq+0x6>

    keyboard_ctrl.code = _8042_scan_code;
    93fc:	b8 60 00 00 00       	mov    $0x60,%eax
    9401:	89 c2                	mov    %eax,%edx
    9403:	ec                   	in     (%dx),%al
    9404:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    9408:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    940c:	66 a3 1e f4 00 00    	mov    %ax,0xf41e

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9412:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9419:	eb 16                	jmp    9431 <keyboard_irq+0x60>
        func = keyboard_ctrl.kbd_service[i];
    941b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    941e:	8b 04 85 22 f0 00 00 	mov    0xf022(,%eax,4),%eax
    9425:	89 45 ec             	mov    %eax,-0x14(%ebp)
        func();
    9428:	8b 45 ec             	mov    -0x14(%ebp),%eax
    942b:	ff d0                	call   *%eax
    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    942d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9431:	0f b6 05 21 f0 00 00 	movzbl 0xf021,%eax
    9438:	0f be c0             	movsbl %al,%eax
    943b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    943e:	7c db                	jl     941b <keyboard_irq+0x4a>
    }
}
    9440:	90                   	nop
    9441:	90                   	nop
    9442:	c9                   	leave  
    9443:	c3                   	ret    

00009444 <reinitialise_kbd>:

void reinitialise_kbd()
{
    9444:	55                   	push   %ebp
    9445:	89 e5                	mov    %esp,%ebp
    9447:	83 ec 08             	sub    $0x8,%esp
    wait_8042_ACK();
    944a:	e8 43 00 00 00       	call   9492 <wait_8042_ACK>
    _8042_send_get_current_scan_code;
    944f:	ba 64 00 00 00       	mov    $0x64,%edx
    9454:	b8 f0 00 00 00       	mov    $0xf0,%eax
    9459:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    945a:	e8 33 00 00 00       	call   9492 <wait_8042_ACK>

    _8042_set_typematic_rate;
    945f:	ba 64 00 00 00       	mov    $0x64,%edx
    9464:	b8 f3 00 00 00       	mov    $0xf3,%eax
    9469:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    946a:	e8 23 00 00 00       	call   9492 <wait_8042_ACK>

    _8042_set_leds;
    946f:	ba 64 00 00 00       	mov    $0x64,%edx
    9474:	b8 ed 00 00 00       	mov    $0xed,%eax
    9479:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    947a:	e8 13 00 00 00       	call   9492 <wait_8042_ACK>

    _8042_enable_scanning;
    947f:	ba 64 00 00 00       	mov    $0x64,%edx
    9484:	b8 f4 00 00 00       	mov    $0xf4,%eax
    9489:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    948a:	e8 03 00 00 00       	call   9492 <wait_8042_ACK>
}
    948f:	90                   	nop
    9490:	c9                   	leave  
    9491:	c3                   	ret    

00009492 <wait_8042_ACK>:

static void
wait_8042_ACK()
{
    9492:	55                   	push   %ebp
    9493:	89 e5                	mov    %esp,%ebp
    9495:	83 ec 10             	sub    $0x10,%esp
    while (_8042_get_status != _8042_ACK)
    9498:	90                   	nop
    9499:	b8 64 00 00 00       	mov    $0x64,%eax
    949e:	89 c2                	mov    %eax,%edx
    94a0:	ec                   	in     (%dx),%al
    94a1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    94a5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    94a9:	66 3d fa 00          	cmp    $0xfa,%ax
    94ad:	75 ea                	jne    9499 <wait_8042_ACK+0x7>
        ;
}
    94af:	90                   	nop
    94b0:	90                   	nop
    94b1:	c9                   	leave  
    94b2:	c3                   	ret    

000094b3 <get_code_kbd_control>:

int16_t get_code_kbd_control()
{
    94b3:	55                   	push   %ebp
    94b4:	89 e5                	mov    %esp,%ebp
    return keyboard_ctrl.code;
    94b6:	0f b7 05 1e f4 00 00 	movzwl 0xf41e,%eax
}
    94bd:	5d                   	pop    %ebp
    94be:	c3                   	ret    

000094bf <handle_ASCII_code_keyboard>:

static void handle_ASCII_code_keyboard()
{
    94bf:	55                   	push   %ebp
    94c0:	89 e5                	mov    %esp,%ebp
    94c2:	83 ec 10             	sub    $0x10,%esp
    int16_t _code = keyboard_ctrl.code - 1;
    94c5:	0f b7 05 1e f4 00 00 	movzwl 0xf41e,%eax
    94cc:	83 e8 01             	sub    $0x1,%eax
    94cf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    if (_code < 0x80) { /* key held down */
    94d3:	66 83 7d fe 7f       	cmpw   $0x7f,-0x2(%ebp)
    94d8:	0f 8f 8f 00 00 00    	jg     956d <handle_ASCII_code_keyboard+0xae>
        switch (_code) {
    94de:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    94e2:	83 f8 37             	cmp    $0x37,%eax
    94e5:	74 3d                	je     9524 <handle_ASCII_code_keyboard+0x65>
    94e7:	83 f8 37             	cmp    $0x37,%eax
    94ea:	7f 44                	jg     9530 <handle_ASCII_code_keyboard+0x71>
    94ec:	83 f8 35             	cmp    $0x35,%eax
    94ef:	74 1b                	je     950c <handle_ASCII_code_keyboard+0x4d>
    94f1:	83 f8 35             	cmp    $0x35,%eax
    94f4:	7f 3a                	jg     9530 <handle_ASCII_code_keyboard+0x71>
    94f6:	83 f8 1c             	cmp    $0x1c,%eax
    94f9:	74 1d                	je     9518 <handle_ASCII_code_keyboard+0x59>
    94fb:	83 f8 29             	cmp    $0x29,%eax
    94fe:	75 30                	jne    9530 <handle_ASCII_code_keyboard+0x71>
        case 0x29: lshift_enable = 1; break;
    9500:	c6 05 20 f4 00 00 01 	movb   $0x1,0xf420
    9507:	e9 b8 00 00 00       	jmp    95c4 <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 1; break;
    950c:	c6 05 21 f4 00 00 01 	movb   $0x1,0xf421
    9513:	e9 ac 00 00 00       	jmp    95c4 <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 1; break;
    9518:	c6 05 23 f4 00 00 01 	movb   $0x1,0xf423
    951f:	e9 a0 00 00 00       	jmp    95c4 <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 1; break;
    9524:	c6 05 22 f4 00 00 01 	movb   $0x1,0xf422
    952b:	e9 94 00 00 00       	jmp    95c4 <handle_ASCII_code_keyboard+0x105>
        default:
            keyboard_ctrl.ascii_code_keyboard = kbdmap[_code * 4 + (lshift_enable || rshift_enable)];
    9530:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    9534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    953b:	0f b6 05 20 f4 00 00 	movzbl 0xf420,%eax
    9542:	84 c0                	test   %al,%al
    9544:	75 0b                	jne    9551 <handle_ASCII_code_keyboard+0x92>
    9546:	0f b6 05 21 f4 00 00 	movzbl 0xf421,%eax
    954d:	84 c0                	test   %al,%al
    954f:	74 07                	je     9558 <handle_ASCII_code_keyboard+0x99>
    9551:	b8 01 00 00 00       	mov    $0x1,%eax
    9556:	eb 05                	jmp    955d <handle_ASCII_code_keyboard+0x9e>
    9558:	b8 00 00 00 00       	mov    $0x0,%eax
    955d:	01 d0                	add    %edx,%eax
    955f:	0f b6 80 c0 c0 00 00 	movzbl 0xc0c0(%eax),%eax
    9566:	a2 20 f0 00 00       	mov    %al,0xf020
        case 0x35: rshift_enable = 0; break;
        case 0x1C: ctrl_enable = 0; break;
        case 0x37: alt_enable = 0; break;
        }
    }
}
    956b:	eb 57                	jmp    95c4 <handle_ASCII_code_keyboard+0x105>
        _code -= 0x80;
    956d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    9571:	83 c0 80             	add    $0xffffff80,%eax
    9574:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
        keyboard_ctrl.ascii_code_keyboard = '\0'; //Free it when release the key
    9578:	c6 05 20 f0 00 00 00 	movb   $0x0,0xf020
        switch (_code) {
    957f:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    9583:	83 f8 37             	cmp    $0x37,%eax
    9586:	74 34                	je     95bc <handle_ASCII_code_keyboard+0xfd>
    9588:	83 f8 37             	cmp    $0x37,%eax
    958b:	7f 37                	jg     95c4 <handle_ASCII_code_keyboard+0x105>
    958d:	83 f8 35             	cmp    $0x35,%eax
    9590:	74 18                	je     95aa <handle_ASCII_code_keyboard+0xeb>
    9592:	83 f8 35             	cmp    $0x35,%eax
    9595:	7f 2d                	jg     95c4 <handle_ASCII_code_keyboard+0x105>
    9597:	83 f8 1c             	cmp    $0x1c,%eax
    959a:	74 17                	je     95b3 <handle_ASCII_code_keyboard+0xf4>
    959c:	83 f8 29             	cmp    $0x29,%eax
    959f:	75 23                	jne    95c4 <handle_ASCII_code_keyboard+0x105>
        case 0x29: lshift_enable = 0; break;
    95a1:	c6 05 20 f4 00 00 00 	movb   $0x0,0xf420
    95a8:	eb 1a                	jmp    95c4 <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 0; break;
    95aa:	c6 05 21 f4 00 00 00 	movb   $0x0,0xf421
    95b1:	eb 11                	jmp    95c4 <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 0; break;
    95b3:	c6 05 23 f4 00 00 00 	movb   $0x0,0xf423
    95ba:	eb 08                	jmp    95c4 <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 0; break;
    95bc:	c6 05 22 f4 00 00 00 	movb   $0x0,0xf422
    95c3:	90                   	nop
}
    95c4:	90                   	nop
    95c5:	c9                   	leave  
    95c6:	c3                   	ret    

000095c7 <get_ASCII_code_keyboard>:

int8_t get_ASCII_code_keyboard()
{
    95c7:	55                   	push   %ebp
    95c8:	89 e5                	mov    %esp,%ebp

    handle_ASCII_code_keyboard();
    95ca:	e8 f0 fe ff ff       	call   94bf <handle_ASCII_code_keyboard>

    return keyboard_ctrl.ascii_code_keyboard;
    95cf:	0f b6 05 20 f0 00 00 	movzbl 0xf020,%eax
    95d6:	5d                   	pop    %ebp
    95d7:	c3                   	ret    

000095d8 <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    95d8:	55                   	push   %ebp
    95d9:	89 e5                	mov    %esp,%ebp
    95db:	90                   	nop
    95dc:	5d                   	pop    %ebp
    95dd:	c3                   	ret    

000095de <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    95de:	55                   	push   %ebp
    95df:	89 e5                	mov    %esp,%ebp
    95e1:	90                   	nop
    95e2:	5d                   	pop    %ebp
    95e3:	c3                   	ret    

000095e4 <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    95e4:	55                   	push   %ebp
    95e5:	89 e5                	mov    %esp,%ebp
    95e7:	83 ec 08             	sub    $0x8,%esp
    95ea:	8b 55 10             	mov    0x10(%ebp),%edx
    95ed:	8b 45 14             	mov    0x14(%ebp),%eax
    95f0:	88 55 fc             	mov    %dl,-0x4(%ebp)
    95f3:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15  = (limite & 0xFFFF);
    95f6:	8b 45 0c             	mov    0xc(%ebp),%eax
    95f9:	89 c2                	mov    %eax,%edx
    95fb:	8b 45 18             	mov    0x18(%ebp),%eax
    95fe:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    9601:	8b 45 0c             	mov    0xc(%ebp),%eax
    9604:	c1 e8 10             	shr    $0x10,%eax
    9607:	83 e0 0f             	and    $0xf,%eax
    960a:	8b 55 18             	mov    0x18(%ebp),%edx
    960d:	83 e0 0f             	and    $0xf,%eax
    9610:	89 c1                	mov    %eax,%ecx
    9612:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    9616:	83 e0 f0             	and    $0xfffffff0,%eax
    9619:	09 c8                	or     %ecx,%eax
    961b:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15  = (base & 0xFFFF);
    961e:	8b 45 08             	mov    0x8(%ebp),%eax
    9621:	89 c2                	mov    %eax,%edx
    9623:	8b 45 18             	mov    0x18(%ebp),%eax
    9626:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    962a:	8b 45 08             	mov    0x8(%ebp),%eax
    962d:	c1 e8 10             	shr    $0x10,%eax
    9630:	89 c2                	mov    %eax,%edx
    9632:	8b 45 18             	mov    0x18(%ebp),%eax
    9635:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    9638:	8b 45 08             	mov    0x8(%ebp),%eax
    963b:	c1 e8 18             	shr    $0x18,%eax
    963e:	89 c2                	mov    %eax,%edx
    9640:	8b 45 18             	mov    0x18(%ebp),%eax
    9643:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags      = flags;
    9646:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    964a:	83 e0 0f             	and    $0xf,%eax
    964d:	89 c2                	mov    %eax,%edx
    964f:	8b 45 18             	mov    0x18(%ebp),%eax
    9652:	89 d1                	mov    %edx,%ecx
    9654:	c1 e1 04             	shl    $0x4,%ecx
    9657:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    965b:	83 e2 0f             	and    $0xf,%edx
    965e:	09 ca                	or     %ecx,%edx
    9660:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    9663:	8b 45 18             	mov    0x18(%ebp),%eax
    9666:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    966a:	88 50 05             	mov    %dl,0x5(%eax)
}
    966d:	90                   	nop
    966e:	c9                   	leave  
    966f:	c3                   	ret    

00009670 <init_gdt_kernel>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt_kernel(void)
{
    9670:	55                   	push   %ebp
    9671:	89 e5                	mov    %esp,%ebp
    9673:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    9676:	a1 24 f4 00 00       	mov    0xf424,%eax
    967b:	50                   	push   %eax
    967c:	6a 00                	push   $0x0
    967e:	6a 00                	push   $0x0
    9680:	6a 00                	push   $0x0
    9682:	6a 00                	push   $0x0
    9684:	e8 5b ff ff ff       	call   95e4 <init_gdt_entry>
    9689:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    968c:	a1 24 f4 00 00       	mov    0xf424,%eax
    9691:	83 c0 08             	add    $0x8,%eax
    9694:	50                   	push   %eax
    9695:	6a 04                	push   $0x4
    9697:	68 9a 00 00 00       	push   $0x9a
    969c:	68 ff ff 0f 00       	push   $0xfffff
    96a1:	6a 00                	push   $0x0
    96a3:	e8 3c ff ff ff       	call   95e4 <init_gdt_entry>
    96a8:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    96ab:	a1 24 f4 00 00       	mov    0xf424,%eax
    96b0:	83 c0 10             	add    $0x10,%eax
    96b3:	50                   	push   %eax
    96b4:	6a 04                	push   $0x4
    96b6:	68 92 00 00 00       	push   $0x92
    96bb:	68 ff ff 0f 00       	push   $0xfffff
    96c0:	6a 00                	push   $0x0
    96c2:	e8 1d ff ff ff       	call   95e4 <init_gdt_entry>
    96c7:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    96ca:	a1 24 f4 00 00       	mov    0xf424,%eax
    96cf:	83 c0 18             	add    $0x18,%eax
    96d2:	50                   	push   %eax
    96d3:	6a 04                	push   $0x4
    96d5:	68 96 00 00 00       	push   $0x96
    96da:	68 ff ff 0f 00       	push   $0xfffff
    96df:	6a 00                	push   $0x0
    96e1:	e8 fe fe ff ff       	call   95e4 <init_gdt_entry>
    96e6:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Chargement de la GDT
    load_gdt();
    96e9:	e8 78 1b 00 00       	call   b266 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    96ee:	66 b8 10 00          	mov    $0x10,%ax
    96f2:	8e d8                	mov    %eax,%ds
    96f4:	8e c0                	mov    %eax,%es
    96f6:	8e e0                	mov    %eax,%fs
    96f8:	8e e8                	mov    %eax,%gs
    96fa:	66 b8 18 00          	mov    $0x18,%ax
    96fe:	8e d0                	mov    %eax,%ss
    9700:	ea 07 97 00 00 08 00 	ljmp   $0x8,$0x9707

00009707 <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    9707:	90                   	nop
    9708:	c9                   	leave  
    9709:	c3                   	ret    

0000970a <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    970a:	55                   	push   %ebp
    970b:	89 e5                	mov    %esp,%ebp
    970d:	83 ec 18             	sub    $0x18,%esp
    9710:	8b 45 08             	mov    0x8(%ebp),%eax
    9713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    9716:	8b 55 18             	mov    0x18(%ebp),%edx
    9719:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    971d:	89 c8                	mov    %ecx,%eax
    971f:	88 45 f8             	mov    %al,-0x8(%ebp)
    9722:	8b 45 10             	mov    0x10(%ebp),%eax
    9725:	89 45 f0             	mov    %eax,-0x10(%ebp)
    9728:	8b 45 14             	mov    0x14(%ebp),%eax
    972b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    972e:	89 d0                	mov    %edx,%eax
    9730:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    9734:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9738:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    973c:	66 89 14 c5 42 f4 00 	mov    %dx,0xf442(,%eax,8)
    9743:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    9744:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9748:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    974c:	88 14 c5 45 f4 00 00 	mov    %dl,0xf445(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    9753:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9757:	c6 04 c5 44 f4 00 00 	movb   $0x0,0xf444(,%eax,8)
    975e:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    975f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9763:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9766:	66 89 14 c5 40 f4 00 	mov    %dx,0xf440(,%eax,8)
    976d:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    976e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9771:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9774:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    9778:	c1 ea 10             	shr    $0x10,%edx
    977b:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    977f:	66 89 04 cd 46 f4 00 	mov    %ax,0xf446(,%ecx,8)
    9786:	00 
}
    9787:	90                   	nop
    9788:	c9                   	leave  
    9789:	c3                   	ret    

0000978a <init_idt>:

void init_idt()
{
    978a:	55                   	push   %ebp
    978b:	89 e5                	mov    %esp,%ebp
    978d:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    9790:	83 ec 0c             	sub    $0xc,%esp
    9793:	68 ad da 00 00       	push   $0xdaad
    9798:	e8 bb 0b 00 00       	call   a358 <Init_PIT>
    979d:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    97a0:	83 ec 08             	sub    $0x8,%esp
    97a3:	6a 28                	push   $0x28
    97a5:	6a 20                	push   $0x20
    97a7:	e8 bf 08 00 00       	call   a06b <PIC_remap>
    97ac:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    97af:	b8 80 b3 00 00       	mov    $0xb380,%eax
    97b4:	ba 00 00 00 00       	mov    $0x0,%edx
    97b9:	83 ec 0c             	sub    $0xc,%esp
    97bc:	6a 20                	push   $0x20
    97be:	52                   	push   %edx
    97bf:	50                   	push   %eax
    97c0:	68 8e 00 00 00       	push   $0x8e
    97c5:	6a 08                	push   $0x8
    97c7:	e8 3e ff ff ff       	call   970a <set_idt>
    97cc:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    97cf:	b8 d0 b2 00 00       	mov    $0xb2d0,%eax
    97d4:	ba 00 00 00 00       	mov    $0x0,%edx
    97d9:	83 ec 0c             	sub    $0xc,%esp
    97dc:	6a 21                	push   $0x21
    97de:	52                   	push   %edx
    97df:	50                   	push   %eax
    97e0:	68 8e 00 00 00       	push   $0x8e
    97e5:	6a 08                	push   $0x8
    97e7:	e8 1e ff ff ff       	call   970a <set_idt>
    97ec:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    97ef:	b8 d8 b2 00 00       	mov    $0xb2d8,%eax
    97f4:	ba 00 00 00 00       	mov    $0x0,%edx
    97f9:	83 ec 0c             	sub    $0xc,%esp
    97fc:	6a 22                	push   $0x22
    97fe:	52                   	push   %edx
    97ff:	50                   	push   %eax
    9800:	68 8e 00 00 00       	push   $0x8e
    9805:	6a 08                	push   $0x8
    9807:	e8 fe fe ff ff       	call   970a <set_idt>
    980c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    980f:	b8 e0 b2 00 00       	mov    $0xb2e0,%eax
    9814:	ba 00 00 00 00       	mov    $0x0,%edx
    9819:	83 ec 0c             	sub    $0xc,%esp
    981c:	6a 23                	push   $0x23
    981e:	52                   	push   %edx
    981f:	50                   	push   %eax
    9820:	68 8e 00 00 00       	push   $0x8e
    9825:	6a 08                	push   $0x8
    9827:	e8 de fe ff ff       	call   970a <set_idt>
    982c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    982f:	b8 e8 b2 00 00       	mov    $0xb2e8,%eax
    9834:	ba 00 00 00 00       	mov    $0x0,%edx
    9839:	83 ec 0c             	sub    $0xc,%esp
    983c:	6a 24                	push   $0x24
    983e:	52                   	push   %edx
    983f:	50                   	push   %eax
    9840:	68 8e 00 00 00       	push   $0x8e
    9845:	6a 08                	push   $0x8
    9847:	e8 be fe ff ff       	call   970a <set_idt>
    984c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    984f:	b8 f0 b2 00 00       	mov    $0xb2f0,%eax
    9854:	ba 00 00 00 00       	mov    $0x0,%edx
    9859:	83 ec 0c             	sub    $0xc,%esp
    985c:	6a 25                	push   $0x25
    985e:	52                   	push   %edx
    985f:	50                   	push   %eax
    9860:	68 8e 00 00 00       	push   $0x8e
    9865:	6a 08                	push   $0x8
    9867:	e8 9e fe ff ff       	call   970a <set_idt>
    986c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    986f:	b8 f8 b2 00 00       	mov    $0xb2f8,%eax
    9874:	ba 00 00 00 00       	mov    $0x0,%edx
    9879:	83 ec 0c             	sub    $0xc,%esp
    987c:	6a 26                	push   $0x26
    987e:	52                   	push   %edx
    987f:	50                   	push   %eax
    9880:	68 8e 00 00 00       	push   $0x8e
    9885:	6a 08                	push   $0x8
    9887:	e8 7e fe ff ff       	call   970a <set_idt>
    988c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    988f:	b8 00 b3 00 00       	mov    $0xb300,%eax
    9894:	ba 00 00 00 00       	mov    $0x0,%edx
    9899:	83 ec 0c             	sub    $0xc,%esp
    989c:	6a 27                	push   $0x27
    989e:	52                   	push   %edx
    989f:	50                   	push   %eax
    98a0:	68 8e 00 00 00       	push   $0x8e
    98a5:	6a 08                	push   $0x8
    98a7:	e8 5e fe ff ff       	call   970a <set_idt>
    98ac:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    98af:	b8 08 b3 00 00       	mov    $0xb308,%eax
    98b4:	ba 00 00 00 00       	mov    $0x0,%edx
    98b9:	83 ec 0c             	sub    $0xc,%esp
    98bc:	6a 28                	push   $0x28
    98be:	52                   	push   %edx
    98bf:	50                   	push   %eax
    98c0:	68 8e 00 00 00       	push   $0x8e
    98c5:	6a 08                	push   $0x8
    98c7:	e8 3e fe ff ff       	call   970a <set_idt>
    98cc:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    98cf:	b8 10 b3 00 00       	mov    $0xb310,%eax
    98d4:	ba 00 00 00 00       	mov    $0x0,%edx
    98d9:	83 ec 0c             	sub    $0xc,%esp
    98dc:	6a 29                	push   $0x29
    98de:	52                   	push   %edx
    98df:	50                   	push   %eax
    98e0:	68 8e 00 00 00       	push   $0x8e
    98e5:	6a 08                	push   $0x8
    98e7:	e8 1e fe ff ff       	call   970a <set_idt>
    98ec:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    98ef:	b8 18 b3 00 00       	mov    $0xb318,%eax
    98f4:	ba 00 00 00 00       	mov    $0x0,%edx
    98f9:	83 ec 0c             	sub    $0xc,%esp
    98fc:	6a 2a                	push   $0x2a
    98fe:	52                   	push   %edx
    98ff:	50                   	push   %eax
    9900:	68 8e 00 00 00       	push   $0x8e
    9905:	6a 08                	push   $0x8
    9907:	e8 fe fd ff ff       	call   970a <set_idt>
    990c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    990f:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9914:	ba 00 00 00 00       	mov    $0x0,%edx
    9919:	83 ec 0c             	sub    $0xc,%esp
    991c:	6a 2b                	push   $0x2b
    991e:	52                   	push   %edx
    991f:	50                   	push   %eax
    9920:	68 8e 00 00 00       	push   $0x8e
    9925:	6a 08                	push   $0x8
    9927:	e8 de fd ff ff       	call   970a <set_idt>
    992c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    992f:	b8 28 b3 00 00       	mov    $0xb328,%eax
    9934:	ba 00 00 00 00       	mov    $0x0,%edx
    9939:	83 ec 0c             	sub    $0xc,%esp
    993c:	6a 2c                	push   $0x2c
    993e:	52                   	push   %edx
    993f:	50                   	push   %eax
    9940:	68 8e 00 00 00       	push   $0x8e
    9945:	6a 08                	push   $0x8
    9947:	e8 be fd ff ff       	call   970a <set_idt>
    994c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    994f:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9954:	ba 00 00 00 00       	mov    $0x0,%edx
    9959:	83 ec 0c             	sub    $0xc,%esp
    995c:	6a 2d                	push   $0x2d
    995e:	52                   	push   %edx
    995f:	50                   	push   %eax
    9960:	68 8e 00 00 00       	push   $0x8e
    9965:	6a 08                	push   $0x8
    9967:	e8 9e fd ff ff       	call   970a <set_idt>
    996c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    996f:	b8 38 b3 00 00       	mov    $0xb338,%eax
    9974:	ba 00 00 00 00       	mov    $0x0,%edx
    9979:	83 ec 0c             	sub    $0xc,%esp
    997c:	6a 2e                	push   $0x2e
    997e:	52                   	push   %edx
    997f:	50                   	push   %eax
    9980:	68 8e 00 00 00       	push   $0x8e
    9985:	6a 08                	push   $0x8
    9987:	e8 7e fd ff ff       	call   970a <set_idt>
    998c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    998f:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9994:	ba 00 00 00 00       	mov    $0x0,%edx
    9999:	83 ec 0c             	sub    $0xc,%esp
    999c:	6a 2f                	push   $0x2f
    999e:	52                   	push   %edx
    999f:	50                   	push   %eax
    99a0:	68 8e 00 00 00       	push   $0x8e
    99a5:	6a 08                	push   $0x8
    99a7:	e8 5e fd ff ff       	call   970a <set_idt>
    99ac:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    99af:	b8 40 b2 00 00       	mov    $0xb240,%eax
    99b4:	ba 00 00 00 00       	mov    $0x0,%edx
    99b9:	83 ec 0c             	sub    $0xc,%esp
    99bc:	6a 08                	push   $0x8
    99be:	52                   	push   %edx
    99bf:	50                   	push   %eax
    99c0:	68 8e 00 00 00       	push   $0x8e
    99c5:	6a 08                	push   $0x8
    99c7:	e8 3e fd ff ff       	call   970a <set_idt>
    99cc:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    99cf:	b8 40 b2 00 00       	mov    $0xb240,%eax
    99d4:	ba 00 00 00 00       	mov    $0x0,%edx
    99d9:	83 ec 0c             	sub    $0xc,%esp
    99dc:	6a 0a                	push   $0xa
    99de:	52                   	push   %edx
    99df:	50                   	push   %eax
    99e0:	68 8e 00 00 00       	push   $0x8e
    99e5:	6a 08                	push   $0x8
    99e7:	e8 1e fd ff ff       	call   970a <set_idt>
    99ec:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    99ef:	b8 40 b2 00 00       	mov    $0xb240,%eax
    99f4:	ba 00 00 00 00       	mov    $0x0,%edx
    99f9:	83 ec 0c             	sub    $0xc,%esp
    99fc:	6a 0b                	push   $0xb
    99fe:	52                   	push   %edx
    99ff:	50                   	push   %eax
    9a00:	68 8e 00 00 00       	push   $0x8e
    9a05:	6a 08                	push   $0x8
    9a07:	e8 fe fc ff ff       	call   970a <set_idt>
    9a0c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9a0f:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9a14:	ba 00 00 00 00       	mov    $0x0,%edx
    9a19:	83 ec 0c             	sub    $0xc,%esp
    9a1c:	6a 0c                	push   $0xc
    9a1e:	52                   	push   %edx
    9a1f:	50                   	push   %eax
    9a20:	68 8e 00 00 00       	push   $0x8e
    9a25:	6a 08                	push   $0x8
    9a27:	e8 de fc ff ff       	call   970a <set_idt>
    9a2c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9a2f:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9a34:	ba 00 00 00 00       	mov    $0x0,%edx
    9a39:	83 ec 0c             	sub    $0xc,%esp
    9a3c:	6a 0d                	push   $0xd
    9a3e:	52                   	push   %edx
    9a3f:	50                   	push   %eax
    9a40:	68 8e 00 00 00       	push   $0x8e
    9a45:	6a 08                	push   $0x8
    9a47:	e8 be fc ff ff       	call   970a <set_idt>
    9a4c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    9a4f:	b8 3a a0 00 00       	mov    $0xa03a,%eax
    9a54:	ba 00 00 00 00       	mov    $0x0,%edx
    9a59:	83 ec 0c             	sub    $0xc,%esp
    9a5c:	6a 0e                	push   $0xe
    9a5e:	52                   	push   %edx
    9a5f:	50                   	push   %eax
    9a60:	68 8e 00 00 00       	push   $0x8e
    9a65:	6a 08                	push   $0x8
    9a67:	e8 9e fc ff ff       	call   970a <set_idt>
    9a6c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    9a6f:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9a74:	ba 00 00 00 00       	mov    $0x0,%edx
    9a79:	83 ec 0c             	sub    $0xc,%esp
    9a7c:	6a 11                	push   $0x11
    9a7e:	52                   	push   %edx
    9a7f:	50                   	push   %eax
    9a80:	68 8e 00 00 00       	push   $0x8e
    9a85:	6a 08                	push   $0x8
    9a87:	e8 7e fc ff ff       	call   970a <set_idt>
    9a8c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    9a8f:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9a94:	ba 00 00 00 00       	mov    $0x0,%edx
    9a99:	83 ec 0c             	sub    $0xc,%esp
    9a9c:	6a 1e                	push   $0x1e
    9a9e:	52                   	push   %edx
    9a9f:	50                   	push   %eax
    9aa0:	68 8e 00 00 00       	push   $0x8e
    9aa5:	6a 08                	push   $0x8
    9aa7:	e8 5e fc ff ff       	call   970a <set_idt>
    9aac:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9aaf:	b8 de 95 00 00       	mov    $0x95de,%eax
    9ab4:	ba 00 00 00 00       	mov    $0x0,%edx
    9ab9:	83 ec 0c             	sub    $0xc,%esp
    9abc:	6a 00                	push   $0x0
    9abe:	52                   	push   %edx
    9abf:	50                   	push   %eax
    9ac0:	68 8e 00 00 00       	push   $0x8e
    9ac5:	6a 08                	push   $0x8
    9ac7:	e8 3e fc ff ff       	call   970a <set_idt>
    9acc:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9acf:	b8 de 95 00 00       	mov    $0x95de,%eax
    9ad4:	ba 00 00 00 00       	mov    $0x0,%edx
    9ad9:	83 ec 0c             	sub    $0xc,%esp
    9adc:	6a 01                	push   $0x1
    9ade:	52                   	push   %edx
    9adf:	50                   	push   %eax
    9ae0:	68 8e 00 00 00       	push   $0x8e
    9ae5:	6a 08                	push   $0x8
    9ae7:	e8 1e fc ff ff       	call   970a <set_idt>
    9aec:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9aef:	b8 de 95 00 00       	mov    $0x95de,%eax
    9af4:	ba 00 00 00 00       	mov    $0x0,%edx
    9af9:	83 ec 0c             	sub    $0xc,%esp
    9afc:	6a 02                	push   $0x2
    9afe:	52                   	push   %edx
    9aff:	50                   	push   %eax
    9b00:	68 8e 00 00 00       	push   $0x8e
    9b05:	6a 08                	push   $0x8
    9b07:	e8 fe fb ff ff       	call   970a <set_idt>
    9b0c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9b0f:	b8 de 95 00 00       	mov    $0x95de,%eax
    9b14:	ba 00 00 00 00       	mov    $0x0,%edx
    9b19:	83 ec 0c             	sub    $0xc,%esp
    9b1c:	6a 03                	push   $0x3
    9b1e:	52                   	push   %edx
    9b1f:	50                   	push   %eax
    9b20:	68 8e 00 00 00       	push   $0x8e
    9b25:	6a 08                	push   $0x8
    9b27:	e8 de fb ff ff       	call   970a <set_idt>
    9b2c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9b2f:	b8 de 95 00 00       	mov    $0x95de,%eax
    9b34:	ba 00 00 00 00       	mov    $0x0,%edx
    9b39:	83 ec 0c             	sub    $0xc,%esp
    9b3c:	6a 04                	push   $0x4
    9b3e:	52                   	push   %edx
    9b3f:	50                   	push   %eax
    9b40:	68 8e 00 00 00       	push   $0x8e
    9b45:	6a 08                	push   $0x8
    9b47:	e8 be fb ff ff       	call   970a <set_idt>
    9b4c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    9b4f:	b8 de 95 00 00       	mov    $0x95de,%eax
    9b54:	ba 00 00 00 00       	mov    $0x0,%edx
    9b59:	83 ec 0c             	sub    $0xc,%esp
    9b5c:	6a 05                	push   $0x5
    9b5e:	52                   	push   %edx
    9b5f:	50                   	push   %eax
    9b60:	68 8e 00 00 00       	push   $0x8e
    9b65:	6a 08                	push   $0x8
    9b67:	e8 9e fb ff ff       	call   970a <set_idt>
    9b6c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    9b6f:	b8 de 95 00 00       	mov    $0x95de,%eax
    9b74:	ba 00 00 00 00       	mov    $0x0,%edx
    9b79:	83 ec 0c             	sub    $0xc,%esp
    9b7c:	6a 06                	push   $0x6
    9b7e:	52                   	push   %edx
    9b7f:	50                   	push   %eax
    9b80:	68 8e 00 00 00       	push   $0x8e
    9b85:	6a 08                	push   $0x8
    9b87:	e8 7e fb ff ff       	call   970a <set_idt>
    9b8c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    9b8f:	b8 de 95 00 00       	mov    $0x95de,%eax
    9b94:	ba 00 00 00 00       	mov    $0x0,%edx
    9b99:	83 ec 0c             	sub    $0xc,%esp
    9b9c:	6a 07                	push   $0x7
    9b9e:	52                   	push   %edx
    9b9f:	50                   	push   %eax
    9ba0:	68 8e 00 00 00       	push   $0x8e
    9ba5:	6a 08                	push   $0x8
    9ba7:	e8 5e fb ff ff       	call   970a <set_idt>
    9bac:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9baf:	b8 de 95 00 00       	mov    $0x95de,%eax
    9bb4:	ba 00 00 00 00       	mov    $0x0,%edx
    9bb9:	83 ec 0c             	sub    $0xc,%esp
    9bbc:	6a 09                	push   $0x9
    9bbe:	52                   	push   %edx
    9bbf:	50                   	push   %eax
    9bc0:	68 8e 00 00 00       	push   $0x8e
    9bc5:	6a 08                	push   $0x8
    9bc7:	e8 3e fb ff ff       	call   970a <set_idt>
    9bcc:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9bcf:	b8 de 95 00 00       	mov    $0x95de,%eax
    9bd4:	ba 00 00 00 00       	mov    $0x0,%edx
    9bd9:	83 ec 0c             	sub    $0xc,%esp
    9bdc:	6a 10                	push   $0x10
    9bde:	52                   	push   %edx
    9bdf:	50                   	push   %eax
    9be0:	68 8e 00 00 00       	push   $0x8e
    9be5:	6a 08                	push   $0x8
    9be7:	e8 1e fb ff ff       	call   970a <set_idt>
    9bec:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9bef:	b8 de 95 00 00       	mov    $0x95de,%eax
    9bf4:	ba 00 00 00 00       	mov    $0x0,%edx
    9bf9:	83 ec 0c             	sub    $0xc,%esp
    9bfc:	6a 12                	push   $0x12
    9bfe:	52                   	push   %edx
    9bff:	50                   	push   %eax
    9c00:	68 8e 00 00 00       	push   $0x8e
    9c05:	6a 08                	push   $0x8
    9c07:	e8 fe fa ff ff       	call   970a <set_idt>
    9c0c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9c0f:	b8 de 95 00 00       	mov    $0x95de,%eax
    9c14:	ba 00 00 00 00       	mov    $0x0,%edx
    9c19:	83 ec 0c             	sub    $0xc,%esp
    9c1c:	6a 13                	push   $0x13
    9c1e:	52                   	push   %edx
    9c1f:	50                   	push   %eax
    9c20:	68 8e 00 00 00       	push   $0x8e
    9c25:	6a 08                	push   $0x8
    9c27:	e8 de fa ff ff       	call   970a <set_idt>
    9c2c:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9c2f:	b8 de 95 00 00       	mov    $0x95de,%eax
    9c34:	ba 00 00 00 00       	mov    $0x0,%edx
    9c39:	83 ec 0c             	sub    $0xc,%esp
    9c3c:	6a 14                	push   $0x14
    9c3e:	52                   	push   %edx
    9c3f:	50                   	push   %eax
    9c40:	68 8e 00 00 00       	push   $0x8e
    9c45:	6a 08                	push   $0x8
    9c47:	e8 be fa ff ff       	call   970a <set_idt>
    9c4c:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    9c4f:	e8 4b 16 00 00       	call   b29f <load_idt>
}
    9c54:	90                   	nop
    9c55:	c9                   	leave  
    9c56:	c3                   	ret    

00009c57 <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    9c57:	55                   	push   %ebp
    9c58:	89 e5                	mov    %esp,%ebp
    9c5a:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    9c5d:	e8 6f f7 ff ff       	call   93d1 <keyboard_irq>
    PIC_sendEOI(1);
    9c62:	83 ec 0c             	sub    $0xc,%esp
    9c65:	6a 01                	push   $0x1
    9c67:	e8 d4 03 00 00       	call   a040 <PIC_sendEOI>
    9c6c:	83 c4 10             	add    $0x10,%esp
}
    9c6f:	90                   	nop
    9c70:	c9                   	leave  
    9c71:	c3                   	ret    

00009c72 <irq2_handler>:

void irq2_handler(void)
{
    9c72:	55                   	push   %ebp
    9c73:	89 e5                	mov    %esp,%ebp
    9c75:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    9c78:	83 ec 0c             	sub    $0xc,%esp
    9c7b:	6a 02                	push   $0x2
    9c7d:	e8 ca 05 00 00       	call   a24c <spurious_IRQ>
    9c82:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9c85:	83 ec 0c             	sub    $0xc,%esp
    9c88:	6a 02                	push   $0x2
    9c8a:	e8 b1 03 00 00       	call   a040 <PIC_sendEOI>
    9c8f:	83 c4 10             	add    $0x10,%esp
}
    9c92:	90                   	nop
    9c93:	c9                   	leave  
    9c94:	c3                   	ret    

00009c95 <irq3_handler>:

void irq3_handler(void)
{
    9c95:	55                   	push   %ebp
    9c96:	89 e5                	mov    %esp,%ebp
    9c98:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    9c9b:	83 ec 0c             	sub    $0xc,%esp
    9c9e:	6a 03                	push   $0x3
    9ca0:	e8 a7 05 00 00       	call   a24c <spurious_IRQ>
    9ca5:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9ca8:	83 ec 0c             	sub    $0xc,%esp
    9cab:	6a 03                	push   $0x3
    9cad:	e8 8e 03 00 00       	call   a040 <PIC_sendEOI>
    9cb2:	83 c4 10             	add    $0x10,%esp
}
    9cb5:	90                   	nop
    9cb6:	c9                   	leave  
    9cb7:	c3                   	ret    

00009cb8 <irq4_handler>:

void irq4_handler(void)
{
    9cb8:	55                   	push   %ebp
    9cb9:	89 e5                	mov    %esp,%ebp
    9cbb:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    9cbe:	83 ec 0c             	sub    $0xc,%esp
    9cc1:	6a 04                	push   $0x4
    9cc3:	e8 84 05 00 00       	call   a24c <spurious_IRQ>
    9cc8:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9ccb:	83 ec 0c             	sub    $0xc,%esp
    9cce:	6a 04                	push   $0x4
    9cd0:	e8 6b 03 00 00       	call   a040 <PIC_sendEOI>
    9cd5:	83 c4 10             	add    $0x10,%esp
}
    9cd8:	90                   	nop
    9cd9:	c9                   	leave  
    9cda:	c3                   	ret    

00009cdb <irq5_handler>:

void irq5_handler(void)
{
    9cdb:	55                   	push   %ebp
    9cdc:	89 e5                	mov    %esp,%ebp
    9cde:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9ce1:	83 ec 0c             	sub    $0xc,%esp
    9ce4:	6a 05                	push   $0x5
    9ce6:	e8 61 05 00 00       	call   a24c <spurious_IRQ>
    9ceb:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9cee:	83 ec 0c             	sub    $0xc,%esp
    9cf1:	6a 05                	push   $0x5
    9cf3:	e8 48 03 00 00       	call   a040 <PIC_sendEOI>
    9cf8:	83 c4 10             	add    $0x10,%esp
}
    9cfb:	90                   	nop
    9cfc:	c9                   	leave  
    9cfd:	c3                   	ret    

00009cfe <irq6_handler>:

void irq6_handler(void)
{
    9cfe:	55                   	push   %ebp
    9cff:	89 e5                	mov    %esp,%ebp
    9d01:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9d04:	83 ec 0c             	sub    $0xc,%esp
    9d07:	6a 06                	push   $0x6
    9d09:	e8 3e 05 00 00       	call   a24c <spurious_IRQ>
    9d0e:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9d11:	83 ec 0c             	sub    $0xc,%esp
    9d14:	6a 06                	push   $0x6
    9d16:	e8 25 03 00 00       	call   a040 <PIC_sendEOI>
    9d1b:	83 c4 10             	add    $0x10,%esp
}
    9d1e:	90                   	nop
    9d1f:	c9                   	leave  
    9d20:	c3                   	ret    

00009d21 <irq7_handler>:

void irq7_handler(void)
{
    9d21:	55                   	push   %ebp
    9d22:	89 e5                	mov    %esp,%ebp
    9d24:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9d27:	83 ec 0c             	sub    $0xc,%esp
    9d2a:	6a 07                	push   $0x7
    9d2c:	e8 1b 05 00 00       	call   a24c <spurious_IRQ>
    9d31:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9d34:	83 ec 0c             	sub    $0xc,%esp
    9d37:	6a 07                	push   $0x7
    9d39:	e8 02 03 00 00       	call   a040 <PIC_sendEOI>
    9d3e:	83 c4 10             	add    $0x10,%esp
}
    9d41:	90                   	nop
    9d42:	c9                   	leave  
    9d43:	c3                   	ret    

00009d44 <irq8_handler>:

void irq8_handler(void)
{
    9d44:	55                   	push   %ebp
    9d45:	89 e5                	mov    %esp,%ebp
    9d47:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    9d4a:	83 ec 0c             	sub    $0xc,%esp
    9d4d:	6a 08                	push   $0x8
    9d4f:	e8 f8 04 00 00       	call   a24c <spurious_IRQ>
    9d54:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9d57:	83 ec 0c             	sub    $0xc,%esp
    9d5a:	6a 08                	push   $0x8
    9d5c:	e8 df 02 00 00       	call   a040 <PIC_sendEOI>
    9d61:	83 c4 10             	add    $0x10,%esp
}
    9d64:	90                   	nop
    9d65:	c9                   	leave  
    9d66:	c3                   	ret    

00009d67 <irq9_handler>:

void irq9_handler(void)
{
    9d67:	55                   	push   %ebp
    9d68:	89 e5                	mov    %esp,%ebp
    9d6a:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    9d6d:	83 ec 0c             	sub    $0xc,%esp
    9d70:	6a 09                	push   $0x9
    9d72:	e8 d5 04 00 00       	call   a24c <spurious_IRQ>
    9d77:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9d7a:	83 ec 0c             	sub    $0xc,%esp
    9d7d:	6a 09                	push   $0x9
    9d7f:	e8 bc 02 00 00       	call   a040 <PIC_sendEOI>
    9d84:	83 c4 10             	add    $0x10,%esp
}
    9d87:	90                   	nop
    9d88:	c9                   	leave  
    9d89:	c3                   	ret    

00009d8a <irq10_handler>:

void irq10_handler(void)
{
    9d8a:	55                   	push   %ebp
    9d8b:	89 e5                	mov    %esp,%ebp
    9d8d:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    9d90:	83 ec 0c             	sub    $0xc,%esp
    9d93:	6a 0a                	push   $0xa
    9d95:	e8 b2 04 00 00       	call   a24c <spurious_IRQ>
    9d9a:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9d9d:	83 ec 0c             	sub    $0xc,%esp
    9da0:	6a 0a                	push   $0xa
    9da2:	e8 99 02 00 00       	call   a040 <PIC_sendEOI>
    9da7:	83 c4 10             	add    $0x10,%esp
}
    9daa:	90                   	nop
    9dab:	c9                   	leave  
    9dac:	c3                   	ret    

00009dad <irq11_handler>:

void irq11_handler(void)
{
    9dad:	55                   	push   %ebp
    9dae:	89 e5                	mov    %esp,%ebp
    9db0:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9db3:	83 ec 0c             	sub    $0xc,%esp
    9db6:	6a 0b                	push   $0xb
    9db8:	e8 8f 04 00 00       	call   a24c <spurious_IRQ>
    9dbd:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9dc0:	83 ec 0c             	sub    $0xc,%esp
    9dc3:	6a 0b                	push   $0xb
    9dc5:	e8 76 02 00 00       	call   a040 <PIC_sendEOI>
    9dca:	83 c4 10             	add    $0x10,%esp
}
    9dcd:	90                   	nop
    9dce:	c9                   	leave  
    9dcf:	c3                   	ret    

00009dd0 <irq12_handler>:

void irq12_handler(void)
{
    9dd0:	55                   	push   %ebp
    9dd1:	89 e5                	mov    %esp,%ebp
    9dd3:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9dd6:	83 ec 0c             	sub    $0xc,%esp
    9dd9:	6a 0c                	push   $0xc
    9ddb:	e8 6c 04 00 00       	call   a24c <spurious_IRQ>
    9de0:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9de3:	83 ec 0c             	sub    $0xc,%esp
    9de6:	6a 0c                	push   $0xc
    9de8:	e8 53 02 00 00       	call   a040 <PIC_sendEOI>
    9ded:	83 c4 10             	add    $0x10,%esp
}
    9df0:	90                   	nop
    9df1:	c9                   	leave  
    9df2:	c3                   	ret    

00009df3 <irq13_handler>:

void irq13_handler(void)
{
    9df3:	55                   	push   %ebp
    9df4:	89 e5                	mov    %esp,%ebp
    9df6:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9df9:	83 ec 0c             	sub    $0xc,%esp
    9dfc:	6a 0d                	push   $0xd
    9dfe:	e8 49 04 00 00       	call   a24c <spurious_IRQ>
    9e03:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9e06:	83 ec 0c             	sub    $0xc,%esp
    9e09:	6a 0d                	push   $0xd
    9e0b:	e8 30 02 00 00       	call   a040 <PIC_sendEOI>
    9e10:	83 c4 10             	add    $0x10,%esp
}
    9e13:	90                   	nop
    9e14:	c9                   	leave  
    9e15:	c3                   	ret    

00009e16 <irq14_handler>:

void irq14_handler(void)
{
    9e16:	55                   	push   %ebp
    9e17:	89 e5                	mov    %esp,%ebp
    9e19:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9e1c:	83 ec 0c             	sub    $0xc,%esp
    9e1f:	6a 0e                	push   $0xe
    9e21:	e8 26 04 00 00       	call   a24c <spurious_IRQ>
    9e26:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9e29:	83 ec 0c             	sub    $0xc,%esp
    9e2c:	6a 0e                	push   $0xe
    9e2e:	e8 0d 02 00 00       	call   a040 <PIC_sendEOI>
    9e33:	83 c4 10             	add    $0x10,%esp
}
    9e36:	90                   	nop
    9e37:	c9                   	leave  
    9e38:	c3                   	ret    

00009e39 <irq15_handler>:

void irq15_handler(void)
{
    9e39:	55                   	push   %ebp
    9e3a:	89 e5                	mov    %esp,%ebp
    9e3c:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    9e3f:	83 ec 0c             	sub    $0xc,%esp
    9e42:	6a 0f                	push   $0xf
    9e44:	e8 03 04 00 00       	call   a24c <spurious_IRQ>
    9e49:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    9e4c:	83 ec 0c             	sub    $0xc,%esp
    9e4f:	6a 0f                	push   $0xf
    9e51:	e8 ea 01 00 00       	call   a040 <PIC_sendEOI>
    9e56:	83 c4 10             	add    $0x10,%esp
    9e59:	90                   	nop
    9e5a:	c9                   	leave  
    9e5b:	c3                   	ret    

00009e5c <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    9e5c:	55                   	push   %ebp
    9e5d:	89 e5                	mov    %esp,%ebp
    9e5f:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    9e62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9e69:	eb 20                	jmp    9e8b <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    9e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9e6e:	c1 e0 0c             	shl    $0xc,%eax
    9e71:	89 c2                	mov    %eax,%edx
    9e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9e76:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    9e7d:	8b 45 08             	mov    0x8(%ebp),%eax
    9e80:	01 c8                	add    %ecx,%eax
    9e82:	83 ca 23             	or     $0x23,%edx
    9e85:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    9e87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9e8b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    9e92:	76 d7                	jbe    9e6b <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    9e94:	8b 45 08             	mov    0x8(%ebp),%eax
    9e97:	83 c8 23             	or     $0x23,%eax
    9e9a:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    9e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
    9e9f:	89 14 85 00 00 01 00 	mov    %edx,0x10000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    9ea6:	e8 a5 14 00 00       	call   b350 <_FlushPagingCache_>
}
    9eab:	90                   	nop
    9eac:	c9                   	leave  
    9ead:	c3                   	ret    

00009eae <init_paging>:

void init_paging()
{
    9eae:	55                   	push   %ebp
    9eaf:	89 e5                	mov    %esp,%ebp
    9eb1:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    9eb4:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    9eba:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    9ec0:	eb 1a                	jmp    9edc <init_paging+0x2e>
        page_directory[i] =
    9ec2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9ec6:	c7 04 85 00 00 01 00 	movl   $0x2,0x10000(,%eax,4)
    9ecd:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    9ed1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9ed5:	83 c0 01             	add    $0x1,%eax
    9ed8:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    9edc:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    9ee2:	76 de                	jbe    9ec2 <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    9ee4:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    9eea:	eb 22                	jmp    9f0e <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    9eec:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9ef0:	c1 e0 0c             	shl    $0xc,%eax
    9ef3:	83 c8 23             	or     $0x23,%eax
    9ef6:	89 c2                	mov    %eax,%edx
    9ef8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9efc:	89 14 85 00 d0 00 00 	mov    %edx,0xd000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    9f03:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9f07:	83 c0 01             	add    $0x1,%eax
    9f0a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    9f0e:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    9f14:	76 d6                	jbe    9eec <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    9f16:	b8 00 d0 00 00       	mov    $0xd000,%eax
    9f1b:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    9f1e:	a3 00 00 01 00       	mov    %eax,0x10000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    9f23:	e8 31 14 00 00       	call   b359 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    9f28:	90                   	nop
    9f29:	c9                   	leave  
    9f2a:	c3                   	ret    

00009f2b <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    9f2b:	55                   	push   %ebp
    9f2c:	89 e5                	mov    %esp,%ebp
    9f2e:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    9f31:	8b 45 08             	mov    0x8(%ebp),%eax
    9f34:	c1 e8 16             	shr    $0x16,%eax
    9f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    9f3a:	8b 45 08             	mov    0x8(%ebp),%eax
    9f3d:	c1 e8 0c             	shr    $0xc,%eax
    9f40:	25 ff 03 00 00       	and    $0x3ff,%eax
    9f45:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    9f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9f4b:	8b 04 85 00 00 01 00 	mov    0x10000(,%eax,4),%eax
    9f52:	83 e0 23             	and    $0x23,%eax
    9f55:	83 f8 23             	cmp    $0x23,%eax
    9f58:	75 56                	jne    9fb0 <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    9f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9f5d:	8b 04 85 00 00 01 00 	mov    0x10000(,%eax,4),%eax
    9f64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    9f69:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    9f6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9f6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    9f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9f79:	01 d0                	add    %edx,%eax
    9f7b:	8b 00                	mov    (%eax),%eax
    9f7d:	83 e0 23             	and    $0x23,%eax
    9f80:	83 f8 23             	cmp    $0x23,%eax
    9f83:	75 24                	jne    9fa9 <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    9f85:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9f88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    9f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9f92:	01 d0                	add    %edx,%eax
    9f94:	8b 00                	mov    (%eax),%eax
    9f96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    9f9b:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    9f9d:	8b 45 08             	mov    0x8(%ebp),%eax
    9fa0:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    9fa5:	09 d0                	or     %edx,%eax
    9fa7:	eb 0c                	jmp    9fb5 <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    9fa9:	b8 53 b5 00 00       	mov    $0xb553,%eax
    9fae:	eb 05                	jmp    9fb5 <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    9fb0:	b8 53 b5 00 00       	mov    $0xb553,%eax
}
    9fb5:	c9                   	leave  
    9fb6:	c3                   	ret    

00009fb7 <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    9fb7:	55                   	push   %ebp
    9fb8:	89 e5                	mov    %esp,%ebp
    9fba:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    9fbd:	8b 45 08             	mov    0x8(%ebp),%eax
    9fc0:	c1 e8 16             	shr    $0x16,%eax
    9fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    9fc6:	8b 45 08             	mov    0x8(%ebp),%eax
    9fc9:	c1 e8 0c             	shr    $0xc,%eax
    9fcc:	25 ff 03 00 00       	and    $0x3ff,%eax
    9fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    9fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9fd7:	8b 04 85 00 00 01 00 	mov    0x10000(,%eax,4),%eax
    9fde:	83 e0 23             	and    $0x23,%eax
    9fe1:	83 f8 23             	cmp    $0x23,%eax
    9fe4:	75 4e                	jne    a034 <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    9fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9fe9:	8b 04 85 00 00 01 00 	mov    0x10000(,%eax,4),%eax
    9ff0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    9ff5:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    9ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9ffb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a002:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a005:	01 d0                	add    %edx,%eax
    a007:	8b 00                	mov    (%eax),%eax
    a009:	83 e0 23             	and    $0x23,%eax
    a00c:	83 f8 23             	cmp    $0x23,%eax
    a00f:	74 26                	je     a037 <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a011:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a014:	c1 e0 0c             	shl    $0xc,%eax
    a017:	89 c2                	mov    %eax,%edx
    a019:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a01c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a023:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a026:	01 c8                	add    %ecx,%eax
    a028:	83 ca 23             	or     $0x23,%edx
    a02b:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a02d:	e8 1e 13 00 00       	call   b350 <_FlushPagingCache_>
    a032:	eb 04                	jmp    a038 <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a034:	90                   	nop
    a035:	eb 01                	jmp    a038 <map_linear_address+0x81>
            return; // the linear address was already mapped
    a037:	90                   	nop
}
    a038:	c9                   	leave  
    a039:	c3                   	ret    

0000a03a <Paging_fault>:

void Paging_fault()
{
    a03a:	55                   	push   %ebp
    a03b:	89 e5                	mov    %esp,%ebp
}
    a03d:	90                   	nop
    a03e:	5d                   	pop    %ebp
    a03f:	c3                   	ret    

0000a040 <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a040:	55                   	push   %ebp
    a041:	89 e5                	mov    %esp,%ebp
    a043:	83 ec 04             	sub    $0x4,%esp
    a046:	8b 45 08             	mov    0x8(%ebp),%eax
    a049:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a04c:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a050:	76 0b                	jbe    a05d <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a052:	ba a0 00 00 00       	mov    $0xa0,%edx
    a057:	b8 20 00 00 00       	mov    $0x20,%eax
    a05c:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a05d:	ba 20 00 00 00       	mov    $0x20,%edx
    a062:	b8 20 00 00 00       	mov    $0x20,%eax
    a067:	ee                   	out    %al,(%dx)
}
    a068:	90                   	nop
    a069:	c9                   	leave  
    a06a:	c3                   	ret    

0000a06b <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a06b:	55                   	push   %ebp
    a06c:	89 e5                	mov    %esp,%ebp
    a06e:	83 ec 18             	sub    $0x18,%esp
    a071:	8b 55 08             	mov    0x8(%ebp),%edx
    a074:	8b 45 0c             	mov    0xc(%ebp),%eax
    a077:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a07a:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a07d:	b8 21 00 00 00       	mov    $0x21,%eax
    a082:	89 c2                	mov    %eax,%edx
    a084:	ec                   	in     (%dx),%al
    a085:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a089:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a08d:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2 = inb(PIC2_DATA);
    a090:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a095:	89 c2                	mov    %eax,%edx
    a097:	ec                   	in     (%dx),%al
    a098:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a09c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a0a0:	88 45 f9             	mov    %al,-0x7(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a0a3:	ba 20 00 00 00       	mov    $0x20,%edx
    a0a8:	b8 11 00 00 00       	mov    $0x11,%eax
    a0ad:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a0ae:	eb 00                	jmp    a0b0 <PIC_remap+0x45>
    a0b0:	eb 00                	jmp    a0b2 <PIC_remap+0x47>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a0b2:	ba a0 00 00 00       	mov    $0xa0,%edx
    a0b7:	b8 11 00 00 00       	mov    $0x11,%eax
    a0bc:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a0bd:	eb 00                	jmp    a0bf <PIC_remap+0x54>
    a0bf:	eb 00                	jmp    a0c1 <PIC_remap+0x56>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a0c1:	ba 21 00 00 00       	mov    $0x21,%edx
    a0c6:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a0ca:	ee                   	out    %al,(%dx)
    io_wait;
    a0cb:	eb 00                	jmp    a0cd <PIC_remap+0x62>
    a0cd:	eb 00                	jmp    a0cf <PIC_remap+0x64>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a0cf:	ba a1 00 00 00       	mov    $0xa1,%edx
    a0d4:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a0d8:	ee                   	out    %al,(%dx)
    io_wait;
    a0d9:	eb 00                	jmp    a0db <PIC_remap+0x70>
    a0db:	eb 00                	jmp    a0dd <PIC_remap+0x72>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a0dd:	ba 21 00 00 00       	mov    $0x21,%edx
    a0e2:	b8 04 00 00 00       	mov    $0x4,%eax
    a0e7:	ee                   	out    %al,(%dx)
    io_wait;
    a0e8:	eb 00                	jmp    a0ea <PIC_remap+0x7f>
    a0ea:	eb 00                	jmp    a0ec <PIC_remap+0x81>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a0ec:	ba a1 00 00 00       	mov    $0xa1,%edx
    a0f1:	b8 02 00 00 00       	mov    $0x2,%eax
    a0f6:	ee                   	out    %al,(%dx)
    io_wait;
    a0f7:	eb 00                	jmp    a0f9 <PIC_remap+0x8e>
    a0f9:	eb 00                	jmp    a0fb <PIC_remap+0x90>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a0fb:	ba 21 00 00 00       	mov    $0x21,%edx
    a100:	b8 01 00 00 00       	mov    $0x1,%eax
    a105:	ee                   	out    %al,(%dx)
    io_wait;
    a106:	eb 00                	jmp    a108 <PIC_remap+0x9d>
    a108:	eb 00                	jmp    a10a <PIC_remap+0x9f>

    outb(PIC2_DATA, ICW4_8086);
    a10a:	ba a1 00 00 00       	mov    $0xa1,%edx
    a10f:	b8 01 00 00 00       	mov    $0x1,%eax
    a114:	ee                   	out    %al,(%dx)
    io_wait;
    a115:	eb 00                	jmp    a117 <PIC_remap+0xac>
    a117:	eb 00                	jmp    a119 <PIC_remap+0xae>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a119:	ba 21 00 00 00       	mov    $0x21,%edx
    a11e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a122:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a123:	ba a1 00 00 00       	mov    $0xa1,%edx
    a128:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a12c:	ee                   	out    %al,(%dx)
}
    a12d:	90                   	nop
    a12e:	c9                   	leave  
    a12f:	c3                   	ret    

0000a130 <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a130:	55                   	push   %ebp
    a131:	89 e5                	mov    %esp,%ebp
    a133:	53                   	push   %ebx
    a134:	83 ec 14             	sub    $0x14,%esp
    a137:	8b 45 08             	mov    0x8(%ebp),%eax
    a13a:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a13d:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a141:	77 08                	ja     a14b <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a143:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a149:	eb 0a                	jmp    a155 <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a14b:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a151:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a155:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a159:	89 c2                	mov    %eax,%edx
    a15b:	ec                   	in     (%dx),%al
    a15c:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a160:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a164:	89 c3                	mov    %eax,%ebx
    a166:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a16a:	ba 01 00 00 00       	mov    $0x1,%edx
    a16f:	89 c1                	mov    %eax,%ecx
    a171:	d3 e2                	shl    %cl,%edx
    a173:	89 d0                	mov    %edx,%eax
    a175:	09 d8                	or     %ebx,%eax
    a177:	88 45 f7             	mov    %al,-0x9(%ebp)

    outb(port, value);
    a17a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a17e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a182:	ee                   	out    %al,(%dx)
}
    a183:	90                   	nop
    a184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a187:	c9                   	leave  
    a188:	c3                   	ret    

0000a189 <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a189:	55                   	push   %ebp
    a18a:	89 e5                	mov    %esp,%ebp
    a18c:	53                   	push   %ebx
    a18d:	83 ec 14             	sub    $0x14,%esp
    a190:	8b 45 08             	mov    0x8(%ebp),%eax
    a193:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a196:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a19a:	77 09                	ja     a1a5 <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a19c:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a1a3:	eb 0b                	jmp    a1b0 <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a1a5:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a1ac:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a1b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a1b3:	89 c2                	mov    %eax,%edx
    a1b5:	ec                   	in     (%dx),%al
    a1b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a1ba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a1be:	89 c3                	mov    %eax,%ebx
    a1c0:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a1c4:	ba 01 00 00 00       	mov    $0x1,%edx
    a1c9:	89 c1                	mov    %eax,%ecx
    a1cb:	d3 e2                	shl    %cl,%edx
    a1cd:	89 d0                	mov    %edx,%eax
    a1cf:	f7 d0                	not    %eax
    a1d1:	21 d8                	and    %ebx,%eax
    a1d3:	88 45 f5             	mov    %al,-0xb(%ebp)

    outb(port, value);
    a1d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a1d9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a1dd:	ee                   	out    %al,(%dx)
}
    a1de:	90                   	nop
    a1df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a1e2:	c9                   	leave  
    a1e3:	c3                   	ret    

0000a1e4 <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a1e4:	55                   	push   %ebp
    a1e5:	89 e5                	mov    %esp,%ebp
    a1e7:	83 ec 14             	sub    $0x14,%esp
    a1ea:	8b 45 08             	mov    0x8(%ebp),%eax
    a1ed:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a1f0:	ba 20 00 00 00       	mov    $0x20,%edx
    a1f5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a1f9:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a1fa:	ba a0 00 00 00       	mov    $0xa0,%edx
    a1ff:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a203:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a204:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a209:	89 c2                	mov    %eax,%edx
    a20b:	ec                   	in     (%dx),%al
    a20c:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a210:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a214:	98                   	cwtl   
    a215:	c1 e0 08             	shl    $0x8,%eax
    a218:	89 c1                	mov    %eax,%ecx
    a21a:	b8 20 00 00 00       	mov    $0x20,%eax
    a21f:	89 c2                	mov    %eax,%edx
    a221:	ec                   	in     (%dx),%al
    a222:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a226:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a22a:	09 c8                	or     %ecx,%eax
}
    a22c:	c9                   	leave  
    a22d:	c3                   	ret    

0000a22e <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a22e:	55                   	push   %ebp
    a22f:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a231:	6a 0b                	push   $0xb
    a233:	e8 ac ff ff ff       	call   a1e4 <__pic_get_irq_reg>
    a238:	83 c4 04             	add    $0x4,%esp
}
    a23b:	c9                   	leave  
    a23c:	c3                   	ret    

0000a23d <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a23d:	55                   	push   %ebp
    a23e:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a240:	6a 0a                	push   $0xa
    a242:	e8 9d ff ff ff       	call   a1e4 <__pic_get_irq_reg>
    a247:	83 c4 04             	add    $0x4,%esp
}
    a24a:	c9                   	leave  
    a24b:	c3                   	ret    

0000a24c <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a24c:	55                   	push   %ebp
    a24d:	89 e5                	mov    %esp,%ebp
    a24f:	83 ec 14             	sub    $0x14,%esp
    a252:	8b 45 08             	mov    0x8(%ebp),%eax
    a255:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a258:	e8 d1 ff ff ff       	call   a22e <pic_get_isr>
    a25d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a261:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a265:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a269:	74 13                	je     a27e <spurious_IRQ+0x32>
    a26b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a26f:	0f b6 c0             	movzbl %al,%eax
    a272:	83 e0 07             	and    $0x7,%eax
    a275:	50                   	push   %eax
    a276:	e8 c5 fd ff ff       	call   a040 <PIC_sendEOI>
    a27b:	83 c4 04             	add    $0x4,%esp
    a27e:	90                   	nop
    a27f:	c9                   	leave  
    a280:	c3                   	ret    

0000a281 <conserv_status_byte>:
uint32_t compteur   = 0;
uint8_t  frequency  = 0;
uint8_t  status_PIT = 0;

void conserv_status_byte()
{
    a281:	55                   	push   %ebp
    a282:	89 e5                	mov    %esp,%ebp
    a284:	83 ec 10             	sub    $0x10,%esp
    set_pit_count(PIT_0, PIT_reload_value);
    a287:	ba 43 00 00 00       	mov    $0x43,%edx
    a28c:	b8 40 00 00 00       	mov    $0x40,%eax
    a291:	ee                   	out    %al,(%dx)
    a292:	b8 40 00 00 00       	mov    $0x40,%eax
    a297:	89 c2                	mov    %eax,%edx
    a299:	ec                   	in     (%dx),%al
    a29a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a29e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a2a2:	88 45 f6             	mov    %al,-0xa(%ebp)
    a2a5:	b8 40 00 00 00       	mov    $0x40,%eax
    a2aa:	89 c2                	mov    %eax,%edx
    a2ac:	ec                   	in     (%dx),%al
    a2ad:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a2b1:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a2b5:	88 45 f7             	mov    %al,-0x9(%ebp)
    a2b8:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a2bc:	66 98                	cbtw   
    a2be:	ba 40 00 00 00       	mov    $0x40,%edx
    a2c3:	ee                   	out    %al,(%dx)
    a2c4:	a1 54 22 02 00       	mov    0x22254,%eax
    a2c9:	c1 f8 08             	sar    $0x8,%eax
    a2cc:	ba 40 00 00 00       	mov    $0x40,%edx
    a2d1:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a2d2:	ba 43 00 00 00       	mov    $0x43,%edx
    a2d7:	b8 40 00 00 00       	mov    $0x40,%eax
    a2dc:	ee                   	out    %al,(%dx)
    a2dd:	b8 40 00 00 00       	mov    $0x40,%eax
    a2e2:	89 c2                	mov    %eax,%edx
    a2e4:	ec                   	in     (%dx),%al
    a2e5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a2e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a2ed:	88 45 f4             	mov    %al,-0xc(%ebp)
    a2f0:	b8 40 00 00 00       	mov    $0x40,%eax
    a2f5:	89 c2                	mov    %eax,%edx
    a2f7:	ec                   	in     (%dx),%al
    a2f8:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a2fc:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a300:	88 45 f5             	mov    %al,-0xb(%ebp)
    a303:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a307:	66 98                	cbtw   
    a309:	ba 43 00 00 00       	mov    $0x43,%edx
    a30e:	ee                   	out    %al,(%dx)
    a30f:	ba 43 00 00 00       	mov    $0x43,%edx
    a314:	b8 34 00 00 00       	mov    $0x34,%eax
    a319:	ee                   	out    %al,(%dx)
}
    a31a:	90                   	nop
    a31b:	c9                   	leave  
    a31c:	c3                   	ret    

0000a31d <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a31d:	55                   	push   %ebp
    a31e:	89 e5                	mov    %esp,%ebp
    a320:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a323:	0f b6 05 20 21 02 00 	movzbl 0x22120,%eax
    a32a:	3c 01                	cmp    $0x1,%al
    a32c:	75 27                	jne    a355 <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a32e:	a1 24 21 02 00       	mov    0x22124,%eax
    a333:	85 c0                	test   %eax,%eax
    a335:	75 11                	jne    a348 <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a337:	c7 05 24 21 02 00 2c 	movl   $0x12c,0x22124
    a33e:	01 00 00 
            __switch();
    a341:	e8 30 0a 00 00       	call   ad76 <__switch>
        } else
            sheduler.task_timer--;
    }
}
    a346:	eb 0d                	jmp    a355 <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a348:	a1 24 21 02 00       	mov    0x22124,%eax
    a34d:	83 e8 01             	sub    $0x1,%eax
    a350:	a3 24 21 02 00       	mov    %eax,0x22124
}
    a355:	90                   	nop
    a356:	c9                   	leave  
    a357:	c3                   	ret    

0000a358 <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a358:	55                   	push   %ebp
    a359:	89 e5                	mov    %esp,%ebp
    a35b:	83 ec 28             	sub    $0x28,%esp
    a35e:	8b 45 08             	mov    0x8(%ebp),%eax
    a361:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a365:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a369:	a2 04 10 01 00       	mov    %al,0x11004
    calculate_frequency();
    a36e:	e8 49 10 00 00       	call   b3bc <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a373:	ba 43 00 00 00       	mov    $0x43,%edx
    a378:	b8 40 00 00 00       	mov    $0x40,%eax
    a37d:	ee                   	out    %al,(%dx)
    a37e:	b8 40 00 00 00       	mov    $0x40,%eax
    a383:	89 c2                	mov    %eax,%edx
    a385:	ec                   	in     (%dx),%al
    a386:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a38a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a38e:	88 45 ee             	mov    %al,-0x12(%ebp)
    a391:	b8 40 00 00 00       	mov    $0x40,%eax
    a396:	89 c2                	mov    %eax,%edx
    a398:	ec                   	in     (%dx),%al
    a399:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    a39d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
    a3a1:	88 45 ef             	mov    %al,-0x11(%ebp)
    a3a4:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    a3a8:	66 98                	cbtw   
    a3aa:	ba 43 00 00 00       	mov    $0x43,%edx
    a3af:	ee                   	out    %al,(%dx)
    a3b0:	ba 43 00 00 00       	mov    $0x43,%edx
    a3b5:	b8 34 00 00 00       	mov    $0x34,%eax
    a3ba:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a3bb:	ba 43 00 00 00       	mov    $0x43,%edx
    a3c0:	b8 40 00 00 00       	mov    $0x40,%eax
    a3c5:	ee                   	out    %al,(%dx)
    a3c6:	b8 40 00 00 00       	mov    $0x40,%eax
    a3cb:	89 c2                	mov    %eax,%edx
    a3cd:	ec                   	in     (%dx),%al
    a3ce:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a3d2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a3d6:	88 45 ec             	mov    %al,-0x14(%ebp)
    a3d9:	b8 40 00 00 00       	mov    $0x40,%eax
    a3de:	89 c2                	mov    %eax,%edx
    a3e0:	ec                   	in     (%dx),%al
    a3e1:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a3e5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a3e9:	88 45 ed             	mov    %al,-0x13(%ebp)
    a3ec:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a3f0:	66 98                	cbtw   
    a3f2:	ba 40 00 00 00       	mov    $0x40,%edx
    a3f7:	ee                   	out    %al,(%dx)
    a3f8:	a1 54 22 02 00       	mov    0x22254,%eax
    a3fd:	c1 f8 08             	sar    $0x8,%eax
    a400:	ba 40 00 00 00       	mov    $0x40,%edx
    a405:	ee                   	out    %al,(%dx)
}
    a406:	90                   	nop
    a407:	c9                   	leave  
    a408:	c3                   	ret    

0000a409 <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a409:	55                   	push   %ebp
    a40a:	89 e5                	mov    %esp,%ebp
    a40c:	83 ec 14             	sub    $0x14,%esp
    a40f:	8b 45 08             	mov    0x8(%ebp),%eax
    a412:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a415:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a419:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a41d:	83 f8 42             	cmp    $0x42,%eax
    a420:	74 1d                	je     a43f <read_back_channel+0x36>
    a422:	83 f8 42             	cmp    $0x42,%eax
    a425:	7f 1e                	jg     a445 <read_back_channel+0x3c>
    a427:	83 f8 40             	cmp    $0x40,%eax
    a42a:	74 07                	je     a433 <read_back_channel+0x2a>
    a42c:	83 f8 41             	cmp    $0x41,%eax
    a42f:	74 08                	je     a439 <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a431:	eb 12                	jmp    a445 <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a433:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a437:	eb 0d                	jmp    a446 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a439:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a43d:	eb 07                	jmp    a446 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a43f:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a443:	eb 01                	jmp    a446 <read_back_channel+0x3d>
        break;
    a445:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a446:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a44a:	ba 43 00 00 00       	mov    $0x43,%edx
    a44f:	b8 40 00 00 00       	mov    $0x40,%eax
    a454:	ee                   	out    %al,(%dx)
    a455:	b8 40 00 00 00       	mov    $0x40,%eax
    a45a:	89 c2                	mov    %eax,%edx
    a45c:	ec                   	in     (%dx),%al
    a45d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a461:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a465:	88 45 f4             	mov    %al,-0xc(%ebp)
    a468:	b8 40 00 00 00       	mov    $0x40,%eax
    a46d:	89 c2                	mov    %eax,%edx
    a46f:	ec                   	in     (%dx),%al
    a470:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a474:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a478:	88 45 f5             	mov    %al,-0xb(%ebp)
    a47b:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a47f:	66 98                	cbtw   
    a481:	ba 43 00 00 00       	mov    $0x43,%edx
    a486:	ee                   	out    %al,(%dx)
    a487:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a48b:	c1 f8 08             	sar    $0x8,%eax
    a48e:	ba 43 00 00 00       	mov    $0x43,%edx
    a493:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a494:	ba 43 00 00 00       	mov    $0x43,%edx
    a499:	b8 40 00 00 00       	mov    $0x40,%eax
    a49e:	ee                   	out    %al,(%dx)
    a49f:	b8 40 00 00 00       	mov    $0x40,%eax
    a4a4:	89 c2                	mov    %eax,%edx
    a4a6:	ec                   	in     (%dx),%al
    a4a7:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a4ab:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a4af:	88 45 f2             	mov    %al,-0xe(%ebp)
    a4b2:	b8 40 00 00 00       	mov    $0x40,%eax
    a4b7:	89 c2                	mov    %eax,%edx
    a4b9:	ec                   	in     (%dx),%al
    a4ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a4be:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a4c2:	88 45 f3             	mov    %al,-0xd(%ebp)
    a4c5:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a4c9:	66 98                	cbtw   
    a4cb:	c9                   	leave  
    a4cc:	c3                   	ret    

0000a4cd <read_ebp>:
                 : "r"(eflags));
}

static inline uint32_t
read_ebp(void)
{
    a4cd:	55                   	push   %ebp
    a4ce:	89 e5                	mov    %esp,%ebp
    a4d0:	83 ec 10             	sub    $0x10,%esp
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
    a4d3:	89 e8                	mov    %ebp,%eax
    a4d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(ebp));
    return ebp;
    a4d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a4db:	c9                   	leave  
    a4dc:	c3                   	ret    

0000a4dd <x86_memset>:
{
    asm volatile("movl %0 , %%esp" ::"r"(esp));
}

void* x86_memset(void* addr, uint8_t data, size_t size)
{
    a4dd:	55                   	push   %ebp
    a4de:	89 e5                	mov    %esp,%ebp
    a4e0:	57                   	push   %edi
    a4e1:	83 ec 04             	sub    $0x4,%esp
    a4e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    a4e7:	88 45 f8             	mov    %al,-0x8(%ebp)
    __asm__("cld; rep stosb\n" ::"D"(addr), "a"(data), "c"(size)
    a4ea:	8b 55 08             	mov    0x8(%ebp),%edx
    a4ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    a4f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
    a4f4:	89 d7                	mov    %edx,%edi
    a4f6:	fc                   	cld    
    a4f7:	f3 aa                	rep stos %al,%es:(%edi)
            : "cc", "memory");

    return addr;
    a4f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    a4fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
    a4ff:	c9                   	leave  
    a500:	c3                   	ret    

0000a501 <backtrace>:
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    a501:	55                   	push   %ebp
    a502:	89 e5                	mov    %esp,%ebp
    a504:	83 ec 18             	sub    $0x18,%esp
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;
    a507:	e8 c1 ff ff ff       	call   a4cd <read_ebp>
    a50c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a50f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a512:	83 c0 04             	add    $0x4,%eax
    a515:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp != 0) {
    a518:	eb 30                	jmp    a54a <backtrace+0x49>
        kprintf("ebp %x eip %x\n", ebp, *eip);
    a51a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a51d:	8b 00                	mov    (%eax),%eax
    a51f:	83 ec 04             	sub    $0x4,%esp
    a522:	50                   	push   %eax
    a523:	ff 75 f4             	push   -0xc(%ebp)
    a526:	68 a6 b5 00 00       	push   $0xb5a6
    a52b:	e8 0c 01 00 00       	call   a63c <kprintf>
    a530:	83 c4 10             	add    $0x10,%esp

        ptr = (int*)(ebp);
    a533:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a536:	89 45 ec             	mov    %eax,-0x14(%ebp)

        ebp = (int)(*ptr);
    a539:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a53c:	8b 00                	mov    (%eax),%eax
    a53e:	89 45 f4             	mov    %eax,-0xc(%ebp)

        eip = (int*)(ebp + 4);
    a541:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a544:	83 c0 04             	add    $0x4,%eax
    a547:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (ebp != 0) {
    a54a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    a54e:	75 ca                	jne    a51a <backtrace+0x19>
    }
    return 0;
    a550:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a555:	c9                   	leave  
    a556:	c3                   	ret    

0000a557 <mon_help>:

int mon_help(int argc, char** argv)
{
    a557:	55                   	push   %ebp
    a558:	89 e5                	mov    %esp,%ebp
    a55a:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 2; i++)
    a55d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a564:	eb 3c                	jmp    a5a2 <mon_help+0x4b>
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    a566:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a569:	89 d0                	mov    %edx,%eax
    a56b:	01 c0                	add    %eax,%eax
    a56d:	01 d0                	add    %edx,%eax
    a56f:	c1 e0 02             	shl    $0x2,%eax
    a572:	05 48 c2 00 00       	add    $0xc248,%eax
    a577:	8b 10                	mov    (%eax),%edx
    a579:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    a57c:	89 c8                	mov    %ecx,%eax
    a57e:	01 c0                	add    %eax,%eax
    a580:	01 c8                	add    %ecx,%eax
    a582:	c1 e0 02             	shl    $0x2,%eax
    a585:	05 44 c2 00 00       	add    $0xc244,%eax
    a58a:	8b 00                	mov    (%eax),%eax
    a58c:	83 ec 04             	sub    $0x4,%esp
    a58f:	52                   	push   %edx
    a590:	50                   	push   %eax
    a591:	68 b5 b5 00 00       	push   $0xb5b5
    a596:	e8 a1 00 00 00       	call   a63c <kprintf>
    a59b:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 2; i++)
    a59e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a5a2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    a5a6:	7e be                	jle    a566 <mon_help+0xf>
    return 0;
    a5a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a5ad:	c9                   	leave  
    a5ae:	c3                   	ret    

0000a5af <monitor_service_keyboard>:

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    a5af:	55                   	push   %ebp
    a5b0:	89 e5                	mov    %esp,%ebp
    a5b2:	83 ec 18             	sub    $0x18,%esp
    if (get_ASCII_code_keyboard() != '\0') {
    a5b5:	e8 0d f0 ff ff       	call   95c7 <get_ASCII_code_keyboard>
    a5ba:	84 c0                	test   %al,%al
    a5bc:	74 7b                	je     a639 <monitor_service_keyboard+0x8a>
        int8_t code = get_ASCII_code_keyboard();
    a5be:	e8 04 f0 ff ff       	call   95c7 <get_ASCII_code_keyboard>
    a5c3:	88 45 f3             	mov    %al,-0xd(%ebp)
        if (code != '\n') {
    a5c6:	80 7d f3 0a          	cmpb   $0xa,-0xd(%ebp)
    a5ca:	74 25                	je     a5f1 <monitor_service_keyboard+0x42>
            keyboard_code_monitor[keyboard_num] = code;
    a5cc:	0f b6 05 1f 11 01 00 	movzbl 0x1111f,%eax
    a5d3:	0f be c0             	movsbl %al,%eax
    a5d6:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
    a5da:	88 90 20 10 01 00    	mov    %dl,0x11020(%eax)
            keyboard_num++;
    a5e0:	0f b6 05 1f 11 01 00 	movzbl 0x1111f,%eax
    a5e7:	83 c0 01             	add    $0x1,%eax
    a5ea:	a2 1f 11 01 00       	mov    %al,0x1111f
            }

            keyboard_num = 0;
        }
    }
    a5ef:	eb 48                	jmp    a639 <monitor_service_keyboard+0x8a>
            for (i = 0; i < keyboard_num; i++) {
    a5f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a5f8:	eb 29                	jmp    a623 <monitor_service_keyboard+0x74>
                putchar(keyboard_code_monitor[i]);
    a5fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a5fd:	05 20 10 01 00       	add    $0x11020,%eax
    a602:	0f b6 00             	movzbl (%eax),%eax
    a605:	0f be c0             	movsbl %al,%eax
    a608:	83 ec 0c             	sub    $0xc,%esp
    a60b:	50                   	push   %eax
    a60c:	e8 32 08 00 00       	call   ae43 <putchar>
    a611:	83 c4 10             	add    $0x10,%esp
                keyboard_code_monitor[i] = 0;
    a614:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a617:	05 20 10 01 00       	add    $0x11020,%eax
    a61c:	c6 00 00             	movb   $0x0,(%eax)
            for (i = 0; i < keyboard_num; i++) {
    a61f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a623:	0f b6 05 1f 11 01 00 	movzbl 0x1111f,%eax
    a62a:	0f be c0             	movsbl %al,%eax
    a62d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a630:	7c c8                	jl     a5fa <monitor_service_keyboard+0x4b>
            keyboard_num = 0;
    a632:	c6 05 1f 11 01 00 00 	movb   $0x0,0x1111f
    a639:	90                   	nop
    a63a:	c9                   	leave  
    a63b:	c3                   	ret    

0000a63c <kprintf>:
#include <stdarg.h>

extern void printf(const char* frmt, va_list arg);

void kprintf(const char* frmt, ...)
{
    a63c:	55                   	push   %ebp
    a63d:	89 e5                	mov    %esp,%ebp
    a63f:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    a642:	8d 45 0c             	lea    0xc(%ebp),%eax
    a645:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    a648:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a64b:	83 ec 08             	sub    $0x8,%esp
    a64e:	50                   	push   %eax
    a64f:	ff 75 08             	push   0x8(%ebp)
    a652:	e8 71 08 00 00       	call   aec8 <printf>
    a657:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    a65a:	90                   	nop
    a65b:	c9                   	leave  
    a65c:	c3                   	ret    

0000a65d <kputs>:

void kputs(const char* frmt, ...)
{
    a65d:	55                   	push   %ebp
    a65e:	89 e5                	mov    %esp,%ebp
    a660:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    a663:	8d 45 0c             	lea    0xc(%ebp),%eax
    a666:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    a669:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a66c:	83 ec 08             	sub    $0x8,%esp
    a66f:	50                   	push   %eax
    a670:	ff 75 08             	push   0x8(%ebp)
    a673:	e8 50 08 00 00       	call   aec8 <printf>
    a678:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
    a67b:	90                   	nop
    a67c:	c9                   	leave  
    a67d:	c3                   	ret    

0000a67e <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    a67e:	55                   	push   %ebp
    a67f:	89 e5                	mov    %esp,%ebp
    a681:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    a684:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    a68b:	eb 49                	jmp    a6d6 <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    a68d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a690:	89 d0                	mov    %edx,%eax
    a692:	01 c0                	add    %eax,%eax
    a694:	01 d0                	add    %edx,%eax
    a696:	c1 e0 02             	shl    $0x2,%eax
    a699:	05 20 11 01 00       	add    $0x11120,%eax
    a69e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    a6a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a6a7:	89 d0                	mov    %edx,%eax
    a6a9:	01 c0                	add    %eax,%eax
    a6ab:	01 d0                	add    %edx,%eax
    a6ad:	c1 e0 02             	shl    $0x2,%eax
    a6b0:	05 28 11 01 00       	add    $0x11128,%eax
    a6b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    a6bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a6be:	89 d0                	mov    %edx,%eax
    a6c0:	01 c0                	add    %eax,%eax
    a6c2:	01 d0                	add    %edx,%eax
    a6c4:	c1 e0 02             	shl    $0x2,%eax
    a6c7:	05 24 11 01 00       	add    $0x11124,%eax
    a6cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    a6d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    a6d6:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    a6dd:	7e ae                	jle    a68d <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    a6df:	c7 05 20 d1 01 00 20 	movl   $0x11120,0x1d120
    a6e6:	11 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    a6e9:	90                   	nop
    a6ea:	c9                   	leave  
    a6eb:	c3                   	ret    

0000a6ec <kmalloc>:

void* kmalloc(uint32_t size)
{
    a6ec:	55                   	push   %ebp
    a6ed:	89 e5                	mov    %esp,%ebp
    a6ef:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    a6f2:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a6f7:	8b 00                	mov    (%eax),%eax
    a6f9:	85 c0                	test   %eax,%eax
    a6fb:	75 37                	jne    a734 <kmalloc+0x48>
        _head_vmm_->address = KERNEL__VM_BASE;
    a6fd:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a702:	ba 40 d1 01 00       	mov    $0x1d140,%edx
    a707:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    a709:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a70e:	8b 55 08             	mov    0x8(%ebp),%edx
    a711:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    a714:	8b 45 08             	mov    0x8(%ebp),%eax
    a717:	83 ec 04             	sub    $0x4,%esp
    a71a:	50                   	push   %eax
    a71b:	6a 00                	push   $0x0
    a71d:	68 40 d1 01 00       	push   $0x1d140
    a722:	e8 8f 0a 00 00       	call   b1b6 <memset>
    a727:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    a72a:	b8 40 d1 01 00       	mov    $0x1d140,%eax
    a72f:	e9 7e 01 00 00       	jmp    a8b2 <kmalloc+0x1c6>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    a734:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    a73b:	eb 04                	jmp    a741 <kmalloc+0x55>
        i++;
    a73d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    a741:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    a748:	77 17                	ja     a761 <kmalloc+0x75>
    a74a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    a74d:	89 d0                	mov    %edx,%eax
    a74f:	01 c0                	add    %eax,%eax
    a751:	01 d0                	add    %edx,%eax
    a753:	c1 e0 02             	shl    $0x2,%eax
    a756:	05 20 11 01 00       	add    $0x11120,%eax
    a75b:	8b 00                	mov    (%eax),%eax
    a75d:	85 c0                	test   %eax,%eax
    a75f:	75 dc                	jne    a73d <kmalloc+0x51>

    _new_item_ = &MM_BLOCK[i];
    a761:	8b 55 f0             	mov    -0x10(%ebp),%edx
    a764:	89 d0                	mov    %edx,%eax
    a766:	01 c0                	add    %eax,%eax
    a768:	01 d0                	add    %edx,%eax
    a76a:	c1 e0 02             	shl    $0x2,%eax
    a76d:	05 20 11 01 00       	add    $0x11120,%eax
    a772:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    a775:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a77a:	8b 00                	mov    (%eax),%eax
    a77c:	b9 40 d1 01 00       	mov    $0x1d140,%ecx
    a781:	8b 55 08             	mov    0x8(%ebp),%edx
    a784:	01 ca                	add    %ecx,%edx
    a786:	39 d0                	cmp    %edx,%eax
    a788:	74 48                	je     a7d2 <kmalloc+0xe6>
        _new_item_->address = KERNEL__VM_BASE;
    a78a:	ba 40 d1 01 00       	mov    $0x1d140,%edx
    a78f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a792:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    a794:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a797:	8b 55 08             	mov    0x8(%ebp),%edx
    a79a:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    a79d:	8b 15 20 d1 01 00    	mov    0x1d120,%edx
    a7a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a7a6:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    a7a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a7ac:	a3 20 d1 01 00       	mov    %eax,0x1d120

        memset((void*)_new_item_->address, 0, size);
    a7b1:	8b 45 08             	mov    0x8(%ebp),%eax
    a7b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
    a7b7:	8b 12                	mov    (%edx),%edx
    a7b9:	83 ec 04             	sub    $0x4,%esp
    a7bc:	50                   	push   %eax
    a7bd:	6a 00                	push   $0x0
    a7bf:	52                   	push   %edx
    a7c0:	e8 f1 09 00 00       	call   b1b6 <memset>
    a7c5:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    a7c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a7cb:	8b 00                	mov    (%eax),%eax
    a7cd:	e9 e0 00 00 00       	jmp    a8b2 <kmalloc+0x1c6>
    }

    tmp = _head_vmm_;
    a7d2:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a7d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    a7da:	eb 27                	jmp    a803 <kmalloc+0x117>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    a7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a7df:	8b 40 08             	mov    0x8(%eax),%eax
    a7e2:	8b 10                	mov    (%eax),%edx
    a7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a7e7:	8b 08                	mov    (%eax),%ecx
    a7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a7ec:	8b 40 04             	mov    0x4(%eax),%eax
    a7ef:	01 c1                	add    %eax,%ecx
    a7f1:	8b 45 08             	mov    0x8(%ebp),%eax
    a7f4:	01 c8                	add    %ecx,%eax
    a7f6:	39 c2                	cmp    %eax,%edx
    a7f8:	73 15                	jae    a80f <kmalloc+0x123>
            break;

        tmp = tmp->next;
    a7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a7fd:	8b 40 08             	mov    0x8(%eax),%eax
    a800:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    a803:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a806:	8b 40 08             	mov    0x8(%eax),%eax
    a809:	85 c0                	test   %eax,%eax
    a80b:	75 cf                	jne    a7dc <kmalloc+0xf0>
    a80d:	eb 01                	jmp    a810 <kmalloc+0x124>
            break;
    a80f:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    a810:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a813:	8b 40 08             	mov    0x8(%eax),%eax
    a816:	85 c0                	test   %eax,%eax
    a818:	75 4c                	jne    a866 <kmalloc+0x17a>
        _new_item_->size = size;
    a81a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a81d:	8b 55 08             	mov    0x8(%ebp),%edx
    a820:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    a823:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a826:	8b 10                	mov    (%eax),%edx
    a828:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a82b:	8b 40 04             	mov    0x4(%eax),%eax
    a82e:	01 c2                	add    %eax,%edx
    a830:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a833:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    a835:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a838:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    a83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a842:	8b 55 ec             	mov    -0x14(%ebp),%edx
    a845:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    a848:	8b 45 08             	mov    0x8(%ebp),%eax
    a84b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    a84e:	8b 12                	mov    (%edx),%edx
    a850:	83 ec 04             	sub    $0x4,%esp
    a853:	50                   	push   %eax
    a854:	6a 00                	push   $0x0
    a856:	52                   	push   %edx
    a857:	e8 5a 09 00 00       	call   b1b6 <memset>
    a85c:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    a85f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a862:	8b 00                	mov    (%eax),%eax
    a864:	eb 4c                	jmp    a8b2 <kmalloc+0x1c6>
    }

    else {
        _new_item_->size = size;
    a866:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a869:	8b 55 08             	mov    0x8(%ebp),%edx
    a86c:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    a86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a872:	8b 10                	mov    (%eax),%edx
    a874:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a877:	8b 40 04             	mov    0x4(%eax),%eax
    a87a:	01 c2                	add    %eax,%edx
    a87c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a87f:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    a881:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a884:	8b 50 08             	mov    0x8(%eax),%edx
    a887:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a88a:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    a88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a890:	8b 55 ec             	mov    -0x14(%ebp),%edx
    a893:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    a896:	8b 45 08             	mov    0x8(%ebp),%eax
    a899:	8b 55 ec             	mov    -0x14(%ebp),%edx
    a89c:	8b 12                	mov    (%edx),%edx
    a89e:	83 ec 04             	sub    $0x4,%esp
    a8a1:	50                   	push   %eax
    a8a2:	6a 00                	push   $0x0
    a8a4:	52                   	push   %edx
    a8a5:	e8 0c 09 00 00       	call   b1b6 <memset>
    a8aa:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    a8ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a8b0:	8b 00                	mov    (%eax),%eax
    }
}
    a8b2:	c9                   	leave  
    a8b3:	c3                   	ret    

0000a8b4 <free>:

void free(virtaddr_t _addr__)
{
    a8b4:	55                   	push   %ebp
    a8b5:	89 e5                	mov    %esp,%ebp
    a8b7:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    a8ba:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a8bf:	8b 00                	mov    (%eax),%eax
    a8c1:	39 45 08             	cmp    %eax,0x8(%ebp)
    a8c4:	75 29                	jne    a8ef <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    a8c6:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a8cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    a8d1:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a8d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    a8dd:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a8e2:	8b 40 08             	mov    0x8(%eax),%eax
    a8e5:	a3 20 d1 01 00       	mov    %eax,0x1d120
        return;
    a8ea:	e9 ac 00 00 00       	jmp    a99b <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    a8ef:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a8f4:	8b 40 08             	mov    0x8(%eax),%eax
    a8f7:	85 c0                	test   %eax,%eax
    a8f9:	75 16                	jne    a911 <free+0x5d>
    a8fb:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a900:	8b 00                	mov    (%eax),%eax
    a902:	39 45 08             	cmp    %eax,0x8(%ebp)
    a905:	75 0a                	jne    a911 <free+0x5d>
        init_vmm();
    a907:	e8 72 fd ff ff       	call   a67e <init_vmm>
        return;
    a90c:	e9 8a 00 00 00       	jmp    a99b <free+0xe7>
    }

    tmp = _head_vmm_;
    a911:	a1 20 d1 01 00       	mov    0x1d120,%eax
    a916:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    a919:	eb 0f                	jmp    a92a <free+0x76>
        tmp_prev = tmp;
    a91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a91e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    a921:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a924:	8b 40 08             	mov    0x8(%eax),%eax
    a927:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    a92a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a92d:	8b 40 08             	mov    0x8(%eax),%eax
    a930:	85 c0                	test   %eax,%eax
    a932:	74 0a                	je     a93e <free+0x8a>
    a934:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a937:	8b 00                	mov    (%eax),%eax
    a939:	39 45 08             	cmp    %eax,0x8(%ebp)
    a93c:	75 dd                	jne    a91b <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    a93e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a941:	8b 40 08             	mov    0x8(%eax),%eax
    a944:	85 c0                	test   %eax,%eax
    a946:	75 29                	jne    a971 <free+0xbd>
    a948:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a94b:	8b 00                	mov    (%eax),%eax
    a94d:	39 45 08             	cmp    %eax,0x8(%ebp)
    a950:	75 1f                	jne    a971 <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    a952:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a955:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    a95b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a95e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    a965:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a968:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    a96f:	eb 2a                	jmp    a99b <free+0xe7>
    }

    if (tmp->address == _addr__) {
    a971:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a974:	8b 00                	mov    (%eax),%eax
    a976:	39 45 08             	cmp    %eax,0x8(%ebp)
    a979:	75 20                	jne    a99b <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    a97b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a97e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    a984:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a987:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    a98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a991:	8b 50 08             	mov    0x8(%eax),%edx
    a994:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a997:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    a99a:	90                   	nop
    }
    a99b:	c9                   	leave  
    a99c:	c3                   	ret    

0000a99d <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    a99d:	55                   	push   %ebp
    a99e:	89 e5                	mov    %esp,%ebp
    a9a0:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    a9a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a9aa:	eb 49                	jmp    a9f5 <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    a9ac:	ba be b5 00 00       	mov    $0xb5be,%edx
    a9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9b4:	c1 e0 04             	shl    $0x4,%eax
    a9b7:	05 20 e1 01 00       	add    $0x1e120,%eax
    a9bc:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    a9be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9c1:	c1 e0 04             	shl    $0x4,%eax
    a9c4:	05 24 e1 01 00       	add    $0x1e124,%eax
    a9c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    a9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9d2:	c1 e0 04             	shl    $0x4,%eax
    a9d5:	05 2c e1 01 00       	add    $0x1e12c,%eax
    a9da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    a9e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9e3:	c1 e0 04             	shl    $0x4,%eax
    a9e6:	05 28 e1 01 00       	add    $0x1e128,%eax
    a9eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    a9f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a9f5:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a9fc:	76 ae                	jbe    a9ac <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    a9fe:	83 ec 08             	sub    $0x8,%esp
    aa01:	6a 01                	push   $0x1
    aa03:	68 00 e0 00 00       	push   $0xe000
    aa08:	e8 4f f4 ff ff       	call   9e5c <create_page_table>
    aa0d:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    aa10:	c7 05 00 e1 01 00 20 	movl   $0x1e120,0x1e100
    aa17:	e1 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    aa1a:	90                   	nop
    aa1b:	c9                   	leave  
    aa1c:	c3                   	ret    

0000aa1d <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    aa1d:	55                   	push   %ebp
    aa1e:	89 e5                	mov    %esp,%ebp
    aa20:	53                   	push   %ebx
    aa21:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    aa24:	a1 00 e1 01 00       	mov    0x1e100,%eax
    aa29:	8b 00                	mov    (%eax),%eax
    aa2b:	ba be b5 00 00       	mov    $0xb5be,%edx
    aa30:	39 d0                	cmp    %edx,%eax
    aa32:	75 40                	jne    aa74 <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    aa34:	a1 00 e1 01 00       	mov    0x1e100,%eax
    aa39:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    aa3f:	a1 00 e1 01 00       	mov    0x1e100,%eax
    aa44:	8b 55 08             	mov    0x8(%ebp),%edx
    aa47:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    aa4a:	8b 45 08             	mov    0x8(%ebp),%eax
    aa4d:	c1 e0 0c             	shl    $0xc,%eax
    aa50:	89 c2                	mov    %eax,%edx
    aa52:	a1 00 e1 01 00       	mov    0x1e100,%eax
    aa57:	8b 00                	mov    (%eax),%eax
    aa59:	83 ec 04             	sub    $0x4,%esp
    aa5c:	52                   	push   %edx
    aa5d:	6a 00                	push   $0x0
    aa5f:	50                   	push   %eax
    aa60:	e8 51 07 00 00       	call   b1b6 <memset>
    aa65:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    aa68:	a1 00 e1 01 00       	mov    0x1e100,%eax
    aa6d:	8b 00                	mov    (%eax),%eax
    aa6f:	e9 ae 01 00 00       	jmp    ac22 <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    aa74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    aa7b:	eb 04                	jmp    aa81 <alloc_page+0x64>
        i++;
    aa7d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    aa81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa84:	c1 e0 04             	shl    $0x4,%eax
    aa87:	05 20 e1 01 00       	add    $0x1e120,%eax
    aa8c:	8b 00                	mov    (%eax),%eax
    aa8e:	ba be b5 00 00       	mov    $0xb5be,%edx
    aa93:	39 d0                	cmp    %edx,%eax
    aa95:	74 09                	je     aaa0 <alloc_page+0x83>
    aa97:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    aa9e:	76 dd                	jbe    aa7d <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    aaa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aaa3:	c1 e0 04             	shl    $0x4,%eax
    aaa6:	05 20 e1 01 00       	add    $0x1e120,%eax
    aaab:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    aaae:	a1 00 e1 01 00       	mov    0x1e100,%eax
    aab3:	8b 00                	mov    (%eax),%eax
    aab5:	8b 55 08             	mov    0x8(%ebp),%edx
    aab8:	81 c2 00 01 00 00    	add    $0x100,%edx
    aabe:	c1 e2 0c             	shl    $0xc,%edx
    aac1:	39 d0                	cmp    %edx,%eax
    aac3:	72 4c                	jb     ab11 <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    aac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aac8:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    aace:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aad1:	8b 55 08             	mov    0x8(%ebp),%edx
    aad4:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    aad7:	8b 15 00 e1 01 00    	mov    0x1e100,%edx
    aadd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aae0:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    aae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aae6:	a3 00 e1 01 00       	mov    %eax,0x1e100

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    aaeb:	8b 45 08             	mov    0x8(%ebp),%eax
    aaee:	c1 e0 0c             	shl    $0xc,%eax
    aaf1:	89 c2                	mov    %eax,%edx
    aaf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aaf6:	8b 00                	mov    (%eax),%eax
    aaf8:	83 ec 04             	sub    $0x4,%esp
    aafb:	52                   	push   %edx
    aafc:	6a 00                	push   $0x0
    aafe:	50                   	push   %eax
    aaff:	e8 b2 06 00 00       	call   b1b6 <memset>
    ab04:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    ab07:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab0a:	8b 00                	mov    (%eax),%eax
    ab0c:	e9 11 01 00 00       	jmp    ac22 <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    ab11:	a1 00 e1 01 00       	mov    0x1e100,%eax
    ab16:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    ab19:	eb 2a                	jmp    ab45 <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    ab1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab1e:	8b 40 0c             	mov    0xc(%eax),%eax
    ab21:	8b 10                	mov    (%eax),%edx
    ab23:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab26:	8b 08                	mov    (%eax),%ecx
    ab28:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab2b:	8b 58 04             	mov    0x4(%eax),%ebx
    ab2e:	8b 45 08             	mov    0x8(%ebp),%eax
    ab31:	01 d8                	add    %ebx,%eax
    ab33:	c1 e0 0c             	shl    $0xc,%eax
    ab36:	01 c8                	add    %ecx,%eax
    ab38:	39 c2                	cmp    %eax,%edx
    ab3a:	77 15                	ja     ab51 <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    ab3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab3f:	8b 40 0c             	mov    0xc(%eax),%eax
    ab42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    ab45:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab48:	8b 40 0c             	mov    0xc(%eax),%eax
    ab4b:	85 c0                	test   %eax,%eax
    ab4d:	75 cc                	jne    ab1b <alloc_page+0xfe>
    ab4f:	eb 01                	jmp    ab52 <alloc_page+0x135>
            break;
    ab51:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    ab52:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab55:	8b 40 0c             	mov    0xc(%eax),%eax
    ab58:	85 c0                	test   %eax,%eax
    ab5a:	75 5d                	jne    abb9 <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    ab5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab5f:	8b 10                	mov    (%eax),%edx
    ab61:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab64:	8b 40 04             	mov    0x4(%eax),%eax
    ab67:	c1 e0 0c             	shl    $0xc,%eax
    ab6a:	01 c2                	add    %eax,%edx
    ab6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab6f:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    ab71:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab74:	8b 55 08             	mov    0x8(%ebp),%edx
    ab77:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    ab7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab7d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    ab84:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab87:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab8a:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    ab8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ab90:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ab93:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    ab96:	8b 45 08             	mov    0x8(%ebp),%eax
    ab99:	c1 e0 0c             	shl    $0xc,%eax
    ab9c:	89 c2                	mov    %eax,%edx
    ab9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aba1:	8b 00                	mov    (%eax),%eax
    aba3:	83 ec 04             	sub    $0x4,%esp
    aba6:	52                   	push   %edx
    aba7:	6a 00                	push   $0x0
    aba9:	50                   	push   %eax
    abaa:	e8 07 06 00 00       	call   b1b6 <memset>
    abaf:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    abb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abb5:	8b 00                	mov    (%eax),%eax
    abb7:	eb 69                	jmp    ac22 <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    abb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    abbc:	8b 10                	mov    (%eax),%edx
    abbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    abc1:	8b 40 04             	mov    0x4(%eax),%eax
    abc4:	c1 e0 0c             	shl    $0xc,%eax
    abc7:	01 c2                	add    %eax,%edx
    abc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abcc:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    abce:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abd1:	8b 55 08             	mov    0x8(%ebp),%edx
    abd4:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    abd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    abda:	8b 50 0c             	mov    0xc(%eax),%edx
    abdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abe0:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    abe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abe6:	8b 55 f0             	mov    -0x10(%ebp),%edx
    abe9:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    abec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    abef:	8b 55 ec             	mov    -0x14(%ebp),%edx
    abf2:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    abf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    abf8:	8b 40 0c             	mov    0xc(%eax),%eax
    abfb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    abfe:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    ac01:	8b 45 08             	mov    0x8(%ebp),%eax
    ac04:	c1 e0 0c             	shl    $0xc,%eax
    ac07:	89 c2                	mov    %eax,%edx
    ac09:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac0c:	8b 00                	mov    (%eax),%eax
    ac0e:	83 ec 04             	sub    $0x4,%esp
    ac11:	52                   	push   %edx
    ac12:	6a 00                	push   $0x0
    ac14:	50                   	push   %eax
    ac15:	e8 9c 05 00 00       	call   b1b6 <memset>
    ac1a:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    ac1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac20:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    ac22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    ac25:	c9                   	leave  
    ac26:	c3                   	ret    

0000ac27 <free_page>:

void free_page(_address_order_track_ page)
{
    ac27:	55                   	push   %ebp
    ac28:	89 e5                	mov    %esp,%ebp
    ac2a:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    ac2d:	8b 45 10             	mov    0x10(%ebp),%eax
    ac30:	85 c0                	test   %eax,%eax
    ac32:	75 2d                	jne    ac61 <free_page+0x3a>
    ac34:	8b 45 14             	mov    0x14(%ebp),%eax
    ac37:	85 c0                	test   %eax,%eax
    ac39:	74 26                	je     ac61 <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    ac3b:	b8 be b5 00 00       	mov    $0xb5be,%eax
    ac40:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    ac43:	a1 00 e1 01 00       	mov    0x1e100,%eax
    ac48:	8b 40 0c             	mov    0xc(%eax),%eax
    ac4b:	a3 00 e1 01 00       	mov    %eax,0x1e100
        _page_area_track_->previous_ = END_LIST;
    ac50:	a1 00 e1 01 00       	mov    0x1e100,%eax
    ac55:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ac5c:	e9 13 01 00 00       	jmp    ad74 <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    ac61:	8b 45 10             	mov    0x10(%ebp),%eax
    ac64:	85 c0                	test   %eax,%eax
    ac66:	75 67                	jne    accf <free_page+0xa8>
    ac68:	8b 45 14             	mov    0x14(%ebp),%eax
    ac6b:	85 c0                	test   %eax,%eax
    ac6d:	75 60                	jne    accf <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    ac6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    ac76:	eb 49                	jmp    acc1 <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ac78:	ba be b5 00 00       	mov    $0xb5be,%edx
    ac7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ac80:	c1 e0 04             	shl    $0x4,%eax
    ac83:	05 20 e1 01 00       	add    $0x1e120,%eax
    ac88:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    ac8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ac8d:	c1 e0 04             	shl    $0x4,%eax
    ac90:	05 24 e1 01 00       	add    $0x1e124,%eax
    ac95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    ac9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ac9e:	c1 e0 04             	shl    $0x4,%eax
    aca1:	05 2c e1 01 00       	add    $0x1e12c,%eax
    aca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    acac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    acaf:	c1 e0 04             	shl    $0x4,%eax
    acb2:	05 28 e1 01 00       	add    $0x1e128,%eax
    acb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    acbd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    acc1:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    acc8:	76 ae                	jbe    ac78 <free_page+0x51>
        }
        return;
    acca:	e9 a5 00 00 00       	jmp    ad74 <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    accf:	a1 00 e1 01 00       	mov    0x1e100,%eax
    acd4:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    acd7:	eb 09                	jmp    ace2 <free_page+0xbb>
            tmp = tmp->next_;
    acd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    acdc:	8b 40 0c             	mov    0xc(%eax),%eax
    acdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    ace2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ace5:	8b 10                	mov    (%eax),%edx
    ace7:	8b 45 08             	mov    0x8(%ebp),%eax
    acea:	39 c2                	cmp    %eax,%edx
    acec:	74 0a                	je     acf8 <free_page+0xd1>
    acee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    acf1:	8b 40 0c             	mov    0xc(%eax),%eax
    acf4:	85 c0                	test   %eax,%eax
    acf6:	75 e1                	jne    acd9 <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    acf8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    acfb:	8b 40 0c             	mov    0xc(%eax),%eax
    acfe:	85 c0                	test   %eax,%eax
    ad00:	75 25                	jne    ad27 <free_page+0x100>
    ad02:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad05:	8b 10                	mov    (%eax),%edx
    ad07:	8b 45 08             	mov    0x8(%ebp),%eax
    ad0a:	39 c2                	cmp    %eax,%edx
    ad0c:	75 19                	jne    ad27 <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    ad0e:	ba be b5 00 00       	mov    $0xb5be,%edx
    ad13:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad16:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    ad18:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad1b:	8b 40 08             	mov    0x8(%eax),%eax
    ad1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    ad25:	eb 4d                	jmp    ad74 <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    ad27:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad2a:	8b 40 0c             	mov    0xc(%eax),%eax
    ad2d:	85 c0                	test   %eax,%eax
    ad2f:	74 36                	je     ad67 <free_page+0x140>
    ad31:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad34:	8b 10                	mov    (%eax),%edx
    ad36:	8b 45 08             	mov    0x8(%ebp),%eax
    ad39:	39 c2                	cmp    %eax,%edx
    ad3b:	75 2a                	jne    ad67 <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    ad3d:	ba be b5 00 00       	mov    $0xb5be,%edx
    ad42:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad45:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    ad47:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad4a:	8b 40 08             	mov    0x8(%eax),%eax
    ad4d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    ad50:	8b 52 0c             	mov    0xc(%edx),%edx
    ad53:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    ad56:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad59:	8b 40 0c             	mov    0xc(%eax),%eax
    ad5c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    ad5f:	8b 52 08             	mov    0x8(%edx),%edx
    ad62:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    ad65:	eb 0d                	jmp    ad74 <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    ad67:	a1 04 e1 01 00       	mov    0x1e104,%eax
    ad6c:	83 e8 01             	sub    $0x1,%eax
    ad6f:	a3 04 e1 01 00       	mov    %eax,0x1e104
    ad74:	c9                   	leave  
    ad75:	c3                   	ret    

0000ad76 <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    ad76:	55                   	push   %ebp
    ad77:	89 e5                	mov    %esp,%ebp
    ad79:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    ad7c:	a1 28 21 02 00       	mov    0x22128,%eax
    ad81:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    ad84:	a1 28 21 02 00       	mov    0x22128,%eax
    ad89:	8b 40 3c             	mov    0x3c(%eax),%eax
    ad8c:	a3 28 21 02 00       	mov    %eax,0x22128

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    ad91:	a1 28 21 02 00       	mov    0x22128,%eax
    ad96:	89 c2                	mov    %eax,%edx
    ad98:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad9b:	83 ec 08             	sub    $0x8,%esp
    ad9e:	52                   	push   %edx
    ad9f:	50                   	push   %eax
    ada0:	e8 bb 06 00 00       	call   b460 <switch_to_task>
    ada5:	83 c4 10             	add    $0x10,%esp
}
    ada8:	90                   	nop
    ada9:	c9                   	leave  
    adaa:	c3                   	ret    

0000adab <init_multitasking>:

void init_multitasking()
{
    adab:	55                   	push   %ebp
    adac:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    adae:	c6 05 20 21 02 00 00 	movb   $0x0,0x22120
    sheduler.task_timer = DELAY_PER_TASK;
    adb5:	c7 05 24 21 02 00 2c 	movl   $0x12c,0x22124
    adbc:	01 00 00 
}
    adbf:	90                   	nop
    adc0:	5d                   	pop    %ebp
    adc1:	c3                   	ret    

0000adc2 <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    adc2:	55                   	push   %ebp
    adc3:	89 e5                	mov    %esp,%ebp
    adc5:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    adc8:	8b 45 08             	mov    0x8(%ebp),%eax
    adcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    add1:	8b 45 08             	mov    0x8(%ebp),%eax
    add4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    addb:	8b 45 08             	mov    0x8(%ebp),%eax
    adde:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    ade5:	8b 45 08             	mov    0x8(%ebp),%eax
    ade8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    adef:	8b 45 08             	mov    0x8(%ebp),%eax
    adf2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    adf9:	8b 45 08             	mov    0x8(%ebp),%eax
    adfc:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    ae03:	8b 45 08             	mov    0x8(%ebp),%eax
    ae06:	8b 55 10             	mov    0x10(%ebp),%edx
    ae09:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    ae0c:	8b 55 0c             	mov    0xc(%ebp),%edx
    ae0f:	8b 45 08             	mov    0x8(%ebp),%eax
    ae12:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    ae15:	8b 45 08             	mov    0x8(%ebp),%eax
    ae18:	8b 55 14             	mov    0x14(%ebp),%edx
    ae1b:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    ae1e:	83 ec 0c             	sub    $0xc,%esp
    ae21:	68 c8 00 00 00       	push   $0xc8
    ae26:	e8 c1 f8 ff ff       	call   a6ec <kmalloc>
    ae2b:	83 c4 10             	add    $0x10,%esp
    ae2e:	89 c2                	mov    %eax,%edx
    ae30:	8b 45 08             	mov    0x8(%ebp),%eax
    ae33:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    ae36:	8b 45 08             	mov    0x8(%ebp),%eax
    ae39:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    ae40:	90                   	nop
    ae41:	c9                   	leave  
    ae42:	c3                   	ret    

0000ae43 <putchar>:
 * Print a number (base <= 16) in reverse order,
 */
void puts(const char* string);

void putchar(uint8_t c)
{
    ae43:	55                   	push   %ebp
    ae44:	89 e5                	mov    %esp,%ebp
    ae46:	83 ec 18             	sub    $0x18,%esp
    ae49:	8b 45 08             	mov    0x8(%ebp),%eax
    ae4c:	88 45 f4             	mov    %al,-0xc(%ebp)
    cputchar(READY_COLOR, c);
    ae4f:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    ae53:	0f be c0             	movsbl %al,%eax
    ae56:	83 ec 08             	sub    $0x8,%esp
    ae59:	50                   	push   %eax
    ae5a:	6a 07                	push   $0x7
    ae5c:	e8 7b e3 ff ff       	call   91dc <cputchar>
    ae61:	83 c4 10             	add    $0x10,%esp
}
    ae64:	90                   	nop
    ae65:	c9                   	leave  
    ae66:	c3                   	ret    

0000ae67 <printnum>:

static void printnum(uint32_t num, uint8_t base)
{
    ae67:	55                   	push   %ebp
    ae68:	89 e5                	mov    %esp,%ebp
    ae6a:	53                   	push   %ebx
    ae6b:	83 ec 14             	sub    $0x14,%esp
    ae6e:	8b 45 0c             	mov    0xc(%ebp),%eax
    ae71:	88 45 f4             	mov    %al,-0xc(%ebp)
    if (num >= base) printnum((uint32_t)(num / base), base);
    ae74:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    ae78:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae7b:	72 1f                	jb     ae9c <printnum+0x35>
    ae7d:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    ae81:	0f b6 5d f4          	movzbl -0xc(%ebp),%ebx
    ae85:	8b 45 08             	mov    0x8(%ebp),%eax
    ae88:	ba 00 00 00 00       	mov    $0x0,%edx
    ae8d:	f7 f3                	div    %ebx
    ae8f:	83 ec 08             	sub    $0x8,%esp
    ae92:	51                   	push   %ecx
    ae93:	50                   	push   %eax
    ae94:	e8 ce ff ff ff       	call   ae67 <printnum>
    ae99:	83 c4 10             	add    $0x10,%esp

    putchar("0123456789abcdef"[num % base]);
    ae9c:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    aea0:	8b 45 08             	mov    0x8(%ebp),%eax
    aea3:	ba 00 00 00 00       	mov    $0x0,%edx
    aea8:	f7 f1                	div    %ecx
    aeaa:	89 d0                	mov    %edx,%eax
    aeac:	0f b6 80 cc b5 00 00 	movzbl 0xb5cc(%eax),%eax
    aeb3:	0f b6 c0             	movzbl %al,%eax
    aeb6:	83 ec 0c             	sub    $0xc,%esp
    aeb9:	50                   	push   %eax
    aeba:	e8 84 ff ff ff       	call   ae43 <putchar>
    aebf:	83 c4 10             	add    $0x10,%esp
}
    aec2:	90                   	nop
    aec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    aec6:	c9                   	leave  
    aec7:	c3                   	ret    

0000aec8 <printf>:

void printf(const char* fmt, va_list arg)
{
    aec8:	55                   	push   %ebp
    aec9:	89 e5                	mov    %esp,%ebp
    aecb:	83 ec 18             	sub    $0x18,%esp
    char*    s;
    int*     p;

    const char* chr_tmp;

    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    aece:	8b 45 08             	mov    0x8(%ebp),%eax
    aed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    aed4:	e9 53 01 00 00       	jmp    b02c <printf+0x164>

        if (*chr_tmp == '%') {
    aed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aedc:	0f b6 00             	movzbl (%eax),%eax
    aedf:	3c 25                	cmp    $0x25,%al
    aee1:	0f 85 29 01 00 00    	jne    b010 <printf+0x148>
            chr_tmp++;
    aee7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            switch (*chr_tmp) {
    aeeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aeee:	0f b6 00             	movzbl (%eax),%eax
    aef1:	0f be c0             	movsbl %al,%eax
    aef4:	83 e8 62             	sub    $0x62,%eax
    aef7:	83 f8 16             	cmp    $0x16,%eax
    aefa:	0f 87 27 01 00 00    	ja     b027 <printf+0x15f>
    af00:	8b 04 85 e0 b5 00 00 	mov    0xb5e0(,%eax,4),%eax
    af07:	ff e0                	jmp    *%eax
            case 'c':
                i = va_arg(arg, int32_t);
    af09:	8b 45 0c             	mov    0xc(%ebp),%eax
    af0c:	8d 50 04             	lea    0x4(%eax),%edx
    af0f:	89 55 0c             	mov    %edx,0xc(%ebp)
    af12:	8b 00                	mov    (%eax),%eax
    af14:	89 45 f0             	mov    %eax,-0x10(%ebp)
                putchar(i);
    af17:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af1a:	0f b6 c0             	movzbl %al,%eax
    af1d:	83 ec 0c             	sub    $0xc,%esp
    af20:	50                   	push   %eax
    af21:	e8 1d ff ff ff       	call   ae43 <putchar>
    af26:	83 c4 10             	add    $0x10,%esp
                break;
    af29:	e9 fa 00 00 00       	jmp    b028 <printf+0x160>
            case 'd':
                i = va_arg(arg, int);
    af2e:	8b 45 0c             	mov    0xc(%ebp),%eax
    af31:	8d 50 04             	lea    0x4(%eax),%edx
    af34:	89 55 0c             	mov    %edx,0xc(%ebp)
    af37:	8b 00                	mov    (%eax),%eax
    af39:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 10);
    af3c:	83 ec 08             	sub    $0x8,%esp
    af3f:	6a 0a                	push   $0xa
    af41:	ff 75 f0             	push   -0x10(%ebp)
    af44:	e8 1e ff ff ff       	call   ae67 <printnum>
    af49:	83 c4 10             	add    $0x10,%esp
                break;
    af4c:	e9 d7 00 00 00       	jmp    b028 <printf+0x160>
            case 'o':
                i = va_arg(arg, int32_t);
    af51:	8b 45 0c             	mov    0xc(%ebp),%eax
    af54:	8d 50 04             	lea    0x4(%eax),%edx
    af57:	89 55 0c             	mov    %edx,0xc(%ebp)
    af5a:	8b 00                	mov    (%eax),%eax
    af5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 8);
    af5f:	83 ec 08             	sub    $0x8,%esp
    af62:	6a 08                	push   $0x8
    af64:	ff 75 f0             	push   -0x10(%ebp)
    af67:	e8 fb fe ff ff       	call   ae67 <printnum>
    af6c:	83 c4 10             	add    $0x10,%esp
                break;
    af6f:	e9 b4 00 00 00       	jmp    b028 <printf+0x160>
            case 'b':
                i = va_arg(arg, int32_t);
    af74:	8b 45 0c             	mov    0xc(%ebp),%eax
    af77:	8d 50 04             	lea    0x4(%eax),%edx
    af7a:	89 55 0c             	mov    %edx,0xc(%ebp)
    af7d:	8b 00                	mov    (%eax),%eax
    af7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 2);
    af82:	83 ec 08             	sub    $0x8,%esp
    af85:	6a 02                	push   $0x2
    af87:	ff 75 f0             	push   -0x10(%ebp)
    af8a:	e8 d8 fe ff ff       	call   ae67 <printnum>
    af8f:	83 c4 10             	add    $0x10,%esp
                break;
    af92:	e9 91 00 00 00       	jmp    b028 <printf+0x160>
            case 'x':
                i = va_arg(arg, int32_t);
    af97:	8b 45 0c             	mov    0xc(%ebp),%eax
    af9a:	8d 50 04             	lea    0x4(%eax),%edx
    af9d:	89 55 0c             	mov    %edx,0xc(%ebp)
    afa0:	8b 00                	mov    (%eax),%eax
    afa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 16);
    afa5:	83 ec 08             	sub    $0x8,%esp
    afa8:	6a 10                	push   $0x10
    afaa:	ff 75 f0             	push   -0x10(%ebp)
    afad:	e8 b5 fe ff ff       	call   ae67 <printnum>
    afb2:	83 c4 10             	add    $0x10,%esp
                break;
    afb5:	eb 71                	jmp    b028 <printf+0x160>
            case 's':
                s = va_arg(arg, char*);
    afb7:	8b 45 0c             	mov    0xc(%ebp),%eax
    afba:	8d 50 04             	lea    0x4(%eax),%edx
    afbd:	89 55 0c             	mov    %edx,0xc(%ebp)
    afc0:	8b 00                	mov    (%eax),%eax
    afc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
                puts(s);
    afc5:	83 ec 0c             	sub    $0xc,%esp
    afc8:	ff 75 ec             	push   -0x14(%ebp)
    afcb:	e8 6e 00 00 00       	call   b03e <puts>
    afd0:	83 c4 10             	add    $0x10,%esp
                break;
    afd3:	eb 53                	jmp    b028 <printf+0x160>
            case 'p':
                p = va_arg(arg, void*);
    afd5:	8b 45 0c             	mov    0xc(%ebp),%eax
    afd8:	8d 50 04             	lea    0x4(%eax),%edx
    afdb:	89 55 0c             	mov    %edx,0xc(%ebp)
    afde:	8b 00                	mov    (%eax),%eax
    afe0:	89 45 e8             	mov    %eax,-0x18(%ebp)
                putchar('0');
    afe3:	83 ec 0c             	sub    $0xc,%esp
    afe6:	6a 30                	push   $0x30
    afe8:	e8 56 fe ff ff       	call   ae43 <putchar>
    afed:	83 c4 10             	add    $0x10,%esp
                putchar('x');
    aff0:	83 ec 0c             	sub    $0xc,%esp
    aff3:	6a 78                	push   $0x78
    aff5:	e8 49 fe ff ff       	call   ae43 <putchar>
    affa:	83 c4 10             	add    $0x10,%esp
                printnum((uint32_t)p, 16);
    affd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    b000:	83 ec 08             	sub    $0x8,%esp
    b003:	6a 10                	push   $0x10
    b005:	50                   	push   %eax
    b006:	e8 5c fe ff ff       	call   ae67 <printnum>
    b00b:	83 c4 10             	add    $0x10,%esp
                break;
    b00e:	eb 18                	jmp    b028 <printf+0x160>
                break;
            }
        }

        else
            putchar(*chr_tmp);
    b010:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b013:	0f b6 00             	movzbl (%eax),%eax
    b016:	0f b6 c0             	movzbl %al,%eax
    b019:	83 ec 0c             	sub    $0xc,%esp
    b01c:	50                   	push   %eax
    b01d:	e8 21 fe ff ff       	call   ae43 <putchar>
    b022:	83 c4 10             	add    $0x10,%esp
    b025:	eb 01                	jmp    b028 <printf+0x160>
                break;
    b027:	90                   	nop
    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    b028:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b02c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b02f:	0f b6 00             	movzbl (%eax),%eax
    b032:	84 c0                	test   %al,%al
    b034:	0f 85 9f fe ff ff    	jne    aed9 <printf+0x11>
    }

    va_end(arg);
}
    b03a:	90                   	nop
    b03b:	90                   	nop
    b03c:	c9                   	leave  
    b03d:	c3                   	ret    

0000b03e <puts>:

void puts(const char* string)
{
    b03e:	55                   	push   %ebp
    b03f:	89 e5                	mov    %esp,%ebp
    b041:	83 ec 08             	sub    $0x8,%esp
    if (*string != '\0') {
    b044:	8b 45 08             	mov    0x8(%ebp),%eax
    b047:	0f b6 00             	movzbl (%eax),%eax
    b04a:	84 c0                	test   %al,%al
    b04c:	74 2a                	je     b078 <puts+0x3a>
        putchar(*string);
    b04e:	8b 45 08             	mov    0x8(%ebp),%eax
    b051:	0f b6 00             	movzbl (%eax),%eax
    b054:	0f b6 c0             	movzbl %al,%eax
    b057:	83 ec 0c             	sub    $0xc,%esp
    b05a:	50                   	push   %eax
    b05b:	e8 e3 fd ff ff       	call   ae43 <putchar>
    b060:	83 c4 10             	add    $0x10,%esp
        puts(string++);
    b063:	8b 45 08             	mov    0x8(%ebp),%eax
    b066:	8d 50 01             	lea    0x1(%eax),%edx
    b069:	89 55 08             	mov    %edx,0x8(%ebp)
    b06c:	83 ec 0c             	sub    $0xc,%esp
    b06f:	50                   	push   %eax
    b070:	e8 c9 ff ff ff       	call   b03e <puts>
    b075:	83 c4 10             	add    $0x10,%esp
    }
    b078:	90                   	nop
    b079:	c9                   	leave  
    b07a:	c3                   	ret    

0000b07b <_strcmp_>:
#include "../../include/lib/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    b07b:	55                   	push   %ebp
    b07c:	89 e5                	mov    %esp,%ebp
    b07e:	53                   	push   %ebx
    b07f:	83 ec 04             	sub    $0x4,%esp
    if (_strlen_(str2) != _strlen_(str1))
    b082:	83 ec 0c             	sub    $0xc,%esp
    b085:	ff 75 0c             	push   0xc(%ebp)
    b088:	e8 59 00 00 00       	call   b0e6 <_strlen_>
    b08d:	83 c4 10             	add    $0x10,%esp
    b090:	89 c3                	mov    %eax,%ebx
    b092:	83 ec 0c             	sub    $0xc,%esp
    b095:	ff 75 08             	push   0x8(%ebp)
    b098:	e8 49 00 00 00       	call   b0e6 <_strlen_>
    b09d:	83 c4 10             	add    $0x10,%esp
    b0a0:	38 c3                	cmp    %al,%bl
    b0a2:	74 0f                	je     b0b3 <_strcmp_+0x38>
        return 0;
    b0a4:	b8 00 00 00 00       	mov    $0x0,%eax
    b0a9:	eb 36                	jmp    b0e1 <_strcmp_+0x66>

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
    b0ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        str2++;
    b0af:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while ((*str1 == *str2) && (*str1 != '\000')) {
    b0b3:	8b 45 08             	mov    0x8(%ebp),%eax
    b0b6:	0f b6 10             	movzbl (%eax),%edx
    b0b9:	8b 45 0c             	mov    0xc(%ebp),%eax
    b0bc:	0f b6 00             	movzbl (%eax),%eax
    b0bf:	38 c2                	cmp    %al,%dl
    b0c1:	75 0a                	jne    b0cd <_strcmp_+0x52>
    b0c3:	8b 45 08             	mov    0x8(%ebp),%eax
    b0c6:	0f b6 00             	movzbl (%eax),%eax
    b0c9:	84 c0                	test   %al,%al
    b0cb:	75 de                	jne    b0ab <_strcmp_+0x30>
    }

    return *str1 == *str2;
    b0cd:	8b 45 08             	mov    0x8(%ebp),%eax
    b0d0:	0f b6 10             	movzbl (%eax),%edx
    b0d3:	8b 45 0c             	mov    0xc(%ebp),%eax
    b0d6:	0f b6 00             	movzbl (%eax),%eax
    b0d9:	38 c2                	cmp    %al,%dl
    b0db:	0f 94 c0             	sete   %al
    b0de:	0f b6 c0             	movzbl %al,%eax
}
    b0e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    b0e4:	c9                   	leave  
    b0e5:	c3                   	ret    

0000b0e6 <_strlen_>:

uint8_t _strlen_(char* str)
{
    b0e6:	55                   	push   %ebp
    b0e7:	89 e5                	mov    %esp,%ebp
    b0e9:	83 ec 10             	sub    $0x10,%esp
    if (*str == '\000')
    b0ec:	8b 45 08             	mov    0x8(%ebp),%eax
    b0ef:	0f b6 00             	movzbl (%eax),%eax
    b0f2:	84 c0                	test   %al,%al
    b0f4:	75 07                	jne    b0fd <_strlen_+0x17>
        return 0;
    b0f6:	b8 00 00 00 00       	mov    $0x0,%eax
    b0fb:	eb 22                	jmp    b11f <_strlen_+0x39>

    uint8_t i = 1;
    b0fd:	c6 45 ff 01          	movb   $0x1,-0x1(%ebp)

    while (*str != '\000') {
    b101:	eb 0e                	jmp    b111 <_strlen_+0x2b>
        str++;
    b103:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        i++;
    b107:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    b10b:	83 c0 01             	add    $0x1,%eax
    b10e:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (*str != '\000') {
    b111:	8b 45 08             	mov    0x8(%ebp),%eax
    b114:	0f b6 00             	movzbl (%eax),%eax
    b117:	84 c0                	test   %al,%al
    b119:	75 e8                	jne    b103 <_strlen_+0x1d>
    }

    return i;
    b11b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
    b11f:	c9                   	leave  
    b120:	c3                   	ret    

0000b121 <_strcpy_>:

void* _strcpy_(char* dest, char* src)
{
    b121:	55                   	push   %ebp
    b122:	89 e5                	mov    %esp,%ebp
    b124:	83 ec 10             	sub    $0x10,%esp
    if (dest == NULL)
    b127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    b12b:	75 07                	jne    b134 <_strcpy_+0x13>
        return (void*)NULL;
    b12d:	b8 00 00 00 00       	mov    $0x0,%eax
    b132:	eb 46                	jmp    b17a <_strcpy_+0x59>

    uint8_t i = 0;
    b134:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    while (src[i] != '\000') {
    b138:	eb 21                	jmp    b15b <_strcpy_+0x3a>
        dest[i] = src[i];
    b13a:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    b13e:	8b 45 0c             	mov    0xc(%ebp),%eax
    b141:	01 d0                	add    %edx,%eax
    b143:	0f b6 4d ff          	movzbl -0x1(%ebp),%ecx
    b147:	8b 55 08             	mov    0x8(%ebp),%edx
    b14a:	01 ca                	add    %ecx,%edx
    b14c:	0f b6 00             	movzbl (%eax),%eax
    b14f:	88 02                	mov    %al,(%edx)
        i++;
    b151:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    b155:	83 c0 01             	add    $0x1,%eax
    b158:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (src[i] != '\000') {
    b15b:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    b15f:	8b 45 0c             	mov    0xc(%ebp),%eax
    b162:	01 d0                	add    %edx,%eax
    b164:	0f b6 00             	movzbl (%eax),%eax
    b167:	84 c0                	test   %al,%al
    b169:	75 cf                	jne    b13a <_strcpy_+0x19>
    }

    dest[i] = '\000';
    b16b:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    b16f:	8b 45 08             	mov    0x8(%ebp),%eax
    b172:	01 d0                	add    %edx,%eax
    b174:	c6 00 00             	movb   $0x0,(%eax)

    return (void*)dest;
    b177:	8b 45 08             	mov    0x8(%ebp),%eax
}
    b17a:	c9                   	leave  
    b17b:	c3                   	ret    

0000b17c <memcpy>:

void* memcpy(void* dest, const void* src, uint32_t size)
{
    b17c:	55                   	push   %ebp
    b17d:	89 e5                	mov    %esp,%ebp
    b17f:	83 ec 10             	sub    $0x10,%esp
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    b182:	8b 45 08             	mov    0x8(%ebp),%eax
    b185:	89 45 fc             	mov    %eax,-0x4(%ebp)
    _src_  = (char*)src;
    b188:	8b 45 0c             	mov    0xc(%ebp),%eax
    b18b:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (size) {
    b18e:	eb 1b                	jmp    b1ab <memcpy+0x2f>
        *(_dest_++) = *(_src_++);
    b190:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b193:	8d 42 01             	lea    0x1(%edx),%eax
    b196:	89 45 f8             	mov    %eax,-0x8(%ebp)
    b199:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b19c:	8d 48 01             	lea    0x1(%eax),%ecx
    b19f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    b1a2:	0f b6 12             	movzbl (%edx),%edx
    b1a5:	88 10                	mov    %dl,(%eax)
        size--;
    b1a7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (size) {
    b1ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    b1af:	75 df                	jne    b190 <memcpy+0x14>
    }

    return (void*)dest;
    b1b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    b1b4:	c9                   	leave  
    b1b5:	c3                   	ret    

0000b1b6 <memset>:

void* memset(void* mem, int8_t data, int size)
{
    b1b6:	55                   	push   %ebp
    b1b7:	89 e5                	mov    %esp,%ebp
    b1b9:	83 ec 14             	sub    $0x14,%esp
    b1bc:	8b 45 0c             	mov    0xc(%ebp),%eax
    b1bf:	88 45 ec             	mov    %al,-0x14(%ebp)
    int i = 0;
    b1c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

    int8_t* tmp = mem;
    b1c9:	8b 45 08             	mov    0x8(%ebp),%eax
    b1cc:	89 45 f8             	mov    %eax,-0x8(%ebp)

    for (i; i < size; i++)
    b1cf:	eb 12                	jmp    b1e3 <memset+0x2d>
        tmp[i] = data;
    b1d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
    b1d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1d7:	01 c2                	add    %eax,%edx
    b1d9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    b1dd:	88 02                	mov    %al,(%edx)
    for (i; i < size; i++)
    b1df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b1e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b1e6:	3b 45 10             	cmp    0x10(%ebp),%eax
    b1e9:	7c e6                	jl     b1d1 <memset+0x1b>

    return (void*)mem;
    b1eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
    b1ee:	c9                   	leave  
    b1ef:	c3                   	ret    

0000b1f0 <_memcmp_>:

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    b1f0:	55                   	push   %ebp
    b1f1:	89 e5                	mov    %esp,%ebp
    b1f3:	83 ec 10             	sub    $0x10,%esp
    char* mem_1 = (char*)src_1;
    b1f6:	8b 45 08             	mov    0x8(%ebp),%eax
    b1f9:	89 45 fc             	mov    %eax,-0x4(%ebp)

    char* mem_2 = (char*)src_2;
    b1fc:	8b 45 0c             	mov    0xc(%ebp),%eax
    b1ff:	89 45 f8             	mov    %eax,-0x8(%ebp)

    uint32_t i = 0;
    b202:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (i < size && *mem_1 == *mem_2) {
    b209:	eb 0c                	jmp    b217 <_memcmp_+0x27>
        i++;
    b20b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        mem_1++;
    b20f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
        mem_2++;
    b213:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (i < size && *mem_1 == *mem_2) {
    b217:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b21a:	3b 45 10             	cmp    0x10(%ebp),%eax
    b21d:	73 10                	jae    b22f <_memcmp_+0x3f>
    b21f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b222:	0f b6 10             	movzbl (%eax),%edx
    b225:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b228:	0f b6 00             	movzbl (%eax),%eax
    b22b:	38 c2                	cmp    %al,%dl
    b22d:	74 dc                	je     b20b <_memcmp_+0x1b>
    }

    return i == size;
    b22f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b232:	3b 45 10             	cmp    0x10(%ebp),%eax
    b235:	0f 94 c0             	sete   %al
    b238:	0f b6 c0             	movzbl %al,%eax
    b23b:	c9                   	leave  
    b23c:	c3                   	ret    
    b23d:	66 90                	xchg   %ax,%ax
    b23f:	90                   	nop

0000b240 <__exception_handler__>:
extern __exception__ , __exception_no_ERRCODE__

section .text
    
    __exception_handler__:
        pop eax 
    b240:	58                   	pop    %eax
        mov dword[__error_code__] , eax
    b241:	a3 5c c2 00 00       	mov    %eax,0xc25c
        call __exception__
    b246:	e8 8d e3 ff ff       	call   95d8 <__exception__>
        iret
    b24b:	cf                   	iret   

0000b24c <__exception_no_ERRCODE_handler__>:

    __exception_no_ERRCODE_handler__:
        call __exception_no_ERRCODE__
    b24c:	e8 8d e3 ff ff       	call   95de <__exception_no_ERRCODE__>
        iret
    b251:	cf                   	iret   
    b252:	66 90                	xchg   %ax,%ax
    b254:	66 90                	xchg   %ax,%ax
    b256:	66 90                	xchg   %ax,%ax
    b258:	66 90                	xchg   %ax,%ax
    b25a:	66 90                	xchg   %ax,%ax
    b25c:	66 90                	xchg   %ax,%ax
    b25e:	66 90                	xchg   %ax,%ax

0000b260 <gdtr>:
global load_idt , load_gdt
extern __idt__

gdtr DW 0	;For limit
    b260:	00 00 00 00 00 00                                   ......

0000b266 <load_gdt>:
	DD 0	;For Base

section .text

load_gdt:
	cli
    b266:	fa                   	cli    
	push eax
    b267:	50                   	push   %eax
	push ecx
    b268:	51                   	push   %ecx
		mov ecx , 0x0
    b269:	b9 00 00 00 00       	mov    $0x0,%ecx
		mov dword [gdtr+2] , ecx
    b26e:	89 0d 62 b2 00 00    	mov    %ecx,0xb262

		xor eax , eax
    b274:	31 c0                	xor    %eax,%eax
		mov eax ,4*64
    b276:	b8 00 01 00 00       	mov    $0x100,%eax
		add eax ,ecx
    b27b:	01 c8                	add    %ecx,%eax
		mov word [gdtr] , ax
    b27d:	66 a3 60 b2 00 00    	mov    %ax,0xb260
		
		lgdt [gdtr]
    b283:	0f 01 15 60 b2 00 00 	lgdtl  0xb260
		mov ecx , dword [gdtr+2]
    b28a:	8b 0d 62 b2 00 00    	mov    0xb262,%ecx
		add ecx , 0x20
    b290:	83 c1 20             	add    $0x20,%ecx
		ltr cx
    b293:	0f 00 d9             	ltr    %cx
	pop ecx
    b296:	59                   	pop    %ecx
	pop eax
    b297:	58                   	pop    %eax
	ret
    b298:	c3                   	ret    

0000b299 <idtr>:

idtr dw 0
    b299:	00 00 00 00 00 00                                   ......

0000b29f <load_idt>:
	dd 0

load_idt:
	cli
    b29f:	fa                   	cli    

	push eax
    b2a0:	50                   	push   %eax
	push ecx
    b2a1:	51                   	push   %ecx
		xor ecx ,ecx
    b2a2:	31 c9                	xor    %ecx,%ecx
		mov ecx , __idt__
    b2a4:	b9 40 f4 00 00       	mov    $0xf440,%ecx
		mov dword [idtr+2] , ecx
    b2a9:	89 0d 9b b2 00 00    	mov    %ecx,0xb29b

		xor eax , eax
    b2af:	31 c0                	xor    %eax,%eax
		mov eax ,16*64
    b2b1:	b8 00 04 00 00       	mov    $0x400,%eax
		add eax ,ecx
    b2b6:	01 c8                	add    %ecx,%eax
		mov word [idtr] , ax
    b2b8:	66 a3 99 b2 00 00    	mov    %ax,0xb299
		
		lidt [idtr]
    b2be:	0f 01 1d 99 b2 00 00 	lidtl  0xb299
	pop ecx
    b2c5:	59                   	pop    %ecx
	pop eax
    b2c6:	58                   	pop    %eax
	ret
    b2c7:	c3                   	ret    
    b2c8:	66 90                	xchg   %ax,%ax
    b2ca:	66 90                	xchg   %ax,%ax
    b2cc:	66 90                	xchg   %ax,%ax
    b2ce:	66 90                	xchg   %ax,%ax

0000b2d0 <irq1>:
section .text
 

 
irq1:
  pusha
    b2d0:	60                   	pusha  
  call irq1_handler
    b2d1:	e8 81 e9 ff ff       	call   9c57 <irq1_handler>
  popa
    b2d6:	61                   	popa   
  iret
    b2d7:	cf                   	iret   

0000b2d8 <irq2>:
 
irq2:
  pusha
    b2d8:	60                   	pusha  
  call irq2_handler
    b2d9:	e8 94 e9 ff ff       	call   9c72 <irq2_handler>
  popa
    b2de:	61                   	popa   
  iret
    b2df:	cf                   	iret   

0000b2e0 <irq3>:
 
irq3:
  pusha
    b2e0:	60                   	pusha  
  call irq3_handler
    b2e1:	e8 af e9 ff ff       	call   9c95 <irq3_handler>
  popa
    b2e6:	61                   	popa   
  iret
    b2e7:	cf                   	iret   

0000b2e8 <irq4>:
 
irq4:
  pusha
    b2e8:	60                   	pusha  
  call irq4_handler
    b2e9:	e8 ca e9 ff ff       	call   9cb8 <irq4_handler>
  popa
    b2ee:	61                   	popa   
  iret
    b2ef:	cf                   	iret   

0000b2f0 <irq5>:
 
irq5:
  pusha
    b2f0:	60                   	pusha  
  call irq5_handler
    b2f1:	e8 e5 e9 ff ff       	call   9cdb <irq5_handler>
  popa
    b2f6:	61                   	popa   
  iret
    b2f7:	cf                   	iret   

0000b2f8 <irq6>:
 
irq6:
  pusha
    b2f8:	60                   	pusha  
  call irq6_handler
    b2f9:	e8 00 ea ff ff       	call   9cfe <irq6_handler>
  popa
    b2fe:	61                   	popa   
  iret
    b2ff:	cf                   	iret   

0000b300 <irq7>:
 
irq7:
  pusha
    b300:	60                   	pusha  
  call irq7_handler
    b301:	e8 1b ea ff ff       	call   9d21 <irq7_handler>
  popa
    b306:	61                   	popa   
  iret
    b307:	cf                   	iret   

0000b308 <irq8>:
 
irq8:
  pusha
    b308:	60                   	pusha  
  call irq8_handler
    b309:	e8 36 ea ff ff       	call   9d44 <irq8_handler>
  popa
    b30e:	61                   	popa   
  iret
    b30f:	cf                   	iret   

0000b310 <irq9>:
 
irq9:
  pusha
    b310:	60                   	pusha  
  call irq9_handler
    b311:	e8 51 ea ff ff       	call   9d67 <irq9_handler>
  popa
    b316:	61                   	popa   
  iret
    b317:	cf                   	iret   

0000b318 <irq10>:
 
irq10:
  pusha
    b318:	60                   	pusha  
  call irq10_handler
    b319:	e8 6c ea ff ff       	call   9d8a <irq10_handler>
  popa
    b31e:	61                   	popa   
  iret
    b31f:	cf                   	iret   

0000b320 <irq11>:
 
irq11:
  pusha
    b320:	60                   	pusha  
  call irq11_handler
    b321:	e8 87 ea ff ff       	call   9dad <irq11_handler>
  popa
    b326:	61                   	popa   
  iret
    b327:	cf                   	iret   

0000b328 <irq12>:
 
irq12:
  pusha
    b328:	60                   	pusha  
  call irq12_handler
    b329:	e8 a2 ea ff ff       	call   9dd0 <irq12_handler>
  popa
    b32e:	61                   	popa   
  iret
    b32f:	cf                   	iret   

0000b330 <irq13>:
 
irq13:
  pusha
    b330:	60                   	pusha  
  call irq13_handler
    b331:	e8 bd ea ff ff       	call   9df3 <irq13_handler>
  popa
    b336:	61                   	popa   
  iret
    b337:	cf                   	iret   

0000b338 <irq14>:
 
irq14:
  pusha
    b338:	60                   	pusha  
  call irq14_handler
    b339:	e8 d8 ea ff ff       	call   9e16 <irq14_handler>
  popa
    b33e:	61                   	popa   
  iret
    b33f:	cf                   	iret   

0000b340 <irq15>:
 
irq15:
  pusha
    b340:	60                   	pusha  
  call irq15_handler
    b341:	e8 f3 ea ff ff       	call   9e39 <irq15_handler>
  popa
    b346:	61                   	popa   
    b347:	cf                   	iret   
    b348:	66 90                	xchg   %ax,%ax
    b34a:	66 90                	xchg   %ax,%ax
    b34c:	66 90                	xchg   %ax,%ax
    b34e:	66 90                	xchg   %ax,%ax

0000b350 <_FlushPagingCache_>:


section .text

_FlushPagingCache_:
    mov eax , page_directory
    b350:	b8 00 00 01 00       	mov    $0x10000,%eax
    mov cr3 , eax
    b355:	0f 22 d8             	mov    %eax,%cr3
    ret
    b358:	c3                   	ret    

0000b359 <_EnablingPaging_>:

_EnablingPaging_:
    call _FlushPagingCache_
    b359:	e8 f2 ff ff ff       	call   b350 <_FlushPagingCache_>
    mov eax , cr0
    b35e:	0f 20 c0             	mov    %cr0,%eax
    ;SI le CD flag de CR0 est à 0 , le cache est activer pour certaines parties de la mémoire système
    ;mais doit être restreint pour les pages individuelles ou région de la mémoire venant d'autre mecanisme de control de cache

    ;Si le CD flage CR0 est a 1 , le cache est restreint dans le cache du processeur(cache herarchy). 
    ;Le cache doit être explicitement purgé pour assurer la cohérence dans la mémoire.
    or eax , 0x80000001
    b361:	0d 01 00 00 80       	or     $0x80000001,%eax
    mov cr0 , eax
    b366:	0f 22 c0             	mov    %eax,%cr0
    ret
    b369:	c3                   	ret    

0000b36a <PagingFault_Handler>:

PagingFault_Handler:
    pop eax
    b36a:	58                   	pop    %eax
    mov dword[error_code] , eax
    b36b:	a3 60 c2 00 00       	mov    %eax,0xc260
    call Paging_fault
    b370:	e8 c5 ec ff ff       	call   a03a <Paging_fault>
    iret
    b375:	cf                   	iret   
    b376:	66 90                	xchg   %ax,%ax
    b378:	66 90                	xchg   %ax,%ax
    b37a:	66 90                	xchg   %ax,%ax
    b37c:	66 90                	xchg   %ax,%ax
    b37e:	66 90                	xchg   %ax,%ax

0000b380 <PIT_handler>:
section .text
PIT_handler:
   
   
      
   pushfd
    b380:	9c                   	pushf  
      call irq_PIT
    b381:	e8 16 00 00 00       	call   b39c <irq_PIT>
      call conserv_status_byte
    b386:	e8 f6 ee ff ff       	call   a281 <conserv_status_byte>
      call sheduler_cpu_timer   
    b38b:	e8 8d ef ff ff       	call   a31d <sheduler_cpu_timer>
   

      nop
    b390:	90                   	nop
      nop
    b391:	90                   	nop
      nop
    b392:	90                   	nop
      nop
    b393:	90                   	nop
      nop
    b394:	90                   	nop
      nop
    b395:	90                   	nop
      nop
    b396:	90                   	nop
      nop
    b397:	90                   	nop
      nop
    b398:	90                   	nop
      nop
    b399:	90                   	nop

   popfd
    b39a:	9d                   	popf   

   
	iretd
    b39b:	cf                   	iret   

0000b39c <irq_PIT>:

irq_PIT:
        mov eax ,dword [IRQ0_fractions]
    b39c:	a1 48 22 02 00       	mov    0x22248,%eax
        mov ebx ,dword [IRQ0_ms]  ;eax.ebx = amount of time between IRQs
    b3a1:	8b 1d 4c 22 02 00    	mov    0x2224c,%ebx
        add dword [system_timer_fractions] , eax  ;Update system timer ticks fractions
    b3a7:	01 05 40 22 02 00    	add    %eax,0x22240
        adc dword [system_timer_ms] , ebx ;Update system timer ticks multi-seconde   
    b3ad:	11 1d 44 22 02 00    	adc    %ebx,0x22244
    push 0
    b3b3:	6a 00                	push   $0x0
      call PIC_sendEOI
    b3b5:	e8 86 ec ff ff       	call   a040 <PIC_sendEOI>
      pop eax
    b3ba:	58                   	pop    %eax
    ret
    b3bb:	c3                   	ret    

0000b3bc <calculate_frequency>:
;For example if you want 8000 Hz then you've got a choice of 8007.93 Hz or 7954.544 Hz. 
;In this case the following code will find the nearest possible frequency.
;Once it has calculated the nearest possible frequency it will reverse 
;the calculation to find the actual frequency selected
calculate_frequency:
    pushad
    b3bc:	60                   	pusha  
    ; Do some checking
    mov ebx ,dword [frequency]
    b3bd:	8b 1d 04 10 01 00    	mov    0x11004,%ebx
   
    mov eax,0x10000                   ;eax = reload value for slowest possible frequency (65536)
    b3c3:	b8 00 00 01 00       	mov    $0x10000,%eax
    cmp ebx,18                        ;Is the requested frequency too low?
    b3c8:	83 fb 12             	cmp    $0x12,%ebx
    jbe .gotReloadValue               ; yes, use slowest possible frequency
    b3cb:	76 34                	jbe    b401 <calculate_frequency.gotReloadValue>
 
    mov eax,1                         ;ax = reload value for fastest possible frequency (1)
    b3cd:	b8 01 00 00 00       	mov    $0x1,%eax
    cmp ebx,1193181                   ;Is the requested frequency too high?
    b3d2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    jae .gotReloadValue               ; yes, use fastest possible frequency
    b3d8:	73 27                	jae    b401 <calculate_frequency.gotReloadValue>
 
    ; Calculate the reload value
 
    mov eax,3579545
    b3da:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    mov edx,0                         ;edx:eax = 3579545
    b3df:	ba 00 00 00 00       	mov    $0x0,%edx
    div ebx                           ;eax = 3579545 / frequency, edx = remainder
    b3e4:	f7 f3                	div    %ebx
    cmp edx,3579545 / 2               ;Is the remainder more than half?
    b3e6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    jb .l1                            ; no, round down
    b3ec:	72 01                	jb     b3ef <calculate_frequency.l1>
    inc eax                           ; yes, round up
    b3ee:	40                   	inc    %eax

0000b3ef <calculate_frequency.l1>:
 .l1:
    mov ebx,3
    b3ef:	bb 03 00 00 00       	mov    $0x3,%ebx
    mov edx,0                         ;edx:eax = 3579545 * 256 / frequency
    b3f4:	ba 00 00 00 00       	mov    $0x0,%edx
    div ebx                           ;eax = (3579545 * 256 / 3 * 256) / frequency
    b3f9:	f7 f3                	div    %ebx
    cmp edx,3 / 2                     ;Is the remainder more than half?
    b3fb:	83 fa 01             	cmp    $0x1,%edx
    jb .l2                            ; no, round down
    b3fe:	72 01                	jb     b401 <calculate_frequency.gotReloadValue>
    inc eax                           ; yes, round up
    b400:	40                   	inc    %eax

0000b401 <calculate_frequency.gotReloadValue>:
 
 
 ; Store the reload value and calculate the actual frequency
 
 .gotReloadValue:
    push eax                          ;Store reload_value for later
    b401:	50                   	push   %eax
    mov [PIT_reload_value],ax         ;Store the reload value for later
    b402:	66 a3 54 22 02 00    	mov    %ax,0x22254
    mov ebx,eax                       ;ebx = reload value
    b408:	89 c3                	mov    %eax,%ebx
 
    mov eax,3579545
    b40a:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    mov edx,0                         ;edx:eax = 3579545
    b40f:	ba 00 00 00 00       	mov    $0x0,%edx
    div ebx                           ;eax = 3579545 / reload_value, edx = remainder
    b414:	f7 f3                	div    %ebx
    cmp edx,3579545 / 2               ;Is the remainder more than half?
    b416:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    jb .l3                            ; no, round down
    b41c:	72 01                	jb     b41f <calculate_frequency.l3>
    inc eax                           ; yes, round up
    b41e:	40                   	inc    %eax

0000b41f <calculate_frequency.l3>:
 .l3:
    mov ebx,3
    b41f:	bb 03 00 00 00       	mov    $0x3,%ebx
    mov edx,0                         ;edx:eax = 3579545 / reload_value
    b424:	ba 00 00 00 00       	mov    $0x0,%edx
    div ebx                           ;eax = (3579545 / 3) / frequency
    b429:	f7 f3                	div    %ebx
    cmp edx,3 / 2                     ;Is the remainder more than half?
    b42b:	83 fa 01             	cmp    $0x1,%edx
    jb .l4                            ; no, round down
    b42e:	72 01                	jb     b431 <calculate_frequency.l4>
    inc eax                           ; yes, round up
    b430:	40                   	inc    %eax

0000b431 <calculate_frequency.l4>:
 .l4:
    mov [IRQ0_frequency],eax          ;Store the actual frequency for displaying later
    b431:	a3 50 22 02 00       	mov    %eax,0x22250
 ;           time in ms = reload_value * 3000 / 3579545 * (2^42)/(2^42)
 ;           time in ms = reload_value * 3000 * (2^42) / 3579545 / (2^42)
 ;           time in ms * 2^32 = reload_value * 3000 * (2^42) / 3579545 / (2^42) * (2^32)
 ;           time in ms * 2^32 = reload_value * 3000 * (2^42) / 3579545 / (2^10)
 
    pop ebx                           ;ebx = reload_value
    b436:	5b                   	pop    %ebx
    mov eax,0xDBB3A062                ;eax = 3000 * (2^42) / 3579545
    b437:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    mul ebx                           ;edx:eax = reload_value * 3000 * (2^42) / 3579545
    b43c:	f7 e3                	mul    %ebx
    shrd eax,edx,10
    b43e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    shr edx,10                        ;edx:eax = reload_value * 3000 * (2^42) / 3579545 / (2^10)
    b442:	c1 ea 0a             	shr    $0xa,%edx
 
    mov [IRQ0_ms],edx                 ;Set whole ms between IRQs
    b445:	89 15 4c 22 02 00    	mov    %edx,0x2224c
    mov [IRQ0_fractions],eax          ;Set fractions of 1 ms between IRQs
    b44b:	a3 48 22 02 00       	mov    %eax,0x22248
 
    popad
    b450:	61                   	popa   
    ret
    b451:	c3                   	ret    
    b452:	66 90                	xchg   %ax,%ax
    b454:	66 90                	xchg   %ax,%ax
    b456:	66 90                	xchg   %ax,%ax
    b458:	66 90                	xchg   %ax,%ax
    b45a:	66 90                	xchg   %ax,%ax
    b45c:	66 90                	xchg   %ax,%ax
    b45e:	66 90                	xchg   %ax,%ax

0000b460 <switch_to_task>:

section .text

	switch_to_task:
		;save entire task state , so last regs should be field------
		push eax
    b460:	50                   	push   %eax
			mov eax , dword[esp+8]
    b461:	8b 44 24 08          	mov    0x8(%esp),%eax
			mov dword[eax+4] , ebx
    b465:	89 58 04             	mov    %ebx,0x4(%eax)
			mov dword[eax+8] , ecx
    b468:	89 48 08             	mov    %ecx,0x8(%eax)
			mov dword[eax+12], edx
    b46b:	89 50 0c             	mov    %edx,0xc(%eax)
			mov dword[eax+16] , esi
    b46e:	89 70 10             	mov    %esi,0x10(%eax)
			mov dword[eax+20] , edi
    b471:	89 78 14             	mov    %edi,0x14(%eax)
			mov dword[eax+24] , esp
    b474:	89 60 18             	mov    %esp,0x18(%eax)
			mov dword[eax+28] , ebp
    b477:	89 68 1c             	mov    %ebp,0x1c(%eax)
			
			;save eip
			push ecx
    b47a:	51                   	push   %ecx
				mov ecx , dword[esp+8]
    b47b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
				mov dword[eax+32] , ecx
    b47f:	89 48 20             	mov    %ecx,0x20(%eax)
			pop ecx
    b482:	59                   	pop    %ecx

			;save eflags
			push ecx
    b483:	51                   	push   %ecx
				pushfd
    b484:	9c                   	pushf  
				pop ecx
    b485:	59                   	pop    %ecx
				mov dword[eax+36] , ecx
    b486:	89 48 24             	mov    %ecx,0x24(%eax)
			pop ecx
    b489:	59                   	pop    %ecx

			;save cr3
			push ecx
    b48a:	51                   	push   %ecx
				mov ecx , cr3
    b48b:	0f 20 d9             	mov    %cr3,%ecx
				mov dword[eax+40] , ecx
    b48e:	89 48 28             	mov    %ecx,0x28(%eax)
			pop ecx
    b491:	59                   	pop    %ecx


			mov word[eax+44] , es
    b492:	8c 40 2c             	mov    %es,0x2c(%eax)
			mov word[eax+46] , gs
    b495:	8c 68 2e             	mov    %gs,0x2e(%eax)
			mov word[eax+48] , fs
    b498:	8c 60 30             	mov    %fs,0x30(%eax)
			
			;save eax
			push ecx
    b49b:	51                   	push   %ecx
				mov ecx , dword[esp+4]
    b49c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
				mov dword[eax] , ecx
    b4a0:	89 08                	mov    %ecx,(%eax)
			pop ecx
    b4a2:	59                   	pop    %ecx
			


		pop eax
    b4a3:	58                   	pop    %eax
		
		;---------------------------------------------------------

		; load task state ----------------------------------------
		
			mov eax , dword[esp+8]
    b4a4:	8b 44 24 08          	mov    0x8(%esp),%eax
			mov ebx , dword[eax+4]
    b4a8:	8b 58 04             	mov    0x4(%eax),%ebx
			mov ecx , dword[eax+8]
    b4ab:	8b 48 08             	mov    0x8(%eax),%ecx
			mov edx , dword[eax+12]
    b4ae:	8b 50 0c             	mov    0xc(%eax),%edx
			mov esi , dword[eax+16]
    b4b1:	8b 70 10             	mov    0x10(%eax),%esi
			mov edi , dword[eax+20]
    b4b4:	8b 78 14             	mov    0x14(%eax),%edi
			mov esp , dword[eax+24]
    b4b7:	8b 60 18             	mov    0x18(%eax),%esp
			mov ebp , dword[eax+28]
    b4ba:	8b 68 1c             	mov    0x1c(%eax),%ebp

			;load eflags
			push ecx
    b4bd:	51                   	push   %ecx
				mov ecx , dword[eax+36]
    b4be:	8b 48 24             	mov    0x24(%eax),%ecx
				push ecx
    b4c1:	51                   	push   %ecx
				popfd
    b4c2:	9d                   	popf   
			pop ecx
    b4c3:	59                   	pop    %ecx

			;load cr3
			push ecx
    b4c4:	51                   	push   %ecx
				mov ecx , dword[eax+40]
    b4c5:	8b 48 28             	mov    0x28(%eax),%ecx
				mov cr3 , ecx
    b4c8:	0f 22 d9             	mov    %ecx,%cr3
			pop ecx
    b4cb:	59                   	pop    %ecx

			mov es , word[eax+44]
    b4cc:	8e 40 2c             	mov    0x2c(%eax),%es
			mov gs , word[eax+46]
    b4cf:	8e 68 2e             	mov    0x2e(%eax),%gs
			mov fs , word[eax+48]
    b4d2:	8e 60 30             	mov    0x30(%eax),%fs

		mov eax , dword[eax+32]
    b4d5:	8b 40 20             	mov    0x20(%eax),%eax
		mov [esp] , eax
    b4d8:	89 04 24             	mov    %eax,(%esp)
		
		;--------------------------------------------------------
		ret
    b4db:	c3                   	ret    
