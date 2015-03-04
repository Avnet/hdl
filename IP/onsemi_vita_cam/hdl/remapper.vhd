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
-- Date           : $Date: 2010-04-20 15:55:23 +0200 (di, 20 apr 2010) $
-- Revision       : $Revision: 225 $
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

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity remapper is
  generic (  
        NROF_DATACONN       : integer;
        DATAWIDTH           : integer;
        NROF_WINDOWS        : integer
  );
  port (
        -- Control signals
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;
       
        WriteCfg            : in    std_logic_vector(2 downto 0);
        RemapMode           : in    std_logic_vector(2 downto 0);
                                                                                                                                                    
        -- Data input
        --from serial   
        PAR_SYNC            : in    std_logic_vector((DATAWIDTH)-1 downto 0);  
        PAR_DATA            : in    std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);  
        PAR_DATA_IMGVALID   : in    std_logic;   
        PAR_DATA_BLACKVALID : in    std_logic; 
        PAR_DATA_CRCVALID   : in    std_logic; 
        PAR_DATA_LINE       : in    std_logic; 
        PAR_DATA_FRAME      : in    std_logic; 
        
        -- kernel odd/even control
        START_KERNEL        : in    std_logic;        
        KERNEL_ODD_EVEN     : in    std_logic;
        VIDEO_SYNC_IN       : in    std_logic_vector(4 downto 0);
        VIDEO_SYNC_OUT      : out   std_logic_vector(4 downto 0);                        
                                        
        en_decoder          : in    std_logic; 
        
        -- Data output
        PAR_DATA_OUT        : out   std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);        
        PAR_DATA_VALID_OUT  : out   std_logic;                                       
        PAR_DATA_LINE_OUT   : out   std_logic;                                       
        PAR_DATA_FRAME_OUT  : out   std_logic;                                       
        PAR_DATA_WINDOW_OUT : out   std_logic                                                                                                                                                                                        
  );
end remapper;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of remapper is

signal index        : integer range 0 to 1;

signal kernel       : std_logic;
signal resetindex   : std_logic;

signal DATA         : std_logic_vector((NROF_DATACONN*DATAWIDTH*2)-1 downto 0);
signal DATA_r       : std_logic_vector((NROF_DATACONN*DATAWIDTH*2)-1 downto 0);
signal VALID        : std_logic; 
signal VALID_r      : std_logic;
signal LLINE        : std_logic;
signal FRAME        : std_logic; 
signal WINDOW       : std_logic;
signal LLINE_r      : std_logic_vector(1 downto 0); 
signal FRAME_r      : std_logic_vector(1 downto 0);
signal WINDOW_r     : std_logic_vector(1 downto 0);   
signal LLINE_r2     : std_logic_vector(1 downto 0); 
signal FRAME_r2     : std_logic_vector(1 downto 0);
signal WINDOW_r2    : std_logic_vector(1 downto 0);      
          
signal DATA_BUS_VALID       : std_logic;
signal DATA_BUS     : std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);
signal SYNC_BUS     : std_logic_vector(DATAWIDTH-1 downto 0);
    
alias Channel1In    : std_logic_vector(DATAWIDTH-1 downto 0) is PAR_DATA(DATAWIDTH*0+DATAWIDTH-1 downto DATAWIDTH*0); 
alias Channel2In    : std_logic_vector(DATAWIDTH-1 downto 0) is PAR_DATA(DATAWIDTH*1+DATAWIDTH-1 downto DATAWIDTH*1); 
alias Channel3In    : std_logic_vector(DATAWIDTH-1 downto 0) is PAR_DATA(DATAWIDTH*2+DATAWIDTH-1 downto DATAWIDTH*2); 
alias Channel4In    : std_logic_vector(DATAWIDTH-1 downto 0) is PAR_DATA(DATAWIDTH*3+DATAWIDTH-1 downto DATAWIDTH*3); 

alias Channel1Out   : std_logic_vector(DATAWIDTH-1 downto 0) is PAR_DATA_OUT(DATAWIDTH*0+DATAWIDTH-1 downto DATAWIDTH*0); 
alias Channel2Out   : std_logic_vector(DATAWIDTH-1 downto 0) is PAR_DATA_OUT(DATAWIDTH*1+DATAWIDTH-1 downto DATAWIDTH*1);  
alias Channel3Out   : std_logic_vector(DATAWIDTH-1 downto 0) is PAR_DATA_OUT(DATAWIDTH*2+DATAWIDTH-1 downto DATAWIDTH*2);              
alias Channel4Out   : std_logic_vector(DATAWIDTH-1 downto 0) is PAR_DATA_OUT(DATAWIDTH*3+DATAWIDTH-1 downto DATAWIDTH*3);              


signal VIDEO_SYNC_r1 : std_logic_vector(4 downto 0);
signal VIDEO_SYNC_r2 : std_logic_vector(4 downto 0);
signal VIDEO_SYNC_r3 : std_logic_vector(4 downto 0);
   
begin
         
-- 1 kernel always contains 8 ADCs
-- 8 ADCs * 10 bits = 80 bits -> 12 bit aligned this is always 768 bits

        

RemapProcess: process(RESET, CLOCK)
begin
    if (RESET = '1') then  
        
        VALID       <= '0';
        index       <= 0;               
        
        resetindex  <= '0'; 
        
        --DATA        <= (others => '0');
         
        LLINE       <= '0';  
        FRAME       <= '0';                               
        WINDOW    <= '0';
        
        LLINE_r       <= (others => '0');
        FRAME_r       <= (others => '0');
        WINDOW_r      <= (others => '0');                            
                    
    elsif(CLOCK'event and CLOCK = '1') then   
        VALID     <= '0';
        
        
        LLINE     <= PAR_DATA_LINE;
        FRAME     <= PAR_DATA_FRAME;
        WINDOW    <= '0'; --not yet supported                
        
        LLINE_r(1)       <= '0';
        FRAME_r(1)       <= '0';
        WINDOW_r(1)      <= '0';    
                            
        -- serial mode
        resetindex          <= not en_decoder;
        SYNC_BUS            <= PAR_SYNC;      
        DATA_BUS            <= PAR_DATA;
        DATA_BUS_VALID      <= (PAR_DATA_IMGVALID and WriteCfg(0)) or (PAR_DATA_BLACKVALID and WriteCfg(1));
                                                                                                                                                  
        case RemapMode(2 downto 0) is
            when "000" => -- normal            
                if (kernel = '0') then -- even kernel
                    if (resetindex = '1') then
                        index <= 0;
                    elsif (DATA_BUS_VALID = '1') then        
                        for i in 0 to (NROF_DATACONN-1) loop                                   
                            if (DATAWIDTH=10) then --10 bit mode                            
                                DATA((2*i*10)+9+index*10 downto  (2*i*10)+index*10) <= DATA_BUS((i*10)+9 downto i*10);                                
                            else    --8 bit mode 
                                DATA((2*i*8)+7+index*8 downto  (2*i*8)+index*8) <= DATA_BUS((i*8)+7 downto i*8);                          
                            end if;
                        end loop; 
                        
                        if (index = 0) then         
                            LLINE_r(0)      <= LLINE;    
                            FRAME_r(0)      <= FRAME;    
                            WINDOW_r(0)     <= WINDOW;   
                        end if;
                                                                                                                                                                                                                       
                        if (index = 1) then
                            index <= 0;  
                        else
                            index <= index + 1;   
                        end if;                  
                    end if;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                else                   -- odd kernel                    
                    if (resetindex = '1') then     
                        index <= 0; 
                    elsif (DATA_BUS_VALID = '1') then  
                        for i in 0 to (NROF_DATACONN-1) loop                                                     
                            if (DATAWIDTH=10) then --10 bit mode                            
                                DATA((2*i*10)+9+(1-index)*10 downto  (2*i*10)+(1-index)*10) <= DATA_BUS(((NROF_DATACONN-i-1)*10)+9 downto (NROF_DATACONN-i-1)*10);                                
                            else                   --8 bit mode
                                DATA((2*i*8)+7+(1-index)*8 downto  (2*i*8)+(1-index)*8) <= DATA_BUS(((NROF_DATACONN-i-1)*8)+7 downto (NROF_DATACONN-i-1)*8);
                            end if;
                        end loop;  
                        
                        if (index = 0) then         
                            LLINE_r(0)      <= LLINE;    
                            FRAME_r(0)      <= FRAME;    
                            WINDOW_r(0)     <= WINDOW;   
                        end if; 
                        
                        if (index = 1) then
                            index <= 0;  
                        else
                            index <= index + 1;   
                        end if;                                                            
                    end if;                                                                                                                                                                                                                                                                                                                
                end if;
                                                                                                                                     
            when "001" => -- subsampling mono/binning                  
                    if (resetindex = '1') then 
                        index <= 0; 
                    elsif (DATA_BUS_VALID = '1') then  
                        for i in 0 to (NROF_DATACONN-1) loop 
                            if (index = 0) then --0                              
                                if (DATAWIDTH=10) then --10 bit mode                            
                                    DATA((i*10)+9 downto  (i*10)) <= DATA_BUS((i*10)+9 downto i*10);                                
                                else                   --8 bit mode
                                    DATA((i*8)+7 downto  (i*8)) <= DATA_BUS((i*8)+7 downto i*8);
                                end if;
                            else                --1
                                if (DATAWIDTH=10) then --10 bit mode                            
                                    DATA(  (((NROF_DATACONN-1)-i)*10)+9+(NROF_DATACONN*DATAWIDTH) downto  (((NROF_DATACONN-1)-i)*10)+(NROF_DATACONN*DATAWIDTH) ) <= DATA_BUS((i*10)+9 downto i*10);                                
                                else                   --8 bit mode
                                    DATA(  (((NROF_DATACONN-1)-i)*8)+7+(NROF_DATACONN*DATAWIDTH) downto  (((NROF_DATACONN-1)-i)*8)+(NROF_DATACONN*DATAWIDTH) ) <= DATA_BUS((i*8)+7 downto i*8);
                                end if;                                                                                                       
                            end if;    
                        end loop;  
                        
                        if (index = 0) then         
                            LLINE_r(0)      <= LLINE;    
                            FRAME_r(0)      <= FRAME;    
                            WINDOW_r(0)     <= WINDOW;   
                        end if;
                                                                                                                                                          
                        if (index = 1) then
                            index <= 0;  
                        else
                            index <= index + 1;   
                        end if;                                                                          
                    end if;                                                                                                                                
                    
                                                
            when "010" =>   -- subsampling color              
                    if (resetindex = '1') then 
                        index <= 0; 
                    elsif (DATA_BUS_VALID = '1') then   
                        if (index = 0) then --0                                                              
                                DATA((DATAWIDTH*0)+(DATAWIDTH-1) downto (DATAWIDTH*0)) <= DATA_BUS((1*DATAWIDTH)-1 downto (0*DATAWIDTH)) ; --0     
                                DATA((DATAWIDTH*7)+(DATAWIDTH-1) downto (DATAWIDTH*7)) <= DATA_BUS((2*DATAWIDTH)-1 downto (1*DATAWIDTH)) ; --2     
                                DATA((DATAWIDTH*2)+(DATAWIDTH-1) downto (DATAWIDTH*2)) <= DATA_BUS((3*DATAWIDTH)-1 downto (2*DATAWIDTH)) ; --4     
                                DATA((DATAWIDTH*5)+(DATAWIDTH-1) downto (DATAWIDTH*5)) <= DATA_BUS((4*DATAWIDTH)-1 downto (3*DATAWIDTH)) ; --6                                                                                                                                                                                                                   
                        else                --1
                                DATA((DATAWIDTH*1)+(DATAWIDTH-1) downto (DATAWIDTH*1)) <= DATA_BUS((1*DATAWIDTH)-1 downto (0*DATAWIDTH)) ; --0     
                                DATA((DATAWIDTH*6)+(DATAWIDTH-1) downto (DATAWIDTH*6)) <= DATA_BUS((2*DATAWIDTH)-1 downto (1*DATAWIDTH)) ; --2     
                                DATA((DATAWIDTH*3)+(DATAWIDTH-1) downto (DATAWIDTH*3)) <= DATA_BUS((3*DATAWIDTH)-1 downto (2*DATAWIDTH)) ; --4     
                                DATA((DATAWIDTH*4)+(DATAWIDTH-1) downto (DATAWIDTH*4)) <= DATA_BUS((4*DATAWIDTH)-1 downto (3*DATAWIDTH)) ; --6                                                                                                                                                                                                                                                                                                                                                                                                                                           
                        end if;
                                                        
                        if (index = 0) then         
                            LLINE_r(0)      <= LLINE;    
                            FRAME_r(0)      <= FRAME;    
                            WINDOW_r(0)     <= WINDOW;   
                        end if;                                                                                                                                             
                            
                        if (index = 1) then
                           index <= 0;  
                        else
                           index <= index + 1;   
                        end if;     
                    end if;                                                                                                                                             
           
                 
           when "011" => --no remapping
               if (resetindex = '1') then
                       index <= 0;
               elsif (DATA_BUS_VALID = '1' ) then                                                                                
                   for i in 0 to (NROF_DATACONN-1) loop                                   
                       if (DATAWIDTH=10) then --10 bit mode 
                           DATA((index*(NROF_DATACONN*DATAWIDTH))+(i*10)+9 downto  (index*(NROF_DATACONN*DATAWIDTH))+(i*10)) <= DATA_BUS((i*10)+9 downto i*10) ;                                                                                                                 
                       else                   --8 bit mode
                           DATA((index*(NROF_DATACONN*DATAWIDTH))+(i*8)+7 downto  (index*(NROF_DATACONN*DATAWIDTH))+(i*8)) <= DATA_BUS((i*8)+7 downto i*8);
                       end if;
                   end loop; 
                   
                   if (index = 0) then         
                       LLINE_r(0)      <= LLINE;    
                       FRAME_r(0)      <= FRAME;    
                       WINDOW_r(0)     <= WINDOW;   
                   end if;                                   
                   
                   if (index = 1) then
                       index <= 0;  
                   else
                       index <= index + 1;   
                   end if;                  
               end if;
                 
            when "100" =>  --  -- synchro channel on all outputs                                
             -- synchro channel on all outputs 
             if (resetindex = '1') then
                      index <= 0;
              elsif (DATA_BUS_VALID = '1') then                                                                                                     
                  for i in 0 to (NROF_DATACONN-1) loop                                   
                      if (DATAWIDTH=10) then --10 bit mode                           
                          DATA((index*(NROF_DATACONN*DATAWIDTH))+(i*10)+9 downto  (index*(NROF_DATACONN*DATAWIDTH))+(i*10)) <= SYNC_BUS(9 downto 0) ;                                                                                                                 
                      else                   --8 bit mode
                          DATA((index*(NROF_DATACONN*DATAWIDTH))+(i*8)+7 downto  (index*(NROF_DATACONN*DATAWIDTH))+(i*8)) <= SYNC_BUS(7 downto 0);
                      end if;
                  end loop; 
                  
                  if (index = 0) then         
                       LLINE_r(0)      <= LLINE;    
                       FRAME_r(0)      <= FRAME;    
                       WINDOW_r(0)     <= WINDOW;   
                  end if;      
                  
                  if (index = 1) then
                      index <= 0;  
                  else
                      index <= index + 1;   
                  end if;                  
              end if; 
            
            when "101" =>  --  -- synchro channel on first output                                
             -- synchro channel on all outputs 
             if (resetindex = '1') then
                      index <= 0;
              elsif (DATA_BUS_VALID = '1') then                                                                                                     
                  for i in 0 to 0 loop                                   
                      if (DATAWIDTH=10) then --10 bit mode                           
                          DATA((index*(NROF_DATACONN*DATAWIDTH))+(i*10)+9 downto  (index*(NROF_DATACONN*DATAWIDTH))+(i*10)) <= SYNC_BUS(9 downto 0) ;                                                                                                                 
                      else                   --8 bit mode
                          DATA((index*(NROF_DATACONN*DATAWIDTH))+(i*8)+7 downto  (index*(NROF_DATACONN*DATAWIDTH))+(i*8)) <= SYNC_BUS(7 downto 0);
                      end if;
                  end loop;
                                  
                  for i in 1 to (NROF_DATACONN-1) loop                                   
                       if (DATAWIDTH=10) then --10 bit mode 
                           DATA((index*(NROF_DATACONN*DATAWIDTH))+(i*10)+9 downto  (index*(NROF_DATACONN*DATAWIDTH))+(i*10)) <= DATA_BUS((i*10)+9 downto i*10) ;                                                                                                                 
                       else                   --8 bit mode
                           DATA((index*(NROF_DATACONN*DATAWIDTH))+(i*8)+7 downto  (index*(NROF_DATACONN*DATAWIDTH))+(i*8)) <= DATA_BUS((i*8)+7 downto i*8);
                       end if;
                   end loop; 
                  
                  if (index = 0) then         
                       LLINE_r(0)      <= LLINE;    
                       FRAME_r(0)      <= FRAME;    
                       WINDOW_r(0)     <= WINDOW;   
                  end if;      
                  
                  if (index = 1) then
                      index <= 0;  
                  else
                      index <= index + 1;   
                  end if;                  
              end if;
                                                                                                   
            when others =>
            
        end case;
       
       if (index = 1 and DATA_BUS_VALID = '1') then
        VALID     <= '1';   
       else
        VALID     <= '0';  
       end if;                      
    end if;
end process;

-- kernelselector for normal mode
kernelselector: process(RESET, CLOCK) 
begin                    
    if (RESET = '1') then  
        kernel <= '0';                               
    elsif (CLOCK'event and CLOCK = '1') then        
        if (START_KERNEL = '1') then
            kernel <= KERNEL_ODD_EVEN;                        
        else  
            if (index = 1 and DATA_BUS_VALID = '1') then  
                kernel <= not kernel;
            end if;                
        end if;                          
    end if;  
end process; 

mux: process(RESET, CLOCK) 
begin                    
    if (RESET = '1') then  
           
    --DATA_r      <= (others => '0');
    VALID_r       <= '0';
          
    PAR_DATA_OUT            <= (others => '0'); 
    PAR_DATA_VALID_OUT      <= '0';
    PAR_DATA_LINE_OUT       <= '0';
    PAR_DATA_FRAME_OUT      <= '0';
    PAR_DATA_WINDOW_OUT     <= '0';  

    VIDEO_SYNC_r1           <= (others => '0');
    VIDEO_SYNC_r2           <= (others => '0'); 
    VIDEO_SYNC_r3           <= (others => '0');
    VIDEO_SYNC_OUT          <= (others => '0');
                                                                               
    elsif (CLOCK'event and CLOCK = '1') then        
    
        VALID_r <= VALID;     
        DATA_r <= DATA;
        
        LLINE_r2    <= LLINE_r;  
        FRAME_r2    <= FRAME_r;  
        WINDOW_r2   <= WINDOW_r; 
        
        if (VALID = '1') then --full word valid, write LSBs
            PAR_DATA_OUT <= DATA((NROF_DATACONN*DATAWIDTH)-1 downto 0);        
            PAR_DATA_LINE_OUT       <= LLINE_r(0);       
            PAR_DATA_FRAME_OUT      <= FRAME_r(0);      
            PAR_DATA_WINDOW_OUT     <= WINDOW_r(0);                                                    
        elsif (VALID_r = '1') then
            PAR_DATA_OUT <= DATA_r((NROF_DATACONN*DATAWIDTH*2)-1 downto (NROF_DATACONN*DATAWIDTH));  
            PAR_DATA_LINE_OUT       <= LLINE_r2(1);        
            PAR_DATA_FRAME_OUT      <= FRAME_r2(1);        
            PAR_DATA_WINDOW_OUT     <= WINDOW_r2(1);                       
        end if;    
                   
        PAR_DATA_VALID_OUT      <= VALID or VALID_r;

       VIDEO_SYNC_r1           <= VIDEO_SYNC_IN;
       VIDEO_SYNC_r2           <= VIDEO_SYNC_r1;
       VIDEO_SYNC_r3           <= VIDEO_SYNC_r2;
       VIDEO_SYNC_OUT          <= VIDEO_SYNC_r3;
                                                           
    end if;   
                                                  
end process; 
                                          
end rtl;        