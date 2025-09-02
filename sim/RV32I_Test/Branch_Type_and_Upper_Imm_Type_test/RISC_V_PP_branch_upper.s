# File: test_branch_upper.s
# Mục tiêu: Kiểm tra 6 lệnh branch + LUI + AUIPC (dùng immediate dạng hex)

.globl main

main:
    # --- PHẦN 1: KHỞI TẠO THANH GHI ---
    addi x1, x0, 0xA        # x1 = 0xA (10)
    addi x2, x0, 0x14       # x2 = 0x14 (20)
    addi x3, x0, 0xA        # x3 = 0xA (10)
    addi x4, x0, -0x5       # x4 = -0x5 (−5)
    addi x5, x0, 0x5        # x5 = 0x5 (5)

    # --- PHẦN 2: KIỂM TRA CÁC LỆNH BRANCH ---
    # BEQ: x1 == x3 → nhảy, gán x10 = 1
    beq x1, x3, 0x8
    addi x10, x0, 0x0
    beq x0, x0, 0x8
    addi x10, x0, 0x1

    # BNE: x1 != x2 → nhảy, gán x11 = 1
    bne x1, x2, 0x8
    addi x11, x0, 0x0
    beq x0, x0, 0x8
    addi x11, x0, 0x1

    # BLT: x4 < x5 → nhảy, gán x12 = 1
    blt x4, x5, 0x8
    addi x12, x0, 0x0
    beq x0, x0, 0x8
    addi x12, x0, 0x1

    # BGE: x2 >= x1 → nhảy, gán x13 = 1
    bge x2, x1, 0x8
    addi x13, x0, 0x0
    beq x0, x0, 0x8
    addi x13, x0, 0x1

    # BLTU: unsigned(0xA) < unsigned(0x14) → nhảy, gán x14 = 1
    bltu x1, x2, 0x8
    addi x14, x0, 0x0
    beq x0, x0, 0x8
    addi x14, x0, 0x1

    # BGEU: unsigned(0x14) >= unsigned(0xA) → nhảy, gán x15 = 1
    bgeu x2, x1, 0x8
    addi x15, x0, 0x0
    beq x0, x0, 0x8
    addi x15, x0, 0x1

    # --- PHẦN 3: KIỂM TRA LUI / AUIPC ---
    lui   x16, 0x12345      # x16 = 0x12345000
    auipc x17, 0x10         # x17 = PC + 0x10000

    # --- PHẦN 4: LƯU KẾT QUẢ ---
    sw x10, 0xC8(x0)        # Mem[0xC8] <= BEQ result
    sw x11, 0xCC(x0)        # Mem[0xCC] <= BNE result
    sw x12, 0xD0(x0)        # Mem[0xD0] <= BLT result
    sw x13, 0xD4(x0)        # Mem[0xD4] <= BGE result
    sw x14, 0xD8(x0)        # Mem[0xD8] <= BLTU result
    sw x15, 0xDC(x0)        # Mem[0xDC] <= BGEU result
    sw x16, 0xE0(x0)        # Mem[0xE0] <= LUI result
    sw x17, 0xE4(x0)        # Mem[0xE4] <= AUIPC result

done:
    beq x0, x0, done

