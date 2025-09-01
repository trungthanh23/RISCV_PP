module datamem(
    input           clk,
    input           we,
    input   [3:0]   be,
    input   [31:0]  a,
    input   [31:0]  wd,
    output  [31:0]  rd
);
    /*verilator public*/ reg [31:0] ram [1023:0];

    assign rd = ram[a[31:2]];

    always @(posedge clk) begin
        if (we) begin
            if (be[0]) ram[a[31:2]][7:0]   <= wd[7:0];
            if (be[1]) ram[a[31:2]][15:8]  <= wd[15:8];
            if (be[2]) ram[a[31:2]][23:16] <= wd[23:16];
            if (be[3]) ram[a[31:2]][31:24] <= wd[31:24];
            else begin 
            end
        end else begin
        end
    end
endmodule