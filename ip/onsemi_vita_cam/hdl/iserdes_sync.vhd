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
-- File           : $URL: http://whatever.euro.cypress.com/repos/ff_te/VHDL/LIB/modules/Iserdes/trunk/iserdes_sync.vhd $
-- Author         : $Author: bert.dewil $
-- Department     : CISP
-- Date           : $Date: 2011-05-02 17:07:00 +0200 (ma, 02 mei 2011) $
-- Revision       : $Revision: 918 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library unisim;
use unisim.vcomponents.all;

entity iserdes_sync is
  generic(
        DATAWIDTH       : integer;
        NROF_CONN       : integer
       );
  port(
        CLOCK           : in    std_logic;
        RESET           : in    std_logic;

        CLK             : in    std_logic;
        CLKDIV          : in    std_logic;

        REQ             : in    std_logic;
        ACK             : out   std_logic;

        -- to ISERDES

        CLK_DIV_RESET         : in std_logic;

        ISERDES_SEL             : out   std_logic_vector(15 downto 0);

        IODELAY_ISERDES_RESET   : out   std_logic;
        IODELAY_INC             : out   std_logic;
        IODELAY_CE              : out   std_logic;

        ISERDES_BITSLIP         : out   std_logic;

        ISERDES_DATA            : in    std_logic_vector(DATAWIDTH-1 downto 0);

        FIFO_RESET              : out   std_logic;
        FIFO_WREN               : out   std_logic_vector(NROF_CONN-1 downto 0);

        --from control
        CTRL_SEL                : in    std_logic_vector(15 downto 0);

        CTRL_RESET              : in    std_logic;
        CTRL_INC                : in    std_logic;
        CTRL_CE                 : in    std_logic;

        CTRL_BITSLIP            : in    std_logic;

        CTRL_SAMPLEINFIRSTBIT   : in    std_logic_vector(NROF_CONN-1 downto 0);
        CTRL_SAMPLEINLASTBIT    : in    std_logic_vector(NROF_CONN-1 downto 0);
        CTRL_SAMPLEINOTHERBIT   : in    std_logic_vector(NROF_CONN-1 downto 0);

        CTRL_DATA               : out   std_logic_vector(DATAWIDTH-1 downto 0);

        CTRL_FIFO_RESET         : in    std_logic;

        --from compare
        CTRL_FIFO_WREN          : in    std_logic;
        CTRL_DELAY_WREN         : in    std_logic
       );


end iserdes_sync;

architecture rtl of iserdes_sync is

type syncstatetp is (       Idle,
                            WaitDataValid,
                            WaitReqLow
                            );

signal syncstate     : syncstatetp;
signal syncdatastate : syncstatetp;

signal ReqPipe : std_logic_vector(1 downto 0);
signal AckPipe : std_logic_vector(1 downto 0);

signal Ack_int  : std_logic;

type datapipetp is array (0 to 1) of std_logic_vector(DATAWIDTH-1 downto 0);
signal datapipe : datapipetp;

signal WaitCntr : std_logic_vector(2 downto 0);

signal FIFO_RESET_r     : std_logic;
signal FIFO_WREN_r      : std_logic;

signal FIRSTBIT_OR      : std_logic;
signal LASTBIT_OR       : std_logic;
signal OTHERBIT_OR      : std_logic;

signal SKEW_ERROR       : std_logic;

--signal test : std_logic_vector(NROF_CONN-1 downto 0);
--
--attribute S: string;
--attribute keep: string;
--attribute S of test : signal is "TRUE";
--attribute keep of test : signal is "TRUE";

begin

metastabilityavoid: process(CLK_DIV_RESET, CLKDIV)
begin
if (CLK_DIV_RESET = '1') then

    ReqPipe <= (others => '0');

elsif (CLKDIV'event and CLKDIV = '1') then

    ReqPipe(0) <= REQ;
    for i in 0 to (ReqPipe'high-1) loop
        ReqPipe(i+1) <= ReqPipe(i);
    end loop;

end if;
end process;

synctoclkdiv: process(CLK_DIV_RESET, CLKDIV)
begin
if (CLK_DIV_RESET = '1') then

    IODELAY_ISERDES_RESET   <= '1';
    IODELAY_INC             <= '0';
    IODELAY_CE              <= '0';

    ISERDES_BITSLIP         <= '0';

    ISERDES_SEL             <= (others => '0');

    FIFO_RESET              <= '1';
    FIFO_WREN               <= (others => '0');
    FIFO_WREN_r             <= '0';

    FIFO_RESET_r            <= '1';

    Ack_int                 <= '0';

    WaitCntr                <= (others => '0');

    syncstate               <= Idle;

elsif (CLKDIV'event and CLKDIV = '1') then

    --defaults
    IODELAY_INC         <= '0';
    IODELAY_CE          <= '0';

    ISERDES_BITSLIP     <= '0';

    FIFO_RESET_r        <= CTRL_FIFO_RESET;

    FIFO_RESET          <= FIFO_RESET_r;
    FIFO_WREN_r         <= CTRL_FIFO_WREN;

-- wr_en ctrl
    if (CTRL_DELAY_WREN = '1') then --special case
        for i in 0 to NROF_CONN-1 loop
            if ( CTRL_SAMPLEINFIRSTBIT(i) = '1') then -- delay wr extra
                FIFO_WREN(i) <= FIFO_WREN_r;
            else                                     -- no extra delay
                FIFO_WREN(i) <= CTRL_FIFO_WREN;
            end if;
        end loop;
    else
        FIFO_WREN             <= (others => CTRL_FIFO_WREN);
    end if;

    case syncstate is
        when Idle =>
            if (ReqPipe(ReqPipe'high) = '1') then --synchronised request
                IODELAY_ISERDES_RESET   <= CTRL_RESET;
                IODELAY_INC             <= CTRL_INC;
                IODELAY_CE              <= CTRL_CE;
                ISERDES_BITSLIP         <= CTRL_BITSLIP;
                ISERDES_SEL             <= CTRL_SEL;
                WaitCntr                <= "011";           --tune to save time
                syncstate               <= WaitDataValid;
            end if;

        when WaitDataValid =>
            if (WaitCntr(WaitCntr'high) = '1') then
                Ack_int                 <= '1';
                syncstate               <= WaitReqLow;
            else
                WaitCntr <= WaitCntr - '1';
            end if;

        when WaitReqLow =>
            if (ReqPipe(ReqPipe'high) = '0') then --synchronised request
                Ack_int                 <= '0';
                syncstate <= Idle;
            end if;

        when others =>
            syncstate   <= Idle;

    end case;

end if;
end process synctoclkdiv;

syncfromclkdiv: process(RESET, CLOCK)
begin
if (RESET = '1') then

    CTRL_DATA   <= (others => '0');
    ACK         <= '0';
    AckPipe     <= (others => '0');
    syncdatastate   <= Idle;

elsif (CLOCK'event and CLOCK = '1') then

    datapipe(0) <= ISERDES_DATA;
    AckPipe(0) <= Ack_int;

    for i in 0 to (datapipe'high-1) loop
        datapipe(i+1) <= datapipe(i);
        AckPipe(i+1) <= AckPipe(i);
    end loop;

    ACK <= AckPipe(AckPipe'high);

    case syncdatastate is
        when Idle =>
            if (REQ = '1') then -- request
                syncdatastate <= WaitReqLow;
            end if;

        when WaitReqLow =>
            if (REQ = '0') then --synchronised request
                CTRL_DATA <= datapipe(datapipe'high);
                syncdatastate <= Idle;
            end if;

        when others =>
            syncdatastate   <= Idle;

    end case;

end if;
end process syncfromclkdiv;

end rtl;