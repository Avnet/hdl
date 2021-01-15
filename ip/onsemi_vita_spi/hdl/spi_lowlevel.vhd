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
library ieee;
use ieee.std_logic_1164.all;
--synopsys:
-----------
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--user:
-----------
--library work;
--use work.all;
--use work.app_pack.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity spi_lowlevel is
  generic
  (     
        gSIMULATION                 : integer := 0;
    
        gSysClkSpeed                : integer := 50;    -- Clock Speed in MHz
        gSpiClkSpeed                : integer := 1000;  -- SPI Clock Speed in kHz
        gUseFixedSpeed              : integer := 1;     -- 0: use timing input 1: use SysClkSpeed/SpiClkSpeed generics
        
        gDATA_WIDTH                 : integer := 16; 
        gTxMSB_FIRST                : integer := 1;
        gRxMSB_FIRST                : integer := 1;
        
        gSCLK_POLARITY              : std_logic := '0'; --'0': idle low, '1': idle high
        gCS_POLARITY                : std_logic := '1'; --'0': active high, '1': active low
        gEN_POLARITY                : std_logic := '0'; --'0': normal, '1': invert
        gMOSI_POLARITY              : std_logic := '0'; --'0': normal, '1': invert
        gMISO_POLARITY              : std_logic := '0'; --'0': normal, '1': invert
        
        gMISO_SAMPLE                : std_logic := '0'; --'0': sample on rising edge, '1': sample on falling edge
        gMOSI_CLK                   : std_logic := '0'  --'0': clock out on rising edge, '1': clock out on falling edge
  );  
  port
  (      
        --
        -- Control signals
        --
        CLK                         : in	std_logic;
        RESET			            : in	std_logic;
                
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
end spi_lowlevel;


---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of spi_lowlevel is

----------------------------
-- COMPONENTS DEFINITIONS --
----------------------------
-- user components
-- none

-------------------------------
-- TYPE & SIGNAL DEFINITIONS --
-------------------------------
-- Objects for spi control
------------------------------------------------------------------
type clockstateTP is ( Idle, Bridge, CS_Active, First_Clk_Low, Clk_High, Clk_Low, Enable_Active);
signal clockstate 	: clockstateTP;

signal TxIndex      : integer range 0 to gDATA_WIDTH;
signal RxIndex      : integer range 0 to gDATA_WIDTH;
               
signal TxWord		: std_logic_vector((gDATA_WIDTH-1) downto 0);
signal RxWord		: std_logic_vector((gDATA_WIDTH-1) downto 0);

signal TimerCnt		: std_logic_vector(16 downto 0);
signal Counter		: std_logic_vector(16 downto 0);
 
signal ClockCounter : std_logic_vector(15 downto 0);
 
 
signal ClockOut     : std_logic;    
signal SampleIn     : std_logic;


--------------------------
--  CONSTANT DEFINITION --
--------------------------
  
--------------------
-- MAIN BEHAVIOUR --
--------------------
begin

-- wiring: 
variable_timing: if (gUseFixedSpeed = 0) generate
    TimerCnt 					<= '0' & TIMING(15 downto 0);
end generate;    
    
fixed_timing: if (gUseFixedSpeed > 0) generate
    TimerCnt 					<= conv_std_logic_vector((integer(real(gSysClkSpeed*1000)/real(gSpiClkSpeed)) - 2),17);
end generate;        


  ----------------------------------------------------------------------
  -- CNTR process ------------------------------------------------------
  ----------------------------------------------------------------------
  counterpr: Process(RESET,CLK)
  begin
    if (RESET='1') then   
        Counter	<= "10000000000000000";
    elsif (CLK'event and CLK='1') then
     if Counter(16)='1' then 
        Counter <= TimerCnt;
     else 
        Counter <= Counter - 1;
     end if;
    end if;
  end process;
  
  ----------------------------------------------------------------------
  -- CLOCK process -----------------------------------------------------
  ----------------------------------------------------------------------
  
  clockpr: Process(RESET,CLK)
  begin
    if (RESET='1') then   
        
        BUSY            <= '0';
                        
        SCLK            <= gSCLK_POLARITY;
        CS              <= gCS_POLARITY;
        EN              <= gEN_POLARITY;
                        
        ClockOut        <= '0';
        SampleIn        <= '0';
        
        ClockCounter    <= (others => '0');  
        
        ClockState  <= Idle;
        
    elsif (CLK'event and CLK='1') then
        
        ClockOut    <= '0';
        SampleIn    <= '0';
        
        case clockstate is
            when Idle =>  
                BUSY    <= '0';
                if (START = '1') then
                    ClockCounter    <= conv_std_logic_vector((gDATA_WIDTH-2), (ClockCounter'high+1));
                    BUSY            <= '1';
                    clockstate      <= Bridge;
                end if;
                    
            when Bridge => 
                if (Counter(Counter'high) = '1') then
                    CS          <= not gCS_POLARITY;
                    clockstate  <= CS_Active;    
                end if;
            
            when CS_Active =>
                if (Counter(Counter'high) = '1') then
                    ClockOut    <= not gMOSI_CLK;                    
                    SCLK        <= gSCLK_POLARITY;                    
                    clockstate  <= First_Clk_Low;    
                end if;                                                                      
           
            when First_Clk_Low => 
                if (Counter(Counter'high) = '1') then
                    ClockOut    <= gMOSI_CLK;                       
                    SCLK        <= not gSCLK_POLARITY;                                     
                    clockstate  <= Clk_High;    
                end if;    
                                                                                                                                    
            when Clk_Low =>
                if (Counter(Counter'high) = '1') then
                    ClockOut    <= gMOSI_CLK;   
                    SampleIn    <= gMISO_SAMPLE;  
                    SCLK        <= not gSCLK_POLARITY;                                     
                    clockstate  <= Clk_High;    
                end if;
                
            when Clk_High =>                
                if (Counter(Counter'high) = '1') then                                                                                                    
                    if (ClockCounter(ClockCounter'high) = '1') then   
                        SCLK            <= gSCLK_POLARITY;
                        EN              <= not gEN_POLARITY; 
                        SampleIn        <= not gMISO_SAMPLE; 
                        clockstate      <= Enable_Active;                          
                    else      
                        ClockCounter    <= ClockCounter - '1';
                        ClockOut        <= not gMOSI_CLK;   
                        SampleIn        <= not gMISO_SAMPLE;
                        SCLK            <= gSCLK_POLARITY;
                        clockstate      <= Clk_Low;    
                    end if;    
                                                    
                end if;
            
            when Enable_Active =>                
                if (Counter(Counter'high) = '1') then
                    EN          <= gEN_POLARITY;
                    CS          <= gCS_POLARITY;   
                    SampleIn    <= gMISO_SAMPLE;      
                    clockstate  <= Idle;
                end if;
            
            when others =>
                
        end case;
    end if; 

  end process;

TxMSBFirstGen: if (gTxMSB_FIRST > 0) generate
    genloop: for i in 0 to (gDATA_WIDTH-1) generate    
        TxWord(i) <= SPI_DATA_TX((gDATA_WIDTH-1)-i);
    end generate;    
end generate;

TxMSBLastGen: if (gTxMSB_FIRST = 0) generate
TxWord <= SPI_DATA_TX;
end generate;

RxMSBFirstGen: if (gRxMSB_FIRST > 0) generate
    genloop: for i in 0 to (gDATA_WIDTH-1) generate
        SPI_DATA_RX(i) <= RxWord((gDATA_WIDTH-1)-i);
    end generate;
end generate;

RxMSBLasttGen: if (gRxMSB_FIRST = 0) generate
SPI_DATA_RX <= RxWord;
end generate;

  data_transfer: process(RESET,CLK)
  begin

    if (RESET='1') then

      RxWord     <= (others => '0');
      
      TxIndex    <= 0;
      RxIndex    <= 0;    
      
      MOSI       <= '0';
      
    elsif (CLK'event and CLK='1') then     
      
      if (START = '1') then
        TxIndex <= 0;
      elsif (ClockOut = '1') then
        if  (gMOSI_POLARITY = '0') then                        
            MOSI    <= TxWord(TxIndex);
        else
            MOSI    <= not TxWord(TxIndex);    
        end if;                            
        TxIndex <= TxIndex + 1;  
      end if; 
        
      if (START = '1') then
        RxIndex <= 0;
      elsif (SampleIn = '1') then
        if gMISO_POLARITY = '0' then
            RxWord(RxIndex) <= MISO;
        else
            RxWord(RxIndex) <= not MISO;    
        end if;
        RxIndex <= RxIndex + 1;  
      end if;                                                                                      

    end if; 
        
  end process data_transfer;

end rtl;