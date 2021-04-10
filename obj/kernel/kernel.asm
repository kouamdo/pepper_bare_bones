
bin/kernel.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00009000 <main>:
#include <lib.h>
#include <mm.h>
#include <task.h>

void main()
{
    9000:	55                   	push   %ebp
    9001:	89 e5                	mov    %esp,%ebp
    9003:	83 e4 f0             	and    $0xfffffff0,%esp
    //On initialise le necessaire avant de lancer la console

    cli;
    9006:	fa                   	cli    

    cclean();
    9007:	e8 c0 03 00 00       	call   93cc <cclean>

    init_gdt();
    900c:	e8 d3 06 00 00       	call   96e4 <init_gdt>

    init_idt();
    9011:	e8 07 08 00 00       	call   981d <init_idt>

    sti;
    9016:	fb                   	sti    

    while (1)
    9017:	eb fe                	jmp    9017 <main+0x17>

00009019 <putchar>:
/*
 * Print a number (base <= 16) in reverse order,
 */

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
    902f:	e8 7d 04 00 00       	call   94b1 <cputchar>
    9034:	83 c4 10             	add    $0x10,%esp
}
    9037:	90                   	nop
    9038:	c9                   	leave  
    9039:	c3                   	ret    

0000903a <puts>:

void puts(const char* string)
{
    903a:	55                   	push   %ebp
    903b:	89 e5                	mov    %esp,%ebp
    903d:	83 ec 08             	sub    $0x8,%esp
    if (*string != '\0') {
    9040:	8b 45 08             	mov    0x8(%ebp),%eax
    9043:	0f b6 00             	movzbl (%eax),%eax
    9046:	84 c0                	test   %al,%al
    9048:	74 2a                	je     9074 <puts+0x3a>
        putchar(*string);
    904a:	8b 45 08             	mov    0x8(%ebp),%eax
    904d:	0f b6 00             	movzbl (%eax),%eax
    9050:	0f b6 c0             	movzbl %al,%eax
    9053:	83 ec 0c             	sub    $0xc,%esp
    9056:	50                   	push   %eax
    9057:	e8 bd ff ff ff       	call   9019 <putchar>
    905c:	83 c4 10             	add    $0x10,%esp
        puts(string++);
    905f:	8b 45 08             	mov    0x8(%ebp),%eax
    9062:	8d 50 01             	lea    0x1(%eax),%edx
    9065:	89 55 08             	mov    %edx,0x8(%ebp)
    9068:	83 ec 0c             	sub    $0xc,%esp
    906b:	50                   	push   %eax
    906c:	e8 c9 ff ff ff       	call   903a <puts>
    9071:	83 c4 10             	add    $0x10,%esp
    }
}
    9074:	90                   	nop
    9075:	c9                   	leave  
    9076:	c3                   	ret    

00009077 <printnum>:

static void printnum(uint32_t num, uint8_t base)
{
    9077:	55                   	push   %ebp
    9078:	89 e5                	mov    %esp,%ebp
    907a:	53                   	push   %ebx
    907b:	83 ec 14             	sub    $0x14,%esp
    907e:	8b 45 0c             	mov    0xc(%ebp),%eax
    9081:	88 45 f4             	mov    %al,-0xc(%ebp)
    if (num >= base) printnum((uint32_t)(num / base), base);
    9084:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    9088:	39 45 08             	cmp    %eax,0x8(%ebp)
    908b:	72 1f                	jb     90ac <printnum+0x35>
    908d:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    9091:	0f b6 5d f4          	movzbl -0xc(%ebp),%ebx
    9095:	8b 45 08             	mov    0x8(%ebp),%eax
    9098:	ba 00 00 00 00       	mov    $0x0,%edx
    909d:	f7 f3                	div    %ebx
    909f:	83 ec 08             	sub    $0x8,%esp
    90a2:	51                   	push   %ecx
    90a3:	50                   	push   %eax
    90a4:	e8 ce ff ff ff       	call   9077 <printnum>
    90a9:	83 c4 10             	add    $0x10,%esp

    putchar("0123456789abcdef"[num % base]);
    90ac:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
    90b0:	8b 45 08             	mov    0x8(%ebp),%eax
    90b3:	ba 00 00 00 00       	mov    $0x0,%edx
    90b8:	f7 f1                	div    %ecx
    90ba:	89 d0                	mov    %edx,%eax
    90bc:	0f b6 80 00 f0 00 00 	movzbl 0xf000(%eax),%eax
    90c3:	0f b6 c0             	movzbl %al,%eax
    90c6:	83 ec 0c             	sub    $0xc,%esp
    90c9:	50                   	push   %eax
    90ca:	e8 4a ff ff ff       	call   9019 <putchar>
    90cf:	83 c4 10             	add    $0x10,%esp
}
    90d2:	90                   	nop
    90d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    90d6:	c9                   	leave  
    90d7:	c3                   	ret    

000090d8 <printf>:

void printf(const char* fmt, ...)
{
    90d8:	55                   	push   %ebp
    90d9:	89 e5                	mov    %esp,%ebp
    90db:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;
    char*    s;
    va_list  arg;
    va_start(arg, fmt);
    90de:	8d 45 0c             	lea    0xc(%ebp),%eax
    90e1:	89 45 e8             	mov    %eax,-0x18(%ebp)

    const char* chr_tmp;

    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    90e4:	8b 45 08             	mov    0x8(%ebp),%eax
    90e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    90ea:	e9 0d 01 00 00       	jmp    91fc <printf+0x124>
        while (*chr_tmp != '%') {
            putchar(*chr_tmp);
    90ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    90f2:	0f b6 00             	movzbl (%eax),%eax
    90f5:	0f b6 c0             	movzbl %al,%eax
    90f8:	83 ec 0c             	sub    $0xc,%esp
    90fb:	50                   	push   %eax
    90fc:	e8 18 ff ff ff       	call   9019 <putchar>
    9101:	83 c4 10             	add    $0x10,%esp
            chr_tmp++;
    9104:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*chr_tmp != '%') {
    9108:	8b 45 f4             	mov    -0xc(%ebp),%eax
    910b:	0f b6 00             	movzbl (%eax),%eax
    910e:	3c 25                	cmp    $0x25,%al
    9110:	75 dd                	jne    90ef <printf+0x17>
        }

        chr_tmp++;
    9112:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

        switch (*chr_tmp) {
    9116:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9119:	0f b6 00             	movzbl (%eax),%eax
    911c:	0f be c0             	movsbl %al,%eax
    911f:	83 e8 62             	sub    $0x62,%eax
    9122:	83 f8 16             	cmp    $0x16,%eax
    9125:	0f 87 cc 00 00 00    	ja     91f7 <printf+0x11f>
    912b:	8b 04 85 14 f0 00 00 	mov    0xf014(,%eax,4),%eax
    9132:	ff e0                	jmp    *%eax
        case 'c':
            i = va_arg(arg, uint32_t);
    9134:	8b 45 e8             	mov    -0x18(%ebp),%eax
    9137:	8d 50 04             	lea    0x4(%eax),%edx
    913a:	89 55 e8             	mov    %edx,-0x18(%ebp)
    913d:	8b 00                	mov    (%eax),%eax
    913f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            putchar(i);
    9142:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9145:	0f b6 c0             	movzbl %al,%eax
    9148:	83 ec 0c             	sub    $0xc,%esp
    914b:	50                   	push   %eax
    914c:	e8 c8 fe ff ff       	call   9019 <putchar>
    9151:	83 c4 10             	add    $0x10,%esp
            break;
    9154:	e9 9f 00 00 00       	jmp    91f8 <printf+0x120>
        case 'd':
            i = va_arg(arg, uint32_t);
    9159:	8b 45 e8             	mov    -0x18(%ebp),%eax
    915c:	8d 50 04             	lea    0x4(%eax),%edx
    915f:	89 55 e8             	mov    %edx,-0x18(%ebp)
    9162:	8b 00                	mov    (%eax),%eax
    9164:	89 45 f0             	mov    %eax,-0x10(%ebp)
            printnum(i, 10);
    9167:	83 ec 08             	sub    $0x8,%esp
    916a:	6a 0a                	push   $0xa
    916c:	ff 75 f0             	pushl  -0x10(%ebp)
    916f:	e8 03 ff ff ff       	call   9077 <printnum>
    9174:	83 c4 10             	add    $0x10,%esp
            break;
    9177:	eb 7f                	jmp    91f8 <printf+0x120>
        case 'o':
            i = va_arg(arg, uint32_t);
    9179:	8b 45 e8             	mov    -0x18(%ebp),%eax
    917c:	8d 50 04             	lea    0x4(%eax),%edx
    917f:	89 55 e8             	mov    %edx,-0x18(%ebp)
    9182:	8b 00                	mov    (%eax),%eax
    9184:	89 45 f0             	mov    %eax,-0x10(%ebp)
            printnum(i, 8);
    9187:	83 ec 08             	sub    $0x8,%esp
    918a:	6a 08                	push   $0x8
    918c:	ff 75 f0             	pushl  -0x10(%ebp)
    918f:	e8 e3 fe ff ff       	call   9077 <printnum>
    9194:	83 c4 10             	add    $0x10,%esp
            break;
    9197:	eb 5f                	jmp    91f8 <printf+0x120>
        case 'b':
            i = va_arg(arg, uint32_t);
    9199:	8b 45 e8             	mov    -0x18(%ebp),%eax
    919c:	8d 50 04             	lea    0x4(%eax),%edx
    919f:	89 55 e8             	mov    %edx,-0x18(%ebp)
    91a2:	8b 00                	mov    (%eax),%eax
    91a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
            printnum(i, 2);
    91a7:	83 ec 08             	sub    $0x8,%esp
    91aa:	6a 02                	push   $0x2
    91ac:	ff 75 f0             	pushl  -0x10(%ebp)
    91af:	e8 c3 fe ff ff       	call   9077 <printnum>
    91b4:	83 c4 10             	add    $0x10,%esp
            break;
    91b7:	eb 3f                	jmp    91f8 <printf+0x120>
        case 'x':
            i = va_arg(arg, uint32_t);
    91b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    91bc:	8d 50 04             	lea    0x4(%eax),%edx
    91bf:	89 55 e8             	mov    %edx,-0x18(%ebp)
    91c2:	8b 00                	mov    (%eax),%eax
    91c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
            printnum(i, 16);
    91c7:	83 ec 08             	sub    $0x8,%esp
    91ca:	6a 10                	push   $0x10
    91cc:	ff 75 f0             	pushl  -0x10(%ebp)
    91cf:	e8 a3 fe ff ff       	call   9077 <printnum>
    91d4:	83 c4 10             	add    $0x10,%esp
            break;
    91d7:	eb 1f                	jmp    91f8 <printf+0x120>
        case 's':
            s = va_arg(arg, char*);
    91d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    91dc:	8d 50 04             	lea    0x4(%eax),%edx
    91df:	89 55 e8             	mov    %edx,-0x18(%ebp)
    91e2:	8b 00                	mov    (%eax),%eax
    91e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
            puts(s);
    91e7:	83 ec 0c             	sub    $0xc,%esp
    91ea:	ff 75 ec             	pushl  -0x14(%ebp)
    91ed:	e8 48 fe ff ff       	call   903a <puts>
    91f2:	83 c4 10             	add    $0x10,%esp
            break;
    91f5:	eb 01                	jmp    91f8 <printf+0x120>
        default:
            break;
    91f7:	90                   	nop
    for (chr_tmp = fmt; *chr_tmp != '\0'; chr_tmp++) {
    91f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    91fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91ff:	0f b6 00             	movzbl (%eax),%eax
    9202:	84 c0                	test   %al,%al
    9204:	0f 85 fe fe ff ff    	jne    9108 <printf+0x30>
        }
    }

    va_end(arg);
    920a:	90                   	nop
    920b:	90                   	nop
    920c:	c9                   	leave  
    920d:	c3                   	ret    

0000920e <_strcmp_>:
#include "../../include/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    920e:	55                   	push   %ebp
    920f:	89 e5                	mov    %esp,%ebp
    9211:	53                   	push   %ebx
    9212:	83 ec 04             	sub    $0x4,%esp
    if (_strlen_(str2) != _strlen_(str1))
    9215:	83 ec 0c             	sub    $0xc,%esp
    9218:	ff 75 0c             	pushl  0xc(%ebp)
    921b:	e8 59 00 00 00       	call   9279 <_strlen_>
    9220:	83 c4 10             	add    $0x10,%esp
    9223:	89 c3                	mov    %eax,%ebx
    9225:	83 ec 0c             	sub    $0xc,%esp
    9228:	ff 75 08             	pushl  0x8(%ebp)
    922b:	e8 49 00 00 00       	call   9279 <_strlen_>
    9230:	83 c4 10             	add    $0x10,%esp
    9233:	38 c3                	cmp    %al,%bl
    9235:	74 0f                	je     9246 <_strcmp_+0x38>
        return 0;
    9237:	b8 00 00 00 00       	mov    $0x0,%eax
    923c:	eb 36                	jmp    9274 <_strcmp_+0x66>

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
    923e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        str2++;
    9242:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while ((*str1 == *str2) && (*str1 != '\000')) {
    9246:	8b 45 08             	mov    0x8(%ebp),%eax
    9249:	0f b6 10             	movzbl (%eax),%edx
    924c:	8b 45 0c             	mov    0xc(%ebp),%eax
    924f:	0f b6 00             	movzbl (%eax),%eax
    9252:	38 c2                	cmp    %al,%dl
    9254:	75 0a                	jne    9260 <_strcmp_+0x52>
    9256:	8b 45 08             	mov    0x8(%ebp),%eax
    9259:	0f b6 00             	movzbl (%eax),%eax
    925c:	84 c0                	test   %al,%al
    925e:	75 de                	jne    923e <_strcmp_+0x30>
    }

    return *str1 == *str2;
    9260:	8b 45 08             	mov    0x8(%ebp),%eax
    9263:	0f b6 10             	movzbl (%eax),%edx
    9266:	8b 45 0c             	mov    0xc(%ebp),%eax
    9269:	0f b6 00             	movzbl (%eax),%eax
    926c:	38 c2                	cmp    %al,%dl
    926e:	0f 94 c0             	sete   %al
    9271:	0f b6 c0             	movzbl %al,%eax
}
    9274:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    9277:	c9                   	leave  
    9278:	c3                   	ret    

00009279 <_strlen_>:

uint8_t _strlen_(char* str)
{
    9279:	55                   	push   %ebp
    927a:	89 e5                	mov    %esp,%ebp
    927c:	83 ec 10             	sub    $0x10,%esp
    if (*str == '\000')
    927f:	8b 45 08             	mov    0x8(%ebp),%eax
    9282:	0f b6 00             	movzbl (%eax),%eax
    9285:	84 c0                	test   %al,%al
    9287:	75 07                	jne    9290 <_strlen_+0x17>
        return 0;
    9289:	b8 00 00 00 00       	mov    $0x0,%eax
    928e:	eb 22                	jmp    92b2 <_strlen_+0x39>

    uint8_t i = 1;
    9290:	c6 45 ff 01          	movb   $0x1,-0x1(%ebp)

    while (*str != '\000') {
    9294:	eb 0e                	jmp    92a4 <_strlen_+0x2b>
        str++;
    9296:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        i++;
    929a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    929e:	83 c0 01             	add    $0x1,%eax
    92a1:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (*str != '\000') {
    92a4:	8b 45 08             	mov    0x8(%ebp),%eax
    92a7:	0f b6 00             	movzbl (%eax),%eax
    92aa:	84 c0                	test   %al,%al
    92ac:	75 e8                	jne    9296 <_strlen_+0x1d>
    }

    return i;
    92ae:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
    92b2:	c9                   	leave  
    92b3:	c3                   	ret    

000092b4 <_strcpy_>:

void* _strcpy_(char* dest, char* src)
{
    92b4:	55                   	push   %ebp
    92b5:	89 e5                	mov    %esp,%ebp
    92b7:	83 ec 10             	sub    $0x10,%esp
    if (dest == NULL)
    92ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    92be:	75 07                	jne    92c7 <_strcpy_+0x13>
        return (void*)NULL;
    92c0:	b8 00 00 00 00       	mov    $0x0,%eax
    92c5:	eb 46                	jmp    930d <_strcpy_+0x59>

    uint8_t i = 0;
    92c7:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    while (src[i] != '\000') {
    92cb:	eb 21                	jmp    92ee <_strcpy_+0x3a>
        dest[i] = src[i];
    92cd:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    92d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    92d4:	01 d0                	add    %edx,%eax
    92d6:	0f b6 4d ff          	movzbl -0x1(%ebp),%ecx
    92da:	8b 55 08             	mov    0x8(%ebp),%edx
    92dd:	01 ca                	add    %ecx,%edx
    92df:	0f b6 00             	movzbl (%eax),%eax
    92e2:	88 02                	mov    %al,(%edx)
        i++;
    92e4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    92e8:	83 c0 01             	add    $0x1,%eax
    92eb:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (src[i] != '\000') {
    92ee:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    92f2:	8b 45 0c             	mov    0xc(%ebp),%eax
    92f5:	01 d0                	add    %edx,%eax
    92f7:	0f b6 00             	movzbl (%eax),%eax
    92fa:	84 c0                	test   %al,%al
    92fc:	75 cf                	jne    92cd <_strcpy_+0x19>
    }

    dest[i] = '\000';
    92fe:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9302:	8b 45 08             	mov    0x8(%ebp),%eax
    9305:	01 d0                	add    %edx,%eax
    9307:	c6 00 00             	movb   $0x0,(%eax)

    return (void*)dest;
    930a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    930d:	c9                   	leave  
    930e:	c3                   	ret    

0000930f <memcpy>:

void* memcpy(void* dest, const void* src, uint32_t size)
{
    930f:	55                   	push   %ebp
    9310:	89 e5                	mov    %esp,%ebp
    9312:	83 ec 10             	sub    $0x10,%esp
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    9315:	8b 45 08             	mov    0x8(%ebp),%eax
    9318:	89 45 fc             	mov    %eax,-0x4(%ebp)
    _src_ = (char*)src;
    931b:	8b 45 0c             	mov    0xc(%ebp),%eax
    931e:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (size) {
    9321:	eb 1b                	jmp    933e <memcpy+0x2f>
        *(_dest_++) = *(_src_++);
    9323:	8b 55 f8             	mov    -0x8(%ebp),%edx
    9326:	8d 42 01             	lea    0x1(%edx),%eax
    9329:	89 45 f8             	mov    %eax,-0x8(%ebp)
    932c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    932f:	8d 48 01             	lea    0x1(%eax),%ecx
    9332:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    9335:	0f b6 12             	movzbl (%edx),%edx
    9338:	88 10                	mov    %dl,(%eax)
        size--;
    933a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (size) {
    933e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    9342:	75 df                	jne    9323 <memcpy+0x14>
    }

    return (void*)dest;
    9344:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9347:	c9                   	leave  
    9348:	c3                   	ret    

00009349 <memset>:

void* memset(void* mem, void* data, uint32_t size)
{
    9349:	55                   	push   %ebp
    934a:	89 e5                	mov    %esp,%ebp
    934c:	83 ec 10             	sub    $0x10,%esp
    if (!mem)
    934f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    9353:	75 07                	jne    935c <memset+0x13>
        return NULL;
    9355:	b8 00 00 00 00       	mov    $0x0,%eax
    935a:	eb 21                	jmp    937d <memset+0x34>

    uint32_t* dest = mem;
    935c:	8b 45 08             	mov    0x8(%ebp),%eax
    935f:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (size) {
    9362:	eb 10                	jmp    9374 <memset+0x2b>
        *dest = (uint32_t)data;
    9364:	8b 55 0c             	mov    0xc(%ebp),%edx
    9367:	8b 45 fc             	mov    -0x4(%ebp),%eax
    936a:	89 10                	mov    %edx,(%eax)
        size--;
    936c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
        dest += 4;
    9370:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    while (size) {
    9374:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    9378:	75 ea                	jne    9364 <memset+0x1b>
    }

    return (void*)mem;
    937a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    937d:	c9                   	leave  
    937e:	c3                   	ret    

0000937f <_memcmp_>:

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    937f:	55                   	push   %ebp
    9380:	89 e5                	mov    %esp,%ebp
    9382:	83 ec 10             	sub    $0x10,%esp
    char* mem_1 = (char*)src_1;
    9385:	8b 45 08             	mov    0x8(%ebp),%eax
    9388:	89 45 fc             	mov    %eax,-0x4(%ebp)

    char* mem_2 = (char*)src_2;
    938b:	8b 45 0c             	mov    0xc(%ebp),%eax
    938e:	89 45 f8             	mov    %eax,-0x8(%ebp)

    uint32_t i = 0;
    9391:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (i < size && *mem_1 == *mem_2) {
    9398:	eb 0c                	jmp    93a6 <_memcmp_+0x27>
        i++;
    939a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        mem_1++;
    939e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
        mem_2++;
    93a2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (i < size && *mem_1 == *mem_2) {
    93a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    93a9:	3b 45 10             	cmp    0x10(%ebp),%eax
    93ac:	73 10                	jae    93be <_memcmp_+0x3f>
    93ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    93b1:	0f b6 10             	movzbl (%eax),%edx
    93b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    93b7:	0f b6 00             	movzbl (%eax),%eax
    93ba:	38 c2                	cmp    %al,%dl
    93bc:	74 dc                	je     939a <_memcmp_+0x1b>
    }

    return i == size;
    93be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    93c1:	3b 45 10             	cmp    0x10(%ebp),%eax
    93c4:	0f 94 c0             	sete   %al
    93c7:	0f b6 c0             	movzbl %al,%eax
    93ca:	c9                   	leave  
    93cb:	c3                   	ret    

000093cc <cclean>:

static int CURSOR_Y = 0;
static int CURSOR_X = 0;

void volatile cclean()
{
    93cc:	55                   	push   %ebp
    93cd:	89 e5                	mov    %esp,%ebp
    93cf:	83 ec 18             	sub    $0x18,%esp
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    93d2:	c7 45 f0 00 80 0b 00 	movl   $0xb8000,-0x10(%ebp)
    int i = 0;
    93d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i != 160 * 24) {
    93e0:	eb 1d                	jmp    93ff <cclean+0x33>
        screen[i] = ' ';
    93e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    93e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    93e8:	01 d0                	add    %edx,%eax
    93ea:	c6 00 20             	movb   $0x20,(%eax)
        screen[i + 1] = 0x0;
    93ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    93f0:	8d 50 01             	lea    0x1(%eax),%edx
    93f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    93f6:	01 d0                	add    %edx,%eax
    93f8:	c6 00 00             	movb   $0x0,(%eax)
        i += 2;
    93fb:	83 45 f4 02          	addl   $0x2,-0xc(%ebp)
    while (i != 160 * 24) {
    93ff:	81 7d f4 00 0f 00 00 	cmpl   $0xf00,-0xc(%ebp)
    9406:	75 da                	jne    93e2 <cclean+0x16>
    }
    cputchar(READY_COLOR , 'K');
    9408:	83 ec 08             	sub    $0x8,%esp
    940b:	6a 4b                	push   $0x4b
    940d:	6a 07                	push   $0x7
    940f:	e8 9d 00 00 00       	call   94b1 <cputchar>
    9414:	83 c4 10             	add    $0x10,%esp
    cputchar(READY_COLOR , '>');
    9417:	83 ec 08             	sub    $0x8,%esp
    941a:	6a 3e                	push   $0x3e
    941c:	6a 07                	push   $0x7
    941e:	e8 8e 00 00 00       	call   94b1 <cputchar>
    9423:	83 c4 10             	add    $0x10,%esp
}
    9426:	90                   	nop
    9427:	c9                   	leave  
    9428:	c3                   	ret    

00009429 <cscrollup>:

void volatile cscrollup()
{
    9429:	55                   	push   %ebp
    942a:	89 e5                	mov    %esp,%ebp
    942c:	81 ec b8 00 00 00    	sub    $0xb8,%esp
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    9432:	c7 45 f0 00 8f 0b 00 	movl   $0xb8f00,-0x10(%ebp)
    unsigned char b[160];
    int i;
    for (i = 0; i < 160; i++)
    9439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9440:	eb 1c                	jmp    945e <cscrollup+0x35>
        b[i] = v[i];
    9442:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9445:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9448:	01 d0                	add    %edx,%eax
    944a:	0f b6 00             	movzbl (%eax),%eax
    944d:	8d 8d 50 ff ff ff    	lea    -0xb0(%ebp),%ecx
    9453:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9456:	01 ca                	add    %ecx,%edx
    9458:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    945a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    945e:	81 7d f4 9f 00 00 00 	cmpl   $0x9f,-0xc(%ebp)
    9465:	7e db                	jle    9442 <cscrollup+0x19>

    cclean();
    9467:	e8 60 ff ff ff       	call   93cc <cclean>

    v = (unsigned char*)(VIDEO_MEM);
    946c:	c7 45 f0 00 80 0b 00 	movl   $0xb8000,-0x10(%ebp)

    for (i = 0; i < 160; i++)
    9473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    947a:	eb 1c                	jmp    9498 <cscrollup+0x6f>
        v[i] = b[i];
    947c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    947f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9482:	01 c2                	add    %eax,%edx
    9484:	8d 8d 50 ff ff ff    	lea    -0xb0(%ebp),%ecx
    948a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    948d:	01 c8                	add    %ecx,%eax
    948f:	0f b6 00             	movzbl (%eax),%eax
    9492:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    9494:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9498:	81 7d f4 9f 00 00 00 	cmpl   $0x9f,-0xc(%ebp)
    949f:	7e db                	jle    947c <cscrollup+0x53>

    CURSOR_Y++;
    94a1:	a1 00 00 01 00       	mov    0x10000,%eax
    94a6:	83 c0 01             	add    $0x1,%eax
    94a9:	a3 00 00 01 00       	mov    %eax,0x10000
}
    94ae:	90                   	nop
    94af:	c9                   	leave  
    94b0:	c3                   	ret    

000094b1 <cputchar>:

void volatile cputchar(unsigned char color, unsigned const char c)
{
    94b1:	55                   	push   %ebp
    94b2:	89 e5                	mov    %esp,%ebp
    94b4:	83 ec 18             	sub    $0x18,%esp
    94b7:	8b 55 08             	mov    0x8(%ebp),%edx
    94ba:	8b 45 0c             	mov    0xc(%ebp),%eax
    94bd:	88 55 ec             	mov    %dl,-0x14(%ebp)
    94c0:	88 45 e8             	mov    %al,-0x18(%ebp)
    unsigned char* v  ;
    
    if (c == '\n') {
    94c3:	80 7d e8 0a          	cmpb   $0xa,-0x18(%ebp)
    94c7:	75 1c                	jne    94e5 <cputchar+0x34>
        CURSOR_X = 0;
    94c9:	c7 05 04 00 01 00 00 	movl   $0x0,0x10004
    94d0:	00 00 00 
        CURSOR_Y++;
    94d3:	a1 00 00 01 00       	mov    0x10000,%eax
    94d8:	83 c0 01             	add    $0x1,%eax
    94db:	a3 00 00 01 00       	mov    %eax,0x10000
            *(v) = c;
            *(v + 1) = color;
            CURSOR_X++;
        }
    }
}
    94e0:	e9 e7 00 00 00       	jmp    95cc <cputchar+0x11b>
    else if(c == 0x0D) {
    94e5:	80 7d e8 0d          	cmpb   $0xd,-0x18(%ebp)
    94e9:	75 3a                	jne    9525 <cputchar+0x74>
        CURSOR_X--;
    94eb:	a1 04 00 01 00       	mov    0x10004,%eax
    94f0:	83 e8 01             	sub    $0x1,%eax
    94f3:	a3 04 00 01 00       	mov    %eax,0x10004
        v = (unsigned char*)(VIDEO_MEM + CURSOR_X * 2 + 160 * CURSOR_Y);
    94f8:	a1 04 00 01 00       	mov    0x10004,%eax
    94fd:	8d 88 00 c0 05 00    	lea    0x5c000(%eax),%ecx
    9503:	8b 15 00 00 01 00    	mov    0x10000,%edx
    9509:	89 d0                	mov    %edx,%eax
    950b:	c1 e0 02             	shl    $0x2,%eax
    950e:	01 d0                	add    %edx,%eax
    9510:	c1 e0 04             	shl    $0x4,%eax
    9513:	01 c8                	add    %ecx,%eax
    9515:	01 c0                	add    %eax,%eax
    9517:	89 45 fc             	mov    %eax,-0x4(%ebp)
        *v = ' ';
    951a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    951d:	c6 00 20             	movb   $0x20,(%eax)
}
    9520:	e9 a7 00 00 00       	jmp    95cc <cputchar+0x11b>
    else if (c == '\t')
    9525:	80 7d e8 09          	cmpb   $0x9,-0x18(%ebp)
    9529:	75 12                	jne    953d <cputchar+0x8c>
        CURSOR_X += 5;
    952b:	a1 04 00 01 00       	mov    0x10004,%eax
    9530:	83 c0 05             	add    $0x5,%eax
    9533:	a3 04 00 01 00       	mov    %eax,0x10004
}
    9538:	e9 8f 00 00 00       	jmp    95cc <cputchar+0x11b>
       v = (unsigned char*)(VIDEO_MEM + CURSOR_X * 2 + 160 * CURSOR_Y);
    953d:	a1 04 00 01 00       	mov    0x10004,%eax
    9542:	8d 88 00 c0 05 00    	lea    0x5c000(%eax),%ecx
    9548:	8b 15 00 00 01 00    	mov    0x10000,%edx
    954e:	89 d0                	mov    %edx,%eax
    9550:	c1 e0 02             	shl    $0x2,%eax
    9553:	01 d0                	add    %edx,%eax
    9555:	c1 e0 04             	shl    $0x4,%eax
    9558:	01 c8                	add    %ecx,%eax
    955a:	01 c0                	add    %eax,%eax
    955c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (c == '\n' || CURSOR_X == 80) {
    955f:	80 7d e8 0a          	cmpb   $0xa,-0x18(%ebp)
    9563:	74 0a                	je     956f <cputchar+0xbe>
    9565:	a1 04 00 01 00       	mov    0x10004,%eax
    956a:	83 f8 50             	cmp    $0x50,%eax
    956d:	75 3b                	jne    95aa <cputchar+0xf9>
            CURSOR_X = 0;
    956f:	c7 05 04 00 01 00 00 	movl   $0x0,0x10004
    9576:	00 00 00 
            CURSOR_Y++;
    9579:	a1 00 00 01 00       	mov    0x10000,%eax
    957e:	83 c0 01             	add    $0x1,%eax
    9581:	a3 00 00 01 00       	mov    %eax,0x10000
            *(v) = c;
    9586:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9589:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    958d:	88 10                	mov    %dl,(%eax)
            *(v + 1) = color;
    958f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9592:	8d 50 01             	lea    0x1(%eax),%edx
    9595:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    9599:	88 02                	mov    %al,(%edx)
            CURSOR_X++;
    959b:	a1 04 00 01 00       	mov    0x10004,%eax
    95a0:	83 c0 01             	add    $0x1,%eax
    95a3:	a3 04 00 01 00       	mov    %eax,0x10004
}
    95a8:	eb 22                	jmp    95cc <cputchar+0x11b>
            *(v) = c;
    95aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    95ad:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    95b1:	88 10                	mov    %dl,(%eax)
            *(v + 1) = color;
    95b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    95b6:	8d 50 01             	lea    0x1(%eax),%edx
    95b9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    95bd:	88 02                	mov    %al,(%edx)
            CURSOR_X++;
    95bf:	a1 04 00 01 00       	mov    0x10004,%eax
    95c4:	83 c0 01             	add    $0x1,%eax
    95c7:	a3 04 00 01 00       	mov    %eax,0x10004
}
    95cc:	90                   	nop
    95cd:	c9                   	leave  
    95ce:	c3                   	ret    

000095cf <move_cursor>:

void move_cursor(uint8_t x , uint8_t y)
{
    95cf:	55                   	push   %ebp
    95d0:	89 e5                	mov    %esp,%ebp
    95d2:	83 ec 18             	sub    $0x18,%esp
    95d5:	8b 55 08             	mov    0x8(%ebp),%edx
    95d8:	8b 45 0c             	mov    0xc(%ebp),%eax
    95db:	88 55 ec             	mov    %dl,-0x14(%ebp)
    95de:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t c_pos;

    c_pos = y * 80 + x;
    95e1:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    95e5:	89 d0                	mov    %edx,%eax
    95e7:	c1 e0 02             	shl    $0x2,%eax
    95ea:	01 d0                	add    %edx,%eax
    95ec:	c1 e0 04             	shl    $0x4,%eax
    95ef:	89 c2                	mov    %eax,%edx
    95f1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    95f5:	01 d0                	add    %edx,%eax
    95f7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

	outb(0x3d4, 0x0f);
    95fb:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9600:	b8 0f 00 00 00       	mov    $0xf,%eax
    9605:	ee                   	out    %al,(%dx)
	outb(0x3d5, (uint8_t) c_pos);
    9606:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    960a:	ba d5 03 00 00       	mov    $0x3d5,%edx
    960f:	ee                   	out    %al,(%dx)
	outb(0x3d4, 0x0e);
    9610:	ba d4 03 00 00       	mov    $0x3d4,%edx
    9615:	b8 0e 00 00 00       	mov    $0xe,%eax
    961a:	ee                   	out    %al,(%dx)
	outb(0x3d5, (uint8_t) (c_pos >> 8));
    961b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    961f:	66 c1 e8 08          	shr    $0x8,%ax
    9623:	ba d5 03 00 00       	mov    $0x3d5,%edx
    9628:	ee                   	out    %al,(%dx)
}
    9629:	90                   	nop
    962a:	c9                   	leave  
    962b:	c3                   	ret    

0000962c <show_cursor>:

void show_cursor(void)
{
    962c:	55                   	push   %ebp
    962d:	89 e5                	mov    %esp,%ebp
	move_cursor(CURSOR_X, CURSOR_Y);
    962f:	a1 00 00 01 00       	mov    0x10000,%eax
    9634:	0f b6 d0             	movzbl %al,%edx
    9637:	a1 04 00 01 00       	mov    0x10004,%eax
    963c:	0f b6 c0             	movzbl %al,%eax
    963f:	52                   	push   %edx
    9640:	50                   	push   %eax
    9641:	e8 89 ff ff ff       	call   95cf <move_cursor>
    9646:	83 c4 08             	add    $0x8,%esp
    9649:	90                   	nop
    964a:	c9                   	leave  
    964b:	c3                   	ret    

0000964c <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    964c:	55                   	push   %ebp
    964d:	89 e5                	mov    %esp,%ebp
    964f:	90                   	nop
    9650:	5d                   	pop    %ebp
    9651:	c3                   	ret    

00009652 <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    9652:	55                   	push   %ebp
    9653:	89 e5                	mov    %esp,%ebp
    9655:	90                   	nop
    9656:	5d                   	pop    %ebp
    9657:	c3                   	ret    

00009658 <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    9658:	55                   	push   %ebp
    9659:	89 e5                	mov    %esp,%ebp
    965b:	83 ec 08             	sub    $0x8,%esp
    965e:	8b 55 10             	mov    0x10(%ebp),%edx
    9661:	8b 45 14             	mov    0x14(%ebp),%eax
    9664:	88 55 fc             	mov    %dl,-0x4(%ebp)
    9667:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15 = (limite & 0xFFFF);
    966a:	8b 45 0c             	mov    0xc(%ebp),%eax
    966d:	89 c2                	mov    %eax,%edx
    966f:	8b 45 18             	mov    0x18(%ebp),%eax
    9672:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    9675:	8b 45 0c             	mov    0xc(%ebp),%eax
    9678:	c1 e8 10             	shr    $0x10,%eax
    967b:	83 e0 0f             	and    $0xf,%eax
    967e:	8b 55 18             	mov    0x18(%ebp),%edx
    9681:	83 e0 0f             	and    $0xf,%eax
    9684:	89 c1                	mov    %eax,%ecx
    9686:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    968a:	83 e0 f0             	and    $0xfffffff0,%eax
    968d:	09 c8                	or     %ecx,%eax
    968f:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15 = (base & 0xFFFF);
    9692:	8b 45 08             	mov    0x8(%ebp),%eax
    9695:	89 c2                	mov    %eax,%edx
    9697:	8b 45 18             	mov    0x18(%ebp),%eax
    969a:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    969e:	8b 45 08             	mov    0x8(%ebp),%eax
    96a1:	c1 e8 10             	shr    $0x10,%eax
    96a4:	89 c2                	mov    %eax,%edx
    96a6:	8b 45 18             	mov    0x18(%ebp),%eax
    96a9:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    96ac:	8b 45 08             	mov    0x8(%ebp),%eax
    96af:	c1 e8 18             	shr    $0x18,%eax
    96b2:	89 c2                	mov    %eax,%edx
    96b4:	8b 45 18             	mov    0x18(%ebp),%eax
    96b7:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags = flags;
    96ba:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    96be:	83 e0 0f             	and    $0xf,%eax
    96c1:	89 c2                	mov    %eax,%edx
    96c3:	8b 45 18             	mov    0x18(%ebp),%eax
    96c6:	89 d1                	mov    %edx,%ecx
    96c8:	c1 e1 04             	shl    $0x4,%ecx
    96cb:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    96cf:	83 e2 0f             	and    $0xf,%edx
    96d2:	09 ca                	or     %ecx,%edx
    96d4:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    96d7:	8b 45 18             	mov    0x18(%ebp),%eax
    96da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    96de:	88 50 05             	mov    %dl,0x5(%eax)
}
    96e1:	90                   	nop
    96e2:	c9                   	leave  
    96e3:	c3                   	ret    

000096e4 <init_gdt>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt(void)
{
    96e4:	55                   	push   %ebp
    96e5:	89 e5                	mov    %esp,%ebp
    96e7:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    96ea:	a1 08 00 01 00       	mov    0x10008,%eax
    96ef:	50                   	push   %eax
    96f0:	6a 00                	push   $0x0
    96f2:	6a 00                	push   $0x0
    96f4:	6a 00                	push   $0x0
    96f6:	6a 00                	push   $0x0
    96f8:	e8 5b ff ff ff       	call   9658 <init_gdt_entry>
    96fd:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    9700:	a1 08 00 01 00       	mov    0x10008,%eax
    9705:	83 c0 08             	add    $0x8,%eax
    9708:	50                   	push   %eax
    9709:	6a 04                	push   $0x4
    970b:	68 9a 00 00 00       	push   $0x9a
    9710:	68 ff ff 0f 00       	push   $0xfffff
    9715:	6a 00                	push   $0x0
    9717:	e8 3c ff ff ff       	call   9658 <init_gdt_entry>
    971c:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    971f:	a1 08 00 01 00       	mov    0x10008,%eax
    9724:	83 c0 10             	add    $0x10,%eax
    9727:	50                   	push   %eax
    9728:	6a 04                	push   $0x4
    972a:	68 92 00 00 00       	push   $0x92
    972f:	68 ff ff 0f 00       	push   $0xfffff
    9734:	6a 00                	push   $0x0
    9736:	e8 1d ff ff ff       	call   9658 <init_gdt_entry>
    973b:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    973e:	a1 08 00 01 00       	mov    0x10008,%eax
    9743:	83 c0 18             	add    $0x18,%eax
    9746:	50                   	push   %eax
    9747:	6a 04                	push   $0x4
    9749:	68 96 00 00 00       	push   $0x96
    974e:	68 ff ff 0f 00       	push   $0xfffff
    9753:	6a 00                	push   $0x0
    9755:	e8 fe fe ff ff       	call   9658 <init_gdt_entry>
    975a:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Segment de tâches
    init_gdt_entry(0, 0xFFFFFF, TSS_PRIVILEGE_0,
    975d:	a1 08 00 01 00       	mov    0x10008,%eax
    9762:	83 c0 20             	add    $0x20,%eax
    9765:	50                   	push   %eax
    9766:	6a 04                	push   $0x4
    9768:	68 89 00 00 00       	push   $0x89
    976d:	68 ff ff ff 00       	push   $0xffffff
    9772:	6a 00                	push   $0x0
    9774:	e8 df fe ff ff       	call   9658 <init_gdt_entry>
    9779:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[4]);

    // Chargement de la GDT
    load_gdt();
    977c:	e8 e5 18 00 00       	call   b066 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    9781:	66 b8 10 00          	mov    $0x10,%ax
    9785:	8e d8                	mov    %eax,%ds
    9787:	8e c0                	mov    %eax,%es
    9789:	8e e0                	mov    %eax,%fs
    978b:	8e e8                	mov    %eax,%gs
    978d:	66 b8 18 00          	mov    $0x18,%ax
    9791:	8e d0                	mov    %eax,%ss
    9793:	ea 9a 97 00 00 08 00 	ljmp   $0x8,$0x979a

0000979a <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    979a:	90                   	nop
    979b:	c9                   	leave  
    979c:	c3                   	ret    

0000979d <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    979d:	55                   	push   %ebp
    979e:	89 e5                	mov    %esp,%ebp
    97a0:	83 ec 18             	sub    $0x18,%esp
    97a3:	8b 45 08             	mov    0x8(%ebp),%eax
    97a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    97a9:	8b 55 18             	mov    0x18(%ebp),%edx
    97ac:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    97b0:	89 c8                	mov    %ecx,%eax
    97b2:	88 45 f8             	mov    %al,-0x8(%ebp)
    97b5:	8b 45 10             	mov    0x10(%ebp),%eax
    97b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    97bb:	8b 45 14             	mov    0x14(%ebp),%eax
    97be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    97c1:	89 d0                	mov    %edx,%eax
    97c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    97c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    97cb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    97cf:	66 89 14 c5 22 00 01 	mov    %dx,0x10022(,%eax,8)
    97d6:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    97d7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    97db:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    97df:	88 14 c5 25 00 01 00 	mov    %dl,0x10025(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    97e6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    97ea:	c6 04 c5 24 00 01 00 	movb   $0x0,0x10024(,%eax,8)
    97f1:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    97f2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    97f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
    97f9:	66 89 14 c5 20 00 01 	mov    %dx,0x10020(,%eax,8)
    9800:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    9801:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9804:	8b 55 f4             	mov    -0xc(%ebp),%edx
    9807:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    980b:	c1 ea 10             	shr    $0x10,%edx
    980e:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    9812:	66 89 04 cd 26 00 01 	mov    %ax,0x10026(,%ecx,8)
    9819:	00 
}
    981a:	90                   	nop
    981b:	c9                   	leave  
    981c:	c3                   	ret    

0000981d <init_idt>:

void init_idt()
{
    981d:	55                   	push   %ebp
    981e:	89 e5                	mov    %esp,%ebp
    9820:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    9823:	83 ec 0c             	sub    $0xc,%esp
    9826:	68 ad da 00 00       	push   $0xdaad
    982b:	e8 8b 0d 00 00       	call   a5bb <Init_PIT>
    9830:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    9833:	83 ec 08             	sub    $0x8,%esp
    9836:	6a 28                	push   $0x28
    9838:	6a 20                	push   $0x20
    983a:	e8 94 0a 00 00       	call   a2d3 <PIC_remap>
    983f:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    9842:	b8 80 b1 00 00       	mov    $0xb180,%eax
    9847:	ba 00 00 00 00       	mov    $0x0,%edx
    984c:	83 ec 0c             	sub    $0xc,%esp
    984f:	6a 20                	push   $0x20
    9851:	52                   	push   %edx
    9852:	50                   	push   %eax
    9853:	68 8e 00 00 00       	push   $0x8e
    9858:	6a 08                	push   $0x8
    985a:	e8 3e ff ff ff       	call   979d <set_idt>
    985f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    9862:	b8 d0 b0 00 00       	mov    $0xb0d0,%eax
    9867:	ba 00 00 00 00       	mov    $0x0,%edx
    986c:	83 ec 0c             	sub    $0xc,%esp
    986f:	6a 21                	push   $0x21
    9871:	52                   	push   %edx
    9872:	50                   	push   %eax
    9873:	68 8e 00 00 00       	push   $0x8e
    9878:	6a 08                	push   $0x8
    987a:	e8 1e ff ff ff       	call   979d <set_idt>
    987f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    9882:	b8 d8 b0 00 00       	mov    $0xb0d8,%eax
    9887:	ba 00 00 00 00       	mov    $0x0,%edx
    988c:	83 ec 0c             	sub    $0xc,%esp
    988f:	6a 22                	push   $0x22
    9891:	52                   	push   %edx
    9892:	50                   	push   %eax
    9893:	68 8e 00 00 00       	push   $0x8e
    9898:	6a 08                	push   $0x8
    989a:	e8 fe fe ff ff       	call   979d <set_idt>
    989f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    98a2:	b8 e0 b0 00 00       	mov    $0xb0e0,%eax
    98a7:	ba 00 00 00 00       	mov    $0x0,%edx
    98ac:	83 ec 0c             	sub    $0xc,%esp
    98af:	6a 23                	push   $0x23
    98b1:	52                   	push   %edx
    98b2:	50                   	push   %eax
    98b3:	68 8e 00 00 00       	push   $0x8e
    98b8:	6a 08                	push   $0x8
    98ba:	e8 de fe ff ff       	call   979d <set_idt>
    98bf:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    98c2:	b8 e8 b0 00 00       	mov    $0xb0e8,%eax
    98c7:	ba 00 00 00 00       	mov    $0x0,%edx
    98cc:	83 ec 0c             	sub    $0xc,%esp
    98cf:	6a 24                	push   $0x24
    98d1:	52                   	push   %edx
    98d2:	50                   	push   %eax
    98d3:	68 8e 00 00 00       	push   $0x8e
    98d8:	6a 08                	push   $0x8
    98da:	e8 be fe ff ff       	call   979d <set_idt>
    98df:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    98e2:	b8 f0 b0 00 00       	mov    $0xb0f0,%eax
    98e7:	ba 00 00 00 00       	mov    $0x0,%edx
    98ec:	83 ec 0c             	sub    $0xc,%esp
    98ef:	6a 25                	push   $0x25
    98f1:	52                   	push   %edx
    98f2:	50                   	push   %eax
    98f3:	68 8e 00 00 00       	push   $0x8e
    98f8:	6a 08                	push   $0x8
    98fa:	e8 9e fe ff ff       	call   979d <set_idt>
    98ff:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    9902:	b8 f8 b0 00 00       	mov    $0xb0f8,%eax
    9907:	ba 00 00 00 00       	mov    $0x0,%edx
    990c:	83 ec 0c             	sub    $0xc,%esp
    990f:	6a 26                	push   $0x26
    9911:	52                   	push   %edx
    9912:	50                   	push   %eax
    9913:	68 8e 00 00 00       	push   $0x8e
    9918:	6a 08                	push   $0x8
    991a:	e8 7e fe ff ff       	call   979d <set_idt>
    991f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    9922:	b8 00 b1 00 00       	mov    $0xb100,%eax
    9927:	ba 00 00 00 00       	mov    $0x0,%edx
    992c:	83 ec 0c             	sub    $0xc,%esp
    992f:	6a 27                	push   $0x27
    9931:	52                   	push   %edx
    9932:	50                   	push   %eax
    9933:	68 8e 00 00 00       	push   $0x8e
    9938:	6a 08                	push   $0x8
    993a:	e8 5e fe ff ff       	call   979d <set_idt>
    993f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    9942:	b8 08 b1 00 00       	mov    $0xb108,%eax
    9947:	ba 00 00 00 00       	mov    $0x0,%edx
    994c:	83 ec 0c             	sub    $0xc,%esp
    994f:	6a 28                	push   $0x28
    9951:	52                   	push   %edx
    9952:	50                   	push   %eax
    9953:	68 8e 00 00 00       	push   $0x8e
    9958:	6a 08                	push   $0x8
    995a:	e8 3e fe ff ff       	call   979d <set_idt>
    995f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    9962:	b8 10 b1 00 00       	mov    $0xb110,%eax
    9967:	ba 00 00 00 00       	mov    $0x0,%edx
    996c:	83 ec 0c             	sub    $0xc,%esp
    996f:	6a 29                	push   $0x29
    9971:	52                   	push   %edx
    9972:	50                   	push   %eax
    9973:	68 8e 00 00 00       	push   $0x8e
    9978:	6a 08                	push   $0x8
    997a:	e8 1e fe ff ff       	call   979d <set_idt>
    997f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    9982:	b8 18 b1 00 00       	mov    $0xb118,%eax
    9987:	ba 00 00 00 00       	mov    $0x0,%edx
    998c:	83 ec 0c             	sub    $0xc,%esp
    998f:	6a 2a                	push   $0x2a
    9991:	52                   	push   %edx
    9992:	50                   	push   %eax
    9993:	68 8e 00 00 00       	push   $0x8e
    9998:	6a 08                	push   $0x8
    999a:	e8 fe fd ff ff       	call   979d <set_idt>
    999f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    99a2:	b8 20 b1 00 00       	mov    $0xb120,%eax
    99a7:	ba 00 00 00 00       	mov    $0x0,%edx
    99ac:	83 ec 0c             	sub    $0xc,%esp
    99af:	6a 2b                	push   $0x2b
    99b1:	52                   	push   %edx
    99b2:	50                   	push   %eax
    99b3:	68 8e 00 00 00       	push   $0x8e
    99b8:	6a 08                	push   $0x8
    99ba:	e8 de fd ff ff       	call   979d <set_idt>
    99bf:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    99c2:	b8 28 b1 00 00       	mov    $0xb128,%eax
    99c7:	ba 00 00 00 00       	mov    $0x0,%edx
    99cc:	83 ec 0c             	sub    $0xc,%esp
    99cf:	6a 2c                	push   $0x2c
    99d1:	52                   	push   %edx
    99d2:	50                   	push   %eax
    99d3:	68 8e 00 00 00       	push   $0x8e
    99d8:	6a 08                	push   $0x8
    99da:	e8 be fd ff ff       	call   979d <set_idt>
    99df:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    99e2:	b8 30 b1 00 00       	mov    $0xb130,%eax
    99e7:	ba 00 00 00 00       	mov    $0x0,%edx
    99ec:	83 ec 0c             	sub    $0xc,%esp
    99ef:	6a 2d                	push   $0x2d
    99f1:	52                   	push   %edx
    99f2:	50                   	push   %eax
    99f3:	68 8e 00 00 00       	push   $0x8e
    99f8:	6a 08                	push   $0x8
    99fa:	e8 9e fd ff ff       	call   979d <set_idt>
    99ff:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    9a02:	b8 38 b1 00 00       	mov    $0xb138,%eax
    9a07:	ba 00 00 00 00       	mov    $0x0,%edx
    9a0c:	83 ec 0c             	sub    $0xc,%esp
    9a0f:	6a 2e                	push   $0x2e
    9a11:	52                   	push   %edx
    9a12:	50                   	push   %eax
    9a13:	68 8e 00 00 00       	push   $0x8e
    9a18:	6a 08                	push   $0x8
    9a1a:	e8 7e fd ff ff       	call   979d <set_idt>
    9a1f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    9a22:	b8 40 b1 00 00       	mov    $0xb140,%eax
    9a27:	ba 00 00 00 00       	mov    $0x0,%edx
    9a2c:	83 ec 0c             	sub    $0xc,%esp
    9a2f:	6a 2f                	push   $0x2f
    9a31:	52                   	push   %edx
    9a32:	50                   	push   %eax
    9a33:	68 8e 00 00 00       	push   $0x8e
    9a38:	6a 08                	push   $0x8
    9a3a:	e8 5e fd ff ff       	call   979d <set_idt>
    9a3f:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    9a42:	b8 40 b0 00 00       	mov    $0xb040,%eax
    9a47:	ba 00 00 00 00       	mov    $0x0,%edx
    9a4c:	83 ec 0c             	sub    $0xc,%esp
    9a4f:	6a 08                	push   $0x8
    9a51:	52                   	push   %edx
    9a52:	50                   	push   %eax
    9a53:	68 8e 00 00 00       	push   $0x8e
    9a58:	6a 08                	push   $0x8
    9a5a:	e8 3e fd ff ff       	call   979d <set_idt>
    9a5f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    9a62:	b8 40 b0 00 00       	mov    $0xb040,%eax
    9a67:	ba 00 00 00 00       	mov    $0x0,%edx
    9a6c:	83 ec 0c             	sub    $0xc,%esp
    9a6f:	6a 0a                	push   $0xa
    9a71:	52                   	push   %edx
    9a72:	50                   	push   %eax
    9a73:	68 8e 00 00 00       	push   $0x8e
    9a78:	6a 08                	push   $0x8
    9a7a:	e8 1e fd ff ff       	call   979d <set_idt>
    9a7f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    9a82:	b8 40 b0 00 00       	mov    $0xb040,%eax
    9a87:	ba 00 00 00 00       	mov    $0x0,%edx
    9a8c:	83 ec 0c             	sub    $0xc,%esp
    9a8f:	6a 0b                	push   $0xb
    9a91:	52                   	push   %edx
    9a92:	50                   	push   %eax
    9a93:	68 8e 00 00 00       	push   $0x8e
    9a98:	6a 08                	push   $0x8
    9a9a:	e8 fe fc ff ff       	call   979d <set_idt>
    9a9f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9aa2:	b8 40 b0 00 00       	mov    $0xb040,%eax
    9aa7:	ba 00 00 00 00       	mov    $0x0,%edx
    9aac:	83 ec 0c             	sub    $0xc,%esp
    9aaf:	6a 0c                	push   $0xc
    9ab1:	52                   	push   %edx
    9ab2:	50                   	push   %eax
    9ab3:	68 8e 00 00 00       	push   $0x8e
    9ab8:	6a 08                	push   $0x8
    9aba:	e8 de fc ff ff       	call   979d <set_idt>
    9abf:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9ac2:	b8 40 b0 00 00       	mov    $0xb040,%eax
    9ac7:	ba 00 00 00 00       	mov    $0x0,%edx
    9acc:	83 ec 0c             	sub    $0xc,%esp
    9acf:	6a 0d                	push   $0xd
    9ad1:	52                   	push   %edx
    9ad2:	50                   	push   %eax
    9ad3:	68 8e 00 00 00       	push   $0x8e
    9ad8:	6a 08                	push   $0x8
    9ada:	e8 be fc ff ff       	call   979d <set_idt>
    9adf:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    9ae2:	b8 a2 a2 00 00       	mov    $0xa2a2,%eax
    9ae7:	ba 00 00 00 00       	mov    $0x0,%edx
    9aec:	83 ec 0c             	sub    $0xc,%esp
    9aef:	6a 0e                	push   $0xe
    9af1:	52                   	push   %edx
    9af2:	50                   	push   %eax
    9af3:	68 8e 00 00 00       	push   $0x8e
    9af8:	6a 08                	push   $0x8
    9afa:	e8 9e fc ff ff       	call   979d <set_idt>
    9aff:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    9b02:	b8 40 b0 00 00       	mov    $0xb040,%eax
    9b07:	ba 00 00 00 00       	mov    $0x0,%edx
    9b0c:	83 ec 0c             	sub    $0xc,%esp
    9b0f:	6a 11                	push   $0x11
    9b11:	52                   	push   %edx
    9b12:	50                   	push   %eax
    9b13:	68 8e 00 00 00       	push   $0x8e
    9b18:	6a 08                	push   $0x8
    9b1a:	e8 7e fc ff ff       	call   979d <set_idt>
    9b1f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    9b22:	b8 40 b0 00 00       	mov    $0xb040,%eax
    9b27:	ba 00 00 00 00       	mov    $0x0,%edx
    9b2c:	83 ec 0c             	sub    $0xc,%esp
    9b2f:	6a 1e                	push   $0x1e
    9b31:	52                   	push   %edx
    9b32:	50                   	push   %eax
    9b33:	68 8e 00 00 00       	push   $0x8e
    9b38:	6a 08                	push   $0x8
    9b3a:	e8 5e fc ff ff       	call   979d <set_idt>
    9b3f:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9b42:	b8 52 96 00 00       	mov    $0x9652,%eax
    9b47:	ba 00 00 00 00       	mov    $0x0,%edx
    9b4c:	83 ec 0c             	sub    $0xc,%esp
    9b4f:	6a 00                	push   $0x0
    9b51:	52                   	push   %edx
    9b52:	50                   	push   %eax
    9b53:	68 8e 00 00 00       	push   $0x8e
    9b58:	6a 08                	push   $0x8
    9b5a:	e8 3e fc ff ff       	call   979d <set_idt>
    9b5f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9b62:	b8 52 96 00 00       	mov    $0x9652,%eax
    9b67:	ba 00 00 00 00       	mov    $0x0,%edx
    9b6c:	83 ec 0c             	sub    $0xc,%esp
    9b6f:	6a 01                	push   $0x1
    9b71:	52                   	push   %edx
    9b72:	50                   	push   %eax
    9b73:	68 8e 00 00 00       	push   $0x8e
    9b78:	6a 08                	push   $0x8
    9b7a:	e8 1e fc ff ff       	call   979d <set_idt>
    9b7f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9b82:	b8 52 96 00 00       	mov    $0x9652,%eax
    9b87:	ba 00 00 00 00       	mov    $0x0,%edx
    9b8c:	83 ec 0c             	sub    $0xc,%esp
    9b8f:	6a 02                	push   $0x2
    9b91:	52                   	push   %edx
    9b92:	50                   	push   %eax
    9b93:	68 8e 00 00 00       	push   $0x8e
    9b98:	6a 08                	push   $0x8
    9b9a:	e8 fe fb ff ff       	call   979d <set_idt>
    9b9f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9ba2:	b8 52 96 00 00       	mov    $0x9652,%eax
    9ba7:	ba 00 00 00 00       	mov    $0x0,%edx
    9bac:	83 ec 0c             	sub    $0xc,%esp
    9baf:	6a 03                	push   $0x3
    9bb1:	52                   	push   %edx
    9bb2:	50                   	push   %eax
    9bb3:	68 8e 00 00 00       	push   $0x8e
    9bb8:	6a 08                	push   $0x8
    9bba:	e8 de fb ff ff       	call   979d <set_idt>
    9bbf:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9bc2:	b8 52 96 00 00       	mov    $0x9652,%eax
    9bc7:	ba 00 00 00 00       	mov    $0x0,%edx
    9bcc:	83 ec 0c             	sub    $0xc,%esp
    9bcf:	6a 04                	push   $0x4
    9bd1:	52                   	push   %edx
    9bd2:	50                   	push   %eax
    9bd3:	68 8e 00 00 00       	push   $0x8e
    9bd8:	6a 08                	push   $0x8
    9bda:	e8 be fb ff ff       	call   979d <set_idt>
    9bdf:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    9be2:	b8 52 96 00 00       	mov    $0x9652,%eax
    9be7:	ba 00 00 00 00       	mov    $0x0,%edx
    9bec:	83 ec 0c             	sub    $0xc,%esp
    9bef:	6a 05                	push   $0x5
    9bf1:	52                   	push   %edx
    9bf2:	50                   	push   %eax
    9bf3:	68 8e 00 00 00       	push   $0x8e
    9bf8:	6a 08                	push   $0x8
    9bfa:	e8 9e fb ff ff       	call   979d <set_idt>
    9bff:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    9c02:	b8 52 96 00 00       	mov    $0x9652,%eax
    9c07:	ba 00 00 00 00       	mov    $0x0,%edx
    9c0c:	83 ec 0c             	sub    $0xc,%esp
    9c0f:	6a 06                	push   $0x6
    9c11:	52                   	push   %edx
    9c12:	50                   	push   %eax
    9c13:	68 8e 00 00 00       	push   $0x8e
    9c18:	6a 08                	push   $0x8
    9c1a:	e8 7e fb ff ff       	call   979d <set_idt>
    9c1f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    9c22:	b8 52 96 00 00       	mov    $0x9652,%eax
    9c27:	ba 00 00 00 00       	mov    $0x0,%edx
    9c2c:	83 ec 0c             	sub    $0xc,%esp
    9c2f:	6a 07                	push   $0x7
    9c31:	52                   	push   %edx
    9c32:	50                   	push   %eax
    9c33:	68 8e 00 00 00       	push   $0x8e
    9c38:	6a 08                	push   $0x8
    9c3a:	e8 5e fb ff ff       	call   979d <set_idt>
    9c3f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9c42:	b8 52 96 00 00       	mov    $0x9652,%eax
    9c47:	ba 00 00 00 00       	mov    $0x0,%edx
    9c4c:	83 ec 0c             	sub    $0xc,%esp
    9c4f:	6a 09                	push   $0x9
    9c51:	52                   	push   %edx
    9c52:	50                   	push   %eax
    9c53:	68 8e 00 00 00       	push   $0x8e
    9c58:	6a 08                	push   $0x8
    9c5a:	e8 3e fb ff ff       	call   979d <set_idt>
    9c5f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9c62:	b8 52 96 00 00       	mov    $0x9652,%eax
    9c67:	ba 00 00 00 00       	mov    $0x0,%edx
    9c6c:	83 ec 0c             	sub    $0xc,%esp
    9c6f:	6a 10                	push   $0x10
    9c71:	52                   	push   %edx
    9c72:	50                   	push   %eax
    9c73:	68 8e 00 00 00       	push   $0x8e
    9c78:	6a 08                	push   $0x8
    9c7a:	e8 1e fb ff ff       	call   979d <set_idt>
    9c7f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9c82:	b8 52 96 00 00       	mov    $0x9652,%eax
    9c87:	ba 00 00 00 00       	mov    $0x0,%edx
    9c8c:	83 ec 0c             	sub    $0xc,%esp
    9c8f:	6a 12                	push   $0x12
    9c91:	52                   	push   %edx
    9c92:	50                   	push   %eax
    9c93:	68 8e 00 00 00       	push   $0x8e
    9c98:	6a 08                	push   $0x8
    9c9a:	e8 fe fa ff ff       	call   979d <set_idt>
    9c9f:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9ca2:	b8 52 96 00 00       	mov    $0x9652,%eax
    9ca7:	ba 00 00 00 00       	mov    $0x0,%edx
    9cac:	83 ec 0c             	sub    $0xc,%esp
    9caf:	6a 13                	push   $0x13
    9cb1:	52                   	push   %edx
    9cb2:	50                   	push   %eax
    9cb3:	68 8e 00 00 00       	push   $0x8e
    9cb8:	6a 08                	push   $0x8
    9cba:	e8 de fa ff ff       	call   979d <set_idt>
    9cbf:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9cc2:	b8 52 96 00 00       	mov    $0x9652,%eax
    9cc7:	ba 00 00 00 00       	mov    $0x0,%edx
    9ccc:	83 ec 0c             	sub    $0xc,%esp
    9ccf:	6a 14                	push   $0x14
    9cd1:	52                   	push   %edx
    9cd2:	50                   	push   %eax
    9cd3:	68 8e 00 00 00       	push   $0x8e
    9cd8:	6a 08                	push   $0x8
    9cda:	e8 be fa ff ff       	call   979d <set_idt>
    9cdf:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    9ce2:	e8 b8 13 00 00       	call   b09f <load_idt>
}
    9ce7:	90                   	nop
    9ce8:	c9                   	leave  
    9ce9:	c3                   	ret    

00009cea <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    9cea:	55                   	push   %ebp
    9ceb:	89 e5                	mov    %esp,%ebp
    9ced:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    9cf0:	e8 fa 01 00 00       	call   9eef <keyboard_irq>
    PIC_sendEOI(1);
    9cf5:	83 ec 0c             	sub    $0xc,%esp
    9cf8:	6a 01                	push   $0x1
    9cfa:	e8 a9 05 00 00       	call   a2a8 <PIC_sendEOI>
    9cff:	83 c4 10             	add    $0x10,%esp
}
    9d02:	90                   	nop
    9d03:	c9                   	leave  
    9d04:	c3                   	ret    

00009d05 <irq2_handler>:

void irq2_handler(void)
{
    9d05:	55                   	push   %ebp
    9d06:	89 e5                	mov    %esp,%ebp
    9d08:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    9d0b:	83 ec 0c             	sub    $0xc,%esp
    9d0e:	6a 02                	push   $0x2
    9d10:	e8 9e 07 00 00       	call   a4b3 <spurious_IRQ>
    9d15:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(2);
    9d18:	83 ec 0c             	sub    $0xc,%esp
    9d1b:	6a 02                	push   $0x2
    9d1d:	e8 86 05 00 00       	call   a2a8 <PIC_sendEOI>
    9d22:	83 c4 10             	add    $0x10,%esp
}
    9d25:	90                   	nop
    9d26:	c9                   	leave  
    9d27:	c3                   	ret    

00009d28 <irq3_handler>:

void irq3_handler(void)
{
    9d28:	55                   	push   %ebp
    9d29:	89 e5                	mov    %esp,%ebp
    9d2b:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    9d2e:	83 ec 0c             	sub    $0xc,%esp
    9d31:	6a 03                	push   $0x3
    9d33:	e8 7b 07 00 00       	call   a4b3 <spurious_IRQ>
    9d38:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(3);
    9d3b:	83 ec 0c             	sub    $0xc,%esp
    9d3e:	6a 03                	push   $0x3
    9d40:	e8 63 05 00 00       	call   a2a8 <PIC_sendEOI>
    9d45:	83 c4 10             	add    $0x10,%esp
}
    9d48:	90                   	nop
    9d49:	c9                   	leave  
    9d4a:	c3                   	ret    

00009d4b <irq4_handler>:

void irq4_handler(void)
{
    9d4b:	55                   	push   %ebp
    9d4c:	89 e5                	mov    %esp,%ebp
    9d4e:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    9d51:	83 ec 0c             	sub    $0xc,%esp
    9d54:	6a 04                	push   $0x4
    9d56:	e8 58 07 00 00       	call   a4b3 <spurious_IRQ>
    9d5b:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(4);
    9d5e:	83 ec 0c             	sub    $0xc,%esp
    9d61:	6a 04                	push   $0x4
    9d63:	e8 40 05 00 00       	call   a2a8 <PIC_sendEOI>
    9d68:	83 c4 10             	add    $0x10,%esp
}
    9d6b:	90                   	nop
    9d6c:	c9                   	leave  
    9d6d:	c3                   	ret    

00009d6e <irq5_handler>:

void irq5_handler(void)
{
    9d6e:	55                   	push   %ebp
    9d6f:	89 e5                	mov    %esp,%ebp
    9d71:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9d74:	83 ec 0c             	sub    $0xc,%esp
    9d77:	6a 05                	push   $0x5
    9d79:	e8 35 07 00 00       	call   a4b3 <spurious_IRQ>
    9d7e:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(5);
    9d81:	83 ec 0c             	sub    $0xc,%esp
    9d84:	6a 05                	push   $0x5
    9d86:	e8 1d 05 00 00       	call   a2a8 <PIC_sendEOI>
    9d8b:	83 c4 10             	add    $0x10,%esp
}
    9d8e:	90                   	nop
    9d8f:	c9                   	leave  
    9d90:	c3                   	ret    

00009d91 <irq6_handler>:

void irq6_handler(void)
{
    9d91:	55                   	push   %ebp
    9d92:	89 e5                	mov    %esp,%ebp
    9d94:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9d97:	83 ec 0c             	sub    $0xc,%esp
    9d9a:	6a 06                	push   $0x6
    9d9c:	e8 12 07 00 00       	call   a4b3 <spurious_IRQ>
    9da1:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(6);
    9da4:	83 ec 0c             	sub    $0xc,%esp
    9da7:	6a 06                	push   $0x6
    9da9:	e8 fa 04 00 00       	call   a2a8 <PIC_sendEOI>
    9dae:	83 c4 10             	add    $0x10,%esp
}
    9db1:	90                   	nop
    9db2:	c9                   	leave  
    9db3:	c3                   	ret    

00009db4 <irq7_handler>:

void irq7_handler(void)
{
    9db4:	55                   	push   %ebp
    9db5:	89 e5                	mov    %esp,%ebp
    9db7:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9dba:	83 ec 0c             	sub    $0xc,%esp
    9dbd:	6a 07                	push   $0x7
    9dbf:	e8 ef 06 00 00       	call   a4b3 <spurious_IRQ>
    9dc4:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(7);
    9dc7:	83 ec 0c             	sub    $0xc,%esp
    9dca:	6a 07                	push   $0x7
    9dcc:	e8 d7 04 00 00       	call   a2a8 <PIC_sendEOI>
    9dd1:	83 c4 10             	add    $0x10,%esp
}
    9dd4:	90                   	nop
    9dd5:	c9                   	leave  
    9dd6:	c3                   	ret    

00009dd7 <irq8_handler>:

void irq8_handler(void)
{
    9dd7:	55                   	push   %ebp
    9dd8:	89 e5                	mov    %esp,%ebp
    9dda:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    9ddd:	83 ec 0c             	sub    $0xc,%esp
    9de0:	6a 08                	push   $0x8
    9de2:	e8 cc 06 00 00       	call   a4b3 <spurious_IRQ>
    9de7:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(8);
    9dea:	83 ec 0c             	sub    $0xc,%esp
    9ded:	6a 08                	push   $0x8
    9def:	e8 b4 04 00 00       	call   a2a8 <PIC_sendEOI>
    9df4:	83 c4 10             	add    $0x10,%esp
}
    9df7:	90                   	nop
    9df8:	c9                   	leave  
    9df9:	c3                   	ret    

00009dfa <irq9_handler>:

void irq9_handler(void)
{
    9dfa:	55                   	push   %ebp
    9dfb:	89 e5                	mov    %esp,%ebp
    9dfd:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    9e00:	83 ec 0c             	sub    $0xc,%esp
    9e03:	6a 09                	push   $0x9
    9e05:	e8 a9 06 00 00       	call   a4b3 <spurious_IRQ>
    9e0a:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(9);
    9e0d:	83 ec 0c             	sub    $0xc,%esp
    9e10:	6a 09                	push   $0x9
    9e12:	e8 91 04 00 00       	call   a2a8 <PIC_sendEOI>
    9e17:	83 c4 10             	add    $0x10,%esp
}
    9e1a:	90                   	nop
    9e1b:	c9                   	leave  
    9e1c:	c3                   	ret    

00009e1d <irq10_handler>:

void irq10_handler(void)
{
    9e1d:	55                   	push   %ebp
    9e1e:	89 e5                	mov    %esp,%ebp
    9e20:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    9e23:	83 ec 0c             	sub    $0xc,%esp
    9e26:	6a 0a                	push   $0xa
    9e28:	e8 86 06 00 00       	call   a4b3 <spurious_IRQ>
    9e2d:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(10);
    9e30:	83 ec 0c             	sub    $0xc,%esp
    9e33:	6a 0a                	push   $0xa
    9e35:	e8 6e 04 00 00       	call   a2a8 <PIC_sendEOI>
    9e3a:	83 c4 10             	add    $0x10,%esp
}
    9e3d:	90                   	nop
    9e3e:	c9                   	leave  
    9e3f:	c3                   	ret    

00009e40 <irq11_handler>:

void irq11_handler(void)
{
    9e40:	55                   	push   %ebp
    9e41:	89 e5                	mov    %esp,%ebp
    9e43:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9e46:	83 ec 0c             	sub    $0xc,%esp
    9e49:	6a 0b                	push   $0xb
    9e4b:	e8 63 06 00 00       	call   a4b3 <spurious_IRQ>
    9e50:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(11);
    9e53:	83 ec 0c             	sub    $0xc,%esp
    9e56:	6a 0b                	push   $0xb
    9e58:	e8 4b 04 00 00       	call   a2a8 <PIC_sendEOI>
    9e5d:	83 c4 10             	add    $0x10,%esp
}
    9e60:	90                   	nop
    9e61:	c9                   	leave  
    9e62:	c3                   	ret    

00009e63 <irq12_handler>:

void irq12_handler(void)
{
    9e63:	55                   	push   %ebp
    9e64:	89 e5                	mov    %esp,%ebp
    9e66:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9e69:	83 ec 0c             	sub    $0xc,%esp
    9e6c:	6a 0c                	push   $0xc
    9e6e:	e8 40 06 00 00       	call   a4b3 <spurious_IRQ>
    9e73:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(12);
    9e76:	83 ec 0c             	sub    $0xc,%esp
    9e79:	6a 0c                	push   $0xc
    9e7b:	e8 28 04 00 00       	call   a2a8 <PIC_sendEOI>
    9e80:	83 c4 10             	add    $0x10,%esp
}
    9e83:	90                   	nop
    9e84:	c9                   	leave  
    9e85:	c3                   	ret    

00009e86 <irq13_handler>:

void irq13_handler(void)
{
    9e86:	55                   	push   %ebp
    9e87:	89 e5                	mov    %esp,%ebp
    9e89:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9e8c:	83 ec 0c             	sub    $0xc,%esp
    9e8f:	6a 0d                	push   $0xd
    9e91:	e8 1d 06 00 00       	call   a4b3 <spurious_IRQ>
    9e96:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(13);
    9e99:	83 ec 0c             	sub    $0xc,%esp
    9e9c:	6a 0d                	push   $0xd
    9e9e:	e8 05 04 00 00       	call   a2a8 <PIC_sendEOI>
    9ea3:	83 c4 10             	add    $0x10,%esp
}
    9ea6:	90                   	nop
    9ea7:	c9                   	leave  
    9ea8:	c3                   	ret    

00009ea9 <irq14_handler>:

void irq14_handler(void)
{
    9ea9:	55                   	push   %ebp
    9eaa:	89 e5                	mov    %esp,%ebp
    9eac:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9eaf:	83 ec 0c             	sub    $0xc,%esp
    9eb2:	6a 0e                	push   $0xe
    9eb4:	e8 fa 05 00 00       	call   a4b3 <spurious_IRQ>
    9eb9:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(14);
    9ebc:	83 ec 0c             	sub    $0xc,%esp
    9ebf:	6a 0e                	push   $0xe
    9ec1:	e8 e2 03 00 00       	call   a2a8 <PIC_sendEOI>
    9ec6:	83 c4 10             	add    $0x10,%esp
}
    9ec9:	90                   	nop
    9eca:	c9                   	leave  
    9ecb:	c3                   	ret    

00009ecc <irq15_handler>:

void irq15_handler(void)
{
    9ecc:	55                   	push   %ebp
    9ecd:	89 e5                	mov    %esp,%ebp
    9ecf:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    9ed2:	83 ec 0c             	sub    $0xc,%esp
    9ed5:	6a 0f                	push   $0xf
    9ed7:	e8 d7 05 00 00       	call   a4b3 <spurious_IRQ>
    9edc:	83 c4 10             	add    $0x10,%esp
    PIC_sendEOI(15);
    9edf:	83 ec 0c             	sub    $0xc,%esp
    9ee2:	6a 0f                	push   $0xf
    9ee4:	e8 bf 03 00 00       	call   a2a8 <PIC_sendEOI>
    9ee9:	83 c4 10             	add    $0x10,%esp
    9eec:	90                   	nop
    9eed:	c9                   	leave  
    9eee:	c3                   	ret    

00009eef <keyboard_irq>:

extern void show_cursor() ;
static void wait_8042_ACK ();

void keyboard_irq()
{
    9eef:	55                   	push   %ebp
    9ef0:	89 e5                	mov    %esp,%ebp
    9ef2:	83 ec 18             	sub    $0x18,%esp
	static int rshift_enable;
	static int alt_enable;
	static int ctrl_enable;

	do {
		i = _8042_get_status;
    9ef5:	b8 64 00 00 00       	mov    $0x64,%eax
    9efa:	89 c2                	mov    %eax,%edx
    9efc:	ec                   	in     (%dx),%al
    9efd:	88 45 f7             	mov    %al,-0x9(%ebp)
    9f00:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    9f04:	88 45 f6             	mov    %al,-0xa(%ebp)
	} while ((i & 0x01) == _8042_BUFFER_OVERRUN);
    9f07:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9f0b:	83 e0 01             	and    $0x1,%eax
    9f0e:	85 c0                	test   %eax,%eax
    9f10:	74 e3                	je     9ef5 <keyboard_irq+0x6>

	i = _8042_scan_code;
    9f12:	b8 60 00 00 00       	mov    $0x60,%eax
    9f17:	89 c2                	mov    %eax,%edx
    9f19:	ec                   	in     (%dx),%al
    9f1a:	88 45 f5             	mov    %al,-0xb(%ebp)
    9f1d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    9f21:	88 45 f6             	mov    %al,-0xa(%ebp)
	i--;
    9f24:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9f28:	83 e8 01             	sub    $0x1,%eax
    9f2b:	88 45 f6             	mov    %al,-0xa(%ebp)

	//// putcar('\n'); dump(&i, 1); putcar(' ');

	if (i < 0x80) {		/* touche enfoncee */
    9f2e:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9f32:	84 c0                	test   %al,%al
    9f34:	0f 88 c6 00 00 00    	js     a000 <keyboard_irq+0x111>
		switch (i) {
    9f3a:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9f3e:	83 f8 37             	cmp    $0x37,%eax
    9f41:	74 52                	je     9f95 <keyboard_irq+0xa6>
    9f43:	83 f8 37             	cmp    $0x37,%eax
    9f46:	7f 73                	jg     9fbb <keyboard_irq+0xcc>
    9f48:	83 f8 35             	cmp    $0x35,%eax
    9f4b:	74 2a                	je     9f77 <keyboard_irq+0x88>
    9f4d:	83 f8 35             	cmp    $0x35,%eax
    9f50:	7f 69                	jg     9fbb <keyboard_irq+0xcc>
    9f52:	83 f8 29             	cmp    $0x29,%eax
    9f55:	74 11                	je     9f68 <keyboard_irq+0x79>
    9f57:	83 f8 29             	cmp    $0x29,%eax
    9f5a:	7f 5f                	jg     9fbb <keyboard_irq+0xcc>
    9f5c:	83 f8 0d             	cmp    $0xd,%eax
    9f5f:	74 43                	je     9fa4 <keyboard_irq+0xb5>
    9f61:	83 f8 1c             	cmp    $0x1c,%eax
    9f64:	74 20                	je     9f86 <keyboard_irq+0x97>
    9f66:	eb 53                	jmp    9fbb <keyboard_irq+0xcc>
		case 0x29:
			lshift_enable = 1;
    9f68:	c7 05 18 08 01 00 01 	movl   $0x1,0x10818
    9f6f:	00 00 00 
			break;
    9f72:	e9 de 00 00 00       	jmp    a055 <keyboard_irq+0x166>
		case 0x35:
			rshift_enable = 1;
    9f77:	c7 05 1c 08 01 00 01 	movl   $0x1,0x1081c
    9f7e:	00 00 00 
			break;
    9f81:	e9 cf 00 00 00       	jmp    a055 <keyboard_irq+0x166>
		case 0x1C:
			ctrl_enable = 1;
    9f86:	c7 05 20 08 01 00 01 	movl   $0x1,0x10820
    9f8d:	00 00 00 
			break;
    9f90:	e9 c0 00 00 00       	jmp    a055 <keyboard_irq+0x166>
		case 0x37:
			alt_enable = 1;
    9f95:	c7 05 24 08 01 00 01 	movl   $0x1,0x10824
    9f9c:	00 00 00 
			break;
    9f9f:	e9 b1 00 00 00       	jmp    a055 <keyboard_irq+0x166>
		case 0x0D:
				cputchar(READY_COLOR  , i);
    9fa4:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9fa8:	83 ec 08             	sub    $0x8,%esp
    9fab:	50                   	push   %eax
    9fac:	6a 07                	push   $0x7
    9fae:	e8 fe f4 ff ff       	call   94b1 <cputchar>
    9fb3:	83 c4 10             	add    $0x10,%esp
			break;
    9fb6:	e9 9a 00 00 00       	jmp    a055 <keyboard_irq+0x166>
		default:
			cputchar(READY_COLOR ,  kbdmap
			       [i * 4 + (lshift_enable || rshift_enable)]);
    9fbb:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9fbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    9fc6:	a1 18 08 01 00       	mov    0x10818,%eax
    9fcb:	85 c0                	test   %eax,%eax
    9fcd:	75 09                	jne    9fd8 <keyboard_irq+0xe9>
    9fcf:	a1 1c 08 01 00       	mov    0x1081c,%eax
    9fd4:	85 c0                	test   %eax,%eax
    9fd6:	74 07                	je     9fdf <keyboard_irq+0xf0>
    9fd8:	b8 01 00 00 00       	mov    $0x1,%eax
    9fdd:	eb 05                	jmp    9fe4 <keyboard_irq+0xf5>
    9fdf:	b8 00 00 00 00       	mov    $0x0,%eax
    9fe4:	01 d0                	add    %edx,%eax
    9fe6:	0f b6 80 e0 b2 00 00 	movzbl 0xb2e0(%eax),%eax
			cputchar(READY_COLOR ,  kbdmap
    9fed:	0f b6 c0             	movzbl %al,%eax
    9ff0:	83 ec 08             	sub    $0x8,%esp
    9ff3:	50                   	push   %eax
    9ff4:	6a 07                	push   $0x7
    9ff6:	e8 b6 f4 ff ff       	call   94b1 <cputchar>
    9ffb:	83 c4 10             	add    $0x10,%esp
    9ffe:	eb 55                	jmp    a055 <keyboard_irq+0x166>
		}
	} else {		/* touche relachee */
		i -= 0x80;
    a000:	80 45 f6 80          	addb   $0x80,-0xa(%ebp)
		switch (i) {
    a004:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a008:	83 f8 37             	cmp    $0x37,%eax
    a00b:	74 3d                	je     a04a <keyboard_irq+0x15b>
    a00d:	83 f8 37             	cmp    $0x37,%eax
    a010:	7f 43                	jg     a055 <keyboard_irq+0x166>
    a012:	83 f8 35             	cmp    $0x35,%eax
    a015:	74 1b                	je     a032 <keyboard_irq+0x143>
    a017:	83 f8 35             	cmp    $0x35,%eax
    a01a:	7f 39                	jg     a055 <keyboard_irq+0x166>
    a01c:	83 f8 1c             	cmp    $0x1c,%eax
    a01f:	74 1d                	je     a03e <keyboard_irq+0x14f>
    a021:	83 f8 29             	cmp    $0x29,%eax
    a024:	75 2f                	jne    a055 <keyboard_irq+0x166>
		case 0x29:
			lshift_enable = 0;
    a026:	c7 05 18 08 01 00 00 	movl   $0x0,0x10818
    a02d:	00 00 00 
			break;
    a030:	eb 23                	jmp    a055 <keyboard_irq+0x166>
		case 0x35:
			rshift_enable = 0;
    a032:	c7 05 1c 08 01 00 00 	movl   $0x0,0x1081c
    a039:	00 00 00 
			break;
    a03c:	eb 17                	jmp    a055 <keyboard_irq+0x166>
		case 0x1C:
			ctrl_enable = 0;
    a03e:	c7 05 20 08 01 00 00 	movl   $0x0,0x10820
    a045:	00 00 00 
			break;
    a048:	eb 0b                	jmp    a055 <keyboard_irq+0x166>
		case 0x37:
			alt_enable = 0;
    a04a:	c7 05 24 08 01 00 00 	movl   $0x0,0x10824
    a051:	00 00 00 
			break;
    a054:	90                   	nop
		}
	}

	show_cursor() ;
    a055:	e8 d2 f5 ff ff       	call   962c <show_cursor>
}
    a05a:	90                   	nop
    a05b:	c9                   	leave  
    a05c:	c3                   	ret    

0000a05d <reinitialise_kbd>:

void reinitialise_kbd()
{
    a05d:	55                   	push   %ebp
    a05e:	89 e5                	mov    %esp,%ebp
    a060:	83 ec 08             	sub    $0x8,%esp
	_8042_send_get_current_scan_code ;
    a063:	ba 64 00 00 00       	mov    $0x64,%edx
    a068:	b8 f0 00 00 00       	mov    $0xf0,%eax
    a06d:	ee                   	out    %al,(%dx)
	wait_8042_ACK ();
    a06e:	e8 33 00 00 00       	call   a0a6 <wait_8042_ACK>

	_8042_set_typematic_rate ; 
    a073:	ba 64 00 00 00       	mov    $0x64,%edx
    a078:	b8 f3 00 00 00       	mov    $0xf3,%eax
    a07d:	ee                   	out    %al,(%dx)
	wait_8042_ACK ();
    a07e:	e8 23 00 00 00       	call   a0a6 <wait_8042_ACK>
	
	_8042_set_leds ;
    a083:	ba 64 00 00 00       	mov    $0x64,%edx
    a088:	b8 ed 00 00 00       	mov    $0xed,%eax
    a08d:	ee                   	out    %al,(%dx)
	wait_8042_ACK ();
    a08e:	e8 13 00 00 00       	call   a0a6 <wait_8042_ACK>
	
	_8042_enable_scanning ;
    a093:	ba 64 00 00 00       	mov    $0x64,%edx
    a098:	b8 f4 00 00 00       	mov    $0xf4,%eax
    a09d:	ee                   	out    %al,(%dx)
	wait_8042_ACK ();
    a09e:	e8 03 00 00 00       	call   a0a6 <wait_8042_ACK>
}
    a0a3:	90                   	nop
    a0a4:	c9                   	leave  
    a0a5:	c3                   	ret    

0000a0a6 <wait_8042_ACK>:

static void wait_8042_ACK ()
{
    a0a6:	55                   	push   %ebp
    a0a7:	89 e5                	mov    %esp,%ebp
    a0a9:	83 ec 10             	sub    $0x10,%esp
	while(_8042_get_status  != _8042_ACK);
    a0ac:	90                   	nop
    a0ad:	b8 64 00 00 00       	mov    $0x64,%eax
    a0b2:	89 c2                	mov    %eax,%edx
    a0b4:	ec                   	in     (%dx),%al
    a0b5:	88 45 ff             	mov    %al,-0x1(%ebp)
    a0b8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a0bc:	3c fa                	cmp    $0xfa,%al
    a0be:	75 ed                	jne    a0ad <wait_8042_ACK+0x7>
    a0c0:	90                   	nop
    a0c1:	90                   	nop
    a0c2:	c9                   	leave  
    a0c3:	c3                   	ret    

0000a0c4 <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    a0c4:	55                   	push   %ebp
    a0c5:	89 e5                	mov    %esp,%ebp
    a0c7:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a0ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    a0d1:	eb 20                	jmp    a0f3 <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a0d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a0d6:	c1 e0 0c             	shl    $0xc,%eax
    a0d9:	89 c2                	mov    %eax,%edx
    a0db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a0de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a0e5:	8b 45 08             	mov    0x8(%ebp),%eax
    a0e8:	01 c8                	add    %ecx,%eax
    a0ea:	83 ca 23             	or     $0x23,%edx
    a0ed:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a0ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    a0f3:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    a0fa:	76 d7                	jbe    a0d3 <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    a0fc:	8b 45 08             	mov    0x8(%ebp),%eax
    a0ff:	83 c8 23             	or     $0x23,%eax
    a102:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    a104:	8b 45 0c             	mov    0xc(%ebp),%eax
    a107:	89 14 85 00 10 01 00 	mov    %edx,0x11000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    a10e:	e8 3d 10 00 00       	call   b150 <_FlushPagingCache_>
}
    a113:	90                   	nop
    a114:	c9                   	leave  
    a115:	c3                   	ret    

0000a116 <init_paging>:

void init_paging()
{
    a116:	55                   	push   %ebp
    a117:	89 e5                	mov    %esp,%ebp
    a119:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    a11c:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a122:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    a128:	eb 1a                	jmp    a144 <init_paging+0x2e>
        page_directory[i] =
    a12a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a12e:	c7 04 85 00 10 01 00 	movl   $0x2,0x11000(,%eax,4)
    a135:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    a139:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a13d:	83 c0 01             	add    $0x1,%eax
    a140:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a144:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a14a:	76 de                	jbe    a12a <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a14c:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    a152:	eb 22                	jmp    a176 <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a154:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a158:	c1 e0 0c             	shl    $0xc,%eax
    a15b:	83 c8 23             	or     $0x23,%eax
    a15e:	89 c2                	mov    %eax,%edx
    a160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a164:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    a16b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    a16f:	83 c0 01             	add    $0x1,%eax
    a172:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    a176:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    a17c:	76 d6                	jbe    a154 <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    a17e:	b8 00 c0 00 00       	mov    $0xc000,%eax
    a183:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    a186:	a3 00 10 01 00       	mov    %eax,0x11000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    a18b:	e8 c9 0f 00 00       	call   b159 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    a190:	90                   	nop
    a191:	c9                   	leave  
    a192:	c3                   	ret    

0000a193 <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    a193:	55                   	push   %ebp
    a194:	89 e5                	mov    %esp,%ebp
    a196:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    a199:	8b 45 08             	mov    0x8(%ebp),%eax
    a19c:	c1 e8 16             	shr    $0x16,%eax
    a19f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    a1a2:	8b 45 08             	mov    0x8(%ebp),%eax
    a1a5:	c1 e8 0c             	shr    $0xc,%eax
    a1a8:	25 ff 03 00 00       	and    $0x3ff,%eax
    a1ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a1b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a1b3:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a1ba:	83 e0 23             	and    $0x23,%eax
    a1bd:	83 f8 23             	cmp    $0x23,%eax
    a1c0:	75 56                	jne    a218 <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a1c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a1c5:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a1cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a1d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a1d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a1d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a1de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1e1:	01 d0                	add    %edx,%eax
    a1e3:	8b 00                	mov    (%eax),%eax
    a1e5:	83 e0 23             	and    $0x23,%eax
    a1e8:	83 f8 23             	cmp    $0x23,%eax
    a1eb:	75 24                	jne    a211 <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a1ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a1f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a1f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a1fa:	01 d0                	add    %edx,%eax
    a1fc:	8b 00                	mov    (%eax),%eax
    a1fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a203:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    a205:	8b 45 08             	mov    0x8(%ebp),%eax
    a208:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    a20d:	09 d0                	or     %edx,%eax
    a20f:	eb 0c                	jmp    a21d <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    a211:	b8 70 f0 00 00       	mov    $0xf070,%eax
    a216:	eb 05                	jmp    a21d <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    a218:	b8 70 f0 00 00       	mov    $0xf070,%eax
}
    a21d:	c9                   	leave  
    a21e:	c3                   	ret    

0000a21f <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    a21f:	55                   	push   %ebp
    a220:	89 e5                	mov    %esp,%ebp
    a222:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    a225:	8b 45 08             	mov    0x8(%ebp),%eax
    a228:	c1 e8 16             	shr    $0x16,%eax
    a22b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    a22e:	8b 45 08             	mov    0x8(%ebp),%eax
    a231:	c1 e8 0c             	shr    $0xc,%eax
    a234:	25 ff 03 00 00       	and    $0x3ff,%eax
    a239:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    a23c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a23f:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a246:	83 e0 23             	and    $0x23,%eax
    a249:	83 f8 23             	cmp    $0x23,%eax
    a24c:	75 4e                	jne    a29c <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    a24e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a251:	8b 04 85 00 10 01 00 	mov    0x11000(,%eax,4),%eax
    a258:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a25d:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    a260:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a263:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a26a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a26d:	01 d0                	add    %edx,%eax
    a26f:	8b 00                	mov    (%eax),%eax
    a271:	83 e0 23             	and    $0x23,%eax
    a274:	83 f8 23             	cmp    $0x23,%eax
    a277:	74 26                	je     a29f <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    a279:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a27c:	c1 e0 0c             	shl    $0xc,%eax
    a27f:	89 c2                	mov    %eax,%edx
    a281:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a284:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    a28b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a28e:	01 c8                	add    %ecx,%eax
    a290:	83 ca 23             	or     $0x23,%edx
    a293:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    a295:	e8 b6 0e 00 00       	call   b150 <_FlushPagingCache_>
    a29a:	eb 04                	jmp    a2a0 <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    a29c:	90                   	nop
    a29d:	eb 01                	jmp    a2a0 <map_linear_address+0x81>
            return; // the linear address was already mapped
    a29f:	90                   	nop
}
    a2a0:	c9                   	leave  
    a2a1:	c3                   	ret    

0000a2a2 <Paging_fault>:

void Paging_fault()
{
    a2a2:	55                   	push   %ebp
    a2a3:	89 e5                	mov    %esp,%ebp
}
    a2a5:	90                   	nop
    a2a6:	5d                   	pop    %ebp
    a2a7:	c3                   	ret    

0000a2a8 <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    a2a8:	55                   	push   %ebp
    a2a9:	89 e5                	mov    %esp,%ebp
    a2ab:	83 ec 04             	sub    $0x4,%esp
    a2ae:	8b 45 08             	mov    0x8(%ebp),%eax
    a2b1:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    a2b4:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    a2b8:	76 0b                	jbe    a2c5 <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    a2ba:	ba a0 00 00 00       	mov    $0xa0,%edx
    a2bf:	b8 20 00 00 00       	mov    $0x20,%eax
    a2c4:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    a2c5:	ba 20 00 00 00       	mov    $0x20,%edx
    a2ca:	b8 20 00 00 00       	mov    $0x20,%eax
    a2cf:	ee                   	out    %al,(%dx)
}
    a2d0:	90                   	nop
    a2d1:	c9                   	leave  
    a2d2:	c3                   	ret    

0000a2d3 <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    a2d3:	55                   	push   %ebp
    a2d4:	89 e5                	mov    %esp,%ebp
    a2d6:	83 ec 18             	sub    $0x18,%esp
    a2d9:	8b 55 08             	mov    0x8(%ebp),%edx
    a2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    a2df:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a2e2:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    a2e5:	b8 21 00 00 00       	mov    $0x21,%eax
    a2ea:	89 c2                	mov    %eax,%edx
    a2ec:	ec                   	in     (%dx),%al
    a2ed:	88 45 ff             	mov    %al,-0x1(%ebp)
    a2f0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a2f4:	88 45 fe             	mov    %al,-0x2(%ebp)
    a2 = inb(PIC2_DATA);
    a2f7:	b8 a1 00 00 00       	mov    $0xa1,%eax
    a2fc:	89 c2                	mov    %eax,%edx
    a2fe:	ec                   	in     (%dx),%al
    a2ff:	88 45 fd             	mov    %al,-0x3(%ebp)
    a302:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a306:	88 45 fc             	mov    %al,-0x4(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a309:	ba 20 00 00 00       	mov    $0x20,%edx
    a30e:	b8 11 00 00 00       	mov    $0x11,%eax
    a313:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a314:	eb 00                	jmp    a316 <PIC_remap+0x43>
    a316:	eb 00                	jmp    a318 <PIC_remap+0x45>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    a318:	ba a0 00 00 00       	mov    $0xa0,%edx
    a31d:	b8 11 00 00 00       	mov    $0x11,%eax
    a322:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    a323:	eb 00                	jmp    a325 <PIC_remap+0x52>
    a325:	eb 00                	jmp    a327 <PIC_remap+0x54>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    a327:	ba 21 00 00 00       	mov    $0x21,%edx
    a32c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a330:	ee                   	out    %al,(%dx)
    io_wait;
    a331:	eb 00                	jmp    a333 <PIC_remap+0x60>
    a333:	eb 00                	jmp    a335 <PIC_remap+0x62>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    a335:	ba a1 00 00 00       	mov    $0xa1,%edx
    a33a:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a33e:	ee                   	out    %al,(%dx)
    io_wait;
    a33f:	eb 00                	jmp    a341 <PIC_remap+0x6e>
    a341:	eb 00                	jmp    a343 <PIC_remap+0x70>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    a343:	ba 21 00 00 00       	mov    $0x21,%edx
    a348:	b8 04 00 00 00       	mov    $0x4,%eax
    a34d:	ee                   	out    %al,(%dx)
    io_wait;
    a34e:	eb 00                	jmp    a350 <PIC_remap+0x7d>
    a350:	eb 00                	jmp    a352 <PIC_remap+0x7f>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    a352:	ba a1 00 00 00       	mov    $0xa1,%edx
    a357:	b8 02 00 00 00       	mov    $0x2,%eax
    a35c:	ee                   	out    %al,(%dx)
    io_wait;
    a35d:	eb 00                	jmp    a35f <PIC_remap+0x8c>
    a35f:	eb 00                	jmp    a361 <PIC_remap+0x8e>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    a361:	ba 21 00 00 00       	mov    $0x21,%edx
    a366:	b8 01 00 00 00       	mov    $0x1,%eax
    a36b:	ee                   	out    %al,(%dx)
    io_wait;
    a36c:	eb 00                	jmp    a36e <PIC_remap+0x9b>
    a36e:	eb 00                	jmp    a370 <PIC_remap+0x9d>

    outb(PIC2_DATA, ICW4_8086);
    a370:	ba a1 00 00 00       	mov    $0xa1,%edx
    a375:	b8 01 00 00 00       	mov    $0x1,%eax
    a37a:	ee                   	out    %al,(%dx)
    io_wait;
    a37b:	eb 00                	jmp    a37d <PIC_remap+0xaa>
    a37d:	eb 00                	jmp    a37f <PIC_remap+0xac>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    a37f:	ba 21 00 00 00       	mov    $0x21,%edx
    a384:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
    a388:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    a389:	ba a1 00 00 00       	mov    $0xa1,%edx
    a38e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
    a392:	ee                   	out    %al,(%dx)
}
    a393:	90                   	nop
    a394:	c9                   	leave  
    a395:	c3                   	ret    

0000a396 <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    a396:	55                   	push   %ebp
    a397:	89 e5                	mov    %esp,%ebp
    a399:	53                   	push   %ebx
    a39a:	83 ec 14             	sub    $0x14,%esp
    a39d:	8b 45 08             	mov    0x8(%ebp),%eax
    a3a0:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    a3a3:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a3a7:	77 08                	ja     a3b1 <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    a3a9:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    a3af:	eb 0a                	jmp    a3bb <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    a3b1:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    a3b7:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    a3bb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    a3bf:	89 c2                	mov    %eax,%edx
    a3c1:	ec                   	in     (%dx),%al
    a3c2:	88 45 f9             	mov    %al,-0x7(%ebp)
    a3c5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a3c9:	89 c3                	mov    %eax,%ebx
    a3cb:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a3cf:	ba 01 00 00 00       	mov    $0x1,%edx
    a3d4:	89 c1                	mov    %eax,%ecx
    a3d6:	d3 e2                	shl    %cl,%edx
    a3d8:	89 d0                	mov    %edx,%eax
    a3da:	09 d8                	or     %ebx,%eax
    a3dc:	88 45 f8             	mov    %al,-0x8(%ebp)

    outb(port, value);
    a3df:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    a3e3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    a3e7:	ee                   	out    %al,(%dx)
}
    a3e8:	90                   	nop
    a3e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a3ec:	c9                   	leave  
    a3ed:	c3                   	ret    

0000a3ee <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    a3ee:	55                   	push   %ebp
    a3ef:	89 e5                	mov    %esp,%ebp
    a3f1:	53                   	push   %ebx
    a3f2:	83 ec 14             	sub    $0x14,%esp
    a3f5:	8b 45 08             	mov    0x8(%ebp),%eax
    a3f8:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    a3fb:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    a3ff:	77 09                	ja     a40a <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    a401:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    a408:	eb 0b                	jmp    a415 <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    a40a:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    a411:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    a415:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a418:	89 c2                	mov    %eax,%edx
    a41a:	ec                   	in     (%dx),%al
    a41b:	88 45 f7             	mov    %al,-0x9(%ebp)
    a41e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a422:	89 c3                	mov    %eax,%ebx
    a424:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    a428:	ba 01 00 00 00       	mov    $0x1,%edx
    a42d:	89 c1                	mov    %eax,%ecx
    a42f:	d3 e2                	shl    %cl,%edx
    a431:	89 d0                	mov    %edx,%eax
    a433:	f7 d0                	not    %eax
    a435:	21 d8                	and    %ebx,%eax
    a437:	88 45 f6             	mov    %al,-0xa(%ebp)

    outb(port, value);
    a43a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a43d:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a441:	ee                   	out    %al,(%dx)
}
    a442:	90                   	nop
    a443:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a446:	c9                   	leave  
    a447:	c3                   	ret    

0000a448 <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a448:	55                   	push   %ebp
    a449:	89 e5                	mov    %esp,%ebp
    a44b:	83 ec 14             	sub    $0x14,%esp
    a44e:	8b 45 08             	mov    0x8(%ebp),%eax
    a451:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a454:	ba 20 00 00 00       	mov    $0x20,%edx
    a459:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a45d:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a45e:	ba a0 00 00 00       	mov    $0xa0,%edx
    a463:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a467:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a468:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a46d:	89 c2                	mov    %eax,%edx
    a46f:	ec                   	in     (%dx),%al
    a470:	88 45 ff             	mov    %al,-0x1(%ebp)
    a473:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a477:	0f b6 c0             	movzbl %al,%eax
    a47a:	c1 e0 08             	shl    $0x8,%eax
    a47d:	89 c1                	mov    %eax,%ecx
    a47f:	b8 20 00 00 00       	mov    $0x20,%eax
    a484:	89 c2                	mov    %eax,%edx
    a486:	ec                   	in     (%dx),%al
    a487:	88 45 fe             	mov    %al,-0x2(%ebp)
    a48a:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
    a48e:	0f b6 c0             	movzbl %al,%eax
    a491:	09 c8                	or     %ecx,%eax
}
    a493:	c9                   	leave  
    a494:	c3                   	ret    

0000a495 <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a495:	55                   	push   %ebp
    a496:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a498:	6a 0b                	push   $0xb
    a49a:	e8 a9 ff ff ff       	call   a448 <__pic_get_irq_reg>
    a49f:	83 c4 04             	add    $0x4,%esp
}
    a4a2:	c9                   	leave  
    a4a3:	c3                   	ret    

0000a4a4 <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a4a4:	55                   	push   %ebp
    a4a5:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a4a7:	6a 0a                	push   $0xa
    a4a9:	e8 9a ff ff ff       	call   a448 <__pic_get_irq_reg>
    a4ae:	83 c4 04             	add    $0x4,%esp
}
    a4b1:	c9                   	leave  
    a4b2:	c3                   	ret    

0000a4b3 <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a4b3:	55                   	push   %ebp
    a4b4:	89 e5                	mov    %esp,%ebp
    a4b6:	83 ec 14             	sub    $0x14,%esp
    a4b9:	8b 45 08             	mov    0x8(%ebp),%eax
    a4bc:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a4bf:	e8 d1 ff ff ff       	call   a495 <pic_get_isr>
    a4c4:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a4c8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a4cc:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a4d0:	74 13                	je     a4e5 <spurious_IRQ+0x32>
    a4d2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a4d6:	0f b6 c0             	movzbl %al,%eax
    a4d9:	83 e0 07             	and    $0x7,%eax
    a4dc:	50                   	push   %eax
    a4dd:	e8 c6 fd ff ff       	call   a2a8 <PIC_sendEOI>
    a4e2:	83 c4 04             	add    $0x4,%esp
    a4e5:	90                   	nop
    a4e6:	c9                   	leave  
    a4e7:	c3                   	ret    

0000a4e8 <conserv_status_byte>:
uint32_t compteur = 0;
uint8_t frequency = 0;
uint8_t status_PIT = 0;

void conserv_status_byte()
{
    a4e8:	55                   	push   %ebp
    a4e9:	89 e5                	mov    %esp,%ebp
    a4eb:	83 ec 10             	sub    $0x10,%esp
     set_pit_count(PIT_0, PIT_reload_value);
    a4ee:	ba 43 00 00 00       	mov    $0x43,%edx
    a4f3:	b8 40 00 00 00       	mov    $0x40,%eax
    a4f8:	ee                   	out    %al,(%dx)
    a4f9:	b8 40 00 00 00       	mov    $0x40,%eax
    a4fe:	89 c2                	mov    %eax,%edx
    a500:	ec                   	in     (%dx),%al
    a501:	88 45 ff             	mov    %al,-0x1(%ebp)
    a504:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a508:	88 45 fa             	mov    %al,-0x6(%ebp)
    a50b:	b8 40 00 00 00       	mov    $0x40,%eax
    a510:	89 c2                	mov    %eax,%edx
    a512:	ec                   	in     (%dx),%al
    a513:	88 45 fe             	mov    %al,-0x2(%ebp)
    a516:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
    a51a:	88 45 fb             	mov    %al,-0x5(%ebp)
    a51d:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
    a521:	66 98                	cbtw   
    a523:	ba 40 00 00 00       	mov    $0x40,%edx
    a528:	ee                   	out    %al,(%dx)
    a529:	a1 54 31 02 00       	mov    0x23154,%eax
    a52e:	c1 f8 08             	sar    $0x8,%eax
    a531:	ba 40 00 00 00       	mov    $0x40,%edx
    a536:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a537:	ba 43 00 00 00       	mov    $0x43,%edx
    a53c:	b8 40 00 00 00       	mov    $0x40,%eax
    a541:	ee                   	out    %al,(%dx)
    a542:	b8 40 00 00 00       	mov    $0x40,%eax
    a547:	89 c2                	mov    %eax,%edx
    a549:	ec                   	in     (%dx),%al
    a54a:	88 45 fd             	mov    %al,-0x3(%ebp)
    a54d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a551:	88 45 f8             	mov    %al,-0x8(%ebp)
    a554:	b8 40 00 00 00       	mov    $0x40,%eax
    a559:	89 c2                	mov    %eax,%edx
    a55b:	ec                   	in     (%dx),%al
    a55c:	88 45 fc             	mov    %al,-0x4(%ebp)
    a55f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
    a563:	88 45 f9             	mov    %al,-0x7(%ebp)
    a566:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    a56a:	66 98                	cbtw   
    a56c:	ba 43 00 00 00       	mov    $0x43,%edx
    a571:	ee                   	out    %al,(%dx)
    a572:	ba 43 00 00 00       	mov    $0x43,%edx
    a577:	b8 34 00 00 00       	mov    $0x34,%eax
    a57c:	ee                   	out    %al,(%dx)

}
    a57d:	90                   	nop
    a57e:	c9                   	leave  
    a57f:	c3                   	ret    

0000a580 <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a580:	55                   	push   %ebp
    a581:	89 e5                	mov    %esp,%ebp
    a583:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a586:	0f b6 05 20 30 02 00 	movzbl 0x23020,%eax
    a58d:	3c 01                	cmp    $0x1,%al
    a58f:	75 27                	jne    a5b8 <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a591:	a1 24 30 02 00       	mov    0x23024,%eax
    a596:	85 c0                	test   %eax,%eax
    a598:	75 11                	jne    a5ab <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a59a:	c7 05 24 30 02 00 2c 	movl   $0x12c,0x23024
    a5a1:	01 00 00 
            __switch();
    a5a4:	e8 bf 09 00 00       	call   af68 <__switch>
        }
        else
            sheduler.task_timer--;
    }
}
    a5a9:	eb 0d                	jmp    a5b8 <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a5ab:	a1 24 30 02 00       	mov    0x23024,%eax
    a5b0:	83 e8 01             	sub    $0x1,%eax
    a5b3:	a3 24 30 02 00       	mov    %eax,0x23024
}
    a5b8:	90                   	nop
    a5b9:	c9                   	leave  
    a5ba:	c3                   	ret    

0000a5bb <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a5bb:	55                   	push   %ebp
    a5bc:	89 e5                	mov    %esp,%ebp
    a5be:	83 ec 28             	sub    $0x28,%esp
    a5c1:	8b 45 08             	mov    0x8(%ebp),%eax
    a5c4:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a5c8:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a5cc:	a2 04 20 01 00       	mov    %al,0x12004
    calculate_frequency();
    a5d1:	e8 e6 0b 00 00       	call   b1bc <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a5d6:	ba 43 00 00 00       	mov    $0x43,%edx
    a5db:	b8 40 00 00 00       	mov    $0x40,%eax
    a5e0:	ee                   	out    %al,(%dx)
    a5e1:	b8 40 00 00 00       	mov    $0x40,%eax
    a5e6:	89 c2                	mov    %eax,%edx
    a5e8:	ec                   	in     (%dx),%al
    a5e9:	88 45 f7             	mov    %al,-0x9(%ebp)
    a5ec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a5f0:	88 45 f2             	mov    %al,-0xe(%ebp)
    a5f3:	b8 40 00 00 00       	mov    $0x40,%eax
    a5f8:	89 c2                	mov    %eax,%edx
    a5fa:	ec                   	in     (%dx),%al
    a5fb:	88 45 f6             	mov    %al,-0xa(%ebp)
    a5fe:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a602:	88 45 f3             	mov    %al,-0xd(%ebp)
    a605:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a609:	66 98                	cbtw   
    a60b:	ba 43 00 00 00       	mov    $0x43,%edx
    a610:	ee                   	out    %al,(%dx)
    a611:	ba 43 00 00 00       	mov    $0x43,%edx
    a616:	b8 34 00 00 00       	mov    $0x34,%eax
    a61b:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a61c:	ba 43 00 00 00       	mov    $0x43,%edx
    a621:	b8 40 00 00 00       	mov    $0x40,%eax
    a626:	ee                   	out    %al,(%dx)
    a627:	b8 40 00 00 00       	mov    $0x40,%eax
    a62c:	89 c2                	mov    %eax,%edx
    a62e:	ec                   	in     (%dx),%al
    a62f:	88 45 f5             	mov    %al,-0xb(%ebp)
    a632:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a636:	88 45 f0             	mov    %al,-0x10(%ebp)
    a639:	b8 40 00 00 00       	mov    $0x40,%eax
    a63e:	89 c2                	mov    %eax,%edx
    a640:	ec                   	in     (%dx),%al
    a641:	88 45 f4             	mov    %al,-0xc(%ebp)
    a644:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a648:	88 45 f1             	mov    %al,-0xf(%ebp)
    a64b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
    a64f:	66 98                	cbtw   
    a651:	ba 40 00 00 00       	mov    $0x40,%edx
    a656:	ee                   	out    %al,(%dx)
    a657:	a1 54 31 02 00       	mov    0x23154,%eax
    a65c:	c1 f8 08             	sar    $0x8,%eax
    a65f:	ba 40 00 00 00       	mov    $0x40,%edx
    a664:	ee                   	out    %al,(%dx)
}
    a665:	90                   	nop
    a666:	c9                   	leave  
    a667:	c3                   	ret    

0000a668 <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a668:	55                   	push   %ebp
    a669:	89 e5                	mov    %esp,%ebp
    a66b:	83 ec 14             	sub    $0x14,%esp
    a66e:	8b 45 08             	mov    0x8(%ebp),%eax
    a671:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a674:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a678:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a67c:	83 f8 42             	cmp    $0x42,%eax
    a67f:	74 1d                	je     a69e <read_back_channel+0x36>
    a681:	83 f8 42             	cmp    $0x42,%eax
    a684:	7f 1e                	jg     a6a4 <read_back_channel+0x3c>
    a686:	83 f8 40             	cmp    $0x40,%eax
    a689:	74 07                	je     a692 <read_back_channel+0x2a>
    a68b:	83 f8 41             	cmp    $0x41,%eax
    a68e:	74 08                	je     a698 <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a690:	eb 12                	jmp    a6a4 <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a692:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a696:	eb 0d                	jmp    a6a5 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a698:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a69c:	eb 07                	jmp    a6a5 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a69e:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a6a2:	eb 01                	jmp    a6a5 <read_back_channel+0x3d>
        break;
    a6a4:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a6a5:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a6a9:	ba 43 00 00 00       	mov    $0x43,%edx
    a6ae:	b8 40 00 00 00       	mov    $0x40,%eax
    a6b3:	ee                   	out    %al,(%dx)
    a6b4:	b8 40 00 00 00       	mov    $0x40,%eax
    a6b9:	89 c2                	mov    %eax,%edx
    a6bb:	ec                   	in     (%dx),%al
    a6bc:	88 45 fe             	mov    %al,-0x2(%ebp)
    a6bf:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
    a6c3:	88 45 f9             	mov    %al,-0x7(%ebp)
    a6c6:	b8 40 00 00 00       	mov    $0x40,%eax
    a6cb:	89 c2                	mov    %eax,%edx
    a6cd:	ec                   	in     (%dx),%al
    a6ce:	88 45 fd             	mov    %al,-0x3(%ebp)
    a6d1:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a6d5:	88 45 fa             	mov    %al,-0x6(%ebp)
    a6d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a6dc:	66 98                	cbtw   
    a6de:	ba 43 00 00 00       	mov    $0x43,%edx
    a6e3:	ee                   	out    %al,(%dx)
    a6e4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a6e8:	c1 f8 08             	sar    $0x8,%eax
    a6eb:	ba 43 00 00 00       	mov    $0x43,%edx
    a6f0:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a6f1:	ba 43 00 00 00       	mov    $0x43,%edx
    a6f6:	b8 40 00 00 00       	mov    $0x40,%eax
    a6fb:	ee                   	out    %al,(%dx)
    a6fc:	b8 40 00 00 00       	mov    $0x40,%eax
    a701:	89 c2                	mov    %eax,%edx
    a703:	ec                   	in     (%dx),%al
    a704:	88 45 fc             	mov    %al,-0x4(%ebp)
    a707:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
    a70b:	88 45 f7             	mov    %al,-0x9(%ebp)
    a70e:	b8 40 00 00 00       	mov    $0x40,%eax
    a713:	89 c2                	mov    %eax,%edx
    a715:	ec                   	in     (%dx),%al
    a716:	88 45 fb             	mov    %al,-0x5(%ebp)
    a719:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
    a71d:	88 45 f8             	mov    %al,-0x8(%ebp)
    a720:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a724:	66 98                	cbtw   
    a726:	c9                   	leave  
    a727:	c3                   	ret    

0000a728 <kprintf>:
#include <stdint.h>

extern void printf(const char* fmt, ...);

void kprintf(const char* frmt, ...)
{
    a728:	55                   	push   %ebp
    a729:	89 e5                	mov    %esp,%ebp
    a72b:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    a72e:	8d 45 0c             	lea    0xc(%ebp),%eax
    a731:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    a734:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a737:	83 ec 08             	sub    $0x8,%esp
    a73a:	50                   	push   %eax
    a73b:	ff 75 08             	pushl  0x8(%ebp)
    a73e:	e8 95 e9 ff ff       	call   90d8 <printf>
    a743:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
}
    a746:	90                   	nop
    a747:	c9                   	leave  
    a748:	c3                   	ret    

0000a749 <kputs>:

void kputs(const char* frmt, ...)
{
    a749:	55                   	push   %ebp
    a74a:	89 e5                	mov    %esp,%ebp
    a74c:	83 ec 18             	sub    $0x18,%esp
    va_list arg;
    va_start(arg, frmt);
    a74f:	8d 45 0c             	lea    0xc(%ebp),%eax
    a752:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(frmt, arg);
    a755:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a758:	83 ec 08             	sub    $0x8,%esp
    a75b:	50                   	push   %eax
    a75c:	ff 75 08             	pushl  0x8(%ebp)
    a75f:	e8 74 e9 ff ff       	call   90d8 <printf>
    a764:	83 c4 10             	add    $0x10,%esp
    va_end(arg);
    printf("\n");
    a767:	83 ec 0c             	sub    $0xc,%esp
    a76a:	68 7b f0 00 00       	push   $0xf07b
    a76f:	e8 64 e9 ff ff       	call   90d8 <printf>
    a774:	83 c4 10             	add    $0x10,%esp
    a777:	90                   	nop
    a778:	c9                   	leave  
    a779:	c3                   	ret    

0000a77a <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    a77a:	55                   	push   %ebp
    a77b:	89 e5                	mov    %esp,%ebp
    a77d:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    a780:	b8 1b 00 00 00       	mov    $0x1b,%eax
    a785:	89 c1                	mov    %eax,%ecx
    a787:	0f 32                	rdmsr  
    a789:	89 45 f8             	mov    %eax,-0x8(%ebp)
    a78c:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    a78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a792:	c1 e0 05             	shl    $0x5,%eax
    a795:	89 c2                	mov    %eax,%edx
    a797:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a79a:	01 d0                	add    %edx,%eax
}
    a79c:	c9                   	leave  
    a79d:	c3                   	ret    

0000a79e <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    a79e:	55                   	push   %ebp
    a79f:	89 e5                	mov    %esp,%ebp
    a7a1:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    a7a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    a7ab:	8b 45 08             	mov    0x8(%ebp),%eax
    a7ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a7b3:	80 cc 08             	or     $0x8,%ah
    a7b6:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    a7b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a7bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a7bf:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    a7c4:	0f 30                	wrmsr  
}
    a7c6:	90                   	nop
    a7c7:	c9                   	leave  
    a7c8:	c3                   	ret    

0000a7c9 <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    a7c9:	55                   	push   %ebp
    a7ca:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    a7cc:	8b 15 08 20 01 00    	mov    0x12008,%edx
    a7d2:	8b 45 08             	mov    0x8(%ebp),%eax
    a7d5:	01 c0                	add    %eax,%eax
    a7d7:	01 d0                	add    %edx,%eax
    a7d9:	0f b7 00             	movzwl (%eax),%eax
    a7dc:	0f b7 c0             	movzwl %ax,%eax
}
    a7df:	5d                   	pop    %ebp
    a7e0:	c3                   	ret    

0000a7e1 <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    a7e1:	55                   	push   %ebp
    a7e2:	89 e5                	mov    %esp,%ebp
    a7e4:	83 ec 04             	sub    $0x4,%esp
    a7e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    a7ea:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    a7ee:	8b 15 08 20 01 00    	mov    0x12008,%edx
    a7f4:	8b 45 08             	mov    0x8(%ebp),%eax
    a7f7:	01 c0                	add    %eax,%eax
    a7f9:	01 c2                	add    %eax,%edx
    a7fb:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a7ff:	66 89 02             	mov    %ax,(%edx)
}
    a802:	90                   	nop
    a803:	c9                   	leave  
    a804:	c3                   	ret    

0000a805 <enable_local_apic>:

void enable_local_apic()
{
    a805:	55                   	push   %ebp
    a806:	89 e5                	mov    %esp,%ebp
    a808:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    a80b:	83 ec 08             	sub    $0x8,%esp
    a80e:	68 fb 03 00 00       	push   $0x3fb
    a813:	68 00 d0 00 00       	push   $0xd000
    a818:	e8 a7 f8 ff ff       	call   a0c4 <create_page_table>
    a81d:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    a820:	e8 55 ff ff ff       	call   a77a <get_apic_base>
    a825:	a3 08 20 01 00       	mov    %eax,0x12008

    set_apic_base(get_apic_base());
    a82a:	e8 4b ff ff ff       	call   a77a <get_apic_base>
    a82f:	83 ec 0c             	sub    $0xc,%esp
    a832:	50                   	push   %eax
    a833:	e8 66 ff ff ff       	call   a79e <set_apic_base>
    a838:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    a83b:	83 ec 0c             	sub    $0xc,%esp
    a83e:	68 f0 00 00 00       	push   $0xf0
    a843:	e8 81 ff ff ff       	call   a7c9 <cpu_ReadLocalAPICReg>
    a848:	83 c4 10             	add    $0x10,%esp
    a84b:	80 cc 01             	or     $0x1,%ah
    a84e:	0f b7 c0             	movzwl %ax,%eax
    a851:	83 ec 08             	sub    $0x8,%esp
    a854:	50                   	push   %eax
    a855:	68 f0 00 00 00       	push   $0xf0
    a85a:	e8 82 ff ff ff       	call   a7e1 <cpu_SetLocalAPICReg>
    a85f:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    a862:	83 ec 08             	sub    $0x8,%esp
    a865:	6a 02                	push   $0x2
    a867:	6a 20                	push   $0x20
    a869:	e8 73 ff ff ff       	call   a7e1 <cpu_SetLocalAPICReg>
    a86e:	83 c4 10             	add    $0x10,%esp
}
    a871:	90                   	nop
    a872:	c9                   	leave  
    a873:	c3                   	ret    

0000a874 <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    a874:	55                   	push   %ebp
    a875:	89 e5                	mov    %esp,%ebp
    a877:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    a87a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    a881:	eb 49                	jmp    a8cc <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    a883:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a886:	89 d0                	mov    %edx,%eax
    a888:	01 c0                	add    %eax,%eax
    a88a:	01 d0                	add    %edx,%eax
    a88c:	c1 e0 02             	shl    $0x2,%eax
    a88f:	05 20 20 01 00       	add    $0x12020,%eax
    a894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    a89a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a89d:	89 d0                	mov    %edx,%eax
    a89f:	01 c0                	add    %eax,%eax
    a8a1:	01 d0                	add    %edx,%eax
    a8a3:	c1 e0 02             	shl    $0x2,%eax
    a8a6:	05 28 20 01 00       	add    $0x12028,%eax
    a8ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    a8b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a8b4:	89 d0                	mov    %edx,%eax
    a8b6:	01 c0                	add    %eax,%eax
    a8b8:	01 d0                	add    %edx,%eax
    a8ba:	c1 e0 02             	shl    $0x2,%eax
    a8bd:	05 24 20 01 00       	add    $0x12024,%eax
    a8c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    a8c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    a8cc:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    a8d3:	7e ae                	jle    a883 <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    a8d5:	c7 05 20 e0 01 00 20 	movl   $0x12020,0x1e020
    a8dc:	20 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    a8df:	90                   	nop
    a8e0:	c9                   	leave  
    a8e1:	c3                   	ret    

0000a8e2 <kmalloc>:

void* kmalloc(uint32_t size)
{
    a8e2:	55                   	push   %ebp
    a8e3:	89 e5                	mov    %esp,%ebp
    a8e5:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    a8e8:	a1 20 e0 01 00       	mov    0x1e020,%eax
    a8ed:	8b 00                	mov    (%eax),%eax
    a8ef:	85 c0                	test   %eax,%eax
    a8f1:	75 36                	jne    a929 <kmalloc+0x47>
        _head_vmm_->address = KERNEL__VM_BASE;
    a8f3:	a1 20 e0 01 00       	mov    0x1e020,%eax
    a8f8:	ba 40 e0 01 00       	mov    $0x1e040,%edx
    a8fd:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    a8ff:	a1 20 e0 01 00       	mov    0x1e020,%eax
    a904:	8b 55 08             	mov    0x8(%ebp),%edx
    a907:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    a90a:	83 ec 04             	sub    $0x4,%esp
    a90d:	ff 75 08             	pushl  0x8(%ebp)
    a910:	6a 00                	push   $0x0
    a912:	68 40 e0 01 00       	push   $0x1e040
    a917:	e8 2d ea ff ff       	call   9349 <memset>
    a91c:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    a91f:	b8 40 e0 01 00       	mov    $0x1e040,%eax
    a924:	e9 7b 01 00 00       	jmp    aaa4 <kmalloc+0x1c2>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    a929:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    a930:	eb 04                	jmp    a936 <kmalloc+0x54>
        i++;
    a932:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    a936:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    a93d:	77 17                	ja     a956 <kmalloc+0x74>
    a93f:	8b 55 f0             	mov    -0x10(%ebp),%edx
    a942:	89 d0                	mov    %edx,%eax
    a944:	01 c0                	add    %eax,%eax
    a946:	01 d0                	add    %edx,%eax
    a948:	c1 e0 02             	shl    $0x2,%eax
    a94b:	05 20 20 01 00       	add    $0x12020,%eax
    a950:	8b 00                	mov    (%eax),%eax
    a952:	85 c0                	test   %eax,%eax
    a954:	75 dc                	jne    a932 <kmalloc+0x50>

    _new_item_ = &MM_BLOCK[i];
    a956:	8b 55 f0             	mov    -0x10(%ebp),%edx
    a959:	89 d0                	mov    %edx,%eax
    a95b:	01 c0                	add    %eax,%eax
    a95d:	01 d0                	add    %edx,%eax
    a95f:	c1 e0 02             	shl    $0x2,%eax
    a962:	05 20 20 01 00       	add    $0x12020,%eax
    a967:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    a96a:	a1 20 e0 01 00       	mov    0x1e020,%eax
    a96f:	8b 00                	mov    (%eax),%eax
    a971:	b9 40 e0 01 00       	mov    $0x1e040,%ecx
    a976:	8b 55 08             	mov    0x8(%ebp),%edx
    a979:	01 ca                	add    %ecx,%edx
    a97b:	39 d0                	cmp    %edx,%eax
    a97d:	74 47                	je     a9c6 <kmalloc+0xe4>
        _new_item_->address = KERNEL__VM_BASE;
    a97f:	ba 40 e0 01 00       	mov    $0x1e040,%edx
    a984:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a987:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    a989:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a98c:	8b 55 08             	mov    0x8(%ebp),%edx
    a98f:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    a992:	8b 15 20 e0 01 00    	mov    0x1e020,%edx
    a998:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a99b:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    a99e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a9a1:	a3 20 e0 01 00       	mov    %eax,0x1e020

        memset((void*)_new_item_->address, 0, size);
    a9a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a9a9:	8b 00                	mov    (%eax),%eax
    a9ab:	83 ec 04             	sub    $0x4,%esp
    a9ae:	ff 75 08             	pushl  0x8(%ebp)
    a9b1:	6a 00                	push   $0x0
    a9b3:	50                   	push   %eax
    a9b4:	e8 90 e9 ff ff       	call   9349 <memset>
    a9b9:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    a9bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a9bf:	8b 00                	mov    (%eax),%eax
    a9c1:	e9 de 00 00 00       	jmp    aaa4 <kmalloc+0x1c2>
    }

    tmp = _head_vmm_;
    a9c6:	a1 20 e0 01 00       	mov    0x1e020,%eax
    a9cb:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    a9ce:	eb 27                	jmp    a9f7 <kmalloc+0x115>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    a9d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9d3:	8b 40 08             	mov    0x8(%eax),%eax
    a9d6:	8b 10                	mov    (%eax),%edx
    a9d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9db:	8b 08                	mov    (%eax),%ecx
    a9dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9e0:	8b 40 04             	mov    0x4(%eax),%eax
    a9e3:	01 c1                	add    %eax,%ecx
    a9e5:	8b 45 08             	mov    0x8(%ebp),%eax
    a9e8:	01 c8                	add    %ecx,%eax
    a9ea:	39 c2                	cmp    %eax,%edx
    a9ec:	73 15                	jae    aa03 <kmalloc+0x121>
            break;

        tmp = tmp->next;
    a9ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9f1:	8b 40 08             	mov    0x8(%eax),%eax
    a9f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    a9f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    a9fa:	8b 40 08             	mov    0x8(%eax),%eax
    a9fd:	85 c0                	test   %eax,%eax
    a9ff:	75 cf                	jne    a9d0 <kmalloc+0xee>
    aa01:	eb 01                	jmp    aa04 <kmalloc+0x122>
            break;
    aa03:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    aa04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa07:	8b 40 08             	mov    0x8(%eax),%eax
    aa0a:	85 c0                	test   %eax,%eax
    aa0c:	75 4b                	jne    aa59 <kmalloc+0x177>
        _new_item_->size = size;
    aa0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa11:	8b 55 08             	mov    0x8(%ebp),%edx
    aa14:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    aa17:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa1a:	8b 10                	mov    (%eax),%edx
    aa1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa1f:	8b 40 04             	mov    0x4(%eax),%eax
    aa22:	01 c2                	add    %eax,%edx
    aa24:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa27:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    aa29:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    aa33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa36:	8b 55 ec             	mov    -0x14(%ebp),%edx
    aa39:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    aa3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa3f:	8b 00                	mov    (%eax),%eax
    aa41:	83 ec 04             	sub    $0x4,%esp
    aa44:	ff 75 08             	pushl  0x8(%ebp)
    aa47:	6a 00                	push   $0x0
    aa49:	50                   	push   %eax
    aa4a:	e8 fa e8 ff ff       	call   9349 <memset>
    aa4f:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    aa52:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa55:	8b 00                	mov    (%eax),%eax
    aa57:	eb 4b                	jmp    aaa4 <kmalloc+0x1c2>
    }

    else {
        _new_item_->size = size;
    aa59:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa5c:	8b 55 08             	mov    0x8(%ebp),%edx
    aa5f:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    aa62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa65:	8b 10                	mov    (%eax),%edx
    aa67:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa6a:	8b 40 04             	mov    0x4(%eax),%eax
    aa6d:	01 c2                	add    %eax,%edx
    aa6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa72:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    aa74:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa77:	8b 50 08             	mov    0x8(%eax),%edx
    aa7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa7d:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    aa80:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aa83:	8b 55 ec             	mov    -0x14(%ebp),%edx
    aa86:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    aa89:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aa8c:	8b 00                	mov    (%eax),%eax
    aa8e:	83 ec 04             	sub    $0x4,%esp
    aa91:	ff 75 08             	pushl  0x8(%ebp)
    aa94:	6a 00                	push   $0x0
    aa96:	50                   	push   %eax
    aa97:	e8 ad e8 ff ff       	call   9349 <memset>
    aa9c:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    aa9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aaa2:	8b 00                	mov    (%eax),%eax
    }
}
    aaa4:	c9                   	leave  
    aaa5:	c3                   	ret    

0000aaa6 <free>:

void free(virtaddr_t _addr__)
{
    aaa6:	55                   	push   %ebp
    aaa7:	89 e5                	mov    %esp,%ebp
    aaa9:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    aaac:	a1 20 e0 01 00       	mov    0x1e020,%eax
    aab1:	8b 00                	mov    (%eax),%eax
    aab3:	39 45 08             	cmp    %eax,0x8(%ebp)
    aab6:	75 29                	jne    aae1 <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    aab8:	a1 20 e0 01 00       	mov    0x1e020,%eax
    aabd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    aac3:	a1 20 e0 01 00       	mov    0x1e020,%eax
    aac8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    aacf:	a1 20 e0 01 00       	mov    0x1e020,%eax
    aad4:	8b 40 08             	mov    0x8(%eax),%eax
    aad7:	a3 20 e0 01 00       	mov    %eax,0x1e020
        return;
    aadc:	e9 ac 00 00 00       	jmp    ab8d <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    aae1:	a1 20 e0 01 00       	mov    0x1e020,%eax
    aae6:	8b 40 08             	mov    0x8(%eax),%eax
    aae9:	85 c0                	test   %eax,%eax
    aaeb:	75 16                	jne    ab03 <free+0x5d>
    aaed:	a1 20 e0 01 00       	mov    0x1e020,%eax
    aaf2:	8b 00                	mov    (%eax),%eax
    aaf4:	39 45 08             	cmp    %eax,0x8(%ebp)
    aaf7:	75 0a                	jne    ab03 <free+0x5d>
        init_vmm();
    aaf9:	e8 76 fd ff ff       	call   a874 <init_vmm>
        return;
    aafe:	e9 8a 00 00 00       	jmp    ab8d <free+0xe7>
    }

    tmp = _head_vmm_;
    ab03:	a1 20 e0 01 00       	mov    0x1e020,%eax
    ab08:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ab0b:	eb 0f                	jmp    ab1c <free+0x76>
        tmp_prev = tmp;
    ab0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab10:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    ab13:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab16:	8b 40 08             	mov    0x8(%eax),%eax
    ab19:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ab1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab1f:	8b 40 08             	mov    0x8(%eax),%eax
    ab22:	85 c0                	test   %eax,%eax
    ab24:	74 0a                	je     ab30 <free+0x8a>
    ab26:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab29:	8b 00                	mov    (%eax),%eax
    ab2b:	39 45 08             	cmp    %eax,0x8(%ebp)
    ab2e:	75 dd                	jne    ab0d <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ab30:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab33:	8b 40 08             	mov    0x8(%eax),%eax
    ab36:	85 c0                	test   %eax,%eax
    ab38:	75 29                	jne    ab63 <free+0xbd>
    ab3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab3d:	8b 00                	mov    (%eax),%eax
    ab3f:	39 45 08             	cmp    %eax,0x8(%ebp)
    ab42:	75 1f                	jne    ab63 <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ab44:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ab4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ab57:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ab5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ab61:	eb 2a                	jmp    ab8d <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ab63:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab66:	8b 00                	mov    (%eax),%eax
    ab68:	39 45 08             	cmp    %eax,0x8(%ebp)
    ab6b:	75 20                	jne    ab8d <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ab6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ab76:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ab80:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ab83:	8b 50 08             	mov    0x8(%eax),%edx
    ab86:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ab89:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ab8c:	90                   	nop
    }
    ab8d:	c9                   	leave  
    ab8e:	c3                   	ret    

0000ab8f <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ab8f:	55                   	push   %ebp
    ab90:	89 e5                	mov    %esp,%ebp
    ab92:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ab95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    ab9c:	eb 49                	jmp    abe7 <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ab9e:	ba 7d f0 00 00       	mov    $0xf07d,%edx
    aba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    aba6:	c1 e0 04             	shl    $0x4,%eax
    aba9:	05 20 f0 01 00       	add    $0x1f020,%eax
    abae:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    abb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abb3:	c1 e0 04             	shl    $0x4,%eax
    abb6:	05 24 f0 01 00       	add    $0x1f024,%eax
    abbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    abc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abc4:	c1 e0 04             	shl    $0x4,%eax
    abc7:	05 2c f0 01 00       	add    $0x1f02c,%eax
    abcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    abd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abd5:	c1 e0 04             	shl    $0x4,%eax
    abd8:	05 28 f0 01 00       	add    $0x1f028,%eax
    abdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    abe3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    abe7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    abee:	76 ae                	jbe    ab9e <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    abf0:	83 ec 08             	sub    $0x8,%esp
    abf3:	6a 01                	push   $0x1
    abf5:	68 00 e0 00 00       	push   $0xe000
    abfa:	e8 c5 f4 ff ff       	call   a0c4 <create_page_table>
    abff:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    ac02:	c7 05 00 f0 01 00 20 	movl   $0x1f020,0x1f000
    ac09:	f0 01 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    ac0c:	90                   	nop
    ac0d:	c9                   	leave  
    ac0e:	c3                   	ret    

0000ac0f <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    ac0f:	55                   	push   %ebp
    ac10:	89 e5                	mov    %esp,%ebp
    ac12:	53                   	push   %ebx
    ac13:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    ac16:	a1 00 f0 01 00       	mov    0x1f000,%eax
    ac1b:	8b 00                	mov    (%eax),%eax
    ac1d:	ba 7d f0 00 00       	mov    $0xf07d,%edx
    ac22:	39 d0                	cmp    %edx,%eax
    ac24:	75 40                	jne    ac66 <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    ac26:	a1 00 f0 01 00       	mov    0x1f000,%eax
    ac2b:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    ac31:	a1 00 f0 01 00       	mov    0x1f000,%eax
    ac36:	8b 55 08             	mov    0x8(%ebp),%edx
    ac39:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    ac3c:	8b 45 08             	mov    0x8(%ebp),%eax
    ac3f:	c1 e0 0c             	shl    $0xc,%eax
    ac42:	89 c2                	mov    %eax,%edx
    ac44:	a1 00 f0 01 00       	mov    0x1f000,%eax
    ac49:	8b 00                	mov    (%eax),%eax
    ac4b:	83 ec 04             	sub    $0x4,%esp
    ac4e:	52                   	push   %edx
    ac4f:	6a 00                	push   $0x0
    ac51:	50                   	push   %eax
    ac52:	e8 f2 e6 ff ff       	call   9349 <memset>
    ac57:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    ac5a:	a1 00 f0 01 00       	mov    0x1f000,%eax
    ac5f:	8b 00                	mov    (%eax),%eax
    ac61:	e9 ae 01 00 00       	jmp    ae14 <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    ac66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ac6d:	eb 04                	jmp    ac73 <alloc_page+0x64>
        i++;
    ac6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ac73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac76:	c1 e0 04             	shl    $0x4,%eax
    ac79:	05 20 f0 01 00       	add    $0x1f020,%eax
    ac7e:	8b 00                	mov    (%eax),%eax
    ac80:	ba 7d f0 00 00       	mov    $0xf07d,%edx
    ac85:	39 d0                	cmp    %edx,%eax
    ac87:	74 09                	je     ac92 <alloc_page+0x83>
    ac89:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    ac90:	76 dd                	jbe    ac6f <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    ac92:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac95:	c1 e0 04             	shl    $0x4,%eax
    ac98:	05 20 f0 01 00       	add    $0x1f020,%eax
    ac9d:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    aca0:	a1 00 f0 01 00       	mov    0x1f000,%eax
    aca5:	8b 00                	mov    (%eax),%eax
    aca7:	8b 55 08             	mov    0x8(%ebp),%edx
    acaa:	81 c2 00 01 00 00    	add    $0x100,%edx
    acb0:	c1 e2 0c             	shl    $0xc,%edx
    acb3:	39 d0                	cmp    %edx,%eax
    acb5:	72 4c                	jb     ad03 <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    acb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acba:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    acc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acc3:	8b 55 08             	mov    0x8(%ebp),%edx
    acc6:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    acc9:	8b 15 00 f0 01 00    	mov    0x1f000,%edx
    accf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acd2:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    acd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acd8:	a3 00 f0 01 00       	mov    %eax,0x1f000

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    acdd:	8b 45 08             	mov    0x8(%ebp),%eax
    ace0:	c1 e0 0c             	shl    $0xc,%eax
    ace3:	89 c2                	mov    %eax,%edx
    ace5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ace8:	8b 00                	mov    (%eax),%eax
    acea:	83 ec 04             	sub    $0x4,%esp
    aced:	52                   	push   %edx
    acee:	6a 00                	push   $0x0
    acf0:	50                   	push   %eax
    acf1:	e8 53 e6 ff ff       	call   9349 <memset>
    acf6:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    acf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    acfc:	8b 00                	mov    (%eax),%eax
    acfe:	e9 11 01 00 00       	jmp    ae14 <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    ad03:	a1 00 f0 01 00       	mov    0x1f000,%eax
    ad08:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    ad0b:	eb 2a                	jmp    ad37 <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    ad0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad10:	8b 40 0c             	mov    0xc(%eax),%eax
    ad13:	8b 10                	mov    (%eax),%edx
    ad15:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad18:	8b 08                	mov    (%eax),%ecx
    ad1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad1d:	8b 58 04             	mov    0x4(%eax),%ebx
    ad20:	8b 45 08             	mov    0x8(%ebp),%eax
    ad23:	01 d8                	add    %ebx,%eax
    ad25:	c1 e0 0c             	shl    $0xc,%eax
    ad28:	01 c8                	add    %ecx,%eax
    ad2a:	39 c2                	cmp    %eax,%edx
    ad2c:	77 15                	ja     ad43 <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    ad2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad31:	8b 40 0c             	mov    0xc(%eax),%eax
    ad34:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    ad37:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad3a:	8b 40 0c             	mov    0xc(%eax),%eax
    ad3d:	85 c0                	test   %eax,%eax
    ad3f:	75 cc                	jne    ad0d <alloc_page+0xfe>
    ad41:	eb 01                	jmp    ad44 <alloc_page+0x135>
            break;
    ad43:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    ad44:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad47:	8b 40 0c             	mov    0xc(%eax),%eax
    ad4a:	85 c0                	test   %eax,%eax
    ad4c:	75 5d                	jne    adab <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    ad4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad51:	8b 10                	mov    (%eax),%edx
    ad53:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad56:	8b 40 04             	mov    0x4(%eax),%eax
    ad59:	c1 e0 0c             	shl    $0xc,%eax
    ad5c:	01 c2                	add    %eax,%edx
    ad5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad61:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    ad63:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad66:	8b 55 08             	mov    0x8(%ebp),%edx
    ad69:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    ad6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    ad76:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad79:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ad7c:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    ad7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ad82:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ad85:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    ad88:	8b 45 08             	mov    0x8(%ebp),%eax
    ad8b:	c1 e0 0c             	shl    $0xc,%eax
    ad8e:	89 c2                	mov    %eax,%edx
    ad90:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ad93:	8b 00                	mov    (%eax),%eax
    ad95:	83 ec 04             	sub    $0x4,%esp
    ad98:	52                   	push   %edx
    ad99:	6a 00                	push   $0x0
    ad9b:	50                   	push   %eax
    ad9c:	e8 a8 e5 ff ff       	call   9349 <memset>
    ada1:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    ada4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ada7:	8b 00                	mov    (%eax),%eax
    ada9:	eb 69                	jmp    ae14 <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    adab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    adae:	8b 10                	mov    (%eax),%edx
    adb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    adb3:	8b 40 04             	mov    0x4(%eax),%eax
    adb6:	c1 e0 0c             	shl    $0xc,%eax
    adb9:	01 c2                	add    %eax,%edx
    adbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    adbe:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    adc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    adc3:	8b 55 08             	mov    0x8(%ebp),%edx
    adc6:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    adc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    adcc:	8b 50 0c             	mov    0xc(%eax),%edx
    adcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    add2:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    add5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    add8:	8b 55 f0             	mov    -0x10(%ebp),%edx
    addb:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    adde:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ade1:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ade4:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    ade7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    adea:	8b 40 0c             	mov    0xc(%eax),%eax
    aded:	8b 55 ec             	mov    -0x14(%ebp),%edx
    adf0:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    adf3:	8b 45 08             	mov    0x8(%ebp),%eax
    adf6:	c1 e0 0c             	shl    $0xc,%eax
    adf9:	89 c2                	mov    %eax,%edx
    adfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    adfe:	8b 00                	mov    (%eax),%eax
    ae00:	83 ec 04             	sub    $0x4,%esp
    ae03:	52                   	push   %edx
    ae04:	6a 00                	push   $0x0
    ae06:	50                   	push   %eax
    ae07:	e8 3d e5 ff ff       	call   9349 <memset>
    ae0c:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    ae0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ae12:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    ae14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    ae17:	c9                   	leave  
    ae18:	c3                   	ret    

0000ae19 <free_page>:

void free_page(_address_order_track_ page)
{
    ae19:	55                   	push   %ebp
    ae1a:	89 e5                	mov    %esp,%ebp
    ae1c:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    ae1f:	8b 45 10             	mov    0x10(%ebp),%eax
    ae22:	85 c0                	test   %eax,%eax
    ae24:	75 2d                	jne    ae53 <free_page+0x3a>
    ae26:	8b 45 14             	mov    0x14(%ebp),%eax
    ae29:	85 c0                	test   %eax,%eax
    ae2b:	74 26                	je     ae53 <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    ae2d:	b8 7d f0 00 00       	mov    $0xf07d,%eax
    ae32:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    ae35:	a1 00 f0 01 00       	mov    0x1f000,%eax
    ae3a:	8b 40 0c             	mov    0xc(%eax),%eax
    ae3d:	a3 00 f0 01 00       	mov    %eax,0x1f000
        _page_area_track_->previous_ = END_LIST;
    ae42:	a1 00 f0 01 00       	mov    0x1f000,%eax
    ae47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ae4e:	e9 13 01 00 00       	jmp    af66 <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    ae53:	8b 45 10             	mov    0x10(%ebp),%eax
    ae56:	85 c0                	test   %eax,%eax
    ae58:	75 67                	jne    aec1 <free_page+0xa8>
    ae5a:	8b 45 14             	mov    0x14(%ebp),%eax
    ae5d:	85 c0                	test   %eax,%eax
    ae5f:	75 60                	jne    aec1 <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    ae61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    ae68:	eb 49                	jmp    aeb3 <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ae6a:	ba 7d f0 00 00       	mov    $0xf07d,%edx
    ae6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae72:	c1 e0 04             	shl    $0x4,%eax
    ae75:	05 20 f0 01 00       	add    $0x1f020,%eax
    ae7a:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    ae7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae7f:	c1 e0 04             	shl    $0x4,%eax
    ae82:	05 24 f0 01 00       	add    $0x1f024,%eax
    ae87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    ae8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ae90:	c1 e0 04             	shl    $0x4,%eax
    ae93:	05 2c f0 01 00       	add    $0x1f02c,%eax
    ae98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    ae9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    aea1:	c1 e0 04             	shl    $0x4,%eax
    aea4:	05 28 f0 01 00       	add    $0x1f028,%eax
    aea9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    aeaf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    aeb3:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    aeba:	76 ae                	jbe    ae6a <free_page+0x51>
        }
        return;
    aebc:	e9 a5 00 00 00       	jmp    af66 <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    aec1:	a1 00 f0 01 00       	mov    0x1f000,%eax
    aec6:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    aec9:	eb 09                	jmp    aed4 <free_page+0xbb>
            tmp = tmp->next_;
    aecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aece:	8b 40 0c             	mov    0xc(%eax),%eax
    aed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    aed4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aed7:	8b 10                	mov    (%eax),%edx
    aed9:	8b 45 08             	mov    0x8(%ebp),%eax
    aedc:	39 c2                	cmp    %eax,%edx
    aede:	74 0a                	je     aeea <free_page+0xd1>
    aee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aee3:	8b 40 0c             	mov    0xc(%eax),%eax
    aee6:	85 c0                	test   %eax,%eax
    aee8:	75 e1                	jne    aecb <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    aeea:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aeed:	8b 40 0c             	mov    0xc(%eax),%eax
    aef0:	85 c0                	test   %eax,%eax
    aef2:	75 25                	jne    af19 <free_page+0x100>
    aef4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    aef7:	8b 10                	mov    (%eax),%edx
    aef9:	8b 45 08             	mov    0x8(%ebp),%eax
    aefc:	39 c2                	cmp    %eax,%edx
    aefe:	75 19                	jne    af19 <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    af00:	ba 7d f0 00 00       	mov    $0xf07d,%edx
    af05:	8b 45 f8             	mov    -0x8(%ebp),%eax
    af08:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    af0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    af0d:	8b 40 08             	mov    0x8(%eax),%eax
    af10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    af17:	eb 4d                	jmp    af66 <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    af19:	8b 45 f8             	mov    -0x8(%ebp),%eax
    af1c:	8b 40 0c             	mov    0xc(%eax),%eax
    af1f:	85 c0                	test   %eax,%eax
    af21:	74 36                	je     af59 <free_page+0x140>
    af23:	8b 45 f8             	mov    -0x8(%ebp),%eax
    af26:	8b 10                	mov    (%eax),%edx
    af28:	8b 45 08             	mov    0x8(%ebp),%eax
    af2b:	39 c2                	cmp    %eax,%edx
    af2d:	75 2a                	jne    af59 <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    af2f:	ba 7d f0 00 00       	mov    $0xf07d,%edx
    af34:	8b 45 f8             	mov    -0x8(%ebp),%eax
    af37:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    af39:	8b 45 f8             	mov    -0x8(%ebp),%eax
    af3c:	8b 40 08             	mov    0x8(%eax),%eax
    af3f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    af42:	8b 52 0c             	mov    0xc(%edx),%edx
    af45:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    af48:	8b 45 f8             	mov    -0x8(%ebp),%eax
    af4b:	8b 40 0c             	mov    0xc(%eax),%eax
    af4e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    af51:	8b 52 08             	mov    0x8(%edx),%edx
    af54:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    af57:	eb 0d                	jmp    af66 <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    af59:	a1 04 f0 01 00       	mov    0x1f004,%eax
    af5e:	83 e8 01             	sub    $0x1,%eax
    af61:	a3 04 f0 01 00       	mov    %eax,0x1f004
    af66:	c9                   	leave  
    af67:	c3                   	ret    

0000af68 <__switch>:
sheduler_t sheduler;

static task_control_block_t main_task, task1, task2, task3;

void __switch()
{
    af68:	55                   	push   %ebp
    af69:	89 e5                	mov    %esp,%ebp
    af6b:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    af6e:	a1 28 30 02 00       	mov    0x23028,%eax
    af73:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    af76:	a1 28 30 02 00       	mov    0x23028,%eax
    af7b:	8b 40 3c             	mov    0x3c(%eax),%eax
    af7e:	a3 28 30 02 00       	mov    %eax,0x23028

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    af83:	a1 28 30 02 00       	mov    0x23028,%eax
    af88:	89 c2                	mov    %eax,%edx
    af8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    af8d:	83 ec 08             	sub    $0x8,%esp
    af90:	52                   	push   %edx
    af91:	50                   	push   %eax
    af92:	e8 c9 02 00 00       	call   b260 <switch_to_task>
    af97:	83 c4 10             	add    $0x10,%esp
}
    af9a:	90                   	nop
    af9b:	c9                   	leave  
    af9c:	c3                   	ret    

0000af9d <init_multitasking>:

void init_multitasking()
{
    af9d:	55                   	push   %ebp
    af9e:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    afa0:	c6 05 20 30 02 00 00 	movb   $0x0,0x23020
    sheduler.task_timer = DELAY_PER_TASK;
    afa7:	c7 05 24 30 02 00 2c 	movl   $0x12c,0x23024
    afae:	01 00 00 
}
    afb1:	90                   	nop
    afb2:	5d                   	pop    %ebp
    afb3:	c3                   	ret    

0000afb4 <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    afb4:	55                   	push   %ebp
    afb5:	89 e5                	mov    %esp,%ebp
    afb7:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    afba:	8b 45 08             	mov    0x8(%ebp),%eax
    afbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    afc3:	8b 45 08             	mov    0x8(%ebp),%eax
    afc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    afcd:	8b 45 08             	mov    0x8(%ebp),%eax
    afd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    afd7:	8b 45 08             	mov    0x8(%ebp),%eax
    afda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    afe1:	8b 45 08             	mov    0x8(%ebp),%eax
    afe4:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    afeb:	8b 45 08             	mov    0x8(%ebp),%eax
    afee:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    aff5:	8b 45 08             	mov    0x8(%ebp),%eax
    aff8:	8b 55 10             	mov    0x10(%ebp),%edx
    affb:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip    = (uint32_t)task_func;
    affe:	8b 55 0c             	mov    0xc(%ebp),%edx
    b001:	8b 45 08             	mov    0x8(%ebp),%eax
    b004:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3    = (uint32_t)cr3;
    b007:	8b 45 08             	mov    0x8(%ebp),%eax
    b00a:	8b 55 14             	mov    0x14(%ebp),%edx
    b00d:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp    = (uint32_t)kmalloc(200);
    b010:	83 ec 0c             	sub    $0xc,%esp
    b013:	68 c8 00 00 00       	push   $0xc8
    b018:	e8 c5 f8 ff ff       	call   a8e2 <kmalloc>
    b01d:	83 c4 10             	add    $0x10,%esp
    b020:	89 c2                	mov    %eax,%edx
    b022:	8b 45 08             	mov    0x8(%ebp),%eax
    b025:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks   = 0;
    b028:	8b 45 08             	mov    0x8(%ebp),%eax
    b02b:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b032:	90                   	nop
    b033:	c9                   	leave  
    b034:	c3                   	ret    
    b035:	66 90                	xchg   %ax,%ax
    b037:	66 90                	xchg   %ax,%ax
    b039:	66 90                	xchg   %ax,%ax
    b03b:	66 90                	xchg   %ax,%ax
    b03d:	66 90                	xchg   %ax,%ax
    b03f:	90                   	nop

0000b040 <__exception_handler__>:
    b040:	58                   	pop    %eax
    b041:	a3 64 b4 00 00       	mov    %eax,0xb464
    b046:	e8 01 e6 ff ff       	call   964c <__exception__>
    b04b:	cf                   	iret   

0000b04c <__exception_no_ERRCODE_handler__>:
    b04c:	e8 01 e6 ff ff       	call   9652 <__exception_no_ERRCODE__>
    b051:	cf                   	iret   
    b052:	66 90                	xchg   %ax,%ax
    b054:	66 90                	xchg   %ax,%ax
    b056:	66 90                	xchg   %ax,%ax
    b058:	66 90                	xchg   %ax,%ax
    b05a:	66 90                	xchg   %ax,%ax
    b05c:	66 90                	xchg   %ax,%ax
    b05e:	66 90                	xchg   %ax,%ax

0000b060 <gdtr>:
    b060:	00 00                	add    %al,(%eax)
    b062:	00 00                	add    %al,(%eax)
	...

0000b066 <load_gdt>:
    b066:	fa                   	cli    
    b067:	50                   	push   %eax
    b068:	51                   	push   %ecx
    b069:	b9 00 00 00 00       	mov    $0x0,%ecx
    b06e:	89 0d 62 b0 00 00    	mov    %ecx,0xb062
    b074:	31 c0                	xor    %eax,%eax
    b076:	b8 00 01 00 00       	mov    $0x100,%eax
    b07b:	01 c8                	add    %ecx,%eax
    b07d:	66 a3 60 b0 00 00    	mov    %ax,0xb060
    b083:	0f 01 15 60 b0 00 00 	lgdtl  0xb060
    b08a:	8b 0d 62 b0 00 00    	mov    0xb062,%ecx
    b090:	83 c1 20             	add    $0x20,%ecx
    b093:	0f 00 d9             	ltr    %cx
    b096:	59                   	pop    %ecx
    b097:	58                   	pop    %eax
    b098:	c3                   	ret    

0000b099 <idtr>:
    b099:	00 00                	add    %al,(%eax)
    b09b:	00 00                	add    %al,(%eax)
	...

0000b09f <load_idt>:
    b09f:	fa                   	cli    
    b0a0:	50                   	push   %eax
    b0a1:	51                   	push   %ecx
    b0a2:	31 c9                	xor    %ecx,%ecx
    b0a4:	b9 20 00 01 00       	mov    $0x10020,%ecx
    b0a9:	89 0d 9b b0 00 00    	mov    %ecx,0xb09b
    b0af:	31 c0                	xor    %eax,%eax
    b0b1:	b8 00 04 00 00       	mov    $0x400,%eax
    b0b6:	01 c8                	add    %ecx,%eax
    b0b8:	66 a3 99 b0 00 00    	mov    %ax,0xb099
    b0be:	0f 01 1d 99 b0 00 00 	lidtl  0xb099
    b0c5:	59                   	pop    %ecx
    b0c6:	58                   	pop    %eax
    b0c7:	c3                   	ret    
    b0c8:	66 90                	xchg   %ax,%ax
    b0ca:	66 90                	xchg   %ax,%ax
    b0cc:	66 90                	xchg   %ax,%ax
    b0ce:	66 90                	xchg   %ax,%ax

0000b0d0 <irq1>:
    b0d0:	60                   	pusha  
    b0d1:	e8 14 ec ff ff       	call   9cea <irq1_handler>
    b0d6:	61                   	popa   
    b0d7:	cf                   	iret   

0000b0d8 <irq2>:
    b0d8:	60                   	pusha  
    b0d9:	e8 27 ec ff ff       	call   9d05 <irq2_handler>
    b0de:	61                   	popa   
    b0df:	cf                   	iret   

0000b0e0 <irq3>:
    b0e0:	60                   	pusha  
    b0e1:	e8 42 ec ff ff       	call   9d28 <irq3_handler>
    b0e6:	61                   	popa   
    b0e7:	cf                   	iret   

0000b0e8 <irq4>:
    b0e8:	60                   	pusha  
    b0e9:	e8 5d ec ff ff       	call   9d4b <irq4_handler>
    b0ee:	61                   	popa   
    b0ef:	cf                   	iret   

0000b0f0 <irq5>:
    b0f0:	60                   	pusha  
    b0f1:	e8 78 ec ff ff       	call   9d6e <irq5_handler>
    b0f6:	61                   	popa   
    b0f7:	cf                   	iret   

0000b0f8 <irq6>:
    b0f8:	60                   	pusha  
    b0f9:	e8 93 ec ff ff       	call   9d91 <irq6_handler>
    b0fe:	61                   	popa   
    b0ff:	cf                   	iret   

0000b100 <irq7>:
    b100:	60                   	pusha  
    b101:	e8 ae ec ff ff       	call   9db4 <irq7_handler>
    b106:	61                   	popa   
    b107:	cf                   	iret   

0000b108 <irq8>:
    b108:	60                   	pusha  
    b109:	e8 c9 ec ff ff       	call   9dd7 <irq8_handler>
    b10e:	61                   	popa   
    b10f:	cf                   	iret   

0000b110 <irq9>:
    b110:	60                   	pusha  
    b111:	e8 e4 ec ff ff       	call   9dfa <irq9_handler>
    b116:	61                   	popa   
    b117:	cf                   	iret   

0000b118 <irq10>:
    b118:	60                   	pusha  
    b119:	e8 ff ec ff ff       	call   9e1d <irq10_handler>
    b11e:	61                   	popa   
    b11f:	cf                   	iret   

0000b120 <irq11>:
    b120:	60                   	pusha  
    b121:	e8 1a ed ff ff       	call   9e40 <irq11_handler>
    b126:	61                   	popa   
    b127:	cf                   	iret   

0000b128 <irq12>:
    b128:	60                   	pusha  
    b129:	e8 35 ed ff ff       	call   9e63 <irq12_handler>
    b12e:	61                   	popa   
    b12f:	cf                   	iret   

0000b130 <irq13>:
    b130:	60                   	pusha  
    b131:	e8 50 ed ff ff       	call   9e86 <irq13_handler>
    b136:	61                   	popa   
    b137:	cf                   	iret   

0000b138 <irq14>:
    b138:	60                   	pusha  
    b139:	e8 6b ed ff ff       	call   9ea9 <irq14_handler>
    b13e:	61                   	popa   
    b13f:	cf                   	iret   

0000b140 <irq15>:
    b140:	60                   	pusha  
    b141:	e8 86 ed ff ff       	call   9ecc <irq15_handler>
    b146:	61                   	popa   
    b147:	cf                   	iret   
    b148:	66 90                	xchg   %ax,%ax
    b14a:	66 90                	xchg   %ax,%ax
    b14c:	66 90                	xchg   %ax,%ax
    b14e:	66 90                	xchg   %ax,%ax

0000b150 <_FlushPagingCache_>:
    b150:	b8 00 10 01 00       	mov    $0x11000,%eax
    b155:	0f 22 d8             	mov    %eax,%cr3
    b158:	c3                   	ret    

0000b159 <_EnablingPaging_>:
    b159:	e8 f2 ff ff ff       	call   b150 <_FlushPagingCache_>
    b15e:	0f 20 c0             	mov    %cr0,%eax
    b161:	0d 01 00 00 80       	or     $0x80000001,%eax
    b166:	0f 22 c0             	mov    %eax,%cr0
    b169:	c3                   	ret    

0000b16a <PagingFault_Handler>:
    b16a:	58                   	pop    %eax
    b16b:	a3 68 b4 00 00       	mov    %eax,0xb468
    b170:	e8 2d f1 ff ff       	call   a2a2 <Paging_fault>
    b175:	cf                   	iret   
    b176:	66 90                	xchg   %ax,%ax
    b178:	66 90                	xchg   %ax,%ax
    b17a:	66 90                	xchg   %ax,%ax
    b17c:	66 90                	xchg   %ax,%ax
    b17e:	66 90                	xchg   %ax,%ax

0000b180 <PIT_handler>:
    b180:	9c                   	pushf  
    b181:	e8 16 00 00 00       	call   b19c <irq_PIT>
    b186:	e8 5d f3 ff ff       	call   a4e8 <conserv_status_byte>
    b18b:	e8 f0 f3 ff ff       	call   a580 <sheduler_cpu_timer>
    b190:	90                   	nop
    b191:	90                   	nop
    b192:	90                   	nop
    b193:	90                   	nop
    b194:	90                   	nop
    b195:	90                   	nop
    b196:	90                   	nop
    b197:	90                   	nop
    b198:	90                   	nop
    b199:	90                   	nop
    b19a:	9d                   	popf   
    b19b:	cf                   	iret   

0000b19c <irq_PIT>:
    b19c:	a1 48 31 02 00       	mov    0x23148,%eax
    b1a1:	8b 1d 4c 31 02 00    	mov    0x2314c,%ebx
    b1a7:	01 05 40 31 02 00    	add    %eax,0x23140
    b1ad:	11 1d 44 31 02 00    	adc    %ebx,0x23144
    b1b3:	6a 00                	push   $0x0
    b1b5:	e8 ee f0 ff ff       	call   a2a8 <PIC_sendEOI>
    b1ba:	58                   	pop    %eax
    b1bb:	c3                   	ret    

0000b1bc <calculate_frequency>:
    b1bc:	60                   	pusha  
    b1bd:	8b 1d 04 20 01 00    	mov    0x12004,%ebx
    b1c3:	b8 00 00 01 00       	mov    $0x10000,%eax
    b1c8:	83 fb 12             	cmp    $0x12,%ebx
    b1cb:	76 34                	jbe    b201 <calculate_frequency.gotReloadValue>
    b1cd:	b8 01 00 00 00       	mov    $0x1,%eax
    b1d2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    b1d8:	73 27                	jae    b201 <calculate_frequency.gotReloadValue>
    b1da:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b1df:	ba 00 00 00 00       	mov    $0x0,%edx
    b1e4:	f7 f3                	div    %ebx
    b1e6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b1ec:	72 01                	jb     b1ef <calculate_frequency.l1>
    b1ee:	40                   	inc    %eax

0000b1ef <calculate_frequency.l1>:
    b1ef:	bb 03 00 00 00       	mov    $0x3,%ebx
    b1f4:	ba 00 00 00 00       	mov    $0x0,%edx
    b1f9:	f7 f3                	div    %ebx
    b1fb:	83 fa 01             	cmp    $0x1,%edx
    b1fe:	72 01                	jb     b201 <calculate_frequency.gotReloadValue>
    b200:	40                   	inc    %eax

0000b201 <calculate_frequency.gotReloadValue>:
    b201:	50                   	push   %eax
    b202:	66 a3 54 31 02 00    	mov    %ax,0x23154
    b208:	89 c3                	mov    %eax,%ebx
    b20a:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b20f:	ba 00 00 00 00       	mov    $0x0,%edx
    b214:	f7 f3                	div    %ebx
    b216:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b21c:	72 01                	jb     b21f <calculate_frequency.l3>
    b21e:	40                   	inc    %eax

0000b21f <calculate_frequency.l3>:
    b21f:	bb 03 00 00 00       	mov    $0x3,%ebx
    b224:	ba 00 00 00 00       	mov    $0x0,%edx
    b229:	f7 f3                	div    %ebx
    b22b:	83 fa 01             	cmp    $0x1,%edx
    b22e:	72 01                	jb     b231 <calculate_frequency.l4>
    b230:	40                   	inc    %eax

0000b231 <calculate_frequency.l4>:
    b231:	a3 50 31 02 00       	mov    %eax,0x23150
    b236:	5b                   	pop    %ebx
    b237:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    b23c:	f7 e3                	mul    %ebx
    b23e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    b242:	c1 ea 0a             	shr    $0xa,%edx
    b245:	89 15 4c 31 02 00    	mov    %edx,0x2314c
    b24b:	a3 48 31 02 00       	mov    %eax,0x23148
    b250:	61                   	popa   
    b251:	c3                   	ret    
    b252:	66 90                	xchg   %ax,%ax
    b254:	66 90                	xchg   %ax,%ax
    b256:	66 90                	xchg   %ax,%ax
    b258:	66 90                	xchg   %ax,%ax
    b25a:	66 90                	xchg   %ax,%ax
    b25c:	66 90                	xchg   %ax,%ax
    b25e:	66 90                	xchg   %ax,%ax

0000b260 <switch_to_task>:
    b260:	50                   	push   %eax
    b261:	8b 44 24 08          	mov    0x8(%esp),%eax
    b265:	89 58 04             	mov    %ebx,0x4(%eax)
    b268:	89 48 08             	mov    %ecx,0x8(%eax)
    b26b:	89 50 0c             	mov    %edx,0xc(%eax)
    b26e:	89 70 10             	mov    %esi,0x10(%eax)
    b271:	89 78 14             	mov    %edi,0x14(%eax)
    b274:	89 60 18             	mov    %esp,0x18(%eax)
    b277:	89 68 1c             	mov    %ebp,0x1c(%eax)
    b27a:	51                   	push   %ecx
    b27b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    b27f:	89 48 20             	mov    %ecx,0x20(%eax)
    b282:	59                   	pop    %ecx
    b283:	51                   	push   %ecx
    b284:	9c                   	pushf  
    b285:	59                   	pop    %ecx
    b286:	89 48 24             	mov    %ecx,0x24(%eax)
    b289:	59                   	pop    %ecx
    b28a:	51                   	push   %ecx
    b28b:	0f 20 d9             	mov    %cr3,%ecx
    b28e:	89 48 28             	mov    %ecx,0x28(%eax)
    b291:	59                   	pop    %ecx
    b292:	8c 40 2c             	mov    %es,0x2c(%eax)
    b295:	8c 68 2e             	mov    %gs,0x2e(%eax)
    b298:	8c 60 30             	mov    %fs,0x30(%eax)
    b29b:	51                   	push   %ecx
    b29c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    b2a0:	89 08                	mov    %ecx,(%eax)
    b2a2:	59                   	pop    %ecx
    b2a3:	58                   	pop    %eax
    b2a4:	8b 44 24 08          	mov    0x8(%esp),%eax
    b2a8:	8b 58 04             	mov    0x4(%eax),%ebx
    b2ab:	8b 48 08             	mov    0x8(%eax),%ecx
    b2ae:	8b 50 0c             	mov    0xc(%eax),%edx
    b2b1:	8b 70 10             	mov    0x10(%eax),%esi
    b2b4:	8b 78 14             	mov    0x14(%eax),%edi
    b2b7:	8b 60 18             	mov    0x18(%eax),%esp
    b2ba:	8b 68 1c             	mov    0x1c(%eax),%ebp
    b2bd:	51                   	push   %ecx
    b2be:	8b 48 24             	mov    0x24(%eax),%ecx
    b2c1:	51                   	push   %ecx
    b2c2:	9d                   	popf   
    b2c3:	59                   	pop    %ecx
    b2c4:	51                   	push   %ecx
    b2c5:	8b 48 28             	mov    0x28(%eax),%ecx
    b2c8:	0f 22 d9             	mov    %ecx,%cr3
    b2cb:	59                   	pop    %ecx
    b2cc:	8e 40 2c             	mov    0x2c(%eax),%es
    b2cf:	8e 68 2e             	mov    0x2e(%eax),%gs
    b2d2:	8e 60 30             	mov    0x30(%eax),%fs
    b2d5:	8b 40 20             	mov    0x20(%eax),%eax
    b2d8:	89 04 24             	mov    %eax,(%esp)
    b2db:	c3                   	ret    
