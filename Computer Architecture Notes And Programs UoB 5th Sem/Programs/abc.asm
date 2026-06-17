.data
# -------------------------------
# DATA MEMORY SECTION
# -------------------------------

array:          .word 12, 7, 25, 9, 30, 14     # Array stored in memory
length:         .word 6                         # Number of elements in array
target:         .word 25                        # Value to search

foundValue:     .word 0                         # Memory location to store found value
foundAddress:   .word 0                         # Memory location to store address of found value
notFoundFlag:   .word 0                         # 1 means value not found


.text
.globl main

main:
    # -------------------------------
    # INITIALIZATION
    # -------------------------------

    la   $s0, array          # $s0 = base address of array
    lw   $s1, length         # $s1 = length of array
    lw   $s2, target         # $s2 = target value to search

    li   $t0, 0              # $t0 = index i = 0
    li   $t1, 0              # $t1 = sum of checked values


search_loop:
    # -------------------------------
    # CONTROL UNIT: BRANCH CONDITION
    # if index == length, go to not_found
    # -------------------------------

    beq  $t0, $s1, not_found

    # -------------------------------
    # ADDRESS CALCULATION
    # address = base address + index * 4
    # Each integer word = 4 bytes
    # -------------------------------

    sll  $t2, $t0, 2         # $t2 = index * 4
    add  $t3, $s0, $t2       # $t3 = address of array[index]

    # -------------------------------
    # MEMORY READ
    # Load array[index] from memory
    # -------------------------------

    lw   $t4, 0($t3)         # $t4 = array[index]

    # -------------------------------
    # COMPARISON AND BRANCH
    # if array[index] == target, jump to found
    # -------------------------------

    beq  $t4, $s2, found

    # -------------------------------
    # ALU OPERATION
    # Add current value to sum
    # -------------------------------

    add  $t1, $t1, $t4       # sum = sum + array[index]

    # -------------------------------
    # UPDATE INDEX
    # -------------------------------

    addi $t0, $t0, 1         # index = index + 1

    # -------------------------------
    # UNCONDITIONAL JUMP
    # Go back to loop
    # -------------------------------

    j search_loop


found:
    # -------------------------------
    # VALUE FOUND
    # Store found value in memory
    # Store its memory address also
    # -------------------------------

    la   $t5, foundValue
    sw   $t4, 0($t5)         # foundValue = array[index]

    la   $t6, foundAddress
    sw   $t3, 0($t6)         # foundAddress = address of array[index]

    # -------------------------------
    # CALL SUBROUTINE
    # Demonstrates jump-and-link instruction
    # -------------------------------

    jal process_found

    j exit_program


not_found:
    # -------------------------------
    # VALUE NOT FOUND
    # Set notFoundFlag = 1
    # -------------------------------

    li   $t7, 1
    la   $t8, notFoundFlag
    sw   $t7, 0($t8)

    j exit_program


process_found:
    # -------------------------------
    # BASIC STACK MEMORY MANAGEMENT
    # Save return address and temporary value
    # -------------------------------

    addi $sp, $sp, -8        # Allocate stack space
    sw   $ra, 4($sp)         # Save return address
    sw   $t4, 0($sp)         # Save found value

    # Example processing:
    # Add 100 to found value and store it again

    lw   $t9, 0($sp)         # Load saved found value
    addi $t9, $t9, 100       # found value = found value + 100

    la   $t5, foundValue
    sw   $t9, 0($t5)         # Update foundValue in memory

    # -------------------------------
    # RESTORE STACK
    # -------------------------------

    lw   $ra, 4($sp)         # Restore return address
    addi $sp, $sp, 8         # Free stack memory

    jr   $ra                 # Return to caller


exit_program:
    # -------------------------------
    # END PROGRAM
    # -------------------------------

    li   $v0, 10             # Exit system call
    syscall