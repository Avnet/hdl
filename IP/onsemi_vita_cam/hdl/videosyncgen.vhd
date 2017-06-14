-------------------------------------------------------------------------------
--  
--        ** **        **          **  ****      **  **********  ********** ® 
--       **   **        **        **   ** **     **  **              ** 
--      **     **        **      **    **  **    **  **              ** 
--     **       **        **    **     **   **   **  *********       ** 
--    **         **        **  **      **    **  **  **              ** 
--   **           **        ****       **     ** **  **              ** 
--  **  .........  **        **        **      ****  **********      ** 
--     ........... 
--                                     Reach Further™ 
--  
-------------------------------------------------------------------------------
--
-- This design is the property of Avnet.  Publication of this 
-- design is not authorized without written consent from Avnet. 
-- 
-- Please direct any questions to the PicoZed community support forum: 
--    http://www.zedboard.org/forum 
-- 
-- Disclaimer: 
--    Avnet, Inc. makes no warranty for the use of this code or design. 
--    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
--    any errors, which may appear in this code, nor does it make a commitment 
--    to update the information contained herein. Avnet, Inc specifically 
--    disclaims any implied warranties of fitness for a particular purpose. 
--                     Copyright(c) 2017 Avnet, Inc. 
--                             All rights reserved. 
-- 
-------------------------------------------------------------------------------
--
-- Create Date:         Dec 03, 2009
-- Design Name:         IVK
-- Module Name:         ivk_video_gen\videosyncgen.vhd
-- Project Name:        IVK
-- Target Devices:      Spartan-6
-- Avnet Boards:        IVK
--
-- Tool versions:       ISE 11.4
--
-- Description:         Video Synchronization Generator
--
-- Dependencies:        
--
-- Revision:            Dec 03, 2009: 1.00 Initial version
--                      Feb 08, 2010: 1.02 Add generation of VBLANK/HBLANK
--                      Jan 12, 2012: 1.07 Modify syncgen for vita receiver
--                                         - fix DE generation 
--                                           (active for VActive lines instead of VActive-1)
--                                         - fix v_VCount_s
--                                         - disable auto restart
--
------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

entity VideoSyncGen is
   generic (
      HWidth_g                   : integer := 16;
      VWidth_g                   : integer := 16 
   );

   port (
      -- Global Reset
      i_Clk_p                    : in std_logic;
      i_Reset_p                  : in std_logic;

      -- 
      i_Restart_p                : in std_logic;

      -- Video Configuration
      iv16_VidHActive_p          : in std_logic_vector(15 downto 0);
      iv16_VidHFPorch_p          : in std_logic_vector(15 downto 0);
      iv16_VidHSync_p            : in std_logic_vector(15 downto 0);
      iv16_VidHBPorch_p          : in std_logic_vector(15 downto 0);
      --
      iv16_VidVActive_p          : in std_logic_vector(15 downto 0);
      iv16_VidVFPorch_p          : in std_logic_vector(15 downto 0);
      iv16_VidVSync_p            : in std_logic_vector(15 downto 0);
      iv16_VidVBPorch_p          : in std_logic_vector(15 downto 0);
      
      -- Video Synchronization Signals
      o_HSync_p                  : out std_logic;
      o_VSync_p                  : out std_logic;
      o_De_p                     : out std_logic;
      o_HBlank_p                 : out std_logic;
      o_VBlank_p                 : out std_logic;

      -- Data Request strobe (1 cycle in advance of synchronization signals)
      ov_HCount_p                : out std_logic_vector(HWidth_g-1 downto 0);
      ov_VCount_p                : out std_logic_vector(VWidth_g-1 downto 0);
      o_PixelRequest_p           : out std_logic
   );
end entity VideoSyncGen;
   
architecture Rtl of VideoSyncGen is

   --
   -- Intermediate signals for output ports
   --
   
   -- Video Synchronization Signals
   signal HSync_s                   : std_logic;
   signal VSync_s                   : std_logic;
   signal De_s                      : std_logic;
   signal HBlank_s                  : std_logic;
   signal VBlank_s                  : std_logic;

   -- Data Request strobe (1 cycle in advance of synchronization signals)
   signal v_HCount_s                : unsigned(HWidth_g-1 downto 0);
   signal v_VCount_s                : unsigned(VWidth_g-1 downto 0);
   signal PixelRequest_s            : std_logic;
   
   
   --
   -- Sync State Machines
   --
   
   type SyncState_t is (
      FrontPorch_c,
      SyncPulse_c,
      BackPorch_c,
      ActiveVideo_c
   );
   signal HSyncState_s              : SyncState_t;
   signal VSyncState_s              : SyncState_t;
   signal VSyncStateD1_s            : SyncState_t;

   attribute fsm_encoding           : string;
   attribute fsm_encoding of HSyncState_s : signal is "sequential";
   attribute fsm_encoding of VSyncState_s : signal is "sequential";
   attribute safe_implementation    : string;
   attribute safe_implementation of HSyncState_s : signal is "yes";
   attribute safe_implementation of VSyncState_s : signal is "yes";
   
   signal v_HSyncCount_s            : unsigned(HWidth_g+1 downto 0);
   signal v_VSyncCount_s            : unsigned(VWidth_g+1 downto 0);
   
   signal HSyncDone_s               : std_logic;
   signal VSyncDone_s               : std_logic;
   
   signal HSyncA1_s                 : std_logic;
   signal VSyncA1_s                 : std_logic;
   signal DeA1_s                    : std_logic;
   signal HBlankA1_s                : std_logic;
   signal VBlankA1_s                : std_logic;

begin

   --
   -- Output port assignments
   --

   -- Video Synchronization Signals
   o_VSync_p                     <= VSync_s;
   o_HSync_p                     <= HSync_s;
   o_De_p                        <= De_s;
   o_HBlank_p                    <= HBlank_s;
   o_VBlank_p                    <= VBlank_s;

   -- Data Request strobe (1 cycle in advance of synchronization signals)
   ov_HCount_p                   <= std_logic_vector(v_HCount_s);
   ov_VCount_p                   <= std_logic_vector(v_VCount_s);
   o_PixelRequest_p              <= PixelRequest_s;

   --
   -- HSync State Machine
   --

   HSyncFsm_l : process ( i_Clk_p, i_Reset_p )
   begin
      if ( i_Reset_p = '1' ) then
         HSyncState_s      <= FrontPorch_c;
         v_HSyncCount_s    <= (others => '0');
         HSyncA1_s         <= '0';
         DeA1_s            <= '0';
         HBlankA1_s        <= '0';
         HSync_s           <= '0';
         De_s              <= '0';
         HBlank_s          <= '0';
         v_HCount_s        <= (others => '0');
         HSyncDone_s       <= '0';
      elsif rising_edge( i_Clk_p ) then

       if ( i_Restart_p = '1' ) then
         -- Start at Active Video
                  v_HSyncCount_s <= (others => '0');
                  HSyncState_s <= ActiveVideo_c;
                  v_HCount_s <= (others => '0');
                  DeA1_s <= '1';
                  HBlankA1_s <= '0';
       else

         -- Default values
         HSyncDone_s <= '0';

         -- HSync Counter
         v_HSyncCount_s <= v_HSyncCount_s + 1;


         -- HSync State Machine
         case HSyncState_s is
         
            when FrontPorch_c =>
               if v_HSyncCount_s >= (unsigned(iv16_VidHFPorch_p) - 1) then
                  v_HSyncCount_s <= (others => '0');
                  HSyncDone_s <= '1';
                  HSyncState_s <= SyncPulse_c;
                  if ( iv16_VidHSync_p(15) = '1' ) then
                     HSyncA1_s <= '1'; -- Active High sync pulse
                  else
                     HSyncA1_s <= '0'; -- Active Low sync pulse
                  end if;
               end if;

            when SyncPulse_c =>
               if v_HSyncCount_s >= (unsigned(iv16_VidHSync_p(14 downto 0)) - 1) then
                  v_HSyncCount_s <= (others => '0');
                  HSyncState_s <= BackPorch_c;
                  if ( iv16_VidHSync_p(15) = '1' ) then
                     HSyncA1_s <= '0'; -- Active High sync pulse
                  else
                     HSyncA1_s <= '1'; -- Active Low sync pulse
                  end if;
               end if;

            when BackPorch_c =>
               if v_HSyncCount_s >= (unsigned(iv16_VidHBPorch_p) - 1) then
                  v_HSyncCount_s <= (others => '0');
                  HSyncState_s <= ActiveVideo_c;
                  v_HCount_s <= (others => '0');
                  if ( VSyncState_s = ActiveVideo_c ) then
                  --if ( VSyncStateD1_s = ActiveVideo_c ) then
                     DeA1_s <= '1';
                  end if;
                  HBlankA1_s <= '0';
               end if;

            when ActiveVideo_c =>
               v_HCount_s <= v_HCount_s + 1;
               if v_HSyncCount_s >= (unsigned(iv16_VidHActive_p) - 1) then
                  v_HSyncCount_s <= (others => '0');
                  HSyncState_s <= FrontPorch_c;
                  DeA1_s <= '0';
                  HBlankA1_s <= '1';
               end if;
               
            when others =>
               HSyncState_s <= ActiveVideo_c;
               v_HSyncCount_s <= (others => '0');
               HSyncDone_s <= '0';
            
         end case;
         
         --  non-advanced versions of synchronization signals (ie. delayed by 1 clock cycle)
         HSync_s  <= HSyncA1_s;
         De_s     <= DeA1_s;
         HBlank_s <= HBlankA1_s;

       end if; -- if ( i_Restart_p = '1' ) then
         
      end if;
   end process HSyncFsm_l;

   -- Pixel Request is advanced version of DE
   PixelRequest_s <= DeA1_s;
   
   --
   -- VSync State Machine
   --

   VSyncFsm_l : process ( i_Clk_p, i_Reset_p )
   begin
      if ( i_Reset_p = '1' ) then
         VSyncState_s      <= FrontPorch_c;
         VSyncStateD1_s    <= FrontPorch_c;
         v_VSyncCount_s    <= (others => '0');
         VSyncA1_s         <= '0';
         VBlankA1_s        <= '0';
         VSync_s           <= '0';
         VBlank_s          <= '0';
         v_VCount_s        <= (others => '0');
         VSyncDone_s       <= '0';
      elsif rising_edge( i_Clk_p ) then

       if ( i_Restart_p = '1' ) then
         -- Start at Active Video
                     v_VSyncCount_s <= (others => '0');
                     VSyncState_s <= ActiveVideo_c;
                     v_VCount_s <= (others => '0');
                     VSyncDone_s <= '1';
                     VBlankA1_s <= '0';
                     VBlank_s <= '0';
                     if ( iv16_VidVSync_p(15) = '1' ) then
                        VSyncA1_s <= '0'; -- Active High sync pulse
                        VSync_s <= '0';
                     else
                        VSyncA1_s <= '1'; -- Active Low sync pulse
                        VSync_s <= '1';
                     end if;       else

         -- Default values
         VSyncDone_s <= '0';
         
         if ( HSyncDone_s = '1' ) then

            -- VSync Counter
            v_VSyncCount_s <= v_VSyncCount_s + 1;

            -- VSync State Machine
            case VSyncState_s is
            
               when FrontPorch_c =>
                  if v_VSyncCount_s >= (unsigned(iv16_VidVFPorch_p) - 1) then
                     v_VSyncCount_s <= (others => '0');
                     VSyncState_s <= SyncPulse_c;
                     if ( iv16_VidVSync_p(15) = '1' ) then
                        VSyncA1_s <= '1'; -- Active High sync pulse
                     else
                        VSyncA1_s <= '0'; -- Active Low sync pulse
                     end if;
                  end if;
                  -- The following assignment is not required
                  --    but conveniently indicates the number of active lines during blanking intervals
                  --v_VCount_s <= unsigned(iv16_VidVActive_p(VWidth_g-1 downto 0));
   
               when SyncPulse_c =>
                  if v_VSyncCount_s >= (unsigned(iv16_VidVSync_p(14 downto 0)) - 1) then
                     v_VSyncCount_s <= (others => '0');
                     VSyncState_s <= BackPorch_c;
                     if ( iv16_VidVSync_p(15) = '1' ) then
                        VSyncA1_s <= '0'; -- Active High sync pulse
                     else
                        VSyncA1_s <= '1'; -- Active Low sync pulse
                     end if;
                  end if;
   
               when BackPorch_c =>
                  --if v_VSyncCount_s >= (unsigned(iv16_VidVBPorch_p) - 1) then
                  --   v_VSyncCount_s <= (others => '0');
                  --   VSyncState_s <= ActiveVideo_c;
                  --   v_VCount_s <= (others => '0');
                  --   VSyncDone_s <= '1';
                  --   VBlankA1_s <= '0';
                  --end if;
                  -- Remain in this state until next i_Restart_p
                  VSyncState_s <= BackPorch_c;
   
               when ActiveVideo_c =>
                  --v_VCount_s <= v_VSyncCount_s(VWidth_g-1 downto 0);
                  v_VCount_s <= v_VSyncCount_s(VWidth_g-1 downto 0) + 1;
                  if v_VSyncCount_s >= (unsigned(iv16_VidVActive_p) - 1) then
                     v_VSyncCount_s <= (others => '0');
                     VSyncState_s <= FrontPorch_c;
                     VBlankA1_s <= '1';
                  end if;
                  
               when others =>
                  VSyncState_s <= ActiveVideo_c;
                  v_VSyncCount_s <= (others => '0');
                  VSyncDone_s <= '0';
               
            end case;
            
            --  non-advanced versions of synchronization signals (ie. delayed by 1 line)
            VSync_s  <= VSyncA1_s;
            VBlank_s <= VBlankA1_s;

            -- delayed version of VSyncState
            VSyncStateD1_s <= VSyncState_s;
            
         end if; -- if ( HSyncDone_s = '1' ) 
         
       end if; -- if ( i_Restart_p = '1' ) then

      end if;
   end process VSyncFsm_l;


end architecture Rtl;
