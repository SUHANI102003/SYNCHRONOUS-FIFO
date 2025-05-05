`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 12:12:39
// Design Name: 
// Module Name: reg_file
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

// NOT following a BRAM template, so this code will use LUT's
// if you want to use BRAM, then you may have to change asynchronous read to synchronous
// but then we cannot have FWFT FIFO - will have to make changes for that
// so, fere we are implementing sinmple FIFO
module reg_file
# (parameter ADDR_WIDTH = 3, DATA_WIDTH=8 )
(
input logic clk,
input logic w_en,
input logic [ADDR_WIDTH-1:0] r_addr,w_addr,
input logic [DATA_WIDTH-1:0] w_data,
output logic [DATA_WIDTH-1:0] r_data
    );
    
//// memory declaration
logic [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];

// write operation
always_ff @(posedge clk) begin
    if(w_en)
        mem[w_addr] <= w_data;
end

// read operation asyn
// why asynchronous read ?? 
// Because we are designing FIrst Word Fall Through
assign r_data = mem[r_addr];
endmodule
