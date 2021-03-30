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
#     http://avnet.me/uzevforum
#
#  Product information is available at:
#     http://avnet.me/ultrazed-ev
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
#  Create Date:         Mar 25, 2021
#  Design Name:         UltraZed-EV QUADCAM (+HDMI +VCU) HW Platform
#  Module Name:         make_uz7ev_evcc_quadcam_h_v.tcl
#  Project Name:        UltraZed-EV QUADCAM_H_V HW
#  Target Devices:      Xilinx Zynq UltraScale+ 7EV
#  Hardware Boards:     UltraZed-EV SOM + EV Carrier + Quad Camera FMC
#
# ----------------------------------------------------------------------------

if {$argc != 0} {
	# Build quadcam_h_v hw platform
   set argv [list board=[lindex $argv 0] project=[lindex $argv 1] sdk=no close_project=yes dev_arch=zynqmp]
   set argc [llength $argv]
   source ./make.tcl -notrace
} else {
	# Build quadcam_h_v hw platform
   set argv [list board=uz7ev_evcc project=quadcam_h_v sdk=no close_project=yes dev_arch=zynqmp]
   set argc [llength $argv]
   source ./make.tcl -notrace
}
