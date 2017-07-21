# ----------------------------------------------------------------------------
#
#        ** **        **          **  ****      **  **********  ********** ®
#       **   **        **        **   ** **     **  **              **
#      **     **        **      **    **  **    **  **              **
#     **       **        **    **     **   **   **  *********       **
#    **         **        **  **      **    **  **  **              **
#   **           **        ****       **     ** **  **              **
#  **  .........  **        **        **      ****  **********      **
#     ...........
#                                     Reach Further™
#
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions to the Avnet Technical Community:
#     http://minized.org/forums/zed-english-forum
# 
#  Product information is available at:
#     http://minized.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2017 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         July 05, 2017
#  Design Name:         MiniZed Sensor Fusion
#  Module Name:         make_minized_sensor_fusion.tcl
#  Project Name:        minized_sensor_fusion
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Xilinx Vivado 2017.1
# 
#  Description:         Build Script for MiniZed Sensor Fusion
# 
#  Dependencies:        
#
#  Revision:            Jul 05, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

# Build MiniZed Foundation
set argv [list board=MINIZED project=minized_sensor_fusion sdk=yes close_project=yes version_override=no]
set argc [llength $argv]
source ./make.tcl -notrace
