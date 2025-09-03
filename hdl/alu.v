module alu (
    input               [31:0]  a,
    input               [31:0]  b,
    input               [3:0]   alucontrol,
    output  reg         [31:0]  result,
    output                      zero
);
  //---Localparam--//
  localparam ADD  = 4'b0000;
  localparam SUB  = 4'b0001;
  localparam AND  = 4'b0010;
  localparam OR   = 4'b0011;
  localparam SLL  = 4'b0100;
  localparam SLT  = 4'b0101;
  localparam SRL  = 4'b0110;
  localparam SRA  = 4'b0111;
  localparam XOR  = 4'b1000;
  localparam SLTU = 4'b1001;
  localparam BEQ  = 4'b1010;
  localparam BNE  = 4'b1011;
  localparam JALR = 4'b1100;
  localparam BGE  = 4'b1101;
  localparam BLTU = 4'b1110;
  localparam BGEU = 4'b1111;


  always @(a or b or alucontrol) begin
    case (alucontrol)
      ADD     : result = a + b;
      SUB     : result = a - b;
      AND     : result = a & b;
      OR      : result = a | b;
      SLL     : result = a << b[4:0];
      SRL     : result = a >> b[4:0];
      XOR     : result = a ^ b;
      SLT     : result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
      SRA     : result = $signed(a) >>> b[4:0];
      SLTU    : result = (a < b) ? 32'd1 : 32'd0; 
      BEQ     : result = (a == b) ? 32'd1 : 32'd0;
      BNE     : result = (a != b) ? 32'd1 : 32'd0;
      //BLT     : result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
      BGE     : result = ($signed(a) >= $signed(b)) ? 32'd1 : 32'd0;
      BLTU    : result = (a < b) ? 32'd1 : 32'd0;
      BGEU    : result = (a >= b) ? 32'd1 : 32'd0;
      JALR    : result = (a + b) & ~1;
      default : result = 32'b0;
    endcase
  end

  assign zero = (result == 32'b0);

endmodule