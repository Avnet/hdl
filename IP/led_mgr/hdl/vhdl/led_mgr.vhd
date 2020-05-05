----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/13/2016 11:42:02 AM
-- Design Name: 
-- Module Name: microphone_mgr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;  

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_mgr is
    Port ( clk_in : in STD_LOGIC;
           resetn_in : in STD_LOGIC;
           -- AXI GPIO interface from Zynq: 
           GPIO_from_Zynq       : in STD_LOGIC_VECTOR (7 downto 0);
           GPIO_to_Zynq         : out STD_LOGIC_VECTOR (7 downto 0);
           GPIO_dir             : in STD_LOGIC_VECTOR (7 downto 0);
           CPU_PL_LED_G          : in STD_LOGIC_VECTOR (0 downto 0);
           CPU_PL_LED_R          : in STD_LOGIC_VECTOR (0 downto 0);
           --PL_SW                : in STD_LOGIC_VECTOR (0 downto 0);

           USER_TRIGGER : out STD_LOGIC;
           --AUDIO_CLK : out STD_LOGIC;
           --AUDIO_DAT : in STD_LOGIC;
           --DSP_CLK : out STD_LOGIC;
           PL_LED_G : out STD_LOGIC;
           PL_LED_R : out STD_LOGIC;
           --DSP_DAT : out STD_LOGIC_VECTOR(1 downto 0);
           AUDIO_RAW : in STD_LOGIC_VECTOR(15 downto 0)
           --AUDIO_RAW : in STD_LOGIC_VECTOR(19 downto 0)
           );
end led_mgr;

architecture Behavioral of led_mgr is

    signal counter      : std_logic_vector(7 downto 0);

begin
    process(resetn_in,clk_in)
    variable vCount : unsigned(7 downto 0);
    begin
        if (resetn_in = '0') then
            vCount := (others => '0');
         elsif rising_edge(clk_in) then
            vCount := vCount + 1;
            counter    <= std_logic_vector(vCount);
        end if;
    end process;

--Assign the outputs:
    --AUDIO_CLK <= clk_in;
    --DSP_CLK <= clk_in;
    --The DSP block has 2's complement input, so we only use the LSB:
    --DSP_DAT(1) <= '0';
    --DSP_DAT(0) <= AUDIO_DAT;

    GPIO_to_Zynq <= (others => 'Z');

    USER_TRIGGER <= GPIO_from_Zynq(0); 

    process(resetn_in,clk_in)
    --variable vAudio : unsigned(15 downto 0);
--    variable vAudio : unsigned(19 downto 0);
--    variable vAudio : signed(19 downto 0);
    variable vAudio : signed(15 downto 0);
    variable mic_led_g    : std_logic;
    variable mic_led_r    : std_logic;
    begin
        vAudio := signed(AUDIO_RAW);
--        if (vAudio > X"0B80") then
        if (vAudio > 1000) then
            --LED = Red
            mic_led_g := '0';
            mic_led_r := '1';
        --elsif (vAudio > X"0B20") then
        elsif (vAudio > 500) then
            --LED = Yellow
            mic_led_g := '1';
            mic_led_r := '1';
--            elsif (vAudio > X"0A80") then
            elsif (vAudio > 50) then
                --LED = Green
                mic_led_g := '1';
                mic_led_r := '0';
            else
                --LED = Off
                mic_led_g := '0';
                mic_led_r := '0';
            end if;
            --if (PL_SW(0) = '1') then
            if (GPIO_from_Zynq(1) = '0') then
                PL_LED_G <= mic_led_g;
                PL_LED_R <= mic_led_r;
            else
                --PL_LED_G <= CPU_PL_LEDs(1);
                --PL_LED_R <= CPU_PL_LEDs(0);
                PL_LED_G <= CPU_PL_LED_G(0);
                PL_LED_R <= CPU_PL_LED_R(0);
            end if;        
    end process;

end Behavioral;
