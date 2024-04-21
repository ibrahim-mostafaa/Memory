`timescale 1ns / 100ps

module SPRAM_tb(); 

parameter Data_Width = 8; 
parameter RAM_Depth = 16; 

// inputs & outputs 
reg clk, rst_n,cs,oe,wr_en; 
reg [$clog2(RAM_Depth)-1:0] addr;

// wire outputs
wire [Data_Width-1:0] data; 

reg  [Data_Width-1:0] tb_data; 
assign data = wr_en?tb_data:'bz; 
// instantiate dut
SPRAM #(.Data_Width(Data_Width), .RAM_Depth(RAM_Depth) ) 
dut(.clk(clk), .rst_n(rst_n),
.cs(cs), .oe(oe), .wr_en(wr_en),
.data(data), .addr(addr)); 

// generate clk
always begin 
clk = 1'b1; #5 clk = 1'b0; #5; 
end 

integer i; 
// store inputs in testvectors and put reset values.  
initial begin
rst_n = 1'b0; 
@(negedge clk); rst_n = 1'b1; 

{cs,wr_en, addr, tb_data, oe} <= 0; 

repeat (2) @(posedge clk); 
for ( i = 0; i< RAM_Depth; i= i+1) begin 
repeat (1) @(posedge clk) addr <= i; cs = 1'b1; wr_en = 1'b1; oe = 1'b0; tb_data = $random; 
end 
//read
for ( i = 0; i< RAM_Depth; i= i+1) begin 
repeat (1) @(posedge clk) addr <= i; cs = 1'b1; wr_en = 1'b0; oe = 1'b1; 
end 
end


endmodule 