`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 22.11.2018 15:48:41
// Design Name: Auto Colour Module
// Module Name: auto_colour
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// Major code in this module is from previous work in Digital Systems Lab 3 Module 10.
// This module will output colour values changed every 1s by generic counters.
// It can be applied to colour patterns whose colours are required to change automatically.
// 
// Dependencies: 
// It depends on generic counter for its full functionalites. 
//
// Revision:
// Revision 1.0.1
// Last edited on: 23 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module auto_colour(
    input         CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input         VERT_TRIG,    // Connect to the trigger out of the vertical syn counter in the VGA interface
    output [11:0] AUTO_COLOUR   // Connect to the output of Auto Colour Module to change the colour automatically
    );
    
    // Definition for intermediate wires
    wire Hz1Trigger;        // Connect the output of the 1-hz counter to the input of auto colour counter
    wire [7:0] Auto_colour; // Connect the output of auto colour counter to the module output
    
    // Instantiation for the 1-hz counter
    generic_counter # (.COUNTER_WIDTH (27), .COUNTER_MAX   (99999999)) One_Hz_counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (1'b1),
    .TRIG_OUT (Hz1Trigger),
    .COUNT    ()    // Pin not used
    );

    // Instantiation for the auto colour counter
    generic_counter # (.COUNTER_WIDTH (8), .COUNTER_MAX   (199)) Auto_colour_counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (Hz1Trigger),
    .TRIG_OUT (),   // Pin not used
    .COUNT    (Auto_colour)
    );

    // Connect the intermediate wire to the module output
    assign AUTO_COLOUR = Auto_colour * 20;  // Since the count value is 8-bit, times it by 20 to reach 12-bit long then output it
endmodule