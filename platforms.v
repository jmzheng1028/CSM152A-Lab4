
`timescale 1ns / 1ps 
 
module platforms( 
    input platform_clk,
    input rst, 
     
   
    input wire [9:0] new_hpos, 
    input wire terminated,
    output reg [9:0] p1_vpos,  
    output reg [9:0] p3_vpos,      
    output reg [9:0] p1_hpos, 
    output reg [9:0] p3_hpos
    ); 
     
    parameter hbp = 295;
    parameter hfp = 655;
    parameter vbp = 31;
    parameter vfp = 511;
    parameter v_spc = 50;
    parameter height = 160;
    localparam width = 120;
	      
    initial begin 
        p1_vpos = vbp; 
        p3_vpos = vbp + 160; 
        p1_hpos = hbp + 240; 
        p3_hpos = hbp + 120; 

    end 
 
    always @ (posedge platform_clk or posedge rst) begin 
        if (rst) begin 
            p1_vpos <= vbp; 
            p3_vpos <= vbp + 160; 
            p1_hpos <= hbp + 240; 
            p3_hpos <= hbp + 120; 
           
        end 
        else begin 
            if(!terminated) begin 
                if (p1_vpos >= vfp) begin 
                    p1_vpos <= vbp + 1; 
                    p1_hpos <= new_hpos;
                end 
                else begin 
						p1_vpos <= p1_vpos + 1; 
            
                end 
                 
             
                if (p3_vpos >= vfp) begin 
                    p3_vpos <= vbp + 1; 
                    p3_hpos <= new_hpos;
						
                end 
                else begin 
						p3_vpos <= p3_vpos + 1;
                end 
					 
					 
              
            end 
        end             
    end 
 
endmodule
