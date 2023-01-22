INCLUDE Irvine32.inc

BoxWidth =3
BoxHeight=1
.data
	boxTop    BYTE 0DAh, (BoxWidth - 2) DUP(0C4h),0BFh 
	boxBody   BYTE 0B3h, (BoxWidth - 2) DUP(' '), 0B3h
	boxBottom BYTE 0C0h, (BoxWidth - 2) DUP(0C4h),0D9h
	outputHandle DWORD 0
	bytesWritten DWORD 0
	count DWORD 0
	xyPosition COORD <10,5>
	cellsWritten DWORD ?
	attributes0 WORD BoxWidth DUP(0Ch)
	attributes1 WORD (BoxWidth-1) DUP(0Eh),0Ah
	attributes2 WORD BoxWidth DUP(0Bh)
.code
main PROC
 
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE ; Get the console ouput handle
    mov outputHandle, eax ; save console handle
    call Clrscr ; 畫出box的第一行
 
    INVOKE WriteConsoleOutputAttribute,
	outputHandle,	; output handle
	ADDR attributes0,	; write attributes
	BoxWidth,	; number of cells
	xyPosition,	; first cell coordinates
	ADDR cellsWritten
 
    INVOKE WriteConsoleOutputCharacter,
    outputHandle,	; console output handle
  	ADDR boxTop,	; pointer to buffer
  	BoxWidth,		; size of buffer
  	xyPosition,	; first cell coordinates
	ADDR cellsWritten ; output count
    inc xyPosition.Y   ; 座標換到下一行位置
    mov ecx, (BoxHeight)    ; number of lines in body
L1: push ecx  ; save counter 避免invoke 有使用到這個暫存器
    INVOKE WriteConsoleOutputAttribute,
    outputHandle,	; output handle
	ADDR attributes1,	; write attributes
	BoxWidth,	; number of cells
	xyPosition,	; first cell coordinates
	ADDR cellsWritten
   
 INVOKE WriteConsoleOutputCharacter,
    outputHandle,	; console output handle
  	ADDR boxBody,	; pointer to buffer
  	BoxWidth,	; size of buffer
  	xyPosition,	; first cell coordinates
	ADDR cellsWritten ; output count
 
    inc xyPosition.Y   ; next line
    pop ecx   ; restore counter
    loop L1
 
    INVOKE WriteConsoleOutputAttribute,
    outputHandle,	; output handle
	ADDR attributes2,	; write attributes
	BoxWidth,	; number of cells
	xyPosition,	; first cell coordinates
	ADDR cellsWritten
 
    ; draw bottom of the box
    INVOKE WriteConsoleOutputCharacter,
	outputHandle,	; console output handle
  	ADDR boxBottom,	; pointer to buffer
  	BoxWidth,	; size of buffer
  	xyPosition,	; first cell coordinates
	ADDR cellsWritten  ; output count

    call WaitMsg
    call Clrscr
    exit
main ENDP
END main
