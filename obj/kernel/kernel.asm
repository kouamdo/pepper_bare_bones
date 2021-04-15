
bin/kernel.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00009000 <main>:
#include <kernel/printf.h>

extern void printf(const char* fmt, ...);

void main()
{
    9000:	55                   	push   %ebp
    9001:	89 e5                	mov    %esp,%ebp
    9003:	83 e4 f0             	and    $0xfffffff0,%esp
    //On initialise le necessaire avant de lancer la console

    cli;
    9006:	fa                   	cli    

    init_gdt();
    9007:	e8 2b 07 00 00       	call   9737 <init_gdt>

    init_idt();
    900c:	e8 5f 08 00 00       	call   9870 <init_idt>

    init_console();
    9011:	e8 76 06 00 00       	call   968c <init_console>

    sti;
    9016:	fb                   	sti    

    while (1)
    9017:	eb fe                	jmp    9017 <main+0x17>

00009019 <putchar>:
 * Print a number (base <= 16) in reverse order,
 */
void puts(const char* string);

void putchar(uint8_t c)
{
    9019:	55                   	push   %ebp
    901a:	89 e5                	mov    %esp,%ebp
    901c:	83 ec 18             	sub    $0x18,%esp
    901f:	8b 45 08             	mov    0x8(%ebp),%eax
    9022:	88 45 f4             	mov    %al,-0xc(%ebp)
    cputchar(READY_COLOR, c);
    9025:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    9029:	0f be c0             	movsbl %al,%eax
    902c:	83 ec 08             	sub    $0x8,%esp
    902f:	50                   	push   %eax
    9030:	6a 07                	push   $0x7
    9032:	e8 c3 04 00 00       	call   94fa <cputchar>
    9037:	83 c4 10             	add    $0x10,%esp
}
    903a:	90                   	nop
    903b:	c9                   	leave  
    903c:	c3                   	ret    

0000903d <printnum>:

static void printnum(uint32_t num, uint8_t base)
{
    903d:	55                   	push   %ebp
    903e:	89 e5                	mov    %esp,%ebp
    9040:	53                   	push   %ebx
    9041:	83 ec 14             	sub    $0x14,%esp
    9044:	8b 45 0c             	mov    0xc(%ebp),%eax
    9047:	88 45 f4             	mov    %al,-0xc(%ebp)
    if (num >= base) printnum((uint32_t)(num / base), base);
    904a:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    904e:	39 45 08             	cmp    %eax,0x8(%ebp)
    9051:	72 1f                	jb     9072 <printnum+0x35>
    9053:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    9057:	0f b6 5d f4          	movzbl -0xc(%ebp),%ebx
    905b:	8b 45 08             	mov    0x8(%ebp),%eax
    905e:	ba 00 00 00 00       	mov    $0x0,%edx
    9063:	f7 f3                	div    %ebx
    9065:	83 ec 08             	sub    $0x8,%esp
    9068:	51                   	push   %ecx
    9069:	50                   	push   %eax
    906a:	e8 ce ff ff ff       	call   903d <printnum>
    906f:	83 c4 10             	add    $0x10,%esp

    putchar("0123456789abcdef"[num % base]);
    9072:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    9076:	8b 45 08             	mov    0x8(%ebp),%eax
    9079:	ba 00 00 00 00       	mov    $0x0,%edx
    907e:	f7 f1                	div    %ecx
    9080:	89 d0                	mov    %edx,%eax
    9082:	0f b6 80 00 f0 00 00 	movzbl 0xf000(%eax),%eax
    9089:	0f b6 c0             	movzbl %al,%eax
    908c:	83 ec 0c             	sub    $0xc,%esp
    908f:	50                   	push   %eax
    9090:	e8 84 ff ff ff       	call   9019 <putchar>
    9095:	83 c4 10             	add    $0x10,%esp
}
    9098:	90                   	nop
    9099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    909c:	c9                   	leave  
    909d:	c3                   	ret    

0000909e <printf>:

void printf(const char* fmt, va_list arg)
{
    909e:	55                   	push   %ebp
    909f:	89 e5                	mov    %esp,%ebp
    90a1:	83 ec 18             	sub    $0x18,%esp
    char*    s;
    int*     p;

    const char* chr_tmp;

    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    90a4:	8b 45 08             	mov    0x8(%ebp),%eax
    90a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    90aa:	e9 36 01 00 00       	jmp    91e5 <printf+0x147>

        if (*chr_tmp == '%') {
    90af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90b2:	0f b6 00             	movzbl (%eax),%eax
    90b5:	3c 25                	cmp    $0x25,%al
    90b7:	0f 85 0c 01 00 00    	jne    91c9 <printf+0x12b>
            chr_tmp++;
    90bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            switch (*chr_tmp) {
    90c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90c4:	0f b6 00             	movzbl (%eax),%eax
    90c7:	0f be c0             	movsbl %al,%eax
    90ca:	83 e8 62             	sub    $0x62,%eax
    90cd:	83 f8 16             	cmp    $0x16,%eax
    90d0:	0f 87 0a 01 00 00    	ja     91e0 <printf+0x142>
    90d6:	8b 04 85 14 f0 00 00 	mov    0xf014(,%eax,4),%eax
    90dd:	ff e0                	jmp    *%eax
            case 'c':
                i = va_arg(arg, int32_t);
    90df:	8b 45 0c             	mov    0xc(%ebp),%eax
    90e2:	8d 50 04             	lea    0x4(%eax),%edx
    90e5:	89 55 0c             	mov    %edx,0xc(%ebp)
    90e8:	8b 00                	mov    (%eax),%eax
    90ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
                putchar(i);
    90ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    90f0:	0f b6 c0             	movzbl %al,%eax
    90f3:	83 ec 0c             	sub    $0xc,%esp
    90f6:	50                   	push   %eax
    90f7:	e8 1d ff ff ff       	call   9019 <putchar>
    90fc:	83 c4 10             	add    $0x10,%esp
                break;
    90ff:	e9 dd 00 00 00       	jmp    91e1 <printf+0x143>
            case 'd':
                i = va_arg(arg, int);
    9104:	8b 45 0c             	mov    0xc(%ebp),%eax
    9107:	8d 50 04             	lea    0x4(%eax),%edx
    910a:	89 55 0c             	mov    %edx,0xc(%ebp)
    910d:	8b 00                	mov    (%eax),%eax
    910f:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 10);
    9112:	83 ec 08             	sub    $0x8,%esp
    9115:	6a 0a                	push   $0xa
    9117:	ff 75 f0             	pushl  -0x10(%ebp)
    911a:	e8 1e ff ff ff       	call   903d <printnum>
    911f:	83 c4 10             	add    $0x10,%esp
                break;
    9122:	e9 ba 00 00 00       	jmp    91e1 <printf+0x143>
            case 'o':
                i = va_arg(arg, int32_t);
    9127:	8b 45 0c             	mov    0xc(%ebp),%eax
    912a:	8d 50 04             	lea    0x4(%eax),%edx
    912d:	89 55 0c             	mov    %edx,0xc(%ebp)
    9130:	8b 00                	mov    (%eax),%eax
    9132:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 8);
    9135:	83 ec 08             	sub    $0x8,%esp
    9138:	6a 08                	push   $0x8
    913a:	ff 75 f0             	pushl  -0x10(%ebp)
    913d:	e8 fb fe ff ff       	call   903d <printnum>
    9142:	83 c4 10             	add    $0x10,%esp
                break;
    9145:	e9 97 00 00 00       	jmp    91e1 <printf+0x143>
            case 'b':
                i = va_arg(arg, int32_t);
    914a:	8b 45 0c             	mov    0xc(%ebp),%eax
    914d:	8d 50 04             	lea    0x4(%eax),%edx
    9150:	89 55 0c             	mov    %edx,0xc(%ebp)
    9153:	8b 00                	mov    (%eax),%eax
    9155:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 2);
    9158:	83 ec 08             	sub    $0x8,%esp
    915b:	6a 02                	push   $0x2
    915d:	ff 75 f0             	pushl  -0x10(%ebp)
    9160:	e8 d8 fe ff ff       	call   903d <printnum>
    9165:	83 c4 10             	add    $0x10,%esp
                break;
    9168:	eb 77                	jmp    91e1 <printf+0x143>
            case 'x':
                i = va_arg(arg, int32_t);
    916a:	8b 45 0c             	mov    0xc(%ebp),%eax
    916d:	8d 50 04             	lea    0x4(%eax),%edx
    9170:	89 55 0c             	mov    %edx,0xc(%ebp)
    9173:	8b 00                	mov    (%eax),%eax
    9175:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 16);
    9178:	83 ec 08             	sub    $0x8,%esp
    917b:	6a 10                	push   $0x10
    917d:	ff 75 f0             	pushl  -0x10(%ebp)
    9180:	e8 b8 fe ff ff       	call   903d <printnum>
    9185:	83 c4 10             	add    $0x10,%esp
                break;
    9188:	eb 57                	jmp    91e1 <printf+0x143>
            case 's':
                s = va_arg(arg, char*);
    918a:	8b 45 0c             	mov    0xc(%ebp),%eax
    918d:	8d 50 04             	lea    0x4(%eax),%edx
    9190:	89 55 0c             	mov    %edx,0xc(%ebp)
    9193:	8b 00                	mov    (%eax),%eax
    9195:	89 45 ec             	mov    %eax,-0x14(%ebp)
                puts(s);
    9198:	83 ec 0c             	sub    $0xc,%esp
    919b:	ff 75 ec             	pushl  -0x14(%ebp)
    919e:	e8 54 00 00 00       	call   91f7 <puts>
    91a3:	83 c4 10             	add    $0x10,%esp
                break;
    91a6:	eb 39                	jmp    91e1 <printf+0x143>
            case 'p':
                p = va_arg(arg, void*);
    91a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    91ab:	8d 50 04             	lea    0x4(%eax),%edx
    91ae:	89 55 0c             	mov    %edx,0xc(%ebp)
    91b1:	8b 00                	mov    (%eax),%eax
    91b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
                printnum((uint32_t)p, 16);
    91b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    91b9:	83 ec 08             	sub    $0x8,%esp
    91bc:	6a 10                	push   $0x10
    91be:	50                   	push   %eax
    91bf:	e8 79 fe ff ff       	call   903d <printnum>
    91c4:	83 c4 10             	add    $0x10,%esp
                break;
    91c7:	eb 18                	jmp    91e1 <printf+0x143>
                break;
            }
        }

        else
            putchar(*chr_tmp);
    91c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91cc:	0f b6 00             	movzbl (%eax),%eax
    91cf:	0f b6 c0             	movzbl %al,%eax
    91d2:	83 ec 0c             	sub    $0xc,%esp
    91d5:	50                   	push   %eax
    91d6:	e8 3e fe ff ff       	call   9019 <putchar>
    91db:	83 c4 10             	add    $0x10,%esp
    91de:	eb 01                	jmp    91e1 <printf+0x143>
                break;
    91e0:	90                   	nop
    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    91e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    91e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91e8:	0f b6 00             	movzbl (%eax),%eax
    91eb:	84 c0                	test   %al,%al
    91ed:	0f 85 bc fe ff ff    	jne    90af <printf+0x11>
    }

    va_end(arg);
}
    91f3:	90                   	nop
    91f4:	90                   	nop
    91f5:	c9                   	leave  
    91f6:	c3                   	ret    

000091f7 <puts>:

void puts(const char* string)
{
    91f7:	55                   	push   %ebp
    91f8:	89 e5                	mov    %esp,%ebp
    91fa:	83 ec 08             	sub    $0x8,%esp
    if (*string != '\0') {
    91fd:	8b 45 08             	mov    0x8(%ebp),%eax
    9200:	0f b6 00             	movzbl (%eax),%eax
    9203:	84 c0                	test   %al,%al
    9205:	74 2a                	je     9231 <puts+0x3a>
        putchar(*string);
    9207:	8b 45 08             	mov    0x8(%ebp),%eax
    920a:	0f b6 00             	movzbl (%eax),%eax
    920d:	0f b6 c0             	movzbl %al,%eax
    9210:	83 ec 0c             	sub    $0xc,%esp
    9213:	50                   	push   %eax
    9214:	e8 00 fe ff ff       	call   9019 <putchar>
    9219:	83 c4 10             	add    $0x10,%esp
        puts(string++);
    921c:	8b 45 08             	mov    0x8(%ebp),%eax
    921f:	8d 50 01             	lea    0x1(%eax),%edx
    9222:	89 55 08             	mov    %edx,0x8(%ebp)
    9225:	83 ec 0c             	sub    $0xc,%esp
    9228:	50                   	push   %eax
    9229:	e8 c9 ff ff ff       	call   91f7 <puts>
    922e:	83 c4 10             	add    $0x10,%esp
    }
    9231:	90                   	nop
    9232:	c9                   	leave  
    9233:	c3                   	ret    

00009234 <_strcmp_>:
#include "../../include/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    9234:	55                   	push   %ebp
    9235:	89 e5                	mov    %esp,%ebp
    9237:	53                   	push   %ebx
    9238:	83 ec 04             	sub    $0x4,%esp
    if (_strlen_(str2) != _strlen_(str1))
    923b:	83 ec 0c             	sub    $0xc,%esp
    923e:	ff 75 0c             	pushl  0xc(%ebp)
    9241:	e8 59 00 00 00       	call   929f <_strlen_>
    9246:	83 c4 10             	add    $0x10,%esp
    9249:	89 c3                	mov    %eax,%ebx
    924b:	83 ec 0c             	sub    $0xc,%esp
    924e:	ff 75 08             	pushl  0x8(%ebp)
    9251:	e8 49 00 00 00       	call   929f <_strlen_>
    9256:	83 c4 10             	add    $0x10,%esp
    9259:	38 c3                	cmp    %al,%bl
    925b:	74 0f                	je     926c <_strcmp_+0x38>
        return 0;
    925d:	b8 00 00 00 00       	mov    $0x0,%eax
    9262:	eb 36                	jmp    929a <_strcmp_+0x66>

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
    9264:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        str2++;
    9268:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while ((*str1 == *str2) && (*str1 != '\000')) {
    926c:	8b 45 08             	mov    0x8(%ebp),%eax
    926f:	0f b6 10             	movzbl (%eax),%edx
    9272:	8b 45 0c             	mov    0xc(%ebp),%eax
    9275:	0f b6 00             	movzbl (%eax),%eax
    9278:	38 c2                	cmp    %al,%dl
    927a:	75 0a                	jne    9286 <_strcmp_+0x52>
    927c:	8b 45 08             	mov    0x8(%ebp),%eax
    927f:	0f b6 00             	movzbl (%eax),%eax
    9282:	84 c0                	test   %al,%al
    9284:	75 de                	jne    9264 <_strcmp_+0x30>
    }

    return *str1 == *str2;
    9286:	8b 45 08             	mov    0x8(%ebp),%eax
    9289:	0f b6 10             	movzbl (%eax),%edx
    928c:	8b 45 0c             	mov    0xc(%ebp),%eax
    928f:	0f b6 00             	movzbl (%eax),%eax
    9292:	38 c2                	cmp    %al,%dl
    9294:	0f 94 c0             	sete   %al
    9297:	0f b6 c0             	movzbl %al,%eax
}
    929a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    929d:	c9                   	leave  
    929e:	c3                   	ret    

0000929f <_strlen_>:

uint8_t _strlen_(char* str)
{
    929f:	55                   	push   %ebp
    92a0:	89 e5                	mov    %esp,%ebp
    92a2:	83 ec 10             	sub    $0x10,%esp
    if (*str == '\000')
    92a5:	8b 45 08             	mov    0x8(%ebp),%eax
    92a8:	0f b6 00             	movzbl (%eax),%eax
    92ab:	84 c0                	test   %al,%al
    92ad:	75 07                	jne    92b6 <_strlen_+0x17>
        return 0;
    92af:	b8 00 00 00 00       	mov    $0x0,%eax
    92b4:	eb 22                	jmp    92d8 <_strlen_+0x39>

    uint8_t i = 1;
    92b6:	c6 45 ff 01          	movb   $0x1,-0x1(%ebp)

    while (*str != '\000') {
    92ba:	eb 0e                	jmp    92ca <_strlen_+0x2b>
        str++;
    92bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        i++;
    92c0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    92c4:	83 c0 01             	add    $0x1,%eax
    92c7:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (*str != '\000') {
    92ca:	8b 45 08             	mov    0x8(%ebp),%eax
    92cd:	0f b6 00             	movzbl (%eax),%eax
    92d0:	84 c0                	test   %al,%al
    92d2:	75 e8                	jne    92bc <_strlen_+0x1d>
    }

    return i;
    92d4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
    92d8:	c9                   	leave  
    92d9:	c3                   	ret    

000092da <_strcpy_>:

void* _strcpy_(char* dest, char* src)
{
    92da:	55                   	push   %ebp
    92db:	89 e5                	mov    %esp,%ebp
    92dd:	83 ec 10             	sub    $0x10,%esp
    if (dest == NULL)
    92e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    92e4:	75 07                	jne    92ed <_strcpy_+0x13>
        return (void*)NULL;
    92e6:	b8 00 00 00 00       	mov    $0x0,%eax
    92eb:	eb 46                	jmp    9333 <_strcpy_+0x59>

    uint8_t i = 0;
    92ed:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    while (src[i] != '\000') {
    92f1:	eb 21                	jmp    9314 <_strcpy_+0x3a>
        dest[i] = src[i];
    92f3:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    92f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    92fa:	01 d0                	add    %edx,%eax
    92fc:	0f b6 4d ff          	movzbl -0x1(%ebp),%ecx
    9300:	8b 55 08             	mov    0x8(%ebp),%edx
    9303:	01 ca                	add    %ecx,%edx
    9305:	0f b6 00             	movzbl (%eax),%eax
    9308:	88 02                	mov    %al,(%edx)
        i++;
    930a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    930e:	83 c0 01             	add    $0x1,%eax
    9311:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (src[i] != '\000') {
    9314:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9318:	8b 45 0c             	mov    0xc(%ebp),%eax
    931b:	01 d0                	add    %edx,%eax
    931d:	0f b6 00             	movzbl (%eax),%eax
    9320:	84 c0                	test   %al,%al
    9322:	75 cf                	jne    92f3 <_strcpy_+0x19>
    }

    dest[i] = '\000';
    9324:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9328:	8b 45 08             	mov    0x8(%ebp),%eax
    932b:	01 d0                	add    %edx,%eax
    932d:	c6 00 00             	movb   $0x0,(%eax)

    return (void*)dest;
    9330:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9333:	c9                   	leave  
    9334:	c3                   	ret    

00009335 <memcpy>:

void* memcpy(void* dest, const void* src, uint32_t size)
{
    9335:	55                   	push   %ebp
    9336:	89 e5                	mov    %esp,%ebp
    9338:	83 ec 10             	sub    $0x10,%esp
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    933b:	8b 45 08             	mov    0x8(%ebp),%eax
    933e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    _src_ = (char*)src;
    9341:	8b 45 0c             	mov    0xc(%ebp),%eax
    9344:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (size) {
    9347:	eb 1b                	jmp    9364 <memcpy+0x2f>
        *(_dest_++) = *(_src_++);
    9349:	8b 55 f8             	mov    -0x8(%ebp),%edx
    934c:	8d 42 01             	lea    0x1(%edx),%eax
    934f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    9352:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9355:	8d 48 01             	lea    0x1(%eax),%ecx
    9358:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    935b:	0f b6 12             	movzbl (%edx),%edx
    935e:	88 10                	mov    %dl,(%eax)
        size--;
    9360:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (size) {
    9364:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    9368:	75 df                	jne    9349 <memcpy+0x14>
    }

    return (void*)dest;
    936a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    936d:	c9                   	leave  
    936e:	c3                   	ret    

0000936f <memset>:

void* memset(void* mem, void* data, uint32_t size)
{
    936f:	55                   	push   %ebp
    9370:	89 e5                	mov    %esp,%ebp
    9372:	83 ec 10             	sub    $0x10,%esp
    if (!mem)
    9375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    9379:	75 07                	jne    9382 <memset+0x13>
        return NULL;
    937b:	b8 00 00 00 00       	mov    $0x0,%eax
    9380:	eb 21                	jmp    93a3 <memset+0x34>

    uint32_t* dest = mem;
    9382:	8b 45 08             	mov    0x8(%ebp),%eax
    9385:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (size) {
    9388:	eb 10                	jmp    939a <memset+0x2b>
        *dest = (uint32_t)data;
    938a:	8b 55 0c             	mov    0xc(%ebp),%edx
    938d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9390:	89 10                	mov    %edx,(%eax)
        size--;
    9392:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
        dest += 4;
    9396:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    while (size) {
    939a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    939e:	75 ea                	jne    938a <memset+0x1b>
    }

    return (void*)mem;
    93a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    93a3:	c9                   	leave  
    93a4:	c3                   	ret    

000093a5 <_memcmp_>:

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    93a5:	55                   	push   %ebp
    93a6:	89 e5                	mov    %esp,%ebp
    93a8:	83 ec 10             	sub    $0x10,%esp
    char* mem_1 = (char*)src_1;
    93ab:	8b 45 08             	mov    0x8(%ebp),%eax
    93ae:	89 45 fc             	mov    %eax,-0x4(%ebp)

    char* mem_2 = (char*)src_2;
    93b1:	8b 45 0c             	mov    0xc(%ebp),%eax
    93b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

    uint32_t i = 0;
    93b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (i < size && *mem_1 == *mem_2) {
    93be:	eb 0c                	jmp    93cc <_memcmp_+0x27>
        i++;
    93c0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        mem_1++;
    93c4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
        mem_2++;
    93c8:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (i < size && *mem_1 == *mem_2) {
    93cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    93cf:	3b 45 10             	cmp    0x10(%ebp),%eax
    93d2:	73 10                	jae    93e4 <_memcmp_+0x3f>
    93d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    93d7:	0f b6 10             	movzbl (%eax),%edx
    93da:	8b 45 f8             	mov    -0x8(%ebp),%eax
    93dd:	0f b6 00             	movzbl (%eax),%eax
    93e0:	38 c2                	cmp    %al,%dl
    93e2:	74 dc                	je     93c0 <_memcmp_+0x1b>
    }

    return i == size;
    93e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    93e7:	3b 45 10             	cmp    0x10(%ebp),%eax
    93ea:	0f 94 c0             	sete   %al
    93ed:	0f b6 c0             	movzbl %al,%eax
    93f0:	c9                   	leave  
    93f1:	c3                   	ret    

000093f2 <cclean>:

void move_cursor(uint8_t x, uint8_t y);
void show_cursor(void);

void volatile cclean()
{
    93f2:	55                   	push   %ebp
    93f3:	89 e5                	mov    %esp,%ebp
    93f5:	83 ec 18             	sub    $0x18,%esp
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    93f8:	c7 45 f0 00 80 0b 00 	movl   $0xb8000,-0x10(%ebp)
    int            i      = 0;
    93ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i <= 160 * 25) {
    9406:	eb 1d                	jmp    9425 <cclean+0x33>
        screen[i]     = ' ';
    9408:	8b 55 f4             	mov    -0xc(%ebp),%edx
    940b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    940e:	01 d0                	add    %edx,%eax
    9410:	c6 00 20             	movb   $0x20,(%eax)
        screen[i + 1] = 0x0;
    9413:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9416:	8d 50 01             	lea    0x1(%eax),%edx
    9419:	8b 45 f0             	mov    -0x10(%ebp),%eax
    941c:	01 d0                	add    %edx,%eax
    941e:	c6 00 00             	movb   $0x0,(%eax)
        i += 2;
    9421:	83 45 f4 02          	addl   $0x2,-0xc(%ebp)
    while (i <= 160 * 25) {
    9425:	81 7d f4 a0 0f 00 00 	cmpl   $0xfa0,-0xc(%ebp)
    942c:	7e da                	jle    9408 <cclean+0x16>
    }
    cputchar(READY_COLOR, 'K');
    942e:	83 ec 08             	sub    $0x8,%esp
    9431:	6a 4b                	push   $0x4b
    9433:	6a 07                	push   $0x7
    9435:	e8 c0 00 00 00       	call   94fa <cputchar>
    943a:	83 c4 10             	add    $0x10,%esp
    cputchar(READY_COLOR, '>');
    943d:	83 ec 08             	sub    $0x8,%esp
    9440:	6a 3e                	push   $0x3e
    9442:	6a 07                	push   $0x7
    9444:	e8 b1 00 00 00       	call   94fa <cputchar>
    9449:	83 c4 10             	add    $0x10,%esp
    cputchar(READY_COLOR, ' ');
    944c:	83 ec 08             	sub    $0x8,%esp
    944f:	6a 20                	push   $0x20
    9451:	6a 07                	push   $0x7
    9453:	e8 a2 00 00 00       	call   94fa <cputchar>
    9458:	83 c4 10             	add    $0x10,%esp

    CURSOR_X = 3;
    945b:	c7 05 04 00 01 00 03 	movl   $0x3,0x10004
    9462:	00 00 00 
    CURSOR_Y = 0;
    9465:	c7 05 00 00 01 00 00 	movl   $0x0,0x10000
    946c:	00 00 00 
}
    946f:	90                   	nop
    9470:	c9                   	leave  
    9471:	c3                   	ret    

00009472 <cscrollup>:

void volatile cscrollup()
{
    9472:	55                   	push   %ebp
    9473:	89 e5                	mov    %esp,%ebp
    9475:	81 ec b8 00 00 00    	sub    $0xb8,%esp
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    947b:	c7 45 f0 00 8f 0b 00 	movl   $0xb8f00,-0x10(%ebp)
    unsigned char  b[160];
    int            i;
    for (i = 0; i < 160; i++)
    9482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9489:	eb 1c                	jmp    94a7 <cscrollup+0x35>
        b[i] = v[i];
    948b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    948e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9491:	01 d0                	add    %edx,%eax
    9493:	0f b6 00             	movzbl (%eax),%eax
    9496:	8d 8d 50 ff ff ff    	lea    -0xb0(%ebp),%ecx
    949c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    949f:	01 ca                	add    %ecx,%edx
    94a1:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    94a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    94a7:	81 7d f4 9f 00 00 00 	cmpl   $0x9f,-0xc(%ebp)
    94ae:	7e db                	jle    948b <cscrollup+0x19>

    cclean();
    94b0:	e8 3d ff ff ff       	call   93f2 <cclean>

    v = (unsigned char*)(VIDEO_MEM);
    94b5:	c7 45 f0 00 80 0b 00 	movl   $0xb8000,-0x10(%ebp)

    for (i = 0; i < 160; i++)
    94bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    94c3:	eb 1c                	jmp    94e1 <cscrollup+0x6f>
        v[i] = b[i];
    94c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    94c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    94cb:	01 c2                	add    %eax,%edx
    94cd:	8d 8d 50 ff ff ff    	lea    -0xb0(%ebp),%ecx
    94d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    94d6:	01 c8                	add    %ecx,%eax
    94d8:	0f b6 00             	movzbl (%eax),%eax
    94db:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    94dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    94e1:	81 7d f4 9f 00 00 00 	cmpl   $0x9f,-0xc(%ebp)
    94e8:	7e db                	jle    94c5 <cscrollup+0x53>

    CURSOR_Y++;
    94ea:	a1 00 00 01 00       	mov    0x10000,%eax
    94ef:	83 c0 01             	add    $0x1,%eax
    94f2:	a3 00 00 01 00       	mov    %eax,0x10000
}
    94f7:	90                   	nop
    94f8:	c9                   	leave  
    94f9:	c3                   	ret    

000094fa <cputchar>:

void volatile cputchar(unsigned char color, const char c)
{
    94fa:	55                   	push   %ebp
    94fb:	89 e5                	mov    %esp,%ebp
    94fd:	83 ec 28             	sub    $0x28,%esp
    9500:	8b 55 08             	mov    0x8(%ebp),%edx
    9503:	8b 45 0c             	mov    0xc(%ebp),%eax
    9506:	88 55 e4             	mov    %dl,-0x1c(%ebp)
    9509:	88 45 e0             	mov    %al,-0x20(%ebp)

    if ((CURSOR_Y) <= (25)) {
    950c:	a1 00 00 01 00       	mov    0x10000,%eax
    9511:	83 f8 19             	cmp    $0x19,%eax
    9514:	0f 8f c0 00 00 00    	jg     95da <cputchar+0xe0>
        if (c == '\n') {
    951a:	80 7d e0 0a          	cmpb   $0xa,-0x20(%ebp)
    951e:	75 1c                	jne    953c <cputchar+0x42>
            CURSOR_X = 0;
    9520:	c7 05 04 00 01 00 00 	movl   $0x0,0x10004
    9527:	00 00 00 
            CURSOR_Y++;
    952a:	a1 00 00 01 00       	mov    0x10000,%eax
    952f:	83 c0 01             	add    $0x1,%eax
    9532:	a3 00 00 01 00       	mov    %eax,0x10000
        }
    }

    else
        cclean();
}
    9537:	e9 a3 00 00 00       	jmp    95df <cputchar+0xe5>
        else if (c == '\t')
    953c:	80 7d e0 09          	cmpb   $0x9,-0x20(%ebp)
    9540:	75 12                	jne    9554 <cputchar+0x5a>
            CURSOR_X += 5;
    9542:	a1 04 00 01 00       	mov    0x10004,%eax
    9547:	83 c0 05             	add    $0x5,%eax
    954a:	a3 04 00 01 00       	mov    %eax,0x10004
}
    954f:	e9 8b 00 00 00       	jmp    95df <cputchar+0xe5>
        else if (c == 0x08)
    9554:	80 7d e0 08          	cmpb   $0x8,-0x20(%ebp)
    9558:	75 3a                	jne    9594 <cputchar+0x9a>
            CURSOR_X--;
    955a:	a1 04 00 01 00       	mov    0x10004,%eax
    955f:	83 e8 01             	sub    $0x1,%eax
    9562:	a3 04 00 01 00       	mov    %eax,0x10004
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9567:	c7 45 f0 00 80 0b 00 	movl   $0xb8000,-0x10(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    956e:	8b 15 00 00 01 00    	mov    0x10000,%edx
    9574:	89 d0                	mov    %edx,%eax
    9576:	c1 e0 02             	shl    $0x2,%eax
    9579:	01 d0                	add    %edx,%eax
    957b:	c1 e0 04             	shl    $0x4,%eax
    957e:	89 c2                	mov    %eax,%edx
    9580:	a1 04 00 01 00       	mov    0x10004,%eax
    9585:	01 d0                	add    %edx,%eax
    9587:	01 c0                	add    %eax,%eax
    9589:	01 45 f0             	add    %eax,-0x10(%ebp)
            *v = ' ';
    958c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    958f:	c6 00 20             	movb   $0x20,(%eax)
}
    9592:	eb 4b                	jmp    95df <cputchar+0xe5>
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9594:	c7 45 f4 00 80 0b 00 	movl   $0xb8000,-0xc(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    959b:	8b 15 00 00 01 00    	mov    0x10000,%edx
    95a1:	89 d0                	mov    %edx,%eax
    95a3:	c1 e0 02             	shl    $0x2,%eax
    95a6:	01 d0                	add    %edx,%eax
    95a8:	c1 e0 04             	shl    $0x4,%eax
    95ab:	89 c2                	mov    %eax,%edx
    95ad:	a1 04 00 01 00       	mov    0x10004,%eax
    95b2:	01 d0                	add    %edx,%eax
    95b4:	01 c0                	add    %eax,%eax
    95b6:	01 45 f4             	add    %eax,-0xc(%ebp)
            *v = c;
    95b9:	0f b6 55 e0          	movzbl -0x20(%ebp),%edx
    95bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    95c0:	88 10                	mov    %dl,(%eax)
            *(v + 1) = READY_COLOR;
    95c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    95c5:	83 c0 01             	add    $0x1,%eax
    95c8:	c6 00 07             	movb   $0x7,(%eax)
            CURSOR_X++;
    95cb:	a1 04 00 01 00       	mov    0x10004,%eax
    95d0:	83 c0 01             	add    $0x1,%eax
    95d3:	a3 04 00 01 00       	mov    %eax,0x10004
}
    95d8:	eb 05                	jmp    95df <cputchar+0xe5>
        cclean();
    95da:	e8 13 fe ff ff       	call   93f2 <cclean>
}
    95df:	90                   	nop
    95e0:	c9                   	leave  
    95e1:	c3                   	ret    

000095e2 <move_cursor>:

void move_cursor(uint8_t x, uint8_t y)
{
    95e2:	55                   	push   %ebp
    95e3:	89 e5                	mov    %esp,%ebp
    95e5:	83 ec 18             	sub    $0x18,%esp
    95e8:	8b 55 08             	mov    0x8(%ebp),%edx
    95eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    95ee:	88 55 ec             	mov    %dl,-0x14(%ebp)
    95f1:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t c_pos;

    c_pos = y * 80 + x;
    95f4:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    95f8:	89 d0                	mov    %edx,%eax
    95fa:	c1 e0 02             	shl    $0x2,%eax
    95fd:	01 d0                	add    %edx,%eax
    95ff:	c1 e0 04             	shl    $0x4,%eax
    9602:	89 c2                	mov    %eax,%edx
    9604:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    9608:	01 d0                	add    %edx,%eax
    960a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    outb(0x3d4, 0x0f);
    960e:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9613:	b8 0f 00 00 00       	mov    $0xf,%eax
    9618:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)c_pos);
    9619:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    961d:	ba d5 03 00 00       	mov    $0x3d5,%edx
    9622:	ee                   	out    %al,(%dx)
    outb(0x3d4, 0x0e);
    9623:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9628:	b8 0e 00 00 00       	mov    $0xe,%eax
    962d:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)(c_pos >> 8));
    962e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    9632:	66 c1 e8 08          	shr    $0x8,%ax
    9636:	ba d5 03 00 00       	mov    $0x3d5,%edx
    963b:	ee                   	out    %al,(%dx)
}
    963c:	90                   	nop
    963d:	c9                   	leave  
    963e:	c3                   	ret    

0000963f <show_cursor>:

void show_cursor(void)
{
    963f:	55                   	push   %ebp
    9640:	89 e5                	mov    %esp,%ebp
    move_cursor(CURSOR_X, CURSOR_Y);
    9642:	a1 00 00 01 00       	mov    0x10000,%eax
    9647:	0f b6 d0             	movzbl %al,%edx
    964a:	a1 04 00 01 00       	mov    0x10004,%eax
    964f:	0f b6 c0             	movzbl %al,%eax
    9652:	52                   	push   %edx
    9653:	50                   	push   %eax
    9654:	e8 89 ff ff ff       	call   95e2 <move_cursor>
    9659:	83 c4 08             	add    $0x8,%esp
}
    965c:	90                   	nop
    965d:	c9                   	leave  
    965e:	c3                   	ret    

0000965f <console_service_keyboard>:

void console_service_keyboard()
{
    965f:	55                   	push   %ebp
    9660:	89 e5                	mov    %esp,%ebp
    9662:	83 ec 08             	sub    $0x8,%esp
    if (get_ASCII_code_keyboard() != 0) {
    9665:	e8 1e 0b 00 00       	call   a188 <get_ASCII_code_keyboard>
    966a:	84 c0                	test   %al,%al
    966c:	74 1b                	je     9689 <console_service_keyboard+0x2a>
        cputchar(READY_COLOR, get_ASCII_code_keyboard());
    966e:	e8 15 0b 00 00       	call   a188 <get_ASCII_code_keyboard>
    9673:	0f be c0             	movsbl %al,%eax
    9676:	83 ec 08             	sub    $0x8,%esp
    9679:	50                   	push   %eax
    967a:	6a 07                	push   $0x7
    967c:	e8 79 fe ff ff       	call   94fa <cputchar>
    9681:	83 c4 10             	add    $0x10,%esp
        show_cursor();
    9684:	e8 b6 ff ff ff       	call   963f <show_cursor>
    }
}
    9689:	90                   	nop
    968a:	c9                   	leave  
    968b:	c3                   	ret    

0000968c <init_console>:

void init_console()
{
    968c:	55                   	push   %ebp
    968d:	89 e5                	mov    %esp,%ebp
    968f:	83 ec 08             	sub    $0x8,%esp
    cclean();
    9692:	e8 5b fd ff ff       	call   93f2 <cclean>
    kbd_init(); //Init keyboard
    9697:	e8 cf 08 00 00       	call   9f6b <kbd_init>
    //init Video graphics here
    969c:	90                   	nop
    969d:	c9                   	leave  
    969e:	c3                   	ret    

0000969f <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    969f:	55                   	push   %ebp
    96a0:	89 e5                	mov    %esp,%ebp
    96a2:	90                   	nop
    96a3:	5d                   	pop    %ebp
    96a4:	c3                   	ret    

000096a5 <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    96a5:	55                   	push   %ebp
    96a6:	89 e5                	mov    %esp,%ebp
    96a8:	90                   	nop
    96a9:	5d                   	pop    %ebp
    96aa:	c3                   	ret    

000096ab <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    96ab:	55                   	push   %ebp
    96ac:	89 e5                	mov    %esp,%ebp
    96ae:	83 ec 08             	sub    $0x8,%esp
    96b1:	8b 55 10             	mov    0x10(%ebp),%edx
    96b4:	8b 45 14             	mov    0x14(%ebp),%eax
    96b7:	88 55 fc             	mov    %dl,-0x4(%ebp)
    96ba:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15 = (limite & 0xFFFF);
    96bd:	8b 45 0c             	mov    0xc(%ebp),%eax
    96c0:	89 c2                	mov    %eax,%edx
    96c2:	8b 45 18             	mov    0x18(%ebp),%eax
    96c5:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    96c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    96cb:	c1 e8 10             	shr    $0x10,%eax
    96ce:	83 e0 0f             	and    $0xf,%eax
    96d1:	8b 55 18             	mov    0x18(%ebp),%edx
    96d4:	83 e0 0f             	and    $0xf,%eax
    96d7:	89 c1                	mov    %eax,%ecx
    96d9:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    96dd:	83 e0 f0             	and    $0xfffffff0,%eax
    96e0:	09 c8                	or     %ecx,%eax
    96e2:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15 = (base & 0xFFFF);
    96e5:	8b 45 08             	mov    0x8(%ebp),%eax
    96e8:	89 c2                	mov    %eax,%edx
    96ea:	8b 45 18             	mov    0x18(%ebp),%eax
    96ed:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    96f1:	8b 45 08             	mov    0x8(%ebp),%eax
    96f4:	c1 e8 10             	shr    $0x10,%eax
    96f7:	89 c2                	mov    %eax,%edx
    96f9:	8b 45 18             	mov    0x18(%ebp),%eax
    96fc:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    96ff:	8b 45 08             	mov    0x8(%ebp),%eax
    9702:	c1 e8 18             	shr    $0x18,%eax
    9705:	89 c2                	mov    %eax,%edx
    9707:	8b 45 18             	mov    0x18(%ebp),%eax
    970a:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags = flags;
    970d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    9711:	83 e0 0f             	and    $0xf,%eax
    9714:	89 c2                	mov    %eax,%edx
    9716:	8b 45 18             	mov    0x18(%ebp),%eax
    9719:	89 d1                	mov    %edx,%ecx
    971b:	c1 e1 04             	shl    $0x4,%ecx
    971e:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    9722:	83 e2 0f             	and    $0xf,%edx
    9725:	09 ca                	or     %ecx,%edx
    9727:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    972a:	8b 45 18             	mov    0x18(%ebp),%eax
    972d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    9731:	88 50 05             	mov    %dl,0x5(%eax)
}
    9734:	90                   	nop
    9735:	c9                   	leave  
    9736:	c3                   	ret    

00009737 <init_gdt>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt(void)
{
    9737:	55                   	push   %ebp
    9738:	89 e5                	mov    %esp,%ebp
    973a:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    973d:	a1 08 00 01 00       	mov    0x10008,%eax
    9742:	50                   	push   %eax
    9743:	6a 00                	push   $0x0
    9745:	6a 00                	push   $0x0
    9747:	6a 00                	push   $0x0
    9749:	6a 00                	push   $0x0
    974b:	e8 5b ff ff ff       	call   96ab <init_gdt_entry>
    9750:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    9753:	a1 08 00 01 00       	mov    0x10008,%eax
    9758:	83 c0 08             	add    $0x8,%eax
    975b:	50                   	push   %eax
    975c:	6a 04                	push   $0x4
    975e:	68 9a 00 00 00       	push   $0x9a
    9763:	68 ff ff 0f 00       	push   $0xfffff
    9768:	6a 00                	push   $0x0
    976a:	e8 3c ff ff ff       	call   96ab <init_gdt_entry>
    976f:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    9772:	a1 08 00 01 00       	mov    0x10008,%eax
    9777:	83 c0 10             	add    $0x10,%eax
    977a:	50                   	push   %eax
    977b:	6a 04                	push   $0x4
    977d:	68 92 00 00 00       	push   $0x92
    9782:	68 ff ff 0f 00       	push   $0xfffff
    9787:	6a 00                	push   $0x0
    9789:	e8 1d ff ff ff       	call   96ab <init_gdt_entry>
    978e:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    9791:	a1 08 00 01 00       	mov    0x10008,%eax
    9796:	83 c0 18             	add    $0x18,%eax
    9799:	50                   	push   %eax
    979a:	6a 04                	push   $0x4
    979c:	68 96 00 00 00       	push   $0x96
    97a1:	68 ff ff 0f 00       	push   $0xfffff
    97a6:	6a 00                	push   $0x0
    97a8:	e8 fe fe ff ff       	call   96ab <init_gdt_entry>
    97ad:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Segment de tâches
    init_gdt_entry(0, 0xFFFFFF, TSS_PRIVILEGE_0,
    97b0:	a1 08 00 01 00       	mov    0x10008,%eax
    97b5:	83 c0 20             	add    $0x20,%eax
    97b8:	50                   	push   %eax
    97b9:	6a 04                	push   $0x4
    97bb:	68 89 00 00 00       	push   $0x89
    97c0:	68 ff ff ff 00       	push   $0xffffff
    97c5:	6a 00                	push   $0x0
    97c7:	e8 df fe ff ff       	call   96ab <init_gdt_entry>
    97cc:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[4]);

    // Chargement de la GDT
    load_gdt();
    97cf:	e8 92 1a 00 00       	call   b266 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    97d4:	66 b8 10 00          	mov    $0x10,%ax
    97d8:	8e d8                	mov    %eax,%ds
    97da:	8e c0                	mov    %eax,%es
    97dc:	8e e0                	mov    %eax,%fs
    97de:	8e e8                	mov    %eax,%gs
    97e0:	66 b8 18 00          	mov    $0x18,%ax
    97e4:	8e d0                	mov    %eax,%ss
    97e6:	ea ed 97 00 00 08 00 	ljmp   $0x8,$0x97ed

000097ed <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    97ed:	90                   	nop
    97ee:	c9                   	leave  
    97ef:	c3                   	ret    

000097f0 <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    97f0:	55                   	push   %ebp
    97f1:	89 e5                	mov    %esp,%ebp
    97f3:	83 ec 18             	sub    $0x18,%esp
    97f6:	8b 45 08             	mov    0x8(%ebp),%eax
    97f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    97fc:	8b 55 18             	mov    0x18(%ebp),%edx
    97ff:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    9803:	89 c8                	mov    %ecx,%eax
    9805:	88 45 f8             	mov    %al,-0x8(%ebp)
    9808:	8b 45 10             	mov    0x10(%ebp),%eax
    980b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    980e:	8b 45 14             	mov    0x14(%ebp),%eax
    9811:	89 45 f4             	mov    %eax,-0xc(%ebp)
    9814:	89 d0                	mov    %edx,%eax
    9816:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    981a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    981e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    9822:	66 89 14 c5 22 00 01 	mov    %dx,0x10022(,%eax,8)
    9829:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    982a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    982e:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    9832:	88 14 c5 25 00 01 00 	mov    %dl,0x10025(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    9839:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    983d:	c6 04 c5 24 00 01 00 	movb   $0x0,0x10024(,%eax,8)
    9844:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    9845:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9849:	8b 55 f0             	mov    -0x10(%ebp),%edx
    984c:	66 89 14 c5 20 00 01 	mov    %dx,0x10020(,%eax,8)
    9853:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    9854:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9857:	8b 55 f4             	mov    -0xc(%ebp),%edx
    985a:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    985e:	c1 ea 10             	shr    $0x10,%edx
    9861:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    9865:	66 89 04 cd 26 00 01 	mov    %ax,0x10026(,%ecx,8)
    986c:	00 
}
    986d:	90                   	nop
    986e:	c9                   	leave  
    986f:	c3                   	ret    

00009870 <init_idt>:

void init_idt()
{
    9870:	55                   	push   %ebp
    9871:	89 e5                	mov    %esp,%ebp
    9873:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    9876:	83 ec 0c             	sub    $0xc,%esp
    9879:	68 ad da 00 00       	push   $0xdaad
    987e:	e8 12 0e 00 00       	call   a695 <Init_PIT>
    9883:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    9886:	83 ec 08             	sub    $0x8,%esp
    9889:	6a 28                	push   $0x28
    988b:	6a 20                	push   $0x20
    988d:	e8 16 0b 00 00       	call   a3a8 <PIC_remap>
    9892:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    9895:	b8 80 b3 00 00       	mov    $0xb380,%eax
    989a:	ba 00 00 00 00       	mov    $0x0,%edx
    989f:	83 ec 0c             	sub    $0xc,%esp
    98a2:	6a 20                	push   $0x20
    98a4:	52                   	push   %edx
    98a5:	50                   	push   %eax
    98a6:	68 8e 00 00 00       	push   $0x8e
    98ab:	6a 08                	push   $0x8
    98ad:	e8 3e ff ff ff       	call   97f0 <set_idt>
    98b2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    98b5:	b8 d0 b2 00 00       	mov    $0xb2d0,%eax
    98ba:	ba 00 00 00 00       	mov    $0x0,%edx
    98bf:	83 ec 0c             	sub    $0xc,%esp
    98c2:	6a 21                	push   $0x21
    98c4:	52                   	push   %edx
    98c5:	50                   	push   %eax
    98c6:	68 8e 00 00 00       	push   $0x8e
    98cb:	6a 08                	push   $0x8
    98cd:	e8 1e ff ff ff       	call   97f0 <set_idt>
    98d2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    98d5:	b8 d8 b2 00 00       	mov    $0xb2d8,%eax
    98da:	ba 00 00 00 00       	mov    $0x0,%edx
    98df:	83 ec 0c             	sub    $0xc,%esp
    98e2:	6a 22                	push   $0x22
    98e4:	52                   	push   %edx
    98e5:	50                   	push   %eax
    98e6:	68 8e 00 00 00       	push   $0x8e
    98eb:	6a 08                	push   $0x8
    98ed:	e8 fe fe ff ff       	call   97f0 <set_idt>
    98f2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    98f5:	b8 e0 b2 00 00       	mov    $0xb2e0,%eax
    98fa:	ba 00 00 00 00       	mov    $0x0,%edx
    98ff:	83 ec 0c             	sub    $0xc,%esp
    9902:	6a 23                	push   $0x23
    9904:	52                   	push   %edx
    9905:	50                   	push   %eax
    9906:	68 8e 00 00 00       	push   $0x8e
    990b:	6a 08                	push   $0x8
    990d:	e8 de fe ff ff       	call   97f0 <set_idt>
    9912:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    9915:	b8 e8 b2 00 00       	mov    $0xb2e8,%eax
    991a:	ba 00 00 00 00       	mov    $0x0,%edx
    991f:	83 ec 0c             	sub    $0xc,%esp
    9922:	6a 24                	push   $0x24
    9924:	52                   	push   %edx
    9925:	50                   	push   %eax
    9926:	68 8e 00 00 00       	push   $0x8e
    992b:	6a 08                	push   $0x8
    992d:	e8 be fe ff ff       	call   97f0 <set_idt>
    9932:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    9935:	b8 f0 b2 00 00       	mov    $0xb2f0,%eax
    993a:	ba 00 00 00 00       	mov    $0x0,%edx
    993f:	83 ec 0c             	sub    $0xc,%esp
    9942:	6a 25                	push   $0x25
    9944:	52                   	push   %edx
    9945:	50                   	push   %eax
    9946:	68 8e 00 00 00       	push   $0x8e
    994b:	6a 08                	push   $0x8
    994d:	e8 9e fe ff ff       	call   97f0 <set_idt>
    9952:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    9955:	b8 f8 b2 00 00       	mov    $0xb2f8,%eax
    995a:	ba 00 00 00 00       	mov    $0x0,%edx
    995f:	83 ec 0c             	sub    $0xc,%esp
    9962:	6a 26                	push   $0x26
    9964:	52                   	push   %edx
    9965:	50                   	push   %eax
    9966:	68 8e 00 00 00       	push   $0x8e
    996b:	6a 08                	push   $0x8
    996d:	e8 7e fe ff ff       	call   97f0 <set_idt>
    9972:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    9975:	b8 00 b3 00 00       	mov    $0xb300,%eax
    997a:	ba 00 00 00 00       	mov    $0x0,%edx
    997f:	83 ec 0c             	sub    $0xc,%esp
    9982:	6a 27                	push   $0x27
    9984:	52                   	push   %edx
    9985:	50                   	push   %eax
    9986:	68 8e 00 00 00       	push   $0x8e
    998b:	6a 08                	push   $0x8
    998d:	e8 5e fe ff ff       	call   97f0 <set_idt>
    9992:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    9995:	b8 08 b3 00 00       	mov    $0xb308,%eax
    999a:	ba 00 00 00 00       	mov    $0x0,%edx
    999f:	83 ec 0c             	sub    $0xc,%esp
    99a2:	6a 28                	push   $0x28
    99a4:	52                   	push   %edx
    99a5:	50                   	push   %eax
    99a6:	68 8e 00 00 00       	push   $0x8e
    99ab:	6a 08                	push   $0x8
    99ad:	e8 3e fe ff ff       	call   97f0 <set_idt>
    99b2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    99b5:	b8 10 b3 00 00       	mov    $0xb310,%eax
    99ba:	ba 00 00 00 00       	mov    $0x0,%edx
    99bf:	83 ec 0c             	sub    $0xc,%esp
    99c2:	6a 29                	push   $0x29
    99c4:	52                   	push   %edx
    99c5:	50                   	push   %eax
    99c6:	68 8e 00 00 00       	push   $0x8e
    99cb:	6a 08                	push   $0x8
    99cd:	e8 1e fe ff ff       	call   97f0 <set_idt>
    99d2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    99d5:	b8 18 b3 00 00       	mov    $0xb318,%eax
    99da:	ba 00 00 00 00       	mov    $0x0,%edx
    99df:	83 ec 0c             	sub    $0xc,%esp
    99e2:	6a 2a                	push   $0x2a
    99e4:	52                   	push   %edx
    99e5:	50                   	push   %eax
    99e6:	68 8e 00 00 00       	push   $0x8e
    99eb:	6a 08                	push   $0x8
    99ed:	e8 fe fd ff ff       	call   97f0 <set_idt>
    99f2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    99f5:	b8 20 b3 00 00       	mov    $0xb320,%eax
    99fa:	ba 00 00 00 00       	mov    $0x0,%edx
    99ff:	83 ec 0c             	sub    $0xc,%esp
    9a02:	6a 2b                	push   $0x2b
    9a04:	52                   	push   %edx
    9a05:	50                   	push   %eax
    9a06:	68 8e 00 00 00       	push   $0x8e
    9a0b:	6a 08                	push   $0x8
    9a0d:	e8 de fd ff ff       	call   97f0 <set_idt>
    9a12:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    9a15:	b8 28 b3 00 00       	mov    $0xb328,%eax
    9a1a:	ba 00 00 00 00       	mov    $0x0,%edx
    9a1f:	83 ec 0c             	sub    $0xc,%esp
    9a22:	6a 2c                	push   $0x2c
    9a24:	52                   	push   %edx
    9a25:	50                   	push   %eax
    9a26:	68 8e 00 00 00       	push   $0x8e
    9a2b:	6a 08                	push   $0x8
    9a2d:	e8 be fd ff ff       	call   97f0 <set_idt>
    9a32:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    9a35:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9a3a:	ba 00 00 00 00       	mov    $0x0,%edx
    9a3f:	83 ec 0c             	sub    $0xc,%esp
    9a42:	6a 2d                	push   $0x2d
    9a44:	52                   	push   %edx
    9a45:	50                   	push   %eax
    9a46:	68 8e 00 00 00       	push   $0x8e
    9a4b:	6a 08                	push   $0x8
    9a4d:	e8 9e fd ff ff       	call   97f0 <set_idt>
    9a52:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    9a55:	b8 38 b3 00 00       	mov    $0xb338,%eax
    9a5a:	ba 00 00 00 00       	mov    $0x0,%edx
    9a5f:	83 ec 0c             	sub    $0xc,%esp
    9a62:	6a 2e                	push   $0x2e
    9a64:	52                   	push   %edx
    9a65:	50                   	push   %eax
    9a66:	68 8e 00 00 00       	push   $0x8e
    9a6b:	6a 08                	push   $0x8
    9a6d:	e8 7e fd ff ff       	call   97f0 <set_idt>
    9a72:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    9a75:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9a7a:	ba 00 00 00 00       	mov    $0x0,%edx
    9a7f:	83 ec 0c             	sub    $0xc,%esp
    9a82:	6a 2f                	push   $0x2f
    9a84:	52                   	push   %edx
    9a85:	50                   	push   %eax
    9a86:	68 8e 00 00 00       	push   $0x8e
    9a8b:	6a 08                	push   $0x8
    9a8d:	e8 5e fd ff ff       	call   97f0 <set_idt>
    9a92:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    9a95:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9a9a:	ba 00 00 00 00       	mov    $0x0,%edx
    9a9f:	83 ec 0c             	sub    $0xc,%esp
    9aa2:	6a 08                	push   $0x8
    9aa4:	52                   	push   %edx
    9aa5:	50                   	push   %eax
    9aa6:	68 8e 00 00 00       	push   $0x8e
    9aab:	6a 08                	push   $0x8
    9aad:	e8 3e fd ff ff       	call   97f0 <set_idt>
    9ab2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    9ab5:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9aba:	ba 00 00 00 00       	mov    $0x0,%edx
    9abf:	83 ec 0c             	sub    $0xc,%esp
    9ac2:	6a 0a                	push   $0xa
    9ac4:	52                   	push   %edx
    9ac5:	50                   	push   %eax
    9ac6:	68 8e 00 00 00       	push   $0x8e
    9acb:	6a 08                	push   $0x8
    9acd:	e8 1e fd ff ff       	call   97f0 <set_idt>
    9ad2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    9ad5:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9ada:	ba 00 00 00 00       	mov    $0x0,%edx
    9adf:	83 ec 0c             	sub    $0xc,%esp
    9ae2:	6a 0b                	push   $0xb
    9ae4:	52                   	push   %edx
    9ae5:	50                   	push   %eax
    9ae6:	68 8e 00 00 00       	push   $0x8e
    9aeb:	6a 08                	push   $0x8
    9aed:	e8 fe fc ff ff       	call   97f0 <set_idt>
    9af2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9af5:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9afa:	ba 00 00 00 00       	mov    $0x0,%edx
    9aff:	83 ec 0c             	sub    $0xc,%esp
    9b02:	6a 0c                	push   $0xc
    9b04:	52                   	push   %edx
    9b05:	50                   	push   %eax
    9b06:	68 8e 00 00 00       	push   $0x8e
    9b0b:	6a 08                	push   $0x8
    9b0d:	e8 de fc ff ff       	call   97f0 <set_idt>
    9b12:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9b15:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9b1a:	ba 00 00 00 00       	mov    $0x0,%edx
    9b1f:	83 ec 0c             	sub    $0xc,%esp
    9b22:	6a 0d                	push   $0xd
    9b24:	52                   	push   %edx
    9b25:	50                   	push   %eax
    9b26:	68 8e 00 00 00       	push   $0x8e
    9b2b:	6a 08                	push   $0x8
    9b2d:	e8 be fc ff ff       	call   97f0 <set_idt>
    9b32:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    9b35:	b8 77 a3 00 00       	mov    $0xa377,%eax
    9b3a:	ba 00 00 00 00       	mov    $0x0,%edx
    9b3f:	83 ec 0c             	sub    $0xc,%esp
    9b42:	6a 0e                	push   $0xe
    9b44:	52                   	push   %edx
    9b45:	50                   	push   %eax
    9b46:	68 8e 00 00 00       	push   $0x8e
    9b4b:	6a 08                	push   $0x8
    9b4d:	e8 9e fc ff ff       	call   97f0 <set_idt>
    9b52:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    9b55:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9b5a:	ba 00 00 00 00       	mov    $0x0,%edx
    9b5f:	83 ec 0c             	sub    $0xc,%esp
    9b62:	6a 11                	push   $0x11
    9b64:	52                   	push   %edx
    9b65:	50                   	push   %eax
    9b66:	68 8e 00 00 00       	push   $0x8e
    9b6b:	6a 08                	push   $0x8
    9b6d:	e8 7e fc ff ff       	call   97f0 <set_idt>
    9b72:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    9b75:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9b7a:	ba 00 00 00 00       	mov    $0x0,%edx
    9b7f:	83 ec 0c             	sub    $0xc,%esp
    9b82:	6a 1e                	push   $0x1e
    9b84:	52                   	push   %edx
    9b85:	50                   	push   %eax
    9b86:	68 8e 00 00 00       	push   $0x8e
    9b8b:	6a 08                	push   $0x8
    9b8d:	e8 5e fc ff ff       	call   97f0 <set_idt>
    9b92:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9b95:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9b9a:	ba 00 00 00 00       	mov    $0x0,%edx
    9b9f:	83 ec 0c             	sub    $0xc,%esp
    9ba2:	6a 00                	push   $0x0
    9ba4:	52                   	push   %edx
    9ba5:	50                   	push   %eax
    9ba6:	68 8e 00 00 00       	push   $0x8e
    9bab:	6a 08                	push   $0x8
    9bad:	e8 3e fc ff ff       	call   97f0 <set_idt>
    9bb2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9bb5:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9bba:	ba 00 00 00 00       	mov    $0x0,%edx
    9bbf:	83 ec 0c             	sub    $0xc,%esp
    9bc2:	6a 01                	push   $0x1
    9bc4:	52                   	push   %edx
    9bc5:	50                   	push   %eax
    9bc6:	68 8e 00 00 00       	push   $0x8e
    9bcb:	6a 08                	push   $0x8
    9bcd:	e8 1e fc ff ff       	call   97f0 <set_idt>
    9bd2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9bd5:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9bda:	ba 00 00 00 00       	mov    $0x0,%edx
    9bdf:	83 ec 0c             	sub    $0xc,%esp
    9be2:	6a 02                	push   $0x2
    9be4:	52                   	push   %edx
    9be5:	50                   	push   %eax
    9be6:	68 8e 00 00 00       	push   $0x8e
    9beb:	6a 08                	push   $0x8
    9bed:	e8 fe fb ff ff       	call   97f0 <set_idt>
    9bf2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9bf5:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9bfa:	ba 00 00 00 00       	mov    $0x0,%edx
    9bff:	83 ec 0c             	sub    $0xc,%esp
    9c02:	6a 03                	push   $0x3
    9c04:	52                   	push   %edx
    9c05:	50                   	push   %eax
    9c06:	68 8e 00 00 00       	push   $0x8e
    9c0b:	6a 08                	push   $0x8
    9c0d:	e8 de fb ff ff       	call   97f0 <set_idt>
    9c12:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9c15:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9c1a:	ba 00 00 00 00       	mov    $0x0,%edx
    9c1f:	83 ec 0c             	sub    $0xc,%esp
    9c22:	6a 04                	push   $0x4
    9c24:	52                   	push   %edx
    9c25:	50                   	push   %eax
    9c26:	68 8e 00 00 00       	push   $0x8e
    9c2b:	6a 08                	push   $0x8
    9c2d:	e8 be fb ff ff       	call   97f0 <set_idt>
    9c32:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    9c35:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9c3a:	ba 00 00 00 00       	mov    $0x0,%edx
    9c3f:	83 ec 0c             	sub    $0xc,%esp
    9c42:	6a 05                	push   $0x5
    9c44:	52                   	push   %edx
    9c45:	50                   	push   %eax
    9c46:	68 8e 00 00 00       	push   $0x8e
    9c4b:	6a 08                	push   $0x8
    9c4d:	e8 9e fb ff ff       	call   97f0 <set_idt>
    9c52:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    9c55:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9c5a:	ba 00 00 00 00       	mov    $0x0,%edx
    9c5f:	83 ec 0c             	sub    $0xc,%esp
    9c62:	6a 06                	push   $0x6
    9c64:	52                   	push   %edx
    9c65:	50                   	push   %eax
    9c66:	68 8e 00 00 00       	push   $0x8e
    9c6b:	6a 08                	push   $0x8
    9c6d:	e8 7e fb ff ff       	call   97f0 <set_idt>
    9c72:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    9c75:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9c7a:	ba 00 00 00 00       	mov    $0x0,%edx
    9c7f:	83 ec 0c             	sub    $0xc,%esp
    9c82:	6a 07                	push   $0x7
    9c84:	52                   	push   %edx
    9c85:	50                   	push   %eax
    9c86:	68 8e 00 00 00       	push   $0x8e
    9c8b:	6a 08                	push   $0x8
    9c8d:	e8 5e fb ff ff       	call   97f0 <set_idt>
    9c92:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9c95:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9c9a:	ba 00 00 00 00       	mov    $0x0,%edx
    9c9f:	83 ec 0c             	sub    $0xc,%esp
    9ca2:	6a 09                	push   $0x9
    9ca4:	52                   	push   %edx
    9ca5:	50                   	push   %eax
    9ca6:	68 8e 00 00 00       	push   $0x8e
    9cab:	6a 08                	push   $0x8
    9cad:	e8 3e fb ff ff       	call   97f0 <set_idt>
    9cb2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9cb5:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9cba:	ba 00 00 00 00       	mov    $0x0,%edx
    9cbf:	83 ec 0c             	sub    $0xc,%esp
    9cc2:	6a 10                	push   $0x10
    9cc4:	52                   	push   %edx
    9cc5:	50                   	push   %eax
    9cc6:	68 8e 00 00 00       	push   $0x8e
    9ccb:	6a 08                	push   $0x8
    9ccd:	e8 1e fb ff ff       	call   97f0 <set_idt>
    9cd2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9cd5:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9cda:	ba 00 00 00 00       	mov    $0x0,%edx
    9cdf:	83 ec 0c             	sub    $0xc,%esp
    9ce2:	6a 12                	push   $0x12
    9ce4:	52                   	push   %edx
    9ce5:	50                   	push   %eax
    9ce6:	68 8e 00 00 00       	push   $0x8e
    9ceb:	6a 08                	push   $0x8
    9ced:	e8 fe fa ff ff       	call   97f0 <set_idt>
    9cf2:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9cf5:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9cfa:	ba 00 00 00 00       	mov    $0x0,%edx
    9cff:	83 ec 0c             	sub    $0xc,%esp
    9d02:	6a 13                	push   $0x13
    9d04:	52                   	push   %edx
    9d05:	50                   	push   %eax
    9d06:	68 8e 00 00 00       	push   $0x8e
    9d0b:	6a 08                	push   $0x8
    9d0d:	e8 de fa ff ff       	call   97f0 <set_idt>
    9d12:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9d15:	b8 a5 96 00 00       	mov    $0x96a5,%eax
    9d1a:	ba 00 00 00 00       	mov    $0x0,%edx
    9d1f:	83 ec 0c             	sub    $0xc,%esp
    9d22:	6a 14                	push   $0x14
    9d24:	52                   	push   %edx
    9d25:	50                   	push   %eax
    9d26:	68 8e 00 00 00       	push   $0x8e
    9d2b:	6a 08                	push   $0x8
    9d2d:	e8 be fa ff ff       	call   97f0 <set_idt>
    9d32:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    9d35:	e8 65 15 00 00       	call   b29f <load_idt>
}
    9d3a:	90                   	nop
    9d3b:	c9                   	leave  
    9d3c:	c3                   	ret    

00009d3d <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    9d3d:	55                   	push   %ebp
    9d3e:	89 e5                	mov    %esp,%ebp
    9d40:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    9d43:	e8 4a 02 00 00       	call   9f92 <keyboard_irq>
    PIC_sendEOI(1);
    9d48:	83 ec 0c             	sub    $0xc,%esp
    9d4b:	6a 01                	push   $0x1
    9d4d:	e8 2b 06 00 00       	call   a37d <PIC_sendEOI>
    9d52:	83 c4 10             	add    $0x10,%esp
}
    9d55:	90                   	nop
    9d56:	c9                   	leave  
    9d57:	c3                   	ret    

00009d58 <irq2_handler>:

void irq2_handler(void)
{
    9d58:	55                   	push   %ebp
    9d59:	89 e5                	mov    %esp,%ebp
    9d5b:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    9d5e:	83 ec 0c             	sub    $0xc,%esp
    9d61:	6a 02                	push   $0x2
    9d63:	e8 21 08 00 00       	call   a589 <spurious_IRQ>
    9d68:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9d6b:	83 ec 0c             	sub    $0xc,%esp
    9d6e:	6a 02                	push   $0x2
    9d70:	e8 08 06 00 00       	call   a37d <PIC_sendEOI>
    9d75:	83 c4 10             	add    $0x10,%esp
}
    9d78:	90                   	nop
    9d79:	c9                   	leave  
    9d7a:	c3                   	ret    

00009d7b <irq3_handler>:

void irq3_handler(void)
{
    9d7b:	55                   	push   %ebp
    9d7c:	89 e5                	mov    %esp,%ebp
    9d7e:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    9d81:	83 ec 0c             	sub    $0xc,%esp
    9d84:	6a 03                	push   $0x3
    9d86:	e8 fe 07 00 00       	call   a589 <spurious_IRQ>
    9d8b:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9d8e:	83 ec 0c             	sub    $0xc,%esp
    9d91:	6a 03                	push   $0x3
    9d93:	e8 e5 05 00 00       	call   a37d <PIC_sendEOI>
    9d98:	83 c4 10             	add    $0x10,%esp
}
    9d9b:	90                   	nop
    9d9c:	c9                   	leave  
    9d9d:	c3                   	ret    

00009d9e <irq4_handler>:

void irq4_handler(void)
{
    9d9e:	55                   	push   %ebp
    9d9f:	89 e5                	mov    %esp,%ebp
    9da1:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    9da4:	83 ec 0c             	sub    $0xc,%esp
    9da7:	6a 04                	push   $0x4
    9da9:	e8 db 07 00 00       	call   a589 <spurious_IRQ>
    9dae:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9db1:	83 ec 0c             	sub    $0xc,%esp
    9db4:	6a 04                	push   $0x4
    9db6:	e8 c2 05 00 00       	call   a37d <PIC_sendEOI>
    9dbb:	83 c4 10             	add    $0x10,%esp
}
    9dbe:	90                   	nop
    9dbf:	c9                   	leave  
    9dc0:	c3                   	ret    

00009dc1 <irq5_handler>:

void irq5_handler(void)
{
    9dc1:	55                   	push   %ebp
    9dc2:	89 e5                	mov    %esp,%ebp
    9dc4:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9dc7:	83 ec 0c             	sub    $0xc,%esp
    9dca:	6a 05                	push   $0x5
    9dcc:	e8 b8 07 00 00       	call   a589 <spurious_IRQ>
    9dd1:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9dd4:	83 ec 0c             	sub    $0xc,%esp
    9dd7:	6a 05                	push   $0x5
    9dd9:	e8 9f 05 00 00       	call   a37d <PIC_sendEOI>
    9dde:	83 c4 10             	add    $0x10,%esp
}
    9de1:	90                   	nop
    9de2:	c9                   	leave  
    9de3:	c3                   	ret    

00009de4 <irq6_handler>:

void irq6_handler(void)
{
    9de4:	55                   	push   %ebp
    9de5:	89 e5                	mov    %esp,%ebp
    9de7:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9dea:	83 ec 0c             	sub    $0xc,%esp
    9ded:	6a 06                	push   $0x6
    9def:	e8 95 07 00 00       	call   a589 <spurious_IRQ>
    9df4:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9df7:	83 ec 0c             	sub    $0xc,%esp
    9dfa:	6a 06                	push   $0x6
    9dfc:	e8 7c 05 00 00       	call   a37d <PIC_sendEOI>
    9e01:	83 c4 10             	add    $0x10,%esp
}
    9e04:	90                   	nop
    9e05:	c9                   	leave  
    9e06:	c3                   	ret    

00009e07 <irq7_handler>:

void irq7_handler(void)
{
    9e07:	55                   	push   %ebp
    9e08:	89 e5                	mov    %esp,%ebp
    9e0a:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9e0d:	83 ec 0c             	sub    $0xc,%esp
    9e10:	6a 07                	push   $0x7
    9e12:	e8 72 07 00 00       	call   a589 <spurious_IRQ>
    9e17:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9e1a:	83 ec 0c             	sub    $0xc,%esp
    9e1d:	6a 07                	push   $0x7
    9e1f:	e8 59 05 00 00       	call   a37d <PIC_sendEOI>
    9e24:	83 c4 10             	add    $0x10,%esp
}
    9e27:	90                   	nop
    9e28:	c9                   	leave  
    9e29:	c3                   	ret    

00009e2a <irq8_handler>:

void irq8_handler(void)
{
    9e2a:	55                   	push   %ebp
    9e2b:	89 e5                	mov    %esp,%ebp
    9e2d:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    9e30:	83 ec 0c             	sub    $0xc,%esp
    9e33:	6a 08                	push   $0x8
    9e35:	e8 4f 07 00 00       	call   a589 <spurious_IRQ>
    9e3a:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9e3d:	83 ec 0c             	sub    $0xc,%esp
    9e40:	6a 08                	push   $0x8
    9e42:	e8 36 05 00 00       	call   a37d <PIC_sendEOI>
    9e47:	83 c4 10             	add    $0x10,%esp
}
    9e4a:	90                   	nop
    9e4b:	c9                   	leave  
    9e4c:	c3                   	ret    

00009e4d <irq9_handler>:

void irq9_handler(void)
{
    9e4d:	55                   	push   %ebp
    9e4e:	89 e5                	mov    %esp,%ebp
    9e50:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    9e53:	83 ec 0c             	sub    $0xc,%esp
    9e56:	6a 09                	push   $0x9
    9e58:	e8 2c 07 00 00       	call   a589 <spurious_IRQ>
    9e5d:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9e60:	83 ec 0c             	sub    $0xc,%esp
    9e63:	6a 09                	push   $0x9
    9e65:	e8 13 05 00 00       	call   a37d <PIC_sendEOI>
    9e6a:	83 c4 10             	add    $0x10,%esp
}
    9e6d:	90                   	nop
    9e6e:	c9                   	leave  
    9e6f:	c3                   	ret    

00009e70 <irq10_handler>:

void irq10_handler(void)
{
    9e70:	55                   	push   %ebp
    9e71:	89 e5                	mov    %esp,%ebp
    9e73:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    9e76:	83 ec 0c             	sub    $0xc,%esp
    9e79:	6a 0a                	push   $0xa
    9e7b:	e8 09 07 00 00       	call   a589 <spurious_IRQ>
    9e80:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9e83:	83 ec 0c             	sub    $0xc,%esp
    9e86:	6a 0a                	push   $0xa
    9e88:	e8 f0 04 00 00       	call   a37d <PIC_sendEOI>
    9e8d:	83 c4 10             	add    $0x10,%esp
}
    9e90:	90                   	nop
    9e91:	c9                   	leave  
    9e92:	c3                   	ret    

00009e93 <irq11_handler>:

void irq11_handler(void)
{
    9e93:	55                   	push   %ebp
    9e94:	89 e5                	mov    %esp,%ebp
    9e96:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9e99:	83 ec 0c             	sub    $0xc,%esp
    9e9c:	6a 0b                	push   $0xb
    9e9e:	e8 e6 06 00 00       	call   a589 <spurious_IRQ>
    9ea3:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9ea6:	83 ec 0c             	sub    $0xc,%esp
    9ea9:	6a 0b                	push   $0xb
    9eab:	e8 cd 04 00 00       	call   a37d <PIC_sendEOI>
    9eb0:	83 c4 10             	add    $0x10,%esp
}
    9eb3:	90                   	nop
    9eb4:	c9                   	leave  
    9eb5:	c3                   	ret    

00009eb6 <irq12_handler>:

void irq12_handler(void)
{
    9eb6:	55                   	push   %ebp
    9eb7:	89 e5                	mov    %esp,%ebp
    9eb9:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9ebc:	83 ec 0c             	sub    $0xc,%esp
    9ebf:	6a 0c                	push   $0xc
    9ec1:	e8 c3 06 00 00       	call   a589 <spurious_IRQ>
    9ec6:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9ec9:	83 ec 0c             	sub    $0xc,%esp
    9ecc:	6a 0c                	push   $0xc
    9ece:	e8 aa 04 00 00       	call   a37d <PIC_sendEOI>
    9ed3:	83 c4 10             	add    $0x10,%esp
}
    9ed6:	90                   	nop
    9ed7:	c9                   	leave  
    9ed8:	c3                   	ret    

00009ed9 <irq13_handler>:

void irq13_handler(void)
{
    9ed9:	55                   	push   %ebp
    9eda:	89 e5                	mov    %esp,%ebp
    9edc:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9edf:	83 ec 0c             	sub    $0xc,%esp
    9ee2:	6a 0d                	push   $0xd
    9ee4:	e8 a0 06 00 00       	call   a589 <spurious_IRQ>
    9ee9:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9eec:	83 ec 0c             	sub    $0xc,%esp
    9eef:	6a 0d                	push   $0xd
    9ef1:	e8 87 04 00 00       	call   a37d <PIC_sendEOI>
    9ef6:	83 c4 10             	add    $0x10,%esp
}
    9ef9:	90                   	nop
    9efa:	c9                   	leave  
    9efb:	c3                   	ret    

00009efc <irq14_handler>:

void irq14_handler(void)
{
    9efc:	55                   	push   %ebp
    9efd:	89 e5                	mov    %esp,%ebp
    9eff:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9f02:	83 ec 0c             	sub    $0xc,%esp
    9f05:	6a 0e                	push   $0xe
    9f07:	e8 7d 06 00 00       	call   a589 <spurious_IRQ>
    9f0c:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9f0f:	83 ec 0c             	sub    $0xc,%esp
    9f12:	6a 0e                	push   $0xe
    9f14:	e8 64 04 00 00       	call   a37d <PIC_sendEOI>
    9f19:	83 c4 10             	add    $0x10,%esp
}
    9f1c:	90                   	nop
    9f1d:	c9                   	leave  
    9f1e:	c3                   	ret    

00009f1f <irq15_handler>:

void irq15_handler(void)
{
    9f1f:	55                   	push   %ebp
    9f20:	89 e5                	mov    %esp,%ebp
    9f22:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    9f25:	83 ec 0c             	sub    $0xc,%esp
    9f28:	6a 0f                	push   $0xf
    9f2a:	e8 5a 06 00 00       	call   a589 <spurious_IRQ>
    9f2f:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    9f32:	83 ec 0c             	sub    $0xc,%esp
    9f35:	6a 0f                	push   $0xf
    9f37:	e8 41 04 00 00       	call   a37d <PIC_sendEOI>
    9f3c:	83 c4 10             	add    $0x10,%esp
    9f3f:	90                   	nop
    9f40:	c9                   	leave  
    9f41:	c3                   	ret    

00009f42 <keyboard_add_service>:
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x60)  */
          0xFF, 0xFF, 0xFF, 0xFF  /*      (0x61)  */
      };

void keyboard_add_service(void (*func)())
{
    9f42:	55                   	push   %ebp
    9f43:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service[keyboard_ctrl.kbd_service_num] = func;
    9f45:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    9f4c:	0f be c0             	movsbl %al,%eax
    9f4f:	8b 55 08             	mov    0x8(%ebp),%edx
    9f52:	89 14 85 22 08 01 00 	mov    %edx,0x10822(,%eax,4)
    keyboard_ctrl.kbd_service_num++;
    9f59:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    9f60:	83 c0 01             	add    $0x1,%eax
    9f63:	a2 21 08 01 00       	mov    %al,0x10821
}
    9f68:	90                   	nop
    9f69:	5d                   	pop    %ebp
    9f6a:	c3                   	ret    

00009f6b <kbd_init>:

void kbd_init()
{
    9f6b:	55                   	push   %ebp
    9f6c:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service_num = 0;
    9f6e:	c6 05 21 08 01 00 00 	movb   $0x0,0x10821
    keyboard_add_service(console_service_keyboard);
    9f75:	68 5f 96 00 00       	push   $0x965f
    9f7a:	e8 c3 ff ff ff       	call   9f42 <keyboard_add_service>
    9f7f:	83 c4 04             	add    $0x4,%esp
    keyboard_add_service(monitor_service_keyboard);
    9f82:	68 c8 a8 00 00       	push   $0xa8c8
    9f87:	e8 b6 ff ff ff       	call   9f42 <keyboard_add_service>
    9f8c:	83 c4 04             	add    $0x4,%esp
}
    9f8f:	90                   	nop
    9f90:	c9                   	leave  
    9f91:	c3                   	ret    

00009f92 <keyboard_irq>:

void keyboard_irq()
{
    9f92:	55                   	push   %ebp
    9f93:	89 e5                	mov    %esp,%ebp
    9f95:	83 ec 18             	sub    $0x18,%esp

    int i;
    void (*func)(void);

    do {
        keyboard_ctrl.code = _8042_get_status;
    9f98:	b8 64 00 00 00       	mov    $0x64,%eax
    9f9d:	89 c2                	mov    %eax,%edx
    9f9f:	ec                   	in     (%dx),%al
    9fa0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    9fa4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    9fa8:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e
    } while ((keyboard_ctrl.code & 0x01) == _8042_BUFFER_OVERRUN);
    9fae:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    9fb5:	98                   	cwtl   
    9fb6:	83 e0 01             	and    $0x1,%eax
    9fb9:	85 c0                	test   %eax,%eax
    9fbb:	74 db                	je     9f98 <keyboard_irq+0x6>

    keyboard_ctrl.code = _8042_scan_code;
    9fbd:	b8 60 00 00 00       	mov    $0x60,%eax
    9fc2:	89 c2                	mov    %eax,%edx
    9fc4:	ec                   	in     (%dx),%al
    9fc5:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    9fc9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    9fcd:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9fd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9fda:	eb 16                	jmp    9ff2 <keyboard_irq+0x60>
        func = keyboard_ctrl.kbd_service[i];
    9fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9fdf:	8b 04 85 22 08 01 00 	mov    0x10822(,%eax,4),%eax
    9fe6:	89 45 ec             	mov    %eax,-0x14(%ebp)
        func();
    9fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9fec:	ff d0                	call   *%eax
    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9fee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9ff2:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    9ff9:	0f be c0             	movsbl %al,%eax
    9ffc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    9fff:	7c db                	jl     9fdc <keyboard_irq+0x4a>
    }
}
    a001:	90                   	nop
    a002:	90                   	nop
    a003:	c9                   	leave  
    a004:	c3                   	ret    

0000a005 <reinitialise_kbd>:

void reinitialise_kbd()
{
    a005:	55                   	push   %ebp
    a006:	89 e5                	mov    %esp,%ebp
    a008:	83 ec 08             	sub    $0x8,%esp
    wait_8042_ACK();
    a00b:	e8 43 00 00 00       	call   a053 <wait_8042_ACK>
    _8042_send_get_current_scan_code;
    a010:	ba 64 00 00 00       	mov    $0x64,%edx
    a015:	b8 f0 00 00 00       	mov    $0xf0,%eax
    a01a:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a01b:	e8 33 00 00 00       	call   a053 <wait_8042_ACK>

    _8042_set_typematic_rate;
    a020:	ba 64 00 00 00       	mov    $0x64,%edx
    a025:	b8 f3 00 00 00       	mov    $0xf3,%eax
    a02a:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a02b:	e8 23 00 00 00       	call   a053 <wait_8042_ACK>

    _8042_set_leds;
    a030:	ba 64 00 00 00       	mov    $0x64,%edx
    a035:	b8 ed 00 00 00       	mov    $0xed,%eax
    a03a:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a03b:	e8 13 00 00 00       	call   a053 <wait_8042_ACK>

    _8042_enable_scanning;
    a040:	ba 64 00 00 00       	mov    $0x64,%edx
    a045:	b8 f4 00 00 00       	mov    $0xf4,%eax
    a04a:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a04b:	e8 03 00 00 00       	call   a053 <wait_8042_ACK>
}
    a050:	90                   	nop
    a051:	c9                   	leave  
    a052:	c3                   	ret    

0000a053 <wait_8042_ACK>:

static void
wait_8042_ACK()
{
    a053:	55                   	push   %ebp
    a054:	89 e5                	mov    %esp,%ebp
    a056:	83 ec 10             	sub    $0x10,%esp
    while (_8042_get_status != _8042_ACK)
    a059:	90                   	nop
    a05a:	b8 64 00 00 00       	mov    $0x64,%eax
    a05f:	89 c2                	mov    %eax,%edx
    a061:	ec                   	in     (%dx),%al
    a062:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a066:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a06a:	66 3d fa 00          	cmp    $0xfa,%ax
    a06e:	75 ea                	jne    a05a <wait_8042_ACK+0x7>
        ;
}
    a070:	90                   	nop
    a071:	90                   	nop
    a072:	c9                   	leave  
    a073:	c3                   	ret    

0000a074 <get_code_kbd_control>:

int16_t get_code_kbd_control()
{
    a074:	55                   	push   %ebp
    a075:	89 e5                	mov    %esp,%ebp
    return keyboard_ctrl.code;
    a077:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
}
    a07e:	5d                   	pop    %ebp
    a07f:	c3                   	ret    

0000a080 <handle_ASCII_code_keyboard>:

static void handle_ASCII_code_keyboard()
{
    a080:	55                   	push   %ebp
    a081:	89 e5                	mov    %esp,%ebp
    a083:	83 ec 10             	sub    $0x10,%esp
    int16_t _code = keyboard_ctrl.code - 1;
    a086:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a08d:	83 e8 01             	sub    $0x1,%eax
    a090:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    if (_code < 0x80) { /* key held down */
    a094:	66 83 7d fe 7f       	cmpw   $0x7f,-0x2(%ebp)
    a099:	0f 8f 8f 00 00 00    	jg     a12e <handle_ASCII_code_keyboard+0xae>
        switch (_code) {
    a09f:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a0a3:	83 f8 37             	cmp    $0x37,%eax
    a0a6:	74 3d                	je     a0e5 <handle_ASCII_code_keyboard+0x65>
    a0a8:	83 f8 37             	cmp    $0x37,%eax
    a0ab:	7f 44                	jg     a0f1 <handle_ASCII_code_keyboard+0x71>
    a0ad:	83 f8 35             	cmp    $0x35,%eax
    a0b0:	74 1b                	je     a0cd <handle_ASCII_code_keyboard+0x4d>
    a0b2:	83 f8 35             	cmp    $0x35,%eax
    a0b5:	7f 3a                	jg     a0f1 <handle_ASCII_code_keyboard+0x71>
    a0b7:	83 f8 1c             	cmp    $0x1c,%eax
    a0ba:	74 1d                	je     a0d9 <handle_ASCII_code_keyboard+0x59>
    a0bc:	83 f8 29             	cmp    $0x29,%eax
    a0bf:	75 30                	jne    a0f1 <handle_ASCII_code_keyboard+0x71>
        case 0x29: lshift_enable = 1; break;
    a0c1:	c6 05 20 0c 01 00 01 	movb   $0x1,0x10c20
    a0c8:	e9 b8 00 00 00       	jmp    a185 <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 1; break;
    a0cd:	c6 05 21 0c 01 00 01 	movb   $0x1,0x10c21
    a0d4:	e9 ac 00 00 00       	jmp    a185 <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 1; break;
    a0d9:	c6 05 23 0c 01 00 01 	movb   $0x1,0x10c23
    a0e0:	e9 a0 00 00 00       	jmp    a185 <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 1; break;
    a0e5:	c6 05 22 0c 01 00 01 	movb   $0x1,0x10c22
    a0ec:	e9 94 00 00 00       	jmp    a185 <handle_ASCII_code_keyboard+0x105>
        default:
            keyboard_ctrl.ascii_code_keyboard = kbdmap[_code * 4 + (lshift_enable || rshift_enable)];
    a0f1:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a0f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a0fc:	0f b6 05 20 0c 01 00 	movzbl 0x10c20,%eax
    a103:	84 c0                	test   %al,%al
    a105:	75 0b                	jne    a112 <handle_ASCII_code_keyboard+0x92>
    a107:	0f b6 05 21 0c 01 00 	movzbl 0x10c21,%eax
    a10e:	84 c0                	test   %al,%al
    a110:	74 07                	je     a119 <handle_ASCII_code_keyboard+0x99>
    a112:	b8 01 00 00 00       	mov    $0x1,%eax
    a117:	eb 05                	jmp    a11e <handle_ASCII_code_keyboard+0x9e>
    a119:	b8 00 00 00 00       	mov    $0x0,%eax
    a11e:	01 d0                	add    %edx,%eax
    a120:	0f b6 80 e0 b4 00 00 	movzbl 0xb4e0(%eax),%eax
    a127:	a2 20 08 01 00       	mov    %al,0x10820
        case 0x35: rshift_enable = 0; break;
        case 0x1C: ctrl_enable = 0; break;
        case 0x37: alt_enable = 0; break;
        }
    }
}
    a12c:	eb 57                	jmp    a185 <handle_ASCII_code_keyboard+0x105>
        _code -= 0x80;
    a12e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a132:	83 c0 80             	add    $0xffffff80,%eax
    a135:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
        keyboard_ctrl.ascii_code_keyboard = '\0'; //Free it when release the key
    a139:	c6 05 20 08 01 00 00 	movb   $0x0,0x10820
        switch (_code) {
    a140:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a144:	83 f8 37             	cmp    $0x37,%eax
    a147:	74 34                	je     a17d <handle_ASCII_code_keyboard+0xfd>
    a149:	83 f8 37             	cmp    $0x37,%eax
    a14c:	7f 37                	jg     a185 <handle_ASCII_code_keyboard+0x105>
    a14e:	83 f8 35             	cmp    $0x35,%eax
    a151:	74 18                	je     a16b <handle_ASCII_code_keyboard+0xeb>
    a153:	83 f8 35             	cmp    $0x35,%eax
    a156:	7f 2d                	jg     a185 <handle_ASCII_code_keyboard+0x105>
    a158:	83 f8 1c             	cmp    $0x1c,%eax
    a15b:	74 17                	je     a174 <handle_ASCII_code_keyboard+0xf4>
    a15d:	83 f8 29             	cmp    $0x29,%eax
    a160:	75 23                	jne    a185 <handle_ASCII_code_keyboard+0x105>
        case 0x29: lshift_enable = 0; break;
    a162:	c6 05 20 0c 01 00 00 	movb   $0x0,0x10c20
    a169:	eb 1a                	jmp    a185 <handle_ASCII_code_keyboard+0x105>
        case 0x35: rshift_enable = 0; break;
    a16b:	c6 05 21 0c 01 00 00 	movb   $0x0,0x10c21
    a172:	eb 11                	jmp    a185 <handle_ASCII_code_keyboard+0x105>
        case 0x1C: ctrl_enable = 0; break;
    a174:	c6 05 23 0c 01 00 00 	movb   $0x0,0x10c23
    a17b:	eb 08                	jmp    a185 <handle_ASCII_code_keyboard+0x105>
        case 0x37: alt_enable = 0; break;
    a17d:	c6 05 22 0c 01 00 00 	movb   $0x0,0x10c22
    a184:	90                   	nop
}
    a185:	90                   	nop
    a186:	c9                   	leave  
    a187:	c3                   	ret    

0000a188 <get_ASCII_code_keyboard>:

int8_t get_ASCII_code_keyboard()
{
    a188:	55                   	push   %ebp
    a189:	89 e5                	mov    %esp,%ebp

    handle_ASCII_code_keyboard();
    a18b:	e8 f0 fe ff ff       	call   a080 <handle_ASCII_code_keyboard>

    return keyboard_ctrl.ascii_code_keyboard;
    a190:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    a197:	5d                   	pop    %ebp
    a198:	c3                   	ret    

0000a199 <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    a199:	55                   	push   %ebp
    a19a:	89 e5                	mov    %esp,%ebp
    a19c:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a1a6:	eb 20                	jmp    a1c8 <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1ab:	c1 e0 0c             	shl    $0xc,%eax
    a1ae:	89 c2                	mov    %eax,%edx
    a1b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1b3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a1ba:	8b 45 08             	mov    0x8(%ebp),%eax
    a1bd:	01 c8                	add    %ecx,%eax
    a1bf:	83 ca 23             	or     $0x23,%edx
    a1c2:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a1c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a1c8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a1cf:	76 d7                	jbe    a1a8 <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    a1d1:	8b 45 08             	mov    0x8(%ebp),%eax
    a1d4:	83 c8 23             	or     $0x23,%eax
    a1d7:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    a1d9:	8b 45 0c             	mov    0xc(%ebp),%eax
    a1dc:	89 14 85 00 10 01 00 	mov    %edx,0x11000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    a1e3:	e8 68 11 00 00       	call   b350 <_FlushPagingCache_>
}
    a1e8:	90                   	nop
    a1e9:	c9                   	leave  
    a1ea:	c3                   	ret    

0000a1eb <init_paging>:

void init_paging()
{
    a1eb:	55                   	push   %ebp
    a1ec:	89 e5                	mov    %esp,%ebp
    a1ee:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    a1f1:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a1f7:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    a1fd:	eb 1a                	jmp    a219 <init_paging+0x2e>
        page_directory[i] =
    a1ff:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a203:	c7 04 85 00 10 01 00 	movl   $0x2,0x11000(,%eax,4)
    a20a:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a20e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a212:	83 c0 01             	add    $0x1,%eax
    a215:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a219:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a21f:	76 de                	jbe    a1ff <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a221:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    a227:	eb 22                	jmp    a24b <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a229:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a22d:	c1 e0 0c             	shl    $0xc,%eax
    a230:	83 c8 23             	or     $0x23,%eax
    a233:	89 c2                	mov    %eax,%edx
    a235:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a239:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a240:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a244:	83 c0 01             	add    $0x1,%eax
    a247:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a24b:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a251:	76 d6                	jbe    a229 <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    a253:	b8 00 c0 00 00       	mov    $0xc000,%eax
    a258:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    a25b:	a3 00 10 01 00       	mov    %eax,0x11000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    a260:	e8 f4 10 00 00       	call   b359 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    a265:	90                   	nop
    a266:	c9                   	leave  
    a267:	c3                   	ret    

0000a268 <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    a268:	55                   	push   %ebp
    a269:	89 e5                	mov    %esp,%ebp
    a26b:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    a26e:	8b 45 08             	mov    0x8(%ebp),%eax
    a271:	c1 e8 16             	shr    $0x16,%eax
    a274:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    a277:	8b 45 08             	mov    0x8(%ebp),%eax
    a27a:	c1 e8 0c             	shr    $0xc,%eax
    a27d:	25 ff 03 00 00       	and    $0x3ff,%eax
    a282:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a285:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a288:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a28f:	83 e0 23             	and    $0x23,%eax
    a292:	83 f8 23             	cmp    $0x23,%eax
    a295:	75 56                	jne    a2ed <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a297:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a29a:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a2a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a2a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a2a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a2ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a2b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a2b6:	01 d0                	add    %edx,%eax
    a2b8:	8b 00                	mov    (%eax),%eax
    a2ba:	83 e0 23             	and    $0x23,%eax
    a2bd:	83 f8 23             	cmp    $0x23,%eax
    a2c0:	75 24                	jne    a2e6 <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a2c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a2c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a2cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a2cf:	01 d0                	add    %edx,%eax
    a2d1:	8b 00                	mov    (%eax),%eax
    a2d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a2d8:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    a2da:	8b 45 08             	mov    0x8(%ebp),%eax
    a2dd:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a2e2:	09 d0                	or     %edx,%eax
    a2e4:	eb 0c                	jmp    a2f2 <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    a2e6:	b8 70 f0 00 00       	mov    $0xf070,%eax
    a2eb:	eb 05                	jmp    a2f2 <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    a2ed:	b8 70 f0 00 00       	mov    $0xf070,%eax
}
    a2f2:	c9                   	leave  
    a2f3:	c3                   	ret    

0000a2f4 <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    a2f4:	55                   	push   %ebp
    a2f5:	89 e5                	mov    %esp,%ebp
    a2f7:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    a2fa:	8b 45 08             	mov    0x8(%ebp),%eax
    a2fd:	c1 e8 16             	shr    $0x16,%eax
    a300:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    a303:	8b 45 08             	mov    0x8(%ebp),%eax
    a306:	c1 e8 0c             	shr    $0xc,%eax
    a309:	25 ff 03 00 00       	and    $0x3ff,%eax
    a30e:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a311:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a314:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a31b:	83 e0 23             	and    $0x23,%eax
    a31e:	83 f8 23             	cmp    $0x23,%eax
    a321:	75 4e                	jne    a371 <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a323:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a326:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a32d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a332:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a335:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a33f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a342:	01 d0                	add    %edx,%eax
    a344:	8b 00                	mov    (%eax),%eax
    a346:	83 e0 23             	and    $0x23,%eax
    a349:	83 f8 23             	cmp    $0x23,%eax
    a34c:	74 26                	je     a374 <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a34e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a351:	c1 e0 0c             	shl    $0xc,%eax
    a354:	89 c2                	mov    %eax,%edx
    a356:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a359:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a360:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a363:	01 c8                	add    %ecx,%eax
    a365:	83 ca 23             	or     $0x23,%edx
    a368:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a36a:	e8 e1 0f 00 00       	call   b350 <_FlushPagingCache_>
    a36f:	eb 04                	jmp    a375 <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a371:	90                   	nop
    a372:	eb 01                	jmp    a375 <map_linear_address+0x81>
            return; // the linear address was already mapped
    a374:	90                   	nop
}
    a375:	c9                   	leave  
    a376:	c3                   	ret    

0000a377 <Paging_fault>:

void Paging_fault()
{
    a377:	55                   	push   %ebp
    a378:	89 e5                	mov    %esp,%ebp
}
    a37a:	90                   	nop
    a37b:	5d                   	pop    %ebp
    a37c:	c3                   	ret    

0000a37d <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a37d:	55                   	push   %ebp
    a37e:	89 e5                	mov    %esp,%ebp
    a380:	83 ec 04             	sub    $0x4,%esp
    a383:	8b 45 08             	mov    0x8(%ebp),%eax
    a386:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a389:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a38d:	76 0b                	jbe    a39a <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a38f:	ba a0 00 00 00       	mov    $0xa0,%edx
    a394:	b8 20 00 00 00       	mov    $0x20,%eax
    a399:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a39a:	ba 20 00 00 00       	mov    $0x20,%edx
    a39f:	b8 20 00 00 00       	mov    $0x20,%eax
    a3a4:	ee                   	out    %al,(%dx)
}
    a3a5:	90                   	nop
    a3a6:	c9                   	leave  
    a3a7:	c3                   	ret    

0000a3a8 <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a3a8:	55                   	push   %ebp
    a3a9:	89 e5                	mov    %esp,%ebp
    a3ab:	83 ec 18             	sub    $0x18,%esp
    a3ae:	8b 55 08             	mov    0x8(%ebp),%edx
    a3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
    a3b4:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a3b7:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a3ba:	b8 21 00 00 00       	mov    $0x21,%eax
    a3bf:	89 c2                	mov    %eax,%edx
    a3c1:	ec                   	in     (%dx),%al
    a3c2:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a3c6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a3ca:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2 = inb(PIC2_DATA);
    a3cd:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a3d2:	89 c2                	mov    %eax,%edx
    a3d4:	ec                   	in     (%dx),%al
    a3d5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a3d9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a3dd:	88 45 f9             	mov    %al,-0x7(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a3e0:	ba 20 00 00 00       	mov    $0x20,%edx
    a3e5:	b8 11 00 00 00       	mov    $0x11,%eax
    a3ea:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a3eb:	eb 00                	jmp    a3ed <PIC_remap+0x45>
    a3ed:	eb 00                	jmp    a3ef <PIC_remap+0x47>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a3ef:	ba a0 00 00 00       	mov    $0xa0,%edx
    a3f4:	b8 11 00 00 00       	mov    $0x11,%eax
    a3f9:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a3fa:	eb 00                	jmp    a3fc <PIC_remap+0x54>
    a3fc:	eb 00                	jmp    a3fe <PIC_remap+0x56>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a3fe:	ba 21 00 00 00       	mov    $0x21,%edx
    a403:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a407:	ee                   	out    %al,(%dx)
    io_wait;
    a408:	eb 00                	jmp    a40a <PIC_remap+0x62>
    a40a:	eb 00                	jmp    a40c <PIC_remap+0x64>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a40c:	ba a1 00 00 00       	mov    $0xa1,%edx
    a411:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a415:	ee                   	out    %al,(%dx)
    io_wait;
    a416:	eb 00                	jmp    a418 <PIC_remap+0x70>
    a418:	eb 00                	jmp    a41a <PIC_remap+0x72>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a41a:	ba 21 00 00 00       	mov    $0x21,%edx
    a41f:	b8 04 00 00 00       	mov    $0x4,%eax
    a424:	ee                   	out    %al,(%dx)
    io_wait;
    a425:	eb 00                	jmp    a427 <PIC_remap+0x7f>
    a427:	eb 00                	jmp    a429 <PIC_remap+0x81>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a429:	ba a1 00 00 00       	mov    $0xa1,%edx
    a42e:	b8 02 00 00 00       	mov    $0x2,%eax
    a433:	ee                   	out    %al,(%dx)
    io_wait;
    a434:	eb 00                	jmp    a436 <PIC_remap+0x8e>
    a436:	eb 00                	jmp    a438 <PIC_remap+0x90>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a438:	ba 21 00 00 00       	mov    $0x21,%edx
    a43d:	b8 01 00 00 00       	mov    $0x1,%eax
    a442:	ee                   	out    %al,(%dx)
    io_wait;
    a443:	eb 00                	jmp    a445 <PIC_remap+0x9d>
    a445:	eb 00                	jmp    a447 <PIC_remap+0x9f>

    outb(PIC2_DATA, ICW4_8086);
    a447:	ba a1 00 00 00       	mov    $0xa1,%edx
    a44c:	b8 01 00 00 00       	mov    $0x1,%eax
    a451:	ee                   	out    %al,(%dx)
    io_wait;
    a452:	eb 00                	jmp    a454 <PIC_remap+0xac>
    a454:	eb 00                	jmp    a456 <PIC_remap+0xae>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a456:	ba 21 00 00 00       	mov    $0x21,%edx
    a45b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a45f:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a460:	ba a1 00 00 00       	mov    $0xa1,%edx
    a465:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a469:	ee                   	out    %al,(%dx)
}
    a46a:	90                   	nop
    a46b:	c9                   	leave  
    a46c:	c3                   	ret    

0000a46d <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a46d:	55                   	push   %ebp
    a46e:	89 e5                	mov    %esp,%ebp
    a470:	53                   	push   %ebx
    a471:	83 ec 14             	sub    $0x14,%esp
    a474:	8b 45 08             	mov    0x8(%ebp),%eax
    a477:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a47a:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a47e:	77 08                	ja     a488 <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a480:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a486:	eb 0a                	jmp    a492 <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a488:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a48e:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a492:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a496:	89 c2                	mov    %eax,%edx
    a498:	ec                   	in     (%dx),%al
    a499:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a49d:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a4a1:	89 c3                	mov    %eax,%ebx
    a4a3:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a4a7:	ba 01 00 00 00       	mov    $0x1,%edx
    a4ac:	89 c1                	mov    %eax,%ecx
    a4ae:	d3 e2                	shl    %cl,%edx
    a4b0:	89 d0                	mov    %edx,%eax
    a4b2:	09 d8                	or     %ebx,%eax
    a4b4:	88 45 f7             	mov    %al,-0x9(%ebp)

    outb(port, value);
    a4b7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a4bb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a4bf:	ee                   	out    %al,(%dx)
}
    a4c0:	90                   	nop
    a4c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a4c4:	c9                   	leave  
    a4c5:	c3                   	ret    

0000a4c6 <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a4c6:	55                   	push   %ebp
    a4c7:	89 e5                	mov    %esp,%ebp
    a4c9:	53                   	push   %ebx
    a4ca:	83 ec 14             	sub    $0x14,%esp
    a4cd:	8b 45 08             	mov    0x8(%ebp),%eax
    a4d0:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a4d3:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a4d7:	77 09                	ja     a4e2 <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a4d9:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a4e0:	eb 0b                	jmp    a4ed <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a4e2:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a4e9:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a4ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a4f0:	89 c2                	mov    %eax,%edx
    a4f2:	ec                   	in     (%dx),%al
    a4f3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a4f7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a4fb:	89 c3                	mov    %eax,%ebx
    a4fd:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a501:	ba 01 00 00 00       	mov    $0x1,%edx
    a506:	89 c1                	mov    %eax,%ecx
    a508:	d3 e2                	shl    %cl,%edx
    a50a:	89 d0                	mov    %edx,%eax
    a50c:	f7 d0                	not    %eax
    a50e:	21 d8                	and    %ebx,%eax
    a510:	88 45 f5             	mov    %al,-0xb(%ebp)

    outb(port, value);
    a513:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a516:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a51a:	ee                   	out    %al,(%dx)
}
    a51b:	90                   	nop
    a51c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a51f:	c9                   	leave  
    a520:	c3                   	ret    

0000a521 <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a521:	55                   	push   %ebp
    a522:	89 e5                	mov    %esp,%ebp
    a524:	83 ec 14             	sub    $0x14,%esp
    a527:	8b 45 08             	mov    0x8(%ebp),%eax
    a52a:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a52d:	ba 20 00 00 00       	mov    $0x20,%edx
    a532:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a536:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a537:	ba a0 00 00 00       	mov    $0xa0,%edx
    a53c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a540:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a541:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a546:	89 c2                	mov    %eax,%edx
    a548:	ec                   	in     (%dx),%al
    a549:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a54d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a551:	98                   	cwtl   
    a552:	c1 e0 08             	shl    $0x8,%eax
    a555:	89 c1                	mov    %eax,%ecx
    a557:	b8 20 00 00 00       	mov    $0x20,%eax
    a55c:	89 c2                	mov    %eax,%edx
    a55e:	ec                   	in     (%dx),%al
    a55f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a563:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a567:	09 c8                	or     %ecx,%eax
}
    a569:	c9                   	leave  
    a56a:	c3                   	ret    

0000a56b <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a56b:	55                   	push   %ebp
    a56c:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a56e:	6a 0b                	push   $0xb
    a570:	e8 ac ff ff ff       	call   a521 <__pic_get_irq_reg>
    a575:	83 c4 04             	add    $0x4,%esp
}
    a578:	c9                   	leave  
    a579:	c3                   	ret    

0000a57a <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a57a:	55                   	push   %ebp
    a57b:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a57d:	6a 0a                	push   $0xa
    a57f:	e8 9d ff ff ff       	call   a521 <__pic_get_irq_reg>
    a584:	83 c4 04             	add    $0x4,%esp
}
    a587:	c9                   	leave  
    a588:	c3                   	ret    

0000a589 <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a589:	55                   	push   %ebp
    a58a:	89 e5                	mov    %esp,%ebp
    a58c:	83 ec 14             	sub    $0x14,%esp
    a58f:	8b 45 08             	mov    0x8(%ebp),%eax
    a592:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a595:	e8 d1 ff ff ff       	call   a56b <pic_get_isr>
    a59a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a59e:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a5a2:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a5a6:	74 13                	je     a5bb <spurious_IRQ+0x32>
    a5a8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a5ac:	0f b6 c0             	movzbl %al,%eax
    a5af:	83 e0 07             	and    $0x7,%eax
    a5b2:	50                   	push   %eax
    a5b3:	e8 c5 fd ff ff       	call   a37d <PIC_sendEOI>
    a5b8:	83 c4 04             	add    $0x4,%esp
    a5bb:	90                   	nop
    a5bc:	c9                   	leave  
    a5bd:	c3                   	ret    

0000a5be <conserv_status_byte>:
uint32_t compteur   = 0;
uint8_t  frequency  = 0;
uint8_t  status_PIT = 0;

void conserv_status_byte()
{
    a5be:	55                   	push   %ebp
    a5bf:	89 e5                	mov    %esp,%ebp
    a5c1:	83 ec 10             	sub    $0x10,%esp
    set_pit_count(PIT_0, PIT_reload_value);
    a5c4:	ba 43 00 00 00       	mov    $0x43,%edx
    a5c9:	b8 40 00 00 00       	mov    $0x40,%eax
    a5ce:	ee                   	out    %al,(%dx)
    a5cf:	b8 40 00 00 00       	mov    $0x40,%eax
    a5d4:	89 c2                	mov    %eax,%edx
    a5d6:	ec                   	in     (%dx),%al
    a5d7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a5db:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a5df:	88 45 f6             	mov    %al,-0xa(%ebp)
    a5e2:	b8 40 00 00 00       	mov    $0x40,%eax
    a5e7:	89 c2                	mov    %eax,%edx
    a5e9:	ec                   	in     (%dx),%al
    a5ea:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a5ee:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a5f2:	88 45 f7             	mov    %al,-0x9(%ebp)
    a5f5:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a5f9:	66 98                	cbtw   
    a5fb:	ba 40 00 00 00       	mov    $0x40,%edx
    a600:	ee                   	out    %al,(%dx)
    a601:	a1 74 32 02 00       	mov    0x23274,%eax
    a606:	c1 f8 08             	sar    $0x8,%eax
    a609:	ba 40 00 00 00       	mov    $0x40,%edx
    a60e:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a60f:	ba 43 00 00 00       	mov    $0x43,%edx
    a614:	b8 40 00 00 00       	mov    $0x40,%eax
    a619:	ee                   	out    %al,(%dx)
    a61a:	b8 40 00 00 00       	mov    $0x40,%eax
    a61f:	89 c2                	mov    %eax,%edx
    a621:	ec                   	in     (%dx),%al
    a622:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a626:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a62a:	88 45 f4             	mov    %al,-0xc(%ebp)
    a62d:	b8 40 00 00 00       	mov    $0x40,%eax
    a632:	89 c2                	mov    %eax,%edx
    a634:	ec                   	in     (%dx),%al
    a635:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a639:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a63d:	88 45 f5             	mov    %al,-0xb(%ebp)
    a640:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a644:	66 98                	cbtw   
    a646:	ba 43 00 00 00       	mov    $0x43,%edx
    a64b:	ee                   	out    %al,(%dx)
    a64c:	ba 43 00 00 00       	mov    $0x43,%edx
    a651:	b8 34 00 00 00       	mov    $0x34,%eax
    a656:	ee                   	out    %al,(%dx)
}
    a657:	90                   	nop
    a658:	c9                   	leave  
    a659:	c3                   	ret    

0000a65a <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a65a:	55                   	push   %ebp
    a65b:	89 e5                	mov    %esp,%ebp
    a65d:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a660:	0f b6 05 40 31 02 00 	movzbl 0x23140,%eax
    a667:	3c 01                	cmp    $0x1,%al
    a669:	75 27                	jne    a692 <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a66b:	a1 44 31 02 00       	mov    0x23144,%eax
    a670:	85 c0                	test   %eax,%eax
    a672:	75 11                	jne    a685 <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a674:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    a67b:	01 00 00 
            __switch();
    a67e:	e8 e1 0a 00 00       	call   b164 <__switch>
        } else
            sheduler.task_timer--;
    }
}
    a683:	eb 0d                	jmp    a692 <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a685:	a1 44 31 02 00       	mov    0x23144,%eax
    a68a:	83 e8 01             	sub    $0x1,%eax
    a68d:	a3 44 31 02 00       	mov    %eax,0x23144
}
    a692:	90                   	nop
    a693:	c9                   	leave  
    a694:	c3                   	ret    

0000a695 <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a695:	55                   	push   %ebp
    a696:	89 e5                	mov    %esp,%ebp
    a698:	83 ec 28             	sub    $0x28,%esp
    a69b:	8b 45 08             	mov    0x8(%ebp),%eax
    a69e:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a6a2:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a6a6:	a2 04 20 01 00       	mov    %al,0x12004
    calculate_frequency();
    a6ab:	e8 0c 0d 00 00       	call   b3bc <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a6b0:	ba 43 00 00 00       	mov    $0x43,%edx
    a6b5:	b8 40 00 00 00       	mov    $0x40,%eax
    a6ba:	ee                   	out    %al,(%dx)
    a6bb:	b8 40 00 00 00       	mov    $0x40,%eax
    a6c0:	89 c2                	mov    %eax,%edx
    a6c2:	ec                   	in     (%dx),%al
    a6c3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a6c7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a6cb:	88 45 ee             	mov    %al,-0x12(%ebp)
    a6ce:	b8 40 00 00 00       	mov    $0x40,%eax
    a6d3:	89 c2                	mov    %eax,%edx
    a6d5:	ec                   	in     (%dx),%al
    a6d6:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    a6da:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
    a6de:	88 45 ef             	mov    %al,-0x11(%ebp)
    a6e1:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    a6e5:	66 98                	cbtw   
    a6e7:	ba 43 00 00 00       	mov    $0x43,%edx
    a6ec:	ee                   	out    %al,(%dx)
    a6ed:	ba 43 00 00 00       	mov    $0x43,%edx
    a6f2:	b8 34 00 00 00       	mov    $0x34,%eax
    a6f7:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a6f8:	ba 43 00 00 00       	mov    $0x43,%edx
    a6fd:	b8 40 00 00 00       	mov    $0x40,%eax
    a702:	ee                   	out    %al,(%dx)
    a703:	b8 40 00 00 00       	mov    $0x40,%eax
    a708:	89 c2                	mov    %eax,%edx
    a70a:	ec                   	in     (%dx),%al
    a70b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a70f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a713:	88 45 ec             	mov    %al,-0x14(%ebp)
    a716:	b8 40 00 00 00       	mov    $0x40,%eax
    a71b:	89 c2                	mov    %eax,%edx
    a71d:	ec                   	in     (%dx),%al
    a71e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a722:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a726:	88 45 ed             	mov    %al,-0x13(%ebp)
    a729:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a72d:	66 98                	cbtw   
    a72f:	ba 40 00 00 00       	mov    $0x40,%edx
    a734:	ee                   	out    %al,(%dx)
    a735:	a1 74 32 02 00       	mov    0x23274,%eax
    a73a:	c1 f8 08             	sar    $0x8,%eax
    a73d:	ba 40 00 00 00       	mov    $0x40,%edx
    a742:	ee                   	out    %al,(%dx)
}
    a743:	90                   	nop
    a744:	c9                   	leave  
    a745:	c3                   	ret    

0000a746 <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a746:	55                   	push   %ebp
    a747:	89 e5                	mov    %esp,%ebp
    a749:	83 ec 14             	sub    $0x14,%esp
    a74c:	8b 45 08             	mov    0x8(%ebp),%eax
    a74f:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a752:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a756:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a75a:	83 f8 42             	cmp    $0x42,%eax
    a75d:	74 1d                	je     a77c <read_back_channel+0x36>
    a75f:	83 f8 42             	cmp    $0x42,%eax
    a762:	7f 1e                	jg     a782 <read_back_channel+0x3c>
    a764:	83 f8 40             	cmp    $0x40,%eax
    a767:	74 07                	je     a770 <read_back_channel+0x2a>
    a769:	83 f8 41             	cmp    $0x41,%eax
    a76c:	74 08                	je     a776 <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a76e:	eb 12                	jmp    a782 <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a770:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a774:	eb 0d                	jmp    a783 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a776:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a77a:	eb 07                	jmp    a783 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a77c:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a780:	eb 01                	jmp    a783 <read_back_channel+0x3d>
        break;
    a782:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a783:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a787:	ba 43 00 00 00       	mov    $0x43,%edx
    a78c:	b8 40 00 00 00       	mov    $0x40,%eax
    a791:	ee                   	out    %al,(%dx)
    a792:	b8 40 00 00 00       	mov    $0x40,%eax
    a797:	89 c2                	mov    %eax,%edx
    a799:	ec                   	in     (%dx),%al
    a79a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a79e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a7a2:	88 45 f4             	mov    %al,-0xc(%ebp)
    a7a5:	b8 40 00 00 00       	mov    $0x40,%eax
    a7aa:	89 c2                	mov    %eax,%edx
    a7ac:	ec                   	in     (%dx),%al
    a7ad:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a7b1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a7b5:	88 45 f5             	mov    %al,-0xb(%ebp)
    a7b8:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a7bc:	66 98                	cbtw   
    a7be:	ba 43 00 00 00       	mov    $0x43,%edx
    a7c3:	ee                   	out    %al,(%dx)
    a7c4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a7c8:	c1 f8 08             	sar    $0x8,%eax
    a7cb:	ba 43 00 00 00       	mov    $0x43,%edx
    a7d0:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a7d1:	ba 43 00 00 00       	mov    $0x43,%edx
    a7d6:	b8 40 00 00 00       	mov    $0x40,%eax
    a7db:	ee                   	out    %al,(%dx)
    a7dc:	b8 40 00 00 00       	mov    $0x40,%eax
    a7e1:	89 c2                	mov    %eax,%edx
    a7e3:	ec                   	in     (%dx),%al
    a7e4:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a7e8:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a7ec:	88 45 f2             	mov    %al,-0xe(%ebp)
    a7ef:	b8 40 00 00 00       	mov    $0x40,%eax
    a7f4:	89 c2                	mov    %eax,%edx
    a7f6:	ec                   	in     (%dx),%al
    a7f7:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a7fb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a7ff:	88 45 f3             	mov    %al,-0xd(%ebp)
    a802:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a806:	66 98                	cbtw   
    a808:	c9                   	leave  
    a809:	c3                   	ret    

0000a80a <read_ebp>:
        registers;                                                     \
    })

static inline uint32_t
read_ebp(void)
{
    a80a:	55                   	push   %ebp
    a80b:	89 e5                	mov    %esp,%ebp
    a80d:	83 ec 10             	sub    $0x10,%esp
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
    a810:	89 e8                	mov    %ebp,%eax
    a812:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(ebp));
    return ebp;
    a815:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a818:	c9                   	leave  
    a819:	c3                   	ret    

0000a81a <backtrace>:
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    a81a:	55                   	push   %ebp
    a81b:	89 e5                	mov    %esp,%ebp
    a81d:	83 ec 18             	sub    $0x18,%esp
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;
    a820:	e8 e5 ff ff ff       	call   a80a <read_ebp>
    a825:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a828:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a82b:	83 c0 04             	add    $0x4,%eax
    a82e:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp != 0) {
    a831:	eb 30                	jmp    a863 <backtrace+0x49>
        kprintf("ebp %x eip %x\n", ebp, *eip);
    a833:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a836:	8b 00                	mov    (%eax),%eax
    a838:	83 ec 04             	sub    $0x4,%esp
    a83b:	50                   	push   %eax
    a83c:	ff 75 f4             	pushl  -0xc(%ebp)
    a83f:	68 c3 f0 00 00       	push   $0xf0c3
    a844:	e8 0c 01 00 00       	call   a955 <kprintf>
    a849:	83 c4 10             	add    $0x10,%esp

        ptr = (int*)(ebp);
    a84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a84f:	89 45 ec             	mov    %eax,-0x14(%ebp)

        ebp = (int)(*ptr);
    a852:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a855:	8b 00                	mov    (%eax),%eax
    a857:	89 45 f4             	mov    %eax,-0xc(%ebp)

        eip = (int*)(ebp + 4);
    a85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a85d:	83 c0 04             	add    $0x4,%eax
    a860:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (ebp != 0) {
    a863:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    a867:	75 ca                	jne    a833 <backtrace+0x19>
    }
    return 0;
    a869:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a86e:	c9                   	leave  
    a86f:	c3                   	ret    

0000a870 <mon_help>:

int mon_help(int argc, char** argv)
{
    a870:	55                   	push   %ebp
    a871:	89 e5                	mov    %esp,%ebp
    a873:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 2; i++)
    a876:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a87d:	eb 3c                	jmp    a8bb <mon_help+0x4b>
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    a87f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a882:	89 d0                	mov    %edx,%eax
    a884:	01 c0                	add    %eax,%eax
    a886:	01 d0                	add    %edx,%eax
    a888:	c1 e0 02             	shl    $0x2,%eax
    a88b:	05 68 b6 00 00       	add    $0xb668,%eax
    a890:	8b 10                	mov    (%eax),%edx
    a892:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    a895:	89 c8                	mov    %ecx,%eax
    a897:	01 c0                	add    %eax,%eax
    a899:	01 c8                	add    %ecx,%eax
    a89b:	c1 e0 02             	shl    $0x2,%eax
    a89e:	05 64 b6 00 00       	add    $0xb664,%eax
    a8a3:	8b 00                	mov    (%eax),%eax
    a8a5:	83 ec 04             	sub    $0x4,%esp
    a8a8:	52                   	push   %edx
    a8a9:	50                   	push   %eax
    a8aa:	68 d2 f0 00 00       	push   $0xf0d2
    a8af:	e8 a1 00 00 00       	call   a955 <kprintf>
    a8b4:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 2; i++)
    a8b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a8bb:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    a8bf:	7e be                	jle    a87f <mon_help+0xf>
    return 0;
    a8c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a8c6:	c9                   	leave  
    a8c7:	c3                   	ret    

0000a8c8 <monitor_service_keyboard>:

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    a8c8:	55                   	push   %ebp
    a8c9:	89 e5                	mov    %esp,%ebp
    a8cb:	83 ec 18             	sub    $0x18,%esp
    if (get_ASCII_code_keyboard() != '\0') {
    a8ce:	e8 b5 f8 ff ff       	call   a188 <get_ASCII_code_keyboard>
    a8d3:	84 c0                	test   %al,%al
    a8d5:	74 7b                	je     a952 <monitor_service_keyboard+0x8a>
        int8_t code = get_ASCII_code_keyboard();
    a8d7:	e8 ac f8 ff ff       	call   a188 <get_ASCII_code_keyboard>
    a8dc:	88 45 f3             	mov    %al,-0xd(%ebp)
        if (code != '\n') {
    a8df:	80 7d f3 0a          	cmpb   $0xa,-0xd(%ebp)
    a8e3:	74 25                	je     a90a <monitor_service_keyboard+0x42>
            keyboard_code_monitor[keyboard_num] = code;
    a8e5:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a8ec:	0f be c0             	movsbl %al,%eax
    a8ef:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
    a8f3:	88 90 20 20 01 00    	mov    %dl,0x12020(%eax)
            keyboard_num++;
    a8f9:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a900:	83 c0 01             	add    $0x1,%eax
    a903:	a2 1f 21 01 00       	mov    %al,0x1211f
            }

            keyboard_num = 0;
        }
    }
    a908:	eb 48                	jmp    a952 <monitor_service_keyboard+0x8a>
            for (i = 0; i < keyboard_num; i++) {
    a90a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a911:	eb 29                	jmp    a93c <monitor_service_keyboard+0x74>
                putchar(keyboard_code_monitor[i]);
    a913:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a916:	05 20 20 01 00       	add    $0x12020,%eax
    a91b:	0f b6 00             	movzbl (%eax),%eax
    a91e:	0f b6 c0             	movzbl %al,%eax
    a921:	83 ec 0c             	sub    $0xc,%esp
    a924:	50                   	push   %eax
    a925:	e8 ef e6 ff ff       	call   9019 <putchar>
    a92a:	83 c4 10             	add    $0x10,%esp
                keyboard_code_monitor[i] = 0;
    a92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a930:	05 20 20 01 00       	add    $0x12020,%eax
    a935:	c6 00 00             	movb   $0x0,(%eax)
            for (i = 0; i < keyboard_num; i++) {
    a938:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a93c:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a943:	0f be c0             	movsbl %al,%eax
    a946:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a949:	7c c8                	jl     a913 <monitor_service_keyboard+0x4b>
            keyboard_num = 0;
    a94b:	c6 05 1f 21 01 00 00 	movb   $0x0,0x1211f
    a952:	90                   	nop
    a953:	c9                   	leave  
    a954:	c3                   	ret    

0000a955 <kprintf>:
#include <stdint.h>

extern void printf(const char* fmt, va_list arg);

void kprintf(const char* frmt, ...)
{
    a955:	55                   	push   %ebp
    a956:	89 e5                	mov    %esp,%ebp
    a958:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    a95b:	8d 45 0c             	lea    0xc(%ebp),%eax
    a95e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    a961:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a964:	83 ec 08             	sub    $0x8,%esp
    a967:	50                   	push   %eax
    a968:	ff 75 08             	pushl  0x8(%ebp)
    a96b:	e8 2e e7 ff ff       	call   909e <printf>
    a970:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    a973:	90                   	nop
    a974:	c9                   	leave  
    a975:	c3                   	ret    

0000a976 <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    a976:	55                   	push   %ebp
    a977:	89 e5                	mov    %esp,%ebp
    a979:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    a97c:	b8 1b 00 00 00       	mov    $0x1b,%eax
    a981:	89 c1                	mov    %eax,%ecx
    a983:	0f 32                	rdmsr  
    a985:	89 45 f8             	mov    %eax,-0x8(%ebp)
    a988:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    a98b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a98e:	c1 e0 05             	shl    $0x5,%eax
    a991:	89 c2                	mov    %eax,%edx
    a993:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a996:	01 d0                	add    %edx,%eax
}
    a998:	c9                   	leave  
    a999:	c3                   	ret    

0000a99a <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    a99a:	55                   	push   %ebp
    a99b:	89 e5                	mov    %esp,%ebp
    a99d:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    a9a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    a9a7:	8b 45 08             	mov    0x8(%ebp),%eax
    a9aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a9af:	80 cc 08             	or     $0x8,%ah
    a9b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    a9b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a9b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a9bb:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    a9c0:	0f 30                	wrmsr  
}
    a9c2:	90                   	nop
    a9c3:	c9                   	leave  
    a9c4:	c3                   	ret    

0000a9c5 <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    a9c5:	55                   	push   %ebp
    a9c6:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    a9c8:	8b 15 20 21 01 00    	mov    0x12120,%edx
    a9ce:	8b 45 08             	mov    0x8(%ebp),%eax
    a9d1:	01 c0                	add    %eax,%eax
    a9d3:	01 d0                	add    %edx,%eax
    a9d5:	0f b7 00             	movzwl (%eax),%eax
    a9d8:	0f b7 c0             	movzwl %ax,%eax
}
    a9db:	5d                   	pop    %ebp
    a9dc:	c3                   	ret    

0000a9dd <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    a9dd:	55                   	push   %ebp
    a9de:	89 e5                	mov    %esp,%ebp
    a9e0:	83 ec 04             	sub    $0x4,%esp
    a9e3:	8b 45 0c             	mov    0xc(%ebp),%eax
    a9e6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    a9ea:	8b 15 20 21 01 00    	mov    0x12120,%edx
    a9f0:	8b 45 08             	mov    0x8(%ebp),%eax
    a9f3:	01 c0                	add    %eax,%eax
    a9f5:	01 c2                	add    %eax,%edx
    a9f7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a9fb:	66 89 02             	mov    %ax,(%edx)
}
    a9fe:	90                   	nop
    a9ff:	c9                   	leave  
    aa00:	c3                   	ret    

0000aa01 <enable_local_apic>:

void enable_local_apic()
{
    aa01:	55                   	push   %ebp
    aa02:	89 e5                	mov    %esp,%ebp
    aa04:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    aa07:	83 ec 08             	sub    $0x8,%esp
    aa0a:	68 fb 03 00 00       	push   $0x3fb
    aa0f:	68 00 d0 00 00       	push   $0xd000
    aa14:	e8 80 f7 ff ff       	call   a199 <create_page_table>
    aa19:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    aa1c:	e8 55 ff ff ff       	call   a976 <get_apic_base>
    aa21:	a3 20 21 01 00       	mov    %eax,0x12120

    set_apic_base(get_apic_base());
    aa26:	e8 4b ff ff ff       	call   a976 <get_apic_base>
    aa2b:	83 ec 0c             	sub    $0xc,%esp
    aa2e:	50                   	push   %eax
    aa2f:	e8 66 ff ff ff       	call   a99a <set_apic_base>
    aa34:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    aa37:	83 ec 0c             	sub    $0xc,%esp
    aa3a:	68 f0 00 00 00       	push   $0xf0
    aa3f:	e8 81 ff ff ff       	call   a9c5 <cpu_ReadLocalAPICReg>
    aa44:	83 c4 10             	add    $0x10,%esp
    aa47:	80 cc 01             	or     $0x1,%ah
    aa4a:	0f b7 c0             	movzwl %ax,%eax
    aa4d:	83 ec 08             	sub    $0x8,%esp
    aa50:	50                   	push   %eax
    aa51:	68 f0 00 00 00       	push   $0xf0
    aa56:	e8 82 ff ff ff       	call   a9dd <cpu_SetLocalAPICReg>
    aa5b:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    aa5e:	83 ec 08             	sub    $0x8,%esp
    aa61:	6a 02                	push   $0x2
    aa63:	6a 20                	push   $0x20
    aa65:	e8 73 ff ff ff       	call   a9dd <cpu_SetLocalAPICReg>
    aa6a:	83 c4 10             	add    $0x10,%esp
}
    aa6d:	90                   	nop
    aa6e:	c9                   	leave  
    aa6f:	c3                   	ret    

0000aa70 <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    aa70:	55                   	push   %ebp
    aa71:	89 e5                	mov    %esp,%ebp
    aa73:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    aa76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    aa7d:	eb 49                	jmp    aac8 <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    aa7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa82:	89 d0                	mov    %edx,%eax
    aa84:	01 c0                	add    %eax,%eax
    aa86:	01 d0                	add    %edx,%eax
    aa88:	c1 e0 02             	shl    $0x2,%eax
    aa8b:	05 40 21 01 00       	add    $0x12140,%eax
    aa90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    aa96:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa99:	89 d0                	mov    %edx,%eax
    aa9b:	01 c0                	add    %eax,%eax
    aa9d:	01 d0                	add    %edx,%eax
    aa9f:	c1 e0 02             	shl    $0x2,%eax
    aaa2:	05 48 21 01 00       	add    $0x12148,%eax
    aaa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    aaad:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aab0:	89 d0                	mov    %edx,%eax
    aab2:	01 c0                	add    %eax,%eax
    aab4:	01 d0                	add    %edx,%eax
    aab6:	c1 e0 02             	shl    $0x2,%eax
    aab9:	05 44 21 01 00       	add    $0x12144,%eax
    aabe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    aac4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    aac8:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    aacf:	7e ae                	jle    aa7f <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    aad1:	c7 05 40 e1 01 00 40 	movl   $0x12140,0x1e140
    aad8:	21 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    aadb:	90                   	nop
    aadc:	c9                   	leave  
    aadd:	c3                   	ret    

0000aade <kmalloc>:

void* kmalloc(uint32_t size)
{
    aade:	55                   	push   %ebp
    aadf:	89 e5                	mov    %esp,%ebp
    aae1:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    aae4:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aae9:	8b 00                	mov    (%eax),%eax
    aaeb:	85 c0                	test   %eax,%eax
    aaed:	75 36                	jne    ab25 <kmalloc+0x47>
        _head_vmm_->address = KERNEL__VM_BASE;
    aaef:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aaf4:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    aaf9:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    aafb:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ab00:	8b 55 08             	mov    0x8(%ebp),%edx
    ab03:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    ab06:	83 ec 04             	sub    $0x4,%esp
    ab09:	ff 75 08             	pushl  0x8(%ebp)
    ab0c:	6a 00                	push   $0x0
    ab0e:	68 60 e1 01 00       	push   $0x1e160
    ab13:	e8 57 e8 ff ff       	call   936f <memset>
    ab18:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    ab1b:	b8 60 e1 01 00       	mov    $0x1e160,%eax
    ab20:	e9 7b 01 00 00       	jmp    aca0 <kmalloc+0x1c2>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    ab25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab2c:	eb 04                	jmp    ab32 <kmalloc+0x54>
        i++;
    ab2e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab32:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    ab39:	77 17                	ja     ab52 <kmalloc+0x74>
    ab3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab3e:	89 d0                	mov    %edx,%eax
    ab40:	01 c0                	add    %eax,%eax
    ab42:	01 d0                	add    %edx,%eax
    ab44:	c1 e0 02             	shl    $0x2,%eax
    ab47:	05 40 21 01 00       	add    $0x12140,%eax
    ab4c:	8b 00                	mov    (%eax),%eax
    ab4e:	85 c0                	test   %eax,%eax
    ab50:	75 dc                	jne    ab2e <kmalloc+0x50>

    _new_item_ = &MM_BLOCK[i];
    ab52:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab55:	89 d0                	mov    %edx,%eax
    ab57:	01 c0                	add    %eax,%eax
    ab59:	01 d0                	add    %edx,%eax
    ab5b:	c1 e0 02             	shl    $0x2,%eax
    ab5e:	05 40 21 01 00       	add    $0x12140,%eax
    ab63:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    ab66:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ab6b:	8b 00                	mov    (%eax),%eax
    ab6d:	b9 60 e1 01 00       	mov    $0x1e160,%ecx
    ab72:	8b 55 08             	mov    0x8(%ebp),%edx
    ab75:	01 ca                	add    %ecx,%edx
    ab77:	39 d0                	cmp    %edx,%eax
    ab79:	74 47                	je     abc2 <kmalloc+0xe4>
        _new_item_->address = KERNEL__VM_BASE;
    ab7b:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ab80:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab83:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    ab85:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab88:	8b 55 08             	mov    0x8(%ebp),%edx
    ab8b:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    ab8e:	8b 15 40 e1 01 00    	mov    0x1e140,%edx
    ab94:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab97:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    ab9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab9d:	a3 40 e1 01 00       	mov    %eax,0x1e140

        memset((void*)_new_item_->address, 0, size);
    aba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aba5:	8b 00                	mov    (%eax),%eax
    aba7:	83 ec 04             	sub    $0x4,%esp
    abaa:	ff 75 08             	pushl  0x8(%ebp)
    abad:	6a 00                	push   $0x0
    abaf:	50                   	push   %eax
    abb0:	e8 ba e7 ff ff       	call   936f <memset>
    abb5:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    abb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abbb:	8b 00                	mov    (%eax),%eax
    abbd:	e9 de 00 00 00       	jmp    aca0 <kmalloc+0x1c2>
    }

    tmp = _head_vmm_;
    abc2:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abc7:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    abca:	eb 27                	jmp    abf3 <kmalloc+0x115>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    abcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abcf:	8b 40 08             	mov    0x8(%eax),%eax
    abd2:	8b 10                	mov    (%eax),%edx
    abd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abd7:	8b 08                	mov    (%eax),%ecx
    abd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abdc:	8b 40 04             	mov    0x4(%eax),%eax
    abdf:	01 c1                	add    %eax,%ecx
    abe1:	8b 45 08             	mov    0x8(%ebp),%eax
    abe4:	01 c8                	add    %ecx,%eax
    abe6:	39 c2                	cmp    %eax,%edx
    abe8:	73 15                	jae    abff <kmalloc+0x121>
            break;

        tmp = tmp->next;
    abea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abed:	8b 40 08             	mov    0x8(%eax),%eax
    abf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    abf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abf6:	8b 40 08             	mov    0x8(%eax),%eax
    abf9:	85 c0                	test   %eax,%eax
    abfb:	75 cf                	jne    abcc <kmalloc+0xee>
    abfd:	eb 01                	jmp    ac00 <kmalloc+0x122>
            break;
    abff:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    ac00:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac03:	8b 40 08             	mov    0x8(%eax),%eax
    ac06:	85 c0                	test   %eax,%eax
    ac08:	75 4b                	jne    ac55 <kmalloc+0x177>
        _new_item_->size = size;
    ac0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac0d:	8b 55 08             	mov    0x8(%ebp),%edx
    ac10:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ac13:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac16:	8b 10                	mov    (%eax),%edx
    ac18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac1b:	8b 40 04             	mov    0x4(%eax),%eax
    ac1e:	01 c2                	add    %eax,%edx
    ac20:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac23:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    ac25:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    ac2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac32:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac35:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac38:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac3b:	8b 00                	mov    (%eax),%eax
    ac3d:	83 ec 04             	sub    $0x4,%esp
    ac40:	ff 75 08             	pushl  0x8(%ebp)
    ac43:	6a 00                	push   $0x0
    ac45:	50                   	push   %eax
    ac46:	e8 24 e7 ff ff       	call   936f <memset>
    ac4b:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac51:	8b 00                	mov    (%eax),%eax
    ac53:	eb 4b                	jmp    aca0 <kmalloc+0x1c2>
    }

    else {
        _new_item_->size = size;
    ac55:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac58:	8b 55 08             	mov    0x8(%ebp),%edx
    ac5b:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ac5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac61:	8b 10                	mov    (%eax),%edx
    ac63:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac66:	8b 40 04             	mov    0x4(%eax),%eax
    ac69:	01 c2                	add    %eax,%edx
    ac6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac6e:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    ac70:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac73:	8b 50 08             	mov    0x8(%eax),%edx
    ac76:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac79:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    ac7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac82:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac85:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac88:	8b 00                	mov    (%eax),%eax
    ac8a:	83 ec 04             	sub    $0x4,%esp
    ac8d:	ff 75 08             	pushl  0x8(%ebp)
    ac90:	6a 00                	push   $0x0
    ac92:	50                   	push   %eax
    ac93:	e8 d7 e6 ff ff       	call   936f <memset>
    ac98:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac9e:	8b 00                	mov    (%eax),%eax
    }
}
    aca0:	c9                   	leave  
    aca1:	c3                   	ret    

0000aca2 <free>:

void free(virtaddr_t _addr__)
{
    aca2:	55                   	push   %ebp
    aca3:	89 e5                	mov    %esp,%ebp
    aca5:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    aca8:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acad:	8b 00                	mov    (%eax),%eax
    acaf:	39 45 08             	cmp    %eax,0x8(%ebp)
    acb2:	75 29                	jne    acdd <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    acb4:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    acbf:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    accb:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acd0:	8b 40 08             	mov    0x8(%eax),%eax
    acd3:	a3 40 e1 01 00       	mov    %eax,0x1e140
        return;
    acd8:	e9 ac 00 00 00       	jmp    ad89 <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    acdd:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ace2:	8b 40 08             	mov    0x8(%eax),%eax
    ace5:	85 c0                	test   %eax,%eax
    ace7:	75 16                	jne    acff <free+0x5d>
    ace9:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acee:	8b 00                	mov    (%eax),%eax
    acf0:	39 45 08             	cmp    %eax,0x8(%ebp)
    acf3:	75 0a                	jne    acff <free+0x5d>
        init_vmm();
    acf5:	e8 76 fd ff ff       	call   aa70 <init_vmm>
        return;
    acfa:	e9 8a 00 00 00       	jmp    ad89 <free+0xe7>
    }

    tmp = _head_vmm_;
    acff:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ad04:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ad07:	eb 0f                	jmp    ad18 <free+0x76>
        tmp_prev = tmp;
    ad09:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    ad0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad12:	8b 40 08             	mov    0x8(%eax),%eax
    ad15:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ad18:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad1b:	8b 40 08             	mov    0x8(%eax),%eax
    ad1e:	85 c0                	test   %eax,%eax
    ad20:	74 0a                	je     ad2c <free+0x8a>
    ad22:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad25:	8b 00                	mov    (%eax),%eax
    ad27:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad2a:	75 dd                	jne    ad09 <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ad2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad2f:	8b 40 08             	mov    0x8(%eax),%eax
    ad32:	85 c0                	test   %eax,%eax
    ad34:	75 29                	jne    ad5f <free+0xbd>
    ad36:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad39:	8b 00                	mov    (%eax),%eax
    ad3b:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad3e:	75 1f                	jne    ad5f <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad40:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad49:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ad53:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ad5d:	eb 2a                	jmp    ad89 <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ad5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad62:	8b 00                	mov    (%eax),%eax
    ad64:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad67:	75 20                	jne    ad89 <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad69:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad72:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ad7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad7f:	8b 50 08             	mov    0x8(%eax),%edx
    ad82:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad85:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ad88:	90                   	nop
    }
    ad89:	c9                   	leave  
    ad8a:	c3                   	ret    

0000ad8b <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ad8b:	55                   	push   %ebp
    ad8c:	89 e5                	mov    %esp,%ebp
    ad8e:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ad91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    ad98:	eb 49                	jmp    ade3 <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ad9a:	ba db f0 00 00       	mov    $0xf0db,%edx
    ad9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ada2:	c1 e0 04             	shl    $0x4,%eax
    ada5:	05 40 f1 01 00       	add    $0x1f140,%eax
    adaa:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    adac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adaf:	c1 e0 04             	shl    $0x4,%eax
    adb2:	05 44 f1 01 00       	add    $0x1f144,%eax
    adb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    adbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adc0:	c1 e0 04             	shl    $0x4,%eax
    adc3:	05 4c f1 01 00       	add    $0x1f14c,%eax
    adc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    adce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    add1:	c1 e0 04             	shl    $0x4,%eax
    add4:	05 48 f1 01 00       	add    $0x1f148,%eax
    add9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    addf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    ade3:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    adea:	76 ae                	jbe    ad9a <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    adec:	83 ec 08             	sub    $0x8,%esp
    adef:	6a 01                	push   $0x1
    adf1:	68 00 e0 00 00       	push   $0xe000
    adf6:	e8 9e f3 ff ff       	call   a199 <create_page_table>
    adfb:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    adfe:	c7 05 20 f1 01 00 40 	movl   $0x1f140,0x1f120
    ae05:	f1 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    ae08:	90                   	nop
    ae09:	c9                   	leave  
    ae0a:	c3                   	ret    

0000ae0b <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    ae0b:	55                   	push   %ebp
    ae0c:	89 e5                	mov    %esp,%ebp
    ae0e:	53                   	push   %ebx
    ae0f:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    ae12:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae17:	8b 00                	mov    (%eax),%eax
    ae19:	ba db f0 00 00       	mov    $0xf0db,%edx
    ae1e:	39 d0                	cmp    %edx,%eax
    ae20:	75 40                	jne    ae62 <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    ae22:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae27:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    ae2d:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae32:	8b 55 08             	mov    0x8(%ebp),%edx
    ae35:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    ae38:	8b 45 08             	mov    0x8(%ebp),%eax
    ae3b:	c1 e0 0c             	shl    $0xc,%eax
    ae3e:	89 c2                	mov    %eax,%edx
    ae40:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae45:	8b 00                	mov    (%eax),%eax
    ae47:	83 ec 04             	sub    $0x4,%esp
    ae4a:	52                   	push   %edx
    ae4b:	6a 00                	push   $0x0
    ae4d:	50                   	push   %eax
    ae4e:	e8 1c e5 ff ff       	call   936f <memset>
    ae53:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    ae56:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae5b:	8b 00                	mov    (%eax),%eax
    ae5d:	e9 ae 01 00 00       	jmp    b010 <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    ae62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae69:	eb 04                	jmp    ae6f <alloc_page+0x64>
        i++;
    ae6b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae72:	c1 e0 04             	shl    $0x4,%eax
    ae75:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae7a:	8b 00                	mov    (%eax),%eax
    ae7c:	ba db f0 00 00       	mov    $0xf0db,%edx
    ae81:	39 d0                	cmp    %edx,%eax
    ae83:	74 09                	je     ae8e <alloc_page+0x83>
    ae85:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    ae8c:	76 dd                	jbe    ae6b <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    ae8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae91:	c1 e0 04             	shl    $0x4,%eax
    ae94:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae99:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    ae9c:	a1 20 f1 01 00       	mov    0x1f120,%eax
    aea1:	8b 00                	mov    (%eax),%eax
    aea3:	8b 55 08             	mov    0x8(%ebp),%edx
    aea6:	81 c2 00 01 00 00    	add    $0x100,%edx
    aeac:	c1 e2 0c             	shl    $0xc,%edx
    aeaf:	39 d0                	cmp    %edx,%eax
    aeb1:	72 4c                	jb     aeff <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    aeb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aeb6:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    aebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aebf:	8b 55 08             	mov    0x8(%ebp),%edx
    aec2:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    aec5:	8b 15 20 f1 01 00    	mov    0x1f120,%edx
    aecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aece:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    aed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aed4:	a3 20 f1 01 00       	mov    %eax,0x1f120

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    aed9:	8b 45 08             	mov    0x8(%ebp),%eax
    aedc:	c1 e0 0c             	shl    $0xc,%eax
    aedf:	89 c2                	mov    %eax,%edx
    aee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aee4:	8b 00                	mov    (%eax),%eax
    aee6:	83 ec 04             	sub    $0x4,%esp
    aee9:	52                   	push   %edx
    aeea:	6a 00                	push   $0x0
    aeec:	50                   	push   %eax
    aeed:	e8 7d e4 ff ff       	call   936f <memset>
    aef2:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    aef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aef8:	8b 00                	mov    (%eax),%eax
    aefa:	e9 11 01 00 00       	jmp    b010 <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    aeff:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af04:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    af07:	eb 2a                	jmp    af33 <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    af09:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af0c:	8b 40 0c             	mov    0xc(%eax),%eax
    af0f:	8b 10                	mov    (%eax),%edx
    af11:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af14:	8b 08                	mov    (%eax),%ecx
    af16:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af19:	8b 58 04             	mov    0x4(%eax),%ebx
    af1c:	8b 45 08             	mov    0x8(%ebp),%eax
    af1f:	01 d8                	add    %ebx,%eax
    af21:	c1 e0 0c             	shl    $0xc,%eax
    af24:	01 c8                	add    %ecx,%eax
    af26:	39 c2                	cmp    %eax,%edx
    af28:	77 15                	ja     af3f <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    af2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af2d:	8b 40 0c             	mov    0xc(%eax),%eax
    af30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    af33:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af36:	8b 40 0c             	mov    0xc(%eax),%eax
    af39:	85 c0                	test   %eax,%eax
    af3b:	75 cc                	jne    af09 <alloc_page+0xfe>
    af3d:	eb 01                	jmp    af40 <alloc_page+0x135>
            break;
    af3f:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    af40:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af43:	8b 40 0c             	mov    0xc(%eax),%eax
    af46:	85 c0                	test   %eax,%eax
    af48:	75 5d                	jne    afa7 <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    af4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af4d:	8b 10                	mov    (%eax),%edx
    af4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af52:	8b 40 04             	mov    0x4(%eax),%eax
    af55:	c1 e0 0c             	shl    $0xc,%eax
    af58:	01 c2                	add    %eax,%edx
    af5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af5d:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    af5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af62:	8b 55 08             	mov    0x8(%ebp),%edx
    af65:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    af68:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af6b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    af72:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af75:	8b 55 f0             	mov    -0x10(%ebp),%edx
    af78:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    af7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    af81:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    af84:	8b 45 08             	mov    0x8(%ebp),%eax
    af87:	c1 e0 0c             	shl    $0xc,%eax
    af8a:	89 c2                	mov    %eax,%edx
    af8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af8f:	8b 00                	mov    (%eax),%eax
    af91:	83 ec 04             	sub    $0x4,%esp
    af94:	52                   	push   %edx
    af95:	6a 00                	push   $0x0
    af97:	50                   	push   %eax
    af98:	e8 d2 e3 ff ff       	call   936f <memset>
    af9d:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    afa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afa3:	8b 00                	mov    (%eax),%eax
    afa5:	eb 69                	jmp    b010 <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    afa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afaa:	8b 10                	mov    (%eax),%edx
    afac:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afaf:	8b 40 04             	mov    0x4(%eax),%eax
    afb2:	c1 e0 0c             	shl    $0xc,%eax
    afb5:	01 c2                	add    %eax,%edx
    afb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afba:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    afbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afbf:	8b 55 08             	mov    0x8(%ebp),%edx
    afc2:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    afc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afc8:	8b 50 0c             	mov    0xc(%eax),%edx
    afcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afce:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    afd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afd4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    afd7:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    afda:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afdd:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afe0:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    afe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afe6:	8b 40 0c             	mov    0xc(%eax),%eax
    afe9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afec:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    afef:	8b 45 08             	mov    0x8(%ebp),%eax
    aff2:	c1 e0 0c             	shl    $0xc,%eax
    aff5:	89 c2                	mov    %eax,%edx
    aff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    affa:	8b 00                	mov    (%eax),%eax
    affc:	83 ec 04             	sub    $0x4,%esp
    afff:	52                   	push   %edx
    b000:	6a 00                	push   $0x0
    b002:	50                   	push   %eax
    b003:	e8 67 e3 ff ff       	call   936f <memset>
    b008:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b00b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b00e:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    b010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    b013:	c9                   	leave  
    b014:	c3                   	ret    

0000b015 <free_page>:

void free_page(_address_order_track_ page)
{
    b015:	55                   	push   %ebp
    b016:	89 e5                	mov    %esp,%ebp
    b018:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    b01b:	8b 45 10             	mov    0x10(%ebp),%eax
    b01e:	85 c0                	test   %eax,%eax
    b020:	75 2d                	jne    b04f <free_page+0x3a>
    b022:	8b 45 14             	mov    0x14(%ebp),%eax
    b025:	85 c0                	test   %eax,%eax
    b027:	74 26                	je     b04f <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    b029:	b8 db f0 00 00       	mov    $0xf0db,%eax
    b02e:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    b031:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b036:	8b 40 0c             	mov    0xc(%eax),%eax
    b039:	a3 20 f1 01 00       	mov    %eax,0x1f120
        _page_area_track_->previous_ = END_LIST;
    b03e:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b043:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    b04a:	e9 13 01 00 00       	jmp    b162 <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    b04f:	8b 45 10             	mov    0x10(%ebp),%eax
    b052:	85 c0                	test   %eax,%eax
    b054:	75 67                	jne    b0bd <free_page+0xa8>
    b056:	8b 45 14             	mov    0x14(%ebp),%eax
    b059:	85 c0                	test   %eax,%eax
    b05b:	75 60                	jne    b0bd <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    b05d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    b064:	eb 49                	jmp    b0af <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    b066:	ba db f0 00 00       	mov    $0xf0db,%edx
    b06b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b06e:	c1 e0 04             	shl    $0x4,%eax
    b071:	05 40 f1 01 00       	add    $0x1f140,%eax
    b076:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    b078:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b07b:	c1 e0 04             	shl    $0x4,%eax
    b07e:	05 44 f1 01 00       	add    $0x1f144,%eax
    b083:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    b089:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b08c:	c1 e0 04             	shl    $0x4,%eax
    b08f:	05 4c f1 01 00       	add    $0x1f14c,%eax
    b094:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    b09a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b09d:	c1 e0 04             	shl    $0x4,%eax
    b0a0:	05 48 f1 01 00       	add    $0x1f148,%eax
    b0a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    b0ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b0af:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    b0b6:	76 ae                	jbe    b066 <free_page+0x51>
        }
        return;
    b0b8:	e9 a5 00 00 00       	jmp    b162 <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b0bd:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b0c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0c5:	eb 09                	jmp    b0d0 <free_page+0xbb>
            tmp = tmp->next_;
    b0c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0ca:	8b 40 0c             	mov    0xc(%eax),%eax
    b0cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0d3:	8b 10                	mov    (%eax),%edx
    b0d5:	8b 45 08             	mov    0x8(%ebp),%eax
    b0d8:	39 c2                	cmp    %eax,%edx
    b0da:	74 0a                	je     b0e6 <free_page+0xd1>
    b0dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0df:	8b 40 0c             	mov    0xc(%eax),%eax
    b0e2:	85 c0                	test   %eax,%eax
    b0e4:	75 e1                	jne    b0c7 <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    b0e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0e9:	8b 40 0c             	mov    0xc(%eax),%eax
    b0ec:	85 c0                	test   %eax,%eax
    b0ee:	75 25                	jne    b115 <free_page+0x100>
    b0f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0f3:	8b 10                	mov    (%eax),%edx
    b0f5:	8b 45 08             	mov    0x8(%ebp),%eax
    b0f8:	39 c2                	cmp    %eax,%edx
    b0fa:	75 19                	jne    b115 <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b0fc:	ba db f0 00 00       	mov    $0xf0db,%edx
    b101:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b104:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    b106:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b109:	8b 40 08             	mov    0x8(%eax),%eax
    b10c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    b113:	eb 4d                	jmp    b162 <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    b115:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b118:	8b 40 0c             	mov    0xc(%eax),%eax
    b11b:	85 c0                	test   %eax,%eax
    b11d:	74 36                	je     b155 <free_page+0x140>
    b11f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b122:	8b 10                	mov    (%eax),%edx
    b124:	8b 45 08             	mov    0x8(%ebp),%eax
    b127:	39 c2                	cmp    %eax,%edx
    b129:	75 2a                	jne    b155 <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b12b:	ba db f0 00 00       	mov    $0xf0db,%edx
    b130:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b133:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    b135:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b138:	8b 40 08             	mov    0x8(%eax),%eax
    b13b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b13e:	8b 52 0c             	mov    0xc(%edx),%edx
    b141:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    b144:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b147:	8b 40 0c             	mov    0xc(%eax),%eax
    b14a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b14d:	8b 52 08             	mov    0x8(%edx),%edx
    b150:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    b153:	eb 0d                	jmp    b162 <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    b155:	a1 24 f1 01 00       	mov    0x1f124,%eax
    b15a:	83 e8 01             	sub    $0x1,%eax
    b15d:	a3 24 f1 01 00       	mov    %eax,0x1f124
    b162:	c9                   	leave  
    b163:	c3                   	ret    

0000b164 <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    b164:	55                   	push   %ebp
    b165:	89 e5                	mov    %esp,%ebp
    b167:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    b16a:	a1 48 31 02 00       	mov    0x23148,%eax
    b16f:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    b172:	a1 48 31 02 00       	mov    0x23148,%eax
    b177:	8b 40 3c             	mov    0x3c(%eax),%eax
    b17a:	a3 48 31 02 00       	mov    %eax,0x23148

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    b17f:	a1 48 31 02 00       	mov    0x23148,%eax
    b184:	89 c2                	mov    %eax,%edx
    b186:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b189:	83 ec 08             	sub    $0x8,%esp
    b18c:	52                   	push   %edx
    b18d:	50                   	push   %eax
    b18e:	e8 cd 02 00 00       	call   b460 <switch_to_task>
    b193:	83 c4 10             	add    $0x10,%esp
}
    b196:	90                   	nop
    b197:	c9                   	leave  
    b198:	c3                   	ret    

0000b199 <init_multitasking>:

void init_multitasking()
{
    b199:	55                   	push   %ebp
    b19a:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    b19c:	c6 05 40 31 02 00 00 	movb   $0x0,0x23140
    sheduler.task_timer = DELAY_PER_TASK;
    b1a3:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    b1aa:	01 00 00 
}
    b1ad:	90                   	nop
    b1ae:	5d                   	pop    %ebp
    b1af:	c3                   	ret    

0000b1b0 <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    b1b0:	55                   	push   %ebp
    b1b1:	89 e5                	mov    %esp,%ebp
    b1b3:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    b1b6:	8b 45 08             	mov    0x8(%ebp),%eax
    b1b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    b1bf:	8b 45 08             	mov    0x8(%ebp),%eax
    b1c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    b1c9:	8b 45 08             	mov    0x8(%ebp),%eax
    b1cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    b1d3:	8b 45 08             	mov    0x8(%ebp),%eax
    b1d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    b1dd:	8b 45 08             	mov    0x8(%ebp),%eax
    b1e0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    b1e7:	8b 45 08             	mov    0x8(%ebp),%eax
    b1ea:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    b1f1:	8b 45 08             	mov    0x8(%ebp),%eax
    b1f4:	8b 55 10             	mov    0x10(%ebp),%edx
    b1f7:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    b1fa:	8b 55 0c             	mov    0xc(%ebp),%edx
    b1fd:	8b 45 08             	mov    0x8(%ebp),%eax
    b200:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    b203:	8b 45 08             	mov    0x8(%ebp),%eax
    b206:	8b 55 14             	mov    0x14(%ebp),%edx
    b209:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    b20c:	83 ec 0c             	sub    $0xc,%esp
    b20f:	68 c8 00 00 00       	push   $0xc8
    b214:	e8 c5 f8 ff ff       	call   aade <kmalloc>
    b219:	83 c4 10             	add    $0x10,%esp
    b21c:	89 c2                	mov    %eax,%edx
    b21e:	8b 45 08             	mov    0x8(%ebp),%eax
    b221:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    b224:	8b 45 08             	mov    0x8(%ebp),%eax
    b227:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b22e:	90                   	nop
    b22f:	c9                   	leave  
    b230:	c3                   	ret    
    b231:	66 90                	xchg   %ax,%ax
    b233:	66 90                	xchg   %ax,%ax
    b235:	66 90                	xchg   %ax,%ax
    b237:	66 90                	xchg   %ax,%ax
    b239:	66 90                	xchg   %ax,%ax
    b23b:	66 90                	xchg   %ax,%ax
    b23d:	66 90                	xchg   %ax,%ax
    b23f:	90                   	nop

0000b240 <__exception_handler__>:
    b240:	58                   	pop    %eax
    b241:	a3 7c b6 00 00       	mov    %eax,0xb67c
    b246:	e8 54 e4 ff ff       	call   969f <__exception__>
    b24b:	cf                   	iret   

0000b24c <__exception_no_ERRCODE_handler__>:
    b24c:	e8 54 e4 ff ff       	call   96a5 <__exception_no_ERRCODE__>
    b251:	cf                   	iret   
    b252:	66 90                	xchg   %ax,%ax
    b254:	66 90                	xchg   %ax,%ax
    b256:	66 90                	xchg   %ax,%ax
    b258:	66 90                	xchg   %ax,%ax
    b25a:	66 90                	xchg   %ax,%ax
    b25c:	66 90                	xchg   %ax,%ax
    b25e:	66 90                	xchg   %ax,%ax

0000b260 <gdtr>:
    b260:	00 00                	add    %al,(%eax)
    b262:	00 00                	add    %al,(%eax)
	...

0000b266 <load_gdt>:
    b266:	fa                   	cli    
    b267:	50                   	push   %eax
    b268:	51                   	push   %ecx
    b269:	b9 00 00 00 00       	mov    $0x0,%ecx
    b26e:	89 0d 62 b2 00 00    	mov    %ecx,0xb262
    b274:	31 c0                	xor    %eax,%eax
    b276:	b8 00 01 00 00       	mov    $0x100,%eax
    b27b:	01 c8                	add    %ecx,%eax
    b27d:	66 a3 60 b2 00 00    	mov    %ax,0xb260
    b283:	0f 01 15 60 b2 00 00 	lgdtl  0xb260
    b28a:	8b 0d 62 b2 00 00    	mov    0xb262,%ecx
    b290:	83 c1 20             	add    $0x20,%ecx
    b293:	0f 00 d9             	ltr    %cx
    b296:	59                   	pop    %ecx
    b297:	58                   	pop    %eax
    b298:	c3                   	ret    

0000b299 <idtr>:
    b299:	00 00                	add    %al,(%eax)
    b29b:	00 00                	add    %al,(%eax)
	...

0000b29f <load_idt>:
    b29f:	fa                   	cli    
    b2a0:	50                   	push   %eax
    b2a1:	51                   	push   %ecx
    b2a2:	31 c9                	xor    %ecx,%ecx
    b2a4:	b9 20 00 01 00       	mov    $0x10020,%ecx
    b2a9:	89 0d 9b b2 00 00    	mov    %ecx,0xb29b
    b2af:	31 c0                	xor    %eax,%eax
    b2b1:	b8 00 04 00 00       	mov    $0x400,%eax
    b2b6:	01 c8                	add    %ecx,%eax
    b2b8:	66 a3 99 b2 00 00    	mov    %ax,0xb299
    b2be:	0f 01 1d 99 b2 00 00 	lidtl  0xb299
    b2c5:	59                   	pop    %ecx
    b2c6:	58                   	pop    %eax
    b2c7:	c3                   	ret    
    b2c8:	66 90                	xchg   %ax,%ax
    b2ca:	66 90                	xchg   %ax,%ax
    b2cc:	66 90                	xchg   %ax,%ax
    b2ce:	66 90                	xchg   %ax,%ax

0000b2d0 <irq1>:
    b2d0:	60                   	pusha  
    b2d1:	e8 67 ea ff ff       	call   9d3d <irq1_handler>
    b2d6:	61                   	popa   
    b2d7:	cf                   	iret   

0000b2d8 <irq2>:
    b2d8:	60                   	pusha  
    b2d9:	e8 7a ea ff ff       	call   9d58 <irq2_handler>
    b2de:	61                   	popa   
    b2df:	cf                   	iret   

0000b2e0 <irq3>:
    b2e0:	60                   	pusha  
    b2e1:	e8 95 ea ff ff       	call   9d7b <irq3_handler>
    b2e6:	61                   	popa   
    b2e7:	cf                   	iret   

0000b2e8 <irq4>:
    b2e8:	60                   	pusha  
    b2e9:	e8 b0 ea ff ff       	call   9d9e <irq4_handler>
    b2ee:	61                   	popa   
    b2ef:	cf                   	iret   

0000b2f0 <irq5>:
    b2f0:	60                   	pusha  
    b2f1:	e8 cb ea ff ff       	call   9dc1 <irq5_handler>
    b2f6:	61                   	popa   
    b2f7:	cf                   	iret   

0000b2f8 <irq6>:
    b2f8:	60                   	pusha  
    b2f9:	e8 e6 ea ff ff       	call   9de4 <irq6_handler>
    b2fe:	61                   	popa   
    b2ff:	cf                   	iret   

0000b300 <irq7>:
    b300:	60                   	pusha  
    b301:	e8 01 eb ff ff       	call   9e07 <irq7_handler>
    b306:	61                   	popa   
    b307:	cf                   	iret   

0000b308 <irq8>:
    b308:	60                   	pusha  
    b309:	e8 1c eb ff ff       	call   9e2a <irq8_handler>
    b30e:	61                   	popa   
    b30f:	cf                   	iret   

0000b310 <irq9>:
    b310:	60                   	pusha  
    b311:	e8 37 eb ff ff       	call   9e4d <irq9_handler>
    b316:	61                   	popa   
    b317:	cf                   	iret   

0000b318 <irq10>:
    b318:	60                   	pusha  
    b319:	e8 52 eb ff ff       	call   9e70 <irq10_handler>
    b31e:	61                   	popa   
    b31f:	cf                   	iret   

0000b320 <irq11>:
    b320:	60                   	pusha  
    b321:	e8 6d eb ff ff       	call   9e93 <irq11_handler>
    b326:	61                   	popa   
    b327:	cf                   	iret   

0000b328 <irq12>:
    b328:	60                   	pusha  
    b329:	e8 88 eb ff ff       	call   9eb6 <irq12_handler>
    b32e:	61                   	popa   
    b32f:	cf                   	iret   

0000b330 <irq13>:
    b330:	60                   	pusha  
    b331:	e8 a3 eb ff ff       	call   9ed9 <irq13_handler>
    b336:	61                   	popa   
    b337:	cf                   	iret   

0000b338 <irq14>:
    b338:	60                   	pusha  
    b339:	e8 be eb ff ff       	call   9efc <irq14_handler>
    b33e:	61                   	popa   
    b33f:	cf                   	iret   

0000b340 <irq15>:
    b340:	60                   	pusha  
    b341:	e8 d9 eb ff ff       	call   9f1f <irq15_handler>
    b346:	61                   	popa   
    b347:	cf                   	iret   
    b348:	66 90                	xchg   %ax,%ax
    b34a:	66 90                	xchg   %ax,%ax
    b34c:	66 90                	xchg   %ax,%ax
    b34e:	66 90                	xchg   %ax,%ax

0000b350 <_FlushPagingCache_>:
    b350:	b8 00 10 01 00       	mov    $0x11000,%eax
    b355:	0f 22 d8             	mov    %eax,%cr3
    b358:	c3                   	ret    

0000b359 <_EnablingPaging_>:
    b359:	e8 f2 ff ff ff       	call   b350 <_FlushPagingCache_>
    b35e:	0f 20 c0             	mov    %cr0,%eax
    b361:	0d 01 00 00 80       	or     $0x80000001,%eax
    b366:	0f 22 c0             	mov    %eax,%cr0
    b369:	c3                   	ret    

0000b36a <PagingFault_Handler>:
    b36a:	58                   	pop    %eax
    b36b:	a3 80 b6 00 00       	mov    %eax,0xb680
    b370:	e8 02 f0 ff ff       	call   a377 <Paging_fault>
    b375:	cf                   	iret   
    b376:	66 90                	xchg   %ax,%ax
    b378:	66 90                	xchg   %ax,%ax
    b37a:	66 90                	xchg   %ax,%ax
    b37c:	66 90                	xchg   %ax,%ax
    b37e:	66 90                	xchg   %ax,%ax

0000b380 <PIT_handler>:
    b380:	9c                   	pushf  
    b381:	e8 16 00 00 00       	call   b39c <irq_PIT>
    b386:	e8 33 f2 ff ff       	call   a5be <conserv_status_byte>
    b38b:	e8 ca f2 ff ff       	call   a65a <sheduler_cpu_timer>
    b390:	90                   	nop
    b391:	90                   	nop
    b392:	90                   	nop
    b393:	90                   	nop
    b394:	90                   	nop
    b395:	90                   	nop
    b396:	90                   	nop
    b397:	90                   	nop
    b398:	90                   	nop
    b399:	90                   	nop
    b39a:	9d                   	popf   
    b39b:	cf                   	iret   

0000b39c <irq_PIT>:
    b39c:	a1 68 32 02 00       	mov    0x23268,%eax
    b3a1:	8b 1d 6c 32 02 00    	mov    0x2326c,%ebx
    b3a7:	01 05 60 32 02 00    	add    %eax,0x23260
    b3ad:	11 1d 64 32 02 00    	adc    %ebx,0x23264
    b3b3:	6a 00                	push   $0x0
    b3b5:	e8 c3 ef ff ff       	call   a37d <PIC_sendEOI>
    b3ba:	58                   	pop    %eax
    b3bb:	c3                   	ret    

0000b3bc <calculate_frequency>:
    b3bc:	60                   	pusha  
    b3bd:	8b 1d 04 20 01 00    	mov    0x12004,%ebx
    b3c3:	b8 00 00 01 00       	mov    $0x10000,%eax
    b3c8:	83 fb 12             	cmp    $0x12,%ebx
    b3cb:	76 34                	jbe    b401 <calculate_frequency.gotReloadValue>
    b3cd:	b8 01 00 00 00       	mov    $0x1,%eax
    b3d2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    b3d8:	73 27                	jae    b401 <calculate_frequency.gotReloadValue>
    b3da:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b3df:	ba 00 00 00 00       	mov    $0x0,%edx
    b3e4:	f7 f3                	div    %ebx
    b3e6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b3ec:	72 01                	jb     b3ef <calculate_frequency.l1>
    b3ee:	40                   	inc    %eax

0000b3ef <calculate_frequency.l1>:
    b3ef:	bb 03 00 00 00       	mov    $0x3,%ebx
    b3f4:	ba 00 00 00 00       	mov    $0x0,%edx
    b3f9:	f7 f3                	div    %ebx
    b3fb:	83 fa 01             	cmp    $0x1,%edx
    b3fe:	72 01                	jb     b401 <calculate_frequency.gotReloadValue>
    b400:	40                   	inc    %eax

0000b401 <calculate_frequency.gotReloadValue>:
    b401:	50                   	push   %eax
    b402:	66 a3 74 32 02 00    	mov    %ax,0x23274
    b408:	89 c3                	mov    %eax,%ebx
    b40a:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b40f:	ba 00 00 00 00       	mov    $0x0,%edx
    b414:	f7 f3                	div    %ebx
    b416:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b41c:	72 01                	jb     b41f <calculate_frequency.l3>
    b41e:	40                   	inc    %eax

0000b41f <calculate_frequency.l3>:
    b41f:	bb 03 00 00 00       	mov    $0x3,%ebx
    b424:	ba 00 00 00 00       	mov    $0x0,%edx
    b429:	f7 f3                	div    %ebx
    b42b:	83 fa 01             	cmp    $0x1,%edx
    b42e:	72 01                	jb     b431 <calculate_frequency.l4>
    b430:	40                   	inc    %eax

0000b431 <calculate_frequency.l4>:
    b431:	a3 70 32 02 00       	mov    %eax,0x23270
    b436:	5b                   	pop    %ebx
    b437:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    b43c:	f7 e3                	mul    %ebx
    b43e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    b442:	c1 ea 0a             	shr    $0xa,%edx
    b445:	89 15 6c 32 02 00    	mov    %edx,0x2326c
    b44b:	a3 68 32 02 00       	mov    %eax,0x23268
    b450:	61                   	popa   
    b451:	c3                   	ret    
    b452:	66 90                	xchg   %ax,%ax
    b454:	66 90                	xchg   %ax,%ax
    b456:	66 90                	xchg   %ax,%ax
    b458:	66 90                	xchg   %ax,%ax
    b45a:	66 90                	xchg   %ax,%ax
    b45c:	66 90                	xchg   %ax,%ax
    b45e:	66 90                	xchg   %ax,%ax

0000b460 <switch_to_task>:
    b460:	50                   	push   %eax
    b461:	8b 44 24 08          	mov    0x8(%esp),%eax
    b465:	89 58 04             	mov    %ebx,0x4(%eax)
    b468:	89 48 08             	mov    %ecx,0x8(%eax)
    b46b:	89 50 0c             	mov    %edx,0xc(%eax)
    b46e:	89 70 10             	mov    %esi,0x10(%eax)
    b471:	89 78 14             	mov    %edi,0x14(%eax)
    b474:	89 60 18             	mov    %esp,0x18(%eax)
    b477:	89 68 1c             	mov    %ebp,0x1c(%eax)
    b47a:	51                   	push   %ecx
    b47b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    b47f:	89 48 20             	mov    %ecx,0x20(%eax)
    b482:	59                   	pop    %ecx
    b483:	51                   	push   %ecx
    b484:	9c                   	pushf  
    b485:	59                   	pop    %ecx
    b486:	89 48 24             	mov    %ecx,0x24(%eax)
    b489:	59                   	pop    %ecx
    b48a:	51                   	push   %ecx
    b48b:	0f 20 d9             	mov    %cr3,%ecx
    b48e:	89 48 28             	mov    %ecx,0x28(%eax)
    b491:	59                   	pop    %ecx
    b492:	8c 40 2c             	mov    %es,0x2c(%eax)
    b495:	8c 68 2e             	mov    %gs,0x2e(%eax)
    b498:	8c 60 30             	mov    %fs,0x30(%eax)
    b49b:	51                   	push   %ecx
    b49c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    b4a0:	89 08                	mov    %ecx,(%eax)
    b4a2:	59                   	pop    %ecx
    b4a3:	58                   	pop    %eax
    b4a4:	8b 44 24 08          	mov    0x8(%esp),%eax
    b4a8:	8b 58 04             	mov    0x4(%eax),%ebx
    b4ab:	8b 48 08             	mov    0x8(%eax),%ecx
    b4ae:	8b 50 0c             	mov    0xc(%eax),%edx
    b4b1:	8b 70 10             	mov    0x10(%eax),%esi
    b4b4:	8b 78 14             	mov    0x14(%eax),%edi
    b4b7:	8b 60 18             	mov    0x18(%eax),%esp
    b4ba:	8b 68 1c             	mov    0x1c(%eax),%ebp
    b4bd:	51                   	push   %ecx
    b4be:	8b 48 24             	mov    0x24(%eax),%ecx
    b4c1:	51                   	push   %ecx
    b4c2:	9d                   	popf   
    b4c3:	59                   	pop    %ecx
    b4c4:	51                   	push   %ecx
    b4c5:	8b 48 28             	mov    0x28(%eax),%ecx
    b4c8:	0f 22 d9             	mov    %ecx,%cr3
    b4cb:	59                   	pop    %ecx
    b4cc:	8e 40 2c             	mov    0x2c(%eax),%es
    b4cf:	8e 68 2e             	mov    0x2e(%eax),%gs
    b4d2:	8e 60 30             	mov    0x30(%eax),%fs
    b4d5:	8b 40 20             	mov    0x20(%eax),%eax
    b4d8:	89 04 24             	mov    %eax,(%esp)
    b4db:	c3                   	ret    
