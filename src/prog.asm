	option casemap:none

maxLen = 255

	.data

fmtStr WORD 'H', 'e', 'l', 'l', 'o', ',', ' ', 'w', 'o', 'r', 'l', 'd', '!', 13, 10, 0
promptStr WORD 'E', 'n', 't', 'e', 'r', ' ', 'n', 'u', 'm', 'b', 'e', 'e', 'r', ':', ' ', 0
replyStr1 WORD 'T', 'o', 'o', ' ', 'b', 'i', 'g', '!', 13, 10, 0
replyStr2 WORD 'T', 'o', 'o', ' ', 's', 'm', 'a', 'l', 'l', '!', 13, 10, 0

input WORD maxLen dup (?)

randNum DWORD ?

	.code

	externdef writeLine:proc
	externdef readLine:proc

	public main

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

printStr MACRO param1
	lea rcx, param1
	call writeLine
ENDM

readStr MACRO param1, param2
	lea rcx, param1
	mov edx, param2
	call readLine
ENDM

storeRand MACRO param1
	rdrand eax
	mov ecx, 100
	xor edx, edx
	div ecx
	mov dword ptr [param1], edx
ENDM

main PROC
	sub rsp, 56

	printStr fmtStr

	storeRand randNum

input_loop:
	printStr promptStr

	readStr input, maxLen

	lea rcx, input
	call watoi

	cmp eax, dword ptr [randNum]
	je main_end
	jl num_smaller

	printStr replyStr1
	jmp input_loop

num_smaller:
	printStr replyStr2
	jmp input_loop

main_end:
	add rsp, 56
	ret
main ENDP

	END
