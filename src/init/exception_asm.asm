global __exception_handler__ , __error_code__
global __exception_no_ERRCODE_handler__ 

extern __exception__ , __exception_no_ERRCODE__

section .text
    
    __exception_handler__:
        pop eax 
        mov dword[__error_code__] , eax
        call __exception__
        iret

    __exception_no_ERRCODE_handler__:
        call __exception_no_ERRCODE__
        iret

section .data 

    __error_code__ dd 0