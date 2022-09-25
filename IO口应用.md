硬件部分
* 复位电路：按键被按下，RST端电位升高按键松开，RST端在电容作用下电位逐渐降低，实现复位操作
* 晶振电路：12MHz
* 按键电路：采用P1口，按键按下，端口置0，(有点好奇这里为什么要上拉电阻，P1口不是带内部上拉电阻吗)
* LED电路：采用P0口，带上拉电阻

软件部分
```asm
ORG 00H ;定义程序起始位置
AJMP START
ORG 0100H

START:	MOV A,#0FEH
		MOV P0,A

MAIN: 	JNB P1.0,K1 ;JNB,CF标志位为0的时候跳转
		JNB P1.1,K2 
		SJMP MAIN ;LJMP长转移指令,PC=addr16，AJMP绝对转移指令,页内跳转,PC+1,PC[10-0]=addr11，SJMP短转移指令,PC+2,PC=PC+rel，JMP变址寻址转移指令

;K1被按下，先延时一下判断是否误触发，再使LED右移，右移后在延时0.2s返回main函数
K1: 	LCALL DELAYMS ;PC+3,SP+1,(SP)=PC[7-0],SP+1,(SP)=PC[15-8],PC=addr16,很明显这是在调用函数
		JNB P1.0,K11
		SJMP MAIN
K11: 	RR A
		MOV P0,A
		LCALL DELAY
		SJMP MAIN

;K2被按下，先延时一下判断是否误触发，再使LED左移，右移后在延时0.2s返回main函数
K2: 	LCALL DELAYMS 
		JNB P1.1,K22
		SJMP MAIN
K22: 	RL A
		MOV P0,A
		LCALL DELAY
		SJMP MAIN

;循环30ms，通过DJNZ实现
DELAYMS: 
		MOV R3,#60
D0: 	MOV R4,#248
		DJNZ R4,$  ;DJNZ,将寄存器或直接寻址地址字节减一，等于0向下运行，不等于零跳转到指定位置
		DJNZ R3,D0
		RET	    ;调用堆栈
	
;循环0.2s，通过DJNZ实现
DELAY: 	MOV R5,#20
D1: 	MOV R6,#20
D2: 	MOV R7,#248
		DJNZ R7,$
		DJNZ R6,D2
		DJNZ R5,D1
		RET

END
```

遇到的问题与解决方法：
* 如何创建工程
* keil仿真调试没问题，但是proteus仿真led却只能移动一次
