`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2025 20:40:24
// Design Name: 
// Module Name: tb_syn_fifo2
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


module tb_syn_fifo2();
parameter DATA_WIDTH = 8;
logic clk, rst_n;
logic w_en, r_en;
logic [DATA_WIDTH-1:0] data_in;
logic [DATA_WIDTH-1:0] data_out;
logic full, empty;

// queue to push data in
logic [DATA_WIDTH-1:0] wdata_q[$], wdata;

syn_fifo2 s_fifo (clk, rst_n, w_en, r_en, data_in, data_out, full, empty);

always #5 clk = ~clk;

initial begin
    clk = 1'b0; rst_n = 1'b1;
    w_en = 1'b0;
    data_in = 0;
    
    repeat(10) @(posedge clk);
    rst_n = 1'b0;
    
    repeat(2) begin
        for (int i=0; i<30; i++) begin
            @(posedge clk);
            w_en = (i%2 == 0)? 1'b1 : 1'b0;
            if(w_en && !full) begin
                data_in = $urandom;
                wdata_q.push_back(data_in);
            end
        end
        #50;
end
end

initial begin
    clk = 1'b0; rst_n = 1'b1;
    r_en = 1'b0;
    
    repeat(20) @ (posedge clk);
    rst_n = 1'b0;
    
    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge clk);
        r_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (r_en && !empty) begin
             #1;
          wdata = wdata_q.pop_front();
          if(data_out !== wdata) 
          $error("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, data_out);
          else 
          $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h",$time, wdata, data_out);
        end
      end
      #50;
    end
    $finish;
  end

  
endmodule
