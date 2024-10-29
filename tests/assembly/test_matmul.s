.import matmul.s
.import utils.s
.import dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9    # MAKE CHANGE HERE
m1: .word 1 2 3 4 5 6 7 8 9    # MAKE CHANGE HERE
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0, m0
    addi s1, x0, 2             # MAKE CHANGE HERE    
    addi s2, x0, 3             # MAKE CHANGE HERE
    la s3, m1
    addi s4, x0, 3             # MAKE CHANGE HERE
    addi s5, x0, 2             # MAKE CHANGE HERE
    la s6, d

    # Call matrix multiply, m0 * m1
    mv a0, s0
    mv a1, s1
    mv a2, s2
    mv a3, s3
    mv a4, s4
    mv a5, s5
    mv a6, s6
    jal ra, matmul             # call matmul

    # Print the output (use print_int_array in utils.s)
    add s7, x0, x0             # counter1 <- 0

print_matrix_outer_loop:
    beq s7, s1, outer_loop_end # for every row of d
    add s8, x0, x0             # counter2 <- 0

print_matrix_inner_loop:
    beq s8, s5, inner_loop_end # for every column of d
    mul t0, s7, s5
    addi t1, x0, 4
    mul t0, t0, t1
    mul t1, t1, s8
    add t0, t0, t1
    add t0, t0, s6
    lw a0, 0(t0)               # a0 <- d + counter1 * column * sizeof(int) + counter2 * sizeof(int)

    # print integer result
    mv a1, a0
    jal ra, print_int
    
    # print space
    li a1, ' '
    jal ra, print_char

    addi s8, s8, 1
    j print_matrix_inner_loop

inner_loop_end:
    # print newline
    li a1, '\n'
    jal ra, print_char

    addi s7, s7, 1
    j print_matrix_outer_loop

outer_loop_end:
    # Exit the program
    jal exit