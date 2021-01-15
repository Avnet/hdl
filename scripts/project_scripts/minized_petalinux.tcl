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
#  Please direct any questions to the MiniZed community support forum:
#     http://www.minized.org/forum
# 
#  Product information is available at:
#     http://www.minized.org/product/minized
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
#  Create Date:         Feb 03, 2017
#  Design Name:         MiniZed PetaLinux BSP HW Platform
#  Module Name:         minized_petalinux.tcl
#  Project Name:        MiniZed PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq-7007
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Vivado 2016.4
# 
#  Description:         Build Script for MiniZed PetaLinux BSP HW Platform
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration 
#                       scripts IP generation scripts or others as needed
# 
#
#  Revision:            Feb 03, 2017: 1.00 Initial version
#                       Apr 06, 2020: 1.01 Updated for 2019.2 tools
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
   source ../boards/$board/$board.tcl -notrace
   avnet_create_project $board $projects_folder $scriptdir
   
   # Remove the SOM specific XDC file since no constraints are needed for 
   # the basic system design
   remove_files -fileset constrs_1 *.xdc
   
   # Apply board specific project property settings
   switch -nocase $board {
      minized_sbc {
         puts "***** Assigning Vivado Project board_part Property to minized..."
         set_property board_part em.avnet.com:minized:part0:1.2 [current_project]
      }
      minized7010 {
         puts "***** Assigning Vivado Project board_part Property to minized7z010..."
         set_property board_part em.avnet.com:minized7z010:part0:1.1 [current_project]
      }
   }

   # Generate Avnet IP
   puts ""
   puts "***** Generating IP..."
   source ./makeip.tcl -notrace
   # avnet_generate_ip microphone_mgr

   # Add Avnet IP Repository
   # The IP_REPO_PATHS looks for a <component>.xml file, where <component> is the name of the IP to add to the catalog. The XML file identifies the various files that define the IP.
   # The IP_REPO_PATHS property does not have to point directly at the XML file for each IP in the repository.
   # The IP catalog searches through the sub-folders of the specified IP repositories, looking for IP to add to the catalog. 
   puts ""
   puts "***** Updating Vivado to include IP Folder"
   cd ../projects
   set_property ip_repo_paths  ../ip [current_fileset]
   update_ip_catalog
   
   # Add Project source files
   puts "***** Adding Source Files to Block Design..."
   # Add Minized-specific RTL design sources
   # Set 'sources_1' fileset object
   set obj [get_filesets sources_1]
   set files [list \
    "[file normalize "../ip/minized/hdl/vhdl/wireless_mgr.vhd"]" \
    "[file normalize "../ip/minized/hdl/vhdl/led_mgr.vhd"]" \
    "[file normalize "../ip/minized/hdl/vhdl/microphone_mgr.vhd"]" \
   ]
   add_files -norecurse -fileset $obj $files
   update_compile_order -fileset sources_1
      
   # Create Block Design and Add PS core
   puts ""
   puts "***** Creating Block Design..."
   create_bd_design ${board}
   set design_name ${board}

   # Add RTL-based IP modules without having to go through the process of packaging the RTL as an IP to be added through the Vivado IP catalog. 
   # See 'Referencing RTL Modules' in Xilinx UG994
   source ../scripts/make_RTL_ip.tcl
   avnet_generate_RTL_ip wireless_mgr wireless_mgr_0
   avnet_generate_RTL_ip led_mgr led_mgr_0
   avnet_generate_RTL_ip microphone_mgr microphone_mgr_0
   
   # Add Processing System presets from board definitions.
   avnet_add_ps_preset $board $projects_folder $scriptdir

   # Add User IO presets from board definitions.
   puts ""
   puts "***** Add defined IP blocks to Block Design..."
   avnet_add_user_io_preset $board $projects_folder $scriptdir

   # General Config
   puts ""
   puts "***** General Configuration for Design..."
   set_property target_language VHDL [current_project]
   #set_property target_language Verilog [current_project]
   
   # Add the constraints that are needed
   import_files -fileset constrs_1 -norecurse ${boards_folder}/bitstream_compression_enable.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}.xdc

   # Add Project source files
   puts ""
   puts "***** Adding Source Files to Block Design..."
   make_wrapper -files [get_files ${projects_folder}/${board}.srcs/sources_1/bd/${board}/${board}.bd] -top
   add_files -norecurse ${projects_folder}/${board}.srcs/sources_1/bd/${board}/hdl/${board}_wrapper.vhd
   
   # Add Vitis directives
   puts ""
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
   write_hw_platform ${projects_folder}/${board}.xsa -include_bit -force
   validate_hw_platform ${projects_folder}/${board}.xsa -verbose
   puts ""
   puts "***** Close the implemented design..."
   close_design
}
