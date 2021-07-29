#Using multiply_proc to print the factorial of a number.

.data
input: .asciz "Enter number : "
output: .asciz "Factorial of number is : "
is: .asciz " \nis "

.text
main:
	la a0,input
	li a7,4
	ecall
	li a7,5
	ecall
	add t0,a0,x0 #t0 = n
	add t1,t0,x0 #i=n
	addi t2,x0,1 #fact = 1 initialising variable
	beq t0,x0,end
	
	multiply_proc:
		mul t2,t2,t1
		addi t1,t1,-1
		bgt t1,x0,multiply_proc
		
	end:
		la a0,output
		li a7,4
		ecall
		addi a0,t0,0
		li a7,1
		ecall
		la a0,is
		li a7,4
		ecall
		addi a0,t2,0
		li a7,1
		ecall
