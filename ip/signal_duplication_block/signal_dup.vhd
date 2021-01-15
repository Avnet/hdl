------------------------------------------------------------------------------
--      _____
--     /     \
--    /____   \____
--   / \===\   \==/
--  /___\===\___\/  AVNET
--       \======/
--        \====/    
------------------------------------------------------------------------------
--
-- This design is the property of Avnet.  Publication of this
-- design is not authorized without written consent from Avnet.
-- 
-- Please direct any questions to:  technical.support@avnet.com
--
-- Disclaimer:
--    Avnet, Inc. makes no warranty for the use of this code or design.
--    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
--    any errors, which may appear in this code, nor does it make a commitment
--    to update the information contained herein. Avnet, Inc specifically
--    disclaims any implied warranties of fitness for a particular purpose.
--                     Copyright(c) 2014 Avnet, Inc.
--                             All rights reserved.
--
------------------------------------------------------------------------------
--
-- Create Date:         Nov 10, 2014
-- Project Name:        Avnet Signal Duplication Block
--
-- Target Devices:      
-- Avnet Boards:        
--
--
-- Tool versions:       
--
-- Description:         This project implements a signal duplicator 
--                      
--
-- Dependencies:        
--
-- Revision:            Nov 10, 2014: 1.00 First Version
--                      
--
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity signal_duplicator is
    Generic (
      BUS_WIDTH          : integer  := 1
    );
    Port (
      INPUT              : in  std_logic_vector(BUS_WIDTH - 1 downto 0);
      OUTPUT1            : out std_logic_vector(BUS_WIDTH - 1 downto 0);
      OUTPUT2            : out std_logic_vector(BUS_WIDTH - 1 downto 0);
   );
end signal_duplicator;

architecture rtl of signal_duplicator is

   signal clk            : std_logic;
   

begin

      OUTPUT1(BUS_WIDTH - 1 downto 0) <= INPUT(BUS_WIDTH - 1 downto 0);
	  OUTPUT2(BUS_WIDTH - 1 downto 0) <= INPUT(BUS_WIDTH - 1 downto 0);

end rtl;
