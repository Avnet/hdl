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
#  Please direct any questions or issues to the MicroZed Community Forums:
#      http://www.microzed.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2014 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         June 7, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     ZedBoard + TDM114 Camera
# 
#  Tool versions:       Vivado 2016.4
# 
#  Description:         Build Script for ZedBaord, and TDM114 Camera Module
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration scripts
#                          IP generation scripts or others
# 
# ----------------------------------------------------------------------------

proc validate_core_licenses { core_list ip_report_filename } {
   set valid_cores 0
   set invalid_cores 0   

   puts ""
   puts "+------------------+------------------------------------+"
   puts "| Video IP Core    | License Status                     |"
   puts "+------------------+------------------------------------+"

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
         puts "| ${core_name} | VALID (Full License)               |"
         incr valid_cores
      } elseif {[regexp "Hardware_E" ${ip_status}]} {
         puts "| ${core_name} | VALID (Hardware Evaluation)        |"
         incr valid_cores
      } elseif {[regexp "Purchased" ${ip_status}]} {
         puts "| ${core_name} | VALID (Purchased)                  |"
         incr valid_cores
      } else {
         puts "| ${core_name} | INVALID                            |"
         incr invalid_cores
      }
      puts "+------------------+------------------------------------+"
      
   }
   return $valid_cores
}

# 'private' used to allow this project to be privately tagged
# 'public' used to allow this project to be publicly tagged
set release_state public

# Generate Avnet IP
puts "***** Generating IP..."
source ./makeip.tcl -notrace
#avnet_generate_ip cam_interface
#avnet_generate_ip zed_hdmi_out

# Create Vivado project
puts "***** Creating Vivado Project..."
source ../Boards/$board/[string tolower $board].tcl -notrace
avnet_create_project $project $projects_folder $scriptdir
#
remove_files -fileset constrs_1 *.xdc
# Add board specific constraint file
switch -nocase $board {
   ZEDBOARD   {
			  set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
              add_files -fileset constrs_1 -norecurse ${projects_folder}/../zedboard_tdm114.xdc
              }
   default    {puts "Unsupported Board!"
               return -code ok}
}

# Add Avnet IP Repository
puts "***** Updating Vivado to include IP Folder"
cd ../Projects/$project
set_property ip_repo_paths  ../../IP [current_fileset]
update_ip_catalog

# Create Block Design and Add PS core
puts "***** Creating Block Design..."
create_bd_design ${project}
avnet_add_ps $project $projects_folder $scriptdir
# Apply board specific settings
#switch -nocase $board {
#}

# General Config
puts "***** General Configuration for Design..."
set_property target_language VHDL [current_project]

# Check for Video IP core licenses
puts "***** Check for Video IP core licenses..."
set v_cfa_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cfa v_cfa_0 ]
set v_cresample_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cresample v_cresample_0 ]
set v_osd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_osd v_osd_0 ]
set v_rgb2ycrcb_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_rgb2ycrcb v_rgb2ycrcb_0 ]
set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc v_tc_0 ]
report_ip_status -file "video_ip_core_status.log"
set core_list [list "v_cfa" "v_cresample" "v_osd" "v_rgb2ycrcb" "v_tc" ]
set valid_cores [validate_core_licenses $core_list "video_ip_core_status.log"]
if { $valid_cores < 5 } {
   puts " 
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-                                                     -*
*-  !! Detected missing license for video ip cores !!  -*
*-                                                     -*
*-  For more details, refer to IP status report:   !!  -*
*-     video_ip_core_status_report.log                 -*
*-                                                     -*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*"	
   error "!! Detected missing license for video ip cores !!"
}
delete_bd_objs [get_bd_cells v_cfa_0]
delete_bd_objs [get_bd_cells v_cresample_0]
delete_bd_objs [get_bd_cells v_osd_0]
delete_bd_objs [get_bd_cells v_rgb2ycrcb_0]
delete_bd_objs [get_bd_cells v_tc_0]

# Create Block Diagram
set design_name ${project}
# Create board specific block diagram
switch -nocase $board {
   ZEDBOARD   {
              set_property -dict [list CONFIG.preset {ZedBoard}] [get_bd_cells processing_system7_0]
              source ../../Scripts/ProjectScripts/zedboard_tdm114_bd.tcl
              }
   default    {puts "Unsupported Board!"
               return -code ok}
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
launch_runs impl_1 -to_step write_bitstream -j 8
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#*- KEEP OUT, do not touch this section unless you know what you are doing! -*
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
