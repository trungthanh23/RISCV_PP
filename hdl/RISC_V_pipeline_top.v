module RISC_V_pipeline_top (
    input           clk,
    input           rst_n,
    output  [31:0]  writedata, dataadr,
    output          memwrite
);
    /*-----------------------------------------------Define parameter-----------------------------------------------*/ 

    //-----Global-----//
    //---Fetch---//
    //---Decode---//
    //---Execute---//
    //---Memory---//
    //---Write Back---//
    /*--------------------------------------------------Define Wire-------------------------------------------------*/

    //--Fetch--//
    wire            StallF;
    wire    [31:0]  RDF;
    wire    [31:0]  PCPlus4F;
    reg     [31:0]  PCF_mux_out_1;
    reg     [31:0]  PCF_mux_out_2;
    reg     [31:0]  PCF;

    //--Decode--//
    wire            FlushD; 
    wire            StallD;           

    wire            RegWriteD;
    wire    [1:0]   ResultSrcD;
    wire            MemWriteD;
    wire            JumpD;
    wire            BranchD;
    wire    [3:0]   ALUControlD;
    wire            ALUSrcD;
    wire            ALUSrcD_U;
    wire            jal_or_jalr_D;
    
    wire    [2:0]   ImmSrcD;

    wire    [31:0]  InstrD;

    wire    [31:0]  RD1D;
    wire    [31:0]  RD2D;
    wire    [31:0]  PCD;
    wire    [4:0]   Rs1D;
    wire    [4:0]   Rs2D;
    wire    [4:0]   RdD;  
    wire    [31:0]  ExtImmD;
    wire    [6:0]   opcodeD;
    wire    [2:0]   funct3D;
    wire    [31:0]  PCPlus4D;

    //--Execute--//
    wire            FlushE;
    wire    [1:0]   ForwardAE;
    wire    [1:0]   ForwardBE;

    wire            RegWriteE;
    wire    [1:0]   ResultSrcE;
    wire            MemWriteE;
    wire            JumpE;
    wire            BranchE;
    wire    [3:0]   ALUControlE;
    wire            ALUSrcE;
    wire            ALUSrcE_U;
    wire            jal_or_jalr_E;
    reg     [31:0]  imm_U_typeE;
    reg             BranchTypeE;
    wire    [31:0]  RD1E;
    wire    [31:0]  RD2E;
    wire    [31:0]  PCE;
    wire    [4:0]   Rs1E;
    wire    [4:0]   Rs2E;
    wire    [4:0]   RdE;
    wire    [31:0]  ExtImmE;
    wire    [6:0]   opcodeE;
    wire    [2:0]   funct3E;
    wire    [31:0]  PCPlus4E;
    wire    [31:0]  PCTargetE;

    wire            PCSrcE;
    wire            ZeroE;
    reg     [31:0]  SrcAE;
    reg     [31:0]  SrcBE;
    reg     [31:0]  WriteDataE;
    wire    [31:0]  ALUResultE;
    //--Memory--//
    wire            RegWriteM;
    wire    [1:0]   ResultSrcM;
    wire            MemWriteM;

    wire    [31:0]  ALUResultM;
    wire    [31:0]  WriteDataM;
    reg     [31:0]  WD_M;
    reg     [3:0]   write_type_M;
    wire    [31:0]  RD_M;
    wire    [4:0]   RdM;
    wire    [31:0]  ExtImmM;
    wire    [6:0]   opcodeM;
    wire    [2:0]   funct3M;
    reg     [31:0]  ReadDataM;
    wire    [31:0]  PCPlus4M;
    
    //--Write_Back--//
    wire            RegWriteW;
    wire    [1:0]   ResultSrcW;

    wire    [31:0]  ALUResultW;
    wire    [31:0]  ReadDataW;
    wire    [4:0]   RdW;
    wire    [31:0]  ExtImmW;
    wire    [31:0]  PCPlus4W;
    reg     [31:0]  ResultW;


    /*---------------------------------------------------Design----------------------------------------------------*/
    //-----------------------Fetch state-----------------------//
    always @(*) begin
        if (jal_or_jalr_E) PCF_mux_out_1 = ALUResultE;
        else PCF_mux_out_1 = PCTargetE;
    end

    always @(*) begin
        if(PCSrcE)  PCF_mux_out_2 = PCF_mux_out_1;
        else        PCF_mux_out_2 = PCPlus4F;
    end

    //--PC--//
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) PCF <= 32'b0;
        else if (!StallF) PCF <= PCF_mux_out_2;
        else PCF <= PCF; 
    end

    assign PCPlus4F = PCF + 32'd4;
    
    inmem inmem(
        .a(PCF),
        .rd(RDF)
    );

    reg_if_id reg_if_id(
        .clk(clk),
        .rst_n(rst_n),
        .en_n(StallD),
        .clr(FlushD),
        .rdf(RDF),
        .pcplus4f(PCPlus4F),
        .pcf(PCF),
        .instrd(InstrD),
        .pcd(PCD),
        .pcplus4d(PCPlus4D)
    );

    //-----------------------Decode state-----------------------//

    //control unit
    control control(
        .funct7(InstrD[30]),
        .funct3(InstrD[14:12]),
        .op(InstrD[6:0]),
        .regwrite(RegWriteD),
        .resultsrc(ResultSrcD),
        .memwrite(MemWriteD),
        .jump(JumpD),
        .branch(BranchD),
        .alucontrol(ALUControlD),
        .alusrc(ALUSrcD),
        .alusrcU(ALUSrcD_U),
        .jal_or_jalr(jal_or_jalr_D),
        .immsrc(ImmSrcD)
    );

    register_file register_file(
        .clk(clk),
        .rst_n(rst_n),
        .we3(RegWriteW),
        .a1(InstrD[19:15]),
        .a2(InstrD[24:20]),
        .a3(RdW),
        .wd3(ResultW),
        .rd1(RD1D),
        .rd2(RD2D)
    );

    assign Rs1D     = InstrD[19:15];
    assign Rs2D     = InstrD[24:20];
    assign RdD      = InstrD[11:7];
    assign funct3D  = InstrD[14:12];
    assign opcodeD  = InstrD[6:0];

    extend extend(
        .instr(InstrD),
        .immsrc(ImmSrcD),
        .extimm(ExtImmD)
    );

    reg_id_ex reg_id_ex(
        .clk(clk),
        .rst_n(rst_n),
        .regwrited(RegWriteD),
        .resultsrcd(ResultSrcD),
        .memwrited(MemWriteD),
        .jumpd(JumpD),
        .branchd(BranchD),
        .alucontrold(ALUControlD),
        .alusrcd(ALUSrcD),
        .alusrcd_u(ALUSrcD_U),
        .jal_or_jalr_d(jal_or_jalr_D),
        .rd1d(RD1D),
        .rd2d(RD2D),
        .pcd(PCD),
        .rs1d(Rs1D),
        .rs2d(Rs2D),
        .rdd(RdD),
        .extimmd(ExtImmD),
        .opcoded(opcodeD),
        .funct3d(funct3D),        
        .pcplus4d(PCPlus4D),
        .clr(FlushE),
        .regwritee(RegWriteE),
        .resultsrce(ResultSrcE),
        .memwritee(MemWriteE),
        .jumpe(JumpE),
        .branche(BranchE),
        .alucontrole(ALUControlE),
        .alusrce(ALUSrcE),
        .alusrce_u(ALUSrcE_U),
        .jal_or_jalr_e(jal_or_jalr_E),
        .rd1e(RD1E),
        .rd2e(RD2E),
        .pce(PCE),
        .rs1e(Rs1E),
        .rs2e(Rs2E),
        .rde(RdE),
        .extimme(ExtImmE),
        .opcodee(opcodeE),
        .funct3e(funct3E),
        .pcplus4e(PCPlus4E)
    );

    //-----------------------Execute state-----------------------//
    
    always @(*) begin
        if(ForwardAE[1])        SrcAE = ALUResultM;
        else if(ForwardAE[0])   SrcAE = ResultW;
        else                    SrcAE = RD1E;
    end

    always @(*) begin
        if(ForwardBE[1])        WriteDataE = ALUResultM;
        else if(ForwardBE[0])   WriteDataE = ResultW;
        else                    WriteDataE = RD2E;
    end

    always @(*) begin
        if(ALUSrcE)     SrcBE = ExtImmE;
        else            SrcBE = WriteDataE;
    end

    assign PCTargetE = PCE + ExtImmE;
    
    always @(*) begin
        if (ALUSrcE_U) imm_U_typeE = ExtImmE;
        else imm_U_typeE = PCTargetE;
    end
    alu alu(
        .a(SrcAE),
        .b(SrcBE),
        .alucontrol(ALUControlE),
        .result(ALUResultE),
        .zero(ZeroE)
    );
    always @(*) begin //sủ dụng funct3e để kiểm tra loại branch, ở đyâ thay vì ta lấy trực tiếp SrcAE và WriteDataE (tránh SrcBE dễ dính Imm) để tính
        case (funct3E)
            3'b000: BranchTypeE = (SrcAE == WriteDataE);                     // BEQ
            3'b001: BranchTypeE = (SrcAE != WriteDataE);                     // BNE
            3'b100: BranchTypeE = ($signed(SrcAE) < $signed(WriteDataE));    // BLT (signed)
            3'b101: BranchTypeE = ($signed(SrcAE) >= $signed(WriteDataE));   // BGE (signed)
            3'b110: BranchTypeE = (SrcAE < WriteDataE);                      // BLTU (unsigned)
            3'b111: BranchTypeE = (SrcAE >= WriteDataE);                     // BGEU (unsigned)
            default: BranchTypeE = 1'b0;
        endcase
    end
    assign PCSrcE = (BranchTypeE & BranchE) | JumpE; //Nếu dùng Branch thì brnachE nhảy lên 1, sẽ tùy thuộc vào funct3e và branchtypeE để nhảy tiếp

    reg_ex_mem reg_ex_mem(
        .clk(clk),
        .rst_n(rst_n),
        .regwritee(RegWriteE),
        .resultsrce(ResultSrcE),
        .memwritee(MemWriteE),
        .aluresulte(ALUResultE),
        .writedatae(WriteDataE),
        .rde(RdE),
        .extimme(imm_U_type),
        .opcodee(opcodeE),
        .funct3e(funct3E),
        .pcplus4e(PCPlus4E),
        .regwritem(RegWriteM),
        .resultsrcm(ResultSrcM),
        .memwritem(MemWriteM),
        .aluresultm(ALUResultM),
        .writedatam(WriteDataM),
        .rdm(RdM),
        .extimmm(ExtImmM),
        .opcodem(opcodeM),
        .funct3m(funct3M),
        .pcplus4m(PCPlus4M)
    );

    //-----------------------Memory state-----------------------//
    
    always @(*) begin
        if (opcodeM == 7'b0100011) begin //Store
            if (funct3M == 3'b000) begin //sb
                write_type_M = 4'b0001 << ALUResultM[1:0];
            end else if (funct3M == 3'b001) begin
                case (ALUResultM[1:0]) //sh
                    2'b00  : write_type_M = 4'b0011;
                    2'b01  : write_type_M = 4'b0110;
                    2'b10  : write_type_M = 4'b1100;
                    2'b11  : write_type_M = 4'b1000; 
                    default: write_type_M = 4'b0011;
                endcase
            end else begin //sw
                write_type_M = 4'b1111;
            end
        end else if (opcodeM == 7'b0000011) begin // Load
            if (funct3M == 3'b000) begin
                case (ALUResultM[1:0]) //lb
                    2'b00   : ReadDataM = {{24{RD_M[7 ]}}, RD_M[7 :0]};
                    2'b01   : ReadDataM = {{24{RD_M[15]}}, RD_M[15:8]};
                    2'b10   : ReadDataM = {{24{RD_M[23]}}, RD_M[23:16]};
                    2'b11   : ReadDataM = {{24{RD_M[31]}}, RD_M[31:24]};
                    default : ReadDataM = {{24{RD_M[7 ]}}, RD_M[7 :0]};
                endcase 
            end else if (funct3M == 3'b001) begin //lh
                case (ALUResultM[1:0])
                    2'b00   : ReadDataM = {{16{RD_M[15]}}, RD_M[15:0]};
                    2'b10   : ReadDataM = {{16{RD_M[31]}}, RD_M[31:16]};
                    default : ReadDataM = {{16{RD_M[15]}}, RD_M[15:0]};
                endcase 
            end else if (funct3M == 3'b010) begin //lw
                ReadDataM = RD_M;
            end else if (funct3M == 3'b100) begin //lbu
                case (ALUResultM[1:0])
                    2'b00   : ReadDataM = {24'b0, RD_M[7 :0]};
                    2'b01   : ReadDataM = {24'b0, RD_M[15:8]};
                    2'b10   : ReadDataM = {24'b0, RD_M[23:16]};
                    2'b11   : ReadDataM = {24'b0, RD_M[31:24]};
                    default : ReadDataM = {24'b0, RD_M[7 :0]};
                endcase
            end else if (funct3M == 3'b101) begin //lhu
                case (ALUResultM[1:0])
                    2'b00   : ReadDataM = {16'b0, RD_M[15:0]};
                    2'b10    : ReadDataM = {16'b0, RD_M[31:16]};
                    default : ReadDataM = {16'b0, RD_M[15:0]};
                endcase
            end else begin
                ReadDataM = RD_M;
            end
        end
    end

    always @(*) begin
        case (ALUResultM[1:0])
            2'b00   : WD_M = WriteDataM;
            2'b01   : WD_M = {WriteDataM[23:0], WriteDataM[31:24]};
            2'b10   : WD_M = {WriteDataM[15:0], WriteDataM[31:16]};
            2'b11   : WD_M = {WriteDataM[7 :0], WriteDataM[31: 8]};
            default : WD_M = WriteDataM; 
        endcase
    end

    datamem datamem(
        .clk(clk),
        .we(MemWriteM),
        .a(ALUResultM),
        .be(write_type_M),
        .wd(WD_M),
        .rd(RD_M)
    );


    reg_mem_wb reg_mem_wb(
        .clk(clk),
        .rst_n(rst_n),
        .regwritem(RegWriteM),
        .resultsrcm(ResultSrcM),
        .aluresultm(ALUResultM),
        .readdatam(ReadDataM),
        .rdm(RdM),
        .extimmm(ExtImmM),
        .pcplus4m(PCPlus4M),
        .regwritew(RegWriteW),
        .resultsrcw(ResultSrcW),
        .aluresultw(ALUResultW),
        .readdataw(ReadDataW),
        .rdw(RdW),
        .extimmw(ExtImmW),
        .pcplus4w(PCPlus4W)
    );

    //-----------------------Writeback state-----------------------//
    always @(*) begin
        case (ResultSrcW)
            2'b00 : ResultW = ALUResultW;
            2'b01 : ResultW = ReadDataW;
            2'b10 : ResultW = PCPlus4W;
            2'b11 : ResultW = ExtImmW;
            default: ResultW = ALUResultW;
        endcase
    end

    //-----------------------Hazard Unit-----------------------//
    hazard_unit hazard_unit(
        .rs1d(Rs1D),
        .rs2d(Rs2D),
        .pcsrce(PCSrcE),
        .resultsrce0(ResultSrcE[0]),
        .rs1e(Rs1E),
        .rs2e(Rs2E),
        .rde(RdE),
        .regwritem(RegWriteM),
        .rdm(RdM),
        .regwritew(RegWriteW),
        .rdw(RdW),
        .stallf(StallF),
        .stalld(StallD),
        .flushd(FlushD),
        .flushe(FlushE),
        .forwardae(ForwardAE),
        .forwardbe(ForwardBE)
    );

    /*-----------------------------------Final Output Connection-----------------------------------*/
    assign dataadr = ALUResultM;
    assign writedata = WriteDataM;
    assign memwrite = MemWriteM;

endmodule
