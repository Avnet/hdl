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
#  Please direct any questions to the MicroZed community support forum:
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
#                      Copyright(c) 2021 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Create Date:         Dec 02, 2014
#  Design Name:         MicroZed Base HW Platform
#  Module Name:         mz7020_som_base.tcl
#  Project Name:        MicroZed Base HW
#  Target Devices:      Xilinx Zynq-7020
#  Hardware Boards:     MicroZed SOM
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xc7z020clg400-1 -force
}

proc avnet_import_constraints {boards_folder board project} {

   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/bitstream_compression_enable.xdc
}

proc create_hier_cell_interrupt_concat { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_interrupt_concat() - Empty argument(s)!"}
     return
   }
   
   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
   }
   
   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
   }
   
   # Save current instance; Restore later
   set oldCurInst [current_bd_instance .]
   
   # Set parent object as current
   current_bd_instance $parentObj
   
   # Create cell and set as current instance
   set hier_obj [create_bd_cell -type hier $nameHier]
   current_bd_instance $hier_obj
   
   # Create interface pins
   
   # Create pins
   create_bd_pin -dir O -from 31 -to 0 dout
   
   # Create instance: xlconcat_interrupt_0, and set properties
   set xlconcat_interrupt_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_interrupt_0 ]
   set_property -dict [ list \
      CONFIG.NUM_PORTS {32} \
   ] $xlconcat_interrupt_0
   
   # Create instance: xlconstant_gnd, and set properties
   set xlconstant_gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_gnd ]
   set_property -dict [ list \
      CONFIG.CONST_VAL {0} \
   ] $xlconstant_gnd
   
   # Create port connections
   connect_bd_net -net xlconcat_interrupt_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_interrupt_0/dout]
   connect_bd_net -net xlconstant_gnd_dout [get_bd_pins xlconcat_interrupt_0/In0] \
      [get_bd_pins xlconcat_interrupt_0/In1] \
      [get_bd_pins xlconcat_interrupt_0/In2] \
      [get_bd_pins xlconcat_interrupt_0/In3] \
      [get_bd_pins xlconcat_interrupt_0/In4] \
      [get_bd_pins xlconcat_interrupt_0/In5] \
      [get_bd_pins xlconcat_interrupt_0/In6] \
      [get_bd_pins xlconcat_interrupt_0/In7] \
      [get_bd_pins xlconcat_interrupt_0/In8] \
      [get_bd_pins xlconcat_interrupt_0/In9] \
      [get_bd_pins xlconcat_interrupt_0/In10] \
      [get_bd_pins xlconcat_interrupt_0/In11] \
      [get_bd_pins xlconcat_interrupt_0/In12] \
      [get_bd_pins xlconcat_interrupt_0/In13] \
      [get_bd_pins xlconcat_interrupt_0/In14] \
      [get_bd_pins xlconcat_interrupt_0/In15] \
      [get_bd_pins xlconcat_interrupt_0/In16] \
      [get_bd_pins xlconcat_interrupt_0/In17] \
      [get_bd_pins xlconcat_interrupt_0/In18] \
      [get_bd_pins xlconcat_interrupt_0/In19] \
      [get_bd_pins xlconcat_interrupt_0/In20] \
      [get_bd_pins xlconcat_interrupt_0/In21] \
      [get_bd_pins xlconcat_interrupt_0/In22] \
      [get_bd_pins xlconcat_interrupt_0/In23] \
      [get_bd_pins xlconcat_interrupt_0/In24] \
      [get_bd_pins xlconcat_interrupt_0/In25] \
      [get_bd_pins xlconcat_interrupt_0/In26] \
      [get_bd_pins xlconcat_interrupt_0/In27] \
      [get_bd_pins xlconcat_interrupt_0/In28] \
      [get_bd_pins xlconcat_interrupt_0/In29] \
      [get_bd_pins xlconcat_interrupt_0/In30] \
      [get_bd_pins xlconcat_interrupt_0/In31] \
      [get_bd_pins xlconstant_gnd/dout]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}


proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the MicroZed which is derived from the 
   # board definition file downloadable from the github.com/avnet/bdf git repository.

   # Create instance: xlconcat_0, and set properties
   set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
   set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
   ] [get_bd_cells xlconcat_0]
   
   set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

   # Add constant set to '0'.  We will connect this to the PS SDIO_0 WP input
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
   set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   # Create instance: interrupt_concat
   #create_hier_cell_interrupt_concat [current_bd_instance .] interrupt_concat
   
   # Create instance: proc_sys_reset_100MHz, and set properties
   set proc_sys_reset_100MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_100MHz ]
   
   # Create instance: proc_sys_reset_142MHz, and set properties
   set proc_sys_reset_142MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_142MHz ]
   
   # Create instance: proc_sys_reset_166MHz, and set properties
   set proc_sys_reset_166MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_166MHz ]
   
   # Create instance: proc_sys_reset_200MHz, and set properties
   set proc_sys_reset_200MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_200MHz ]
   
   # Create instance: proc_sys_reset_41MHz, and set properties
   set proc_sys_reset_41MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_41MHz ]
   
   # Create instance: proc_sys_reset_50MHz, and set properties
   set proc_sys_reset_50MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_50MHz ]
   
   # Create instance: clk_wiz_0, and set properties
   set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
   set_property -dict [ list \
      CONFIG.CLKOUT1_JITTER {162.035} \
      CONFIG.CLKOUT1_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
      CONFIG.CLKOUT2_JITTER {150.257} \
      CONFIG.CLKOUT2_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {142} \
      CONFIG.CLKOUT2_USED {true} \
      CONFIG.CLKOUT3_JITTER {146.458} \
      CONFIG.CLKOUT3_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {166} \
      CONFIG.CLKOUT3_USED {true} \
      CONFIG.CLKOUT4_JITTER {142.107} \
      CONFIG.CLKOUT4_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {200} \
      CONFIG.CLKOUT4_USED {true} \
      CONFIG.CLKOUT5_JITTER {192.113} \
      CONFIG.CLKOUT5_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {50} \
      CONFIG.CLKOUT5_USED {true} \
      CONFIG.CLKOUT6_JITTER {202.017} \
      CONFIG.CLKOUT6_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {41} \
      CONFIG.CLKOUT6_USED {true} \
      CONFIG.MMCM_CLKFBOUT_MULT_F {20.000} \
      CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
      CONFIG.MMCM_CLKOUT1_DIVIDE {7} \
      CONFIG.MMCM_CLKOUT2_DIVIDE {6} \
      CONFIG.MMCM_CLKOUT3_DIVIDE {5} \
      CONFIG.MMCM_CLKOUT4_DIVIDE {20} \
      CONFIG.MMCM_CLKOUT5_DIVIDE {24} \
      CONFIG.NUM_OUT_CLKS {6} \
      CONFIG.RESET_TYPE {ACTIVE_LOW} \
   ] $clk_wiz_0

   save_bd_design

   # Create interface connections
   connect_bd_intf_net [get_bd_intf_pins ps7/M_AXI_GP0] [get_bd_intf_pins ps7_axi_periph/S00_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins ps7_axi_periph/M00_AXI] 
      
   # Connect the IP blocks, clocks, resets, etc.
   connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins ps7/SDIO0_WP]

   connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
      [get_bd_pins ps7_axi_periph/S00_ACLK] \
      [get_bd_pins ps7_axi_periph/M00_ACLK] \
      [get_bd_pins ps7/M_AXI_GP0_ACLK] \
      [get_bd_pins ps7_axi_periph/ACLK] \
      [get_bd_pins axi_intc_0/s_axi_aclk]

   connect_bd_net [get_bd_pins ps7/FCLK_CLK0] [get_bd_pins clk_wiz_0/clk_in1]

   connect_bd_net [get_bd_pins proc_sys_reset_100MHz/interconnect_aresetn] [get_bd_pins ps7_axi_periph/ARESETN] 

   connect_bd_net [get_bd_pins proc_sys_reset_100MHz/peripheral_aresetn] \
      [get_bd_pins ps7_axi_periph/S00_ARESETN] \
      [get_bd_pins ps7_axi_periph/M00_ARESETN] \
      [get_bd_pins axi_intc_0/s_axi_aresetn] 

   connect_bd_net [get_bd_pins ps7/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
   connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins xlconcat_0/In0]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   #connect_bd_net [get_bd_pins interrupt_concat/dout] [get_bd_pins axi_intc_0/intr]

   connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_100MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_142MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins proc_sys_reset_166MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins proc_sys_reset_200MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins proc_sys_reset_50MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out6] [get_bd_pins proc_sys_reset_41MHz/slowest_sync_clk]

   connect_bd_net [get_bd_pins clk_wiz_0/locked] \
      [get_bd_pins proc_sys_reset_100MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_142MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_166MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_200MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_50MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_41MHz/dcm_locked]


   connect_bd_net [get_bd_pins ps7/FCLK_RESET0_N] \
      [get_bd_pins proc_sys_reset_41MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_50MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_100MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_200MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_142MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_166MHz/ext_reset_in] \
      [get_bd_pins clk_wiz_0/resetn]

   save_bd_design
}

proc avnet_add_ps {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config \
      {make_external "FIXED_IO, DDR" }  [get_bd_cells ps7]

   save_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   set ps7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7 ]
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config { \
      make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells ps7]

   # Enable the M_AXI_GP0 port on the PS
   set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {1}] [get_bd_cells ps7]

   # Enable the PL-to-PS interrupts on the PS
   set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1}] [get_bd_cells ps7]

   # Bring the SDIO WP pin out to EMIO
   set_property -dict [list CONFIG.PCW_SD0_GRP_WP_ENABLE {1} CONFIG.PCW_SD0_GRP_WP_IO {EMIO}] [get_bd_cells ps7]

   set ps7_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_axi_periph ]
   
   set_property -dict [ list \
      CONFIG.NUM_MI {01} \
   ] [get_bd_cells ps7_axi_periph]

   save_bd_design
}

proc avnet_assign_addresses {project projects_folder scriptdir} {
    # Unassign all address segments
  delete_bd_objs [get_bd_addr_segs]
  delete_bd_objs [get_bd_addr_segs -excluded]

  # Hard-code specific address segments (used in device-tree or applications)
  #assign_bd_address -offset 0xA0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  
  assign_bd_address

}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   set_property PFM_NAME "em.avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

   # define clock and reset ports
   set_property PFM.CLOCK { \
      clk_out1 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_100MHz" status "fixed"} \
      clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_142MHz" status "fixed"} \
      clk_out3 {id "2" is_default "false" proc_sys_reset "proc_sys_reset_166MHz" status "fixed"} \
      clk_out4 {id "3" is_default "false" proc_sys_reset "proc_sys_reset_200MHz" status "fixed"} \
      clk_out5 {id "4" is_default "false" proc_sys_reset "proc_sys_reset_50MHz" status "fixed"} \
      clk_out6 {id "5" is_default "false" proc_sys_reset "proc_sys_reset_41MHz" status "fixed"} \
   } [get_bd_cells /clk_wiz_0]

   set_property PFM.AXI_PORT { \
      M_AXI_GP1 {memport "M_AXI_GP" sptag "GP" memory ""} \
      S_AXI_HP1 {memport "S_AXI_HP" sptag "HP1" memory "ps7 HP1_DDR_LOWOCM"} \
      S_AXI_HP2 {memport "S_AXI_HP" sptag "HP2" memory "ps7 HP2_DDR_LOWOCM"} \
      S_AXI_HP3 {memport "S_AXI_HP" sptag "HP3" memory "ps7 HP3_DDR_LOWOCM"} \
   } [get_bd_cells /ps7]
   
   
   # The following creates the equivalent of
   # set_property PFM.AXI_PORT { M01_AXI {memport "M_AXI_GP" }} [get_bd_cells /ps7_axi_periph]
   # for all the interfaces M01_AXI to M31_AXI
   set parVal []
   for {set i 1} {$i < 32} {incr i} {
      lappend parVal M[format %02d $i]_AXI \
   {memport "M_AXI_GP"}
   }
   set_property PFM.AXI_PORT $parVal [get_bd_cells /ps7_axi_periph]

   #set_property PFM.AXI_PORT {M05_AXI {memport "M_AXI_GP" sptag "" memory ""} M06_AXI {memport "M_AXI_GP" sptag "" memory ""} M07_AXI {memport "M_AXI_GP" sptag "" memory ""} M08_AXI {memport "M_AXI_GP" sptag "" memory ""} M09_AXI {memport "M_AXI_GP" sptag "" memory ""} M10_AXI {memport "M_AXI_GP" sptag "" memory ""} M11_AXI {memport "M_AXI_GP" sptag "" memory ""} M12_AXI {memport "M_AXI_GP" sptag "" memory ""} M13_AXI {memport "M_AXI_GP" sptag "" memory ""} M14_AXI {memport "M_AXI_GP" sptag "" memory ""} M15_AXI {memport "M_AXI_GP" sptag "" memory ""} M16_AXI {memport "M_AXI_GP" sptag "" memory ""} M17_AXI {memport "M_AXI_GP" sptag "" memory ""} M18_AXI {memport "M_AXI_GP" sptag "" memory ""} M19_AXI {memport "M_AXI_GP" sptag "" memory ""} M20_AXI {memport "M_AXI_GP" sptag "" memory ""} M21_AXI {memport "M_AXI_GP" sptag "" memory ""} M22_AXI {memport "M_AXI_GP" sptag "" memory ""} M23_AXI {memport "M_AXI_GP" sptag "" memory ""} M24_AXI {memport "M_AXI_GP" sptag "" memory ""} M25_AXI {memport "M_AXI_GP" sptag "" memory ""} M26_AXI {memport "M_AXI_GP" sptag "" memory ""} M27_AXI {memport "M_AXI_GP" sptag "" memory ""} M28_AXI {memport "M_AXI_GP" sptag "" memory ""} M29_AXI {memport "M_AXI_GP" sptag "" memory ""} M30_AXI {memport "M_AXI_GP" sptag "" memory ""} M31_AXI {memport "M_AXI_GP" sptag "" memory ""}} [get_bd_cells /ps7_axi_periph]
 
   # required for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   # define interrupt ports
   set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]

   # Set platform project properties
   set_property platform.description                   "Base MiniZed development platform" [current_project]
   set_property platform.uses_pr                       false         [current_project]

   set_property platform.design_intent.server_managed  "false" [current_project]
   set_property platform.design_intent.external_host   "false" [current_project]
   set_property platform.design_intent.embedded        "true" [current_project]
   set_property platform.design_intent.datacenter      "false" [current_proj]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   #set_property platform.post_sys_link_tcl_hook        ./scripts/dynamic_postlink.tcl [current_project]
   #set_property platform.post_sys_link_tcl_hook        ${projects_folder}/../../../boards/mz7020_som/mz7020_som_dynamic_postlink.tcl [current_project]
   #set_property platform.post_sys_link_overlay_tcl_hook        ${projects_folder}/../../../boards/mz7020_som/mz7020_som_dynamic_postlink.tcl [current_project]

   set_property platform.vendor                        "em.avnet.com" [current_project]
   set_property platform.board_id                      ${project} [current_project]
   set_property platform.name                          ${design_name} [current_project]
   set_property platform.version                       "1.0" [current_project]
   set_property platform.platform_state                "pre_synth" [current_project]
   set_property platform.ip_cache_dir                  [get_property ip_output_repo [current_project]] [current_project]

   # recommnded to use "sd_card" for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis_Embedded_Platform_Source/blob/2020.1/Xilinx_Official_Platforms/zcu104_base/vivado/xilinx_zcu104_base_202010_1_xsa.tcl
   #set_property platform.default_output_type           "xclbin" [current_project]
   set_property platform.default_output_type           "sd_card" [current_project]

   set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
   set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
   set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
}

