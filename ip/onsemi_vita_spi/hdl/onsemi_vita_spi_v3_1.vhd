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
-- Design Name:         ON Semiconductor SPI controller
-- Module Name:         onsemi_vita_cam_v3_1.vhd
-- Project Name:        ON Semiconductor SPI controller
-- Target Devices:      Zynq-7000
-- Avnet Boards:        FMC-IMAGEON + VITA-2000, EMBV + PYTYHON-1300-C
--
-- Tool versions:       Vivado 2014.4
--
-- Description:         ON Semiconductor SPI controller
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
--
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity onsemi_vita_spi_v3_1 is
	generic (
		-- Users to add parameters here
		C_VIDEO_DATA_WIDTH      : integer   := 10;
		C_VIDEO_DIRECT_OUTPUT   : integer   := 0;
		--C_VIDEO_USE_SYNCGEN     : integer   := 1;
		C_IO_VITA_DATA_WIDTH    : integer   := 4;
		C_INCLUDE_BLC                  : integer := 0;
        C_INCLUDE_MONITOR              : integer := 0;  		
		C_FAMILY                : string    := "zynq";
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 8
	);
	port (
		-- Users to add ports here
		oe                             : in  std_logic;
		-- I/O pins
		io_vita_spi_sclk               : out std_logic;
		io_vita_spi_ssel_n             : out std_logic;
		io_vita_spi_mosi               : out std_logic;
		io_vita_spi_miso               : in  std_logic;
		-- Debug Ports
		debug_spi_o                    : out std_logic_vector( 95 downto 0);

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end onsemi_vita_spi_v3_1;

architecture arch_imp of onsemi_vita_spi_v3_1 is

	-- component declaration
	component onsemi_vita_spi_v3_1_S00_AXI is
		generic (
        C_FAMILY                       : string               := "zynq";
		--
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 8
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic;

		oe                             : in  std_logic;
		-- I/O pins
		io_vita_spi_sclk               : out std_logic;
		io_vita_spi_ssel_n             : out std_logic;
		io_vita_spi_mosi               : out std_logic;
		io_vita_spi_miso               : in  std_logic;
		-- Debug Ports
		debug_spi_o                    : out std_logic_vector( 95 downto 0)
		);
	end component onsemi_vita_spi_v3_1_S00_AXI;

begin

-- Instantiation of Axi Bus Interface S00_AXI
onsemi_vita_spi_v3_1_S00_AXI_inst : onsemi_vita_spi_v3_1_S00_AXI
	generic map (
        C_FAMILY              => C_FAMILY,
        --
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready,

      oe                             => oe,
      -- I/O pins
      io_vita_spi_sclk               => io_vita_spi_sclk,
      io_vita_spi_ssel_n             => io_vita_spi_ssel_n,
      io_vita_spi_mosi               => io_vita_spi_mosi,
      io_vita_spi_miso               => io_vita_spi_miso,
      -- Debug Ports
      debug_spi_o                    => debug_spi_o

	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
