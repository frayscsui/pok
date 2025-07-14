.data
array1:	.word	1, 2, 3, 4
array2:	.word 2, 3, 4, 5
array3:	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# Temporary register | Uses
# $t1 - Base address array1
# $t2 - Base address array2
# $t3 - Base address array3

# $t4 - Value of the array1 and array3
# $t5 - Value of the array2
# $t7 - Address

# $t8 - register counter for 1st loop
# $t9 - register counter for 2nd loop

.text
.globl Main
Main:
	# Load the array as an address
	la	$t1, array1
	la	$t2, array2
	la	$t3, array3

	# Initiate the first loop
	addi	$t8, $zero, 0

	# Initiate print
	li	$v0, 1

FirstLoop:
	# Increment loop counter
	addi	$t8, $t8, 4

	# Reset counter
	addi	$t9, $zero, 0

SecondLoop:
	# Increment loop counter (2nd)
	addi	$t9, $t9, 4

	# Load array1 value
	add	$t7, $t1, $t8
	lw	$t4, -4($t7)

	# Load array2 value
	add	$t7, $t2, $t9
	lw	$t5, -4($t7)

	# Multiply the values
	mult	$t4, $t5
	mflo	$t4

	# Load the value inside array
	addi	$t3, $t3, 4
	# Load the value
	sw	$t4, -4($t3)

	# Print the integer
	add	$a0, $zero, $t4
	syscall

	# Check if exceed 4
	bne	$t9, 16, SecondLoop
	bne	$t8, 16, FirstLoop

Exit:
	# Exit the program
	li	$v0, 10
	syscall



	