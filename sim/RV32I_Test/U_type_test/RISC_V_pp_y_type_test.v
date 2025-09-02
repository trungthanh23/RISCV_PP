`timescale 1ns/1ps

module RISC_V_pp_top_U_type_tb();

    // ... (Khai báo và khởi tạo DUT, clock, reset giữ nguyên) ...
    reg clk = 0;
    reg rst_n;
    wire [31:0] writedata, dataadr;
    wire memwrite;

    RISC_V_pipeline_top dut (
        .clk(clk), 
        .rst_n(rst_n), 
        .writedata(writedata), 
        .dataadr(dataadr), 
        .memwrite(memwrite)
    );

    initial begin rst_n = 1'b0; #22; rst_n = 1'b1; end
    always #5 clk = ~clk;

    // =================================================================
    // Kịch bản kiểm tra
    // =================================================================
    
    integer success_count = 0;

    // Theo dõi và kiểm tra các lần ghi vào bộ nhớ
    always @(negedge clk) begin
        if (memwrite) begin
            case (dataadr)
                600: if (writedata === 32'hABCDE000) begin
                        $display("INFO: LUI test passed!");
                        success_count <= success_count + 1;
                     end else begin
                        $display("\n");
                        $display("        **************************************** ");
                        $display("        **                                    **       |\__||  ");
                        $display("        ** OOPS!!                             **      / X,X  | ");
                        $display("        ** U-type instruction failed!! =((    **    / _____  | ");
                        $display("        ** SIMULATION FAILED!!                **   /^ ^ ^ \\  |");
                        $display("        **                                    **  |^ ^ ^ ^ |w| ");
                        $display("        ****************************************   \\m___m__|_|");
                        $display("\n        FAILED: LUI test incorrect! Wrote %h      ", writedata);
                        $display("\n      ****************************************               ");
                        $stop;
                     end
                604: if (writedata === 4100) begin
                        $display("INFO: AUIPC test passed!");
                        success_count <= success_count + 1;
                     end else begin
                        $display("\n");
                        $display("        **************************************** ");
                        $display("        **                                    **       |\__||  ");
                        $display("        ** OOPS!!                             **      / X,X  | ");
                        $display("        ** U-type instruction failed!! =((    **    / _____  | ");
                        $display("        ** SIMULATION FAILED!!                **   /^ ^ ^ \\  |");
                        $display("        **                                    **  |^ ^ ^ ^ |w| ");
                        $display("        ****************************************   \\m___m__|_|");
                        $display("\n       FAILED: AUIPC test incorrect! Wrote %d     ", writedata);
                        $display("\n      ****************************************               ");
                        $stop;
                     end
            endcase
        end
    end

    // Khối báo cáo cuối cùng
    always @(posedge clk) begin
        if (success_count == 2) begin
            $display("        ************************************               ");
			$display("        **                                **       |\__||  ");
			$display("        **  Congratulations !!            **      / O.O  | ");
			$display("        **  U-type instructions passed!   **    /_____   | ");
			$display("        **  SIMULATION PASS !!            **   /^ ^ ^ \\  |");
			$display("        **                                **  |^ ^ ^ ^ |w| ");
			$display("        ************************************   \\m___m__|_|");
			$display("\n");
            $stop;
        end
    end

    // Khối timeout
    initial begin
        #1000;
        $display("\n");
        $display("        **************************************** ");
        $display("        **                                    **       |\__||  ");
        $display("        ** OOPS!!                             **      / X,X  | ");
        $display("        ** U-type instruction failed!! =((    **    / _____  | ");
        $display("        ** SIMULATION FAILED!!                **   /^ ^ ^ \\  |");
        $display("        **                                    **  |^ ^ ^ ^ |w| ");
        $display("        ****************************************   \\m___m__|_|");
        $display("\n      **  FAILED: Simulation timed out!     **               ");
        $display("\n      ****************************************               ");
        $stop;
    end

endmodule