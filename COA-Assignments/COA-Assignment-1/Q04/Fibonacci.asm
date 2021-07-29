#code for Printing  first N fibonacci numbers

.data
input: .asciz "Enter the number of fibonacii: "
output1: .asciz "The First "
output2: .asciz " Fibonacci numbers are\n"
space: .asciz " "

.text
main:
	la a0,input
	li a7,4	# 4 to printStr
	ecall	
	
	li a7,5 # 5 to readInt
	ecall #getting value of N
	
	addi t0,a0,0 #copying N from a0 to t0
	li t1,0 # a=0
	li t2,1 #b=1;
	
	la a0,output1
	li a7,4
	ecall
	addi a0,t0,0
	li a7,1
	ecall
	la a0,output2
	li a7,4
	ecall	
	
	beq t0,x0,return #if n=0 there is nothing to do exit
	
	li t4,0 #i=0 t0 n-1 iterations
	
	loop:
		la a0,space #prints space
		li a7,4
		ecall
		beq t4,x0,firstEle # first_ele
		
		li a0,1
		beq t4,a0,secondEle #second ele
		#else
		add t3,t1,t2 #c=a+b
		addi a0,t3,0
		li a7,1
		ecall # prints a fibonacci_number
		
		addi t1,t2,0 #a=b
		addi t2,t3,0 #b=c
		
		addi t4,t4,1 #i=i+1
		blt t4,t0,loop
		j return
	firstEle:
		addi a0,t1,0
		li a7,1
		ecall
		addi t4,t4,1
		blt t4,t0,loop
		bge t4,t0,return
	secondEle:
		addi a0,t2,0
		li a7,1
		ecall
		addi t4,t4,1
		blt t4,t0,loop
	return:
