-- Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
-- Date        : Fri Nov 23 09:57:39 2018
-- Host        : tlf18.see.ed.ac.uk running 64-bit Scientific Linux release 7.5 (Nitrogen)
-- Command     : write_vhdl -force -mode synth_stub
--               /home/s1886282/0_MyProjects/0_Digital_System_Design_Lab_3/9_Assessment2/Extra/Snake_Game/Snake_Game.srcs/sources_1/ip/Idle_State_Pattern_Rom/Idle_State_Pattern_Rom_stub.vhdl
-- Design      : Idle_State_Pattern_Rom
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Idle_State_Pattern_Rom is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 16 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 11 downto 0 )
  );

end Idle_State_Pattern_Rom;

architecture stub of Idle_State_Pattern_Rom is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[16:0],douta[11:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_2,Vivado 2015.2";
begin
end;
