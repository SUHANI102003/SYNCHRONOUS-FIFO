`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2025 20:12:15
// Design Name: 
// Module Name: syn_fifo2
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


module syn_fifo2
# (parameter DEPTH = 8, DATA_WIDTH = 8)(
input logic clk, rst_n,
input logic w_en, r_en,
input logic [DATA_WIDTH-1:0] data_in,
output logic [DATA_WIDTH-1:0] data_out,
output logic full, empty
    );
    
logic [DATA_WIDTH-1:0] fifo [DEPTH];
logic [$clog2(DEPTH)-1:0] w_ptr, r_ptr;

// reset
always_ff @(posedge clk) begin
    if(rst_n) begin
        w_ptr <=0; r_ptr <=0;
        data_out <=0;
    end
end

// write
always_ff @(posedge clk) begin
    if (w_en && !full) begin
        fifo[w_ptr] <= data_in;
        w_ptr <= w_ptr +1;
    end
end

// read
always_ff @(posedge clk) begin
    if (r_en && !empty) begin
        data_out <= fifo[r_ptr];
        r_ptr <= r_ptr +1;
    end
end

assign full = ((w_ptr + 1'b1) == r_ptr);
assign empty = (w_ptr == r_ptr);
endmodule
