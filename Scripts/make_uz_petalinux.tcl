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
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Jul 01, 2016
#  Design Name:         UltraZed PetaLinux BSP HW Platform
#  Module Name:         make_uz_petalinux.tcl
#  Project Name:        UltraZed PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     UltraZed SOM
# 
#  Tool versions:       Xilinx Vivado 2016.2
# 
#  Description:         Build Script for UltraZed PetaLinux BSP HW Platform
# 
#  Dependencies:        make.tcl
#
#  Revision:            Jul 01, 2016: 1.00 Initial version
#                       Jan 05, 2017: 1.01 Added support for PCIe Carrier
#                       Aug 25, 2017: 1.02 Updated for 2017.2 tools
#                       Jan 30, 2018: 1.03 Added support for UltraZed-EV
#                       Feb 01, 2018: 1.04 Updated for 2017.4 tools
#                       Oct 25, 2018: 1.05 Updated for 2018.2 tools
#                       Oct 01, 2019: 1.06 Updated for 2019.1 tools
#                       Feb 20, 2020: 1.06 Updated for 2019.2 tools
# 
# ----------------------------------------------------------------------------

# Build PetaLinux BSP HW Platform
# for UltraZed 3EG SOM + IO Carrier
set argv [list board=UZ3EG_IOCC project=uz_petalinux sdk=no close_project=yes version_override=yes dev_arch=zynqmp]
set argc [llength $argv]
source ./make.tcl -notrace

# Build PetaLinux BSP HW Platform
# for UltraZed 3EG SOM + PCIe Carrier
set argv [list board=UZ3EG_PCIEC project=uz_petalinux sdk=no close_project=yes version_override=yes dev_arch=zynqmp]
set argc [llength $argv]
source ./make.tcl -notrace

# Build PetaLinux BSP HW Platform (also used for OOB HW Platform)
# for UltraZed 7EV-ES2 SOM + EV Carrier
#set argv [list board=UZ7EV_ES2_EVCC project=uz_petalinux sdk=no close_project=yes version_override=yes dev_arch=zynqmp]
#set argc [llength $argv]
#source ./make.tcl -notrace

# Build PetaLinux BSP HW Platform (also used for OOB HW Platform)
# for UltraZed 7EV SOM + EV Carrier
set argv [list board=UZ7EV_EVCC project=uz_petalinux sdk=no close_project=yes version_override=yes dev_arch=zynqmp]
set argc [llength $argv]
source ./make.tcl -notrace

