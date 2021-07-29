#program to print favorite number;

.data
input:.asciz "Enter your favorite no : "
output:.asciz "your favorite no is : "
 
 .text 
   
   la a0,input
   li a7,4
   ecall
   li a7,5
   ecall
   
   add t0,a0,x0
   
   la a0,output
   li a7,4
   ecall
   addi a0,t0,0
   li a7,1
   ecall
