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
#                      Copyright(c) 2014 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         March 20, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     PicoZed FMC Carrier Card V1 + V2
# 
#  Tool versions:       Vivado 2014.4
# 
#  Description:         Build Script for Toshiba TCM3232PB Frame Buffer design
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration scripts
#                          IP generation scripts or others
# 
# ----------------------------------------------------------------------------

# 'private' used to allow this project to be privately tagged
# 'public' used to allow this project to be publicly tagged
set release_state public

# Generate Avnet IP
puts "***** Generating IP..."
source ./makeip.tcl -notrace
#avnet_generate_ip tcm_receiver
#avnet_generate_ip avnet_hdmi_out

# Create Vivado project
puts "***** Creating Vivado Project..."
source ../Boards/$board/[string tolower $board].tcl -notrace
avnet_create_project $project $projects_folder $scriptdir
#
remove_files -fileset constrs_1 *.xdc
# Set the IO pin mapping
if {[string match -nocase "PZ7015_FMCCC" $board] || [string match -nocase "PZ7030_FMCCC" $board]} { 
         add_files -fileset constrs_1 -norecurse ${projects_folder}/../fmccc_io.xdc
      } else {
         add_files -fileset constrs_1 -norecurse ${projects_folder}/../fmc2_io.xdc
      }

# Set the IO voltage standard
if {[string match -nocase "PZ7015_FMCCC" $board] || [string match -nocase "PZ7015_FMC2" $board]} { 
         add_files -fileset constrs_1 -norecurse ${projects_folder}/../vstd_3p3.xdc
      } else {
         add_files -fileset constrs_1 -norecurse ${projects_folder}/../vstd_1p8.xdc
      }

# Add Avnet IP Repository
puts "***** Updating Vivado to include IP Folder"
cd ../Projects/$project
set_property ip_repo_paths  ../../IP [current_fileset]
update_ip_catalog

# Create Block Design and Add PS core
puts "***** Creating Block Design..."
create_bd_design ${project}
#avnet_add_ps $project $projects_folder $scriptdir
# Apply board specific settings
#      source ../../Scripts/ProjectScripts/pz_fmcc_pcie_pio_prst.tcl

# General Config
puts "***** General Configuration for Design..."
set_property target_language VHDL [current_project]

# Check for Video IP core licenses

# Create Block Diagram
set design_name ${project}
if {[string match -nocase "PZ7015_FMCCC" $board] || [string match -nocase "PZ7015_FMC2" $board]} { 
         source ../../Scripts/ProjectScripts/pz15_pcie_pio_bd.tcl
      } else {
         source ../../Scripts/ProjectScripts/pz30_pcie_pio_bd.tcl
      }


puts "***** Validating Layout for Block Design..."
validate_bd_design
puts "***** Regenerating Layout for Block Design..."
regenerate_bd_layout

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
# Added due to HOW the PCIE IP was generated using a Board Preset
update_ip_catalog -rebuild -scan_changes
launch_runs impl_1 -to_step write_bitstream
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#*- KEEP OUT, do not touch this section unless you know what you are doing! -*
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
