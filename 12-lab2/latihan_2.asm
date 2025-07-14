.data
output1: .asciiz "Nilai terendah = "
output2: .asciiz "\nNilai tertinggi = "
output3: .asciiz "\nRata-rata nilai = "
output4: .asciiz "\nRange nilai = "
divider: .asciiz "\n--------------------"
output5: .asciiz "\nPeokra: \"Sepertinya soal lab perlu dipermudah\""
output6: .asciiz "\nPeokra: \"Sepertinya soal lab perlu dipersulit\""

scores: .word 80,75,89,60,70,85,90,83,40,66,-1

# Temporary register info
# $t0 = Nilai terendah
# $t1 = Nilai tertinggi
# $t2 = "SLT" checking
# $t3 = Total scores -->-- Average scores
# $t4 = Array value at index -->-- CONSTANT <4> -->-- CONSTANT <80>
# $t5 = Array length 
# $t6 = Array index addr (base addr + 4)
# $t7 = Arrays (scores)

.text
.globl main
main:
	# Load the base address of the array (scores)
	la	$t7, scores
	# Initiate register
	addi	$t5, $zero, 0
	addi	$t6, $t7, 0
	addi	$t3, $zero, 0
	# Initiate the lowest score register to 100
	addi	$t0, $zero, 100
	
loop:
	# Get the value of the array at index position
	lw	$t4, 0($t6)
	# Exit the loop if the value is -1 (end of array)
	beq	$t4, -1, endloop
	# Add to total scores
	add	$t3, $t3, $t4
	
lowest:
	slt	$t2, $t4, $t0
	beq	$t2, 0, highest
	
	add	$t0, $zero, $t4
	
highest:
	slt	$t2, $t4, $t1
	beq	$t2, 1, increment
	
	add	$t1, $zero, $t4
	
increment:
	addi	$t5, $t5, 4
	add	$t6, $t7, $t5
	j	loop


endloop:
	# Print nilai terendah
	li	$v0, 4
	la	$a0, output1
	syscall
	li	$v0, 1
	addi	$a0, $t0, 0
	syscall
	
	# Print nilai tertinggi
	li	$v0, 4
	la	$a0, output2
	syscall
	li	$v0, 1
	addi	$a0, $t1, 0
	syscall
	
	# Print nilai rata-rata
	li	$v0, 4
	la	$a0, output3
	syscall
	# Get the average score
	addi	$t4, $zero, 4
	div	$t5, $t4
	mflo	$t5
	div	$t3, $t5
	mflo	$t3
	# Print the result
	li	$v0, 1
	addi	$a0, $t3, 0
	syscall
	
	# Print range nilai
	li	$v0, 4
	la	$a0, output4
	syscall
	li	$v0, 1
	sub	$a0, $t1, $t0
	syscall
	
	# Print keterangan
	li	$v0, 4
	la	$a0, divider
	syscall
	addi	$t4, $zero, 80
	slt	$t2, $t3, $t4
	beq	$t2, 0, happyEnding

badEnding:
	la	$a0, output5
	syscall
	j	exit

happyEnding:
	la	$a0, output6
	syscall

# Exit the program
exit:
	li	$v0, 10
	syscall
	