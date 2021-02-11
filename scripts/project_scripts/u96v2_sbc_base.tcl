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
#     http://www.ultrazed.org/product/ultrazed
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
#  Create Date:         Apr 04, 2019
#  Design Name:         Ultra96v2 OOB PetaLinux BSP HW Platform
#  Module Name:         make_ultra96v2_oob.tcl
#  Project Name:        Ultra96v2 OOB PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96v2 Board
# 
#  Tool versions:       Xilinx Vivado 2018.3
# 
#  Description:         Build Script for Ultra96v2 OOB PetaLinux BSP HW Platform
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration 
#                       scripts IP generation scripts or others as needed
# 
#
#  Revision:            Apr 04, 2019: 1.00 Initial version
#                       Oct 14, 2019: 1.01 Updated for Vivado 2019.1
#                       Jan 22, 2020: 1.02 Updated for Vivado 2019.2
# 
# ----------------------------------------------------------------------------

# 'private' used to allow this project to be privately tagged
# 'public' used to allow this project to be publicly tagged
set release_state public

if {[string match -nocase "yes" $clean]} {
   # Clean up project output products.

   # Open the existing project.
   puts ""
   puts "***** Opening Vivado Project ${projects_folder}/${board}_${project}.xpr ..."
   open_project ${projects_folder}/${board}_${project}.xpr
   
   # Reset output products.
   reset_target all [get_files ${projects_folder}/${board}_${project}.srcs/sources_1/bd/${board}_${project}/${project}.bd]

   # Reset design runs.
   reset_run impl_1
   reset_run synth_1

   # Reset project.
   reset_project
} else {
   # Create Vivado project
   puts ""
   puts "***** Creating Vivado Project..."
   source ${boards_folder}/$board/$project/${board}_${project}.tcl -notrace
   avnet_create_project ${board}_${project} $projects_folder $scriptdir
   
   
   # Remove the SOM specific XDC file since no constraints are needed for 
   # the basic system design
   remove_files -fileset constrs_1 *.xdc
   
   # Apply board specific project property settings
   puts ""
   puts "***** Assigning Vivado Project board_part Property to ultra96v2..."
   set_property board_part avnet.com:ultra96v2:part0:1.1 [current_project]

   # Generate Avnet IP
   puts ""
   puts "***** Generating IP..."
   source ./makeip.tcl -notrace
   #avnet_generate_ip PWM_w_Int

   # Add Avnet IP Repository
   # The IP_REPO_PATHS looks for a <component>.xml file, where <component> is the name of the IP to add to the catalog. The XML file identifies the various files that define the IP.
   # The IP_REPO_PATHS property does not have to point directly at the XML file for each IP in the repository.
   # The IP catalog searches through the sub-folders of the specified IP repositories, looking for IP to add to the catalog. 
   puts ""
   puts "***** Updating Vivado to include IP Folder"
   cd ../projects
   set_property ip_repo_paths  ../ip [current_fileset]
   update_ip_catalog
   
   # Create Block Design and Add PS core
   puts ""
   puts "***** Creating Block Design..."
   create_bd_design ${board}_${project}
   set design_name ${board}_${project}
   
   # Add Processing System presets from board definitions.
   avnet_add_ps_preset ${board}_${project} $projects_folder $scriptdir

   # Add User IO presets from board definitions.
   puts ""
   puts "***** Add defined IP blocks to Block Design..."
   avnet_add_user_io_preset ${board}_${project} $projects_folder $scriptdir

   # Assign the peripheral addresses
   assign_bd_address

   # Regenerate the BD to make it more readable and validate it 
   regenerate_bd_layout
   save_bd_design
   validate_bd_design

   # General Config
   puts ""
   puts "***** General Configuration for Design..."
   set_property target_language VHDL [current_project]
   #set_property target_language Verilog [current_project]
   
   # Add the constraints that are needed
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${board}_${project}.xdc
   
   # Add Project source files
   puts ""
   puts "***** Adding Source Files to Block Design..."
   make_wrapper -files [get_files ${projects_folder}/${board}_${project}.srcs/sources_1/bd/${board}_${project}/${board}_${project}.bd] -top
   add_files -norecurse ${projects_folder}/${board}_${project}.srcs/sources_1/bd/${board}_${project}/hdl/${board}_${project}_wrapper.vhd
   #add_files -norecurse ${projects_folder}/${board}_${project}.srcs/sources_1/bd/${board}_${project}/hdl/${board}_${project}_wrapper.v
   
   # Add Vitis directives
   puts ""
   puts "***** Adding Vitis Directves to Design..."
   avnet_add_vitis_directives ${board}_${project} $projects_folder $scriptdir
   update_compile_order -fileset sources_1
   import_files
   
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
   launch_runs impl_1 -to_step write_bitstream -jobs $numberOfCores
   #*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
   #*- KEEP OUT, do not touch this section unless you know what you are doing! -*
   #*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
   puts ""
   puts "***** Wait for bitstream to be written..."
   wait_on_run impl_1
   puts ""
   puts "***** Open the implemented design..."
   open_run impl_1
   puts ""
   puts "***** Write and validate the design archive..."
   write_hw_platform -file ${projects_folder}/${board}_${project}.xsa -include_bit -force
   validate_hw_platform ${projects_folder}/${board}_${project}.xsa -verbose
   puts ""
   puts "***** Close the implemented design..."
   close_design
}
