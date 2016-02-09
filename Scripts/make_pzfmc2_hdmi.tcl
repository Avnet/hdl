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
#  Create Date:         June 16, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     PicoZed FMC Carrier V2, on-board HDMI
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         Build Script for on-board HDMI of PicoZed FMC Carrier V2
# 
#  Dependencies:        make.tcl
# 
# ----------------------------------------------------------------------------

# Build HDMI design for the PicoZed-7020 + FMC Carrier Card V2
set argv [list board=PZ7020_FMC2 project=pzfmc2_hdmi sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build HDMI design for the PicoZed-7030 + FMC Carrier Card V2
set argv [list board=PZ7030_FMC2 project=pzfmc2_hdmi sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

