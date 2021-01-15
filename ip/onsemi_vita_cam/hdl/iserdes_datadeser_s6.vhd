--------------------------------------------------------------------------------
--  
--        ** **        **          **  ****      **  **********  ********** ® 
--       **   **        **        **   ** **     **  **              ** 
--      **     **        **      **    **  **    **  **              ** 
--     **       **        **    **     **   **   **  *********       ** 
--    **         **        **  **      **    **  **  **              ** 
--   **           **        ****       **     ** **  **              ** 
--  **  .........  **        **        **      ****  **********      ** 
--     ........... 
--                                     Reach Further™ 
--  
-------------------------------------------------------------------------------
--
-- This design is the property of Avnet.  Publication of this 
-- design is not authorized without written consent from Avnet. 
-- 
-- Please direct any questions to the PicoZed community support forum: 
--    http://www.zedboard.org/forum 
-- 
-- Disclaimer: 
--    Avnet, Inc. makes no warranty for the use of this code or design. 
--    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
--    any errors, which may appear in this code, nor does it make a commitment 
--    to update the information contained herein. Avnet, Inc specifically 
--    disclaims any implied warranties of fitness for a particular purpose. 
--                     Copyright(c) 2017 Avnet, Inc. 
--                             All rights reserved. 
-- 
-------------------------------------------------------------------------------
--
-- Create Date:         Apr 23, 2012
-- Design Name:         FMC-IMAGEON
-- Module Name:         iserdes_datadeser_s6.vhd
-- Project Name:        FMC-IMAGEON
-- Target Devices:      Spartan 6
-- Avnet Boards:        FMC-IMAGEON
-- Tool versions:       ISE 13.4
-- Description:         Spartan 6 10:1 iSerDes Datapath
--
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library work;
use work.all;

--xilinx:
---------
-- synopsys translate_off
Library XilinxCoreLib;
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on


entity iserdes_datadeser_s6 is
port  (
      RESET               : in    std_logic;
      CLOCK               : in    std_logic;

      PCLK01x             : in    std_logic;
      PCLK02x             : in    std_logic;
      PCLK10x             : in    std_logic;
      STROBE              : in    std_logic;

      SDATAP              : in    std_logic;
      SDATAN              : in    std_logic;

      ALIGN_START         : in    std_logic;
      FIFO_EN             : in    std_logic;
      TRAINING            : in    std_logic_vector(9 downto 0);
      MANUAL_TAP          : in    std_logic_vector(9 downto 0);

      ALIGN_BUSY          : out   std_logic;
      ALIGNED             : out   std_logic;

      FIFO_RDEN           : in    std_logic;
      FIFO_EMPTY          : out   std_logic;
      FIFO_DATAOUT        : out   std_logic_vector(9 downto 0)
      );
end iserdes_datadeser_s6;

architecture rtl of iserdes_datadeser_s6 is

component serdes_1_to_5_diff_data is
generic (
      DIFF_TERM           : string;
      BITSLIP_ENABLE      : string
      );
port  (
      reset               : in    std_logic;
      gclk                : in    std_logic;

      rxioclk             : in    std_logic;
      rxserdesstrobe      : in    std_logic;
      bitslip             : in    std_logic;
      use_phase_detector  : in    std_logic;

      datain_p            : in    std_logic;
      datain_n            : in    std_logic;

      data_out            : out   std_logic_vector(4 downto 0)
      );
end component;

component phsaligner is
port  (
      rst                 : in    std_logic;
      clk                 : in    std_logic;
      
      training            : in    std_logic_vector(9 downto 0);
      sdata               : in    std_logic_vector(9 downto 0);

      bitslip             : out   std_logic;
      flipgear            : out   std_logic;
      psaligned           : out   std_logic
      );
end component;

component FIFO18_s6 is
port (
      rst                 : in    std_logic;
      wr_clk              : in    std_logic;
      rd_clk              : in    std_logic;
      din                 : in    std_logic_vector(15 downto 0);
      wr_en               : in    std_logic;
      rd_en               : in    std_logic;
      dout                : out   std_logic_vector(15 downto 0);
      full                : out   std_logic;
      empty               : out   std_logic
      );
end component;

signal ALIGNED_o              : std_logic;
signal RAWBYTE                : std_logic_vector(4 downto 0);
signal RAWBYTE_q              : std_logic_vector(4 downto 0);
signal RAWWORD                : std_logic_vector(9 downto 0);
signal RX_TOGGLE              : std_logic;
signal RX_TOGGLE_q            : std_logic;
signal BITSLIP                : std_logic;
signal BITSLIP_d              : std_logic;
signal BITSLIP_p              : std_logic;
signal FLIPGEAR               : std_logic;
signal FLIPGEAR_s             : std_logic;
signal FIFO_EN_d0             : std_logic;
signal FIFO_EN_d1             : std_logic;
signal FIFO_DI                : std_logic_vector(15 downto 0);
signal FIFO_DO                : std_logic_vector(15 downto 0);
signal FIFO_FULL              : std_logic;

begin

  ALIGNED <= ALIGNED_o;

  -- Align Busy
  process (CLOCK)
  begin
    if (RESET = '1') then
      ALIGN_BUSY  <= '0';
    elsif (CLOCK'event and CLOCK = '1') then
      if (ALIGN_START = '1') then
        ALIGN_BUSY  <= '1';
      elsif (ALIGNED_o = '1') then
        ALIGN_BUSY  <= '0';
      end if;
    end if;
  end process;

  -- SerDes Core
  SERDES_CORE : serdes_1_to_5_diff_data
  generic map (
    DIFF_TERM               => "FALSE"            ,
    BITSLIP_ENABLE          => "TRUE"
  )
  port map (
    reset                   => RESET              ,
    gclk                    => PCLK02x            ,
    
    rxioclk                 => PCLK10x            ,
    rxserdesstrobe          => STROBE             ,
    bitslip                 => BITSLIP_p          ,
    use_phase_detector      => '1'                ,
    
    datain_p                => SDATAP             ,
    datain_n                => SDATAN             ,
    
    data_out                => RAWBYTE
  );
  
  process (PCLK02x)
  begin
    if (RESET = '1') then
      BITSLIP_d   <= '0';
    elsif (PCLK02x'event and PCLK02x = '1') then
      BITSLIP_d   <= BITSLIP;
    end if;
  end process;

  process (PCLK02x)
  begin
    if (RESET = '1') then
      BITSLIP_p   <= '0';
    elsif (PCLK02x'event and PCLK02x = '1') then
      BITSLIP_p   <= (not BITSLIP_d) and BITSLIP;
    end if;
  end process;

  -- BitSlip Control
  BITSLIP_CTRL : phsaligner
  port map (
    rst                     => RESET              ,
    clk                     => PCLK01x            ,
    
    training                => TRAINING           ,
    sdata                   => RAWWORD            ,
    
    bitslip                 => BITSLIP            ,
    flipgear                => FLIPGEAR           ,
    psaligned               => ALIGNED_o
  );
  

  -- GearBox
  RX_TOGGLE <= RX_TOGGLE_q xor FLIPGEAR_s;
  
  process (PCLK02x)
  begin
    if (RESET = '1') then
      FLIPGEAR_s  <= '0';
    elsif (PCLK02x'event and PCLK02x = '1') then
      FLIPGEAR_s  <= FLIPGEAR;
    end if;
  end process;

  process (PCLK02x)
  begin
    if (RESET = '1') then
      RX_TOGGLE_q <= '0';
    elsif (PCLK02x'event and PCLK02x = '1') then
      RX_TOGGLE_q <= not RX_TOGGLE_q;
    end if;
  end process;
  
  process (PCLK02x)
  begin
    if (RESET = '1') then
      RAWBYTE_q   <= (others => '0');
    elsif (PCLK02x'event and PCLK02x = '1') then
      RAWBYTE_q   <= RAWBYTE;
    end if;
  end process;
  
  process (PCLK02x)
  begin
    if (RESET = '1') then
      RAWWORD   <= (others => '0');
    elsif (PCLK02x'event and PCLK02x = '1') then
      if (RX_TOGGLE = '1') then
        RAWWORD   <= RAWBYTE_q & RAWBYTE;
      end if;
    end if;
  end process;
  
  -- FIFO18
  blockramgen_s6 : FIFO18_s6
  port map (
    rst                     => RESET              ,
    wr_clk                  => PCLK01x            ,
    rd_clk                  => CLOCK              ,
    din                     => FIFO_DI            ,
    wr_en                   => FIFO_EN_d1         ,
    rd_en                   => FIFO_RDEN          ,
    dout                    => FIFO_DO            ,
    full                    => FIFO_FULL          ,
    empty                   => FIFO_EMPTY
  );
  
  FIFO_DI(15 downto 10) <= (others => '0');
  FIFO_DI( 9 downto  0) <= RAWWORD;
  FIFO_DATAOUT          <= FIFO_DO( 9 downto  0);
  
  process (PCLK01x)
  begin
    if (RESET = '1') then
      FIFO_EN_d0    <= '0';
      FIFO_EN_d1    <= '0';
    elsif (PCLK01x'event and PCLK01x = '1') then
      FIFO_EN_d0    <= FIFO_EN;
      FIFO_EN_d1    <= FIFO_EN_d0;
    end if;
  end process;
  
end rtl;