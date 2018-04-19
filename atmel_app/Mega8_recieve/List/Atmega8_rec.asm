
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _n=R4
	.DEF _symb=R7
	.DEF _N1=R8
	.DEF _Status=R10
	.DEF _Command=R12
	.DEF _rx_wr_index=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x1

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;const int t=1;// Time (in ms) between on/off all_out

	.DSEG
;int n;
;char symb; int N1;
;int Status;
;int Command;
;int NumPort;
;int dNumPort;
;
;char buf[6]; int i;
;int m[16];
;
;#define Y1 PORTD.3
;#define Y2 PORTD.4
;#define Y3 PORTB.6
;#define Y4 PORTC.5
;#define Y5 PORTC.4
;#define Y6 PORTC.3
;#define Y7 PORTC.2
;#define Y8 PORTC.0
;#define Y9 PORTB.2
;#define Y10 PORTB.1
;#define Y11 PORTB.0
;#define Y12 PORTD.7
;#define Y13 PORTD.6
;#define Y14 PORTD.5
;#define Y15 PORTB.7
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0050 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0051 char status,data;
; 0000 0052 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0053 data=UDR;
	IN   R16,12
; 0000 0054 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BREQ PC+2
	RJMP _0x4
; 0000 0055    {
; 0000 0056    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0057 #if RX_BUFFER_SIZE == 256
; 0000 0058    // special case for receiver buffer size=256
; 0000 0059    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 005A #else
; 0000 005B    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x5
	CLR  R6
; 0000 005C    if (++rx_counter == RX_BUFFER_SIZE)
_0x5:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BREQ PC+2
	RJMP _0x6
; 0000 005D       {
; 0000 005E       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 005F       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0060       }
; 0000 0061 #endif
; 0000 0062    }
_0x6:
; 0000 0063 }
_0x4:
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006A {
_getchar:
; 0000 006B char data;
; 0000 006C while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x7:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ PC+2
	RJMP _0x9
	RJMP _0x7
_0x9:
; 0000 006D data=rx_buffer[rx_rd_index++];
	LDS  R30,_rx_rd_index
	SUBI R30,-LOW(1)
	STS  _rx_rd_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 006E #if RX_BUFFER_SIZE != 256
; 0000 006F if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDS  R26,_rx_rd_index
	CPI  R26,LOW(0x8)
	BREQ PC+2
	RJMP _0xA
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0000 0070 #endif
; 0000 0071 #asm("cli")
_0xA:
	cli
; 0000 0072 --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0000 0073 #asm("sei")
	sei
; 0000 0074 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0075 }
;#pragma used-
;#endif
;
;// Write a character to the USART Transmitter
;#ifndef _DEBUG_TERMINAL_IO_
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 007E {
_putchar:
; 0000 007F while ((UCSRA & DATA_REGISTER_EMPTY)==0);
	ST   -Y,R26
;	c -> Y+0
_0xB:
	SBIC 0xB,5
	RJMP _0xD
	RJMP _0xB
_0xD:
; 0000 0080 UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0081 }
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;void All_OnOff()
; 0000 008A    {
_All_OnOff:
; 0000 008B     Y1=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0xE
	CBI  0x12,3
	RJMP _0xF
_0xE:
	SBI  0x12,3
_0xF:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 008C     Y2=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x10
	CBI  0x12,4
	RJMP _0x11
_0x10:
	SBI  0x12,4
_0x11:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 008D     Y3=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x12
	CBI  0x18,6
	RJMP _0x13
_0x12:
	SBI  0x18,6
_0x13:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 008E     Y4=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x14
	CBI  0x15,5
	RJMP _0x15
_0x14:
	SBI  0x15,5
_0x15:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 008F     Y5=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x16
	CBI  0x15,4
	RJMP _0x17
_0x16:
	SBI  0x15,4
_0x17:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0090     Y6=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x18
	CBI  0x15,3
	RJMP _0x19
_0x18:
	SBI  0x15,3
_0x19:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0091     Y7=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x1A
	CBI  0x15,2
	RJMP _0x1B
_0x1A:
	SBI  0x15,2
_0x1B:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0092     Y8=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x1C
	CBI  0x15,0
	RJMP _0x1D
_0x1C:
	SBI  0x15,0
_0x1D:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0093     Y9=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x1E
	CBI  0x18,2
	RJMP _0x1F
_0x1E:
	SBI  0x18,2
_0x1F:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0094     Y10=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x20
	CBI  0x18,1
	RJMP _0x21
_0x20:
	SBI  0x18,1
_0x21:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0095     Y11=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x22
	CBI  0x18,0
	RJMP _0x23
_0x22:
	SBI  0x18,0
_0x23:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0096     Y12=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x24
	CBI  0x12,7
	RJMP _0x25
_0x24:
	SBI  0x12,7
_0x25:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0097     Y13=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x26
	CBI  0x12,6
	RJMP _0x27
_0x26:
	SBI  0x12,6
_0x27:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0098     Y14=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x28
	CBI  0x12,5
	RJMP _0x29
_0x28:
	SBI  0x12,5
_0x29:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 0099     Y15=Status; delay_ms(t);
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x2A
	CBI  0x18,7
	RJMP _0x2B
_0x2A:
	SBI  0x18,7
_0x2B:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	RCALL _delay_ms
; 0000 009A    /* if (!Status)
; 0000 009B     {
; 0000 009C      int i=1;
; 0000 009D      for (i=1;i<16;++i)
; 0000 009E      {
; 0000 009F        m[i]=0;
; 0000 00A0      }
; 0000 00A1     }*/
; 0000 00A2    }
	RET
;
; void Safe_OnOff()
; 0000 00A5    {
_Safe_OnOff:
; 0000 00A6    int t=10;
; 0000 00A7    if (m[1]==1) {Y1=Status; delay_ms(t);}
	RCALL __SAVELOCR2
;	t -> R16,R17
	__GETWRN 16,17,10
	__GETW1MN _m,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2C
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x2D
	CBI  0x12,3
	RJMP _0x2E
_0x2D:
	SBI  0x12,3
_0x2E:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00A8    if (m[2]==1) {Y2=Status; delay_ms(t);}
_0x2C:
	__GETW1MN _m,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2F
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x30
	CBI  0x12,4
	RJMP _0x31
_0x30:
	SBI  0x12,4
_0x31:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00A9    if (m[3]==1) {Y3=Status; delay_ms(t);}
_0x2F:
	__GETW1MN _m,6
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x32
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x33
	CBI  0x18,6
	RJMP _0x34
_0x33:
	SBI  0x18,6
_0x34:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00AA    if (m[4]==1) {Y4=Status; delay_ms(t);}
_0x32:
	__GETW1MN _m,8
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x35
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x36
	CBI  0x15,5
	RJMP _0x37
_0x36:
	SBI  0x15,5
_0x37:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00AB    if (m[5]==1) {Y5=Status; delay_ms(t);}
_0x35:
	__GETW1MN _m,10
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x38
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x39
	CBI  0x15,4
	RJMP _0x3A
_0x39:
	SBI  0x15,4
_0x3A:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00AC    if (m[6]==1) {Y6=Status; delay_ms(t);}
_0x38:
	__GETW1MN _m,12
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3B
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x3C
	CBI  0x15,3
	RJMP _0x3D
_0x3C:
	SBI  0x15,3
_0x3D:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00AD    if (m[7]==1) {Y7=Status; delay_ms(t);}
_0x3B:
	__GETW1MN _m,14
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3E
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x3F
	CBI  0x15,2
	RJMP _0x40
_0x3F:
	SBI  0x15,2
_0x40:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00AE    if (m[8]==1) {Y8=Status; delay_ms(t);}
_0x3E:
	__GETW1MN _m,16
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x41
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x42
	CBI  0x15,0
	RJMP _0x43
_0x42:
	SBI  0x15,0
_0x43:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00AF    if (m[9]==1) {Y9=Status; delay_ms(t);}
_0x41:
	__GETW1MN _m,18
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x44
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x45
	CBI  0x18,2
	RJMP _0x46
_0x45:
	SBI  0x18,2
_0x46:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00B0    if (m[10]==1) {Y10=Status; delay_ms(t);}
_0x44:
	__GETW1MN _m,20
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x47
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x48
	CBI  0x18,1
	RJMP _0x49
_0x48:
	SBI  0x18,1
_0x49:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00B1    if (m[11]==1) {Y11=Status; delay_ms(t);}
_0x47:
	__GETW1MN _m,22
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x4A
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x4B
	CBI  0x18,0
	RJMP _0x4C
_0x4B:
	SBI  0x18,0
_0x4C:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00B2    if (m[12]==1) {Y12=Status; delay_ms(t);}
_0x4A:
	__GETW1MN _m,24
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x4D
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x4E
	CBI  0x12,7
	RJMP _0x4F
_0x4E:
	SBI  0x12,7
_0x4F:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00B3    if (m[13]==1) {Y13=Status; delay_ms(t);}
_0x4D:
	__GETW1MN _m,26
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x50
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x51
	CBI  0x12,6
	RJMP _0x52
_0x51:
	SBI  0x12,6
_0x52:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00B4    if (m[14]==1) {Y14=Status; delay_ms(t);}
_0x50:
	__GETW1MN _m,28
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x53
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x54
	CBI  0x12,5
	RJMP _0x55
_0x54:
	SBI  0x12,5
_0x55:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00B5    if (m[15]==1) {Y15=Status; delay_ms(t);}
_0x53:
	__GETW1MN _m,30
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x56
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x57
	CBI  0x18,7
	RJMP _0x58
_0x57:
	SBI  0x18,7
_0x58:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00B6    }
_0x56:
	RCALL __LOADLOCR2P
	RET
;
; void SetPort()
; 0000 00B9    {
_SetPort:
; 0000 00BA     if (NumPort == 1) {Y1 = Status; m[1]=Status;}
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,1
	BREQ PC+2
	RJMP _0x59
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x5A
	CBI  0x12,3
	RJMP _0x5B
_0x5A:
	SBI  0x12,3
_0x5B:
	__POINTW1MN _m,2
	ST   Z,R10
	STD  Z+1,R11
; 0000 00BB     if (NumPort == 2) {Y2 = Status; m[2]=Status;}
_0x59:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,2
	BREQ PC+2
	RJMP _0x5C
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x5D
	CBI  0x12,4
	RJMP _0x5E
_0x5D:
	SBI  0x12,4
_0x5E:
	__POINTW1MN _m,4
	ST   Z,R10
	STD  Z+1,R11
; 0000 00BC     if (NumPort == 3) {Y3 = Status; m[3]=Status;}
_0x5C:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,3
	BREQ PC+2
	RJMP _0x5F
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x60
	CBI  0x18,6
	RJMP _0x61
_0x60:
	SBI  0x18,6
_0x61:
	__POINTW1MN _m,6
	ST   Z,R10
	STD  Z+1,R11
; 0000 00BD     if (NumPort == 4) {Y4 = Status; m[4]=Status;}
_0x5F:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,4
	BREQ PC+2
	RJMP _0x62
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x63
	CBI  0x15,5
	RJMP _0x64
_0x63:
	SBI  0x15,5
_0x64:
	__POINTW1MN _m,8
	ST   Z,R10
	STD  Z+1,R11
; 0000 00BE     if (NumPort == 5) {Y5 = Status; m[5]=Status;}
_0x62:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,5
	BREQ PC+2
	RJMP _0x65
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x66
	CBI  0x15,4
	RJMP _0x67
_0x66:
	SBI  0x15,4
_0x67:
	__POINTW1MN _m,10
	ST   Z,R10
	STD  Z+1,R11
; 0000 00BF     if (NumPort == 6) {Y6 = Status; m[6]=Status;}
_0x65:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,6
	BREQ PC+2
	RJMP _0x68
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x69
	CBI  0x15,3
	RJMP _0x6A
_0x69:
	SBI  0x15,3
_0x6A:
	__POINTW1MN _m,12
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C0     if (NumPort == 7) {Y7 = Status; m[7]=Status;}
_0x68:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,7
	BREQ PC+2
	RJMP _0x6B
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x6C
	CBI  0x15,2
	RJMP _0x6D
_0x6C:
	SBI  0x15,2
_0x6D:
	__POINTW1MN _m,14
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C1     if (NumPort == 8) {Y8 = Status; m[8]=Status;}
_0x6B:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,8
	BREQ PC+2
	RJMP _0x6E
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x6F
	CBI  0x15,0
	RJMP _0x70
_0x6F:
	SBI  0x15,0
_0x70:
	__POINTW1MN _m,16
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C2     if (NumPort == 9) {Y9 = Status; m[9]=Status;}
_0x6E:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,9
	BREQ PC+2
	RJMP _0x71
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x72
	CBI  0x18,2
	RJMP _0x73
_0x72:
	SBI  0x18,2
_0x73:
	__POINTW1MN _m,18
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C3     if (NumPort == 10) {Y10 = Status; m[10]=Status;}
_0x71:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,10
	BREQ PC+2
	RJMP _0x74
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x75
	CBI  0x18,1
	RJMP _0x76
_0x75:
	SBI  0x18,1
_0x76:
	__POINTW1MN _m,20
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C4     if (NumPort == 11) {Y11 = Status; m[11]=Status;}
_0x74:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,11
	BREQ PC+2
	RJMP _0x77
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x78
	CBI  0x18,0
	RJMP _0x79
_0x78:
	SBI  0x18,0
_0x79:
	__POINTW1MN _m,22
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C5     if (NumPort == 12) {Y12 = Status; m[12]=Status;}
_0x77:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,12
	BREQ PC+2
	RJMP _0x7A
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x7B
	CBI  0x12,7
	RJMP _0x7C
_0x7B:
	SBI  0x12,7
_0x7C:
	__POINTW1MN _m,24
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C6     if (NumPort == 13) {Y13 = Status; m[13]=Status;}
_0x7A:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,13
	BREQ PC+2
	RJMP _0x7D
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x7E
	CBI  0x12,6
	RJMP _0x7F
_0x7E:
	SBI  0x12,6
_0x7F:
	__POINTW1MN _m,26
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C7     if (NumPort == 14) {Y14 = Status; m[14]=Status;}
_0x7D:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,14
	BREQ PC+2
	RJMP _0x80
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x81
	CBI  0x12,5
	RJMP _0x82
_0x81:
	SBI  0x12,5
_0x82:
	__POINTW1MN _m,28
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C8     if (NumPort == 15) {Y15 = Status; m[15]=Status;}
_0x80:
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,15
	BREQ PC+2
	RJMP _0x83
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x84
	CBI  0x18,7
	RJMP _0x85
_0x84:
	SBI  0x18,7
_0x85:
	__POINTW1MN _m,30
	ST   Z,R10
	STD  Z+1,R11
; 0000 00C9    }
_0x83:
	RET
;
; void GetMPorts()
; 0000 00CC   {
_GetMPorts:
	PUSH R15
; 0000 00CD    bit first=1;
; 0000 00CE      for (i=1; i<16; ++i)
;	first -> R15.0
	LDI  R30,LOW(1)
	MOV  R15,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _i,R30
	STS  _i+1,R31
_0x87:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,16
	BRLT PC+2
	RJMP _0x88
; 0000 00CF      {
; 0000 00D0        if (m[i]==1)
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(_m)
	LDI  R27,HIGH(_m)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x89
; 0000 00D1        {
; 0000 00D2         if (!first) putchar('_');
	SBRC R15,0
	RJMP _0x8A
	LDI  R26,LOW(95)
	RCALL _putchar
; 0000 00D3         putchar(i+48);
_0x8A:
	LDS  R26,_i
	SUBI R26,-LOW(48)
	RCALL _putchar
; 0000 00D4         first=0;
	CLT
	BLD  R15,0
; 0000 00D5        }
; 0000 00D6      }
_0x89:
_0x86:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x87
_0x88:
; 0000 00D7      putchar(0x0D);
	LDI  R26,LOW(13)
	RCALL _putchar
; 0000 00D8   }
	POP  R15
	RET
;
;  void GetYPorts()
; 0000 00DB   {
_GetYPorts:
	PUSH R15
; 0000 00DC    bit first=1;
; 0000 00DD    int ys[16];
; 0000 00DE 
; 0000 00DF    if (Y1) ys[1] = 1;
	SBIW R28,32
;	first -> R15.0
;	ys -> Y+0
	LDI  R30,LOW(1)
	MOV  R15,R30
	SBIS 0x12,3
	RJMP _0x8B
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00E0    if (Y2) ys[2] = 1;
_0x8B:
	SBIS 0x12,4
	RJMP _0x8C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00E1    if (Y3) ys[3] = 1;
_0x8C:
	SBIS 0x18,6
	RJMP _0x8D
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00E2    if (Y4) ys[4] = 1;
_0x8D:
	SBIS 0x15,5
	RJMP _0x8E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 00E3    if (Y5) ys[5] = 1;
_0x8E:
	SBIS 0x15,4
	RJMP _0x8F
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 00E4    if (Y6) ys[6] = 1;
_0x8F:
	SBIS 0x15,3
	RJMP _0x90
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 00E5    if (Y7) ys[7] = 1;
_0x90:
	SBIS 0x15,2
	RJMP _0x91
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 00E6    if (Y8) ys[8] = 1;
_0x91:
	SBIS 0x15,0
	RJMP _0x92
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 00E7    if (Y9) ys[9] = 1;
_0x92:
	SBIS 0x18,2
	RJMP _0x93
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 00E8    if (Y10) ys[10] = 1;
_0x93:
	SBIS 0x18,1
	RJMP _0x94
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 00E9    if (Y11) ys[11] = 1;
_0x94:
	SBIS 0x18,0
	RJMP _0x95
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0000 00EA    if (Y12) ys[12] = 1;
_0x95:
	SBIS 0x12,7
	RJMP _0x96
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+24,R30
	STD  Y+24+1,R31
; 0000 00EB    if (Y13) ys[13] = 1;
_0x96:
	SBIS 0x12,6
	RJMP _0x97
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+26,R30
	STD  Y+26+1,R31
; 0000 00EC    if (Y14) ys[14] = 1;
_0x97:
	SBIS 0x12,5
	RJMP _0x98
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+28,R30
	STD  Y+28+1,R31
; 0000 00ED    if (Y15) ys[15] = 1;
_0x98:
	SBIS 0x18,7
	RJMP _0x99
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+30,R30
	STD  Y+30+1,R31
; 0000 00EE 
; 0000 00EF    for (i=1; i<16; ++i)
_0x99:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _i,R30
	STS  _i+1,R31
_0x9B:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,16
	BRLT PC+2
	RJMP _0x9C
; 0000 00F0      {
; 0000 00F1        if (ys[i]==1)
	LDS  R30,_i
	LDS  R31,_i+1
	MOVW R26,R28
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x9D
; 0000 00F2        {
; 0000 00F3         if (!first) putchar('_');
	SBRC R15,0
	RJMP _0x9E
	LDI  R26,LOW(95)
	RCALL _putchar
; 0000 00F4         putchar(i+48);
_0x9E:
	LDS  R26,_i
	SUBI R26,-LOW(48)
	RCALL _putchar
; 0000 00F5         first=0;
	CLT
	BLD  R15,0
; 0000 00F6        }
; 0000 00F7      }
_0x9D:
_0x9A:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x9B
_0x9C:
; 0000 00F8 
; 0000 00F9    putchar(0x0D);
	LDI  R26,LOW(13)
	RCALL _putchar
; 0000 00FA   }
	ADIW R28,32
	POP  R15
	RET
;
;void main(void)
; 0000 00FD {
_main:
; 0000 00FE // Declare your local variables here
; 0000 00FF 
; 0000 0100 // Input/Output Ports initialization
; 0000 0101 // Port B initialization
; 0000 0102 // Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
; 0000 0103 // State7=0 State6=0 State5=T State4=T State3=T State2=0 State1=0 State0=0
; 0000 0104 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0105 DDRB=0xC7;
	LDI  R30,LOW(199)
	OUT  0x17,R30
; 0000 0106 
; 0000 0107 // Port C initialization
; 0000 0108 // Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0109 // State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 010A PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 010B DDRC=0x7F;
	LDI  R30,LOW(127)
	OUT  0x14,R30
; 0000 010C 
; 0000 010D // Port D initialization
; 0000 010E // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=Out
; 0000 010F // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=0
; 0000 0110 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0111 DDRD=0xFB;
	LDI  R30,LOW(251)
	OUT  0x11,R30
; 0000 0112 
; 0000 0113 // Timer/Counter 0 initialization
; 0000 0114 // Clock source: System Clock
; 0000 0115 // Clock value: Timer 0 Stopped
; 0000 0116 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0117 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0118 
; 0000 0119 // Timer/Counter 1 initialization
; 0000 011A // Clock source: System Clock
; 0000 011B // Clock value: Timer1 Stopped
; 0000 011C // Mode: Normal top=0xFFFF
; 0000 011D // OC1A output: Discon.
; 0000 011E // OC1B output: Discon.
; 0000 011F // Noise Canceler: Off
; 0000 0120 // Input Capture on Falling Edge
; 0000 0121 // Timer1 Overflow Interrupt: Off
; 0000 0122 // Input Capture Interrupt: Off
; 0000 0123 // Compare A Match Interrupt: Off
; 0000 0124 // Compare B Match Interrupt: Off
; 0000 0125 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0126 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0127 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0128 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0129 ICR1H=0x00;
	OUT  0x27,R30
; 0000 012A ICR1L=0x00;
	OUT  0x26,R30
; 0000 012B OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 012C OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 012D OCR1BH=0x00;
	OUT  0x29,R30
; 0000 012E OCR1BL=0x00;
	OUT  0x28,R30
; 0000 012F 
; 0000 0130 // Timer/Counter 2 initialization
; 0000 0131 // Clock source: System Clock
; 0000 0132 // Clock value: Timer2 Stopped
; 0000 0133 // Mode: Normal top=0xFF
; 0000 0134 // OC2 output: Disconnected
; 0000 0135 ASSR=0x00;
	OUT  0x22,R30
; 0000 0136 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0137 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0138 OCR2=0x00;
	OUT  0x23,R30
; 0000 0139 
; 0000 013A // External Interrupt(s) initialization
; 0000 013B // INT0: Off
; 0000 013C // INT1: Off
; 0000 013D MCUCR=0x00;
	OUT  0x35,R30
; 0000 013E 
; 0000 013F // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0140 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0141 
; 0000 0142 // USART initialization
; 0000 0143 // Communication Parameters: 7 Data, 1 Stop, Even Parity
; 0000 0144 // USART Receiver: On
; 0000 0145 // USART Transmitter: On
; 0000 0146 // USART Mode: Asynchronous
; 0000 0147 // USART Baud Rate: 38400
; 0000 0148 //UCSRA=0x00;
; 0000 0149 //UCSRB=0x98;
; 0000 014A //UCSRC=0xA4;
; 0000 014B //UBRRH=0x00;
; 0000 014C //UBRRL=0x0C;
; 0000 014D //96008N1
; 0000 014E UCSRA=0x00;
	OUT  0xB,R30
; 0000 014F UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0150 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0151 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0152 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0153 
; 0000 0154 // Analog Comparator initialization
; 0000 0155 // Analog Comparator: Off
; 0000 0156 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0157 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0158 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0159 
; 0000 015A // ADC initialization
; 0000 015B // ADC disabled
; 0000 015C ADCSRA=0x00;
	OUT  0x6,R30
; 0000 015D 
; 0000 015E // SPI initialization
; 0000 015F // SPI disabled
; 0000 0160 SPCR=0x00;
	OUT  0xD,R30
; 0000 0161 
; 0000 0162 // TWI initialization
; 0000 0163 // TWI disabled
; 0000 0164 TWCR=0x00;
	OUT  0x36,R30
; 0000 0165 
; 0000 0166 // Watchdog Timer initialization
; 0000 0167 // Watchdog Timer Prescaler: OSC/2048k
; 0000 0168 #pragma optsize-
; 0000 0169 WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0000 016A WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0000 016B #ifdef _OPTIMIZE_SIZE_
; 0000 016C #pragma optsize+
; 0000 016D #endif
; 0000 016E 
; 0000 016F // Global enable interrupts
; 0000 0170 #asm("sei")
	sei
; 0000 0171 
; 0000 0172 while (1)
_0x9F:
; 0000 0173   {
; 0000 0174        #asm("wdr")
	wdr
; 0000 0175    while (rx_counter) {   //Обрабатываем принятые данные
_0xA2:
	LDS  R30,_rx_counter
	CPI  R30,0
	BRNE PC+2
	RJMP _0xA4
; 0000 0176     symb=getchar();
	RCALL _getchar
	MOV  R7,R30
; 0000 0177     putchar(symb);
	MOV  R26,R7
	RCALL _putchar
; 0000 0178     if (n<6)
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R4,R30
	CPC  R5,R31
	BRLT PC+2
	RJMP _0xA5
; 0000 0179     {
; 0000 017A      if (symb>=65 && symb<=90)
	LDI  R30,LOW(65)
	CP   R7,R30
	BRSH PC+2
	RJMP _0xA7
	LDI  R30,LOW(90)
	CP   R30,R7
	BRSH PC+2
	RJMP _0xA7
	RJMP _0xA8
_0xA7:
	RJMP _0xA6
_0xA8:
; 0000 017B      {
; 0000 017C       symb=symb+32;
	LDI  R30,LOW(32)
	ADD  R7,R30
; 0000 017D      }
; 0000 017E      buf[n]=symb;
_0xA6:
	MOVW R30,R4
	SUBI R30,LOW(-_buf)
	SBCI R31,HIGH(-_buf)
	ST   Z,R7
; 0000 017F     }
; 0000 0180     ++n;
_0xA5:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0181          #asm("wdr")
	wdr
; 0000 0182 
; 0000 0183       if (N1==3)
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0xA9
; 0000 0184       {
; 0000 0185          if (symb=='0') { Status = 0; N1=4; }
	LDI  R30,LOW(48)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xAA
	CLR  R10
	CLR  R11
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R8,R30
; 0000 0186          if (symb=='1') { Status = 1; N1=4; }
_0xAA:
	LDI  R30,LOW(49)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xAB
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R8,R30
; 0000 0187       }
_0xAB:
; 0000 0188       if (N1==2)
_0xA9:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0xAC
; 0000 0189       {
; 0000 018A          if (symb=='_') N1=3;
	LDI  R30,LOW(95)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xAD
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R8,R30
; 0000 018B          else
	RJMP _0xAE
_0xAD:
; 0000 018C          {
; 0000 018D           dNumPort = symb-48;
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,48
	STS  _dNumPort,R30
	STS  _dNumPort+1,R31
; 0000 018E           if (dNumPort >= 0 && dNumPort <= 9 )
	LDS  R26,_dNumPort+1
	TST  R26
	BRPL PC+2
	RJMP _0xB0
	LDS  R26,_dNumPort
	LDS  R27,_dNumPort+1
	SBIW R26,10
	BRLT PC+2
	RJMP _0xB0
	RJMP _0xB1
_0xB0:
	RJMP _0xAF
_0xB1:
; 0000 018F           {
; 0000 0190            NumPort = NumPort*10 + dNumPort;
	LDS  R30,_NumPort
	LDS  R31,_NumPort+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	LDS  R26,_dNumPort
	LDS  R27,_dNumPort+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _NumPort,R30
	STS  _NumPort+1,R31
; 0000 0191            N1=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R8,R30
; 0000 0192           }
; 0000 0193          }
_0xAF:
_0xAE:
; 0000 0194          if (N1!=3) N1=0;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	BRNE PC+2
	RJMP _0xB2
	CLR  R8
	CLR  R9
; 0000 0195       }
_0xB2:
; 0000 0196       if (N1==1)
_0xAC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0xB3
; 0000 0197       {
; 0000 0198        if (symb=='a') { Command=1; N1=2;}
	LDI  R30,LOW(97)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xB4
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
; 0000 0199        if (symb=='s') { Command=2; N1=2;}
_0xB4:
	LDI  R30,LOW(115)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xB5
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
	MOVW R8,R30
; 0000 019A        if (!Command)
_0xB5:
	MOV  R0,R12
	OR   R0,R13
	BREQ PC+2
	RJMP _0xB6
; 0000 019B           {
; 0000 019C             NumPort = symb-48;
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,48
	STS  _NumPort,R30
	STS  _NumPort+1,R31
; 0000 019D            if (NumPort >= 0 && NumPort <= 9 ) N1=2;
	LDS  R26,_NumPort+1
	TST  R26
	BRPL PC+2
	RJMP _0xB8
	LDS  R26,_NumPort
	LDS  R27,_NumPort+1
	SBIW R26,10
	BRLT PC+2
	RJMP _0xB8
	RJMP _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
; 0000 019E            else N1=0;
	RJMP _0xBA
_0xB7:
	CLR  R8
	CLR  R9
; 0000 019F           }
_0xBA:
; 0000 01A0       }
_0xB6:
; 0000 01A1       if (N1==0 && symb=='s') N1=1;
_0xB3:
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BREQ PC+2
	RJMP _0xBC
	LDI  R30,LOW(115)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xBC
	RJMP _0xBD
_0xBC:
	RJMP _0xBB
_0xBD:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 01A2 
; 0000 01A3     if (symb==0x0D)
_0xBB:
	LDI  R30,LOW(13)
	CP   R30,R7
	BREQ PC+2
	RJMP _0xBE
; 0000 01A4     {
; 0000 01A5       if (N1==4)   //Обрабатываем команды
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0xBF
; 0000 01A6       {
; 0000 01A7         if (Command==1) All_OnOff();
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BREQ PC+2
	RJMP _0xC0
	RCALL _All_OnOff
; 0000 01A8         if (Command==2) Safe_OnOff();
_0xC0:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R12
	CPC  R31,R13
	BREQ PC+2
	RJMP _0xC1
	RCALL _Safe_OnOff
; 0000 01A9         if (!Command) SetPort();
_0xC1:
	MOV  R0,R12
	OR   R0,R13
	BREQ PC+2
	RJMP _0xC2
	RCALL _SetPort
; 0000 01AA       }
_0xC2:
; 0000 01AB 
; 0000 01AC       if (buf[0]=='g' && buf[1]=='e' && buf[2]=='t')
_0xBF:
	LDS  R26,_buf
	CPI  R26,LOW(0x67)
	BREQ PC+2
	RJMP _0xC4
	__GETB2MN _buf,1
	CPI  R26,LOW(0x65)
	BREQ PC+2
	RJMP _0xC4
	__GETB2MN _buf,2
	CPI  R26,LOW(0x74)
	BREQ PC+2
	RJMP _0xC4
	RJMP _0xC5
_0xC4:
	RJMP _0xC3
_0xC5:
; 0000 01AD       {
; 0000 01AE         if (buf[3]=='m') GetMPorts();
	__GETB2MN _buf,3
	CPI  R26,LOW(0x6D)
	BREQ PC+2
	RJMP _0xC6
	RCALL _GetMPorts
; 0000 01AF         if (buf[3]=='y') GetYPorts();
_0xC6:
	__GETB2MN _buf,3
	CPI  R26,LOW(0x79)
	BREQ PC+2
	RJMP _0xC7
	RCALL _GetYPorts
; 0000 01B0       }
_0xC7:
; 0000 01B1 
; 0000 01B2       Command = 0;
_0xC3:
	CLR  R12
	CLR  R13
; 0000 01B3       N1=0;
	CLR  R8
	CLR  R9
; 0000 01B4       n=0;
	CLR  R4
	CLR  R5
; 0000 01B5     }
; 0000 01B6 
; 0000 01B7    } //while (rx_counter) {
_0xBE:
	RJMP _0xA2
_0xA4:
; 0000 01B8   } //while(1)
	RJMP _0x9F
_0xA1:
; 0000 01B9 
; 0000 01BA }
_0xC8:
	RJMP _0xC8
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_NumPort:
	.BYTE 0x2
_dNumPort:
	.BYTE 0x2
_buf:
	.BYTE 0x6
_i:
	.BYTE 0x2
_m:
	.BYTE 0x20
_rx_buffer:
	.BYTE 0x8
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
