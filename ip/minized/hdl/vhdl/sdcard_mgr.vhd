----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2016 06:02:58 PM
-- Design Name: 
-- Module Name: sdcard_mgr - Behavioral
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

entity sdcard_mgr is
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
           
           --SDCARD_CLK : out STD_LOGIC;
           --SDCARD_CMD : inout STD_LOGIC;
           --SDCARD_DAT : inout STD_LOGIC_VECTOR (3 downto 0);
           --SDCARD_CD : in STD_LOGIC;
           --SDCARD_WP : in STD_LOGIC
           PMOD1_PIN1  : inout STD_LOGIC;   -- SDCARD_DAT3
           PMOD1_PIN2  : inout STD_LOGIC;   -- SDCARD_CMD
           PMOD1_PIN3  : inout STD_LOGIC;   -- SDCARD_DAT0
           PMOD1_PIN4  : out STD_LOGIC;     -- SDCARD_CLK
           PMOD1_PIN7  : inout STD_LOGIC;   -- SDCARD_DAT1
           PMOD1_PIN8  : inout STD_LOGIC;   -- SDCARD_DAT2
           PMOD1_PIN9  : in STD_LOGIC;      -- SDCARD_CD
           PMOD1_PIN10 : in STD_LOGIC       -- SDCARD_WP

           );
end sdcard_mgr;

architecture Behavioral of sdcard_mgr is

component IOBUF is
port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
);
end component IOBUF;  

signal SDIO_not_cmd_T : STD_LOGIC;
signal SDIO_not_data_T : STD_LOGIC_VECTOR(3 downto 0);

begin
sdio_cmd_iobuf: component IOBUF
     port map (
      I => SDIO_CMD_from_Zynq,
      O => SDIO_CMD_to_Zynq,
      T => SDIO_CMD_dir,
      IO => PMOD1_PIN2 -- Pmod pin 2: SDCARD_CMD
    ); 

sdio_dat0_iobuf: component IOBUF
     port map (
      I => SDIO_DATA_from_Zynq(0),
      O => SDIO_DATA_to_Zynq(0),
      T => SDIO_DATA_dir(0),
      IO => PMOD1_PIN3-- Pmod pin 3: SDCARD_DAT0
    ); 

sdio_dat1_iobuf: component IOBUF
     port map (
      I => SDIO_DATA_from_Zynq(1),
      O => SDIO_DATA_to_Zynq(1),
      T => SDIO_DATA_dir(1),
      IO => PMOD1_PIN7 -- Pmod pin 7: SDCARD_DAT1
    ); 

sdio_dat2_iobuf: component IOBUF
     port map (
      I => SDIO_DATA_from_Zynq(2),
      O => SDIO_DATA_to_Zynq(2),
      T => SDIO_DATA_dir(2),
      IO => PMOD1_PIN8 -- Pmod pin 8: SDCARD_DAT2
    ); 

sdio_dat3_iobuf: component IOBUF
     port map (
      I => SDIO_DATA_from_Zynq(3),
      O => SDIO_DATA_to_Zynq(3),
      T => SDIO_DATA_dir(3),
      IO => PMOD1_PIN1 -- Pmod pin 1: SDCARD_DAT3

    ); 

SDIO_CLK_FB <= SDIO_CLK; --Feedback clock
PMOD1_PIN4  <= SDIO_CLK; -- Pmod pin 4: SDCARD_CLK
SDIO_CDN	<= PMOD1_PIN9; -- Pmod pin 9: SDCARD_CD (Card Detect)
SDIO_WP		<= PMOD1_PIN10; -- Pmod pin 10: SDCARD_WP (Write Protect)

end Behavioral;

