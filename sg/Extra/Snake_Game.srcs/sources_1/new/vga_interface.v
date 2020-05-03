`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: School of Engineering, The University of Edinburgh
// Engineer: Yunfan Jiang (s1886282)
// 
// Create Date: 24.10.2018 11:39:06
// Design Name: VGA Interface
// Module Name: vga_interface
// Project Name: Snake Game
// Target Devices: DIGILENT Basys3
// Tool Versions: Vivado 2015.2
// Description: 
// Major code is from previous work in Digital System Lab 3 Module 10
// Drive the VGA.
// Read the RGB value from Colour Control Logic and colour each pixels on the screen.
// 
// Dependencies: 
// It dependes on generic counter for its full functionalities.
// Revision:
// Revision 1.2.4
// Last edited on: 24 Nov 2018
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_interface(
    input             CLK,          // Connect to the on-board clock with the frequency of 100MHz
    input      [11:0] COLOUR_IN,    // Connect to the output of Colour Logic 
    output            VERT_TRIG,    // Connect to the inputs of Idle Pattern Display, Win Pattern Display, and Fail Pattern Display   
    output reg        HS,           // Connect to the Horizontal Sync
    output reg        VS,           // Connect to the Vertical Sync
    output reg [8:0]  ADDRV,        // Connect to the output of VGA Display Module
    output reg [9:0]  ADDRH,        // Connect to the output of VGA Display Module
    output reg [11:0] COLOUR_OUT    // Connect to VGA colours
    );
    
    // Time is Vertical Lines
    parameter VertTimeToPulseWidthEnd  = 10'd2;     // Reset the Vertical Sync
    parameter VertTimeToBackPorchEnd   = 10'd31;    // VGA starts to scan
    parameter VertTimeToDisplayTimeEnd = 10'd511;   // VGA stops scaning
    parameter VertTimeToFrontPorchEnd  = 10'd521;   
    
    // Time is Front Horizontal Lines
    parameter HorzTimeToPulseWidthEnd  = 10'd96;    // Reset the Horizontal Sync
    parameter HorzTimeToBackPorchEnd   = 10'd144;   // VGA starts to scan
    parameter HorzTimeToDisplayTimeEnd = 10'd784;   // VGA stops scaning
    parameter HorzTimeToFrontPorchEnd  = 10'd800;
    
    // Definition for wires
    wire       Horz_trigger;        // Connect to the output of the Horizontal Counter to the input of Vertical Counter
    wire       LOW_FREQ_TRIGGER;    // Connect to the output of the Low Frequency Counter to the input of the Horizontal Counter
    wire [9:0] Horz_count;          // Connect to the output of the Horizontal Counter
    wire [9:0] Ver_count;           // Connect to the output of the Vertical Counter
    
    // Instantiation for Low_freq_counter
    // This counter will adjust the frequency to the monitor-acceptable frequency
    generic_counter # (.COUNTER_WIDTH (2), .COUNTER_MAX   (3)) Low_freq_counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (1'b1),
    .TRIG_OUT (LOW_FREQ_TRIGGER),
    .COUNT    ()    // Pin not used
    );
                       
    // Instantiation for Horizontal_counter
    generic_counter # (.COUNTER_WIDTH (10), .COUNTER_MAX   (799)) Horz_counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (LOW_FREQ_TRIGGER),
    .TRIG_OUT (Horz_trigger),
    .COUNT    (Horz_count)
    );
                       
    // Instantiation for Vertical_counter
    generic_counter # (.COUNTER_WIDTH (10), .COUNTER_MAX   (520)) Ver_counter (
    .CLK      (CLK),
    .RESET    (1'b0),
    .ENABLE   (Horz_trigger),
    .TRIG_OUT (VERT_TRIG),
    .COUNT    (Ver_count)
    );
                       
    // Definition for logic of HS and VS
    always@ (posedge CLK) begin
        if (Horz_count < HorzTimeToPulseWidthEnd)   // Within this range, reset the Horizontal Sync
            HS <= 0;
        else
            HS <= 1;
    end // always
    
    always@ (posedge CLK) begin
        if (Ver_count < VertTimeToPulseWidthEnd)    // Within this range, reset the Vertical Sync
            VS <= 0;
        else
            VS <= 1;
    end // always
    
    // Definition for logic of COLOUR_OUT
    always@ (posedge CLK) begin // Within the displaying range, output the "COLOUR_IN"
        if ((Horz_count >= HorzTimeToBackPorchEnd) && (Horz_count <= HorzTimeToDisplayTimeEnd) && (Ver_count >= VertTimeToBackPorchEnd) && (Ver_count <= VertTimeToDisplayTimeEnd))
            COLOUR_OUT <= COLOUR_IN;
        else
            COLOUR_OUT <= 0;
    end // always
    
    // Definition for logic of Addresses
    // Output the addresses of next pixel that will be scaned
    always@ (posedge CLK) begin
        if ((Horz_count >= HorzTimeToBackPorchEnd) && (Horz_count <= HorzTimeToDisplayTimeEnd) && (Ver_count >= VertTimeToBackPorchEnd) && (Ver_count <= VertTimeToDisplayTimeEnd)) begin
            ADDRH <= Horz_count - HorzTimeToBackPorchEnd + 1;
            ADDRV <= Ver_count - VertTimeToBackPorchEnd + 1;
        end // if
        else begin
            ADDRH <= 0;
            ADDRV <= 0;
        end // else
    end // always
    
endmodule
