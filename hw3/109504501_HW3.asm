INCLUDE Irvine32.inc

CountMatches PROTO,
	ptr1: PTR SDWORD,
	ptr2: PTR SDWORD,
	arrSize: DWORD
.data
	array1 sdword 10,5,4,-6,2,11,12
	array2 sdword 10,5,3,1,4,2,-6
.code
main PROC  
	INVOKE CountMatches,OFFSET array1,OFFSET array2,LENGTHOF array2  ; displays CountMatches, points to array1, points to array2, the length of array2
 	exit                                                             ; exit
main ENDP
CountMatches PROC,
	ptr1: PTR SDWORD,
	ptr2: PTR SDWORD,
	arrSize: DWORD           
	push esi                  ; save esi
	push edi                  ; save edi
	mov eax,0                 ; store 0 in eax
	mov edi,ptr1              ; get pointer ptr1
	mov esi,ptr2              ; get pointer ptr2
	mov ecx,arrSize           ; set the size of array as the total number of the loop
	
L1:
	push ecx                  ; save loop counter
	mov ecx,arrSize           ; set the size of array as the total number of the loop
L2:
	mov ebx,[esi]             ; store the value of [esi] in ebx
	cmp [edi],ebx             ; compare each integer with ebx
	jne L                     ; jump to L if [edi] is not equal to ebx
	inc eax                   ; eax = eax + 1
L:
	add esi,4                 ; point to the next integer (DWORD is four bytes)
	add edi,4                 ; point to the next integer (DWORD is four bytes)
	pop ecx                   ; restore ecx
	LOOP L1                   ; loop L1
	ret                       ; return
CountMatches ENDP
END main
