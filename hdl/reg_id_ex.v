module reg_id_ex(
    input                   clk,
    input                   rst_n,

    input                   regwrited,
    input       [1:0]       resultsrcd,
    input                   memwrited,
    input                   jumpd,
    input                   branchd,
    input       [3:0]       alucontrold,
    input                   alusrcd,
    input                   alusrcd_u,
    input                   jal_or_jalr_d,

    input       [31:0]      rd1d,
    input       [31:0]      rd2d,

    input       [31:0]      pcd,
    input       [4:0]       rs1d,
    input       [4:0]       rs2d,
    input       [4:0]       rdd,
    input       [31:0]      extimmd,
    input       [6:0]       opcoded,
    input       [2:0]       funct3d,
    input       [31:0]      pcplus4d,

    input                   clr,

    output  reg             regwritee,
    output  reg [1:0]       resultsrce,
    output  reg             memwritee,
    output  reg             jumpe,
    output  reg             branche,
    output  reg [3:0]       alucontrole,
    output  reg             alusrce,
    output  reg             alusrce_u,
    output  reg             jal_or_jalr_e,
    output  reg [31:0]      rd1e,
    output  reg [31:0]      rd2e,
    output  reg [31:0]      pce,
    output  reg [4:0]       rs1e,
    output  reg [4:0]       rs2e,
    output  reg [4:0]       rde,
    output  reg [31:0]      extimme,
    output  reg [6:0]       opcodee,
    output  reg [2:0]       funct3e,
    output  reg [31:0]      pcplus4e
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            regwritee   <= 1'b0;
            resultsrce  <= 2'b0;
            memwritee   <= 1'b0;
            jumpe       <= 1'b0;
            branche     <= 1'b0;
            alucontrole <= 3'b0;
            alusrce     <= 1'b0;
            alusrce_u   <= 1'b0;
            jal_or_jalr_e <= 1'b0;
            rd1e        <= 32'b0;
            rd2e        <= 32'b0;
            pce         <= 32'b0;
            rs1e        <= 5'b0;
            rs2e        <= 5'b0;
            rde         <= 5'b0;
            extimme     <= 32'b0;
            opcodee     <= 7'b0;
            funct3e     <= 3'b0;    
            pcplus4e    <= 32'b0;
        end else if (clr) begin
            regwritee   <= 1'b0;
            resultsrce  <= 2'b0;
            memwritee   <= 1'b0;
            jumpe       <= 1'b0;
            branche     <= 1'b0;
            alucontrole <= 3'b0;
            alusrce     <= 1'b0;
            alusrce_u   <= 1'b0;
            jal_or_jalr_e <= 1'b0;
            rd1e        <= 32'b0;
            rd2e        <= 32'b0;
            pce         <= 32'b0;
            rs1e        <= 5'b0;
            rs2e        <= 5'b0;
            rde         <= 5'b0;
            extimme     <= 32'b0;
            opcodee     <= 7'b0;
            funct3e     <= 3'b0;
            pcplus4e    <= 32'b0;
        end else begin
            regwritee   <= regwrited;
            resultsrce  <= resultsrcd;
            memwritee   <= memwrited;
            jumpe       <= jumpd;
            branche     <= branchd;
            alucontrole <= alucontrold;
            alusrce     <= alusrcd;
            alusrce_u   <= alusrcd_u;
            jal_or_jalr_e <= jal_or_jalr_d;
            rd1e        <= rd1d;
            rd2e        <= rd2d;
            pce         <= pcd;
            rs1e        <= rs1d;
            rs2e        <= rs2d;
            rde         <= rdd;
            extimme     <= extimmd;
            opcodee     <= opcoded;
            funct3e     <= funct3d;
            pcplus4e    <= pcplus4d;
        end 
    end

endmodule
