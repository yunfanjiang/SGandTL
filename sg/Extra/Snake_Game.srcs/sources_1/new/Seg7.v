`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 15.10.2018 10:41:41
// Design Name: Seven-segment Decoder
// Module Name: Seg7
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// Major code is from previous work in Digital Systems Lab 3 Module 8.
// The input number will be decoded into corresponding 7-segment value in this module. Hence, each Arabic numbers can be displayed correctly on the 7-segment display. 
//
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.

// Revision:
// Revision 1.0.0
// Last edited on: 18 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Seg7(
    input            DOT_IN,            // Connect to the dot bit
    input      [1:0] SEG_SELECT_IN,     // Connect to the output of the strobe counter
    input      [3:0] BIN_IN,            // Connect to the output of the MUX
    output reg [3:0] SEG_SELECT_OUT,    // Connect to the anodes of the 7-segment display 
    output reg [7:0] HEX_OUT            // Connect to the cathodes of each segment
    );
    
    always@ (SEG_SELECT_IN) begin           // A "case" statement is used to select the digit of 7-segment display
    case (SEG_SELECT_IN)
        2'B00 : SEG_SELECT_OUT <= 4'B1110;  // Select the first digit
        2'B01 : SEG_SELECT_OUT <= 4'B1101;  // Select the second digit
        2'B10 : SEG_SELECT_OUT <= 4'B1011;  // Select the third digit
        2'B11 : SEG_SELECT_OUT <= 4'B0111;  // Select the fourth digit
        default: SEG_SELECT_OUT <= 4'B1111;
    endcase
    end // always
    
    always@ (BIN_IN or DOT_IN) begin            // A "case" statement is used to decode the input number
        case(BIN_IN)
            4'h0 : HEX_OUT [6:0] <= 7'b1000000;
            4'h1 : HEX_OUT [6:0] <= 7'b1111001;
            4'h2 : HEX_OUT [6:0] <= 7'b0100100;
            4'h3 : HEX_OUT [6:0] <= 7'b0110000;

            4'h4 : HEX_OUT [6:0] <= 7'b0011001;
            4'h5 : HEX_OUT [6:0] <= 7'b0010010;
            4'h6 : HEX_OUT [6:0] <= 7'b0000010;
            4'h7 : HEX_OUT [6:0] <= 7'b1111000;

            4'h8 : HEX_OUT [6:0] <= 7'b0000000;
            4'h9 : HEX_OUT [6:0] <= 7'b0011000;
            4'ha : HEX_OUT [6:0] <= 7'b0001000;
            4'hb : HEX_OUT [6:0] <= 7'b0000011;

            4'hc : HEX_OUT [6:0] <= 7'b1000110;
            4'hd : HEX_OUT [6:0] <= 7'b0100001;
            4'he : HEX_OUT [6:0] <= 7'b0000110;
            4'hf : HEX_OUT [6:0] <= 7'b0001110;

            default: HEX_OUT [6:0] <= 7'B1111111;
        endcase
        
        HEX_OUT[7] <= ~DOT_IN;
        end
endmodule