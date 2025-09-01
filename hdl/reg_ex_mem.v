module reg_ex_mem(
    input               clk,
    input               rst_n,

    input               regwritee,
    input       [1:0]   resultsrce,
    input               memwritee,
    input       [31:0]  aluresulte,
    input       [31:0]  writedatae,
    input       [4:0]   rde,
    input       [31:0]  extimme,
    input       [6:0]   opcodee,
    input       [2:0]   funct3e,
    input       [31:0]  pcplus4e,

    output  reg         regwritem,
    output  reg [1:0]   resultsrcm,
    output  reg         memwritem,
    output  reg [31:0]  aluresultm,
    output  reg [31:0]  writedatam,
    output  reg [4:0]   rdm,
    output  reg [31:0]  extimmm,
    output  reg [6:0]   opcodem,
    output  reg [2:0]   funct3m,
    output  reg [31:0]  pcplus4m
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            regwritem   <= 1'b0;
            resultsrcm  <= 2'b0;
            memwritem   <= 1'b0;
            aluresultm  <= 32'b0;
            writedatam  <= 32'b0;
            rdm         <= 5'b0;
            extimmm     <= 31'b0;
            opcodem     <= 7'b0;
            funct3m     <= 3'b0;
            pcplus4m    <= 32'b0;
        end else begin
            regwritem   <= regwritee;
            resultsrcm  <= resultsrce;
            memwritem   <= memwritee;
            aluresultm  <= aluresulte;
            writedatam  <= writedatae;
            rdm         <= rde;
            extimmm     <= extimme;
            opcodem     <= opcodee;
            funct3m     <= funct3e;
            pcplus4m    <= pcplus4e;
        end
    end

endmodule