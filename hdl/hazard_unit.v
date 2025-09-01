module hazard_unit(
    //--Input--//
    input       [4:0]   rs1d,
    input       [4:0]   rs2d,
    
    input               pcsrce,
    input               resultsrce0,
    input       [4:0]   rs1e,
    input       [4:0]   rs2e,
    input       [4:0]   rde,

    input               regwritem,
    input       [4:0]   rdm,

    input               regwritew,
    input       [4:0]   rdw,

    //--Output--//
    output              stallf,
    output              stalld,
    output              flushd,

    output              flushe,

    output reg  [1:0]   forwardae,
    output reg  [1:0]   forwardbe
);
    wire                lwStall;

    //---Data hazard logic---//
    always @(*) begin
        if(((rs1e == rdm) && regwritem) && (rs1e != 5'b0)) begin
            forwardae = 2'b10;
        end else if (((rs1e == rdw) && regwritew) && (rs1e != 5'b0)) begin
            forwardae = 2'b01;
        end else begin
            forwardae = 2'b00;
        end
    end

    always @(*) begin
        if(((rs2e == rdm) && regwritem) && (rs2e != 5'b0)) begin
            forwardbe = 2'b10;
        end else if (((rs2e == rdw) && regwritew) && (rs2e != 5'b0)) begin
            forwardbe = 2'b01;
        end else begin
            forwardbe = 2'b00;
        end
    end   

    //---Load word stall logic---//
    assign lwStall  = ((rs1d == rde) || (rs2d == rde)) && resultsrce0;
    assign stallf   = lwStall;
    assign stalld   = lwStall;

    //---Control hazard flush--//
    assign flushd = pcsrce;
    assign flushe = lwStall || pcsrce;
endmodule