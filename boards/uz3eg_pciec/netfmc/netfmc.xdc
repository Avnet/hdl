# ----------------------------------------------------------------------------
#
#        ** **        **          **  ****      **  **********  ********** ®
#       **   **        **        **   ** **     **  **              **
#      **     **        **      **    **  **    **  **              **
#     **       **        **    **     **   **   **  *********       **
#    **         **        **  **      **    **  **  **              **
#   **           **        ****       **     ** **  **              **
#  **  .........  **        **        **      ****  **********      **
#     ...........
#                                     Reach Further™
#
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions to the UltraZed community support forum:
#     http://www.ultrazed.org/forum
# 
#  Product information is available at:
#     http://www.ultrazed.org/product/ultrazed
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2017 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         May 31, 2018
#  Design Name:         UltraZed CCD HW Platform
#  Module Name:         uz3eg_pciec_ccd.xdc
#  Project Name:        UltraZed CCD
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     UltraZed SOM
# 
#  Tool versions:       Vivado 2017.4
# 
#  Description:         Build Script for UltraZed CCD HW Platform
# 
#  Dependencies:        None
# 
#
#  Revision:            May 31, 2018: 1.00 Created based upon uz_pciec_factest
#                                          project but adds support for Avnet 
#                                          FMC-Network1 expansion card.
#                       Jun 25, 2018: 1.01 Added I2C ports for MAC ID EEPROMs
# 
# ----------------------------------------------------------------------------
# 
#  Notes: 
# 
#  Thursday, May 31, 2018
#
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
# 
# ----------------------------------------------------------------------------

## SYSMON
#set_property IOSTANDARD ANALOG [get_ports Vp_Vn_v_p]
#set_property IOSTANDARD ANALOG [get_ports Vp_Vn_v_n]


## PL DIP Switches

#set_property PACKAGE_PIN H1 [get_ports {dip_switches_8bits_tri_i[0]}]		;# JX2_HP_DP_17_P
#set_property PACKAGE_PIN G1 [get_ports {dip_switches_8bits_tri_i[1]}]		;# JX2_HP_DP_17_N
#set_property PACKAGE_PIN G7 [get_ports {dip_switches_8bits_tri_i[2]}]		;# JX2_HP_DP_19_P
#set_property PACKAGE_PIN F7 [get_ports {dip_switches_8bits_tri_i[3]}]		;# JX2_HP_DP_19_N
#set_property PACKAGE_PIN G8 [get_ports {dip_switches_8bits_tri_i[4]}]		;# JX2_HP_DP_21_P
#set_property PACKAGE_PIN F8 [get_ports {dip_switches_8bits_tri_i[5]}]		;# JX2_HP_DP_21_N
#set_property PACKAGE_PIN B3 [get_ports {dip_switches_8bits_tri_i[6]}]		;# JX2_HP_DP_23_P
#set_property PACKAGE_PIN B2 [get_ports {dip_switches_8bits_tri_i[7]}]		;# JX2_HP_DP_23_N

#set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[4]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[5]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[6]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[7]}]


## PL LEDs 

#set_property PACKAGE_PIN C8 [get_ports {led_8bits_tri_o[0]}]		;# JX2_HP_DP_16_P
#set_property PACKAGE_PIN B8 [get_ports {led_8bits_tri_o[1]}]		;# JX2_HP_DP_16_N
#set_property PACKAGE_PIN A6 [get_ports {led_8bits_tri_o[2]}]		;# JX2_HP_DP_18_P
#set_property PACKAGE_PIN A5 [get_ports {led_8bits_tri_o[3]}]		;# JX2_HP_DP_18_N
#set_property PACKAGE_PIN H6 [get_ports {led_8bits_tri_o[4]}]		;# JX2_HP_DP_20_P
#set_property PACKAGE_PIN G6 [get_ports {led_8bits_tri_o[5]}]		;# JX2_HP_DP_20_N
#set_property PACKAGE_PIN G5 [get_ports {led_8bits_tri_o[6]}]		;# JX2_HP_DP_22_P
#set_property PACKAGE_PIN F5 [get_ports {led_8bits_tri_o[7]}]		;# JX2_HP_DP_22_N

#set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[4]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[5]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[6]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[7]}]


## PL Push Switches

#set_property PACKAGE_PIN D8 [get_ports {push_buttons_4bits_tri_i[0]}]		;# JX2_HP_SE_00
#set_property PACKAGE_PIN E7 [get_ports {push_buttons_4bits_tri_i[1]}]		;# JX2_HP_SE_01
#set_property PACKAGE_PIN A4 [get_ports {push_buttons_4bits_tri_i[2]}]		;# JX2_HP_SE_02
#set_property PACKAGE_PIN H5 [get_ports {push_buttons_4bits_tri_i[3]}]		;# JX2_HP_SE_03

#set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[3]}]   

#
# FMC LPC Interface - FMC-Network1
#
set_property PACKAGE_PIN P3 [get_ports {ref_clk_fsel[0]}]
set_property PACKAGE_PIN N1 [get_ports {ref_clk_oe[0]}]
set_property PACKAGE_PIN P4 [get_ports {ref_clk_clk_p}]
set_property PACKAGE_PIN R4 [get_ports {ref_clk_clk_n}]

set_property IOSTANDARD LVCMOS18 [get_ports {ref_clk_fsel[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ref_clk_oe[0]}]
set_property IOSTANDARD LVDS [get_ports {ref_clk_clk_n}]
set_property IOSTANDARD LVDS [get_ports {ref_clk_clk_p}]

# Ethernet port 0
set_property PACKAGE_PIN M5 [get_ports {reset_port_0}]
set_property PACKAGE_PIN N5 [get_ports mdio_port_0_mdc]
set_property PACKAGE_PIN L5 [get_ports mdio_port_0_mdio_io]

set_property PACKAGE_PIN M3 [get_ports rgmii_port_0_rxc]
set_property PACKAGE_PIN L3 [get_ports rgmii_port_0_rx_ctl]
set_property PACKAGE_PIN R1 [get_ports {rgmii_port_0_rd[3]}]
set_property PACKAGE_PIN R2 [get_ports {rgmii_port_0_rd[2]}]
set_property PACKAGE_PIN K2 [get_ports {rgmii_port_0_rd[1]}]
set_property PACKAGE_PIN L2 [get_ports {rgmii_port_0_rd[0]}]

set_property PACKAGE_PIN K5 [get_ports rgmii_port_0_txc]
set_property PACKAGE_PIN V1 [get_ports rgmii_port_0_tx_ctl]
set_property PACKAGE_PIN U1 [get_ports {rgmii_port_0_td[3]}]
set_property PACKAGE_PIN J4 [get_ports {rgmii_port_0_td[2]}]
set_property PACKAGE_PIN K4 [get_ports {rgmii_port_0_td[1]}]
set_property PACKAGE_PIN K6 [get_ports {rgmii_port_0_td[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {reset_port_0}]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_port_0_mdc]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_port_0_mdio_io]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_0_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_0_rx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_rd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_rd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_rd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_rd[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_0_txc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_0_tx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_td[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_td[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_td[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_td[0]}]

# Ethernet port 0
set_property PACKAGE_PIN W7 [get_ports {reset_port_1}]
set_property PACKAGE_PIN P1 [get_ports mdio_port_1_mdc]
set_property PACKAGE_PIN P2 [get_ports mdio_port_1_mdio_io]

set_property PACKAGE_PIN N4 [get_ports rgmii_port_1_rxc]
set_property PACKAGE_PIN N3 [get_ports rgmii_port_1_rx_ctl]
set_property PACKAGE_PIN J6 [get_ports {rgmii_port_1_rd[3]}]
set_property PACKAGE_PIN K7 [get_ports {rgmii_port_1_rd[2]}]
set_property PACKAGE_PIN J7 [get_ports {rgmii_port_1_rd[1]}]
set_property PACKAGE_PIN M6 [get_ports {rgmii_port_1_rd[0]}]

set_property PACKAGE_PIN U2 [get_ports rgmii_port_1_txc]
set_property PACKAGE_PIN W8 [get_ports rgmii_port_1_tx_ctl]
set_property PACKAGE_PIN T7 [get_ports {rgmii_port_1_td[3]}]
set_property PACKAGE_PIN R7 [get_ports {rgmii_port_1_td[2]}]
set_property PACKAGE_PIN T3 [get_ports {rgmii_port_1_td[1]}]
set_property PACKAGE_PIN V3 [get_ports {rgmii_port_1_td[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {reset_port_1}]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_port_1_mdc]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_port_1_mdio_io]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_1_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_1_rx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_rd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_rd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_rd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_rd[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_1_txc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_1_tx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_td[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_td[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_td[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_td[0]}]

# Ethernet PHY LEDs
set_property PACKAGE_PIN AA3 [get_ports {leds_fmcnet_10bits_tri_o[9]}];  # JX1_HP_DP_08_N - FMC_LA28_N
set_property PACKAGE_PIN AA4 [get_ports {leds_fmcnet_10bits_tri_o[8]}];  # JX1_HP_DP_08_P - FMC_LA28_P
set_property PACKAGE_PIN AD7 [get_ports {leds_fmcnet_10bits_tri_o[7]}];  # JX1_HP_DP_07_N - FMC_LA24_N
set_property PACKAGE_PIN AD8 [get_ports {leds_fmcnet_10bits_tri_o[6]}];  # JX1_HP_DP_07_P - FMC_LA24_P
set_property PACKAGE_PIN Y1  [get_ports {leds_fmcnet_10bits_tri_o[5]}];  # JX1_HP_DP_09_N - FMC_LA25_N
set_property PACKAGE_PIN W1  [get_ports {leds_fmcnet_10bits_tri_o[4]}];  # JX1_HP_DP_09_P - FMC_LA25_P
set_property PACKAGE_PIN W2  [get_ports {leds_fmcnet_10bits_tri_o[3]}];  # JX1_HP_DP_12_N - FMC_LA26_N
set_property PACKAGE_PIN W3  [get_ports {leds_fmcnet_10bits_tri_o[2]}];  # JX1_HP_DP_12_P - FMC_LA26_P
set_property PACKAGE_PIN AA2 [get_ports {leds_fmcnet_10bits_tri_o[1]}];  # JX1_HP_DP_14_N - FMC_LA27_N
set_property PACKAGE_PIN Y2  [get_ports {leds_fmcnet_10bits_tri_o[0]}];  # JX1_HP_DP_14_P - FMC_LA27_P

set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_fmcnet_10bits_tri_o[0]}]

# FMC I2C busses
set_property PACKAGE_PIN B10  [get_ports {iic_rtl_0_sda_io}];   # JX2_HD_SE_01_N - FMC_SDA
set_property PACKAGE_PIN C10  [get_ports {iic_rtl_0_scl_io}];   # JX2_HD_SE_01_P - FMC_SCL
set_property PACKAGE_PIN AB8  [get_ports {iic_rtl_1_scl_io}];   # JX1_HP_DP_00_P - FMC_LA32_P - SCL1
set_property PACKAGE_PIN AB7  [get_ports {iic_rtl_1_sda_io}];   # JX1_HP_DP_00_N - FMC_LA32_N - SDA1
set_property PACKAGE_PIN AE7  [get_ports {iic_rtl_2_scl_io}];   # JX1_HP_DP_06_P - FMC_LA31_P - SCL2
set_property PACKAGE_PIN AE6  [get_ports {iic_rtl_2_sda_io}];   # JX1_HP_DP_06_N - FMC_LA31_N - SDA2

set_property IOSTANDARD LVCMOS33 [get_ports {iic_rtl_0_sda_io}]
set_property IOSTANDARD LVCMOS33 [get_ports {iic_rtl_0_scl_io}]
set_property IOSTANDARD LVCMOS18 [get_ports {iic_rtl_1_scl_io}]
set_property IOSTANDARD LVCMOS18 [get_ports {iic_rtl_1_sda_io}]
set_property IOSTANDARD LVCMOS18 [get_ports {iic_rtl_2_scl_io}]
set_property IOSTANDARD LVCMOS18 [get_ports {iic_rtl_2_sda_io}]

# FMC card present
set_property PACKAGE_PIN H9   [get_ports {FMC_PRSNT_M2C_N}];    # JX2_HD_SE_00_N - FMC_PRSNT_M2C_N
set_property PACKAGE_PIN H10  [get_ports {FMC_TRST_N}];  	    # JX2_HD_SE_00_P - FMC_TRST_N

set_property IOSTANDARD LVCMOS33 [get_ports {FMC_PRSNT_M2C_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {FMC_TRST_N}]

# The following constraints force placement of the BUFGs needed by the RGMII RX clock for Ethernet FMC ports 2 and 3
# Without these constraints, timing will not close because the BUFGCE selected by Vivado is too far.
# It is actually not recommended to use LOC constraints on BUFGCEs but instead to constrain placement to a clock 
# region, but in Vivado 2017.2, even this does not result a good placement of BUFGCE and timing closure.

#set_property BEL BUFCE [get_cells *_i/gmii_to_rgmii_2/U0/i_gmii_to_rgmii_block/*_0_core/i_gmii_to_rgmii/i_gmii_to_rgmii/gen_rgmii_rx_clk_zq.bufg_rgmii_rx_clk]
#set_property LOC BUFGCE_X0Y15 [get_cells *_i/gmii_to_rgmii_2/U0/i_gmii_to_rgmii_block/*_0_core/i_gmii_to_rgmii/i_gmii_to_rgmii/gen_rgmii_rx_clk_zq.bufg_rgmii_rx_clk]
#set_property BEL BUFCE [get_cells *_i/gmii_to_rgmii_2/U0/i_gmii_to_rgmii_block/*_0_core/i_gmii_to_rgmii/i_gmii_to_rgmii/gen_rgmii_rx_clk_zq.bufio_rgmii_rx_clk]
#set_property LOC BUFGCE_X0Y14 [get_cells *_i/gmii_to_rgmii_2/U0/i_gmii_to_rgmii_block/*_0_core/i_gmii_to_rgmii/i_gmii_to_rgmii/gen_rgmii_rx_clk_zq.bufio_rgmii_rx_clk]

#set_property BEL BUFCE [get_cells *_i/gmii_to_rgmii_3/U0/*_0_core/i_gmii_to_rgmii/i_gmii_to_rgmii/gen_rgmii_rx_clk_zq.bufg_rgmii_rx_clk]
#set_property LOC BUFGCE_X0Y19 [get_cells *_i/gmii_to_rgmii_3/U0/*_0_core/i_gmii_to_rgmii/i_gmii_to_rgmii/gen_rgmii_rx_clk_zq.bufg_rgmii_rx_clk]
#set_property BEL BUFCE [get_cells *_i/gmii_to_rgmii_3/U0/*_0_core/i_gmii_to_rgmii/i_gmii_to_rgmii/gen_rgmii_rx_clk_zq.bufio_rgmii_rx_clk]
#set_property LOC BUFGCE_X0Y18 [get_cells *_i/gmii_to_rgmii_3/U0/*_0_core/i_gmii_to_rgmii/i_gmii_to_rgmii/gen_rgmii_rx_clk_zq.bufio_rgmii_rx_clk]

# Since Vivado 2019.2, when we connect a GEM MDIO interface to EMIO, this sets parameter PSU__ENET0__GRP_MDIO_INTERNAL to 1
# (see file "<vivado-path>\2019.2\data\PS\8series\data\zynqconfig\enet\enet0_preset.xml")
# which in turn enables a new create_clock constraint for the MDIO clock output
# (see file "<vivad-path>\2019.2\data\PS\8series\data\zynqconfig\code\ucfgen.xml").
# The name of the clock is mdioX_mdc_clock and the frequency is specified by parameter PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ.
# The constraint is added to this automatically generated file:
# "<prj_name>\<prj_name>.srcs\sources_1\bd\<prj_name>\ip\<prj_name>_zynq_ultra_ps_e_0_0\<prj_name>_zynq_ultra_ps_e_0_0.xdc"
# The new clock causes Vivado to analyze some non-critical paths that it was not analyzing before, and it has difficulty achieving timing closure.
# To prevent this problem, we declare false path from Clock wizard's 375MHz clock to the Zynq PS GEM's MDIO clock output
set_false_path -from [get_clocks clk_out1_uz3eg_pciec_base_clk_wiz_1_0] -to [get_clocks mdio0_mdc_clock]
set_false_path -from [get_clocks clk_out1_uz3eg_pciec_base_clk_wiz_1_0] -to [get_clocks mdio1_mdc_clock]
set_false_path -from [get_clocks clk_out1_uz3eg_pciec_base_clk_wiz_1_0] -to [get_clocks mdio2_mdc_clock]
set_false_path -from [get_clocks clk_out1_uz3eg_pciec_base_clk_wiz_1_0] -to [get_clocks mdio3_mdc_clock]

# Create the clocks for the RGMII RX CLK inputs
create_clock -period 8.000 -name rgmii_port_0_rx_clk -waveform {0.000 4.000} [get_ports rgmii_port_0_rxc]
create_clock -period 8.000 -name rgmii_port_1_rx_clk -waveform {0.000 4.000} [get_ports rgmii_port_1_rxc]
create_clock -period 8.000 -name rgmii_port_2_rx_clk -waveform {0.000 4.000} [get_ports rgmii_port_2_rxc]
create_clock -period 8.000 -name rgmii_port_3_rx_clk -waveform {0.000 4.000} [get_ports rgmii_port_3_rxc]

