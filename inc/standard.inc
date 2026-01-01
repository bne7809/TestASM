externdef writeLine:proc
externdef readLine:proc

printStr MACRO param1
	lea rcx, param1
	call writeLine
ENDM

readStr MACRO param1, param2
	lea rcx, param1
	mov edx, param2
	call readLine
ENDM

storeRand MACRO param1, param2
	rdrand eax
	mov ecx, param2
	xor edx, edx
	div ecx
	mov dword ptr [param1], edx
ENDM
