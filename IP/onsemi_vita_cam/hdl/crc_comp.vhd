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
-- Date           : $Date: 2010-03-17 12:13:46 +0100 (Wed, 17 Mar 2010) $
-- Revision       : $Revision: 62 $
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

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity crc_comp is
  generic (
         DATAWIDTH       : integer := 8        
  );  
  port ( -- System
  		 CLOCK			: in	std_logic;
  		 RESET      	: in    std_logic;
  		 -- Data input
  		 en_decoder     : in	std_logic;
  		 VALID			: in	std_logic;
  		 
         SENS_CRC_IN    : in    std_logic_vector(DATAWIDTH-1 downto 0);
         CALC_CRC_IN    : in    std_logic_vector(DATAWIDTH-1 downto 0);
                        
         STATUS         : out   std_logic
        );
end;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of crc_comp is

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

type CompareStatetp is (   
                        Idle,
                        LookForFirstValid,
                        LookForNextValid,
                        Error        
                    );
                    
signal CompareState : CompareStatetp;

--------------------
-- MAIN BEHAVIOUR --
--------------------
begin

-- CRC detector
-- status 0 = OK, status 1 = ERROR
--
-- An error is generated either when:
-- 1. the system has not run yet (after reset)
-- 2. a CRC is detected but not equal to the calculated crc
-- 3. no CRC is detected while looking for one (when sync pattern is not decoded correctly, ie when no sensor is inserted)

-- this way 
        
  
  CRCcomp:process(CLOCK, RESET)  
 
  begin  
    if (RESET ='1') then           
        STATUS          <= '1';  
        CompareState    <= Idle; 
        
      --
    elsif (CLOCK'event and CLOCK = '1') then
        --if (en_decoder = '1') then
            case CompareState is
                when Idle =>   
                    if (en_decoder = '1') then     
                        CompareState    <= LookForFirstValid;   
                    end if; 
                     
                when LookForFirstValid =>
                    if (en_decoder = '1') then 
                        if (VALID = '1') then
                            if (SENS_CRC_IN = CALC_CRC_IN) then
                                STATUS          <= '0';  
                                CompareState    <= LookForNextValid;                                     
                            else
                                STATUS          <= '1';
                                CompareState    <= Error;                                                                                                                        
                            end if;                                                                                            
                        end if;                                                
                    else 
                        STATUS          <= '1';
                        CompareState    <= Idle; 
                    end if; 
                    
                when LookForNextValid =>
                    if (en_decoder = '1') then 
                        if (VALID = '1') then
                            if (SENS_CRC_IN = CALC_CRC_IN) then
                                STATUS          <= '0';                                     
                            else
                                STATUS          <= '1';
-- Keep updating current CRC STATUS
-- (for ChipScope debugging only !)
--                                CompareState    <= Error;                                                                                                                        
                            end if;                                                                                            
                        end if;                                                
                    else 
                        CompareState    <= Idle; 
                    end if; 
                    
                    
                when Error =>                 
                    if (en_decoder = '0') then
                        CompareState    <= Idle;
                    end if; 
                
                when others => 
                    CompareState    <= Idle;                 
                        
            end case;             
         --else             
         --   CompareState    <= Idle;      
         --end if;
                                                     
    end if;
    
  end process; 
    
end rtl;
