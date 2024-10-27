.globl argmax
.extern matmul
.text

# ==============================================================================
# Arguments:
#   a0: the pointer to the start of the vector
#   a1: the number of elements in the vector
# Returns:
#   a0: the first index of the largest element
# ==============================================================================
argmax:
   li t0, 1                    # 最小長度為1
   blt a1, t0, error_empty_vector   # 如果長度<1，跳到錯誤處理
   
   # Prologue
   addi sp, sp, -20
   sw ra, 16(sp)
   sw s0, 12(sp)
   sw s1, 8(sp)
   sw s2, 4(sp)
   sw s3, 0(sp)
   
   # 初始化
   mv s0, a0                   # s0 = 向量位址
   mv s1, a1                   # s1 = 向量長度
   li t0, 0                    # t0 = 當前索引(0)
   mv t1, t0                   # t1 = 最大值索引(0)
   lw t2, 0(s0)               # t2 = 目前最大值(第一個元素)
   
loop:
   beq t0, s1, done           # 如果到達結尾，結束
   
   # 載入當前元素
   slli t3, t0, 2             # t3 = 索引 * 4
   add t3, s0, t3             # t3 = 當前元素位址
   lw t4, 0(t3)               # t4 = 當前元素值
   
   # 比較大小
   ble t4, t2, not_larger     # 如果當前元素 <= 最大值，跳過
   mv t2, t4                  # 更新最大值
   mv t1, t0                  # 更新最大值索引
   
not_larger:
   addi t0, t0, 1             # 索引++
   j loop
   
done:
   mv a0, t1                  # 回傳最大值索引
   
   # Epilogue
   lw ra, 16(sp)
   lw s0, 12(sp)
   lw s1, 8(sp)
   lw s2, 4(sp)
   lw s3, 0(sp)
   addi sp, sp, 20
   
   ret

error_empty_vector:
   li a0, -1                  # 回傳-1表示錯誤
   ret