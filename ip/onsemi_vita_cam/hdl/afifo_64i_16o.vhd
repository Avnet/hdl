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

entity afifo_64i_16o is
  generic
  (
    C_FAMILY                  : string               := "zynq"
  );
  port
  (
      rst                     : IN std_logic;

      wr_clk                  : IN std_logic;
      wr_en                   : IN std_logic;
      din                     : IN std_logic_vector(63 downto 0);

      rd_clk                  : IN std_logic;
      rd_en                   : IN std_logic;
      dout                    : OUT std_logic_vector(15 downto 0);

      empty                   : OUT std_logic;
      full                    : OUT std_logic
  );
end entity afifo_64i_16o;

architecture rtl of afifo_64i_16o is

  signal demux_din            : std_logic_vector(63 downto 0);

begin

  -- need to re-order input vector for proper order at output
  demux_din(63 downto 48)  <= din(15 downto  0);
  demux_din(47 downto 32)  <= din(31 downto 16);
  demux_din(31 downto 16)  <= din(47 downto 32);
  demux_din(15 downto  0)  <= din(63 downto 48);


  -- xpm_fifo_async: Asynchronous FIFO
  -- Xilinx Parameterized Macro, Version 2016.4
  afifo_64i_16o_l : xpm_fifo_async
  generic map (

    FIFO_MEMORY_TYPE        => "block",          --string; "auto", "block", or "distributed";
    ECC_MODE                => "no_ecc",         --string; "no_ecc" or "en_ecc";
    RELATED_CLOCKS          => 0,                --positive integer; 0 or 1
    FIFO_WRITE_DEPTH        => 4096,             --positive integer
    WRITE_DATA_WIDTH        => 64,               --positive integer
    WR_DATA_COUNT_WIDTH     => 10,               --positive integer
    PROG_FULL_THRESH        => 2048,             --positive integer
    FULL_RESET_VALUE        => 0,                --positive integer; 0 or 1;
    READ_MODE               => "fwft",           --string; "std" (standard) or "fwft" (first-word-fall-through);
    FIFO_READ_LATENCY       => 1,                --positive integer;
    READ_DATA_WIDTH         => 16,               --positive integer
    RD_DATA_COUNT_WIDTH     => 10,               --positive integer
    PROG_EMPTY_THRESH       => 2048,             --positive integer
    DOUT_RESET_VALUE        => "0",              --string
    CDC_SYNC_STAGES         => 2,                --positive integer
    WAKEUP_TIME             => 0                 --positive integer; 0 or 2;
  )
  port map (
    sleep            => '0',
    rst              => rst,
    wr_clk           => wr_clk,
    wr_en            => wr_en,
    din              => demux_din, --din,
    full             => full,
    overflow         => open,
    wr_rst_busy      => open,
    rd_clk           => rd_clk,
    rd_en            => rd_en,
    dout             => dout,
    empty            => empty,
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

end rtl;
