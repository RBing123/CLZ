.globl argmax

.text
# =================================================================
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue

    add t0, x0, x0              # t0 <- 0
    addi t1, x0, 4              # t1 <- sizeof(int)
    lw t4, 0(a0)                # max <- a0[0]
    add t5, x0, x0              # index <- 0

loop_start:
    beq t0, a1, loop_end        # for t0 from 0 to a1-1
    mul t2, t1, t0              # t2 <- t0 * sizeof(int)
    add t2, t2, a0              # t2 <- a0 + t0 * sizeof(int)
    lw t3, 0(t2)                # t3 <- a0[t0]
    ble t3, t4, loop_continue   # if a0[t0] <= max, jump to loop_continue
    mv t4, t3                   # max <- a0[t0]
    mv t5, t0                   # index <- t0

loop_continue:
    addi t0, t0, 1
    j loop_start

loop_end:
    mv a0, t5                   # return index    

    # Epilogue


    ret