.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    addi t0, x0, 5
    bne a0, t0, number_dismatch 

    add s0, a1, x0

    # =====================================
    # LOAD MATRICES
    # =====================================
    # Load pretrained m0
    addi a0, x0, 4
    call malloc
    add s2, a0, x0                # malloc memory for the number of rows in m0
    addi a0, x0, 4
    call malloc
    add s3, a0, x0                # malloc memory for the number of columns in m0
    lw a0, 4(s0)
    add a1, x0, s2
    add a2, x0, s3
    call read_matrix              # read_matrix(m0)
    add s1, a0, x0                # s1 <- returned matrix m0







    # Load pretrained m1
    addi a0, x0, 4
    call malloc
    add s5, a0, x0                # malloc memory for the number of rows in m1
    addi a0, x0, 4
    call malloc
    add s6, a0, x0                # malloc memory for the number of columns in m1
    lw a0, 8(s0)
    add a1, x0, s5
    add a2, x0, s6
    call read_matrix              # read_matrix(m1)
    add s4, a0, x0                # s4 <- returned matrix m1







    # Load input matrix
    addi a0, x0, 4
    call malloc
    add s8, a0, x0                # malloc memory for the number of rows in input matrix
    addi a0, x0, 4
    call malloc
    add s9, a0, x0                # malloc memory for the number of columns in input matrix
    lw a0, 12(s0)
    add a1, x0, s8
    add a2, x0, s9
    call read_matrix              # read_matrix(input_matrix)
    add s7, a0, x0                # s7 <- returned input_matrix

    lw s2, 0(s2)
    lw s3, 0(s3)
    lw s5, 0(s5)
    lw s6, 0(s6)
    lw s8, 0(s8)
    lw s9, 0(s9)

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    add a0, s2, x0
    mul a0, a0, s9
    addi t0, x0, 4
    mul a0, a0, t0
    call malloc
    add s10, a0, x0
    add a0, s1, x0
    add a1, s2, x0
    add a2, s3, x0
    add a3, s7, x0
    add a4, s8, x0
    add a5, s9, x0
    add a6, s10, x0
    call matmul                   # matmul(m0, input_matrix)
    add s1, s10, x0
    add s3, s9, x0

    add a0, s1, x0
    add a1, s2, x0
    mul a1, a1, s3
    call relu                     # relu(m0*input)

    add a0, s5, x0
    mul a0, a0, s3
    addi t0, x0, 4
    mul a0, a0, t0
    call malloc
    add s10, a0, x0
    add a0, s4, x0
    add a1, s5, x0
    add a2, s6, x0
    add a3, s1, x0
    add a4, s2, x0
    add a5, s3, x0
    add a6, s10, x0
    call matmul                   # matmul(m1, relu)
    add s1, s10, x0
    add s2, s5, x0

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0)                  # Load pointer to output filename
    add a1, s1, x0
    add a2, s2, x0
    add a3, s3, x0
    call write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    add a0, s1, x0
    add a1, s2, x0
    mul a1, a1, s3
    call argmax

    # Print classification
    add a1, a0, x0
    call print_int


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

number_dismatch:
    li a1, 3
    jal exit2