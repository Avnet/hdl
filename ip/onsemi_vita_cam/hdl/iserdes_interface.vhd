-- *********************************************************************
-- Copyright 2011, ON Semiconductor Corporation.
--
-- This software is owned by ON Semiconductor Corporation (ON)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of ON.
--
-- Disclaimer: ON makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. ON reserves the right to make changes without further
-- notice to the materials described herein. ON does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. ON's products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the ON Software License Agreement.
--
-- *********************************************************************
-- File           : $URL: http://whatever.euro.cypress.com/repos/ff_te/VHDL/LIB/modules/Iserdes/trunk/iserdes_interface.vhd $
-- Author         : $Author: bert.dewil $
-- Department     : CISP
-- Date           : $Date: 2011-05-03 15:12:09 +0200 (di, 03 mei 2011) $
-- Revision       : $Revision: 920 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library work;
use work.all;


-- synopsys translate_off
Library XilinxCoreLib;
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on

entity iserdes_interface is
  generic (
        SIMULATION      : integer := 0;
        NROF_CONN       : integer := 4; --16 bits
        NROF_CONTR_CONN : integer := 4;
        NROF_CLOCKCOMP  : integer := 1;
        DATAWIDTH       : integer := 10; -- can be 4, 6, 8 or 10 for DDR, can be 2, 3, 4, 5, 6, 7, or 8 for SDR.
        RETRY_MAX       : integer := 32767; --16 bits, global
        STABLE_COUNT    : integer := 16;
        TAP_COUNT_MAX   : integer := 64;
        DATA_RATE       : string  := "DDR"; -- DDR/SDR
        DIFF_TERM       : boolean := TRUE;
        USE_FIFO        : boolean := FALSE;
        USE_BLOCKRAMFIFO : boolean := TRUE;
        INVERT_OUTPUT    : boolean := FALSE;
        INVERSE_BITORDER : boolean := FALSE;
        CLKSPEED        : integer := 50;    -- APPCLK speed in MHz. Everything is generated from Appclk to be as sync as possible
        --DATAWIDTH, DATARATE, and clockspeed are used to calculate high speed clk speed.
        --SIM_DEVICE      : string  := "VIRTEX5"; --VIRTEX4/VIRTEX5, for BUFR
        C_FAMILY        : string  := "virtex6";
        NROF_DELAYCTRLS : integer := 1;
        IDELAYCLK_MULT  : integer := 4;
        IDELAYCLK_DIV   : integer := 1;
        GENIDELAYCLK    : boolean := FALSE; -- generate own idelayrefclk based on mult and div parameters or use external clk
                                   -- ext clk can come from common part and thus always be in spec regardless of clkspeed
        USE_OUTPLL      : boolean := TRUE;  --use output/multiplieng PLL instead of DCM
        USE_INPLL       : boolean := TRUE;  --use input/dividing PLL instead of DCM
        USE_HS_EXT_CLK_IN    : boolean := FALSE; -- use external clock high speed clock in
                                                 -- YES -> use as CLK source, either via BUFG or BUFIO/BUFR,
                                                 --        -> when USE_HS_REGIONAL_CLK = YES
                                                 --                use BUFIO (only IOblock can be clocked)
                                                 --         -> when USE_HS_REGIONAL_CLK = NO
                                                 --                use BUFG
                                                 --
                                                 -- NO -> when use USE_LS_EXT_CLK_IN = YES
                                                 --           not supported
                                                 --       when use USE_LS_EXT_CLK_IN = NO
                                                 --           appclk combined with DCM as CLK source
                                                 --             use BUFG as CLK source
        USE_LS_EXT_CLK_IN    : boolean := FALSE; -- use external clock low speed clock in
                                                 -- YES -> use as CLKDIV source, either via BUFG or BUFIO/BUFR,
                                                 --        -> when USE_LS_REGIONAL_CLK = YES
                                                 --               use BUFR
                                                 --        -> when USE_LS_REGIONAL_CLK = NO
                                                 --               use BUFG
                                                 --
                                                 --
                                                 -- NO ->  when USE_HS_EXT_CLK_IN = YES
                                                 --        -> when USE_HS_REGIONAL_CLK =YES and BUFR can divide
                                                 --               use BUFIO/BUFR to divide HS
                                                 --        -> when USE_HS_REGIONAL_CLK =YES and BUFR can not divide
                                                 --               use BUFIO/BUFR + DCM to divide HS
                                                 --        -> when USE_HS_EXT_CLK_IN = NO
                                                 --               use DCM (same as HS_EXT_CLK_IN) as clk source, sync with appclk
                                                 --
                                                 --
        USE_DIFF_HS_CLK_IN  : boolean := FALSE;  -- differential mode, automatically instantiates the correct buffer
        USE_DIFF_LS_CLK_IN  : boolean := FALSE;  -- differential mode, automatically instantiates the correct buffer
        USE_HS_REGIONAL_CLK  : boolean := FALSE; -- only used when USE_HS_EXT_CLK_IN = yes
        USE_LS_REGIONAL_CLK  : boolean := FALSE; -- only used when USE_LS_EXT_CLK_IN = yes
        USE_HS_EXT_CLK_OUT   : boolean := FALSE; -- use external clock high speed clock out
        USE_LS_EXT_CLK_OUT   : boolean := FALSE; -- use external clock low speed clock out
        USE_DIFF_HS_CLK_OUT  : boolean := FALSE; -- differential mode, automatically instantiates the correct buffer
        USE_DIFF_LS_CLK_OUT  : boolean := FALSE; -- differential mode, automatically instantiates the correct buffer
        USE_DATAPATH         : boolean := TRUE
  );
  port(
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;

        CLK_RDY             : out    std_logic;
        CLK_STATUS          : out    std_logic_vector((16*NROF_CLOCKCOMP)-1 downto 0);

        CLK200              : in   std_logic; -- optional 200MHz refclk

        -- to sensor (external)
        LS_OUT_CLK         : out   std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
        LS_OUT_CLKb        : out   std_logic_vector(NROF_CLOCKCOMP-1 downto 0);  -- only used in differential mode

        HS_OUT_CLK         : out   std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
        HS_OUT_CLKb        : out   std_logic_vector(NROF_CLOCKCOMP-1 downto 0);

        -- from sensor (only used when USED_EXT_CLK = YES)
        LS_IN_CLK          : in    std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
        LS_IN_CLKb         : in    std_logic_vector(NROF_CLOCKCOMP-1 downto 0);

        HS_IN_CLK          : in    std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
        HS_IN_CLKb         : in    std_logic_vector(NROF_CLOCKCOMP-1 downto 0);

        --serdes data, directly connected to bondpads
        SDATAP              : in    std_logic_vector(NROF_CONN-1 downto 0);
        SDATAN              : in    std_logic_vector(NROF_CONN-1 downto 0);

        -- status info
        EDGE_DETECT         : out   std_logic_vector(NROF_CONN-1 downto 0);
        TRAINING_DETECT     : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT       : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND    : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND   : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES        : out   std_logic_vector((16*NROF_CONN)-1 downto 0);
        TAP_SETTING         : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
        WINDOW_WIDTH        : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
        WORD_ALIGN          : out   std_logic_vector(NROF_CONN-1 downto 0);
        TIMEOUTONACK        : out   std_logic_vector(NROF_CONTR_CONN-1 downto 0);
        
        -- control
        ALIGN_START         : in    std_logic;
        ALIGN_BUSY          : out   std_logic;
        ALIGNED             : out   std_logic;

        FIFO_EN             : in    std_logic;

        AUTOALIGN           : in    std_logic;

        TRAINING            : in    std_logic_vector(DATAWIDTH-1 downto 0);
        MANUAL_TAP          : in    std_logic_vector(9 downto 0);

        EN_LS_CLK_OUT      : in   std_logic;
        EN_HS_CLK_OUT      : in   std_logic;

        -- parallel data out
        FIFO_RDEN           : in    std_logic;
        FIFO_EMPTY          : out   std_logic;
        FIFO_DATAOUT        : out   std_logic_vector((NROF_CONN*DATAWIDTH)-1 downto 0)
       );
end iserdes_interface;

architecture structure of iserdes_interface is

component iserdes_idelayctrl
  generic (
    NROF_DELAYCTRLS     : integer;
    IDELAYCLK_MULT      : integer;
    IDELAYCLK_DIV       : integer;
    GENIDELAYCLK        : boolean
    );
  port (
    CLOCK            : in std_logic;
    RESET            : in std_logic;
    CLK200           : in std_logic;
    idelay_ctrl_rdy  : out std_logic
  );
end component;

component iserdes_datadeser
  generic (
        NROF_CONN       : integer; --16 bits
        DATAWIDTH       : integer; -- can be 4, 6, 8 or 10 for DDR, can be 2, 3, 4, 5, 6, 7, or 8 for SDR.
        RETRY_MAX       : integer; --16 bits, global
        STABLE_COUNT    : integer; -- x bits,
        TAP_COUNT_MAX   : integer;
        DATA_RATE       : string  := "DDR"; -- DDR/SDR
        DIFF_TERM       : boolean := TRUE;
        USE_FIFO        : boolean := FALSE;
        USE_BLOCKRAMFIFO : boolean := TRUE;
        INVERT_OUTPUT    : boolean := FALSE;
        INVERSE_BITORDER : boolean := FALSE;
        C_FAMILY        : string  := "virtex6"
  );
  port(
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;

        --serdes clocks, from clocking module(s)
        CLK                 : in    std_logic;
        CLKb                : in    std_logic;

        CLKDIV              : in    std_logic;

        --serdes data, directly connected to bondpads
        SDATAP              : in    std_logic_vector(NROF_CONN-1 downto 0);
        SDATAN              : in    std_logic_vector(NROF_CONN-1 downto 0);

        -- status info
        EDGE_DETECT         : out   std_logic_vector(NROF_CONN-1 downto 0);
        TRAINING_DETECT     : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT       : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND    : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND   : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES        : out   std_logic_vector((16*NROF_CONN)-1 downto 0);
        TAP_SETTING         : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
        WINDOW_WIDTH        : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
        WORD_ALIGN          : out   std_logic_vector(NROF_CONN-1 downto 0); 
        TIMEOUTONACK        : out   std_logic;

        CLK_DIV_RESET       : in std_logic;
        
        -- control
        --sync to clock
        ALIGN_START         : in    std_logic;
        ALIGN_BUSY          : out   std_logic;
        ALIGNED             : out   std_logic;

        SAMPLEINFIRSTBIT    : out   std_logic_vector(NROF_CONN-1 downto 0);
        SAMPLEINLASTBIT     : out   std_logic_vector(NROF_CONN-1 downto 0);
        SAMPLEINOTHERBIT    : out   std_logic_vector(NROF_CONN-1 downto 0);

        AUTOALIGN           : in    std_logic;

        TRAINING            : in    std_logic_vector(DATAWIDTH-1 downto 0);
        MANUAL_TAP          : in    std_logic_vector(9 downto 0);
        
        --sync to clockdiv
        FIFO_WREN           : in    std_logic;
        DELAY_WREN          : in    std_logic;
        
        -- parallel data out
        FIFO_RDEN           : in    std_logic;
        FIFO_EMPTY          : out   std_logic;
        FIFO_DATAOUT        : out   std_logic_vector((NROF_CONN*DATAWIDTH)-1 downto 0)
       );

end component;

component iserdes_clocks
  generic (
        SIMULATION   : integer := 0;
        DATAWIDTH    : integer := 10;
        DATA_RATE    : string  := "DDR";
        CLKSPEED     : integer := 50;
        --SIM_DEVICE   : string  := "VIRTEX5";
        C_FAMILY     : string  := "virtex6";
        DIFF_TERM    : boolean := TRUE;
        USE_OUTPLL   : boolean := TRUE;  --use output/multiplieng PLL instead of DCM
        USE_INPLL    : boolean := TRUE;
        USE_HS_EXT_CLK_IN    : boolean := FALSE;
        USE_LS_EXT_CLK_IN    : boolean := FALSE;
        USE_DIFF_HS_CLK_IN  : boolean := FALSE;
        USE_DIFF_LS_CLK_IN  : boolean := FALSE;
        USE_HS_REGIONAL_CLK  : boolean := FALSE;
        USE_LS_REGIONAL_CLK  : boolean := FALSE;
        USE_HS_EXT_CLK_OUT   : boolean := FALSE;
        USE_LS_EXT_CLK_OUT   : boolean := FALSE; -- use external clock low speed clock out

        USE_DIFF_HS_CLK_OUT  : boolean := FALSE; -- differential mode, automatically instantiates the correct buffer
        USE_DIFF_LS_CLK_OUT  : boolean := FALSE -- differential mode, automatically instantiates the correct buffer
  );
  port (
        CLOCK              : in    std_logic;  --appclock
        RESET              : in    std_logic;  --active high reset

        CLK_RDY            : out    std_logic; --CLK status (locked)
        CLK_STATUS         : out    std_logic_vector(15 downto 0);

        -- to iserdes
        CLK                : out   std_logic;
        CLKb               : out   std_logic;
        CLKDIV             : out   std_logic;

        EN_LS_CLK_OUT      : in   std_logic;
        EN_HS_CLK_OUT      : in   std_logic;
        
        --reset for synchronizer between clk_div and App_clk
        CLK_DIV_RESET      : out std_logic;

        -- to sensor (external)
        LS_OUT_CLK         : out   std_logic;
        LS_OUT_CLKb        : out   std_logic;  -- only used in differential mode

        HS_OUT_CLK         : out   std_logic;
        HS_OUT_CLKb        : out   std_logic;

        -- from sensor (only used when USED_EXT_CLK = YES)
        LS_IN_CLK          : in    std_logic;
        LS_IN_CLKb         : in    std_logic;

        HS_IN_CLK          : in    std_logic;
        HS_IN_CLKb         : in    std_logic
       );
end component;

component iserdes_compare
  generic(
        NROF_CONN       : integer
       );
  port(
        CLOCK               : in    std_logic;
        CLKDIV              : in    std_logic;

        RESET               : in    std_logic;
        FIFO_EN             : in    std_logic;
        
        SAMPLEINFIRSTBIT    : in    std_logic_vector(NROF_CONN-1 downto 0);
        SAMPLEINLASTBIT     : in    std_logic_vector(NROF_CONN-1 downto 0);
        SAMPLEINOTHERBIT    : in    std_logic_vector(NROF_CONN-1 downto 0);
        
        SKEW_ERROR          : out   std_logic;
        
        FIFO_WREN           : out   std_logic;
        DELAY_WREN          : out   std_logic
       );
end component;

-- constants

constant nrof_conn_per_controlblock : integer :=  (NROF_CONN/NROF_CONTR_CONN);
constant nrof_clocks_per_controlblock : integer :=  (NROF_CLOCKCOMP/NROF_CONTR_CONN);
constant nrof_controlblocks_per_clock : integer :=  (NROF_CONTR_CONN/NROF_CLOCKCOMP);
constant nrof_conn_per_clock : integer :=  (NROF_CONN/NROF_CLOCKCOMP);

----signals
-- clock module signals
signal CLK_c              : std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
signal CLKb_c             : std_logic_vector(NROF_CLOCKCOMP-1 downto 0);
signal CLKDIV_c           : std_logic_vector(NROF_CLOCKCOMP-1 downto 0);

signal CLK_RDY_i          : std_logic_vector(NROF_CLOCKCOMP-1 downto 0);

signal FIFO_WREN_c        : std_logic_vector(NROF_CLOCKCOMP-1 downto 0); 
signal DELAY_WREN_c       : std_logic_vector(NROF_CLOCKCOMP-1 downto 0); 

-- data module signals
signal CLK_d              : std_logic_vector(NROF_CONTR_CONN-1 downto 0);
signal CLKb_d             : std_logic_vector(NROF_CONTR_CONN-1 downto 0);
signal CLKDIV_d           : std_logic_vector(NROF_CONTR_CONN-1 downto 0);

signal FIFO_WREN_d        : std_logic_vector(NROF_CONTR_CONN-1 downto 0); 
signal DELAY_WREN_d       : std_logic_vector(NROF_CONTR_CONN-1 downto 0); 

--
signal ALIGN_BUSY_d       : std_logic_vector(NROF_CONTR_CONN-1 downto 0);
signal ALIGNED_d          : std_logic_vector(NROF_CONTR_CONN-1 downto 0);

signal FIFO_EMPTY_d       : std_logic_vector(NROF_CONTR_CONN-1 downto 0);


signal SAMPLEINFIRSTBIT   : std_logic_vector(NROF_CONN-1 downto 0);
signal SAMPLEINLASTBIT    : std_logic_vector(NROF_CONN-1 downto 0);
signal SAMPLEINOTHERBIT   : std_logic_vector(NROF_CONN-1 downto 0);


signal CLK_DIV_RESET      :std_logic;

begin

-- mapping, depends on used hardware

-- this block might need to be moved elsewhere, or replaced by a component
generate_data_clock_assignment: for i in 0 to (NROF_CLOCKCOMP-1) generate
FIFO_WREN_d(i*nrof_controlblocks_per_clock+nrof_controlblocks_per_clock-1 downto i*nrof_controlblocks_per_clock) <= (others => FIFO_WREN_c(i));  
DELAY_WREN_d(i*nrof_controlblocks_per_clock+nrof_controlblocks_per_clock-1 downto i*nrof_controlblocks_per_clock) <= (others => DELAY_WREN_c(i)); 
CLK_d(i*nrof_controlblocks_per_clock+nrof_controlblocks_per_clock-1 downto i*nrof_controlblocks_per_clock) <= (others => CLK_c(i));
CLKb_d(i*nrof_controlblocks_per_clock+nrof_controlblocks_per_clock-1 downto i*nrof_controlblocks_per_clock) <= (others => CLKb_c(i));
CLKDIV_d(i*nrof_controlblocks_per_clock+nrof_controlblocks_per_clock-1 downto i*nrof_controlblocks_per_clock) <= (others => CLKDIV_c(i));
end generate;

process (ALIGN_BUSY_d)
   variable TMP : std_logic;
begin
   TMP := '0';
   for I in ALIGN_BUSY_d'low to ALIGN_BUSY_d'high loop
      TMP := TMP or ALIGN_BUSY_d(I);
   end loop;
   ALIGN_BUSY <= TMP;
end process;

process (ALIGNED_d)
   variable TMP : std_logic;
begin
   TMP := '0';
   for I in ALIGNED_d'low to ALIGNED_d'high loop
      TMP := TMP and ALIGNED_d(I);
   end loop;
   ALIGNED <= TMP;
end process;

process (FIFO_EMPTY_d)
   variable TMP : std_logic;
begin
   TMP := '0';
   for I in FIFO_EMPTY_d'low to FIFO_EMPTY_d'high loop
      TMP := TMP or FIFO_EMPTY_d(I);
   end loop;
   FIFO_EMPTY <= TMP;
end process;

-- end mapping

process(CLOCK)
variable tmp : std_logic := '0';
begin
if (CLOCK = '1' and CLOCK'event) then
    tmp := '1';
    for i in 0 to NROF_CLOCKCOMP-1 loop
    tmp := CLK_RDY_i(i) and tmp;
    end loop;
    CLK_RDY <= tmp;
end if;
end process;

generate_idelay: if (USE_DATAPATH = TRUE) generate
-- delay controllers
serdesidelayrefclk: iserdes_idelayctrl
  generic map(
    NROF_DELAYCTRLS     => NROF_DELAYCTRLS  ,
    IDELAYCLK_MULT      => IDELAYCLK_MULT   ,
    IDELAYCLK_DIV       => IDELAYCLK_DIV     ,
    GENIDELAYCLK        => GENIDELAYCLK
    )
  port map(
    CLOCK               => CLOCK            ,
    RESET               => RESET            ,
    CLK200              => CLK200           ,
    idelay_ctrl_rdy     => open
  );

end generate;

serdesclockgen : for i in 0 to (NROF_CLOCKCOMP-1) generate
co: iserdes_compare
  generic map (
        NROF_CONN           => NROF_CONN
       )
  port map (
        CLOCK               => CLOCK              ,
        CLKDIV              => CLKDIV_c(i)        ,
        
        RESET               => RESET              ,
        FIFO_EN             => FIFO_EN            ,
        
        SAMPLEINFIRSTBIT    => SAMPLEINFIRSTBIT(i*nrof_conn_per_clock + nrof_conn_per_clock-1 downto i*nrof_conn_per_clock) ,
        SAMPLEINLASTBIT     => SAMPLEINLASTBIT(i*nrof_conn_per_clock + nrof_conn_per_clock-1 downto i*nrof_conn_per_clock)  ,
        SAMPLEINOTHERBIT    => SAMPLEINOTHERBIT(i*nrof_conn_per_clock + nrof_conn_per_clock-1 downto i*nrof_conn_per_clock) ,
        
        SKEW_ERROR          => open               ,
        
        FIFO_WREN           => FIFO_WREN_c(i)     ,
        DELAY_WREN          => DELAY_WREN_c(i)
       );

ic: iserdes_clocks
  generic map(
        SIMULATION              => SIMULATION           ,
        DATAWIDTH               => DATAWIDTH            ,
        DATA_RATE               => DATA_RATE            ,
        CLKSPEED                => CLKSPEED             ,
        --SIM_DEVICE              => SIM_DEVICE           ,
        C_FAMILY                => C_FAMILY             ,
        DIFF_TERM               => DIFF_TERM            ,
        USE_OUTPLL              => USE_OUTPLL           ,
        USE_INPLL               => USE_INPLL            ,
        USE_HS_EXT_CLK_IN       => USE_HS_EXT_CLK_IN    ,
        USE_LS_EXT_CLK_IN       => USE_LS_EXT_CLK_IN    ,
        USE_DIFF_HS_CLK_IN      => USE_DIFF_HS_CLK_IN   ,
        USE_DIFF_LS_CLK_IN      => USE_DIFF_LS_CLK_IN   ,
        USE_HS_REGIONAL_CLK     => USE_HS_REGIONAL_CLK  ,
        USE_LS_REGIONAL_CLK     => USE_LS_REGIONAL_CLK  ,
        USE_HS_EXT_CLK_OUT      => USE_HS_EXT_CLK_OUT   ,
        USE_LS_EXT_CLK_OUT      => USE_LS_EXT_CLK_OUT   ,

        USE_DIFF_HS_CLK_OUT     => USE_DIFF_HS_CLK_OUT  ,
        USE_DIFF_LS_CLK_OUT     => USE_DIFF_LS_CLK_OUT
  )
  port map(
        CLOCK              => CLOCK         ,
        RESET              => RESET         ,

        CLK_RDY            => CLK_RDY_i(i)  ,
        CLK_STATUS         => CLK_STATUS((i*16)+15 downto (i*16)) ,

        -- to iserdes
        CLK                => CLK_c(i)      ,
        CLKb               => CLKb_c(i)     ,
        CLKDIV             => CLKDIV_c(i)   ,

        EN_LS_CLK_OUT      => EN_LS_CLK_OUT ,
        EN_HS_CLK_OUT      => EN_HS_CLK_OUT ,
        
        
        --reset for synchronizer between clk_div and App_clk
        CLK_DIV_RESET      => CLK_DIV_RESET,

        -- to sensor (external)
        LS_OUT_CLK         => LS_OUT_CLK(i) ,
        LS_OUT_CLKb        => LS_OUT_CLKb(i),

        HS_OUT_CLK         => HS_OUT_CLK(i) ,
        HS_OUT_CLKb        => HS_OUT_CLKb(i),

        -- from sensor (only used when USED_EXT_CLK = YES)
        LS_IN_CLK          => LS_IN_CLK(i)  ,
        LS_IN_CLKb         => LS_IN_CLKb(i) ,

        HS_IN_CLK          => HS_IN_CLK(i)  ,
        HS_IN_CLKb         => HS_IN_CLKb(i)
       );

end generate;


generate_datagen: if (USE_DATAPATH = TRUE) generate

 datagen: for j in 0 to (NROF_CONTR_CONN-1) generate

   db: iserdes_datadeser
      generic map (
            NROF_CONN        => nrof_conn_per_controlblock        ,
            DATAWIDTH        => DATAWIDTH       ,
            RETRY_MAX        => RETRY_MAX       ,
            STABLE_COUNT     => STABLE_COUNT    ,
            TAP_COUNT_MAX    => TAP_COUNT_MAX   ,
            DATA_RATE        => DATA_RATE       ,
            DIFF_TERM        => DIFF_TERM       ,
            USE_FIFO         => USE_FIFO        ,
            USE_BLOCKRAMFIFO => USE_BLOCKRAMFIFO,
            INVERT_OUTPUT    => INVERT_OUTPUT   ,
            INVERSE_BITORDER => INVERSE_BITORDER,
            C_FAMILY         => C_FAMILY
      )
      port map(
            CLOCK               => CLOCK        ,
            RESET               => RESET        ,

            --serdes clocks, from clocking module(s)
            CLK                 => CLK_d(j)     ,
            CLKb                => CLKb_d(j)    ,

            CLKDIV              => CLKDIV_d(j)  ,

            --serdes data, directly connected to bondpads
            SDATAP              => SDATAP(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock) ,
            SDATAN              => SDATAN(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock) ,

            -- status info
            EDGE_DETECT         => EDGE_DETECT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock) ,
            TRAINING_DETECT     => TRAINING_DETECT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock) ,
            STABLE_DETECT       => STABLE_DETECT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock) ,
            FIRST_EDGE_FOUND    => FIRST_EDGE_FOUND(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock) ,
            SECOND_EDGE_FOUND   => SECOND_EDGE_FOUND(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock) ,
            NROF_RETRIES        => NROF_RETRIES(((j+1)*nrof_conn_per_controlblock*16)-1 downto j*nrof_conn_per_controlblock*16) ,
            TAP_SETTING         => TAP_SETTING(((j+1)*nrof_conn_per_controlblock*10)-1 downto j*nrof_conn_per_controlblock*10) ,
            WINDOW_WIDTH        => WINDOW_WIDTH(((j+1)*nrof_conn_per_controlblock*10)-1 downto j*nrof_conn_per_controlblock*10) ,
            WORD_ALIGN          => WORD_ALIGN(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock) ,
            TIMEOUTONACK        => TIMEOUTONACK(j) ,
            
            
            --reset for synchronizer between clk_div and App_clk
            CLK_DIV_RESET       => CLK_DIV_RESET,

            -- control
            ALIGN_START         => ALIGN_START      ,
            ALIGN_BUSY          => ALIGN_BUSY_d(j)  ,
            ALIGNED             => ALIGNED_d(j)     ,

            SAMPLEINFIRSTBIT    => SAMPLEINFIRSTBIT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)   ,
            SAMPLEINLASTBIT     => SAMPLEINLASTBIT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)    ,
            SAMPLEINOTHERBIT    => SAMPLEINOTHERBIT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)   ,

            AUTOALIGN           => AUTOALIGN        ,

            TRAINING            => TRAINING         ,
            MANUAL_TAP          => MANUAL_TAP       ,
            
             --sync to clockdiv
            FIFO_WREN           => FIFO_WREN_d(j)   ,
            DELAY_WREN          => DELAY_WREN_d(j)  ,
            
            -- parallel data out
            FIFO_RDEN           => FIFO_RDEN        ,
            FIFO_EMPTY          => FIFO_EMPTY_d(j)  ,
            FIFO_DATAOUT        => FIFO_DATAOUT(((j+1)*nrof_conn_per_controlblock*DATAWIDTH)-1 downto j*nrof_conn_per_controlblock*DATAWIDTH)
           );

    end generate;
	
end generate;

generate_nodatagen: if (USE_DATAPATH = FALSE) generate
    datagen: for j in 0 to (NROF_CONTR_CONN-1) generate

        EDGE_DETECT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)        <= (others => '0');
        TRAINING_DETECT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)    <= (others => '0');
        STABLE_DETECT(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)      <= (others => '0');
        FIRST_EDGE_FOUND(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)   <= (others => '0');
        SECOND_EDGE_FOUND(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)  <= (others => '0');
        NROF_RETRIES(((j+1)*nrof_conn_per_controlblock*16)-1 downto j*nrof_conn_per_controlblock*16) <= (others => '0');
        TAP_SETTING(((j+1)*nrof_conn_per_controlblock*10)-1 downto j*nrof_conn_per_controlblock*10)  <= (others => '0');
        WINDOW_WIDTH(((j+1)*nrof_conn_per_controlblock*10)-1 downto j*nrof_conn_per_controlblock*10) <= (others => '0');
        WORD_ALIGN(((j+1)*nrof_conn_per_controlblock)-1 downto j*nrof_conn_per_controlblock)         <= (others => '0');


        ALIGN_BUSY_d(j)     <= '0';
        ALIGNED_d(j)        <= '1';

        FIFO_EMPTY_d(j)     <= '1';
        FIFO_DATAOUT(((j+1)*nrof_conn_per_controlblock*DATAWIDTH)-1 downto j*nrof_conn_per_controlblock*DATAWIDTH) <= (others => '0');

    end generate;
end generate;

end  structure;