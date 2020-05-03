`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 22.11.2018 14:21:15
// Design Name: Win State Pattern
// Module Name: win_state_pattern
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// The winning pattern is determined in this module.
// "If...else..." statement is used to display this pattern.
// The movement of the pattern is controlled by an 8-bit generic counter.
// The code to define the pattern is from previous work in Digital Systems Lab 3 Module 10.
// 
// Dependencies: 
// It depends on generic counter for its full functionalities.
// 
// Revision:
// Revision 1.2.4
// Last edited on: 24 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module win_state_pattern(
    input             CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input             RESET,        // Connect to the middle RESET button to reset this module
    input             VERT_TRIG,    // Connect to the output of VGA Interface, the trigger-out signal of the vertical syn counter
    input      [8:0]  Y,            // Connect to the output of VGA Interface, the vertical address for the pixels
    input      [9:0]  X,            // Connect to the output of VGA Interface, the horizontal address for the pixles
    output     [7:0]  WIN_MOVE,     // Connect to the input of Colour Control Logic, the counting value to control the movement of pattern
    output reg [11:0] WIN_COLOUR    // Connect to the input of Colour Control Logic, the colour value for the win state pattern
    );
    
    // Instantiation for the Pattern Move Counter
    generic_counter # (.COUNTER_WIDTH (8), .COUNTER_MAX   (249)) Win_Pattern_Move_Counter (
    .CLK      (CLK),
    .RESET    (RESET),
    .ENABLE   (VERT_TRIG),
    .TRIG_OUT (),           // Pin not used
    .COUNT    (WIN_MOVE)
    );

    always@ (posedge CLK) begin
        if (((X >= 129) && (X <= 509)) && ((Y >= 135) && (Y <= 363))) begin // Flag area
            if ((((10 * Y - 6 * X) >= 312) && ((10 * Y - 6 * X) <= 836)) | (((6 * X + 10 * Y) >= 4134) && ((6 * X + 10 * Y) <= 4658)))  // The Cross Area
                WIN_COLOUR <= 12'b111111111111; // Colour the pixels white within the cross area
            else
                WIN_COLOUR <= 12'b111101110000; // Colour the pixels blue out of the cross area
            end // if
        else
            WIN_COLOUR <= 12'b111011101100;     // Colour the pixels blue out of the flag area
    end // always
endmodule
