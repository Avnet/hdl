-- File:     sck_logic.vhd
-- 
-- Created: 8-23-00 ALS
--  This file generates an internal SCK by dividing the system clock as determined by CLKDIV. 
--  This internal SCK has a CPHA=1 relationship to data and is used to clock the internal SPI
--  shift register. This internal SCK is used to generate the desired output SCK as determined
--  by CPHA and CPOL in the control register. The SCK output to the SPI bus is output only when
--  the slave select signals are asserted, but the internal SCK runs continuously.
--
-- Revised: 8-28-00 ALS
-- Revised: 9-11-00 ALS
-- Revised: 10-17-00 ALS
-- Modified for use in Avnet Demo: 2014-06-19 DWR

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity sck_logic is
   port(
      -- clock and reset
      reset          : in    std_logic;  -- active high reset    
      clk            : in    std_logic;  -- clock

      -- internal interface signals
      clkdiv         : in    std_logic_vector(1 downto 0);   -- sets the clock divisor for sck clock
      cpol           : in    std_logic;  -- sets clock polarity for output sck clock
      cpha           : in    std_logic;  -- sets clock phase for output sck clock
      
      -- internal spi interface signals
      clkph0_mask    : in    std_logic;  -- clock mask for sck when cpha=0
      clkph1_mask    : in    std_logic;  -- clock mask for sck when cpha=1
      sck_ph1        : out   std_logic;  -- internal sck created from dividing system clock
      sck_int_re     : out   std_logic;  -- rising edge of internal sck
      sck_int_fe     : out   std_logic;  -- falling edge of internal sck
      sck_re         : out   std_logic;  -- rising edge of external sck
      sck_fe         : out   std_logic;  -- falling edge of external sck
      
      -- external spi interface signals
      sck            : out  std_logic    -- sck as determined by cpha, cpol, and clkdiv
   );
end sck_logic;



architecture DEFINITION of sck_logic is

--**************************** Signals ***************************************

signal clk_cnt      : STD_LOGIC_VECTOR(4 downto 0); -- clock divider output
signal clk_cnt_en   : STD_LOGIC;            -- count enable for clock divider
signal clk_cnt_rst  : STD_LOGIC;            -- clock count reset


signal sck_int_d1   : STD_LOGIC;    -- sck_int delayed one clock for edge detection
signal sck_int      : STD_LOGIC;    -- version of sck when CPHA=1
signal sck_ph0      : STD_LOGIC;    -- version of sck when CPHA=0
signal sck_out      : STD_LOGIC;    -- sck to be output
signal sck_d1       : std_logic;    -- output sck delayed one clock for edge detection
signal i_sck_ph1    : std_logic;    -- output sck delayed one clock for edge detection


--**************************** Component Definitions  ********************************
-- 5-bit counter for clock divider
component upcnt5 
    port(
          
         cnt_en       : in STD_LOGIC;                        -- Count enable                      
         clr          : in STD_LOGIC;                        -- Active high clear
         clk          : in STD_LOGIC;                        -- Clock
         qout         : inout STD_LOGIC_VECTOR (4 downto 0)
        
         );
        
end component;


begin

--************************** Clock Divider Instantiation ********************************
CLK_DIVDR : upcnt5
    port map(
          
         cnt_en       => clk_cnt_en,
         clr          => clk_cnt_rst,
         clk          => clk,
         qout         => clk_cnt
        
         );
-- This counter is always enabled, can't instantiate the counter with a literal
clk_cnt_en <= '1';
clk_cnt_rst <= reset;

--************************** Internal SCK Generation ***************************************
-- SCK when CPHA=1 is simply the output of the clock divider determined by the CLK_DIV bits
-- SCK_INT is based off the CPHA=1 waveforms and is used as the internal SCK
-- SCK_INT is used to clock the SPI shift register, therefore, it runs before and after SS_N
-- is asserted
-- sck_ph1 is SCK_INT when clkph1_mask = 1. The clock mask blocks SCK_INT edges that are before
-- and after SS_N
sckpha_1_process: process (clk,reset)
begin
    if reset = '1'  then
        sck_int <= '0';
    elsif clk'event and clk = '1' then
    
        -- determine clock divider output based on control register
        case clkdiv is
            when "00" =>
                sck_int <= clk_cnt(1);
            when "01" =>
                sck_int <= clk_cnt(2);
            when "10" =>
                sck_int <= clk_cnt(3);
            when "11" =>
                sck_int <= clk_cnt(4);
            when others =>  -- error in register
                sck_int <= '0';
        end case;
    end if;
end process;

i_sck_ph1 <= sck_int and clkph1_mask;
sck_ph1 <= i_sck_ph1;

-- Detect rising and falling edges of sck_ph1 to use as state transition
sck_intedge_process: process(clk, reset)
begin
    if reset = '1' then
        sck_int_d1 <= '0';
    elsif clk'event and clk = '1' then
        sck_int_d1 <= sck_int;

    end if;
end process;


sck_int_re <= '1' when sck_int = '1' and sck_int_d1 = '0' 
        else '0';
sck_int_fe <= '1' when sck_int = '0' and sck_int_d1 = '1'
        else '0';   

-- SCK when CPHA=0 is out of phase with internal SCK - therefore its toggle needs to be delayed 
-- by the signal clk_mask and then its simply an inversion of the counter bit

sckpha_0_process: process (clk, reset)
begin
    if reset = '1' then
        sck_ph0 <= '0';
    elsif clk'event and clk = '1' then
        
        if clkph0_mask = '0' then
            sck_ph0 <= '0';
        else
            case clkdiv is
                when "00" =>
                    sck_ph0 <= not(clk_cnt(1));
                when "01" =>
                    sck_ph0 <= not(clk_cnt(2));
                when "10" =>
                    sck_ph0 <= not(clk_cnt(3));
                when "11" =>
                    sck_ph0 <= not(clk_cnt(4));
                when others =>  -- error in register
                    sck_ph0 <= '0';
            end case;
        end if;
    end if;
end process;

--************************** External SCK Generation **********************************
-- This process outputs SCK based on the CPHA and CPOL parameters set in the control register
sck_out_process: process(clk, reset, cpol)
variable temp:  std_logic_vector(1 downto 0);
begin
    if reset = '1' then
        sck_out <= '0';
    elsif clk'event and clk = '1' then
        temp := cpol & cpha;
        case temp is
            when "00" =>    -- polarity = 0, phase = 0
                    -- sck = sck_ph0
                sck_out <= sck_ph0;
            when "01" =>    -- polarity= 0, phase = 1
                    -- sck = sck_ph1
                sck_out <= i_sck_ph1;
            when "10" =>    -- polarity = 1, phase = 0
                    -- sck = not(sck_ph0)
                sck_out <= not(sck_ph0);
            when "11" =>    -- polarity = 1, phase = 1
                    -- sck = not(sck_ph1)
                sck_out <= not(i_sck_ph1);
            when others =>  -- default to sck_ph0
                sck_out <= sck_ph0;
        end case;
    end if;
end process;

sck <= sck_out;
-- Detect rising and falling edges of SCK_OUT to use to end cycle correctly
-- and to keep RCV_LOAD signal 1 system clock in width
SCK_DELAY_PROCESS: process(clk, reset)
begin
    if reset = '1' then
        sck_d1 <= '0';
    elsif clk'event and clk = '1' then
        sck_d1 <= sck_out;

    end if;
end process;


sck_re <= '1' when sck_out = '1' and sck_d1 = '0' 
        else '0';
sck_fe <= '1' when sck_out = '0' and sck_d1 = '1'
        else '0';


end DEFINITION;
  

