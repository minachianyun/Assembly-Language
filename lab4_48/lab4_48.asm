TITLE Lab4
INCLUDE Irvine32.inc

.data
	myID BYTE 31h, 30h, 39h, 35h, 30h, 34h, 35h, 30h, 31h
	myID2 BYTE 31h, 31h, 30h, 35h, 30h, 32h, 35h, 31h, 34h
	size_ID DWORD 9
	size_ID2 DWORD 9

.code
Convert PROC USES eax
L1:
	mov eax,[esi]		  ;�NmyID�w�q��eax
	add eax,11h			  ;�Neax�[�W11h (�Neax�Ʀr�ର�r��)
	mov [esi],eax		  ;�Ǧ^myID (the contents of the eax are copied to the memory location addressed by esi)
	inc esi				  ;�Nesi�[�W1 (myID�U�Ӧ�m)
	loop L1               ;L1�j��
	ret                   ;bring the processor back to the point in the program where the procedure was called
Convert ENDP

Convert2 PROC 
	push eax			  ;save eax
L2:	
	mov eax,[esi]		  ;�NmyID2�w�q��eax
	add eax,11h			  ;�Neax�[�W11h (eax�Ʀr�ର�r��)
	mov [esi],eax		  ;�Neax�Ǧ^myID2 (the contents of the eax are copied to the memory location addressed by esi)
	inc esi				  ;�Nesi�[�W1 (myID2�U�Ӧ�m)
	loop L2	              ;L2�j��
	pop eax				  ;restore eax
	ret                   ;bring the processor back to the point in the program where the procedure was called
Convert2 ENDP

main PROC		
	mov eax,9999h         ;�Neax�w�q��9999h
	mov ebx,9999h         ;�Nebx�w�q��9999h
	mov edx,9999h         ;�Nedx�w�q��9999h
	mov esi ,OFFSET myID  ;esi = address of myID
	mov ecx,size_ID		  ;�Nsize_ID�]���j�馸��
	call Convert		  ;����Convert
	mov esi ,OFFSET myID2 ;esi = address of myID2
	mov ecx,size_ID2	  ;size_ID2�]���j�馸��
	call Convert2		  ;����Convert2
	exit
main ENDP
END main