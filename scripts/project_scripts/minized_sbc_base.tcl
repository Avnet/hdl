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
#     http://avnet.me/minized_forum
# 
#  Product information is available at:
#     http://avnet.me/minized
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
#  Create Date:         Feb 03, 2017
#  Design Name:         MiniZed Base HW Platform
#  Module Name:         minized_sbc_base.tcl
#  Project Name:        MiniZed Base HW
#  Target Devices:      Xilinx Zynq-7007
#  Hardware Boards:     MiniZed
# 
# ----------------------------------------------------------------------------

# 'private' used to allow this project to be privately tagged
# 'public' used to allow this project to be publicly tagged
set release_state public

if {[string match -nocase "yes" $clean]} {
   # Clean up project output products.

   # Open the existing project.
   puts ""
   puts "***** Opening Vivado project ${projects_folder}/${board}_${project}.xpr ..."
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
   puts "***** Creating Vivado project..."
   source ${boards_folder}/$board/$project/${board}_${project}.tcl -notrace
   avnet_create_project ${board}_${project} $projects_folder $scriptdir
   
   # Set synthesis language for project
   # Can be set to either VHDL or Verilog
   set synth_lang VHDL
   puts ""
   puts "***** Setting synthesis language for project to ${synth_lang}..."
   set_property target_language ${synth_lang} [current_project]

   # Import the constraints that are needed
   puts ""
   puts "***** Importing constraints file(s)..."
   avnet_import_constraints ${boards_folder} ${board} ${project}

   # Apply board specific project property settings
   puts ""
   puts "***** Assigning Vivado project board_part property to minized..."
   set_property board_part avnet.com:minized:part0:1.3 [current_project]

   # Generate Avnet IP
   puts ""
   puts "***** Generating IP..."
   source ./makeip.tcl -notrace
   #avnet_generate_ip microphone_mgr

   # Add Avnet IP repository
   # The IP_REPO_PATHS looks for a <component>.xml file, where <component> is the name of the IP to add to the catalog. 
   # The XML file identifies the various files that define the IP.
   # The IP_REPO_PATHS property does not have to point directly at the XML file for each IP in the repository.
   # The IP catalog searches through the sub-folders of the specified IP repositories, looking for IP to add to the catalog. 
   puts ""
   puts "***** Updating Vivado to include IP folder"
   cd ../projects
   set_property ip_repo_paths  ../ip [current_fileset]
   update_ip_catalog
   
   # Create block design
   puts ""
   puts "***** Creating block design..."
   create_bd_design ${board}_${project}
   set design_name ${board}_${project}
   
   # Add project RTL source files
   puts "***** Adding RTL source Files to design..."
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

   # Add custom RTL IP blocks
   puts ""
   puts "***** Adding custom RTL IP blocks to block design..."
   # Add RTL-based IP modules without having to go through the process of packaging the RTL as an IP to be added through the Vivado IP catalog. 
   # See 'Referencing RTL Modules' in Xilinx UG994
   source ../scripts/make_RTL_ip.tcl
   avnet_generate_RTL_ip wireless_mgr wireless_mgr_0
   avnet_generate_RTL_ip led_mgr led_mgr_0
   avnet_generate_RTL_ip microphone_mgr microphone_mgr_0
   
   # Add processing system presets from board definitions.
   puts ""
   puts "***** Adding processing system presets from board definition..."
   avnet_add_ps_preset ${board}_${project} $projects_folder $scriptdir

   # Add User IO presets from board definitions.
   puts ""
   puts "***** Adding defined IP blocks to block design..."
   avnet_add_user_io_preset ${board}_${project} $projects_folder $scriptdir

   # Assign peripheral addresses
   puts ""
   puts "***** Assigning peripheral addresses..."
   avnet_assign_addresses ${board}_${project} $projects_folder $scriptdir

   # Redraw the BD and validate the design
   puts ""
   puts "***** Validating the block design..."
   regenerate_bd_layout
   save_bd_design
   validate_bd_design

   # Make sure user has required IP licenses before building the design
   puts ""
   puts "***** Validating IP licenses..."
   source $scripts_folder/validate_ip_licenses.tcl
   set ret [validate_ip_licenses ${board}_${project}]
   if {$ret != 0} {
      error "!! Detected missing license !!"
   }

   # Create HDL wrapper for design and add to project
   puts ""
   puts "***** Creating top level HDL wrapper for design and adding to project..."
   make_wrapper -files [get_files ${projects_folder}/${board}_${project}.srcs/sources_1/bd/${board}_${project}/${board}_${project}.bd] -top
   # Fetch the synthesis language setting for the project and add the corresponding file to the project
   # The synthesis language can be set to either VHDL (<>.vhd file) or Verilog (<>.v file)
   if { {VHDL} == [get_property target_language [current_project]] } {
      add_files -norecurse ${projects_folder}/${board}_${project}.srcs/sources_1/bd/${board}_${project}/hdl/${board}_${project}_wrapper.vhd
   } else {
      add_files -norecurse ${projects_folder}/${board}_${project}.srcs/sources_1/bd/${board}_${project}/hdl/${board}_${project}_wrapper.v
   }
   
   # Add Vitis directives
   puts ""
   puts "***** Adding Vitis directves to design..."
   avnet_add_vitis_directives ${board}_${project} $projects_folder $scriptdir
   update_compile_order -fileset sources_1
   import_files
   
   # Build the binary
   #*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
   #*- KEEP OUT, do not touch this section unless you know what you are doing! -*
   #*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
   puts ""
   puts "***** Building binary..."
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
