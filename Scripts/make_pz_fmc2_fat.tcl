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
#  Create Date:         Apr 07, 2016
#  Design Name:         PicoZed + FMC2 Carrier
#  Module Name:         make_pz_fmc2_fat.tcl
#  Project Name:        PicoZed FMC2 Carrier HW Factory Acceptance Test
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed + FMC Carrier 2
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         Build Script for PicoZed FMC2 HW Factory Acceptance 
#                       Test design
# 
#  Dependencies:        make.tcl
#
#  Revision:            Apr 07, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------


# Build HW Factory Acceptance Test design
# for PicoZed FMC Carrier 2 + PicoZed 7030 SOM
set argv [list board=PZ7030_FMC2 project=pz_fmc2_valtest sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace
