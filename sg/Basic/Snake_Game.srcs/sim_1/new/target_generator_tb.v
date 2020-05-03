`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 15.11.2018 13:34:54
// Design Name: Testbench for Target Generator
// Module Name: target_generator_tb
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This testbench is designed to test the performance of Target Generator
// 
// Dependencies: 
// It depends on Target Generator for its full functionalities.
//
// Revision:
// Revision 1.0.1
// Last edited on: 18 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module target_generator_tb(
    );
    
    // Definition for wires and registers
    reg        CLK;
    reg        RESET;
    reg        REACHED_TRGT;
    wire [6:0] TRGT_Y_OUT;
    wire [7:0] TRGT_X_OUT;
    
    // Instantiation for Target Generator
    target_generator Target_Generator_uut (
    .CLK (CLK),
    .RESET (RESET),
    .REACHED_TRGT (REACHED_TRGT),
    .TRGT_Y_OUT (TRGT_Y_OUT),
    .TRGT_X_OUT (TRGT_X_OUT)
    );
                                           
    // Initialization
    initial begin               // At the beginning CLK will be set low, then it will inverse its value every 1ns.
        CLK = 0;
        forever#1 CLK = ~CLK;
    end // initial
    
    initial begin               // RESET is set low all the time.
        RESET = 0;
    end // initial
    
    initial begin               // REACHED_TRGT is to simulate that the snake reaches the target.
        REACHED_TRGT = 0;
        #100 REACHED_TRGT = 1;
        #10  REACHED_TRGT = 0;
        #100 REACHED_TRGT = 1;
        #10  REACHED_TRGT = 0;
    end // initial
    
endmodule
