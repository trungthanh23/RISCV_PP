# File: test_rtype.s
# Mục tiêu: Kiểm tra 10 lệnh R-type cơ bản của RV32I.

.globl main

main:
    # --- PHẦN 1: KHỞI TẠO DỮ LIỆU ---
    # Chuẩn bị các giá trị để tính toán.
    # x1 = 15 (0xF)
    # x2 = 10 (0xA)
    # x3 = -1 (0xFFFFFFFF)
    # x4 = 2 (0x2), dùng cho các lệnh dịch chuyển
    addi x1, x0, 15
    addi x2, x0, 10
    addi x3, x0, -1 
    addi x4, x0, 2

    # --- PHẦN 2: THỰC THI CÁC LỆNH R-TYPE ---
    # Mỗi lệnh sẽ lưu kết quả vào một thanh ghi riêng, từ x10 đến x19.
    
    add  x10, x1, x2     # ADD:  15 + 10 = 25
    sub  x11, x1, x2     # SUB:  15 - 10 = 5
    xor  x12, x1, x2     # XOR:  15 ^ 10 = 5 (0xF ^ 0xA = 0x5)
    or   x13, x1, x2     # OR:   15 | 10 = 15 (0xF | 0xA = 0xF)
    and  x14, x1, x2     # AND:  15 & 10 = 10 (0xF & 0xA = 0xA)
    sll  x15, x1, x4     # SLL:  15 << 2 = 60
    srl  x16, x1, x4     # SRL:  15 >> 2 = 3
    sra  x17, x3, x4     # SRA:  -1 >>> 2 = -1 (dịch phải số học)
    slt  x18, x3, x1     # SLT:  (-1 < 15) ? 1 : 0 = 1 (so sánh có dấu)
    sltu x19, x3, x1     # SLTU: (0xFF..F < 15) ? 1 : 0 = 0 (so sánh không dấu)

    # --- PHẦN 3: LƯU KẾT QUẢ VÀO BỘ NHỚ ---
    # Lưu các thanh ghi từ x10-x19 vào các địa chỉ 100, 104, 108, ...
    sw x10, 100(x0)      # Mem[100] <= 25
    sw x11, 104(x0)      # Mem[104] <= 5
    sw x12, 108(x0)      # Mem[108] <= 5
    sw x13, 112(x0)      # Mem[112] <= 15
    sw x14, 116(x0)      # Mem[116] <= 10
    sw x15, 120(x0)      # Mem[120] <= 60
    sw x16, 124(x0)      # Mem[124] <= 3
    sw x17, 128(x0)      # Mem[128] <= -1 (0xFFFFFFFF)
    sw x18, 132(x0)      # Mem[132] <= 1
    sw x19, 136(x0)      # Mem[136] <= 0

done:
    # Dừng chương trình bằng một vòng lặp vô tận.
    beq x0, x0, done