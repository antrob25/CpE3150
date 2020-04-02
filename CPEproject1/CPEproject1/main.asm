;
; CPEproject1.asm
;
; Created: 2020-03-30 14:16:05
; Author : Sithija Gunasinghe, Anthony Robles, Dan Napierkowski, Cade Johnstone
;


LDI R16, 0
LDI R17, 0xFF
LDI R18, 0x1F
LDI R19, 0
SBI DDRE,4	;makes PE4 an output
CBI PORTE,4	;clears bit PE4
CBI DDRE,5	;makes PE5 an input
SBI PORTE,5	;set bit PE5
SBI DDRE,6	;makes PE6 an input
SBI PORTE,6	;set bit PE6
CBI DDRA,0	;makes PA0 an input
CBI DDRA,1	;makes PA1 an input
SBI PORTA,0	;set bit PA0
SBI PORTA,1	;set bit PA1
OUT DDRA,R16
OUT PORTA,R17
OUT DDRD,R17	;Sets PortD as output
OUT PORTD,R17	
OUT PORTC,R16	;PORTC = 0

//INPUT
START:	
	CHECK_SW1:
		SBIC PINA,0 // positive button
		INC R19 	;increments R19 when positive button is pressed
		CP R19, R18	
		BRSH RESET1	;calls Reset if R19 is greater than or equal to R18
BACK1:	CALL OUTPUT_DISPLAY	
		RCALL CLEAR	;calls clear to clear all relevant status registers
		RJMP CHECK_SW2

	CHECK_SW2:
		SBIC PINA,1 //negative button
		DEC R19		;decrements R19 when negative button is pressed
		BRLT RESET2	;calls Reset if R19 is less than 0
		RCALL CLEAR	;calls clear to clear all relevant status registers
BACK2:	CALL OUTPUT_DISPLAY	
		RJMP START	;jumps to the beginning of the input loop

RESET1:	
		LDI R19, 0	;sets R19 to 0
		RCALL BEEP
		RJMP BACK1
RESET2:
		LDI R19, 0x1F
		RCALL BEEP
		RJMP BACK2
BEEP:	LDI R22, 100
	L2:	SBI PORTE, 4 // Sound loop ;sets PE4 to high--starts sound
		RCALL DELAY 	
		NOP
		NOP
		CBI PORTE, 4	;clears PE4 -- ends sound
		RCALL DELAY
		DEC R22		
		BRNE L2		;Loops until R22 = 0 
		RET

CLEAR:	CLH	
		CLC
		CLS
		CLN
		CLZ
		RET

DELAY:	LDI R20,10 // 500 microsecond delay for 1kHz frequency  
	L3:	LDI R21,199
	L1: NOP
		DEC R21
		BRNE L1
		DEC R20
		BRNE L3
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RET

OUTPUT_DISPLAY:
	SBRC R19, 0
	CBI PORTE,5
	SBRS R19, 0
	SBI PORTE,5

	SBRC R19, 1
	CBI PORTD,3
	SBRS R19, 1
	SBI PORTD,3

	SBRC R19, 2
	CBI PORTD,2
	SBRS R19, 2
	SBI PORTD,2

	SBRC R19, 3
	CBI PORTD,1
	SBRS R19, 3
	SBI PORTD,1

	SBRC R19, 4
	CBI PORTD,0
	SBRS R19, 4
	SBI PORTD,0

	RET


