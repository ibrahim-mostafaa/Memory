
module SYNC_FIFO #(parameter Data_Width = 8, FIFO_Depth = 16)(

    input clk, rst_n, rd, wr,
    input [Data_Width-1:0] data_in, 
    output empty, full, 
    output reg [$clog2(FIFO_Depth):0]count,
    output reg [Data_Width-1:0] data_out);

    reg [Data_Width-1:0] fifo_ram [0:FIFO_Depth-1];
    reg [$clog2(FIFO_Depth)-1:0] read_ptr, write_ptr;
	
    assign empty= (count==0);
    assign full =(count==FIFO_Depth);
    
    always @(posedge clk) 
        begin
            if (wr && ! full)
                fifo_ram [write_ptr] <= data_in;
            end

//Read and Write Clock
    always @ (posedge clk) 
        begin
            if (rd && !empty)
                data_out <= fifo_ram [read_ptr];
        end

//pointer block 
    always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n) begin
            write_ptr <= 0;
            read_ptr <= 0;
			data_out <= 'bz;
        end 
        else begin
            write_ptr <= (wr && ! full) ? write_ptr + 1 : write_ptr;
            read_ptr  <= (rd && !empty) ? read_ptr  + 1 : read_ptr;
        end
    end

//counter
    always @(posedge clk or negedge rst_n) 
        begin
            if (!rst_n)   
                count <= 0;
            else begin
                case ({wr, rd})
                2'b00: count <= count;
                2'b01: count <= (count == 0) ? 0: count - 1;
                2'b10: count <= (count == FIFO_Depth) ? FIFO_Depth: count + 1;
                2'b11 : count <= count;
                default: count <= count;
                endcase
            end
        end
endmodule
