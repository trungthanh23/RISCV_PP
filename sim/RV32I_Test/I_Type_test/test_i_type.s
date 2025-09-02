# File: test_itype.s
# Mục tiêu: Kiểm tra 9 lệnh I-type với các giá trị immediate hợp lệ.

.globl main

main:
    # --- PHẦN 1: KHỞI TẠO DỮ LIỆU ---
    # x1 = 100 (0x64)
    addi x1, x0, 100

    # --- PHẦN 2: THỰC THI CÁC LỆNH I-TYPE ---
    addi  x10, x1, 200    # ADDI:  100 + 200 = 300 (0x12C)
    slti  x11, x1, 200    # SLTI:  (100 < 200) ? 1 : 0 = 1
    sltiu x12, x1, -1     # SLTIU: (100 < 0xFFFFFFFF) ? 1 : 0 = 1
    andi  x13, x1, 0x0F0  # ANDI:  100 & 240 (0x64 & 0xF0) = 96 (0x60)
    ori   x14, x1, 0x0F0  # ORI:   100 | 240 (0x64 | 0xF0) = 244 (0xF4)
    xori  x15, x1, -1     # XORI:  100 ^ -1 (0x64 ^ 0xFF...F) = -101 (0xFFFFFF9B)
    slli  x16, x1, 4      # SLLI:  100 << 4 = 1600 (0x640)
    srli  x17, x1, 4      # SRLI:  100 >> 4 = 6
    
    # Để test srai, ta cần một số âm trong thanh ghi
    addi x2, x0, -100     # x2 = -100 (0xFFFFFF9C)
    srai  x18, x2, 4      # SRAI:  -100 >>> 4 = -7 (0xFFFFFFF9)

    # --- PHẦN 3: LƯU KẾT QUẢ VÀO BỘ NHỚ ---
    sw x10, 200(x0)      # Mem[200] <= 300
    sw x11, 204(x0)      # Mem[204] <= 1
    sw x12, 208(x0)      # Mem[208] <= 1
    sw x13, 212(x0)      # Mem[212] <= 96
    sw x14, 216(x0)      # Mem[216] <= 244
    sw x15, 220(x0)      # Mem[220] <= -101 (0xFFFFFF9B)
    sw x16, 224(x0)      # Mem[224] <= 1600
    sw x17, 228(x0)      # Mem[228] <= 6
    sw x18, 232(x0)      # Mem[232] <= -7 (0xFFFFFFF9)

done:
    beq x0, x0, done