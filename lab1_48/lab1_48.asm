include Irvine32.inc

.data

.code
main PROC
	mov al, 00000001b	;組長學號末兩碼二進位轉十進位
	mov ah, 14	;組員學號末兩碼十進位轉十六進位
	mov ax, 4501h	;組長學號末四碼十進位轉十進位
	mov dx, 0EEEAh	;讓dx顯示eeea
	sub dx, ax	;把dx的值減去ax的值
main ENDP
END main

