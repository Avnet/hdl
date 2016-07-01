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
#  Create Date:         Feb 08, 2016
#  Design Name:         PicoZed PetaLinux BSP HW Platform
#  Module Name:         make_pz_petalinux.tcl
#  Project Name:        PicoZed PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed SOM
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         Build Script for PicoZed PetaLinux BSP HW Platform
# 
#  Dependencies:        make.tcl
#
#  Revision:            Feb 08, 2016: 1.00 Initial version
#                       May 10, 2016: 1.1  Updated to support 2015.4 tools
#                       Jul 01, 2016: 1.2  Updated to support 2016.2 tools
# 
# ----------------------------------------------------------------------------

# Build PetaLinux BSP HW Platform
# for PicoZed 7010 SOM
set argv [list board=PZ7010_FMC2 project=pz_petalinux sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build PetaLinux BSP HW Platform
# for PicoZed 7015 SOM
set argv [list board=PZ7015_FMC2 project=pz_petalinux sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build PetaLinux BSP HW Platform
# for PicoZed 7020 SOM
set argv [list board=PZ7020_FMC2 project=pz_petalinux sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build PetaLinux BSP HW Platform
# for PicoZed 7030 SOM
set argv [list board=PZ7030_FMC2 project=pz_petalinux sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace
