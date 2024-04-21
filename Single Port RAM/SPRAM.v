
module SPRAM #(parameter Data_Width = 8, RAM_Depth = 16)(
input clk,
input rst_n,
input cs,
input oe,
input wr_en,
inout [Data_Width-1:0]data,  // only one port either for read or write 
//with wr_en as a control
input [$clog2(RAM_Depth)-1:0] addr
); 

reg [Data_Width-1:0] memory[0:RAM_Depth-1]; 
reg [Data_Width-1:0] temp_data;
always@(posedge clk or negedge rst_n) begin 
if (!rst_n) begin 
temp_data <=0; 
end 
else if (cs && wr_en) begin  // writes
memory[addr] <= data; 
end  
else if (cs && !wr_en && oe)begin // reads 
temp_data <= memory[addr];  
end 
end 

assign data = cs&&oe&&!wr_en? temp_data:'bz; 

endmodule 