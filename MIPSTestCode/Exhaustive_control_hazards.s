.data
.text
la $t3, another
addi $t5, $0, 1
addi $t6, $0, 2
addi $t2, $0, 30

jr $3
addi $t0, $0, 15 #This shouldn't run

here:
addi $t0, $0, 15
beq $t0, $t2, done
subi $t0, $0, 15 #This shouldn't run
next:
bne $t0, $0, here
subi $t0, $0, 15 #This shouldn't run

another:
j next
addi $t0, $0, 50 #This shouldn't run
done:
jal finish
addi $t0, $0, 50 #This shouldn't run until the final jr call
halt


finish:
jr $ra
halt
