`timescale 1ns / 1ps

 module points(
	input clk,
	input rst,
	input hs_rst,
	input wire [9:0] d_y, 
	input wire [9:0] d_x,
	input wire [9:0] p1_vpos,
	input wire [9:0] p3_vpos,
	input wire [9:0] p1_hpos,
	input wire [9:0] p3_hpos,
	
	output reg terminated, 
	output reg [31:0] points
    );
	 
	localparam vbp = 31;
	localparam vfp = 511;
	localparam doodle_size = 50;
	localparam height = 160;
   localparam width = 120;
	 
	initial begin
		terminated = 0;
		points = 0;
	end

	always @ (posedge clk or posedge rst or posedge hs_rst) begin
		if (rst) begin
			points <= 0;
			terminated <= 0;
		end
		else if (hs_rst) begin
			points <= 0;
		end
		 else if ( d_y - doodle_size <= p1_vpos + height)
		 begin
			if((d_x <= p1_hpos && d_x + doodle_size > p1_hpos) || (d_x < p1_hpos + width && d_x && d_x + doodle_size >= p1_hpos + width) || (d_x > p1_hpos && d_x + doodle_size < p1_hpos + width))
			begin
				terminated <= 1;
				points <= points;
			end
			else
				points <= points + 1;
		 end
		 
		 else if ( d_y - doodle_size <= p3_vpos + height)
		 begin
			if((d_x <= p3_hpos && d_x + doodle_size > p3_hpos) || (d_x < p3_hpos + width && d_x && d_x + doodle_size >= p3_hpos + width) || (d_x > p3_hpos && d_x + doodle_size < p3_hpos + width))
			begin
				terminated <= 1;
				points <= points;
			end
			else
				points <= points + 1;
		 end
		 
		 else begin
			points <= points + 1;
		end
		 
	end

endmodule
