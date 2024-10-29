.globl dot

.text
# =======================================================
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

    # Prologue
    mv t0, a0                # t0 <- v0
    add a0, x0, x0           # product <- 0
    add t1, x0, x0           # counter <- 0
    addi t2, x0, 4
    mul a3, a3, t2
    mul a4, a4, t2
loop_start:
    beq t1, a2, loop_end     # for counter from 0 to length-1
    mul t2, t1, a3
    mul t3, t1, a4
    add t4, t0, t2           # t4 <- v0 + counter * stride0 * sizeof(int)
    add t5, a1, t3           # t5 <- v1 + counter * stride1 * sizeof(int)
    lw t4, 0(t4)             # t4 <- v0[counter]
    lw t5, 0(t5)             # t5 <- v1[counter]
    mul t4, t4, t5
    add a0, a0, t4           # product <- product + v0[counter] * v1[counter]
    addi t1, t1, 1           # counter <- counter + 1
    j loop_start

loop_end:
    # Epilogue

    
    ret