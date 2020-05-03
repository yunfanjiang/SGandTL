`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 12.11.2018 10:43:30
// Design Name: VGA Display Module
// Module Name: vga_display_module
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module is used to display different patterns according to the state of master state machine.
// When in idle state, the opening scene will be displayed.
// When in palying state, the snake will be coloured yellow, the target will be coloured red, and the background will be coloured blue.
// When in win state, it will display winning scene.
// When in fail state, it will display failing pattern.
//
// Dependencies: 
// It depends on Colour Control Logic, VGA Interface, Idle Pattern Display, Win Pattern Display, and Fail Pattern Display for its full functionalities.
//
// Revision:
// Revision 1.1.0
// Last edited on: 24 Nov 2018
// Additional Comments:
// Block diagram for the VGA Display Module
/*
                  RESET  CLK            COLOUR_IN                  MSM_STATE  AUTO_COLOUR
                    /     /                 /                           /       /
                    |     |                 |                           |       |
                    |     |                 |                           |       |                                    
                +---\-----\-----------------|---------------------------|-------|------------------------------+     
                |                           |                           |       |                              |     
                |                           |                           |       |                              |     
                |                           |                           |       |                              |     
                |                           |       +--------------+    |       |                              |     
                |                           |       |  R       CLK |    |       |                              |     
                |                           |       |              |    |       |                              |     
                |                           |       |              |    |       |                              |     
                |                           |       |  Idle_State  |    |       |                              |     
                |                           |       |              |    |       |                              |     
                |                           |       |    Pattern   |    |       |                              |     
                |                           |       |              |    |       |                              |     
                |                           |       |              |    |       |                              |     
                |                           |       |              |    |       |                              |     
                |                           |       |              |    |       |                              |     
                |                           |       |              |    |       |                              |     
                |                           |       +--/-------/---+    |       |                              |     
                |          +--------------+ |          |       |        |       |    +--------------+          |     
                |          |  R       CLK | |          |       |        |       |    |  R       CLK |          |     
                |          |              | |          |       |        |       |    |              |          |     
                |          |              | |          |       |        |       |    |              |          |     
                |          |   Win_State  | |     Idle_|       |Idle_   |       |    |  Fail_State  |          |     
                |          |              | |      MOVE|       |COLOUR  |       |    |              |          |     
                |          |    Pattern   | |       +--\-------\--------\---+   |    |    Pattern   |          |     
                |          |              | |       |                       ----\    |              |          |     
                |          |              | \--------                       |        |              |          |     
                |          |              |         |                       |        |              |          |     
                |          |              |         |                       |        |              |          |     
                |          |              |         |                       |        |              |          |     
                |          +--/------/----+     WIN_|      Colour_logic     |Fail_   +---/------/---+          |     
                |             |      |          MOVE|                       |MOVE        |      |              |     
                |             |      \---------------                       -------------\      |              |     
                |             |                     |                       |                   |              |     
                |             |                     |                       |                   |              |     
                |             \----------------------                       --------------------\              |     
                |                               WIN_+----/------------/-----+  Fail_                           |     
                |                              COLOUR    |            |       COLOUR                           |     
                |                                        |            |                                        |     
                |                                        |            |                                        |     
                |                                  COLOUR|            |ADDRESS                                 |     
                |                                        |            |                                        |     
                |                                        |            |                                        |     
                |                        +---------------\------------\----------------+                       |     
                |                        |                                             |                       |     
                |                        |                                             |                       |     
                |              /----------                                             |                       |     
                |              |         |                VGA_Interface                |                       |     
                |              |         |                                             |                       |     
                |              |         |                                             |                       |     
                |              |         +------/---/-------------------/-------/------+                       |     
                |              |                |   |                   |       |                              |     
                |              |                |   |                   |       |                              |     
                |              |                |   |                   |       |                              |     
                |              |                |   |                   |       |                              |     
                |              |                |   |                   |       |                              |     
                |              |                |   |                   |       |                              |     
                +--------------|----------------|---|-------------------|-------|------------------------------+     
                               |                |   |                   |       |                                    
                               |                |   |                   |       |                                    
                               |                |   |                   |       |                                    
                               \                \   \                   \       \                                    
                           VERT_TRIG           HS   VS             COLOUR_OUT    ADDRESS_OUT 
*/
//////////////////////////////////////////////////////////////////////////////////


module vga_display_module(
    input         CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input         RESET,        // Connect to the middle button to reset the state into idle state
    input  [1:0]  MSM_STATE_IN, // Connect to the output of Master State Machine
    input  [11:0] AUTO_COLOUR,  // Connect to the output of Auto Colour Module
    input  [11:0] COLOUR_IN,    // Connect to the output of Snake Control Module
    output        HS,           // Connect to Horizontal Sync
    output        VS,           // Connect to Vertical Sync
    output        VERT_TRIG,    // Connect to the input of Auto Colour Module
    output [8:0]  ADDRV_OUT,    // Connect to the input of Snake Control Module
    output [9:0]  ADDRH_OUT,    // Connect to the input of Snake Control Module
    output [11:0] COLOUR_OUT    // Connect to the VGA colour
    );
    
    // Define intermediate buses
    wire        VERT_TRIG;      // Connect the inputs of Idle Pattern Display, Win Pattern Display, and Fail Pattern Display to the output of VGA interface
    wire [6:0]  FAIL_MOVE;      // Connect the input of Colour Control Logic to the output of Fail Pattern Display Module
    wire [7:0]  WIN_MOVE;       // Connect the input of Colour Control Logic to the output of Win Pattern Display Module
    wire [8:0]  IDLE_MOVE;      // Connect the input of Colour Control Logic to the output of Idle Pattern Display Module   
    wire [8:0]  Y;              // Connect the input of Colour Control Logic to the output of VGA Interface
    wire [9:0]  X;              // Connect the input of Colour Control Logic to the output of VGA Interface
    wire [11:0] Colour_Value;   // Connect the input of VGA Interface to the output of Colour Control Logic 
    wire [11:0] IDLE_COLOUR;    // Connect the input of Colour Control Logic to the output of Idle Pattern Display Module
    wire [11:0] WIN_COLOUR;     // Connect the input of Colour Control Logic to the output of Win Pattern Display Module
    wire [11:0] FAIL_COLOUR;    // Connect the input of Colour Control Logic to the output of Fail Pattern Display Module
    
    // Connect pixel addresses from VGA to addresses out
    assign ADDRH_OUT = X;
    assign ADDRV_OUT = Y;
    
    // Connect the trigger-out signal of vertical syn counter to the module output
    assign VERT_TRIG = VERT_TRIG;
    
    // Instantiation for Colour Control Logic Module
    colour_control_logic Colour_Logic (
    .CLK          (CLK),
    .RESET        (RESET),
    .MSM_STATE_IN (MSM_STATE_IN),
    .FAIL_MOVE    (FAIL_MOVE),
    .IDLE_MOVE    (IDLE_MOVE),
    .WIN_MOVE     (WIN_MOVE),
    .Y            (Y),
    .X            (X),
    .COLOUR_IN    (COLOUR_IN),
    .AUTO_COLOUR  (AUTO_COLOUR),
    .IDLE_COLOUR  (IDLE_COLOUR),
    .WIN_COLOUR   (WIN_COLOUR),
    .FAIL_COLOUR  (FAIL_COLOUR),
    .COLOUR_OUT   (Colour_Value)
    );
                                       
    // Instantiation for VGA Interface
    vga_interface VGA_Interface (
    .CLK          (CLK),
    .COLOUR_IN    (Colour_Value),
    .VERT_TRIG    (VERT_TRIG),
    .HS           (HS),
    .VS           (VS),
    .ADDRV        (Y),
    .ADDRH        (X),
    .COLOUR_OUT   (COLOUR_OUT)
    );
    
    // Instantiation for the Idle Pattern Display Module
    idle_state_pattern Idle_Pattern_Display (
    .CLK          (CLK),
    .VERT_TRIG    (VERT_TRIG),
    .Y            (Y),
    .X            (X),
    .IDLE_MOVE    (IDLE_MOVE),
    .IDLE_COLOUR  (IDLE_COLOUR)
    );
    
    // Instantiation for the Win Pattern Display Module
    win_state_pattern Win_Pattern_Display (
    .CLK          (CLK),
    .RESET        (RESET),
    .VERT_TRIG    (VERT_TRIG),
    .Y            (Y),
    .X            (X),
    .WIN_MOVE     (WIN_MOVE),
    .WIN_COLOUR   (WIN_COLOUR)
    );
    
    // Instantiation for the Fail Pattern Display Module
    fail_state_pattern Fail_Pattern_Display (
    .CLK          (CLK),
    .VERT_TRIG    (VERT_TRIG),
    .Y            (Y),
    .X            (X),
    .FAIL_MOVE    (FAIL_MOVE),
    .FAIL_COLOUR  (FAIL_COLOUR)
    );
endmodule
