# File: test_jal_jalr.s
# Mục tiêu: Kiểm tra JAL và JALR

.globl main

main:
    # --- JAL TEST ---
    jal x1, target1          # jump đến target1, lưu return addr vào x1
    addi x10, x0, 0x0        # sẽ bị bỏ qua nếu nhảy đúng
target1:
    addi x10, x0, 0x11       # x10 = 0x11 để xác nhận jal đã chạy

    # --- JALR TEST ---
    auipc x2, 0              # x2 = PC hiện tại
    addi  x2, x2, target2 - .  # x2 = địa chỉ target2
    jalr  x3, 0(x2)          # nhảy gián tiếp đến target2, lưu return addr vào x3
    addi x11, x0, 0x0        # sẽ bị bỏ qua nếu nhảy đúng
target2:
    addi x11, x0, 0x22       # x11 = 0x22 để xác nhận jalr đã chạy

    # --- LƯU KẾT QUẢ ---
    sw x10, 0xF0(x0)         # Mem[0xF0] <= JAL result
    sw x11, 0xF4(x0)         # Mem[0xF4] <= JALR result
    sw x1,  0xF8(x0)         # Mem[0xF8] <= return addr from JAL
    sw x3,  0xFC(x0)         # Mem[0xFC] <= return addr from JALR

done:
    beq x0, x0, done
