watoi PROC
	mov r8w, word ptr [rcx]
	mov r9d, 1
	xor eax, eax
	cmp r8w, '-'
	jne watoi_loop
	mov r9d, -1
	add rcx, 2
watoi_loop:
	mov r8w, word ptr [rcx]
	cmp r8w, '0'
	jl watoi_end
	cmp r8w, '9'
	jg watoi_end
	imul eax, 10
	sub r8w, '0'
	movsx r8d, r8w
	imul r8d, r9d
	add eax, r8d
	add rcx, 2
	jmp watoi_loop
watoi_end:
	ret
watoi ENDP
