`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 15.11.2018 11:27:06
// Design Name: Target Record and Hold
// Module Name: target_record_and_hold
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module can record and hold the address value until the target is reached by the player.
// When the player reaches the old target, a new target will be generated.
// It can also make sure that the new target is within range by subtracting certain correction value when the new target is out of the range.
// Meanwhile, super targets will be generated randomly. And this module will record the addresses for super targets.
//
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.
//
// Revision:
// Revision 1.4.0
// Last edited on: 24 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module target_record_and_hold(
    input        CLK,           // Connect to the on-board clock with the frequency of 100MHz
    input        REACHED_TRGT,  // Connect to the output of Snake Control Module
    input        SUP_TRGT_TRIG, // Connect to the output of Super Target Generator. When this signal is active, a super target will be generated
    input  [6:0] TRGT_Y_IN,     // Connect to the output of the 7-bit LFSR
    input  [7:0] TRGT_X_IN,     // Connect to the output of the 8-bit LFSR
    output       SUP_TRGT,      // Connect to the input of Snake Control Module
    output [6:0] TRGT_Y_OUT,    // Connect to the input of Snake Control Module
    output [7:0] TRGT_X_OUT     // Connect to the input of Snake Control Module
    );
    
    // Definition for intermediate registers
    reg       Super_Target = 0;         // When a super target is generated this signal will be active
    reg [6:0] Target_address_Y = 60;    // The vertical address of target is stored in this register and initialized to 60
    reg [7:0] Target_address_X = 80;    // The horizontal address of target is stored in this register and initialized to 80
    
    // Definition for parameters
    parameter Y_Correction = 8;         // 8 is the difference between the border and the maximum value of the 7-bit LFSR, i.e. 128 - 120
    parameter X_Correction = 96;        // 96 is the difference between the border and the maximum value of the 8-bit LFSR, i.e. 256 - 160 
    
    // Every time the target is reached by the player, a new target will be generated
    always@ (posedge CLK) begin
        if (REACHED_TRGT) begin                               // Once the old target is reached, a new target will be generated
            if (TRGT_X_IN >= 160)                             // Check if the X address for the new target is within pixel range or not
                Target_address_X <= TRGT_X_IN - X_Correction; // If the address is out of the range, correct it by subtracting the correction value
            else
                Target_address_X <= TRGT_X_IN;                // If the address is within the range, record and hold it
                
            if (TRGT_Y_IN >= 120)                             // Check if the Y address for the new target is within pixel range or not
                Target_address_Y <= TRGT_Y_IN - Y_Correction; // If the address is out of the range, correct it by subtracting the correction value
            else
                Target_address_Y <= TRGT_Y_IN;                // If the address is within the range, record and hold it
        end // if
    end // always
    
    // Logic for super target
    always@ (posedge CLK) begin
        if (REACHED_TRGT) begin
            if (SUP_TRGT_TRIG)
                Super_Target = 1;   // When the trigger out of Super Target Generator is active, a super target will be generated
            else
                Super_Target = 0;   // Super targets will not be generated when the trigger out of Super Target Generator is not active
        end // if
    end // always
    
    // Connect the intermediate registers to the module outputs
    assign SUP_TRGT   = Super_Target;
    assign TRGT_X_OUT = Target_address_X;
    assign TRGT_Y_OUT = Target_address_Y;
endmodule
