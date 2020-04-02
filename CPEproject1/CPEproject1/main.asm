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
CBI DDRA,0	;makes PA0 an input
CBI DDRA,1	;makes PA1 an input
SBI PORTA,0	;set bit PA0
SBI PORTA,1	;set bit PA1
OUT DDRA,R16
OUT PORTA,R17
OUT DDRD,R17	;Sets PortD as output
OUT PORTD,R16	
OUT PORTC,R16	;PORTC = 0

//INPUT
START:	
	CHECK_SW1:
		SBIC PINA,0 // positive button
		INC R19 	;increments R19 when positive button is pressed
		CP R19, R18	
		BRSH RESET1	;calls Reset if R19 is greater than or equal to R18
BACK1:	OUT PORTD, R19
		RCALL CLEAR	;calls clear to clear all relevant status registers
		RJMP CHECK_SW2

	CHECK_SW2:
		SBIC PINA,1 //negative button
		DEC R19		;decrements R19 when negative button is pressed
		BRLT RESET2	;calls Reset if R19 is less than 0
		RCALL CLEAR	;calls clear to clear all relevant status registers
BACK2:	OUT PORTD, R19
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

