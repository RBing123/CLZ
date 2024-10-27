.globl matmul

.text
# =======================================
# Arguments
#   a0: address of input matrix 1 (n * m)
#   a1: address of input matrix 2 (m * k)
#   a2: address of output matrix (result)
#   a3: n (number of rows in matrix 1)
#   a4: m (number of columns in matrix 1/rows in matrix 2)
#   a5: k (number of columns in matrix 2)
# Returns:
#   a0: address of output matrix
# =======================================
matmul:
   # Prologue
   addi sp, sp, -32        # Space for ra, s0-s6
   sw ra, 28(sp)          
   sw s0, 24(sp)          
   sw s1, 20(sp)          
   sw s2, 16(sp)
   sw s3, 12(sp)          # 儲存 n
   sw s4, 8(sp)           # 儲存 m
   sw s5, 4(sp)           # 儲存 k
   sw s6, 0(sp)           # 儲存 result matrix address
   
   # Save arguments
   mv s0, a0              # s0 = matrix1 address
   mv s1, a1              # s1 = matrix2 address
   mv s2, a2              # s2 = result matrix address
   mv s3, a3              # s3 = n
   mv s4, a4              # s4 = m
   mv s5, a5              # s5 = k
   
   # i loop initialization
   li t0, 0               # t0: i = 0 for outer loop
i_loop:
   bge t0, s3, i_done     # if i >= n, exit i loop
   
   # j loop initialization
   li t1, 0               # t1: j = 0 for middle loop
j_loop:
   bge t1, s5, j_done     # if j >= k, exit j loop
   
   # Initialize sum for current element
   li t3, 0               # t3: sum = 0
   
   # m loop initialization
   li t2, 0               # t2: m = 0 for inner loop
m_loop:
   bge t2, s4, m_done     # if m >= m, exit m loop
   
   # Calculate addresses
   # matrix1[i][m]
   mul t4, t0, s4         # t4 = i * m
   add t4, t4, t2         # t4 = i * m + m
   slli t4, t4, 2         # t4 = (i * m + m) * 4
   add t4, s0, t4         # t4 = address of matrix1[i][m]
   lw t5, 0(t4)           # t5 = matrix1[i][m]
   
   # matrix2[m][j]
   mul t4, t2, s5         # t4 = m * k
   add t4, t4, t1         # t4 = m * k + j
   slli t4, t4, 2         # t4 = (m * k + j) * 4
   add t4, s1, t4         # t4 = address of matrix2[m][j]
   lw t6, 0(t4)           # t6 = matrix2[m][j]
   
   # Multiply and accumulate
   mul t4, t5, t6         # t4 = matrix1[i][m] * matrix2[m][j]
   add t3, t3, t4         # sum += t4
   
   # m loop increment
   addi t2, t2, 1         # m++
   j m_loop
   
m_done:
   # Store result in result matrix
   mul t4, t0, s5         # t4 = i * k
   add t4, t4, t1         # t4 = i * k + j
   slli t4, t4, 2         # t4 = (i * k + j) * 4
   add t4, s2, t4         # t4 = address of result[i][j]
   sw t3, 0(t4)           # result[i][j] = sum
   
   # j loop increment
   addi t1, t1, 1         # j++
   j j_loop
   
j_done:
   # i loop increment
   addi t0, t0, 1         # i++
   j i_loop
   
i_done:
   # Return result matrix address
   mv a0, s2
   
   # Epilogue
   lw ra, 28(sp)          
   lw s0, 24(sp)          
   lw s1, 20(sp)          
   lw s2, 16(sp)
   lw s3, 12(sp)          
   lw s4, 8(sp)           
   lw s5, 4(sp)           
   lw s6, 0(sp)           
   addi sp, sp, 32        
   
   ret