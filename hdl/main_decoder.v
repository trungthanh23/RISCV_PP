module main_decoder(
    input   [6:0]   op,
    output          branch,
    output          jump,
    output          memwrite,
    output          alusrc,
    output          regwrite,
    output  [1:0]   aluop,
    output  [2:0]   immsrc,
    output  [1:0]   resultsrc
);

    reg [11:0] decode;

    assign {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = decode;

    always @(op) begin
        case (op)
            7'b0110011: decode = 12'b1XXX00000100; // R-type_RV32I
            7'b0010011: decode = 12'b100010000100; // I_type_RV32I
            7'b1100011: decode = 12'b001000XX1010; // B-type
            7'b0000011: decode = 12'b100010010000; // Load
            7'b0100011: decode = 12'b000111000000; // sw
            7'b1101111: decode = 12'b1011X0100XX1; // jump
            7'b0110111: decode = 12'b110000110000; // lui
            default: decode = 12'bXXXXXXXXXXX;
        endcase
    end


endmodule