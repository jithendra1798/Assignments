# program to binary search.
  .data
	Array: .byte 0,10,20,30,40,50,60,70
	input: .asciz "enter the element to search using binary search"
	output: .asciz " \n element  found"
	output_1: .string "given element is not found"
  .text
      andi t0, t0, 0 #for sorted array
      andi t1, t1, 0 #low value
      andi t2, t2, 0 #high value
      andi t3, t3, 0 #mid  value
      andi t4, t4, 0 #key to be searched
      andi t5, t5, 0 #index in which the key  resides
      andi t6, t6, 0 #find mid value in the array
      
      li t1, 0 # Low Value
      li t2, 8 # High Value
      li t3, 0 # mid Value
      la a0,input
      li a7,4
      ecall
      li a7,5
      ecall
      addi t4, a0,0 
      li t6, 2
      
  IF:  bgt t1, t2, END
  
  ELSE:
  add t3, t1, t2
  div t3, t3, t6
  la t0, Array
  add t0, t0, t3
  lb t0, 0(t0)
 
 ifkey:
   bne t4, t0,if_else_key
   j END
   
 if_else_key:
    bgt t4, t0,else_key
    addi t2, t3, -1
    j ELSE

 else_key:
     addi t1, t3, 1
      j ELSE 
      

      
END: 	
        beq t4,t0,found
        la a0,output_1
        li a7,4
        ecall
        
found:
       addi a0,t0,0
 	li a7,1
 	ecall
 	la a0,output
 	li a7,4
 	ecall