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
#  Create Date:         Jan 04, 2017
#  Design Name:         UltraZed + I/O Carrier Pmod Sensors HW Platform
#  Module Name:         make_uz_iocc_sensor.tcl
#  Project Name:        UltraZed I/O Carrier Pmod Sensors Integration
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     UltraZed SOM
# 
#  Tool versions:       Xilinx Vivado 2016.2
# 
#  Description:         Build Script for UltraZed Pmod Sensors HW Platform
# 
#  Dependencies:        make.tcl
#
#  Revision:            Jan 04, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

# Build Pmod Sensors HW Platform
# for UltraZed 3EG SOM
set argv [list board=UZ3EG_IOCC project=uz_iocc_sensor sdk=yes version_override=yes dev_arch=zynqmp]
set argc [llength $argv]
source ./make.tcl -notrace
