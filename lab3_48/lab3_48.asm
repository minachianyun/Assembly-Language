include Irvine32.inc
.data
	Result byte 9 DUP(?)
.code
main PROC
	mov ecx, 9                   ;�Necx�w�q��9 (ecx is automatically used as a counter and is decremented each time the loop repeats)
	mov esi, OFFSET Result       ;�Ǧ^�ܼƱq�Ҧb�Ϭq�}�l�������Z��
	mov al, 0                    ;�Nal�w�q��0
L1:
	add al, 9                    ;�Nal�[�W9
	mov [esi], al                ;The contents of the al register are copied to the memory location addressed by esi
	inc esi                      ;�Nesi�[�W1
LOOP L1                          ;repeat L1 (9 times)
	exit
main ENDP
END main
