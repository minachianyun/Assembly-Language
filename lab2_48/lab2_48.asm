include Irvine32.inc

.data
Value1 SBYTE 03h
Value2 SBYTE 02h
Value3 SBYTE 8fh
Result SDWORD ?

.code
main PROC
	mov al, Value1  ;�Nal�w�q��Value1
	add al, Value2  ;�Nal�[�WValue2 (al = Value1 + Value2)
	shl al, 1       ;�Nal���H2
	mov Value1, al  ;�NValue1�w�q��al
	shl al, 3       ;�Nal���H2���T����
	sub al, Value1  ;�Nal��hValue1
	mov ah, Value3  ;�Nah�w�q��Value3
	sub ah, al      ;�Nah��hal (ah = ah - al)
	neg ah          ;�Nah�[�W�t��
	movzx eax, ah   ;���F��operands in the same size, �ҥH�ϥ�movzx�Neax�w�q��ah
	mov Result, eax ;�̫�N����eax�s��Result

	
main ENDP
END main