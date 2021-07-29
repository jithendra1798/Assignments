#program to Print the first N Fibonacci numbers using recursion.
.data

array: .word 
output1: .asciz "Enter the value of N (number of Fibonacii numbers)"
output2: .asciz "The  first N fibonacci numbers are: \n"
str1: .asciz "  \0"

.text

main:    
        la    a0,output1
        li    a7,4
        ecall
                                            
        li    a7,5
        ecall
        
        li    s0, 1            
        li    a3,0
        addi  a4, a0,0
        
        la    a5, array         # fibonacci numbers will be stored in array
        addi  a6,a5,0
        addi  s10,a3,0
        
        la    a0,output2
        li    a7,4
        ecall
        
        j loop
loop:
        bgt   a3,a4,print       #loop from i=1 to n
        addi  a0,a3,0
        jal   ra, fibonacii           # call fibonacii
        mv    a1, a0           
        sw    a1,0(a5)          # store the result in array
        addi  a5,a5,4
        addi  a3,a3,1
        j     loop
fibonacii:
        ble   a0, s0, return   # if(n <= 1)
        addi  sp, sp, -12      
        sw    ra, 8(sp)        
        sw    a0, 4(sp)        
        addi  a0, a0, -1       
        jal   ra, fibonacii          # call fibonacii(n - 1)
        sw    a0, 0(sp)        # store the value of fibonacii(n - 1)
        lw    a0, 4(sp)        
        addi  a0, a0, -2       
        jal   ra, fibonacii          # call fibonacii(n - 2)
        lw    t0, 0(sp)        
        add   a0, a0, t0       # fibonacii(n - 1) + fibonacii(n - 2)
        lw    ra, 8(sp)        
        addi  sp, sp, 12       
        ret                    
	
return:
        ret                    # return

print:                         # prinitng all the fibonacci numbers
        bge   s10,a4,exit
        lw    a0,0(a6)
        addi  a6,a6,4
        addi  s10,s10,1
        
	li    a7,1
	ecall
	
	la    a0,str1
	li    a7,4
	ecall
	
	j print
exit: