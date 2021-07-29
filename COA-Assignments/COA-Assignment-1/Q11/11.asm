#program for sort an array (use your favorite sort algo). Array can be init in the program.
.data
array:	.word   1,20,30,40,50
array_string: .string "1,20,30,40,50\n"
string_1:   .string "Sorted array  is \n "
input: .asciz "The input arrays is  "
space: .asciz "   "
.text
# used insertion sort technique
main:
                la a0,input
                li a7,4
                ecall
                la a0,array_string
               li a7,4
               ecall
               
		la   s0, array 
		addi t0, x0, 5     # initialisation of  n
		addi t1, x0 ,0     # initialisation of  i
		jal  ra, Loop1
		
		# Print the result 
		jal  ra, output

		# Exit  the program
		li   a7, 10
                ecall

Loop1:
		addi t1, t1, 1     # increment i
		slli t4, t1, 2     # get the address of data[i]
		add  s1, s0, t4
		lw   t5, 0(s1)     # t5=data[i]
		add  t3, t5, x0    # temp=data[i]
		addi t2, t1, -1    # j=i-1
		blt  t1, t0, Loop2 # if(i < n)
		jr   ra
		
Loop2:
		slli t4, t2, 2     # get the address of data[j]
		add  s1, s0, t4
		lw   t6, 0(s1)     # t6=data[j]
		blt  t2, x0, Loop1 # if(j < 0) leave Loop2
		bge  t3, t6, Loop1 # if(temp >= data[j]) leave Loop2
		sw   t6, 4(s1)     # data[j+1] = data[j]
		sw   t3, 0(s1)     # data[j] = temp
		addi t2, t2, -1    # j--
		j    Loop2

output:
		la   a0, string_1
                li   a7, 4
                ecall
		lw   t0, 0(s0)
		mv   a0, t0
		li   a7, 1
    	        ecall
    	        la a0,space
    	        li a7,4
    	        ecall
		lw   t0, 4(s0)
		mv   a0, t0
		li   a7, 1
    	        ecall
    	        la a0,space
    	        li a7,4
    	        ecall
		lw   t0, 8(s0)
		mv   a0, t0
		li   a7, 1
    	        ecall
    	        la a0,space
    	        li a7,4
    	        ecall
		lw   t0, 12(s0)
		mv   a0, t0
		li   a7, 1
    	        ecall
    	        la a0,space
    	        li a7,4
    	        ecall
		lw   t0, 16(s0)
		mv   a0, t0
		li   a7, 1
    	        ecall
		ret