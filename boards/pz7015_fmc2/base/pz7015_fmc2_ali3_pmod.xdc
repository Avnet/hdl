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
#  Design Name:         PicoZed FMC2 + ALI3 Display Kit
#  Module Name:         PZ7015_FMC2_ali3_pmod.xdc
#  Project Name:        PicoZed FMC2 + ALI3 Display Kit
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed, PicoZed FMC2 Carrier, ALI3 Display Kit
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         I/O Constraints used for adding an ALI3 display to
#                       a PicoZed FMC2 design.
# 
#  Dependencies:        
#
#  Revision:            Nov 23, 2015: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#
# PicoZed with FMC Carrier 2 - Display Kit I/O constraints
#

# ALI3 (Avnet LCD Interface) Interface on PMOD-ALI3 which is on the 3.3V fixed
# power Bank 13 JA and JB Pmod pair.
set_property PACKAGE_PIN U19  [get_ports ali3_video_ali_rst_n];  # JA4-5_P
set_property PACKAGE_PIN AA14 [get_ports ali3_video_ali_clk_p];  # JA0-1_P
set_property PACKAGE_PIN AA15 [get_ports ali3_video_ali_clk_n];  # JA0-1_N
set_property PACKAGE_PIN AA16 [get_ports {ali3_video_ali_data_p[0]}];  # JB0-1_P
set_property PACKAGE_PIN AA17 [get_ports {ali3_video_ali_data_n[0]}];  # JB0-1_N
set_property PACKAGE_PIN AA11 [get_ports {ali3_video_ali_data_p[1]}];  # JB2-3_P
set_property PACKAGE_PIN AB11 [get_ports {ali3_video_ali_data_n[1]}];  # JB2-3_N
set_property PACKAGE_PIN Y12  [get_ports {ali3_video_ali_data_p[2]}];  # JB4-5_P
set_property PACKAGE_PIN Y13  [get_ports {ali3_video_ali_data_n[2]}];  # JB4-5_N
set_property PACKAGE_PIN V11  [get_ports {ali3_video_ali_data_p[3]}];  # JB6-7_P
set_property PACKAGE_PIN W11  [get_ports {ali3_video_ali_data_n[3]}];  # JB6-7_N
set_property PACKAGE_PIN V19  [get_ports ali3_touch_irq];  # JA4-5_N
set_property PACKAGE_PIN V18  [get_ports ali3_iic_scl_io];  # JA6-7_P
set_property PACKAGE_PIN W18  [get_ports ali3_iic_sda_io];  # JA6-7_N

# ALI3 (Avnet LCD Interface) Interface on PMOD-ALI3 option on the 3.3V fixed
# power Bank 13 JZ and JA Pmod pair.

#set_property PACKAGE_PIN V16  [get_ports ali3_video_ali_rst_n];  # JZ4-5_P
#set_property PACKAGE_PIN R17  [get_ports ali3_video_ali_clk_p];  # JZ0-1_P
#set_property PACKAGE_PIN T17  [get_ports ali3_video_ali_clk_n];  # JZ0-1_N
#set_property PACKAGE_PIN AA14 [get_ports {ali3_video_ali_data_p[0]}];  # JA0-1_P
#set_property PACKAGE_PIN AA15 [get_ports {ali3_video_ali_data_n[0]}];  # JA0-1_N
#set_property PACKAGE_PIN Y14  [get_ports {ali3_video_ali_data_p[1]}];  # JA2-3_P
#set_property PACKAGE_PIN Y15  [get_ports {ali3_video_ali_data_n[1]}];  # JA2-3_N
#set_property PACKAGE_PIN U19  [get_ports {ali3_video_ali_data_p[2]}];  # JA4-5_P
#set_property PACKAGE_PIN V19  [get_ports {ali3_video_ali_data_n[2]}];  # JA4-5_N
#set_property PACKAGE_PIN V11  [get_ports {ali3_video_ali_data_p[3]}];  # JA6-7_P
#set_property PACKAGE_PIN W11  [get_ports {ali3_video_ali_data_n[3]}];  # JA6-7_N
#set_property PACKAGE_PIN W16  [get_ports ali3_touch_irq];  # JZ4-5_N
#set_property PACKAGE_PIN V15  [get_ports ali3_iic_scl_io];  # JZ6-7_P
#set_property PACKAGE_PIN W15  [get_ports ali3_iic_sda_io];  # JZ6-7_N

# Assign these I/Os to 3.3V to match the fixed 3.3V power Bank 13.

set_property IOSTANDARD LVCMOS33 [get_ports ali3_video_ali_rst_n*];
set_property IOSTANDARD TMDS_33  [get_ports ali3_video_ali_clk*];
set_property IOSTANDARD TMDS_33  [get_ports ali3_video_ali_data*];
set_property IOSTANDARD LVCMOS33 [get_ports ali3_touch_irq*];
set_property IOSTANDARD LVCMOS33 [get_ports ali3_iic*];
