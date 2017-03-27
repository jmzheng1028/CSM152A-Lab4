`timescale 1ns / 1ps

module doodle_x(
	input doodle_clk,
	input rst,
	
	input left,
	input right,
	
	input wire [9:0] p1_vpos,
	input wire [9:0] p3_vpos,
	input wire [9:0] p1_hpos,
	
	input wire [9:0] p3_hpos,
	output reg [7:0] Led,
	output reg [9:0] d_x
    );
	 

parameter hbp = 295;
parameter hfp = 655;
parameter bottom = 511;
localparam p_width = 75;
localparam p_height = 20;
localparam size = 50;

reg [1:0] temp;

initial begin
	d_x=hbp;
	temp = 0;
end

always @ (posedge doodle_clk or posedge left or posedge right) begin
	if(left) begin
		temp <= 2;
	end
	
	else if(right) begin
		temp <= 1;
	end
	
	else begin
		temp <= 0;
	end
end

always @ (posedge doodle_clk or posedge rst) begin
	if (rst) begin
		d_x <= hbp + 120;
		Led [7:0] <= 0;
	end

	else if( temp == 1) begin
		if (d_x >= hfp - 20) begin
			d_x <= d_x;
		end
		
		else begin
			d_x <= d_x + 2;
		
		end
	
	end

	else if( temp == 2) begin
		if (d_x <= hbp) begin
			d_x <= d_x;
		end
		
		else begin
			d_x <= d_x - 2;
		
		end
	
	end
	
		

	else begin
		Led[7:0] <= 0;
		d_x <= d_x;
	end
end

endmodule
