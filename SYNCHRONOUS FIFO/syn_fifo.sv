`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.04.2025 22:46:27
// Design Name: 
// Module Name: syn_fifo
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


module syn_fifo
# (parameter ADDR_WIDTH = 10, DATA_WIDTH=8, 
             ALMOST_FULL_THRESHOLD = 12,
             ALMOST_EMPTY_THRESHOLD = 4)
(
input logic clk, rst_n, wr_en, rd_en, 
input logic [DATA_WIDTH-1:0] wr_data, rd_data,
output logic full, empty, almost_full, almost_empty, rd_valid, wr_ready
);

// signal declarations
    //logic  [DATA_WIDTH-1:0] ram_rd_data;
    logic  [ADDR_WIDTH-1:0] wr_ptr;
    logic  [ADDR_WIDTH-1:0] rd_ptr;
    logic  [ADDR_WIDTH:0]   fifo_count;  // One extra bit for full detection
 
// instantiate dual port ram   
 dual_port_ram #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) ram 
 (
 .clk(clk), .we_a(wr_en && wr_ready), .din(wr_data), .addr_w(wr_ptr),
  .addr_r(rd_ptr), .dout(rd_data)
 );

// Status Flags
    assign empty         = (fifo_count == 0);
    assign full          = (fifo_count == 2**ADDR_WIDTH);
    assign almost_empty  = (fifo_count <= ALMOST_EMPTY_THRESHOLD);
    assign almost_full   = (fifo_count >= ALMOST_FULL_THRESHOLD);
    assign wr_ready      = !full;
    assign rd_valid      = !empty;
    
//assign rd_data = ram_rd_data;

 // Write address update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wr_ptr <= 0;
        else if (wr_en && wr_ready)
            wr_ptr <= wr_ptr+ 1;
    end 
    
 // Read address update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rd_ptr <= 0;
        else if (rd_en && rd_valid)
            rd_ptr <= rd_ptr + 1;
    end 

// FIFO count management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            fifo_count <= 0;
        else begin
            case ({wr_en && wr_ready, rd_en && rd_valid})
                2'b10: fifo_count <= fifo_count + 1; // Write only
                2'b01: fifo_count <= fifo_count - 1; // Read only
                default: fifo_count <= fifo_count;   // No change
            endcase
        end
    end
endmodule

/*
module dual_port_ram
# (parameter ADDR_WIDTH = 10, DATA_WIDTH=8)
(
input logic clk, we_a,
input logic [DATA_WIDTH-1:0] din, // writing data
input logic [ADDR_WIDTH-1:0] addr_w,addr_r, // reading & writing address
output logic [DATA_WIDTH-1:0] dout // reading data
    );
    
// declaring memory size
logic [DATA_WIDTH-1:0] ram2 [0 : 2**ADDR_WIDTH-1];

// port a
always@(posedge clk) begin
    if(we_a)
        ram2[addr_w] <= din;
        dout <= ram2[addr_r];
end  

  
endmodule
*/