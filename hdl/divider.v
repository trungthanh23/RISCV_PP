module divider (
    input           clk_i,
    input           rst_ni,
    input           start_i,
    input  [31:0]   operand_a_i,
    input  [31:0]   operand_b_i,
    input  [1:0]    func_i,          // Function select (00: DIV, 01: DIVU, 10: REM, 11: REMU)
    output reg [31:0] result_o,      // Output result
    output reg       div_done_o         // Output valid signal
);

localparam IDLE        = 3'b000;
localparam EXECUTE     = 3'b001;
localparam COMPLETE    = 3'b010;

reg [2:0] state_q, state_d;
reg [31:0] quotient_q, quotient_d;
reg [31:0] remainder_q, remainder_d;
reg [31:0] dividend_q, dividend_d;
reg [31:0] divisor_q, divisor_d;
reg [5:0]  count_q, count_d;
reg        sign_a, sign_b;

always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        state_q <= IDLE;
        quotient_q <= 32'b0;
        remainder_q <= 32'b0;
        dividend_q <= 32'b0;
        divisor_q <= 32'b0;
        count_q <= 6'b0;
    end else begin
        state_q <= state_d;
        quotient_q <= quotient_d;
        remainder_q <= remainder_d;
        dividend_q <= dividend_d;
        divisor_q <= divisor_d;
        count_q <= count_d;
    end
end

always @(*) begin
    state_d = state_q;
    quotient_d = quotient_q;
    remainder_d = remainder_q;
    dividend_d = dividend_q;
    divisor_d = divisor_q;
    count_d = count_q;
    div_done_o = 1'b0;
    result_o = 32'b0;

    case (state_q)
        IDLE: begin
            if (start_i) begin
                sign_a = (func_i == 2'b00 || func_i == 2'b10) && operand_a_i[31];
                sign_b = (func_i == 2'b00 || func_i == 2'b10) && operand_b_i[31];

                // Absolute value of dividend and divisor
                dividend_d = sign_a ? -operand_a_i : operand_a_i;
                divisor_d = sign_b ? -operand_b_i : operand_b_i;

                quotient_d = 32'b0;
                remainder_d = 32'b0;
                count_d = 6'd32; // 32-bit division

                state_d = EXECUTE;
            end
        end

        EXECUTE: begin
            if (count_q > 0) begin
                // Shift left remainder and bring down next dividend bit
                remainder_d = {remainder_q[30:0], dividend_q[31]};
                dividend_d = {dividend_q[30:0], 1'b0};

                // Subtract divisor from remainder and update quotient
                if (remainder_d >= divisor_q) begin
                    remainder_d = remainder_d - divisor_q;
                    quotient_d = {quotient_q[30:0], 1'b1};
                end else begin
                    quotient_d = {quotient_q[30:0], 1'b0};
                end

                count_d = count_q - 1;
            end else begin
                state_d = COMPLETE;
            end
        end

        COMPLETE: begin
            // Adjust sign of quotient and remainder if needed
            if (func_i == 2'b00 || func_i == 2'b10) begin
                if (sign_a ^ sign_b) begin
                    quotient_d = -quotient_q;  // Adjust quotient sign
                end
                if (sign_a) begin
                    remainder_d = -remainder_q; // Adjust remainder sign if dividend was negative
                end
            end

            // Output result based on function
            case (func_i)
                2'b00: result_o = quotient_d;   // DIV
                2'b01: result_o = quotient_d;   // DIVU
                2'b10: result_o = remainder_d;  // REM
                2'b11: result_o = remainder_d;  // REMU
            endcase
            div_done_o = 1'b1;
            state_d = IDLE;
        end
    endcase
end

endmodule