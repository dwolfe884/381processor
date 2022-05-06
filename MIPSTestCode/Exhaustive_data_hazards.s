.data
.text

#Testing forwarding for first operand
addi $t0, $0, 10
add $t0, $t0, $t0 #data forwarding from ex stage
add $t0, $t0, $t0 #data forwarding from mem stage
add $t0, $t0, $t0 #data forwarding from wb stage

#Testing forwarding for second operand
addi $t2, $0, 10
add $t2, $t2, $t2 #data forwarding from ex stage
add $t2, $t2, $t2 #data forwarding from mem stage
add $t2, $t2, $t2 #data forwarding from wb stage

#Testing branch data forwarding
addi $t0, $0, 80
addi $t1, $0, 80
bne $t0, $t1, here #data forwarding for branch from ex stage. This won't be taken
bne $t0, $t1, here #data forwarding for branch from mem stage. This won't be taken
beq $t0, $t1, here #data forwarding for branch from wb stage. This will be taken
nop #These won't run
nop #These won't run
here:

#Testing i type forwading
addi $t1, $0, 1
addi $t1, $t1, 1 #data forwarding from ex stage
addi $t2, $t1, 1 #data forwarding from mem stage
addi $t1, $t2, 1 #data forwarding from ex stage
addi $t1, $t2, 1 #data forwarding from mem stage
addi $t1, $t2, 1 #data forwarding from wb stage
add $t6, $t1, $t2 #End with an r type instruction to test forwarding both rs and rt values
halt
