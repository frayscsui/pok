.data
	namaIn:		.asciiz "Siapa nama anda? "
	semIn:		.asciiz "\nSemester berapakah Anda? "
	
	namaPrint:	.asciiz "Halo namasiswa dengan nama "
	semPrint:	.asciiz ". Semoga Anda dapat menjalani semester ke-"
	lastPrint:	.asciiz " di Fasilkom dengan baik!"
	
	namaOut:	.space 10

.text
.globl main
main:
	# I/O: Nama
	li	$v0, 4			# Set syscall instruction to print str
	la	$a0, namaIn		# Set a0 with string for print
	syscall
	
	li	$v0, 8			# Set syscall instruction to ask input str
	la	$a0, namaOut		# Set string input to string
	li	$a1, 11			# Set length of string to 10 (11-1)
	syscall
	
	# IO: Semester
	li	$v0, 4
	la	$a0, semIn
	syscall
	
	li	$v0, 5
	syscall
	add	$t0, $t0, $v0
	
	# Print output
	# Output1
	li	$v0, 4
	la	$a0, namaPrint
	syscall
	
	# Nama
	la	$a0, namaOut
	syscall
	
	# Output2
	la	$a0, semPrint
	syscall
	
	# Semester
	li	$v0, 1
	addi	$a0, $t0, 0
	syscall
	
	# Output1
	li	$v0, 4
	la	$a0, lastPrint
	syscall
	
	# End program
	li	$v0, 10
	syscall
