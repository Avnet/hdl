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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Library xpm;
use xpm.vcomponents.all;

entity pulse_regen is
  generic
  (
    C_FAMILY                  : string               := "zynq"
  );
  port
  (
      rst                     : IN std_logic;

      clk1                    : IN std_logic;
      pulse1                  : IN std_logic;

      clk2                    : IN std_logic;
      pulse2                  : OUT std_logic
  );

end entity pulse_regen;

architecture rtl of pulse_regen is

  signal rd_empty : std_logic;

begin

  -- xpm_fifo_async: Asynchronous FIFO
  -- Xilinx Parameterized Macro, Version 2016.4
  pulse_regen_l : xpm_fifo_async
  generic map (

    FIFO_MEMORY_TYPE        => "auto",           --string; "auto", "block", or "distributed";
    ECC_MODE                => "no_ecc",         --string; "no_ecc" or "en_ecc";
    RELATED_CLOCKS          => 0,                --positive integer; 0 or 1
    FIFO_WRITE_DEPTH        => 16,               --positive integer
    WRITE_DATA_WIDTH        => 1,                --positive integer
    WR_DATA_COUNT_WIDTH     => 4,                --positive integer
    PROG_FULL_THRESH        => 8,                --positive integer
    FULL_RESET_VALUE        => 0,                --positive integer; 0 or 1;
    READ_MODE               => "fwft",           --string; "std" (standard) or "fwft" (first-word-fall-through);
    FIFO_READ_LATENCY       => 1,                --positive integer;
    READ_DATA_WIDTH         => 1,                --positive integer
    RD_DATA_COUNT_WIDTH     => 4,                --positive integer
    PROG_EMPTY_THRESH       => 8,                --positive integer
    DOUT_RESET_VALUE        => "0",              --string
    CDC_SYNC_STAGES         => 2,                --positive integer
    WAKEUP_TIME             => 0                 --positive integer; 0 or 2;
  )
  port map (
    sleep            => '0',
    rst              => rst,
    wr_clk           => clk1,
    wr_en            => pulse1,
    din              => (others => '1'),
    full             => open,
    overflow         => open,
    wr_rst_busy      => open,
    rd_clk           => clk2,
    rd_en            => '1',
    dout             => open,
    empty            => rd_empty,
    underflow        => open,
    rd_rst_busy      => open,
    prog_full        => open,
    wr_data_count    => open,
    prog_empty       => open,
    rd_data_count    => open,
    injectsbiterr    => '0',
    injectdbiterr    => '0',
    sbiterr          => open,
    dbiterr          => open
  );

  pulse2 <= not rd_empty;
   
end rtl;
