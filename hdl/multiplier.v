module multiplier (
    input           clk_i,
    input           rst_ni,
    input           start_i,        // Tín hiệu bắt đầu phép nhân
    input  [31:0]   operand_a_i,     // Toán hạng 1
    input  [31:0]   operand_b_i,     // Toán hạng 2
    input  [1:0]    func_i,          // Hàm chọn (00: MUL, 01: MULH, 10: MULHU, 11: MULHSU)
    output reg [31:0] result_o,      // Kết quả đầu ra
    output reg       mult_done_o         // Tín hiệu hoàn thành phép nhân
);

localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam COMPLETE = 2'b10;

reg [1:0]  state_q, state_d;
reg [63:0] product_q, product_d;
reg [31:0] a_q, a_d;
reg [31:0] b_q, b_d;
reg [5:0]  count_q, count_d;
reg sign_a, sign_b;

// Thanh ghi trạng thái
always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        state_q   <= IDLE;
        product_q <= 64'b0;
        a_q       <= 32'b0;
        b_q       <= 32'b0;
        count_q   <= 6'b0;
    end else begin
        state_q   <= state_d;
        product_q <= product_d;
        a_q       <= a_d;
        b_q       <= b_d;
        count_q   <= count_d;
    end
end

// FSM và logic điều khiển
always @(*) begin
    // Mặc định các giá trị
    state_d   = state_q;
    product_d = product_q;
    a_d       = a_q;
    b_d       = b_q;
    count_d   = count_q;
    mult_done_o   = 1'b0;
    result_o  = 32'b0;

    case (state_q)
        IDLE: begin
            if (start_i) begin
                // Khởi tạo các giá trị khi bắt đầu
                // case (func_i)
                //     2'b00, 2'b01: begin // MUL hoặc MULH
                //         sign_a = operand_a_i[31];
                //         sign_b = operand_b_i[31];
                //         a_d    = sign_a ? -operand_a_i : operand_a_i;
                //         b_d    = sign_b ? -operand_b_i : operand_b_i;
                //     end
                //     2'b10: begin // MULHU
                //         sign_a = 1'b0;
                //         sign_b = 1'b0;
                //         a_d    = operand_a_i;
                //         b_d    = operand_b_i;
                //     end
                //     2'b11: begin // MULHSU
                //         sign_a = operand_a_i[31];
                //         sign_b = 1'b0;
                //         a_d    = sign_a ? -operand_a_i : operand_a_i;
                //         b_d    = operand_b_i;
                //     end
                // endcase

                a_d = operand_a_i;
                b_d = operand_b_i;

                // Kiểm tra dấu của các toán hạng
                sign_a = (func_i != 2'b10) && operand_a_i[31];
                sign_b = (func_i == 2'b00 || func_i == 2'b01) && operand_b_i[31];

                // Tạo giá trị tuyệt đối của các toán hạng nếu cần
                if (sign_a) a_d = -operand_a_i;
                if (sign_b) b_d = -operand_b_i;


                product_d = 64'b0;
                count_d   = 6'b0;
                state_d   = CALC;
            end
        end

        CALC: begin
            if (count_q < 32) begin
                // Nếu b_q[0] == 1, cộng a_q vào product
                if (b_q[0]) begin
                    product_d = product_q + {32'b0, a_q};
                end
                a_d      = a_q << 1;  // Dịch trái a_q
                b_d      = b_q >> 1;  // Dịch phải b_q
                count_d  = count_q + 1;
            end else begin
                state_d = COMPLETE;  // Chuyển trạng thái khi đủ 32 chu kỳ
            end
        end

        COMPLETE: begin
            // Xử lý dấu nếu cần
            if ((sign_a ^ sign_b)) begin
                product_d = -product_q;
            end else begin
                product_d = product_q;
            end

            // Chọn kết quả dựa trên loại lệnh
            case (func_i)
                2'b00: result_o = product_d[31:0];   // MUL: phần thấp của sản phẩm
                2'b01: result_o = product_d[63:32];  // MULH: phần cao của sản phẩm có dấu
                2'b10: result_o = product_d[63:32];  // MULHU: phần cao của sản phẩm không dấu
                2'b11: result_o = product_d[63:32];  // MULHSU: phần cao của sản phẩm với a có dấu, b không dấu
            endcase
            mult_done_o = 1'b1;
            state_d = IDLE;
        end
    endcase
end

endmodule