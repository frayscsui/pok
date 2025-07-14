.data
	StrKolom1:	.asciiz "Kolom Matriks Pertama: "
	StrBaris1:	.asciiz "Baris Matriks Pertama: "
	StrKolom2:	.asciiz "Kolom Matriks Kedua: "
	StrBaris2:	.asciiz "Baris Matriks Kedua: "
	Matriks:	.asciiz "Matriks: \n"
	Beda:		.asciiz "Yahh, matriks memiliki ordo beda D:"
	Sama:		.asciiz "Yeyy matriks memiliki ordo sama :DD"
	Barrier:	.asciiz "|"
	Space:	.asciiz " "
	Enter:	.asciiz "\n"
	NextLine:	.asciiz "|\n"
	Baris1:	.word 1, 2, 3, 4
	Kolom1:	.word 2, 3, 4, 5
	Baris2:	.word 3, 4, 5, 6
	Kolom2:	.word 4, 5, 6, 7
	Matriks1:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	Matriks2:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# Temporary/Saved Registers Uses

# $s0 - 8 bit ordo matriks 1
# $S1 - 8 bit ordo matriks 2
# $s2 - Matriks

# $t0 - Loop i
# $t1 - Loop j
# $t2 - Value baris & hasil kali baris x kolom
# $t3 - Value kolom
# $t4
# $t5 - Constant[4] | Address
# $t6 - Ukuran kolom matriks
# $t7 - Ukuran baris matriks
# $t8 - Baris matriks 1/2
# $t9 - Kolom matriks 1/2


.text
.globl FirstMatrix
FirstMatrix:
	### MATRIX 1
	# Ask user the size of the matrix 1
	li	$v0, 4
	la	$a0, StrKolom1
	syscall
	li	$v0, 5
	syscall

	# Add to $t6
	add	$t6, $zero, $v0

	li	$v0, 4
	la	$a0, StrBaris1
	syscall
	li	$v0, 5
	syscall

	# Add to $t7
	add	$t7, $zero, $v0

	# Simpan ordo matriks 1
	add 	$s0, $zero, $t6
	sll	$s0, $s0, 4
	add	$s0, $s0, $t7

	## LOOP
	# Multply all baris & kolom by 4 for branch
	addi	$t5, $zero, 4
	mult	$t6, $t5
	mflo	$t6
	mult	$t7, $t5
	mflo	$t7

	# Load the matriks
	la	$s2, Matriks1
	la	$t8, Baris1
	la	$t9, Kolom1
	# Initiate the first loop
	addi	$t0, $zero, 0

	# Print string
	li	$v0, 4
	la	$a0, Matriks
	syscall

FirstOutterLoop:
	# Print string
	li	$v0, 4
	la	$a0, Barrier
	syscall
	la	$a0, Space
	syscall
	# Increment loop counter
	addi	$t0, $t0, 4
	# Reset counter
	addi	$t1, $zero, 0

FirstInnerLoop:
	# Increment loop counter (2nd)
	addi	$t1, $t1, 4

	# Load Baris1 value
	add	$t5, $t8, $t0
	lw	$t2, -4($t5)

	# Load Kolom1 value
	add	$t5, $t9, $t1
	lw	$t3, -4($t5)

	# Multiply the values
	mult	$t2, $t3
	mflo	$t2

	# Load the value inside array
	addi	$s2, $s2, 4
	# Load the value
	sw	$t2, -4($s2)

	# Print the integer
	li	$v0, 1
	add	$a0, $zero, $t2
	syscall
	li	$v0, 4
	la	$a0, Space
	syscall

	# Check if exceed 4
	bne	$t1, $t6, FirstInnerLoop

FirstLoopCheck:
	# Print string
	li	$v0, 4
	la	$a0, NextLine
	syscall
	# Back to loop if not the same
	bne	$t0, $t7, FirstOutterLoop



SecondMatrix:
	### MATRIX 2
	# Ask user the size of the matrix 1
	li	$v0, 4
	la	$a0, StrKolom2
	syscall
	li	$v0, 5
	syscall

	# Add to $t6
	add	$t6, $zero, $v0

	li	$v0, 4
	la	$a0, StrBaris2
	syscall
	li	$v0, 5
	syscall

	# Add to $t7
	add	$t7, $zero, $v0

	# Simpan ordo matriks 1
	add 	$s1, $zero, $t6
	sll	$s1, $s1, 4
	add	$s1, $s1, $t7

	## LOOP
	# Multply all baris & kolom by 4 for branch
	addi	$t5, $zero, 4
	mult	$t6, $t5
	mflo	$t6
	mult	$t7, $t5
	mflo	$t7

	# Load the matriks
	la	$s2, Matriks2
	la	$t8, Baris2
	la	$t9, Kolom2
	# Initiate the first loop
	addi	$t0, $zero, 0

	# Print string
	li	$v0, 4
	la	$a0, Matriks
	syscall

SecondOutterLoop:
	# Print string
	li	$v0, 4
	la	$a0, Barrier
	syscall
	la	$a0, Space
	syscall
	# Increment loop counter
	addi	$t0, $t0, 4
	# Reset counter
	addi	$t1, $zero, 0

SecondInnerLoop:
	# Increment loop counter (2nd)
	addi	$t1, $t1, 4

	# Load Baris1 value
	add	$t5, $t8, $t0
	lw	$t2, -4($t5)

	# Load Kolom1 value
	add	$t5, $t9, $t1
	lw	$t3, -4($t5)

	# Multiply the values
	mult	$t2, $t3
	mflo	$t2

	# Load the value inside array
	addi	$s2, $s2, 4
	# Load the value
	sw	$t2, -4($s2)

	# Print the integer
	li	$v0, 1
	add	$a0, $zero, $t2
	syscall
	li	$v0, 4
	la	$a0, Space
	syscall

	# Check if exceed 4
	bne	$t1, $t6, SecondInnerLoop

SecondLoopCheck:
	# Print string
	li	$v0, 4
	la	$a0, NextLine
	syscall
	# Back to loop if not the same
	bne	$t0, $t7, SecondOutterLoop



CheckOrdo:
	li	$v0, 4
	beq	$s0, $s1, OrdoSama

OrdeBeda:
	la	$a0, Beda
	syscall
	j	ExitProgram

OrdoSama:
	la	$a0, Sama
	syscall

ExitProgram:
	li	$v0, 10
	syscall
