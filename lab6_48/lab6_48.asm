TITLE lab6
INCLUDE Irvine32.inc
.data
result BYTE 81 DUP(?)
.code
start@0 PROC uses ecx
	mov ecx,9           ;�]�E�E���k,�ҥH�ݭnloop �`�@9��
	mov eax,1           ;�]�w�q1�}�l��
L:
	mul ebx             ;ebx������,eax�Q����
	mov result[esi],al  ;�Nresult�w�q��eax������
	mov edx,10          ;�Nedx�w�q��10
	sub edx,ecx         ;edx = edx - ecx
	mov eax,edx         ;�Neax�w�q��edx
	inc esi             ;esi�[1 
	inc eax             ;eax�[1
	Loop L
	ret
start@0 ENDP

main PROC
	mov eax,0           ;�Neax�w�q��0
	mov esi,0		    ;�Nesi�w�q��0
	mov ebx,1           ;�Nebx�w�q��1
	mov ecx,9           ;�]�E�E���k,�ҥH�ݭnloop �`�@9��
L1:
	CALL start@0        ;�I�sstart@0
	inc ebx             ;�Nebx�[1
	Loop L1
	exit
main ENDP
END main