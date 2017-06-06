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
-- Design Name:         ON Semiconductor VITA camera receiver
-- Module Name:         onsemi_vita_cam_core.vhd
-- Project Name:        ON Semiconductor VITA camera receiver
-- Target Devices:      Zynq-7000
-- Avnet Boards:        FMC-IMAGEON + VITA-2000, EMBV + PYTYHON-1300-C
--
-- Tool versions:       2014.4
--
-- Description:         ON Semiconductor VITA camera receiver - Core Logic.
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

entity onsemi_vita_cam_core is
  Generic
  (
    C_VIDEO_DATA_WIDTH             : integer := 10;
    C_VIDEO_DIRECT_OUTPUT          : integer := 0;
--  C_VIDEO_USE_SYNCGEN            : integer := 1;
    C_IO_VITA_DATA_WIDTH           : integer := 4;
    C_INCLUDE_BLC                  : integer := 0;
    C_INCLUDE_MONITOR              : integer := 0;
    C_FAMILY                       : string  := "zynq"
  );
  Port
  (
    clk200                         : in  std_logic;
    clk                            : in  std_logic;
    clk4x                          : in  std_logic;
    reset                          : in  std_logic;
    oe                             : in  std_logic;
    -- HOST Interface - VITA
    host_vita_reset                : in  std_logic;
    -- HOST Interface - ISERDES
    host_iserdes_reset             : in  std_logic;
    host_iserdes_auto_align        : in  std_logic;
    host_iserdes_align_start       : in  std_logic;
    host_iserdes_fifo_enable       : in  std_logic;
    host_iserdes_manual_tap        : in  std_logic_vector(9 downto 0);
    host_iserdes_training          : in  std_logic_vector(9 downto 0);
    host_iserdes_clk_ready         : out std_logic;
    host_iserdes_clk_status        : out std_logic_vector(15 downto 0);
    host_iserdes_align_busy        : out std_logic;
    host_iserdes_aligned           : out std_logic;
    -- HOST Interface - Sync Channel Decoder
    host_decoder_reset             : in  std_logic;
    host_decoder_enable            : in  std_logic;
    host_decoder_startoddeven      : in  std_logic_vector(31 downto 0);
    host_decoder_code_ls           : in  std_logic_vector(9 downto 0);
    host_decoder_code_le           : in  std_logic_vector(9 downto 0);
    host_decoder_code_fs           : in  std_logic_vector(9 downto 0);
    host_decoder_code_fe           : in  std_logic_vector(9 downto 0);
    host_decoder_code_bl           : in  std_logic_vector(9 downto 0);
    host_decoder_code_img          : in  std_logic_vector(9 downto 0);
    host_decoder_code_tr           : in  std_logic_vector(9 downto 0);
    host_decoder_code_crc          : in  std_logic_vector(9 downto 0);
    host_decoder_frame_start       : out std_logic;
    host_decoder_cnt_black_lines   : out std_logic_vector(31 downto 0);
    host_decoder_cnt_image_lines   : out std_logic_vector(31 downto 0);
    host_decoder_cnt_black_pixels  : out std_logic_vector(31 downto 0);
    host_decoder_cnt_image_pixels  : out std_logic_vector(31 downto 0);
    host_decoder_cnt_frames        : out std_logic_vector(31 downto 0);
    host_decoder_cnt_windows       : out std_logic_vector(31 downto 0);
    host_decoder_cnt_clocks        : out std_logic_vector(31 downto 0);
    host_decoder_cnt_start_lines   : out std_logic_vector(31 downto 0);
    host_decoder_cnt_end_lines     : out std_logic_vector(31 downto 0);
    host_decoder_cnt_monitor0high  : out std_logic_vector(31 downto 0);
    host_decoder_cnt_monitor0low   : out std_logic_vector(31 downto 0);
    host_decoder_cnt_monitor1high  : out std_logic_vector(31 downto 0);
    host_decoder_cnt_monitor1low   : out std_logic_vector(31 downto 0);
    -- HOST Interface - CRC Checker
    host_crc_reset                 : in  std_logic;
    host_crc_initvalue             : in  std_logic;
    host_crc_status                : out std_logic_vector(31 downto 0);
    -- HOST Interface - Data Channel Remapper
    host_remapper_write_cfg        : in  std_logic_vector(2 downto 0);
    host_remapper_mode             : in  std_logic_vector(2 downto 0);
    -- HOST Interface - Trigger Generator
    host_triggen_enable            : in  std_logic_vector(2 downto 0);
    host_triggen_sync2readout      : in  std_logic_vector(2 downto 0);
    host_triggen_readouttrigger    : in  std_logic;
    host_triggen_default_freq      : in  std_logic_vector(31 downto 0);
    host_triggen_cnt_trigger0high  : in  std_logic_vector(31 downto 0);
    host_triggen_cnt_trigger0low   : in  std_logic_vector(31 downto 0);
    host_triggen_cnt_trigger1high  : in  std_logic_vector(31 downto 0);
    host_triggen_cnt_trigger1low   : in  std_logic_vector(31 downto 0);
    host_triggen_cnt_trigger2high  : in  std_logic_vector(31 downto 0);
    host_triggen_cnt_trigger2low   : in  std_logic_vector(31 downto 0);
    host_triggen_ext_debounce      : in  std_logic_vector(31 downto 0);
    host_triggen_ext_polarity      : in  std_logic;
    host_triggen_gen_polarity      : in  std_logic_vector(2 downto 0);
    -- HOST Interface - FPN/PRNU Correction
    host_fpn_prnu_values           : in  std_logic_vector((16*16)-1 downto 0);
    -- HOST Interface - Sync Generator
    host_syncgen_delay             : in  std_logic_vector(15 downto 0);
    host_syncgen_hactive           : in  std_logic_vector(15 downto 0);
    host_syncgen_hfporch           : in  std_logic_vector(15 downto 0);
    host_syncgen_hsync             : in  std_logic_vector(15 downto 0);
    host_syncgen_hbporch           : in  std_logic_vector(15 downto 0);
    host_syncgen_vactive           : in  std_logic_vector(15 downto 0);
    host_syncgen_vfporch           : in  std_logic_vector(15 downto 0);
    host_syncgen_vsync             : in  std_logic_vector(15 downto 0);
    host_syncgen_vbporch           : in  std_logic_vector(15 downto 0);
    -- I/O pins
    io_vita_clk_pll                : out std_logic;
    io_vita_reset_n                : out std_logic;
    io_vita_trigger                : out std_logic_vector(2 downto 0);
    io_vita_monitor                : in  std_logic_vector(1 downto 0);
    io_vita_clk_out_p              : in  std_logic;
    io_vita_clk_out_n              : in  std_logic;
    io_vita_sync_p                 : in  std_logic;
    io_vita_sync_n                 : in  std_logic;
    io_vita_data_p                 : in  std_logic_vector(C_IO_VITA_DATA_WIDTH-1 downto 0);
    io_vita_data_n                 : in  std_logic_vector(C_IO_VITA_DATA_WIDTH-1 downto 0);
    -- Trigger Port
    trigger1                       : in  std_logic;
    -- Frame Sync Port
    fsync                          : out std_logic;
    -- Video Port
    video_vsync_o                  : out  std_logic;
    video_hsync_o                  : out  std_logic;
    video_vblank_o                 : out  std_logic;
    video_hblank_o                 : out  std_logic;
    video_active_video_o           : out  std_logic;
    video_data_o                   : out  std_logic_vector((C_VIDEO_DATA_WIDTH-1) downto 0);
    -- Debug Ports
    debug_iserdes_o                : out std_logic_vector(229 downto 0);
    debug_decoder_o                : out std_logic_vector(186 downto 0);
    debug_crc_o                    : out std_logic_vector( 87 downto 0);
    debug_triggen_o                : out std_logic_vector(  9 downto 0);
    debug_syncgen_o                : out std_logic_vector( 37 downto 0);
    debug_video_o                  : out std_logic_vector( 31 downto 0)
  );
end onsemi_vita_cam_core;

architecture rtl of onsemi_vita_cam_core is

  signal host_iserdes_reset_n      : std_logic;

  --
  -- VITA Serial LVDS Receiver
  --

  constant gSIMULATION     : integer := 0;
  constant NROF_CONN       : integer := 5;
  constant NROF_CONTR_CONN : integer := 5;
  constant NROF_CLOCKCOMP  : integer := 1;
  constant NROF_WINDOWS    : integer := 8;
  constant DATAWIDTH       : integer := 10;
  constant CLKSPEED        : integer := 62;
  constant INVBOOL         : boolean := FALSE;
  constant NROF_DELAYCTRLS : integer := 1;
  
  -- usedatapathfunc(gEngineering, gLVDS_OUT) ?
  -- APP_CFG_REG.Sysmode(5) ? = ??
  -- APP_CFG_REG.Sysmode(6) ? = ??
  -- APP_CFG_REG.Sysmode(7) ? = INITVALUE = '0'

  component iserdes_interface is
  generic (
    SIMULATION      : integer := 0;
    NROF_CONN       : integer := 4; --16 bits
    NROF_CONTR_CONN : integer := 4;
    NROF_CLOCKCOMP  : integer := 1;
    DATAWIDTH       : integer := 10; -- can be 4, 6, 8 or 10 for DDR, can be 2, 3, 4, 5, 6, 7, or 8 for SDR.
    RETRY_MAX       : integer := 32767; --16 bits, global
    STABLE_COUNT    : integer := 16;
    TAP_COUNT_MAX   : integer := 64;
    DATA_RATE       : string  := "DDR"; -- DDR/SDR
    DIFF_TERM       : boolean := TRUE;
    USE_FIFO        : boolean := FALSE;
    USE_BLOCKRAMFIFO : boolean := TRUE;
    INVERT_OUTPUT    : boolean := FALSE;
    INVERSE_BITORDER : boolean := FALSE;
    CLKSPEED        : integer := 50;    -- APPCLK speed in MHz. Everything is generated from Appclk to be as sync as possible
    --DATAWIDTH, DATARATE, and clockspeed are used to calculate high speed clk speed.
    --SIM_DEVICE      : string  := "VIRTEX5"; --VIRTEX4/VIRTEX5, for BUFR
    C_FAMILY        : string  := "virtex6";
    NROF_DELAYCTRLS : integer := 1;
    IDELAYCLK_MULT  : integer := 4;
    IDELAYCLK_DIV   : integer := 1;
    GENIDELAYCLK    : boolean := FALSE; -- generate own idelayrefclk based on mult and div parameters or use external clk
                                        -- ext clk can come from common part and thus always be in spec regardless of clkspeed
    USE_OUTPLL      : boolean := TRUE;  --use output/multiplieng PLL instead of DCM
    USE_INPLL       : boolean := TRUE;  --use input/dividing PLL instead of DCM
    USE_HS_EXT_CLK_IN    : boolean := FALSE; -- use external clock high speed clock in
                                             -- YES -> use as CLK source, either via BUFG or BUFIO/BUFR,
                                             --        -> when USE_HS_REGIONAL_CLK = YES
                                             --                use BUFIO (only IOblock can be clocked)
                                             --         -> when USE_HS_REGIONAL_CLK = NO
                                             --                use BUFG
                                             --
                                             -- NO -> when use USE_LS_EXT_CLK_IN = YES
                                             --           not supported
                                             --       when use USE_LS_EXT_CLK_IN = NO
                                             --           appclk combined with DCM as CLK source
                                             --             use BUFG as CLK source
    USE_LS_EXT_CLK_IN    : boolean := FALSE; -- use external clock low speed clock in
                                                 -- YES -> use as CLKDIV source, either via BUFG or BUFIO/BUFR,
                                                 --        -> when USE_LS_REGIONAL_CLK = YES
                                                 --               use BUFR
                                                 --        -> when USE_LS_REGIONAL_CLK = NO
                                                 --               use BUFG
                                                 --
                                                 --
                                                 -- NO ->  when USE_HS_EXT_CLK_IN = YES
                                                 --        -> when USE_HS_REGIONAL_CLK =YES and BUFR can divide
                                                 --               use BUFIO/BUFR to divide HS
                                                 --        -> when USE_HS_REGIONAL_CLK =YES and BUFR can not divide
                                                 --               use BUFIO/BUFR + DCM to divide HS
                                                 --        -> when USE_HS_EXT_CLK_IN = NO
                                                 --               use DCM (same as HS_EXT_CLK_IN) as clk source, sync with appclk
                                                 --
                                                 --
    USE_DIFF_HS_CLK_IN  : boolean := FALSE;  -- differential mode, automatically instantiates the correct buffer
    USE_DIFF_LS_CLK_IN  : boolean := FALSE;  -- differential mode, automatically instantiates the correct buffer
    USE_HS_REGIONAL_CLK  : boolean := FALSE; -- only used when USE_HS_EXT_CLK_IN = yes
    USE_LS_REGIONAL_CLK  : boolean := FALSE; -- only used when USE_LS_EXT_CLK_IN = yes
    USE_HS_EXT_CLK_OUT   : boolean := FALSE; -- use external clock high speed clock out
    USE_LS_EXT_CLK_OUT   : boolean := FALSE; -- use external clock low speed clock out
    USE_DIFF_HS_CLK_OUT  : boolean := FALSE; -- differential mode, automatically instantiates the correct buffer
    USE_DIFF_LS_CLK_OUT  : boolean := FALSE; -- differential mode, automatically instantiates the correct buffer
    USE_DATAPATH         : boolean := TRUE
  );
  port(
    CLOCK               : in    std_logic;
    RESET               : in    std_logic;

    CLK_RDY             : out    std_logic;
    CLK_STATUS          : out    std_logic_vector((16*NROF_CLOCKCOMP)-1 downto 0);
    CLK200              : in   std_logic; -- optional 200MHz refclk

    -- to sensor (external)
    LS_OUT_CLK         : out   std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
    LS_OUT_CLKb        : out   std_logic_vector(NROF_CLOCKCOMP-1 downto 0);  -- only used in differential mode

    HS_OUT_CLK         : out   std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
    HS_OUT_CLKb        : out   std_logic_vector(NROF_CLOCKCOMP-1 downto 0);

    -- from sensor (only used when USED_EXT_CLK = YES)
    LS_IN_CLK          : in    std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
    LS_IN_CLKb         : in    std_logic_vector(NROF_CLOCKCOMP-1 downto 0);

    HS_IN_CLK          : in    std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
    HS_IN_CLKb         : in    std_logic_vector(NROF_CLOCKCOMP-1 downto 0);

    --serdes data, directly connected to bondpads
    SDATAP              : in    std_logic_vector(NROF_CONN-1 downto 0);
    SDATAN              : in    std_logic_vector(NROF_CONN-1 downto 0);

    -- status info
    EDGE_DETECT         : out   std_logic_vector(NROF_CONN-1 downto 0);
    TRAINING_DETECT     : out   std_logic_vector(NROF_CONN-1 downto 0);
    STABLE_DETECT       : out   std_logic_vector(NROF_CONN-1 downto 0);
    FIRST_EDGE_FOUND    : out   std_logic_vector(NROF_CONN-1 downto 0);
    SECOND_EDGE_FOUND   : out   std_logic_vector(NROF_CONN-1 downto 0);
    NROF_RETRIES        : out   std_logic_vector((16*NROF_CONN)-1 downto 0);
    TAP_SETTING         : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
    WINDOW_WIDTH        : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
    WORD_ALIGN          : out   std_logic_vector(NROF_CONN-1 downto 0);
    TIMEOUTONACK        : out   std_logic_vector(NROF_CONTR_CONN-1 downto 0);
        
    -- control
    ALIGN_START         : in    std_logic;
    ALIGN_BUSY          : out   std_logic;
    ALIGNED             : out   std_logic;

    FIFO_EN             : in    std_logic;

    AUTOALIGN           : in    std_logic;

    TRAINING            : in    std_logic_vector(DATAWIDTH-1 downto 0);
    MANUAL_TAP          : in    std_logic_vector(9 downto 0);

    EN_LS_CLK_OUT      : in   std_logic;
    EN_HS_CLK_OUT      : in   std_logic;

    -- parallel data out
    FIFO_RDEN           : in    std_logic;
    FIFO_EMPTY          : out   std_logic;
    FIFO_DATAOUT        : out   std_logic_vector((NROF_CONN*DATAWIDTH)-1 downto 0)
  );
  end component iserdes_interface;
  
  component iserdes_interface_s6 is
  port (
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
    TRAINING            : in    std_logic_vector(DATAWIDTH-1 downto 0);
    MANUAL_TAP          : in    std_logic_vector(9 downto 0);

    -- status
    PLL_LOCKED          : out   std_logic;
    ALIGN_BUSY          : out   std_logic;
    ALIGNED             : out   std_logic;

    -- parallel data out
    FIFO_RDEN           : in    std_logic;
    FIFO_EMPTY          : out   std_logic;
    FIFO_DATAOUT        : out   std_logic_vector((NROF_CONN*DATAWIDTH)-1 downto 0)
  );
  end component iserdes_interface_s6;

  signal CLK_RDY             : std_logic;
  signal CLK_STATUS          : std_logic_vector((16*NROF_CLOCKCOMP)-1 downto 0);

  signal EDGE_DETECT         : std_logic_vector(NROF_CONN-1 downto 0);
  signal TRAINING_DETECT     : std_logic_vector(NROF_CONN-1 downto 0);
  signal STABLE_DETECT       : std_logic_vector(NROF_CONN-1 downto 0);
  signal FIRST_EDGE_FOUND    : std_logic_vector(NROF_CONN-1 downto 0);
  signal SECOND_EDGE_FOUND   : std_logic_vector(NROF_CONN-1 downto 0);
  signal NROF_RETRIES        : std_logic_vector((16*NROF_CONN)-1 downto 0);
  signal TAP_SETTING         : std_logic_vector((10*NROF_CONN)-1 downto 0);
  signal WINDOW_WIDTH        : std_logic_vector((10*NROF_CONN)-1 downto 0);
  signal WORD_ALIGN          : std_logic_vector(NROF_CONN-1 downto 0);
  signal TIMEOUTONACK        : std_logic_vector(NROF_CONTR_CONN-1 downto 0);
        
  -- control
--signal ALIGN_START         : std_logic;
  signal ALIGN_BUSY          : std_logic;
  signal ALIGNED             : std_logic;

--signal FIFO_EN             : std_logic;

--signal AUTOALIGN           : std_logic;

--signal TRAINING            : std_logic_vector(DATAWIDTH-1 downto 0);
--signal MANUAL_TAP          : std_logic_vector(9 downto 0);

--signal EN_LS_CLK_OUT       : std_logic;
--signal EN_HS_CLK_OUT       : std_logic;

  -- parallel data out
  signal FIFO_RDEN           : std_logic;
  signal FIFO_EMPTY          : std_logic;
  signal FIFO_DATAOUT        : std_logic_vector((NROF_CONN*DATAWIDTH)-1 downto 0);

  --
  -- Sync Channel Decoder
  -- 

  component syncchanneldecoder
  generic (  
        NROF_CONN       : integer;
        DATAWIDTH       : integer;
        NROF_WINDOWS    : integer;
        C_INCLUDE_MONITOR : integer
  );
  port (
        -- Control signals
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;
              
        -- Internal signaling
        
        en_decoder          : in    std_logic;    
        --busy_decoder        : out   std_logic;   
        
        PAR_DATA_RDEN       : out   std_logic;   
        PAR_DATA_EMPTY      : in    std_logic;                         
        PAR_DATAIN          : in    std_logic_vector((NROF_CONN*DATAWIDTH)-1 downto 0);                                                                                                            
                
        PAR_SYNCOUT         : out   std_logic_vector((DATAWIDTH)-1 downto 0);        
        PAR_DATAOUT         : out   std_logic_vector(((NROF_CONN-1)*DATAWIDTH)-1 downto 0);  
        PAR_DATA_IMGVALID   : out   std_logic;   
        PAR_DATA_BLACKVALID : out   std_logic; 
        PAR_DATA_LINE       : out   std_logic; 
        PAR_DATA_FRAME      : out   std_logic; 
        KERNEL_ODD_EVEN     : out   std_logic;
        START_KERNEL        : out   std_logic;  
        
        StartOddEven        : in    std_logic_vector(31 downto 0); 
        
        LS_value            : in    std_logic_vector(9 downto 0); 
        LE_value            : in    std_logic_vector(9 downto 0); 
        FS_value            : in    std_logic_vector(9 downto 0); 
        FE_value            : in    std_logic_vector(9 downto 0); 
        BL_value            : in    std_logic_vector(9 downto 0); 
        IMG_value           : in    std_logic_vector(9 downto 0); 
        TR_value            : in    std_logic_vector(9 downto 0); 
        CRC_value           : in    std_logic_vector(9 downto 0); 
        
                                                                 
        -- synchro signals
        framestart          : out   std_logic;   
                              
        windowstart         : out   std_logic;   
        windowend           : out   std_logic;   
                        
        linestart           : out   std_logic;
        lineend             : out   std_logic;
                      
        blacklinestart      : out   std_logic;
        blacklineend        : out   std_logic;
                      
        imagelinestart      : out   std_logic;
        imagelineend        : out   std_logic;                                        
                      
        validcrc            : out   std_logic;                                                                                                
        
        -- counters         
        FramesCnt           : out   std_logic_vector(31 downto 0);
    
        -- lines/frame counter
        BlackLinesCnt       : out   std_logic_vector(31 downto 0);  
        ImgLinesCnt         : out   std_logic_vector(31 downto 0);   
    
        -- pixels/frame counter       
        BlackPixelCnt       : out   std_logic_vector(31 downto 0); 
        ImgPixelCnt         : out   std_logic_vector(31 downto 0);    
    
        -- windows/frame counter
        WindowsCnt          : out   std_logic_vector(31 downto 0);     
    
        -- clocks/frame counter -> fps
        ClocksCnt           : out   std_logic_vector(31 downto 0);
            
        StartLineCnt        : out   std_logic_vector(31 downto 0);
        EndLineCnt          : out   std_logic_vector(31 downto 0);
         
        -- monitors        
        MONITOR             : in    std_logic_vector(1 downto 0);
                    
        Monitor0HighCnt     : out   std_logic_vector(31 downto 0);  
        Monitor0LowCnt      : out   std_logic_vector(31 downto 0); 
        Monitor1HighCnt     : out   std_logic_vector(31 downto 0);
        Monitor1LowCnt      : out   std_logic_vector(31 downto 0)                                   
  );
  end component;

--signal SYNC_PAR_DATA_RDEN   : std_logic;       
--signal SYNC_PAR_DATAIN      : std_logic_vector((NROF_CONN*DATAWIDTH)-1 downto 0);     

  signal SYNC_PAR_SYNCOUT         : std_logic_vector(DATAWIDTH-1 downto 0);
  signal SYNC_PAR_DATAOUT         : std_logic_vector(((NROF_CONN-1)*DATAWIDTH)-1 downto 0);
  signal SYNC_PAR_DATA_IMGVALID   : std_logic;
  signal SYNC_PAR_DATA_BLACKVALID : std_logic;
  signal SYNC_PAR_DATA_LINE       : std_logic; 
  signal SYNC_PAR_DATA_FRAME      : std_logic;
  signal SYNC_KERNEL_ODD_EVEN     : std_logic;
  signal SYNC_START_KERNEL        : std_logic;
--signal SYNC_VIDEO_SYNC          : std_logic_vector(4 downto 0);

  -- synchro signals
  signal framestart           : std_logic;   
                            
  signal windowstart          : std_logic;   
  signal windowend            : std_logic;   
                            
  signal linestart            : std_logic;
  signal lineend              : std_logic;
                            
  signal blacklinestart       : std_logic;
  signal blacklineend         : std_logic;
                            
  signal imagelinestart       : std_logic;
  signal imagelineend         : std_logic;                                        
                            
  signal validcrc             : std_logic;                                                                                                
                            
  --
  -- CRC Checker
  -- 

  constant POLYNOMIAL         : std_logic_vector(10 downto 0) := "11001001111";

  component crc_checker is
  generic (  
        NROF_DATACONN       : integer;
        DATAWIDTH           : integer;
        NROF_WINDOWS        : integer;
        POLYNOMIAL          : std_logic_vector
  );
  port (
        -- Control signals
        CLOCK                   : in    std_logic;
        RESET                   : in    std_logic;
--        APP_CFG_REG             : in    AppCfgRegTp;        
        INITVALUE               : in    std_logic;
                                
        en_decoder              : in    std_logic;
                                                                                                                                     
        -- Data input  
        PAR_SYNC_IN             : in    std_logic_vector(DATAWIDTH-1 downto 0);     
        PAR_DATA_IN             : in    std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);  
        PAR_DATA_IMGVALID_IN    : in    std_logic;   
        PAR_DATA_BLACKVALID_IN  : in    std_logic;
        PAR_DATA_CRCVALID_IN    : in    std_logic; 
        PAR_DATA_LINE_IN        : in    std_logic;
        PAR_DATA_FRAME_IN       : in    std_logic;
        START_KERNEL_IN         : in    std_logic;      
        KERNEL_ODD_EVEN_IN      : in    std_logic;                  
        VIDEO_SYNC_IN           : in    std_logic_vector(4 downto 0);
    
        -- Data out
        PAR_SYNC_OUT            : out   std_logic_vector(DATAWIDTH-1 downto 0); 
        PAR_DATA_OUT            : out   std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);  
        PAR_DATA_IMGVALID_OUT   : out   std_logic;   
        PAR_DATA_BLACKVALID_OUT : out   std_logic;
        PAR_DATA_CRCVALID_OUT   : out   std_logic; 
        PAR_DATA_LINE_OUT       : out   std_logic;
        PAR_DATA_FRAME_OUT      : out   std_logic;
        START_KERNEL_OUT        : out   std_logic;      
        KERNEL_ODD_EVEN_OUT     : out   std_logic;
        VIDEO_SYNC_OUT          : out   std_logic_vector(4 downto 0);
                
        --status
        CRC_STATUS              : out   std_logic_vector(NROF_DATACONN-1 downto 0)
                                                                                                                                         
  );
  end component;

  signal CRC_PAR_SYNC_OUT             : std_logic_vector(DATAWIDTH-1 downto 0);                                      
  signal CRC_PAR_DATA_OUT             : std_logic_vector(((NROF_CONN-1)*DATAWIDTH)-1 downto 0);                     
  signal CRC_PAR_DATA_IMGVALID_OUT    : std_logic;                                                                  
  signal CRC_PAR_DATA_BLACKVALID_OUT  : std_logic;                                                                  
  signal CRC_PAR_DATA_CRCVALID_OUT    : std_logic;                                                                  
  signal CRC_PAR_DATA_LINE_OUT        : std_logic;                                                                  
  signal CRC_PAR_DATA_FRAME_OUT       : std_logic;                                                                  
  signal CRC_START_KERNEL             : std_logic;
  signal CRC_KERNEL_ODD_EVEN          : std_logic;
  signal CRC_VIDEO_SYNC               : std_logic_vector(4 downto 0);
  
  signal CRC_STATUS                   : std_logic_vector(NROF_CONN - 2 downto 0);
  signal CRC_DEBUG                    : std_logic_vector(((NROF_CONN-1)*(2*DATAWIDTH+1))-1 downto 0);
          
  --
  -- Data Channel Re-Mapper
  -- 

  component remapper
  generic (  
        NROF_DATACONN       : integer;
        DATAWIDTH           : integer;
        NROF_WINDOWS        : integer
  );
  port (
        -- Control signals
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;
       
        WriteCfg            : in    std_logic_vector(2 downto 0);
        RemapMode           : in    std_logic_vector(2 downto 0);
                                                                                                                                                    
        -- Data input
        --from serial   
        PAR_SYNC            : in    std_logic_vector((DATAWIDTH)-1 downto 0);  
        PAR_DATA            : in    std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);  
        PAR_DATA_IMGVALID   : in    std_logic;   
        PAR_DATA_BLACKVALID : in    std_logic; 
        PAR_DATA_CRCVALID   : in    std_logic; 
        PAR_DATA_LINE       : in    std_logic; 
        PAR_DATA_FRAME      : in    std_logic; 
        
        -- kernel odd/even control
        START_KERNEL        : in    std_logic;        
        KERNEL_ODD_EVEN     : in    std_logic;                        
        VIDEO_SYNC_IN       : in    std_logic_vector(4 downto 0);
        VIDEO_SYNC_OUT      : out  std_logic_vector(4 downto 0);
                                        
        en_decoder          : in    std_logic;      
        
        -- Data output
        PAR_DATA_OUT        : out   std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);        
        PAR_DATA_VALID_OUT  : out   std_logic;                                       
        PAR_DATA_LINE_OUT   : out   std_logic;                                       
        PAR_DATA_FRAME_OUT  : out   std_logic;                                       
        PAR_DATA_WINDOW_OUT : out   std_logic                                                                       
  );
  end component;

  signal REMAP_PAR_DATA_OUT           : std_logic_vector(((NROF_CONN-1)*DATAWIDTH)-1 downto 0);       
  signal REMAP_PAR_DATA_VALID_OUT     : std_logic;                                       
  signal REMAP_PAR_DATA_LINE_OUT      : std_logic;                                       
  signal REMAP_PAR_DATA_FRAME_OUT     : std_logic;                                       
  signal REMAP_PAR_DATA_WINDOW_OUT    : std_logic;         

  signal REMAP_VIDEO_SYNC             : std_logic_vector(4 downto 0);

  --
  -- FPN/PRNU Correction
  --

  component correct_column_fpn_prnu_dsp48e is
  generic (
        NROF_DATACONN       : integer;
        DATAWIDTH           : integer;
        ENABLECORRECT       : boolean;
        C_FAMILY            : string
  );
  port (
        -- Control signals
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;
        CorrectValues       : in    std_logic_vector((NROF_DATACONN*4*16)-1 downto 0);

        WR_DATA_in          : in    std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);
        WR_NEXT_in          : in    std_logic;
        WR_FRAME_in         : in    std_logic;
        WR_LINE_in          : in    std_logic;
        WR_WINDOW_in        : in    std_logic;

        WR_DATA_out         : out   std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);
        WR_NEXT_out         : out   std_logic;
        WR_FRAME_out        : out   std_logic;
        WR_LINE_out         : out   std_logic;
        WR_WINDOW_out       : out   std_logic;

        VIDEO_SYNC_IN       : in    std_logic_vector(4 downto 0);
        VIDEO_SYNC_OUT      : out   std_logic_vector(4 downto 0)
  );
  end component;

  signal BLC_CORRECT_VALUES         : std_logic_vector(((NROF_CONN-1)*4*16)-1 downto 0);

  signal BLC_PAR_DATA_OUT           : std_logic_vector(((NROF_CONN-1)*DATAWIDTH)-1 downto 0);       
  signal BLC_PAR_DATA_VALID_OUT     : std_logic;                                       
  signal BLC_PAR_DATA_LINE_OUT      : std_logic;                                       
  signal BLC_PAR_DATA_FRAME_OUT     : std_logic;                                       
  signal BLC_PAR_DATA_WINDOW_OUT    : std_logic;         

  signal BLC_VIDEO_SYNC             : std_logic_vector(4 downto 0);
  
  --
  -- Trigger Generator
  --

  component triggergenerator 
  port (
        -- Control signals
        csi_clockreset_clk       : in    std_logic;
        csi_clockreset_reset_n   : in    std_logic;
        
        coe_external_trigger_in  : in    std_logic;    
        readouttrigger           : in    std_logic;
        
        ENABLETRIGGER            : in    std_logic_vector(2 downto 0);      
        SYNCTOREADOUT_OR_EXT     : in    std_logic_vector(2 downto 0); --(0): enable timeout default frequency
                                                                       --(1): trigger on readout input trigger
                                                                       --(2): trigger on external input trigger
                                                                       --Note: (0) can be combined with (1) xor (2), (1) and (2) can be combined but it is prob not usefull
        DEFAULTFREQ              : in    std_logic_vector(31 downto 0); --acutally an interval
        TRIGGERLENGTHLOW0        : in    std_logic_vector(31 downto 0);      
        TRIGGERLENGTHHIGH0       : in    std_logic_vector(31 downto 0);      
        TRIGGERLENGTHLOW1        : in    std_logic_vector(31 downto 0);      
        TRIGGERLENGTHHIGH1       : in    std_logic_vector(31 downto 0);
        TRIGGERLENGTHLOW2        : in    std_logic_vector(31 downto 0);
        TRIGGERLENGTHHIGH2       : in    std_logic_vector(31 downto 0);
        
        EXTERNAL_TRIGGER_DEB     : in    std_logic_vector(31 downto 0); 
        EXTERNAL_TRIGGER_POL     : in    std_logic;                       --0 is active low 1 is active high
        coe_vita_TRIGGER         : out   std_logic_vector(2 downto 0)                                                                                                                                                                         
  );
  end component;

--  signal readouttrigger          : std_logic; 
--  signal readouttrigger_d1       : std_logic;
--  signal readouttrigger_d2       : std_logic;

  signal triggen_vita_trigger      : std_logic_vector(2 downto 0);

  -- 
  -- Delayed Start Frame signal
  --
  
  component pulse_regen is
  generic
  (
    C_FAMILY                     : string := "kintex7"
  );
  port
  (
      rst                        : IN std_logic;

      clk1                       : IN std_logic;
      pulse1                     : IN std_logic;

      clk2                       : IN std_logic;
      pulse2                     : OUT std_logic
  );
  end component;  

  signal framestart_cnt          : unsigned(15 downto 0) := (others => '0');  
  signal framestart_active       : std_logic := '0';
  signal framestart2             : std_logic;
  signal framestart2_regen       : std_logic;

  --
  -- Video Sync Generator
  --

  component VideoSyncGen is
   generic (
      HWidth_g                   : integer := 16;
      VWidth_g                   : integer := 16 
   );

   port (
      -- Global Reset
      i_Clk_p                    : in std_logic;
      i_Reset_p                  : in std_logic;

      -- 
      i_Restart_p                : in std_logic;

      -- Video Configuration
      iv16_VidHActive_p          : in std_logic_vector(15 downto 0);
      iv16_VidHFPorch_p          : in std_logic_vector(15 downto 0);
      iv16_VidHSync_p            : in std_logic_vector(15 downto 0);
      iv16_VidHBPorch_p          : in std_logic_vector(15 downto 0);
      --
      iv16_VidVActive_p          : in std_logic_vector(15 downto 0);
      iv16_VidVFPorch_p          : in std_logic_vector(15 downto 0);
      iv16_VidVSync_p            : in std_logic_vector(15 downto 0);
      iv16_VidVBPorch_p          : in std_logic_vector(15 downto 0);
      
      -- Video Synchronization Signals
      o_HSync_p                  : out std_logic;
      o_VSync_p                  : out std_logic;
      o_De_p                     : out std_logic;
      o_HBlank_p                 : out std_logic;
      o_VBlank_p                 : out std_logic;

      -- Data Request strobe (1 cycle in advance of synchronization signals)
      ov_HCount_p                : out std_logic_vector(HWidth_g-1 downto 0);
      ov_VCount_p                : out std_logic_vector(VWidth_g-1 downto 0);
      o_PixelRequest_p           : out std_logic
   );
  end component VideoSyncGen;

  signal syncgen_hsync             : std_logic;
  signal syncgen_vsync             : std_logic;
  signal syncgen_de                : std_logic;
  signal syncgen_hblank            : std_logic;
  signal syncgen_vblank            : std_logic;
  
  signal syncgen_vcount            : std_logic_vector(15 downto 0); 
  signal syncgen_hcount            : std_logic_vector(15 downto 0); 
  signal syncgen_pixelrequest      : std_logic;

  --
  -- De-Multiplexer
  --

  component afifo_64i_16o is
  generic
  (
    C_FAMILY                  : string               := "virtex6"
  );
  port
  (
      rst                     : IN std_logic;

      wr_clk                  : IN std_logic;
      wr_en                   : IN std_logic;
      din                     : IN std_logic_VECTOR(63 downto 0);

      rd_clk                  : IN std_logic;
      rd_en                   : IN std_logic;
      dout                    : OUT std_logic_VECTOR(15 downto 0);

      empty                   : OUT std_logic;
      full                    : OUT std_logic
  );
  end component;

  signal demux_din            : std_logic_vector(63 downto 0);
  signal demux_dout           : std_logic_vector(15 downto 0);
  signal demux_empty          : std_logic;
  signal demux_full           : std_logic;

  --
  -- I/O registers & buffers
  --

  signal clk_n                     : std_logic;
  signal net0                      : std_logic;
  signal net1                      : std_logic;

  signal oe_n                      : std_logic;

  signal vita_clk_pll_o            : std_logic;
  signal vita_reset_n_o            : std_logic;
  signal vita_trigger_o            : std_logic_vector(2 downto 0);

  signal vita_clk_pll_t            : std_logic;
  signal vita_reset_n_t            : std_logic;
  signal vita_trigger_t            : std_logic_vector(2 downto 0);

begin

  host_iserdes_reset_n <= not host_iserdes_reset;
  
  --
  -- VITA Serial LVDS Receiver
  --

  vita_iserdes_s6 : if ( C_FAMILY = "spartan6" ) generate
    vita_iserdes : iserdes_interface_s6
    port map (
          CLOCK               => clk                        ,
          RESET               => host_iserdes_reset         ,
          
          -- serdes clock, directly connected to bondpads
          SCLKP               => io_vita_clk_out_p          ,
          SCLKN               => io_vita_clk_out_n          ,

          -- serdes data, directly connected to bondpads
          SDATAP(4 downto 1)  => io_vita_data_p(3 downto 0) ,
          SDATAP(0)           => io_vita_sync_p             ,
          SDATAN(4 downto 1)  => io_vita_data_n(3 downto 0) ,
          SDATAN(0)           => io_vita_sync_n             ,
          
          -- control
          ALIGN_START         => host_iserdes_align_start   ,
          FIFO_EN             => host_iserdes_fifo_enable   ,
          TRAINING            => host_iserdes_training      ,
          MANUAL_TAP          => host_iserdes_manual_tap    ,

          -- status
          PLL_LOCKED          => CLK_RDY                    ,
          ALIGN_BUSY          => ALIGN_BUSY                 ,
          ALIGNED             => ALIGNED                    ,

          -- parallel data out
          FIFO_RDEN           => FIFO_RDEN                  ,
          FIFO_EMPTY          => FIFO_EMPTY                 ,
          FIFO_DATAOUT        => FIFO_DATAOUT
    );
    
    
    host_iserdes_clk_ready    <= CLK_RDY;
    host_iserdes_clk_status   <= CLK_STATUS;
    host_iserdes_align_busy   <= ALIGN_BUSY;
    host_iserdes_aligned      <= ALIGNED;
    
  end generate;
  
  vita_iserdes_v5 : if not ( C_FAMILY = "spartan6" ) generate
    vita_iserdes : iserdes_interface
    generic map (
          SIMULATION          => gSIMULATION   ,
          NROF_CONN           => NROF_CONN    ,
          NROF_CONTR_CONN     => NROF_CONN    ,
          NROF_CLOCKCOMP      => 1            ,
          DATAWIDTH           => DATAWIDTH    ,
          RETRY_MAX           => 32767        ,
          STABLE_COUNT        => 16           ,
          --TAP_COUNT_MAX       => 64           , -- for Virtex-5 IODELAY
          TAP_COUNT_MAX       => 32           , -- for Virtex-6 IODELAYE1
          DATA_RATE           => "DDR"        ,
          DIFF_TERM           => TRUE         ,
          USE_FIFO            => TRUE         ,
          USE_BLOCKRAMFIFO    => TRUE         ,
          INVERT_OUTPUT       => INVBOOL      , --change back for final system !!!!!
          INVERSE_BITORDER    => FALSE        ,
          CLKSPEED            => CLKSPEED     ,
          --SIM_DEVICE          => "VIRTEX5"    ,
          C_FAMILY            => C_FAMILY     ,
          NROF_DELAYCTRLS     => NROF_DELAYCTRLS, --should be 2 for 'correct' char board, change when required
          IDELAYCLK_MULT      => 3            ,
          IDELAYCLK_DIV       => 1            ,
          GENIDELAYCLK        => FALSE        ,
          USE_OUTPLL          => FALSE        , --use output/multiplieng PLL instead of DCM
          USE_INPLL           => FALSE        ,
          USE_HS_EXT_CLK_IN   => TRUE,--useLVDSclocks(gEngineering, gLVDS_OUT)   ,
          USE_LS_EXT_CLK_IN   => FALSE        ,
          USE_DIFF_HS_CLK_IN  => TRUE,--useLVDSclocks(gEngineering, gLVDS_OUT)   , -- differential mode, automatically instantiates the correct buffer
          USE_DIFF_LS_CLK_IN  => FALSE        , -- differential mode, automatically instantiates the correct buffer
          USE_HS_REGIONAL_CLK => TRUE,--useLVDSclocks(gEngineering, gLVDS_OUT)   , -- only used when USE_HS_EXT_CLK_IN = yes
          USE_LS_REGIONAL_CLK => FALSE        , --
          USE_HS_EXT_CLK_OUT  => FALSE        , -- use external clock high speed clock out
          USE_LS_EXT_CLK_OUT  => FALSE        , -- use external clock low speed clock out
          USE_DIFF_HS_CLK_OUT => TRUE         , -- differential mode, automatically instantiates the correct buffer
          USE_DIFF_LS_CLK_OUT => FALSE        , -- differential mode, automatically instantiates the correct buffer
          USE_DATAPATH        => TRUE--usedatapathfunc(gEngineering, gLVDS_OUT)
    )
    port map(
          CLOCK               => clk          ,
          RESET               => host_iserdes_reset,

          CLK200              => clk200       ,

          CLK_RDY             => CLK_RDY      ,
          CLK_STATUS          => CLK_STATUS   ,

          -- to sensor (external)
          --LS_OUT_CLK(0)          => open, --CLK_PLL           ,
          --LS_OUT_CLKb(0)         => open, --CLK_PLL_n         ,


          --HS_OUT_CLK(0)       => open, --ClockIn_P    ,
          --HS_OUT_CLKb(0)      => open, --ClockIn_N    ,

          -- from sensor (only used when USED_EXT_CLK = YES)
          LS_IN_CLK(0)        => '0',
          LS_IN_CLKb(0)       => '0',

          HS_IN_CLK(0)        => io_vita_clk_out_p,
          HS_IN_CLKb(0)       => io_vita_clk_out_n,

          --serdes data, directly connected to bondpads
          SDATAP(4 downto 1)  => io_vita_data_p(3 downto 0),
          SDATAP(0)           => io_vita_sync_p            ,
          SDATAN(4 downto 1)  => io_vita_data_n(3 downto 0),
          SDATAN(0)           => io_vita_sync_n            ,

          -- status info
          EDGE_DETECT         => EDGE_DETECT          ,
          TRAINING_DETECT     => TRAINING_DETECT      ,
          STABLE_DETECT       => STABLE_DETECT        ,
          FIRST_EDGE_FOUND    => FIRST_EDGE_FOUND     ,
          SECOND_EDGE_FOUND   => SECOND_EDGE_FOUND    ,
          NROF_RETRIES        => NROF_RETRIES         ,
          TAP_SETTING         => TAP_SETTING          ,
          WINDOW_WIDTH        => WINDOW_WIDTH         ,
          WORD_ALIGN          => WORD_ALIGN           ,

          -- control
          ALIGN_START         => host_iserdes_align_start,
          ALIGN_BUSY          => ALIGN_BUSY           ,
          ALIGNED             => ALIGNED              ,

          FIFO_EN             => host_iserdes_fifo_enable,

          AUTOALIGN           => host_iserdes_auto_align,

          TRAINING            => host_iserdes_training,
          MANUAL_TAP          => host_iserdes_manual_tap,

          EN_LS_CLK_OUT       => '0'                  ,--APP_CFG_REG.Sysmode(5),
          EN_HS_CLK_OUT       => '0'                  ,--APP_CFG_REG.Sysmode(6),
          TIMEOUTONACK        => open            ,

          -- parallel data out
          FIFO_RDEN           => FIFO_RDEN            ,
          FIFO_EMPTY          => FIFO_EMPTY           ,
          FIFO_DATAOUT        => FIFO_DATAOUT
         );

    host_iserdes_clk_ready    <= CLK_RDY;
    host_iserdes_clk_status   <= CLK_STATUS;
    host_iserdes_align_busy   <= ALIGN_BUSY;
    host_iserdes_aligned      <= ALIGNED;

  end generate;

  --
  -- Sync Channel Decoder
  -- 

  vita_syncchanneldecoder: syncchanneldecoder
  generic map (  
        NROF_CONN       => NROF_CONN        ,
        DATAWIDTH       => DATAWIDTH        ,
        NROF_WINDOWS    => 8                ,
        C_INCLUDE_MONITOR => C_INCLUDE_MONITOR
  )
  port map (
        -- Control signals
        CLOCK               => clk                  ,
        RESET               => host_decoder_reset   ,
              
        -- Internal signaling
        
        en_decoder          => host_decoder_enable  ,
       
        PAR_DATA_RDEN       => FIFO_RDEN            ,
        PAR_DATA_EMPTY      => FIFO_EMPTY           ,
        PAR_DATAIN          => FIFO_DATAOUT         , 
                
        PAR_SYNCOUT         => SYNC_PAR_SYNCOUT         ,
        PAR_DATAOUT         => SYNC_PAR_DATAOUT         ,
        PAR_DATA_IMGVALID   => SYNC_PAR_DATA_IMGVALID   ,
        PAR_DATA_BLACKVALID => SYNC_PAR_DATA_BLACKVALID ,
        PAR_DATA_LINE       => SYNC_PAR_DATA_LINE       ,
        PAR_DATA_FRAME      => SYNC_PAR_DATA_FRAME      ,
        KERNEL_ODD_EVEN     => SYNC_KERNEL_ODD_EVEN     ,
        START_KERNEL        => SYNC_START_KERNEL        ,
        
        StartOddEven        => host_decoder_startoddeven,
                                        
        LS_value            => host_decoder_code_ls     ,
        LE_value            => host_decoder_code_le     ,
        FS_value            => host_decoder_code_fs     ,
        FE_value            => host_decoder_code_fe     ,
        BL_value            => host_decoder_code_bl     ,
        IMG_value           => host_decoder_code_img    ,
        TR_value            => host_decoder_code_tr     ,
        CRC_value           => host_decoder_code_crc    ,
        
                                                                 
        -- synchro signals
        framestart          => framestart           ,
                                               
        windowstart         => windowstart          ,
        windowend           => windowend            ,
                                  
        linestart           => linestart            ,
        lineend             => lineend              ,
                               
        blacklinestart      => blacklinestart       ,
        blacklineend        => blacklineend         ,
                                 
        imagelinestart      => imagelinestart       ,
        imagelineend        => imagelineend         ,                               
                                   
        validcrc            => validcrc             ,                                                                                       
        
        -- counters         
        FramesCnt           => host_decoder_cnt_frames,
    
        -- lines/frame counter
        BlackLinesCnt       => host_decoder_cnt_black_lines,
        ImgLinesCnt         => host_decoder_cnt_image_lines,
    
        -- pixels/frame counter       
        BlackPixelCnt       => host_decoder_cnt_black_pixels,
        ImgPixelCnt         => host_decoder_cnt_image_pixels,
    
        -- windows/frame counter
        WindowsCnt          => host_decoder_cnt_windows,
    
        -- clocks/frame counter -> fps
        ClocksCnt           => host_decoder_cnt_clocks,
            
        StartLineCnt        => host_decoder_cnt_start_lines,
        EndLineCnt          => host_decoder_cnt_end_lines,
         
        -- monitors        
        MONITOR             => io_vita_monitor,
                    
        Monitor0HighCnt     => host_decoder_cnt_monitor0high,
        Monitor0LowCnt      => host_decoder_cnt_monitor0low,
        Monitor1HighCnt     => host_decoder_cnt_monitor1high,
        Monitor1LowCnt      => host_decoder_cnt_monitor1low
    );

  host_decoder_frame_start <= framestart;

  --
  -- CRC Checker
  -- 

  vita_crc_checker: crc_checker
  generic map (  
        NROF_DATACONN       => NROF_CONN - 1                    ,
        DATAWIDTH           => DATAWIDTH                        ,
        NROF_WINDOWS        => NROF_WINDOWS                     ,
        POLYNOMIAL          => POLYNOMIAL
  )
  port map (
        -- Control signals
        CLOCK                   => clk                          , 
        RESET                   => host_decoder_reset           , 
                                                                
        INITVALUE               => host_crc_initvalue           ,                                 
        en_decoder              => host_decoder_enable          ,

        -- Data input  
        PAR_SYNC_IN             => SYNC_PAR_SYNCOUT             ,
        PAR_DATA_IN             => SYNC_PAR_DATAOUT             ,
        PAR_DATA_IMGVALID_IN    => SYNC_PAR_DATA_IMGVALID       ,
        PAR_DATA_BLACKVALID_IN  => SYNC_PAR_DATA_BLACKVALID     ,
        PAR_DATA_CRCVALID_IN    => validcrc                     ,
        PAR_DATA_LINE_IN        => SYNC_PAR_DATA_LINE           ,
        PAR_DATA_FRAME_IN       => SYNC_PAR_DATA_FRAME          ,
        START_KERNEL_IN         => SYNC_START_KERNEL            ,
        KERNEL_ODD_EVEN_IN      => SYNC_KERNEL_ODD_EVEN         ,               
        VIDEO_SYNC_IN           => "00000", --SYNC_VIDEO_SYNC              ,
                                             
        -- Data out
        PAR_SYNC_OUT            => CRC_PAR_SYNC_OUT             ,             
        PAR_DATA_OUT            => CRC_PAR_DATA_OUT             ,             
        PAR_DATA_IMGVALID_OUT   => CRC_PAR_DATA_IMGVALID_OUT    ,             
        PAR_DATA_BLACKVALID_OUT => CRC_PAR_DATA_BLACKVALID_OUT  ,             
        PAR_DATA_CRCVALID_OUT   => CRC_PAR_DATA_CRCVALID_OUT    ,             
        PAR_DATA_LINE_OUT       => CRC_PAR_DATA_LINE_OUT        ,             
        PAR_DATA_FRAME_OUT      => CRC_PAR_DATA_FRAME_OUT       ,             
        START_KERNEL_OUT        => CRC_START_KERNEL             ,
        KERNEL_ODD_EVEN_OUT     => CRC_KERNEL_ODD_EVEN          ,
        VIDEO_SYNC_OUT          => open, --CRC_VIDEO_SYNC               ,
                                
        --status
        CRC_STATUS              => CRC_STATUS
--        CRC_DEBUG               => CRC_DEBUG
  );

  host_crc_status(31 downto (NROF_CONN - 1)) <= (others => '0');
  host_crc_status((NROF_CONN - 2) downto  0) <= CRC_STATUS;

  --
  -- Data Channel Re-Mapper
  -- 

  vita_remapper: remapper
  generic map (  
        NROF_DATACONN       => NROF_CONN - 1        ,
        DATAWIDTH           => DATAWIDTH            ,
        NROF_WINDOWS        => 8
  )
  port map (
        -- Control signals
        CLOCK               => clk                          , 
        RESET               => host_decoder_reset           , 
                                                        
        WriteCfg            => host_remapper_write_cfg      ,
        RemapMode           => host_remapper_mode           ,
                                                                                                                                                    
        -- Data input                                
        --from serial                                
        PAR_SYNC            => CRC_PAR_SYNC_OUT             , 
        PAR_DATA            => CRC_PAR_DATA_OUT             ,   
        PAR_DATA_IMGVALID   => CRC_PAR_DATA_IMGVALID_OUT    , 
        PAR_DATA_BLACKVALID => CRC_PAR_DATA_BLACKVALID_OUT  , 
        PAR_DATA_CRCVALID   => CRC_PAR_DATA_CRCVALID_OUT    , 
        PAR_DATA_LINE       => CRC_PAR_DATA_LINE_OUT        , 
        PAR_DATA_FRAME      => CRC_PAR_DATA_FRAME_OUT       , 
                                                       
        -- kernel odd/even control                     
        START_KERNEL        => CRC_KERNEL_ODD_EVEN          ,       
        KERNEL_ODD_EVEN     => CRC_START_KERNEL             ,                       
        VIDEO_SYNC_IN       => CRC_VIDEO_SYNC               ,
        VIDEO_SYNC_OUT      => REMAP_VIDEO_SYNC             ,
                                                       
        en_decoder          => host_decoder_enable          ,
        
        -- Data output
        PAR_DATA_OUT        => REMAP_PAR_DATA_OUT           ,                 
        PAR_DATA_VALID_OUT  => REMAP_PAR_DATA_VALID_OUT     ,                 
        PAR_DATA_LINE_OUT   => REMAP_PAR_DATA_LINE_OUT      ,                 
        PAR_DATA_FRAME_OUT  => REMAP_PAR_DATA_FRAME_OUT     ,                 
        PAR_DATA_WINDOW_OUT => REMAP_PAR_DATA_WINDOW_OUT                                                                
  );

  --
  -- FPN/PRNU Correction
  --

WITH_BLC : if (C_INCLUDE_BLC = 1) generate

  vita_blc: correct_column_fpn_prnu_dsp48e
  generic map (
        NROF_DATACONN       => NROF_CONN - 1        ,
        DATAWIDTH           => DATAWIDTH            ,
        ENABLECORRECT       => true                 ,
        C_FAMILY            => C_FAMILY
  )
  port map (
        -- Control signals
        CLOCK               => clk,
        RESET               => host_decoder_reset,
        CorrectValues       => host_fpn_prnu_values,

        WR_DATA_in          => REMAP_PAR_DATA_OUT,
        WR_NEXT_in          => REMAP_PAR_DATA_VALID_OUT,
        WR_FRAME_in         => REMAP_PAR_DATA_LINE_OUT,
        WR_LINE_in          => REMAP_PAR_DATA_FRAME_OUT,
        WR_WINDOW_in        => REMAP_PAR_DATA_WINDOW_OUT,

        WR_DATA_out         => BLC_PAR_DATA_OUT,
        WR_NEXT_out         => BLC_PAR_DATA_VALID_OUT,
        WR_FRAME_out        => BLC_PAR_DATA_LINE_OUT,
        WR_LINE_out         => BLC_PAR_DATA_FRAME_OUT,
        WR_WINDOW_out       => BLC_PAR_DATA_WINDOW_OUT,

        VIDEO_SYNC_IN       => REMAP_VIDEO_SYNC,
        VIDEO_SYNC_OUT      => BLC_VIDEO_SYNC
  );

end generate WITH_BLC;

WITHOUT_BLC : if (C_INCLUDE_BLC = 0) generate
  BLC_PAR_DATA_OUT        <= REMAP_PAR_DATA_OUT;
  BLC_PAR_DATA_VALID_OUT  <= REMAP_PAR_DATA_VALID_OUT;
  BLC_PAR_DATA_LINE_OUT   <= REMAP_PAR_DATA_LINE_OUT;
  BLC_PAR_DATA_FRAME_OUT  <= REMAP_PAR_DATA_FRAME_OUT;
  BLC_PAR_DATA_WINDOW_OUT <= REMAP_PAR_DATA_WINDOW_OUT;
  BLC_VIDEO_SYNC          <= REMAP_VIDEO_SYNC;
end generate WITHOUT_BLC;

  --
  -- Trigger Generator
  --

--  readouttrigger <= host_triggen_readouttrigger or trigger1;

--  triggen_readouttrigger_l : process (clk)
--  begin
--    if rising_edge( clk ) then
--      readouttrigger_d1 <= readouttrigger;
--      readouttrigger_d2 <= readouttrigger_d1;
--    end if;
--  end process;

  vita_triggergenerator: triggergenerator
  port map (
        -- Control signals
        csi_clockreset_clk       => clk                          ,
        csi_clockreset_reset_n   => host_iserdes_reset_n         ,
        
--        readouttrigger           => readouttrigger_d2            ,
        coe_external_trigger_in  => trigger1                     ,
        readouttrigger           => host_triggen_readouttrigger  ,
        
        ENABLETRIGGER            => host_triggen_enable          ,     
        SYNCTOREADOUT_OR_EXT     => host_triggen_sync2readout    ,
        DEFAULTFREQ              => host_triggen_default_freq    ,
        TRIGGERLENGTHLOW0        => host_triggen_cnt_trigger0low ,
        TRIGGERLENGTHHIGH0       => host_triggen_cnt_trigger0high,
        TRIGGERLENGTHLOW1        => host_triggen_cnt_trigger1low ,
        TRIGGERLENGTHHIGH1       => host_triggen_cnt_trigger1high,
        TRIGGERLENGTHLOW2        => host_triggen_cnt_trigger2low ,
        TRIGGERLENGTHHIGH2       => host_triggen_cnt_trigger2high,
        
        EXTERNAL_TRIGGER_DEB     => host_triggen_ext_debounce    ,
        EXTERNAL_TRIGGER_POL     => host_triggen_ext_polarity    ,
        coe_vita_TRIGGER         => triggen_vita_trigger
  );

  triggen_gen_polarity_l : process (clk)
  begin
    if rising_edge( clk ) then
      -- TRIGGER0
      if ( host_triggen_gen_polarity(0) = '0' ) then
         vita_trigger_o(0)       <= triggen_vita_trigger(0);
      else
         vita_trigger_o(0)       <= not triggen_vita_trigger(0);
      end if;
      -- TRIGGER1
      if ( host_triggen_gen_polarity(1) = '0' ) then
         vita_trigger_o(1)       <= triggen_vita_trigger(1);
      else
         vita_trigger_o(1)       <= not triggen_vita_trigger(1);
      end if;
      -- TRIGGER2
      if ( host_triggen_gen_polarity(2) = '0' ) then
         vita_trigger_o(2)       <= triggen_vita_trigger(2);
      else
         vita_trigger_o(2)       <= not triggen_vita_trigger(2);
      end if;
    end if;
  end process;

  -- 
  -- Delayed Start Frame signal
  --

  framestart2_l :  process (reset, clk)
  begin
    if ( reset = '1' ) then
	    framestart_active         <= '0';
		 framestart_cnt            <= (others => '0');
	    framestart2               <= '0';
		 
	 elsif rising_edge( clk ) then
	    -- default values
	    framestart2               <= '0';		 
		 
		 -- detect incoming framestart
	    if ( framestart = '1' ) then
		    framestart_active      <= '1';
		    framestart_cnt         <= (others => '0');
       end if;
		 
		 -- create delayed framestart2
		 if ( framestart_active = '1' ) then
	       framestart_cnt      <= framestart_cnt + 1;
		    if ( framestart_cnt = unsigned(host_syncgen_delay)-1 ) then
				 framestart_active   <= '0';
			    framestart2         <= '1';
		    end if;
		 end if;
	 end if;
  end process framestart2_l;
  
  -- regenerate framestart2 to clk4x clock
  framestart2_regen_l : pulse_regen
  generic map
  (
    C_FAMILY                     => C_FAMILY
  )
  port map
  (
      rst                        => reset,

      clk1                       => clk,
      pulse1                     => framestart2,

      clk2                       => clk4x,
      pulse2                     => framestart2_regen
  );

  --
  -- Video Sync Generator
  --

--VIDEO_WITH_SYNCGEN : if (C_VIDEO_USE_SYNCGEN = 1) generate

  syncgen_l : VideoSyncGen
   generic map (
      HWidth_g                   => 16,
      VWidth_g                   => 16
   )
   port map (
      -- Global Reset
      i_Clk_p                    => clk4x,
      i_Reset_p                  => reset,

      i_Restart_p                => framestart2_regen,

      -- Video Configuration
      iv16_VidHActive_p          => host_syncgen_hactive,
      iv16_VidHFPorch_p          => host_syncgen_hfporch,
      iv16_VidHSync_p            => host_syncgen_hsync,
      iv16_VidHBPorch_p          => host_syncgen_hbporch,
      --
      iv16_VidVActive_p          => host_syncgen_vactive,
      iv16_VidVFPorch_p          => host_syncgen_vfporch,
      iv16_VidVSync_p            => host_syncgen_vsync,
      iv16_VidVBPorch_p          => host_syncgen_vbporch,
      
      -- Video Synchronization Signals
      o_HSync_p                  => syncgen_hsync,
      o_VSync_p                  => syncgen_vsync,
      o_De_p                     => syncgen_de,
      o_HBlank_p                 => syncgen_hblank,
      o_VBlank_p                 => syncgen_vblank,

      -- Data Request strobe (1 cycle in advance of synchronization signals)
      ov_HCount_p                => syncgen_hcount,
      ov_VCount_p                => syncgen_vcount,
      o_PixelRequest_p           => syncgen_pixelrequest
   );


--  syncgen_delay_l : process (clk)
--  begin
--    if rising_edge( clk ) then
----      SYNC_VIDEO_SYNC(4)         <= syncgen_vsync;
----      SYNC_VIDEO_SYNC(3)         <= syncgen_hsync;
----      SYNC_VIDEO_SYNC(2)         <= syncgen_vblank;
----      SYNC_VIDEO_SYNC(1)         <= syncgen_hblank;
----      SYNC_VIDEO_SYNC(0)         <= syncgen_de;
--      CRC_VIDEO_SYNC(4)         <= syncgen_vsync;
--      CRC_VIDEO_SYNC(3)         <= syncgen_hsync;
--      CRC_VIDEO_SYNC(2)         <= syncgen_vblank;
--      CRC_VIDEO_SYNC(1)         <= syncgen_hblank;
--      CRC_VIDEO_SYNC(0)         <= syncgen_de;
--    end if;
--  end process;
--
--end generate VIDEO_WITH_SYNCGEN;

--VIDEO_WITHOUT_SYNCGEN : if (C_VIDEO_USE_SYNCGEN = 0) generate
   -- Without the VideoSynGen module, 
   --    only the DE signal is availabel via IMGVALID
   CRC_VIDEO_SYNC(4)         <= '0'; -- vsync
   CRC_VIDEO_SYNC(3)         <= '0'; -- hsync
   CRC_VIDEO_SYNC(2)         <= '0'; -- vblank
   CRC_VIDEO_SYNC(1)         <= '0'; -- hblank
   CRC_VIDEO_SYNC(0)         <= CRC_PAR_DATA_IMGVALID_OUT; -- de
--end generate VIDEO_WITHOUT_SYNCGEN;

DEMUX_GEN : if (C_VIDEO_DIRECT_OUTPUT = 0) generate

  --
  -- De-Multiplexer
  --

  demux_fifo_l : afifo_64i_16o
  generic map
  (
    C_FAMILY                  => C_FAMILY
  )
  port map
  (
      rst                     => framestart,

      wr_clk                  => clk,
      wr_en                   => BLC_VIDEO_SYNC(0), -- delayed version of CRC_PAR_DATA_IMGVALID_OUT
      din                     => demux_din,

      rd_clk                  => clk4x,
      rd_en                   => syncgen_de, --syncgen_pixelrequest,
      dout                    => demux_dout,

      empty                   => demux_empty,
      full                    => demux_full
  );

  demux_din(63 downto 58)  <= BLC_VIDEO_SYNC & framestart;
  demux_din(57 downto 48)  <= BLC_PAR_DATA_OUT( 9 downto  0);
  demux_din(47 downto 42)  <= BLC_VIDEO_SYNC & '0';
  demux_din(41 downto 32)  <= BLC_PAR_DATA_OUT(19 downto 10);
  demux_din(31 downto 26)  <= BLC_VIDEO_SYNC  & '0';
  demux_din(25 downto 16)  <= BLC_PAR_DATA_OUT(29 downto 20);
  demux_din(15 downto 10)  <= BLC_VIDEO_SYNC  & '0';
  demux_din( 9 downto  0)  <= BLC_PAR_DATA_OUT(39 downto 30);

  --
  -- Video Interface
  --

  VIDEO_8BIT_GEN : if (C_VIDEO_DATA_WIDTH = 8) generate
    video_8bit_oregs_l : process (clk4x)
    begin
      if rising_edge( clk4x ) then
--         video_vsync_o        <= demux_dout(15);
--         video_hsync_o        <= demux_dout(14);
--         video_vblank_o       <= demux_dout(13);
--         video_hblank_o       <= demux_dout(12);
--         video_active_video_o <= demux_dout(11);
--         fsync                <= demux_dout(10);
         video_vsync_o        <= syncgen_vsync;
         video_hsync_o        <= syncgen_hsync;
         video_vblank_o       <= syncgen_vblank;
         video_hblank_o       <= syncgen_hblank;
         video_active_video_o <= syncgen_de;
         fsync                <= framestart2_regen;
         video_data_o         <= demux_dout(9 downto 2);
      end if;
    end process;
  end generate VIDEO_8BIT_GEN;

  VIDEO_10BIT_GEN : if (C_VIDEO_DATA_WIDTH = 10) generate
    video_10bit_oregs_l : process (clk4x)
    begin
      if rising_edge( clk4x ) then
--         video_vsync_o        <= demux_dout(15);
--         video_hsync_o        <= demux_dout(14);
--         video_vblank_o       <= demux_dout(13);
--         video_hblank_o       <= demux_dout(12);
--         video_active_video_o <= demux_dout(11);
--         fsync               <= demux_dout(10);
         video_vsync_o        <= syncgen_vsync;
         video_hsync_o        <= syncgen_hsync;
         video_vblank_o       <= syncgen_vblank;
         video_hblank_o       <= syncgen_hblank;
         video_active_video_o <= syncgen_de;
         fsync               <= framestart2_regen;
         video_data_o   <= demux_dout(9 downto 0);
      end if;
    end process;
  end generate VIDEO_10BIT_GEN;

  VIDEO_16BIT_GEN : if (C_VIDEO_DATA_WIDTH = 16) generate
    video_16bit_oregs_l : process (clk4x)
    begin
      if rising_edge( clk4x ) then
--         video_vsync_o        <= demux_dout(15);
--         video_hsync_o        <= demux_dout(14);
--         video_vblank_o       <= demux_dout(13);
--         video_hblank_o       <= demux_dout(12);
--         video_active_video_o <= demux_dout(11);
--         fsync               <= demux_dout(10);
         video_vsync_o        <= syncgen_vsync;
         video_hsync_o        <= syncgen_hsync;
         video_vblank_o       <= syncgen_vblank;
         video_hblank_o       <= syncgen_hblank;
         video_active_video_o <= syncgen_de;
         fsync               <= framestart2_regen;
         video_data_o   <= X"80" & demux_dout(9 downto 2);
      end if;
    end process;
  end generate VIDEO_16BIT_GEN;

  VIDEO_24BIT_GEN : if (C_VIDEO_DATA_WIDTH = 24) generate
    video_24bit_oregs_l : process (clk4x)
    begin
      if rising_edge( clk4x ) then
--         video_vsync_o        <= demux_dout(15);
--         video_hsync_o        <= demux_dout(14);
--         video_vblank_o       <= demux_dout(13);
--         video_hblank_o       <= demux_dout(12);
--         video_active_video_o <= demux_dout(11);
--         fsync               <= demux_dout(10);
         video_vsync_o        <= syncgen_vsync;
         video_hsync_o        <= syncgen_hsync;
         video_vblank_o       <= syncgen_vblank;
         video_hblank_o       <= syncgen_hblank;
         video_active_video_o <= syncgen_de;
         fsync               <= framestart2_regen;
         video_data_o   <= demux_dout(9 downto 2) & demux_dout(9 downto 2) & demux_dout(9 downto 2);
      end if;
    end process;
  end generate VIDEO_24BIT_GEN;

end generate DEMUX_GEN;

DIRECT_OUTPUT_GEN : if (C_VIDEO_DIRECT_OUTPUT = 1) generate

  --
  -- Video Interface
  --

  VIDEO_40BIT_GEN : if (C_VIDEO_DATA_WIDTH = 40) generate
    video_40bit_oregs_l : process (clk)
    begin
      if rising_edge( clk ) then
         video_vsync_o        <= BLC_VIDEO_SYNC(4);
         video_hsync_o        <= BLC_VIDEO_SYNC(3);
         video_vblank_o       <= BLC_VIDEO_SYNC(2);
         video_hblank_o       <= BLC_VIDEO_SYNC(1);
         video_active_video_o <= BLC_VIDEO_SYNC(0);
         fsync                <= framestart;
         video_data_o         <= BLC_PAR_DATA_OUT(39 downto 30)
                               & BLC_PAR_DATA_OUT(29 downto 20)
                               & BLC_PAR_DATA_OUT(19 downto 10)
                               & BLC_PAR_DATA_OUT( 9 downto  0)
										;
      end if;
    end process;
  end generate VIDEO_40BIT_GEN;

  VIDEO_64BIT_GEN : if (C_VIDEO_DATA_WIDTH = 64) generate
    video_64bit_oregs_l : process (clk)
    begin
      if rising_edge( clk ) then
         video_vsync_o        <= BLC_VIDEO_SYNC(4);
         video_hsync_o        <= BLC_VIDEO_SYNC(3);
         video_vblank_o       <= BLC_VIDEO_SYNC(2);
         video_hblank_o       <= BLC_VIDEO_SYNC(1);
         video_active_video_o <= BLC_VIDEO_SYNC(0);
         fsync                <= framestart;
         video_data_o         <= "000000" & BLC_PAR_DATA_OUT(39 downto 30)
                               & "000000" & BLC_PAR_DATA_OUT(29 downto 20)
                               & "000000" & BLC_PAR_DATA_OUT(19 downto 10)
                               & "000000" & BLC_PAR_DATA_OUT( 9 downto  0)
                               ;
      end if;
    end process;
  end generate VIDEO_64BIT_GEN;

end generate DIRECT_OUTPUT_GEN;

  --
  -- I/O registers & buffers
  --

  clk_n <= not clk;
  oe_n  <= not oe;

  net0 <= '0';
  net1 <= '1';

   --io_oregs1_l : process (clk)
   --begin
   --   if Rising_Edge(clk) then
         vita_reset_n_o <= not host_vita_reset;
   --    vita_trigger_o <= (others => '0');
         --
         vita_reset_n_t    <= oe_n;
         vita_trigger_t    <= (others => oe_n);
   --   end if;
   --end process;

   S6_GEN : if (C_FAMILY = "spartan6") generate

      ODDR_vita_clk_pll_o : ODDR2 
         generic map (
            DDR_ALIGNMENT => "C0", -- "NONE", "C0" or "C1" 
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => vita_clk_pll_o,
            C0 => clk,
            C1 => clk_n,
            CE => net1,
            D0 => net0,
            D1 => net1,
            R  => net0,
            S  => net0);

      ODDR_vita_clk_pll_t : ODDR2 
         generic map (
            DDR_ALIGNMENT => "C0", -- "NONE", "C0" or "C1" 
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => vita_clk_pll_t,
            C0 => clk,
            C1 => clk_n,
            CE => net1,
            D0 => oe_n, 
            D1 => oe_n, 
            R  => net0, 
            S  => net0);

   end generate S6_GEN;

   V6_GEN : if (C_FAMILY = "virtex6" or C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate

      ODDR_vita_clk_pll_o : ODDR
         generic map (
              DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"  
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => vita_clk_pll_o,
            C  => clk,
            CE => net1,
            D1 => net0,
            D2 => net1,
            R  => net0,
            S  => net0);

      ODDR_vita_clk_pll_t : ODDR 
         generic map (
            DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"  
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => vita_clk_pll_t,
            C  => clk,
            CE => net1,
            D1 => oe_n, 
            D2 => oe_n, 
            R  => net0, 
            S  => net0);

   end generate V6_GEN;

   --
   -- Tri-stateable outputs
   --    Can be used to disable outputs to FMC connector
   --    until FMC module is correctly identified.
   -- 

   OBUFT_vita_reset_n : OBUFT
   port map (
      O => io_vita_reset_n,
      I => vita_reset_n_o,
      T => vita_reset_n_t
   );

   IO1: for I in 0 to 2 generate
      OBUFT_vita_trigger : OBUFT
      port map (
         O => io_vita_trigger(I),
         I => vita_trigger_o(I),
         T => vita_trigger_t(I)
      );
   end generate IO1;
   
   OBUFT_vita_clk_pll : OBUFT
   port map (
      O => io_vita_clk_pll,
      I => vita_clk_pll_o,
      T => vita_clk_pll_t
   );

   --
   -- Debug Ports
   --    Can be used to connect to ChipScope for debugging.
   --    Having a port makes these signals accessible for debug via EDK.
   -- 

   debug_iserdes_l : process (clk)
   begin
      if Rising_Edge(clk) then
         debug_iserdes_o( 49 downto   0) <= FIFO_DATAOUT;
         debug_iserdes_o(            50) <= FIFO_EMPTY;
         debug_iserdes_o(            51) <= host_iserdes_fifo_enable;
         debug_iserdes_o(            52) <= host_iserdes_auto_align;
         debug_iserdes_o(            53) <= host_iserdes_align_start;
         debug_iserdes_o(            54) <= host_iserdes_reset;
         debug_iserdes_o( 59 downto  55) <= EDGE_DETECT;
         debug_iserdes_o( 64 downto  60) <= TRAINING_DETECT;
         debug_iserdes_o( 69 downto  65) <= STABLE_DETECT;
         debug_iserdes_o( 74 downto  70) <= FIRST_EDGE_FOUND;
         debug_iserdes_o( 79 downto  75) <= SECOND_EDGE_FOUND;
         debug_iserdes_o( 89 downto  80) <= host_iserdes_training;
         debug_iserdes_o( 99 downto  90) <= host_iserdes_manual_tap;
         debug_iserdes_o(115 downto 100) <= CLK_STATUS;
         debug_iserdes_o(           116) <= CLK_RDY;
         debug_iserdes_o(           117) <= ALIGN_BUSY;
         debug_iserdes_o(           118) <= ALIGNED;
         debug_iserdes_o(           119) <= '0';
         debug_iserdes_o(124 downto 120) <= WORD_ALIGN;
         debug_iserdes_o(129 downto 125) <= TIMEOUTONACK;
         debug_iserdes_o(179 downto 130) <= TAP_SETTING;
         debug_iserdes_o(229 downto 180) <= WINDOW_WIDTH;
         --debug_iserdes_o(309 downto 230) <= NROF_RETRIES;
      end if;
   end process;

   debug_decoder_l : process (clk)
   begin
      if Rising_Edge(clk) then
         debug_decoder_o( 49 downto   0) <= FIFO_DATAOUT;
         debug_decoder_o(            50) <= FIFO_EMPTY;
         debug_decoder_o(            51) <= FIFO_RDEN;
         debug_decoder_o(            52) <= host_iserdes_fifo_enable;
         debug_decoder_o(            53) <= host_decoder_enable;
         debug_decoder_o(            54) <= framestart;
         debug_decoder_o(            55) <= windowstart;
         debug_decoder_o(            56) <= windowend;
         debug_decoder_o(            57) <= linestart;
         debug_decoder_o(            58) <= lineend;
         debug_decoder_o(            59) <= blacklinestart;
         debug_decoder_o(            60) <= blacklineend;
         debug_decoder_o(            61) <= imagelinestart;
         debug_decoder_o(            62) <= imagelineend;
         debug_decoder_o(            63) <= validcrc;
         debug_decoder_o( 67 downto  64) <= CRC_STATUS(NROF_CONN - 2 downto 0);

         debug_decoder_o( 77 downto  68) <= SYNC_PAR_SYNCOUT;
         debug_decoder_o(117 downto  78) <= SYNC_PAR_DATAOUT;
         debug_decoder_o(           118) <= SYNC_PAR_DATA_IMGVALID;
         debug_decoder_o(           119) <= SYNC_PAR_DATA_BLACKVALID;
         debug_decoder_o(           120) <= validcrc;
         debug_decoder_o(           121) <= SYNC_PAR_DATA_LINE;
         debug_decoder_o(           122) <= SYNC_PAR_DATA_FRAME;
         debug_decoder_o(           123) <= SYNC_START_KERNEL;
         debug_decoder_o(           124) <= SYNC_KERNEL_ODD_EVEN;

--         debug_decoder_o(134 downto 125) <= CRC_PAR_SYNC_OUT;
--         debug_decoder_o(174 downto 135) <= CRC_PAR_DATA_OUT;
--         debug_decoder_o(           175) <= CRC_PAR_DATA_IMGVALID_OUT;
--         debug_decoder_o(           176) <= CRC_PAR_DATA_BLACKVALID_OUT;
--         debug_decoder_o(           177) <= CRC_PAR_DATA_CRCVALID_OUT;
--         debug_decoder_o(           178) <= CRC_PAR_DATA_LINE_OUT;
--         debug_decoder_o(           179) <= CRC_PAR_DATA_FRAME_OUT;
--         debug_decoder_o(           180) <= CRC_START_KERNEL;
--         debug_decoder_o(           181) <= CRC_KERNEL_ODD_EVEN;
--         debug_decoder_o(134 downto 125) <= (others => '0');
         debug_decoder_o(           125) <= CRC_PAR_DATA_FRAME_OUT;
         debug_decoder_o(           126) <= CRC_PAR_DATA_LINE_OUT;
         debug_decoder_o(           127) <= CRC_PAR_DATA_CRCVALID_OUT;
         debug_decoder_o(           128) <= CRC_PAR_DATA_BLACKVALID_OUT;
         debug_decoder_o(           129) <= CRC_PAR_DATA_IMGVALID_OUT;
         debug_decoder_o(           130) <= syncgen_de;
         debug_decoder_o(           131) <= syncgen_hblank;
         debug_decoder_o(           132) <= syncgen_vblank;
         debug_decoder_o(           133) <= syncgen_hsync;
         debug_decoder_o(           134) <= syncgen_vsync;
         debug_decoder_o(174 downto 135) <= REMAP_PAR_DATA_OUT;
         debug_decoder_o(           175) <= REMAP_PAR_DATA_VALID_OUT;
         debug_decoder_o(           176) <= REMAP_PAR_DATA_LINE_OUT;
         debug_decoder_o(           177) <= REMAP_PAR_DATA_FRAME_OUT;
         debug_decoder_o(           178) <= REMAP_PAR_DATA_WINDOW_OUT;
         debug_decoder_o(           179) <= host_remapper_write_cfg(0);
         debug_decoder_o(           180) <= host_remapper_write_cfg(1);
         debug_decoder_o(           181) <= host_remapper_write_cfg(2);

         debug_decoder_o(           182) <= REMAP_VIDEO_SYNC(3); -- hsync
         debug_decoder_o(           183) <= REMAP_VIDEO_SYNC(4); -- vsync
         debug_decoder_o(           184) <= REMAP_VIDEO_SYNC(0); -- de
         debug_decoder_o(           185) <= REMAP_VIDEO_SYNC(1); -- hblank
         debug_decoder_o(           186) <= REMAP_VIDEO_SYNC(2); -- vblank

      end if;
   end process;

   debug_crc_l : process (clk)
   begin
      if Rising_Edge(clk) then
        debug_crc_o( 3 downto  0) <= CRC_STATUS;
        debug_crc_o(87 downto  4) <= (others => '0'); --CRC_DEBUG;
      end if;
   end process;

   debug_syncgen_l : process (clk)
   begin
      if Rising_Edge(clk) then
        debug_syncgen_o(          37)   <= syncgen_vsync;
        debug_syncgen_o(          36)   <= syncgen_hsync;
        debug_syncgen_o(          35)   <= syncgen_vblank;
        debug_syncgen_o(          34)   <= syncgen_hblank;
        debug_syncgen_o(          33)   <= syncgen_de;
        debug_syncgen_o(          32)   <= syncgen_pixelrequest;
        debug_syncgen_o(31 downto 16)   <= syncgen_vcount;
        debug_syncgen_o(15 downto  0)   <= syncgen_hcount;
      end if;
   end process;

   debug_video_l : process (clk4x)
   begin
      if Rising_Edge(clk4x) then
        debug_video_o(10 downto  0)   <= demux_dout(10 downto 0);
        debug_video_o(          11)   <= syncgen_de;
        debug_video_o(          12)   <= syncgen_hblank;
        debug_video_o(          13)   <= syncgen_vblank;
        debug_video_o(          14)   <= syncgen_hsync;
        debug_video_o(          15)   <= syncgen_vsync;
        debug_video_o(          16)   <= demux_empty;
        debug_video_o(          17)   <= demux_full;
        debug_video_o(          18)   <= syncgen_de; --syncgen_pixelrequest; 
        debug_video_o(          19)   <= framestart2_regen;
        debug_video_o(          20)   <= framestart2;
        debug_video_o(          21)   <= framestart;
        debug_video_o(          22)   <= BLC_VIDEO_SYNC(0);
        debug_video_o(          23)   <= CRC_PAR_DATA_IMGVALID_OUT;
        debug_video_o(          24)   <= CRC_PAR_DATA_BLACKVALID_OUT;
        debug_video_o(          25)   <= CRC_PAR_DATA_CRCVALID_OUT;
        debug_video_o(          26)   <= CRC_PAR_DATA_LINE_OUT;
        debug_video_o(          27)   <= CRC_PAR_DATA_FRAME_OUT;
        debug_video_o(          28)   <= CRC_START_KERNEL;
        debug_video_o(          29)   <= CRC_KERNEL_ODD_EVEN;
        debug_video_o(          30)   <= clk;
        debug_video_o(          31)   <= '0';
      end if;
   end process;

   debug_triggen_l : process (clk)
   begin
      if Rising_Edge(clk) then
        debug_triggen_o( 2 downto  0)   <= host_triggen_enable;
        debug_triggen_o(           3)   <= host_triggen_sync2readout(0);
        debug_triggen_o(           4)   <= host_triggen_readouttrigger;
        debug_triggen_o(           5)   <= trigger1; 
        debug_triggen_o(           6)   <= '0'; --readouttrigger_d2;
        debug_triggen_o( 9 downto  7)   <= vita_trigger_o;
      end if;
   end process;

end rtl;
