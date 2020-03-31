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
#  Please direct any questions to the PicoZed community support forum:
#     http://avnet.me/microzed_forum
# 
#  Product information is available at:
#     http://avnet.me/microzed
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
#  Create Date:         Mar 26, 2016
#  Design Name:         MicroZed PetaLinux BSP HW Platform
#  Module Name:         mz_petalinux.tcl
#  Project Name:        MicroZed PetaLinux BSP Generator
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MicroZed SOM
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         Build Script for MicroZed PetaLinux BSP HW Platform
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration 
#                       scripts IP generation scripts or others as needed
# 
#
#  Revision:            Mar 26, 2016: 1.00 Initial version
#                       Jun 16, 2016: 1.1  Updated to support 2015.4 tools
#                       Jul 01, 2016: 1.2  Updated to support 2016.2 tools
#                       Oct 10, 2017: 1.3  Updated to support 2017.2 tools
#                       May 03, 2018: 1.4  Updated to support 2017.4 tools
#                       Aug 11, 2018: 1.5  Updated to support 2018.2 tools
#                       Sep 20, 2019: 1.6  Updated to support 2019.1 tools
#                       Feb 12, 2020: 1.7  Updated to support 2019.2 tools
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
#TC   avnet_create_project $project $projects_folder $scriptdir
   avnet_create_project $board $projects_folder $scriptdir
   # Remove the SOM specific XDC file since no constraints are needed for 
   # the basic system design
   remove_files -fileset constrs_1 *.xdc
   
   # Apply board specific project property settings
   switch -nocase $board {
      MZ7010_FMCCC {
         puts ""
         puts "***** Assigning Vivado Project board_part Property to microzed_7010..."
         set_property board_part em.avnet.com:microzed_7010:part0:1.2 [current_project]
      }
   
      MZ7020_FMCCC {
         puts ""
         puts "***** Assigning Vivado Project board_part Property to microzed_7020..."
         set_property board_part em.avnet.com:microzed_7020:part0:1.2 [current_project]
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
   #import_files -fileset constrs_1 -norecurse ../../Boards/${board}/${project}.xdc
   
   # Add Project source files
   puts ""
   puts "***** Adding Source Files to Block Design..."
#TC   make_wrapper -files [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd] -top
#TC   add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.vhd
   make_wrapper -files [get_files ${projects_folder}/${board}.srcs/sources_1/bd/${board}/${board}.bd] -top
   add_files -norecurse ${projects_folder}/${board}.srcs/sources_1/bd/${board}/hdl/${board}_wrapper.vhd
   #add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.v
   
   
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
   write_hw_platform -fixed -file ${projects_folder}/${board}.xsa -include_bit -force
   validate_hw_platform ${projects_folder}/${board}.xsa -verbose
   puts "***** Close the implemented design..."
   close_design
}
