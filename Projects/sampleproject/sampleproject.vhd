-- ----------------------------------------------------------------------------
--       _____
--      *     *
--     *____   *____
--    * *===*   *==*
--   *___*===*___**  AVNET
--        *======*
--         *====*
-- ----------------------------------------------------------------------------
-- 
--  This design is the property of Avnet.  Publication of this
--  design is not authorized without written consent from Avnet.
-- 
--  Please direct any questions or issues to the MicroZed Community Forums:
--      http://www.microzed.org
-- 
--  Disclaimer:
--     Avnet, Inc. makes no warranty for the use of this code or design.
--     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
--     any errors, which may appear in this code, nor does it make a commitment
--     to update the information contained herein. Avnet, Inc specifically
--     disclaims any implied warranties of fitness for a particular purpose.
--                      Copyright(c) 2014 Avnet, Inc.
--                              All rights reserved.
-- 
-- ----------------------------------------------------------------------------
-- 
--  Create Date:         December 02, 2014
--  Design Name:         
--  Module Name:         
--  Project Name:        
--  Target Devices:      
--  Hardware Boards:     MicroZed, IO Carrier
-- 
--  Tool versions:       Vivado 2014.4
-- 
--  Description:         sample project top (fails build)
-- 
--  Dependencies:        IP generation scripts or others
-- 
-- ----------------------------------------------------------------------------


-- library IEEE;
-- use IEEE.STD_LOGIC_1164.ALL;
-- 
-- -- Uncomment the following library declaration if using
-- -- arithmetic functions with Signed or Unsigned values
-- --use IEEE.NUMERIC_STD.ALL;
-- 
-- -- Uncomment the following library declaration if instantiating
-- -- any Xilinx leaf cells in this code.
-- --library UNISIM;
-- --use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.vcomponents.all;


entity master_sm_demo is
   Port ( 
      CLK_100MHZ     : in     STD_LOGIC;
      CLK_10MHZ      : out    STD_LOGIC;
      CLK_EN         : out    STD_LOGIC;  -- ENABLES IO Carrier 100Mhz PLL
      RESET_OUT      : out    STD_LOGIC;
      RESET_IN       : in     STD_LOGIC;

      USER_PB1       : in     STD_LOGIC;
      USER_PB2       : in     STD_LOGIC;
      USER_PB3       : in     STD_LOGIC;
      USER_PB4       : in     STD_LOGIC;
      DIP_SW1        : in     STD_LOGIC;
      DIP_SW2        : in     STD_LOGIC;
      DIP_SW3        : in     STD_LOGIC;
      DIP_SW4        : in     STD_LOGIC;
      SERVO_PWM      : out    STD_LOGIC;
      
      -- PMOD BUS COnnectors
      JA_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JA_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JA_PMOD_TRGO   : out    STD_LOGIC;
      JA_PMOD_TRGI   : in     STD_LOGIC;
      
      JB_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JB_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JB_PMOD_TRGO   : out    STD_LOGIC;
      JB_PMOD_TRGI   : in     STD_LOGIC;
      
      JC_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JC_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JC_PMOD_TRGO   : out    STD_LOGIC;
      JC_PMOD_TRGI   : in     STD_LOGIC;
      
      JD_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JD_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JD_PMOD_TRGO   : out    STD_LOGIC;
      JD_PMOD_TRGI   : in     STD_LOGIC;
      
      JE_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JE_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JE_PMOD_TRGO   : out    STD_LOGIC;
      JE_PMOD_TRGI   : in     STD_LOGIC;
      
      JF_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JF_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JF_PMOD_TRGO   : out    STD_LOGIC;
      JF_PMOD_TRGI   : in     STD_LOGIC;
      
      JG_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JG_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JG_PMOD_TRGO   : out    STD_LOGIC;
      JG_PMOD_TRGI   : in     STD_LOGIC;
      
      JK_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JK_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JK_PMOD_TRGO   : out    STD_LOGIC;
      JK_PMOD_TRGI   : in     STD_LOGIC;
      
      JY_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JY_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JY_PMOD_TRGO   : out    STD_LOGIC;
      JY_PMOD_TRGI   : in     STD_LOGIC;
      
      JZ_PMOD_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      JZ_PMOD_IN     : in     STD_LOGIC_VECTOR(31 downto 0);
      JZ_PMOD_TRGO   : out    STD_LOGIC;
      JZ_PMOD_TRGI   : in     STD_LOGIC;

      -- Bram interface
      ENABLE         : out    STD_LOGIC;
      DATA_OUT       : out    STD_LOGIC_VECTOR(31 downto 0);
      DATA_IN        : in     STD_LOGIC_VECTOR(31 downto 0);
      WRITE_ENABLE   : out    STD_LOGIC_VECTOR(3 downto 0);
      ADDRESS_OUT    : out    STD_LOGIC_VECTOR(31 downto 0);
      MEM_CLK        : out    STD_LOGIC;
      MEM_RST        : out    STD_LOGIC;

      LED_D1         : out    STD_LOGIC;
      LED_D2         : out    STD_LOGIC;
      LED_D3         : out    STD_LOGIC;
      LED_D4         : out    STD_LOGIC;
      LED_D5         : out    STD_LOGIC;
      LED_D6         : out    STD_LOGIC;
      LED_D7         : out    STD_LOGIC;
      LED_D8         : out    STD_LOGIC
      );
end master_sm_demo;

architecture Behavioral of master_sm_demo is

   attribute keep : string;  

   signal locked           : std_logic; -- Output from the DCM indicating component is locked on input clock
   signal clk_system_bufg  : std_logic;
   signal clk_system_bufg_5MHz  : std_logic;
   signal clk_system       : std_logic;
   signal clk_system_10MHz  : std_logic;
   signal clk_5MHz_counter : std_logic_vector(5 downto 0);
   signal debounce_clk     : std_logic;
   signal reset            : std_logic;
   signal clk_feedback     : std_logic;  -- Dummy net used for MMCM clock feedback requirement
   
--   component clk_wiz_0 is
--    Port (   
--      reset    : in  STD_LOGIC;
--      locked   : out STD_LOGIC;
--      
--      clk_in1  : in  STD_LOGIC;
--
--      clk_out1 : out STD_LOGIC;
--      clk_out2 : out STD_LOGIC
--      );
--   end component;

   -- SPI Signals
   signal jc_1_rx_data1       : std_logic_vector(7 downto 0);
   attribute KEEP of jc_1_rx_data1: signal is "true";  
   --signal jc_1_rx_data2       : std_logic_vector(7 downto 0);
   --signal jc_1_rx_data3       : std_logic_vector(7 downto 0);
   --signal jc_1_rx_data4       : std_logic_vector(7 downto 0);
   signal i_jc_1_rx_data1     : std_logic_vector(7 downto 0);
   --signal i_jc_1_rx_data2     : std_logic_vector(7 downto 0);
   --signal i_jc_1_rx_data3     : std_logic_vector(7 downto 0);
   --signal i_jc_1_rx_data4     : std_logic_vector(7 downto 0);
   signal i_jc_spi_cs_n       : std_logic_vector(7 downto 0);
   signal i_jc_1_start        : std_logic;
   signal i_jc_1_done_ack     : std_logic;
   signal i_jc_1_done         : std_logic;
   
   --DEL SIGNALS WHEN IN REAL CODE
   signal jc_1_start        : std_logic;
   signal read_jc_1         : std_logic;
   signal clk               : std_logic;
   
   TYPE state_machine IS (INIT, IDLE, PERFORM_READ, REGISTER_DATA); 
   SIGNAL  JC_1_SM     :  state_machine; 
   -- SPI Master logic
   COMPONENT spi_interface
      PORT (
         reset          :  IN    STD_LOGIC;                     -- Reset
         clk            :  IN    STD_LOGIC;                     -- Input Clock
         clkdiv         :  IN    STD_LOGIC_VECTOR(1 DOWNTO 0);  -- Clock Divider Sets 4,8,16,32

         -- CONTROLS Latched PER transaction
         tx_sel         :  IN    STD_LOGIC_VECTOR(1 downto 0);    -- Mode Bit (Future) & Transmit/Receive
                                                                  -- Bit 1: (Future don't care for now)
                                                                  -- When 1  Enables Mode Selection
                                                                     -- when bit 1 = 1 and bit 0 = 0 Full Duplex
                                                                     -- when bit 1 = 1 and bit 0 = 1 Bi-SPI (TX Line)(FUTURE)
                                                                  -- When 0 : Half Duplex
                                                                     -- Bit 0: Tr (1)/Rx (0)
         numb_bytes     :  IN    STD_LOGIC_VECTOR(1 downto 0); -- Number of Bytes for this transaction (Zero-based numbering)
         slave_sel      :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Slave Enable Mask Signals (Active High). (7 downto 1 Future for now X)
         start          :  IN    STD_LOGIC;                    -- Start Transaction (Disabled when Done = '1')
         done_ack       :  IN    STD_LOGIC;                    -- Done Ack, use to clear Done Bit
         done           :  OUT   STD_LOGIC;                    -- Transaction Is Complete, must be cleared before next
                                                                                           -- Transaction
         --tx_bit_order   :  IN    STD_LOGIC;                    -- 1: MSB first, 0: LSB first
         ss_polarity    :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Slave Select Polarity for ASSERTED State
         cpol_cpha      :  IN    STD_LOGIC_VECTOR(1 downto 0); -- Clock Polarity, Clock Phase
                                                               -- Mode   CPOL  CPHA
                                                               -- 0      0     0
                                                               -- 1      0     1
                                                               -- 2      1     0
                                                               -- 3      1     1
                                                               -- At CPOL=0 the base value of the clock is zero
                                                                  -- For CPHA=0, data are captured on the clock's rising edge 
                                                                  -- For CPHA=1, data are captured on the clock's falling edge
                                                               -- At CPOL=1 the base value of the clock is one (inversion of CPOL=0)
                                                                  -- For CPHA=0, data are captured on clock's falling edge
                                                                  -- For CPHA=1, data are captured on clock's rising edge
                              
         -- TX (INTERNAL) Latched PER transaction
         xmit_data1     :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Load In
         xmit_data2     :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Load In
         xmit_data3     :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Load In
         xmit_data4     :  IN    STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Load In
         
         -- RX (INTERNAL) Held Until done_ack
         recv_data1     :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Read Out
         recv_data2     :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Read Out
         recv_data3     :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Read Out
         recv_data4     :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data To Read Out
         
         -- INTERFACE
         ss_n           :  OUT   STD_LOGIC_VECTOR(7 DOWNTO 0); -- Slave Chip Select Signals (7 downto 1 Future, for now DNI)
         miso           :  IN    STD_LOGIC;                    -- Master In Slave Out
         mosi           :  OUT   STD_LOGIC;                    -- Master Out Slave In
         sck            :  OUT   STD_LOGIC                     -- S Clock Out
      );
   END COMPONENT;
   
   
   SIGNAL  JC_2_SM     :  state_machine; 
   SIGNAL  JD_1_SM     :  state_machine; 
   SIGNAL  JD_2_SM     :  state_machine; 
   SIGNAL  JE_1_SM     :  state_machine; 
   SIGNAL  JE_2_SM     :  state_machine; 
   SIGNAL  JF_1_SM     :  state_machine; 
   SIGNAL  JF_2_SM     :  state_machine; 
   SIGNAL  JG_1_SM     :  state_machine; 
   SIGNAL  JG_2_SM     :  state_machine; 
   SIGNAL  JH_1_SM     :  state_machine; 
   SIGNAL  JH_2_SM     :  state_machine; 
   
   TYPE servo_state_machine IS (INIT, IDLE, INCREASE_FREQ, DECREASE_FREQ, HOLD_POSITION, STOP_POSITION, TOGGLE_PIN); 
   SIGNAL  servo_sm         	:  servo_state_machine; 
   signal i_servo_pwm       	: std_logic;
   signal i_servo_ctr_val   	: std_logic_vector(15 downto 0);
   signal i_servo_ctr_val_def   : std_logic_vector(15 downto 0);
   signal i_frame_ctr_val   	: std_logic_vector(17 downto 0);
   signal i_servo_ctr       	: std_logic_vector(15 downto 0);
   signal i_frame_ctr       	: std_logic_vector(17 downto 0);
   signal i_led_sig         	: std_logic_vector( 7 downto 0);
   
begin




   --*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
   -- add in temporary clock - to be removed when PS clock is present DWR
   --*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
   -- USE with IO carrier clock
   
--clktemp_clk : clk_wiz_0
--PORT MAP(
--   reset    => USER_PB1 and not(DIP_SW1),
--   clk_in1  => CLK_100MHZ,
--   clk_out1 => clk_system,
--   clk_out2 => clk_system_10MHz,
--   locked   => locked
--);

 
   --reset <= not(locked); -- Generate a system reset that holds off while clocks are not locked
   reset <= not(RESET_IN); -- Generate a system reset that holds off while clocks are not locked
   CLK_EN <= '1';
   -- DWR fix this section
   clk <= CLK_100MHZ;
--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
-- USE without IO carrier clock
--reset <= RESET;
--CLK_EN <= '0';
--clk <= CLK_10MHZ;

-- Servo Specs:
-- @ 10Mhz 10 clock ticks = 1 uS
-- Frame time 16-23ms / 16000-23000mS
-- Pulse Width range 0.9ms to 2.1ms
-- Pulse width          Horn position
--   0.8ms /  800us       Safety zone for CW
--   0.9ms /  900us       +60 degrees ± 10° CW
--   1.5ms / 1500us       0 degree(center position)
--   2.1ms / 2100us       -60 degree ± 10° CCW
--   2.2ms / 2200us       Safety zone for CCW


SERVO_PWM <= i_servo_pwm;
SERVO_PWM_PROCESS: process(reset, clk)
begin
   if(reset = '1') then
      servo_sm             <= INIT;
      i_servo_pwm       	<= '1';
      i_servo_ctr_val   	<= x"3B60"; -- reset to 1.5ms
      i_servo_ctr_val_def   <= i_servo_ctr_val;
      i_servo_ctr       	<= i_servo_ctr_val;
      i_frame_ctr_val   	<= "01" & x"D4C0";
      i_frame_ctr       	<= i_frame_ctr_val;
      i_led_sig         	<= (others=>'0');
   elsif(rising_edge(clk)) then
      case servo_sm is
         when INIT =>
            servo_sm <= HOLD_POSITION;
         when IDLE =>
            if((unsigned(i_servo_ctr) > 0) and i_servo_pwm = '1') then
               i_servo_ctr <= i_servo_ctr - '1';
            end if;
            
            if(unsigned(i_frame_ctr) > 0) then
               i_frame_ctr <= i_frame_ctr - '1';
            end if;
            
            if((jc_1_rx_data1(1) = '1' or USER_PB3 = '1') and DIP_SW1 = '1') then 
               servo_sm <= DECREASE_FREQ;
            elsif((jc_1_rx_data1(2) = '1' or USER_PB2 = '1') and DIP_SW1 = '1') then
               servo_sm <= INCREASE_FREQ;
            elsif((jc_1_rx_data1(3) = '1' or USER_PB1 = '1') and DIP_SW1 = '1') then
               servo_sm <= HOLD_POSITION;
            elsif ((jc_1_rx_data1(0) = '1' or USER_PB4 = '1') and DIP_SW1 = '1') then
               servo_sm <= STOP_POSITION;
            elsif(i_servo_ctr = x"0000") then
               servo_sm <= TOGGLE_PIN;
            elsif(i_frame_ctr = x"0000") then
               servo_sm <= TOGGLE_PIN;
            end if;

         when INCREASE_FREQ =>
            if(jc_1_rx_data1(2) = '0' or USER_PB2 = '0') then -- 5 pushes makes the FET saturate)
               if(unsigned(i_servo_ctr_val) >= 21000) then --x"5208"
                  i_servo_ctr_val   <= x"55F0"; -- 2200us       Safety zone for CCW
                  i_led_sig <= "00000001";
               else
                  i_servo_ctr_val   <= i_servo_ctr_val + x"3E8"; --reset to 1.5ms
                  i_led_sig <= "00000010";
               end if;
               servo_sm <= IDLE;
            end if;
         when DECREASE_FREQ =>
            if(jc_1_rx_data1(1) = '0' or USER_PB3 = '0') then
               if(unsigned(i_servo_ctr_val) <= 9000) then  --x"2328"
                  i_servo_ctr_val   <= x"1F40";  -- 800us       Safety zone for CW
                  i_led_sig <= "10000000";
               else
                  i_servo_ctr_val   <= i_servo_ctr_val - x"03E8"; --reset to 1.5ms
                  i_led_sig <= "01000000";
               end if;
               servo_sm <= IDLE;
            end if;
         when HOLD_POSITION =>
            i_servo_ctr_val   <= i_servo_ctr_val_def; -- reset to 1.5ms
            servo_sm <= TOGGLE_PIN;
            i_led_sig <= "00011000";
         -- change this to add in a toggle for estop
         -- instead of IF DIP_SW4, look for PB to be set to 0 (user let go)
         -- proceed to new state (ESTOP HOLD)
         -- then when button pressed again, go to HOLD_POSITION
         when STOP_POSITION =>
            i_servo_pwm <= '1';
            i_led_sig <= "11111111";
            if( DIP_SW4 = '1') then
               servo_sm <= HOLD_POSITION;
            end if;
         when TOGGLE_PIN =>
            if(i_servo_ctr = x"0000" and not(i_frame_ctr = x"0000" )) then
               i_servo_pwm <= '0';
            else
               i_servo_pwm <= '1';
               i_frame_ctr <= i_frame_ctr_val;
               i_servo_ctr <= i_servo_ctr_val;
            end if;
            servo_sm <= IDLE;
            
         when others =>
            servo_sm <= IDLE;
      end case;
   end if;
end process;

   
-- MAXIM Corona ISO Dig Input Using TOP JC pins (1-4)
-- JC_1_SM
JC_1_SM_PROCESS: process(reset, clk)
begin   
   if( reset = '1') then
      JC_1_SM <= INIT;
      jc_1_rx_data1 <= (others=>'0');
      --jc_1_rx_data2 <= (others=>'0');
      --jc_1_rx_data3 <= (others=>'0');
      --jc_1_rx_data4 <= (others=>'0');
      i_jc_1_done_ack <= '0';
      i_jc_1_start <= '0';
      
   elsif(rising_edge(clk)) then
      case JC_1_SM is
         when INIT =>
            -- initialize the part
            i_jc_1_start <= '0';
            i_jc_1_done_ack <= '0';
            --if(jc_1_start = '1') then  -- Commented out to help traveling demo kick start
               JC_1_SM <= IDLE;
            --end if;
            
         when IDLE =>
            -- IDLE until we are told to go by the controller
            i_jc_1_start <= '0';
            if(jc_1_start = '1') then
               jc_1_rx_data1 <= (others=>'0');
               --jc_1_rx_data2 <= (others=>'0');
               --jc_1_rx_data3 <= (others=>'0');
               --jc_1_rx_data4 <= (others=>'0');
               JC_1_SM <= PERFORM_READ;
            else
               jc_1_rx_data1 <= i_jc_1_rx_data1;
               --jc_1_rx_data2 <= i_jc_1_rx_data2;
               --jc_1_rx_data3 <= i_jc_1_rx_data3;
               --jc_1_rx_data4 <= i_jc_1_rx_data4;
            end if;
            i_jc_1_done_ack <= '0';

         when PERFORM_READ =>
            -- Start a read from the SPI bus...wait until we are DONE
            i_jc_1_start <= '1';
            if i_jc_1_done = '1' then
               JC_1_SM <= REGISTER_DATA;
            end if;

         when REGISTER_DATA =>
            jc_1_rx_data1 <= i_jc_1_rx_data1;
            --jc_1_rx_data2 <= i_jc_1_rx_data2;
            --jc_1_rx_data3 <= i_jc_1_rx_data3;
            --jc_1_rx_data4 <= i_jc_1_rx_data4;
            i_jc_1_done_ack <= '1';
            if(jc_1_start = '0') then
               JC_1_SM <= IDLE;
            end if;

         when others =>
            JC_1_SM <= INIT;

      end case;
   end if;
end process;

   read_jc_1 <= '1' when JC_1_SM = IDLE else '0';
   
   jc_1_start <= (USER_PB4 and not(DIP_SW1)) or (read_jc_1 and DIP_SW1);
   LED_D1 <= jc_1_rx_data1(0) when DIP_SW1 = '0' else i_led_sig(0);
   LED_D2 <= jc_1_rx_data1(1) when DIP_SW1 = '0' else i_led_sig(1);
   LED_D3 <= jc_1_rx_data1(2) when DIP_SW1 = '0' else i_led_sig(2);
   LED_D4 <= jc_1_rx_data1(3) when DIP_SW1 = '0' else i_led_sig(3);
   LED_D5 <= jc_1_rx_data1(4) when DIP_SW1 = '0' else i_led_sig(4);
   LED_D6 <= jc_1_rx_data1(5) when DIP_SW1 = '0' else i_led_sig(5);
   LED_D7 <= jc_1_rx_data1(6) when DIP_SW1 = '0' else i_led_sig(6);
   LED_D8 <= jc_1_rx_data1(7) when DIP_SW1 = '0' else i_led_sig(7);

end Behavioral;