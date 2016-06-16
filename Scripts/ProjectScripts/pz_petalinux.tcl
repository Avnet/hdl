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
avnet_create_project $project $projects_folder $scriptdir
# Remove the SOM specific XDC file since no constraints are needed for 
# the basic system design
remove_files -fileset constrs_1 *.xdc

# Apply board specific project property settings
switch -nocase $board {
   PZ7010_FMC2 {
      puts "***** Assigning Vivado Project board_part Property to picozed_7010_fmc2..."
      set_property board_part em.avnet.com:picozed_7010_fmc2:part0:1.1 [current_project]
   }

   PZ7015_FMC2 {
      puts "***** Assigning Vivado Project board_part Property to picozed_7015_fmc2..."
      set_property board_part em.avnet.com:picozed_7015_fmc2:part0:1.1 [current_project]
   }

   PZ7020_FMC2 {
      puts "***** Assigning Vivado Project board_part Property to picozed_7020_fmc2..."
      set_property board_part em.avnet.com:picozed_7020_fmc2:part0:1.1 [current_project]
   }
   
   PZ7030_FMC2 {
      puts "***** Assigning Vivado Project board_part Property to picozed_7030_fmc2..."
      set_property board_part em.avnet.com:picozed_7030_fmc2:part0:1.1 [current_project]
   }
}

# Create Block Design and Add PS core
puts "***** Creating Block Design..."
create_bd_design ${project}
set design_name ${project}
avnet_add_ps_preset $project $projects_folder $scriptdir

# Add preset IP from board definitions
avnet_add_user_io_preset $project $projects_folder $scriptdir

# General Config
puts "***** General Configuration for Design..."
set_property target_language VHDL [current_project]

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
}
