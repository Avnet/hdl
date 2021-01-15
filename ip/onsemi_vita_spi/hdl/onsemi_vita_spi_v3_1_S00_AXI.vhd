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
-- Design Name:         ON Semiconductor VITA SPI controller
-- Module Name:         onsemi_vita_cam_v3_1_S00_AXI.vhd
-- Project Name:        ON Semiconductor VITA SPI controller
-- Target Devices:      Zynq-7000
-- Avnet Boards:        FMC-IMAGEON + VITA-2000, EMBV + PYTYHON-1300-C
--
-- Tool versions:       Vivado 2014.4
--
-- Description:         ON Semiconductor VITA SPI controller - User Logic.
--                      This layer implements the following programming model
--                         0x00 - CORE_VERSION
--                                [31:24] VERSION_MAJOR
--                                [23:16] VERSION_MINOR
--                                [15: 0] VERSION_PATCH
--                         0x04 - CORE_ID = 0x4F4E5653 (ASCII for "ONVS")
--
--                         0x010 - SPI_CONTROL
--                                   [ 1] SPI_RESET
--                                   [ 8] SPI_STATUS_BUSY
--                                   [ 9] SPI_STATUS_ERROR
--                                   [16] SPI_TXFIFO_FULL
--                                   [24] SPI_RXFIFO_EMPTY
--                         0x14 - SPI_TIMING[15:0]
--                         0x18 - SPI_TXFIFO_DATA[31:0]
--                         0x1C - SPI_RXFIFO_DATA[31:0]
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

entity onsemi_vita_spi_v3_1_S00_AXI is
	generic (
		-- Users to add parameters here
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
		clk                            : in  std_logic;
		reset                          : in  std_logic;
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
end onsemi_vita_spi_v3_1_S00_AXI;

architecture arch_imp of onsemi_vita_spi_v3_1_S00_AXI is

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
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg5 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg6 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg7 :std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;

    -- read back register content
	signal slv_reg4_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	--
	signal slv_reg7_r1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

	------------------------------------------
    -- HOST Interface - SPI
    ------------------------------------------
	signal host_spi_clk                   : std_logic;
	signal host_spi_reset                 : std_logic;
	signal host_spi_timing                : std_logic_vector(15 downto 0);
	signal host_spi_status_busy           : std_logic;
	signal host_spi_status_error          : std_logic;
	signal host_spi_txfifo_clk            : std_logic;                          	
	signal host_spi_txfifo_wen_a1         : std_logic;                              
	signal host_spi_txfifo_wen            : std_logic;                              
	signal host_spi_txfifo_din            : std_logic_vector(31 downto 0);         
	signal host_spi_txfifo_full           : std_logic; 
	signal host_spi_rxfifo_clk            : std_logic;                          	
	signal host_spi_rxfifo_ren            : std_logic;                              
	signal host_spi_rxfifo_dout           : std_logic_vector(31 downto 0);         
	signal host_spi_rxfifo_empty          : std_logic; 

    ------------------------------------------
    -- VITA SPI Controller Core Logic
    ------------------------------------------

    constant CORE_VERSION                 : std_logic_vector(31 downto 0) := X"03030000"; -- 3.3.0
    constant CORE_ID                      : std_logic_vector(31 downto 0) := X"4F4E5653"; -- ASCII for "ONVS" 
    
component onsemi_vita_spi_core is
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
end component onsemi_vita_spi_core;

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
	      slv_reg4 <= (others => '0');
	      slv_reg5 <= (others => '0');
	      slv_reg6 <= (others => '0');
	      slv_reg7 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
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
	          when others =>
	            slv_reg4 <= slv_reg4;
	            slv_reg5 <= slv_reg5;
	            slv_reg6 <= slv_reg6;
	            slv_reg7 <= slv_reg7;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 


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

	process (slv_reg4, slv_reg5, slv_reg6, slv_reg7, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
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
	      when b"000100" =>
	        reg_data_out <= slv_reg4_r1; -- slv_reg4;
	      when b"000101" =>
	        reg_data_out <= slv_reg5;
	      when b"000110" =>
	        reg_data_out <= slv_reg6;
	      when b"000111" =>
	        reg_data_out <= slv_reg7_r1; --slv_reg7;
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
   -- HOST Interface - SPI
   ------------------------------------------
  
   host_spi_clk          <= S_AXI_ACLK;
   host_spi_txfifo_clk   <= S_AXI_ACLK;
   host_spi_rxfifo_clk   <= S_AXI_ACLK;

   host_spi_process : process ( S_AXI_ACLK )
      variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
   begin
      if rising_edge(S_AXI_ACLK) then
         if S_AXI_ARESETN = '0' then
            host_spi_reset         <= '0';
            host_spi_timing        <= (others => '0');
            host_spi_txfifo_wen_a1 <= '0';
            host_spi_txfifo_wen    <= '0';
            host_spi_txfifo_din    <= (others => '0');
            host_spi_rxfifo_ren    <= '0';
            --
            slv_reg4_r1 <= (others => '0');
            slv_reg7_r1 <= (others => '0');
         else
            loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);        

            -- 0x10 - SPI_CONTROL
            --           [ 1] SPI_RESET
            --           [ 8] SPI_STATUS_BUSY
            --           [ 9] SPI_STATUS_ERROR
            --           [16] SPI_TXFIFO_FULL
            --           [24] SPI_RXFIFO_EMPTY
            host_spi_reset         <= slv_reg4(1);
            slv_reg4_r1 <= "0000000" & host_spi_rxfifo_empty &
                           "0000000" & host_spi_txfifo_full &
                           "000000" & host_spi_status_error & host_spi_status_busy &
                           "000000" & host_spi_reset & "0";

            -- 0x14 - SPI_TIMING[15:0]
            host_spi_timing        <= slv_reg5(15 downto  0);

            -- 0x18 - SPI_TXFIFO_DATA[31:0]
            -- slv_reg6 is valid 1 cycle after slv_reg_wren
            if (slv_reg_wren = '1' and loc_addr = b"000110") then
               host_spi_txfifo_wen_a1 <= '1';
            else
               host_spi_txfifo_wen_a1 <= '0';
            end if;
            host_spi_txfifo_wen    <= host_spi_txfifo_wen_a1;
            --
            host_spi_txfifo_din    <= slv_reg6;

            -- 0x1C - SPI_RXFIFO_DATA[31:0]
            -- use write to pop value from RXFIFO ...
            if (slv_reg_wren = '1' and loc_addr = b"000111") then
              host_spi_rxfifo_ren <= '1';
            else
              host_spi_rxfifo_ren <= '0';
            end if;
            --                 
            slv_reg7_r1 <= host_spi_rxfifo_dout;                         

         end if;
      end if;
   end process host_spi_process;

    ------------------------------------------
    -- VITA SPI Controller Core Logic
    ------------------------------------------
  onsemi_vita_spicore_inst : onsemi_vita_spi_core
    generic map
    (
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      oe                             => oe,
      -- HOST Interface - SPI
      host_spi_clk                   => host_spi_clk,
      host_spi_reset                 => host_spi_reset,
      host_spi_timing                => host_spi_timing,
      host_spi_status_busy           => host_spi_status_busy,
      host_spi_status_error          => host_spi_status_error,
      host_spi_txfifo_clk            => host_spi_txfifo_clk,
      host_spi_txfifo_wen            => host_spi_txfifo_wen,
      host_spi_txfifo_din            => host_spi_txfifo_din,
      host_spi_txfifo_full           => host_spi_txfifo_full,
      host_spi_rxfifo_clk            => host_spi_rxfifo_clk,
      host_spi_rxfifo_ren            => host_spi_rxfifo_ren,
      host_spi_rxfifo_dout           => host_spi_rxfifo_dout,
      host_spi_rxfifo_empty          => host_spi_rxfifo_empty,
      -- I/O pins
      io_vita_spi_sclk               => io_vita_spi_sclk,
      io_vita_spi_ssel_n             => io_vita_spi_ssel_n,
      io_vita_spi_mosi               => io_vita_spi_mosi,
      io_vita_spi_miso               => io_vita_spi_miso,
      -- Debug Port
      debug_spi_o                    => debug_spi_o
   );

	-- User logic ends

end arch_imp;
