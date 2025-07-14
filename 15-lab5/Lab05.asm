; include header of ATmega8515
.include "m8515def.inc"

; Mendefinisi register
.def result = r1
.def number = r23
.def modulo = r24
.def temp = r25

DATA:
	.db 13

PROGRAM:
	ldi ZL, LOW(DATA*2)
	ldi ZH, HIGH(DATA*2)
	lpm number, Z
	ldi modulo, 1

LOOP_OUT:
	adiw modulo, 1
	cp number, modulo
	breq IS_PRIME
	ldi temp, 0
	add temp, number

LOOP_IN:
	cp temp, modulo
	breq NOT_PRIME
	brlt LOOP_OUT
	sub temp, modulo
	rjmp LOOP_IN

IS_PRIME:
	ldi temp, 1
	rjmp MOV_RESULT

NOT_PRIME:
	ldi temp, 0
	rjmp MOV_RESULT

MOV_RESULT:
	mov result, temp
	rjmp EXIT

EXIT:
	rjmp EXIT
