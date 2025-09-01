`timescale 1ns/1ps

module tb_riscv();

    // Sử dụng reg và wire cho nhất quán
    reg  clk;
    reg  rst_n;
    wire [31:0] WriteData, DataAdr;
    wire MemWrite;

    // Khởi tạo đúng module của bạn
    RISC_V_pipeline_top dut(
        .clk(clk), 
        .rst_n(rst_n), 
        .writedata(WriteData), 
        .dataadr(DataAdr), 
        .memwrite(MemWrite)
    );

    // Khởi tạo test
    initial begin
        rst_n <= 0; #22; rst_n <= 1;
    end

    // Tạo clock
    always begin
        clk <= 1; #5; clk <= 0; #5;
    end

    // Logic kiểm tra kết quả
    always @(negedge clk) begin
        if (MemWrite) begin
            if (DataAdr === 100 && WriteData === 25) begin
                $display("Simulation succeeded: Wrote %d to address %d", WriteData, DataAdr);
                $stop;
            end else if (DataAdr !== 96) begin
                $display ("Simlation failed");
                $stop;
            // end else begin
            //     // Nếu ghi vào một địa chỉ/dữ liệu khác ngoài dự kiến, báo lỗi
            //     $display("Simulation failed: Wrote %d to address %d", WriteData, DataAdr);
            //     $stop;
            end
        end
    end
    
    // // Thêm một cơ chế timeout để tránh lặp vô tận
    // initial begin
    //     #500; // Nếu sau 500ns mà chưa $stop, có lẽ đã có lỗi
    //     $display("Simulation failed: Timeout");
    //     $stop;
    // end

endmodule