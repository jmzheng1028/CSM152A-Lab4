`timescale 1ns / 1ps


module top_module(
	
	input clk,
	input rst,
	input hs, 
	input hs_rst, 
	input left,
	input right,
	
	output wire [7:0] Led,
	output wire [3:0] AN,
	output wire [6:0] SEG,

	// VGA
	output wire [2:0] red,	
	output wire [2:0] green,
	output wire [2:0] blue,	
	output wire hsync,
	output wire vsync
	);

	

	
	wire pixel_clk;
	wire doodle_clk;
	wire platform_clk;
	wire points_clk;
	wire gravity_clk;
	wire move_clk;
	wire rst_signal;
	wire hs_rst_signal;
	wire hs_signal;
	wire left_signal;
	wire right_signal;
	
	debouncer rst_debouncer (
		.clk(clk),
		.button(rst),
		.button_state(rst_signal)
	);
	
	debouncer hs_rst_debouncer(
		.clk(clk),
		.button(hs_rst),
		.button_state(hs_rst_signal)
	);
	
	debouncer hs_debouncer (
		.clk(clk),
		.button(hs),
		.button_state(hs_signal)
	);
	

	
	clockdiv divider(
		.clk(clk),
		.rst(rst_signal),
		.pixel_clk(pixel_clk),
		.doodle_clk(doodle_clk),
		.platform_clk(platform_clk),
		.points_clk(points_clk),
		.gravity_clk(gravity_clk),
		.move_clk(move_clk)
		);
		
		
		
	debouncer left_debouncer (
		.clk(move_clk),
		.button(left),
		.button_state(left_signal)
	);
	
	debouncer right_debouncer (
		.clk(move_clk),
		.button(right),
		.button_state(right_signal)
	);
		
	
	wire [9:0] doo_x;
	wire [9:0] doo_y;
	wire [9:0] p1_vpos; 
	wire [9:0] p3_vpos;
	wire [9:0] p1_hpos;
	wire [9:0] p3_hpos;
	wire [9:0] new_hpos; 
	
	wire terminated;	
	wire [31:0] points;

	points points_mod (
		.clk(points_clk),
		.rst(rst_signal),
		.hs_rst(hs_rst_signal),
		.d_y(doo_y),
		.d_x(doo_x),
		.p1_hpos(p1_hpos),
		.p3_hpos(p3_hpos),
		.p1_vpos(p1_vpos),
		.p3_vpos(p3_vpos),
		.terminated(terminated),
		.points(points)
	);

	wire [31:0] highscore;
	
	high_score highscore_mod (
		.clk(clk),
		.rst(hs_rst_signal),
		.points(points),
		.highscore(highscore)	
	);

	wire [31:0] value_to_display;

	select_display_value display_mux (
		.clk(clk),
		.hs(hs_signal),
		.points(points),
		.highscore(highscore),
		.val(value_to_display)
	);
	
	ssdCtrl points_display(
			.CLK(clk),
			.RST(rst_signal),
			.DIN(value_to_display),
			.AN(AN),
			.SEG(SEG)
	);

	lfsr_rand_generator rand_mod1 (
		.clk(clk),
		.rst(rst_signal),
		.rand_hpos(new_hpos)
	);
	
	platforms platforms_mod (
		.platform_clk(platform_clk),
		.rst(rst_signal),
		.new_hpos(new_hpos),
		.terminated(terminated),
		.p1_vpos(p1_vpos),
		.p3_vpos(p3_vpos),
		.p1_hpos(p1_hpos),
		.p3_hpos(p3_hpos)
	);
	
	doodle_x dx_mod (
		.doodle_clk(doodle_clk),
		.rst(rst_signal),
		.left(left_signal),
		.right(right_signal),
		.p1_vpos(p1_vpos),
		.p3_vpos(p3_vpos),
		.p1_hpos(p1_hpos),
		.p3_hpos(p3_hpos),
		
		.Led(Led),
		.d_x(doo_x)
		);

	doodle_y dy_mod ( 
		.clk(platform_clk),
		.rst(rst_signal),
		.terminated(terminated),
		.p1_vpos(p1_vpos),
		.p3_vpos(p3_vpos),
		.p1_hpos(p1_hpos),
		.p3_hpos(p3_hpos),
		.d_x(doo_x),
		.d_y(doo_y)
		
	);

	vga640x480 vga(
		.pixel_clk(pixel_clk),
		.rst(rst_signal),
		.left(left_signal),
		.right(right_signal),
		.d_x(doo_x),
		.d_y(doo_y),
		.p1_vpos(p1_vpos),
		.p3_vpos(p3_vpos),
		.p1_hpos(p1_hpos),
		.p3_hpos(p3_hpos),
		.terminated(terminated),
		.hsync(hsync),
		.vsync(vsync),
		.red(red),
		.green(green),
		.blue(blue)
		);

endmodule
