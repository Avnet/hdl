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
#  Create Date:         Nov 13, 2017
#  Design Name:         UltraZed-EV Out Of Box Design Platform
#  Module Name:         make_uz7ev_oob.tcl
#  Project Name:        UltraZed-EV Out Of Box Design Generator
#  Target Devices:      Xilinx Zynq UltraScale+ 7EV
#  Hardware Boards:     UltraZed-EV SOM
# 
#  Tool versions:       Xilinx Vivado 2017.2
# 
#  Description:         Build Script for UltraZed-EV OOB HW Platform
# 
#  Dependencies:        make.tcl
#
#  Revision:            Nov 13, 2017: 1.00 Initial version
#                       Nov 13, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

# Build OOB HW Platform
# for UltraZed 7EV-ES2 SOM + Carrier
#set argv [list board=UZ7EV_ES2_EVCC project=uz7ev_evcc_oob sdk=yes close_project=yes version_override=yes dev_arch=zynqmp]
#set argc [llength $argv]
#source ./make.tcl -notrace

# Build OOB HW Platform
# for UltraZed 7EV SOM + Carrier
set argv [list board=UZ7EV_EVCC project=uz7ev_evcc_oob sdk=yes close_project=yes version_override=yes dev_arch=zynqmp]
set argc [llength $argv]
source ./make.tcl -notrace