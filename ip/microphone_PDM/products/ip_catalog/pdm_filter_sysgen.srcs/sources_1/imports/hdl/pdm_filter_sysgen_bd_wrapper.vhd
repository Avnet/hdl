--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.1 (win64) Build 1846317 Fri Apr 14 18:55:03 MDT 2017
--Date        : Sun Jun 11 11:07:01 2017
--Host        : Luc-HPZ210 running 64-bit Service Pack 1  (build 7601)
--Command     : generate_target pdm_filter_sysgen_bd_wrapper.bd
--Design      : pdm_filter_sysgen_bd_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity pdm_filter_sysgen_bd_wrapper is
  port (
    audio_ce : out STD_LOGIC;
    audio_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    clk : in STD_LOGIC;
    pdm_in : in STD_LOGIC
  );
end pdm_filter_sysgen_bd_wrapper;

architecture STRUCTURE of pdm_filter_sysgen_bd_wrapper is
  component pdm_filter_sysgen_bd is
  port (
    audio_ce : out STD_LOGIC;
    audio_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    clk : in STD_LOGIC;
    pdm_in : in STD_LOGIC
  );
  end component pdm_filter_sysgen_bd;
begin
pdm_filter_sysgen_bd_i: component pdm_filter_sysgen_bd
     port map (
      audio_ce => audio_ce,
      audio_out(15 downto 0) => audio_out(15 downto 0),
      clk => clk,
      pdm_in => pdm_in
    );
end STRUCTURE;
