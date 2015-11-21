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
#  Create Date:         April 23, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     FMC-IMAGEON + VITA-2000-C Camera
# 
#  Tool versions:       Vivado 2014.4
# 
#  Description:         Build Script for FMC-IMAGEON + VITA-2000-C Getting Started design
# 
#  Dependencies:        make.tcl
# 
# ----------------------------------------------------------------------------

# Build FMC-IMAGEON + VITA-2000-C Getting Started design for the ZC702 board
set argv [list board=ZC702 project=fmc_imageon_gs sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build FMC-IMAGEON + VITA-2000-C Getting Started design for the ZedBoard
set argv [list board=ZEDBOARD project=fmc_imageon_gs sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build FMC-IMAGEON + VITA-2000-C Getting Started design for the MicroZed-7020 + FMC Carrier Card
set argv [list board=MZ7020_FMCCC project=fmc_imageon_gs sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace


