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
CBI PORTE,6	;set bit PE6
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
		BRSH RESET	;calls Reset if R19 is greater than or equal to R18
		OUT PORTD, R19	
		RCALL CLEAR	;calls clear to clear all relevant status registers
		RJMP CHECK_SW2

	CHECK_SW2:
		SBIC PINA,1 //negative button
		DEC R19		;decrements R19 when negative button is pressed
		BRLT RESET	;calls Reset if R19 is less than 0
		OUT PORTD, R19
		RCALL CLEAR	;calls clear to clear all relevant status registers
		RJMP CHECK_SW3	;jumps to the beginning of the input loop

	CHECK_SW3:
		SBIC PINA, 2
		RCALL WATCH_TIMER
		OUT PORTD, R31
		RJMP START

RESET:	CPSE R19, R18
		LDI R19, 0x1F	;if R19 is not equal to R18 sets R19 to 0x1F --what is this for?
		LDI R19, 0	;sets R19 to 0
		LDI R22, 100	;value to loop sound 100 times
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

WATCH_TIMER: // Stop Watch function
	LDI R31,0
	CHECK_SW4:
		CALL DELAY
		INC R31
		SBIC PINA, 3
		RJMP CHECK_SW4
		RET
	

		

			
			
		


