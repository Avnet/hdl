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
#  Create Date:         May 14, 2017
#  Design Name:         MiniZed Basic Microphone HW Platform
#  Module Name:         minized_mic.tcl
#  Project Name:        MiniZed Basic Microphone
#  Target Devices:      Xilinx Zynq-7007
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Vivado 2017.1
# 
#  Description:         Build Script for MiniZed Basic Microphone HW Platform
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration 
#                       scripts IP generation scripts or others as needed
# 
#
#  Revision:            May 14, 2017: 1.00 Initial version
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
   MINIZED {
      puts "***** Assigning Vivado Project board_part Property to minized..."
      set_property board_part em.avnet.com:minized:part0:1.1 [current_project]
   }
}

# Generate Avnet IP
puts "***** Generating MiniZed microphone_mgr IP..."
source ./makeip.tcl -notrace
avnet_generate_ip microphone_mgr

# Add Avnet IP Repository
puts "***** Updating Vivado to include IP Folder"
cd ../Projects/$project
set_property ip_repo_paths  ../../IP [current_fileset]
update_ip_catalog


# Create Block Design and Add PS core
puts "***** Creating Block Design..."
create_bd_design ${project}
set design_name ${project}
avnet_add_custom_ps $project $projects_folder $scriptdir


# Add preset IP from board definitions
avnet_add_user_io_preset $project $projects_folder $scriptdir


# General Config
puts "***** General Configuration for Design..."
set_property target_language VHDL [current_project]


# Add MiniZed microphone
puts "***** Adding MiniZed PDM microphone demodulation filter (SysGen IP)..."
create_bd_cell -type ip -vlnv Avnet_Inc:SysGen:pdm_filt:1.0 pdm_filt_0
connect_bd_net [get_bd_pins pdm_filt_0/clk] [get_bd_pins processing_system7_0/FCLK_CLK2]


# Create instance: microphone_mgr, and set properties
set microphone_mgr_0 [ create_bd_cell -type ip -vlnv avnet.com:ip:microphone_mgr:1.0 microphone_mgr_0 ]
connect_bd_net [get_bd_pins microphone_mgr_0/clk_in] [get_bd_pins processing_system7_0/FCLK_CLK2]
connect_bd_net [get_bd_pins microphone_mgr_0/resetn_in] [get_bd_pins processing_system7_0/FCLK_RESET2_N]
connect_bd_net [get_bd_pins pdm_filt_0/PDM_IN] [get_bd_pins microphone_mgr_0/AUDIO_PDM]

# Create BD ports to external pins of microphone
create_bd_port -dir I AUDIO_DAT
connect_bd_net [get_bd_ports AUDIO_DAT] [get_bd_pins microphone_mgr_0/AUDIO_DAT]
create_bd_port -dir O AUDIO_CLK
connect_bd_net [get_bd_pins microphone_mgr_0/AUDIO_CLK] [get_bd_ports AUDIO_CLK]

# Create BD ports to LEDs
# ->->->-> this should use board automation, but can't get it to work (May 3, 2017) -- see line 62 .\boards\MINIZED\MINIZED.tcl
# ...      C:\Xilinx\Vivado\2016.4\data\boards\board_files\minized\1.1\part0_pins.xml
# create_bd_port -dir O pl_led_r_tri_o
# connect_bd_net [get_bd_ports pl_led_r_tri_o] [get_bd_pins axi_gpio_1/gpio_io_o]
# create_bd_port -dir O pl_led_g_tri_o
# connect_bd_net [get_bd_ports pl_led_g_tri_o] [get_bd_pins axi_gpio_1/gpio_io_o]

# Create ILA to capture raw PDM (single-bit) output of mic -- this can be used to export raw PDM to Simulink model as input stimulus
# Note: PDM data from the mic is collected into 1024-bit vectors in microphone_mgr_0 code
#       ... this is done to maximize usage of BRAM storage, otherwise would max out if captured as single-bits
#       ... must de-serialize when reading into MATLAB
# When capturing data in ILA, use microphone_mgr_0/PDM_vector_full_STROBE to qualify capture control to PDM capture at output sample rate of 160MHz/64 = 2.5 MSPS in 160 MHz clock domain
create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0
set_property -dict [list CONFIG.C_PROBE2_TYPE {1} CONFIG.C_PROBE1_TYPE {1} CONFIG.C_PROBE1_WIDTH {1024} CONFIG.C_NUM_OF_PROBES {3} CONFIG.C_EN_STRG_QUAL {1} CONFIG.C_MONITOR_TYPE {Native} CONFIG.C_PROBE2_MU_CNT {2} CONFIG.C_PROBE1_MU_CNT {2} CONFIG.C_PROBE0_MU_CNT {2} CONFIG.ALL_PROBE_SAME_MU_CNT {2} CONFIG.C_ENABLE_ILA_AXI_MON {false}] [get_bd_cells ila_0]
connect_bd_net [get_bd_pins ila_0/clk] [get_bd_pins processing_system7_0/FCLK_CLK2] 
connect_bd_net [get_bd_pins microphone_mgr_0/PDM_vector_full_STROBE] [get_bd_pins ila_0/probe0]
connect_bd_net [get_bd_pins microphone_mgr_0/audio_data_vector_OUT] [get_bd_pins ila_0/probe1]
connect_bd_net [get_bd_pins microphone_mgr_0/audio_captureCE] [get_bd_pins ila_0/probe2]


# Create ILA to capture audio output of mic
# When capturing data in ILA, use CE from pdm_filt_0 to qualify capture control to capture audio data at output sample rate of 160MHz/(64*64) = 39.0625 KSPS in 160 MHz clock domain
create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_1
set_property -dict [list CONFIG.C_MONITOR_TYPE {Native} CONFIG.C_DATA_DEPTH {16384} CONFIG.C_PROBE1_TYPE {1} CONFIG.C_PROBE1_WIDTH {16} CONFIG.C_NUM_OF_PROBES {2} CONFIG.C_EN_STRG_QUAL {1} CONFIG.C_PROBE1_MU_CNT {2} CONFIG.C_PROBE0_MU_CNT {2} CONFIG.ALL_PROBE_SAME_MU_CNT {2}] [get_bd_cells ila_1]
connect_bd_net [get_bd_pins ila_1/clk] [get_bd_pins processing_system7_0/FCLK_CLK2] 
connect_bd_net [get_bd_pins pdm_filt_0/audio_ce] [get_bd_pins ila_1/probe0]
connect_bd_net [get_bd_pins pdm_filt_0/audio_out] [get_bd_pins ila_1/probe1]


# add selection for proper xdc based on needs
add_files -fileset constrs_1 -norecurse $scriptdir/../Boards/MINIZED/minized_mic.xdc
add_files -fileset constrs_1 -norecurse $scriptdir/../Boards/MINIZED/minized_pins.xdc
add_files -fileset constrs_1 -norecurse $scriptdir/../Boards/MINIZED/minized_LEDs.xdc


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
