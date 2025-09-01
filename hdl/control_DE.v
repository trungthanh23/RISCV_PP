module control_DE (
    input clk, rst_n, clr, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD_A,
    input [1:0] ResultSrcD, ALUSrcD_B,
    input [3:0] ALUControlD,
    output reg RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE_A,
    output reg [1:0] ResultSrcE, ALUSrcE_B,
    output reg [3:0] ALUControlE
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            RegWriteE <= 0;
			MemWriteE <= 0;
			JumpE <= 0;
			BranchE <= 0; 
			ALUSrcE_B <= 0;
            ALUSrcE_A <=0;
			ResultSrcE <= 0;
			ALUControlE <= 0;
        end
        else if (clr) begin
                RegWriteE <= 0;
                MemWriteE <= 0;
                JumpE <= 0;
                BranchE <= 0; 
                ALUSrcE_B <= 0;       
                ALUSrcE_A <=0;
                ResultSrcE <= 0;
                ALUControlE <= 0;
            end
            else begin
                RegWriteE <= RegWriteD;
                MemWriteE <= MemWriteD;
                JumpE <= JumpD;
                BranchE <= BranchD; 
                ALUSrcE_B <= ALUSrcD_B;
                ALUSrcE_A <= ALUSrcD_A;
                ResultSrcE <= ResultSrcD;
                ALUControlE <= ALUControlD;   
            end
	 end
endmodule
