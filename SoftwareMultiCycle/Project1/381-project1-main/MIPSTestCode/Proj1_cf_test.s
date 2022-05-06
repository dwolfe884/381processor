.data
str1: .asciiz "Please enter a number:\n"
.align 2
vals: .word 25 1 4 10 381 42 100 60 0 12
.text
#.globl main
addiu $sp, $0, 0x7FFFEFFC
j main
calcFib:
blt $a0, 2, ret #Check if argument is less than 2

addi $sp, $sp, -12 #Move the stack pointer up to fit 3 registers
sw $ra, 0($sp) #Put return reg on stack
sw $a0, 4($sp) #Put argument on stack

addi $a0, $a0, -1 
jal calcFib #Call calcFib(n-1)
sw $v0, 8($sp) #Store output in 3rd reg on stack

lw $a0, 4($sp) #Load original arugment
addi $a0, $a0, -2
jal calcFib #Call calcFib(n-2)

lw $t0, 8($sp) #load output from stack
add $v0, $v0, $t0 #Add 
lw $ra, 0($sp) #load return address
addi $sp, $sp, 12 #Reset stack
jr $ra

ret: #Return the number passed in if < 2
addi $v0, $a0, 0 
jr $ra

main:
# Start program
addi $s1, $zero, 0 # s1 is ouput value
inputs:
# Request some user input:
#li $v0, 4
#la $a0, str1
#syscall
#li $v0, 5
#syscall
#addi $a0, $v0, 0
addi $a0, $0, 5
jal calcFib
addi $t1, $v0, 0
# Print output
li $v0, 1
addi $a0, $t1, 0
syscall
# Exit program
halt
li $v0, 10
syscall
