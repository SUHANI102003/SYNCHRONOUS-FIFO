`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2025 23:02:45
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb();

    // Parameters
    localparam ADDR_WIDTH = 4;
    localparam DATA_WIDTH = 8;
    localparam DEPTH = 2**ADDR_WIDTH;

    // Signals
    logic clk;
    logic rst_n;
    logic wr_en, rd_en;
    logic [DATA_WIDTH-1:0] wr_data, rd_data;
    logic full, empty, almost_full, almost_empty, rd_valid, wr_ready;

    // Instantiate FIFO
    syn_fifo #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ALMOST_FULL_THRESHOLD(12),
        .ALMOST_EMPTY_THRESHOLD(4)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty),
        .rd_valid(rd_valid),
        .wr_ready(wr_ready)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end

    // Stimulus
    initial begin
        // Initialize
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;
        #20;
        rst_n = 1;

        // Write 8 values into FIFO
        repeat (8) begin
            @(posedge clk);
            if (wr_ready) begin
                wr_en <= 1;
                wr_data <= wr_data + 1; // Write incrementing values
            end
        end
        wr_en <= 0;

        // Wait a few cycles
        repeat (5) @(posedge clk);

        // Read 8 values from FIFO
        repeat (8) begin
            @(posedge clk);
            if (rd_valid) begin
                rd_en <= 1;
            end else begin
                rd_en <= 0;
            end
        end
        rd_en <= 0;

        // End simulation
        repeat (5) @(posedge clk);
        $finish;
    end

endmodule

   


