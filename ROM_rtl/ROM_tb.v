`timescale 1ns / 100ps

module ROM_tb(); 

// inputs & outputs 
reg clk, rst_n,cs; 
reg [2:0] addr;

// wire outputs
wire [15:0] data; 

// instantiate dut
ROM dut(.clk(clk), .rst_n(rst_n), .cs(cs) ,.addr(addr),.data(data)); 

// generate clk
always begin 
clk = 1'b1; #5 clk = 1'b0; #5; 
end 

// put reset values.  
initial begin
rst_n = 1'b0; 
cs = 1'b1; 
@(negedge clk); rst_n = 1'b1; 
end

//generate new address @ posedge clk 
always @(posedge clk) begin 
addr = $random; 
end 

endmodule 