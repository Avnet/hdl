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
#  Create Date:         December 02, 2014
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     MicroZed, IO Carrier
# 
#  Tool versions:       Vivado 2014.4
# 
#  Description:         Build Script for sample project
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
#avnet_generate_ip spi_interface



# create a block design add PS
puts "***** Generating Block Design..."
source ../Boards/$board/$board.tcl -notrace
avnet_create_project $project $projects_folder $scriptdir

# Add Avnet IP Repository
puts "***** Updating Vivado to include IP Folder"
cd ../Projects/$project
set_property ip_repo_paths  ../../IP [current_fileset]
update_ip_catalog

# Create Block Design
puts "***** Creating Block Design..."
create_bd_design "design_1"
avnet_add_ps $project $projects_folder $scriptdir

# General Config
puts "***** General Configuration for Design..."
set_property target_language VHDL [current_project]

# Add Project source files
puts "***** Adding Source Files to Block Design..."
make_wrapper -files [get_files $repo_folder/Projects/sampleproject_working/$board/sampleproject_working.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse $repo_folder/Projects/sampleproject_working/$board/sampleproject_working.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.vhd

# Insert Avnet IP
puts "***** Inserting Avnet IP to Block Design..."
#create_bd_cell -type ip -vlnv Avnet.com:interface:pl_spi_engine_v1_0:1.0 pl_spi_engine_v1_0_0

# insert Xilinx IP and configure
puts "***** Inserting Xilinx IP to Block Design..."
#create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 blk_mem_gen_0
#set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}] [get_bd_cells blk_mem_gen_0]
#create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.3 mig_7series_0
#apply_bd_automation -rule xilinx.com:bd_rule:board -config {rst_polarity "ACTIVE_LOW" }  [get_bd_pins mig_7series_0/sys_rst]

# Wire Design
puts "***** Wiring Block Design..."

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
launch_runs impl_1 -to_step write_bitstream
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#*- KEEP OUT, do not touch this section unless you know what you are doing! -*
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
