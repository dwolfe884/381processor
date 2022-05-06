.data
.text
#.global main
#main:
#addiu $sp $0, 0xFFFC
lui $sp, 0x7FFF
nop
nop
nop
ori $sp, $sp, 0xEFFC
nop
nop
nop
add $t0, $0, $sp
addi $t0, $0, 5 
addi $t1, $0, 10
#addiu $t3, $t0, -15
addu $t4, $t3, $t3
nop
nop
and $t5, $t0, $t1
nop
nop
nop
andi $t6, $t5, 0xFF
lui $t0, 0x1001
nop
nop
nop
sw $t6, 0($t0)
nop
nop
nop
lw $t2, 0($t0)
nop
nop
nop
nor $t3, $t2, $t0
nop
nop
nop
xor $t4, $t2, $t3
nop
nop
nop
xori $t5, $t4, 0x1100
or $t2, $t3, $0
nop
nop
nop
ori $t4, $t2, 0x11
nop
nop
nop
slt $t6, $t1, $t4
slti $t4, $0, 5
sll $t5, $t5, 4
nop
nop
nop
srl $t5, $t5, 4
nop
nop
nop
sra $t5, $t5, 4
nop
nop
nop
sub $t4, $t5, $t1
subu $t5, $t2, $t0
beq $0, $0, next
nop
nop
nop
add $t7, $0, $0
next:
bne $t1, $0, next2
nop
nop
nop
add $t7, $0, $0
next2:
j closer
nop
nop
nop
add $t7, $0, $0
closer:
jal almost
nop
repl.qb $t5, 5 
halt

almost:
addi $t0, $0, 10
addi $t1, $0, 100
jr $ra
#halt

