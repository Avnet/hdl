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
-- Create Date:         Sep 13, 2016
-- Project Name:        External Input Signal Debounce
--
-- Target Devices:      Zynq-7000
-- Avnet Boards:        MiniZed
--
--
-- Tool versions:       Vivado 2017.1
--
-- Description:         This module receives raw PDM (single-bit) data from PDM mic on MiniZed @ 160 MHz / 64 = 2.5 MSPS. 
--						Data is registered into 160 MHz clock domain (FCLK_CLK2 PS-PL clock).
--						AUDIO_PDM drives downstream PDM demodulation filter (pdm_filter_sg) which is synchronous to 160 MHz clock domain, for 64X over-clocking of Xilinx FIR Compiler (MAC-based) -> uses single DSP48 resource
--
-- Dependencies:        
--
-- Revision:            Sep 13, 2016: 1.00 First Version
-- 						April 20, 2017
--      					revised for use of 160 MHz fast clock with SysGen over-clocked (MAC-based) FIR filters (Luc Langlois / Avnet)
--
-------------------------------------------------------------------------------

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

entity microphone_mgr is
    Port ( clk_in : in STD_LOGIC;       -- 160 MHz
           resetn_in : in STD_LOGIC;
           AUDIO_CLK : out STD_LOGIC;     
           AUDIO_DAT : in STD_LOGIC;
           AUDIO_PDM : out STD_LOGIC;
           
           audio_captureCE : out STD_LOGIC;    -- temporary for ILA verification only
           audio_data_vector_OUT : out STD_LOGIC_VECTOR(1023 downto 0);
           PDM_vector_full_STROBE  : out STD_LOGIC
           );
end microphone_mgr;

architecture Behavioral of microphone_mgr is

    signal audio_clock_sig          : std_logic;
    signal audio_clock_sig_r        : std_logic;
    signal audio_capture_CE         : std_logic;
    signal audio_dat_r              : std_logic;
    
    signal audio_data_vector        : std_logic_vector(1023 downto 0);  -- serial-to-parallel for efficient capture in ILA BRAM of PDM vector
    signal shift_count              : std_logic_vector(9 downto 0);    -- counter to 4096 for efficient capture in ILA BRAM of PDM vector
    signal shift_count_msb_r        : std_logic;
    
    -- Declare the attributes in the architecture section
    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of clk_in: SIGNAL is "xilinx.com:signal:clock:1.0 clk_in CLK";
	ATTRIBUTE X_INTERFACE_INFO OF resetn_in: SIGNAL IS "xilinx.com:signal:reset:1.0 resetn_in RST";
	ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    -- ATTRIBUTE X_INTERFACE_PARAMETER of clk_in: SIGNAL is "FREQ_HZ 153600000"; -- can't generate from IO PLL of PS ... closest is 160 MHz for 2.5 MHz clock to mic
    ATTRIBUTE X_INTERFACE_PARAMETER of clk_in: SIGNAL is "ASSOCIATED_RESET resetn_in, FREQ_HZ 160000000";
    -- Supported parameters: ASSOCIATED_CLKEN, ASSOCIATED_RESET, ASSOCIATED_ASYNC_RESET, ASSOCIATED_BUSIF, CLK_DOMAIN, PHASE, FREQ_HZ
    -- Most of these parameters are optional.  However, when using AXI, at least one clock must be associated to the AXI interface.
    -- Use the axi interface name for ASSOCIATED_BUSIF, if there are multiple interfaces, separate each name by ':'
    -- Use the port name for ASSOCIATED_RESET.
    -- Output clocks will require FREQ_HZ to be set (note the value is in HZ and an integer is expected).
	ATTRIBUTE X_INTERFACE_INFO of AUDIO_CLK: SIGNAL is "xilinx.com:signal:clock:1.0 AUDIO_CLK CLK";
    -- ATTRIBUTE X_INTERFACE_PARAMETER of AUDIO_CLK: SIGNAL is "FREQ_HZ 2400000";
    ATTRIBUTE X_INTERFACE_PARAMETER of AUDIO_CLK: SIGNAL is "FREQ_HZ 2500000";
                
begin
--    process(resetn_in,clk_in)
    process(clk_in)
    variable audio_overclock_count : unsigned(5 downto 0);
    
    begin
        if rising_edge(clk_in) then
            if (resetn_in = '0') then
                audio_overclock_count := (others => '0');
                audio_clock_sig <= '0';
                audio_clock_sig_r <= '0';
                
                shift_count <= (others => '0');
                shift_count_msb_r <= '0';
                
            else
                audio_overclock_count := audio_overclock_count + 1;
                audio_clock_sig <= audio_overclock_count(5);                -- drive clock to mic @ 160 / 64 = 2.5 MHz
                audio_clock_sig_r <= audio_clock_sig;
                if (audio_capture_CE = '1') then
                    audio_dat_r <= AUDIO_DAT;                               -- register incoming mic PDM data

    --  serial to parallel of PDM data for efficient capture in ILA
                    audio_data_vector(1023 downto 1) <=  audio_data_vector(1022 downto 0);
                    audio_data_vector(0) <= AUDIO_DAT;
                    shift_count <= shift_count + 1;
                end if;
                shift_count_msb_r <= shift_count(9);
            end if;
        end if;
    end process;

    audio_capture_CE <= audio_clock_sig AND NOT(audio_clock_sig_r);

--Assign the outputs:
    AUDIO_CLK <= audio_clock_sig;
    AUDIO_PDM <= audio_dat_r;

    audio_captureCE <= audio_clock_sig AND NOT(audio_clock_sig_r);  -- temproary for ILA verification only
    
    audio_data_vector_OUT <= audio_data_vector;
    PDM_vector_full_STROBE <= NOT(shift_count(9)) AND shift_count_msb_r;
    
end Behavioral;
