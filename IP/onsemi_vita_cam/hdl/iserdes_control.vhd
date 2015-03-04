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
-- File           : $URL: http://whatever.euro.cypress.com/repos/ff_te/VHDL/LIB/modules/Iserdes/trunk/iserdes_control.vhd $
-- Author         : $Author: bert.dewil $
-- Department     : CISP
-- Date           : $Date: 2011-05-02 09:00:53 +0200 (ma, 02 mei 2011) $
-- Revision       : $Revision: 917 $
-- *********************************************************************
-- Description
--
-- This code controls the training of the individual SERDES modules
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

--xilinx:
---------
-- synopsys translate_off
Library XilinxCoreLib;
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on
-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_control is
  generic (
        NROF_CONN       : integer; --16 bits
        DATAWIDTH       : integer;
        RETRY_MAX       : integer; --16 bits, global
        STABLE_COUNT    : integer; -- x bits,
        TAP_COUNT_MAX   : integer;
        INVERSE_BITORDER : boolean
  );
  port(
        CLOCK           : in    std_logic;
        RESET           : in    std_logic;

        ALIGN_START     : in    std_logic;
        ALIGN_BUSY      : out   std_logic;
        ALIGNED         : out   std_logic;

        AUTOALIGN       : in    std_logic; --when 0 use manual tap setting as an override for the bitalign/wordalign
                                           --when 1

        TRAINING        : in    std_logic_vector(DATAWIDTH-1 downto 0);
        MANUAL_TAP      : in    std_logic_vector(9 downto 0);

        -- status info
        EDGE_DETECT         : out   std_logic_vector(NROF_CONN-1 downto 0);
        TRAINING_DETECT     : out   std_logic_vector(NROF_CONN-1 downto 0);
        STABLE_DETECT       : out   std_logic_vector(NROF_CONN-1 downto 0);
        FIRST_EDGE_FOUND    : out   std_logic_vector(NROF_CONN-1 downto 0);
        SECOND_EDGE_FOUND   : out   std_logic_vector(NROF_CONN-1 downto 0);
        NROF_RETRIES        : out   std_logic_vector((16*NROF_CONN)-1 downto 0);
        TAP_SETTING         : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
        BIT_WIDTH           : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
        WINDOW_WIDTH        : out   std_logic_vector((10*NROF_CONN)-1 downto 0);
        WORD_ALIGN          : out   std_logic_vector(NROF_CONN-1 downto 0);
        TIMEOUTONACK        : out   std_logic;

        -- to sync
        REQ                 : out   std_logic;
        ACK                 : in    std_logic;

        CTRL_SEL            : out   std_logic_vector(15 downto 0);

        CTRL_RESET          : out   std_logic;
        CTRL_INC            : out   std_logic;
        CTRL_CE             : out   std_logic;

        CTRL_BITSLIP        : out   std_logic;

        CTRL_DATA           : in    std_logic_vector(DATAWIDTH-1 downto 0);

        CTRL_SAMPLEINFIRSTBIT   : out    std_logic_vector(NROF_CONN-1 downto 0);
        CTRL_SAMPLEINLASTBIT    : out    std_logic_vector(NROF_CONN-1 downto 0);
        CTRL_SAMPLEINOTHERBIT   : out    std_logic_vector(NROF_CONN-1 downto 0);

        CTRL_FIFO_RESET     : out   std_logic
       );

end iserdes_control;

architecture rtl of iserdes_control is

type handshakestatetp is (  Idle,
                            WaitAckHigh,
                            WaitAckLow
                            );

signal handshakestate : handshakestatetp;

type serdesseqstatetp is (  --ResetFifo,
                            Idle,
                            TrainSerdes,
                            WaitTrainSerdesBusyOn,
                            WaitTrainSerdesBusyOff
                            );

signal serdesseqstate : serdesseqstatetp;


type alignstatetp is (      Idle,
                            Reset_Delay,
                            Wait_Reset_Delay,
                            Get_Edge,
                            Check_Edge,
                            Wait_Sample_Stable,
                            Compare_Training,
                            Valid_Begin_Found,
                            CheckFirstEdgeChanged,
                            CheckFirstEdgeStable,
                            CheckSecondEdgeChanged,
                            WindowFound,
                            Reset_Delay_Man,
                            Start_Word_Align,
                            Do_Word_Align,
                            Alignment_Done
                            );

signal alignstate : alignstatetp;

signal edge_int             : std_logic_vector(DATAWIDTH-1 downto 0);
signal edge_init            : std_logic_vector(DATAWIDTH-1 downto 0);
signal data_init            : std_logic_vector(DATAWIDTH-1 downto 0);

signal edge_int_or          : std_logic;

type comparetp is array (0 to DATAWIDTH-1) of std_logic_vector(DATAWIDTH-1 downto 0);
signal compare              : comparetp;

signal Maxcount             : std_logic_vector(10 downto 0);
signal tapcount             : std_logic_vector(9 downto 0);
signal windowcount          : std_logic_vector(9 downto 0);
signal bitcount             : std_logic_vector(9 downto 0);

signal start_align_i        : std_logic;
signal done_align_i         : std_logic;
signal busy_align_i         : std_logic;
signal SerdesCntr           : std_logic_vector(15 downto 0);
signal selector             : std_logic_vector(15 downto 0);

signal CTRL_SAMPLEINFIRSTBIT_i   : std_logic; 
signal CTRL_SAMPLEINLASTBIT_i    : std_logic; 
signal CTRL_SAMPLEINOTHERBIT_i   : std_logic; 

signal start_handshake      : std_logic;
signal end_handshake        : std_logic;

signal retrycntr            : std_logic_vector(15 downto 0);
signal retries              : std_logic_vector(15 downto 0);
constant retry_count_load   : std_logic_vector(15 downto 0) := std_logic_vector(TO_UNSIGNED((RETRY_MAX-2),(retrycntr'high+1)));

signal GenCntr              : std_logic_vector(15 downto 0);
constant StableCntrLoad     : std_logic_vector(GenCntr'high downto 0) := std_logic_vector(TO_UNSIGNED((STABLE_COUNT-2),(GenCntr'high+1)));

constant TimeOutCntrLd          : std_logic_vector(5 downto 0) := "011111" ;
signal TimeOutCntr              : std_logic_vector(5 downto 0);

begin

gen_edge_detect: for i in 0 to (DATAWIDTH-2) generate
edge_int(i) <= CTRL_DATA(i) xor CTRL_DATA(i+1);
end generate;
edge_int(DATAWIDTH-1) <= CTRL_DATA(0) xor CTRL_DATA(DATAWIDTH-1);

edgeprocess: process(CLOCK)
    variable edge_tmp : std_logic := '0';
begin
if (CLOCK'event and CLOCK = '1') then
    -- funny workaround to make OR-ing of parametrisable signals into one signal work
    if (start_handshake = '1') then
        edge_tmp := '0';
    else
        for i in 0 to DATAWIDTH-1 loop
            edge_tmp := edge_tmp or edge_int(i);
        end loop;
        edge_int_or <= edge_tmp;
    end if;

end if;
end process;

handshaker: process(RESET, CLOCK)
begin
if (RESET = '1') then
    REQ             <= '0';
    end_handshake   <= '0';
    handshakestate  <= Idle;
    TIMEOUTONACK    <= '0';
    TimeOutCntr     <= TimeOutCntrLd;

elsif (CLOCK'EVENT and CLOCK = '1') then

    -- defaults
    end_handshake   <= '0';

    case handshakestate is
        when Idle =>

            if ALIGN_START='1'then
                TIMEOUTONACK        <= '0';
                TimeOutCntr         <= TimeOutCntrLd;
            end if;

            if (start_handshake = '1') then
                REQ <= '1';
                handshakestate  <= WaitAckHigh;
            end if;

        when WaitAckHigh =>
            if (ACK = '1') then
                REQ <= '0';
                handshakestate      <= WaitAckLow;
                TimeOutCntr         <= TimeOutCntrLd;
            elsif(TimeOutCntr(TimeOutCntr'high) = '1') then
                TIMEOUTONACK        <=  '1';
                handshakestate      <= Idle;
                TimeOutCntr         <= TimeOutCntrLd;
                end_handshake       <= '1';
            else
                TimeOutCntr <= TimeOutCntr - '1' ;
            end if;


        when WaitAckLow =>
            if (ACK = '0') then
                end_handshake   <= '1';
                handshakestate  <= Idle;
                TimeOutCntr     <= TimeOutCntrLd;
            elsif(TimeOutCntr(TimeOutCntr'high) = '1') then
                TIMEOUTONACK    <=  '1';
                handshakestate  <= Idle;
                TimeOutCntr     <= TimeOutCntrLd;
                end_handshake   <= '1';
            else
                TimeOutCntr     <= TimeOutCntr - '1';
            end if;

        when others =>
            handshakestate  <= Idle;

    end case;

end if;
end process handshaker;


CTRL_SEL <= selector;

alignsequencer: process(RESET, CLOCK)
begin
if (RESET = '1') then
     selector       <= (others => '0');
     SerdesCntr     <= std_logic_vector(TO_SIGNED(3,(SerdesCntr'high+1)));

     ALIGN_BUSY     <= '0';
     ALIGNED        <= '0';

     start_align_i  <= '0';

     CTRL_FIFO_RESET <= '1';
     CTRL_SAMPLEINFIRSTBIT   <= (others => '0');   
     CTRL_SAMPLEINLASTBIT    <= (others => '0');   
     CTRL_SAMPLEINOTHERBIT   <= (others => '0');   

     serdesseqstate  <= Idle;

elsif (CLOCK'EVENT and CLOCK = '1') then

    start_align_i   <= '0';

    case serdesseqstate is

        when Idle =>
            --CTRL_FIFO_RESET <= '0';
            if (ALIGN_START = '1') then
                CTRL_FIFO_RESET <= '1';
                ALIGN_BUSY      <= '1';
                start_align_i   <= '1';
                SerdesCntr      <=  std_logic_vector(TO_SIGNED((NROF_CONN-2),(SerdesCntr'high+1)));
                selector        <= (others => '0');
                serdesseqstate  <= TrainSerdes;
            end if;

        when TrainSerdes =>
            serdesseqstate  <= WaitTrainSerdesBusyOn;

        when WaitTrainSerdesBusyOn =>
            if (busy_align_i = '1') then
                serdesseqstate  <= WaitTrainSerdesBusyOff;
            end if;

        when WaitTrainSerdesBusyOff =>
            if (busy_align_i = '0') then
                CTRL_SAMPLEINFIRSTBIT(TO_INTEGER(UNSIGNED(selector)))   <= CTRL_SAMPLEINFIRSTBIT_i;
                CTRL_SAMPLEINLASTBIT(TO_INTEGER(UNSIGNED(selector)))    <= CTRL_SAMPLEINLASTBIT_i;
                CTRL_SAMPLEINOTHERBIT(TO_INTEGER(UNSIGNED(selector)))   <= CTRL_SAMPLEINOTHERBIT_i;
                if (SerdesCntr(SerdesCntr'high) = '1') then
                    ALIGNED             <= '1';
                    ALIGN_BUSY          <= '0';
                    CTRL_FIFO_RESET     <= '0';
                    serdesseqstate      <= Idle;
                else
                    start_align_i   <= '1';
                    selector    <= selector + '1';
                    SerdesCntr  <= SerdesCntr - '1';
                    serdesseqstate  <= TrainSerdes;
                end if;
            end if;

        when others =>
            serdesseqstate  <= Idle;
    end case;
end if;
end process alignsequencer;

aligning: process(RESET, CLOCK)
variable index : integer range 0 to 65535;
begin
if (RESET = '1') then

    done_align_i    <= '0';
    busy_align_i    <= '0';

    CTRL_RESET          <= '1';
    CTRL_INC            <= '0';
    CTRL_CE             <= '0';
    CTRL_BITSLIP        <= '0';

    CTRL_SAMPLEINFIRSTBIT_i   <= '0';
    CTRL_SAMPLEINLASTBIT_i    <= '0';
    CTRL_SAMPLEINOTHERBIT_i   <= '0';

    edge_init           <= (others => '0');
    data_init           <= (others => '0');

    EDGE_DETECT         <= (others => '0');
    TRAINING_DETECT     <= (others => '0');
    STABLE_DETECT       <= (others => '0');
    FIRST_EDGE_FOUND    <= (others => '0');
    SECOND_EDGE_FOUND   <= (others => '0');
    WORD_ALIGN          <= (others => '0');
    NROF_RETRIES        <= (others => '0');
    TAP_SETTING         <= (others => '0');
    WINDOW_WIDTH        <= (others => '0');

    start_handshake <= '0';

    maxcount            <= (others => '1');
    tapcount            <= (others => '0');
    windowcount         <= (others => '0');
    bitcount            <= (others => '0');
    retries             <= (others => '0');

    compare             <= (others => (others => '0'));

    RetryCntr           <= (others => '1');
    GenCntr             <= (others => '1');

    index               := 0;
    alignstate <= Idle;

elsif (CLOCK'event and CLOCK = '1') then
    --defaults
    done_align_i    <= '0';
    start_handshake <= '0';

    index               := TO_INTEGER(UNSIGNED(selector));

    -- generate compare words
    -- the 2 last versions will be the 'special' words that when stable sampling
    -- occurs on both of them the resulting parallel words will be skewed.
    -- In this case the data written into the FIFO has to be compensated for the skew
    --
    for i in 0 to (DATAWIDTH-1) loop
        compare(i) <= STD_LOGIC_VECTOR(UNSIGNED(TRAINING) ROL (i+6));
    end loop;

    case alignstate is
        when Idle =>
            busy_align_i    <= '0';
            if (start_align_i = '1') then
                 busy_align_i    <= '1';
                --reset status words
                 EDGE_DETECT(index)         <= '0';
                 TRAINING_DETECT(index)     <= '0';
                 STABLE_DETECT(index)       <= '0';
                 FIRST_EDGE_FOUND(index)    <= '0';
                 SECOND_EDGE_FOUND(index)   <= '0';
                 WORD_ALIGN(index)          <= '0';
                 NROF_RETRIES((16*index)+15 downto 16*index)    <= (others => '0');
                 TAP_SETTING((10*index)+9 downto 10*index)      <= (others => '0');
                 WINDOW_WIDTH((10*index)+9 downto 10*index)     <= (others => '0');

                 tapcount            <= (others => '0');
                 windowcount         <= (others => '0');
                 bitcount            <= (others => '0');
                 Maxcount            <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-1),(Maxcount'high+1)));
                 retries             <= (others => '0');
                 RetryCntr           <= retry_count_load;

                if (AUTOALIGN = '1') then -- use training algorithm
                    CTRL_RESET      <= '1';
                    CTRL_INC        <= '0';
                    CTRL_CE         <= '0';
                    start_handshake <= '1';
                    CTRL_SAMPLEINFIRSTBIT_i   <= '0';
                    CTRL_SAMPLEINLASTBIT_i    <= '0';
                    CTRL_SAMPLEINOTHERBIT_i   <= '0';
                    alignstate      <= Reset_Delay;
                else                      -- manually set tapcount
                    start_handshake <= '1';
                    CTRL_RESET      <= '1';
                    CTRL_INC        <= '0';
                    CTRL_CE         <= '0';
                    GenCntr         <= "000000" & MANUAL_TAP;
                    CTRL_SAMPLEINFIRSTBIT_i   <= '0';
                    CTRL_SAMPLEINLASTBIT_i    <= '0';
                    CTRL_SAMPLEINOTHERBIT_i   <= '0';
                    alignstate      <= Reset_Delay_Man;
                end if;
            end if;

        when Reset_Delay =>
            GenCntr         <= std_logic_vector(TO_UNSIGNED((STABLE_COUNT-1),(GenCntr'high+1)));
            if (end_handshake = '1') then
               alignstate       <= Wait_Reset_Delay;
            end if;

        when Wait_Reset_Delay =>
            start_handshake     <= '1';
            --do nothing
            CTRL_RESET          <= '0';
            CTRL_INC            <= '0';
            CTRL_CE             <= '0';
            alignstate          <= Get_Edge;

        when Get_Edge =>
            if (end_handshake = '1') then
                EDGE_DETECT(index)   <= edge_int_or;
                alignstate           <= Check_Edge;
            end if;

        when Check_Edge =>
            if (RetryCntr(RetryCntr'high) = '1') then -- no stable edge found within retry limit
                NROF_RETRIES((16*index)+15 downto 16*index)    <= retries;
                TAP_SETTING((10*index)+9 downto 10*index)      <= tapcount;
                alignstate   <= Idle;
            else
                RetryCntr  <= RetryCntr - '1';
                if (edge_int_or = '1') then             -- edge found, check stability
                    DATA_init       <= CTRL_DATA;       -- memorize data
                    edge_init       <= edge_int;        -- memorize data edges
                    start_handshake <= '1';
                    --do nothing
                    CTRL_RESET      <= '0';
                    CTRL_INC        <= '0';
                    CTRL_CE         <= '0';
                    alignstate      <= Wait_Sample_Stable;
                else
                    start_handshake <= '1';    -- no edge found but retrylimit not yet reached, increment tap and try again
                    if (Maxcount(Maxcount'high) = '1') then
                            retries         <= retries + '1';
                            RetryCntr       <= RetryCntr - '1';
                            tapcount        <= (others => '0');
                            CTRL_RESET      <= '1';
                            CTRL_INC        <= '0';
                            CTRL_CE         <= '0';
                            Maxcount        <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-1),(Maxcount'high+1)));
                            alignstate      <= Reset_Delay;
                    else
                            retries         <= retries + '1';
                            RetryCntr       <= RetryCntr - '1';
                            tapcount        <= tapcount + '1';
                            Maxcount        <= Maxcount - '1';
                            CTRL_RESET      <= '0';
                            CTRL_INC        <= '1';
                            CTRL_CE         <= '1';
                            alignstate      <= Get_Edge;
                    end if;
                end if;
            end if;

        when Wait_Sample_Stable =>
            if (end_handshake = '1') then
                if (GenCntr(GenCntr'high) = '1') then  -- sampled x times the same edge data
                    STABLE_DETECT(index)   <= '1';
                    GenCntr                   <= std_logic_vector(TO_UNSIGNED((DATAWIDTH-1),(GenCntr'high+1)));      --recycle stablecounter for compare purposes
                    alignstate                <= Compare_Training;
                else
                   if (edge_init /= edge_int) then     -- data not the same, increment tab and try again
                        start_handshake <= '1';
                        retries               <= retries + '1';
                        RetryCntr             <= RetryCntr - '1';
                        if (Maxcount(Maxcount'high) = '1') then
                            tapcount              <= (others => '0');
                            CTRL_RESET            <= '1';
                            CTRL_INC              <= '0';
                            CTRL_CE               <= '0';
                            Maxcount              <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-1),(Maxcount'high+1)));
                            alignstate            <= Reset_Delay;
                        else
                            tapcount              <= tapcount + '1';
                            Maxcount              <= Maxcount - '1';
                            CTRL_RESET            <= '0';
                            CTRL_INC              <= '1';
                            CTRL_CE               <= '1';
                            GenCntr               <= StableCntrLoad;
                            alignstate            <= Get_Edge;
                        end if;
                    else
                        GenCntr               <= GenCntr - '1';
                        CTRL_RESET            <= '0';
                        CTRL_INC              <= '0';
                        CTRL_CE               <= '0';
                        start_handshake       <= '1';
                    end if;
                end if;
            end if;


        -- the data detected as 'stable' in the previous state should be the training word.
        -- therefore no new data is 'grabbed' from the serdes module

        when Compare_Training =>
            if (GenCntr(GenCntr'high) = '1') then
               start_handshake       <= '1';
               if (Maxcount(Maxcount'high) = '1') then
                    tapcount              <= (others => '0');
                    CTRL_RESET            <= '1';
                    CTRL_INC              <= '0';
                    CTRL_CE               <= '0';
                    Maxcount              <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-1),(Maxcount'high+1)));
                    alignstate            <= Reset_Delay;
               else
                    retries               <= retries + '1';
                    RetryCntr             <= RetryCntr - '1';
                    tapcount              <= tapcount + '1';
                    Maxcount              <= Maxcount - '1';
                    CTRL_RESET            <= '0';
                    CTRL_INC              <= '1';
                    CTRL_CE               <= '1';
                    GenCntr               <= StableCntrLoad;
                    alignstate            <= Get_Edge;
              end if;
            else
                if (CTRL_DATA = compare(TO_INTEGER(UNSIGNED(GenCntr)))) then
                    TRAINING_DETECT(index)   <= '1';

                    if (GenCntr = DATAWIDTH-1) then
                        CTRL_SAMPLEINFIRSTBIT_i <= '0';
                        CTRL_SAMPLEINLASTBIT_i  <= '1';
                        CTRL_SAMPLEINOTHERBIT_i <= '0';
                    elsif (GenCntr = DATAWIDTH-2) then
                        CTRL_SAMPLEINFIRSTBIT_i <= '1';
                        CTRL_SAMPLEINLASTBIT_i  <= '0';
                        CTRL_SAMPLEINOTHERBIT_i <= '0';
                    else
                        CTRL_SAMPLEINFIRSTBIT_i <= '0';
                        CTRL_SAMPLEINLASTBIT_i  <= '0';
                        CTRL_SAMPLEINOTHERBIT_i <= '1';
                    end if;

                    alignstate               <= Valid_Begin_Found;
                end if;
                GenCntr             <= GenCntr - '1';
            end if;

        when Valid_Begin_Found =>
            start_handshake <= '1';
            Maxcount        <= Maxcount - '1';
            tapcount        <= tapcount + '1';
            CTRL_RESET      <= '0';
            CTRL_INC        <= '1';
            CTRL_CE         <= '1';
            alignstate      <= CheckFirstEdgeChanged;

        when CheckFirstEdgeChanged =>
            if (end_handshake = '1') then
                IF (
                    ((CTRL_DATA = STD_LOGIC_VECTOR(UNSIGNED(DATA_init) ROR 1)) and (INVERSE_BITORDER = FALSE)) or
                    ((CTRL_DATA = STD_LOGIC_VECTOR(UNSIGNED(DATA_init) ROL 1)) and (INVERSE_BITORDER = TRUE))
                        ) THEN  --edge found (1 time)
                    start_handshake <= '1';
                    CTRL_RESET      <= '0';
                    CTRL_INC        <= '0';
                    CTRL_CE         <= '0';
                    GenCntr         <= std_logic_vector(TO_UNSIGNED((STABLE_COUNT-1),(GenCntr'high+1)));
                    alignstate      <= CheckFirstEdgeStable;
                else
                    start_handshake <= '1';
                    if (Maxcount(Maxcount'high) = '1') then
                        tapcount        <= (others => '0');
                        CTRL_RESET      <= '1';
                        CTRL_INC        <= '0';
                        CTRL_CE         <= '0';
                        Maxcount        <= std_logic_vector(TO_UNSIGNED((TAP_COUNT_MAX-1),(Maxcount'high+1)));
                        alignstate      <= Reset_Delay;
                    else
                        Maxcount        <= Maxcount - '1';
                        tapcount        <= tapcount + '1';
                        CTRL_RESET      <= '0';
                        CTRL_INC        <= '1';
                        CTRL_CE         <= '1';
                    end if;
                end if;
            end if;

        when CheckFirstEdgeStable =>
            if (end_handshake = '1') then
                start_handshake             <= '1';
                if (GenCntr(GenCntr'high) = '1') then -- edge detected ok
                    windowcount                 <= windowcount + '1';
                    bitcount                    <= bitcount + '1';
                    tapcount                    <= tapcount + '1';
                    Maxcount                    <= Maxcount - '1';
                    CTRL_RESET                  <= '0';
                    CTRL_INC                    <= '1';
                    CTRL_CE                     <= '1';
                    FIRST_EDGE_FOUND(index)     <= '1';
                    alignstate                  <= CheckSecondEdgeChanged;
                else
                    GenCntr                     <= GenCntr - '1';
                    IF (
                    ((CTRL_DATA = STD_LOGIC_VECTOR(UNSIGNED(DATA_init) ROR 1)) and (INVERSE_BITORDER = FALSE)) or
                    ((CTRL_DATA = STD_LOGIC_VECTOR(UNSIGNED(DATA_init) ROL 1)) and (INVERSE_BITORDER = TRUE))
                        ) THEN
                        CTRL_RESET          <= '0';
                        CTRL_INC            <= '0';
                        CTRL_CE             <= '0';
                    else -- edge changed during stability test
                        GenCntr             <= std_logic_vector(TO_UNSIGNED((STABLE_COUNT-1),(GenCntr'high+1)));
                        tapcount            <= tapcount + '1'; -- increment tapcount by one and try again
                        bitcount            <= bitcount + '1';
                        Maxcount            <= Maxcount - '1';
                        CTRL_RESET          <= '0';
                        CTRL_INC            <= '1';
                        CTRL_CE             <= '1';
                        alignstate          <= CheckFirstEdgeChanged;
                    end if;
                end if;
            end if;

        when CheckSecondEdgeChanged =>
            if (end_handshake = '1') then
                IF (
                    ((CTRL_DATA = STD_LOGIC_VECTOR(UNSIGNED(DATA_init) ROR 2)) and (INVERSE_BITORDER = FALSE)) or
                    ((CTRL_DATA = STD_LOGIC_VECTOR(UNSIGNED(DATA_init) ROL 2)) and (INVERSE_BITORDER = TRUE))
                        ) THEN   -- 2nd edge found, window found
                    SECOND_EDGE_FOUND(index)                      <= '1';
                    WINDOW_WIDTH((10*index)+9 downto 10*index) <= windowcount;
                    BIT_WIDTH((10*index)+9 downto 10*index) <= bitcount;
                    GenCntr             <= ("0000000" & windowcount(9 downto 1)) - "10"; --divide by 2
                    start_handshake     <= '1';
                    tapcount            <= tapcount - '1';
                    CTRL_RESET          <= '0';
                    CTRL_INC            <= '0';
                    CTRL_CE             <= '1';
                    alignstate          <= WindowFound;
                else
                        start_handshake <= '1';
                        if (Maxcount(Maxcount'high) = '1') then  --overrun tapcount
                            CTRL_RESET      <= '1';
                            CTRL_INC        <= '0';
                            CTRL_CE         <= '0';
                            alignstate   <= Reset_Delay;
                        else
                            windowcount     <= windowcount + '1';
                            bitcount        <= bitcount + '1';
                            Maxcount        <= Maxcount - '1';
                            tapcount        <= tapcount + '1';
                            CTRL_RESET      <= '0';
                            CTRL_INC        <= '1';
                            CTRL_CE         <= '1';
                        end if;
                end if;
            end if;

        when WindowFound =>
            if (end_handshake = '1') then
                if (GenCntr(GenCntr'high) = '1') then
                   --TAP_SETTING((10*index)+9 downto 10*index)      <= tapcount;
                   alignstate   <= Start_Word_Align;
                else
                   start_handshake     <= '1';
                   tapcount            <= tapcount - '1';
                   GenCntr             <= GenCntr - '1';
                   CTRL_RESET          <= '0';
                   CTRL_INC            <= '0';
                   CTRL_CE             <= '1';
                end if;
            end if;

        when Reset_Delay_Man =>
            if (end_handshake = '1') then
               if (GenCntr(GenCntr'high) = '1') then
                   alignstate          <= Start_Word_Align;
                   --TAP_SETTING((10*index)+9 downto 10*index)      <= tapcount;
               else
                   GenCntr             <= GenCntr - '1';
                   start_handshake     <= '1';
                   tapcount            <= tapcount + '1';
                   CTRL_RESET          <= '0';
                   CTRL_INC            <= '1';
                   CTRL_CE             <= '1';
               end if;
            end if;

-- wordalignment, can fail in manual tap mode, or when bitalign algorithm fails

        when Start_Word_Align =>
            if (CTRL_DATA = TRAINING) then
                WORD_ALIGN(index)   <= '1';
                alignstate          <= Alignment_Done;
            else
                start_handshake     <= '1';
                GenCntr             <= std_logic_vector(TO_UNSIGNED((DATAWIDTH-2),(GenCntr'high+1)));
                CTRL_RESET          <= '0';
                CTRL_INC            <= '0';
                CTRL_CE             <= '0';
                CTRL_BITSLIP        <= '1';
                alignstate          <= Do_Word_Align;
            end if;

        when Do_Word_Align =>
            if (end_handshake = '1') then
                if (CTRL_DATA = TRAINING) then
                    WORD_ALIGN(index)   <= '1';
                    alignstate          <= Alignment_Done;
                else
                    if (GenCntr(GenCntr'high) = '1') then --alignment failed
                        TAP_SETTING((10*index)+9 downto 10*index)      <= tapcount;
                        NROF_RETRIES((16*index)+15 downto 16*index)    <= retries;
                        alignstate      <= Idle;
                    else
                        start_handshake <= '1';
                        CTRL_BITSLIP    <= '1';
                        GenCntr             <= GenCntr - '1';
                    end if;
                end if;
            end if;

        when Alignment_Done =>
            done_align_i        <= '1';
            CTRL_RESET          <= '0';
            CTRL_INC            <= '0';
            CTRL_CE             <= '0';
            CTRL_BITSLIP        <= '0';
            NROF_RETRIES((16*index)+15 downto 16*index)    <= retries;
            TAP_SETTING((10*index)+9 downto 10*index)      <= tapcount;
            alignstate          <= Idle;

        when others =>
            alignstate   <= Idle;

    end case;
end if;
end process;

end rtl;