#program to print sum of n integers
.data
output:  .asciz " the sum is/n "


.text

 main: 
        li a3,8 #an arbitary value of N
        li a1,0 #sum
        li a2,1 
loop:
      add a1,a1,a2
      addi a2, a2, 1 # t0 = t1 + imm
      ble a2, a3, loop# if a2 <a3 loop

      la a0,output #
      li a7,4 #print

      addi a0,a1,0
      li a7,1
      ecall 
       
      
      
      