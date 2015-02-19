-- File:     spi_xmit_shift_reg.vhd
--
-- Created:  9-6-00 ALS
--  SPI shift register that shifts data out on MOSI. No data is shifted in. 
--  This is an 8-bit, loadable register. The data output from the shift register is
--  clocked one additional system clock to align the data with the outgoing clock on
--  SCK.
--
-- Revised: 9-11-00 ALS
-- Revised: 9-20-00 ALS
-- Modified: 2014-06-19 DWR

    


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity spi_xmit_shift_reg is
   port(
      reset        : in STD_LOGIC;       -- reset
      sys_clk      : in STD_LOGIC;       -- system clock
      sclk         : in STD_LOGIC;       -- clock
      -- two modes to load data parallel and serial
      data_ld      : in STD_LOGIC;    -- Data load enable
      data_in      : in STD_LOGIC_VECTOR (7 downto 0); -- Data to load in
      shift_en     : in STD_LOGIC;    -- Shift enable   (Future - enables passthrough)
      shift_in     : in STD_LOGIC;    -- Serial data in (Future - enables passthrough)
      
      mosi     : out STD_LOGIC        -- Shift serial data out
   );
end spi_xmit_shift_reg;




architecture DEFINITION of spi_xmit_shift_reg is

--******************************** Signals ***********************
signal data_int     : STD_LOGIC_VECTOR (7 downto 0);
signal mosi_int     : STD_LOGIC;


begin

--******************************** SPI Xmit Shift Register ***********************
-- This shift register is clocked on SCK_1
xmit_shift_reg:  process(sclk, reset)
   begin
      -- Clear output register
      if (reset = '1' ) then
         data_int <= (others => '0');
      -- On rising edge of spi clock, shift data
      elsif sclk'event and sclk = '1' then
         -- Load data
         if (data_ld = '1') then
            data_int <= data_in;
         -- If shift enable is high (Future - enables passthrough)
         elsif shift_en = '1' then
            -- Shift the data
            data_int <= data_int(6 downto 0) & shift_in;
         else
            -- added state to get rid of spurious bit twiddling
            data_int <= (others => '0');
         end if;
   
      end if;
end process;

--******************************** MOSI Output Register ***********************  
-- This output register is clocked on the system clock and aligns the data from the
-- shift register with the outgoing SCK
outreg: process (sys_clk, reset)
begin
    if reset = '1' then
        mosi_int <= '0';
    elsif sys_clk'event and sys_clk = '1' then
    
        mosi_int <= data_int(7); 
    end if;
end process;
mosi <= mosi_int;

end DEFINITION;
  
