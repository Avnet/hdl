-------------------------------------------------------------------------------
--      _____
--     /     \
--    /____   \____
--   / \===\   \==/
--  /___\===\___\/  AVNET
--       \======/
--        \====/    
-------------------------------------------------------------------------------
--
-- This design is the property of Avnet.  Publication of this
-- design is not authorized without written consent from Avnet.
-- 
-- Please direct any questions to community forums on MicroZed.org
--
-- Disclaimer:
--    Avnet, Inc. makes no warranty for the use of this code or design.
--    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
--    any errors, which may appear in this code, nor does it make a commitment
--    to update the information contained herein. Avnet, Inc specifically
--    disclaims any implied warranties of fitness for a particular purpose.
--                     Copyright(c) 2015 Avnet, Inc.
--                             All rights reserved.
--
-------------------------------------------------------------------------------
--
-- Create Date:         Apr 26, 2015
-- Project Name:        External Input Signal Debounce
--
-- Target Devices:      Zynq-7000
-- Avnet Boards:        ZedBoard, MicroZed, PicoZed
--
--
-- Tool versions:       Vivado 2014.4
--
-- Description:         This project debounces external input signals. 
--
-- Dependencies:        
--
-- Revision:            Apr 20, 2015: 1.00 First Version
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity debounce is
  generic (
    C_DEPTH_SELECT : integer := 4  -- 2-to-n number of clock cycles to debounce input signal
  );
  port (
    clk           : in  std_logic; -- Debounce clock should be around 10-100ns period.
    signal_in     : in  std_logic; -- Physical input signal.
    signal_out    : out std_logic -- Debounced output signal.
  );
	
end debounce;

architecture rtl of debounce is

  constant SHIFT_REG_EMPTY : std_logic_vector(C_DEPTH_SELECT downto 0) := (others => '0'); -- When shift register is empty.
  constant SHIFT_REG_FULL  : std_logic_vector(C_DEPTH_SELECT downto 0) := (others => '1'); -- When shift register is full.

  signal signal_in_reg     : std_logic_vector(C_DEPTH_SELECT downto 0) := (others => '0');  -- Registered input signal samples.

  begin

  -- Input signal debounce process.
  debounce : process (clk)
  begin 
    if rising_edge(clk) then
      signal_in_reg <= signal_in_reg(signal_in_reg'high - 1 downto signal_in_reg'low) & signal_in;
	  
	  -- Check to see if the input shift register has filled up with valid 
	  -- input samples.
	  if (signal_in_reg = SHIFT_REG_FULL) then
	    -- A valid logic high is detected, set the debounced output high.
	    signal_out <= '1';
	  else
	    -- A valid logic high has not been detected yet, set the debounced 
		-- output low.
	    signal_out <= '0';
	  end if;

    end if;
end process;

end rtl;
