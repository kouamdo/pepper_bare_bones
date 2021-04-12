
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
    9007:	e8 1f 07 00 00       	call   972b <init_gdt>

    init_idt();
    900c:	e8 53 08 00 00       	call   9864 <init_idt>

    init_console();
    9011:	e8 6a 06 00 00       	call   9680 <init_console>

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
    9029:	83 ec 08             	sub    $0x8,%esp
    902c:	50                   	push   %eax
    902d:	6a 07                	push   $0x7
    902f:	e8 c3 04 00 00       	call   94f7 <cputchar>
    9034:	83 c4 10             	add    $0x10,%esp
}
    9037:	90                   	nop
    9038:	c9                   	leave  
    9039:	c3                   	ret    

0000903a <printnum>:

static void printnum(uint32_t num, uint8_t base)
{
    903a:	55                   	push   %ebp
    903b:	89 e5                	mov    %esp,%ebp
    903d:	53                   	push   %ebx
    903e:	83 ec 14             	sub    $0x14,%esp
    9041:	8b 45 0c             	mov    0xc(%ebp),%eax
    9044:	88 45 f4             	mov    %al,-0xc(%ebp)
    if (num >= base) printnum((uint32_t)(num / base), base);
    9047:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    904b:	39 45 08             	cmp    %eax,0x8(%ebp)
    904e:	72 1f                	jb     906f <printnum+0x35>
    9050:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    9054:	0f b6 5d f4          	movzbl -0xc(%ebp),%ebx
    9058:	8b 45 08             	mov    0x8(%ebp),%eax
    905b:	ba 00 00 00 00       	mov    $0x0,%edx
    9060:	f7 f3                	div    %ebx
    9062:	83 ec 08             	sub    $0x8,%esp
    9065:	51                   	push   %ecx
    9066:	50                   	push   %eax
    9067:	e8 ce ff ff ff       	call   903a <printnum>
    906c:	83 c4 10             	add    $0x10,%esp

    putchar("0123456789abcdef"[num % base]);
    906f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    9073:	8b 45 08             	mov    0x8(%ebp),%eax
    9076:	ba 00 00 00 00       	mov    $0x0,%edx
    907b:	f7 f1                	div    %ecx
    907d:	89 d0                	mov    %edx,%eax
    907f:	0f b6 80 00 f0 00 00 	movzbl 0xf000(%eax),%eax
    9086:	0f b6 c0             	movzbl %al,%eax
    9089:	83 ec 0c             	sub    $0xc,%esp
    908c:	50                   	push   %eax
    908d:	e8 87 ff ff ff       	call   9019 <putchar>
    9092:	83 c4 10             	add    $0x10,%esp
}
    9095:	90                   	nop
    9096:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    9099:	c9                   	leave  
    909a:	c3                   	ret    

0000909b <printf>:

void printf(const char* fmt, va_list arg)
{
    909b:	55                   	push   %ebp
    909c:	89 e5                	mov    %esp,%ebp
    909e:	83 ec 18             	sub    $0x18,%esp
    char*    s;
    int*     p;

    const char* chr_tmp;

    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    90a1:	8b 45 08             	mov    0x8(%ebp),%eax
    90a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    90a7:	e9 36 01 00 00       	jmp    91e2 <printf+0x147>

        if (*chr_tmp == '%') {
    90ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90af:	0f b6 00             	movzbl (%eax),%eax
    90b2:	3c 25                	cmp    $0x25,%al
    90b4:	0f 85 0c 01 00 00    	jne    91c6 <printf+0x12b>
            chr_tmp++;
    90ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            switch (*chr_tmp) {
    90be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90c1:	0f b6 00             	movzbl (%eax),%eax
    90c4:	0f be c0             	movsbl %al,%eax
    90c7:	83 e8 62             	sub    $0x62,%eax
    90ca:	83 f8 16             	cmp    $0x16,%eax
    90cd:	0f 87 0a 01 00 00    	ja     91dd <printf+0x142>
    90d3:	8b 04 85 14 f0 00 00 	mov    0xf014(,%eax,4),%eax
    90da:	ff e0                	jmp    *%eax
            case 'c':
                i = va_arg(arg, int32_t);
    90dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    90df:	8d 50 04             	lea    0x4(%eax),%edx
    90e2:	89 55 0c             	mov    %edx,0xc(%ebp)
    90e5:	8b 00                	mov    (%eax),%eax
    90e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
                putchar(i);
    90ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
    90ed:	0f b6 c0             	movzbl %al,%eax
    90f0:	83 ec 0c             	sub    $0xc,%esp
    90f3:	50                   	push   %eax
    90f4:	e8 20 ff ff ff       	call   9019 <putchar>
    90f9:	83 c4 10             	add    $0x10,%esp
                break;
    90fc:	e9 dd 00 00 00       	jmp    91de <printf+0x143>
            case 'd':
                i = va_arg(arg, int);
    9101:	8b 45 0c             	mov    0xc(%ebp),%eax
    9104:	8d 50 04             	lea    0x4(%eax),%edx
    9107:	89 55 0c             	mov    %edx,0xc(%ebp)
    910a:	8b 00                	mov    (%eax),%eax
    910c:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 10);
    910f:	83 ec 08             	sub    $0x8,%esp
    9112:	6a 0a                	push   $0xa
    9114:	ff 75 f0             	pushl  -0x10(%ebp)
    9117:	e8 1e ff ff ff       	call   903a <printnum>
    911c:	83 c4 10             	add    $0x10,%esp
                break;
    911f:	e9 ba 00 00 00       	jmp    91de <printf+0x143>
            case 'o':
                i = va_arg(arg, int32_t);
    9124:	8b 45 0c             	mov    0xc(%ebp),%eax
    9127:	8d 50 04             	lea    0x4(%eax),%edx
    912a:	89 55 0c             	mov    %edx,0xc(%ebp)
    912d:	8b 00                	mov    (%eax),%eax
    912f:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 8);
    9132:	83 ec 08             	sub    $0x8,%esp
    9135:	6a 08                	push   $0x8
    9137:	ff 75 f0             	pushl  -0x10(%ebp)
    913a:	e8 fb fe ff ff       	call   903a <printnum>
    913f:	83 c4 10             	add    $0x10,%esp
                break;
    9142:	e9 97 00 00 00       	jmp    91de <printf+0x143>
            case 'b':
                i = va_arg(arg, int32_t);
    9147:	8b 45 0c             	mov    0xc(%ebp),%eax
    914a:	8d 50 04             	lea    0x4(%eax),%edx
    914d:	89 55 0c             	mov    %edx,0xc(%ebp)
    9150:	8b 00                	mov    (%eax),%eax
    9152:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 2);
    9155:	83 ec 08             	sub    $0x8,%esp
    9158:	6a 02                	push   $0x2
    915a:	ff 75 f0             	pushl  -0x10(%ebp)
    915d:	e8 d8 fe ff ff       	call   903a <printnum>
    9162:	83 c4 10             	add    $0x10,%esp
                break;
    9165:	eb 77                	jmp    91de <printf+0x143>
            case 'x':
                i = va_arg(arg, int32_t);
    9167:	8b 45 0c             	mov    0xc(%ebp),%eax
    916a:	8d 50 04             	lea    0x4(%eax),%edx
    916d:	89 55 0c             	mov    %edx,0xc(%ebp)
    9170:	8b 00                	mov    (%eax),%eax
    9172:	89 45 f0             	mov    %eax,-0x10(%ebp)
                printnum(i, 16);
    9175:	83 ec 08             	sub    $0x8,%esp
    9178:	6a 10                	push   $0x10
    917a:	ff 75 f0             	pushl  -0x10(%ebp)
    917d:	e8 b8 fe ff ff       	call   903a <printnum>
    9182:	83 c4 10             	add    $0x10,%esp
                break;
    9185:	eb 57                	jmp    91de <printf+0x143>
            case 's':
                s = va_arg(arg, char*);
    9187:	8b 45 0c             	mov    0xc(%ebp),%eax
    918a:	8d 50 04             	lea    0x4(%eax),%edx
    918d:	89 55 0c             	mov    %edx,0xc(%ebp)
    9190:	8b 00                	mov    (%eax),%eax
    9192:	89 45 ec             	mov    %eax,-0x14(%ebp)
                puts(s);
    9195:	83 ec 0c             	sub    $0xc,%esp
    9198:	ff 75 ec             	pushl  -0x14(%ebp)
    919b:	e8 54 00 00 00       	call   91f4 <puts>
    91a0:	83 c4 10             	add    $0x10,%esp
                break;
    91a3:	eb 39                	jmp    91de <printf+0x143>
            case 'p':
                p = va_arg(arg, void*);
    91a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    91a8:	8d 50 04             	lea    0x4(%eax),%edx
    91ab:	89 55 0c             	mov    %edx,0xc(%ebp)
    91ae:	8b 00                	mov    (%eax),%eax
    91b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
                printnum((uint32_t)p, 16);
    91b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    91b6:	83 ec 08             	sub    $0x8,%esp
    91b9:	6a 10                	push   $0x10
    91bb:	50                   	push   %eax
    91bc:	e8 79 fe ff ff       	call   903a <printnum>
    91c1:	83 c4 10             	add    $0x10,%esp
                break;
    91c4:	eb 18                	jmp    91de <printf+0x143>
                break;
            }
        }

        else
            putchar(*chr_tmp);
    91c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91c9:	0f b6 00             	movzbl (%eax),%eax
    91cc:	0f b6 c0             	movzbl %al,%eax
    91cf:	83 ec 0c             	sub    $0xc,%esp
    91d2:	50                   	push   %eax
    91d3:	e8 41 fe ff ff       	call   9019 <putchar>
    91d8:	83 c4 10             	add    $0x10,%esp
    91db:	eb 01                	jmp    91de <printf+0x143>
                break;
    91dd:	90                   	nop
    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    91de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    91e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91e5:	0f b6 00             	movzbl (%eax),%eax
    91e8:	84 c0                	test   %al,%al
    91ea:	0f 85 bc fe ff ff    	jne    90ac <printf+0x11>
    }

    va_end(arg);
}
    91f0:	90                   	nop
    91f1:	90                   	nop
    91f2:	c9                   	leave  
    91f3:	c3                   	ret    

000091f4 <puts>:

void puts(const char* string)
{
    91f4:	55                   	push   %ebp
    91f5:	89 e5                	mov    %esp,%ebp
    91f7:	83 ec 08             	sub    $0x8,%esp
    if (*string != '\0') {
    91fa:	8b 45 08             	mov    0x8(%ebp),%eax
    91fd:	0f b6 00             	movzbl (%eax),%eax
    9200:	84 c0                	test   %al,%al
    9202:	74 2a                	je     922e <puts+0x3a>
        putchar(*string);
    9204:	8b 45 08             	mov    0x8(%ebp),%eax
    9207:	0f b6 00             	movzbl (%eax),%eax
    920a:	0f b6 c0             	movzbl %al,%eax
    920d:	83 ec 0c             	sub    $0xc,%esp
    9210:	50                   	push   %eax
    9211:	e8 03 fe ff ff       	call   9019 <putchar>
    9216:	83 c4 10             	add    $0x10,%esp
        puts(string++);
    9219:	8b 45 08             	mov    0x8(%ebp),%eax
    921c:	8d 50 01             	lea    0x1(%eax),%edx
    921f:	89 55 08             	mov    %edx,0x8(%ebp)
    9222:	83 ec 0c             	sub    $0xc,%esp
    9225:	50                   	push   %eax
    9226:	e8 c9 ff ff ff       	call   91f4 <puts>
    922b:	83 c4 10             	add    $0x10,%esp
    }
    922e:	90                   	nop
    922f:	c9                   	leave  
    9230:	c3                   	ret    

00009231 <_strcmp_>:
#include "../../include/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    9231:	55                   	push   %ebp
    9232:	89 e5                	mov    %esp,%ebp
    9234:	53                   	push   %ebx
    9235:	83 ec 04             	sub    $0x4,%esp
    if (_strlen_(str2) != _strlen_(str1))
    9238:	83 ec 0c             	sub    $0xc,%esp
    923b:	ff 75 0c             	pushl  0xc(%ebp)
    923e:	e8 59 00 00 00       	call   929c <_strlen_>
    9243:	83 c4 10             	add    $0x10,%esp
    9246:	89 c3                	mov    %eax,%ebx
    9248:	83 ec 0c             	sub    $0xc,%esp
    924b:	ff 75 08             	pushl  0x8(%ebp)
    924e:	e8 49 00 00 00       	call   929c <_strlen_>
    9253:	83 c4 10             	add    $0x10,%esp
    9256:	38 c3                	cmp    %al,%bl
    9258:	74 0f                	je     9269 <_strcmp_+0x38>
        return 0;
    925a:	b8 00 00 00 00       	mov    $0x0,%eax
    925f:	eb 36                	jmp    9297 <_strcmp_+0x66>

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
    9261:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        str2++;
    9265:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while ((*str1 == *str2) && (*str1 != '\000')) {
    9269:	8b 45 08             	mov    0x8(%ebp),%eax
    926c:	0f b6 10             	movzbl (%eax),%edx
    926f:	8b 45 0c             	mov    0xc(%ebp),%eax
    9272:	0f b6 00             	movzbl (%eax),%eax
    9275:	38 c2                	cmp    %al,%dl
    9277:	75 0a                	jne    9283 <_strcmp_+0x52>
    9279:	8b 45 08             	mov    0x8(%ebp),%eax
    927c:	0f b6 00             	movzbl (%eax),%eax
    927f:	84 c0                	test   %al,%al
    9281:	75 de                	jne    9261 <_strcmp_+0x30>
    }

    return *str1 == *str2;
    9283:	8b 45 08             	mov    0x8(%ebp),%eax
    9286:	0f b6 10             	movzbl (%eax),%edx
    9289:	8b 45 0c             	mov    0xc(%ebp),%eax
    928c:	0f b6 00             	movzbl (%eax),%eax
    928f:	38 c2                	cmp    %al,%dl
    9291:	0f 94 c0             	sete   %al
    9294:	0f b6 c0             	movzbl %al,%eax
}
    9297:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    929a:	c9                   	leave  
    929b:	c3                   	ret    

0000929c <_strlen_>:

uint8_t _strlen_(char* str)
{
    929c:	55                   	push   %ebp
    929d:	89 e5                	mov    %esp,%ebp
    929f:	83 ec 10             	sub    $0x10,%esp
    if (*str == '\000')
    92a2:	8b 45 08             	mov    0x8(%ebp),%eax
    92a5:	0f b6 00             	movzbl (%eax),%eax
    92a8:	84 c0                	test   %al,%al
    92aa:	75 07                	jne    92b3 <_strlen_+0x17>
        return 0;
    92ac:	b8 00 00 00 00       	mov    $0x0,%eax
    92b1:	eb 22                	jmp    92d5 <_strlen_+0x39>

    uint8_t i = 1;
    92b3:	c6 45 ff 01          	movb   $0x1,-0x1(%ebp)

    while (*str != '\000') {
    92b7:	eb 0e                	jmp    92c7 <_strlen_+0x2b>
        str++;
    92b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        i++;
    92bd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    92c1:	83 c0 01             	add    $0x1,%eax
    92c4:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (*str != '\000') {
    92c7:	8b 45 08             	mov    0x8(%ebp),%eax
    92ca:	0f b6 00             	movzbl (%eax),%eax
    92cd:	84 c0                	test   %al,%al
    92cf:	75 e8                	jne    92b9 <_strlen_+0x1d>
    }

    return i;
    92d1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
    92d5:	c9                   	leave  
    92d6:	c3                   	ret    

000092d7 <_strcpy_>:

void* _strcpy_(char* dest, char* src)
{
    92d7:	55                   	push   %ebp
    92d8:	89 e5                	mov    %esp,%ebp
    92da:	83 ec 10             	sub    $0x10,%esp
    if (dest == NULL)
    92dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    92e1:	75 07                	jne    92ea <_strcpy_+0x13>
        return (void*)NULL;
    92e3:	b8 00 00 00 00       	mov    $0x0,%eax
    92e8:	eb 46                	jmp    9330 <_strcpy_+0x59>

    uint8_t i = 0;
    92ea:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    while (src[i] != '\000') {
    92ee:	eb 21                	jmp    9311 <_strcpy_+0x3a>
        dest[i] = src[i];
    92f0:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    92f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    92f7:	01 d0                	add    %edx,%eax
    92f9:	0f b6 4d ff          	movzbl -0x1(%ebp),%ecx
    92fd:	8b 55 08             	mov    0x8(%ebp),%edx
    9300:	01 ca                	add    %ecx,%edx
    9302:	0f b6 00             	movzbl (%eax),%eax
    9305:	88 02                	mov    %al,(%edx)
        i++;
    9307:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    930b:	83 c0 01             	add    $0x1,%eax
    930e:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (src[i] != '\000') {
    9311:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9315:	8b 45 0c             	mov    0xc(%ebp),%eax
    9318:	01 d0                	add    %edx,%eax
    931a:	0f b6 00             	movzbl (%eax),%eax
    931d:	84 c0                	test   %al,%al
    931f:	75 cf                	jne    92f0 <_strcpy_+0x19>
    }

    dest[i] = '\000';
    9321:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9325:	8b 45 08             	mov    0x8(%ebp),%eax
    9328:	01 d0                	add    %edx,%eax
    932a:	c6 00 00             	movb   $0x0,(%eax)

    return (void*)dest;
    932d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9330:	c9                   	leave  
    9331:	c3                   	ret    

00009332 <memcpy>:

void* memcpy(void* dest, const void* src, uint32_t size)
{
    9332:	55                   	push   %ebp
    9333:	89 e5                	mov    %esp,%ebp
    9335:	83 ec 10             	sub    $0x10,%esp
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    9338:	8b 45 08             	mov    0x8(%ebp),%eax
    933b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    _src_ = (char*)src;
    933e:	8b 45 0c             	mov    0xc(%ebp),%eax
    9341:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (size) {
    9344:	eb 1b                	jmp    9361 <memcpy+0x2f>
        *(_dest_++) = *(_src_++);
    9346:	8b 55 f8             	mov    -0x8(%ebp),%edx
    9349:	8d 42 01             	lea    0x1(%edx),%eax
    934c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    934f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9352:	8d 48 01             	lea    0x1(%eax),%ecx
    9355:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    9358:	0f b6 12             	movzbl (%edx),%edx
    935b:	88 10                	mov    %dl,(%eax)
        size--;
    935d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (size) {
    9361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    9365:	75 df                	jne    9346 <memcpy+0x14>
    }

    return (void*)dest;
    9367:	8b 45 08             	mov    0x8(%ebp),%eax
}
    936a:	c9                   	leave  
    936b:	c3                   	ret    

0000936c <memset>:

void* memset(void* mem, void* data, uint32_t size)
{
    936c:	55                   	push   %ebp
    936d:	89 e5                	mov    %esp,%ebp
    936f:	83 ec 10             	sub    $0x10,%esp
    if (!mem)
    9372:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    9376:	75 07                	jne    937f <memset+0x13>
        return NULL;
    9378:	b8 00 00 00 00       	mov    $0x0,%eax
    937d:	eb 21                	jmp    93a0 <memset+0x34>

    uint32_t* dest = mem;
    937f:	8b 45 08             	mov    0x8(%ebp),%eax
    9382:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (size) {
    9385:	eb 10                	jmp    9397 <memset+0x2b>
        *dest = (uint32_t)data;
    9387:	8b 55 0c             	mov    0xc(%ebp),%edx
    938a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    938d:	89 10                	mov    %edx,(%eax)
        size--;
    938f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
        dest += 4;
    9393:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    while (size) {
    9397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    939b:	75 ea                	jne    9387 <memset+0x1b>
    }

    return (void*)mem;
    939d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    93a0:	c9                   	leave  
    93a1:	c3                   	ret    

000093a2 <_memcmp_>:

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    93a2:	55                   	push   %ebp
    93a3:	89 e5                	mov    %esp,%ebp
    93a5:	83 ec 10             	sub    $0x10,%esp
    char* mem_1 = (char*)src_1;
    93a8:	8b 45 08             	mov    0x8(%ebp),%eax
    93ab:	89 45 fc             	mov    %eax,-0x4(%ebp)

    char* mem_2 = (char*)src_2;
    93ae:	8b 45 0c             	mov    0xc(%ebp),%eax
    93b1:	89 45 f8             	mov    %eax,-0x8(%ebp)

    uint32_t i = 0;
    93b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (i < size && *mem_1 == *mem_2) {
    93bb:	eb 0c                	jmp    93c9 <_memcmp_+0x27>
        i++;
    93bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        mem_1++;
    93c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
        mem_2++;
    93c5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (i < size && *mem_1 == *mem_2) {
    93c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    93cc:	3b 45 10             	cmp    0x10(%ebp),%eax
    93cf:	73 10                	jae    93e1 <_memcmp_+0x3f>
    93d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    93d4:	0f b6 10             	movzbl (%eax),%edx
    93d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    93da:	0f b6 00             	movzbl (%eax),%eax
    93dd:	38 c2                	cmp    %al,%dl
    93df:	74 dc                	je     93bd <_memcmp_+0x1b>
    }

    return i == size;
    93e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    93e4:	3b 45 10             	cmp    0x10(%ebp),%eax
    93e7:	0f 94 c0             	sete   %al
    93ea:	0f b6 c0             	movzbl %al,%eax
    93ed:	c9                   	leave  
    93ee:	c3                   	ret    

000093ef <cclean>:

void move_cursor(uint8_t x, uint8_t y);
void show_cursor(void);

void volatile cclean()
{
    93ef:	55                   	push   %ebp
    93f0:	89 e5                	mov    %esp,%ebp
    93f2:	83 ec 18             	sub    $0x18,%esp
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    93f5:	c7 45 f0 00 80 0b 00 	movl   $0xb8000,-0x10(%ebp)
    int            i      = 0;
    93fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i <= 160 * 25) {
    9403:	eb 1d                	jmp    9422 <cclean+0x33>
        screen[i]     = ' ';
    9405:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9408:	8b 45 f0             	mov    -0x10(%ebp),%eax
    940b:	01 d0                	add    %edx,%eax
    940d:	c6 00 20             	movb   $0x20,(%eax)
        screen[i + 1] = 0x0;
    9410:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9413:	8d 50 01             	lea    0x1(%eax),%edx
    9416:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9419:	01 d0                	add    %edx,%eax
    941b:	c6 00 00             	movb   $0x0,(%eax)
        i += 2;
    941e:	83 45 f4 02          	addl   $0x2,-0xc(%ebp)
    while (i <= 160 * 25) {
    9422:	81 7d f4 a0 0f 00 00 	cmpl   $0xfa0,-0xc(%ebp)
    9429:	7e da                	jle    9405 <cclean+0x16>
    }
    cputchar(READY_COLOR, 'K');
    942b:	83 ec 08             	sub    $0x8,%esp
    942e:	6a 4b                	push   $0x4b
    9430:	6a 07                	push   $0x7
    9432:	e8 c0 00 00 00       	call   94f7 <cputchar>
    9437:	83 c4 10             	add    $0x10,%esp
    cputchar(READY_COLOR, '>');
    943a:	83 ec 08             	sub    $0x8,%esp
    943d:	6a 3e                	push   $0x3e
    943f:	6a 07                	push   $0x7
    9441:	e8 b1 00 00 00       	call   94f7 <cputchar>
    9446:	83 c4 10             	add    $0x10,%esp
    cputchar(READY_COLOR, ' ');
    9449:	83 ec 08             	sub    $0x8,%esp
    944c:	6a 20                	push   $0x20
    944e:	6a 07                	push   $0x7
    9450:	e8 a2 00 00 00       	call   94f7 <cputchar>
    9455:	83 c4 10             	add    $0x10,%esp

    CURSOR_X = 3;
    9458:	c7 05 04 00 01 00 03 	movl   $0x3,0x10004
    945f:	00 00 00 
    CURSOR_Y = 0;
    9462:	c7 05 00 00 01 00 00 	movl   $0x0,0x10000
    9469:	00 00 00 
}
    946c:	90                   	nop
    946d:	c9                   	leave  
    946e:	c3                   	ret    

0000946f <cscrollup>:

void volatile cscrollup()
{
    946f:	55                   	push   %ebp
    9470:	89 e5                	mov    %esp,%ebp
    9472:	81 ec b8 00 00 00    	sub    $0xb8,%esp
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    9478:	c7 45 f0 00 8f 0b 00 	movl   $0xb8f00,-0x10(%ebp)
    unsigned char  b[160];
    int            i;
    for (i = 0; i < 160; i++)
    947f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9486:	eb 1c                	jmp    94a4 <cscrollup+0x35>
        b[i] = v[i];
    9488:	8b 55 f4             	mov    -0xc(%ebp),%edx
    948b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    948e:	01 d0                	add    %edx,%eax
    9490:	0f b6 00             	movzbl (%eax),%eax
    9493:	8d 8d 50 ff ff ff    	lea    -0xb0(%ebp),%ecx
    9499:	8b 55 f4             	mov    -0xc(%ebp),%edx
    949c:	01 ca                	add    %ecx,%edx
    949e:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    94a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    94a4:	81 7d f4 9f 00 00 00 	cmpl   $0x9f,-0xc(%ebp)
    94ab:	7e db                	jle    9488 <cscrollup+0x19>

    cclean();
    94ad:	e8 3d ff ff ff       	call   93ef <cclean>

    v = (unsigned char*)(VIDEO_MEM);
    94b2:	c7 45 f0 00 80 0b 00 	movl   $0xb8000,-0x10(%ebp)

    for (i = 0; i < 160; i++)
    94b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    94c0:	eb 1c                	jmp    94de <cscrollup+0x6f>
        v[i] = b[i];
    94c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    94c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    94c8:	01 c2                	add    %eax,%edx
    94ca:	8d 8d 50 ff ff ff    	lea    -0xb0(%ebp),%ecx
    94d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    94d3:	01 c8                	add    %ecx,%eax
    94d5:	0f b6 00             	movzbl (%eax),%eax
    94d8:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    94da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    94de:	81 7d f4 9f 00 00 00 	cmpl   $0x9f,-0xc(%ebp)
    94e5:	7e db                	jle    94c2 <cscrollup+0x53>

    CURSOR_Y++;
    94e7:	a1 00 00 01 00       	mov    0x10000,%eax
    94ec:	83 c0 01             	add    $0x1,%eax
    94ef:	a3 00 00 01 00       	mov    %eax,0x10000
}
    94f4:	90                   	nop
    94f5:	c9                   	leave  
    94f6:	c3                   	ret    

000094f7 <cputchar>:

void volatile cputchar(unsigned char color, unsigned const char c)
{
    94f7:	55                   	push   %ebp
    94f8:	89 e5                	mov    %esp,%ebp
    94fa:	83 ec 28             	sub    $0x28,%esp
    94fd:	8b 55 08             	mov    0x8(%ebp),%edx
    9500:	8b 45 0c             	mov    0xc(%ebp),%eax
    9503:	88 55 e4             	mov    %dl,-0x1c(%ebp)
    9506:	88 45 e0             	mov    %al,-0x20(%ebp)

    if ((CURSOR_Y) <= (25)) {
    9509:	a1 00 00 01 00       	mov    0x10000,%eax
    950e:	83 f8 19             	cmp    $0x19,%eax
    9511:	0f 8f c0 00 00 00    	jg     95d7 <cputchar+0xe0>
        if (c == '\n') {
    9517:	80 7d e0 0a          	cmpb   $0xa,-0x20(%ebp)
    951b:	75 1c                	jne    9539 <cputchar+0x42>
            CURSOR_X = 0;
    951d:	c7 05 04 00 01 00 00 	movl   $0x0,0x10004
    9524:	00 00 00 
            CURSOR_Y++;
    9527:	a1 00 00 01 00       	mov    0x10000,%eax
    952c:	83 c0 01             	add    $0x1,%eax
    952f:	a3 00 00 01 00       	mov    %eax,0x10000
        }
    }

    else
        cclean();
}
    9534:	e9 a3 00 00 00       	jmp    95dc <cputchar+0xe5>
        else if (c == '\t')
    9539:	80 7d e0 09          	cmpb   $0x9,-0x20(%ebp)
    953d:	75 12                	jne    9551 <cputchar+0x5a>
            CURSOR_X += 5;
    953f:	a1 04 00 01 00       	mov    0x10004,%eax
    9544:	83 c0 05             	add    $0x5,%eax
    9547:	a3 04 00 01 00       	mov    %eax,0x10004
}
    954c:	e9 8b 00 00 00       	jmp    95dc <cputchar+0xe5>
        else if (c == 0x08)
    9551:	80 7d e0 08          	cmpb   $0x8,-0x20(%ebp)
    9555:	75 3a                	jne    9591 <cputchar+0x9a>
            CURSOR_X--;
    9557:	a1 04 00 01 00       	mov    0x10004,%eax
    955c:	83 e8 01             	sub    $0x1,%eax
    955f:	a3 04 00 01 00       	mov    %eax,0x10004
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9564:	c7 45 f0 00 80 0b 00 	movl   $0xb8000,-0x10(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    956b:	8b 15 00 00 01 00    	mov    0x10000,%edx
    9571:	89 d0                	mov    %edx,%eax
    9573:	c1 e0 02             	shl    $0x2,%eax
    9576:	01 d0                	add    %edx,%eax
    9578:	c1 e0 04             	shl    $0x4,%eax
    957b:	89 c2                	mov    %eax,%edx
    957d:	a1 04 00 01 00       	mov    0x10004,%eax
    9582:	01 d0                	add    %edx,%eax
    9584:	01 c0                	add    %eax,%eax
    9586:	01 45 f0             	add    %eax,-0x10(%ebp)
            *v = ' ';
    9589:	8b 45 f0             	mov    -0x10(%ebp),%eax
    958c:	c6 00 20             	movb   $0x20,(%eax)
}
    958f:	eb 4b                	jmp    95dc <cputchar+0xe5>
            uint8_t* v = (uint8_t*)VIDEO_MEM;
    9591:	c7 45 f4 00 80 0b 00 	movl   $0xb8000,-0xc(%ebp)
            v += 2 * CURSOR_X + 160 * CURSOR_Y;
    9598:	8b 15 00 00 01 00    	mov    0x10000,%edx
    959e:	89 d0                	mov    %edx,%eax
    95a0:	c1 e0 02             	shl    $0x2,%eax
    95a3:	01 d0                	add    %edx,%eax
    95a5:	c1 e0 04             	shl    $0x4,%eax
    95a8:	89 c2                	mov    %eax,%edx
    95aa:	a1 04 00 01 00       	mov    0x10004,%eax
    95af:	01 d0                	add    %edx,%eax
    95b1:	01 c0                	add    %eax,%eax
    95b3:	01 45 f4             	add    %eax,-0xc(%ebp)
            *v = c;
    95b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    95b9:	0f b6 55 e0          	movzbl -0x20(%ebp),%edx
    95bd:	88 10                	mov    %dl,(%eax)
            *(v + 1) = READY_COLOR;
    95bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    95c2:	83 c0 01             	add    $0x1,%eax
    95c5:	c6 00 07             	movb   $0x7,(%eax)
            CURSOR_X++;
    95c8:	a1 04 00 01 00       	mov    0x10004,%eax
    95cd:	83 c0 01             	add    $0x1,%eax
    95d0:	a3 04 00 01 00       	mov    %eax,0x10004
}
    95d5:	eb 05                	jmp    95dc <cputchar+0xe5>
        cclean();
    95d7:	e8 13 fe ff ff       	call   93ef <cclean>
}
    95dc:	90                   	nop
    95dd:	c9                   	leave  
    95de:	c3                   	ret    

000095df <move_cursor>:

void move_cursor(uint8_t x, uint8_t y)
{
    95df:	55                   	push   %ebp
    95e0:	89 e5                	mov    %esp,%ebp
    95e2:	83 ec 18             	sub    $0x18,%esp
    95e5:	8b 55 08             	mov    0x8(%ebp),%edx
    95e8:	8b 45 0c             	mov    0xc(%ebp),%eax
    95eb:	88 55 ec             	mov    %dl,-0x14(%ebp)
    95ee:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t c_pos;

    c_pos = y * 80 + x;
    95f1:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    95f5:	89 d0                	mov    %edx,%eax
    95f7:	c1 e0 02             	shl    $0x2,%eax
    95fa:	01 d0                	add    %edx,%eax
    95fc:	c1 e0 04             	shl    $0x4,%eax
    95ff:	89 c2                	mov    %eax,%edx
    9601:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    9605:	01 d0                	add    %edx,%eax
    9607:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    outb(0x3d4, 0x0f);
    960b:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9610:	b8 0f 00 00 00       	mov    $0xf,%eax
    9615:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)c_pos);
    9616:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    961a:	ba d5 03 00 00       	mov    $0x3d5,%edx
    961f:	ee                   	out    %al,(%dx)
    outb(0x3d4, 0x0e);
    9620:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9625:	b8 0e 00 00 00       	mov    $0xe,%eax
    962a:	ee                   	out    %al,(%dx)
    outb(0x3d5, (uint8_t)(c_pos >> 8));
    962b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    962f:	66 c1 e8 08          	shr    $0x8,%ax
    9633:	ba d5 03 00 00       	mov    $0x3d5,%edx
    9638:	ee                   	out    %al,(%dx)
}
    9639:	90                   	nop
    963a:	c9                   	leave  
    963b:	c3                   	ret    

0000963c <show_cursor>:

void show_cursor(void)
{
    963c:	55                   	push   %ebp
    963d:	89 e5                	mov    %esp,%ebp
    move_cursor(CURSOR_X, CURSOR_Y);
    963f:	a1 00 00 01 00       	mov    0x10000,%eax
    9644:	0f b6 d0             	movzbl %al,%edx
    9647:	a1 04 00 01 00       	mov    0x10004,%eax
    964c:	0f b6 c0             	movzbl %al,%eax
    964f:	52                   	push   %edx
    9650:	50                   	push   %eax
    9651:	e8 89 ff ff ff       	call   95df <move_cursor>
    9656:	83 c4 08             	add    $0x8,%esp
}
    9659:	90                   	nop
    965a:	c9                   	leave  
    965b:	c3                   	ret    

0000965c <console_service_keyboard>:

void console_service_keyboard()
{
    965c:	55                   	push   %ebp
    965d:	89 e5                	mov    %esp,%ebp
    965f:	83 ec 08             	sub    $0x8,%esp
    cputchar(READY_COLOR, get_ASCII_code_keyboard());
    9662:	e8 1d 0a 00 00       	call   a084 <get_ASCII_code_keyboard>
    9667:	0f b6 c0             	movzbl %al,%eax
    966a:	83 ec 08             	sub    $0x8,%esp
    966d:	50                   	push   %eax
    966e:	6a 07                	push   $0x7
    9670:	e8 82 fe ff ff       	call   94f7 <cputchar>
    9675:	83 c4 10             	add    $0x10,%esp
    show_cursor();
    9678:	e8 bf ff ff ff       	call   963c <show_cursor>
}
    967d:	90                   	nop
    967e:	c9                   	leave  
    967f:	c3                   	ret    

00009680 <init_console>:

void init_console()
{
    9680:	55                   	push   %ebp
    9681:	89 e5                	mov    %esp,%ebp
    9683:	83 ec 08             	sub    $0x8,%esp
    cclean();
    9686:	e8 64 fd ff ff       	call   93ef <cclean>
    kbd_init(); //Init keyboard
    968b:	e8 cf 08 00 00       	call   9f5f <kbd_init>
    //init Video graphics here
    9690:	90                   	nop
    9691:	c9                   	leave  
    9692:	c3                   	ret    

00009693 <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    9693:	55                   	push   %ebp
    9694:	89 e5                	mov    %esp,%ebp
    9696:	90                   	nop
    9697:	5d                   	pop    %ebp
    9698:	c3                   	ret    

00009699 <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    9699:	55                   	push   %ebp
    969a:	89 e5                	mov    %esp,%ebp
    969c:	90                   	nop
    969d:	5d                   	pop    %ebp
    969e:	c3                   	ret    

0000969f <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    969f:	55                   	push   %ebp
    96a0:	89 e5                	mov    %esp,%ebp
    96a2:	83 ec 08             	sub    $0x8,%esp
    96a5:	8b 55 10             	mov    0x10(%ebp),%edx
    96a8:	8b 45 14             	mov    0x14(%ebp),%eax
    96ab:	88 55 fc             	mov    %dl,-0x4(%ebp)
    96ae:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15 = (limite & 0xFFFF);
    96b1:	8b 45 0c             	mov    0xc(%ebp),%eax
    96b4:	89 c2                	mov    %eax,%edx
    96b6:	8b 45 18             	mov    0x18(%ebp),%eax
    96b9:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    96bc:	8b 45 0c             	mov    0xc(%ebp),%eax
    96bf:	c1 e8 10             	shr    $0x10,%eax
    96c2:	83 e0 0f             	and    $0xf,%eax
    96c5:	8b 55 18             	mov    0x18(%ebp),%edx
    96c8:	83 e0 0f             	and    $0xf,%eax
    96cb:	89 c1                	mov    %eax,%ecx
    96cd:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    96d1:	83 e0 f0             	and    $0xfffffff0,%eax
    96d4:	09 c8                	or     %ecx,%eax
    96d6:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15 = (base & 0xFFFF);
    96d9:	8b 45 08             	mov    0x8(%ebp),%eax
    96dc:	89 c2                	mov    %eax,%edx
    96de:	8b 45 18             	mov    0x18(%ebp),%eax
    96e1:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    96e5:	8b 45 08             	mov    0x8(%ebp),%eax
    96e8:	c1 e8 10             	shr    $0x10,%eax
    96eb:	89 c2                	mov    %eax,%edx
    96ed:	8b 45 18             	mov    0x18(%ebp),%eax
    96f0:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    96f3:	8b 45 08             	mov    0x8(%ebp),%eax
    96f6:	c1 e8 18             	shr    $0x18,%eax
    96f9:	89 c2                	mov    %eax,%edx
    96fb:	8b 45 18             	mov    0x18(%ebp),%eax
    96fe:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags = flags;
    9701:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    9705:	83 e0 0f             	and    $0xf,%eax
    9708:	89 c2                	mov    %eax,%edx
    970a:	8b 45 18             	mov    0x18(%ebp),%eax
    970d:	89 d1                	mov    %edx,%ecx
    970f:	c1 e1 04             	shl    $0x4,%ecx
    9712:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    9716:	83 e2 0f             	and    $0xf,%edx
    9719:	09 ca                	or     %ecx,%edx
    971b:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    971e:	8b 45 18             	mov    0x18(%ebp),%eax
    9721:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    9725:	88 50 05             	mov    %dl,0x5(%eax)
}
    9728:	90                   	nop
    9729:	c9                   	leave  
    972a:	c3                   	ret    

0000972b <init_gdt>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt(void)
{
    972b:	55                   	push   %ebp
    972c:	89 e5                	mov    %esp,%ebp
    972e:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    9731:	a1 08 00 01 00       	mov    0x10008,%eax
    9736:	50                   	push   %eax
    9737:	6a 00                	push   $0x0
    9739:	6a 00                	push   $0x0
    973b:	6a 00                	push   $0x0
    973d:	6a 00                	push   $0x0
    973f:	e8 5b ff ff ff       	call   969f <init_gdt_entry>
    9744:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    9747:	a1 08 00 01 00       	mov    0x10008,%eax
    974c:	83 c0 08             	add    $0x8,%eax
    974f:	50                   	push   %eax
    9750:	6a 04                	push   $0x4
    9752:	68 9a 00 00 00       	push   $0x9a
    9757:	68 ff ff 0f 00       	push   $0xfffff
    975c:	6a 00                	push   $0x0
    975e:	e8 3c ff ff ff       	call   969f <init_gdt_entry>
    9763:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    9766:	a1 08 00 01 00       	mov    0x10008,%eax
    976b:	83 c0 10             	add    $0x10,%eax
    976e:	50                   	push   %eax
    976f:	6a 04                	push   $0x4
    9771:	68 92 00 00 00       	push   $0x92
    9776:	68 ff ff 0f 00       	push   $0xfffff
    977b:	6a 00                	push   $0x0
    977d:	e8 1d ff ff ff       	call   969f <init_gdt_entry>
    9782:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    9785:	a1 08 00 01 00       	mov    0x10008,%eax
    978a:	83 c0 18             	add    $0x18,%eax
    978d:	50                   	push   %eax
    978e:	6a 04                	push   $0x4
    9790:	68 96 00 00 00       	push   $0x96
    9795:	68 ff ff 0f 00       	push   $0xfffff
    979a:	6a 00                	push   $0x0
    979c:	e8 fe fe ff ff       	call   969f <init_gdt_entry>
    97a1:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Segment de tâches
    init_gdt_entry(0, 0xFFFFFF, TSS_PRIVILEGE_0,
    97a4:	a1 08 00 01 00       	mov    0x10008,%eax
    97a9:	83 c0 20             	add    $0x20,%eax
    97ac:	50                   	push   %eax
    97ad:	6a 04                	push   $0x4
    97af:	68 89 00 00 00       	push   $0x89
    97b4:	68 ff ff ff 00       	push   $0xffffff
    97b9:	6a 00                	push   $0x0
    97bb:	e8 df fe ff ff       	call   969f <init_gdt_entry>
    97c0:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[4]);

    // Chargement de la GDT
    load_gdt();
    97c3:	e8 7e 1a 00 00       	call   b246 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    97c8:	66 b8 10 00          	mov    $0x10,%ax
    97cc:	8e d8                	mov    %eax,%ds
    97ce:	8e c0                	mov    %eax,%es
    97d0:	8e e0                	mov    %eax,%fs
    97d2:	8e e8                	mov    %eax,%gs
    97d4:	66 b8 18 00          	mov    $0x18,%ax
    97d8:	8e d0                	mov    %eax,%ss
    97da:	ea e1 97 00 00 08 00 	ljmp   $0x8,$0x97e1

000097e1 <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    97e1:	90                   	nop
    97e2:	c9                   	leave  
    97e3:	c3                   	ret    

000097e4 <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    97e4:	55                   	push   %ebp
    97e5:	89 e5                	mov    %esp,%ebp
    97e7:	83 ec 18             	sub    $0x18,%esp
    97ea:	8b 45 08             	mov    0x8(%ebp),%eax
    97ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    97f0:	8b 55 18             	mov    0x18(%ebp),%edx
    97f3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    97f7:	89 c8                	mov    %ecx,%eax
    97f9:	88 45 f8             	mov    %al,-0x8(%ebp)
    97fc:	8b 45 10             	mov    0x10(%ebp),%eax
    97ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    9802:	8b 45 14             	mov    0x14(%ebp),%eax
    9805:	89 45 f4             	mov    %eax,-0xc(%ebp)
    9808:	89 d0                	mov    %edx,%eax
    980a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    980e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9812:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    9816:	66 89 14 c5 22 00 01 	mov    %dx,0x10022(,%eax,8)
    981d:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    981e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9822:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    9826:	88 14 c5 25 00 01 00 	mov    %dl,0x10025(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    982d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9831:	c6 04 c5 24 00 01 00 	movb   $0x0,0x10024(,%eax,8)
    9838:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    9839:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    983d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    9840:	66 89 14 c5 20 00 01 	mov    %dx,0x10020(,%eax,8)
    9847:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    9848:	8b 45 f0             	mov    -0x10(%ebp),%eax
    984b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    984e:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    9852:	c1 ea 10             	shr    $0x10,%edx
    9855:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    9859:	66 89 04 cd 26 00 01 	mov    %ax,0x10026(,%ecx,8)
    9860:	00 
}
    9861:	90                   	nop
    9862:	c9                   	leave  
    9863:	c3                   	ret    

00009864 <init_idt>:

void init_idt()
{
    9864:	55                   	push   %ebp
    9865:	89 e5                	mov    %esp,%ebp
    9867:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    986a:	83 ec 0c             	sub    $0xc,%esp
    986d:	68 ad da 00 00       	push   $0xdaad
    9872:	e8 0d 0e 00 00       	call   a684 <Init_PIT>
    9877:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    987a:	83 ec 08             	sub    $0x8,%esp
    987d:	6a 28                	push   $0x28
    987f:	6a 20                	push   $0x20
    9881:	e8 11 0b 00 00       	call   a397 <PIC_remap>
    9886:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    9889:	b8 60 b3 00 00       	mov    $0xb360,%eax
    988e:	ba 00 00 00 00       	mov    $0x0,%edx
    9893:	83 ec 0c             	sub    $0xc,%esp
    9896:	6a 20                	push   $0x20
    9898:	52                   	push   %edx
    9899:	50                   	push   %eax
    989a:	68 8e 00 00 00       	push   $0x8e
    989f:	6a 08                	push   $0x8
    98a1:	e8 3e ff ff ff       	call   97e4 <set_idt>
    98a6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    98a9:	b8 b0 b2 00 00       	mov    $0xb2b0,%eax
    98ae:	ba 00 00 00 00       	mov    $0x0,%edx
    98b3:	83 ec 0c             	sub    $0xc,%esp
    98b6:	6a 21                	push   $0x21
    98b8:	52                   	push   %edx
    98b9:	50                   	push   %eax
    98ba:	68 8e 00 00 00       	push   $0x8e
    98bf:	6a 08                	push   $0x8
    98c1:	e8 1e ff ff ff       	call   97e4 <set_idt>
    98c6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    98c9:	b8 b8 b2 00 00       	mov    $0xb2b8,%eax
    98ce:	ba 00 00 00 00       	mov    $0x0,%edx
    98d3:	83 ec 0c             	sub    $0xc,%esp
    98d6:	6a 22                	push   $0x22
    98d8:	52                   	push   %edx
    98d9:	50                   	push   %eax
    98da:	68 8e 00 00 00       	push   $0x8e
    98df:	6a 08                	push   $0x8
    98e1:	e8 fe fe ff ff       	call   97e4 <set_idt>
    98e6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    98e9:	b8 c0 b2 00 00       	mov    $0xb2c0,%eax
    98ee:	ba 00 00 00 00       	mov    $0x0,%edx
    98f3:	83 ec 0c             	sub    $0xc,%esp
    98f6:	6a 23                	push   $0x23
    98f8:	52                   	push   %edx
    98f9:	50                   	push   %eax
    98fa:	68 8e 00 00 00       	push   $0x8e
    98ff:	6a 08                	push   $0x8
    9901:	e8 de fe ff ff       	call   97e4 <set_idt>
    9906:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    9909:	b8 c8 b2 00 00       	mov    $0xb2c8,%eax
    990e:	ba 00 00 00 00       	mov    $0x0,%edx
    9913:	83 ec 0c             	sub    $0xc,%esp
    9916:	6a 24                	push   $0x24
    9918:	52                   	push   %edx
    9919:	50                   	push   %eax
    991a:	68 8e 00 00 00       	push   $0x8e
    991f:	6a 08                	push   $0x8
    9921:	e8 be fe ff ff       	call   97e4 <set_idt>
    9926:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    9929:	b8 d0 b2 00 00       	mov    $0xb2d0,%eax
    992e:	ba 00 00 00 00       	mov    $0x0,%edx
    9933:	83 ec 0c             	sub    $0xc,%esp
    9936:	6a 25                	push   $0x25
    9938:	52                   	push   %edx
    9939:	50                   	push   %eax
    993a:	68 8e 00 00 00       	push   $0x8e
    993f:	6a 08                	push   $0x8
    9941:	e8 9e fe ff ff       	call   97e4 <set_idt>
    9946:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    9949:	b8 d8 b2 00 00       	mov    $0xb2d8,%eax
    994e:	ba 00 00 00 00       	mov    $0x0,%edx
    9953:	83 ec 0c             	sub    $0xc,%esp
    9956:	6a 26                	push   $0x26
    9958:	52                   	push   %edx
    9959:	50                   	push   %eax
    995a:	68 8e 00 00 00       	push   $0x8e
    995f:	6a 08                	push   $0x8
    9961:	e8 7e fe ff ff       	call   97e4 <set_idt>
    9966:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    9969:	b8 e0 b2 00 00       	mov    $0xb2e0,%eax
    996e:	ba 00 00 00 00       	mov    $0x0,%edx
    9973:	83 ec 0c             	sub    $0xc,%esp
    9976:	6a 27                	push   $0x27
    9978:	52                   	push   %edx
    9979:	50                   	push   %eax
    997a:	68 8e 00 00 00       	push   $0x8e
    997f:	6a 08                	push   $0x8
    9981:	e8 5e fe ff ff       	call   97e4 <set_idt>
    9986:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    9989:	b8 e8 b2 00 00       	mov    $0xb2e8,%eax
    998e:	ba 00 00 00 00       	mov    $0x0,%edx
    9993:	83 ec 0c             	sub    $0xc,%esp
    9996:	6a 28                	push   $0x28
    9998:	52                   	push   %edx
    9999:	50                   	push   %eax
    999a:	68 8e 00 00 00       	push   $0x8e
    999f:	6a 08                	push   $0x8
    99a1:	e8 3e fe ff ff       	call   97e4 <set_idt>
    99a6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    99a9:	b8 f0 b2 00 00       	mov    $0xb2f0,%eax
    99ae:	ba 00 00 00 00       	mov    $0x0,%edx
    99b3:	83 ec 0c             	sub    $0xc,%esp
    99b6:	6a 29                	push   $0x29
    99b8:	52                   	push   %edx
    99b9:	50                   	push   %eax
    99ba:	68 8e 00 00 00       	push   $0x8e
    99bf:	6a 08                	push   $0x8
    99c1:	e8 1e fe ff ff       	call   97e4 <set_idt>
    99c6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    99c9:	b8 f8 b2 00 00       	mov    $0xb2f8,%eax
    99ce:	ba 00 00 00 00       	mov    $0x0,%edx
    99d3:	83 ec 0c             	sub    $0xc,%esp
    99d6:	6a 2a                	push   $0x2a
    99d8:	52                   	push   %edx
    99d9:	50                   	push   %eax
    99da:	68 8e 00 00 00       	push   $0x8e
    99df:	6a 08                	push   $0x8
    99e1:	e8 fe fd ff ff       	call   97e4 <set_idt>
    99e6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    99e9:	b8 00 b3 00 00       	mov    $0xb300,%eax
    99ee:	ba 00 00 00 00       	mov    $0x0,%edx
    99f3:	83 ec 0c             	sub    $0xc,%esp
    99f6:	6a 2b                	push   $0x2b
    99f8:	52                   	push   %edx
    99f9:	50                   	push   %eax
    99fa:	68 8e 00 00 00       	push   $0x8e
    99ff:	6a 08                	push   $0x8
    9a01:	e8 de fd ff ff       	call   97e4 <set_idt>
    9a06:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    9a09:	b8 08 b3 00 00       	mov    $0xb308,%eax
    9a0e:	ba 00 00 00 00       	mov    $0x0,%edx
    9a13:	83 ec 0c             	sub    $0xc,%esp
    9a16:	6a 2c                	push   $0x2c
    9a18:	52                   	push   %edx
    9a19:	50                   	push   %eax
    9a1a:	68 8e 00 00 00       	push   $0x8e
    9a1f:	6a 08                	push   $0x8
    9a21:	e8 be fd ff ff       	call   97e4 <set_idt>
    9a26:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    9a29:	b8 10 b3 00 00       	mov    $0xb310,%eax
    9a2e:	ba 00 00 00 00       	mov    $0x0,%edx
    9a33:	83 ec 0c             	sub    $0xc,%esp
    9a36:	6a 2d                	push   $0x2d
    9a38:	52                   	push   %edx
    9a39:	50                   	push   %eax
    9a3a:	68 8e 00 00 00       	push   $0x8e
    9a3f:	6a 08                	push   $0x8
    9a41:	e8 9e fd ff ff       	call   97e4 <set_idt>
    9a46:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    9a49:	b8 18 b3 00 00       	mov    $0xb318,%eax
    9a4e:	ba 00 00 00 00       	mov    $0x0,%edx
    9a53:	83 ec 0c             	sub    $0xc,%esp
    9a56:	6a 2e                	push   $0x2e
    9a58:	52                   	push   %edx
    9a59:	50                   	push   %eax
    9a5a:	68 8e 00 00 00       	push   $0x8e
    9a5f:	6a 08                	push   $0x8
    9a61:	e8 7e fd ff ff       	call   97e4 <set_idt>
    9a66:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    9a69:	b8 20 b3 00 00       	mov    $0xb320,%eax
    9a6e:	ba 00 00 00 00       	mov    $0x0,%edx
    9a73:	83 ec 0c             	sub    $0xc,%esp
    9a76:	6a 2f                	push   $0x2f
    9a78:	52                   	push   %edx
    9a79:	50                   	push   %eax
    9a7a:	68 8e 00 00 00       	push   $0x8e
    9a7f:	6a 08                	push   $0x8
    9a81:	e8 5e fd ff ff       	call   97e4 <set_idt>
    9a86:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    9a89:	b8 20 b2 00 00       	mov    $0xb220,%eax
    9a8e:	ba 00 00 00 00       	mov    $0x0,%edx
    9a93:	83 ec 0c             	sub    $0xc,%esp
    9a96:	6a 08                	push   $0x8
    9a98:	52                   	push   %edx
    9a99:	50                   	push   %eax
    9a9a:	68 8e 00 00 00       	push   $0x8e
    9a9f:	6a 08                	push   $0x8
    9aa1:	e8 3e fd ff ff       	call   97e4 <set_idt>
    9aa6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    9aa9:	b8 20 b2 00 00       	mov    $0xb220,%eax
    9aae:	ba 00 00 00 00       	mov    $0x0,%edx
    9ab3:	83 ec 0c             	sub    $0xc,%esp
    9ab6:	6a 0a                	push   $0xa
    9ab8:	52                   	push   %edx
    9ab9:	50                   	push   %eax
    9aba:	68 8e 00 00 00       	push   $0x8e
    9abf:	6a 08                	push   $0x8
    9ac1:	e8 1e fd ff ff       	call   97e4 <set_idt>
    9ac6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    9ac9:	b8 20 b2 00 00       	mov    $0xb220,%eax
    9ace:	ba 00 00 00 00       	mov    $0x0,%edx
    9ad3:	83 ec 0c             	sub    $0xc,%esp
    9ad6:	6a 0b                	push   $0xb
    9ad8:	52                   	push   %edx
    9ad9:	50                   	push   %eax
    9ada:	68 8e 00 00 00       	push   $0x8e
    9adf:	6a 08                	push   $0x8
    9ae1:	e8 fe fc ff ff       	call   97e4 <set_idt>
    9ae6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9ae9:	b8 20 b2 00 00       	mov    $0xb220,%eax
    9aee:	ba 00 00 00 00       	mov    $0x0,%edx
    9af3:	83 ec 0c             	sub    $0xc,%esp
    9af6:	6a 0c                	push   $0xc
    9af8:	52                   	push   %edx
    9af9:	50                   	push   %eax
    9afa:	68 8e 00 00 00       	push   $0x8e
    9aff:	6a 08                	push   $0x8
    9b01:	e8 de fc ff ff       	call   97e4 <set_idt>
    9b06:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9b09:	b8 20 b2 00 00       	mov    $0xb220,%eax
    9b0e:	ba 00 00 00 00       	mov    $0x0,%edx
    9b13:	83 ec 0c             	sub    $0xc,%esp
    9b16:	6a 0d                	push   $0xd
    9b18:	52                   	push   %edx
    9b19:	50                   	push   %eax
    9b1a:	68 8e 00 00 00       	push   $0x8e
    9b1f:	6a 08                	push   $0x8
    9b21:	e8 be fc ff ff       	call   97e4 <set_idt>
    9b26:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    9b29:	b8 66 a3 00 00       	mov    $0xa366,%eax
    9b2e:	ba 00 00 00 00       	mov    $0x0,%edx
    9b33:	83 ec 0c             	sub    $0xc,%esp
    9b36:	6a 0e                	push   $0xe
    9b38:	52                   	push   %edx
    9b39:	50                   	push   %eax
    9b3a:	68 8e 00 00 00       	push   $0x8e
    9b3f:	6a 08                	push   $0x8
    9b41:	e8 9e fc ff ff       	call   97e4 <set_idt>
    9b46:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    9b49:	b8 20 b2 00 00       	mov    $0xb220,%eax
    9b4e:	ba 00 00 00 00       	mov    $0x0,%edx
    9b53:	83 ec 0c             	sub    $0xc,%esp
    9b56:	6a 11                	push   $0x11
    9b58:	52                   	push   %edx
    9b59:	50                   	push   %eax
    9b5a:	68 8e 00 00 00       	push   $0x8e
    9b5f:	6a 08                	push   $0x8
    9b61:	e8 7e fc ff ff       	call   97e4 <set_idt>
    9b66:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    9b69:	b8 20 b2 00 00       	mov    $0xb220,%eax
    9b6e:	ba 00 00 00 00       	mov    $0x0,%edx
    9b73:	83 ec 0c             	sub    $0xc,%esp
    9b76:	6a 1e                	push   $0x1e
    9b78:	52                   	push   %edx
    9b79:	50                   	push   %eax
    9b7a:	68 8e 00 00 00       	push   $0x8e
    9b7f:	6a 08                	push   $0x8
    9b81:	e8 5e fc ff ff       	call   97e4 <set_idt>
    9b86:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9b89:	b8 99 96 00 00       	mov    $0x9699,%eax
    9b8e:	ba 00 00 00 00       	mov    $0x0,%edx
    9b93:	83 ec 0c             	sub    $0xc,%esp
    9b96:	6a 00                	push   $0x0
    9b98:	52                   	push   %edx
    9b99:	50                   	push   %eax
    9b9a:	68 8e 00 00 00       	push   $0x8e
    9b9f:	6a 08                	push   $0x8
    9ba1:	e8 3e fc ff ff       	call   97e4 <set_idt>
    9ba6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9ba9:	b8 99 96 00 00       	mov    $0x9699,%eax
    9bae:	ba 00 00 00 00       	mov    $0x0,%edx
    9bb3:	83 ec 0c             	sub    $0xc,%esp
    9bb6:	6a 01                	push   $0x1
    9bb8:	52                   	push   %edx
    9bb9:	50                   	push   %eax
    9bba:	68 8e 00 00 00       	push   $0x8e
    9bbf:	6a 08                	push   $0x8
    9bc1:	e8 1e fc ff ff       	call   97e4 <set_idt>
    9bc6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9bc9:	b8 99 96 00 00       	mov    $0x9699,%eax
    9bce:	ba 00 00 00 00       	mov    $0x0,%edx
    9bd3:	83 ec 0c             	sub    $0xc,%esp
    9bd6:	6a 02                	push   $0x2
    9bd8:	52                   	push   %edx
    9bd9:	50                   	push   %eax
    9bda:	68 8e 00 00 00       	push   $0x8e
    9bdf:	6a 08                	push   $0x8
    9be1:	e8 fe fb ff ff       	call   97e4 <set_idt>
    9be6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9be9:	b8 99 96 00 00       	mov    $0x9699,%eax
    9bee:	ba 00 00 00 00       	mov    $0x0,%edx
    9bf3:	83 ec 0c             	sub    $0xc,%esp
    9bf6:	6a 03                	push   $0x3
    9bf8:	52                   	push   %edx
    9bf9:	50                   	push   %eax
    9bfa:	68 8e 00 00 00       	push   $0x8e
    9bff:	6a 08                	push   $0x8
    9c01:	e8 de fb ff ff       	call   97e4 <set_idt>
    9c06:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9c09:	b8 99 96 00 00       	mov    $0x9699,%eax
    9c0e:	ba 00 00 00 00       	mov    $0x0,%edx
    9c13:	83 ec 0c             	sub    $0xc,%esp
    9c16:	6a 04                	push   $0x4
    9c18:	52                   	push   %edx
    9c19:	50                   	push   %eax
    9c1a:	68 8e 00 00 00       	push   $0x8e
    9c1f:	6a 08                	push   $0x8
    9c21:	e8 be fb ff ff       	call   97e4 <set_idt>
    9c26:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    9c29:	b8 99 96 00 00       	mov    $0x9699,%eax
    9c2e:	ba 00 00 00 00       	mov    $0x0,%edx
    9c33:	83 ec 0c             	sub    $0xc,%esp
    9c36:	6a 05                	push   $0x5
    9c38:	52                   	push   %edx
    9c39:	50                   	push   %eax
    9c3a:	68 8e 00 00 00       	push   $0x8e
    9c3f:	6a 08                	push   $0x8
    9c41:	e8 9e fb ff ff       	call   97e4 <set_idt>
    9c46:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    9c49:	b8 99 96 00 00       	mov    $0x9699,%eax
    9c4e:	ba 00 00 00 00       	mov    $0x0,%edx
    9c53:	83 ec 0c             	sub    $0xc,%esp
    9c56:	6a 06                	push   $0x6
    9c58:	52                   	push   %edx
    9c59:	50                   	push   %eax
    9c5a:	68 8e 00 00 00       	push   $0x8e
    9c5f:	6a 08                	push   $0x8
    9c61:	e8 7e fb ff ff       	call   97e4 <set_idt>
    9c66:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    9c69:	b8 99 96 00 00       	mov    $0x9699,%eax
    9c6e:	ba 00 00 00 00       	mov    $0x0,%edx
    9c73:	83 ec 0c             	sub    $0xc,%esp
    9c76:	6a 07                	push   $0x7
    9c78:	52                   	push   %edx
    9c79:	50                   	push   %eax
    9c7a:	68 8e 00 00 00       	push   $0x8e
    9c7f:	6a 08                	push   $0x8
    9c81:	e8 5e fb ff ff       	call   97e4 <set_idt>
    9c86:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9c89:	b8 99 96 00 00       	mov    $0x9699,%eax
    9c8e:	ba 00 00 00 00       	mov    $0x0,%edx
    9c93:	83 ec 0c             	sub    $0xc,%esp
    9c96:	6a 09                	push   $0x9
    9c98:	52                   	push   %edx
    9c99:	50                   	push   %eax
    9c9a:	68 8e 00 00 00       	push   $0x8e
    9c9f:	6a 08                	push   $0x8
    9ca1:	e8 3e fb ff ff       	call   97e4 <set_idt>
    9ca6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9ca9:	b8 99 96 00 00       	mov    $0x9699,%eax
    9cae:	ba 00 00 00 00       	mov    $0x0,%edx
    9cb3:	83 ec 0c             	sub    $0xc,%esp
    9cb6:	6a 10                	push   $0x10
    9cb8:	52                   	push   %edx
    9cb9:	50                   	push   %eax
    9cba:	68 8e 00 00 00       	push   $0x8e
    9cbf:	6a 08                	push   $0x8
    9cc1:	e8 1e fb ff ff       	call   97e4 <set_idt>
    9cc6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9cc9:	b8 99 96 00 00       	mov    $0x9699,%eax
    9cce:	ba 00 00 00 00       	mov    $0x0,%edx
    9cd3:	83 ec 0c             	sub    $0xc,%esp
    9cd6:	6a 12                	push   $0x12
    9cd8:	52                   	push   %edx
    9cd9:	50                   	push   %eax
    9cda:	68 8e 00 00 00       	push   $0x8e
    9cdf:	6a 08                	push   $0x8
    9ce1:	e8 fe fa ff ff       	call   97e4 <set_idt>
    9ce6:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9ce9:	b8 99 96 00 00       	mov    $0x9699,%eax
    9cee:	ba 00 00 00 00       	mov    $0x0,%edx
    9cf3:	83 ec 0c             	sub    $0xc,%esp
    9cf6:	6a 13                	push   $0x13
    9cf8:	52                   	push   %edx
    9cf9:	50                   	push   %eax
    9cfa:	68 8e 00 00 00       	push   $0x8e
    9cff:	6a 08                	push   $0x8
    9d01:	e8 de fa ff ff       	call   97e4 <set_idt>
    9d06:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9d09:	b8 99 96 00 00       	mov    $0x9699,%eax
    9d0e:	ba 00 00 00 00       	mov    $0x0,%edx
    9d13:	83 ec 0c             	sub    $0xc,%esp
    9d16:	6a 14                	push   $0x14
    9d18:	52                   	push   %edx
    9d19:	50                   	push   %eax
    9d1a:	68 8e 00 00 00       	push   $0x8e
    9d1f:	6a 08                	push   $0x8
    9d21:	e8 be fa ff ff       	call   97e4 <set_idt>
    9d26:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    9d29:	e8 51 15 00 00       	call   b27f <load_idt>
}
    9d2e:	90                   	nop
    9d2f:	c9                   	leave  
    9d30:	c3                   	ret    

00009d31 <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    9d31:	55                   	push   %ebp
    9d32:	89 e5                	mov    %esp,%ebp
    9d34:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    9d37:	e8 4a 02 00 00       	call   9f86 <keyboard_irq>
    PIC_sendEOI(1);
    9d3c:	83 ec 0c             	sub    $0xc,%esp
    9d3f:	6a 01                	push   $0x1
    9d41:	e8 26 06 00 00       	call   a36c <PIC_sendEOI>
    9d46:	83 c4 10             	add    $0x10,%esp
}
    9d49:	90                   	nop
    9d4a:	c9                   	leave  
    9d4b:	c3                   	ret    

00009d4c <irq2_handler>:

void irq2_handler(void)
{
    9d4c:	55                   	push   %ebp
    9d4d:	89 e5                	mov    %esp,%ebp
    9d4f:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    9d52:	83 ec 0c             	sub    $0xc,%esp
    9d55:	6a 02                	push   $0x2
    9d57:	e8 1c 08 00 00       	call   a578 <spurious_IRQ>
    9d5c:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9d5f:	83 ec 0c             	sub    $0xc,%esp
    9d62:	6a 02                	push   $0x2
    9d64:	e8 03 06 00 00       	call   a36c <PIC_sendEOI>
    9d69:	83 c4 10             	add    $0x10,%esp
}
    9d6c:	90                   	nop
    9d6d:	c9                   	leave  
    9d6e:	c3                   	ret    

00009d6f <irq3_handler>:

void irq3_handler(void)
{
    9d6f:	55                   	push   %ebp
    9d70:	89 e5                	mov    %esp,%ebp
    9d72:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    9d75:	83 ec 0c             	sub    $0xc,%esp
    9d78:	6a 03                	push   $0x3
    9d7a:	e8 f9 07 00 00       	call   a578 <spurious_IRQ>
    9d7f:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9d82:	83 ec 0c             	sub    $0xc,%esp
    9d85:	6a 03                	push   $0x3
    9d87:	e8 e0 05 00 00       	call   a36c <PIC_sendEOI>
    9d8c:	83 c4 10             	add    $0x10,%esp
}
    9d8f:	90                   	nop
    9d90:	c9                   	leave  
    9d91:	c3                   	ret    

00009d92 <irq4_handler>:

void irq4_handler(void)
{
    9d92:	55                   	push   %ebp
    9d93:	89 e5                	mov    %esp,%ebp
    9d95:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    9d98:	83 ec 0c             	sub    $0xc,%esp
    9d9b:	6a 04                	push   $0x4
    9d9d:	e8 d6 07 00 00       	call   a578 <spurious_IRQ>
    9da2:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9da5:	83 ec 0c             	sub    $0xc,%esp
    9da8:	6a 04                	push   $0x4
    9daa:	e8 bd 05 00 00       	call   a36c <PIC_sendEOI>
    9daf:	83 c4 10             	add    $0x10,%esp
}
    9db2:	90                   	nop
    9db3:	c9                   	leave  
    9db4:	c3                   	ret    

00009db5 <irq5_handler>:

void irq5_handler(void)
{
    9db5:	55                   	push   %ebp
    9db6:	89 e5                	mov    %esp,%ebp
    9db8:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9dbb:	83 ec 0c             	sub    $0xc,%esp
    9dbe:	6a 05                	push   $0x5
    9dc0:	e8 b3 07 00 00       	call   a578 <spurious_IRQ>
    9dc5:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9dc8:	83 ec 0c             	sub    $0xc,%esp
    9dcb:	6a 05                	push   $0x5
    9dcd:	e8 9a 05 00 00       	call   a36c <PIC_sendEOI>
    9dd2:	83 c4 10             	add    $0x10,%esp
}
    9dd5:	90                   	nop
    9dd6:	c9                   	leave  
    9dd7:	c3                   	ret    

00009dd8 <irq6_handler>:

void irq6_handler(void)
{
    9dd8:	55                   	push   %ebp
    9dd9:	89 e5                	mov    %esp,%ebp
    9ddb:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9dde:	83 ec 0c             	sub    $0xc,%esp
    9de1:	6a 06                	push   $0x6
    9de3:	e8 90 07 00 00       	call   a578 <spurious_IRQ>
    9de8:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9deb:	83 ec 0c             	sub    $0xc,%esp
    9dee:	6a 06                	push   $0x6
    9df0:	e8 77 05 00 00       	call   a36c <PIC_sendEOI>
    9df5:	83 c4 10             	add    $0x10,%esp
}
    9df8:	90                   	nop
    9df9:	c9                   	leave  
    9dfa:	c3                   	ret    

00009dfb <irq7_handler>:

void irq7_handler(void)
{
    9dfb:	55                   	push   %ebp
    9dfc:	89 e5                	mov    %esp,%ebp
    9dfe:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9e01:	83 ec 0c             	sub    $0xc,%esp
    9e04:	6a 07                	push   $0x7
    9e06:	e8 6d 07 00 00       	call   a578 <spurious_IRQ>
    9e0b:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9e0e:	83 ec 0c             	sub    $0xc,%esp
    9e11:	6a 07                	push   $0x7
    9e13:	e8 54 05 00 00       	call   a36c <PIC_sendEOI>
    9e18:	83 c4 10             	add    $0x10,%esp
}
    9e1b:	90                   	nop
    9e1c:	c9                   	leave  
    9e1d:	c3                   	ret    

00009e1e <irq8_handler>:

void irq8_handler(void)
{
    9e1e:	55                   	push   %ebp
    9e1f:	89 e5                	mov    %esp,%ebp
    9e21:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    9e24:	83 ec 0c             	sub    $0xc,%esp
    9e27:	6a 08                	push   $0x8
    9e29:	e8 4a 07 00 00       	call   a578 <spurious_IRQ>
    9e2e:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9e31:	83 ec 0c             	sub    $0xc,%esp
    9e34:	6a 08                	push   $0x8
    9e36:	e8 31 05 00 00       	call   a36c <PIC_sendEOI>
    9e3b:	83 c4 10             	add    $0x10,%esp
}
    9e3e:	90                   	nop
    9e3f:	c9                   	leave  
    9e40:	c3                   	ret    

00009e41 <irq9_handler>:

void irq9_handler(void)
{
    9e41:	55                   	push   %ebp
    9e42:	89 e5                	mov    %esp,%ebp
    9e44:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    9e47:	83 ec 0c             	sub    $0xc,%esp
    9e4a:	6a 09                	push   $0x9
    9e4c:	e8 27 07 00 00       	call   a578 <spurious_IRQ>
    9e51:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9e54:	83 ec 0c             	sub    $0xc,%esp
    9e57:	6a 09                	push   $0x9
    9e59:	e8 0e 05 00 00       	call   a36c <PIC_sendEOI>
    9e5e:	83 c4 10             	add    $0x10,%esp
}
    9e61:	90                   	nop
    9e62:	c9                   	leave  
    9e63:	c3                   	ret    

00009e64 <irq10_handler>:

void irq10_handler(void)
{
    9e64:	55                   	push   %ebp
    9e65:	89 e5                	mov    %esp,%ebp
    9e67:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    9e6a:	83 ec 0c             	sub    $0xc,%esp
    9e6d:	6a 0a                	push   $0xa
    9e6f:	e8 04 07 00 00       	call   a578 <spurious_IRQ>
    9e74:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9e77:	83 ec 0c             	sub    $0xc,%esp
    9e7a:	6a 0a                	push   $0xa
    9e7c:	e8 eb 04 00 00       	call   a36c <PIC_sendEOI>
    9e81:	83 c4 10             	add    $0x10,%esp
}
    9e84:	90                   	nop
    9e85:	c9                   	leave  
    9e86:	c3                   	ret    

00009e87 <irq11_handler>:

void irq11_handler(void)
{
    9e87:	55                   	push   %ebp
    9e88:	89 e5                	mov    %esp,%ebp
    9e8a:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9e8d:	83 ec 0c             	sub    $0xc,%esp
    9e90:	6a 0b                	push   $0xb
    9e92:	e8 e1 06 00 00       	call   a578 <spurious_IRQ>
    9e97:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9e9a:	83 ec 0c             	sub    $0xc,%esp
    9e9d:	6a 0b                	push   $0xb
    9e9f:	e8 c8 04 00 00       	call   a36c <PIC_sendEOI>
    9ea4:	83 c4 10             	add    $0x10,%esp
}
    9ea7:	90                   	nop
    9ea8:	c9                   	leave  
    9ea9:	c3                   	ret    

00009eaa <irq12_handler>:

void irq12_handler(void)
{
    9eaa:	55                   	push   %ebp
    9eab:	89 e5                	mov    %esp,%ebp
    9ead:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9eb0:	83 ec 0c             	sub    $0xc,%esp
    9eb3:	6a 0c                	push   $0xc
    9eb5:	e8 be 06 00 00       	call   a578 <spurious_IRQ>
    9eba:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9ebd:	83 ec 0c             	sub    $0xc,%esp
    9ec0:	6a 0c                	push   $0xc
    9ec2:	e8 a5 04 00 00       	call   a36c <PIC_sendEOI>
    9ec7:	83 c4 10             	add    $0x10,%esp
}
    9eca:	90                   	nop
    9ecb:	c9                   	leave  
    9ecc:	c3                   	ret    

00009ecd <irq13_handler>:

void irq13_handler(void)
{
    9ecd:	55                   	push   %ebp
    9ece:	89 e5                	mov    %esp,%ebp
    9ed0:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9ed3:	83 ec 0c             	sub    $0xc,%esp
    9ed6:	6a 0d                	push   $0xd
    9ed8:	e8 9b 06 00 00       	call   a578 <spurious_IRQ>
    9edd:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9ee0:	83 ec 0c             	sub    $0xc,%esp
    9ee3:	6a 0d                	push   $0xd
    9ee5:	e8 82 04 00 00       	call   a36c <PIC_sendEOI>
    9eea:	83 c4 10             	add    $0x10,%esp
}
    9eed:	90                   	nop
    9eee:	c9                   	leave  
    9eef:	c3                   	ret    

00009ef0 <irq14_handler>:

void irq14_handler(void)
{
    9ef0:	55                   	push   %ebp
    9ef1:	89 e5                	mov    %esp,%ebp
    9ef3:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9ef6:	83 ec 0c             	sub    $0xc,%esp
    9ef9:	6a 0e                	push   $0xe
    9efb:	e8 78 06 00 00       	call   a578 <spurious_IRQ>
    9f00:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9f03:	83 ec 0c             	sub    $0xc,%esp
    9f06:	6a 0e                	push   $0xe
    9f08:	e8 5f 04 00 00       	call   a36c <PIC_sendEOI>
    9f0d:	83 c4 10             	add    $0x10,%esp
}
    9f10:	90                   	nop
    9f11:	c9                   	leave  
    9f12:	c3                   	ret    

00009f13 <irq15_handler>:

void irq15_handler(void)
{
    9f13:	55                   	push   %ebp
    9f14:	89 e5                	mov    %esp,%ebp
    9f16:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    9f19:	83 ec 0c             	sub    $0xc,%esp
    9f1c:	6a 0f                	push   $0xf
    9f1e:	e8 55 06 00 00       	call   a578 <spurious_IRQ>
    9f23:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    9f26:	83 ec 0c             	sub    $0xc,%esp
    9f29:	6a 0f                	push   $0xf
    9f2b:	e8 3c 04 00 00       	call   a36c <PIC_sendEOI>
    9f30:	83 c4 10             	add    $0x10,%esp
    9f33:	90                   	nop
    9f34:	c9                   	leave  
    9f35:	c3                   	ret    

00009f36 <keyboard_add_service>:
          0xFF, 0xFF, 0xFF, 0xFF, /*      (0x60)  */
          0xFF, 0xFF, 0xFF, 0xFF  /*      (0x61)  */
      };

void keyboard_add_service(void (*func)())
{
    9f36:	55                   	push   %ebp
    9f37:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service[keyboard_ctrl.kbd_service_num] = func;
    9f39:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    9f40:	0f be c0             	movsbl %al,%eax
    9f43:	8b 55 08             	mov    0x8(%ebp),%edx
    9f46:	89 14 85 21 08 01 00 	mov    %edx,0x10821(,%eax,4)
    keyboard_ctrl.kbd_service_num++;
    9f4d:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    9f54:	83 c0 01             	add    $0x1,%eax
    9f57:	a2 20 08 01 00       	mov    %al,0x10820
}
    9f5c:	90                   	nop
    9f5d:	5d                   	pop    %ebp
    9f5e:	c3                   	ret    

00009f5f <kbd_init>:

void kbd_init()
{
    9f5f:	55                   	push   %ebp
    9f60:	89 e5                	mov    %esp,%ebp
    keyboard_ctrl.kbd_service_num = 0;
    9f62:	c6 05 20 08 01 00 00 	movb   $0x0,0x10820
    keyboard_add_service(console_service_keyboard);
    9f69:	68 5c 96 00 00       	push   $0x965c
    9f6e:	e8 c3 ff ff ff       	call   9f36 <keyboard_add_service>
    9f73:	83 c4 04             	add    $0x4,%esp
    keyboard_add_service(monitor_service_keyboard);
    9f76:	68 b7 a8 00 00       	push   $0xa8b7
    9f7b:	e8 b6 ff ff ff       	call   9f36 <keyboard_add_service>
    9f80:	83 c4 04             	add    $0x4,%esp
}
    9f83:	90                   	nop
    9f84:	c9                   	leave  
    9f85:	c3                   	ret    

00009f86 <keyboard_irq>:

void keyboard_irq()
{
    9f86:	55                   	push   %ebp
    9f87:	89 e5                	mov    %esp,%ebp
    9f89:	83 ec 18             	sub    $0x18,%esp
    do {
        keyboard_ctrl.code = _8042_get_status;
    9f8c:	b8 64 00 00 00       	mov    $0x64,%eax
    9f91:	89 c2                	mov    %eax,%edx
    9f93:	ec                   	in     (%dx),%al
    9f94:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    9f98:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    9f9c:	66 a3 1d 0c 01 00    	mov    %ax,0x10c1d
    } while ((keyboard_ctrl.code & 0x01) == _8042_BUFFER_OVERRUN);
    9fa2:	0f b7 05 1d 0c 01 00 	movzwl 0x10c1d,%eax
    9fa9:	98                   	cwtl   
    9faa:	83 e0 01             	and    $0x1,%eax
    9fad:	85 c0                	test   %eax,%eax
    9faf:	74 db                	je     9f8c <keyboard_irq+0x6>

    keyboard_ctrl.code = _8042_scan_code;
    9fb1:	b8 60 00 00 00       	mov    $0x60,%eax
    9fb6:	89 c2                	mov    %eax,%edx
    9fb8:	ec                   	in     (%dx),%al
    9fb9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    9fbd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    9fc1:	66 a3 1d 0c 01 00    	mov    %ax,0x10c1d
    keyboard_ctrl.code--;
    9fc7:	0f b7 05 1d 0c 01 00 	movzwl 0x10c1d,%eax
    9fce:	83 e8 01             	sub    $0x1,%eax
    9fd1:	66 a3 1d 0c 01 00    	mov    %ax,0x10c1d

    int i;
    void (*func)(void);

    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9fd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9fde:	eb 16                	jmp    9ff6 <keyboard_irq+0x70>
        func = keyboard_ctrl.kbd_service[i];
    9fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9fe3:	8b 04 85 21 08 01 00 	mov    0x10821(,%eax,4),%eax
    9fea:	89 45 ec             	mov    %eax,-0x14(%ebp)
        func();
    9fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9ff0:	ff d0                	call   *%eax
    for (i = 0; i < keyboard_ctrl.kbd_service_num; i++) {
    9ff2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9ff6:	0f b6 05 20 08 01 00 	movzbl 0x10820,%eax
    9ffd:	0f be c0             	movsbl %al,%eax
    a000:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a003:	7c db                	jl     9fe0 <keyboard_irq+0x5a>
    }
}
    a005:	90                   	nop
    a006:	90                   	nop
    a007:	c9                   	leave  
    a008:	c3                   	ret    

0000a009 <reinitialise_kbd>:

void reinitialise_kbd()
{
    a009:	55                   	push   %ebp
    a00a:	89 e5                	mov    %esp,%ebp
    a00c:	83 ec 08             	sub    $0x8,%esp
    wait_8042_ACK();
    a00f:	e8 43 00 00 00       	call   a057 <wait_8042_ACK>
    _8042_send_get_current_scan_code;
    a014:	ba 64 00 00 00       	mov    $0x64,%edx
    a019:	b8 f0 00 00 00       	mov    $0xf0,%eax
    a01e:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a01f:	e8 33 00 00 00       	call   a057 <wait_8042_ACK>

    _8042_set_typematic_rate;
    a024:	ba 64 00 00 00       	mov    $0x64,%edx
    a029:	b8 f3 00 00 00       	mov    $0xf3,%eax
    a02e:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a02f:	e8 23 00 00 00       	call   a057 <wait_8042_ACK>

    _8042_set_leds;
    a034:	ba 64 00 00 00       	mov    $0x64,%edx
    a039:	b8 ed 00 00 00       	mov    $0xed,%eax
    a03e:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a03f:	e8 13 00 00 00       	call   a057 <wait_8042_ACK>

    _8042_enable_scanning;
    a044:	ba 64 00 00 00       	mov    $0x64,%edx
    a049:	b8 f4 00 00 00       	mov    $0xf4,%eax
    a04e:	ee                   	out    %al,(%dx)
    wait_8042_ACK();
    a04f:	e8 03 00 00 00       	call   a057 <wait_8042_ACK>
}
    a054:	90                   	nop
    a055:	c9                   	leave  
    a056:	c3                   	ret    

0000a057 <wait_8042_ACK>:

static void
wait_8042_ACK()
{
    a057:	55                   	push   %ebp
    a058:	89 e5                	mov    %esp,%ebp
    a05a:	83 ec 10             	sub    $0x10,%esp
    while (_8042_get_status != _8042_ACK)
    a05d:	90                   	nop
    a05e:	b8 64 00 00 00       	mov    $0x64,%eax
    a063:	89 c2                	mov    %eax,%edx
    a065:	ec                   	in     (%dx),%al
    a066:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a06a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a06e:	66 3d fa 00          	cmp    $0xfa,%ax
    a072:	75 ea                	jne    a05e <wait_8042_ACK+0x7>
        ;
}
    a074:	90                   	nop
    a075:	90                   	nop
    a076:	c9                   	leave  
    a077:	c3                   	ret    

0000a078 <get_code_kbd_control>:

int16_t get_code_kbd_control()
{
    a078:	55                   	push   %ebp
    a079:	89 e5                	mov    %esp,%ebp
    return keyboard_ctrl.code;
    a07b:	0f b7 05 1d 0c 01 00 	movzwl 0x10c1d,%eax
}
    a082:	5d                   	pop    %ebp
    a083:	c3                   	ret    

0000a084 <get_ASCII_code_keyboard>:

int8_t get_ASCII_code_keyboard()
{
    a084:	55                   	push   %ebp
    a085:	89 e5                	mov    %esp,%ebp
    a087:	83 ec 10             	sub    $0x10,%esp
    int16_t _code = get_code_kbd_control();
    a08a:	e8 e9 ff ff ff       	call   a078 <get_code_kbd_control>
    a08f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    static int16_t lshift_enable = 0;
    static int16_t rshift_enable = 0;
    static int16_t alt_enable    = 0;
    static int16_t ctrl_enable   = 0;

    if (_code < 0x80) { /* touche enfoncee */
    a093:	66 83 7d fe 7f       	cmpw   $0x7f,-0x2(%ebp)
    a098:	7f 5a                	jg     a0f4 <get_ASCII_code_keyboard+0x70>
        switch (_code) {
    a09a:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a09e:	83 f8 37             	cmp    $0x37,%eax
    a0a1:	74 46                	je     a0e9 <get_ASCII_code_keyboard+0x65>
    a0a3:	83 f8 37             	cmp    $0x37,%eax
    a0a6:	0f 8f a1 00 00 00    	jg     a14d <get_ASCII_code_keyboard+0xc9>
    a0ac:	83 f8 35             	cmp    $0x35,%eax
    a0af:	74 22                	je     a0d3 <get_ASCII_code_keyboard+0x4f>
    a0b1:	83 f8 35             	cmp    $0x35,%eax
    a0b4:	0f 8f 93 00 00 00    	jg     a14d <get_ASCII_code_keyboard+0xc9>
    a0ba:	83 f8 1c             	cmp    $0x1c,%eax
    a0bd:	74 1f                	je     a0de <get_ASCII_code_keyboard+0x5a>
    a0bf:	83 f8 29             	cmp    $0x29,%eax
    a0c2:	0f 85 85 00 00 00    	jne    a14d <get_ASCII_code_keyboard+0xc9>
        case 0x29: lshift_enable = 1; break;
    a0c8:	66 c7 05 20 0c 01 00 	movw   $0x1,0x10c20
    a0cf:	01 00 
    a0d1:	eb 7b                	jmp    a14e <get_ASCII_code_keyboard+0xca>
        case 0x35: rshift_enable = 1; break;
    a0d3:	66 c7 05 22 0c 01 00 	movw   $0x1,0x10c22
    a0da:	01 00 
    a0dc:	eb 70                	jmp    a14e <get_ASCII_code_keyboard+0xca>
        case 0x1C: ctrl_enable = 1; break;
    a0de:	66 c7 05 24 0c 01 00 	movw   $0x1,0x10c24
    a0e5:	01 00 
    a0e7:	eb 65                	jmp    a14e <get_ASCII_code_keyboard+0xca>
        case 0x37: alt_enable = 1; break;
    a0e9:	66 c7 05 26 0c 01 00 	movw   $0x1,0x10c26
    a0f0:	01 00 
    a0f2:	eb 5a                	jmp    a14e <get_ASCII_code_keyboard+0xca>
        default:
            break;
        }
    } else { /* touche relachee */
        _code -= 0x80;
    a0f4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a0f8:	83 c0 80             	add    $0xffffff80,%eax
    a0fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
        switch (_code) {
    a0ff:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a103:	83 f8 37             	cmp    $0x37,%eax
    a106:	74 3a                	je     a142 <get_ASCII_code_keyboard+0xbe>
    a108:	83 f8 37             	cmp    $0x37,%eax
    a10b:	7f 41                	jg     a14e <get_ASCII_code_keyboard+0xca>
    a10d:	83 f8 35             	cmp    $0x35,%eax
    a110:	74 1a                	je     a12c <get_ASCII_code_keyboard+0xa8>
    a112:	83 f8 35             	cmp    $0x35,%eax
    a115:	7f 37                	jg     a14e <get_ASCII_code_keyboard+0xca>
    a117:	83 f8 1c             	cmp    $0x1c,%eax
    a11a:	74 1b                	je     a137 <get_ASCII_code_keyboard+0xb3>
    a11c:	83 f8 29             	cmp    $0x29,%eax
    a11f:	75 2d                	jne    a14e <get_ASCII_code_keyboard+0xca>
        case 0x29: lshift_enable = 0; break;
    a121:	66 c7 05 20 0c 01 00 	movw   $0x0,0x10c20
    a128:	00 00 
    a12a:	eb 22                	jmp    a14e <get_ASCII_code_keyboard+0xca>
        case 0x35: rshift_enable = 0; break;
    a12c:	66 c7 05 22 0c 01 00 	movw   $0x0,0x10c22
    a133:	00 00 
    a135:	eb 17                	jmp    a14e <get_ASCII_code_keyboard+0xca>
        case 0x1C: ctrl_enable = 0; break;
    a137:	66 c7 05 24 0c 01 00 	movw   $0x0,0x10c24
    a13e:	00 00 
    a140:	eb 0c                	jmp    a14e <get_ASCII_code_keyboard+0xca>
        case 0x37: alt_enable = 0; break;
    a142:	66 c7 05 26 0c 01 00 	movw   $0x0,0x10c26
    a149:	00 00 
    a14b:	eb 01                	jmp    a14e <get_ASCII_code_keyboard+0xca>
            break;
    a14d:	90                   	nop
        }
    }

    return kbdmap[_code * 4 + (lshift_enable || rshift_enable)];
    a14e:	0f bf 45 fe          	movswl -0x2(%ebp),%eax
    a152:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a159:	0f b7 05 20 0c 01 00 	movzwl 0x10c20,%eax
    a160:	66 85 c0             	test   %ax,%ax
    a163:	75 0c                	jne    a171 <get_ASCII_code_keyboard+0xed>
    a165:	0f b7 05 22 0c 01 00 	movzwl 0x10c22,%eax
    a16c:	66 85 c0             	test   %ax,%ax
    a16f:	74 07                	je     a178 <get_ASCII_code_keyboard+0xf4>
    a171:	b8 01 00 00 00       	mov    $0x1,%eax
    a176:	eb 05                	jmp    a17d <get_ASCII_code_keyboard+0xf9>
    a178:	b8 00 00 00 00       	mov    $0x0,%eax
    a17d:	01 d0                	add    %edx,%eax
    a17f:	0f b6 80 c0 b4 00 00 	movzbl 0xb4c0(%eax),%eax
    a186:	c9                   	leave  
    a187:	c3                   	ret    

0000a188 <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    a188:	55                   	push   %ebp
    a189:	89 e5                	mov    %esp,%ebp
    a18b:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a18e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a195:	eb 20                	jmp    a1b7 <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a197:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a19a:	c1 e0 0c             	shl    $0xc,%eax
    a19d:	89 c2                	mov    %eax,%edx
    a19f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1a2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a1a9:	8b 45 08             	mov    0x8(%ebp),%eax
    a1ac:	01 c8                	add    %ecx,%eax
    a1ae:	83 ca 23             	or     $0x23,%edx
    a1b1:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a1b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a1b7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a1be:	76 d7                	jbe    a197 <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    a1c0:	8b 45 08             	mov    0x8(%ebp),%eax
    a1c3:	83 c8 23             	or     $0x23,%eax
    a1c6:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    a1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    a1cb:	89 14 85 00 10 01 00 	mov    %edx,0x11000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    a1d2:	e8 59 11 00 00       	call   b330 <_FlushPagingCache_>
}
    a1d7:	90                   	nop
    a1d8:	c9                   	leave  
    a1d9:	c3                   	ret    

0000a1da <init_paging>:

void init_paging()
{
    a1da:	55                   	push   %ebp
    a1db:	89 e5                	mov    %esp,%ebp
    a1dd:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    a1e0:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a1e6:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    a1ec:	eb 1a                	jmp    a208 <init_paging+0x2e>
        page_directory[i] =
    a1ee:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a1f2:	c7 04 85 00 10 01 00 	movl   $0x2,0x11000(,%eax,4)
    a1f9:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a1fd:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a201:	83 c0 01             	add    $0x1,%eax
    a204:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a208:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a20e:	76 de                	jbe    a1ee <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a210:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    a216:	eb 22                	jmp    a23a <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a218:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a21c:	c1 e0 0c             	shl    $0xc,%eax
    a21f:	83 c8 23             	or     $0x23,%eax
    a222:	89 c2                	mov    %eax,%edx
    a224:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a228:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a22f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a233:	83 c0 01             	add    $0x1,%eax
    a236:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a23a:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a240:	76 d6                	jbe    a218 <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    a242:	b8 00 c0 00 00       	mov    $0xc000,%eax
    a247:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    a24a:	a3 00 10 01 00       	mov    %eax,0x11000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    a24f:	e8 e5 10 00 00       	call   b339 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    a254:	90                   	nop
    a255:	c9                   	leave  
    a256:	c3                   	ret    

0000a257 <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    a257:	55                   	push   %ebp
    a258:	89 e5                	mov    %esp,%ebp
    a25a:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    a25d:	8b 45 08             	mov    0x8(%ebp),%eax
    a260:	c1 e8 16             	shr    $0x16,%eax
    a263:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    a266:	8b 45 08             	mov    0x8(%ebp),%eax
    a269:	c1 e8 0c             	shr    $0xc,%eax
    a26c:	25 ff 03 00 00       	and    $0x3ff,%eax
    a271:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a274:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a277:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a27e:	83 e0 23             	and    $0x23,%eax
    a281:	83 f8 23             	cmp    $0x23,%eax
    a284:	75 56                	jne    a2dc <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a286:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a289:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a290:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a295:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a298:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a29b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a2a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a2a5:	01 d0                	add    %edx,%eax
    a2a7:	8b 00                	mov    (%eax),%eax
    a2a9:	83 e0 23             	and    $0x23,%eax
    a2ac:	83 f8 23             	cmp    $0x23,%eax
    a2af:	75 24                	jne    a2d5 <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a2b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a2b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a2bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a2be:	01 d0                	add    %edx,%eax
    a2c0:	8b 00                	mov    (%eax),%eax
    a2c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a2c7:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    a2c9:	8b 45 08             	mov    0x8(%ebp),%eax
    a2cc:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a2d1:	09 d0                	or     %edx,%eax
    a2d3:	eb 0c                	jmp    a2e1 <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    a2d5:	b8 70 f0 00 00       	mov    $0xf070,%eax
    a2da:	eb 05                	jmp    a2e1 <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    a2dc:	b8 70 f0 00 00       	mov    $0xf070,%eax
}
    a2e1:	c9                   	leave  
    a2e2:	c3                   	ret    

0000a2e3 <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    a2e3:	55                   	push   %ebp
    a2e4:	89 e5                	mov    %esp,%ebp
    a2e6:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    a2e9:	8b 45 08             	mov    0x8(%ebp),%eax
    a2ec:	c1 e8 16             	shr    $0x16,%eax
    a2ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    a2f2:	8b 45 08             	mov    0x8(%ebp),%eax
    a2f5:	c1 e8 0c             	shr    $0xc,%eax
    a2f8:	25 ff 03 00 00       	and    $0x3ff,%eax
    a2fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a300:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a303:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a30a:	83 e0 23             	and    $0x23,%eax
    a30d:	83 f8 23             	cmp    $0x23,%eax
    a310:	75 4e                	jne    a360 <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a312:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a315:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a31c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a321:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a324:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a327:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a32e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a331:	01 d0                	add    %edx,%eax
    a333:	8b 00                	mov    (%eax),%eax
    a335:	83 e0 23             	and    $0x23,%eax
    a338:	83 f8 23             	cmp    $0x23,%eax
    a33b:	74 26                	je     a363 <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a33d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a340:	c1 e0 0c             	shl    $0xc,%eax
    a343:	89 c2                	mov    %eax,%edx
    a345:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a348:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a34f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a352:	01 c8                	add    %ecx,%eax
    a354:	83 ca 23             	or     $0x23,%edx
    a357:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a359:	e8 d2 0f 00 00       	call   b330 <_FlushPagingCache_>
    a35e:	eb 04                	jmp    a364 <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a360:	90                   	nop
    a361:	eb 01                	jmp    a364 <map_linear_address+0x81>
            return; // the linear address was already mapped
    a363:	90                   	nop
}
    a364:	c9                   	leave  
    a365:	c3                   	ret    

0000a366 <Paging_fault>:

void Paging_fault()
{
    a366:	55                   	push   %ebp
    a367:	89 e5                	mov    %esp,%ebp
}
    a369:	90                   	nop
    a36a:	5d                   	pop    %ebp
    a36b:	c3                   	ret    

0000a36c <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a36c:	55                   	push   %ebp
    a36d:	89 e5                	mov    %esp,%ebp
    a36f:	83 ec 04             	sub    $0x4,%esp
    a372:	8b 45 08             	mov    0x8(%ebp),%eax
    a375:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a378:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a37c:	76 0b                	jbe    a389 <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a37e:	ba a0 00 00 00       	mov    $0xa0,%edx
    a383:	b8 20 00 00 00       	mov    $0x20,%eax
    a388:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a389:	ba 20 00 00 00       	mov    $0x20,%edx
    a38e:	b8 20 00 00 00       	mov    $0x20,%eax
    a393:	ee                   	out    %al,(%dx)
}
    a394:	90                   	nop
    a395:	c9                   	leave  
    a396:	c3                   	ret    

0000a397 <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a397:	55                   	push   %ebp
    a398:	89 e5                	mov    %esp,%ebp
    a39a:	83 ec 18             	sub    $0x18,%esp
    a39d:	8b 55 08             	mov    0x8(%ebp),%edx
    a3a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    a3a3:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a3a6:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a3a9:	b8 21 00 00 00       	mov    $0x21,%eax
    a3ae:	89 c2                	mov    %eax,%edx
    a3b0:	ec                   	in     (%dx),%al
    a3b1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a3b5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a3b9:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2 = inb(PIC2_DATA);
    a3bc:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a3c1:	89 c2                	mov    %eax,%edx
    a3c3:	ec                   	in     (%dx),%al
    a3c4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a3c8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a3cc:	88 45 f9             	mov    %al,-0x7(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a3cf:	ba 20 00 00 00       	mov    $0x20,%edx
    a3d4:	b8 11 00 00 00       	mov    $0x11,%eax
    a3d9:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a3da:	eb 00                	jmp    a3dc <PIC_remap+0x45>
    a3dc:	eb 00                	jmp    a3de <PIC_remap+0x47>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a3de:	ba a0 00 00 00       	mov    $0xa0,%edx
    a3e3:	b8 11 00 00 00       	mov    $0x11,%eax
    a3e8:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a3e9:	eb 00                	jmp    a3eb <PIC_remap+0x54>
    a3eb:	eb 00                	jmp    a3ed <PIC_remap+0x56>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a3ed:	ba 21 00 00 00       	mov    $0x21,%edx
    a3f2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a3f6:	ee                   	out    %al,(%dx)
    io_wait;
    a3f7:	eb 00                	jmp    a3f9 <PIC_remap+0x62>
    a3f9:	eb 00                	jmp    a3fb <PIC_remap+0x64>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a3fb:	ba a1 00 00 00       	mov    $0xa1,%edx
    a400:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a404:	ee                   	out    %al,(%dx)
    io_wait;
    a405:	eb 00                	jmp    a407 <PIC_remap+0x70>
    a407:	eb 00                	jmp    a409 <PIC_remap+0x72>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a409:	ba 21 00 00 00       	mov    $0x21,%edx
    a40e:	b8 04 00 00 00       	mov    $0x4,%eax
    a413:	ee                   	out    %al,(%dx)
    io_wait;
    a414:	eb 00                	jmp    a416 <PIC_remap+0x7f>
    a416:	eb 00                	jmp    a418 <PIC_remap+0x81>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a418:	ba a1 00 00 00       	mov    $0xa1,%edx
    a41d:	b8 02 00 00 00       	mov    $0x2,%eax
    a422:	ee                   	out    %al,(%dx)
    io_wait;
    a423:	eb 00                	jmp    a425 <PIC_remap+0x8e>
    a425:	eb 00                	jmp    a427 <PIC_remap+0x90>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a427:	ba 21 00 00 00       	mov    $0x21,%edx
    a42c:	b8 01 00 00 00       	mov    $0x1,%eax
    a431:	ee                   	out    %al,(%dx)
    io_wait;
    a432:	eb 00                	jmp    a434 <PIC_remap+0x9d>
    a434:	eb 00                	jmp    a436 <PIC_remap+0x9f>

    outb(PIC2_DATA, ICW4_8086);
    a436:	ba a1 00 00 00       	mov    $0xa1,%edx
    a43b:	b8 01 00 00 00       	mov    $0x1,%eax
    a440:	ee                   	out    %al,(%dx)
    io_wait;
    a441:	eb 00                	jmp    a443 <PIC_remap+0xac>
    a443:	eb 00                	jmp    a445 <PIC_remap+0xae>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a445:	ba 21 00 00 00       	mov    $0x21,%edx
    a44a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a44e:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a44f:	ba a1 00 00 00       	mov    $0xa1,%edx
    a454:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a458:	ee                   	out    %al,(%dx)
}
    a459:	90                   	nop
    a45a:	c9                   	leave  
    a45b:	c3                   	ret    

0000a45c <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a45c:	55                   	push   %ebp
    a45d:	89 e5                	mov    %esp,%ebp
    a45f:	53                   	push   %ebx
    a460:	83 ec 14             	sub    $0x14,%esp
    a463:	8b 45 08             	mov    0x8(%ebp),%eax
    a466:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a469:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a46d:	77 08                	ja     a477 <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a46f:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a475:	eb 0a                	jmp    a481 <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a477:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a47d:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a481:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a485:	89 c2                	mov    %eax,%edx
    a487:	ec                   	in     (%dx),%al
    a488:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a48c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a490:	89 c3                	mov    %eax,%ebx
    a492:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a496:	ba 01 00 00 00       	mov    $0x1,%edx
    a49b:	89 c1                	mov    %eax,%ecx
    a49d:	d3 e2                	shl    %cl,%edx
    a49f:	89 d0                	mov    %edx,%eax
    a4a1:	09 d8                	or     %ebx,%eax
    a4a3:	88 45 f7             	mov    %al,-0x9(%ebp)

    outb(port, value);
    a4a6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a4aa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a4ae:	ee                   	out    %al,(%dx)
}
    a4af:	90                   	nop
    a4b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a4b3:	c9                   	leave  
    a4b4:	c3                   	ret    

0000a4b5 <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a4b5:	55                   	push   %ebp
    a4b6:	89 e5                	mov    %esp,%ebp
    a4b8:	53                   	push   %ebx
    a4b9:	83 ec 14             	sub    $0x14,%esp
    a4bc:	8b 45 08             	mov    0x8(%ebp),%eax
    a4bf:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a4c2:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a4c6:	77 09                	ja     a4d1 <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a4c8:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a4cf:	eb 0b                	jmp    a4dc <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a4d1:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a4d8:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a4dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a4df:	89 c2                	mov    %eax,%edx
    a4e1:	ec                   	in     (%dx),%al
    a4e2:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a4e6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a4ea:	89 c3                	mov    %eax,%ebx
    a4ec:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a4f0:	ba 01 00 00 00       	mov    $0x1,%edx
    a4f5:	89 c1                	mov    %eax,%ecx
    a4f7:	d3 e2                	shl    %cl,%edx
    a4f9:	89 d0                	mov    %edx,%eax
    a4fb:	f7 d0                	not    %eax
    a4fd:	21 d8                	and    %ebx,%eax
    a4ff:	88 45 f5             	mov    %al,-0xb(%ebp)

    outb(port, value);
    a502:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a505:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a509:	ee                   	out    %al,(%dx)
}
    a50a:	90                   	nop
    a50b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a50e:	c9                   	leave  
    a50f:	c3                   	ret    

0000a510 <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a510:	55                   	push   %ebp
    a511:	89 e5                	mov    %esp,%ebp
    a513:	83 ec 14             	sub    $0x14,%esp
    a516:	8b 45 08             	mov    0x8(%ebp),%eax
    a519:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a51c:	ba 20 00 00 00       	mov    $0x20,%edx
    a521:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a525:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a526:	ba a0 00 00 00       	mov    $0xa0,%edx
    a52b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a52f:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a530:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a535:	89 c2                	mov    %eax,%edx
    a537:	ec                   	in     (%dx),%al
    a538:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a53c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a540:	98                   	cwtl   
    a541:	c1 e0 08             	shl    $0x8,%eax
    a544:	89 c1                	mov    %eax,%ecx
    a546:	b8 20 00 00 00       	mov    $0x20,%eax
    a54b:	89 c2                	mov    %eax,%edx
    a54d:	ec                   	in     (%dx),%al
    a54e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a552:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a556:	09 c8                	or     %ecx,%eax
}
    a558:	c9                   	leave  
    a559:	c3                   	ret    

0000a55a <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a55a:	55                   	push   %ebp
    a55b:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a55d:	6a 0b                	push   $0xb
    a55f:	e8 ac ff ff ff       	call   a510 <__pic_get_irq_reg>
    a564:	83 c4 04             	add    $0x4,%esp
}
    a567:	c9                   	leave  
    a568:	c3                   	ret    

0000a569 <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a569:	55                   	push   %ebp
    a56a:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a56c:	6a 0a                	push   $0xa
    a56e:	e8 9d ff ff ff       	call   a510 <__pic_get_irq_reg>
    a573:	83 c4 04             	add    $0x4,%esp
}
    a576:	c9                   	leave  
    a577:	c3                   	ret    

0000a578 <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a578:	55                   	push   %ebp
    a579:	89 e5                	mov    %esp,%ebp
    a57b:	83 ec 14             	sub    $0x14,%esp
    a57e:	8b 45 08             	mov    0x8(%ebp),%eax
    a581:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a584:	e8 d1 ff ff ff       	call   a55a <pic_get_isr>
    a589:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a58d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a591:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a595:	74 13                	je     a5aa <spurious_IRQ+0x32>
    a597:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a59b:	0f b6 c0             	movzbl %al,%eax
    a59e:	83 e0 07             	and    $0x7,%eax
    a5a1:	50                   	push   %eax
    a5a2:	e8 c5 fd ff ff       	call   a36c <PIC_sendEOI>
    a5a7:	83 c4 04             	add    $0x4,%esp
    a5aa:	90                   	nop
    a5ab:	c9                   	leave  
    a5ac:	c3                   	ret    

0000a5ad <conserv_status_byte>:
uint32_t compteur   = 0;
uint8_t  frequency  = 0;
uint8_t  status_PIT = 0;

void conserv_status_byte()
{
    a5ad:	55                   	push   %ebp
    a5ae:	89 e5                	mov    %esp,%ebp
    a5b0:	83 ec 10             	sub    $0x10,%esp
    set_pit_count(PIT_0, PIT_reload_value);
    a5b3:	ba 43 00 00 00       	mov    $0x43,%edx
    a5b8:	b8 40 00 00 00       	mov    $0x40,%eax
    a5bd:	ee                   	out    %al,(%dx)
    a5be:	b8 40 00 00 00       	mov    $0x40,%eax
    a5c3:	89 c2                	mov    %eax,%edx
    a5c5:	ec                   	in     (%dx),%al
    a5c6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    a5ca:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a5ce:	88 45 f6             	mov    %al,-0xa(%ebp)
    a5d1:	b8 40 00 00 00       	mov    $0x40,%eax
    a5d6:	89 c2                	mov    %eax,%edx
    a5d8:	ec                   	in     (%dx),%al
    a5d9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a5dd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a5e1:	88 45 f7             	mov    %al,-0x9(%ebp)
    a5e4:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a5e8:	66 98                	cbtw   
    a5ea:	ba 40 00 00 00       	mov    $0x40,%edx
    a5ef:	ee                   	out    %al,(%dx)
    a5f0:	a1 74 32 02 00       	mov    0x23274,%eax
    a5f5:	c1 f8 08             	sar    $0x8,%eax
    a5f8:	ba 40 00 00 00       	mov    $0x40,%edx
    a5fd:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a5fe:	ba 43 00 00 00       	mov    $0x43,%edx
    a603:	b8 40 00 00 00       	mov    $0x40,%eax
    a608:	ee                   	out    %al,(%dx)
    a609:	b8 40 00 00 00       	mov    $0x40,%eax
    a60e:	89 c2                	mov    %eax,%edx
    a610:	ec                   	in     (%dx),%al
    a611:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a615:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a619:	88 45 f4             	mov    %al,-0xc(%ebp)
    a61c:	b8 40 00 00 00       	mov    $0x40,%eax
    a621:	89 c2                	mov    %eax,%edx
    a623:	ec                   	in     (%dx),%al
    a624:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a628:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a62c:	88 45 f5             	mov    %al,-0xb(%ebp)
    a62f:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a633:	66 98                	cbtw   
    a635:	ba 43 00 00 00       	mov    $0x43,%edx
    a63a:	ee                   	out    %al,(%dx)
    a63b:	ba 43 00 00 00       	mov    $0x43,%edx
    a640:	b8 34 00 00 00       	mov    $0x34,%eax
    a645:	ee                   	out    %al,(%dx)
}
    a646:	90                   	nop
    a647:	c9                   	leave  
    a648:	c3                   	ret    

0000a649 <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a649:	55                   	push   %ebp
    a64a:	89 e5                	mov    %esp,%ebp
    a64c:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a64f:	0f b6 05 40 31 02 00 	movzbl 0x23140,%eax
    a656:	3c 01                	cmp    $0x1,%al
    a658:	75 27                	jne    a681 <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a65a:	a1 44 31 02 00       	mov    0x23144,%eax
    a65f:	85 c0                	test   %eax,%eax
    a661:	75 11                	jne    a674 <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a663:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    a66a:	01 00 00 
            __switch();
    a66d:	e8 d8 0a 00 00       	call   b14a <__switch>
        } else
            sheduler.task_timer--;
    }
}
    a672:	eb 0d                	jmp    a681 <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a674:	a1 44 31 02 00       	mov    0x23144,%eax
    a679:	83 e8 01             	sub    $0x1,%eax
    a67c:	a3 44 31 02 00       	mov    %eax,0x23144
}
    a681:	90                   	nop
    a682:	c9                   	leave  
    a683:	c3                   	ret    

0000a684 <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a684:	55                   	push   %ebp
    a685:	89 e5                	mov    %esp,%ebp
    a687:	83 ec 28             	sub    $0x28,%esp
    a68a:	8b 45 08             	mov    0x8(%ebp),%eax
    a68d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a691:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a695:	a2 04 20 01 00       	mov    %al,0x12004
    calculate_frequency();
    a69a:	e8 fd 0c 00 00       	call   b39c <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a69f:	ba 43 00 00 00       	mov    $0x43,%edx
    a6a4:	b8 40 00 00 00       	mov    $0x40,%eax
    a6a9:	ee                   	out    %al,(%dx)
    a6aa:	b8 40 00 00 00       	mov    $0x40,%eax
    a6af:	89 c2                	mov    %eax,%edx
    a6b1:	ec                   	in     (%dx),%al
    a6b2:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a6b6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a6ba:	88 45 ee             	mov    %al,-0x12(%ebp)
    a6bd:	b8 40 00 00 00       	mov    $0x40,%eax
    a6c2:	89 c2                	mov    %eax,%edx
    a6c4:	ec                   	in     (%dx),%al
    a6c5:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    a6c9:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
    a6cd:	88 45 ef             	mov    %al,-0x11(%ebp)
    a6d0:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
    a6d4:	66 98                	cbtw   
    a6d6:	ba 43 00 00 00       	mov    $0x43,%edx
    a6db:	ee                   	out    %al,(%dx)
    a6dc:	ba 43 00 00 00       	mov    $0x43,%edx
    a6e1:	b8 34 00 00 00       	mov    $0x34,%eax
    a6e6:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a6e7:	ba 43 00 00 00       	mov    $0x43,%edx
    a6ec:	b8 40 00 00 00       	mov    $0x40,%eax
    a6f1:	ee                   	out    %al,(%dx)
    a6f2:	b8 40 00 00 00       	mov    $0x40,%eax
    a6f7:	89 c2                	mov    %eax,%edx
    a6f9:	ec                   	in     (%dx),%al
    a6fa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    a6fe:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
    a702:	88 45 ec             	mov    %al,-0x14(%ebp)
    a705:	b8 40 00 00 00       	mov    $0x40,%eax
    a70a:	89 c2                	mov    %eax,%edx
    a70c:	ec                   	in     (%dx),%al
    a70d:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
    a711:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
    a715:	88 45 ed             	mov    %al,-0x13(%ebp)
    a718:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a71c:	66 98                	cbtw   
    a71e:	ba 40 00 00 00       	mov    $0x40,%edx
    a723:	ee                   	out    %al,(%dx)
    a724:	a1 74 32 02 00       	mov    0x23274,%eax
    a729:	c1 f8 08             	sar    $0x8,%eax
    a72c:	ba 40 00 00 00       	mov    $0x40,%edx
    a731:	ee                   	out    %al,(%dx)
}
    a732:	90                   	nop
    a733:	c9                   	leave  
    a734:	c3                   	ret    

0000a735 <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a735:	55                   	push   %ebp
    a736:	89 e5                	mov    %esp,%ebp
    a738:	83 ec 14             	sub    $0x14,%esp
    a73b:	8b 45 08             	mov    0x8(%ebp),%eax
    a73e:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a741:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a745:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a749:	83 f8 42             	cmp    $0x42,%eax
    a74c:	74 1d                	je     a76b <read_back_channel+0x36>
    a74e:	83 f8 42             	cmp    $0x42,%eax
    a751:	7f 1e                	jg     a771 <read_back_channel+0x3c>
    a753:	83 f8 40             	cmp    $0x40,%eax
    a756:	74 07                	je     a75f <read_back_channel+0x2a>
    a758:	83 f8 41             	cmp    $0x41,%eax
    a75b:	74 08                	je     a765 <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a75d:	eb 12                	jmp    a771 <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a75f:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a763:	eb 0d                	jmp    a772 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a765:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a769:	eb 07                	jmp    a772 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a76b:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a76f:	eb 01                	jmp    a772 <read_back_channel+0x3d>
        break;
    a771:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a772:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a776:	ba 43 00 00 00       	mov    $0x43,%edx
    a77b:	b8 40 00 00 00       	mov    $0x40,%eax
    a780:	ee                   	out    %al,(%dx)
    a781:	b8 40 00 00 00       	mov    $0x40,%eax
    a786:	89 c2                	mov    %eax,%edx
    a788:	ec                   	in     (%dx),%al
    a789:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    a78d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a791:	88 45 f4             	mov    %al,-0xc(%ebp)
    a794:	b8 40 00 00 00       	mov    $0x40,%eax
    a799:	89 c2                	mov    %eax,%edx
    a79b:	ec                   	in     (%dx),%al
    a79c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    a7a0:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a7a4:	88 45 f5             	mov    %al,-0xb(%ebp)
    a7a7:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a7ab:	66 98                	cbtw   
    a7ad:	ba 43 00 00 00       	mov    $0x43,%edx
    a7b2:	ee                   	out    %al,(%dx)
    a7b3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a7b7:	c1 f8 08             	sar    $0x8,%eax
    a7ba:	ba 43 00 00 00       	mov    $0x43,%edx
    a7bf:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a7c0:	ba 43 00 00 00       	mov    $0x43,%edx
    a7c5:	b8 40 00 00 00       	mov    $0x40,%eax
    a7ca:	ee                   	out    %al,(%dx)
    a7cb:	b8 40 00 00 00       	mov    $0x40,%eax
    a7d0:	89 c2                	mov    %eax,%edx
    a7d2:	ec                   	in     (%dx),%al
    a7d3:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
    a7d7:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
    a7db:	88 45 f2             	mov    %al,-0xe(%ebp)
    a7de:	b8 40 00 00 00       	mov    $0x40,%eax
    a7e3:	89 c2                	mov    %eax,%edx
    a7e5:	ec                   	in     (%dx),%al
    a7e6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a7ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a7ee:	88 45 f3             	mov    %al,-0xd(%ebp)
    a7f1:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a7f5:	66 98                	cbtw   
    a7f7:	c9                   	leave  
    a7f8:	c3                   	ret    

0000a7f9 <read_ebp>:
        registers;                                                     \
    })

static inline uint32_t
read_ebp(void)
{
    a7f9:	55                   	push   %ebp
    a7fa:	89 e5                	mov    %esp,%ebp
    a7fc:	83 ec 10             	sub    $0x10,%esp
    uint32_t ebp;
    asm volatile("movl %%ebp,%0"
    a7ff:	89 e8                	mov    %ebp,%eax
    a801:	89 45 fc             	mov    %eax,-0x4(%ebp)
                 : "=r"(ebp));
    return ebp;
    a804:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    a807:	c9                   	leave  
    a808:	c3                   	ret    

0000a809 <backtrace>:
          { "help", "Display this list of commands", mon_help },
          { "backtrace", "Affiche le trace des piles", backtrace },
      };

int backtrace(int argc, char** argv)
{
    a809:	55                   	push   %ebp
    a80a:	89 e5                	mov    %esp,%ebp
    a80c:	83 ec 18             	sub    $0x18,%esp
    // Your code here.
    int ebp = read_ebp(), *eip = (int*)(ebp + 4), *ptr;
    a80f:	e8 e5 ff ff ff       	call   a7f9 <read_ebp>
    a814:	89 45 f4             	mov    %eax,-0xc(%ebp)
    a817:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a81a:	83 c0 04             	add    $0x4,%eax
    a81d:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (ebp != 0) {
    a820:	eb 30                	jmp    a852 <backtrace+0x49>
        kprintf("ebp %x eip %x\n", ebp, *eip);
    a822:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a825:	8b 00                	mov    (%eax),%eax
    a827:	83 ec 04             	sub    $0x4,%esp
    a82a:	50                   	push   %eax
    a82b:	ff 75 f4             	pushl  -0xc(%ebp)
    a82e:	68 c3 f0 00 00       	push   $0xf0c3
    a833:	e8 03 01 00 00       	call   a93b <kprintf>
    a838:	83 c4 10             	add    $0x10,%esp

        ptr = (int*)(ebp);
    a83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a83e:	89 45 ec             	mov    %eax,-0x14(%ebp)

        ebp = (int)(*ptr);
    a841:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a844:	8b 00                	mov    (%eax),%eax
    a846:	89 45 f4             	mov    %eax,-0xc(%ebp)

        eip = (int*)(ebp + 4);
    a849:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a84c:	83 c0 04             	add    $0x4,%eax
    a84f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (ebp != 0) {
    a852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    a856:	75 ca                	jne    a822 <backtrace+0x19>
    }
    return 0;
    a858:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a85d:	c9                   	leave  
    a85e:	c3                   	ret    

0000a85f <mon_help>:

int mon_help(int argc, char** argv)
{
    a85f:	55                   	push   %ebp
    a860:	89 e5                	mov    %esp,%ebp
    a862:	83 ec 18             	sub    $0x18,%esp
    int i;

    for (i = 0; i < 2; i++)
    a865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a86c:	eb 3c                	jmp    a8aa <mon_help+0x4b>
        kprintf("%s - %s\n", commands[i].name, commands[i].desc);
    a86e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    a871:	89 d0                	mov    %edx,%eax
    a873:	01 c0                	add    %eax,%eax
    a875:	01 d0                	add    %edx,%eax
    a877:	c1 e0 02             	shl    $0x2,%eax
    a87a:	05 48 b6 00 00       	add    $0xb648,%eax
    a87f:	8b 10                	mov    (%eax),%edx
    a881:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    a884:	89 c8                	mov    %ecx,%eax
    a886:	01 c0                	add    %eax,%eax
    a888:	01 c8                	add    %ecx,%eax
    a88a:	c1 e0 02             	shl    $0x2,%eax
    a88d:	05 44 b6 00 00       	add    $0xb644,%eax
    a892:	8b 00                	mov    (%eax),%eax
    a894:	83 ec 04             	sub    $0x4,%esp
    a897:	52                   	push   %edx
    a898:	50                   	push   %eax
    a899:	68 d2 f0 00 00       	push   $0xf0d2
    a89e:	e8 98 00 00 00       	call   a93b <kprintf>
    a8a3:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 2; i++)
    a8a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a8aa:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    a8ae:	7e be                	jle    a86e <mon_help+0xf>
    return 0;
    a8b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
    a8b5:	c9                   	leave  
    a8b6:	c3                   	ret    

0000a8b7 <monitor_service_keyboard>:

#define KEYBOARD_CODE_MAX 0xff
static int8_t keyboard_code_monitor[KEYBOARD_CODE_MAX], keyboard_num = 0;

void monitor_service_keyboard()
{
    a8b7:	55                   	push   %ebp
    a8b8:	89 e5                	mov    %esp,%ebp
    a8ba:	83 ec 18             	sub    $0x18,%esp
    int8_t code = get_ASCII_code_keyboard();
    a8bd:	e8 c2 f7 ff ff       	call   a084 <get_ASCII_code_keyboard>
    a8c2:	88 45 f3             	mov    %al,-0xd(%ebp)
    if (code != '\n') {
    a8c5:	80 7d f3 0a          	cmpb   $0xa,-0xd(%ebp)
    a8c9:	74 25                	je     a8f0 <monitor_service_keyboard+0x39>
        keyboard_code_monitor[keyboard_num] = code;
    a8cb:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a8d2:	0f be c0             	movsbl %al,%eax
    a8d5:	0f b6 55 f3          	movzbl -0xd(%ebp),%edx
    a8d9:	88 90 20 20 01 00    	mov    %dl,0x12020(%eax)
        keyboard_num++;
    a8df:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a8e6:	83 c0 01             	add    $0x1,%eax
    a8e9:	a2 1f 21 01 00       	mov    %al,0x1211f
            keyboard_code_monitor[i] = 0;
        }

        keyboard_num = 0;
    }
    a8ee:	eb 48                	jmp    a938 <monitor_service_keyboard+0x81>
        for (i = 0; i < keyboard_num; i++) {
    a8f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a8f7:	eb 29                	jmp    a922 <monitor_service_keyboard+0x6b>
            putchar(keyboard_code_monitor[i]);
    a8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a8fc:	05 20 20 01 00       	add    $0x12020,%eax
    a901:	0f b6 00             	movzbl (%eax),%eax
    a904:	0f b6 c0             	movzbl %al,%eax
    a907:	83 ec 0c             	sub    $0xc,%esp
    a90a:	50                   	push   %eax
    a90b:	e8 09 e7 ff ff       	call   9019 <putchar>
    a910:	83 c4 10             	add    $0x10,%esp
            keyboard_code_monitor[i] = 0;
    a913:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a916:	05 20 20 01 00       	add    $0x12020,%eax
    a91b:	c6 00 00             	movb   $0x0,(%eax)
        for (i = 0; i < keyboard_num; i++) {
    a91e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a922:	0f b6 05 1f 21 01 00 	movzbl 0x1211f,%eax
    a929:	0f be c0             	movsbl %al,%eax
    a92c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    a92f:	7c c8                	jl     a8f9 <monitor_service_keyboard+0x42>
        keyboard_num = 0;
    a931:	c6 05 1f 21 01 00 00 	movb   $0x0,0x1211f
    a938:	90                   	nop
    a939:	c9                   	leave  
    a93a:	c3                   	ret    

0000a93b <kprintf>:
#include <stdint.h>

extern void printf(const char* fmt, va_list arg);

void kprintf(const char* frmt, ...)
{
    a93b:	55                   	push   %ebp
    a93c:	89 e5                	mov    %esp,%ebp
    a93e:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    a941:	8d 45 0c             	lea    0xc(%ebp),%eax
    a944:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    a947:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a94a:	83 ec 08             	sub    $0x8,%esp
    a94d:	50                   	push   %eax
    a94e:	ff 75 08             	pushl  0x8(%ebp)
    a951:	e8 45 e7 ff ff       	call   909b <printf>
    a956:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    a959:	90                   	nop
    a95a:	c9                   	leave  
    a95b:	c3                   	ret    

0000a95c <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    a95c:	55                   	push   %ebp
    a95d:	89 e5                	mov    %esp,%ebp
    a95f:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    a962:	b8 1b 00 00 00       	mov    $0x1b,%eax
    a967:	89 c1                	mov    %eax,%ecx
    a969:	0f 32                	rdmsr  
    a96b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    a96e:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    a971:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a974:	c1 e0 05             	shl    $0x5,%eax
    a977:	89 c2                	mov    %eax,%edx
    a979:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a97c:	01 d0                	add    %edx,%eax
}
    a97e:	c9                   	leave  
    a97f:	c3                   	ret    

0000a980 <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    a980:	55                   	push   %ebp
    a981:	89 e5                	mov    %esp,%ebp
    a983:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    a986:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    a98d:	8b 45 08             	mov    0x8(%ebp),%eax
    a990:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a995:	80 cc 08             	or     $0x8,%ah
    a998:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    a99b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a99e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a9a1:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    a9a6:	0f 30                	wrmsr  
}
    a9a8:	90                   	nop
    a9a9:	c9                   	leave  
    a9aa:	c3                   	ret    

0000a9ab <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    a9ab:	55                   	push   %ebp
    a9ac:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    a9ae:	8b 15 20 21 01 00    	mov    0x12120,%edx
    a9b4:	8b 45 08             	mov    0x8(%ebp),%eax
    a9b7:	01 c0                	add    %eax,%eax
    a9b9:	01 d0                	add    %edx,%eax
    a9bb:	0f b7 00             	movzwl (%eax),%eax
    a9be:	0f b7 c0             	movzwl %ax,%eax
}
    a9c1:	5d                   	pop    %ebp
    a9c2:	c3                   	ret    

0000a9c3 <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    a9c3:	55                   	push   %ebp
    a9c4:	89 e5                	mov    %esp,%ebp
    a9c6:	83 ec 04             	sub    $0x4,%esp
    a9c9:	8b 45 0c             	mov    0xc(%ebp),%eax
    a9cc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    a9d0:	8b 15 20 21 01 00    	mov    0x12120,%edx
    a9d6:	8b 45 08             	mov    0x8(%ebp),%eax
    a9d9:	01 c0                	add    %eax,%eax
    a9db:	01 c2                	add    %eax,%edx
    a9dd:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a9e1:	66 89 02             	mov    %ax,(%edx)
}
    a9e4:	90                   	nop
    a9e5:	c9                   	leave  
    a9e6:	c3                   	ret    

0000a9e7 <enable_local_apic>:

void enable_local_apic()
{
    a9e7:	55                   	push   %ebp
    a9e8:	89 e5                	mov    %esp,%ebp
    a9ea:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    a9ed:	83 ec 08             	sub    $0x8,%esp
    a9f0:	68 fb 03 00 00       	push   $0x3fb
    a9f5:	68 00 d0 00 00       	push   $0xd000
    a9fa:	e8 89 f7 ff ff       	call   a188 <create_page_table>
    a9ff:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    aa02:	e8 55 ff ff ff       	call   a95c <get_apic_base>
    aa07:	a3 20 21 01 00       	mov    %eax,0x12120

    set_apic_base(get_apic_base());
    aa0c:	e8 4b ff ff ff       	call   a95c <get_apic_base>
    aa11:	83 ec 0c             	sub    $0xc,%esp
    aa14:	50                   	push   %eax
    aa15:	e8 66 ff ff ff       	call   a980 <set_apic_base>
    aa1a:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    aa1d:	83 ec 0c             	sub    $0xc,%esp
    aa20:	68 f0 00 00 00       	push   $0xf0
    aa25:	e8 81 ff ff ff       	call   a9ab <cpu_ReadLocalAPICReg>
    aa2a:	83 c4 10             	add    $0x10,%esp
    aa2d:	80 cc 01             	or     $0x1,%ah
    aa30:	0f b7 c0             	movzwl %ax,%eax
    aa33:	83 ec 08             	sub    $0x8,%esp
    aa36:	50                   	push   %eax
    aa37:	68 f0 00 00 00       	push   $0xf0
    aa3c:	e8 82 ff ff ff       	call   a9c3 <cpu_SetLocalAPICReg>
    aa41:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    aa44:	83 ec 08             	sub    $0x8,%esp
    aa47:	6a 02                	push   $0x2
    aa49:	6a 20                	push   $0x20
    aa4b:	e8 73 ff ff ff       	call   a9c3 <cpu_SetLocalAPICReg>
    aa50:	83 c4 10             	add    $0x10,%esp
}
    aa53:	90                   	nop
    aa54:	c9                   	leave  
    aa55:	c3                   	ret    

0000aa56 <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    aa56:	55                   	push   %ebp
    aa57:	89 e5                	mov    %esp,%ebp
    aa59:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    aa5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    aa63:	eb 49                	jmp    aaae <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    aa65:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa68:	89 d0                	mov    %edx,%eax
    aa6a:	01 c0                	add    %eax,%eax
    aa6c:	01 d0                	add    %edx,%eax
    aa6e:	c1 e0 02             	shl    $0x2,%eax
    aa71:	05 40 21 01 00       	add    $0x12140,%eax
    aa76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    aa7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa7f:	89 d0                	mov    %edx,%eax
    aa81:	01 c0                	add    %eax,%eax
    aa83:	01 d0                	add    %edx,%eax
    aa85:	c1 e0 02             	shl    $0x2,%eax
    aa88:	05 48 21 01 00       	add    $0x12148,%eax
    aa8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    aa93:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa96:	89 d0                	mov    %edx,%eax
    aa98:	01 c0                	add    %eax,%eax
    aa9a:	01 d0                	add    %edx,%eax
    aa9c:	c1 e0 02             	shl    $0x2,%eax
    aa9f:	05 44 21 01 00       	add    $0x12144,%eax
    aaa4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    aaaa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    aaae:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    aab5:	7e ae                	jle    aa65 <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    aab7:	c7 05 40 e1 01 00 40 	movl   $0x12140,0x1e140
    aabe:	21 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    aac1:	90                   	nop
    aac2:	c9                   	leave  
    aac3:	c3                   	ret    

0000aac4 <kmalloc>:

void* kmalloc(uint32_t size)
{
    aac4:	55                   	push   %ebp
    aac5:	89 e5                	mov    %esp,%ebp
    aac7:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    aaca:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aacf:	8b 00                	mov    (%eax),%eax
    aad1:	85 c0                	test   %eax,%eax
    aad3:	75 36                	jne    ab0b <kmalloc+0x47>
        _head_vmm_->address = KERNEL__VM_BASE;
    aad5:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aada:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    aadf:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    aae1:	a1 40 e1 01 00       	mov    0x1e140,%eax
    aae6:	8b 55 08             	mov    0x8(%ebp),%edx
    aae9:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    aaec:	83 ec 04             	sub    $0x4,%esp
    aaef:	ff 75 08             	pushl  0x8(%ebp)
    aaf2:	6a 00                	push   $0x0
    aaf4:	68 60 e1 01 00       	push   $0x1e160
    aaf9:	e8 6e e8 ff ff       	call   936c <memset>
    aafe:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    ab01:	b8 60 e1 01 00       	mov    $0x1e160,%eax
    ab06:	e9 7b 01 00 00       	jmp    ac86 <kmalloc+0x1c2>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    ab0b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab12:	eb 04                	jmp    ab18 <kmalloc+0x54>
        i++;
    ab14:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab18:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    ab1f:	77 17                	ja     ab38 <kmalloc+0x74>
    ab21:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab24:	89 d0                	mov    %edx,%eax
    ab26:	01 c0                	add    %eax,%eax
    ab28:	01 d0                	add    %edx,%eax
    ab2a:	c1 e0 02             	shl    $0x2,%eax
    ab2d:	05 40 21 01 00       	add    $0x12140,%eax
    ab32:	8b 00                	mov    (%eax),%eax
    ab34:	85 c0                	test   %eax,%eax
    ab36:	75 dc                	jne    ab14 <kmalloc+0x50>

    _new_item_ = &MM_BLOCK[i];
    ab38:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab3b:	89 d0                	mov    %edx,%eax
    ab3d:	01 c0                	add    %eax,%eax
    ab3f:	01 d0                	add    %edx,%eax
    ab41:	c1 e0 02             	shl    $0x2,%eax
    ab44:	05 40 21 01 00       	add    $0x12140,%eax
    ab49:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    ab4c:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ab51:	8b 00                	mov    (%eax),%eax
    ab53:	b9 60 e1 01 00       	mov    $0x1e160,%ecx
    ab58:	8b 55 08             	mov    0x8(%ebp),%edx
    ab5b:	01 ca                	add    %ecx,%edx
    ab5d:	39 d0                	cmp    %edx,%eax
    ab5f:	74 47                	je     aba8 <kmalloc+0xe4>
        _new_item_->address = KERNEL__VM_BASE;
    ab61:	ba 60 e1 01 00       	mov    $0x1e160,%edx
    ab66:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab69:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    ab6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab6e:	8b 55 08             	mov    0x8(%ebp),%edx
    ab71:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    ab74:	8b 15 40 e1 01 00    	mov    0x1e140,%edx
    ab7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab7d:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    ab80:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab83:	a3 40 e1 01 00       	mov    %eax,0x1e140

        memset((void*)_new_item_->address, 0, size);
    ab88:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab8b:	8b 00                	mov    (%eax),%eax
    ab8d:	83 ec 04             	sub    $0x4,%esp
    ab90:	ff 75 08             	pushl  0x8(%ebp)
    ab93:	6a 00                	push   $0x0
    ab95:	50                   	push   %eax
    ab96:	e8 d1 e7 ff ff       	call   936c <memset>
    ab9b:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ab9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aba1:	8b 00                	mov    (%eax),%eax
    aba3:	e9 de 00 00 00       	jmp    ac86 <kmalloc+0x1c2>
    }

    tmp = _head_vmm_;
    aba8:	a1 40 e1 01 00       	mov    0x1e140,%eax
    abad:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    abb0:	eb 27                	jmp    abd9 <kmalloc+0x115>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    abb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abb5:	8b 40 08             	mov    0x8(%eax),%eax
    abb8:	8b 10                	mov    (%eax),%edx
    abba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abbd:	8b 08                	mov    (%eax),%ecx
    abbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abc2:	8b 40 04             	mov    0x4(%eax),%eax
    abc5:	01 c1                	add    %eax,%ecx
    abc7:	8b 45 08             	mov    0x8(%ebp),%eax
    abca:	01 c8                	add    %ecx,%eax
    abcc:	39 c2                	cmp    %eax,%edx
    abce:	73 15                	jae    abe5 <kmalloc+0x121>
            break;

        tmp = tmp->next;
    abd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abd3:	8b 40 08             	mov    0x8(%eax),%eax
    abd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    abd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abdc:	8b 40 08             	mov    0x8(%eax),%eax
    abdf:	85 c0                	test   %eax,%eax
    abe1:	75 cf                	jne    abb2 <kmalloc+0xee>
    abe3:	eb 01                	jmp    abe6 <kmalloc+0x122>
            break;
    abe5:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    abe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abe9:	8b 40 08             	mov    0x8(%eax),%eax
    abec:	85 c0                	test   %eax,%eax
    abee:	75 4b                	jne    ac3b <kmalloc+0x177>
        _new_item_->size = size;
    abf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abf3:	8b 55 08             	mov    0x8(%ebp),%edx
    abf6:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    abf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abfc:	8b 10                	mov    (%eax),%edx
    abfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac01:	8b 40 04             	mov    0x4(%eax),%eax
    ac04:	01 c2                	add    %eax,%edx
    ac06:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac09:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    ac0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    ac15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac18:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac1b:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac21:	8b 00                	mov    (%eax),%eax
    ac23:	83 ec 04             	sub    $0x4,%esp
    ac26:	ff 75 08             	pushl  0x8(%ebp)
    ac29:	6a 00                	push   $0x0
    ac2b:	50                   	push   %eax
    ac2c:	e8 3b e7 ff ff       	call   936c <memset>
    ac31:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac34:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac37:	8b 00                	mov    (%eax),%eax
    ac39:	eb 4b                	jmp    ac86 <kmalloc+0x1c2>
    }

    else {
        _new_item_->size = size;
    ac3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac3e:	8b 55 08             	mov    0x8(%ebp),%edx
    ac41:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ac44:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac47:	8b 10                	mov    (%eax),%edx
    ac49:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac4c:	8b 40 04             	mov    0x4(%eax),%eax
    ac4f:	01 c2                	add    %eax,%edx
    ac51:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac54:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    ac56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac59:	8b 50 08             	mov    0x8(%eax),%edx
    ac5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac5f:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    ac62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac65:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac68:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac6e:	8b 00                	mov    (%eax),%eax
    ac70:	83 ec 04             	sub    $0x4,%esp
    ac73:	ff 75 08             	pushl  0x8(%ebp)
    ac76:	6a 00                	push   $0x0
    ac78:	50                   	push   %eax
    ac79:	e8 ee e6 ff ff       	call   936c <memset>
    ac7e:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac81:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac84:	8b 00                	mov    (%eax),%eax
    }
}
    ac86:	c9                   	leave  
    ac87:	c3                   	ret    

0000ac88 <free>:

void free(virtaddr_t _addr__)
{
    ac88:	55                   	push   %ebp
    ac89:	89 e5                	mov    %esp,%ebp
    ac8b:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    ac8e:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ac93:	8b 00                	mov    (%eax),%eax
    ac95:	39 45 08             	cmp    %eax,0x8(%ebp)
    ac98:	75 29                	jne    acc3 <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    ac9a:	a1 40 e1 01 00       	mov    0x1e140,%eax
    ac9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    aca5:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acaa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    acb1:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acb6:	8b 40 08             	mov    0x8(%eax),%eax
    acb9:	a3 40 e1 01 00       	mov    %eax,0x1e140
        return;
    acbe:	e9 ac 00 00 00       	jmp    ad6f <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    acc3:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acc8:	8b 40 08             	mov    0x8(%eax),%eax
    accb:	85 c0                	test   %eax,%eax
    accd:	75 16                	jne    ace5 <free+0x5d>
    accf:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acd4:	8b 00                	mov    (%eax),%eax
    acd6:	39 45 08             	cmp    %eax,0x8(%ebp)
    acd9:	75 0a                	jne    ace5 <free+0x5d>
        init_vmm();
    acdb:	e8 76 fd ff ff       	call   aa56 <init_vmm>
        return;
    ace0:	e9 8a 00 00 00       	jmp    ad6f <free+0xe7>
    }

    tmp = _head_vmm_;
    ace5:	a1 40 e1 01 00       	mov    0x1e140,%eax
    acea:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    aced:	eb 0f                	jmp    acfe <free+0x76>
        tmp_prev = tmp;
    acef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    acf2:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    acf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    acf8:	8b 40 08             	mov    0x8(%eax),%eax
    acfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    acfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad01:	8b 40 08             	mov    0x8(%eax),%eax
    ad04:	85 c0                	test   %eax,%eax
    ad06:	74 0a                	je     ad12 <free+0x8a>
    ad08:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad0b:	8b 00                	mov    (%eax),%eax
    ad0d:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad10:	75 dd                	jne    acef <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ad12:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad15:	8b 40 08             	mov    0x8(%eax),%eax
    ad18:	85 c0                	test   %eax,%eax
    ad1a:	75 29                	jne    ad45 <free+0xbd>
    ad1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad1f:	8b 00                	mov    (%eax),%eax
    ad21:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad24:	75 1f                	jne    ad45 <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad26:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ad39:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ad43:	eb 2a                	jmp    ad6f <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ad45:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad48:	8b 00                	mov    (%eax),%eax
    ad4a:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad4d:	75 20                	jne    ad6f <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad58:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ad62:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad65:	8b 50 08             	mov    0x8(%eax),%edx
    ad68:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad6b:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ad6e:	90                   	nop
    }
    ad6f:	c9                   	leave  
    ad70:	c3                   	ret    

0000ad71 <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ad71:	55                   	push   %ebp
    ad72:	89 e5                	mov    %esp,%ebp
    ad74:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ad77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    ad7e:	eb 49                	jmp    adc9 <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ad80:	ba db f0 00 00       	mov    $0xf0db,%edx
    ad85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad88:	c1 e0 04             	shl    $0x4,%eax
    ad8b:	05 40 f1 01 00       	add    $0x1f140,%eax
    ad90:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    ad92:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad95:	c1 e0 04             	shl    $0x4,%eax
    ad98:	05 44 f1 01 00       	add    $0x1f144,%eax
    ad9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    ada3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ada6:	c1 e0 04             	shl    $0x4,%eax
    ada9:	05 4c f1 01 00       	add    $0x1f14c,%eax
    adae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    adb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adb7:	c1 e0 04             	shl    $0x4,%eax
    adba:	05 48 f1 01 00       	add    $0x1f148,%eax
    adbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    adc5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    adc9:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    add0:	76 ae                	jbe    ad80 <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    add2:	83 ec 08             	sub    $0x8,%esp
    add5:	6a 01                	push   $0x1
    add7:	68 00 e0 00 00       	push   $0xe000
    addc:	e8 a7 f3 ff ff       	call   a188 <create_page_table>
    ade1:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    ade4:	c7 05 20 f1 01 00 40 	movl   $0x1f140,0x1f120
    adeb:	f1 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    adee:	90                   	nop
    adef:	c9                   	leave  
    adf0:	c3                   	ret    

0000adf1 <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    adf1:	55                   	push   %ebp
    adf2:	89 e5                	mov    %esp,%ebp
    adf4:	53                   	push   %ebx
    adf5:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    adf8:	a1 20 f1 01 00       	mov    0x1f120,%eax
    adfd:	8b 00                	mov    (%eax),%eax
    adff:	ba db f0 00 00       	mov    $0xf0db,%edx
    ae04:	39 d0                	cmp    %edx,%eax
    ae06:	75 40                	jne    ae48 <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    ae08:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae0d:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    ae13:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae18:	8b 55 08             	mov    0x8(%ebp),%edx
    ae1b:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    ae1e:	8b 45 08             	mov    0x8(%ebp),%eax
    ae21:	c1 e0 0c             	shl    $0xc,%eax
    ae24:	89 c2                	mov    %eax,%edx
    ae26:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae2b:	8b 00                	mov    (%eax),%eax
    ae2d:	83 ec 04             	sub    $0x4,%esp
    ae30:	52                   	push   %edx
    ae31:	6a 00                	push   $0x0
    ae33:	50                   	push   %eax
    ae34:	e8 33 e5 ff ff       	call   936c <memset>
    ae39:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    ae3c:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae41:	8b 00                	mov    (%eax),%eax
    ae43:	e9 ae 01 00 00       	jmp    aff6 <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    ae48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae4f:	eb 04                	jmp    ae55 <alloc_page+0x64>
        i++;
    ae51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae55:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae58:	c1 e0 04             	shl    $0x4,%eax
    ae5b:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae60:	8b 00                	mov    (%eax),%eax
    ae62:	ba db f0 00 00       	mov    $0xf0db,%edx
    ae67:	39 d0                	cmp    %edx,%eax
    ae69:	74 09                	je     ae74 <alloc_page+0x83>
    ae6b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    ae72:	76 dd                	jbe    ae51 <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    ae74:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae77:	c1 e0 04             	shl    $0x4,%eax
    ae7a:	05 40 f1 01 00       	add    $0x1f140,%eax
    ae7f:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    ae82:	a1 20 f1 01 00       	mov    0x1f120,%eax
    ae87:	8b 00                	mov    (%eax),%eax
    ae89:	8b 55 08             	mov    0x8(%ebp),%edx
    ae8c:	81 c2 00 01 00 00    	add    $0x100,%edx
    ae92:	c1 e2 0c             	shl    $0xc,%edx
    ae95:	39 d0                	cmp    %edx,%eax
    ae97:	72 4c                	jb     aee5 <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    ae99:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ae9c:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    aea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aea5:	8b 55 08             	mov    0x8(%ebp),%edx
    aea8:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    aeab:	8b 15 20 f1 01 00    	mov    0x1f120,%edx
    aeb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aeb4:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    aeb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aeba:	a3 20 f1 01 00       	mov    %eax,0x1f120

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    aebf:	8b 45 08             	mov    0x8(%ebp),%eax
    aec2:	c1 e0 0c             	shl    $0xc,%eax
    aec5:	89 c2                	mov    %eax,%edx
    aec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aeca:	8b 00                	mov    (%eax),%eax
    aecc:	83 ec 04             	sub    $0x4,%esp
    aecf:	52                   	push   %edx
    aed0:	6a 00                	push   $0x0
    aed2:	50                   	push   %eax
    aed3:	e8 94 e4 ff ff       	call   936c <memset>
    aed8:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    aedb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aede:	8b 00                	mov    (%eax),%eax
    aee0:	e9 11 01 00 00       	jmp    aff6 <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    aee5:	a1 20 f1 01 00       	mov    0x1f120,%eax
    aeea:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    aeed:	eb 2a                	jmp    af19 <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    aeef:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aef2:	8b 40 0c             	mov    0xc(%eax),%eax
    aef5:	8b 10                	mov    (%eax),%edx
    aef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aefa:	8b 08                	mov    (%eax),%ecx
    aefc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aeff:	8b 58 04             	mov    0x4(%eax),%ebx
    af02:	8b 45 08             	mov    0x8(%ebp),%eax
    af05:	01 d8                	add    %ebx,%eax
    af07:	c1 e0 0c             	shl    $0xc,%eax
    af0a:	01 c8                	add    %ecx,%eax
    af0c:	39 c2                	cmp    %eax,%edx
    af0e:	77 15                	ja     af25 <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    af10:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af13:	8b 40 0c             	mov    0xc(%eax),%eax
    af16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    af19:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af1c:	8b 40 0c             	mov    0xc(%eax),%eax
    af1f:	85 c0                	test   %eax,%eax
    af21:	75 cc                	jne    aeef <alloc_page+0xfe>
    af23:	eb 01                	jmp    af26 <alloc_page+0x135>
            break;
    af25:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    af26:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af29:	8b 40 0c             	mov    0xc(%eax),%eax
    af2c:	85 c0                	test   %eax,%eax
    af2e:	75 5d                	jne    af8d <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    af30:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af33:	8b 10                	mov    (%eax),%edx
    af35:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af38:	8b 40 04             	mov    0x4(%eax),%eax
    af3b:	c1 e0 0c             	shl    $0xc,%eax
    af3e:	01 c2                	add    %eax,%edx
    af40:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af43:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    af45:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af48:	8b 55 08             	mov    0x8(%ebp),%edx
    af4b:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    af4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af51:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    af58:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
    af5e:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    af61:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af64:	8b 55 ec             	mov    -0x14(%ebp),%edx
    af67:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    af6a:	8b 45 08             	mov    0x8(%ebp),%eax
    af6d:	c1 e0 0c             	shl    $0xc,%eax
    af70:	89 c2                	mov    %eax,%edx
    af72:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af75:	8b 00                	mov    (%eax),%eax
    af77:	83 ec 04             	sub    $0x4,%esp
    af7a:	52                   	push   %edx
    af7b:	6a 00                	push   $0x0
    af7d:	50                   	push   %eax
    af7e:	e8 e9 e3 ff ff       	call   936c <memset>
    af83:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    af86:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af89:	8b 00                	mov    (%eax),%eax
    af8b:	eb 69                	jmp    aff6 <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    af8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af90:	8b 10                	mov    (%eax),%edx
    af92:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af95:	8b 40 04             	mov    0x4(%eax),%eax
    af98:	c1 e0 0c             	shl    $0xc,%eax
    af9b:	01 c2                	add    %eax,%edx
    af9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afa0:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    afa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afa5:	8b 55 08             	mov    0x8(%ebp),%edx
    afa8:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    afab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afae:	8b 50 0c             	mov    0xc(%eax),%edx
    afb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afb4:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    afb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afba:	8b 55 f0             	mov    -0x10(%ebp),%edx
    afbd:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    afc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afc3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afc6:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    afc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afcc:	8b 40 0c             	mov    0xc(%eax),%eax
    afcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afd2:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    afd5:	8b 45 08             	mov    0x8(%ebp),%eax
    afd8:	c1 e0 0c             	shl    $0xc,%eax
    afdb:	89 c2                	mov    %eax,%edx
    afdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afe0:	8b 00                	mov    (%eax),%eax
    afe2:	83 ec 04             	sub    $0x4,%esp
    afe5:	52                   	push   %edx
    afe6:	6a 00                	push   $0x0
    afe8:	50                   	push   %eax
    afe9:	e8 7e e3 ff ff       	call   936c <memset>
    afee:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    aff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aff4:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    aff6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    aff9:	c9                   	leave  
    affa:	c3                   	ret    

0000affb <free_page>:

void free_page(_address_order_track_ page)
{
    affb:	55                   	push   %ebp
    affc:	89 e5                	mov    %esp,%ebp
    affe:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    b001:	8b 45 10             	mov    0x10(%ebp),%eax
    b004:	85 c0                	test   %eax,%eax
    b006:	75 2d                	jne    b035 <free_page+0x3a>
    b008:	8b 45 14             	mov    0x14(%ebp),%eax
    b00b:	85 c0                	test   %eax,%eax
    b00d:	74 26                	je     b035 <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    b00f:	b8 db f0 00 00       	mov    $0xf0db,%eax
    b014:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    b017:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b01c:	8b 40 0c             	mov    0xc(%eax),%eax
    b01f:	a3 20 f1 01 00       	mov    %eax,0x1f120
        _page_area_track_->previous_ = END_LIST;
    b024:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b029:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    b030:	e9 13 01 00 00       	jmp    b148 <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    b035:	8b 45 10             	mov    0x10(%ebp),%eax
    b038:	85 c0                	test   %eax,%eax
    b03a:	75 67                	jne    b0a3 <free_page+0xa8>
    b03c:	8b 45 14             	mov    0x14(%ebp),%eax
    b03f:	85 c0                	test   %eax,%eax
    b041:	75 60                	jne    b0a3 <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    b043:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    b04a:	eb 49                	jmp    b095 <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    b04c:	ba db f0 00 00       	mov    $0xf0db,%edx
    b051:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b054:	c1 e0 04             	shl    $0x4,%eax
    b057:	05 40 f1 01 00       	add    $0x1f140,%eax
    b05c:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    b05e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b061:	c1 e0 04             	shl    $0x4,%eax
    b064:	05 44 f1 01 00       	add    $0x1f144,%eax
    b069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    b06f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b072:	c1 e0 04             	shl    $0x4,%eax
    b075:	05 4c f1 01 00       	add    $0x1f14c,%eax
    b07a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    b080:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b083:	c1 e0 04             	shl    $0x4,%eax
    b086:	05 48 f1 01 00       	add    $0x1f148,%eax
    b08b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    b091:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b095:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    b09c:	76 ae                	jbe    b04c <free_page+0x51>
        }
        return;
    b09e:	e9 a5 00 00 00       	jmp    b148 <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b0a3:	a1 20 f1 01 00       	mov    0x1f120,%eax
    b0a8:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0ab:	eb 09                	jmp    b0b6 <free_page+0xbb>
            tmp = tmp->next_;
    b0ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0b0:	8b 40 0c             	mov    0xc(%eax),%eax
    b0b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0b9:	8b 10                	mov    (%eax),%edx
    b0bb:	8b 45 08             	mov    0x8(%ebp),%eax
    b0be:	39 c2                	cmp    %eax,%edx
    b0c0:	74 0a                	je     b0cc <free_page+0xd1>
    b0c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0c5:	8b 40 0c             	mov    0xc(%eax),%eax
    b0c8:	85 c0                	test   %eax,%eax
    b0ca:	75 e1                	jne    b0ad <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    b0cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0cf:	8b 40 0c             	mov    0xc(%eax),%eax
    b0d2:	85 c0                	test   %eax,%eax
    b0d4:	75 25                	jne    b0fb <free_page+0x100>
    b0d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0d9:	8b 10                	mov    (%eax),%edx
    b0db:	8b 45 08             	mov    0x8(%ebp),%eax
    b0de:	39 c2                	cmp    %eax,%edx
    b0e0:	75 19                	jne    b0fb <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b0e2:	ba db f0 00 00       	mov    $0xf0db,%edx
    b0e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0ea:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    b0ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0ef:	8b 40 08             	mov    0x8(%eax),%eax
    b0f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    b0f9:	eb 4d                	jmp    b148 <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    b0fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0fe:	8b 40 0c             	mov    0xc(%eax),%eax
    b101:	85 c0                	test   %eax,%eax
    b103:	74 36                	je     b13b <free_page+0x140>
    b105:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b108:	8b 10                	mov    (%eax),%edx
    b10a:	8b 45 08             	mov    0x8(%ebp),%eax
    b10d:	39 c2                	cmp    %eax,%edx
    b10f:	75 2a                	jne    b13b <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b111:	ba db f0 00 00       	mov    $0xf0db,%edx
    b116:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b119:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    b11b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b11e:	8b 40 08             	mov    0x8(%eax),%eax
    b121:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b124:	8b 52 0c             	mov    0xc(%edx),%edx
    b127:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    b12a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b12d:	8b 40 0c             	mov    0xc(%eax),%eax
    b130:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b133:	8b 52 08             	mov    0x8(%edx),%edx
    b136:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    b139:	eb 0d                	jmp    b148 <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    b13b:	a1 24 f1 01 00       	mov    0x1f124,%eax
    b140:	83 e8 01             	sub    $0x1,%eax
    b143:	a3 24 f1 01 00       	mov    %eax,0x1f124
    b148:	c9                   	leave  
    b149:	c3                   	ret    

0000b14a <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    b14a:	55                   	push   %ebp
    b14b:	89 e5                	mov    %esp,%ebp
    b14d:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    b150:	a1 48 31 02 00       	mov    0x23148,%eax
    b155:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    b158:	a1 48 31 02 00       	mov    0x23148,%eax
    b15d:	8b 40 3c             	mov    0x3c(%eax),%eax
    b160:	a3 48 31 02 00       	mov    %eax,0x23148

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    b165:	a1 48 31 02 00       	mov    0x23148,%eax
    b16a:	89 c2                	mov    %eax,%edx
    b16c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b16f:	83 ec 08             	sub    $0x8,%esp
    b172:	52                   	push   %edx
    b173:	50                   	push   %eax
    b174:	e8 c7 02 00 00       	call   b440 <switch_to_task>
    b179:	83 c4 10             	add    $0x10,%esp
}
    b17c:	90                   	nop
    b17d:	c9                   	leave  
    b17e:	c3                   	ret    

0000b17f <init_multitasking>:

void init_multitasking()
{
    b17f:	55                   	push   %ebp
    b180:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    b182:	c6 05 40 31 02 00 00 	movb   $0x0,0x23140
    sheduler.task_timer = DELAY_PER_TASK;
    b189:	c7 05 44 31 02 00 2c 	movl   $0x12c,0x23144
    b190:	01 00 00 
}
    b193:	90                   	nop
    b194:	5d                   	pop    %ebp
    b195:	c3                   	ret    

0000b196 <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    b196:	55                   	push   %ebp
    b197:	89 e5                	mov    %esp,%ebp
    b199:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    b19c:	8b 45 08             	mov    0x8(%ebp),%eax
    b19f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    b1a5:	8b 45 08             	mov    0x8(%ebp),%eax
    b1a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    b1af:	8b 45 08             	mov    0x8(%ebp),%eax
    b1b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    b1b9:	8b 45 08             	mov    0x8(%ebp),%eax
    b1bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    b1c3:	8b 45 08             	mov    0x8(%ebp),%eax
    b1c6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    b1cd:	8b 45 08             	mov    0x8(%ebp),%eax
    b1d0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    b1d7:	8b 45 08             	mov    0x8(%ebp),%eax
    b1da:	8b 55 10             	mov    0x10(%ebp),%edx
    b1dd:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    b1e0:	8b 55 0c             	mov    0xc(%ebp),%edx
    b1e3:	8b 45 08             	mov    0x8(%ebp),%eax
    b1e6:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    b1e9:	8b 45 08             	mov    0x8(%ebp),%eax
    b1ec:	8b 55 14             	mov    0x14(%ebp),%edx
    b1ef:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    b1f2:	83 ec 0c             	sub    $0xc,%esp
    b1f5:	68 c8 00 00 00       	push   $0xc8
    b1fa:	e8 c5 f8 ff ff       	call   aac4 <kmalloc>
    b1ff:	83 c4 10             	add    $0x10,%esp
    b202:	89 c2                	mov    %eax,%edx
    b204:	8b 45 08             	mov    0x8(%ebp),%eax
    b207:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    b20a:	8b 45 08             	mov    0x8(%ebp),%eax
    b20d:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b214:	90                   	nop
    b215:	c9                   	leave  
    b216:	c3                   	ret    
    b217:	66 90                	xchg   %ax,%ax
    b219:	66 90                	xchg   %ax,%ax
    b21b:	66 90                	xchg   %ax,%ax
    b21d:	66 90                	xchg   %ax,%ax
    b21f:	90                   	nop

0000b220 <__exception_handler__>:
    b220:	58                   	pop    %eax
    b221:	a3 5c b6 00 00       	mov    %eax,0xb65c
    b226:	e8 68 e4 ff ff       	call   9693 <__exception__>
    b22b:	cf                   	iret   

0000b22c <__exception_no_ERRCODE_handler__>:
    b22c:	e8 68 e4 ff ff       	call   9699 <__exception_no_ERRCODE__>
    b231:	cf                   	iret   
    b232:	66 90                	xchg   %ax,%ax
    b234:	66 90                	xchg   %ax,%ax
    b236:	66 90                	xchg   %ax,%ax
    b238:	66 90                	xchg   %ax,%ax
    b23a:	66 90                	xchg   %ax,%ax
    b23c:	66 90                	xchg   %ax,%ax
    b23e:	66 90                	xchg   %ax,%ax

0000b240 <gdtr>:
    b240:	00 00                	add    %al,(%eax)
    b242:	00 00                	add    %al,(%eax)
	...

0000b246 <load_gdt>:
    b246:	fa                   	cli    
    b247:	50                   	push   %eax
    b248:	51                   	push   %ecx
    b249:	b9 00 00 00 00       	mov    $0x0,%ecx
    b24e:	89 0d 42 b2 00 00    	mov    %ecx,0xb242
    b254:	31 c0                	xor    %eax,%eax
    b256:	b8 00 01 00 00       	mov    $0x100,%eax
    b25b:	01 c8                	add    %ecx,%eax
    b25d:	66 a3 40 b2 00 00    	mov    %ax,0xb240
    b263:	0f 01 15 40 b2 00 00 	lgdtl  0xb240
    b26a:	8b 0d 42 b2 00 00    	mov    0xb242,%ecx
    b270:	83 c1 20             	add    $0x20,%ecx
    b273:	0f 00 d9             	ltr    %cx
    b276:	59                   	pop    %ecx
    b277:	58                   	pop    %eax
    b278:	c3                   	ret    

0000b279 <idtr>:
    b279:	00 00                	add    %al,(%eax)
    b27b:	00 00                	add    %al,(%eax)
	...

0000b27f <load_idt>:
    b27f:	fa                   	cli    
    b280:	50                   	push   %eax
    b281:	51                   	push   %ecx
    b282:	31 c9                	xor    %ecx,%ecx
    b284:	b9 20 00 01 00       	mov    $0x10020,%ecx
    b289:	89 0d 7b b2 00 00    	mov    %ecx,0xb27b
    b28f:	31 c0                	xor    %eax,%eax
    b291:	b8 00 04 00 00       	mov    $0x400,%eax
    b296:	01 c8                	add    %ecx,%eax
    b298:	66 a3 79 b2 00 00    	mov    %ax,0xb279
    b29e:	0f 01 1d 79 b2 00 00 	lidtl  0xb279
    b2a5:	59                   	pop    %ecx
    b2a6:	58                   	pop    %eax
    b2a7:	c3                   	ret    
    b2a8:	66 90                	xchg   %ax,%ax
    b2aa:	66 90                	xchg   %ax,%ax
    b2ac:	66 90                	xchg   %ax,%ax
    b2ae:	66 90                	xchg   %ax,%ax

0000b2b0 <irq1>:
    b2b0:	60                   	pusha  
    b2b1:	e8 7b ea ff ff       	call   9d31 <irq1_handler>
    b2b6:	61                   	popa   
    b2b7:	cf                   	iret   

0000b2b8 <irq2>:
    b2b8:	60                   	pusha  
    b2b9:	e8 8e ea ff ff       	call   9d4c <irq2_handler>
    b2be:	61                   	popa   
    b2bf:	cf                   	iret   

0000b2c0 <irq3>:
    b2c0:	60                   	pusha  
    b2c1:	e8 a9 ea ff ff       	call   9d6f <irq3_handler>
    b2c6:	61                   	popa   
    b2c7:	cf                   	iret   

0000b2c8 <irq4>:
    b2c8:	60                   	pusha  
    b2c9:	e8 c4 ea ff ff       	call   9d92 <irq4_handler>
    b2ce:	61                   	popa   
    b2cf:	cf                   	iret   

0000b2d0 <irq5>:
    b2d0:	60                   	pusha  
    b2d1:	e8 df ea ff ff       	call   9db5 <irq5_handler>
    b2d6:	61                   	popa   
    b2d7:	cf                   	iret   

0000b2d8 <irq6>:
    b2d8:	60                   	pusha  
    b2d9:	e8 fa ea ff ff       	call   9dd8 <irq6_handler>
    b2de:	61                   	popa   
    b2df:	cf                   	iret   

0000b2e0 <irq7>:
    b2e0:	60                   	pusha  
    b2e1:	e8 15 eb ff ff       	call   9dfb <irq7_handler>
    b2e6:	61                   	popa   
    b2e7:	cf                   	iret   

0000b2e8 <irq8>:
    b2e8:	60                   	pusha  
    b2e9:	e8 30 eb ff ff       	call   9e1e <irq8_handler>
    b2ee:	61                   	popa   
    b2ef:	cf                   	iret   

0000b2f0 <irq9>:
    b2f0:	60                   	pusha  
    b2f1:	e8 4b eb ff ff       	call   9e41 <irq9_handler>
    b2f6:	61                   	popa   
    b2f7:	cf                   	iret   

0000b2f8 <irq10>:
    b2f8:	60                   	pusha  
    b2f9:	e8 66 eb ff ff       	call   9e64 <irq10_handler>
    b2fe:	61                   	popa   
    b2ff:	cf                   	iret   

0000b300 <irq11>:
    b300:	60                   	pusha  
    b301:	e8 81 eb ff ff       	call   9e87 <irq11_handler>
    b306:	61                   	popa   
    b307:	cf                   	iret   

0000b308 <irq12>:
    b308:	60                   	pusha  
    b309:	e8 9c eb ff ff       	call   9eaa <irq12_handler>
    b30e:	61                   	popa   
    b30f:	cf                   	iret   

0000b310 <irq13>:
    b310:	60                   	pusha  
    b311:	e8 b7 eb ff ff       	call   9ecd <irq13_handler>
    b316:	61                   	popa   
    b317:	cf                   	iret   

0000b318 <irq14>:
    b318:	60                   	pusha  
    b319:	e8 d2 eb ff ff       	call   9ef0 <irq14_handler>
    b31e:	61                   	popa   
    b31f:	cf                   	iret   

0000b320 <irq15>:
    b320:	60                   	pusha  
    b321:	e8 ed eb ff ff       	call   9f13 <irq15_handler>
    b326:	61                   	popa   
    b327:	cf                   	iret   
    b328:	66 90                	xchg   %ax,%ax
    b32a:	66 90                	xchg   %ax,%ax
    b32c:	66 90                	xchg   %ax,%ax
    b32e:	66 90                	xchg   %ax,%ax

0000b330 <_FlushPagingCache_>:
    b330:	b8 00 10 01 00       	mov    $0x11000,%eax
    b335:	0f 22 d8             	mov    %eax,%cr3
    b338:	c3                   	ret    

0000b339 <_EnablingPaging_>:
    b339:	e8 f2 ff ff ff       	call   b330 <_FlushPagingCache_>
    b33e:	0f 20 c0             	mov    %cr0,%eax
    b341:	0d 01 00 00 80       	or     $0x80000001,%eax
    b346:	0f 22 c0             	mov    %eax,%cr0
    b349:	c3                   	ret    

0000b34a <PagingFault_Handler>:
    b34a:	58                   	pop    %eax
    b34b:	a3 60 b6 00 00       	mov    %eax,0xb660
    b350:	e8 11 f0 ff ff       	call   a366 <Paging_fault>
    b355:	cf                   	iret   
    b356:	66 90                	xchg   %ax,%ax
    b358:	66 90                	xchg   %ax,%ax
    b35a:	66 90                	xchg   %ax,%ax
    b35c:	66 90                	xchg   %ax,%ax
    b35e:	66 90                	xchg   %ax,%ax

0000b360 <PIT_handler>:
    b360:	9c                   	pushf  
    b361:	e8 16 00 00 00       	call   b37c <irq_PIT>
    b366:	e8 42 f2 ff ff       	call   a5ad <conserv_status_byte>
    b36b:	e8 d9 f2 ff ff       	call   a649 <sheduler_cpu_timer>
    b370:	90                   	nop
    b371:	90                   	nop
    b372:	90                   	nop
    b373:	90                   	nop
    b374:	90                   	nop
    b375:	90                   	nop
    b376:	90                   	nop
    b377:	90                   	nop
    b378:	90                   	nop
    b379:	90                   	nop
    b37a:	9d                   	popf   
    b37b:	cf                   	iret   

0000b37c <irq_PIT>:
    b37c:	a1 68 32 02 00       	mov    0x23268,%eax
    b381:	8b 1d 6c 32 02 00    	mov    0x2326c,%ebx
    b387:	01 05 60 32 02 00    	add    %eax,0x23260
    b38d:	11 1d 64 32 02 00    	adc    %ebx,0x23264
    b393:	6a 00                	push   $0x0
    b395:	e8 d2 ef ff ff       	call   a36c <PIC_sendEOI>
    b39a:	58                   	pop    %eax
    b39b:	c3                   	ret    

0000b39c <calculate_frequency>:
    b39c:	60                   	pusha  
    b39d:	8b 1d 04 20 01 00    	mov    0x12004,%ebx
    b3a3:	b8 00 00 01 00       	mov    $0x10000,%eax
    b3a8:	83 fb 12             	cmp    $0x12,%ebx
    b3ab:	76 34                	jbe    b3e1 <calculate_frequency.gotReloadValue>
    b3ad:	b8 01 00 00 00       	mov    $0x1,%eax
    b3b2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    b3b8:	73 27                	jae    b3e1 <calculate_frequency.gotReloadValue>
    b3ba:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b3bf:	ba 00 00 00 00       	mov    $0x0,%edx
    b3c4:	f7 f3                	div    %ebx
    b3c6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b3cc:	72 01                	jb     b3cf <calculate_frequency.l1>
    b3ce:	40                   	inc    %eax

0000b3cf <calculate_frequency.l1>:
    b3cf:	bb 03 00 00 00       	mov    $0x3,%ebx
    b3d4:	ba 00 00 00 00       	mov    $0x0,%edx
    b3d9:	f7 f3                	div    %ebx
    b3db:	83 fa 01             	cmp    $0x1,%edx
    b3de:	72 01                	jb     b3e1 <calculate_frequency.gotReloadValue>
    b3e0:	40                   	inc    %eax

0000b3e1 <calculate_frequency.gotReloadValue>:
    b3e1:	50                   	push   %eax
    b3e2:	66 a3 74 32 02 00    	mov    %ax,0x23274
    b3e8:	89 c3                	mov    %eax,%ebx
    b3ea:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b3ef:	ba 00 00 00 00       	mov    $0x0,%edx
    b3f4:	f7 f3                	div    %ebx
    b3f6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b3fc:	72 01                	jb     b3ff <calculate_frequency.l3>
    b3fe:	40                   	inc    %eax

0000b3ff <calculate_frequency.l3>:
    b3ff:	bb 03 00 00 00       	mov    $0x3,%ebx
    b404:	ba 00 00 00 00       	mov    $0x0,%edx
    b409:	f7 f3                	div    %ebx
    b40b:	83 fa 01             	cmp    $0x1,%edx
    b40e:	72 01                	jb     b411 <calculate_frequency.l4>
    b410:	40                   	inc    %eax

0000b411 <calculate_frequency.l4>:
    b411:	a3 70 32 02 00       	mov    %eax,0x23270
    b416:	5b                   	pop    %ebx
    b417:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    b41c:	f7 e3                	mul    %ebx
    b41e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    b422:	c1 ea 0a             	shr    $0xa,%edx
    b425:	89 15 6c 32 02 00    	mov    %edx,0x2326c
    b42b:	a3 68 32 02 00       	mov    %eax,0x23268
    b430:	61                   	popa   
    b431:	c3                   	ret    
    b432:	66 90                	xchg   %ax,%ax
    b434:	66 90                	xchg   %ax,%ax
    b436:	66 90                	xchg   %ax,%ax
    b438:	66 90                	xchg   %ax,%ax
    b43a:	66 90                	xchg   %ax,%ax
    b43c:	66 90                	xchg   %ax,%ax
    b43e:	66 90                	xchg   %ax,%ax

0000b440 <switch_to_task>:
    b440:	50                   	push   %eax
    b441:	8b 44 24 08          	mov    0x8(%esp),%eax
    b445:	89 58 04             	mov    %ebx,0x4(%eax)
    b448:	89 48 08             	mov    %ecx,0x8(%eax)
    b44b:	89 50 0c             	mov    %edx,0xc(%eax)
    b44e:	89 70 10             	mov    %esi,0x10(%eax)
    b451:	89 78 14             	mov    %edi,0x14(%eax)
    b454:	89 60 18             	mov    %esp,0x18(%eax)
    b457:	89 68 1c             	mov    %ebp,0x1c(%eax)
    b45a:	51                   	push   %ecx
    b45b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    b45f:	89 48 20             	mov    %ecx,0x20(%eax)
    b462:	59                   	pop    %ecx
    b463:	51                   	push   %ecx
    b464:	9c                   	pushf  
    b465:	59                   	pop    %ecx
    b466:	89 48 24             	mov    %ecx,0x24(%eax)
    b469:	59                   	pop    %ecx
    b46a:	51                   	push   %ecx
    b46b:	0f 20 d9             	mov    %cr3,%ecx
    b46e:	89 48 28             	mov    %ecx,0x28(%eax)
    b471:	59                   	pop    %ecx
    b472:	8c 40 2c             	mov    %es,0x2c(%eax)
    b475:	8c 68 2e             	mov    %gs,0x2e(%eax)
    b478:	8c 60 30             	mov    %fs,0x30(%eax)
    b47b:	51                   	push   %ecx
    b47c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    b480:	89 08                	mov    %ecx,(%eax)
    b482:	59                   	pop    %ecx
    b483:	58                   	pop    %eax
    b484:	8b 44 24 08          	mov    0x8(%esp),%eax
    b488:	8b 58 04             	mov    0x4(%eax),%ebx
    b48b:	8b 48 08             	mov    0x8(%eax),%ecx
    b48e:	8b 50 0c             	mov    0xc(%eax),%edx
    b491:	8b 70 10             	mov    0x10(%eax),%esi
    b494:	8b 78 14             	mov    0x14(%eax),%edi
    b497:	8b 60 18             	mov    0x18(%eax),%esp
    b49a:	8b 68 1c             	mov    0x1c(%eax),%ebp
    b49d:	51                   	push   %ecx
    b49e:	8b 48 24             	mov    0x24(%eax),%ecx
    b4a1:	51                   	push   %ecx
    b4a2:	9d                   	popf   
    b4a3:	59                   	pop    %ecx
    b4a4:	51                   	push   %ecx
    b4a5:	8b 48 28             	mov    0x28(%eax),%ecx
    b4a8:	0f 22 d9             	mov    %ecx,%cr3
    b4ab:	59                   	pop    %ecx
    b4ac:	8e 40 2c             	mov    0x2c(%eax),%es
    b4af:	8e 68 2e             	mov    0x2e(%eax),%gs
    b4b2:	8e 60 30             	mov    0x30(%eax),%fs
    b4b5:	8b 40 20             	mov    0x20(%eax),%eax
    b4b8:	89 04 24             	mov    %eax,(%esp)
    b4bb:	c3                   	ret    
