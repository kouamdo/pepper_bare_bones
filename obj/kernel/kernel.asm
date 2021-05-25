
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

    init_console();
    900f:	e8 62 07 00 00       	call   9776 <init_console>

    init_gdt();
    9014:	e8 08 08 00 00       	call   9821 <init_gdt>

    init_idt();
    9019:	e8 1d 09 00 00       	call   993b <init_idt>

    //Kernel Mapping
    kprintf("Pepper kernel info : \n");
    901e:	83 ec 0c             	sub    $0xc,%esp
    9021:	68 00 f0 00 00       	push   $0xf000
    9026:	e8 19 1a 00 00       	call   aa44 <kprintf>
    902b:	83 c4 10             	add    $0x10,%esp
    kprintf("PEPPER_Kernel init at [%p] length [%d] bytes \n", main, &end - (void**)main);
    902e:	b8 01 40 02 00       	mov    $0x24001,%eax
    9033:	2d 00 90 00 00       	sub    $0x9000,%eax
    9038:	c1 f8 02             	sar    $0x2,%eax
    903b:	83 ec 04             	sub    $0x4,%esp
    903e:	50                   	push   %eax
    903f:	68 00 90 00 00       	push   $0x9000
    9044:	68 18 f0 00 00       	push   $0xf018
    9049:	e8 f6 19 00 00       	call   aa44 <kprintf>
    904e:	83 c4 10             	add    $0x10,%esp
    kprintf("Allocate [16384] bytes of stacks\n");
    9051:	83 ec 0c             	sub    $0xc,%esp
    9054:	68 48 f0 00 00       	push   $0xf048
    9059:	e8 e6 19 00 00       	call   aa44 <kprintf>
    905e:	83 c4 10             	add    $0x10,%esp
    kprintf("Firmware variables at [%p] length [%d] bytes \n", detect_bios_info(), detect_bios_info_end() - detect_bios_info());
    9061:	e8 6d 00 00 00       	call   90d3 <detect_bios_info_end>
    9066:	89 c3                	mov    %eax,%ebx
    9068:	e8 1b 00 00 00       	call   9088 <detect_bios_info>
    906d:	29 c3                	sub    %eax,%ebx
    906f:	e8 14 00 00 00       	call   9088 <detect_bios_info>
    9074:	83 ec 04             	sub    $0x4,%esp
    9077:	53                   	push   %ebx
    9078:	50                   	push   %eax
    9079:	68 6c f0 00 00       	push   $0xf06c
    907e:	e8 c1 19 00 00       	call   aa44 <kprintf>
    9083:	83 c4 10             	add    $0x10,%esp
    //--------------

    while (1)
    9086:	eb fe                	jmp    9086 <main+0x86>

00009088 <detect_bios_info>:
        ;
}

//detect BIOS info--------------------------
void* detect_bios_info()
{
    9088:	55                   	push   %ebp
    9089:	89 e5                	mov    %esp,%ebp
    908b:	83 ec 10             	sub    $0x10,%esp
    int       i = 0;
    908e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    uint16_t* bios_info;

    bios_info = (int16_t*)(0x7e00);
    9095:	c7 45 f8 00 7e 00 00 	movl   $0x7e00,-0x8(%ebp)

    while (bios_info[i] != 0xB00B)
    909c:	eb 04                	jmp    90a2 <detect_bios_info+0x1a>
        i++;
    909e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (bios_info[i] != 0xB00B)
    90a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90a5:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90ab:	01 d0                	add    %edx,%eax
    90ad:	0f b7 00             	movzwl (%eax),%eax
    90b0:	66 3d 0b b0          	cmp    $0xb00b,%ax
    90b4:	75 e8                	jne    909e <detect_bios_info+0x16>

    bios_info_begin = (char*)(&bios_info[i]);
    90b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90b9:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90bf:	01 d0                	add    %edx,%eax
    90c1:	a3 00 00 01 00       	mov    %eax,0x10000

    return (void*)(&bios_info[i]);
    90c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90c9:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90cf:	01 d0                	add    %edx,%eax
}
    90d1:	c9                   	leave  
    90d2:	c3                   	ret    

000090d3 <detect_bios_info_end>:

void* detect_bios_info_end()
{
    90d3:	55                   	push   %ebp
    90d4:	89 e5                	mov    %esp,%ebp
    90d6:	83 ec 10             	sub    $0x10,%esp
    int       i = 0;
    90d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    uint16_t* bios_info;

    bios_info = (int16_t*)(bios_info_begin);
    90e0:	a1 00 00 01 00       	mov    0x10000,%eax
    90e5:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (bios_info[i] != 0xB00E)
    90e8:	eb 04                	jmp    90ee <detect_bios_info_end+0x1b>
        i++;
    90ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (bios_info[i] != 0xB00E)
    90ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
    90f1:	8d 14 00             	lea    (%eax,%eax,1),%edx
    90f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    90f7:	01 d0                	add    %edx,%eax
    90f9:	0f b7 00             	movzwl (%eax),%eax
    90fc:	66 3d 0e b0          	cmp    $0xb00e,%ax
    9100:	75 e8                	jne    90ea <detect_bios_info_end+0x17>

    return (void*)(&bios_info[i]);
    9102:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9105:	8d 14 00             	lea    (%eax,%eax,1),%edx
    9108:	8b 45 f8             	mov    -0x8(%ebp),%eax
    910b:	01 d0                	add    %edx,%eax
}
    910d:	c9                   	leave  
    910e:	c3                   	ret    

0000910f <putchar>:
 * Print a number (base <= 16) in reverse order,
 */
void puts(const char* string);

void putchar(uint8_t c)
{
    910f:	55                   	push   %ebp
    9110:	89 e5                	mov    %esp,%ebp
    9112:	83 ec 18             	sub    $0x18,%esp
    9115:	8b 45 08             	mov    0x8(%ebp),%eax
    9118:	88 45 f4             	mov    %al,-0xc(%ebp)
    cputchar(READY_COLOR, c);
    911b:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    911f:	0f be c0             	movsbl %al,%eax
    9122:	83 ec 08             	sub    $0x8,%esp
    9125:	50                   	push   %eax
    9126:	6a 07                	push   $0x7
    9128:	e8 b7 04 00 00       	call   95e4 <cputchar>
    912d:	83 c4 10             	add    $0x10,%esp
}
    9130:	90                   	nop
    9131:	c9                   	leave  
    9132:	c3                   	ret    

00009133 <printnum>:

static void printnum(uint32_t num, uint8_t base)
{
    9133:	55                   	push   %ebp
    9134:	89 e5                	mov    %esp,%ebp
    9136:	53                   	push   %ebx
    9137:	83 ec 14             	sub    $0x14,%esp
    913a:	8b 45 0c             	mov    0xc(%ebp),%eax
    913d:	88 45 f4             	mov    %al,-0xc(%ebp)
    if (num >= base) printnum((uint32_t)(num / base), base);
    9140:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    9144:	39 45 08             	cmp    %eax,0x8(%ebp)
    9147:	72 1f                	jb     9168 <printnum+0x35>
    9149:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    914d:	0f b6 5d f4          	movzbl -0xc(%ebp),%ebx
    9151:	8b 45 08             	mov    0x8(%ebp),%eax
    9154:	ba 00 00 00 00       	mov    $0x0,%edx
    9159:	f7 f3                	div    %ebx
    915b:	83 ec 08             	sub    $0x8,%esp
    915e:	51                   	push   %ecx
    915f:	50                   	push   %eax
    9160:	e8 ce ff ff ff       	call   9133 <printnum>
    9165:	83 c4 10             	add    $0x10,%esp

    putchar("0123456789abcdef"[num % base]);
    9168:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    916c:	8b 45 08             	mov    0x8(%ebp),%eax
    916f:	ba 00 00 00 00       	mov    $0x0,%edx
    9174:	f7 f1                	div    %ecx
    9176:	89 d0                	mov    %edx,%eax
    9178:	0f b6 80 9c f0 00 00 	movzbl 0xf09c(%eax),%eax
    917f:	0f b6 c0             	movzbl %al,%eax
    9182:	83 ec 0c             	sub    $0xc,%esp
    9185:	50                   	push   %eax
    9186:	e8 84 ff ff ff       	call   910f <putchar>
    918b:	83 c4 10             	add    $0x10,%esp
}
    918e:	90                   	nop
    918f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    9192:	c9                   	leave  
    9193:	c3                   	ret    

00009194 <printf>:

void printf(const char* fmt, va_list arg)
{
    9194:	55                   	push   %ebp
    9195:	89 e5                	mov    %esp,%ebp
    9197:	83 ec 18             	sub    $0x18,%esp
    char*    s;
    int*     p;

    const char* chr_tmp;

    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    919a:	8b 45 08             	mov    0x8(%ebp),%eax
    919d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    91a0:	e9 53 01 00 00       	jmp    92f8 <printf+0x164>

        if (*chr_tmp == '%') {
    91a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91a8:	0f b6 00             	movzbl (%eax),%eax
    91ab:	3c 25                	cmp    $0x25,%al
    91ad:	0f 85 29 01 00 00    	jne    92dc <printf+0x148>
            chr_tmp++;
    91b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            switch (*chr_tmp) {
    91b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91ba:	0f b6 00             	movzbl (%eax),%eax
    91bd:	0f be c0             	movsbl %al,%eax
    91c0:	83 e8 62             	sub    $0x62,%eax
    91c3:	83 f8 16             	cmp    $0x16,%eax
    91c6:	0f 87 27 01 00 00    	ja     92f3 <printf+0x15f>
    91cc:	8b 04 85 b0 f0 00 00 	mov    0xf0b0(,%eax,4),%eax
    91d3:	ff e0                	jmp    *%eax
            case 'c':
                i = va_arg(arg, int32_t);
    91d5:	8b 45 0c             	mov    0xc(%ebp),%eax
    91d8:	8d 50 04             	lea    0x4(%eax),%edx
    91db:	89 55 0c             	mov    %edx,0xc(%ebp)
    91de:	8b 00                	mov    (%eax),%eax
    91e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
                putchar(i);
    91e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    91e6:	0f b6 c0             	movzbl %al,%eax
    91e9:	83 ec 0c             	sub    $0xc,%esp
    91ec:	50                   	push   %eax
    91ed:	e8 1d ff ff ff       	call   910f <putchar>
    91f2:	83 c4 10             	add    $0x10,%esp
                break;
    91f5:	e9 fa 00 00 00       	jmp    92f4 <printf+0x160>
            case 'd':
                i = va_arg(arg, int);
    91fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    91fd:	8d 50 04             	lea    0x4(%eax),%edx
    9200:	89 55 0c             	mov    %edx,0xc(%ebp)
    9203:	8b 00                	mov    (%eax),%eax
    9205:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 10);
    9208:	83 ec 08             	sub    $0x8,%esp
    920b:	6a 0a                	push   $0xa
    920d:	ff 75 f0             	pushl  -0x10(%ebp)
    9210:	e8 1e ff ff ff       	call   9133 <printnum>
    9215:	83 c4 10             	add    $0x10,%esp
                break;
    9218:	e9 d7 00 00 00       	jmp    92f4 <printf+0x160>
            case 'o':
                i = va_arg(arg, int32_t);
    921d:	8b 45 0c             	mov    0xc(%ebp),%eax
    9220:	8d 50 04             	lea    0x4(%eax),%edx
    9223:	89 55 0c             	mov    %edx,0xc(%ebp)
    9226:	8b 00                	mov    (%eax),%eax
    9228:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 8);
    922b:	83 ec 08             	sub    $0x8,%esp
    922e:	6a 08                	push   $0x8
    9230:	ff 75 f0             	pushl  -0x10(%ebp)
    9233:	e8 fb fe ff ff       	call   9133 <printnum>
    9238:	83 c4 10             	add    $0x10,%esp
                break;
    923b:	e9 b4 00 00 00       	jmp    92f4 <printf+0x160>
            case 'b':
                i = va_arg(arg, int32_t);
    9240:	8b 45 0c             	mov    0xc(%ebp),%eax
    9243:	8d 50 04             	lea    0x4(%eax),%edx
    9246:	89 55 0c             	mov    %edx,0xc(%ebp)
    9249:	8b 00                	mov    (%eax),%eax
    924b:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 2);
    924e:	83 ec 08             	sub    $0x8,%esp
    9251:	6a 02                	push   $0x2
    9253:	ff 75 f0             	pushl  -0x10(%ebp)
    9256:	e8 d8 fe ff ff       	call   9133 <printnum>
    925b:	83 c4 10             	add    $0x10,%esp
                break;
    925e:	e9 91 00 00 00       	jmp    92f4 <printf+0x160>
            case 'x':
                i = va_arg(arg, int32_t);
    9263:	8b 45 0c             	mov    0xc(%ebp),%eax
    9266:	8d 50 04             	lea    0x4(%eax),%edx
    9269:	89 55 0c             	mov    %edx,0xc(%ebp)
    926c:	8b 00                	mov    (%eax),%eax
    926e:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 16);
    9271:	83 ec 08             	sub    $0x8,%esp
    9274:	6a 10                	push   $0x10
    9276:	ff 75 f0             	pushl  -0x10(%ebp)
    9279:	e8 b5 fe ff ff       	call   9133 <printnum>
    927e:	83 c4 10             	add    $0x10,%esp
                break;
    9281:	eb 71                	jmp    92f4 <printf+0x160>
            case 's':
                s = va_arg(arg, char*);
    9283:	8b 45 0c             	mov    0xc(%ebp),%eax
    9286:	8d 50 04             	lea    0x4(%eax),%edx
    9289:	89 55 0c             	mov    %edx,0xc(%ebp)
    928c:	8b 00                	mov    (%eax),%eax
    928e:	89 45 ec             	mov    %eax,-0x14(%ebp)
                puts(s);
    9291:	83 ec 0c             	sub    $0xc,%esp
    9294:	ff 75 ec             	pushl  -0x14(%ebp)
    9297:	e8 6e 00 00 00       	call   930a <puts>
    929c:	83 c4 10             	add    $0x10,%esp
                break;
    929f:	eb 53                	jmp    92f4 <printf+0x160>
            case 'p':
                p = va_arg(arg, void*);
    92a1:	8b 45 0c             	mov    0xc(%ebp),%eax
    92a4:	8d 50 04             	lea    0x4(%eax),%edx
    92a7:	89 55 0c             	mov    %edx,0xc(%ebp)
    92aa:	8b 00                	mov    (%eax),%eax
    92ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
                putchar('0');
    92af:	83 ec 0c             	sub    $0xc,%esp
    92b2:	6a 30                	push   $0x30
    92b4:	e8 56 fe ff ff       	call   910f <putchar>
    92b9:	83 c4 10             	add    $0x10,%esp
                putchar('x');
    92bc:	83 ec 0c             	sub    $0xc,%esp
    92bf:	6a 78                	push   $0x78
    92c1:	e8 49 fe ff ff       	call   910f <putchar>
    92c6:	83 c4 10             	add    $0x10,%esp
                printnum((uint32_t)p, 16);
    92c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    92cc:	83 ec 08             	sub    $0x8,%esp
    92cf:	6a 10                	push   $0x10
    92d1:	50                   	push   %eax
    92d2:	e8 5c fe ff ff       	call   9133 <printnum>
    92d7:	83 c4 10             	add    $0x10,%esp
                break;
    92da:	eb 18                	jmp    92f4 <printf+0x160>
                break;
            }
        }

        else
            putchar(*chr_tmp);
    92dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    92df:	0f b6 00             	movzbl (%eax),%eax
    92e2:	0f b6 c0             	movzbl %al,%eax
    92e5:	83 ec 0c             	sub    $0xc,%esp
    92e8:	50                   	push   %eax
    92e9:	e8 21 fe ff ff       	call   910f <putchar>
    92ee:	83 c4 10             	add    $0x10,%esp
    92f1:	eb 01                	jmp    92f4 <printf+0x160>
                break;
    92f3:	90                   	nop
    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    92f4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    92f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    92fb:	0f b6 00             	movzbl (%eax),%eax
    92fe:	84 c0                	test   %al,%al
    9300:	0f 85 9f fe ff ff    	jne    91a5 <printf+0x11>
    }

    va_end(arg);
}
    9306:	90                   	nop
    9307:	90                   	nop
    9308:	c9                   	leave  
    9309:	c3                   	ret    

0000930a <puts>:

void puts(const char* string)
{
    930a:	55                   	push   %ebp
    930b:	89 e5                	mov    %esp,%ebp
    930d:	83 ec 08             	sub    $0x8,%esp
    if (*string != '\0') {
    9310:	8b 45 08             	mov    0x8(%ebp),%eax
    9313:	0f b6 00             	movzbl (%eax),%eax
    9316:	84 c0                	test   %al,%al
    9318:	74 2a                	je     9344 <puts+0x3a>
        putchar(*string);
    931a:	8b 45 08             	mov    0x8(%ebp),%eax
    931d:	0f b6 00             	movzbl (%eax),%eax
    9320:	0f b6 c0             	movzbl %al,%eax
    9323:	83 ec 0c             	sub    $0xc,%esp
    9326:	50                   	push   %eax
    9327:	e8 e3 fd ff ff       	call   910f <putchar>
    932c:	83 c4 10             	add    $0x10,%esp
        puts(string++);
    932f:	8b 45 08             	mov    0x8(%ebp),%eax
    9332:	8d 50 01             	lea    0x1(%eax),%edx
    9335:	89 55 08             	mov    %edx,0x8(%ebp)
    9338:	83 ec 0c             	sub    $0xc,%esp
    933b:	50                   	push   %eax
    933c:	e8 c9 ff ff ff       	call   930a <puts>
    9341:	83 c4 10             	add    $0x10,%esp
    }
    9344:	90                   	nop
    9345:	c9                   	leave  
    9346:	c3                   	ret    

00009347 <_strcmp_>:
#include "../../include/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    9347:	55                   	push   %ebp
    9348:	89 e5                	mov    %esp,%ebp
    934a:	53                   	push   %ebx
    934b:	83 ec 04             	sub    $0x4,%esp
    if (_strlen_(str2) != _strlen_(str1))
    934e:	83 ec 0c             	sub    $0xc,%esp
    9351:	ff 75 0c             	pushl  0xc(%ebp)
    9354:	e8 59 00 00 00       	call   93b2 <_strlen_>
    9359:	83 c4 10             	add    $0x10,%esp
    935c:	89 c3                	mov    %eax,%ebx
    935e:	83 ec 0c             	sub    $0xc,%esp
    9361:	ff 75 08             	pushl  0x8(%ebp)
    9364:	e8 49 00 00 00       	call   93b2 <_strlen_>
    9369:	83 c4 10             	add    $0x10,%esp
    936c:	38 c3                	cmp    %al,%bl
    936e:	74 0f                	je     937f <_strcmp_+0x38>
        return 0;
    9370:	b8 00 00 00 00       	mov    $0x0,%eax
    9375:	eb 36                	jmp    93ad <_strcmp_+0x66>

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
    9377:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        str2++;
    937b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while ((*str1 == *str2) && (*str1 != '\000')) {
    937f:	8b 45 08             	mov    0x8(%ebp),%eax
    9382:	0f b6 10             	movzbl (%eax),%edx
    9385:	8b 45 0c             	mov    0xc(%ebp),%eax
    9388:	0f b6 00             	movzbl (%eax),%eax
    938b:	38 c2                	cmp    %al,%dl
    938d:	75 0a                	jne    9399 <_strcmp_+0x52>
    938f:	8b 45 08             	mov    0x8(%ebp),%eax
    9392:	0f b6 00             	movzbl (%eax),%eax
    9395:	84 c0                	test   %al,%al
    9397:	75 de                	jne    9377 <_strcmp_+0x30>
    }

    return *str1 == *str2;
    9399:	8b 45 08             	mov    0x8(%ebp),%eax
    939c:	0f b6 10             	movzbl (%eax),%edx
    939f:	8b 45 0c             	mov    0xc(%ebp),%eax
    93a2:	0f b6 00             	movzbl (%eax),%eax
    93a5:	38 c2                	cmp    %al,%dl
    93a7:	0f 94 c0             	sete   %al
    93aa:	0f b6 c0             	movzbl %al,%eax
}
    93ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    93b0:	c9                   	leave  
    93b1:	c3                   	ret    

000093b2 <_strlen_>:

uint8_t _strlen_(char* str)
{
    93b2:	55                   	push   %ebp
    93b3:	89 e5                	mov    %esp,%ebp
    93b5:	83 ec 10             	sub    $0x10,%esp
    if (*str == '\000')
    93b8:	8b 45 08             	mov    0x8(%ebp),%eax
    93bb:	0f b6 00             	movzbl (%eax),%eax
    93be:	84 c0                	test   %al,%al
    93c0:	75 07                	jne    93c9 <_strlen_+0x17>
        return 0;
    93c2:	b8 00 00 00 00       	mov    $0x0,%eax
    93c7:	eb 22                	jmp    93eb <_strlen_+0x39>

    uint8_t i = 1;
    93c9:	c6 45 ff 01          	movb   $0x1,-0x1(%ebp)

    while (*str != '\000') {
    93cd:	eb 0e                	jmp    93dd <_strlen_+0x2b>
        str++;
    93cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        i++;
    93d3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    93d7:	83 c0 01             	add    $0x1,%eax
    93da:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (*str != '\000') {
    93dd:	8b 45 08             	mov    0x8(%ebp),%eax
    93e0:	0f b6 00             	movzbl (%eax),%eax
    93e3:	84 c0                	test   %al,%al
    93e5:	75 e8                	jne    93cf <_strlen_+0x1d>
    }

    return i;
    93e7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
    93eb:	c9                   	leave  
    93ec:	c3                   	ret    

000093ed <_strcpy_>:

void* _strcpy_(char* dest, char* src)
{
    93ed:	55                   	push   %ebp
    93ee:	89 e5                	mov    %esp,%ebp
    93f0:	83 ec 10             	sub    $0x10,%esp
    if (dest == NULL)
    93f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    93f7:	75 07                	jne    9400 <_strcpy_+0x13>
        return (void*)NULL;
    93f9:	b8 00 00 00 00       	mov    $0x0,%eax
    93fe:	eb 46                	jmp    9446 <_strcpy_+0x59>

    uint8_t i = 0;
    9400:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    while (src[i] != '\000') {
    9404:	eb 21                	jmp    9427 <_strcpy_+0x3a>
        dest[i] = src[i];
    9406:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    940a:	8b 45 0c             	mov    0xc(%ebp),%eax
    940d:	01 d0                	add    %edx,%eax
    940f:	0f b6 4d ff          	movzbl -0x1(%ebp),%ecx
    9413:	8b 55 08             	mov    0x8(%ebp),%edx
    9416:	01 ca                	add    %ecx,%edx
    9418:	0f b6 00             	movzbl (%eax),%eax
    941b:	88 02                	mov    %al,(%edx)
        i++;
    941d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    9421:	83 c0 01             	add    $0x1,%eax
    9424:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (src[i] != '\000') {
    9427:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    942b:	8b 45 0c             	mov    0xc(%ebp),%eax
    942e:	01 d0                	add    %edx,%eax
    9430:	0f b6 00             	movzbl (%eax),%eax
    9433:	84 c0                	test   %al,%al
    9435:	75 cf                	jne    9406 <_strcpy_+0x19>
    }

    dest[i] = '\000';
    9437:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    943b:	8b 45 08             	mov    0x8(%ebp),%eax
    943e:	01 d0                	add    %edx,%eax
    9440:	c6 00 00             	movb   $0x0,(%eax)

    return (void*)dest;
    9443:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9446:	c9                   	leave  
    9447:	c3                   	ret    

00009448 <memcpy>:

void* memcpy(void* dest, const void* src, uint32_t size)
{
    9448:	55                   	push   %ebp
    9449:	89 e5                	mov    %esp,%ebp
    944b:	83 ec 10             	sub    $0x10,%esp
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    944e:	8b 45 08             	mov    0x8(%ebp),%eax
    9451:	89 45 fc             	mov    %eax,-0x4(%ebp)
    _src_  = (char*)src;
    9454:	8b 45 0c             	mov    0xc(%ebp),%eax
    9457:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (size) {
    945a:	eb 1b                	jmp    9477 <memcpy+0x2f>
        *(_dest_++) = *(_src_++);
    945c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    945f:	8d 42 01             	lea    0x1(%edx),%eax
    9462:	89 45 f8             	mov    %eax,-0x8(%ebp)
    9465:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9468:	8d 48 01             	lea    0x1(%eax),%ecx
    946b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    946e:	0f b6 12             	movzbl (%edx),%edx
    9471:	88 10                	mov    %dl,(%eax)
        size--;
    9473:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (size) {
    9477:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    947b:	75 df                	jne    945c <memcpy+0x14>
    }

    return (void*)dest;
    947d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9480:	c9                   	leave  
    9481:	c3                   	ret    

00009482 <memset>:

void* memset(void* mem, int8_t data, int size)
{
    9482:	55                   	push   %ebp
    9483:	89 e5                	mov    %esp,%ebp
    9485:	83 ec 14             	sub    $0x14,%esp
    9488:	8b 45 0c             	mov    0xc(%ebp),%eax
    948b:	88 45 ec             	mov    %al,-0x14(%ebp)
    int i = 0;
    948e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

    int8_t* tmp = mem;
    9495:	8b 45 08             	mov    0x8(%ebp),%eax
    9498:	89 45 f8             	mov    %eax,-0x8(%ebp)

    for (i; i < size; i++)
    949b:	eb 12                	jmp    94af <memset+0x2d>
        tmp[i] = data;
    949d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    94a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    94a3:	01 c2                	add    %eax,%edx
    94a5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    94a9:	88 02                	mov    %al,(%edx)
    for (i; i < size; i++)
    94ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    94af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    94b2:	3b 45 10             	cmp    0x10(%ebp),%eax
    94b5:	7c e6                	jl     949d <memset+0x1b>

    return (void*)mem;
    94b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    94ba:	c9                   	leave  
    94bb:	c3                   	ret    

000094bc <_memcmp_>:

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    94bc:	55                   	push   %ebp
    94bd:	89 e5                	mov    %esp,%ebp
    94bf:	83 ec 10             	sub    $0x10,%esp
    char* mem_1 = (char*)src_1;
    94c2:	8b 45 08             	mov    0x8(%ebp),%eax
    94c5:	89 45 fc             	mov    %eax,-0x4(%ebp)

    char* mem_2 = (char*)src_2;
    94c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    94cb:	89 45 f8             	mov    %eax,-0x8(%ebp)

    uint32_t i = 0;
    94ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (i < size && *mem_1 == *mem_2) {
    94d5:	eb 0c                	jmp    94e3 <_memcmp_+0x27>
        i++;
    94d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        mem_1++;
    94db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
        mem_2++;
    94df:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (i < size && *mem_1 == *mem_2) {
    94e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    94e6:	3b 45 10             	cmp    0x10(%ebp),%eax
    94e9:	73 10                	jae    94fb <_memcmp_+0x3f>
    94eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    94ee:	0f b6 10             	movzbl (%eax),%edx
    94f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    94f4:	0f b6 00             	movzbl (%eax),%eax
    94f7:	38 c2                	cmp    %al,%dl
    94f9:	74 dc                	je     94d7 <_memcmp_+0x1b>
    }

    return i == size;
    94fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    94fe:	3b 45 10             	cmp    0x10(%ebp),%eax
    9501:	0f 94 c0             	sete   %al
    9504:	0f b6 c0             	movzbl %al,%eax
    9507:	c9                   	leave  
    9508:	c3                   	ret    

00009509 <cclean>:

void move_cursor(uint8_t x, uint8_t y);
void show_cursor(void);

void volatile cclean()
{
    9509:	55                   	push   %ebp
    950a:	89 e5                	mov    %esp,%ebp
    950c:	83 ec 10             	sub    $0x10,%esp
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    950f:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
    int            i      = 0;
    9516:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (i <= 160 * 25) {
    951d:	eb 1d                	jmp    953c <cclean+0x33>
        screen[i]     = ' ';
    951f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    9522:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9525:	01 d0                	add    %edx,%eax
    9527:	c6 00 20             	movb   $0x20,(%eax)
        screen[i + 1] = 0x0;
    952a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    952d:	8d 50 01             	lea    0x1(%eax),%edx
    9530:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9533:	01 d0                	add    %edx,%eax
    9535:	c6 00 00             	movb   $0x0,(%eax)
        i += 2;
    9538:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    while (i <= 160 * 25) {
    953c:	81 7d fc a0 0f 00 00 	cmpl   $0xfa0,-0x4(%ebp)
    9543:	7e da                	jle    951f <cclean+0x16>
    }

    CURSOR_X = 0;
    9545:	c7 05 0c 00 01 00 00 	movl   $0x0,0x1000c
    954c:	00 00 00 
    CURSOR_Y = 0;
    954f:	c7 05 08 00 01 00 00 	movl   $0x0,0x10008
    9556:	00 00 00 
}
    9559:	90                   	nop
    955a:	c9                   	leave  
    955b:	c3                   	ret    

0000955c <cscrollup>:

void volatile cscrollup()
{
    955c:	55                   	push   %ebp
    955d:	89 e5                	mov    %esp,%ebp
    955f:	81 ec b0 00 00 00    	sub    $0xb0,%esp
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    9565:	c7 45 f8 00 8f 0b 00 	movl   $0xb8f00,-0x8(%ebp)
    unsigned char  b[160];
    int            i;
    for (i = 0; i < 160; i++)
    956c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    9573:	eb 1c                	jmp    9591 <cscrollup+0x35>
        b[i] = v[i];
    9575:	8b 55 fc             	mov    -0x4(%ebp),%edx
    9578:	8b 45 f8             	mov    -0x8(%ebp),%eax
    957b:	01 d0                	add    %edx,%eax
    957d:	0f b6 00             	movzbl (%eax),%eax
    9580:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    9586:	8b 55 fc             	mov    -0x4(%ebp),%edx
    9589:	01 ca                	add    %ecx,%edx
    958b:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    958d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    9591:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    9598:	7e db                	jle    9575 <cscrollup+0x19>

    cclean();
    959a:	e8 6a ff ff ff       	call   9509 <cclean>

    v = (unsigned char*)(VIDEO_MEM);
    959f:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)

    for (i = 0; i < 160; i++)
    95a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    95ad:	eb 1c                	jmp    95cb <cscrollup+0x6f>
        v[i] = b[i];
    95af:	8b 55 fc             	mov    -0x4(%ebp),%edx
    95b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    95b5:	01 c2                	add    %eax,%edx
    95b7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    95bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    95c0:	01 c8                	add    %ecx,%eax
    95c2:	0f b6 00             	movzbl (%eax),%eax
    95c5:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    95c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    95cb:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    95d2:	7e db                	jle    95af <cscrollup+0x53>

    CURSOR_Y++;
    95d4:	a1 08 00 01 00       	mov    0x10008,%eax
    95d9:	83 c0 01             	add    $0x1,%eax
    95dc:	a3 08 00 01 00       	mov    %eax,0x10008
}
    95e1:	90                   	nop
    95e2:	c9                   	leave  
    95e3:	c3                   	ret    

000095e4 <cputchar>:

void volatile cputchar(char color, const char c)
{
    95e4:	55                   	push   %ebp
    95e5:	89 e5                	mov    %esp,%ebp
    95e7:	83 ec 18             	sub    $0x18,%esp
    95ea:	8b 55 08             	mov    0x8(%ebp),%edx
    95ed:	8b 45 0c             	mov    0xc(%ebp),%eax
    95f0:	88 55 ec             	mov    %dl,-0x14(%ebp)
    95f3:	88 45 e8             	mov    %al,-0x18(%ebp)

    if ((CURSOR_Y) <= (25)) {
    95f6:	a1 08 00 01 00       	mov    0x10008,%eax
    95fb:	83 f8 19             	cmp    $0x19,%eax
    95fe:	0f 8f c0 00 00 00    	jg     96c4 <cputchar+0xe0>
        if (c == '\n') {
    9604:	80 7d e8 0a          	cmpb   $0xa,-0x18(%ebp)
    9608:	75 1c                	jne    9626 <cputchar+0x42>
            CURSOR_X = 0;
    960a:	c7 05 0c 00 01 00 00 	movl   $0x0,0x1000c
    9611:	00 00 00 
            CURSOR_Y++;
    9614:	a1 08 00 01 00       	mov    0x10008,%eax
    9619:	83 c0 01             	add    $0x1,%eax
    961c:	a3 08 00 01 00       	mov    %eax,0x10008
        }
    }

    else
        cclean();
}
    9621:	e9 a3 00 00 00       	jmp    96c9 <cputchar+0xe5>
        else if (c == '\t')
    9626:	80 7d e8 09          	cmpb   $0x9,-0x18(%ebp)
    962a:	75 12                	jne    963e <cputchar+0x5a>
            CURSOR_X += 5;
    962c:	a1 0c 00 01 00       	mov    0x1000c,%eax
    9631:	83 c0 05             	add    $0x5,%eax
    9634:	a3 0c 00 01 00       	mov    %eax,0x1000c
}
    9639:	e9 8b 00 00 00       	jmp    96c9 <cputchar+0xe5>
        else if (c == 0x08)
    963e:	80 7d e8 08          	cmpb   $0x8,-0x18(%ebp)
    9642:	75 3a                	jne    967e <cputchar+0x9a>
            CURSOR_X--;
    9644:	a1 0c 00 01 00       	mov    0x1000c,%eax
    9649:	83 e8 01             	sub    $0x1,%eax
    964c:	a3 0c 00 01 00       	mov    %eax,0x1000c
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9651:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    9658:	8b 15 08 00 01 00    	mov    0x10008,%edx
    965e:	89 d0                	mov    %edx,%eax
    9660:	c1 e0 02             	shl    $0x2,%eax
    9663:	01 d0                	add    %edx,%eax
    9665:	c1 e0 04             	shl    $0x4,%eax
    9668:	89 c2                	mov    %eax,%edx
    966a:	a1 0c 00 01 00       	mov    0x1000c,%eax
    966f:	01 d0                	add    %edx,%eax
    9671:	01 c0                	add    %eax,%eax
    9673:	01 45 f8             	add    %eax,-0x8(%ebp)
            *v = ' ';
    9676:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9679:	c6 00 20             	movb   $0x20,(%eax)
}
    967c:	eb 4b                	jmp    96c9 <cputchar+0xe5>
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    967e:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    9685:	8b 15 08 00 01 00    	mov    0x10008,%edx
    968b:	89 d0                	mov    %edx,%eax
    968d:	c1 e0 02             	shl    $0x2,%eax
    9690:	01 d0                	add    %edx,%eax
    9692:	c1 e0 04             	shl    $0x4,%eax
    9695:	89 c2                	mov    %eax,%edx
    9697:	a1 0c 00 01 00       	mov    0x1000c,%eax
    969c:	01 d0                	add    %edx,%eax
    969e:	01 c0                	add    %eax,%eax
    96a0:	01 45 fc             	add    %eax,-0x4(%ebp)
            *v = c;
    96a3:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    96a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    96aa:	88 10                	mov    %dl,(%eax)
            *(v + 1) = READY_COLOR;
    96ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    96af:	83 c0 01             	add    $0x1,%eax
    96b2:	c6 00 07             	movb   $0x7,(%eax)
            CURSOR_X++;
    96b5:	a1 0c 00 01 00       	mov    0x1000c,%eax
    96ba:	83 c0 01             	add    $0x1,%eax
    96bd:	a3 0c 00 01 00       	mov    %eax,0x1000c
}
    96c2:	eb 05                	jmp    96c9 <cputchar+0xe5>
        cclean();
    96c4:	e8 40 fe ff ff       	call   9509 <cclean>
}
    96c9:	90                   	nop
    96ca:	c9                   	leave  
    96cb:	c3                   	ret    

000096cc <move_cursor>:

void move_cursor(uint8_t x, uint8_t y)
{
    96cc:	55                   	push   %ebp
    96cd:	89 e5                	mov    %esp,%ebp
    96cf:	83 ec 18             	sub    $0x18,%esp
    96d2:	8b 55 08             	mov    0x8(%ebp),%edx
    96d5:	8b 45 0c             	mov    0xc(%ebp),%eax
    96d8:	88 55 ec             	mov    %dl,-0x14(%ebp)
    96db:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t c_pos;

    c_pos = y * 80 + x;
    96de:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    96e2:	89 d0                	mov    %edx,%eax
    96e4:	c1 e0 02             	shl    $0x2,%eax
    96e7:	01 d0                	add    %edx,%eax
    96e9:	c1 e0 04             	shl    $0x4,%eax
    96ec:	89 c2                	mov    %eax,%edx
    96ee:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    96f2:	01 d0                	add    %edx,%eax
    96f4:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    outb(0x3d4, 0x0f);
    96f8:	ba d4 03 00 00       	mov    $0x3d4,%edx
    96fd:	b8 0f 00 00 00       	mov    $0xf,%eax
    9702:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)c_pos);
    9703:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    9707:	ba d5 03 00 00       	mov    $0x3d5,%edx
    970c:	ee                   	out    %al,(%dx)
    outb(0x3d4, 0x0e);
    970d:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9712:	b8 0e 00 00 00       	mov    $0xe,%eax
    9717:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)(c_pos >> 8));
    9718:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    971c:	66 c1 e8 08          	shr    $0x8,%ax
    9720:	ba d5 03 00 00       	mov    $0x3d5,%edx
    9725:	ee                   	out    %al,(%dx)
}
    9726:	90                   	nop
    9727:	c9                   	leave  
    9728:	c3                   	ret    

00009729 <show_cursor>:

void show_cursor(void)
{
    9729:	55                   	push   %ebp
    972a:	89 e5                	mov    %esp,%ebp
    move_cursor(CURSOR_X, CURSOR_Y);
    972c:	a1 08 00 01 00       	mov    0x10008,%eax
    9731:	0f b6 d0             	movzbl %al,%edx
    9734:	a1 0c 00 01 00       	mov    0x1000c,%eax
    9739:	0f b6 c0             	movzbl %al,%eax
    973c:	52                   	push   %edx
    973d:	50                   	push   %eax
    973e:	e8 89 ff ff ff       	call   96cc <move_cursor>
    9743:	83 c4 08             	add    $0x8,%esp
}
    9746:	90                   	nop
    9747:	c9                   	leave  
    9748:	c3                   	ret    

00009749 <console_service_keyboard>:

void console_service_keyboard()
{
    9749:	55                   	push   %ebp
    974a:	89 e5                	mov    %esp,%ebp
    974c:	83 ec 08             	sub    $0x8,%esp
    if (get_ASCII_code_keyboard() != 0) {
    974f:	e8 ff 0a 00 00       	call   a253 <get_ASCII_code_keyboard>
    9754:	84 c0                	test   %al,%al
    9756:	74 1b                	je     9773 <console_service_keyboard+0x2a>
        cputchar(READY_COLOR, get_ASCII_code_keyboard());
    9758:	e8 f6 0a 00 00       	call   a253 <get_ASCII_code_keyboard>
    975d:	0f be c0             	movsbl %al,%eax
    9760:	83 ec 08             	sub    $0x8,%esp
    9763:	50                   	push   %eax
    9764:	6a 07                	push   $0x7
    9766:	e8 79 fe ff ff       	call   95e4 <cputchar>
    976b:	83 c4 10             	add    $0x10,%esp
        show_cursor();
    976e:	e8 b6 ff ff ff       	call   9729 <show_cursor>
    }
}
    9773:	90                   	nop
    9774:	c9                   	leave  
    9775:	c3                   	ret    

00009776 <init_console>:

void init_console()
{
    9776:	55                   	push   %ebp
    9777:	89 e5                	mov    %esp,%ebp
    9779:	83 ec 08             	sub    $0x8,%esp
    cclean();
    977c:	e8 88 fd ff ff       	call   9509 <cclean>
    kbd_init(); //Init keyboard
    9781:	e8 b0 08 00 00       	call   a036 <kbd_init>
    //init Video graphics here
    9786:	90                   	nop
    9787:	c9                   	leave  
    9788:	c3                   	ret    

00009789 <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    9789:	55                   	push   %ebp
    978a:	89 e5                	mov    %esp,%ebp
    978c:	90                   	nop
    978d:	5d                   	pop    %ebp
    978e:	c3                   	ret    

0000978f <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    978f:	55                   	push   %ebp
    9790:	89 e5                	mov    %esp,%ebp
    9792:	90                   	nop
    9793:	5d                   	pop    %ebp
    9794:	c3                   	ret    

00009795 <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    9795:	55                   	push   %ebp
    9796:	89 e5                	mov    %esp,%ebp
    9798:	83 ec 08             	sub    $0x8,%esp
    979b:	8b 55 10             	mov    0x10(%ebp),%edx
    979e:	8b 45 14             	mov    0x14(%ebp),%eax
    97a1:	88 55 fc             	mov    %dl,-0x4(%ebp)
    97a4:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15  = (limite & 0xFFFF);
    97a7:	8b 45 0c             	mov    0xc(%ebp),%eax
    97aa:	89 c2                	mov    %eax,%edx
    97ac:	8b 45 18             	mov    0x18(%ebp),%eax
    97af:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    97b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    97b5:	c1 e8 10             	shr    $0x10,%eax
    97b8:	83 e0 0f             	and    $0xf,%eax
    97bb:	8b 55 18             	mov    0x18(%ebp),%edx
    97be:	83 e0 0f             	and    $0xf,%eax
    97c1:	89 c1                	mov    %eax,%ecx
    97c3:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    97c7:	83 e0 f0             	and    $0xfffffff0,%eax
    97ca:	09 c8                	or     %ecx,%eax
    97cc:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15  = (base & 0xFFFF);
    97cf:	8b 45 08             	mov    0x8(%ebp),%eax
    97d2:	89 c2                	mov    %eax,%edx
    97d4:	8b 45 18             	mov    0x18(%ebp),%eax
    97d7:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    97db:	8b 45 08             	mov    0x8(%ebp),%eax
    97de:	c1 e8 10             	shr    $0x10,%eax
    97e1:	89 c2                	mov    %eax,%edx
    97e3:	8b 45 18             	mov    0x18(%ebp),%eax
    97e6:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    97e9:	8b 45 08             	mov    0x8(%ebp),%eax
    97ec:	c1 e8 18             	shr    $0x18,%eax
    97ef:	89 c2                	mov    %eax,%edx
    97f1:	8b 45 18             	mov    0x18(%ebp),%eax
    97f4:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags      = flags;
    97f7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    97fb:	83 e0 0f             	and    $0xf,%eax
    97fe:	89 c2                	mov    %eax,%edx
    9800:	8b 45 18             	mov    0x18(%ebp),%eax
    9803:	89 d1                	mov    %edx,%ecx
    9805:	c1 e1 04             	shl    $0x4,%ecx
    9808:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    980c:	83 e2 0f             	and    $0xf,%edx
    980f:	09 ca                	or     %ecx,%edx
    9811:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    9814:	8b 45 18             	mov    0x18(%ebp),%eax
    9817:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    981b:	88 50 05             	mov    %dl,0x5(%eax)
}
    981e:	90                   	nop
    981f:	c9                   	leave  
    9820:	c3                   	ret    

00009821 <init_gdt>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt(void)
{
    9821:	55                   	push   %ebp
    9822:	89 e5                	mov    %esp,%ebp
    9824:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    9827:	a1 10 00 01 00       	mov    0x10010,%eax
    982c:	50                   	push   %eax
    982d:	6a 00                	push   $0x0
    982f:	6a 00                	push   $0x0
    9831:	6a 00                	push   $0x0
    9833:	6a 00                	push   $0x0
    9835:	e8 5b ff ff ff       	call   9795 <init_gdt_entry>
    983a:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    983d:	a1 10 00 01 00       	mov    0x10010,%eax
    9842:	83 c0 08             	add    $0x8,%eax
    9845:	50                   	push   %eax
    9846:	6a 04                	push   $0x4
    9848:	68 9a 00 00 00       	push   $0x9a
    984d:	68 ff ff 0f 00       	push   $0xfffff
    9852:	6a 00                	push   $0x0
    9854:	e8 3c ff ff ff       	call   9795 <init_gdt_entry>
    9859:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    985c:	a1 10 00 01 00       	mov    0x10010,%eax
    9861:	83 c0 10             	add    $0x10,%eax
    9864:	50                   	push   %eax
    9865:	6a 04                	push   $0x4
    9867:	68 92 00 00 00       	push   $0x92
    986c:	68 ff ff 0f 00       	push   $0xfffff
    9871:	6a 00                	push   $0x0
    9873:	e8 1d ff ff ff       	call   9795 <init_gdt_entry>
    9878:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    987b:	a1 10 00 01 00       	mov    0x10010,%eax
    9880:	83 c0 18             	add    $0x18,%eax
    9883:	50                   	push   %eax
    9884:	6a 04                	push   $0x4
    9886:	68 96 00 00 00       	push   $0x96
    988b:	68 ff ff 0f 00       	push   $0xfffff
    9890:	6a 00                	push   $0x0
    9892:	e8 fe fe ff ff       	call   9795 <init_gdt_entry>
    9897:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Chargement de la GDT
    load_gdt();
    989a:	e8 b7 1a 00 00       	call   b356 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    989f:	66 b8 10 00          	mov    $0x10,%ax
    98a3:	8e d8                	mov    %eax,%ds
    98a5:	8e c0                	mov    %eax,%es
    98a7:	8e e0                	mov    %eax,%fs
    98a9:	8e e8                	mov    %eax,%gs
    98ab:	66 b8 18 00          	mov    $0x18,%ax
    98af:	8e d0                	mov    %eax,%ss
    98b1:	ea b8 98 00 00 08 00 	ljmp   $0x8,$0x98b8

000098b8 <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    98b8:	90                   	nop
    98b9:	c9                   	leave  
    98ba:	c3                   	ret    

000098bb <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    98bb:	55                   	push   %ebp
    98bc:	89 e5                	mov    %esp,%ebp
    98be:	83 ec 18             	sub    $0x18,%esp
    98c1:	8b 45 08             	mov    0x8(%ebp),%eax
    98c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    98c7:	8b 55 18             	mov    0x18(%ebp),%edx
    98ca:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    98ce:	89 c8                	mov    %ecx,%eax
    98d0:	88 45 f8             	mov    %al,-0x8(%ebp)
    98d3:	8b 45 10             	mov    0x10(%ebp),%eax
    98d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    98d9:	8b 45 14             	mov    0x14(%ebp),%eax
    98dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    98df:	89 d0                	mov    %edx,%eax
    98e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    98e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    98e9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    98ed:	66 89 14 c5 22 00 01 	mov    %dx,0x10022(,%eax,8)
    98f4:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    98f5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    98f9:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    98fd:	88 14 c5 25 00 01 00 	mov    %dl,0x10025(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    9904:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9908:	c6 04 c5 24 00 01 00 	movb   $0x0,0x10024(,%eax,8)
    990f:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    9910:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9914:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9917:	66 89 14 c5 20 00 01 	mov    %dx,0x10020(,%eax,8)
    991e:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    991f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9922:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9925:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    9929:	c1 ea 10             	shr    $0x10,%edx
    992c:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    9930:	66 89 04 cd 26 00 01 	mov    %ax,0x10026(,%ecx,8)
    9937:	00 
}
    9938:	90                   	nop
    9939:	c9                   	leave  
    993a:	c3                   	ret    

0000993b <init_idt>:

void init_idt()
{
    993b:	55                   	push   %ebp
    993c:	89 e5                	mov    %esp,%ebp
    993e:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    9941:	83 ec 0c             	sub    $0xc,%esp
    9944:	68 ad da 00 00       	push   $0xdaad
    9949:	e8 12 0e 00 00       	call   a760 <Init_PIT>
    994e:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    9951:	83 ec 08             	sub    $0x8,%esp
    9954:	6a 28                	push   $0x28
    9956:	6a 20                	push   $0x20
    9958:	e8 16 0b 00 00       	call   a473 <PIC_remap>
    995d:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    9960:	b8 70 b4 00 00       	mov    $0xb470,%eax
    9965:	ba 00 00 00 00       	mov    $0x0,%edx
    996a:	83 ec 0c             	sub    $0xc,%esp
    996d:	6a 20                	push   $0x20
    996f:	52                   	push   %edx
    9970:	50                   	push   %eax
    9971:	68 8e 00 00 00       	push   $0x8e
    9976:	6a 08                	push   $0x8
    9978:	e8 3e ff ff ff       	call   98bb <set_idt>
    997d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    9980:	b8 c0 b3 00 00       	mov    $0xb3c0,%eax
    9985:	ba 00 00 00 00       	mov    $0x0,%edx
    998a:	83 ec 0c             	sub    $0xc,%esp
    998d:	6a 21                	push   $0x21
    998f:	52                   	push   %edx
    9990:	50                   	push   %eax
    9991:	68 8e 00 00 00       	push   $0x8e
    9996:	6a 08                	push   $0x8
    9998:	e8 1e ff ff ff       	call   98bb <set_idt>
    999d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    99a0:	b8 c8 b3 00 00       	mov    $0xb3c8,%eax
    99a5:	ba 00 00 00 00       	mov    $0x0,%edx
    99aa:	83 ec 0c             	sub    $0xc,%esp
    99ad:	6a 22                	push   $0x22
    99af:	52                   	push   %edx
    99b0:	50                   	push   %eax
    99b1:	68 8e 00 00 00       	push   $0x8e
    99b6:	6a 08                	push   $0x8
    99b8:	e8 fe fe ff ff       	call   98bb <set_idt>
    99bd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    99c0:	b8 d0 b3 00 00       	mov    $0xb3d0,%eax
    99c5:	ba 00 00 00 00       	mov    $0x0,%edx
    99ca:	83 ec 0c             	sub    $0xc,%esp
    99cd:	6a 23                	push   $0x23
    99cf:	52                   	push   %edx
    99d0:	50                   	push   %eax
    99d1:	68 8e 00 00 00       	push   $0x8e
    99d6:	6a 08                	push   $0x8
    99d8:	e8 de fe ff ff       	call   98bb <set_idt>
    99dd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    99e0:	b8 d8 b3 00 00       	mov    $0xb3d8,%eax
    99e5:	ba 00 00 00 00       	mov    $0x0,%edx
    99ea:	83 ec 0c             	sub    $0xc,%esp
    99ed:	6a 24                	push   $0x24
    99ef:	52                   	push   %edx
    99f0:	50                   	push   %eax
    99f1:	68 8e 00 00 00       	push   $0x8e
    99f6:	6a 08                	push   $0x8
    99f8:	e8 be fe ff ff       	call   98bb <set_idt>
    99fd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    9a00:	b8 e0 b3 00 00       	mov    $0xb3e0,%eax
    9a05:	ba 00 00 00 00       	mov    $0x0,%edx
    9a0a:	83 ec 0c             	sub    $0xc,%esp
    9a0d:	6a 25                	push   $0x25
    9a0f:	52                   	push   %edx
    9a10:	50                   	push   %eax
    9a11:	68 8e 00 00 00       	push   $0x8e
    9a16:	6a 08                	push   $0x8
    9a18:	e8 9e fe ff ff       	call   98bb <set_idt>
    9a1d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    9a20:	b8 e8 b3 00 00       	mov    $0xb3e8,%eax
    9a25:	ba 00 00 00 00       	mov    $0x0,%edx
    9a2a:	83 ec 0c             	sub    $0xc,%esp
    9a2d:	6a 26                	push   $0x26
    9a2f:	52                   	push   %edx
    9a30:	50                   	push   %eax
    9a31:	68 8e 00 00 00       	push   $0x8e
    9a36:	6a 08                	push   $0x8
    9a38:	e8 7e fe ff ff       	call   98bb <set_idt>
    9a3d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    9a40:	b8 f0 b3 00 00       	mov    $0xb3f0,%eax
    9a45:	ba 00 00 00 00       	mov    $0x0,%edx
    9a4a:	83 ec 0c             	sub    $0xc,%esp
    9a4d:	6a 27                	push   $0x27
    9a4f:	52                   	push   %edx
    9a50:	50                   	push   %eax
    9a51:	68 8e 00 00 00       	push   $0x8e
    9a56:	6a 08                	push   $0x8
    9a58:	e8 5e fe ff ff       	call   98bb <set_idt>
    9a5d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    9a60:	b8 f8 b3 00 00       	mov    $0xb3f8,%eax
    9a65:	ba 00 00 00 00       	mov    $0x0,%edx
    9a6a:	83 ec 0c             	sub    $0xc,%esp
    9a6d:	6a 28                	push   $0x28
    9a6f:	52                   	push   %edx
    9a70:	50                   	push   %eax
    9a71:	68 8e 00 00 00       	push   $0x8e
    9a76:	6a 08                	push   $0x8
    9a78:	e8 3e fe ff ff       	call   98bb <set_idt>
    9a7d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    9a80:	b8 00 b4 00 00       	mov    $0xb400,%eax
    9a85:	ba 00 00 00 00       	mov    $0x0,%edx
    9a8a:	83 ec 0c             	sub    $0xc,%esp
    9a8d:	6a 29                	push   $0x29
    9a8f:	52                   	push   %edx
    9a90:	50                   	push   %eax
    9a91:	68 8e 00 00 00       	push   $0x8e
    9a96:	6a 08                	push   $0x8
    9a98:	e8 1e fe ff ff       	call   98bb <set_idt>
    9a9d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    9aa0:	b8 08 b4 00 00       	mov    $0xb408,%eax
    9aa5:	ba 00 00 00 00       	mov    $0x0,%edx
    9aaa:	83 ec 0c             	sub    $0xc,%esp
    9aad:	6a 2a                	push   $0x2a
    9aaf:	52                   	push   %edx
    9ab0:	50                   	push   %eax
    9ab1:	68 8e 00 00 00       	push   $0x8e
    9ab6:	6a 08                	push   $0x8
    9ab8:	e8 fe fd ff ff       	call   98bb <set_idt>
    9abd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    9ac0:	b8 10 b4 00 00       	mov    $0xb410,%eax
    9ac5:	ba 00 00 00 00       	mov    $0x0,%edx
    9aca:	83 ec 0c             	sub    $0xc,%esp
    9acd:	6a 2b                	push   $0x2b
    9acf:	52                   	push   %edx
    9ad0:	50                   	push   %eax
    9ad1:	68 8e 00 00 00       	push   $0x8e
    9ad6:	6a 08                	push   $0x8
    9ad8:	e8 de fd ff ff       	call   98bb <set_idt>
    9add:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    9ae0:	b8 18 b4 00 00       	mov    $0xb418,%eax
    9ae5:	ba 00 00 00 00       	mov    $0x0,%edx
    9aea:	83 ec 0c             	sub    $0xc,%esp
    9aed:	6a 2c                	push   $0x2c
    9aef:	52                   	push   %edx
    9af0:	50                   	push   %eax
    9af1:	68 8e 00 00 00       	push   $0x8e
    9af6:	6a 08                	push   $0x8
    9af8:	e8 be fd ff ff       	call   98bb <set_idt>
    9afd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    9b00:	b8 20 b4 00 00       	mov    $0xb420,%eax
    9b05:	ba 00 00 00 00       	mov    $0x0,%edx
    9b0a:	83 ec 0c             	sub    $0xc,%esp
    9b0d:	6a 2d                	push   $0x2d
    9b0f:	52                   	push   %edx
    9b10:	50                   	push   %eax
    9b11:	68 8e 00 00 00       	push   $0x8e
    9b16:	6a 08                	push   $0x8
    9b18:	e8 9e fd ff ff       	call   98bb <set_idt>
    9b1d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    9b20:	b8 28 b4 00 00       	mov    $0xb428,%eax
    9b25:	ba 00 00 00 00       	mov    $0x0,%edx
    9b2a:	83 ec 0c             	sub    $0xc,%esp
    9b2d:	6a 2e                	push   $0x2e
    9b2f:	52                   	push   %edx
    9b30:	50                   	push   %eax
    9b31:	68 8e 00 00 00       	push   $0x8e
    9b36:	6a 08                	push   $0x8
    9b38:	e8 7e fd ff ff       	call   98bb <set_idt>
    9b3d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    9b40:	b8 30 b4 00 00       	mov    $0xb430,%eax
    9b45:	ba 00 00 00 00       	mov    $0x0,%edx
    9b4a:	83 ec 0c             	sub    $0xc,%esp
    9b4d:	6a 2f                	push   $0x2f
    9b4f:	52                   	push   %edx
    9b50:	50                   	push   %eax
    9b51:	68 8e 00 00 00       	push   $0x8e
    9b56:	6a 08                	push   $0x8
    9b58:	e8 5e fd ff ff       	call   98bb <set_idt>
    9b5d:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    9b60:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9b65:	ba 00 00 00 00       	mov    $0x0,%edx
    9b6a:	83 ec 0c             	sub    $0xc,%esp
    9b6d:	6a 08                	push   $0x8
    9b6f:	52                   	push   %edx
    9b70:	50                   	push   %eax
    9b71:	68 8e 00 00 00       	push   $0x8e
    9b76:	6a 08                	push   $0x8
    9b78:	e8 3e fd ff ff       	call   98bb <set_idt>
    9b7d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    9b80:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9b85:	ba 00 00 00 00       	mov    $0x0,%edx
    9b8a:	83 ec 0c             	sub    $0xc,%esp
    9b8d:	6a 0a                	push   $0xa
    9b8f:	52                   	push   %edx
    9b90:	50                   	push   %eax
    9b91:	68 8e 00 00 00       	push   $0x8e
    9b96:	6a 08                	push   $0x8
    9b98:	e8 1e fd ff ff       	call   98bb <set_idt>
    9b9d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    9ba0:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9ba5:	ba 00 00 00 00       	mov    $0x0,%edx
    9baa:	83 ec 0c             	sub    $0xc,%esp
    9bad:	6a 0b                	push   $0xb
    9baf:	52                   	push   %edx
    9bb0:	50                   	push   %eax
    9bb1:	68 8e 00 00 00       	push   $0x8e
    9bb6:	6a 08                	push   $0x8
    9bb8:	e8 fe fc ff ff       	call   98bb <set_idt>
    9bbd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9bc0:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9bc5:	ba 00 00 00 00       	mov    $0x0,%edx
    9bca:	83 ec 0c             	sub    $0xc,%esp
    9bcd:	6a 0c                	push   $0xc
    9bcf:	52                   	push   %edx
    9bd0:	50                   	push   %eax
    9bd1:	68 8e 00 00 00       	push   $0x8e
    9bd6:	6a 08                	push   $0x8
    9bd8:	e8 de fc ff ff       	call   98bb <set_idt>
    9bdd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9be0:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9be5:	ba 00 00 00 00       	mov    $0x0,%edx
    9bea:	83 ec 0c             	sub    $0xc,%esp
    9bed:	6a 0d                	push   $0xd
    9bef:	52                   	push   %edx
    9bf0:	50                   	push   %eax
    9bf1:	68 8e 00 00 00       	push   $0x8e
    9bf6:	6a 08                	push   $0x8
    9bf8:	e8 be fc ff ff       	call   98bb <set_idt>
    9bfd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    9c00:	b8 42 a4 00 00       	mov    $0xa442,%eax
    9c05:	ba 00 00 00 00       	mov    $0x0,%edx
    9c0a:	83 ec 0c             	sub    $0xc,%esp
    9c0d:	6a 0e                	push   $0xe
    9c0f:	52                   	push   %edx
    9c10:	50                   	push   %eax
    9c11:	68 8e 00 00 00       	push   $0x8e
    9c16:	6a 08                	push   $0x8
    9c18:	e8 9e fc ff ff       	call   98bb <set_idt>
    9c1d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    9c20:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9c25:	ba 00 00 00 00       	mov    $0x0,%edx
    9c2a:	83 ec 0c             	sub    $0xc,%esp
    9c2d:	6a 11                	push   $0x11
    9c2f:	52                   	push   %edx
    9c30:	50                   	push   %eax
    9c31:	68 8e 00 00 00       	push   $0x8e
    9c36:	6a 08                	push   $0x8
    9c38:	e8 7e fc ff ff       	call   98bb <set_idt>
    9c3d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    9c40:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9c45:	ba 00 00 00 00       	mov    $0x0,%edx
    9c4a:	83 ec 0c             	sub    $0xc,%esp
    9c4d:	6a 1e                	push   $0x1e
    9c4f:	52                   	push   %edx
    9c50:	50                   	push   %eax
    9c51:	68 8e 00 00 00       	push   $0x8e
    9c56:	6a 08                	push   $0x8
    9c58:	e8 5e fc ff ff       	call   98bb <set_idt>
    9c5d:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9c60:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9c65:	ba 00 00 00 00       	mov    $0x0,%edx
    9c6a:	83 ec 0c             	sub    $0xc,%esp
    9c6d:	6a 00                	push   $0x0
    9c6f:	52                   	push   %edx
    9c70:	50                   	push   %eax
    9c71:	68 8e 00 00 00       	push   $0x8e
    9c76:	6a 08                	push   $0x8
    9c78:	e8 3e fc ff ff       	call   98bb <set_idt>
    9c7d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9c80:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9c85:	ba 00 00 00 00       	mov    $0x0,%edx
    9c8a:	83 ec 0c             	sub    $0xc,%esp
    9c8d:	6a 01                	push   $0x1
    9c8f:	52                   	push   %edx
    9c90:	50                   	push   %eax
    9c91:	68 8e 00 00 00       	push   $0x8e
    9c96:	6a 08                	push   $0x8
    9c98:	e8 1e fc ff ff       	call   98bb <set_idt>
    9c9d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9ca0:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9ca5:	ba 00 00 00 00       	mov    $0x0,%edx
    9caa:	83 ec 0c             	sub    $0xc,%esp
    9cad:	6a 02                	push   $0x2
    9caf:	52                   	push   %edx
    9cb0:	50                   	push   %eax
    9cb1:	68 8e 00 00 00       	push   $0x8e
    9cb6:	6a 08                	push   $0x8
    9cb8:	e8 fe fb ff ff       	call   98bb <set_idt>
    9cbd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9cc0:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9cc5:	ba 00 00 00 00       	mov    $0x0,%edx
    9cca:	83 ec 0c             	sub    $0xc,%esp
    9ccd:	6a 03                	push   $0x3
    9ccf:	52                   	push   %edx
    9cd0:	50                   	push   %eax
    9cd1:	68 8e 00 00 00       	push   $0x8e
    9cd6:	6a 08                	push   $0x8
    9cd8:	e8 de fb ff ff       	call   98bb <set_idt>
    9cdd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9ce0:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9ce5:	ba 00 00 00 00       	mov    $0x0,%edx
    9cea:	83 ec 0c             	sub    $0xc,%esp
    9ced:	6a 04                	push   $0x4
    9cef:	52                   	push   %edx
    9cf0:	50                   	push   %eax
    9cf1:	68 8e 00 00 00       	push   $0x8e
    9cf6:	6a 08                	push   $0x8
    9cf8:	e8 be fb ff ff       	call   98bb <set_idt>
    9cfd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    9d00:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9d05:	ba 00 00 00 00       	mov    $0x0,%edx
    9d0a:	83 ec 0c             	sub    $0xc,%esp
    9d0d:	6a 05                	push   $0x5
    9d0f:	52                   	push   %edx
    9d10:	50                   	push   %eax
    9d11:	68 8e 00 00 00       	push   $0x8e
    9d16:	6a 08                	push   $0x8
    9d18:	e8 9e fb ff ff       	call   98bb <set_idt>
    9d1d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    9d20:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9d25:	ba 00 00 00 00       	mov    $0x0,%edx
    9d2a:	83 ec 0c             	sub    $0xc,%esp
    9d2d:	6a 06                	push   $0x6
    9d2f:	52                   	push   %edx
    9d30:	50                   	push   %eax
    9d31:	68 8e 00 00 00       	push   $0x8e
    9d36:	6a 08                	push   $0x8
    9d38:	e8 7e fb ff ff       	call   98bb <set_idt>
    9d3d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    9d40:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9d45:	ba 00 00 00 00       	mov    $0x0,%edx
    9d4a:	83 ec 0c             	sub    $0xc,%esp
    9d4d:	6a 07                	push   $0x7
    9d4f:	52                   	push   %edx
    9d50:	50                   	push   %eax
    9d51:	68 8e 00 00 00       	push   $0x8e
    9d56:	6a 08                	push   $0x8
    9d58:	e8 5e fb ff ff       	call   98bb <set_idt>
    9d5d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9d60:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9d65:	ba 00 00 00 00       	mov    $0x0,%edx
    9d6a:	83 ec 0c             	sub    $0xc,%esp
    9d6d:	6a 09                	push   $0x9
    9d6f:	52                   	push   %edx
    9d70:	50                   	push   %eax
    9d71:	68 8e 00 00 00       	push   $0x8e
    9d76:	6a 08                	push   $0x8
    9d78:	e8 3e fb ff ff       	call   98bb <set_idt>
    9d7d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9d80:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9d85:	ba 00 00 00 00       	mov    $0x0,%edx
    9d8a:	83 ec 0c             	sub    $0xc,%esp
    9d8d:	6a 10                	push   $0x10
    9d8f:	52                   	push   %edx
    9d90:	50                   	push   %eax
    9d91:	68 8e 00 00 00       	push   $0x8e
    9d96:	6a 08                	push   $0x8
    9d98:	e8 1e fb ff ff       	call   98bb <set_idt>
    9d9d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9da0:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9da5:	ba 00 00 00 00       	mov    $0x0,%edx
    9daa:	83 ec 0c             	sub    $0xc,%esp
    9dad:	6a 12                	push   $0x12
    9daf:	52                   	push   %edx
    9db0:	50                   	push   %eax
    9db1:	68 8e 00 00 00       	push   $0x8e
    9db6:	6a 08                	push   $0x8
    9db8:	e8 fe fa ff ff       	call   98bb <set_idt>
    9dbd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9dc0:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9dc5:	ba 00 00 00 00       	mov    $0x0,%edx
    9dca:	83 ec 0c             	sub    $0xc,%esp
    9dcd:	6a 13                	push   $0x13
    9dcf:	52                   	push   %edx
    9dd0:	50                   	push   %eax
    9dd1:	68 8e 00 00 00       	push   $0x8e
    9dd6:	6a 08                	push   $0x8
    9dd8:	e8 de fa ff ff       	call   98bb <set_idt>
    9ddd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9de0:	b8 8f 97 00 00       	mov    $0x978f,%eax
    9de5:	ba 00 00 00 00       	mov    $0x0,%edx
    9dea:	83 ec 0c             	sub    $0xc,%esp
    9ded:	6a 14                	push   $0x14
    9def:	52                   	push   %edx
    9df0:	50                   	push   %eax
    9df1:	68 8e 00 00 00       	push   $0x8e
    9df6:	6a 08                	push   $0x8
    9df8:	e8 be fa ff ff       	call   98bb <set_idt>
    9dfd:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    9e00:	e8 8a 15 00 00       	call   b38f <load_idt>
}
    9e05:	90                   	nop
    9e06:	c9                   	leave  
    9e07:	c3                   	ret    

00009e08 <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    9e08:	55                   	push   %ebp
    9e09:	89 e5                	mov    %esp,%ebp
    9e0b:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    9e0e:	e8 4a 02 00 00       	call   a05d <keyboard_irq>
    PIC_sendEOI(1);
    9e13:	83 ec 0c             	sub    $0xc,%esp
    9e16:	6a 01                	push   $0x1
    9e18:	e8 2b 06 00 00       	call   a448 <PIC_sendEOI>
    9e1d:	83 c4 10             	add    $0x10,%esp
}
    9e20:	90                   	nop
    9e21:	c9                   	leave  
    9e22:	c3                   	ret    

00009e23 <irq2_handler>:

void irq2_handler(void)
{
    9e23:	55                   	push   %ebp
    9e24:	89 e5                	mov    %esp,%ebp
    9e26:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    9e29:	83 ec 0c             	sub    $0xc,%esp
    9e2c:	6a 02                	push   $0x2
    9e2e:	e8 21 08 00 00       	call   a654 <spurious_IRQ>
    9e33:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9e36:	83 ec 0c             	sub    $0xc,%esp
    9e39:	6a 02                	push   $0x2
    9e3b:	e8 08 06 00 00       	call   a448 <PIC_sendEOI>
    9e40:	83 c4 10             	add    $0x10,%esp
}
    9e43:	90                   	nop
    9e44:	c9                   	leave  
    9e45:	c3                   	ret    

00009e46 <irq3_handler>:

void irq3_handler(void)
{
    9e46:	55                   	push   %ebp
    9e47:	89 e5                	mov    %esp,%ebp
    9e49:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    9e4c:	83 ec 0c             	sub    $0xc,%esp
    9e4f:	6a 03                	push   $0x3
    9e51:	e8 fe 07 00 00       	call   a654 <spurious_IRQ>
    9e56:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9e59:	83 ec 0c             	sub    $0xc,%esp
    9e5c:	6a 03                	push   $0x3
    9e5e:	e8 e5 05 00 00       	call   a448 <PIC_sendEOI>
    9e63:	83 c4 10             	add    $0x10,%esp
}
    9e66:	90                   	nop
    9e67:	c9                   	leave  
    9e68:	c3                   	ret    

00009e69 <irq4_handler>:

void irq4_handler(void)
{
    9e69:	55                   	push   %ebp
    9e6a:	89 e5                	mov    %esp,%ebp
    9e6c:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    9e6f:	83 ec 0c             	sub    $0xc,%esp
    9e72:	6a 04                	push   $0x4
    9e74:	e8 db 07 00 00       	call   a654 <spurious_IRQ>
    9e79:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9e7c:	83 ec 0c             	sub    $0xc,%esp
    9e7f:	6a 04                	push   $0x4
    9e81:	e8 c2 05 00 00       	call   a448 <PIC_sendEOI>
    9e86:	83 c4 10             	add    $0x10,%esp
}
    9e89:	90                   	nop
    9e8a:	c9                   	leave  
    9e8b:	c3                   	ret    

00009e8c <irq5_handler>:

void irq5_handler(void)
{
    9e8c:	55                   	push   %ebp
    9e8d:	89 e5                	mov    %esp,%ebp
    9e8f:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9e92:	83 ec 0c             	sub    $0xc,%esp
    9e95:	6a 05                	push   $0x5
    9e97:	e8 b8 07 00 00       	call   a654 <spurious_IRQ>
    9e9c:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9e9f:	83 ec 0c             	sub    $0xc,%esp
    9ea2:	6a 05                	push   $0x5
    9ea4:	e8 9f 05 00 00       	call   a448 <PIC_sendEOI>
    9ea9:	83 c4 10             	add    $0x10,%esp
}
    9eac:	90                   	nop
    9ead:	c9                   	leave  
    9eae:	c3                   	ret    

00009eaf <irq6_handler>:

void irq6_handler(void)
{
    9eaf:	55                   	push   %ebp
    9eb0:	89 e5                	mov    %esp,%ebp
    9eb2:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9eb5:	83 ec 0c             	sub    $0xc,%esp
    9eb8:	6a 06                	push   $0x6
    9eba:	e8 95 07 00 00       	call   a654 <spurious_IRQ>
    9ebf:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9ec2:	83 ec 0c             	sub    $0xc,%esp
    9ec5:	6a 06                	push   $0x6
    9ec7:	e8 7c 05 00 00       	call   a448 <PIC_sendEOI>
    9ecc:	83 c4 10             	add    $0x10,%esp
}
    9ecf:	90                   	nop
    9ed0:	c9                   	leave  
    9ed1:	c3                   	ret    

00009ed2 <irq7_handler>:

void irq7_handler(void)
{
    9ed2:	55                   	push   %ebp
    9ed3:	89 e5                	mov    %esp,%ebp
    9ed5:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9ed8:	83 ec 0c             	sub    $0xc,%esp
    9edb:	6a 07                	push   $0x7
    9edd:	e8 72 07 00 00       	call   a654 <spurious_IRQ>
    9ee2:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9ee5:	83 ec 0c             	sub    $0xc,%esp
    9ee8:	6a 07                	push   $0x7
    9eea:	e8 59 05 00 00       	call   a448 <PIC_sendEOI>
    9eef:	83 c4 10             	add    $0x10,%esp
}
    9ef2:	90                   	nop
    9ef3:	c9                   	leave  
    9ef4:	c3                   	ret    

00009ef5 <irq8_handler>:

void irq8_handler(void)
{
    9ef5:	55                   	push   %ebp
    9ef6:	89 e5                	mov    %esp,%ebp
    9ef8:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    9efb:	83 ec 0c             	sub    $0xc,%esp
    9efe:	6a 08                	push   $0x8
    9f00:	e8 4f 07 00 00       	call   a654 <spurious_IRQ>
    9f05:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9f08:	83 ec 0c             	sub    $0xc,%esp
    9f0b:	6a 08                	push   $0x8
    9f0d:	e8 36 05 00 00       	call   a448 <PIC_sendEOI>
    9f12:	83 c4 10             	add    $0x10,%esp
}
    9f15:	90                   	nop
    9f16:	c9                   	leave  
    9f17:	c3                   	ret    

00009f18 <irq9_handler>:

void irq9_handler(void)
{
    9f18:	55                   	push   %ebp
    9f19:	89 e5                	mov    %esp,%ebp
    9f1b:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    9f1e:	83 ec 0c             	sub    $0xc,%esp
    9f21:	6a 09                	push   $0x9
    9f23:	e8 2c 07 00 00       	call   a654 <spurious_IRQ>
    9f28:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9f2b:	83 ec 0c             	sub    $0xc,%esp
    9f2e:	6a 09                	push   $0x9
    9f30:	e8 13 05 00 00       	call   a448 <PIC_sendEOI>
    9f35:	83 c4 10             	add    $0x10,%esp
}
    9f38:	90                   	nop
    9f39:	c9                   	leave  
    9f3a:	c3                   	ret    

00009f3b <irq10_handler>:

void irq10_handler(void)
{
    9f3b:	55                   	push   %ebp
    9f3c:	89 e5                	mov    %esp,%ebp
    9f3e:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    9f41:	83 ec 0c             	sub    $0xc,%esp
    9f44:	6a 0a                	push   $0xa
    9f46:	e8 09 07 00 00       	call   a654 <spurious_IRQ>
    9f4b:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9f4e:	83 ec 0c             	sub    $0xc,%esp
    9f51:	6a 0a                	push   $0xa
    9f53:	e8 f0 04 00 00       	call   a448 <PIC_sendEOI>
    9f58:	83 c4 10             	add    $0x10,%esp
}
    9f5b:	90                   	nop
    9f5c:	c9                   	leave  
    9f5d:	c3                   	ret    

00009f5e <irq11_handler>:

void irq11_handler(void)
{
    9f5e:	55                   	push   %ebp
    9f5f:	89 e5                	mov    %esp,%ebp
    9f61:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9f64:	83 ec 0c             	sub    $0xc,%esp
    9f67:	6a 0b                	push   $0xb
    9f69:	e8 e6 06 00 00       	call   a654 <spurious_IRQ>
    9f6e:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9f71:	83 ec 0c             	sub    $0xc,%esp
    9f74:	6a 0b                	push   $0xb
    9f76:	e8 cd 04 00 00       	call   a448 <PIC_sendEOI>
    9f7b:	83 c4 10             	add    $0x10,%esp
}
    9f7e:	90                   	nop
    9f7f:	c9                   	leave  
    9f80:	c3                   	ret    

00009f81 <irq12_handler>:

void irq12_handler(void)
{
    9f81:	55                   	push   %ebp
    9f82:	89 e5                	mov    %esp,%ebp
    9f84:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9f87:	83 ec 0c             	sub    $0xc,%esp
    9f8a:	6a 0c                	push   $0xc
    9f8c:	e8 c3 06 00 00       	call   a654 <spurious_IRQ>
    9f91:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9f94:	83 ec 0c             	sub    $0xc,%esp
    9f97:	6a 0c                	push   $0xc
    9f99:	e8 aa 04 00 00       	call   a448 <PIC_sendEOI>
    9f9e:	83 c4 10             	add    $0x10,%esp
}
    9fa1:	90                   	nop
    9fa2:	c9                   	leave  
    9fa3:	c3                   	ret    

00009fa4 <irq13_handler>:

void irq13_handler(void)
{
    9fa4:	55                   	push   %ebp
    9fa5:	89 e5                	mov    %esp,%ebp
    9fa7:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9faa:	83 ec 0c             	sub    $0xc,%esp
    9fad:	6a 0d                	push   $0xd
    9faf:	e8 a0 06 00 00       	call   a654 <spurious_IRQ>
    9fb4:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9fb7:	83 ec 0c             	sub    $0xc,%esp
    9fba:	6a 0d                	push   $0xd
    9fbc:	e8 87 04 00 00       	call   a448 <PIC_sendEOI>
    9fc1:	83 c4 10             	add    $0x10,%esp
}
    9fc4:	90                   	nop
    9fc5:	c9                   	leave  
    9fc6:	c3                   	ret    

00009fc7 <irq14_handler>:

void irq14_handler(void)
{
    9fc7:	55                   	push   %ebp
    9fc8:	89 e5                	mov    %esp,%ebp
    9fca:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9fcd:	83 ec 0c             	sub    $0xc,%esp
    9fd0:	6a 0e                	push   $0xe
    9fd2:	e8 7d 06 00 00       	call   a654 <spurious_IRQ>
    9fd7:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9fda:	83 ec 0c             	sub    $0xc,%esp
    9fdd:	6a 0e                	push   $0xe
    9fdf:	e8 64 04 00 00       	call   a448 <PIC_sendEOI>
    9fe4:	83 c4 10             	add    $0x10,%esp
}
    9fe7:	90                   	nop
    9fe8:	c9                   	leave  
    9fe9:	c3                   	ret    

00009fea <irq15_handler>:

void irq15_handler(void)
{
    9fea:	55                   	push   %ebp
    9feb:	89 e5                	mov    %esp,%ebp
    9fed:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    9ff0:	83 ec 0c             	sub    $0xc,%esp
    9ff3:	6a 0f                	push   $0xf
    9ff5:	e8 5a 06 00 00       	call   a654 <spurious_IRQ>
    9ffa:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    9ffd:	83 ec 0c             	sub    $0xc,%esp
    a000:	6a 0f                	push   $0xf
    a002:	e8 41 04 00 00       	call   a448 <PIC_sendEOI>
    a007:	83 c4 10             	add    $0x10,%esp
    a00a:	90                   	nop
    a00b:	c9                   	leave  
    a00c:	c3                   	ret    

0000a00d <keyboard_add_service>:
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x60)  */
          0xFF, 0xFF, 0xFF, 0xFF  /*      (0x61)  */
      };

void keyboard_add_service(void (*func)())
{
    a00d:	55                   	push   %ebp
    a00e:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service[keyboard_ctrl.kbd_service_num] = func;
    a010:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a017:	0f be c0             	movsbl %al,%eax
    a01a:	8b 55 08             	mov    0x8(%ebp),%edx
    a01d:	89 14 85 22 08 01 00 	mov    %edx,0x10822(,%eax,4)
    keyboard_ctrl.kbd_service_num++;
    a024:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a02b:	83 c0 01             	add    $0x1,%eax
    a02e:	a2 21 08 01 00       	mov    %al,0x10821
}
    a033:	90                   	nop
    a034:	5d                   	pop    %ebp
    a035:	c3                   	ret    

0000a036 <kbd_init>:

void kbd_init()
{
    a036:	55                   	push   %ebp
    a037:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service_num = 0;
    a039:	c6 05 21 08 01 00 00 	movb   $0x0,0x10821
    keyboard_add_service(console_service_keyboard);
    a040:	68 49 97 00 00       	push   $0x9749
    a045:	e8 c3 ff ff ff       	call   a00d <keyboard_add_service>
    a04a:	83 c4 04             	add    $0x4,%esp
    keyboard_add_service(monitor_service_keyboard);
    a04d:	68 b7 a9 00 00       	push   $0xa9b7
    a052:	e8 b6 ff ff ff       	call   a00d <keyboard_add_service>
    a057:	83 c4 04             	add    $0x4,%esp
}
    a05a:	90                   	nop
    a05b:	c9                   	leave  
    a05c:	c3                   	ret    

0000a05d <keyboard_irq>:

void keyboard_irq()
{
    a05d:	55                   	push   %ebp
    a05e:	89 e5                	mov    %esp,%ebp
    a060:	83 ec 18             	sub    $0x18,%esp

    int i;
    void (*func)(void);

    do {
        keyboard_ctrl.code = _8042_get_status;
    a063:	b8 64 00 00 00       	mov    $0x64,%eax
    a068:	89 c2                	mov    %eax,%edx
    a06a:	ec                   	in     (%dx),%al
    a06b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a06f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a073:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e
    } while ((keyboard_ctrl.code & 0x01) == _8042_BUFFER_OVERRUN);
    a079:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a080:	98                   	cwtl   
    a081:	83 e0 01             	and    $0x1,%eax
    a084:	85 c0                	test   %eax,%eax
    a086:	74 db                	je     a063 <keyboard_irq+0x6>

    keyboard_ctrl.code = _8042_scan_code;
    a088:	b8 60 00 00 00       	mov    $0x60,%eax
    a08d:	89 c2                	mov    %eax,%edx
    a08f:	ec                   	in     (%dx),%al
    a090:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a094:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a098:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    a09e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a0a5:	eb 16                	jmp    a0bd <keyboard_irq+0x60>
        func = keyboard_ctrl.kbd_service[i];
    a0a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a0aa:	8b 04 85 22 08 01 00 	mov    0x10822(,%eax,4),%eax
    a0b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        func();
    a0b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a0b7:	ff d0                	call   *%eax
    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    a0b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a0bd:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a0c4:	0f be c0             	movsbl %al,%eax
    a0c7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a0ca:	7c db                	jl     a0a7 <keyboard_irq+0x4a>
    }
}
    a0cc:	90                   	nop
    a0cd:	90                   	nop
    a0ce:	c9                   	leave  
    a0cf:	c3                   	ret    

0000a0d0 <reinitialise_kbd>:

void reinitialise_kbd()
{
    a0d0:	55                   	push   %ebp
    a0d1:	89 e5                	mov    %esp,%ebp
    a0d3:	83 ec 08             	sub    $0x8,%esp
    wait_8042_ACK();
    a0d6:	e8 43 00 00 00       	call   a11e <wait_8042_ACK>
    _8042_send_get_current_scan_code;
    a0db:	ba 64 00 00 00       	mov    $0x64,%edx
    a0e0:	b8 f0 00 00 00       	mov    $0xf0,%eax
    a0e5:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a0e6:	e8 33 00 00 00       	call   a11e <wait_8042_ACK>

    _8042_set_typematic_rate;
    a0eb:	ba 64 00 00 00       	mov    $0x64,%edx
    a0f0:	b8 f3 00 00 00       	mov    $0xf3,%eax
    a0f5:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a0f6:	e8 23 00 00 00       	call   a11e <wait_8042_ACK>

    _8042_set_leds;
    a0fb:	ba 64 00 00 00       	mov    $0x64,%edx
    a100:	b8 ed 00 00 00       	mov    $0xed,%eax
    a105:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a106:	e8 13 00 00 00       	call   a11e <wait_8042_ACK>

    _8042_enable_scanning;
    a10b:	ba 64 00 00 00       	mov    $0x64,%edx
    a110:	b8 f4 00 00 00       	mov    $0xf4,%eax
    a115:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a116:	e8 03 00 00 00       	call   a11e <wait_8042_ACK>
}
    a11b:	90                   	nop
    a11c:	c9                   	leave  
    a11d:	c3                   	ret    

0000a11e <wait_8042_ACK>:

static void
wait_8042_ACK()
{
    a11e:	55                   	push   %ebp
    a11f:	89 e5                	mov    %esp,%ebp
    a121:	83 ec 10             	sub    $0x10,%esp
    while (_8042_get_status != _8042_ACK)
    a124:	90                   	nop
    a125:	b8 64 00 00 00       	mov    $0x64,%eax
    a12a:	89 c2                	mov    %eax,%edx
    a12c:	ec                   	in     (%dx),%al
    a12d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a131:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a135:	66 3d fa 00          	cmp    $0xfa,%ax
    a139:	75 ea                	jne    a125 <wait_8042_ACK+0x7>
        ;
}
    a13b:	90                   	nop
    a13c:	90                   	nop
    a13d:	c9                   	leave  
    a13e:	c3                   	ret    

0000a13f <get_code_kbd_control>:

int16_t get_code_kbd_control()
{
    a13f:	55                   	push   %ebp
    a140:	89 e5                	mov    %esp,%ebp
    return keyboard_ctrl.code;
    a142:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
}
    a149:	5d                   	pop    %ebp
    a14a:	c3                   	ret    

0000a14b <handle_ASCII_code_keyboard>:

static void handle_ASCII_code_keyboard()
{
    a14b:	55                   	push   %ebp
    a14c:	89 e5                	mov    %esp,%ebp
    a14e:	83 ec 10             	sub    $0x10,%esp
    int16_t _code = keyboard_ctrl.code - 1;
    a151:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a158:	83 e8 01             	sub    $0x1,%eax
    a15b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    if (_code < 0x80) { /* key held down */
    a15f:	66 83 7d fe 7f       	cmpw   $0x7f,-0x2(%ebp)
    a164:	0f 8f 8f 00 00 00    	jg     a1f9 <handle_ASCII_code_keyboard+0xae>
        switch (_code) {
    a16a:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a16e:	83 f8 37             	cmp    $0x37,%eax
    a171:	74 3d                	je     a1b0 <handle_ASCII_code_keyboard+0x65>
    a173:	83 f8 37             	cmp    $0x37,%eax
    a176:	7f 44                	jg     a1bc <handle_ASCII_code_keyboard+0x71>
    a178:	83 f8 35             	cmp    $0x35,%eax
    a17b:	74 1b                	je     a198 <handle_ASCII_code_keyboard+0x4d>
    a17d:	83 f8 35             	cmp    $0x35,%eax
    a180:	7f 3a                	jg     a1bc <handle_ASCII_code_keyboard+0x71>
    a182:	83 f8 1c             	cmp    $0x1c,%eax
    a185:	74 1d                	je     a1a4 <handle_ASCII_code_keyboard+0x59>
    a187:	83 f8 29             	cmp    $0x29,%eax
    a18a:	75 30                	jne    a1bc <handle_ASCII_code_keyboard+0x71>
        case 0x29: lshift_enable = 1; break;
    a18c:	c6 05 20 0c 01 00 01 	movb   $0x1,0x10c20
    a193:	e9 b8 00 00 00       	jmp    a250 <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 1; break;
    a198:	c6 05 21 0c 01 00 01 	movb   $0x1,0x10c21
    a19f:	e9 ac 00 00 00       	jmp    a250 <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 1; break;
    a1a4:	c6 05 23 0c 01 00 01 	movb   $0x1,0x10c23
    a1ab:	e9 a0 00 00 00       	jmp    a250 <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 1; break;
    a1b0:	c6 05 22 0c 01 00 01 	movb   $0x1,0x10c22
    a1b7:	e9 94 00 00 00       	jmp    a250 <handle_ASCII_code_keyboard+0x105>
        default:
            keyboard_ctrl.ascii_code_keyboard = kbdmap[_code * 4 + (lshift_enable || rshift_enable)];
    a1bc:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a1c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a1c7:	0f b6 05 20 0c 01 00 	movzbl 0x10c20,%eax
    a1ce:	84 c0                	test   %al,%al
    a1d0:	75 0b                	jne    a1dd <handle_ASCII_code_keyboard+0x92>
    a1d2:	0f b6 05 21 0c 01 00 	movzbl 0x10c21,%eax
    a1d9:	84 c0                	test   %al,%al
    a1db:	74 07                	je     a1e4 <handle_ASCII_code_keyboard+0x99>
    a1dd:	b8 01 00 00 00       	mov    $0x1,%eax
    a1e2:	eb 05                	jmp    a1e9 <handle_ASCII_code_keyboard+0x9e>
    a1e4:	b8 00 00 00 00       	mov    $0x0,%eax
    a1e9:	01 d0                	add    %edx,%eax
    a1eb:	0f b6 80 e0 b5 00 00 	movzbl 0xb5e0(%eax),%eax
    a1f2:	a2 20 08 01 00       	mov    %al,0x10820
        case 0x35: rshift_enable = 0; break;
        case 0x1C: ctrl_enable = 0; break;
        case 0x37: alt_enable = 0; break;
        }
    }
}
    a1f7:	eb 57                	jmp    a250 <handle_ASCII_code_keyboard+0x105>
        _code -= 0x80;
    a1f9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a1fd:	83 c0 80             	add    $0xffffff80,%eax
    a200:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
        keyboard_ctrl.ascii_code_keyboard = '\0'; //Free it when release the key
    a204:	c6 05 20 08 01 00 00 	movb   $0x0,0x10820
        switch (_code) {
    a20b:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a20f:	83 f8 37             	cmp    $0x37,%eax
    a212:	74 34                	je     a248 <handle_ASCII_code_keyboard+0xfd>
    a214:	83 f8 37             	cmp    $0x37,%eax
    a217:	7f 37                	jg     a250 <handle_ASCII_code_keyboard+0x105>
    a219:	83 f8 35             	cmp    $0x35,%eax
    a21c:	74 18                	je     a236 <handle_ASCII_code_keyboard+0xeb>
    a21e:	83 f8 35             	cmp    $0x35,%eax
    a221:	7f 2d                	jg     a250 <handle_ASCII_code_keyboard+0x105>
    a223:	83 f8 1c             	cmp    $0x1c,%eax
    a226:	74 17                	je     a23f <handle_ASCII_code_keyboard+0xf4>
    a228:	83 f8 29             	cmp    $0x29,%eax
    a22b:	75 23                	jne    a250 <handle_ASCII_code_keyboard+0x105>
        case 0x29: lshift_enable = 0; break;
    a22d:	c6 05 20 0c 01 00 00 	movb   $0x0,0x10c20
    a234:	eb 1a                	jmp    a250 <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 0; break;
    a236:	c6 05 21 0c 01 00 00 	movb   $0x0,0x10c21
    a23d:	eb 11                	jmp    a250 <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 0; break;
    a23f:	c6 05 23 0c 01 00 00 	movb   $0x0,0x10c23
    a246:	eb 08                	jmp    a250 <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 0; break;
    a248:	c6 05 22 0c 01 00 00 	movb   $0x0,0x10c22
    a24f:	90                   	nop
}
    a250:	90                   	nop
    a251:	c9                   	leave  
    a252:	c3                   	ret    

0000a253 <get_ASCII_code_keyboard>:

int8_t get_ASCII_code_keyboard()
{
    a253:	55                   	push   %ebp
    a254:	89 e5                	mov    %esp,%ebp

    handle_ASCII_code_keyboard();
    a256:	e8 f0 fe ff ff       	call   a14b <handle_ASCII_code_keyboard>

    return keyboard_ctrl.ascii_code_keyboard;
    a25b:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    a262:	5d                   	pop    %ebp
    a263:	c3                   	ret    

0000a264 <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    a264:	55                   	push   %ebp
    a265:	89 e5                	mov    %esp,%ebp
    a267:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a26a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a271:	eb 20                	jmp    a293 <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a273:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a276:	c1 e0 0c             	shl    $0xc,%eax
    a279:	89 c2                	mov    %eax,%edx
    a27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a27e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a285:	8b 45 08             	mov    0x8(%ebp),%eax
    a288:	01 c8                	add    %ecx,%eax
    a28a:	83 ca 23             	or     $0x23,%edx
    a28d:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a28f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a293:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a29a:	76 d7                	jbe    a273 <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    a29c:	8b 45 08             	mov    0x8(%ebp),%eax
    a29f:	83 c8 23             	or     $0x23,%eax
    a2a2:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    a2a4:	8b 45 0c             	mov    0xc(%ebp),%eax
    a2a7:	89 14 85 00 10 01 00 	mov    %edx,0x11000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    a2ae:	e8 8d 11 00 00       	call   b440 <_FlushPagingCache_>
}
    a2b3:	90                   	nop
    a2b4:	c9                   	leave  
    a2b5:	c3                   	ret    

0000a2b6 <init_paging>:

void init_paging()
{
    a2b6:	55                   	push   %ebp
    a2b7:	89 e5                	mov    %esp,%ebp
    a2b9:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    a2bc:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a2c2:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    a2c8:	eb 1a                	jmp    a2e4 <init_paging+0x2e>
        page_directory[i] =
    a2ca:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a2ce:	c7 04 85 00 10 01 00 	movl   $0x2,0x11000(,%eax,4)
    a2d5:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a2d9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a2dd:	83 c0 01             	add    $0x1,%eax
    a2e0:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a2e4:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a2ea:	76 de                	jbe    a2ca <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a2ec:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    a2f2:	eb 22                	jmp    a316 <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a2f4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a2f8:	c1 e0 0c             	shl    $0xc,%eax
    a2fb:	83 c8 23             	or     $0x23,%eax
    a2fe:	89 c2                	mov    %eax,%edx
    a300:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a304:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a30b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a30f:	83 c0 01             	add    $0x1,%eax
    a312:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a316:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a31c:	76 d6                	jbe    a2f4 <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    a31e:	b8 00 c0 00 00       	mov    $0xc000,%eax
    a323:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    a326:	a3 00 10 01 00       	mov    %eax,0x11000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    a32b:	e8 19 11 00 00       	call   b449 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    a330:	90                   	nop
    a331:	c9                   	leave  
    a332:	c3                   	ret    

0000a333 <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    a333:	55                   	push   %ebp
    a334:	89 e5                	mov    %esp,%ebp
    a336:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    a339:	8b 45 08             	mov    0x8(%ebp),%eax
    a33c:	c1 e8 16             	shr    $0x16,%eax
    a33f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    a342:	8b 45 08             	mov    0x8(%ebp),%eax
    a345:	c1 e8 0c             	shr    $0xc,%eax
    a348:	25 ff 03 00 00       	and    $0x3ff,%eax
    a34d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a350:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a353:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a35a:	83 e0 23             	and    $0x23,%eax
    a35d:	83 f8 23             	cmp    $0x23,%eax
    a360:	75 56                	jne    a3b8 <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a362:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a365:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a36c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a371:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a374:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a37e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a381:	01 d0                	add    %edx,%eax
    a383:	8b 00                	mov    (%eax),%eax
    a385:	83 e0 23             	and    $0x23,%eax
    a388:	83 f8 23             	cmp    $0x23,%eax
    a38b:	75 24                	jne    a3b1 <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a38d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a390:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a397:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a39a:	01 d0                	add    %edx,%eax
    a39c:	8b 00                	mov    (%eax),%eax
    a39e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a3a3:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    a3a5:	8b 45 08             	mov    0x8(%ebp),%eax
    a3a8:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a3ad:	09 d0                	or     %edx,%eax
    a3af:	eb 0c                	jmp    a3bd <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    a3b1:	b8 0c f1 00 00       	mov    $0xf10c,%eax
    a3b6:	eb 05                	jmp    a3bd <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    a3b8:	b8 0c f1 00 00       	mov    $0xf10c,%eax
}
    a3bd:	c9                   	leave  
    a3be:	c3                   	ret    

0000a3bf <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    a3bf:	55                   	push   %ebp
    a3c0:	89 e5                	mov    %esp,%ebp
    a3c2:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    a3c5:	8b 45 08             	mov    0x8(%ebp),%eax
    a3c8:	c1 e8 16             	shr    $0x16,%eax
    a3cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    a3ce:	8b 45 08             	mov    0x8(%ebp),%eax
    a3d1:	c1 e8 0c             	shr    $0xc,%eax
    a3d4:	25 ff 03 00 00       	and    $0x3ff,%eax
    a3d9:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a3dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a3df:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a3e6:	83 e0 23             	and    $0x23,%eax
    a3e9:	83 f8 23             	cmp    $0x23,%eax
    a3ec:	75 4e                	jne    a43c <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a3ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a3f1:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a3f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a3fd:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a400:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a403:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a40a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a40d:	01 d0                	add    %edx,%eax
    a40f:	8b 00                	mov    (%eax),%eax
    a411:	83 e0 23             	and    $0x23,%eax
    a414:	83 f8 23             	cmp    $0x23,%eax
    a417:	74 26                	je     a43f <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a419:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a41c:	c1 e0 0c             	shl    $0xc,%eax
    a41f:	89 c2                	mov    %eax,%edx
    a421:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a424:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a42b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a42e:	01 c8                	add    %ecx,%eax
    a430:	83 ca 23             	or     $0x23,%edx
    a433:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a435:	e8 06 10 00 00       	call   b440 <_FlushPagingCache_>
    a43a:	eb 04                	jmp    a440 <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a43c:	90                   	nop
    a43d:	eb 01                	jmp    a440 <map_linear_address+0x81>
            return; // the linear address was already mapped
    a43f:	90                   	nop
}
    a440:	c9                   	leave  
    a441:	c3                   	ret    

0000a442 <Paging_fault>:

void Paging_fault()
{
    a442:	55                   	push   %ebp
    a443:	89 e5                	mov    %esp,%ebp
}
    a445:	90                   	nop
    a446:	5d                   	pop    %ebp
    a447:	c3                   	ret    

0000a448 <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a448:	55                   	push   %ebp
    a449:	89 e5                	mov    %esp,%ebp
    a44b:	83 ec 04             	sub    $0x4,%esp
    a44e:	8b 45 08             	mov    0x8(%ebp),%eax
    a451:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a454:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a458:	76 0b                	jbe    a465 <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a45a:	ba a0 00 00 00       	mov    $0xa0,%edx
    a45f:	b8 20 00 00 00       	mov    $0x20,%eax
    a464:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a465:	ba 20 00 00 00       	mov    $0x20,%edx
    a46a:	b8 20 00 00 00       	mov    $0x20,%eax
    a46f:	ee                   	out    %al,(%dx)
}
    a470:	90                   	nop
    a471:	c9                   	leave  
    a472:	c3                   	ret    

0000a473 <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a473:	55                   	push   %ebp
    a474:	89 e5                	mov    %esp,%ebp
    a476:	83 ec 18             	sub    $0x18,%esp
    a479:	8b 55 08             	mov    0x8(%ebp),%edx
    a47c:	8b 45 0c             	mov    0xc(%ebp),%eax
    a47f:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a482:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a485:	b8 21 00 00 00       	mov    $0x21,%eax
    a48a:	89 c2                	mov    %eax,%edx
    a48c:	ec                   	in     (%dx),%al
    a48d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a491:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a495:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2 = inb(PIC2_DATA);
    a498:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a49d:	89 c2                	mov    %eax,%edx
    a49f:	ec                   	in     (%dx),%al
    a4a0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a4a4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a4a8:	88 45 f9             	mov    %al,-0x7(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a4ab:	ba 20 00 00 00       	mov    $0x20,%edx
    a4b0:	b8 11 00 00 00       	mov    $0x11,%eax
    a4b5:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a4b6:	eb 00                	jmp    a4b8 <PIC_remap+0x45>
    a4b8:	eb 00                	jmp    a4ba <PIC_remap+0x47>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a4ba:	ba a0 00 00 00       	mov    $0xa0,%edx
    a4bf:	b8 11 00 00 00       	mov    $0x11,%eax
    a4c4:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a4c5:	eb 00                	jmp    a4c7 <PIC_remap+0x54>
    a4c7:	eb 00                	jmp    a4c9 <PIC_remap+0x56>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a4c9:	ba 21 00 00 00       	mov    $0x21,%edx
    a4ce:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a4d2:	ee                   	out    %al,(%dx)
    io_wait;
    a4d3:	eb 00                	jmp    a4d5 <PIC_remap+0x62>
    a4d5:	eb 00                	jmp    a4d7 <PIC_remap+0x64>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a4d7:	ba a1 00 00 00       	mov    $0xa1,%edx
    a4dc:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a4e0:	ee                   	out    %al,(%dx)
    io_wait;
    a4e1:	eb 00                	jmp    a4e3 <PIC_remap+0x70>
    a4e3:	eb 00                	jmp    a4e5 <PIC_remap+0x72>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a4e5:	ba 21 00 00 00       	mov    $0x21,%edx
    a4ea:	b8 04 00 00 00       	mov    $0x4,%eax
    a4ef:	ee                   	out    %al,(%dx)
    io_wait;
    a4f0:	eb 00                	jmp    a4f2 <PIC_remap+0x7f>
    a4f2:	eb 00                	jmp    a4f4 <PIC_remap+0x81>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a4f4:	ba a1 00 00 00       	mov    $0xa1,%edx
    a4f9:	b8 02 00 00 00       	mov    $0x2,%eax
    a4fe:	ee                   	out    %al,(%dx)
    io_wait;
    a4ff:	eb 00                	jmp    a501 <PIC_remap+0x8e>
    a501:	eb 00                	jmp    a503 <PIC_remap+0x90>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a503:	ba 21 00 00 00       	mov    $0x21,%edx
    a508:	b8 01 00 00 00       	mov    $0x1,%eax
    a50d:	ee                   	out    %al,(%dx)
    io_wait;
    a50e:	eb 00                	jmp    a510 <PIC_remap+0x9d>
    a510:	eb 00                	jmp    a512 <PIC_remap+0x9f>

    outb(PIC2_DATA, ICW4_8086);
    a512:	ba a1 00 00 00       	mov    $0xa1,%edx
    a517:	b8 01 00 00 00       	mov    $0x1,%eax
    a51c:	ee                   	out    %al,(%dx)
    io_wait;
    a51d:	eb 00                	jmp    a51f <PIC_remap+0xac>
    a51f:	eb 00                	jmp    a521 <PIC_remap+0xae>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a521:	ba 21 00 00 00       	mov    $0x21,%edx
    a526:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a52a:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a52b:	ba a1 00 00 00       	mov    $0xa1,%edx
    a530:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a534:	ee                   	out    %al,(%dx)
}
    a535:	90                   	nop
    a536:	c9                   	leave  
    a537:	c3                   	ret    

0000a538 <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a538:	55                   	push   %ebp
    a539:	89 e5                	mov    %esp,%ebp
    a53b:	53                   	push   %ebx
    a53c:	83 ec 14             	sub    $0x14,%esp
    a53f:	8b 45 08             	mov    0x8(%ebp),%eax
    a542:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a545:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a549:	77 08                	ja     a553 <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a54b:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a551:	eb 0a                	jmp    a55d <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a553:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a559:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a55d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a561:	89 c2                	mov    %eax,%edx
    a563:	ec                   	in     (%dx),%al
    a564:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a568:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a56c:	89 c3                	mov    %eax,%ebx
    a56e:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a572:	ba 01 00 00 00       	mov    $0x1,%edx
    a577:	89 c1                	mov    %eax,%ecx
    a579:	d3 e2                	shl    %cl,%edx
    a57b:	89 d0                	mov    %edx,%eax
    a57d:	09 d8                	or     %ebx,%eax
    a57f:	88 45 f7             	mov    %al,-0x9(%ebp)

    outb(port, value);
    a582:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a586:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a58a:	ee                   	out    %al,(%dx)
}
    a58b:	90                   	nop
    a58c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a58f:	c9                   	leave  
    a590:	c3                   	ret    

0000a591 <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a591:	55                   	push   %ebp
    a592:	89 e5                	mov    %esp,%ebp
    a594:	53                   	push   %ebx
    a595:	83 ec 14             	sub    $0x14,%esp
    a598:	8b 45 08             	mov    0x8(%ebp),%eax
    a59b:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a59e:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a5a2:	77 09                	ja     a5ad <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a5a4:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a5ab:	eb 0b                	jmp    a5b8 <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a5ad:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a5b4:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a5b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a5bb:	89 c2                	mov    %eax,%edx
    a5bd:	ec                   	in     (%dx),%al
    a5be:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a5c2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a5c6:	89 c3                	mov    %eax,%ebx
    a5c8:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a5cc:	ba 01 00 00 00       	mov    $0x1,%edx
    a5d1:	89 c1                	mov    %eax,%ecx
    a5d3:	d3 e2                	shl    %cl,%edx
    a5d5:	89 d0                	mov    %edx,%eax
    a5d7:	f7 d0                	not    %eax
    a5d9:	21 d8                	and    %ebx,%eax
    a5db:	88 45 f5             	mov    %al,-0xb(%ebp)

    outb(port, value);
    a5de:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a5e1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a5e5:	ee                   	out    %al,(%dx)
}
    a5e6:	90                   	nop
    a5e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a5ea:	c9                   	leave  
    a5eb:	c3                   	ret    

0000a5ec <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a5ec:	55                   	push   %ebp
    a5ed:	89 e5                	mov    %esp,%ebp
    a5ef:	83 ec 14             	sub    $0x14,%esp
    a5f2:	8b 45 08             	mov    0x8(%ebp),%eax
    a5f5:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a5f8:	ba 20 00 00 00       	mov    $0x20,%edx
    a5fd:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a601:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a602:	ba a0 00 00 00       	mov    $0xa0,%edx
    a607:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a60b:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a60c:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a611:	89 c2                	mov    %eax,%edx
    a613:	ec                   	in     (%dx),%al
    a614:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a618:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a61c:	98                   	cwtl   
    a61d:	c1 e0 08             	shl    $0x8,%eax
    a620:	89 c1                	mov    %eax,%ecx
    a622:	b8 20 00 00 00       	mov    $0x20,%eax
    a627:	89 c2                	mov    %eax,%edx
    a629:	ec                   	in     (%dx),%al
    a62a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a62e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a632:	09 c8                	or     %ecx,%eax
}
    a634:	c9                   	leave  
    a635:	c3                   	ret    

0000a636 <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a636:	55                   	push   %ebp
    a637:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a639:	6a 0b                	push   $0xb
    a63b:	e8 ac ff ff ff       	call   a5ec <__pic_get_irq_reg>
    a640:	83 c4 04             	add    $0x4,%esp
}
    a643:	c9                   	leave  
    a644:	c3                   	ret    

0000a645 <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a645:	55                   	push   %ebp
    a646:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a648:	6a 0a                	push   $0xa
    a64a:	e8 9d ff ff ff       	call   a5ec <__pic_get_irq_reg>
    a64f:	83 c4 04             	add    $0x4,%esp
}
    a652:	c9                   	leave  
    a653:	c3                   	ret    

0000a654 <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a654:	55                   	push   %ebp
    a655:	89 e5                	mov    %esp,%ebp
    a657:	83 ec 14             	sub    $0x14,%esp
    a65a:	8b 45 08             	mov    0x8(%ebp),%eax
    a65d:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a660:	e8 d1 ff ff ff       	call   a636 <pic_get_isr>
    a665:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a669:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a66d:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a671:	74 13                	je     a686 <spurious_IRQ+0x32>
    a673:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a677:	0f b6 c0             	movzbl %al,%eax
    a67a:	83 e0 07             	and    $0x7,%eax
    a67d:	50                   	push   %eax
    a67e:	e8 c5 fd ff ff       	call   a448 <PIC_sendEOI>
    a683:	83 c4 04             	add    $0x4,%esp
    a686:	90                   	nop
    a687:	c9                   	leave  
    a688:	c3                   	ret    

0000a689 <conserv_status_byte>:
uint32_t compteur   = 0;
uint8_t  frequency  = 0;
uint8_t  status_PIT = 0;

void conserv_status_byte()
{
    a689:	55                   	push   %ebp
    a68a:	89 e5                	mov    %esp,%ebp
    a68c:	83 ec 10             	sub    $0x10,%esp
    set_pit_count(PIT_0, PIT_reload_value);
    a68f:	ba 43 00 00 00       	mov    $0x43,%edx
    a694:	b8 40 00 00 00       	mov    $0x40,%eax
    a699:	ee                   	out    %al,(%dx)
    a69a:	b8 40 00 00 00       	mov    $0x40,%eax
    a69f:	89 c2                	mov    %eax,%edx
    a6a1:	ec                   	in     (%dx),%al
    a6a2:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a6a6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a6aa:	88 45 f6             	mov    %al,-0xa(%ebp)
    a6ad:	b8 40 00 00 00       	mov    $0x40,%eax
    a6b2:	89 c2                	mov    %eax,%edx
    a6b4:	ec                   	in     (%dx),%al
    a6b5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a6b9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a6bd:	88 45 f7             	mov    %al,-0x9(%ebp)
    a6c0:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a6c4:	66 98                	cbtw   
    a6c6:	ba 40 00 00 00       	mov    $0x40,%edx
    a6cb:	ee                   	out    %al,(%dx)
    a6cc:	a1 74 32 02 00       	mov    0x23274,%eax
    a6d1:	c1 f8 08             	sar    $0x8,%eax
    a6d4:	ba 40 00 00 00       	mov    $0x40,%edx
    a6d9:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a6da:	ba 43 00 00 00       	mov    $0x43,%edx
    a6df:	b8 40 00 00 00       	mov    $0x40,%eax
    a6e4:	ee                   	out    %al,(%dx)
    a6e5:	b8 40 00 00 00       	mov    $0x40,%eax
    a6ea:	89 c2                	mov    %eax,%edx
    a6ec:	ec                   	in     (%dx),%al
    a6ed:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a6f1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a6f5:	88 45 f4             	mov    %al,-0xc(%ebp)
    a6f8:	b8 40 00 00 00       	mov    $0x40,%eax
    a6fd:	89 c2                	mov    %eax,%edx
    a6ff:	ec                   	in     (%dx),%al
    a700:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a704:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a708:	88 45 f5             	mov    %al,-0xb(%ebp)
    a70b:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a70f:	66 98                	cbtw   
    a711:	ba 43 00 00 00       	mov    $0x43,%edx
    a716:	ee                   	out    %al,(%dx)
    a717:	ba 43 00 00 00       	mov    $0x43,%edx
    a71c:	b8 34 00 00 00       	mov    $0x34,%eax
    a721:	ee                   	out    %al,(%dx)
}
    a722:	90                   	nop
    a723:	c9                   	leave  
    a724:	c3                   	ret    

0000a725 <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a725:	55                   	push   %ebp
    a726:	89 e5                	mov    %esp,%ebp
    a728:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a72b:	0f b6 05 40 31 02 00 	movzbl 0x23140,%eax
    a732:	3c 01                	cmp    $0x1,%al
    a734:	75 27                	jne    a75d <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a736:	a1 44 31 02 00       	mov    0x23144,%eax
    a73b:	85 c0                	test   %eax,%eax
    a73d:	75 11                	jne    a750 <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a73f:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    a746:	01 00 00 
            __switch();
    a749:	e8 09 0b 00 00       	call   b257 <__switch>
        } else
            sheduler.task_timer--;
    }
}
    a74e:	eb 0d                	jmp    a75d <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a750:	a1 44 31 02 00       	mov    0x23144,%eax
    a755:	83 e8 01             	sub    $0x1,%eax
    a758:	a3 44 31 02 00       	mov    %eax,0x23144
}
    a75d:	90                   	nop
    a75e:	c9                   	leave  
    a75f:	c3                   	ret    

0000a760 <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a760:	55                   	push   %ebp
    a761:	89 e5                	mov    %esp,%ebp
    a763:	83 ec 28             	sub    $0x28,%esp
    a766:	8b 45 08             	mov    0x8(%ebp),%eax
    a769:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a76d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a771:	a2 04 20 01 00       	mov    %al,0x12004
    calculate_frequency();
    a776:	e8 31 0d 00 00       	call   b4ac <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a77b:	ba 43 00 00 00       	mov    $0x43,%edx
    a780:	b8 40 00 00 00       	mov    $0x40,%eax
    a785:	ee                   	out    %al,(%dx)
    a786:	b8 40 00 00 00       	mov    $0x40,%eax
    a78b:	89 c2                	mov    %eax,%edx
    a78d:	ec                   	in     (%dx),%al
    a78e:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a792:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a796:	88 45 ee             	mov    %al,-0x12(%ebp)
    a799:	b8 40 00 00 00       	mov    $0x40,%eax
    a79e:	89 c2                	mov    %eax,%edx
    a7a0:	ec                   	in     (%dx),%al
    a7a1:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    a7a5:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
    a7a9:	88 45 ef             	mov    %al,-0x11(%ebp)
    a7ac:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    a7b0:	66 98                	cbtw   
    a7b2:	ba 43 00 00 00       	mov    $0x43,%edx
    a7b7:	ee                   	out    %al,(%dx)
    a7b8:	ba 43 00 00 00       	mov    $0x43,%edx
    a7bd:	b8 34 00 00 00       	mov    $0x34,%eax
    a7c2:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a7c3:	ba 43 00 00 00       	mov    $0x43,%edx
    a7c8:	b8 40 00 00 00       	mov    $0x40,%eax
    a7cd:	ee                   	out    %al,(%dx)
    a7ce:	b8 40 00 00 00       	mov    $0x40,%eax
    a7d3:	89 c2                	mov    %eax,%edx
    a7d5:	ec                   	in     (%dx),%al
    a7d6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a7da:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a7de:	88 45 ec             	mov    %al,-0x14(%ebp)
    a7e1:	b8 40 00 00 00       	mov    $0x40,%eax
    a7e6:	89 c2                	mov    %eax,%edx
    a7e8:	ec                   	in     (%dx),%al
    a7e9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a7ed:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a7f1:	88 45 ed             	mov    %al,-0x13(%ebp)
    a7f4:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a7f8:	66 98                	cbtw   
    a7fa:	ba 40 00 00 00       	mov    $0x40,%edx
    a7ff:	ee                   	out    %al,(%dx)
    a800:	a1 74 32 02 00       	mov    0x23274,%eax
    a805:	c1 f8 08             	sar    $0x8,%eax
    a808:	ba 40 00 00 00       	mov    $0x40,%edx
    a80d:	ee                   	out    %al,(%dx)
}
    a80e:	90                   	nop
    a80f:	c9                   	leave  
    a810:	c3                   	ret    

0000a811 <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a811:	55                   	push   %ebp
    a812:	89 e5                	mov    %esp,%ebp
    a814:	83 ec 14             	sub    $0x14,%esp
    a817:	8b 45 08             	mov    0x8(%ebp),%eax
    a81a:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a81d:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a821:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a825:	83 f8 42             	cmp    $0x42,%eax
    a828:	74 1d                	je     a847 <read_back_channel+0x36>
    a82a:	83 f8 42             	cmp    $0x42,%eax
    a82d:	7f 1e                	jg     a84d <read_back_channel+0x3c>
    a82f:	83 f8 40             	cmp    $0x40,%eax
    a832:	74 07                	je     a83b <read_back_channel+0x2a>
    a834:	83 f8 41             	cmp    $0x41,%eax
    a837:	74 08                	je     a841 <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a839:	eb 12                	jmp    a84d <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a83b:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a83f:	eb 0d                	jmp    a84e <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a841:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a845:	eb 07                	jmp    a84e <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a847:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a84b:	eb 01                	jmp    a84e <read_back_channel+0x3d>
        break;
    a84d:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a84e:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a852:	ba 43 00 00 00       	mov    $0x43,%edx
    a857:	b8 40 00 00 00       	mov    $0x40,%eax
    a85c:	ee                   	out    %al,(%dx)
    a85d:	b8 40 00 00 00       	mov    $0x40,%eax
    a862:	89 c2                	mov    %eax,%edx
    a864:	ec                   	in     (%dx),%al
    a865:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a869:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a86d:	88 45 f4             	mov    %al,-0xc(%ebp)
    a870:	b8 40 00 00 00       	mov    $0x40,%eax
    a875:	89 c2                	mov    %eax,%edx
    a877:	ec                   	in     (%dx),%al
    a878:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a87c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a880:	88 45 f5             	mov    %al,-0xb(%ebp)
    a883:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a887:	66 98                	cbtw   
    a889:	ba 43 00 00 00       	mov    $0x43,%edx
    a88e:	ee                   	out    %al,(%dx)
    a88f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a893:	c1 f8 08             	sar    $0x8,%eax
    a896:	ba 43 00 00 00       	mov    $0x43,%edx
    a89b:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a89c:	ba 43 00 00 00       	mov    $0x43,%edx
    a8a1:	b8 40 00 00 00       	mov    $0x40,%eax
    a8a6:	ee                   	out    %al,(%dx)
    a8a7:	b8 40 00 00 00       	mov    $0x40,%eax
    a8ac:	89 c2                	mov    %eax,%edx
    a8ae:	ec                   	in     (%dx),%al
    a8af:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a8b3:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a8b7:	88 45 f2             	mov    %al,-0xe(%ebp)
    a8ba:	b8 40 00 00 00       	mov    $0x40,%eax
    a8bf:	89 c2                	mov    %eax,%edx
    a8c1:	ec                   	in     (%dx),%al
    a8c2:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a8c6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a8ca:	88 45 f3             	mov    %al,-0xd(%ebp)
    a8cd:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a8d1:	66 98                	cbtw   
    a8d3:	c9                   	leave  
    a8d4:	c3                   	ret    

0000a8d5 <read_ebp>:
                 : "r"(eflags));
}

static inline uint32_t
read_ebp(void)
{
    a8d5:	55                   	push   %ebp
    a8d6:	89 e5                	mov    %esp,%ebp
    a8d8:	83 ec 10             	sub    $0x10,%esp
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
    a8db:	89 e8                	mov    %ebp,%eax
    a8dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(ebp));
    return ebp;
    a8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a8e3:	c9                   	leave  
    a8e4:	c3                   	ret    

0000a8e5 <x86_memset>:
{
    asm volatile("movl %0 , %%esp" ::"r"(esp));
}

void* x86_memset(void* addr, uint8_t data, size_t size)
{
    a8e5:	55                   	push   %ebp
    a8e6:	89 e5                	mov    %esp,%ebp
    a8e8:	57                   	push   %edi
    a8e9:	83 ec 04             	sub    $0x4,%esp
    a8ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    a8ef:	88 45 f8             	mov    %al,-0x8(%ebp)
    __asm__("cld; rep stosb\n" ::"D"(addr), "a"(data), "c"(size)
    a8f2:	8b 55 08             	mov    0x8(%ebp),%edx
    a8f5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    a8f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
    a8fc:	89 d7                	mov    %edx,%edi
    a8fe:	fc                   	cld    
    a8ff:	f3 aa                	rep stos %al,%es:(%edi)
            : "cc", "memory");

    return addr;
    a901:	8b 45 08             	mov    0x8(%ebp),%eax
}
    a904:	8b 7d fc             	mov    -0x4(%ebp),%edi
    a907:	c9                   	leave  
    a908:	c3                   	ret    

0000a909 <backtrace>:
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    a909:	55                   	push   %ebp
    a90a:	89 e5                	mov    %esp,%ebp
    a90c:	83 ec 18             	sub    $0x18,%esp
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;
    a90f:	e8 c1 ff ff ff       	call   a8d5 <read_ebp>
    a914:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a917:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a91a:	83 c0 04             	add    $0x4,%eax
    a91d:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp != 0) {
    a920:	eb 30                	jmp    a952 <backtrace+0x49>
        kprintf("ebp %x eip %x\n", ebp, *eip);
    a922:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a925:	8b 00                	mov    (%eax),%eax
    a927:	83 ec 04             	sub    $0x4,%esp
    a92a:	50                   	push   %eax
    a92b:	ff 75 f4             	pushl  -0xc(%ebp)
    a92e:	68 5f f1 00 00       	push   $0xf15f
    a933:	e8 0c 01 00 00       	call   aa44 <kprintf>
    a938:	83 c4 10             	add    $0x10,%esp

        ptr = (int*)(ebp);
    a93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a93e:	89 45 ec             	mov    %eax,-0x14(%ebp)

        ebp = (int)(*ptr);
    a941:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a944:	8b 00                	mov    (%eax),%eax
    a946:	89 45 f4             	mov    %eax,-0xc(%ebp)

        eip = (int*)(ebp + 4);
    a949:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a94c:	83 c0 04             	add    $0x4,%eax
    a94f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (ebp != 0) {
    a952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    a956:	75 ca                	jne    a922 <backtrace+0x19>
    }
    return 0;
    a958:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a95d:	c9                   	leave  
    a95e:	c3                   	ret    

0000a95f <mon_help>:

int mon_help(int argc, char** argv)
{
    a95f:	55                   	push   %ebp
    a960:	89 e5                	mov    %esp,%ebp
    a962:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 2; i++)
    a965:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a96c:	eb 3c                	jmp    a9aa <mon_help+0x4b>
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    a96e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a971:	89 d0                	mov    %edx,%eax
    a973:	01 c0                	add    %eax,%eax
    a975:	01 d0                	add    %edx,%eax
    a977:	c1 e0 02             	shl    $0x2,%eax
    a97a:	05 68 b7 00 00       	add    $0xb768,%eax
    a97f:	8b 10                	mov    (%eax),%edx
    a981:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    a984:	89 c8                	mov    %ecx,%eax
    a986:	01 c0                	add    %eax,%eax
    a988:	01 c8                	add    %ecx,%eax
    a98a:	c1 e0 02             	shl    $0x2,%eax
    a98d:	05 64 b7 00 00       	add    $0xb764,%eax
    a992:	8b 00                	mov    (%eax),%eax
    a994:	83 ec 04             	sub    $0x4,%esp
    a997:	52                   	push   %edx
    a998:	50                   	push   %eax
    a999:	68 6e f1 00 00       	push   $0xf16e
    a99e:	e8 a1 00 00 00       	call   aa44 <kprintf>
    a9a3:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 2; i++)
    a9a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a9aa:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    a9ae:	7e be                	jle    a96e <mon_help+0xf>
    return 0;
    a9b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a9b5:	c9                   	leave  
    a9b6:	c3                   	ret    

0000a9b7 <monitor_service_keyboard>:

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    a9b7:	55                   	push   %ebp
    a9b8:	89 e5                	mov    %esp,%ebp
    a9ba:	83 ec 18             	sub    $0x18,%esp
    if (get_ASCII_code_keyboard() != '\0') {
    a9bd:	e8 91 f8 ff ff       	call   a253 <get_ASCII_code_keyboard>
    a9c2:	84 c0                	test   %al,%al
    a9c4:	74 7b                	je     aa41 <monitor_service_keyboard+0x8a>
        int8_t code = get_ASCII_code_keyboard();
    a9c6:	e8 88 f8 ff ff       	call   a253 <get_ASCII_code_keyboard>
    a9cb:	88 45 f3             	mov    %al,-0xd(%ebp)
        if (code != '\n') {
    a9ce:	80 7d f3 0a          	cmpb   $0xa,-0xd(%ebp)
    a9d2:	74 25                	je     a9f9 <monitor_service_keyboard+0x42>
            keyboard_code_monitor[keyboard_num] = code;
    a9d4:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a9db:	0f be c0             	movsbl %al,%eax
    a9de:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
    a9e2:	88 90 20 20 01 00    	mov    %dl,0x12020(%eax)
            keyboard_num++;
    a9e8:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a9ef:	83 c0 01             	add    $0x1,%eax
    a9f2:	a2 1f 21 01 00       	mov    %al,0x1211f
            }

            keyboard_num = 0;
        }
    }
    a9f7:	eb 48                	jmp    aa41 <monitor_service_keyboard+0x8a>
            for (i = 0; i < keyboard_num; i++) {
    a9f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    aa00:	eb 29                	jmp    aa2b <monitor_service_keyboard+0x74>
                putchar(keyboard_code_monitor[i]);
    aa02:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa05:	05 20 20 01 00       	add    $0x12020,%eax
    aa0a:	0f b6 00             	movzbl (%eax),%eax
    aa0d:	0f b6 c0             	movzbl %al,%eax
    aa10:	83 ec 0c             	sub    $0xc,%esp
    aa13:	50                   	push   %eax
    aa14:	e8 f6 e6 ff ff       	call   910f <putchar>
    aa19:	83 c4 10             	add    $0x10,%esp
                keyboard_code_monitor[i] = 0;
    aa1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa1f:	05 20 20 01 00       	add    $0x12020,%eax
    aa24:	c6 00 00             	movb   $0x0,(%eax)
            for (i = 0; i < keyboard_num; i++) {
    aa27:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    aa2b:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    aa32:	0f be c0             	movsbl %al,%eax
    aa35:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    aa38:	7c c8                	jl     aa02 <monitor_service_keyboard+0x4b>
            keyboard_num = 0;
    aa3a:	c6 05 1f 21 01 00 00 	movb   $0x0,0x1211f
    aa41:	90                   	nop
    aa42:	c9                   	leave  
    aa43:	c3                   	ret    

0000aa44 <kprintf>:
#include <stdint.h>

extern void printf(const char* fmt, va_list arg);

void kprintf(const char* frmt, ...)
{
    aa44:	55                   	push   %ebp
    aa45:	89 e5                	mov    %esp,%ebp
    aa47:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    aa4a:	8d 45 0c             	lea    0xc(%ebp),%eax
    aa4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    aa50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa53:	83 ec 08             	sub    $0x8,%esp
    aa56:	50                   	push   %eax
    aa57:	ff 75 08             	pushl  0x8(%ebp)
    aa5a:	e8 35 e7 ff ff       	call   9194 <printf>
    aa5f:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    aa62:	90                   	nop
    aa63:	c9                   	leave  
    aa64:	c3                   	ret    

0000aa65 <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    aa65:	55                   	push   %ebp
    aa66:	89 e5                	mov    %esp,%ebp
    aa68:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    aa6b:	b8 1b 00 00 00       	mov    $0x1b,%eax
    aa70:	89 c1                	mov    %eax,%ecx
    aa72:	0f 32                	rdmsr  
    aa74:	89 45 f8             	mov    %eax,-0x8(%ebp)
    aa77:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    aa7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    aa7d:	c1 e0 05             	shl    $0x5,%eax
    aa80:	89 c2                	mov    %eax,%edx
    aa82:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aa85:	01 d0                	add    %edx,%eax
}
    aa87:	c9                   	leave  
    aa88:	c3                   	ret    

0000aa89 <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    aa89:	55                   	push   %ebp
    aa8a:	89 e5                	mov    %esp,%ebp
    aa8c:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    aa8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    aa96:	8b 45 08             	mov    0x8(%ebp),%eax
    aa99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    aa9e:	80 cc 08             	or     $0x8,%ah
    aaa1:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    aaa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aaa7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aaaa:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    aaaf:	0f 30                	wrmsr  
}
    aab1:	90                   	nop
    aab2:	c9                   	leave  
    aab3:	c3                   	ret    

0000aab4 <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    aab4:	55                   	push   %ebp
    aab5:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    aab7:	8b 15 20 21 01 00    	mov    0x12120,%edx
    aabd:	8b 45 08             	mov    0x8(%ebp),%eax
    aac0:	01 c0                	add    %eax,%eax
    aac2:	01 d0                	add    %edx,%eax
    aac4:	0f b7 00             	movzwl (%eax),%eax
    aac7:	0f b7 c0             	movzwl %ax,%eax
}
    aaca:	5d                   	pop    %ebp
    aacb:	c3                   	ret    

0000aacc <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    aacc:	55                   	push   %ebp
    aacd:	89 e5                	mov    %esp,%ebp
    aacf:	83 ec 04             	sub    $0x4,%esp
    aad2:	8b 45 0c             	mov    0xc(%ebp),%eax
    aad5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    aad9:	8b 15 20 21 01 00    	mov    0x12120,%edx
    aadf:	8b 45 08             	mov    0x8(%ebp),%eax
    aae2:	01 c0                	add    %eax,%eax
    aae4:	01 c2                	add    %eax,%edx
    aae6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    aaea:	66 89 02             	mov    %ax,(%edx)
}
    aaed:	90                   	nop
    aaee:	c9                   	leave  
    aaef:	c3                   	ret    

0000aaf0 <enable_local_apic>:

void enable_local_apic()
{
    aaf0:	55                   	push   %ebp
    aaf1:	89 e5                	mov    %esp,%ebp
    aaf3:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    aaf6:	83 ec 08             	sub    $0x8,%esp
    aaf9:	68 fb 03 00 00       	push   $0x3fb
    aafe:	68 00 d0 00 00       	push   $0xd000
    ab03:	e8 5c f7 ff ff       	call   a264 <create_page_table>
    ab08:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    ab0b:	e8 55 ff ff ff       	call   aa65 <get_apic_base>
    ab10:	a3 20 21 01 00       	mov    %eax,0x12120

    set_apic_base(get_apic_base());
    ab15:	e8 4b ff ff ff       	call   aa65 <get_apic_base>
    ab1a:	83 ec 0c             	sub    $0xc,%esp
    ab1d:	50                   	push   %eax
    ab1e:	e8 66 ff ff ff       	call   aa89 <set_apic_base>
    ab23:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    ab26:	83 ec 0c             	sub    $0xc,%esp
    ab29:	68 f0 00 00 00       	push   $0xf0
    ab2e:	e8 81 ff ff ff       	call   aab4 <cpu_ReadLocalAPICReg>
    ab33:	83 c4 10             	add    $0x10,%esp
    ab36:	80 cc 01             	or     $0x1,%ah
    ab39:	0f b7 c0             	movzwl %ax,%eax
    ab3c:	83 ec 08             	sub    $0x8,%esp
    ab3f:	50                   	push   %eax
    ab40:	68 f0 00 00 00       	push   $0xf0
    ab45:	e8 82 ff ff ff       	call   aacc <cpu_SetLocalAPICReg>
    ab4a:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    ab4d:	83 ec 08             	sub    $0x8,%esp
    ab50:	6a 02                	push   $0x2
    ab52:	6a 20                	push   $0x20
    ab54:	e8 73 ff ff ff       	call   aacc <cpu_SetLocalAPICReg>
    ab59:	83 c4 10             	add    $0x10,%esp
}
    ab5c:	90                   	nop
    ab5d:	c9                   	leave  
    ab5e:	c3                   	ret    

0000ab5f <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    ab5f:	55                   	push   %ebp
    ab60:	89 e5                	mov    %esp,%ebp
    ab62:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    ab65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    ab6c:	eb 49                	jmp    abb7 <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    ab6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    ab71:	89 d0                	mov    %edx,%eax
    ab73:	01 c0                	add    %eax,%eax
    ab75:	01 d0                	add    %edx,%eax
    ab77:	c1 e0 02             	shl    $0x2,%eax
    ab7a:	05 40 21 01 00       	add    $0x12140,%eax
    ab7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    ab85:	8b 55 fc             	mov    -0x4(%ebp),%edx
    ab88:	89 d0                	mov    %edx,%eax
    ab8a:	01 c0                	add    %eax,%eax
    ab8c:	01 d0                	add    %edx,%eax
    ab8e:	c1 e0 02             	shl    $0x2,%eax
    ab91:	05 48 21 01 00       	add    $0x12148,%eax
    ab96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    ab9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    ab9f:	89 d0                	mov    %edx,%eax
    aba1:	01 c0                	add    %eax,%eax
    aba3:	01 d0                	add    %edx,%eax
    aba5:	c1 e0 02             	shl    $0x2,%eax
    aba8:	05 44 21 01 00       	add    $0x12144,%eax
    abad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    abb3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    abb7:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    abbe:	7e ae                	jle    ab6e <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    abc0:	c7 05 40 e1 01 00 40 	movl   $0x12140,0x1e140
    abc7:	21 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    abca:	90                   	nop
    abcb:	c9                   	leave  
    abcc:	c3                   	ret    

0000abcd <kmalloc>:

void* kmalloc(uint32_t size)
{
    abcd:	55                   	push   %ebp
    abce:	89 e5                	mov    %esp,%ebp
    abd0:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    abd3:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abd8:	8b 00                	mov    (%eax),%eax
    abda:	85 c0                	test   %eax,%eax
    abdc:	75 37                	jne    ac15 <kmalloc+0x48>
        _head_vmm_->address = KERNEL__VM_BASE;
    abde:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abe3:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    abe8:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    abea:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abef:	8b 55 08             	mov    0x8(%ebp),%edx
    abf2:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    abf5:	8b 45 08             	mov    0x8(%ebp),%eax
    abf8:	83 ec 04             	sub    $0x4,%esp
    abfb:	50                   	push   %eax
    abfc:	6a 00                	push   $0x0
    abfe:	68 60 e1 01 00       	push   $0x1e160
    ac03:	e8 7a e8 ff ff       	call   9482 <memset>
    ac08:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    ac0b:	b8 60 e1 01 00       	mov    $0x1e160,%eax
    ac10:	e9 7e 01 00 00       	jmp    ad93 <kmalloc+0x1c6>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    ac15:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ac1c:	eb 04                	jmp    ac22 <kmalloc+0x55>
        i++;
    ac1e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ac22:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    ac29:	77 17                	ja     ac42 <kmalloc+0x75>
    ac2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ac2e:	89 d0                	mov    %edx,%eax
    ac30:	01 c0                	add    %eax,%eax
    ac32:	01 d0                	add    %edx,%eax
    ac34:	c1 e0 02             	shl    $0x2,%eax
    ac37:	05 40 21 01 00       	add    $0x12140,%eax
    ac3c:	8b 00                	mov    (%eax),%eax
    ac3e:	85 c0                	test   %eax,%eax
    ac40:	75 dc                	jne    ac1e <kmalloc+0x51>

    _new_item_ = &MM_BLOCK[i];
    ac42:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ac45:	89 d0                	mov    %edx,%eax
    ac47:	01 c0                	add    %eax,%eax
    ac49:	01 d0                	add    %edx,%eax
    ac4b:	c1 e0 02             	shl    $0x2,%eax
    ac4e:	05 40 21 01 00       	add    $0x12140,%eax
    ac53:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    ac56:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ac5b:	8b 00                	mov    (%eax),%eax
    ac5d:	b9 60 e1 01 00       	mov    $0x1e160,%ecx
    ac62:	8b 55 08             	mov    0x8(%ebp),%edx
    ac65:	01 ca                	add    %ecx,%edx
    ac67:	39 d0                	cmp    %edx,%eax
    ac69:	74 48                	je     acb3 <kmalloc+0xe6>
        _new_item_->address = KERNEL__VM_BASE;
    ac6b:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ac70:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac73:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    ac75:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac78:	8b 55 08             	mov    0x8(%ebp),%edx
    ac7b:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    ac7e:	8b 15 40 e1 01 00    	mov    0x1e140,%edx
    ac84:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac87:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    ac8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac8d:	a3 40 e1 01 00       	mov    %eax,0x1e140

        memset((void*)_new_item_->address, 0, size);
    ac92:	8b 45 08             	mov    0x8(%ebp),%eax
    ac95:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac98:	8b 12                	mov    (%edx),%edx
    ac9a:	83 ec 04             	sub    $0x4,%esp
    ac9d:	50                   	push   %eax
    ac9e:	6a 00                	push   $0x0
    aca0:	52                   	push   %edx
    aca1:	e8 dc e7 ff ff       	call   9482 <memset>
    aca6:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    aca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acac:	8b 00                	mov    (%eax),%eax
    acae:	e9 e0 00 00 00       	jmp    ad93 <kmalloc+0x1c6>
    }

    tmp = _head_vmm_;
    acb3:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acb8:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    acbb:	eb 27                	jmp    ace4 <kmalloc+0x117>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    acbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acc0:	8b 40 08             	mov    0x8(%eax),%eax
    acc3:	8b 10                	mov    (%eax),%edx
    acc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acc8:	8b 08                	mov    (%eax),%ecx
    acca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    accd:	8b 40 04             	mov    0x4(%eax),%eax
    acd0:	01 c1                	add    %eax,%ecx
    acd2:	8b 45 08             	mov    0x8(%ebp),%eax
    acd5:	01 c8                	add    %ecx,%eax
    acd7:	39 c2                	cmp    %eax,%edx
    acd9:	73 15                	jae    acf0 <kmalloc+0x123>
            break;

        tmp = tmp->next;
    acdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acde:	8b 40 08             	mov    0x8(%eax),%eax
    ace1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    ace4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ace7:	8b 40 08             	mov    0x8(%eax),%eax
    acea:	85 c0                	test   %eax,%eax
    acec:	75 cf                	jne    acbd <kmalloc+0xf0>
    acee:	eb 01                	jmp    acf1 <kmalloc+0x124>
            break;
    acf0:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    acf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    acf4:	8b 40 08             	mov    0x8(%eax),%eax
    acf7:	85 c0                	test   %eax,%eax
    acf9:	75 4c                	jne    ad47 <kmalloc+0x17a>
        _new_item_->size = size;
    acfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acfe:	8b 55 08             	mov    0x8(%ebp),%edx
    ad01:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ad04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad07:	8b 10                	mov    (%eax),%edx
    ad09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad0c:	8b 40 04             	mov    0x4(%eax),%eax
    ad0f:	01 c2                	add    %eax,%edx
    ad11:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad14:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    ad16:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    ad20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad23:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad26:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ad29:	8b 45 08             	mov    0x8(%ebp),%eax
    ad2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad2f:	8b 12                	mov    (%edx),%edx
    ad31:	83 ec 04             	sub    $0x4,%esp
    ad34:	50                   	push   %eax
    ad35:	6a 00                	push   $0x0
    ad37:	52                   	push   %edx
    ad38:	e8 45 e7 ff ff       	call   9482 <memset>
    ad3d:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ad40:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad43:	8b 00                	mov    (%eax),%eax
    ad45:	eb 4c                	jmp    ad93 <kmalloc+0x1c6>
    }

    else {
        _new_item_->size = size;
    ad47:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad4a:	8b 55 08             	mov    0x8(%ebp),%edx
    ad4d:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ad50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad53:	8b 10                	mov    (%eax),%edx
    ad55:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad58:	8b 40 04             	mov    0x4(%eax),%eax
    ad5b:	01 c2                	add    %eax,%edx
    ad5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad60:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    ad62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad65:	8b 50 08             	mov    0x8(%eax),%edx
    ad68:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad6b:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    ad6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad71:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad74:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ad77:	8b 45 08             	mov    0x8(%ebp),%eax
    ad7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad7d:	8b 12                	mov    (%edx),%edx
    ad7f:	83 ec 04             	sub    $0x4,%esp
    ad82:	50                   	push   %eax
    ad83:	6a 00                	push   $0x0
    ad85:	52                   	push   %edx
    ad86:	e8 f7 e6 ff ff       	call   9482 <memset>
    ad8b:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ad8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad91:	8b 00                	mov    (%eax),%eax
    }
}
    ad93:	c9                   	leave  
    ad94:	c3                   	ret    

0000ad95 <free>:

void free(virtaddr_t _addr__)
{
    ad95:	55                   	push   %ebp
    ad96:	89 e5                	mov    %esp,%ebp
    ad98:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    ad9b:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ada0:	8b 00                	mov    (%eax),%eax
    ada2:	39 45 08             	cmp    %eax,0x8(%ebp)
    ada5:	75 29                	jne    add0 <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    ada7:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    adb2:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    adbe:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adc3:	8b 40 08             	mov    0x8(%eax),%eax
    adc6:	a3 40 e1 01 00       	mov    %eax,0x1e140
        return;
    adcb:	e9 ac 00 00 00       	jmp    ae7c <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    add0:	a1 40 e1 01 00       	mov    0x1e140,%eax
    add5:	8b 40 08             	mov    0x8(%eax),%eax
    add8:	85 c0                	test   %eax,%eax
    adda:	75 16                	jne    adf2 <free+0x5d>
    addc:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ade1:	8b 00                	mov    (%eax),%eax
    ade3:	39 45 08             	cmp    %eax,0x8(%ebp)
    ade6:	75 0a                	jne    adf2 <free+0x5d>
        init_vmm();
    ade8:	e8 72 fd ff ff       	call   ab5f <init_vmm>
        return;
    aded:	e9 8a 00 00 00       	jmp    ae7c <free+0xe7>
    }

    tmp = _head_vmm_;
    adf2:	a1 40 e1 01 00       	mov    0x1e140,%eax
    adf7:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    adfa:	eb 0f                	jmp    ae0b <free+0x76>
        tmp_prev = tmp;
    adfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    adff:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    ae02:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae05:	8b 40 08             	mov    0x8(%eax),%eax
    ae08:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ae0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae0e:	8b 40 08             	mov    0x8(%eax),%eax
    ae11:	85 c0                	test   %eax,%eax
    ae13:	74 0a                	je     ae1f <free+0x8a>
    ae15:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae18:	8b 00                	mov    (%eax),%eax
    ae1a:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae1d:	75 dd                	jne    adfc <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ae1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae22:	8b 40 08             	mov    0x8(%eax),%eax
    ae25:	85 c0                	test   %eax,%eax
    ae27:	75 29                	jne    ae52 <free+0xbd>
    ae29:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae2c:	8b 00                	mov    (%eax),%eax
    ae2e:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae31:	75 1f                	jne    ae52 <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ae33:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ae3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ae46:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ae49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ae50:	eb 2a                	jmp    ae7c <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ae52:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae55:	8b 00                	mov    (%eax),%eax
    ae57:	39 45 08             	cmp    %eax,0x8(%ebp)
    ae5a:	75 20                	jne    ae7c <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ae5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ae65:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ae6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae72:	8b 50 08             	mov    0x8(%eax),%edx
    ae75:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ae78:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ae7b:	90                   	nop
    }
    ae7c:	c9                   	leave  
    ae7d:	c3                   	ret    

0000ae7e <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ae7e:	55                   	push   %ebp
    ae7f:	89 e5                	mov    %esp,%ebp
    ae81:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ae84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    ae8b:	eb 49                	jmp    aed6 <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ae8d:	ba 77 f1 00 00       	mov    $0xf177,%edx
    ae92:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae95:	c1 e0 04             	shl    $0x4,%eax
    ae98:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae9d:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    ae9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aea2:	c1 e0 04             	shl    $0x4,%eax
    aea5:	05 44 f1 01 00       	add    $0x1f144,%eax
    aeaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    aeb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aeb3:	c1 e0 04             	shl    $0x4,%eax
    aeb6:	05 4c f1 01 00       	add    $0x1f14c,%eax
    aebb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    aec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aec4:	c1 e0 04             	shl    $0x4,%eax
    aec7:	05 48 f1 01 00       	add    $0x1f148,%eax
    aecc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    aed2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    aed6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    aedd:	76 ae                	jbe    ae8d <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    aedf:	83 ec 08             	sub    $0x8,%esp
    aee2:	6a 01                	push   $0x1
    aee4:	68 00 e0 00 00       	push   $0xe000
    aee9:	e8 76 f3 ff ff       	call   a264 <create_page_table>
    aeee:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    aef1:	c7 05 20 f1 01 00 40 	movl   $0x1f140,0x1f120
    aef8:	f1 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    aefb:	90                   	nop
    aefc:	c9                   	leave  
    aefd:	c3                   	ret    

0000aefe <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    aefe:	55                   	push   %ebp
    aeff:	89 e5                	mov    %esp,%ebp
    af01:	53                   	push   %ebx
    af02:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    af05:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af0a:	8b 00                	mov    (%eax),%eax
    af0c:	ba 77 f1 00 00       	mov    $0xf177,%edx
    af11:	39 d0                	cmp    %edx,%eax
    af13:	75 40                	jne    af55 <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    af15:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af1a:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    af20:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af25:	8b 55 08             	mov    0x8(%ebp),%edx
    af28:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    af2b:	8b 45 08             	mov    0x8(%ebp),%eax
    af2e:	c1 e0 0c             	shl    $0xc,%eax
    af31:	89 c2                	mov    %eax,%edx
    af33:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af38:	8b 00                	mov    (%eax),%eax
    af3a:	83 ec 04             	sub    $0x4,%esp
    af3d:	52                   	push   %edx
    af3e:	6a 00                	push   $0x0
    af40:	50                   	push   %eax
    af41:	e8 3c e5 ff ff       	call   9482 <memset>
    af46:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    af49:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af4e:	8b 00                	mov    (%eax),%eax
    af50:	e9 ae 01 00 00       	jmp    b103 <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    af55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    af5c:	eb 04                	jmp    af62 <alloc_page+0x64>
        i++;
    af5e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    af62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    af65:	c1 e0 04             	shl    $0x4,%eax
    af68:	05 40 f1 01 00       	add    $0x1f140,%eax
    af6d:	8b 00                	mov    (%eax),%eax
    af6f:	ba 77 f1 00 00       	mov    $0xf177,%edx
    af74:	39 d0                	cmp    %edx,%eax
    af76:	74 09                	je     af81 <alloc_page+0x83>
    af78:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    af7f:	76 dd                	jbe    af5e <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    af81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    af84:	c1 e0 04             	shl    $0x4,%eax
    af87:	05 40 f1 01 00       	add    $0x1f140,%eax
    af8c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    af8f:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af94:	8b 00                	mov    (%eax),%eax
    af96:	8b 55 08             	mov    0x8(%ebp),%edx
    af99:	81 c2 00 01 00 00    	add    $0x100,%edx
    af9f:	c1 e2 0c             	shl    $0xc,%edx
    afa2:	39 d0                	cmp    %edx,%eax
    afa4:	72 4c                	jb     aff2 <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    afa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afa9:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    afaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afb2:	8b 55 08             	mov    0x8(%ebp),%edx
    afb5:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    afb8:	8b 15 20 f1 01 00    	mov    0x1f120,%edx
    afbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afc1:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    afc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afc7:	a3 20 f1 01 00       	mov    %eax,0x1f120

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    afcc:	8b 45 08             	mov    0x8(%ebp),%eax
    afcf:	c1 e0 0c             	shl    $0xc,%eax
    afd2:	89 c2                	mov    %eax,%edx
    afd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afd7:	8b 00                	mov    (%eax),%eax
    afd9:	83 ec 04             	sub    $0x4,%esp
    afdc:	52                   	push   %edx
    afdd:	6a 00                	push   $0x0
    afdf:	50                   	push   %eax
    afe0:	e8 9d e4 ff ff       	call   9482 <memset>
    afe5:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    afe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afeb:	8b 00                	mov    (%eax),%eax
    afed:	e9 11 01 00 00       	jmp    b103 <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    aff2:	a1 20 f1 01 00       	mov    0x1f120,%eax
    aff7:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    affa:	eb 2a                	jmp    b026 <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    affc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afff:	8b 40 0c             	mov    0xc(%eax),%eax
    b002:	8b 10                	mov    (%eax),%edx
    b004:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b007:	8b 08                	mov    (%eax),%ecx
    b009:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b00c:	8b 58 04             	mov    0x4(%eax),%ebx
    b00f:	8b 45 08             	mov    0x8(%ebp),%eax
    b012:	01 d8                	add    %ebx,%eax
    b014:	c1 e0 0c             	shl    $0xc,%eax
    b017:	01 c8                	add    %ecx,%eax
    b019:	39 c2                	cmp    %eax,%edx
    b01b:	77 15                	ja     b032 <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    b01d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b020:	8b 40 0c             	mov    0xc(%eax),%eax
    b023:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    b026:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b029:	8b 40 0c             	mov    0xc(%eax),%eax
    b02c:	85 c0                	test   %eax,%eax
    b02e:	75 cc                	jne    affc <alloc_page+0xfe>
    b030:	eb 01                	jmp    b033 <alloc_page+0x135>
            break;
    b032:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    b033:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b036:	8b 40 0c             	mov    0xc(%eax),%eax
    b039:	85 c0                	test   %eax,%eax
    b03b:	75 5d                	jne    b09a <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    b03d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b040:	8b 10                	mov    (%eax),%edx
    b042:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b045:	8b 40 04             	mov    0x4(%eax),%eax
    b048:	c1 e0 0c             	shl    $0xc,%eax
    b04b:	01 c2                	add    %eax,%edx
    b04d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b050:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    b052:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b055:	8b 55 08             	mov    0x8(%ebp),%edx
    b058:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    b05b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b05e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    b065:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b068:	8b 55 f0             	mov    -0x10(%ebp),%edx
    b06b:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    b06e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b071:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b074:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    b077:	8b 45 08             	mov    0x8(%ebp),%eax
    b07a:	c1 e0 0c             	shl    $0xc,%eax
    b07d:	89 c2                	mov    %eax,%edx
    b07f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b082:	8b 00                	mov    (%eax),%eax
    b084:	83 ec 04             	sub    $0x4,%esp
    b087:	52                   	push   %edx
    b088:	6a 00                	push   $0x0
    b08a:	50                   	push   %eax
    b08b:	e8 f2 e3 ff ff       	call   9482 <memset>
    b090:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b093:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b096:	8b 00                	mov    (%eax),%eax
    b098:	eb 69                	jmp    b103 <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    b09a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b09d:	8b 10                	mov    (%eax),%edx
    b09f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0a2:	8b 40 04             	mov    0x4(%eax),%eax
    b0a5:	c1 e0 0c             	shl    $0xc,%eax
    b0a8:	01 c2                	add    %eax,%edx
    b0aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0ad:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    b0af:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0b2:	8b 55 08             	mov    0x8(%ebp),%edx
    b0b5:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    b0b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0bb:	8b 50 0c             	mov    0xc(%eax),%edx
    b0be:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0c1:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    b0c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    b0ca:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    b0cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b0d3:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    b0d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b0d9:	8b 40 0c             	mov    0xc(%eax),%eax
    b0dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
    b0df:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    b0e2:	8b 45 08             	mov    0x8(%ebp),%eax
    b0e5:	c1 e0 0c             	shl    $0xc,%eax
    b0e8:	89 c2                	mov    %eax,%edx
    b0ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b0ed:	8b 00                	mov    (%eax),%eax
    b0ef:	83 ec 04             	sub    $0x4,%esp
    b0f2:	52                   	push   %edx
    b0f3:	6a 00                	push   $0x0
    b0f5:	50                   	push   %eax
    b0f6:	e8 87 e3 ff ff       	call   9482 <memset>
    b0fb:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b0fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b101:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    b103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    b106:	c9                   	leave  
    b107:	c3                   	ret    

0000b108 <free_page>:

void free_page(_address_order_track_ page)
{
    b108:	55                   	push   %ebp
    b109:	89 e5                	mov    %esp,%ebp
    b10b:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    b10e:	8b 45 10             	mov    0x10(%ebp),%eax
    b111:	85 c0                	test   %eax,%eax
    b113:	75 2d                	jne    b142 <free_page+0x3a>
    b115:	8b 45 14             	mov    0x14(%ebp),%eax
    b118:	85 c0                	test   %eax,%eax
    b11a:	74 26                	je     b142 <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    b11c:	b8 77 f1 00 00       	mov    $0xf177,%eax
    b121:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    b124:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b129:	8b 40 0c             	mov    0xc(%eax),%eax
    b12c:	a3 20 f1 01 00       	mov    %eax,0x1f120
        _page_area_track_->previous_ = END_LIST;
    b131:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b136:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    b13d:	e9 13 01 00 00       	jmp    b255 <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    b142:	8b 45 10             	mov    0x10(%ebp),%eax
    b145:	85 c0                	test   %eax,%eax
    b147:	75 67                	jne    b1b0 <free_page+0xa8>
    b149:	8b 45 14             	mov    0x14(%ebp),%eax
    b14c:	85 c0                	test   %eax,%eax
    b14e:	75 60                	jne    b1b0 <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    b150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    b157:	eb 49                	jmp    b1a2 <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    b159:	ba 77 f1 00 00       	mov    $0xf177,%edx
    b15e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b161:	c1 e0 04             	shl    $0x4,%eax
    b164:	05 40 f1 01 00       	add    $0x1f140,%eax
    b169:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    b16b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b16e:	c1 e0 04             	shl    $0x4,%eax
    b171:	05 44 f1 01 00       	add    $0x1f144,%eax
    b176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    b17c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b17f:	c1 e0 04             	shl    $0x4,%eax
    b182:	05 4c f1 01 00       	add    $0x1f14c,%eax
    b187:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    b18d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b190:	c1 e0 04             	shl    $0x4,%eax
    b193:	05 48 f1 01 00       	add    $0x1f148,%eax
    b198:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    b19e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b1a2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    b1a9:	76 ae                	jbe    b159 <free_page+0x51>
        }
        return;
    b1ab:	e9 a5 00 00 00       	jmp    b255 <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b1b0:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b1b5:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b1b8:	eb 09                	jmp    b1c3 <free_page+0xbb>
            tmp = tmp->next_;
    b1ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1bd:	8b 40 0c             	mov    0xc(%eax),%eax
    b1c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b1c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1c6:	8b 10                	mov    (%eax),%edx
    b1c8:	8b 45 08             	mov    0x8(%ebp),%eax
    b1cb:	39 c2                	cmp    %eax,%edx
    b1cd:	74 0a                	je     b1d9 <free_page+0xd1>
    b1cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1d2:	8b 40 0c             	mov    0xc(%eax),%eax
    b1d5:	85 c0                	test   %eax,%eax
    b1d7:	75 e1                	jne    b1ba <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    b1d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1dc:	8b 40 0c             	mov    0xc(%eax),%eax
    b1df:	85 c0                	test   %eax,%eax
    b1e1:	75 25                	jne    b208 <free_page+0x100>
    b1e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1e6:	8b 10                	mov    (%eax),%edx
    b1e8:	8b 45 08             	mov    0x8(%ebp),%eax
    b1eb:	39 c2                	cmp    %eax,%edx
    b1ed:	75 19                	jne    b208 <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b1ef:	ba 77 f1 00 00       	mov    $0xf177,%edx
    b1f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1f7:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    b1f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b1fc:	8b 40 08             	mov    0x8(%eax),%eax
    b1ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    b206:	eb 4d                	jmp    b255 <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    b208:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b20b:	8b 40 0c             	mov    0xc(%eax),%eax
    b20e:	85 c0                	test   %eax,%eax
    b210:	74 36                	je     b248 <free_page+0x140>
    b212:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b215:	8b 10                	mov    (%eax),%edx
    b217:	8b 45 08             	mov    0x8(%ebp),%eax
    b21a:	39 c2                	cmp    %eax,%edx
    b21c:	75 2a                	jne    b248 <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b21e:	ba 77 f1 00 00       	mov    $0xf177,%edx
    b223:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b226:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    b228:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b22b:	8b 40 08             	mov    0x8(%eax),%eax
    b22e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b231:	8b 52 0c             	mov    0xc(%edx),%edx
    b234:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    b237:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b23a:	8b 40 0c             	mov    0xc(%eax),%eax
    b23d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b240:	8b 52 08             	mov    0x8(%edx),%edx
    b243:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    b246:	eb 0d                	jmp    b255 <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    b248:	a1 24 f1 01 00       	mov    0x1f124,%eax
    b24d:	83 e8 01             	sub    $0x1,%eax
    b250:	a3 24 f1 01 00       	mov    %eax,0x1f124
    b255:	c9                   	leave  
    b256:	c3                   	ret    

0000b257 <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    b257:	55                   	push   %ebp
    b258:	89 e5                	mov    %esp,%ebp
    b25a:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    b25d:	a1 48 31 02 00       	mov    0x23148,%eax
    b262:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    b265:	a1 48 31 02 00       	mov    0x23148,%eax
    b26a:	8b 40 3c             	mov    0x3c(%eax),%eax
    b26d:	a3 48 31 02 00       	mov    %eax,0x23148

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    b272:	a1 48 31 02 00       	mov    0x23148,%eax
    b277:	89 c2                	mov    %eax,%edx
    b279:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b27c:	83 ec 08             	sub    $0x8,%esp
    b27f:	52                   	push   %edx
    b280:	50                   	push   %eax
    b281:	e8 ca 02 00 00       	call   b550 <switch_to_task>
    b286:	83 c4 10             	add    $0x10,%esp
}
    b289:	90                   	nop
    b28a:	c9                   	leave  
    b28b:	c3                   	ret    

0000b28c <init_multitasking>:

void init_multitasking()
{
    b28c:	55                   	push   %ebp
    b28d:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    b28f:	c6 05 40 31 02 00 00 	movb   $0x0,0x23140
    sheduler.task_timer = DELAY_PER_TASK;
    b296:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    b29d:	01 00 00 
}
    b2a0:	90                   	nop
    b2a1:	5d                   	pop    %ebp
    b2a2:	c3                   	ret    

0000b2a3 <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    b2a3:	55                   	push   %ebp
    b2a4:	89 e5                	mov    %esp,%ebp
    b2a6:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    b2a9:	8b 45 08             	mov    0x8(%ebp),%eax
    b2ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    b2b2:	8b 45 08             	mov    0x8(%ebp),%eax
    b2b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    b2bc:	8b 45 08             	mov    0x8(%ebp),%eax
    b2bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    b2c6:	8b 45 08             	mov    0x8(%ebp),%eax
    b2c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    b2d0:	8b 45 08             	mov    0x8(%ebp),%eax
    b2d3:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    b2da:	8b 45 08             	mov    0x8(%ebp),%eax
    b2dd:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    b2e4:	8b 45 08             	mov    0x8(%ebp),%eax
    b2e7:	8b 55 10             	mov    0x10(%ebp),%edx
    b2ea:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    b2ed:	8b 55 0c             	mov    0xc(%ebp),%edx
    b2f0:	8b 45 08             	mov    0x8(%ebp),%eax
    b2f3:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    b2f6:	8b 45 08             	mov    0x8(%ebp),%eax
    b2f9:	8b 55 14             	mov    0x14(%ebp),%edx
    b2fc:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    b2ff:	83 ec 0c             	sub    $0xc,%esp
    b302:	68 c8 00 00 00       	push   $0xc8
    b307:	e8 c1 f8 ff ff       	call   abcd <kmalloc>
    b30c:	83 c4 10             	add    $0x10,%esp
    b30f:	89 c2                	mov    %eax,%edx
    b311:	8b 45 08             	mov    0x8(%ebp),%eax
    b314:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    b317:	8b 45 08             	mov    0x8(%ebp),%eax
    b31a:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b321:	90                   	nop
    b322:	c9                   	leave  
    b323:	c3                   	ret    
    b324:	66 90                	xchg   %ax,%ax
    b326:	66 90                	xchg   %ax,%ax
    b328:	66 90                	xchg   %ax,%ax
    b32a:	66 90                	xchg   %ax,%ax
    b32c:	66 90                	xchg   %ax,%ax
    b32e:	66 90                	xchg   %ax,%ax

0000b330 <__exception_handler__>:
    b330:	58                   	pop    %eax
    b331:	a3 7c b7 00 00       	mov    %eax,0xb77c
    b336:	e8 4e e4 ff ff       	call   9789 <__exception__>
    b33b:	cf                   	iret   

0000b33c <__exception_no_ERRCODE_handler__>:
    b33c:	e8 4e e4 ff ff       	call   978f <__exception_no_ERRCODE__>
    b341:	cf                   	iret   
    b342:	66 90                	xchg   %ax,%ax
    b344:	66 90                	xchg   %ax,%ax
    b346:	66 90                	xchg   %ax,%ax
    b348:	66 90                	xchg   %ax,%ax
    b34a:	66 90                	xchg   %ax,%ax
    b34c:	66 90                	xchg   %ax,%ax
    b34e:	66 90                	xchg   %ax,%ax

0000b350 <gdtr>:
    b350:	00 00                	add    %al,(%eax)
    b352:	00 00                	add    %al,(%eax)
	...

0000b356 <load_gdt>:
    b356:	fa                   	cli    
    b357:	50                   	push   %eax
    b358:	51                   	push   %ecx
    b359:	b9 00 00 00 00       	mov    $0x0,%ecx
    b35e:	89 0d 52 b3 00 00    	mov    %ecx,0xb352
    b364:	31 c0                	xor    %eax,%eax
    b366:	b8 00 01 00 00       	mov    $0x100,%eax
    b36b:	01 c8                	add    %ecx,%eax
    b36d:	66 a3 50 b3 00 00    	mov    %ax,0xb350
    b373:	0f 01 15 50 b3 00 00 	lgdtl  0xb350
    b37a:	8b 0d 52 b3 00 00    	mov    0xb352,%ecx
    b380:	83 c1 20             	add    $0x20,%ecx
    b383:	0f 00 d9             	ltr    %cx
    b386:	59                   	pop    %ecx
    b387:	58                   	pop    %eax
    b388:	c3                   	ret    

0000b389 <idtr>:
    b389:	00 00                	add    %al,(%eax)
    b38b:	00 00                	add    %al,(%eax)
	...

0000b38f <load_idt>:
    b38f:	fa                   	cli    
    b390:	50                   	push   %eax
    b391:	51                   	push   %ecx
    b392:	31 c9                	xor    %ecx,%ecx
    b394:	b9 20 00 01 00       	mov    $0x10020,%ecx
    b399:	89 0d 8b b3 00 00    	mov    %ecx,0xb38b
    b39f:	31 c0                	xor    %eax,%eax
    b3a1:	b8 00 04 00 00       	mov    $0x400,%eax
    b3a6:	01 c8                	add    %ecx,%eax
    b3a8:	66 a3 89 b3 00 00    	mov    %ax,0xb389
    b3ae:	0f 01 1d 89 b3 00 00 	lidtl  0xb389
    b3b5:	59                   	pop    %ecx
    b3b6:	58                   	pop    %eax
    b3b7:	c3                   	ret    
    b3b8:	66 90                	xchg   %ax,%ax
    b3ba:	66 90                	xchg   %ax,%ax
    b3bc:	66 90                	xchg   %ax,%ax
    b3be:	66 90                	xchg   %ax,%ax

0000b3c0 <irq1>:
    b3c0:	60                   	pusha  
    b3c1:	e8 42 ea ff ff       	call   9e08 <irq1_handler>
    b3c6:	61                   	popa   
    b3c7:	cf                   	iret   

0000b3c8 <irq2>:
    b3c8:	60                   	pusha  
    b3c9:	e8 55 ea ff ff       	call   9e23 <irq2_handler>
    b3ce:	61                   	popa   
    b3cf:	cf                   	iret   

0000b3d0 <irq3>:
    b3d0:	60                   	pusha  
    b3d1:	e8 70 ea ff ff       	call   9e46 <irq3_handler>
    b3d6:	61                   	popa   
    b3d7:	cf                   	iret   

0000b3d8 <irq4>:
    b3d8:	60                   	pusha  
    b3d9:	e8 8b ea ff ff       	call   9e69 <irq4_handler>
    b3de:	61                   	popa   
    b3df:	cf                   	iret   

0000b3e0 <irq5>:
    b3e0:	60                   	pusha  
    b3e1:	e8 a6 ea ff ff       	call   9e8c <irq5_handler>
    b3e6:	61                   	popa   
    b3e7:	cf                   	iret   

0000b3e8 <irq6>:
    b3e8:	60                   	pusha  
    b3e9:	e8 c1 ea ff ff       	call   9eaf <irq6_handler>
    b3ee:	61                   	popa   
    b3ef:	cf                   	iret   

0000b3f0 <irq7>:
    b3f0:	60                   	pusha  
    b3f1:	e8 dc ea ff ff       	call   9ed2 <irq7_handler>
    b3f6:	61                   	popa   
    b3f7:	cf                   	iret   

0000b3f8 <irq8>:
    b3f8:	60                   	pusha  
    b3f9:	e8 f7 ea ff ff       	call   9ef5 <irq8_handler>
    b3fe:	61                   	popa   
    b3ff:	cf                   	iret   

0000b400 <irq9>:
    b400:	60                   	pusha  
    b401:	e8 12 eb ff ff       	call   9f18 <irq9_handler>
    b406:	61                   	popa   
    b407:	cf                   	iret   

0000b408 <irq10>:
    b408:	60                   	pusha  
    b409:	e8 2d eb ff ff       	call   9f3b <irq10_handler>
    b40e:	61                   	popa   
    b40f:	cf                   	iret   

0000b410 <irq11>:
    b410:	60                   	pusha  
    b411:	e8 48 eb ff ff       	call   9f5e <irq11_handler>
    b416:	61                   	popa   
    b417:	cf                   	iret   

0000b418 <irq12>:
    b418:	60                   	pusha  
    b419:	e8 63 eb ff ff       	call   9f81 <irq12_handler>
    b41e:	61                   	popa   
    b41f:	cf                   	iret   

0000b420 <irq13>:
    b420:	60                   	pusha  
    b421:	e8 7e eb ff ff       	call   9fa4 <irq13_handler>
    b426:	61                   	popa   
    b427:	cf                   	iret   

0000b428 <irq14>:
    b428:	60                   	pusha  
    b429:	e8 99 eb ff ff       	call   9fc7 <irq14_handler>
    b42e:	61                   	popa   
    b42f:	cf                   	iret   

0000b430 <irq15>:
    b430:	60                   	pusha  
    b431:	e8 b4 eb ff ff       	call   9fea <irq15_handler>
    b436:	61                   	popa   
    b437:	cf                   	iret   
    b438:	66 90                	xchg   %ax,%ax
    b43a:	66 90                	xchg   %ax,%ax
    b43c:	66 90                	xchg   %ax,%ax
    b43e:	66 90                	xchg   %ax,%ax

0000b440 <_FlushPagingCache_>:
    b440:	b8 00 10 01 00       	mov    $0x11000,%eax
    b445:	0f 22 d8             	mov    %eax,%cr3
    b448:	c3                   	ret    

0000b449 <_EnablingPaging_>:
    b449:	e8 f2 ff ff ff       	call   b440 <_FlushPagingCache_>
    b44e:	0f 20 c0             	mov    %cr0,%eax
    b451:	0d 01 00 00 80       	or     $0x80000001,%eax
    b456:	0f 22 c0             	mov    %eax,%cr0
    b459:	c3                   	ret    

0000b45a <PagingFault_Handler>:
    b45a:	58                   	pop    %eax
    b45b:	a3 80 b7 00 00       	mov    %eax,0xb780
    b460:	e8 dd ef ff ff       	call   a442 <Paging_fault>
    b465:	cf                   	iret   
    b466:	66 90                	xchg   %ax,%ax
    b468:	66 90                	xchg   %ax,%ax
    b46a:	66 90                	xchg   %ax,%ax
    b46c:	66 90                	xchg   %ax,%ax
    b46e:	66 90                	xchg   %ax,%ax

0000b470 <PIT_handler>:
    b470:	9c                   	pushf  
    b471:	e8 16 00 00 00       	call   b48c <irq_PIT>
    b476:	e8 0e f2 ff ff       	call   a689 <conserv_status_byte>
    b47b:	e8 a5 f2 ff ff       	call   a725 <sheduler_cpu_timer>
    b480:	90                   	nop
    b481:	90                   	nop
    b482:	90                   	nop
    b483:	90                   	nop
    b484:	90                   	nop
    b485:	90                   	nop
    b486:	90                   	nop
    b487:	90                   	nop
    b488:	90                   	nop
    b489:	90                   	nop
    b48a:	9d                   	popf   
    b48b:	cf                   	iret   

0000b48c <irq_PIT>:
    b48c:	a1 68 32 02 00       	mov    0x23268,%eax
    b491:	8b 1d 6c 32 02 00    	mov    0x2326c,%ebx
    b497:	01 05 60 32 02 00    	add    %eax,0x23260
    b49d:	11 1d 64 32 02 00    	adc    %ebx,0x23264
    b4a3:	6a 00                	push   $0x0
    b4a5:	e8 9e ef ff ff       	call   a448 <PIC_sendEOI>
    b4aa:	58                   	pop    %eax
    b4ab:	c3                   	ret    

0000b4ac <calculate_frequency>:
    b4ac:	60                   	pusha  
    b4ad:	8b 1d 04 20 01 00    	mov    0x12004,%ebx
    b4b3:	b8 00 00 01 00       	mov    $0x10000,%eax
    b4b8:	83 fb 12             	cmp    $0x12,%ebx
    b4bb:	76 34                	jbe    b4f1 <calculate_frequency.gotReloadValue>
    b4bd:	b8 01 00 00 00       	mov    $0x1,%eax
    b4c2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    b4c8:	73 27                	jae    b4f1 <calculate_frequency.gotReloadValue>
    b4ca:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b4cf:	ba 00 00 00 00       	mov    $0x0,%edx
    b4d4:	f7 f3                	div    %ebx
    b4d6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b4dc:	72 01                	jb     b4df <calculate_frequency.l1>
    b4de:	40                   	inc    %eax

0000b4df <calculate_frequency.l1>:
    b4df:	bb 03 00 00 00       	mov    $0x3,%ebx
    b4e4:	ba 00 00 00 00       	mov    $0x0,%edx
    b4e9:	f7 f3                	div    %ebx
    b4eb:	83 fa 01             	cmp    $0x1,%edx
    b4ee:	72 01                	jb     b4f1 <calculate_frequency.gotReloadValue>
    b4f0:	40                   	inc    %eax

0000b4f1 <calculate_frequency.gotReloadValue>:
    b4f1:	50                   	push   %eax
    b4f2:	66 a3 74 32 02 00    	mov    %ax,0x23274
    b4f8:	89 c3                	mov    %eax,%ebx
    b4fa:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b4ff:	ba 00 00 00 00       	mov    $0x0,%edx
    b504:	f7 f3                	div    %ebx
    b506:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b50c:	72 01                	jb     b50f <calculate_frequency.l3>
    b50e:	40                   	inc    %eax

0000b50f <calculate_frequency.l3>:
    b50f:	bb 03 00 00 00       	mov    $0x3,%ebx
    b514:	ba 00 00 00 00       	mov    $0x0,%edx
    b519:	f7 f3                	div    %ebx
    b51b:	83 fa 01             	cmp    $0x1,%edx
    b51e:	72 01                	jb     b521 <calculate_frequency.l4>
    b520:	40                   	inc    %eax

0000b521 <calculate_frequency.l4>:
    b521:	a3 70 32 02 00       	mov    %eax,0x23270
    b526:	5b                   	pop    %ebx
    b527:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    b52c:	f7 e3                	mul    %ebx
    b52e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    b532:	c1 ea 0a             	shr    $0xa,%edx
    b535:	89 15 6c 32 02 00    	mov    %edx,0x2326c
    b53b:	a3 68 32 02 00       	mov    %eax,0x23268
    b540:	61                   	popa   
    b541:	c3                   	ret    
    b542:	66 90                	xchg   %ax,%ax
    b544:	66 90                	xchg   %ax,%ax
    b546:	66 90                	xchg   %ax,%ax
    b548:	66 90                	xchg   %ax,%ax
    b54a:	66 90                	xchg   %ax,%ax
    b54c:	66 90                	xchg   %ax,%ax
    b54e:	66 90                	xchg   %ax,%ax

0000b550 <switch_to_task>:
    b550:	50                   	push   %eax
    b551:	8b 44 24 08          	mov    0x8(%esp),%eax
    b555:	89 58 04             	mov    %ebx,0x4(%eax)
    b558:	89 48 08             	mov    %ecx,0x8(%eax)
    b55b:	89 50 0c             	mov    %edx,0xc(%eax)
    b55e:	89 70 10             	mov    %esi,0x10(%eax)
    b561:	89 78 14             	mov    %edi,0x14(%eax)
    b564:	89 60 18             	mov    %esp,0x18(%eax)
    b567:	89 68 1c             	mov    %ebp,0x1c(%eax)
    b56a:	51                   	push   %ecx
    b56b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    b56f:	89 48 20             	mov    %ecx,0x20(%eax)
    b572:	59                   	pop    %ecx
    b573:	51                   	push   %ecx
    b574:	9c                   	pushf  
    b575:	59                   	pop    %ecx
    b576:	89 48 24             	mov    %ecx,0x24(%eax)
    b579:	59                   	pop    %ecx
    b57a:	51                   	push   %ecx
    b57b:	0f 20 d9             	mov    %cr3,%ecx
    b57e:	89 48 28             	mov    %ecx,0x28(%eax)
    b581:	59                   	pop    %ecx
    b582:	8c 40 2c             	mov    %es,0x2c(%eax)
    b585:	8c 68 2e             	mov    %gs,0x2e(%eax)
    b588:	8c 60 30             	mov    %fs,0x30(%eax)
    b58b:	51                   	push   %ecx
    b58c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    b590:	89 08                	mov    %ecx,(%eax)
    b592:	59                   	pop    %ecx
    b593:	58                   	pop    %eax
    b594:	8b 44 24 08          	mov    0x8(%esp),%eax
    b598:	8b 58 04             	mov    0x4(%eax),%ebx
    b59b:	8b 48 08             	mov    0x8(%eax),%ecx
    b59e:	8b 50 0c             	mov    0xc(%eax),%edx
    b5a1:	8b 70 10             	mov    0x10(%eax),%esi
    b5a4:	8b 78 14             	mov    0x14(%eax),%edi
    b5a7:	8b 60 18             	mov    0x18(%eax),%esp
    b5aa:	8b 68 1c             	mov    0x1c(%eax),%ebp
    b5ad:	51                   	push   %ecx
    b5ae:	8b 48 24             	mov    0x24(%eax),%ecx
    b5b1:	51                   	push   %ecx
    b5b2:	9d                   	popf   
    b5b3:	59                   	pop    %ecx
    b5b4:	51                   	push   %ecx
    b5b5:	8b 48 28             	mov    0x28(%eax),%ecx
    b5b8:	0f 22 d9             	mov    %ecx,%cr3
    b5bb:	59                   	pop    %ecx
    b5bc:	8e 40 2c             	mov    0x2c(%eax),%es
    b5bf:	8e 68 2e             	mov    0x2e(%eax),%gs
    b5c2:	8e 60 30             	mov    0x30(%eax),%fs
    b5c5:	8b 40 20             	mov    0x20(%eax),%eax
    b5c8:	89 04 24             	mov    %eax,(%esp)
    b5cb:	c3                   	ret    
