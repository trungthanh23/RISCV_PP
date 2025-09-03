module extend (
    input   [31:0]  instr,
    input   [2:0]   immsrc,
    output  [31:0]  extimm
);

    reg [31:0] extimmreg;

    always @(*) begin
        case (immsrc)
            3'b000 : extimmreg = {{20{instr[31]}}, instr[31:20]}; 
            3'b001 : extimmreg = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            3'b010 : extimmreg = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            3'b011 : extimmreg = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            3'b100 : extimmreg = {instr[31:12], 12'b0}; 
            default: extimmreg = 32'd0;
        endcase
    end

    assign extimm = extimmreg;
endmodule