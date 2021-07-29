.#program to print sum of n numbers n is a input
.data
input: .asciz "Enter the  value of N \n"
output: .asciz "the sum of N numbers is \n"
 
 .text
 main:
 
        la 	a0, input
	li 	a7, 4 # print function call
	ecall
	
	li 	a7, 5 # read int system call
	ecall
	mv a2,a0
	la	a0, output
	li	a7, 4
	ecall 
	
	li t0,0
        li t1,0
	
loop:
	beqz  a2,exit
	add t1,t1,a2
	addi a2,a2,-1
	beq x0,x0,loop
	
exit:
	 mv a0,t1
	 li a7,1
	 ecall 