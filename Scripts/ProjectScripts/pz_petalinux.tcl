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
#  Please direct any questions to the PicoZed community support forum:
#     http://www.picozed.org/forum
# 
#  Product information is available at:
#     http://www.picozed.org/product/picozed
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
#  Create Date:         Feb 08, 2016
#  Design Name:         PicoZed PetaLinux BSP HW Platform
#  Module Name:         pz_petalinux.tcl
#  Project Name:        PicoZed PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed SOM
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         Build Script for PicoZed PetaLinux BSP HW Platform
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration 
#                       scripts IP generation scripts or others as needed
# 
#
#  Revision:            Feb 08, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

# 'private' used to allow this project to be privately tagged
# 'public' used to allow this project to be publicly tagged
set release_state public

if {[string match -nocase "yes" $clean]} {
   # Clean up project output products.

   # Open the existing project.
   puts ""
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
puts ""
puts "***** Creating Vivado Project..."
source ../Boards/$board/$board.tcl -notrace
#avnet_create_project $project $projects_folder $scriptdir
avnet_create_project $board $projects_folder $scriptdir
# Remove the SOM specific XDC file since no constraints are needed for 
# the basic system design
remove_files -fileset constrs_1 *.xdc

# Apply board specific project property settings
switch -nocase $board {
   PZ7010_FMC2 {
      puts ""
      puts "***** Assigning Vivado Project board_part Property to picozed_7010_fmc2..."
      set_property board_part em.avnet.com:picozed_7010_fmc2:part0:1.2 [current_project]
   }

   PZ7015_FMC2 {
      puts ""
      puts "***** Assigning Vivado Project board_part Property to picozed_7015_fmc2..."
      set_property board_part em.avnet.com:picozed_7015_fmc2:part0:1.2 [current_project]
   }

   PZ7020_FMC2 {
      puts ""
      puts "***** Assigning Vivado Project board_part Property to picozed_7020_fmc2..."
      set_property board_part em.avnet.com:picozed_7020_fmc2:part0:1.2 [current_project]
   }
   
   PZ7030_FMC2 {
      puts ""
      puts "***** Assigning Vivado Project board_part Property to picozed_7030_fmc2..."
      set_property board_part em.avnet.com:picozed_7030_fmc2:part0:1.2 [current_project]
   }
}

# Add Avnet IP Repository
puts ""
puts "***** Updating Vivado to include IP Folder"
cd ../Projects/$project
set_property ip_repo_paths  ../../IP [current_project]
update_ip_catalog

# Create Block Design and add Zynq PS
puts ""
puts "***** Creating Block Design..."
#create_bd_design ${project}
#set design_name ${project}
create_bd_design ${board}
set design_name ${board}
#avnet_add_ps_preset $project $projects_folder $scriptdir
avnet_add_ps_preset $board $projects_folder $scriptdir

# Add preset IP from board definitions
puts ""
puts "***** Add defined IP blocks to Block Design..."
#avnet_add_user_io_preset $project $projects_folder $scriptdir
avnet_add_user_io_preset $board $projects_folder $scriptdir

# Add the AXI_IIC and associated I/O constraints
puts ""
puts "***** Add the AXI_IIC and constraints..."
# Add the AXI_IIC IP block and make the connections
#avnet_add_i2c_ip $project $projects_folder $scriptdir
avnet_add_i2c_ip $board $projects_folder $scriptdir
# Add the constraints that are needed for testing
#avnet_add_i2c $project $projects_folder $scriptdir
avnet_add_i2c $board $projects_folder $scriptdir

# Check design IPs
set bCheckIPsPassed 1
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_iic:2.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
"

   set list_ips_missing ""
   puts "INFO: Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      puts "ERROR: The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." 
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  puts "WARNING: Will not continue with creation of design due to the error(s) above."
  return 3
}


# General Config
puts ""
puts "***** General Configuration for Design..."
set_property target_language VHDL [current_project]

# Add Project source files
puts ""
puts "***** Adding Source Files to Block Design..."
#make_wrapper -files [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd] -top
#add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.vhd
   make_wrapper -files [get_files ${projects_folder}/${board}.srcs/sources_1/bd/${board}/${board}.bd] -top
   add_files -norecurse ${projects_folder}/${board}.srcs/sources_1/bd/${board}/hdl/${board}_wrapper.vhd


# Build the binary
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#*- KEEP OUT, do not touch this section unless you know what you are doing! -*
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
puts ""
puts "***** Building Binary..."
# add this to allow up+enter rebuild capability 
cd $scripts_folder
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
save_bd_design
launch_runs impl_1 -to_step write_bitstream -j 6
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#*- KEEP OUT, do not touch this section unless you know what you are doing! -*
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
}
