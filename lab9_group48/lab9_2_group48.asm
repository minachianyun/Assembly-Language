INCLUDE Irvine32.inc

Str_remove PROTO,
	pStart:PTR byte,
	nChars:DWORD
.data
target1 BYTE "109504501",0 
target2 BYTE "110502514",0 
target3 BYTE "999999999",0

.code

main PROC  
 	INVOKE Str_remove, OFFSET target1, 5          ; remove five characters from the first string
	mov edx,OFFSET target1                        ; point to target1
	call WriteString                              ; display it
	call Crlf                                     ; output a CR/LF

	INVOKE Str_remove, OFFSET target2, 2          ; remove two characters from the second string
	mov edx,OFFSET target2
	call WriteString                              ; display it
	call Crlf                                     ; output a CR/LF

	INVOKE Str_remove, OFFSET [target2+1], 15     ; remove the characters that is out of range
	mov edx,OFFSET target2                        ; point to target2
	call WriteString                              ; display it
	call Crlf                                     ; output a CR/LF
	call WaitMsg                                  ; "Press any key......."
 	exit
main ENDP
Str_remove PROC,
	pStart:PTR BYTE,	                          ; points to first character to delete
	nChars:DWORD	                              ; numbers of characters to delete

	INVOKE Str_length, pStart  
	mov	ecx,eax		                              ; store the langth of string in ecx as the total number of loop
	.IF nChars <= ecx	                          ; check if remove characters is greater than the length of string
	  sub ecx,nChars	                          ; if no, then subtract the number of remove characters
	.ENDIF

	mov	esi,pStart		                          ; define the start of copy string
	add	esi,nChars			                      ; move the start point to the right place to copy
	mov	edi,pStart		                          ; set the destination 
	cld					                          ; scan in forward direction
	rep	movsb			                          ; copy doublewords
    mov	BYTE PTR [edi],0	                      ; set null bytes

Exit_proc:
	ret
Str_remove ENDP
END main