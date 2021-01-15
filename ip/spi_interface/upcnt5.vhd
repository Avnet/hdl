-- File:     upcnt5.vhd
-- 
-- Purpose:  Up 5-bit counter
--
-- Created:  7-25-00 ALS
-- Modified: 2014-06-19 DWR
	


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity upcnt5 is
   port (
      cnt_en       : in STD_LOGIC;                        -- Count enable                       -- Load line enable
      clr          : in STD_LOGIC;                        -- Active high clear
      clk          : in STD_LOGIC;                        -- Clock
      qout         : inout STD_LOGIC_VECTOR (4 downto 0)
   );
end upcnt5;


architecture DEFINITION of upcnt5 is

signal q_int : UNSIGNED (4 downto 0);

begin

process(clk, clr)
begin
   -- Clear output register
   if (clr = '1') then
      q_int <= (others => '0');
   -- On rising edge of clock count
   elsif (clk'event) and clk = '1' then
      if cnt_en = '1' then
         q_int <= q_int + 1;
      end if;
   end if;
end process;

qout <= STD_LOGIC_VECTOR(q_int);

end DEFINITION;
  

