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

    # check malloc
    beqz s1, malloc_error

    # open file
    mv a0, s0      # file name
    li a1, 0       # read mode = 0
    li a7, 1024    # syscall: open file
    ecall

    # fopen error check
    bltz a0, fopen_error
    mv s3, a0      # file descripter

    # read matrix data
    mv a0, s3      # file descripter
    mv a1, s1      # buffer address
    li t0, 4       # 4 bytes per integer
    mul a2, s2, t0 # total bytes needs to store
    li a7, 63      # syscall: read file
    ecall

    # fread error check
    blt a0, a2, fread_error

    # close file
    mv a0, t0
    li a7, 57      # syscall: close file
    ecall

    # fclose error check
    bltz a0, fclose_error

    # return successfully
    mv a0, s1 
    j read_done

malloc_error:
    li a0, 48      # Malloc error
    j exit

fopen_error:
    li a0, 50      # fopen error
    j exit

fread_error:
    mv a0, s3      # close
    li a7, 57
    ecall
    li a0, 51      # fread error
    j exit

fclose_error:
    li a0, 52      # fclose error
    j exit

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