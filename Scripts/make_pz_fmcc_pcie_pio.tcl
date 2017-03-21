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
#  Create Date:         March 20, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     PicoZed 7015 7030 With FMCCC and FMCCCv2
# 
#  Tool versions:       Vivado 2016.4
# 
#  Description:         Build Script for PicoZed 7015 7030 With FMCCC and FMCCCv2 PCIE PIO Design
# 
#  Dependencies:        make.tcl
# 
# ----------------------------------------------------------------------------

# Build PCIE PIO Design for the PicoZed-7015 + FMC Carrier Card
set argv [list board=PZ7015_FMCCC project=pz_fmcc_pcie_pio]
set argc [llength $argv]
source ./make.tcl -notrace

## Build PCIE PIO Design for the PicoZed-7030 + FMC Carrier Card
#set argv [list board=PZ7030_FMCCC project=pz_fmcc_pcie_pio]
#set argc [llength $argv]
#source ./make.tcl -notrace
#
## Build PCIE PIO Design for the PicoZed-7015 + FMC Carrier Card V2
#set argv [list board=PZ7015_FMC2 project=pz_fmcc_pcie_pio]
#set argc [llength $argv]
#source ./make.tcl -notrace
#
## Build PCIE PIO Design for the PicoZed-7015 + FMC Carrier Card V2
#set argv [list board=PZ7030_FMC2 project=pz_fmcc_pcie_pio]
#set argc [llength $argv]
#source ./make.tcl -notrace
