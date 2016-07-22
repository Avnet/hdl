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
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Jul 07, 2016
#  Design Name:         ZCU102 PetaLinux BSP HW Platform
#  Module Name:         make_zcu102_petalinux.tcl
#  Project Name:        ZCU102 PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq UltraScale+ 9EG
#  Hardware Boards:     Xilinx ZCU102
# 
#  Tool versions:       Xilinx Vivado 2016.2
# 
#  Description:         Build Script for PetaLinux on Xilinx ZCU102 Board
# 
#  Dependencies:        make.tcl
#
#  Revision:            Jul 07, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

# Build PetaLinux BSP HW Platform
# for Xilinx ZCU102 Board
set argv [list board=ZCU102 project=zcu102_petalinux sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace
