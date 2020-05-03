`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 12.11.2018 11:10:39
// Design Name: Pseudo Random Number Generator
// Module Name: pseudo_random_number_generator
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description:
// A Linear Feedback Shift Register (LFSR) is developed in this module to generate pseudo random number by using "generate" syntax.
// This LFSR is with adjustable width and can be applied to generate the addresses of target in Target Generator.
// Several d-type flip flops are connected in series and the input of the first flip flop is determined by certain combinational logic.
// The total output is composed of the outputs of each flip flops.  
// 
// Dependencies: 
// It depends on d-type flip flop for its full functionalities.
//
// Revision:
// Revision 1.1.0
// Last edited on: 16 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pseudo_random_number_generator(
    CLK,        // Connect to the on-board clock with the frequency of 100MHz
    RESET,      // Connect to the middle button to reset the state into idle state
    PRNG_OUT    // Output the pseudo random number
    );
    
    // Definition for parameter
    parameter WIDTH = 8;    // This parameter defines the number of d-type flip flops in the LFSR
    
    // Definition for I/Os
    input                CLK;       // Connect to the on-board clock with the frequency of 100MHz
    input                RESET;     // Connect to the middle button to reset the state into idle state
    output [WIDTH - 1:0] PRNG_OUT;  // Output the pseudo random number
    
    // Definition for the intermediate wire
    wire [WIDTH:0] W;
    
    // Definition for the generate variable
    genvar DtypeNo;
    // Use "generate" syntax to develop a shifting register with the flip flop's number of "WIDTH" 
    generate
        for (DtypeNo = 0; DtypeNo < WIDTH; DtypeNo = DtypeNo + 1)
        begin: Instantiation_for_D_Type
            d_type_register D_Type_FF (.CLK (CLK), .RESET (RESET), .D_IN (W[DtypeNo]), .D_OUT (W[DtypeNo + 1]));    // Connect flip flops in series
        end // for
    endgenerate
    
    // Connect the intermediate wire to the output
    assign PRNG_OUT = W[WIDTH:1];
    // Determine the input of the first flip flop by a combinational logic
    assign W[0] = ~((W[WIDTH - 4]) ^ (~((W[WIDTH - 3]) ^ (~(W[WIDTH] ^ W[WIDTH - 2])))));
endmodule