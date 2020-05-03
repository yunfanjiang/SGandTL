`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 15.11.2018 11:45:44
// Design Name: Target Generator
// Module Name: target_generator
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module can generate the addresses for the target randomly by using a 7-bit LFSR and a 8-bit LFSR.
// It will record and hold the addresses until the target is reached by the player.
// After the old target is reached, a new target will be generated.
// It can also make sure that the new address is within range by subtracting correction value when the new address is out of the range. 
//
// Dependencies: 
// It depends on pseudo_random_number_generator and target_record_and_hold for its full functionalities.
//
// Revision:
// Revision 1.1.1
// Last edited on: 24 Nov 2018
// Additional Comments:
// Block diagram for the Target Generator
/*
                          RESET     CLK         REACHED_TARGET
                           /        /               /
                           |        |               |
                +----------|--------|---------------|--------------------------------+
                |          |        -------.--------|--------------------/           |
                |          |        |      |        |                    |           |
                |          |        |      |        |         RESET      |           |
                |     +----\--------\----+ |        |      +-------------\----+      |
                |     |    R       CLK   | |        |      |    R       CLK   |      |
                |     |                  | |        |      |                  |      |
                |     |                  | |        |      |                  |      |
                |     |                  | |        |      |                  |      |
                |     |      X_PRNG      | |        |      |      Y_PRNG      |      |
                |     |                  | |        |      |                  |      |
                |     |                  | |        |      |                  |      |
                |     |                  | |        |      |                  |      |
                |     |                  | |        |      |                  |      |
                |     |                  | |        |      |                  |      |
                |     +-------/----------+ |        |      +---------/--------+      |
                |             |            |        |                |               |
                |    ADDRESS_X|            |   REACHED_TARGET        | ADDRESS_Y     |
                |             |            |        |                |               |
                |     +-------\------------\--------\----------------\--------+      |
                |     |                   CLK                                 |      |
                |     |                                                       |      |
                |     |                                                       |      |
                |     |                   Record_and_Hold                     |      |
                |     |                                                       |      |
                |     |                                                       |      |
                |     |                                                       |      |
                |     +--------------------/-------------/--------------------+      |
                |                          |             |                           |
                |                          |             |                           |
                |                          |             |                           |
                |                          |             |                           |
                |                          |             |                           |
                +--------------------------|-------------|---------------------------+
                                           |             |
                                           |             |
                                           \             \
                                    ADDRESS_X_OUT     ADDRESS_Y_OUT   
*/
//////////////////////////////////////////////////////////////////////////////////


module target_generator(
    input        CLK,           // Connect to the on-board clock with the frequency of 100MHz
    input        RESET,         // Connect to the middle button to reset the state into idle state
    input        REACHED_TRGT,  // Connect to the output of Snake Control Module
    output [6:0] TRGT_Y_OUT,    // Connect to the input of Snake Control Module
    output [7:0] TRGT_X_OUT     // Connect to the input of Snake Control Module
    );
    
    // Definition for intermediate wires
    wire [6:0] Target_address_Y;    // Connect the output of Y_PRNG to the input of Record_and_Hold
    wire [7:0] Target_address_X;    // Connect the output of X_PRNG to the input of Record_and_Hold
    
    // Instantiation for the PRNG to generate X address of target
    pseudo_random_number_generator # (.WIDTH (8)) X_PRNG (
    .CLK          (CLK),
    .RESET        (RESET),
    .PRNG_OUT     (Target_address_X)
    );

    // Instantiation for the PRNG to generate Y address of target
    pseudo_random_number_generator # (.WIDTH (7)) Y_PRNG (
    .CLK          (CLK),
    .RESET        (RESET),
    .PRNG_OUT     (Target_address_Y)
    );
                                     
    // Instantiation for the Target Record and Hold
    // This module can record and hold the addresses of target and guarantee that it is within the range
    target_record_and_hold Record_and_Hold (
    .CLK          (CLK),
    .REACHED_TRGT (REACHED_TRGT),
    .TRGT_Y_IN    (Target_address_Y),
    .TRGT_X_IN    (Target_address_X),
    .TRGT_Y_OUT   (TRGT_Y_OUT),
    .TRGT_X_OUT   (TRGT_X_OUT)
    );
endmodule
