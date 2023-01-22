include Irvine32.inc
.data
	Result byte 9 DUP(?)
.code
main PROC
	mov ecx, 9                   ;將ecx定義為9 (ecx is automatically used as a counter and is decremented each time the loop repeats)
	mov esi, OFFSET Result       ;傳回變數從所在區段開始的偏移距離
	mov al, 0                    ;將al定義為0
L1:
	add al, 9                    ;將al加上9
	mov [esi], al                ;The contents of the al register are copied to the memory location addressed by esi
	inc esi                      ;將esi加上1
LOOP L1                          ;repeat L1 (9 times)
	exit
main ENDP
END main
