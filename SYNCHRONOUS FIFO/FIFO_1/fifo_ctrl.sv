`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 12:22:43
// Design Name: 
// Module Name: fifo_ctrl
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


module fifo_ctrl
# (parameter ADDR_WIDTH = 3)
(
input logic clk, reset,
input logic wr, rd,
output logic full, empty,
output logic [ADDR_WIDTH-1:0] w_addr, r_addr // pointers only
    );
    
// signal declarations
logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
logic [ADDR_WIDTH-1:0] wr_ptr_next, rd_ptr_next;

logic full_next;
logic empty_next;

// sequential reset
always_ff @ (posedge clk or posedge reset) begin
    if (reset)
    begin
         wr_ptr <=0; 
         rd_ptr <=0;
         full <=1'b0;
         empty <=1'b1;
    end
    else
    begin
         wr_ptr <= wr_ptr_next; 
         rd_ptr <= rd_ptr_next;
         full <= full_next;
         empty <= empty_next;
    end
end

// combinational logic
always_comb 
begin
    // defaults
     wr_ptr_next = wr_ptr;
     rd_ptr_next = rd_ptr;
     empty_next = empty;
     full_next = full;
     
     //case 
     case({wr,rd})
        2'b01 : //read
        begin
            if(~empty) // pointer has to move to next location
            begin
                rd_ptr_next = rd_ptr + 1; // fifo is not full anymore, so we can overwrite
                full_next = 1'b0; // can write to fifo
                if (rd_ptr_next == wr_ptr)
                    empty_next = 1'b1;
            end
        end
        
        2'b10 : //write
        begin
            if(~full) // pointer has to move to next location
            begin
                wr_ptr_next = wr_ptr + 1; // fifo is now not empty, so we can read
                empty_next = 1'b0; // can read from fifo
                if (wr_ptr_next == rd_ptr)
                    full_next = 1'b1;
            end
        end
        
        2'b11 : // read & write simultaneously
        begin
            if(empty)
            begin 
                wr_ptr_next = wr_ptr;
                rd_ptr_next = rd_ptr;
            end 
            else
            begin  
                wr_ptr_next = wr_ptr + 1;
                rd_ptr_next = rd_ptr + 1;
            end
        end
        
        default : ;
     endcase
     
     // outputs 
assign w_addr = wr_ptr;     
assign r_addr = rd_ptr;     
end
endmodule
