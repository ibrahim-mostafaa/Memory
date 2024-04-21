`timescale 1ns / 100ps

module SYNC_FIFO_tb();

	parameter Data_Width = 8; 
	parameter FIFO_Depth = 16; 
    reg clk, rst_n, rd, wr;
    reg [Data_Width-1:0] data_in;
    wire empty, full;
    wire [$clog2(FIFO_Depth):0] count;
    wire [Data_Width-1:0] data_out;

    SYNC_FIFO my_fifo (
        .data_in(data_in),
        .clk(clk),
        .rst_n(rst_n),
        .rd(rd),
        .wr(wr),
        .empty(empty),
        .full(full),
        .count(count),
        .data_out(data_out)
    );

// generate clk
always begin 
clk = 1'b1; #5 clk = 1'b0; #5; 
end 

integer i; 
    initial begin
	rst_n = 1'b0; 
	wr = 1'b0;
	rd = 1'b0; 
	@(negedge clk); rst_n = 1'b1;
	
repeat (2) @(posedge clk); 
for ( i = 0; i< FIFO_Depth; i= i+1) begin 
repeat (1) @(posedge clk) wr = 1'b1; rd = 1'b0; data_in = $random; 
end 
//read
for ( i = 0; i< FIFO_Depth; i= i+1) begin 
repeat (1) @(posedge clk) wr = 1'b0; rd = 1'b1; 
end 
    end



endmodule