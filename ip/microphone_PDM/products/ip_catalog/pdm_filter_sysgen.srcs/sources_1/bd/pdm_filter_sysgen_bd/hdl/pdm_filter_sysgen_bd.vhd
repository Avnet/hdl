--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.1 (win64) Build 1846317 Fri Apr 14 18:55:03 MDT 2017
--Date        : Sun Jun 11 11:07:01 2017
--Host        : Luc-HPZ210 running 64-bit Service Pack 1  (build 7601)
--Command     : generate_target pdm_filter_sysgen_bd.bd
--Design      : pdm_filter_sysgen_bd
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity pdm_filter_sysgen_bd is
  port (
    audio_ce : out STD_LOGIC;
    audio_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    clk : in STD_LOGIC;
    pdm_in : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of pdm_filter_sysgen_bd : entity is "pdm_filter_sysgen_bd,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=pdm_filter_sysgen_bd,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=1,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=SYSGEN,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of pdm_filter_sysgen_bd : entity is "pdm_filter_sysgen_bd.hwdef";
end pdm_filter_sysgen_bd;

architecture STRUCTURE of pdm_filter_sysgen_bd is
  component pdm_filter_sysgen_bd_pdm_filter_sysgen_1_0 is
  port (
    pdm_in : in STD_LOGIC;
    clk : in STD_LOGIC;
    audio_ce : out STD_LOGIC;
    audio_out : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component pdm_filter_sysgen_bd_pdm_filter_sysgen_1_0;
  signal clk_1 : STD_LOGIC;
  signal pdm_filter_sysgen_1_audio_ce : STD_LOGIC;
  signal pdm_filter_sysgen_1_audio_out : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal pdm_in_1 : STD_LOGIC;
begin
  audio_ce <= pdm_filter_sysgen_1_audio_ce;
  audio_out(15 downto 0) <= pdm_filter_sysgen_1_audio_out(15 downto 0);
  clk_1 <= clk;
  pdm_in_1 <= pdm_in;
pdm_filter_sysgen_1: component pdm_filter_sysgen_bd_pdm_filter_sysgen_1_0
     port map (
      audio_ce => pdm_filter_sysgen_1_audio_ce,
      audio_out(15 downto 0) => pdm_filter_sysgen_1_audio_out(15 downto 0),
      clk => clk_1,
      pdm_in => pdm_in_1
    );
end STRUCTURE;
