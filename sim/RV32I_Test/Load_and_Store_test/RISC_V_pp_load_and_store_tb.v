`timescale 1ns/1ps

module RISC_V_pp_top_load_and_store_tb();

    // Tín hiệu điều khiển và quan sát
    reg clk = 0;
    reg rst_n;
    wire [31:0] writedata, dataadr;
    wire memwrite;

    // Khởi tạo bộ xử lý (DUT)
    RISC_V_pipeline_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite)
    );

    // Khởi tạo tín hiệu reset
    initial begin
        rst_n = 1'b0; 
        #22;
        rst_n = 1'b1;
    end

    // Tạo xung clock với chu kỳ 10ns
    always #5 clk = ~clk;
    
    // =================================================================
    // Kịch bản kiểm tra (Verification Logic)
    // =================================================================
    
    integer success_count = 0;
    integer error_count = 0;

    // Theo dõi và kiểm tra các lần ghi vào bộ nhớ
    always @(negedge clk) begin
        // Chỉ kiểm tra các lần ghi vào vùng nhớ kết quả (>= 400)
        if (memwrite && dataadr >= 400) begin
            $display("INFO: Verifying write to address %d with data %h", dataadr, writedata);
            case (dataadr)
                400: if (writedata === 32'h1234ABCD) success_count <= success_count + 1;
                     else begin $display("ERROR: LW test failed!"); error_count <= error_count + 1; end
                404: if (writedata === 32'h00001234) success_count <= success_count + 1;
                     else begin $display("ERROR: LH (positive) test failed!"); error_count <= error_count + 1; end
                408: if (writedata === 32'h00001234) success_count <= success_count + 1;
                     else begin $display("ERROR: LHU (positive) test failed!"); error_count <= error_count + 1; end
                412: if (writedata === 32'hFFFFABCD) success_count <= success_count + 1;
                     else begin $display("ERROR: LH (negative) test failed!"); error_count <= error_count + 1; end
                416: if (writedata === 32'h0000ABCD) success_count <= success_count + 1;
                     else begin $display("ERROR: LHU (negative) test failed!"); error_count <= error_count + 1; end
                420: if (writedata === 32'h00000034) success_count <= success_count + 1;
                     else begin $display("ERROR: LB (positive) test failed!"); error_count <= error_count + 1; end
                424: if (writedata === 32'h00000034) success_count <= success_count + 1;
                     else begin $display("ERROR: LBU (positive) test failed!"); error_count <= error_count + 1; end
                428: if (writedata === 32'hFFFFFFCD) success_count <= success_count + 1;
                     else begin $display("ERROR: LB (negative) test failed!"); error_count <= error_count + 1; end
                432: if (writedata === 32'h000000CD) success_count <= success_count + 1;
                     else begin $display("ERROR: LBU (negative) test failed!"); error_count <= error_count + 1; end
                default: begin
                    $display("ERROR: Wrote to unexpected verification address %d", dataadr);
                    error_count <= error_count + 1;
                end
            endcase
        end
    end

    initial begin
        #2000; 

        if (error_count == 0 && success_count == 9) begin
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
            $display("        ** Passed: %0d/9, Failed: %0d/9       **", success_count, error_count);
            $display("        ****************************************                 ");
        end
        
        $stop; 
    end

endmodule