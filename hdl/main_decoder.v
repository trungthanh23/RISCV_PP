module main_decoder(
    input   [6:0]   op,
    output reg       branch,
    output reg       jump,
    output reg       memwrite,
    output reg       alusrc,
    output reg       alusrcU,
    output reg       regwrite,
    output reg [1:0] aluop,
    output reg [2:0] immsrc,
    output reg [1:0] resultsrc
);

    always @(*) begin
        // giá trị mặc định (tránh latch)
        regwrite  = 0;
        immsrc    = 3'b000;
        alusrcU   = 0;
        alusrc    = 0;
        memwrite  = 0;
        resultsrc = 2'b00;
        branch    = 0;
        aluop     = 2'b00;
        jump      = 0;

        case (op)
            7'b0110011: begin // R-type
                regwrite  = 1;
                aluop     = 2'b10;
            end

            7'b0010011: begin // I-type (ADDI, SLTI, ANDI, ORI, XORI, SLLI, SRLI, SRAI)
                regwrite  = 1;
                alusrc    = 1;
                aluop     = 2'b10;
            end

            7'b0000011: begin // Load (LW)
                regwrite  = 1;
                alusrc    = 1;
                resultsrc = 2'b01; // lấy dữ liệu từ memory
            end

            7'b0100011: begin // S-type (SW)
                alusrc    = 1;
                memwrite  = 1;
                immsrc    = 3'b001;
            end

            7'b1100011: begin // B-type (BEQ, BNE, BLT, ...)
                branch    = 1;
                aluop     = 2'b01;
                immsrc    = 3'b010;
            end

            7'b1101111: begin // J-type (JAL)
                regwrite  = 1;
                jump      = 1;
                immsrc    = 3'b011;
                resultsrc = 2'b10; // PC+4
            end

            7'b0110111: begin // LUI
                regwrite  = 1;
                alusrcU   = 1;  // dùng immediate kiểu U
                immsrc    = 3'b100;
                resultsrc = 2'b11;
            end

            7'b0010111: begin // AUIPC
                regwrite  = 1;
                immsrc    = 3'b100;
                resultsrc = 2'b11;
            end
        endcase
    end
endmodule
