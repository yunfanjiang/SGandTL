`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 14.10.2018 09:46:13
// Design Name: Five-bit Four-to-one Multiplexer
// Module Name: MUX
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// Major code is from previous work in Digital Systems Lab 3 Module 9.
// A 5-bit four-to-one multiplexer is developed here.
// 
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.
//
// Revision:
// Revision 1.0.0
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUX(
    input      [1:0] SIGNAL_SELECT, // Select signal
    input      [4:0] SIGNAL_IN_0,   // Input signal 1
    input      [4:0] SIGNAL_IN_1,   // Input signal 2
    input      [4:0] SIGNAL_IN_2,   // Input signal 3
    input      [4:0] SIGNAL_IN_3,   // Input signal 4
    output reg [4:0] SIGNAL_OUT     // Output signal
    );
    
    // A "case" statement is used to realize the functionalities
    always@ (SIGNAL_SELECT | SIGNAL_IN_0 | SIGNAL_IN_1 | SIGNAL_IN_2 | SIGNAL_IN_3) begin
        case (SIGNAL_SELECT)
            2'b00 : SIGNAL_OUT <= SIGNAL_IN_0;
            2'b01 : SIGNAL_OUT <= SIGNAL_IN_1;
            2'b10 : SIGNAL_OUT <= SIGNAL_IN_2;
            2'b11 : SIGNAL_OUT <= SIGNAL_IN_3;
            
            default: SIGNAL_OUT <= 5'b00000;
        endcase
    end // always
endmodule
