`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 21.11.2018 14:02:47
// Design Name: Idle State Pattern
// Module Name: idle_state_pattern
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// The idle state pattern is determined in this module.
// The idle state pattern is stored in a 12 * 131072 ROM created by the IP core.
// The movement of the idle state pattern is controlled by an 8-bit generic counter.
// 
// Dependencies: 
// It depends on the Idle State Pattern Rom and generic counter for its full functionalities.
// 
// Revision:
// Revision 1.5.1
// Last edited on: 24 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module idle_state_pattern(
    input         CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input         VERT_TRIG,    // Connect to the output of VGA Interface, the trigger-out signal of the vertical syn counter
    input  [8:0]  Y,            // Connect to the output of VGA Interface, the vertical address for the pixels
    input  [9:0]  X,            // Connect to the output of VGA Interface, the horizontal address for the pixles
    output [7:0]  IDLE_MOVE,    // Connect to the input of Colour Control Logic, the counting value to control the movement of pattern
    output [11:0] IDLE_COLOUR   // Connect to the input of Colour Control Logic, the colour value for the idle state pattern
    );
    
    // Definition for intermediate wires
    wire [7:0]  rom_y;  // This wire and wire "rom_x" will be input to the ROM to find the colour value for the idle state pattern at specific location
    wire [8:0]  rom_x;  // This wire and wire "rom_y" will be input to the ROM to find the colour value for the idle stat epattern at specific location
    
    // Connect the inputs to the intermediate wires
    assign rom_y = Y - 111; // To show the pattern at the center area, the vertical address of pixel should be subtracted by 111
    assign rom_x = X - 63;  // To show the pattern at the center area, the horizontal address of pixel should be subtracted by 63
    
    // Instantiation for the Idle State Pattern Rom, which stores the colour value for the idle state pattern
    Idle_State_Pattern_Rom Idle_State_Pattern_Rom (
    .clka     (CLK),
    .addra    ({rom_x, rom_y}),
    .douta    (IDLE_COLOUR)
    );

    // Instantiation for the Pattern Move Counter
    generic_counter # (.COUNTER_WIDTH (8), .COUNTER_MAX   (256)) Pattern_Move_Counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (VERT_TRIG),
    .TRIG_OUT (),           // Pin not used
    .COUNT    (IDLE_MOVE)
    );
endmodule