-------------------------------------------------------------------------------
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
-- Module Name:         iserdes_interface_s6.vhd
-- Project Name:        FMC-IMAGEON
-- Target Devices:      Spartan 6
-- Avnet Boards:        FMC-IMAGEON
-- Tool versions:       ISE 13.4
-- Description:         Spartan 6 10:1 iSerDes Top
--
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library work;
use work.all;

library unisim;
use unisim.vcomponents.all;

entity iserdes_interface_s6 is
port  (
      CLOCK               : in    std_logic;
      RESET               : in    std_logic;
      
      -- serdes clock, directly connected to bondpads
      SCLKP               : in    std_logic;
      SCLKN               : in    std_logic;

      -- serdes data, directly connected to bondpads
      SDATAP              : in    std_logic_vector(4 downto 0);
      SDATAN              : in    std_logic_vector(4 downto 0);
      
      -- control
      ALIGN_START         : in    std_logic;
      FIFO_EN             : in    std_logic;
      TRAINING            : in    std_logic_vector(9 downto 0);
      MANUAL_TAP          : in    std_logic_vector(9 downto 0);

      -- status
      PLL_LOCKED          : out   std_logic;
      ALIGN_BUSY          : out   std_logic;
      ALIGNED             : out   std_logic;
      
      -- parallel data out
      FIFO_RDEN           : in    std_logic;
      FIFO_EMPTY          : out   std_logic;
      FIFO_DATAOUT        : out   std_logic_vector(49 downto 0)
      );
end iserdes_interface_s6;

architecture rtl of iserdes_interface_s6 is

component iserdes_datadeser_s6 is
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
end component;

signal RXCLKINT               : std_logic;
signal RXCLK                  : std_logic;

signal PLL_CLKFBOUT           : std_logic;
signal PLL_CLKOUT0            : std_logic;
signal PLL_CLKOUT1            : std_logic;
signal PLL_CLKOUT2            : std_logic;
signal PLL_LOCKED_i           : std_logic;

signal PCLK01x                : std_logic;
signal PCLK02x                : std_logic;
signal PCLK10x                : std_logic;
signal BUFPLL_LOCKED          : std_logic;

signal SERDES_STROBE          : std_logic;
signal SERDES_RESET           : std_logic;

signal ALIGN_BUSY_i           : std_logic_vector(4 downto 0);
signal ALIGNED_i              : std_logic_vector(4 downto 0);

signal FIFO_EMPTY_i           : std_logic_vector(4 downto 0);



begin

  -- Signal Assignment
  PLL_LOCKED                <= PLL_LOCKED_i;
  SERDES_RESET              <= not BUFPLL_LOCKED;

  -- Electrical I/O Interface
  IBUFDS_RXCLK : IBUFDS
  generic map (
    IOSTANDARD              => "TMDS_33"          ,
    DIFF_TERM               => FALSE
  )
  port map (
    I                       => SCLKP              ,
    IB                      => SCLKN              ,
    O                       => RXCLKINT
  );
  
  BUFIO2_RXCLK : BUFIO2
  generic map (
    DIVIDE_BYPASS           => TRUE               ,
    DIVIDE                  => 1
  )
  port map (
    I                       => RXCLKINT           ,
    SERDESSTROBE            => open               ,
    IOCLK                   => open               ,
    DIVCLK                  => RXCLK
  );
  
  -- PLL
  PLL_BASE_ISERDES : PLL_BASE
  generic map (
    CLKIN_PERIOD            => 5.0                ,
    CLKFBOUT_MULT           => 2                  ,         -- DDR CLK
    CLKOUT0_DIVIDE          => 1                  ,         -- 2x DDR CLK 10x CLKIN
    CLKOUT1_DIVIDE          => 10                 ,         -- 5/ DDR CLK 1x CLKIN
    CLKOUT2_DIVIDE          => 5                  ,         -- 2.5/ DDR CLK 2x CLKIN
    COMPENSATION            => "INTERNAL"
  )
  port map
  (
    CLKFBOUT                => PLL_CLKFBOUT       ,
    CLKOUT0                 => PLL_CLKOUT0        ,
    CLKOUT1                 => PLL_CLKOUT1        ,
    CLKOUT2                 => PLL_CLKOUT2        ,
    CLKOUT3                 => open               ,
    CLKOUT4                 => open               ,
    CLKOUT5                 => open               ,
    LOCKED                  => PLL_LOCKED_i       ,
    CLKFBIN                 => PLL_CLKFBOUT       ,
    CLKIN                   => RXCLK              ,
    RST                     => RESET
  );
    
  -- Clock Buffers
  BUFG_PCLK01x : BUFG
  port map (
    I                       => PLL_CLKOUT1        ,
    O                       => PCLK01x
  );
  
  BUFG_PCLK02x : BUFG
  port map (
    I                       => PLL_CLKOUT2        ,
    O                       => PCLK02x
  );
  
  BUFPLL_PCLK10x : BUFPLL
  generic map (
    DIVIDE                  => 5
  )
  port map (
    PLLIN                   => PLL_CLKOUT0        ,
    GCLK                    => PCLK02x            ,
    LOCKED                  => PLL_LOCKED_i       ,
    IOCLK                   => PCLK10x            ,
    SERDESSTROBE            => SERDES_STROBE      ,
    LOCK                    => BUFPLL_LOCKED
  );
  
  SERDESPATHGEN: for i in 0 to 4 generate

    ISERDES_DATADESER_PATH : iserdes_datadeser_s6
    port map (
      RESET                   => SERDES_RESET       ,
      CLOCK                   => CLOCK              ,
      
      PCLK01x                 => PCLK01x            ,
      PCLK02x                 => PCLK02x            ,
      PCLK10x                 => PCLK10x            ,
      STROBE                  => SERDES_STROBE      ,
      
      SDATAP                  => SDATAP(i)          ,
      SDATAN                  => SDATAN(i)          ,
      
      ALIGN_START             => ALIGN_START        ,
      FIFO_EN                 => FIFO_EN            ,
      TRAINING                => TRAINING           ,
      MANUAL_TAP              => MANUAL_TAP         ,
      
      ALIGN_BUSY              => ALIGN_BUSY_i(i)    ,
      ALIGNED                 => ALIGNED_i(i)       ,
      
      FIFO_RDEN               => FIFO_RDEN          ,
      FIFO_EMPTY              => FIFO_EMPTY_i(i)    ,
      FIFO_DATAOUT            => FIFO_DATAOUT(((i * 10) + 9) downto (i * 10))
    );

  end generate;
  
  process (ALIGN_BUSY_i)
  variable TEMP : std_logic;
  begin
    TEMP := '0';

    for i in ALIGN_BUSY_i'low to ALIGN_BUSY_i'high loop
      TEMP := TEMP or ALIGN_BUSY_i(i);
    end loop;

    ALIGN_BUSY  <= TEMP;
  end process;

  process (ALIGNED_i)
  variable TEMP : std_logic;
  begin
    TEMP := '1';

    for i in ALIGNED_i'low to ALIGNED_i'high loop
      TEMP := TEMP and ALIGNED_i(i);
    end loop;

    ALIGNED  <= TEMP;
  end process;
  
  process (FIFO_EMPTY_i)
  variable TEMP : std_logic;
  begin
    TEMP := '0';

    for i in FIFO_EMPTY_i'low to FIFO_EMPTY_i'high loop
      TEMP := TEMP or FIFO_EMPTY_i(i);
    end loop;

    FIFO_EMPTY  <= TEMP;
  end process;

end rtl;