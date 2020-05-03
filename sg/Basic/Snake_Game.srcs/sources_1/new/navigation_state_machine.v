`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 12.11.2018 09:36:52
// Design Name: Navigation State Machine Module
// Module Name: navigation_state_machine
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description:
// This module controls the movement of the snake in playing mode by four direction buttons.
// By pressing the up button, the snake will go upward. By pressing the down button, the snake will go downward.
// By pressing the left button, the snake will go leftward. By pressing the right button, the snake will go rightward.
// Note that the snake will not turn to the opposite direction.
//
// A state machine, which includes two parts, the combinational logic part and sequential logic part, is used to realize these functionalities.
// In sequential logic part, functionalities of "RESET" and change from current state to next state are realized in an "always@" syntax.
// The combinational logic part, which determines the next state based on current state and button inputs, are constructed by using "case" syntax.
// A detailed state table is given below.
//                      State Table
//      State Code                      State Name
//        2'b00                            UP
//        2'b01                            DOWN
//        2'b10                            LEFT
//        2'b11                            RIGHT
//
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.
//
// Revision:
// Revision 1.2.2
// Last edited on: 16 Nov 2018
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module navigation_state_machine(
    input        CLK,       // Connect to the on-board clock with the frequency of 100MHz
    input        RESET,     // Connect to the middle button to reset the state into idle state 
    input        BTNU,      // Connect to the up button to make the snake moving upward
    input        BTND,      // Connect to the down button to make the snake moving downward
    input        BTNL,      // Connect to the left button to make the snake moving leftward
    input        BTNR,      // Connect to the right button to make the snake moving rightward
    output [1:0] NVGT_STATE // Connect to the input of Snake Control Module
    );
    
    // Definition for intermediate registers
    reg [1:0] Curr_state = 2'b00;   // Store the current state
    reg [1:0] Next_state;           // Store the next state

    // Connect the intermediate register to the output
    assign NVGT_STATE = Curr_state;
    
    // Sequential logic part
    always@ (posedge CLK) begin
        if (RESET) begin                    // Definition for the functionality of "RESET"
            Curr_state <= 2'b00;            // When RESET, the state will be reset to idle state
        end // if
        else begin
            Curr_state <= Next_state;       // When not RESET, the current state will change to the next state at the positive edge of clock signal
        end // else
    end // always

    // Combinational logic part
    always@ (posedge CLK) begin
        case (Curr_state)
            2'b00: begin                    // Moving upward
                if (BTNL) begin             // Moving leftward when pressing left button
                    Next_state <= 2'b10;
                end // if
                else if (BTNR) begin        // Moving rightward when pressing right button
                    Next_state <= 2'b11;
                end // else if
                else begin                  // When no buttons are pressed or the down button is pressed, it will keep moving upward
                    Next_state <= 2'b00;
                end // else
            end
            
            2'b01: begin                    // Moving downward
                if (BTNL) begin             // Moving leftward when pressing left button
                    Next_state <= 2'b10;
                end // if
                else if (BTNR) begin        // Moving rightward when pressing right button
                    Next_state <= 2'b11;
                end // else if
                else begin                  // When no buttons are pressed or the up button is pressed, it will keep moving downward
                    Next_state <= 2'b01;
                end // else
            end

            2'b10: begin                    // Moving leftward
                if (BTNU) begin             // Moving upward when pressing up button
                    Next_state <= 2'b00;
                end // if
                else if (BTND) begin        // Moving downward when pressing down button     
                    Next_state <= 2'b01;
                end // else if
                else begin                  // When no buttons are pressed or the right button is pressed, it will keep moving leftward
                    Next_state <= 2'b10;
                end // else
            end

            2'b11: begin                    // Moving rightward
                if (BTNU) begin             // Moving upward when pressing up button
                    Next_state <= 2'b00;
                end // if
                else if (BTND) begin        // Moving downward when pressing down button
                    Next_state <= 2'b01;
                end // else if
                else begin                  // When no buttons are pressed or the left button is pressed, it will keep moving rightward
                    Next_state <= 2'b11;
                end // else
            end
            
            default:
                Next_state <= 2'b00;        // Moving upward when in default case
        endcase
    end // always
endmodule
