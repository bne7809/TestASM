itowa PROC
	xor r8, r8
	mov eax, edx
	mov r9d, eax
itowa_int_len_loop_begin:
	mov r10d, r9d
	movsxd r9, r9d
	imul r9, 1717986919
	shr r9, 32
	sar r9d, 2
	sar r10d, 31
	sub r9d, r10d

	inc r8
	test r9d, r9d
	jnz itowa_int_len_loop_begin
itowa_int_len_loop_end:
	cmp eax, 0
	jns itowa_loop_begin
	neg eax
	mov word ptr [rcx], '-'
	add rcx, 2
itowa_loop_begin:
	shl r8, 1
	add rcx, r8
	shr r8, 1
	mov word ptr [rcx], 0
	sub rcx, 2
	mov r9, rcx
	mov ecx, 10
itowa_loop:
	cdq
	idiv ecx

	add edx, '0'
	mov word ptr [r9], dx
	sub r9, 2
	sub edx, '0'

	dec r8
	test r8, r8
	jnz itowa_loop

	ret
itowa ENDP
