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

    reg [10:0] decode;

    assign {regwrite, immsrc, alusrc, memwrite, resultsrc, branch, aluop, jump} = decode;

    always @(op) begin
        case (op)
            7'b0110011: decode = 11'b1_XXX_0_0_00_0_10_0; // R-type_RV32I
            7'b0010011: decode = 11'b1_000_1_0_00_0_10_0; // I_type_RV32I
            7'b1100011: decode = 11'b0_010_0_0_XX_1_01_0; // B-type
            7'b0000011: decode = 11'b1_000_1_0_01_0_00_0; // Load
            7'b0100011: decode = 11'b0_001_1_1_00_0_00_0; // sw
            7'b1101111: decode = 11'b1_011_X_0_10_0_XX_1; // jump
            7'b0110111: decode = 11'b1_100_0_0_11_0_00_0; // lui
            default: decode = 11'bXXXXXXXXXXX;
        endcase
    end


endmodule