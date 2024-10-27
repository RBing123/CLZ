.data
   # 3x3 矩陣
   m0: .word   1, 2, 3,    # 第一列
               4, 5, 6,    # 第二列
               7, 8, 9     # 第三列
               
   m1: .word   1, 2, 3,    # 第一列
               4, 5, 6,    # 第二列
               7, 8, 9     # 第三列
   
   n: .word 3              # 列數
   m: .word 3              # m0的行數/m1的列數
   k: .word 3              # 行數
   
   # 為結果矩陣分配空間 (3x3)
   result: .word 0:9       # 初始化9個0
   
   # 輸出格式用的字串
   space: .asciiz " "
   newline: .asciiz "\n"
   result_msg: .asciiz "Result matrix:\n"

.text
.globl main

main:
   # Prologue
   addi sp, sp, -4
   sw ra, 0(sp)
   
   # 準備參數
   la a0, m0              # a0 = 第一個矩陣位址
   la a1, m1              # a1 = 第二個矩陣位址
   la a2, result          # a2 = 結果矩陣位址
   lw a3, n               # a3 = n = 3
   lw a4, m               # a4 = m = 3
   lw a5, k               # a5 = k = 3
   
   # 呼叫矩陣乘法函數
   jal matmul
   
   # 印出結果矩陣
   # 印出提示訊息
   li a0, 4              # print_string
   la a1, result_msg
   ecall
   
   la t0, result         # t0 = result address
   lw t1, n              # t1 = 列數
   lw t2, k              # t2 = 行數
   li t3, 0              # t3 = row counter (i)
   
print_row:
   li t4, 0              # t4 = column counter (j)
   
print_element:
   # 計算當前元素位址
   mul t5, t3, t2        # t5 = i * k
   add t5, t5, t4        # t5 = i * k + j
   slli t5, t5, 2        # t5 = (i * k + j) * 4
   add t5, t0, t5        # t5 = address of result[i][j]
   
   # 印出數字
   li a0, 1              # print_int
   lw a1, 0(t5)          # load number to print
   ecall
   
   # 印出空格
   li a0, 4              # print_string
   la a1, space
   ecall
   
   # 更新行計數器
   addi t4, t4, 1        # j++
   blt t4, t2, print_element
   
   # 印出換行
   li a0, 4              # print_string
   la a1, newline
   ecall
   
   # 更新列計數器
   addi t3, t3, 1        # i++
   blt t3, t1, print_row
   
   # Epilogue
   lw ra, 0(sp)
   addi sp, sp, 4
   
   ret