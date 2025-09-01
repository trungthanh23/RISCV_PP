`timescale 1ns/1ps

module RISC_V_pp_top_R_type_tb();

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
    
    integer success_count = 0;
    integer error_count = 0;

    // Checking program
    always @(negedge clk) begin
        if (MemWrite) begin
            case (DataAdr)
                100: if (WriteData === 25) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: ADD test failed! Wrote %d, expected 25", WriteData);
                         error_count <= error_count + 1;
                     end
                104: if (WriteData === 5) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: SUB test failed! Wrote %d, expected 5", WriteData);
                         error_count <= error_count + 1;
                     end
                108: if (WriteData === 5) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: XOR test failed! Wrote %d, expected 5", WriteData);
                         error_count <= error_count + 1;
                     end
                112: if (WriteData === 15) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: OR test failed! Wrote %d, expected 15", WriteData);
                         error_count <= error_count + 1;
                     end
                116: if (WriteData === 10) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: AND test failed! Wrote %d, expected 10", WriteData);
                         error_count <= error_count + 1;
                     end
                120: if (WriteData === 60) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: SLL test failed! Wrote %d, expected 60", WriteData);
                         error_count <= error_count + 1;
                     end
                124: if (WriteData === 3) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: SRL test failed! Wrote %d, expected 3", WriteData);
                         error_count <= error_count + 1;
                     end
                128: if (WriteData === 32'hFFFFFFFF) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: SRA test failed! Wrote %h, expected FFFFFFFF", WriteData);
                         error_count <= error_count + 1;
                     end
                132: if (WriteData === 1) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: SLT test failed! Wrote %d, expected 1", WriteData);
                         error_count <= error_count + 1;
                     end
                136: if (WriteData === 0) success_count <= success_count + 1;
                     else begin
                         $display("ERROR: SLTU test failed! Wrote %d, expected 0", WriteData);
                         error_count <= error_count + 1;
                     end
                default: begin
                    $display("ERROR: Wrote to unexpected address %d", DataAdr);
                    error_count <= error_count + 1;
                end
            endcase
        end
    end


    initial begin
        #1000; 

        if (error_count == 0 && success_count == 10) begin
            $display("        ************************************               ");
			$display("        **                                **       |\__||  ");
			$display("        **  Congratulations !!            **      / O.O  | ");
			$display("        **  R-type instructions passed!   **    /_____   | ");
			$display("        **  SIMULATION PASS !!            **   /^ ^ ^ \\  |");
			$display("        **                                **  |^ ^ ^ ^ |w| ");
			$display("        ************************************   \\m___m__|_|");
			$display("\n");
        end else begin
            $display("\n");
            $display("        **************************************** ");
            $display("        **                                    **       |\__||  ");
            $display("        ** OOPS!!                             **      / X,X  | ");
            $display("        ** R-type instruction failed!! =((    **    / _____  | ");
            $display("        ** SIMULATION FAILED!!                **   /^ ^ ^ \\  |");
            $display("        **                                    **  |^ ^ ^ ^ |w| ");
            $display("        ****************************************   \\m___m__|_|");
            $display("        ** Passed: %0d/10, Failed: %0d/10     **", success_count, error_count);
            $display("        ****************************************                 ");
        end
        
        $stop; 
    end

endmodule