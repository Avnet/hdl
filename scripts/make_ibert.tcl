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
#                      Copyright(c) 2014 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         October 8, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     PicoZed 7030 SOM + FMC Carrier Card
# 
#  Tool versions:       Vivado 2015.2.1
# 
#  Description:         Build Script for PicoZed 7030 SOM + FMC Carrier Card IBERT
# 
#  Dependencies:        make.tcl
# 
# ----------------------------------------------------------------------------

# Set Build Variables
set argv [list board=PZ7015_FMCCC project=ibert jtag=no version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

set argv [list board=PZ7030_FMCCC project=ibert jtag=no version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

set argv [list board=PZ7015_FMC2 project=ibert jtag=no version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

set argv [list board=PZ7030_FMC2 project=ibert jtag=no version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace