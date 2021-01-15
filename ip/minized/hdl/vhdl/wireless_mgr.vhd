----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2016 06:02:58 PM
-- Design Name: 
-- Module Name: wireless_mgr - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wireless_mgr is
    Port ( 
           -- SDIO #0 interface from Zynq: 
           SDIO_CLK             : in STD_LOGIC;
           SDIO_CLK_FB          : out STD_LOGIC;
           SDIO_CMD_from_Zynq   : in STD_LOGIC;
           SDIO_CMD_to_Zynq     : out STD_LOGIC;
           SDIO_CMD_dir         : in STD_LOGIC;
           SDIO_DATA_from_Zynq  : in STD_LOGIC_VECTOR (3 downto 0);
           SDIO_DATA_to_Zynq    : out STD_LOGIC_VECTOR (3 downto 0);
           SDIO_DATA_dir        : in STD_LOGIC_VECTOR (3 downto 0);
           SDIO_CDN             : out STD_LOGIC;
           SDIO_WP              : out STD_LOGIC;
           -- UART #0 interface from Zynq: 
           ZYNQ_UART_TX         : in STD_LOGIC;
           ZYNQ_UART_RX         : out STD_LOGIC; 
           ZYNQ_UART_RTS        : in STD_LOGIC;
           ZYNQ_UART_CTS        : out STD_LOGIC;
           -- GPIO interface from Zynq: 
           GPIO_from_Zynq       : in STD_LOGIC_VECTOR (3 downto 0);
           GPIO_to_Zynq         : out STD_LOGIC_VECTOR (3 downto 0);
           GPIO_dir             : in STD_LOGIC_VECTOR (3 downto 0);
           -- Murata Type 1DX Wi-Fi interface:
           WL_SDIO_CLK          : out STD_LOGIC;
           WL_SDIO_CMD          : inout STD_LOGIC;
           WL_SDIO_DAT          : inout STD_LOGIC_VECTOR (3 downto 0);
           WL_REG_ON            : out STD_LOGIC;
           WL_HOST_WAKE         : in STD_LOGIC;
           -- Murata Type 1DX Bluetooth interface:
           BT_TXD_OUT           : in STD_LOGIC;
           BT_RXD_IN            : out STD_LOGIC;
           BT_RTS_OUT_N         : in STD_LOGIC;
           BT_CTS_IN_N          : out STD_LOGIC;
           BT_REG_ON            : out STD_LOGIC;
           BT_HOST_WAKE         : in STD_LOGIC            
         );
end wireless_mgr;

architecture Behavioral of wireless_mgr is

-- I/O buffer component for inout driver on pin pad:
component IOBUF is
port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
);
end component IOBUF;  

begin

sdio_cmd_iobuf: component IOBUF
     port map (
      I => SDIO_CMD_from_Zynq,
      O => SDIO_CMD_to_Zynq,
      T => SDIO_CMD_dir,
      IO => WL_SDIO_CMD
    ); 

sdio_dat0_iobuf: component IOBUF
     port map (
      I => SDIO_DATA_from_Zynq(0),
      O => SDIO_DATA_to_Zynq(0),
      T => SDIO_DATA_dir(0),
      IO => WL_SDIO_DAT(0)
    ); 

sdio_dat1_iobuf: component IOBUF
     port map (
      I => SDIO_DATA_from_Zynq(1),
      O => SDIO_DATA_to_Zynq(1),
      T => SDIO_DATA_dir(1),
      IO => WL_SDIO_DAT(1)
    ); 

sdio_dat2_iobuf: component IOBUF
     port map (
      I => SDIO_DATA_from_Zynq(2),
      O => SDIO_DATA_to_Zynq(2),
      T => SDIO_DATA_dir(2),
      IO => WL_SDIO_DAT(2)
    ); 

sdio_dat3_iobuf: component IOBUF
     port map (
      I => SDIO_DATA_from_Zynq(3),
      O => SDIO_DATA_to_Zynq(3),
      T => SDIO_DATA_dir(3),
      IO => WL_SDIO_DAT(3)
    ); 

    -- GPIO assignments:
    BT_REG_ON <= GPIO_from_Zynq(0) when GPIO_dir(0) = '0' else 'Z';
    GPIO_to_Zynq(1) <= BT_HOST_WAKE;
    WL_REG_ON <= GPIO_from_Zynq(2) when GPIO_dir(2) = '0' else 'Z';
    GPIO_to_Zynq(3) <= WL_HOST_WAKE;

    -- Bluetooth UART assignments:
    -- BT_RTS_OUT# (Request to Send) on module connected to Zynq UART_CTS (Clear to Send). Direction: Zynq <- module
    ZYNQ_UART_CTS     <= BT_RTS_OUT_N;
    -- PL Pmod JD pin 2: BT_RXD_IN (Receive signal) on module connected to Zynq UART_TX (Transmit signal). Direction: Zynq -> module
    BT_RXD_IN    <= ZYNQ_UART_TX;
    -- BT_TXD_OUT (Transmit signal) on module connected to Zynq UART_Rx (Receive signal). Direction: Zynq <- module
    ZYNQ_UART_RX      <= BT_TXD_OUT;
    -- BT_CTS_IN# (Clear to Send) on module connected to Zynq UART_RTS (Request to Send). Direction: Zynq -> module
    BT_CTS_IN_N    <= ZYNQ_UART_RTS;

    -- Wi-Fi assignments:
    SDIO_CLK_FB <= SDIO_CLK; --Feedback clock
    WL_SDIO_CLK  <= SDIO_CLK;
    SDIO_CDN <= '0'; -- Card Detect
    SDIO_WP <= '0'; -- Write Protect

end Behavioral;

