`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 12.11.2018 11:42:56
// Design Name: Testbench for Pseudo Random Number Generator
// Module Name: prng_tb
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This testbench is used to test the performance of Pseudo Random Number Generator
//
// Dependencies: 
// It depends on Pseudo Random Number Generator for its full functionalities.
// 
// Revision:
// Revision 1.0.1
// Last edited on: 18 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module prng_tb(
    );
    
    // Definition for registers and wires
    reg        CLK;
    reg        RESET;
    wire [7:0] PRNG_OUT;
    
    // Instantiation for PRNG
    pseudo_random_number_generator # (.WIDTH (8)) uut (
    .CLK (CLK),
    .RESET (RESET),
    .PRNG_OUT (PRNG_OUT)
    );
                                                       
   // Initialization
   initial begin    // At the beginning CLK is low, then every 1ns it will inverse its value.
        CLK = 0;
        forever#1 CLK = ~CLK;
   end  // initial
   
   initial begin    // RESET is set low all the time.
        RESET = 1'b0;
   end
endmodule
