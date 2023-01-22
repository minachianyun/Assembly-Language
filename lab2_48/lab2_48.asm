include Irvine32.inc

.data
Value1 SBYTE 03h
Value2 SBYTE 02h
Value3 SBYTE 8fh
Result SDWORD ?

.code
main PROC
	mov al, Value1  ;將al定義為Value1
	add al, Value2  ;將al加上Value2 (al = Value1 + Value2)
	shl al, 1       ;將al乘以2
	mov Value1, al  ;將Value1定義為al
	shl al, 3       ;將al乘以2的三次方
	sub al, Value1  ;將al減去Value1
	mov ah, Value3  ;將ah定義為Value3
	sub ah, al      ;將ah減去al (ah = ah - al)
	neg ah          ;將ah加上負號
	movzx eax, ah   ;為了讓operands in the same size, 所以使用movzx將eax定義為ah
	mov Result, eax ;最後將答案eax存到Result

	
main ENDP
END main