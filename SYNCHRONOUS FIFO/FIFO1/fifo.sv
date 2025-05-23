`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 17:38:40
// Design Name: 
// Module Name: fifo
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


module fifo
# (parameter ADDR_WIDTH = 3, DATA_WIDTH=8 )
(
input logic clk, reset,
input logic wr, rd,
output logic full, empty,
input logic [DATA_WIDTH-1:0] w_data,
output logic [DATA_WIDTH-1:0] r_data
    );
    
logic [ADDR_WIDTH-1:0] w_addr, r_addr;

//instantiate register file
reg_file #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH))
        r_file_unit (.w_en(wr & ~full), .*);
       
// instantiate fifo controller
fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH))
    ctrl_unit (.*);
endmodule
