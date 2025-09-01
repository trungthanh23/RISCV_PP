module reg_mem_wb (
    input               clk,
    input               rst_n,

    input               regwritem,
    input       [1:0]   resultsrcm,
    input       [31:0]  aluresultm,
    input       [31:0]  readdatam,
    input       [4:0]   rdm,
    input       [31:0]  extimmm,
    input       [31:0]  pcplus4m,

    output  reg         regwritew,
    output  reg [1:0]   resultsrcw,
    output  reg [31:0]  aluresultw,
    output  reg [31:0]  readdataw,
    output  reg [4:0]   rdw, 
    output  reg [31:0]  extimmw,   
    output  reg [31:0]  pcplus4w
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            regwritew   <= 1'b0;
            resultsrcw  <= 2'b00;
            aluresultw  <= 32'b0;
            readdataw   <= 32'b0;
            rdw         <= 5'b0;
            extimmw     <= 32'b0;
            pcplus4w    <= 32'b0;
        end else begin
            regwritew   <= regwritem;
            resultsrcw  <= resultsrcm;
            aluresultw  <= aluresultm;
            readdataw   <= readdatam;
            rdw         <= rdm;
            extimmw     <= extimmm;
            pcplus4w    <= pcplus4m;
        end
    end

endmodule