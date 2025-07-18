;====================================================================
; Processor		: ATmega8515
; Compiler		: AVRASM
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================

.include "m8515def.inc"
.def ready = r17
.def temp = r16 ; temporary register
.def EW = r23 ; for PORTA
.def PB = r24 ; for PORTB
.def A  = r25
.def count = r21

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

.org $00
rjmp MAIN
.org $01
rjmp ext_int0
.org $02
rjmp ext_int1

;====================================================================
; CODE SEGMENT
;====================================================================

MAIN:

INIT_STACK:
	ldi temp, low(RAMEND)
	ldi temp, high(RAMEND)
    ldi ready, 0
	out SPH, temp

INIT_INTERRUPT:
	ldi temp,0b00001010
	out MCUCR,temp
	ldi temp,0b11000000
	out GICR,temp
	sei

rjmp INIT_LCD_MAIN

ext_int0: ; Interrupt when button 0 is pressed
	rcall INPUT_TEXT ; Read message
	ldi ready, 1 ; Set ready
	reti

ext_int1: ; Interrupt when button 1 is pressed
	rcall INPUT_TEXT2 ; Read message2
	ldi ready, 1 ; Set ready
	reti

EXIT:
	rjmp EXIT

INPUT_TEXT:
	ldi ZH,high(2*message) ; Load high part of byte address into ZH
	ldi ZL,low(2*message) ; Load low part of byte address into ZL
	ret

INPUT_TEXT2:
	ldi ZH,high(2*message2) ; Load high part of byte address into ZH
	ldi ZL,low(2*message2) ; Load low part of byte address into ZL
	ret

INIT_LCD_MAIN:
	rcall INIT_LCD

	ser temp
	out DDRA,temp ; Set port A as output
	out DDRB,temp ; Set port B as output

	rcall INPUT_TEXT

LOADBYTE_PHASE1:
    tst ready ; Check if ready is set
    brne LOOP_LCD ; Back to LOOP_LCD
	lpm ; Load byte from program memory into r0

    tst r0 ; Check if we've reached the end of the message
	breq LOOP_LCD ; If so, quit
	cpi count, 10 ; Check if we've reached the end for the first line
	breq NEWLINE ; If so, change line

	mov A, r0 ; Put the character onto Port B
	rcall WRITE_TEXT
	inc count
	adiw ZL,1 ; Increase Z registers
	rjmp LOADBYTE_PHASE1

NEWLINE:
	cbi PORTA,1 ; CLR RS
	ldi PB,$C0 ; MOV DATA,0x01
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	ldi count, 0
	rcall DELAY_01

LOADBYTE_PHASE2:
    tst ready ; Check if ready is set
    brne LOOP_LCD ; Back to LOOP_LCD
	lpm ; Load byte from program memory into r0

	tst r0 ; Check if we've reached the end of the message
	breq LOOP_LCD ; If so, quit

	mov A, r0 ; Put the character onto Port B
	rcall WRITE_TEXT
	adiw ZL,1 ; Increase Z registers
	rjmp LOADBYTE_PHASE2

LOOP_LCD:
    tst ready ; Check if ready is clear
    breq LOOP_LCD ; Loop again
    ldi count, 0 ; Clear count
    ldi ready, 0 ; Clear ready
    rcall CLEAR_LCD ; Clear the LED
	rjmp LOADBYTE_PHASE1 ; Exit loop

INIT_LCD:
	cbi PORTA,1 ; CLR RS
	ldi PB,0x38 ; MOV DATA,0x38 --> 8bit, 2line, 5x7
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	rcall DELAY_01

	cbi PORTA,1 ; CLR RS
	ldi PB,$0E ; MOV DATA,0x0E --> disp ON, cursor ON, blink OFF
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	rcall DELAY_01

	rcall CLEAR_LCD ; CLEAR LCD

	cbi PORTA,1 ; CLR RS
	ldi PB,$06 ; MOV DATA,0x06 --> increase cursor, display sroll OFF
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	rcall DELAY_01
	ret

CLEAR_LCD:
	cbi PORTA,1 ; CLR RS
	ldi PB,$01 ; MOV DATA,0x01
	out PORTB,PB
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	rcall DELAY_01
	ret

WRITE_TEXT:
	sbi PORTA,1 ; SETB RS
	out PORTB, A
	sbi PORTA,0 ; SETB EN
	cbi PORTA,0 ; CLR EN
	rcall DELAY_01
	ret

;====================================================================
; DELAYS	[ Generated by delay loop calculator at	  ]
; 		    [ http://www.bretmulvey.com/avrdelay.html ]
;====================================================================

DELAY_00:				; Delay 4 000 cycles
						; 500us at 8.0 MHz	
	    ldi  r18, 6
	    ldi  r19, 49
	L0: dec  r19
	    brne L0
	    dec  r18
	    brne L0
	ret

DELAY_01:				; DELAY_CONTROL 40 000 cycles
						; 5ms at 8.0 MHz
	    ldi  r18, 52
	    ldi  r19, 242
	L1: dec  r19
	    brne L1
	    dec  r18
	    brne L1
	    nop
	ret

DELAY_02:				; Delay 160 000 cycles
						; 20ms at 8.0 MHz
	    ldi  r18, 208
	    ldi  r19, 202
	L2: dec  r19
	    brne L2
	    dec  r18
	    brne L2
	    nop
	ret

;====================================================================
; DATA
;====================================================================

message:
.db "2306227311HADIR"
message2:
.db "2024-05-09"
unused: ; This piece of .db is unused
.db 0
