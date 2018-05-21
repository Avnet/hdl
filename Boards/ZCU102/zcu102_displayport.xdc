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
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         August 17, 2016
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq MPSoC 9EG
#  Hardware Boards:     Xilinx ZCU102
# 
#  Tool versions:       Vivado 2016.2
# 
#  Description:         Build Script for ZCU102
# 
#  Dependencies:        To be called from a project build script
# 
# ----------------------------------------------------------------------------

########################
# Physical Constraints #
########################

set_property PACKAGE_PIN G11 [get_ports dp_aux_data_oe]
set_property PACKAGE_PIN D10 [get_ports dp_aux_data_out]
set_property IOSTANDARD LVCMOS33 [get_ports dp_*]

##################
# Primary Clocks #
##################


####################
# Generated Clocks #
####################


################
# Clock Groups #
################

