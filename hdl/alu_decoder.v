module alu_decoder(
    input       [2:0]   funct3,
    input               funct7,
    input               op5,
    input       [1:0]   aluop,
    output  reg [3:0]   alucontrol
);
    wire aludec;
    assign aludec = op5 & funct7;

    always @(aludec or funct3 or aluop) begin
        case (aluop)
            2'b00:  alucontrol = 4'b0000;
            2'b01:  begin
                case (funct3)
                    3'b000: alucontrol = 4'b0001;
                    3'b001: alucontrol = 4'b0001;
                    3'b100: alucontrol = 4'b0101;
                    3'b101: alucontrol = 4'b0101;
                    3'b110: alucontrol = 4'b1001;
                    3'b111: alucontrol = 4'b1001;
                    default: alucontrol = 4'b0001;
                endcase
            end
            
            2'b10: begin
              case (funct3)
                3'b000: begin
                  if (aludec) alucontrol = 4'b0001;
                  else        alucontrol = 4'b0000;
                end 
                3'b001: alucontrol = 4'b0100;
                3'b010: alucontrol = 4'b0101;
                3'b011: alucontrol = 4'b1001;
                3'b100: alucontrol = 4'b1000;
                3'b101: begin
                    if(funct7) alucontrol = 4'b0111;
                    else       alucontrol = 4'b0110;
                end
                3'b110: alucontrol = 4'b0011;
                3'b111: alucontrol = 4'b0010;
                default: alucontrol = 4'bxxxx;
              endcase
            end
            default: alucontrol = 4'bxxxx;
        endcase
    end

endmodule
