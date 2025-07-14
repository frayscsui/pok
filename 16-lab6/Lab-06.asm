.include "m8515def.inc"

; Inisiasi variable/register
.def temp = r19
.def n_hasil = r0
.def n_min_1 = r16
.def n_min_2 = r17
.def n = r4
.def hasil = r16

.def TIGA = r10
.def DUA = r9
.def SATU = r8

; Data
DATA:
.db 2

; Main program
init:
    ; Memastikan stack pointer berada di addr $025F
    ldi temp, low(RAMEND)
    out SPL, temp
    ldi temp, high(RAMEND)
    out SPH, temp

    ; Mengambil data dari program memory
    ldi ZL, low(DATA)
    ldi ZH, high(DATA)
    lpm n, Z

    ; Menyimpan konstant
    ldi temp, 1
    mov SATU, temp
    ldi temp, 2
    mov DUA, temp
    ldi temp, 3
    mov TIGA, temp

    ; Menyimpan memory asal
    ldi ZL, $90
    ldi ZH, $00

    ; Pangil barisan
    rcall barisan
    rjmp forever

barisan:
    ; Menyimpan hasil kedalam stack
    push n
    push n_min_1
    push n_min_2
    push n_hasil

    ; Cek ketika n == 0
    tst n
    breq n_nol

    ; Cek ketika n == 1
    cp n, SATU
    brbs 1, n_satu

    ; Pengurangan(?)
    mov n_min_2, n
    subi n_min_2, 2
    mov n_min_1, n
    dec n_min_1

    ; Rekursif: P(n-2)
    mov n, n_min_2
    rcall barisan
    mul hasil, TIGA
    mov temp, n_hasil

    ; Rekursif: P(n-1)
    mov n, n_min_1
    rcall barisan
    mul hasil, DUA
    add hasil, n_hasil
    add hasil, temp

    ; Simpan hasil kedalam memory
    pop n_hasil
    pop n_min_2
    pop n_min_1
    pop n
    add ZL, n
    st Z, hasil
    ret

n_nol:
    ldi hasil, 1
    rjmp done

n_satu:
    ldi hasil, 2

done:
    pop n_hasil
    pop n_min_2
    pop n_min_1
    pop n
    ret

forever:
    rjmp forever
