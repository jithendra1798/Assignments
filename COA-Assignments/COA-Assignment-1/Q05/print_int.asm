#Assignment
#program to print_int: Write a program to convert a 2 digit integer to its equivalent ASCII string. Create a print_int procedure which takes the 2 digit decimal int as the input, and outputs the address of the ASCII string.
.data
input: .asciz "Enter  input number  "
output: .asciz "The number string is \n"
address: .asciz "\nThe address of ascii string is\n"
string:
.text
main:
	la a0,input
	li a7,4
	ecall
	la a0, string
	li a7, 5
	ecall
	li a6, 10
	la a3, string
	j print_int

print_int:
	rem a2, a0, a6
	div a4, a0, a6
	addi a2, a2, 48  #  the ascii value of '0'  is 48 hence add the value  48
	addi a4, a4, 48
	sb a4, 0(a3)
	sb a2, 1(a3)
	la a0,output
	li a7,4
	ecall
	la a0, string
	li a7,4
	ecall
	la a0,address
	li a7,4
	ecall
	la a0,string
	li a7, 34
	ecall
	
	li a7, 10 # to  exit
	ecall