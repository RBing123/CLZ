.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)                # the pointer to string representing the filename
    sw s1, 4(sp)                # a pointer to the number of rows
    sw s2, 8(sp)                # a pointer to the number of columns
    sw s3, 12(sp)               # the file descriptor
    sw s4, 16(sp)               # the pointer to the matrix in memory
    sw s5, 20(sp)               # save the # of entries
    sw ra, 24(sp)

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0

    add a1, s0, x0              # fopen("filename", "-r")
    add a2, x0, x0
    call fopen
    addi t0, x0, -1
    beq t0, a0, eof_or_error    # if file descriptor (fp) is -1: exit with exit code 1

    add s3, a0, x0
    
    add a1, s3, x0
    add a2, s1, x0
    addi a3, x0, 4
    call fread                  # fread(fp, row, 4)
    bne a0, a3, eof_or_error    # if a0 is NOT equal to a3: exit with exit code 1

    lw t0, 0(s1)
    blt t0, x0, eof_or_error

    add a1, s3, x0
    add a2, s2, x0
    addi a3, x0, 4
    call fread                  # fread(fp, column, 4)
    bne a0, a3, eof_or_error    # if a0 is NOT equal to a3: exit with exit code 1

    lw t0, 0(s2)
    blt t0, x0, eof_or_error

    lw t0, 0(s1)                # t0 <- row
    lw t1, 0(s2)                # t1 <- column
    mul a0, t0, t1              # a0 <- t0 * t1 (# of entries)
    add s5, a0, x0              # save the # of entries
    addi t0, x0, 4
    mul a0, a0, t0
    call malloc
    beq a0, x0, eof_or_error    # if a pointer returned is NULL: exit with exit code 1

    add s4, a0, x0              # save the returned pointer

    add a1, s3, x0
    add a2, s4, x0
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a3, t0, t1
    addi t0, x0, 4
    mul a3, a3, t0
    call fread
    bne a0, a3, eof_or_error

    add a1, s3, x0              # fclose(fp)
    call fclose
    bne a0, x0, eof_or_error

    add a0, s4, x0

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

eof_or_error:
    li a1 1
    jal exit2
    