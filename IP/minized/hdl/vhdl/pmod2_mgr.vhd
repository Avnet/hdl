----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2016 06:02:58 PM
-- Design Name: 
-- Module Name: pmod2_mgr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;  

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pmod2_mgr is
    Port ( clk_in : in STD_LOGIC;
   resetn_in : in STD_LOGIC;
   PMOD2_PIN1  : out STD_LOGIC;
   PMOD2_PIN2  : out STD_LOGIC;
   PMOD2_PIN3  : out STD_LOGIC;
   PMOD2_PIN4  : out STD_LOGIC;
   PMOD2_PIN7  : out STD_LOGIC;
   PMOD2_PIN8  : out STD_LOGIC;
   PMOD2_PIN9  : out STD_LOGIC;
   PMOD2_PIN10 : out STD_LOGIC;
   AUDIO_CLK_in : in STD_LOGIC;
   AUDIO_DAT_in : in STD_LOGIC;
   SLOW_CLK_out : out STD_LOGIC;
   DSP_in : in STD_LOGIC_VECTOR(15 downto 0)
   );
end pmod2_mgr;

architecture Behavioral of pmod2_mgr is

signal counter                  : std_logic_vector(7 downto 0);

begin
process(resetn_in,AUDIO_CLK_in)
variable vCount : unsigned(7 downto 0);
begin
if (resetn_in = '0') then
    vCount := (others => '0');
 elsif rising_edge(AUDIO_CLK_in) then
    vCount := vCount + 1;
    counter    <= std_logic_vector(vCount);
end if;
end process;

--Assign the outputs:

--PMOD_DAT(7 downto 0)  <= counter(7 downto 0);
PMOD2_PIN1  <= DSP_in(8);
PMOD2_PIN2  <= DSP_in(9);
PMOD2_PIN3  <= DSP_in(10);
PMOD2_PIN4  <= DSP_in(11);
PMOD2_PIN7  <= DSP_in(12);
PMOD2_PIN8  <= DSP_in(13);
PMOD2_PIN9  <= DSP_in(14);
PMOD2_PIN10 <= DSP_in(15);
--PMOD2_PIN9  <= AUDIO_CLK_in;
--PMOD2_PIN10 <= AUDIO_DAT_in;

SLOW_CLK_out <= counter(5); --Divide by 64, the filter decimation rate

end Behavioral;
