----------------------------------------------------------------------------------
-- Engineer:  Mike Field <hamster@snap.net.nz> 
-- Module:    vga_generator.vhd
-- 
-- Description: A test pattern generator for the Zedboard's VGA & HDMI interface
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
-- Modifications: 		Removed VGA Interface and support 720P timing with 
--                      embedded synchronization.
--
------------------------------------------------------------------------------ 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity video_generator is
	Port ( clk        : in   STD_LOGIC;
           r          : out  STD_LOGIC_VECTOR (7 downto 0);
           g          : out  STD_LOGIC_VECTOR (7 downto 0);
           b          : out  STD_LOGIC_VECTOR (7 downto 0);
           de         : out  STD_LOGIC := '0';
           vsync      : out  STD_LOGIC := '0';
           hsync      : out  STD_LOGIC := '0';
		   vblank     : out  STD_LOGIC := '0';
		   hblank     : out  STD_LOGIC := '0'
		 );
end video_generator;

architecture Behavioral of video_generator is
   
   signal   colour_pattern : STD_LOGIC_VECTOR (23 downto 0);
   signal   colour         : STD_LOGIC_VECTOR (23 downto 0);
   
   signal   hcounter    : unsigned(11 downto 0) := (others => '0');
   signal   vcounter    : unsigned(11 downto 0) := (others => '0');
   
   constant ZERO        : unsigned(11 downto 0) := (others => '0');

   signal   hVisible    : unsigned(11 downto 0);
   signal   hStartSync  : unsigned(11 downto 0);
   signal   hEndSync    : unsigned(11 downto 0);
   signal   hMax        : unsigned(11 downto 0);
   signal   hSyncActive : std_logic := '1';
   
   signal   vVisible    : unsigned(11 downto 0);
   signal   vStartSync  : unsigned(11 downto 0);
   signal   vEndSync    : unsigned(11 downto 0);
   signal   vMax        : unsigned(11 downto 0);
   signal   vSyncActive : std_logic := '1';  
   
   -- Colours converted using The RGB -> YCbCr converter app found on Google Gadgets 
                                                                        --  Y   Cb  Cr
   constant C_BLACK      : std_logic_vector(23 downto 0) := x"000000";  --  16 128 128
   constant C_RED        : std_logic_vector(23 downto 0) := x"FF0000";  --  81  90 240
   constant C_GREEN      : std_logic_vector(23 downto 0) := x"00FF00";  -- 172  42  27
   constant C_BLUE       : std_logic_vector(23 downto 0) := x"0000FF";  --  32 240 118
   constant C_WHITE      : std_logic_vector(23 downto 0) := x"FFFFFF";  -- 234 128 128
   constant C_YELLOW	 : std_logic_vector(23 downto 0) := x"FFFF00";  -- 235  24 152
   constant C_CYAN 	     : std_logic_vector(23 downto 0) := x"00FFFF";  -- 191 232   8
   constant C_PURPLE     : std_logic_vector(23 downto 0) := x"FF00FF";  --  60 232 200
   
begin  

    -- Set the video mode to 1280x720x60Hz (75MHz pixel clock needed)
    hSyncActive <= '1';
    hStartSync  <= ZERO+72-1;
    hEndSync    <= ZERO+72+80-1;
    hVisible    <= ZERO+72+80+216-1;           
	hMax        <= ZERO+72+80+216+1280-1;           
	
	vSyncActive <= '1';        
    vStartSync  <= ZERO+3-1;
    vEndSync    <= ZERO+3+5-1;
	vVisible    <= ZERO+3+5+22-1;
    vMax        <= ZERO+3+5+22+720-1;

colour_pattern_proc: process(hcounter, vcounter)
begin
    -------------------------
    -- Cool Color Pattern
    -------------------------
    colour_pattern(23 downto 16) <= std_logic_vector(hcounter(7 downto 0));
    colour_pattern(15 downto  8) <= std_logic_vector(vcounter(7 downto 0));
    colour_pattern( 7 downto  0) <= std_logic_vector(hcounter(7 downto 0)+vcounter(7 downto 0));
end process;

colour <= colour_pattern;
  
clk_process: process (clk)
   begin
      if rising_edge(clk) then 
         if (vCounter <= vVisible or hCounter < hVisible or hCounter = hMax) then 
            r  <= (others => '0');
            g  <= (others => '0');
            b  <= (others => '0');
            de <= '0';
         else
            r  <= colour(23 downto 16);
            g  <= colour(15 downto  8);
            b  <= colour( 7 downto  0);
            de <= '1';
         end if;
              
         -- Generate the sync Pulses
         if vCounter = vStartSync and hCounter = hMax then 
            vSync <= vSyncActive;
         elsif vCounter = vEndSync and hCounter = hMax then
            vSync <= not(vSyncActive);
         end if;

         if hCounter = hStartSync then 
            hSync <= hSyncActive;
         elsif hCounter = hEndSync then
            hSync <= not(hSyncActive);
         end if;

         -- Generate the Blanking Signals
		 if vCounter = vMax and hCounter = hMax then
			vBlank <= '1';
		 elsif vCounter = vVisible and hCounter = hMax then		 
		    vBlank <= '0';
		 end if;

		 if hCounter = hMax then
			hBlank <= '1';
		 elsif hCounter = hVisible then
		    hBlank <= '0';
		 end if;
		 
		 -- Advance the position counters
         if hCounter = hMax  then
            -- starting a new line
            hCounter <= (others => '0');
            if vCounter = vMax then
               vCounter <= (others => '0');
            else
               vCounter <= vCounter + 1;
            end if;
         else
            hCounter <= hCounter + 1;
         end if;
      end if;
   end process;
   
end Behavioral;

