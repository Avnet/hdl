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
-- Date           : $Date: 2011-01-11 13:22:13 +0100 (di, 11 jan 2011) $
-- Revision       : $Revision: 712 $
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

--xilinx:
---------
--Library XilinxCoreLib;
library unisim;
use unisim.vcomponents.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_mux is 
  generic(                                                                                                                
        DATAWIDTH       : integer;
        NROF_CONN       : integer
       );     
  port( 
        CLOCK           : in    std_logic;  
        RESET           : in    std_logic;        
        
        CLKDIV          : in    std_logic;                 
        
        -- select comes from the bitalign/wordalign statemachine and is aligned to CLOCK
        SEL             : in    std_logic_vector(15 downto 0);
        
                                       
        -- from/to ISERDES
        IODELAY_ISERDES_RESET   : out   std_logic_vector(NROF_CONN-1 downto 0);
        IODELAY_INC             : out   std_logic_vector(NROF_CONN-1 downto 0);
        IODELAY_CE              : out   std_logic_vector(NROF_CONN-1 downto 0);
        
        ISERDES_BITSLIP         : out   std_logic_vector(NROF_CONN-1 downto 0);
        
        ISERDES_DATA            : in    std_logic_vector((DATAWIDTH*NROF_CONN)-1 downto 0);  
        -- made as a one dimensional array, multidimensional arrays parameterisable with generics do not exist in VHDL
        
                       
        --from/to sync
        
        SYNC_RESET              : in    std_logic;
        SYNC_INC                : in    std_logic;
        SYNC_CE                 : in    std_logic;
        
        SYNC_BITSLIP            : in    std_logic;    
        
        SYNC_DATA               : out   std_logic_vector(DATAWIDTH-1 downto 0)
                                                                                                                                                                              
       );
       
end iserdes_mux;

architecture rtl of iserdes_mux is

begin
     
muxgen: if (NROF_CONN  > 1) generate

multiplexer: process(RESET, CLKDIV)
variable index : integer range 0 to (NROF_CONN-1);    
begin
if (RESET = '1') then
                                                                      
   IODELAY_ISERDES_RESET    <= (others => '0');
   IODELAY_INC              <= (others => '0');  
   IODELAY_CE               <= (others => '0');         
   
   ISERDES_BITSLIP          <= (others => '0');  
   
   SYNC_DATA                <= (others => '0');      
   
elsif (CLKDIV'event and CLKDIV = '1') then
    
    index :=   TO_INTEGER(UNSIGNED(SEL));    
    
    IODELAY_ISERDES_RESET(index)    <= SYNC_RESET; 
    IODELAY_INC(index)              <= SYNC_INC;  
    IODELAY_CE(index)               <= SYNC_CE;                               
        
    SYNC_DATA   <= ISERDES_DATA(((index+1)*DATAWIDTH)-1 downto (index*DATAWIDTH));
    
    ISERDES_BITSLIP(index)          <= SYNC_BITSLIP;
                          
end if;
end process multiplexer;

end generate;

nomuxgen: if (NROF_CONN  = 1) generate

multiplexer: process(RESET, CLKDIV)
variable index : integer range 0 to (NROF_CONN-1);    
begin
if (RESET = '1') then
                                                                      
   IODELAY_ISERDES_RESET    <= (others => '0');
   IODELAY_INC              <= (others => '0');  
   IODELAY_CE               <= (others => '0');         
   
   ISERDES_BITSLIP          <= (others => '0');    
   
   SYNC_DATA                <= (others => '0');      
   
elsif (CLKDIV'event and CLKDIV = '1') then

   IODELAY_ISERDES_RESET(0) <= SYNC_RESET;
   IODELAY_INC(0)           <= SYNC_INC;
   IODELAY_CE(0)            <= SYNC_CE;
                            
   ISERDES_BITSLIP(0)       <= SYNC_BITSLIP;
                     
   SYNC_DATA                <= ISERDES_DATA; 
        
end if;
end process multiplexer;
                                      
end generate;

end rtl;



