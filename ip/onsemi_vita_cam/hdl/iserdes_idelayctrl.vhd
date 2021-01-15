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
-- Date           : $Date: 2011-02-01 09:18:32 +0100 (di, 01 feb 2011) $
-- Revision       : $Revision: 747 $
-- *********************************************************************
-- Description
--
-- *********************************************************************

library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity iserdes_idelayctrl is
  generic ( 
    NROF_DELAYCTRLS     : integer;
    IDELAYCLK_MULT      : integer;
    IDELAYCLK_DIV       : integer;
    GENIDELAYCLK        : boolean
    );
  port (
    CLOCK            : in std_logic;             
    RESET            : in std_logic;
    CLK200           : in std_logic;
    idelay_ctrl_rdy  : out std_logic
  );
end entity iserdes_idelayctrl;

architecture syn of iserdes_idelayctrl is

  constant ONES            : std_logic_vector(NROF_DELAYCTRLS-1 downto 0) := (others => '1');
                           
  constant zeros           : std_logic_vector(15 downto 0) := (others => '0');      
  constant zero            : std_logic := '0'; 
  
  signal idelay_ctrl_rdy_i : std_logic_vector(NROF_DELAYCTRLS-1 downto 0);
  
  signal REF_CLK0          : std_logic;     
  signal REF_CLK180        : std_logic;   
  signal REF_CLK270        : std_logic;
  signal REF_CLK2X         : std_logic;
  signal REF_CLK2X180      : std_logic;
  signal REF_CLK90         : std_logic;
  signal REF_CLKDV         : std_logic;
  signal REF_CLKFX         : std_logic;
  signal REF_CLKFX180      : std_logic; 
  
  signal REF_LOCKED        : std_logic;
  signal REF_CLKFB         : std_logic;
  signal REF_CLKIN         : std_logic;
  
  signal RESET_DELAYCTRL   : std_logic; 
  
  signal REF_CLK           : std_logic;   
  
begin


gen_own_clk: if (GENIDELAYCLK = TRUE) generate
--needs bufg on feedback & output

ref_feedback_BUFG_inst : BUFG
port map (
O => REF_CLKFB, -- Clock buffer output
I => REF_CLK0 -- Clock buffer input
);  
  
ref_out_BUFG_inst : BUFG
port map (
O => REF_CLK, -- Clock buffer output
I => REF_CLKFX -- Clock buffer input
);  


REF_CLKIN <= CLOCK;

DCM_ADV_inst : DCM_ADV                                                            
generic map (                                                                 
    CLKDV_DIVIDE            => 2.0, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0                      
    CLKFX_DIVIDE            => IDELAYCLK_DIV, -- Can be any integer from 1 to 32                         
    CLKFX_MULTIPLY          => IDELAYCLK_MULT, -- Can be any integer from 2 to 32                            
    CLKIN_DIVIDE_BY_2       => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature    
    CLKIN_PERIOD            => 10.0, -- Specify period of input clock in ns from 1.25 to 1000.00  
    CLKOUT_PHASE_SHIFT      => "NONE", -- Specify phase shift mode of NONE, FIXED,          
    -- VARIABLE_POSITIVE, VARIABLE_CENTER or DIRECT                                    
    CLK_FEEDBACK            => "1X", -- Specify clock feedback of NONE or 1X                      
    DCM_AUTOCALIBRATION     => TRUE, -- DCM calibration circuitry TRUE/FALSE               
    DCM_PERFORMANCE_MODE    => "MAX_SPEED", -- Can be MAX_SPEED or MAX_RANGE              
    DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS", -- SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
    -- an integer from 0 to 15                                                         
    DFS_FREQUENCY_MODE      => "HIGH", -- HIGH or LOW frequency mode for frequency synthesis 
                                       -- HIGH:  25MHz < CLKIN < 350MHz                                 
                                       --     : 140MHz < CLKFX < 350MHz                                     
    DLL_FREQUENCY_MODE      => "LOW", -- LOW, HIGH, or HIGH_SER frequency mode for DLL      
                                       -- HIGH or LOW frequency mode for frequency synthesis 
    DUTY_CYCLE_CORRECTION   => TRUE,   -- Duty cycle correction, TRUE or FALSE             
    FACTORY_JF              => X"F0F0", -- FACTORY JF Values Suggested to be set to X"F0F0"         
    PHASE_SHIFT             => 0, -- Amount of fixed phase shift from -255 to 1023                 
    SIM_DEVICE              => "VIRTEX5", -- Set target device, "VIRTEX4" or "VIRTEX5"              
    STARTUP_WAIT            => FALSE -- Delay configuration DONE until DCM LOCK, TRUE/FALSE 
    )     
port map (                                                                         
    CLK0            => REF_CLK0,            -- 0 degree DCM CLK output                                           
    CLK180          => REF_CLK180,          -- 180 degree DCM CLK output                                     
    CLK270          => REF_CLK270,          -- 270 degree DCM CLK output                                     
    CLK2X           => REF_CLK2X,           -- 2X DCM CLK output                                               
    CLK2X180        => REF_CLK2X180,        -- 2X, 180 degree DCM CLK out                                
    CLK90           => REF_CLK90,           -- 90 degree DCM CLK output                                        
    CLKDV           => REF_CLKDV,           -- Divided DCM CLK out (CLKDV_DIVIDE)                              
    CLKFX           => REF_CLKFX,           -- DCM CLK synthesis out (M/D)                                     
    CLKFX180        => REF_CLKFX180,        -- 180 degree CLK synthesis out                              
    DO              => open,                -- 16-bit data output for Dynamic Reconfiguration Port (DRP)             
    DRDY            => open,                -- Ready output signal from the DRP                                  
    LOCKED          => REF_LOCKED,          -- DCM LOCK status output                                        
    PSDONE          => open,                -- Dynamic phase adjust done output                              
    CLKFB           => REF_CLKFB,           -- DCM clock feedback                                              
    CLKIN           => REF_CLKIN,           -- Clock input (from IBUFG, BUFG or DCM)                           
    DADDR           => zeros(6 downto 0),   -- 7-bit address for the DRP                                       
    DCLK            => zero,                -- Clock for the DRP                                                 
    DEN             => zero,                -- Enable input for the DRP                                            
    DI              => zeros(15 downto 0),  -- 16-bit data input for the DRP                                         
    DWE             => zero,                -- Active high allows for writing configuration memory                 
    PSCLK           => zero,                -- Dynamic phase adjust clock input                                
    PSEN            => zero,                -- Dynamic phase adjust enable input                                 
    PSINCDEC        => zero,                -- Dynamic phase adjust increment/decrement                  
    RST             => RESET                -- DCM asynchronous reset input                                         
);

RESET_DELAYCTRL <= not REF_LOCKED;

end generate;

use_ext_clk: if (GENIDELAYCLK = FALSE) generate

RESET_DELAYCTRL <= RESET;
REF_CLK <= CLK200;

end generate;



IDELAYCTRL_INST : for bnk_i in 0 to NROF_DELAYCTRLS-1 generate
  u_idelayctrl : IDELAYCTRL
    port map (
      rdy     => idelay_ctrl_rdy_i(bnk_i),
      refclk  => REF_CLK,
      rst     => RESET_DELAYCTRL
    );
end generate IDELAYCTRL_INST;

idelay_ctrl_rdy <= '1' when (idelay_ctrl_rdy_i = ONES) else
                   '0';

end architecture syn;
