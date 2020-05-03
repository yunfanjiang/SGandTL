`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 18.11.2018 15:32:56
// Design Name: Speed Selection Module
// Module Name: speed_selection
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// This module allows players to select the moving speed of snake from four speeds, slow, moderate, fast, and extremely fast, by slide switches.
// Four generic counters are used to realize four different speeds. Then a 4-to-1 multiplexer is used to select different speed counter.
// 
// Dependencies: 
// It depends on generic counter and multiplexer for its full functionalities.
// 
// Revision:
// Revision 1.2.0
// Last edited on: 24 Nov 2018
// Additional Comments:
// Block diagram for the Speed Selection Module
/*
                        CLK 
                         /                                                         SPEED_SELECT
                         |                                                               /
                         |                                                               |
                         |                                                               |
            +------------|---------------------------------------------------------------|----------+
            |            -----------------/----------------/----------------/            |          |
            |            |                |                |                |            |          |
            |            |                |                |                |            |          |
            |     +------\-----+   +------\-----+   +------\-----+   +------\-----+      |          |
            |     |     CLK    |   |     CLK    |   |     CLK    |   |     CLK    |      |          |
            |    1| EN         |  1| EN         |  1| EN         |  1| EN         |      |          |
            |     |            |   |            |   |            |   |            |      |          |
            |     |            |   |            |   |            |   |  Extremely |      |          |
            |     |    SLOW    |   |  Moderate  |   |    Fast    |   |    Fast    |      |          |
            |     |    Speed   |   |    Speed   |   |    Speed   |   |    Speed   |      |          |
            |     |   Counter  |   |   Counter  |   |   Counter  |   |   Counter  |      |          |
            |     |            |   |            |   |            |   |            |      |          |
            |     |            |   |            |   |            |   |            |      |          |
            |     |            |   |            |   |            |   |            |      |          |
            |    0| R          |  0| R          |  0| R          |  0| R          |      |          |
            |     |            |   |            |   |            |   |            |      |          |
            |     +-----/------+   +-----/------+   +-----/------+   +-----/------+      |          |
            |      COUNT|           COUNT|           COUNT|           COUNT|             |          |
            |           |                |                |                |             |          |
            |           |                |                |                |             |          |
            |           |                |                |                |         /-  |          |
            |           |                |                |                |         | `.|          |
            |           |                |                |                \----------   \,         |
            |           |                |                |                          |     '/       |
            |           |                |                \---------------------------      |       |
            |           |                |                                           |      ----/   |
            |           |                \--------------------------------------------  Mux |   |   |
            |           |                                                            |      |   |   |
            |           \-------------------------------------------------------------     .\   |   |
            |                                                                        |   ,'     |   |
            |                                                                        |  -       |   |
            |                                                                        \-`        |   |
            |                                                                                   |   |
            |                                    /----------------------------------------------\   |
            |                                    |                                                  |
            +------------------------------------|--------------------------------------------------+
                                                 |
                                                 |
                                                 \       
                                            SPEED_COUNT   
*/
//////////////////////////////////////////////////////////////////////////////////


module speed_selection(
    input         CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input         RESET,        // Connect to the middle RESET button to reset the counters
    input  [1:0]  SEL_SIGNAL,   // Connect to the slide switches to select the speed
    output [22:0] SPEED_COUNT   // Connect to the input of Snake Control Module
    );
    
    // Definition for intermediate wires
    wire [22:0] slow_count;             // Connect the output of the slow counter to the input of MUX
    wire [22:0] moderate_count;         // Connect the output of the moderate counter to the input of MUX
    wire [22:0] fast_count;             // Connect the output of the fast counter to the input of MUX
    wire [22:0] extremely_fast_count;   // Connect the output of the extremely-fast counter to the input of MUX
    
    // Instantiation for the Slow-speed Counter
    generic_counter # (.COUNTER_WIDTH (23), .COUNTER_MAX   (7000000)) Slow_Speed_Counter (
    .CLK        (CLK),
    .RESET      (RESET),
    .ENABLE     (1'b1),
    .TRIG_OUT   (),    // Pin not used
    .COUNT      (slow_count)
    );

    // Instantiation for the Moderate-speed Counter
    generic_counter # (.COUNTER_WIDTH (23), .COUNTER_MAX   (5000000)) Moderate_Speed_Counter (
    .CLK        (CLK),
    .RESET      (RESET),
    .ENABLE     (1'b1),
    .TRIG_OUT   (),    // Pin not used
    .COUNT      (moderate_count)
    );

    // Instantiation for the Fast-speed Counter
    generic_counter # (.COUNTER_WIDTH (23), .COUNTER_MAX   (3000000)) Fast_Speed_Counter (
    .CLK        (CLK),
    .RESET      (RESET),
    .ENABLE     (1'b1),
    .TRIG_OUT   (),    // Pin not used
    .COUNT      (fast_count)
    );

    // Instantiation for the Extremely fast-speed Counter
    generic_counter # (.COUNTER_WIDTH (23), .COUNTER_MAX   (1000000)) E_Fast_Speed_Counter (
    .CLK        (CLK),
    .RESET      (RESET),
    .ENABLE     (1'b1),
    .TRIG_OUT   (),    // Pin not used
    .COUNT      (extremely_fast_count)
    );

    // Instantiation for the 23-bit four-to-one multiplexer
    bit23_4to1_mux MUX (
    .SEL_SIGNAL (SEL_SIGNAL),
    .MUX_IN_0   (slow_count),
    .MUX_IN_1   (moderate_count),
    .MUX_IN_2   (fast_count),
    .MUX_IN_3   (extremely_fast_count),
    .MUX_OUT    (SPEED_COUNT)
    );
endmodule
