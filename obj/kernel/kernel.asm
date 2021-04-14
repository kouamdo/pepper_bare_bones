
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
    9007:	e8 22 07 00 00       	call   972e <init_gdt>

    init_idt();
    900c:	e8 56 08 00 00       	call   9867 <init_idt>

    init_console();
    9011:	e8 6d 06 00 00       	call   9683 <init_console>

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
    cputchar(READY_COLOR, get_ASCII_code_keyboard());
    9665:	e8 35 0b 00 00       	call   a19f <get_ASCII_code_keyboard>
    966a:	0f be c0             	movsbl %al,%eax
    966d:	83 ec 08             	sub    $0x8,%esp
    9670:	50                   	push   %eax
    9671:	6a 07                	push   $0x7
    9673:	e8 82 fe ff ff       	call   94fa <cputchar>
    9678:	83 c4 10             	add    $0x10,%esp
    show_cursor();
    967b:	e8 bf ff ff ff       	call   963f <show_cursor>
}
    9680:	90                   	nop
    9681:	c9                   	leave  
    9682:	c3                   	ret    

00009683 <init_console>:

void init_console()
{
    9683:	55                   	push   %ebp
    9684:	89 e5                	mov    %esp,%ebp
    9686:	83 ec 08             	sub    $0x8,%esp
    cclean();
    9689:	e8 64 fd ff ff       	call   93f2 <cclean>
    kbd_init(); //Init keyboard
    968e:	e8 cf 08 00 00       	call   9f62 <kbd_init>
    //init Video graphics here
    9693:	90                   	nop
    9694:	c9                   	leave  
    9695:	c3                   	ret    

00009696 <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    9696:	55                   	push   %ebp
    9697:	89 e5                	mov    %esp,%ebp
    9699:	90                   	nop
    969a:	5d                   	pop    %ebp
    969b:	c3                   	ret    

0000969c <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    969c:	55                   	push   %ebp
    969d:	89 e5                	mov    %esp,%ebp
    969f:	90                   	nop
    96a0:	5d                   	pop    %ebp
    96a1:	c3                   	ret    

000096a2 <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    96a2:	55                   	push   %ebp
    96a3:	89 e5                	mov    %esp,%ebp
    96a5:	83 ec 08             	sub    $0x8,%esp
    96a8:	8b 55 10             	mov    0x10(%ebp),%edx
    96ab:	8b 45 14             	mov    0x14(%ebp),%eax
    96ae:	88 55 fc             	mov    %dl,-0x4(%ebp)
    96b1:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15 = (limite & 0xFFFF);
    96b4:	8b 45 0c             	mov    0xc(%ebp),%eax
    96b7:	89 c2                	mov    %eax,%edx
    96b9:	8b 45 18             	mov    0x18(%ebp),%eax
    96bc:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    96bf:	8b 45 0c             	mov    0xc(%ebp),%eax
    96c2:	c1 e8 10             	shr    $0x10,%eax
    96c5:	83 e0 0f             	and    $0xf,%eax
    96c8:	8b 55 18             	mov    0x18(%ebp),%edx
    96cb:	83 e0 0f             	and    $0xf,%eax
    96ce:	89 c1                	mov    %eax,%ecx
    96d0:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    96d4:	83 e0 f0             	and    $0xfffffff0,%eax
    96d7:	09 c8                	or     %ecx,%eax
    96d9:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15 = (base & 0xFFFF);
    96dc:	8b 45 08             	mov    0x8(%ebp),%eax
    96df:	89 c2                	mov    %eax,%edx
    96e1:	8b 45 18             	mov    0x18(%ebp),%eax
    96e4:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    96e8:	8b 45 08             	mov    0x8(%ebp),%eax
    96eb:	c1 e8 10             	shr    $0x10,%eax
    96ee:	89 c2                	mov    %eax,%edx
    96f0:	8b 45 18             	mov    0x18(%ebp),%eax
    96f3:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    96f6:	8b 45 08             	mov    0x8(%ebp),%eax
    96f9:	c1 e8 18             	shr    $0x18,%eax
    96fc:	89 c2                	mov    %eax,%edx
    96fe:	8b 45 18             	mov    0x18(%ebp),%eax
    9701:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags = flags;
    9704:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    9708:	83 e0 0f             	and    $0xf,%eax
    970b:	89 c2                	mov    %eax,%edx
    970d:	8b 45 18             	mov    0x18(%ebp),%eax
    9710:	89 d1                	mov    %edx,%ecx
    9712:	c1 e1 04             	shl    $0x4,%ecx
    9715:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    9719:	83 e2 0f             	and    $0xf,%edx
    971c:	09 ca                	or     %ecx,%edx
    971e:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    9721:	8b 45 18             	mov    0x18(%ebp),%eax
    9724:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    9728:	88 50 05             	mov    %dl,0x5(%eax)
}
    972b:	90                   	nop
    972c:	c9                   	leave  
    972d:	c3                   	ret    

0000972e <init_gdt>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt(void)
{
    972e:	55                   	push   %ebp
    972f:	89 e5                	mov    %esp,%ebp
    9731:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    9734:	a1 08 00 01 00       	mov    0x10008,%eax
    9739:	50                   	push   %eax
    973a:	6a 00                	push   $0x0
    973c:	6a 00                	push   $0x0
    973e:	6a 00                	push   $0x0
    9740:	6a 00                	push   $0x0
    9742:	e8 5b ff ff ff       	call   96a2 <init_gdt_entry>
    9747:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    974a:	a1 08 00 01 00       	mov    0x10008,%eax
    974f:	83 c0 08             	add    $0x8,%eax
    9752:	50                   	push   %eax
    9753:	6a 04                	push   $0x4
    9755:	68 9a 00 00 00       	push   $0x9a
    975a:	68 ff ff 0f 00       	push   $0xfffff
    975f:	6a 00                	push   $0x0
    9761:	e8 3c ff ff ff       	call   96a2 <init_gdt_entry>
    9766:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    9769:	a1 08 00 01 00       	mov    0x10008,%eax
    976e:	83 c0 10             	add    $0x10,%eax
    9771:	50                   	push   %eax
    9772:	6a 04                	push   $0x4
    9774:	68 92 00 00 00       	push   $0x92
    9779:	68 ff ff 0f 00       	push   $0xfffff
    977e:	6a 00                	push   $0x0
    9780:	e8 1d ff ff ff       	call   96a2 <init_gdt_entry>
    9785:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    9788:	a1 08 00 01 00       	mov    0x10008,%eax
    978d:	83 c0 18             	add    $0x18,%eax
    9790:	50                   	push   %eax
    9791:	6a 04                	push   $0x4
    9793:	68 96 00 00 00       	push   $0x96
    9798:	68 ff ff 0f 00       	push   $0xfffff
    979d:	6a 00                	push   $0x0
    979f:	e8 fe fe ff ff       	call   96a2 <init_gdt_entry>
    97a4:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Segment de tâches
    init_gdt_entry(0, 0xFFFFFF, TSS_PRIVILEGE_0,
    97a7:	a1 08 00 01 00       	mov    0x10008,%eax
    97ac:	83 c0 20             	add    $0x20,%eax
    97af:	50                   	push   %eax
    97b0:	6a 04                	push   $0x4
    97b2:	68 89 00 00 00       	push   $0x89
    97b7:	68 ff ff ff 00       	push   $0xffffff
    97bc:	6a 00                	push   $0x0
    97be:	e8 df fe ff ff       	call   96a2 <init_gdt_entry>
    97c3:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[4]);

    // Chargement de la GDT
    load_gdt();
    97c6:	e8 9b 1a 00 00       	call   b266 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    97cb:	66 b8 10 00          	mov    $0x10,%ax
    97cf:	8e d8                	mov    %eax,%ds
    97d1:	8e c0                	mov    %eax,%es
    97d3:	8e e0                	mov    %eax,%fs
    97d5:	8e e8                	mov    %eax,%gs
    97d7:	66 b8 18 00          	mov    $0x18,%ax
    97db:	8e d0                	mov    %eax,%ss
    97dd:	ea e4 97 00 00 08 00 	ljmp   $0x8,$0x97e4

000097e4 <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    97e4:	90                   	nop
    97e5:	c9                   	leave  
    97e6:	c3                   	ret    

000097e7 <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    97e7:	55                   	push   %ebp
    97e8:	89 e5                	mov    %esp,%ebp
    97ea:	83 ec 18             	sub    $0x18,%esp
    97ed:	8b 45 08             	mov    0x8(%ebp),%eax
    97f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    97f3:	8b 55 18             	mov    0x18(%ebp),%edx
    97f6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    97fa:	89 c8                	mov    %ecx,%eax
    97fc:	88 45 f8             	mov    %al,-0x8(%ebp)
    97ff:	8b 45 10             	mov    0x10(%ebp),%eax
    9802:	89 45 f0             	mov    %eax,-0x10(%ebp)
    9805:	8b 45 14             	mov    0x14(%ebp),%eax
    9808:	89 45 f4             	mov    %eax,-0xc(%ebp)
    980b:	89 d0                	mov    %edx,%eax
    980d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    9811:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9815:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    9819:	66 89 14 c5 22 00 01 	mov    %dx,0x10022(,%eax,8)
    9820:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    9821:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9825:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    9829:	88 14 c5 25 00 01 00 	mov    %dl,0x10025(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    9830:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9834:	c6 04 c5 24 00 01 00 	movb   $0x0,0x10024(,%eax,8)
    983b:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    983c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9840:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9843:	66 89 14 c5 20 00 01 	mov    %dx,0x10020(,%eax,8)
    984a:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    984b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    984e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9851:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    9855:	c1 ea 10             	shr    $0x10,%edx
    9858:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    985c:	66 89 04 cd 26 00 01 	mov    %ax,0x10026(,%ecx,8)
    9863:	00 
}
    9864:	90                   	nop
    9865:	c9                   	leave  
    9866:	c3                   	ret    

00009867 <init_idt>:

void init_idt()
{
    9867:	55                   	push   %ebp
    9868:	89 e5                	mov    %esp,%ebp
    986a:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    986d:	83 ec 0c             	sub    $0xc,%esp
    9870:	68 ad da 00 00       	push   $0xdaad
    9875:	e8 32 0e 00 00       	call   a6ac <Init_PIT>
    987a:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    987d:	83 ec 08             	sub    $0x8,%esp
    9880:	6a 28                	push   $0x28
    9882:	6a 20                	push   $0x20
    9884:	e8 36 0b 00 00       	call   a3bf <PIC_remap>
    9889:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    988c:	b8 80 b3 00 00       	mov    $0xb380,%eax
    9891:	ba 00 00 00 00       	mov    $0x0,%edx
    9896:	83 ec 0c             	sub    $0xc,%esp
    9899:	6a 20                	push   $0x20
    989b:	52                   	push   %edx
    989c:	50                   	push   %eax
    989d:	68 8e 00 00 00       	push   $0x8e
    98a2:	6a 08                	push   $0x8
    98a4:	e8 3e ff ff ff       	call   97e7 <set_idt>
    98a9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    98ac:	b8 d0 b2 00 00       	mov    $0xb2d0,%eax
    98b1:	ba 00 00 00 00       	mov    $0x0,%edx
    98b6:	83 ec 0c             	sub    $0xc,%esp
    98b9:	6a 21                	push   $0x21
    98bb:	52                   	push   %edx
    98bc:	50                   	push   %eax
    98bd:	68 8e 00 00 00       	push   $0x8e
    98c2:	6a 08                	push   $0x8
    98c4:	e8 1e ff ff ff       	call   97e7 <set_idt>
    98c9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    98cc:	b8 d8 b2 00 00       	mov    $0xb2d8,%eax
    98d1:	ba 00 00 00 00       	mov    $0x0,%edx
    98d6:	83 ec 0c             	sub    $0xc,%esp
    98d9:	6a 22                	push   $0x22
    98db:	52                   	push   %edx
    98dc:	50                   	push   %eax
    98dd:	68 8e 00 00 00       	push   $0x8e
    98e2:	6a 08                	push   $0x8
    98e4:	e8 fe fe ff ff       	call   97e7 <set_idt>
    98e9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    98ec:	b8 e0 b2 00 00       	mov    $0xb2e0,%eax
    98f1:	ba 00 00 00 00       	mov    $0x0,%edx
    98f6:	83 ec 0c             	sub    $0xc,%esp
    98f9:	6a 23                	push   $0x23
    98fb:	52                   	push   %edx
    98fc:	50                   	push   %eax
    98fd:	68 8e 00 00 00       	push   $0x8e
    9902:	6a 08                	push   $0x8
    9904:	e8 de fe ff ff       	call   97e7 <set_idt>
    9909:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    990c:	b8 e8 b2 00 00       	mov    $0xb2e8,%eax
    9911:	ba 00 00 00 00       	mov    $0x0,%edx
    9916:	83 ec 0c             	sub    $0xc,%esp
    9919:	6a 24                	push   $0x24
    991b:	52                   	push   %edx
    991c:	50                   	push   %eax
    991d:	68 8e 00 00 00       	push   $0x8e
    9922:	6a 08                	push   $0x8
    9924:	e8 be fe ff ff       	call   97e7 <set_idt>
    9929:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    992c:	b8 f0 b2 00 00       	mov    $0xb2f0,%eax
    9931:	ba 00 00 00 00       	mov    $0x0,%edx
    9936:	83 ec 0c             	sub    $0xc,%esp
    9939:	6a 25                	push   $0x25
    993b:	52                   	push   %edx
    993c:	50                   	push   %eax
    993d:	68 8e 00 00 00       	push   $0x8e
    9942:	6a 08                	push   $0x8
    9944:	e8 9e fe ff ff       	call   97e7 <set_idt>
    9949:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    994c:	b8 f8 b2 00 00       	mov    $0xb2f8,%eax
    9951:	ba 00 00 00 00       	mov    $0x0,%edx
    9956:	83 ec 0c             	sub    $0xc,%esp
    9959:	6a 26                	push   $0x26
    995b:	52                   	push   %edx
    995c:	50                   	push   %eax
    995d:	68 8e 00 00 00       	push   $0x8e
    9962:	6a 08                	push   $0x8
    9964:	e8 7e fe ff ff       	call   97e7 <set_idt>
    9969:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    996c:	b8 00 b3 00 00       	mov    $0xb300,%eax
    9971:	ba 00 00 00 00       	mov    $0x0,%edx
    9976:	83 ec 0c             	sub    $0xc,%esp
    9979:	6a 27                	push   $0x27
    997b:	52                   	push   %edx
    997c:	50                   	push   %eax
    997d:	68 8e 00 00 00       	push   $0x8e
    9982:	6a 08                	push   $0x8
    9984:	e8 5e fe ff ff       	call   97e7 <set_idt>
    9989:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    998c:	b8 08 b3 00 00       	mov    $0xb308,%eax
    9991:	ba 00 00 00 00       	mov    $0x0,%edx
    9996:	83 ec 0c             	sub    $0xc,%esp
    9999:	6a 28                	push   $0x28
    999b:	52                   	push   %edx
    999c:	50                   	push   %eax
    999d:	68 8e 00 00 00       	push   $0x8e
    99a2:	6a 08                	push   $0x8
    99a4:	e8 3e fe ff ff       	call   97e7 <set_idt>
    99a9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    99ac:	b8 10 b3 00 00       	mov    $0xb310,%eax
    99b1:	ba 00 00 00 00       	mov    $0x0,%edx
    99b6:	83 ec 0c             	sub    $0xc,%esp
    99b9:	6a 29                	push   $0x29
    99bb:	52                   	push   %edx
    99bc:	50                   	push   %eax
    99bd:	68 8e 00 00 00       	push   $0x8e
    99c2:	6a 08                	push   $0x8
    99c4:	e8 1e fe ff ff       	call   97e7 <set_idt>
    99c9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    99cc:	b8 18 b3 00 00       	mov    $0xb318,%eax
    99d1:	ba 00 00 00 00       	mov    $0x0,%edx
    99d6:	83 ec 0c             	sub    $0xc,%esp
    99d9:	6a 2a                	push   $0x2a
    99db:	52                   	push   %edx
    99dc:	50                   	push   %eax
    99dd:	68 8e 00 00 00       	push   $0x8e
    99e2:	6a 08                	push   $0x8
    99e4:	e8 fe fd ff ff       	call   97e7 <set_idt>
    99e9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    99ec:	b8 20 b3 00 00       	mov    $0xb320,%eax
    99f1:	ba 00 00 00 00       	mov    $0x0,%edx
    99f6:	83 ec 0c             	sub    $0xc,%esp
    99f9:	6a 2b                	push   $0x2b
    99fb:	52                   	push   %edx
    99fc:	50                   	push   %eax
    99fd:	68 8e 00 00 00       	push   $0x8e
    9a02:	6a 08                	push   $0x8
    9a04:	e8 de fd ff ff       	call   97e7 <set_idt>
    9a09:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    9a0c:	b8 28 b3 00 00       	mov    $0xb328,%eax
    9a11:	ba 00 00 00 00       	mov    $0x0,%edx
    9a16:	83 ec 0c             	sub    $0xc,%esp
    9a19:	6a 2c                	push   $0x2c
    9a1b:	52                   	push   %edx
    9a1c:	50                   	push   %eax
    9a1d:	68 8e 00 00 00       	push   $0x8e
    9a22:	6a 08                	push   $0x8
    9a24:	e8 be fd ff ff       	call   97e7 <set_idt>
    9a29:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    9a2c:	b8 30 b3 00 00       	mov    $0xb330,%eax
    9a31:	ba 00 00 00 00       	mov    $0x0,%edx
    9a36:	83 ec 0c             	sub    $0xc,%esp
    9a39:	6a 2d                	push   $0x2d
    9a3b:	52                   	push   %edx
    9a3c:	50                   	push   %eax
    9a3d:	68 8e 00 00 00       	push   $0x8e
    9a42:	6a 08                	push   $0x8
    9a44:	e8 9e fd ff ff       	call   97e7 <set_idt>
    9a49:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    9a4c:	b8 38 b3 00 00       	mov    $0xb338,%eax
    9a51:	ba 00 00 00 00       	mov    $0x0,%edx
    9a56:	83 ec 0c             	sub    $0xc,%esp
    9a59:	6a 2e                	push   $0x2e
    9a5b:	52                   	push   %edx
    9a5c:	50                   	push   %eax
    9a5d:	68 8e 00 00 00       	push   $0x8e
    9a62:	6a 08                	push   $0x8
    9a64:	e8 7e fd ff ff       	call   97e7 <set_idt>
    9a69:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    9a6c:	b8 40 b3 00 00       	mov    $0xb340,%eax
    9a71:	ba 00 00 00 00       	mov    $0x0,%edx
    9a76:	83 ec 0c             	sub    $0xc,%esp
    9a79:	6a 2f                	push   $0x2f
    9a7b:	52                   	push   %edx
    9a7c:	50                   	push   %eax
    9a7d:	68 8e 00 00 00       	push   $0x8e
    9a82:	6a 08                	push   $0x8
    9a84:	e8 5e fd ff ff       	call   97e7 <set_idt>
    9a89:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    9a8c:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9a91:	ba 00 00 00 00       	mov    $0x0,%edx
    9a96:	83 ec 0c             	sub    $0xc,%esp
    9a99:	6a 08                	push   $0x8
    9a9b:	52                   	push   %edx
    9a9c:	50                   	push   %eax
    9a9d:	68 8e 00 00 00       	push   $0x8e
    9aa2:	6a 08                	push   $0x8
    9aa4:	e8 3e fd ff ff       	call   97e7 <set_idt>
    9aa9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    9aac:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9ab1:	ba 00 00 00 00       	mov    $0x0,%edx
    9ab6:	83 ec 0c             	sub    $0xc,%esp
    9ab9:	6a 0a                	push   $0xa
    9abb:	52                   	push   %edx
    9abc:	50                   	push   %eax
    9abd:	68 8e 00 00 00       	push   $0x8e
    9ac2:	6a 08                	push   $0x8
    9ac4:	e8 1e fd ff ff       	call   97e7 <set_idt>
    9ac9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    9acc:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9ad1:	ba 00 00 00 00       	mov    $0x0,%edx
    9ad6:	83 ec 0c             	sub    $0xc,%esp
    9ad9:	6a 0b                	push   $0xb
    9adb:	52                   	push   %edx
    9adc:	50                   	push   %eax
    9add:	68 8e 00 00 00       	push   $0x8e
    9ae2:	6a 08                	push   $0x8
    9ae4:	e8 fe fc ff ff       	call   97e7 <set_idt>
    9ae9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9aec:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9af1:	ba 00 00 00 00       	mov    $0x0,%edx
    9af6:	83 ec 0c             	sub    $0xc,%esp
    9af9:	6a 0c                	push   $0xc
    9afb:	52                   	push   %edx
    9afc:	50                   	push   %eax
    9afd:	68 8e 00 00 00       	push   $0x8e
    9b02:	6a 08                	push   $0x8
    9b04:	e8 de fc ff ff       	call   97e7 <set_idt>
    9b09:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9b0c:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9b11:	ba 00 00 00 00       	mov    $0x0,%edx
    9b16:	83 ec 0c             	sub    $0xc,%esp
    9b19:	6a 0d                	push   $0xd
    9b1b:	52                   	push   %edx
    9b1c:	50                   	push   %eax
    9b1d:	68 8e 00 00 00       	push   $0x8e
    9b22:	6a 08                	push   $0x8
    9b24:	e8 be fc ff ff       	call   97e7 <set_idt>
    9b29:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    9b2c:	b8 8e a3 00 00       	mov    $0xa38e,%eax
    9b31:	ba 00 00 00 00       	mov    $0x0,%edx
    9b36:	83 ec 0c             	sub    $0xc,%esp
    9b39:	6a 0e                	push   $0xe
    9b3b:	52                   	push   %edx
    9b3c:	50                   	push   %eax
    9b3d:	68 8e 00 00 00       	push   $0x8e
    9b42:	6a 08                	push   $0x8
    9b44:	e8 9e fc ff ff       	call   97e7 <set_idt>
    9b49:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    9b4c:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9b51:	ba 00 00 00 00       	mov    $0x0,%edx
    9b56:	83 ec 0c             	sub    $0xc,%esp
    9b59:	6a 11                	push   $0x11
    9b5b:	52                   	push   %edx
    9b5c:	50                   	push   %eax
    9b5d:	68 8e 00 00 00       	push   $0x8e
    9b62:	6a 08                	push   $0x8
    9b64:	e8 7e fc ff ff       	call   97e7 <set_idt>
    9b69:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    9b6c:	b8 40 b2 00 00       	mov    $0xb240,%eax
    9b71:	ba 00 00 00 00       	mov    $0x0,%edx
    9b76:	83 ec 0c             	sub    $0xc,%esp
    9b79:	6a 1e                	push   $0x1e
    9b7b:	52                   	push   %edx
    9b7c:	50                   	push   %eax
    9b7d:	68 8e 00 00 00       	push   $0x8e
    9b82:	6a 08                	push   $0x8
    9b84:	e8 5e fc ff ff       	call   97e7 <set_idt>
    9b89:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9b8c:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9b91:	ba 00 00 00 00       	mov    $0x0,%edx
    9b96:	83 ec 0c             	sub    $0xc,%esp
    9b99:	6a 00                	push   $0x0
    9b9b:	52                   	push   %edx
    9b9c:	50                   	push   %eax
    9b9d:	68 8e 00 00 00       	push   $0x8e
    9ba2:	6a 08                	push   $0x8
    9ba4:	e8 3e fc ff ff       	call   97e7 <set_idt>
    9ba9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9bac:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9bb1:	ba 00 00 00 00       	mov    $0x0,%edx
    9bb6:	83 ec 0c             	sub    $0xc,%esp
    9bb9:	6a 01                	push   $0x1
    9bbb:	52                   	push   %edx
    9bbc:	50                   	push   %eax
    9bbd:	68 8e 00 00 00       	push   $0x8e
    9bc2:	6a 08                	push   $0x8
    9bc4:	e8 1e fc ff ff       	call   97e7 <set_idt>
    9bc9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9bcc:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9bd1:	ba 00 00 00 00       	mov    $0x0,%edx
    9bd6:	83 ec 0c             	sub    $0xc,%esp
    9bd9:	6a 02                	push   $0x2
    9bdb:	52                   	push   %edx
    9bdc:	50                   	push   %eax
    9bdd:	68 8e 00 00 00       	push   $0x8e
    9be2:	6a 08                	push   $0x8
    9be4:	e8 fe fb ff ff       	call   97e7 <set_idt>
    9be9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9bec:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9bf1:	ba 00 00 00 00       	mov    $0x0,%edx
    9bf6:	83 ec 0c             	sub    $0xc,%esp
    9bf9:	6a 03                	push   $0x3
    9bfb:	52                   	push   %edx
    9bfc:	50                   	push   %eax
    9bfd:	68 8e 00 00 00       	push   $0x8e
    9c02:	6a 08                	push   $0x8
    9c04:	e8 de fb ff ff       	call   97e7 <set_idt>
    9c09:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9c0c:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9c11:	ba 00 00 00 00       	mov    $0x0,%edx
    9c16:	83 ec 0c             	sub    $0xc,%esp
    9c19:	6a 04                	push   $0x4
    9c1b:	52                   	push   %edx
    9c1c:	50                   	push   %eax
    9c1d:	68 8e 00 00 00       	push   $0x8e
    9c22:	6a 08                	push   $0x8
    9c24:	e8 be fb ff ff       	call   97e7 <set_idt>
    9c29:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    9c2c:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9c31:	ba 00 00 00 00       	mov    $0x0,%edx
    9c36:	83 ec 0c             	sub    $0xc,%esp
    9c39:	6a 05                	push   $0x5
    9c3b:	52                   	push   %edx
    9c3c:	50                   	push   %eax
    9c3d:	68 8e 00 00 00       	push   $0x8e
    9c42:	6a 08                	push   $0x8
    9c44:	e8 9e fb ff ff       	call   97e7 <set_idt>
    9c49:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    9c4c:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9c51:	ba 00 00 00 00       	mov    $0x0,%edx
    9c56:	83 ec 0c             	sub    $0xc,%esp
    9c59:	6a 06                	push   $0x6
    9c5b:	52                   	push   %edx
    9c5c:	50                   	push   %eax
    9c5d:	68 8e 00 00 00       	push   $0x8e
    9c62:	6a 08                	push   $0x8
    9c64:	e8 7e fb ff ff       	call   97e7 <set_idt>
    9c69:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    9c6c:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9c71:	ba 00 00 00 00       	mov    $0x0,%edx
    9c76:	83 ec 0c             	sub    $0xc,%esp
    9c79:	6a 07                	push   $0x7
    9c7b:	52                   	push   %edx
    9c7c:	50                   	push   %eax
    9c7d:	68 8e 00 00 00       	push   $0x8e
    9c82:	6a 08                	push   $0x8
    9c84:	e8 5e fb ff ff       	call   97e7 <set_idt>
    9c89:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9c8c:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9c91:	ba 00 00 00 00       	mov    $0x0,%edx
    9c96:	83 ec 0c             	sub    $0xc,%esp
    9c99:	6a 09                	push   $0x9
    9c9b:	52                   	push   %edx
    9c9c:	50                   	push   %eax
    9c9d:	68 8e 00 00 00       	push   $0x8e
    9ca2:	6a 08                	push   $0x8
    9ca4:	e8 3e fb ff ff       	call   97e7 <set_idt>
    9ca9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9cac:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9cb1:	ba 00 00 00 00       	mov    $0x0,%edx
    9cb6:	83 ec 0c             	sub    $0xc,%esp
    9cb9:	6a 10                	push   $0x10
    9cbb:	52                   	push   %edx
    9cbc:	50                   	push   %eax
    9cbd:	68 8e 00 00 00       	push   $0x8e
    9cc2:	6a 08                	push   $0x8
    9cc4:	e8 1e fb ff ff       	call   97e7 <set_idt>
    9cc9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9ccc:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9cd1:	ba 00 00 00 00       	mov    $0x0,%edx
    9cd6:	83 ec 0c             	sub    $0xc,%esp
    9cd9:	6a 12                	push   $0x12
    9cdb:	52                   	push   %edx
    9cdc:	50                   	push   %eax
    9cdd:	68 8e 00 00 00       	push   $0x8e
    9ce2:	6a 08                	push   $0x8
    9ce4:	e8 fe fa ff ff       	call   97e7 <set_idt>
    9ce9:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9cec:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9cf1:	ba 00 00 00 00       	mov    $0x0,%edx
    9cf6:	83 ec 0c             	sub    $0xc,%esp
    9cf9:	6a 13                	push   $0x13
    9cfb:	52                   	push   %edx
    9cfc:	50                   	push   %eax
    9cfd:	68 8e 00 00 00       	push   $0x8e
    9d02:	6a 08                	push   $0x8
    9d04:	e8 de fa ff ff       	call   97e7 <set_idt>
    9d09:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9d0c:	b8 9c 96 00 00       	mov    $0x969c,%eax
    9d11:	ba 00 00 00 00       	mov    $0x0,%edx
    9d16:	83 ec 0c             	sub    $0xc,%esp
    9d19:	6a 14                	push   $0x14
    9d1b:	52                   	push   %edx
    9d1c:	50                   	push   %eax
    9d1d:	68 8e 00 00 00       	push   $0x8e
    9d22:	6a 08                	push   $0x8
    9d24:	e8 be fa ff ff       	call   97e7 <set_idt>
    9d29:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    9d2c:	e8 6e 15 00 00       	call   b29f <load_idt>
}
    9d31:	90                   	nop
    9d32:	c9                   	leave  
    9d33:	c3                   	ret    

00009d34 <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    9d34:	55                   	push   %ebp
    9d35:	89 e5                	mov    %esp,%ebp
    9d37:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    9d3a:	e8 4a 02 00 00       	call   9f89 <keyboard_irq>
    PIC_sendEOI(1);
    9d3f:	83 ec 0c             	sub    $0xc,%esp
    9d42:	6a 01                	push   $0x1
    9d44:	e8 4b 06 00 00       	call   a394 <PIC_sendEOI>
    9d49:	83 c4 10             	add    $0x10,%esp
}
    9d4c:	90                   	nop
    9d4d:	c9                   	leave  
    9d4e:	c3                   	ret    

00009d4f <irq2_handler>:

void irq2_handler(void)
{
    9d4f:	55                   	push   %ebp
    9d50:	89 e5                	mov    %esp,%ebp
    9d52:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    9d55:	83 ec 0c             	sub    $0xc,%esp
    9d58:	6a 02                	push   $0x2
    9d5a:	e8 41 08 00 00       	call   a5a0 <spurious_IRQ>
    9d5f:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9d62:	83 ec 0c             	sub    $0xc,%esp
    9d65:	6a 02                	push   $0x2
    9d67:	e8 28 06 00 00       	call   a394 <PIC_sendEOI>
    9d6c:	83 c4 10             	add    $0x10,%esp
}
    9d6f:	90                   	nop
    9d70:	c9                   	leave  
    9d71:	c3                   	ret    

00009d72 <irq3_handler>:

void irq3_handler(void)
{
    9d72:	55                   	push   %ebp
    9d73:	89 e5                	mov    %esp,%ebp
    9d75:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    9d78:	83 ec 0c             	sub    $0xc,%esp
    9d7b:	6a 03                	push   $0x3
    9d7d:	e8 1e 08 00 00       	call   a5a0 <spurious_IRQ>
    9d82:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9d85:	83 ec 0c             	sub    $0xc,%esp
    9d88:	6a 03                	push   $0x3
    9d8a:	e8 05 06 00 00       	call   a394 <PIC_sendEOI>
    9d8f:	83 c4 10             	add    $0x10,%esp
}
    9d92:	90                   	nop
    9d93:	c9                   	leave  
    9d94:	c3                   	ret    

00009d95 <irq4_handler>:

void irq4_handler(void)
{
    9d95:	55                   	push   %ebp
    9d96:	89 e5                	mov    %esp,%ebp
    9d98:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    9d9b:	83 ec 0c             	sub    $0xc,%esp
    9d9e:	6a 04                	push   $0x4
    9da0:	e8 fb 07 00 00       	call   a5a0 <spurious_IRQ>
    9da5:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9da8:	83 ec 0c             	sub    $0xc,%esp
    9dab:	6a 04                	push   $0x4
    9dad:	e8 e2 05 00 00       	call   a394 <PIC_sendEOI>
    9db2:	83 c4 10             	add    $0x10,%esp
}
    9db5:	90                   	nop
    9db6:	c9                   	leave  
    9db7:	c3                   	ret    

00009db8 <irq5_handler>:

void irq5_handler(void)
{
    9db8:	55                   	push   %ebp
    9db9:	89 e5                	mov    %esp,%ebp
    9dbb:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9dbe:	83 ec 0c             	sub    $0xc,%esp
    9dc1:	6a 05                	push   $0x5
    9dc3:	e8 d8 07 00 00       	call   a5a0 <spurious_IRQ>
    9dc8:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9dcb:	83 ec 0c             	sub    $0xc,%esp
    9dce:	6a 05                	push   $0x5
    9dd0:	e8 bf 05 00 00       	call   a394 <PIC_sendEOI>
    9dd5:	83 c4 10             	add    $0x10,%esp
}
    9dd8:	90                   	nop
    9dd9:	c9                   	leave  
    9dda:	c3                   	ret    

00009ddb <irq6_handler>:

void irq6_handler(void)
{
    9ddb:	55                   	push   %ebp
    9ddc:	89 e5                	mov    %esp,%ebp
    9dde:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9de1:	83 ec 0c             	sub    $0xc,%esp
    9de4:	6a 06                	push   $0x6
    9de6:	e8 b5 07 00 00       	call   a5a0 <spurious_IRQ>
    9deb:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9dee:	83 ec 0c             	sub    $0xc,%esp
    9df1:	6a 06                	push   $0x6
    9df3:	e8 9c 05 00 00       	call   a394 <PIC_sendEOI>
    9df8:	83 c4 10             	add    $0x10,%esp
}
    9dfb:	90                   	nop
    9dfc:	c9                   	leave  
    9dfd:	c3                   	ret    

00009dfe <irq7_handler>:

void irq7_handler(void)
{
    9dfe:	55                   	push   %ebp
    9dff:	89 e5                	mov    %esp,%ebp
    9e01:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9e04:	83 ec 0c             	sub    $0xc,%esp
    9e07:	6a 07                	push   $0x7
    9e09:	e8 92 07 00 00       	call   a5a0 <spurious_IRQ>
    9e0e:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9e11:	83 ec 0c             	sub    $0xc,%esp
    9e14:	6a 07                	push   $0x7
    9e16:	e8 79 05 00 00       	call   a394 <PIC_sendEOI>
    9e1b:	83 c4 10             	add    $0x10,%esp
}
    9e1e:	90                   	nop
    9e1f:	c9                   	leave  
    9e20:	c3                   	ret    

00009e21 <irq8_handler>:

void irq8_handler(void)
{
    9e21:	55                   	push   %ebp
    9e22:	89 e5                	mov    %esp,%ebp
    9e24:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    9e27:	83 ec 0c             	sub    $0xc,%esp
    9e2a:	6a 08                	push   $0x8
    9e2c:	e8 6f 07 00 00       	call   a5a0 <spurious_IRQ>
    9e31:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9e34:	83 ec 0c             	sub    $0xc,%esp
    9e37:	6a 08                	push   $0x8
    9e39:	e8 56 05 00 00       	call   a394 <PIC_sendEOI>
    9e3e:	83 c4 10             	add    $0x10,%esp
}
    9e41:	90                   	nop
    9e42:	c9                   	leave  
    9e43:	c3                   	ret    

00009e44 <irq9_handler>:

void irq9_handler(void)
{
    9e44:	55                   	push   %ebp
    9e45:	89 e5                	mov    %esp,%ebp
    9e47:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    9e4a:	83 ec 0c             	sub    $0xc,%esp
    9e4d:	6a 09                	push   $0x9
    9e4f:	e8 4c 07 00 00       	call   a5a0 <spurious_IRQ>
    9e54:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9e57:	83 ec 0c             	sub    $0xc,%esp
    9e5a:	6a 09                	push   $0x9
    9e5c:	e8 33 05 00 00       	call   a394 <PIC_sendEOI>
    9e61:	83 c4 10             	add    $0x10,%esp
}
    9e64:	90                   	nop
    9e65:	c9                   	leave  
    9e66:	c3                   	ret    

00009e67 <irq10_handler>:

void irq10_handler(void)
{
    9e67:	55                   	push   %ebp
    9e68:	89 e5                	mov    %esp,%ebp
    9e6a:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    9e6d:	83 ec 0c             	sub    $0xc,%esp
    9e70:	6a 0a                	push   $0xa
    9e72:	e8 29 07 00 00       	call   a5a0 <spurious_IRQ>
    9e77:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9e7a:	83 ec 0c             	sub    $0xc,%esp
    9e7d:	6a 0a                	push   $0xa
    9e7f:	e8 10 05 00 00       	call   a394 <PIC_sendEOI>
    9e84:	83 c4 10             	add    $0x10,%esp
}
    9e87:	90                   	nop
    9e88:	c9                   	leave  
    9e89:	c3                   	ret    

00009e8a <irq11_handler>:

void irq11_handler(void)
{
    9e8a:	55                   	push   %ebp
    9e8b:	89 e5                	mov    %esp,%ebp
    9e8d:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9e90:	83 ec 0c             	sub    $0xc,%esp
    9e93:	6a 0b                	push   $0xb
    9e95:	e8 06 07 00 00       	call   a5a0 <spurious_IRQ>
    9e9a:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9e9d:	83 ec 0c             	sub    $0xc,%esp
    9ea0:	6a 0b                	push   $0xb
    9ea2:	e8 ed 04 00 00       	call   a394 <PIC_sendEOI>
    9ea7:	83 c4 10             	add    $0x10,%esp
}
    9eaa:	90                   	nop
    9eab:	c9                   	leave  
    9eac:	c3                   	ret    

00009ead <irq12_handler>:

void irq12_handler(void)
{
    9ead:	55                   	push   %ebp
    9eae:	89 e5                	mov    %esp,%ebp
    9eb0:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9eb3:	83 ec 0c             	sub    $0xc,%esp
    9eb6:	6a 0c                	push   $0xc
    9eb8:	e8 e3 06 00 00       	call   a5a0 <spurious_IRQ>
    9ebd:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9ec0:	83 ec 0c             	sub    $0xc,%esp
    9ec3:	6a 0c                	push   $0xc
    9ec5:	e8 ca 04 00 00       	call   a394 <PIC_sendEOI>
    9eca:	83 c4 10             	add    $0x10,%esp
}
    9ecd:	90                   	nop
    9ece:	c9                   	leave  
    9ecf:	c3                   	ret    

00009ed0 <irq13_handler>:

void irq13_handler(void)
{
    9ed0:	55                   	push   %ebp
    9ed1:	89 e5                	mov    %esp,%ebp
    9ed3:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9ed6:	83 ec 0c             	sub    $0xc,%esp
    9ed9:	6a 0d                	push   $0xd
    9edb:	e8 c0 06 00 00       	call   a5a0 <spurious_IRQ>
    9ee0:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9ee3:	83 ec 0c             	sub    $0xc,%esp
    9ee6:	6a 0d                	push   $0xd
    9ee8:	e8 a7 04 00 00       	call   a394 <PIC_sendEOI>
    9eed:	83 c4 10             	add    $0x10,%esp
}
    9ef0:	90                   	nop
    9ef1:	c9                   	leave  
    9ef2:	c3                   	ret    

00009ef3 <irq14_handler>:

void irq14_handler(void)
{
    9ef3:	55                   	push   %ebp
    9ef4:	89 e5                	mov    %esp,%ebp
    9ef6:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9ef9:	83 ec 0c             	sub    $0xc,%esp
    9efc:	6a 0e                	push   $0xe
    9efe:	e8 9d 06 00 00       	call   a5a0 <spurious_IRQ>
    9f03:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9f06:	83 ec 0c             	sub    $0xc,%esp
    9f09:	6a 0e                	push   $0xe
    9f0b:	e8 84 04 00 00       	call   a394 <PIC_sendEOI>
    9f10:	83 c4 10             	add    $0x10,%esp
}
    9f13:	90                   	nop
    9f14:	c9                   	leave  
    9f15:	c3                   	ret    

00009f16 <irq15_handler>:

void irq15_handler(void)
{
    9f16:	55                   	push   %ebp
    9f17:	89 e5                	mov    %esp,%ebp
    9f19:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    9f1c:	83 ec 0c             	sub    $0xc,%esp
    9f1f:	6a 0f                	push   $0xf
    9f21:	e8 7a 06 00 00       	call   a5a0 <spurious_IRQ>
    9f26:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    9f29:	83 ec 0c             	sub    $0xc,%esp
    9f2c:	6a 0f                	push   $0xf
    9f2e:	e8 61 04 00 00       	call   a394 <PIC_sendEOI>
    9f33:	83 c4 10             	add    $0x10,%esp
    9f36:	90                   	nop
    9f37:	c9                   	leave  
    9f38:	c3                   	ret    

00009f39 <keyboard_add_service>:
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x60)  */
          0xFF, 0xFF, 0xFF, 0xFF  /*      (0x61)  */
      };

void keyboard_add_service(void (*func)())
{
    9f39:	55                   	push   %ebp
    9f3a:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service[keyboard_ctrl.kbd_service_num] = func;
    9f3c:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    9f43:	0f be c0             	movsbl %al,%eax
    9f46:	8b 55 08             	mov    0x8(%ebp),%edx
    9f49:	89 14 85 22 08 01 00 	mov    %edx,0x10822(,%eax,4)
    keyboard_ctrl.kbd_service_num++;
    9f50:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    9f57:	83 c0 01             	add    $0x1,%eax
    9f5a:	a2 21 08 01 00       	mov    %al,0x10821
}
    9f5f:	90                   	nop
    9f60:	5d                   	pop    %ebp
    9f61:	c3                   	ret    

00009f62 <kbd_init>:

void kbd_init()
{
    9f62:	55                   	push   %ebp
    9f63:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service_num = 0;
    9f65:	c6 05 21 08 01 00 00 	movb   $0x0,0x10821
    keyboard_add_service(console_service_keyboard);
    9f6c:	68 5f 96 00 00       	push   $0x965f
    9f71:	e8 c3 ff ff ff       	call   9f39 <keyboard_add_service>
    9f76:	83 c4 04             	add    $0x4,%esp
    keyboard_add_service(monitor_service_keyboard);
    9f79:	68 df a8 00 00       	push   $0xa8df
    9f7e:	e8 b6 ff ff ff       	call   9f39 <keyboard_add_service>
    9f83:	83 c4 04             	add    $0x4,%esp
}
    9f86:	90                   	nop
    9f87:	c9                   	leave  
    9f88:	c3                   	ret    

00009f89 <keyboard_irq>:

void keyboard_irq()
{
    9f89:	55                   	push   %ebp
    9f8a:	89 e5                	mov    %esp,%ebp
    9f8c:	83 ec 18             	sub    $0x18,%esp

    int i;
    void (*func)(void);

    do {
        keyboard_ctrl.code = _8042_get_status;
    9f8f:	b8 64 00 00 00       	mov    $0x64,%eax
    9f94:	89 c2                	mov    %eax,%edx
    9f96:	ec                   	in     (%dx),%al
    9f97:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    9f9b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    9f9f:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e
    } while ((keyboard_ctrl.code & 0x01) == _8042_BUFFER_OVERRUN);
    9fa5:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    9fac:	98                   	cwtl   
    9fad:	83 e0 01             	and    $0x1,%eax
    9fb0:	85 c0                	test   %eax,%eax
    9fb2:	74 db                	je     9f8f <keyboard_irq+0x6>

    keyboard_ctrl.code = _8042_scan_code;
    9fb4:	b8 60 00 00 00       	mov    $0x60,%eax
    9fb9:	89 c2                	mov    %eax,%edx
    9fbb:	ec                   	in     (%dx),%al
    9fbc:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    9fc0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    9fc4:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e
    keyboard_ctrl.code--;
    9fca:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    9fd1:	83 e8 01             	sub    $0x1,%eax
    9fd4:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9fda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9fe1:	eb 16                	jmp    9ff9 <keyboard_irq+0x70>
        func = keyboard_ctrl.kbd_service[i];
    9fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9fe6:	8b 04 85 22 08 01 00 	mov    0x10822(,%eax,4),%eax
    9fed:	89 45 ec             	mov    %eax,-0x14(%ebp)
        func();
    9ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9ff3:	ff d0                	call   *%eax
    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9ff5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9ff9:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    a000:	0f be c0             	movsbl %al,%eax
    a003:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a006:	7c db                	jl     9fe3 <keyboard_irq+0x5a>
    }
}
    a008:	90                   	nop
    a009:	90                   	nop
    a00a:	c9                   	leave  
    a00b:	c3                   	ret    

0000a00c <reinitialise_kbd>:

void reinitialise_kbd()
{
    a00c:	55                   	push   %ebp
    a00d:	89 e5                	mov    %esp,%ebp
    a00f:	83 ec 08             	sub    $0x8,%esp
    wait_8042_ACK();
    a012:	e8 43 00 00 00       	call   a05a <wait_8042_ACK>
    _8042_send_get_current_scan_code;
    a017:	ba 64 00 00 00       	mov    $0x64,%edx
    a01c:	b8 f0 00 00 00       	mov    $0xf0,%eax
    a021:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a022:	e8 33 00 00 00       	call   a05a <wait_8042_ACK>

    _8042_set_typematic_rate;
    a027:	ba 64 00 00 00       	mov    $0x64,%edx
    a02c:	b8 f3 00 00 00       	mov    $0xf3,%eax
    a031:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a032:	e8 23 00 00 00       	call   a05a <wait_8042_ACK>

    _8042_set_leds;
    a037:	ba 64 00 00 00       	mov    $0x64,%edx
    a03c:	b8 ed 00 00 00       	mov    $0xed,%eax
    a041:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a042:	e8 13 00 00 00       	call   a05a <wait_8042_ACK>

    _8042_enable_scanning;
    a047:	ba 64 00 00 00       	mov    $0x64,%edx
    a04c:	b8 f4 00 00 00       	mov    $0xf4,%eax
    a051:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a052:	e8 03 00 00 00       	call   a05a <wait_8042_ACK>
}
    a057:	90                   	nop
    a058:	c9                   	leave  
    a059:	c3                   	ret    

0000a05a <wait_8042_ACK>:

static void
wait_8042_ACK()
{
    a05a:	55                   	push   %ebp
    a05b:	89 e5                	mov    %esp,%ebp
    a05d:	83 ec 10             	sub    $0x10,%esp
    while (_8042_get_status != _8042_ACK)
    a060:	90                   	nop
    a061:	b8 64 00 00 00       	mov    $0x64,%eax
    a066:	89 c2                	mov    %eax,%edx
    a068:	ec                   	in     (%dx),%al
    a069:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a06d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a071:	66 3d fa 00          	cmp    $0xfa,%ax
    a075:	75 ea                	jne    a061 <wait_8042_ACK+0x7>
        ;
}
    a077:	90                   	nop
    a078:	90                   	nop
    a079:	c9                   	leave  
    a07a:	c3                   	ret    

0000a07b <get_code_kbd_control>:

int16_t get_code_kbd_control()
{
    a07b:	55                   	push   %ebp
    a07c:	89 e5                	mov    %esp,%ebp
    return keyboard_ctrl.code;
    a07e:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
}
    a085:	5d                   	pop    %ebp
    a086:	c3                   	ret    

0000a087 <handle_ASCII_code_keyboard>:

static void handle_ASCII_code_keyboard()
{
    a087:	55                   	push   %ebp
    a088:	89 e5                	mov    %esp,%ebp
    static int16_t lshift_enable;
    static int16_t rshift_enable;
    static int16_t alt_enable;
    static int16_t ctrl_enable;

    if (keyboard_ctrl.code < 0x80) { /* touche enfoncee */
    a08a:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a091:	66 83 f8 7f          	cmp    $0x7f,%ax
    a095:	0f 8f a1 00 00 00    	jg     a13c <handle_ASCII_code_keyboard+0xb5>
        switch (keyboard_ctrl.code) {
    a09b:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a0a2:	98                   	cwtl   
    a0a3:	83 f8 37             	cmp    $0x37,%eax
    a0a6:	74 43                	je     a0eb <handle_ASCII_code_keyboard+0x64>
    a0a8:	83 f8 37             	cmp    $0x37,%eax
    a0ab:	7f 4c                	jg     a0f9 <handle_ASCII_code_keyboard+0x72>
    a0ad:	83 f8 35             	cmp    $0x35,%eax
    a0b0:	74 1d                	je     a0cf <handle_ASCII_code_keyboard+0x48>
    a0b2:	83 f8 35             	cmp    $0x35,%eax
    a0b5:	7f 42                	jg     a0f9 <handle_ASCII_code_keyboard+0x72>
    a0b7:	83 f8 1c             	cmp    $0x1c,%eax
    a0ba:	74 21                	je     a0dd <handle_ASCII_code_keyboard+0x56>
    a0bc:	83 f8 29             	cmp    $0x29,%eax
    a0bf:	75 38                	jne    a0f9 <handle_ASCII_code_keyboard+0x72>
        case 0x29: lshift_enable = 1; break;
    a0c1:	66 c7 05 20 0c 01 00 	movw   $0x1,0x10c20
    a0c8:	01 00 
    a0ca:	e9 ce 00 00 00       	jmp    a19d <handle_ASCII_code_keyboard+0x116>
        case 0x35: rshift_enable = 1; break;
    a0cf:	66 c7 05 22 0c 01 00 	movw   $0x1,0x10c22
    a0d6:	01 00 
    a0d8:	e9 c0 00 00 00       	jmp    a19d <handle_ASCII_code_keyboard+0x116>
        case 0x1C: ctrl_enable = 1; break;
    a0dd:	66 c7 05 24 0c 01 00 	movw   $0x1,0x10c24
    a0e4:	01 00 
    a0e6:	e9 b2 00 00 00       	jmp    a19d <handle_ASCII_code_keyboard+0x116>
        case 0x37: alt_enable = 1; break;
    a0eb:	66 c7 05 26 0c 01 00 	movw   $0x1,0x10c26
    a0f2:	01 00 
    a0f4:	e9 a4 00 00 00       	jmp    a19d <handle_ASCII_code_keyboard+0x116>
        default:
            keyboard_ctrl.ascii_code_keyboard = kbdmap[keyboard_ctrl.code * 4 + (lshift_enable || rshift_enable)];
    a0f9:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a100:	98                   	cwtl   
    a101:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a108:	0f b7 05 20 0c 01 00 	movzwl 0x10c20,%eax
    a10f:	66 85 c0             	test   %ax,%ax
    a112:	75 0c                	jne    a120 <handle_ASCII_code_keyboard+0x99>
    a114:	0f b7 05 22 0c 01 00 	movzwl 0x10c22,%eax
    a11b:	66 85 c0             	test   %ax,%ax
    a11e:	74 07                	je     a127 <handle_ASCII_code_keyboard+0xa0>
    a120:	b8 01 00 00 00       	mov    $0x1,%eax
    a125:	eb 05                	jmp    a12c <handle_ASCII_code_keyboard+0xa5>
    a127:	b8 00 00 00 00       	mov    $0x0,%eax
    a12c:	01 d0                	add    %edx,%eax
    a12e:	0f b6 80 e0 b4 00 00 	movzbl 0xb4e0(%eax),%eax
    a135:	a2 20 08 01 00       	mov    %al,0x10820
            return;
    a13a:	eb 61                	jmp    a19d <handle_ASCII_code_keyboard+0x116>
        }
    } else { /* touche relachee */
        keyboard_ctrl.code -= 0x80;
    a13c:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a143:	83 c0 80             	add    $0xffffff80,%eax
    a146:	66 a3 1e 0c 01 00    	mov    %ax,0x10c1e
        switch (keyboard_ctrl.code) {
    a14c:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a153:	98                   	cwtl   
    a154:	83 f8 37             	cmp    $0x37,%eax
    a157:	74 3a                	je     a193 <handle_ASCII_code_keyboard+0x10c>
    a159:	83 f8 37             	cmp    $0x37,%eax
    a15c:	7f 3f                	jg     a19d <handle_ASCII_code_keyboard+0x116>
    a15e:	83 f8 35             	cmp    $0x35,%eax
    a161:	74 1a                	je     a17d <handle_ASCII_code_keyboard+0xf6>
    a163:	83 f8 35             	cmp    $0x35,%eax
    a166:	7f 35                	jg     a19d <handle_ASCII_code_keyboard+0x116>
    a168:	83 f8 1c             	cmp    $0x1c,%eax
    a16b:	74 1b                	je     a188 <handle_ASCII_code_keyboard+0x101>
    a16d:	83 f8 29             	cmp    $0x29,%eax
    a170:	75 2b                	jne    a19d <handle_ASCII_code_keyboard+0x116>
        case 0x29: lshift_enable = 0; break;
    a172:	66 c7 05 20 0c 01 00 	movw   $0x0,0x10c20
    a179:	00 00 
    a17b:	eb 20                	jmp    a19d <handle_ASCII_code_keyboard+0x116>
        case 0x35: rshift_enable = 0; break;
    a17d:	66 c7 05 22 0c 01 00 	movw   $0x0,0x10c22
    a184:	00 00 
    a186:	eb 15                	jmp    a19d <handle_ASCII_code_keyboard+0x116>
        case 0x1C: ctrl_enable = 0; break;
    a188:	66 c7 05 24 0c 01 00 	movw   $0x0,0x10c24
    a18f:	00 00 
    a191:	eb 0a                	jmp    a19d <handle_ASCII_code_keyboard+0x116>
        case 0x37: alt_enable = 0; break;
    a193:	66 c7 05 26 0c 01 00 	movw   $0x0,0x10c26
    a19a:	00 00 
    a19c:	90                   	nop
        }
    }
}
    a19d:	5d                   	pop    %ebp
    a19e:	c3                   	ret    

0000a19f <get_ASCII_code_keyboard>:

int8_t get_ASCII_code_keyboard()
{
    a19f:	55                   	push   %ebp
    a1a0:	89 e5                	mov    %esp,%ebp
    handle_ASCII_code_keyboard();
    a1a2:	e8 e0 fe ff ff       	call   a087 <handle_ASCII_code_keyboard>
    return keyboard_ctrl.ascii_code_keyboard;
    a1a7:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    a1ae:	5d                   	pop    %ebp
    a1af:	c3                   	ret    

0000a1b0 <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    a1b0:	55                   	push   %ebp
    a1b1:	89 e5                	mov    %esp,%ebp
    a1b3:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a1b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a1bd:	eb 20                	jmp    a1df <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1c2:	c1 e0 0c             	shl    $0xc,%eax
    a1c5:	89 c2                	mov    %eax,%edx
    a1c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a1d1:	8b 45 08             	mov    0x8(%ebp),%eax
    a1d4:	01 c8                	add    %ecx,%eax
    a1d6:	83 ca 23             	or     $0x23,%edx
    a1d9:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a1db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a1df:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a1e6:	76 d7                	jbe    a1bf <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    a1e8:	8b 45 08             	mov    0x8(%ebp),%eax
    a1eb:	83 c8 23             	or     $0x23,%eax
    a1ee:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    a1f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    a1f3:	89 14 85 00 10 01 00 	mov    %edx,0x11000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    a1fa:	e8 51 11 00 00       	call   b350 <_FlushPagingCache_>
}
    a1ff:	90                   	nop
    a200:	c9                   	leave  
    a201:	c3                   	ret    

0000a202 <init_paging>:

void init_paging()
{
    a202:	55                   	push   %ebp
    a203:	89 e5                	mov    %esp,%ebp
    a205:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    a208:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a20e:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    a214:	eb 1a                	jmp    a230 <init_paging+0x2e>
        page_directory[i] =
    a216:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a21a:	c7 04 85 00 10 01 00 	movl   $0x2,0x11000(,%eax,4)
    a221:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a225:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a229:	83 c0 01             	add    $0x1,%eax
    a22c:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a230:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a236:	76 de                	jbe    a216 <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a238:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    a23e:	eb 22                	jmp    a262 <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a240:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a244:	c1 e0 0c             	shl    $0xc,%eax
    a247:	83 c8 23             	or     $0x23,%eax
    a24a:	89 c2                	mov    %eax,%edx
    a24c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a250:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a257:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a25b:	83 c0 01             	add    $0x1,%eax
    a25e:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a262:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a268:	76 d6                	jbe    a240 <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    a26a:	b8 00 c0 00 00       	mov    $0xc000,%eax
    a26f:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    a272:	a3 00 10 01 00       	mov    %eax,0x11000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    a277:	e8 dd 10 00 00       	call   b359 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    a27c:	90                   	nop
    a27d:	c9                   	leave  
    a27e:	c3                   	ret    

0000a27f <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    a27f:	55                   	push   %ebp
    a280:	89 e5                	mov    %esp,%ebp
    a282:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    a285:	8b 45 08             	mov    0x8(%ebp),%eax
    a288:	c1 e8 16             	shr    $0x16,%eax
    a28b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    a28e:	8b 45 08             	mov    0x8(%ebp),%eax
    a291:	c1 e8 0c             	shr    $0xc,%eax
    a294:	25 ff 03 00 00       	and    $0x3ff,%eax
    a299:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a29c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a29f:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a2a6:	83 e0 23             	and    $0x23,%eax
    a2a9:	83 f8 23             	cmp    $0x23,%eax
    a2ac:	75 56                	jne    a304 <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a2b1:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a2b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a2bd:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a2c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a2c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a2ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a2cd:	01 d0                	add    %edx,%eax
    a2cf:	8b 00                	mov    (%eax),%eax
    a2d1:	83 e0 23             	and    $0x23,%eax
    a2d4:	83 f8 23             	cmp    $0x23,%eax
    a2d7:	75 24                	jne    a2fd <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a2d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a2dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a2e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a2e6:	01 d0                	add    %edx,%eax
    a2e8:	8b 00                	mov    (%eax),%eax
    a2ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a2ef:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    a2f1:	8b 45 08             	mov    0x8(%ebp),%eax
    a2f4:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a2f9:	09 d0                	or     %edx,%eax
    a2fb:	eb 0c                	jmp    a309 <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    a2fd:	b8 70 f0 00 00       	mov    $0xf070,%eax
    a302:	eb 05                	jmp    a309 <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    a304:	b8 70 f0 00 00       	mov    $0xf070,%eax
}
    a309:	c9                   	leave  
    a30a:	c3                   	ret    

0000a30b <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    a30b:	55                   	push   %ebp
    a30c:	89 e5                	mov    %esp,%ebp
    a30e:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    a311:	8b 45 08             	mov    0x8(%ebp),%eax
    a314:	c1 e8 16             	shr    $0x16,%eax
    a317:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    a31a:	8b 45 08             	mov    0x8(%ebp),%eax
    a31d:	c1 e8 0c             	shr    $0xc,%eax
    a320:	25 ff 03 00 00       	and    $0x3ff,%eax
    a325:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a328:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a32b:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a332:	83 e0 23             	and    $0x23,%eax
    a335:	83 f8 23             	cmp    $0x23,%eax
    a338:	75 4e                	jne    a388 <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a33a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a33d:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a349:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a34c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a34f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a356:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a359:	01 d0                	add    %edx,%eax
    a35b:	8b 00                	mov    (%eax),%eax
    a35d:	83 e0 23             	and    $0x23,%eax
    a360:	83 f8 23             	cmp    $0x23,%eax
    a363:	74 26                	je     a38b <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a365:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a368:	c1 e0 0c             	shl    $0xc,%eax
    a36b:	89 c2                	mov    %eax,%edx
    a36d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a370:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a377:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a37a:	01 c8                	add    %ecx,%eax
    a37c:	83 ca 23             	or     $0x23,%edx
    a37f:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a381:	e8 ca 0f 00 00       	call   b350 <_FlushPagingCache_>
    a386:	eb 04                	jmp    a38c <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a388:	90                   	nop
    a389:	eb 01                	jmp    a38c <map_linear_address+0x81>
            return; // the linear address was already mapped
    a38b:	90                   	nop
}
    a38c:	c9                   	leave  
    a38d:	c3                   	ret    

0000a38e <Paging_fault>:

void Paging_fault()
{
    a38e:	55                   	push   %ebp
    a38f:	89 e5                	mov    %esp,%ebp
}
    a391:	90                   	nop
    a392:	5d                   	pop    %ebp
    a393:	c3                   	ret    

0000a394 <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a394:	55                   	push   %ebp
    a395:	89 e5                	mov    %esp,%ebp
    a397:	83 ec 04             	sub    $0x4,%esp
    a39a:	8b 45 08             	mov    0x8(%ebp),%eax
    a39d:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a3a0:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a3a4:	76 0b                	jbe    a3b1 <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a3a6:	ba a0 00 00 00       	mov    $0xa0,%edx
    a3ab:	b8 20 00 00 00       	mov    $0x20,%eax
    a3b0:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a3b1:	ba 20 00 00 00       	mov    $0x20,%edx
    a3b6:	b8 20 00 00 00       	mov    $0x20,%eax
    a3bb:	ee                   	out    %al,(%dx)
}
    a3bc:	90                   	nop
    a3bd:	c9                   	leave  
    a3be:	c3                   	ret    

0000a3bf <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a3bf:	55                   	push   %ebp
    a3c0:	89 e5                	mov    %esp,%ebp
    a3c2:	83 ec 18             	sub    $0x18,%esp
    a3c5:	8b 55 08             	mov    0x8(%ebp),%edx
    a3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    a3cb:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a3ce:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a3d1:	b8 21 00 00 00       	mov    $0x21,%eax
    a3d6:	89 c2                	mov    %eax,%edx
    a3d8:	ec                   	in     (%dx),%al
    a3d9:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a3dd:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a3e1:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2 = inb(PIC2_DATA);
    a3e4:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a3e9:	89 c2                	mov    %eax,%edx
    a3eb:	ec                   	in     (%dx),%al
    a3ec:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a3f0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a3f4:	88 45 f9             	mov    %al,-0x7(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a3f7:	ba 20 00 00 00       	mov    $0x20,%edx
    a3fc:	b8 11 00 00 00       	mov    $0x11,%eax
    a401:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a402:	eb 00                	jmp    a404 <PIC_remap+0x45>
    a404:	eb 00                	jmp    a406 <PIC_remap+0x47>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a406:	ba a0 00 00 00       	mov    $0xa0,%edx
    a40b:	b8 11 00 00 00       	mov    $0x11,%eax
    a410:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a411:	eb 00                	jmp    a413 <PIC_remap+0x54>
    a413:	eb 00                	jmp    a415 <PIC_remap+0x56>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a415:	ba 21 00 00 00       	mov    $0x21,%edx
    a41a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a41e:	ee                   	out    %al,(%dx)
    io_wait;
    a41f:	eb 00                	jmp    a421 <PIC_remap+0x62>
    a421:	eb 00                	jmp    a423 <PIC_remap+0x64>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a423:	ba a1 00 00 00       	mov    $0xa1,%edx
    a428:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a42c:	ee                   	out    %al,(%dx)
    io_wait;
    a42d:	eb 00                	jmp    a42f <PIC_remap+0x70>
    a42f:	eb 00                	jmp    a431 <PIC_remap+0x72>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a431:	ba 21 00 00 00       	mov    $0x21,%edx
    a436:	b8 04 00 00 00       	mov    $0x4,%eax
    a43b:	ee                   	out    %al,(%dx)
    io_wait;
    a43c:	eb 00                	jmp    a43e <PIC_remap+0x7f>
    a43e:	eb 00                	jmp    a440 <PIC_remap+0x81>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a440:	ba a1 00 00 00       	mov    $0xa1,%edx
    a445:	b8 02 00 00 00       	mov    $0x2,%eax
    a44a:	ee                   	out    %al,(%dx)
    io_wait;
    a44b:	eb 00                	jmp    a44d <PIC_remap+0x8e>
    a44d:	eb 00                	jmp    a44f <PIC_remap+0x90>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a44f:	ba 21 00 00 00       	mov    $0x21,%edx
    a454:	b8 01 00 00 00       	mov    $0x1,%eax
    a459:	ee                   	out    %al,(%dx)
    io_wait;
    a45a:	eb 00                	jmp    a45c <PIC_remap+0x9d>
    a45c:	eb 00                	jmp    a45e <PIC_remap+0x9f>

    outb(PIC2_DATA, ICW4_8086);
    a45e:	ba a1 00 00 00       	mov    $0xa1,%edx
    a463:	b8 01 00 00 00       	mov    $0x1,%eax
    a468:	ee                   	out    %al,(%dx)
    io_wait;
    a469:	eb 00                	jmp    a46b <PIC_remap+0xac>
    a46b:	eb 00                	jmp    a46d <PIC_remap+0xae>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a46d:	ba 21 00 00 00       	mov    $0x21,%edx
    a472:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a476:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a477:	ba a1 00 00 00       	mov    $0xa1,%edx
    a47c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a480:	ee                   	out    %al,(%dx)
}
    a481:	90                   	nop
    a482:	c9                   	leave  
    a483:	c3                   	ret    

0000a484 <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a484:	55                   	push   %ebp
    a485:	89 e5                	mov    %esp,%ebp
    a487:	53                   	push   %ebx
    a488:	83 ec 14             	sub    $0x14,%esp
    a48b:	8b 45 08             	mov    0x8(%ebp),%eax
    a48e:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a491:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a495:	77 08                	ja     a49f <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a497:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a49d:	eb 0a                	jmp    a4a9 <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a49f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a4a5:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a4a9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a4ad:	89 c2                	mov    %eax,%edx
    a4af:	ec                   	in     (%dx),%al
    a4b0:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a4b4:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a4b8:	89 c3                	mov    %eax,%ebx
    a4ba:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a4be:	ba 01 00 00 00       	mov    $0x1,%edx
    a4c3:	89 c1                	mov    %eax,%ecx
    a4c5:	d3 e2                	shl    %cl,%edx
    a4c7:	89 d0                	mov    %edx,%eax
    a4c9:	09 d8                	or     %ebx,%eax
    a4cb:	88 45 f7             	mov    %al,-0x9(%ebp)

    outb(port, value);
    a4ce:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a4d2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a4d6:	ee                   	out    %al,(%dx)
}
    a4d7:	90                   	nop
    a4d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a4db:	c9                   	leave  
    a4dc:	c3                   	ret    

0000a4dd <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a4dd:	55                   	push   %ebp
    a4de:	89 e5                	mov    %esp,%ebp
    a4e0:	53                   	push   %ebx
    a4e1:	83 ec 14             	sub    $0x14,%esp
    a4e4:	8b 45 08             	mov    0x8(%ebp),%eax
    a4e7:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a4ea:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a4ee:	77 09                	ja     a4f9 <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a4f0:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a4f7:	eb 0b                	jmp    a504 <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a4f9:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a500:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a504:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a507:	89 c2                	mov    %eax,%edx
    a509:	ec                   	in     (%dx),%al
    a50a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a50e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a512:	89 c3                	mov    %eax,%ebx
    a514:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a518:	ba 01 00 00 00       	mov    $0x1,%edx
    a51d:	89 c1                	mov    %eax,%ecx
    a51f:	d3 e2                	shl    %cl,%edx
    a521:	89 d0                	mov    %edx,%eax
    a523:	f7 d0                	not    %eax
    a525:	21 d8                	and    %ebx,%eax
    a527:	88 45 f5             	mov    %al,-0xb(%ebp)

    outb(port, value);
    a52a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a52d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a531:	ee                   	out    %al,(%dx)
}
    a532:	90                   	nop
    a533:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a536:	c9                   	leave  
    a537:	c3                   	ret    

0000a538 <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a538:	55                   	push   %ebp
    a539:	89 e5                	mov    %esp,%ebp
    a53b:	83 ec 14             	sub    $0x14,%esp
    a53e:	8b 45 08             	mov    0x8(%ebp),%eax
    a541:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a544:	ba 20 00 00 00       	mov    $0x20,%edx
    a549:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a54d:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a54e:	ba a0 00 00 00       	mov    $0xa0,%edx
    a553:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a557:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a558:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a55d:	89 c2                	mov    %eax,%edx
    a55f:	ec                   	in     (%dx),%al
    a560:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a564:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a568:	98                   	cwtl   
    a569:	c1 e0 08             	shl    $0x8,%eax
    a56c:	89 c1                	mov    %eax,%ecx
    a56e:	b8 20 00 00 00       	mov    $0x20,%eax
    a573:	89 c2                	mov    %eax,%edx
    a575:	ec                   	in     (%dx),%al
    a576:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a57a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a57e:	09 c8                	or     %ecx,%eax
}
    a580:	c9                   	leave  
    a581:	c3                   	ret    

0000a582 <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a582:	55                   	push   %ebp
    a583:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a585:	6a 0b                	push   $0xb
    a587:	e8 ac ff ff ff       	call   a538 <__pic_get_irq_reg>
    a58c:	83 c4 04             	add    $0x4,%esp
}
    a58f:	c9                   	leave  
    a590:	c3                   	ret    

0000a591 <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a591:	55                   	push   %ebp
    a592:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a594:	6a 0a                	push   $0xa
    a596:	e8 9d ff ff ff       	call   a538 <__pic_get_irq_reg>
    a59b:	83 c4 04             	add    $0x4,%esp
}
    a59e:	c9                   	leave  
    a59f:	c3                   	ret    

0000a5a0 <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a5a0:	55                   	push   %ebp
    a5a1:	89 e5                	mov    %esp,%ebp
    a5a3:	83 ec 14             	sub    $0x14,%esp
    a5a6:	8b 45 08             	mov    0x8(%ebp),%eax
    a5a9:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a5ac:	e8 d1 ff ff ff       	call   a582 <pic_get_isr>
    a5b1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a5b5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a5b9:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a5bd:	74 13                	je     a5d2 <spurious_IRQ+0x32>
    a5bf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a5c3:	0f b6 c0             	movzbl %al,%eax
    a5c6:	83 e0 07             	and    $0x7,%eax
    a5c9:	50                   	push   %eax
    a5ca:	e8 c5 fd ff ff       	call   a394 <PIC_sendEOI>
    a5cf:	83 c4 04             	add    $0x4,%esp
    a5d2:	90                   	nop
    a5d3:	c9                   	leave  
    a5d4:	c3                   	ret    

0000a5d5 <conserv_status_byte>:
uint32_t compteur   = 0;
uint8_t  frequency  = 0;
uint8_t  status_PIT = 0;

void conserv_status_byte()
{
    a5d5:	55                   	push   %ebp
    a5d6:	89 e5                	mov    %esp,%ebp
    a5d8:	83 ec 10             	sub    $0x10,%esp
    set_pit_count(PIT_0, PIT_reload_value);
    a5db:	ba 43 00 00 00       	mov    $0x43,%edx
    a5e0:	b8 40 00 00 00       	mov    $0x40,%eax
    a5e5:	ee                   	out    %al,(%dx)
    a5e6:	b8 40 00 00 00       	mov    $0x40,%eax
    a5eb:	89 c2                	mov    %eax,%edx
    a5ed:	ec                   	in     (%dx),%al
    a5ee:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a5f2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a5f6:	88 45 f6             	mov    %al,-0xa(%ebp)
    a5f9:	b8 40 00 00 00       	mov    $0x40,%eax
    a5fe:	89 c2                	mov    %eax,%edx
    a600:	ec                   	in     (%dx),%al
    a601:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a605:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a609:	88 45 f7             	mov    %al,-0x9(%ebp)
    a60c:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a610:	66 98                	cbtw   
    a612:	ba 40 00 00 00       	mov    $0x40,%edx
    a617:	ee                   	out    %al,(%dx)
    a618:	a1 74 32 02 00       	mov    0x23274,%eax
    a61d:	c1 f8 08             	sar    $0x8,%eax
    a620:	ba 40 00 00 00       	mov    $0x40,%edx
    a625:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a626:	ba 43 00 00 00       	mov    $0x43,%edx
    a62b:	b8 40 00 00 00       	mov    $0x40,%eax
    a630:	ee                   	out    %al,(%dx)
    a631:	b8 40 00 00 00       	mov    $0x40,%eax
    a636:	89 c2                	mov    %eax,%edx
    a638:	ec                   	in     (%dx),%al
    a639:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a63d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a641:	88 45 f4             	mov    %al,-0xc(%ebp)
    a644:	b8 40 00 00 00       	mov    $0x40,%eax
    a649:	89 c2                	mov    %eax,%edx
    a64b:	ec                   	in     (%dx),%al
    a64c:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a650:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a654:	88 45 f5             	mov    %al,-0xb(%ebp)
    a657:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a65b:	66 98                	cbtw   
    a65d:	ba 43 00 00 00       	mov    $0x43,%edx
    a662:	ee                   	out    %al,(%dx)
    a663:	ba 43 00 00 00       	mov    $0x43,%edx
    a668:	b8 34 00 00 00       	mov    $0x34,%eax
    a66d:	ee                   	out    %al,(%dx)
}
    a66e:	90                   	nop
    a66f:	c9                   	leave  
    a670:	c3                   	ret    

0000a671 <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a671:	55                   	push   %ebp
    a672:	89 e5                	mov    %esp,%ebp
    a674:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a677:	0f b6 05 40 31 02 00 	movzbl 0x23140,%eax
    a67e:	3c 01                	cmp    $0x1,%al
    a680:	75 27                	jne    a6a9 <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a682:	a1 44 31 02 00       	mov    0x23144,%eax
    a687:	85 c0                	test   %eax,%eax
    a689:	75 11                	jne    a69c <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a68b:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    a692:	01 00 00 
            __switch();
    a695:	e8 d8 0a 00 00       	call   b172 <__switch>
        } else
            sheduler.task_timer--;
    }
}
    a69a:	eb 0d                	jmp    a6a9 <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a69c:	a1 44 31 02 00       	mov    0x23144,%eax
    a6a1:	83 e8 01             	sub    $0x1,%eax
    a6a4:	a3 44 31 02 00       	mov    %eax,0x23144
}
    a6a9:	90                   	nop
    a6aa:	c9                   	leave  
    a6ab:	c3                   	ret    

0000a6ac <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a6ac:	55                   	push   %ebp
    a6ad:	89 e5                	mov    %esp,%ebp
    a6af:	83 ec 28             	sub    $0x28,%esp
    a6b2:	8b 45 08             	mov    0x8(%ebp),%eax
    a6b5:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a6b9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a6bd:	a2 04 20 01 00       	mov    %al,0x12004
    calculate_frequency();
    a6c2:	e8 f5 0c 00 00       	call   b3bc <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a6c7:	ba 43 00 00 00       	mov    $0x43,%edx
    a6cc:	b8 40 00 00 00       	mov    $0x40,%eax
    a6d1:	ee                   	out    %al,(%dx)
    a6d2:	b8 40 00 00 00       	mov    $0x40,%eax
    a6d7:	89 c2                	mov    %eax,%edx
    a6d9:	ec                   	in     (%dx),%al
    a6da:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a6de:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a6e2:	88 45 ee             	mov    %al,-0x12(%ebp)
    a6e5:	b8 40 00 00 00       	mov    $0x40,%eax
    a6ea:	89 c2                	mov    %eax,%edx
    a6ec:	ec                   	in     (%dx),%al
    a6ed:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    a6f1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
    a6f5:	88 45 ef             	mov    %al,-0x11(%ebp)
    a6f8:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    a6fc:	66 98                	cbtw   
    a6fe:	ba 43 00 00 00       	mov    $0x43,%edx
    a703:	ee                   	out    %al,(%dx)
    a704:	ba 43 00 00 00       	mov    $0x43,%edx
    a709:	b8 34 00 00 00       	mov    $0x34,%eax
    a70e:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a70f:	ba 43 00 00 00       	mov    $0x43,%edx
    a714:	b8 40 00 00 00       	mov    $0x40,%eax
    a719:	ee                   	out    %al,(%dx)
    a71a:	b8 40 00 00 00       	mov    $0x40,%eax
    a71f:	89 c2                	mov    %eax,%edx
    a721:	ec                   	in     (%dx),%al
    a722:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a726:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a72a:	88 45 ec             	mov    %al,-0x14(%ebp)
    a72d:	b8 40 00 00 00       	mov    $0x40,%eax
    a732:	89 c2                	mov    %eax,%edx
    a734:	ec                   	in     (%dx),%al
    a735:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a739:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a73d:	88 45 ed             	mov    %al,-0x13(%ebp)
    a740:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a744:	66 98                	cbtw   
    a746:	ba 40 00 00 00       	mov    $0x40,%edx
    a74b:	ee                   	out    %al,(%dx)
    a74c:	a1 74 32 02 00       	mov    0x23274,%eax
    a751:	c1 f8 08             	sar    $0x8,%eax
    a754:	ba 40 00 00 00       	mov    $0x40,%edx
    a759:	ee                   	out    %al,(%dx)
}
    a75a:	90                   	nop
    a75b:	c9                   	leave  
    a75c:	c3                   	ret    

0000a75d <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a75d:	55                   	push   %ebp
    a75e:	89 e5                	mov    %esp,%ebp
    a760:	83 ec 14             	sub    $0x14,%esp
    a763:	8b 45 08             	mov    0x8(%ebp),%eax
    a766:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a769:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a76d:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a771:	83 f8 42             	cmp    $0x42,%eax
    a774:	74 1d                	je     a793 <read_back_channel+0x36>
    a776:	83 f8 42             	cmp    $0x42,%eax
    a779:	7f 1e                	jg     a799 <read_back_channel+0x3c>
    a77b:	83 f8 40             	cmp    $0x40,%eax
    a77e:	74 07                	je     a787 <read_back_channel+0x2a>
    a780:	83 f8 41             	cmp    $0x41,%eax
    a783:	74 08                	je     a78d <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a785:	eb 12                	jmp    a799 <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a787:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a78b:	eb 0d                	jmp    a79a <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a78d:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a791:	eb 07                	jmp    a79a <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a793:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a797:	eb 01                	jmp    a79a <read_back_channel+0x3d>
        break;
    a799:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a79a:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a79e:	ba 43 00 00 00       	mov    $0x43,%edx
    a7a3:	b8 40 00 00 00       	mov    $0x40,%eax
    a7a8:	ee                   	out    %al,(%dx)
    a7a9:	b8 40 00 00 00       	mov    $0x40,%eax
    a7ae:	89 c2                	mov    %eax,%edx
    a7b0:	ec                   	in     (%dx),%al
    a7b1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a7b5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a7b9:	88 45 f4             	mov    %al,-0xc(%ebp)
    a7bc:	b8 40 00 00 00       	mov    $0x40,%eax
    a7c1:	89 c2                	mov    %eax,%edx
    a7c3:	ec                   	in     (%dx),%al
    a7c4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a7c8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a7cc:	88 45 f5             	mov    %al,-0xb(%ebp)
    a7cf:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a7d3:	66 98                	cbtw   
    a7d5:	ba 43 00 00 00       	mov    $0x43,%edx
    a7da:	ee                   	out    %al,(%dx)
    a7db:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a7df:	c1 f8 08             	sar    $0x8,%eax
    a7e2:	ba 43 00 00 00       	mov    $0x43,%edx
    a7e7:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a7e8:	ba 43 00 00 00       	mov    $0x43,%edx
    a7ed:	b8 40 00 00 00       	mov    $0x40,%eax
    a7f2:	ee                   	out    %al,(%dx)
    a7f3:	b8 40 00 00 00       	mov    $0x40,%eax
    a7f8:	89 c2                	mov    %eax,%edx
    a7fa:	ec                   	in     (%dx),%al
    a7fb:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a7ff:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a803:	88 45 f2             	mov    %al,-0xe(%ebp)
    a806:	b8 40 00 00 00       	mov    $0x40,%eax
    a80b:	89 c2                	mov    %eax,%edx
    a80d:	ec                   	in     (%dx),%al
    a80e:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a812:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a816:	88 45 f3             	mov    %al,-0xd(%ebp)
    a819:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a81d:	66 98                	cbtw   
    a81f:	c9                   	leave  
    a820:	c3                   	ret    

0000a821 <read_ebp>:
        registers;                                                     \
    })

static inline uint32_t
read_ebp(void)
{
    a821:	55                   	push   %ebp
    a822:	89 e5                	mov    %esp,%ebp
    a824:	83 ec 10             	sub    $0x10,%esp
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
    a827:	89 e8                	mov    %ebp,%eax
    a829:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(ebp));
    return ebp;
    a82c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a82f:	c9                   	leave  
    a830:	c3                   	ret    

0000a831 <backtrace>:
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    a831:	55                   	push   %ebp
    a832:	89 e5                	mov    %esp,%ebp
    a834:	83 ec 18             	sub    $0x18,%esp
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;
    a837:	e8 e5 ff ff ff       	call   a821 <read_ebp>
    a83c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a842:	83 c0 04             	add    $0x4,%eax
    a845:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp != 0) {
    a848:	eb 30                	jmp    a87a <backtrace+0x49>
        kprintf("ebp %x eip %x\n", ebp, *eip);
    a84a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a84d:	8b 00                	mov    (%eax),%eax
    a84f:	83 ec 04             	sub    $0x4,%esp
    a852:	50                   	push   %eax
    a853:	ff 75 f4             	pushl  -0xc(%ebp)
    a856:	68 c3 f0 00 00       	push   $0xf0c3
    a85b:	e8 03 01 00 00       	call   a963 <kprintf>
    a860:	83 c4 10             	add    $0x10,%esp

        ptr = (int*)(ebp);
    a863:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a866:	89 45 ec             	mov    %eax,-0x14(%ebp)

        ebp = (int)(*ptr);
    a869:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a86c:	8b 00                	mov    (%eax),%eax
    a86e:	89 45 f4             	mov    %eax,-0xc(%ebp)

        eip = (int*)(ebp + 4);
    a871:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a874:	83 c0 04             	add    $0x4,%eax
    a877:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (ebp != 0) {
    a87a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    a87e:	75 ca                	jne    a84a <backtrace+0x19>
    }
    return 0;
    a880:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a885:	c9                   	leave  
    a886:	c3                   	ret    

0000a887 <mon_help>:

int mon_help(int argc, char** argv)
{
    a887:	55                   	push   %ebp
    a888:	89 e5                	mov    %esp,%ebp
    a88a:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 2; i++)
    a88d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a894:	eb 3c                	jmp    a8d2 <mon_help+0x4b>
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    a896:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a899:	89 d0                	mov    %edx,%eax
    a89b:	01 c0                	add    %eax,%eax
    a89d:	01 d0                	add    %edx,%eax
    a89f:	c1 e0 02             	shl    $0x2,%eax
    a8a2:	05 68 b6 00 00       	add    $0xb668,%eax
    a8a7:	8b 10                	mov    (%eax),%edx
    a8a9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    a8ac:	89 c8                	mov    %ecx,%eax
    a8ae:	01 c0                	add    %eax,%eax
    a8b0:	01 c8                	add    %ecx,%eax
    a8b2:	c1 e0 02             	shl    $0x2,%eax
    a8b5:	05 64 b6 00 00       	add    $0xb664,%eax
    a8ba:	8b 00                	mov    (%eax),%eax
    a8bc:	83 ec 04             	sub    $0x4,%esp
    a8bf:	52                   	push   %edx
    a8c0:	50                   	push   %eax
    a8c1:	68 d2 f0 00 00       	push   $0xf0d2
    a8c6:	e8 98 00 00 00       	call   a963 <kprintf>
    a8cb:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 2; i++)
    a8ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a8d2:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    a8d6:	7e be                	jle    a896 <mon_help+0xf>
    return 0;
    a8d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a8dd:	c9                   	leave  
    a8de:	c3                   	ret    

0000a8df <monitor_service_keyboard>:

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    a8df:	55                   	push   %ebp
    a8e0:	89 e5                	mov    %esp,%ebp
    a8e2:	83 ec 18             	sub    $0x18,%esp
    int8_t code = get_ASCII_code_keyboard();
    a8e5:	e8 b5 f8 ff ff       	call   a19f <get_ASCII_code_keyboard>
    a8ea:	88 45 f3             	mov    %al,-0xd(%ebp)
    if (code != '\n') {
    a8ed:	80 7d f3 0a          	cmpb   $0xa,-0xd(%ebp)
    a8f1:	74 25                	je     a918 <monitor_service_keyboard+0x39>
        keyboard_code_monitor[keyboard_num] = code;
    a8f3:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a8fa:	0f be c0             	movsbl %al,%eax
    a8fd:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
    a901:	88 90 20 20 01 00    	mov    %dl,0x12020(%eax)
        keyboard_num++;
    a907:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a90e:	83 c0 01             	add    $0x1,%eax
    a911:	a2 1f 21 01 00       	mov    %al,0x1211f
            keyboard_code_monitor[i] = 0;
        }

        keyboard_num = 0;
    }
    a916:	eb 48                	jmp    a960 <monitor_service_keyboard+0x81>
        for (i = 0; i < keyboard_num; i++) {
    a918:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a91f:	eb 29                	jmp    a94a <monitor_service_keyboard+0x6b>
            putchar(keyboard_code_monitor[i]);
    a921:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a924:	05 20 20 01 00       	add    $0x12020,%eax
    a929:	0f b6 00             	movzbl (%eax),%eax
    a92c:	0f b6 c0             	movzbl %al,%eax
    a92f:	83 ec 0c             	sub    $0xc,%esp
    a932:	50                   	push   %eax
    a933:	e8 e1 e6 ff ff       	call   9019 <putchar>
    a938:	83 c4 10             	add    $0x10,%esp
            keyboard_code_monitor[i] = 0;
    a93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a93e:	05 20 20 01 00       	add    $0x12020,%eax
    a943:	c6 00 00             	movb   $0x0,(%eax)
        for (i = 0; i < keyboard_num; i++) {
    a946:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a94a:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a951:	0f be c0             	movsbl %al,%eax
    a954:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a957:	7c c8                	jl     a921 <monitor_service_keyboard+0x42>
        keyboard_num = 0;
    a959:	c6 05 1f 21 01 00 00 	movb   $0x0,0x1211f
    a960:	90                   	nop
    a961:	c9                   	leave  
    a962:	c3                   	ret    

0000a963 <kprintf>:
#include <stdint.h>

extern void printf(const char* fmt, va_list arg);

void kprintf(const char* frmt, ...)
{
    a963:	55                   	push   %ebp
    a964:	89 e5                	mov    %esp,%ebp
    a966:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    a969:	8d 45 0c             	lea    0xc(%ebp),%eax
    a96c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    a96f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a972:	83 ec 08             	sub    $0x8,%esp
    a975:	50                   	push   %eax
    a976:	ff 75 08             	pushl  0x8(%ebp)
    a979:	e8 20 e7 ff ff       	call   909e <printf>
    a97e:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    a981:	90                   	nop
    a982:	c9                   	leave  
    a983:	c3                   	ret    

0000a984 <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    a984:	55                   	push   %ebp
    a985:	89 e5                	mov    %esp,%ebp
    a987:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    a98a:	b8 1b 00 00 00       	mov    $0x1b,%eax
    a98f:	89 c1                	mov    %eax,%ecx
    a991:	0f 32                	rdmsr  
    a993:	89 45 f8             	mov    %eax,-0x8(%ebp)
    a996:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    a999:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a99c:	c1 e0 05             	shl    $0x5,%eax
    a99f:	89 c2                	mov    %eax,%edx
    a9a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a9a4:	01 d0                	add    %edx,%eax
}
    a9a6:	c9                   	leave  
    a9a7:	c3                   	ret    

0000a9a8 <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    a9a8:	55                   	push   %ebp
    a9a9:	89 e5                	mov    %esp,%ebp
    a9ab:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    a9ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    a9b5:	8b 45 08             	mov    0x8(%ebp),%eax
    a9b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a9bd:	80 cc 08             	or     $0x8,%ah
    a9c0:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    a9c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a9c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a9c9:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    a9ce:	0f 30                	wrmsr  
}
    a9d0:	90                   	nop
    a9d1:	c9                   	leave  
    a9d2:	c3                   	ret    

0000a9d3 <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    a9d3:	55                   	push   %ebp
    a9d4:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    a9d6:	8b 15 20 21 01 00    	mov    0x12120,%edx
    a9dc:	8b 45 08             	mov    0x8(%ebp),%eax
    a9df:	01 c0                	add    %eax,%eax
    a9e1:	01 d0                	add    %edx,%eax
    a9e3:	0f b7 00             	movzwl (%eax),%eax
    a9e6:	0f b7 c0             	movzwl %ax,%eax
}
    a9e9:	5d                   	pop    %ebp
    a9ea:	c3                   	ret    

0000a9eb <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    a9eb:	55                   	push   %ebp
    a9ec:	89 e5                	mov    %esp,%ebp
    a9ee:	83 ec 04             	sub    $0x4,%esp
    a9f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    a9f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    a9f8:	8b 15 20 21 01 00    	mov    0x12120,%edx
    a9fe:	8b 45 08             	mov    0x8(%ebp),%eax
    aa01:	01 c0                	add    %eax,%eax
    aa03:	01 c2                	add    %eax,%edx
    aa05:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    aa09:	66 89 02             	mov    %ax,(%edx)
}
    aa0c:	90                   	nop
    aa0d:	c9                   	leave  
    aa0e:	c3                   	ret    

0000aa0f <enable_local_apic>:

void enable_local_apic()
{
    aa0f:	55                   	push   %ebp
    aa10:	89 e5                	mov    %esp,%ebp
    aa12:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    aa15:	83 ec 08             	sub    $0x8,%esp
    aa18:	68 fb 03 00 00       	push   $0x3fb
    aa1d:	68 00 d0 00 00       	push   $0xd000
    aa22:	e8 89 f7 ff ff       	call   a1b0 <create_page_table>
    aa27:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    aa2a:	e8 55 ff ff ff       	call   a984 <get_apic_base>
    aa2f:	a3 20 21 01 00       	mov    %eax,0x12120

    set_apic_base(get_apic_base());
    aa34:	e8 4b ff ff ff       	call   a984 <get_apic_base>
    aa39:	83 ec 0c             	sub    $0xc,%esp
    aa3c:	50                   	push   %eax
    aa3d:	e8 66 ff ff ff       	call   a9a8 <set_apic_base>
    aa42:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    aa45:	83 ec 0c             	sub    $0xc,%esp
    aa48:	68 f0 00 00 00       	push   $0xf0
    aa4d:	e8 81 ff ff ff       	call   a9d3 <cpu_ReadLocalAPICReg>
    aa52:	83 c4 10             	add    $0x10,%esp
    aa55:	80 cc 01             	or     $0x1,%ah
    aa58:	0f b7 c0             	movzwl %ax,%eax
    aa5b:	83 ec 08             	sub    $0x8,%esp
    aa5e:	50                   	push   %eax
    aa5f:	68 f0 00 00 00       	push   $0xf0
    aa64:	e8 82 ff ff ff       	call   a9eb <cpu_SetLocalAPICReg>
    aa69:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    aa6c:	83 ec 08             	sub    $0x8,%esp
    aa6f:	6a 02                	push   $0x2
    aa71:	6a 20                	push   $0x20
    aa73:	e8 73 ff ff ff       	call   a9eb <cpu_SetLocalAPICReg>
    aa78:	83 c4 10             	add    $0x10,%esp
}
    aa7b:	90                   	nop
    aa7c:	c9                   	leave  
    aa7d:	c3                   	ret    

0000aa7e <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    aa7e:	55                   	push   %ebp
    aa7f:	89 e5                	mov    %esp,%ebp
    aa81:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    aa84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    aa8b:	eb 49                	jmp    aad6 <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    aa8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa90:	89 d0                	mov    %edx,%eax
    aa92:	01 c0                	add    %eax,%eax
    aa94:	01 d0                	add    %edx,%eax
    aa96:	c1 e0 02             	shl    $0x2,%eax
    aa99:	05 40 21 01 00       	add    $0x12140,%eax
    aa9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    aaa4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aaa7:	89 d0                	mov    %edx,%eax
    aaa9:	01 c0                	add    %eax,%eax
    aaab:	01 d0                	add    %edx,%eax
    aaad:	c1 e0 02             	shl    $0x2,%eax
    aab0:	05 48 21 01 00       	add    $0x12148,%eax
    aab5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    aabb:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aabe:	89 d0                	mov    %edx,%eax
    aac0:	01 c0                	add    %eax,%eax
    aac2:	01 d0                	add    %edx,%eax
    aac4:	c1 e0 02             	shl    $0x2,%eax
    aac7:	05 44 21 01 00       	add    $0x12144,%eax
    aacc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    aad2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    aad6:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    aadd:	7e ae                	jle    aa8d <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    aadf:	c7 05 40 e1 01 00 40 	movl   $0x12140,0x1e140
    aae6:	21 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    aae9:	90                   	nop
    aaea:	c9                   	leave  
    aaeb:	c3                   	ret    

0000aaec <kmalloc>:

void* kmalloc(uint32_t size)
{
    aaec:	55                   	push   %ebp
    aaed:	89 e5                	mov    %esp,%ebp
    aaef:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    aaf2:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aaf7:	8b 00                	mov    (%eax),%eax
    aaf9:	85 c0                	test   %eax,%eax
    aafb:	75 36                	jne    ab33 <kmalloc+0x47>
        _head_vmm_->address = KERNEL__VM_BASE;
    aafd:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ab02:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ab07:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    ab09:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ab0e:	8b 55 08             	mov    0x8(%ebp),%edx
    ab11:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    ab14:	83 ec 04             	sub    $0x4,%esp
    ab17:	ff 75 08             	pushl  0x8(%ebp)
    ab1a:	6a 00                	push   $0x0
    ab1c:	68 60 e1 01 00       	push   $0x1e160
    ab21:	e8 49 e8 ff ff       	call   936f <memset>
    ab26:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    ab29:	b8 60 e1 01 00       	mov    $0x1e160,%eax
    ab2e:	e9 7b 01 00 00       	jmp    acae <kmalloc+0x1c2>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    ab33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab3a:	eb 04                	jmp    ab40 <kmalloc+0x54>
        i++;
    ab3c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab40:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    ab47:	77 17                	ja     ab60 <kmalloc+0x74>
    ab49:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab4c:	89 d0                	mov    %edx,%eax
    ab4e:	01 c0                	add    %eax,%eax
    ab50:	01 d0                	add    %edx,%eax
    ab52:	c1 e0 02             	shl    $0x2,%eax
    ab55:	05 40 21 01 00       	add    $0x12140,%eax
    ab5a:	8b 00                	mov    (%eax),%eax
    ab5c:	85 c0                	test   %eax,%eax
    ab5e:	75 dc                	jne    ab3c <kmalloc+0x50>

    _new_item_ = &MM_BLOCK[i];
    ab60:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab63:	89 d0                	mov    %edx,%eax
    ab65:	01 c0                	add    %eax,%eax
    ab67:	01 d0                	add    %edx,%eax
    ab69:	c1 e0 02             	shl    $0x2,%eax
    ab6c:	05 40 21 01 00       	add    $0x12140,%eax
    ab71:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    ab74:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ab79:	8b 00                	mov    (%eax),%eax
    ab7b:	b9 60 e1 01 00       	mov    $0x1e160,%ecx
    ab80:	8b 55 08             	mov    0x8(%ebp),%edx
    ab83:	01 ca                	add    %ecx,%edx
    ab85:	39 d0                	cmp    %edx,%eax
    ab87:	74 47                	je     abd0 <kmalloc+0xe4>
        _new_item_->address = KERNEL__VM_BASE;
    ab89:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ab8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab91:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    ab93:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab96:	8b 55 08             	mov    0x8(%ebp),%edx
    ab99:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    ab9c:	8b 15 40 e1 01 00    	mov    0x1e140,%edx
    aba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aba5:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    aba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abab:	a3 40 e1 01 00       	mov    %eax,0x1e140

        memset((void*)_new_item_->address, 0, size);
    abb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abb3:	8b 00                	mov    (%eax),%eax
    abb5:	83 ec 04             	sub    $0x4,%esp
    abb8:	ff 75 08             	pushl  0x8(%ebp)
    abbb:	6a 00                	push   $0x0
    abbd:	50                   	push   %eax
    abbe:	e8 ac e7 ff ff       	call   936f <memset>
    abc3:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    abc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abc9:	8b 00                	mov    (%eax),%eax
    abcb:	e9 de 00 00 00       	jmp    acae <kmalloc+0x1c2>
    }

    tmp = _head_vmm_;
    abd0:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abd5:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    abd8:	eb 27                	jmp    ac01 <kmalloc+0x115>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    abda:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abdd:	8b 40 08             	mov    0x8(%eax),%eax
    abe0:	8b 10                	mov    (%eax),%edx
    abe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abe5:	8b 08                	mov    (%eax),%ecx
    abe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abea:	8b 40 04             	mov    0x4(%eax),%eax
    abed:	01 c1                	add    %eax,%ecx
    abef:	8b 45 08             	mov    0x8(%ebp),%eax
    abf2:	01 c8                	add    %ecx,%eax
    abf4:	39 c2                	cmp    %eax,%edx
    abf6:	73 15                	jae    ac0d <kmalloc+0x121>
            break;

        tmp = tmp->next;
    abf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abfb:	8b 40 08             	mov    0x8(%eax),%eax
    abfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    ac01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac04:	8b 40 08             	mov    0x8(%eax),%eax
    ac07:	85 c0                	test   %eax,%eax
    ac09:	75 cf                	jne    abda <kmalloc+0xee>
    ac0b:	eb 01                	jmp    ac0e <kmalloc+0x122>
            break;
    ac0d:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    ac0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac11:	8b 40 08             	mov    0x8(%eax),%eax
    ac14:	85 c0                	test   %eax,%eax
    ac16:	75 4b                	jne    ac63 <kmalloc+0x177>
        _new_item_->size = size;
    ac18:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac1b:	8b 55 08             	mov    0x8(%ebp),%edx
    ac1e:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ac21:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac24:	8b 10                	mov    (%eax),%edx
    ac26:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac29:	8b 40 04             	mov    0x4(%eax),%eax
    ac2c:	01 c2                	add    %eax,%edx
    ac2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac31:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    ac33:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    ac3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac40:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac43:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac46:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac49:	8b 00                	mov    (%eax),%eax
    ac4b:	83 ec 04             	sub    $0x4,%esp
    ac4e:	ff 75 08             	pushl  0x8(%ebp)
    ac51:	6a 00                	push   $0x0
    ac53:	50                   	push   %eax
    ac54:	e8 16 e7 ff ff       	call   936f <memset>
    ac59:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac5f:	8b 00                	mov    (%eax),%eax
    ac61:	eb 4b                	jmp    acae <kmalloc+0x1c2>
    }

    else {
        _new_item_->size = size;
    ac63:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac66:	8b 55 08             	mov    0x8(%ebp),%edx
    ac69:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ac6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac6f:	8b 10                	mov    (%eax),%edx
    ac71:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac74:	8b 40 04             	mov    0x4(%eax),%eax
    ac77:	01 c2                	add    %eax,%edx
    ac79:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac7c:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    ac7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac81:	8b 50 08             	mov    0x8(%eax),%edx
    ac84:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac87:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    ac8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac90:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac93:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac96:	8b 00                	mov    (%eax),%eax
    ac98:	83 ec 04             	sub    $0x4,%esp
    ac9b:	ff 75 08             	pushl  0x8(%ebp)
    ac9e:	6a 00                	push   $0x0
    aca0:	50                   	push   %eax
    aca1:	e8 c9 e6 ff ff       	call   936f <memset>
    aca6:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    aca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acac:	8b 00                	mov    (%eax),%eax
    }
}
    acae:	c9                   	leave  
    acaf:	c3                   	ret    

0000acb0 <free>:

void free(virtaddr_t _addr__)
{
    acb0:	55                   	push   %ebp
    acb1:	89 e5                	mov    %esp,%ebp
    acb3:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    acb6:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acbb:	8b 00                	mov    (%eax),%eax
    acbd:	39 45 08             	cmp    %eax,0x8(%ebp)
    acc0:	75 29                	jne    aceb <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    acc2:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    accd:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    acd9:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acde:	8b 40 08             	mov    0x8(%eax),%eax
    ace1:	a3 40 e1 01 00       	mov    %eax,0x1e140
        return;
    ace6:	e9 ac 00 00 00       	jmp    ad97 <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    aceb:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acf0:	8b 40 08             	mov    0x8(%eax),%eax
    acf3:	85 c0                	test   %eax,%eax
    acf5:	75 16                	jne    ad0d <free+0x5d>
    acf7:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acfc:	8b 00                	mov    (%eax),%eax
    acfe:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad01:	75 0a                	jne    ad0d <free+0x5d>
        init_vmm();
    ad03:	e8 76 fd ff ff       	call   aa7e <init_vmm>
        return;
    ad08:	e9 8a 00 00 00       	jmp    ad97 <free+0xe7>
    }

    tmp = _head_vmm_;
    ad0d:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ad12:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ad15:	eb 0f                	jmp    ad26 <free+0x76>
        tmp_prev = tmp;
    ad17:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    ad1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad20:	8b 40 08             	mov    0x8(%eax),%eax
    ad23:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ad26:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad29:	8b 40 08             	mov    0x8(%eax),%eax
    ad2c:	85 c0                	test   %eax,%eax
    ad2e:	74 0a                	je     ad3a <free+0x8a>
    ad30:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad33:	8b 00                	mov    (%eax),%eax
    ad35:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad38:	75 dd                	jne    ad17 <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ad3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad3d:	8b 40 08             	mov    0x8(%eax),%eax
    ad40:	85 c0                	test   %eax,%eax
    ad42:	75 29                	jne    ad6d <free+0xbd>
    ad44:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad47:	8b 00                	mov    (%eax),%eax
    ad49:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad4c:	75 1f                	jne    ad6d <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad57:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ad61:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ad6b:	eb 2a                	jmp    ad97 <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ad6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad70:	8b 00                	mov    (%eax),%eax
    ad72:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad75:	75 20                	jne    ad97 <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad77:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad80:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ad8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad8d:	8b 50 08             	mov    0x8(%eax),%edx
    ad90:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad93:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ad96:	90                   	nop
    }
    ad97:	c9                   	leave  
    ad98:	c3                   	ret    

0000ad99 <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ad99:	55                   	push   %ebp
    ad9a:	89 e5                	mov    %esp,%ebp
    ad9c:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ad9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    ada6:	eb 49                	jmp    adf1 <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ada8:	ba db f0 00 00       	mov    $0xf0db,%edx
    adad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adb0:	c1 e0 04             	shl    $0x4,%eax
    adb3:	05 40 f1 01 00       	add    $0x1f140,%eax
    adb8:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    adba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adbd:	c1 e0 04             	shl    $0x4,%eax
    adc0:	05 44 f1 01 00       	add    $0x1f144,%eax
    adc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    adcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adce:	c1 e0 04             	shl    $0x4,%eax
    add1:	05 4c f1 01 00       	add    $0x1f14c,%eax
    add6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    addc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    addf:	c1 e0 04             	shl    $0x4,%eax
    ade2:	05 48 f1 01 00       	add    $0x1f148,%eax
    ade7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    aded:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    adf1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    adf8:	76 ae                	jbe    ada8 <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    adfa:	83 ec 08             	sub    $0x8,%esp
    adfd:	6a 01                	push   $0x1
    adff:	68 00 e0 00 00       	push   $0xe000
    ae04:	e8 a7 f3 ff ff       	call   a1b0 <create_page_table>
    ae09:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    ae0c:	c7 05 20 f1 01 00 40 	movl   $0x1f140,0x1f120
    ae13:	f1 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    ae16:	90                   	nop
    ae17:	c9                   	leave  
    ae18:	c3                   	ret    

0000ae19 <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    ae19:	55                   	push   %ebp
    ae1a:	89 e5                	mov    %esp,%ebp
    ae1c:	53                   	push   %ebx
    ae1d:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    ae20:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae25:	8b 00                	mov    (%eax),%eax
    ae27:	ba db f0 00 00       	mov    $0xf0db,%edx
    ae2c:	39 d0                	cmp    %edx,%eax
    ae2e:	75 40                	jne    ae70 <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    ae30:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae35:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    ae3b:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae40:	8b 55 08             	mov    0x8(%ebp),%edx
    ae43:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    ae46:	8b 45 08             	mov    0x8(%ebp),%eax
    ae49:	c1 e0 0c             	shl    $0xc,%eax
    ae4c:	89 c2                	mov    %eax,%edx
    ae4e:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae53:	8b 00                	mov    (%eax),%eax
    ae55:	83 ec 04             	sub    $0x4,%esp
    ae58:	52                   	push   %edx
    ae59:	6a 00                	push   $0x0
    ae5b:	50                   	push   %eax
    ae5c:	e8 0e e5 ff ff       	call   936f <memset>
    ae61:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    ae64:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae69:	8b 00                	mov    (%eax),%eax
    ae6b:	e9 ae 01 00 00       	jmp    b01e <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    ae70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae77:	eb 04                	jmp    ae7d <alloc_page+0x64>
        i++;
    ae79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae80:	c1 e0 04             	shl    $0x4,%eax
    ae83:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae88:	8b 00                	mov    (%eax),%eax
    ae8a:	ba db f0 00 00       	mov    $0xf0db,%edx
    ae8f:	39 d0                	cmp    %edx,%eax
    ae91:	74 09                	je     ae9c <alloc_page+0x83>
    ae93:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    ae9a:	76 dd                	jbe    ae79 <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    ae9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae9f:	c1 e0 04             	shl    $0x4,%eax
    aea2:	05 40 f1 01 00       	add    $0x1f140,%eax
    aea7:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    aeaa:	a1 20 f1 01 00       	mov    0x1f120,%eax
    aeaf:	8b 00                	mov    (%eax),%eax
    aeb1:	8b 55 08             	mov    0x8(%ebp),%edx
    aeb4:	81 c2 00 01 00 00    	add    $0x100,%edx
    aeba:	c1 e2 0c             	shl    $0xc,%edx
    aebd:	39 d0                	cmp    %edx,%eax
    aebf:	72 4c                	jb     af0d <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    aec1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aec4:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    aeca:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aecd:	8b 55 08             	mov    0x8(%ebp),%edx
    aed0:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    aed3:	8b 15 20 f1 01 00    	mov    0x1f120,%edx
    aed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aedc:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    aedf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aee2:	a3 20 f1 01 00       	mov    %eax,0x1f120

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    aee7:	8b 45 08             	mov    0x8(%ebp),%eax
    aeea:	c1 e0 0c             	shl    $0xc,%eax
    aeed:	89 c2                	mov    %eax,%edx
    aeef:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aef2:	8b 00                	mov    (%eax),%eax
    aef4:	83 ec 04             	sub    $0x4,%esp
    aef7:	52                   	push   %edx
    aef8:	6a 00                	push   $0x0
    aefa:	50                   	push   %eax
    aefb:	e8 6f e4 ff ff       	call   936f <memset>
    af00:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    af03:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af06:	8b 00                	mov    (%eax),%eax
    af08:	e9 11 01 00 00       	jmp    b01e <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    af0d:	a1 20 f1 01 00       	mov    0x1f120,%eax
    af12:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    af15:	eb 2a                	jmp    af41 <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    af17:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af1a:	8b 40 0c             	mov    0xc(%eax),%eax
    af1d:	8b 10                	mov    (%eax),%edx
    af1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af22:	8b 08                	mov    (%eax),%ecx
    af24:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af27:	8b 58 04             	mov    0x4(%eax),%ebx
    af2a:	8b 45 08             	mov    0x8(%ebp),%eax
    af2d:	01 d8                	add    %ebx,%eax
    af2f:	c1 e0 0c             	shl    $0xc,%eax
    af32:	01 c8                	add    %ecx,%eax
    af34:	39 c2                	cmp    %eax,%edx
    af36:	77 15                	ja     af4d <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    af38:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af3b:	8b 40 0c             	mov    0xc(%eax),%eax
    af3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    af41:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af44:	8b 40 0c             	mov    0xc(%eax),%eax
    af47:	85 c0                	test   %eax,%eax
    af49:	75 cc                	jne    af17 <alloc_page+0xfe>
    af4b:	eb 01                	jmp    af4e <alloc_page+0x135>
            break;
    af4d:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    af4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af51:	8b 40 0c             	mov    0xc(%eax),%eax
    af54:	85 c0                	test   %eax,%eax
    af56:	75 5d                	jne    afb5 <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    af58:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af5b:	8b 10                	mov    (%eax),%edx
    af5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af60:	8b 40 04             	mov    0x4(%eax),%eax
    af63:	c1 e0 0c             	shl    $0xc,%eax
    af66:	01 c2                	add    %eax,%edx
    af68:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af6b:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    af6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af70:	8b 55 08             	mov    0x8(%ebp),%edx
    af73:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    af76:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    af80:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af83:	8b 55 f0             	mov    -0x10(%ebp),%edx
    af86:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    af89:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    af8f:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    af92:	8b 45 08             	mov    0x8(%ebp),%eax
    af95:	c1 e0 0c             	shl    $0xc,%eax
    af98:	89 c2                	mov    %eax,%edx
    af9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af9d:	8b 00                	mov    (%eax),%eax
    af9f:	83 ec 04             	sub    $0x4,%esp
    afa2:	52                   	push   %edx
    afa3:	6a 00                	push   $0x0
    afa5:	50                   	push   %eax
    afa6:	e8 c4 e3 ff ff       	call   936f <memset>
    afab:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    afae:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afb1:	8b 00                	mov    (%eax),%eax
    afb3:	eb 69                	jmp    b01e <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    afb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afb8:	8b 10                	mov    (%eax),%edx
    afba:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afbd:	8b 40 04             	mov    0x4(%eax),%eax
    afc0:	c1 e0 0c             	shl    $0xc,%eax
    afc3:	01 c2                	add    %eax,%edx
    afc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afc8:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    afca:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afcd:	8b 55 08             	mov    0x8(%ebp),%edx
    afd0:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    afd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afd6:	8b 50 0c             	mov    0xc(%eax),%edx
    afd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afdc:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    afdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afe2:	8b 55 f0             	mov    -0x10(%ebp),%edx
    afe5:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    afe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afeb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afee:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    aff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aff4:	8b 40 0c             	mov    0xc(%eax),%eax
    aff7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    affa:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    affd:	8b 45 08             	mov    0x8(%ebp),%eax
    b000:	c1 e0 0c             	shl    $0xc,%eax
    b003:	89 c2                	mov    %eax,%edx
    b005:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b008:	8b 00                	mov    (%eax),%eax
    b00a:	83 ec 04             	sub    $0x4,%esp
    b00d:	52                   	push   %edx
    b00e:	6a 00                	push   $0x0
    b010:	50                   	push   %eax
    b011:	e8 59 e3 ff ff       	call   936f <memset>
    b016:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b019:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b01c:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    b01e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    b021:	c9                   	leave  
    b022:	c3                   	ret    

0000b023 <free_page>:

void free_page(_address_order_track_ page)
{
    b023:	55                   	push   %ebp
    b024:	89 e5                	mov    %esp,%ebp
    b026:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    b029:	8b 45 10             	mov    0x10(%ebp),%eax
    b02c:	85 c0                	test   %eax,%eax
    b02e:	75 2d                	jne    b05d <free_page+0x3a>
    b030:	8b 45 14             	mov    0x14(%ebp),%eax
    b033:	85 c0                	test   %eax,%eax
    b035:	74 26                	je     b05d <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    b037:	b8 db f0 00 00       	mov    $0xf0db,%eax
    b03c:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    b03f:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b044:	8b 40 0c             	mov    0xc(%eax),%eax
    b047:	a3 20 f1 01 00       	mov    %eax,0x1f120
        _page_area_track_->previous_ = END_LIST;
    b04c:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b051:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    b058:	e9 13 01 00 00       	jmp    b170 <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    b05d:	8b 45 10             	mov    0x10(%ebp),%eax
    b060:	85 c0                	test   %eax,%eax
    b062:	75 67                	jne    b0cb <free_page+0xa8>
    b064:	8b 45 14             	mov    0x14(%ebp),%eax
    b067:	85 c0                	test   %eax,%eax
    b069:	75 60                	jne    b0cb <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    b06b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    b072:	eb 49                	jmp    b0bd <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    b074:	ba db f0 00 00       	mov    $0xf0db,%edx
    b079:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b07c:	c1 e0 04             	shl    $0x4,%eax
    b07f:	05 40 f1 01 00       	add    $0x1f140,%eax
    b084:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    b086:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b089:	c1 e0 04             	shl    $0x4,%eax
    b08c:	05 44 f1 01 00       	add    $0x1f144,%eax
    b091:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    b097:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b09a:	c1 e0 04             	shl    $0x4,%eax
    b09d:	05 4c f1 01 00       	add    $0x1f14c,%eax
    b0a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    b0a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b0ab:	c1 e0 04             	shl    $0x4,%eax
    b0ae:	05 48 f1 01 00       	add    $0x1f148,%eax
    b0b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    b0b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b0bd:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    b0c4:	76 ae                	jbe    b074 <free_page+0x51>
        }
        return;
    b0c6:	e9 a5 00 00 00       	jmp    b170 <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b0cb:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b0d0:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0d3:	eb 09                	jmp    b0de <free_page+0xbb>
            tmp = tmp->next_;
    b0d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0d8:	8b 40 0c             	mov    0xc(%eax),%eax
    b0db:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0de:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0e1:	8b 10                	mov    (%eax),%edx
    b0e3:	8b 45 08             	mov    0x8(%ebp),%eax
    b0e6:	39 c2                	cmp    %eax,%edx
    b0e8:	74 0a                	je     b0f4 <free_page+0xd1>
    b0ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0ed:	8b 40 0c             	mov    0xc(%eax),%eax
    b0f0:	85 c0                	test   %eax,%eax
    b0f2:	75 e1                	jne    b0d5 <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    b0f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0f7:	8b 40 0c             	mov    0xc(%eax),%eax
    b0fa:	85 c0                	test   %eax,%eax
    b0fc:	75 25                	jne    b123 <free_page+0x100>
    b0fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b101:	8b 10                	mov    (%eax),%edx
    b103:	8b 45 08             	mov    0x8(%ebp),%eax
    b106:	39 c2                	cmp    %eax,%edx
    b108:	75 19                	jne    b123 <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b10a:	ba db f0 00 00       	mov    $0xf0db,%edx
    b10f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b112:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    b114:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b117:	8b 40 08             	mov    0x8(%eax),%eax
    b11a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    b121:	eb 4d                	jmp    b170 <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    b123:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b126:	8b 40 0c             	mov    0xc(%eax),%eax
    b129:	85 c0                	test   %eax,%eax
    b12b:	74 36                	je     b163 <free_page+0x140>
    b12d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b130:	8b 10                	mov    (%eax),%edx
    b132:	8b 45 08             	mov    0x8(%ebp),%eax
    b135:	39 c2                	cmp    %eax,%edx
    b137:	75 2a                	jne    b163 <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b139:	ba db f0 00 00       	mov    $0xf0db,%edx
    b13e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b141:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    b143:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b146:	8b 40 08             	mov    0x8(%eax),%eax
    b149:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b14c:	8b 52 0c             	mov    0xc(%edx),%edx
    b14f:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    b152:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b155:	8b 40 0c             	mov    0xc(%eax),%eax
    b158:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b15b:	8b 52 08             	mov    0x8(%edx),%edx
    b15e:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    b161:	eb 0d                	jmp    b170 <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    b163:	a1 24 f1 01 00       	mov    0x1f124,%eax
    b168:	83 e8 01             	sub    $0x1,%eax
    b16b:	a3 24 f1 01 00       	mov    %eax,0x1f124
    b170:	c9                   	leave  
    b171:	c3                   	ret    

0000b172 <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    b172:	55                   	push   %ebp
    b173:	89 e5                	mov    %esp,%ebp
    b175:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    b178:	a1 48 31 02 00       	mov    0x23148,%eax
    b17d:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    b180:	a1 48 31 02 00       	mov    0x23148,%eax
    b185:	8b 40 3c             	mov    0x3c(%eax),%eax
    b188:	a3 48 31 02 00       	mov    %eax,0x23148

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    b18d:	a1 48 31 02 00       	mov    0x23148,%eax
    b192:	89 c2                	mov    %eax,%edx
    b194:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b197:	83 ec 08             	sub    $0x8,%esp
    b19a:	52                   	push   %edx
    b19b:	50                   	push   %eax
    b19c:	e8 bf 02 00 00       	call   b460 <switch_to_task>
    b1a1:	83 c4 10             	add    $0x10,%esp
}
    b1a4:	90                   	nop
    b1a5:	c9                   	leave  
    b1a6:	c3                   	ret    

0000b1a7 <init_multitasking>:

void init_multitasking()
{
    b1a7:	55                   	push   %ebp
    b1a8:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    b1aa:	c6 05 40 31 02 00 00 	movb   $0x0,0x23140
    sheduler.task_timer = DELAY_PER_TASK;
    b1b1:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    b1b8:	01 00 00 
}
    b1bb:	90                   	nop
    b1bc:	5d                   	pop    %ebp
    b1bd:	c3                   	ret    

0000b1be <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    b1be:	55                   	push   %ebp
    b1bf:	89 e5                	mov    %esp,%ebp
    b1c1:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    b1c4:	8b 45 08             	mov    0x8(%ebp),%eax
    b1c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    b1cd:	8b 45 08             	mov    0x8(%ebp),%eax
    b1d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    b1d7:	8b 45 08             	mov    0x8(%ebp),%eax
    b1da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    b1e1:	8b 45 08             	mov    0x8(%ebp),%eax
    b1e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    b1eb:	8b 45 08             	mov    0x8(%ebp),%eax
    b1ee:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    b1f5:	8b 45 08             	mov    0x8(%ebp),%eax
    b1f8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    b1ff:	8b 45 08             	mov    0x8(%ebp),%eax
    b202:	8b 55 10             	mov    0x10(%ebp),%edx
    b205:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    b208:	8b 55 0c             	mov    0xc(%ebp),%edx
    b20b:	8b 45 08             	mov    0x8(%ebp),%eax
    b20e:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    b211:	8b 45 08             	mov    0x8(%ebp),%eax
    b214:	8b 55 14             	mov    0x14(%ebp),%edx
    b217:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    b21a:	83 ec 0c             	sub    $0xc,%esp
    b21d:	68 c8 00 00 00       	push   $0xc8
    b222:	e8 c5 f8 ff ff       	call   aaec <kmalloc>
    b227:	83 c4 10             	add    $0x10,%esp
    b22a:	89 c2                	mov    %eax,%edx
    b22c:	8b 45 08             	mov    0x8(%ebp),%eax
    b22f:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    b232:	8b 45 08             	mov    0x8(%ebp),%eax
    b235:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b23c:	90                   	nop
    b23d:	c9                   	leave  
    b23e:	c3                   	ret    
    b23f:	90                   	nop

0000b240 <__exception_handler__>:
    b240:	58                   	pop    %eax
    b241:	a3 7c b6 00 00       	mov    %eax,0xb67c
    b246:	e8 4b e4 ff ff       	call   9696 <__exception__>
    b24b:	cf                   	iret   

0000b24c <__exception_no_ERRCODE_handler__>:
    b24c:	e8 4b e4 ff ff       	call   969c <__exception_no_ERRCODE__>
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
    b2d1:	e8 5e ea ff ff       	call   9d34 <irq1_handler>
    b2d6:	61                   	popa   
    b2d7:	cf                   	iret   

0000b2d8 <irq2>:
    b2d8:	60                   	pusha  
    b2d9:	e8 71 ea ff ff       	call   9d4f <irq2_handler>
    b2de:	61                   	popa   
    b2df:	cf                   	iret   

0000b2e0 <irq3>:
    b2e0:	60                   	pusha  
    b2e1:	e8 8c ea ff ff       	call   9d72 <irq3_handler>
    b2e6:	61                   	popa   
    b2e7:	cf                   	iret   

0000b2e8 <irq4>:
    b2e8:	60                   	pusha  
    b2e9:	e8 a7 ea ff ff       	call   9d95 <irq4_handler>
    b2ee:	61                   	popa   
    b2ef:	cf                   	iret   

0000b2f0 <irq5>:
    b2f0:	60                   	pusha  
    b2f1:	e8 c2 ea ff ff       	call   9db8 <irq5_handler>
    b2f6:	61                   	popa   
    b2f7:	cf                   	iret   

0000b2f8 <irq6>:
    b2f8:	60                   	pusha  
    b2f9:	e8 dd ea ff ff       	call   9ddb <irq6_handler>
    b2fe:	61                   	popa   
    b2ff:	cf                   	iret   

0000b300 <irq7>:
    b300:	60                   	pusha  
    b301:	e8 f8 ea ff ff       	call   9dfe <irq7_handler>
    b306:	61                   	popa   
    b307:	cf                   	iret   

0000b308 <irq8>:
    b308:	60                   	pusha  
    b309:	e8 13 eb ff ff       	call   9e21 <irq8_handler>
    b30e:	61                   	popa   
    b30f:	cf                   	iret   

0000b310 <irq9>:
    b310:	60                   	pusha  
    b311:	e8 2e eb ff ff       	call   9e44 <irq9_handler>
    b316:	61                   	popa   
    b317:	cf                   	iret   

0000b318 <irq10>:
    b318:	60                   	pusha  
    b319:	e8 49 eb ff ff       	call   9e67 <irq10_handler>
    b31e:	61                   	popa   
    b31f:	cf                   	iret   

0000b320 <irq11>:
    b320:	60                   	pusha  
    b321:	e8 64 eb ff ff       	call   9e8a <irq11_handler>
    b326:	61                   	popa   
    b327:	cf                   	iret   

0000b328 <irq12>:
    b328:	60                   	pusha  
    b329:	e8 7f eb ff ff       	call   9ead <irq12_handler>
    b32e:	61                   	popa   
    b32f:	cf                   	iret   

0000b330 <irq13>:
    b330:	60                   	pusha  
    b331:	e8 9a eb ff ff       	call   9ed0 <irq13_handler>
    b336:	61                   	popa   
    b337:	cf                   	iret   

0000b338 <irq14>:
    b338:	60                   	pusha  
    b339:	e8 b5 eb ff ff       	call   9ef3 <irq14_handler>
    b33e:	61                   	popa   
    b33f:	cf                   	iret   

0000b340 <irq15>:
    b340:	60                   	pusha  
    b341:	e8 d0 eb ff ff       	call   9f16 <irq15_handler>
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
    b370:	e8 19 f0 ff ff       	call   a38e <Paging_fault>
    b375:	cf                   	iret   
    b376:	66 90                	xchg   %ax,%ax
    b378:	66 90                	xchg   %ax,%ax
    b37a:	66 90                	xchg   %ax,%ax
    b37c:	66 90                	xchg   %ax,%ax
    b37e:	66 90                	xchg   %ax,%ax

0000b380 <PIT_handler>:
    b380:	9c                   	pushf  
    b381:	e8 16 00 00 00       	call   b39c <irq_PIT>
    b386:	e8 4a f2 ff ff       	call   a5d5 <conserv_status_byte>
    b38b:	e8 e1 f2 ff ff       	call   a671 <sheduler_cpu_timer>
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
    b3b5:	e8 da ef ff ff       	call   a394 <PIC_sendEOI>
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
