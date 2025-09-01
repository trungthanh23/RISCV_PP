module register_file (
    input           clk,
    input           rst_n,
    input           we3,
    input   [4:0]   a1,
    input   [4:0]   a2,
    input   [4:0]   a3,
    input   [31:0]  wd3,
    output  [31:0]  rd1,
    output  [31:0]  rd2
);

    reg [31:0] register [31:0];
    integer i;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                register[i] <= 32'b0;
            end
        end else if ((we3 == 1'b1) && (a3 != 5'b0)) begin
            register[a3] <= wd3;
        end
    end

    assign rd1 = (a1 == 5'b0) ? 32'b0 : register[a1];
    assign rd2 = (a2 == 5'b0) ? 32'b0 : register[a2];

endmodule