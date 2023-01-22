TITLE lab6
INCLUDE Irvine32.inc
.data
result BYTE 81 DUP(?)
.code
start@0 PROC uses ecx
	mov ecx,9           ;因九九乘法,所以需要loop 總共9次
	mov eax,1           ;設定從1開始乘
L:
	mul ebx             ;ebx為乘數,eax被乘數
	mov result[esi],al  ;將result定義為eax的後兩位
	mov edx,10          ;將edx定義為10
	sub edx,ecx         ;edx = edx - ecx
	mov eax,edx         ;將eax定義為edx
	inc esi             ;esi加1 
	inc eax             ;eax加1
	Loop L
	ret
start@0 ENDP

main PROC
	mov eax,0           ;將eax定義為0
	mov esi,0		    ;將esi定義為0
	mov ebx,1           ;將ebx定義為1
	mov ecx,9           ;因九九乘法,所以需要loop 總共9次
L1:
	CALL start@0        ;呼叫start@0
	inc ebx             ;將ebx加1
	Loop L1
	exit
main ENDP
END main