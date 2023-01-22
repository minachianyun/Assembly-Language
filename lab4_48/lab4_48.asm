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
	mov eax,[esi]		  ;將myID定義為eax
	add eax,11h			  ;將eax加上11h (將eax數字轉為字母)
	mov [esi],eax		  ;傳回myID (the contents of the eax are copied to the memory location addressed by esi)
	inc esi				  ;將esi加上1 (myID下個位置)
	loop L1               ;L1迴圈
	ret                   ;bring the processor back to the point in the program where the procedure was called
Convert ENDP

Convert2 PROC 
	push eax			  ;save eax
L2:	
	mov eax,[esi]		  ;將myID2定義為eax
	add eax,11h			  ;將eax加上11h (eax數字轉為字母)
	mov [esi],eax		  ;將eax傳回myID2 (the contents of the eax are copied to the memory location addressed by esi)
	inc esi				  ;將esi加上1 (myID2下個位置)
	loop L2	              ;L2迴圈
	pop eax				  ;restore eax
	ret                   ;bring the processor back to the point in the program where the procedure was called
Convert2 ENDP

main PROC		
	mov eax,9999h         ;將eax定義為9999h
	mov ebx,9999h         ;將ebx定義為9999h
	mov edx,9999h         ;將edx定義為9999h
	mov esi ,OFFSET myID  ;esi = address of myID
	mov ecx,size_ID		  ;將size_ID設為迴圈次數
	call Convert		  ;執行Convert
	mov esi ,OFFSET myID2 ;esi = address of myID2
	mov ecx,size_ID2	  ;size_ID2設為迴圈次數
	call Convert2		  ;執行Convert2
	exit
main ENDP
END main