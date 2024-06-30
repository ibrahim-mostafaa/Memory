module ROM(clk, rst_n, cs, addr, data);

input [2:0] addr; // address
input cs; // chip select
input rst_n; 
input clk; 
output reg [15:0] data;

reg [15:0] rom_data;
reg rst_n_sync;

always@(*)
begin

if(cs)
begin
case(addr) 
3'b000: rom_data = 16'h1;
3'b001: rom_data = 16'h2;
3'b010: rom_data = 16'h3;
3'b011: rom_data = 16'h4;

3'b100: rom_data = 16'h5;
3'b101: rom_data = 16'h6;
3'b110: rom_data = 16'h7;
3'b111: rom_data = 16'h8;
default: rom_data = 0;
endcase 
end 
else rom_data = 0; 
end 

// Asynchronous reset assertion, synchronous reset deassertion
always @(negedge rst_n or posedge clk) begin
    if (!rst_n)
        rst_n_sync <= 1'b0;  // Asynchronous reset assertion
    else
        rst_n_sync <= 1'b1;  // Synchronous reset deassertion
end

// Data output logic
always @(*) begin
    if (!rst_n_sync)
        data = 16'b0;  // Clear data on reset
    else
        data = rom_data;  // Update data immediately from combinational logic
end

endmodule
