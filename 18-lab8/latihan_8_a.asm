.include "m8515def.inc"

; Define register
.def temp = r16
.def timer = r17
.def speed = r18

; Interruption
.org $00
rjmp MAIN
.org $01
rjmp RESET_LED
.org $02
rjmp SPEED_CHANGE
.org $07
rjmp OVERFLOW

; Main Program
MAIN:
    ; Set stack pointer
    ldi temp, low(RAMEND)
    out SPL, temp
    ldi temp, high(RAMEND)
    out SPH, temp

; Initiate the interruption for int0 and int1
INIT_INT:
    ldi temp, 0b00001010
    out MCUCR, temp
    ldi temp, 0b11000000
    out GICR, temp

    ; Enable global interruption
    sei

; Initiate LED on PORT B
INIT_IO:
    ser temp
    out DDRB, temp

; Initiate Timer0
INIT_TIMER:
    ; Set timer speed to CLK/256
	ldi r16, (1<<CS02)
	out TCCR0, r16

	; Execute an internal interrupt when Timer0 overflows
	ldi r16, (1<<TOV0)
	out TIFR, r16

    ; Enable Timer0 Overflow Interruption
	ldi r16, (1<<TOIE0)
	out TIMSK, r16

; Waiting for the next interruption
FOREVERLOOP:
    rjmp FOREVERLOOP

; Reset the LED back to 0
RESET_LED:
    ldi temp, 0
    out PORTB, temp
    reti

; Change the speed of timer
SPEED_CHANGE:
    ; Check the timer speed
    cpi speed, 1
    ; Jump to SPEED_SLOW if already fast (speed = 0)
    brne SPEED_SLOW

    ; Clear speed register to identify as fast timer
    ldi speed, 0
    ; Set timer speed to CLK/256
    ldi temp, (1<<CS02)
    out TCCR0, temp
    reti

; Slow the timer
SPEED_SLOW:
    ; Set speed register to identify as slow timer
    inc speed
    ; Set timer speed to CLK/1024
    ldi temp, (1<<CS02) | (1<<CS00)
    out TCCR0, temp
    reti

; Check if timer is overflow
OVERFLOW:
    ; Save the temp and SREG
    push temp
    in temp, SREG
    push temp

    ; Load the value of LED
    in temp, PORTB
    ; Check if all LED is in active state
    cpi temp, $FF
    breq CLEAR_LED

    ; Increment the value
    inc temp
    rjmp SET_LED

; Set all LED to inactive state
CLEAR_LED:
    ldi temp, 0

; Set the LED and exit interrupt
SET_LED:
    ; Set all the LED based on the temp value
    out PORTB, temp

    ; Set back the SREG and temp value
    pop temp
    out SREG, temp
    pop temp
    reti
