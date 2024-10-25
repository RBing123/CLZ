.globl write_matrix
.text
# ==============================================================================
# Arguments:
#   a0 (char*) pointer to output filename
#   a1 (int*) pointer to matrix
#   a2 (int) number of elements to write
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)
    sw s1, 20(sp)
    sw s2, 16(sp)

    # save register
    mv s0, a0      # s0 = filename
    mv s1, a1      # s1 = matrix pointer
    mv s2, a2      # s2 = number of elements

    # open file (create/truncate)
    mv a0, s0      # file name
    li a1, 1       # write mode = 1
    li a7, 1024    # syscall: open file
    ecall
    
    # check fopen error
    bltz a0, write_open_error
    mv s3, a0      # save file descriptor

    # write matrix
    mv a0, s3      # file descriptor
    mv a1, s1      # buffer address
    li t0, 4       # 4 bytes per integer
    mul a2, s2, t0 # total write bytes
    li a7, 64      # syscall: writ back to file
    ecall

    # check fwrite error
    bltz a0, a2, write_error

    # close file
    mv a0, s3
    li a7, 57      # syscall: close file
    ecall
    
    # check fclose error
    bltz a0, close_error

    # return successfully
    mv a0, s1
    j write_done

write_open_error:
    li a0, 53      # fopen error
    j exit

write_error:
    mv a0, s3      # close file
    li a7, 57
    ecall
    li a0, 54      # fwrite error
    j exit

close_error:
    li a0, 55      # fclose error
    j exit

write_done:
    # Epilogue
    lw ra, 28(sp)
    lw s0, 24(sp)
    lw s1, 20(sp)
    lw s2, 16(sp)
    addi sp, sp, 32
    ret
exit:
    li a7, 93      # syscall: exit
    ecall