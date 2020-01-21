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
# 
# ----------------------------------------------------------------------------

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
#TC   avnet_create_project $project $projects_folder $scriptdir
   avnet_create_project $board $projects_folder $scriptdir
   
   # Remove the SOM specific XDC file since no constraints are needed for 
   # the basic system design
   remove_files -fileset constrs_1 *.xdc
   
   # Apply board specific project property settings
   switch -nocase $board {
      MINIZED {
         puts "***** Assigning Vivado Project board_part Property to minized..."
         set_property board_part em.avnet.com:minized:part0:1.2 [current_project]
      }
      MINIZED7010 {
         puts "***** Assigning Vivado Project board_part Property to minized7z010..."
         set_property board_part em.avnet.com:minized7z010:part0:1.1 [current_project]
      }
   }
   
   # Generate Avnet IP
   puts "***** Generating IP..."
   source ./makeip.tcl -notrace
   # avnet_generate_ip microphone_mgr
   
   # Add Avnet IP Repository
   # The IP_REPO_PATHS looks for a <component>.xml file, where <component> is the name of the IP to add to the catalog. The XML file identifies the various files that define the IP.
   # The IP_REPO_PATHS property does not have to point directly at the XML file for each IP in the repository.
   # The IP catalog searches through the sub-folders of the specified IP repositories, looking for IP to add to the catalog. 
   puts "***** Updating Vivado to include IP Folder"
   cd ../Projects/$project
   set_property ip_repo_paths  ../../IP [current_fileset]
   update_ip_catalog
   
   # Add Avnet IP Repository
   #puts "***** Updating Vivado to include IP Folder"
   #cd ../Projects/$project
   #set_property ip_repo_paths  ../../IP [current_project]
   #update_ip_catalog
   
   # Add Project source files
   puts "***** Adding Source Files to Block Design..."
   # Add Minized-specific RTL design sources
   # Set 'sources_1' fileset object
   set obj [get_filesets sources_1]
   set files [list \
    "[file normalize "../../IP/minized/hdl/vhdl/wireless_mgr.vhd"]"\
   ]
   add_files -norecurse -fileset $obj $files
   update_compile_order -fileset sources_1
      
   # Create Block Design and Add PS core
   puts "***** Creating Block Design..."
#TC   create_bd_design ${project}
#TC   set design_name ${project}
   create_bd_design ${board}
   set design_name ${board}

   # Add RTL-based IP modules without having to go through the process of packaging the RTL as an IP to be added through the Vivado IP catalog. 
   # See 'Referencing RTL Modules' in Xilinx UG994
   source ../../Scripts/make_RTL_ip.tcl
   avnet_generate_RTL_ip wireless_mgr wireless_mgr_0
   
   # Add Processing System presets from board definitions.
#TC   avnet_add_ps_preset $project $projects_folder $scriptdir
   avnet_add_ps_preset $board $projects_folder $scriptdir
   
   # Add User IO presets from board definitions.
#TC   avnet_add_user_io_preset $project $projects_folder $scriptdir
   avnet_add_user_io_preset $board $projects_folder $scriptdir
   
   # General Config
   puts "***** General Configuration for Design..."
   set_property target_language VHDL [current_project]
   
   # Add the constraints that are needed
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/minized_LEDs.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/bitstream_compression_enable.xdc
   import_files -fileset constrs_1 -norecurse ${projects_folder}/../${project}.xdc

#TC   make_wrapper -files [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd] -top
#TC   add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.vhd
   make_wrapper -files [get_files ${projects_folder}/${board}.srcs/sources_1/bd/${board}/${board}.bd] -top
   add_files -norecurse ${projects_folder}/${board}.srcs/sources_1/bd/${board}/hdl/${board}_wrapper.vhd

   # Add SDSoC directives
   puts "***** Adding SDSoC Directves to Design..."
#TC   avnet_add_sdsoc_directives $project $projects_folder $scriptdir
   avnet_add_sdsoc_directives $board $projects_folder $scriptdir
   update_compile_order -fileset sources_1
   import_files
   
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
   launch_runs impl_1 -to_step write_bitstream -j 4
   #*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
   #*- KEEP OUT, do not touch this section unless you know what you are doing! -*
   #*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
   #save_bd_design
   #launch_runs impl_1 -to_step write_bitstream -jobs [numberOfCPUs]
   puts "***** Wait for bitstream to be written..."
   wait_on_run impl_1
   puts "***** Open the implemented design..."
   open_run impl_1
   puts "***** Write and validate the DSA..."
#TC   write_dsa ${projects_folder}/${project}.dsa -include_bit -force
#TC   validate_dsa ${projects_folder}/${project}.dsa -verbose
   write_dsa ${projects_folder}/${board}.dsa -include_bit -force
   validate_dsa ${projects_folder}/${board}.dsa -verbose
   puts "***** Close the implemented design..."
   close_design

}
