	option casemap:none

	.data

fmtStr WORD 'H', 'e', 'l', 'l', 'o', ',', ' ', 'w', 'o', 'r', 'l', 'd', '!', 13, 10, 0

	.code

	INCLUDE standard.inc

	public main

main PROC
	sub rsp, 56

	printStr fmtStr

	add rsp, 56
	ret

main ENDP

	END
