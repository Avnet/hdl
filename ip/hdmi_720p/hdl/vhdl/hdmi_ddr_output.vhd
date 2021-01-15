----------------------------------------------------------------------------------
-- Engineer:    Mike Field <hamster@snap.net.nz>
-- 
-- Module Name:    hdmi_ddr_output - Behavioral 
--
-- Description: DDR inferface to the ADV7511 HDMI transmitter
--
-- Feel free to use this how you see fit, and fix any errors you find :-)
----------------------------------------------------------------------------------

------------------------------------------------------------------------------
--      _____
--     *     *
--    *____   *____
--   * *===*   *==*
--  *___*===*___**  AVNET
--       *======*
--        *====*
------------------------------------------------------------------------------
--
-- Derived from sample code original on http://hamsterworks.co.nz
-- 
-- This code has been modified by Avnet and republished with permission of 
-- originator Mike Field.
--
-- Please direct any questions to the PicoZed community support forum:
--    http://www.picozed.org/forum
--
-- Product information is available at:
--    http://www.picozed.org/product/picozed
--
-- Disclaimer:
--    Avnet, Inc. makes no warranty for the use of this code or design.
--    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
--    any errors, which may appear in this code, nor does it make a commitment
--    to update the information contained herein. Avnet, Inc specifically
--    disclaims any implied warranties of fitness for a particular purpose.
--
------------------------------------------------------------------------------
--
-- Revision:            Nov 13, 2015: 1.00 Avnet modifications for PicoZed
--                                         FMC Carrier Validation Test
--
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity hdmi_ddr_output is
    Port ( clk      : in  STD_LOGIC;
           clk90    : in  STD_LOGIC;
           y        : in  STD_LOGIC_VECTOR (7 downto 0);
           c        : in  STD_LOGIC_VECTOR (7 downto 0);
           hsync_in : in  STD_LOGIC;
           vsync_in : in  STD_LOGIC;
           de_in    : in  STD_LOGIC;
           
           hdmi_clk      : out   STD_LOGIC;
           hdmi_hsync    : out   STD_LOGIC;
           hdmi_vsync    : out   STD_LOGIC;
           hdmi_d        : out   STD_LOGIC_VECTOR (15 downto 0);
           hdmi_de       : out   STD_LOGIC);
end hdmi_ddr_output;

architecture Behavioral of hdmi_ddr_output is
begin
clk_proc: process(clk)
   begin
      if rising_edge(clk) then
         hdmi_vsync <= vsync_in;
         hdmi_hsync <= hsync_in;
      end if;
   end process;

ODDR_hdmi_clk : ODDR 
   generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0',SRTYPE => "SYNC") 
   port map (C => clk90, Q => hdmi_clk,  D1 => '1', D2 => '0', CE => '1', R => '0', S => '0');

ODDR_hdmi_de : ODDR 
   generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0',SRTYPE => "SYNC") 
   port map (C => clk, Q => hdmi_de,  D1 => de_in, D2 => de_in, CE => '1', R => '0', S => '0');

ddr_gen: for i in 0 to 7 generate
   begin
   ODDR_hdmi_d : ODDR 
     generic map(DDR_CLK_EDGE => "SAME_EDGE", INIT => '0',SRTYPE => "SYNC") 
     port map (C => clk, Q => hdmi_d(i),  D1 => c(i), D2 => y(i), CE => '1', R => '0', S => '0');
   end generate;
   hdmi_d(15 downto 8) <= "00000000";

end Behavioral;