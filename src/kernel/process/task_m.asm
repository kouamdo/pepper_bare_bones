global switch_to_task

section .text

	switch_to_task:
		;save entire task state , so last regs should be field------
		push eax
			mov eax , dword[esp+8]
			mov dword[eax+4] , ebx
			mov dword[eax+8] , ecx
			mov dword[eax+12], edx
			mov dword[eax+16] , esi
			mov dword[eax+20] , edi
			mov dword[eax+24] , esp
			mov dword[eax+28] , ebp
			
			;save eip
			push ecx
				mov ecx , dword[esp+8]
				mov dword[eax+32] , ecx
			pop ecx

			;save eflags
			push ecx
				pushfd
				pop ecx
				mov dword[eax+36] , ecx
			pop ecx

			;save cr3
			push ecx
				mov ecx , cr3
				mov dword[eax+40] , ecx
			pop ecx


			mov word[eax+44] , es
			mov word[eax+46] , gs
			mov word[eax+48] , fs
			
			;save eax
			push ecx
				mov ecx , dword[esp+4]
				mov dword[eax] , ecx
			pop ecx
			


		pop eax
		
		
		;---------------------------------------------------------

		; load task state ----------------------------------------
		
			mov eax , dword[esp+8]
			mov ebx , dword[eax+4]
			mov ecx , dword[eax+8]
			mov edx , dword[eax+12]
			mov esi , dword[eax+16]
			mov edi , dword[eax+20]
			mov esp , dword[eax+24]
			mov ebp , dword[eax+28]

			;load eflags
			push ecx
				mov ecx , dword[eax+36]
				push ecx
				popfd
			pop ecx

			;load cr3
			push ecx
				mov ecx , dword[eax+40]
				mov cr3 , ecx
			pop ecx

			mov es , word[eax+44]
			mov gs , word[eax+46]
			mov fs , word[eax+48]

		mov eax , dword[eax+32]
		mov [esp] , eax
		
		;--------------------------------------------------------
		ret
