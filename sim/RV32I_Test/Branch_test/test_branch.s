# File: test_branch.s
# Mục tiêu: Kiểm tra toàn diện 6 lệnh rẽ nhánh của RV32I.

.globl main

main:
    # --- PHẦN 1: KHỞI TẠO DỮ LIỆU ---
    # x1 = 10
    # x2 = 10
    # x3 = 20
    # x4 = -10 (0xFFFFFFF6)
    # x30 = 0 (Thanh ghi "điểm số")
    addi x1, x0, 10
    addi x2, x0, 10
    addi x3, x0, 20
    addi x4, x0, -10
    add x30, x0, x0

    # --- PHẦN 2: THỰC THI CÁC BÀI TEST ---
    # Mỗi khi đi đúng đường, ta sẽ cộng 1 vào x30.
    # Tổng điểm cuối cùng phải là 12.
    
    # Test 1: BEQ (should take)
    beq x1, x2, beq_taken_ok
    j test_fail # Nhảy đến đây là sai
beq_taken_ok:
    addi x30, x30, 1 # Điểm +1

    # Test 2: BEQ (should not take)
    beq x1, x3, test_fail # Nhảy đến đây là sai
    addi x30, x30, 1 # Điểm +1

    # Test 3: BNE (should take)
    bne x1, x3, bne_taken_ok
    j test_fail
bne_taken_ok:
    addi x30, x30, 1 # Điểm +1

    # Test 4: BNE (should not take)
    bne x1, x2, test_fail
    addi x30, x30, 1 # Điểm +1

    # Test 5: BLT (signed, should take)
    blt x4, x1, blt_taken_ok # (-10 < 10) -> true
    j test_fail
blt_taken_ok:
    addi x30, x30, 1 # Điểm +1

    # Test 6: BLT (signed, should not take)
    blt x1, x4, test_fail # (10 < -10) -> false
    addi x30, x30, 1 # Điểm +1

    # Test 7: BGE (signed, should take)
    bge x1, x4, bge_taken_ok # (10 >= -10) -> true
    j test_fail
bge_taken_ok:
    addi x30, x30, 1 # Điểm +1

    # Test 8: BGE (signed, should not take)
    bge x4, x1, test_fail # (-10 >= 10) -> false
    addi x30, x30, 1 # Điểm +1

    # Test 9: BLTU (unsigned, should take)
    bltu x1, x4, bltu_taken_ok # (10 < 0xFF...F6) -> true
    j test_fail
bltu_taken_ok:
    addi x30, x30, 1 # Điểm +1

    # Test 10: BLTU (unsigned, should not take)
    bltu x4, x1, test_fail # (0xFF...F6 < 10) -> false
    addi x30, x30, 1 # Điểm +1

    # Test 11: BGEU (unsigned, should take)
    bgeu x4, x1, bgeu_taken_ok # (0xFF...F6 >= 10) -> true
    j test_fail
bgeu_taken_ok:
    addi x30, x30, 1 # Điểm +1

    # Test 12: BGEU (unsigned, should not take)
    bgeu x1, x4, test_fail # (10 >= 0xFF...F6) -> false
    addi x30, x30, 1 # Điểm +1

    # Nếu tất cả 12 bài test đều đúng, x30 sẽ có giá trị là 12.
    # Để làm cho giá trị test độc nhất, ta cộng thêm một số.
    # Ví dụ: 12 + 6 = 18. Giá trị cuối cùng cần kiểm tra là 18.
    addi x30, x30, 6

    # --- PHẦN 3: LƯU KẾT QUẢ ĐỂ TESTBENCH XÁC MINH ---
    # Giá trị kỳ vọng là 18.
    sw x30, 500(x0)
    j done

test_fail:
    # Nếu có bất kỳ nhánh nào chạy sai, nó sẽ nhảy đến đây
    # và ghi một giá trị sai (ví dụ 999) vào bộ nhớ.
    addi x30, x0, 999
    sw x30, 500(x0)

done:
    beq x0, x0, done