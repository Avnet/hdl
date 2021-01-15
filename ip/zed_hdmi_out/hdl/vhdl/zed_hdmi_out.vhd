------------------------------------------------------------------
--      _____
--     /     \
--    /____   \____
--   / \===\   \==/
--  /___\===\___\/  AVNET
--       \======/
--        \====/    
-----------------------------------------------------------------
--
-- This design is the property of Avnet.  Publication of this
-- design is not authorized without written consent from Avnet.
-- 
-- Please direct any questions to:  technical.support@avnet.com
--
-- Disclaimer:
--    Avnet, Inc. makes no warranty for the use of this code or design.
--    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
--    any errors, which may appear in this code, nor does it make a commitment
--    to update the information contained herein. Avnet, Inc specifically
--    disclaims any implied warranties of fitness for a particular purpose.
--                     Copyright(c) 2011 Avnet, Inc.
--                             All rights reserved.
--
------------------------------------------------------------------
--
-- Create Date:         May 19, 2012
-- Design Name:         ZedBoard HDMI Output
-- Module Name:         zed_hdmi_out.vhd
-- Project Name:        ZedBoard HDMI Output
-- Target Devices:      Zynq-7000
--
-- Tool versions:       ISE 14.3
--
-- Description:         ZedBoard HDMI output interface.
--
-- Dependencies:        
--
-- Revision:            May 19, 2012: 1.02 Initial version
--                      Dec 21, 2012: 2.01 Remove XSVI bus interface
--                                         Remove xsvi_ prefixes to video_
--                                         Rename active_video to de
--                                         Change IP_GROUP to FMC-IMAGEON
--
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity zed_hdmi_out is
   Generic
   (
      C_DATA_WIDTH        : integer := 16;
      C_FAMILY            : string  := "virtex6"
   );
   Port
   (
      clk                 : in  std_logic;
      reset               : in  std_logic;
      -- Audio Input Port
      audio_spdif         : in  std_logic;
      -- Video Ports
      video_vsync         : in  std_logic;
      video_hsync         : in  std_logic;
      video_de            : in  std_logic;
      video_data          : in  std_logic_vector((C_DATA_WIDTH-1) downto 0);
      -- I/O pins
      io_hdmio_spdif      : out std_logic;
      io_hdmio_video      : out std_logic_vector(15 downto 0);
      io_hdmio_vsync      : out std_logic;
      io_hdmio_hsync      : out std_logic;
      io_hdmio_de         : out std_logic;
      io_hdmio_clk        : out std_logic
   );
end zed_hdmi_out;

architecture rtl of zed_hdmi_out is

   signal clk_n           : std_logic;

   signal net0            : std_logic;
   signal net1            : std_logic;

   signal oe              : std_logic;
   signal oe_n            : std_logic;

   --
   -- Audio Port
   --

   signal spdif_r         : std_logic;

   --
   -- Video Port
   --

   signal video_r         : std_logic_vector(15 downto 0);
   signal vsync_r         : std_logic;
   signal hsync_r         : std_logic;
   signal de_r            : std_logic;

   --
   -- IOB Registers
   -- 
    
   signal hdmi_spdif_o   : std_logic;
   signal hdmi_video_o   : std_logic_vector(15 downto 0);
   signal hdmi_vsync_o   : std_logic;
   signal hdmi_hsync_o   : std_logic;
   signal hdmi_de_o      : std_logic;
   signal hdmi_clk_o     : std_logic;

   signal hdmi_spdif_t   : std_logic;
   signal hdmi_video_t   : std_logic_vector(15 downto 0);
   signal hdmi_vsync_t   : std_logic;
   signal hdmi_hsync_t   : std_logic;
   signal hdmi_de_t      : std_logic;
   signal hdmi_clk_t     : std_logic;

   attribute IOB : string;
   attribute IOB of hdmi_spdif_o : signal is "TRUE";
   attribute IOB of hdmi_video_o : signal is "TRUE";
   attribute IOB of hdmi_vsync_o : signal is "TRUE";
   attribute IOB of hdmi_hsync_o : signal is "TRUE";
   attribute IOB of hdmi_de_o    : signal is "TRUE";
   attribute IOB of hdmi_clk_o   : signal is "TRUE";

begin

   clk_n <= not clk;

   oe    <= '1';
   oe_n  <= not oe;

   net0 <= '0';
   net1 <= '1';

   --
   -- Audio Port
   -- 

   spdif_r <= audio_spdif;

   --
   -- Video Ports
   --

   VIDEO_PORTS_16BIT_GEN : if (C_DATA_WIDTH = 16) generate
      video_ports_16bit_iregs_l : process (clk)
      begin
         if Rising_Edge(clk) then
            video_r <= video_data(15 downto 0);
            vsync_r <= video_vsync;
            hsync_r <= video_hsync;
            de_r    <= video_de;
         end if;
      end process;
   end generate VIDEO_PORTS_16BIT_GEN;

   --
   -- IOB Registers
   --
   
   io_oregs_l : process (clk)
   begin
      if Rising_Edge(clk) then
         hdmi_spdif_o <= spdif_r;
         hdmi_video_o <= video_r;
         hdmi_vsync_o <= vsync_r;
         hdmi_hsync_o <= hsync_r;
         hdmi_de_o    <= de_r;
         --
         hdmi_spdif_t <= oe_n;
         hdmi_video_t <= (others => oe_n);
         hdmi_vsync_t <= oe_n;
         hdmi_hsync_t <= oe_n;
         hdmi_de_t    <= oe_n;
      end if;
   end process;

   S3ADSP_GEN : if (C_FAMILY = "spartan3adsp") generate

      ODDR_hdmi_clk_o : ODDR2 
         generic map (
            DDR_ALIGNMENT => "NONE", -- "NONE", "C0" or "C1" 
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => hdmi_clk_o,
            C0 => clk,
            C1 => clk_n,
            CE => net1,
            D0 => net0, 
            D1 => net1, 
            R  => net0, 
            S  => net0);

      ODDR_hdmi_clk_t : ODDR2 
         generic map (
            DDR_ALIGNMENT => "NONE", -- "NONE", "C0" or "C1" 
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => hdmi_clk_t,
            C0 => clk,
            C1 => clk_n,
            CE => net1,
            D0 => oe_n, 
            D1 => oe_n, 
            R  => net0, 
            S  => net0);

   end generate S3ADSP_GEN;

   S6_GEN : if (C_FAMILY = "spartan6") generate

      ODDR_hdmi_clk_o : ODDR2 
         generic map (
            DDR_ALIGNMENT => "C0", -- "NONE", "C0" or "C1" 
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => hdmi_clk_o,
            C0 => clk,
            C1 => clk_n,
            CE => net1,
            D0 => net0,
            D1 => net1,
            R  => net0,
            S  => net0);

      ODDR_hdmi_clk_t : ODDR2 
         generic map (
            DDR_ALIGNMENT => "C0", -- "NONE", "C0" or "C1" 
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => hdmi_clk_t,
            C0 => clk,
            C1 => clk_n,
            CE => net1,
            D0 => oe_n, 
            D1 => oe_n, 
            R  => net0, 
            S  => net0);

   end generate S6_GEN;

   V6_GEN : if (C_FAMILY = "virtex6" or C_FAMILY = "zynq" or C_FAMILY = "kintex7" or C_FAMILY = "artix7" or C_FAMILY = "virtex7") generate

      ODDR_hdmi_clk_o : ODDR
         generic map (
              DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"  
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => hdmi_clk_o,
            C  => clk,
            CE => net1,
            D1 => net0,
            D2 => net1,
            R  => net0,
            S  => net0);

      ODDR_hdmi_clk_t : ODDR 
         generic map (
            DDR_CLK_EDGE => "SAME_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE"  
            INIT => '1',             -- Sets initial state of Q  
            SRTYPE => "ASYNC")       -- Reset type     
         port map (
            Q  => hdmi_clk_t,
            C  => clk,
            CE => net1,
            D1 => oe_n, 
            D2 => oe_n, 
            R  => net0, 
            S  => net0);

   end generate V6_GEN;

   --
   -- Tri-stateable outputs
   --    Can be used to disable outputs to FMC connector
   --    until FMC module is correctly identified.
   -- 

   OBUFT_hdmio_spdif : OBUFT
   port map (
      O => io_hdmio_spdif,
      I => hdmi_spdif_o,
      T => hdmi_spdif_t
   );

   IO1: for I in 0 to 15 generate
      OBUFT_hdmio_video : OBUFT
      port map (
         O => io_hdmio_video(I),
         I => hdmi_video_o(I),
         T => hdmi_video_t(I)
      );
   end generate IO1;

   OBUFT_hdmio_vsync : OBUFT
   port map (
      O => io_hdmio_vsync,
      I => hdmi_vsync_o,
      T => hdmi_vsync_t
   );
   
   OBUFT_hdmio_hsync : OBUFT
   port map (
      O => io_hdmio_hsync,
      I => hdmi_hsync_o,
      T => hdmi_hsync_t
   );
   
   OBUFT_hdmio_de : OBUFT
   port map (
      O => io_hdmio_de,
      I => hdmi_de_o,
      T => hdmi_de_t
   );
   
   OBUFT_hdmio_clk : OBUFT
   port map (
      O => io_hdmio_clk,
      I => hdmi_clk_o,
      T => hdmi_clk_t
   );

end rtl;
