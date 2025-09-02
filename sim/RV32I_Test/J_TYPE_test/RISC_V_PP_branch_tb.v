`timescale 1ns/1ps

module RISC_V_pp_top_I_type_tb();

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

    always @(negedge clk) begin
        if (MemWrite) begin
            case (DataAdr)
                240: if (WriteData === 32'h11) begin
                         success_count <= success_count + 1;
                     end else begin
                         $display("ERROR: JAL test failed!, data is %08h", WriteData);  
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
        #3000; 

        if (error_count == 0 && success_count == 1) begin
            $display("        ************************************               ");
			$display("        **                                **       |\__||  ");
			$display("        **  Congratulations !!            **      / O.O  | ");
			$display("        **  JAL instruction passed!       **    /_____   | ");
			$display("        **  SIMULATION PASS !!            **   /^ ^ ^ \\  |");
			$display("        **                                **  |^ ^ ^ ^ |w| ");
			$display("        ************************************   \\m___m__|_|");
			$display("\n");
        end else begin
            $display("\n");
            $display("        **************************************** ");
            $display("        **                                    **       |\__||  ");
            $display("        ** OOPS!!                             **      / X,X  | ");
            $display("        ** JAL instruction failed!! =((       **    / _____  | ");
            $display("        ** SIMULATION FAILED!!                **   /^ ^ ^ \\  |");
            $display("        **                                    **  |^ ^ ^ ^ |w| ");
            $display("        ****************************************   \\m___m__|_|");
            $display("        ** Passed: %0d/1, Failed: %0d/1       **", success_count, error_count);
            $display("        ****************************************                 ");
        end
        
        $stop; 
    end
endmodule