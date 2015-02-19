-- File:     spi_rcv_shift_reg.vhd
--
-- Created:  9-6-00 ALS
--  SPI shift register that shifts data in on MISO. No data is shifted out. 
--  This is an 8-bit register clocked on the outgoing SCK. The data input
--  on the MISO pin is first clocked by two registers - one on the rising edge
--  of SCK and one on the falling edge of SCK. The data selected to be input into the
--  shift register is determined by a control bit in the control register (RCV_CPOL).
--  When all bits have been shifted in, the data is loaded into the uC SPI Receive Data
--  register.
--
-- Revised: 9-11-00 ALS
-- Revised: 10-17-00 ALS
-- Revised: 12-12-02 JRH
-- Modified: 2014-06-19 DWR
    


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity spi_rcv_shift_reg is
   port(
      reset       : in STD_LOGIC;   -- reset
      sclk        : in STD_LOGIC;   -- clock

      -- shift control and data
      miso        : in STD_LOGIC;    -- Serial data in
      shift_en    : in STD_LOGIC;    -- Active high shift enable
      
      -- parallel data out
      data_out    : out STD_LOGIC_VECTOR (7 downto 0);  -- Shifted data
      rcv_load    : out std_logic;  -- load signal to uC register
      
      -- rising edge and falling SCK edges
      sck_re      : in  std_logic;  -- rising edge of SCK
      sck_fe      : in  std_logic;  -- falling edge of SCK
      
      -- uC configuration for receive clock polarity
      cpol_cpha   : in std_logic_vector(1 downto 0)    -- spi clock polarity/spi phase
   );
end spi_rcv_shift_reg;




architecture DEFINITION of spi_rcv_shift_reg is

--******************************** Signals ***********************
signal data_int     : STD_LOGIC_VECTOR (7 downto 0);
signal shift_in     : STD_LOGIC;        -- data to be shifted in 
signal miso_neg     : STD_LOGIC;        -- data clocked on neg SCK
signal miso_pos     : STD_LOGIC;        -- data clocked on pos SCK

signal rcv_bitcnt_int   : unsigned(2 downto 0); -- internal bit count
signal rcv_bitcnt   : std_logic_vector(2 downto 0); -- bit count


begin

--******************************** SPI Receive Shift Register ***********************
-- This shift register is clocked on the SCK output from the FPGA
rcv_shift_reg:  process(sclk, reset)
begin
   -- Clear output register
   if (reset = '1') then
      data_int <= (others => '0');
   -- On rising edge of spi clock, shift in data
   elsif sclk'event and sclk = '1' then
      -- If shift enable is high
      if shift_en = '1' then
         -- Shift the data
         data_int <= data_int(6 downto 0) & shift_in;
      end if;
   end if;
end process;

--******************************** MISO Input Registers ***********************  
-- The MISO signal is clocked on both the rising and falling edges of SCK. The output
-- of both these registers is then multiplexed with the chpa control bit choosing
-- which data is the valid data for the system. This data is then the input to the
-- shift register.

-- SCK rising edge register
inreg_pos: process (sclk, reset)
begin
    if reset = '1' then
        miso_pos <= '0';
    elsif sclk'event and sclk = '1' then
    
        miso_pos <= miso; 
    end if;
end process;

-- SCK falling edge register
inreg_neg: process (sclk, reset)
begin
   if reset = '1' then
      miso_neg <= '0';
   elsif sclk'event and sclk = '0' then
      miso_neg <= miso; 
   end if;
end process;

-- multiplexor to determine shift in data
-- Mode   CPOL  CPHA
-- 0      0     0
-- 1      0     1
-- 2      1     0
-- 3      1     1
miso_mux: process (miso_neg, miso_pos, cpol_cpha)
begin
    if(cpol_cpha = "00") then
        shift_in <= miso_pos;
    elsif(cpol_cpha = "01") then
        shift_in <= miso_neg;
    elsif(cpol_cpha = "10") then
        shift_in <= miso_neg;
    elsif(cpol_cpha = "11") then
        shift_in <= miso_pos;
    end if;
end process;

--******************************** Parallel Data Out ***********************

data_out <= data_int(6 downto 0) & shift_in;

--******************************** Receive Bit Counter ***********************
-- Count bits loading into the SPI receive shift register based on SCK
-- assert RCV_LOAD when bit count is 0
RCV_BITCNT_PROC: process(sclk, reset, shift_en)
begin
    if reset = '1' or shift_en = '0' then
        rcv_bitcnt_int <= (others => '0');
    elsif sclk'event and sclk = '1' then
            rcv_bitcnt_int <= rcv_bitcnt_int + 1;
    end if;
end process;

rcv_bitcnt <= STD_LOGIC_VECTOR(rcv_bitcnt_int);

--******************************** Receive Load ***********************
-- If RCV_CPOL = '0', want to assert RCV_LOAD with falling edge of SCK
-- If RCV_CPOL = '1', want to assert RCV_LOAD with rising edge of SCK 
-- only want RCV_LOAD to be 1 system clock pulse in width
rcv_load <= '1' when ( shift_en = '1' and
            (  (rcv_bitcnt="000" and cpol_cpha="01" and sck_re='1')
            or (rcv_bitcnt="000" and cpol_cpha="11" and sck_re='1')
            or (rcv_bitcnt="000" and cpol_cpha="00" and sck_fe='1')
            or (rcv_bitcnt="111" and cpol_cpha="10" and sck_fe='1') )
              )
        else '0';

end DEFINITION;
  
