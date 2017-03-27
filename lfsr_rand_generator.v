`timescale 1ns / 1ps

module lfsr_rand_generator(
	input clk,
	input rst,
	output reg [9:0] rand_hpos
    );


localparam hbp = 295;

localparam range = 3;

reg [15:0] lfsr;
reg new_bit;
reg [15:0] update;

initial begin 
	lfsr = 777;
	update = 0;
end	 



always @ (posedge clk or posedge rst) begin
	if(rst) begin
		update <= update + 1;
		lfsr <= 777 + update;
		rand_hpos <= hbp;
	end
	else begin
		new_bit  <= ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5) ) & 1;
      lfsr <= (lfsr >> 1) | (new_bit << 15);
		
		rand_hpos <= (lfsr % range) * 120 + hbp;
	end
end
endmodule