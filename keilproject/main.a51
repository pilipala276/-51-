;***********************功能说明*************************
;用AT89C52的MCU外部中断0记录中断次数并显示
;连线方式为P0口连接数码管段选SA-SH，P32连接按键作为中断输入
;程序启动时，初始化显示一下设定值，有按键按下进入中断，计数+1
;********************************************************
ORG 0000H
AJMP MAIN

ORG 0003H
LJMP INTT0

;--------------------------------------------------------

ORG 0100H
MAIN:	;************主程序******************************
	MOV P1,#0FFH
LOOP:	
	MOV 40H,#00H	;系统初始设置计数初值0000
LOOP0:
	MOV 39H,#00H
	MOV 38H,#00H
	MOV 37H,#02H	
	
	MOV 30H,#00H	;数码管显示缓存，千位
	MOV 29H,#00H	;数码管显示缓存，百位
	MOV 28H,#00H	;数码管显示缓存，十位
	MOV 27H,#00H	;数码管显示缓存，个位
	
	MOV 30H,40H		;初值传递
	MOV 29H,39H
	MOV 28H,38H
	MOV 27H,37H
	
	MOV DPTR,#TAB
	MOV R1,#50H
	MOV R2,#50H
JJJ:				;显示系统设置的初始值
	LCALL DISPLAY	
	DJNZ R1,JJJ 
	;DJNZ R2,JJJ
	
	MOV 30H,#00H	
	MOV 29H,#00H	
	MOV 28H,#00H	
	MOV 27H,#00H	
	SETB EA			;开启CPU中断
	SETB IT0		;边沿触发
	SETB EX0		;开启外部中断0
	
KKK:	
	LCALL DISPLAY	;循化调用显示子程序
	AJMP KKK
	

;***********************功能说明*************************
;*******************外部中断0子程序**********************
;********************************************************
INTT0:
	INC 27H			;累加
	MOV A,27H		;判断个位是否为10，不相等转移，相等进一
	CJNE A,#10,LOOP1
	MOV 27H,#00H
	
	INC 28H			
	MOV A,28H		;判断十位是否为10，不相等转移，相等进一
	CJNE A,#10,LOOP1
	MOV 28H,#00H
	
	INC 29H			
	MOV A,29H		;判断百位是否为10，不相等转移，相等进一
	CJNE A,#10,LOOP1
	MOV 29H,#00H
	
	INC 30H			
	MOV A,30H		;判断千位是否为10，不相等转移，相等清零
	CJNE A,#10,LOOP1
	MOV 30H,#00H
	
LOOP1:
	MOV A,27H		;判断计数值是否达到设定值
	CLR C
	SUBB A,37H
	JNZ LOOP2
	
	MOV A,28H		
	CLR C
	SUBB A,38H
	JNZ LOOP2
	
	MOV A,29H		
	CLR C
	SUBB A,39H
	JNZ LOOP2
	
	MOV A,30H		
	CLR C
	SUBB A,40H
	JNZ LOOP2
	
	MOV P0,#0FFH		;计数值是否达到设定值，清零
	MOV 30H,#00H		
	MOV 29H,#00H	
	MOV 28H,#00H	
	MOV 27H,#00H
	MOV P1,#0FFH
	
LOOP2:
	RETI
	
;***********************功能说明*************************
;**********************显示子程序************************
;********************************************************
DISPLAY:
	;MOV P1,#0FFH
	
	MOV A,30H			;数码管显示千位数
	MOVC A,@A+DPTR
	MOV P0,A
	SETB P1.0
	ACALL DELAY
	CLR P1.0
	
	MOV A,29H			;数码管显示百位数
	MOVC A,@A+DPTR
	MOV P0,A
	SETB P1.1
	ACALL DELAY
	CLR P1.1
	
	MOV A,28H			;数码管显示十位数
	MOVC A,@A+DPTR
	MOV P0,A
	SETB P1.2
	ACALL DELAY
	CLR P1.2
	
	MOV A,27H			;数码管显示个位数
	MOVC A,@A+DPTR
	MOV P0,A
	SETB P1.3
	ACALL DELAY
	CLR P1.3
	
	
	RET
	
;=========================================
TAB:					;数码管显示数字需要传入的值
	DB	0C0H;0
	DB	0F9H;1
	DB	0A4H;2
	DB	0B0H;3
	DB	099H;4
	DB	092H;5
	DB	082H;6
	DB	0F8H;7
	DB	080H;8
	DB	090H;9
;=========================================
DELAY:					;延时函数
		MOV R6,#10H
DEL1:
		MOV R7,#10H
		DJNZ R7,$
		DJNZ R6,DEL1
		RET
;=========================================

END