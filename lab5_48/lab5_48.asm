TITLE lab6_48
include Irvine32.inc

.data
myID byte "109504501"
myID2 byte "110502514"
size_ID = 9
result byte 9 DUP(?)

.code
main PROC
	mov esi ,0           ;定義esi為0 (從位置0開始)
	mov ecx,size_ID      ;定義loop的次數
L1:  
	mov al,myID[esi]     ;al設為myID組長學號的第esi位置
	cmp al,myID2[esi]    ;比較myID和myID2的第esi位置
	ja L2                ;jump if above (if myID > myID2)
	jb L3                ;jump if below (if myID < myID2)
	jz L4                ;jump if zero (if myID == myID2)
L2:
	mov result[esi],42h  ;myID的數字>myID2的數字, 將result變成B(42h)
	inc esi              ;移動至下個位置
	Loop L1              ;回到L1
	jmp L5               ;若ecx=0, 停止loop L1
L3:
	mov result[esi],43h  ;myID的數字<myID2的數字, 將result變成C(43h)
	inc esi	             ;移動至下個位置
	Loop L1              ;回到L1
	jmp L5               ;若ecx=0, 停止loop L1
L4:
	mov result[esi],41h  ;myID的數字==myID2的數字, 將result變成C(43h)
	inc esi              ;移動至下個位置
	Loop L1              ;回到L1
	jmp L5               ;若ecx=0, 停止loop L1
L5:
	exit
main ENDP
END main