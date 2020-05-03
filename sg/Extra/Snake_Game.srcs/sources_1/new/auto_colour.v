`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 21.11.2018 15:02:30
// Design Name: Auto Colour Module
// Module Name: auto_colour
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module will output automatically-changed colour values with two different speeds, the fastly-changed one and slowly-changed one.
// This module can be applied to colour the patterns whose colours are required to change automatically.
// Generic counters are used to realize these functionalites.
// Major code in this module is from previous work in Digital Systems Lab 3 Module 10.
// 
// Dependencies: 
// It depends on generic counter for its full functionalites.
// 
// Revision:
// Revision 1.3.4
// Last edited on: 24 Nov 2018
// Additional Comments:
// Block diagram for Auto Colour Module
/*
             VERT_TRIG    CLK 
                /          /  
                |          |                                                                     
            +---|----------|------------------------------------------------------------------------+
            |   |          |-----------------------------/--------------------------/               |
            |   |          |                             |                          |               |
            |   |   +------\-----+                +------\-----+             +------\-----+         |
            |   |   |     CLK    |                |     CLK    |             |     CLK    |         |
            |   \---- EN         |                | EN         |      -------- EN         |         |
            |       |            |                |            |      |      |            |         |
            |       |            |                |            |      |      |            |         |
            |       |            |                |            |Trig  |      |    Slow_   |         |
            |       | Auto_colour|                |    1-Hz    -------\      | auto_colour|         |
            |       |   Counter  |                |   Counter  |             |   Counter  |         |
            |       |            |                |            |             |            |         |
            |       |            |                |            |             |            |         |
            |       |            |                |            |             |            |         |
            |      1| R          |               1| R          |            1| R          |         |
            |       |            |                |            |             |            |         |
            |       +-----/------+                +------------+             +------/-----+         |
            |             |                                                         |               |
            |             |                                                         |               |
            |             |                                                         |               |
            +-------------|---------------------------------------------------------|---------------+
                          |                                                         |
                          |                                                         |
                          \                                                         \
                      AUTO_COLOUR                                               SLOW_AUTO_COLOUR
*/
//////////////////////////////////////////////////////////////////////////////////


module auto_colour(
    input         CLK,              // Connect to the on-board clock with the frequency of 100MHz
    input         VERT_TRIG,        // Connect to the trigger-out signal of vertical counter in the VGA interface
    output [11:0] AUTO_COLOUR,      // Connect to the input of Snake Control Module, through which the automatically-changed colour value will be output
    output [11:0] SLOW_AUTO_COLOUR  // Connect to the input of Win Pattern Display Module, through which the automatically-changed colour value will be output
    );

    // Definition for the intermediate wires
    wire Hz1Trigger;                // Connect the output of the 1Hz counter to the input of slow auto colour counter
    wire [7:0] Auto_colour;         // Connect the output of the auto colour counter to the module output
    wire [7:0] Slow_auto_colour;    // Connect the output of the slow auto colour counter to the module output
    
    // Instantiation for the auto colour counter
    generic_counter # (.COUNTER_WIDTH (8), .COUNTER_MAX   (199)) Auto_colour_counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (VERT_TRIG),
    .TRIG_OUT (),   // Pin not used
    .COUNT    (Auto_colour)
    );
    
    // Instantiation for the 1 Hz counter
    generic_counter # (.COUNTER_WIDTH (27), .COUNTER_MAX   (99999999)) One_Hz_counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (1'b1),
    .TRIG_OUT (Hz1Trigger),   // Pin not used
    .COUNT    ()
    );

    // Instantiation for the slow auto colour counter
    generic_counter # (.COUNTER_WIDTH (8), .COUNTER_MAX   (199)) Slow_auto_colour_counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (Hz1Trigger),
    .TRIG_OUT (),   // Pin not used
    .COUNT    (Slow_auto_colour)
    );

    // Connect the intermediate wires to the module outputs
    assign AUTO_COLOUR = Auto_colour * 20;              // Times the value by 20 to reach a 12-bit colour value
    assign SLOW_AUTO_COLOUR = Slow_auto_colour * 20;    // Times the value by 20 to reach a 12-bit colour value
endmodule