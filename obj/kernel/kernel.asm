
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
    9665:	e8 1f 0b 00 00       	call   a189 <get_ASCII_code_keyboard>
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
    97c6:	e8 8b 1a 00 00       	call   b256 <load_gdt>
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
    9875:	e8 1c 0e 00 00       	call   a696 <Init_PIT>
    987a:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    987d:	83 ec 08             	sub    $0x8,%esp
    9880:	6a 28                	push   $0x28
    9882:	6a 20                	push   $0x20
    9884:	e8 20 0b 00 00       	call   a3a9 <PIC_remap>
    9889:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    988c:	b8 70 b3 00 00       	mov    $0xb370,%eax
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
    98ac:	b8 c0 b2 00 00       	mov    $0xb2c0,%eax
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
    98cc:	b8 c8 b2 00 00       	mov    $0xb2c8,%eax
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
    98ec:	b8 d0 b2 00 00       	mov    $0xb2d0,%eax
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
    990c:	b8 d8 b2 00 00       	mov    $0xb2d8,%eax
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
    992c:	b8 e0 b2 00 00       	mov    $0xb2e0,%eax
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
    994c:	b8 e8 b2 00 00       	mov    $0xb2e8,%eax
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
    996c:	b8 f0 b2 00 00       	mov    $0xb2f0,%eax
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
    998c:	b8 f8 b2 00 00       	mov    $0xb2f8,%eax
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
    99ac:	b8 00 b3 00 00       	mov    $0xb300,%eax
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
    99cc:	b8 08 b3 00 00       	mov    $0xb308,%eax
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
    99ec:	b8 10 b3 00 00       	mov    $0xb310,%eax
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
    9a0c:	b8 18 b3 00 00       	mov    $0xb318,%eax
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
    9a2c:	b8 20 b3 00 00       	mov    $0xb320,%eax
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
    9a4c:	b8 28 b3 00 00       	mov    $0xb328,%eax
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
    9a6c:	b8 30 b3 00 00       	mov    $0xb330,%eax
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
    9a8c:	b8 30 b2 00 00       	mov    $0xb230,%eax
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
    9aac:	b8 30 b2 00 00       	mov    $0xb230,%eax
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
    9acc:	b8 30 b2 00 00       	mov    $0xb230,%eax
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
    9aec:	b8 30 b2 00 00       	mov    $0xb230,%eax
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
    9b0c:	b8 30 b2 00 00       	mov    $0xb230,%eax
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
    9b2c:	b8 78 a3 00 00       	mov    $0xa378,%eax
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
    9b4c:	b8 30 b2 00 00       	mov    $0xb230,%eax
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
    9b6c:	b8 30 b2 00 00       	mov    $0xb230,%eax
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
    9d2c:	e8 5e 15 00 00       	call   b28f <load_idt>
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
    9d44:	e8 35 06 00 00       	call   a37e <PIC_sendEOI>
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
    9d5a:	e8 2b 08 00 00       	call   a58a <spurious_IRQ>
    9d5f:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9d62:	83 ec 0c             	sub    $0xc,%esp
    9d65:	6a 02                	push   $0x2
    9d67:	e8 12 06 00 00       	call   a37e <PIC_sendEOI>
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
    9d7d:	e8 08 08 00 00       	call   a58a <spurious_IRQ>
    9d82:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9d85:	83 ec 0c             	sub    $0xc,%esp
    9d88:	6a 03                	push   $0x3
    9d8a:	e8 ef 05 00 00       	call   a37e <PIC_sendEOI>
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
    9da0:	e8 e5 07 00 00       	call   a58a <spurious_IRQ>
    9da5:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9da8:	83 ec 0c             	sub    $0xc,%esp
    9dab:	6a 04                	push   $0x4
    9dad:	e8 cc 05 00 00       	call   a37e <PIC_sendEOI>
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
    9dc3:	e8 c2 07 00 00       	call   a58a <spurious_IRQ>
    9dc8:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9dcb:	83 ec 0c             	sub    $0xc,%esp
    9dce:	6a 05                	push   $0x5
    9dd0:	e8 a9 05 00 00       	call   a37e <PIC_sendEOI>
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
    9de6:	e8 9f 07 00 00       	call   a58a <spurious_IRQ>
    9deb:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9dee:	83 ec 0c             	sub    $0xc,%esp
    9df1:	6a 06                	push   $0x6
    9df3:	e8 86 05 00 00       	call   a37e <PIC_sendEOI>
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
    9e09:	e8 7c 07 00 00       	call   a58a <spurious_IRQ>
    9e0e:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9e11:	83 ec 0c             	sub    $0xc,%esp
    9e14:	6a 07                	push   $0x7
    9e16:	e8 63 05 00 00       	call   a37e <PIC_sendEOI>
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
    9e2c:	e8 59 07 00 00       	call   a58a <spurious_IRQ>
    9e31:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9e34:	83 ec 0c             	sub    $0xc,%esp
    9e37:	6a 08                	push   $0x8
    9e39:	e8 40 05 00 00       	call   a37e <PIC_sendEOI>
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
    9e4f:	e8 36 07 00 00       	call   a58a <spurious_IRQ>
    9e54:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9e57:	83 ec 0c             	sub    $0xc,%esp
    9e5a:	6a 09                	push   $0x9
    9e5c:	e8 1d 05 00 00       	call   a37e <PIC_sendEOI>
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
    9e72:	e8 13 07 00 00       	call   a58a <spurious_IRQ>
    9e77:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9e7a:	83 ec 0c             	sub    $0xc,%esp
    9e7d:	6a 0a                	push   $0xa
    9e7f:	e8 fa 04 00 00       	call   a37e <PIC_sendEOI>
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
    9e95:	e8 f0 06 00 00       	call   a58a <spurious_IRQ>
    9e9a:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9e9d:	83 ec 0c             	sub    $0xc,%esp
    9ea0:	6a 0b                	push   $0xb
    9ea2:	e8 d7 04 00 00       	call   a37e <PIC_sendEOI>
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
    9eb8:	e8 cd 06 00 00       	call   a58a <spurious_IRQ>
    9ebd:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9ec0:	83 ec 0c             	sub    $0xc,%esp
    9ec3:	6a 0c                	push   $0xc
    9ec5:	e8 b4 04 00 00       	call   a37e <PIC_sendEOI>
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
    9edb:	e8 aa 06 00 00       	call   a58a <spurious_IRQ>
    9ee0:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9ee3:	83 ec 0c             	sub    $0xc,%esp
    9ee6:	6a 0d                	push   $0xd
    9ee8:	e8 91 04 00 00       	call   a37e <PIC_sendEOI>
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
    9efe:	e8 87 06 00 00       	call   a58a <spurious_IRQ>
    9f03:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9f06:	83 ec 0c             	sub    $0xc,%esp
    9f09:	6a 0e                	push   $0xe
    9f0b:	e8 6e 04 00 00       	call   a37e <PIC_sendEOI>
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
    9f21:	e8 64 06 00 00       	call   a58a <spurious_IRQ>
    9f26:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    9f29:	83 ec 0c             	sub    $0xc,%esp
    9f2c:	6a 0f                	push   $0xf
    9f2e:	e8 4b 04 00 00       	call   a37e <PIC_sendEOI>
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
    9f79:	68 c9 a8 00 00       	push   $0xa8c9
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

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9fca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9fd1:	eb 16                	jmp    9fe9 <keyboard_irq+0x60>
        func = keyboard_ctrl.kbd_service[i];
    9fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9fd6:	8b 04 85 22 08 01 00 	mov    0x10822(,%eax,4),%eax
    9fdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
        func();
    9fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9fe3:	ff d0                	call   *%eax
    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9fe5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9fe9:	0f b6 05 21 08 01 00 	movzbl 0x10821,%eax
    9ff0:	0f be c0             	movsbl %al,%eax
    9ff3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    9ff6:	7c db                	jl     9fd3 <keyboard_irq+0x4a>
    }
}
    9ff8:	90                   	nop
    9ff9:	90                   	nop
    9ffa:	c9                   	leave  
    9ffb:	c3                   	ret    

00009ffc <reinitialise_kbd>:

void reinitialise_kbd()
{
    9ffc:	55                   	push   %ebp
    9ffd:	89 e5                	mov    %esp,%ebp
    9fff:	83 ec 08             	sub    $0x8,%esp
    wait_8042_ACK();
    a002:	e8 43 00 00 00       	call   a04a <wait_8042_ACK>
    _8042_send_get_current_scan_code;
    a007:	ba 64 00 00 00       	mov    $0x64,%edx
    a00c:	b8 f0 00 00 00       	mov    $0xf0,%eax
    a011:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a012:	e8 33 00 00 00       	call   a04a <wait_8042_ACK>

    _8042_set_typematic_rate;
    a017:	ba 64 00 00 00       	mov    $0x64,%edx
    a01c:	b8 f3 00 00 00       	mov    $0xf3,%eax
    a021:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a022:	e8 23 00 00 00       	call   a04a <wait_8042_ACK>

    _8042_set_leds;
    a027:	ba 64 00 00 00       	mov    $0x64,%edx
    a02c:	b8 ed 00 00 00       	mov    $0xed,%eax
    a031:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a032:	e8 13 00 00 00       	call   a04a <wait_8042_ACK>

    _8042_enable_scanning;
    a037:	ba 64 00 00 00       	mov    $0x64,%edx
    a03c:	b8 f4 00 00 00       	mov    $0xf4,%eax
    a041:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a042:	e8 03 00 00 00       	call   a04a <wait_8042_ACK>
}
    a047:	90                   	nop
    a048:	c9                   	leave  
    a049:	c3                   	ret    

0000a04a <wait_8042_ACK>:

static void
wait_8042_ACK()
{
    a04a:	55                   	push   %ebp
    a04b:	89 e5                	mov    %esp,%ebp
    a04d:	83 ec 10             	sub    $0x10,%esp
    while (_8042_get_status != _8042_ACK)
    a050:	90                   	nop
    a051:	b8 64 00 00 00       	mov    $0x64,%eax
    a056:	89 c2                	mov    %eax,%edx
    a058:	ec                   	in     (%dx),%al
    a059:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a05d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a061:	66 3d fa 00          	cmp    $0xfa,%ax
    a065:	75 ea                	jne    a051 <wait_8042_ACK+0x7>
        ;
}
    a067:	90                   	nop
    a068:	90                   	nop
    a069:	c9                   	leave  
    a06a:	c3                   	ret    

0000a06b <get_code_kbd_control>:

int16_t get_code_kbd_control()
{
    a06b:	55                   	push   %ebp
    a06c:	89 e5                	mov    %esp,%ebp
    return keyboard_ctrl.code;
    a06e:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
}
    a075:	5d                   	pop    %ebp
    a076:	c3                   	ret    

0000a077 <handle_ASCII_code_keyboard>:

static void handle_ASCII_code_keyboard()
{
    a077:	55                   	push   %ebp
    a078:	89 e5                	mov    %esp,%ebp
    a07a:	83 ec 10             	sub    $0x10,%esp
    int16_t        _code = keyboard_ctrl.code - 1;
    a07d:	0f b7 05 1e 0c 01 00 	movzwl 0x10c1e,%eax
    a084:	83 e8 01             	sub    $0x1,%eax
    a087:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    static int16_t lshift_enable;
    static int16_t rshift_enable;
    static int16_t alt_enable;
    static int16_t ctrl_enable;

    if (_code < 0x80) { /* key held down */
    a08b:	66 83 7d fe 7f       	cmpw   $0x7f,-0x2(%ebp)
    a090:	0f 8f 99 00 00 00    	jg     a12f <handle_ASCII_code_keyboard+0xb8>
        switch (_code) {
    a096:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a09a:	83 f8 37             	cmp    $0x37,%eax
    a09d:	74 43                	je     a0e2 <handle_ASCII_code_keyboard+0x6b>
    a09f:	83 f8 37             	cmp    $0x37,%eax
    a0a2:	7f 4c                	jg     a0f0 <handle_ASCII_code_keyboard+0x79>
    a0a4:	83 f8 35             	cmp    $0x35,%eax
    a0a7:	74 1d                	je     a0c6 <handle_ASCII_code_keyboard+0x4f>
    a0a9:	83 f8 35             	cmp    $0x35,%eax
    a0ac:	7f 42                	jg     a0f0 <handle_ASCII_code_keyboard+0x79>
    a0ae:	83 f8 1c             	cmp    $0x1c,%eax
    a0b1:	74 21                	je     a0d4 <handle_ASCII_code_keyboard+0x5d>
    a0b3:	83 f8 29             	cmp    $0x29,%eax
    a0b6:	75 38                	jne    a0f0 <handle_ASCII_code_keyboard+0x79>
        case 0x29: lshift_enable = 1; break;
    a0b8:	66 c7 05 20 0c 01 00 	movw   $0x1,0x10c20
    a0bf:	01 00 
    a0c1:	e9 c1 00 00 00       	jmp    a187 <handle_ASCII_code_keyboard+0x110>
        case 0x35: rshift_enable = 1; break;
    a0c6:	66 c7 05 22 0c 01 00 	movw   $0x1,0x10c22
    a0cd:	01 00 
    a0cf:	e9 b3 00 00 00       	jmp    a187 <handle_ASCII_code_keyboard+0x110>
        case 0x1C: ctrl_enable = 1; break;
    a0d4:	66 c7 05 24 0c 01 00 	movw   $0x1,0x10c24
    a0db:	01 00 
    a0dd:	e9 a5 00 00 00       	jmp    a187 <handle_ASCII_code_keyboard+0x110>
        case 0x37: alt_enable = 1; break;
    a0e2:	66 c7 05 26 0c 01 00 	movw   $0x1,0x10c26
    a0e9:	01 00 
    a0eb:	e9 97 00 00 00       	jmp    a187 <handle_ASCII_code_keyboard+0x110>
        default:
            keyboard_ctrl.ascii_code_keyboard = kbdmap[_code * 4 + (lshift_enable || rshift_enable)];
    a0f0:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a0f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a0fb:	0f b7 05 20 0c 01 00 	movzwl 0x10c20,%eax
    a102:	66 85 c0             	test   %ax,%ax
    a105:	75 0c                	jne    a113 <handle_ASCII_code_keyboard+0x9c>
    a107:	0f b7 05 22 0c 01 00 	movzwl 0x10c22,%eax
    a10e:	66 85 c0             	test   %ax,%ax
    a111:	74 07                	je     a11a <handle_ASCII_code_keyboard+0xa3>
    a113:	b8 01 00 00 00       	mov    $0x1,%eax
    a118:	eb 05                	jmp    a11f <handle_ASCII_code_keyboard+0xa8>
    a11a:	b8 00 00 00 00       	mov    $0x0,%eax
    a11f:	01 d0                	add    %edx,%eax
    a121:	0f b6 80 e0 b4 00 00 	movzbl 0xb4e0(%eax),%eax
    a128:	a2 20 08 01 00       	mov    %al,0x10820
            return;
    a12d:	eb 58                	jmp    a187 <handle_ASCII_code_keyboard+0x110>
        }
    } else {
        _code -= 0x80;
    a12f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a133:	83 c0 80             	add    $0xffffff80,%eax
    a136:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
        switch (_code) {
    a13a:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a13e:	83 f8 37             	cmp    $0x37,%eax
    a141:	74 3a                	je     a17d <handle_ASCII_code_keyboard+0x106>
    a143:	83 f8 37             	cmp    $0x37,%eax
    a146:	7f 3f                	jg     a187 <handle_ASCII_code_keyboard+0x110>
    a148:	83 f8 35             	cmp    $0x35,%eax
    a14b:	74 1a                	je     a167 <handle_ASCII_code_keyboard+0xf0>
    a14d:	83 f8 35             	cmp    $0x35,%eax
    a150:	7f 35                	jg     a187 <handle_ASCII_code_keyboard+0x110>
    a152:	83 f8 1c             	cmp    $0x1c,%eax
    a155:	74 1b                	je     a172 <handle_ASCII_code_keyboard+0xfb>
    a157:	83 f8 29             	cmp    $0x29,%eax
    a15a:	75 2b                	jne    a187 <handle_ASCII_code_keyboard+0x110>
        case 0x29: lshift_enable = 0; break;
    a15c:	66 c7 05 20 0c 01 00 	movw   $0x0,0x10c20
    a163:	00 00 
    a165:	eb 20                	jmp    a187 <handle_ASCII_code_keyboard+0x110>
        case 0x35: rshift_enable = 0; break;
    a167:	66 c7 05 22 0c 01 00 	movw   $0x0,0x10c22
    a16e:	00 00 
    a170:	eb 15                	jmp    a187 <handle_ASCII_code_keyboard+0x110>
        case 0x1C: ctrl_enable = 0; break;
    a172:	66 c7 05 24 0c 01 00 	movw   $0x0,0x10c24
    a179:	00 00 
    a17b:	eb 0a                	jmp    a187 <handle_ASCII_code_keyboard+0x110>
        case 0x37: alt_enable = 0; break;
    a17d:	66 c7 05 26 0c 01 00 	movw   $0x0,0x10c26
    a184:	00 00 
    a186:	90                   	nop
        }
    }
}
    a187:	c9                   	leave  
    a188:	c3                   	ret    

0000a189 <get_ASCII_code_keyboard>:

int8_t get_ASCII_code_keyboard()
{
    a189:	55                   	push   %ebp
    a18a:	89 e5                	mov    %esp,%ebp
    handle_ASCII_code_keyboard();
    a18c:	e8 e6 fe ff ff       	call   a077 <handle_ASCII_code_keyboard>
    return keyboard_ctrl.ascii_code_keyboard;
    a191:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    a198:	5d                   	pop    %ebp
    a199:	c3                   	ret    

0000a19a <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    a19a:	55                   	push   %ebp
    a19b:	89 e5                	mov    %esp,%ebp
    a19d:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a1a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a1a7:	eb 20                	jmp    a1c9 <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a1a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1ac:	c1 e0 0c             	shl    $0xc,%eax
    a1af:	89 c2                	mov    %eax,%edx
    a1b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1b4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a1bb:	8b 45 08             	mov    0x8(%ebp),%eax
    a1be:	01 c8                	add    %ecx,%eax
    a1c0:	83 ca 23             	or     $0x23,%edx
    a1c3:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a1c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a1c9:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a1d0:	76 d7                	jbe    a1a9 <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    a1d2:	8b 45 08             	mov    0x8(%ebp),%eax
    a1d5:	83 c8 23             	or     $0x23,%eax
    a1d8:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    a1da:	8b 45 0c             	mov    0xc(%ebp),%eax
    a1dd:	89 14 85 00 10 01 00 	mov    %edx,0x11000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    a1e4:	e8 57 11 00 00       	call   b340 <_FlushPagingCache_>
}
    a1e9:	90                   	nop
    a1ea:	c9                   	leave  
    a1eb:	c3                   	ret    

0000a1ec <init_paging>:

void init_paging()
{
    a1ec:	55                   	push   %ebp
    a1ed:	89 e5                	mov    %esp,%ebp
    a1ef:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    a1f2:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a1f8:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    a1fe:	eb 1a                	jmp    a21a <init_paging+0x2e>
        page_directory[i] =
    a200:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a204:	c7 04 85 00 10 01 00 	movl   $0x2,0x11000(,%eax,4)
    a20b:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a20f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a213:	83 c0 01             	add    $0x1,%eax
    a216:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a21a:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a220:	76 de                	jbe    a200 <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a222:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    a228:	eb 22                	jmp    a24c <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a22a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a22e:	c1 e0 0c             	shl    $0xc,%eax
    a231:	83 c8 23             	or     $0x23,%eax
    a234:	89 c2                	mov    %eax,%edx
    a236:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a23a:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a241:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a245:	83 c0 01             	add    $0x1,%eax
    a248:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a24c:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a252:	76 d6                	jbe    a22a <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    a254:	b8 00 c0 00 00       	mov    $0xc000,%eax
    a259:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    a25c:	a3 00 10 01 00       	mov    %eax,0x11000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    a261:	e8 e3 10 00 00       	call   b349 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    a266:	90                   	nop
    a267:	c9                   	leave  
    a268:	c3                   	ret    

0000a269 <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    a269:	55                   	push   %ebp
    a26a:	89 e5                	mov    %esp,%ebp
    a26c:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    a26f:	8b 45 08             	mov    0x8(%ebp),%eax
    a272:	c1 e8 16             	shr    $0x16,%eax
    a275:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    a278:	8b 45 08             	mov    0x8(%ebp),%eax
    a27b:	c1 e8 0c             	shr    $0xc,%eax
    a27e:	25 ff 03 00 00       	and    $0x3ff,%eax
    a283:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a286:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a289:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a290:	83 e0 23             	and    $0x23,%eax
    a293:	83 f8 23             	cmp    $0x23,%eax
    a296:	75 56                	jne    a2ee <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a298:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a29b:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a2a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a2a7:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a2aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a2ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a2b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a2b7:	01 d0                	add    %edx,%eax
    a2b9:	8b 00                	mov    (%eax),%eax
    a2bb:	83 e0 23             	and    $0x23,%eax
    a2be:	83 f8 23             	cmp    $0x23,%eax
    a2c1:	75 24                	jne    a2e7 <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a2c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a2c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a2d0:	01 d0                	add    %edx,%eax
    a2d2:	8b 00                	mov    (%eax),%eax
    a2d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a2d9:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    a2db:	8b 45 08             	mov    0x8(%ebp),%eax
    a2de:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a2e3:	09 d0                	or     %edx,%eax
    a2e5:	eb 0c                	jmp    a2f3 <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    a2e7:	b8 70 f0 00 00       	mov    $0xf070,%eax
    a2ec:	eb 05                	jmp    a2f3 <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    a2ee:	b8 70 f0 00 00       	mov    $0xf070,%eax
}
    a2f3:	c9                   	leave  
    a2f4:	c3                   	ret    

0000a2f5 <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    a2f5:	55                   	push   %ebp
    a2f6:	89 e5                	mov    %esp,%ebp
    a2f8:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    a2fb:	8b 45 08             	mov    0x8(%ebp),%eax
    a2fe:	c1 e8 16             	shr    $0x16,%eax
    a301:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    a304:	8b 45 08             	mov    0x8(%ebp),%eax
    a307:	c1 e8 0c             	shr    $0xc,%eax
    a30a:	25 ff 03 00 00       	and    $0x3ff,%eax
    a30f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a312:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a315:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a31c:	83 e0 23             	and    $0x23,%eax
    a31f:	83 f8 23             	cmp    $0x23,%eax
    a322:	75 4e                	jne    a372 <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a324:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a327:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a32e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a333:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a336:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a340:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a343:	01 d0                	add    %edx,%eax
    a345:	8b 00                	mov    (%eax),%eax
    a347:	83 e0 23             	and    $0x23,%eax
    a34a:	83 f8 23             	cmp    $0x23,%eax
    a34d:	74 26                	je     a375 <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a34f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a352:	c1 e0 0c             	shl    $0xc,%eax
    a355:	89 c2                	mov    %eax,%edx
    a357:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a35a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a361:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a364:	01 c8                	add    %ecx,%eax
    a366:	83 ca 23             	or     $0x23,%edx
    a369:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a36b:	e8 d0 0f 00 00       	call   b340 <_FlushPagingCache_>
    a370:	eb 04                	jmp    a376 <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a372:	90                   	nop
    a373:	eb 01                	jmp    a376 <map_linear_address+0x81>
            return; // the linear address was already mapped
    a375:	90                   	nop
}
    a376:	c9                   	leave  
    a377:	c3                   	ret    

0000a378 <Paging_fault>:

void Paging_fault()
{
    a378:	55                   	push   %ebp
    a379:	89 e5                	mov    %esp,%ebp
}
    a37b:	90                   	nop
    a37c:	5d                   	pop    %ebp
    a37d:	c3                   	ret    

0000a37e <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a37e:	55                   	push   %ebp
    a37f:	89 e5                	mov    %esp,%ebp
    a381:	83 ec 04             	sub    $0x4,%esp
    a384:	8b 45 08             	mov    0x8(%ebp),%eax
    a387:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a38a:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a38e:	76 0b                	jbe    a39b <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a390:	ba a0 00 00 00       	mov    $0xa0,%edx
    a395:	b8 20 00 00 00       	mov    $0x20,%eax
    a39a:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a39b:	ba 20 00 00 00       	mov    $0x20,%edx
    a3a0:	b8 20 00 00 00       	mov    $0x20,%eax
    a3a5:	ee                   	out    %al,(%dx)
}
    a3a6:	90                   	nop
    a3a7:	c9                   	leave  
    a3a8:	c3                   	ret    

0000a3a9 <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a3a9:	55                   	push   %ebp
    a3aa:	89 e5                	mov    %esp,%ebp
    a3ac:	83 ec 18             	sub    $0x18,%esp
    a3af:	8b 55 08             	mov    0x8(%ebp),%edx
    a3b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    a3b5:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a3b8:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a3bb:	b8 21 00 00 00       	mov    $0x21,%eax
    a3c0:	89 c2                	mov    %eax,%edx
    a3c2:	ec                   	in     (%dx),%al
    a3c3:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a3c7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a3cb:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2 = inb(PIC2_DATA);
    a3ce:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a3d3:	89 c2                	mov    %eax,%edx
    a3d5:	ec                   	in     (%dx),%al
    a3d6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a3da:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a3de:	88 45 f9             	mov    %al,-0x7(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a3e1:	ba 20 00 00 00       	mov    $0x20,%edx
    a3e6:	b8 11 00 00 00       	mov    $0x11,%eax
    a3eb:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a3ec:	eb 00                	jmp    a3ee <PIC_remap+0x45>
    a3ee:	eb 00                	jmp    a3f0 <PIC_remap+0x47>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a3f0:	ba a0 00 00 00       	mov    $0xa0,%edx
    a3f5:	b8 11 00 00 00       	mov    $0x11,%eax
    a3fa:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a3fb:	eb 00                	jmp    a3fd <PIC_remap+0x54>
    a3fd:	eb 00                	jmp    a3ff <PIC_remap+0x56>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a3ff:	ba 21 00 00 00       	mov    $0x21,%edx
    a404:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a408:	ee                   	out    %al,(%dx)
    io_wait;
    a409:	eb 00                	jmp    a40b <PIC_remap+0x62>
    a40b:	eb 00                	jmp    a40d <PIC_remap+0x64>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a40d:	ba a1 00 00 00       	mov    $0xa1,%edx
    a412:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a416:	ee                   	out    %al,(%dx)
    io_wait;
    a417:	eb 00                	jmp    a419 <PIC_remap+0x70>
    a419:	eb 00                	jmp    a41b <PIC_remap+0x72>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a41b:	ba 21 00 00 00       	mov    $0x21,%edx
    a420:	b8 04 00 00 00       	mov    $0x4,%eax
    a425:	ee                   	out    %al,(%dx)
    io_wait;
    a426:	eb 00                	jmp    a428 <PIC_remap+0x7f>
    a428:	eb 00                	jmp    a42a <PIC_remap+0x81>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a42a:	ba a1 00 00 00       	mov    $0xa1,%edx
    a42f:	b8 02 00 00 00       	mov    $0x2,%eax
    a434:	ee                   	out    %al,(%dx)
    io_wait;
    a435:	eb 00                	jmp    a437 <PIC_remap+0x8e>
    a437:	eb 00                	jmp    a439 <PIC_remap+0x90>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a439:	ba 21 00 00 00       	mov    $0x21,%edx
    a43e:	b8 01 00 00 00       	mov    $0x1,%eax
    a443:	ee                   	out    %al,(%dx)
    io_wait;
    a444:	eb 00                	jmp    a446 <PIC_remap+0x9d>
    a446:	eb 00                	jmp    a448 <PIC_remap+0x9f>

    outb(PIC2_DATA, ICW4_8086);
    a448:	ba a1 00 00 00       	mov    $0xa1,%edx
    a44d:	b8 01 00 00 00       	mov    $0x1,%eax
    a452:	ee                   	out    %al,(%dx)
    io_wait;
    a453:	eb 00                	jmp    a455 <PIC_remap+0xac>
    a455:	eb 00                	jmp    a457 <PIC_remap+0xae>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a457:	ba 21 00 00 00       	mov    $0x21,%edx
    a45c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a460:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a461:	ba a1 00 00 00       	mov    $0xa1,%edx
    a466:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a46a:	ee                   	out    %al,(%dx)
}
    a46b:	90                   	nop
    a46c:	c9                   	leave  
    a46d:	c3                   	ret    

0000a46e <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a46e:	55                   	push   %ebp
    a46f:	89 e5                	mov    %esp,%ebp
    a471:	53                   	push   %ebx
    a472:	83 ec 14             	sub    $0x14,%esp
    a475:	8b 45 08             	mov    0x8(%ebp),%eax
    a478:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a47b:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a47f:	77 08                	ja     a489 <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a481:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a487:	eb 0a                	jmp    a493 <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a489:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a48f:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a493:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a497:	89 c2                	mov    %eax,%edx
    a499:	ec                   	in     (%dx),%al
    a49a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a49e:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a4a2:	89 c3                	mov    %eax,%ebx
    a4a4:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a4a8:	ba 01 00 00 00       	mov    $0x1,%edx
    a4ad:	89 c1                	mov    %eax,%ecx
    a4af:	d3 e2                	shl    %cl,%edx
    a4b1:	89 d0                	mov    %edx,%eax
    a4b3:	09 d8                	or     %ebx,%eax
    a4b5:	88 45 f7             	mov    %al,-0x9(%ebp)

    outb(port, value);
    a4b8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a4bc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a4c0:	ee                   	out    %al,(%dx)
}
    a4c1:	90                   	nop
    a4c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a4c5:	c9                   	leave  
    a4c6:	c3                   	ret    

0000a4c7 <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a4c7:	55                   	push   %ebp
    a4c8:	89 e5                	mov    %esp,%ebp
    a4ca:	53                   	push   %ebx
    a4cb:	83 ec 14             	sub    $0x14,%esp
    a4ce:	8b 45 08             	mov    0x8(%ebp),%eax
    a4d1:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a4d4:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a4d8:	77 09                	ja     a4e3 <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a4da:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a4e1:	eb 0b                	jmp    a4ee <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a4e3:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a4ea:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a4ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a4f1:	89 c2                	mov    %eax,%edx
    a4f3:	ec                   	in     (%dx),%al
    a4f4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a4f8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a4fc:	89 c3                	mov    %eax,%ebx
    a4fe:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a502:	ba 01 00 00 00       	mov    $0x1,%edx
    a507:	89 c1                	mov    %eax,%ecx
    a509:	d3 e2                	shl    %cl,%edx
    a50b:	89 d0                	mov    %edx,%eax
    a50d:	f7 d0                	not    %eax
    a50f:	21 d8                	and    %ebx,%eax
    a511:	88 45 f5             	mov    %al,-0xb(%ebp)

    outb(port, value);
    a514:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a517:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a51b:	ee                   	out    %al,(%dx)
}
    a51c:	90                   	nop
    a51d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a520:	c9                   	leave  
    a521:	c3                   	ret    

0000a522 <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a522:	55                   	push   %ebp
    a523:	89 e5                	mov    %esp,%ebp
    a525:	83 ec 14             	sub    $0x14,%esp
    a528:	8b 45 08             	mov    0x8(%ebp),%eax
    a52b:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a52e:	ba 20 00 00 00       	mov    $0x20,%edx
    a533:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a537:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a538:	ba a0 00 00 00       	mov    $0xa0,%edx
    a53d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a541:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a542:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a547:	89 c2                	mov    %eax,%edx
    a549:	ec                   	in     (%dx),%al
    a54a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a54e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a552:	98                   	cwtl   
    a553:	c1 e0 08             	shl    $0x8,%eax
    a556:	89 c1                	mov    %eax,%ecx
    a558:	b8 20 00 00 00       	mov    $0x20,%eax
    a55d:	89 c2                	mov    %eax,%edx
    a55f:	ec                   	in     (%dx),%al
    a560:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a564:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a568:	09 c8                	or     %ecx,%eax
}
    a56a:	c9                   	leave  
    a56b:	c3                   	ret    

0000a56c <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a56c:	55                   	push   %ebp
    a56d:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a56f:	6a 0b                	push   $0xb
    a571:	e8 ac ff ff ff       	call   a522 <__pic_get_irq_reg>
    a576:	83 c4 04             	add    $0x4,%esp
}
    a579:	c9                   	leave  
    a57a:	c3                   	ret    

0000a57b <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a57b:	55                   	push   %ebp
    a57c:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a57e:	6a 0a                	push   $0xa
    a580:	e8 9d ff ff ff       	call   a522 <__pic_get_irq_reg>
    a585:	83 c4 04             	add    $0x4,%esp
}
    a588:	c9                   	leave  
    a589:	c3                   	ret    

0000a58a <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a58a:	55                   	push   %ebp
    a58b:	89 e5                	mov    %esp,%ebp
    a58d:	83 ec 14             	sub    $0x14,%esp
    a590:	8b 45 08             	mov    0x8(%ebp),%eax
    a593:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a596:	e8 d1 ff ff ff       	call   a56c <pic_get_isr>
    a59b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a59f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a5a3:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a5a7:	74 13                	je     a5bc <spurious_IRQ+0x32>
    a5a9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a5ad:	0f b6 c0             	movzbl %al,%eax
    a5b0:	83 e0 07             	and    $0x7,%eax
    a5b3:	50                   	push   %eax
    a5b4:	e8 c5 fd ff ff       	call   a37e <PIC_sendEOI>
    a5b9:	83 c4 04             	add    $0x4,%esp
    a5bc:	90                   	nop
    a5bd:	c9                   	leave  
    a5be:	c3                   	ret    

0000a5bf <conserv_status_byte>:
uint32_t compteur   = 0;
uint8_t  frequency  = 0;
uint8_t  status_PIT = 0;

void conserv_status_byte()
{
    a5bf:	55                   	push   %ebp
    a5c0:	89 e5                	mov    %esp,%ebp
    a5c2:	83 ec 10             	sub    $0x10,%esp
    set_pit_count(PIT_0, PIT_reload_value);
    a5c5:	ba 43 00 00 00       	mov    $0x43,%edx
    a5ca:	b8 40 00 00 00       	mov    $0x40,%eax
    a5cf:	ee                   	out    %al,(%dx)
    a5d0:	b8 40 00 00 00       	mov    $0x40,%eax
    a5d5:	89 c2                	mov    %eax,%edx
    a5d7:	ec                   	in     (%dx),%al
    a5d8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a5dc:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a5e0:	88 45 f6             	mov    %al,-0xa(%ebp)
    a5e3:	b8 40 00 00 00       	mov    $0x40,%eax
    a5e8:	89 c2                	mov    %eax,%edx
    a5ea:	ec                   	in     (%dx),%al
    a5eb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a5ef:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a5f3:	88 45 f7             	mov    %al,-0x9(%ebp)
    a5f6:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a5fa:	66 98                	cbtw   
    a5fc:	ba 40 00 00 00       	mov    $0x40,%edx
    a601:	ee                   	out    %al,(%dx)
    a602:	a1 74 32 02 00       	mov    0x23274,%eax
    a607:	c1 f8 08             	sar    $0x8,%eax
    a60a:	ba 40 00 00 00       	mov    $0x40,%edx
    a60f:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a610:	ba 43 00 00 00       	mov    $0x43,%edx
    a615:	b8 40 00 00 00       	mov    $0x40,%eax
    a61a:	ee                   	out    %al,(%dx)
    a61b:	b8 40 00 00 00       	mov    $0x40,%eax
    a620:	89 c2                	mov    %eax,%edx
    a622:	ec                   	in     (%dx),%al
    a623:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a627:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a62b:	88 45 f4             	mov    %al,-0xc(%ebp)
    a62e:	b8 40 00 00 00       	mov    $0x40,%eax
    a633:	89 c2                	mov    %eax,%edx
    a635:	ec                   	in     (%dx),%al
    a636:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a63a:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a63e:	88 45 f5             	mov    %al,-0xb(%ebp)
    a641:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a645:	66 98                	cbtw   
    a647:	ba 43 00 00 00       	mov    $0x43,%edx
    a64c:	ee                   	out    %al,(%dx)
    a64d:	ba 43 00 00 00       	mov    $0x43,%edx
    a652:	b8 34 00 00 00       	mov    $0x34,%eax
    a657:	ee                   	out    %al,(%dx)
}
    a658:	90                   	nop
    a659:	c9                   	leave  
    a65a:	c3                   	ret    

0000a65b <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a65b:	55                   	push   %ebp
    a65c:	89 e5                	mov    %esp,%ebp
    a65e:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a661:	0f b6 05 40 31 02 00 	movzbl 0x23140,%eax
    a668:	3c 01                	cmp    $0x1,%al
    a66a:	75 27                	jne    a693 <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a66c:	a1 44 31 02 00       	mov    0x23144,%eax
    a671:	85 c0                	test   %eax,%eax
    a673:	75 11                	jne    a686 <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a675:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    a67c:	01 00 00 
            __switch();
    a67f:	e8 d8 0a 00 00       	call   b15c <__switch>
        } else
            sheduler.task_timer--;
    }
}
    a684:	eb 0d                	jmp    a693 <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a686:	a1 44 31 02 00       	mov    0x23144,%eax
    a68b:	83 e8 01             	sub    $0x1,%eax
    a68e:	a3 44 31 02 00       	mov    %eax,0x23144
}
    a693:	90                   	nop
    a694:	c9                   	leave  
    a695:	c3                   	ret    

0000a696 <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a696:	55                   	push   %ebp
    a697:	89 e5                	mov    %esp,%ebp
    a699:	83 ec 28             	sub    $0x28,%esp
    a69c:	8b 45 08             	mov    0x8(%ebp),%eax
    a69f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a6a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a6a7:	a2 04 20 01 00       	mov    %al,0x12004
    calculate_frequency();
    a6ac:	e8 fb 0c 00 00       	call   b3ac <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a6b1:	ba 43 00 00 00       	mov    $0x43,%edx
    a6b6:	b8 40 00 00 00       	mov    $0x40,%eax
    a6bb:	ee                   	out    %al,(%dx)
    a6bc:	b8 40 00 00 00       	mov    $0x40,%eax
    a6c1:	89 c2                	mov    %eax,%edx
    a6c3:	ec                   	in     (%dx),%al
    a6c4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a6c8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a6cc:	88 45 ee             	mov    %al,-0x12(%ebp)
    a6cf:	b8 40 00 00 00       	mov    $0x40,%eax
    a6d4:	89 c2                	mov    %eax,%edx
    a6d6:	ec                   	in     (%dx),%al
    a6d7:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    a6db:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
    a6df:	88 45 ef             	mov    %al,-0x11(%ebp)
    a6e2:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    a6e6:	66 98                	cbtw   
    a6e8:	ba 43 00 00 00       	mov    $0x43,%edx
    a6ed:	ee                   	out    %al,(%dx)
    a6ee:	ba 43 00 00 00       	mov    $0x43,%edx
    a6f3:	b8 34 00 00 00       	mov    $0x34,%eax
    a6f8:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a6f9:	ba 43 00 00 00       	mov    $0x43,%edx
    a6fe:	b8 40 00 00 00       	mov    $0x40,%eax
    a703:	ee                   	out    %al,(%dx)
    a704:	b8 40 00 00 00       	mov    $0x40,%eax
    a709:	89 c2                	mov    %eax,%edx
    a70b:	ec                   	in     (%dx),%al
    a70c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a710:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a714:	88 45 ec             	mov    %al,-0x14(%ebp)
    a717:	b8 40 00 00 00       	mov    $0x40,%eax
    a71c:	89 c2                	mov    %eax,%edx
    a71e:	ec                   	in     (%dx),%al
    a71f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a723:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a727:	88 45 ed             	mov    %al,-0x13(%ebp)
    a72a:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a72e:	66 98                	cbtw   
    a730:	ba 40 00 00 00       	mov    $0x40,%edx
    a735:	ee                   	out    %al,(%dx)
    a736:	a1 74 32 02 00       	mov    0x23274,%eax
    a73b:	c1 f8 08             	sar    $0x8,%eax
    a73e:	ba 40 00 00 00       	mov    $0x40,%edx
    a743:	ee                   	out    %al,(%dx)
}
    a744:	90                   	nop
    a745:	c9                   	leave  
    a746:	c3                   	ret    

0000a747 <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a747:	55                   	push   %ebp
    a748:	89 e5                	mov    %esp,%ebp
    a74a:	83 ec 14             	sub    $0x14,%esp
    a74d:	8b 45 08             	mov    0x8(%ebp),%eax
    a750:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a753:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a757:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a75b:	83 f8 42             	cmp    $0x42,%eax
    a75e:	74 1d                	je     a77d <read_back_channel+0x36>
    a760:	83 f8 42             	cmp    $0x42,%eax
    a763:	7f 1e                	jg     a783 <read_back_channel+0x3c>
    a765:	83 f8 40             	cmp    $0x40,%eax
    a768:	74 07                	je     a771 <read_back_channel+0x2a>
    a76a:	83 f8 41             	cmp    $0x41,%eax
    a76d:	74 08                	je     a777 <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a76f:	eb 12                	jmp    a783 <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a771:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a775:	eb 0d                	jmp    a784 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a777:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a77b:	eb 07                	jmp    a784 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a77d:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a781:	eb 01                	jmp    a784 <read_back_channel+0x3d>
        break;
    a783:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a784:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a788:	ba 43 00 00 00       	mov    $0x43,%edx
    a78d:	b8 40 00 00 00       	mov    $0x40,%eax
    a792:	ee                   	out    %al,(%dx)
    a793:	b8 40 00 00 00       	mov    $0x40,%eax
    a798:	89 c2                	mov    %eax,%edx
    a79a:	ec                   	in     (%dx),%al
    a79b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a79f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a7a3:	88 45 f4             	mov    %al,-0xc(%ebp)
    a7a6:	b8 40 00 00 00       	mov    $0x40,%eax
    a7ab:	89 c2                	mov    %eax,%edx
    a7ad:	ec                   	in     (%dx),%al
    a7ae:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a7b2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a7b6:	88 45 f5             	mov    %al,-0xb(%ebp)
    a7b9:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a7bd:	66 98                	cbtw   
    a7bf:	ba 43 00 00 00       	mov    $0x43,%edx
    a7c4:	ee                   	out    %al,(%dx)
    a7c5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a7c9:	c1 f8 08             	sar    $0x8,%eax
    a7cc:	ba 43 00 00 00       	mov    $0x43,%edx
    a7d1:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a7d2:	ba 43 00 00 00       	mov    $0x43,%edx
    a7d7:	b8 40 00 00 00       	mov    $0x40,%eax
    a7dc:	ee                   	out    %al,(%dx)
    a7dd:	b8 40 00 00 00       	mov    $0x40,%eax
    a7e2:	89 c2                	mov    %eax,%edx
    a7e4:	ec                   	in     (%dx),%al
    a7e5:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a7e9:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a7ed:	88 45 f2             	mov    %al,-0xe(%ebp)
    a7f0:	b8 40 00 00 00       	mov    $0x40,%eax
    a7f5:	89 c2                	mov    %eax,%edx
    a7f7:	ec                   	in     (%dx),%al
    a7f8:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a7fc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a800:	88 45 f3             	mov    %al,-0xd(%ebp)
    a803:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a807:	66 98                	cbtw   
    a809:	c9                   	leave  
    a80a:	c3                   	ret    

0000a80b <read_ebp>:
        registers;                                                     \
    })

static inline uint32_t
read_ebp(void)
{
    a80b:	55                   	push   %ebp
    a80c:	89 e5                	mov    %esp,%ebp
    a80e:	83 ec 10             	sub    $0x10,%esp
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
    a811:	89 e8                	mov    %ebp,%eax
    a813:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(ebp));
    return ebp;
    a816:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a819:	c9                   	leave  
    a81a:	c3                   	ret    

0000a81b <backtrace>:
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    a81b:	55                   	push   %ebp
    a81c:	89 e5                	mov    %esp,%ebp
    a81e:	83 ec 18             	sub    $0x18,%esp
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;
    a821:	e8 e5 ff ff ff       	call   a80b <read_ebp>
    a826:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a829:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a82c:	83 c0 04             	add    $0x4,%eax
    a82f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp != 0) {
    a832:	eb 30                	jmp    a864 <backtrace+0x49>
        kprintf("ebp %x eip %x\n", ebp, *eip);
    a834:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a837:	8b 00                	mov    (%eax),%eax
    a839:	83 ec 04             	sub    $0x4,%esp
    a83c:	50                   	push   %eax
    a83d:	ff 75 f4             	pushl  -0xc(%ebp)
    a840:	68 c3 f0 00 00       	push   $0xf0c3
    a845:	e8 03 01 00 00       	call   a94d <kprintf>
    a84a:	83 c4 10             	add    $0x10,%esp

        ptr = (int*)(ebp);
    a84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a850:	89 45 ec             	mov    %eax,-0x14(%ebp)

        ebp = (int)(*ptr);
    a853:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a856:	8b 00                	mov    (%eax),%eax
    a858:	89 45 f4             	mov    %eax,-0xc(%ebp)

        eip = (int*)(ebp + 4);
    a85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a85e:	83 c0 04             	add    $0x4,%eax
    a861:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (ebp != 0) {
    a864:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    a868:	75 ca                	jne    a834 <backtrace+0x19>
    }
    return 0;
    a86a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a86f:	c9                   	leave  
    a870:	c3                   	ret    

0000a871 <mon_help>:

int mon_help(int argc, char** argv)
{
    a871:	55                   	push   %ebp
    a872:	89 e5                	mov    %esp,%ebp
    a874:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 2; i++)
    a877:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a87e:	eb 3c                	jmp    a8bc <mon_help+0x4b>
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    a880:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a883:	89 d0                	mov    %edx,%eax
    a885:	01 c0                	add    %eax,%eax
    a887:	01 d0                	add    %edx,%eax
    a889:	c1 e0 02             	shl    $0x2,%eax
    a88c:	05 68 b6 00 00       	add    $0xb668,%eax
    a891:	8b 10                	mov    (%eax),%edx
    a893:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    a896:	89 c8                	mov    %ecx,%eax
    a898:	01 c0                	add    %eax,%eax
    a89a:	01 c8                	add    %ecx,%eax
    a89c:	c1 e0 02             	shl    $0x2,%eax
    a89f:	05 64 b6 00 00       	add    $0xb664,%eax
    a8a4:	8b 00                	mov    (%eax),%eax
    a8a6:	83 ec 04             	sub    $0x4,%esp
    a8a9:	52                   	push   %edx
    a8aa:	50                   	push   %eax
    a8ab:	68 d2 f0 00 00       	push   $0xf0d2
    a8b0:	e8 98 00 00 00       	call   a94d <kprintf>
    a8b5:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 2; i++)
    a8b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a8bc:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    a8c0:	7e be                	jle    a880 <mon_help+0xf>
    return 0;
    a8c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a8c7:	c9                   	leave  
    a8c8:	c3                   	ret    

0000a8c9 <monitor_service_keyboard>:

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    a8c9:	55                   	push   %ebp
    a8ca:	89 e5                	mov    %esp,%ebp
    a8cc:	83 ec 18             	sub    $0x18,%esp
    int8_t code = get_ASCII_code_keyboard();
    a8cf:	e8 b5 f8 ff ff       	call   a189 <get_ASCII_code_keyboard>
    a8d4:	88 45 f3             	mov    %al,-0xd(%ebp)
    if (code != '\n') {
    a8d7:	80 7d f3 0a          	cmpb   $0xa,-0xd(%ebp)
    a8db:	74 25                	je     a902 <monitor_service_keyboard+0x39>
        keyboard_code_monitor[keyboard_num] = code;
    a8dd:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a8e4:	0f be c0             	movsbl %al,%eax
    a8e7:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
    a8eb:	88 90 20 20 01 00    	mov    %dl,0x12020(%eax)
        keyboard_num++;
    a8f1:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a8f8:	83 c0 01             	add    $0x1,%eax
    a8fb:	a2 1f 21 01 00       	mov    %al,0x1211f
            keyboard_code_monitor[i] = 0;
        }

        keyboard_num = 0;
    }
    a900:	eb 48                	jmp    a94a <monitor_service_keyboard+0x81>
        for (i = 0; i < keyboard_num; i++) {
    a902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a909:	eb 29                	jmp    a934 <monitor_service_keyboard+0x6b>
            putchar(keyboard_code_monitor[i]);
    a90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a90e:	05 20 20 01 00       	add    $0x12020,%eax
    a913:	0f b6 00             	movzbl (%eax),%eax
    a916:	0f b6 c0             	movzbl %al,%eax
    a919:	83 ec 0c             	sub    $0xc,%esp
    a91c:	50                   	push   %eax
    a91d:	e8 f7 e6 ff ff       	call   9019 <putchar>
    a922:	83 c4 10             	add    $0x10,%esp
            keyboard_code_monitor[i] = 0;
    a925:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a928:	05 20 20 01 00       	add    $0x12020,%eax
    a92d:	c6 00 00             	movb   $0x0,(%eax)
        for (i = 0; i < keyboard_num; i++) {
    a930:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a934:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a93b:	0f be c0             	movsbl %al,%eax
    a93e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a941:	7c c8                	jl     a90b <monitor_service_keyboard+0x42>
        keyboard_num = 0;
    a943:	c6 05 1f 21 01 00 00 	movb   $0x0,0x1211f
    a94a:	90                   	nop
    a94b:	c9                   	leave  
    a94c:	c3                   	ret    

0000a94d <kprintf>:
#include <stdint.h>

extern void printf(const char* fmt, va_list arg);

void kprintf(const char* frmt, ...)
{
    a94d:	55                   	push   %ebp
    a94e:	89 e5                	mov    %esp,%ebp
    a950:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    a953:	8d 45 0c             	lea    0xc(%ebp),%eax
    a956:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    a959:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a95c:	83 ec 08             	sub    $0x8,%esp
    a95f:	50                   	push   %eax
    a960:	ff 75 08             	pushl  0x8(%ebp)
    a963:	e8 36 e7 ff ff       	call   909e <printf>
    a968:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    a96b:	90                   	nop
    a96c:	c9                   	leave  
    a96d:	c3                   	ret    

0000a96e <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    a96e:	55                   	push   %ebp
    a96f:	89 e5                	mov    %esp,%ebp
    a971:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    a974:	b8 1b 00 00 00       	mov    $0x1b,%eax
    a979:	89 c1                	mov    %eax,%ecx
    a97b:	0f 32                	rdmsr  
    a97d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    a980:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    a983:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a986:	c1 e0 05             	shl    $0x5,%eax
    a989:	89 c2                	mov    %eax,%edx
    a98b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a98e:	01 d0                	add    %edx,%eax
}
    a990:	c9                   	leave  
    a991:	c3                   	ret    

0000a992 <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    a992:	55                   	push   %ebp
    a993:	89 e5                	mov    %esp,%ebp
    a995:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    a998:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    a99f:	8b 45 08             	mov    0x8(%ebp),%eax
    a9a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a9a7:	80 cc 08             	or     $0x8,%ah
    a9aa:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    a9ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a9b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a9b3:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    a9b8:	0f 30                	wrmsr  
}
    a9ba:	90                   	nop
    a9bb:	c9                   	leave  
    a9bc:	c3                   	ret    

0000a9bd <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    a9bd:	55                   	push   %ebp
    a9be:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    a9c0:	8b 15 20 21 01 00    	mov    0x12120,%edx
    a9c6:	8b 45 08             	mov    0x8(%ebp),%eax
    a9c9:	01 c0                	add    %eax,%eax
    a9cb:	01 d0                	add    %edx,%eax
    a9cd:	0f b7 00             	movzwl (%eax),%eax
    a9d0:	0f b7 c0             	movzwl %ax,%eax
}
    a9d3:	5d                   	pop    %ebp
    a9d4:	c3                   	ret    

0000a9d5 <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    a9d5:	55                   	push   %ebp
    a9d6:	89 e5                	mov    %esp,%ebp
    a9d8:	83 ec 04             	sub    $0x4,%esp
    a9db:	8b 45 0c             	mov    0xc(%ebp),%eax
    a9de:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    a9e2:	8b 15 20 21 01 00    	mov    0x12120,%edx
    a9e8:	8b 45 08             	mov    0x8(%ebp),%eax
    a9eb:	01 c0                	add    %eax,%eax
    a9ed:	01 c2                	add    %eax,%edx
    a9ef:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a9f3:	66 89 02             	mov    %ax,(%edx)
}
    a9f6:	90                   	nop
    a9f7:	c9                   	leave  
    a9f8:	c3                   	ret    

0000a9f9 <enable_local_apic>:

void enable_local_apic()
{
    a9f9:	55                   	push   %ebp
    a9fa:	89 e5                	mov    %esp,%ebp
    a9fc:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    a9ff:	83 ec 08             	sub    $0x8,%esp
    aa02:	68 fb 03 00 00       	push   $0x3fb
    aa07:	68 00 d0 00 00       	push   $0xd000
    aa0c:	e8 89 f7 ff ff       	call   a19a <create_page_table>
    aa11:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    aa14:	e8 55 ff ff ff       	call   a96e <get_apic_base>
    aa19:	a3 20 21 01 00       	mov    %eax,0x12120

    set_apic_base(get_apic_base());
    aa1e:	e8 4b ff ff ff       	call   a96e <get_apic_base>
    aa23:	83 ec 0c             	sub    $0xc,%esp
    aa26:	50                   	push   %eax
    aa27:	e8 66 ff ff ff       	call   a992 <set_apic_base>
    aa2c:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    aa2f:	83 ec 0c             	sub    $0xc,%esp
    aa32:	68 f0 00 00 00       	push   $0xf0
    aa37:	e8 81 ff ff ff       	call   a9bd <cpu_ReadLocalAPICReg>
    aa3c:	83 c4 10             	add    $0x10,%esp
    aa3f:	80 cc 01             	or     $0x1,%ah
    aa42:	0f b7 c0             	movzwl %ax,%eax
    aa45:	83 ec 08             	sub    $0x8,%esp
    aa48:	50                   	push   %eax
    aa49:	68 f0 00 00 00       	push   $0xf0
    aa4e:	e8 82 ff ff ff       	call   a9d5 <cpu_SetLocalAPICReg>
    aa53:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    aa56:	83 ec 08             	sub    $0x8,%esp
    aa59:	6a 02                	push   $0x2
    aa5b:	6a 20                	push   $0x20
    aa5d:	e8 73 ff ff ff       	call   a9d5 <cpu_SetLocalAPICReg>
    aa62:	83 c4 10             	add    $0x10,%esp
}
    aa65:	90                   	nop
    aa66:	c9                   	leave  
    aa67:	c3                   	ret    

0000aa68 <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    aa68:	55                   	push   %ebp
    aa69:	89 e5                	mov    %esp,%ebp
    aa6b:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    aa6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    aa75:	eb 49                	jmp    aac0 <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    aa77:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa7a:	89 d0                	mov    %edx,%eax
    aa7c:	01 c0                	add    %eax,%eax
    aa7e:	01 d0                	add    %edx,%eax
    aa80:	c1 e0 02             	shl    $0x2,%eax
    aa83:	05 40 21 01 00       	add    $0x12140,%eax
    aa88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    aa8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa91:	89 d0                	mov    %edx,%eax
    aa93:	01 c0                	add    %eax,%eax
    aa95:	01 d0                	add    %edx,%eax
    aa97:	c1 e0 02             	shl    $0x2,%eax
    aa9a:	05 48 21 01 00       	add    $0x12148,%eax
    aa9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    aaa5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aaa8:	89 d0                	mov    %edx,%eax
    aaaa:	01 c0                	add    %eax,%eax
    aaac:	01 d0                	add    %edx,%eax
    aaae:	c1 e0 02             	shl    $0x2,%eax
    aab1:	05 44 21 01 00       	add    $0x12144,%eax
    aab6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    aabc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    aac0:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    aac7:	7e ae                	jle    aa77 <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    aac9:	c7 05 40 e1 01 00 40 	movl   $0x12140,0x1e140
    aad0:	21 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    aad3:	90                   	nop
    aad4:	c9                   	leave  
    aad5:	c3                   	ret    

0000aad6 <kmalloc>:

void* kmalloc(uint32_t size)
{
    aad6:	55                   	push   %ebp
    aad7:	89 e5                	mov    %esp,%ebp
    aad9:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    aadc:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aae1:	8b 00                	mov    (%eax),%eax
    aae3:	85 c0                	test   %eax,%eax
    aae5:	75 36                	jne    ab1d <kmalloc+0x47>
        _head_vmm_->address = KERNEL__VM_BASE;
    aae7:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aaec:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    aaf1:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    aaf3:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aaf8:	8b 55 08             	mov    0x8(%ebp),%edx
    aafb:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    aafe:	83 ec 04             	sub    $0x4,%esp
    ab01:	ff 75 08             	pushl  0x8(%ebp)
    ab04:	6a 00                	push   $0x0
    ab06:	68 60 e1 01 00       	push   $0x1e160
    ab0b:	e8 5f e8 ff ff       	call   936f <memset>
    ab10:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    ab13:	b8 60 e1 01 00       	mov    $0x1e160,%eax
    ab18:	e9 7b 01 00 00       	jmp    ac98 <kmalloc+0x1c2>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    ab1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab24:	eb 04                	jmp    ab2a <kmalloc+0x54>
        i++;
    ab26:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab2a:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    ab31:	77 17                	ja     ab4a <kmalloc+0x74>
    ab33:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab36:	89 d0                	mov    %edx,%eax
    ab38:	01 c0                	add    %eax,%eax
    ab3a:	01 d0                	add    %edx,%eax
    ab3c:	c1 e0 02             	shl    $0x2,%eax
    ab3f:	05 40 21 01 00       	add    $0x12140,%eax
    ab44:	8b 00                	mov    (%eax),%eax
    ab46:	85 c0                	test   %eax,%eax
    ab48:	75 dc                	jne    ab26 <kmalloc+0x50>

    _new_item_ = &MM_BLOCK[i];
    ab4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab4d:	89 d0                	mov    %edx,%eax
    ab4f:	01 c0                	add    %eax,%eax
    ab51:	01 d0                	add    %edx,%eax
    ab53:	c1 e0 02             	shl    $0x2,%eax
    ab56:	05 40 21 01 00       	add    $0x12140,%eax
    ab5b:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    ab5e:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ab63:	8b 00                	mov    (%eax),%eax
    ab65:	b9 60 e1 01 00       	mov    $0x1e160,%ecx
    ab6a:	8b 55 08             	mov    0x8(%ebp),%edx
    ab6d:	01 ca                	add    %ecx,%edx
    ab6f:	39 d0                	cmp    %edx,%eax
    ab71:	74 47                	je     abba <kmalloc+0xe4>
        _new_item_->address = KERNEL__VM_BASE;
    ab73:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ab78:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab7b:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    ab7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab80:	8b 55 08             	mov    0x8(%ebp),%edx
    ab83:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    ab86:	8b 15 40 e1 01 00    	mov    0x1e140,%edx
    ab8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab8f:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    ab92:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab95:	a3 40 e1 01 00       	mov    %eax,0x1e140

        memset((void*)_new_item_->address, 0, size);
    ab9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab9d:	8b 00                	mov    (%eax),%eax
    ab9f:	83 ec 04             	sub    $0x4,%esp
    aba2:	ff 75 08             	pushl  0x8(%ebp)
    aba5:	6a 00                	push   $0x0
    aba7:	50                   	push   %eax
    aba8:	e8 c2 e7 ff ff       	call   936f <memset>
    abad:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    abb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abb3:	8b 00                	mov    (%eax),%eax
    abb5:	e9 de 00 00 00       	jmp    ac98 <kmalloc+0x1c2>
    }

    tmp = _head_vmm_;
    abba:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abbf:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    abc2:	eb 27                	jmp    abeb <kmalloc+0x115>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    abc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abc7:	8b 40 08             	mov    0x8(%eax),%eax
    abca:	8b 10                	mov    (%eax),%edx
    abcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abcf:	8b 08                	mov    (%eax),%ecx
    abd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abd4:	8b 40 04             	mov    0x4(%eax),%eax
    abd7:	01 c1                	add    %eax,%ecx
    abd9:	8b 45 08             	mov    0x8(%ebp),%eax
    abdc:	01 c8                	add    %ecx,%eax
    abde:	39 c2                	cmp    %eax,%edx
    abe0:	73 15                	jae    abf7 <kmalloc+0x121>
            break;

        tmp = tmp->next;
    abe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abe5:	8b 40 08             	mov    0x8(%eax),%eax
    abe8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    abeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abee:	8b 40 08             	mov    0x8(%eax),%eax
    abf1:	85 c0                	test   %eax,%eax
    abf3:	75 cf                	jne    abc4 <kmalloc+0xee>
    abf5:	eb 01                	jmp    abf8 <kmalloc+0x122>
            break;
    abf7:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    abf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abfb:	8b 40 08             	mov    0x8(%eax),%eax
    abfe:	85 c0                	test   %eax,%eax
    ac00:	75 4b                	jne    ac4d <kmalloc+0x177>
        _new_item_->size = size;
    ac02:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac05:	8b 55 08             	mov    0x8(%ebp),%edx
    ac08:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ac0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac0e:	8b 10                	mov    (%eax),%edx
    ac10:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac13:	8b 40 04             	mov    0x4(%eax),%eax
    ac16:	01 c2                	add    %eax,%edx
    ac18:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac1b:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    ac1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    ac27:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac2d:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac30:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac33:	8b 00                	mov    (%eax),%eax
    ac35:	83 ec 04             	sub    $0x4,%esp
    ac38:	ff 75 08             	pushl  0x8(%ebp)
    ac3b:	6a 00                	push   $0x0
    ac3d:	50                   	push   %eax
    ac3e:	e8 2c e7 ff ff       	call   936f <memset>
    ac43:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac46:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac49:	8b 00                	mov    (%eax),%eax
    ac4b:	eb 4b                	jmp    ac98 <kmalloc+0x1c2>
    }

    else {
        _new_item_->size = size;
    ac4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac50:	8b 55 08             	mov    0x8(%ebp),%edx
    ac53:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ac56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac59:	8b 10                	mov    (%eax),%edx
    ac5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac5e:	8b 40 04             	mov    0x4(%eax),%eax
    ac61:	01 c2                	add    %eax,%edx
    ac63:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac66:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    ac68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac6b:	8b 50 08             	mov    0x8(%eax),%edx
    ac6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac71:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    ac74:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac77:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac7a:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac80:	8b 00                	mov    (%eax),%eax
    ac82:	83 ec 04             	sub    $0x4,%esp
    ac85:	ff 75 08             	pushl  0x8(%ebp)
    ac88:	6a 00                	push   $0x0
    ac8a:	50                   	push   %eax
    ac8b:	e8 df e6 ff ff       	call   936f <memset>
    ac90:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac93:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac96:	8b 00                	mov    (%eax),%eax
    }
}
    ac98:	c9                   	leave  
    ac99:	c3                   	ret    

0000ac9a <free>:

void free(virtaddr_t _addr__)
{
    ac9a:	55                   	push   %ebp
    ac9b:	89 e5                	mov    %esp,%ebp
    ac9d:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    aca0:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aca5:	8b 00                	mov    (%eax),%eax
    aca7:	39 45 08             	cmp    %eax,0x8(%ebp)
    acaa:	75 29                	jne    acd5 <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    acac:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    acb7:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    acc3:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acc8:	8b 40 08             	mov    0x8(%eax),%eax
    accb:	a3 40 e1 01 00       	mov    %eax,0x1e140
        return;
    acd0:	e9 ac 00 00 00       	jmp    ad81 <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    acd5:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acda:	8b 40 08             	mov    0x8(%eax),%eax
    acdd:	85 c0                	test   %eax,%eax
    acdf:	75 16                	jne    acf7 <free+0x5d>
    ace1:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ace6:	8b 00                	mov    (%eax),%eax
    ace8:	39 45 08             	cmp    %eax,0x8(%ebp)
    aceb:	75 0a                	jne    acf7 <free+0x5d>
        init_vmm();
    aced:	e8 76 fd ff ff       	call   aa68 <init_vmm>
        return;
    acf2:	e9 8a 00 00 00       	jmp    ad81 <free+0xe7>
    }

    tmp = _head_vmm_;
    acf7:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acfc:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    acff:	eb 0f                	jmp    ad10 <free+0x76>
        tmp_prev = tmp;
    ad01:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad04:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    ad07:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad0a:	8b 40 08             	mov    0x8(%eax),%eax
    ad0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ad10:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad13:	8b 40 08             	mov    0x8(%eax),%eax
    ad16:	85 c0                	test   %eax,%eax
    ad18:	74 0a                	je     ad24 <free+0x8a>
    ad1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad1d:	8b 00                	mov    (%eax),%eax
    ad1f:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad22:	75 dd                	jne    ad01 <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ad24:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad27:	8b 40 08             	mov    0x8(%eax),%eax
    ad2a:	85 c0                	test   %eax,%eax
    ad2c:	75 29                	jne    ad57 <free+0xbd>
    ad2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad31:	8b 00                	mov    (%eax),%eax
    ad33:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad36:	75 1f                	jne    ad57 <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad38:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad41:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ad4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ad55:	eb 2a                	jmp    ad81 <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ad57:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad5a:	8b 00                	mov    (%eax),%eax
    ad5c:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad5f:	75 20                	jne    ad81 <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad61:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ad74:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad77:	8b 50 08             	mov    0x8(%eax),%edx
    ad7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad7d:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ad80:	90                   	nop
    }
    ad81:	c9                   	leave  
    ad82:	c3                   	ret    

0000ad83 <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ad83:	55                   	push   %ebp
    ad84:	89 e5                	mov    %esp,%ebp
    ad86:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ad89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    ad90:	eb 49                	jmp    addb <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ad92:	ba db f0 00 00       	mov    $0xf0db,%edx
    ad97:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad9a:	c1 e0 04             	shl    $0x4,%eax
    ad9d:	05 40 f1 01 00       	add    $0x1f140,%eax
    ada2:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    ada4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ada7:	c1 e0 04             	shl    $0x4,%eax
    adaa:	05 44 f1 01 00       	add    $0x1f144,%eax
    adaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    adb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adb8:	c1 e0 04             	shl    $0x4,%eax
    adbb:	05 4c f1 01 00       	add    $0x1f14c,%eax
    adc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    adc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adc9:	c1 e0 04             	shl    $0x4,%eax
    adcc:	05 48 f1 01 00       	add    $0x1f148,%eax
    add1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    add7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    addb:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    ade2:	76 ae                	jbe    ad92 <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    ade4:	83 ec 08             	sub    $0x8,%esp
    ade7:	6a 01                	push   $0x1
    ade9:	68 00 e0 00 00       	push   $0xe000
    adee:	e8 a7 f3 ff ff       	call   a19a <create_page_table>
    adf3:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    adf6:	c7 05 20 f1 01 00 40 	movl   $0x1f140,0x1f120
    adfd:	f1 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    ae00:	90                   	nop
    ae01:	c9                   	leave  
    ae02:	c3                   	ret    

0000ae03 <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    ae03:	55                   	push   %ebp
    ae04:	89 e5                	mov    %esp,%ebp
    ae06:	53                   	push   %ebx
    ae07:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    ae0a:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae0f:	8b 00                	mov    (%eax),%eax
    ae11:	ba db f0 00 00       	mov    $0xf0db,%edx
    ae16:	39 d0                	cmp    %edx,%eax
    ae18:	75 40                	jne    ae5a <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    ae1a:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae1f:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    ae25:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae2a:	8b 55 08             	mov    0x8(%ebp),%edx
    ae2d:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    ae30:	8b 45 08             	mov    0x8(%ebp),%eax
    ae33:	c1 e0 0c             	shl    $0xc,%eax
    ae36:	89 c2                	mov    %eax,%edx
    ae38:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae3d:	8b 00                	mov    (%eax),%eax
    ae3f:	83 ec 04             	sub    $0x4,%esp
    ae42:	52                   	push   %edx
    ae43:	6a 00                	push   $0x0
    ae45:	50                   	push   %eax
    ae46:	e8 24 e5 ff ff       	call   936f <memset>
    ae4b:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    ae4e:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae53:	8b 00                	mov    (%eax),%eax
    ae55:	e9 ae 01 00 00       	jmp    b008 <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    ae5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae61:	eb 04                	jmp    ae67 <alloc_page+0x64>
        i++;
    ae63:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae67:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae6a:	c1 e0 04             	shl    $0x4,%eax
    ae6d:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae72:	8b 00                	mov    (%eax),%eax
    ae74:	ba db f0 00 00       	mov    $0xf0db,%edx
    ae79:	39 d0                	cmp    %edx,%eax
    ae7b:	74 09                	je     ae86 <alloc_page+0x83>
    ae7d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    ae84:	76 dd                	jbe    ae63 <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    ae86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae89:	c1 e0 04             	shl    $0x4,%eax
    ae8c:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae91:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    ae94:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae99:	8b 00                	mov    (%eax),%eax
    ae9b:	8b 55 08             	mov    0x8(%ebp),%edx
    ae9e:	81 c2 00 01 00 00    	add    $0x100,%edx
    aea4:	c1 e2 0c             	shl    $0xc,%edx
    aea7:	39 d0                	cmp    %edx,%eax
    aea9:	72 4c                	jb     aef7 <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    aeab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aeae:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    aeb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aeb7:	8b 55 08             	mov    0x8(%ebp),%edx
    aeba:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    aebd:	8b 15 20 f1 01 00    	mov    0x1f120,%edx
    aec3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aec6:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    aec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aecc:	a3 20 f1 01 00       	mov    %eax,0x1f120

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    aed1:	8b 45 08             	mov    0x8(%ebp),%eax
    aed4:	c1 e0 0c             	shl    $0xc,%eax
    aed7:	89 c2                	mov    %eax,%edx
    aed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aedc:	8b 00                	mov    (%eax),%eax
    aede:	83 ec 04             	sub    $0x4,%esp
    aee1:	52                   	push   %edx
    aee2:	6a 00                	push   $0x0
    aee4:	50                   	push   %eax
    aee5:	e8 85 e4 ff ff       	call   936f <memset>
    aeea:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    aeed:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aef0:	8b 00                	mov    (%eax),%eax
    aef2:	e9 11 01 00 00       	jmp    b008 <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    aef7:	a1 20 f1 01 00       	mov    0x1f120,%eax
    aefc:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    aeff:	eb 2a                	jmp    af2b <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    af01:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af04:	8b 40 0c             	mov    0xc(%eax),%eax
    af07:	8b 10                	mov    (%eax),%edx
    af09:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af0c:	8b 08                	mov    (%eax),%ecx
    af0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af11:	8b 58 04             	mov    0x4(%eax),%ebx
    af14:	8b 45 08             	mov    0x8(%ebp),%eax
    af17:	01 d8                	add    %ebx,%eax
    af19:	c1 e0 0c             	shl    $0xc,%eax
    af1c:	01 c8                	add    %ecx,%eax
    af1e:	39 c2                	cmp    %eax,%edx
    af20:	77 15                	ja     af37 <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    af22:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af25:	8b 40 0c             	mov    0xc(%eax),%eax
    af28:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    af2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af2e:	8b 40 0c             	mov    0xc(%eax),%eax
    af31:	85 c0                	test   %eax,%eax
    af33:	75 cc                	jne    af01 <alloc_page+0xfe>
    af35:	eb 01                	jmp    af38 <alloc_page+0x135>
            break;
    af37:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    af38:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af3b:	8b 40 0c             	mov    0xc(%eax),%eax
    af3e:	85 c0                	test   %eax,%eax
    af40:	75 5d                	jne    af9f <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    af42:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af45:	8b 10                	mov    (%eax),%edx
    af47:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af4a:	8b 40 04             	mov    0x4(%eax),%eax
    af4d:	c1 e0 0c             	shl    $0xc,%eax
    af50:	01 c2                	add    %eax,%edx
    af52:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af55:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    af57:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af5a:	8b 55 08             	mov    0x8(%ebp),%edx
    af5d:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    af60:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af63:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    af6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    af70:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    af73:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af76:	8b 55 ec             	mov    -0x14(%ebp),%edx
    af79:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    af7c:	8b 45 08             	mov    0x8(%ebp),%eax
    af7f:	c1 e0 0c             	shl    $0xc,%eax
    af82:	89 c2                	mov    %eax,%edx
    af84:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af87:	8b 00                	mov    (%eax),%eax
    af89:	83 ec 04             	sub    $0x4,%esp
    af8c:	52                   	push   %edx
    af8d:	6a 00                	push   $0x0
    af8f:	50                   	push   %eax
    af90:	e8 da e3 ff ff       	call   936f <memset>
    af95:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    af98:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af9b:	8b 00                	mov    (%eax),%eax
    af9d:	eb 69                	jmp    b008 <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    af9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afa2:	8b 10                	mov    (%eax),%edx
    afa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afa7:	8b 40 04             	mov    0x4(%eax),%eax
    afaa:	c1 e0 0c             	shl    $0xc,%eax
    afad:	01 c2                	add    %eax,%edx
    afaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afb2:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    afb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afb7:	8b 55 08             	mov    0x8(%ebp),%edx
    afba:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    afbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afc0:	8b 50 0c             	mov    0xc(%eax),%edx
    afc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afc6:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    afc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
    afcf:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    afd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afd8:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    afdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afde:	8b 40 0c             	mov    0xc(%eax),%eax
    afe1:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afe4:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    afe7:	8b 45 08             	mov    0x8(%ebp),%eax
    afea:	c1 e0 0c             	shl    $0xc,%eax
    afed:	89 c2                	mov    %eax,%edx
    afef:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aff2:	8b 00                	mov    (%eax),%eax
    aff4:	83 ec 04             	sub    $0x4,%esp
    aff7:	52                   	push   %edx
    aff8:	6a 00                	push   $0x0
    affa:	50                   	push   %eax
    affb:	e8 6f e3 ff ff       	call   936f <memset>
    b000:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    b003:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b006:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    b008:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    b00b:	c9                   	leave  
    b00c:	c3                   	ret    

0000b00d <free_page>:

void free_page(_address_order_track_ page)
{
    b00d:	55                   	push   %ebp
    b00e:	89 e5                	mov    %esp,%ebp
    b010:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    b013:	8b 45 10             	mov    0x10(%ebp),%eax
    b016:	85 c0                	test   %eax,%eax
    b018:	75 2d                	jne    b047 <free_page+0x3a>
    b01a:	8b 45 14             	mov    0x14(%ebp),%eax
    b01d:	85 c0                	test   %eax,%eax
    b01f:	74 26                	je     b047 <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    b021:	b8 db f0 00 00       	mov    $0xf0db,%eax
    b026:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    b029:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b02e:	8b 40 0c             	mov    0xc(%eax),%eax
    b031:	a3 20 f1 01 00       	mov    %eax,0x1f120
        _page_area_track_->previous_ = END_LIST;
    b036:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b03b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    b042:	e9 13 01 00 00       	jmp    b15a <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    b047:	8b 45 10             	mov    0x10(%ebp),%eax
    b04a:	85 c0                	test   %eax,%eax
    b04c:	75 67                	jne    b0b5 <free_page+0xa8>
    b04e:	8b 45 14             	mov    0x14(%ebp),%eax
    b051:	85 c0                	test   %eax,%eax
    b053:	75 60                	jne    b0b5 <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    b055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    b05c:	eb 49                	jmp    b0a7 <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    b05e:	ba db f0 00 00       	mov    $0xf0db,%edx
    b063:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b066:	c1 e0 04             	shl    $0x4,%eax
    b069:	05 40 f1 01 00       	add    $0x1f140,%eax
    b06e:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    b070:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b073:	c1 e0 04             	shl    $0x4,%eax
    b076:	05 44 f1 01 00       	add    $0x1f144,%eax
    b07b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    b081:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b084:	c1 e0 04             	shl    $0x4,%eax
    b087:	05 4c f1 01 00       	add    $0x1f14c,%eax
    b08c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    b092:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b095:	c1 e0 04             	shl    $0x4,%eax
    b098:	05 48 f1 01 00       	add    $0x1f148,%eax
    b09d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    b0a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b0a7:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    b0ae:	76 ae                	jbe    b05e <free_page+0x51>
        }
        return;
    b0b0:	e9 a5 00 00 00       	jmp    b15a <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b0b5:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b0ba:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0bd:	eb 09                	jmp    b0c8 <free_page+0xbb>
            tmp = tmp->next_;
    b0bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0c2:	8b 40 0c             	mov    0xc(%eax),%eax
    b0c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0cb:	8b 10                	mov    (%eax),%edx
    b0cd:	8b 45 08             	mov    0x8(%ebp),%eax
    b0d0:	39 c2                	cmp    %eax,%edx
    b0d2:	74 0a                	je     b0de <free_page+0xd1>
    b0d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0d7:	8b 40 0c             	mov    0xc(%eax),%eax
    b0da:	85 c0                	test   %eax,%eax
    b0dc:	75 e1                	jne    b0bf <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    b0de:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0e1:	8b 40 0c             	mov    0xc(%eax),%eax
    b0e4:	85 c0                	test   %eax,%eax
    b0e6:	75 25                	jne    b10d <free_page+0x100>
    b0e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0eb:	8b 10                	mov    (%eax),%edx
    b0ed:	8b 45 08             	mov    0x8(%ebp),%eax
    b0f0:	39 c2                	cmp    %eax,%edx
    b0f2:	75 19                	jne    b10d <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b0f4:	ba db f0 00 00       	mov    $0xf0db,%edx
    b0f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0fc:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    b0fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b101:	8b 40 08             	mov    0x8(%eax),%eax
    b104:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    b10b:	eb 4d                	jmp    b15a <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    b10d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b110:	8b 40 0c             	mov    0xc(%eax),%eax
    b113:	85 c0                	test   %eax,%eax
    b115:	74 36                	je     b14d <free_page+0x140>
    b117:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b11a:	8b 10                	mov    (%eax),%edx
    b11c:	8b 45 08             	mov    0x8(%ebp),%eax
    b11f:	39 c2                	cmp    %eax,%edx
    b121:	75 2a                	jne    b14d <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b123:	ba db f0 00 00       	mov    $0xf0db,%edx
    b128:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b12b:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    b12d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b130:	8b 40 08             	mov    0x8(%eax),%eax
    b133:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b136:	8b 52 0c             	mov    0xc(%edx),%edx
    b139:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    b13c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b13f:	8b 40 0c             	mov    0xc(%eax),%eax
    b142:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b145:	8b 52 08             	mov    0x8(%edx),%edx
    b148:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    b14b:	eb 0d                	jmp    b15a <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    b14d:	a1 24 f1 01 00       	mov    0x1f124,%eax
    b152:	83 e8 01             	sub    $0x1,%eax
    b155:	a3 24 f1 01 00       	mov    %eax,0x1f124
    b15a:	c9                   	leave  
    b15b:	c3                   	ret    

0000b15c <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    b15c:	55                   	push   %ebp
    b15d:	89 e5                	mov    %esp,%ebp
    b15f:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    b162:	a1 48 31 02 00       	mov    0x23148,%eax
    b167:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    b16a:	a1 48 31 02 00       	mov    0x23148,%eax
    b16f:	8b 40 3c             	mov    0x3c(%eax),%eax
    b172:	a3 48 31 02 00       	mov    %eax,0x23148

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    b177:	a1 48 31 02 00       	mov    0x23148,%eax
    b17c:	89 c2                	mov    %eax,%edx
    b17e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b181:	83 ec 08             	sub    $0x8,%esp
    b184:	52                   	push   %edx
    b185:	50                   	push   %eax
    b186:	e8 c5 02 00 00       	call   b450 <switch_to_task>
    b18b:	83 c4 10             	add    $0x10,%esp
}
    b18e:	90                   	nop
    b18f:	c9                   	leave  
    b190:	c3                   	ret    

0000b191 <init_multitasking>:

void init_multitasking()
{
    b191:	55                   	push   %ebp
    b192:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    b194:	c6 05 40 31 02 00 00 	movb   $0x0,0x23140
    sheduler.task_timer = DELAY_PER_TASK;
    b19b:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    b1a2:	01 00 00 
}
    b1a5:	90                   	nop
    b1a6:	5d                   	pop    %ebp
    b1a7:	c3                   	ret    

0000b1a8 <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    b1a8:	55                   	push   %ebp
    b1a9:	89 e5                	mov    %esp,%ebp
    b1ab:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    b1ae:	8b 45 08             	mov    0x8(%ebp),%eax
    b1b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    b1b7:	8b 45 08             	mov    0x8(%ebp),%eax
    b1ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    b1c1:	8b 45 08             	mov    0x8(%ebp),%eax
    b1c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    b1cb:	8b 45 08             	mov    0x8(%ebp),%eax
    b1ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    b1d5:	8b 45 08             	mov    0x8(%ebp),%eax
    b1d8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    b1df:	8b 45 08             	mov    0x8(%ebp),%eax
    b1e2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    b1e9:	8b 45 08             	mov    0x8(%ebp),%eax
    b1ec:	8b 55 10             	mov    0x10(%ebp),%edx
    b1ef:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    b1f2:	8b 55 0c             	mov    0xc(%ebp),%edx
    b1f5:	8b 45 08             	mov    0x8(%ebp),%eax
    b1f8:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    b1fb:	8b 45 08             	mov    0x8(%ebp),%eax
    b1fe:	8b 55 14             	mov    0x14(%ebp),%edx
    b201:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    b204:	83 ec 0c             	sub    $0xc,%esp
    b207:	68 c8 00 00 00       	push   $0xc8
    b20c:	e8 c5 f8 ff ff       	call   aad6 <kmalloc>
    b211:	83 c4 10             	add    $0x10,%esp
    b214:	89 c2                	mov    %eax,%edx
    b216:	8b 45 08             	mov    0x8(%ebp),%eax
    b219:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    b21c:	8b 45 08             	mov    0x8(%ebp),%eax
    b21f:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b226:	90                   	nop
    b227:	c9                   	leave  
    b228:	c3                   	ret    
    b229:	66 90                	xchg   %ax,%ax
    b22b:	66 90                	xchg   %ax,%ax
    b22d:	66 90                	xchg   %ax,%ax
    b22f:	90                   	nop

0000b230 <__exception_handler__>:
    b230:	58                   	pop    %eax
    b231:	a3 7c b6 00 00       	mov    %eax,0xb67c
    b236:	e8 5b e4 ff ff       	call   9696 <__exception__>
    b23b:	cf                   	iret   

0000b23c <__exception_no_ERRCODE_handler__>:
    b23c:	e8 5b e4 ff ff       	call   969c <__exception_no_ERRCODE__>
    b241:	cf                   	iret   
    b242:	66 90                	xchg   %ax,%ax
    b244:	66 90                	xchg   %ax,%ax
    b246:	66 90                	xchg   %ax,%ax
    b248:	66 90                	xchg   %ax,%ax
    b24a:	66 90                	xchg   %ax,%ax
    b24c:	66 90                	xchg   %ax,%ax
    b24e:	66 90                	xchg   %ax,%ax

0000b250 <gdtr>:
    b250:	00 00                	add    %al,(%eax)
    b252:	00 00                	add    %al,(%eax)
	...

0000b256 <load_gdt>:
    b256:	fa                   	cli    
    b257:	50                   	push   %eax
    b258:	51                   	push   %ecx
    b259:	b9 00 00 00 00       	mov    $0x0,%ecx
    b25e:	89 0d 52 b2 00 00    	mov    %ecx,0xb252
    b264:	31 c0                	xor    %eax,%eax
    b266:	b8 00 01 00 00       	mov    $0x100,%eax
    b26b:	01 c8                	add    %ecx,%eax
    b26d:	66 a3 50 b2 00 00    	mov    %ax,0xb250
    b273:	0f 01 15 50 b2 00 00 	lgdtl  0xb250
    b27a:	8b 0d 52 b2 00 00    	mov    0xb252,%ecx
    b280:	83 c1 20             	add    $0x20,%ecx
    b283:	0f 00 d9             	ltr    %cx
    b286:	59                   	pop    %ecx
    b287:	58                   	pop    %eax
    b288:	c3                   	ret    

0000b289 <idtr>:
    b289:	00 00                	add    %al,(%eax)
    b28b:	00 00                	add    %al,(%eax)
	...

0000b28f <load_idt>:
    b28f:	fa                   	cli    
    b290:	50                   	push   %eax
    b291:	51                   	push   %ecx
    b292:	31 c9                	xor    %ecx,%ecx
    b294:	b9 20 00 01 00       	mov    $0x10020,%ecx
    b299:	89 0d 8b b2 00 00    	mov    %ecx,0xb28b
    b29f:	31 c0                	xor    %eax,%eax
    b2a1:	b8 00 04 00 00       	mov    $0x400,%eax
    b2a6:	01 c8                	add    %ecx,%eax
    b2a8:	66 a3 89 b2 00 00    	mov    %ax,0xb289
    b2ae:	0f 01 1d 89 b2 00 00 	lidtl  0xb289
    b2b5:	59                   	pop    %ecx
    b2b6:	58                   	pop    %eax
    b2b7:	c3                   	ret    
    b2b8:	66 90                	xchg   %ax,%ax
    b2ba:	66 90                	xchg   %ax,%ax
    b2bc:	66 90                	xchg   %ax,%ax
    b2be:	66 90                	xchg   %ax,%ax

0000b2c0 <irq1>:
    b2c0:	60                   	pusha  
    b2c1:	e8 6e ea ff ff       	call   9d34 <irq1_handler>
    b2c6:	61                   	popa   
    b2c7:	cf                   	iret   

0000b2c8 <irq2>:
    b2c8:	60                   	pusha  
    b2c9:	e8 81 ea ff ff       	call   9d4f <irq2_handler>
    b2ce:	61                   	popa   
    b2cf:	cf                   	iret   

0000b2d0 <irq3>:
    b2d0:	60                   	pusha  
    b2d1:	e8 9c ea ff ff       	call   9d72 <irq3_handler>
    b2d6:	61                   	popa   
    b2d7:	cf                   	iret   

0000b2d8 <irq4>:
    b2d8:	60                   	pusha  
    b2d9:	e8 b7 ea ff ff       	call   9d95 <irq4_handler>
    b2de:	61                   	popa   
    b2df:	cf                   	iret   

0000b2e0 <irq5>:
    b2e0:	60                   	pusha  
    b2e1:	e8 d2 ea ff ff       	call   9db8 <irq5_handler>
    b2e6:	61                   	popa   
    b2e7:	cf                   	iret   

0000b2e8 <irq6>:
    b2e8:	60                   	pusha  
    b2e9:	e8 ed ea ff ff       	call   9ddb <irq6_handler>
    b2ee:	61                   	popa   
    b2ef:	cf                   	iret   

0000b2f0 <irq7>:
    b2f0:	60                   	pusha  
    b2f1:	e8 08 eb ff ff       	call   9dfe <irq7_handler>
    b2f6:	61                   	popa   
    b2f7:	cf                   	iret   

0000b2f8 <irq8>:
    b2f8:	60                   	pusha  
    b2f9:	e8 23 eb ff ff       	call   9e21 <irq8_handler>
    b2fe:	61                   	popa   
    b2ff:	cf                   	iret   

0000b300 <irq9>:
    b300:	60                   	pusha  
    b301:	e8 3e eb ff ff       	call   9e44 <irq9_handler>
    b306:	61                   	popa   
    b307:	cf                   	iret   

0000b308 <irq10>:
    b308:	60                   	pusha  
    b309:	e8 59 eb ff ff       	call   9e67 <irq10_handler>
    b30e:	61                   	popa   
    b30f:	cf                   	iret   

0000b310 <irq11>:
    b310:	60                   	pusha  
    b311:	e8 74 eb ff ff       	call   9e8a <irq11_handler>
    b316:	61                   	popa   
    b317:	cf                   	iret   

0000b318 <irq12>:
    b318:	60                   	pusha  
    b319:	e8 8f eb ff ff       	call   9ead <irq12_handler>
    b31e:	61                   	popa   
    b31f:	cf                   	iret   

0000b320 <irq13>:
    b320:	60                   	pusha  
    b321:	e8 aa eb ff ff       	call   9ed0 <irq13_handler>
    b326:	61                   	popa   
    b327:	cf                   	iret   

0000b328 <irq14>:
    b328:	60                   	pusha  
    b329:	e8 c5 eb ff ff       	call   9ef3 <irq14_handler>
    b32e:	61                   	popa   
    b32f:	cf                   	iret   

0000b330 <irq15>:
    b330:	60                   	pusha  
    b331:	e8 e0 eb ff ff       	call   9f16 <irq15_handler>
    b336:	61                   	popa   
    b337:	cf                   	iret   
    b338:	66 90                	xchg   %ax,%ax
    b33a:	66 90                	xchg   %ax,%ax
    b33c:	66 90                	xchg   %ax,%ax
    b33e:	66 90                	xchg   %ax,%ax

0000b340 <_FlushPagingCache_>:
    b340:	b8 00 10 01 00       	mov    $0x11000,%eax
    b345:	0f 22 d8             	mov    %eax,%cr3
    b348:	c3                   	ret    

0000b349 <_EnablingPaging_>:
    b349:	e8 f2 ff ff ff       	call   b340 <_FlushPagingCache_>
    b34e:	0f 20 c0             	mov    %cr0,%eax
    b351:	0d 01 00 00 80       	or     $0x80000001,%eax
    b356:	0f 22 c0             	mov    %eax,%cr0
    b359:	c3                   	ret    

0000b35a <PagingFault_Handler>:
    b35a:	58                   	pop    %eax
    b35b:	a3 80 b6 00 00       	mov    %eax,0xb680
    b360:	e8 13 f0 ff ff       	call   a378 <Paging_fault>
    b365:	cf                   	iret   
    b366:	66 90                	xchg   %ax,%ax
    b368:	66 90                	xchg   %ax,%ax
    b36a:	66 90                	xchg   %ax,%ax
    b36c:	66 90                	xchg   %ax,%ax
    b36e:	66 90                	xchg   %ax,%ax

0000b370 <PIT_handler>:
    b370:	9c                   	pushf  
    b371:	e8 16 00 00 00       	call   b38c <irq_PIT>
    b376:	e8 44 f2 ff ff       	call   a5bf <conserv_status_byte>
    b37b:	e8 db f2 ff ff       	call   a65b <sheduler_cpu_timer>
    b380:	90                   	nop
    b381:	90                   	nop
    b382:	90                   	nop
    b383:	90                   	nop
    b384:	90                   	nop
    b385:	90                   	nop
    b386:	90                   	nop
    b387:	90                   	nop
    b388:	90                   	nop
    b389:	90                   	nop
    b38a:	9d                   	popf   
    b38b:	cf                   	iret   

0000b38c <irq_PIT>:
    b38c:	a1 68 32 02 00       	mov    0x23268,%eax
    b391:	8b 1d 6c 32 02 00    	mov    0x2326c,%ebx
    b397:	01 05 60 32 02 00    	add    %eax,0x23260
    b39d:	11 1d 64 32 02 00    	adc    %ebx,0x23264
    b3a3:	6a 00                	push   $0x0
    b3a5:	e8 d4 ef ff ff       	call   a37e <PIC_sendEOI>
    b3aa:	58                   	pop    %eax
    b3ab:	c3                   	ret    

0000b3ac <calculate_frequency>:
    b3ac:	60                   	pusha  
    b3ad:	8b 1d 04 20 01 00    	mov    0x12004,%ebx
    b3b3:	b8 00 00 01 00       	mov    $0x10000,%eax
    b3b8:	83 fb 12             	cmp    $0x12,%ebx
    b3bb:	76 34                	jbe    b3f1 <calculate_frequency.gotReloadValue>
    b3bd:	b8 01 00 00 00       	mov    $0x1,%eax
    b3c2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    b3c8:	73 27                	jae    b3f1 <calculate_frequency.gotReloadValue>
    b3ca:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b3cf:	ba 00 00 00 00       	mov    $0x0,%edx
    b3d4:	f7 f3                	div    %ebx
    b3d6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b3dc:	72 01                	jb     b3df <calculate_frequency.l1>
    b3de:	40                   	inc    %eax

0000b3df <calculate_frequency.l1>:
    b3df:	bb 03 00 00 00       	mov    $0x3,%ebx
    b3e4:	ba 00 00 00 00       	mov    $0x0,%edx
    b3e9:	f7 f3                	div    %ebx
    b3eb:	83 fa 01             	cmp    $0x1,%edx
    b3ee:	72 01                	jb     b3f1 <calculate_frequency.gotReloadValue>
    b3f0:	40                   	inc    %eax

0000b3f1 <calculate_frequency.gotReloadValue>:
    b3f1:	50                   	push   %eax
    b3f2:	66 a3 74 32 02 00    	mov    %ax,0x23274
    b3f8:	89 c3                	mov    %eax,%ebx
    b3fa:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b3ff:	ba 00 00 00 00       	mov    $0x0,%edx
    b404:	f7 f3                	div    %ebx
    b406:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b40c:	72 01                	jb     b40f <calculate_frequency.l3>
    b40e:	40                   	inc    %eax

0000b40f <calculate_frequency.l3>:
    b40f:	bb 03 00 00 00       	mov    $0x3,%ebx
    b414:	ba 00 00 00 00       	mov    $0x0,%edx
    b419:	f7 f3                	div    %ebx
    b41b:	83 fa 01             	cmp    $0x1,%edx
    b41e:	72 01                	jb     b421 <calculate_frequency.l4>
    b420:	40                   	inc    %eax

0000b421 <calculate_frequency.l4>:
    b421:	a3 70 32 02 00       	mov    %eax,0x23270
    b426:	5b                   	pop    %ebx
    b427:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    b42c:	f7 e3                	mul    %ebx
    b42e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    b432:	c1 ea 0a             	shr    $0xa,%edx
    b435:	89 15 6c 32 02 00    	mov    %edx,0x2326c
    b43b:	a3 68 32 02 00       	mov    %eax,0x23268
    b440:	61                   	popa   
    b441:	c3                   	ret    
    b442:	66 90                	xchg   %ax,%ax
    b444:	66 90                	xchg   %ax,%ax
    b446:	66 90                	xchg   %ax,%ax
    b448:	66 90                	xchg   %ax,%ax
    b44a:	66 90                	xchg   %ax,%ax
    b44c:	66 90                	xchg   %ax,%ax
    b44e:	66 90                	xchg   %ax,%ax

0000b450 <switch_to_task>:
    b450:	50                   	push   %eax
    b451:	8b 44 24 08          	mov    0x8(%esp),%eax
    b455:	89 58 04             	mov    %ebx,0x4(%eax)
    b458:	89 48 08             	mov    %ecx,0x8(%eax)
    b45b:	89 50 0c             	mov    %edx,0xc(%eax)
    b45e:	89 70 10             	mov    %esi,0x10(%eax)
    b461:	89 78 14             	mov    %edi,0x14(%eax)
    b464:	89 60 18             	mov    %esp,0x18(%eax)
    b467:	89 68 1c             	mov    %ebp,0x1c(%eax)
    b46a:	51                   	push   %ecx
    b46b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    b46f:	89 48 20             	mov    %ecx,0x20(%eax)
    b472:	59                   	pop    %ecx
    b473:	51                   	push   %ecx
    b474:	9c                   	pushf  
    b475:	59                   	pop    %ecx
    b476:	89 48 24             	mov    %ecx,0x24(%eax)
    b479:	59                   	pop    %ecx
    b47a:	51                   	push   %ecx
    b47b:	0f 20 d9             	mov    %cr3,%ecx
    b47e:	89 48 28             	mov    %ecx,0x28(%eax)
    b481:	59                   	pop    %ecx
    b482:	8c 40 2c             	mov    %es,0x2c(%eax)
    b485:	8c 68 2e             	mov    %gs,0x2e(%eax)
    b488:	8c 60 30             	mov    %fs,0x30(%eax)
    b48b:	51                   	push   %ecx
    b48c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    b490:	89 08                	mov    %ecx,(%eax)
    b492:	59                   	pop    %ecx
    b493:	58                   	pop    %eax
    b494:	8b 44 24 08          	mov    0x8(%esp),%eax
    b498:	8b 58 04             	mov    0x4(%eax),%ebx
    b49b:	8b 48 08             	mov    0x8(%eax),%ecx
    b49e:	8b 50 0c             	mov    0xc(%eax),%edx
    b4a1:	8b 70 10             	mov    0x10(%eax),%esi
    b4a4:	8b 78 14             	mov    0x14(%eax),%edi
    b4a7:	8b 60 18             	mov    0x18(%eax),%esp
    b4aa:	8b 68 1c             	mov    0x1c(%eax),%ebp
    b4ad:	51                   	push   %ecx
    b4ae:	8b 48 24             	mov    0x24(%eax),%ecx
    b4b1:	51                   	push   %ecx
    b4b2:	9d                   	popf   
    b4b3:	59                   	pop    %ecx
    b4b4:	51                   	push   %ecx
    b4b5:	8b 48 28             	mov    0x28(%eax),%ecx
    b4b8:	0f 22 d9             	mov    %ecx,%cr3
    b4bb:	59                   	pop    %ecx
    b4bc:	8e 40 2c             	mov    0x2c(%eax),%es
    b4bf:	8e 68 2e             	mov    0x2e(%eax),%gs
    b4c2:	8e 60 30             	mov    0x30(%eax),%fs
    b4c5:	8b 40 20             	mov    0x20(%eax),%eax
    b4c8:	89 04 24             	mov    %eax,(%esp)
    b4cb:	c3                   	ret    
