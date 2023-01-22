INCLUDE Irvine32.inc

Str_copyN PROTO,
    source:PTR BYTE,     ; source string address
    target:PTR BYTE,     ; target string address
    maxChars:DWORD       ; maximum number of character to copy

.data
string_1 BYTE "109504501",0    
string_2 BYTE "110502514",0

.code
main PROC  
	INVOKE Str_copyN, OFFSET string_1, OFFSET string_2 + 9, (SIZEOF string_2) - 1       
	mov edx, OFFSET string_2
	call WriteString          ; display it
	call Crlf                 ; output a CR/LF
	call WaitMsg              ; "Press any key........"
 	exit
main ENDP

Str_copyN PROC USES eax ecx esi edi,
    source:PTR BYTE,          ; source string address
    target:PTR BYTE,          ; target string address
    maxChars:DWORD            ; maximum number of character to copy
    mov ecx, maxChars         ; set counter
    mov esi, source           ; set the address of source to esi
    mov edi, target           ; set the address of target to edi
    cld                       ; direction = forward
    rep movsb                 ; copy the string
    mov byte ptr [edi], 0     ; insert a null byte
    ret
Str_copyN ENDP

END main