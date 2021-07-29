#program to find the GCD of the 2 initilised numbers


.data
output: .asciz "The GCD of 2 initilised  numbers is\n "


.text

main:

	li a1,25 # declaring first number
	li a2,30 #dclaring second number
	
	#checking which is the smaller number and storing it in a3
	ble a2,a1,z 
	addi a3,a1,0
	beq a3,a1,x
	z:
	addi a3,a2,0
	x:
	
loop:

	rem a4,a1,a3 #finding  remainder a1%a3
	rem a5,a2,a3 #finding  remainder a2%a3
	
	bne a4,x0,y #checking if the first remainder is 0 
	beq a5,x0,exit #this statment will only be executed if a4 = 0 and this statment checks if a5=0 if it is 0  it goes outside the loop 
	y:	
	addi a3,a3,-1 #decrementing loop variable
	bgt a3,x0,loop 
	
	exit:
	
	la 	a0, output
	li 	a7, 4 # print function call
	ecall
	
	#printing  GCD 
	addi a0,a3,0
	li a7,1 
	ecall
