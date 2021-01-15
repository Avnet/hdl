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
-- Author         : $Author: fvk $ @ cypress.com
-- Department     : MPD_BE
-- Date           : $Date: 2010-04-14 14:16:04 +0200 (Wed, 14 Apr 2010) $
-- Revision       : $Revision: 189 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

-------------
-- LIBRARY --
-------------
--common:
---------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

-- CRC Tool by Easics    
library work;
use work.all;
use work.PCK_CRC10_D10.all;
use work.PCK_CRC8_D8.all;
--use work.app_pack.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity crc_calc is
  generic (
         DATAWIDTH       : integer ;
         POLYNOMIAL      : std_logic_vector := "11001001111";
         USE_CRC_TOOL    : boolean := TRUE         
  );  
  port ( -- System
--  		 APP_CFG_REG		    : in    AppCfgRegTp;
       INITVALUE     : in  std_logic;       
  		 CLOCK			: in	std_logic;
  		 RESET      	: in    std_logic;
  		 -- Data input
  		 INIT			: in	std_logic;
         DATA_IN        : in    std_logic_vector(DATAWIDTH-1 downto 0);
         CRC_OUT        : out   std_logic_vector(DATAWIDTH-1 downto 0)
        );
end;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of crc_calc is

----------------------------
-- COMPONENTS DEFINITIONS --
----------------------------
-- Xilinx components
-- none

-- user components
-- none 

-------------------------------
-- TYPE & SIGNAL DEFINITIONS --
-------------------------------        
type temptp is array (DATAWIDTH downto 0) of std_logic_vector(DATAWIDTH downto 0);  
    
signal  CRC_own            : std_logic_vector(DATAWIDTH-1 downto 0);  
signal  CRC_tool           : unsigned(DATAWIDTH-1 downto 0); 


       
signal tmparray : temptp;


--------------------
-- MAIN BEHAVIOUR --
--------------------
begin

 
CRC_OUT <= std_logic_vector(CRC_tool(DATAWIDTH-1 downto 0)) when (USE_CRC_TOOL = TRUE) else CRC_own;                               
  
  CRCModule:process(CLOCK, RESET)  
    
  variable CRC_own_i    : std_logic_vector(DATAWIDTH downto 0);       
  variable temp		    : std_logic_vector(DATAWIDTH downto 0);
    
  begin  
    if (RESET ='1') then           
      CRC_own_i         := (others => '1');                                          
      
      CRC_tool          <= (others => '1');
      CRC_own           <= (others => '1');                             
      --
    elsif (CLOCK'event and CLOCK = '1') then
        
        
        --DATA_IN_delay1  <= DATA_IN;
        --DATA_IN_delay2  <= DATA_IN_delay1;        
        
--        if (INIT='1' and APP_CFG_REG.sysmode(7) = '0') then             
        if (INIT='1' and INITVALUE = '0') then             
             CRC_tool            <= (others => '1');  --CRC tool by easics
                 
             CRC_own             <= (others => '1');  --own implementation                                   
             CRC_own_i           := (others => '1');
              
--        elsif ( INIT='1' and APP_CFG_REG.sysmode(7) = '1') then             
        elsif ( INIT='1' and INITVALUE = '1') then             
             CRC_tool            <= (others => '0');  --CRC tool by easics
                 
             CRC_own             <= (others => '0');  --own implementation                                   
             CRC_own_i           := (others => '0');                                                                               
        else                      
            
            CRC_own_i(DATAWIDTH-1 downto 0) := DATA_IN xor CRC_own_i(DATAWIDTH downto 1);                        
            CRC_own_i(DATAWIDTH)            := '0';
            
            for i in (DATAWIDTH) downto 0 loop     
                      
                if (CRC_own_i(CRC_own_i'high) = '1') then                
                    temp             := (CRC_own_i xor POLYNOMIAL); 
                    CRC_own_i        := (temp(DATAWIDTH-1 downto 0) & '0');  
                        
                    tmparray(DATAWIDTH-i)     <= temp;    
                        
                else                                                            
                    CRC_own_i        := (CRC_own_i(DATAWIDTH-1 downto 0) & '0');
                end if;                                                                                                                   
            end loop;                                                
            
            if (DATAWIDTH = 10) then
                CRC_tool   <= nextCRC10_D10(unsigned(DATA_IN),unsigned(CRC_tool));   --CRC tool by easics                           
            else  
                CRC_tool   <= nextCRC8_D8(unsigned(DATA_IN),unsigned(CRC_tool));  --CRC tool by easics     
            end if;    
                
            CRC_own    <= CRC_own_i(DATAWIDTH downto 1);    --own implementation                                                                                                             
        end if;   
        
                                                                             
                                                    
    end if;
    
  end process; 
    
end rtl;
