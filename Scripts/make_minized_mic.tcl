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
#  Create Date:         May 1, 2017
#  Design Name:         MiniZed
#  Module Name:         minized_mic.tcl
#  Project Name:        MiniZed Microphone
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Xilinx Vivado 2017.1
# 
#  Description:         Build Script for MiniZed microphone 
#                       Test design
#
#  Dependencies:        make.tcl
#
#  Revision:            May 1, 2017: 1.00 Initial version
#
# ----------------------------------------------------------------------------
	

# Build MiniZed with microphone support
# Don't launch implementation from script ... instead, must manually copy project to short folder name near root C:\ due to over-long path names from SysGen IP
set argv [list board=minized project=minized_mic sdk=no close_project=no version_override=no]
set argc [llength $argv]
source ./make.tcl -notrace
