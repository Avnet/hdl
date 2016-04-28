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
#  Create Date:         Mar 27, 2016
#  Design Name:         MicroZed Sensor Fusion HW Platform
#  Module Name:         make_mz_iocc_sensor_fusion.tcl
#  Project Name:        MicroZed Sensor Fusion
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MicroZed SOM
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         Build Script for MicroZed Sensor Fusion HW Platform
# 
#  Dependencies:        make.tcl
#
#  Revision:            Mar 27, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

# Build Sensor Fusion HW Platform
# for MicroZed 7010 SOM
set argv [list board=MZ7010_IOCC project=mz_iocc_sensor_fusion sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

# Build Sensor Fusion HW Platform
# for MicroZed 7020 SOM
set argv [list board=MZ7020_IOCC project=mz_iocc_sensor_fusion sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace

