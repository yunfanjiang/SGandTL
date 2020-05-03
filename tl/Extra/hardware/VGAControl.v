`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: This file is from support materials for Engineering Software 3 Assessment 2, but amended for software design requirement.
//           Amended by: Yunfan Jiang (s1886282)
// 
// Design Name: VGA Control 
// Module Name: VGA Control  
// Project Name: Traffic light
// Target Devices: DIGILENT BASYS 3 FPGA Board
// Tool versions: Vivado 2015.2
// Description: 
// The default patterns and shapes and locations of VGA regions are re-arranged and re-designed for software design requirement.
//
// Revision: 
// Revision 1.3.4
// Last edited on: 14 Nov 2018
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGAControl(
    clk,
    reset,
    colour_out,
    hs,
    vs,
    reg_0_colour,
    reg_1_colour,
    reg_2_colour,
    reg_3_colour,
    reg_4_colour,
    reg_5_colour,
    reg_6_colour,
    reg_7_colour,
    reg_8_colour,
    reg_9_colour,
    reg_10_colour,
    reg_11_colour
    );

    input clk;
    input reset;
    output [11:0] colour_out;
    output hs;
    output vs;
    input [11:0] reg_0_colour;
    input [11:0] reg_1_colour;
    input [11:0] reg_2_colour;
    input [11:0] reg_3_colour;
    input [11:0] reg_4_colour;
    input [11:0] reg_5_colour;
    input [11:0] reg_6_colour;
    input [11:0] reg_7_colour;
    input [11:0] reg_8_colour;
    input [11:0] reg_9_colour;
    input [11:0] reg_10_colour;
    input [11:0] reg_11_colour;
    
    wire reset;
            
    wire [9:0] addrh;
    wire [8:0] addrv;
    reg  [11:0] colour;

    VGAInterface VGAInterface_instance (
        .CLK(clk), 
        .C_IN(colour), 
        .C_OUT(colour_out), 
        .HS(hs), 
        .VS(vs),
        .ADR_X(addrh),
        .ADR_Y(addrv)
    );

    always @(posedge clk) begin
        if (((((addrh - 134) * (addrh - 134)) + ((addrv - 82) * (addrv - 82))) <= 2601))    // Red light for road 1
            colour <= reg_0_colour;
        else if (((((addrh - 261) * (addrh - 261)) + ((addrv - 82) * (addrv - 82))) <= 2601))   // Yellow light for road 2
            colour <= reg_1_colour;
        else if (((((addrh - 98) * (addrh - 98)) + ((addrv - 241) * (addrv - 241))) <= 2601))   // Red light for road 2
            colour <= reg_6_colour;
        else if (((((addrh - 225) * (addrh - 225)) + ((addrv - 241) * (addrv - 241))) <= 2601)) // Yellow light for road 2
            colour <= reg_7_colour;
        // Letter pattern for pedestrian stop
        else if (((addrv >= 410) & (addrv <= 420)) & (((addrh >= 240) & (addrh <= 270)) | ((addrh >= 280) & (addrh <= 310)) | ((addrh >= 340) & (addrh <= 360)) | ((addrh >= 380) & (addrh <= 410))))
            colour <= reg_4_colour;
        else if (((addrv >= 420) & (addrv <= 430)) & (((addrh >= 240) & (addrh <= 250)) | ((addrh >= 290) & (addrh <= 300)) | ((addrh >= 330) & (addrh <= 340)) | ((addrh >= 360) & (addrh <= 370)) | ((addrh >= 380) & (addrh <= 390)) | ((addrh >= 400) & (addrh <= 410))))
            colour <= reg_4_colour;
        else if (((addrv >= 430) & (addrv <= 440)) & (((addrh >= 240) & (addrh <= 260)) | ((addrh >= 290) & (addrh <= 300)) | ((addrh >= 330) & (addrh <= 340)) | ((addrh >= 360) & (addrh <= 370)) | ((addrh >= 380) & (addrh <= 410))))
            colour <= reg_4_colour;        
        else if (((addrv >= 440) & (addrv <= 450)) & (((addrh >= 260) & (addrh <= 270)) | ((addrh >= 290) & (addrh <= 300)) | ((addrh >= 330) & (addrh <= 340)) | ((addrh >= 360) & (addrh <= 370)) | ((addrh >= 380) & (addrh <= 390))))
            colour <= reg_4_colour;        
        else if (((addrv >= 450) & (addrv <= 460)) & (((addrh >= 240) & (addrh <= 270)) | ((addrh >= 290) & (addrh <= 300)) | ((addrh >= 340) & (addrh <= 360)) | ((addrh >= 380) & (addrh <= 390))))
            colour <= reg_4_colour;
        // Letter pattern for pedestrian go
        else if (((addrv >= 350) & (addrv <= 360)) & (((addrh >= 270) & (addrh <= 290)) | ((addrh >= 350) & (addrh <= 370))))
            colour <= reg_9_colour;
        else if (((addrv >= 360) & (addrv <= 370)) & (((addrh >= 260) & (addrh <= 270)) | ((addrh >= 340) & (addrh <= 350)) | ((addrh >= 370) & (addrh <= 380))))
            colour <= reg_9_colour;
        else if (((addrv >= 370) & (addrv <= 380)) & (((addrh >= 260) & (addrh <= 270)) | ((addrh >= 280) & (addrh <= 300)) | ((addrh >= 340) & (addrh <= 350)) | ((addrh >= 370) & (addrh <= 380))))
            colour <= reg_9_colour;
        else if (((addrv >= 380) & (addrv <= 390)) & (((addrh >= 260) & (addrh <= 270)) | ((addrh >= 290) & (addrh <= 300)) | ((addrh >= 340) & (addrh <= 350)) | ((addrh >= 370) & (addrh <= 380))))
            colour <= reg_9_colour;
        else if (((addrv >= 390) & (addrv <= 400)) & (((addrh >= 270) & (addrh <= 290)) | ((addrh >= 350) & (addrh <= 370))))
            colour <= reg_9_colour;
        // Straight light for road 1
        else if ((((addrh >= 370) & (addrh <= 417)) & ((addrv >= 81) & (addrv <= 128))) | ((48*addrh + 48*addrv >= 20496) & (48*addrh - 47*addrv <= 17361) & (addrv <= 81) & ((addrh >= 346) & (addrh <= 441)) & ((addrv >= 33) & (addrv <= 81))))
            colour <= reg_2_colour;
        // Straight light for road 2
        else if ((((addrh >= 334) & (addrh <= 381)) & ((addrv >= 240) & (addrv <= 287))) | ((48*addrh + 48*addrv >= 26400) & (48*addrh - 47*addrv <= 8160) & (addrv <= 240) & ((addrh >= 310) & (addrh <= 405)) & ((addrv >= 192) & (addrv <= 240))))
            colour <= reg_8_colour;
        // Right-turn light for road 1
        else if ((((addrh >= 495) & (addrh <= 542)) & ((addrv >= 59) & (addrv <= 105))) | ((47*addrh - 47*addrv <= 23829) & (47*addrh + 47*addrv <= 31537) & (addrh >= 542) & ((addrh >= 542) & (addrh <= 589)) & ((addrv >= 35) & (addrv <= 129))))
            colour <= reg_3_colour;
        // Right-turn light for road 2
        else if ((((addrh >= 459) & (addrh <= 506)) & ((addrv >= 218) & (addrv <= 264))) | ((47*addrh - 47*addrv <= 14664) & (47*addrh + 47*addrv <= 37318) & (addrh >= 506) & ((addrh >= 506) & (addrh <= 553)) & ((addrv >= 194) & (addrv <= 288))))
            colour <= reg_5_colour;
        // Traffic light frame
        else if ((((addrv >= 62) & (addrv <= 102)) & ((addrh >= 0) & (addrh <= 69))) | (((addrv >= 220) & (addrv <= 260)) & ((addrh >= 574) & (addrh <= 640))) | (((addrh >= 310) & (addrh <= 330)) & ((addrv >= 470) & (addrv <= 480))))
            colour <= 12'b000100011110;
        // Traffic light frame
        else if ((((addrv >= 11) & (addrv <= 151)) & ((addrh >= 69) & (addrh <= 607))) | (((addrv >= 170) & (addrv <= 310)) & ((addrh >= 36) & (addrh <= 574))))
            colour <= 12'b000001001100;
        // Area to display "GO" and "STOP"
        else if (((addrh >= 220) & (addrh <= 420)) & ((addrv >= 340) & (addrv <= 470)))
            colour <= 12'b111011101110;
        else
            colour <= 12'b111111111111;
	end
  
endmodule
