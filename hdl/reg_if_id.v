module reg_if_id(
    input               clk,
    input               rst_n,
    input               en_n,
    input               clr,
    input       [31:0]  rdf,
    input       [31:0]  pcplus4f,
    input       [31:0]  pcf,
    output  reg [31:0]  instrd,
    output  reg [31:0]  pcd,
    output  reg [31:0]  pcplus4d
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            instrd      <=  32'b0;
            pcd         <=  32'b0;
            pcplus4d    <=  32'b0;
        end else if (clr) begin
            instrd      <=  32'b0;
            pcd         <=  32'b0;
            pcplus4d    <=  32'b0;
        end else if (!en_n) begin
            instrd      <=  rdf;
            pcd         <=  pcf;
            pcplus4d    <=  pcplus4f;
        end else begin
            instrd      <=  instrd;
            pcd         <=  pcd;
            pcplus4d    <=  pcplus4d;
        end
    end
    
endmodule