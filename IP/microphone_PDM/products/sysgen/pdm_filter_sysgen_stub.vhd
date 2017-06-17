-- Generated from Simulink block 
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
entity pdm_filter_sysgen_stub is
  port (
    pdm_in : in std_logic;
    clk : in std_logic;
    audio_ce : out std_logic;
    audio_out : out std_logic_vector( 16-1 downto 0 )
  );
end pdm_filter_sysgen_stub;
architecture structural of pdm_filter_sysgen_stub is 
begin
  sysgen_dut : entity xil_defaultlib.pdm_filter_sysgen 
  port map (
    pdm_in => pdm_in,
    clk => clk,
    audio_ce => audio_ce,
    audio_out => audio_out
  );
end structural;
