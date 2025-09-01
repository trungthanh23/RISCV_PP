module control_EM (
    input clk, rst_n, RegWriteE, MemWriteE,
    input [1:0] ResultSrcE,
    output reg [1:0] ResultSrcM,
    output reg RegWriteM, MemWriteM
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            RegWriteM <= 0;
            MemWriteM <= 0;
            ResultSrcM <= 0;
        end
        else begin
            RegWriteM <= RegWriteE;
            MemWriteM <= MemWriteE;
            ResultSrcM <= ResultSrcE;
        end
    end
endmodule
