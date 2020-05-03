`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 12.11.2018 11:16:49
// Design Name: D Type Flip Flop
// Module Name: d_type_register
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description:
// Main code in this module is from previous work in Digital System Lab 3 Module 4. 
// A D type flip flop with the functionality of RESET is designed here, which can be used in Pseudo Random Number Generator.
// At the positive edge of the clock signal, the output of the D type flip flop will take the value of the input.
//
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.

// Revision:
// Revision 1.0.1
// Last edited on: 16 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module d_type_register(
    input  CLK,     // Connect to the on-board clock with the frequency of 100MHz
    input  RESET,   // Connect to the middle button to reset the state into idle state
    input  D_IN,    // This is the signal input to the flip flop
    output D_OUT    // This is the signal output of the flip flop
    );
    
    // Definition for the intermediate register
    reg d_out = 0;  // Store the output signal
    
    // Connect the intermediate register to the output
    assign D_OUT = d_out;
    
    // Synchronous logic
    always@ (posedge CLK) begin
        if (RESET) begin        // Logic for the functionality of "RESET"
            d_out <= 0;         // Reset the state of the flip flop to zero
        end // if
        else begin              // When not reset, the state of the flip flop is the input
            d_out <= D_IN;
        end // else
    end // always
endmodule