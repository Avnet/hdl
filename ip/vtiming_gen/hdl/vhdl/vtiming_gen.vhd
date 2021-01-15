-------------------------------------------------------------------------------
--      _____
--     /     \
--    /____   \____
--   / \===\   \==/
--  /___\===\___\/  AVNET
--       \======/
--        \====/    
-------------------------------------------------------------------------------
--
-- This design is the property of Avnet.  Publication of this
-- design is not authorized without written consent from Avnet.
-- 
-- Please direct any questions to community forums on MicroZed.org
--
-- Disclaimer:
--    Avnet, Inc. makes no warranty for the use of this code or design.
--    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
--    any errors, which may appear in this code, nor does it make a commitment
--    to update the information contained herein. Avnet, Inc specifically
--    disclaims any implied warranties of fitness for a particular purpose.
--                     Copyright(c) 2013 Avnet, Inc.
--                             All rights reserved.
--
-------------------------------------------------------------------------------
--
-- Create Date:         Apr 26, 2013
-- Project Name:        Video Timing Generator

-- Target Devices:      Zynq-7000
-- Avnet Boards:        ZedBoard

--
-- Tool versions:       ISE 14.5
--
-- Description:         This project generates video timing
--                      compatible with the "Xilinx AXI4S to Video Out" core. 
--
-- Dependencies:        
--
-- Revision:            Apr 26, 2013: 1.00 First Version
--                      Jun 07, 2013: 1.01 Do not include clk port
--                                         in VTIMING_OUT interface
--                      Jun 04, 2014: 1.02 Changed WVGA hvsync_polarity
--                                         to match Sharp 7" Panel interface
--                      Jun 18, 2014: 1.03 Added WSVGA resolution definition
--                                         to support Kyocera 10.1" Panel 
--                                         interface
--                      Sep 22, 2015: 1.04 Added WXVGA resolution definition
--                                         to support Ampire 10.1" Panel 
--                                         interface
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity vtiming_gen is
    Generic (
	  C_VIDEO_RESOLUTION : integer := 1;
      C_FAMILY           : string  := "zynq"
    );
    Port (
      resetn             : in  std_logic;
      clk                : in  std_logic;
	  enable             : in  std_logic;
      -- VTIMING bus signals
      vsync_out          : out std_logic;
      hsync_out          : out std_logic;
      vblank_out         : out std_logic;
      hblank_out         : out std_logic;
      active_video_out   : out std_logic;
		
      debug              : out std_logic_vector(7 downto 0)
   );
end vtiming_gen;

architecture rtl of vtiming_gen is

   --
   -- Timing Configuration
   -- 

   signal hvsync_polarity : std_logic;
	
   signal tc_hsblnk   : std_logic_vector(10 downto 0);
   signal tc_hssync   : std_logic_vector(10 downto 0);
   signal tc_hesync   : std_logic_vector(10 downto 0);
   signal tc_heblnk   : std_logic_vector(10 downto 0);
		 
   signal tc_vsblnk   : std_logic_vector(10 downto 0);
   signal tc_vssync   : std_logic_vector(10 downto 0);
   signal tc_vesync   : std_logic_vector(10 downto 0);
   signal tc_veblnk   : std_logic_vector(10 downto 0);

   --
   -- Timing Generator
   -- 

   signal restart       : std_logic;
	
   component timing is
      port ( 
         clk            : in  std_logic;
         restart        : in  std_logic;
		 
         tc_hsblnk      : in  std_logic_vector(10 downto 0);
         tc_hssync      : in  std_logic_vector(10 downto 0);
         tc_hesync      : in  std_logic_vector(10 downto 0);
         tc_heblnk      : in  std_logic_vector(10 downto 0);

         hcount         : out std_logic_vector(10 downto 0);
         hsync          : out std_logic;
         hblnk          : out std_logic;

         tc_vsblnk      : in  std_logic_vector(10 downto 0);
         tc_vssync      : in  std_logic_vector(10 downto 0);
         tc_vesync      : in  std_logic_vector(10 downto 0);
         tc_veblnk      : in  std_logic_vector(10 downto 0);

         vcount         : out std_logic_vector(10 downto 0);
         vsync          : out std_logic;
         vblnk          : out std_logic
      );
   end component timing;

   signal timing_vsync  : std_logic;
   signal timing_vblank : std_logic;
   signal timing_hsync  : std_logic;
   signal timing_hblank : std_logic;
	
   signal active_video  : std_logic;
	
	
begin

   --
   -- Timing Configuration
   -- 

   VGA_VTIMING_GEN : if ( C_VIDEO_RESOLUTION = 0 ) generate
      -- VGA 
      --   pixel rate = 25 MHz
      --   resolution = 640x480@60HZ
      hvsync_polarity <= '1';
      --                                            HPIXELS HFNPRCH HSYNCPW HBKPRCH
      tc_hsblnk <= std_logic_vector( conv_unsigned( 640                             - 1, 11) );
      tc_hssync <= std_logic_vector( conv_unsigned( 640 +   16                      - 1, 11) );
      tc_hesync <= std_logic_vector( conv_unsigned( 640 +   16 +    96              - 1, 11) );
      tc_heblnk <= std_logic_vector( conv_unsigned( 640 +   16 +    96 +    48      - 1, 11) );
      --                                            VLINES  VFNPRCH VSYNCPW VBKPRCH
      tc_vsblnk <= std_logic_vector( conv_unsigned( 480                            - 1, 11) );
      tc_vssync <= std_logic_vector( conv_unsigned( 480 +   11                     - 1, 11) );
      tc_vesync <= std_logic_vector( conv_unsigned( 480 +   11 +    2              - 1, 11) );
      tc_veblnk <= std_logic_vector( conv_unsigned( 480 +   11 +    2 +     31     - 1, 11) );
   end generate VGA_VTIMING_GEN;

   WVGA_VTIMING_GEN : if ( C_VIDEO_RESOLUTION = 1 ) generate
      -- WVGA 
      --   pixel rate = 33.33 MHz
      --   resolution = 800x480@60HZ
      hvsync_polarity <= '0';
      --                                            HPIXELS HFNPRCH HSYNCPW HBKPRCH
      tc_hsblnk <= std_logic_vector( conv_unsigned( 800                            - 1, 11) );
      tc_hssync <= std_logic_vector( conv_unsigned( 800 +   40                     - 1, 11) );
      tc_hesync <= std_logic_vector( conv_unsigned( 800 +   40 +    128            - 1, 11) );
      tc_heblnk <= std_logic_vector( conv_unsigned( 800 +   40 +    128 +    88    - 1, 11) );
      --                                            VLINES  VFNPRCH VSYNCPW VBKPRCH
      tc_vsblnk <= std_logic_vector( conv_unsigned( 480                            - 1, 11) );
      tc_vssync <= std_logic_vector( conv_unsigned( 480 +   8                      - 1, 11) );
      tc_vesync <= std_logic_vector( conv_unsigned( 480 +   8 +     2              - 1, 11) );
      tc_veblnk <= std_logic_vector( conv_unsigned( 480 +   8 +     2 +     35     - 1, 11) );
   end generate WVGA_VTIMING_GEN;

   SVGA_VTIMING_GEN : if ( C_VIDEO_RESOLUTION = 2 ) generate
      -- SVGA
      --   pixel rate = 40 MHz
      --   resolution = 800x600@60HZ
      hvsync_polarity <= '0';
      --                                            HPIXELS HFNPRCH HSYNCPW HBKPRCH
      tc_hsblnk <= std_logic_vector( conv_unsigned( 800                            - 1, 11) );
      tc_hssync <= std_logic_vector( conv_unsigned( 800 +   40                     - 1, 11) );
      tc_hesync <= std_logic_vector( conv_unsigned( 800 +   40 +    128            - 1, 11) );
      tc_heblnk <= std_logic_vector( conv_unsigned( 800 +   40 +    128 +    88    - 1, 11) );
      --                                            VLINES  VFNPRCH VSYNCPW VBKPRCH
      tc_vsblnk <= std_logic_vector( conv_unsigned( 600                            - 1, 11) );
      tc_vssync <= std_logic_vector( conv_unsigned( 600 +   1                      - 1, 11) );
      tc_vesync <= std_logic_vector( conv_unsigned( 600 +   1 +     4              - 1, 11) );
      tc_veblnk <= std_logic_vector( conv_unsigned( 600 +   1 +     4 +     23     - 1, 11) );
   end generate SVGA_VTIMING_GEN;

   XGA_VTIMING_GEN : if ( C_VIDEO_RESOLUTION = 3 ) generate
      -- XGA 
      --   pixel rate = 65 MHz
      --   resolution = 1024x768@60HZ
      hvsync_polarity <= '1';
      --                                            HPIXELS HFNPRCH HSYNCPW HBKPRCH
      tc_hsblnk <= std_logic_vector( conv_unsigned(1024                            - 1, 11) );
      tc_hssync <= std_logic_vector( conv_unsigned(1024 +   24                     - 1, 11) );
      tc_hesync <= std_logic_vector( conv_unsigned(1024 +   24 +    136            - 1, 11) );
      tc_heblnk <= std_logic_vector( conv_unsigned(1024 +   24 +    136 +   160    - 1, 11) );
      --                                            VLINES  VFNPRCH VSYNCPW VBKPRCH
      tc_vsblnk <= std_logic_vector( conv_unsigned( 768                            - 1, 11) );
      tc_vssync <= std_logic_vector( conv_unsigned( 768 +   3                      - 1, 11) );
      tc_vesync <= std_logic_vector( conv_unsigned( 768 +   3 +     6              - 1, 11) );
      tc_veblnk <= std_logic_vector( conv_unsigned( 768 +   3 +     6 +     29     - 1, 11) );
   end generate XGA_VTIMING_GEN;

   HD720P_VTIMING_GEN : if ( C_VIDEO_RESOLUTION = 4 ) generate
      -- 720P60
      --   pixel rate = 74.25 MHz
      --   resolution = 1280x720@60HZ
      hvsync_polarity <= '0';
      --                                            HPIXELS HFNPRCH HSYNCPW HBKPRCH
      tc_hsblnk <= std_logic_vector( conv_unsigned(1280                            - 1, 11) );
      tc_hssync <= std_logic_vector( conv_unsigned(1280 +   72                     - 1, 11) );
      tc_hesync <= std_logic_vector( conv_unsigned(1280 +   72 +    80             - 1, 11) );
      tc_heblnk <= std_logic_vector( conv_unsigned(1280 +   72 +    80 +    216    - 1, 11) );
      --                                            VLINES  VFNPRCH VSYNCPW VBKPRCH
      tc_vsblnk <= std_logic_vector( conv_unsigned( 720                            - 1, 11) );
      tc_vssync <= std_logic_vector( conv_unsigned( 720 +   3                      - 1, 11) );
      tc_vesync <= std_logic_vector( conv_unsigned( 720 +   3 +     5              - 1, 11) );
      tc_veblnk <= std_logic_vector( conv_unsigned( 720 +   3 +     5 +     22     - 1, 11) );
   end generate HD720P_VTIMING_GEN;
  
   SXGA_VTIMING_GEN : if ( C_VIDEO_RESOLUTION = 5 ) generate
      -- SXGA
      --   pixel rate = 108 MHz
      --   resolution = 1280x1024@60HZ
      hvsync_polarity <= '0';
      --                                            HPIXELS HFNPRCH HSYNCPW HBKPRCH
      tc_hsblnk <= std_logic_vector( conv_unsigned(1280                            - 1, 11) );
      tc_hssync <= std_logic_vector( conv_unsigned(1280 +   48                     - 1, 11) );
      tc_hesync <= std_logic_vector( conv_unsigned(1280 +   48 +    112            - 1, 11) );
      tc_heblnk <= std_logic_vector( conv_unsigned(1280 +   48 +    112 +   248    - 1, 11) );
      --                                            VLINES  VFNPRCH VSYNCPW VBKPRCH
      tc_vsblnk <= std_logic_vector( conv_unsigned(1024                            - 1, 11) );
      tc_vssync <= std_logic_vector( conv_unsigned(1024 +   1                      - 1, 11) );
      tc_vesync <= std_logic_vector( conv_unsigned(1024 +   1 +     3              - 1, 11) );
      tc_veblnk <= std_logic_vector( conv_unsigned(1024 +   1 +     3 +     38     - 1, 11) );
   end generate SXGA_VTIMING_GEN;

   WSVGA_VTIMING_GEN : if ( C_VIDEO_RESOLUTION = 6 ) generate
      -- WSVGA
      --   pixel rate = 50 MHz
      --   resolution = 1024x600@60HZ
      hvsync_polarity <= '0';
      --                                            HPIXELS HFNPRCH HSYNCPW HBKPRCH
      tc_hsblnk <= std_logic_vector( conv_unsigned(1024                            - 1, 11) );
      tc_hssync <= std_logic_vector( conv_unsigned(1024 +   48                     - 1, 11) );
      tc_hesync <= std_logic_vector( conv_unsigned(1024 +   48 +    32             - 1, 11) );
      tc_heblnk <= std_logic_vector( conv_unsigned(1024 +   48 +    32 +    240    - 1, 11) );
      --                                            VLINES  VFNPRCH VSYNCPW VBKPRCH
      tc_vsblnk <= std_logic_vector( conv_unsigned( 600                            - 1, 11) );
      tc_vssync <= std_logic_vector( conv_unsigned( 600 +   3                      - 1, 11) );
      tc_vesync <= std_logic_vector( conv_unsigned( 600 +   3 +     10             - 1, 11) );
      tc_veblnk <= std_logic_vector( conv_unsigned( 600 +   3 +     10 +    12     - 1, 11) );
   end generate WSVGA_VTIMING_GEN;
   
   WXGA_VTIMING_GEN : if ( C_VIDEO_RESOLUTION = 7 ) generate
      -- SXGA
      --   pixel rate = 71.1 MHz
      --   resolution = 1280x800@60HZ
      hvsync_polarity <= '0';
      --                                            HPIXELS HFNPRCH HSYNCPW HBKPRCH
      tc_hsblnk <= std_logic_vector( conv_unsigned(1280                            - 1, 11) );
      tc_hssync <= std_logic_vector( conv_unsigned(1280 +   60                     - 1, 11) );
      tc_hesync <= std_logic_vector( conv_unsigned(1280 +   60  +    50            - 1, 11) );
      tc_heblnk <= std_logic_vector( conv_unsigned(1280 +   60  +    50  +   50    - 1, 11) );
      --                                            VLINES  VFNPRCH VSYNCPW VBKPRCH
      tc_vsblnk <= std_logic_vector( conv_unsigned(800                             - 1, 11) );
      tc_vssync <= std_logic_vector( conv_unsigned(800  +   6                      - 1, 11) );
      tc_vesync <= std_logic_vector( conv_unsigned(800  +   6   +     3            - 1, 11) );
      tc_veblnk <= std_logic_vector( conv_unsigned(800  +   6   +     3  +    14   - 1, 11) );
   end generate WXGA_VTIMING_GEN;


   --
   -- Timing Generator
   -- 
	
   restart <= (not resetn) or (not enable);

   timing_l : timing
      port map( 
         clk            => clk,
         restart        => restart,
		 
         tc_hsblnk      => tc_hsblnk,
         tc_hssync      => tc_hssync,
         tc_hesync      => tc_hesync,
         tc_heblnk      => tc_heblnk,

         hcount         => open,
         hsync          => timing_hsync,
         hblnk          => timing_hblank,

         tc_vsblnk      => tc_vsblnk,
         tc_vssync      => tc_vssync,
         tc_vesync      => tc_vesync,
         tc_veblnk      => tc_veblnk,

         vcount         => open,
         vsync          => timing_vsync,
         vblnk          => timing_vblank
      );

   active_video         <= not(timing_hblank) and not(timing_vblank);

   timing_oregs : process ( clk )
   begin
      if rising_edge(clk) then
         hsync_out        <= timing_hsync xor hvsync_polarity;
         vsync_out        <= timing_vsync xor hvsync_polarity;
         hblank_out       <= timing_hblank;
         vblank_out       <= timing_vblank;
         active_video_out <= active_video;
      end if;
   end process;
	
   debug_oregs : process ( clk )
   begin
      if rising_edge(clk) then
         debug(7)         <= timing_vsync;
         debug(6)         <= timing_vblank;
         debug(5)         <= timing_hsync;
         debug(4)         <= timing_hblank;
         debug(3)         <= hvsync_polarity;
         debug(2)         <= timing_vsync xor hvsync_polarity;
         debug(1)         <= timing_hsync xor hvsync_polarity;
         debug(0)         <= active_video;
      end if;
   end process;
        
end rtl;
