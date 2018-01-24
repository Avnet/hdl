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
#  Please direct any questions to the Avnet Technical Community:
#     http://minized.org/forums/zed-english-forum
# 
#  Product information is available at:
#     http://minized.org
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
#  Create Date:         August 14, 2017
#  Design Name:         MiniZed SpeedWay
#  Module Name:         minized_speedway.xdc
#  Project Name:        minized_speedway
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Xilinx Vivado 2017.1
# 
#  Description:         MiniZed PetaLinux constraints for SpeedWay training 
#                       platform which matches the one from the 2017 Fall 
#                       SpeedWays.
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration 
#                       scripts IP generation scripts or others as needed     
#
#  Revision:            Aug 14, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

########################
# Physical Constraints #
########################

#
# MiniZed - Sensor Fusion I/O constraints are a modified version of 
# minized_foundation constraints but with AXI I2C blocks assigned to 
# AXI I2C IP blocks so that sensor Pmods can be connected.
#

#######################################################################
# MiniZed LEDs
#######################################################################
# These constraints are used for when connecting the Red PL LED to 
# the PWM_w_Int custom IP block during the Developing Zynq Hardware 
# SpeedWay activities.
set_property PACKAGE_PIN E12 [get_ports {PL_LED_R[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PL_LED_R[0]}]

# These constraints are used for when connecting the Red PL LED to 
# a GPIO block per UltraFast Methodology.
#set_property PACKAGE_PIN E13 [get_ports {pl_led_g_tri_o[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {pl_led_g_tri_o[0]}]

# These constraints are used for when connecting the Green PL LED to 
# a GPIO block per UltraFast Methodology.
set_property PACKAGE_PIN E13 [get_ports {pl_led_g_tri_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pl_led_g_tri_o[0]}]

#######################################################################
# MiniZed PL_Switch
#######################################################################
set_property PACKAGE_PIN E11 [get_ports {pl_sw_1bit_tri_i[0]}];  
set_property IOSTANDARD LVCMOS33 [get_ports {pl_sw_1bit_tri_i[0]}]

#######################################################################
# AXI IIC 0 
#######################################################################
set_property PACKAGE_PIN F15 [get_ports iic_rtl_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_rtl_0_sda_io]

set_property PACKAGE_PIN G15 [get_ports iic_rtl_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_rtl_0_scl_io]
#######################################################################
#AXI IIC 1 PMOD 1
#######################################################################
set_property PACKAGE_PIN M14 [get_ports iic_rtl_1_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_rtl_1_sda_io]

set_property PACKAGE_PIN L14 [get_ports iic_rtl_1_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_rtl_1_scl_io]
#######################################################################
#AXI IIC 2 PMOD 2
#######################################################################
set_property PACKAGE_PIN N12 [get_ports iic_rtl_2_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_rtl_2_sda_io]

set_property PACKAGE_PIN N11 [get_ports iic_rtl_2_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_rtl_2_scl_io]

#######################################################################
# Wireless Module
#######################################################################
set_property PACKAGE_PIN J15 [get_ports WL_SDIO_CLK]
set_property IOSTANDARD LVCMOS33 [get_ports WL_SDIO_CLK]

set_property PACKAGE_PIN J11 [get_ports WL_SDIO_CMD]
set_property IOSTANDARD LVCMOS33 [get_ports WL_SDIO_CMD]

set_property PACKAGE_PIN J13 [get_ports {WL_SDIO_DAT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {WL_SDIO_DAT[0]}]

set_property PACKAGE_PIN H11 [get_ports {WL_SDIO_DAT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {WL_SDIO_DAT[1]}]

set_property PACKAGE_PIN K15 [get_ports {WL_SDIO_DAT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {WL_SDIO_DAT[2]}]

set_property PACKAGE_PIN J14 [get_ports {WL_SDIO_DAT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {WL_SDIO_DAT[3]}]

set_property PACKAGE_PIN K11 [get_ports WL_REG_ON]
set_property IOSTANDARD LVCMOS33 [get_ports WL_REG_ON]

set_property PACKAGE_PIN K12 [get_ports WL_HOST_WAKE]
set_property IOSTANDARD LVCMOS33 [get_ports WL_HOST_WAKE]

set_property PACKAGE_PIN G14 [get_ports BT_TXD_OUT]
set_property IOSTANDARD LVCMOS33 [get_ports BT_TXD_OUT]

set_property PACKAGE_PIN G11 [get_ports BT_RXD_IN]
set_property IOSTANDARD LVCMOS33 [get_ports BT_RXD_IN]

set_property PACKAGE_PIN H12 [get_ports BT_RTS_OUT_N]
set_property IOSTANDARD LVCMOS33 [get_ports BT_RTS_OUT_N]

set_property PACKAGE_PIN G12 [get_ports BT_CTS_IN_N]
set_property IOSTANDARD LVCMOS33 [get_ports BT_CTS_IN_N]

set_property PACKAGE_PIN H13 [get_ports BT_REG_ON]
set_property IOSTANDARD LVCMOS33 [get_ports BT_REG_ON]

set_property PACKAGE_PIN H14 [get_ports BT_HOST_WAKE]
set_property IOSTANDARD LVCMOS33 [get_ports BT_HOST_WAKE]



