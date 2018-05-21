-- 
-- Create Date: 09/14/2016 06:02:58 PM
-- Design Name: 
-- Module Name: pmod1_mgr - Behavioral
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

entity pmod1_mgr is
    Port ( clk_in : in STD_LOGIC;
       resetn_in : in STD_LOGIC;
       --PMOD_DAT : inout STD_LOGIC_VECTOR (7 downto 0)
       PMOD1_PIN1  : inout STD_LOGIC;
       PMOD1_PIN2  : inout STD_LOGIC;
       PMOD1_PIN3  : inout STD_LOGIC;
       PMOD1_PIN4  : inout STD_LOGIC;
       PMOD1_PIN7  : inout STD_LOGIC;
       PMOD1_PIN8  : inout STD_LOGIC;
       PMOD1_PIN9  : inout STD_LOGIC;
       PMOD1_PIN10 : inout STD_LOGIC
       );
end pmod1_mgr;

architecture Behavioral of pmod1_mgr is

    signal counter                  : std_logic_vector(7 downto 0);

begin
process(resetn_in,clk_in)
variable vCount : unsigned(7 downto 0);
begin
    if (resetn_in = '0') then
        vCount := (others => '0');
     elsif rising_edge(clk_in) then
        vCount := vCount + 1;
        counter    <= std_logic_vector(vCount);
    end if;
end process;

--Assign the outputs:

    --PMOD_DAT(7 downto 0)  <= counter(7 downto 0);
    PMOD1_PIN1  <= counter(0);
    PMOD1_PIN2  <= counter(1);
    PMOD1_PIN3  <= counter(2);
    PMOD1_PIN4  <= counter(3);
    PMOD1_PIN7  <= counter(4);
    PMOD1_PIN8  <= counter(5);
    PMOD1_PIN9  <= counter(6);
    PMOD1_PIN10 <= counter(7);

end Behavioral;
