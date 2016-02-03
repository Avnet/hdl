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
#  Please direct any questions or issues to the MicroZed Community Forums:
#      http://www.microzed.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2015 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         November 24, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     FMC-HDMI-CAM + PYTHON-1300-C
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         XDC generation script for FMC-HDMI-CAM + PYTHON-1300-C Design
# 
#  Dependencies:        To be called from the scripts directory as follows:
#                          source ./ProjectScripts/fmchc_python1300c_xdc_gen.tcl
#
#  Revision:            Nov 24, 2015: 1.00 Initial version
# 
# ----------------------------------------------------------------------------


#!/usr/bin/tclsh

# This procedure will modify the generic project XDC, 
# and replace the generic FMC{} constraints with the board specific FMC locations
proc xdc_gen {master_xdc_file generic_xdc_file fmc_slot target_xdc_file} {

	# read contents of board's master XDC file
	set master_xdc_fp [open $master_xdc_file "r"]
	set master_xdc_data [read $master_xdc_fp]
	close $master_xdc_fp
	set master_xdc_lines [split $master_xdc_data "\n"]

	# read contents of project's generic XDC file
	set generic_xdc_fp [open $generic_xdc_file "r"]
	set generic_xdc_data [read $generic_xdc_fp]
	close $generic_xdc_fp
	set generic_xdc_lines [split $generic_xdc_data "\n"]

	set target_xdc_fp [open $target_xdc_file "w"]

	# Iterate over lines of generic XDC file
	for {set i 0} {$i < [llength $generic_xdc_lines]} {incr i} {
		# Detect lines containing generic FMC{} constraints
		set idx11 [string first "FMC\{" [lindex $generic_xdc_lines $i]]
		set idx12 [string first "\}"    [lindex $generic_xdc_lines $i]]
		if {$idx11 != -1} {
			set str1 [string range [lindex $generic_xdc_lines $i] 0 [expr $idx11-2]] 
			set str2 [string range [lindex $generic_xdc_lines $i] [expr $idx11+4] [expr $idx12-1]]
			set str3 [string range [lindex $generic_xdc_lines $i] [expr $idx12+2] end]
            
			# Iterate over lines of master XDC file to resolve location of FMC pin
			set fmc_pin $str2
			set fmc_loc "?"
			for {set j 0} {$j < [llength $master_xdc_lines]} {incr j} {
				#set idx21 [string first $fmc_pin [lindex $master_xdc_lines $j]]
				#set idx22 [string first $fmc_slot  [lindex $master_xdc_lines $j]]
				#if { $idx21 != -1 && $idx22 != -1 } {
				#	set idx31 [string first "PACKAGE_PIN" [lindex $master_xdc_lines $j]]
				#	set idx32 [string first "\[" [lindex $master_xdc_lines $j]]
				#	set fmc_loc [string range [lindex $master_xdc_lines $j] [expr $idx31+12] [expr $idx32-1]]
				#	break
				#}
				set idx21 [string first $fmc_pin [lindex $master_xdc_lines $j]]
				set idx22 [string first $fmc_slot  [lindex $master_xdc_lines $j]]
				if { [string first $fmc_pin [lindex $master_xdc_lines $j]] != -1 } {
					if { $fmc_slot eq "" || [string first $fmc_slot  [lindex $master_xdc_lines $j]] != -1 } {
						set idx21 [string first "PACKAGE_PIN" [lindex $master_xdc_lines $j]]
						set idx22 [string first "\[" [lindex $master_xdc_lines $j]]
						set fmc_loc [string range [lindex $master_xdc_lines $j] [expr $idx21+12] [expr $idx22-1]]
						break
					}
				}
			}
			
			puts $target_xdc_fp "$str1 $fmc_loc $str3" 
			
		} else {
			puts $target_xdc_fp [lindex $generic_xdc_lines $i]
		}
	}
	
	close $target_xdc_fp

}


set board "PZ7030_FMC2"
set master_xdc "PZ7030_7015_RevC_FMCV2_RevA_v1.xdc"
set fmc_slot ""

#set board "ZC706"
#set master_xdc "zc706_r1_0.xdc"
#set fmc_slot "LPC"

# create variables with absolute folders for all necessary folders
set project "fmchc_python1300c"
set boards_folder [file normalize [pwd]/../Boards]
set project_folder [file normalize [pwd]/../Projects/$project]
set scripts_folder [file normalize [pwd]]

# Generate XDC file for PZ7020_FMC2 JX1
set master_xdc_file $boards_folder/$board/$master_xdc
set generic_xdc_file $project_folder/generic_$project.xdc
if { $fmc_slot eq "" } {
	set target_xdc_file $project_folder/${board}_${project}.xdc
} else {
	set target_xdc_file $project_folder/${board}_${fmc_slot}_${project}.xdc
}
xdc_gen $master_xdc_file $generic_xdc_file $fmc_slot $target_xdc_file


