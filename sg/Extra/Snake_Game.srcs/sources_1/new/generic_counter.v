`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 24.10.2018 11:20:33
// Design Name: Generic Counter
// Module Name: generic_counter
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// Major code in this module is from previous work in Digital System Lab 3 Module 10.
// A n-bit counter is designed here, with the functionalities of RESET and HOLD. This counter design, with specified parameters, can be applied in other modules.
//
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.
//
// Revision:
// Revision 1.2.3
// Last edited on: 18 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module generic_counter(
    CLK,
    RESET,
    ENABLE,
    TRIG_OUT,
    COUNT
    );
    
    // Definition for parameters
    parameter COUNTER_WIDTH = 4;    // This is the length of the counter
    parameter COUNTER_MAX   = 9;    // This is the maximum value that the counter can count
    
    // Definition for interfaces
    input                        CLK;       // Connect to the on-board clock with the frequency of 100MHz
    input                        RESET;     // Connect to the middle button to reset the state into idle state
    input                        ENABLE;    // When "ENABLE" is active, the counter can work
    output                       TRIG_OUT;  // When the counter counts to the maximum, this output will be active
    output [COUNTER_WIDTH-1 : 0] COUNT;     // This is the count value for the counter
    
    // Definition for registers
    reg [COUNTER_WIDTH-1 : 0] count_value = 0;  // Initial
    reg                       Trigger_out = 0;  // Initial
    
    // Synchornous logic for count_value
    always@ (posedge CLK) begin
        if (RESET == 1)                             // Logic for "RESET" functionality
            count_value <= 0;
        else begin
            if (ENABLE == 1) begin                  // When "ENABLE" is active the counter can work
                if (count_value == COUNTER_MAX)     // When count to the maximum, reset the counter
                    count_value <= 0;
                else
                    count_value <= count_value + 1; // Count up
            end // if
        end // else
    end // always
    
    // Synchronous logic for Trigger_out
    always@ (posedge CLK) begin
        if (RESET)
            Trigger_out <= 0;
        else begin
            if ((ENABLE == 1) && (count_value == COUNTER_MAX))  // When count to the maximum, "TRIG_OUT" will be active
                Trigger_out <= 1;
            else
                Trigger_out <= 0;
        end // else
    end // always
    
    // Connect the intermediate registers to the outputs
    assign COUNT    = count_value;
    assign TRIG_OUT = Trigger_out;
    
endmodule
