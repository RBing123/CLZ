.golbl read_matrix
.text
# ==============================================================================
# Arguments:
#   a0 (char*) pointer to input filename
#   a1 (int*) pointer to destination matrix
#   a2 (int) number of elements to read
# ==============================================================================
read_matrix:
    # Prologue
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)

    # save arguments
    mv s0, a0      # s0 = filename
    mv s1, a1      # s1 = matrix pointer
    mv s2, a2      # s2 = number of elements

    # open file
    li a1, 0       # read mode = 0
    li a7, 1024    # syscall: open file
    ecall

    # error check
    bltz a0, read_error
    mv t0, a0      # data descripter

    # read matrix data
    mv a0, t0      # data descripter
    mv a1, s1      # buffer address
    li a2, 4       # 4 bytes per integer
    mul a2, a2, s2 # total bytes needs to store
    li a7, 63      # syscall: read file
    ecall

    # close file
    mv a0, t0
    li a7, 57      # syscall: close file
    ecall
read_done:
    # Epilogue
    lw ra, 28(sp)
    lw s0, 24(sp)
    lw s1, 20(sp)
    lw s2, 16(sp)
    addi sp, sp, 32
    ret

read_error:
    li a0, -1      # error code
    j read_done