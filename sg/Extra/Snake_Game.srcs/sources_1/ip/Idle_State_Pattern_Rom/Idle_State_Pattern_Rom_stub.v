// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Fri Nov 23 09:57:39 2018
// Host        : tlf18.see.ed.ac.uk running 64-bit Scientific Linux release 7.5 (Nitrogen)
// Command     : write_verilog -force -mode synth_stub
//               /home/s1886282/0_MyProjects/0_Digital_System_Design_Lab_3/9_Assessment2/Extra/Snake_Game/Snake_Game.srcs/sources_1/ip/Idle_State_Pattern_Rom/Idle_State_Pattern_Rom_stub.v
// Design      : Idle_State_Pattern_Rom
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2015.2" *)
module Idle_State_Pattern_Rom(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[16:0],douta[11:0]" */;
  input clka;
  input [16:0]addra;
  output [11:0]douta;
endmodule
