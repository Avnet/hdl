----------------------------------------------------------------------------------
-- Engineer:    Mike Field <hamster@snap.net.nz> 
-- Module Name: convert_444_422 - Behavioral 
-- 
-- Description: Convert the input pixels into two RGB values - that for the Y calc
--              and that for the CbCr calculation
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
use IEEE.NUMERIC_STD.ALL;

entity convert_444_422 is
    Port ( clk      : in  STD_LOGIC;
           -- pixels and control signals in
           r_in      : in  STD_LOGIC_VECTOR (7 downto 0);
           g_in      : in  STD_LOGIC_VECTOR (7 downto 0);
           b_in      : in  STD_LOGIC_VECTOR (7 downto 0);
           hsync_in  : in  STD_LOGIC;
           vsync_in  : in  STD_LOGIC;
           hblank_in : in  STD_LOGIC;
           vblank_in : in  STD_LOGIC;
           de_in     : in  STD_LOGIC;
           
           -- two channels of output RGB + control signals
           r1_out     : out STD_LOGIC_VECTOR (8 downto 0);
           g1_out     : out STD_LOGIC_VECTOR (8 downto 0);
           b1_out     : out  STD_LOGIC_VECTOR (8 downto 0);

           r2_out     : out  STD_LOGIC_VECTOR (8 downto 0);
           g2_out     : out  STD_LOGIC_VECTOR (8 downto 0);
           b2_out     : out  STD_LOGIC_VECTOR (8 downto 0);
           pair_start_out : out STD_LOGIC;
           hsync_out  : out STD_LOGIC;
           vsync_out  : out STD_LOGIC;
           hblank_out : out STD_LOGIC;
           vblank_out : out STD_LOGIC;
           de_out     : out STD_LOGIC
           );
end convert_444_422;

architecture Behavioral of convert_444_422 is
   signal r_a : STD_LOGIC_VECTOR (7 downto 0);
   signal g_a : STD_LOGIC_VECTOR (7 downto 0);
   signal b_a : STD_LOGIC_VECTOR (7 downto 0);
   signal h_a : STD_LOGIC;
   signal v_a : STD_LOGIC;
   signal h_b : STD_LOGIC;
   signal v_b : STD_LOGIC;
   signal d_a : STD_LOGIC;
   signal d_a_last : STD_LOGIC;

   -- flag is used to work out which pairs of pixels to sum.
   signal flag : STD_LOGIC;
begin

clk_proc: process(clk)
   begin
      if rising_edge(clk) then
         -- sync pairs to the de_in going high (if a scan line has odd pixel count)
         if (d_a = '1' and d_a_last = '0') or flag = '1' then
            r2_out <= std_logic_vector(unsigned('0' & r_a) +  unsigned('0' & r_in));
            g2_out <= std_logic_vector(unsigned('0' & g_a) +  unsigned('0' & g_in));
            b2_out <= std_logic_vector(unsigned('0' & b_a) +  unsigned('0' & b_in));
            flag   <= '0';
            pair_start_out <= '1';
         else
            flag <= '1';
            pair_start_out <= '0';
         end if;
         
         r1_out    <= r_a & "0";
         b1_out    <= b_a & "0";
         g1_out    <= g_a & "0";
         hsync_out <= h_a;
         vsync_out <= v_a;
         hblank_out <= h_b;
         vblank_out <= v_b;
         de_out    <= d_a;
         d_a_last  <= d_a;
      
         r_a <= r_in;
         g_a <= g_in;
         b_a <= b_in;
         h_a <= hsync_in;
         v_a <= vsync_in;
         h_b <= hblank_in;
         v_b <= vblank_in;
         d_a <= de_in;
         
      end if;
   end process;

end Behavioral;