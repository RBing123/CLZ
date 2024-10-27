.data
    vector1: .word 1, 2, 3
    vector2: .word 1, 3, 5
    size:    .word 3
    result_msg: .asciiz "The dot product is: "
    newline:    .asciiz "\n"

.global main

main:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    # Arguments4
    la a0, vector1     # a0 = vector1 address
    la a1, vector2     # a1 = vector2 address
    lw a2, size        # a2 = size

    # invoke dot.s
    jal ra, dot        # a0 = save result

    # save result
    mv t0, a0

    # print out message
    li a7, 4           
    la a0, result_msg
    ecall

    # print out result
    li a7, 1           
    mv a0, t0          
    ecall

    # print out newline
    li a7, 4
    la a0, newline
    ecall

    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 8
             
    ret