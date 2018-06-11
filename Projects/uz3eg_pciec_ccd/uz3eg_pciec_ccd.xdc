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

# SYSMON
set_property IOSTANDARD ANALOG [get_ports Vp_Vn_v_p]
set_property IOSTANDARD ANALOG [get_ports Vp_Vn_v_n]


# PL DIP Switches

set_property PACKAGE_PIN H1 [get_ports {dip_switches_8bits_tri_i[0]}]		;# JX2_HP_DP_17_P
set_property PACKAGE_PIN G1 [get_ports {dip_switches_8bits_tri_i[1]}]		;# JX2_HP_DP_17_N
set_property PACKAGE_PIN G7 [get_ports {dip_switches_8bits_tri_i[2]}]		;# JX2_HP_DP_19_P
set_property PACKAGE_PIN F7 [get_ports {dip_switches_8bits_tri_i[3]}]		;# JX2_HP_DP_19_N
set_property PACKAGE_PIN G8 [get_ports {dip_switches_8bits_tri_i[4]}]		;# JX2_HP_DP_21_P
set_property PACKAGE_PIN F8 [get_ports {dip_switches_8bits_tri_i[5]}]		;# JX2_HP_DP_21_N
set_property PACKAGE_PIN B3 [get_ports {dip_switches_8bits_tri_i[6]}]		;# JX2_HP_DP_23_P
set_property PACKAGE_PIN B2 [get_ports {dip_switches_8bits_tri_i[7]}]		;# JX2_HP_DP_23_N

set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[7]}]


# PL LEDs 

set_property PACKAGE_PIN C8 [get_ports {led_8bits_tri_o[0]}]		;# JX2_HP_DP_16_P
set_property PACKAGE_PIN B8 [get_ports {led_8bits_tri_o[1]}]		;# JX2_HP_DP_16_N
set_property PACKAGE_PIN A6 [get_ports {led_8bits_tri_o[2]}]		;# JX2_HP_DP_18_P
set_property PACKAGE_PIN A5 [get_ports {led_8bits_tri_o[3]}]		;# JX2_HP_DP_18_N
set_property PACKAGE_PIN H6 [get_ports {led_8bits_tri_o[4]}]		;# JX2_HP_DP_20_P
set_property PACKAGE_PIN G6 [get_ports {led_8bits_tri_o[5]}]		;# JX2_HP_DP_20_N
set_property PACKAGE_PIN G5 [get_ports {led_8bits_tri_o[6]}]		;# JX2_HP_DP_22_P
set_property PACKAGE_PIN F5 [get_ports {led_8bits_tri_o[7]}]		;# JX2_HP_DP_22_N

set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[7]}]


# PL Push Switches

set_property PACKAGE_PIN D8 [get_ports {push_buttons_4bits_tri_i[0]}]		;# JX2_HP_SE_00
set_property PACKAGE_PIN E7 [get_ports {push_buttons_4bits_tri_i[1]}]		;# JX2_HP_SE_01
set_property PACKAGE_PIN A4 [get_ports {push_buttons_4bits_tri_i[2]}]		;# JX2_HP_SE_02
set_property PACKAGE_PIN H5 [get_ports {push_buttons_4bits_tri_i[3]}]		;# JX2_HP_SE_03

set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[3]}]   


# FMC LPC Interface - FMC-Network1

set_property PACKAGE_PIN P3 [get_ports {ref_clk_fsel[0]}]
set_property PACKAGE_PIN N1 [get_ports {ref_clk_oe[0]}]
set_property PACKAGE_PIN P4 [get_ports {ref_clk_p[0]}]
set_property PACKAGE_PIN R4 [get_ports {ref_clk_n[0]}]

set_property PACKAGE_PIN M5 [get_ports {reset_port_0[0]}]
set_property PACKAGE_PIN N5 [get_ports mdio_io_port_0_mdc]
set_property PACKAGE_PIN L5 [get_ports mdio_io_port_0_mdio_io]

set_property PACKAGE_PIN L3 [get_ports rgmii_port_0_rx_ctl]
set_property PACKAGE_PIN M3 [get_ports rgmii_port_0_rxc]
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

set_property PACKAGE_PIN W7 [get_ports {reset_port_1[0]}]
set_property PACKAGE_PIN P1 [get_ports mdio_io_port_1_mdc]
set_property PACKAGE_PIN P2 [get_ports mdio_io_port_1_mdio_io]

set_property PACKAGE_PIN N3 [get_ports rgmii_port_1_rx_ctl]
set_property PACKAGE_PIN N4 [get_ports rgmii_port_1_rxc]
set_property PACKAGE_PIN J6 [get_ports {rgmii_port_1_rd[3]}]
set_property PACKAGE_PIN K7 [get_ports {rgmii_port_1_rd[2]}]
set_property PACKAGE_PIN J7 [get_ports {rgmii_port_1_rd[1]}]
set_property PACKAGE_PIN M6 [get_ports {rgmii_port_1_rd[0]}]

set_property PACKAGE_PIN W8 [get_ports rgmii_port_1_tx_ctl]
set_property PACKAGE_PIN U2 [get_ports rgmii_port_1_txc]
set_property PACKAGE_PIN T7 [get_ports {rgmii_port_1_td[3]}]
set_property PACKAGE_PIN R7 [get_ports {rgmii_port_1_td[2]}]
set_property PACKAGE_PIN T3 [get_ports {rgmii_port_1_td[1]}]
set_property PACKAGE_PIN V3 [get_ports {rgmii_port_1_td[0]}]

set_property PACKAGE_PIN AD7 [get_ports {LED4B}];  			# JX1_HP_DP_07_N - FMC_LA24_N
set_property PACKAGE_PIN AD8 [get_ports {LED4A}];  			# JX1_HP_DP_07_P - FMC_LA24_P
set_property PACKAGE_PIN Y1 [get_ports {LED3B}];  			# JX1_HP_DP_09_N - FMC_LA25_N
set_property PACKAGE_PIN W1 [get_ports {LED3A}];  			# JX1_HP_DP_09_P - FMC_LA25_P
set_property PACKAGE_PIN W2 [get_ports {LED2B}];  			# JX1_HP_DP_12_N - FMC_LA26_N
set_property PACKAGE_PIN W3 [get_ports {LED2A}];  			# JX1_HP_DP_12_P - FMC_LA26_P
set_property PACKAGE_PIN AA2 [get_ports {LED1B}];  			# JX1_HP_DP_14_N - FMC_LA27_N
set_property PACKAGE_PIN Y2 [get_ports {LED1A}];  			# JX1_HP_DP_14_P - FMC_LA27_P
set_property PACKAGE_PIN AA3 [get_ports {LED5B}];  			# JX1_HP_DP_08_N - FMC_LA28_N
set_property PACKAGE_PIN AA4 [get_ports {LED5A}];  			# JX1_HP_DP_08_P - FMC_LA28_P

set_property PACKAGE_PIN B10  [get_ports {FMC_SDA}];  		# JX2_HD_SE_01_N - FMC_SDA
set_property PACKAGE_PIN C10  [get_ports {FMC_SCL}];  		# JX2_HD_SE_01_P - FMC_SCL
set_property PACKAGE_PIN H9   [get_ports {FMC_PRSNT_M2C_N}];# JX2_HD_SE_00_N - FMC_PRSNT_M2C_N
set_property PACKAGE_PIN H10  [get_ports {FMC_TRST_N}];  	# JX2_HD_SE_00_P - FMC_TRST_N

set_property IOSTANDARD LVCMOS18 [get_ports {ref_clk_fsel[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ref_clk_oe[0]}]
set_property IOSTANDARD LVDS [get_ports {ref_clk_n[0]}]
set_property IOSTANDARD LVDS [get_ports {ref_clk_p[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {reset_port_0[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_io_port_0_mdc]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_io_port_0_mdio_io]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_0_rx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_0_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_rd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_rd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_rd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_rd[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_0_tx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_0_txc]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_td[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_td[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_td[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_0_td[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {reset_port_1[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_io_port_1_mdc]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_io_port_1_mdio_io]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_1_rx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_1_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_rd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_rd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_rd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_rd[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_1_tx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_port_1_txc]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_td[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_td[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_td[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_port_1_td[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {LED4B}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED4A}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED3B}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED3A}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED2B}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED2A}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED1B}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED1A}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED5B}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED5A}]

set_property IOSTANDARD LVCMOS33 [get_ports {FMC_SDA}]
set_property IOSTANDARD LVCMOS33 [get_ports {FMC_SCL}]
set_property IOSTANDARD LVCMOS33 [get_ports {FMC_PRSNT_M2C_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {FMC_TRST_N}]
