`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 12.11.2018 10:21:25
// Design Name: Colour Control Logic
// Module Name: colour_control_logic
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module will output different colour values according to the state of the master state machine.
// When the master state machine is in idle state, it will colour the screen blue.
// When the master state machine is in playing state, it will colour the snake yellow, colour the target red, and colour the background blue.
// When the master state machine is in win state, it will display the winning pattern.
// A "case" statement is used to realize these functionalities. 
//
// Dependencies: 
// It depends on Colour Control Logic and VGA Interface for its full functionalities.
// 
// Revision:
// Revision 1.1.1
// Last edited on: 21 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module colour_control_logic(
    input             CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input             RESET,        // Connect to the middle button to reset the state into idle state
    input      [1:0]  MSM_STATE_IN, // Connect to the output of Master State Machine
    input      [7:0]  WIN_MOVE,     // Connect to the output of Win State Pattern Display
    input      [8:0]  Y,            // Connect to the output of VGA Interface
    input      [9:0]  X,            // Connect to the output of VGA Interface
    input      [11:0] AUTO_COLOUR,  // Connect to the output of Auto Colour Module
    input      [11:0] COLOUR_IN,    // Connect to the output of the Snake Control Module
    input      [11:0] WIN_COLOUR,   // Connect to the output of Win State Pattern Display
    output reg [11:0] COLOUR_OUT    // Connect to the input of VGA Interface
    );
    
    // Definition for parameters
    parameter radius = 50;      // Radius for the circles displayed in winning state
    parameter centre_x = 319;   // The pixel position for the horizontal center
    parameter centre_y = 239;   // The pixel position for the vertical center

    // Definition for colour logic
    always@ (posedge CLK) begin
        if (RESET) begin
            COLOUR_OUT <= 12'b111100000000;         // Reset to idle state, colour the screen blue
        end // if
        else begin
            case (MSM_STATE_IN)                     // According to the state of master state machine to output colour values
                2'b00: begin                        // Idle state, colour the screen blue
                    COLOUR_OUT <= 12'b111100000000;
                end
                
                2'b01: begin                        // Playing state, the colour value is determined by the Snake Control Module
                    COLOUR_OUT <= COLOUR_IN;
                end
                
                2'b10: begin                        // Win state, display the winning pattern, in this case, the Scotland flag
                    // II quadrant circle
                    if ((((X - (centre_x - WIN_MOVE)) * (X - (centre_x - WIN_MOVE))) + ((Y - (centre_y - WIN_MOVE)) * (Y - (centre_y - WIN_MOVE)))) <= (radius * radius))
                        COLOUR_OUT <= AUTO_COLOUR * 20;
                    // I quadrant circle
                    else if ((((X - (centre_x + WIN_MOVE)) * (X - (centre_x + WIN_MOVE))) + ((Y - (centre_y - WIN_MOVE)) * (Y - (centre_y - WIN_MOVE)))) <= (radius * radius))
                        COLOUR_OUT <= AUTO_COLOUR * 40;
                    // III quadrant circle
                    else if ((((X - (centre_x - WIN_MOVE)) * (X - (centre_x - WIN_MOVE))) + ((Y - (centre_y + WIN_MOVE)) * (Y - (centre_y + WIN_MOVE)))) <= (radius * radius))
                        COLOUR_OUT <= AUTO_COLOUR * 60;
                    // IV quadrant circle
                    else if ((((X - (centre_x + WIN_MOVE)) * (X - (centre_x + WIN_MOVE))) + ((Y - (centre_y + WIN_MOVE)) * (Y - (centre_y + WIN_MOVE)))) <= (radius * radius)) 
                        COLOUR_OUT <= AUTO_COLOUR * 80;
                    // Central displaying area
                    else if (((X >= (centre_x + radius - WIN_MOVE)) && (X <= (centre_x - radius + WIN_MOVE)) && (Y >= (centre_y +radius - WIN_MOVE)) && (Y <= (centre_y - radius + WIN_MOVE))))     
                        COLOUR_OUT <= WIN_COLOUR;
                    else
                        COLOUR_OUT <= 12'b111100000000;                    
                end
                        
                default:                            // In default case, colour the screen blue
                    COLOUR_OUT <= 12'b111100000000;
            endcase
        end // else
    end // always
endmodule
