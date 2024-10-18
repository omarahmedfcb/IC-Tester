
;CodeVisionAVR C Compiler V3.46a 
;(C) Copyright 1998-2021 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x49,0x43,0x20,0x37,0x34,0x31,0x35,0x33
	.DB  0xD,0x0,0x49,0x43,0x20,0x37,0x34,0x31
	.DB  0x35,0x35,0xD,0x0,0x49,0x43,0x20,0x37
	.DB  0x34,0x31,0x35,0x36,0xD,0x0,0x49,0x43
	.DB  0x20,0x37,0x34,0x31,0x35,0x37,0xD,0x0
	.DB  0x49,0x43,0x20,0x37,0x34,0x31,0x35,0x38
	.DB  0xD,0x0,0x49,0x43,0x20,0x37,0x34,0x31
	.DB  0x35,0x34,0xD,0x0,0x4E,0x6F,0x74,0x20
	.DB  0x44,0x65,0x66,0x69,0x6E,0x65,0x64,0xD
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _0x9
	.DW  _0x0*2

	.DW  0x0A
	.DW  _0x9+10
	.DW  _0x0*2+10

	.DW  0x0A
	.DW  _0x9+20
	.DW  _0x0*2+20

	.DW  0x0A
	.DW  _0x9+30
	.DW  _0x0*2+30

	.DW  0x0A
	.DW  _0x9+40
	.DW  _0x0*2+40

	.DW  0x0A
	.DW  _0x9+50
	.DW  _0x0*2+50

	.DW  0x0D
	.DW  _0x9+60
	.DW  _0x0*2+60

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;unsigned char ic74153();
;unsigned char ic74154();
;unsigned char ic74155();
;unsigned char ic74156();
;unsigned char ic74157();
;unsigned char ic74158();
;void ic_test();
;void main(void)
; 0000 0016 {

	.CSEG
_main:
; .FSTART _main
; 0000 0017 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0018 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0019 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 001A UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 001B UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 001C PORTD = 0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 001D 
; 0000 001E 
; 0000 001F while (1)
_0x3:
; 0000 0020 {
; 0000 0021 if (SW == 0)
	SBIC 0x10,2
	RJMP _0x6
; 0000 0022 {
; 0000 0023 ic_test();
	RCALL _ic_test
; 0000 0024 delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0025 }
; 0000 0026 }
_0x6:
	RJMP _0x3
; 0000 0027 }
_0x7:
	RJMP _0x7
; .FEND
;void ic_test()
; 0000 002B {
_ic_test:
; .FSTART _ic_test
; 0000 002C char check = 0;
; 0000 002D check = ic74153();
	ST   -Y,R17
;	check -> R17
	LDI  R17,0
	RCALL _ic74153
	MOV  R17,R30
; 0000 002E if (check == 1)
	CPI  R17,1
	BRNE _0x8
; 0000 002F {
; 0000 0030 puts("IC 74153\r");
	__POINTW2MN _0x9,0
	RJMP _0x2060005
; 0000 0031 return;
; 0000 0032 }
; 0000 0033 check = ic74155();
_0x8:
	RCALL _ic74155
	MOV  R17,R30
; 0000 0034 if (check == 1)
	CPI  R17,1
	BRNE _0xA
; 0000 0035 {
; 0000 0036 puts("IC 74155\r");
	__POINTW2MN _0x9,10
	RJMP _0x2060005
; 0000 0037 return;
; 0000 0038 }
; 0000 0039 check = ic74156();
_0xA:
	RCALL _ic74156
	MOV  R17,R30
; 0000 003A if (check == 1)
	CPI  R17,1
	BRNE _0xB
; 0000 003B {
; 0000 003C puts("IC 74156\r");
	__POINTW2MN _0x9,20
	RJMP _0x2060005
; 0000 003D return;
; 0000 003E }
; 0000 003F check = ic74157();
_0xB:
	RCALL _ic74157
	MOV  R17,R30
; 0000 0040 if (check == 1)
	CPI  R17,1
	BRNE _0xC
; 0000 0041 {
; 0000 0042 puts("IC 74157\r");
	__POINTW2MN _0x9,30
	RJMP _0x2060005
; 0000 0043 return;
; 0000 0044 }
; 0000 0045 check = ic74158();
_0xC:
	RCALL _ic74158
	MOV  R17,R30
; 0000 0046 if (check == 1)
	CPI  R17,1
	BRNE _0xD
; 0000 0047 {
; 0000 0048 puts("IC 74158\r");
	__POINTW2MN _0x9,40
	RJMP _0x2060005
; 0000 0049 return;
; 0000 004A }
; 0000 004B check = ic74154();
_0xD:
	RCALL _ic74154
	MOV  R17,R30
; 0000 004C if (check == 1)
	CPI  R17,1
	BRNE _0xE
; 0000 004D {
; 0000 004E puts("IC 74154\r");
	__POINTW2MN _0x9,50
	RJMP _0x2060005
; 0000 004F return;
; 0000 0050 }
; 0000 0051 
; 0000 0052 puts("Not Defined\r");
_0xE:
	__POINTW2MN _0x9,60
_0x2060005:
	RCALL _puts
; 0000 0053 }
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x9:
	.BYTE 0x49
;unsigned char ic74153()
; 0000 0056 {

	.CSEG
_ic74153:
; .FSTART _ic74153
; 0000 0057 
; 0000 0058 signed char j,i;
; 0000 0059 unsigned char D = 0x09 , x;
; 0000 005A DDRA = 0xF0;
	RCALL __SAVELOCR4
;	j -> R17
;	i -> R16
;	D -> R19
;	x -> R18
	LDI  R19,9
	LDI  R30,LOW(240)
	RCALL SUBOPT_0x0
; 0000 005B PORTA = 0;
; 0000 005C DDRC = 0xF0;
; 0000 005D PORTC = 0;
; 0000 005E DDRD =0xB0;
	LDI  R30,LOW(176)
	OUT  0x11,R30
; 0000 005F //DDRD |= 0xB0;
; 0000 0060 PORTD = 0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 0061 DDRB = 0X07;
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x1
; 0000 0062 PORTB = 0;
; 0000 0063 GND = 0;
; 0000 0064 VCC = 1;
; 0000 0065 PORTA.4 = 1; PORTC.5 = 1;  //enables
	SBI  0x1B,4
	SBI  0x15,5
; 0000 0066 // input 1001
; 0000 0067 
; 0000 0068 for (i = 0;i <= 1;i++)
	LDI  R16,LOW(0)
_0x18:
	CPI  R16,2
	BRLT PC+2
	RJMP _0x19
; 0000 0069 {
; 0000 006A PORTA.6 =Read_BIT(D,3);PORTA.7 =Read_BIT(D,2);PORTD.4 =Read_BIT(D,1);PORTD.5 =Read_BIT(D,0);
	RCALL SUBOPT_0x2
	BRNE _0x1A
	CBI  0x1B,6
	RJMP _0x1B
_0x1A:
	SBI  0x1B,6
_0x1B:
	RCALL SUBOPT_0x3
	BRNE _0x1C
	CBI  0x1B,7
	RJMP _0x1D
_0x1C:
	SBI  0x1B,7
_0x1D:
	RCALL SUBOPT_0x4
	BRNE _0x1E
	CBI  0x12,4
	RJMP _0x1F
_0x1E:
	SBI  0x12,4
_0x1F:
	SBRC R19,0
	RJMP _0x20
	CBI  0x12,5
	RJMP _0x21
_0x20:
	SBI  0x12,5
_0x21:
; 0000 006B x = 0;
	LDI  R18,LOW(0)
; 0000 006C for (j = 3; j >= 0;j--)
	LDI  R17,LOW(3)
_0x23:
	CPI  R17,0
	BRLT _0x24
; 0000 006D {
; 0000 006E PORTA.5 = Read_BIT(j,1);
	RCALL SUBOPT_0x5
	BRNE _0x25
	CBI  0x1B,5
	RJMP _0x26
_0x25:
	SBI  0x1B,5
_0x26:
; 0000 006F PORTC.6 = Read_BIT(j,0);
	SBRC R17,0
	RJMP _0x27
	CBI  0x15,6
	RJMP _0x28
_0x27:
	SBI  0x15,6
_0x28:
; 0000 0070 PORTA.4 = 0;
	CBI  0x1B,4
; 0000 0071 delay_ms(30);
	RCALL SUBOPT_0x6
; 0000 0072 
; 0000 0073 x = (x << 1) | PIND.6;
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	OR   R30,R26
	MOV  R18,R30
; 0000 0074 PORTA.4 = 1 ;
	SBI  0x1B,4
; 0000 0075 delay_ms(30);
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0076 if (PIND.6 != 0){
	SBIS 0x10,6
	RJMP _0x2D
; 0000 0077 return 0;
	LDI  R30,LOW(0)
	JMP  _0x2060001
; 0000 0078 }
; 0000 0079 
; 0000 007A }
_0x2D:
	SUBI R17,1
	RJMP _0x23
_0x24:
; 0000 007B delay_ms(30);
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay_ms
; 0000 007C if (x != D) {
	CP   R19,R18
	BREQ _0x2E
; 0000 007D return 0;
	LDI  R30,LOW(0)
	JMP  _0x2060001
; 0000 007E }
; 0000 007F D^= 0x0F;
_0x2E:
	LDI  R30,LOW(15)
	EOR  R19,R30
; 0000 0080 }
	SUBI R16,-1
	RJMP _0x18
_0x19:
; 0000 0081 
; 0000 0082 D = 0x09 ; x=0;
	LDI  R19,LOW(9)
	LDI  R18,LOW(0)
; 0000 0083 for (i = 0;i <= 1;i++)
	LDI  R16,LOW(0)
_0x30:
	CPI  R16,2
	BRGE _0x31
; 0000 0084 {
; 0000 0085 PORTC.7 =Read_BIT(D,3);PORTB.0 =Read_BIT(D,2);PORTB.1 =Read_BIT(D,1);PORTB.2 =Read_BIT(D,0);
	RCALL SUBOPT_0x2
	BRNE _0x32
	CBI  0x15,7
	RJMP _0x33
_0x32:
	SBI  0x15,7
_0x33:
	RCALL SUBOPT_0x3
	BRNE _0x34
	CBI  0x18,0
	RJMP _0x35
_0x34:
	SBI  0x18,0
_0x35:
	RCALL SUBOPT_0x4
	BRNE _0x36
	CBI  0x18,1
	RJMP _0x37
_0x36:
	SBI  0x18,1
_0x37:
	SBRC R19,0
	RJMP _0x38
	CBI  0x18,2
	RJMP _0x39
_0x38:
	SBI  0x18,2
_0x39:
; 0000 0086 x = 0;
	LDI  R18,LOW(0)
; 0000 0087 for (j = 3; j >= 0;j--)
	LDI  R17,LOW(3)
_0x3B:
	CPI  R17,0
	BRLT _0x3C
; 0000 0088 {
; 0000 0089 PORTA.5 = Read_BIT(j,1);
	RCALL SUBOPT_0x5
	BRNE _0x3D
	CBI  0x1B,5
	RJMP _0x3E
_0x3D:
	SBI  0x1B,5
_0x3E:
; 0000 008A PORTC.6 = Read_BIT(j,0);
	SBRC R17,0
	RJMP _0x3F
	CBI  0x15,6
	RJMP _0x40
_0x3F:
	SBI  0x15,6
_0x40:
; 0000 008B PORTC.5 = 0;
	CBI  0x15,5
; 0000 008C delay_ms(30);
	RCALL SUBOPT_0x6
; 0000 008D 
; 0000 008E x = (x << 1) | PINB.3;
	LDI  R30,0
	SBIC 0x16,3
	LDI  R30,1
	OR   R30,R26
	MOV  R18,R30
; 0000 008F PORTC.5 =1;
	RCALL SUBOPT_0x7
; 0000 0090 delay_ms(30);
; 0000 0091 if (PINB.3 != 0) {
	SBIS 0x16,3
	RJMP _0x45
; 0000 0092 return 0;
	LDI  R30,LOW(0)
	JMP  _0x2060001
; 0000 0093 }
; 0000 0094 
; 0000 0095 }
_0x45:
	SUBI R17,1
	RJMP _0x3B
_0x3C:
; 0000 0096 if (x != D) {
	CP   R19,R18
	BREQ _0x46
; 0000 0097 return 0;
	LDI  R30,LOW(0)
	JMP  _0x2060001
; 0000 0098 }
; 0000 0099 D^= 0x0F;
_0x46:
	LDI  R30,LOW(15)
	EOR  R19,R30
; 0000 009A 
; 0000 009B }
	SUBI R16,-1
	RJMP _0x30
_0x31:
; 0000 009C VCC = 0;
	CBI  0x15,4
; 0000 009D return 1;
	LDI  R30,LOW(1)
	JMP  _0x2060001
; 0000 009E }
; .FEND
;unsigned char ic74155()
; 0000 00A2 {
_ic74155:
; .FSTART _ic74155
; 0000 00A3 
; 0000 00A4 signed char j,i;
; 0000 00A5 
; 0000 00A6 DDRA = 0x70;
	RCALL SUBOPT_0x8
;	j -> R17
;	i -> R16
; 0000 00A7 DDRB = 0x00;
; 0000 00A8 DDRC = 0x0f0;
; 0000 00A9 DDRD = 0x80;
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x9
; 0000 00AA PORTA = 0;
; 0000 00AB PORTC = 0;
; 0000 00AC PORTD = 0x04;
; 0000 00AD PORTB = 0;
; 0000 00AE GND = 0;
; 0000 00AF VCC = 1;
; 0000 00B0 PORTA.5 = 1; PORTC.6 = 1; //enables
; 0000 00B1 
; 0000 00B2 
; 0000 00B3 for (i = 0;i <= 3;i++)
_0x52:
	CPI  R16,4
	BRGE _0x53
; 0000 00B4 {
; 0000 00B5 PORTA.6 =Read_BIT(i,1);
	RCALL SUBOPT_0xA
	BRNE _0x54
	CBI  0x1B,6
	RJMP _0x55
_0x54:
	SBI  0x1B,6
_0x55:
; 0000 00B6 PORTC.7 =Read_BIT(i,0);
	SBRC R16,0
	RJMP _0x56
	CBI  0x15,7
	RJMP _0x57
_0x56:
	SBI  0x15,7
_0x57:
; 0000 00B7 
; 0000 00B8 for (j = 0; j <= 1;j++)
	LDI  R17,LOW(0)
_0x59:
	CPI  R17,2
	BRGE _0x5A
; 0000 00B9 {
; 0000 00BA PORTA.4 = j;
	CPI  R17,0
	BRNE _0x5B
	CBI  0x1B,4
	RJMP _0x5C
_0x5B:
	SBI  0x1B,4
_0x5C:
; 0000 00BB PORTC.5 = !j;
	CPI  R17,0
	BREQ _0x5D
	CBI  0x15,5
	RJMP _0x5E
_0x5D:
	SBI  0x15,5
_0x5E:
; 0000 00BC PORTA.5 = 0;
	CBI  0x1B,5
; 0000 00BD PORTC.6 = 0;
	CBI  0x15,6
; 0000 00BE 
; 0000 00BF delay_ms(30);
	RCALL SUBOPT_0xB
; 0000 00C0 if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=(j<<i) ) return 0;
	RCALL SUBOPT_0xC
	BREQ _0x63
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 00C1 delay_ms(30);
_0x63:
	RCALL SUBOPT_0xD
; 0000 00C2 if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=(j<<i) ) return 0;
	RCALL SUBOPT_0xC
	BREQ _0x64
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 00C3 PORTA.5 = 1;
_0x64:
	SBI  0x1B,5
; 0000 00C4 PORTC.5 = 1;
	SBI  0x15,5
; 0000 00C5 }
	SUBI R17,-1
	RJMP _0x59
_0x5A:
; 0000 00C6 delay_ms(30);
	RCALL SUBOPT_0xB
; 0000 00C7 if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=0 ) return 0;
	BREQ _0x69
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 00C8 delay_ms(30);
_0x69:
	RCALL SUBOPT_0xD
; 0000 00C9 if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=0 ) return 0;
	BREQ _0x6A
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 00CA }
_0x6A:
	SUBI R16,-1
	RJMP _0x52
_0x53:
; 0000 00CB 
; 0000 00CC 
; 0000 00CD VCC = 0;
	RJMP _0x2060004
; 0000 00CE return 1;
; 0000 00CF }
; .FEND
;unsigned char ic74156()
; 0000 00D2 {
_ic74156:
; .FSTART _ic74156
; 0000 00D3 
; 0000 00D4 signed char j,i;
; 0000 00D5 DDRA = 0x70;
	RCALL SUBOPT_0x8
;	j -> R17
;	i -> R16
; 0000 00D6 DDRB = 0x00;
; 0000 00D7 DDRC = 0x0F0;
; 0000 00D8 DDRD = 0x82;
	LDI  R30,LOW(130)
	RCALL SUBOPT_0x9
; 0000 00D9 PORTA = 0;
; 0000 00DA PORTC = 0;
; 0000 00DB PORTD = 0x04;
; 0000 00DC PORTB = 0;
; 0000 00DD GND = 0;
; 0000 00DE VCC = 1;
; 0000 00DF PORTA.5 = 1; PORTC.6 = 1;  //enables
; 0000 00E0 // input 1001
; 0000 00E1 
; 0000 00E2 for (i = 0;i <= 3;i++)
_0x76:
	CPI  R16,4
	BRGE _0x77
; 0000 00E3 {
; 0000 00E4 PORTA.6 =Read_BIT(i,1);
	RCALL SUBOPT_0xA
	BRNE _0x78
	CBI  0x1B,6
	RJMP _0x79
_0x78:
	SBI  0x1B,6
_0x79:
; 0000 00E5 PORTC.7 =Read_BIT(i,0);
	SBRC R16,0
	RJMP _0x7A
	CBI  0x15,7
	RJMP _0x7B
_0x7A:
	SBI  0x15,7
_0x7B:
; 0000 00E6 
; 0000 00E7 for (j = 0; j <= 1;j++)
	LDI  R17,LOW(0)
_0x7D:
	CPI  R17,2
	BRGE _0x7E
; 0000 00E8 {
; 0000 00E9 PORTA.4 = j;
	CPI  R17,0
	BRNE _0x7F
	CBI  0x1B,4
	RJMP _0x80
_0x7F:
	SBI  0x1B,4
_0x80:
; 0000 00EA PORTC.5 = !j;
	CPI  R17,0
	BREQ _0x81
	CBI  0x15,5
	RJMP _0x82
_0x81:
	SBI  0x15,5
_0x82:
; 0000 00EB PORTA.5 = 0;
	CBI  0x1B,5
; 0000 00EC PORTC.6 = 0;
	CBI  0x15,6
; 0000 00ED 
; 0000 00EE //loadmodeon;
; 0000 00EF PORTA = PORTA | 0x80;
	RCALL SUBOPT_0xE
; 0000 00F0 PORTD = PORTD | 0x70;
; 0000 00F1 PORTB = PORTB | 0x0f;
; 0000 00F2 delay_ms(30);
; 0000 00F3 //PINA.3=1;PINA.4=1;PINA.5=1;PINA.6=1;  PINC.4=1;PINC.5=1;PINC.6=1;PINC.7=1;
; 0000 00F4 
; 0000 00F5 if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=(j<<i) ) return 0;
	RCALL SUBOPT_0xC
	BREQ _0x87
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 00F6 delay_ms(30);
_0x87:
	RCALL SUBOPT_0xD
; 0000 00F7 if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=(j<<i) ) return 0;
	RCALL SUBOPT_0xC
	BREQ _0x88
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 00F8 
; 0000 00F9 //PINA.3=0;PINA.4=0;PINA.5=0;PINA.6=0;  PINC.4=0;PINC.5=0;PINC.6=0;PINC.7=0;
; 0000 00FA PORTA &= 0x7F;
_0x88:
	RCALL SUBOPT_0xF
; 0000 00FB PORTD &= 0x8F;
; 0000 00FC PORTB &= 0xF0;
; 0000 00FD 
; 0000 00FE delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00FF 
; 0000 0100 //PORTA.3=0;PORTA.4=0;PORTA.5=0;PORTA.6=0;  PORTC.4=0;PORTC.5=0;PORTC.6=0;PORTC.7=0;
; 0000 0101 //if (PINA.3 == 1) led = 1;
; 0000 0102 
; 0000 0103 
; 0000 0104 //if (((PINA.3<<3)+(PINA.4<<2)+(PINA.5<<1)+(PINA.6))!=0 ) return 0;
; 0000 0105 //if (((PINC.4<<3)+(PINC.5<<2)+(PINC.6<<1)+(PINC.7))!=0 ) return 0;
; 0000 0106 //LOADMODEOFF;*/
; 0000 0107 PORTA.5 = 1;
	SBI  0x1B,5
; 0000 0108 PORTC.6 = 1;
	SBI  0x15,6
; 0000 0109 }
	SUBI R17,-1
	RJMP _0x7D
_0x7E:
; 0000 010A //loadmodeon;
; 0000 010B //PORTA.3=1;PORTA.4=1;PORTA.5=1;PORTA.6=1;  PORTC.4=1;PORTC.5=1;PORTC.6=1;PORTC.7=1;
; 0000 010C PORTA = PORTA | 0x80;
	RCALL SUBOPT_0xE
; 0000 010D PORTD = PORTD | 0x70;
; 0000 010E PORTB = PORTB | 0x0f;
; 0000 010F delay_ms(30);
; 0000 0110 if (((!PINA.7<<3)+ (!PIND.4<<2)+ (!PIND.5<<1)+(!PIND.6))!=0 ) return 0;
	BREQ _0x8D
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 0111 delay_ms(30);
_0x8D:
	RCALL SUBOPT_0xD
; 0000 0112 if (((!PINB.0<<3)+ (!PINB.1<<2)+ (!PINB.2<<1)+(!PINB.3))!=0 ) return 0;
	BREQ _0x8E
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 0113 
; 0000 0114 
; 0000 0115 PORTA &= 0x7F;
_0x8E:
	RCALL SUBOPT_0xF
; 0000 0116 PORTD &= 0x8F;
; 0000 0117 PORTB &= 0xF0;
; 0000 0118 //PORTA.3=0;PORTA.4=0;PORTA.5=0;PORTA.6=0;  PORTC.4=0;PORTC.5=0;PORTC.6=0;PORTC.7=0;
; 0000 0119 
; 0000 011A //if (((PINA.3<<3)+(PINA.4<<2)+(PINA.5<<1)+(PINA.6))!=0) return 0;
; 0000 011B //if (((PINC.4<<3)+(PINC.5<<2)+(PINC.6<<1)+(PINC.7))!=0 ) return 0;
; 0000 011C // LOADMODEOFF;
; 0000 011D }
	SUBI R16,-1
	RJMP _0x76
_0x77:
; 0000 011E 
; 0000 011F VCC = 0;
	RJMP _0x2060004
; 0000 0120 return 1;
; 0000 0121 }
; .FEND
;unsigned char ic74157()
; 0000 0125 {
_ic74157:
; .FSTART _ic74157
; 0000 0126 signed char i;
; 0000 0127 unsigned char D = 0x05 ;
; 0000 0128 PORTA = 0;
	RCALL SUBOPT_0x10
;	i -> R17
;	D -> R16
; 0000 0129 PORTC = 0;
; 0000 012A PORTD = 0x04;
; 0000 012B PORTB = 0;
; 0000 012C DDRA = 0x70;
; 0000 012D PORTA = 0;
; 0000 012E DDRC = 0xF0;
; 0000 012F PORTC = 0;
; 0000 0130 DDRD &=0x0F;
	RCALL SUBOPT_0x11
; 0000 0131 DDRD |= 0xB0;
; 0000 0132 PORTD &= 0x0F;
; 0000 0133 DDRB = 0X06;
; 0000 0134 PORTB = 0;
; 0000 0135 GND = 0;
; 0000 0136 VCC = 1;
; 0000 0137 PORTC.5 = 1;  //enables
	RCALL SUBOPT_0x12
; 0000 0138 PORTA.5=0;PORTA.6=0;PORTD.4=0; PORTD.5=0;PORTC.6=0;PORTC.7=0;PORTB.1=0; PORTB.2=0;
; 0000 0139 PORTA.4=0;
; 0000 013A // input 0101
; 0000 013B for (i = 0;i <= 1;i++)
_0xAA:
	CPI  R17,2
	BRGE _0xAB
; 0000 013C {
; 0000 013D PORTC.6 =Read_BIT(D,3); PORTB.1 =Read_BIT(D,2);PORTD.4 =Read_BIT(D,1);PORTA.5 =Read_BIT(D,0);
	RCALL SUBOPT_0x13
	BRNE _0xAC
	CBI  0x15,6
	RJMP _0xAD
_0xAC:
	SBI  0x15,6
_0xAD:
	RCALL SUBOPT_0x14
	BRNE _0xAE
	CBI  0x18,1
	RJMP _0xAF
_0xAE:
	SBI  0x18,1
_0xAF:
	RCALL SUBOPT_0x15
	BRNE _0xB0
	CBI  0x12,4
	RJMP _0xB1
_0xB0:
	SBI  0x12,4
_0xB1:
	SBRC R16,0
	RJMP _0xB2
	CBI  0x1B,5
	RJMP _0xB3
_0xB2:
	SBI  0x1B,5
_0xB3:
; 0000 013E PORTC.5 = 0;
	RCALL SUBOPT_0x16
; 0000 013F delay_ms(30);
; 0000 0140 if (((PINB.0<<3)+ ( PINB.3<<2) + (PIND.6<<1) + (PINA.7)) != D )
	BREQ _0xB6
; 0000 0141 return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 0142 PORTC.5 = 1;
_0xB6:
	RCALL SUBOPT_0x7
; 0000 0143 delay_ms(30);
; 0000 0144 if ((PINB.0!=0) & (PINB.3!=0) & (PIND.6 !=0) & (PINA.7!=0))
	RCALL SUBOPT_0x17
	BREQ _0xB9
; 0000 0145 return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 0146 D^= 0x0F;
_0xB9:
	LDI  R30,LOW(15)
	EOR  R16,R30
; 0000 0147 }
	SUBI R17,-1
	RJMP _0xAA
_0xAB:
; 0000 0148 D = 0x05 ;
	RCALL SUBOPT_0x18
; 0000 0149 PORTA.5=0;PORTA.6=0;PORTD.4=0; PORTD.5=0;PORTC.6=0;PORTC.7=0;PORTB.1=0; PORTB.2=0;
; 0000 014A PORTA.4=1;
; 0000 014B // input 0101
; 0000 014C for (i = 0;i <= 1;i++)
_0xCD:
	CPI  R17,2
	BRGE _0xCE
; 0000 014D {
; 0000 014E PORTC.7 =Read_BIT(D,3); PORTB.2 =Read_BIT(D,2);PORTD.5 =Read_BIT(D,1);PORTA.6 =Read_BIT(D,0);
	RCALL SUBOPT_0x13
	BRNE _0xCF
	CBI  0x15,7
	RJMP _0xD0
_0xCF:
	SBI  0x15,7
_0xD0:
	RCALL SUBOPT_0x14
	BRNE _0xD1
	CBI  0x18,2
	RJMP _0xD2
_0xD1:
	SBI  0x18,2
_0xD2:
	RCALL SUBOPT_0x15
	BRNE _0xD3
	CBI  0x12,5
	RJMP _0xD4
_0xD3:
	SBI  0x12,5
_0xD4:
	SBRC R16,0
	RJMP _0xD5
	CBI  0x1B,6
	RJMP _0xD6
_0xD5:
	SBI  0x1B,6
_0xD6:
; 0000 014F PORTC.5 = 0;
	RCALL SUBOPT_0x16
; 0000 0150 delay_ms(30);
; 0000 0151 if (((PINB.0<<3)+ ( PINB.3<<2) + (PIND.6<<1) + (PINA.7)) != D )
	BREQ _0xD9
; 0000 0152 return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 0153 PORTC.5 = 1;
_0xD9:
	RCALL SUBOPT_0x7
; 0000 0154 delay_ms(30);
; 0000 0155 if ((PINB.0!=0) & (PINB.3!=0) & (PIND.6 !=0) & (PINA.7!=0))
	RCALL SUBOPT_0x17
	BREQ _0xDC
; 0000 0156 return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 0157 D^= 0x0F;
_0xDC:
	LDI  R30,LOW(15)
	EOR  R16,R30
; 0000 0158 }
	SUBI R17,-1
	RJMP _0xCD
_0xCE:
; 0000 0159 VCC = 0;
	RJMP _0x2060004
; 0000 015A return 1;
; 0000 015B }
; .FEND
;unsigned char ic74158()
; 0000 015E {
_ic74158:
; .FSTART _ic74158
; 0000 015F signed char i;
; 0000 0160 unsigned char D = 0x05 ;
; 0000 0161 PORTA = 0;
	RCALL SUBOPT_0x10
;	i -> R17
;	D -> R16
; 0000 0162 PORTC = 0;
; 0000 0163 PORTD = 0x04;
; 0000 0164 PORTB = 0;
; 0000 0165 DDRA = 0x70;
; 0000 0166 PORTA = 0;
; 0000 0167 DDRC = 0xF0;
; 0000 0168 PORTC = 0;
; 0000 0169 DDRD &=0x0F;
	RCALL SUBOPT_0x11
; 0000 016A DDRD |= 0xB0;
; 0000 016B PORTD &= 0x0F;
; 0000 016C DDRB = 0X06;
; 0000 016D PORTB = 0;
; 0000 016E GND = 0;
; 0000 016F VCC = 1;
; 0000 0170 PORTC.5 = 1;  //enables
	RCALL SUBOPT_0x12
; 0000 0171 PORTA.5=0;PORTA.6=0;PORTD.4=0; PORTD.5=0;PORTC.6=0;PORTC.7=0;PORTB.1=0; PORTB.2=0;
; 0000 0172 PORTA.4=0;
; 0000 0173 // input 0101
; 0000 0174 for (i = 0;i <= 1;i++)
_0xF8:
	CPI  R17,2
	BRGE _0xF9
; 0000 0175 {
; 0000 0176 PORTC.6 =Read_BIT(D,3); PORTB.1 =Read_BIT(D,2);PORTD.4 =Read_BIT(D,1);PORTA.5 =Read_BIT(D,0);
	RCALL SUBOPT_0x13
	BRNE _0xFA
	CBI  0x15,6
	RJMP _0xFB
_0xFA:
	SBI  0x15,6
_0xFB:
	RCALL SUBOPT_0x14
	BRNE _0xFC
	CBI  0x18,1
	RJMP _0xFD
_0xFC:
	SBI  0x18,1
_0xFD:
	RCALL SUBOPT_0x15
	BRNE _0xFE
	CBI  0x12,4
	RJMP _0xFF
_0xFE:
	SBI  0x12,4
_0xFF:
	SBRC R16,0
	RJMP _0x100
	CBI  0x1B,5
	RJMP _0x101
_0x100:
	SBI  0x1B,5
_0x101:
; 0000 0177 PORTC.5 = 0;
	RCALL SUBOPT_0x19
; 0000 0178 delay_ms(30);
; 0000 0179 if (((!PINB.0<<3)+ ( !PINB.3<<2) + (!PIND.6<<1) + (!PINA.7)) != D )
	BREQ _0x104
; 0000 017A return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 017B PORTC.5 = 1;
_0x104:
	RCALL SUBOPT_0x7
; 0000 017C delay_ms(30);
; 0000 017D if ((!PINB.0!=0) & (!PINB.3!=0) & (!PIND.6 !=0) & (!PINA.7!=0))
	RCALL SUBOPT_0x1A
	BREQ _0x107
; 0000 017E return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 017F D^= 0x0F;
_0x107:
	LDI  R30,LOW(15)
	EOR  R16,R30
; 0000 0180 }
	SUBI R17,-1
	RJMP _0xF8
_0xF9:
; 0000 0181 D = 0x05 ;
	RCALL SUBOPT_0x18
; 0000 0182 PORTA.5=0;PORTA.6=0;PORTD.4=0; PORTD.5=0;PORTC.6=0;PORTC.7=0;PORTB.1=0; PORTB.2=0;
; 0000 0183 PORTA.4=1;
; 0000 0184 // input 0101
; 0000 0185 for (i = 0;i <= 1;i++)
_0x11B:
	CPI  R17,2
	BRGE _0x11C
; 0000 0186 {
; 0000 0187 PORTC.7 =Read_BIT(D,3); PORTB.2 =Read_BIT(D,2);PORTD.5 =Read_BIT(D,1);PORTA.6 =Read_BIT(D,0);
	RCALL SUBOPT_0x13
	BRNE _0x11D
	CBI  0x15,7
	RJMP _0x11E
_0x11D:
	SBI  0x15,7
_0x11E:
	RCALL SUBOPT_0x14
	BRNE _0x11F
	CBI  0x18,2
	RJMP _0x120
_0x11F:
	SBI  0x18,2
_0x120:
	RCALL SUBOPT_0x15
	BRNE _0x121
	CBI  0x12,5
	RJMP _0x122
_0x121:
	SBI  0x12,5
_0x122:
	SBRC R16,0
	RJMP _0x123
	CBI  0x1B,6
	RJMP _0x124
_0x123:
	SBI  0x1B,6
_0x124:
; 0000 0188 PORTC.5 = 0;
	RCALL SUBOPT_0x19
; 0000 0189 delay_ms(30);
; 0000 018A if (((!PINB.0<<3)+ ( !PINB.3<<2) + (!PIND.6<<1) + (!PINA.7)) != D )
	BREQ _0x127
; 0000 018B return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 018C PORTC.5 = 1;
_0x127:
	RCALL SUBOPT_0x7
; 0000 018D delay_ms(30);
; 0000 018E if ((!PINB.0!=0) & (!PINB.3!=0) & (!PIND.6 !=0) & (!PINA.7!=0))
	RCALL SUBOPT_0x1A
	BREQ _0x12A
; 0000 018F return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060003
; 0000 0190 D^= 0x0F;
_0x12A:
	LDI  R30,LOW(15)
	EOR  R16,R30
; 0000 0191 }
	SUBI R17,-1
	RJMP _0x11B
_0x11C:
; 0000 0192 VCC = 0;
_0x2060004:
	CBI  0x15,4
; 0000 0193 return 1;
	LDI  R30,LOW(1)
_0x2060003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0194 }
; .FEND
;unsigned char ic74154()
; 0000 0197 {
_ic74154:
; .FSTART _ic74154
; 0000 0198 
; 0000 0199 signed char j,i;
; 0000 019A unsigned char D = 0xFE,x,y,y2 ;
; 0000 019B 
; 0000 019C DDRA = 0x00;
	RCALL __SAVELOCR6
;	j -> R17
;	i -> R16
;	D -> R19
;	x -> R18
;	y -> R21
;	y2 -> R20
	LDI  R19,254
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 019D PORTA = 0;
	OUT  0x1B,R30
; 0000 019E DDRC = 0x7F;
	LDI  R30,LOW(127)
	OUT  0x14,R30
; 0000 019F PORTC = 0;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01A0 DDRB = 0x00;
	OUT  0x17,R30
; 0000 01A1 PORTB = 0;
	OUT  0x18,R30
; 0000 01A2 DDRD = 0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 01A3 PORTD &=0x0F;
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
; 0000 01A4 GND = 0;
	CBI  0x1B,7
; 0000 01A5 VCC2 = 1;
	SBI  0x15,0
; 0000 01A6 PORTC.5 = 0; PORTC.6 = 0;  //enables
	CBI  0x15,5
	CBI  0x15,6
; 0000 01A7 
; 0000 01A8 x = 1;
	LDI  R18,LOW(1)
; 0000 01A9 for (i = 0 ; i <= 15 ;i++)
	LDI  R16,LOW(0)
_0x136:
	CPI  R16,16
	BRLT PC+2
	RJMP _0x137
; 0000 01AA {
; 0000 01AB if (i == 7 ) {
	CPI  R16,7
	BRNE _0x138
; 0000 01AC x = 1;
	LDI  R18,LOW(1)
; 0000 01AD continue;
	RJMP _0x135
; 0000 01AE }
; 0000 01AF 
; 0000 01B0 PORTC.4 =Read_BIT(i,3);PORTC.3 =Read_BIT(i,2);PORTC.2 =Read_BIT(i,1);PORTC.1 =Read_BIT(i,0);
_0x138:
	MOV  R30,R16
	ANDI R30,LOW(0x8)
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RCALL __ASRW3
	CPI  R30,0
	BRNE _0x139
	CBI  0x15,4
	RJMP _0x13A
_0x139:
	SBI  0x15,4
_0x13A:
	MOV  R30,R16
	ANDI R30,LOW(0x4)
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RCALL __ASRW2
	CPI  R30,0
	BRNE _0x13B
	CBI  0x15,3
	RJMP _0x13C
_0x13B:
	SBI  0x15,3
_0x13C:
	RCALL SUBOPT_0xA
	BRNE _0x13D
	CBI  0x15,2
	RJMP _0x13E
_0x13D:
	SBI  0x15,2
_0x13E:
	SBRC R16,0
	RJMP _0x13F
	CBI  0x15,1
	RJMP _0x140
_0x13F:
	SBI  0x15,1
_0x140:
; 0000 01B1 delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01B2 y = (!PINA.7<<7 )+(!PINA.6<<6 )+(!PINA.5<<5 )+(!PINA.4<<4 )+(!PINA.3<<3 )+(!PINA.2<<2)+(!PINA.1<<1)+!PINA.0;
	LDI  R26,0
	SBIS 0x19,7
	LDI  R26,1
	RCALL SUBOPT_0x1B
	LDI  R26,0
	SBIS 0x19,6
	LDI  R26,1
	RCALL SUBOPT_0x1C
	LDI  R26,0
	SBIS 0x19,5
	LDI  R26,1
	RCALL SUBOPT_0x1D
	LDI  R26,0
	SBIS 0x19,4
	LDI  R26,1
	RCALL SUBOPT_0x1E
	LDI  R26,0
	SBIS 0x19,3
	LDI  R26,1
	RCALL SUBOPT_0x1F
	LDI  R26,0
	SBIS 0x19,2
	LDI  R26,1
	RCALL SUBOPT_0x20
	LDI  R26,0
	SBIS 0x19,1
	LDI  R26,1
	RCALL SUBOPT_0x21
	LDI  R30,0
	SBIS 0x19,0
	LDI  R30,1
	ADD  R30,R26
	MOV  R21,R30
; 0000 01B3 y2 = (!PINC.7<<7 )+(!PINB.0<<6 )+(!PINB.1<<5 )+(!PINB.2<<4 )+(!PINB.3<<3 )+(!PIND.6<<2 )+(!PIND.5<<1 )+(!PIND.4);
	LDI  R26,0
	SBIS 0x13,7
	LDI  R26,1
	RCALL SUBOPT_0x1B
	LDI  R26,0
	SBIS 0x16,0
	LDI  R26,1
	RCALL SUBOPT_0x1C
	LDI  R26,0
	SBIS 0x16,1
	LDI  R26,1
	RCALL SUBOPT_0x1D
	LDI  R26,0
	SBIS 0x16,2
	LDI  R26,1
	RCALL SUBOPT_0x1E
	LDI  R26,0
	SBIS 0x16,3
	LDI  R26,1
	RCALL SUBOPT_0x1F
	LDI  R26,0
	SBIS 0x10,6
	LDI  R26,1
	RCALL SUBOPT_0x20
	LDI  R26,0
	SBIS 0x10,5
	LDI  R26,1
	RCALL SUBOPT_0x21
	LDI  R30,0
	SBIS 0x10,4
	LDI  R30,1
	ADD  R30,R26
	MOV  R20,R30
; 0000 01B4 
; 0000 01B5 
; 0000 01B6 if(y==x&& i< 8)
	CP   R18,R21
	BRNE _0x142
	CPI  R16,8
	BRLT _0x143
_0x142:
	RJMP _0x141
_0x143:
; 0000 01B7 {
; 0000 01B8 //x= rotateLeft(x, 1);
; 0000 01B9 x = x * 2;
	LSL  R18
; 0000 01BA continue;
	RJMP _0x135
; 0000 01BB }
; 0000 01BC 
; 0000 01BD else if (y2 == x)
_0x141:
	CP   R18,R20
	BRNE _0x145
; 0000 01BE {
; 0000 01BF x = (1<<i-7);
	MOV  R30,R16
	SUBI R30,LOW(7)
	LDI  R26,LOW(1)
	RCALL __LSLB12
	MOV  R18,R30
; 0000 01C0 continue;
	RJMP _0x135
; 0000 01C1 }
; 0000 01C2 else
_0x145:
; 0000 01C3 {
; 0000 01C4 return 0;
	LDI  R30,LOW(0)
	RJMP _0x2060002
; 0000 01C5 }
; 0000 01C6 
; 0000 01C7 }
_0x135:
	SUBI R16,-1
	RJMP _0x136
_0x137:
; 0000 01C8 VCC2 = 0;
	CBI  0x15,0
; 0000 01C9 return 1;
	LDI  R30,LOW(1)
_0x2060002:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; 0000 01CA 
; 0000 01CB }
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
; .FEND
_puts:
; .FSTART _puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000003:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000005
	MOV  R26,R17
	RCALL _putchar
	RJMP _0x2000003
_0x2000005:
	LDI  R26,LOW(10)
	RCALL _putchar
_0x2060001:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	OUT  0x1A,R30
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	LDI  R30,LOW(240)
	OUT  0x14,R30
	LDI  R30,LOW(0)
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	OUT  0x17,R30
	LDI  R30,LOW(0)
	OUT  0x18,R30
	CBI  0x1B,7
	SBI  0x15,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	MOV  R30,R19
	ANDI R30,LOW(0x8)
	LDI  R31,0
	RCALL __ASRW3
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	MOV  R30,R19
	ANDI R30,LOW(0x4)
	LDI  R31,0
	RCALL __ASRW2
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	MOV  R30,R19
	ANDI R30,LOW(0x2)
	LDI  R31,0
	ASR  R31
	ROR  R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	ANDI R30,LOW(0x2)
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ASR  R31
	ROR  R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay_ms
	MOV  R30,R18
	LSL  R30
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	SBI  0x15,5
	LDI  R26,LOW(30)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(112)
	OUT  0x1A,R30
	LDI  R30,LOW(0)
	OUT  0x17,R30
	LDI  R30,LOW(240)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x9:
	OUT  0x11,R30
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	OUT  0x15,R30
	LDI  R30,LOW(4)
	OUT  0x12,R30
	LDI  R30,LOW(0)
	OUT  0x18,R30
	CBI  0x1B,7
	SBI  0x15,4
	SBI  0x1B,5
	SBI  0x15,6
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	MOV  R30,R16
	ANDI R30,LOW(0x2)
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ASR  R31
	ROR  R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,0
	SBIS 0x19,7
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDI  R26,0
	SBIS 0x10,4
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIS 0x10,5
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	MOV  R26,R0
	ADD  R26,R30
	LDI  R30,0
	SBIS 0x10,6
	LDI  R30,1
	ADD  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0xC:
	MOV  R22,R30
	MOV  R26,R17
	LDI  R27,0
	SBRC R26,7
	SER  R27
	MOV  R30,R16
	RCALL __LSLW12
	MOV  R26,R22
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,0
	SBIS 0x16,0
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDI  R26,0
	SBIS 0x16,1
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIS 0x16,2
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	MOV  R26,R0
	ADD  R26,R30
	LDI  R30,0
	SBIS 0x16,3
	LDI  R30,1
	ADD  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	SBI  0x1B,7
	IN   R30,0x12
	ORI  R30,LOW(0x70)
	OUT  0x12,R30
	IN   R30,0x18
	ORI  R30,LOW(0xF)
	OUT  0x18,R30
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	CBI  0x1B,7
	IN   R30,0x12
	ANDI R30,LOW(0x8F)
	OUT  0x12,R30
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x10:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R16,5
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	OUT  0x15,R30
	LDI  R30,LOW(4)
	OUT  0x12,R30
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(112)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x11:
	IN   R30,0x11
	ANDI R30,LOW(0xF)
	OUT  0x11,R30
	IN   R30,0x11
	ORI  R30,LOW(0xB0)
	OUT  0x11,R30
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OUT  0x12,R30
	LDI  R30,LOW(6)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	SBI  0x15,5
	CBI  0x1B,5
	CBI  0x1B,6
	CBI  0x12,4
	CBI  0x12,5
	CBI  0x15,6
	CBI  0x15,7
	CBI  0x18,1
	CBI  0x18,2
	CBI  0x1B,4
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x13:
	MOV  R30,R16
	ANDI R30,LOW(0x8)
	LDI  R31,0
	RCALL __ASRW3
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x14:
	MOV  R30,R16
	ANDI R30,LOW(0x4)
	LDI  R31,0
	RCALL __ASRW2
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	MOV  R30,R16
	ANDI R30,LOW(0x2)
	LDI  R31,0
	ASR  R31
	ROR  R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x16:
	CBI  0x15,5
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x16,3
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	MOV  R26,R0
	ADD  R26,R30
	LDI  R30,0
	SBIC 0x19,7
	LDI  R30,1
	ADD  R26,R30
	MOV  R30,R16
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x17:
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	LDI  R30,LOW(0)
	__NEB12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x16,3
	LDI  R26,1
	LDI  R30,LOW(0)
	__NEB12
	AND  R0,R30
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	LDI  R30,LOW(0)
	__NEB12
	AND  R0,R30
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	LDI  R30,LOW(0)
	__NEB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x18:
	LDI  R16,LOW(5)
	CBI  0x1B,5
	CBI  0x1B,6
	CBI  0x12,4
	CBI  0x12,5
	CBI  0x15,6
	CBI  0x15,7
	CBI  0x18,1
	CBI  0x18,2
	SBI  0x1B,4
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x19:
	CBI  0x15,5
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,0
	SBIS 0x16,0
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDI  R26,0
	SBIS 0x16,3
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIS 0x10,6
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	MOV  R26,R0
	ADD  R26,R30
	LDI  R30,0
	SBIS 0x19,7
	LDI  R30,1
	ADD  R26,R30
	MOV  R30,R16
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1A:
	LDI  R26,0
	SBIS 0x16,0
	LDI  R26,1
	LDI  R30,LOW(0)
	__NEB12
	MOV  R0,R30
	LDI  R26,0
	SBIS 0x16,3
	LDI  R26,1
	LDI  R30,LOW(0)
	__NEB12
	AND  R0,R30
	LDI  R26,0
	SBIS 0x10,6
	LDI  R26,1
	LDI  R30,LOW(0)
	__NEB12
	AND  R0,R30
	LDI  R26,0
	SBIS 0x19,7
	LDI  R26,1
	LDI  R30,LOW(0)
	__NEB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	MOV  R30,R26
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ADD  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ADD  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	ADD  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	MOV  R30,R26
	LSL  R30
	LSL  R30
	ADD  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	MOV  R30,R26
	LSL  R30
	MOV  R26,R0
	ADD  R26,R30
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	LDI  R30,8
	MOV  R1,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12S8:
	CP   R0,R1
	BRLO __LSLW12L
	MOV  R31,R30
	LDI  R30,0
	SUB  R0,R1
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
