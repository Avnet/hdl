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
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         March 19, 2016
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     MicroZed IIoT Kit
# 
#  Tool versions:       
# 
#  Description:         Build Script for MZ IIoT
# 
#  Dependencies:        make.tcl
# 
# ----------------------------------------------------------------------------

# Build MZ IIoT design for MicroZed IIoT Kit + MicroZed 7010 SOM
set argv [list board=MZ7010_ACC project=mz_acc_iiot sdk=no version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build MZ IIoT design for MicroZed IIoT Kit + MicroZed 7020 SOM
#set argv [list board=MZ7020_EMBV project=embv_hdmi_passthrough sdk=yes version_override=yes]
#set argc [llength $argv]
#source ./make.tcl -notrace
 
