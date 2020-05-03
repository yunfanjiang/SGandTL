`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 18.11.2018 15:24:57
// Design Name: 23-bit 4-to-1 multiplexer
// Module Name: bit23_4to1_mux
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// A 23-bit 4-to-1 multiplexer is developed in this module, which can be applied in Speed Selection Module and Mode Selection Module. 
//
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.
// 
// Revision:
// Revision 1.0.0
// Last edited on: 24 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bit23_4to1_mux(
    input  [1:0]  SEL_SIGNAL, // Select signal to select input to be delivered to the output
    input  [22:0] MUX_IN_0,   // Input signal
    input  [22:0] MUX_IN_1,   // Input signal
    input  [22:0] MUX_IN_2,   // Input signal
    input  [22:0] MUX_IN_3,   // Input signal
    output [22:0] MUX_OUT     // Output signal
    );
    
    // Definition for the intermediate register
    reg [22:0] Mux_Out;
    
    // Logic to select the input to be delivered to the output
    always@ (SEL_SIGNAL | MUX_IN_0 | MUX_IN_1 | MUX_IN_2 | MUX_IN_3) begin
        case (SEL_SIGNAL)   // A "case" statement is used to select the input based on the select signal
            2'b00: Mux_Out <= MUX_IN_0;
            2'b01: Mux_Out <= MUX_IN_1;
            2'b10: Mux_Out <= MUX_IN_2;
            2'b11: Mux_Out <= MUX_IN_3;
            
            default:
                Mux_Out <= 0;
        endcase
    end // always
    
    //Connect the intermediate register to the module output
    assign MUX_OUT = Mux_Out;
endmodule
