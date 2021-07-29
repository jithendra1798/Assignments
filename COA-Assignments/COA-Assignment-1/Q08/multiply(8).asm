#program to multiply 2 numbers
.data

input2: .string "Enter the 2nd number \n" #input
out: .string "The product is  of two is"  #output
input1: .string "Enter the 1st number\n" #input
.text 
main:
	la,a0,input1 #loading  input
	li a7,4 #printing
	ecall
	li a7,5 
	ecall
	addi t0,a0,0 

	
	la,a0,input2 #loading input
	li a7,4 #print
	ecall
	li a7,5 
	ecall
	 addi t1,a0,0 

	#output
              la a0,out 
	li a7,4
	ecall
	mul t2,t1,t0
	addi a0,t2,0
	li a7,1
	ecall