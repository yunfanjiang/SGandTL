`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 15.11.2018 15:22:23
// Design Name: Snake Control Module
// Module Name: snake_control
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module is the key module of this design.
// It defines the snake and its movement. It also represents the snake and the target.
// Five parts are included in this module.
// The first part uses a "generate" statement to define the move of the snake.
// The second part controls the moving direction of the snake according to the Navigation State Machine by a "case" statement.
// The third part checks that whether the snake reaches the target.
// The fourth part outputs the colour value, which will colour the snake yellow, colour the normal target red, colour the super target colourful, and colour the background blue.
// The fifth part uses iteration to check whether the snake hits itself or not. When it hits itself, it will output an active signal.
// Partial code is from the instruction of the Digital Systems Lab 3 Module 14. 
// 
// Dependencies: 
// This is a basic module. It does not depend on any sub-modules to realize its functionalities.
//
// Revision:
// Revision 1.7.7
// Last edited on: 24 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module snake_control(
    input             CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input             RESET,        // Connect to the middle button to reset the state into idle state
    input             SUP_TRGT,     // Connect to the output of Target Generator. When this signal is active, a super target will be generated
    input      [1:0]  MSM_STATE,    // Connect to the output of the Master State Machine
    input      [1:0]  NVGT_STATE,   // Connect to the output of the Navigation State Machine
    input      [6:0]  TRGT_Y,       // Connect to the output of Target Generator
    input      [7:0]  TRGT_X,       // Connect to the output of Target Generator
    input      [8:0]  PIXEL_Y,      // Connect to the output of VGA Interface
    input      [9:0]  PIXEL_X,      // Connect to the output of VGA Interface
    input      [11:0] AUTO_COLOUR,  // Connect to the output of Auto Colour Module, through which a automatically-changed colour value will be input
    input      [13:0] CURR_SCORE,   // Connect to the output of Score Counter, which is the current scores that the player gets
    input      [22:0] SPEED_COUNT,  // Connect to the output of Speed Selection Module, through which four moving speeds can be choosen by the slide switches
    output reg        HIT_FAIL,     // Connect to the input of Master State Machine. When the snake hits itself, this signal will be active and the game will fail
    output reg        WALL_FAIL,    // Connect to the input of Master State Machine. When the snake hits the walls, this signal will be active and the game will fail
    output reg        REACHED_TRGT, // Connect to the inputs of Target Generator and Score Counter. When the snake reaches a target, this signal will be active and a new target will be generated
    output reg [11:0] COLOUR_OUT    // Connect to the input of VGA Interface
    );
    
    // Definition for parameters
    parameter MaxX = 159;       // This is the maximum horizontal position that the snake can get
    parameter MaxY = 119;       // This is the maximum vertical position that the snake can get
    parameter MaxLength = 40;   // The max length that the snake can grow
    parameter InitLength = 3;   // The initial length of the snake
    
    // Definition for intermediate wires 
    wire [6:0] pixel_y;         // The vertical pixel address after reducing resolution
    wire [7:0] pixel_x;         // The horizontal pixel address after reducing resolution
    wire [5:0] CurrLength;      // The current length of the snake
    
    // Definition for intermediate registers
    reg       SUP_TRGT_REACHED = 0; // When the snake reaches a super target, this signal will be active
    reg [5:0] Hit_Check_Iteration;  // Iteration factor to check whether the snake hits itself or not
    
    // Reduce the resolution by shifting rightward two bits
    assign pixel_y = PIXEL_Y [8:2];
    assign pixel_x = PIXEL_X [9:2];
    
    // Every time the snake reaches one target, it will grow longer for two units
    assign CurrLength = InitLength + CURR_SCORE * 2; 
    
    // Definition for registers to store the position of snake
    reg [7:0] SnakeState_X [0:MaxLength - 1];
    reg [6:0] SnakeState_Y [0:MaxLength - 1];
    
    // The code within "generate" statement is from the instruction of Digital Systems Lab 3 Module 14
    // Changing the position of the snake registers
    // Shift the SnakeState X and Y
    genvar PixNo;
    generate
        for (PixNo = 0; PixNo < MaxLength - 1; PixNo = PixNo + 1)
            begin: PixShift
                always@ (posedge CLK) begin
                    if (RESET) begin
                        SnakeState_X [PixNo + 1] <= 80;
                        SnakeState_Y [PixNo + 1] <= 100;
                    end // else
                    else if (SPEED_COUNT == 0) begin
                        SnakeState_X [PixNo + 1] <= SnakeState_X [PixNo];
                        SnakeState_Y [PixNo + 1] <= SnakeState_Y [PixNo];
                    end // else if
                end // always
            end // for
    endgenerate
    
    // Navigate the movement of snake
    always@ (posedge CLK) begin
        if (RESET) begin    // Set the initial position of the snake
            SnakeState_X [PixNo + 1] <= 80;
            SnakeState_Y [PixNo + 1] <= 100;
        end // if
        else if (SPEED_COUNT == 0) begin    // Use Speed Counter to slow down the movement of the snake
            case (NVGT_STATE)
                2'b00: begin    // Up
                    if (SnakeState_Y [0] == 0) begin
                        if ((CURR_SCORE >= 1) && (SUP_TRGT_REACHED == 0))   // Snake will die if it hits the top wall after reaching the first target
                            WALL_FAIL <=1;
                        else
                            SnakeState_Y [0] <= MaxY;   // After reaching a super target or before reaching the first target, the snake will not die even if it hits the walls
                    end // if
                    else begin
                        WALL_FAIL <= 0;
                        SnakeState_Y [0] <= SnakeState_Y [0] - 1;
                    end // else
                end
                
                2'b01: begin    // Down
                    if (SnakeState_Y [0] == MaxY) begin
                        if ((CURR_SCORE >= 1) && (SUP_TRGT_REACHED == 0))   // Snake will die if it hits the bottom wall after reaching the fitst target
                            WALL_FAIL <= 1;
                        else
                        SnakeState_Y [0] <=0;   // After reaching a super target or before reaching the first target, the snake will not die even if it hits the walls
                    end // if
                    else begin
                        WALL_FAIL <= 0;
                        SnakeState_Y [0] <= SnakeState_Y [0] + 1;
                    end // else
                end
                
                2'b10: begin    // Left
                    if (SnakeState_X [0] == 0) begin
                        if ((CURR_SCORE >= 1) && (SUP_TRGT_REACHED == 0))   // Snake will die if it hits the left wall after reaching the first target
                            WALL_FAIL <= 1;
                        else
                        SnakeState_X [0] <= MaxX;   // After reaching a super target or before reaching the first target, the snake will not die even if it hits the walls
                    end // if
                    else begin
                        WALL_FAIL <= 0;
                        SnakeState_X [0] <= SnakeState_X [0] - 1;
                    end // else
                end
                
                2'b11: begin    // Right
                    if (SnakeState_X [0] == MaxX) begin
                        if ((CURR_SCORE >= 1) && (SUP_TRGT_REACHED == 0))        // Snake will die if it hits the right wall after reaching the first target
                            WALL_FAIL <= 1;
                        else
                        SnakeState_X [0] <= 0;  // After reaching a super target or before reaching the first target, the snake will not die even if it hits the walls
                    end //if
                    else begin
                        WALL_FAIL <= 0;
                        SnakeState_X [0] <= SnakeState_X [0] + 1;
                    end // else
                end                
            endcase
        end // else if
    end // always
    
    // Check if the snake reaches the target
    always@ (posedge CLK) begin
        if (RESET) begin    // Reset the reaching signals
            SUP_TRGT_REACHED <= 0;
            REACHED_TRGT <= 0;
        end // if
        else if ((SnakeState_X [0] == TRGT_X) && (SnakeState_Y [0] == TRGT_Y)) begin   // When the snake reaches the target, activate "REACHED_TRGT"
            if (SUP_TRGT) begin
                SUP_TRGT_REACHED <= 1;  // This signal will be active when the snake reaches a super target
                REACHED_TRGT <= 1;
            end // if
            else begin
                SUP_TRGT_REACHED <= 0;  // When the snake reaches a normal target, this signal will not be active
                REACHED_TRGT <= 1;      // When the snake reaches a normal target, this signal will be active
            end // else
        end // else if
        else 
            REACHED_TRGT <= 0;          // When the snake does not reach a normal target or super target, this signal will not be active
    end // always
    
    // This part will colour the snake yellow, colour the normal target red, colour the super target colourful, and colour the background blue
    always@ (posedge CLK) begin
    // Check if the pixel belongs to the snake
        if (
            ((pixel_x == SnakeState_X [0]) && (pixel_y == SnakeState_Y [0]) && (CurrLength >= InitLength)) | ((pixel_x == SnakeState_X [1]) && (pixel_y == SnakeState_Y [1]) && (CurrLength >= InitLength)) |
            ((pixel_x == SnakeState_X [1]) && (pixel_y == SnakeState_Y [1]) && (CurrLength >= InitLength)) | ((pixel_x == SnakeState_X [2]) && (pixel_y == SnakeState_Y [2]) && (CurrLength >= InitLength)) |
            ((pixel_x == SnakeState_X [3]) && (pixel_y == SnakeState_Y [3]) && (CurrLength >= 5)) | ((pixel_x == SnakeState_X [4]) && (pixel_y == SnakeState_Y [4]) && (CurrLength >= 5)) |
            ((pixel_x == SnakeState_X [5]) && (pixel_y == SnakeState_Y [5]) && (CurrLength >= 7)) | ((pixel_x == SnakeState_X [6]) && (pixel_y == SnakeState_Y [6]) && (CurrLength >= 7)) |
            ((pixel_x == SnakeState_X [7]) && (pixel_y == SnakeState_Y [7]) && (CurrLength >= 9)) | ((pixel_x == SnakeState_X [8]) && (pixel_y == SnakeState_Y [8]) && (CurrLength >= 9)) |
            ((pixel_x == SnakeState_X [9]) && (pixel_y == SnakeState_Y [9]) && (CurrLength >= 11)) | ((pixel_x == SnakeState_X [10]) && (pixel_y == SnakeState_Y [10]) && (CurrLength >= 11)) |
            ((pixel_x == SnakeState_X [11]) && (pixel_y == SnakeState_Y [11]) && (CurrLength >= 13)) | ((pixel_x == SnakeState_X [12]) && (pixel_y == SnakeState_Y [12]) && (CurrLength >= 13)) |
            ((pixel_x == SnakeState_X [13]) && (pixel_y == SnakeState_Y [13]) && (CurrLength >= 15)) | ((pixel_x == SnakeState_X [14]) && (pixel_y == SnakeState_Y [14]) && (CurrLength >= 15)) |
            ((pixel_x == SnakeState_X [15]) && (pixel_y == SnakeState_Y [15]) && (CurrLength >= 17)) | ((pixel_x == SnakeState_X [16]) && (pixel_y == SnakeState_Y [16]) && (CurrLength >= 17)) |
            ((pixel_x == SnakeState_X [17]) && (pixel_y == SnakeState_Y [17]) && (CurrLength >= 19)) | ((pixel_x == SnakeState_X [18]) && (pixel_y == SnakeState_Y [18]) && (CurrLength >= 19)) |
            ((pixel_x == SnakeState_X [19]) && (pixel_y == SnakeState_Y [19]) && (CurrLength >= 21)) | ((pixel_x == SnakeState_X [20]) && (pixel_y == SnakeState_Y [20]) && (CurrLength >= 21)) |
            ((pixel_x == SnakeState_X [21]) && (pixel_y == SnakeState_Y [21]) && (CurrLength >= 23)) | ((pixel_x == SnakeState_X [22]) && (pixel_y == SnakeState_Y [22]) && (CurrLength >= 23)) |
            ((pixel_x == SnakeState_X [23]) && (pixel_y == SnakeState_Y [23]) && (CurrLength >= 25)) | ((pixel_x == SnakeState_X [24]) && (pixel_y == SnakeState_Y [24]) && (CurrLength >= 25)) |
            ((pixel_x == SnakeState_X [25]) && (pixel_y == SnakeState_Y [25]) && (CurrLength >= 27)) | ((pixel_x == SnakeState_X [26]) && (pixel_y == SnakeState_Y [26]) && (CurrLength >= 27)) |
            ((pixel_x == SnakeState_X [27]) && (pixel_y == SnakeState_Y [27]) && (CurrLength >= 29)) | ((pixel_x == SnakeState_X [28]) && (pixel_y == SnakeState_Y [28]) && (CurrLength >= 29)) |
            ((pixel_x == SnakeState_X [29]) && (pixel_y == SnakeState_Y [29]) && (CurrLength >= 31)) | ((pixel_x == SnakeState_X [30]) && (pixel_y == SnakeState_Y [30]) && (CurrLength >= 31)) |
            ((pixel_x == SnakeState_X [31]) && (pixel_y == SnakeState_Y [31]) && (CurrLength >= 33)) | ((pixel_x == SnakeState_X [32]) && (pixel_y == SnakeState_Y [32]) && (CurrLength >= 33)) |
            ((pixel_x == SnakeState_X [33]) && (pixel_y == SnakeState_Y [33]) && (CurrLength >= 35)) | ((pixel_x == SnakeState_X [34]) && (pixel_y == SnakeState_Y [34]) && (CurrLength >= 35)) |
            ((pixel_x == SnakeState_X [35]) && (pixel_y == SnakeState_Y [35]) && (CurrLength >= 37)) | ((pixel_x == SnakeState_X [36]) && (pixel_y == SnakeState_Y [36]) && (CurrLength >= 37)) |
            ((pixel_x == SnakeState_X [37]) && (pixel_y == SnakeState_Y [37]) && (CurrLength >= 39)) | ((pixel_x == SnakeState_X [38]) && (pixel_y == SnakeState_Y [38]) && (CurrLength >= 39)) |
            ((pixel_x == SnakeState_X [39]) && (pixel_y == SnakeState_Y [39]) && (CurrLength >= 41))
           ) begin
            if (SUP_TRGT_REACHED)               // After reaching a super target, the snake will be colourful
                COLOUR_OUT <= AUTO_COLOUR;
            else
                COLOUR_OUT <= 12'b000010011101; // When not reaching a super target, colour the snake yellow
        end // if
        else if ((pixel_x == TRGT_X) && (pixel_y == TRGT_Y)) begin  // Check if the pixel belongs to the target
            if (SUP_TRGT)
                COLOUR_OUT <= AUTO_COLOUR;  // Colour the super target colourful
            else
                COLOUR_OUT <= 12'b000000011001; // Colour the normal target red
        end // else if
        else
            COLOUR_OUT <= 12'b111011101100; // Colour the background blue
    end // always
    
    // Check whether the snake hits itself or not by iteration
    always@ (posedge CLK) begin
        if (Hit_Check_Iteration == CurrLength)  // Set the iteration factor to 1 when it reaches the current length
            Hit_Check_Iteration <= 1;
        else
            Hit_Check_Iteration <= Hit_Check_Iteration + 1; // Add one to iteration factor every time
            
        if (RESET)          
            HIT_FAIL <= 0;  // When the middle RESET button is pressed, reset the hitting signal
        else if ((SnakeState_X [0] == SnakeState_X [Hit_Check_Iteration]) && (SnakeState_Y [0] == SnakeState_Y [Hit_Check_Iteration]) && (SUP_TRGT_REACHED == 0))
            HIT_FAIL <= 1;  // If the snake does not reach a super target, this signal will be active when it hits itself
    end // always
endmodule