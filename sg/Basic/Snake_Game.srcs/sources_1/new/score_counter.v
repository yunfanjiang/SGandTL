`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 16.11.2018 08:19:55
// Design Name: Score Counter
// Module Name: score_counter
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module will record the scores that the player gets.
// It will extract each digits of the score number and output them to display.
// When the player gets enough scores to win, it will output a signal to indicate that the player wins.
// It contains combinational part and sequential part. While combinational part is used to extract the digits, sequential part is used to record the score.
// 
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.
//
// Revision:
// Revision 1.5.2
// Last edited on: 18 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module score_counter(
    input        CLK,           // Connect to the on-board clock with the frequency of 100MHz
    input        RESET,         // Connect to the middle button to reset the state into idle state
    input        REACHED_TRGT,  // Connect to the output of Snake Control Module
    output       SCORE_REACHED, // Connect to the input of Master State Machine
    output [4:0] DIGIT_0,       // Connect to the input of Seg-7 Interface
    output [4:0] DIGIT_1,       // Connect to the input of Seg-7 Interface
    output [4:0] DIGIT_2,       // Connect to the input of Seg-7 Interface
    output [4:0] DIGIT_3        // Connect to the input of Seg-7 Interface
    );
    
    // Definition for intermediate registers and wires
    reg         Score_Reached;      // When player gets enough score to win, this wll be active
    reg  [13:0] count_value;        // Record two times the score
    reg  [4:0]  digit_0;            // The LSB of the score
    reg  [4:0]  digit_1;            // The second digit of the score
    reg  [4:0]  digit_2;            // The third digit of the score
    reg  [4:0]  digit_3;            // THe MSB of the score
    wire [13:0] real_count_value;   // The real score that the player gets
    
    // Definition for parameter
    parameter score_to_win = 10;    // Player will win after he or she gets this marks
    
    // Sequential logic to record the scores
    always@ (posedge CLK) begin
        if (RESET)                              // Functionality to reset the score
            count_value <= 0;
        else begin
            if (REACHED_TRGT)                   // Once the player reaches the target, one mark will be added
                count_value <= count_value + 1;
        end //else
    end // always
    
    // Determine the player wins or not
    always@ (posedge CLK) begin
        if (real_count_value >= score_to_win)
            Score_Reached <= 1;
        else
            Score_Reached <= 0;
    end
    
    // Since when the player gets one mark the counter will add two, divide the count value by two then extract each digits
    assign real_count_value = count_value / 2;
    
    // Extract and output each digits
    always@ (posedge CLK) begin
        digit_0 <= real_count_value % 10;           // Extract the LSB of the score
        digit_1 <= (real_count_value / 10) % 10;    // Extract the second digit
        digit_2 <= (real_count_value / 100) % 10;   // Extract the third digit
        digit_3 <= real_count_value / 1000;         // Extract the MSB of the score
    end // always
    
    // Connect the intermediate registers to the outputs
    assign DIGIT_0 = digit_0;
    assign DIGIT_1 = digit_1;
    assign DIGIT_2 = digit_2;
    assign DIGIT_3 = digit_3;
    assign SCORE_REACHED = Score_Reached;
    
endmodule
