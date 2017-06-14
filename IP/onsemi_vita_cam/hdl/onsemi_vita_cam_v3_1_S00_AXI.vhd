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
-- Create Date:         Nov 14, 2013
-- Design Name:         ON Semiconductor VITA camera receiver
-- Module Name:         onsemi_vita_cam_v3_1_S00_AXI.vhd
-- Project Name:        ON Semiconductor VITA camera receiver
-- Target Devices:      Zynq-7000
-- Avnet Boards:        FMC-IMAGEON + VITA-2000, EMBV + PYTYHON-1300-C
--
-- Tool versions:       Vivado 2014.4
--
-- Description:         ON Semiconductor VITA camera receiver - User Logic.
--                      This layer implements the following programming model
--                         0x00 - CORE_VERSION
--                                [31:24] VERSION_MAJOR
--                                [23:16] VERSION_MINOR
--                                [15: 0] VERSION_PATCH
--                         0x04 - CORE_ID = 0x4F4E5643 (ASCII for "ONVC")

--                         0x0C - VITA_CONTROL
--                                   [ 0] VITA_RESET
--                         0x10 - ISERDES_CONTROL
--                                   [ 0] ISERDES_RESET
--                                   [ 1] ISERDES_AUTO_ALIGN
--                                   [ 2] ISERDES_ALIGN_START
--                                   [ 3] ISERDES_FIFO_ENABLE
--                                   [ 8] ISERDES_CLK_READY
--                                   [ 9] ISERDES_ALIGN_BUSY
--                                   [10] ISERDES_ALIGNED
--                                [23:16] ISERDES_TXCLK_STATUS
--                                [31:24] ISERDES_RXCLK_STATUS
--                         0x14 - ISERDES_TRAINING
--                         0x18 - ISERDES_MANUAL_TAP
--                         0x1C - {unused}
--                         0x20 - DECODER_CONTROL
--                                   [0] DECODER_RESET
--                                   [1] DECODER_ENABLE
--                         0x24 - DECODER_STARTODDEVEN
--                         0x28 - DECODER_CODES_LS_LE
--                                   [15: 0] CODE_LS
--                                   [31:16] CODE_LE
--                         0x2C - DECODER_CODES_FS_FE
--                                   [15: 0] CODE_FS
--                                   [31:16] CODE_FE
--                         0x30 - DECODER_CODES_BL_IMG
--                                   [15: 0] CODE_BL
--                                   [31:16] CODE_IMG
--                         0x34 - DECODER_CODES_TR_CRC
--                                   [15: 0] CODE_TR
--                                   [31:16] CODE_CRC
--                         0x38 - DECODER_CNT_BLACK_LINES
--                         0x3C - DECODER_CNT_IMAGE_LINES
--                         0x40 - DECODER_CNT_BLACK_PIXELS
--                         0x44 - DECODER_CNT_IMAGE_PIXELS
--                         0x48 - DECODER_CNT_FRAMES
--                         0x4C - DECODER_CNT_WINDOWS
--                         0x50 - DECODER_CNT_CLOCKS
--                         0x54 - DECODER_CNT_START_LINES
--                         0x58 - DECODER_CNT_END_LINES
--                         0x5C - SYNCGEN_DELAY
--                                   [15: 0] DELAY
--                         0x60 - SYNCGEN_HTIMING1
--                                   [15: 0] HACTIVE
--                                   [31:16] HFPORCH
--                         0x64 - SYNCGEN_HTIMING2
--                                   [15: 0] HSYNC
--                                   [31:16] HBPORCH
--                         0x68 - SYNCGEN_VTIMING1
--                                   [15: 0] VACTIVE
--                                   [31:16] VFPORCH
--                         0x6C - SYNCGEN_VTIMING2
--                                   [15: 0] VSYNC
--                                   [31:16] VBPORCH
--                         0x70 - CRC_CONTROL
--                                   [0] CRC_RESET
--                                   [1] CRC_INITVALUE
--                         0x74 - CRC_STATUS
--                         0x78 - REMAPPER_CONTROL[7:0]
--                                   [2:0] REMAPPER_WRITE_CFG
--                                   [6:4] REMAPPER_MODE
--                         0x7C - {unused}
--                         0x80 - FPN_PRNU_VALUES[ 31:  0]
--                                  [ 7: 0] PRNU_0
--                                  [15: 8] FPN_0
--                                  [23:16] PRNU_1
--                                  [31:24] FPN_1
--                         0x84 - FPN_PRNU_VALUES[ 63: 32]
--                                  [ 7: 0] PRNU_2
--                                  [15: 8] FPN_2
--                                  [23:16] PRNU_3
--                                  [31:24] FPN_3
--                         0x88 - FPN_PRNU_VALUES[ 95: 64]
--                         0x8C - FPN_PRNU_VALUES[127: 96]
--                         0x90 - FPN_PRNU_VALUES[159:128]
--                         0x94 - FPN_PRNU_VALUES[191:160]
--                         0x98 - FPN_PRNU_VALUES[223:192]
--                         0x9C - FPN_PRNU_VALUES[255:224]
--                                  [ 7: 0] PRNU_14
--                                  [15: 8] FPN_14
--                                  [23:16] PRNU_15
--                                  [31:24] FPN_15
--                         0xA0 - {unused}
--                         0xA4 - {unused}
--                         0xA8 - {unused}
--                         0xAC - {unused}
--                         0xB0 - {unused}
--                         0xB4 - {unused}
--                         0xB8 - {unused}
--                         0xBC - {unused}
--                         0xC0 - DECODER_CNT_MONITOR0_HIGH
--                         0xC4 - DECODER_CNT_MONITOR0_LOW
--                         0xC8 - DECODER_CNT_MONITOR1_HIGH
--                         0xCC - DECODER_CNT_MONITOR1_LOW
--                         0xD0 - {unused}
--                         0xD4 - {unused}
--                         0xD8 - {unused}
--                         0xDC - TRIGGEN_EXT_DEBOUNCE
--                         0xE0 - TRIGGEN_CONTROL
--                                [ 2: 0] TRIGGEN_ENABLE
--                                [ 6: 4] TRIGGEN_SYNC2READOUT
--                                [    8] TRIGGEN_READOUTTRIGGER
--                                [   16] TRIGGEN_EXT_POLARITY
--                                [   24] TRIGGEN_CNT_UPDATE
--                                [30:28] TRIGGEN_GEN_POLARITY
--                         0xE4 - TRIGGEN_DEFAULT_FREQ
--                         0xE8 - TRIGGEN_TRIG0_HIGH
--                         0xEC - TRIGGEN_TRIG0_LOW
--                         0xF0 - TRIGGEN_TRIG1_HIGH
--                         0xF4 - TRIGGEN_TRIG1_LOW
--                         0xF8 - TRIGGEN_TRIG2_HIGH
--                         0xFC - TRIGGEN_TRIG2_LOW
--
--
-- Dependencies:        
--
-- Revision:            Nov 14, 2013: 2.0  Re-create core with Vivado 2013.3
--                      Dec 24, 2013: 2.1  - remove debug_host debug port
--                                         - add debug_syncgen debug port
--                                         - replace clk/clk4x with single clk
--                                           (implement div4 logic inside core)
--                      Jun 18, 2014: 2.3  - add C_INCLUDE_BLC parameter to optionnally
--                                           remove correct_column_fpn_prnu_dsp48e module
--                                         - add C_INCLUDE_MONITOR to optionnally
--                                           remove monitor logic inside syncchanneldecoder
------------------------------------------------------------------
--                      Jan 26, 2015: 3.1  - Rename to onsemi_vita_cam_*
--                                         - Modifications for linux device driver
--                                            - move SPI to seperate core
--                                            - remove reset pin (will be implemented with GPIO
--                      Feb 23, 2015: 3.1  - Add version register for semantic versioning
--                                           ref : http://semver.org 
--                      Jun 02, 2017: 3.3  - Change version to 3.3.0
--
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity onsemi_vita_cam_v3_1_S00_AXI is
	generic (
		-- Users to add parameters here
		C_VIDEO_DATA_WIDTH             : integer              := 10;
		C_VIDEO_DIRECT_OUTPUT          : integer              := 0;
		--C_VIDEO_USE_SYNCGEN            : integer              := 1;
        C_IO_VITA_DATA_WIDTH           : integer              := 4;
        C_INCLUDE_BLC                  : integer := 0;
        C_INCLUDE_MONITOR              : integer := 0;        
		C_FAMILY                       : string               := "zynq";
		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 8
	);
	port (
		-- Users to add ports here
		clk200                         : in  std_logic;
		clk                            : in  std_logic;
		reset                          : in  std_logic;
		oe                             : in  std_logic;
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
		video_vsync                    : out  std_logic;
		video_hsync                    : out  std_logic;
		video_vblank                   : out  std_logic;
		video_hblank                   : out  std_logic;
		video_active_video             : out  std_logic;
		video_data                     : out  std_logic_vector((C_VIDEO_DATA_WIDTH-1) downto 0);
		-- Debug Ports
		debug_iserdes_o                : out std_logic_vector(229 downto 0);
		debug_decoder_o                : out std_logic_vector(186 downto 0);
		debug_crc_o                    : out std_logic_vector( 87 downto 0);
		debug_triggen_o                : out std_logic_vector(  9 downto 0);
        debug_syncgen_o                : out std_logic_vector( 37 downto 0);
		debug_video_o                  : out std_logic_vector( 31 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    -- privilege and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    -- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    -- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    -- valid data. There is one write strobe bit for each eight
    -- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    -- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    -- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    -- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    -- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    -- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether the
    -- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    -- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    -- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    -- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    -- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end onsemi_vita_cam_v3_1_S00_AXI;

architecture arch_imp of onsemi_vita_cam_v3_1_S00_AXI is

	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := 5;
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
	---- Number of Slave Registers 64
	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg8	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg9	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg10	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg11	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg12	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg13	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg14	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg15	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg16	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg17	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg18	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg19	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg20	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg21	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg22	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg23	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg24	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg25	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg26	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg27	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg28	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg29	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg30	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg31	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg32	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg33	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg34	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg35	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg36	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg37	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg38	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg39	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg40	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg41	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg42	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg43	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg44	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg45	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg46	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg47	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg48	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg49	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg50	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg51	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg52	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg53	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg54	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg55	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg56	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg57	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg58	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg59	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg60	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg61	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg62	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg63	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;

    -- read back register content
	--
	signal slv_reg3_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	--
	signal slv_reg14_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg15_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg16_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg17_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg18_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg19_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg20_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg21_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg22_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	--
	signal slv_reg29_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	--
	signal slv_reg48_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg49_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg50_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg51_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	

	------------------------------------------
    -- HOST Interface - VITA
    ------------------------------------------
	signal host_vita_reset                : std_logic;

    ------------------------------------------
    -- HOST Interface - ISERDES
    ------------------------------------------
	signal host_iserdes_reset             : std_logic;
	signal host_iserdes_auto_align        : std_logic;
	signal host_iserdes_align_start       : std_logic;
	signal host_iserdes_fifo_enable       : std_logic;
	signal host_iserdes_manual_tap        : std_logic_vector(9 downto 0);
	signal host_iserdes_training          : std_logic_vector(9 downto 0);
	--
	signal host_iserdes_clk_ready         : std_logic;
	signal host_iserdes_clk_status        : std_logic_vector(15 downto 0);
	signal host_iserdes_align_busy        : std_logic;
	signal host_iserdes_aligned           : std_logic;

	------------------------------------------
    -- HOST Interface - Sync Channel Decoder
    ------------------------------------------
	signal host_decoder_reset             : std_logic;
	signal host_decoder_enable            : std_logic;
	signal host_decoder_startoddeven      : std_logic_vector(31 downto 0);
	signal host_decoder_code_ls           : std_logic_vector(9 downto 0);
	signal host_decoder_code_le           : std_logic_vector(9 downto 0);
	signal host_decoder_code_fs           : std_logic_vector(9 downto 0);
	signal host_decoder_code_fe           : std_logic_vector(9 downto 0);
	signal host_decoder_code_bl           : std_logic_vector(9 downto 0);
	signal host_decoder_code_img          : std_logic_vector(9 downto 0);
	signal host_decoder_code_tr           : std_logic_vector(9 downto 0);
	signal host_decoder_code_crc          : std_logic_vector(9 downto 0);
	signal host_decoder_frame_start       : std_logic;
	signal host_decoder_cnt_black_lines   : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_image_lines   : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_black_pixels  : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_image_pixels  : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_frames        : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_windows       : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_clocks        : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_start_lines   : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_end_lines     : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_monitor0high  : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_monitor0low   : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_monitor1high  : std_logic_vector(31 downto 0);
	signal host_decoder_cnt_monitor1low   : std_logic_vector(31 downto 0);

    ------------------------------------------
    -- HOST Interface - CRC Checker
    ------------------------------------------
	signal host_crc_reset                 : std_logic;
	signal host_crc_initvalue             : std_logic;
	signal host_crc_status                : std_logic_vector(31 downto 0);

    ------------------------------------------
    -- HOST Interface - Data Channel Remapper
    ------------------------------------------
	signal host_remapper_write_cfg        : std_logic_vector(2 downto 0);
	signal host_remapper_mode             : std_logic_vector(2 downto 0);

    ------------------------------------------
    -- HOST Interface - Trigger Generator
    ------------------------------------------
	signal host_triggen_enable            : std_logic_vector(2 downto 0);
	signal host_triggen_sync2readout      : std_logic_vector(2 downto 0);
	signal host_triggen_readouttrigger    : std_logic;
	signal host_triggen_default_freq      : std_logic_vector(31 downto 0);
	signal host_triggen_cnt_trigger0high  : std_logic_vector(31 downto 0);
	signal host_triggen_cnt_trigger0low   : std_logic_vector(31 downto 0);
	signal host_triggen_cnt_trigger1high  : std_logic_vector(31 downto 0);
	signal host_triggen_cnt_trigger1low   : std_logic_vector(31 downto 0);
	signal host_triggen_cnt_trigger2high  : std_logic_vector(31 downto 0);
	signal host_triggen_cnt_trigger2low   : std_logic_vector(31 downto 0);
	signal host_triggen_ext_debounce      : std_logic_vector(31 downto 0);
	signal host_triggen_ext_polarity      : std_logic;
	signal host_triggen_cnt_update        : std_logic;  
	signal host_triggen_gen_polarity      : std_logic_vector(2 downto 0);

    ------------------------------------------
    -- HOST Interface - FPN/PRNU Correction
    ------------------------------------------
	signal host_fpn_prnu_values           : std_logic_vector((16*16)-1 downto 0);
  
    ------------------------------------------
    -- HOST Interface - Sync Generator
    ------------------------------------------
	signal host_syncgen_delay             : std_logic_vector(15 downto 0);
	signal host_syncgen_hactive           : std_logic_vector(15 downto 0);
	signal host_syncgen_hfporch           : std_logic_vector(15 downto 0);
	signal host_syncgen_hsync             : std_logic_vector(15 downto 0);
	signal host_syncgen_hbporch           : std_logic_vector(15 downto 0);
	signal host_syncgen_vactive           : std_logic_vector(15 downto 0);
	signal host_syncgen_vfporch           : std_logic_vector(15 downto 0);
	signal host_syncgen_vsync             : std_logic_vector(15 downto 0);
	signal host_syncgen_vbporch           : std_logic_vector(15 downto 0);

    ------------------------------------------
    -- Clock Divide by 4 logic
    ------------------------------------------

    constant zero            : std_logic := '0';
    constant one             : std_logic := '1';

    signal vita_clk          : std_logic;
    signal vita_clk4x        : std_logic;

    ------------------------------------------
    -- VITA Camera Receiver Core Logic
    ------------------------------------------

    constant CORE_VERSION                 : std_logic_vector(31 downto 0) := X"03030000"; -- 3.3.0
    constant CORE_ID                      : std_logic_vector(31 downto 0) := X"4F4E5643"; -- ASCII for "ONVC" 

component onsemi_vita_cam_core is
  Generic
  (
    C_VIDEO_DATA_WIDTH             : integer := 10;
    C_VIDEO_DIRECT_OUTPUT          : integer := 0;
    --C_VIDEO_USE_SYNCGEN            : integer := 1;
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
end component onsemi_vita_cam_core;

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	        axi_awready <= '1';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      --
	      slv_reg3 <= (others => '0');
	      slv_reg4 <= (others => '0');
	      slv_reg5 <= (others => '0');
	      slv_reg6 <= (others => '0');
	      slv_reg7 <= (others => '0');
	      slv_reg8 <= (others => '0');
	      slv_reg9 <= (others => '0');
	      slv_reg10 <= (others => '0');
	      slv_reg11 <= (others => '0');
	      slv_reg12 <= (others => '0');
	      slv_reg13 <= (others => '0');
	      slv_reg14 <= (others => '0');
	      slv_reg15 <= (others => '0');
	      slv_reg16 <= (others => '0');
	      slv_reg17 <= (others => '0');
	      slv_reg18 <= (others => '0');
	      slv_reg19 <= (others => '0');
	      slv_reg20 <= (others => '0');
	      slv_reg21 <= (others => '0');
	      slv_reg22 <= (others => '0');
	      slv_reg23 <= (others => '0');
	      slv_reg24 <= (others => '0');
	      slv_reg25 <= (others => '0');
	      slv_reg26 <= (others => '0');
	      slv_reg27 <= (others => '0');
	      slv_reg28 <= (others => '0');
	      slv_reg29 <= (others => '0');
	      slv_reg30 <= (others => '0');
	      slv_reg31 <= (others => '0');
	      --
	      --
	      slv_reg48 <= (others => '0');
	      slv_reg49 <= (others => '0');
	      slv_reg50 <= (others => '0');
	      slv_reg51 <= (others => '0');
	      --
	      slv_reg55 <= (others => '0');
	      slv_reg56 <= (others => '0');
	      slv_reg57 <= (others => '0');
	      slv_reg58 <= (others => '0');
	      slv_reg59 <= (others => '0');
	      slv_reg60 <= (others => '0');
	      slv_reg61 <= (others => '0');
	      slv_reg62 <= (others => '0');
	      slv_reg63 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"000011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 3
	                slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 4
	                slv_reg4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 5
	                slv_reg5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 6
	                slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"000111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 7
	                slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 8
	                slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 9
	                slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 10
	                slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 11
	                slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 12
	                slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 13
	                slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 14
	                slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"001111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 15
	                slv_reg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 16
	                slv_reg16(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 17
	                slv_reg17(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 18
	                slv_reg18(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 19
	                slv_reg19(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 20
	                slv_reg20(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 21
	                slv_reg21(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 22
	                slv_reg22(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"010111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 23
	                slv_reg23(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 24
	                slv_reg24(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 25
	                slv_reg25(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 26
	                slv_reg26(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 27
	                slv_reg27(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 28
	                slv_reg28(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 29
	                slv_reg29(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 30
	                slv_reg30(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"011111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 31
	                slv_reg31(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          --
	          --
	          when b"110000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 48
	                slv_reg48(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"110001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 49
	                slv_reg49(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"110010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 50
	                slv_reg50(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"110011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 51
	                slv_reg51(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          --
	          when b"110111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 55
	                slv_reg55(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 56
	                slv_reg56(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 57
	                slv_reg57(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 58
	                slv_reg58(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 59
	                slv_reg59(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 60
	                slv_reg60(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 61
	                slv_reg61(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 62
	                slv_reg62(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"111111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 63
	                slv_reg63(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when others =>
	            slv_reg3 <= slv_reg3;
	            slv_reg4 <= slv_reg4;
	            slv_reg5 <= slv_reg5;
	            slv_reg6 <= slv_reg6;
	            slv_reg7 <= slv_reg7;
	            slv_reg8 <= slv_reg8;
	            slv_reg9 <= slv_reg9;
	            slv_reg10 <= slv_reg10;
	            slv_reg11 <= slv_reg11;
	            slv_reg12 <= slv_reg12;
	            slv_reg13 <= slv_reg13;
	            slv_reg14 <= slv_reg14;
	            slv_reg15 <= slv_reg15;
	            slv_reg16 <= slv_reg16;
	            slv_reg17 <= slv_reg17;
	            slv_reg18 <= slv_reg18;
	            slv_reg19 <= slv_reg19;
	            slv_reg20 <= slv_reg20;
	            slv_reg21 <= slv_reg21;
	            slv_reg22 <= slv_reg22;
	            slv_reg23 <= slv_reg23;
	            slv_reg24 <= slv_reg24;
	            slv_reg25 <= slv_reg25;
	            slv_reg26 <= slv_reg26;
	            slv_reg27 <= slv_reg27;
	            slv_reg28 <= slv_reg28;
	            slv_reg29 <= slv_reg29;
	            slv_reg30 <= slv_reg30;
	            slv_reg31 <= slv_reg31;
	            --
	            --
	            slv_reg48 <= slv_reg48;
	            slv_reg49 <= slv_reg49;
	            slv_reg50 <= slv_reg50;
	            slv_reg51 <= slv_reg51;
	            --
	            slv_reg55 <= slv_reg55;
	            slv_reg56 <= slv_reg56;
	            slv_reg57 <= slv_reg57;
	            slv_reg58 <= slv_reg58;
	            slv_reg59 <= slv_reg59;
	            slv_reg60 <= slv_reg60;
	            slv_reg61 <= slv_reg61;
	            slv_reg62 <= slv_reg62;
	            slv_reg63 <= slv_reg63;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

WITH_BLC_1 : if (C_INCLUDE_BLC = 1) generate
	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      slv_reg32 <= (others => '0');
	      slv_reg33 <= (others => '0');
	      slv_reg34 <= (others => '0');
	      slv_reg35 <= (others => '0');
	      slv_reg36 <= (others => '0');
	      slv_reg37 <= (others => '0');
	      slv_reg38 <= (others => '0');
	      slv_reg39 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"100000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 32
	                slv_reg32(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"100001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 33
	                slv_reg33(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"100010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 34
	                slv_reg34(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"100011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 35
	                slv_reg35(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"100100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 36
	                slv_reg36(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"100101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 37
	                slv_reg37(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"100110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 38
	                slv_reg38(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"100111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 39
	                slv_reg39(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when others =>
	            slv_reg32 <= slv_reg32;
	            slv_reg33 <= slv_reg33;
	            slv_reg34 <= slv_reg34;
	            slv_reg35 <= slv_reg35;
	            slv_reg36 <= slv_reg36;
	            slv_reg37 <= slv_reg37;
	            slv_reg38 <= slv_reg38;
	            slv_reg39 <= slv_reg39;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 
end generate WITH_BLC_1;
WITHOUT_BLC_1 : if (C_INCLUDE_BLC = 0) generate
 	slv_reg32 <= (others => '0');
 	slv_reg33 <= (others => '0');
 	slv_reg34 <= (others => '0');
 	slv_reg35 <= (others => '0');
 	slv_reg36 <= (others => '0');
 	slv_reg37 <= (others => '0');
 	slv_reg38 <= (others => '0');
 	slv_reg39 <= (others => '0');
end generate WITHOUT_BLC_1;

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, slv_reg16, slv_reg17, slv_reg18, slv_reg19, slv_reg20, slv_reg21, slv_reg22, slv_reg23, slv_reg24, slv_reg25, slv_reg26, slv_reg27, slv_reg28, slv_reg29, slv_reg30, slv_reg31, slv_reg32, slv_reg33, slv_reg34, slv_reg35, slv_reg36, slv_reg37, slv_reg38, slv_reg39, slv_reg40, slv_reg41, slv_reg42, slv_reg43, slv_reg44, slv_reg45, slv_reg46, slv_reg47, slv_reg48, slv_reg49, slv_reg50, slv_reg51, slv_reg52, slv_reg53, slv_reg54, slv_reg55, slv_reg56, slv_reg57, slv_reg58, slv_reg59, slv_reg60, slv_reg61, slv_reg62, slv_reg63, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin
	  if S_AXI_ARESETN = '0' then
	    reg_data_out  <= (others => '1');
	  else
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"000000" =>
	        reg_data_out <= CORE_VERSION;
	      when b"000001" =>
	        reg_data_out <= CORE_ID;
	      --
	      when b"000011" =>
	        reg_data_out <= slv_reg3_r1; --slv_reg3;
	      when b"000100" =>
	        reg_data_out <= slv_reg4_r1; --slv_reg4;
	      when b"000101" =>
	        reg_data_out <= slv_reg5;
	      when b"000110" =>
	        reg_data_out <= slv_reg6;
	      when b"000111" =>
	        reg_data_out <= slv_reg7;
	      when b"001000" =>
	        reg_data_out <= slv_reg8;
	      when b"001001" =>
	        reg_data_out <= slv_reg9;
	      when b"001010" =>
	        reg_data_out <= slv_reg10;
	      when b"001011" =>
	        reg_data_out <= slv_reg11;
	      when b"001100" =>
	        reg_data_out <= slv_reg12;
	      when b"001101" =>
	        reg_data_out <= slv_reg13;
	      when b"001110" =>
	        reg_data_out <= slv_reg14_r1; --slv_reg14;
	      when b"001111" =>
	        reg_data_out <= slv_reg15_r1; --slv_reg15;
	      when b"010000" =>
	        reg_data_out <= slv_reg16_r1; --slv_reg16;
	      when b"010001" =>
	        reg_data_out <= slv_reg17_r1; --slv_reg17;
	      when b"010010" =>
	        reg_data_out <= slv_reg18_r1; --slv_reg18;
	      when b"010011" =>
	        reg_data_out <= slv_reg19_r1; --slv_reg19;
	      when b"010100" =>
	        reg_data_out <= slv_reg20_r1; --slv_reg20;
	      when b"010101" =>
	        reg_data_out <= slv_reg21_r1; --slv_reg21;
	      when b"010110" =>
	        reg_data_out <= slv_reg22_r1; --slv_reg22;
	      when b"010111" =>
	        reg_data_out <= slv_reg23;
	      when b"011000" =>
	        reg_data_out <= slv_reg24;
	      when b"011001" =>
	        reg_data_out <= slv_reg25;
	      when b"011010" =>
	        reg_data_out <= slv_reg26;
	      when b"011011" =>
	        reg_data_out <= slv_reg27;
	      when b"011100" =>
	        reg_data_out <= slv_reg28;
	      when b"011101" =>
	        reg_data_out <= slv_reg29_r1; --slv_reg29;
	      when b"011110" =>
	        reg_data_out <= slv_reg30;
	      when b"011111" =>
	        reg_data_out <= slv_reg31;
	      when b"100000" =>
	        reg_data_out <= slv_reg32;
	      when b"100001" =>
	        reg_data_out <= slv_reg33;
	      when b"100010" =>
	        reg_data_out <= slv_reg34;
	      when b"100011" =>
	        reg_data_out <= slv_reg35;
	      when b"100100" =>
	        reg_data_out <= slv_reg36;
	      when b"100101" =>
	        reg_data_out <= slv_reg37;
	      when b"100110" =>
	        reg_data_out <= slv_reg38;
	      when b"100111" =>
	        reg_data_out <= slv_reg39;
	      when b"101000" =>
	        reg_data_out <= (others => '0'); --slv_reg40;
	      when b"101001" =>
	        reg_data_out <= (others => '0'); --slv_reg41;
	      when b"101010" =>
	        reg_data_out <= (others => '0'); --slv_reg42;
	      when b"101011" =>
	        reg_data_out <= (others => '0'); --slv_reg43;
	      when b"101100" =>
	        reg_data_out <= (others => '0'); --slv_reg44;
	      when b"101101" =>
	        reg_data_out <= (others => '0'); --slv_reg45;
	      when b"101110" =>
	        reg_data_out <= (others => '0'); --slv_reg46;
	      when b"101111" =>
	        reg_data_out <= (others => '0'); --slv_reg47;
	      when b"110000" =>
	        reg_data_out <= slv_reg48_r1; --slv_reg48;
	      when b"110001" =>
	        reg_data_out <= slv_reg49_r1; --slv_reg49;
	      when b"110010" =>
	        reg_data_out <= slv_reg50_r1; --slv_reg50;
	      when b"110011" =>
	        reg_data_out <= slv_reg51_r1; --slv_reg51;
	      when b"110100" =>
	        reg_data_out <= (others => '0'); --slv_reg52;
	      when b"110101" =>
	        reg_data_out <= (others => '0'); --slv_reg53;
	      when b"110110" =>
	        reg_data_out <= (others => '0'); --slv_reg54;
	      when b"110111" =>
	        reg_data_out <= slv_reg55;
	      when b"111000" =>
	        reg_data_out <= slv_reg56;
	      when b"111001" =>
	        reg_data_out <= slv_reg57;
	      when b"111010" =>
	        reg_data_out <= slv_reg58;
	      when b"111011" =>
	        reg_data_out <= slv_reg59;
	      when b"111100" =>
	        reg_data_out <= slv_reg60;
	      when b"111101" =>
	        reg_data_out <= slv_reg61;
	      when b"111110" =>
	        reg_data_out <= slv_reg62;
	      when b"111111" =>
	        reg_data_out <= slv_reg63;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	  end if;
	end process; 



	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here
	
   ------------------------------------------
   -- HOST Interface - VITA Control
   ------------------------------------------
  
   host_reset_process : process ( S_AXI_ACLK )
      variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            host_vita_reset        <= '0';
            --
            slv_reg3_r1 <= (others => '0');
         else
            loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);        

            -- 0x0C - VITA_CONTROL
            --           [ 0] VITA_RESET
            host_vita_reset        <= slv_reg3(0);
            slv_reg3_r1 <= "00000000" & 
                           "00000000" & 
                           "00000000" & 
                           "0000000" & host_vita_reset;
         end if;
      end if;
   end process host_reset_process;

   ------------------------------------------
   -- HOST Interface - ISERDES
   ------------------------------------------
  
--   host_iserdes_process : process ( S_AXI_ACLK )
--   begin
--      if rising_edge(S_AXI_ACLK) then
--         if S_AXI_ARESETN = '0' then
--            host_iserdes_reset           <= '0';
--            host_iserdes_auto_align      <= '0';
--            host_iserdes_align_start     <= '0';
--            host_iserdes_fifo_enable     <= '0';
--            host_iserdes_training        <= (others => '0');
--            host_iserdes_manual_tap      <= (others => '0');
--            --
--            slv_reg4_r1                  <= (others => '0');
--         else

            --
            -- 0x10 - ISERDES_CONTROL
            --           [ 0] ISERDES_RESET
            --           [ 1] ISERDES_AUTO_ALIGN
            --           [ 2] ISERDES_ALIGN_START
            --           [ 3] ISERDES_FIFO_ENABLE
            --           [ 8] ISERDES_CLK_READY
            --           [ 9] ISERDES_ALIGN_BUSY
            --           [10] ISERDES_ALIGNED
            --        [23:16] ISERDES_TXCLK_STATUS
            --        [31:24] ISERDES_RXCLK_STATUS
            host_iserdes_reset           <= slv_reg4(0);
            host_iserdes_auto_align      <= slv_reg4(1);
            host_iserdes_align_start     <= slv_reg4(2);
            host_iserdes_fifo_enable     <= slv_reg4(3);
            slv_reg4_r1 <= host_iserdes_clk_status & "00000" & 
               host_iserdes_aligned & 
               host_iserdes_align_busy & 
               host_iserdes_clk_ready & "0000" & 
               host_iserdes_fifo_enable & 
               host_iserdes_align_start & 
               host_iserdes_auto_align & 
               host_iserdes_reset;

            --       
            -- 0x14 - ISERDES_TRAINING
            host_iserdes_training        <= slv_reg5(9 downto 0);

            --       
            -- 0x18 - ISERDES_MANUAL_TAP
            host_iserdes_manual_tap      <= slv_reg6(9 downto 0);

--         end if;
--      end if;
--   end process host_iserdes_process;


   ------------------------------------------
   -- HOST Interface - Sync Channel Decoder
   ------------------------------------------

--   host_sync_process : process ( S_AXI_ACLK )
--   begin
--      if rising_edge(S_AXI_ACLK) then
--         if S_AXI_ARESETN = '0' then
--            host_decoder_reset           <= '0';
--            host_decoder_enable          <= '0';
--            host_decoder_startoddeven    <= (others => '0');
--            host_decoder_code_ls         <= (others => '0');
--            host_decoder_code_le         <= (others => '0');
--            host_decoder_code_fs         <= (others => '0');
--            host_decoder_code_fe         <= (others => '0');
--            host_decoder_code_bl         <= (others => '0');
--            host_decoder_code_img        <= (others => '0');
--            host_decoder_code_tr         <= (others => '0');
--            host_decoder_code_crc        <= (others => '0');
--         else
            --       
            -- 0x20 - DECODER_CONTROL[7:0]
            --           [0] DECODER_RESET
            --           [1] DECODER_ENABLE
            host_decoder_reset           <= slv_reg8(0);
            host_decoder_enable          <= slv_reg8(1);

            --       
            -- 0x24 - DECODER_STARTODDEVEN
            host_decoder_startoddeven    <= slv_reg9;

            --       
            -- 0x28 - DECODER_CODES_LS_LE
            host_decoder_code_ls         <= slv_reg10( 9 downto  0);
            host_decoder_code_le         <= slv_reg10(25 downto 16);

            --       
            -- 0x2C - DECODER_CODES_FS_FE
            host_decoder_code_fs         <= slv_reg11( 9 downto  0);
            host_decoder_code_fe         <= slv_reg11(25 downto 16);

            --       
            -- 0x30 - DECODER_CODES_BL_IMG
            host_decoder_code_bl         <= slv_reg12( 9 downto  0);
            host_decoder_code_img        <= slv_reg12(25 downto 16);

            -- 0x34 - DECODER_CODES_TR_CRC
            host_decoder_code_tr         <= slv_reg13( 9 downto  0);
            host_decoder_code_crc        <= slv_reg13(25 downto 16);


            --       
            -- 0xC0 - DECODER_CNT_MONITOR0_HIGH
            slv_reg48_r1 <= host_decoder_cnt_monitor0high;

            --       
            -- 0xC4 - DECODER_CNT_MONITOR0_LOW
            slv_reg49_r1 <= host_decoder_cnt_monitor0low;

            --       
            -- 0xC8 - DECODER_CNT_MONITOR1_HIGH
            slv_reg50_r1 <= host_decoder_cnt_monitor1high;

            --       
            -- 0xCC - DECODER_CNT_MONITOR1_LOW
            slv_reg51_r1 <= host_decoder_cnt_monitor1low;

--         end if;
--      end if;
--   end process host_sync_process;

   host_sync2_process : process ( S_AXI_ACLK )
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            slv_reg14_r1 <= (others => '0');
            slv_reg15_r1 <= (others => '0');
            slv_reg16_r1 <= (others => '0');
            slv_reg17_r1 <= (others => '0');
            slv_reg18_r1 <= (others => '0');
            slv_reg19_r1 <= (others => '0');
            slv_reg20_r1 <= (others => '0');
            slv_reg21_r1 <= (others => '0');
            slv_reg22_r1 <= (others => '0');

         else

            if ( host_decoder_frame_start = '1' ) then

               --       
               -- 0x38 - DECODER_CNT_BLACK_LINES
               slv_reg14_r1 <= host_decoder_cnt_black_lines;

               --       
               -- 0x3C - DECODER_CNT_IMAGE_LINES
               slv_reg15_r1 <= host_decoder_cnt_image_lines;

               --       
               -- 0x40 - DECODER_CNT_BLACK_PIXELS
               slv_reg16_r1 <= host_decoder_cnt_black_pixels;

               --       
               -- 0x44 - DECODER_CNT_IMAGE_PIXELS
               slv_reg17_r1 <= host_decoder_cnt_image_pixels;

               --       
               -- 0x48 - DECODER_CNT_FRAMES
               slv_reg18_r1 <= host_decoder_cnt_frames;

               --       
               -- 0x4C - DECODER_CNT_WINDOWS
               slv_reg19_r1 <= host_decoder_cnt_windows;

               --       
               -- 0x50 - DECODER_CNT_CLOCKS
               slv_reg20_r1 <= host_decoder_cnt_clocks;

               --       
               -- 0x54 - DECODER_CNT_START_LINES
               slv_reg21_r1 <= host_decoder_cnt_start_lines;

               --       
               -- 0x58 - DECODER_CNT_END_LINES
               slv_reg22_r1 <= host_decoder_cnt_end_lines;

            end if; --if ( host_decoder_frame_start = '1' ) then

         end if;
      end if;
   end process host_sync2_process;

   -- Read Logic

   ------------------------------------------
   -- HOST Interface - CRC Checker
   ------------------------------------------

--   host_crc_process : process ( S_AXI_ACLK )
--   begin
--      if rising_edge(S_AXI_ACLK) then
--         if S_AXI_ARESETN = '0' then
--            host_crc_reset     <= '0';
--            host_crc_initvalue <= '0';
--            --       
--            slv_reg29_r1       <= (others => '0');
--         else

            --       
            -- 0x70 - CRC_CONTROL[7:0]
            --           [0] CRC_RESET
            --           [1] CRC_INITVALUE
            host_crc_reset     <= slv_reg28(0);
            host_crc_initvalue <= slv_reg28(1);

            --       
            -- 0x74 - CRC_STATUS
            slv_reg29_r1       <= host_crc_status;

--         end if;
--      end if;
--   end process host_crc_process;

   ------------------------------------------
   -- HOST Interface - Data Channel Remapper
   ------------------------------------------

--   host_data_process : process ( S_AXI_ACLK )
--   begin
--      if rising_edge(S_AXI_ACLK) then
--         if S_AXI_ARESETN = '0' then
--            host_remapper_write_cfg      <= (others => '0');
--            host_remapper_mode           <= (others => '0');
--         else

            --       
            -- 0x78 - REMAPPER_CONTROL[7:0]
            --           [2:0] REMAPPER_WRITE_CFG
            --           [6:4] REMAPPER_MODE
            host_remapper_write_cfg      <= slv_reg30(2 downto 0);
            host_remapper_mode           <= slv_reg30(6 downto 4);

--         end if;
--      end if;
--   end process host_data_process;

   ------------------------------------------
   -- HOST Interface - Trigger Generator
   ------------------------------------------

--   host_trigger_process : process ( S_AXI_ACLK )
--   begin
--      if rising_edge(S_AXI_ACLK) then
--         if S_AXI_ARESETN = '0' then
--            host_triggen_enable            <= (others => '0');
--            host_triggen_sync2readout      <= (others => '0');
--            host_triggen_readouttrigger    <= '0';
--            host_triggen_default_freq      <= (others => '0');
--            host_triggen_cnt_trigger0high  <= (others => '0');
--            host_triggen_cnt_trigger0low   <= (others => '0');
--            host_triggen_cnt_trigger1high  <= (others => '0');
--            host_triggen_cnt_trigger1low   <= (others => '0');
--            host_triggen_cnt_trigger2high  <= (others => '0');
--            host_triggen_cnt_trigger2low   <= (others => '0');
--            host_triggen_ext_debounce      <= (others => '0');
--            host_triggen_ext_polarity      <= '0';
--            host_triggen_cnt_update        <= '0';
--         else

            -- 0xDC - TRIGGEN_EXT_DEBOUNCE
            host_triggen_ext_debounce      <= slv_reg55;

            --
            -- 0xE0 - TRIGGEN_CONTROL
            --        [ 2: 0] TRIGGEN_ENABLE
            --        [ 6: 4] TRIGGEN_SYNC2READOUT
            --        [    8] TRIGGEN_READOUTTRIGGER
            --        [   16] TRIGGEN_EXT_POLARITY
            --        [   24] TRIGGEN_CNT_UPDATE
            --        [30:28] TRIGGEN_GEN_POLARITY
            host_triggen_enable            <= slv_reg56(2 downto 0);
            host_triggen_sync2readout      <= slv_reg56(6 downto 4);
            host_triggen_readouttrigger    <= slv_reg56(8);
            host_triggen_ext_polarity      <= slv_reg56(16);
            host_triggen_cnt_update        <= slv_reg56(24);
            host_triggen_gen_polarity      <= slv_reg56(30 downto 28);

            --
            -- 0xE4 - TRIGGEN_DEFAULT_FREQ
            host_triggen_default_freq      <= slv_reg57;

--         end if;
--      end if;
--   end process host_trigger_process;

   host_trigger2_process : process ( S_AXI_ACLK )
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            host_triggen_cnt_trigger0high  <= (others => '0');
            host_triggen_cnt_trigger0low   <= (others => '0');
            host_triggen_cnt_trigger1high  <= (others => '0');
            host_triggen_cnt_trigger1low   <= (others => '0');
            host_triggen_cnt_trigger2high  <= (others => '0');
            host_triggen_cnt_trigger2low   <= (others => '0');
         else
            if ( host_triggen_cnt_update = '1' ) then

               --
               -- 0xE8 - TRIGGEN_TRIG0_HIGH
               host_triggen_cnt_trigger0high  <= slv_reg58;

               --
               -- 0xEC - TRIGGEN_TRIG0_LOW
               host_triggen_cnt_trigger0low   <= slv_reg59;

               --
               -- 0xF0 - TRIGGEN_TRIG1_HIGH
               host_triggen_cnt_trigger1high  <= slv_reg60;

               --
               -- 0xF4 - TRIGGEN_TRIG1_LOW
               host_triggen_cnt_trigger1low   <= slv_reg61;

               --
               -- 0xF8 - TRIGGEN_TRIG2_HIGH
               host_triggen_cnt_trigger2high  <= slv_reg62;

               --
               -- 0xFC - TRIGGEN_TRIG2_LOW
               host_triggen_cnt_trigger2low   <= slv_reg63;
 
            end if; -- if ( host_triggen_cnt_update == '1' ) then

         end if;
      end if;
   end process host_trigger2_process;

   ------------------------------------------
   -- HOST Interface - FPN/PRNU Correction
   ------------------------------------------

WITH_BLC_2 : if (C_INCLUDE_BLC = 1) generate

--   host_prnu_process : process ( S_AXI_ACLK )
--   begin
--      if rising_edge(S_AXI_ACLK) then
--         if S_AXI_ARESETN = '0' then
--            host_fpn_prnu_values         <= (others => '0');
--         else

            -- 0x80 - FPN_PRNU_VALUES[ 31:  0]
            -- 0x84 - FPN_PRNU_VALUES[ 63: 32]
            -- 0x88 - FPN_PRNU_VALUES[ 95: 64]
            -- 0x8C - FPN_PRNU_VALUES[127: 96]
            -- 0x90 - FPN_PRNU_VALUES[159:128]
            -- 0x94 - FPN_PRNU_VALUES[191:160]
            -- 0x98 - FPN_PRNU_VALUES[223:192]
            -- 0x9C - FPN_PRNU_VALUES[255:224]
            host_fpn_prnu_values( 31 downto   0) <= slv_reg32;
            host_fpn_prnu_values( 63 downto  32) <= slv_reg33;
            host_fpn_prnu_values( 95 downto  64) <= slv_reg34;
            host_fpn_prnu_values(127 downto  96) <= slv_reg35;
            host_fpn_prnu_values(159 downto 128) <= slv_reg36;
            host_fpn_prnu_values(191 downto 160) <= slv_reg37;
            host_fpn_prnu_values(223 downto 192) <= slv_reg38;
            host_fpn_prnu_values(255 downto 224) <= slv_reg39;

--         end if;
--      end if;
--   end process host_prnu_process;

end generate WITH_BLC_2;

WITHOUT_BLC_2 : if (C_INCLUDE_BLC = 0) generate
   host_fpn_prnu_values <= (others => '0');
end generate WITHOUT_BLC_2;


   ------------------------------------------
   -- HOST Interface - Sync Generator
   ------------------------------------------

--   host_syncgen_process : process ( S_AXI_ACLK )
--   begin
--      if rising_edge(S_AXI_ACLK) then
--         if S_AXI_ARESETN = '0' then
--            host_syncgen_delay <= (others => '0');
--            host_syncgen_hactive <= (others => '0');
--            host_syncgen_hfporch <= (others => '0');
--            host_syncgen_hsync   <= (others => '0');
--            host_syncgen_hbporch <= (others => '0');
--            host_syncgen_vactive <= (others => '0');
--            host_syncgen_vfporch <= (others => '0');
--            host_syncgen_vsync   <= (others => '0');
--            host_syncgen_vbporch <= (others => '0');
--         else

            -- 0x5C - SYNCGEN_DELAY
            --           [15: 0] DELAY
            host_syncgen_delay <= slv_reg23(15 downto  0);
            
            -- 0x60 - SYNCGEN_HTIMING1
            --           [15: 0] HACTIVE
            --           [31:16] HFPORCH
            -- 0x64 - SYNCGEN_HTIMING2
            --           [15: 0] HSYNC
            --           [31:16] HBPORCH
            -- 0x68 - SYNCGEN_VTIMING1
            --           [15: 0] VACTIVE
            --           [31:16] VFPORCH
            -- 0x6C - SYNCGEN_VTIMING2
            --           [15: 0] VSYNC
            --           [31:16] VBPORCH
            host_syncgen_hactive <= slv_reg24(15 downto  0);
            host_syncgen_hfporch <= slv_reg24(31 downto 16);
            host_syncgen_hsync   <= slv_reg25(15 downto  0);
            host_syncgen_hbporch <= slv_reg25(31 downto 16);
            host_syncgen_vactive <= slv_reg26(15 downto  0);
            host_syncgen_vfporch <= slv_reg26(31 downto 16);
            host_syncgen_vsync   <= slv_reg27(15 downto  0);
            host_syncgen_vbporch <= slv_reg27(31 downto 16);

--         end if;
--      end if;
--   end process host_syncgen_process;

   ------------------------------------------
   -- Clock Divide by 4 logic
   ------------------------------------------
   
    vita_clk4x <= clk;
 
    vita_clk_div4_l : BUFR
    generic map (
        BUFR_DIVIDE => "4", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
        SIM_DEVICE  => "7series"
    )
    port map (
        I       => vita_clk4x, -- Clock buffer input
        O       => vita_clk  , -- Clock buffer output
        CE      => one       ,
        CLR     => zero
    );

      
    ------------------------------------------
    -- VITA Receiver Core Logic
    ------------------------------------------
  onsemi_vita_cam_core_inst : onsemi_vita_cam_core
    generic map
    (
      C_VIDEO_DATA_WIDTH             => C_VIDEO_DATA_WIDTH,
      C_VIDEO_DIRECT_OUTPUT          => C_VIDEO_DIRECT_OUTPUT,
      --C_VIDEO_USE_SYNCGEN            => C_VIDEO_USE_SYNCGEN,
      C_IO_VITA_DATA_WIDTH           => C_IO_VITA_DATA_WIDTH,
      C_INCLUDE_BLC                  => C_INCLUDE_BLC,
      C_INCLUDE_MONITOR              => C_INCLUDE_MONITOR,      
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      clk200                         => clk200,
      clk                            => vita_clk,
      clk4x                          => vita_clk4x,
      reset                          => reset,
      oe                             => oe,
      -- HOST Interface - VITA      
      host_vita_reset                => host_vita_reset,
      -- HOST Interface - ISERDES
      host_iserdes_reset             => host_iserdes_reset,
      host_iserdes_auto_align        => host_iserdes_auto_align,
      host_iserdes_align_start       => host_iserdes_align_start,
      host_iserdes_fifo_enable       => host_iserdes_fifo_enable,
      host_iserdes_manual_tap        => host_iserdes_manual_tap,
      host_iserdes_training          => host_iserdes_training,
      host_iserdes_clk_ready         => host_iserdes_clk_ready,
      host_iserdes_clk_status        => host_iserdes_clk_status,
      host_iserdes_align_busy        => host_iserdes_align_busy,
      host_iserdes_aligned           => host_iserdes_aligned,
      -- HOST Interface - Sync Channel Decoder
      host_decoder_reset             => host_decoder_reset,
      host_decoder_enable            => host_decoder_enable,
      host_decoder_startoddeven      => host_decoder_startoddeven,
      host_decoder_code_ls           => host_decoder_code_ls,
      host_decoder_code_le           => host_decoder_code_le,
      host_decoder_code_fs           => host_decoder_code_fs,
      host_decoder_code_fe           => host_decoder_code_fe,
      host_decoder_code_bl           => host_decoder_code_bl,
      host_decoder_code_img          => host_decoder_code_img,
      host_decoder_code_tr           => host_decoder_code_tr,
      host_decoder_code_crc          => host_decoder_code_crc,
      host_decoder_frame_start       => host_decoder_frame_start,
      host_decoder_cnt_black_lines   => host_decoder_cnt_black_lines,
      host_decoder_cnt_image_lines   => host_decoder_cnt_image_lines,
      host_decoder_cnt_black_pixels  => host_decoder_cnt_black_pixels,
      host_decoder_cnt_image_pixels  => host_decoder_cnt_image_pixels,
      host_decoder_cnt_frames        => host_decoder_cnt_frames,
      host_decoder_cnt_windows       => host_decoder_cnt_windows,
      host_decoder_cnt_clocks        => host_decoder_cnt_clocks,
      host_decoder_cnt_start_lines   => host_decoder_cnt_start_lines,
      host_decoder_cnt_end_lines     => host_decoder_cnt_end_lines,
      host_decoder_cnt_monitor0high  => host_decoder_cnt_monitor0high,
      host_decoder_cnt_monitor0low   => host_decoder_cnt_monitor0low,
      host_decoder_cnt_monitor1high  => host_decoder_cnt_monitor1high,
      host_decoder_cnt_monitor1low   => host_decoder_cnt_monitor1low,
      -- HOST Interface - CRC Checker
      host_crc_reset                 => host_crc_reset,
      host_crc_initvalue             => host_crc_initvalue,
      host_crc_status                => host_crc_status,
      -- HOST Interface - Data Channel Remapper
      host_remapper_write_cfg        => host_remapper_write_cfg,
      host_remapper_mode             => host_remapper_mode,
      -- HOST Interface - Trigger Generator
      host_triggen_enable            => host_triggen_enable,
      host_triggen_sync2readout      => host_triggen_sync2readout,
      host_triggen_readouttrigger    => host_triggen_readouttrigger,
      host_triggen_default_freq      => host_triggen_default_freq,
      host_triggen_cnt_trigger0high  => host_triggen_cnt_trigger0high,
      host_triggen_cnt_trigger0low   => host_triggen_cnt_trigger0low,
      host_triggen_cnt_trigger1high  => host_triggen_cnt_trigger1high,
      host_triggen_cnt_trigger1low   => host_triggen_cnt_trigger1low,
      host_triggen_cnt_trigger2high  => host_triggen_cnt_trigger2high,
      host_triggen_cnt_trigger2low   => host_triggen_cnt_trigger2low,
      host_triggen_ext_debounce      => host_triggen_ext_debounce,
      host_triggen_ext_polarity      => host_triggen_ext_polarity,
      host_triggen_gen_polarity      => host_triggen_gen_polarity,
      -- HOST Interface - FPN/PRNU Correction
      host_fpn_prnu_values           => host_fpn_prnu_values,
      -- HOST Interface - Sync Generator
      host_syncgen_delay             => host_syncgen_delay,
      host_syncgen_hactive           => host_syncgen_hactive,
      host_syncgen_hfporch           => host_syncgen_hfporch,
      host_syncgen_hsync             => host_syncgen_hsync,
      host_syncgen_hbporch           => host_syncgen_hbporch,
      host_syncgen_vactive           => host_syncgen_vactive,
      host_syncgen_vfporch           => host_syncgen_vfporch,
      host_syncgen_vsync             => host_syncgen_vsync,
      host_syncgen_vbporch           => host_syncgen_vbporch,
      -- I/O pins
      io_vita_clk_pll                => io_vita_clk_pll,
      io_vita_reset_n                => io_vita_reset_n,
      io_vita_trigger                => io_vita_trigger,
      io_vita_monitor                => io_vita_monitor,
      io_vita_clk_out_p              => io_vita_clk_out_p,
      io_vita_clk_out_n              => io_vita_clk_out_n,
      io_vita_sync_p                 => io_vita_sync_p,
      io_vita_sync_n                 => io_vita_sync_n,
      io_vita_data_p                 => io_vita_data_p,
      io_vita_data_n                 => io_vita_data_n,
      -- Trigger Port
      trigger1                       => trigger1,
      -- Frame Sync Port
      fsync                          => fsync,
      -- Video Port
      video_vsync_o                  => video_vsync,
      video_hsync_o                  => video_hsync,
      video_vblank_o                 => video_vblank,
      video_hblank_o                 => video_hblank,
      video_active_video_o           => video_active_video,
      video_data_o                   => video_data,
      -- Debug Port
      debug_iserdes_o                => debug_iserdes_o,
      debug_decoder_o                => debug_decoder_o,
      debug_crc_o                    => debug_crc_o,
      debug_triggen_o                => debug_triggen_o,
      debug_syncgen_o                => debug_syncgen_o,
      debug_video_o                  => debug_video_o
   );

	-- User logic ends

end arch_imp;
