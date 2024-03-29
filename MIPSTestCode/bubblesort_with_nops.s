.data
vals: .word 25 1 4 10 381 42 100 60 0 12
.text
j main
nop

#$a0 = n = number of elements in array to sort
bsort:

addi $t0, $0, 4 #Set right element index to 1
addi $t1, $0, 0 #set left element index to 0
addi $t8, $0, 0 #Swapped = False
lui $t2, 0x1001
nop
nop
nop
#la $t2, vals #Get address of array

#START OF FOR LOOP
for:
add $t3, $t2, $t0 #Get offset of right element
add $t4, $t2, $t1 #Get offset of left element
nop
nop

lw $t5, 0($t3) #Get right element
lw $t6, 0($t4) #Get left element
nop
nop
nop

slt $t7, $t5, $t6
nop
nop
nop

beq $t7, $0, inc
nop
sw $t5, 0($t4) #Put right element in left element spot
sw $t6, 0($t3) #Put left element in right element spot
addi $t8, $0, 1 #swapped = true

inc:
addi $t0, $t0, 4 #Increment right index
addi $t1, $t1, 4 #Increment left index
nop
nop
slt $t7, $t0, $a0 #Check if i<n
nop
nop
nop
bne $t7, $0, for #Jump to top of for loop
nop
slti $t7, $t8, 1 #Check if swapped = True
nop
nop
nop
beq $t7, $0, bsort #If we have swapped, restart
nop
jr $ra #Else, return
nop
main:
# Start program
addi $s1, $zero, 0 # s1 is ouput value
inputs:

addi $t0, $0, 10 #N = 10
nop
nop
nop
sll $a0, $t0, 2 #Word align N
jal bsort
nop
addi $t1, $v0, 0
nop
nop
# Print output
li $v0, 1
addi $a0, $t1, 0
syscall
# Exit program
halt
li $v0, 10
syscall

