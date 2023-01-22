INCLUDE Irvine32.inc

FindLargest PROTO,
	ptrarr:PTR SDWORD,
	szarr:DWORD
.data
Ex1Array sdword 105522063,109504501, 110502514
Ex2Array sdword -105522063, -109504501, -110502514
.code

main PROC  
 	invoke FindLargest,OFFSET EX1Array,LENGTHOF EX1Array      ; displays FindLargest, points to the EX1Array, the length of EX1Array
	invoke FindLargest,OFFSET EX2Array,LENGTHOF EX2Array      ; displays FindLargest, points to the EX2Array, the length of EX2Array
	call WaitMsg                                              ; "Press any key........."
	invoke ExitProcess,0                                      ; end the program
 	exit                                                      ; exit
main ENDP
FindLargest PROC,
	ptrarr:PTR SDWORD,                                        ; pointer to array
	szarr:DWORD                                               ; size of the array

	push esi                                                  ; save esi
	push ecx                                                  ; save ecx
	mov eax,80000000h                                         ; store 80000000h into eax
	mov esi,ptrarr                                            ; store pointer to array into esi
	mov ecx,szarr                                             ; store size of array into ecx
L1: 
	cmp [esi],eax                                             ; compare each integer with eax
	jl L2                                                     ; jump to L2 if [esi] is less than eax
	mov eax,[esi]                                             ; if [esi] is greater or equal than eax, then store [esi] into eax
L2: 
	add esi,4                                                 ; point to the next integer(DWORD is four bytes)
	LOOP L1                                                   ; loop L1
	call WriteInt                                             ; displays: eax
	call Crlf                                                 ; go to the next line
	pop ecx                                                   ; restore ecx
	pop esi                                                   ; restore esi
	ret                                                       ; return
FindLargest ENDP
END main