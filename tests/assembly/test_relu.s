.data 
    matrix: .word 5, -3, 0, 2, -1
    n: .word 5
    newline: .asciiz "\n"
    space: .asciiz " "
.text
main:
    # Prologue
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)
    sw s2, 0(sp)
    
    # load data
    la a0, matrix
    lw a1, n
    mv s0, a0       # s0 = matrix address
    mv s1, a1       # s1 = n
    
    # invoke relu function
    jal relu

    # print
    li s2, 0
print_loop:
    bge s2, s1, print_done   # if (i >= n) goto print_done
    
    # load matrix element
    slli t0, s2, 2          # t0 = i * 4
    add t0, s0, t0          # t0 = matrix + i * 4
    lw t1, 0(t0)            # t1 = matrix[i]
    
    # printout number (syscall)
    mv a0, t1              # a0: element of matrix
    li a7, 1               # syscall 1 print insteger
    ecall
    
    # space (syscall)
    la a0, space           # load space address
    li a7, 4               # syscall 4 print string
    ecall
    
    addi s2, s2, 1        # i++
    j print_loop

print_done:
    #  (syscall)
    la a0, newline         # newline address
    li a7, 4               # syscall 4 print
    ecall

    # Epilogue
    lw ra, 12(sp)
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw s2, 0(sp)
    addi sp, sp, 16
    
    # Exit program (syscall)
    li a0, 0              # return 0
    li a7, 10             # syscall 10 exit
    ecall    