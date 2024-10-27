.data
   # 測試資料
   v0: .word   -1, 2, 3, -4, 5, -6, 7, -8, 9   # 測試向量
   n0: .word 9                                  # 向量長度
   
   # 輸出訊息
   msg1: .asciiz "Argmax result: "
   newline: .asciiz "\n"

.text
.globl main

main:
   # Prologue
   addi sp, sp, -4
   sw ra, 0(sp)
   
   # Test: 一般向量
   # 印出提示訊息
   la a0, msg1
   li a7, 4         # 印出字串
   ecall
   
   # 呼叫 argmax
   la a0, v0        # 載入向量位址
   lw a1, n0        # 載入向量長度
   jal argmax       # 呼叫 argmax
   
   # 保存結果
   mv t0, a0        # 保存 argmax 的結果
   
   # 印出結果
   mv a0, t0
   li a7, 1         # 印出整數
   ecall
   
   # 印出換行
   la a0, newline
   li a7, 4         # 印出字串
   ecall
   
   # Epilogue
   lw ra, 0(sp)
   addi sp, sp, 4
   
   # 結束程式
   li a7, 10        # 結束程式
   ecall