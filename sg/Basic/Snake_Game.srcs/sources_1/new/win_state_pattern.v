`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University Of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 22.11.2018 15:47:21
// Design Name: Win State Pattern Display Module
// Module Name: win_state_pattern
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// Major code in this module is from previous work in Digital Systems Lab 3 Module 10.
// Pattern for Scotland Flag is defined in this module.
// Pattern is displayed based on the pixel addresses, which is realized by "if...else..." statement.
// Meanwhile, it will output a counting value to control the movement of the pattern, which is realized by the generic counter.
// 
// Dependencies: 
// It depends on the generic counter for its full functionalities. 
//
// Revision:
// Revision 1.1.0
// Last edited on: 24 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module win_state_pattern(
    input             CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input             RESET,        // Connect to the middle RESET button
    input             VERT_TRIG,    // Connect to the trigger out of the vertical syn counter in the VGA interface
    input      [8:0]  Y,            // Connect to the output of the VGA interface. The vertical address of pixel
    input      [9:0]  X,            // Connect to the output of the VGA interface. The horizontal address of pixel
    output     [7:0]  WIN_MOVE,     // Connect to the input of Colour Control Logic to control the movement of the pattern
    output reg [11:0] WIN_COLOUR    // Connect to the input of Colour Control Logic to determine the pattern
    );
    
    // Instantiation for the Pattern Move Counter
    generic_counter # (.COUNTER_WIDTH (8), .COUNTER_MAX   (249)) Win_Pattern_Move_Counter (
    .CLK      (CLK),
    .RESET    (RESET),
    .ENABLE   (VERT_TRIG),
    .TRIG_OUT (),           // Pin not used
    .COUNT    (WIN_MOVE)
    );

    // Logic to define the pattern
    always@ (posedge CLK) begin
        if (((X >= 129) && (X <= 509)) && ((Y >= 135) && (Y <= 363))) begin // Flag area
            if ((((10 * Y - 6 * X) >= 312) && ((10 * Y - 6 * X) <= 836)) | (((6 * X + 10 * Y) >= 4134) && ((6 * X + 10 * Y) <= 4658)))  // The Cross Area
                WIN_COLOUR <= 12'b111111111111; // Colour the region white within the cross area
            else
                WIN_COLOUR <= 12'b111101110000; // Colour the region blue out of the cross area
            end // if
        else
                WIN_COLOUR <= 12'b111100000000;
    end // always
endmodule