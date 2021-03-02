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
#     http://avnet.me/Ultra96_Forum
#
#  Product information is available at:
#     http://avnet.me/ultra96-v2
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
#  Create Date:         Nov 4, 2020
#  Design Name:         Ultra96v2 Dual Camera Mezzanine HW Platform
#  Module Name:         make_u96v2_sbc_dualcam.tcl
#  Project Name:        Ultra96v2 Dual Camera Mezzanine HW
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96v2 Board + Dual Camera Mezzanine
#
# ----------------------------------------------------------------------------

# Pause function borrowed from:
# https://stackoverflow.com/questions/18993122/tcl-pause-waiting-for-key-pressed-to-continue

proc pause {{message "Hit Enter to continue ==> "}} {
   puts -nonewline $message
   flush stdout
   gets stdin
}

if {$argc != 0} {
	# Build dualcam hw platform
	set argv [list board=[lindex $argv 0] project=[lindex $argv 1] sdk=no close_project=yes dev_arch=zynqmp]
	set argc [llength $argv]
   #puts "This design will not build in the Vivado 2020.2 tools."
   #puts "This design uses the obsolete v_osd on screen display IP which has now been removed from the Vivado IP library."
   #puts "We are working on a fix to replace the on screen display IP with the video mixer IP.  Completion date is TBD."
   #puts "Exiting gracefully without doing anything."
   #pause
	source ./make.tcl -notrace
} else {
	# Build dualcam hw platform
   set argv [list board=u96v2_sbc project=dualcam sdk=no close_project=no dev_arch=zynqmp]
   set argc [llength $argv]
   #puts "This design will not build in the Vivado 2020.2 tools."
   #puts "This design uses the obsolete v_osd on screen display IP which has now been removed from the Vivado IP library."
   #puts "We are working on a fix to replace the on screen display IP with the video mixer IP.  Completion date is TBD."
   #puts "Exiting gracefully without doing anything."
   #pause
   source ./make.tcl -notrace
}

