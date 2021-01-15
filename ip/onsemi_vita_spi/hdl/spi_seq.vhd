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
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
--user:
-----------
--library	work;
--use work.all;
--use work.app_pack.all;

entity spi_seq is
    generic (
        gSIMULATION                 : integer := 0;    
        gSysClkSpeed                : integer := 50;        
        gDATA_WIDTH                 : integer := 26;        
        gSyncTriggerWidth           : integer := 1;     -- min 1, max 15
        gRWbitposition              : integer := 0;     -- seen from LSB, when > 32
        gRWbitpolarity              : integer := 0      -- '0': On SPI channel write = 1, read = 0. '1': inverse
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
end spi_seq;


Architecture behaviour of spi_seq is

----------------------
--constant definition:
----------------------

type spi_seqtp is (	
                    Idle,
                    WaitSync1,
                    WaitSync1First,
                    WaitSync2,
                    Check_Fifo_Empty,
                    Read_En_Active,
                    Read_En_Active2,
                    GetFifoValue,
                    DoSpiComm,
                    Wait_spi_comm_busy,
                    Wait_spi_comm_busy_off                                              
				);


---------------------
-- signal definition:
---------------------

signal spi_seq				: spi_seqtp;

signal SpiRw                : std_logic; --'0' = write, '1' = read
signal Sync1_rising         : std_logic;
signal Sync2_rising         : std_logic;

signal synctriggers_prev   : std_logic_vector(gSyncTriggerWidth-1 downto 0); 

begin

--------------------------
--	default values	--
--------------------------

APP_RDFIFO_CLK <= CLK;
APP_WRFIFO_CLK <= CLK;  
	      
--------------------------
-- Process definition:	--
--------------------------

-- APP_RDFIFO_DATA_OUT bit assignments

-- bit 31 sync 2
-- bit 30 sync 1
-- bit 29 NOP bit                   
-- bits 28 RW (W = 0, R = 1)                  
-- bits 27 dt 0: address + data                  
                  
spi_sequencer: Process (CLK, RESET)
variable RWbit : std_logic;
begin
  
  if (RESET='1') then	    	
	
     BUSY               <= '0';                                          
     SPI_START	        <= '0';    
     SPI_DATA_TX        <= (others => '0');    
     
     SpiRw              <= '0';
     RWbit              := '0';
     
     APP_RDFIFO_EN      <= '0';
            
     APP_WRFIFO_EN	    <= '0'; 
     APP_WRFIFO_DATA_IN <= (others => '0');               
     
     ERROR              <= '0'; 
     
     spi_seq            <= Idle;
               
  elsif (CLK'event and CLK='1') then	
	
	SPI_START	        <= '0';											                                                                                 
 	APP_RDFIFO_EN       <= '0';
 	APP_WRFIFO_EN	    <= '0';  
 	                       
    Case spi_seq is     
               
        when Idle =>                                  
                BUSY          <= '0';                                                                                                                                                                                                                       
                if (APP_RDFIFO_EMPTY = '0') then
                    APP_RDFIFO_EN  <= '1';
                    spi_seq        <= Read_En_Active;
                end if;
        
        when Check_Fifo_Empty =>
             if (APP_RDFIFO_EMPTY = '0') then
                APP_RDFIFO_EN  <= '1';
                spi_seq        <= Read_En_Active;
             else
                spi_seq        <= Idle; 
             end if;

        when Read_En_Active =>
            spi_seq             <= Read_En_Active2;    
       
        when Read_En_Active2 =>
            spi_seq             <= GetFifoValue;    
       
        
        when GetFifoValue =>                           
            case APP_RDFIFO_DATA_OUT(31 downto 30) is
                when "00" => --Immediate =>
                    spi_seq <= DoSpiComm;
                when "01" => --Sync1 =>
                    spi_seq <= WaitSync1;    
                when "10" => --Sync2 =>  
                    spi_seq <= WaitSync2;       
                when "11" => --FirstSync1ThenSync2 =>
                    spi_seq <= WaitSync1First; 
                when others =>
                    spi_seq <= DoSpiComm;                        
            end case;            
            
        when WaitSync1 =>    
            if (Sync1_rising = '1') then
                spi_seq <= DoSpiComm;    
            end if;    
        
        when WaitSync1First =>    
            if (Sync1_rising = '1') then
                spi_seq <= WaitSync2;    
            end if; 
                    
        when WaitSync2 => 
            if (Sync2_rising = '1') then    
                spi_seq <= DoSpiComm; 
            end if;
                
        when DoSpiComm =>
            if (APP_RDFIFO_DATA_OUT(29) = '0') then    
                SpiRw               <= APP_RDFIFO_DATA_OUT(28);                                
                SPI_START	        <= '1';     
                -- 
                --   
                if (gRWbitpolarity > 0) then
                    RWbit := APP_RDFIFO_DATA_OUT(28); 
                else
                    RWbit := not APP_RDFIFO_DATA_OUT(28); 
                end if;            
                             
                if (gRWbitposition = 0) then
                    SPI_DATA_TX         <= APP_RDFIFO_DATA_OUT(gDATA_WIDTH-2 downto 0) & RWbit;
                elsif (gRWbitposition = 27) then
                    SPI_DATA_TX         <= RWbit & APP_RDFIFO_DATA_OUT(gDATA_WIDTH-2 downto 0);
                elsif (gRWbitposition > 32) then
                    SPI_DATA_TX         <= APP_RDFIFO_DATA_OUT(gDATA_WIDTH-1 downto 0);                    
                else
                    SPI_DATA_TX         <= APP_RDFIFO_DATA_OUT(gDATA_WIDTH-2 downto gRWbitposition) & RWbit & APP_RDFIFO_DATA_OUT(gRWbitposition-1 downto 0);
                end if;                                   
                spi_seq             <= Wait_spi_comm_busy;                                                                              
            else --NOP bit set
                spi_seq <= Check_Fifo_Empty;     
            end if;
                                                                
        when Wait_spi_comm_busy => 
           if (SPI_BUSY = '1') then
             spi_seq           <= Wait_spi_comm_busy_off;
           end if;        
        
        when Wait_spi_comm_busy_off =>
            if (SPI_BUSY = '0') then
                if (SpiRw = '1') then --a read was performed, so write the result to FIFO 
                   APP_WRFIFO_DATA_IN(31 downto gDATA_WIDTH)  <= (others => '0'); 
                   APP_WRFIFO_DATA_IN(gDATA_WIDTH-1 downto 0) <= SPI_DATA_RX;
                   APP_WRFIFO_EN	<= '1'; 
                   ERROR            <= APP_WRFIFO_FULL;
                end if;                
                spi_seq         <= Check_Fifo_Empty;                  
            end if;                                                                                                                                                                                                                                                                                                                                                                          
                                                      
        when others =>
            spi_seq                 <= Idle;      

		end case;


	end if;

end process;

spi_triggerselector: Process (CLK, RESET)
begin    
  if (RESET='1') then	    	
    Sync1_rising   <= '0';  
    Sync2_rising   <= '0';
    
    synctriggers_prev   <= (others => '0');
        	
  elsif (CLK'event and CLK='1') then
    
    synctriggers_prev  <= synctriggers; 
                    	    
    for i in 0 to gSyncTriggerWidth-1 loop
        if (TO_INTEGER(UNSIGNED(sync1_select)) = i) then
            Sync1_rising <= synctriggers_prev(i) and not synctriggers(i); 
        end if;
        
        if (TO_INTEGER(UNSIGNED(sync2_select)) = i) then
            Sync2_rising <= synctriggers_prev(i) and not synctriggers(i); 
        end if;                        
    end loop;         
  end if;         
end process;

end behaviour;