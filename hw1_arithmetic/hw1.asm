TITLE HW1:ARITHMETIC
INCLUDE Irvine32.inc

.data
MyID DWORD ?
Digit0 BYTE 4
Digit1 BYTE 5
Digit2 BYTE 0
Digit3 BYTE 1

.code
main PROC
	mov al, Digit0  ;將al定義為Digit0
	mov bl, Digit1  ;將bl定義為Digit1
	mov cl, Digit2  ;將cl定義為Digit2
	mov dl, Digit3  ;將bl定義為Digit3
	movzx eax, al   ;將eax定義為al
	movzx ebx, bl   ;將ebx定義為bl
	movzx ecx, cl   ;將ecx定義為cl
	movzx edx, dl   ;將edx定義為dl
	shl eax, 24     ;將eax向左移6位(因為2^24 = 16^6)
	shl ebx, 16     ;將ebx向左移4位(因為2^16 = 16^4)
	shl ecx, 8      ;將ecx向左移2位(因為2^8 = 16^2)
	add eax, ebx    ;將eax加上ebx
	add eax, ecx    ;將eax加上ecx
	add eax, edx    ;將eax加上edx
	mov MyID, eax   ;將MyID定義為eax
	exit
main ENDP
END main
