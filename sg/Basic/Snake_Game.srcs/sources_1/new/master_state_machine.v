`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 12.11.2018 09:14:04
// Design Name: Master State Machine Module
// Module Name: master_state_machine
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description:
// This module controls the whole project at the highest level.
// In other words, it determines the project to enter one out of the three modes (idle mode, playing mode, and win mode).
// In idle mode, the whole screen will be coloured bule. By pressing any push buttons, it will enter the playing mode.
// In playing mode, the player can control the snake by four direction buttons. It will stay in the playing mode until the player gets ten marks.
// In win mode, the screen will display the win pattern.
//
// The state machine contains two parts, combinational logic part and sequential logic part.
// In sequential logic part, functionalities of "RESET" and change from current state to next state are realized in an "always@" syntax.
// In combinational logic part, how to change the state is determined using "case" syntax.
// A detailed state table is given below.
//                      State Table
//      State Code                      State Name
//        2'b00                            IDLE
//        2'b01                            PLAY
//        2'b10                            WIN
//
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.
// 
// Revision:
// Revision 1.1.1
// Last edited on: 16 Nov 2018
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module master_state_machine(
    input        CLK,           // Connect to the on-board clock with the frequency of 100MHz
    input        RESET,         // Connect to the middle button to reset the state into idle state
    input        BTNL,          // Connect to the left button. By pressing it to enter the playing mode from idle mode
    input        BTNR,          // Connect to the right button. By pressing it to enter the playing mode from idle mode
    input        BTNU,          // Connect to the up button. By pressing it to enter the playing mode from idle mode
    input        BTND,          // Connect to the down button. By pressing it to enter the playing mode from idle mode
    input        SCORE_REACHED, // Connect to the output of Score Counter. When the score is ten it will be active
    output [1:0] MSM_STATE      // Connect to the inputs of Snake Control Module and VGA Interface
    );
    
    // Define intermediate registers
    reg [1:0] Curr_state = 2'b00;   // Current state is stored in this register
    reg [1:0] Next_state;           // Next state is stored in this register
    
    // Connect the intermediate register to the output
    assign MSM_STATE = Curr_state;
    
    // Sequential logic part
    always@ (posedge CLK) begin
        if (RESET) begin                // Definition for the functionality of "RESET"
            Curr_state <= 2'b00;        // When RESET, the state will be reset to idle state
        end // if
        else begin
            Curr_state <= Next_state;   // When not RESET, the current state will change to the next state at the positive edge of clock signal
        end // else
    end // always
    
    // Combinational logic part
    always@ (posedge CLK) begin
        case (Curr_state)
            2'b00: begin                                // Idle state
                if (BTNU | BTND | BTNL | BTNR) begin    // When in idle state, pressing any buttons will change the state to playing state
                    Next_state <= 2'b01;
                end // if
                else begin                              // When no buttons are pressed, stay in idle state
                    Next_state <= 2'b00;
                end // else
            end
            
            2'b01: begin                                // Playing state
                if (SCORE_REACHED) begin                // When the score that the player gets is ten, the state will change to win state
                    Next_state <= 2'b10;
                end // if
                else begin                              // Before the player gets ten score, stay in playing state
                    Next_state <= 2'b01;
                end // else
            end
            
            2'b10: begin                                // Win state
                Next_state <= 2'b10;                    // Always stay in win state unless the middle button is pressed
            end
            
            default:
                Next_state <= 2'b00;                    // In default case, stay in idle state
        endcase
    end // always      
endmodule
