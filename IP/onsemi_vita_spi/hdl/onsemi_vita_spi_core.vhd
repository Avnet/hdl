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
-- Create Date:         Sep 15, 2011
-- Design Name:         ON Semiconductor VITA SPI controller
-- Module Name:         onsemi_vita_cam_core.vhd
-- Project Name:        ON Semiconductor VITA SPI controller
-- Target Devices:      Zynq-7000
-- Avnet Boards:        FMC-IMAGEON + VITA-2000, EMBV + PYTYHON-1300-C
--
-- Tool versions:       2014.4
--
-- Description:         ON Semiconductor VITA SPI controller - Core Logic.
--
-- Dependencies:        
--
-- Revision:            Sep 15, 2011: 1.00 Initial version:
--                                         - VITA SPI controller 
--                      Sep 22, 2011: 1.01 Added:
--                                         - ISERDES interface
--                      Sep 28, 2011: 1.02 Added:
--                                         - sync channel decoder
--                                         - crc checker
--                                         - data remapper
--                      Oct 20, 2011: 1.03 Modify:
--                                         - iserdes (use BUFR)
--                      Oct 21, 2011: 1.04 Added:
--                                         - fpn prnu correction
--                      Nov 03, 2011: 1.05 Added:
--                                         - trigger generator
--                      Dec 19, 2011: 1.06 Modified:
--                                         - port to Kintex-7
--                      Jan 12, 2012: 1.07 Added:
--                                         - new fsync output port
--                                         Modify:
--                                         - syncgen
--                      Feb 06, 2012: 1.08 Modify:
--                                         - triggergenerator
--                                           (new version with debounce logic)
--                                         - new C_XSVI_DIRECT_OUTPUT option
--                      Feb 22, 2012: 1.09 Modified
--                                         - port to Zynq
--                                         - new C_XSVI_USE_SYNCGEN option
--                      May 28, 2012: 1.11 Added:
--                                         - host_triggen_cnt_update
--                                           (for simultaneous update of high/low values)
--                                         - host_triggen_gen_polarity
--                      Jun 01, 2012: 1.12 Modify:
--                                         - Move syncgen after demux_fifo
--                                         - Increase size of demux_fifo
--                                           (to tolerate jitter in video timing from sensor)
--                                         - Add programmable delay on framestart for syncgen
--                      Jul 31, 2012: 1.13 Modify:
--                                         - define clk200, clk, clk4x with SIGIS = CLK
--                                         - define reset with SIGIS = RST
--                                         - port to Spartan-6
--                      Dec 05, 2013: 2.0  Vivado 2013.3 port
--                                         - replace xsvi_ with video_
--                                         - add generic for width of IO_VITA_DATA
--                                         - remove generic USE_SYNCGEN (unused)
--                      Dec 24, 2013: 2.1  - remove debug_host debug port
--                                         - add debug_syncgen debug port
--                      Jun 18, 2014: 2.3  - add C_INCLUDE_BLC parameter to optionnally
--                                           remove correct_column_fpn_prnu_dsp48e module
--                                         - add C_INCLUDE_MONITOR to optionnally
--                                           remove monitor logic inside syncchanneldecoder
------------------------------------------------------------------
--                      Jan 26, 2015: 3.1  - Rename to onsemi_vita_cam_*
--                                         - Modifications for linux device driver
--                                            - move SPI to seperate core
--                                            - remove reset pin (will be implemented with GPIO
--
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity onsemi_vita_spi_core is
  Generic
  (
    C_FAMILY                       : string  := "zynq"
  );
  Port
  (
    oe                             : in  std_logic;
    -- HOST Interface - SPI
    host_spi_clk                   : in  std_logic;
    host_spi_reset                 : in  std_logic;
    host_spi_timing                : in  std_logic_vector(15 downto 0);
    host_spi_status_busy           : out std_logic;
    host_spi_status_error          : out std_logic;
    host_spi_txfifo_clk            : in  std_logic;                          	
    host_spi_txfifo_wen            : in  std_logic;                              
    host_spi_txfifo_din            : in  std_logic_vector(31 downto 0);         
    host_spi_txfifo_full           : out std_logic; 
    host_spi_rxfifo_clk            : in  std_logic;                          	
    host_spi_rxfifo_ren            : in  std_logic;                              
    host_spi_rxfifo_dout           : out std_logic_vector(31 downto 0);         
    host_spi_rxfifo_empty          : out std_logic; 
    -- I/O pins
    io_vita_spi_sclk               : out std_logic;
    io_vita_spi_ssel_n             : out std_logic;
    io_vita_spi_mosi               : out std_logic;
    io_vita_spi_miso               : in  std_logic;
    -- Debug Ports
    debug_spi_o                    : out std_logic_vector( 95 downto 0)
  );
end onsemi_vita_spi_core;

architecture rtl of onsemi_vita_spi_core is

  --
  -- VITA SPI Controller
  --

  component spi_top is
  generic
  (     
    gSIMULATION                    : integer := 0;    
    gSysClkSpeed                   : integer := 50;
        
    --LowLevel SPI settings           
    gSpiClkSpeed                   : integer := 1000;  -- SPI Clock Speed in kHz
    gUseFixedSpeed                 : integer := 1;     -- 0: use timing input 
                                                       -- 1: use SysClkSpeed/SpiClkSpeed generics
        
    gDATA_WIDTH                    : integer := 26; 
    gTxMSB_FIRST                   : integer := 1;
    gRxMSB_FIRST                   : integer := 1;
                
    gSCLK_POLARITY                 : std_logic := '0'; --'0': idle low, '1': idle high
    gCS_POLARITY                   : std_logic := '1'; --'0': active high, '1': active low
    gEN_POLARITY                   : std_logic := '0'; --'0': normal, '1': invert
    gMOSI_POLARITY                 : std_logic := '0'; --'0': normal, '1': invert
    gMISO_POLARITY                 : std_logic := '0'; --'0': normal, '1': invert
        
    gMISO_SAMPLE                   : std_logic := '1'; --'0': sample on rising edge
                                                       --'1': sample on falling edge
    gMOSI_CLK                      : std_logic := '0'; --'0': clock out on rising edge
                                                       --'1': clock out on falling edge
         
    --Seq SPI settings                                                                               
    gSyncTriggerWidth              : integer;          -- min 1, max 15  
    gRWbitposition                 : integer := 0      --seen from LSB                              
  );       
  Port	
  (
    CLOCK                          : in  std_logic;	
    RESET                          : in  std_logic;                                             
    TIMING                         : in  std_logic_vector(15 downto 0);
        
    BUSY                           : out	std_logic;
                                                        
    --synchro signals 		
    synctriggers                   : in  std_logic_vector(gSyncTriggerWidth-1 downto 0); 
    sync1_select                   : in  std_logic_vector(3 downto 0);	
    sync2_select                   : in  std_logic_vector(3 downto 0);	
		    							                                
    -- Fifo signals    
    -- read fifo interface (SPI write path/SPI read address path)                                                           
    APP_RDFIFO_CLK                 : out std_logic;                          	
    APP_RDFIFO_EN	                 : out std_logic;                              
    APP_RDFIFO_DATA_OUT            : in  std_logic_vector( 31 downto 0);         
    APP_RDFIFO_EMPTY   	           : in  std_logic; 
        
    -- write fifo interface (SPI read data path)
    APP_WRFIFO_CLK                 : out std_logic;                          	
    APP_WRFIFO_EN                  : out std_logic;                              
    APP_WRFIFO_DATA_IN             : out std_logic_vector( 31 downto 0);         
    APP_WRFIFO_FULL   	           : in  std_logic; 
        
    ERROR                          : out std_logic; 

    --
    -- SPI
    --
    SCLK                           : out std_logic;
    MOSI                           : out std_logic;
    MISO                           : in  std_logic;
    CS                             : out std_logic;
    EN                             : out std_logic  	  		
  );		
  end component spi_top;

  signal vita_spi_status_busy      : std_logic;
  signal vita_spi_status_error     : std_logic;

  --
  -- VITA SPI FIFOs
  --

  component afifo_32 is
    generic
    (
      C_FAMILY                     : string               := "virtex6"
    );
    port
    (
      rst                          : IN std_logic;

      wr_clk                       : IN std_logic;
      wr_en                        : IN std_logic;
      din                          : IN std_logic_VECTOR(31 downto 0);

      rd_clk                       : IN std_logic;
      rd_en                        : IN std_logic;
      dout                         : OUT std_logic_VECTOR(31 downto 0);

      empty                        : OUT std_logic;
      full                         : OUT std_logic
    );
  end component afifo_32;
  
  signal vita_spi_txfifo_clk       : std_logic;
  signal vita_spi_txfifo_ren       : std_logic;
  signal vita_spi_txfifo_dout      : std_logic_vector(31 downto 0);  
  signal vita_spi_txfifo_empty     : std_logic;
  
  signal vita_spi_rxfifo_clk       : std_logic;
  signal vita_spi_rxfifo_wen       : std_logic;
  signal vita_spi_rxfifo_din       : std_logic_vector(31 downto 0);  
  signal vita_spi_rxfifo_full      : std_logic;

  --
  -- I/O registers & buffers
  --

  signal oe_n                      : std_logic;

  signal vita_spi_sclk_o           : std_logic;
  signal vita_spi_ssel_n_o         : std_logic;
  signal vita_spi_mosi_o           : std_logic;

  signal vita_spi_sclk_t           : std_logic;
  signal vita_spi_ssel_n_t         : std_logic;
  signal vita_spi_mosi_t           : std_logic;

begin

  --
  -- SPI Controller
  --

  vita_spi: spi_top 
  generic map
  (     
    gSIMULATION                    => 0,     --gSIMULATION,  
    gSysClkSpeed                   => 50,    -- 50MHz  --gSysClkSpeed,
        
    --LowLevel SPI settings           
    gSpiClkSpeed                   => 1000,  -- 1000KHz (or 1MHz)
    gUseFixedSpeed                 => 0, 
        
    gDATA_WIDTH                    => 26, 
    gTxMSB_FIRST                   => 1,
    gRxMSB_FIRST                   => 1,
                
    gSCLK_POLARITY                 => '0', 
    gCS_POLARITY                   => '1', 
    gEN_POLARITY                   => '0', 
    gMOSI_POLARITY                 => '0', 
    gMISO_POLARITY                 => '0', 
       
    gMISO_SAMPLE                   => '0', 
    gMOSI_CLK                      => '0',
         
    --Seq SPI settings                                                                               
    gSyncTriggerWidth              => 10,
    gRWbitposition                 => 16                     
  )  
  port map           
  (
    CLOCK                          => host_spi_clk,  
    RESET                          => host_spi_reset,  
    TIMING                         => host_spi_timing, --TIMING,
        
    BUSY                           => vita_spi_status_busy,           
                               
    --synchro signals                             
    synctriggers                   => (others => '0'), --synctriggers,  
    sync1_select                   => (others => '0'), --sync1_select,
    sync2_select                   => (others => '0'), --sync2_select,
                                                                                                                                                                             
    -- Fifo signals    
    -- read fifo interface (SPI write path/SPI read address path)                                                           
    APP_RDFIFO_CLK                 => vita_spi_txfifo_clk,         
    APP_RDFIFO_EN                  => vita_spi_txfifo_ren,     
    APP_RDFIFO_DATA_OUT            => vita_spi_txfifo_dout,     
    APP_RDFIFO_EMPTY               => vita_spi_txfifo_empty,
        
    -- write fifo interface (SPI read data path)
    APP_WRFIFO_CLK                 => vita_spi_rxfifo_clk,   
    APP_WRFIFO_EN                  => vita_spi_rxfifo_wen,     
    APP_WRFIFO_DATA_IN             => vita_spi_rxfifo_din,     
    APP_WRFIFO_FULL                => vita_spi_rxfifo_full,
        
    ERROR                          => vita_spi_status_error,         

    --
    -- SPI
    --
    SCLK                           => vita_spi_sclk_o,  
    MOSI                           => vita_spi_mosi_o,          
    MISO                           => io_vita_spi_miso, 
    CS                             => vita_spi_ssel_n_o, 
    EN                             => open                                                 
  );

  host_spi_status_busy  <= vita_spi_status_busy;
  host_spi_status_error <= vita_spi_status_error;  
  
  --
  -- VITA SPI FIFOs
  --

  vita_spi_txfifo_l : afifo_32
  generic map
  (
    C_FAMILY                     => C_FAMILY
  )
  port map
  (
    rst                          => host_spi_reset,

    wr_clk                       => host_spi_txfifo_clk,
    wr_en                        => host_spi_txfifo_wen,
    din                          => host_spi_txfifo_din,

    rd_clk                       => vita_spi_txfifo_clk,
    rd_en                        => vita_spi_txfifo_ren,
    dout                         => vita_spi_txfifo_dout,

    empty                        => vita_spi_txfifo_empty,
    full                         => host_spi_txfifo_full
  );

  vita_spi_rxfifo_l : afifo_32
  generic map
  (
    C_FAMILY                     => C_FAMILY
  )
  port map
  (
    rst                          => host_spi_reset,

    wr_clk                       => vita_spi_rxfifo_clk,
    wr_en                        => vita_spi_rxfifo_wen,
    din                          => vita_spi_rxfifo_din,

    rd_clk                       => host_spi_rxfifo_clk,
    rd_en                        => host_spi_rxfifo_ren,
    dout                         => host_spi_rxfifo_dout,

    empty                        => host_spi_rxfifo_empty,
    full                         => vita_spi_rxfifo_full
  );
  
  --
  -- I/O registers & buffers
  --

  oe_n  <= not oe;

   --io_oregs2_l : process (host_spi_clk)
   --begin
   --   if Rising_Edge(host_spi_clk) then
         vita_spi_sclk_t   <= oe_n;
         vita_spi_ssel_n_t <= oe_n;
         vita_spi_mosi_t   <= oe_n;
   --   end if;
   --end process;


   --
   -- Tri-stateable outputs
   --    Can be used to disable outputs to FMC connector
   --    until FMC module is correctly identified.
   -- 

   OBUFT_vita_spi_sclk : OBUFT
   port map (
      O => io_vita_spi_sclk,
      I => vita_spi_sclk_o,
      T => vita_spi_sclk_t
   );

   OBUFT_vita_spi_ssel_n : OBUFT
   port map (
      O => io_vita_spi_ssel_n,
      I => vita_spi_ssel_n_o,
      T => vita_spi_ssel_n_t
   );

   OBUFT_vita_spi_mosi : OBUFT
   port map (
      O => io_vita_spi_mosi,
      I => vita_spi_mosi_o,
      T => vita_spi_mosi_t
   );

   --
   -- Debug Ports
   --    Can be used to connect to ChipScope for debugging.
   --    Having a port makes these signals accessible for debug via EDK.
   -- 

   debug_spi_l : process (host_spi_clk)
   begin
      if Rising_Edge(host_spi_clk) then
         debug_spi_o(15 downto  0) <= host_spi_timing;
         debug_spi_o(          16) <= vita_spi_sclk_o;
         debug_spi_o(          17) <= vita_spi_ssel_n_o;
         debug_spi_o(          18) <= vita_spi_mosi_o;
         debug_spi_o(          19) <= io_vita_spi_miso;
         debug_spi_o(          20) <= '0';
         debug_spi_o(          21) <= host_spi_txfifo_wen;
         debug_spi_o(          22) <= host_spi_rxfifo_ren;
         debug_spi_o(          23) <= '0';
         debug_spi_o(          24) <= '0';
         debug_spi_o(          25) <= host_spi_reset;
         debug_spi_o(          26) <= vita_spi_status_busy;
         debug_spi_o(          27) <= vita_spi_status_error;
         debug_spi_o(          28) <= vita_spi_rxfifo_wen;
         debug_spi_o(          29) <= vita_spi_txfifo_ren;
         debug_spi_o(          30) <= vita_spi_rxfifo_full;
         debug_spi_o(          31) <= vita_spi_txfifo_empty;
         debug_spi_o(63 downto 32) <= vita_spi_rxfifo_din;
         debug_spi_o(95 downto 64) <= vita_spi_txfifo_dout;
      end if;
   end process;

end rtl;
