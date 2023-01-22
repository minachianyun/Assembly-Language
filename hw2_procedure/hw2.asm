TITLE Example of ASM              
INCLUDE Irvine32.inc

.data
 ChStr BYTE  "#####   "
       BYTE  "    #   "
       BYTE  "    #   "
       BYTE  "    #   "
       BYTE  "    #   "
       BYTE  "    #   "
       BYTE  "    #   "
       BYTE  "########"
 BitStr BYTE 8 DUP(?)
.code
change PROC
 	mov bl,10000000b
 	mov dl,0 
 	mov edi,0
L:
 	mov al,ChStr[esi]          ; 將al定義為ChStr[esi]
 	cmp al,20h                 ; compare al and 20h
 	jz L1                      ; if(al>20h): al=al+07h and continue  ; if(al==20h): jump directly to L1
 	add al,7h                  ; add 7h to al
 	add dl,bl                  ; add bl to dl
 	shr bl,1                   ; bl shift one position right
 	jmp L2                     ; jump to L2
L1: 
 	add al,10h                 ; add 10h to al
 	shr bl,1                   ; bl shift one position right
L2:                            ; L2: convert blank to 0 and # to 1 for each byte in ChStr
    mov ChStr[esi], al         ; 將ChStr[esi]定義為al
 	inc esi                    ; add one to esi (move to next position at ChStr)
 	cmp bl,0                   ; compare bl and 0
 	jnz L4                     ; if(bl==0): continue  ; if(bl!=0): jump directy to L4
 	mov BitStr[edi],dl         ; 將BitStr[esi]定義為al
 	mov bl,10000000b           ; 將bl定義為10000000b
 	mov dl,0                   ; 將dl定義為0
 	inc edi                    ; add one to edi
L4:
 	Loop L
 	ret
change ENDP

main PROC  
 	mov esi,0
 	mov ecx,64
 	CALL change
 	mov ecx,8
 	mov esi,0
L3:                            ; L3: print out the result(BitStr)
 	movzx eax,BitStr[esi]
 	mov ebx,type byte
 	call writebinb
 	call crlf
 	inc esi
 	Loop L3
 	exit
main ENDP
END main