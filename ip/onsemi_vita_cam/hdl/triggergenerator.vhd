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
-- File           : $URL: http://whatever.euro.cypress.com/repos/vita1300/RefKitAltera/VHDL/trunk/CY_VITA/triggergenerator.vhd $
-- Author         : $Author: bert.dewil $
-- Department     : CISP
-- Date           : $Date: 2011-03-22 08:58:11 +0100 (di, 22 mrt 2011) $
-- Revision       : $Revision: 1091 $
-- *********************************************************************
-- Description
--
-- Generates trigger to VITA to make the sensor work in triggered mode.
-- Can be used to control integration time
--
-- *********************************************************************

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
entity triggergenerator is
  port (
        -- Control signals
        csi_clockreset_clk       : in    std_logic;
        csi_clockreset_reset_n   : in    std_logic;

        coe_external_trigger_in  : in    std_logic;        
        readouttrigger           : in    std_logic;

        ENABLETRIGGER            : in    std_logic_vector(2 downto 0); --what trigger should be used 0 simple mode + 1 and 2 for multislope
        SYNCTOREADOUT_OR_EXT     : in    std_logic_vector(2 downto 0); --(0): enable timeout default frequency
                                                                       --(1): trigger on readout input trigger
                                                                       --(2): trigger on external input trigger
                                                                       --Note: (0) can be combined with (1) xor (2), (1) and (2) can be combined but it is prob not usefull
        DEFAULTFREQ              : in    std_logic_vector(31 downto 0); --acutally an interval
        TRIGGERLENGTHLOW0        : in    std_logic_vector(31 downto 0);
        TRIGGERLENGTHHIGH0       : in    std_logic_vector(31 downto 0);
        TRIGGERLENGTHLOW1        : in    std_logic_vector(31 downto 0);
        TRIGGERLENGTHHIGH1       : in    std_logic_vector(31 downto 0);
        TRIGGERLENGTHLOW2        : in    std_logic_vector(31 downto 0);
        TRIGGERLENGTHHIGH2       : in    std_logic_vector(31 downto 0);
        
        EXTERNAL_TRIGGER_DEB     : in    std_logic_vector(31 downto 0); 
        EXTERNAL_TRIGGER_POL     : in    std_logic;                       --0 is active low 1 is active high
        coe_vita_TRIGGER         : out   std_logic_vector(2 downto 0)
  );
end triggergenerator;

architecture rtl of triggergenerator is

signal trigger_0    : std_logic;
signal trigger_1    : std_logic;
signal trigger_2    : std_logic;

signal TriggerCntr  : std_logic_vector(32 downto 0);

signal FPScounter   : std_logic_vector(32 downto 0);
signal starttrigger : std_logic;

signal ext_trigger_deb           : std_logic;
signal coe_external_trigger_in_d : std_logic;
signal DebCntr         : std_logic_vector(32 downto 0);

type TriggerStatetp is (    Idle,
                            Trig0High,
                            Trig0Low,
                            Trig1High,
                            Trig1Low,
                            Trig2High,
                            Trig2Low
                        );

signal TriggerState : TriggerStatetp;

begin

coe_vita_TRIGGER(0) <= trigger_0;
coe_vita_TRIGGER(1) <= trigger_1;
coe_vita_TRIGGER(2) <= trigger_2;

--Debounce external trigger: trigger is accepted if input signal does not change for EXTERNAL_TRIGGER_DEB and has right polarity
debounce : process(csi_clockreset_clk, csi_clockreset_reset_n)
begin
    if (csi_clockreset_reset_n = '0') then
        coe_external_trigger_in_d<='0';
        ext_trigger_deb    <= '0';
        DebCntr      <= (others => '1');
    elsif (csi_clockreset_clk'event and csi_clockreset_clk= '1') then
        coe_external_trigger_in_d <=coe_external_trigger_in;

        if ((coe_external_trigger_in xor coe_external_trigger_in_d) = '1') then --if change restart
          DebCntr   <= '0' & EXTERNAL_TRIGGER_DEB;
        elsif DebCntr(DebCntr'high)='0' then
          DebCntr <= DebCntr - '1'; 
        end if;
        
        ext_trigger_deb    <= '0';
        if(unsigned(DebCntr)=0 and coe_external_trigger_in_d=EXTERNAL_TRIGGER_POL) then --trigger when change is stable and correct pol
          ext_trigger_deb <='1';
        end if;
        
    end if;
end process;

--Start trigger generation depending on SYNCTOREADOUT_OR_EXT, input triggers and DEFAULT PERIOD/FREQ
fpsgenerator : process(csi_clockreset_clk, csi_clockreset_reset_n)
begin
    if (csi_clockreset_reset_n = '0') then
        starttrigger    <= '0';
        FPScounter      <= (others => '1');
    elsif (csi_clockreset_clk'event and csi_clockreset_clk= '1') then

        starttrigger    <= '0';
        if (readouttrigger = '1' and SYNCTOREADOUT_OR_EXT(1) = '1') then
            starttrigger <= '1';
            FPScounter   <= '0' & DEFAULTFREQ;
        elsif (ext_trigger_deb = '1' and SYNCTOREADOUT_OR_EXT(2) = '1') then
            starttrigger <= '1';
            FPScounter   <= '0' & DEFAULTFREQ;            
        elsif (FPScounter(FPScounter'high) = '1' ) then --default frequency
            starttrigger <= SYNCTOREADOUT_OR_EXT(0);
            FPScounter   <= '0' & DEFAULTFREQ;
        else
            FPScounter <= FPScounter - '1';
        end if;
    end if;
end process;

--On starttrigger start player (once)
triggerprocess  : process(csi_clockreset_clk, csi_clockreset_reset_n)
begin
    if (csi_clockreset_reset_n = '0') then
        trigger_0         <= '0';
        trigger_1         <= '0';
        trigger_2         <= '0';

        TriggerCntr     <= (others => '1');

        TriggerState    <= Idle;

    elsif (csi_clockreset_clk'event and csi_clockreset_clk= '1') then
        case TriggerState is
            when Idle => --holdoff system Trigger is only accepted when system was idle
                if starttrigger = '1' and ENABLETRIGGER(0) = '1' then
                    trigger_0       <= '1';
                    TriggerCntr     <= '0' & TRIGGERLENGTHHIGH0;
                    TriggerState    <= Trig0High;
                end if;

            when Trig0High =>
                if (TriggerCntr(TriggerCntr'high) = '1') then
                    TriggerCntr     <= '0' & TRIGGERLENGTHLOW0;
                    trigger_0       <= '0';
                    TriggerState    <= Trig0Low;
                else
                    TriggerCntr     <= TriggerCntr - '1';
                end if;

            when Trig0Low =>
                if (TriggerCntr(TriggerCntr'high) = '1') then
                    if (ENABLETRIGGER(1) = '1') then
                        trigger_1       <= '1';
                        TriggerCntr     <= '0' & TRIGGERLENGTHHIGH1;
                        TriggerState    <= Trig1High;
                    else
                        TriggerState    <= Idle;
                    end if;
                else
                    TriggerCntr  <= TriggerCntr - '1';
                end if;

            when Trig1High =>
                if (TriggerCntr(TriggerCntr'high) = '1') then
                    TriggerCntr     <= '0' & TRIGGERLENGTHLOW1;
                    trigger_1       <= '0';
                    TriggerState    <= Trig1Low;
                else
                    TriggerCntr     <= TriggerCntr - '1';
                end if;

            when Trig1Low =>
                if (TriggerCntr(TriggerCntr'high) = '1') then
                    if (ENABLETRIGGER(2) = '1') then
                        trigger_2       <= '1';
                        TriggerCntr     <= '0' & TRIGGERLENGTHHIGH2;
                        TriggerState    <= Trig2High;
                    else
                        TriggerState    <= Idle;
                    end if;
                else
                    TriggerCntr  <= TriggerCntr - '1';
                end if;

            when Trig2High =>
                if (TriggerCntr(TriggerCntr'high) = '1') then
                    TriggerCntr     <= '0' & TRIGGERLENGTHLOW2;
                    trigger_2       <= '0';
                    TriggerState    <= Trig2Low;
                else
                    TriggerCntr     <= TriggerCntr - '1';
                end if;

            when Trig2Low =>
                if (TriggerCntr(TriggerCntr'high) = '1') then
                    TriggerState    <= Idle;
                else
                    TriggerCntr  <= TriggerCntr - '1';
                end if;

            when others =>
                TriggerState <= Idle;

        end case;
    end if;

end process;

end rtl;