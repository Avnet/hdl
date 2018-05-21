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
#  Create Date:         Jul 25, 2016
#  Design Name:         Zynq Mini-ITX PetaLinux BSP HW Platform
#  Module Name:         make_mitx_petalinux.tcl
#  Project Name:        Zynq Mini-ITX PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     Zynq Mini-ITX
# 
#  Tool versions:       Xilinx Vivado 2016.2
# 
#  Description:         Build Script for Zynq Mini-ITX PetaLinux BSP HW 
#                       Platform
# 
#  Dependencies:        make.tcl
#
#  Revision:            Jul 25, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

# Build PetaLinux BSP HW Platform
# for Zynq Mini-ITX 7045 Platform
set argv [list board=MITXZ7045 project=mitx_petalinux sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build PetaLinux BSP HW Platform
# for Zynq Mini-ITX 7100 Platform
set argv [list board=MITXZ7100 project=mitx_petalinux sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace
