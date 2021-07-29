.data
int_array_1: .byte 0,10,20,30,40,50,60,70,80
int_array_2: .byte 1,2,3,4,5,6,7,8,9
result: .byte  0,0,0,0,0,0,0,0,0
input_array_1: .asciz "0,10,20,30,40,50\n"
input_array_2: .asciz "1,2,3,4,5,6\n"
input: .asciz "The input arrays are: \n"
output: .asciz "The added array is: \n"
space: .asciz "  "

.text
li t0,0	#value of i for looping
li t5,9 # n value 

la a0,input
li a7,4
ecall

la a0,input_array_1
li a7,4
ecall

la a0,input_array_2
li a7,4
ecall

looping:
	la t1,int_array_1
	la t2,int_array_2
	la t3,result
	add t1,t1,t0 #address of int_array_1[i]
	add t2,t2,t0 #address of int_array_2[i]
	add t3,t3,t0 #address of result[i]
	lb t1,0(t1) #loading the value 
	lb t2,0(t2) #loading the value 
	add t4,t1,t2 # t4=int_array_1[i]+int_array_2[i]
	sb t4,0(t3) # storing value of t4 to result[i]
	addi t0,t0,1 # increment i
	blt t0,t5,looping # i<N
	
li t0,0 # initilising i=0

#printing
la a0,output
li a7,4
ecall

print:
	la t1,result	#  address of new array to t1
	add t1,t1,t0
	
	# Load result[i] to a0 and print
	lb a0,0(t1)
	li a7,1
	ecall
	
	# Print space
	la a0,space
	li a7,4
	ecall
	
	
	addi t0,t0,1 #  increment i
	blt t0,t5,print 
	
return: