#Q6   Use the print_int procedure to print the sum from the N_sum program.

.data 
input: .asciz "Enter the value of N "
result: .asciz " The Sum is Of total "
address: .asciz "\nThe address of ascii string is "
output: .asciz "\nCalculated result "
sum:
.text
main:
	
	la a0,input
	li a7,4
	ecall
	li a7,5 
	ecall # taking the  input value of N
	add t0,a0,x0 #store the value of N
	
	li t1,0 # sum = 0
	li t2,0 # i=0
	TOTAL_SUM:
		add t1,t1,t2
		addi t2,t2,1
		ble t2,t0,TOTAL_SUM
	
	la a3,sum
	add a0,t1,x0
	li a1,10
	print_int:
		rem a2, a0, a1
		div a4, a0, a1
		addi a2, a2, 48  # 48 is the ascii value of '0' hence add the value  48
		addi a4, a4, 48
		sb a4, 0(a3)
		sb a2, 1(a3)
		la a0,result
		li a7,4
		ecall
		la a0, sum
		li a7,4
		ecall
		la a0,address
		li a7,4
		ecall
		la a0,sum
		li a7, 34
		ecall
		
		la a0,output
		li a7,4
		ecall
		li a7, 10 #  exit
		ecall
	