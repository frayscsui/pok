; Menambahkan header ATmega8515
.include "m8515def.inc"

; Mendefinisikan beberapa register
.def result  = R1	; Hasil pembagian (floor division)
.def value1  = R18	; Angka yang akan dibagi
.def value2  = R19	; Angka pembagi
.def temp    = R24	; Temporary, digunakan untuk menghitung pembagian

; Menyimpan data ke memory
MY_DATA:
.db 32, 5

; Program
Main:
	ldi ZL, LOW(MY_DATA*2)	; Mengambil memory address kedalam ZL
	ldi ZH, HIGH(MY_DATA*2)	; Mengambil memory address kedalam ZH
	lpm value1, Z+			; Mengambil nilai dari pointer Z dan increment by 1
	lpm value2, Z			; Mengambil nilai dari pointer Z+1

Loop:
	cp value1, value2		; Melakukan komparasi value1 dan value2
	brlt Stop				; Pindah ke "Stop" jika value1 < value2
	sub value1, value2		; Mengurangi nilai value1 dengan value2
	adiw temp, 1			; Menambahkan counter temp sebanyak 1 sebagai hasil bagi
	rjmp Loop				; Balik lagi ke label "Loop"

Stop:
	mov result, temp		; Pindahkan hasilnya dari temporary ke result

Forever:
	rjmp Forever			; Loop selamanya

; RESULT = 6
