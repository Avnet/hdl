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
-- Date           : $Date: 2010-07-02 09:41:24 +0200 (vr, 02 jul 2010) $
-- Revision       : $Revision: 531 $
-- *********************************************************************
--                   Jun 18, 2014: - add C_INCLUDE_MONITOR to optionnally
--                                   remove monitor logic inside syncchanneldecoder
-- *********************************************************************
-- Description
--
-- *********************************************************************

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
entity syncchanneldecoder is
  generic (  
    NROF_CONN       : integer;
    DATAWIDTH       : integer;
    NROF_WINDOWS    : integer;
    C_INCLUDE_MONITOR : integer
  );
  port (
        -- Control signals
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;
              
        -- Internal signaling
        
        en_decoder          : in    std_logic;    
        --busy_decoder        : out   std_logic;   
        
        PAR_DATA_RDEN       : out   std_logic;   
        PAR_DATA_EMPTY      : in    std_logic;                         
        PAR_DATAIN          : in    std_logic_vector((NROF_CONN*DATAWIDTH)-1 downto 0);                                                                                                            
                
        PAR_SYNCOUT         : out   std_logic_vector((DATAWIDTH)-1 downto 0);        
        PAR_DATAOUT         : out   std_logic_vector(((NROF_CONN-1)*DATAWIDTH)-1 downto 0);  
        PAR_DATA_IMGVALID   : out   std_logic;   
        PAR_DATA_BLACKVALID : out   std_logic; 
        PAR_DATA_LINE       : out   std_logic; 
        PAR_DATA_FRAME      : out   std_logic; 
        KERNEL_ODD_EVEN     : out   std_logic;
        START_KERNEL        : out   std_logic;  
        
        StartOddEven        : in    std_logic_vector(31 downto 0); 
        
        LS_value            : in    std_logic_vector(9 downto 0); 
        LE_value            : in    std_logic_vector(9 downto 0); 
        FS_value            : in    std_logic_vector(9 downto 0); 
        FE_value            : in    std_logic_vector(9 downto 0); 
        BL_value            : in    std_logic_vector(9 downto 0); 
        IMG_value           : in    std_logic_vector(9 downto 0); 
        TR_value            : in    std_logic_vector(9 downto 0); 
        CRC_value           : in    std_logic_vector(9 downto 0); 
        
                                                                 
        -- synchro signals
        framestart          : out   std_logic;   
                              
        windowstart         : out   std_logic;   
        windowend           : out   std_logic;   
                        
        linestart           : out   std_logic;
        lineend             : out   std_logic;
                      
        blacklinestart      : out   std_logic;
        blacklineend        : out   std_logic;
                      
        imagelinestart      : out   std_logic;
        imagelineend        : out   std_logic;                                        
                      
        validcrc            : out   std_logic;                                                                                                
        
        -- counters         
        FramesCnt           : out   std_logic_vector(31 downto 0);
    
        -- lines/frame counter
        BlackLinesCnt       : out   std_logic_vector(31 downto 0);  
        ImgLinesCnt         : out   std_logic_vector(31 downto 0);   
    
        -- pixels/frame counter       
        BlackPixelCnt       : out   std_logic_vector(31 downto 0); 
        ImgPixelCnt         : out   std_logic_vector(31 downto 0);    
    
        -- windows/frame counter
        WindowsCnt          : out   std_logic_vector(31 downto 0);     
    
        -- clocks/frame counter -> fps
        ClocksCnt           : out   std_logic_vector(31 downto 0);
            
        StartLineCnt        : out   std_logic_vector(31 downto 0);
        EndLineCnt          : out   std_logic_vector(31 downto 0);
         
        -- monitors        
        MONITOR             : in    std_logic_vector(1 downto 0);
                    
        Monitor0HighCnt     : out   std_logic_vector(31 downto 0);  
        Monitor0LowCnt      : out   std_logic_vector(31 downto 0); 
        Monitor1HighCnt     : out   std_logic_vector(31 downto 0);
        Monitor1LowCnt      : out   std_logic_vector(31 downto 0)                                                                                                                                                                                                                                                                                                                      
  );
end syncchanneldecoder;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of syncchanneldecoder is

alias  SyncChannel : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAIN((DATAWIDTH-1) downto 0); 
alias  DataChannels : std_logic_vector(((NROF_CONN-1)*DATAWIDTH-1) downto 0) is PAR_DATAIN((NROF_CONN*DATAWIDTH-1) downto DATAWIDTH); 
 
--debug only
--inp
alias DataChannel0 : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAIN((DATAWIDTH-1)+1*DATAWIDTH downto 1*DATAWIDTH); 
alias DataChannel1 : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAIN((DATAWIDTH-1)+2*DATAWIDTH downto 2*DATAWIDTH);  
alias DataChannel2 : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAIN((DATAWIDTH-1)+3*DATAWIDTH downto 3*DATAWIDTH);  
alias DataChannel3 : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAIN((DATAWIDTH-1)+4*DATAWIDTH downto 4*DATAWIDTH);  
--outp    
alias ParOutChannel0 : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAOUT((DATAWIDTH-1)+0*DATAWIDTH downto 0*DATAWIDTH); 
alias ParOutChannel1 : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAOUT((DATAWIDTH-1)+1*DATAWIDTH downto 1*DATAWIDTH);  
alias ParOutChannel2 : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAOUT((DATAWIDTH-1)+2*DATAWIDTH downto 2*DATAWIDTH);  
alias ParOutChannel3 : std_logic_vector((DATAWIDTH-1) downto 0) is PAR_DATAOUT((DATAWIDTH-1)+3*DATAWIDTH downto 3*DATAWIDTH);                              
           
type SyncDelayPipetp is array (0 to 5) of std_logic_vector((DATAWIDTH-1) downto 0);
signal SyncDelayPipe    : SyncDelayPipetp;
type DataDelayPipetp is array (0 to SyncDelayPipe'high) of std_logic_vector(((NROF_CONN-1)*DATAWIDTH-1) downto 0); 
signal DataDelayPipe   : DataDelayPipetp; 
signal DataValidPipe    : std_logic_vector(0 to 5);
 
constant zeros          : std_logic_vector((DATAWIDTH-1) downto 0) := (others => '0');  
  
--signal extstartframe    : std_logic;  
--signal intstartframe    : std_logic;  
signal startframe       : std_logic; 

signal startwindow      : std_logic;   
signal endwindow        : std_logic;

signal startwindowid    : std_logic_vector(1023 downto 0);    
signal endwindowid      : std_logic_vector(1023 downto 0);      

signal windowid         : std_logic_vector((DATAWIDTH-1) downto 0); 
                        
signal startline        : std_logic;   
signal endline          : std_logic; 

signal startblackline   : std_logic;   
signal endblackline     : std_logic; 

signal startimageline   : std_logic;   
signal endimageline     : std_logic;

signal blackdatavalid   : std_logic;      
signal imgdatavalid     : std_logic;
signal datavalid        : std_logic;

signal crcvalid         : std_logic;

signal en_valid         : std_logic;
       
--signal firststartframe  : std_logic; 
--signal nextstartframe   : std_logic;      

signal StartLineCntr    : std_logic_vector(31 downto 0);
signal EndLineCntr      : std_logic_vector(31 downto 0);

signal rst_cntrs        : std_logic;
signal decode           : std_logic;       
--signal dec              : std_logic;      
signal enpipe           : std_logic_vector(15 downto 0);                                                     
signal syncvalid        : std_logic;
signal syncvalid_r      : std_logic;

-- framescounter
signal FramesCntr       : std_logic_vector(31 downto 0);
    
-- lines/frame counter
signal BlackLinesCntr   : std_logic_vector(31 downto 0);  
signal ImgLinesCntr     : std_logic_vector(31 downto 0);   
    
-- pixels/frame counter       
signal BlackPixelCntr   : std_logic_vector(31 downto 0); 
signal ImgPixelCntr     : std_logic_vector(31 downto 0);    
    
-- windows/frame counter
signal WindowsCntr      : std_logic_vector(31 downto 0);     
    
-- clocks/frame counter -> fps
signal ClocksCntr       : std_logic_vector(31 downto 0);  
--signal ClocksCnt        : std_logic_vector(31 downto 0);  

type DataStatetp is (
                            Idle,
                            Valid
                          );
                          
signal BlackDataState : DataStatetp;                          
signal ImgDataState   : DataStatetp;  

type DecoderEnablerStatetp is (
                            Idle,      
                            DetectEnableStart,                      
                            --DetectFirstFrameStart,                           
                            Enabled
                          );
                         
signal DecoderEnablerState : DecoderEnablerStatetp; 

type blacklinecntstatetp is ( 
                 WaitFirstBlackLine,
                 CountBlackLines
                 );
signal blacklinecntstate : blacklinecntstatetp;

signal Monitor0HighCntr : std_logic_vector(31 downto 0);
signal Monitor0LowCntr  : std_logic_vector(31 downto 0);
signal Monitor1HighCntr : std_logic_vector(31 downto 0);
signal Monitor1LowCntr  : std_logic_vector(31 downto 0);


signal monitor_rising   : std_logic_vector(1 downto 0);    
signal monitor_falling  : std_logic_vector(1 downto 0);   
    
type Monitor_synctp is array (2 downto 0) of std_logic_vector(1 downto 0);   
signal Monitor_sync : Monitor_synctp;                        

begin


PAR_DATA_RDEN   <= enpipe(4);
en_valid        <= enpipe(15) and en_decoder;
syncvalid       <= not PAR_DATA_EMPTY;
syncvalid_r     <= DataValidPipe(0); 
 
EnPipePr: process(RESET, CLOCK) 
begin                                      
    if (RESET = '1') then
        enpipe  <= (others => '0');
    elsif (CLOCK'event and CLOCK = '1') then 
        
        enpipe(0) <= en_decoder;       
            
        for i in 0 to enpipe'high-1 loop
            enpipe(i+1) <= enpipe(i);
        end loop;                                                                               
        
    end if;
end process;

DataPipe: process(RESET, CLOCK) 
begin                                      
    if (RESET = '1') then
        SyncDelayPipe   <= (others => (others => '0')); 
        PAR_SYNCOUT     <= (others => '0');    
        -- DataDelayPipe doesnt need reset state
        DataValidPipe   <= (others => '0');    
        
        PAR_DATA_LINE       <= '0';                 
        PAR_DATA_FRAME      <= '0';             
                        
    elsif (CLOCK'event and CLOCK = '1') then
        
        PAR_DATA_LINE        <= (startimageline or startblackline) and syncvalid_r; --needs one cycle delay
        PAR_DATA_FRAME       <= startframe and syncvalid_r;
                                                                            
        if (PAR_DATA_EMPTY = '0') then
                SyncDelayPipe(0) <= SyncChannel;
                DataDelayPipe(0) <= DataChannels;                                                
            for i in 0 to (SyncDelayPipe'high-1) loop            
                    SyncDelayPipe(i+1) <= SyncDelayPipe(i); 
                    DataDelayPipe(i+1) <= DataDelayPipe(i);                           
            end loop; 
        end if;
                  
        PAR_DATAOUT <= DataDelayPipe(3);
        PAR_SYNCOUT <= SyncDelayPipe(3);                            
       
        for i in 0 to (DataValidPipe'high-1) loop      
            DataValidPipe(i+1) <= DataValidPipe(i);   
        end loop;
       
        DataValidPipe(0) <= not PAR_DATA_EMPTY;       
                            
    end if;  
end process;        
          
PAR_DATA_IMGVALID      <= imgdatavalid and DataValidPipe(1); 
PAR_DATA_BLACKVALID    <= blackdatavalid and DataValidPipe(1);
                               
                  
framestart <= startframe;
              
windowstart <= startwindow;
windowend <= endwindow;
              
linestart <= startline;   
lineend <= endline;      
              
blacklinestart <= startblackline;
blacklineend <= endblackline;
              
imagelinestart <= startimageline;
imagelineend <= endimageline; 
              
validcrc <= crcvalid and DataValidPipe(1);   
    
-- counters             
FramesCnt <= FramesCntr;            
                        
-- lines/frame count    
BlackLinesCnt <= BlackLinesCntr;
ImgLinesCnt <= ImgLinesCntr;            
                        
-- pixels/frame count    
BlackPixelCnt <= BlackPixelCntr;                      
ImgPixelCnt <= ImgPixelCntr;          
                        
-- windows/frame count    
WindowsCnt <= WindowsCntr;  

--
StartLineCnt    <= StartLineCntr;
EndLineCnt      <= EndLineCntr;

--extstartframe <= nextstartframe or firststartframe;
                                                                          
Decoder: process(RESET, CLOCK) 
begin                                      
    if (RESET = '1') then  
        startframe          <= '0';     
        startwindow         <= '0';    
        endwindow           <= '0';                            
        startline           <= '0';                            
        startblackline      <= '0';  
        startimageline      <= '0'; 
        endline             <= '0';    
        endblackline        <= '0';                          
        endimageline        <= '0';   
        
        datavalid           <= '0';  
        blackdatavalid      <= '0';  
        imgdatavalid        <= '0';                              
        
        crcvalid            <= '0';
        
--        StartFrameState     <= Idle; 
        BlackDataState      <= Idle;
        
        windowid            <= (others => '0'); 
        startwindowid       <= (others => '0');        
        endwindowid         <= (others => '0');                  
        
--        firststartframe     <= '0'; 
--        nextstartframe      <= '0';
        
        decode              <= '0';                              
               
    elsif (CLOCK'event and CLOCK = '1') then
                       
        -- detect framestart by:
        -- 1. first looking for a linestart from a blackline
        -- 2. then look for the first framestart available    
        
        --framedetection for decoder enabler 
        -- startframe is detected 2 clks before internal startframe, should be enough
        
        --firststartframe   <= '0';  
               
        if (en_valid = '1') then                                 
            --if (syncvalid = '1') then                                                           
                case DecoderEnablerState is
                    when Idle =>      
                        decode <= '0';                        
                        if (SyncDelayPipe(2) = LS_value(9 downto (10-DATAWIDTH)) and  SyncDelayPipe(0) = BL_value(9 downto (10-DATAWIDTH))) then                                           
                            DecoderEnablerState <= DetectEnableStart;
                        end if;
                    
                    when DetectEnableStart =>
                        if (SyncDelayPipe(0) = FS_value(9 downto (10-DATAWIDTH))) then                          
                            decode                 <= '1';  
                            --firststartframe     <= '1';       
                            DecoderEnablerState <= Enabled;                                                                                          
                        end if;                                       
                                                                    
                    when Enabled => 
                        decode          <= '1';         
                                                            
                    when others =>
                        DecoderEnablerState <= Idle;            
                end case;
            --end if;
        else 
             decode <= '0';                       
             DecoderEnablerState <= Idle;                   
        end if;                                                
                      
             
        if (decode = '1') then                  
            startframe     <= '0';                        
                if (SyncDelayPipe(2) = FS_value(9 downto (10-DATAWIDTH)) and SyncDelayPipe(1) = zeros(9 downto (10-DATAWIDTH) )) then                
                    startframe  <= '1';                 
                end if;                                                                                                           
        else
            startframe     <= '0';            
        end if;                                                                                                                             
        -- frameend detect, not feasible without software...
                            
        --start window detection 
        if (decode = '1') then                  
            startwindow     <= '0';  
            startwindowid   <= (others => '0');                                     
                if (SyncDelayPipe(2) = FS_value(9 downto (10-DATAWIDTH))) then                
                    startwindow  <= '1';   
                    startwindowid( TO_INTEGER(UNSIGNED(SyncDelayPipe(1))) ) <= '1';
                    windowid     <= SyncDelayPipe(1);
                end if;                                                                                                           
        else
            startwindow     <= '0';   
            startwindowid   <= (others => '0');           
        end if;
            
        --end window detection                       
        if (decode = '1') then
            endwindow       <= '0'; 
            endwindowid     <= (others => '0');             
                if (SyncDelayPipe(4) = FE_value(9 downto (10-DATAWIDTH))) then                
                    endwindow <= '1'; 
                    endwindowid(TO_INTEGER(UNSIGNED(SyncDelayPipe(3))) ) <= '1';               
                end if; 
        else        
            endwindowid     <= (others => '0');                              
            endwindow <= '0'; 
        end if;    
              
        -- start line pulse generation                                           
        --startline is detected every startline code passes
        if (decode = '1') then
            startline <= '0';
                if (SyncDelayPipe(2) = LS_value(9 downto (10-DATAWIDTH))) then                
                    startline <= '1';            
                end if;
        else
            startline <= '0';     
        end if;            
        --startblackline is detected after every combination of LS + dontcare + BL
        if (decode = '1') then
            startblackline <= '0';    
                if (SyncDelayPipe(2) = LS_value(9 downto (10-DATAWIDTH)) and  SyncDelayPipe(0) = BL_value(9 downto (10-DATAWIDTH))) then                
                    startblackline <= '1';           
                end if;
        else
            startblackline <= '0';          
        end if;
        --startimageline is detected after either:
        -- 1. LS + dontcare + IMG (a normal line without a funny windowing exception)
        -- 2. LS + LS + dontcare (2 linestarts right after eachother -> 2 startimagelines will be detected)
        -- 3. LS + dontcare + LS (2 linestarts almost right after eachother -> 2 startimagelines will be detected
        -- 4. in theory 3 linestarts could follow eachother, this is not supported for now.        
        -- 5. the same with FS in place of LS (ignore MSB)
        
        -- note: case 2 and case 4 are probably not possible
                              
        if (decode = '1') then
            startimageline <= '0';
                if ((SyncDelayPipe(2)(DATAWIDTH-2 downto 0) = LS_value(8 downto (10-DATAWIDTH)) and  SyncDelayPipe(0) = IMG_value(9 downto (10-DATAWIDTH))) or
                   (SyncDelayPipe(2)(DATAWIDTH-2 downto 0) = LS_value(8 downto (10-DATAWIDTH)) and  SyncDelayPipe(1)(DATAWIDTH-2 downto 0) = LS_value(8 downto (10-DATAWIDTH))) or
                   (SyncDelayPipe(2)(DATAWIDTH-2 downto 0) = LS_value(8 downto (10-DATAWIDTH)) and  SyncDelayPipe(0)(DATAWIDTH-2 downto 0) = LS_value(8 downto (10-DATAWIDTH)))                                                                                                                                                                                         
                    ) then                
                    startimageline <= '1';           
                end if;  
        else 
            startimageline <= '0';     
        end if;
                
        -- end line pulse generation
        -- endline is detected every endline code passes
        if (decode = '1') then 
            endline <= '0';      
                if (SyncDelayPipe(4) = LE_value(9 downto (10-DATAWIDTH))) then                
                    endline <= '1';            
                end if;                   
        else 
            endline <= '0';    
        end if;
              
        -- endblackline is detected after BL + LE        
        if (decode = '1') then  
            endblackline <= '0'; 
                if (SyncDelayPipe(5) = BL_value(9 downto (10-DATAWIDTH)) and  SyncDelayPipe(4) = LE_value(9 downto (10-DATAWIDTH))) then     
                    endblackline <= '1';    
                end if;                          
        else              
            endblackline <= '0';                 
        end if;
            
        -- endimageline is detected after either 
        -- 1. IMG + LE
        -- 2. LE + LE           
        -- 3 the same with frameend             
        if (decode = '1') then   
            endimageline <= '0';
                if (SyncDelayPipe(5) = IMG_value(9 downto (10-DATAWIDTH)) and  SyncDelayPipe(4)(DATAWIDTH-2 downto 0) = LE_value(8 downto (10-DATAWIDTH))) or
                    (SyncDelayPipe(5)(DATAWIDTH-2 downto 0) = LE_value(8 downto (10-DATAWIDTH)) and  SyncDelayPipe(4)(DATAWIDTH-2 downto 0) = LE_value(8 downto (10-DATAWIDTH)))            
                then     
                    endimageline <= '1';    
                end if;                           
        else
            endimageline <= '0';                    
        end if;
            
        -- data valid generation
        -- simple valid data, independant of black or img       
        -- always valid except when TR and CRC are present
        
        datavalid <= '0';
        if (decode = '1') then            
                if (SyncDelayPipe(3) = TR_value(9 downto (10-DATAWIDTH)) or 
                    SyncDelayPipe(3) = CRC_value(9 downto (10-DATAWIDTH))                                                                                             
                    ) then                
                    datavalid <= '0';                   
                else
                    datavalid <= '1';                                                      
                end if;
        end if;                           
        
        --black data valid    
        -- black lines are non overlapping with other windows -> all blackline start/ blackline end pulses should be present                
        if (decode = '1') then
                case BlackDataState is
                    when Idle =>
                        if (startblackline = '1' and syncvalid_r = '1') then
                            blackdatavalid <= '1';     
                            BlackDataState <= Valid;  
                        else
                            blackdatavalid <= '0';     
                        end if;
                        
                    when Valid =>
                        if (endblackline = '1' and syncvalid_r = '1') then
                            blackdatavalid <= '0';  
                            BlackDataState <= Idle; 
                        else
                            blackdatavalid <= '1';                                                                 
                        end if;
                end case;   
        else
            blackdatavalid <= '0';  
            BlackDataState <= Idle;                       
        end if;
        
        -- image data valid -> valid data and not black data = img data            
        --img data valid
        --imgdatavalid <= datavalid and not blackdatavalid;      
        
        if (decode = '1') then
                case ImgDataState is
                    when Idle =>
                        if (startimageline = '1' and syncvalid_r = '1') then
                            imgdatavalid <= '1';     
                            ImgDataState <= Valid; 
                        else    
                            imgdatavalid <= '0';           
                        end if;
                        
                    when Valid =>
                        if (endimageline = '1' and startimageline = '0' and syncvalid_r = '1') then                          
                            imgdatavalid <= '0';  
                            ImgDataState <= Idle;
                        else    
                            imgdatavalid <= '1';                                                                       
                        end if;
                end case;                                 
        else
            imgdatavalid <= '0';  
            ImgDataState <= Idle;                       
        end if;
                                                                
        -- CRC
        if (decode = '1') then
            crcvalid <= '0';
                if (SyncDelayPipe(3) = CRC_value(9 downto (10-DATAWIDTH))) then                
                    crcvalid <= '1';          
                end if;
        else
            crcvalid <= '0';
        end if;
        
                    
    end if;  
end process;                                
  
Counters: process(RESET, CLOCK)        
begin                                      
  if (RESET = '1') then                   
        
     StartLineCntr  <= (others => '0');
     EndLineCntr <= (others => '0');
            
     rst_cntrs <= '0';
     
     FramesCntr <= (others => '0');
     BlackLinesCntr <= (others => '0');       
     ImgLinesCntr <= (others => '0');     
     BlackPixelCntr <= (others => '0'); 
     ImgPixelCntr <= (others => '0');
     
     WindowsCntr <= (others => '0');   
     ClocksCntr <= (others => '0'); 
     ClocksCnt <= (others => '0');                                                                                            
  elsif (CLOCK'event and CLOCK = '1') then      
    
    -- counter rst logic
    if (enpipe(0) = '1' and enpipe(1) = '0') then --rising edge 
        rst_cntrs <= '1';
    else
        rst_cntrs <= '0';
    end if;    
    
    -- startlinecounter (/readout) (including black lines)
    if (rst_cntrs = '1' ) then
        StartLineCntr <= (others => '0');   
        EndLineCntr   <= (others => '0');            
    else        
        if (syncvalid_r = '1') then                                                                                                                
                if (startline = '1' and decode = '1') then
                    StartLineCntr <= StartLineCntr + '1';   
                end if; 
                if (endline = '1' and decode = '1') then
                    EndLineCntr <= EndLineCntr + '1';   
                end if;                                                                                                                                                
        end if;
    end if;  
                             
    -- framescounter
    if (rst_cntrs = '1') then
        FramesCntr <= (others => '0');
    else   
        if (syncvalid_r = '1') then
            if (startframe = '1' and decode = '1') then
                FramesCntr <= FramesCntr + '1';   
            end if;          
        end if;
    end if;            
    
    -- lines/frame counter
    -- counts total amount of blacklines 
            
    if (rst_cntrs = '1') then
        BlackLinesCntr      <= (others => '0'); 
        blacklinecntstate   <= WaitFirstBlackLine;            
    else
        if (syncvalid_r = '1') then
            case blacklinecntstate is
                
                when WaitFirstBlackLine =>
                    if (startblackline = '1') then
                        BlackLinesCntr      <= X"00000001";
                        blacklinecntstate   <= CountBlackLines;
                    end if;    
                
                when CountBlackLines =>  
                    if (startblackline = '1') then
                        BlackLinesCntr      <= BlackLinesCntr + '1';
                    elsif (startimageline = '1') then
                        blacklinecntstate   <= WaitFirstBlackLine;
                    end if;
                                            
                when others =>
                    blacklinecntstate   <= WaitFirstBlackLine;
                        
            end case;                            
        end if;                
    end if;
    
    if (rst_cntrs = '1' or (startframe = '1' and decode = '1')) then    
        ImgLinesCntr <= (others => '0');            
    else
        if (syncvalid_r = '1'  and decode = '1') then
            if (startimageline = '1') then
                ImgLinesCntr <= ImgLinesCntr + '1';
            end if;
        end if;                
    end if;
              
    -- pixels/frame counter      
    if (rst_cntrs = '1' or startblackline = '1') then
        BlackPixelCntr <= (others => '0');            
    else
        if (syncvalid_r = '1') then
            if (blackdatavalid = '1') then
                BlackPixelCntr <= BlackPixelCntr + '1';
            end if;
        end if;                
    end if;           
             
    if (rst_cntrs = '1' or (startimageline = '1' and decode = '1')) then
        ImgPixelCntr <= (others => '0');            
    else
        if (syncvalid_r = '1' and decode = '1') then
            if (imgdatavalid = '1') then
                ImgPixelCntr <= ImgPixelCntr + '1';
            end if;
        end if;                
    end if;         
                                                 
    -- windows/frame counter
    if (rst_cntrs = '1') then
        WindowsCntr <= (others => '0'); 
    elsif (startframe = '1' and decode = '1') then  --equal to the first window start
        WindowsCntr <= X"00000001";        
    else
        if (syncvalid_r = '1' and decode = '1') then
            if (startwindow = '1') then
                WindowsCntr <= WindowsCntr + '1';
            end if;
        end if;                
    end if;    
        
    -- clocks/frame counter -> fps
    if (startframe = '1' and syncvalid_r = '1') then
        ClocksCntr <= (others => '0'); 
        ClocksCnt  <= ClocksCntr;    
    else
        ClocksCntr <= ClocksCntr + '1';                        
    end if;
 
  end if; 
end process;

-- should run sync to data
Odd_Even_indication: process(RESET, CLOCK)
begin
if (RESET = '1') then
    KERNEL_ODD_EVEN <= '0';
    START_KERNEL    <= '0';
elsif(CLOCK = '1' and CLOCK'event) then
    START_KERNEL    <= '0';    
    if (startwindow = '1') then              
        KERNEL_ODD_EVEN <= StartOddEven(to_integer(unsigned(windowid(4 downto 0)))); 
        START_KERNEL    <= '1';       
    end if;                   
end if; 
end process;
          
WITH_MONITOR_PARSER : if (C_INCLUDE_MONITOR = 1) generate

-- monitor parser
-- also used for lightsource triggering
monitor_parser: process(RESET, CLOCK)
begin
if (RESET = '1') then
    
    Monitor0HighCntr    <= (others => '0');
    Monitor0LowCntr     <= (others => '0');
    Monitor1HighCntr    <= (others => '0');
    Monitor1LowCntr     <= (others => '0');    
    
    Monitor0HighCnt     <= (others => '0');
    Monitor0LowCnt      <= (others => '0');
    Monitor1HighCnt     <= (others => '0');
    Monitor1LowCnt      <= (others => '0');             
    
    for i in 0 to 1 loop
        monitor_rising(i)   <= '0';    
        monitor_falling(i)  <= '0';                    
    end loop;      
    
    Monitor_sync        <= (others => (others => '0'));      
       
elsif(CLOCK = '1' and CLOCK'event) then
    
    --defaults
                     
    Monitor_sync(0)(0)  <= MONITOR(0);
    Monitor_sync(0)(1)  <= MONITOR(1);      
        
    for i in 0 to (Monitor_sync'high - 1) loop
        Monitor_sync(i+1) <= Monitor_sync(i);           
    end loop;  
    
    -- monitor counters
    for i in 0 to 1 loop
    --defaults
    monitor_rising(i)   <= '0';    
    monitor_falling(i)  <= '0';                            
        if (decode = '1') then
           if (Monitor_sync(2)(i) = '0' and Monitor_sync(1)(i) = '1') then --rising edge
              monitor_rising(i) <= '1';       
           elsif (Monitor_sync(2)(0) = '1' and Monitor_sync(1)(i) = '0') then --falling edge 
              monitor_falling(i) <= '1';    
           end if;
        end if;          
    end loop;          
    
    if (decode = '1') then
        if (monitor_rising(0) = '1') then
            Monitor0HighCnt <= Monitor0HighCntr;
            Monitor0HighCntr <= (others => '0');
        elsif (Monitor_sync(2)(0) = '1') then
            Monitor0HighCntr <= Monitor0HighCntr + '1';
        end if;    
            
        if (monitor_falling(0) = '1') then
            Monitor0LowCnt <= Monitor0LowCntr;
            Monitor0LowCntr <= (others => '0');
        elsif (Monitor_sync(2)(0) = '0') then
            Monitor0LowCntr <= Monitor0LowCntr + '1';
        end if;       
            
        if (monitor_rising(1) = '1') then
            Monitor1HighCnt <= Monitor1HighCntr;
            Monitor1HighCntr <= (others => '0');
        elsif (Monitor_sync(2)(1) = '1') then
            Monitor1HighCntr <= Monitor1HighCntr + '1';
        end if;    
            
        if (monitor_falling(1) = '1') then
            Monitor1LowCnt <= Monitor1LowCntr;
            Monitor1LowCntr <= (others => '0');
        elsif (Monitor_sync(2)(1) = '0') then
            Monitor1LowCntr <= Monitor1LowCntr + '1';
        end if;                      
    end if;    
                  
end if; 
end process;         

end generate WITH_MONITOR_PARSER;
                                                                                                                     
end rtl;
