ORG 00H ;���������ʼλ��
AJMP START
ORG 0100H

START:	MOV A,#0FEH
		MOV P0,A

MAIN: 	JNB P1.0,K1 ;JNB,CF��־λΪ0��ʱ����ת
		JNB P1.1,K2 
		SJMP MAIN ;LJMP��ת��ָ��,PC=addr16��AJMP����ת��ָ��,ҳ����ת,PC+1,PC[10-0]=addr11��SJMP��ת��ָ��,PC+2,PC=PC+rel��JMP��ַѰַת��ָ��

;K1�����£�����ʱһ���ж��Ƿ��󴥷�����ʹLED���ƣ����ƺ�����ʱ0.2s����main����
K1: 	LCALL DELAYMS ;PC+3,SP+1,(SP)=PC[7-0],SP+1,(SP)=PC[15-8],PC=addr16,�����������ڵ��ú���
		JNB P1.0,K11
		SJMP MAIN
K11: 	RR A
		MOV P0,A
		LCALL DELAY
		SJMP MAIN

;K1�����£�����ʱһ���ж��Ƿ��󴥷�����ʹLED���ƣ����ƺ�����ʱ0.2s����main����
K2: 	LCALL DELAYMS 
		JNB P1.1,K22
		SJMP MAIN
K22: 	RL A
		MOV P0,A
		LCALL DELAY
		SJMP MAIN

;ѭ��30ms��ͨ��DJNZʵ��
DELAYMS: 
		MOV R3,#60
D0: 	MOV R4,#248
		DJNZ R4,$  ;DJNZ,���Ĵ�����ֱ��Ѱַ��ַ�ֽڼ�һ������0�������У�����������ת��ָ��λ��
		DJNZ R3,D0
		RET		;���ö�ջ
	
;ѭ��0.2s��ͨ��DJNZʵ��
DELAY: 	MOV R5,#20
D1: 	MOV R6,#20
D2: 	MOV R7,#248
		DJNZ R7,$
		DJNZ R6,D2
		DJNZ R5,D1
		RET

END

