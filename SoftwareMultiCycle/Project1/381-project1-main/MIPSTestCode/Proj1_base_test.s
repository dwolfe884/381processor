.data
.text
#.global main
#main:
addiu $sp $0, 0x7FFFEFFC
add $t0, $0, $sp
addi $t0, $0, 5 
addi $t1, $0, 10
add $t2, $t0, $t1
addiu $t3, $t0, -15
addu $t4, $t3, $t3
and $t5, $t0, $t1
andi $t6, $t5, 0xFF
lui $t0, 0x1001
sw $t6, 0($t0)
lw $t2, 0($t0)
nor $t3, $t2, $t0
xor $t4, $t2, $t3
xori $t5, $t4, 0x1100
or $t2, $t3, $0
ori $t4, $t2, 0x11
slt $t6, $t1, $t4
slti $t4, $0, 5
sll $t5, $t5, 4
srl $t5, $t5, 4
sra $t5, $t5, 4
sub $t4, $t5, $t1
subu $t5, $t2, $t0
beq $0, $0, next
next:
bne $t1, $0, next2
next2:
j closer
closer:
jal almost
repl.qb $t5, 5 
halt

almost:
addi $t0, $0, 10
addi $t1, $0, 100
jr $ra
