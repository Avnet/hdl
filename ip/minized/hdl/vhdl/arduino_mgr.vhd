----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/13/2016 11:42:02 AM
-- Design Name: 
-- Module Name: arduino_mgr - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity arduino_mgr is
    Port ( clk_in : in STD_LOGIC;
           resetn_in : in STD_LOGIC;
           --ARD_DAT : inout STD_LOGIC_VECTOR (13 downto 0);
           --ARD_ADDR : out STD_LOGIC_VECTOR (2 downto 0)
           ARD_DAT0 : out STD_LOGIC;
           ARD_DAT1 : out STD_LOGIC;
           ARD_DAT2 : out STD_LOGIC;
           ARD_DAT3 : out STD_LOGIC;
           ARD_DAT4 : in STD_LOGIC;
           ARD_DAT5 : in STD_LOGIC;
           ARD_DAT6 : in STD_LOGIC;
           ARD_DAT7 : out STD_LOGIC;
           ARD_DAT8 : out STD_LOGIC;
           ARD_DAT9 : out STD_LOGIC;
           ARD_DAT10 : out STD_LOGIC;
           ARD_DAT11 : out STD_LOGIC;
           ARD_DAT12 : out STD_LOGIC;
           ARD_DAT13 : out STD_LOGIC;
           ARD_ADDR0 : in STD_LOGIC;
           ARD_ADDR1 : in STD_LOGIC;
           ARD_ADDR2 : out STD_LOGIC;
           --PL_LED_G : out STD_LOGIC;
           --PL_LED_R : out STD_LOGIC;
           LSM6DS0_INT1 : out STD_LOGIC_VECTOR(0 downto 0);
           LPS25H_INT1 : out STD_LOGIC_VECTOR(0 downto 0);
           HTS221_DRDY : out STD_LOGIC_VECTOR(0 downto 0);
           LIS3MDL_INT1 : out STD_LOGIC_VECTOR(0 downto 0);
           LIS3MDL_DRDY : out STD_LOGIC_VECTOR(0 downto 0)
           );
end arduino_mgr;

architecture Behavioral of arduino_mgr is

    signal counter   : std_logic_vector(27 downto 0);

begin
    process(resetn_in,clk_in)
    variable vCount : unsigned(27 downto 0);
    begin
      --  if (resetn_in = '0') then
      --      vCount := (others => '0');
      --   elsif rising_edge(clk_in) then
        if rising_edge(clk_in) then
            vCount := vCount + 1;
            counter    <= std_logic_vector(vCount);
        end if;
    end process;

--Assign the outputs:
    ARD_DAT0  <= counter(0);
    ARD_DAT1  <= counter(1);
    ARD_DAT2  <= counter(2);
    ARD_DAT3  <= counter(3);
    --ARD_DAT4  <= counter(4);
    --ARD_DAT5  <= counter(5);
    --ARD_DAT6  <= counter(6);
    ARD_DAT7  <= counter(7);
    ARD_DAT8  <= counter(8);
    ARD_DAT9  <= counter(9);
    ARD_DAT10  <= counter(10);
    ARD_DAT11  <= counter(11);
    ARD_DAT12  <= counter(12);
    ARD_DAT13  <= counter(13);
    --ARD_ADDR0  <= counter(14);
    --ARD_ADDR1  <= counter(15);
    ARD_ADDR2  <= counter(16);

    --PL_LED_G <= counter(21);
    --PL_LED_R <= counter(22);

    LSM6DS0_INT1(0) <= ARD_DAT4;
    LPS25H_INT1(0) <= ARD_DAT5;
    HTS221_DRDY(0) <= ARD_DAT6;
    LIS3MDL_INT1(0) <= ARD_ADDR0;
    LIS3MDL_DRDY(0) <= ARD_ADDR1;



end Behavioral;
