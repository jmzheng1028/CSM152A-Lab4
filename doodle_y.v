`timescale 1ns / 1ps

module doodle_y(
    input clk, 
    input rst,
    input terminated,
    input [9:0] p1_vpos,
    input [9:0] p3_vpos,
    input [9:0] p1_hpos,
    input [9:0] p3_hpos,
    input wire [9:0] d_x,
    output reg [9:0] d_y
	 
   );
     
    localparam size = 50;
    localparam plat_width = 75;
    localparam gravity = 2;
     
	 
	  
    initial begin
		 d_y = 510;
    end
     
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
             d_y <= 510;
        end    
 
    end

endmodule
