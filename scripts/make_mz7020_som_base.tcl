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
#  Create Date:         Mar 26, 2016
#  Design Name:         MicroZed PetaLinux BSP HW Platform
#  Module Name:         make_mz_petalinux.tcl
#  Project Name:        MicroZed PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MicroZed SOM
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         Build Script for MicroZed PetaLinux BSP HW Platform
# 
#  Dependencies:        make.tcl
#
#  Revision:            Mar 26, 2016: 1.0  Initial version
#                       Jun 16, 2016: 1.1  Updated to support 2015.4 tools
#                       Jul 01, 2016: 1.2  Updated to support 2016.2 tools
#                       Oct 10, 2017: 1.3  Updated to support 2017.2 tools
#                       May 03, 2018: 1.4  Updated to support 2017.4 tools
#                       Aug 11, 2018: 1.5  Updated to support 2018.2 tools
#                       Sep 20, 2019: 1.6  Updated to support 2019.1 tools
#                       Feb 12, 2020: 1.7  Updated to support 2019.2 tools
# 
# ----------------------------------------------------------------------------

# Build PetaLinux BSP HW Platform
# for MicroZed 7010 SOM
set argv [list board=mz7020_som project=base sdk=no version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace
   
