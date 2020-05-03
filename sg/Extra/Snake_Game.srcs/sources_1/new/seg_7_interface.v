`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 16.11.2018 08:30:49
// Design Name: Seven-segment Interface
// Module Name: seg_7_interface
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// Major code is from previous work in Digital Systems Lab 3 Module 9.
// Strobe mechanism to drive the 7-segment display is developed here.
// The 7-segment display interface can be used to display the score that the player gets.
// 
// Dependencies: 
// It depends on generic counter, five-bit four-to-one multiplexer, and seven-segment decoder for its full functionalities. 
//
// Revision:
// Revision 1.2.0
// Lasr edited on: 24 Nov 2018
// Additional Comments:
// Block diagram for the Seg_7 Interface
/*
                         RESET     CLK
                           /        /
                           |        |                                           DIGIT_IN
                           |        |                                            . . . .
                           |        |                                            | | | |
                           |        |                                            | | | |                                                        
                       +---\--------|--------------------------------------------|-|-|-|-------------------------------------------------+      
                       |            -------------------------------/             | | | |                                                 |      
                       |            |                              |             | | | |                                                 |      
                       |            |                              |             | | | |                                                 |      
                       |     +------\-----+                 +------\-----+       | | | | -,               +------------------+           |      
                       |     |     CLK    |Trig             |     CLK    |       | | | | | ',             |                  |           |      
                       |    1| EN         ------------------- EN         |       | | | | |   '.           |                  |           |      
                       |     |            |                 |            |       | | | \--     `.         |                  |           |      
                       |     |            |                 |            |       | | |   |       `'       |                  |           |      
                       |     |            |                 |            |       | | |   |        |       |BIN               |           |      
                       |     |    Bit17   |                 |   Strobe   |       | | \----   Mux  ---------_IN    Decoder    |           |      
                       |     |   Counter  |                 |  Counter   |       | |     |        |       |                  |           |      
                       |     |            |                 |            |       | |     |        |       |                  |           |      
                       |     |            |                 |            |       | \------        .   ----- Seg_             |           |      
                       |     |            |                 |            |       |       |     .-`    |   |Select            |           |      
                       |    0| R          |            RESET| R          |       |       |   ,-|      |   |                  |           |      
                       |     |            |                 |            |       \-------- .'  |      |   |                  |           |      
                       |     +------------+                 +------/-----+               -`    |      |   +-----/------/-----+           |      
                       |                                           |                     Select|      |         |      |                 |      
                       |                                      Count|                           |      |    SEG_ |      | DEC             |      
                       |                                           |                           |      |   SELECT|      | OUT             |      
                       |                                           \---------------------------\------\         |      |                 |      
                       |                                                                                        |      |                 |      
                       |                                         /----------------------------------------------\      |                 |      
                       |                                         |                  /----------------------------------\                 |      
                       |                                         |                  |                                                    |      
                       +-----------------------------------------|------------------|----------------------------------------------------+      
                                                                 |                  |                                                           
                                                                 |                  |                                                           
                                                                 |                  |                                                           
                                                                 \                  \                                                           
                                                                SEG_               DEC
                                                               SELECT              OUT 
*/                       
//////////////////////////////////////////////////////////////////////////////////


module seg_7_interface(
    input        CLK,           // Connect to the on-board clock with the frequency of 100MHz
    input        RESET,         // Connect to the middle button to reset the state into idle state
    input  [4:0] DIGIT_IN_0,    // Connect to the output of Score Counter
    input  [4:0] DIGIT_IN_1,    // Connect to the output of Score Counter
    input  [4:0] DIGIT_IN_2,    // Connect to the output of Score Counter
    input  [4:0] DIGIT_IN_3,    // Connect to the output of Score Counter
    output [3:0] SEG_SELECT,    // Connect to the input of seven-segment decoder    
    output [7:0] DEC_OUT        // Connect to the input of seven-segment decoder
    );
     
    // Definition for intermediate wires
    wire       Bit17TriggOut;   // Connect the output of the 17-bit counter to the input of the strobe counter
    wire [1:0] StrobeCountOut;  // Connect the output of the strobe counter to the input of the Multiplexer
    wire [4:0] MuxOut;          // Connect the output of the multiplexer to the input of the seven-segment decoder
        
    // Instantiation for the 17-bit counter
    // This counter slows down the on-board clock with the frequency of 100 MHz to the frequency of 1 KHz
    generic_counter # (.COUNTER_WIDTH (17), .COUNTER_MAX   (99999)) Bit17_Counter (
    .CLK            (CLK),
    .RESET          (1'b0),
    .ENABLE         (1'b1),
    .TRIG_OUT       (Bit17TriggOut),
    .COUNT          ()    // Pin not used
    );
                       
    // Instantiation for the 2-bit strobe counter
    // This counter is for the strobe mechanism of the 7-segment display
    generic_counter # (.COUNTER_WIDTH (2), .COUNTER_MAX   (3)) Strobe_Counter (
    .CLK            (CLK),
    .RESET          (RESET),
    .ENABLE         (Bit17TriggOut),
    .TRIG_OUT       (),    // Pin not used
    .COUNT          (StrobeCountOut)
    );
                                              
    // Instantiation for the MUX
    MUX Mux4to1 (
    .SIGNAL_SELECT  (StrobeCountOut),
    .SIGNAL_IN_0    (DIGIT_IN_0),
    .SIGNAL_IN_1    (DIGIT_IN_1),
    .SIGNAL_IN_2    (DIGIT_IN_2),
    .SIGNAL_IN_3    (DIGIT_IN_3),
    .SIGNAL_OUT     (MuxOut)
    );
                 
    // Instantiation for the decoder
    Seg7 Decoder (
    .SEG_SELECT_IN  (StrobeCountOut),
    .BIN_IN         (MuxOut [3:0]),
    .DOT_IN         (1'b0),
    .SEG_SELECT_OUT (SEG_SELECT),
    .HEX_OUT        (DEC_OUT)
    );

endmodule
