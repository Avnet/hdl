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
#  Module Name:         uz_petalinux.tcl
#  Project Name:        UltraZed CCD Generator
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     UltraZed SOM
# 
#  Tool versions:       Vivado 2017.2
# 
#  Description:         Build Script for UltraZed CCD HW Platform
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration 
#                       scripts IP generation scripts or others as needed
# 
#
#  Revision:            Oct 02, 2017: 1.00 Created based upon uz_petalinux but 
#                                          addding a call to enable PSU SPI on
#                                          PS Pmod so that the TPM Pmod can be 
#                                          connected for CCD.
#  Revision:            Jun 25, 2018: 1.01 Updated to add support for 
#                                          FMC-NETWORK1 expansion module.
# 
# ----------------------------------------------------------------------------

proc validate_core_licenses { core_list ip_report_filename } {
   set valid_cores 0
   set invalid_cores 0   

   puts ""
   puts "+-----------------------+------------------------------------+"
   puts "| Networking IP Core    | License Status                     |"
   puts "+-----------------------+------------------------------------+"

   foreach core $core_list {
   
      # Format core name for display
      set core_name $core
      for {set j 0} {$j < [expr 16 - [string length $core]]} {incr j} {
         append core_name " "
      }
      
      # Search for core license status in ip status report
      set file [open $ip_report_filename r]   
      set ip_status ""
      while {[gets $file line] >= 0} {
         if {[regexp $core $line]} {
            set ip_status $line
   		 break
         }
      }
      close $file
      #puts "ip_status = ${ip_status}"
   
      # Validate and display status of core license
      if {[regexp "Included" ${ip_status}]} {
         puts "| ${core_name}       | VALID (Full License)               |"
         incr valid_cores
      } elseif {[regexp "Hardware_E" ${ip_status}]} {
         puts "| ${core_name}       | VALID (Hardware Evaluation)        |"
         incr valid_cores
      } elseif {[regexp "Purchased" ${ip_status}]} {
         puts "| ${core_name}       | VALID (Purchased)                  |"
         incr valid_cores
      } else {
         puts "| ${core_name}       | INVALID                            |"
         incr invalid_cores
      }
      puts "+-----------------------+------------------------------------+"
      
   }
   return $valid_cores
}

# 'private' used to allow this project to be privately tagged
# 'public' used to allow this project to be publicly tagged
set release_state public

if {[string match -nocase "yes" $clean]} {
   # Clean up project output products.

   # Open the existing project.
   puts "***** Opening Vivado Project $projects_folder/$project.xpr ..."
   open_project $projects_folder/$project.xpr
   
   # Reset output products.
   reset_target all [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

   # Reset design runs.
   reset_run impl_1
   reset_run synth_1

   # Reset project.
   reset_project
} else {
# Create Vivado project
puts "***** Creating Vivado Project..."
source ../Boards/$board/$board.tcl -notrace
avnet_create_project $project $projects_folder $scriptdir

# Apply board specific project property settings
switch -nocase $board {
   UZ3EG_PCIEC {
      puts "***** Assigning Vivado Project board_part Property to ultrazed_eg_pciecc_production..."
      set_property board_part em.avnet.com:ultrazed_eg_pciecc_production:part0:1.0 [current_project]
   }
}

# Create Block Design and Add PS core
puts "***** Creating Block Design..."
create_bd_design ${project}
set design_name ${project}

# Add Processing System presets from board definitions.
avnet_add_ps_preset $project $projects_folder $scriptdir

# General Config
puts "***** General Configuration for Design..."
set_property target_language VHDL [current_project]

# Add the constraints that are needed for testing
add_files -fileset constrs_1 -norecurse ${projects_folder}/../uz3eg_pciec_ccd.xdc

# Create Block Diagram
set design_name ${project}
source ${projects_folder}/../../../Scripts/ProjectScripts/${project}_bd.tcl

# Check for Networking IP core licenses
puts "***** Check for Networking IP core licenses..."
report_ip_status -file "networking_ip_core_status.log"
set core_list [list "axi_ethernet" ]
set valid_cores [validate_core_licenses $core_list "networking_ip_core_status.log"]
if { $valid_cores < 1 } {
   puts " 
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                           -*
*-   !! Detected missing license for networking ip cores !!  -*
*-                                                           -*
*-     For more details, refer to IP status report:   !!     -*
*-     networking_ip_core_status_report.log                  -*
*-                                                           -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
   error "!! Detected missing license for networking ip cores !!"
} else {
puts " 
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                           -*
*-    !! Detected valid license for networking ip cores !!   -*
*-                                                           -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"
}

# Add Project source files
puts "***** Adding Source Files to Block Design..."
make_wrapper -files [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd] -top
add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.vhd

# Build the binary
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#*- KEEP OUT, do not touch this section unless you know what you are doing! -*
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
puts "***** Building Binary..."
# add this to allow up+enter rebuild capability 
cd $scripts_folder
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
save_bd_design
launch_runs impl_1 -to_step write_bitstream -j 2
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#*- KEEP OUT, do not touch this section unless you know what you are doing! -*
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
}
