# File: test_mem_access.s (Final Corrected Version)
# Mục tiêu: Kiểm tra toàn diện các lệnh Store và Load.

.globl main

main:
    # --- PHẦN 1: DÙNG LỆNH STORE ĐỂ SETUP BỘ NHỚ ---
    # Sử dụng lệnh giả "li" (Load Immediate) để nạp hằng số một cách an toàn và đúng đắn.
    # Trình biên dịch sẽ tự động chuyển các lệnh "li" này thành các lệnh phần cứng phù hợp.
    
    li x1, 0x1234ABCD
    li x2, 0x1234
    li x3, 0xABCD

    # Bắt đầu ghi vào các địa chỉ từ 200
    sw x1, 200(x0)      # Ghi word: Mem[200-203] = 1234ABCD
    sh x2, 204(x0)      # Ghi half (dương): Mem[204-205] = 1234
    sh x3, 206(x0)      # Ghi half (âm): Mem[206-207] = ABCD
    sb x2, 208(x0)      # Ghi byte (dương): Mem[208] = 34
    sb x3, 209(x0)      # Ghi byte (âm): Mem[209] = CD
    
    # --- PHẦN 2 & 3: LOAD VÀ STORE KẾT QUẢ ---
    # Toàn bộ phần còn lại của chương trình không thay đổi.
    lw  x10, 200(x0)
    lh  x11, 204(x0)
    lhu x12, 204(x0)
    lh  x13, 206(x0)
    lhu x14, 206(x0)
    lb  x15, 208(x0)
    lbu x16, 208(x0)
    lb  x17, 209(x0)
    lbu x18, 209(x0)

    # Lưu kết quả để testbench xác minh
    sw x10, 400(x0)
    sw x11, 404(x0)
    sw x12, 408(x0)
    sw x13, 412(x0)
    sw x14, 416(x0)
    sw x15, 420(x0)
    sw x16, 424(x0)
    sw x17, 428(x0)
    sw x18, 432(x0)

done:
    beq x0, x0, done