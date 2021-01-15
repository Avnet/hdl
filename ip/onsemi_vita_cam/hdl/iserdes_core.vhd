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
-- Revision:            
--                      Feb 22, 2012: 1.09 Modified
--                                         - port to Zynq
--                      Oct 28, 2014: 1.15 Fix reset for IDELAYE2 primitive
--                                         which caused intermittent vertical bar issues
--                                         
--
------------------------------------------------------------------

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
-- Date           : $Date: 2011-02-21 14:30:23 +0100 (ma, 21 feb 2011) $
-- Revision       : $Revision: 800 $
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
library unisim;
use unisim.vcomponents.all;  
-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_core is
  generic(
       DATAWIDTH        : integer := 10;    -- can be 4, 6, 8 or 10 for DDR, can be 2, 3, 4, 5, 6, 7, or 8 for SDR.
       DATA_RATE        : string  := "DDR"; -- DDR/SDR   
       DIFF_TERM        : boolean := TRUE;
       USE_FIFO         : boolean := FALSE;
       USE_BLOCKRAMFIFO : boolean := TRUE;
       INVERT_OUTPUT    : boolean := FALSE; 
       INVERSE_BITORDER : boolean := FALSE;
       C_FAMILY         : string  := "virtex6"
  );
  port( 
        CLOCK                   : in    std_logic; --system clock, sync to local clock
        RESET                   : in    std_logic;
        
        -- Data IO
        -- clk src can be internal or external
        CLK                     : in    std_logic; -- high speed serial clock, either internal/external source, 
        CLKb                    : in    std_logic; -- can come from DCM/PLL, IBUF, BUFIO
        
        CLKDIV                  : in    std_logic; -- parallel clock, derived from CLK using DCM/PLL or BUFR        
                                                   -- can be same as clock/appclock in synchronous systems 
                                                   
        -- differential data input -> from outside, necesarry buffer is present in this file
        SDATAP                  : in    std_logic; 
        SDATAN                  : in    std_logic;
                                              
        --Ctrl IO, all controls should run on CLKDIV/parallelclk
        IODELAY_ISERDES_RESET   : in    std_logic;
        
        -- iodelay control        
        IODELAY_INC             : in    std_logic;
        IODELAY_CE              : in    std_logic;
                
        -- iserdes_nodelay control
        ISERDES_BITSLIP         : in    std_logic;
        ISERDES_DATAOUT         : out   std_logic_vector(DATAWIDTH-1 downto 0); --iserdes data, sync to clkdiv. can be used when fifo is not used
        
        -- fifo control
        FIFO_RESET              : in    std_logic;
        --write side, sync to clkdiv         
        FIFO_WREN               : in    std_logic; 
        --readside                         
        FIFO_RDEN               : in    std_logic;
        FIFO_EMPTY              : out   std_logic;                                     
        FIFO_DATAOUT            : out   std_logic_vector(DATAWIDTH-1 downto 0)                                                                                                                                                                                                                                                                                         
       );

attribute S: string;   
attribute keep: string;

attribute S of FIFO_EMPTY       : signal is "yes";
attribute keep of FIFO_EMPTY    : signal is "yes";

end iserdes_core;

architecture rtl of iserdes_core is       

component iserdes_fifo_10_bit IS               
	port (                                    
	rst: IN std_logic;                        
	wr_clk: IN std_logic;                     
	rd_clk: IN std_logic;                     
	din: IN std_logic_VECTOR(9 downto 0);     
	wr_en: IN std_logic;                      
	rd_en: IN std_logic;                      
	dout: OUT std_logic_VECTOR(9 downto 0);   
	full: OUT std_logic;                      
	empty: OUT std_logic);                    
END component;                    

component iserdes_fifo_8_bit IS               
	port (                                    
	rst: IN std_logic;                        
	wr_clk: IN std_logic;                     
	rd_clk: IN std_logic;                     
	din: IN std_logic_VECTOR(7 downto 0);     
	wr_en: IN std_logic;                      
	rd_en: IN std_logic;                      
	dout: OUT std_logic_VECTOR(7 downto 0);   
	full: OUT std_logic;                      
	empty: OUT std_logic);                    
END component;    

component iserdes_fifo_6_bit IS               
	port (                                    
	rst: IN std_logic;                        
	wr_clk: IN std_logic;                     
	rd_clk: IN std_logic;                     
	din: IN std_logic_VECTOR(5 downto 0);     
	wr_en: IN std_logic;                      
	rd_en: IN std_logic;                      
	dout: OUT std_logic_VECTOR(5 downto 0);   
	full: OUT std_logic;                      
	empty: OUT std_logic);                    
END component;    

signal SerialIn             : std_logic;
signal SerialIoDelayOut     : std_logic;

constant zero               : std_logic := '0';
constant one                : std_logic := '1';

constant zeros              : std_logic_vector(31 downto 0) := X"00000000"; 
    
signal SHIFT_FROM_SLAVE1    : std_logic;  
signal SHIFT_FROM_SLAVE2    : std_logic;  

signal SHIFT_TO_SLAVE1      : std_logic;     
signal SHIFT_TO_SLAVE2      : std_logic;

signal MASTER_DATA          : std_logic_vector(7 downto 0);        
signal SLAVE_DATA           : std_logic_vector(7 downto 0);

signal ISERDES_DATA         : std_logic_vector(DATAWIDTH-1 downto 0);      
   
signal DI                   : std_logic_vector(15 downto 0);    
signal DO                   : std_logic_vector(15 downto 0);    
  
signal CLKb_inv             : std_logic;
signal CLKDIVb_inv          : std_logic;

signal FIFO_FULL            : std_logic;

attribute S of FIFO_FULL       : signal is "yes";
attribute keep of FIFO_FULL    : signal is "yes";

signal CNTVALUEOUT          : std_logic_vector(4 downto 0);

begin

CLKb_inv  <= not CLKB;    
-- differential buffer
IBUFDS_inst : IBUFDS
generic map (
    CAPACITANCE => "DONT_CARE",     -- "LOW", "NORMAL", "DONT_CARE" (Virtex-4 only)
    DIFF_TERM => DIFF_TERM,         -- Differential Termination (Virtex-4/5, Spartan-3E/3A)
    IBUF_DELAY_VALUE => "0",        -- Specify the amount of added input delay for buffer, "0"-"16" (Spartan-3E/3A only)
    IFD_DELAY_VALUE => "AUTO",      -- Specify the amount of added delay for input register, "AUTO", "0"-"8" (Spartan-3E/3A only)
    IOSTANDARD => "DEFAULT")
port map (
O   =>  SerialIn    ,   -- Clock buffer output
I   =>  SDATAP      ,   -- Diff_p clock buffer input (connect directly to top-level port)
IB  =>  SDATAN       -- Diff_n clock buffer input (connect directly to top-level port)
);


IODELAY_V5_GEN : if (C_FAMILY = "virtex5") generate

-- iodelay
IODELAY_inst : IODELAY
  generic map (
    DELAY_SRC                   => "I",
                                -- Specify which input port to be used
                                -- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
    HIGH_PERFORMANCE_MODE       => TRUE,
                                -- TRUE specifies lower jitter
                                -- at expense of more power
    IDELAY_TYPE                 => "VARIABLE",
                                -- "DEFAULT", "FIXED" or "VARIABLE"
    IDELAY_VALUE                => 0,
                                -- 0 to 63 tap values
    ODELAY_VALUE                => 0,
                                -- 0 to 63 tap values
    REFCLK_FREQUENCY            => 200.0,
                                -- Frequency used for IDELAYCTRL
                                -- 175.0 to 225.0
    SIGNAL_PATTERN              => "DATA"
                                -- Input signal type, "CLOCK" or "DATA"
  )
  port map (
    DATAOUT                     => SerialIoDelayOut         ,    -- 1-bit delayed data output
    C                           => CLKDIV                   ,    -- 1-bit clock input
    CE                          => IODELAY_CE               ,    -- 1-bit clock enable input
    DATAIN                      => zero                     ,    -- 1-bit internal data input
    IDATAIN                     => SerialIn                 ,    -- 1-bit input data input (connect to port)
    INC                         => IODELAY_INC              ,    -- 1-bit increment/decrement input
    ODATAIN                     => zero                     ,    -- 1-bit output data input
    RST                         => IODELAY_ISERDES_RESET    ,    -- 1-bit active high, synch reset input
    T                           => one                   -- 1-bit 3-state control input
  );

end generate IODELAY_V5_GEN;

IODELAY_V6_GEN : if (C_FAMILY = "virtex6") generate

-- iodelay
IODELAYE1_inst : IODELAYE1
  generic map (
    DELAY_SRC                   => "I",
                                -- Specify which input port to be used
                                -- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
    HIGH_PERFORMANCE_MODE       => TRUE,
                                -- TRUE specifies lower jitter
                                -- at expense of more power
    IDELAY_TYPE                 => "VARIABLE",
                                -- "DEFAULT", "FIXED" or "VARIABLE"
    IDELAY_VALUE                => 0,
                                -- 0 to 63 tap values
    ODELAY_VALUE                => 0,
                                -- 0 to 63 tap values
    REFCLK_FREQUENCY            => 200.0,
                                -- Frequency used for IDELAYCTRL
                                -- 175.0 to 225.0
    SIGNAL_PATTERN              => "DATA"
                                -- Input signal type, "CLOCK" or "DATA"
  )
  port map (
    DATAOUT                     => SerialIoDelayOut         ,    -- 1-bit delayed data output
    C                           => CLKDIV                   ,    -- 1-bit clock input
    CE                          => IODELAY_CE               ,    -- 1-bit clock enable input
    DATAIN                      => zero                     ,    -- 1-bit internal data input
    IDATAIN                     => SerialIn                 ,    -- 1-bit input data input (connect to port)
    INC                         => IODELAY_INC              ,    -- 1-bit increment/decrement input
    ODATAIN                     => zero                     ,    -- 1-bit output data input
    RST                         => IODELAY_ISERDES_RESET    ,    -- 1-bit active high, synch reset input
    T                           => one                      ,    -- 1-bit 3-state control input
    CINVCTRL                    => '0'                      ,    -- 1-bit input: Dynamic clock inversion input
    CLKIN                       => '0'                      ,    -- 1-bit input: Clock delay input
    CNTVALUEIN                  => (others => '0')          ,    -- 5-bit input: Counter value input
--    CNTVALUEOUT                 => open                          -- 5-bit output: Counter value output
    CNTVALUEOUT                 => CNTVALUEOUT
  );

end generate IODELAY_V6_GEN;

IDELAY_K7_GEN : if (C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate

-- iodelay
IDELAYE2_inst : IDELAYE2
  generic map (
    CINVCTRL_SEL                => "FALSE", -- Dynamic clock inversion
    DELAY_SRC                   => "IDATAIN",
                                -- Specify which input port to be used
                                -- "I"=IDATAIN, "O"=ODATAIN, "DATAIN"=DATAIN, "IO"=Bi-directional
    HIGH_PERFORMANCE_MODE       => "TRUE",
                                -- TRUE specifies lower jitter
                                -- at expense of more power
    IDELAY_TYPE                 => "VARIABLE",
                                -- "DEFAULT", "FIXED" or "VARIABLE"
    IDELAY_VALUE                => 0,
                                -- 0 to 63 tap values
    PIPE_SEL                    => "FALSE",
    REFCLK_FREQUENCY            => 200.0,
                                -- Frequency used for IDELAYCTRL
                                -- 175.0 to 225.0
    SIGNAL_PATTERN              => "DATA"
                                -- Input signal type, "CLOCK" or "DATA"
  )
  port map (
--  CNTVALUEOUT                 => open,
    CNTVALUEOUT                 => CNTVALUEOUT,
    CINVCTRL                    => '0',
    CNTVALUEIN                  => (others => '0'),
--  LD                          => '0',
    LD                          => IODELAY_ISERDES_RESET    , -- 1-bit, In VAR_LOAD mode, it loads the value of CNTVALUEIN.
    LDPIPEEN                    => '0',
    --
    DATAOUT                     => SerialIoDelayOut         , -- 1-bit delayed data output
    C                           => CLKDIV                   , -- 1-bit clock input
    CE                          => IODELAY_CE               , -- 1-bit clock enable input
    DATAIN                      => zero                     , -- 1-bit internal data input
    IDATAIN                     => SerialIn                 , -- 1-bit input data input (connect to port)
    INC                         => IODELAY_INC              , -- 1-bit increment/decrement input
--  REGRST                      => IODELAY_ISERDES_RESET      -- 1-bit active high, synch reset input
    REGRST                      => '0'                        -- 1-bit active high, Reset for the pipeline register. Only used in VAR_LOAD_PIPE mode.
  );

end generate IDELAY_K7_GEN;
 
-- iserdes

-- datawidth
-- can be 4, 6, 8 or 10 for DDR, can be 2, 3, 4, 5, 6, 7, or 8 for SDR.

MASTER_ISERDES_V5_GEN : if (C_FAMILY = "virtex5") generate
   Master_iserdes : ISERDES_NODELAY
   generic map( 
            BITSLIP_ENABLE  => TRUE         ,
            DATA_RATE       => DATA_RATE    ,
            DATA_WIDTH      => DATAWIDTH    ,
            INIT_Q1         => '0'          ,
            INIT_Q2         => '0'          ,
            INIT_Q3         => '0'          ,
            INIT_Q4         => '0'          ,
            INTERFACE_TYPE  => "NETWORKING" ,
            NUM_CE          => 2            ,
            SERDES_MODE     => "MASTER"
            )
      port map (
                BITSLIP     => ISERDES_BITSLIP          ,
                CE1         => one                      ,
                CE2         => one                      ,
                CLK         => CLK                      ,
                CLKB        => CLKb_inv                 ,
                CLKDIV      => CLKDIV                   ,
                D           => SerialIoDelayOut         ,
                OCLK        => zero                     ,
                RST         => IODELAY_ISERDES_RESET    ,
                SHIFTIN1    => zero                     ,
                SHIFTIN2    => zero                     ,
                Q1          => MASTER_DATA(0)           ,
                Q2          => MASTER_DATA(1)           ,
                Q3          => MASTER_DATA(2)           ,
                Q4          => MASTER_DATA(3)           ,
                Q5          => MASTER_DATA(4)           ,
                Q6          => MASTER_DATA(5)           ,
                SHIFTOUT1   => SHIFT_TO_SLAVE1          ,
                SHIFTOUT2   => SHIFT_TO_SLAVE2      
                );
   MASTER_DATA(6) <= '0';                
   MASTER_DATA(7) <= '0';                
end generate MASTER_ISERDES_V5_GEN;

MASTER_ISERDES_V6_GEN : if (C_FAMILY = "virtex6") generate
   Master_iserdes : ISERDESE1
   generic map( 
            DATA_RATE       => DATA_RATE    ,
            DATA_WIDTH      => DATAWIDTH    ,
            INIT_Q1         => '0'          ,
            INIT_Q2         => '0'          ,
            INIT_Q3         => '0'          ,
            INIT_Q4         => '0'          ,
            INTERFACE_TYPE  => "NETWORKING" ,
            NUM_CE          => 2            ,
            SERDES_MODE     => "MASTER"     ,
            --
            DYN_CLKDIV_INV_EN => FALSE      , -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
            DYN_CLK_INV_EN    => FALSE      , -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
            IOBDELAY        => "IFD"        ,
            OFB_USED        => FALSE        ,
            SRVAL_Q1        => '0'          ,
            SRVAL_Q2        => '0'          ,
            SRVAL_Q3        => '0'          ,
            SRVAL_Q4        => '0'
            )
      port map (
                BITSLIP     => ISERDES_BITSLIP          ,
                CE1         => one                      ,
                CE2         => one                      ,
                CLK         => CLK                      ,
                CLKB        => CLKb_inv                     ,
                CLKDIV      => CLKDIV                   ,
                DDLY        => SerialIoDelayOut         , -- 1-bit input: Serial data from IDELAYE2
                OCLK        => zero                     ,
                RST         => IODELAY_ISERDES_RESET    ,
                SHIFTIN1    => zero                     ,
                SHIFTIN2    => zero                     ,
                Q1          => MASTER_DATA(0)           ,
                Q2          => MASTER_DATA(1)           ,
                Q3          => MASTER_DATA(2)           ,
                Q4          => MASTER_DATA(3)           ,
                Q5          => MASTER_DATA(4)           ,
                Q6          => MASTER_DATA(5)           ,
                SHIFTOUT1   => SHIFT_TO_SLAVE1          ,
                SHIFTOUT2   => SHIFT_TO_SLAVE2          ,
                --
                D           => '0',
                O           => open,
                OFB         => '0', -- 1-bit input: Data feedback from OSERDESE2
                -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inv pins to switch clk polarity
                DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
                DYNCLKSEL    => '0'  -- 1-bit input: Dynamic CLK/CLKB inversion
                );
   MASTER_DATA(6) <= '0';                
   MASTER_DATA(7) <= '0';                
end generate MASTER_ISERDES_V6_GEN;

MASTER_ISERDES_K7_GEN : if (C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate
   Master_iserdes : ISERDESE2
   generic map( 
            DATA_RATE       => DATA_RATE    ,
            DATA_WIDTH      => DATAWIDTH    ,
            INIT_Q1         => '0'          ,
            INIT_Q2         => '0'          ,
            INIT_Q3         => '0'          ,
            INIT_Q4         => '0'          ,
            INTERFACE_TYPE  => "NETWORKING" ,
            NUM_CE          => 2            ,
            SERDES_MODE     => "MASTER"     ,
            --
            DYN_CLKDIV_INV_EN => "FALSE"    , -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
            DYN_CLK_INV_EN    => "FALSE"    , -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
            IOBDELAY        => "IFD"        ,
            OFB_USED        => "FALSE"      ,
            SRVAL_Q1        => '0'          ,
            SRVAL_Q2        => '0'          ,
            SRVAL_Q3        => '0'          ,
            SRVAL_Q4        => '0'
            )
      port map (
                BITSLIP     => ISERDES_BITSLIP          ,
                CE1         => one                      ,
                CE2         => one                      ,
                CLK         => CLK                      ,
                CLKB        => CLKb_inv                 ,
                CLKDIV      => CLKDIV                   ,
                DDLY        => SerialIoDelayOut         , -- 1-bit input: Serial data from IDELAYE2
                OCLK        => zero                     ,
                RST         => IODELAY_ISERDES_RESET    ,
                SHIFTIN1    => zero                     ,
                SHIFTIN2    => zero                     ,
                Q1          => MASTER_DATA(0)           ,
                Q2          => MASTER_DATA(1)           ,
                Q3          => MASTER_DATA(2)           ,
                Q4          => MASTER_DATA(3)           ,
                Q5          => MASTER_DATA(4)           ,
                Q6          => MASTER_DATA(5)           ,
                Q7          => MASTER_DATA(6)           ,
                Q8          => MASTER_DATA(7)           ,
                SHIFTOUT1   => SHIFT_TO_SLAVE1          ,
                SHIFTOUT2   => SHIFT_TO_SLAVE2          ,
                --
                D           => '0',
                O           => open,
                CLKDIVP     => '0', -- 1-bit input: TBD
                OFB         => '0', -- 1-bit input: Data feedback from OSERDESE2
                OCLKB       => '0', -- 1-bit input: High speed negative edge output clock
                -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inv pins to switch clk polarity
                DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
                DYNCLKSEL    => '0'  -- 1-bit input: Dynamic CLK/CLKB inversion
                );
end generate MASTER_ISERDES_K7_GEN;

-- dual serdes modules needed for widths of 8 and 10 in DDR mode, and 7 and 8 in SDR mode

Slave_iserdes_gen: if (DATAWIDTH >6) generate

SLAVE_ISERDES_V5_V6_REORDER : if (C_FAMILY = "virtex5" or C_FAMILY = "virtex6") generate
        
    Normal_Output: if (INVERT_OUTPUT=FALSE) generate
        Normal_order: if (INVERSE_BITORDER=FALSE) generate                
            ISERDES_DATA(5 downto 0) <= MASTER_DATA(5 downto 0);                       
            ISERDES_DATA(DATAWIDTH-1 downto 6) <= SLAVE_DATA(DATAWIDTH-5 downto 2);  
        end generate;  
        
        Inverse_order: if (INVERSE_BITORDER=TRUE) generate                           
                gen_inverse_master: for i in 0 to 5 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= MASTER_DATA(i);
                end generate;
                gen_inverse_slave: for i in 6 to DATAWIDTH-1 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= SLAVE_DATA(i-4);                
                end generate;                                      
        end generate;                                 
   end generate;           
   
   Inverse_Output: if (INVERT_OUTPUT=TRUE) generate
        Normal_order: if (INVERSE_BITORDER=FALSE) generate                
            ISERDES_DATA(5 downto 0) <= not MASTER_DATA(5 downto 0);                       
            ISERDES_DATA(DATAWIDTH-1 downto 6) <= not SLAVE_DATA(DATAWIDTH-5 downto 2);  
        end generate;  
        
        Inverse_order: if (INVERSE_BITORDER=TRUE) generate                          
                gen_inverse_master: for i in 0 to 5 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= not MASTER_DATA(i);
                end generate;
                gen_inverse_slave: for i in 6 to DATAWIDTH-1 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= not SLAVE_DATA(i-4);                
                end generate;                                      
        end generate;                                 
   end generate;      

end generate SLAVE_ISERDES_V5_V6_REORDER;

SLAVE_ISERDES_K7_REORDER : if (C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate
        
    Normal_Output: if (INVERT_OUTPUT=FALSE) generate
        Normal_order: if (INVERSE_BITORDER=FALSE) generate                
            ISERDES_DATA(7 downto 0) <= MASTER_DATA(7 downto 0);                       
            ISERDES_DATA(DATAWIDTH-1 downto 8) <= SLAVE_DATA(DATAWIDTH-7 downto 2);  
        end generate;  
        
        Inverse_order: if (INVERSE_BITORDER=TRUE) generate                           
                gen_inverse_master: for i in 0 to 7 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= MASTER_DATA(i);
                end generate;
                gen_inverse_slave: for i in 8 to DATAWIDTH-1 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= SLAVE_DATA(i-6);                
                end generate;                                      
        end generate;                                 
   end generate;           
   
   Inverse_Output: if (INVERT_OUTPUT=TRUE) generate
        Normal_order: if (INVERSE_BITORDER=FALSE) generate                
            ISERDES_DATA(7 downto 0) <= not MASTER_DATA(7 downto 0);                       
            ISERDES_DATA(DATAWIDTH-1 downto 8) <= not SLAVE_DATA(DATAWIDTH-7 downto 2);  
        end generate;  
        
        Inverse_order: if (INVERSE_BITORDER=TRUE) generate                          
                gen_inverse_master: for i in 0 to 7 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= not MASTER_DATA(i);
                end generate;
                gen_inverse_slave: for i in 8 to DATAWIDTH-1 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= not SLAVE_DATA(i-6);                
                end generate;                                      
        end generate;                                 
   end generate;      

end generate SLAVE_ISERDES_K7_REORDER;
   
SLAVE_ISERDES_V5_GEN : if (C_FAMILY = "virtex5") generate  
   Slave_iserdes : ISERDES_NODELAY
   generic map( 
            BITSLIP_ENABLE  => TRUE         ,
            DATA_RATE       => DATA_RATE    ,
            DATA_WIDTH      => DATAWIDTH    ,
            INIT_Q1         => '0'          ,
            INIT_Q2         => '0'          ,
            INIT_Q3         => '0'          ,
            INIT_Q4         => '0'          ,
            INTERFACE_TYPE  => "NETWORKING" ,
            NUM_CE          => 2            ,
            SERDES_MODE     => "SLAVE"
            )
      port map (
                BITSLIP     => ISERDES_BITSLIP          ,
                CE1         => one                      ,
                CE2         => one                      ,
                CLK         => CLK                      ,
                CLKB        => CLKb_inv                 ,
                CLKDIV      => CLKDIV                   ,
                D           => zero                     ,
                OCLK        => zero                     ,
                RST         => IODELAY_ISERDES_RESET    ,
                SHIFTIN1    => SHIFT_TO_SLAVE1          ,
                SHIFTIN2    => SHIFT_TO_SLAVE2          ,
                Q1          => SLAVE_DATA(0)            ,
                Q2          => SLAVE_DATA(1)            ,
                Q3          => SLAVE_DATA(2)            ,
                Q4          => SLAVE_DATA(3)            ,
                Q5          => SLAVE_DATA(4)            ,
                Q6          => SLAVE_DATA(5)            ,
                SHIFTOUT1   => SHIFT_FROM_SLAVE1        ,
                SHIFTOUT2   => SHIFT_FROM_SLAVE2      
                );	   
   SLAVE_DATA(6) <= '0';                
   SLAVE_DATA(7) <= '0';                
end generate SLAVE_ISERDES_V5_GEN;				

SLAVE_ISERDES_V6_GEN : if (C_FAMILY = "virtex6") generate  
   Slave_iserdes : ISERDESE1
   generic map( 
            DATA_RATE       => DATA_RATE    ,
            DATA_WIDTH      => DATAWIDTH    ,
            INIT_Q1         => '0'          ,
            INIT_Q2         => '0'          ,
            INIT_Q3         => '0'          ,
            INIT_Q4         => '0'          ,
            INTERFACE_TYPE  => "NETWORKING" ,
            NUM_CE          => 2            ,
            SERDES_MODE     => "SLAVE"     ,
            --
            DYN_CLKDIV_INV_EN => FALSE, -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
            DYN_CLK_INV_EN    => FALSE, -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
            IOBDELAY        => "NONE",
            OFB_USED        => FALSE      ,
            SRVAL_Q1        => '0',
            SRVAL_Q2        => '0',
            SRVAL_Q3        => '0',
            SRVAL_Q4        => '0'
            )
      port map (
                BITSLIP     => ISERDES_BITSLIP          ,
                CE1         => one                      ,
                CE2         => one                      ,
                CLK         => CLK                      ,
                CLKB        => CLKb_inv                 ,
                CLKDIV      => CLKDIV                   ,
                DDLY        => zero                     , -- 1-bit input: Serial data from IDELAYE2
                OCLK        => zero                     ,
                RST         => IODELAY_ISERDES_RESET    ,
                SHIFTIN1    => SHIFT_TO_SLAVE1          ,
                SHIFTIN2    => SHIFT_TO_SLAVE2          ,
                Q1          => SLAVE_DATA(0)            ,
                Q2          => SLAVE_DATA(1)            ,
                Q3          => SLAVE_DATA(2)            ,
                Q4          => SLAVE_DATA(3)            ,
                Q5          => SLAVE_DATA(4)            ,
                Q6          => SLAVE_DATA(5)            ,
                SHIFTOUT1   => SHIFT_FROM_SLAVE1        ,
                SHIFTOUT2   => SHIFT_FROM_SLAVE2        ,
                --
                D           => '0',
                O           => open,
                OFB         => '0', -- 1-bit input: Data feedback from OSERDESE2
                -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inv pins to switch clk polarity
                DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
                DYNCLKSEL    => '0'  -- 1-bit input: Dynamic CLK/CLKB inversion
                );
   SLAVE_DATA(6) <= '0';                
   SLAVE_DATA(7) <= '0';                
end generate SLAVE_ISERDES_V6_GEN;	

SLAVE_ISERDES_K7_GEN : if (C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate  
   Slave_iserdes : ISERDESE2
   generic map( 
            DATA_RATE       => DATA_RATE    ,
            DATA_WIDTH      => DATAWIDTH    ,
            INIT_Q1         => '0'          ,
            INIT_Q2         => '0'          ,
            INIT_Q3         => '0'          ,
            INIT_Q4         => '0'          ,
            INTERFACE_TYPE  => "NETWORKING" ,
            NUM_CE          => 2            ,
            SERDES_MODE     => "SLAVE"     ,
            --
            DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
            DYN_CLK_INV_EN    => "FALSE", -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
            IOBDELAY        => "NONE",
            OFB_USED        => "FALSE"      ,
            SRVAL_Q1        => '0',
            SRVAL_Q2        => '0',
            SRVAL_Q3        => '0',
            SRVAL_Q4        => '0'
            )
      port map (
                BITSLIP     => ISERDES_BITSLIP          ,
                CE1         => one                      ,
                CE2         => one                      ,
                CLK         => CLK                      ,
                CLKB        => CLKb_inv                 ,
                CLKDIV      => CLKDIV                   ,
                DDLY        => zero                     , -- 1-bit input: Serial data from IDELAYE2
                OCLK        => zero                     ,
                RST         => IODELAY_ISERDES_RESET    ,
                SHIFTIN1    => SHIFT_TO_SLAVE1          ,
                SHIFTIN2    => SHIFT_TO_SLAVE2          ,
                Q1          => SLAVE_DATA(0)            ,
                Q2          => SLAVE_DATA(1)            ,
                Q3          => SLAVE_DATA(2)            ,
                Q4          => SLAVE_DATA(3)            ,
                Q5          => SLAVE_DATA(4)            ,
                Q6          => SLAVE_DATA(5)            ,
                Q7          => SLAVE_DATA(6)            ,
                Q8          => SLAVE_DATA(7)            ,
                SHIFTOUT1   => SHIFT_FROM_SLAVE1        ,
                SHIFTOUT2   => SHIFT_FROM_SLAVE2        ,
                --
                D           => '0',
                O           => open,
                CLKDIVP     => '0',
                OFB         => '0', -- 1-bit input: Data feedback from OSERDESE2
                OCLKB       => '0', -- 1-bit input: High speed negative edge output clock
                -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inv pins to switch clk polarity
                DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
                DYNCLKSEL    => '0'  -- 1-bit input: Dynamic CLK/CLKB inversion
                );
end generate SLAVE_ISERDES_K7_GEN;				

end generate;                

Noslave_iserdes_gen: if (DATAWIDTH <= 6) generate
    
    Normal_Output: if (INVERT_OUTPUT=FALSE) generate
        Normal_order: if (INVERSE_BITORDER=FALSE) generate                                          
            ISERDES_DATA(DATAWIDTH-1 downto 0) <= MASTER_DATA(DATAWIDTH-1 downto 0);  
        end generate;  
        
        Inverse_order: if (INVERSE_BITORDER=TRUE) generate                         
                gen_inverse_master: for i in 0 to DATAWIDTH-1 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= MASTER_DATA(i);
                end generate;                                                  
        end generate;                                 
   end generate;           
 
   Inverse_Output: if (INVERT_OUTPUT=TRUE) generate
        Normal_order: if (INVERSE_BITORDER=FALSE) generate                                          
            ISERDES_DATA(DATAWIDTH-1 downto 0) <= not MASTER_DATA(DATAWIDTH-1 downto 0);  
        end generate;  
        
        Inverse_order: if (INVERSE_BITORDER=TRUE) generate                         
                gen_inverse_master: for i in 0 to DATAWIDTH-1 generate
                    ISERDES_DATA((DATAWIDTH-1)-i) <= not MASTER_DATA(i);
                end generate;                                                  
        end generate;                                 
   end generate;  
    
    SHIFT_FROM_SLAVE1   <= '0';
    SHIFT_FROM_SLAVE2   <= '0';
                            
end generate;     

ISERDES_DATAOUT <= ISERDES_DATA;    

-- fifo
fifogen: if (USE_FIFO = TRUE) generate
    blockramgen: if(USE_BLOCKRAMFIFO = TRUE) generate
        
        FIFO18_inst : FIFO18
        generic map (
            ALMOST_FULL_OFFSET      => X"080"   , -- Sets almost full threshold
            ALMOST_EMPTY_OFFSET     => X"080"   , -- Sets the almost empty threshold
            DATA_WIDTH              => 18       , -- Sets data width to 4, 9, or 18
            DO_REG                  => 1        , -- Enable output register ( 0 or 1), Must be 1 if the EN_SYN = FALSE
            EN_SYN                  => FALSE    , -- Specified FIFO as Asynchronous (FALSE) or
                                                  -- Synchronous (TRUE)
            FIRST_WORD_FALL_THROUGH => FALSE    , -- Sets the FIFO FWFT to TRUE or FALSE
            SIM_MODE                => "SAFE"   
            ) 
                                                  -- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation
                                                  -- Design Guide" for details
        port map (
            ALMOSTEMPTY             => open                 , -- 1-bit almost empty output flag
            ALMOSTFULL              => open                 , -- 1-bit almost full output flag
            DO                      => DO                   , -- 16-bit data output
            DOP                     => open                 , -- 2-bit parity data output
            EMPTY                   => FIFO_EMPTY           , -- 1-bit empty output flag
            FULL                    => FIFO_FULL            , -- 1-bit full output flag
            RDCOUNT                 => open                 , -- 12-bit read count output
            RDERR                   => open                 , -- 1-bit read error output
            WRCOUNT                 => open                 , -- 12-bit write count output
            WRERR                   => open                 , -- 1-bit write error
            DI                      => DI                   , -- 16-bit data input
            DIP                     => zeros(1 downto 0)    , -- 2-bit parity input
            RDCLK                   => CLOCK                , -- 1-bit read clock input
            RDEN                    => FIFO_RDEN            , -- 1-bit read enable input
            RST                     => FIFO_RESET           , -- 1-bit reset input
            WRCLK                   => CLKDIV               , -- 1-bit write clock input
            WREN                    => FIFO_WREN              -- 1-bit write enable input
        );           
    -- End of FIFO18_inst instantiation

    DI(15 downto DATAWIDTH) <= (others => '0');
    DI(DATAWIDTH-1 downto 0) <= ISERDES_DATA;                                         
    FIFO_DATAOUT <= DO(DATAWIDTH-1 downto 0);
    end generate;    
    
    distramgen: if(USE_BLOCKRAMFIFO = FALSE) generate
        gen_10bit_fifo: if DATAWIDTH=10 generate
              fifo_10bit: iserdes_fifo_10_bit 
                port map(
                rst     => FIFO_RESET           , -- 1-bit reset input
                wr_clk  => CLKDIV               , -- 1-bit write clock input
                rd_clk  => CLOCK                , -- 1-bit read clock input
                din     => DI(9 downto 0)       , -- data input
                wr_en   => FIFO_WREN            , -- 1-bit write enable input
                rd_en   => FIFO_RDEN            , -- 1-bit read enable input
                dout    => FIFO_DATAOUT         , -- data output
                full    => FIFO_FULL            ,
                empty   => FIFO_EMPTY             -- 1-bit empty output flag 
                 );
         end generate;

         gen_8bit_fifo: if DATAWIDTH=8 generate
              fifo_8bit: iserdes_fifo_8_bit 
                port map(
                rst     => FIFO_RESET           , -- 1-bit reset input
                wr_clk  => CLKDIV               , -- 1-bit write clock input
                rd_clk  => CLOCK                , -- 1-bit read clock input
                din     => DI(7 downto 0)       , -- data input
                wr_en   => FIFO_WREN            , -- 1-bit write enable input
                rd_en   => FIFO_RDEN            , -- 1-bit read enable input
                dout    => FIFO_DATAOUT         , -- data output
                full    => FIFO_FULL            ,
                empty   => FIFO_EMPTY             -- 1-bit empty output flag 
                 );
         end generate;

         gen_6bit_fifo: if DATAWIDTH=6 generate
              fifo_6bit: iserdes_fifo_6_bit 
                port map(
                rst     => FIFO_RESET           , -- 1-bit reset input
                wr_clk  => CLKDIV               , -- 1-bit write clock input
                rd_clk  => CLOCK                , -- 1-bit read clock input
                din     => DI(5 downto 0)       , -- data input
                wr_en   => FIFO_WREN            , -- 1-bit write enable input
                rd_en   => FIFO_RDEN            , -- 1-bit read enable input
                dout    => FIFO_DATAOUT         , -- data output
                full    => FIFO_FULL            ,
                empty   => FIFO_EMPTY             -- 1-bit empty output flag 
                 );
         end generate;
         
      DI(15 downto DATAWIDTH) <= (others => '0');
      DI(DATAWIDTH-1 downto 0) <= ISERDES_DATA;                                         
     
    end generate;             
end generate;

nofifogen: if (USE_FIFO = FALSE) generate
    FIFO_DATAOUT <= ISERDES_DATA;
    FIFO_EMPTY   <= '0';
end generate;

end rtl;



