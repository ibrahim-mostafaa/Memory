
module DPRAM #(parameter Data_Width = 8, RAM_Depth = 16)(
input clk,
input rst_n,
input cs,
input oe,
input wr_en,
input [Data_Width-1:0]data_in, 
input [$clog2(RAM_Depth)-1:0] addr,
output reg [Data_Width-1:0]data_out
); 

reg [Data_Width-1:0] memory [0:RAM_Depth-1]; 

always@(posedge clk or negedge rst_n) begin 
if (!rst_n) begin 
data_out <=0; 
end 
else if (cs && wr_en) begin  // writes
memory[addr] <= data_in; 
end  
else if (cs && !wr_en && oe)begin // reads 
data_out <= memory[addr];  
end 
end 

endmodule 