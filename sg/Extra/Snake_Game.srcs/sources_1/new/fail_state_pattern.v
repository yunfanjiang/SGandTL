`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 23.11.2018 08:48:49
// Design Name: Fail State Pattern
// Module Name: fail_state_pattern
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// The fail state pattern is defined in this module.
// The fail state pattern is stored in a 12 * 8192 ROM realized by the statement "$readmemh".
// The movement of the fail state pattern is controlled by a 7-bit counter.
// 
// Dependencies: 
// It depends on generic counter for its full functionalities.
// 
// Revision:
// Revision 1.2.0
// Last edited on: 24 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fail_state_pattern(
    input             CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input             VERT_TRIG,    // Connect to the output of VGA Interface, the trigger-out signal of the vertical syn counter
    input      [8:0]  Y,            // Connect to the output of VGA Interface, the vertical address for the pixels
    input      [9:0]  X,            // Connect to the output of VGA Interface, the horizontal address for the pixles
    output     [6:0]  FAIL_MOVE,    // Connect to the input of Colour Control Logic, the counting value to control the movement of pattern
    output reg [11:0] FAIL_COLOUR   // Connect to the input of Colour Control Logic, the colour value for the fail state pattern
    );
    
    // Definition for the intermediate wires
    wire [6:0] rom_x;   // This wire and wire "rom_y" will be input to the ROM to find the colour value for the fail state pattern at specific location
    wire [5:0] rom_y;   // This wire and wire "rom_x" will be input to the ROM to find the colour value for the fail state pattern at specific location
    
    // Definition for the ROM to store the colour value for the fail state pattern
    reg [11:0] fail_colour [8191:0];
    
    // Connect the inputs to the intermediate wires
    assign rom_x = X - 256; // To show the pattern at the center area, the horizontal address of pixel should be subtracted by 256
    assign rom_y = Y - 208; // To show the pattern at the center area, the vertical address of pixel should be subtracted by 208
    
    // Initialization for the ROM
    initial begin
        $readmemh ("fail_state_pattern_rom.list", fail_colour); // Read the previously-written ROM file
    end // initial
    
    // Read colour value from the ROM corresponding to the pixel addresses
    always@ (posedge CLK) begin
        FAIL_COLOUR <= fail_colour[{rom_x,rom_y}];
    end // always
    
    // Instantiation for the Pattern Move Counter
    generic_counter # (.COUNTER_WIDTH (7), .COUNTER_MAX   (127)) Fail_Pattern_Move_Counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (VERT_TRIG),
    .TRIG_OUT (),           // Pin not used
    .COUNT    (FAIL_MOVE)
    );
endmodule
