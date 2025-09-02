# File: test_U_type.s
# Mục tiêu: Kiểm tra hai lệnh U-type là LUI và AUIPC.

.globl main

main:
    # --- PHẦN 1: THỰC THI LỆNH ---
    
    # Test LUI (Load Upper Immediate)
    # Lệnh này nằm ở địa chỉ PC = 0x00.
    # Nó sẽ nạp 20 bit immediate (0xABCDE) vào 20 bit cao của x10
    # và xóa 12 bit thấp về 0.
    # Kỳ vọng: x10 = 0xABCDE000
    lui x10, 0xABCDE

    # Test AUIPC (Add Upper Immediate to PC)
    # Lệnh này nằm ở địa chỉ PC = 0x04.
    # Nó sẽ tính: rd = PC + (imm << 12)
    # rd = 0x04 + (1 << 12) = 4 + 4096 = 4100 (tức 0x1004)
    # Kỳ vọng: x11 = 4100
    auipc x11, 1
    
    # --- PHẦN 2: LƯU KẾT QUẢ ĐỂ XÁC MINH ---
    # Ghi hai kết quả ra bộ nhớ
    sw x10, 600(x0)      # Mem[600] <= 0xABCDE000
    sw x11, 604(x0)      # Mem[604] <= 4100

done:
    # Dừng chương trình
    beq x0, x0, done