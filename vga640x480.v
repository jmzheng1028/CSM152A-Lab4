`timescale 1ns / 1ps

module vga640x480(
	input wire pixel_clk,
	input wire rst,
	input wire left,
	input wire right,
	input wire [9:0] d_x,
	input wire [9:0] d_y,
	input wire [9:0] p1_vpos,
	input wire [9:0] p3_vpos,
	input wire [9:0] p1_hpos, 
	input wire [9:0] p3_hpos,
	input wire terminated,
	output wire hsync,		
	output wire vsync,
	output reg [2:0] red,
	output reg [2:0] green, 
	output reg [2:0] blue
	);

parameter hpixels = 800;
parameter vlines = 521; 
parameter hpulse = 96;
parameter vpulse = 2;
parameter hbp = 295;
parameter hfp = 655;
parameter vbp = 31;
parameter vfp = 511;
reg [9:0] hc;
reg [9:0] vc;



always @(posedge pixel_clk or posedge rst)
begin
	if (rst == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else 
	begin
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
	
	
end

assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

parameter doodleSize = 50;

localparam height = 160;
localparam width = 120;

always @(*)
begin

	if (vc >= vbp && vc <= vfp)
	begin
		if(hc <= hbp || hc >= hfp) begin
			red = 3'b001;
			green = 3'b001;
			blue = 3'b001;
		end
		else if ( vc >= p1_vpos && vc <= p1_vpos + height && hc >= p1_hpos && hc <= p1_hpos + width ) begin
			red = 3'b010;
			green = 3'b010;
			blue = 3'b010;
			
		end
		else if ( vc >= p3_vpos && vc <= p3_vpos + height && hc >= p3_hpos && hc <= p3_hpos + width ) begin
			red = 3'b010;
			green = 3'b010;
			blue = 3'b010;
			
		end
		
		else if (!terminated && (vc >= d_y - doodleSize && vc <= d_y && hc >= d_x && hc <= d_x + doodleSize)) begin
			red = 3'b000;
			green = 3'b111;
			blue = 3'b000;
		end
		
		else
		begin
			red = 3'b0;
			green =3'b0;
			blue = 3'b0;
		end

	end
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule
