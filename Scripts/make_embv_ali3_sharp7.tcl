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
#     http://www.microzed.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2015 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Jun 03, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     MicroZed EMBV Carrier + Zed Display Kit
# 
#  Tool versions:       
# 
#  Description:         Build Script for Zed Display Kit design
# 
#  Dependencies:        make.tcl
#
#  Revision:            Jun 03, 2015: 1.00 Initial version
#                       Sep 17, 2015: 1.01 Updated for Vivado 2015.2
# 
# ----------------------------------------------------------------------------

# Build Zed Display Kit reference design
# for MicroZed EMBV Carrier + MicroZed 7010 SOM
set argv [list board=MZ7010_EMBV project=embv_ali3_sharp7 sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build Zed Display Kit reference design
# for MicroZed EMBV Carrier + MicroZed 7020 SOM
set argv [list board=MZ7020_EMBV project=embv_ali3_sharp7 sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace
