.data
	namaIn:		.asciiz "Siapa nama anda? "
	tahunIn:	.asciiz "\nTahun angkatan berapa? "
	semIn:		.asciiz "Semester berapa Anda? "
	
	ang2020:	.asciiz "Chronos"
	ang2021:	.asciiz "Bakung"
	ang2022:	.asciiz "Apollo"
	ang2023:	.asciiz "Gaung"

	namaPrint:	.asciiz "Halo namasiswa dengan nama "
	tahunPrint:	.asciiz " dari angkatan "
	semPrint:	.asciiz ". Semoga Anda dapat menjalani semester ke-"
	lastPrint:	.asciiz " di Fasilkom dengan baik!"
	
	namaOut:	.space 10

.text
.globl main
main:
	# Variable
	addi	$t2, $t2, 2020
	addi	$t3, $t3, 2021
	addi	$t4, $t4, 2022
	addi	$t5, $t5, 2023
	
	# I/O: Nama
	li	$v0, 4			# Set syscall instruction to print str
	la	$a0, namaIn		# Set a0 with string for print
	syscall
	
	li	$v0, 8			# Set syscall instruction to ask input str
	la	$a0, namaOut		# Set string input to string
	li	$a1, 11			# Set length of string to 10 (11-1)
	syscall
	
	# IO: Tahun
	li	$v0, 4
	la	$a0, tahunIn
	syscall
	
	li	$v0, 5
	syscall
	add	$t1, $t1, $v0
	
	# IO: Semester
	li	$v0, 4
	la	$a0, semIn
	syscall
	
	li	$v0, 5
	syscall
	add	$t0, $t0, $v0
	
print1First:
	# Output1
	li	$v0, 4
	la	$a0, namaPrint
	syscall
	
	# Nama
	la	$a0, namaOut
	syscall
	
	# Output2
	la	$a0, tahunPrint
	syscall
	
	# Jump to check angkatan
	j	checkAng

checkAng:
	beq	$t1, $t2, printAng2020
	beq	$t1, $t3, printAng2021
	beq	$t1, $t4, printAng2022
	beq	$t1, $t5, printAng2023
	
printAng2020:
	li	$v0, 4
	la	$a0, ang2020
	syscall
	j	printLast
	
printAng2021:
	li	$v0, 4
	la	$a0, ang2021
	syscall
	j	printLast
	
printAng2022:
	li	$v0, 4
	la	$a0, ang2022
	syscall
	j	printLast
	
printAng2023:
	li	$v0, 4
	la	$a0, ang2023
	syscall
	j	printLast

printLast:
	la	$a0, semPrint
	syscall
	
	# Semester
	li	$v0, 1
	addi	$a0, $t0, 0
	syscall
	
	# Output4
	li	$v0, 4
	la	$a0, lastPrint
	syscall
	
	# End program
	li	$v0, 10
	syscall
