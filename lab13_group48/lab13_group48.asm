INCLUDE Irvine32.inc
.data
consoleHandle    DWORD ?
xyInit COORD <2,15> ; �_�l�y��
xyBound COORD <80,25> ; �@�ӭ����̤j�����
xyPos COORD <2,15> ; �{�b����Ц�m
main EQU start@0
.code
main PROC

; Get the Console standard output handle:
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov consoleHandle,eax
	
; �]�w�^��_�l��m
INITIAL:
	mov ax,xyInit.x
	mov xyPos.x,ax
	mov ax,xyInit.y
	mov xyPos.y,ax
START:
	call ClrScr
	INVOKE SetConsoleCursorPosition, consoleHandle, xyPos
	call ReadChar
	.IF ax == 1177h ;UP
		sub xyPos.y,1
	.ENDIF
	.IF ax == 1F73h ;DOWN
		add xyPos.y,1
	.ENDIF
	.IF ax == 1E61h ;LEFT
		sub xyPos.x,1
	.ENDIF
	.IF ax == 2064h ;RIGHT
		add xyPos.x,1
	.ENDIF
	.IF ax == 011Bh ;ESC
		jmp END_FUNC
	.ENDIF
	
	; �ˬd�@���W�U���k�ᦳ�S���W�L�������
	.IF xyPos.x == 0h ;x lowerbound
		add xyPos.x,1 ; �W�L��ɰ��d�b���
	.ENDIF
	mov ax,xyBound.x ; ���G�����������w�}�A�G�N�䤤�@���ন register
	.IF xyPos.x == ax ;x upperbound
		sub xyPos.x,1 ; �W�L��ɰ��d�b���
	.ENDIF
	
	.IF xyPos.y == 0h ;y lowerbound
		add xyPos.y,1 ; �W�L��ɰ��d�b���
	.ENDIF
	mov ax,xyBound.y
	.IF xyPos.y == ax ;y upperbound
		sub xyPos.y,1 ; �W�L��ɰ��d�b���
	.ENDIF
	
	jmp START
END_FUNC:
	exit
main ENDP

END main