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
// When in idle state, the whole screen will be coloured blue, which means the player can start the game.
// When in palying state, the snake will be coloured yellow, the target will be coloured red, and the background will be coloured blue.
// After the player gets ten scores, winning pattern will be displayed.
//
// Dependencies: 
// It depends on Colour Control Logic, VGA Interface, Win State Pattern Display, and Auto Colour Module for its full functionalities.
//
// Revision:
// Revision 1.0.1
// Last edited on: 23 Nov 2018
// Additional Comments:
// Block diagram for the VGA Display Module
/*
                          RESET     CLK      MSM_STATE  COLOUR_IN
                           /        /           /        /   
                           |        |           |        |
                           |        |           |        |
                           |        |           |        |
                +----------|--------|-----------|--------|----------------------------+
                |          |        |           |        |                            |
                |          |        ------------|--------|-----------------/          |
                |          |        |           |        |      RESET      |          |
                |       +--\--------\--+        |        |     +-----------\--+       |
                |       |  R       CLK |        |        |     |  R       CLK |       |
                |       |              |        |        |     |              |       |
                |       |              |        |        |     |              |       |
                |       |              |        |        |     |   Win_State  |       |
                |       |  Auto_colour |        |        |     |              |       |
                |       |              |        |        |     |    Pattern   |       |
                |       |    Module    |        |        |     |              |       |
                |       |              |        |        |     |              |       |
                |       |              |        |        |     |              |       |
                |       |              |        |        |     |              |       |
                |       |              |        |        |     |              |       |
                |       +------/-------+        |        |     +---/-------/--+       |
                |              |       MSM_STATE|    COLOUR_IN     |       |          |
                |              |                |        |         |       |          |
                |              |         +------\--------\---+     |       |          |
                |              |         |                   |     |       |          |
                |              |         |                   |     |       |          |
                |              |         |                   |     |       |          |
                |              |         |                   ------\       |          |
                |              |         |    Colour_logic   | WIN_        |          |
                |              |         |                   | MOVE        |          |
                |              \----------                   |             |          |
                |             AUTO_COLOUR|                   |             |          |
                |                        |                   |             |          |
                |                        |                   |             |          |
                |                        |                   --------------\          |
                |                        |                   | WIN_                   |
                |                        +--/---------/------+COLOUR                  |
                |                           |         |                               |
                |                           |         |                               |
                |                           |         |                               |
                |                     COLOUR|         |ADDRESS                        |
                |                           |         |                               |
                |                           |         |                               |
                |                           |         |                               |
                |      +--------------------\---------\-----------------------+       |
                |      |                                                      |       |
                |      |                   VGA_Interface                      |       |
                |      |                                                      |       |
                |      +--------/----/---------------------/----------/-------+       |
                |               |    |                     |          |               |
                |               |    |                     |          |               |
                |               |    |                     |          |               |
                |               |    |                     |          |               |
                +---------------|----|---------------------|----------|---------------+
                                |    |                     |          |
                                |    |                     |          |
                                \    \                     \          \      
                                HS   VS             COLOUR_OUT    ADDRESS_OUT 
*/                
//////////////////////////////////////////////////////////////////////////////////


module vga_display_module(
    input         CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input         RESET,        // Connect to the middle button to reset the state into idle state
    input  [1:0]  MSM_STATE_IN, // Connect to the output of Master State Machine
    input  [11:0] COLOUR_IN,    // Connect to the output of Snake Control Module
    output        HS,           // Connect to Horizontal Sync
    output        VS,           // Connect to Vertical Sync
    output [8:0]  ADDRV_OUT,    // Connect to the input of Snake Control Module
    output [9:0]  ADDRH_OUT,    // Connect to the input of Snake Control Module
    output [11:0] COLOUR_OUT    // Connect to the VGA colour
    );
    
    // Define intermediate buses
    wire        VERT_TRIG;
    wire [7:0]  WIN_MOVE;
    wire [8:0]  Y;              // Connect the input of Colour Control Logic to the output of VGA Interface
    wire [9:0]  X;              // Connect the input of Colour Control Logic to the output of VGA Interface
    wire [11:0] Colour_Value;   // Connect the input of VGA Interface to the output of Colour Control Logic 
    wire [11:0] WIN_COLOUR;     // Connect the input of Colour Control Logic to the output of Win State Pattern Display
    wire [11:0] AUTO_COLOUR;    // Connect the input of Colour Control Logic to the output of Auto Colour Module
    
    // Connect pixel addresses from VGA to addresses out
    assign ADDRH_OUT = X;
    assign ADDRV_OUT = Y;
    
    // Instantiation for Colour Control Logic
    colour_control_logic Colour_Logic (
    .CLK          (CLK),
    .RESET        (RESET),
    .MSM_STATE_IN (MSM_STATE_IN),
    .WIN_MOVE     (WIN_MOVE),
    .Y            (Y),
    .X            (X),
    .AUTO_COLOUR  (AUTO_COLOUR),
    .COLOUR_IN    (COLOUR_IN),
    .WIN_COLOUR   (WIN_COLOUR),
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
    
    // Instantiation for Win State Pattern Display
    win_state_pattern Win_State_Pattern_Display (
    .CLK          (CLK),
    .RESET        (RESET),
    .VERT_TRIG    (VERT_TRIG),
    .Y            (Y),
    .X            (X),
    .WIN_MOVE     (WIN_MOVE),
    .WIN_COLOUR   (WIN_COLOUR)
    );
    
    // Instantiation for Auto Colour Module
    auto_colour Auto_Colour_Module (
    .CLK          (CLK),
    .VERT_TRIG    (VERT_TRIG),
    .AUTO_COLOUR  (AUTO_COLOUR)
    );
endmodule
