module control_MW (
    input clk, rst_n, RegWriteM,
    input [1:0] ResultSrcM,
    output reg [1:0] ResultSrcW,
    output reg RegWriteW
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            RegWriteW <= 0;
            ResultSrcW <= 0;
        end
        else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
        end
    end
endmodule