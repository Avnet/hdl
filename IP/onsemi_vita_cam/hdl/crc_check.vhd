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
library work;
use work.all;
--use work.app_pack.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity crc_checker is
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
--        APP_CFG_REG		        : in    AppCfgRegTp;        
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
end crc_checker;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of crc_checker is

component crc_calc 
  generic (
         DATAWIDTH       : integer := 8;
         POLYNOMIAL      : std_logic_vector := "101001101";
         USE_CRC_TOOL    : boolean := TRUE         
  );  
  port ( -- System
--  		 APP_CFG_REG		    : in    AppCfgRegTp;
       INITVALUE               : in    std_logic;

  		 CLOCK			: in	std_logic;
  		 RESET      	: in    std_logic;
  		 -- Data input
  		 INIT			: in	std_logic;
         DATA_IN        : in    std_logic_vector(DATAWIDTH-1 downto 0);
         CRC_OUT        : out   std_logic_vector(DATAWIDTH-1 downto 0)
        );
end component;
    
component crc_comp 
  generic (
         DATAWIDTH       : integer := 8        
  );  
  port ( -- System
  		 CLOCK			: in	std_logic;
  		 RESET      	: in    std_logic;
  		 
  		 -- Data input
  		 en_decoder     : in    std_logic;
  		 VALID			: in	std_logic;
  		 
         SENS_CRC_IN    : in    std_logic_vector(DATAWIDTH-1 downto 0);
         CALC_CRC_IN    : in    std_logic_vector(DATAWIDTH-1 downto 0);
                        
         STATUS         : out   std_logic
        );
end component;
                        
--signals

type CRCcheckstatetp is (   Idle,
                            Valid
                        );
                        
signal CRCcheckstate : CRCcheckstatetp;
                                                
signal init         : std_logic;

signal calc_CRC     : std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);
              
signal PAR_DATA_int                 : std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0) ; 
signal PAR_DATA_IMGVALID_int        : std_logic; 
signal PAR_DATA_BLACKVALID_int      : std_logic;       
signal PAR_DATA_CRCVALID_int        : std_logic;     
signal PAR_DATA_LINE_int            : std_logic; 
signal PAR_DATA_FRAME_int           : std_logic; 
signal PAR_SYNC_int                 : std_logic_vector((DATAWIDTH)-1 downto 0) ;   
signal START_KERNEL_int             : std_logic;      
signal KERNEL_ODD_EVEN_int          : std_logic;    
signal VIDEO_SYNC_int               : std_logic_vector(4 downto 0);

begin

-- generate parallel CRC checkers
generate_CRC: for i in 0 to (NROF_DATACONN-1) generate

the_crc_calc: crc_calc 
  generic map(
         DATAWIDTH       => DATAWIDTH   ,
         POLYNOMIAL      => POLYNOMIAL  ,
         USE_CRC_TOOL    => TRUE
  ) 
  port map( 
--  		 APP_CFG_REG		    => APP_CFG_REG,
       INITVALUE     => INITVALUE        ,
  		 CLOCK			=> CLOCK            ,
  		 RESET      	=> RESET            ,
  		 
  		 INIT			=> init                                                              ,
         DATA_IN        => PAR_DATA_int((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH))    ,
         CRC_OUT        => calc_crc((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH))
        );                                                                                                                
        
the_crc_comp: crc_comp
  generic map(
         DATAWIDTH       => DATAWIDTH          
  ) 
  port map(
  		 CLOCK			=> CLOCK                    ,
  		 RESET      	=> RESET                    ,
  		 
  		 en_decoder     => en_decoder               ,  		
  		 VALID			=> PAR_DATA_CRCVALID_int    ,
  		 
         SENS_CRC_IN    => PAR_DATA_int((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH))    ,
         CALC_CRC_IN    => calc_crc((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH))       ,
                        
         STATUS         => CRC_STATUS(i)  		   		   		   		   		 
  );        
     
end generate;
    
InitProcess: process(RESET, CLOCK)
begin
    if (RESET = '1') then  
        init            <= '1';    
        CRCcheckstate   <= Idle;
    elsif(CLOCK'event and CLOCK = '1') then  
        if (en_decoder ='1') then                                                              
            case CRCcheckstate is
                when Idle =>
                    init <= '1';     
                    if (PAR_DATA_IMGVALID_IN = '1' or PAR_DATA_BLACKVALID_IN = '1') then
                        init           <= '0';     
                        CRCcheckstate  <= Valid;                       
                    end if;    
                                                
                when Valid =>
                    init <= '0';            
                    if (PAR_DATA_IMGVALID_IN = '0' and PAR_DATA_BLACKVALID_IN = '0') then     
                        init <= '1'; 
                        CRCcheckstate  <= Idle; 
                    end if; 
                       
                when others =>
                    CRCcheckstate  <= Idle;
            end case;
        else
            init            <= '1';     
            CRCcheckstate  <= Idle;
        end if;         
    end if;

end process;

DataProcess: process(RESET, CLOCK)
begin
    if (RESET = '1') then  
             
        PAR_DATA_IMGVALID_OUT       <= '0';
        PAR_DATA_BLACKVALID_OUT     <= '0';                
        PAR_DATA_CRCVALID_OUT       <= '0';     
        
        PAR_DATA_IMGVALID_int       <= '0';
        PAR_DATA_BLACKVALID_int     <= '0';
        
        PAR_DATA_CRCVALID_int       <= '0';
        
        PAR_DATA_LINE_int           <= '0'; 
        PAR_DATA_FRAME_int          <= '0';     
        
        START_KERNEL_int            <= '0';  
        KERNEL_ODD_EVEN_int         <= '0';  
        VIDEO_SYNC_int              <= (others => '0');
        
        START_KERNEL_OUT            <= '0';  
        KERNEL_ODD_EVEN_OUT         <= '0';  
        VIDEO_SYNC_OUT              <= (others => '0');
        
        PAR_DATA_LINE_OUT           <= '0'; 
        PAR_DATA_FRAME_OUT          <= '0'; 
        
        PAR_SYNC_int                <= (others => '0');
        PAR_SYNC_OUT                <= (others => '0');
        
    elsif (CLOCK'event and CLOCK = '1') then  
                      
        PAR_DATA_int             <= PAR_DATA_IN;  
        PAR_DATA_OUT             <= PAR_DATA_int;
        
        PAR_DATA_IMGVALID_int    <= PAR_DATA_IMGVALID_IN;  
        PAR_DATA_BLACKVALID_int  <= PAR_DATA_BLACKVALID_IN;        
           
        PAR_DATA_IMGVALID_OUT    <= PAR_DATA_IMGVALID_int;  
        PAR_DATA_BLACKVALID_OUT  <= PAR_DATA_BLACKVALID_int;
        
        PAR_DATA_CRCVALID_int    <= PAR_DATA_CRCVALID_IN;
        
        PAR_DATA_CRCVALID_OUT    <= PAR_DATA_CRCVALID_int;
        
        PAR_DATA_LINE_int        <= PAR_DATA_LINE_IN;  
        PAR_DATA_FRAME_int       <= PAR_DATA_FRAME_IN;
        
        PAR_DATA_LINE_OUT        <= PAR_DATA_LINE_int;  
        PAR_DATA_FRAME_OUT       <= PAR_DATA_FRAME_int;
        
        PAR_SYNC_int             <= PAR_SYNC_IN;
        PAR_SYNC_OUT             <= PAR_SYNC_int;
        
        START_KERNEL_int         <= START_KERNEL_IN;      
        KERNEL_ODD_EVEN_int      <= KERNEL_ODD_EVEN_IN;
        VIDEO_SYNC_int           <= VIDEO_SYNC_IN;
        
        START_KERNEL_OUT         <= START_KERNEL_int;    
        KERNEL_ODD_EVEN_OUT      <= KERNEL_ODD_EVEN_int;                                                                                        
        VIDEO_SYNC_OUT           <= VIDEO_SYNC_int;
    end if;

end process;

end rtl;




