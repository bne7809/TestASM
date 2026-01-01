	option casemap:none

maxLen = 255

	.data

promptStr WORD 'E', 'n', 't', 'e', 'r', ' ', 'n', 'u', 'm', 'b', 'e', 'r', ':', ' ', 0
replyStr1 WORD 'T', 'o', 'o', ' ', 'b', 'i', 'g', '!', 13, 10, 0
replyStr2 WORD 'T', 'o', 'o', ' ', 's', 'm', 'a', 'l', 'l', '!', 13, 10, 0
genStr WORD 'T', 'h', 'i', 's', ' ', 'n', 'u', 'm', 'b', 'e', 'r', ' ', 'w', 'a', 's', ' ', 'g', 'e', 'n', 'e', 'r', 'a', 't', 'e', 'd', ':', ' ', 0
retStr WORD 13, 10, 0

input WORD maxLen dup (?)

randNum DWORD ?

	.code

	INCLUDE standard.inc
	INCLUDE watoi.inc
	INCLUDE itowa.inc

	public main

main PROC
	sub rsp, 56

	storeRand randNum, 100

	printStr genStr

	lea rcx, input
	mov edx, dword ptr [randNum]
	call itowa

	printStr input
	printStr retStr

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
