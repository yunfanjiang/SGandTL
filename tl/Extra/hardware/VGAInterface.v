`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 			University of Edinburgh
// Engineer: 			Godwin Enemali
// 
// Create Date:   	00:26:38 11/08/2013 
// Design Name: 		Digital System Lab A (Assignment III)
// Module Name:   	Generic_Counter4_VGA 
// Project Name: 		Colouring The World
// Target Devices:	FPGA Board; Digilent BASYS 2
// Tool versions: 	P.49d
// Description: 		This module use instances of the generic counter to create two synchronisation signals
//							HS (Horizontal) and VS (vertical) that continually refreshes the display pixels.
//							The module also create two addresses using the counters that selects a pixel for
//							a desired display.
// Dependencies: 		It depends on the generic counter and VGA_Wrapper modules for its complete functionality
//
// Revision: Nil
// Revision 0.01 - File Created
// Additional Comments: Nil
//
//////////////////////////////////////////////////////////////////////////////////

//Interface list is defined, stating inputs and outputs as well
//as dimentions

module VGAInterface(
    input CLK,
    input [11:0] C_IN,
    output reg [11:0] C_OUT,
    output reg HS,
    output reg VS,
    output [9:0] ADR_X,
    output [8:0] ADR_Y
    );

    //Time in Vertical lines which help to easily
    //define ranges of desired behaviour of each
    //counter
    parameter Vert_Time_To_PulseWidth_End 	= 10'd2;
    parameter Vert_Time_To_BackPorch_End 	= 10'd31;
    parameter Vert_Time_To_DisplayTime_End  = 10'd511;
    parameter Vert_Time_To_FrontPorch_End 	= 10'd521;

    //Time in Horinzontal lines which help to easily
    //define ranges of desired behaviour of each
    //counter
    parameter Hor_Time_To_PulseWidth_End 	= 10'd96;
    parameter Hor_Time_To_BackPorch_End 	= 10'd144;
    parameter Hor_Time_To_DisplayTime_End 	= 10'd784;
    parameter Hor_Time_To_FrontPorch_End 	= 10'd800;
    
    //wires are created to be used as connectors between
    //counter interfaces as well as registers for the
    //addresses

    wire bit_1trig_out;
    wire [9:0] COUNT_HS;
    wire [9:0] COUNT_VS;
    wire trig_out_HS;
    wire trig_out_AX;
    reg [9:0] Address_X;
    reg [8:0] Address_Y;

    //This instance of a generic counter is a single bit counter
    //created to reduce the 50MHz available on the board to 25MHz
    GenericCounter # (
        .COUNTER_WIDTH(2), 
        .COUNTER_MAX(3)
        ) 
        Bit_1_counter (
            .CLK(CLK), 
            .RESET(1'b0), 
            .ENABLE(1'b1), 
            .TRIGER_OUT(bit_1trig_out)
        );
												
    //Instances of the generic counters to serve as generators of 
    //Horizontal and vercical synchronization signals
    GenericCounter # (
        .COUNTER_WIDTH(10), 
        .COUNTER_MAX(Hor_Time_To_FrontPorch_End-1)
        )
        counter_HS (
            .CLK(CLK), 
            .RESET(1'b0), 
            .ENABLE(bit_1trig_out), 
            .COUNT(COUNT_HS),
            .TRIGER_OUT(trig_out_HS)
        );
							  
    GenericCounter # (
        .COUNTER_WIDTH(10),
        .COUNTER_MAX(Vert_Time_To_FrontPorch_End-1)
        ) 
        counter_VS (
            .CLK(CLK), 
            .RESET(1'b0), 
            .ENABLE(trig_out_HS), 
            .COUNT(COUNT_VS)
        );
							  					  
    //HS is set LOW only when COUNT_HS is less than Horizontal time to 
    //pulse width end, and HIGH everywhere else
    always@(posedge CLK)begin
        if(COUNT_HS < Hor_Time_To_PulseWidth_End)
            HS <= 0;
        else
            HS <= 1;
    end
	
    //Just like HS above, VS is defined.
    always@(posedge CLK)begin
        if(COUNT_VS < Vert_Time_To_PulseWidth_End)
            VS <= 0;
        else
            VS <= 1;
    end
		
    //The output C_out is now defined when the synchronization signals
    //are within the display range. In that range they take value of input
    //otherwise they take the value 8'h00
    always@(posedge CLK)begin
        if(((COUNT_HS > Hor_Time_To_BackPorch_End) && (COUNT_HS < Hor_Time_To_DisplayTime_End))
            &&((COUNT_VS > Vert_Time_To_BackPorch_End) && (COUNT_VS < Vert_Time_To_DisplayTime_End)))
            C_OUT <= C_IN;
        else
            C_OUT <= 8'h00;
    end
		
    //Addresses X and Y are now defined to select pixels only when the synchronization
    //are within the display region (after back porch and just before front porch)
    always@(posedge CLK)begin
        if((COUNT_HS > Hor_Time_To_BackPorch_End)&&(COUNT_HS < Hor_Time_To_DisplayTime_End))
            Address_X <= COUNT_HS - Hor_Time_To_BackPorch_End;
        else
            Address_X <= 0;
            
        if((COUNT_VS > Vert_Time_To_BackPorch_End)&&(COUNT_VS < Vert_Time_To_DisplayTime_End))
            Address_Y <= COUNT_VS - Vert_Time_To_BackPorch_End;
        else
            Address_Y <= 0; 
    end

    //The registers containing Addresses X and Y are assigned to the ouput
    //ADR_X and ADR_Y
    assign ADR_X = Address_X;
    assign ADR_Y = Address_Y;					  

endmodule
