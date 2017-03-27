`timescale 1ns / 1ps

module clockdiv(
	input wire clk,		
	input wire rst,		
	output wire pixel_clk,
	output wire doodle_clk,
	output wire platform_clk,
	output wire points_clk,
	output wire gravity_clk,
	output wire move_clk
	);

reg [1:0] pixel_count;
reg [31:0] doodle_count;
reg [31:0] platform_count;
reg [31:0] points_count;
reg [31:0] gravity_count;

reg [31:0] move_count;

reg platform_clk_reg;
reg pixel_clk_reg;
reg doodle_clk_reg;
reg points_clk_reg;
reg gravity_clk_reg;

reg move_clk_reg;
localparam DIV_FACTOR = 2; // 25 MHz
localparam DOODLE_FACTOR = 250000; // 200 Hz
//TODO
localparam MOVE_FACTOR = 125; 

reg [63:0] PLATFORM_FACTOR; 
localparam POINTS_FACTOR = 5000000; 
localparam GRAVITY_FACTOR = 500000; 


initial begin
	PLATFORM_FACTOR = 500000; 
	pixel_count = 0;
	pixel_clk_reg = 0;
	doodle_count = 0;
	doodle_clk_reg = 0;
	platform_count = 0;
	platform_clk_reg = 0;
	points_count = 0;
	points_clk_reg = 0;
	gravity_count = 0;
	gravity_clk_reg = 0;
	
	move_count = 0;
	move_clk_reg = 0;
	
end

// pixel clock
always @(posedge clk or posedge rst)
begin
	if (rst == 1) begin
		pixel_count <= 0;
		pixel_clk_reg <= 0;
	end
	else if (pixel_count == DIV_FACTOR - 1) begin
		pixel_count <= 0;
		pixel_clk_reg <= ~pixel_clk_reg;
	end
	else begin
		pixel_count <= pixel_count + 1;
		pixel_clk_reg <= pixel_clk_reg;
	end
end

// move clock
always @(posedge clk or posedge rst)
begin
	if (rst == 1) begin
		move_count <= 0;
		move_clk_reg <= 0;
	end
	else if (move_count == MOVE_FACTOR - 1) begin
		move_count <= 0;
		move_clk_reg <= ~move_clk_reg;
	end
	else begin
		move_count <= move_count + 1;
		move_clk_reg <= move_clk_reg;
	end
end


always @ (posedge clk or posedge rst)
begin
	if(rst == 1) begin
		doodle_count <= 0;
		doodle_clk_reg <= 0;
	end
	else if (doodle_count == DOODLE_FACTOR - 1) begin
		doodle_count <= 0;
		doodle_clk_reg <= ~doodle_clk_reg;
	end
	else begin
		doodle_count <= doodle_count + 1;
		doodle_clk_reg <= doodle_clk_reg;
	end
end

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		platform_count <= 0;
		platform_clk_reg <= 0;
	end
	else if (platform_count >= PLATFORM_FACTOR - 1) begin
		platform_count <= 0;
		platform_clk_reg <= ~platform_clk_reg;
	end
	else begin
		platform_count <= platform_count + 1;
		platform_clk_reg <= platform_clk_reg;
	end
end

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		points_count <= 0;
		points_clk_reg <= 0;
		
		PLATFORM_FACTOR <= 500000; 
	end
	else if (power_signal) begin
			PLATFORM_FACTOR <= 500000;
	end
	else if (points_count == POINTS_FACTOR - 1) begin
		points_count <= 0;
		points_clk_reg <= ~points_clk_reg;
		
		if (PLATFORM_FACTOR >= 200000) begin 
			PLATFORM_FACTOR <= PLATFORM_FACTOR - 1000;
		end
		else begin
			PLATFORM_FACTOR <= PLATFORM_FACTOR;
		end
	end
	else begin
		points_count <= points_count + 1;
		points_clk_reg <= points_clk_reg;
	end
end

always @ (posedge clk or posedge rst) begin
	if (rst) begin
		gravity_count <= 0;
		gravity_clk_reg <= 0;
	end
	else if (gravity_count == GRAVITY_FACTOR - 1) begin
		gravity_count <= 0;
		gravity_clk_reg <= ~gravity_clk_reg;
	end
	else begin
		gravity_count <= gravity_count + 1;
		gravity_clk_reg <= gravity_clk_reg;
	end
end

assign pixel_clk = pixel_clk_reg;
assign doodle_clk = doodle_clk_reg;
assign platform_clk = platform_clk_reg;
assign points_clk = points_clk_reg;
assign gravity_clk = gravity_clk_reg;
assign move_clk = move_clk_reg;
endmodule
