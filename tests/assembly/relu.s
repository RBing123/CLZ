.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue

    add t0, x0, x0              # t0 <- 0
loop_start:
    beq t0, a1, loop_end        # for t0 from 0 to a1-1
    addi t2, x0, 4
    mul t1, t0, t2              # t1 <- t0 * sizeof(int)
    add t2, t1, a0              # t2 <- a0 + t0 * sizeof(int)
    lw t3, 0(t2)                # t3 <- a0[t0]
    bge t3, x0, loop_continue   # if t3 > 0, jump to loop_continue
    add t3, x0, x0              # t3 <- 0
    sw t3, 0(t2)                # a0[t0] <- t3

loop_continue:
    addi t0, t0, 1              # t0 <- t0 + 1
    j loop_start

loop_end:


    # Epilogue

    
	ret