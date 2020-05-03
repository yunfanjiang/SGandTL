`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 18.11.2018 17:43:34
// Design Name: Mode Selection Module
// Module Name: mode_selection
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module allows the players to select the game mode from normal mode and endless mode by slide switches.
// In normal mode, when the player gets ten marks, then he or she will win.
// In endless mode, the player will never win. What he or she can do is to reach the targets continuously or fail the game.
// A multiplexer is used to realize these functionalities.
// 
// Dependencies: 
// It depends on the 23-bit 4-to-1 multiplexer for its full functionalities.
// 
// Revision:
// Revision 1.1.0
// Last edited on: 24 Nov 2018
// Additional Comments:
// Block diagram for the Mode Selection Module
/*
                                    MODE_SELECT
                                        /
                                        |
                +-----------------------|-------------------+
                |                       |                   |
                |                       |                   |
                |                  /-,  |                   |
                |                  |  ',|                   |
                |                  |    \.                  |
                |         10--------      `'                |
                |                  |       |                |
                |                  |       |                |
                |                  |  Mux  ---------/       |
                |                  |       |        |       |
                |                  |       |        |       |
                |                  |       |        |       |
                |      99999--------       .        |       |
                |                  |    ,-`         |       |
                |                  |  ,'            |       |
                |                  \-`              |       |
                |                                   |       |
                |                                   |       |
                |                                   |       |
                +-----------------------------------|-------+
                                                    |
                                                    |
                                                    \
                                              SCORE_TO_WIN
*/
//////////////////////////////////////////////////////////////////////////////////


module mode_selection(
    input         MODE_SELECT,  // Connect to the slide switches through which the players can select the game modes
    output [16:0] SCORE_TO_WIN  // Connect to the input of Score Counter, which determines the score the players have to get to win the game
    );
    
    // Instantiation for the multiplexer
    bit23_4to1_mux MUX (
    .SEL_SIGNAL (MODE_SELECT),
    .MUX_IN_0   (10),
    .MUX_IN_1   (99999),
    .MUX_IN_2   (), // Pin not used
    .MUX_IN_3   (), // Pin not used
    .MUX_OUT    (SCORE_TO_WIN)
    );
endmodule
