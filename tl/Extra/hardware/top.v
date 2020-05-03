`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2015 00:15:58
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    input clk_in,
    input reset_in,
    output [15:0] led_out,
    input p_btn_U_in,
    input p_btn_L_in,
    input p_btn_R_in,
    input p_btn_D_in,
    input  [15:0] s_switches_in,
    output [7:0] seg7_hex_out,
    output [3:0] seg7_sel_out,
    output [11:0] vga_colour_out,
    output vga_hs_out,
    output vga_vs_out,
    input uart_rxd,
    output uart_txd
    );
    
    wire [11:0] reg_0_colour;
    wire [11:0] reg_1_colour;
    wire [11:0] reg_2_colour;
    wire [11:0] reg_3_colour;
    wire [11:0] reg_4_colour;
    wire [11:0] reg_5_colour;
    wire [11:0] reg_6_colour;
    wire [11:0] reg_7_colour;
    wire [11:0] reg_8_colour;
    wire [11:0] reg_9_colour;
    wire [11:0] reg_10_colour;
    wire [11:0] reg_11_colour;
    
    mb_system_wrapper mb_sys_inst (
        .clk_in(clk_in),
        .ext_reset_in(~reset_in),
        .led_out_tri_o(led_out),
        .p_btn_d_tri_i(p_btn_D_in),
        .p_btn_l_tri_i(p_btn_L_in),
        .p_btn_r_tri_i(p_btn_R_in),
        .p_btn_u_tri_i(p_btn_U_in),
        .s_switches_tri_i(s_switches_in),
        .seg7_hex_out_tri_o(seg7_hex_out),
        .seg7_sel_out_tri_o(seg7_sel_out),
        .region_0_colour_tri_o(reg_0_colour),
        .region_1_colour_tri_o(reg_1_colour),
        .region_2_colour_tri_o(reg_2_colour),
        .region_3_colour_tri_o(reg_3_colour),
        .region_4_colour_tri_o(reg_4_colour),
        .region_5_colour_tri_o(reg_5_colour),
        .region_6_colour_tri_o(reg_6_colour),
        .region_7_colour_tri_o(reg_7_colour),
        .region_8_colour_tri_o(reg_8_colour),
        .region_9_colour_tri_o(reg_9_colour),
        .region_10_colour_tri_o(reg_10_colour),
        .region_11_colour_tri_o(reg_11_colour),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd)
    );
    
    VGAControl VGACntrl_inst (
        .reset(reset_in),
        .clk(clk_in),
        .colour_out(vga_colour_out),
        .hs(vga_hs_out),
        .vs(vga_vs_out),
        .reg_0_colour(reg_0_colour),
        .reg_1_colour(reg_1_colour),
        .reg_2_colour(reg_2_colour),
        .reg_3_colour(reg_3_colour),
        .reg_4_colour(reg_4_colour),
        .reg_5_colour(reg_5_colour),
        .reg_6_colour(reg_6_colour),
        .reg_7_colour(reg_7_colour),
        .reg_8_colour(reg_8_colour),
        .reg_9_colour(reg_9_colour),
        .reg_10_colour(reg_10_colour),
        .reg_11_colour(reg_11_colour)
    );
 
endmodule
