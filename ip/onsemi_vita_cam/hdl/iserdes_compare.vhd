-- *********************************************************************
-- Copyright 2011, ON Semiconductor Corporation.
--
-- This software is owned by ON Semiconductor Corporation (ON)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of ON.
--
-- Disclaimer: ON makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. ON reserves the right to make changes without further
-- notice to the materials described herein. ON does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. ON's products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the ON Software License Agreement.
--
-- *********************************************************************
-- File           : $URL: http://whatever.euro.cypress.com/repos/ff_te/VHDL/LIB/modules/Iserdes/trunk/iserdes_compare.vhd $
-- Author         : $Author: bert.dewil $
-- Department     : CISP
-- Date           : $Date: 2011-04-18 15:49:57 +0200 (ma, 18 apr 2011) $
-- Revision       : $Revision: 903 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library unisim;
use unisim.vcomponents.all;

entity iserdes_compare is
  generic(
        NROF_CONN       : integer
       );
  port(
        CLOCK               : in    std_logic;
        CLKDIV              : in    std_logic;

        RESET               : in    std_logic;
        FIFO_EN             : in    std_logic;

        SAMPLEINFIRSTBIT    : in    std_logic_vector(NROF_CONN-1 downto 0);
        SAMPLEINLASTBIT     : in    std_logic_vector(NROF_CONN-1 downto 0);
        SAMPLEINOTHERBIT    : in    std_logic_vector(NROF_CONN-1 downto 0);

        SKEW_ERROR          : out   std_logic;

        FIFO_WREN           : out   std_logic;
        DELAY_WREN          : out   std_logic
       );

end iserdes_compare;

architecture rtl of iserdes_compare is

signal FIRSTBIT_OR      : std_logic;
signal LASTBIT_OR       : std_logic;
signal OTHERBIT_OR      : std_logic;

signal DELAY_WREN_r     : std_logic;
signal DELAY_WREN_r2    : std_logic;

signal FIFO_WREN_r2     : std_logic;

begin

-- OR'ed status
process (SAMPLEINFIRSTBIT)
   variable TMP : std_logic;
begin
   TMP := '0';
   for I in SAMPLEINFIRSTBIT'low to SAMPLEINFIRSTBIT'high loop
      TMP := TMP or SAMPLEINFIRSTBIT(I);
   end loop;
   FIRSTBIT_OR <= TMP;
end process;

process (SAMPLEINLASTBIT)
   variable TMP : std_logic;
begin
   TMP := '0';
   for I in SAMPLEINLASTBIT'low to SAMPLEINLASTBIT'high loop
      TMP := TMP or SAMPLEINLASTBIT(I);
   end loop;
   LASTBIT_OR <= TMP;
end process;

process (SAMPLEINOTHERBIT)
   variable TMP : std_logic;
begin
   TMP := '0';
   for I in SAMPLEINOTHERBIT'low to SAMPLEINOTHERBIT'high loop
      TMP := TMP or SAMPLEINOTHERBIT(I);
   end loop;
   OTHERBIT_OR <= TMP;
end process;

delayselector: process(RESET, CLOCK)
    variable orstatus : std_logic_vector(2 downto 0);
begin
if (RESET = '1') then
   SKEW_ERROR     <= '0';
   DELAY_WREN_r   <= '0';
elsif (CLOCK'event and CLOCK = '1') then

    orstatus := OTHERBIT_OR & LASTBIT_OR & FIRSTBIT_OR;

    case orstatus is
        when "000" => --not yet trained             0
            SKEW_ERROR     <= '0';
            DELAY_WREN_r   <= '0';
        when "001" => --all samples in first bit    1
            SKEW_ERROR     <= '0';
            DELAY_WREN_r   <= '0';
        when "010" => --all samples in last bit     2
            SKEW_ERROR     <= '0';
            DELAY_WREN_r   <= '0';
        when "100" => --all samples in other bit    4
            SKEW_ERROR     <= '0';
            DELAY_WREN_r   <= '0';
        when "101" => --samples in first & other    5
            SKEW_ERROR     <= '0';
            DELAY_WREN_r   <= '0';
        when "110" => --samples in lastt & other    6
            SKEW_ERROR     <= '0';
            DELAY_WREN_r   <= '0';
        when "011" => --samples in first & last     3
                      -- use special fifo enable to compensate word skew
            SKEW_ERROR     <= '0';
            DELAY_WREN_r   <= '1';
        when "111" => --unsupported, too much skew  7
            SKEW_ERROR     <= '1';
            DELAY_WREN_r   <= '0';
        when others =>
            SKEW_ERROR     <= '0';
            DELAY_WREN_r   <= '0';
    end case;
end if;
end process delayselector;

clockdomaincrossing: process(RESET, CLKDIV)
begin
if (RESET = '1') then
    DELAY_WREN_r2 <= '0';
    DELAY_WREN    <= '0';

    FIFO_WREN     <= '0';
    FIFO_WREN_r2  <= '0';

elsif (CLKDIV'event and CLKDIV = '1') then
   DELAY_WREN_r2    <= DELAY_WREN_r;
   DELAY_WREN       <= DELAY_WREN_r2;

   FIFO_WREN_r2     <= FIFO_EN;
   FIFO_WREN        <= FIFO_WREN_r2;
end if;
end process clockdomaincrossing;


end rtl;