------------------------------------------------------------------
-- Copyright 2011(c) Analog Devices, Inc.
--
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without modification, 
-- are permitted provided that the following conditions are met:
--? - Redistributions of source code must retain the above copyright
--? ? notice, this list of conditions and the following disclaimer.
--? - Redistributions in binary form must reproduce the above copyright
--? ? notice, this list of conditions and the following disclaimer in
--? ? the documentation and/or other materials provided with the
--? ? distribution.
--? - Neither the name of Analog Devices, Inc. nor the names of its
--? ? contributors may be used to endorse or promote products derived
--? ? from this software without specific prior written permission.
--? - The use of this software may or may not infringe the patent rights
--? ? of one or more patent holders. ?This license does not release you
--? ? from the requirement that you obtain separate licenses from these
--? ? patent holders to use this software.
--? - Use of the software either in source or binary form, must be run
--? ? on or directly connected to an Analog Devices Inc. component.
--
-- THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
-- IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
-- OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
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

entity adv7511_embed_syncs is
   Port
   (
      clk             : in  std_logic;      
      -- Video Input
      vsync_i         : in  std_logic;
      hsync_i         : in  std_logic;
      vblank_i        : in  std_logic;
      hblank_i        : in  std_logic;
      active_video_i  : in  std_logic;
      y_data_i        : in  std_logic_vector(7 downto 0);
      c_data_i        : in  std_logic_vector(7 downto 0);
      -- Video Output
      vsync_o         : out std_logic;
      hsync_o         : out std_logic;
      y_data_o        : out std_logic_vector(7 downto 0);
      c_data_o        : out std_logic_vector(7 downto 0);
      active_video_o  : out std_logic
   );
end adv7511_embed_syncs;

architecture rtl of adv7511_embed_syncs is

   --
   -- Input Delay
   --

   signal vsync_d         : std_logic_vector(6 downto 1);
   signal hsync_d         : std_logic_vector(6 downto 1);
   signal vblank_d        : std_logic_vector(6 downto 1);
   signal hblank_d        : std_logic_vector(6 downto 1);
   signal active_video_d  : std_logic_vector(6 downto 1);
   
   signal y_data_d1   : std_logic_vector(7 downto 0);
   signal y_data_d2   : std_logic_vector(7 downto 0);
   signal y_data_d3   : std_logic_vector(7 downto 0);
   signal y_data_d4   : std_logic_vector(7 downto 0);
   signal y_data_d5   : std_logic_vector(7 downto 0);
   signal y_data_d6   : std_logic_vector(7 downto 0);
   
   signal c_data_d1   : std_logic_vector(7 downto 0);
   signal c_data_d2   : std_logic_vector(7 downto 0);
   signal c_data_d3   : std_logic_vector(7 downto 0);
   signal c_data_d4   : std_logic_vector(7 downto 0);
   signal c_data_d5   : std_logic_vector(7 downto 0);
   signal c_data_d6   : std_logic_vector(7 downto 0);
   
   signal vsync_df        : std_logic;
   signal hsync_df        : std_logic;
   signal vblank_df       : std_logic;
   signal hblank_df       : std_logic;
   signal active_video_df : std_logic;
   signal y_data_df       : std_logic_vector(7 downto 0);
   signal c_data_df       : std_logic_vector(7 downto 0);

   --
   -- SAV/EAV Codes
   --

   signal sav            : std_logic_vector(7 downto 0); 
   signal eav            : std_logic_vector(7 downto 0); 

begin

   --
   -- Input Delay
   --

   input_delay_l : process (clk)
   begin
      if Rising_Edge(clk) then
         -- vsync delay line
         vsync_d <= vsync_d(5 downto 1) & vsync_i;
         
		 -- hsync delay line
         hsync_d <= hsync_d(5 downto 1) & hsync_i;
         
		 -- vblank delay line
         vblank_d <= vblank_d(5 downto 1) & vblank_i;
         
		 -- hblank delay line
         hblank_d <= hblank_d(5 downto 1) & hblank_i;
         
		 -- active_video delay line
         active_video_d <= active_video_d(5 downto 1) & active_video_i;
         
		 -- video_data delay line
         if (y_data_i = X"00") then
            y_data_d1 <= X"01";
         elsif (y_data_i = X"FF") then
            y_data_d1 <= X"FE";
         else
            y_data_d1 <= y_data_i;
         end if;

		 case ( hblank_d(5 downto 1) ) is
           when "00011" => y_data_d2 <= eav;           
           when "00001" => y_data_d2 <= X"00";
           when others  => y_data_d2 <= y_data_d1;
         end case;	 
	 
         y_data_d3  <= y_data_d2;
		 y_data_d4  <= y_data_d3;
		 y_data_d5  <= y_data_d4;
		 y_data_d6  <= y_data_d5;

         if (c_data_i = X"00") then
            c_data_d1 <= X"01";
         elsif (c_data_i = X"FF") then
            c_data_d1 <= X"FE";
         else
            c_data_d1 <= c_data_i;
         end if;
		 
		 case ( hblank_d(5 downto 1) ) is
           when "00011" => c_data_d2 <= X"00";           
           when "00001" => c_data_d2 <= X"FF";
           when others  => c_data_d2 <= c_data_d1;
         end case;	 
		 		 
		 c_data_d3  <= c_data_d2;		 
		 c_data_d4  <= c_data_d3;		 
		 c_data_d5  <= c_data_d4;		 
		 c_data_d6  <= c_data_d5;		 
         
         --
         vsync_df        <= vsync_d(6);
         hsync_df        <= hsync_d(6);
         vblank_df       <= vblank_d(6);
         hblank_df       <= hblank_d(6);
         active_video_df <= active_video_d(6);

         case ( hblank_d(6 downto 2) ) is
           when "10000" => y_data_df <= sav;
           when "11000" => y_data_df <= X"00";
           when others  => y_data_df <= y_data_d6;
         end case;
		 
         case ( hblank_d(6 downto 2) ) is
           when "10000" => c_data_df <= X"00";
           when "11000" => c_data_df <= X"FF";
           when others  => c_data_df <= c_data_d6;
         end case;		 
      end if;
   end process;

   y_data_o       <= y_data_df;
   c_data_o       <= c_data_df;
   active_video_o <= active_video_df;
   vsync_o        <= vsync_df;
   hsync_o        <= hsync_df;

   --
   -- SAV/EAV Codes
   --

   sav <= X"80" when (vblank_d(2) = '0') else X"AB";
   eav <= X"9D" when (vblank_d(2) = '0') else X"B6";
       
end rtl;

