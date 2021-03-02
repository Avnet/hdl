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
#  Please direct any questions to the MicroZed community support forum:
#     http://avnet.me/microzed_forum
#
#  Product information is available at:
#     http://avnet.me/microzed
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
#  Create Date:         Dec 02, 2014
#  Design Name:         MicroZed Base HW Platform
#  Module Name:         make_mz7010_som_base.tcl
#  Project Name:        MicroZed Base HW
#  Target Devices:      Xilinx Zynq-7010
#  Hardware Boards:     MicroZed SOM
#
# ----------------------------------------------------------------------------

if {$argc != 0} {
	# Build base hw platform
	set argv [list board=[lindex $argv 0] project=[lindex $argv 1] sdk=no close_project=yes dev_arch=zynq]
	set argc [llength $argv]
	source ./make.tcl -notrace
} else {
	# Build base hw platform
   set argv [list board=mz7010_som project=base sdk=no close_project=yes dev_arch=zynq]
   set argc [llength $argv]
   source ./make.tcl -notrace
}
