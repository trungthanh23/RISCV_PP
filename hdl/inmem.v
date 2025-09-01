module inmem(
    input  [31:0]   a,
    output [31:0]   rd
);
    reg [31:0] mem [63:0];

    initial begin
        $readmemh("/home/thanhtrung/Code/Project/RICS-V Processor/sim/src/RISCV_PP_Test/RV32I_Test/Load_and_Store_test/RISC_V_PP_load_and_store.txt", mem);
    end

    assign rd = mem[a[31:2]];

endmodule