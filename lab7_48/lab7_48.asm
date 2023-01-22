include Irvine32.inc

divide MACRO dd,dr,q,r                         ; a macro named divide with parameter named dd, dr, q, r
	mov edx,0                                  ; define edx = 0
	mov ecx,100                                ; define ecx = 100
	div cx                                     ; divide 
	mov q,ax                                   ; move ax to q
	mov r,dx                                   ; move dx to r
ENDM
.data
dividend WORD 4501
divisor WORD 100
quotient WORD 1 DUP(?)
remainder WORD 1 DUP(?)
.code
main PROC
	movsx eax,dividend		
	call WriteDec                               ; display it
	call Crlf                                   ; output a CR/LF
	divide dividend,divisor,quotient,remainder  ; macro divide
	movsx eax,quotient                          ; move quotient with sighn-extend into eax
	call WriteDec                               ; display it
	call Crlf                                   ; output a CR/LF
	movsx eax,remainder                         ; move remainder with sign-extend into eax
	call WriteDec                               ; display it
	call Crlf                                   ; output a CR/LF
	exit
main ENDP
END main