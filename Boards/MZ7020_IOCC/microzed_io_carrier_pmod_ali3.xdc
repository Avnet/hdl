# ----------------------------------------------------------------------------
#       _____
#      *     *
#     *____   *____
#    * *===*   *==*
#   *___*===*___**  AVNET
#        *======*
#         *====*
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions or issues to the MicroZed Community Forums:
#      http://www.microzed.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2014 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         December 02, 2014
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq-7020
#  Hardware Boards:     MicroZed, IO Carrier
# 
#  Tool versions:       Vivado 2014.4
# 
#  Description:         Build Script for MicroZed IO Carrier
# 
#  Dependencies:        To be called from a project build script
# 
# ----------------------------------------------------------------------------

########################
# Physical Constraints #
########################

# Clock, clock enable, and reset
set_property PACKAGE_PIN K17 [get_ports {CLK_100MHZ}];  # "BB_CLK"
set_property IOSTANDARD LVCMOS33 [get_ports {CLK_100MHZ}];

set_property PACKAGE_PIN K18 [get_ports {CLK_EN}];  # "BB_CLK_EN"
set_property IOSTANDARD LVCMOS33 [get_ports {CLK_EN}];

#set_property PACKAGE_PIN G20 [get_ports {USER_RESET}];  # "PB3"
#set_property IOSTANDARD LVCMOS33 [get_ports {USER_RESET}];

#
# MicroZed with IO Carrier - User I/O constraints
#


# ----------------------------------------------------------------------------
# JC Pmod 
#  -- MAXIM Corona ISO Dig Input Using TOP JC pins (1-4)
#  -- MAXIM Lakewood ISO Power Supply Using BOTTOM JC pins (7-10)
# ---------------------------------------------------------------------------- 
set_property SLEW SLOW           [get_ports {JC_SPI_CS_N}];
set_property SLEW SLOW           [get_ports {JC_SPI_MOSI}];
set_property SLEW SLOW           [get_ports {JC_SPI_MISO}];
set_property SLEW SLOW           [get_ports {JC_SPI_SCK}];
#set_property SLEW SLOW           [get_ports {JC_SPI_CS_N2}];
#set_property SLEW SLOW           [get_ports {JC_SPI_MOSI2}];
#set_property SLEW SLOW           [get_ports {JC_SPI_MISO2}];
#set_property SLEW SLOW           [get_ports {JC_SPI_SCK2}];
set_property IOSTANDARD LVCMOS33 [get_ports {JC_SPI_CS_N}];
set_property IOSTANDARD LVCMOS33 [get_ports {JC_SPI_MOSI}];
set_property IOSTANDARD LVCMOS33 [get_ports {JC_SPI_MISO}];
set_property IOSTANDARD LVCMOS33 [get_ports {JC_SPI_SCK}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JC_SPI_CS_N2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JC_SPI_MOSI2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JC_SPI_MISO2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JC_SPI_SCK2}];
# rewired as moved corona board set_property PACKAGE_PIN N18     [get_ports {JC_SPI_CS_N}];     # "JX1_JC0-1_P" Pin 1
# rewired as moved corona board set_property PACKAGE_PIN P19     [get_ports {JC_SPI_MOSI}];     # "JX1_JC0-1_N" Pin 2
# rewired as moved corona board set_property PACKAGE_PIN N20     [get_ports {JC_SPI_MISO}];     # "JX1_JC2-3_P" Pin 3
# rewired as moved corona board set_property PACKAGE_PIN P20     [get_ports {JC_SPI_SCK}];      # "JX1_JC2-3_N" Pin 4
set_property PACKAGE_PIN R16     [get_ports {JC_SPI_CS_N}];     # "JX1_JC0-1_P" Pin 1
set_property PACKAGE_PIN R17     [get_ports {JC_SPI_MOSI}];     # "JX1_JC0-1_N" Pin 2
set_property PACKAGE_PIN T17     [get_ports {JC_SPI_MISO}];     # "JX1_JC2-3_P" Pin 3
set_property PACKAGE_PIN R18     [get_ports {JC_SPI_SCK}];      # "JX1_JC2-3_N" Pin 4
#set_property PACKAGE_PIN T20     [get_ports {JC_SPI_CS_N2}];    # "JX1_JC4-5_P" Pin 7
#set_property PACKAGE_PIN U20     [get_ports {JC_SPI_MOSI2}];    # "JX1_JC4-5_N" Pin 8
#set_property PACKAGE_PIN V20     [get_ports {JC_SPI_MISO2}];    # "JX1_JC6-7_P" Pin 9
#set_property PACKAGE_PIN W20     [get_ports {JC_SPI_SCK2}];     # "JX1_JC6-7_N" Pin 10


## ----------------------------------------------------------------------------
## JD Pmod 
##  -- MAXIM Santa Fe ISO AFE Using TOP JD pins (1-4)
##  -- ?? Using BOTTOM JD pins (7-10)
## ---------------------------------------------------------------------------- 
#set_property SLEW SLOW           [get_ports {JD_SPI_CS_N}];
#set_property SLEW SLOW           [get_ports {JD_SPI_MOSI}];
#set_property SLEW SLOW           [get_ports {JD_SPI_MISO}];
#set_property SLEW SLOW           [get_ports {JD_SPI_SCK}];
#set_property SLEW SLOW           [get_ports {JD_SPI_CS_N2}];
#set_property SLEW SLOW           [get_ports {JD_SPI_MOSI2}];
#set_property SLEW SLOW           [get_ports {JD_SPI_MISO2}];
#set_property SLEW SLOW           [get_ports {JD_SPI_SCK2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JD_SPI_CS_N}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JD_SPI_MOSI}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JD_SPI_MISO}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JD_SPI_SCK}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JD_SPI_CS_N2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JD_SPI_MOSI2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JD_SPI_MISO2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JD_SPI_SCK2}];
#set_property PACKAGE_PIN R16     [get_ports {JD_SPI_CS_N}];     # "JX1_JD0-1_P" Pin 1
#set_property PACKAGE_PIN R17     [get_ports {JD_SPI_MOSI}];     # "JX1_JD0-1_N" Pin 2
#set_property PACKAGE_PIN T17     [get_ports {JD_SPI_MISO}];     # "JX1_JD2-3_P" Pin 3
#set_property PACKAGE_PIN R18     [get_ports {JD_SPI_SCK}];      # "JX1_JD2-3_N" Pin 4
#set_property PACKAGE_PIN V17     [get_ports {JD_SPI_CS_N2}];    # "JX1_JD4-5_P" Pin 7
#set_property PACKAGE_PIN V18     [get_ports {JD_SPI_MOSI2}];    # "JX1_JD4-5_N" Pin 8
#set_property PACKAGE_PIN W18     [get_ports {JD_SPI_MISO2}];    # "JX1_JD6-7_P" Pin 9
#set_property PACKAGE_PIN W19     [get_ports {JD_SPI_SCK2}];     # "JX1_JD6-7_N" Pin 10
#
#
## ----------------------------------------------------------------------------
## JE Pmod 
##  -- TI LDC1000 Using TOP JE pins (1-4)
##  -- ?? Using BOTTOM JE pins (7-10)
## ---------------------------------------------------------------------------- 
#set_property SLEW SLOW           [get_ports {JE_SPI_CS_N}];
#set_property SLEW SLOW           [get_ports {JE_SPI_MOSI}];
#set_property SLEW SLOW           [get_ports {JE_SPI_MISO}];
#set_property SLEW SLOW           [get_ports {JE_SPI_SCK}];
#set_property SLEW SLOW           [get_ports {JE_SPI_CS_N2}];
#set_property SLEW SLOW           [get_ports {JE_SPI_MOSI2}];
#set_property SLEW SLOW           [get_ports {JE_SPI_MISO2}];
#set_property SLEW SLOW           [get_ports {JE_SPI_SCK2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JE_SPI_CS_N}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JE_SPI_MOSI}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JE_SPI_MISO}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JE_SPI_SCK}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JE_SPI_CS_N2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JE_SPI_MOSI2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JE_SPI_MISO2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JE_SPI_SCK2}];
#set_property PACKAGE_PIN E17     [get_ports {JE_SPI_CS_N}];     # "JX2_JE0-1_P"   Pin 1
#set_property PACKAGE_PIN D18     [get_ports {JE_SPI_MOSI}];     # "JX2_JE0-1_N"   Pin 2
#set_property PACKAGE_PIN D19     [get_ports {JE_SPI_MISO}];     # "JX2_JE2-3_P"   Pin 3
#set_property PACKAGE_PIN D20     [get_ports {JE_SPI_SCK}];      # "JX2_JE2-3_N"   Pin 4
#set_property PACKAGE_PIN E18     [get_ports {JE_SPI_CS_N2}];    # "JX2_JE4-5_P"   Pin 7
#set_property PACKAGE_PIN E19     [get_ports {JE_SPI_MOSI2}];    # "JX2_JE4-5_N"   Pin 8
#set_property PACKAGE_PIN F17     [get_ports {JE_SPI_MISO2}];    # "JX2_JE6-7_P"   Pin 9
#set_property PACKAGE_PIN F16     [get_ports {JE_SPI_SCK2}];     # "JX2_JE6-7_N"   Pin 10
#
#
## ----------------------------------------------------------------------------
## JF Pmod 
##  -- ADI CN0354 4 CH Thermocouple Using TOP JF pins (1-4)
##  -- ADI CN0241 High-Side Current Sense Using BOTTOM JF pins (7-10) 
##  --  Note: CN0241 does NOT use a standard PMOD pinout
## ---------------------------------------------------------------------------- 
#set_property SLEW SLOW           [get_ports {JF_SPI_CS_N}];
#set_property SLEW SLOW           [get_ports {JF_SPI_MOSI}];
#set_property SLEW SLOW           [get_ports {JF_SPI_MISO}];
#set_property SLEW SLOW           [get_ports {JF_SPI_SCK}];
#set_property SLEW SLOW           [get_ports {JF_SPI_CS_N2}];
#set_property SLEW SLOW           [get_ports {JF_SPI_MOSI2}];
#set_property SLEW SLOW           [get_ports {JF_SPI_MISO2}];
#set_property SLEW SLOW           [get_ports {JF_SPI_SCK2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JF_SPI_CS_N}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JF_SPI_MOSI}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JF_SPI_MISO}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JF_SPI_SCK}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JF_SPI_CS_N2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JF_SPI_MOSI2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JF_SPI_MISO2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JF_SPI_SCK2}];
#set_property PACKAGE_PIN L19     [get_ports {JF_SPI_CS_N}];     # "JX2_JF0-1_P" Pin 1
#set_property PACKAGE_PIN L20     [get_ports {JF_SPI_MOSI}];     # "JX2_JF0-1_N" Pin 2
#set_property PACKAGE_PIN M19     [get_ports {JF_SPI_MISO}];     # "JX2_JF2-3_P" Pin 3
#set_property PACKAGE_PIN M20     [get_ports {JF_SPI_SCK}];      # "JX2_JF2-3_N" Pin 4
##    Note: CN0241 does NOT use a standard PMOD pinout
##    JF_SPI_MOSI2 is a placeholder for this board, as this pin is /SD_SDP
#set_property PACKAGE_PIN M17     [get_ports {JF_SPI_MOSI2}];    # "JX2_JF4-5_P" Pin 7
#set_property PACKAGE_PIN M18     [get_ports {JF_SPI_SCK2}];    # "JX2_JF4-5_N" Pin 8
#set_property PACKAGE_PIN J19     [get_ports {JF_SPI_MISO2}];    # "JX2_JF6-7_P" Pin 9
#set_property PACKAGE_PIN K19     [get_ports {JF_SPI_CS_N2}];     # "JX2_JF6-7_N" Pin 10
#
#
## ----------------------------------------------------------------------------
## JG Pmod 
##  -- ADI CN0303 MEMS Vibration Analyzer Using TOP JG pins (1-4)
##  -- ADI CN0332 MR Speed Sensor Using BOTTOM JG pins (7-10)
## ---------------------------------------------------------------------------- 
#set_property SLEW SLOW           [get_ports {JG_SPI_CS_N}];
#set_property SLEW SLOW           [get_ports {JG_SPI_MOSI}];
#set_property SLEW SLOW           [get_ports {JG_SPI_MISO}];
#set_property SLEW SLOW           [get_ports {JG_SPI_SCK}];
#set_property SLEW SLOW           [get_ports {JG_SPI_CS_N2}];
#set_property SLEW SLOW           [get_ports {JG_SPI_MOSI2}];
#set_property SLEW SLOW           [get_ports {JG_SPI_MISO2}];
#set_property SLEW SLOW           [get_ports {JG_SPI_SCK2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JG_SPI_CS_N}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JG_SPI_MOSI}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JG_SPI_MISO}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JG_SPI_SCK}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JG_SPI_CS_N2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JG_SPI_MOSI2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JG_SPI_MISO2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JG_SPI_SCK2}];
#set_property PACKAGE_PIN G17     [get_ports {JG_SPI_CS_N}];     # "JX2_JG0-1_P" Pin 1
#set_property PACKAGE_PIN G18     [get_ports {JG_SPI_MOSI}];     # "JX2_JG0-1_N" Pin 2
#set_property PACKAGE_PIN F19     [get_ports {JG_SPI_MISO}];     # "JX2_JG2-3_P" Pin 3
#set_property PACKAGE_PIN F20     [get_ports {JG_SPI_SCK}];      # "JX2_JG2-3_N" Pin 4
#set_property PACKAGE_PIN H16     [get_ports {JG_SPI_CS_N2}];    # "JX2_JG4-5_P" Pin 7
#set_property PACKAGE_PIN H17     [get_ports {JG_SPI_MOSI2}];    # "JX2_JG4-5_N" Pin 8
#set_property PACKAGE_PIN J18     [get_ports {JG_SPI_MISO2}];    # "JX2_JG6-7_P" Pin 9
#set_property PACKAGE_PIN H18     [get_ports {JG_SPI_SCK2}];     # "JX2_JG6-7_N" Pin 10
#
#
## ----------------------------------------------------------------------------
## JH Pmod 
##  -- ST STEVAL-MKI154V1+MKI109V2 TOP JH pins (1-4)
##  -- FREESCALE Pressure Transducer Using BOTTOM JH pins (7-10)
## ---------------------------------------------------------------------------- 
#set_property SLEW SLOW           [get_ports {JH_SPI_CS_N}];
#set_property SLEW SLOW           [get_ports {JH_SPI_MOSI}];
#set_property SLEW SLOW           [get_ports {JH_SPI_MISO}];
#set_property SLEW SLOW           [get_ports {JH_SPI_SCK}];
#set_property SLEW SLOW           [get_ports {JH_SPI_CS_N2}];
#set_property SLEW SLOW           [get_ports {JH_SPI_MOSI2}];
#set_property SLEW SLOW           [get_ports {JH_SPI_MISO2}];
#set_property SLEW SLOW           [get_ports {JH_SPI_SCK2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JH_SPI_CS_N}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JH_SPI_MOSI}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JH_SPI_MISO}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JH_SPI_SCK}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JH_SPI_CS_N2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JH_SPI_MOSI2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JH_SPI_MISO2}];
#set_property IOSTANDARD LVCMOS33 [get_ports {JH_SPI_SCK2}];
#set_property PACKAGE_PIN K14     [get_ports {JH_SPI_CS_N}];     # "JX2_JH0-1_P" Pin 1
#set_property PACKAGE_PIN J14     [get_ports {JH_SPI_MOSI}];     # "JX2_JH0-1_N" Pin 2
#set_property PACKAGE_PIN H15     [get_ports {JH_SPI_MISO}];     # "JX2_JH2-3_P" Pin 3
#set_property PACKAGE_PIN G15     [get_ports {JH_SPI_SCK}];      # "JX2_JH2-3_N" Pin 4
#set_property PACKAGE_PIN N15     [get_ports {JH_SPI_CS_N2}];    # "JX2_JH4-5_P" Pin 7
#set_property PACKAGE_PIN N16     [get_ports {JH_SPI_MOSI2}];    # "JX2_JH4-5_N" Pin 8
#set_property PACKAGE_PIN L14     [get_ports {JH_SPI_MISO2}];    # "JX2_JH6-7_P" Pin 9
#set_property PACKAGE_PIN L15     [get_ports {JH_SPI_SCK2}];     # "JX2_JH6-7_N" Pin 10



##
### User PL DIP Switches which are on the VADJ powered Bank 35
set_property IOSTANDARD LVCMOS33 [get_ports {DIP_SW1}];
set_property IOSTANDARD LVCMOS33 [get_ports {DIP_SW2}];
set_property IOSTANDARD LVCMOS33 [get_ports {DIP_SW3}];
set_property IOSTANDARD LVCMOS33 [get_ports {DIP_SW4}];
set_property PACKAGE_PIN M14 [get_ports {DIP_SW1}];  # "JX2_DIP_SW1"
set_property PACKAGE_PIN M15 [get_ports {DIP_SW2}];  # "JX2_DIP_SW2"
set_property PACKAGE_PIN K16 [get_ports {DIP_SW3}];  # "JX2_DIP_SW3"
set_property PACKAGE_PIN J16 [get_ports {DIP_SW4}];  # "JX2_DIP_SW4"
##set_property PACKAGE_PIN P19 [get_ports {emio_user_tri_io[11]}];  # "JX1_JC0-1_N"
##

##
### User PL LEDs which are on the VADJ powered Bank 34
set_property DRIVE 12 [get_ports {LED_D1}];
set_property DRIVE 12 [get_ports {LED_D2}];
set_property DRIVE 12 [get_ports {LED_D3}];
set_property DRIVE 12 [get_ports {LED_D4}];
set_property DRIVE 12 [get_ports {LED_D5}];
set_property DRIVE 12 [get_ports {LED_D6}];
set_property DRIVE 12 [get_ports {LED_D7}];
set_property DRIVE 12 [get_ports {LED_D8}];
set_property SLEW SLOW [get_ports {LED_D1}];
set_property SLEW SLOW [get_ports {LED_D2}];
set_property SLEW SLOW [get_ports {LED_D3}];
set_property SLEW SLOW [get_ports {LED_D4}];
set_property SLEW SLOW [get_ports {LED_D5}];
set_property SLEW SLOW [get_ports {LED_D6}];
set_property SLEW SLOW [get_ports {LED_D7}];
set_property SLEW SLOW [get_ports {LED_D8}];
set_property IOSTANDARD LVCMOS33 [get_ports {LED_D1}];
set_property IOSTANDARD LVCMOS33 [get_ports {LED_D2}];
set_property IOSTANDARD LVCMOS33 [get_ports {LED_D3}];
set_property IOSTANDARD LVCMOS33 [get_ports {LED_D4}];
set_property IOSTANDARD LVCMOS33 [get_ports {LED_D5}];
set_property IOSTANDARD LVCMOS33 [get_ports {LED_D6}];
set_property IOSTANDARD LVCMOS33 [get_ports {LED_D7}];
set_property IOSTANDARD LVCMOS33 [get_ports {LED_D8}];
set_property PACKAGE_PIN U14 [get_ports {LED_D1}];  # "JX1_LED1"
set_property PACKAGE_PIN U15 [get_ports {LED_D2}];  # "JX1_LED2"
set_property PACKAGE_PIN U18 [get_ports {LED_D3}];  # "JX1_LED3"
set_property PACKAGE_PIN U19 [get_ports {LED_D4}];  # "JX1_LED4"
set_property PACKAGE_PIN R19 [get_ports {LED_D5}];  # "JX1_LED5"
set_property PACKAGE_PIN V13 [get_ports {LED_D6}];  # "JX1_LED6"
set_property PACKAGE_PIN P14 [get_ports {LED_D7}];  # "JX1_LED7"
set_property PACKAGE_PIN R14 [get_ports {LED_D8}];  # "JX1_LED8"
##

## JY P4 SERVO_PWM output
#set_property DRIVE 12 [get_ports {SERVO_PWM}];
set_property SLEW SLOW [get_ports {SERVO_PWM}];
set_property IOSTANDARD LVCMOS33 [get_ports {SERVO_PWM}];
#set_property PACKAGE_PIN U10 [get_ports {SERVO_PWM}];  # "JX1_JY2-3_N" Pin 4
# set to pin 1 on JF
set_property PACKAGE_PIN L19 [get_ports {SERVO_PWM}];  # "JX2_JF0-1_P" Pin 1

### User PL Push Buttons which are on the VADJ powered Bank 35
##set_property PACKAGE_PIN N18 [get_ports {emio_user_tri_io[15]}];  # "JX1_JC0-1_P"
set_property IOSTANDARD LVCMOS33 [get_ports {USER_PB1}];
set_property IOSTANDARD LVCMOS33 [get_ports {USER_PB2}];
set_property IOSTANDARD LVCMOS33 [get_ports {USER_PB3}];
set_property IOSTANDARD LVCMOS33 [get_ports {USER_PB4}];
set_property PACKAGE_PIN G19 [get_ports {USER_PB1}];  # "JX2_PB1"
set_property PACKAGE_PIN G20 [get_ports {USER_PB2}];  # "JX2_PB2"
set_property PACKAGE_PIN J20 [get_ports {USER_PB3}];  # "JX2_PB3"
set_property PACKAGE_PIN H20 [get_ports {USER_PB4}];  # "JX2_PB4"

# needed?
#set_property IOB TRUE [all_fanin -only_cells -startpoints_only -flat [all_outputs]]

##################
# Primary Clocks #
##################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 12.999 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period  7.000 -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]
#create_clock -period 10.000 -name clk_fpga_2 [get_nets -hierarchical FCLK_CLK2]

####################
# Generated Clocks #
####################

# Rename auto-generated clocks from MMCM
#create_generated_clock -name ali3_clk [get_pins tutorial_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]

################
# Clock Groups #
################

#set_clock_groups -asynchronous -group [get_clocks "clk_fpga_0" ] -group [get_clocks "clk_fpga_1" ] -group [get_clocks "ali3_clk" ]

