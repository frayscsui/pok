; include header of ATmega8515
.include "m8515def.inc"

; Mendefinisi register
.def result = r1
.def number = r23
.def modulo = r24
.def temp = r25

; Menyimpan data pengetesan
DATA:
	.db 13

; Program
PROGRAM:
	ldi ZL, LOW(DATA*2)		; Mengambil memory address ke dalam ZL
	ldi ZH, HIGH(DATA*2)	; Mengambil memory address ke dalam ZH
	lpm number, Z			; Mengambil nilai dari address Z ke register "number"
	ldi modulo, 1			; Menetapkan nilai module = 1

LOOP_OUT:
	adiw modulo, 1			; Menambahkan nilai module dengan +1 sebagai counter
	cp number, modulo		; Melakukan perbandingan nilai "number" dengan "modulo"
	breq IS_PRIME			; Pindah ke label "IS_PRIME" jika nilainya sama (number = PRIMA)
	ldi temp, 0				; Menetapkan nilai temporary = 0
	add temp, number		; Tambahkan nilai temp dengan number sebagai perhitungan

LOOP_IN:
	cp temp, modulo			; Melakukan komparasi "temp" dengan "modulo"
	breq NOT_PRIME			; Cek ketika nilai temp sama dengan modulo 
	brlt LOOP_OUT			; Keluar ke LOOP_OUT ketika "temp" kurang dari "modulo"
	sub temp, modulo        ; Mengurangi nilai temp dengan modulo
	rjmp LOOP_IN            ; Balik ke LOOP_IN

IS_PRIME:
	ldi temp, 1             ; Menetapkan nilai temp dengan 1 sebagai nilai hasil
	rjmp MOV_RESULT         ; Pindah ke label MOV_RESULT

NOT_PRIME:
	ldi temp, 0             ; Menetapkan nilai temp dengan 0 sebagai nilai hasil
	rjmp MOV_RESULT         ; Pindah ke label MOV_RESULT

MOV_RESULT:
	mov result, temp        ; Memindahkan nilainya ke register "result"
	rjmp EXIT               ; Keluar program

EXIT:
	rjmp EXIT
