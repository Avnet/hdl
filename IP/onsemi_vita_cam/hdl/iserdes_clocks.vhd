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
-- Author         : $Author: gert.rijckbosch $ @ cypress.com
-- Department     : MPD_BE
-- Date           : $Date: 2011-05-13 10:06:42 +0200 (vr, 13 mei 2011) $
-- Revision       : $Revision: 943 $
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
entity iserdes_clocks is
  generic (
        SIMULATION   : integer := 0;
        DATAWIDTH    : integer := 10;    -- can be 4, 6, 8 or 10 for DDR, can be 2, 3, 4, 5, 6, 7, or 8 for SDR.
        DATA_RATE    : string  := "DDR"; -- DDR/SDR
        CLKSPEED     : integer := 50;    -- APPCLK speed in MHz. Everything is generated from Appclk to be as sync as possible
        --DATAWIDTH, DATARATE, and clockspeed are used to calculate high speed clk speed.
        --SIM_DEVICE   : string  := "VIRTEX5"; --VIRTEX4/VIRTEX5, for BUFR
        C_FAMILY     : string  := "virtex5";
        DIFF_TERM    : boolean := TRUE;
        USE_INPLL    : boolean := TRUE;
        USE_OUTPLL   : boolean := TRUE;  --use output/multiplieng PLL instead of DCM

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
        USE_DIFF_LS_CLK_OUT  : boolean := FALSE -- differential mode, automatically instantiates the correct buffer
  );
  port (
        CLOCK              : in    std_logic;  --appclock
        RESET              : in    std_logic;  --active high reset

        CLK_RDY            : out    std_logic; --CLK status (locked)
        CLK_STATUS         : out    std_logic_vector(15 downto 0); -- extended status
                                                                   -- 8 LSBs: transmit clk (if any)
                                                                   -- 8 MSBs: receive clk (if any)
        EN_LS_CLK_OUT      : in   std_logic;
        EN_HS_CLK_OUT      : in   std_logic;


        --reset for synchronizer between clk_div and App_clk
        CLK_DIV_RESET      : out std_logic;


        -- to iserdes
        CLK                : out   std_logic;
        CLKb               : out   std_logic;
        CLKDIV             : out   std_logic;

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

end iserdes_clocks;

architecture rtl of iserdes_clocks is

-- functions
function calcoutplldivider(
                                DATAWIDTH    : integer;
                                DATA_RATE    : string;
                                CLKSPEED     : integer
                                
                            )
                            return integer is
variable output : integer := 1;
variable a : integer := 1;
begin
    a := 1000 / CLKSPEED;
    
    if (DATA_RATE = "SDR") then
        output := a / DATAWIDTH;
    else
        output := a / (DATAWIDTH/2);
    end if;
    

    return output;

end function;


function calcoutpllmultiplier(
                                DATAWIDTH    : integer;
                                DATA_RATE    : string;
                                CLKSPEED     : integer
                                
                            )
                            return integer is
variable output : integer := 1;
begin
    output := 1000 / CLKSPEED;
    
    
    if (DATA_RATE = "SDR") then
        output := output / DATAWIDTH;
    else
        output := output / (DATAWIDTH/2);
    end if;
   
     if (DATA_RATE = "SDR") then
        output := output * DATAWIDTH;
    else
        output := output * (DATAWIDTH/2);
    end if;
   
   

    return output;

end function;


function calcclockmultiplier(
                                DATAWIDTH    : integer;
                                DATA_RATE    : string;
                                CLKSPEED     : integer
                                )
                                return integer is
variable output : integer := 0;

begin
    if (DATA_RATE = "SDR") then
        output := DATAWIDTH;
    else
        output := DATAWIDTH/2;
    end if;

    return output;

end function;

function checkBUFRdividable(    clockmultiplier : integer
                                )
                                return boolean is
variable output : boolean := FALSE;

begin
    if (    clockmultiplier = 2 or
            clockmultiplier = 3 or
            clockmultiplier = 4 or
            clockmultiplier = 5 or
            clockmultiplier = 6 or
            clockmultiplier = 7 or
            clockmultiplier = 8 ) then
         output := TRUE;
     else
         output := FALSE;
     end if;

    return output;
end function;

function calcperiod(
                                CLKSPEED     : integer;
                                MULTIPLIER   : integer
                                )
                                return real is
variable output : real := 0.0;

begin

    output := 1000.0/real(CLKSPEED*MULTIPLIER);

    return output;

end function;

function setlocktime(           USECLKFX     : boolean;
                                USEPLL       : boolean;
                                SIMULATION   : integer;
                                CLKSPEED     : integer
                                )
                                return std_logic_vector is
variable output : std_logic_vector(23 downto 0) := X"000000";

begin

    if (SIMULATION > 0) then
        output :=  X"000080";
    else 
        if (USEPLL = TRUE) then --PLL lock time is always 100us
            output :=  std_logic_vector(to_unsigned((CLKSPEED*100),24));
        elsif (USECLKFX = TRUE) then --DFS locktime is always 10ms
            output :=  std_logic_vector(to_unsigned((CLKSPEED*10000),24));
        else --locktime is worst case for 30MHz; 5000us resulting in 150000 clocks
            output :=  std_logic_vector(to_unsigned(150000,24));
        end if;
    end if;

    return output;

end function;

function calcinpllmultiplier(
                            CLKSPEED     : integer
                            )
                            return integer is
variable output : integer := 1;
begin
    -- PLL frequency needs to be within 400MHz and 1000MHz

    if (CLKSPEED > 500) then
        output := 1;
    elsif (CLKSPEED > 250) then
        output := 2;
    elsif (CLKSPEED > 125) then
        output := 4;
    else
        output := 8;
    end if;

    return output;

end function;

--constants
constant clockmultiplier : integer := calcclockmultiplier(DATAWIDTH, DATA_RATE, CLKSPEED);
constant BUFR_dividable  : boolean := checkBUFRdividable(clockmultiplier);
constant inpllmultiplier : integer := calcinpllmultiplier(CLKSPEED*clockmultiplier);   
constant outpllmultiplier: integer := calcoutpllmultiplier(DATAWIDTH ,DATA_RATE,CLKSPEED);
constant outplldivider   : integer := calcoutplldivider(DATAWIDTH ,DATA_RATE,CLKSPEED);



constant zero            : std_logic := '0';
constant one             : std_logic := '1';
constant zeros           : std_logic_vector(31 downto 0) := X"00000000";
constant ones            : std_logic_vector(31 downto 0) := X"FFFFFFFF";
constant LockTimeMULT    : std_logic_vector(23 downto 0) := setlocktime(TRUE, USE_OUTPLL, SIMULATION, CLKSPEED);
constant LockTimeDIV     : std_logic_vector(23 downto 0) := setlocktime(FALSE, USE_INPLL, SIMULATION, CLKSPEED);
constant ResetTime        : std_logic_vector(23 downto 0) := X"000100";
--signals
type   lockedmonitorstatetp is (
                                    Idle,
                                    AssertReset1,
                                    WaitLocked1,
                                    CheckLocked1,
                                    AssertReset2,
                                    WaitLocked2,
                                    CheckLocked2,
                                    AssertReset3,
                                    WaitLocked3,
                                    CheckLocked3

                                );

signal lockedmonitorstate : lockedmonitorstatetp;

signal Cntr              : std_logic_vector(23 downto 0);

signal dcm_mult_gen      : std_logic := '0';
signal dcm_div_gen       : std_logic := '0';

signal lsoutclk          : std_logic;
signal lsoddroutclk      : std_logic;

signal hsinclk           : std_logic;
signal lsinclk           : std_logic;

signal lsdcmmultclk      : std_logic;
signal hsdcmmultclk      : std_logic;
signal hsoddroutclk      : std_logic;

--signal lsdcmdivclk       : std_logic;
--signal hsdcmdivclk       : std_logic;

signal clk_tmp           : std_logic;

signal MULT_CLK0         : std_logic;
signal MULT_CLK180       : std_logic;
signal MULT_CLK270       : std_logic;
signal MULT_CLK2X        : std_logic;
signal MULT_CLK2X180     : std_logic;
signal MULT_CLK90        : std_logic;
signal MULT_CLKDV        : std_logic;
signal MULT_CLKFX        : std_logic;
signal MULT_CLKFX180     : std_logic;
signal MULT_LOCKED       : std_logic;
signal MULT_CLKFB        : std_logic;
signal MULT_CLKIN        : std_logic;
signal MULT_RST          : std_logic;
signal MULT_DO           : std_logic_vector(15 downto 0);

signal DIV_CLK0          : std_logic;
signal DIV_CLK180        : std_logic;
signal DIV_CLK270        : std_logic;
signal DIV_CLK2X         : std_logic;
signal DIV_CLK2X180      : std_logic;
signal DIV_CLK90         : std_logic;
signal DIV_CLKDV         : std_logic;
signal DIV_CLKFX         : std_logic;
signal DIV_CLKFX180      : std_logic;
signal DIV_LOCKED        : std_logic;
signal DIV_CLKFB         : std_logic;
signal DIV_CLKIN         : std_logic;
signal DIV_RST           : std_logic;
signal DIV_DO            : std_logic_vector(15 downto 0);
--only for PLL
signal DIV_PLLFBI        : std_logic;
signal DIV_PLLFBO        : std_logic;

signal LOCKED            : std_logic;

signal dividable_s   : boolean := BUFR_dividable;
--signal clk_div
signal CLK_LOW           : std_logic;

-- lock signals AND'ed with DRP DO(1)
signal multiplier_lock   : std_logic;
signal divider_lock      : std_logic;

signal divider_lock_r    : std_logic;
signal divider_lock_r2   : std_logic;

-- output of reset sequencer
signal multiplier_status : std_logic;
signal divider_status    : std_logic;

attribute syn_preserve : boolean;
attribute equivalent_register_removal : string;
attribute shreg_extract : string;

attribute equivalent_register_removal of divider_lock_r     : signal is "no";
attribute syn_preserve                of divider_lock_r     : signal is true;
attribute shreg_extract               of divider_lock_r     : signal is "no";

attribute equivalent_register_removal of divider_lock_r2     : signal is "no";
attribute syn_preserve                of divider_lock_r2     : signal is true;
attribute shreg_extract               of divider_lock_r2     : signal is "no";

begin

-- DO bit assignment (DCM only)
-- DO[0]: Phase shift overflow
-- DO[1]: Clkin stopped
-- DO[2]: Clkfx stopped
-- DO[3]: Clkfb stopped

CLK_STATUS(7)           <= '0';
CLK_STATUS(6)           <= multiplier_lock;
CLK_STATUS(5)           <= MULT_LOCKED;
CLK_STATUS(4 downto 1)  <= MULT_DO(3 downto 0);
CLK_STATUS(0)           <= multiplier_status;

CLK_STATUS(15)          <= '0';
CLK_STATUS(14)          <= divider_lock;
CLK_STATUS(13)          <= DIV_LOCKED;
CLK_STATUS(12 downto 9) <= DIV_DO(3 downto 0);
CLK_STATUS(8)           <= divider_status;

-- in 'normal' cases only one clock entity will be needed per project

-- DCM is needed:   1. when a high speed clock out is required, then HS clock is generated internally,
--                  2. when no high speed clock in is available and it needs to be generated internally
--                  3. when a high speed clock in needs to be divided


-- or when a only a low speed clock in is available
-- in the latter case a clock reconstruction algorithm is required that is applied on the data, which is not supported yet

gen_oserdes_multiplier_DCM: if (USE_HS_EXT_CLK_OUT = TRUE or USE_HS_EXT_CLK_IN = FALSE) generate

  gen_oserdes_multiplier_v5 : if (C_FAMILY = "virtex5" ) generate
  
     gen_dcm: if (USE_OUTPLL = FALSE) generate

        DCM_ADV_inst : DCM_ADV
            generic map (
                CLKDV_DIVIDE            => 2.0, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
                CLKFX_DIVIDE            => 1, -- Can be any integer from 1 to 32
                CLKFX_MULTIPLY          => clockmultiplier, -- Can be any integer from 2 to 32
                CLKIN_DIVIDE_BY_2       => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
                CLKIN_PERIOD            => calcperiod(CLKSPEED,1), -- Specify period of input clock in ns from 1.25 to 1000.00
                CLKOUT_PHASE_SHIFT      => "NONE", -- Specify phase shift mode of NONE, FIXED,
                -- VARIABLE_POSITIVE, VARIABLE_CENTER or DIRECT
                CLK_FEEDBACK            => "1X", -- Specify clock feedback of NONE or 1X
                DCM_AUTOCALIBRATION     => TRUE, -- DCM calibration circuitry TRUE/FALSE
                DCM_PERFORMANCE_MODE    => "MAX_SPEED", -- Can be MAX_SPEED or MAX_RANGE
                DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS", -- SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                -- an integer from 0 to 15
                DFS_FREQUENCY_MODE      => "HIGH", -- HIGH or LOW frequency mode for frequency synthesis
                DLL_FREQUENCY_MODE      => "LOW",  -- LOW, HIGH, or HIGH_SER frequency mode for DLL
                DUTY_CYCLE_CORRECTION   => TRUE, -- Duty cycle correction, TRUE or FALSE
                FACTORY_JF              => X"F0F0", -- FACTORY JF Values Suggested to be set to X"F0F0"
                PHASE_SHIFT             => 0, -- Amount of fixed phase shift from -255 to 1023
                --SIM_DEVICE              => "VIRTEX5", -- Set target device, "VIRTEX4" or "VIRTEX5"
                SIM_DEVICE              => C_FAMILY,
                STARTUP_WAIT            => FALSE -- Delay configuration DONE until DCM LOCK, TRUE/FALSE
                )
            port  map (
                CLK0            => MULT_CLK0,           -- 0 degree DCM CLK output
                CLK180          => MULT_CLK180,         -- 180 degree DCM CLK output
                CLK270          => MULT_CLK270,         -- 270 degree DCM CLK output
                CLK2X           => MULT_CLK2X,          -- 2X DCM CLK output
                CLK2X180        => MULT_CLK2X180,       -- 2X, 180 degree DCM CLK out
                CLK90           => MULT_CLK90,          -- 90 degree DCM CLK output
                CLKDV           => MULT_CLKDV,          -- Divided DCM CLK out (CLKDV_DIVIDE)
                CLKFX           => MULT_CLKFX,          -- DCM CLK synthesis out (M/D)
                CLKFX180        => MULT_CLKFX180,       -- 180 degree CLK synthesis out
                DO              => MULT_DO,             -- 16-bit data output for Dynamic Reconfiguration Port (DRP)
                DRDY            => open,                -- Ready output signal from the DRP
                LOCKED          => MULT_LOCKED,         -- DCM LOCK status output
                PSDONE          => open,                -- Dynamic phase adjust done output
                CLKFB           => MULT_CLKFB,          -- DCM clock feedback
                CLKIN           => MULT_CLKIN,          -- Clock input (from IBUFG, BUFG or DCM)
                DADDR           => zeros(6 downto 0),   -- 7-bit address for the DRP
                DCLK            => CLOCK,               -- Clock for the DRP
                DEN             => zero,                -- Enable input for the DRP
                DI              => zeros(15 downto 0),  -- 16-bit data input for the DRP
                DWE             => zero,                -- Active high allows for writing configuration memory
                PSCLK           => zero,                -- Dynamic phase adjust clock input
                PSEN            => zero,                -- Dynamic phase adjust enable input
                PSINCDEC        => zero,                -- Dynamic phase adjust increment/decrement
                RST             => MULT_RST             -- DCM asynchronous reset input
            );

         -- lock status generation
         -- required because of funny condition where DCM lock does not deassert when input clock operates outside allowed range

         multiplier_lock <= MULT_LOCKED and not MULT_DO(1);

     end generate; -- gen_dcm: if (USE_OUTPLL = FALSE) generate

     gen_pll: if (USE_OUTPLL = TRUE) generate

         PLL_ADV_INST : PLL_ADV
         generic map( BANDWIDTH          => "OPTIMIZED",
                     CLKIN1_PERIOD      => calcperiod(CLKSPEED,1),
                     CLKIN2_PERIOD      => 10.000,
                     CLKOUT0_DIVIDE     => outplldivider,
                     CLKOUT0_PHASE      => 0.000,
                     CLKOUT0_DUTY_CYCLE => 0.500,
                     COMPENSATION       => "SYSTEM_SYNCHRONOUS",
                     DIVCLK_DIVIDE      => 1,
                     CLKFBOUT_MULT      => outpllmultiplier,
                     CLKFBOUT_PHASE     => 0.0,
                     REF_JITTER         => 0.005000
         )
         port map (
                     CLKFBIN            => MULT_CLKFB,
                     CLKINSEL           => one,
                     CLKIN1             => MULT_CLKIN,
                     CLKIN2             => zero,
                     DADDR(4 downto 0)  => zeros(4 downto 0),
                     DCLK               => CLOCK,
                     DEN                => zero,
                     DI(15 downto 0)    => zeros(15 downto 0),
                     DWE                => zero,
                     REL                => zero,
                     RST                => MULT_RST,
                     CLKFBDCM           => open,
                     CLKFBOUT           => MULT_CLK0,       -- naming not ideal, matches DCM naming
                     CLKOUTDCM0         => open,
                     CLKOUTDCM1         => open,
                     CLKOUTDCM2         => open,
                     CLKOUTDCM3         => open,
                     CLKOUTDCM4         => open,
                     CLKOUTDCM5         => open,
                     CLKOUT0            => MULT_CLKFX,      -- naming not ideal, matches DCM naming
                     CLKOUT1            => open,
                     CLKOUT2            => open,
                     CLKOUT3            => open,
                     CLKOUT4            => open,
                     CLKOUT5            => open,
                     DO                 => MULT_DO,
                     DRDY               => open,
                     LOCKED             => MULT_LOCKED
         );

         --unused signals
         MULT_CLK180 <= '0';
         MULT_CLK270 <= '0';
         MULT_CLK2X <= '0';
         MULT_CLK2X180 <= '0';
         MULT_CLK90 <= '0';
         MULT_CLKDV <= '0';
         MULT_CLKFX180 <= '0';

         multiplier_lock <= MULT_LOCKED;

     end generate; -- gen_pll: if (USE_OUTPLL = TRUE) generate

  end generate; --gen_oserdes_multiplier_v5 : if (C_FAMILY = "virtex5" ) generate

  gen_oserdes_multiplier_v6 : if (C_FAMILY = "virtex6" or C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate

         mmcm_adv_inst : MMCM_ADV
           generic map
            (BANDWIDTH            => "OPTIMIZED",
             CLKOUT4_CASCADE      => FALSE,
             CLOCK_HOLD           => FALSE,
             COMPENSATION         => "ZHOLD",
             STARTUP_WAIT         => FALSE,
             DIVCLK_DIVIDE        => 1,
             CLKFBOUT_MULT_F      => 10.000,
             CLKFBOUT_PHASE       => 0.000,
             CLKFBOUT_USE_FINE_PS => FALSE,
             CLKOUT0_DIVIDE_F     => 1.000,
             CLKOUT0_PHASE        => 0.000,
             CLKOUT0_DUTY_CYCLE   => 0.500,
             CLKOUT0_USE_FINE_PS  => FALSE,
             CLKIN1_PERIOD        => calcperiod(CLKSPEED,1),
             REF_JITTER1          => 0.005000)
           port map
             -- Output clocks
            (CLKFBOUT            => MULT_CLK0,       -- naming not ideal, matches DCM naming
             CLKFBOUTB           => open,
             CLKOUT0             => MULT_CLKFX,      -- naming not ideal, matches DCM naming
             CLKOUT0B            => open,
             CLKOUT1             => open,
             CLKOUT1B            => open,
             CLKOUT2             => open,
             CLKOUT2B            => open,
             CLKOUT3             => open,
             CLKOUT3B            => open,
             CLKOUT4             => open,
             CLKOUT5             => open,
             CLKOUT6             => open,
             -- Input clock control
             CLKFBIN             => MULT_CLKFB,
             CLKIN1              => MULT_CLKIN,
             CLKIN2              => '0',
             -- Tied to always select the primary input clock
             CLKINSEL            => '1',
             -- Ports for dynamic reconfiguration
             DADDR               => (others => '0'),
             DCLK                => '0',
             DEN                 => '0',
             DI                  => (others => '0'),
             DO                  => open,
             DRDY                => open,
             DWE                 => '0',
             -- Ports for dynamic phase shift
             PSCLK               => '0',
             PSEN                => '0',
             PSINCDEC            => '0',
             PSDONE              => open,
             -- Other control and status signals
             LOCKED              => MULT_LOCKED,
             CLKINSTOPPED        => open,
             CLKFBSTOPPED        => open,
             PWRDWN              => '0',
             RST                 => MULT_RST);

         --unused signals
         MULT_CLK180 <= '0';
         MULT_CLK270 <= '0';
         MULT_CLK2X <= '0';
         MULT_CLK2X180 <= '0';
         MULT_CLK90 <= '0';
         MULT_CLKDV <= '0';
         MULT_CLKFX180 <= '0';

         multiplier_lock <= MULT_LOCKED;
  
  end generate; --gen_oserdes_multiplier_v6 : if (C_FAMILY = "virtex6" or C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate

--  necessary BUFG instansiations
mult_feedback_BUFG_inst : BUFG
port map (
O => MULT_CLKFB, -- Clock buffer output
I => MULT_CLK0 -- Clock buffer input
);

--LSoutput_BUFG_inst : BUFG
--port map (
--O => lsdcmmultclk, -- Clock buffer output
--I => MULT_CLK0 -- Clock buffer input
--);
--
--HSoutput_BUFG_inst : BUFG
--port map (
--O => hsdcmmultclk, -- Clock buffer output
--I => MULT_CLKFX -- Clock buffer input
--);
--
--lsoutclk   <= lsdcmmultclk;
--MULT_CLKIN <= CLOCK;
--
--end generate;
LSoutput_BUFGMUX_inst : BUFGMUX_CTRL
port map (
O  => lsdcmmultclk, -- Clock buffer output
I0 => MULT_CLK0, -- Clock buffer input 0
I1 => CLK_LOW,
S  => EN_LS_CLK_OUT
);

HSoutput_BUFGMUX_inst : BUFGMUX_CTRL
port map (
O => hsdcmmultclk, -- Clock buffer output
I0 => MULT_CLKFX, -- Clock buffer input
I1 => CLK_LOW,
S  => EN_HS_CLK_OUT
);

lsoutclk   <= lsdcmmultclk;
MULT_CLKIN <= CLOCK;
CLK_LOW    <= '0';

end generate; -- gen_oserdes_multiplier_DCM


gen_no_iserdes_multiplier_DCM: if (USE_HS_EXT_CLK_OUT = FALSE) generate

LSoutput_BUFGMUX_inst : BUFGMUX_CTRL
port map (
O  => lsoutclk, -- Clock buffer output
I0 => CLOCK, -- Clock buffer input 0
I1 => CLK_LOW,
S  => EN_LS_CLK_OUT
);



 --   lsoutclk <= CLOCK;
    CLK_LOW    <= '0';
    lsdcmmultclk <= '0';
    hsdcmmultclk <= '0';
    multiplier_lock <= '1';
    MULT_LOCKED  <= '1';
    MULT_DO      <= (others => '0');

end generate; -- gen_no_iserdes_multiplier_DCM


gen_iserdes_divider: if ((USE_HS_EXT_CLK_IN = TRUE and USE_HS_REGIONAL_CLK = FALSE) or  ( BUFR_dividable = FALSE and USE_HS_EXT_CLK_IN = TRUE and USE_HS_REGIONAL_CLK = TRUE)) generate

  gen_iserdes_divider_v5 : if (C_FAMILY = "virtex5" ) generate
  
    gen_pll: if (USE_INPLL = TRUE) generate
    
         PLL_ADV_INST : PLL_ADV
            generic map( BANDWIDTH          => "OPTIMIZED",
                         CLKIN1_PERIOD      => calcperiod(CLKSPEED,clockmultiplier),
                         CLKIN2_PERIOD      => 10.000,
                         CLKOUT0_DIVIDE     => clockmultiplier*inpllmultiplier,
                         CLKOUT0_PHASE      => 0.000,
                         CLKOUT0_DUTY_CYCLE => 0.500,
                         CLKOUT1_DIVIDE     => inpllmultiplier,
                         CLKOUT1_PHASE      => 0.000,
                         CLKOUT1_DUTY_CYCLE => 0.500,
                         COMPENSATION       => "SOURCE_SYNCHRONOUS",
                         DIVCLK_DIVIDE      => 1,
                         CLKFBOUT_MULT      => inpllmultiplier,               --this could be wrong for other implementations
                         CLKFBOUT_PHASE     => 0.0,
                         REF_JITTER         => 0.005000
            )
            port map (
                         CLKFBIN            => DIV_PLLFBO,
                         CLKINSEL           => one,
                         CLKIN1             => DIV_CLKIN,
                         CLKIN2             => zero,
                         DADDR(4 downto 0)  => zeros(4 downto 0),
                         DCLK               => CLOCK,
                         DEN                => zero,
                         DI(15 downto 0)    => zeros(15 downto 0),
                         DWE                => zero,
                         REL                => zero,
                         RST                => DIV_RST,
                         CLKFBDCM           => open,
                         CLKFBOUT           => DIV_PLLFBI,       -- naming not ideal, matches DCM naming
                         CLKOUTDCM0         => open,
                         CLKOUTDCM1         => open,
                         CLKOUTDCM2         => open,
                         CLKOUTDCM3         => open,
                         CLKOUTDCM4         => open,
                         CLKOUTDCM5         => open,
                         CLKOUT0            => DIV_CLKDV,      -- naming not ideal, matches DCM naming
                         CLKOUT1            => DIV_CLK0,
                         CLKOUT2            => open,
                         CLKOUT3            => open,
                         CLKOUT4            => open,
                         CLKOUT5            => open,
                         DO                 => DIV_DO,
                         DRDY               => open,
                         LOCKED             => DIV_LOCKED
            );

        DIV_CLKIN <= hsinclk;
        divider_lock <= DIV_LOCKED;
        CLK_DIV_RESET<= not DIV_LOCKED;

        div_PLLfeedback_BUFG_inst : BUFG
        port map (
        O => DIV_PLLFBO, -- Clock buffer output
        I => DIV_PLLFBI -- Clock buffer input
        );
        
    end generate;

    gen_dcm: if (USE_INPLL = FALSE) generate
    
        DCM_ADV_inst : DCM_ADV
        generic map (
        CLKDV_DIVIDE            => real(clockmultiplier), -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
        CLKFX_DIVIDE            => 1, -- Can be any integer from 1 to 32
        CLKFX_MULTIPLY          => 2, -- Can be any integer from 2 to 32
        CLKIN_DIVIDE_BY_2       => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
        CLKIN_PERIOD            => calcperiod(CLKSPEED,clockmultiplier), -- Specify period of input clock in ns from 1.25 to 1000.00
        CLKOUT_PHASE_SHIFT      => "NONE", -- Specify phase shift mode of NONE, FIXED,
        -- VARIABLE_POSITIVE, VARIABLE_CENTER or DIRECT
        CLK_FEEDBACK            => "1X", -- Specify clock feedback of NONE or 1X
        DCM_AUTOCALIBRATION     => TRUE, -- DCM calibration circuitry TRUE/FALSE
        DCM_PERFORMANCE_MODE    => "MAX_SPEED", -- Can be MAX_SPEED or MAX_RANGE
        DESKEW_ADJUST           => "SOURCE_SYNCHRONOUS", -- SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
        -- an integer from 0 to 15
        DFS_FREQUENCY_MODE      => "HIGH", -- HIGH or LOW frequency mode for frequency synthesis
                                           -- HIGH:  25MHz < CLKIN < 350MHz
                                           --     : 140MHz < CLKFX < 350MHz
        DLL_FREQUENCY_MODE      => "HIGH", -- LOW, HIGH, or HIGH_SER frequency mode for DLL
                                           --
        DUTY_CYCLE_CORRECTION   => TRUE, -- Duty cycle correction, TRUE or FALSE
        FACTORY_JF              => X"F0F0", -- FACTORY JF Values Suggested to be set to X"F0F0"
        PHASE_SHIFT             => 0, -- Amount of fixed phase shift from -255 to 1023
        --SIM_DEVICE              => "VIRTEX5", -- Set target device, "VIRTEX4" or "VIRTEX5"
        SIM_DEVICE              => C_FAMILY,
        STARTUP_WAIT            => FALSE -- Delay configuration DONE until DCM LOCK, TRUE/FALSE
        )
        port map (
        CLK0            => DIV_CLK0,                -- 0 degree DCM CLK output
        CLK180          => DIV_CLK180,              -- 180 degree DCM CLK output
        CLK270          => DIV_CLK270,              -- 270 degree DCM CLK output
        CLK2X           => DIV_CLK2X,               -- 2X DCM CLK output
        CLK2X180        => DIV_CLK2X180,            -- 2X, 180 degree DCM CLK out
        CLK90           => DIV_CLK90,               -- 90 degree DCM CLK output
        CLKDV           => DIV_CLKDV,               -- Divided DCM CLK out (CLKDV_DIVIDE)
        CLKFX           => DIV_CLKFX,               -- DCM CLK synthesis out (M/D)
        CLKFX180        => DIV_CLKFX180,            -- 180 degree CLK synthesis out
        DO              => DIV_DO,                  -- 16-bit data output for Dynamic Reconfiguration Port (DRP)
        DRDY            => open,                    -- Ready output signal from the DRP
        LOCKED          => DIV_LOCKED,              -- DCM LOCK status output
        PSDONE          => open,                    -- Dynamic phase adjust done output
        CLKFB           => DIV_CLKFB,               -- DCM clock feedback
        CLKIN           => DIV_CLKIN,               -- Clock input (from IBUFG, BUFG or DCM)
        DADDR           => zeros(6 downto 0),       -- 7-bit address for the DRP
        DCLK            => CLOCK,                   -- Clock for the DRP
        DEN             => zero,                    -- Enable input for the DRP
        DI              => zeros(15 downto 0),      -- 16-bit data input for the DRP
        DWE             => zero,                    -- Active high allows for writing configuration memory
        PSCLK           => zero,                    -- Dynamic phase adjust clock input
        PSEN            => zero,                    -- Dynamic phase adjust enable input
        PSINCDEC        => zero,                    -- Dynamic phase adjust increment/decrement
        RST             => DIV_RST                  -- DCM asynchronous reset input
        );

        DIV_CLKIN <= hsinclk;
        divider_lock <= DIV_LOCKED and not DIV_DO(1);
        CLK_DIV_RESET<= not DIV_LOCKED and DIV_DO(1);
    
    end generate;

  end generate; --gen_iserdes_divider_v5 : if (C_FAMILY = "virtex5" ) generate

  gen_iserdes_divider_v6 : if (C_FAMILY = "virtex6" or C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate

         mmcm_adv_inst : MMCM_ADV
           generic map
            (BANDWIDTH            => "OPTIMIZED",
             CLKOUT4_CASCADE      => FALSE,
             CLOCK_HOLD           => FALSE,
             COMPENSATION         => "ZHOLD",
             STARTUP_WAIT         => FALSE,
             DIVCLK_DIVIDE        => 5,
             CLKFBOUT_MULT_F      => 5.0*real(inpllmultiplier),               --this could be wrong for other implementations
             CLKFBOUT_PHASE       => 0.000,
             CLKFBOUT_USE_FINE_PS => FALSE,
             CLKOUT0_DIVIDE_F     => real(clockmultiplier)*real(inpllmultiplier),
             CLKOUT0_PHASE        => 0.000,
             CLKOUT0_DUTY_CYCLE   => 0.500,
             CLKOUT0_USE_FINE_PS  => FALSE,
             CLKOUT1_DIVIDE       => inpllmultiplier,
             CLKOUT1_PHASE        => 0.000,
             CLKOUT1_DUTY_CYCLE   => 0.500,
             CLKOUT1_USE_FINE_PS  => FALSE,
             CLKIN1_PERIOD        => calcperiod(CLKSPEED,clockmultiplier),
             REF_JITTER1          => 0.005000,
             CLKIN2_PERIOD        => calcperiod(CLKSPEED,clockmultiplier),
             REF_JITTER2          => 0.005000
           )
           port map
           (
             -- Output clocks
             CLKFBOUT            => DIV_PLLFBI,       -- naming not ideal, matches DCM naming
             CLKFBOUTB           => open,
             CLKOUT0             => DIV_CLKDV,      -- naming not ideal, matches DCM naming
             CLKOUT0B            => open,
             CLKOUT1             => DIV_CLK0,
             CLKOUT1B            => open,
             CLKOUT2             => open,
             CLKOUT2B            => open,
             CLKOUT3             => open,
             CLKOUT3B            => open,
             CLKOUT4             => open,
             CLKOUT5             => open,
             CLKOUT6             => open,
             -- Input clock control
             CLKFBIN             => DIV_PLLFBO,
             CLKIN1              => DIV_CLKIN,
             --CLKIN2              => '0',
             CLKIN2              => DIV_CLKIN,
             -- Tied to always select the primary input clock
             CLKINSEL            => '1',
             -- Ports for dynamic reconfiguration
             DADDR               => (others => '0'),
             DCLK                => CLOCK,
             DEN                 => '0',
             DI                  => (others => '0'),
             DO                  => DIV_DO,
             DRDY                => open,
             DWE                 => '0',
             -- Ports for dynamic phase shift
             PSCLK               => '0',
             PSEN                => '0',
             PSINCDEC            => '0',
             PSDONE              => open,
             -- Other control and status signals
             LOCKED              => DIV_LOCKED,
             CLKINSTOPPED        => open,
             CLKFBSTOPPED        => open,
             PWRDWN              => '0',
             RST                 => DIV_RST
           );

        DIV_CLKIN <= hsinclk;
        divider_lock <= DIV_LOCKED;
        CLK_DIV_RESET<= not DIV_LOCKED;

        div_PLLfeedback_BUFG_inst : BUFG
        port map (
        O => DIV_PLLFBO, -- Clock buffer output
        I => DIV_PLLFBI -- Clock buffer input
        );

  end generate; --gen_iserdes_divider_v6 : if (C_FAMILY = "virtex6" or C_FAMILY = "kintex7" or C_FAMILY = "zynq" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate

  div_feedback_BUFG_inst : BUFG
  port map (
    O => DIV_CLKFB, -- Clock buffer output
    I => DIV_CLK0 -- Clock buffer input
  );

  LS_Input_BUFG_inst : BUFG
  port map (
    O => lsinclk, -- Clock buffer output
    I => DIV_CLKDV -- Clock buffer input
  );

end generate; -- gen_iserdes_divider

-- connect DCM input to appclock when used as a multiplier
-- connect DCM input to incoming hsclk when used as a divider

gen_no_iserdes_divider_DCM: if (USE_HS_EXT_CLK_IN = FALSE or USE_LS_EXT_CLK_IN = TRUE or (BUFR_dividable = TRUE and USE_LS_REGIONAL_CLK=TRUE)or (USE_HS_REGIONAL_CLK = TRUE and BUFR_dividable = TRUE)) generate
    DIV_LOCKED <= '1';
    divider_lock <= '1';
    DIV_DO     <= (others => '0');
    CLK_DIV_RESET<= RESET;      --FIXME should be in reset until a clock is comming from the device find a way to detect this.
end generate; -- gen_no_iserdes_divider_DCM

-- clocks out
-- high speed clock outs
gen_hs_clk_out: if (USE_HS_EXT_CLK_OUT = TRUE) generate

    DataSampleClk : ODDR
    generic map(
        DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
        INIT => '0', -- Initial value for Q port (’1’ or ’0’)
        SRTYPE => "SYNC") -- Reset Type ("ASYNC" or "SYNC")
    port map (
        Q =>    hsoddroutclk        , -- 1-bit DDR output
        C =>    hsdcmmultclk        , -- 1-bit clock input
        CE =>   '1'                 ,
        D1 =>   '1'                 ,
        D2 =>   '0'                 ,
        R =>    '0'                 , -- 1-bit reset input
        S =>    '0'                   -- 1-bit set input
    );

    --high speed output can only be made on FPGA
    gen_diff_hs_clk_out: if (USE_DIFF_HS_CLK_OUT = TRUE) generate
        hs_clk_out_obufds : OBUFDS
        generic map (
            IOSTANDARD => "DEFAULT")
        port map (
        O       => HS_OUT_CLK    ,   -- Diff_p output (connect directly to top-level port)
        OB      => HS_OUT_CLKb   ,   -- Diff_n output (connect directly to top-level port)
        I       => hsoddroutclk      -- Buffer input
        );
    end generate;

    gen_no_diff_hs_clk_out: if (USE_DIFF_HS_CLK_OUT = FALSE) generate
        HS_OUT_CLK  <= hsoddroutclk;
        HS_OUT_CLKb <= '0';
    end generate;
end generate;

gen_no_hs_clk_out: if (USE_HS_EXT_CLK_OUT = FALSE) generate
    HS_OUT_CLK  <= '0';
    HS_OUT_CLKb <= '0';
end generate;

-- low speed clock outs

gen_ls_clk_out: if (USE_LS_EXT_CLK_OUT = TRUE) generate

    DataSampleClk : ODDR
    generic map(
        DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"
        INIT => '0', -- Initial value for Q port (’1’ or ’0’)
        SRTYPE => "SYNC") -- Reset Type ("ASYNC" or "SYNC")
    port map (
        Q =>    lsoddroutclk        , -- 1-bit DDR output
        C =>    lsoutclk            , -- 1-bit clock input
        CE =>   '1'                 ,
        D1 =>   '1'                 ,
        D2 =>   '0'                 ,
        R =>    '0'                 , -- 1-bit reset input
        S =>    '0'                   -- 1-bit set input
    );

    gen_diff_ls_clk_out: if (USE_DIFF_LS_CLK_OUT = TRUE) generate
        ls_clk_out_obufds : OBUFDS
        generic map (
            IOSTANDARD => "DEFAULT")
        port map (
        O       => LS_OUT_CLK    ,   -- Diff_p output (connect directly to top-level port)
        OB      => LS_OUT_CLKb   ,   -- Diff_n output (connect directly to top-level port)
        I       => lsoddroutclk      -- Buffer input
        );
    end generate;

    gen_no_diff_ls_clk_out: if (USE_DIFF_LS_CLK_OUT = FALSE) generate
        LS_OUT_CLK  <= lsoddroutclk;
        LS_OUT_CLKb <= '0';
    end generate;
end generate;

gen_no_ls_clk_out: if (USE_LS_EXT_CLK_OUT = FALSE) generate
    LS_OUT_CLK  <= '0';
    LS_OUT_CLKb <= '0';
end generate;

-- clocks in
-- high speed clock in

gen_hs_clk_in: if (USE_HS_EXT_CLK_IN = TRUE) generate
    --assume always differential
    gen_diff_hs_clk_in :if (USE_DIFF_HS_CLK_IN = TRUE) generate
        IBUFDS_inst : IBUFDS
        generic map (
            CAPACITANCE         => "DONT_CARE"  , -- "LOW", "NORMAL", "DONT_CARE" (Virtex-4 only)
            DIFF_TERM           => DIFF_TERM    , -- Differential Termination (Virtex-4/5, Spartan-3E/3A)
            IBUF_DELAY_VALUE    => "0"          , -- Specify the amount of added input delay for buffer, "0"-"16" (Spartan-3E/3A only)
            IFD_DELAY_VALUE     => "AUTO"       , -- Specify the amount of added delay for input register, "AUTO", "0"-"8" (Spartan-3E/3A only)
            IOSTANDARD          => "DEFAULT"
            )
        port map (
        O   => hsinclk     ,   -- Clock buffer output
        I   => HS_IN_CLK    ,   -- Diff_p clock buffer input (connect directly to top-level port)
        IB  => HS_IN_CLKb       -- Diff_n clock buffer input (connect directly to top-level port)
        );
    end generate;

    gen_single_hs_clk_in :if (USE_DIFF_HS_CLK_IN = FALSE) generate
        hsinclk <= HS_IN_CLK;
    end generate;

 --   gen_direct_connection: if (USE_HS_EXT_CLK_IN = TRUE) generate

   --     CLK <= clk_tmp;
     --   CLKb <= not clk_tmp;

        gen_regional_hs_clk_in: if (USE_HS_REGIONAL_CLK = TRUE) generate
            -- uses BUFIO because the only clocked instances with this clock are in the IO column
            -- is limited to one clockregion
            BUFIO_regional_hs_clk_in : BUFIO
            port map (
            O => clk_tmp, -- Clock buffer output
            I => hsinclk  -- Clock buffer input
            );

        CLK <= clk_tmp;
        CLKb <= clk_tmp;
        end generate;

      -- gen_global_hs_clk_in: if (USE_HS_REGIONAL_CLK = FALSE) generate
      --     -- uses BUFG
      --     BUFG_regional_hs_clk_in : BUFG
      --     port map (
      --     O => clk_tmp, -- Clock buffer output
      --     I => hsinclk -- Clock buffer input
      --     );
      --
      -- CLK <= clk_tmp;
      -- CLKb <= not clk_tmp;
      -- end generate;
    --end generate;

    gen_no_direct_connection: if (USE_LS_EXT_CLK_IN = FALSE and USE_HS_REGIONAL_CLK = FALSE) generate --divider dcm is generated
        CLK  <= DIV_CLKFB;
        CLKb <= DIV_CLKFB; --or DIV_CLK180
    end generate;

end generate;

gen_no_hs_clk_in: if (USE_HS_EXT_CLK_IN = FALSE) generate
-- use DCM for high speed clocking
    CLK         <= hsdcmmultclk;
    CLKb        <= not hsdcmmultclk;
    hsinclk     <= hsdcmmultclk;
end generate;

--low speed clock in
gen_ls_clk_in: if (USE_LS_EXT_CLK_IN = TRUE) generate
    gen_diff_ls_clk_in: if (USE_DIFF_LS_CLK_IN = TRUE) generate
        IBUFDS_inst : IBUFDS
        generic map (
            CAPACITANCE         => "DONT_CARE"  , -- "LOW", "NORMAL", "DONT_CARE" (Virtex-4 only)
            DIFF_TERM           => DIFF_TERM    , -- Differential Termination (Virtex-4/5, Spartan-3E/3A)
            IBUF_DELAY_VALUE    => "0"          , -- Specify the amount of added input delay for buffer, "0"-"16" (Spartan-3E/3A only)
            IFD_DELAY_VALUE     => "AUTO"       , -- Specify the amount of added delay for input register, "AUTO", "0"-"8" (Spartan-3E/3A only)
            IOSTANDARD          => "DEFAULT"
            )
        port map (
        O   => lsinclk     ,   -- Clock buffer output
        I   => LS_IN_CLK    ,   -- Diff_p clock buffer input (connect directly to top-level port)
        IB  => LS_IN_CLKb       -- Diff_n clock buffer input (connect directly to top-level port)
        );
    end generate;

    gen_single_ls_clk_in :if (USE_DIFF_LS_CLK_IN = FALSE) generate
        lsinclk <= LS_IN_CLK;
    end generate;

    gen_regional_ls_clk_in: if (USE_LS_REGIONAL_CLK = TRUE) generate
        BUFR_regional_hs_clk_in : BUFR
            generic map (
            BUFR_DIVIDE => "BYPASS"     , -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
            --SIM_DEVICE  => SIM_DEVICE
            SIM_DEVICE  => C_FAMILY
            )
            port map (
            O => CLKDIV, -- Clock buffer output
            CE  => one      ,
            CLR => zero     ,
            I => lsinclk  -- Clock buffer input
            );
    end generate;

    gen_noregional_ls_clk_in: if (USE_LS_REGIONAL_CLK = FALSE) generate
        BUFG_regional_hs_clk_in : BUFG
        port map (
        O   => CLKDIV, -- Clock buffer output
        I   => lsinclk  -- Clock buffer input
        );
    end generate;
end generate;

gen_no_ls_clk_in: if (USE_LS_EXT_CLK_IN = FALSE) generate

    gen_regional_hs_clk_in: if (USE_HS_REGIONAL_CLK = TRUE) generate
    -- use BUFR if it can divide
    -- multiplier can be 2 or bigger
        gen_multiplier_2: if (clockmultiplier = 2) generate
            BUFR_regional_hs_clk_in : BUFR
                generic map (
                BUFR_DIVIDE => "2", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                --SIM_DEVICE  => SIM_DEVICE
                SIM_DEVICE  => "7series"
                )
                port map (
                O       => CLKDIV   ,   -- Clock buffer output
                CE      => one      ,
                CLR     => zero     ,
                I       => hsinclk      -- Clock buffer input
                );
        end generate;

        gen_multiplier_3: if (clockmultiplier = 3) generate
            BUFR_regional_hs_clk_in : BUFR
                generic map (
                BUFR_DIVIDE => "3", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                --SIM_DEVICE  => SIM_DEVICE
                SIM_DEVICE  => "7series"
                )
                port map (
                O       => CLKDIV   ,   -- Clock buffer output
                CE      => one      ,
                CLR     => zero     ,
                I       => hsinclk      -- Clock buffer input
                );
        end generate;

        gen_multiplier_4: if (clockmultiplier = 4) generate
            BUFR_regional_hs_clk_in : BUFR
                generic map (
                BUFR_DIVIDE => "4", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                --SIM_DEVICE  => SIM_DEVICE
                SIM_DEVICE  => "7series"
                )
                port map (
                O       => CLKDIV   ,   -- Clock buffer output
                CE      => one      ,
                CLR     => zero     ,
                I       => hsinclk      -- Clock buffer input
                );
        end generate;

        gen_multiplier_5: if (clockmultiplier = 5) generate
            BUFR_regional_hs_clk_in : BUFR
                generic map (
                BUFR_DIVIDE => "5", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                --SIM_DEVICE  => SIM_DEVICE
                SIM_DEVICE  => "7series"
                )
                port map (
                O       => CLKDIV   ,   -- Clock buffer output
                CE      => one      ,
                CLR     => zero     ,
                I       => hsinclk      -- Clock buffer input
                );
        end generate;

        gen_multiplier_6: if (clockmultiplier = 6) generate
            BUFR_regional_hs_clk_in : BUFR
                generic map (
                BUFR_DIVIDE => "6", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                --SIM_DEVICE  => SIM_DEVICE
                SIM_DEVICE  => "7series"
                )
                port map (
                O       => CLKDIV   ,   -- Clock buffer output
                CE      => one      ,
                CLR     => zero     ,
                I       => hsinclk      -- Clock buffer input
                );
        end generate;

        gen_multiplier_7: if (clockmultiplier = 7) generate
            BUFR_regional_hs_clk_in : BUFR
                generic map (
                BUFR_DIVIDE => "7", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                --SIM_DEVICE  => SIM_DEVICE
                SIM_DEVICE  => "7series"
                )
                port map (
                O       => CLKDIV   ,   -- Clock buffer output
                CE      => one      ,
                CLR     => zero     ,
                I       => hsinclk      -- Clock buffer input
                );
        end generate;

        gen_multiplier_8: if (clockmultiplier = 8) generate
            BUFR_regional_hs_clk_in : BUFR
                generic map (
                BUFR_DIVIDE => "8", -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                --SIM_DEVICE  => SIM_DEVICE
                SIM_DEVICE  => "7series"
                )
                port map (
                O       => CLKDIV   ,   -- Clock buffer output
                CE      => one      ,
                CLR     => zero     ,
                I       => hsinclk      -- Clock buffer input
                );
        end generate;

        -- use DCM to divide when BUFR can't
        gen_other_multiplier: if ( BUFR_dividable = FALSE ) generate
            CLKDIV <= lsinclk;
        end generate;

    end generate;
    -- use DCM to divide when global clocking is used (or PMCD)
    gen_no_regional_hs_clk_in: if (USE_HS_REGIONAL_CLK = FALSE) generate
        CLKDIV <= lsinclk;
    end generate;

end generate;

-- only divider lock needs to be registered, multiplier lock is generated on same clock domain
register_process : process (RESET, CLOCK)
begin
if (RESET = '1') then

    divider_lock_r      <= '0';
    divider_lock_r2     <= '0';

elsif (CLOCK = '1' and CLOCK'event) then

    divider_lock_r      <= divider_lock;
    divider_lock_r2     <= divider_lock_r;

end if;
end process;

locked_monitor_process : process (RESET, CLOCK)
begin
if (RESET = '1') then
    MULT_RST    <= '1';
    DIV_RST     <= '1';

    LOCKED      <= '0';

    multiplier_status <= '0';
    divider_status    <= '0';

    CLK_RDY     <= '0';

    Cntr        <= (others => '1');

    lockedmonitorstate <= Idle;

elsif (CLOCK = '1' and CLOCK'event) then

    LOCKED      <= multiplier_status and divider_status;
    CLK_RDY     <= LOCKED;

    case lockedmonitorstate is
        when Idle =>
            Cntr                <= ResetTime; --reset should be asserted minimum one CLKDIV cycle
            if (multiplier_lock = '0') then
                multiplier_status   <= '0';
                divider_status      <= '0';
                MULT_RST            <= '1';
                DIV_RST             <= '1';
                lockedmonitorstate  <= AssertReset1;
            elsif (divider_lock_r2 = '0') then
                divider_status      <= '0';
                MULT_RST            <= '0';
                DIV_RST             <= '1';
                lockedmonitorstate  <= AssertReset2;
            else
                multiplier_status   <= '1';
                divider_status      <= '1';
                MULT_RST    <= '0';
                DIV_RST     <= '0';
            end if;

        when AssertReset1 =>
            If (Cntr(Cntr'high) = '1') then
                MULT_RST            <= '0';
                DIV_RST             <= '1';
                Cntr                <= LockTimeMULT; --Cntr should be as long as lock time
                lockedmonitorstate  <= WaitLocked1;
            else
                Cntr <= Cntr - '1';
            end if;

        when WaitLocked1 =>
            if (Cntr(Cntr'high) = '1') then
                MULT_RST            <= '0';
                DIV_RST             <= '1';
                lockedmonitorstate  <= CheckLocked1;
            else
                Cntr <= Cntr - '1';
            end if;

        when CheckLocked1 =>
            if (multiplier_lock = '1') then
                multiplier_status   <= '1';
                MULT_RST            <= '0';
                DIV_RST             <= '1';
                Cntr                <= ResetTime; --reset should be asserted minimum one CLKDIV cycle
                lockedmonitorstate  <= AssertReset2;
            else
                MULT_RST            <= '1';
                DIV_RST             <= '1';
                Cntr                <= ResetTime;
                lockedmonitorstate  <= AssertReset1;
            end if;

        when AssertReset2 =>
            If (Cntr(Cntr'high) = '1') then
                MULT_RST            <= '0';
                DIV_RST             <= '0';
                Cntr                <= LockTimeDIV; --Cntr should be as long as lock time
                lockedmonitorstate  <= WaitLocked2;
            else
                Cntr <= Cntr - '1';
            end if;

        when WaitLocked2 =>
            if (Cntr(Cntr'high) = '1') then
                MULT_RST            <= '0';
                DIV_RST             <= '0';
                lockedmonitorstate  <= CheckLocked2;
            else
                Cntr <= Cntr - '1';
            end if;

         when CheckLocked2 =>
            if (divider_lock_r2 = '1') then
                --divider_status      <= '1';
                --lockedmonitorstate  <= Idle;
                DIV_RST             <= '1';
                Cntr                <= ResetTime; --reset should be asserted minimum one CLKDIV cycle
                lockedmonitorstate  <= AssertReset3;
            else
                --check whether multiplier DCM did not get out of lock for some reason
                if (multiplier_lock = '0') then
                    multiplier_status   <= '0';
                    MULT_RST            <= '1';
                    DIV_RST             <= '1';
                    Cntr                <= ResetTime;
                    lockedmonitorstate  <= AssertReset1;
                else
                -- only reset divider DCM again in this state. Otherwise highspeedclock will not be available when no sensor is inserted (debug)
                    MULT_RST            <= '0';
                    DIV_RST             <= '1';
                    Cntr                <= ResetTime;
                    lockedmonitorstate  <= AssertReset2;
                end if;
            end if;

        -- code needs to lock twice to avoid power up problems.
        when AssertReset3 =>
            If (Cntr(Cntr'high) = '1') then
                MULT_RST            <= '0';
                DIV_RST             <= '0';
                Cntr                <= LockTimeDIV; --Cntr should be as long as lock time
                lockedmonitorstate  <= WaitLocked3;
            else
                Cntr <= Cntr - '1';
            end if;

        when WaitLocked3 =>
            if (Cntr(Cntr'high) = '1') then
                MULT_RST            <= '0';
                DIV_RST             <= '0';
                lockedmonitorstate  <= CheckLocked3;
            else
                Cntr <= Cntr - '1';
            end if;

         when CheckLocked3 =>
            if (divider_lock_r2 = '1') then
                divider_status      <= '1';
                lockedmonitorstate  <= Idle;
            else
                --check whether multiplier DCM did not get out of lock for some reason
                if (multiplier_lock = '0') then
                    multiplier_status   <= '0';
                    MULT_RST            <= '1';
                    DIV_RST             <= '1';
                    Cntr                <= ResetTime;
                    lockedmonitorstate  <= AssertReset1;
                else
                -- only reset divider DCM again in this state. Otherwise highspeedclock will not be available when no sensor is inserted (debug)
                    MULT_RST            <= '0';
                    DIV_RST             <= '1';
                    Cntr                <= ResetTime;
                    lockedmonitorstate  <= AssertReset2;
                end if;
            end if;


        when others =>
            lockedmonitorstate  <= Idle;

    end case;

end if;
end process;

end rtl;