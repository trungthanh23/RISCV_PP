module control(
    input           funct7,
    input   [2:0]   funct3,
    input   [6:0]   op,
    output          regwrite,
    output  [1:0]   resultsrc,
    output          memwrite,
    output          jump,
    output          branch,
    output  [3:0]   alucontrol,
    output          alusrc,
    output          alusrcU,
    output  [2:0]   immsrc
);

    wire    [1:0]   aluop;

    main_decoder main_decoder(
        .op(op),
        .branch(branch),
        .jump(jump),
        .resultsrc(resultsrc),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .immsrc(immsrc),
        .regwrite(regwrite),
        .aluop(aluop)
    );

    alu_decoder alu_decoder(
        .funct3(funct3),
        .funct7(funct7),
        .aluop(aluop),
        .op5(op[5]),
        .alucontrol(alucontrol)
    );

endmodule
