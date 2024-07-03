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
#  Please direct any questions to the K24 community support forum:
#     http://avnet.me/k24-dk-forum
#
#  Product information is available at:
#     http://avnet.me/k24-dk
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2024 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Create Date:         May 28, 2024
#  Design Name:         K24 IOCC Factory Test HW Platform
#  Module Name:         make_k24_iocc_factest.tcl
#  Project Name:        K24 IOCC Factory Test HW
#  Target Devices:      Xilinx Zynq UltraScale+ XCK24
#  Hardware Boards:     K24C SOM + I/O Carrier
#
# ----------------------------------------------------------------------------

if {$argc != 0} {
	# Build base hw platform
	set argv [list board=[lindex $argv 0] project=[lindex $argv 1] sdk=no close_project=yes dev_arch=zynqmp]
	set argc [llength $argv]
	source ./make.tcl -notrace
} else {
	# Build base hw platform
   set argv [list board=k24_iocc project=factest sdk=no close_project=yes dev_arch=zynqmp]
   set argc [llength $argv]
   source ./make.tcl -notrace
}
