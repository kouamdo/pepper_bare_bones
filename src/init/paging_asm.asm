global _EnablingPaging_ , _FlushPagingCache_
extern page_directory  , Paging_fault


section .text

_FlushPagingCache_:
    mov eax , page_directory
    mov cr3 , eax
    ret

_EnablingPaging_:
    call _FlushPagingCache_
    mov eax , cr0
    ;SI le CD flag de CR0 est à 0 , le cache est activer pour certaines parties de la mémoire système
    ;mais doit être restreint pour les pages individuelles ou région de la mémoire venant d'autre mecanisme de control de cache

    ;Si le CD flage CR0 est a 1 , le cache est restreint dans le cache du processeur(cache herarchy). 
    ;Le cache doit être explicitement purgé pour assurer la cohérence dans la mémoire.
    or eax , 0x80000001
    mov cr0 , eax
    ret

PagingFault_Handler:
    pop eax
    mov dword[error_code] , eax
    call Paging_fault
    iret

    section .data
        error_code dd 0
