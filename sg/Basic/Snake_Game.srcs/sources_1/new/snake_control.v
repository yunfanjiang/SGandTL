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
// The first part slows down the moving speed of the snake, which is realized by the generic counter.
// The second part uses a "generate" statement to define the move of the snake.
// The third part controls the moving direction of the snake according to the Navigation State Machine by a "case" statement.
// The fourth part outputs the colour value, which will colour the snake yellow, colour the target red, and colour the background blue.
// Partial code is from the instruction of the Digital Systems Lab 3 Module 14. 
// 
// Dependencies: 
// It depends on generic counter for its full functionalities. 
//
// Revision:
// Revision 1.3.7
// Last edited on: 21 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module snake_control(
    input             CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input             RESET,        // Connect to the middle button to reset the state into idle state
    input      [1:0]  MSM_STATE,    // Connect to the output of the Master State Machine
    input      [1:0]  NVGT_STATE,   // Connect to the output of the Navigation State Machine
    input      [6:0]  TRGT_Y,       // Connect to the output of Target Generator
    input      [7:0]  TRGT_X,       // Connect to the output of Target Generator
    input      [8:0]  PIXEL_Y,      // Connect to the output of VGA Interface
    input      [9:0]  PIXEL_X,      // Connect to the output of VGA Interface
    output reg        REACHED_TRGT, // Connect to the inputs of Target Generator and Score Counter
    output reg [11:0] COLOUR_OUT    // Connect to the input of VGA Interface
    );
    
    // Definition for parameters
    parameter MaxX = 159;       // This is the maximum horizontal position that the snake can get
    parameter MaxY = 119;       // This is the maximum vertical position that the snake can get
    parameter SnakeLength = 20; // The length of the snake
    
    // Definition for intermediate wires 
    wire [25:0] Speed_Counter;  // Slow down the move of the snake
    wire [6:0] pixel_y;         // The vertical pixel address after reducing resolution
    wire [7:0] pixel_x;         // The horizontal pixel address after reducing resolution
    
    // Reduce the resolution by shifting rightward two bits
    assign pixel_y = PIXEL_Y [8:2];
    assign pixel_x = PIXEL_X [9:2]; 
    
    // Definition for registers to store the position of snake
    reg [7:0] SnakeState_X [0:SnakeLength - 1];
    reg [6:0] SnakeState_Y [0:SnakeLength - 1];
    
    // Initializa the snake to the initial position
    integer i;  // Definition for the iteration factor
    initial begin
        for (i = 0; i <= SnakeLength - 1; i = i +1) begin   // Initializa the snake to position (80,100)
            SnakeState_X [i] = 80;
            SnakeState_Y [i] = 100;
        end
    end
    
    // Instantiation for the speed counter which can slow down the movement of snake
    generic_counter # (.COUNTER_WIDTH (23), .COUNTER_MAX   (5000000)) Speed_Counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (1'b1),
    .TRIG_OUT (),    // Pin not used
    .COUNT    (Speed_Counter)
    );

    // The code within "generate" statement is from the instruction of Digital Systems Lab 3 Module 14
    // Changing the position of the snake registers
    // Shift the SnakeState X and Y
    genvar PixNo;
    generate
        for (PixNo = 0; PixNo <= SnakeLength - 1; PixNo = PixNo + 1)
            begin: PixShift
                always@ (posedge CLK) begin
                    if (RESET) begin
                        SnakeState_X [PixNo + 1] <= 80;
                        SnakeState_Y [PixNo + 1] <= 100;
                    end // else
                    else if ((Speed_Counter == 0) && (MSM_STATE == 2'b01)) begin
                        SnakeState_X [PixNo + 1] <= SnakeState_X [PixNo];
                        SnakeState_Y [PixNo + 1] <= SnakeState_Y [PixNo];
                    end // else if
                end // always
            end // for
    endgenerate
    
    // Navigate the movement of snake
    always@ (posedge CLK) begin
        if (RESET) begin    // Set the initial state of the snake
            SnakeState_X [0] = 80;
            SnakeState_Y [0] = 100;
        end // if
        else if ((Speed_Counter == 0) && (MSM_STATE == 2'b01)) begin    // Use Speed Counter to slow down the movement of the snake
            case (NVGT_STATE)
                2'b00: begin                        // Up
                    if (SnakeState_Y [0] == 0)      // When the snake gets the top of the screen, make it appearing at the bottom
                        SnakeState_Y [0] <= MaxY;
                    else
                        SnakeState_Y [0] <= SnakeState_Y [0] - 1;
                end
                
                2'b01: begin                        // Down
                    if (SnakeState_Y [0] == MaxY)   // When the snake gets the bottom of the screen, make it appearing at the top
                        SnakeState_Y [0] <=0;
                    else
                        SnakeState_Y [0] <= SnakeState_Y [0] + 1;
                end
                
                2'b10: begin                        // Left
                    if (SnakeState_X [0] == 0)      // When the snake gets the leftmost of the screen, make it appearing at the rightmost
                        SnakeState_X [0] <= MaxX;
                    else
                        SnakeState_X [0] <= SnakeState_X [0] - 1;
                end
                
                2'b11: begin                        // Right
                    if (SnakeState_X [0] == MaxX)   // When the snake gets the rightmost of the screen, make it appearing at the leftmost
                        SnakeState_X [0] <= 0;
                    else
                        SnakeState_X [0] <= SnakeState_X [0] + 1;
                end                
            endcase
        end // else if
    end // always
    
    // Check if the snake reaches the target
    always@ (posedge CLK) begin
        if ((SnakeState_X [0] == TRGT_X) && (SnakeState_Y [0] == TRGT_Y))   // When the snake reaches the target, activate "REACHED_TRGT"
            REACHED_TRGT <= 1;
        else 
            REACHED_TRGT <= 0;
    end // always
    
    // This part will colour the snake yellow, colour the target red, colour the background blue
    always@ (posedge CLK) begin
        if (                                                                        // Check if the pixel belongs to the snake
            ((pixel_x == SnakeState_X [0]) && (pixel_y == SnakeState_Y [0]))   |
            ((pixel_x == SnakeState_X [1]) && (pixel_y == SnakeState_Y [1]))   |
            ((pixel_x == SnakeState_X [2]) && (pixel_y == SnakeState_Y [2]))   |
            ((pixel_x == SnakeState_X [3]) && (pixel_y == SnakeState_Y [3]))   |
            ((pixel_x == SnakeState_X [4]) && (pixel_y == SnakeState_Y [4]))   |
            ((pixel_x == SnakeState_X [5]) && (pixel_y == SnakeState_Y [5]))   |
            ((pixel_x == SnakeState_X [6]) && (pixel_y == SnakeState_Y [6]))   |
            ((pixel_x == SnakeState_X [7]) && (pixel_y == SnakeState_Y [7]))   |
            ((pixel_x == SnakeState_X [8]) && (pixel_y == SnakeState_Y [8]))   |
            ((pixel_x == SnakeState_X [9]) && (pixel_y == SnakeState_Y [9]))   |
            ((pixel_x == SnakeState_X [10]) && (pixel_y == SnakeState_Y [10])) |
            ((pixel_x == SnakeState_X [11]) && (pixel_y == SnakeState_Y [11])) |
            ((pixel_x == SnakeState_X [12]) && (pixel_y == SnakeState_Y [12])) |
            ((pixel_x == SnakeState_X [13]) && (pixel_y == SnakeState_Y [13])) |
            ((pixel_x == SnakeState_X [14]) && (pixel_y == SnakeState_Y [14])) |
            ((pixel_x == SnakeState_X [15]) && (pixel_y == SnakeState_Y [15])) |
            ((pixel_x == SnakeState_X [16]) && (pixel_y == SnakeState_Y [16])) |
            ((pixel_x == SnakeState_X [17]) && (pixel_y == SnakeState_Y [17])) |
            ((pixel_x == SnakeState_X [18]) && (pixel_y == SnakeState_Y [18])) |
            ((pixel_x == SnakeState_X [19]) && (pixel_y == SnakeState_Y [19])) )
            COLOUR_OUT <= 12'h0FF;
        else if ((pixel_x == TRGT_X) && (pixel_y == TRGT_Y))                        // Check if the pixel belongs to the target
            COLOUR_OUT <= 12'h00F;
        else                                                                        // Colour the background blue
            COLOUR_OUT <= 12'hF00;
    end // always
endmodule