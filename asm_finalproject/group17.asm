;跳棋程式
INCLUDE Irvine32.inc

;繪出棋盤
print PROTO 

;棋盤座標與小黑窗座標轉換
Transfer PROTO,
	X1:sbyte,
	Y1:sbyte
	
;判斷輸入的座標是否在棋盤內
Boundary PROTO,
	x:sbyte,y:sbyte
	
;判斷有無玩家勝利
Iswin PROTO

;判斷輸入的位置是否有棋子
IsChess PROTO,
	boolx:sbyte,booly:sbyte

;選擇棋子
Choose PROTO

;移動游標
movecursor PROTO

;移動棋子
movechess PROTO

;棋子座標結構(帶正負的座標)
COOR STRUCT 
	X sbyte 0
	Y sbyte 0
COOR ENDS

.data
;15隻藍棋位置
B COOR <-4, 8>, <-4, 7>, <-3, 7>, <-4, 6>, <-3, 6>, <-2, 6>, <-4, 5>, <-3, 5>, <-2, 5>, <-1, 5>, <-4, 4>, <-3, 4>, <-2, 4>, <-1, 4>, < 0, 4> 
;15隻紅紫棋位置
M COOR <-4, 0>, <-4,-1>, <-3,-1>, <-4,-2>, <-3,-2>, <-2,-2>, <-4,-3>, <-3,-3>, <-2,-3>, <-1,-3>, <-4,-4>, <-3,-4>, <-2,-4>, <-1,-4>, < 0,-4>
;15隻咖啡棋位置
Br COOR < 4, 0>, < 4,-1>, < 5,-1>, < 4,-2>, < 5,-2>, < 6,-2>, < 4,-3>, < 5,-3>, < 6,-3>, < 7,-3>, < 4,-4>, < 5,-4>, < 6,-4>, < 7,-4>, < 8,-4>

;快贏的15隻藍棋位置
;B COOR <4, -8>, <4, -7>, <3, -7>, <4, -6>, <3, -6>, <2, -6>, <4, -5>, <2, -3>, <2, -5>, <1, -5>, <4, -4>, <3, -4>, <2, -4>, <1, -4>, < 0, -4> 
;快贏的15隻紅紫棋位置
;M COOR <4, 0>, <4,1>, <4,2>, <4,3>, <4,4>, <3,0>, <3,2>, <3,3>, <3,4>, <2,2>, <2,3>, <2,4>, <1,3>, <1,4>, < 0,4>
;快贏的15隻咖啡棋位置
;Br COOR <-4, 0>, <-4,1>, <-4,2>, <-4,3>, <-4,4>, <-3,1>, <-5,2>, <-5,3>, <-5,4>, <-6,2>, <-6,3>, <-6,4>, <-7,3>, <-7,4>, <-8,4>

;棋盤樣式
dot byte "o"

;游標位置
cursor COOR < 0, 0>

;控制權
control byte 1

;遊戲狀態
chos   byte "choose",0
unchos byte "unlock",0
En     byte "end",0
bluewin		byte "The winner is blue!!!",0
magentawin	byte "The winner is magenta!!!",0
brownwin	byte "The winner is yellow!!!",0
jumporstop  byte "Choose another position to arrive, or press Enter again to stop the chess here. ",0
havechess	byte "This position has a chess. ",0
cantjump    byte "You can't jump to the position",0
chooseyourschess byte "You Can't choose other's chess or choose Nothing. Please choose your own chess! ",0

introduction byte "Sternhalma(Chinese checkers)",0
introduction2 byte "is a strategy board game of German origin that can be played by two, three, four, or six people,",0
introduction3 byte "playing individually or with partners. The game is a modern and simplified variation of the game Halma.",0
way_to_play byte "use 'up' 'down' 'left',and 'right' to control, 'enter' to select. ",0

.code
main PROC
		
		INVOKE print							;印出初始棋盤

	gameconti:
		
		INVOKE Iswin							;判斷有無玩家勝利
		cmp  ax,1								
		jz somebodywin							;有玩家勝利
		INVOKE Choose 							;選擇棋子
		mov  edx, OFFSET chos					
		call WriteString						;輸出"choose"狀態
		INVOKE movechess						;移動棋子
		cmp  ax, 0
		jz   unchoose							;重新選擇棋子
		INVOKE print							;繪出棋盤
		mov  edx, OFFSET En						
		call WriteString						;輸出"end"狀態
		
		add control, 1							;control = (control + 1) % 3 + 1
		cmp control, 3
		jng gameconti
		add control, -3
		mov al,control
		jmp gameconti							;遊戲繼續

	unchoose:									;重新選擇棋子
		INVOKE print							;繪出棋盤
		mov  edx, OFFSET unchos					
		call WriteString						;輸出"unlock"狀態
		jmp  gameconti
				
	somebodywin:								;有玩家勝利
		cmp  bx,1
		jz   wblue
		cmp  bx,2
		jz   wmagenta
		cmp  bx,3
		jz   wbrown
		
	wblue:										;藍棋勝利
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET bluewin					;印出"The winner is blue!!!"狀態
		call WriteString
		jmp  endgame
		
	wmagenta:										;紅紫棋勝利
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET magentawin				;印出"The winner is magenta!!!"狀態
		call WriteString
		jmp  endgame

	wbrown:									;咖啡棋勝利
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET brownwin				;印出"The winner is brown!!!"狀態
		call WriteString
		jmp  endgame
		
	endgame:									;遊戲結束
		call readchar
		exit
		
main ENDP
;----------------------------------------------print----------------------------------------------
print PROC
		
		call clrscr								;清空螢幕
		
		push eax								;將會用到的暫存器內容放入堆疊
		push ebx
		push ecx
		push esi
		
	;---繪製大棋盤白點---
	;雙層迴圈 -8 <= i,j <= 8
	;透過 Boundary 以及透過 Transfer 轉換，繪出棋盤上的點出棋盤上的點
		mov  ecx, 17
	printintro:
		
		mov  al , 15
		call SetTextColor
		mov  dh , 1
		mov  dl , 0
		call Gotoxy
		mov  edx, OFFSET introduction
		call WriteString
		mov  dh , 2
		mov  dl , 0
		call Gotoxy
		mov  edx, OFFSET introduction2
		call WriteString
		mov  dh , 3
		mov  dl , 0
		call Gotoxy
		mov  edx, OFFSET introduction3
		call WriteString
		mov  al , 3
		call SetTextColor
		mov  dh , 27
		mov  dl , 0
		call Gotoxy
		mov edx, OFFSET way_to_play
		call WriteString
	outter:
		mov   bh , cl
		sub   bh , 9
		
		push  ecx
			
		mov   ecx, 17
	inner:
		mov   bl , cl
		sub   bl , 9
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   outofbound							;點出界 --> 不印出
		
		INVOKE Transfer, bh, bl
		call Gotoxy								;游標位置已經由 Transfer 算好，並放入適當的暫存器 (dl,dh)
		mov  eax, white + ( black*16 )			;設定前景為白色，背景為黑色
		call SetTextColor
		
		mov  al , dot
		call Writechar							;印出點點

	outofbound:
		
		loop inner
		
		pop ecx
		
		loop outter
		
	;---大棋盤紅點---
	;按照矩陣的內容，透過 Transfer 轉換後繪出
		mov  ecx, 15
		mov  esi, OFFSET B
	
	printblue:
		mov  bh , (COOR PTR [esi]).X
		mov  bl , (COOR PTR [esi]).Y
		INVOKE Transfer, bh, bl
		call Gotoxy
		mov  eax, 1 + ( black*16 )			;設定前景為藍色，背景為黑色
		call SetTextColor
		
		mov  al , 3h
		call Writechar 						;印出愛心
		
		add  esi, TYPE COOR
		loop printblue
	
	;---大棋盤紅紫點---
	;按照矩陣的內容，透過 Transfer 轉換後繪出
		mov  ecx, 15
		mov  esi, OFFSET M
		
	
	printmagenta:
		mov  bh , (COOR PTR [esi]).X
		mov  bl , (COOR PTR [esi]).Y
		INVOKE Transfer, bh, bl
		call Gotoxy
		mov  eax, 5 + ( black*16 )			;設定前景為紅紫色，背景為黑色
		call SetTextColor
		
		mov  al , 6h
		call Writechar						;印出黑桃
		
		add  esi, TYPE COOR
		loop printmagenta	
		
	;---大棋盤咖啡點---
	;按照矩陣的內容，透過 Transfer 轉換後繪出
		mov  ecx, 15
		mov  esi, OFFSET Br
		
	printbrown:
		mov  bh , (COOR PTR [esi]).X
		mov  bl , (COOR PTR [esi]).Y
		INVOKE Transfer, bh, bl
		call Gotoxy
		mov  eax, 6 + ( black*16 )		;設定前景為咖啡色，背景為黑色
		call SetTextColor
		
		mov  al , 4h
		call Writechar						;印出菱形
		add  esi, TYPE COOR
		loop printbrown
		
	;---大棋盤游標---
		mov  bh , cursor.X
		mov  bl , cursor.Y
		INVOKE Transfer, bh, bl
		
		;繪製"[" ，淡青綠色
		sub  dl ,1
		call Gotoxy
		mov  eax, 11 + ( black*16 )
		call SetTextColor
		mov  al , "["
		call Writechar
		
		;繪製"[" ，淡青綠色
		add  dl ,2
		call Gotoxy
		mov  eax, 11 + ( black*16 )
		call SetTextColor
		mov  al , "]"
		call Writechar
		
	;從堆疊取回暫存器內容
		pop  esi
		pop  ecx
		pop  ebx
		pop  eax

		ret
		
print ENDP

;----------------------------------------------Transfer----------------------------------------------
Transfer PROC,
	X1:sbyte, Y1:sbyte
	
	;將會用到的暫存器內容放入堆疊
	push eax
	push ebx

	mov al, X1;
	mov bl, Y1;
	
	;2*x1 + y1 + 13 =x2
	
	add al, al
	add al, bl
	add al, 30
	mov dl, al
	
	;-y1 + 9 = y2
	neg bl
	add bl, 15
	mov dh, bl
	
	;從堆疊取回暫存器內容
	pop ebx
	pop eax
	
	ret

Transfer ENDP
;----------------------------------------------Boundary----------------------------------------------
Boundary PROC, ux:SBYTE, uy:SBYTE
		push ebx
	test_uptri: 
		
		;判斷是否在上三角裡，只要有一項不符合，
		;就直接跳去判斷是不是下三角里
		cmp uy, -4
		jl test_downtri  ;y<-4
		cmp ux, -4 
		jl test_downtri  ;x<-4
		mov bl, ux
		add bl, uy
		cmp bl, 4  
		jg test_downtri  ;x+y>4
		jmp Istrue
		
		;三項都符合，所以在上三角裡
		;就直接跳去Istrue，回傳true(ax=1)，結束程式

	test_downtri:
		;判斷是否在下三角裡，只要有一項不符合，
		;就直接跳去Isfalse，回傳false(ax=0)，結束程式
		cmp uy, 4 
		jg Isfalse  ;y > 4
		cmp ux, 4 
		jg Isfalse  ;x > 4
		mov bl, ux
		add bl, uy
		cmp bl, -4
		jl Isfalse  ;x+y>=-4
		
		;三項都符合，所以在下三角裡就
		;到Istrue，回傳true(ax=1)，結束程式
		
	Istrue:
		mov ax, 1
		jmp existBoundary
	Isfalse:
		mov ax, 0
	existBoundary:
		pop ebx
		ret
		
Boundary ENDP
;----------------------------------------------Iswin----------------------------------------------
Iswin PROC
		push edi
		push ecx
		mov ecx, 15
		mov edi, 0
	checkR:
		cmp (COOR PTR B[edi]).Y, -4   		;B的每個棋子的Y都必須小於等於-4
		jg checkM                     		;只要有一顆沒有，R就不可能贏，就直接跳去check M
		cmp (COOR PTR B[edi]).X, 0			;B的每個棋子的X都必須大於等於0
		jl checkM                     		;只要有一顆沒有，B就不可能贏，就直接跳去check M
		cmp (COOR PTR B[edi]).X, 4			;B的每個棋子的X都必須小於等於4
		jg checkM                  	   		;只要有一顆沒有，B就不可能贏，就直接跳去check M
		add edi, TYPE COOR
		loop checkR
		mov bx, 1
		jmp Win                        		;B每顆棋子的Y都小於等於-4，則B贏了
		
	checkM:
		mov ecx, 15
		mov edi, 0
	Mloop:
		mov bl, (COOR PTR M[edi]).X    		;M的每個棋子都必須x+y>=4
		add bl, (COOR PTR M[edi]).Y
		cmp bl, 4 
		jl checkBr                    		;只要有一顆沒有，M就不可能贏，就直接跳去check Br
		cmp (COOR PTR M[edi]).Y, 0     		;M的每個棋子的Y都必須大於等於0
		jl checkBr                    		;只要有一顆沒有，M就不可能贏，就直接跳去check Br
		cmp (COOR PTR M[edi]).Y, 4    		;M的每個棋子的Y都必須小於等於4
		jg checkBr                      		;只要有一顆沒有，M不可能贏，就直接跳去check Br
		add edi, TYPE COOR
		loop Mloop
		mov bx, 2
		jmp Win                       		;M的每個棋子都x+y>=4，則M贏了
		
	checkBr:
		mov ecx, 15
		mov edi, 0
	Brloop:
		cmp (COOR PTR Br[edi]).X, -4    		;Br的每個棋子的X都必須小於等於-4
		jg Conti                       		;只要有一顆沒有，Br就不可能贏，即B,M,Br都沒有人贏
		cmp (COOR PTR Br[edi]).Y, 0    		;Br的每個棋子的Y都必須大於等於0
		jl Conti                      		;只要有一顆沒有，Br就不可能贏，即B,M,Br都沒有人贏 Y
		cmp (COOR PTR Br[edi]).Y, 4    		;Br的每個棋子的Y都必須小於等於4
		jg Conti                      		;只要有一顆沒有，Br就不可能贏，即B,M,Br都沒有人贏
		add edi, TYPE COOR
		loop Brloop
		mov bx, 3
		jmp Win								;Br每顆棋子的X都小於等於-4，則Br贏了
		
	Win:									;有玩家勝利 ax = 1
		mov ax, 1
		jmp existIswin
		
	Conti:									;無玩家勝利 ax = 0
		mov ax, 0;
		
	existIswin:
		pop ecx
		pop edi
		ret
		
Iswin ENDP
;----------------------------------------------movecursor----------------------------------------------
movecursor PROC

		push eax
		push ebx
	
	;等待輸入上、下、左、右、enter
	WaitInput:
		call readchar
		cmp  eax, 4800h						;上
		jz   UP
		cmp  eax, 5000h						;下
		jz   DOWN
		cmp  eax, 4B00h						;左
		jz   LEFT
		cmp  eax, 4D00h						;右
		jz   RIGHT
		cmp  eax, 1C0Dh						;enter
		jz   OUTFUN
		jmp  WaitInput
	
	;上 -> Y座標+1 並判斷位置是否超出邊界
	UP:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bl, 1
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   WaitInput
		mov  cursor.X, bh
		mov  cursor.Y, bl
		INVOKE print
		jmp  WaitInput
	
	;下 -> Y座標-1 並判斷位置是否超出邊界
	DOWN:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bl, -1
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   WaitInput
		mov  cursor.X, bh
		mov  cursor.Y, bl
		INVOKE print
		jmp  WaitInput
	
	;左 -> X座標-1 並判斷位置是否超出邊界
	LEFT:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bh, -1
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   WaitInput
		mov  cursor.X, bh
		mov  cursor.Y, bl
		INVOKE print
		jmp  WaitInput
	
	;右 -> X座標+1 並判斷位置是否超出邊界
	RIGHT:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bh, 1
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   WaitInput
		mov  cursor.X, bh
		mov  cursor.Y, bl
		INVOKE print
		jmp  WaitInput
	
	;enter 跳出函式
	OUTFUN:
		pop  ebx
		pop  eax
		ret
		
movecursor ENDP
;----------------------------------------------movechess----------------------------------------------
movechess PROC

		;宣告區域變數  isjmp:判斷是否為"跳"棋  chessx:棋子X座標  chessy:棋子Y座標
		LOCAL isjmp : byte, chessx : sbyte,chessy : sbyte
		push ebx
		push edx
		
		;isjmp預設為0
		mov  isjmp, 0
		
	moveagain:
		
		;移動游標
		INVOKE movecursor
		
		;將棋子原始位置寫入 (bh, bl)
		mov  bh, (COOR PTR [esi]).X
		mov  chessx, bh
		mov  bl, (COOR PTR [esi]).Y
		mov  chessy, bl

		;檢查游標位置是否有棋子
		INVOKE IsChess, cursor.X, cursor.Y
		cmp  al, 0
		jz   startmove						;該位置無棋子
		
		;如果(bh, bl) == (cursor.X, cursor.Y) => 處理跳棋結束 或者 取消選取
		cmp  bh, cursor.X
		jnz  haschess
		cmp  bl, cursor.Y
		jnz  haschess
		jmp  startmove
	
	haschess:
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET havechess			;印出"This position has a chess."狀態
		call WriteString
		jnz  moveagain	
		
	startmove:	
		;(bh, bl) 紀錄後來位置與原始位置的差
		mov  bh, cursor.X
		mov  bl, cursor.Y
		sub  bh, chessx
		sub  bl, chessy
		
		;跳過的棋子不用判斷移動
		cmp  isjmp, 0
		jnz  jump							;處理"跳"棋
		
		cmp  bh, 1
		jz   xplusone						;X座標差 = +1(走、跳)
		cmp  bh, 0
		jz   xremain1						;X座標差 = 0 (走、跳、取消選取)
		cmp  bh, -1
		jz   xminusone						;X座標差 = -1(走、跳)
		cmp  bh, 2
		jz   xplustwo						;X座標差 = +2(跳)
		cmp  bh, -2
		jz   xminustwo						;X座標差 = -2(跳)
		jmp  invalidmove					;X座標差超出範圍(非法移動)
	
	;X座標差 = +1(走、跳)
	xplusone:
		cmp  bl, 0
		jz   moveright;						;Y座標差 = 0 (向右走)
		cmp  bl, -1	
		jz   moverightdown					;Y座標差 = -1(向右下走)
		jmp  invalidmove					;Y座標差超出範圍(非法移動)
	
	;向右走
	moveright:
		mov  bh, chessx
		add  bh, 1
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret
	
	;向右下走
	moverightdown:
		mov  bh, chessx
		add  bh, 1
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		add  bl, -1
		mov  (COOR PTR [esi]).Y, bl			;改變旗子Y座標
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret

	;X座標差 = 0 (走、跳、取消選取)
	xremain1:
		cmp  bl, 1
		jz   moverightup					;Y座標差 = 1 (向右上走)
		cmp  bl, -1						
		jz   moveleftdown					;Y座標差 = -1 (向左下走)
		cmp  bl, 0
		jz   unlock							;Y座標差 = 0 (取消選取)
		cmp  bl, 2
		jz   jumprightup					;Y座標差 = 2 (向右上跳)
		cmp  bl, -2
		jz   jumpleftdown					;Y座標差 = -2 (向左下跳)
		jmp  invalidmove					;Y座標差超出範圍(非法移動)

	;取消選取
	unlock:
		mov  ax, 0							;設定 ax = 0 供主程式判斷控制權轉移
		pop  ebx
		ret
	
	;向右上走
	moverightup:
		mov  bh, chessx
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		add  bl, 1
		mov  (COOR PTR [esi]).Y, bl			;改變旗子Y座標
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret
	
	;向左下走
	moveleftdown:
		mov  bh, chessx
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		sub  bl, 1
		mov  (COOR PTR [esi]).Y, bl			;改變旗子Y座標
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret
	
	;X座標差 = -1 (走、跳)
	xminusone:
		cmp  bl, 0
		jz   moveleft						;Y座標差 = 0 (向左走)
		cmp  bl, 1
		jz   moveleftup						;Y座標差 = 1 (向左上走)
		jmp  invalidmove					;Y座標差超出範圍(非法移動)
		
	;向左走
	moveleft:
		mov  bh, chessx
		add  bh, -1
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret
	
	;向左上走
	moveleftup:
		mov  bh, chessx
		add  bh, -1
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		add  bl, 1
		mov  (COOR PTR [esi]).Y, bl			;改變旗子Y座標
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret

	;這裡處理"跳"棋
	jump:
		cmp  bh, 2
		jz   xplustwo						;X座標差 = +2(跳)
		cmp  bh, 0
		jz   xremain2						;X座標差 = 0 (跳)
		cmp  bh, -2
		jz   xminustwo						;X座標差 = -2(跳)
		jmp  invalidmove					;X座標差超出範圍(非法移動)
		
	xplustwo:
		cmp  bl, 0
		jz   jumpright						;Y座標差 = 0 (向右跳)
		cmp  bl, -2
		jz   jumprightdown					;Y座標差 = -2 (向右下跳)
		jmp  invalidmove					;Y座標差超出範圍(非法移動)
		
	jumpright:
		mov  bh, cursor.X
		add  bh, -1
		mov  bl, cursor.Y
		INVOKE IsChess, bh, bl				;判斷要跳的方向是否有棋子
		cmp  al, 0
		jz   invalidmove					;要跳的方向無棋子
		mov  bh, chessx
		add  bh, 2
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  isjmp, 1						;設定 isjmp = 1
		INVOKE print
		jmp  jumpagain

	jumprightdown:
		mov  bh, cursor.X
		add  bh, -1
		mov  bl, cursor.Y
		add  bl, 1
		INVOKE IsChess, bh, bl				;判斷要跳的方向是否有棋子
		cmp  al, 0
		jz   invalidmove					;要跳的方向無棋子
		mov  bh, chessx
		add  bh, 2
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		add  bl, -2
		mov  (COOR PTR [esi]).Y, bl			;改變旗子Y座標
		mov  isjmp, 1						;設定 isjmp = 1
		INVOKE print
		jmp  jumpagain
		
	xremain2:
		cmp  bl, 2	
		jz   jumprightup					;Y座標差 = 2 (向右上跳)
		cmp  bl, -2
		jz   jumpleftdown					;Y座標差 = -2 (向左下跳)
		cmp  bl, 0
		jz   jumpend						;Y座標差 = 0 (跳棋結束)
		jmp  invalidmove					;Y座標差超出範圍(非法移動)

	jumprightup:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bl, -1
		INVOKE IsChess, bh, bl				;判斷要跳的方向是否有棋子
		cmp  al, 0
		jz   invalidmove					;要跳的方向無棋子
		mov  bh, chessx
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		add  bl, 2
		mov  (COOR PTR [esi]).Y, bl			;改變旗子Y座標
		mov  isjmp, 1						;設定 isjmp = 1
		INVOKE print
		jmp  jumpagain

	jumpleftdown:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bl, 1
		INVOKE IsChess, bh, bl				;判斷要跳的方向是否有棋子
		cmp  al, 0
		jz   invalidmove					;要跳的方向無棋子
		mov  bh, chessx
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		add  bl, -2
		mov  (COOR PTR [esi]).Y, bl			;改變旗子Y座標
		mov  isjmp, 1						;設定 isjmp = 1
		INVOKE print
		jmp  jumpagain
		
	xminustwo:
		cmp  bl, 2							;Y座標差 = 2 (向左上跳)
		jz   jumpleftup
		cmp  bl, 0							;Y座標差 = 0 (向左跳)
		jz   jumpleft
		jmp  invalidmove					;Y座標差超出範圍(非法移動)

	jumpleftup:
		mov  bh, cursor.X
		add  bh, 1
		mov  bl, cursor.Y
		add  bl, -1
		INVOKE IsChess, bh, bl				;判斷要跳的方向是否有棋子
		cmp  al, 0
		jz   invalidmove					;要跳的方向無棋子
		mov  bh, chessx
		add  bh, -2
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		add  bl, 2
		mov  (COOR PTR [esi]).Y, bl			;改變旗子Y座標
		mov  isjmp, 1						;設定 isjmp = 1
		INVOKE print
		jmp  jumpagain

	jumpleft:
		mov  bh, cursor.X
		add  bh, 1
		mov  bl, cursor.Y
		INVOKE IsChess, bh, bl				;判斷要跳的方向是否有棋子
		cmp  al, 0
		jz   invalidmove					;要跳的方向無棋子
		mov  bh, chessx
		add  bh, -2
		mov  (COOR PTR [esi]).X, bh			;改變旗子X座標
		mov  bl, chessy
		mov  isjmp, 1						;設定 isjmp = 1
		INVOKE print
		jmp  jumpagain

	;跳棋可以決定是否要繼續跳
	jumpagain:
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET jumporstop
		call WriteString
		jmp  moveagain
	
	;非法移動
	invalidmove:	
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET cantjump
		call WriteString
		jmp  moveagain
	
	;結束移動
	jumpend:
		mov  ax, 1
		pop  edx
		pop  ebx
		ret

movechess ENDP
;----------------------------------------------Choose----------------------------------------------
Choose PROC
		push eax;
		push ecx;
		push ebx;
		push edx;
		push edi;
	stage_move:
		INVOKE Movecursor                   ;移動游標
		INVOKE print
		INVOKE Boundary, cursor.X, cursor.Y ;確認游標有沒有在棋盤內
		cmp ax, 1
		jne stage_move                      ;沒有的話回到移動游標的狀態 
		INVOKE IsChess, cursor.X, cursor.Y  ;確認選到的是不是正確的棋子(是不是和control相同)
		cmp al, control
		jne invalidchoose                 	;選錯的話回到移動游標的狀態  
		mov bl, al
		mov ecx, 15                         ;count=15
		mov ah, cursor.X                    ;把游標的XY傳進ax
		mov al, cursor.Y
		cmp bl, 1                           ;是藍棋
		je chessB
		cmp bl, 2                           ;是紅紫棋
		je chessM
		cmp bl, 3                           ;是咖啡棋
		je chessBr
		
	chessB: 
		mov edi, OFFSET B                   ;edi指到B(藍棋)的起始位置
		jmp stage_return
		
	chessM:
		mov edi, OFFSET M                  ;edi指到M(紅紫棋)的起始位置	
		jmp stage_return
		
	chessBr:
		mov edi, OFFSET Br                   ;edi指到Br(咖啡棋)的起始位置	
		jmp stage_return
		
	stage_return:
		cmp ah, (COOR PTR [edi]).X
		jnz reloop							;X座標不符
		cmp al, (COOR PTR [edi]).Y
		jnz reloop							;Y座標不符
		jmp stage_find						;找到相符位置的棋子
		
	reloop:
		add edi, TYPE COOR					;判斷選取的是否為下一隻棋子
		loop stage_return
		
	stage_find:
		mov esi, edi                        ;回傳esi=edi
		pop eax;
		pop ecx;
		pop ebx;
		pop edx;
		pop edi;
		ret
		
	;非法選取棋子
	invalidchoose:
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET chooseyourschess
		call WriteString					;印出"You Can't choose other's chess or choose Nothing. Please choose your own chess! "狀態
		INVOKE Transfer, cursor.X, cursor.Y
		call Gotoxy
		jmp stage_move                      ;選錯的話回到移動游標的狀態	
		
Choose ENDP
;----------------------------------------------IsChess----------------------------------------------
IsChess PROC,
		boolx: sbyte, booly: sbyte
		
		;將使用的暫存器的值存到堆疊
		push ecx							
		push ebx
		push edi
		
		mov ecx, 45							;設定迴圈次數
		mov edi, OFFSET B					;設定edi指到B的記憶體位置
	find:
		mov bl, (COOR PTR [edi]).X
		mov bh, (COOR PTR [edi]).Y
		
		cmp boolx, bl
		jnz addpointer						;X座標不符
		cmp booly, bh
		jnz addpointer						;Y座標不符
		jz lookecx
		
	addpointer:
		add edi, TYPE COOR
		loop find
		
	;找到對應位置的棋子 判斷ecx範圍 取的棋子的所有者
	lookecx:
		cmp ecx, 30
		jg findr							;藍棋
		cmp ecx, 15
		jg findg							;紅紫棋
		cmp ecx, 0
		jg findy							;咖啡棋
		cmp ecx, 0
		jz nofind							;無棋子
		
	;藍棋  al = 1
	findr:
		mov al, 1
		pop  edi
		pop  ebx
		pop  ecx
		ret
		
	;紅紫棋	al = 2
	findg:
		mov al, 2
		pop  edi
		pop  ebx
		pop  ecx
		ret
		
	;咖啡棋  al = 3
	findy:
		mov al, 3
		pop  edi
		pop  ebx
		pop  ecx
		ret
		
	;無棋子	 al = 0
	nofind:
		mov al, 0
		pop  edi
		pop  ebx
		pop  ecx
		ret
		
IsChess ENDP
END main	