#  program to print "Hello World!"

# Setup the parameters to print hello world
main: addi  a0, x0, 1      # 1 = StdOut
        la    a1, helloworld # load address of helloworld
        addi  a2, x0, 13     # length of our string
        addi  a7, x0, 64     # write system call
        ecall                # Call 
# Setup the parameters to exit the program


        addi    a0, x0, 0   # Use 0 return code
        addi    a7, x0, 93  # Service command code 93 terminates
        ecall               #terminate the program


.data
helloworld:      .ascii "Hello World \n"
