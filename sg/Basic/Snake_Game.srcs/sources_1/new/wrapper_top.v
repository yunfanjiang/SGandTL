`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 15.11.2018 16:08:12
// Design Name: Top Wrapper
// Module Name: wrapper_top
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// A simplified version of snake game is developed in this project.
// By pressing any push buttons, the player can enter the playing mode.
// In the playing mode, player can control the movement of the snake by pressing four direction buttons to eat the target.
// Once the player eats a target successfully, one mark will be added.
// When the player gets ten marks, he or she will succeed and the monitor will display the win pattern. Then the player can press the middle button to start a new game.
// The player can start a new game by simply pressing the middle button during the game.
// The sanke will not hit itself, and it will not die when touching the walls. So there is no need for player to worry about that.
// Good luck and have fun :)
// 
// Dependencies: 
// It depends on Master State Machine Module, Navigation State Machine Module, Snake Control Module, Target Generator, VGA Interface, Score Counter,
// and 7-segment Interface for its full functionalities.
//
// Revision:
// Revision 1.3.2
// Last edited on: 24 Nov 2018
// Additional Comments:
// Block diagram for the project
/*
                                                     Push Buttons     
                                                         /
                                                         |
                +----------------------------------------|-----------------------------------------------+
                |                                        |                                               |
                |                   /--------------------\----------------------/                        |
                |                   |                                           |                        |
                |        +----------\--------------+           +----------------\---------------+        |
                |        |                         |           |                                |        |
                |        |  Master State Machine   |           |    Navigation State Machine    |        |
                |        |                         |           |                                |        |
                |        +----------/--------------+           +----------------/---------------+        |
                |                   |                                           |                        |
                |                   |                                           |                        |
                |                   |                                           |                        |
                |          /--------\-------------/         /-------------------\                        |
                |          |                      |         |                                            |
                |          |                      |         |                                            |
                |          |                      |         |                                            |
                |          |                    +-\---------\------+                                     |
                |          |    -----------------                  -----------------                     |
                |          |    |               |   Snake Control  |               |                     |
                |          |    |        /-------                  |               |                     |
                |          |    |        |      +--------/---------+               |                     |
                |          |    |        |               |                         |                     |
                |          |    |        |               |                         |                     |
                |          |    |        |               ------------------/       |                     |
                |          |    |        |               |                 |       |                     |
                |        +-\----\--------\-----+         |            +----\-------\--------+            |
                |        |                     |         |            |                     |            |
                |        |     VGA Interface   |         |            |   Target Generator  |            |
                |        |                     |         |            |                     |            |
                |        +-/-------/--/--------+         |            +---------------------+            |
                |          |       |  |                  |                                               |
                |          |       |  |                  |                                               |
                |          |       |  |           +------\---------+                                     |
                |          |       |  |           |                |                                     |
                |          |       |  |           |  Score Counter |                                     |
                |          |       |  |           |                |                                     |
                |          |       |  |           |                |                                     |
                |          |       |  |           +---/-------/----+                                     |
                |          |       |  |               |       |                                          |
                |          |       |  |               |       |                                          |
                |          |       |  |               |       |                                          |
                |          |       |  |               |       |                                          |
                |          |       |  |    +----------\-------\------------+                             |
                |          |       |  |    |                               |                             |
                |          |       |  |    |          Seg_7 Display        |                             |
                |          |       |  |    |                               |                             |
                |          |       |  |    |                               |                             |
                |          |       |  |    +-----/--------------------/----+                             |
                |          |       |  |          |                    |                                  |
                |          |       |  |          |                    |                                  |
                |          |       |  |          |                    |                                  |
                |          |       |  |          |                    |                                  |
                |          |       |  |          |                    |                                  |
                +----------|-------|--|----------|--------------------|----------------------------------+
                           |       |  |          |                    |
                           |       |  |          |                    |
                           \       \  \          \                    \
                       COLOUR_OUT HS  VS        SEG_                 DEC     
                                               SELECT                OUT     
*/ 
//////////////////////////////////////////////////////////////////////////////////


module wrapper_top(
    input         CLK,          // Connect to on-borad clock, to which all modules are synchronous
    input         RESET,        // Connect to the middle push button to reset the game
    input         BTNU,         // Connect to the up push button to make the snake moving upward
    input         BTND,         // Connect to the down push button to make the snake moving downward
    input         BTNL,         // Connect to the left push button to make the snake moving leftward
    input         BTNR,         // Connect to the right push button to make the snake moving rightward    
    output        HS,           // Connect to Horizontal Sync
    output        VS,           // Connect to Vertical Sync
    output [3:0]  SEG_SELECT,   // Connect to the anodes of the 7-segment display
    output [7:0]  DEC_OUT,      // Connect to cathodes of the eight segments
    output [11:0] COLOUR_OUT    // Connect to VGA colours
    );
    
    // Definition for intermediate wires
    wire        REACHED_TRGT;   // Connect output of Snake Control Module to inputs of Target Generator and Score Counter
    wire        SCORE_REACHED;  // Connect output of Score Counter to Master State Machine Module
    wire [1:0]  MSM_STATE;      // Connect output of Master State Machine Module to inputs of Snake Control Module and VGA Interface
    wire [1:0]  NVGT_STATE;     // Connect output of Navigation State Machine Module to input of Snake Control Module
    wire [4:0]  DIGIT_0;        // Connect output of Score Counter to input of 7-segment Interface
    wire [4:0]  DIGIT_1;        // Connect output of Score Counter to input of 7-segment Interface
    wire [4:0]  DIGIT_2;        // Connect output of Score Counter to input of 7-segment Interface
    wire [4:0]  DIGIT_3;        // Connect output of Score Counter to input of 7-segment Interface
    wire [6:0]  TRGT_Y;         // Connect output of Target Generator to input of Snake Control Module
    wire [7:0]  TRGT_X;         // Connect output of Target Generator to input of Snake Control Module
    wire [8:0]  PIXEL_Y;        // Connect output of VGA Interface to input of Snake Control Module
    wire [9:0]  PIXEL_X;        // Connect output of VGA Interface to input of Snake Control Module
    wire [11:0] COLOUR;         // Connect output of Snake Control Module to input of VGA Interface
    
    // Instantiation for the Master State Machine
    // This module determines the game modes, including idle mode, playing mode, and win mode.
    master_state_machine Master_State_Machine (
    .CLK           (CLK),
    .RESET         (RESET),
    .BTNL          (BTNL),
    .BTNR          (BTNR),
    .BTNU          (BTNU),
    .BTND          (BTND),
    .SCORE_REACHED (SCORE_REACHED),
    .MSM_STATE     (MSM_STATE)
    );
                                               
    // Instantiation for the Navigation State Machine
    // This module controls the movement of snake in playing mode
    navigation_state_machine Navigation_State_Machine (
    .CLK           (CLK),
    .RESET         (RESET),
    .BTNU          (BTNU),
    .BTND          (BTND),
    .BTNL          (BTNL),
    .BTNR          (BTNR),
    .NVGT_STATE    (NVGT_STATE)
    );
                                                       
    // Instantiation for the Snake Control
    // This module represents a snake and determines if the target beeing reached
    snake_control Snake_Control (
    .CLK           (CLK),
    .RESET         (RESET),
    .MSM_STATE     (MSM_STATE),
    .NVGT_STATE    (NVGT_STATE),
    .TRGT_Y        (TRGT_Y),
    .TRGT_X        (TRGT_X),
    .PIXEL_Y       (PIXEL_Y),
    .PIXEL_X       (PIXEL_X),
    .REACHED_TRGT  (REACHED_TRGT),
    .COLOUR_OUT    (COLOUR)
    );
                                 
    // Instantiation for the Target Generator
    // This module generates a target randomly by LFSRs
    target_generator Target_Generator (
    .CLK           (CLK),
    .RESET         (RESET),
    .REACHED_TRGT  (REACHED_TRGT),
    .TRGT_Y_OUT    (TRGT_Y),
    .TRGT_X_OUT    (TRGT_X)
    );
                                                                                           
    // Instantiation for the VGA Interface
    // This module colours each pixels on the monitor depending on the input colour value
    vga_display_module VGA_Interface (
    .CLK           (CLK),
    .RESET         (RESET),
    .MSM_STATE_IN  (MSM_STATE),
    .COLOUR_IN     (COLOUR),
    .HS            (HS),
    .VS            (VS),
    .ADDRV_OUT     (PIXEL_Y),
    .ADDRH_OUT     (PIXEL_X),
    .COLOUR_OUT    (COLOUR_OUT)
    );
                                      
    // Instantiation for the Score Counter
    // This module will count the scores that the player has gotten
    score_counter Score_Counter (
    .CLK           (CLK),
    .RESET         (RESET),
    .REACHED_TRGT  (REACHED_TRGT),
    .SCORE_REACHED (SCORE_REACHED),
    .DIGIT_0       (DIGIT_0),
    .DIGIT_1       (DIGIT_1),
    .DIGIT_2       (DIGIT_2),
    .DIGIT_3       (DIGIT_3)
    );
                                 
    // Instantiation for the 7-segment Interface
    // This module displays the score on the 7-segment display
    seg_7_interface Seg_7_Interface (
    .CLK           (CLK),
    .RESET         (RESET),
    .DIGIT_IN_0    (DIGIT_0),
    .DIGIT_IN_1    (DIGIT_1),
    .DIGIT_IN_2    (DIGIT_2),
    .DIGIT_IN_3    (DIGIT_3),
    .SEG_SELECT    (SEG_SELECT),
    .DEC_OUT       (DEC_OUT)
    );
endmodule