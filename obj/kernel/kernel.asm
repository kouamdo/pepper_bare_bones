
bin/kernel.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00009000 <entry_kernel>:
    9000:	bd 00 00 10 00       	mov    $0x100000,%ebp
    9005:	89 ec                	mov    %ebp,%esp
    9007:	81 c4 00 a0 00 00    	add    $0xa000,%esp
    900d:	ea 14 90 00 00 08 00 	ljmp   $0x8,$0x9014

00009014 <main>:
char *       bios_info_begin, *bios_info_end;

void detect_bios_info();

void main()
{
    9014:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    9018:	83 e4 f0             	and    $0xfffffff0,%esp
    901b:	ff 71 fc             	pushl  -0x4(%ecx)
    901e:	55                   	push   %ebp
    901f:	89 e5                	mov    %esp,%ebp
    9021:	51                   	push   %ecx
    9022:	83 ec 04             	sub    $0x4,%esp
    cli;
    9025:	fa                   	cli    

    init_console();
    9026:	e8 65 07 00 00       	call   9790 <init_console>

    detect_bios_info();
    902b:	e8 7f 00 00 00       	call   90af <detect_bios_info>

    init_gdt(); //Init GDT secondly
    9030:	e8 06 08 00 00       	call   983b <init_gdt>

    //Kernel Mapping
    kprintf("Kernel Memory Info: \n\n");
    9035:	83 ec 0c             	sub    $0xc,%esp
    9038:	68 00 f0 00 00       	push   $0xf000
    903d:	e8 1c 1a 00 00       	call   aa5e <kprintf>
    9042:	83 c4 10             	add    $0x10,%esp
    kprintf("Kernel stack base at [%p] length [%d] bytes\n", KSTACKTOP, KSTKSIZE);
    9045:	83 ec 04             	sub    $0x4,%esp
    9048:	68 00 a0 00 00       	push   $0xa000
    904d:	68 00 00 10 00       	push   $0x100000
    9052:	68 18 f0 00 00       	push   $0xf018
    9057:	e8 02 1a 00 00       	call   aa5e <kprintf>
    905c:	83 c4 10             	add    $0x10,%esp
    kprintf("PEPPER_Kernel init at [%p] length [%d] bytes \n", main, &end - (void**)main);
    905f:	b8 01 40 02 00       	mov    $0x24001,%eax
    9064:	2d 14 90 00 00       	sub    $0x9014,%eax
    9069:	c1 f8 02             	sar    $0x2,%eax
    906c:	83 ec 04             	sub    $0x4,%esp
    906f:	50                   	push   %eax
    9070:	68 14 90 00 00       	push   $0x9014
    9075:	68 48 f0 00 00       	push   $0xf048
    907a:	e8 df 19 00 00       	call   aa5e <kprintf>
    907f:	83 c4 10             	add    $0x10,%esp
    kprintf("Firmware variables at [%p] length [%d] bytes \n", bios_info_begin, (int)(bios_info_end) - (int)(bios_info_begin));
    9082:	a1 04 00 01 00       	mov    0x10004,%eax
    9087:	89 c2                	mov    %eax,%edx
    9089:	a1 00 00 01 00       	mov    0x10000,%eax
    908e:	29 c2                	sub    %eax,%edx
    9090:	a1 00 00 01 00       	mov    0x10000,%eax
    9095:	83 ec 04             	sub    $0x4,%esp
    9098:	52                   	push   %edx
    9099:	50                   	push   %eax
    909a:	68 78 f0 00 00       	push   $0xf078
    909f:	e8 ba 19 00 00       	call   aa5e <kprintf>
    90a4:	83 c4 10             	add    $0x10,%esp

    init_idt();
    90a7:	e8 a9 08 00 00       	call   9955 <init_idt>

    sti;
    90ac:	fb                   	sti    

    while (1)
    90ad:	eb fe                	jmp    90ad <main+0x99>

000090af <detect_bios_info>:
        ;
}

//detect BIOS info
void detect_bios_info()
{
    90af:	55                   	push   %ebp
    90b0:	89 e5                	mov    %esp,%ebp
    90b2:	83 ec 10             	sub    $0x10,%esp
    int       i = 0;
    90b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    uint16_t* bios_info;

    bios_info = (int16_t*)(0x7e00);
    90bc:	c7 45 f8 00 7e 00 00 	movl   $0x7e00,-0x8(%ebp)

    while (bios_info[i] != 0xB00B)
    90c3:	eb 04                	jmp    90c9 <detect_bios_info+0x1a>
        i++;
    90c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (bios_info[i] != 0xB00B)
    90c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90cc:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90d2:	01 d0                	add    %edx,%eax
    90d4:	0f b7 00             	movzwl (%eax),%eax
    90d7:	66 3d 0b b0          	cmp    $0xb00b,%ax
    90db:	75 e8                	jne    90c5 <detect_bios_info+0x16>

    bios_info_begin = (char*)(&bios_info[i]);
    90dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90e0:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90e6:	01 d0                	add    %edx,%eax
    90e8:	a3 00 00 01 00       	mov    %eax,0x10000

    bios_info = (uint16_t*)bios_info_begin;
    90ed:	a1 00 00 01 00       	mov    0x10000,%eax
    90f2:	89 45 f8             	mov    %eax,-0x8(%ebp)

    i = 0;
    90f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

    while (bios_info[i] != 0xB00E)
    90fc:	eb 04                	jmp    9102 <detect_bios_info+0x53>
        i++;
    90fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (bios_info[i] != 0xB00E)
    9102:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9105:	8d 14 00             	lea    (%eax,%eax,1),%edx
    9108:	8b 45 f8             	mov    -0x8(%ebp),%eax
    910b:	01 d0                	add    %edx,%eax
    910d:	0f b7 00             	movzwl (%eax),%eax
    9110:	66 3d 0e b0          	cmp    $0xb00e,%ax
    9114:	75 e8                	jne    90fe <detect_bios_info+0x4f>

    bios_info_end = (char*)(&bios_info[i]);
    9116:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9119:	8d 14 00             	lea    (%eax,%eax,1),%edx
    911c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    911f:	01 d0                	add    %edx,%eax
    9121:	a3 04 00 01 00       	mov    %eax,0x10004
    9126:	90                   	nop
    9127:	c9                   	leave  
    9128:	c3                   	ret    

00009129 <putchar>:
 * Print a number (base <= 16) in reverse order,
 */
void puts(const char* string);

void putchar(uint8_t c)
{
    9129:	55                   	push   %ebp
    912a:	89 e5                	mov    %esp,%ebp
    912c:	83 ec 18             	sub    $0x18,%esp
    912f:	8b 45 08             	mov    0x8(%ebp),%eax
    9132:	88 45 f4             	mov    %al,-0xc(%ebp)
    cputchar(READY_COLOR, c);
    9135:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    9139:	0f be c0             	movsbl %al,%eax
    913c:	83 ec 08             	sub    $0x8,%esp
    913f:	50                   	push   %eax
    9140:	6a 07                	push   $0x7
    9142:	e8 b7 04 00 00       	call   95fe <cputchar>
    9147:	83 c4 10             	add    $0x10,%esp
}
    914a:	90                   	nop
    914b:	c9                   	leave  
    914c:	c3                   	ret    

0000914d <printnum>:

static void printnum(uint32_t num, uint8_t base)
{
    914d:	55                   	push   %ebp
    914e:	89 e5                	mov    %esp,%ebp
    9150:	53                   	push   %ebx
    9151:	83 ec 14             	sub    $0x14,%esp
    9154:	8b 45 0c             	mov    0xc(%ebp),%eax
    9157:	88 45 f4             	mov    %al,-0xc(%ebp)
    if (num >= base) printnum((uint32_t)(num / base), base);
    915a:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    915e:	39 45 08             	cmp    %eax,0x8(%ebp)
    9161:	72 1f                	jb     9182 <printnum+0x35>
    9163:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    9167:	0f b6 5d f4          	movzbl -0xc(%ebp),%ebx
    916b:	8b 45 08             	mov    0x8(%ebp),%eax
    916e:	ba 00 00 00 00       	mov    $0x0,%edx
    9173:	f7 f3                	div    %ebx
    9175:	83 ec 08             	sub    $0x8,%esp
    9178:	51                   	push   %ecx
    9179:	50                   	push   %eax
    917a:	e8 ce ff ff ff       	call   914d <printnum>
    917f:	83 c4 10             	add    $0x10,%esp

    putchar("0123456789abcdef"[num % base]);
    9182:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    9186:	8b 45 08             	mov    0x8(%ebp),%eax
    9189:	ba 00 00 00 00       	mov    $0x0,%edx
    918e:	f7 f1                	div    %ecx
    9190:	89 d0                	mov    %edx,%eax
    9192:	0f b6 80 a8 f0 00 00 	movzbl 0xf0a8(%eax),%eax
    9199:	0f b6 c0             	movzbl %al,%eax
    919c:	83 ec 0c             	sub    $0xc,%esp
    919f:	50                   	push   %eax
    91a0:	e8 84 ff ff ff       	call   9129 <putchar>
    91a5:	83 c4 10             	add    $0x10,%esp
}
    91a8:	90                   	nop
    91a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    91ac:	c9                   	leave  
    91ad:	c3                   	ret    

000091ae <printf>:

void printf(const char* fmt, va_list arg)
{
    91ae:	55                   	push   %ebp
    91af:	89 e5                	mov    %esp,%ebp
    91b1:	83 ec 18             	sub    $0x18,%esp
    char*    s;
    int*     p;

    const char* chr_tmp;

    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    91b4:	8b 45 08             	mov    0x8(%ebp),%eax
    91b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    91ba:	e9 53 01 00 00       	jmp    9312 <printf+0x164>

        if (*chr_tmp == '%') {
    91bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91c2:	0f b6 00             	movzbl (%eax),%eax
    91c5:	3c 25                	cmp    $0x25,%al
    91c7:	0f 85 29 01 00 00    	jne    92f6 <printf+0x148>
            chr_tmp++;
    91cd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            switch (*chr_tmp) {
    91d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91d4:	0f b6 00             	movzbl (%eax),%eax
    91d7:	0f be c0             	movsbl %al,%eax
    91da:	83 e8 62             	sub    $0x62,%eax
    91dd:	83 f8 16             	cmp    $0x16,%eax
    91e0:	0f 87 27 01 00 00    	ja     930d <printf+0x15f>
    91e6:	8b 04 85 bc f0 00 00 	mov    0xf0bc(,%eax,4),%eax
    91ed:	ff e0                	jmp    *%eax
            case 'c':
                i = va_arg(arg, int32_t);
    91ef:	8b 45 0c             	mov    0xc(%ebp),%eax
    91f2:	8d 50 04             	lea    0x4(%eax),%edx
    91f5:	89 55 0c             	mov    %edx,0xc(%ebp)
    91f8:	8b 00                	mov    (%eax),%eax
    91fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
                putchar(i);
    91fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9200:	0f b6 c0             	movzbl %al,%eax
    9203:	83 ec 0c             	sub    $0xc,%esp
    9206:	50                   	push   %eax
    9207:	e8 1d ff ff ff       	call   9129 <putchar>
    920c:	83 c4 10             	add    $0x10,%esp
                break;
    920f:	e9 fa 00 00 00       	jmp    930e <printf+0x160>
            case 'd':
                i = va_arg(arg, int);
    9214:	8b 45 0c             	mov    0xc(%ebp),%eax
    9217:	8d 50 04             	lea    0x4(%eax),%edx
    921a:	89 55 0c             	mov    %edx,0xc(%ebp)
    921d:	8b 00                	mov    (%eax),%eax
    921f:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 10);
    9222:	83 ec 08             	sub    $0x8,%esp
    9225:	6a 0a                	push   $0xa
    9227:	ff 75 f0             	pushl  -0x10(%ebp)
    922a:	e8 1e ff ff ff       	call   914d <printnum>
    922f:	83 c4 10             	add    $0x10,%esp
                break;
    9232:	e9 d7 00 00 00       	jmp    930e <printf+0x160>
            case 'o':
                i = va_arg(arg, int32_t);
    9237:	8b 45 0c             	mov    0xc(%ebp),%eax
    923a:	8d 50 04             	lea    0x4(%eax),%edx
    923d:	89 55 0c             	mov    %edx,0xc(%ebp)
    9240:	8b 00                	mov    (%eax),%eax
    9242:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 8);
    9245:	83 ec 08             	sub    $0x8,%esp
    9248:	6a 08                	push   $0x8
    924a:	ff 75 f0             	pushl  -0x10(%ebp)
    924d:	e8 fb fe ff ff       	call   914d <printnum>
    9252:	83 c4 10             	add    $0x10,%esp
                break;
    9255:	e9 b4 00 00 00       	jmp    930e <printf+0x160>
            case 'b':
                i = va_arg(arg, int32_t);
    925a:	8b 45 0c             	mov    0xc(%ebp),%eax
    925d:	8d 50 04             	lea    0x4(%eax),%edx
    9260:	89 55 0c             	mov    %edx,0xc(%ebp)
    9263:	8b 00                	mov    (%eax),%eax
    9265:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 2);
    9268:	83 ec 08             	sub    $0x8,%esp
    926b:	6a 02                	push   $0x2
    926d:	ff 75 f0             	pushl  -0x10(%ebp)
    9270:	e8 d8 fe ff ff       	call   914d <printnum>
    9275:	83 c4 10             	add    $0x10,%esp
                break;
    9278:	e9 91 00 00 00       	jmp    930e <printf+0x160>
            case 'x':
                i = va_arg(arg, int32_t);
    927d:	8b 45 0c             	mov    0xc(%ebp),%eax
    9280:	8d 50 04             	lea    0x4(%eax),%edx
    9283:	89 55 0c             	mov    %edx,0xc(%ebp)
    9286:	8b 00                	mov    (%eax),%eax
    9288:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 16);
    928b:	83 ec 08             	sub    $0x8,%esp
    928e:	6a 10                	push   $0x10
    9290:	ff 75 f0             	pushl  -0x10(%ebp)
    9293:	e8 b5 fe ff ff       	call   914d <printnum>
    9298:	83 c4 10             	add    $0x10,%esp
                break;
    929b:	eb 71                	jmp    930e <printf+0x160>
            case 's':
                s = va_arg(arg, char*);
    929d:	8b 45 0c             	mov    0xc(%ebp),%eax
    92a0:	8d 50 04             	lea    0x4(%eax),%edx
    92a3:	89 55 0c             	mov    %edx,0xc(%ebp)
    92a6:	8b 00                	mov    (%eax),%eax
    92a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
                puts(s);
    92ab:	83 ec 0c             	sub    $0xc,%esp
    92ae:	ff 75 ec             	pushl  -0x14(%ebp)
    92b1:	e8 6e 00 00 00       	call   9324 <puts>
    92b6:	83 c4 10             	add    $0x10,%esp
                break;
    92b9:	eb 53                	jmp    930e <printf+0x160>
            case 'p':
                p = va_arg(arg, void*);
    92bb:	8b 45 0c             	mov    0xc(%ebp),%eax
    92be:	8d 50 04             	lea    0x4(%eax),%edx
    92c1:	89 55 0c             	mov    %edx,0xc(%ebp)
    92c4:	8b 00                	mov    (%eax),%eax
    92c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
                putchar('0');
    92c9:	83 ec 0c             	sub    $0xc,%esp
    92cc:	6a 30                	push   $0x30
    92ce:	e8 56 fe ff ff       	call   9129 <putchar>
    92d3:	83 c4 10             	add    $0x10,%esp
                putchar('x');
    92d6:	83 ec 0c             	sub    $0xc,%esp
    92d9:	6a 78                	push   $0x78
    92db:	e8 49 fe ff ff       	call   9129 <putchar>
    92e0:	83 c4 10             	add    $0x10,%esp
                printnum((uint32_t)p, 16);
    92e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    92e6:	83 ec 08             	sub    $0x8,%esp
    92e9:	6a 10                	push   $0x10
    92eb:	50                   	push   %eax
    92ec:	e8 5c fe ff ff       	call   914d <printnum>
    92f1:	83 c4 10             	add    $0x10,%esp
                break;
    92f4:	eb 18                	jmp    930e <printf+0x160>
                break;
            }
        }

        else
            putchar(*chr_tmp);
    92f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    92f9:	0f b6 00             	movzbl (%eax),%eax
    92fc:	0f b6 c0             	movzbl %al,%eax
    92ff:	83 ec 0c             	sub    $0xc,%esp
    9302:	50                   	push   %eax
    9303:	e8 21 fe ff ff       	call   9129 <putchar>
    9308:	83 c4 10             	add    $0x10,%esp
    930b:	eb 01                	jmp    930e <printf+0x160>
                break;
    930d:	90                   	nop
    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    930e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9312:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9315:	0f b6 00             	movzbl (%eax),%eax
    9318:	84 c0                	test   %al,%al
    931a:	0f 85 9f fe ff ff    	jne    91bf <printf+0x11>
    }

    va_end(arg);
}
    9320:	90                   	nop
    9321:	90                   	nop
    9322:	c9                   	leave  
    9323:	c3                   	ret    

00009324 <puts>:

void puts(const char* string)
{
    9324:	55                   	push   %ebp
    9325:	89 e5                	mov    %esp,%ebp
    9327:	83 ec 08             	sub    $0x8,%esp
    if (*string != '\0') {
    932a:	8b 45 08             	mov    0x8(%ebp),%eax
    932d:	0f b6 00             	movzbl (%eax),%eax
    9330:	84 c0                	test   %al,%al
    9332:	74 2a                	je     935e <puts+0x3a>
        putchar(*string);
    9334:	8b 45 08             	mov    0x8(%ebp),%eax
    9337:	0f b6 00             	movzbl (%eax),%eax
    933a:	0f b6 c0             	movzbl %al,%eax
    933d:	83 ec 0c             	sub    $0xc,%esp
    9340:	50                   	push   %eax
    9341:	e8 e3 fd ff ff       	call   9129 <putchar>
    9346:	83 c4 10             	add    $0x10,%esp
        puts(string++);
    9349:	8b 45 08             	mov    0x8(%ebp),%eax
    934c:	8d 50 01             	lea    0x1(%eax),%edx
    934f:	89 55 08             	mov    %edx,0x8(%ebp)
    9352:	83 ec 0c             	sub    $0xc,%esp
    9355:	50                   	push   %eax
    9356:	e8 c9 ff ff ff       	call   9324 <puts>
    935b:	83 c4 10             	add    $0x10,%esp
    }
    935e:	90                   	nop
    935f:	c9                   	leave  
    9360:	c3                   	ret    

00009361 <_strcmp_>:
#include "../../include/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    9361:	55                   	push   %ebp
    9362:	89 e5                	mov    %esp,%ebp
    9364:	53                   	push   %ebx
    9365:	83 ec 04             	sub    $0x4,%esp
    if (_strlen_(str2) != _strlen_(str1))
    9368:	83 ec 0c             	sub    $0xc,%esp
    936b:	ff 75 0c             	pushl  0xc(%ebp)
    936e:	e8 59 00 00 00       	call   93cc <_strlen_>
    9373:	83 c4 10             	add    $0x10,%esp
    9376:	89 c3                	mov    %eax,%ebx
    9378:	83 ec 0c             	sub    $0xc,%esp
    937b:	ff 75 08             	pushl  0x8(%ebp)
    937e:	e8 49 00 00 00       	call   93cc <_strlen_>
    9383:	83 c4 10             	add    $0x10,%esp
    9386:	38 c3                	cmp    %al,%bl
    9388:	74 0f                	je     9399 <_strcmp_+0x38>
        return 0;
    938a:	b8 00 00 00 00       	mov    $0x0,%eax
    938f:	eb 36                	jmp    93c7 <_strcmp_+0x66>

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
    9391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        str2++;
    9395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while ((*str1 == *str2) && (*str1 != '\000')) {
    9399:	8b 45 08             	mov    0x8(%ebp),%eax
    939c:	0f b6 10             	movzbl (%eax),%edx
    939f:	8b 45 0c             	mov    0xc(%ebp),%eax
    93a2:	0f b6 00             	movzbl (%eax),%eax
    93a5:	38 c2                	cmp    %al,%dl
    93a7:	75 0a                	jne    93b3 <_strcmp_+0x52>
    93a9:	8b 45 08             	mov    0x8(%ebp),%eax
    93ac:	0f b6 00             	movzbl (%eax),%eax
    93af:	84 c0                	test   %al,%al
    93b1:	75 de                	jne    9391 <_strcmp_+0x30>
    }

    return *str1 == *str2;
    93b3:	8b 45 08             	mov    0x8(%ebp),%eax
    93b6:	0f b6 10             	movzbl (%eax),%edx
    93b9:	8b 45 0c             	mov    0xc(%ebp),%eax
    93bc:	0f b6 00             	movzbl (%eax),%eax
    93bf:	38 c2                	cmp    %al,%dl
    93c1:	0f 94 c0             	sete   %al
    93c4:	0f b6 c0             	movzbl %al,%eax
}
    93c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    93ca:	c9                   	leave  
    93cb:	c3                   	ret    

000093cc <_strlen_>:

uint8_t _strlen_(char* str)
{
    93cc:	55                   	push   %ebp
    93cd:	89 e5                	mov    %esp,%ebp
    93cf:	83 ec 10             	sub    $0x10,%esp
    if (*str == '\000')
    93d2:	8b 45 08             	mov    0x8(%ebp),%eax
    93d5:	0f b6 00             	movzbl (%eax),%eax
    93d8:	84 c0                	test   %al,%al
    93da:	75 07                	jne    93e3 <_strlen_+0x17>
        return 0;
    93dc:	b8 00 00 00 00       	mov    $0x0,%eax
    93e1:	eb 22                	jmp    9405 <_strlen_+0x39>

    uint8_t i = 1;
    93e3:	c6 45 ff 01          	movb   $0x1,-0x1(%ebp)

    while (*str != '\000') {
    93e7:	eb 0e                	jmp    93f7 <_strlen_+0x2b>
        str++;
    93e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        i++;
    93ed:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    93f1:	83 c0 01             	add    $0x1,%eax
    93f4:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (*str != '\000') {
    93f7:	8b 45 08             	mov    0x8(%ebp),%eax
    93fa:	0f b6 00             	movzbl (%eax),%eax
    93fd:	84 c0                	test   %al,%al
    93ff:	75 e8                	jne    93e9 <_strlen_+0x1d>
    }

    return i;
    9401:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
    9405:	c9                   	leave  
    9406:	c3                   	ret    

00009407 <_strcpy_>:

void* _strcpy_(char* dest, char* src)
{
    9407:	55                   	push   %ebp
    9408:	89 e5                	mov    %esp,%ebp
    940a:	83 ec 10             	sub    $0x10,%esp
    if (dest == NULL)
    940d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    9411:	75 07                	jne    941a <_strcpy_+0x13>
        return (void*)NULL;
    9413:	b8 00 00 00 00       	mov    $0x0,%eax
    9418:	eb 46                	jmp    9460 <_strcpy_+0x59>

    uint8_t i = 0;
    941a:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    while (src[i] != '\000') {
    941e:	eb 21                	jmp    9441 <_strcpy_+0x3a>
        dest[i] = src[i];
    9420:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9424:	8b 45 0c             	mov    0xc(%ebp),%eax
    9427:	01 d0                	add    %edx,%eax
    9429:	0f b6 4d ff          	movzbl -0x1(%ebp),%ecx
    942d:	8b 55 08             	mov    0x8(%ebp),%edx
    9430:	01 ca                	add    %ecx,%edx
    9432:	0f b6 00             	movzbl (%eax),%eax
    9435:	88 02                	mov    %al,(%edx)
        i++;
    9437:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    943b:	83 c0 01             	add    $0x1,%eax
    943e:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (src[i] != '\000') {
    9441:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9445:	8b 45 0c             	mov    0xc(%ebp),%eax
    9448:	01 d0                	add    %edx,%eax
    944a:	0f b6 00             	movzbl (%eax),%eax
    944d:	84 c0                	test   %al,%al
    944f:	75 cf                	jne    9420 <_strcpy_+0x19>
    }

    dest[i] = '\000';
    9451:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9455:	8b 45 08             	mov    0x8(%ebp),%eax
    9458:	01 d0                	add    %edx,%eax
    945a:	c6 00 00             	movb   $0x0,(%eax)

    return (void*)dest;
    945d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9460:	c9                   	leave  
    9461:	c3                   	ret    

00009462 <memcpy>:

void* memcpy(void* dest, const void* src, uint32_t size)
{
    9462:	55                   	push   %ebp
    9463:	89 e5                	mov    %esp,%ebp
    9465:	83 ec 10             	sub    $0x10,%esp
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    9468:	8b 45 08             	mov    0x8(%ebp),%eax
    946b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    _src_  = (char*)src;
    946e:	8b 45 0c             	mov    0xc(%ebp),%eax
    9471:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (size) {
    9474:	eb 1b                	jmp    9491 <memcpy+0x2f>
        *(_dest_++) = *(_src_++);
    9476:	8b 55 f8             	mov    -0x8(%ebp),%edx
    9479:	8d 42 01             	lea    0x1(%edx),%eax
    947c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    947f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9482:	8d 48 01             	lea    0x1(%eax),%ecx
    9485:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    9488:	0f b6 12             	movzbl (%edx),%edx
    948b:	88 10                	mov    %dl,(%eax)
        size--;
    948d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (size) {
    9491:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    9495:	75 df                	jne    9476 <memcpy+0x14>
    }

    return (void*)dest;
    9497:	8b 45 08             	mov    0x8(%ebp),%eax
}
    949a:	c9                   	leave  
    949b:	c3                   	ret    

0000949c <memset>:

void* memset(void* mem, int8_t data, int size)
{
    949c:	55                   	push   %ebp
    949d:	89 e5                	mov    %esp,%ebp
    949f:	83 ec 14             	sub    $0x14,%esp
    94a2:	8b 45 0c             	mov    0xc(%ebp),%eax
    94a5:	88 45 ec             	mov    %al,-0x14(%ebp)
    int i = 0;
    94a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

    int8_t* tmp = mem;
    94af:	8b 45 08             	mov    0x8(%ebp),%eax
    94b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

    for (i; i < size; i++)
    94b5:	eb 12                	jmp    94c9 <memset+0x2d>
        tmp[i] = data;
    94b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    94ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
    94bd:	01 c2                	add    %eax,%edx
    94bf:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    94c3:	88 02                	mov    %al,(%edx)
    for (i; i < size; i++)
    94c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    94c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    94cc:	3b 45 10             	cmp    0x10(%ebp),%eax
    94cf:	7c e6                	jl     94b7 <memset+0x1b>

    return (void*)mem;
    94d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    94d4:	c9                   	leave  
    94d5:	c3                   	ret    

000094d6 <_memcmp_>:

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    94d6:	55                   	push   %ebp
    94d7:	89 e5                	mov    %esp,%ebp
    94d9:	83 ec 10             	sub    $0x10,%esp
    char* mem_1 = (char*)src_1;
    94dc:	8b 45 08             	mov    0x8(%ebp),%eax
    94df:	89 45 fc             	mov    %eax,-0x4(%ebp)

    char* mem_2 = (char*)src_2;
    94e2:	8b 45 0c             	mov    0xc(%ebp),%eax
    94e5:	89 45 f8             	mov    %eax,-0x8(%ebp)

    uint32_t i = 0;
    94e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (i < size && *mem_1 == *mem_2) {
    94ef:	eb 0c                	jmp    94fd <_memcmp_+0x27>
        i++;
    94f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        mem_1++;
    94f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
        mem_2++;
    94f9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (i < size && *mem_1 == *mem_2) {
    94fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9500:	3b 45 10             	cmp    0x10(%ebp),%eax
    9503:	73 10                	jae    9515 <_memcmp_+0x3f>
    9505:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9508:	0f b6 10             	movzbl (%eax),%edx
    950b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    950e:	0f b6 00             	movzbl (%eax),%eax
    9511:	38 c2                	cmp    %al,%dl
    9513:	74 dc                	je     94f1 <_memcmp_+0x1b>
    }

    return i == size;
    9515:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9518:	3b 45 10             	cmp    0x10(%ebp),%eax
    951b:	0f 94 c0             	sete   %al
    951e:	0f b6 c0             	movzbl %al,%eax
    9521:	c9                   	leave  
    9522:	c3                   	ret    

00009523 <cclean>:

void move_cursor(uint8_t x, uint8_t y);
void show_cursor(void);

void volatile cclean()
{
    9523:	55                   	push   %ebp
    9524:	89 e5                	mov    %esp,%ebp
    9526:	83 ec 10             	sub    $0x10,%esp
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    9529:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
    int            i      = 0;
    9530:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (i <= 160 * 25) {
    9537:	eb 1d                	jmp    9556 <cclean+0x33>
        screen[i]     = ' ';
    9539:	8b 55 fc             	mov    -0x4(%ebp),%edx
    953c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    953f:	01 d0                	add    %edx,%eax
    9541:	c6 00 20             	movb   $0x20,(%eax)
        screen[i + 1] = 0x0;
    9544:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9547:	8d 50 01             	lea    0x1(%eax),%edx
    954a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    954d:	01 d0                	add    %edx,%eax
    954f:	c6 00 00             	movb   $0x0,(%eax)
        i += 2;
    9552:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    while (i <= 160 * 25) {
    9556:	81 7d fc a0 0f 00 00 	cmpl   $0xfa0,-0x4(%ebp)
    955d:	7e da                	jle    9539 <cclean+0x16>
    }

    CURSOR_X = 0;
    955f:	c7 05 0c 00 01 00 00 	movl   $0x0,0x1000c
    9566:	00 00 00 
    CURSOR_Y = 0;
    9569:	c7 05 08 00 01 00 00 	movl   $0x0,0x10008
    9570:	00 00 00 
}
    9573:	90                   	nop
    9574:	c9                   	leave  
    9575:	c3                   	ret    

00009576 <cscrollup>:

void volatile cscrollup()
{
    9576:	55                   	push   %ebp
    9577:	89 e5                	mov    %esp,%ebp
    9579:	81 ec b0 00 00 00    	sub    $0xb0,%esp
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    957f:	c7 45 f8 00 8f 0b 00 	movl   $0xb8f00,-0x8(%ebp)
    unsigned char  b[160];
    int            i;
    for (i = 0; i < 160; i++)
    9586:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    958d:	eb 1c                	jmp    95ab <cscrollup+0x35>
        b[i] = v[i];
    958f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    9592:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9595:	01 d0                	add    %edx,%eax
    9597:	0f b6 00             	movzbl (%eax),%eax
    959a:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    95a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
    95a3:	01 ca                	add    %ecx,%edx
    95a5:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    95a7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    95ab:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    95b2:	7e db                	jle    958f <cscrollup+0x19>

    cclean();
    95b4:	e8 6a ff ff ff       	call   9523 <cclean>

    v = (unsigned char*)(VIDEO_MEM);
    95b9:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)

    for (i = 0; i < 160; i++)
    95c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    95c7:	eb 1c                	jmp    95e5 <cscrollup+0x6f>
        v[i] = b[i];
    95c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
    95cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    95cf:	01 c2                	add    %eax,%edx
    95d1:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    95d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    95da:	01 c8                	add    %ecx,%eax
    95dc:	0f b6 00             	movzbl (%eax),%eax
    95df:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    95e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    95e5:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    95ec:	7e db                	jle    95c9 <cscrollup+0x53>

    CURSOR_Y++;
    95ee:	a1 08 00 01 00       	mov    0x10008,%eax
    95f3:	83 c0 01             	add    $0x1,%eax
    95f6:	a3 08 00 01 00       	mov    %eax,0x10008
}
    95fb:	90                   	nop
    95fc:	c9                   	leave  
    95fd:	c3                   	ret    

000095fe <cputchar>:

void volatile cputchar(char color, const char c)
{
    95fe:	55                   	push   %ebp
    95ff:	89 e5                	mov    %esp,%ebp
    9601:	83 ec 18             	sub    $0x18,%esp
    9604:	8b 55 08             	mov    0x8(%ebp),%edx
    9607:	8b 45 0c             	mov    0xc(%ebp),%eax
    960a:	88 55 ec             	mov    %dl,-0x14(%ebp)
    960d:	88 45 e8             	mov    %al,-0x18(%ebp)

    if ((CURSOR_Y) <= (25)) {
    9610:	a1 08 00 01 00       	mov    0x10008,%eax
    9615:	83 f8 19             	cmp    $0x19,%eax
    9618:	0f 8f c0 00 00 00    	jg     96de <cputchar+0xe0>
        if (c == '\n') {
    961e:	80 7d e8 0a          	cmpb   $0xa,-0x18(%ebp)
    9622:	75 1c                	jne    9640 <cputchar+0x42>
            CURSOR_X = 0;
    9624:	c7 05 0c 00 01 00 00 	movl   $0x0,0x1000c
    962b:	00 00 00 
            CURSOR_Y++;
    962e:	a1 08 00 01 00       	mov    0x10008,%eax
    9633:	83 c0 01             	add    $0x1,%eax
    9636:	a3 08 00 01 00       	mov    %eax,0x10008
        }
    }

    else
        cclean();
}
    963b:	e9 a3 00 00 00       	jmp    96e3 <cputchar+0xe5>
        else if (c == '\t')
    9640:	80 7d e8 09          	cmpb   $0x9,-0x18(%ebp)
    9644:	75 12                	jne    9658 <cputchar+0x5a>
            CURSOR_X += 5;
    9646:	a1 0c 00 01 00       	mov    0x1000c,%eax
    964b:	83 c0 05             	add    $0x5,%eax
    964e:	a3 0c 00 01 00       	mov    %eax,0x1000c
}
    9653:	e9 8b 00 00 00       	jmp    96e3 <cputchar+0xe5>
        else if (c == 0x08)
    9658:	80 7d e8 08          	cmpb   $0x8,-0x18(%ebp)
    965c:	75 3a                	jne    9698 <cputchar+0x9a>
            CURSOR_X--;
    965e:	a1 0c 00 01 00       	mov    0x1000c,%eax
    9663:	83 e8 01             	sub    $0x1,%eax
    9666:	a3 0c 00 01 00       	mov    %eax,0x1000c
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    966b:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    9672:	8b 15 08 00 01 00    	mov    0x10008,%edx
    9678:	89 d0                	mov    %edx,%eax
    967a:	c1 e0 02             	shl    $0x2,%eax
    967d:	01 d0                	add    %edx,%eax
    967f:	c1 e0 04             	shl    $0x4,%eax
    9682:	89 c2                	mov    %eax,%edx
    9684:	a1 0c 00 01 00       	mov    0x1000c,%eax
    9689:	01 d0                	add    %edx,%eax
    968b:	01 c0                	add    %eax,%eax
    968d:	01 45 f8             	add    %eax,-0x8(%ebp)
            *v = ' ';
    9690:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9693:	c6 00 20             	movb   $0x20,(%eax)
}
    9696:	eb 4b                	jmp    96e3 <cputchar+0xe5>
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9698:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    969f:	8b 15 08 00 01 00    	mov    0x10008,%edx
    96a5:	89 d0                	mov    %edx,%eax
    96a7:	c1 e0 02             	shl    $0x2,%eax
    96aa:	01 d0                	add    %edx,%eax
    96ac:	c1 e0 04             	shl    $0x4,%eax
    96af:	89 c2                	mov    %eax,%edx
    96b1:	a1 0c 00 01 00       	mov    0x1000c,%eax
    96b6:	01 d0                	add    %edx,%eax
    96b8:	01 c0                	add    %eax,%eax
    96ba:	01 45 fc             	add    %eax,-0x4(%ebp)
            *v = c;
    96bd:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    96c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    96c4:	88 10                	mov    %dl,(%eax)
            *(v + 1) = READY_COLOR;
    96c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    96c9:	83 c0 01             	add    $0x1,%eax
    96cc:	c6 00 07             	movb   $0x7,(%eax)
            CURSOR_X++;
    96cf:	a1 0c 00 01 00       	mov    0x1000c,%eax
    96d4:	83 c0 01             	add    $0x1,%eax
    96d7:	a3 0c 00 01 00       	mov    %eax,0x1000c
}
    96dc:	eb 05                	jmp    96e3 <cputchar+0xe5>
        cclean();
    96de:	e8 40 fe ff ff       	call   9523 <cclean>
}
    96e3:	90                   	nop
    96e4:	c9                   	leave  
    96e5:	c3                   	ret    

000096e6 <move_cursor>:

void move_cursor(uint8_t x, uint8_t y)
{
    96e6:	55                   	push   %ebp
    96e7:	89 e5                	mov    %esp,%ebp
    96e9:	83 ec 18             	sub    $0x18,%esp
    96ec:	8b 55 08             	mov    0x8(%ebp),%edx
    96ef:	8b 45 0c             	mov    0xc(%ebp),%eax
    96f2:	88 55 ec             	mov    %dl,-0x14(%ebp)
    96f5:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t c_pos;

    c_pos = y * 80 + x;
    96f8:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    96fc:	89 d0                	mov    %edx,%eax
    96fe:	c1 e0 02             	shl    $0x2,%eax
    9701:	01 d0                	add    %edx,%eax
    9703:	c1 e0 04             	shl    $0x4,%eax
    9706:	89 c2                	mov    %eax,%edx
    9708:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    970c:	01 d0                	add    %edx,%eax
    970e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    outb(0x3d4, 0x0f);
    9712:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9717:	b8 0f 00 00 00       	mov    $0xf,%eax
    971c:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)c_pos);
    971d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    9721:	ba d5 03 00 00       	mov    $0x3d5,%edx
    9726:	ee                   	out    %al,(%dx)
    outb(0x3d4, 0x0e);
    9727:	ba d4 03 00 00       	mov    $0x3d4,%edx
    972c:	b8 0e 00 00 00       	mov    $0xe,%eax
    9731:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)(c_pos >> 8));
    9732:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    9736:	66 c1 e8 08          	shr    $0x8,%ax
    973a:	ba d5 03 00 00       	mov    $0x3d5,%edx
    973f:	ee                   	out    %al,(%dx)
}
    9740:	90                   	nop
    9741:	c9                   	leave  
    9742:	c3                   	ret    

00009743 <show_cursor>:

void show_cursor(void)
{
    9743:	55                   	push   %ebp
    9744:	89 e5                	mov    %esp,%ebp
    move_cursor(CURSOR_X, CURSOR_Y);
    9746:	a1 08 00 01 00       	mov    0x10008,%eax
    974b:	0f b6 d0             	movzbl %al,%edx
    974e:	a1 0c 00 01 00       	mov    0x1000c,%eax
    9753:	0f b6 c0             	movzbl %al,%eax
    9756:	52                   	push   %edx
    9757:	50                   	push   %eax
    9758:	e8 89 ff ff ff       	call   96e6 <move_cursor>
    975d:	83 c4 08             	add    $0x8,%esp
}
    9760:	90                   	nop
    9761:	c9                   	leave  
    9762:	c3                   	ret    

00009763 <console_service_keyboard>:

void console_service_keyboard()
{
    9763:	55                   	push   %ebp
    9764:	89 e5                	mov    %esp,%ebp
    9766:	83 ec 08             	sub    $0x8,%esp
    if (get_ASCII_code_keyboard() != 0) {
    9769:	e8 ff 0a 00 00       	call   a26d <get_ASCII_code_keyboard>
    976e:	84 c0                	test   %al,%al
    9770:	74 1b                	je     978d <console_service_keyboard+0x2a>
        cputchar(READY_COLOR, get_ASCII_code_keyboard());
    9772:	e8 f6 0a 00 00       	call   a26d <get_ASCII_code_keyboard>
    9777:	0f be c0             	movsbl %al,%eax
    977a:	83 ec 08             	sub    $0x8,%esp
    977d:	50                   	push   %eax
    977e:	6a 07                	push   $0x7
    9780:	e8 79 fe ff ff       	call   95fe <cputchar>
    9785:	83 c4 10             	add    $0x10,%esp
        show_cursor();
    9788:	e8 b6 ff ff ff       	call   9743 <show_cursor>
    }
}
    978d:	90                   	nop
    978e:	c9                   	leave  
    978f:	c3                   	ret    

00009790 <init_console>:

void init_console()
{
    9790:	55                   	push   %ebp
    9791:	89 e5                	mov    %esp,%ebp
    9793:	83 ec 08             	sub    $0x8,%esp
    cclean();
    9796:	e8 88 fd ff ff       	call   9523 <cclean>
    kbd_init(); //Init keyboard
    979b:	e8 b0 08 00 00       	call   a050 <kbd_init>
    //init Video graphics here
    97a0:	90                   	nop
    97a1:	c9                   	leave  
    97a2:	c3                   	ret    

000097a3 <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    97a3:	55                   	push   %ebp
    97a4:	89 e5                	mov    %esp,%ebp
    97a6:	90                   	nop
    97a7:	5d                   	pop    %ebp
    97a8:	c3                   	ret    

000097a9 <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    97a9:	55                   	push   %ebp
    97aa:	89 e5                	mov    %esp,%ebp
    97ac:	90                   	nop
    97ad:	5d                   	pop    %ebp
    97ae:	c3                   	ret    

000097af <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    97af:	55                   	push   %ebp
    97b0:	89 e5                	mov    %esp,%ebp
    97b2:	83 ec 08             	sub    $0x8,%esp
    97b5:	8b 55 10             	mov    0x10(%ebp),%edx
    97b8:	8b 45 14             	mov    0x14(%ebp),%eax
    97bb:	88 55 fc             	mov    %dl,-0x4(%ebp)
    97be:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15  = (limite & 0xFFFF);
    97c1:	8b 45 0c             	mov    0xc(%ebp),%eax
    97c4:	89 c2                	mov    %eax,%edx
    97c6:	8b 45 18             	mov    0x18(%ebp),%eax
    97c9:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    97cc:	8b 45 0c             	mov    0xc(%ebp),%eax
    97cf:	c1 e8 10             	shr    $0x10,%eax
    97d2:	83 e0 0f             	and    $0xf,%eax
    97d5:	8b 55 18             	mov    0x18(%ebp),%edx
    97d8:	83 e0 0f             	and    $0xf,%eax
    97db:	89 c1                	mov    %eax,%ecx
    97dd:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    97e1:	83 e0 f0             	and    $0xfffffff0,%eax
    97e4:	09 c8                	or     %ecx,%eax
    97e6:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15  = (base & 0xFFFF);
    97e9:	8b 45 08             	mov    0x8(%ebp),%eax
    97ec:	89 c2                	mov    %eax,%edx
    97ee:	8b 45 18             	mov    0x18(%ebp),%eax
    97f1:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    97f5:	8b 45 08             	mov    0x8(%ebp),%eax
    97f8:	c1 e8 10             	shr    $0x10,%eax
    97fb:	89 c2                	mov    %eax,%edx
    97fd:	8b 45 18             	mov    0x18(%ebp),%eax
    9800:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    9803:	8b 45 08             	mov    0x8(%ebp),%eax
    9806:	c1 e8 18             	shr    $0x18,%eax
    9809:	89 c2                	mov    %eax,%edx
    980b:	8b 45 18             	mov    0x18(%ebp),%eax
    980e:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags      = flags;
    9811:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    9815:	83 e0 0f             	and    $0xf,%eax
    9818:	89 c2                	mov    %eax,%edx
    981a:	8b 45 18             	mov    0x18(%ebp),%eax
    981d:	89 d1                	mov    %edx,%ecx
    981f:	c1 e1 04             	shl    $0x4,%ecx
    9822:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    9826:	83 e2 0f             	and    $0xf,%edx
    9829:	09 ca                	or     %ecx,%edx
    982b:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    982e:	8b 45 18             	mov    0x18(%ebp),%eax
    9831:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    9835:	88 50 05             	mov    %dl,0x5(%eax)
}
    9838:	90                   	nop
    9839:	c9                   	leave  
    983a:	c3                   	ret    

0000983b <init_gdt>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt(void)
{
    983b:	55                   	push   %ebp
    983c:	89 e5                	mov    %esp,%ebp
    983e:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    9841:	a1 10 00 01 00       	mov    0x10010,%eax
    9846:	50                   	push   %eax
    9847:	6a 00                	push   $0x0
    9849:	6a 00                	push   $0x0
    984b:	6a 00                	push   $0x0
    984d:	6a 00                	push   $0x0
    984f:	e8 5b ff ff ff       	call   97af <init_gdt_entry>
    9854:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    9857:	a1 10 00 01 00       	mov    0x10010,%eax
    985c:	83 c0 08             	add    $0x8,%eax
    985f:	50                   	push   %eax
    9860:	6a 04                	push   $0x4
    9862:	68 9a 00 00 00       	push   $0x9a
    9867:	68 ff ff 0f 00       	push   $0xfffff
    986c:	6a 00                	push   $0x0
    986e:	e8 3c ff ff ff       	call   97af <init_gdt_entry>
    9873:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    9876:	a1 10 00 01 00       	mov    0x10010,%eax
    987b:	83 c0 10             	add    $0x10,%eax
    987e:	50                   	push   %eax
    987f:	6a 04                	push   $0x4
    9881:	68 92 00 00 00       	push   $0x92
    9886:	68 ff ff 0f 00       	push   $0xfffff
    988b:	6a 00                	push   $0x0
    988d:	e8 1d ff ff ff       	call   97af <init_gdt_entry>
    9892:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    9895:	a1 10 00 01 00       	mov    0x10010,%eax
    989a:	83 c0 18             	add    $0x18,%eax
    989d:	50                   	push   %eax
    989e:	6a 04                	push   $0x4
    98a0:	68 96 00 00 00       	push   $0x96
    98a5:	68 ff ff 0f 00       	push   $0xfffff
    98aa:	6a 00                	push   $0x0
    98ac:	e8 fe fe ff ff       	call   97af <init_gdt_entry>
    98b1:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Chargement de la GDT
    load_gdt();
    98b4:	e8 ad 1a 00 00       	call   b366 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    98b9:	66 b8 10 00          	mov    $0x10,%ax
    98bd:	8e d8                	mov    %eax,%ds
    98bf:	8e c0                	mov    %eax,%es
    98c1:	8e e0                	mov    %eax,%fs
    98c3:	8e e8                	mov    %eax,%gs
    98c5:	66 b8 18 00          	mov    $0x18,%ax
    98c9:	8e d0                	mov    %eax,%ss
    98cb:	ea d2 98 00 00 08 00 	ljmp   $0x8,$0x98d2

000098d2 <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    98d2:	90                   	nop
    98d3:	c9                   	leave  
    98d4:	c3                   	ret    

000098d5 <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    98d5:	55                   	push   %ebp
    98d6:	89 e5                	mov    %esp,%ebp
    98d8:	83 ec 18             	sub    $0x18,%esp
    98db:	8b 45 08             	mov    0x8(%ebp),%eax
    98de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    98e1:	8b 55 18             	mov    0x18(%ebp),%edx
    98e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    98e8:	89 c8                	mov    %ecx,%eax
    98ea:	88 45 f8             	mov    %al,-0x8(%ebp)
    98ed:	8b 45 10             	mov    0x10(%ebp),%eax
    98f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    98f3:	8b 45 14             	mov    0x14(%ebp),%eax
    98f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    98f9:	89 d0                	mov    %edx,%eax
    98fb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    98ff:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9903:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    9907:	66 89 14 c5 22 00 01 	mov    %dx,0x10022(,%eax,8)
    990e:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    990f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9913:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    9917:	88 14 c5 25 00 01 00 	mov    %dl,0x10025(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    991e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9922:	c6 04 c5 24 00 01 00 	movb   $0x0,0x10024(,%eax,8)
    9929:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    992a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    992e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9931:	66 89 14 c5 20 00 01 	mov    %dx,0x10020(,%eax,8)
    9938:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    9939:	8b 45 f0             	mov    -0x10(%ebp),%eax
    993c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    993f:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    9943:	c1 ea 10             	shr    $0x10,%edx
    9946:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    994a:	66 89 04 cd 26 00 01 	mov    %ax,0x10026(,%ecx,8)
    9951:	00 
}
    9952:	90                   	nop
    9953:	c9                   	leave  
    9954:	c3                   	ret    

00009955 <init_idt>:

void init_idt()
{
    9955:	55                   	push   %ebp
    9956:	89 e5                	mov    %esp,%ebp
    9958:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    995b:	83 ec 0c             	sub    $0xc,%esp
    995e:	68 ad da 00 00       	push   $0xdaad
    9963:	e8 12 0e 00 00       	call   a77a <Init_PIT>
    9968:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    996b:	83 ec 08             	sub    $0x8,%esp
    996e:	6a 28                	push   $0x28
    9970:	6a 20                	push   $0x20
    9972:	e8 16 0b 00 00       	call   a48d <PIC_remap>
    9977:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    997a:	b8 80 b4 00 00       	mov    $0xb480,%eax
    997f:	ba 00 00 00 00       	mov    $0x0,%edx
    9984:	83 ec 0c             	sub    $0xc,%esp
    9987:	6a 20                	push   $0x20
    9989:	52                   	push   %edx
    998a:	50                   	push   %eax
    998b:	68 8e 00 00 00       	push   $0x8e
    9990:	6a 08                	push   $0x8
    9992:	e8 3e ff ff ff       	call   98d5 <set_idt>
    9997:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    999a:	b8 d0 b3 00 00       	mov    $0xb3d0,%eax
    999f:	ba 00 00 00 00       	mov    $0x0,%edx
    99a4:	83 ec 0c             	sub    $0xc,%esp
    99a7:	6a 21                	push   $0x21
    99a9:	52                   	push   %edx
    99aa:	50                   	push   %eax
    99ab:	68 8e 00 00 00       	push   $0x8e
    99b0:	6a 08                	push   $0x8
    99b2:	e8 1e ff ff ff       	call   98d5 <set_idt>
    99b7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    99ba:	b8 d8 b3 00 00       	mov    $0xb3d8,%eax
    99bf:	ba 00 00 00 00       	mov    $0x0,%edx
    99c4:	83 ec 0c             	sub    $0xc,%esp
    99c7:	6a 22                	push   $0x22
    99c9:	52                   	push   %edx
    99ca:	50                   	push   %eax
    99cb:	68 8e 00 00 00       	push   $0x8e
    99d0:	6a 08                	push   $0x8
    99d2:	e8 fe fe ff ff       	call   98d5 <set_idt>
    99d7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    99da:	b8 e0 b3 00 00       	mov    $0xb3e0,%eax
    99df:	ba 00 00 00 00       	mov    $0x0,%edx
    99e4:	83 ec 0c             	sub    $0xc,%esp
    99e7:	6a 23                	push   $0x23
    99e9:	52                   	push   %edx
    99ea:	50                   	push   %eax
    99eb:	68 8e 00 00 00       	push   $0x8e
    99f0:	6a 08                	push   $0x8
    99f2:	e8 de fe ff ff       	call   98d5 <set_idt>
    99f7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    99fa:	b8 e8 b3 00 00       	mov    $0xb3e8,%eax
    99ff:	ba 00 00 00 00       	mov    $0x0,%edx
    9a04:	83 ec 0c             	sub    $0xc,%esp
    9a07:	6a 24                	push   $0x24
    9a09:	52                   	push   %edx
    9a0a:	50                   	push   %eax
    9a0b:	68 8e 00 00 00       	push   $0x8e
    9a10:	6a 08                	push   $0x8
    9a12:	e8 be fe ff ff       	call   98d5 <set_idt>
    9a17:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    9a1a:	b8 f0 b3 00 00       	mov    $0xb3f0,%eax
    9a1f:	ba 00 00 00 00       	mov    $0x0,%edx
    9a24:	83 ec 0c             	sub    $0xc,%esp
    9a27:	6a 25                	push   $0x25
    9a29:	52                   	push   %edx
    9a2a:	50                   	push   %eax
    9a2b:	68 8e 00 00 00       	push   $0x8e
    9a30:	6a 08                	push   $0x8
    9a32:	e8 9e fe ff ff       	call   98d5 <set_idt>
    9a37:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    9a3a:	b8 f8 b3 00 00       	mov    $0xb3f8,%eax
    9a3f:	ba 00 00 00 00       	mov    $0x0,%edx
    9a44:	83 ec 0c             	sub    $0xc,%esp
    9a47:	6a 26                	push   $0x26
    9a49:	52                   	push   %edx
    9a4a:	50                   	push   %eax
    9a4b:	68 8e 00 00 00       	push   $0x8e
    9a50:	6a 08                	push   $0x8
    9a52:	e8 7e fe ff ff       	call   98d5 <set_idt>
    9a57:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    9a5a:	b8 00 b4 00 00       	mov    $0xb400,%eax
    9a5f:	ba 00 00 00 00       	mov    $0x0,%edx
    9a64:	83 ec 0c             	sub    $0xc,%esp
    9a67:	6a 27                	push   $0x27
    9a69:	52                   	push   %edx
    9a6a:	50                   	push   %eax
    9a6b:	68 8e 00 00 00       	push   $0x8e
    9a70:	6a 08                	push   $0x8
    9a72:	e8 5e fe ff ff       	call   98d5 <set_idt>
    9a77:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    9a7a:	b8 08 b4 00 00       	mov    $0xb408,%eax
    9a7f:	ba 00 00 00 00       	mov    $0x0,%edx
    9a84:	83 ec 0c             	sub    $0xc,%esp
    9a87:	6a 28                	push   $0x28
    9a89:	52                   	push   %edx
    9a8a:	50                   	push   %eax
    9a8b:	68 8e 00 00 00       	push   $0x8e
    9a90:	6a 08                	push   $0x8
    9a92:	e8 3e fe ff ff       	call   98d5 <set_idt>
    9a97:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    9a9a:	b8 10 b4 00 00       	mov    $0xb410,%eax
    9a9f:	ba 00 00 00 00       	mov    $0x0,%edx
    9aa4:	83 ec 0c             	sub    $0xc,%esp
    9aa7:	6a 29                	push   $0x29
    9aa9:	52                   	push   %edx
    9aaa:	50                   	push   %eax
    9aab:	68 8e 00 00 00       	push   $0x8e
    9ab0:	6a 08                	push   $0x8
    9ab2:	e8 1e fe ff ff       	call   98d5 <set_idt>
    9ab7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    9aba:	b8 18 b4 00 00       	mov    $0xb418,%eax
    9abf:	ba 00 00 00 00       	mov    $0x0,%edx
    9ac4:	83 ec 0c             	sub    $0xc,%esp
    9ac7:	6a 2a                	push   $0x2a
    9ac9:	52                   	push   %edx
    9aca:	50                   	push   %eax
    9acb:	68 8e 00 00 00       	push   $0x8e
    9ad0:	6a 08                	push   $0x8
    9ad2:	e8 fe fd ff ff       	call   98d5 <set_idt>
    9ad7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    9ada:	b8 20 b4 00 00       	mov    $0xb420,%eax
    9adf:	ba 00 00 00 00       	mov    $0x0,%edx
    9ae4:	83 ec 0c             	sub    $0xc,%esp
    9ae7:	6a 2b                	push   $0x2b
    9ae9:	52                   	push   %edx
    9aea:	50                   	push   %eax
    9aeb:	68 8e 00 00 00       	push   $0x8e
    9af0:	6a 08                	push   $0x8
    9af2:	e8 de fd ff ff       	call   98d5 <set_idt>
    9af7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    9afa:	b8 28 b4 00 00       	mov    $0xb428,%eax
    9aff:	ba 00 00 00 00       	mov    $0x0,%edx
    9b04:	83 ec 0c             	sub    $0xc,%esp
    9b07:	6a 2c                	push   $0x2c
    9b09:	52                   	push   %edx
    9b0a:	50                   	push   %eax
    9b0b:	68 8e 00 00 00       	push   $0x8e
    9b10:	6a 08                	push   $0x8
    9b12:	e8 be fd ff ff       	call   98d5 <set_idt>
    9b17:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    9b1a:	b8 30 b4 00 00       	mov    $0xb430,%eax
    9b1f:	ba 00 00 00 00       	mov    $0x0,%edx
    9b24:	83 ec 0c             	sub    $0xc,%esp
    9b27:	6a 2d                	push   $0x2d
    9b29:	52                   	push   %edx
    9b2a:	50                   	push   %eax
    9b2b:	68 8e 00 00 00       	push   $0x8e
    9b30:	6a 08                	push   $0x8
    9b32:	e8 9e fd ff ff       	call   98d5 <set_idt>
    9b37:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    9b3a:	b8 38 b4 00 00       	mov    $0xb438,%eax
    9b3f:	ba 00 00 00 00       	mov    $0x0,%edx
    9b44:	83 ec 0c             	sub    $0xc,%esp
    9b47:	6a 2e                	push   $0x2e
    9b49:	52                   	push   %edx
    9b4a:	50                   	push   %eax
    9b4b:	68 8e 00 00 00       	push   $0x8e
    9b50:	6a 08                	push   $0x8
    9b52:	e8 7e fd ff ff       	call   98d5 <set_idt>
    9b57:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    9b5a:	b8 40 b4 00 00       	mov    $0xb440,%eax
    9b5f:	ba 00 00 00 00       	mov    $0x0,%edx
    9b64:	83 ec 0c             	sub    $0xc,%esp
    9b67:	6a 2f                	push   $0x2f
    9b69:	52                   	push   %edx
    9b6a:	50                   	push   %eax
    9b6b:	68 8e 00 00 00       	push   $0x8e
    9b70:	6a 08                	push   $0x8
    9b72:	e8 5e fd ff ff       	call   98d5 <set_idt>
    9b77:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    9b7a:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9b7f:	ba 00 00 00 00       	mov    $0x0,%edx
    9b84:	83 ec 0c             	sub    $0xc,%esp
    9b87:	6a 08                	push   $0x8
    9b89:	52                   	push   %edx
    9b8a:	50                   	push   %eax
    9b8b:	68 8e 00 00 00       	push   $0x8e
    9b90:	6a 08                	push   $0x8
    9b92:	e8 3e fd ff ff       	call   98d5 <set_idt>
    9b97:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    9b9a:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9b9f:	ba 00 00 00 00       	mov    $0x0,%edx
    9ba4:	83 ec 0c             	sub    $0xc,%esp
    9ba7:	6a 0a                	push   $0xa
    9ba9:	52                   	push   %edx
    9baa:	50                   	push   %eax
    9bab:	68 8e 00 00 00       	push   $0x8e
    9bb0:	6a 08                	push   $0x8
    9bb2:	e8 1e fd ff ff       	call   98d5 <set_idt>
    9bb7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    9bba:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9bbf:	ba 00 00 00 00       	mov    $0x0,%edx
    9bc4:	83 ec 0c             	sub    $0xc,%esp
    9bc7:	6a 0b                	push   $0xb
    9bc9:	52                   	push   %edx
    9bca:	50                   	push   %eax
    9bcb:	68 8e 00 00 00       	push   $0x8e
    9bd0:	6a 08                	push   $0x8
    9bd2:	e8 fe fc ff ff       	call   98d5 <set_idt>
    9bd7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9bda:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9bdf:	ba 00 00 00 00       	mov    $0x0,%edx
    9be4:	83 ec 0c             	sub    $0xc,%esp
    9be7:	6a 0c                	push   $0xc
    9be9:	52                   	push   %edx
    9bea:	50                   	push   %eax
    9beb:	68 8e 00 00 00       	push   $0x8e
    9bf0:	6a 08                	push   $0x8
    9bf2:	e8 de fc ff ff       	call   98d5 <set_idt>
    9bf7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9bfa:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9bff:	ba 00 00 00 00       	mov    $0x0,%edx
    9c04:	83 ec 0c             	sub    $0xc,%esp
    9c07:	6a 0d                	push   $0xd
    9c09:	52                   	push   %edx
    9c0a:	50                   	push   %eax
    9c0b:	68 8e 00 00 00       	push   $0x8e
    9c10:	6a 08                	push   $0x8
    9c12:	e8 be fc ff ff       	call   98d5 <set_idt>
    9c17:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    9c1a:	b8 5c a4 00 00       	mov    $0xa45c,%eax
    9c1f:	ba 00 00 00 00       	mov    $0x0,%edx
    9c24:	83 ec 0c             	sub    $0xc,%esp
    9c27:	6a 0e                	push   $0xe
    9c29:	52                   	push   %edx
    9c2a:	50                   	push   %eax
    9c2b:	68 8e 00 00 00       	push   $0x8e
    9c30:	6a 08                	push   $0x8
    9c32:	e8 9e fc ff ff       	call   98d5 <set_idt>
    9c37:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    9c3a:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9c3f:	ba 00 00 00 00       	mov    $0x0,%edx
    9c44:	83 ec 0c             	sub    $0xc,%esp
    9c47:	6a 11                	push   $0x11
    9c49:	52                   	push   %edx
    9c4a:	50                   	push   %eax
    9c4b:	68 8e 00 00 00       	push   $0x8e
    9c50:	6a 08                	push   $0x8
    9c52:	e8 7e fc ff ff       	call   98d5 <set_idt>
    9c57:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    9c5a:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9c5f:	ba 00 00 00 00       	mov    $0x0,%edx
    9c64:	83 ec 0c             	sub    $0xc,%esp
    9c67:	6a 1e                	push   $0x1e
    9c69:	52                   	push   %edx
    9c6a:	50                   	push   %eax
    9c6b:	68 8e 00 00 00       	push   $0x8e
    9c70:	6a 08                	push   $0x8
    9c72:	e8 5e fc ff ff       	call   98d5 <set_idt>
    9c77:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9c7a:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9c7f:	ba 00 00 00 00       	mov    $0x0,%edx
    9c84:	83 ec 0c             	sub    $0xc,%esp
    9c87:	6a 00                	push   $0x0
    9c89:	52                   	push   %edx
    9c8a:	50                   	push   %eax
    9c8b:	68 8e 00 00 00       	push   $0x8e
    9c90:	6a 08                	push   $0x8
    9c92:	e8 3e fc ff ff       	call   98d5 <set_idt>
    9c97:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9c9a:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9c9f:	ba 00 00 00 00       	mov    $0x0,%edx
    9ca4:	83 ec 0c             	sub    $0xc,%esp
    9ca7:	6a 01                	push   $0x1
    9ca9:	52                   	push   %edx
    9caa:	50                   	push   %eax
    9cab:	68 8e 00 00 00       	push   $0x8e
    9cb0:	6a 08                	push   $0x8
    9cb2:	e8 1e fc ff ff       	call   98d5 <set_idt>
    9cb7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9cba:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9cbf:	ba 00 00 00 00       	mov    $0x0,%edx
    9cc4:	83 ec 0c             	sub    $0xc,%esp
    9cc7:	6a 02                	push   $0x2
    9cc9:	52                   	push   %edx
    9cca:	50                   	push   %eax
    9ccb:	68 8e 00 00 00       	push   $0x8e
    9cd0:	6a 08                	push   $0x8
    9cd2:	e8 fe fb ff ff       	call   98d5 <set_idt>
    9cd7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9cda:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9cdf:	ba 00 00 00 00       	mov    $0x0,%edx
    9ce4:	83 ec 0c             	sub    $0xc,%esp
    9ce7:	6a 03                	push   $0x3
    9ce9:	52                   	push   %edx
    9cea:	50                   	push   %eax
    9ceb:	68 8e 00 00 00       	push   $0x8e
    9cf0:	6a 08                	push   $0x8
    9cf2:	e8 de fb ff ff       	call   98d5 <set_idt>
    9cf7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9cfa:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9cff:	ba 00 00 00 00       	mov    $0x0,%edx
    9d04:	83 ec 0c             	sub    $0xc,%esp
    9d07:	6a 04                	push   $0x4
    9d09:	52                   	push   %edx
    9d0a:	50                   	push   %eax
    9d0b:	68 8e 00 00 00       	push   $0x8e
    9d10:	6a 08                	push   $0x8
    9d12:	e8 be fb ff ff       	call   98d5 <set_idt>
    9d17:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    9d1a:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9d1f:	ba 00 00 00 00       	mov    $0x0,%edx
    9d24:	83 ec 0c             	sub    $0xc,%esp
    9d27:	6a 05                	push   $0x5
    9d29:	52                   	push   %edx
    9d2a:	50                   	push   %eax
    9d2b:	68 8e 00 00 00       	push   $0x8e
    9d30:	6a 08                	push   $0x8
    9d32:	e8 9e fb ff ff       	call   98d5 <set_idt>
    9d37:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    9d3a:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9d3f:	ba 00 00 00 00       	mov    $0x0,%edx
    9d44:	83 ec 0c             	sub    $0xc,%esp
    9d47:	6a 06                	push   $0x6
    9d49:	52                   	push   %edx
    9d4a:	50                   	push   %eax
    9d4b:	68 8e 00 00 00       	push   $0x8e
    9d50:	6a 08                	push   $0x8
    9d52:	e8 7e fb ff ff       	call   98d5 <set_idt>
    9d57:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    9d5a:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9d5f:	ba 00 00 00 00       	mov    $0x0,%edx
    9d64:	83 ec 0c             	sub    $0xc,%esp
    9d67:	6a 07                	push   $0x7
    9d69:	52                   	push   %edx
    9d6a:	50                   	push   %eax
    9d6b:	68 8e 00 00 00       	push   $0x8e
    9d70:	6a 08                	push   $0x8
    9d72:	e8 5e fb ff ff       	call   98d5 <set_idt>
    9d77:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9d7a:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9d7f:	ba 00 00 00 00       	mov    $0x0,%edx
    9d84:	83 ec 0c             	sub    $0xc,%esp
    9d87:	6a 09                	push   $0x9
    9d89:	52                   	push   %edx
    9d8a:	50                   	push   %eax
    9d8b:	68 8e 00 00 00       	push   $0x8e
    9d90:	6a 08                	push   $0x8
    9d92:	e8 3e fb ff ff       	call   98d5 <set_idt>
    9d97:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9d9a:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9d9f:	ba 00 00 00 00       	mov    $0x0,%edx
    9da4:	83 ec 0c             	sub    $0xc,%esp
    9da7:	6a 10                	push   $0x10
    9da9:	52                   	push   %edx
    9daa:	50                   	push   %eax
    9dab:	68 8e 00 00 00       	push   $0x8e
    9db0:	6a 08                	push   $0x8
    9db2:	e8 1e fb ff ff       	call   98d5 <set_idt>
    9db7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9dba:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9dbf:	ba 00 00 00 00       	mov    $0x0,%edx
    9dc4:	83 ec 0c             	sub    $0xc,%esp
    9dc7:	6a 12                	push   $0x12
    9dc9:	52                   	push   %edx
    9dca:	50                   	push   %eax
    9dcb:	68 8e 00 00 00       	push   $0x8e
    9dd0:	6a 08                	push   $0x8
    9dd2:	e8 fe fa ff ff       	call   98d5 <set_idt>
    9dd7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9dda:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9ddf:	ba 00 00 00 00       	mov    $0x0,%edx
    9de4:	83 ec 0c             	sub    $0xc,%esp
    9de7:	6a 13                	push   $0x13
    9de9:	52                   	push   %edx
    9dea:	50                   	push   %eax
    9deb:	68 8e 00 00 00       	push   $0x8e
    9df0:	6a 08                	push   $0x8
    9df2:	e8 de fa ff ff       	call   98d5 <set_idt>
    9df7:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9dfa:	b8 a9 97 00 00       	mov    $0x97a9,%eax
    9dff:	ba 00 00 00 00       	mov    $0x0,%edx
    9e04:	83 ec 0c             	sub    $0xc,%esp
    9e07:	6a 14                	push   $0x14
    9e09:	52                   	push   %edx
    9e0a:	50                   	push   %eax
    9e0b:	68 8e 00 00 00       	push   $0x8e
    9e10:	6a 08                	push   $0x8
    9e12:	e8 be fa ff ff       	call   98d5 <set_idt>
    9e17:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    9e1a:	e8 80 15 00 00       	call   b39f <load_idt>
}
    9e1f:	90                   	nop
    9e20:	c9                   	leave  
    9e21:	c3                   	ret    

00009e22 <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    9e22:	55                   	push   %ebp
    9e23:	89 e5                	mov    %esp,%ebp
    9e25:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    9e28:	e8 4a 02 00 00       	call   a077 <keyboard_irq>
    PIC_sendEOI(1);
    9e2d:	83 ec 0c             	sub    $0xc,%esp
    9e30:	6a 01                	push   $0x1
    9e32:	e8 2b 06 00 00       	call   a462 <PIC_sendEOI>
    9e37:	83 c4 10             	add    $0x10,%esp
}
    9e3a:	90                   	nop
    9e3b:	c9                   	leave  
    9e3c:	c3                   	ret    

00009e3d <irq2_handler>:

void irq2_handler(void)
{
    9e3d:	55                   	push   %ebp
    9e3e:	89 e5                	mov    %esp,%ebp
    9e40:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    9e43:	83 ec 0c             	sub    $0xc,%esp
    9e46:	6a 02                	push   $0x2
    9e48:	e8 21 08 00 00       	call   a66e <spurious_IRQ>
    9e4d:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9e50:	83 ec 0c             	sub    $0xc,%esp
    9e53:	6a 02                	push   $0x2
    9e55:	e8 08 06 00 00       	call   a462 <PIC_sendEOI>
    9e5a:	83 c4 10             	add    $0x10,%esp
}
    9e5d:	90                   	nop
    9e5e:	c9                   	leave  
    9e5f:	c3                   	ret    

00009e60 <irq3_handler>:

void irq3_handler(void)
{
    9e60:	55                   	push   %ebp
    9e61:	89 e5                	mov    %esp,%ebp
    9e63:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    9e66:	83 ec 0c             	sub    $0xc,%esp
    9e69:	6a 03                	push   $0x3
    9e6b:	e8 fe 07 00 00       	call   a66e <spurious_IRQ>
    9e70:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9e73:	83 ec 0c             	sub    $0xc,%esp
    9e76:	6a 03                	push   $0x3
    9e78:	e8 e5 05 00 00       	call   a462 <PIC_sendEOI>
    9e7d:	83 c4 10             	add    $0x10,%esp
}
    9e80:	90                   	nop
    9e81:	c9                   	leave  
    9e82:	c3                   	ret    

00009e83 <irq4_handler>:

void irq4_handler(void)
{
    9e83:	55                   	push   %ebp
    9e84:	89 e5                	mov    %esp,%ebp
    9e86:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    9e89:	83 ec 0c             	sub    $0xc,%esp
    9e8c:	6a 04                	push   $0x4
    9e8e:	e8 db 07 00 00       	call   a66e <spurious_IRQ>
    9e93:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9e96:	83 ec 0c             	sub    $0xc,%esp
    9e99:	6a 04                	push   $0x4
    9e9b:	e8 c2 05 00 00       	call   a462 <PIC_sendEOI>
    9ea0:	83 c4 10             	add    $0x10,%esp
}
    9ea3:	90                   	nop
    9ea4:	c9                   	leave  
    9ea5:	c3                   	ret    

00009ea6 <irq5_handler>:

void irq5_handler(void)
{
    9ea6:	55                   	push   %ebp
    9ea7:	89 e5                	mov    %esp,%ebp
    9ea9:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9eac:	83 ec 0c             	sub    $0xc,%esp
    9eaf:	6a 05                	push   $0x5
    9eb1:	e8 b8 07 00 00       	call   a66e <spurious_IRQ>
    9eb6:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9eb9:	83 ec 0c             	sub    $0xc,%esp
    9ebc:	6a 05                	push   $0x5
    9ebe:	e8 9f 05 00 00       	call   a462 <PIC_sendEOI>
    9ec3:	83 c4 10             	add    $0x10,%esp
}
    9ec6:	90                   	nop
    9ec7:	c9                   	leave  
    9ec8:	c3                   	ret    

00009ec9 <irq6_handler>:

void irq6_handler(void)
{
    9ec9:	55                   	push   %ebp
    9eca:	89 e5                	mov    %esp,%ebp
    9ecc:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9ecf:	83 ec 0c             	sub    $0xc,%esp
    9ed2:	6a 06                	push   $0x6
    9ed4:	e8 95 07 00 00       	call   a66e <spurious_IRQ>
    9ed9:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9edc:	83 ec 0c             	sub    $0xc,%esp
    9edf:	6a 06                	push   $0x6
    9ee1:	e8 7c 05 00 00       	call   a462 <PIC_sendEOI>
    9ee6:	83 c4 10             	add    $0x10,%esp
}
    9ee9:	90                   	nop
    9eea:	c9                   	leave  
    9eeb:	c3                   	ret    

00009eec <irq7_handler>:

void irq7_handler(void)
{
    9eec:	55                   	push   %ebp
    9eed:	89 e5                	mov    %esp,%ebp
    9eef:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9ef2:	83 ec 0c             	sub    $0xc,%esp
    9ef5:	6a 07                	push   $0x7
    9ef7:	e8 72 07 00 00       	call   a66e <spurious_IRQ>
    9efc:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9eff:	83 ec 0c             	sub    $0xc,%esp
    9f02:	6a 07                	push   $0x7
    9f04:	e8 59 05 00 00       	call   a462 <PIC_sendEOI>
    9f09:	83 c4 10             	add    $0x10,%esp
}
    9f0c:	90                   	nop
    9f0d:	c9                   	leave  
    9f0e:	c3                   	ret    

00009f0f <irq8_handler>:

void irq8_handler(void)
{
    9f0f:	55                   	push   %ebp
    9f10:	89 e5                	mov    %esp,%ebp
    9f12:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    9f15:	83 ec 0c             	sub    $0xc,%esp
    9f18:	6a 08                	push   $0x8
    9f1a:	e8 4f 07 00 00       	call   a66e <spurious_IRQ>
    9f1f:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9f22:	83 ec 0c             	sub    $0xc,%esp
    9f25:	6a 08                	push   $0x8
    9f27:	e8 36 05 00 00       	call   a462 <PIC_sendEOI>
    9f2c:	83 c4 10             	add    $0x10,%esp
}
    9f2f:	90                   	nop
    9f30:	c9                   	leave  
    9f31:	c3                   	ret    

00009f32 <irq9_handler>:

void irq9_handler(void)
{
    9f32:	55                   	push   %ebp
    9f33:	89 e5                	mov    %esp,%ebp
    9f35:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    9f38:	83 ec 0c             	sub    $0xc,%esp
    9f3b:	6a 09                	push   $0x9
    9f3d:	e8 2c 07 00 00       	call   a66e <spurious_IRQ>
    9f42:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9f45:	83 ec 0c             	sub    $0xc,%esp
    9f48:	6a 09                	push   $0x9
    9f4a:	e8 13 05 00 00       	call   a462 <PIC_sendEOI>
    9f4f:	83 c4 10             	add    $0x10,%esp
}
    9f52:	90                   	nop
    9f53:	c9                   	leave  
    9f54:	c3                   	ret    

00009f55 <irq10_handler>:

void irq10_handler(void)
{
    9f55:	55                   	push   %ebp
    9f56:	89 e5                	mov    %esp,%ebp
    9f58:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    9f5b:	83 ec 0c             	sub    $0xc,%esp
    9f5e:	6a 0a                	push   $0xa
    9f60:	e8 09 07 00 00       	call   a66e <spurious_IRQ>
    9f65:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9f68:	83 ec 0c             	sub    $0xc,%esp
    9f6b:	6a 0a                	push   $0xa
    9f6d:	e8 f0 04 00 00       	call   a462 <PIC_sendEOI>
    9f72:	83 c4 10             	add    $0x10,%esp
}
    9f75:	90                   	nop
    9f76:	c9                   	leave  
    9f77:	c3                   	ret    

00009f78 <irq11_handler>:

void irq11_handler(void)
{
    9f78:	55                   	push   %ebp
    9f79:	89 e5                	mov    %esp,%ebp
    9f7b:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9f7e:	83 ec 0c             	sub    $0xc,%esp
    9f81:	6a 0b                	push   $0xb
    9f83:	e8 e6 06 00 00       	call   a66e <spurious_IRQ>
    9f88:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9f8b:	83 ec 0c             	sub    $0xc,%esp
    9f8e:	6a 0b                	push   $0xb
    9f90:	e8 cd 04 00 00       	call   a462 <PIC_sendEOI>
    9f95:	83 c4 10             	add    $0x10,%esp
}
    9f98:	90                   	nop
    9f99:	c9                   	leave  
    9f9a:	c3                   	ret    

00009f9b <irq12_handler>:

void irq12_handler(void)
{
    9f9b:	55                   	push   %ebp
    9f9c:	89 e5                	mov    %esp,%ebp
    9f9e:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9fa1:	83 ec 0c             	sub    $0xc,%esp
    9fa4:	6a 0c                	push   $0xc
    9fa6:	e8 c3 06 00 00       	call   a66e <spurious_IRQ>
    9fab:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9fae:	83 ec 0c             	sub    $0xc,%esp
    9fb1:	6a 0c                	push   $0xc
    9fb3:	e8 aa 04 00 00       	call   a462 <PIC_sendEOI>
    9fb8:	83 c4 10             	add    $0x10,%esp
}
    9fbb:	90                   	nop
    9fbc:	c9                   	leave  
    9fbd:	c3                   	ret    

00009fbe <irq13_handler>:

void irq13_handler(void)
{
    9fbe:	55                   	push   %ebp
    9fbf:	89 e5                	mov    %esp,%ebp
    9fc1:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9fc4:	83 ec 0c             	sub    $0xc,%esp
    9fc7:	6a 0d                	push   $0xd
    9fc9:	e8 a0 06 00 00       	call   a66e <spurious_IRQ>
    9fce:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9fd1:	83 ec 0c             	sub    $0xc,%esp
    9fd4:	6a 0d                	push   $0xd
    9fd6:	e8 87 04 00 00       	call   a462 <PIC_sendEOI>
    9fdb:	83 c4 10             	add    $0x10,%esp
}
    9fde:	90                   	nop
    9fdf:	c9                   	leave  
    9fe0:	c3                   	ret    

00009fe1 <irq14_handler>:

void irq14_handler(void)
{
    9fe1:	55                   	push   %ebp
    9fe2:	89 e5                	mov    %esp,%ebp
    9fe4:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9fe7:	83 ec 0c             	sub    $0xc,%esp
    9fea:	6a 0e                	push   $0xe
    9fec:	e8 7d 06 00 00       	call   a66e <spurious_IRQ>
    9ff1:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9ff4:	83 ec 0c             	sub    $0xc,%esp
    9ff7:	6a 0e                	push   $0xe
    9ff9:	e8 64 04 00 00       	call   a462 <PIC_sendEOI>
    9ffe:	83 c4 10             	add    $0x10,%esp
}
    a001:	90                   	nop
    a002:	c9                   	leave  
    a003:	c3                   	ret    

0000a004 <irq15_handler>:

void irq15_handler(void)
{
    a004:	55                   	push   %ebp
    a005:	89 e5                	mov    %esp,%ebp
    a007:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    a00a:	83 ec 0c             	sub    $0xc,%esp
    a00d:	6a 0f                	push   $0xf
    a00f:	e8 5a 06 00 00       	call   a66e <spurious_IRQ>
    a014:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    a017:	83 ec 0c             	sub    $0xc,%esp
    a01a:	6a 0f                	push   $0xf
    a01c:	e8 41 04 00 00       	call   a462 <PIC_sendEOI>
    a021:	83 c4 10             	add    $0x10,%esp
    a024:	90                   	nop
    a025:	c9                   	leave  
    a026:	c3                   	ret    

0000a027 <keyboard_add_service>:
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x60)  */
          0xFF, 0xFF, 0xFF, 0xFF  /*      (0x61)  */
      };

void keyboard_add_service(void (*func)())
{
    a027:	55                   	push   %ebp
    a028:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service[keyboard_ctrl.kbd_service_num] = func;
    a02a:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a031:	0f be c0             	movsbl %al,%eax
    a034:	8b 55 08             	mov    0x8(%ebp),%edx
    a037:	89 14 85 22 08 01 00 	mov    %edx,0x10822(,%eax,4)
    keyboard_ctrl.kbd_service_num++;
    a03e:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a045:	83 c0 01             	add    $0x1,%eax
    a048:	a2 21 08 01 00       	mov    %al,0x10821
}
    a04d:	90                   	nop
    a04e:	5d                   	pop    %ebp
    a04f:	c3                   	ret    

0000a050 <kbd_init>:

void kbd_init()
{
    a050:	55                   	push   %ebp
    a051:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service_num = 0;
    a053:	c6 05 21 08 01 00 00 	movb   $0x0,0x10821
    keyboard_add_service(console_service_keyboard);
    a05a:	68 63 97 00 00       	push   $0x9763
    a05f:	e8 c3 ff ff ff       	call   a027 <keyboard_add_service>
    a064:	83 c4 04             	add    $0x4,%esp
    keyboard_add_service(monitor_service_keyboard);
    a067:	68 d1 a9 00 00       	push   $0xa9d1
    a06c:	e8 b6 ff ff ff       	call   a027 <keyboard_add_service>
    a071:	83 c4 04             	add    $0x4,%esp
}
    a074:	90                   	nop
    a075:	c9                   	leave  
    a076:	c3                   	ret    

0000a077 <keyboard_irq>:

void keyboard_irq()
{
    a077:	55                   	push   %ebp
    a078:	89 e5                	mov    %esp,%ebp
    a07a:	83 ec 18             	sub    $0x18,%esp

    int i;
    void (*func)(void);

    do {
        keyboard_ctrl.code = _8042_get_status;
    a07d:	b8 64 00 00 00       	mov    $0x64,%eax
    a082:	89 c2                	mov    %eax,%edx
    a084:	ec                   	in     (%dx),%al
    a085:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a089:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a08d:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e
    } while ((keyboard_ctrl.code & 0x01) == _8042_BUFFER_OVERRUN);
    a093:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a09a:	98                   	cwtl   
    a09b:	83 e0 01             	and    $0x1,%eax
    a09e:	85 c0                	test   %eax,%eax
    a0a0:	74 db                	je     a07d <keyboard_irq+0x6>

    keyboard_ctrl.code = _8042_scan_code;
    a0a2:	b8 60 00 00 00       	mov    $0x60,%eax
    a0a7:	89 c2                	mov    %eax,%edx
    a0a9:	ec                   	in     (%dx),%al
    a0aa:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a0ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a0b2:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    a0b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a0bf:	eb 16                	jmp    a0d7 <keyboard_irq+0x60>
        func = keyboard_ctrl.kbd_service[i];
    a0c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a0c4:	8b 04 85 22 08 01 00 	mov    0x10822(,%eax,4),%eax
    a0cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        func();
    a0ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a0d1:	ff d0                	call   *%eax
    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    a0d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a0d7:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a0de:	0f be c0             	movsbl %al,%eax
    a0e1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a0e4:	7c db                	jl     a0c1 <keyboard_irq+0x4a>
    }
}
    a0e6:	90                   	nop
    a0e7:	90                   	nop
    a0e8:	c9                   	leave  
    a0e9:	c3                   	ret    

0000a0ea <reinitialise_kbd>:

void reinitialise_kbd()
{
    a0ea:	55                   	push   %ebp
    a0eb:	89 e5                	mov    %esp,%ebp
    a0ed:	83 ec 08             	sub    $0x8,%esp
    wait_8042_ACK();
    a0f0:	e8 43 00 00 00       	call   a138 <wait_8042_ACK>
    _8042_send_get_current_scan_code;
    a0f5:	ba 64 00 00 00       	mov    $0x64,%edx
    a0fa:	b8 f0 00 00 00       	mov    $0xf0,%eax
    a0ff:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a100:	e8 33 00 00 00       	call   a138 <wait_8042_ACK>

    _8042_set_typematic_rate;
    a105:	ba 64 00 00 00       	mov    $0x64,%edx
    a10a:	b8 f3 00 00 00       	mov    $0xf3,%eax
    a10f:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a110:	e8 23 00 00 00       	call   a138 <wait_8042_ACK>

    _8042_set_leds;
    a115:	ba 64 00 00 00       	mov    $0x64,%edx
    a11a:	b8 ed 00 00 00       	mov    $0xed,%eax
    a11f:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a120:	e8 13 00 00 00       	call   a138 <wait_8042_ACK>

    _8042_enable_scanning;
    a125:	ba 64 00 00 00       	mov    $0x64,%edx
    a12a:	b8 f4 00 00 00       	mov    $0xf4,%eax
    a12f:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a130:	e8 03 00 00 00       	call   a138 <wait_8042_ACK>
}
    a135:	90                   	nop
    a136:	c9                   	leave  
    a137:	c3                   	ret    

0000a138 <wait_8042_ACK>:

static void
wait_8042_ACK()
{
    a138:	55                   	push   %ebp
    a139:	89 e5                	mov    %esp,%ebp
    a13b:	83 ec 10             	sub    $0x10,%esp
    while (_8042_get_status != _8042_ACK)
    a13e:	90                   	nop
    a13f:	b8 64 00 00 00       	mov    $0x64,%eax
    a144:	89 c2                	mov    %eax,%edx
    a146:	ec                   	in     (%dx),%al
    a147:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a14b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a14f:	66 3d fa 00          	cmp    $0xfa,%ax
    a153:	75 ea                	jne    a13f <wait_8042_ACK+0x7>
        ;
}
    a155:	90                   	nop
    a156:	90                   	nop
    a157:	c9                   	leave  
    a158:	c3                   	ret    

0000a159 <get_code_kbd_control>:

int16_t get_code_kbd_control()
{
    a159:	55                   	push   %ebp
    a15a:	89 e5                	mov    %esp,%ebp
    return keyboard_ctrl.code;
    a15c:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
}
    a163:	5d                   	pop    %ebp
    a164:	c3                   	ret    

0000a165 <handle_ASCII_code_keyboard>:

static void handle_ASCII_code_keyboard()
{
    a165:	55                   	push   %ebp
    a166:	89 e5                	mov    %esp,%ebp
    a168:	83 ec 10             	sub    $0x10,%esp
    int16_t _code = keyboard_ctrl.code - 1;
    a16b:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a172:	83 e8 01             	sub    $0x1,%eax
    a175:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    if (_code < 0x80) { /* key held down */
    a179:	66 83 7d fe 7f       	cmpw   $0x7f,-0x2(%ebp)
    a17e:	0f 8f 8f 00 00 00    	jg     a213 <handle_ASCII_code_keyboard+0xae>
        switch (_code) {
    a184:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a188:	83 f8 37             	cmp    $0x37,%eax
    a18b:	74 3d                	je     a1ca <handle_ASCII_code_keyboard+0x65>
    a18d:	83 f8 37             	cmp    $0x37,%eax
    a190:	7f 44                	jg     a1d6 <handle_ASCII_code_keyboard+0x71>
    a192:	83 f8 35             	cmp    $0x35,%eax
    a195:	74 1b                	je     a1b2 <handle_ASCII_code_keyboard+0x4d>
    a197:	83 f8 35             	cmp    $0x35,%eax
    a19a:	7f 3a                	jg     a1d6 <handle_ASCII_code_keyboard+0x71>
    a19c:	83 f8 1c             	cmp    $0x1c,%eax
    a19f:	74 1d                	je     a1be <handle_ASCII_code_keyboard+0x59>
    a1a1:	83 f8 29             	cmp    $0x29,%eax
    a1a4:	75 30                	jne    a1d6 <handle_ASCII_code_keyboard+0x71>
        case 0x29: lshift_enable = 1; break;
    a1a6:	c6 05 20 0c 01 00 01 	movb   $0x1,0x10c20
    a1ad:	e9 b8 00 00 00       	jmp    a26a <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 1; break;
    a1b2:	c6 05 21 0c 01 00 01 	movb   $0x1,0x10c21
    a1b9:	e9 ac 00 00 00       	jmp    a26a <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 1; break;
    a1be:	c6 05 23 0c 01 00 01 	movb   $0x1,0x10c23
    a1c5:	e9 a0 00 00 00       	jmp    a26a <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 1; break;
    a1ca:	c6 05 22 0c 01 00 01 	movb   $0x1,0x10c22
    a1d1:	e9 94 00 00 00       	jmp    a26a <handle_ASCII_code_keyboard+0x105>
        default:
            keyboard_ctrl.ascii_code_keyboard = kbdmap[_code * 4 + (lshift_enable || rshift_enable)];
    a1d6:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a1da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a1e1:	0f b6 05 20 0c 01 00 	movzbl 0x10c20,%eax
    a1e8:	84 c0                	test   %al,%al
    a1ea:	75 0b                	jne    a1f7 <handle_ASCII_code_keyboard+0x92>
    a1ec:	0f b6 05 21 0c 01 00 	movzbl 0x10c21,%eax
    a1f3:	84 c0                	test   %al,%al
    a1f5:	74 07                	je     a1fe <handle_ASCII_code_keyboard+0x99>
    a1f7:	b8 01 00 00 00       	mov    $0x1,%eax
    a1fc:	eb 05                	jmp    a203 <handle_ASCII_code_keyboard+0x9e>
    a1fe:	b8 00 00 00 00       	mov    $0x0,%eax
    a203:	01 d0                	add    %edx,%eax
    a205:	0f b6 80 e0 b5 00 00 	movzbl 0xb5e0(%eax),%eax
    a20c:	a2 20 08 01 00       	mov    %al,0x10820
        case 0x35: rshift_enable = 0; break;
        case 0x1C: ctrl_enable = 0; break;
        case 0x37: alt_enable = 0; break;
        }
    }
}
    a211:	eb 57                	jmp    a26a <handle_ASCII_code_keyboard+0x105>
        _code -= 0x80;
    a213:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a217:	83 c0 80             	add    $0xffffff80,%eax
    a21a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
        keyboard_ctrl.ascii_code_keyboard = '\0'; //Free it when release the key
    a21e:	c6 05 20 08 01 00 00 	movb   $0x0,0x10820
        switch (_code) {
    a225:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a229:	83 f8 37             	cmp    $0x37,%eax
    a22c:	74 34                	je     a262 <handle_ASCII_code_keyboard+0xfd>
    a22e:	83 f8 37             	cmp    $0x37,%eax
    a231:	7f 37                	jg     a26a <handle_ASCII_code_keyboard+0x105>
    a233:	83 f8 35             	cmp    $0x35,%eax
    a236:	74 18                	je     a250 <handle_ASCII_code_keyboard+0xeb>
    a238:	83 f8 35             	cmp    $0x35,%eax
    a23b:	7f 2d                	jg     a26a <handle_ASCII_code_keyboard+0x105>
    a23d:	83 f8 1c             	cmp    $0x1c,%eax
    a240:	74 17                	je     a259 <handle_ASCII_code_keyboard+0xf4>
    a242:	83 f8 29             	cmp    $0x29,%eax
    a245:	75 23                	jne    a26a <handle_ASCII_code_keyboard+0x105>
        case 0x29: lshift_enable = 0; break;
    a247:	c6 05 20 0c 01 00 00 	movb   $0x0,0x10c20
    a24e:	eb 1a                	jmp    a26a <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 0; break;
    a250:	c6 05 21 0c 01 00 00 	movb   $0x0,0x10c21
    a257:	eb 11                	jmp    a26a <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 0; break;
    a259:	c6 05 23 0c 01 00 00 	movb   $0x0,0x10c23
    a260:	eb 08                	jmp    a26a <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 0; break;
    a262:	c6 05 22 0c 01 00 00 	movb   $0x0,0x10c22
    a269:	90                   	nop
}
    a26a:	90                   	nop
    a26b:	c9                   	leave  
    a26c:	c3                   	ret    

0000a26d <get_ASCII_code_keyboard>:

int8_t get_ASCII_code_keyboard()
{
    a26d:	55                   	push   %ebp
    a26e:	89 e5                	mov    %esp,%ebp

    handle_ASCII_code_keyboard();
    a270:	e8 f0 fe ff ff       	call   a165 <handle_ASCII_code_keyboard>

    return keyboard_ctrl.ascii_code_keyboard;
    a275:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    a27c:	5d                   	pop    %ebp
    a27d:	c3                   	ret    

0000a27e <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    a27e:	55                   	push   %ebp
    a27f:	89 e5                	mov    %esp,%ebp
    a281:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a284:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a28b:	eb 20                	jmp    a2ad <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a28d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a290:	c1 e0 0c             	shl    $0xc,%eax
    a293:	89 c2                	mov    %eax,%edx
    a295:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a298:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a29f:	8b 45 08             	mov    0x8(%ebp),%eax
    a2a2:	01 c8                	add    %ecx,%eax
    a2a4:	83 ca 23             	or     $0x23,%edx
    a2a7:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a2a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a2ad:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a2b4:	76 d7                	jbe    a28d <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    a2b6:	8b 45 08             	mov    0x8(%ebp),%eax
    a2b9:	83 c8 23             	or     $0x23,%eax
    a2bc:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    a2be:	8b 45 0c             	mov    0xc(%ebp),%eax
    a2c1:	89 14 85 00 10 01 00 	mov    %edx,0x11000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    a2c8:	e8 83 11 00 00       	call   b450 <_FlushPagingCache_>
}
    a2cd:	90                   	nop
    a2ce:	c9                   	leave  
    a2cf:	c3                   	ret    

0000a2d0 <init_paging>:

void init_paging()
{
    a2d0:	55                   	push   %ebp
    a2d1:	89 e5                	mov    %esp,%ebp
    a2d3:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    a2d6:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a2dc:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    a2e2:	eb 1a                	jmp    a2fe <init_paging+0x2e>
        page_directory[i] =
    a2e4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a2e8:	c7 04 85 00 10 01 00 	movl   $0x2,0x11000(,%eax,4)
    a2ef:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a2f3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a2f7:	83 c0 01             	add    $0x1,%eax
    a2fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a2fe:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a304:	76 de                	jbe    a2e4 <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a306:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    a30c:	eb 22                	jmp    a330 <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a30e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a312:	c1 e0 0c             	shl    $0xc,%eax
    a315:	83 c8 23             	or     $0x23,%eax
    a318:	89 c2                	mov    %eax,%edx
    a31a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a31e:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a325:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a329:	83 c0 01             	add    $0x1,%eax
    a32c:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a330:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a336:	76 d6                	jbe    a30e <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    a338:	b8 00 c0 00 00       	mov    $0xc000,%eax
    a33d:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    a340:	a3 00 10 01 00       	mov    %eax,0x11000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    a345:	e8 0f 11 00 00       	call   b459 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    a34a:	90                   	nop
    a34b:	c9                   	leave  
    a34c:	c3                   	ret    

0000a34d <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    a34d:	55                   	push   %ebp
    a34e:	89 e5                	mov    %esp,%ebp
    a350:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    a353:	8b 45 08             	mov    0x8(%ebp),%eax
    a356:	c1 e8 16             	shr    $0x16,%eax
    a359:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    a35c:	8b 45 08             	mov    0x8(%ebp),%eax
    a35f:	c1 e8 0c             	shr    $0xc,%eax
    a362:	25 ff 03 00 00       	and    $0x3ff,%eax
    a367:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a36d:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a374:	83 e0 23             	and    $0x23,%eax
    a377:	83 f8 23             	cmp    $0x23,%eax
    a37a:	75 56                	jne    a3d2 <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a37c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a37f:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a386:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a38b:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a38e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a398:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a39b:	01 d0                	add    %edx,%eax
    a39d:	8b 00                	mov    (%eax),%eax
    a39f:	83 e0 23             	and    $0x23,%eax
    a3a2:	83 f8 23             	cmp    $0x23,%eax
    a3a5:	75 24                	jne    a3cb <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a3a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a3aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a3b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a3b4:	01 d0                	add    %edx,%eax
    a3b6:	8b 00                	mov    (%eax),%eax
    a3b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a3bd:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    a3bf:	8b 45 08             	mov    0x8(%ebp),%eax
    a3c2:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a3c7:	09 d0                	or     %edx,%eax
    a3c9:	eb 0c                	jmp    a3d7 <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    a3cb:	b8 18 f1 00 00       	mov    $0xf118,%eax
    a3d0:	eb 05                	jmp    a3d7 <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    a3d2:	b8 18 f1 00 00       	mov    $0xf118,%eax
}
    a3d7:	c9                   	leave  
    a3d8:	c3                   	ret    

0000a3d9 <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    a3d9:	55                   	push   %ebp
    a3da:	89 e5                	mov    %esp,%ebp
    a3dc:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    a3df:	8b 45 08             	mov    0x8(%ebp),%eax
    a3e2:	c1 e8 16             	shr    $0x16,%eax
    a3e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    a3e8:	8b 45 08             	mov    0x8(%ebp),%eax
    a3eb:	c1 e8 0c             	shr    $0xc,%eax
    a3ee:	25 ff 03 00 00       	and    $0x3ff,%eax
    a3f3:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a3f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a3f9:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a400:	83 e0 23             	and    $0x23,%eax
    a403:	83 f8 23             	cmp    $0x23,%eax
    a406:	75 4e                	jne    a456 <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a408:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a40b:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a412:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a417:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a41a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a41d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a424:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a427:	01 d0                	add    %edx,%eax
    a429:	8b 00                	mov    (%eax),%eax
    a42b:	83 e0 23             	and    $0x23,%eax
    a42e:	83 f8 23             	cmp    $0x23,%eax
    a431:	74 26                	je     a459 <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a433:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a436:	c1 e0 0c             	shl    $0xc,%eax
    a439:	89 c2                	mov    %eax,%edx
    a43b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a43e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a445:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a448:	01 c8                	add    %ecx,%eax
    a44a:	83 ca 23             	or     $0x23,%edx
    a44d:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a44f:	e8 fc 0f 00 00       	call   b450 <_FlushPagingCache_>
    a454:	eb 04                	jmp    a45a <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a456:	90                   	nop
    a457:	eb 01                	jmp    a45a <map_linear_address+0x81>
            return; // the linear address was already mapped
    a459:	90                   	nop
}
    a45a:	c9                   	leave  
    a45b:	c3                   	ret    

0000a45c <Paging_fault>:

void Paging_fault()
{
    a45c:	55                   	push   %ebp
    a45d:	89 e5                	mov    %esp,%ebp
}
    a45f:	90                   	nop
    a460:	5d                   	pop    %ebp
    a461:	c3                   	ret    

0000a462 <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a462:	55                   	push   %ebp
    a463:	89 e5                	mov    %esp,%ebp
    a465:	83 ec 04             	sub    $0x4,%esp
    a468:	8b 45 08             	mov    0x8(%ebp),%eax
    a46b:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a46e:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a472:	76 0b                	jbe    a47f <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a474:	ba a0 00 00 00       	mov    $0xa0,%edx
    a479:	b8 20 00 00 00       	mov    $0x20,%eax
    a47e:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a47f:	ba 20 00 00 00       	mov    $0x20,%edx
    a484:	b8 20 00 00 00       	mov    $0x20,%eax
    a489:	ee                   	out    %al,(%dx)
}
    a48a:	90                   	nop
    a48b:	c9                   	leave  
    a48c:	c3                   	ret    

0000a48d <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a48d:	55                   	push   %ebp
    a48e:	89 e5                	mov    %esp,%ebp
    a490:	83 ec 18             	sub    $0x18,%esp
    a493:	8b 55 08             	mov    0x8(%ebp),%edx
    a496:	8b 45 0c             	mov    0xc(%ebp),%eax
    a499:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a49c:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a49f:	b8 21 00 00 00       	mov    $0x21,%eax
    a4a4:	89 c2                	mov    %eax,%edx
    a4a6:	ec                   	in     (%dx),%al
    a4a7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a4ab:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a4af:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2 = inb(PIC2_DATA);
    a4b2:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a4b7:	89 c2                	mov    %eax,%edx
    a4b9:	ec                   	in     (%dx),%al
    a4ba:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a4be:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a4c2:	88 45 f9             	mov    %al,-0x7(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a4c5:	ba 20 00 00 00       	mov    $0x20,%edx
    a4ca:	b8 11 00 00 00       	mov    $0x11,%eax
    a4cf:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a4d0:	eb 00                	jmp    a4d2 <PIC_remap+0x45>
    a4d2:	eb 00                	jmp    a4d4 <PIC_remap+0x47>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a4d4:	ba a0 00 00 00       	mov    $0xa0,%edx
    a4d9:	b8 11 00 00 00       	mov    $0x11,%eax
    a4de:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a4df:	eb 00                	jmp    a4e1 <PIC_remap+0x54>
    a4e1:	eb 00                	jmp    a4e3 <PIC_remap+0x56>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a4e3:	ba 21 00 00 00       	mov    $0x21,%edx
    a4e8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a4ec:	ee                   	out    %al,(%dx)
    io_wait;
    a4ed:	eb 00                	jmp    a4ef <PIC_remap+0x62>
    a4ef:	eb 00                	jmp    a4f1 <PIC_remap+0x64>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a4f1:	ba a1 00 00 00       	mov    $0xa1,%edx
    a4f6:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a4fa:	ee                   	out    %al,(%dx)
    io_wait;
    a4fb:	eb 00                	jmp    a4fd <PIC_remap+0x70>
    a4fd:	eb 00                	jmp    a4ff <PIC_remap+0x72>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a4ff:	ba 21 00 00 00       	mov    $0x21,%edx
    a504:	b8 04 00 00 00       	mov    $0x4,%eax
    a509:	ee                   	out    %al,(%dx)
    io_wait;
    a50a:	eb 00                	jmp    a50c <PIC_remap+0x7f>
    a50c:	eb 00                	jmp    a50e <PIC_remap+0x81>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a50e:	ba a1 00 00 00       	mov    $0xa1,%edx
    a513:	b8 02 00 00 00       	mov    $0x2,%eax
    a518:	ee                   	out    %al,(%dx)
    io_wait;
    a519:	eb 00                	jmp    a51b <PIC_remap+0x8e>
    a51b:	eb 00                	jmp    a51d <PIC_remap+0x90>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a51d:	ba 21 00 00 00       	mov    $0x21,%edx
    a522:	b8 01 00 00 00       	mov    $0x1,%eax
    a527:	ee                   	out    %al,(%dx)
    io_wait;
    a528:	eb 00                	jmp    a52a <PIC_remap+0x9d>
    a52a:	eb 00                	jmp    a52c <PIC_remap+0x9f>

    outb(PIC2_DATA, ICW4_8086);
    a52c:	ba a1 00 00 00       	mov    $0xa1,%edx
    a531:	b8 01 00 00 00       	mov    $0x1,%eax
    a536:	ee                   	out    %al,(%dx)
    io_wait;
    a537:	eb 00                	jmp    a539 <PIC_remap+0xac>
    a539:	eb 00                	jmp    a53b <PIC_remap+0xae>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a53b:	ba 21 00 00 00       	mov    $0x21,%edx
    a540:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a544:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a545:	ba a1 00 00 00       	mov    $0xa1,%edx
    a54a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a54e:	ee                   	out    %al,(%dx)
}
    a54f:	90                   	nop
    a550:	c9                   	leave  
    a551:	c3                   	ret    

0000a552 <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a552:	55                   	push   %ebp
    a553:	89 e5                	mov    %esp,%ebp
    a555:	53                   	push   %ebx
    a556:	83 ec 14             	sub    $0x14,%esp
    a559:	8b 45 08             	mov    0x8(%ebp),%eax
    a55c:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a55f:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a563:	77 08                	ja     a56d <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a565:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a56b:	eb 0a                	jmp    a577 <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a56d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a573:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a577:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a57b:	89 c2                	mov    %eax,%edx
    a57d:	ec                   	in     (%dx),%al
    a57e:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a582:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a586:	89 c3                	mov    %eax,%ebx
    a588:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a58c:	ba 01 00 00 00       	mov    $0x1,%edx
    a591:	89 c1                	mov    %eax,%ecx
    a593:	d3 e2                	shl    %cl,%edx
    a595:	89 d0                	mov    %edx,%eax
    a597:	09 d8                	or     %ebx,%eax
    a599:	88 45 f7             	mov    %al,-0x9(%ebp)

    outb(port, value);
    a59c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a5a0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a5a4:	ee                   	out    %al,(%dx)
}
    a5a5:	90                   	nop
    a5a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a5a9:	c9                   	leave  
    a5aa:	c3                   	ret    

0000a5ab <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a5ab:	55                   	push   %ebp
    a5ac:	89 e5                	mov    %esp,%ebp
    a5ae:	53                   	push   %ebx
    a5af:	83 ec 14             	sub    $0x14,%esp
    a5b2:	8b 45 08             	mov    0x8(%ebp),%eax
    a5b5:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a5b8:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a5bc:	77 09                	ja     a5c7 <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a5be:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a5c5:	eb 0b                	jmp    a5d2 <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a5c7:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a5ce:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a5d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a5d5:	89 c2                	mov    %eax,%edx
    a5d7:	ec                   	in     (%dx),%al
    a5d8:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a5dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a5e0:	89 c3                	mov    %eax,%ebx
    a5e2:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a5e6:	ba 01 00 00 00       	mov    $0x1,%edx
    a5eb:	89 c1                	mov    %eax,%ecx
    a5ed:	d3 e2                	shl    %cl,%edx
    a5ef:	89 d0                	mov    %edx,%eax
    a5f1:	f7 d0                	not    %eax
    a5f3:	21 d8                	and    %ebx,%eax
    a5f5:	88 45 f5             	mov    %al,-0xb(%ebp)

    outb(port, value);
    a5f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a5fb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a5ff:	ee                   	out    %al,(%dx)
}
    a600:	90                   	nop
    a601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a604:	c9                   	leave  
    a605:	c3                   	ret    

0000a606 <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a606:	55                   	push   %ebp
    a607:	89 e5                	mov    %esp,%ebp
    a609:	83 ec 14             	sub    $0x14,%esp
    a60c:	8b 45 08             	mov    0x8(%ebp),%eax
    a60f:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a612:	ba 20 00 00 00       	mov    $0x20,%edx
    a617:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a61b:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a61c:	ba a0 00 00 00       	mov    $0xa0,%edx
    a621:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a625:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a626:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a62b:	89 c2                	mov    %eax,%edx
    a62d:	ec                   	in     (%dx),%al
    a62e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a632:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a636:	98                   	cwtl   
    a637:	c1 e0 08             	shl    $0x8,%eax
    a63a:	89 c1                	mov    %eax,%ecx
    a63c:	b8 20 00 00 00       	mov    $0x20,%eax
    a641:	89 c2                	mov    %eax,%edx
    a643:	ec                   	in     (%dx),%al
    a644:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a648:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a64c:	09 c8                	or     %ecx,%eax
}
    a64e:	c9                   	leave  
    a64f:	c3                   	ret    

0000a650 <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a650:	55                   	push   %ebp
    a651:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a653:	6a 0b                	push   $0xb
    a655:	e8 ac ff ff ff       	call   a606 <__pic_get_irq_reg>
    a65a:	83 c4 04             	add    $0x4,%esp
}
    a65d:	c9                   	leave  
    a65e:	c3                   	ret    

0000a65f <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a65f:	55                   	push   %ebp
    a660:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a662:	6a 0a                	push   $0xa
    a664:	e8 9d ff ff ff       	call   a606 <__pic_get_irq_reg>
    a669:	83 c4 04             	add    $0x4,%esp
}
    a66c:	c9                   	leave  
    a66d:	c3                   	ret    

0000a66e <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a66e:	55                   	push   %ebp
    a66f:	89 e5                	mov    %esp,%ebp
    a671:	83 ec 14             	sub    $0x14,%esp
    a674:	8b 45 08             	mov    0x8(%ebp),%eax
    a677:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a67a:	e8 d1 ff ff ff       	call   a650 <pic_get_isr>
    a67f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a683:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a687:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a68b:	74 13                	je     a6a0 <spurious_IRQ+0x32>
    a68d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a691:	0f b6 c0             	movzbl %al,%eax
    a694:	83 e0 07             	and    $0x7,%eax
    a697:	50                   	push   %eax
    a698:	e8 c5 fd ff ff       	call   a462 <PIC_sendEOI>
    a69d:	83 c4 04             	add    $0x4,%esp
    a6a0:	90                   	nop
    a6a1:	c9                   	leave  
    a6a2:	c3                   	ret    

0000a6a3 <conserv_status_byte>:
uint32_t compteur   = 0;
uint8_t  frequency  = 0;
uint8_t  status_PIT = 0;

void conserv_status_byte()
{
    a6a3:	55                   	push   %ebp
    a6a4:	89 e5                	mov    %esp,%ebp
    a6a6:	83 ec 10             	sub    $0x10,%esp
    set_pit_count(PIT_0, PIT_reload_value);
    a6a9:	ba 43 00 00 00       	mov    $0x43,%edx
    a6ae:	b8 40 00 00 00       	mov    $0x40,%eax
    a6b3:	ee                   	out    %al,(%dx)
    a6b4:	b8 40 00 00 00       	mov    $0x40,%eax
    a6b9:	89 c2                	mov    %eax,%edx
    a6bb:	ec                   	in     (%dx),%al
    a6bc:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a6c0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a6c4:	88 45 f6             	mov    %al,-0xa(%ebp)
    a6c7:	b8 40 00 00 00       	mov    $0x40,%eax
    a6cc:	89 c2                	mov    %eax,%edx
    a6ce:	ec                   	in     (%dx),%al
    a6cf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a6d3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a6d7:	88 45 f7             	mov    %al,-0x9(%ebp)
    a6da:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a6de:	66 98                	cbtw   
    a6e0:	ba 40 00 00 00       	mov    $0x40,%edx
    a6e5:	ee                   	out    %al,(%dx)
    a6e6:	a1 74 32 02 00       	mov    0x23274,%eax
    a6eb:	c1 f8 08             	sar    $0x8,%eax
    a6ee:	ba 40 00 00 00       	mov    $0x40,%edx
    a6f3:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a6f4:	ba 43 00 00 00       	mov    $0x43,%edx
    a6f9:	b8 40 00 00 00       	mov    $0x40,%eax
    a6fe:	ee                   	out    %al,(%dx)
    a6ff:	b8 40 00 00 00       	mov    $0x40,%eax
    a704:	89 c2                	mov    %eax,%edx
    a706:	ec                   	in     (%dx),%al
    a707:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a70b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a70f:	88 45 f4             	mov    %al,-0xc(%ebp)
    a712:	b8 40 00 00 00       	mov    $0x40,%eax
    a717:	89 c2                	mov    %eax,%edx
    a719:	ec                   	in     (%dx),%al
    a71a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a71e:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a722:	88 45 f5             	mov    %al,-0xb(%ebp)
    a725:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a729:	66 98                	cbtw   
    a72b:	ba 43 00 00 00       	mov    $0x43,%edx
    a730:	ee                   	out    %al,(%dx)
    a731:	ba 43 00 00 00       	mov    $0x43,%edx
    a736:	b8 34 00 00 00       	mov    $0x34,%eax
    a73b:	ee                   	out    %al,(%dx)
}
    a73c:	90                   	nop
    a73d:	c9                   	leave  
    a73e:	c3                   	ret    

0000a73f <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a73f:	55                   	push   %ebp
    a740:	89 e5                	mov    %esp,%ebp
    a742:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a745:	0f b6 05 40 31 02 00 	movzbl 0x23140,%eax
    a74c:	3c 01                	cmp    $0x1,%al
    a74e:	75 27                	jne    a777 <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a750:	a1 44 31 02 00       	mov    0x23144,%eax
    a755:	85 c0                	test   %eax,%eax
    a757:	75 11                	jne    a76a <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a759:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    a760:	01 00 00 
            __switch();
    a763:	e8 09 0b 00 00       	call   b271 <__switch>
        } else
            sheduler.task_timer--;
    }
}
    a768:	eb 0d                	jmp    a777 <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a76a:	a1 44 31 02 00       	mov    0x23144,%eax
    a76f:	83 e8 01             	sub    $0x1,%eax
    a772:	a3 44 31 02 00       	mov    %eax,0x23144
}
    a777:	90                   	nop
    a778:	c9                   	leave  
    a779:	c3                   	ret    

0000a77a <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a77a:	55                   	push   %ebp
    a77b:	89 e5                	mov    %esp,%ebp
    a77d:	83 ec 28             	sub    $0x28,%esp
    a780:	8b 45 08             	mov    0x8(%ebp),%eax
    a783:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a787:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a78b:	a2 04 20 01 00       	mov    %al,0x12004
    calculate_frequency();
    a790:	e8 27 0d 00 00       	call   b4bc <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a795:	ba 43 00 00 00       	mov    $0x43,%edx
    a79a:	b8 40 00 00 00       	mov    $0x40,%eax
    a79f:	ee                   	out    %al,(%dx)
    a7a0:	b8 40 00 00 00       	mov    $0x40,%eax
    a7a5:	89 c2                	mov    %eax,%edx
    a7a7:	ec                   	in     (%dx),%al
    a7a8:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a7ac:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a7b0:	88 45 ee             	mov    %al,-0x12(%ebp)
    a7b3:	b8 40 00 00 00       	mov    $0x40,%eax
    a7b8:	89 c2                	mov    %eax,%edx
    a7ba:	ec                   	in     (%dx),%al
    a7bb:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    a7bf:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
    a7c3:	88 45 ef             	mov    %al,-0x11(%ebp)
    a7c6:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    a7ca:	66 98                	cbtw   
    a7cc:	ba 43 00 00 00       	mov    $0x43,%edx
    a7d1:	ee                   	out    %al,(%dx)
    a7d2:	ba 43 00 00 00       	mov    $0x43,%edx
    a7d7:	b8 34 00 00 00       	mov    $0x34,%eax
    a7dc:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a7dd:	ba 43 00 00 00       	mov    $0x43,%edx
    a7e2:	b8 40 00 00 00       	mov    $0x40,%eax
    a7e7:	ee                   	out    %al,(%dx)
    a7e8:	b8 40 00 00 00       	mov    $0x40,%eax
    a7ed:	89 c2                	mov    %eax,%edx
    a7ef:	ec                   	in     (%dx),%al
    a7f0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a7f4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a7f8:	88 45 ec             	mov    %al,-0x14(%ebp)
    a7fb:	b8 40 00 00 00       	mov    $0x40,%eax
    a800:	89 c2                	mov    %eax,%edx
    a802:	ec                   	in     (%dx),%al
    a803:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a807:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a80b:	88 45 ed             	mov    %al,-0x13(%ebp)
    a80e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a812:	66 98                	cbtw   
    a814:	ba 40 00 00 00       	mov    $0x40,%edx
    a819:	ee                   	out    %al,(%dx)
    a81a:	a1 74 32 02 00       	mov    0x23274,%eax
    a81f:	c1 f8 08             	sar    $0x8,%eax
    a822:	ba 40 00 00 00       	mov    $0x40,%edx
    a827:	ee                   	out    %al,(%dx)
}
    a828:	90                   	nop
    a829:	c9                   	leave  
    a82a:	c3                   	ret    

0000a82b <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a82b:	55                   	push   %ebp
    a82c:	89 e5                	mov    %esp,%ebp
    a82e:	83 ec 14             	sub    $0x14,%esp
    a831:	8b 45 08             	mov    0x8(%ebp),%eax
    a834:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a837:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a83b:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a83f:	83 f8 42             	cmp    $0x42,%eax
    a842:	74 1d                	je     a861 <read_back_channel+0x36>
    a844:	83 f8 42             	cmp    $0x42,%eax
    a847:	7f 1e                	jg     a867 <read_back_channel+0x3c>
    a849:	83 f8 40             	cmp    $0x40,%eax
    a84c:	74 07                	je     a855 <read_back_channel+0x2a>
    a84e:	83 f8 41             	cmp    $0x41,%eax
    a851:	74 08                	je     a85b <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a853:	eb 12                	jmp    a867 <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a855:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a859:	eb 0d                	jmp    a868 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a85b:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a85f:	eb 07                	jmp    a868 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a861:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a865:	eb 01                	jmp    a868 <read_back_channel+0x3d>
        break;
    a867:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a868:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a86c:	ba 43 00 00 00       	mov    $0x43,%edx
    a871:	b8 40 00 00 00       	mov    $0x40,%eax
    a876:	ee                   	out    %al,(%dx)
    a877:	b8 40 00 00 00       	mov    $0x40,%eax
    a87c:	89 c2                	mov    %eax,%edx
    a87e:	ec                   	in     (%dx),%al
    a87f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a883:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a887:	88 45 f4             	mov    %al,-0xc(%ebp)
    a88a:	b8 40 00 00 00       	mov    $0x40,%eax
    a88f:	89 c2                	mov    %eax,%edx
    a891:	ec                   	in     (%dx),%al
    a892:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a896:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a89a:	88 45 f5             	mov    %al,-0xb(%ebp)
    a89d:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a8a1:	66 98                	cbtw   
    a8a3:	ba 43 00 00 00       	mov    $0x43,%edx
    a8a8:	ee                   	out    %al,(%dx)
    a8a9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a8ad:	c1 f8 08             	sar    $0x8,%eax
    a8b0:	ba 43 00 00 00       	mov    $0x43,%edx
    a8b5:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a8b6:	ba 43 00 00 00       	mov    $0x43,%edx
    a8bb:	b8 40 00 00 00       	mov    $0x40,%eax
    a8c0:	ee                   	out    %al,(%dx)
    a8c1:	b8 40 00 00 00       	mov    $0x40,%eax
    a8c6:	89 c2                	mov    %eax,%edx
    a8c8:	ec                   	in     (%dx),%al
    a8c9:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a8cd:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a8d1:	88 45 f2             	mov    %al,-0xe(%ebp)
    a8d4:	b8 40 00 00 00       	mov    $0x40,%eax
    a8d9:	89 c2                	mov    %eax,%edx
    a8db:	ec                   	in     (%dx),%al
    a8dc:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a8e0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a8e4:	88 45 f3             	mov    %al,-0xd(%ebp)
    a8e7:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a8eb:	66 98                	cbtw   
    a8ed:	c9                   	leave  
    a8ee:	c3                   	ret    

0000a8ef <read_ebp>:
                 : "r"(eflags));
}

static inline uint32_t
read_ebp(void)
{
    a8ef:	55                   	push   %ebp
    a8f0:	89 e5                	mov    %esp,%ebp
    a8f2:	83 ec 10             	sub    $0x10,%esp
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
    a8f5:	89 e8                	mov    %ebp,%eax
    a8f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(ebp));
    return ebp;
    a8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a8fd:	c9                   	leave  
    a8fe:	c3                   	ret    

0000a8ff <x86_memset>:
{
    asm volatile("movl %0 , %%esp" ::"r"(esp));
}

void* x86_memset(void* addr, uint8_t data, size_t size)
{
    a8ff:	55                   	push   %ebp
    a900:	89 e5                	mov    %esp,%ebp
    a902:	57                   	push   %edi
    a903:	83 ec 04             	sub    $0x4,%esp
    a906:	8b 45 0c             	mov    0xc(%ebp),%eax
    a909:	88 45 f8             	mov    %al,-0x8(%ebp)
    __asm__("cld; rep stosb\n" ::"D"(addr), "a"(data), "c"(size)
    a90c:	8b 55 08             	mov    0x8(%ebp),%edx
    a90f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    a913:	8b 4d 10             	mov    0x10(%ebp),%ecx
    a916:	89 d7                	mov    %edx,%edi
    a918:	fc                   	cld    
    a919:	f3 aa                	rep stos %al,%es:(%edi)
            : "cc", "memory");

    return addr;
    a91b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    a91e:	8b 7d fc             	mov    -0x4(%ebp),%edi
    a921:	c9                   	leave  
    a922:	c3                   	ret    

0000a923 <backtrace>:
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    a923:	55                   	push   %ebp
    a924:	89 e5                	mov    %esp,%ebp
    a926:	83 ec 18             	sub    $0x18,%esp
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;
    a929:	e8 c1 ff ff ff       	call   a8ef <read_ebp>
    a92e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a931:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a934:	83 c0 04             	add    $0x4,%eax
    a937:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp != 0) {
    a93a:	eb 30                	jmp    a96c <backtrace+0x49>
        kprintf("ebp %x eip %x\n", ebp, *eip);
    a93c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a93f:	8b 00                	mov    (%eax),%eax
    a941:	83 ec 04             	sub    $0x4,%esp
    a944:	50                   	push   %eax
    a945:	ff 75 f4             	pushl  -0xc(%ebp)
    a948:	68 6b f1 00 00       	push   $0xf16b
    a94d:	e8 0c 01 00 00       	call   aa5e <kprintf>
    a952:	83 c4 10             	add    $0x10,%esp

        ptr = (int*)(ebp);
    a955:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a958:	89 45 ec             	mov    %eax,-0x14(%ebp)

        ebp = (int)(*ptr);
    a95b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a95e:	8b 00                	mov    (%eax),%eax
    a960:	89 45 f4             	mov    %eax,-0xc(%ebp)

        eip = (int*)(ebp + 4);
    a963:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a966:	83 c0 04             	add    $0x4,%eax
    a969:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (ebp != 0) {
    a96c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    a970:	75 ca                	jne    a93c <backtrace+0x19>
    }
    return 0;
    a972:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a977:	c9                   	leave  
    a978:	c3                   	ret    

0000a979 <mon_help>:

int mon_help(int argc, char** argv)
{
    a979:	55                   	push   %ebp
    a97a:	89 e5                	mov    %esp,%ebp
    a97c:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 2; i++)
    a97f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a986:	eb 3c                	jmp    a9c4 <mon_help+0x4b>
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    a988:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a98b:	89 d0                	mov    %edx,%eax
    a98d:	01 c0                	add    %eax,%eax
    a98f:	01 d0                	add    %edx,%eax
    a991:	c1 e0 02             	shl    $0x2,%eax
    a994:	05 68 b7 00 00       	add    $0xb768,%eax
    a999:	8b 10                	mov    (%eax),%edx
    a99b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    a99e:	89 c8                	mov    %ecx,%eax
    a9a0:	01 c0                	add    %eax,%eax
    a9a2:	01 c8                	add    %ecx,%eax
    a9a4:	c1 e0 02             	shl    $0x2,%eax
    a9a7:	05 64 b7 00 00       	add    $0xb764,%eax
    a9ac:	8b 00                	mov    (%eax),%eax
    a9ae:	83 ec 04             	sub    $0x4,%esp
    a9b1:	52                   	push   %edx
    a9b2:	50                   	push   %eax
    a9b3:	68 7a f1 00 00       	push   $0xf17a
    a9b8:	e8 a1 00 00 00       	call   aa5e <kprintf>
    a9bd:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 2; i++)
    a9c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a9c4:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    a9c8:	7e be                	jle    a988 <mon_help+0xf>
    return 0;
    a9ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a9cf:	c9                   	leave  
    a9d0:	c3                   	ret    

0000a9d1 <monitor_service_keyboard>:

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    a9d1:	55                   	push   %ebp
    a9d2:	89 e5                	mov    %esp,%ebp
    a9d4:	83 ec 18             	sub    $0x18,%esp
    if (get_ASCII_code_keyboard() != '\0') {
    a9d7:	e8 91 f8 ff ff       	call   a26d <get_ASCII_code_keyboard>
    a9dc:	84 c0                	test   %al,%al
    a9de:	74 7b                	je     aa5b <monitor_service_keyboard+0x8a>
        int8_t code = get_ASCII_code_keyboard();
    a9e0:	e8 88 f8 ff ff       	call   a26d <get_ASCII_code_keyboard>
    a9e5:	88 45 f3             	mov    %al,-0xd(%ebp)
        if (code != '\n') {
    a9e8:	80 7d f3 0a          	cmpb   $0xa,-0xd(%ebp)
    a9ec:	74 25                	je     aa13 <monitor_service_keyboard+0x42>
            keyboard_code_monitor[keyboard_num] = code;
    a9ee:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a9f5:	0f be c0             	movsbl %al,%eax
    a9f8:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
    a9fc:	88 90 20 20 01 00    	mov    %dl,0x12020(%eax)
            keyboard_num++;
    aa02:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    aa09:	83 c0 01             	add    $0x1,%eax
    aa0c:	a2 1f 21 01 00       	mov    %al,0x1211f
            }

            keyboard_num = 0;
        }
    }
    aa11:	eb 48                	jmp    aa5b <monitor_service_keyboard+0x8a>
            for (i = 0; i < keyboard_num; i++) {
    aa13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    aa1a:	eb 29                	jmp    aa45 <monitor_service_keyboard+0x74>
                putchar(keyboard_code_monitor[i]);
    aa1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa1f:	05 20 20 01 00       	add    $0x12020,%eax
    aa24:	0f b6 00             	movzbl (%eax),%eax
    aa27:	0f b6 c0             	movzbl %al,%eax
    aa2a:	83 ec 0c             	sub    $0xc,%esp
    aa2d:	50                   	push   %eax
    aa2e:	e8 f6 e6 ff ff       	call   9129 <putchar>
    aa33:	83 c4 10             	add    $0x10,%esp
                keyboard_code_monitor[i] = 0;
    aa36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa39:	05 20 20 01 00       	add    $0x12020,%eax
    aa3e:	c6 00 00             	movb   $0x0,(%eax)
            for (i = 0; i < keyboard_num; i++) {
    aa41:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    aa45:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    aa4c:	0f be c0             	movsbl %al,%eax
    aa4f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    aa52:	7c c8                	jl     aa1c <monitor_service_keyboard+0x4b>
            keyboard_num = 0;
    aa54:	c6 05 1f 21 01 00 00 	movb   $0x0,0x1211f
    aa5b:	90                   	nop
    aa5c:	c9                   	leave  
    aa5d:	c3                   	ret    

0000aa5e <kprintf>:
#include <stdint.h>

extern void printf(const char* fmt, va_list arg);

void kprintf(const char* frmt, ...)
{
    aa5e:	55                   	push   %ebp
    aa5f:	89 e5                	mov    %esp,%ebp
    aa61:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    aa64:	8d 45 0c             	lea    0xc(%ebp),%eax
    aa67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    aa6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa6d:	83 ec 08             	sub    $0x8,%esp
    aa70:	50                   	push   %eax
    aa71:	ff 75 08             	pushl  0x8(%ebp)
    aa74:	e8 35 e7 ff ff       	call   91ae <printf>
    aa79:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    aa7c:	90                   	nop
    aa7d:	c9                   	leave  
    aa7e:	c3                   	ret    

0000aa7f <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    aa7f:	55                   	push   %ebp
    aa80:	89 e5                	mov    %esp,%ebp
    aa82:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    aa85:	b8 1b 00 00 00       	mov    $0x1b,%eax
    aa8a:	89 c1                	mov    %eax,%ecx
    aa8c:	0f 32                	rdmsr  
    aa8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    aa91:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    aa94:	8b 45 fc             	mov    -0x4(%ebp),%eax
    aa97:	c1 e0 05             	shl    $0x5,%eax
    aa9a:	89 c2                	mov    %eax,%edx
    aa9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aa9f:	01 d0                	add    %edx,%eax
}
    aaa1:	c9                   	leave  
    aaa2:	c3                   	ret    

0000aaa3 <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    aaa3:	55                   	push   %ebp
    aaa4:	89 e5                	mov    %esp,%ebp
    aaa6:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    aaa9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    aab0:	8b 45 08             	mov    0x8(%ebp),%eax
    aab3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    aab8:	80 cc 08             	or     $0x8,%ah
    aabb:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    aabe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aac1:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aac4:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    aac9:	0f 30                	wrmsr  
}
    aacb:	90                   	nop
    aacc:	c9                   	leave  
    aacd:	c3                   	ret    

0000aace <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    aace:	55                   	push   %ebp
    aacf:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    aad1:	8b 15 20 21 01 00    	mov    0x12120,%edx
    aad7:	8b 45 08             	mov    0x8(%ebp),%eax
    aada:	01 c0                	add    %eax,%eax
    aadc:	01 d0                	add    %edx,%eax
    aade:	0f b7 00             	movzwl (%eax),%eax
    aae1:	0f b7 c0             	movzwl %ax,%eax
}
    aae4:	5d                   	pop    %ebp
    aae5:	c3                   	ret    

0000aae6 <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    aae6:	55                   	push   %ebp
    aae7:	89 e5                	mov    %esp,%ebp
    aae9:	83 ec 04             	sub    $0x4,%esp
    aaec:	8b 45 0c             	mov    0xc(%ebp),%eax
    aaef:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    aaf3:	8b 15 20 21 01 00    	mov    0x12120,%edx
    aaf9:	8b 45 08             	mov    0x8(%ebp),%eax
    aafc:	01 c0                	add    %eax,%eax
    aafe:	01 c2                	add    %eax,%edx
    ab00:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    ab04:	66 89 02             	mov    %ax,(%edx)
}
    ab07:	90                   	nop
    ab08:	c9                   	leave  
    ab09:	c3                   	ret    

0000ab0a <enable_local_apic>:

void enable_local_apic()
{
    ab0a:	55                   	push   %ebp
    ab0b:	89 e5                	mov    %esp,%ebp
    ab0d:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    ab10:	83 ec 08             	sub    $0x8,%esp
    ab13:	68 fb 03 00 00       	push   $0x3fb
    ab18:	68 00 d0 00 00       	push   $0xd000
    ab1d:	e8 5c f7 ff ff       	call   a27e <create_page_table>
    ab22:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    ab25:	e8 55 ff ff ff       	call   aa7f <get_apic_base>
    ab2a:	a3 20 21 01 00       	mov    %eax,0x12120

    set_apic_base(get_apic_base());
    ab2f:	e8 4b ff ff ff       	call   aa7f <get_apic_base>
    ab34:	83 ec 0c             	sub    $0xc,%esp
    ab37:	50                   	push   %eax
    ab38:	e8 66 ff ff ff       	call   aaa3 <set_apic_base>
    ab3d:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    ab40:	83 ec 0c             	sub    $0xc,%esp
    ab43:	68 f0 00 00 00       	push   $0xf0
    ab48:	e8 81 ff ff ff       	call   aace <cpu_ReadLocalAPICReg>
    ab4d:	83 c4 10             	add    $0x10,%esp
    ab50:	80 cc 01             	or     $0x1,%ah
    ab53:	0f b7 c0             	movzwl %ax,%eax
    ab56:	83 ec 08             	sub    $0x8,%esp
    ab59:	50                   	push   %eax
    ab5a:	68 f0 00 00 00       	push   $0xf0
    ab5f:	e8 82 ff ff ff       	call   aae6 <cpu_SetLocalAPICReg>
    ab64:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    ab67:	83 ec 08             	sub    $0x8,%esp
    ab6a:	6a 02                	push   $0x2
    ab6c:	6a 20                	push   $0x20
    ab6e:	e8 73 ff ff ff       	call   aae6 <cpu_SetLocalAPICReg>
    ab73:	83 c4 10             	add    $0x10,%esp
}
    ab76:	90                   	nop
    ab77:	c9                   	leave  
    ab78:	c3                   	ret    

0000ab79 <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    ab79:	55                   	push   %ebp
    ab7a:	89 e5                	mov    %esp,%ebp
    ab7c:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    ab7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    ab86:	eb 49                	jmp    abd1 <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    ab88:	8b 55 fc             	mov    -0x4(%ebp),%edx
    ab8b:	89 d0                	mov    %edx,%eax
    ab8d:	01 c0                	add    %eax,%eax
    ab8f:	01 d0                	add    %edx,%eax
    ab91:	c1 e0 02             	shl    $0x2,%eax
    ab94:	05 40 21 01 00       	add    $0x12140,%eax
    ab99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    ab9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aba2:	89 d0                	mov    %edx,%eax
    aba4:	01 c0                	add    %eax,%eax
    aba6:	01 d0                	add    %edx,%eax
    aba8:	c1 e0 02             	shl    $0x2,%eax
    abab:	05 48 21 01 00       	add    $0x12148,%eax
    abb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    abb6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    abb9:	89 d0                	mov    %edx,%eax
    abbb:	01 c0                	add    %eax,%eax
    abbd:	01 d0                	add    %edx,%eax
    abbf:	c1 e0 02             	shl    $0x2,%eax
    abc2:	05 44 21 01 00       	add    $0x12144,%eax
    abc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    abcd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    abd1:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    abd8:	7e ae                	jle    ab88 <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    abda:	c7 05 40 e1 01 00 40 	movl   $0x12140,0x1e140
    abe1:	21 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    abe4:	90                   	nop
    abe5:	c9                   	leave  
    abe6:	c3                   	ret    

0000abe7 <kmalloc>:

void* kmalloc(uint32_t size)
{
    abe7:	55                   	push   %ebp
    abe8:	89 e5                	mov    %esp,%ebp
    abea:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    abed:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abf2:	8b 00                	mov    (%eax),%eax
    abf4:	85 c0                	test   %eax,%eax
    abf6:	75 37                	jne    ac2f <kmalloc+0x48>
        _head_vmm_->address = KERNEL__VM_BASE;
    abf8:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abfd:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ac02:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    ac04:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ac09:	8b 55 08             	mov    0x8(%ebp),%edx
    ac0c:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    ac0f:	8b 45 08             	mov    0x8(%ebp),%eax
    ac12:	83 ec 04             	sub    $0x4,%esp
    ac15:	50                   	push   %eax
    ac16:	6a 00                	push   $0x0
    ac18:	68 60 e1 01 00       	push   $0x1e160
    ac1d:	e8 7a e8 ff ff       	call   949c <memset>
    ac22:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    ac25:	b8 60 e1 01 00       	mov    $0x1e160,%eax
    ac2a:	e9 7e 01 00 00       	jmp    adad <kmalloc+0x1c6>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    ac2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ac36:	eb 04                	jmp    ac3c <kmalloc+0x55>
        i++;
    ac38:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ac3c:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    ac43:	77 17                	ja     ac5c <kmalloc+0x75>
    ac45:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ac48:	89 d0                	mov    %edx,%eax
    ac4a:	01 c0                	add    %eax,%eax
    ac4c:	01 d0                	add    %edx,%eax
    ac4e:	c1 e0 02             	shl    $0x2,%eax
    ac51:	05 40 21 01 00       	add    $0x12140,%eax
    ac56:	8b 00                	mov    (%eax),%eax
    ac58:	85 c0                	test   %eax,%eax
    ac5a:	75 dc                	jne    ac38 <kmalloc+0x51>

    _new_item_ = &MM_BLOCK[i];
    ac5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ac5f:	89 d0                	mov    %edx,%eax
    ac61:	01 c0                	add    %eax,%eax
    ac63:	01 d0                	add    %edx,%eax
    ac65:	c1 e0 02             	shl    $0x2,%eax
    ac68:	05 40 21 01 00       	add    $0x12140,%eax
    ac6d:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    ac70:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ac75:	8b 00                	mov    (%eax),%eax
    ac77:	b9 60 e1 01 00       	mov    $0x1e160,%ecx
    ac7c:	8b 55 08             	mov    0x8(%ebp),%edx
    ac7f:	01 ca                	add    %ecx,%edx
    ac81:	39 d0                	cmp    %edx,%eax
    ac83:	74 48                	je     accd <kmalloc+0xe6>
        _new_item_->address = KERNEL__VM_BASE;
    ac85:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ac8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac8d:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    ac8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac92:	8b 55 08             	mov    0x8(%ebp),%edx
    ac95:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    ac98:	8b 15 40 e1 01 00    	mov    0x1e140,%edx
    ac9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aca1:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    aca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aca7:	a3 40 e1 01 00       	mov    %eax,0x1e140

        memset((void*)_new_item_->address, 0, size);
    acac:	8b 45 08             	mov    0x8(%ebp),%eax
    acaf:	8b 55 ec             	mov    -0x14(%ebp),%edx
    acb2:	8b 12                	mov    (%edx),%edx
    acb4:	83 ec 04             	sub    $0x4,%esp
    acb7:	50                   	push   %eax
    acb8:	6a 00                	push   $0x0
    acba:	52                   	push   %edx
    acbb:	e8 dc e7 ff ff       	call   949c <memset>
    acc0:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    acc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acc6:	8b 00                	mov    (%eax),%eax
    acc8:	e9 e0 00 00 00       	jmp    adad <kmalloc+0x1c6>
    }

    tmp = _head_vmm_;
    accd:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acd2:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    acd5:	eb 27                	jmp    acfe <kmalloc+0x117>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    acd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acda:	8b 40 08             	mov    0x8(%eax),%eax
    acdd:	8b 10                	mov    (%eax),%edx
    acdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ace2:	8b 08                	mov    (%eax),%ecx
    ace4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ace7:	8b 40 04             	mov    0x4(%eax),%eax
    acea:	01 c1                	add    %eax,%ecx
    acec:	8b 45 08             	mov    0x8(%ebp),%eax
    acef:	01 c8                	add    %ecx,%eax
    acf1:	39 c2                	cmp    %eax,%edx
    acf3:	73 15                	jae    ad0a <kmalloc+0x123>
            break;

        tmp = tmp->next;
    acf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acf8:	8b 40 08             	mov    0x8(%eax),%eax
    acfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    acfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad01:	8b 40 08             	mov    0x8(%eax),%eax
    ad04:	85 c0                	test   %eax,%eax
    ad06:	75 cf                	jne    acd7 <kmalloc+0xf0>
    ad08:	eb 01                	jmp    ad0b <kmalloc+0x124>
            break;
    ad0a:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    ad0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad0e:	8b 40 08             	mov    0x8(%eax),%eax
    ad11:	85 c0                	test   %eax,%eax
    ad13:	75 4c                	jne    ad61 <kmalloc+0x17a>
        _new_item_->size = size;
    ad15:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad18:	8b 55 08             	mov    0x8(%ebp),%edx
    ad1b:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ad1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad21:	8b 10                	mov    (%eax),%edx
    ad23:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad26:	8b 40 04             	mov    0x4(%eax),%eax
    ad29:	01 c2                	add    %eax,%edx
    ad2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad2e:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    ad30:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    ad3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad40:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ad43:	8b 45 08             	mov    0x8(%ebp),%eax
    ad46:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad49:	8b 12                	mov    (%edx),%edx
    ad4b:	83 ec 04             	sub    $0x4,%esp
    ad4e:	50                   	push   %eax
    ad4f:	6a 00                	push   $0x0
    ad51:	52                   	push   %edx
    ad52:	e8 45 e7 ff ff       	call   949c <memset>
    ad57:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ad5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad5d:	8b 00                	mov    (%eax),%eax
    ad5f:	eb 4c                	jmp    adad <kmalloc+0x1c6>
    }

    else {
        _new_item_->size = size;
    ad61:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad64:	8b 55 08             	mov    0x8(%ebp),%edx
    ad67:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ad6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad6d:	8b 10                	mov    (%eax),%edx
    ad6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad72:	8b 40 04             	mov    0x4(%eax),%eax
    ad75:	01 c2                	add    %eax,%edx
    ad77:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad7a:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    ad7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad7f:	8b 50 08             	mov    0x8(%eax),%edx
    ad82:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad85:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    ad88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad8e:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ad91:	8b 45 08             	mov    0x8(%ebp),%eax
    ad94:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad97:	8b 12                	mov    (%edx),%edx
    ad99:	83 ec 04             	sub    $0x4,%esp
    ad9c:	50                   	push   %eax
    ad9d:	6a 00                	push   $0x0
    ad9f:	52                   	push   %edx
    ada0:	e8 f7 e6 ff ff       	call   949c <memset>
    ada5:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ada8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    adab:	8b 00                	mov    (%eax),%eax
    }
}
    adad:	c9                   	leave  
    adae:	c3                   	ret    

0000adaf <free>:

void free(virtaddr_t _addr__)
{
    adaf:	55                   	push   %ebp
    adb0:	89 e5                	mov    %esp,%ebp
    adb2:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    adb5:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adba:	8b 00                	mov    (%eax),%eax
    adbc:	39 45 08             	cmp    %eax,0x8(%ebp)
    adbf:	75 29                	jne    adea <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    adc1:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    adcc:	a1 40 e1 01 00       	mov    0x1e140,%eax
    add1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    add8:	a1 40 e1 01 00       	mov    0x1e140,%eax
    addd:	8b 40 08             	mov    0x8(%eax),%eax
    ade0:	a3 40 e1 01 00       	mov    %eax,0x1e140
        return;
    ade5:	e9 ac 00 00 00       	jmp    ae96 <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    adea:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adef:	8b 40 08             	mov    0x8(%eax),%eax
    adf2:	85 c0                	test   %eax,%eax
    adf4:	75 16                	jne    ae0c <free+0x5d>
    adf6:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adfb:	8b 00                	mov    (%eax),%eax
    adfd:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae00:	75 0a                	jne    ae0c <free+0x5d>
        init_vmm();
    ae02:	e8 72 fd ff ff       	call   ab79 <init_vmm>
        return;
    ae07:	e9 8a 00 00 00       	jmp    ae96 <free+0xe7>
    }

    tmp = _head_vmm_;
    ae0c:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ae11:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ae14:	eb 0f                	jmp    ae25 <free+0x76>
        tmp_prev = tmp;
    ae16:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae19:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    ae1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae1f:	8b 40 08             	mov    0x8(%eax),%eax
    ae22:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ae25:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae28:	8b 40 08             	mov    0x8(%eax),%eax
    ae2b:	85 c0                	test   %eax,%eax
    ae2d:	74 0a                	je     ae39 <free+0x8a>
    ae2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae32:	8b 00                	mov    (%eax),%eax
    ae34:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae37:	75 dd                	jne    ae16 <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ae39:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae3c:	8b 40 08             	mov    0x8(%eax),%eax
    ae3f:	85 c0                	test   %eax,%eax
    ae41:	75 29                	jne    ae6c <free+0xbd>
    ae43:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae46:	8b 00                	mov    (%eax),%eax
    ae48:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae4b:	75 1f                	jne    ae6c <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ae4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ae56:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ae60:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ae63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ae6a:	eb 2a                	jmp    ae96 <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ae6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae6f:	8b 00                	mov    (%eax),%eax
    ae71:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae74:	75 20                	jne    ae96 <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ae76:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ae7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ae89:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae8c:	8b 50 08             	mov    0x8(%eax),%edx
    ae8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ae92:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ae95:	90                   	nop
    }
    ae96:	c9                   	leave  
    ae97:	c3                   	ret    

0000ae98 <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ae98:	55                   	push   %ebp
    ae99:	89 e5                	mov    %esp,%ebp
    ae9b:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ae9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    aea5:	eb 49                	jmp    aef0 <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    aea7:	ba 83 f1 00 00       	mov    $0xf183,%edx
    aeac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aeaf:	c1 e0 04             	shl    $0x4,%eax
    aeb2:	05 40 f1 01 00       	add    $0x1f140,%eax
    aeb7:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    aeb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aebc:	c1 e0 04             	shl    $0x4,%eax
    aebf:	05 44 f1 01 00       	add    $0x1f144,%eax
    aec4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    aeca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aecd:	c1 e0 04             	shl    $0x4,%eax
    aed0:	05 4c f1 01 00       	add    $0x1f14c,%eax
    aed5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    aedb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aede:	c1 e0 04             	shl    $0x4,%eax
    aee1:	05 48 f1 01 00       	add    $0x1f148,%eax
    aee6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    aeec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    aef0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    aef7:	76 ae                	jbe    aea7 <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    aef9:	83 ec 08             	sub    $0x8,%esp
    aefc:	6a 01                	push   $0x1
    aefe:	68 00 e0 00 00       	push   $0xe000
    af03:	e8 76 f3 ff ff       	call   a27e <create_page_table>
    af08:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    af0b:	c7 05 20 f1 01 00 40 	movl   $0x1f140,0x1f120
    af12:	f1 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    af15:	90                   	nop
    af16:	c9                   	leave  
    af17:	c3                   	ret    

0000af18 <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    af18:	55                   	push   %ebp
    af19:	89 e5                	mov    %esp,%ebp
    af1b:	53                   	push   %ebx
    af1c:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    af1f:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af24:	8b 00                	mov    (%eax),%eax
    af26:	ba 83 f1 00 00       	mov    $0xf183,%edx
    af2b:	39 d0                	cmp    %edx,%eax
    af2d:	75 40                	jne    af6f <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    af2f:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af34:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    af3a:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af3f:	8b 55 08             	mov    0x8(%ebp),%edx
    af42:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    af45:	8b 45 08             	mov    0x8(%ebp),%eax
    af48:	c1 e0 0c             	shl    $0xc,%eax
    af4b:	89 c2                	mov    %eax,%edx
    af4d:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af52:	8b 00                	mov    (%eax),%eax
    af54:	83 ec 04             	sub    $0x4,%esp
    af57:	52                   	push   %edx
    af58:	6a 00                	push   $0x0
    af5a:	50                   	push   %eax
    af5b:	e8 3c e5 ff ff       	call   949c <memset>
    af60:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    af63:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af68:	8b 00                	mov    (%eax),%eax
    af6a:	e9 ae 01 00 00       	jmp    b11d <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    af6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    af76:	eb 04                	jmp    af7c <alloc_page+0x64>
        i++;
    af78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    af7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    af7f:	c1 e0 04             	shl    $0x4,%eax
    af82:	05 40 f1 01 00       	add    $0x1f140,%eax
    af87:	8b 00                	mov    (%eax),%eax
    af89:	ba 83 f1 00 00       	mov    $0xf183,%edx
    af8e:	39 d0                	cmp    %edx,%eax
    af90:	74 09                	je     af9b <alloc_page+0x83>
    af92:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    af99:	76 dd                	jbe    af78 <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    af9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    af9e:	c1 e0 04             	shl    $0x4,%eax
    afa1:	05 40 f1 01 00       	add    $0x1f140,%eax
    afa6:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    afa9:	a1 20 f1 01 00       	mov    0x1f120,%eax
    afae:	8b 00                	mov    (%eax),%eax
    afb0:	8b 55 08             	mov    0x8(%ebp),%edx
    afb3:	81 c2 00 01 00 00    	add    $0x100,%edx
    afb9:	c1 e2 0c             	shl    $0xc,%edx
    afbc:	39 d0                	cmp    %edx,%eax
    afbe:	72 4c                	jb     b00c <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    afc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afc3:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    afc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afcc:	8b 55 08             	mov    0x8(%ebp),%edx
    afcf:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    afd2:	8b 15 20 f1 01 00    	mov    0x1f120,%edx
    afd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afdb:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    afde:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afe1:	a3 20 f1 01 00       	mov    %eax,0x1f120

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    afe6:	8b 45 08             	mov    0x8(%ebp),%eax
    afe9:	c1 e0 0c             	shl    $0xc,%eax
    afec:	89 c2                	mov    %eax,%edx
    afee:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aff1:	8b 00                	mov    (%eax),%eax
    aff3:	83 ec 04             	sub    $0x4,%esp
    aff6:	52                   	push   %edx
    aff7:	6a 00                	push   $0x0
    aff9:	50                   	push   %eax
    affa:	e8 9d e4 ff ff       	call   949c <memset>
    afff:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b002:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b005:	8b 00                	mov    (%eax),%eax
    b007:	e9 11 01 00 00       	jmp    b11d <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    b00c:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b011:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    b014:	eb 2a                	jmp    b040 <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    b016:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b019:	8b 40 0c             	mov    0xc(%eax),%eax
    b01c:	8b 10                	mov    (%eax),%edx
    b01e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b021:	8b 08                	mov    (%eax),%ecx
    b023:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b026:	8b 58 04             	mov    0x4(%eax),%ebx
    b029:	8b 45 08             	mov    0x8(%ebp),%eax
    b02c:	01 d8                	add    %ebx,%eax
    b02e:	c1 e0 0c             	shl    $0xc,%eax
    b031:	01 c8                	add    %ecx,%eax
    b033:	39 c2                	cmp    %eax,%edx
    b035:	77 15                	ja     b04c <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    b037:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b03a:	8b 40 0c             	mov    0xc(%eax),%eax
    b03d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    b040:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b043:	8b 40 0c             	mov    0xc(%eax),%eax
    b046:	85 c0                	test   %eax,%eax
    b048:	75 cc                	jne    b016 <alloc_page+0xfe>
    b04a:	eb 01                	jmp    b04d <alloc_page+0x135>
            break;
    b04c:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    b04d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b050:	8b 40 0c             	mov    0xc(%eax),%eax
    b053:	85 c0                	test   %eax,%eax
    b055:	75 5d                	jne    b0b4 <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    b057:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b05a:	8b 10                	mov    (%eax),%edx
    b05c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b05f:	8b 40 04             	mov    0x4(%eax),%eax
    b062:	c1 e0 0c             	shl    $0xc,%eax
    b065:	01 c2                	add    %eax,%edx
    b067:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b06a:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    b06c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b06f:	8b 55 08             	mov    0x8(%ebp),%edx
    b072:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    b075:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b078:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    b07f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b082:	8b 55 f0             	mov    -0x10(%ebp),%edx
    b085:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    b088:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b08b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b08e:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    b091:	8b 45 08             	mov    0x8(%ebp),%eax
    b094:	c1 e0 0c             	shl    $0xc,%eax
    b097:	89 c2                	mov    %eax,%edx
    b099:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b09c:	8b 00                	mov    (%eax),%eax
    b09e:	83 ec 04             	sub    $0x4,%esp
    b0a1:	52                   	push   %edx
    b0a2:	6a 00                	push   $0x0
    b0a4:	50                   	push   %eax
    b0a5:	e8 f2 e3 ff ff       	call   949c <memset>
    b0aa:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b0ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0b0:	8b 00                	mov    (%eax),%eax
    b0b2:	eb 69                	jmp    b11d <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    b0b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0b7:	8b 10                	mov    (%eax),%edx
    b0b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0bc:	8b 40 04             	mov    0x4(%eax),%eax
    b0bf:	c1 e0 0c             	shl    $0xc,%eax
    b0c2:	01 c2                	add    %eax,%edx
    b0c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0c7:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    b0c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0cc:	8b 55 08             	mov    0x8(%ebp),%edx
    b0cf:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    b0d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0d5:	8b 50 0c             	mov    0xc(%eax),%edx
    b0d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0db:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    b0de:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    b0e4:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    b0e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b0ed:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    b0f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0f3:	8b 40 0c             	mov    0xc(%eax),%eax
    b0f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b0f9:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    b0fc:	8b 45 08             	mov    0x8(%ebp),%eax
    b0ff:	c1 e0 0c             	shl    $0xc,%eax
    b102:	89 c2                	mov    %eax,%edx
    b104:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b107:	8b 00                	mov    (%eax),%eax
    b109:	83 ec 04             	sub    $0x4,%esp
    b10c:	52                   	push   %edx
    b10d:	6a 00                	push   $0x0
    b10f:	50                   	push   %eax
    b110:	e8 87 e3 ff ff       	call   949c <memset>
    b115:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b118:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b11b:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    b11d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    b120:	c9                   	leave  
    b121:	c3                   	ret    

0000b122 <free_page>:

void free_page(_address_order_track_ page)
{
    b122:	55                   	push   %ebp
    b123:	89 e5                	mov    %esp,%ebp
    b125:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    b128:	8b 45 10             	mov    0x10(%ebp),%eax
    b12b:	85 c0                	test   %eax,%eax
    b12d:	75 2d                	jne    b15c <free_page+0x3a>
    b12f:	8b 45 14             	mov    0x14(%ebp),%eax
    b132:	85 c0                	test   %eax,%eax
    b134:	74 26                	je     b15c <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    b136:	b8 83 f1 00 00       	mov    $0xf183,%eax
    b13b:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    b13e:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b143:	8b 40 0c             	mov    0xc(%eax),%eax
    b146:	a3 20 f1 01 00       	mov    %eax,0x1f120
        _page_area_track_->previous_ = END_LIST;
    b14b:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b150:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    b157:	e9 13 01 00 00       	jmp    b26f <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    b15c:	8b 45 10             	mov    0x10(%ebp),%eax
    b15f:	85 c0                	test   %eax,%eax
    b161:	75 67                	jne    b1ca <free_page+0xa8>
    b163:	8b 45 14             	mov    0x14(%ebp),%eax
    b166:	85 c0                	test   %eax,%eax
    b168:	75 60                	jne    b1ca <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    b16a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    b171:	eb 49                	jmp    b1bc <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    b173:	ba 83 f1 00 00       	mov    $0xf183,%edx
    b178:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b17b:	c1 e0 04             	shl    $0x4,%eax
    b17e:	05 40 f1 01 00       	add    $0x1f140,%eax
    b183:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    b185:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b188:	c1 e0 04             	shl    $0x4,%eax
    b18b:	05 44 f1 01 00       	add    $0x1f144,%eax
    b190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    b196:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b199:	c1 e0 04             	shl    $0x4,%eax
    b19c:	05 4c f1 01 00       	add    $0x1f14c,%eax
    b1a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    b1a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b1aa:	c1 e0 04             	shl    $0x4,%eax
    b1ad:	05 48 f1 01 00       	add    $0x1f148,%eax
    b1b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    b1b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b1bc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    b1c3:	76 ae                	jbe    b173 <free_page+0x51>
        }
        return;
    b1c5:	e9 a5 00 00 00       	jmp    b26f <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b1ca:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b1cf:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b1d2:	eb 09                	jmp    b1dd <free_page+0xbb>
            tmp = tmp->next_;
    b1d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1d7:	8b 40 0c             	mov    0xc(%eax),%eax
    b1da:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b1dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1e0:	8b 10                	mov    (%eax),%edx
    b1e2:	8b 45 08             	mov    0x8(%ebp),%eax
    b1e5:	39 c2                	cmp    %eax,%edx
    b1e7:	74 0a                	je     b1f3 <free_page+0xd1>
    b1e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1ec:	8b 40 0c             	mov    0xc(%eax),%eax
    b1ef:	85 c0                	test   %eax,%eax
    b1f1:	75 e1                	jne    b1d4 <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    b1f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1f6:	8b 40 0c             	mov    0xc(%eax),%eax
    b1f9:	85 c0                	test   %eax,%eax
    b1fb:	75 25                	jne    b222 <free_page+0x100>
    b1fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b200:	8b 10                	mov    (%eax),%edx
    b202:	8b 45 08             	mov    0x8(%ebp),%eax
    b205:	39 c2                	cmp    %eax,%edx
    b207:	75 19                	jne    b222 <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b209:	ba 83 f1 00 00       	mov    $0xf183,%edx
    b20e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b211:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    b213:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b216:	8b 40 08             	mov    0x8(%eax),%eax
    b219:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    b220:	eb 4d                	jmp    b26f <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    b222:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b225:	8b 40 0c             	mov    0xc(%eax),%eax
    b228:	85 c0                	test   %eax,%eax
    b22a:	74 36                	je     b262 <free_page+0x140>
    b22c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b22f:	8b 10                	mov    (%eax),%edx
    b231:	8b 45 08             	mov    0x8(%ebp),%eax
    b234:	39 c2                	cmp    %eax,%edx
    b236:	75 2a                	jne    b262 <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b238:	ba 83 f1 00 00       	mov    $0xf183,%edx
    b23d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b240:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    b242:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b245:	8b 40 08             	mov    0x8(%eax),%eax
    b248:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b24b:	8b 52 0c             	mov    0xc(%edx),%edx
    b24e:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    b251:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b254:	8b 40 0c             	mov    0xc(%eax),%eax
    b257:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b25a:	8b 52 08             	mov    0x8(%edx),%edx
    b25d:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    b260:	eb 0d                	jmp    b26f <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    b262:	a1 24 f1 01 00       	mov    0x1f124,%eax
    b267:	83 e8 01             	sub    $0x1,%eax
    b26a:	a3 24 f1 01 00       	mov    %eax,0x1f124
    b26f:	c9                   	leave  
    b270:	c3                   	ret    

0000b271 <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    b271:	55                   	push   %ebp
    b272:	89 e5                	mov    %esp,%ebp
    b274:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    b277:	a1 48 31 02 00       	mov    0x23148,%eax
    b27c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    b27f:	a1 48 31 02 00       	mov    0x23148,%eax
    b284:	8b 40 3c             	mov    0x3c(%eax),%eax
    b287:	a3 48 31 02 00       	mov    %eax,0x23148

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    b28c:	a1 48 31 02 00       	mov    0x23148,%eax
    b291:	89 c2                	mov    %eax,%edx
    b293:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b296:	83 ec 08             	sub    $0x8,%esp
    b299:	52                   	push   %edx
    b29a:	50                   	push   %eax
    b29b:	e8 c0 02 00 00       	call   b560 <switch_to_task>
    b2a0:	83 c4 10             	add    $0x10,%esp
}
    b2a3:	90                   	nop
    b2a4:	c9                   	leave  
    b2a5:	c3                   	ret    

0000b2a6 <init_multitasking>:

void init_multitasking()
{
    b2a6:	55                   	push   %ebp
    b2a7:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    b2a9:	c6 05 40 31 02 00 00 	movb   $0x0,0x23140
    sheduler.task_timer = DELAY_PER_TASK;
    b2b0:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    b2b7:	01 00 00 
}
    b2ba:	90                   	nop
    b2bb:	5d                   	pop    %ebp
    b2bc:	c3                   	ret    

0000b2bd <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    b2bd:	55                   	push   %ebp
    b2be:	89 e5                	mov    %esp,%ebp
    b2c0:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    b2c3:	8b 45 08             	mov    0x8(%ebp),%eax
    b2c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    b2cc:	8b 45 08             	mov    0x8(%ebp),%eax
    b2cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    b2d6:	8b 45 08             	mov    0x8(%ebp),%eax
    b2d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    b2e0:	8b 45 08             	mov    0x8(%ebp),%eax
    b2e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    b2ea:	8b 45 08             	mov    0x8(%ebp),%eax
    b2ed:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    b2f4:	8b 45 08             	mov    0x8(%ebp),%eax
    b2f7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    b2fe:	8b 45 08             	mov    0x8(%ebp),%eax
    b301:	8b 55 10             	mov    0x10(%ebp),%edx
    b304:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    b307:	8b 55 0c             	mov    0xc(%ebp),%edx
    b30a:	8b 45 08             	mov    0x8(%ebp),%eax
    b30d:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    b310:	8b 45 08             	mov    0x8(%ebp),%eax
    b313:	8b 55 14             	mov    0x14(%ebp),%edx
    b316:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    b319:	83 ec 0c             	sub    $0xc,%esp
    b31c:	68 c8 00 00 00       	push   $0xc8
    b321:	e8 c1 f8 ff ff       	call   abe7 <kmalloc>
    b326:	83 c4 10             	add    $0x10,%esp
    b329:	89 c2                	mov    %eax,%edx
    b32b:	8b 45 08             	mov    0x8(%ebp),%eax
    b32e:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    b331:	8b 45 08             	mov    0x8(%ebp),%eax
    b334:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b33b:	90                   	nop
    b33c:	c9                   	leave  
    b33d:	c3                   	ret    
    b33e:	66 90                	xchg   %ax,%ax

0000b340 <__exception_handler__>:
    b340:	58                   	pop    %eax
    b341:	a3 7c b7 00 00       	mov    %eax,0xb77c
    b346:	e8 58 e4 ff ff       	call   97a3 <__exception__>
    b34b:	cf                   	iret   

0000b34c <__exception_no_ERRCODE_handler__>:
    b34c:	e8 58 e4 ff ff       	call   97a9 <__exception_no_ERRCODE__>
    b351:	cf                   	iret   
    b352:	66 90                	xchg   %ax,%ax
    b354:	66 90                	xchg   %ax,%ax
    b356:	66 90                	xchg   %ax,%ax
    b358:	66 90                	xchg   %ax,%ax
    b35a:	66 90                	xchg   %ax,%ax
    b35c:	66 90                	xchg   %ax,%ax
    b35e:	66 90                	xchg   %ax,%ax

0000b360 <gdtr>:
    b360:	00 00                	add    %al,(%eax)
    b362:	00 00                	add    %al,(%eax)
	...

0000b366 <load_gdt>:
    b366:	fa                   	cli    
    b367:	50                   	push   %eax
    b368:	51                   	push   %ecx
    b369:	b9 00 00 00 00       	mov    $0x0,%ecx
    b36e:	89 0d 62 b3 00 00    	mov    %ecx,0xb362
    b374:	31 c0                	xor    %eax,%eax
    b376:	b8 00 01 00 00       	mov    $0x100,%eax
    b37b:	01 c8                	add    %ecx,%eax
    b37d:	66 a3 60 b3 00 00    	mov    %ax,0xb360
    b383:	0f 01 15 60 b3 00 00 	lgdtl  0xb360
    b38a:	8b 0d 62 b3 00 00    	mov    0xb362,%ecx
    b390:	83 c1 20             	add    $0x20,%ecx
    b393:	0f 00 d9             	ltr    %cx
    b396:	59                   	pop    %ecx
    b397:	58                   	pop    %eax
    b398:	c3                   	ret    

0000b399 <idtr>:
    b399:	00 00                	add    %al,(%eax)
    b39b:	00 00                	add    %al,(%eax)
	...

0000b39f <load_idt>:
    b39f:	fa                   	cli    
    b3a0:	50                   	push   %eax
    b3a1:	51                   	push   %ecx
    b3a2:	31 c9                	xor    %ecx,%ecx
    b3a4:	b9 20 00 01 00       	mov    $0x10020,%ecx
    b3a9:	89 0d 9b b3 00 00    	mov    %ecx,0xb39b
    b3af:	31 c0                	xor    %eax,%eax
    b3b1:	b8 00 04 00 00       	mov    $0x400,%eax
    b3b6:	01 c8                	add    %ecx,%eax
    b3b8:	66 a3 99 b3 00 00    	mov    %ax,0xb399
    b3be:	0f 01 1d 99 b3 00 00 	lidtl  0xb399
    b3c5:	59                   	pop    %ecx
    b3c6:	58                   	pop    %eax
    b3c7:	c3                   	ret    
    b3c8:	66 90                	xchg   %ax,%ax
    b3ca:	66 90                	xchg   %ax,%ax
    b3cc:	66 90                	xchg   %ax,%ax
    b3ce:	66 90                	xchg   %ax,%ax

0000b3d0 <irq1>:
    b3d0:	60                   	pusha  
    b3d1:	e8 4c ea ff ff       	call   9e22 <irq1_handler>
    b3d6:	61                   	popa   
    b3d7:	cf                   	iret   

0000b3d8 <irq2>:
    b3d8:	60                   	pusha  
    b3d9:	e8 5f ea ff ff       	call   9e3d <irq2_handler>
    b3de:	61                   	popa   
    b3df:	cf                   	iret   

0000b3e0 <irq3>:
    b3e0:	60                   	pusha  
    b3e1:	e8 7a ea ff ff       	call   9e60 <irq3_handler>
    b3e6:	61                   	popa   
    b3e7:	cf                   	iret   

0000b3e8 <irq4>:
    b3e8:	60                   	pusha  
    b3e9:	e8 95 ea ff ff       	call   9e83 <irq4_handler>
    b3ee:	61                   	popa   
    b3ef:	cf                   	iret   

0000b3f0 <irq5>:
    b3f0:	60                   	pusha  
    b3f1:	e8 b0 ea ff ff       	call   9ea6 <irq5_handler>
    b3f6:	61                   	popa   
    b3f7:	cf                   	iret   

0000b3f8 <irq6>:
    b3f8:	60                   	pusha  
    b3f9:	e8 cb ea ff ff       	call   9ec9 <irq6_handler>
    b3fe:	61                   	popa   
    b3ff:	cf                   	iret   

0000b400 <irq7>:
    b400:	60                   	pusha  
    b401:	e8 e6 ea ff ff       	call   9eec <irq7_handler>
    b406:	61                   	popa   
    b407:	cf                   	iret   

0000b408 <irq8>:
    b408:	60                   	pusha  
    b409:	e8 01 eb ff ff       	call   9f0f <irq8_handler>
    b40e:	61                   	popa   
    b40f:	cf                   	iret   

0000b410 <irq9>:
    b410:	60                   	pusha  
    b411:	e8 1c eb ff ff       	call   9f32 <irq9_handler>
    b416:	61                   	popa   
    b417:	cf                   	iret   

0000b418 <irq10>:
    b418:	60                   	pusha  
    b419:	e8 37 eb ff ff       	call   9f55 <irq10_handler>
    b41e:	61                   	popa   
    b41f:	cf                   	iret   

0000b420 <irq11>:
    b420:	60                   	pusha  
    b421:	e8 52 eb ff ff       	call   9f78 <irq11_handler>
    b426:	61                   	popa   
    b427:	cf                   	iret   

0000b428 <irq12>:
    b428:	60                   	pusha  
    b429:	e8 6d eb ff ff       	call   9f9b <irq12_handler>
    b42e:	61                   	popa   
    b42f:	cf                   	iret   

0000b430 <irq13>:
    b430:	60                   	pusha  
    b431:	e8 88 eb ff ff       	call   9fbe <irq13_handler>
    b436:	61                   	popa   
    b437:	cf                   	iret   

0000b438 <irq14>:
    b438:	60                   	pusha  
    b439:	e8 a3 eb ff ff       	call   9fe1 <irq14_handler>
    b43e:	61                   	popa   
    b43f:	cf                   	iret   

0000b440 <irq15>:
    b440:	60                   	pusha  
    b441:	e8 be eb ff ff       	call   a004 <irq15_handler>
    b446:	61                   	popa   
    b447:	cf                   	iret   
    b448:	66 90                	xchg   %ax,%ax
    b44a:	66 90                	xchg   %ax,%ax
    b44c:	66 90                	xchg   %ax,%ax
    b44e:	66 90                	xchg   %ax,%ax

0000b450 <_FlushPagingCache_>:
    b450:	b8 00 10 01 00       	mov    $0x11000,%eax
    b455:	0f 22 d8             	mov    %eax,%cr3
    b458:	c3                   	ret    

0000b459 <_EnablingPaging_>:
    b459:	e8 f2 ff ff ff       	call   b450 <_FlushPagingCache_>
    b45e:	0f 20 c0             	mov    %cr0,%eax
    b461:	0d 01 00 00 80       	or     $0x80000001,%eax
    b466:	0f 22 c0             	mov    %eax,%cr0
    b469:	c3                   	ret    

0000b46a <PagingFault_Handler>:
    b46a:	58                   	pop    %eax
    b46b:	a3 80 b7 00 00       	mov    %eax,0xb780
    b470:	e8 e7 ef ff ff       	call   a45c <Paging_fault>
    b475:	cf                   	iret   
    b476:	66 90                	xchg   %ax,%ax
    b478:	66 90                	xchg   %ax,%ax
    b47a:	66 90                	xchg   %ax,%ax
    b47c:	66 90                	xchg   %ax,%ax
    b47e:	66 90                	xchg   %ax,%ax

0000b480 <PIT_handler>:
    b480:	9c                   	pushf  
    b481:	e8 16 00 00 00       	call   b49c <irq_PIT>
    b486:	e8 18 f2 ff ff       	call   a6a3 <conserv_status_byte>
    b48b:	e8 af f2 ff ff       	call   a73f <sheduler_cpu_timer>
    b490:	90                   	nop
    b491:	90                   	nop
    b492:	90                   	nop
    b493:	90                   	nop
    b494:	90                   	nop
    b495:	90                   	nop
    b496:	90                   	nop
    b497:	90                   	nop
    b498:	90                   	nop
    b499:	90                   	nop
    b49a:	9d                   	popf   
    b49b:	cf                   	iret   

0000b49c <irq_PIT>:
    b49c:	a1 68 32 02 00       	mov    0x23268,%eax
    b4a1:	8b 1d 6c 32 02 00    	mov    0x2326c,%ebx
    b4a7:	01 05 60 32 02 00    	add    %eax,0x23260
    b4ad:	11 1d 64 32 02 00    	adc    %ebx,0x23264
    b4b3:	6a 00                	push   $0x0
    b4b5:	e8 a8 ef ff ff       	call   a462 <PIC_sendEOI>
    b4ba:	58                   	pop    %eax
    b4bb:	c3                   	ret    

0000b4bc <calculate_frequency>:
    b4bc:	60                   	pusha  
    b4bd:	8b 1d 04 20 01 00    	mov    0x12004,%ebx
    b4c3:	b8 00 00 01 00       	mov    $0x10000,%eax
    b4c8:	83 fb 12             	cmp    $0x12,%ebx
    b4cb:	76 34                	jbe    b501 <calculate_frequency.gotReloadValue>
    b4cd:	b8 01 00 00 00       	mov    $0x1,%eax
    b4d2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    b4d8:	73 27                	jae    b501 <calculate_frequency.gotReloadValue>
    b4da:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b4df:	ba 00 00 00 00       	mov    $0x0,%edx
    b4e4:	f7 f3                	div    %ebx
    b4e6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b4ec:	72 01                	jb     b4ef <calculate_frequency.l1>
    b4ee:	40                   	inc    %eax

0000b4ef <calculate_frequency.l1>:
    b4ef:	bb 03 00 00 00       	mov    $0x3,%ebx
    b4f4:	ba 00 00 00 00       	mov    $0x0,%edx
    b4f9:	f7 f3                	div    %ebx
    b4fb:	83 fa 01             	cmp    $0x1,%edx
    b4fe:	72 01                	jb     b501 <calculate_frequency.gotReloadValue>
    b500:	40                   	inc    %eax

0000b501 <calculate_frequency.gotReloadValue>:
    b501:	50                   	push   %eax
    b502:	66 a3 74 32 02 00    	mov    %ax,0x23274
    b508:	89 c3                	mov    %eax,%ebx
    b50a:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b50f:	ba 00 00 00 00       	mov    $0x0,%edx
    b514:	f7 f3                	div    %ebx
    b516:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b51c:	72 01                	jb     b51f <calculate_frequency.l3>
    b51e:	40                   	inc    %eax

0000b51f <calculate_frequency.l3>:
    b51f:	bb 03 00 00 00       	mov    $0x3,%ebx
    b524:	ba 00 00 00 00       	mov    $0x0,%edx
    b529:	f7 f3                	div    %ebx
    b52b:	83 fa 01             	cmp    $0x1,%edx
    b52e:	72 01                	jb     b531 <calculate_frequency.l4>
    b530:	40                   	inc    %eax

0000b531 <calculate_frequency.l4>:
    b531:	a3 70 32 02 00       	mov    %eax,0x23270
    b536:	5b                   	pop    %ebx
    b537:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    b53c:	f7 e3                	mul    %ebx
    b53e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    b542:	c1 ea 0a             	shr    $0xa,%edx
    b545:	89 15 6c 32 02 00    	mov    %edx,0x2326c
    b54b:	a3 68 32 02 00       	mov    %eax,0x23268
    b550:	61                   	popa   
    b551:	c3                   	ret    
    b552:	66 90                	xchg   %ax,%ax
    b554:	66 90                	xchg   %ax,%ax
    b556:	66 90                	xchg   %ax,%ax
    b558:	66 90                	xchg   %ax,%ax
    b55a:	66 90                	xchg   %ax,%ax
    b55c:	66 90                	xchg   %ax,%ax
    b55e:	66 90                	xchg   %ax,%ax

0000b560 <switch_to_task>:
    b560:	50                   	push   %eax
    b561:	8b 44 24 08          	mov    0x8(%esp),%eax
    b565:	89 58 04             	mov    %ebx,0x4(%eax)
    b568:	89 48 08             	mov    %ecx,0x8(%eax)
    b56b:	89 50 0c             	mov    %edx,0xc(%eax)
    b56e:	89 70 10             	mov    %esi,0x10(%eax)
    b571:	89 78 14             	mov    %edi,0x14(%eax)
    b574:	89 60 18             	mov    %esp,0x18(%eax)
    b577:	89 68 1c             	mov    %ebp,0x1c(%eax)
    b57a:	51                   	push   %ecx
    b57b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    b57f:	89 48 20             	mov    %ecx,0x20(%eax)
    b582:	59                   	pop    %ecx
    b583:	51                   	push   %ecx
    b584:	9c                   	pushf  
    b585:	59                   	pop    %ecx
    b586:	89 48 24             	mov    %ecx,0x24(%eax)
    b589:	59                   	pop    %ecx
    b58a:	51                   	push   %ecx
    b58b:	0f 20 d9             	mov    %cr3,%ecx
    b58e:	89 48 28             	mov    %ecx,0x28(%eax)
    b591:	59                   	pop    %ecx
    b592:	8c 40 2c             	mov    %es,0x2c(%eax)
    b595:	8c 68 2e             	mov    %gs,0x2e(%eax)
    b598:	8c 60 30             	mov    %fs,0x30(%eax)
    b59b:	51                   	push   %ecx
    b59c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    b5a0:	89 08                	mov    %ecx,(%eax)
    b5a2:	59                   	pop    %ecx
    b5a3:	58                   	pop    %eax
    b5a4:	8b 44 24 08          	mov    0x8(%esp),%eax
    b5a8:	8b 58 04             	mov    0x4(%eax),%ebx
    b5ab:	8b 48 08             	mov    0x8(%eax),%ecx
    b5ae:	8b 50 0c             	mov    0xc(%eax),%edx
    b5b1:	8b 70 10             	mov    0x10(%eax),%esi
    b5b4:	8b 78 14             	mov    0x14(%eax),%edi
    b5b7:	8b 60 18             	mov    0x18(%eax),%esp
    b5ba:	8b 68 1c             	mov    0x1c(%eax),%ebp
    b5bd:	51                   	push   %ecx
    b5be:	8b 48 24             	mov    0x24(%eax),%ecx
    b5c1:	51                   	push   %ecx
    b5c2:	9d                   	popf   
    b5c3:	59                   	pop    %ecx
    b5c4:	51                   	push   %ecx
    b5c5:	8b 48 28             	mov    0x28(%eax),%ecx
    b5c8:	0f 22 d9             	mov    %ecx,%cr3
    b5cb:	59                   	pop    %ecx
    b5cc:	8e 40 2c             	mov    0x2c(%eax),%es
    b5cf:	8e 68 2e             	mov    0x2e(%eax),%gs
    b5d2:	8e 60 30             	mov    0x30(%eax),%fs
    b5d5:	8b 40 20             	mov    0x20(%eax),%eax
    b5d8:	89 04 24             	mov    %eax,(%esp)
    b5db:	c3                   	ret    
