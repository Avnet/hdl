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
#  Hardware Boards:     FMC-HDMI-CAM + PYTHON-1300-C Camera
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         Build Script for FMC-HDMI-CAM + PYTHON-1300-C Getting Started design
# 
#  Dependencies:        make.tcl
# 
# ----------------------------------------------------------------------------

# Build FMC-HDMI-CAM + PYTHON-1300-C Getting Started design for the MicroZed-7020 + FMC Carrier Card
set argv [list board=MZ7020_FMCCC project=fmchc_python1300c sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build FMC-HDMI-CAM + PYTHON-1300-C Getting Started design for the PicoZed-7030 + FMC Carrier Card V2
set argv [list board=PZ7030_FMC2 project=fmchc_python1300c sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build FMC-HDMI-CAM + PYTHON-1300-C Getting Started design for the PicoZed-7020 + FMC Carrier Card V2
set argv [list board=PZ7020_FMC2 project=fmchc_python1300c sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build FMC-HDMI-CAM + PYTHON-1300-C Getting Started design for the ZedBoard
set argv [list board=ZEDBOARD project=fmchc_python1300c sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build FMC-HDMI-CAM + PYTHON-1300-C Getting Started design for the ZC702 board
set argv [list board=ZC702 project=fmchc_python1300c sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build FMC-HDMI-CAM + PYTHON-1300-C Getting Started design for the ZC706 board
set argv [list board=ZC706 project=fmchc_python1300c sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

