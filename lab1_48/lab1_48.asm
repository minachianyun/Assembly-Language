include Irvine32.inc

.data

.code
main PROC
	mov al, 00000001b	;�ժ��Ǹ�����X�G�i����Q�i��
	mov ah, 14	;�խ��Ǹ�����X�Q�i����Q���i��
	mov ax, 4501h	;�ժ��Ǹ����|�X�Q�i����Q�i��
	mov dx, 0EEEAh	;��dx���eeea
	sub dx, ax	;��dx���ȴ�hax����
main ENDP
END main

