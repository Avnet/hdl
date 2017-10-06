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
#  Please direct any questions to the UltraZed community support forum:
#     http://www.ultrazed.org/forum
# 
#  Product information is available at:
#     http://www.ultrazed.org/product/ultrazed
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
#  Create Date:         Oct 02, 2017
#  Design Name:         UltraZed CCD HW Platform
#  Module Name:         make_uz3eg_pciec_ccd.tcl
#  Project Name:        UltraZed CCD
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     UltraZed SOM
# 
#  Tool versions:       Xilinx Vivado 2017.2
# 
#  Description:         Build Script for UltraZed PetaLinux CCD HW Platform
# 
#  Dependencies:        make.tcl
#
#  Revision:            Oct 02, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

# Build CCD HW Platform
# for UltraZed 3EG SOM + PCIe Carrier
set argv [list board=UZ3EG_PCIEC project=uz3eg_pciec_ccd sdk=yes close_project=yes version_override=yes dev_arch=zynqmp]
set argc [llength $argv]
source ./make.tcl -notrace
