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
-- Date           : $Date: 2010-06-21 18:22:42 +0200 (ma, 21 jun 2010) $
-- Revision       : $Revision: 391 $
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
--unisim:
-----------
Library UNISIM;
use UNISIM.vcomponents.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity correct_column_fpn_prnu_dsp48e is
  generic (
        NROF_DATACONN       : integer;
        DATAWIDTH           : integer;
        ENABLECORRECT       : boolean;
        C_FAMILY            : string    := "virtex6"
  );
  port (
        -- Control signals
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;
        CorrectValues       : in    std_logic_vector((NROF_DATACONN*4*16)-1 downto 0);

        WR_DATA_in          : in    std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);
        WR_NEXT_in          : in    std_logic;
        WR_FRAME_in         : in    std_logic;
        WR_LINE_in          : in    std_logic;
        WR_WINDOW_in        : in    std_logic;

        WR_DATA_out         : out   std_logic_vector((NROF_DATACONN*DATAWIDTH)-1 downto 0);
        WR_NEXT_out         : out   std_logic;
        WR_FRAME_out        : out   std_logic;
        WR_LINE_out         : out   std_logic;
        WR_WINDOW_out       : out   std_logic;

        VIDEO_SYNC_IN       : in    std_logic_vector(4 downto 0);
        VIDEO_SYNC_OUT      : out   std_logic_vector(4 downto 0)
  );
end correct_column_fpn_prnu_dsp48e;

---------------------------
-- BEHAVIOUR DESCRIPTION --
---------------------------
architecture rtl of correct_column_fpn_prnu_dsp48e is

type CorrectBlockArrayTp is array (NROF_DATACONN-1 downto 0) of std_logic_vector(7 downto 0);

signal CorrectBlockOffset: CorrectBlockArrayTp;
signal CorrectBlockGain: CorrectBlockArrayTp;

type RegArrayTp is array ((NROF_DATACONN*4)-1 downto 0) of std_logic_vector(15 downto 0);
signal RegArray : RegArrayTp;

type DelayPipeTp is array (3 downto 0) of std_logic_vector(8 downto 0);
signal DelayPipe : DelayPipeTp;

signal index : integer range 0 to 3;

type AArrayTp is array (0 to NROF_DATACONN-1) of std_logic_vector(29 downto 0);
type BArrayTp is array (0 to NROF_DATACONN-1) of std_logic_vector(17 downto 0);
type CArrayTp is array (0 to NROF_DATACONN-1) of std_logic_vector(47 downto 0);
type PArrayTp is array (0 to NROF_DATACONN-1) of std_logic_vector(47 downto 0);

signal A : AArrayTp;
signal B : BArrayTp;
signal C : CArrayTp;
signal P : PArrayTp;

signal overflow            : std_logic_vector(NROF_DATACONN-1 downto 0);
signal underflow           : std_logic_vector(NROF_DATACONN-1 downto 0);

constant zero              : std_logic := '0';
constant zeros             : std_logic_vector(47 downto 0) := X"000000000000";
constant one               : std_logic := '1';
constant ones              : std_logic_vector(47 downto 0) := X"FFFFFFFFFFFF";

constant ALUMODE           : std_logic_vector(3 downto 0) := "0001";
-- use: (ALUMODE = 0001)
-- -Z + (X + Y + CARRYIN) – 1 =
-- not (Z) + X + Y + CARRYIN
-- with CARRYIN = 1 to compensate for the extra - 1

-- alternatively use:  (ALUMODE = 0000)
-- Z + X + Y + CARRYIN
-- with Z as a negative number in 2s complement form

--                                                            6543210
constant OPMODE            : std_logic_vector(6 downto 0) := "0110101";
--with ALUMODE = 0001
-- X = M (partial product 1)
-- Y = M (partial product 2)
-- Z = C
constant RST_SYNC_NUM : integer := 16;
signal rstdsp_sync_r : std_logic_vector(RST_SYNC_NUM-1 downto 0);
signal rst_dsp : std_logic;

--signal DATA_DSP : std_logic_vector((NROF_DATACONN*DATAWIDTH)+1 downto 0);  --2 bits more than required for under/overflow detection

-- for debug...
-- remapped
alias Channel0  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_in((0*DATAWIDTH)+(DATAWIDTH-1) downto (0*DATAWIDTH));
--alias Channel1  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_remapper((1*DATAWIDTH)+(DATAWIDTH-1) downto (1*DATAWIDTH));
--alias Channel2  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_remapper((2*DATAWIDTH)+(DATAWIDTH-1) downto (2*DATAWIDTH));
--alias Channel3  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_remapper((3*DATAWIDTH)+(DATAWIDTH-1) downto (3*DATAWIDTH));
--alias Channel4  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_remapper((4*DATAWIDTH)+(DATAWIDTH-1) downto (4*DATAWIDTH));
--alias Channel5  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_remapper((5*DATAWIDTH)+(DATAWIDTH-1) downto (5*DATAWIDTH));
--alias Channel6  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_remapper((6*DATAWIDTH)+(DATAWIDTH-1) downto (6*DATAWIDTH));
--alias Channel7  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_remapper((7*DATAWIDTH)+(DATAWIDTH-1) downto (7*DATAWIDTH));

-- corrected
alias CorrChannel0  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_out((0*DATAWIDTH)+(DATAWIDTH-1) downto (0*DATAWIDTH));
--alias CorrChannel1  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_corrected((1*DATAWIDTH)+(DATAWIDTH-1) downto (1*DATAWIDTH));
--alias CorrChannel2  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_corrected((2*DATAWIDTH)+(DATAWIDTH-1) downto (2*DATAWIDTH));
--alias CorrChannel3  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_corrected((3*DATAWIDTH)+(DATAWIDTH-1) downto (3*DATAWIDTH));
--alias CorrChannel4  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_corrected((4*DATAWIDTH)+(DATAWIDTH-1) downto (4*DATAWIDTH));
--alias CorrChannel5  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_corrected((5*DATAWIDTH)+(DATAWIDTH-1) downto (5*DATAWIDTH));
--alias CorrChannel6  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_corrected((6*DATAWIDTH)+(DATAWIDTH-1) downto (6*DATAWIDTH));
--alias CorrChannel7  : std_logic_vector(DATAWIDTH-1 downto 0) is WR_DATA_corrected((7*DATAWIDTH)+(DATAWIDTH-1) downto (7*DATAWIDTH));

begin

gen_no_correction: if (ENABLECORRECT = FALSE) generate

    WR_DATA_out   <= WR_DATA_in;
    WR_NEXT_out   <= WR_NEXT_in;
    WR_FRAME_out  <= WR_FRAME_in;
    WR_LINE_out   <= WR_LINE_in;
    WR_WINDOW_out <= WR_WINDOW_in;
    --
    VIDEO_SYNC_OUT <= VIDEO_SYNC_IN;

end generate;

gen_correction: if (ENABLECORRECT = TRUE) generate

    -- make registerarray more easily addressable  
    gen_array: for i in 0 to (NROF_DATACONN*4)-1 generate
        RegArray(i) <= CorrectValues(((i+1)*16)-1 downto i*16);
    end generate;

-- DSP48E: DSP Function Block
-- Virtex-5
-- Xilinx HDL Libraries Guide, version 10.1.2

-- implementing (A*B)+C
gen_correct_blocks : for i in 0 to (NROF_DATACONN-1) generate

    --placed in low/LSB bits
    A(i)(29 downto 0) <=  "00000" & "000000000000000" & '0' & '1' & CorrectBlockGain(i)(7 downto 0);     --30 bits total of which 25 LSB bits go to multiplier
    B(i)(17 downto 0) <= zeros((16-DATAWIDTH) downto 0) & '0' & WR_DATA_in((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH));   --18 bits total, 1 bit sign, 10 bits padded with 7 0s
    --48 bits total, 1 bit sign, 10 bits padded with 37 0s
    C(i)(47) <= CorrectBlockOffset(i)(7); --sign bit
    gen_high_c_bits: for j in (26-DATAWIDTH) to 46 generate
    C(i)(j) <= CorrectBlockOffset(i)(7); -- unused bits high
    end generate;
    C(i)(25-DATAWIDTH downto 18-DATAWIDTH) <= CorrectBlockOffset(i)(7 downto 0); --actual offset
    C(i)(17-DATAWIDTH downto 0) <= zeros(17-DATAWIDTH downto 0); --low padding
    -- overflow/underflow detection still to implement
    --DATA_DSP((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH)) <= P(i)(39 downto (40-DATAWIDTH));

    Over_underflow_detect: process(RESET, CLOCK)
    begin
        if (RESET = '1') then
            --no reset
        elsif(CLOCK'event and CLOCK = '1') then
            if (P(i)(47) = '1') then --negative (= underflow)
                WR_DATA_out((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH))   <= (others => '0');
            elsif (P(i)(18) = '1') then --positive (=overflow)
                WR_DATA_out((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH))   <= (others => '1');
            else
                WR_DATA_out((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH))   <= P(i)(17 downto (18-DATAWIDTH));
            end if;
        end if;
    end process;


    ----placed in high/MSB bits
    --A(i)(29 downto 0) <=  "00000" & '0' & CorrectBlockGain(i)(15 downto 0) & "00000000";     --30 bits total of which 25 LSB bits go to multiplier: 5 unused bits, 1 bit sign (0), 16 bits padded with 8 0s
    --B(i)(17 downto 0) <= '0' & WR_DATA_remapper((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH)) & zeros((16-DATAWIDTH) downto 0) ;   --18 bits total, 1 bit sign, 10 bits padded with 7 0s
    ----48 bits total, 1 bit sign, 10 bits padded with 37 0s
    --C(i)(47) <= CorrectBlockOffset(i)(DATAWIDTH); --sign bit
    --C(i)(46 downto (47-DATAWIDTH)) <= CorrectBlockOffset(i)(DATAWIDTH-1 downto 0); --actual offset
    --C(i)((46-DATAWIDTH) downto 0) <= zeros((46-DATAWIDTH) downto 0); --low padding
    ---- overflow/underflow detection still to implement
    --WR_DATA_corrected((i*DATAWIDTH)+(DATAWIDTH-1) downto (i*DATAWIDTH)) <= P(i)(39 downto (40-DATAWIDTH));

    --Datapath (port B) should have one clk delay extra


    gen_correct_blocks_s6: if ( C_FAMILY = "spartan6" ) generate
      the_correct_block : DSP48A1
      generic map (
          A0REG           =>  1,
          A1REG           =>  1,
          B0REG           =>  1,
          B1REG           =>  1,
          CARRYINREG      =>  1,
          CARRYINSEL      =>  "OPMODE5",
          CARRYOUTREG     =>  1,
          CREG            =>  1,
          DREG            =>  1,
          MREG            =>  1,
          OPMODEREG       =>  1,
          PREG            =>  1,
          RSTTYPE         =>  "SYNC"
          )
      port map (
          BCOUT                   => open,
          CARRYOUT                => open,
          CARRYOUTF               => open,
          M                       => open,
          P                       => P(i),
          PCOUT                   => open,

          A                       => A(i)(17 downto 0),
          B                       => B(i),
          C                       => C(i),
          CARRYIN                 => zero,
          CEA                     => one,
          CEB                     => one,
          CEC                     => one,
          CECARRYIN               => one,
          CED                     => one,
          CEM                     => one,
          CEOPMODE                => one,
          CEP                     => one,
          CLK                     => CLOCK,
          D                       => zeros(17 downto 0),
          OPMODE                  => X"2D",
          PCIN                    => zeros(47 downto 0),
          RSTA                    => rst_dsp,
          RSTB                    => rst_dsp,
          RSTC                    => rst_dsp,
          RSTCARRYIN              => rst_dsp,
          RSTD                    => rst_dsp,
          RSTM                    => rst_dsp,
          RSTOPMODE               => rst_dsp,
          RSTP                    => rst_dsp
      );
    end generate;

    gen_correct_blocks_v5: if not ( C_FAMILY = "spartan6" ) generate
      the_correct_block : DSP48E
      generic map (
          ACASCREG                        => 0,               -- Number of pipeline registers between
                                                              -- A/ACIN input and ACOUT output, 0, 1, or 2
          ALUMODEREG                      => 0,               -- Number of pipeline registers on ALUMODE input, 0 or 1
          AREG                            => 0,               -- Number of pipeline registers on the A input, 0, 1 or 2
          AUTORESET_PATTERN_DETECT        => FALSE,           -- Auto-reset upon pattern detect, TRUE or FALSE
          AUTORESET_PATTERN_DETECT_OPTINV => "MATCH",         -- Reset if "MATCH" or "NOMATCH"
          A_INPUT                         => "DIRECT",        -- Selects A input used, "DIRECT" (A port) or "CASCADE" (ACIN port)
          BCASCREG                        => 2,               -- Number of pipeline registers between B/BCIN input and BCOUT output, 0, 1, or 2
          BREG                            => 2,               -- Number of pipeline registers on the B input, 0, 1 or 2
          B_INPUT                         => "DIRECT",        -- Selects B input used, "DIRECT" (B port) or "CASCADE" (BCIN port)
          CARRYINREG                      => 1,               -- Number of pipeline registers for the CARRYIN input, 0 or 1
          CARRYINSELREG                   => 1,               -- Number of pipeline registers for the CARRYINSEL input, 0 or 1
          CREG                            => 1,               -- Number of pipeline registers on the C input, 0 or 1
          MASK                            => X"3FFFFFFFFFFF", -- 48-bit Mask value for pattern detect
          MREG                            => 1,               -- Number of multiplier pipeline registers, 0 or 1
          MULTCARRYINREG                  => 0,               -- Number of pipeline registers for multiplier carry in bit, 0 or 1
          OPMODEREG                       => 1,               -- Number of pipeline registers on OPMODE input, 0 or 1
          PATTERN                         => X"000000000000", -- 48-bit Pattern match for pattern detect
          PREG                            => 1,               -- Number of pipeline registers on the P output, 0 or 1
          SIM_MODE                        => "SAFE",          -- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation
          -- Design Guide" for details
          SEL_MASK                        => "MASK",          -- Select mask value between the "MASK" value or the value on the "C" port
          SEL_PATTERN                     => "PATTERN",       -- Select pattern value between the "PATTERN" value or the value on the "C" port
          SEL_ROUNDING_MASK               => "SEL_MASK",      -- "SEL_MASK", "MODE1", "MODE2"
          USE_MULT                        => "MULT_S",        -- Select multiplier usage, "MULT" (MREG => 0),
                                                              -- "MULT_S" (MREG => 1), "NONE" (not using multiplier)
          USE_PATTERN_DETECT              => "PATDET",        -- Enable pattern detect, "PATDET", "NO_PATDET"
          USE_SIMD                        => "ONE48"          -- SIMD selection, "ONE48", "TWO24", "FOUR12"
          )
      port map (
          ACOUT               => open,                -- 30-bit A port cascade output
          BCOUT               => open,                -- 18-bit B port cascade output
          CARRYCASCOUT        => open,                -- 1-bit cascade carry output
          CARRYOUT            => open,                -- 4-bit carry output
          MULTSIGNOUT         => open,                -- 1-bit multiplier sign cascade output
          OVERFLOW            => overflow(i),         -- 1-bit overflow in add/acc output
          P                   => P(i),                -- 48-bit output
          PATTERNBDETECT      => open,                -- 1-bit active high pattern bar detect output
          PATTERNDETECT       => open,                -- 1-bit active high pattern detect output
          PCOUT               => open,                -- 48-bit cascade output
          UNDERFLOW           => underflow(i),        -- 1-bit active high underflow in add/acc output
          A                   => A(i),                -- 30-bit A data input
          ACIN                => zeros(29 downto 0),  -- 30-bit A cascade data input
          ALUMODE             => ALUMODE,             -- 4-bit ALU control input
          B                   => B(i),                -- 18-bit B data input
          BCIN                => zeros(17 downto 0),  -- 18-bit B cascade input
          C                   => C(i),                -- 48-bit C data input
          CARRYCASCIN         => zero,                -- 1-bit cascade carry input
          CARRYIN             => ALUMODE(0),          -- 1-bit carry input signal
          CARRYINSEL          => zeros(2 downto 0),   -- 3-bit carry select input
          CEA1                => one,                 -- 1-bit active high clock enable input for 1st stage A registers
          CEA2                => one,                 -- 1-bit active high clock enable input for 2nd stage A registers
          CEALUMODE           => one,                 -- 1-bit active high clock enable input for ALUMODE registers
          CEB1                => one,                 -- 1-bit active high clock enable input for 1st stage B registers
          CEB2                => one,                 -- 1-bit active high clock enable input for 2nd stage B registers
          CEC                 => one,                 -- 1-bit active high clock enable input for C registers
          CECARRYIN           => one,                 -- 1-bit active high clock enable input for CARRYIN register
          CECTRL              => one,                 -- 1-bit active high clock enable input for OPMODE and carry registers
          CEM                 => one,                 -- 1-bit active high clock enable input for multiplier registers
          CEMULTCARRYIN       => one,                 -- 1-bit active high clock enable for multiplier carry in register
          CEP                 => one,                 -- 1-bit active high clock enable input for P registers
          CLK                 => CLOCK,               -- Clock input
          MULTSIGNIN          => zero,                -- 1-bit multiplier sign input
          OPMODE              => OPMODE,              -- 7-bit operation mode input
          PCIN                => zeros(47 downto 0),  -- 48-bit P cascade input
          RSTA                => rst_dsp,             -- 1-bit reset input for A pipeline registers
          RSTALLCARRYIN       => rst_dsp,             -- 1-bit reset input for carry pipeline registers
          RSTALUMODE          => rst_dsp,             -- 1-bit reset input for ALUMODE pipeline registers
          RSTB                => rst_dsp,             -- 1-bit reset input for B pipeline registers
          RSTC                => rst_dsp,             -- 1-bit reset input for C pipeline registers
          RSTCTRL             => rst_dsp,             -- 1-bit reset input for OPMODE pipeline registers
          RSTM                => rst_dsp,             -- 1-bit reset input for multiplier registers
          RSTP                => rst_dsp              -- 1-bit reset input for P pipeline registers
      );
    end generate;
end generate;

    CorrectMultiplexer: process(RESET, CLOCK)
    begin
        if (RESET = '1') then
            index   <= 3;

            --DATA_IN <= (others => '0');

            for i in 0 to (NROF_DATACONN-1) loop
                CorrectBlockGain(i)     <= X"00";
                CorrectBlockOffset(i)   <= (others => '0');
            end loop;

        elsif(CLOCK'event and CLOCK = '1') then

            for i in 0 to (NROF_DATACONN-1) loop
                CorrectBlockGain(i)     <= RegArray(i+(index*NROF_DATACONN))(7 downto 0);
                CorrectBlockOffset(i)   <= RegArray(i+(index*NROF_DATACONN))(15 downto 8);
            end loop;

            --WR_DATA_remapper_r <= WR_DATA_remapper;
            --DATA_IN <= WR_DATA_remapper_r;

            if (WR_NEXT_in = '1') then
                if (WR_LINE_in = '1') then -- start line, reset correction
                    index <= 0;
                else
                    if (index = 3) then
                        index <= 0;
                    else
                        index <= index + 1;
                    end if;
                end if;
            else
                -- do nothing
            end if;
        end if;

    end process;

    ValidDelayBlock: process(RESET, CLOCK)
    begin
        if (RESET = '1') then

            DelayPipe          <= (others => (others => '0'));
            WR_NEXT_out  <= '0';
            WR_FRAME_out <= '0';
            WR_LINE_out  <= '0';
            WR_WINDOW_out <= '0';
            --
            VIDEO_SYNC_OUT <= (others => '0');

        elsif(CLOCK'event and CLOCK = '1') then

            DelayPipe(0)(0) <= WR_NEXT_in;
            DelayPipe(0)(1) <= WR_FRAME_in;
            DelayPipe(0)(2) <= WR_LINE_in;
            DelayPipe(0)(3) <= WR_WINDOW_in;
            --
            DelayPipe(0)(8 downto 4) <= VIDEO_SYNC_IN;      

            for i in 0 to (DelayPipe'high-1)loop
                DelayPipe(i+1) <= DelayPipe(i);
            end loop;

            WR_NEXT_out   <= DelayPipe(DelayPipe'high)(0);
            WR_FRAME_out  <= DelayPipe(DelayPipe'high)(1);
            WR_LINE_out   <= DelayPipe(DelayPipe'high)(2);
            WR_WINDOW_out <= DelayPipe(DelayPipe'high)(3);
            --
            VIDEO_SYNC_OUT <= DelayPipe(DelayPipe'high)(8 downto 4);
        end if;

    end process;

end generate;

process (CLOCK, reset)
  begin
    if (reset = '1') then
      rstdsp_sync_r <= (others => '1');
    elsif (CLOCK = '1' and CLOCK'event) then
      rstdsp_sync_r <= rstdsp_sync_r(RST_SYNC_NUM-2 downto 0) & '0';
    end if;
  end process;

rst_dsp <= rstdsp_sync_r(RST_SYNC_NUM-1);

end rtl;




