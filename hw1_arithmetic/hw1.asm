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
	mov al, Digit0  ;�Nal�w�q��Digit0
	mov bl, Digit1  ;�Nbl�w�q��Digit1
	mov cl, Digit2  ;�Ncl�w�q��Digit2
	mov dl, Digit3  ;�Nbl�w�q��Digit3
	movzx eax, al   ;�Neax�w�q��al
	movzx ebx, bl   ;�Nebx�w�q��bl
	movzx ecx, cl   ;�Necx�w�q��cl
	movzx edx, dl   ;�Nedx�w�q��dl
	shl eax, 24     ;�Neax�V����6��(�]��2^24 = 16^6)
	shl ebx, 16     ;�Nebx�V����4��(�]��2^16 = 16^4)
	shl ecx, 8      ;�Necx�V����2��(�]��2^8 = 16^2)
	add eax, ebx    ;�Neax�[�Webx
	add eax, ecx    ;�Neax�[�Wecx
	add eax, edx    ;�Neax�[�Wedx
	mov MyID, eax   ;�NMyID�w�q��eax
	exit
main ENDP
END main
