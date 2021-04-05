
bin/kernel.elf:     format de fichier elf32-i386


Déassemblage de la section .text :

00009000 <main>:
#include <lib.h>
#include <mm.h>
#include <task.h>

void main()
{
    9000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    9004:	83 e4 f0             	and    $0xfffffff0,%esp
    9007:	ff 71 fc             	pushl  -0x4(%ecx)
    900a:	55                   	push   %ebp
    900b:	89 e5                	mov    %esp,%ebp
    900d:	51                   	push   %ecx
    900e:	83 ec 04             	sub    $0x4,%esp
    //On initialise le necessaire avant de lancer la console
    pepper_screen();
    9011:	e8 b0 13 00 00       	call   a3c6 <pepper_screen>

    cli;
    9016:	fa                   	cli    

    init_idt();
    9017:	e8 bf 03 00 00       	call   93db <init_idt>

    init_paging();
    901c:	e8 b3 0c 00 00       	call   9cd4 <init_paging>
    kprintf(2 ,READY_COLOR ,"pepper kernel IA32bits laboratory\n\n");
    9021:	83 ec 04             	sub    $0x4,%esp
    9024:	68 e0 16 01 00       	push   $0x116e0
    9029:	6a 07                	push   $0x7
    902b:	6a 02                	push   $0x2
    902d:	e8 36 14 00 00       	call   a468 <kprintf>
    9032:	83 c4 10             	add    $0x10,%esp

    kprintf(2 ,READY_COLOR ,"K > ");
    9035:	83 ec 04             	sub    $0x4,%esp
    9038:	68 04 17 01 00       	push   $0x11704
    903d:	6a 07                	push   $0x7
    903f:	6a 02                	push   $0x2
    9041:	e8 22 14 00 00       	call   a468 <kprintf>
    9046:	83 c4 10             	add    $0x10,%esp

    sti;
    9049:	fb                   	sti    

    // enable_local_apic();

    // program_IOAPIC();

    while (1)
    904a:	eb fe                	jmp    904a <main+0x4a>

0000904c <_strcmp_>:
#include "../../include/string.h"
#include <stddef.h>

uint32_t _strcmp_(char* str1, char* str2)
{
    904c:	55                   	push   %ebp
    904d:	89 e5                	mov    %esp,%ebp
    904f:	53                   	push   %ebx
    9050:	83 ec 04             	sub    $0x4,%esp
    if (_strlen_(str2) != _strlen_(str1))
    9053:	83 ec 0c             	sub    $0xc,%esp
    9056:	ff 75 0c             	pushl  0xc(%ebp)
    9059:	e8 59 00 00 00       	call   90b7 <_strlen_>
    905e:	83 c4 10             	add    $0x10,%esp
    9061:	89 c3                	mov    %eax,%ebx
    9063:	83 ec 0c             	sub    $0xc,%esp
    9066:	ff 75 08             	pushl  0x8(%ebp)
    9069:	e8 49 00 00 00       	call   90b7 <_strlen_>
    906e:	83 c4 10             	add    $0x10,%esp
    9071:	38 c3                	cmp    %al,%bl
    9073:	74 0f                	je     9084 <_strcmp_+0x38>
        return 0;
    9075:	b8 00 00 00 00       	mov    $0x0,%eax
    907a:	eb 36                	jmp    90b2 <_strcmp_+0x66>

    while ((*str1 == *str2) && (*str1 != '\000')) {
        str1++;
    907c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        str2++;
    9080:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while ((*str1 == *str2) && (*str1 != '\000')) {
    9084:	8b 45 08             	mov    0x8(%ebp),%eax
    9087:	0f b6 10             	movzbl (%eax),%edx
    908a:	8b 45 0c             	mov    0xc(%ebp),%eax
    908d:	0f b6 00             	movzbl (%eax),%eax
    9090:	38 c2                	cmp    %al,%dl
    9092:	75 0a                	jne    909e <_strcmp_+0x52>
    9094:	8b 45 08             	mov    0x8(%ebp),%eax
    9097:	0f b6 00             	movzbl (%eax),%eax
    909a:	84 c0                	test   %al,%al
    909c:	75 de                	jne    907c <_strcmp_+0x30>
    }

    return *str1 == *str2;
    909e:	8b 45 08             	mov    0x8(%ebp),%eax
    90a1:	0f b6 10             	movzbl (%eax),%edx
    90a4:	8b 45 0c             	mov    0xc(%ebp),%eax
    90a7:	0f b6 00             	movzbl (%eax),%eax
    90aa:	38 c2                	cmp    %al,%dl
    90ac:	0f 94 c0             	sete   %al
    90af:	0f b6 c0             	movzbl %al,%eax
}
    90b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    90b5:	c9                   	leave  
    90b6:	c3                   	ret    

000090b7 <_strlen_>:

uint8_t _strlen_(char* str)
{
    90b7:	55                   	push   %ebp
    90b8:	89 e5                	mov    %esp,%ebp
    90ba:	83 ec 10             	sub    $0x10,%esp
    if (*str == '\000')
    90bd:	8b 45 08             	mov    0x8(%ebp),%eax
    90c0:	0f b6 00             	movzbl (%eax),%eax
    90c3:	84 c0                	test   %al,%al
    90c5:	75 07                	jne    90ce <_strlen_+0x17>
        return 0;
    90c7:	b8 00 00 00 00       	mov    $0x0,%eax
    90cc:	eb 22                	jmp    90f0 <_strlen_+0x39>

    uint8_t i = 1;
    90ce:	c6 45 ff 01          	movb   $0x1,-0x1(%ebp)

    while (*str != '\000') {
    90d2:	eb 0e                	jmp    90e2 <_strlen_+0x2b>
        str++;
    90d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        i++;
    90d8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    90dc:	83 c0 01             	add    $0x1,%eax
    90df:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (*str != '\000') {
    90e2:	8b 45 08             	mov    0x8(%ebp),%eax
    90e5:	0f b6 00             	movzbl (%eax),%eax
    90e8:	84 c0                	test   %al,%al
    90ea:	75 e8                	jne    90d4 <_strlen_+0x1d>
    }

    return i;
    90ec:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
    90f0:	c9                   	leave  
    90f1:	c3                   	ret    

000090f2 <_strcpy_>:

void* _strcpy_(char* dest, char* src)
{
    90f2:	55                   	push   %ebp
    90f3:	89 e5                	mov    %esp,%ebp
    90f5:	83 ec 10             	sub    $0x10,%esp
    if (dest == NULL)
    90f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    90fc:	75 07                	jne    9105 <_strcpy_+0x13>
        return (void*)NULL;
    90fe:	b8 00 00 00 00       	mov    $0x0,%eax
    9103:	eb 46                	jmp    914b <_strcpy_+0x59>

    uint8_t i = 0;
    9105:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    while (src[i] != '\000') {
    9109:	eb 21                	jmp    912c <_strcpy_+0x3a>
        dest[i] = src[i];
    910b:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    910f:	8b 45 0c             	mov    0xc(%ebp),%eax
    9112:	01 d0                	add    %edx,%eax
    9114:	0f b6 4d ff          	movzbl -0x1(%ebp),%ecx
    9118:	8b 55 08             	mov    0x8(%ebp),%edx
    911b:	01 ca                	add    %ecx,%edx
    911d:	0f b6 00             	movzbl (%eax),%eax
    9120:	88 02                	mov    %al,(%edx)
        i++;
    9122:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    9126:	83 c0 01             	add    $0x1,%eax
    9129:	88 45 ff             	mov    %al,-0x1(%ebp)
    while (src[i] != '\000') {
    912c:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9130:	8b 45 0c             	mov    0xc(%ebp),%eax
    9133:	01 d0                	add    %edx,%eax
    9135:	0f b6 00             	movzbl (%eax),%eax
    9138:	84 c0                	test   %al,%al
    913a:	75 cf                	jne    910b <_strcpy_+0x19>
    }

    dest[i] = '\000';
    913c:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    9140:	8b 45 08             	mov    0x8(%ebp),%eax
    9143:	01 d0                	add    %edx,%eax
    9145:	c6 00 00             	movb   $0x0,(%eax)

    return (void*)dest;
    9148:	8b 45 08             	mov    0x8(%ebp),%eax
}
    914b:	c9                   	leave  
    914c:	c3                   	ret    

0000914d <memcpy>:

void* memcpy(void* dest, const void* src, uint32_t size)
{
    914d:	55                   	push   %ebp
    914e:	89 e5                	mov    %esp,%ebp
    9150:	83 ec 10             	sub    $0x10,%esp
    char *_dest_, *_src_;

    _dest_ = (char*)dest;
    9153:	8b 45 08             	mov    0x8(%ebp),%eax
    9156:	89 45 fc             	mov    %eax,-0x4(%ebp)
    _src_ = (char*)src;
    9159:	8b 45 0c             	mov    0xc(%ebp),%eax
    915c:	89 45 f8             	mov    %eax,-0x8(%ebp)

    while (size) {
    915f:	eb 1b                	jmp    917c <memcpy+0x2f>
        *(_dest_++) = *(_src_++);
    9161:	8b 55 f8             	mov    -0x8(%ebp),%edx
    9164:	8d 42 01             	lea    0x1(%edx),%eax
    9167:	89 45 f8             	mov    %eax,-0x8(%ebp)
    916a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    916d:	8d 48 01             	lea    0x1(%eax),%ecx
    9170:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    9173:	0f b6 12             	movzbl (%edx),%edx
    9176:	88 10                	mov    %dl,(%eax)
        size--;
    9178:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (size) {
    917c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    9180:	75 df                	jne    9161 <memcpy+0x14>
    }

    return (void*)dest;
    9182:	8b 45 08             	mov    0x8(%ebp),%eax
}
    9185:	c9                   	leave  
    9186:	c3                   	ret    

00009187 <memset>:

void* memset(void* mem, void* data, uint32_t size)
{
    9187:	55                   	push   %ebp
    9188:	89 e5                	mov    %esp,%ebp
    918a:	83 ec 10             	sub    $0x10,%esp
    if (!mem)
    918d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    9191:	75 07                	jne    919a <memset+0x13>
        return NULL;
    9193:	b8 00 00 00 00       	mov    $0x0,%eax
    9198:	eb 21                	jmp    91bb <memset+0x34>

    uint32_t* dest = mem;
    919a:	8b 45 08             	mov    0x8(%ebp),%eax
    919d:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (size) {
    91a0:	eb 10                	jmp    91b2 <memset+0x2b>
        *dest = (uint32_t)data;
    91a2:	8b 55 0c             	mov    0xc(%ebp),%edx
    91a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    91a8:	89 10                	mov    %edx,(%eax)
        size--;
    91aa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
        dest += 4;
    91ae:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    while (size) {
    91b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    91b6:	75 ea                	jne    91a2 <memset+0x1b>
    }

    return (void*)mem;
    91b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    91bb:	c9                   	leave  
    91bc:	c3                   	ret    

000091bd <_memcmp_>:

bool _memcmp_(void* src_1, void* src_2, uint32_t size)
{
    91bd:	55                   	push   %ebp
    91be:	89 e5                	mov    %esp,%ebp
    91c0:	83 ec 10             	sub    $0x10,%esp
    char* mem_1 = (char*)src_1;
    91c3:	8b 45 08             	mov    0x8(%ebp),%eax
    91c6:	89 45 fc             	mov    %eax,-0x4(%ebp)

    char* mem_2 = (char*)src_2;
    91c9:	8b 45 0c             	mov    0xc(%ebp),%eax
    91cc:	89 45 f8             	mov    %eax,-0x8(%ebp)

    uint32_t i = 0;
    91cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (i < size && *mem_1 == *mem_2) {
    91d6:	eb 0c                	jmp    91e4 <_memcmp_+0x27>
        i++;
    91d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        mem_1++;
    91dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
        mem_2++;
    91e0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (i < size && *mem_1 == *mem_2) {
    91e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91e7:	3b 45 10             	cmp    0x10(%ebp),%eax
    91ea:	73 10                	jae    91fc <_memcmp_+0x3f>
    91ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
    91ef:	0f b6 10             	movzbl (%eax),%edx
    91f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    91f5:	0f b6 00             	movzbl (%eax),%eax
    91f8:	38 c2                	cmp    %al,%dl
    91fa:	74 dc                	je     91d8 <_memcmp_+0x1b>
    }

    return i == size;
    91fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    91ff:	3b 45 10             	cmp    0x10(%ebp),%eax
    9202:	0f 94 c0             	sete   %al
    9205:	0f b6 c0             	movzbl %al,%eax
    9208:	c9                   	leave  
    9209:	c3                   	ret    

0000920a <__exception__>:
extern unsigned int __error_code__;

void __exception__(void) {}
    920a:	55                   	push   %ebp
    920b:	89 e5                	mov    %esp,%ebp
    920d:	90                   	nop
    920e:	5d                   	pop    %ebp
    920f:	c3                   	ret    

00009210 <__exception_no_ERRCODE__>:
void __exception_no_ERRCODE__(void) {}
    9210:	55                   	push   %ebp
    9211:	89 e5                	mov    %esp,%ebp
    9213:	90                   	nop
    9214:	5d                   	pop    %ebp
    9215:	c3                   	ret    

00009216 <init_gdt_entry>:
/*
 * init_desc initialise un descripteur de segment situe en gdt ou en ldt.
 * desc est l'adresse lineaire du descripteur a initialiser.
 */
static void init_gdt_entry(uint32_t base, uint32_t limite, uint8_t access, uint8_t flags, gdt_entry_desc* desc)
{
    9216:	55                   	push   %ebp
    9217:	89 e5                	mov    %esp,%ebp
    9219:	83 ec 08             	sub    $0x8,%esp
    921c:	8b 55 10             	mov    0x10(%ebp),%edx
    921f:	8b 45 14             	mov    0x14(%ebp),%eax
    9222:	88 55 fc             	mov    %dl,-0x4(%ebp)
    9225:	88 45 f8             	mov    %al,-0x8(%ebp)
    desc->lim0_15 = (limite & 0xFFFF);
    9228:	8b 45 0c             	mov    0xc(%ebp),%eax
    922b:	89 c2                	mov    %eax,%edx
    922d:	8b 45 18             	mov    0x18(%ebp),%eax
    9230:	66 89 10             	mov    %dx,(%eax)
    desc->lim16_19 = (limite & 0xF0000) >> 16;
    9233:	8b 45 0c             	mov    0xc(%ebp),%eax
    9236:	c1 e8 10             	shr    $0x10,%eax
    9239:	83 e0 0f             	and    $0xf,%eax
    923c:	8b 55 18             	mov    0x18(%ebp),%edx
    923f:	83 e0 0f             	and    $0xf,%eax
    9242:	89 c1                	mov    %eax,%ecx
    9244:	0f b6 42 06          	movzbl 0x6(%edx),%eax
    9248:	83 e0 f0             	and    $0xfffffff0,%eax
    924b:	09 c8                	or     %ecx,%eax
    924d:	88 42 06             	mov    %al,0x6(%edx)

    desc->base0_15 = (base & 0xFFFF);
    9250:	8b 45 08             	mov    0x8(%ebp),%eax
    9253:	89 c2                	mov    %eax,%edx
    9255:	8b 45 18             	mov    0x18(%ebp),%eax
    9258:	66 89 50 02          	mov    %dx,0x2(%eax)
    desc->base16_23 = (base & 0xFF0000) >> 16;
    925c:	8b 45 08             	mov    0x8(%ebp),%eax
    925f:	c1 e8 10             	shr    $0x10,%eax
    9262:	89 c2                	mov    %eax,%edx
    9264:	8b 45 18             	mov    0x18(%ebp),%eax
    9267:	88 50 04             	mov    %dl,0x4(%eax)
    desc->base24_31 = (base & 0xFF000000) >> 24;
    926a:	8b 45 08             	mov    0x8(%ebp),%eax
    926d:	c1 e8 18             	shr    $0x18,%eax
    9270:	89 c2                	mov    %eax,%edx
    9272:	8b 45 18             	mov    0x18(%ebp),%eax
    9275:	88 50 07             	mov    %dl,0x7(%eax)

    desc->flags = flags;
    9278:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    927c:	83 e0 0f             	and    $0xf,%eax
    927f:	89 c2                	mov    %eax,%edx
    9281:	8b 45 18             	mov    0x18(%ebp),%eax
    9284:	89 d1                	mov    %edx,%ecx
    9286:	c1 e1 04             	shl    $0x4,%ecx
    9289:	0f b6 50 06          	movzbl 0x6(%eax),%edx
    928d:	83 e2 0f             	and    $0xf,%edx
    9290:	09 ca                	or     %ecx,%edx
    9292:	88 50 06             	mov    %dl,0x6(%eax)
    desc->acces_byte = access;
    9295:	8b 45 18             	mov    0x18(%ebp),%eax
    9298:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
    929c:	88 50 05             	mov    %dl,0x5(%eax)
}
    929f:	90                   	nop
    92a0:	c9                   	leave  
    92a1:	c3                   	ret    

000092a2 <init_gdt>:
 * en memoire. Une GDT est deja operationnelle, mais c'est celle qui
 * a ete initialisee par le secteur de boot et qui ne correspond
 * pas forcement a celle que l'on souhaite.
 */
void init_gdt(void)
{
    92a2:	55                   	push   %ebp
    92a3:	89 e5                	mov    %esp,%ebp
    92a5:	83 ec 08             	sub    $0x8,%esp
    /* initialisation des descripteurs de segment */
    init_gdt_entry(0x0, 0x0, 0x0, 0x0, &__gdt_entry__[0]);
    92a8:	a1 00 30 01 00       	mov    0x13000,%eax
    92ad:	50                   	push   %eax
    92ae:	6a 00                	push   $0x0
    92b0:	6a 00                	push   $0x0
    92b2:	6a 00                	push   $0x0
    92b4:	6a 00                	push   $0x0
    92b6:	e8 5b ff ff ff       	call   9216 <init_gdt_entry>
    92bb:	83 c4 14             	add    $0x14,%esp

    // Segment de code
    init_gdt_entry(0, 0xFFFFF, CODE_PRIVILEGE_0,
    92be:	a1 00 30 01 00       	mov    0x13000,%eax
    92c3:	83 c0 08             	add    $0x8,%eax
    92c6:	50                   	push   %eax
    92c7:	6a 04                	push   $0x4
    92c9:	68 9a 00 00 00       	push   $0x9a
    92ce:	68 ff ff 0f 00       	push   $0xfffff
    92d3:	6a 00                	push   $0x0
    92d5:	e8 3c ff ff ff       	call   9216 <init_gdt_entry>
    92da:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1), &__gdt_entry__[1]);

    // Segment de donnée
    init_gdt_entry(0, 0xFFFFF, DATA_PRIVILEGE_0,
    92dd:	a1 00 30 01 00       	mov    0x13000,%eax
    92e2:	83 c0 10             	add    $0x10,%eax
    92e5:	50                   	push   %eax
    92e6:	6a 04                	push   $0x4
    92e8:	68 92 00 00 00       	push   $0x92
    92ed:	68 ff ff 0f 00       	push   $0xfffff
    92f2:	6a 00                	push   $0x0
    92f4:	e8 1d ff ff ff       	call   9216 <init_gdt_entry>
    92f9:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[2]);

    // Segment de pile
    init_gdt_entry(0, 0xFFFFF, STACK_PRIVILEGE_0,
    92fc:	a1 00 30 01 00       	mov    0x13000,%eax
    9301:	83 c0 18             	add    $0x18,%eax
    9304:	50                   	push   %eax
    9305:	6a 04                	push   $0x4
    9307:	68 96 00 00 00       	push   $0x96
    930c:	68 ff ff 0f 00       	push   $0xfffff
    9311:	6a 00                	push   $0x0
    9313:	e8 fe fe ff ff       	call   9216 <init_gdt_entry>
    9318:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[3]);

    // Segment de tâches
    init_gdt_entry(0, 0xFFFFFF, TSS_PRIVILEGE_0,
    931b:	a1 00 30 01 00       	mov    0x13000,%eax
    9320:	83 c0 20             	add    $0x20,%eax
    9323:	50                   	push   %eax
    9324:	6a 04                	push   $0x4
    9326:	68 89 00 00 00       	push   $0x89
    932b:	68 ff ff ff 00       	push   $0xffffff
    9330:	6a 00                	push   $0x0
    9332:	e8 df fe ff ff       	call   9216 <init_gdt_entry>
    9337:	83 c4 14             	add    $0x14,%esp
                   SEG_GRANULARITY(0) | SEG_SIZE(1) | 0x0, &__gdt_entry__[4]);

    // Chargement de la GDT
    load_gdt();
    933a:	e8 f7 1e 00 00       	call   b236 <load_gdt>
    /*
        0x10(16) tout simplement parceque le data segment est à 16 + @base_gdt
        0x8 car code segment est à @base gdt + 8
        0x18 car stack segment est à @base gdt+24
    */
    __asm__ __volatile__(
    933f:	66 b8 10 00          	mov    $0x10,%ax
    9343:	8e d8                	mov    %eax,%ds
    9345:	8e c0                	mov    %eax,%es
    9347:	8e e0                	mov    %eax,%fs
    9349:	8e e8                	mov    %eax,%gs
    934b:	66 b8 18 00          	mov    $0x18,%ax
    934f:	8e d0                	mov    %eax,%ss
    9351:	ea 58 93 00 00 08 00 	ljmp   $0x8,$0x9358

00009358 <next>:
            movw %ax, %gs	\n \
            movw $0x18, %ax \n \
            movw %ax, %ss \n \
            ljmp $0x08, $next	\n  \
            next:   \n"); // Long jump after reconfiguration of all segment
}
    9358:	90                   	nop
    9359:	c9                   	leave  
    935a:	c3                   	ret    

0000935b <set_idt>:
__idt_entry__ __idt__[IDTSIZE];

extern void load_idt();

static void set_idt(uint16_t selector, uint8_t type, uint64_t offset, uint16_t vector)
{
    935b:	55                   	push   %ebp
    935c:	89 e5                	mov    %esp,%ebp
    935e:	83 ec 18             	sub    $0x18,%esp
    9361:	8b 45 08             	mov    0x8(%ebp),%eax
    9364:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    9367:	8b 55 18             	mov    0x18(%ebp),%edx
    936a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    936e:	89 c8                	mov    %ecx,%eax
    9370:	88 45 f8             	mov    %al,-0x8(%ebp)
    9373:	8b 45 10             	mov    0x10(%ebp),%eax
    9376:	89 45 f0             	mov    %eax,-0x10(%ebp)
    9379:	8b 45 14             	mov    0x14(%ebp),%eax
    937c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    937f:	89 d0                	mov    %edx,%eax
    9381:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    __idt__[vector].selector = selector; // Kernelcode segment offset
    9385:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9389:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
    938d:	66 89 14 c5 22 30 01 	mov    %dx,0x13022(,%eax,8)
    9394:	00 
    __idt__[vector].type_attr = type;    // Interrupt gate
    9395:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    9399:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
    939d:	88 14 c5 25 30 01 00 	mov    %dl,0x13025(,%eax,8)
    __idt__[vector].zero = 0;            // Only zero
    93a4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    93a8:	c6 04 c5 24 30 01 00 	movb   $0x0,0x13024(,%eax,8)
    93af:	00 
    __idt__[vector].offset_lowerbits = (offset & 0xFFFF);
    93b0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
    93b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
    93b7:	66 89 14 c5 20 30 01 	mov    %dx,0x13020(,%eax,8)
    93be:	00 
    __idt__[vector].offset_higherbits = (offset & 0xFFFF0000) >> 16;
    93bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    93c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    93c5:	0f ac d0 10          	shrd   $0x10,%edx,%eax
    93c9:	c1 ea 10             	shr    $0x10,%edx
    93cc:	0f b7 4d ec          	movzwl -0x14(%ebp),%ecx
    93d0:	66 89 04 cd 26 30 01 	mov    %ax,0x13026(,%ecx,8)
    93d7:	00 
}
    93d8:	90                   	nop
    93d9:	c9                   	leave  
    93da:	c3                   	ret    

000093db <init_idt>:

void init_idt()
{
    93db:	55                   	push   %ebp
    93dc:	89 e5                	mov    %esp,%ebp
    93de:	83 ec 08             	sub    $0x8,%esp
    Init_PIT((uint16_t)0xDAAD);
    93e1:	83 ec 0c             	sub    $0xc,%esp
    93e4:	68 ad da 00 00       	push   $0xdaad
    93e9:	e8 a9 0d 00 00       	call   a197 <Init_PIT>
    93ee:	83 c4 10             	add    $0x10,%esp

    
    // On itiialise les intérruptions qu'on va utiliser
    PIC_remap(0x20, 0x28);
    93f1:	83 ec 08             	sub    $0x8,%esp
    93f4:	6a 28                	push   $0x28
    93f6:	6a 20                	push   $0x20
    93f8:	e8 94 0a 00 00       	call   9e91 <PIC_remap>
    93fd:	83 c4 10             	add    $0x10,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)PIT_handler, 0x20); // IRQ_0
    9400:	b8 50 b3 00 00       	mov    $0xb350,%eax
    9405:	ba 00 00 00 00       	mov    $0x0,%edx
    940a:	83 ec 0c             	sub    $0xc,%esp
    940d:	6a 20                	push   $0x20
    940f:	52                   	push   %edx
    9410:	50                   	push   %eax
    9411:	68 8e 00 00 00       	push   $0x8e
    9416:	6a 08                	push   $0x8
    9418:	e8 3e ff ff ff       	call   935b <set_idt>
    941d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq1, 0x21);
    9420:	b8 a0 b2 00 00       	mov    $0xb2a0,%eax
    9425:	ba 00 00 00 00       	mov    $0x0,%edx
    942a:	83 ec 0c             	sub    $0xc,%esp
    942d:	6a 21                	push   $0x21
    942f:	52                   	push   %edx
    9430:	50                   	push   %eax
    9431:	68 8e 00 00 00       	push   $0x8e
    9436:	6a 08                	push   $0x8
    9438:	e8 1e ff ff ff       	call   935b <set_idt>
    943d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq2, 0x22);
    9440:	b8 a8 b2 00 00       	mov    $0xb2a8,%eax
    9445:	ba 00 00 00 00       	mov    $0x0,%edx
    944a:	83 ec 0c             	sub    $0xc,%esp
    944d:	6a 22                	push   $0x22
    944f:	52                   	push   %edx
    9450:	50                   	push   %eax
    9451:	68 8e 00 00 00       	push   $0x8e
    9456:	6a 08                	push   $0x8
    9458:	e8 fe fe ff ff       	call   935b <set_idt>
    945d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq3, 0x23);
    9460:	b8 b0 b2 00 00       	mov    $0xb2b0,%eax
    9465:	ba 00 00 00 00       	mov    $0x0,%edx
    946a:	83 ec 0c             	sub    $0xc,%esp
    946d:	6a 23                	push   $0x23
    946f:	52                   	push   %edx
    9470:	50                   	push   %eax
    9471:	68 8e 00 00 00       	push   $0x8e
    9476:	6a 08                	push   $0x8
    9478:	e8 de fe ff ff       	call   935b <set_idt>
    947d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq4, 0x24);
    9480:	b8 b8 b2 00 00       	mov    $0xb2b8,%eax
    9485:	ba 00 00 00 00       	mov    $0x0,%edx
    948a:	83 ec 0c             	sub    $0xc,%esp
    948d:	6a 24                	push   $0x24
    948f:	52                   	push   %edx
    9490:	50                   	push   %eax
    9491:	68 8e 00 00 00       	push   $0x8e
    9496:	6a 08                	push   $0x8
    9498:	e8 be fe ff ff       	call   935b <set_idt>
    949d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq5, 0x25);
    94a0:	b8 c0 b2 00 00       	mov    $0xb2c0,%eax
    94a5:	ba 00 00 00 00       	mov    $0x0,%edx
    94aa:	83 ec 0c             	sub    $0xc,%esp
    94ad:	6a 25                	push   $0x25
    94af:	52                   	push   %edx
    94b0:	50                   	push   %eax
    94b1:	68 8e 00 00 00       	push   $0x8e
    94b6:	6a 08                	push   $0x8
    94b8:	e8 9e fe ff ff       	call   935b <set_idt>
    94bd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq6, 0x26);
    94c0:	b8 c8 b2 00 00       	mov    $0xb2c8,%eax
    94c5:	ba 00 00 00 00       	mov    $0x0,%edx
    94ca:	83 ec 0c             	sub    $0xc,%esp
    94cd:	6a 26                	push   $0x26
    94cf:	52                   	push   %edx
    94d0:	50                   	push   %eax
    94d1:	68 8e 00 00 00       	push   $0x8e
    94d6:	6a 08                	push   $0x8
    94d8:	e8 7e fe ff ff       	call   935b <set_idt>
    94dd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq7, 0x27);
    94e0:	b8 d0 b2 00 00       	mov    $0xb2d0,%eax
    94e5:	ba 00 00 00 00       	mov    $0x0,%edx
    94ea:	83 ec 0c             	sub    $0xc,%esp
    94ed:	6a 27                	push   $0x27
    94ef:	52                   	push   %edx
    94f0:	50                   	push   %eax
    94f1:	68 8e 00 00 00       	push   $0x8e
    94f6:	6a 08                	push   $0x8
    94f8:	e8 5e fe ff ff       	call   935b <set_idt>
    94fd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq8, 0x28);
    9500:	b8 d8 b2 00 00       	mov    $0xb2d8,%eax
    9505:	ba 00 00 00 00       	mov    $0x0,%edx
    950a:	83 ec 0c             	sub    $0xc,%esp
    950d:	6a 28                	push   $0x28
    950f:	52                   	push   %edx
    9510:	50                   	push   %eax
    9511:	68 8e 00 00 00       	push   $0x8e
    9516:	6a 08                	push   $0x8
    9518:	e8 3e fe ff ff       	call   935b <set_idt>
    951d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq9, 0x29);
    9520:	b8 e0 b2 00 00       	mov    $0xb2e0,%eax
    9525:	ba 00 00 00 00       	mov    $0x0,%edx
    952a:	83 ec 0c             	sub    $0xc,%esp
    952d:	6a 29                	push   $0x29
    952f:	52                   	push   %edx
    9530:	50                   	push   %eax
    9531:	68 8e 00 00 00       	push   $0x8e
    9536:	6a 08                	push   $0x8
    9538:	e8 1e fe ff ff       	call   935b <set_idt>
    953d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq10, 0x2A);
    9540:	b8 e8 b2 00 00       	mov    $0xb2e8,%eax
    9545:	ba 00 00 00 00       	mov    $0x0,%edx
    954a:	83 ec 0c             	sub    $0xc,%esp
    954d:	6a 2a                	push   $0x2a
    954f:	52                   	push   %edx
    9550:	50                   	push   %eax
    9551:	68 8e 00 00 00       	push   $0x8e
    9556:	6a 08                	push   $0x8
    9558:	e8 fe fd ff ff       	call   935b <set_idt>
    955d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq11, 0x2B);
    9560:	b8 f0 b2 00 00       	mov    $0xb2f0,%eax
    9565:	ba 00 00 00 00       	mov    $0x0,%edx
    956a:	83 ec 0c             	sub    $0xc,%esp
    956d:	6a 2b                	push   $0x2b
    956f:	52                   	push   %edx
    9570:	50                   	push   %eax
    9571:	68 8e 00 00 00       	push   $0x8e
    9576:	6a 08                	push   $0x8
    9578:	e8 de fd ff ff       	call   935b <set_idt>
    957d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq12, 0x2C);
    9580:	b8 f8 b2 00 00       	mov    $0xb2f8,%eax
    9585:	ba 00 00 00 00       	mov    $0x0,%edx
    958a:	83 ec 0c             	sub    $0xc,%esp
    958d:	6a 2c                	push   $0x2c
    958f:	52                   	push   %edx
    9590:	50                   	push   %eax
    9591:	68 8e 00 00 00       	push   $0x8e
    9596:	6a 08                	push   $0x8
    9598:	e8 be fd ff ff       	call   935b <set_idt>
    959d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq13, 0x2D);
    95a0:	b8 00 b3 00 00       	mov    $0xb300,%eax
    95a5:	ba 00 00 00 00       	mov    $0x0,%edx
    95aa:	83 ec 0c             	sub    $0xc,%esp
    95ad:	6a 2d                	push   $0x2d
    95af:	52                   	push   %edx
    95b0:	50                   	push   %eax
    95b1:	68 8e 00 00 00       	push   $0x8e
    95b6:	6a 08                	push   $0x8
    95b8:	e8 9e fd ff ff       	call   935b <set_idt>
    95bd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq14, 0x2E);
    95c0:	b8 08 b3 00 00       	mov    $0xb308,%eax
    95c5:	ba 00 00 00 00       	mov    $0x0,%edx
    95ca:	83 ec 0c             	sub    $0xc,%esp
    95cd:	6a 2e                	push   $0x2e
    95cf:	52                   	push   %edx
    95d0:	50                   	push   %eax
    95d1:	68 8e 00 00 00       	push   $0x8e
    95d6:	6a 08                	push   $0x8
    95d8:	e8 7e fd ff ff       	call   935b <set_idt>
    95dd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)irq15, 0x2F);
    95e0:	b8 10 b3 00 00       	mov    $0xb310,%eax
    95e5:	ba 00 00 00 00       	mov    $0x0,%edx
    95ea:	83 ec 0c             	sub    $0xc,%esp
    95ed:	6a 2f                	push   $0x2f
    95ef:	52                   	push   %edx
    95f0:	50                   	push   %eax
    95f1:	68 8e 00 00 00       	push   $0x8e
    95f6:	6a 08                	push   $0x8
    95f8:	e8 5e fd ff ff       	call   935b <set_idt>
    95fd:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x8);
    9600:	b8 10 b2 00 00       	mov    $0xb210,%eax
    9605:	ba 00 00 00 00       	mov    $0x0,%edx
    960a:	83 ec 0c             	sub    $0xc,%esp
    960d:	6a 08                	push   $0x8
    960f:	52                   	push   %edx
    9610:	50                   	push   %eax
    9611:	68 8e 00 00 00       	push   $0x8e
    9616:	6a 08                	push   $0x8
    9618:	e8 3e fd ff ff       	call   935b <set_idt>
    961d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xA);
    9620:	b8 10 b2 00 00       	mov    $0xb210,%eax
    9625:	ba 00 00 00 00       	mov    $0x0,%edx
    962a:	83 ec 0c             	sub    $0xc,%esp
    962d:	6a 0a                	push   $0xa
    962f:	52                   	push   %edx
    9630:	50                   	push   %eax
    9631:	68 8e 00 00 00       	push   $0x8e
    9636:	6a 08                	push   $0x8
    9638:	e8 1e fd ff ff       	call   935b <set_idt>
    963d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xB);
    9640:	b8 10 b2 00 00       	mov    $0xb210,%eax
    9645:	ba 00 00 00 00       	mov    $0x0,%edx
    964a:	83 ec 0c             	sub    $0xc,%esp
    964d:	6a 0b                	push   $0xb
    964f:	52                   	push   %edx
    9650:	50                   	push   %eax
    9651:	68 8e 00 00 00       	push   $0x8e
    9656:	6a 08                	push   $0x8
    9658:	e8 fe fc ff ff       	call   935b <set_idt>
    965d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xC);
    9660:	b8 10 b2 00 00       	mov    $0xb210,%eax
    9665:	ba 00 00 00 00       	mov    $0x0,%edx
    966a:	83 ec 0c             	sub    $0xc,%esp
    966d:	6a 0c                	push   $0xc
    966f:	52                   	push   %edx
    9670:	50                   	push   %eax
    9671:	68 8e 00 00 00       	push   $0x8e
    9676:	6a 08                	push   $0x8
    9678:	e8 de fc ff ff       	call   935b <set_idt>
    967d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0xD);
    9680:	b8 10 b2 00 00       	mov    $0xb210,%eax
    9685:	ba 00 00 00 00       	mov    $0x0,%edx
    968a:	83 ec 0c             	sub    $0xc,%esp
    968d:	6a 0d                	push   $0xd
    968f:	52                   	push   %edx
    9690:	50                   	push   %eax
    9691:	68 8e 00 00 00       	push   $0x8e
    9696:	6a 08                	push   $0x8
    9698:	e8 be fc ff ff       	call   935b <set_idt>
    969d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)Paging_fault, 0xE);
    96a0:	b8 60 9e 00 00       	mov    $0x9e60,%eax
    96a5:	ba 00 00 00 00       	mov    $0x0,%edx
    96aa:	83 ec 0c             	sub    $0xc,%esp
    96ad:	6a 0e                	push   $0xe
    96af:	52                   	push   %edx
    96b0:	50                   	push   %eax
    96b1:	68 8e 00 00 00       	push   $0x8e
    96b6:	6a 08                	push   $0x8
    96b8:	e8 9e fc ff ff       	call   935b <set_idt>
    96bd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x11);
    96c0:	b8 10 b2 00 00       	mov    $0xb210,%eax
    96c5:	ba 00 00 00 00       	mov    $0x0,%edx
    96ca:	83 ec 0c             	sub    $0xc,%esp
    96cd:	6a 11                	push   $0x11
    96cf:	52                   	push   %edx
    96d0:	50                   	push   %eax
    96d1:	68 8e 00 00 00       	push   $0x8e
    96d6:	6a 08                	push   $0x8
    96d8:	e8 7e fc ff ff       	call   935b <set_idt>
    96dd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_handler__, 0x1E);
    96e0:	b8 10 b2 00 00       	mov    $0xb210,%eax
    96e5:	ba 00 00 00 00       	mov    $0x0,%edx
    96ea:	83 ec 0c             	sub    $0xc,%esp
    96ed:	6a 1e                	push   $0x1e
    96ef:	52                   	push   %edx
    96f0:	50                   	push   %eax
    96f1:	68 8e 00 00 00       	push   $0x8e
    96f6:	6a 08                	push   $0x8
    96f8:	e8 5e fc ff ff       	call   935b <set_idt>
    96fd:	83 c4 20             	add    $0x20,%esp

    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x0);
    9700:	b8 10 92 00 00       	mov    $0x9210,%eax
    9705:	ba 00 00 00 00       	mov    $0x0,%edx
    970a:	83 ec 0c             	sub    $0xc,%esp
    970d:	6a 00                	push   $0x0
    970f:	52                   	push   %edx
    9710:	50                   	push   %eax
    9711:	68 8e 00 00 00       	push   $0x8e
    9716:	6a 08                	push   $0x8
    9718:	e8 3e fc ff ff       	call   935b <set_idt>
    971d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x1);
    9720:	b8 10 92 00 00       	mov    $0x9210,%eax
    9725:	ba 00 00 00 00       	mov    $0x0,%edx
    972a:	83 ec 0c             	sub    $0xc,%esp
    972d:	6a 01                	push   $0x1
    972f:	52                   	push   %edx
    9730:	50                   	push   %eax
    9731:	68 8e 00 00 00       	push   $0x8e
    9736:	6a 08                	push   $0x8
    9738:	e8 1e fc ff ff       	call   935b <set_idt>
    973d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x2);
    9740:	b8 10 92 00 00       	mov    $0x9210,%eax
    9745:	ba 00 00 00 00       	mov    $0x0,%edx
    974a:	83 ec 0c             	sub    $0xc,%esp
    974d:	6a 02                	push   $0x2
    974f:	52                   	push   %edx
    9750:	50                   	push   %eax
    9751:	68 8e 00 00 00       	push   $0x8e
    9756:	6a 08                	push   $0x8
    9758:	e8 fe fb ff ff       	call   935b <set_idt>
    975d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x3);
    9760:	b8 10 92 00 00       	mov    $0x9210,%eax
    9765:	ba 00 00 00 00       	mov    $0x0,%edx
    976a:	83 ec 0c             	sub    $0xc,%esp
    976d:	6a 03                	push   $0x3
    976f:	52                   	push   %edx
    9770:	50                   	push   %eax
    9771:	68 8e 00 00 00       	push   $0x8e
    9776:	6a 08                	push   $0x8
    9778:	e8 de fb ff ff       	call   935b <set_idt>
    977d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x4);
    9780:	b8 10 92 00 00       	mov    $0x9210,%eax
    9785:	ba 00 00 00 00       	mov    $0x0,%edx
    978a:	83 ec 0c             	sub    $0xc,%esp
    978d:	6a 04                	push   $0x4
    978f:	52                   	push   %edx
    9790:	50                   	push   %eax
    9791:	68 8e 00 00 00       	push   $0x8e
    9796:	6a 08                	push   $0x8
    9798:	e8 be fb ff ff       	call   935b <set_idt>
    979d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x5);
    97a0:	b8 10 92 00 00       	mov    $0x9210,%eax
    97a5:	ba 00 00 00 00       	mov    $0x0,%edx
    97aa:	83 ec 0c             	sub    $0xc,%esp
    97ad:	6a 05                	push   $0x5
    97af:	52                   	push   %edx
    97b0:	50                   	push   %eax
    97b1:	68 8e 00 00 00       	push   $0x8e
    97b6:	6a 08                	push   $0x8
    97b8:	e8 9e fb ff ff       	call   935b <set_idt>
    97bd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x6);
    97c0:	b8 10 92 00 00       	mov    $0x9210,%eax
    97c5:	ba 00 00 00 00       	mov    $0x0,%edx
    97ca:	83 ec 0c             	sub    $0xc,%esp
    97cd:	6a 06                	push   $0x6
    97cf:	52                   	push   %edx
    97d0:	50                   	push   %eax
    97d1:	68 8e 00 00 00       	push   $0x8e
    97d6:	6a 08                	push   $0x8
    97d8:	e8 7e fb ff ff       	call   935b <set_idt>
    97dd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x7);
    97e0:	b8 10 92 00 00       	mov    $0x9210,%eax
    97e5:	ba 00 00 00 00       	mov    $0x0,%edx
    97ea:	83 ec 0c             	sub    $0xc,%esp
    97ed:	6a 07                	push   $0x7
    97ef:	52                   	push   %edx
    97f0:	50                   	push   %eax
    97f1:	68 8e 00 00 00       	push   $0x8e
    97f6:	6a 08                	push   $0x8
    97f8:	e8 5e fb ff ff       	call   935b <set_idt>
    97fd:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x9);
    9800:	b8 10 92 00 00       	mov    $0x9210,%eax
    9805:	ba 00 00 00 00       	mov    $0x0,%edx
    980a:	83 ec 0c             	sub    $0xc,%esp
    980d:	6a 09                	push   $0x9
    980f:	52                   	push   %edx
    9810:	50                   	push   %eax
    9811:	68 8e 00 00 00       	push   $0x8e
    9816:	6a 08                	push   $0x8
    9818:	e8 3e fb ff ff       	call   935b <set_idt>
    981d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x10);
    9820:	b8 10 92 00 00       	mov    $0x9210,%eax
    9825:	ba 00 00 00 00       	mov    $0x0,%edx
    982a:	83 ec 0c             	sub    $0xc,%esp
    982d:	6a 10                	push   $0x10
    982f:	52                   	push   %edx
    9830:	50                   	push   %eax
    9831:	68 8e 00 00 00       	push   $0x8e
    9836:	6a 08                	push   $0x8
    9838:	e8 1e fb ff ff       	call   935b <set_idt>
    983d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x12);
    9840:	b8 10 92 00 00       	mov    $0x9210,%eax
    9845:	ba 00 00 00 00       	mov    $0x0,%edx
    984a:	83 ec 0c             	sub    $0xc,%esp
    984d:	6a 12                	push   $0x12
    984f:	52                   	push   %edx
    9850:	50                   	push   %eax
    9851:	68 8e 00 00 00       	push   $0x8e
    9856:	6a 08                	push   $0x8
    9858:	e8 fe fa ff ff       	call   935b <set_idt>
    985d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x13);
    9860:	b8 10 92 00 00       	mov    $0x9210,%eax
    9865:	ba 00 00 00 00       	mov    $0x0,%edx
    986a:	83 ec 0c             	sub    $0xc,%esp
    986d:	6a 13                	push   $0x13
    986f:	52                   	push   %edx
    9870:	50                   	push   %eax
    9871:	68 8e 00 00 00       	push   $0x8e
    9876:	6a 08                	push   $0x8
    9878:	e8 de fa ff ff       	call   935b <set_idt>
    987d:	83 c4 20             	add    $0x20,%esp
    set_idt(0x08, INTGATE_PRIVILEGE_0, (unsigned long)__exception_no_ERRCODE__, 0x14);
    9880:	b8 10 92 00 00       	mov    $0x9210,%eax
    9885:	ba 00 00 00 00       	mov    $0x0,%edx
    988a:	83 ec 0c             	sub    $0xc,%esp
    988d:	6a 14                	push   $0x14
    988f:	52                   	push   %edx
    9890:	50                   	push   %eax
    9891:	68 8e 00 00 00       	push   $0x8e
    9896:	6a 08                	push   $0x8
    9898:	e8 be fa ff ff       	call   935b <set_idt>
    989d:	83 c4 20             	add    $0x20,%esp

    /* initialisation de la structure pour IDTR */
    load_idt();
    98a0:	e8 ca 19 00 00       	call   b26f <load_idt>
}
    98a5:	90                   	nop
    98a6:	c9                   	leave  
    98a7:	c3                   	ret    

000098a8 <irq1_handler>:

extern void spurious_IRQ(unsigned char irq);
extern void keyboard_irq() ; 

void irq1_handler(void)
{
    98a8:	55                   	push   %ebp
    98a9:	89 e5                	mov    %esp,%ebp
    98ab:	83 ec 08             	sub    $0x8,%esp
    keyboard_irq() ; 
    98ae:	e8 fa 01 00 00       	call   9aad <keyboard_irq>
    PIC_sendEOI(1);
    98b3:	83 ec 0c             	sub    $0xc,%esp
    98b6:	6a 01                	push   $0x1
    98b8:	e8 a9 05 00 00       	call   9e66 <PIC_sendEOI>
    98bd:	83 c4 10             	add    $0x10,%esp
}
    98c0:	90                   	nop
    98c1:	c9                   	leave  
    98c2:	c3                   	ret    

000098c3 <irq2_handler>:

void irq2_handler(void)
{
    98c3:	55                   	push   %ebp
    98c4:	89 e5                	mov    %esp,%ebp
    98c6:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(2);
    98c9:	83 ec 0c             	sub    $0xc,%esp
    98cc:	6a 02                	push   $0x2
    98ce:	e8 9e 07 00 00       	call   a071 <spurious_IRQ>
    98d3:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(2);
    98d6:	83 ec 0c             	sub    $0xc,%esp
    98d9:	6a 02                	push   $0x2
    98db:	e8 86 05 00 00       	call   9e66 <PIC_sendEOI>
    98e0:	83 c4 10             	add    $0x10,%esp
}
    98e3:	90                   	nop
    98e4:	c9                   	leave  
    98e5:	c3                   	ret    

000098e6 <irq3_handler>:

void irq3_handler(void)
{
    98e6:	55                   	push   %ebp
    98e7:	89 e5                	mov    %esp,%ebp
    98e9:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(3);
    98ec:	83 ec 0c             	sub    $0xc,%esp
    98ef:	6a 03                	push   $0x3
    98f1:	e8 7b 07 00 00       	call   a071 <spurious_IRQ>
    98f6:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(3);
    98f9:	83 ec 0c             	sub    $0xc,%esp
    98fc:	6a 03                	push   $0x3
    98fe:	e8 63 05 00 00       	call   9e66 <PIC_sendEOI>
    9903:	83 c4 10             	add    $0x10,%esp
}
    9906:	90                   	nop
    9907:	c9                   	leave  
    9908:	c3                   	ret    

00009909 <irq4_handler>:

void irq4_handler(void)
{
    9909:	55                   	push   %ebp
    990a:	89 e5                	mov    %esp,%ebp
    990c:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(4);
    990f:	83 ec 0c             	sub    $0xc,%esp
    9912:	6a 04                	push   $0x4
    9914:	e8 58 07 00 00       	call   a071 <spurious_IRQ>
    9919:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(4);
    991c:	83 ec 0c             	sub    $0xc,%esp
    991f:	6a 04                	push   $0x4
    9921:	e8 40 05 00 00       	call   9e66 <PIC_sendEOI>
    9926:	83 c4 10             	add    $0x10,%esp
}
    9929:	90                   	nop
    992a:	c9                   	leave  
    992b:	c3                   	ret    

0000992c <irq5_handler>:

void irq5_handler(void)
{
    992c:	55                   	push   %ebp
    992d:	89 e5                	mov    %esp,%ebp
    992f:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(5);
    9932:	83 ec 0c             	sub    $0xc,%esp
    9935:	6a 05                	push   $0x5
    9937:	e8 35 07 00 00       	call   a071 <spurious_IRQ>
    993c:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(5);
    993f:	83 ec 0c             	sub    $0xc,%esp
    9942:	6a 05                	push   $0x5
    9944:	e8 1d 05 00 00       	call   9e66 <PIC_sendEOI>
    9949:	83 c4 10             	add    $0x10,%esp
}
    994c:	90                   	nop
    994d:	c9                   	leave  
    994e:	c3                   	ret    

0000994f <irq6_handler>:

void irq6_handler(void)
{
    994f:	55                   	push   %ebp
    9950:	89 e5                	mov    %esp,%ebp
    9952:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(6);
    9955:	83 ec 0c             	sub    $0xc,%esp
    9958:	6a 06                	push   $0x6
    995a:	e8 12 07 00 00       	call   a071 <spurious_IRQ>
    995f:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(6);
    9962:	83 ec 0c             	sub    $0xc,%esp
    9965:	6a 06                	push   $0x6
    9967:	e8 fa 04 00 00       	call   9e66 <PIC_sendEOI>
    996c:	83 c4 10             	add    $0x10,%esp
}
    996f:	90                   	nop
    9970:	c9                   	leave  
    9971:	c3                   	ret    

00009972 <irq7_handler>:

void irq7_handler(void)
{
    9972:	55                   	push   %ebp
    9973:	89 e5                	mov    %esp,%ebp
    9975:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(7);
    9978:	83 ec 0c             	sub    $0xc,%esp
    997b:	6a 07                	push   $0x7
    997d:	e8 ef 06 00 00       	call   a071 <spurious_IRQ>
    9982:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(7);
    9985:	83 ec 0c             	sub    $0xc,%esp
    9988:	6a 07                	push   $0x7
    998a:	e8 d7 04 00 00       	call   9e66 <PIC_sendEOI>
    998f:	83 c4 10             	add    $0x10,%esp
}
    9992:	90                   	nop
    9993:	c9                   	leave  
    9994:	c3                   	ret    

00009995 <irq8_handler>:

void irq8_handler(void)
{
    9995:	55                   	push   %ebp
    9996:	89 e5                	mov    %esp,%ebp
    9998:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(8);
    999b:	83 ec 0c             	sub    $0xc,%esp
    999e:	6a 08                	push   $0x8
    99a0:	e8 cc 06 00 00       	call   a071 <spurious_IRQ>
    99a5:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(8);
    99a8:	83 ec 0c             	sub    $0xc,%esp
    99ab:	6a 08                	push   $0x8
    99ad:	e8 b4 04 00 00       	call   9e66 <PIC_sendEOI>
    99b2:	83 c4 10             	add    $0x10,%esp
}
    99b5:	90                   	nop
    99b6:	c9                   	leave  
    99b7:	c3                   	ret    

000099b8 <irq9_handler>:

void irq9_handler(void)
{
    99b8:	55                   	push   %ebp
    99b9:	89 e5                	mov    %esp,%ebp
    99bb:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(9);
    99be:	83 ec 0c             	sub    $0xc,%esp
    99c1:	6a 09                	push   $0x9
    99c3:	e8 a9 06 00 00       	call   a071 <spurious_IRQ>
    99c8:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(9);
    99cb:	83 ec 0c             	sub    $0xc,%esp
    99ce:	6a 09                	push   $0x9
    99d0:	e8 91 04 00 00       	call   9e66 <PIC_sendEOI>
    99d5:	83 c4 10             	add    $0x10,%esp
}
    99d8:	90                   	nop
    99d9:	c9                   	leave  
    99da:	c3                   	ret    

000099db <irq10_handler>:

void irq10_handler(void)
{
    99db:	55                   	push   %ebp
    99dc:	89 e5                	mov    %esp,%ebp
    99de:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(10);
    99e1:	83 ec 0c             	sub    $0xc,%esp
    99e4:	6a 0a                	push   $0xa
    99e6:	e8 86 06 00 00       	call   a071 <spurious_IRQ>
    99eb:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(10);
    99ee:	83 ec 0c             	sub    $0xc,%esp
    99f1:	6a 0a                	push   $0xa
    99f3:	e8 6e 04 00 00       	call   9e66 <PIC_sendEOI>
    99f8:	83 c4 10             	add    $0x10,%esp
}
    99fb:	90                   	nop
    99fc:	c9                   	leave  
    99fd:	c3                   	ret    

000099fe <irq11_handler>:

void irq11_handler(void)
{
    99fe:	55                   	push   %ebp
    99ff:	89 e5                	mov    %esp,%ebp
    9a01:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(11);
    9a04:	83 ec 0c             	sub    $0xc,%esp
    9a07:	6a 0b                	push   $0xb
    9a09:	e8 63 06 00 00       	call   a071 <spurious_IRQ>
    9a0e:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(11);
    9a11:	83 ec 0c             	sub    $0xc,%esp
    9a14:	6a 0b                	push   $0xb
    9a16:	e8 4b 04 00 00       	call   9e66 <PIC_sendEOI>
    9a1b:	83 c4 10             	add    $0x10,%esp
}
    9a1e:	90                   	nop
    9a1f:	c9                   	leave  
    9a20:	c3                   	ret    

00009a21 <irq12_handler>:

void irq12_handler(void)
{
    9a21:	55                   	push   %ebp
    9a22:	89 e5                	mov    %esp,%ebp
    9a24:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(12);
    9a27:	83 ec 0c             	sub    $0xc,%esp
    9a2a:	6a 0c                	push   $0xc
    9a2c:	e8 40 06 00 00       	call   a071 <spurious_IRQ>
    9a31:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(12);
    9a34:	83 ec 0c             	sub    $0xc,%esp
    9a37:	6a 0c                	push   $0xc
    9a39:	e8 28 04 00 00       	call   9e66 <PIC_sendEOI>
    9a3e:	83 c4 10             	add    $0x10,%esp
}
    9a41:	90                   	nop
    9a42:	c9                   	leave  
    9a43:	c3                   	ret    

00009a44 <irq13_handler>:

void irq13_handler(void)
{
    9a44:	55                   	push   %ebp
    9a45:	89 e5                	mov    %esp,%ebp
    9a47:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(13);
    9a4a:	83 ec 0c             	sub    $0xc,%esp
    9a4d:	6a 0d                	push   $0xd
    9a4f:	e8 1d 06 00 00       	call   a071 <spurious_IRQ>
    9a54:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(13);
    9a57:	83 ec 0c             	sub    $0xc,%esp
    9a5a:	6a 0d                	push   $0xd
    9a5c:	e8 05 04 00 00       	call   9e66 <PIC_sendEOI>
    9a61:	83 c4 10             	add    $0x10,%esp
}
    9a64:	90                   	nop
    9a65:	c9                   	leave  
    9a66:	c3                   	ret    

00009a67 <irq14_handler>:

void irq14_handler(void)
{
    9a67:	55                   	push   %ebp
    9a68:	89 e5                	mov    %esp,%ebp
    9a6a:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(14);
    9a6d:	83 ec 0c             	sub    $0xc,%esp
    9a70:	6a 0e                	push   $0xe
    9a72:	e8 fa 05 00 00       	call   a071 <spurious_IRQ>
    9a77:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(14);
    9a7a:	83 ec 0c             	sub    $0xc,%esp
    9a7d:	6a 0e                	push   $0xe
    9a7f:	e8 e2 03 00 00       	call   9e66 <PIC_sendEOI>
    9a84:	83 c4 10             	add    $0x10,%esp
}
    9a87:	90                   	nop
    9a88:	c9                   	leave  
    9a89:	c3                   	ret    

00009a8a <irq15_handler>:

void irq15_handler(void)
{
    9a8a:	55                   	push   %ebp
    9a8b:	89 e5                	mov    %esp,%ebp
    9a8d:	83 ec 08             	sub    $0x8,%esp
    spurious_IRQ(15);
    9a90:	83 ec 0c             	sub    $0xc,%esp
    9a93:	6a 0f                	push   $0xf
    9a95:	e8 d7 05 00 00       	call   a071 <spurious_IRQ>
    9a9a:	83 c4 10             	add    $0x10,%esp

    PIC_sendEOI(15);
    9a9d:	83 ec 0c             	sub    $0xc,%esp
    9aa0:	6a 0f                	push   $0xf
    9aa2:	e8 bf 03 00 00       	call   9e66 <PIC_sendEOI>
    9aa7:	83 c4 10             	add    $0x10,%esp
    9aaa:	90                   	nop
    9aab:	c9                   	leave  
    9aac:	c3                   	ret    

00009aad <keyboard_irq>:

extern void show_cursor() ;
static void wait_8042_ACK ();

void keyboard_irq()
{
    9aad:	55                   	push   %ebp
    9aae:	89 e5                	mov    %esp,%ebp
    9ab0:	83 ec 18             	sub    $0x18,%esp
	static int rshift_enable;
	static int alt_enable;
	static int ctrl_enable;

	do {
		i = _8042_get_status;
    9ab3:	b8 64 00 00 00       	mov    $0x64,%eax
    9ab8:	89 c2                	mov    %eax,%edx
    9aba:	ec                   	in     (%dx),%al
    9abb:	88 45 f7             	mov    %al,-0x9(%ebp)
    9abe:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    9ac2:	88 45 f6             	mov    %al,-0xa(%ebp)
	} while ((i & 0x01) == _8042_BUFFER_OVERRUN);
    9ac5:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9ac9:	83 e0 01             	and    $0x1,%eax
    9acc:	85 c0                	test   %eax,%eax
    9ace:	74 e3                	je     9ab3 <keyboard_irq+0x6>

	i = _8042_scan_code;
    9ad0:	b8 60 00 00 00       	mov    $0x60,%eax
    9ad5:	89 c2                	mov    %eax,%edx
    9ad7:	ec                   	in     (%dx),%al
    9ad8:	88 45 f5             	mov    %al,-0xb(%ebp)
    9adb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    9adf:	88 45 f6             	mov    %al,-0xa(%ebp)
	i--;
    9ae2:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9ae6:	83 e8 01             	sub    $0x1,%eax
    9ae9:	88 45 f6             	mov    %al,-0xa(%ebp)

	//// putcar('\n'); dump(&i, 1); putcar(' ');

	if (i < 0x80) {		/* touche enfoncee */
    9aec:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9af0:	84 c0                	test   %al,%al
    9af2:	0f 88 c6 00 00 00    	js     9bbe <keyboard_irq+0x111>
		switch (i) {
    9af8:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9afc:	83 f8 37             	cmp    $0x37,%eax
    9aff:	74 52                	je     9b53 <keyboard_irq+0xa6>
    9b01:	83 f8 37             	cmp    $0x37,%eax
    9b04:	7f 73                	jg     9b79 <keyboard_irq+0xcc>
    9b06:	83 f8 35             	cmp    $0x35,%eax
    9b09:	74 2a                	je     9b35 <keyboard_irq+0x88>
    9b0b:	83 f8 35             	cmp    $0x35,%eax
    9b0e:	7f 69                	jg     9b79 <keyboard_irq+0xcc>
    9b10:	83 f8 29             	cmp    $0x29,%eax
    9b13:	74 11                	je     9b26 <keyboard_irq+0x79>
    9b15:	83 f8 29             	cmp    $0x29,%eax
    9b18:	7f 5f                	jg     9b79 <keyboard_irq+0xcc>
    9b1a:	83 f8 0d             	cmp    $0xd,%eax
    9b1d:	74 43                	je     9b62 <keyboard_irq+0xb5>
    9b1f:	83 f8 1c             	cmp    $0x1c,%eax
    9b22:	74 20                	je     9b44 <keyboard_irq+0x97>
    9b24:	eb 53                	jmp    9b79 <keyboard_irq+0xcc>
		case 0x29:
			lshift_enable = 1;
    9b26:	c7 05 18 38 01 00 01 	movl   $0x1,0x13818
    9b2d:	00 00 00 
			break;
    9b30:	e9 de 00 00 00       	jmp    9c13 <keyboard_irq+0x166>
		case 0x35:
			rshift_enable = 1;
    9b35:	c7 05 1c 38 01 00 01 	movl   $0x1,0x1381c
    9b3c:	00 00 00 
			break;
    9b3f:	e9 cf 00 00 00       	jmp    9c13 <keyboard_irq+0x166>
		case 0x1C:
			ctrl_enable = 1;
    9b44:	c7 05 20 38 01 00 01 	movl   $0x1,0x13820
    9b4b:	00 00 00 
			break;
    9b4e:	e9 c0 00 00 00       	jmp    9c13 <keyboard_irq+0x166>
		case 0x37:
			alt_enable = 1;
    9b53:	c7 05 24 38 01 00 01 	movl   $0x1,0x13824
    9b5a:	00 00 00 
			break;
    9b5d:	e9 b1 00 00 00       	jmp    9c13 <keyboard_irq+0x166>
		case 0x0D:
				putchar(READY_COLOR  , i);
    9b62:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9b66:	83 ec 08             	sub    $0x8,%esp
    9b69:	50                   	push   %eax
    9b6a:	6a 07                	push   $0x7
    9b6c:	e8 73 0a 00 00       	call   a5e4 <putchar>
    9b71:	83 c4 10             	add    $0x10,%esp
			break;
    9b74:	e9 9a 00 00 00       	jmp    9c13 <keyboard_irq+0x166>
		default:
			putchar(READY_COLOR ,  kbdmap
			       [i * 4 + (lshift_enable || rshift_enable)]);
    9b79:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9b7d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    9b84:	a1 18 38 01 00       	mov    0x13818,%eax
    9b89:	85 c0                	test   %eax,%eax
    9b8b:	75 09                	jne    9b96 <keyboard_irq+0xe9>
    9b8d:	a1 1c 38 01 00       	mov    0x1381c,%eax
    9b92:	85 c0                	test   %eax,%eax
    9b94:	74 07                	je     9b9d <keyboard_irq+0xf0>
    9b96:	b8 01 00 00 00       	mov    $0x1,%eax
    9b9b:	eb 05                	jmp    9ba2 <keyboard_irq+0xf5>
    9b9d:	b8 00 00 00 00       	mov    $0x0,%eax
    9ba2:	01 d0                	add    %edx,%eax
    9ba4:	0f b6 80 80 ba 00 00 	movzbl 0xba80(%eax),%eax
			putchar(READY_COLOR ,  kbdmap
    9bab:	0f b6 c0             	movzbl %al,%eax
    9bae:	83 ec 08             	sub    $0x8,%esp
    9bb1:	50                   	push   %eax
    9bb2:	6a 07                	push   $0x7
    9bb4:	e8 2b 0a 00 00       	call   a5e4 <putchar>
    9bb9:	83 c4 10             	add    $0x10,%esp
    9bbc:	eb 55                	jmp    9c13 <keyboard_irq+0x166>
		}
	} else {		/* touche relachee */
		i -= 0x80;
    9bbe:	80 45 f6 80          	addb   $0x80,-0xa(%ebp)
		switch (i) {
    9bc2:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9bc6:	83 f8 37             	cmp    $0x37,%eax
    9bc9:	74 3d                	je     9c08 <keyboard_irq+0x15b>
    9bcb:	83 f8 37             	cmp    $0x37,%eax
    9bce:	7f 43                	jg     9c13 <keyboard_irq+0x166>
    9bd0:	83 f8 35             	cmp    $0x35,%eax
    9bd3:	74 1b                	je     9bf0 <keyboard_irq+0x143>
    9bd5:	83 f8 35             	cmp    $0x35,%eax
    9bd8:	7f 39                	jg     9c13 <keyboard_irq+0x166>
    9bda:	83 f8 1c             	cmp    $0x1c,%eax
    9bdd:	74 1d                	je     9bfc <keyboard_irq+0x14f>
    9bdf:	83 f8 29             	cmp    $0x29,%eax
    9be2:	75 2f                	jne    9c13 <keyboard_irq+0x166>
		case 0x29:
			lshift_enable = 0;
    9be4:	c7 05 18 38 01 00 00 	movl   $0x0,0x13818
    9beb:	00 00 00 
			break;
    9bee:	eb 23                	jmp    9c13 <keyboard_irq+0x166>
		case 0x35:
			rshift_enable = 0;
    9bf0:	c7 05 1c 38 01 00 00 	movl   $0x0,0x1381c
    9bf7:	00 00 00 
			break;
    9bfa:	eb 17                	jmp    9c13 <keyboard_irq+0x166>
		case 0x1C:
			ctrl_enable = 0;
    9bfc:	c7 05 20 38 01 00 00 	movl   $0x0,0x13820
    9c03:	00 00 00 
			break;
    9c06:	eb 0b                	jmp    9c13 <keyboard_irq+0x166>
		case 0x37:
			alt_enable = 0;
    9c08:	c7 05 24 38 01 00 00 	movl   $0x0,0x13824
    9c0f:	00 00 00 
			break;
    9c12:	90                   	nop
		}
	}

	show_cursor() ;
    9c13:	e8 f7 0c 00 00       	call   a90f <show_cursor>
}
    9c18:	90                   	nop
    9c19:	c9                   	leave  
    9c1a:	c3                   	ret    

00009c1b <reinitialise_kbd>:

void reinitialise_kbd()
{
    9c1b:	55                   	push   %ebp
    9c1c:	89 e5                	mov    %esp,%ebp
    9c1e:	83 ec 08             	sub    $0x8,%esp
	_8042_send_get_current_scan_code ;
    9c21:	ba 64 00 00 00       	mov    $0x64,%edx
    9c26:	b8 f0 00 00 00       	mov    $0xf0,%eax
    9c2b:	ee                   	out    %al,(%dx)
	wait_8042_ACK ();
    9c2c:	e8 33 00 00 00       	call   9c64 <wait_8042_ACK>

	_8042_set_typematic_rate ; 
    9c31:	ba 64 00 00 00       	mov    $0x64,%edx
    9c36:	b8 f3 00 00 00       	mov    $0xf3,%eax
    9c3b:	ee                   	out    %al,(%dx)
	wait_8042_ACK ();
    9c3c:	e8 23 00 00 00       	call   9c64 <wait_8042_ACK>
	
	_8042_set_leds ;
    9c41:	ba 64 00 00 00       	mov    $0x64,%edx
    9c46:	b8 ed 00 00 00       	mov    $0xed,%eax
    9c4b:	ee                   	out    %al,(%dx)
	wait_8042_ACK ();
    9c4c:	e8 13 00 00 00       	call   9c64 <wait_8042_ACK>
	
	_8042_enable_scanning ;
    9c51:	ba 64 00 00 00       	mov    $0x64,%edx
    9c56:	b8 f4 00 00 00       	mov    $0xf4,%eax
    9c5b:	ee                   	out    %al,(%dx)
	wait_8042_ACK ();
    9c5c:	e8 03 00 00 00       	call   9c64 <wait_8042_ACK>
}
    9c61:	90                   	nop
    9c62:	c9                   	leave  
    9c63:	c3                   	ret    

00009c64 <wait_8042_ACK>:

static void wait_8042_ACK ()
{
    9c64:	55                   	push   %ebp
    9c65:	89 e5                	mov    %esp,%ebp
    9c67:	83 ec 10             	sub    $0x10,%esp
	while(_8042_get_status  != _8042_ACK);
    9c6a:	90                   	nop
    9c6b:	b8 64 00 00 00       	mov    $0x64,%eax
    9c70:	89 c2                	mov    %eax,%edx
    9c72:	ec                   	in     (%dx),%al
    9c73:	88 45 ff             	mov    %al,-0x1(%ebp)
    9c76:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    9c7a:	3c fa                	cmp    $0xfa,%al
    9c7c:	75 ed                	jne    9c6b <wait_8042_ACK+0x7>
    9c7e:	90                   	nop
    9c7f:	90                   	nop
    9c80:	c9                   	leave  
    9c81:	c3                   	ret    

00009c82 <create_page_table>:
/*
 *   create page table , after that we can map linear address
 * page_table will be pinted by the pagedirectore[index]
 */
void create_page_table(uint32_t* page_table, uint32_t index)
{
    9c82:	55                   	push   %ebp
    9c83:	89 e5                	mov    %esp,%ebp
    9c85:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    9c88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    9c8f:	eb 20                	jmp    9cb1 <create_page_table+0x2f>
        page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    9c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9c94:	c1 e0 0c             	shl    $0xc,%eax
    9c97:	89 c2                	mov    %eax,%edx
    9c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9c9c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    9ca3:	8b 45 08             	mov    0x8(%ebp),%eax
    9ca6:	01 c8                	add    %ecx,%eax
    9ca8:	83 ca 23             	or     $0x23,%edx
    9cab:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    9cad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    9cb1:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    9cb8:	76 d7                	jbe    9c91 <create_page_table+0xf>
                                     PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[index] =
        ((uint32_t)page_table) |
    9cba:	8b 45 08             	mov    0x8(%ebp),%eax
    9cbd:	83 c8 23             	or     $0x23,%eax
    9cc0:	89 c2                	mov    %eax,%edx
    page_directory[index] =
    9cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
    9cc5:	89 14 85 00 40 01 00 	mov    %edx,0x14000(,%eax,4)
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _FlushPagingCache_();
    9ccc:	e8 4f 16 00 00       	call   b320 <_FlushPagingCache_>
}
    9cd1:	90                   	nop
    9cd2:	c9                   	leave  
    9cd3:	c3                   	ret    

00009cd4 <init_paging>:

void init_paging()
{
    9cd4:	55                   	push   %ebp
    9cd5:	89 e5                	mov    %esp,%ebp
    9cd7:	83 ec 18             	sub    $0x18,%esp
    uint16_t i = 0;
    9cda:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)

    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    9ce0:	66 c7 45 f6 01 00    	movw   $0x1,-0xa(%ebp)
    9ce6:	eb 1a                	jmp    9d02 <init_paging+0x2e>
        page_directory[i] =
    9ce8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9cec:	c7 04 85 00 40 01 00 	movl   $0x2,0x14000(,%eax,4)
    9cf3:	02 00 00 00 
    for (i = 1; i < PAGE_DIRECTORY_OFFSET; i++)
    9cf7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9cfb:	83 c0 01             	add    $0x1,%eax
    9cfe:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    9d02:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    9d08:	76 de                	jbe    9ce8 <init_paging+0x14>
            (PAGE_PRESENT(0) | PAGE_READ_WRITE | PAGE_ACCESSED(0) | PAGE_SUPERVISOR);

    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    9d0a:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
    9d10:	eb 22                	jmp    9d34 <init_paging+0x60>
        first_page_table[i] = (i << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    9d12:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9d16:	c1 e0 0c             	shl    $0xc,%eax
    9d19:	83 c8 23             	or     $0x23,%eax
    9d1c:	89 c2                	mov    %eax,%edx
    9d1e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9d22:	89 14 85 00 c0 00 00 	mov    %edx,0xc000(,%eax,4)
    for (i = 0; i < PAGE_TABLE_OFFSET; i++)
    9d29:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    9d2d:	83 c0 01             	add    $0x1,%eax
    9d30:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    9d34:	66 81 7d f6 ff 03    	cmpw   $0x3ff,-0xa(%ebp)
    9d3a:	76 d6                	jbe    9d12 <init_paging+0x3e>
                                           PAGE_ACCESSED(1) | PAGE_SUPERVISOR);

    page_directory[0] =
        ((uint32_t)first_page_table) |
    9d3c:	b8 00 c0 00 00       	mov    $0xc000,%eax
    9d41:	83 c8 23             	or     $0x23,%eax
    page_directory[0] =
    9d44:	a3 00 40 01 00       	mov    %eax,0x14000
        (PAGE_ACCESSED(1) | PAGE_READ_WRITE | PAGE_PRESENT(1) | PAGE_SUPERVISOR);

    _EnablingPaging_();
    9d49:	e8 db 15 00 00       	call   b329 <_EnablingPaging_>
    // __RUN_TEST__(paging_test);
}
    9d4e:	90                   	nop
    9d4f:	c9                   	leave  
    9d50:	c3                   	ret    

00009d51 <get_phyaddr>:

// Conf :Intel Manual page 2897
physaddr_t get_phyaddr(virtaddr_t virtualaddr)
{
    9d51:	55                   	push   %ebp
    9d52:	89 e5                	mov    %esp,%ebp
    9d54:	83 ec 10             	sub    $0x10,%esp
    uint32_t pdindex = (uint32_t)virtualaddr >> 22;
    9d57:	8b 45 08             	mov    0x8(%ebp),%eax
    9d5a:	c1 e8 16             	shr    $0x16,%eax
    9d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    uint32_t ptindex = (uint32_t)virtualaddr >> 12 & 0x03FF;
    9d60:	8b 45 08             	mov    0x8(%ebp),%eax
    9d63:	c1 e8 0c             	shr    $0xc,%eax
    9d66:	25 ff 03 00 00       	and    $0x3ff,%eax
    9d6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    /*
      A 4-KByte naturally aligned page directory is located at the physical
       address specified in bits 31:12 of CR3
  */

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    9d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9d71:	8b 04 85 00 40 01 00 	mov    0x14000(,%eax,4),%eax
    9d78:	83 e0 23             	and    $0x23,%eax
    9d7b:	83 f8 23             	cmp    $0x23,%eax
    9d7e:	75 56                	jne    9dd6 <get_phyaddr+0x85>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    9d80:	8b 45 fc             	mov    -0x4(%ebp),%eax
    9d83:	8b 04 85 00 40 01 00 	mov    0x14000(,%eax,4),%eax
    9d8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    9d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    9d92:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9d95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    9d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9d9f:	01 d0                	add    %edx,%eax
    9da1:	8b 00                	mov    (%eax),%eax
    9da3:	83 e0 23             	and    $0x23,%eax
    9da6:	83 f8 23             	cmp    $0x23,%eax
    9da9:	75 24                	jne    9dcf <get_phyaddr+0x7e>

            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    9dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9dae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    9db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9db8:	01 d0                	add    %edx,%eax
    9dba:	8b 00                	mov    (%eax),%eax
    9dbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    9dc1:	89 c2                	mov    %eax,%edx
                                (((uint32_t)virtualaddr) & 0xFFF));
    9dc3:	8b 45 08             	mov    0x8(%ebp),%eax
    9dc6:	25 ff 0f 00 00       	and    $0xfff,%eax
            return (physaddr_t)((pt[ptindex] & 0xFFFFF000) +
    9dcb:	09 d0                	or     %edx,%eax
    9dcd:	eb 0c                	jmp    9ddb <get_phyaddr+0x8a>

        else
            return NO_PHYSICAL_ADDRESS;
    9dcf:	b8 09 17 01 00       	mov    $0x11709,%eax
    9dd4:	eb 05                	jmp    9ddb <get_phyaddr+0x8a>
    }
    else
        return NO_PHYSICAL_ADDRESS;
    9dd6:	b8 09 17 01 00       	mov    $0x11709,%eax
}
    9ddb:	c9                   	leave  
    9ddc:	c3                   	ret    

00009ddd <map_linear_address>:
 *   We wll create one page directory to map that liear address
 * If the page directory doesn't exist , we will not mapp it just .So we should create one page table before and map it with create_page_table() function
 */

void map_linear_address(virtaddr_t virtual_address)
{
    9ddd:	55                   	push   %ebp
    9dde:	89 e5                	mov    %esp,%ebp
    9de0:	83 ec 18             	sub    $0x18,%esp
    uint32_t pdindex = (uint32_t)virtual_address >> 22;
    9de3:	8b 45 08             	mov    0x8(%ebp),%eax
    9de6:	c1 e8 16             	shr    $0x16,%eax
    9de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ptindex = (uint32_t)virtual_address >> 12 & 0x03FF;
    9dec:	8b 45 08             	mov    0x8(%ebp),%eax
    9def:	c1 e8 0c             	shr    $0xc,%eax
    9df2:	25 ff 03 00 00       	and    $0x3ff,%eax
    9df7:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if ((page_directory[pdindex] & PAGE_VALID) == PAGE_VALID) {
    9dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9dfd:	8b 04 85 00 40 01 00 	mov    0x14000(,%eax,4),%eax
    9e04:	83 e0 23             	and    $0x23,%eax
    9e07:	83 f8 23             	cmp    $0x23,%eax
    9e0a:	75 4e                	jne    9e5a <map_linear_address+0x7d>
        uint32_t* pt = (uint32_t*)(page_directory[pdindex] & 0xFFFFF000);
    9e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    9e0f:	8b 04 85 00 40 01 00 	mov    0x14000(,%eax,4),%eax
    9e16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    9e1b:	89 45 ec             	mov    %eax,-0x14(%ebp)

        if ((pt[ptindex] & PAGE_VALID) == PAGE_VALID)
    9e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9e21:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    9e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9e2b:	01 d0                	add    %edx,%eax
    9e2d:	8b 00                	mov    (%eax),%eax
    9e2f:	83 e0 23             	and    $0x23,%eax
    9e32:	83 f8 23             	cmp    $0x23,%eax
    9e35:	74 26                	je     9e5d <map_linear_address+0x80>
            return; // the linear address was already mapped

        else // we create the page table
            pt[ptindex] = (ptindex << 12) | (PAGE_PRESENT(1) | PAGE_READ_WRITE |
    9e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9e3a:	c1 e0 0c             	shl    $0xc,%eax
    9e3d:	89 c2                	mov    %eax,%edx
    9e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    9e42:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    9e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
    9e4c:	01 c8                	add    %ecx,%eax
    9e4e:	83 ca 23             	or     $0x23,%edx
    9e51:	89 10                	mov    %edx,(%eax)
    }

    else
        return; // Wa can't not create one page just for it

    _FlushPagingCache_();
    9e53:	e8 c8 14 00 00       	call   b320 <_FlushPagingCache_>
    9e58:	eb 04                	jmp    9e5e <map_linear_address+0x81>
        return; // Wa can't not create one page just for it
    9e5a:	90                   	nop
    9e5b:	eb 01                	jmp    9e5e <map_linear_address+0x81>
            return; // the linear address was already mapped
    9e5d:	90                   	nop
}
    9e5e:	c9                   	leave  
    9e5f:	c3                   	ret    

00009e60 <Paging_fault>:

void Paging_fault()
{
    9e60:	55                   	push   %ebp
    9e61:	89 e5                	mov    %esp,%ebp
}
    9e63:	90                   	nop
    9e64:	5d                   	pop    %ebp
    9e65:	c3                   	ret    

00009e66 <PIC_sendEOI>:
 *	Les EOI s'applique par le maitre sur les IRQ0-IRQ7
 *	Les EOI s'applique par le maitre sur les IRQ8-IRQ15
 */

void PIC_sendEOI(uint8_t irq)
{
    9e66:	55                   	push   %ebp
    9e67:	89 e5                	mov    %esp,%ebp
    9e69:	83 ec 04             	sub    $0x4,%esp
    9e6c:	8b 45 08             	mov    0x8(%ebp),%eax
    9e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
    // IRQ for Slaves PIC
    if (irq >= 0x8)
    9e72:	80 7d fc 07          	cmpb   $0x7,-0x4(%ebp)
    9e76:	76 0b                	jbe    9e83 <PIC_sendEOI+0x1d>
        outb(PIC2_COMMAND, PIC_EOI);
    9e78:	ba a0 00 00 00       	mov    $0xa0,%edx
    9e7d:	b8 20 00 00 00       	mov    $0x20,%eax
    9e82:	ee                   	out    %al,(%dx)

    // IRQ for Master PIC
    outb(PIC1_COMMAND, PIC_EOI);
    9e83:	ba 20 00 00 00       	mov    $0x20,%edx
    9e88:	b8 20 00 00 00       	mov    $0x20,%eax
    9e8d:	ee                   	out    %al,(%dx)
}
    9e8e:	90                   	nop
    9e8f:	c9                   	leave  
    9e90:	c3                   	ret    

00009e91 <PIC_remap>:

void PIC_remap(uint8_t offset1, uint8_t offset2)
{
    9e91:	55                   	push   %ebp
    9e92:	89 e5                	mov    %esp,%ebp
    9e94:	83 ec 18             	sub    $0x18,%esp
    9e97:	8b 55 08             	mov    0x8(%ebp),%edx
    9e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
    9e9d:	88 55 ec             	mov    %dl,-0x14(%ebp)
    9ea0:	88 45 e8             	mov    %al,-0x18(%ebp)
       Word), qui permettent de paramétrer certaines opérations du contrôleur
       une fois que celui-ci a été réinitialisé.
        */

    /* Conservation des données dans les intérrupteurs */
    a1 = inb(PIC1_DATA);
    9ea3:	b8 21 00 00 00       	mov    $0x21,%eax
    9ea8:	89 c2                	mov    %eax,%edx
    9eaa:	ec                   	in     (%dx),%al
    9eab:	88 45 ff             	mov    %al,-0x1(%ebp)
    9eae:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    9eb2:	88 45 fe             	mov    %al,-0x2(%ebp)
    a2 = inb(PIC2_DATA);
    9eb5:	b8 a1 00 00 00       	mov    $0xa1,%eax
    9eba:	89 c2                	mov    %eax,%edx
    9ebc:	ec                   	in     (%dx),%al
    9ebd:	88 45 fd             	mov    %al,-0x3(%ebp)
    9ec0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    9ec4:	88 45 fc             	mov    %al,-0x4(%ebp)

    /* Initialisation ICW1*/
    /* Initialisation obligatoire ------------------*/
    outb(PIC1_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    9ec7:	ba 20 00 00 00       	mov    $0x20,%edx
    9ecc:	b8 11 00 00 00       	mov    $0x11,%eax
    9ed1:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    9ed2:	eb 00                	jmp    9ed4 <PIC_remap+0x43>
    9ed4:	eb 00                	jmp    9ed6 <PIC_remap+0x45>
    outb(PIC2_COMMAND, ICW1_ICW4 | ICW1_INIT); //
    9ed6:	ba a0 00 00 00       	mov    $0xa0,%edx
    9edb:	b8 11 00 00 00       	mov    $0x11,%eax
    9ee0:	ee                   	out    %al,(%dx)
    io_wait;                                   //
    9ee1:	eb 00                	jmp    9ee3 <PIC_remap+0x52>
    9ee3:	eb 00                	jmp    9ee5 <PIC_remap+0x54>
    /* Fin de l'initialisation -------------------*/

    /*Initialisation ICW2 ---------------------*/
    // ICW2 : Deplacement du vecteur du maitre
    outb(PIC1_DATA, offset1);
    9ee5:	ba 21 00 00 00       	mov    $0x21,%edx
    9eea:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    9eee:	ee                   	out    %al,(%dx)
    io_wait;
    9eef:	eb 00                	jmp    9ef1 <PIC_remap+0x60>
    9ef1:	eb 00                	jmp    9ef3 <PIC_remap+0x62>
    // ICW2 : deplacement du vecteur d'escalve
    outb(PIC2_DATA, offset2);
    9ef3:	ba a1 00 00 00       	mov    $0xa1,%edx
    9ef8:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    9efc:	ee                   	out    %al,(%dx)
    io_wait;
    9efd:	eb 00                	jmp    9eff <PIC_remap+0x6e>
    9eff:	eb 00                	jmp    9f01 <PIC_remap+0x70>
    /* Fin Initialisation ICW2 ----------------*/

    /*Initialisation ICW3 ----------------------*/
    // ICW3 : Dire au PIC maitre qu'il y'a un PIC esclave à IRQ2
    outb(PIC1_DATA, 4);
    9f01:	ba 21 00 00 00       	mov    $0x21,%edx
    9f06:	b8 04 00 00 00       	mov    $0x4,%eax
    9f0b:	ee                   	out    %al,(%dx)
    io_wait;
    9f0c:	eb 00                	jmp    9f0e <PIC_remap+0x7d>
    9f0e:	eb 00                	jmp    9f10 <PIC_remap+0x7f>
    // ICW3 : Dire au PIC esclave qu'il a une configuration en cascade
    outb(PIC2_DATA, 2);
    9f10:	ba a1 00 00 00       	mov    $0xa1,%edx
    9f15:	b8 02 00 00 00       	mov    $0x2,%eax
    9f1a:	ee                   	out    %al,(%dx)
    io_wait;
    9f1b:	eb 00                	jmp    9f1d <PIC_remap+0x8c>
    9f1d:	eb 00                	jmp    9f1f <PIC_remap+0x8e>
    /* Fin Initialisation ICW3 ----------------*/

    /*Initialisation ICW4 ----------------------*/
    outb(PIC1_DATA, ICW4_8086);
    9f1f:	ba 21 00 00 00       	mov    $0x21,%edx
    9f24:	b8 01 00 00 00       	mov    $0x1,%eax
    9f29:	ee                   	out    %al,(%dx)
    io_wait;
    9f2a:	eb 00                	jmp    9f2c <PIC_remap+0x9b>
    9f2c:	eb 00                	jmp    9f2e <PIC_remap+0x9d>

    outb(PIC2_DATA, ICW4_8086);
    9f2e:	ba a1 00 00 00       	mov    $0xa1,%edx
    9f33:	b8 01 00 00 00       	mov    $0x1,%eax
    9f38:	ee                   	out    %al,(%dx)
    io_wait;
    9f39:	eb 00                	jmp    9f3b <PIC_remap+0xaa>
    9f3b:	eb 00                	jmp    9f3d <PIC_remap+0xac>
    /* Fin Initialisation ICW4 ----------------*/

    // Restoration
    outb(PIC1_DATA, a1);
    9f3d:	ba 21 00 00 00       	mov    $0x21,%edx
    9f42:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
    9f46:	ee                   	out    %al,(%dx)
    outb(PIC2_DATA, a2);
    9f47:	ba a1 00 00 00       	mov    $0xa1,%edx
    9f4c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
    9f50:	ee                   	out    %al,(%dx)
}
    9f51:	90                   	nop
    9f52:	c9                   	leave  
    9f53:	c3                   	ret    

00009f54 <IRQ_set_mask>:

void IRQ_set_mask(uint8_t irqline)
{
    9f54:	55                   	push   %ebp
    9f55:	89 e5                	mov    %esp,%ebp
    9f57:	53                   	push   %ebx
    9f58:	83 ec 14             	sub    $0x14,%esp
    9f5b:	8b 45 08             	mov    0x8(%ebp),%eax
    9f5e:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t port;
    uint8_t value;

    if (irqline < 8)
    9f61:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    9f65:	77 08                	ja     9f6f <IRQ_set_mask+0x1b>
        port = PIC1_DATA;
    9f67:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
    9f6d:	eb 0a                	jmp    9f79 <IRQ_set_mask+0x25>

    else {
        port = PIC2_DATA;
    9f6f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
        irqline -= 8;
    9f75:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    /*
     *	This register is a bitmap of the request
     *	lines going into the PIC. When a bit is set,
     *	the PIC ignores the request and continues normal operation.
     */
    value = inb(port) | (1 << irqline);
    9f79:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
    9f7d:	89 c2                	mov    %eax,%edx
    9f7f:	ec                   	in     (%dx),%al
    9f80:	88 45 f9             	mov    %al,-0x7(%ebp)
    9f83:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    9f87:	89 c3                	mov    %eax,%ebx
    9f89:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    9f8d:	ba 01 00 00 00       	mov    $0x1,%edx
    9f92:	89 c1                	mov    %eax,%ecx
    9f94:	d3 e2                	shl    %cl,%edx
    9f96:	89 d0                	mov    %edx,%eax
    9f98:	09 d8                	or     %ebx,%eax
    9f9a:	88 45 f8             	mov    %al,-0x8(%ebp)

    outb(port, value);
    9f9d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
    9fa1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
    9fa5:	ee                   	out    %al,(%dx)
}
    9fa6:	90                   	nop
    9fa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    9faa:	c9                   	leave  
    9fab:	c3                   	ret    

00009fac <IRQ_clear_mask>:

void IRQ_clear_mask(uint8_t irqline)
{
    9fac:	55                   	push   %ebp
    9fad:	89 e5                	mov    %esp,%ebp
    9faf:	53                   	push   %ebx
    9fb0:	83 ec 14             	sub    $0x14,%esp
    9fb3:	8b 45 08             	mov    0x8(%ebp),%eax
    9fb6:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint8_t value;
    uint32_t port;

    if (irqline < 8)
    9fb9:	80 7d e8 07          	cmpb   $0x7,-0x18(%ebp)
    9fbd:	77 09                	ja     9fc8 <IRQ_clear_mask+0x1c>
        port = PIC1_DATA;
    9fbf:	c7 45 f8 21 00 00 00 	movl   $0x21,-0x8(%ebp)
    9fc6:	eb 0b                	jmp    9fd3 <IRQ_clear_mask+0x27>
    else {
        port = PIC2_DATA;
    9fc8:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%ebp)
        irqline -= 8;
    9fcf:	80 6d e8 08          	subb   $0x8,-0x18(%ebp)
    }
    value = inb(port) & (~(1 << irqline));
    9fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    9fd6:	89 c2                	mov    %eax,%edx
    9fd8:	ec                   	in     (%dx),%al
    9fd9:	88 45 f7             	mov    %al,-0x9(%ebp)
    9fdc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    9fe0:	89 c3                	mov    %eax,%ebx
    9fe2:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
    9fe6:	ba 01 00 00 00       	mov    $0x1,%edx
    9feb:	89 c1                	mov    %eax,%ecx
    9fed:	d3 e2                	shl    %cl,%edx
    9fef:	89 d0                	mov    %edx,%eax
    9ff1:	f7 d0                	not    %eax
    9ff3:	21 d8                	and    %ebx,%eax
    9ff5:	88 45 f6             	mov    %al,-0xa(%ebp)

    outb(port, value);
    9ff8:	8b 55 f8             	mov    -0x8(%ebp),%edx
    9ffb:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    9fff:	ee                   	out    %al,(%dx)
}
    a000:	90                   	nop
    a001:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a004:	c9                   	leave  
    a005:	c3                   	ret    

0000a006 <__pic_get_irq_reg>:

static uint16_t  __pic_get_irq_reg(uint8_t ocw3)
{
    a006:	55                   	push   %ebp
    a007:	89 e5                	mov    %esp,%ebp
    a009:	83 ec 14             	sub    $0x14,%esp
    a00c:	8b 45 08             	mov    0x8(%ebp),%eax
    a00f:	88 45 ec             	mov    %al,-0x14(%ebp)
    /*
     * OCW3 to PIC CMD to get the register value . PIC2 is chained
     *	, and represent IRQ 8-15 .
     */

    outb(PIC1_COMMAND, ocw3);
    a012:	ba 20 00 00 00       	mov    $0x20,%edx
    a017:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a01b:	ee                   	out    %al,(%dx)
    outb(PIC2_COMMAND, ocw3);
    a01c:	ba a0 00 00 00       	mov    $0xa0,%edx
    a021:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a025:	ee                   	out    %al,(%dx)

    return ((inb(PIC2_COMMAND) << 8) | inb(PIC1_COMMAND));
    a026:	b8 a0 00 00 00       	mov    $0xa0,%eax
    a02b:	89 c2                	mov    %eax,%edx
    a02d:	ec                   	in     (%dx),%al
    a02e:	88 45 ff             	mov    %al,-0x1(%ebp)
    a031:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a035:	0f b6 c0             	movzbl %al,%eax
    a038:	c1 e0 08             	shl    $0x8,%eax
    a03b:	89 c1                	mov    %eax,%ecx
    a03d:	b8 20 00 00 00       	mov    $0x20,%eax
    a042:	89 c2                	mov    %eax,%edx
    a044:	ec                   	in     (%dx),%al
    a045:	88 45 fe             	mov    %al,-0x2(%ebp)
    a048:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
    a04c:	0f b6 c0             	movzbl %al,%eax
    a04f:	09 c8                	or     %ecx,%eax
}
    a051:	c9                   	leave  
    a052:	c3                   	ret    

0000a053 <pic_get_isr>:
/*
 * the PIC will send interrupts from the IRR to the CPU, at which point they are marked in the ISR.
 */

uint16_t (pic_get_isr)()
{
    a053:	55                   	push   %ebp
    a054:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_ISR);
    a056:	6a 0b                	push   $0xb
    a058:	e8 a9 ff ff ff       	call   a006 <__pic_get_irq_reg>
    a05d:	83 c4 04             	add    $0x4,%esp
}
    a060:	c9                   	leave  
    a061:	c3                   	ret    

0000a062 <__pic_get_irr>:

uint16_t (__pic_get_irr)()
{
    a062:	55                   	push   %ebp
    a063:	89 e5                	mov    %esp,%ebp
    return __pic_get_irq_reg(PIC_READ_IRR);
    a065:	6a 0a                	push   $0xa
    a067:	e8 9a ff ff ff       	call   a006 <__pic_get_irq_reg>
    a06c:	83 c4 04             	add    $0x4,%esp
}
    a06f:	c9                   	leave  
    a070:	c3                   	ret    

0000a071 <spurious_IRQ>:


//If request getting in ISR is differnet to irq
void spurious_IRQ(uint8_t irq)
{
    a071:	55                   	push   %ebp
    a072:	89 e5                	mov    %esp,%ebp
    a074:	83 ec 14             	sub    $0x14,%esp
    a077:	8b 45 08             	mov    0x8(%ebp),%eax
    a07a:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint16_t isr_request = pic_get_isr() ;
    a07d:	e8 d1 ff ff ff       	call   a053 <pic_get_isr>
    a082:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

    //send the EOI to the master PIC because the master PIC itself 
    //won't know that it was a spurious IRQ from the slave. 

    if (isr_request != irq) PIC_sendEOI((uint8_t)(isr_request%8)) ;
    a086:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a08a:	66 39 45 fe          	cmp    %ax,-0x2(%ebp)
    a08e:	74 13                	je     a0a3 <spurious_IRQ+0x32>
    a090:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a094:	0f b6 c0             	movzbl %al,%eax
    a097:	83 e0 07             	and    $0x7,%eax
    a09a:	50                   	push   %eax
    a09b:	e8 c6 fd ff ff       	call   9e66 <PIC_sendEOI>
    a0a0:	83 c4 04             	add    $0x4,%esp
    a0a3:	90                   	nop
    a0a4:	c9                   	leave  
    a0a5:	c3                   	ret    

0000a0a6 <conserv_status_byte>:
uint32_t compteur = 0;
uint8_t frequency = 0;
uint8_t status_PIT = 0;

void conserv_status_byte()
{
    a0a6:	55                   	push   %ebp
    a0a7:	89 e5                	mov    %esp,%ebp
    a0a9:	83 ec 18             	sub    $0x18,%esp
     set_pit_count(PIT_0, PIT_reload_value);
    a0ac:	ba 43 00 00 00       	mov    $0x43,%edx
    a0b1:	b8 40 00 00 00       	mov    $0x40,%eax
    a0b6:	ee                   	out    %al,(%dx)
    a0b7:	b8 40 00 00 00       	mov    $0x40,%eax
    a0bc:	89 c2                	mov    %eax,%edx
    a0be:	ec                   	in     (%dx),%al
    a0bf:	88 45 f7             	mov    %al,-0x9(%ebp)
    a0c2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a0c6:	88 45 f2             	mov    %al,-0xe(%ebp)
    a0c9:	b8 40 00 00 00       	mov    $0x40,%eax
    a0ce:	89 c2                	mov    %eax,%edx
    a0d0:	ec                   	in     (%dx),%al
    a0d1:	88 45 f6             	mov    %al,-0xa(%ebp)
    a0d4:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a0d8:	88 45 f3             	mov    %al,-0xd(%ebp)
    a0db:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a0df:	66 98                	cbtw   
    a0e1:	ba 40 00 00 00       	mov    $0x40,%edx
    a0e6:	ee                   	out    %al,(%dx)
    a0e7:	a1 54 61 02 00       	mov    0x26154,%eax
    a0ec:	c1 f8 08             	sar    $0x8,%eax
    a0ef:	ba 40 00 00 00       	mov    $0x40,%edx
    a0f4:	ee                   	out    %al,(%dx)

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a0f5:	ba 43 00 00 00       	mov    $0x43,%edx
    a0fa:	b8 40 00 00 00       	mov    $0x40,%eax
    a0ff:	ee                   	out    %al,(%dx)
    a100:	b8 40 00 00 00       	mov    $0x40,%eax
    a105:	89 c2                	mov    %eax,%edx
    a107:	ec                   	in     (%dx),%al
    a108:	88 45 f5             	mov    %al,-0xb(%ebp)
    a10b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a10f:	88 45 f0             	mov    %al,-0x10(%ebp)
    a112:	b8 40 00 00 00       	mov    $0x40,%eax
    a117:	89 c2                	mov    %eax,%edx
    a119:	ec                   	in     (%dx),%al
    a11a:	88 45 f4             	mov    %al,-0xc(%ebp)
    a11d:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a121:	88 45 f1             	mov    %al,-0xf(%ebp)
    a124:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
    a128:	66 98                	cbtw   
    a12a:	ba 43 00 00 00       	mov    $0x43,%edx
    a12f:	ee                   	out    %al,(%dx)
    a130:	ba 43 00 00 00       	mov    $0x43,%edx
    a135:	b8 34 00 00 00       	mov    $0x34,%eax
    a13a:	ee                   	out    %al,(%dx)

    compteur++;
    a13b:	a1 00 50 01 00       	mov    0x15000,%eax
    a140:	83 c0 01             	add    $0x1,%eax
    a143:	a3 00 50 01 00       	mov    %eax,0x15000
    print_frequence(system_timer_ms);
    a148:	a1 44 61 02 00       	mov    0x26144,%eax
    a14d:	83 ec 0c             	sub    $0xc,%esp
    a150:	50                   	push   %eax
    a151:	e8 b0 02 00 00       	call   a406 <print_frequence>
    a156:	83 c4 10             	add    $0x10,%esp
}
    a159:	90                   	nop
    a15a:	c9                   	leave  
    a15b:	c3                   	ret    

0000a15c <sheduler_cpu_timer>:

void sheduler_cpu_timer()
{
    a15c:	55                   	push   %ebp
    a15d:	89 e5                	mov    %esp,%ebp
    a15f:	83 ec 08             	sub    $0x8,%esp
    if (sheduler.init_timer == 1) {
    a162:	0f b6 05 20 60 02 00 	movzbl 0x26020,%eax
    a169:	3c 01                	cmp    $0x1,%al
    a16b:	75 27                	jne    a194 <sheduler_cpu_timer+0x38>
        if (sheduler.task_timer == 0) {
    a16d:	a1 24 60 02 00       	mov    0x26024,%eax
    a172:	85 c0                	test   %eax,%eax
    a174:	75 11                	jne    a187 <sheduler_cpu_timer+0x2b>
            sheduler.task_timer = DELAY_PER_TASK;
    a176:	c7 05 24 60 02 00 2c 	movl   $0x12c,0x26024
    a17d:	01 00 00 
            __switch();
    a180:	e8 ba 0f 00 00       	call   b13f <__switch>
        }
        else
            sheduler.task_timer--;
    }
}
    a185:	eb 0d                	jmp    a194 <sheduler_cpu_timer+0x38>
            sheduler.task_timer--;
    a187:	a1 24 60 02 00       	mov    0x26024,%eax
    a18c:	83 e8 01             	sub    $0x1,%eax
    a18f:	a3 24 60 02 00       	mov    %eax,0x26024
}
    a194:	90                   	nop
    a195:	c9                   	leave  
    a196:	c3                   	ret    

0000a197 <Init_PIT>:

void Init_PIT(uint16_t frequence)
{
    a197:	55                   	push   %ebp
    a198:	89 e5                	mov    %esp,%ebp
    a19a:	83 ec 28             	sub    $0x28,%esp
    a19d:	8b 45 08             	mov    0x8(%ebp),%eax
    a1a0:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
       -send Mode or command register  to select which channel will be configured

       -send data to a good channel

       */
    frequency = frequence;
    a1a4:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
    a1a8:	a2 04 50 01 00       	mov    %al,0x15004
    calculate_frequency();
    a1ad:	e8 da 11 00 00       	call   b38c <calculate_frequency>

    pit_send_command(BCD_BINARY_MODE(0) | OPERATING_MODE(2) | ACCESS_MODE(3) | CHANNEL_0);
    a1b2:	ba 43 00 00 00       	mov    $0x43,%edx
    a1b7:	b8 40 00 00 00       	mov    $0x40,%eax
    a1bc:	ee                   	out    %al,(%dx)
    a1bd:	b8 40 00 00 00       	mov    $0x40,%eax
    a1c2:	89 c2                	mov    %eax,%edx
    a1c4:	ec                   	in     (%dx),%al
    a1c5:	88 45 f7             	mov    %al,-0x9(%ebp)
    a1c8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a1cc:	88 45 f2             	mov    %al,-0xe(%ebp)
    a1cf:	b8 40 00 00 00       	mov    $0x40,%eax
    a1d4:	89 c2                	mov    %eax,%edx
    a1d6:	ec                   	in     (%dx),%al
    a1d7:	88 45 f6             	mov    %al,-0xa(%ebp)
    a1da:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    a1de:	88 45 f3             	mov    %al,-0xd(%ebp)
    a1e1:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
    a1e5:	66 98                	cbtw   
    a1e7:	ba 43 00 00 00       	mov    $0x43,%edx
    a1ec:	ee                   	out    %al,(%dx)
    a1ed:	ba 43 00 00 00       	mov    $0x43,%edx
    a1f2:	b8 34 00 00 00       	mov    $0x34,%eax
    a1f7:	ee                   	out    %al,(%dx)

    set_pit_count(PIT_0, PIT_reload_value);
    a1f8:	ba 43 00 00 00       	mov    $0x43,%edx
    a1fd:	b8 40 00 00 00       	mov    $0x40,%eax
    a202:	ee                   	out    %al,(%dx)
    a203:	b8 40 00 00 00       	mov    $0x40,%eax
    a208:	89 c2                	mov    %eax,%edx
    a20a:	ec                   	in     (%dx),%al
    a20b:	88 45 f5             	mov    %al,-0xb(%ebp)
    a20e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    a212:	88 45 f0             	mov    %al,-0x10(%ebp)
    a215:	b8 40 00 00 00       	mov    $0x40,%eax
    a21a:	89 c2                	mov    %eax,%edx
    a21c:	ec                   	in     (%dx),%al
    a21d:	88 45 f4             	mov    %al,-0xc(%ebp)
    a220:	0f b6 45 f4          	movzbl -0xc(%ebp),%eax
    a224:	88 45 f1             	mov    %al,-0xf(%ebp)
    a227:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
    a22b:	66 98                	cbtw   
    a22d:	ba 40 00 00 00       	mov    $0x40,%edx
    a232:	ee                   	out    %al,(%dx)
    a233:	a1 54 61 02 00       	mov    0x26154,%eax
    a238:	c1 f8 08             	sar    $0x8,%eax
    a23b:	ba 40 00 00 00       	mov    $0x40,%edx
    a240:	ee                   	out    %al,(%dx)
}
    a241:	90                   	nop
    a242:	c9                   	leave  
    a243:	c3                   	ret    

0000a244 <read_back_channel>:

// We should send command before read PIT channel

int8_t read_back_channel(int8_t channel)
{
    a244:	55                   	push   %ebp
    a245:	89 e5                	mov    %esp,%ebp
    a247:	83 ec 14             	sub    $0x14,%esp
    a24a:	8b 45 08             	mov    0x8(%ebp),%eax
    a24d:	88 45 ec             	mov    %al,-0x14(%ebp)
    uint8_t command = 0x00;
    a250:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    switch (channel) {
    a254:	0f be 45 ec          	movsbl -0x14(%ebp),%eax
    a258:	83 f8 42             	cmp    $0x42,%eax
    a25b:	74 1d                	je     a27a <read_back_channel+0x36>
    a25d:	83 f8 42             	cmp    $0x42,%eax
    a260:	7f 1e                	jg     a280 <read_back_channel+0x3c>
    a262:	83 f8 40             	cmp    $0x40,%eax
    a265:	74 07                	je     a26e <read_back_channel+0x2a>
    a267:	83 f8 41             	cmp    $0x41,%eax
    a26a:	74 08                	je     a274 <read_back_channel+0x30>

    case PIT_2:
        command |= READ_BACK_TIMER_2(1);
        break;
    default:
        break;
    a26c:	eb 12                	jmp    a280 <read_back_channel+0x3c>
        command |= READ_BACK_TIMER_0(1);
    a26e:	80 4d ff 02          	orb    $0x2,-0x1(%ebp)
        break;
    a272:	eb 0d                	jmp    a281 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_1(1);
    a274:	80 4d ff 04          	orb    $0x4,-0x1(%ebp)
        break;
    a278:	eb 07                	jmp    a281 <read_back_channel+0x3d>
        command |= READ_BACK_TIMER_2(1);
    a27a:	80 4d ff 08          	orb    $0x8,-0x1(%ebp)
        break;
    a27e:	eb 01                	jmp    a281 <read_back_channel+0x3d>
        break;
    a280:	90                   	nop
    }

    command |= LATCH_STATUS_FLAG(0) | LATCH_COUNT_FLAG(0) | READ_BACK_COMMAND;
    a281:	80 4d ff c0          	orb    $0xc0,-0x1(%ebp)

    pit_send_command((uint8_t)command);
    a285:	ba 43 00 00 00       	mov    $0x43,%edx
    a28a:	b8 40 00 00 00       	mov    $0x40,%eax
    a28f:	ee                   	out    %al,(%dx)
    a290:	b8 40 00 00 00       	mov    $0x40,%eax
    a295:	89 c2                	mov    %eax,%edx
    a297:	ec                   	in     (%dx),%al
    a298:	88 45 fe             	mov    %al,-0x2(%ebp)
    a29b:	0f b6 45 fe          	movzbl -0x2(%ebp),%eax
    a29f:	88 45 f9             	mov    %al,-0x7(%ebp)
    a2a2:	b8 40 00 00 00       	mov    $0x40,%eax
    a2a7:	89 c2                	mov    %eax,%edx
    a2a9:	ec                   	in     (%dx),%al
    a2aa:	88 45 fd             	mov    %al,-0x3(%ebp)
    a2ad:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
    a2b1:	88 45 fa             	mov    %al,-0x6(%ebp)
    a2b4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    a2b8:	66 98                	cbtw   
    a2ba:	ba 43 00 00 00       	mov    $0x43,%edx
    a2bf:	ee                   	out    %al,(%dx)
    a2c0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a2c4:	c1 f8 08             	sar    $0x8,%eax
    a2c7:	ba 43 00 00 00       	mov    $0x43,%edx
    a2cc:	ee                   	out    %al,(%dx)

    return read_pit_count(PIT_0);
    a2cd:	ba 43 00 00 00       	mov    $0x43,%edx
    a2d2:	b8 40 00 00 00       	mov    $0x40,%eax
    a2d7:	ee                   	out    %al,(%dx)
    a2d8:	b8 40 00 00 00       	mov    $0x40,%eax
    a2dd:	89 c2                	mov    %eax,%edx
    a2df:	ec                   	in     (%dx),%al
    a2e0:	88 45 fc             	mov    %al,-0x4(%ebp)
    a2e3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
    a2e7:	88 45 f7             	mov    %al,-0x9(%ebp)
    a2ea:	b8 40 00 00 00       	mov    $0x40,%eax
    a2ef:	89 c2                	mov    %eax,%edx
    a2f1:	ec                   	in     (%dx),%al
    a2f2:	88 45 fb             	mov    %al,-0x5(%ebp)
    a2f5:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
    a2f9:	88 45 f8             	mov    %al,-0x8(%ebp)
    a2fc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a300:	66 98                	cbtw   
    a302:	c9                   	leave  
    a303:	c3                   	ret    

0000a304 <do_checksum>:
#include <init/rsdp.h>
#include <init/video.h>
#include <string.h>

volatile uint32_t do_checksum(RSDPDesc_ext_t* tableHeader)
{
    a304:	55                   	push   %ebp
    a305:	89 e5                	mov    %esp,%ebp
    a307:	83 ec 10             	sub    $0x10,%esp
    unsigned char sum = 0;
    a30a:	c6 45 ff 00          	movb   $0x0,-0x1(%ebp)

    for (int i = 0; i < tableHeader->length; i++) {
    a30e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    a315:	eb 12                	jmp    a329 <do_checksum+0x25>
        sum += ((char*)tableHeader)[i];
    a317:	8b 55 f8             	mov    -0x8(%ebp),%edx
    a31a:	8b 45 08             	mov    0x8(%ebp),%eax
    a31d:	01 d0                	add    %edx,%eax
    a31f:	0f b6 00             	movzbl (%eax),%eax
    a322:	00 45 ff             	add    %al,-0x1(%ebp)
    for (int i = 0; i < tableHeader->length; i++) {
    a325:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    a329:	8b 45 08             	mov    0x8(%ebp),%eax
    a32c:	8b 50 14             	mov    0x14(%eax),%edx
    a32f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a332:	39 c2                	cmp    %eax,%edx
    a334:	77 e1                	ja     a317 <do_checksum+0x13>
    }

    return sum == 0;
    a336:	80 7d ff 00          	cmpb   $0x0,-0x1(%ebp)
    a33a:	0f 94 c0             	sete   %al
    a33d:	0f b6 c0             	movzbl %al,%eax
}
    a340:	c9                   	leave  
    a341:	c3                   	ret    

0000a342 <detecting_RSDP>:
// Decting the RSDP In the extended BIOS Data Area
// SO we should validate some field and deduce it

// Only for BIOS systems
RSDPDesc_ext_t* detecting_RSDP()
{
    a342:	55                   	push   %ebp
    a343:	89 e5                	mov    %esp,%ebp
    a345:	83 ec 18             	sub    $0x18,%esp
    int* t = (int*)0x000E0000;
    a348:	c7 45 f4 00 00 0e 00 	movl   $0xe0000,-0xc(%ebp)

    char signature[] = "RSD PTR ";
    a34f:	c7 45 eb 52 53 44 20 	movl   $0x20445352,-0x15(%ebp)
    a356:	c7 45 ef 50 54 52 20 	movl   $0x20525450,-0x11(%ebp)
    a35d:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)

    while (t <= (int*)0x000FFFFF) {
    a361:	eb 30                	jmp    a393 <detecting_RSDP+0x51>
        if (_memcmp_(t, signature, sizeof(signature))) {
    a363:	83 ec 04             	sub    $0x4,%esp
    a366:	6a 09                	push   $0x9
    a368:	8d 45 eb             	lea    -0x15(%ebp),%eax
    a36b:	50                   	push   %eax
    a36c:	ff 75 f4             	pushl  -0xc(%ebp)
    a36f:	e8 49 ee ff ff       	call   91bd <_memcmp_>
    a374:	83 c4 10             	add    $0x10,%esp
    a377:	85 c0                	test   %eax,%eax
    a379:	74 14                	je     a38f <detecting_RSDP+0x4d>
            kprintf(2, 11, "RSDP Detected\n");
    a37b:	83 ec 04             	sub    $0x4,%esp
    a37e:	68 14 17 01 00       	push   $0x11714
    a383:	6a 0b                	push   $0xb
    a385:	6a 02                	push   $0x2
    a387:	e8 dc 00 00 00       	call   a468 <kprintf>
    a38c:	83 c4 10             	add    $0x10,%esp
        }
        t++;
    a38f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
    while (t <= (int*)0x000FFFFF) {
    a393:	81 7d f4 ff ff 0f 00 	cmpl   $0xfffff,-0xc(%ebp)
    a39a:	76 c7                	jbe    a363 <detecting_RSDP+0x21>
    }
    if (t > (int*)0x000FFFFF)
    a39c:	81 7d f4 ff ff 0f 00 	cmpl   $0xfffff,-0xc(%ebp)
    a3a3:	76 1e                	jbe    a3c3 <detecting_RSDP+0x81>
        kprintf(4, ADVICE_COLOR, "RSDP doesn't exist on this area : [% ... %]\n",
    a3a5:	83 ec 0c             	sub    $0xc,%esp
    a3a8:	68 ff ff 0f 00       	push   $0xfffff
    a3ad:	68 00 00 0e 00       	push   $0xe0000
    a3b2:	68 24 17 01 00       	push   $0x11724
    a3b7:	6a 06                	push   $0x6
    a3b9:	6a 04                	push   $0x4
    a3bb:	e8 a8 00 00 00       	call   a468 <kprintf>
    a3c0:	83 c4 20             	add    $0x20,%esp
                0x000E0000, 0x000FFFFF);
    a3c3:	90                   	nop
    a3c4:	c9                   	leave  
    a3c5:	c3                   	ret    

0000a3c6 <pepper_screen>:

static int CURSOR_Y = 0;
static int CURSOR_X = 0;

void volatile pepper_screen()
{
    a3c6:	55                   	push   %ebp
    a3c7:	89 e5                	mov    %esp,%ebp
    a3c9:	83 ec 10             	sub    $0x10,%esp
    unsigned char* screen = (unsigned char*)(VIDEO_MEM);
    a3cc:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
    int i = 0;
    a3d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (i != 160 * 24) {
    a3da:	eb 1d                	jmp    a3f9 <pepper_screen+0x33>
        screen[i] = ' ';
    a3dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a3df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a3e2:	01 d0                	add    %edx,%eax
    a3e4:	c6 00 20             	movb   $0x20,(%eax)
        screen[i + 1] = 0x0;
    a3e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a3ea:	8d 50 01             	lea    0x1(%eax),%edx
    a3ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a3f0:	01 d0                	add    %edx,%eax
    a3f2:	c6 00 00             	movb   $0x0,(%eax)
        i += 2;
    a3f5:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    while (i != 160 * 24) {
    a3f9:	81 7d fc 00 0f 00 00 	cmpl   $0xf00,-0x4(%ebp)
    a400:	75 da                	jne    a3dc <pepper_screen+0x16>
    }
}
    a402:	90                   	nop
    a403:	90                   	nop
    a404:	c9                   	leave  
    a405:	c3                   	ret    

0000a406 <print_frequence>:

void volatile print_frequence(unsigned int freq)
{
    a406:	55                   	push   %ebp
    a407:	89 e5                	mov    %esp,%ebp
    a409:	83 ec 10             	sub    $0x10,%esp
    unsigned char* pos = (unsigned char*)(VIDEO_MEM + 160 * 25 - 10);
    a40c:	c7 45 f8 96 8f 0b 00 	movl   $0xb8f96,-0x8(%ebp)
    unsigned char i = 10;
    a413:	c6 45 ff 0a          	movb   $0xa,-0x1(%ebp)

    while (i > 0) {
    a417:	eb 45                	jmp    a45e <print_frequence+0x58>
        freq %= 10;
    a419:	8b 4d 08             	mov    0x8(%ebp),%ecx
    a41c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    a421:	89 c8                	mov    %ecx,%eax
    a423:	f7 e2                	mul    %edx
    a425:	c1 ea 03             	shr    $0x3,%edx
    a428:	89 d0                	mov    %edx,%eax
    a42a:	c1 e0 02             	shl    $0x2,%eax
    a42d:	01 d0                	add    %edx,%eax
    a42f:	01 c0                	add    %eax,%eax
    a431:	29 c1                	sub    %eax,%ecx
    a433:	89 ca                	mov    %ecx,%edx
    a435:	89 55 08             	mov    %edx,0x8(%ebp)
        pos[i] = (freq) + 0x30;
    a438:	8b 45 08             	mov    0x8(%ebp),%eax
    a43b:	89 c1                	mov    %eax,%ecx
    a43d:	0f b6 55 ff          	movzbl -0x1(%ebp),%edx
    a441:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a444:	01 d0                	add    %edx,%eax
    a446:	8d 51 30             	lea    0x30(%ecx),%edx
    a449:	88 10                	mov    %dl,(%eax)
        pos[i + 1] = ADVICE_COLOR;
    a44b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    a44f:	8d 50 01             	lea    0x1(%eax),%edx
    a452:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a455:	01 d0                	add    %edx,%eax
    a457:	c6 00 06             	movb   $0x6,(%eax)
        i -= 2;
    a45a:	80 6d ff 02          	subb   $0x2,-0x1(%ebp)
    while (i > 0) {
    a45e:	80 7d ff 00          	cmpb   $0x0,-0x1(%ebp)
    a462:	75 b5                	jne    a419 <print_frequence+0x13>
    }
}
    a464:	90                   	nop
    a465:	90                   	nop
    a466:	c9                   	leave  
    a467:	c3                   	ret    

0000a468 <kprintf>:

void volatile kprintf(int nmber_param, ...)
{
    a468:	55                   	push   %ebp
    a469:	89 e5                	mov    %esp,%ebp
    a46b:	53                   	push   %ebx
    a46c:	83 ec 24             	sub    $0x24,%esp
    a46f:	89 e0                	mov    %esp,%eax
    a471:	89 c3                	mov    %eax,%ebx
    int val = 0;
    a473:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    va_list ap;
    int i, tab_param[nmber_param];
    a47a:	8b 45 08             	mov    0x8(%ebp),%eax
    a47d:	8d 50 ff             	lea    -0x1(%eax),%edx
    a480:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    a483:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    a48a:	b8 10 00 00 00       	mov    $0x10,%eax
    a48f:	83 e8 01             	sub    $0x1,%eax
    a492:	01 d0                	add    %edx,%eax
    a494:	b9 10 00 00 00       	mov    $0x10,%ecx
    a499:	ba 00 00 00 00       	mov    $0x0,%edx
    a49e:	f7 f1                	div    %ecx
    a4a0:	6b c0 10             	imul   $0x10,%eax,%eax
    a4a3:	29 c4                	sub    %eax,%esp
    a4a5:	89 e0                	mov    %esp,%eax
    a4a7:	83 c0 03             	add    $0x3,%eax
    a4aa:	c1 e8 02             	shr    $0x2,%eax
    a4ad:	c1 e0 02             	shl    $0x2,%eax
    a4b0:	89 45 e0             	mov    %eax,-0x20(%ebp)

    va_start(ap, nmber_param);
    a4b3:	8d 45 0c             	lea    0xc(%ebp),%eax
    a4b6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    for (i = 0; i < nmber_param; i++) {
    a4b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    a4c0:	eb 18                	jmp    a4da <kprintf+0x72>
        tab_param[i] = va_arg(ap, int);
    a4c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
    a4c5:	8d 50 04             	lea    0x4(%eax),%edx
    a4c8:	89 55 d8             	mov    %edx,-0x28(%ebp)
    a4cb:	8b 08                	mov    (%eax),%ecx
    a4cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
    a4d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
    a4d3:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    for (i = 0; i < nmber_param; i++) {
    a4d6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    a4da:	8b 45 ec             	mov    -0x14(%ebp),%eax
    a4dd:	3b 45 08             	cmp    0x8(%ebp),%eax
    a4e0:	7c e0                	jl     a4c2 <kprintf+0x5a>
    }

    unsigned char color = (unsigned char)tab_param[0];
    a4e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
    a4e5:	8b 00                	mov    (%eax),%eax
    a4e7:	88 45 df             	mov    %al,-0x21(%ebp)
    char* string;

    string = (char*)tab_param[1];
    a4ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
    a4ed:	8b 40 04             	mov    0x4(%eax),%eax
    a4f0:	89 45 f0             	mov    %eax,-0x10(%ebp)

    unsigned char j = 2;
    a4f3:	c6 45 f7 02          	movb   $0x2,-0x9(%ebp)

    while (*string) {
    a4f7:	eb 51                	jmp    a54a <kprintf+0xe2>
        if (*string == '%') {
    a4f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a4fc:	0f b6 00             	movzbl (%eax),%eax
    a4ff:	3c 25                	cmp    $0x25,%al
    a501:	75 29                	jne    a52c <kprintf+0xc4>
            print_address(color, tab_param[j]);
    a503:	0f b6 55 f7          	movzbl -0x9(%ebp),%edx
    a507:	8b 45 e0             	mov    -0x20(%ebp),%eax
    a50a:	8b 04 90             	mov    (%eax,%edx,4),%eax
    a50d:	89 c2                	mov    %eax,%edx
    a50f:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
    a513:	83 ec 08             	sub    $0x8,%esp
    a516:	52                   	push   %edx
    a517:	50                   	push   %eax
    a518:	e8 e5 01 00 00       	call   a702 <print_address>
    a51d:	83 c4 10             	add    $0x10,%esp
            j++;
    a520:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    a524:	83 c0 01             	add    $0x1,%eax
    a527:	88 45 f7             	mov    %al,-0x9(%ebp)
    a52a:	eb 1a                	jmp    a546 <kprintf+0xde>
        }
        else
            putchar(color, *string);
    a52c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a52f:	0f b6 00             	movzbl (%eax),%eax
    a532:	0f b6 d0             	movzbl %al,%edx
    a535:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
    a539:	83 ec 08             	sub    $0x8,%esp
    a53c:	52                   	push   %edx
    a53d:	50                   	push   %eax
    a53e:	e8 a1 00 00 00       	call   a5e4 <putchar>
    a543:	83 c4 10             	add    $0x10,%esp

        string++;
    a546:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (*string) {
    a54a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    a54d:	0f b6 00             	movzbl (%eax),%eax
    a550:	84 c0                	test   %al,%al
    a552:	75 a5                	jne    a4f9 <kprintf+0x91>
    a554:	89 dc                	mov    %ebx,%esp
    }

    va_end(ap);
}
    a556:	90                   	nop
    a557:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    a55a:	c9                   	leave  
    a55b:	c3                   	ret    

0000a55c <scrollup>:

void volatile scrollup()
{
    a55c:	55                   	push   %ebp
    a55d:	89 e5                	mov    %esp,%ebp
    a55f:	81 ec b0 00 00 00    	sub    $0xb0,%esp
    unsigned char* v = (unsigned char*)(VIDEO_MEM + 3840);
    a565:	c7 45 f8 00 8f 0b 00 	movl   $0xb8f00,-0x8(%ebp)
    unsigned char b[160];
    int i;
    for (i = 0; i < 160; i++)
    a56c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    a573:	eb 1c                	jmp    a591 <scrollup+0x35>
        b[i] = v[i];
    a575:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a578:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a57b:	01 d0                	add    %edx,%eax
    a57d:	0f b6 00             	movzbl (%eax),%eax
    a580:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    a586:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a589:	01 ca                	add    %ecx,%edx
    a58b:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    a58d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    a591:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    a598:	7e db                	jle    a575 <scrollup+0x19>

    pepper_screen();
    a59a:	e8 27 fe ff ff       	call   a3c6 <pepper_screen>

    v = (unsigned char*)(VIDEO_MEM);
    a59f:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)

    for (i = 0; i < 160; i++)
    a5a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    a5ad:	eb 1c                	jmp    a5cb <scrollup+0x6f>
        v[i] = b[i];
    a5af:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a5b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a5b5:	01 c2                	add    %eax,%edx
    a5b7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    a5bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a5c0:	01 c8                	add    %ecx,%eax
    a5c2:	0f b6 00             	movzbl (%eax),%eax
    a5c5:	88 02                	mov    %al,(%edx)
    for (i = 0; i < 160; i++)
    a5c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    a5cb:	81 7d fc 9f 00 00 00 	cmpl   $0x9f,-0x4(%ebp)
    a5d2:	7e db                	jle    a5af <scrollup+0x53>

    CURSOR_Y++;
    a5d4:	a1 08 50 01 00       	mov    0x15008,%eax
    a5d9:	83 c0 01             	add    $0x1,%eax
    a5dc:	a3 08 50 01 00       	mov    %eax,0x15008
}
    a5e1:	90                   	nop
    a5e2:	c9                   	leave  
    a5e3:	c3                   	ret    

0000a5e4 <putchar>:

void volatile putchar(unsigned char color, unsigned const char c)
{
    a5e4:	55                   	push   %ebp
    a5e5:	89 e5                	mov    %esp,%ebp
    a5e7:	83 ec 18             	sub    $0x18,%esp
    a5ea:	8b 55 08             	mov    0x8(%ebp),%edx
    a5ed:	8b 45 0c             	mov    0xc(%ebp),%eax
    a5f0:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a5f3:	88 45 e8             	mov    %al,-0x18(%ebp)
    if (c == '\n') {
    a5f6:	80 7d e8 0a          	cmpb   $0xa,-0x18(%ebp)
    a5fa:	75 1c                	jne    a618 <putchar+0x34>
        CURSOR_X = 0;
    a5fc:	c7 05 0c 50 01 00 00 	movl   $0x0,0x1500c
    a603:	00 00 00 
        CURSOR_Y++;
    a606:	a1 08 50 01 00       	mov    0x15008,%eax
    a60b:	83 c0 01             	add    $0x1,%eax
    a60e:	a3 08 50 01 00       	mov    %eax,0x15008
            *(v) = c;
            *(v + 1) = color;
            CURSOR_X++;
        }
    }
}
    a613:	e9 e7 00 00 00       	jmp    a6ff <putchar+0x11b>
    else if(c == 0x0D) {
    a618:	80 7d e8 0d          	cmpb   $0xd,-0x18(%ebp)
    a61c:	75 3a                	jne    a658 <putchar+0x74>
        CURSOR_X--;
    a61e:	a1 0c 50 01 00       	mov    0x1500c,%eax
    a623:	83 e8 01             	sub    $0x1,%eax
    a626:	a3 0c 50 01 00       	mov    %eax,0x1500c
        unsigned char* v = (unsigned char*)(VIDEO_MEM + CURSOR_X * 2 + 160 * CURSOR_Y);
    a62b:	a1 0c 50 01 00       	mov    0x1500c,%eax
    a630:	8d 88 00 c0 05 00    	lea    0x5c000(%eax),%ecx
    a636:	8b 15 08 50 01 00    	mov    0x15008,%edx
    a63c:	89 d0                	mov    %edx,%eax
    a63e:	c1 e0 02             	shl    $0x2,%eax
    a641:	01 d0                	add    %edx,%eax
    a643:	c1 e0 04             	shl    $0x4,%eax
    a646:	01 c8                	add    %ecx,%eax
    a648:	01 c0                	add    %eax,%eax
    a64a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        *v = ' ';
    a64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a650:	c6 00 20             	movb   $0x20,(%eax)
}
    a653:	e9 a7 00 00 00       	jmp    a6ff <putchar+0x11b>
    else if (c == '\t')
    a658:	80 7d e8 09          	cmpb   $0x9,-0x18(%ebp)
    a65c:	75 12                	jne    a670 <putchar+0x8c>
        CURSOR_X += 5;
    a65e:	a1 0c 50 01 00       	mov    0x1500c,%eax
    a663:	83 c0 05             	add    $0x5,%eax
    a666:	a3 0c 50 01 00       	mov    %eax,0x1500c
}
    a66b:	e9 8f 00 00 00       	jmp    a6ff <putchar+0x11b>
        unsigned char* v = (unsigned char*)(VIDEO_MEM + CURSOR_X * 2 + 160 * CURSOR_Y);
    a670:	a1 0c 50 01 00       	mov    0x1500c,%eax
    a675:	8d 88 00 c0 05 00    	lea    0x5c000(%eax),%ecx
    a67b:	8b 15 08 50 01 00    	mov    0x15008,%edx
    a681:	89 d0                	mov    %edx,%eax
    a683:	c1 e0 02             	shl    $0x2,%eax
    a686:	01 d0                	add    %edx,%eax
    a688:	c1 e0 04             	shl    $0x4,%eax
    a68b:	01 c8                	add    %ecx,%eax
    a68d:	01 c0                	add    %eax,%eax
    a68f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (c == '\n' || CURSOR_X == 80) {
    a692:	80 7d e8 0a          	cmpb   $0xa,-0x18(%ebp)
    a696:	74 0a                	je     a6a2 <putchar+0xbe>
    a698:	a1 0c 50 01 00       	mov    0x1500c,%eax
    a69d:	83 f8 50             	cmp    $0x50,%eax
    a6a0:	75 3b                	jne    a6dd <putchar+0xf9>
            CURSOR_X = 0;
    a6a2:	c7 05 0c 50 01 00 00 	movl   $0x0,0x1500c
    a6a9:	00 00 00 
            CURSOR_Y++;
    a6ac:	a1 08 50 01 00       	mov    0x15008,%eax
    a6b1:	83 c0 01             	add    $0x1,%eax
    a6b4:	a3 08 50 01 00       	mov    %eax,0x15008
            *(v) = c;
    a6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a6bc:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    a6c0:	88 10                	mov    %dl,(%eax)
            *(v + 1) = color;
    a6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a6c5:	8d 50 01             	lea    0x1(%eax),%edx
    a6c8:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a6cc:	88 02                	mov    %al,(%edx)
            CURSOR_X++;
    a6ce:	a1 0c 50 01 00       	mov    0x1500c,%eax
    a6d3:	83 c0 01             	add    $0x1,%eax
    a6d6:	a3 0c 50 01 00       	mov    %eax,0x1500c
}
    a6db:	eb 22                	jmp    a6ff <putchar+0x11b>
            *(v) = c;
    a6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a6e0:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    a6e4:	88 10                	mov    %dl,(%eax)
            *(v + 1) = color;
    a6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a6e9:	8d 50 01             	lea    0x1(%eax),%edx
    a6ec:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a6f0:	88 02                	mov    %al,(%edx)
            CURSOR_X++;
    a6f2:	a1 0c 50 01 00       	mov    0x1500c,%eax
    a6f7:	83 c0 01             	add    $0x1,%eax
    a6fa:	a3 0c 50 01 00       	mov    %eax,0x1500c
}
    a6ff:	90                   	nop
    a700:	c9                   	leave  
    a701:	c3                   	ret    

0000a702 <print_address>:

void volatile print_address(unsigned char color, unsigned int adress__)
{
    a702:	55                   	push   %ebp
    a703:	89 e5                	mov    %esp,%ebp
    a705:	83 ec 24             	sub    $0x24,%esp
    a708:	8b 45 08             	mov    0x8(%ebp),%eax
    a70b:	88 45 dc             	mov    %al,-0x24(%ebp)
    char p[10] = {0};
    a70e:	c7 45 ee 00 00 00 00 	movl   $0x0,-0x12(%ebp)
    a715:	c7 45 f2 00 00 00 00 	movl   $0x0,-0xe(%ebp)
    a71c:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)


    if (CURSOR_Y >= 25) {
    a722:	a1 08 50 01 00       	mov    0x15008,%eax
    a727:	83 f8 18             	cmp    $0x18,%eax
    a72a:	7e 1e                	jle    a74a <print_address+0x48>
        scrollup();
    a72c:	e8 2b fe ff ff       	call   a55c <scrollup>
        CURSOR_X = 0;
    a731:	c7 05 0c 50 01 00 00 	movl   $0x0,0x1500c
    a738:	00 00 00 
        CURSOR_Y = 0;
    a73b:	c7 05 08 50 01 00 00 	movl   $0x0,0x15008
    a742:	00 00 00 
                p[10 - i] |= (char)(adress__ + 0x30);
        }
        for (i = 0; i < 10; i++)
            putchar(color, p[i]);
    }
}
    a745:	e9 65 01 00 00       	jmp    a8af <print_address+0x1ad>
        c = adress__;
    a74a:	8b 45 0c             	mov    0xc(%ebp),%eax
    a74d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        for (i = 1; i <= 8; i++) {
    a750:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    a757:	e9 1a 01 00 00       	jmp    a876 <print_address+0x174>
            adress__ = c % 16;
    a75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a75f:	83 e0 0f             	and    $0xf,%eax
    a762:	89 45 0c             	mov    %eax,0xc(%ebp)
            c /= 16;
    a765:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a768:	c1 e8 04             	shr    $0x4,%eax
    a76b:	89 45 f8             	mov    %eax,-0x8(%ebp)
            if (adress__ == 15)
    a76e:	83 7d 0c 0f          	cmpl   $0xf,0xc(%ebp)
    a772:	75 21                	jne    a795 <print_address+0x93>
                p[10 - i] |= 'f';
    a774:	b8 0a 00 00 00       	mov    $0xa,%eax
    a779:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a77c:	0f b6 54 05 ee       	movzbl -0x12(%ebp,%eax,1),%edx
    a781:	b8 0a 00 00 00       	mov    $0xa,%eax
    a786:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a789:	83 ca 66             	or     $0x66,%edx
    a78c:	88 54 05 ee          	mov    %dl,-0x12(%ebp,%eax,1)
    a790:	e9 dd 00 00 00       	jmp    a872 <print_address+0x170>
            else if (adress__ == 14)
    a795:	83 7d 0c 0e          	cmpl   $0xe,0xc(%ebp)
    a799:	75 21                	jne    a7bc <print_address+0xba>
                p[10 - i] |= 'e';
    a79b:	b8 0a 00 00 00       	mov    $0xa,%eax
    a7a0:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a7a3:	0f b6 54 05 ee       	movzbl -0x12(%ebp,%eax,1),%edx
    a7a8:	b8 0a 00 00 00       	mov    $0xa,%eax
    a7ad:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a7b0:	83 ca 65             	or     $0x65,%edx
    a7b3:	88 54 05 ee          	mov    %dl,-0x12(%ebp,%eax,1)
    a7b7:	e9 b6 00 00 00       	jmp    a872 <print_address+0x170>
            else if (adress__ == 13)
    a7bc:	83 7d 0c 0d          	cmpl   $0xd,0xc(%ebp)
    a7c0:	75 21                	jne    a7e3 <print_address+0xe1>
                p[10 - i] |= 'd';
    a7c2:	b8 0a 00 00 00       	mov    $0xa,%eax
    a7c7:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a7ca:	0f b6 54 05 ee       	movzbl -0x12(%ebp,%eax,1),%edx
    a7cf:	b8 0a 00 00 00       	mov    $0xa,%eax
    a7d4:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a7d7:	83 ca 64             	or     $0x64,%edx
    a7da:	88 54 05 ee          	mov    %dl,-0x12(%ebp,%eax,1)
    a7de:	e9 8f 00 00 00       	jmp    a872 <print_address+0x170>
            else if (adress__ == 12)
    a7e3:	83 7d 0c 0c          	cmpl   $0xc,0xc(%ebp)
    a7e7:	75 1e                	jne    a807 <print_address+0x105>
                p[10 - i] |= 'c';
    a7e9:	b8 0a 00 00 00       	mov    $0xa,%eax
    a7ee:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a7f1:	0f b6 54 05 ee       	movzbl -0x12(%ebp,%eax,1),%edx
    a7f6:	b8 0a 00 00 00       	mov    $0xa,%eax
    a7fb:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a7fe:	83 ca 63             	or     $0x63,%edx
    a801:	88 54 05 ee          	mov    %dl,-0x12(%ebp,%eax,1)
    a805:	eb 6b                	jmp    a872 <print_address+0x170>
            else if (adress__ == 11)
    a807:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
    a80b:	75 1e                	jne    a82b <print_address+0x129>
                p[10 - i] |= 'b';
    a80d:	b8 0a 00 00 00       	mov    $0xa,%eax
    a812:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a815:	0f b6 54 05 ee       	movzbl -0x12(%ebp,%eax,1),%edx
    a81a:	b8 0a 00 00 00       	mov    $0xa,%eax
    a81f:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a822:	83 ca 62             	or     $0x62,%edx
    a825:	88 54 05 ee          	mov    %dl,-0x12(%ebp,%eax,1)
    a829:	eb 47                	jmp    a872 <print_address+0x170>
            else if (adress__ == 10)
    a82b:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
    a82f:	75 1e                	jne    a84f <print_address+0x14d>
                p[10 - i] |= 'a';
    a831:	b8 0a 00 00 00       	mov    $0xa,%eax
    a836:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a839:	0f b6 54 05 ee       	movzbl -0x12(%ebp,%eax,1),%edx
    a83e:	b8 0a 00 00 00       	mov    $0xa,%eax
    a843:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a846:	83 ca 61             	or     $0x61,%edx
    a849:	88 54 05 ee          	mov    %dl,-0x12(%ebp,%eax,1)
    a84d:	eb 23                	jmp    a872 <print_address+0x170>
                p[10 - i] |= (char)(adress__ + 0x30);
    a84f:	b8 0a 00 00 00       	mov    $0xa,%eax
    a854:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a857:	0f b6 54 05 ee       	movzbl -0x12(%ebp,%eax,1),%edx
    a85c:	8b 45 0c             	mov    0xc(%ebp),%eax
    a85f:	83 c0 30             	add    $0x30,%eax
    a862:	89 c1                	mov    %eax,%ecx
    a864:	b8 0a 00 00 00       	mov    $0xa,%eax
    a869:	2b 45 fc             	sub    -0x4(%ebp),%eax
    a86c:	09 ca                	or     %ecx,%edx
    a86e:	88 54 05 ee          	mov    %dl,-0x12(%ebp,%eax,1)
        for (i = 1; i <= 8; i++) {
    a872:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    a876:	83 7d fc 08          	cmpl   $0x8,-0x4(%ebp)
    a87a:	0f 86 dc fe ff ff    	jbe    a75c <print_address+0x5a>
        for (i = 0; i < 10; i++)
    a880:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    a887:	eb 20                	jmp    a8a9 <print_address+0x1a7>
            putchar(color, p[i]);
    a889:	8d 55 ee             	lea    -0x12(%ebp),%edx
    a88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a88f:	01 d0                	add    %edx,%eax
    a891:	0f b6 00             	movzbl (%eax),%eax
    a894:	0f b6 d0             	movzbl %al,%edx
    a897:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
    a89b:	52                   	push   %edx
    a89c:	50                   	push   %eax
    a89d:	e8 42 fd ff ff       	call   a5e4 <putchar>
    a8a2:	83 c4 08             	add    $0x8,%esp
        for (i = 0; i < 10; i++)
    a8a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    a8a9:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
    a8ad:	76 da                	jbe    a889 <print_address+0x187>
}
    a8af:	90                   	nop
    a8b0:	c9                   	leave  
    a8b1:	c3                   	ret    

0000a8b2 <move_cursor>:

void move_cursor(uint8_t x , uint8_t y)
{
    a8b2:	55                   	push   %ebp
    a8b3:	89 e5                	mov    %esp,%ebp
    a8b5:	83 ec 18             	sub    $0x18,%esp
    a8b8:	8b 55 08             	mov    0x8(%ebp),%edx
    a8bb:	8b 45 0c             	mov    0xc(%ebp),%eax
    a8be:	88 55 ec             	mov    %dl,-0x14(%ebp)
    a8c1:	88 45 e8             	mov    %al,-0x18(%ebp)
    uint16_t c_pos;

    c_pos = y * 80 + x;
    a8c4:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
    a8c8:	89 d0                	mov    %edx,%eax
    a8ca:	c1 e0 02             	shl    $0x2,%eax
    a8cd:	01 d0                	add    %edx,%eax
    a8cf:	c1 e0 04             	shl    $0x4,%eax
    a8d2:	89 c2                	mov    %eax,%edx
    a8d4:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
    a8d8:	01 d0                	add    %edx,%eax
    a8da:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

	outb(0x3d4, 0x0f);
    a8de:	ba d4 03 00 00       	mov    $0x3d4,%edx
    a8e3:	b8 0f 00 00 00       	mov    $0xf,%eax
    a8e8:	ee                   	out    %al,(%dx)
	outb(0x3d5, (uint8_t) c_pos);
    a8e9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a8ed:	ba d5 03 00 00       	mov    $0x3d5,%edx
    a8f2:	ee                   	out    %al,(%dx)
	outb(0x3d4, 0x0e);
    a8f3:	ba d4 03 00 00       	mov    $0x3d4,%edx
    a8f8:	b8 0e 00 00 00       	mov    $0xe,%eax
    a8fd:	ee                   	out    %al,(%dx)
	outb(0x3d5, (uint8_t) (c_pos >> 8));
    a8fe:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    a902:	66 c1 e8 08          	shr    $0x8,%ax
    a906:	ba d5 03 00 00       	mov    $0x3d5,%edx
    a90b:	ee                   	out    %al,(%dx)
}
    a90c:	90                   	nop
    a90d:	c9                   	leave  
    a90e:	c3                   	ret    

0000a90f <show_cursor>:

void show_cursor(void)
{
    a90f:	55                   	push   %ebp
    a910:	89 e5                	mov    %esp,%ebp
	move_cursor(CURSOR_X, CURSOR_Y);
    a912:	a1 08 50 01 00       	mov    0x15008,%eax
    a917:	0f b6 d0             	movzbl %al,%edx
    a91a:	a1 0c 50 01 00       	mov    0x1500c,%eax
    a91f:	0f b6 c0             	movzbl %al,%eax
    a922:	52                   	push   %edx
    a923:	50                   	push   %eax
    a924:	e8 89 ff ff ff       	call   a8b2 <move_cursor>
    a929:	83 c4 08             	add    $0x8,%esp
    a92c:	90                   	nop
    a92d:	c9                   	leave  
    a92e:	c3                   	ret    

0000a92f <get_apic_base>:
/*
    Get Physical address of the APIC registers page
*/

static uintptr_t get_apic_base()
{
    a92f:	55                   	push   %ebp
    a930:	89 e5                	mov    %esp,%ebp
    a932:	83 ec 10             	sub    $0x10,%esp
    uint32_t msr_data[2];

    ReadMSR(IA32_APIC_BASE_MSR, msr_data);
    a935:	b8 1b 00 00 00       	mov    $0x1b,%eax
    a93a:	89 c1                	mov    %eax,%ecx
    a93c:	0f 32                	rdmsr  
    a93e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    a941:	89 55 fc             	mov    %edx,-0x4(%ebp)

    return (uintptr_t)(msr_data[1] * 32 + msr_data[0]);
    a944:	8b 45 fc             	mov    -0x4(%ebp),%eax
    a947:	c1 e0 05             	shl    $0x5,%eax
    a94a:	89 c2                	mov    %eax,%edx
    a94c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a94f:	01 d0                	add    %edx,%eax
}
    a951:	c9                   	leave  
    a952:	c3                   	ret    

0000a953 <set_apic_base>:

static void set_apic_base(uintptr_t apic)
{
    a953:	55                   	push   %ebp
    a954:	89 e5                	mov    %esp,%ebp
    a956:	83 ec 10             	sub    $0x10,%esp
    uint32_t data[2];

    data[1] = 0;
    a959:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    data[0] = (apic & 0xfffff000) | IA32_APIC_BASE_MSR_ENABLE;
    a960:	8b 45 08             	mov    0x8(%ebp),%eax
    a963:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    a968:	80 cc 08             	or     $0x8,%ah
    a96b:	89 45 f8             	mov    %eax,-0x8(%ebp)

    SetMSR(IA32_APIC_BASE_MSR, data);
    a96e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    a971:	8b 55 fc             	mov    -0x4(%ebp),%edx
    a974:	b9 1b 00 00 00       	mov    $0x1b,%ecx
    a979:	0f 30                	wrmsr  
}
    a97b:	90                   	nop
    a97c:	c9                   	leave  
    a97d:	c3                   	ret    

0000a97e <cpu_ReadLocalAPICReg>:

static uint32_t cpu_ReadLocalAPICReg(uint32_t offset)
{
    a97e:	55                   	push   %ebp
    a97f:	89 e5                	mov    %esp,%ebp
    return __ioapic_reg__[offset];
    a981:	8b 15 10 50 01 00    	mov    0x15010,%edx
    a987:	8b 45 08             	mov    0x8(%ebp),%eax
    a98a:	01 c0                	add    %eax,%eax
    a98c:	01 d0                	add    %edx,%eax
    a98e:	0f b7 00             	movzwl (%eax),%eax
    a991:	0f b7 c0             	movzwl %ax,%eax
}
    a994:	5d                   	pop    %ebp
    a995:	c3                   	ret    

0000a996 <cpu_SetLocalAPICReg>:

static void cpu_SetLocalAPICReg(uint32_t offset, uint16_t data)
{
    a996:	55                   	push   %ebp
    a997:	89 e5                	mov    %esp,%ebp
    a999:	83 ec 04             	sub    $0x4,%esp
    a99c:	8b 45 0c             	mov    0xc(%ebp),%eax
    a99f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    __ioapic_reg__[offset] = data;
    a9a3:	8b 15 10 50 01 00    	mov    0x15010,%edx
    a9a9:	8b 45 08             	mov    0x8(%ebp),%eax
    a9ac:	01 c0                	add    %eax,%eax
    a9ae:	01 c2                	add    %eax,%edx
    a9b0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
    a9b4:	66 89 02             	mov    %ax,(%edx)
}
    a9b7:	90                   	nop
    a9b8:	c9                   	leave  
    a9b9:	c3                   	ret    

0000a9ba <enable_local_apic>:

void enable_local_apic()
{
    a9ba:	55                   	push   %ebp
    a9bb:	89 e5                	mov    %esp,%ebp
    a9bd:	83 ec 08             	sub    $0x8,%esp
    // Acces to read the top of the memory
    create_page_table(__3fb_index_page_directory__, 0x3FB);
    a9c0:	83 ec 08             	sub    $0x8,%esp
    a9c3:	68 fb 03 00 00       	push   $0x3fb
    a9c8:	68 00 d0 00 00       	push   $0xd000
    a9cd:	e8 b0 f2 ff ff       	call   9c82 <create_page_table>
    a9d2:	83 c4 10             	add    $0x10,%esp

    __ioapic_reg__ = (uint16_t*)get_apic_base();
    a9d5:	e8 55 ff ff ff       	call   a92f <get_apic_base>
    a9da:	a3 10 50 01 00       	mov    %eax,0x15010

    set_apic_base(get_apic_base());
    a9df:	e8 4b ff ff ff       	call   a92f <get_apic_base>
    a9e4:	83 ec 0c             	sub    $0xc,%esp
    a9e7:	50                   	push   %eax
    a9e8:	e8 66 ff ff ff       	call   a953 <set_apic_base>
    a9ed:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0xF0, cpu_ReadLocalAPICReg(0xF0) | 0x100);
    a9f0:	83 ec 0c             	sub    $0xc,%esp
    a9f3:	68 f0 00 00 00       	push   $0xf0
    a9f8:	e8 81 ff ff ff       	call   a97e <cpu_ReadLocalAPICReg>
    a9fd:	83 c4 10             	add    $0x10,%esp
    aa00:	80 cc 01             	or     $0x1,%ah
    aa03:	0f b7 c0             	movzwl %ax,%eax
    aa06:	83 ec 08             	sub    $0x8,%esp
    aa09:	50                   	push   %eax
    aa0a:	68 f0 00 00 00       	push   $0xf0
    aa0f:	e8 82 ff ff ff       	call   a996 <cpu_SetLocalAPICReg>
    aa14:	83 c4 10             	add    $0x10,%esp

    cpu_SetLocalAPICReg(0x20, 2);
    aa17:	83 ec 08             	sub    $0x8,%esp
    aa1a:	6a 02                	push   $0x2
    aa1c:	6a 20                	push   $0x20
    aa1e:	e8 73 ff ff ff       	call   a996 <cpu_SetLocalAPICReg>
    aa23:	83 c4 10             	add    $0x10,%esp

    kprintf(2, 15, "[K:CPU]\tEnabling and setting of local APIC\n");
    aa26:	83 ec 04             	sub    $0x4,%esp
    aa29:	68 54 17 01 00       	push   $0x11754
    aa2e:	6a 0f                	push   $0xf
    aa30:	6a 02                	push   $0x2
    aa32:	e8 31 fa ff ff       	call   a468 <kprintf>
    aa37:	83 c4 10             	add    $0x10,%esp
}
    aa3a:	90                   	nop
    aa3b:	c9                   	leave  
    aa3c:	c3                   	ret    

0000aa3d <program_IOAPIC>:
#include <init/rsdp.h>
#include <init/video.h>

void program_IOAPIC()
{
    aa3d:	55                   	push   %ebp
    aa3e:	89 e5                	mov    %esp,%ebp
    aa40:	83 ec 08             	sub    $0x8,%esp
    detecting_RSDP();
    aa43:	e8 fa f8 ff ff       	call   a342 <detecting_RSDP>
    aa48:	90                   	nop
    aa49:	c9                   	leave  
    aa4a:	c3                   	ret    

0000aa4b <init_vmm>:

_virt_mm_ MM_BLOCK[0x1000], *_head_vmm_;
extern test_case_result __vm_mm_manager__;

void init_vmm()
{
    aa4b:	55                   	push   %ebp
    aa4c:	89 e5                	mov    %esp,%ebp
    aa4e:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 0x1000; i++) {
    aa51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    aa58:	eb 49                	jmp    aaa3 <init_vmm+0x58>
        MM_BLOCK[i].address = VM__NO_VM_ADDRESS;
    aa5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa5d:	89 d0                	mov    %edx,%eax
    aa5f:	01 c0                	add    %eax,%eax
    aa61:	01 d0                	add    %edx,%eax
    aa63:	c1 e0 02             	shl    $0x2,%eax
    aa66:	05 20 50 01 00       	add    $0x15020,%eax
    aa6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].next = (_virt_mm_*)NULL;
    aa71:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa74:	89 d0                	mov    %edx,%eax
    aa76:	01 c0                	add    %eax,%eax
    aa78:	01 d0                	add    %edx,%eax
    aa7a:	c1 e0 02             	shl    $0x2,%eax
    aa7d:	05 28 50 01 00       	add    $0x15028,%eax
    aa82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MM_BLOCK[i].size = 0;
    aa88:	8b 55 fc             	mov    -0x4(%ebp),%edx
    aa8b:	89 d0                	mov    %edx,%eax
    aa8d:	01 c0                	add    %eax,%eax
    aa8f:	01 d0                	add    %edx,%eax
    aa91:	c1 e0 02             	shl    $0x2,%eax
    aa94:	05 24 50 01 00       	add    $0x15024,%eax
    aa99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x1000; i++) {
    aa9f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    aaa3:	81 7d fc ff 0f 00 00 	cmpl   $0xfff,-0x4(%ebp)
    aaaa:	7e ae                	jle    aa5a <init_vmm+0xf>
    }
    _head_vmm_ = MM_BLOCK;
    aaac:	c7 05 20 10 02 00 20 	movl   $0x15020,0x21020
    aab3:	50 01 00 

    // __RUN_TEST__(__vm_mm_manager__);
}
    aab6:	90                   	nop
    aab7:	c9                   	leave  
    aab8:	c3                   	ret    

0000aab9 <kmalloc>:

void* kmalloc(uint32_t size)
{
    aab9:	55                   	push   %ebp
    aaba:	89 e5                	mov    %esp,%ebp
    aabc:	83 ec 18             	sub    $0x18,%esp
    // Insert at the head
    if (_head_vmm_->address == VM__NO_VM_ADDRESS) {
    aabf:	a1 20 10 02 00       	mov    0x21020,%eax
    aac4:	8b 00                	mov    (%eax),%eax
    aac6:	85 c0                	test   %eax,%eax
    aac8:	75 36                	jne    ab00 <kmalloc+0x47>
        _head_vmm_->address = KERNEL__VM_BASE;
    aaca:	a1 20 10 02 00       	mov    0x21020,%eax
    aacf:	ba 40 10 02 00       	mov    $0x21040,%edx
    aad4:	89 10                	mov    %edx,(%eax)
        _head_vmm_->size = size;
    aad6:	a1 20 10 02 00       	mov    0x21020,%eax
    aadb:	8b 55 08             	mov    0x8(%ebp),%edx
    aade:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)KERNEL__VM_BASE, 0, size);
    aae1:	83 ec 04             	sub    $0x4,%esp
    aae4:	ff 75 08             	pushl  0x8(%ebp)
    aae7:	6a 00                	push   $0x0
    aae9:	68 40 10 02 00       	push   $0x21040
    aaee:	e8 94 e6 ff ff       	call   9187 <memset>
    aaf3:	83 c4 10             	add    $0x10,%esp

        return (void*)KERNEL__VM_BASE;
    aaf6:	b8 40 10 02 00       	mov    $0x21040,%eax
    aafb:	e9 7b 01 00 00       	jmp    ac7b <kmalloc+0x1c2>
    }

    _virt_mm_ *tmp, *_new_item_;
    uint32_t i = 0;
    ab00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab07:	eb 04                	jmp    ab0d <kmalloc+0x54>
        i++;
    ab09:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    while (i < 0x1000 && MM_BLOCK[i].address != VM__NO_VM_ADDRESS)
    ab0d:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
    ab14:	77 17                	ja     ab2d <kmalloc+0x74>
    ab16:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab19:	89 d0                	mov    %edx,%eax
    ab1b:	01 c0                	add    %eax,%eax
    ab1d:	01 d0                	add    %edx,%eax
    ab1f:	c1 e0 02             	shl    $0x2,%eax
    ab22:	05 20 50 01 00       	add    $0x15020,%eax
    ab27:	8b 00                	mov    (%eax),%eax
    ab29:	85 c0                	test   %eax,%eax
    ab2b:	75 dc                	jne    ab09 <kmalloc+0x50>

    _new_item_ = &MM_BLOCK[i];
    ab2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
    ab30:	89 d0                	mov    %edx,%eax
    ab32:	01 c0                	add    %eax,%eax
    ab34:	01 d0                	add    %edx,%eax
    ab36:	c1 e0 02             	shl    $0x2,%eax
    ab39:	05 20 50 01 00       	add    $0x15020,%eax
    ab3e:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the base address is free
    if (_head_vmm_->address != KERNEL__VM_BASE + size) {
    ab41:	a1 20 10 02 00       	mov    0x21020,%eax
    ab46:	8b 00                	mov    (%eax),%eax
    ab48:	b9 40 10 02 00       	mov    $0x21040,%ecx
    ab4d:	8b 55 08             	mov    0x8(%ebp),%edx
    ab50:	01 ca                	add    %ecx,%edx
    ab52:	39 d0                	cmp    %edx,%eax
    ab54:	74 47                	je     ab9d <kmalloc+0xe4>
        _new_item_->address = KERNEL__VM_BASE;
    ab56:	ba 40 10 02 00       	mov    $0x21040,%edx
    ab5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab5e:	89 10                	mov    %edx,(%eax)
        _new_item_->size = size;
    ab60:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab63:	8b 55 08             	mov    0x8(%ebp),%edx
    ab66:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->next = _head_vmm_;
    ab69:	8b 15 20 10 02 00    	mov    0x21020,%edx
    ab6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab72:	89 50 08             	mov    %edx,0x8(%eax)

        _head_vmm_ = _new_item_;
    ab75:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab78:	a3 20 10 02 00       	mov    %eax,0x21020

        memset((void*)_new_item_->address, 0, size);
    ab7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab80:	8b 00                	mov    (%eax),%eax
    ab82:	83 ec 04             	sub    $0x4,%esp
    ab85:	ff 75 08             	pushl  0x8(%ebp)
    ab88:	6a 00                	push   $0x0
    ab8a:	50                   	push   %eax
    ab8b:	e8 f7 e5 ff ff       	call   9187 <memset>
    ab90:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ab93:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ab96:	8b 00                	mov    (%eax),%eax
    ab98:	e9 de 00 00 00       	jmp    ac7b <kmalloc+0x1c2>
    }

    tmp = _head_vmm_;
    ab9d:	a1 20 10 02 00       	mov    0x21020,%eax
    aba2:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    aba5:	eb 27                	jmp    abce <kmalloc+0x115>
        if (tmp->next->address >= tmp->address + tmp->size + size)
    aba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abaa:	8b 40 08             	mov    0x8(%eax),%eax
    abad:	8b 10                	mov    (%eax),%edx
    abaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abb2:	8b 08                	mov    (%eax),%ecx
    abb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abb7:	8b 40 04             	mov    0x4(%eax),%eax
    abba:	01 c1                	add    %eax,%ecx
    abbc:	8b 45 08             	mov    0x8(%ebp),%eax
    abbf:	01 c8                	add    %ecx,%eax
    abc1:	39 c2                	cmp    %eax,%edx
    abc3:	73 15                	jae    abda <kmalloc+0x121>
            break;

        tmp = tmp->next;
    abc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abc8:	8b 40 08             	mov    0x8(%eax),%eax
    abcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    abce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abd1:	8b 40 08             	mov    0x8(%eax),%eax
    abd4:	85 c0                	test   %eax,%eax
    abd6:	75 cf                	jne    aba7 <kmalloc+0xee>
    abd8:	eb 01                	jmp    abdb <kmalloc+0x122>
            break;
    abda:	90                   	nop
    }

    // if we are at the end
    if (tmp->next == (_virt_mm_*)NULL) {
    abdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abde:	8b 40 08             	mov    0x8(%eax),%eax
    abe1:	85 c0                	test   %eax,%eax
    abe3:	75 4b                	jne    ac30 <kmalloc+0x177>
        _new_item_->size = size;
    abe5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abe8:	8b 55 08             	mov    0x8(%ebp),%edx
    abeb:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    abee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abf1:	8b 10                	mov    (%eax),%edx
    abf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    abf6:	8b 40 04             	mov    0x4(%eax),%eax
    abf9:	01 c2                	add    %eax,%edx
    abfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    abfe:	89 10                	mov    %edx,(%eax)
        _new_item_->next = (_virt_mm_*)NULL;
    ac00:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

        tmp->next = _new_item_;
    ac0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac10:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac13:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac16:	8b 00                	mov    (%eax),%eax
    ac18:	83 ec 04             	sub    $0x4,%esp
    ac1b:	ff 75 08             	pushl  0x8(%ebp)
    ac1e:	6a 00                	push   $0x0
    ac20:	50                   	push   %eax
    ac21:	e8 61 e5 ff ff       	call   9187 <memset>
    ac26:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac29:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac2c:	8b 00                	mov    (%eax),%eax
    ac2e:	eb 4b                	jmp    ac7b <kmalloc+0x1c2>
    }

    else {
        _new_item_->size = size;
    ac30:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac33:	8b 55 08             	mov    0x8(%ebp),%edx
    ac36:	89 50 04             	mov    %edx,0x4(%eax)
        _new_item_->address = tmp->address + tmp->size;
    ac39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac3c:	8b 10                	mov    (%eax),%edx
    ac3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac41:	8b 40 04             	mov    0x4(%eax),%eax
    ac44:	01 c2                	add    %eax,%edx
    ac46:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac49:	89 10                	mov    %edx,(%eax)

        _new_item_->next = tmp->next;
    ac4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac4e:	8b 50 08             	mov    0x8(%eax),%edx
    ac51:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac54:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next = _new_item_;
    ac57:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ac5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    ac5d:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)_new_item_->address, 0, size);
    ac60:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac63:	8b 00                	mov    (%eax),%eax
    ac65:	83 ec 04             	sub    $0x4,%esp
    ac68:	ff 75 08             	pushl  0x8(%ebp)
    ac6b:	6a 00                	push   $0x0
    ac6d:	50                   	push   %eax
    ac6e:	e8 14 e5 ff ff       	call   9187 <memset>
    ac73:	83 c4 10             	add    $0x10,%esp

        return (void*)_new_item_->address;
    ac76:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ac79:	8b 00                	mov    (%eax),%eax
    }
}
    ac7b:	c9                   	leave  
    ac7c:	c3                   	ret    

0000ac7d <free>:

void free(virtaddr_t _addr__)
{
    ac7d:	55                   	push   %ebp
    ac7e:	89 e5                	mov    %esp,%ebp
    ac80:	83 ec 10             	sub    $0x10,%esp
    _virt_mm_ *tmp, *tmp_prev;
    // Remove at the head
    if (_head_vmm_->address == _addr__) {
    ac83:	a1 20 10 02 00       	mov    0x21020,%eax
    ac88:	8b 00                	mov    (%eax),%eax
    ac8a:	39 45 08             	cmp    %eax,0x8(%ebp)
    ac8d:	75 29                	jne    acb8 <free+0x3b>
        // Mark free
        _head_vmm_->address = VM__NO_VM_ADDRESS;
    ac8f:	a1 20 10 02 00       	mov    0x21020,%eax
    ac94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        _head_vmm_->size = 0;
    ac9a:	a1 20 10 02 00       	mov    0x21020,%eax
    ac9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        _head_vmm_ = _head_vmm_->next;
    aca6:	a1 20 10 02 00       	mov    0x21020,%eax
    acab:	8b 40 08             	mov    0x8(%eax),%eax
    acae:	a3 20 10 02 00       	mov    %eax,0x21020
        return;
    acb3:	e9 ac 00 00 00       	jmp    ad64 <free+0xe7>
    }

    // If it is the last item
    if (_head_vmm_->next == (_virt_mm_*)NULL && _head_vmm_->address == _addr__) {
    acb8:	a1 20 10 02 00       	mov    0x21020,%eax
    acbd:	8b 40 08             	mov    0x8(%eax),%eax
    acc0:	85 c0                	test   %eax,%eax
    acc2:	75 16                	jne    acda <free+0x5d>
    acc4:	a1 20 10 02 00       	mov    0x21020,%eax
    acc9:	8b 00                	mov    (%eax),%eax
    accb:	39 45 08             	cmp    %eax,0x8(%ebp)
    acce:	75 0a                	jne    acda <free+0x5d>
        init_vmm();
    acd0:	e8 76 fd ff ff       	call   aa4b <init_vmm>
        return;
    acd5:	e9 8a 00 00 00       	jmp    ad64 <free+0xe7>
    }

    tmp = _head_vmm_;
    acda:	a1 20 10 02 00       	mov    0x21020,%eax
    acdf:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    ace2:	eb 0f                	jmp    acf3 <free+0x76>
        tmp_prev = tmp;
    ace4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ace7:	89 45 f8             	mov    %eax,-0x8(%ebp)
        tmp = tmp->next;
    acea:	8b 45 fc             	mov    -0x4(%ebp),%eax
    aced:	8b 40 08             	mov    0x8(%eax),%eax
    acf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (tmp->next != (_virt_mm_*)NULL && tmp->address != _addr__) {
    acf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    acf6:	8b 40 08             	mov    0x8(%eax),%eax
    acf9:	85 c0                	test   %eax,%eax
    acfb:	74 0a                	je     ad07 <free+0x8a>
    acfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad00:	8b 00                	mov    (%eax),%eax
    ad02:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad05:	75 dd                	jne    ace4 <free+0x67>
    }

    if (tmp->next == (_virt_mm_*)NULL && tmp->address == _addr__) {
    ad07:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad0a:	8b 40 08             	mov    0x8(%eax),%eax
    ad0d:	85 c0                	test   %eax,%eax
    ad0f:	75 29                	jne    ad3a <free+0xbd>
    ad11:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad14:	8b 00                	mov    (%eax),%eax
    ad16:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad19:	75 1f                	jne    ad3a <free+0xbd>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad24:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = (_virt_mm_*)NULL;
    ad2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    ad38:	eb 2a                	jmp    ad64 <free+0xe7>
    }

    if (tmp->address == _addr__) {
    ad3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad3d:	8b 00                	mov    (%eax),%eax
    ad3f:	39 45 08             	cmp    %eax,0x8(%ebp)
    ad42:	75 20                	jne    ad64 <free+0xe7>
        // Mark it , the item is free
        tmp->address = VM__NO_VM_ADDRESS;
    ad44:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tmp->size = 0;
    ad4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        tmp_prev->next = tmp->next;
    ad57:	8b 45 fc             	mov    -0x4(%ebp),%eax
    ad5a:	8b 50 08             	mov    0x8(%eax),%edx
    ad5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    ad60:	89 50 08             	mov    %edx,0x8(%eax)
        return;
    ad63:	90                   	nop
    }
    ad64:	c9                   	leave  
    ad65:	c3                   	ret    

0000ad66 <init_page_mem_manage>:
*/
__page_table_frame__ uint32_t __kernel_phys_mem_manager__[PAGE_TABLE_OFFSET]
    __attribute__((aligned(PAGE_TABLE_SIZE)));

void init_page_mem_manage()
{
    ad66:	55                   	push   %ebp
    ad67:	89 e5                	mov    %esp,%ebp
    ad69:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++) {
    ad6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    ad73:	eb 49                	jmp    adbe <init_page_mem_manage+0x58>
        MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    ad75:	ba 80 17 01 00       	mov    $0x11780,%edx
    ad7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad7d:	c1 e0 04             	shl    $0x4,%eax
    ad80:	05 20 20 02 00       	add    $0x22020,%eax
    ad85:	89 10                	mov    %edx,(%eax)
        MEMORY_SPACES_PAGES[i].order = 0;
    ad87:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad8a:	c1 e0 04             	shl    $0x4,%eax
    ad8d:	05 24 20 02 00       	add    $0x22024,%eax
    ad92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    ad98:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ad9b:	c1 e0 04             	shl    $0x4,%eax
    ad9e:	05 2c 20 02 00       	add    $0x2202c,%eax
    ada3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    ada9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    adac:	c1 e0 04             	shl    $0x4,%eax
    adaf:	05 28 20 02 00       	add    $0x22028,%eax
    adb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (i = 0; i < 0x400; i++) {
    adba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    adbe:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    adc5:	76 ae                	jbe    ad75 <init_page_mem_manage+0xf>
    }

    create_page_table(__kernel_phys_mem_manager__, 1);
    adc7:	83 ec 08             	sub    $0x8,%esp
    adca:	6a 01                	push   $0x1
    adcc:	68 00 e0 00 00       	push   $0xe000
    add1:	e8 ac ee ff ff       	call   9c82 <create_page_table>
    add6:	83 c4 10             	add    $0x10,%esp

    _page_area_track_ = MEMORY_SPACES_PAGES;
    add9:	c7 05 00 20 02 00 20 	movl   $0x22020,0x22000
    ade0:	20 02 00 

    // __RUN_TEST__(__phy_mem_manager__);
}
    ade3:	90                   	nop
    ade4:	c9                   	leave  
    ade5:	c3                   	ret    

0000ade6 <alloc_page>:

physaddr_t alloc_page(uint32_t order)
{
    ade6:	55                   	push   %ebp
    ade7:	89 e5                	mov    %esp,%ebp
    ade9:	53                   	push   %ebx
    adea:	83 ec 14             	sub    $0x14,%esp
    // Insert at the head
    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS) {
    aded:	a1 00 20 02 00       	mov    0x22000,%eax
    adf2:	8b 00                	mov    (%eax),%eax
    adf4:	ba 80 17 01 00       	mov    $0x11780,%edx
    adf9:	39 d0                	cmp    %edx,%eax
    adfb:	75 40                	jne    ae3d <alloc_page+0x57>
        _page_area_track_->_address_ = KERNEL__PHY_MEM;
    adfd:	a1 00 20 02 00       	mov    0x22000,%eax
    ae02:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        _page_area_track_->order = order;
    ae08:	a1 00 20 02 00       	mov    0x22000,%eax
    ae0d:	8b 55 08             	mov    0x8(%ebp),%edx
    ae10:	89 50 04             	mov    %edx,0x4(%eax)
        memset((void*)(*_page_area_track_)._address_, 0, order * 0x1000);
    ae13:	8b 45 08             	mov    0x8(%ebp),%eax
    ae16:	c1 e0 0c             	shl    $0xc,%eax
    ae19:	89 c2                	mov    %eax,%edx
    ae1b:	a1 00 20 02 00       	mov    0x22000,%eax
    ae20:	8b 00                	mov    (%eax),%eax
    ae22:	83 ec 04             	sub    $0x4,%esp
    ae25:	52                   	push   %edx
    ae26:	6a 00                	push   $0x0
    ae28:	50                   	push   %eax
    ae29:	e8 59 e3 ff ff       	call   9187 <memset>
    ae2e:	83 c4 10             	add    $0x10,%esp

        return (*_page_area_track_)._address_;
    ae31:	a1 00 20 02 00       	mov    0x22000,%eax
    ae36:	8b 00                	mov    (%eax),%eax
    ae38:	e9 ae 01 00 00       	jmp    afeb <alloc_page+0x205>
    }

    // FInd the free address space
    uint32_t i = 0;
    ae3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    _address_order_track_* new_page;

    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae44:	eb 04                	jmp    ae4a <alloc_page+0x64>
        i++;
    ae46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while (MEMORY_SPACES_PAGES[i]._address_ != NO_PHYSICAL_ADDRESS && i < 0x400)
    ae4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae4d:	c1 e0 04             	shl    $0x4,%eax
    ae50:	05 20 20 02 00       	add    $0x22020,%eax
    ae55:	8b 00                	mov    (%eax),%eax
    ae57:	ba 80 17 01 00       	mov    $0x11780,%edx
    ae5c:	39 d0                	cmp    %edx,%eax
    ae5e:	74 09                	je     ae69 <alloc_page+0x83>
    ae60:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    ae67:	76 dd                	jbe    ae46 <alloc_page+0x60>

    new_page = (_address_order_track_*)(&MEMORY_SPACES_PAGES[i]);
    ae69:	8b 45 f4             	mov    -0xc(%ebp),%eax
    ae6c:	c1 e0 04             	shl    $0x4,%eax
    ae6f:	05 20 20 02 00       	add    $0x22020,%eax
    ae74:	89 45 ec             	mov    %eax,-0x14(%ebp)

    // If the head doesn't have a base address

    if (_page_area_track_->_address_ >= KERNEL__PHY_MEM + (PAGE_SIZE * order)) {
    ae77:	a1 00 20 02 00       	mov    0x22000,%eax
    ae7c:	8b 00                	mov    (%eax),%eax
    ae7e:	8b 55 08             	mov    0x8(%ebp),%edx
    ae81:	81 c2 00 01 00 00    	add    $0x100,%edx
    ae87:	c1 e2 0c             	shl    $0xc,%edx
    ae8a:	39 d0                	cmp    %edx,%eax
    ae8c:	72 4c                	jb     aeda <alloc_page+0xf4>
        new_page->_address_ = KERNEL__PHY_MEM;
    ae8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ae91:	c7 00 00 00 10 00    	movl   $0x100000,(%eax)
        new_page->order = order;
    ae97:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ae9a:	8b 55 08             	mov    0x8(%ebp),%edx
    ae9d:	89 50 04             	mov    %edx,0x4(%eax)
        new_page->next_ = _page_area_track_;
    aea0:	8b 15 00 20 02 00    	mov    0x22000,%edx
    aea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aea9:	89 50 0c             	mov    %edx,0xc(%eax)
        _page_area_track_ = new_page;
    aeac:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aeaf:	a3 00 20 02 00       	mov    %eax,0x22000

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    aeb4:	8b 45 08             	mov    0x8(%ebp),%eax
    aeb7:	c1 e0 0c             	shl    $0xc,%eax
    aeba:	89 c2                	mov    %eax,%edx
    aebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aebf:	8b 00                	mov    (%eax),%eax
    aec1:	83 ec 04             	sub    $0x4,%esp
    aec4:	52                   	push   %edx
    aec5:	6a 00                	push   $0x0
    aec7:	50                   	push   %eax
    aec8:	e8 ba e2 ff ff       	call   9187 <memset>
    aecd:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    aed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    aed3:	8b 00                	mov    (%eax),%eax
    aed5:	e9 11 01 00 00       	jmp    afeb <alloc_page+0x205>
    }

    _address_order_track_* tmp;

    tmp = (_page_area_track_);
    aeda:	a1 00 20 02 00       	mov    0x22000,%eax
    aedf:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Find a optimal position for the new page
    while (tmp->next_ != END_LIST) {
    aee2:	eb 2a                	jmp    af0e <alloc_page+0x128>
        if ((tmp->next_->_address_) > (tmp->_address_ + ((tmp->order + order) * PAGE_SIZE)))
    aee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aee7:	8b 40 0c             	mov    0xc(%eax),%eax
    aeea:	8b 10                	mov    (%eax),%edx
    aeec:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aeef:	8b 08                	mov    (%eax),%ecx
    aef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    aef4:	8b 58 04             	mov    0x4(%eax),%ebx
    aef7:	8b 45 08             	mov    0x8(%ebp),%eax
    aefa:	01 d8                	add    %ebx,%eax
    aefc:	c1 e0 0c             	shl    $0xc,%eax
    aeff:	01 c8                	add    %ecx,%eax
    af01:	39 c2                	cmp    %eax,%edx
    af03:	77 15                	ja     af1a <alloc_page+0x134>
            break;
        else
            tmp = tmp->next_;
    af05:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af08:	8b 40 0c             	mov    0xc(%eax),%eax
    af0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    af0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af11:	8b 40 0c             	mov    0xc(%eax),%eax
    af14:	85 c0                	test   %eax,%eax
    af16:	75 cc                	jne    aee4 <alloc_page+0xfe>
    af18:	eb 01                	jmp    af1b <alloc_page+0x135>
            break;
    af1a:	90                   	nop
    }

    if (tmp->next_ == END_LIST) {
    af1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af1e:	8b 40 0c             	mov    0xc(%eax),%eax
    af21:	85 c0                	test   %eax,%eax
    af23:	75 5d                	jne    af82 <alloc_page+0x19c>
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    af25:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af28:	8b 10                	mov    (%eax),%edx
    af2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af2d:	8b 40 04             	mov    0x4(%eax),%eax
    af30:	c1 e0 0c             	shl    $0xc,%eax
    af33:	01 c2                	add    %eax,%edx
    af35:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af38:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    af3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af3d:	8b 55 08             	mov    0x8(%ebp),%edx
    af40:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = END_LIST;
    af43:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        new_page->previous_ = tmp;
    af4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af50:	8b 55 f0             	mov    -0x10(%ebp),%edx
    af53:	89 50 08             	mov    %edx,0x8(%eax)

        tmp->next_ = new_page;
    af56:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af59:	8b 55 ec             	mov    -0x14(%ebp),%edx
    af5c:	89 50 0c             	mov    %edx,0xc(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    af5f:	8b 45 08             	mov    0x8(%ebp),%eax
    af62:	c1 e0 0c             	shl    $0xc,%eax
    af65:	89 c2                	mov    %eax,%edx
    af67:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af6a:	8b 00                	mov    (%eax),%eax
    af6c:	83 ec 04             	sub    $0x4,%esp
    af6f:	52                   	push   %edx
    af70:	6a 00                	push   $0x0
    af72:	50                   	push   %eax
    af73:	e8 0f e2 ff ff       	call   9187 <memset>
    af78:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    af7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af7e:	8b 00                	mov    (%eax),%eax
    af80:	eb 69                	jmp    afeb <alloc_page+0x205>
    }

    else {
        new_page->_address_ = (tmp->_address_) + (tmp->order * PAGE_SIZE);
    af82:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af85:	8b 10                	mov    (%eax),%edx
    af87:	8b 45 f0             	mov    -0x10(%ebp),%eax
    af8a:	8b 40 04             	mov    0x4(%eax),%eax
    af8d:	c1 e0 0c             	shl    $0xc,%eax
    af90:	01 c2                	add    %eax,%edx
    af92:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af95:	89 10                	mov    %edx,(%eax)
        new_page->order = order;
    af97:	8b 45 ec             	mov    -0x14(%ebp),%eax
    af9a:	8b 55 08             	mov    0x8(%ebp),%edx
    af9d:	89 50 04             	mov    %edx,0x4(%eax)

        new_page->next_ = tmp->next_;
    afa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afa3:	8b 50 0c             	mov    0xc(%eax),%edx
    afa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afa9:	89 50 0c             	mov    %edx,0xc(%eax)
        new_page->previous_ = tmp;
    afac:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
    afb2:	89 50 08             	mov    %edx,0x8(%eax)
        tmp->next_ = new_page;
    afb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afbb:	89 50 0c             	mov    %edx,0xc(%eax)
        tmp->next_->previous_ = new_page;
    afbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    afc1:	8b 40 0c             	mov    0xc(%eax),%eax
    afc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
    afc7:	89 50 08             	mov    %edx,0x8(%eax)

        memset((void*)(*new_page)._address_, 0, order * 0x1000);
    afca:	8b 45 08             	mov    0x8(%ebp),%eax
    afcd:	c1 e0 0c             	shl    $0xc,%eax
    afd0:	89 c2                	mov    %eax,%edx
    afd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afd5:	8b 00                	mov    (%eax),%eax
    afd7:	83 ec 04             	sub    $0x4,%esp
    afda:	52                   	push   %edx
    afdb:	6a 00                	push   $0x0
    afdd:	50                   	push   %eax
    afde:	e8 a4 e1 ff ff       	call   9187 <memset>
    afe3:	83 c4 10             	add    $0x10,%esp
        return (*new_page)._address_;
    afe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    afe9:	8b 00                	mov    (%eax),%eax
    }
    NMBER_PAGES_ALLOC++;
}
    afeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    afee:	c9                   	leave  
    afef:	c3                   	ret    

0000aff0 <free_page>:

void free_page(_address_order_track_ page)
{
    aff0:	55                   	push   %ebp
    aff1:	89 e5                	mov    %esp,%ebp
    aff3:	83 ec 10             	sub    $0x10,%esp
    // If it is the head of the list
    if (page.previous_ == END_LIST && page.next_ != END_LIST) {
    aff6:	8b 45 10             	mov    0x10(%ebp),%eax
    aff9:	85 c0                	test   %eax,%eax
    affb:	75 2d                	jne    b02a <free_page+0x3a>
    affd:	8b 45 14             	mov    0x14(%ebp),%eax
    b000:	85 c0                	test   %eax,%eax
    b002:	74 26                	je     b02a <free_page+0x3a>
        page._address_ = NO_PHYSICAL_ADDRESS; // freeing one memory address
    b004:	b8 80 17 01 00       	mov    $0x11780,%eax
    b009:	89 45 08             	mov    %eax,0x8(%ebp)
        _page_area_track_ = _page_area_track_->next_; // point to the second item
    b00c:	a1 00 20 02 00       	mov    0x22000,%eax
    b011:	8b 40 0c             	mov    0xc(%eax),%eax
    b014:	a3 00 20 02 00       	mov    %eax,0x22000
        _page_area_track_->previous_ = END_LIST;
    b019:	a1 00 20 02 00       	mov    0x22000,%eax
    b01e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        return;
    b025:	e9 13 01 00 00       	jmp    b13d <free_page+0x14d>
    }

    // If we have only one page in the list
    else if (page.previous_ == END_LIST && page.next_ == END_LIST) {
    b02a:	8b 45 10             	mov    0x10(%ebp),%eax
    b02d:	85 c0                	test   %eax,%eax
    b02f:	75 67                	jne    b098 <free_page+0xa8>
    b031:	8b 45 14             	mov    0x14(%ebp),%eax
    b034:	85 c0                	test   %eax,%eax
    b036:	75 60                	jne    b098 <free_page+0xa8>
        uintptr_t i;
        for (i = 0; i < 0x400; i++) {
    b038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    b03f:	eb 49                	jmp    b08a <free_page+0x9a>
            MEMORY_SPACES_PAGES[i]._address_ = NO_PHYSICAL_ADDRESS;
    b041:	ba 80 17 01 00       	mov    $0x11780,%edx
    b046:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b049:	c1 e0 04             	shl    $0x4,%eax
    b04c:	05 20 20 02 00       	add    $0x22020,%eax
    b051:	89 10                	mov    %edx,(%eax)
            MEMORY_SPACES_PAGES[i].order = 0;
    b053:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b056:	c1 e0 04             	shl    $0x4,%eax
    b059:	05 24 20 02 00       	add    $0x22024,%eax
    b05e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].next_ = END_LIST;
    b064:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b067:	c1 e0 04             	shl    $0x4,%eax
    b06a:	05 2c 20 02 00       	add    $0x2202c,%eax
    b06f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            MEMORY_SPACES_PAGES[i].previous_ = END_LIST;
    b075:	8b 45 fc             	mov    -0x4(%ebp),%eax
    b078:	c1 e0 04             	shl    $0x4,%eax
    b07b:	05 28 20 02 00       	add    $0x22028,%eax
    b080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (i = 0; i < 0x400; i++) {
    b086:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    b08a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%ebp)
    b091:	76 ae                	jbe    b041 <free_page+0x51>
        }
        return;
    b093:	e9 a5 00 00 00       	jmp    b13d <free_page+0x14d>
    }

    else {
        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b098:	a1 00 20 02 00       	mov    0x22000,%eax
    b09d:	89 45 f8             	mov    %eax,-0x8(%ebp)

        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0a0:	eb 09                	jmp    b0ab <free_page+0xbb>
            tmp = tmp->next_;
    b0a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0a5:	8b 40 0c             	mov    0xc(%eax),%eax
    b0a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (tmp->_address_ != page._address_ && tmp->next_ != END_LIST)
    b0ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0ae:	8b 10                	mov    (%eax),%edx
    b0b0:	8b 45 08             	mov    0x8(%ebp),%eax
    b0b3:	39 c2                	cmp    %eax,%edx
    b0b5:	74 0a                	je     b0c1 <free_page+0xd1>
    b0b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0ba:	8b 40 0c             	mov    0xc(%eax),%eax
    b0bd:	85 c0                	test   %eax,%eax
    b0bf:	75 e1                	jne    b0a2 <free_page+0xb2>

        if (tmp->next_ == END_LIST && tmp->_address_ == page._address_) // At the end of the list
    b0c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0c4:	8b 40 0c             	mov    0xc(%eax),%eax
    b0c7:	85 c0                	test   %eax,%eax
    b0c9:	75 25                	jne    b0f0 <free_page+0x100>
    b0cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0ce:	8b 10                	mov    (%eax),%edx
    b0d0:	8b 45 08             	mov    0x8(%ebp),%eax
    b0d3:	39 c2                	cmp    %eax,%edx
    b0d5:	75 19                	jne    b0f0 <free_page+0x100>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b0d7:	ba 80 17 01 00       	mov    $0x11780,%edx
    b0dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0df:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = END_LIST;
    b0e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0e4:	8b 40 08             	mov    0x8(%eax),%eax
    b0e7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return;
    b0ee:	eb 4d                	jmp    b13d <free_page+0x14d>
        }

        if (tmp->next_ != END_LIST && tmp->_address_ == page._address_) // At the middle
    b0f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0f3:	8b 40 0c             	mov    0xc(%eax),%eax
    b0f6:	85 c0                	test   %eax,%eax
    b0f8:	74 36                	je     b130 <free_page+0x140>
    b0fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b0fd:	8b 10                	mov    (%eax),%edx
    b0ff:	8b 45 08             	mov    0x8(%ebp),%eax
    b102:	39 c2                	cmp    %eax,%edx
    b104:	75 2a                	jne    b130 <free_page+0x140>
        {
            tmp->_address_ = NO_PHYSICAL_ADDRESS;
    b106:	ba 80 17 01 00       	mov    $0x11780,%edx
    b10b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b10e:	89 10                	mov    %edx,(%eax)
            tmp->previous_->next_ = tmp->next_;
    b110:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b113:	8b 40 08             	mov    0x8(%eax),%eax
    b116:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b119:	8b 52 0c             	mov    0xc(%edx),%edx
    b11c:	89 50 0c             	mov    %edx,0xc(%eax)
            tmp->next_->previous_ = tmp->previous_;
    b11f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    b122:	8b 40 0c             	mov    0xc(%eax),%eax
    b125:	8b 55 f8             	mov    -0x8(%ebp),%edx
    b128:	8b 52 08             	mov    0x8(%edx),%edx
    b12b:	89 50 08             	mov    %edx,0x8(%eax)
            return;
    b12e:	eb 0d                	jmp    b13d <free_page+0x14d>
        }
    }
    NMBER_PAGES_ALLOC--;
    b130:	a1 04 20 02 00       	mov    0x22004,%eax
    b135:	83 e8 01             	sub    $0x1,%eax
    b138:	a3 04 20 02 00       	mov    %eax,0x22004
    b13d:	c9                   	leave  
    b13e:	c3                   	ret    

0000b13f <__switch>:

static task_control_block_t main_task, task1, task2 , task3;


void __switch()
{
    b13f:	55                   	push   %ebp
    b140:	89 e5                	mov    %esp,%ebp
    b142:	83 ec 18             	sub    $0x18,%esp
    task_control_block_t* prev_task;

    prev_task = sheduler.running_task;
    b145:	a1 28 60 02 00       	mov    0x26028,%eax
    b14a:	89 45 f4             	mov    %eax,-0xc(%ebp)

    sheduler.running_task = sheduler.running_task->new_tasks;
    b14d:	a1 28 60 02 00       	mov    0x26028,%eax
    b152:	8b 40 3c             	mov    0x3c(%eax),%eax
    b155:	a3 28 60 02 00       	mov    %eax,0x26028

    switch_to_task(&(prev_task->regs), &(sheduler.running_task->regs));
    b15a:	a1 28 60 02 00       	mov    0x26028,%eax
    b15f:	89 c2                	mov    %eax,%edx
    b161:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b164:	83 ec 08             	sub    $0x8,%esp
    b167:	52                   	push   %edx
    b168:	50                   	push   %eax
    b169:	e8 c2 02 00 00       	call   b430 <switch_to_task>
    b16e:	83 c4 10             	add    $0x10,%esp
}
    b171:	90                   	nop
    b172:	c9                   	leave  
    b173:	c3                   	ret    

0000b174 <init_multitasking>:

void init_multitasking()
{
    b174:	55                   	push   %ebp
    b175:	89 e5                	mov    %esp,%ebp
    sheduler.init_timer = 0;
    b177:	c6 05 20 60 02 00 00 	movb   $0x0,0x26020
    sheduler.task_timer = DELAY_PER_TASK;
    b17e:	c7 05 24 60 02 00 2c 	movl   $0x12c,0x26024
    b185:	01 00 00 
}
    b188:	90                   	nop
    b189:	5d                   	pop    %ebp
    b18a:	c3                   	ret    

0000b18b <create_task>:

void create_task(task_control_block_t* task, void (*task_func)(), uint32_t eflags, uint32_t cr3)
{
    b18b:	55                   	push   %ebp
    b18c:	89 e5                	mov    %esp,%ebp
    b18e:	83 ec 08             	sub    $0x8,%esp
    task->regs.eax = 0;
    b191:	8b 45 08             	mov    0x8(%ebp),%eax
    b194:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    task->regs.ebx = 0;
    b19a:	8b 45 08             	mov    0x8(%ebp),%eax
    b19d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    task->regs.ecx = 0;
    b1a4:	8b 45 08             	mov    0x8(%ebp),%eax
    b1a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    task->regs.edx = 0;
    b1ae:	8b 45 08             	mov    0x8(%ebp),%eax
    b1b1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    task->regs.esi = 0;
    b1b8:	8b 45 08             	mov    0x8(%ebp),%eax
    b1bb:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    task->regs.edi = 0;
    b1c2:	8b 45 08             	mov    0x8(%ebp),%eax
    b1c5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    task->regs.eflags = eflags;
    b1cc:	8b 45 08             	mov    0x8(%ebp),%eax
    b1cf:	8b 55 10             	mov    0x10(%ebp),%edx
    b1d2:	89 50 24             	mov    %edx,0x24(%eax)
    task->regs.eip = (uint32_t)task_func;
    b1d5:	8b 55 0c             	mov    0xc(%ebp),%edx
    b1d8:	8b 45 08             	mov    0x8(%ebp),%eax
    b1db:	89 50 20             	mov    %edx,0x20(%eax)
    task->regs.cr3 = (uint32_t)cr3;
    b1de:	8b 45 08             	mov    0x8(%ebp),%eax
    b1e1:	8b 55 14             	mov    0x14(%ebp),%edx
    b1e4:	89 50 28             	mov    %edx,0x28(%eax)
    task->regs.esp = (uint32_t)kmalloc(200);
    b1e7:	83 ec 0c             	sub    $0xc,%esp
    b1ea:	68 c8 00 00 00       	push   $0xc8
    b1ef:	e8 c5 f8 ff ff       	call   aab9 <kmalloc>
    b1f4:	83 c4 10             	add    $0x10,%esp
    b1f7:	89 c2                	mov    %eax,%edx
    b1f9:	8b 45 08             	mov    0x8(%ebp),%eax
    b1fc:	89 50 18             	mov    %edx,0x18(%eax)
    task->new_tasks = 0;
    b1ff:	8b 45 08             	mov    0x8(%ebp),%eax
    b202:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
    b209:	90                   	nop
    b20a:	c9                   	leave  
    b20b:	c3                   	ret    
    b20c:	66 90                	xchg   %ax,%ax
    b20e:	66 90                	xchg   %ax,%ax

0000b210 <__exception_handler__>:
    b210:	58                   	pop    %eax
    b211:	a3 04 bc 00 00       	mov    %eax,0xbc04
    b216:	e8 ef df ff ff       	call   920a <__exception__>
    b21b:	cf                   	iret   

0000b21c <__exception_no_ERRCODE_handler__>:
    b21c:	e8 ef df ff ff       	call   9210 <__exception_no_ERRCODE__>
    b221:	cf                   	iret   
    b222:	66 90                	xchg   %ax,%ax
    b224:	66 90                	xchg   %ax,%ax
    b226:	66 90                	xchg   %ax,%ax
    b228:	66 90                	xchg   %ax,%ax
    b22a:	66 90                	xchg   %ax,%ax
    b22c:	66 90                	xchg   %ax,%ax
    b22e:	66 90                	xchg   %ax,%ax

0000b230 <gdtr>:
    b230:	00 00                	add    %al,(%eax)
    b232:	00 00                	add    %al,(%eax)
	...

0000b236 <load_gdt>:
    b236:	fa                   	cli    
    b237:	50                   	push   %eax
    b238:	51                   	push   %ecx
    b239:	b9 00 00 00 00       	mov    $0x0,%ecx
    b23e:	89 0d 32 b2 00 00    	mov    %ecx,0xb232
    b244:	31 c0                	xor    %eax,%eax
    b246:	b8 00 01 00 00       	mov    $0x100,%eax
    b24b:	01 c8                	add    %ecx,%eax
    b24d:	66 a3 30 b2 00 00    	mov    %ax,0xb230
    b253:	0f 01 15 30 b2 00 00 	lgdtl  0xb230
    b25a:	8b 0d 32 b2 00 00    	mov    0xb232,%ecx
    b260:	83 c1 20             	add    $0x20,%ecx
    b263:	0f 00 d9             	ltr    %cx
    b266:	59                   	pop    %ecx
    b267:	58                   	pop    %eax
    b268:	c3                   	ret    

0000b269 <idtr>:
    b269:	00 00                	add    %al,(%eax)
    b26b:	00 00                	add    %al,(%eax)
	...

0000b26f <load_idt>:
    b26f:	fa                   	cli    
    b270:	50                   	push   %eax
    b271:	51                   	push   %ecx
    b272:	31 c9                	xor    %ecx,%ecx
    b274:	b9 20 30 01 00       	mov    $0x13020,%ecx
    b279:	89 0d 6b b2 00 00    	mov    %ecx,0xb26b
    b27f:	31 c0                	xor    %eax,%eax
    b281:	b8 00 04 00 00       	mov    $0x400,%eax
    b286:	01 c8                	add    %ecx,%eax
    b288:	66 a3 69 b2 00 00    	mov    %ax,0xb269
    b28e:	0f 01 1d 69 b2 00 00 	lidtl  0xb269
    b295:	59                   	pop    %ecx
    b296:	58                   	pop    %eax
    b297:	c3                   	ret    
    b298:	66 90                	xchg   %ax,%ax
    b29a:	66 90                	xchg   %ax,%ax
    b29c:	66 90                	xchg   %ax,%ax
    b29e:	66 90                	xchg   %ax,%ax

0000b2a0 <irq1>:
    b2a0:	60                   	pusha  
    b2a1:	e8 02 e6 ff ff       	call   98a8 <irq1_handler>
    b2a6:	61                   	popa   
    b2a7:	cf                   	iret   

0000b2a8 <irq2>:
    b2a8:	60                   	pusha  
    b2a9:	e8 15 e6 ff ff       	call   98c3 <irq2_handler>
    b2ae:	61                   	popa   
    b2af:	cf                   	iret   

0000b2b0 <irq3>:
    b2b0:	60                   	pusha  
    b2b1:	e8 30 e6 ff ff       	call   98e6 <irq3_handler>
    b2b6:	61                   	popa   
    b2b7:	cf                   	iret   

0000b2b8 <irq4>:
    b2b8:	60                   	pusha  
    b2b9:	e8 4b e6 ff ff       	call   9909 <irq4_handler>
    b2be:	61                   	popa   
    b2bf:	cf                   	iret   

0000b2c0 <irq5>:
    b2c0:	60                   	pusha  
    b2c1:	e8 66 e6 ff ff       	call   992c <irq5_handler>
    b2c6:	61                   	popa   
    b2c7:	cf                   	iret   

0000b2c8 <irq6>:
    b2c8:	60                   	pusha  
    b2c9:	e8 81 e6 ff ff       	call   994f <irq6_handler>
    b2ce:	61                   	popa   
    b2cf:	cf                   	iret   

0000b2d0 <irq7>:
    b2d0:	60                   	pusha  
    b2d1:	e8 9c e6 ff ff       	call   9972 <irq7_handler>
    b2d6:	61                   	popa   
    b2d7:	cf                   	iret   

0000b2d8 <irq8>:
    b2d8:	60                   	pusha  
    b2d9:	e8 b7 e6 ff ff       	call   9995 <irq8_handler>
    b2de:	61                   	popa   
    b2df:	cf                   	iret   

0000b2e0 <irq9>:
    b2e0:	60                   	pusha  
    b2e1:	e8 d2 e6 ff ff       	call   99b8 <irq9_handler>
    b2e6:	61                   	popa   
    b2e7:	cf                   	iret   

0000b2e8 <irq10>:
    b2e8:	60                   	pusha  
    b2e9:	e8 ed e6 ff ff       	call   99db <irq10_handler>
    b2ee:	61                   	popa   
    b2ef:	cf                   	iret   

0000b2f0 <irq11>:
    b2f0:	60                   	pusha  
    b2f1:	e8 08 e7 ff ff       	call   99fe <irq11_handler>
    b2f6:	61                   	popa   
    b2f7:	cf                   	iret   

0000b2f8 <irq12>:
    b2f8:	60                   	pusha  
    b2f9:	e8 23 e7 ff ff       	call   9a21 <irq12_handler>
    b2fe:	61                   	popa   
    b2ff:	cf                   	iret   

0000b300 <irq13>:
    b300:	60                   	pusha  
    b301:	e8 3e e7 ff ff       	call   9a44 <irq13_handler>
    b306:	61                   	popa   
    b307:	cf                   	iret   

0000b308 <irq14>:
    b308:	60                   	pusha  
    b309:	e8 59 e7 ff ff       	call   9a67 <irq14_handler>
    b30e:	61                   	popa   
    b30f:	cf                   	iret   

0000b310 <irq15>:
    b310:	60                   	pusha  
    b311:	e8 74 e7 ff ff       	call   9a8a <irq15_handler>
    b316:	61                   	popa   
    b317:	cf                   	iret   
    b318:	66 90                	xchg   %ax,%ax
    b31a:	66 90                	xchg   %ax,%ax
    b31c:	66 90                	xchg   %ax,%ax
    b31e:	66 90                	xchg   %ax,%ax

0000b320 <_FlushPagingCache_>:
    b320:	b8 00 40 01 00       	mov    $0x14000,%eax
    b325:	0f 22 d8             	mov    %eax,%cr3
    b328:	c3                   	ret    

0000b329 <_EnablingPaging_>:
    b329:	e8 f2 ff ff ff       	call   b320 <_FlushPagingCache_>
    b32e:	0f 20 c0             	mov    %cr0,%eax
    b331:	0d 01 00 00 80       	or     $0x80000001,%eax
    b336:	0f 22 c0             	mov    %eax,%cr0
    b339:	c3                   	ret    

0000b33a <PagingFault_Handler>:
    b33a:	58                   	pop    %eax
    b33b:	a3 08 bc 00 00       	mov    %eax,0xbc08
    b340:	e8 1b eb ff ff       	call   9e60 <Paging_fault>
    b345:	cf                   	iret   
    b346:	66 90                	xchg   %ax,%ax
    b348:	66 90                	xchg   %ax,%ax
    b34a:	66 90                	xchg   %ax,%ax
    b34c:	66 90                	xchg   %ax,%ax
    b34e:	66 90                	xchg   %ax,%ax

0000b350 <PIT_handler>:
    b350:	9c                   	pushf  
    b351:	e8 16 00 00 00       	call   b36c <irq_PIT>
    b356:	e8 4b ed ff ff       	call   a0a6 <conserv_status_byte>
    b35b:	e8 fc ed ff ff       	call   a15c <sheduler_cpu_timer>
    b360:	90                   	nop
    b361:	90                   	nop
    b362:	90                   	nop
    b363:	90                   	nop
    b364:	90                   	nop
    b365:	90                   	nop
    b366:	90                   	nop
    b367:	90                   	nop
    b368:	90                   	nop
    b369:	90                   	nop
    b36a:	9d                   	popf   
    b36b:	cf                   	iret   

0000b36c <irq_PIT>:
    b36c:	a1 48 61 02 00       	mov    0x26148,%eax
    b371:	8b 1d 4c 61 02 00    	mov    0x2614c,%ebx
    b377:	01 05 40 61 02 00    	add    %eax,0x26140
    b37d:	11 1d 44 61 02 00    	adc    %ebx,0x26144
    b383:	6a 00                	push   $0x0
    b385:	e8 dc ea ff ff       	call   9e66 <PIC_sendEOI>
    b38a:	58                   	pop    %eax
    b38b:	c3                   	ret    

0000b38c <calculate_frequency>:
    b38c:	60                   	pusha  
    b38d:	8b 1d 04 50 01 00    	mov    0x15004,%ebx
    b393:	b8 00 00 01 00       	mov    $0x10000,%eax
    b398:	83 fb 12             	cmp    $0x12,%ebx
    b39b:	76 34                	jbe    b3d1 <calculate_frequency.gotReloadValue>
    b39d:	b8 01 00 00 00       	mov    $0x1,%eax
    b3a2:	81 fb dd 34 12 00    	cmp    $0x1234dd,%ebx
    b3a8:	73 27                	jae    b3d1 <calculate_frequency.gotReloadValue>
    b3aa:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b3af:	ba 00 00 00 00       	mov    $0x0,%edx
    b3b4:	f7 f3                	div    %ebx
    b3b6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b3bc:	72 01                	jb     b3bf <calculate_frequency.l1>
    b3be:	40                   	inc    %eax

0000b3bf <calculate_frequency.l1>:
    b3bf:	bb 03 00 00 00       	mov    $0x3,%ebx
    b3c4:	ba 00 00 00 00       	mov    $0x0,%edx
    b3c9:	f7 f3                	div    %ebx
    b3cb:	83 fa 01             	cmp    $0x1,%edx
    b3ce:	72 01                	jb     b3d1 <calculate_frequency.gotReloadValue>
    b3d0:	40                   	inc    %eax

0000b3d1 <calculate_frequency.gotReloadValue>:
    b3d1:	50                   	push   %eax
    b3d2:	66 a3 54 61 02 00    	mov    %ax,0x26154
    b3d8:	89 c3                	mov    %eax,%ebx
    b3da:	b8 99 9e 36 00       	mov    $0x369e99,%eax
    b3df:	ba 00 00 00 00       	mov    $0x0,%edx
    b3e4:	f7 f3                	div    %ebx
    b3e6:	81 fa 4c 4f 1b 00    	cmp    $0x1b4f4c,%edx
    b3ec:	72 01                	jb     b3ef <calculate_frequency.l3>
    b3ee:	40                   	inc    %eax

0000b3ef <calculate_frequency.l3>:
    b3ef:	bb 03 00 00 00       	mov    $0x3,%ebx
    b3f4:	ba 00 00 00 00       	mov    $0x0,%edx
    b3f9:	f7 f3                	div    %ebx
    b3fb:	83 fa 01             	cmp    $0x1,%edx
    b3fe:	72 01                	jb     b401 <calculate_frequency.l4>
    b400:	40                   	inc    %eax

0000b401 <calculate_frequency.l4>:
    b401:	a3 50 61 02 00       	mov    %eax,0x26150
    b406:	5b                   	pop    %ebx
    b407:	b8 62 a0 b3 db       	mov    $0xdbb3a062,%eax
    b40c:	f7 e3                	mul    %ebx
    b40e:	0f ac d0 0a          	shrd   $0xa,%edx,%eax
    b412:	c1 ea 0a             	shr    $0xa,%edx
    b415:	89 15 4c 61 02 00    	mov    %edx,0x2614c
    b41b:	a3 48 61 02 00       	mov    %eax,0x26148
    b420:	61                   	popa   
    b421:	c3                   	ret    
    b422:	66 90                	xchg   %ax,%ax
    b424:	66 90                	xchg   %ax,%ax
    b426:	66 90                	xchg   %ax,%ax
    b428:	66 90                	xchg   %ax,%ax
    b42a:	66 90                	xchg   %ax,%ax
    b42c:	66 90                	xchg   %ax,%ax
    b42e:	66 90                	xchg   %ax,%ax

0000b430 <switch_to_task>:
    b430:	50                   	push   %eax
    b431:	8b 44 24 08          	mov    0x8(%esp),%eax
    b435:	89 58 04             	mov    %ebx,0x4(%eax)
    b438:	89 48 08             	mov    %ecx,0x8(%eax)
    b43b:	89 50 0c             	mov    %edx,0xc(%eax)
    b43e:	89 70 10             	mov    %esi,0x10(%eax)
    b441:	89 78 14             	mov    %edi,0x14(%eax)
    b444:	89 60 18             	mov    %esp,0x18(%eax)
    b447:	89 68 1c             	mov    %ebp,0x1c(%eax)
    b44a:	51                   	push   %ecx
    b44b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
    b44f:	89 48 20             	mov    %ecx,0x20(%eax)
    b452:	59                   	pop    %ecx
    b453:	51                   	push   %ecx
    b454:	9c                   	pushf  
    b455:	59                   	pop    %ecx
    b456:	89 48 24             	mov    %ecx,0x24(%eax)
    b459:	59                   	pop    %ecx
    b45a:	51                   	push   %ecx
    b45b:	0f 20 d9             	mov    %cr3,%ecx
    b45e:	89 48 28             	mov    %ecx,0x28(%eax)
    b461:	59                   	pop    %ecx
    b462:	8c 40 2c             	mov    %es,0x2c(%eax)
    b465:	8c 68 2e             	mov    %gs,0x2e(%eax)
    b468:	8c 60 30             	mov    %fs,0x30(%eax)
    b46b:	51                   	push   %ecx
    b46c:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    b470:	89 08                	mov    %ecx,(%eax)
    b472:	59                   	pop    %ecx
    b473:	58                   	pop    %eax
    b474:	8b 44 24 08          	mov    0x8(%esp),%eax
    b478:	8b 58 04             	mov    0x4(%eax),%ebx
    b47b:	8b 48 08             	mov    0x8(%eax),%ecx
    b47e:	8b 50 0c             	mov    0xc(%eax),%edx
    b481:	8b 70 10             	mov    0x10(%eax),%esi
    b484:	8b 78 14             	mov    0x14(%eax),%edi
    b487:	8b 60 18             	mov    0x18(%eax),%esp
    b48a:	8b 68 1c             	mov    0x1c(%eax),%ebp
    b48d:	51                   	push   %ecx
    b48e:	8b 48 24             	mov    0x24(%eax),%ecx
    b491:	51                   	push   %ecx
    b492:	9d                   	popf   
    b493:	59                   	pop    %ecx
    b494:	51                   	push   %ecx
    b495:	8b 48 28             	mov    0x28(%eax),%ecx
    b498:	0f 22 d9             	mov    %ecx,%cr3
    b49b:	59                   	pop    %ecx
    b49c:	8e 40 2c             	mov    0x2c(%eax),%es
    b49f:	8e 68 2e             	mov    0x2e(%eax),%gs
    b4a2:	8e 60 30             	mov    0x30(%eax),%fs
    b4a5:	8b 40 20             	mov    0x20(%eax),%eax
    b4a8:	89 04 24             	mov    %eax,(%esp)
    b4ab:	c3                   	ret    

Déassemblage de la section .test_section__code :

0000b4ac <gdt_testing_func__2_>:
    &gdt_testing_func__2_,
    NULL,
    NULL};

TEST_UNIT_FUNC(gdt_testing_func__2_)
{
    b4ac:	55                   	push   %ebp
    b4ad:	89 e5                	mov    %esp,%ebp
    __gdt_testing_2_.passed = true;
    b4af:	c7 05 00 f0 00 00 00 	movl   $0x0,0xf000
    b4b6:	00 00 00 
    asm volatile(
    b4b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    b4be:	8e d8                	mov    %eax,%ds
        "mov $0xFFFFFFFF , %eax \n    \
    mov %eax , %ds\n");
    __gdt_testing_2_.passed = false;
    b4c0:	c7 05 00 f0 00 00 01 	movl   $0x1,0xf000
    b4c7:	00 00 00 
}
    b4ca:	90                   	nop
    b4cb:	5d                   	pop    %ebp
    b4cc:	c3                   	ret    

0000b4cd <gdt_testing_func__3_>:
                               "Verify the CS beyond his expected limit\n",
                               &gdt_testing_func__3_,
                               NULL,
                               NULL};
TEST_UNIT_FUNC(gdt_testing_func__3_)
{
    b4cd:	55                   	push   %ebp
    b4ce:	89 e5                	mov    %esp,%ebp
    __gdt_testing_3_.passed = true;
    b4d0:	c7 05 20 f2 00 00 00 	movl   $0x0,0xf220
    b4d7:	00 00 00 
    asm volatile("ljmp $0xFFFFFFFF , $0xFFFF");
    b4da:	ea ff ff 00 00 ff ff 	ljmp   $0xffff,$0xffff
    __gdt_testing_3_.passed = false;
    b4e1:	c7 05 20 f2 00 00 01 	movl   $0x1,0xf220
    b4e8:	00 00 00 
}
    b4eb:	90                   	nop
    b4ec:	5d                   	pop    %ebp
    b4ed:	c3                   	ret    

0000b4ee <func__test_all_interrupt>:
    true, "test all interrupt", "Test all interrrupt", &func__test_all_interrupt, NULL, NULL

};

TEST_UNIT_FUNC(func__test_all_interrupt)
{
    b4ee:	55                   	push   %ebp
    b4ef:	89 e5                	mov    %esp,%ebp
    b4f1:	83 ec 18             	sub    $0x18,%esp
    uint8_t i;

    for (i = 32; i <= 48; i++) {
    b4f4:	c6 45 f7 20          	movb   $0x20,-0x9(%ebp)
    b4f8:	eb 20                	jmp    b51a <func__test_all_interrupt+0x2c>
        // asm("int %0" ::"m"(i) : "memory");

        kprintf(3, 0x7, "[K:Int]\tInterrupt request query % has done \n", i);
    b4fa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    b4fe:	50                   	push   %eax
    b4ff:	68 8c 17 01 00       	push   $0x1178c
    b504:	6a 07                	push   $0x7
    b506:	6a 03                	push   $0x3
    b508:	e8 5b ef ff ff       	call   a468 <kprintf>
    b50d:	83 c4 10             	add    $0x10,%esp
    for (i = 32; i <= 48; i++) {
    b510:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    b514:	83 c0 01             	add    $0x1,%eax
    b517:	88 45 f7             	mov    %al,-0x9(%ebp)
    b51a:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
    b51e:	76 da                	jbe    b4fa <func__test_all_interrupt+0xc>
    }
}
    b520:	90                   	nop
    b521:	90                   	nop
    b522:	c9                   	leave  
    b523:	c3                   	ret    

0000b524 <__test_paging_1>:

    test_write_page_2.passed = true;
}

TEST_UNIT_FUNC(__test_paging_1)
{
    b524:	55                   	push   %ebp
    b525:	89 e5                	mov    %esp,%ebp
    b527:	81 ec e8 07 00 00    	sub    $0x7e8,%esp
    test_write_page.passed = true;
    b52d:	c7 05 e0 fa 00 00 00 	movl   $0x0,0xfae0
    b534:	00 00 00 
    uint32_t page_table[500];
    create_page_table(page_table, 1);
    b537:	83 ec 08             	sub    $0x8,%esp
    b53a:	6a 01                	push   $0x1
    b53c:	8d 85 24 f8 ff ff    	lea    -0x7dc(%ebp),%eax
    b542:	50                   	push   %eax
    b543:	e8 3a e7 ff ff       	call   9c82 <create_page_table>
    b548:	83 c4 10             	add    $0x10,%esp

    uint8_t* ptr;

    ptr = (uint8_t*)0x400000;
    b54b:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)

    *ptr = '\t';
    b552:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b555:	c6 00 09             	movb   $0x9,(%eax)
    test_write_page.passed = false;
    b558:	c7 05 e0 fa 00 00 01 	movl   $0x1,0xfae0
    b55f:	00 00 00 
}
    b562:	90                   	nop
    b563:	c9                   	leave  
    b564:	c3                   	ret    

0000b565 <__test_paging_2>:
{
    b565:	55                   	push   %ebp
    b566:	89 e5                	mov    %esp,%ebp
    b568:	81 ec e8 07 00 00    	sub    $0x7e8,%esp
    create_page_table(page_table, 1);
    b56e:	83 ec 08             	sub    $0x8,%esp
    b571:	6a 01                	push   $0x1
    b573:	8d 85 24 f8 ff ff    	lea    -0x7dc(%ebp),%eax
    b579:	50                   	push   %eax
    b57a:	e8 03 e7 ff ff       	call   9c82 <create_page_table>
    b57f:	83 c4 10             	add    $0x10,%esp
    ptr = (uint8_t*)0x400000;
    b582:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
    map_linear_address((uint32_t*)0x400000);
    b589:	83 ec 0c             	sub    $0xc,%esp
    b58c:	68 00 00 40 00       	push   $0x400000
    b591:	e8 47 e8 ff ff       	call   9ddd <map_linear_address>
    b596:	83 c4 10             	add    $0x10,%esp
    *ptr = '\t';
    b599:	8b 45 f4             	mov    -0xc(%ebp),%eax
    b59c:	c6 00 09             	movb   $0x9,(%eax)
    test_write_page_2.passed = true;
    b59f:	c7 05 00 fd 00 00 00 	movl   $0x0,0xfd00
    b5a6:	00 00 00 
}
    b5a9:	90                   	nop
    b5aa:	c9                   	leave  
    b5ab:	c3                   	ret    

0000b5ac <page_mm_test_func__1>:
    &page_mm_test_func__4,
    NULL,
    NULL};

TEST_UNIT_FUNC(page_mm_test_func__1)
{
    b5ac:	55                   	push   %ebp
    b5ad:	89 e5                	mov    %esp,%ebp
    b5af:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;
    page_mm_test__1.passed = true;
    b5b2:	c7 05 60 01 01 00 00 	movl   $0x0,0x10160
    b5b9:	00 00 00 

    for (i = 0; i < 0x400; i++)
    b5bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b5c3:	eb 12                	jmp    b5d7 <page_mm_test_func__1+0x2b>
        alloc_page(i);
    b5c5:	83 ec 0c             	sub    $0xc,%esp
    b5c8:	ff 75 f4             	pushl  -0xc(%ebp)
    b5cb:	e8 16 f8 ff ff       	call   ade6 <alloc_page>
    b5d0:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 0x400; i++)
    b5d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b5d7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    b5de:	76 e5                	jbe    b5c5 <page_mm_test_func__1+0x19>

    _address_order_track_* tmp;

    tmp = _page_area_track_->next_;
    b5e0:	a1 00 20 02 00       	mov    0x22000,%eax
    b5e5:	8b 40 0c             	mov    0xc(%eax),%eax
    b5e8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (tmp->next_ != END_LIST) {
    b5eb:	eb 34                	jmp    b621 <page_mm_test_func__1+0x75>
        if (tmp->_address_ != tmp->previous_->_address_ + (tmp->previous_->order * PAGE_SIZE)) {
    b5ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b5f0:	8b 10                	mov    (%eax),%edx
    b5f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b5f5:	8b 40 08             	mov    0x8(%eax),%eax
    b5f8:	8b 08                	mov    (%eax),%ecx
    b5fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b5fd:	8b 40 08             	mov    0x8(%eax),%eax
    b600:	8b 40 04             	mov    0x4(%eax),%eax
    b603:	c1 e0 0c             	shl    $0xc,%eax
    b606:	01 c8                	add    %ecx,%eax
    b608:	39 c2                	cmp    %eax,%edx
    b60a:	74 0c                	je     b618 <page_mm_test_func__1+0x6c>
            page_mm_test__1.passed = false;
    b60c:	c7 05 60 01 01 00 01 	movl   $0x1,0x10160
    b613:	00 00 00 
            return;
    b616:	eb 21                	jmp    b639 <page_mm_test_func__1+0x8d>
        }
        tmp = tmp->next_;
    b618:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b61b:	8b 40 0c             	mov    0xc(%eax),%eax
    b61e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    b621:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b624:	8b 40 0c             	mov    0xc(%eax),%eax
    b627:	85 c0                	test   %eax,%eax
    b629:	75 c2                	jne    b5ed <page_mm_test_func__1+0x41>
    }

    if (page_mm_test__1.passed == true)
    b62b:	a1 60 01 01 00       	mov    0x10160,%eax
    b630:	85 c0                	test   %eax,%eax
    b632:	75 05                	jne    b639 <page_mm_test_func__1+0x8d>
        page_mm_test_func__2();
    b634:	e8 02 00 00 00       	call   b63b <page_mm_test_func__2>
}
    b639:	c9                   	leave  
    b63a:	c3                   	ret    

0000b63b <page_mm_test_func__2>:
TEST_UNIT_FUNC(page_mm_test_func__2)
{
    b63b:	55                   	push   %ebp
    b63c:	89 e5                	mov    %esp,%ebp
    b63e:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;

    for (i = 0; i < 0x400; i++)
    b641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b648:	eb 2c                	jmp    b676 <page_mm_test_func__2+0x3b>
        free_page(*_page_area_track_);
    b64a:	a1 00 20 02 00       	mov    0x22000,%eax
    b64f:	83 ec 10             	sub    $0x10,%esp
    b652:	89 e2                	mov    %esp,%edx
    b654:	8b 08                	mov    (%eax),%ecx
    b656:	89 0a                	mov    %ecx,(%edx)
    b658:	8b 48 04             	mov    0x4(%eax),%ecx
    b65b:	89 4a 04             	mov    %ecx,0x4(%edx)
    b65e:	8b 48 08             	mov    0x8(%eax),%ecx
    b661:	89 4a 08             	mov    %ecx,0x8(%edx)
    b664:	8b 40 0c             	mov    0xc(%eax),%eax
    b667:	89 42 0c             	mov    %eax,0xc(%edx)
    b66a:	e8 81 f9 ff ff       	call   aff0 <free_page>
    b66f:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 0x400; i++)
    b672:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b676:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    b67d:	76 cb                	jbe    b64a <page_mm_test_func__2+0xf>

    if (_page_area_track_->next_ == END_LIST)
    b67f:	a1 00 20 02 00       	mov    0x22000,%eax
    b684:	8b 40 0c             	mov    0xc(%eax),%eax
    b687:	85 c0                	test   %eax,%eax
    b689:	75 0c                	jne    b697 <page_mm_test_func__2+0x5c>
        page_mm_test__2.passed = true;
    b68b:	c7 05 80 03 01 00 00 	movl   $0x0,0x10380
    b692:	00 00 00 

    else
        page_mm_test__2.passed = false;
}
    b695:	eb 0a                	jmp    b6a1 <page_mm_test_func__2+0x66>
        page_mm_test__2.passed = false;
    b697:	c7 05 80 03 01 00 01 	movl   $0x1,0x10380
    b69e:	00 00 00 
}
    b6a1:	90                   	nop
    b6a2:	c9                   	leave  
    b6a3:	c3                   	ret    

0000b6a4 <page_mm_test_func__3>:

TEST_UNIT_FUNC(page_mm_test_func__3)
{
    b6a4:	55                   	push   %ebp
    b6a5:	89 e5                	mov    %esp,%ebp
    b6a7:	83 ec 18             	sub    $0x18,%esp
    if (page_mm_test__2.passed == false || page_mm_test__1.passed == false) {
    b6aa:	a1 80 03 01 00       	mov    0x10380,%eax
    b6af:	83 f8 01             	cmp    $0x1,%eax
    b6b2:	74 0a                	je     b6be <page_mm_test_func__3+0x1a>
    b6b4:	a1 60 01 01 00       	mov    0x10160,%eax
    b6b9:	83 f8 01             	cmp    $0x1,%eax
    b6bc:	75 0f                	jne    b6cd <page_mm_test_func__3+0x29>
        page_mm_test__3.passed = false;
    b6be:	c7 05 a0 05 01 00 01 	movl   $0x1,0x105a0
    b6c5:	00 00 00 
        return;
    b6c8:	e9 c5 00 00 00       	jmp    b792 <page_mm_test_func__3+0xee>
    }

    uint32_t i;

    // Begin by allocate some page
    for (i = 0; i < 0x400; i++)
    b6cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b6d4:	eb 12                	jmp    b6e8 <page_mm_test_func__3+0x44>
        alloc_page(i);
    b6d6:	83 ec 0c             	sub    $0xc,%esp
    b6d9:	ff 75 f4             	pushl  -0xc(%ebp)
    b6dc:	e8 05 f7 ff ff       	call   ade6 <alloc_page>
    b6e1:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 0x400; i++)
    b6e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b6e8:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    b6ef:	76 e5                	jbe    b6d6 <page_mm_test_func__3+0x32>

    // Remove it randomly
    for (i = 0; i < 0x400; i++) {
    b6f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b6f8:	eb 75                	jmp    b76f <page_mm_test_func__3+0xcb>
        int j = compteur % (0x400 - i), k = 1;
    b6fa:	a1 00 50 01 00       	mov    0x15000,%eax
    b6ff:	ba 00 04 00 00       	mov    $0x400,%edx
    b704:	89 d1                	mov    %edx,%ecx
    b706:	2b 4d f4             	sub    -0xc(%ebp),%ecx
    b709:	ba 00 00 00 00       	mov    $0x0,%edx
    b70e:	f7 f1                	div    %ecx
    b710:	89 d0                	mov    %edx,%eax
    b712:	89 45 e8             	mov    %eax,-0x18(%ebp)
    b715:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

        _address_order_track_* tmp;

        tmp = _page_area_track_;
    b71c:	a1 00 20 02 00       	mov    0x22000,%eax
    b721:	89 45 ec             	mov    %eax,-0x14(%ebp)

        while (tmp->next_ != END_LIST && k < j) {
    b724:	eb 0d                	jmp    b733 <page_mm_test_func__3+0x8f>
            tmp = tmp->next_;
    b726:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b729:	8b 40 0c             	mov    0xc(%eax),%eax
    b72c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            k++;
    b72f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
        while (tmp->next_ != END_LIST && k < j) {
    b733:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b736:	8b 40 0c             	mov    0xc(%eax),%eax
    b739:	85 c0                	test   %eax,%eax
    b73b:	74 08                	je     b745 <page_mm_test_func__3+0xa1>
    b73d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b740:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    b743:	7c e1                	jl     b726 <page_mm_test_func__3+0x82>
        }

        free_page(*tmp);
    b745:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b748:	83 ec 10             	sub    $0x10,%esp
    b74b:	89 e2                	mov    %esp,%edx
    b74d:	8b 08                	mov    (%eax),%ecx
    b74f:	89 0a                	mov    %ecx,(%edx)
    b751:	8b 48 04             	mov    0x4(%eax),%ecx
    b754:	89 4a 04             	mov    %ecx,0x4(%edx)
    b757:	8b 48 08             	mov    0x8(%eax),%ecx
    b75a:	89 4a 08             	mov    %ecx,0x8(%edx)
    b75d:	8b 40 0c             	mov    0xc(%eax),%eax
    b760:	89 42 0c             	mov    %eax,0xc(%edx)
    b763:	e8 88 f8 ff ff       	call   aff0 <free_page>
    b768:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 0x400; i++) {
    b76b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b76f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    b776:	76 82                	jbe    b6fa <page_mm_test_func__3+0x56>
    }

    if (_page_area_track_->_address_ == NO_PHYSICAL_ADDRESS)
    b778:	a1 00 20 02 00       	mov    0x22000,%eax
    b77d:	8b 00                	mov    (%eax),%eax
    b77f:	ba b9 17 01 00       	mov    $0x117b9,%edx
    b784:	39 d0                	cmp    %edx,%eax
    b786:	75 0a                	jne    b792 <page_mm_test_func__3+0xee>
        page_mm_test__3.passed = true;
    b788:	c7 05 a0 05 01 00 00 	movl   $0x0,0x105a0
    b78f:	00 00 00 
}
    b792:	c9                   	leave  
    b793:	c3                   	ret    

0000b794 <page_mm_test_func__4>:
TEST_UNIT_FUNC(page_mm_test_func__4)
{
    b794:	55                   	push   %ebp
    b795:	89 e5                	mov    %esp,%ebp
    b797:	83 ec 18             	sub    $0x18,%esp
    uint32_t i, j;

    for (i = 1; i < 10; i++) {
    b79a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    b7a1:	eb 27                	jmp    b7ca <page_mm_test_func__4+0x36>
        j = compteur % (i + 1);
    b7a3:	a1 00 50 01 00       	mov    0x15000,%eax
    b7a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    b7ab:	8d 4a 01             	lea    0x1(%edx),%ecx
    b7ae:	ba 00 00 00 00       	mov    $0x0,%edx
    b7b3:	f7 f1                	div    %ecx
    b7b5:	89 55 ec             	mov    %edx,-0x14(%ebp)

        alloc_page(j);
    b7b8:	83 ec 0c             	sub    $0xc,%esp
    b7bb:	ff 75 ec             	pushl  -0x14(%ebp)
    b7be:	e8 23 f6 ff ff       	call   ade6 <alloc_page>
    b7c3:	83 c4 10             	add    $0x10,%esp
    for (i = 1; i < 10; i++) {
    b7c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b7ca:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    b7ce:	76 d3                	jbe    b7a3 <page_mm_test_func__4+0xf>
    }

    _address_order_track_* tmp;

    tmp = _page_area_track_->next_;
    b7d0:	a1 00 20 02 00       	mov    0x22000,%eax
    b7d5:	8b 40 0c             	mov    0xc(%eax),%eax
    b7d8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    while (tmp->next_ != END_LIST) {
    b7db:	eb 34                	jmp    b811 <page_mm_test_func__4+0x7d>
        if (tmp->_address_ < tmp->previous_->_address_ + (tmp->previous_->order * PAGE_SIZE)) {
    b7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b7e0:	8b 10                	mov    (%eax),%edx
    b7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b7e5:	8b 40 08             	mov    0x8(%eax),%eax
    b7e8:	8b 08                	mov    (%eax),%ecx
    b7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b7ed:	8b 40 08             	mov    0x8(%eax),%eax
    b7f0:	8b 40 04             	mov    0x4(%eax),%eax
    b7f3:	c1 e0 0c             	shl    $0xc,%eax
    b7f6:	01 c8                	add    %ecx,%eax
    b7f8:	39 c2                	cmp    %eax,%edx
    b7fa:	73 0c                	jae    b808 <page_mm_test_func__4+0x74>
            page_mm_test__4.passed = false;
    b7fc:	c7 05 c0 07 01 00 01 	movl   $0x1,0x107c0
    b803:	00 00 00 
            return;
    b806:	eb 13                	jmp    b81b <page_mm_test_func__4+0x87>
        }
        tmp = tmp->next_;
    b808:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b80b:	8b 40 0c             	mov    0xc(%eax),%eax
    b80e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next_ != END_LIST) {
    b811:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b814:	8b 40 0c             	mov    0xc(%eax),%eax
    b817:	85 c0                	test   %eax,%eax
    b819:	75 c2                	jne    b7dd <page_mm_test_func__4+0x49>
    }
}
    b81b:	c9                   	leave  
    b81c:	c3                   	ret    

0000b81d <mm_test_func__1>:
    &mm_test_func__4,
    NULL,
    NULL};

TEST_UNIT_FUNC(mm_test_func__1)
{
    b81d:	55                   	push   %ebp
    b81e:	89 e5                	mov    %esp,%ebp
    b820:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;
    mm_test__1.passed = true;
    b823:	c7 05 20 0c 01 00 00 	movl   $0x0,0x10c20
    b82a:	00 00 00 

    for (i = 0; i < 0x400; i++)
    b82d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b834:	eb 12                	jmp    b848 <mm_test_func__1+0x2b>
        kmalloc(i);
    b836:	83 ec 0c             	sub    $0xc,%esp
    b839:	ff 75 f4             	pushl  -0xc(%ebp)
    b83c:	e8 78 f2 ff ff       	call   aab9 <kmalloc>
    b841:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 0x400; i++)
    b844:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b848:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    b84f:	76 e5                	jbe    b836 <mm_test_func__1+0x19>

    _virt_mm_ *tmp, *tmp_prev;

    tmp = _head_vmm_->next;
    b851:	a1 20 10 02 00       	mov    0x21020,%eax
    b856:	8b 40 08             	mov    0x8(%eax),%eax
    b859:	89 45 f0             	mov    %eax,-0x10(%ebp)
    tmp_prev = _head_vmm_;
    b85c:	a1 20 10 02 00       	mov    0x21020,%eax
    b861:	89 45 ec             	mov    %eax,-0x14(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    b864:	eb 31                	jmp    b897 <mm_test_func__1+0x7a>
        if (tmp->address != tmp_prev->address + tmp_prev->size) {
    b866:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b869:	8b 10                	mov    (%eax),%edx
    b86b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b86e:	8b 08                	mov    (%eax),%ecx
    b870:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b873:	8b 40 04             	mov    0x4(%eax),%eax
    b876:	01 c8                	add    %ecx,%eax
    b878:	39 c2                	cmp    %eax,%edx
    b87a:	74 0c                	je     b888 <mm_test_func__1+0x6b>
            mm_test__1.passed = false;
    b87c:	c7 05 20 0c 01 00 01 	movl   $0x1,0x10c20
    b883:	00 00 00 
            return;
    b886:	eb 27                	jmp    b8af <mm_test_func__1+0x92>
        }
        tmp_prev = tmp;
    b888:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b88b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        tmp = tmp->next;
    b88e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b891:	8b 40 08             	mov    0x8(%eax),%eax
    b894:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    b897:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b89a:	8b 40 08             	mov    0x8(%eax),%eax
    b89d:	85 c0                	test   %eax,%eax
    b89f:	75 c5                	jne    b866 <mm_test_func__1+0x49>
    }

    if (mm_test__1.passed == true)
    b8a1:	a1 20 0c 01 00       	mov    0x10c20,%eax
    b8a6:	85 c0                	test   %eax,%eax
    b8a8:	75 05                	jne    b8af <mm_test_func__1+0x92>
        mm_test_func__2();
    b8aa:	e8 02 00 00 00       	call   b8b1 <mm_test_func__2>
}
    b8af:	c9                   	leave  
    b8b0:	c3                   	ret    

0000b8b1 <mm_test_func__2>:

TEST_UNIT_FUNC(mm_test_func__2)
{
    b8b1:	55                   	push   %ebp
    b8b2:	89 e5                	mov    %esp,%ebp
    b8b4:	83 ec 18             	sub    $0x18,%esp
    uint32_t i;
    for (i = 0; i < 0x400; i++)
    b8b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b8be:	eb 17                	jmp    b8d7 <mm_test_func__2+0x26>
        free(_head_vmm_->address);
    b8c0:	a1 20 10 02 00       	mov    0x21020,%eax
    b8c5:	8b 00                	mov    (%eax),%eax
    b8c7:	83 ec 0c             	sub    $0xc,%esp
    b8ca:	50                   	push   %eax
    b8cb:	e8 ad f3 ff ff       	call   ac7d <free>
    b8d0:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 0x400; i++)
    b8d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b8d7:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    b8de:	76 e0                	jbe    b8c0 <mm_test_func__2+0xf>
    if (_head_vmm_->next == (_virt_mm_*)NULL)
    b8e0:	a1 20 10 02 00       	mov    0x21020,%eax
    b8e5:	8b 40 08             	mov    0x8(%eax),%eax
    b8e8:	85 c0                	test   %eax,%eax
    b8ea:	75 0c                	jne    b8f8 <mm_test_func__2+0x47>
        mm_test__2.passed = true;
    b8ec:	c7 05 40 0e 01 00 00 	movl   $0x0,0x10e40
    b8f3:	00 00 00 

    else
        mm_test__2.passed = false;
}
    b8f6:	eb 0a                	jmp    b902 <mm_test_func__2+0x51>
        mm_test__2.passed = false;
    b8f8:	c7 05 40 0e 01 00 01 	movl   $0x1,0x10e40
    b8ff:	00 00 00 
}
    b902:	90                   	nop
    b903:	c9                   	leave  
    b904:	c3                   	ret    

0000b905 <mm_test_func__3>:

TEST_UNIT_FUNC(mm_test_func__3)
{
    b905:	55                   	push   %ebp
    b906:	89 e5                	mov    %esp,%ebp
    b908:	83 ec 18             	sub    $0x18,%esp
    if (mm_test__2.passed == false || mm_test__3.passed == false) {
    b90b:	a1 40 0e 01 00       	mov    0x10e40,%eax
    b910:	83 f8 01             	cmp    $0x1,%eax
    b913:	74 0a                	je     b91f <mm_test_func__3+0x1a>
    b915:	a1 60 10 01 00       	mov    0x11060,%eax
    b91a:	83 f8 01             	cmp    $0x1,%eax
    b91d:	75 0f                	jne    b92e <mm_test_func__3+0x29>
        mm_test__3.passed = false;
    b91f:	c7 05 60 10 01 00 01 	movl   $0x1,0x11060
    b926:	00 00 00 
        return;
    b929:	e9 ab 00 00 00       	jmp    b9d9 <mm_test_func__3+0xd4>
    }

    uint32_t i;
    for (i = 0; i < 0x400; i++)
    b92e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b935:	eb 12                	jmp    b949 <mm_test_func__3+0x44>
        kmalloc(i);
    b937:	83 ec 0c             	sub    $0xc,%esp
    b93a:	ff 75 f4             	pushl  -0xc(%ebp)
    b93d:	e8 77 f1 ff ff       	call   aab9 <kmalloc>
    b942:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 0x400; i++)
    b945:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b949:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    b950:	76 e5                	jbe    b937 <mm_test_func__3+0x32>

    for (i = 0; i < 0x400; i++) {
    b952:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b959:	eb 60                	jmp    b9bb <mm_test_func__3+0xb6>
        int j = compteur % (0x400 - i), k = 1;
    b95b:	a1 00 50 01 00       	mov    0x15000,%eax
    b960:	ba 00 04 00 00       	mov    $0x400,%edx
    b965:	89 d1                	mov    %edx,%ecx
    b967:	2b 4d f4             	sub    -0xc(%ebp),%ecx
    b96a:	ba 00 00 00 00       	mov    $0x0,%edx
    b96f:	f7 f1                	div    %ecx
    b971:	89 d0                	mov    %edx,%eax
    b973:	89 45 e8             	mov    %eax,-0x18(%ebp)
    b976:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

        _virt_mm_* tmp;

        tmp = _head_vmm_;
    b97d:	a1 20 10 02 00       	mov    0x21020,%eax
    b982:	89 45 ec             	mov    %eax,-0x14(%ebp)

        while (tmp->next != (_virt_mm_*)NULL && k < j) {
    b985:	eb 0d                	jmp    b994 <mm_test_func__3+0x8f>
            tmp = tmp->next;
    b987:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b98a:	8b 40 08             	mov    0x8(%eax),%eax
    b98d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            k++;
    b990:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
        while (tmp->next != (_virt_mm_*)NULL && k < j) {
    b994:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b997:	8b 40 08             	mov    0x8(%eax),%eax
    b99a:	85 c0                	test   %eax,%eax
    b99c:	74 08                	je     b9a6 <mm_test_func__3+0xa1>
    b99e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    b9a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
    b9a4:	7c e1                	jl     b987 <mm_test_func__3+0x82>
        }

        free(tmp->address);
    b9a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    b9a9:	8b 00                	mov    (%eax),%eax
    b9ab:	83 ec 0c             	sub    $0xc,%esp
    b9ae:	50                   	push   %eax
    b9af:	e8 c9 f2 ff ff       	call   ac7d <free>
    b9b4:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < 0x400; i++) {
    b9b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    b9bb:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
    b9c2:	76 97                	jbe    b95b <mm_test_func__3+0x56>
    }

    if (_head_vmm_->address == VM__NO_VM_ADDRESS)
    b9c4:	a1 20 10 02 00       	mov    0x21020,%eax
    b9c9:	8b 00                	mov    (%eax),%eax
    b9cb:	85 c0                	test   %eax,%eax
    b9cd:	75 0a                	jne    b9d9 <mm_test_func__3+0xd4>
        mm_test__3.passed = true;
    b9cf:	c7 05 60 10 01 00 00 	movl   $0x0,0x11060
    b9d6:	00 00 00 
}
    b9d9:	c9                   	leave  
    b9da:	c3                   	ret    

0000b9db <mm_test_func__4>:

TEST_UNIT_FUNC(mm_test_func__4)
{
    b9db:	55                   	push   %ebp
    b9dc:	89 e5                	mov    %esp,%ebp
    b9de:	83 ec 18             	sub    $0x18,%esp
    uint32_t i, j;

    for (i = 1; i < 10; i++) {
    b9e1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    b9e8:	eb 27                	jmp    ba11 <mm_test_func__4+0x36>
        j = compteur % (i + 1);
    b9ea:	a1 00 50 01 00       	mov    0x15000,%eax
    b9ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
    b9f2:	8d 4a 01             	lea    0x1(%edx),%ecx
    b9f5:	ba 00 00 00 00       	mov    $0x0,%edx
    b9fa:	f7 f1                	div    %ecx
    b9fc:	89 55 e8             	mov    %edx,-0x18(%ebp)

        kmalloc(j);
    b9ff:	83 ec 0c             	sub    $0xc,%esp
    ba02:	ff 75 e8             	pushl  -0x18(%ebp)
    ba05:	e8 af f0 ff ff       	call   aab9 <kmalloc>
    ba0a:	83 c4 10             	add    $0x10,%esp
    for (i = 1; i < 10; i++) {
    ba0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    ba11:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    ba15:	76 d3                	jbe    b9ea <mm_test_func__4+0xf>
    }

    _virt_mm_ *tmp, *tmp_prev;
    tmp = _head_vmm_->next;
    ba17:	a1 20 10 02 00       	mov    0x21020,%eax
    ba1c:	8b 40 08             	mov    0x8(%eax),%eax
    ba1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    tmp_prev = _head_vmm_;
    ba22:	a1 20 10 02 00       	mov    0x21020,%eax
    ba27:	89 45 ec             	mov    %eax,-0x14(%ebp)

    while (tmp->next != (_virt_mm_*)NULL) {
    ba2a:	eb 31                	jmp    ba5d <mm_test_func__4+0x82>
        if (tmp->address < tmp_prev->address + tmp_prev->size) {
    ba2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ba2f:	8b 10                	mov    (%eax),%edx
    ba31:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ba34:	8b 08                	mov    (%eax),%ecx
    ba36:	8b 45 ec             	mov    -0x14(%ebp),%eax
    ba39:	8b 40 04             	mov    0x4(%eax),%eax
    ba3c:	01 c8                	add    %ecx,%eax
    ba3e:	39 c2                	cmp    %eax,%edx
    ba40:	73 0c                	jae    ba4e <mm_test_func__4+0x73>
            mm_test__4.passed = false;
    ba42:	c7 05 80 12 01 00 01 	movl   $0x1,0x11280
    ba49:	00 00 00 
            return;
    ba4c:	eb 19                	jmp    ba67 <mm_test_func__4+0x8c>
        }
        tmp_prev = tmp;
    ba4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ba51:	89 45 ec             	mov    %eax,-0x14(%ebp)
        tmp = tmp->next;
    ba54:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ba57:	8b 40 08             	mov    0x8(%eax),%eax
    ba5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (tmp->next != (_virt_mm_*)NULL) {
    ba5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    ba60:	8b 40 08             	mov    0x8(%eax),%eax
    ba63:	85 c0                	test   %eax,%eax
    ba65:	75 c5                	jne    ba2c <mm_test_func__4+0x51>
    }
}
    ba67:	c9                   	leave  
    ba68:	c3                   	ret    
