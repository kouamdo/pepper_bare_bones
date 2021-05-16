
bin/kernel.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00009000 <main>:
char *       bios_info_begin, bios_info_end;

void *detect_bios_info(), *detect_bios_info_end();

void main()
{
    9000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    9004:	83 e4 f0             	and    $0xfffffff0,%esp
    9007:	ff 71 fc             	pushl  -0x4(%ecx)
    900a:	55                   	push   %ebp
    900b:	89 e5                	mov    %esp,%ebp
    900d:	53                   	push   %ebx
    900e:	51                   	push   %ecx
    cli;
    900f:	fa                   	cli    

    init_console();
    9010:	e8 53 07 00 00       	call   9768 <init_console>

    //Kernel Mapping
    kprintf("PEPPER_Kernel init at [%p] length [%d] bytes \n", main, &end - (void**)main);
    9015:	b8 7a 32 02 00       	mov    $0x2327a,%eax
    901a:	2d 00 90 00 00       	sub    $0x9000,%eax
    901f:	c1 f8 02             	sar    $0x2,%eax
    9022:	83 ec 04             	sub    $0x4,%esp
    9025:	50                   	push   %eax
    9026:	68 00 90 00 00       	push   $0x9000
    902b:	68 00 f0 00 00       	push   $0xf000
    9030:	e8 fc 19 00 00       	call   aa31 <kprintf>
    9035:	83 c4 10             	add    $0x10,%esp
    kprintf("Allocate [16384] bytes of stacks\n");
    9038:	83 ec 0c             	sub    $0xc,%esp
    903b:	68 30 f0 00 00       	push   $0xf030
    9040:	e8 ec 19 00 00       	call   aa31 <kprintf>
    9045:	83 c4 10             	add    $0x10,%esp
    kprintf("Firmware variables at [%p] length [%d] bytes \n", detect_bios_info(), detect_bios_info_end() - detect_bios_info());
    9048:	e8 78 00 00 00       	call   90c5 <detect_bios_info_end>
    904d:	89 c3                	mov    %eax,%ebx
    904f:	e8 26 00 00 00       	call   907a <detect_bios_info>
    9054:	29 c3                	sub    %eax,%ebx
    9056:	e8 1f 00 00 00       	call   907a <detect_bios_info>
    905b:	83 ec 04             	sub    $0x4,%esp
    905e:	53                   	push   %ebx
    905f:	50                   	push   %eax
    9060:	68 54 f0 00 00       	push   $0xf054
    9065:	e8 c7 19 00 00       	call   aa31 <kprintf>
    906a:	83 c4 10             	add    $0x10,%esp

    //load Memory detection

    //------------

    init_gdt(); //Init GDT secondly
    906d:	e8 a1 07 00 00       	call   9813 <init_gdt>

    init_idt();
    9072:	e8 d5 08 00 00       	call   994c <init_idt>

    sti;
    9077:	fb                   	sti    

    while (1)
    9078:	eb fe                	jmp    9078 <main+0x78>

0000907a <detect_bios_info>:
        ;
}

//detect BIOS info
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
    90b3:	a3 00 00 01 00       	mov    %eax,0x10000

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
    90d2:	a1 00 00 01 00       	mov    0x10000,%eax
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
    90ff:	c9                   	leave  
    9100:	c3                   	ret    

00009101 <putchar>:
 * Print a number (base <= 16) in reverse order,
 */
void puts(const char* string);

void putchar(uint8_t c)
{
    9101:	55                   	push   %ebp
    9102:	89 e5                	mov    %esp,%ebp
    9104:	83 ec 18             	sub    $0x18,%esp
    9107:	8b 45 08             	mov    0x8(%ebp),%eax
    910a:	88 45 f4             	mov    %al,-0xc(%ebp)
    cputchar(READY_COLOR, c);
    910d:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    9111:	0f be c0             	movsbl %al,%eax
    9114:	83 ec 08             	sub    $0x8,%esp
    9117:	50                   	push   %eax
    9118:	6a 07                	push   $0x7
    911a:	e8 b7 04 00 00       	call   95d6 <cputchar>
    911f:	83 c4 10             	add    $0x10,%esp
}
    9122:	90                   	nop
    9123:	c9                   	leave  
    9124:	c3                   	ret    

00009125 <printnum>:

static void printnum(uint32_t num, uint8_t base)
{
    9125:	55                   	push   %ebp
    9126:	89 e5                	mov    %esp,%ebp
    9128:	53                   	push   %ebx
    9129:	83 ec 14             	sub    $0x14,%esp
    912c:	8b 45 0c             	mov    0xc(%ebp),%eax
    912f:	88 45 f4             	mov    %al,-0xc(%ebp)
    if (num >= base) printnum((uint32_t)(num / base), base);
    9132:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    9136:	39 45 08             	cmp    %eax,0x8(%ebp)
    9139:	72 1f                	jb     915a <printnum+0x35>
    913b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    913f:	0f b6 5d f4          	movzbl -0xc(%ebp),%ebx
    9143:	8b 45 08             	mov    0x8(%ebp),%eax
    9146:	ba 00 00 00 00       	mov    $0x0,%edx
    914b:	f7 f3                	div    %ebx
    914d:	83 ec 08             	sub    $0x8,%esp
    9150:	51                   	push   %ecx
    9151:	50                   	push   %eax
    9152:	e8 ce ff ff ff       	call   9125 <printnum>
    9157:	83 c4 10             	add    $0x10,%esp

    putchar("0123456789abcdef"[num % base]);
    915a:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    915e:	8b 45 08             	mov    0x8(%ebp),%eax
    9161:	ba 00 00 00 00       	mov    $0x0,%edx
    9166:	f7 f1                	div    %ecx
    9168:	89 d0                	mov    %edx,%eax
    916a:	0f b6 80 84 f0 00 00 	movzbl 0xf084(%eax),%eax
    9171:	0f b6 c0             	movzbl %al,%eax
    9174:	83 ec 0c             	sub    $0xc,%esp
    9177:	50                   	push   %eax
    9178:	e8 84 ff ff ff       	call   9101 <putchar>
    917d:	83 c4 10             	add    $0x10,%esp
}
    9180:	90                   	nop
    9181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    9184:	c9                   	leave  
    9185:	c3                   	ret    

00009186 <printf>:

void printf(const char* fmt, va_list arg)
{
    9186:	55                   	push   %ebp
    9187:	89 e5                	mov    %esp,%ebp
    9189:	83 ec 18             	sub    $0x18,%esp
    char*    s;
    int*     p;

    const char* chr_tmp;

    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    918c:	8b 45 08             	mov    0x8(%ebp),%eax
    918f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    9192:	e9 53 01 00 00       	jmp    92ea <printf+0x164>

        if (*chr_tmp == '%') {
    9197:	8b 45 f4             	mov    -0xc(%ebp),%eax
    919a:	0f b6 00             	movzbl (%eax),%eax
    919d:	3c 25                	cmp    $0x25,%al
    919f:	0f 85 29 01 00 00    	jne    92ce <printf+0x148>
            chr_tmp++;
    91a5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            switch (*chr_tmp) {
    91a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91ac:	0f b6 00             	movzbl (%eax),%eax
    91af:	0f be c0             	movsbl %al,%eax
    91b2:	83 e8 62             	sub    $0x62,%eax
    91b5:	83 f8 16             	cmp    $0x16,%eax
    91b8:	0f 87 27 01 00 00    	ja     92e5 <printf+0x15f>
    91be:	8b 04 85 98 f0 00 00 	mov    0xf098(,%eax,4),%eax
    91c5:	ff e0                	jmp    *%eax
            case 'c':
                i = va_arg(arg, int32_t);
    91c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    91ca:	8d 50 04             	lea    0x4(%eax),%edx
    91cd:	89 55 0c             	mov    %edx,0xc(%ebp)
    91d0:	8b 00                	mov    (%eax),%eax
    91d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
                putchar(i);
    91d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    91d8:	0f b6 c0             	movzbl %al,%eax
    91db:	83 ec 0c             	sub    $0xc,%esp
    91de:	50                   	push   %eax
    91df:	e8 1d ff ff ff       	call   9101 <putchar>
    91e4:	83 c4 10             	add    $0x10,%esp
                break;
    91e7:	e9 fa 00 00 00       	jmp    92e6 <printf+0x160>
            case 'd':
                i = va_arg(arg, int);
    91ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    91ef:	8d 50 04             	lea    0x4(%eax),%edx
    91f2:	89 55 0c             	mov    %edx,0xc(%ebp)
    91f5:	8b 00                	mov    (%eax),%eax
    91f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 10);
    91fa:	83 ec 08             	sub    $0x8,%esp
    91fd:	6a 0a                	push   $0xa
    91ff:	ff 75 f0             	pushl  -0x10(%ebp)
    9202:	e8 1e ff ff ff       	call   9125 <printnum>
    9207:	83 c4 10             	add    $0x10,%esp
                break;
    920a:	e9 d7 00 00 00       	jmp    92e6 <printf+0x160>
            case 'o':
                i = va_arg(arg, int32_t);
    920f:	8b 45 0c             	mov    0xc(%ebp),%eax
    9212:	8d 50 04             	lea    0x4(%eax),%edx
    9215:	89 55 0c             	mov    %edx,0xc(%ebp)
    9218:	8b 00                	mov    (%eax),%eax
    921a:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 8);
    921d:	83 ec 08             	sub    $0x8,%esp
    9220:	6a 08                	push   $0x8
    9222:	ff 75 f0             	pushl  -0x10(%ebp)
    9225:	e8 fb fe ff ff       	call   9125 <printnum>
    922a:	83 c4 10             	add    $0x10,%esp
                break;
    922d:	e9 b4 00 00 00       	jmp    92e6 <printf+0x160>
            case 'b':
                i = va_arg(arg, int32_t);
    9232:	8b 45 0c             	mov    0xc(%ebp),%eax
    9235:	8d 50 04             	lea    0x4(%eax),%edx
    9238:	89 55 0c             	mov    %edx,0xc(%ebp)
    923b:	8b 00                	mov    (%eax),%eax
    923d:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 2);
    9240:	83 ec 08             	sub    $0x8,%esp
    9243:	6a 02                	push   $0x2
    9245:	ff 75 f0             	pushl  -0x10(%ebp)
    9248:	e8 d8 fe ff ff       	call   9125 <printnum>
    924d:	83 c4 10             	add    $0x10,%esp
                break;
    9250:	e9 91 00 00 00       	jmp    92e6 <printf+0x160>
            case 'x':
                i = va_arg(arg, int32_t);
    9255:	8b 45 0c             	mov    0xc(%ebp),%eax
    9258:	8d 50 04             	lea    0x4(%eax),%edx
    925b:	89 55 0c             	mov    %edx,0xc(%ebp)
    925e:	8b 00                	mov    (%eax),%eax
    9260:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 16);
    9263:	83 ec 08             	sub    $0x8,%esp
    9266:	6a 10                	push   $0x10
    9268:	ff 75 f0             	pushl  -0x10(%ebp)
    926b:	e8 b5 fe ff ff       	call   9125 <printnum>
    9270:	83 c4 10             	add    $0x10,%esp
                break;
    9273:	eb 71                	jmp    92e6 <printf+0x160>
            case 's':
                s = va_arg(arg, char*);
    9275:	8b 45 0c             	mov    0xc(%ebp),%eax
    9278:	8d 50 04             	lea    0x4(%eax),%edx
    927b:	89 55 0c             	mov    %edx,0xc(%ebp)
    927e:	8b 00                	mov    (%eax),%eax
    9280:	89 45 ec             	mov    %eax,-0x14(%ebp)
                puts(s);
    9283:	83 ec 0c             	sub    $0xc,%esp
    9286:	ff 75 ec             	pushl  -0x14(%ebp)
    9289:	e8 6e 00 00 00       	call   92fc <puts>
    928e:	83 c4 10             	add    $0x10,%esp
                break;
    9291:	eb 53                	jmp    92e6 <printf+0x160>
            case 'p':
                p = va_arg(arg, void*);
    9293:	8b 45 0c             	mov    0xc(%ebp),%eax
    9296:	8d 50 04             	lea    0x4(%eax),%edx
    9299:	89 55 0c             	mov    %edx,0xc(%ebp)
    929c:	8b 00                	mov    (%eax),%eax
    929e:	89 45 e8             	mov    %eax,-0x18(%ebp)
                putchar('0');
    92a1:	83 ec 0c             	sub    $0xc,%esp
    92a4:	6a 30                	push   $0x30
    92a6:	e8 56 fe ff ff       	call   9101 <putchar>
    92ab:	83 c4 10             	add    $0x10,%esp
                putchar('x');
    92ae:	83 ec 0c             	sub    $0xc,%esp
    92b1:	6a 78                	push   $0x78
    92b3:	e8 49 fe ff ff       	call   9101 <putchar>
    92b8:	83 c4 10             	add    $0x10,%esp
                printnum((uint32_t)p, 16);
    92bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    92be:	83 ec 08             	sub    $0x8,%esp
    92c1:	6a 10                	push   $0x10
    92c3:	50                   	push   %eax
    92c4:	e8 5c fe ff ff       	call   9125 <printnum>
    92c9:	83 c4 10             	add    $0x10,%esp
                break;
    92cc:	eb 18                	jmp    92e6 <printf+0x160>
                break;
            }
        }

        else
            putchar(*chr_tmp);
    92ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    92d1:	0f b6 00             	movzbl (%eax),%eax
    92d4:	0f b6 c0             	movzbl %al,%eax
    92d7:	83 ec 0c             	sub    $0xc,%esp
    92da:	50                   	push   %eax
    92db:	e8 21 fe ff ff       	call   9101 <putchar>
    92e0:	83 c4 10             	add    $0x10,%esp
    92e3:	eb 01                	jmp    92e6 <printf+0x160>
                break;
    92e5:	90                   	nop
    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    92e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    92ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    92ed:	0f b6 00             	movzbl (%eax),%eax
    92f0:	84 c0                	test   %al,%al
    92f2:	0f 85 9f fe ff ff    	jne    9197 <printf+0x11>
    }

    va_end(arg);
}
    92f8:	90                   	nop
    92f9:	90                   	nop
    92fa:	c9                   	leave  
    92fb:	c3                   	ret    

000092fc <puts>:

void puts(const char* string)
{
    92fc:	55                   	push   %ebp
    92fd:	89 e5                	mov    %esp,%ebp
    92ff:	83 ec 08             	sub    $0x8,%esp
    if (*string != '\0') {
    9302:	8b 45 08             	mov    0x8(%ebp),%eax
    9305:	0f b6 00             	movzbl (%eax),%eax
    9308:	84 c0                	test   %al,%al
    930a:	74 2a                	je     9336 <puts+0x3a>
        putchar(*string);
    930c:	8b 45 08             	mov    0x8(%ebp),%eax
    930f:	0f b6 00             	movzbl (%eax),%eax
    9312:	0f b6 c0             	movzbl %al,%eax
    9315:	83 ec 0c             	sub    $0xc,%esp
    9318:	50                   	push   %eax
    9319:	e8 e3 fd ff ff       	call   9101 <putchar>
    931e:	83 c4 10             	add    $0x10,%esp
        puts(string++);
    9321:	8b 45 08             	mov    0x8(%ebp),%eax
    9324:	8d 50 01             	lea    0x1(%eax),%edx
    9327:	89 55 08             	mov    %edx,0x8(%ebp)
    932a:	83 ec 0c             	sub    $0xc,%esp
    932d:	50                   	push   %eax
    932e:	e8 c9 ff ff ff       	call   92fc <puts>
    9333:	83 c4 10             	add    $0x10,%esp
    }
    9336:	90                   	nop
    9337:	c9                   	leave  
    9338:	c3                   	ret    

00009339 <_strcmp_>:
#include "../../include/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    9339:	55                   	push   %ebp
    933a:	89 e5                	mov    %esp,%ebp
    933c:	53                   	push   %ebx
    933d:	83 ec 04             	sub    $0x4,%esp
    if (_strlen_(str2) != _strlen_(str1))
    9340:	83 ec 0c             	sub    $0xc,%esp
    9343:	ff 75 0c             	pushl  0xc(%ebp)
    9346:	e8 59 00 00 00       	call   93a4 <_strlen_>
    934b:	83 c4 10             	add    $0x10,%esp
    934e:	89 c3                	mov    %eax,%ebx
    9350:	83 ec 0c             	sub    $0xc,%esp
    9353:	ff 75 08             	pushl  0x8(%ebp)
    9356:	e8 49 00 00 00       	call   93a4 <_strlen_>
    935b:	83 c4 10             	add    $0x10,%esp
    935e:	38 c3                	cmp    %al,%bl
    9360:	74 0f                	je     9371 <_strcmp_+0x38>
        return 0;
    9362:	b8 00 00 00 00       	mov    $0x0,%eax
    9367:	eb 36                	jmp    939f <_strcmp_+0x66>

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
    9369:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        str2++;
    936d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while ((*str1 == *str2) && (*str1 != '\000')) {
    9371:	8b 45 08             	mov    0x8(%ebp),%eax
    9374:	0f b6 10             	movzbl (%eax),%edx
    9377:	8b 45 0c             	mov    0xc(%ebp),%eax
    937a:	0f b6 00             	movzbl (%eax),%eax
    937d:	38 c2                	cmp    %al,%dl
    937f:	75 0a                	jne    938b <_strcmp_+0x52>
    9381:	8b 45 08             	mov    0x8(%ebp),%eax
    9384:	0f b6 00             	movzbl (%eax),%eax
    9387:	84 c0                	test   %al,%al
    9389:	75 de                	jne    9369 <_strcmp_+0x30>
    }

    return *str1 == *str2;
    938b:	8b 45 08             	mov    0x8(%ebp),%eax
    938e:	0f b6 10             	movzbl (%eax),%edx
    9391:	8b 45 0c             	mov    0xc(%ebp),%eax
    9394:	0f b6 00             	movzbl (%eax),%eax
    9397:	38 c2                	cmp    %al,%dl
    9399:	0f 94 c0             	sete   %al
    939c:	0f b6 c0             	movzbl %al,%eax
}
    939f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    93a2:	c9                   	leave  
    93a3:	c3                   	ret    

000093a4 <_strlen_>:

uint8_t _strlen_(char* str)
{
    93a4:	55                   	push   %ebp
    93a5:	89 e5                	mov    %esp,%ebp
    93a7:	83 ec 10             	sub    $0x10,%esp
    if (*str == '\000')
    93aa:	8b 45 08             	mov    0x8(%ebp),%eax
    93ad:	0f b6 00             	movzbl (%eax),%eax
    93b0:	84 c0                	test   %al,%al
    93b2:	75 07                	jne    93bb <_strlen_+0x17>
        return 0;
    93b4:	b8 00 00 00 00       	mov    $0x0,%eax
    93b9:	eb 22                	jmp    93dd <_strlen_+0x39>

    uint8_t i = 1;
    93bb:	c6 45 ff 01          	movb   $0x1,-0x1(%ebp)

    while (*str != '\000') {
    93bf:	eb 0e                	jmp    93cf <_strlen_+0x2b>
        str++;
    93c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        i++;
    93c5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    93c9:	83 c0 01             	add    $0x1,%eax
    93cc:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (*str != '\000') {
    93cf:	8b 45 08             	mov    0x8(%ebp),%eax
    93d2:	0f b6 00             	movzbl (%eax),%eax
    93d5:	84 c0                	test   %al,%al
    93d7:	75 e8                	jne    93c1 <_strlen_+0x1d>
    }

    return i;
    93d9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
    93dd:	c9                   	leave  
    93de:	c3                   	ret    

000093df <_strcpy_>:

void* _strcpy_(char* dest, char* src)
{
    93df:	55                   	push   %ebp
    93e0:	89 e5                	mov    %esp,%ebp
    93e2:	83 ec 10             	sub    $0x10,%esp
    if (dest == NULL)
    93e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    93e9:	75 07                	jne    93f2 <_strcpy_+0x13>
        return (void*)NULL;
    93eb:	b8 00 00 00 00       	mov    $0x0,%eax
    93f0:	eb 46                	jmp    9438 <_strcpy_+0x59>

    uint8_t i = 0;
    93f2:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    while (src[i] != '\000') {
    93f6:	eb 21                	jmp    9419 <_strcpy_+0x3a>
        dest[i] = src[i];
    93f8:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    93fc:	8b 45 0c             	mov    0xc(%ebp),%eax
    93ff:	01 d0                	add    %edx,%eax
    9401:	0f b6 4d ff          	movzbl -0x1(%ebp),%ecx
    9405:	8b 55 08             	mov    0x8(%ebp),%edx
    9408:	01 ca                	add    %ecx,%edx
    940a:	0f b6 00             	movzbl (%eax),%eax
    940d:	88 02                	mov    %al,(%edx)
        i++;
    940f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    9413:	83 c0 01             	add    $0x1,%eax
    9416:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (src[i] != '\000') {
    9419:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    941d:	8b 45 0c             	mov    0xc(%ebp),%eax
    9420:	01 d0                	add    %edx,%eax
    9422:	0f b6 00             	movzbl (%eax),%eax
    9425:	84 c0                	test   %al,%al
    9427:	75 cf                	jne    93f8 <_strcpy_+0x19>
    }

    dest[i] = '\000';
    9429:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    942d:	8b 45 08             	mov    0x8(%ebp),%eax
    9430:	01 d0                	add    %edx,%eax
    9432:	c6 00 00             	movb   $0x0,(%eax)

    return (void*)dest;
    9435:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9438:	c9                   	leave  
    9439:	c3                   	ret    

0000943a <memcpy>:

void* memcpy(void* dest, const void* src, uint32_t size)
{
    943a:	55                   	push   %ebp
    943b:	89 e5                	mov    %esp,%ebp
    943d:	83 ec 10             	sub    $0x10,%esp
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    9440:	8b 45 08             	mov    0x8(%ebp),%eax
    9443:	89 45 fc             	mov    %eax,-0x4(%ebp)
    _src_  = (char*)src;
    9446:	8b 45 0c             	mov    0xc(%ebp),%eax
    9449:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (size) {
    944c:	eb 1b                	jmp    9469 <memcpy+0x2f>
        *(_dest_++) = *(_src_++);
    944e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    9451:	8d 42 01             	lea    0x1(%edx),%eax
    9454:	89 45 f8             	mov    %eax,-0x8(%ebp)
    9457:	8b 45 fc             	mov    -0x4(%ebp),%eax
    945a:	8d 48 01             	lea    0x1(%eax),%ecx
    945d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    9460:	0f b6 12             	movzbl (%edx),%edx
    9463:	88 10                	mov    %dl,(%eax)
        size--;
    9465:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (size) {
    9469:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    946d:	75 df                	jne    944e <memcpy+0x14>
    }

    return (void*)dest;
    946f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9472:	c9                   	leave  
    9473:	c3                   	ret    

00009474 <memset>:

void* memset(void* mem, int8_t data, int size)
{
    9474:	55                   	push   %ebp
    9475:	89 e5                	mov    %esp,%ebp
    9477:	83 ec 14             	sub    $0x14,%esp
    947a:	8b 45 0c             	mov    0xc(%ebp),%eax
    947d:	88 45 ec             	mov    %al,-0x14(%ebp)
    int i = 0;
    9480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

    int8_t* tmp = mem;
    9487:	8b 45 08             	mov    0x8(%ebp),%eax
    948a:	89 45 f8             	mov    %eax,-0x8(%ebp)

    for (i; i < size; i++)
    948d:	eb 12                	jmp    94a1 <memset+0x2d>
        tmp[i] = data;
    948f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    9492:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9495:	01 c2                	add    %eax,%edx
    9497:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    949b:	88 02                	mov    %al,(%edx)
    for (i; i < size; i++)
    949d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    94a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    94a4:	3b 45 10             	cmp    0x10(%ebp),%eax
    94a7:	7c e6                	jl     948f <memset+0x1b>

    return (void*)mem;
    94a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    94ac:	c9                   	leave  
    94ad:	c3                   	ret    

000094ae <_memcmp_>:

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    94ae:	55                   	push   %ebp
    94af:	89 e5                	mov    %esp,%ebp
    94b1:	83 ec 10             	sub    $0x10,%esp
    char* mem_1 = (char*)src_1;
    94b4:	8b 45 08             	mov    0x8(%ebp),%eax
    94b7:	89 45 fc             	mov    %eax,-0x4(%ebp)

    char* mem_2 = (char*)src_2;
    94ba:	8b 45 0c             	mov    0xc(%ebp),%eax
    94bd:	89 45 f8             	mov    %eax,-0x8(%ebp)

    uint32_t i = 0;
    94c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (i < size && *mem_1 == *mem_2) {
    94c7:	eb 0c                	jmp    94d5 <_memcmp_+0x27>
        i++;
    94c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        mem_1++;
    94cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
        mem_2++;
    94d1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (i < size && *mem_1 == *mem_2) {
    94d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    94d8:	3b 45 10             	cmp    0x10(%ebp),%eax
    94db:	73 10                	jae    94ed <_memcmp_+0x3f>
    94dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    94e0:	0f b6 10             	movzbl (%eax),%edx
    94e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    94e6:	0f b6 00             	movzbl (%eax),%eax
    94e9:	38 c2                	cmp    %al,%dl
    94eb:	74 dc                	je     94c9 <_memcmp_+0x1b>
    }

    return i == size;
    94ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    94f0:	3b 45 10             	cmp    0x10(%ebp),%eax
    94f3:	0f 94 c0             	sete   %al
    94f6:	0f b6 c0             	movzbl %al,%eax
    94f9:	c9                   	leave  
    94fa:	c3                   	ret    

000094fb <cclean>:

void move_cursor(uint8_t x, uint8_t y);
void show_cursor(void);

void volatile cclean()
{
    94fb:	55                   	push   %ebp
    94fc:	89 e5                	mov    %esp,%ebp
    94fe:	83 ec 10             	sub    $0x10,%esp
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    9501:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
    int            i      = 0;
    9508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (i <= 160 * 25) {
    950f:	eb 1d                	jmp    952e <cclean+0x33>
        screen[i]     = ' ';
    9511:	8b 55 fc             	mov    -0x4(%ebp),%edx
    9514:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9517:	01 d0                	add    %edx,%eax
    9519:	c6 00 20             	movb   $0x20,(%eax)
        screen[i + 1] = 0x0;
    951c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    951f:	8d 50 01             	lea    0x1(%eax),%edx
    9522:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9525:	01 d0                	add    %edx,%eax
    9527:	c6 00 00             	movb   $0x0,(%eax)
        i += 2;
    952a:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    while (i <= 160 * 25) {
    952e:	81 7d fc a0 0f 00 00 	cmpl   $0xfa0,-0x4(%ebp)
    9535:	7e da                	jle    9511 <cclean+0x16>
    }

    CURSOR_X = 0;
    9537:	c7 05 0c 00 01 00 00 	movl   $0x0,0x1000c
    953e:	00 00 00 
    CURSOR_Y = 0;
    9541:	c7 05 08 00 01 00 00 	movl   $0x0,0x10008
    9548:	00 00 00 
}
    954b:	90                   	nop
    954c:	c9                   	leave  
    954d:	c3                   	ret    

0000954e <cscrollup>:

void volatile cscrollup()
{
    954e:	55                   	push   %ebp
    954f:	89 e5                	mov    %esp,%ebp
    9551:	81 ec b0 00 00 00    	sub    $0xb0,%esp
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    9557:	c7 45 f8 00 8f 0b 00 	movl   $0xb8f00,-0x8(%ebp)
    unsigned char  b[160];
    int            i;
    for (i = 0; i < 160; i++)
    955e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    9565:	eb 1c                	jmp    9583 <cscrollup+0x35>
        b[i] = v[i];
    9567:	8b 55 fc             	mov    -0x4(%ebp),%edx
    956a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    956d:	01 d0                	add    %edx,%eax
    956f:	0f b6 00             	movzbl (%eax),%eax
    9572:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    9578:	8b 55 fc             	mov    -0x4(%ebp),%edx
    957b:	01 ca                	add    %ecx,%edx
    957d:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    957f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    9583:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    958a:	7e db                	jle    9567 <cscrollup+0x19>

    cclean();
    958c:	e8 6a ff ff ff       	call   94fb <cclean>

    v = (unsigned char*)(VIDEO_MEM);
    9591:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)

    for (i = 0; i < 160; i++)
    9598:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    959f:	eb 1c                	jmp    95bd <cscrollup+0x6f>
        v[i] = b[i];
    95a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
    95a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    95a7:	01 c2                	add    %eax,%edx
    95a9:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    95af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    95b2:	01 c8                	add    %ecx,%eax
    95b4:	0f b6 00             	movzbl (%eax),%eax
    95b7:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    95b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    95bd:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    95c4:	7e db                	jle    95a1 <cscrollup+0x53>

    CURSOR_Y++;
    95c6:	a1 08 00 01 00       	mov    0x10008,%eax
    95cb:	83 c0 01             	add    $0x1,%eax
    95ce:	a3 08 00 01 00       	mov    %eax,0x10008
}
    95d3:	90                   	nop
    95d4:	c9                   	leave  
    95d5:	c3                   	ret    

000095d6 <cputchar>:

void volatile cputchar(char color, const char c)
{
    95d6:	55                   	push   %ebp
    95d7:	89 e5                	mov    %esp,%ebp
    95d9:	83 ec 18             	sub    $0x18,%esp
    95dc:	8b 55 08             	mov    0x8(%ebp),%edx
    95df:	8b 45 0c             	mov    0xc(%ebp),%eax
    95e2:	88 55 ec             	mov    %dl,-0x14(%ebp)
    95e5:	88 45 e8             	mov    %al,-0x18(%ebp)

    if ((CURSOR_Y) <= (25)) {
    95e8:	a1 08 00 01 00       	mov    0x10008,%eax
    95ed:	83 f8 19             	cmp    $0x19,%eax
    95f0:	0f 8f c0 00 00 00    	jg     96b6 <cputchar+0xe0>
        if (c == '\n') {
    95f6:	80 7d e8 0a          	cmpb   $0xa,-0x18(%ebp)
    95fa:	75 1c                	jne    9618 <cputchar+0x42>
            CURSOR_X = 0;
    95fc:	c7 05 0c 00 01 00 00 	movl   $0x0,0x1000c
    9603:	00 00 00 
            CURSOR_Y++;
    9606:	a1 08 00 01 00       	mov    0x10008,%eax
    960b:	83 c0 01             	add    $0x1,%eax
    960e:	a3 08 00 01 00       	mov    %eax,0x10008
        }
    }

    else
        cclean();
}
    9613:	e9 a3 00 00 00       	jmp    96bb <cputchar+0xe5>
        else if (c == '\t')
    9618:	80 7d e8 09          	cmpb   $0x9,-0x18(%ebp)
    961c:	75 12                	jne    9630 <cputchar+0x5a>
            CURSOR_X += 5;
    961e:	a1 0c 00 01 00       	mov    0x1000c,%eax
    9623:	83 c0 05             	add    $0x5,%eax
    9626:	a3 0c 00 01 00       	mov    %eax,0x1000c
}
    962b:	e9 8b 00 00 00       	jmp    96bb <cputchar+0xe5>
        else if (c == 0x08)
    9630:	80 7d e8 08          	cmpb   $0x8,-0x18(%ebp)
    9634:	75 3a                	jne    9670 <cputchar+0x9a>
            CURSOR_X--;
    9636:	a1 0c 00 01 00       	mov    0x1000c,%eax
    963b:	83 e8 01             	sub    $0x1,%eax
    963e:	a3 0c 00 01 00       	mov    %eax,0x1000c
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9643:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    964a:	8b 15 08 00 01 00    	mov    0x10008,%edx
    9650:	89 d0                	mov    %edx,%eax
    9652:	c1 e0 02             	shl    $0x2,%eax
    9655:	01 d0                	add    %edx,%eax
    9657:	c1 e0 04             	shl    $0x4,%eax
    965a:	89 c2                	mov    %eax,%edx
    965c:	a1 0c 00 01 00       	mov    0x1000c,%eax
    9661:	01 d0                	add    %edx,%eax
    9663:	01 c0                	add    %eax,%eax
    9665:	01 45 f8             	add    %eax,-0x8(%ebp)
            *v = ' ';
    9668:	8b 45 f8             	mov    -0x8(%ebp),%eax
    966b:	c6 00 20             	movb   $0x20,(%eax)
}
    966e:	eb 4b                	jmp    96bb <cputchar+0xe5>
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9670:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    9677:	8b 15 08 00 01 00    	mov    0x10008,%edx
    967d:	89 d0                	mov    %edx,%eax
    967f:	c1 e0 02             	shl    $0x2,%eax
    9682:	01 d0                	add    %edx,%eax
    9684:	c1 e0 04             	shl    $0x4,%eax
    9687:	89 c2                	mov    %eax,%edx
    9689:	a1 0c 00 01 00       	mov    0x1000c,%eax
    968e:	01 d0                	add    %edx,%eax
    9690:	01 c0                	add    %eax,%eax
    9692:	01 45 fc             	add    %eax,-0x4(%ebp)
            *v = c;
    9695:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    9699:	8b 45 fc             	mov    -0x4(%ebp),%eax
    969c:	88 10                	mov    %dl,(%eax)
            *(v + 1) = READY_COLOR;
    969e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    96a1:	83 c0 01             	add    $0x1,%eax
    96a4:	c6 00 07             	movb   $0x7,(%eax)
            CURSOR_X++;
    96a7:	a1 0c 00 01 00       	mov    0x1000c,%eax
    96ac:	83 c0 01             	add    $0x1,%eax
    96af:	a3 0c 00 01 00       	mov    %eax,0x1000c
}
    96b4:	eb 05                	jmp    96bb <cputchar+0xe5>
        cclean();
    96b6:	e8 40 fe ff ff       	call   94fb <cclean>
}
    96bb:	90                   	nop
    96bc:	c9                   	leave  
    96bd:	c3                   	ret    

000096be <move_cursor>:

void move_cursor(uint8_t x, uint8_t y)
{
    96be:	55                   	push   %ebp
    96bf:	89 e5                	mov    %esp,%ebp
    96c1:	83 ec 18             	sub    $0x18,%esp
    96c4:	8b 55 08             	mov    0x8(%ebp),%edx
    96c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    96ca:	88 55 ec             	mov    %dl,-0x14(%ebp)
    96cd:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t c_pos;

    c_pos = y * 80 + x;
    96d0:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    96d4:	89 d0                	mov    %edx,%eax
    96d6:	c1 e0 02             	shl    $0x2,%eax
    96d9:	01 d0                	add    %edx,%eax
    96db:	c1 e0 04             	shl    $0x4,%eax
    96de:	89 c2                	mov    %eax,%edx
    96e0:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    96e4:	01 d0                	add    %edx,%eax
    96e6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    outb(0x3d4, 0x0f);
    96ea:	ba d4 03 00 00       	mov    $0x3d4,%edx
    96ef:	b8 0f 00 00 00       	mov    $0xf,%eax
    96f4:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)c_pos);
    96f5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    96f9:	ba d5 03 00 00       	mov    $0x3d5,%edx
    96fe:	ee                   	out    %al,(%dx)
    outb(0x3d4, 0x0e);
    96ff:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9704:	b8 0e 00 00 00       	mov    $0xe,%eax
    9709:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)(c_pos >> 8));
    970a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    970e:	66 c1 e8 08          	shr    $0x8,%ax
    9712:	ba d5 03 00 00       	mov    $0x3d5,%edx
    9717:	ee                   	out    %al,(%dx)
}
    9718:	90                   	nop
    9719:	c9                   	leave  
    971a:	c3                   	ret    

0000971b <show_cursor>:

void show_cursor(void)
{
    971b:	55                   	push   %ebp
    971c:	89 e5                	mov    %esp,%ebp
    move_cursor(CURSOR_X, CURSOR_Y);
    971e:	a1 08 00 01 00       	mov    0x10008,%eax
    9723:	0f b6 d0             	movzbl %al,%edx
    9726:	a1 0c 00 01 00       	mov    0x1000c,%eax
    972b:	0f b6 c0             	movzbl %al,%eax
    972e:	52                   	push   %edx
    972f:	50                   	push   %eax
    9730:	e8 89 ff ff ff       	call   96be <move_cursor>
    9735:	83 c4 08             	add    $0x8,%esp
}
    9738:	90                   	nop
    9739:	c9                   	leave  
    973a:	c3                   	ret    

0000973b <console_service_keyboard>:

void console_service_keyboard()
{
    973b:	55                   	push   %ebp
    973c:	89 e5                	mov    %esp,%ebp
    973e:	83 ec 08             	sub    $0x8,%esp
    if (get_ASCII_code_keyboard() != 0) {
    9741:	e8 1e 0b 00 00       	call   a264 <get_ASCII_code_keyboard>
    9746:	84 c0                	test   %al,%al
    9748:	74 1b                	je     9765 <console_service_keyboard+0x2a>
        cputchar(READY_COLOR, get_ASCII_code_keyboard());
    974a:	e8 15 0b 00 00       	call   a264 <get_ASCII_code_keyboard>
    974f:	0f be c0             	movsbl %al,%eax
    9752:	83 ec 08             	sub    $0x8,%esp
    9755:	50                   	push   %eax
    9756:	6a 07                	push   $0x7
    9758:	e8 79 fe ff ff       	call   95d6 <cputchar>
    975d:	83 c4 10             	add    $0x10,%esp
        show_cursor();
    9760:	e8 b6 ff ff ff       	call   971b <show_cursor>
    }
}
    9765:	90                   	nop
    9766:	c9                   	leave  
    9767:	c3                   	ret    

00009768 <init_console>:

void init_console()
{
    9768:	55                   	push   %ebp
    9769:	89 e5                	mov    %esp,%ebp
    976b:	83 ec 08             	sub    $0x8,%esp
    cclean();
    976e:	e8 88 fd ff ff       	call   94fb <cclean>
    kbd_init(); //Init keyboard
    9773:	e8 cf 08 00 00       	call   a047 <kbd_init>
    //init Video graphics here
    9778:	90                   	nop
    9779:	c9                   	leave  
    977a:	c3                   	ret    

0000977b <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    977b:	55                   	push   %ebp
    977c:	89 e5                	mov    %esp,%ebp
    977e:	90                   	nop
    977f:	5d                   	pop    %ebp
    9780:	c3                   	ret    

00009781 <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    9781:	55                   	push   %ebp
    9782:	89 e5                	mov    %esp,%ebp
    9784:	90                   	nop
    9785:	5d                   	pop    %ebp
    9786:	c3                   	ret    

00009787 <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    9787:	55                   	push   %ebp
    9788:	89 e5                	mov    %esp,%ebp
    978a:	83 ec 08             	sub    $0x8,%esp
    978d:	8b 55 10             	mov    0x10(%ebp),%edx
    9790:	8b 45 14             	mov    0x14(%ebp),%eax
    9793:	88 55 fc             	mov    %dl,-0x4(%ebp)
    9796:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15 = (limite & 0xFFFF);
    9799:	8b 45 0c             	mov    0xc(%ebp),%eax
    979c:	89 c2                	mov    %eax,%edx
    979e:	8b 45 18             	mov    0x18(%ebp),%eax
    97a1:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    97a4:	8b 45 0c             	mov    0xc(%ebp),%eax
    97a7:	c1 e8 10             	shr    $0x10,%eax
    97aa:	83 e0 0f             	and    $0xf,%eax
    97ad:	8b 55 18             	mov    0x18(%ebp),%edx
    97b0:	83 e0 0f             	and    $0xf,%eax
    97b3:	89 c1                	mov    %eax,%ecx
    97b5:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    97b9:	83 e0 f0             	and    $0xfffffff0,%eax
    97bc:	09 c8                	or     %ecx,%eax
    97be:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15 = (base & 0xFFFF);
    97c1:	8b 45 08             	mov    0x8(%ebp),%eax
    97c4:	89 c2                	mov    %eax,%edx
    97c6:	8b 45 18             	mov    0x18(%ebp),%eax
    97c9:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    97cd:	8b 45 08             	mov    0x8(%ebp),%eax
    97d0:	c1 e8 10             	shr    $0x10,%eax
    97d3:	89 c2                	mov    %eax,%edx
    97d5:	8b 45 18             	mov    0x18(%ebp),%eax
    97d8:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    97db:	8b 45 08             	mov    0x8(%ebp),%eax
    97de:	c1 e8 18             	shr    $0x18,%eax
    97e1:	89 c2                	mov    %eax,%edx
    97e3:	8b 45 18             	mov    0x18(%ebp),%eax
    97e6:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags = flags;
    97e9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    97ed:	83 e0 0f             	and    $0xf,%eax
    97f0:	89 c2                	mov    %eax,%edx
    97f2:	8b 45 18             	mov    0x18(%ebp),%eax
    97f5:	89 d1                	mov    %edx,%ecx
    97f7:	c1 e1 04             	shl    $0x4,%ecx
    97fa:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    97fe:	83 e2 0f             	and    $0xf,%edx
    9801:	09 ca                	or     %ecx,%edx
    9803:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    9806:	8b 45 18             	mov    0x18(%ebp),%eax
    9809:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    980d:	88 50 05             	mov    %dl,0x5(%eax)
}
    9810:	90                   	nop
    9811:	c9                   	leave  
    9812:	c3                   	ret    

00009813 <init_gdt>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt(void)
{
    9813:	55                   	push   %ebp
    9814:	89 e5                	mov    %esp,%ebp
    9816:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    9819:	a1 10 00 01 00       	mov    0x10010,%eax
    981e:	50                   	push   %eax
    981f:	6a 00                	push   $0x0
    9821:	6a 00                	push   $0x0
    9823:	6a 00                	push   $0x0
    9825:	6a 00                	push   $0x0
    9827:	e8 5b ff ff ff       	call   9787 <init_gdt_entry>
    982c:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    982f:	a1 10 00 01 00       	mov    0x10010,%eax
    9834:	83 c0 08             	add    $0x8,%eax
    9837:	50                   	push   %eax
    9838:	6a 04                	push   $0x4
    983a:	68 9a 00 00 00       	push   $0x9a
    983f:	68 ff ff 0f 00       	push   $0xfffff
    9844:	6a 00                	push   $0x0
    9846:	e8 3c ff ff ff       	call   9787 <init_gdt_entry>
    984b:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    984e:	a1 10 00 01 00       	mov    0x10010,%eax
    9853:	83 c0 10             	add    $0x10,%eax
    9856:	50                   	push   %eax
    9857:	6a 04                	push   $0x4
    9859:	68 92 00 00 00       	push   $0x92
    985e:	68 ff ff 0f 00       	push   $0xfffff
    9863:	6a 00                	push   $0x0
    9865:	e8 1d ff ff ff       	call   9787 <init_gdt_entry>
    986a:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    986d:	a1 10 00 01 00       	mov    0x10010,%eax
    9872:	83 c0 18             	add    $0x18,%eax
    9875:	50                   	push   %eax
    9876:	6a 04                	push   $0x4
    9878:	68 96 00 00 00       	push   $0x96
    987d:	68 ff ff 0f 00       	push   $0xfffff
    9882:	6a 00                	push   $0x0
    9884:	e8 fe fe ff ff       	call   9787 <init_gdt_entry>
    9889:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Segment de tâches
    init_gdt_entry(0, 0xFFFFFF, TSS_PRIVILEGE_0,
    988c:	a1 10 00 01 00       	mov    0x10010,%eax
    9891:	83 c0 20             	add    $0x20,%eax
    9894:	50                   	push   %eax
    9895:	6a 04                	push   $0x4
    9897:	68 89 00 00 00       	push   $0x89
    989c:	68 ff ff ff 00       	push   $0xffffff
    98a1:	6a 00                	push   $0x0
    98a3:	e8 df fe ff ff       	call   9787 <init_gdt_entry>
    98a8:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[4]);

    // Chargement de la GDT
    load_gdt();
    98ab:	e8 96 1a 00 00       	call   b346 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    98b0:	66 b8 10 00          	mov    $0x10,%ax
    98b4:	8e d8                	mov    %eax,%ds
    98b6:	8e c0                	mov    %eax,%es
    98b8:	8e e0                	mov    %eax,%fs
    98ba:	8e e8                	mov    %eax,%gs
    98bc:	66 b8 18 00          	mov    $0x18,%ax
    98c0:	8e d0                	mov    %eax,%ss
    98c2:	ea c9 98 00 00 08 00 	ljmp   $0x8,$0x98c9

000098c9 <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    98c9:	90                   	nop
    98ca:	c9                   	leave  
    98cb:	c3                   	ret    

000098cc <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    98cc:	55                   	push   %ebp
    98cd:	89 e5                	mov    %esp,%ebp
    98cf:	83 ec 18             	sub    $0x18,%esp
    98d2:	8b 45 08             	mov    0x8(%ebp),%eax
    98d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    98d8:	8b 55 18             	mov    0x18(%ebp),%edx
    98db:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    98df:	89 c8                	mov    %ecx,%eax
    98e1:	88 45 f8             	mov    %al,-0x8(%ebp)
    98e4:	8b 45 10             	mov    0x10(%ebp),%eax
    98e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    98ea:	8b 45 14             	mov    0x14(%ebp),%eax
    98ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    98f0:	89 d0                	mov    %edx,%eax
    98f2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    98f6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    98fa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    98fe:	66 89 14 c5 22 00 01 	mov    %dx,0x10022(,%eax,8)
    9905:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    9906:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    990a:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    990e:	88 14 c5 25 00 01 00 	mov    %dl,0x10025(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    9915:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9919:	c6 04 c5 24 00 01 00 	movb   $0x0,0x10024(,%eax,8)
    9920:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    9921:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9925:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9928:	66 89 14 c5 20 00 01 	mov    %dx,0x10020(,%eax,8)
    992f:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    9930:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9933:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9936:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    993a:	c1 ea 10             	shr    $0x10,%edx
    993d:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    9941:	66 89 04 cd 26 00 01 	mov    %ax,0x10026(,%ecx,8)
    9948:	00 
}
    9949:	90                   	nop
    994a:	c9                   	leave  
    994b:	c3                   	ret    

0000994c <init_idt>:

void init_idt()
{
    994c:	55                   	push   %ebp
    994d:	89 e5                	mov    %esp,%ebp
    994f:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    9952:	83 ec 0c             	sub    $0xc,%esp
    9955:	68 ad da 00 00       	push   $0xdaad
    995a:	e8 12 0e 00 00       	call   a771 <Init_PIT>
    995f:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    9962:	83 ec 08             	sub    $0x8,%esp
    9965:	6a 28                	push   $0x28
    9967:	6a 20                	push   $0x20
    9969:	e8 16 0b 00 00       	call   a484 <PIC_remap>
    996e:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    9971:	b8 60 b4 00 00       	mov    $0xb460,%eax
    9976:	ba 00 00 00 00       	mov    $0x0,%edx
    997b:	83 ec 0c             	sub    $0xc,%esp
    997e:	6a 20                	push   $0x20
    9980:	52                   	push   %edx
    9981:	50                   	push   %eax
    9982:	68 8e 00 00 00       	push   $0x8e
    9987:	6a 08                	push   $0x8
    9989:	e8 3e ff ff ff       	call   98cc <set_idt>
    998e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    9991:	b8 b0 b3 00 00       	mov    $0xb3b0,%eax
    9996:	ba 00 00 00 00       	mov    $0x0,%edx
    999b:	83 ec 0c             	sub    $0xc,%esp
    999e:	6a 21                	push   $0x21
    99a0:	52                   	push   %edx
    99a1:	50                   	push   %eax
    99a2:	68 8e 00 00 00       	push   $0x8e
    99a7:	6a 08                	push   $0x8
    99a9:	e8 1e ff ff ff       	call   98cc <set_idt>
    99ae:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    99b1:	b8 b8 b3 00 00       	mov    $0xb3b8,%eax
    99b6:	ba 00 00 00 00       	mov    $0x0,%edx
    99bb:	83 ec 0c             	sub    $0xc,%esp
    99be:	6a 22                	push   $0x22
    99c0:	52                   	push   %edx
    99c1:	50                   	push   %eax
    99c2:	68 8e 00 00 00       	push   $0x8e
    99c7:	6a 08                	push   $0x8
    99c9:	e8 fe fe ff ff       	call   98cc <set_idt>
    99ce:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    99d1:	b8 c0 b3 00 00       	mov    $0xb3c0,%eax
    99d6:	ba 00 00 00 00       	mov    $0x0,%edx
    99db:	83 ec 0c             	sub    $0xc,%esp
    99de:	6a 23                	push   $0x23
    99e0:	52                   	push   %edx
    99e1:	50                   	push   %eax
    99e2:	68 8e 00 00 00       	push   $0x8e
    99e7:	6a 08                	push   $0x8
    99e9:	e8 de fe ff ff       	call   98cc <set_idt>
    99ee:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    99f1:	b8 c8 b3 00 00       	mov    $0xb3c8,%eax
    99f6:	ba 00 00 00 00       	mov    $0x0,%edx
    99fb:	83 ec 0c             	sub    $0xc,%esp
    99fe:	6a 24                	push   $0x24
    9a00:	52                   	push   %edx
    9a01:	50                   	push   %eax
    9a02:	68 8e 00 00 00       	push   $0x8e
    9a07:	6a 08                	push   $0x8
    9a09:	e8 be fe ff ff       	call   98cc <set_idt>
    9a0e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    9a11:	b8 d0 b3 00 00       	mov    $0xb3d0,%eax
    9a16:	ba 00 00 00 00       	mov    $0x0,%edx
    9a1b:	83 ec 0c             	sub    $0xc,%esp
    9a1e:	6a 25                	push   $0x25
    9a20:	52                   	push   %edx
    9a21:	50                   	push   %eax
    9a22:	68 8e 00 00 00       	push   $0x8e
    9a27:	6a 08                	push   $0x8
    9a29:	e8 9e fe ff ff       	call   98cc <set_idt>
    9a2e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    9a31:	b8 d8 b3 00 00       	mov    $0xb3d8,%eax
    9a36:	ba 00 00 00 00       	mov    $0x0,%edx
    9a3b:	83 ec 0c             	sub    $0xc,%esp
    9a3e:	6a 26                	push   $0x26
    9a40:	52                   	push   %edx
    9a41:	50                   	push   %eax
    9a42:	68 8e 00 00 00       	push   $0x8e
    9a47:	6a 08                	push   $0x8
    9a49:	e8 7e fe ff ff       	call   98cc <set_idt>
    9a4e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    9a51:	b8 e0 b3 00 00       	mov    $0xb3e0,%eax
    9a56:	ba 00 00 00 00       	mov    $0x0,%edx
    9a5b:	83 ec 0c             	sub    $0xc,%esp
    9a5e:	6a 27                	push   $0x27
    9a60:	52                   	push   %edx
    9a61:	50                   	push   %eax
    9a62:	68 8e 00 00 00       	push   $0x8e
    9a67:	6a 08                	push   $0x8
    9a69:	e8 5e fe ff ff       	call   98cc <set_idt>
    9a6e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    9a71:	b8 e8 b3 00 00       	mov    $0xb3e8,%eax
    9a76:	ba 00 00 00 00       	mov    $0x0,%edx
    9a7b:	83 ec 0c             	sub    $0xc,%esp
    9a7e:	6a 28                	push   $0x28
    9a80:	52                   	push   %edx
    9a81:	50                   	push   %eax
    9a82:	68 8e 00 00 00       	push   $0x8e
    9a87:	6a 08                	push   $0x8
    9a89:	e8 3e fe ff ff       	call   98cc <set_idt>
    9a8e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    9a91:	b8 f0 b3 00 00       	mov    $0xb3f0,%eax
    9a96:	ba 00 00 00 00       	mov    $0x0,%edx
    9a9b:	83 ec 0c             	sub    $0xc,%esp
    9a9e:	6a 29                	push   $0x29
    9aa0:	52                   	push   %edx
    9aa1:	50                   	push   %eax
    9aa2:	68 8e 00 00 00       	push   $0x8e
    9aa7:	6a 08                	push   $0x8
    9aa9:	e8 1e fe ff ff       	call   98cc <set_idt>
    9aae:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    9ab1:	b8 f8 b3 00 00       	mov    $0xb3f8,%eax
    9ab6:	ba 00 00 00 00       	mov    $0x0,%edx
    9abb:	83 ec 0c             	sub    $0xc,%esp
    9abe:	6a 2a                	push   $0x2a
    9ac0:	52                   	push   %edx
    9ac1:	50                   	push   %eax
    9ac2:	68 8e 00 00 00       	push   $0x8e
    9ac7:	6a 08                	push   $0x8
    9ac9:	e8 fe fd ff ff       	call   98cc <set_idt>
    9ace:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    9ad1:	b8 00 b4 00 00       	mov    $0xb400,%eax
    9ad6:	ba 00 00 00 00       	mov    $0x0,%edx
    9adb:	83 ec 0c             	sub    $0xc,%esp
    9ade:	6a 2b                	push   $0x2b
    9ae0:	52                   	push   %edx
    9ae1:	50                   	push   %eax
    9ae2:	68 8e 00 00 00       	push   $0x8e
    9ae7:	6a 08                	push   $0x8
    9ae9:	e8 de fd ff ff       	call   98cc <set_idt>
    9aee:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    9af1:	b8 08 b4 00 00       	mov    $0xb408,%eax
    9af6:	ba 00 00 00 00       	mov    $0x0,%edx
    9afb:	83 ec 0c             	sub    $0xc,%esp
    9afe:	6a 2c                	push   $0x2c
    9b00:	52                   	push   %edx
    9b01:	50                   	push   %eax
    9b02:	68 8e 00 00 00       	push   $0x8e
    9b07:	6a 08                	push   $0x8
    9b09:	e8 be fd ff ff       	call   98cc <set_idt>
    9b0e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    9b11:	b8 10 b4 00 00       	mov    $0xb410,%eax
    9b16:	ba 00 00 00 00       	mov    $0x0,%edx
    9b1b:	83 ec 0c             	sub    $0xc,%esp
    9b1e:	6a 2d                	push   $0x2d
    9b20:	52                   	push   %edx
    9b21:	50                   	push   %eax
    9b22:	68 8e 00 00 00       	push   $0x8e
    9b27:	6a 08                	push   $0x8
    9b29:	e8 9e fd ff ff       	call   98cc <set_idt>
    9b2e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    9b31:	b8 18 b4 00 00       	mov    $0xb418,%eax
    9b36:	ba 00 00 00 00       	mov    $0x0,%edx
    9b3b:	83 ec 0c             	sub    $0xc,%esp
    9b3e:	6a 2e                	push   $0x2e
    9b40:	52                   	push   %edx
    9b41:	50                   	push   %eax
    9b42:	68 8e 00 00 00       	push   $0x8e
    9b47:	6a 08                	push   $0x8
    9b49:	e8 7e fd ff ff       	call   98cc <set_idt>
    9b4e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    9b51:	b8 20 b4 00 00       	mov    $0xb420,%eax
    9b56:	ba 00 00 00 00       	mov    $0x0,%edx
    9b5b:	83 ec 0c             	sub    $0xc,%esp
    9b5e:	6a 2f                	push   $0x2f
    9b60:	52                   	push   %edx
    9b61:	50                   	push   %eax
    9b62:	68 8e 00 00 00       	push   $0x8e
    9b67:	6a 08                	push   $0x8
    9b69:	e8 5e fd ff ff       	call   98cc <set_idt>
    9b6e:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    9b71:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9b76:	ba 00 00 00 00       	mov    $0x0,%edx
    9b7b:	83 ec 0c             	sub    $0xc,%esp
    9b7e:	6a 08                	push   $0x8
    9b80:	52                   	push   %edx
    9b81:	50                   	push   %eax
    9b82:	68 8e 00 00 00       	push   $0x8e
    9b87:	6a 08                	push   $0x8
    9b89:	e8 3e fd ff ff       	call   98cc <set_idt>
    9b8e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    9b91:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9b96:	ba 00 00 00 00       	mov    $0x0,%edx
    9b9b:	83 ec 0c             	sub    $0xc,%esp
    9b9e:	6a 0a                	push   $0xa
    9ba0:	52                   	push   %edx
    9ba1:	50                   	push   %eax
    9ba2:	68 8e 00 00 00       	push   $0x8e
    9ba7:	6a 08                	push   $0x8
    9ba9:	e8 1e fd ff ff       	call   98cc <set_idt>
    9bae:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    9bb1:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9bb6:	ba 00 00 00 00       	mov    $0x0,%edx
    9bbb:	83 ec 0c             	sub    $0xc,%esp
    9bbe:	6a 0b                	push   $0xb
    9bc0:	52                   	push   %edx
    9bc1:	50                   	push   %eax
    9bc2:	68 8e 00 00 00       	push   $0x8e
    9bc7:	6a 08                	push   $0x8
    9bc9:	e8 fe fc ff ff       	call   98cc <set_idt>
    9bce:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9bd1:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9bd6:	ba 00 00 00 00       	mov    $0x0,%edx
    9bdb:	83 ec 0c             	sub    $0xc,%esp
    9bde:	6a 0c                	push   $0xc
    9be0:	52                   	push   %edx
    9be1:	50                   	push   %eax
    9be2:	68 8e 00 00 00       	push   $0x8e
    9be7:	6a 08                	push   $0x8
    9be9:	e8 de fc ff ff       	call   98cc <set_idt>
    9bee:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9bf1:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9bf6:	ba 00 00 00 00       	mov    $0x0,%edx
    9bfb:	83 ec 0c             	sub    $0xc,%esp
    9bfe:	6a 0d                	push   $0xd
    9c00:	52                   	push   %edx
    9c01:	50                   	push   %eax
    9c02:	68 8e 00 00 00       	push   $0x8e
    9c07:	6a 08                	push   $0x8
    9c09:	e8 be fc ff ff       	call   98cc <set_idt>
    9c0e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    9c11:	b8 53 a4 00 00       	mov    $0xa453,%eax
    9c16:	ba 00 00 00 00       	mov    $0x0,%edx
    9c1b:	83 ec 0c             	sub    $0xc,%esp
    9c1e:	6a 0e                	push   $0xe
    9c20:	52                   	push   %edx
    9c21:	50                   	push   %eax
    9c22:	68 8e 00 00 00       	push   $0x8e
    9c27:	6a 08                	push   $0x8
    9c29:	e8 9e fc ff ff       	call   98cc <set_idt>
    9c2e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    9c31:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9c36:	ba 00 00 00 00       	mov    $0x0,%edx
    9c3b:	83 ec 0c             	sub    $0xc,%esp
    9c3e:	6a 11                	push   $0x11
    9c40:	52                   	push   %edx
    9c41:	50                   	push   %eax
    9c42:	68 8e 00 00 00       	push   $0x8e
    9c47:	6a 08                	push   $0x8
    9c49:	e8 7e fc ff ff       	call   98cc <set_idt>
    9c4e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    9c51:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9c56:	ba 00 00 00 00       	mov    $0x0,%edx
    9c5b:	83 ec 0c             	sub    $0xc,%esp
    9c5e:	6a 1e                	push   $0x1e
    9c60:	52                   	push   %edx
    9c61:	50                   	push   %eax
    9c62:	68 8e 00 00 00       	push   $0x8e
    9c67:	6a 08                	push   $0x8
    9c69:	e8 5e fc ff ff       	call   98cc <set_idt>
    9c6e:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9c71:	b8 81 97 00 00       	mov    $0x9781,%eax
    9c76:	ba 00 00 00 00       	mov    $0x0,%edx
    9c7b:	83 ec 0c             	sub    $0xc,%esp
    9c7e:	6a 00                	push   $0x0
    9c80:	52                   	push   %edx
    9c81:	50                   	push   %eax
    9c82:	68 8e 00 00 00       	push   $0x8e
    9c87:	6a 08                	push   $0x8
    9c89:	e8 3e fc ff ff       	call   98cc <set_idt>
    9c8e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9c91:	b8 81 97 00 00       	mov    $0x9781,%eax
    9c96:	ba 00 00 00 00       	mov    $0x0,%edx
    9c9b:	83 ec 0c             	sub    $0xc,%esp
    9c9e:	6a 01                	push   $0x1
    9ca0:	52                   	push   %edx
    9ca1:	50                   	push   %eax
    9ca2:	68 8e 00 00 00       	push   $0x8e
    9ca7:	6a 08                	push   $0x8
    9ca9:	e8 1e fc ff ff       	call   98cc <set_idt>
    9cae:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9cb1:	b8 81 97 00 00       	mov    $0x9781,%eax
    9cb6:	ba 00 00 00 00       	mov    $0x0,%edx
    9cbb:	83 ec 0c             	sub    $0xc,%esp
    9cbe:	6a 02                	push   $0x2
    9cc0:	52                   	push   %edx
    9cc1:	50                   	push   %eax
    9cc2:	68 8e 00 00 00       	push   $0x8e
    9cc7:	6a 08                	push   $0x8
    9cc9:	e8 fe fb ff ff       	call   98cc <set_idt>
    9cce:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9cd1:	b8 81 97 00 00       	mov    $0x9781,%eax
    9cd6:	ba 00 00 00 00       	mov    $0x0,%edx
    9cdb:	83 ec 0c             	sub    $0xc,%esp
    9cde:	6a 03                	push   $0x3
    9ce0:	52                   	push   %edx
    9ce1:	50                   	push   %eax
    9ce2:	68 8e 00 00 00       	push   $0x8e
    9ce7:	6a 08                	push   $0x8
    9ce9:	e8 de fb ff ff       	call   98cc <set_idt>
    9cee:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9cf1:	b8 81 97 00 00       	mov    $0x9781,%eax
    9cf6:	ba 00 00 00 00       	mov    $0x0,%edx
    9cfb:	83 ec 0c             	sub    $0xc,%esp
    9cfe:	6a 04                	push   $0x4
    9d00:	52                   	push   %edx
    9d01:	50                   	push   %eax
    9d02:	68 8e 00 00 00       	push   $0x8e
    9d07:	6a 08                	push   $0x8
    9d09:	e8 be fb ff ff       	call   98cc <set_idt>
    9d0e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    9d11:	b8 81 97 00 00       	mov    $0x9781,%eax
    9d16:	ba 00 00 00 00       	mov    $0x0,%edx
    9d1b:	83 ec 0c             	sub    $0xc,%esp
    9d1e:	6a 05                	push   $0x5
    9d20:	52                   	push   %edx
    9d21:	50                   	push   %eax
    9d22:	68 8e 00 00 00       	push   $0x8e
    9d27:	6a 08                	push   $0x8
    9d29:	e8 9e fb ff ff       	call   98cc <set_idt>
    9d2e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    9d31:	b8 81 97 00 00       	mov    $0x9781,%eax
    9d36:	ba 00 00 00 00       	mov    $0x0,%edx
    9d3b:	83 ec 0c             	sub    $0xc,%esp
    9d3e:	6a 06                	push   $0x6
    9d40:	52                   	push   %edx
    9d41:	50                   	push   %eax
    9d42:	68 8e 00 00 00       	push   $0x8e
    9d47:	6a 08                	push   $0x8
    9d49:	e8 7e fb ff ff       	call   98cc <set_idt>
    9d4e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    9d51:	b8 81 97 00 00       	mov    $0x9781,%eax
    9d56:	ba 00 00 00 00       	mov    $0x0,%edx
    9d5b:	83 ec 0c             	sub    $0xc,%esp
    9d5e:	6a 07                	push   $0x7
    9d60:	52                   	push   %edx
    9d61:	50                   	push   %eax
    9d62:	68 8e 00 00 00       	push   $0x8e
    9d67:	6a 08                	push   $0x8
    9d69:	e8 5e fb ff ff       	call   98cc <set_idt>
    9d6e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9d71:	b8 81 97 00 00       	mov    $0x9781,%eax
    9d76:	ba 00 00 00 00       	mov    $0x0,%edx
    9d7b:	83 ec 0c             	sub    $0xc,%esp
    9d7e:	6a 09                	push   $0x9
    9d80:	52                   	push   %edx
    9d81:	50                   	push   %eax
    9d82:	68 8e 00 00 00       	push   $0x8e
    9d87:	6a 08                	push   $0x8
    9d89:	e8 3e fb ff ff       	call   98cc <set_idt>
    9d8e:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9d91:	b8 81 97 00 00       	mov    $0x9781,%eax
    9d96:	ba 00 00 00 00       	mov    $0x0,%edx
    9d9b:	83 ec 0c             	sub    $0xc,%esp
    9d9e:	6a 10                	push   $0x10
    9da0:	52                   	push   %edx
    9da1:	50                   	push   %eax
    9da2:	68 8e 00 00 00       	push   $0x8e
    9da7:	6a 08                	push   $0x8
    9da9:	e8 1e fb ff ff       	call   98cc <set_idt>
    9dae:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9db1:	b8 81 97 00 00       	mov    $0x9781,%eax
    9db6:	ba 00 00 00 00       	mov    $0x0,%edx
    9dbb:	83 ec 0c             	sub    $0xc,%esp
    9dbe:	6a 12                	push   $0x12
    9dc0:	52                   	push   %edx
    9dc1:	50                   	push   %eax
    9dc2:	68 8e 00 00 00       	push   $0x8e
    9dc7:	6a 08                	push   $0x8
    9dc9:	e8 fe fa ff ff       	call   98cc <set_idt>
    9dce:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9dd1:	b8 81 97 00 00       	mov    $0x9781,%eax
    9dd6:	ba 00 00 00 00       	mov    $0x0,%edx
    9ddb:	83 ec 0c             	sub    $0xc,%esp
    9dde:	6a 13                	push   $0x13
    9de0:	52                   	push   %edx
    9de1:	50                   	push   %eax
    9de2:	68 8e 00 00 00       	push   $0x8e
    9de7:	6a 08                	push   $0x8
    9de9:	e8 de fa ff ff       	call   98cc <set_idt>
    9dee:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9df1:	b8 81 97 00 00       	mov    $0x9781,%eax
    9df6:	ba 00 00 00 00       	mov    $0x0,%edx
    9dfb:	83 ec 0c             	sub    $0xc,%esp
    9dfe:	6a 14                	push   $0x14
    9e00:	52                   	push   %edx
    9e01:	50                   	push   %eax
    9e02:	68 8e 00 00 00       	push   $0x8e
    9e07:	6a 08                	push   $0x8
    9e09:	e8 be fa ff ff       	call   98cc <set_idt>
    9e0e:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    9e11:	e8 69 15 00 00       	call   b37f <load_idt>
}
    9e16:	90                   	nop
    9e17:	c9                   	leave  
    9e18:	c3                   	ret    

00009e19 <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    9e19:	55                   	push   %ebp
    9e1a:	89 e5                	mov    %esp,%ebp
    9e1c:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    9e1f:	e8 4a 02 00 00       	call   a06e <keyboard_irq>
    PIC_sendEOI(1);
    9e24:	83 ec 0c             	sub    $0xc,%esp
    9e27:	6a 01                	push   $0x1
    9e29:	e8 2b 06 00 00       	call   a459 <PIC_sendEOI>
    9e2e:	83 c4 10             	add    $0x10,%esp
}
    9e31:	90                   	nop
    9e32:	c9                   	leave  
    9e33:	c3                   	ret    

00009e34 <irq2_handler>:

void irq2_handler(void)
{
    9e34:	55                   	push   %ebp
    9e35:	89 e5                	mov    %esp,%ebp
    9e37:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    9e3a:	83 ec 0c             	sub    $0xc,%esp
    9e3d:	6a 02                	push   $0x2
    9e3f:	e8 21 08 00 00       	call   a665 <spurious_IRQ>
    9e44:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9e47:	83 ec 0c             	sub    $0xc,%esp
    9e4a:	6a 02                	push   $0x2
    9e4c:	e8 08 06 00 00       	call   a459 <PIC_sendEOI>
    9e51:	83 c4 10             	add    $0x10,%esp
}
    9e54:	90                   	nop
    9e55:	c9                   	leave  
    9e56:	c3                   	ret    

00009e57 <irq3_handler>:

void irq3_handler(void)
{
    9e57:	55                   	push   %ebp
    9e58:	89 e5                	mov    %esp,%ebp
    9e5a:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    9e5d:	83 ec 0c             	sub    $0xc,%esp
    9e60:	6a 03                	push   $0x3
    9e62:	e8 fe 07 00 00       	call   a665 <spurious_IRQ>
    9e67:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9e6a:	83 ec 0c             	sub    $0xc,%esp
    9e6d:	6a 03                	push   $0x3
    9e6f:	e8 e5 05 00 00       	call   a459 <PIC_sendEOI>
    9e74:	83 c4 10             	add    $0x10,%esp
}
    9e77:	90                   	nop
    9e78:	c9                   	leave  
    9e79:	c3                   	ret    

00009e7a <irq4_handler>:

void irq4_handler(void)
{
    9e7a:	55                   	push   %ebp
    9e7b:	89 e5                	mov    %esp,%ebp
    9e7d:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    9e80:	83 ec 0c             	sub    $0xc,%esp
    9e83:	6a 04                	push   $0x4
    9e85:	e8 db 07 00 00       	call   a665 <spurious_IRQ>
    9e8a:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9e8d:	83 ec 0c             	sub    $0xc,%esp
    9e90:	6a 04                	push   $0x4
    9e92:	e8 c2 05 00 00       	call   a459 <PIC_sendEOI>
    9e97:	83 c4 10             	add    $0x10,%esp
}
    9e9a:	90                   	nop
    9e9b:	c9                   	leave  
    9e9c:	c3                   	ret    

00009e9d <irq5_handler>:

void irq5_handler(void)
{
    9e9d:	55                   	push   %ebp
    9e9e:	89 e5                	mov    %esp,%ebp
    9ea0:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9ea3:	83 ec 0c             	sub    $0xc,%esp
    9ea6:	6a 05                	push   $0x5
    9ea8:	e8 b8 07 00 00       	call   a665 <spurious_IRQ>
    9ead:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9eb0:	83 ec 0c             	sub    $0xc,%esp
    9eb3:	6a 05                	push   $0x5
    9eb5:	e8 9f 05 00 00       	call   a459 <PIC_sendEOI>
    9eba:	83 c4 10             	add    $0x10,%esp
}
    9ebd:	90                   	nop
    9ebe:	c9                   	leave  
    9ebf:	c3                   	ret    

00009ec0 <irq6_handler>:

void irq6_handler(void)
{
    9ec0:	55                   	push   %ebp
    9ec1:	89 e5                	mov    %esp,%ebp
    9ec3:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9ec6:	83 ec 0c             	sub    $0xc,%esp
    9ec9:	6a 06                	push   $0x6
    9ecb:	e8 95 07 00 00       	call   a665 <spurious_IRQ>
    9ed0:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9ed3:	83 ec 0c             	sub    $0xc,%esp
    9ed6:	6a 06                	push   $0x6
    9ed8:	e8 7c 05 00 00       	call   a459 <PIC_sendEOI>
    9edd:	83 c4 10             	add    $0x10,%esp
}
    9ee0:	90                   	nop
    9ee1:	c9                   	leave  
    9ee2:	c3                   	ret    

00009ee3 <irq7_handler>:

void irq7_handler(void)
{
    9ee3:	55                   	push   %ebp
    9ee4:	89 e5                	mov    %esp,%ebp
    9ee6:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9ee9:	83 ec 0c             	sub    $0xc,%esp
    9eec:	6a 07                	push   $0x7
    9eee:	e8 72 07 00 00       	call   a665 <spurious_IRQ>
    9ef3:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9ef6:	83 ec 0c             	sub    $0xc,%esp
    9ef9:	6a 07                	push   $0x7
    9efb:	e8 59 05 00 00       	call   a459 <PIC_sendEOI>
    9f00:	83 c4 10             	add    $0x10,%esp
}
    9f03:	90                   	nop
    9f04:	c9                   	leave  
    9f05:	c3                   	ret    

00009f06 <irq8_handler>:

void irq8_handler(void)
{
    9f06:	55                   	push   %ebp
    9f07:	89 e5                	mov    %esp,%ebp
    9f09:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    9f0c:	83 ec 0c             	sub    $0xc,%esp
    9f0f:	6a 08                	push   $0x8
    9f11:	e8 4f 07 00 00       	call   a665 <spurious_IRQ>
    9f16:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9f19:	83 ec 0c             	sub    $0xc,%esp
    9f1c:	6a 08                	push   $0x8
    9f1e:	e8 36 05 00 00       	call   a459 <PIC_sendEOI>
    9f23:	83 c4 10             	add    $0x10,%esp
}
    9f26:	90                   	nop
    9f27:	c9                   	leave  
    9f28:	c3                   	ret    

00009f29 <irq9_handler>:

void irq9_handler(void)
{
    9f29:	55                   	push   %ebp
    9f2a:	89 e5                	mov    %esp,%ebp
    9f2c:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    9f2f:	83 ec 0c             	sub    $0xc,%esp
    9f32:	6a 09                	push   $0x9
    9f34:	e8 2c 07 00 00       	call   a665 <spurious_IRQ>
    9f39:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9f3c:	83 ec 0c             	sub    $0xc,%esp
    9f3f:	6a 09                	push   $0x9
    9f41:	e8 13 05 00 00       	call   a459 <PIC_sendEOI>
    9f46:	83 c4 10             	add    $0x10,%esp
}
    9f49:	90                   	nop
    9f4a:	c9                   	leave  
    9f4b:	c3                   	ret    

00009f4c <irq10_handler>:

void irq10_handler(void)
{
    9f4c:	55                   	push   %ebp
    9f4d:	89 e5                	mov    %esp,%ebp
    9f4f:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    9f52:	83 ec 0c             	sub    $0xc,%esp
    9f55:	6a 0a                	push   $0xa
    9f57:	e8 09 07 00 00       	call   a665 <spurious_IRQ>
    9f5c:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9f5f:	83 ec 0c             	sub    $0xc,%esp
    9f62:	6a 0a                	push   $0xa
    9f64:	e8 f0 04 00 00       	call   a459 <PIC_sendEOI>
    9f69:	83 c4 10             	add    $0x10,%esp
}
    9f6c:	90                   	nop
    9f6d:	c9                   	leave  
    9f6e:	c3                   	ret    

00009f6f <irq11_handler>:

void irq11_handler(void)
{
    9f6f:	55                   	push   %ebp
    9f70:	89 e5                	mov    %esp,%ebp
    9f72:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9f75:	83 ec 0c             	sub    $0xc,%esp
    9f78:	6a 0b                	push   $0xb
    9f7a:	e8 e6 06 00 00       	call   a665 <spurious_IRQ>
    9f7f:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9f82:	83 ec 0c             	sub    $0xc,%esp
    9f85:	6a 0b                	push   $0xb
    9f87:	e8 cd 04 00 00       	call   a459 <PIC_sendEOI>
    9f8c:	83 c4 10             	add    $0x10,%esp
}
    9f8f:	90                   	nop
    9f90:	c9                   	leave  
    9f91:	c3                   	ret    

00009f92 <irq12_handler>:

void irq12_handler(void)
{
    9f92:	55                   	push   %ebp
    9f93:	89 e5                	mov    %esp,%ebp
    9f95:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9f98:	83 ec 0c             	sub    $0xc,%esp
    9f9b:	6a 0c                	push   $0xc
    9f9d:	e8 c3 06 00 00       	call   a665 <spurious_IRQ>
    9fa2:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9fa5:	83 ec 0c             	sub    $0xc,%esp
    9fa8:	6a 0c                	push   $0xc
    9faa:	e8 aa 04 00 00       	call   a459 <PIC_sendEOI>
    9faf:	83 c4 10             	add    $0x10,%esp
}
    9fb2:	90                   	nop
    9fb3:	c9                   	leave  
    9fb4:	c3                   	ret    

00009fb5 <irq13_handler>:

void irq13_handler(void)
{
    9fb5:	55                   	push   %ebp
    9fb6:	89 e5                	mov    %esp,%ebp
    9fb8:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9fbb:	83 ec 0c             	sub    $0xc,%esp
    9fbe:	6a 0d                	push   $0xd
    9fc0:	e8 a0 06 00 00       	call   a665 <spurious_IRQ>
    9fc5:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9fc8:	83 ec 0c             	sub    $0xc,%esp
    9fcb:	6a 0d                	push   $0xd
    9fcd:	e8 87 04 00 00       	call   a459 <PIC_sendEOI>
    9fd2:	83 c4 10             	add    $0x10,%esp
}
    9fd5:	90                   	nop
    9fd6:	c9                   	leave  
    9fd7:	c3                   	ret    

00009fd8 <irq14_handler>:

void irq14_handler(void)
{
    9fd8:	55                   	push   %ebp
    9fd9:	89 e5                	mov    %esp,%ebp
    9fdb:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9fde:	83 ec 0c             	sub    $0xc,%esp
    9fe1:	6a 0e                	push   $0xe
    9fe3:	e8 7d 06 00 00       	call   a665 <spurious_IRQ>
    9fe8:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9feb:	83 ec 0c             	sub    $0xc,%esp
    9fee:	6a 0e                	push   $0xe
    9ff0:	e8 64 04 00 00       	call   a459 <PIC_sendEOI>
    9ff5:	83 c4 10             	add    $0x10,%esp
}
    9ff8:	90                   	nop
    9ff9:	c9                   	leave  
    9ffa:	c3                   	ret    

00009ffb <irq15_handler>:

void irq15_handler(void)
{
    9ffb:	55                   	push   %ebp
    9ffc:	89 e5                	mov    %esp,%ebp
    9ffe:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    a001:	83 ec 0c             	sub    $0xc,%esp
    a004:	6a 0f                	push   $0xf
    a006:	e8 5a 06 00 00       	call   a665 <spurious_IRQ>
    a00b:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    a00e:	83 ec 0c             	sub    $0xc,%esp
    a011:	6a 0f                	push   $0xf
    a013:	e8 41 04 00 00       	call   a459 <PIC_sendEOI>
    a018:	83 c4 10             	add    $0x10,%esp
    a01b:	90                   	nop
    a01c:	c9                   	leave  
    a01d:	c3                   	ret    

0000a01e <keyboard_add_service>:
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x60)  */
          0xFF, 0xFF, 0xFF, 0xFF  /*      (0x61)  */
      };

void keyboard_add_service(void (*func)())
{
    a01e:	55                   	push   %ebp
    a01f:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service[keyboard_ctrl.kbd_service_num] = func;
    a021:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a028:	0f be c0             	movsbl %al,%eax
    a02b:	8b 55 08             	mov    0x8(%ebp),%edx
    a02e:	89 14 85 22 08 01 00 	mov    %edx,0x10822(,%eax,4)
    keyboard_ctrl.kbd_service_num++;
    a035:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a03c:	83 c0 01             	add    $0x1,%eax
    a03f:	a2 21 08 01 00       	mov    %al,0x10821
}
    a044:	90                   	nop
    a045:	5d                   	pop    %ebp
    a046:	c3                   	ret    

0000a047 <kbd_init>:

void kbd_init()
{
    a047:	55                   	push   %ebp
    a048:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service_num = 0;
    a04a:	c6 05 21 08 01 00 00 	movb   $0x0,0x10821
    keyboard_add_service(console_service_keyboard);
    a051:	68 3b 97 00 00       	push   $0x973b
    a056:	e8 c3 ff ff ff       	call   a01e <keyboard_add_service>
    a05b:	83 c4 04             	add    $0x4,%esp
    keyboard_add_service(monitor_service_keyboard);
    a05e:	68 a4 a9 00 00       	push   $0xa9a4
    a063:	e8 b6 ff ff ff       	call   a01e <keyboard_add_service>
    a068:	83 c4 04             	add    $0x4,%esp
}
    a06b:	90                   	nop
    a06c:	c9                   	leave  
    a06d:	c3                   	ret    

0000a06e <keyboard_irq>:

void keyboard_irq()
{
    a06e:	55                   	push   %ebp
    a06f:	89 e5                	mov    %esp,%ebp
    a071:	83 ec 18             	sub    $0x18,%esp

    int i;
    void (*func)(void);

    do {
        keyboard_ctrl.code = _8042_get_status;
    a074:	b8 64 00 00 00       	mov    $0x64,%eax
    a079:	89 c2                	mov    %eax,%edx
    a07b:	ec                   	in     (%dx),%al
    a07c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a080:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a084:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e
    } while ((keyboard_ctrl.code & 0x01) == _8042_BUFFER_OVERRUN);
    a08a:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a091:	98                   	cwtl   
    a092:	83 e0 01             	and    $0x1,%eax
    a095:	85 c0                	test   %eax,%eax
    a097:	74 db                	je     a074 <keyboard_irq+0x6>

    keyboard_ctrl.code = _8042_scan_code;
    a099:	b8 60 00 00 00       	mov    $0x60,%eax
    a09e:	89 c2                	mov    %eax,%edx
    a0a0:	ec                   	in     (%dx),%al
    a0a1:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a0a5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a0a9:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    a0af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a0b6:	eb 16                	jmp    a0ce <keyboard_irq+0x60>
        func = keyboard_ctrl.kbd_service[i];
    a0b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a0bb:	8b 04 85 22 08 01 00 	mov    0x10822(,%eax,4),%eax
    a0c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        func();
    a0c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a0c8:	ff d0                	call   *%eax
    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    a0ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a0ce:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a0d5:	0f be c0             	movsbl %al,%eax
    a0d8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a0db:	7c db                	jl     a0b8 <keyboard_irq+0x4a>
    }
}
    a0dd:	90                   	nop
    a0de:	90                   	nop
    a0df:	c9                   	leave  
    a0e0:	c3                   	ret    

0000a0e1 <reinitialise_kbd>:

void reinitialise_kbd()
{
    a0e1:	55                   	push   %ebp
    a0e2:	89 e5                	mov    %esp,%ebp
    a0e4:	83 ec 08             	sub    $0x8,%esp
    wait_8042_ACK();
    a0e7:	e8 43 00 00 00       	call   a12f <wait_8042_ACK>
    _8042_send_get_current_scan_code;
    a0ec:	ba 64 00 00 00       	mov    $0x64,%edx
    a0f1:	b8 f0 00 00 00       	mov    $0xf0,%eax
    a0f6:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a0f7:	e8 33 00 00 00       	call   a12f <wait_8042_ACK>

    _8042_set_typematic_rate;
    a0fc:	ba 64 00 00 00       	mov    $0x64,%edx
    a101:	b8 f3 00 00 00       	mov    $0xf3,%eax
    a106:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a107:	e8 23 00 00 00       	call   a12f <wait_8042_ACK>

    _8042_set_leds;
    a10c:	ba 64 00 00 00       	mov    $0x64,%edx
    a111:	b8 ed 00 00 00       	mov    $0xed,%eax
    a116:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a117:	e8 13 00 00 00       	call   a12f <wait_8042_ACK>

    _8042_enable_scanning;
    a11c:	ba 64 00 00 00       	mov    $0x64,%edx
    a121:	b8 f4 00 00 00       	mov    $0xf4,%eax
    a126:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a127:	e8 03 00 00 00       	call   a12f <wait_8042_ACK>
}
    a12c:	90                   	nop
    a12d:	c9                   	leave  
    a12e:	c3                   	ret    

0000a12f <wait_8042_ACK>:

static void
wait_8042_ACK()
{
    a12f:	55                   	push   %ebp
    a130:	89 e5                	mov    %esp,%ebp
    a132:	83 ec 10             	sub    $0x10,%esp
    while (_8042_get_status != _8042_ACK)
    a135:	90                   	nop
    a136:	b8 64 00 00 00       	mov    $0x64,%eax
    a13b:	89 c2                	mov    %eax,%edx
    a13d:	ec                   	in     (%dx),%al
    a13e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a142:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a146:	66 3d fa 00          	cmp    $0xfa,%ax
    a14a:	75 ea                	jne    a136 <wait_8042_ACK+0x7>
        ;
}
    a14c:	90                   	nop
    a14d:	90                   	nop
    a14e:	c9                   	leave  
    a14f:	c3                   	ret    

0000a150 <get_code_kbd_control>:

int16_t get_code_kbd_control()
{
    a150:	55                   	push   %ebp
    a151:	89 e5                	mov    %esp,%ebp
    return keyboard_ctrl.code;
    a153:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
}
    a15a:	5d                   	pop    %ebp
    a15b:	c3                   	ret    

0000a15c <handle_ASCII_code_keyboard>:

static void handle_ASCII_code_keyboard()
{
    a15c:	55                   	push   %ebp
    a15d:	89 e5                	mov    %esp,%ebp
    a15f:	83 ec 10             	sub    $0x10,%esp
    int16_t _code = keyboard_ctrl.code - 1;
    a162:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a169:	83 e8 01             	sub    $0x1,%eax
    a16c:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    if (_code < 0x80) { /* key held down */
    a170:	66 83 7d fe 7f       	cmpw   $0x7f,-0x2(%ebp)
    a175:	0f 8f 8f 00 00 00    	jg     a20a <handle_ASCII_code_keyboard+0xae>
        switch (_code) {
    a17b:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a17f:	83 f8 37             	cmp    $0x37,%eax
    a182:	74 3d                	je     a1c1 <handle_ASCII_code_keyboard+0x65>
    a184:	83 f8 37             	cmp    $0x37,%eax
    a187:	7f 44                	jg     a1cd <handle_ASCII_code_keyboard+0x71>
    a189:	83 f8 35             	cmp    $0x35,%eax
    a18c:	74 1b                	je     a1a9 <handle_ASCII_code_keyboard+0x4d>
    a18e:	83 f8 35             	cmp    $0x35,%eax
    a191:	7f 3a                	jg     a1cd <handle_ASCII_code_keyboard+0x71>
    a193:	83 f8 1c             	cmp    $0x1c,%eax
    a196:	74 1d                	je     a1b5 <handle_ASCII_code_keyboard+0x59>
    a198:	83 f8 29             	cmp    $0x29,%eax
    a19b:	75 30                	jne    a1cd <handle_ASCII_code_keyboard+0x71>
        case 0x29: lshift_enable = 1; break;
    a19d:	c6 05 20 0c 01 00 01 	movb   $0x1,0x10c20
    a1a4:	e9 b8 00 00 00       	jmp    a261 <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 1; break;
    a1a9:	c6 05 21 0c 01 00 01 	movb   $0x1,0x10c21
    a1b0:	e9 ac 00 00 00       	jmp    a261 <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 1; break;
    a1b5:	c6 05 23 0c 01 00 01 	movb   $0x1,0x10c23
    a1bc:	e9 a0 00 00 00       	jmp    a261 <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 1; break;
    a1c1:	c6 05 22 0c 01 00 01 	movb   $0x1,0x10c22
    a1c8:	e9 94 00 00 00       	jmp    a261 <handle_ASCII_code_keyboard+0x105>
        default:
            keyboard_ctrl.ascii_code_keyboard = kbdmap[_code * 4 + (lshift_enable || rshift_enable)];
    a1cd:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a1d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a1d8:	0f b6 05 20 0c 01 00 	movzbl 0x10c20,%eax
    a1df:	84 c0                	test   %al,%al
    a1e1:	75 0b                	jne    a1ee <handle_ASCII_code_keyboard+0x92>
    a1e3:	0f b6 05 21 0c 01 00 	movzbl 0x10c21,%eax
    a1ea:	84 c0                	test   %al,%al
    a1ec:	74 07                	je     a1f5 <handle_ASCII_code_keyboard+0x99>
    a1ee:	b8 01 00 00 00       	mov    $0x1,%eax
    a1f3:	eb 05                	jmp    a1fa <handle_ASCII_code_keyboard+0x9e>
    a1f5:	b8 00 00 00 00       	mov    $0x0,%eax
    a1fa:	01 d0                	add    %edx,%eax
    a1fc:	0f b6 80 c0 b5 00 00 	movzbl 0xb5c0(%eax),%eax
    a203:	a2 20 08 01 00       	mov    %al,0x10820
        case 0x35: rshift_enable = 0; break;
        case 0x1C: ctrl_enable = 0; break;
        case 0x37: alt_enable = 0; break;
        }
    }
}
    a208:	eb 57                	jmp    a261 <handle_ASCII_code_keyboard+0x105>
        _code -= 0x80;
    a20a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a20e:	83 c0 80             	add    $0xffffff80,%eax
    a211:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
        keyboard_ctrl.ascii_code_keyboard = '\0'; //Free it when release the key
    a215:	c6 05 20 08 01 00 00 	movb   $0x0,0x10820
        switch (_code) {
    a21c:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a220:	83 f8 37             	cmp    $0x37,%eax
    a223:	74 34                	je     a259 <handle_ASCII_code_keyboard+0xfd>
    a225:	83 f8 37             	cmp    $0x37,%eax
    a228:	7f 37                	jg     a261 <handle_ASCII_code_keyboard+0x105>
    a22a:	83 f8 35             	cmp    $0x35,%eax
    a22d:	74 18                	je     a247 <handle_ASCII_code_keyboard+0xeb>
    a22f:	83 f8 35             	cmp    $0x35,%eax
    a232:	7f 2d                	jg     a261 <handle_ASCII_code_keyboard+0x105>
    a234:	83 f8 1c             	cmp    $0x1c,%eax
    a237:	74 17                	je     a250 <handle_ASCII_code_keyboard+0xf4>
    a239:	83 f8 29             	cmp    $0x29,%eax
    a23c:	75 23                	jne    a261 <handle_ASCII_code_keyboard+0x105>
        case 0x29: lshift_enable = 0; break;
    a23e:	c6 05 20 0c 01 00 00 	movb   $0x0,0x10c20
    a245:	eb 1a                	jmp    a261 <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 0; break;
    a247:	c6 05 21 0c 01 00 00 	movb   $0x0,0x10c21
    a24e:	eb 11                	jmp    a261 <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 0; break;
    a250:	c6 05 23 0c 01 00 00 	movb   $0x0,0x10c23
    a257:	eb 08                	jmp    a261 <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 0; break;
    a259:	c6 05 22 0c 01 00 00 	movb   $0x0,0x10c22
    a260:	90                   	nop
}
    a261:	90                   	nop
    a262:	c9                   	leave  
    a263:	c3                   	ret    

0000a264 <get_ASCII_code_keyboard>:

int8_t get_ASCII_code_keyboard()
{
    a264:	55                   	push   %ebp
    a265:	89 e5                	mov    %esp,%ebp

    handle_ASCII_code_keyboard();
    a267:	e8 f0 fe ff ff       	call   a15c <handle_ASCII_code_keyboard>

    return keyboard_ctrl.ascii_code_keyboard;
    a26c:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    a273:	5d                   	pop    %ebp
    a274:	c3                   	ret    

0000a275 <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    a275:	55                   	push   %ebp
    a276:	89 e5                	mov    %esp,%ebp
    a278:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a27b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a282:	eb 20                	jmp    a2a4 <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a284:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a287:	c1 e0 0c             	shl    $0xc,%eax
    a28a:	89 c2                	mov    %eax,%edx
    a28c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a28f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a296:	8b 45 08             	mov    0x8(%ebp),%eax
    a299:	01 c8                	add    %ecx,%eax
    a29b:	83 ca 23             	or     $0x23,%edx
    a29e:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a2a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a2a4:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a2ab:	76 d7                	jbe    a284 <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    a2ad:	8b 45 08             	mov    0x8(%ebp),%eax
    a2b0:	83 c8 23             	or     $0x23,%eax
    a2b3:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    a2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
    a2b8:	89 14 85 00 10 01 00 	mov    %edx,0x11000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    a2bf:	e8 6c 11 00 00       	call   b430 <_FlushPagingCache_>
}
    a2c4:	90                   	nop
    a2c5:	c9                   	leave  
    a2c6:	c3                   	ret    

0000a2c7 <init_paging>:

void init_paging()
{
    a2c7:	55                   	push   %ebp
    a2c8:	89 e5                	mov    %esp,%ebp
    a2ca:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    a2cd:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a2d3:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    a2d9:	eb 1a                	jmp    a2f5 <init_paging+0x2e>
        page_directory[i] =
    a2db:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a2df:	c7 04 85 00 10 01 00 	movl   $0x2,0x11000(,%eax,4)
    a2e6:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a2ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a2ee:	83 c0 01             	add    $0x1,%eax
    a2f1:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a2f5:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a2fb:	76 de                	jbe    a2db <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a2fd:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    a303:	eb 22                	jmp    a327 <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a305:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a309:	c1 e0 0c             	shl    $0xc,%eax
    a30c:	83 c8 23             	or     $0x23,%eax
    a30f:	89 c2                	mov    %eax,%edx
    a311:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a315:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a31c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a320:	83 c0 01             	add    $0x1,%eax
    a323:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a327:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a32d:	76 d6                	jbe    a305 <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    a32f:	b8 00 c0 00 00       	mov    $0xc000,%eax
    a334:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    a337:	a3 00 10 01 00       	mov    %eax,0x11000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    a33c:	e8 f8 10 00 00       	call   b439 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    a341:	90                   	nop
    a342:	c9                   	leave  
    a343:	c3                   	ret    

0000a344 <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    a344:	55                   	push   %ebp
    a345:	89 e5                	mov    %esp,%ebp
    a347:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    a34a:	8b 45 08             	mov    0x8(%ebp),%eax
    a34d:	c1 e8 16             	shr    $0x16,%eax
    a350:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    a353:	8b 45 08             	mov    0x8(%ebp),%eax
    a356:	c1 e8 0c             	shr    $0xc,%eax
    a359:	25 ff 03 00 00       	and    $0x3ff,%eax
    a35e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a361:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a364:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a36b:	83 e0 23             	and    $0x23,%eax
    a36e:	83 f8 23             	cmp    $0x23,%eax
    a371:	75 56                	jne    a3c9 <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a373:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a376:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a37d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a382:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a385:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a388:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a38f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a392:	01 d0                	add    %edx,%eax
    a394:	8b 00                	mov    (%eax),%eax
    a396:	83 e0 23             	and    $0x23,%eax
    a399:	83 f8 23             	cmp    $0x23,%eax
    a39c:	75 24                	jne    a3c2 <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a39e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a3a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a3a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a3ab:	01 d0                	add    %edx,%eax
    a3ad:	8b 00                	mov    (%eax),%eax
    a3af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a3b4:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    a3b6:	8b 45 08             	mov    0x8(%ebp),%eax
    a3b9:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a3be:	09 d0                	or     %edx,%eax
    a3c0:	eb 0c                	jmp    a3ce <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    a3c2:	b8 f4 f0 00 00       	mov    $0xf0f4,%eax
    a3c7:	eb 05                	jmp    a3ce <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    a3c9:	b8 f4 f0 00 00       	mov    $0xf0f4,%eax
}
    a3ce:	c9                   	leave  
    a3cf:	c3                   	ret    

0000a3d0 <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    a3d0:	55                   	push   %ebp
    a3d1:	89 e5                	mov    %esp,%ebp
    a3d3:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    a3d6:	8b 45 08             	mov    0x8(%ebp),%eax
    a3d9:	c1 e8 16             	shr    $0x16,%eax
    a3dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    a3df:	8b 45 08             	mov    0x8(%ebp),%eax
    a3e2:	c1 e8 0c             	shr    $0xc,%eax
    a3e5:	25 ff 03 00 00       	and    $0x3ff,%eax
    a3ea:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a3ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a3f0:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a3f7:	83 e0 23             	and    $0x23,%eax
    a3fa:	83 f8 23             	cmp    $0x23,%eax
    a3fd:	75 4e                	jne    a44d <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a3ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a402:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a409:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a40e:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a411:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a41b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a41e:	01 d0                	add    %edx,%eax
    a420:	8b 00                	mov    (%eax),%eax
    a422:	83 e0 23             	and    $0x23,%eax
    a425:	83 f8 23             	cmp    $0x23,%eax
    a428:	74 26                	je     a450 <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a42a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a42d:	c1 e0 0c             	shl    $0xc,%eax
    a430:	89 c2                	mov    %eax,%edx
    a432:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a435:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a43c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a43f:	01 c8                	add    %ecx,%eax
    a441:	83 ca 23             	or     $0x23,%edx
    a444:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a446:	e8 e5 0f 00 00       	call   b430 <_FlushPagingCache_>
    a44b:	eb 04                	jmp    a451 <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a44d:	90                   	nop
    a44e:	eb 01                	jmp    a451 <map_linear_address+0x81>
            return; // the linear address was already mapped
    a450:	90                   	nop
}
    a451:	c9                   	leave  
    a452:	c3                   	ret    

0000a453 <Paging_fault>:

void Paging_fault()
{
    a453:	55                   	push   %ebp
    a454:	89 e5                	mov    %esp,%ebp
}
    a456:	90                   	nop
    a457:	5d                   	pop    %ebp
    a458:	c3                   	ret    

0000a459 <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a459:	55                   	push   %ebp
    a45a:	89 e5                	mov    %esp,%ebp
    a45c:	83 ec 04             	sub    $0x4,%esp
    a45f:	8b 45 08             	mov    0x8(%ebp),%eax
    a462:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a465:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a469:	76 0b                	jbe    a476 <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a46b:	ba a0 00 00 00       	mov    $0xa0,%edx
    a470:	b8 20 00 00 00       	mov    $0x20,%eax
    a475:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a476:	ba 20 00 00 00       	mov    $0x20,%edx
    a47b:	b8 20 00 00 00       	mov    $0x20,%eax
    a480:	ee                   	out    %al,(%dx)
}
    a481:	90                   	nop
    a482:	c9                   	leave  
    a483:	c3                   	ret    

0000a484 <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a484:	55                   	push   %ebp
    a485:	89 e5                	mov    %esp,%ebp
    a487:	83 ec 18             	sub    $0x18,%esp
    a48a:	8b 55 08             	mov    0x8(%ebp),%edx
    a48d:	8b 45 0c             	mov    0xc(%ebp),%eax
    a490:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a493:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a496:	b8 21 00 00 00       	mov    $0x21,%eax
    a49b:	89 c2                	mov    %eax,%edx
    a49d:	ec                   	in     (%dx),%al
    a49e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a4a2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a4a6:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2 = inb(PIC2_DATA);
    a4a9:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a4ae:	89 c2                	mov    %eax,%edx
    a4b0:	ec                   	in     (%dx),%al
    a4b1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a4b5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a4b9:	88 45 f9             	mov    %al,-0x7(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a4bc:	ba 20 00 00 00       	mov    $0x20,%edx
    a4c1:	b8 11 00 00 00       	mov    $0x11,%eax
    a4c6:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a4c7:	eb 00                	jmp    a4c9 <PIC_remap+0x45>
    a4c9:	eb 00                	jmp    a4cb <PIC_remap+0x47>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a4cb:	ba a0 00 00 00       	mov    $0xa0,%edx
    a4d0:	b8 11 00 00 00       	mov    $0x11,%eax
    a4d5:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a4d6:	eb 00                	jmp    a4d8 <PIC_remap+0x54>
    a4d8:	eb 00                	jmp    a4da <PIC_remap+0x56>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a4da:	ba 21 00 00 00       	mov    $0x21,%edx
    a4df:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a4e3:	ee                   	out    %al,(%dx)
    io_wait;
    a4e4:	eb 00                	jmp    a4e6 <PIC_remap+0x62>
    a4e6:	eb 00                	jmp    a4e8 <PIC_remap+0x64>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a4e8:	ba a1 00 00 00       	mov    $0xa1,%edx
    a4ed:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a4f1:	ee                   	out    %al,(%dx)
    io_wait;
    a4f2:	eb 00                	jmp    a4f4 <PIC_remap+0x70>
    a4f4:	eb 00                	jmp    a4f6 <PIC_remap+0x72>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a4f6:	ba 21 00 00 00       	mov    $0x21,%edx
    a4fb:	b8 04 00 00 00       	mov    $0x4,%eax
    a500:	ee                   	out    %al,(%dx)
    io_wait;
    a501:	eb 00                	jmp    a503 <PIC_remap+0x7f>
    a503:	eb 00                	jmp    a505 <PIC_remap+0x81>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a505:	ba a1 00 00 00       	mov    $0xa1,%edx
    a50a:	b8 02 00 00 00       	mov    $0x2,%eax
    a50f:	ee                   	out    %al,(%dx)
    io_wait;
    a510:	eb 00                	jmp    a512 <PIC_remap+0x8e>
    a512:	eb 00                	jmp    a514 <PIC_remap+0x90>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a514:	ba 21 00 00 00       	mov    $0x21,%edx
    a519:	b8 01 00 00 00       	mov    $0x1,%eax
    a51e:	ee                   	out    %al,(%dx)
    io_wait;
    a51f:	eb 00                	jmp    a521 <PIC_remap+0x9d>
    a521:	eb 00                	jmp    a523 <PIC_remap+0x9f>

    outb(PIC2_DATA, ICW4_8086);
    a523:	ba a1 00 00 00       	mov    $0xa1,%edx
    a528:	b8 01 00 00 00       	mov    $0x1,%eax
    a52d:	ee                   	out    %al,(%dx)
    io_wait;
    a52e:	eb 00                	jmp    a530 <PIC_remap+0xac>
    a530:	eb 00                	jmp    a532 <PIC_remap+0xae>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a532:	ba 21 00 00 00       	mov    $0x21,%edx
    a537:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a53b:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a53c:	ba a1 00 00 00       	mov    $0xa1,%edx
    a541:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a545:	ee                   	out    %al,(%dx)
}
    a546:	90                   	nop
    a547:	c9                   	leave  
    a548:	c3                   	ret    

0000a549 <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a549:	55                   	push   %ebp
    a54a:	89 e5                	mov    %esp,%ebp
    a54c:	53                   	push   %ebx
    a54d:	83 ec 14             	sub    $0x14,%esp
    a550:	8b 45 08             	mov    0x8(%ebp),%eax
    a553:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a556:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a55a:	77 08                	ja     a564 <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a55c:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a562:	eb 0a                	jmp    a56e <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a564:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a56a:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a56e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a572:	89 c2                	mov    %eax,%edx
    a574:	ec                   	in     (%dx),%al
    a575:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a579:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a57d:	89 c3                	mov    %eax,%ebx
    a57f:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a583:	ba 01 00 00 00       	mov    $0x1,%edx
    a588:	89 c1                	mov    %eax,%ecx
    a58a:	d3 e2                	shl    %cl,%edx
    a58c:	89 d0                	mov    %edx,%eax
    a58e:	09 d8                	or     %ebx,%eax
    a590:	88 45 f7             	mov    %al,-0x9(%ebp)

    outb(port, value);
    a593:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a597:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a59b:	ee                   	out    %al,(%dx)
}
    a59c:	90                   	nop
    a59d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a5a0:	c9                   	leave  
    a5a1:	c3                   	ret    

0000a5a2 <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a5a2:	55                   	push   %ebp
    a5a3:	89 e5                	mov    %esp,%ebp
    a5a5:	53                   	push   %ebx
    a5a6:	83 ec 14             	sub    $0x14,%esp
    a5a9:	8b 45 08             	mov    0x8(%ebp),%eax
    a5ac:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a5af:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a5b3:	77 09                	ja     a5be <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a5b5:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a5bc:	eb 0b                	jmp    a5c9 <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a5be:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a5c5:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a5c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a5cc:	89 c2                	mov    %eax,%edx
    a5ce:	ec                   	in     (%dx),%al
    a5cf:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a5d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a5d7:	89 c3                	mov    %eax,%ebx
    a5d9:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a5dd:	ba 01 00 00 00       	mov    $0x1,%edx
    a5e2:	89 c1                	mov    %eax,%ecx
    a5e4:	d3 e2                	shl    %cl,%edx
    a5e6:	89 d0                	mov    %edx,%eax
    a5e8:	f7 d0                	not    %eax
    a5ea:	21 d8                	and    %ebx,%eax
    a5ec:	88 45 f5             	mov    %al,-0xb(%ebp)

    outb(port, value);
    a5ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a5f2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a5f6:	ee                   	out    %al,(%dx)
}
    a5f7:	90                   	nop
    a5f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a5fb:	c9                   	leave  
    a5fc:	c3                   	ret    

0000a5fd <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a5fd:	55                   	push   %ebp
    a5fe:	89 e5                	mov    %esp,%ebp
    a600:	83 ec 14             	sub    $0x14,%esp
    a603:	8b 45 08             	mov    0x8(%ebp),%eax
    a606:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a609:	ba 20 00 00 00       	mov    $0x20,%edx
    a60e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a612:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a613:	ba a0 00 00 00       	mov    $0xa0,%edx
    a618:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a61c:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a61d:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a622:	89 c2                	mov    %eax,%edx
    a624:	ec                   	in     (%dx),%al
    a625:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a629:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a62d:	98                   	cwtl   
    a62e:	c1 e0 08             	shl    $0x8,%eax
    a631:	89 c1                	mov    %eax,%ecx
    a633:	b8 20 00 00 00       	mov    $0x20,%eax
    a638:	89 c2                	mov    %eax,%edx
    a63a:	ec                   	in     (%dx),%al
    a63b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a63f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a643:	09 c8                	or     %ecx,%eax
}
    a645:	c9                   	leave  
    a646:	c3                   	ret    

0000a647 <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a647:	55                   	push   %ebp
    a648:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a64a:	6a 0b                	push   $0xb
    a64c:	e8 ac ff ff ff       	call   a5fd <__pic_get_irq_reg>
    a651:	83 c4 04             	add    $0x4,%esp
}
    a654:	c9                   	leave  
    a655:	c3                   	ret    

0000a656 <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a656:	55                   	push   %ebp
    a657:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a659:	6a 0a                	push   $0xa
    a65b:	e8 9d ff ff ff       	call   a5fd <__pic_get_irq_reg>
    a660:	83 c4 04             	add    $0x4,%esp
}
    a663:	c9                   	leave  
    a664:	c3                   	ret    

0000a665 <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a665:	55                   	push   %ebp
    a666:	89 e5                	mov    %esp,%ebp
    a668:	83 ec 14             	sub    $0x14,%esp
    a66b:	8b 45 08             	mov    0x8(%ebp),%eax
    a66e:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a671:	e8 d1 ff ff ff       	call   a647 <pic_get_isr>
    a676:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a67a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a67e:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a682:	74 13                	je     a697 <spurious_IRQ+0x32>
    a684:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a688:	0f b6 c0             	movzbl %al,%eax
    a68b:	83 e0 07             	and    $0x7,%eax
    a68e:	50                   	push   %eax
    a68f:	e8 c5 fd ff ff       	call   a459 <PIC_sendEOI>
    a694:	83 c4 04             	add    $0x4,%esp
    a697:	90                   	nop
    a698:	c9                   	leave  
    a699:	c3                   	ret    

0000a69a <conserv_status_byte>:
uint32_t compteur   = 0;
uint8_t  frequency  = 0;
uint8_t  status_PIT = 0;

void conserv_status_byte()
{
    a69a:	55                   	push   %ebp
    a69b:	89 e5                	mov    %esp,%ebp
    a69d:	83 ec 10             	sub    $0x10,%esp
    set_pit_count(PIT_0, PIT_reload_value);
    a6a0:	ba 43 00 00 00       	mov    $0x43,%edx
    a6a5:	b8 40 00 00 00       	mov    $0x40,%eax
    a6aa:	ee                   	out    %al,(%dx)
    a6ab:	b8 40 00 00 00       	mov    $0x40,%eax
    a6b0:	89 c2                	mov    %eax,%edx
    a6b2:	ec                   	in     (%dx),%al
    a6b3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a6b7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a6bb:	88 45 f6             	mov    %al,-0xa(%ebp)
    a6be:	b8 40 00 00 00       	mov    $0x40,%eax
    a6c3:	89 c2                	mov    %eax,%edx
    a6c5:	ec                   	in     (%dx),%al
    a6c6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a6ca:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a6ce:	88 45 f7             	mov    %al,-0x9(%ebp)
    a6d1:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a6d5:	66 98                	cbtw   
    a6d7:	ba 40 00 00 00       	mov    $0x40,%edx
    a6dc:	ee                   	out    %al,(%dx)
    a6dd:	a1 74 32 02 00       	mov    0x23274,%eax
    a6e2:	c1 f8 08             	sar    $0x8,%eax
    a6e5:	ba 40 00 00 00       	mov    $0x40,%edx
    a6ea:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a6eb:	ba 43 00 00 00       	mov    $0x43,%edx
    a6f0:	b8 40 00 00 00       	mov    $0x40,%eax
    a6f5:	ee                   	out    %al,(%dx)
    a6f6:	b8 40 00 00 00       	mov    $0x40,%eax
    a6fb:	89 c2                	mov    %eax,%edx
    a6fd:	ec                   	in     (%dx),%al
    a6fe:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a702:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a706:	88 45 f4             	mov    %al,-0xc(%ebp)
    a709:	b8 40 00 00 00       	mov    $0x40,%eax
    a70e:	89 c2                	mov    %eax,%edx
    a710:	ec                   	in     (%dx),%al
    a711:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a715:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a719:	88 45 f5             	mov    %al,-0xb(%ebp)
    a71c:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a720:	66 98                	cbtw   
    a722:	ba 43 00 00 00       	mov    $0x43,%edx
    a727:	ee                   	out    %al,(%dx)
    a728:	ba 43 00 00 00       	mov    $0x43,%edx
    a72d:	b8 34 00 00 00       	mov    $0x34,%eax
    a732:	ee                   	out    %al,(%dx)
}
    a733:	90                   	nop
    a734:	c9                   	leave  
    a735:	c3                   	ret    

0000a736 <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a736:	55                   	push   %ebp
    a737:	89 e5                	mov    %esp,%ebp
    a739:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a73c:	0f b6 05 40 31 02 00 	movzbl 0x23140,%eax
    a743:	3c 01                	cmp    $0x1,%al
    a745:	75 27                	jne    a76e <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a747:	a1 44 31 02 00       	mov    0x23144,%eax
    a74c:	85 c0                	test   %eax,%eax
    a74e:	75 11                	jne    a761 <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a750:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    a757:	01 00 00 
            __switch();
    a75a:	e8 e5 0a 00 00       	call   b244 <__switch>
        } else
            sheduler.task_timer--;
    }
}
    a75f:	eb 0d                	jmp    a76e <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a761:	a1 44 31 02 00       	mov    0x23144,%eax
    a766:	83 e8 01             	sub    $0x1,%eax
    a769:	a3 44 31 02 00       	mov    %eax,0x23144
}
    a76e:	90                   	nop
    a76f:	c9                   	leave  
    a770:	c3                   	ret    

0000a771 <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a771:	55                   	push   %ebp
    a772:	89 e5                	mov    %esp,%ebp
    a774:	83 ec 28             	sub    $0x28,%esp
    a777:	8b 45 08             	mov    0x8(%ebp),%eax
    a77a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a77e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a782:	a2 04 20 01 00       	mov    %al,0x12004
    calculate_frequency();
    a787:	e8 10 0d 00 00       	call   b49c <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a78c:	ba 43 00 00 00       	mov    $0x43,%edx
    a791:	b8 40 00 00 00       	mov    $0x40,%eax
    a796:	ee                   	out    %al,(%dx)
    a797:	b8 40 00 00 00       	mov    $0x40,%eax
    a79c:	89 c2                	mov    %eax,%edx
    a79e:	ec                   	in     (%dx),%al
    a79f:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a7a3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a7a7:	88 45 ee             	mov    %al,-0x12(%ebp)
    a7aa:	b8 40 00 00 00       	mov    $0x40,%eax
    a7af:	89 c2                	mov    %eax,%edx
    a7b1:	ec                   	in     (%dx),%al
    a7b2:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    a7b6:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
    a7ba:	88 45 ef             	mov    %al,-0x11(%ebp)
    a7bd:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    a7c1:	66 98                	cbtw   
    a7c3:	ba 43 00 00 00       	mov    $0x43,%edx
    a7c8:	ee                   	out    %al,(%dx)
    a7c9:	ba 43 00 00 00       	mov    $0x43,%edx
    a7ce:	b8 34 00 00 00       	mov    $0x34,%eax
    a7d3:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a7d4:	ba 43 00 00 00       	mov    $0x43,%edx
    a7d9:	b8 40 00 00 00       	mov    $0x40,%eax
    a7de:	ee                   	out    %al,(%dx)
    a7df:	b8 40 00 00 00       	mov    $0x40,%eax
    a7e4:	89 c2                	mov    %eax,%edx
    a7e6:	ec                   	in     (%dx),%al
    a7e7:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a7eb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a7ef:	88 45 ec             	mov    %al,-0x14(%ebp)
    a7f2:	b8 40 00 00 00       	mov    $0x40,%eax
    a7f7:	89 c2                	mov    %eax,%edx
    a7f9:	ec                   	in     (%dx),%al
    a7fa:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a7fe:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a802:	88 45 ed             	mov    %al,-0x13(%ebp)
    a805:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a809:	66 98                	cbtw   
    a80b:	ba 40 00 00 00       	mov    $0x40,%edx
    a810:	ee                   	out    %al,(%dx)
    a811:	a1 74 32 02 00       	mov    0x23274,%eax
    a816:	c1 f8 08             	sar    $0x8,%eax
    a819:	ba 40 00 00 00       	mov    $0x40,%edx
    a81e:	ee                   	out    %al,(%dx)
}
    a81f:	90                   	nop
    a820:	c9                   	leave  
    a821:	c3                   	ret    

0000a822 <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a822:	55                   	push   %ebp
    a823:	89 e5                	mov    %esp,%ebp
    a825:	83 ec 14             	sub    $0x14,%esp
    a828:	8b 45 08             	mov    0x8(%ebp),%eax
    a82b:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a82e:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a832:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a836:	83 f8 42             	cmp    $0x42,%eax
    a839:	74 1d                	je     a858 <read_back_channel+0x36>
    a83b:	83 f8 42             	cmp    $0x42,%eax
    a83e:	7f 1e                	jg     a85e <read_back_channel+0x3c>
    a840:	83 f8 40             	cmp    $0x40,%eax
    a843:	74 07                	je     a84c <read_back_channel+0x2a>
    a845:	83 f8 41             	cmp    $0x41,%eax
    a848:	74 08                	je     a852 <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a84a:	eb 12                	jmp    a85e <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a84c:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a850:	eb 0d                	jmp    a85f <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a852:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a856:	eb 07                	jmp    a85f <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a858:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a85c:	eb 01                	jmp    a85f <read_back_channel+0x3d>
        break;
    a85e:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a85f:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a863:	ba 43 00 00 00       	mov    $0x43,%edx
    a868:	b8 40 00 00 00       	mov    $0x40,%eax
    a86d:	ee                   	out    %al,(%dx)
    a86e:	b8 40 00 00 00       	mov    $0x40,%eax
    a873:	89 c2                	mov    %eax,%edx
    a875:	ec                   	in     (%dx),%al
    a876:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a87a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a87e:	88 45 f4             	mov    %al,-0xc(%ebp)
    a881:	b8 40 00 00 00       	mov    $0x40,%eax
    a886:	89 c2                	mov    %eax,%edx
    a888:	ec                   	in     (%dx),%al
    a889:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a88d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a891:	88 45 f5             	mov    %al,-0xb(%ebp)
    a894:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a898:	66 98                	cbtw   
    a89a:	ba 43 00 00 00       	mov    $0x43,%edx
    a89f:	ee                   	out    %al,(%dx)
    a8a0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a8a4:	c1 f8 08             	sar    $0x8,%eax
    a8a7:	ba 43 00 00 00       	mov    $0x43,%edx
    a8ac:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a8ad:	ba 43 00 00 00       	mov    $0x43,%edx
    a8b2:	b8 40 00 00 00       	mov    $0x40,%eax
    a8b7:	ee                   	out    %al,(%dx)
    a8b8:	b8 40 00 00 00       	mov    $0x40,%eax
    a8bd:	89 c2                	mov    %eax,%edx
    a8bf:	ec                   	in     (%dx),%al
    a8c0:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a8c4:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a8c8:	88 45 f2             	mov    %al,-0xe(%ebp)
    a8cb:	b8 40 00 00 00       	mov    $0x40,%eax
    a8d0:	89 c2                	mov    %eax,%edx
    a8d2:	ec                   	in     (%dx),%al
    a8d3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a8d7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a8db:	88 45 f3             	mov    %al,-0xd(%ebp)
    a8de:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a8e2:	66 98                	cbtw   
    a8e4:	c9                   	leave  
    a8e5:	c3                   	ret    

0000a8e6 <read_ebp>:
        registers;                                                     \
    })

static inline uint32_t
read_ebp(void)
{
    a8e6:	55                   	push   %ebp
    a8e7:	89 e5                	mov    %esp,%ebp
    a8e9:	83 ec 10             	sub    $0x10,%esp
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
    a8ec:	89 e8                	mov    %ebp,%eax
    a8ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(ebp));
    return ebp;
    a8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a8f4:	c9                   	leave  
    a8f5:	c3                   	ret    

0000a8f6 <backtrace>:
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    a8f6:	55                   	push   %ebp
    a8f7:	89 e5                	mov    %esp,%ebp
    a8f9:	83 ec 18             	sub    $0x18,%esp
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;
    a8fc:	e8 e5 ff ff ff       	call   a8e6 <read_ebp>
    a901:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a904:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a907:	83 c0 04             	add    $0x4,%eax
    a90a:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp != 0) {
    a90d:	eb 30                	jmp    a93f <backtrace+0x49>
        kprintf("ebp %x eip %x\n", ebp, *eip);
    a90f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a912:	8b 00                	mov    (%eax),%eax
    a914:	83 ec 04             	sub    $0x4,%esp
    a917:	50                   	push   %eax
    a918:	ff 75 f4             	pushl  -0xc(%ebp)
    a91b:	68 47 f1 00 00       	push   $0xf147
    a920:	e8 0c 01 00 00       	call   aa31 <kprintf>
    a925:	83 c4 10             	add    $0x10,%esp

        ptr = (int*)(ebp);
    a928:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a92b:	89 45 ec             	mov    %eax,-0x14(%ebp)

        ebp = (int)(*ptr);
    a92e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a931:	8b 00                	mov    (%eax),%eax
    a933:	89 45 f4             	mov    %eax,-0xc(%ebp)

        eip = (int*)(ebp + 4);
    a936:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a939:	83 c0 04             	add    $0x4,%eax
    a93c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (ebp != 0) {
    a93f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    a943:	75 ca                	jne    a90f <backtrace+0x19>
    }
    return 0;
    a945:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a94a:	c9                   	leave  
    a94b:	c3                   	ret    

0000a94c <mon_help>:

int mon_help(int argc, char** argv)
{
    a94c:	55                   	push   %ebp
    a94d:	89 e5                	mov    %esp,%ebp
    a94f:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 2; i++)
    a952:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a959:	eb 3c                	jmp    a997 <mon_help+0x4b>
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    a95b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a95e:	89 d0                	mov    %edx,%eax
    a960:	01 c0                	add    %eax,%eax
    a962:	01 d0                	add    %edx,%eax
    a964:	c1 e0 02             	shl    $0x2,%eax
    a967:	05 48 b7 00 00       	add    $0xb748,%eax
    a96c:	8b 10                	mov    (%eax),%edx
    a96e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    a971:	89 c8                	mov    %ecx,%eax
    a973:	01 c0                	add    %eax,%eax
    a975:	01 c8                	add    %ecx,%eax
    a977:	c1 e0 02             	shl    $0x2,%eax
    a97a:	05 44 b7 00 00       	add    $0xb744,%eax
    a97f:	8b 00                	mov    (%eax),%eax
    a981:	83 ec 04             	sub    $0x4,%esp
    a984:	52                   	push   %edx
    a985:	50                   	push   %eax
    a986:	68 56 f1 00 00       	push   $0xf156
    a98b:	e8 a1 00 00 00       	call   aa31 <kprintf>
    a990:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 2; i++)
    a993:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a997:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    a99b:	7e be                	jle    a95b <mon_help+0xf>
    return 0;
    a99d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a9a2:	c9                   	leave  
    a9a3:	c3                   	ret    

0000a9a4 <monitor_service_keyboard>:

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    a9a4:	55                   	push   %ebp
    a9a5:	89 e5                	mov    %esp,%ebp
    a9a7:	83 ec 18             	sub    $0x18,%esp
    if (get_ASCII_code_keyboard() != '\0') {
    a9aa:	e8 b5 f8 ff ff       	call   a264 <get_ASCII_code_keyboard>
    a9af:	84 c0                	test   %al,%al
    a9b1:	74 7b                	je     aa2e <monitor_service_keyboard+0x8a>
        int8_t code = get_ASCII_code_keyboard();
    a9b3:	e8 ac f8 ff ff       	call   a264 <get_ASCII_code_keyboard>
    a9b8:	88 45 f3             	mov    %al,-0xd(%ebp)
        if (code != '\n') {
    a9bb:	80 7d f3 0a          	cmpb   $0xa,-0xd(%ebp)
    a9bf:	74 25                	je     a9e6 <monitor_service_keyboard+0x42>
            keyboard_code_monitor[keyboard_num] = code;
    a9c1:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a9c8:	0f be c0             	movsbl %al,%eax
    a9cb:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
    a9cf:	88 90 20 20 01 00    	mov    %dl,0x12020(%eax)
            keyboard_num++;
    a9d5:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a9dc:	83 c0 01             	add    $0x1,%eax
    a9df:	a2 1f 21 01 00       	mov    %al,0x1211f
            }

            keyboard_num = 0;
        }
    }
    a9e4:	eb 48                	jmp    aa2e <monitor_service_keyboard+0x8a>
            for (i = 0; i < keyboard_num; i++) {
    a9e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a9ed:	eb 29                	jmp    aa18 <monitor_service_keyboard+0x74>
                putchar(keyboard_code_monitor[i]);
    a9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9f2:	05 20 20 01 00       	add    $0x12020,%eax
    a9f7:	0f b6 00             	movzbl (%eax),%eax
    a9fa:	0f b6 c0             	movzbl %al,%eax
    a9fd:	83 ec 0c             	sub    $0xc,%esp
    aa00:	50                   	push   %eax
    aa01:	e8 fb e6 ff ff       	call   9101 <putchar>
    aa06:	83 c4 10             	add    $0x10,%esp
                keyboard_code_monitor[i] = 0;
    aa09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa0c:	05 20 20 01 00       	add    $0x12020,%eax
    aa11:	c6 00 00             	movb   $0x0,(%eax)
            for (i = 0; i < keyboard_num; i++) {
    aa14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    aa18:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    aa1f:	0f be c0             	movsbl %al,%eax
    aa22:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    aa25:	7c c8                	jl     a9ef <monitor_service_keyboard+0x4b>
            keyboard_num = 0;
    aa27:	c6 05 1f 21 01 00 00 	movb   $0x0,0x1211f
    aa2e:	90                   	nop
    aa2f:	c9                   	leave  
    aa30:	c3                   	ret    

0000aa31 <kprintf>:
#include <stdint.h>

extern void printf(const char* fmt, va_list arg);

void kprintf(const char* frmt, ...)
{
    aa31:	55                   	push   %ebp
    aa32:	89 e5                	mov    %esp,%ebp
    aa34:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    aa37:	8d 45 0c             	lea    0xc(%ebp),%eax
    aa3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    aa3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa40:	83 ec 08             	sub    $0x8,%esp
    aa43:	50                   	push   %eax
    aa44:	ff 75 08             	pushl  0x8(%ebp)
    aa47:	e8 3a e7 ff ff       	call   9186 <printf>
    aa4c:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    aa4f:	90                   	nop
    aa50:	c9                   	leave  
    aa51:	c3                   	ret    

0000aa52 <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    aa52:	55                   	push   %ebp
    aa53:	89 e5                	mov    %esp,%ebp
    aa55:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    aa58:	b8 1b 00 00 00       	mov    $0x1b,%eax
    aa5d:	89 c1                	mov    %eax,%ecx
    aa5f:	0f 32                	rdmsr  
    aa61:	89 45 f8             	mov    %eax,-0x8(%ebp)
    aa64:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    aa67:	8b 45 fc             	mov    -0x4(%ebp),%eax
    aa6a:	c1 e0 05             	shl    $0x5,%eax
    aa6d:	89 c2                	mov    %eax,%edx
    aa6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aa72:	01 d0                	add    %edx,%eax
}
    aa74:	c9                   	leave  
    aa75:	c3                   	ret    

0000aa76 <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    aa76:	55                   	push   %ebp
    aa77:	89 e5                	mov    %esp,%ebp
    aa79:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    aa7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    aa83:	8b 45 08             	mov    0x8(%ebp),%eax
    aa86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    aa8b:	80 cc 08             	or     $0x8,%ah
    aa8e:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    aa91:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aa94:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa97:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    aa9c:	0f 30                	wrmsr  
}
    aa9e:	90                   	nop
    aa9f:	c9                   	leave  
    aaa0:	c3                   	ret    

0000aaa1 <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    aaa1:	55                   	push   %ebp
    aaa2:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    aaa4:	8b 15 20 21 01 00    	mov    0x12120,%edx
    aaaa:	8b 45 08             	mov    0x8(%ebp),%eax
    aaad:	01 c0                	add    %eax,%eax
    aaaf:	01 d0                	add    %edx,%eax
    aab1:	0f b7 00             	movzwl (%eax),%eax
    aab4:	0f b7 c0             	movzwl %ax,%eax
}
    aab7:	5d                   	pop    %ebp
    aab8:	c3                   	ret    

0000aab9 <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    aab9:	55                   	push   %ebp
    aaba:	89 e5                	mov    %esp,%ebp
    aabc:	83 ec 04             	sub    $0x4,%esp
    aabf:	8b 45 0c             	mov    0xc(%ebp),%eax
    aac2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    aac6:	8b 15 20 21 01 00    	mov    0x12120,%edx
    aacc:	8b 45 08             	mov    0x8(%ebp),%eax
    aacf:	01 c0                	add    %eax,%eax
    aad1:	01 c2                	add    %eax,%edx
    aad3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    aad7:	66 89 02             	mov    %ax,(%edx)
}
    aada:	90                   	nop
    aadb:	c9                   	leave  
    aadc:	c3                   	ret    

0000aadd <enable_local_apic>:

void enable_local_apic()
{
    aadd:	55                   	push   %ebp
    aade:	89 e5                	mov    %esp,%ebp
    aae0:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    aae3:	83 ec 08             	sub    $0x8,%esp
    aae6:	68 fb 03 00 00       	push   $0x3fb
    aaeb:	68 00 d0 00 00       	push   $0xd000
    aaf0:	e8 80 f7 ff ff       	call   a275 <create_page_table>
    aaf5:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    aaf8:	e8 55 ff ff ff       	call   aa52 <get_apic_base>
    aafd:	a3 20 21 01 00       	mov    %eax,0x12120

    set_apic_base(get_apic_base());
    ab02:	e8 4b ff ff ff       	call   aa52 <get_apic_base>
    ab07:	83 ec 0c             	sub    $0xc,%esp
    ab0a:	50                   	push   %eax
    ab0b:	e8 66 ff ff ff       	call   aa76 <set_apic_base>
    ab10:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    ab13:	83 ec 0c             	sub    $0xc,%esp
    ab16:	68 f0 00 00 00       	push   $0xf0
    ab1b:	e8 81 ff ff ff       	call   aaa1 <cpu_ReadLocalAPICReg>
    ab20:	83 c4 10             	add    $0x10,%esp
    ab23:	80 cc 01             	or     $0x1,%ah
    ab26:	0f b7 c0             	movzwl %ax,%eax
    ab29:	83 ec 08             	sub    $0x8,%esp
    ab2c:	50                   	push   %eax
    ab2d:	68 f0 00 00 00       	push   $0xf0
    ab32:	e8 82 ff ff ff       	call   aab9 <cpu_SetLocalAPICReg>
    ab37:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    ab3a:	83 ec 08             	sub    $0x8,%esp
    ab3d:	6a 02                	push   $0x2
    ab3f:	6a 20                	push   $0x20
    ab41:	e8 73 ff ff ff       	call   aab9 <cpu_SetLocalAPICReg>
    ab46:	83 c4 10             	add    $0x10,%esp
}
    ab49:	90                   	nop
    ab4a:	c9                   	leave  
    ab4b:	c3                   	ret    

0000ab4c <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    ab4c:	55                   	push   %ebp
    ab4d:	89 e5                	mov    %esp,%ebp
    ab4f:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    ab52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    ab59:	eb 49                	jmp    aba4 <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    ab5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
    ab5e:	89 d0                	mov    %edx,%eax
    ab60:	01 c0                	add    %eax,%eax
    ab62:	01 d0                	add    %edx,%eax
    ab64:	c1 e0 02             	shl    $0x2,%eax
    ab67:	05 40 21 01 00       	add    $0x12140,%eax
    ab6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    ab72:	8b 55 fc             	mov    -0x4(%ebp),%edx
    ab75:	89 d0                	mov    %edx,%eax
    ab77:	01 c0                	add    %eax,%eax
    ab79:	01 d0                	add    %edx,%eax
    ab7b:	c1 e0 02             	shl    $0x2,%eax
    ab7e:	05 48 21 01 00       	add    $0x12148,%eax
    ab83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    ab89:	8b 55 fc             	mov    -0x4(%ebp),%edx
    ab8c:	89 d0                	mov    %edx,%eax
    ab8e:	01 c0                	add    %eax,%eax
    ab90:	01 d0                	add    %edx,%eax
    ab92:	c1 e0 02             	shl    $0x2,%eax
    ab95:	05 44 21 01 00       	add    $0x12144,%eax
    ab9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    aba0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    aba4:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    abab:	7e ae                	jle    ab5b <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    abad:	c7 05 40 e1 01 00 40 	movl   $0x12140,0x1e140
    abb4:	21 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    abb7:	90                   	nop
    abb8:	c9                   	leave  
    abb9:	c3                   	ret    

0000abba <kmalloc>:

void* kmalloc(uint32_t size)
{
    abba:	55                   	push   %ebp
    abbb:	89 e5                	mov    %esp,%ebp
    abbd:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    abc0:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abc5:	8b 00                	mov    (%eax),%eax
    abc7:	85 c0                	test   %eax,%eax
    abc9:	75 37                	jne    ac02 <kmalloc+0x48>
        _head_vmm_->address = KERNEL__VM_BASE;
    abcb:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abd0:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    abd5:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    abd7:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abdc:	8b 55 08             	mov    0x8(%ebp),%edx
    abdf:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    abe2:	8b 45 08             	mov    0x8(%ebp),%eax
    abe5:	83 ec 04             	sub    $0x4,%esp
    abe8:	50                   	push   %eax
    abe9:	6a 00                	push   $0x0
    abeb:	68 60 e1 01 00       	push   $0x1e160
    abf0:	e8 7f e8 ff ff       	call   9474 <memset>
    abf5:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    abf8:	b8 60 e1 01 00       	mov    $0x1e160,%eax
    abfd:	e9 7e 01 00 00       	jmp    ad80 <kmalloc+0x1c6>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    ac02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ac09:	eb 04                	jmp    ac0f <kmalloc+0x55>
        i++;
    ac0b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ac0f:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    ac16:	77 17                	ja     ac2f <kmalloc+0x75>
    ac18:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ac1b:	89 d0                	mov    %edx,%eax
    ac1d:	01 c0                	add    %eax,%eax
    ac1f:	01 d0                	add    %edx,%eax
    ac21:	c1 e0 02             	shl    $0x2,%eax
    ac24:	05 40 21 01 00       	add    $0x12140,%eax
    ac29:	8b 00                	mov    (%eax),%eax
    ac2b:	85 c0                	test   %eax,%eax
    ac2d:	75 dc                	jne    ac0b <kmalloc+0x51>

    _new_item_ = &MM_BLOCK[i];
    ac2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ac32:	89 d0                	mov    %edx,%eax
    ac34:	01 c0                	add    %eax,%eax
    ac36:	01 d0                	add    %edx,%eax
    ac38:	c1 e0 02             	shl    $0x2,%eax
    ac3b:	05 40 21 01 00       	add    $0x12140,%eax
    ac40:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    ac43:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ac48:	8b 00                	mov    (%eax),%eax
    ac4a:	b9 60 e1 01 00       	mov    $0x1e160,%ecx
    ac4f:	8b 55 08             	mov    0x8(%ebp),%edx
    ac52:	01 ca                	add    %ecx,%edx
    ac54:	39 d0                	cmp    %edx,%eax
    ac56:	74 48                	je     aca0 <kmalloc+0xe6>
        _new_item_->address = KERNEL__VM_BASE;
    ac58:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ac5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac60:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    ac62:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac65:	8b 55 08             	mov    0x8(%ebp),%edx
    ac68:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    ac6b:	8b 15 40 e1 01 00    	mov    0x1e140,%edx
    ac71:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac74:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    ac77:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac7a:	a3 40 e1 01 00       	mov    %eax,0x1e140

        memset((void*)_new_item_->address, 0, size);
    ac7f:	8b 45 08             	mov    0x8(%ebp),%eax
    ac82:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac85:	8b 12                	mov    (%edx),%edx
    ac87:	83 ec 04             	sub    $0x4,%esp
    ac8a:	50                   	push   %eax
    ac8b:	6a 00                	push   $0x0
    ac8d:	52                   	push   %edx
    ac8e:	e8 e1 e7 ff ff       	call   9474 <memset>
    ac93:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac96:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac99:	8b 00                	mov    (%eax),%eax
    ac9b:	e9 e0 00 00 00       	jmp    ad80 <kmalloc+0x1c6>
    }

    tmp = _head_vmm_;
    aca0:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aca5:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    aca8:	eb 27                	jmp    acd1 <kmalloc+0x117>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    acaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acad:	8b 40 08             	mov    0x8(%eax),%eax
    acb0:	8b 10                	mov    (%eax),%edx
    acb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acb5:	8b 08                	mov    (%eax),%ecx
    acb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acba:	8b 40 04             	mov    0x4(%eax),%eax
    acbd:	01 c1                	add    %eax,%ecx
    acbf:	8b 45 08             	mov    0x8(%ebp),%eax
    acc2:	01 c8                	add    %ecx,%eax
    acc4:	39 c2                	cmp    %eax,%edx
    acc6:	73 15                	jae    acdd <kmalloc+0x123>
            break;

        tmp = tmp->next;
    acc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    accb:	8b 40 08             	mov    0x8(%eax),%eax
    acce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    acd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acd4:	8b 40 08             	mov    0x8(%eax),%eax
    acd7:	85 c0                	test   %eax,%eax
    acd9:	75 cf                	jne    acaa <kmalloc+0xf0>
    acdb:	eb 01                	jmp    acde <kmalloc+0x124>
            break;
    acdd:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    acde:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ace1:	8b 40 08             	mov    0x8(%eax),%eax
    ace4:	85 c0                	test   %eax,%eax
    ace6:	75 4c                	jne    ad34 <kmalloc+0x17a>
        _new_item_->size = size;
    ace8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aceb:	8b 55 08             	mov    0x8(%ebp),%edx
    acee:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    acf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acf4:	8b 10                	mov    (%eax),%edx
    acf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acf9:	8b 40 04             	mov    0x4(%eax),%eax
    acfc:	01 c2                	add    %eax,%edx
    acfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad01:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    ad03:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    ad0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad10:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad13:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ad16:	8b 45 08             	mov    0x8(%ebp),%eax
    ad19:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad1c:	8b 12                	mov    (%edx),%edx
    ad1e:	83 ec 04             	sub    $0x4,%esp
    ad21:	50                   	push   %eax
    ad22:	6a 00                	push   $0x0
    ad24:	52                   	push   %edx
    ad25:	e8 4a e7 ff ff       	call   9474 <memset>
    ad2a:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ad2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad30:	8b 00                	mov    (%eax),%eax
    ad32:	eb 4c                	jmp    ad80 <kmalloc+0x1c6>
    }

    else {
        _new_item_->size = size;
    ad34:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad37:	8b 55 08             	mov    0x8(%ebp),%edx
    ad3a:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ad3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad40:	8b 10                	mov    (%eax),%edx
    ad42:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad45:	8b 40 04             	mov    0x4(%eax),%eax
    ad48:	01 c2                	add    %eax,%edx
    ad4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad4d:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    ad4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad52:	8b 50 08             	mov    0x8(%eax),%edx
    ad55:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad58:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    ad5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad61:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ad64:	8b 45 08             	mov    0x8(%ebp),%eax
    ad67:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad6a:	8b 12                	mov    (%edx),%edx
    ad6c:	83 ec 04             	sub    $0x4,%esp
    ad6f:	50                   	push   %eax
    ad70:	6a 00                	push   $0x0
    ad72:	52                   	push   %edx
    ad73:	e8 fc e6 ff ff       	call   9474 <memset>
    ad78:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ad7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad7e:	8b 00                	mov    (%eax),%eax
    }
}
    ad80:	c9                   	leave  
    ad81:	c3                   	ret    

0000ad82 <free>:

void free(virtaddr_t _addr__)
{
    ad82:	55                   	push   %ebp
    ad83:	89 e5                	mov    %esp,%ebp
    ad85:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    ad88:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ad8d:	8b 00                	mov    (%eax),%eax
    ad8f:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad92:	75 29                	jne    adbd <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    ad94:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ad99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    ad9f:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ada4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    adab:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adb0:	8b 40 08             	mov    0x8(%eax),%eax
    adb3:	a3 40 e1 01 00       	mov    %eax,0x1e140
        return;
    adb8:	e9 ac 00 00 00       	jmp    ae69 <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    adbd:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adc2:	8b 40 08             	mov    0x8(%eax),%eax
    adc5:	85 c0                	test   %eax,%eax
    adc7:	75 16                	jne    addf <free+0x5d>
    adc9:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adce:	8b 00                	mov    (%eax),%eax
    add0:	39 45 08             	cmp    %eax,0x8(%ebp)
    add3:	75 0a                	jne    addf <free+0x5d>
        init_vmm();
    add5:	e8 72 fd ff ff       	call   ab4c <init_vmm>
        return;
    adda:	e9 8a 00 00 00       	jmp    ae69 <free+0xe7>
    }

    tmp = _head_vmm_;
    addf:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ade4:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ade7:	eb 0f                	jmp    adf8 <free+0x76>
        tmp_prev = tmp;
    ade9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    adec:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    adef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    adf2:	8b 40 08             	mov    0x8(%eax),%eax
    adf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    adf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    adfb:	8b 40 08             	mov    0x8(%eax),%eax
    adfe:	85 c0                	test   %eax,%eax
    ae00:	74 0a                	je     ae0c <free+0x8a>
    ae02:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae05:	8b 00                	mov    (%eax),%eax
    ae07:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae0a:	75 dd                	jne    ade9 <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ae0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae0f:	8b 40 08             	mov    0x8(%eax),%eax
    ae12:	85 c0                	test   %eax,%eax
    ae14:	75 29                	jne    ae3f <free+0xbd>
    ae16:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae19:	8b 00                	mov    (%eax),%eax
    ae1b:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae1e:	75 1f                	jne    ae3f <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ae20:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ae29:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ae33:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ae36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ae3d:	eb 2a                	jmp    ae69 <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ae3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae42:	8b 00                	mov    (%eax),%eax
    ae44:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae47:	75 20                	jne    ae69 <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ae49:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ae52:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ae5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae5f:	8b 50 08             	mov    0x8(%eax),%edx
    ae62:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ae65:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ae68:	90                   	nop
    }
    ae69:	c9                   	leave  
    ae6a:	c3                   	ret    

0000ae6b <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ae6b:	55                   	push   %ebp
    ae6c:	89 e5                	mov    %esp,%ebp
    ae6e:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ae71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    ae78:	eb 49                	jmp    aec3 <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ae7a:	ba 5f f1 00 00       	mov    $0xf15f,%edx
    ae7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae82:	c1 e0 04             	shl    $0x4,%eax
    ae85:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae8a:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    ae8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae8f:	c1 e0 04             	shl    $0x4,%eax
    ae92:	05 44 f1 01 00       	add    $0x1f144,%eax
    ae97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    ae9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aea0:	c1 e0 04             	shl    $0x4,%eax
    aea3:	05 4c f1 01 00       	add    $0x1f14c,%eax
    aea8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    aeae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aeb1:	c1 e0 04             	shl    $0x4,%eax
    aeb4:	05 48 f1 01 00       	add    $0x1f148,%eax
    aeb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    aebf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    aec3:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    aeca:	76 ae                	jbe    ae7a <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    aecc:	83 ec 08             	sub    $0x8,%esp
    aecf:	6a 01                	push   $0x1
    aed1:	68 00 e0 00 00       	push   $0xe000
    aed6:	e8 9a f3 ff ff       	call   a275 <create_page_table>
    aedb:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    aede:	c7 05 20 f1 01 00 40 	movl   $0x1f140,0x1f120
    aee5:	f1 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    aee8:	90                   	nop
    aee9:	c9                   	leave  
    aeea:	c3                   	ret    

0000aeeb <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    aeeb:	55                   	push   %ebp
    aeec:	89 e5                	mov    %esp,%ebp
    aeee:	53                   	push   %ebx
    aeef:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    aef2:	a1 20 f1 01 00       	mov    0x1f120,%eax
    aef7:	8b 00                	mov    (%eax),%eax
    aef9:	ba 5f f1 00 00       	mov    $0xf15f,%edx
    aefe:	39 d0                	cmp    %edx,%eax
    af00:	75 40                	jne    af42 <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    af02:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af07:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    af0d:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af12:	8b 55 08             	mov    0x8(%ebp),%edx
    af15:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    af18:	8b 45 08             	mov    0x8(%ebp),%eax
    af1b:	c1 e0 0c             	shl    $0xc,%eax
    af1e:	89 c2                	mov    %eax,%edx
    af20:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af25:	8b 00                	mov    (%eax),%eax
    af27:	83 ec 04             	sub    $0x4,%esp
    af2a:	52                   	push   %edx
    af2b:	6a 00                	push   $0x0
    af2d:	50                   	push   %eax
    af2e:	e8 41 e5 ff ff       	call   9474 <memset>
    af33:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    af36:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af3b:	8b 00                	mov    (%eax),%eax
    af3d:	e9 ae 01 00 00       	jmp    b0f0 <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    af42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    af49:	eb 04                	jmp    af4f <alloc_page+0x64>
        i++;
    af4b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    af4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    af52:	c1 e0 04             	shl    $0x4,%eax
    af55:	05 40 f1 01 00       	add    $0x1f140,%eax
    af5a:	8b 00                	mov    (%eax),%eax
    af5c:	ba 5f f1 00 00       	mov    $0xf15f,%edx
    af61:	39 d0                	cmp    %edx,%eax
    af63:	74 09                	je     af6e <alloc_page+0x83>
    af65:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    af6c:	76 dd                	jbe    af4b <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    af6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    af71:	c1 e0 04             	shl    $0x4,%eax
    af74:	05 40 f1 01 00       	add    $0x1f140,%eax
    af79:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    af7c:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af81:	8b 00                	mov    (%eax),%eax
    af83:	8b 55 08             	mov    0x8(%ebp),%edx
    af86:	81 c2 00 01 00 00    	add    $0x100,%edx
    af8c:	c1 e2 0c             	shl    $0xc,%edx
    af8f:	39 d0                	cmp    %edx,%eax
    af91:	72 4c                	jb     afdf <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    af93:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af96:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    af9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af9f:	8b 55 08             	mov    0x8(%ebp),%edx
    afa2:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    afa5:	8b 15 20 f1 01 00    	mov    0x1f120,%edx
    afab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afae:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    afb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afb4:	a3 20 f1 01 00       	mov    %eax,0x1f120

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    afb9:	8b 45 08             	mov    0x8(%ebp),%eax
    afbc:	c1 e0 0c             	shl    $0xc,%eax
    afbf:	89 c2                	mov    %eax,%edx
    afc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afc4:	8b 00                	mov    (%eax),%eax
    afc6:	83 ec 04             	sub    $0x4,%esp
    afc9:	52                   	push   %edx
    afca:	6a 00                	push   $0x0
    afcc:	50                   	push   %eax
    afcd:	e8 a2 e4 ff ff       	call   9474 <memset>
    afd2:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    afd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afd8:	8b 00                	mov    (%eax),%eax
    afda:	e9 11 01 00 00       	jmp    b0f0 <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    afdf:	a1 20 f1 01 00       	mov    0x1f120,%eax
    afe4:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    afe7:	eb 2a                	jmp    b013 <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    afe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afec:	8b 40 0c             	mov    0xc(%eax),%eax
    afef:	8b 10                	mov    (%eax),%edx
    aff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aff4:	8b 08                	mov    (%eax),%ecx
    aff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aff9:	8b 58 04             	mov    0x4(%eax),%ebx
    affc:	8b 45 08             	mov    0x8(%ebp),%eax
    afff:	01 d8                	add    %ebx,%eax
    b001:	c1 e0 0c             	shl    $0xc,%eax
    b004:	01 c8                	add    %ecx,%eax
    b006:	39 c2                	cmp    %eax,%edx
    b008:	77 15                	ja     b01f <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    b00a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b00d:	8b 40 0c             	mov    0xc(%eax),%eax
    b010:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    b013:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b016:	8b 40 0c             	mov    0xc(%eax),%eax
    b019:	85 c0                	test   %eax,%eax
    b01b:	75 cc                	jne    afe9 <alloc_page+0xfe>
    b01d:	eb 01                	jmp    b020 <alloc_page+0x135>
            break;
    b01f:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    b020:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b023:	8b 40 0c             	mov    0xc(%eax),%eax
    b026:	85 c0                	test   %eax,%eax
    b028:	75 5d                	jne    b087 <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    b02a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b02d:	8b 10                	mov    (%eax),%edx
    b02f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b032:	8b 40 04             	mov    0x4(%eax),%eax
    b035:	c1 e0 0c             	shl    $0xc,%eax
    b038:	01 c2                	add    %eax,%edx
    b03a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b03d:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    b03f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b042:	8b 55 08             	mov    0x8(%ebp),%edx
    b045:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    b048:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b04b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    b052:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b055:	8b 55 f0             	mov    -0x10(%ebp),%edx
    b058:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    b05b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b05e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b061:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    b064:	8b 45 08             	mov    0x8(%ebp),%eax
    b067:	c1 e0 0c             	shl    $0xc,%eax
    b06a:	89 c2                	mov    %eax,%edx
    b06c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b06f:	8b 00                	mov    (%eax),%eax
    b071:	83 ec 04             	sub    $0x4,%esp
    b074:	52                   	push   %edx
    b075:	6a 00                	push   $0x0
    b077:	50                   	push   %eax
    b078:	e8 f7 e3 ff ff       	call   9474 <memset>
    b07d:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b080:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b083:	8b 00                	mov    (%eax),%eax
    b085:	eb 69                	jmp    b0f0 <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    b087:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b08a:	8b 10                	mov    (%eax),%edx
    b08c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b08f:	8b 40 04             	mov    0x4(%eax),%eax
    b092:	c1 e0 0c             	shl    $0xc,%eax
    b095:	01 c2                	add    %eax,%edx
    b097:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b09a:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    b09c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b09f:	8b 55 08             	mov    0x8(%ebp),%edx
    b0a2:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    b0a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0a8:	8b 50 0c             	mov    0xc(%eax),%edx
    b0ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0ae:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    b0b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    b0b7:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    b0ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b0c0:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    b0c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0c6:	8b 40 0c             	mov    0xc(%eax),%eax
    b0c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b0cc:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    b0cf:	8b 45 08             	mov    0x8(%ebp),%eax
    b0d2:	c1 e0 0c             	shl    $0xc,%eax
    b0d5:	89 c2                	mov    %eax,%edx
    b0d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0da:	8b 00                	mov    (%eax),%eax
    b0dc:	83 ec 04             	sub    $0x4,%esp
    b0df:	52                   	push   %edx
    b0e0:	6a 00                	push   $0x0
    b0e2:	50                   	push   %eax
    b0e3:	e8 8c e3 ff ff       	call   9474 <memset>
    b0e8:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b0eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0ee:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    b0f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    b0f3:	c9                   	leave  
    b0f4:	c3                   	ret    

0000b0f5 <free_page>:

void free_page(_address_order_track_ page)
{
    b0f5:	55                   	push   %ebp
    b0f6:	89 e5                	mov    %esp,%ebp
    b0f8:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    b0fb:	8b 45 10             	mov    0x10(%ebp),%eax
    b0fe:	85 c0                	test   %eax,%eax
    b100:	75 2d                	jne    b12f <free_page+0x3a>
    b102:	8b 45 14             	mov    0x14(%ebp),%eax
    b105:	85 c0                	test   %eax,%eax
    b107:	74 26                	je     b12f <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    b109:	b8 5f f1 00 00       	mov    $0xf15f,%eax
    b10e:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    b111:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b116:	8b 40 0c             	mov    0xc(%eax),%eax
    b119:	a3 20 f1 01 00       	mov    %eax,0x1f120
        _page_area_track_->previous_ = END_LIST;
    b11e:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b123:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    b12a:	e9 13 01 00 00       	jmp    b242 <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    b12f:	8b 45 10             	mov    0x10(%ebp),%eax
    b132:	85 c0                	test   %eax,%eax
    b134:	75 67                	jne    b19d <free_page+0xa8>
    b136:	8b 45 14             	mov    0x14(%ebp),%eax
    b139:	85 c0                	test   %eax,%eax
    b13b:	75 60                	jne    b19d <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    b13d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    b144:	eb 49                	jmp    b18f <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    b146:	ba 5f f1 00 00       	mov    $0xf15f,%edx
    b14b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b14e:	c1 e0 04             	shl    $0x4,%eax
    b151:	05 40 f1 01 00       	add    $0x1f140,%eax
    b156:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    b158:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b15b:	c1 e0 04             	shl    $0x4,%eax
    b15e:	05 44 f1 01 00       	add    $0x1f144,%eax
    b163:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    b169:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b16c:	c1 e0 04             	shl    $0x4,%eax
    b16f:	05 4c f1 01 00       	add    $0x1f14c,%eax
    b174:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    b17a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b17d:	c1 e0 04             	shl    $0x4,%eax
    b180:	05 48 f1 01 00       	add    $0x1f148,%eax
    b185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    b18b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b18f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    b196:	76 ae                	jbe    b146 <free_page+0x51>
        }
        return;
    b198:	e9 a5 00 00 00       	jmp    b242 <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b19d:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b1a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b1a5:	eb 09                	jmp    b1b0 <free_page+0xbb>
            tmp = tmp->next_;
    b1a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1aa:	8b 40 0c             	mov    0xc(%eax),%eax
    b1ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b1b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1b3:	8b 10                	mov    (%eax),%edx
    b1b5:	8b 45 08             	mov    0x8(%ebp),%eax
    b1b8:	39 c2                	cmp    %eax,%edx
    b1ba:	74 0a                	je     b1c6 <free_page+0xd1>
    b1bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1bf:	8b 40 0c             	mov    0xc(%eax),%eax
    b1c2:	85 c0                	test   %eax,%eax
    b1c4:	75 e1                	jne    b1a7 <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    b1c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1c9:	8b 40 0c             	mov    0xc(%eax),%eax
    b1cc:	85 c0                	test   %eax,%eax
    b1ce:	75 25                	jne    b1f5 <free_page+0x100>
    b1d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1d3:	8b 10                	mov    (%eax),%edx
    b1d5:	8b 45 08             	mov    0x8(%ebp),%eax
    b1d8:	39 c2                	cmp    %eax,%edx
    b1da:	75 19                	jne    b1f5 <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b1dc:	ba 5f f1 00 00       	mov    $0xf15f,%edx
    b1e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1e4:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    b1e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1e9:	8b 40 08             	mov    0x8(%eax),%eax
    b1ec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    b1f3:	eb 4d                	jmp    b242 <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    b1f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1f8:	8b 40 0c             	mov    0xc(%eax),%eax
    b1fb:	85 c0                	test   %eax,%eax
    b1fd:	74 36                	je     b235 <free_page+0x140>
    b1ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b202:	8b 10                	mov    (%eax),%edx
    b204:	8b 45 08             	mov    0x8(%ebp),%eax
    b207:	39 c2                	cmp    %eax,%edx
    b209:	75 2a                	jne    b235 <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b20b:	ba 5f f1 00 00       	mov    $0xf15f,%edx
    b210:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b213:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    b215:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b218:	8b 40 08             	mov    0x8(%eax),%eax
    b21b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b21e:	8b 52 0c             	mov    0xc(%edx),%edx
    b221:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    b224:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b227:	8b 40 0c             	mov    0xc(%eax),%eax
    b22a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b22d:	8b 52 08             	mov    0x8(%edx),%edx
    b230:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    b233:	eb 0d                	jmp    b242 <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    b235:	a1 24 f1 01 00       	mov    0x1f124,%eax
    b23a:	83 e8 01             	sub    $0x1,%eax
    b23d:	a3 24 f1 01 00       	mov    %eax,0x1f124
    b242:	c9                   	leave  
    b243:	c3                   	ret    

0000b244 <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    b244:	55                   	push   %ebp
    b245:	89 e5                	mov    %esp,%ebp
    b247:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    b24a:	a1 48 31 02 00       	mov    0x23148,%eax
    b24f:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    b252:	a1 48 31 02 00       	mov    0x23148,%eax
    b257:	8b 40 3c             	mov    0x3c(%eax),%eax
    b25a:	a3 48 31 02 00       	mov    %eax,0x23148

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    b25f:	a1 48 31 02 00       	mov    0x23148,%eax
    b264:	89 c2                	mov    %eax,%edx
    b266:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b269:	83 ec 08             	sub    $0x8,%esp
    b26c:	52                   	push   %edx
    b26d:	50                   	push   %eax
    b26e:	e8 cd 02 00 00       	call   b540 <switch_to_task>
    b273:	83 c4 10             	add    $0x10,%esp
}
    b276:	90                   	nop
    b277:	c9                   	leave  
    b278:	c3                   	ret    

0000b279 <init_multitasking>:

void init_multitasking()
{
    b279:	55                   	push   %ebp
    b27a:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    b27c:	c6 05 40 31 02 00 00 	movb   $0x0,0x23140
    sheduler.task_timer = DELAY_PER_TASK;
    b283:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    b28a:	01 00 00 
}
    b28d:	90                   	nop
    b28e:	5d                   	pop    %ebp
    b28f:	c3                   	ret    

0000b290 <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    b290:	55                   	push   %ebp
    b291:	89 e5                	mov    %esp,%ebp
    b293:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    b296:	8b 45 08             	mov    0x8(%ebp),%eax
    b299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    b29f:	8b 45 08             	mov    0x8(%ebp),%eax
    b2a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    b2a9:	8b 45 08             	mov    0x8(%ebp),%eax
    b2ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    b2b3:	8b 45 08             	mov    0x8(%ebp),%eax
    b2b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    b2bd:	8b 45 08             	mov    0x8(%ebp),%eax
    b2c0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    b2c7:	8b 45 08             	mov    0x8(%ebp),%eax
    b2ca:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    b2d1:	8b 45 08             	mov    0x8(%ebp),%eax
    b2d4:	8b 55 10             	mov    0x10(%ebp),%edx
    b2d7:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    b2da:	8b 55 0c             	mov    0xc(%ebp),%edx
    b2dd:	8b 45 08             	mov    0x8(%ebp),%eax
    b2e0:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    b2e3:	8b 45 08             	mov    0x8(%ebp),%eax
    b2e6:	8b 55 14             	mov    0x14(%ebp),%edx
    b2e9:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    b2ec:	83 ec 0c             	sub    $0xc,%esp
    b2ef:	68 c8 00 00 00       	push   $0xc8
    b2f4:	e8 c1 f8 ff ff       	call   abba <kmalloc>
    b2f9:	83 c4 10             	add    $0x10,%esp
    b2fc:	89 c2                	mov    %eax,%edx
    b2fe:	8b 45 08             	mov    0x8(%ebp),%eax
    b301:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    b304:	8b 45 08             	mov    0x8(%ebp),%eax
    b307:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b30e:	90                   	nop
    b30f:	c9                   	leave  
    b310:	c3                   	ret    
    b311:	66 90                	xchg   %ax,%ax
    b313:	66 90                	xchg   %ax,%ax
    b315:	66 90                	xchg   %ax,%ax
    b317:	66 90                	xchg   %ax,%ax
    b319:	66 90                	xchg   %ax,%ax
    b31b:	66 90                	xchg   %ax,%ax
    b31d:	66 90                	xchg   %ax,%ax
    b31f:	90                   	nop

0000b320 <__exception_handler__>:
    b320:	58                   	pop    %eax
    b321:	a3 5c b7 00 00       	mov    %eax,0xb75c
    b326:	e8 50 e4 ff ff       	call   977b <__exception__>
    b32b:	cf                   	iret   

0000b32c <__exception_no_ERRCODE_handler__>:
    b32c:	e8 50 e4 ff ff       	call   9781 <__exception_no_ERRCODE__>
    b331:	cf                   	iret   
    b332:	66 90                	xchg   %ax,%ax
    b334:	66 90                	xchg   %ax,%ax
    b336:	66 90                	xchg   %ax,%ax
    b338:	66 90                	xchg   %ax,%ax
    b33a:	66 90                	xchg   %ax,%ax
    b33c:	66 90                	xchg   %ax,%ax
    b33e:	66 90                	xchg   %ax,%ax

0000b340 <gdtr>:
    b340:	00 00                	add    %al,(%eax)
    b342:	00 00                	add    %al,(%eax)
	...

0000b346 <load_gdt>:
    b346:	fa                   	cli    
    b347:	50                   	push   %eax
    b348:	51                   	push   %ecx
    b349:	b9 00 00 00 00       	mov    $0x0,%ecx
    b34e:	89 0d 42 b3 00 00    	mov    %ecx,0xb342
    b354:	31 c0                	xor    %eax,%eax
    b356:	b8 00 01 00 00       	mov    $0x100,%eax
    b35b:	01 c8                	add    %ecx,%eax
    b35d:	66 a3 40 b3 00 00    	mov    %ax,0xb340
    b363:	0f 01 15 40 b3 00 00 	lgdtl  0xb340
    b36a:	8b 0d 42 b3 00 00    	mov    0xb342,%ecx
    b370:	83 c1 20             	add    $0x20,%ecx
    b373:	0f 00 d9             	ltr    %cx
    b376:	59                   	pop    %ecx
    b377:	58                   	pop    %eax
    b378:	c3                   	ret    

0000b379 <idtr>:
    b379:	00 00                	add    %al,(%eax)
    b37b:	00 00                	add    %al,(%eax)
	...

0000b37f <load_idt>:
    b37f:	fa                   	cli    
    b380:	50                   	push   %eax
    b381:	51                   	push   %ecx
    b382:	31 c9                	xor    %ecx,%ecx
    b384:	b9 20 00 01 00       	mov    $0x10020,%ecx
    b389:	89 0d 7b b3 00 00    	mov    %ecx,0xb37b
    b38f:	31 c0                	xor    %eax,%eax
    b391:	b8 00 04 00 00       	mov    $0x400,%eax
    b396:	01 c8                	add    %ecx,%eax
    b398:	66 a3 79 b3 00 00    	mov    %ax,0xb379
    b39e:	0f 01 1d 79 b3 00 00 	lidtl  0xb379
    b3a5:	59                   	pop    %ecx
    b3a6:	58                   	pop    %eax
    b3a7:	c3                   	ret    
    b3a8:	66 90                	xchg   %ax,%ax
    b3aa:	66 90                	xchg   %ax,%ax
    b3ac:	66 90                	xchg   %ax,%ax
    b3ae:	66 90                	xchg   %ax,%ax

0000b3b0 <irq1>:
    b3b0:	60                   	pusha  
    b3b1:	e8 63 ea ff ff       	call   9e19 <irq1_handler>
    b3b6:	61                   	popa   
    b3b7:	cf                   	iret   

0000b3b8 <irq2>:
    b3b8:	60                   	pusha  
    b3b9:	e8 76 ea ff ff       	call   9e34 <irq2_handler>
    b3be:	61                   	popa   
    b3bf:	cf                   	iret   

0000b3c0 <irq3>:
    b3c0:	60                   	pusha  
    b3c1:	e8 91 ea ff ff       	call   9e57 <irq3_handler>
    b3c6:	61                   	popa   
    b3c7:	cf                   	iret   

0000b3c8 <irq4>:
    b3c8:	60                   	pusha  
    b3c9:	e8 ac ea ff ff       	call   9e7a <irq4_handler>
    b3ce:	61                   	popa   
    b3cf:	cf                   	iret   

0000b3d0 <irq5>:
    b3d0:	60                   	pusha  
    b3d1:	e8 c7 ea ff ff       	call   9e9d <irq5_handler>
    b3d6:	61                   	popa   
    b3d7:	cf                   	iret   

0000b3d8 <irq6>:
    b3d8:	60                   	pusha  
    b3d9:	e8 e2 ea ff ff       	call   9ec0 <irq6_handler>
    b3de:	61                   	popa   
    b3df:	cf                   	iret   

0000b3e0 <irq7>:
    b3e0:	60                   	pusha  
    b3e1:	e8 fd ea ff ff       	call   9ee3 <irq7_handler>
    b3e6:	61                   	popa   
    b3e7:	cf                   	iret   

0000b3e8 <irq8>:
    b3e8:	60                   	pusha  
    b3e9:	e8 18 eb ff ff       	call   9f06 <irq8_handler>
    b3ee:	61                   	popa   
    b3ef:	cf                   	iret   

0000b3f0 <irq9>:
    b3f0:	60                   	pusha  
    b3f1:	e8 33 eb ff ff       	call   9f29 <irq9_handler>
    b3f6:	61                   	popa   
    b3f7:	cf                   	iret   

0000b3f8 <irq10>:
    b3f8:	60                   	pusha  
    b3f9:	e8 4e eb ff ff       	call   9f4c <irq10_handler>
    b3fe:	61                   	popa   
    b3ff:	cf                   	iret   

0000b400 <irq11>:
    b400:	60                   	pusha  
    b401:	e8 69 eb ff ff       	call   9f6f <irq11_handler>
    b406:	61                   	popa   
    b407:	cf                   	iret   

0000b408 <irq12>:
    b408:	60                   	pusha  
    b409:	e8 84 eb ff ff       	call   9f92 <irq12_handler>
    b40e:	61                   	popa   
    b40f:	cf                   	iret   

0000b410 <irq13>:
    b410:	60                   	pusha  
    b411:	e8 9f eb ff ff       	call   9fb5 <irq13_handler>
    b416:	61                   	popa   
    b417:	cf                   	iret   

0000b418 <irq14>:
    b418:	60                   	pusha  
    b419:	e8 ba eb ff ff       	call   9fd8 <irq14_handler>
    b41e:	61                   	popa   
    b41f:	cf                   	iret   

0000b420 <irq15>:
    b420:	60                   	pusha  
    b421:	e8 d5 eb ff ff       	call   9ffb <irq15_handler>
    b426:	61                   	popa   
    b427:	cf                   	iret   
    b428:	66 90                	xchg   %ax,%ax
    b42a:	66 90                	xchg   %ax,%ax
    b42c:	66 90                	xchg   %ax,%ax
    b42e:	66 90                	xchg   %ax,%ax

0000b430 <_FlushPagingCache_>:
    b430:	b8 00 10 01 00       	mov    $0x11000,%eax
    b435:	0f 22 d8             	mov    %eax,%cr3
    b438:	c3                   	ret    

0000b439 <_EnablingPaging_>:
    b439:	e8 f2 ff ff ff       	call   b430 <_FlushPagingCache_>
    b43e:	0f 20 c0             	mov    %cr0,%eax
    b441:	0d 01 00 00 80       	or     $0x80000001,%eax
    b446:	0f 22 c0             	mov    %eax,%cr0
    b449:	c3                   	ret    

0000b44a <PagingFault_Handler>:
    b44a:	58                   	pop    %eax
    b44b:	a3 60 b7 00 00       	mov    %eax,0xb760
    b450:	e8 fe ef ff ff       	call   a453 <Paging_fault>
    b455:	cf                   	iret   
    b456:	66 90                	xchg   %ax,%ax
    b458:	66 90                	xchg   %ax,%ax
    b45a:	66 90                	xchg   %ax,%ax
    b45c:	66 90                	xchg   %ax,%ax
    b45e:	66 90                	xchg   %ax,%ax

0000b460 <PIT_handler>:
    b460:	9c                   	pushf  
    b461:	e8 16 00 00 00       	call   b47c <irq_PIT>
    b466:	e8 2f f2 ff ff       	call   a69a <conserv_status_byte>
    b46b:	e8 c6 f2 ff ff       	call   a736 <sheduler_cpu_timer>
    b470:	90                   	nop
    b471:	90                   	nop
    b472:	90                   	nop
    b473:	90                   	nop
    b474:	90                   	nop
    b475:	90                   	nop
    b476:	90                   	nop
    b477:	90                   	nop
    b478:	90                   	nop
    b479:	90                   	nop
    b47a:	9d                   	popf   
    b47b:	cf                   	iret   

0000b47c <irq_PIT>:
    b47c:	a1 68 32 02 00       	mov    0x23268,%eax
    b481:	8b 1d 6c 32 02 00    	mov    0x2326c,%ebx
    b487:	01 05 60 32 02 00    	add    %eax,0x23260
    b48d:	11 1d 64 32 02 00    	adc    %ebx,0x23264
    b493:	6a 00                	push   $0x0
    b495:	e8 bf ef ff ff       	call   a459 <PIC_sendEOI>
    b49a:	58                   	pop    %eax
    b49b:	c3                   	ret    

0000b49c <calculate_frequency>:
    b49c:	60                   	pusha  
    b49d:	8b 1d 04 20 01 00    	mov    0x12004,%ebx
    b4a3:	b8 00 00 01 00       	mov    $0x10000,%eax
    b4a8:	83 fb 12             	cmp    $0x12,%ebx
    b4ab:	76 34                	jbe    b4e1 <calculate_frequency.gotReloadValue>
    b4ad:	b8 01 00 00 00       	mov    $0x1,%eax
    b4b2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    b4b8:	73 27                	jae    b4e1 <calculate_frequency.gotReloadValue>
    b4ba:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b4bf:	ba 00 00 00 00       	mov    $0x0,%edx
    b4c4:	f7 f3                	div    %ebx
    b4c6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b4cc:	72 01                	jb     b4cf <calculate_frequency.l1>
    b4ce:	40                   	inc    %eax

0000b4cf <calculate_frequency.l1>:
    b4cf:	bb 03 00 00 00       	mov    $0x3,%ebx
    b4d4:	ba 00 00 00 00       	mov    $0x0,%edx
    b4d9:	f7 f3                	div    %ebx
    b4db:	83 fa 01             	cmp    $0x1,%edx
    b4de:	72 01                	jb     b4e1 <calculate_frequency.gotReloadValue>
    b4e0:	40                   	inc    %eax

0000b4e1 <calculate_frequency.gotReloadValue>:
    b4e1:	50                   	push   %eax
    b4e2:	66 a3 74 32 02 00    	mov    %ax,0x23274
    b4e8:	89 c3                	mov    %eax,%ebx
    b4ea:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b4ef:	ba 00 00 00 00       	mov    $0x0,%edx
    b4f4:	f7 f3                	div    %ebx
    b4f6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b4fc:	72 01                	jb     b4ff <calculate_frequency.l3>
    b4fe:	40                   	inc    %eax

0000b4ff <calculate_frequency.l3>:
    b4ff:	bb 03 00 00 00       	mov    $0x3,%ebx
    b504:	ba 00 00 00 00       	mov    $0x0,%edx
    b509:	f7 f3                	div    %ebx
    b50b:	83 fa 01             	cmp    $0x1,%edx
    b50e:	72 01                	jb     b511 <calculate_frequency.l4>
    b510:	40                   	inc    %eax

0000b511 <calculate_frequency.l4>:
    b511:	a3 70 32 02 00       	mov    %eax,0x23270
    b516:	5b                   	pop    %ebx
    b517:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    b51c:	f7 e3                	mul    %ebx
    b51e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    b522:	c1 ea 0a             	shr    $0xa,%edx
    b525:	89 15 6c 32 02 00    	mov    %edx,0x2326c
    b52b:	a3 68 32 02 00       	mov    %eax,0x23268
    b530:	61                   	popa   
    b531:	c3                   	ret    
    b532:	66 90                	xchg   %ax,%ax
    b534:	66 90                	xchg   %ax,%ax
    b536:	66 90                	xchg   %ax,%ax
    b538:	66 90                	xchg   %ax,%ax
    b53a:	66 90                	xchg   %ax,%ax
    b53c:	66 90                	xchg   %ax,%ax
    b53e:	66 90                	xchg   %ax,%ax

0000b540 <switch_to_task>:
    b540:	50                   	push   %eax
    b541:	8b 44 24 08          	mov    0x8(%esp),%eax
    b545:	89 58 04             	mov    %ebx,0x4(%eax)
    b548:	89 48 08             	mov    %ecx,0x8(%eax)
    b54b:	89 50 0c             	mov    %edx,0xc(%eax)
    b54e:	89 70 10             	mov    %esi,0x10(%eax)
    b551:	89 78 14             	mov    %edi,0x14(%eax)
    b554:	89 60 18             	mov    %esp,0x18(%eax)
    b557:	89 68 1c             	mov    %ebp,0x1c(%eax)
    b55a:	51                   	push   %ecx
    b55b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    b55f:	89 48 20             	mov    %ecx,0x20(%eax)
    b562:	59                   	pop    %ecx
    b563:	51                   	push   %ecx
    b564:	9c                   	pushf  
    b565:	59                   	pop    %ecx
    b566:	89 48 24             	mov    %ecx,0x24(%eax)
    b569:	59                   	pop    %ecx
    b56a:	51                   	push   %ecx
    b56b:	0f 20 d9             	mov    %cr3,%ecx
    b56e:	89 48 28             	mov    %ecx,0x28(%eax)
    b571:	59                   	pop    %ecx
    b572:	8c 40 2c             	mov    %es,0x2c(%eax)
    b575:	8c 68 2e             	mov    %gs,0x2e(%eax)
    b578:	8c 60 30             	mov    %fs,0x30(%eax)
    b57b:	51                   	push   %ecx
    b57c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    b580:	89 08                	mov    %ecx,(%eax)
    b582:	59                   	pop    %ecx
    b583:	58                   	pop    %eax
    b584:	8b 44 24 08          	mov    0x8(%esp),%eax
    b588:	8b 58 04             	mov    0x4(%eax),%ebx
    b58b:	8b 48 08             	mov    0x8(%eax),%ecx
    b58e:	8b 50 0c             	mov    0xc(%eax),%edx
    b591:	8b 70 10             	mov    0x10(%eax),%esi
    b594:	8b 78 14             	mov    0x14(%eax),%edi
    b597:	8b 60 18             	mov    0x18(%eax),%esp
    b59a:	8b 68 1c             	mov    0x1c(%eax),%ebp
    b59d:	51                   	push   %ecx
    b59e:	8b 48 24             	mov    0x24(%eax),%ecx
    b5a1:	51                   	push   %ecx
    b5a2:	9d                   	popf   
    b5a3:	59                   	pop    %ecx
    b5a4:	51                   	push   %ecx
    b5a5:	8b 48 28             	mov    0x28(%eax),%ecx
    b5a8:	0f 22 d9             	mov    %ecx,%cr3
    b5ab:	59                   	pop    %ecx
    b5ac:	8e 40 2c             	mov    0x2c(%eax),%es
    b5af:	8e 68 2e             	mov    0x2e(%eax),%gs
    b5b2:	8e 60 30             	mov    0x30(%eax),%fs
    b5b5:	8b 40 20             	mov    0x20(%eax),%eax
    b5b8:	89 04 24             	mov    %eax,(%esp)
    b5bb:	c3                   	ret    
