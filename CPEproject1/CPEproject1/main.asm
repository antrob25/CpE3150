;
; CPEproject1.asm
;
; Created: 2020-03-30 14:16:05
; Author : Sithija Gunasinghe, Anthony Robles, Dan Napierkowski, Cade Johnstone
;


LDI R16, 0
LDI R17, 0xFF
LDI R18, 0x20	
SBI DDRE,4	;makes PE4 an output
CBI PORTE,4	;clears bit PE4
CBI DDRA,0	;makes PA0 an input
CBI DDRA,1	;makes PA1 an input
SBI PORTA,0	;set bit PA0
SBI PORTA,1	;set bit PA1
OUT DDRD, R17 	;Sets PortD as output
OUT PORTC, R16	;PORTC = 0

//INPUT
START:	SBIC PINA,0 // positive button
		INC R16 	;increments R16 when positive button is pressed
		CP R16, R18	
		BRSH RESET	;calls Reset if R16 is greater than or equal to R18
		OUT PORTD, R16	;refresh the binary output
		RCALL CLEAR	;calls clear to clear all relevant status registers
		SBIC PINA,1 //negative button
		DEC R16		;decrements R16 when negative button is pressed
		BRLT RESET	;calls Reset if R16 is less than 0
		RCALL CLEAR	;calls clear to clear all relevant status registers
		OUT PORTD, R16	;refresh the binary output
		RJMP START	;jumps to the beginning of the input loop

RESET:	CPSE R16, R18
		LDI R16, 0x1F	;sets value to 31 if overflowed from 0
		LDI R16, 0	;sets R16 to 0 if overflowed from 31
		LDI R21, 100	;value to loop sound 100 times
	L2:	SBI PORTE, 4 // Sound loop ;sets PE4 to high--starts sound
		RCALL DELAY 	
		NOP
		NOP
		CBI PORTE, 4	;clears PE4 -- ends sound
		RCALL DELAY
		DEC R21		
		BRNE L2		;Loops until R21 = 0 
		RET

CLEAR:	CLH	
		CLC
		CLS
		CLN
		CLZ
		RET

DELAY:	LDI R19,10 // 500 microsecond delay for 1kHz frequency
	L3:	LDI R20,199
	L1: NOP
		DEC R20
		BRNE L1
		DEC R19
		BRNE L3
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		RET


