.globl dot

.text
# ==============================================================
# Arguments:
# a0: the address of vector 1
# a1: the address of vector 2
# a2: vector length
# Return:
# a0: return the result of vector 1 inner product with vector 2
# ==============================================================
dot:
    # Prologue
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)

    # intialize
    li t0, 0        # t0: save result
    li t4, 0        # t4: counter

dot_loop:
    beq t4, a2, dot_done

    # load vector element
    lw t1, 0(a0)    # t1: vector1[i]
    lw t2, 0(a1)    # t2: vector2[i]

    mul t5, t1, t2  # t5: vector1[i] * vector2[i]
    addi t0, t0, t5 # result += t5

    # refresh pointer and counter
    addi a0, a0, 4
    addi a1, a1, 4
    addi t4, t4, 1

    j dot_loop

dot_done:
    mv a0, t0

    # Epilogue
    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12

    ret
