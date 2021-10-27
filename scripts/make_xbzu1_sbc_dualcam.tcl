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
#     http://avnet.me/<TBD>
#
#  Product information is available at:
#     http://avnet.me/<TBD>
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2021 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Create Date:         Oct 05, 2021
#  Design Name:         XBoard-ZU1 Dual Camera SYZYGY HW Platform
#  Module Name:         make_xbzu1_sbc_dualcam.tcl
#  Project Name:        XBoard-ZU1 Dual Camera SYZYGY HW
#  Target Devices:      Xilinx Zynq UltraScale+ 1CG
#  Hardware Boards:     Xboard-ZU1 Board + SYZYGY DualCam Pod
#
# ----------------------------------------------------------------------------

if {$argc != 0} {
	# Build dualcam hw platform
	set argv [list board=[lindex $argv 0] project=[lindex $argv 1] sdk=no close_project=yes dev_arch=zynqmp]
	set argc [llength $argv]
	source ./make.tcl -notrace
} else {
	# Build dualcam hw platform
   set argv [list board=xbzu1_sbc project=dualcam sdk=no close_project=yes dev_arch=zynqmp]
   set argc [llength $argv]
   source ./make.tcl -notrace
}

