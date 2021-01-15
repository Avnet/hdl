-- *********************************************************************
-- Copyright 2008, Cypress Semiconductor Corporation.
--
-- This software is owned by Cypress Semiconductor Corporation (Cypress)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of Cypress.
--
-- Disclaimer: Cypress makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. Cypress reserves the right to make changes without further
-- notice to the materials described herein. Cypress does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. Cypress' products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the Cypress Software License Agreement.
--
-- *********************************************************************
-- Author         : $Author: fwi $ @ cypress.com
-- Department     : MPD_BE
-- Date           : $Date: 2010-07-02 09:41:24 +0200 (Fri, 02 Jul 2010) $
-- Revision       : $Revision: 531 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

-------------------
-- LIBRARY USAGE --
-------------------
--common:
---------
library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--user:
-----------
--library	work;
--use work.all;
--use work.app_pack.all;

entity spi_top is
  generic
        (     
        gSIMULATION                 : integer := 0;    
        gSysClkSpeed                : integer := 50;
        
        --LowLevel SPI settings           
        gSpiClkSpeed                : integer := 1000;  -- SPI Clock Speed in kHz
        gUseFixedSpeed              : integer := 1;     -- 0: use timing input 1: use SysClkSpeed/SpiClkSpeed generics
        
        gDATA_WIDTH                 : integer := 26; 
        gTxMSB_FIRST                : integer := 1;
        gRxMSB_FIRST                : integer := 1;
                
        gSCLK_POLARITY              : std_logic := '0'; --'0': idle low, '1': idle high
        gCS_POLARITY                : std_logic := '1'; --'0': active high, '1': active low
        gEN_POLARITY                : std_logic := '0'; --'0': normal, '1': invert
        gMOSI_POLARITY              : std_logic := '0'; --'0': normal, '1': invert
        gMISO_POLARITY              : std_logic := '0'; --'0': normal, '1': invert
        
        gMISO_SAMPLE                : std_logic := '1'; --'0': sample on rising edge, '1': sample on falling edge
        gMOSI_CLK                   : std_logic := '0'; --'0': clock out on rising edge, '1': clock out on falling edge
         
        --Seq SPI settings                                                                               
        gSyncTriggerWidth           : integer;     -- min 1, max 15  
        gRWbitposition              : integer := 0      --seen from LSB                              
        );       
  Port	(
  		CLOCK			                : in	std_logic;	
		RESET			                : in	std_logic;
                                              
        TIMING					        : in    std_logic_vector(15 downto 0);
        
        BUSY                            : out	std_logic;
                                                        
		--START_READ	                    : in	std_logic;
		--BUSY_READ                       : out 	std_logic;
		                                
		--START_WRITE                     : in 	std_logic;
		--BUSY_WRITE                      : out	std_logic;				
		
		--synchro signals 		
		synctriggers                    : in    std_logic_vector(gSyncTriggerWidth-1 downto 0); 
		sync1_select                    : in    std_logic_vector(3 downto 0);	
		sync2_select                    : in    std_logic_vector(3 downto 0);	
		    							                                
        -- Fifo signals    
        -- read fifo interface (SPI write path/SPI read address path)                                                           
        APP_RDFIFO_CLK	                : out	std_logic;                          	
        APP_RDFIFO_EN	                : out	std_logic;                              
        APP_RDFIFO_DATA_OUT             : in 	std_logic_vector( 31 downto 0);         
        APP_RDFIFO_EMPTY   	            : in 	std_logic; 
        
        -- write fifo interface (SPI read data path)
        APP_WRFIFO_CLK	                : out	std_logic;                          	
        APP_WRFIFO_EN	                : out	std_logic;                              
        APP_WRFIFO_DATA_IN              : out 	std_logic_vector( 31 downto 0);         
        APP_WRFIFO_FULL   	            : in 	std_logic; 
        
        ERROR                           : out   std_logic; 
  		--
        -- SPI
        --
        SCLK	        		    : out	std_logic;
        MOSI            	        : out	std_logic;
        MISO						: in	std_logic;
        CS       				    : out	std_logic;
        EN                          : out	std_logic  	  		
		);		
end spi_top;

Architecture structure of spi_top is

-------------------------
-- component declaration:
-------------------------

component spi_seq
    generic (
        gSIMULATION                 : integer;    
        gSysClkSpeed                : integer;        
        gDATA_WIDTH                 : integer;        
        gSyncTriggerWidth           : integer;     -- min 1, max 15
        gRWbitposition              : integer      --seen from LSB              
        );      
	port	(
		-- system:
		CLK				                : in	std_logic;	
		RESET			                : in	std_logic;
       
        BUSY                            : out	std_logic;
       
        --synchro signals 		
		synctriggers                    : in    std_logic_vector(gSyncTriggerWidth-1 downto 0); 
		sync1_select                    : in    std_logic_vector(3 downto 0);		
		sync2_select                    : in    std_logic_vector(3 downto 0);	
    
    
        -- Fifo signals    
        -- read fifo interface (SPI write path/SPI read address path)                                                           
        APP_RDFIFO_CLK	                : out	std_logic;                          	
        APP_RDFIFO_EN	                : out	std_logic;                              
        APP_RDFIFO_DATA_OUT             : in 	std_logic_vector( 31 downto 0);         
        APP_RDFIFO_EMPTY   	            : in 	std_logic; 
        
        -- write fifo interface (SPI read data path)
        APP_WRFIFO_CLK	                : out	std_logic;                          	
        APP_WRFIFO_EN	                : out	std_logic;                              
        APP_WRFIFO_DATA_IN              : out 	std_logic_vector( 31 downto 0);         
        APP_WRFIFO_FULL   	            : in 	std_logic; 
        
        ERROR                           : out   std_logic;             		
		
		SPI_START			            : out	std_logic;
		SPI_BUSY			            : in	std_logic;
		SPI_DATA_TX		                : out	std_logic_Vector(gDATA_WIDTH-1 downto 0);
		SPI_DATA_RX		                : in	std_logic_vector(gDATA_WIDTH-1 downto 0)	
		);
end component;
 
component spi_lowlevel
  generic
  (     
        gSIMULATION                 : integer := 0;
    
        gSysClkSpeed                : integer := 50;    -- Clock Speed in MHz
        gSpiClkSpeed                : integer := 1000;  -- SPI Clock Speed in kHz
        gUseFixedSpeed              : integer := 1;     -- 0: use timing input 1: use SysClkSpeed/SpiClkSpeed generics
        
        gDATA_WIDTH                 : integer := 26; 
        gTxMSB_FIRST                : integer := 1;
        gRxMSB_FIRST                : integer := 1;
                
        gSCLK_POLARITY              : std_logic := '0'; --'0': idle low, '1': idle high
        gCS_POLARITY                : std_logic := '1'; --'0': active high, '1': active low
        gEN_POLARITY                : std_logic := '0'; --'0': normal, '1': invert
        gMOSI_POLARITY              : std_logic := '0'; --'0': normal, '1': invert
        gMISO_POLARITY              : std_logic := '0'; --'0': normal, '1': invert
        
        gMISO_SAMPLE                : std_logic := '1'; --'0': sample on rising edge, '1': sample on falling edge
        gMOSI_CLK                   : std_logic := '0'  --'0': clock out on rising edge, '1': clock out on falling edge
  );  
  port
  (      
        --
        -- Control signals
        --
        CLK                         : in	std_logic;
        RESET 			            : in	std_logic;
                
        START					    : in	std_logic;
        BUSY					    : out	std_logic;       

        SPI_DATA_TX		            : in	std_logic_Vector((gDATA_WIDTH-1) downto 0);
        SPI_DATA_RX		            : out	std_logic_vector((gDATA_WIDTH-1) downto 0);
        
        TIMING                      : in	std_logic_vector(15 downto 0);
        
        --
        -- SPI
        --
        SCLK	        		    : out	std_logic;
        MOSI            	        : out	std_logic;
        MISO						: in	std_logic;
        CS       				    : out	std_logic;
        EN                          : out	std_logic                                
        
  );
end component; 


----------------------
-- signal declaration:
----------------------

signal SPI_START                    : std_logic;    
signal SPI_BUSY                     : std_logic;
signal SPI_DATA_TX				 	: std_Logic_vector(gDATA_WIDTH-1 downto 0);
signal SPI_DATA_RX					: std_logic_vector(gDATA_WIDTH-1 downto 0);


begin

---------------------------
-- component instantiation:
---------------------------

the_spi_seq: spi_seq
    generic map (
        gSIMULATION          => gSIMULATION             ,    
        gSysClkSpeed         => gSysClkSpeed            ,
        gDATA_WIDTH          => gDATA_WIDTH             ,
        gSyncTriggerWidth    => gSyncTriggerWidth       ,
        gRWbitposition       => gRWbitposition   
        )                                               
	port map (                                          
		-- system:                                      
		CLK				      => CLOCK			        ,	
		RESET			      => RESET  		        ,      
        
        BUSY                  => BUSY                   ,
                
        synctriggers          => synctriggers          ,
        sync1_select          => sync1_select           ,
        sync2_select          => sync2_select           ,
                                		               
        -- Fifo signals                                                          
        APP_RDFIFO_CLK	      => APP_RDFIFO_CLK	        ,	
        APP_RDFIFO_EN	      => APP_RDFIFO_EN	        ,    
        APP_RDFIFO_DATA_OUT   => APP_RDFIFO_DATA_OUT    ,    
        APP_RDFIFO_EMPTY   	  => APP_RDFIFO_EMPTY       ,
        
        APP_WRFIFO_CLK	      => APP_WRFIFO_CLK	        ,                                                  	
        APP_WRFIFO_EN	      => APP_WRFIFO_EN	        ,                                                     
        APP_WRFIFO_DATA_IN    => APP_WRFIFO_DATA_IN     ,                                               
        APP_WRFIFO_FULL   	  => APP_WRFIFO_FULL        ,                                         
        
        ERROR                 => ERROR                  ,
                                
		SPI_START			  => SPI_START	            ,
		SPI_BUSY			  => SPI_BUSY	            ,
		SPI_DATA_TX		      => SPI_DATA_TX            ,
		SPI_DATA_RX		      => SPI_DATA_RX	
		);
    
the_spi_lowlevel: spi_lowlevel
  generic map
  (     
        gSIMULATION                 => gSIMULATION      ,
    
        gSysClkSpeed                => gSysClkSpeed     , -- Clock Speed in MHz
        gSpiClkSpeed                => 1000             , -- SPI Clock Speed in kHz
        gUseFixedSpeed              => 0                , -- 0: use timing input 1: use SysClkSpeed/SpiClkSpeed generics
        
        gDATA_WIDTH                 => 26               , 
        gTxMSB_FIRST                => 1                ,
        gRxMSB_FIRST                => 1                ,
                 
        gSCLK_POLARITY              => '0'              , --'0': idle low, '1': idle high
        gCS_POLARITY                => '1'              , --'0': active high, '1': active low
        gEN_POLARITY                => '0'              , --'0': normal, '1': invert
        gMOSI_POLARITY              => '0'              , --'0': normal, '1': invert
        gMISO_POLARITY              => '0'              , --'0': normal, '1': invert
        
        gMISO_SAMPLE                => '0'              , --'0': sample on rising edge, '1': sample on falling edge
        gMOSI_CLK                   => '0'                --'0': clock out on rising edge, '1': clock out on falling edge
  )  
  port map
  (      
        --
        -- Control signals
        --
        CLK                         => CLOCK            ,    
        RESET			            => RESET            ,
                
        START					    => SPI_START	    ,  
        BUSY					    => SPI_BUSY	        ,   

        SPI_DATA_TX		            => SPI_DATA_TX      ,
        SPI_DATA_RX		            => SPI_DATA_RX	    ,       
        
        TIMING                      => TIMING           ,       
        
        --
        -- SPI
        --
        SCLK	        		    => SCLK             ,
        MOSI            	        => MOSI             ,
        MISO						=> MISO             ,
        CS       				    => CS               ,
        EN                          => EN                            
  );

end STRUCTURE ;