.data
input1:	.asciiz "Banyak name tag: "
input2:	.asciiz "Name Tag "
input3:	.asciiz ": \n"
input4:	.asciiz "Daftar bentuk name tag:\n[1] Persegi Panjang \n[2] Segitiga\nPilih bentuk name tag: "
input5:	.asciiz "Masukkan alas: "
input6:	.asciiz "Masukkan tinggi: "
divider:	.asciiz "--------------------\n"
output:	.asciiz "Total biaya untuk memproduksi name tag tersebut yaitu Rp"

# $t0 = Nametag amount
# $t1 = Base    / Temporary area
# $t2 = Height  / Temporary mult LO
# $t3 = Nametag counter
# $t4 = Nametag selector
# $t5 = Total area
# $t6 = Total price
# $t7 = CONSTANT [1/100]

.text
.globl main
main:
	# Initiate the temporary register
	addi	$t4, $zero, 0
	addi	$t7, $zero, 1

	# Get the amount of name tag
	li	$v0, 4
	la	$a0, input1
	syscall
	
	li	$v0, 5
	syscall
	add	$t0, $zero, $v0
	
loop:
	# Break the loop if the amount is same
	beq	$t3, $t0, endloop
	addi	$t3, $t3, 1
	
	# print separator and "Name tag x"
	li	$v0, 4
	la	$a0, divider
	syscall
	la	$a0, input2
	syscall
	
	li	$v0, 1
	add	$a0, $zero, $t3
	syscall
	
	li	$v0, 4
	la	$a0, input3
	syscall
	
	# Ask the user the shape of the name tag
	li	$v0, 4
	la	$a0, input4
	syscall
	
	li	$v0, 5
	syscall
	add	$t4, $zero, $v0
	
	# Ask the user base
	li	$v0, 4
	la	$a0, input5
	syscall
	
	li	$v0, 5
	syscall
	add	$t1, $zero, $v0
	
	# Ask the user height
	li	$v0, 4
	la	$a0, input6
	syscall
	
	li	$v0, 5
	syscall
	add	$t2, $zero, $v0
		
	mult	$t1, $t2
	mflo	$t1
	
	beq	$t4, $t7, sum

triangle:
	srl	$t1, $t1, 1
	
sum:
	add	$t5, $t5, $t1
	
	# Jump back to loop
	j	loop
	
endloop:
	# Multiply the total area with price
	addi	$t7, $zero, 100
	mult	$t5, $t7
	mflo	$t6
	
	# Print the output
	li	$v0, 4
	la	$a0, output
	syscall
	
	li	$v0, 1
	add	$a0, $zero, $t6
	syscall
	
	# End program
	li		$v0, 10
	syscall