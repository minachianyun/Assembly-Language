INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword	
DifferentInputs proto, v1:dword, v2:dword, v3:dword	

.data

.code

main PROC  
 	invoke DifferentInputs,2,2,3	
    invoke DifferentInputs,2,3,2
   	invoke DifferentInputs,3,5,5
   	invoke DifferentInputs,2,2,2
   	invoke DifferentInputs,104522064,110502514,109504501

	call WaitMsg
	invoke ExitProcess,0
 	exit
main ENDP
DifferentInputs proc,
	v1:dword, v2:dword, v3:dword
	mov eax,v1   		;set eax as v1
	cmp v2,eax			;compare eax with v2
	je  Label_Equal		;if equal, jump to Label_Equal
	cmp v3,eax			;compare eax with v3
	je   Label_Equal	;if equal, jump to Label_Equal
	mov eax,v2			;set eax as v2
	cmp v3,eax          ;compare eax with v3
	je   Label_Equal	;if equal, jump to Label_Equal
	mov eax,1			;set eax as 1
	jmp exit_label		;jump to exit_label
Label_Equal: 
    mov  eax,0      ; return false
	
exit_label:
    call DumpRegs
    ret
DifferentInputs endp

END main