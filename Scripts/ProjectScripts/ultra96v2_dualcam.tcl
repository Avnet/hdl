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
   avnet_create_project $project $projects_folder $scriptdir
#DWR   avnet_create_project $board $projects_folder $scriptdir
   
   # Apply board specific project property settings
   switch -nocase $board {
      ULTRA96V2 {
         puts "***** Assigning Vivado Project board_part Property to ultra96v2..."
         set_property board_part avnet.com:ultra96v2:part0:1.1 [current_project]
         #DWR merged in
         set obj [current_project]
         set proj_dir [get_property directory [current_project]]
         #DWR set _xil_proj_name_ "project_1"
         set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
         set_property -name "enable_vhdl_2008" -value "1" -objects $obj
         #set_property -name "ip_cache_permissions" -value "disable" -objects $obj
         #set_property -name "ip_output_repo" -value "$proj_dir/${project}.cache/ip" -objects $obj
         set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
         set_property -name "platform.board_id" -value "ultra96" -objects $obj
         #set_property -name "sim.central_dir" -value "$proj_dir/${project}.ip_user_files" -objects $obj
         #set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
         #set_property -name "sim.ipstatic.use_precompiled_libs" -value "0" -objects $obj
         #set_property -name "sim.use_ip_compiled_libs" -value "0" -objects $obj
         #set_property -name "simulator_language" -value "Mixed" -objects $obj
         #set_property -name "webtalk.activehdl_export_sim" -value "3" -objects $obj
         #set_property -name "webtalk.ies_export_sim" -value "3" -objects $obj
         #set_property -name "webtalk.modelsim_export_sim" -value "3" -objects $obj
         #set_property -name "webtalk.questa_export_sim" -value "3" -objects $obj
         #set_property -name "webtalk.riviera_export_sim" -value "3" -objects $obj
         #set_property -name "webtalk.vcs_export_sim" -value "3" -objects $obj
         #set_property -name "webtalk.xsim_export_sim" -value "3" -objects $obj
         set_property -name "xpm_libraries" -value "XPM_CDC XPM_FIFO XPM_MEMORY" -objects $obj
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
   create_bd_design ${project}
   set design_name ${project}
#DWR   create_bd_design ${board}
#DWR   set design_name ${board}
   
   # Add Processing System presets from board definitions.
   #avnet_add_ps_preset $project $projects_folder $scriptdir
#DWR   avnet_add_ps_preset $board $projects_folder $scriptdir

   # Add User IO presets from board definitions.
   puts ""
   puts "***** Add defined IP blocks to Block Design..."
   #avnet_add_user_io_preset $project $projects_folder $scriptdir
#DWR   avnet_add_user_io_preset $board $projects_folder $scriptdir

########################################
#DWR need to remove puts and create new puts to alert the stages - for now ignore and add in the heir blocks as they are
  # Create interface ports
  set mipi_phy_if_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0 ]


  # Create ports
  set CLK48M [ create_bd_port -dir O -type clk CLK48M ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {48000000} \
 ] $CLK48M
  set ICP3_I2C_ID_SELECT [ create_bd_port -dir O -from 0 -to 0 ICP3_I2C_ID_SELECT ]
  set SP3 [ create_bd_port -dir O -from 0 -to 0 SP3 ]
  set TRG_INPUT [ create_bd_port -dir O -from 0 -to 0 TRG_INPUT ]

  # Create instance: CAPTURE_PIPLINE
  create_hier_cell_CAPTURE_PIPLINE [current_bd_instance .] CAPTURE_PIPLINE

  # Create instance: GPIO
  create_hier_cell_GPIO [current_bd_instance .] GPIO

  # Create instance: LIVE_VIDEO_DP
  create_hier_cell_LIVE_VIDEO_DP [current_bd_instance .] LIVE_VIDEO_DP

  # Create instance: ZYNQ
  create_hier_cell_ZYNQ [current_bd_instance .] ZYNQ

########################################

  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {53.330000000000005} \
   CONFIG.CLKOUT1_JITTER {134.774} \
   CONFIG.CLKOUT1_PHASE_ERROR {165.723} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
   CONFIG.CLKOUT2_JITTER {171.561} \
   CONFIG.CLKOUT2_PHASE_ERROR {165.723} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {48} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {141.184} \
   CONFIG.CLKOUT3_PHASE_ERROR {165.723} \
   CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {148.5} \
   CONFIG.CLKOUT3_USED {true} \
   CONFIG.CLK_OUT2_PORT {clk48M} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {32.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {5.333} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {25} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {8} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {3} \
 ] $clk_wiz
 
   # Create interface connections
  connect_bd_intf_net -intf_net LIVE_VIDEO_DP_m_axi_mm_video1 [get_bd_intf_pins LIVE_VIDEO_DP/m_axi_mm_video1] [get_bd_intf_pins ZYNQ/S03_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins CAPTURE_PIPLINE/m_axi_mm_video] [get_bd_intf_pins ZYNQ/S00_AXI]
  connect_bd_intf_net -intf_net ZYNQ_M01_AXI [get_bd_intf_pins CAPTURE_PIPLINE/s_axi_CTRL1] [get_bd_intf_pins ZYNQ/M01_AXI]
  connect_bd_intf_net -intf_net ZYNQ_M05_AXI [get_bd_intf_pins LIVE_VIDEO_DP/S00_AXI] [get_bd_intf_pins ZYNQ/M05_AXI]
  connect_bd_intf_net -intf_net ZYNQ_M06_AXI [get_bd_intf_pins LIVE_VIDEO_DP/s_axi_CTRL1] [get_bd_intf_pins ZYNQ/M06_AXI]
  connect_bd_intf_net -intf_net ZYNQ_M07_AXI [get_bd_intf_pins LIVE_VIDEO_DP/ctrl] [get_bd_intf_pins ZYNQ/M07_AXI]
  connect_bd_intf_net -intf_net ZYNQ_M08_AXI [get_bd_intf_pins LIVE_VIDEO_DP/ctrl1] [get_bd_intf_pins ZYNQ/M08_AXI]
  connect_bd_intf_net -intf_net ZYNQ_M09_AXI [get_bd_intf_pins CAPTURE_PIPLINE/csirxss_s_axi] [get_bd_intf_pins ZYNQ/M09_AXI]
  connect_bd_intf_net -intf_net ZYNQ_M10_AXI [get_bd_intf_pins CAPTURE_PIPLINE/s_axi_ctrl] [get_bd_intf_pins ZYNQ/M10_AXI]
  connect_bd_intf_net -intf_net ZYNQ_M11_AXI [get_bd_intf_pins LIVE_VIDEO_DP/s_axi_CTRL3] [get_bd_intf_pins ZYNQ/M11_AXI]
  connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_ports mipi_phy_if_0] [get_bd_intf_pins CAPTURE_PIPLINE/mipi_phy_if_0]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins GPIO/S_AXI] [get_bd_intf_pins ZYNQ/M03_AXI]

  # Create port connections
  connect_bd_net -net GPIO_SP2 [get_bd_ports ICP3_I2C_ID_SELECT] [get_bd_pins GPIO/ICP3_I2C_ID_SELECT]
  connect_bd_net -net GPIO_SP3 [get_bd_ports SP3] [get_bd_pins GPIO/SP3]
  connect_bd_net -net GPIO_TRG_INPUT [get_bd_ports TRG_INPUT] [get_bd_pins GPIO/TRG_INPUT]
  connect_bd_net -net GPIO_VPSS_RESETn [get_bd_pins CAPTURE_PIPLINE/aux_reset_in_0] [get_bd_pins GPIO/VPSS_RESETn]
  connect_bd_net -net GPIO_frame_buffer_rd_resetn [get_bd_pins GPIO/frame_buffer_rd_resetn] [get_bd_pins LIVE_VIDEO_DP/aux_reset_in]
  connect_bd_net -net GPIO_frame_buffer_wr_resetn [get_bd_pins CAPTURE_PIPLINE/aux_reset_in] [get_bd_pins GPIO/frame_buffer_wr_resetn]
  connect_bd_net -net In0_1 [get_bd_pins LIVE_VIDEO_DP/interrupt1] [get_bd_pins ZYNQ/In0]
  connect_bd_net -net In1_1 [get_bd_pins CAPTURE_PIPLINE/interrupt] [get_bd_pins ZYNQ/In1]
  connect_bd_net -net LIVE_VIDEO_DP_Dout [get_bd_pins LIVE_VIDEO_DP/Dout] [get_bd_pins ZYNQ/dp_live_video_in_pixel1]
  connect_bd_net -net LIVE_VIDEO_DP_alpha [get_bd_pins LIVE_VIDEO_DP/alpha] [get_bd_pins ZYNQ/dp_live_gfx_alpha_in]
  connect_bd_net -net LIVE_VIDEO_DP_interrupt [get_bd_pins LIVE_VIDEO_DP/interrupt] [get_bd_pins ZYNQ/In3]
  connect_bd_net -net ZYNQ_pl_resetn0 [get_bd_pins CAPTURE_PIPLINE/ext_reset_in] [get_bd_pins LIVE_VIDEO_DP/ext_reset_in] [get_bd_pins ZYNQ/pl_resetn0]
  connect_bd_net -net clk_wiz_clk48M [get_bd_ports CLK48M] [get_bd_pins clk_wiz/clk48M]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins CAPTURE_PIPLINE/dphy_clk_200M] [get_bd_pins GPIO/clk200] [get_bd_pins LIVE_VIDEO_DP/clk200] [get_bd_pins ZYNQ/clk200] [get_bd_pins clk_wiz/clk_out1]
  connect_bd_net -net clk_wiz_clk_out3 [get_bd_pins LIVE_VIDEO_DP/clk150] [get_bd_pins ZYNQ/dp_video_in_clk] [get_bd_pins clk_wiz/clk_out3]
  connect_bd_net -net clk_wiz_locked [get_bd_pins CAPTURE_PIPLINE/dcm_locked] [get_bd_pins LIVE_VIDEO_DP/dcm_locked] [get_bd_pins ZYNQ/dcm_locked] [get_bd_pins clk_wiz/locked]
  connect_bd_net -net mipi_csi2_rx_subsyst_0_csirxss_csi_irq [get_bd_pins CAPTURE_PIPLINE/csirxss_csi_irq] [get_bd_pins ZYNQ/In2]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins CAPTURE_PIPLINE/video_aresetn] [get_bd_pins GPIO/s_axi_aresetn] [get_bd_pins LIVE_VIDEO_DP/axi_resetn] [get_bd_pins ZYNQ/S00_ARESETN]
  connect_bd_net -net rst_ps8_0_100M_peripheral_reset [get_bd_pins ZYNQ/peripheral_reset] [get_bd_pins clk_wiz/reset]
  connect_bd_net -net v_axi4s_vid_out_0_vid_active_video [get_bd_pins LIVE_VIDEO_DP/vid_active_video] [get_bd_pins ZYNQ/dp_live_video_in_de]
  connect_bd_net -net v_axi4s_vid_out_0_vid_hsync [get_bd_pins LIVE_VIDEO_DP/vid_hsync] [get_bd_pins ZYNQ/dp_live_video_in_hsync]
  connect_bd_net -net v_axi4s_vid_out_0_vid_vsync [get_bd_pins LIVE_VIDEO_DP/vid_vsync] [get_bd_pins ZYNQ/dp_live_video_in_vsync]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins ZYNQ/pl_clk0] [get_bd_pins clk_wiz/clk_in1]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CAPTURE_PIPLINE/v_frmbuf_wr_0/Data_m_axi_mm_video] [get_bd_addr_segs ZYNQ/zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces LIVE_VIDEO_DP/v_frmbuf_rd_0/Data_m_axi_mm_video] [get_bd_addr_segs ZYNQ/zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
  assign_bd_address -offset 0xA0011000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs LIVE_VIDEO_DP/alpha_control_0/S00_AXI/S00_AXI_reg] -force
  assign_bd_address -offset 0xA0040000 -range 0x00001000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs GPIO/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA0020000 -range 0x00020000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs CAPTURE_PIPLINE/mipi_csi2_rx_subsyst_0/csirxss_s_axi/Reg] -force
  assign_bd_address -offset 0xA00C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs LIVE_VIDEO_DP/v_frmbuf_rd_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs CAPTURE_PIPLINE/v_frmbuf_wr_0/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0xA0070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs LIVE_VIDEO_DP/v_osd_0/ctrl/Reg] -force
  assign_bd_address -offset 0xA0080000 -range 0x00040000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs CAPTURE_PIPLINE/v_proc_ss_0/s_axi_ctrl/Reg] -force
  assign_bd_address -offset 0xA0060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs LIVE_VIDEO_DP/v_tc_0/ctrl/Reg] -force
  assign_bd_address -offset 0xA0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces ZYNQ/zynq_ultra_ps_e_0/Data] [get_bd_addr_segs LIVE_VIDEO_DP/v_tpg_0/s_axi_CTRL/Reg] -force

  regenerate_bd_layout
########################################


   # General Config
   puts ""
   puts "***** General Configuration for Design..."
   
#DWR   set_property target_language VHDL [current_project]
   set_property target_language Verilog [current_project]
   
   # Add the constraints that are needed
   import_files -fileset constrs_1 -norecurse ../../Boards/${board}/${project}.xdc
   
   # Add Project source files
   puts ""
   puts "***** Adding Source Files to Block Design..."
   
   # initially try importaing JUST his wrapper - later change to making and importing our dynamic wrapper
   make_wrapper -files [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd] -top
   #add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.vhd
   add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.v
   
   #add_files -norecurse ../../Boards/${board}/design_1_wrapper.v
   #set obj [get_filesets sources_1]
   #set_property -name "top" -value "design_1_wrapper" -objects $obj
   
#DWR   make_wrapper -files [get_files ${projects_folder}/${board}.srcs/sources_1/bd/${board}/${board}.bd] -top
#DWR   add_files -norecurse ${projects_folder}/${board}.srcs/sources_1/bd/${board}/hdl/${board}_wrapper.vhd
   #add_files -norecurse ${projects_folder}/${project}.srcs/sources_1/bd/${project}/hdl/${project}_wrapper.v
   
   # Add Vitis directives
   puts ""
#TC   puts "***** Adding SDSoC Directves to Design..."
#TC   avnet_add_sdsoc_directives $project $projects_folder $scriptdir
#TC   avnet_add_sdsoc_directives $board $projects_folder $scriptdir
   puts "***** Adding Vitis Directves to Design..."
#DWR   avnet_add_vitis_directives $board $projects_folder $scriptdir
#DWR removed for now, do not use hacked function in boards folder
   avnet_add_vitis_directives $project $projects_folder $scriptdir
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
#DWR need to check on IP folder?  Error seemed to think there was a missing IP folder under cache, so maybe need to copy into that folder?
#    ERROR: [Common 17-53] User Exception: Specified ip cache dir /media/training/BUILD/projects/mipiDesign/ONSEMI_MIPI_AR0144_AR1335/hdl/Projects/ultra96v2_dualcam/ULTRA96V2_2020_1/project_1.cache/ip does not exist. Unable to copy into Shell.

#DWR   write_hw_platform ${projects_folder}/${board}.xsa -include_bit -force
#DWR   validate_hw_platform ${projects_folder}/${board}.xsa -verbose
   write_hw_platform ${projects_folder}/${project}.xsa -include_bit -force
   validate_hw_platform ${projects_folder}/${project}.xsa -verbose
   puts "***** Close the implemented design..."
   close_design
}
