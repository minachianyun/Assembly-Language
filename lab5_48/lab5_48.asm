TITLE lab6_48
include Irvine32.inc

.data
myID byte "109504501"
myID2 byte "110502514"
size_ID = 9
result byte 9 DUP(?)

.code
main PROC
	mov esi ,0           ;�w�qesi��0 (�q��m0�}�l)
	mov ecx,size_ID      ;�w�qloop������
L1:  
	mov al,myID[esi]     ;al�]��myID�ժ��Ǹ�����esi��m
	cmp al,myID2[esi]    ;���myID�MmyID2����esi��m
	ja L2                ;jump if above (if myID > myID2)
	jb L3                ;jump if below (if myID < myID2)
	jz L4                ;jump if zero (if myID == myID2)
L2:
	mov result[esi],42h  ;myID���Ʀr>myID2���Ʀr, �Nresult�ܦ�B(42h)
	inc esi              ;���ʦܤU�Ӧ�m
	Loop L1              ;�^��L1
	jmp L5               ;�Yecx=0, ����loop L1
L3:
	mov result[esi],43h  ;myID���Ʀr<myID2���Ʀr, �Nresult�ܦ�C(43h)
	inc esi	             ;���ʦܤU�Ӧ�m
	Loop L1              ;�^��L1
	jmp L5               ;�Yecx=0, ����loop L1
L4:
	mov result[esi],41h  ;myID���Ʀr==myID2���Ʀr, �Nresult�ܦ�C(43h)
	inc esi              ;���ʦܤU�Ӧ�m
	Loop L1              ;�^��L1
	jmp L5               ;�Yecx=0, ����loop L1
L5:
	exit
main ENDP
END main