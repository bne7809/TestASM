strcmp PROC
strcmp_begin:
	mov r8w, word ptr [rcx]
	mov r9w, word ptr [rdx]
	cmp r8w, r9w
	jne strcmp_end
	test r8w, r8w
	jz strcmp_end
	add rcx, 2
	add rdx, 2
	jmp strcmp_begin
strcmp_end:
	mov ax, r8w
	sub ax, r9w
	ret
strcmp ENDP
