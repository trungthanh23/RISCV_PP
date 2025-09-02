`timescale 1ns/1ps

module RISC_V_pp_top_Branch_tb();

    reg  clk;
    reg  rst_n;
    wire [31:0] WriteData, DataAdr;
    wire MemWrite;

    RISC_V_pipeline_top dut(
        .clk(clk), 
        .rst_n(rst_n), 
        .writedata(WriteData), 
        .dataadr(DataAdr), 
        .memwrite(MemWrite)
    );

    initial begin
        rst_n <= 1'b0; 
        #22;
        rst_n <= 1'b1;
    end

    always begin
        clk <= 1'b1; #5; 
        clk <= 1'b0; #5;
    end
    
    // =================================================================
    // =                     Verification Logic                        =
    // =================================================================

    always @(negedge clk) begin
        if (MemWrite) begin
            // Chỉ quan tâm đến địa chỉ xác minh cuối cùng
            if (DataAdr == 500) begin
                if (WriteData == 18) begin
                    $display("        ************************************               ");
			        $display("        **                                **       |\__||  ");
			        $display("        **  Congratulations !!            **      / O.O  | ");
			        $display("        **  Branch instructions passed!   **    /_____   | ");
			        $display("        **  SIMULATION PASS !!            **   /^ ^ ^ \\  |");
			        $display("        **                                **  |^ ^ ^ ^ |w| ");
			        $display("        ************************************   \\m___m__|_|");
                    $display("\nSUCCESS: All 12 branch test cases passed! Final score: %d", WriteData);
                    $stop;
                end else begin
                    $display("\n");
                    $display("        ****************************************               ");
                    $display("        **                                    **       |\__||  ");
                    $display("        ** OOPS!!                             **      / X,X  | ");
                    $display("        ** Branch instruction failed!! =((    **    / _____  | ");
                    $display("        ** SIMULATION FAILED!!                **   /^ ^ ^ \\  |");
                    $display("        **                                    **  |^ ^ ^ ^ |w| ");
                    $display("        ****************************************   \\m___m__|_|");
                    $display("\n      FAILED: Branch test logic is incorrect!");
                    $display("\n      Final score was %d, but expected 18.", WriteData);
                    $stop;
                end
            end
        end
    end

    // Khối timeout
    initial begin
        #3000;
        $display("\n");
        $display("        **************************************** ");
        $display("        **                                    **       |\__||  ");
        $display("        ** OOPS!!                             **      / X,X  | ");
        $display("        ** Branch instruction failed!! =((    **    / _____  | ");
        $display("        ** SIMULATION FAILED!!                **   /^ ^ ^ \\  |");
        $display("        **                                    **  |^ ^ ^ ^ |w| ");
        $display("        ****************************************   \\m___m__|_|");
        $display("\n    FAILED: Simulation timed out! The processor may be stuck.");
        $stop;
    end

endmodule