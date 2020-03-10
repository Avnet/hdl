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
   source ../Boards/$board/$project.tcl -notrace
#TC   avnet_create_project $project $projects_folder $scriptdir
   avnet_create_project $board $projects_folder $scriptdir
   
   # Apply board specific project property settings
   switch -nocase $board {
      ULTRA96V2 {
         puts "***** Assigning Vivado Project board_part Property to ultra96v2..."
         set_property board_part em.avnet.com:ultra96v2:part0:1.0 [current_project]
      }
   }

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
   cd ../Projects/$project
   set_property ip_repo_paths  ../../IP [current_fileset]
   update_ip_catalog
   
   # Create Block Design and Add PS core
   puts ""
   puts "***** Creating Block Design..."
#TC   create_bd_design ${project}
#TC   set design_name ${project}
   create_bd_design ${board}
   set design_name ${board}
   
   # Add Processing System presets from board definitions.
#TC   avnet_add_ps_preset $project $projects_folder $scriptdir
   avnet_add_ps_preset $board $projects_folder $scriptdir

   # Add User IO presets from board definitions.
   puts ""
   puts "***** Add defined IP blocks to Block Design..."
#TC   avnet_add_user_io_preset $project $projects_folder $scriptdir
   avnet_add_user_io_preset $board $projects_folder $scriptdir

   # General Config
   puts ""
   puts "***** General Configuration for Design..."
   set_property target_language VHDL [current_project]
   #set_property target_language Verilog [current_project]
   
   # Add the constraints that are needed
   import_files -fileset constrs_1 -norecurse ../../Boards/${board}/${project}.xdc
   
   # Add Project source files
   puts ""
   puts "***** Adding Source Files to Block Design..."
#TC   make_wrapper -files [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd] -top
#TC   add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.vhd
   make_wrapper -files [get_files ${projects_folder}/${board}.srcs/sources_1/bd/${board}/${board}.bd] -top
   add_files -norecurse ${projects_folder}/${board}.srcs/sources_1/bd/${board}/hdl/${board}_wrapper.vhd
   #add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.v
   
   # Add Vitis directives
   puts ""
#TC   puts "***** Adding SDSoC Directves to Design..."
#TC   avnet_add_sdsoc_directives $project $projects_folder $scriptdir
#TC   avnet_add_sdsoc_directives $board $projects_folder $scriptdir
   puts "***** Adding Vitis Directves to Design..."
   avnet_add_vitis_directives $board $projects_folder $scriptdir
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
   #launch_runs impl_1 -to_step write_bitstream -j 4
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
#TC   write_dsa ${projects_folder}/${project}.dsa -include_bit -force
#TC   validate_dsa ${projects_folder}/${project}.dsa -verbose
   write_hw_platform ${projects_folder}/${board}.xsa -include_bit -force
   validate_hw_platform ${projects_folder}/${board}.xsa -verbose
   puts "***** Close the implemented design..."
   close_design
}
