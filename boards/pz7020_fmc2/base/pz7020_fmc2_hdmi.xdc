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
#  Please direct any questions to the PicoZed community support forum:
#     http://www.picozed.org/forum
# 
#  Product information is available at:
#     http://www.picozed.org/product/picozed
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Apr 18, 2016
#  Design Name:         PicoZed FMC2 HDMI
#  Module Name:         PZ7020_FMC2_hdmi.xdc
#  Project Name:        PicoZed FMC2 HDMI
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed, PicoZed FMC2 Carrier
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         I/O Constraints used for implementing HDMI output on
#                       a PicoZed FMC2 design.
# 
#  Dependencies:        
#
#  Revision:            Apr 18, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#
# PicoZed with FMC Carrier 2 - HDMI I/O constraints
#

# PicoZed FMC Carrier Card Gen2 Pinout - 7020

# HDMI Interface on PicoZed FMC Gen2 Carrier which is on the Vadj power banks 
# across power Bank 34 and 35 
set_property PACKAGE_PIN V12 [get_ports {hdmi_clk  }];  # "V12.JX1_LVDS_3_P.JX1.18.HDMIO_CLK"
set_property PACKAGE_PIN L17 [get_ports {hdmi_d[0] }];  # "L17.JX2_LVDS_10_N.JX2.49.HDMIO_Y0_D20"
set_property PACKAGE_PIN L16 [get_ports {hdmi_d[1] }];  # "L16.JX2_LVDS_10_P.JX2.47.HDMIO_Y1_D21"
set_property PACKAGE_PIN G20 [get_ports {hdmi_d[2] }];  # "G20.JX2_LVDS_16_N.JX2.69.HDMIO_Y2_D22"
set_property PACKAGE_PIN G19 [get_ports {hdmi_d[3] }];  # "G19.JX2_LVDS_16_P.JX2.67.HDMIO_Y3_D23"
set_property PACKAGE_PIN M15 [get_ports {hdmi_d[4] }];  # "M15.JX2_LVDS_22_N.JX2.89.HDMIO_Y4_D24"
set_property PACKAGE_PIN M14 [get_ports {hdmi_d[5] }];  # "M14.JX2_LVDS_22_P.JX2.87.HDMIO_Y5_D25"
set_property PACKAGE_PIN J16 [get_ports {hdmi_d[6] }];  # "J16.JX2_LVDS_23_N.JX2.90.HDMIO_Y6_D26"
set_property PACKAGE_PIN K16 [get_ports {hdmi_d[7] }];  # "K16.JX2_LVDS_23_P.JX2.88.HDMIO_Y7_D27"
set_property PACKAGE_PIN G14 [get_ports {hdmi_d[8] }];  # "G14.JX2_SE_0.JX2.13.HDMIO_CBCR0_D28"
set_property PACKAGE_PIN J15 [get_ports {hdmi_d[9] }];  # "J15.JX2_SE_1.JX2.14.HDMIO_CBCR1_D29"
set_property PACKAGE_PIN B20 [get_ports {hdmi_d[10]}];  # "B20.JX2_LVDS_0_N.JX2.19.HDMIO_CBCR2_D30"
set_property PACKAGE_PIN C20 [get_ports {hdmi_d[11]}];  # "C20.JX2_LVDS_0_P.JX2.17.HDMIO_CBCR3_D31"
set_property PACKAGE_PIN T10 [get_ports {hdmi_d[12]}];  # "T10.JX1_LVDS_0_N.JX1.13.HDMIO_CBCR4_D32"
set_property PACKAGE_PIN T11 [get_ports {hdmi_d[13]}];  # "T11.JX1_LVDS_0_P.JX1.11.HDMIO_CBCR5_D33"
set_property PACKAGE_PIN U12 [get_ports {hdmi_d[14]}];  # "U12.JX1_LVDS_1_N.JX1.14.HDMIO_CBCR6_D34"
set_property PACKAGE_PIN T12 [get_ports {hdmi_d[15]}];  # "T12.JX1_LVDS_1_P.JX1.12.HDMIO_CBCR7_D35"

#set_property PACKAGE_PIN T14 [get_ports {hdmi_hpd }];  # "T14.JX1_LVDS_4_P.JX1.23.HDMIO_HPD"
#set_property PACKAGE_PIN T15 [get_ports {hdmi_pd  }];  # "T15.JX1_LVDS_4_N.JX1.25.HDMIO_PD"
#set_property PACKAGE_PIN E17 [get_ports {hdmi_int }];  # "E17.JX2_LVDS_2_P.JX2.23.HDMIO_INT"

set_property IOSTANDARD LVCMOS18 [get_ports hdmi_*]
