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
#                      Copyright(c) 2015 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Nov 23, 2015
#  Design Name:         PicoZed FMC2
#  Module Name:         PZ7020_FMC2_user_io.xdc
#  Project Name:        PicoZed FMC2
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed, PicoZed FMC2 Carrier
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         I/O Constraints used for adding user I/O to a design.
# 
#  Dependencies:        
#
#  Revision:            Nov 23, 2015: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#
# PicoZed with FMC Carrier 2 - User I/O constraints
#

# User PL LEDs which are on the VADJ powered Bank 34 and Bank 13
set_property PACKAGE_PIN U13  [get_ports {emio_user_tri_io[0]}];  # "PL_LED1"
set_property PACKAGE_PIN V6   [get_ports {emio_user_tri_io[1]}];  # "PL_LED2"
set_property PACKAGE_PIN W6   [get_ports {emio_user_tri_io[2]}];  # "PL_LED3"
set_property PACKAGE_PIN Y12  [get_ports {emio_user_tri_io[3]}];  # "PL_LED4"

# User PL Push Buttons which are on the VADJ powered Bank 34 and Bank 13
set_property PACKAGE_PIN V13  [get_ports {emio_user_tri_io[4]}];  # "PL_PB1"
set_property PACKAGE_PIN V5   [get_ports {emio_user_tri_io[5]}];  # "PL_PB2"
set_property PACKAGE_PIN Y13  [get_ports {emio_user_tri_io[6]}];  # "PL_PB3"
set_property PACKAGE_PIN V11  [get_ports {emio_user_tri_io[7]}];  # "PL_PB4"
set_property PACKAGE_PIN V10  [get_ports {emio_user_tri_io[8]}];  # "PL_PB5"

set_property IOSTANDARD LVCMOS33 [get_ports emio_user_tri_io*];
