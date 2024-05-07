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
#  Please direct any questions to the ZUBoard community support forum:
#     http://avnet.me/zuboard-1cg-forum
#
#  Product information is available at:
#     http://avnet.me/zuboard-1cg
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
#  Create Date:         Apr 11, 2022
#  Design Name:         ZUBoard-1CG Dualcam HSIO HW Platform
#  Module Name:         zub1cg_sbc_dualcam.tcl
#  Project Name:        ZUBoard-1CG Dualcam
#  Target Devices:      Xilinx Zynq UltraScale+ 1CG
#  Hardware Boards:     ZUBoard-1CG Board
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu1cg-sbva484-1-e -force
}

proc avnet_import_constraints {boards_folder board project} {

   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
   set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_100M
   #
   # System Management Wizard 
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0
   set_property -dict [ list \
      CONFIG.CHANNEL_ENABLE_VP_VN {false} \
      CONFIG.ENABLE_VCCPSAUX_ALARM {false} \
      CONFIG.ENABLE_VCCPSINTFP_ALARM {false} \
      CONFIG.ENABLE_VCCPSINTLP_ALARM {false} \
      CONFIG.OT_ALARM {false} \
      CONFIG.USER_TEMP_ALARM {false} \
      CONFIG.VCCAUX_ALARM {false} \
      CONFIG.VCCINT_ALARM {false} ] [get_bd_cells system_management_wiz_0]

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/system_management_wiz_0/S_AXI_LITE} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}}  [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE]

   save_bd_design
   
   #
   # HSIO I2C
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0
   make_bd_intf_pins_external  [get_bd_intf_pins axi_iic_0/IIC]
   set_property name hsio_i2c [get_bd_intf_ports IIC_0]

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_iic_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}}  [get_bd_intf_pins axi_iic_0/S_AXI]

   save_bd_design

   #
   # Add the Concat block for the interrupts
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]

   save_bd_design

   #
   # VITIS ADDITIONS - START
   #

   # Enable M_AXI_HPM1_FPD
   set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {1}] [get_bd_cells zynq_ultra_ps_e_0]

   # enable S_AXI_HP0_FPD High-Performance port
   set_property -dict [list CONFIG.PSU__USE__S_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]

   #
   # Vitis interrupt
   #
   # Add AXI interrupt controller (for VITIS XRT interrupt support)
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0

   # Set IRQ type to 'EDGE' and connection to 'SINGLE'
   set_property -dict [ list \
      CONFIG.C_IRQ_IS_LEVEL {0} \
      CONFIG.C_IRQ_CONNECTION {1}] [get_bd_cells axi_intc_0]
   #

   #
   # System peripherals interrupts
   #
   set_property -dict [list CONFIG.NUM_PORTS {7}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/In6] [get_bd_pins axi_intc_0/irq]

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_intc_0/s_axi} \
      ddr_seg {Auto} intc_ip {/axi_interconnect_0} \
      master_apm {0}}  [get_bd_intf_pins axi_intc_0/s_axi]
   
   save_bd_design

   # Create clock wizard (with same clock frequencies as in zcu102_base/zcu104_base VITIS platforms)
   #   [0] 150 MHz
   #   [1] 300 MHz
   #   [2]  75 MHz
   #   [3] 100 MHz
   #   [4] 200 MHz
   #   [5] 400 MHz
   #   [6] 600 MHz
   create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
   set_property -dict [ list \
      CONFIG.CLKOUT1_JITTER {107.567} \
      CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150} \
      CONFIG.CLKOUT2_JITTER {94.862} \
      CONFIG.CLKOUT2_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300} \
      CONFIG.CLKOUT2_USED {true} \
      CONFIG.CLKOUT3_JITTER {133.812} \
      CONFIG.CLKOUT3_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {48} \
      CONFIG.CLKOUT3_USED {true} \
      CONFIG.CLKOUT4_JITTER {115.831} \
      CONFIG.CLKOUT4_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} \
      CONFIG.CLKOUT4_USED {true} \
      CONFIG.CLKOUT5_JITTER {102.086} \
      CONFIG.CLKOUT5_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {200.000} \
      CONFIG.CLKOUT5_USED {true} \
      CONFIG.CLKOUT6_JITTER {90.074} \
      CONFIG.CLKOUT6_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {400.000} \
      CONFIG.CLKOUT6_USED {true} \
      CONFIG.CLKOUT7_JITTER {83.768} \
      CONFIG.CLKOUT7_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT7_REQUESTED_OUT_FREQ {600.000} \
      CONFIG.CLKOUT7_USED {true} \
      CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
      CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
      CONFIG.MMCM_CLKOUT2_DIVIDE {25} \
      CONFIG.MMCM_CLKOUT3_DIVIDE {12} \
      CONFIG.MMCM_CLKOUT4_DIVIDE {6} \
      CONFIG.MMCM_CLKOUT5_DIVIDE {3} \
      CONFIG.MMCM_CLKOUT6_DIVIDE {2} \
      CONFIG.NUM_OUT_CLKS {7} \
      CONFIG.RESET_PORT {resetn} \
      CONFIG.RESET_TYPE {ACTIVE_LOW}] [get_bd_cells clk_wiz_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_4
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_5
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_6

   save_bd_design

   connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins clk_wiz_0/clk_in1] 
   connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In5]
   save_bd_design

   connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins proc_sys_reset_4/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out6] [get_bd_pins proc_sys_reset_5/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out7] [get_bd_pins proc_sys_reset_6/slowest_sync_clk]
   save_bd_design

   connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
   connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
   connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_2/dcm_locked]
   connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_3/dcm_locked]
   connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_4/dcm_locked]
   connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_5/dcm_locked]
   connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_6/dcm_locked]
   save_bd_design

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins clk_wiz_0/resetn]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_1/ext_reset_in]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_2/ext_reset_in]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_3/ext_reset_in]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_4/ext_reset_in]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_5/ext_reset_in]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_6/ext_reset_in]
   save_bd_design

   regenerate_bd_layout
   save_bd_design

   #
   # VITIS ADDITIONS - END
   #  
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]
   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]

   set_property -dict [list \
      CONFIG.PSU__USE__M_AXI_GP0 {1} \
      CONFIG.PSU__USE__M_AXI_GP2 {0} \
      CONFIG.PSU__USE__IRQ0 {1} \
      CONFIG.PSU__USE__IRQ1 {0}] [get_bd_cells zynq_ultra_ps_e_0]

   # Enable the PS SPI1 (HSIO MCU) and I2C0 (AP1302 ISP on DualCam HSIO)
   set_property -dict [list \
      CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__I2C0__PERIPHERAL__IO {EMIO} \
      CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__SPI1__PERIPHERAL__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]

   # Set PMU GPO2 (connected to on/off controller KILL_N signal) initial state to '1'
   set_property -dict [list CONFIG.PSU__PMU__GPO2__POLARITY {high}] [get_bd_cells zynq_ultra_ps_e_0]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]

   # Enable DisplayPort using PS GTR0 and GTR1
   set_property -dict [list \
      CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
      CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
      CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]

   # Set the DisplayPort reference clock to 135 MHz
   set_property -dict [list \
      CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk0} \
      CONFIG.PSU__DP__REF_CLK_FREQ {135}] [get_bd_cells zynq_ultra_ps_e_0]

   # Enable the SD0 and set it to eMMC 8-bit mode
   set_property -dict [list \
      CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__SD0__PERIPHERAL__IO {MIO 13 .. 22} \
      CONFIG.PSU__SD0__SLOT_TYPE {eMMC} \
      CONFIG.PSU__SD0__DATA_TRANSFER_MODE {8Bit}] [get_bd_cells zynq_ultra_ps_e_0]

   save_bd_design
}

proc avnet_assign_addresses {project projects_folder scriptdir} {
   # Unassign all address segments
   delete_bd_objs [get_bd_addr_segs]
   delete_bd_objs [get_bd_addr_segs -excluded]

   # Hard-code specific address segments (used in device-tree or applications)
   #assign_bd_address -offset 0xA0090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force

   assign_bd_address -target_address_space /CAPTURE_PIPELINE/v_frmbuf_wr_0/Data_m_axi_mm_video [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] -force
   #Slave segment '/zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW' is being assigned into address space '/CAPTURE_PIPELINE/v_frmbuf_wr_0/Data_m_axi_mm_video' at <0x0000_0000 [ 2G ]>.
   assign_bd_address -target_address_space /CAPTURE_PIPELINE/v_frmbuf_wr_0/Data_m_axi_mm_video [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] -force
   #Slave segment '/zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM' is being assigned into address space '/CAPTURE_PIPELINE/v_frmbuf_wr_0/Data_m_axi_mm_video' at <0xFF00_0000 [ 16M ]>.
  
   assign_bd_address

}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}

   set_property PFM_NAME "avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

   # define clock and reset ports
   set_property PFM.CLOCK { \
   clk_out1 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_0" status "fixed"} \
   clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_1" status "fixed"} \
   clk_out3 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_2" status "fixed"} \
   clk_out4 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_3" status "fixed"} \
   clk_out5 {id "4" is_default "false" proc_sys_reset "/proc_sys_reset_4" status "fixed"} \
   clk_out6 {id "5" is_default "false" proc_sys_reset "/proc_sys_reset_5" status "fixed"} \
   clk_out7 {id "6" is_default "false" proc_sys_reset "/proc_sys_reset_6" status "fixed"} \
   } [get_bd_cells /clk_wiz_0]

   # define AXI ports
   set_property PFM.AXI_PORT { \
   M_AXI_HPM0_LPD {memport "M_AXI_GP" sptag "HPM0_LPD"} \
   S_AXI_HPC0_FPD {memport "S_AXI_HP" sptag "HPC0" memory "zynq_ultra_ps_e_0 HPC0_DDR_LOW"} \
   S_AXI_HPC1_FPD {memport "S_AXI_HP" sptag "HPC1" memory "zynq_ultra_ps_e_0 HPC1_DDR_LOW"} \
   S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "zynq_ultra_ps_e_0 HP1_DDR_LOW"} \
   S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "zynq_ultra_ps_e_0 HP2_DDR_LOW"} \
   S_AXI_HP3_FPD {memport "S_AXI_HP" sptag "HP3" memory "zynq_ultra_ps_e_0 HP3_DDR_LOW"} \
   } [get_bd_cells /zynq_ultra_ps_e_0]

  set_property PFM.AXI_PORT { \
       M04_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M05_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M06_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M07_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M08_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M09_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M10_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M11_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M12_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M13_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M14_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M15_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
       M16_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
   } [get_bd_cells /axi_interconnect_0]
   
   # required for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   # define interrupt ports
   set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]

   # Set platform project properties
   set_property platform.description                   "ZUBoard-1CG Dual Camera HW Platform" [current_project]
   set_property platform.uses_pr                       false         [current_project]

   set_property platform.design_intent.server_managed  "false" [current_project]
   set_property platform.design_intent.external_host   "false" [current_project]
   set_property platform.design_intent.embedded        "true" [current_project]
   set_property platform.design_intent.datacenter      "false" [current_proj]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   #set_property platform.post_sys_link_tcl_hook        ${projects_folder}/../../../boards/ultra96v2/ultra96v2_oob_dynamic_postlink.tcl [current_project]

   set_property platform.vendor                        "avnet.com" [current_project]
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

# Hierarchical cell: GPIO
proc create_hier_cell_GPIO { parentCell nameHier } {

   variable script_folder

   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_GPIO() - Empty argument(s)!"}
      return
   }

   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
      return
   }

   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

   # Create pins
   create_bd_pin -dir O -from 0 -to 0 icp3_i2c_id_select
   create_bd_pin -dir O -from 0 -to 0 sp3
   create_bd_pin -dir O -from 0 -to 0 trigger
   create_bd_pin -dir O -from 0 -to 0 vpss_csc_resetn
   create_bd_pin -dir O -from 0 -to 0 vpss_scaler_resetn
   create_bd_pin -dir O -from 0 -to 0 rst
   create_bd_pin -dir O -from 0 -to 0 stby

   create_bd_pin -dir I -type clk clk100
   create_bd_pin -dir O -from 0 -to 0 frame_buffer_rd_resetn
   create_bd_pin -dir O -from 0 -to 0 frame_buffer_wr_resetn
   create_bd_pin -dir I -type rst s_axi_aresetn

   # Create instance: axi_gpio_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   set_property -dict [ list \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_GPIO_WIDTH {8}] [get_bd_cells axi_gpio_0]

   # Create instance: xlslice_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
   set_property -dict [ list \
      CONFIG.DIN_FROM {0} \
      CONFIG.DIN_TO {0} \
      CONFIG.DIN_WIDTH {8}] [get_bd_cells xlslice_0]

   # Create instance: xlslice_1, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1
   set_property -dict [ list \
      CONFIG.DIN_FROM {1} \
      CONFIG.DIN_TO {1} \
      CONFIG.DIN_WIDTH {8} \
      CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_1]

   # Create instance: xlslice_2, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2
   set_property -dict [ list \
      CONFIG.DIN_FROM {2} \
      CONFIG.DIN_TO {2} \
      CONFIG.DIN_WIDTH {8} \
      CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_2]

   # Create instance: xlslice_3, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3
   set_property -dict [ list \
      CONFIG.DIN_FROM {3} \
      CONFIG.DIN_TO {3} \
      CONFIG.DIN_WIDTH {8} \
      CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_3]

   # Create instance: xlslice_4, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4
   set_property -dict [ list \
      CONFIG.DIN_FROM {4} \
      CONFIG.DIN_TO {4} \
      CONFIG.DIN_WIDTH {8} \
      CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_4]

   # Create instance: xlslice_5, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5
   set_property -dict [ list \
      CONFIG.DIN_FROM {5} \
      CONFIG.DIN_TO {5} \
      CONFIG.DIN_WIDTH {8} \
      CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_5]

   # Create instance: xlslice_6, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6
   set_property -dict [ list \
      CONFIG.DIN_FROM {6} \
      CONFIG.DIN_TO {6} \
      CONFIG.DIN_WIDTH {8} \
      CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_6]

   # Create instance: xlslice_7, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7
   set_property -dict [ list \
      CONFIG.DIN_FROM {7} \
      CONFIG.DIN_TO {7} \
      CONFIG.DIN_WIDTH {8} \
      CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_7]



   # Create interface connections
   connect_bd_intf_net [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]

   # Create port connections
   connect_bd_net [get_bd_pins clk100] [get_bd_pins axi_gpio_0/s_axi_aclk]
   connect_bd_net [get_bd_pins s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_0/Din]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_1/Din]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_2/Din]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_3/Din]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_4/Din]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_5/Din]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_6/Din]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins xlslice_7/Din]
   connect_bd_net [get_bd_pins xlslice_0/Dout] [get_bd_pins trigger]
   connect_bd_net [get_bd_pins xlslice_1/Dout] [get_bd_pins icp3_i2c_id_select]
   connect_bd_net [get_bd_pins xlslice_2/Dout] [get_bd_pins sp3]
   connect_bd_net [get_bd_pins xlslice_3/Dout] [get_bd_pins frame_buffer_wr_resetn]
   connect_bd_net [get_bd_pins xlslice_4/Dout] [get_bd_pins frame_buffer_rd_resetn]
   connect_bd_net [get_bd_pins xlslice_4/Dout] [get_bd_pins vpss_csc_resetn]
   connect_bd_net [get_bd_pins xlslice_5/Dout] [get_bd_pins vpss_scaler_resetn]
   connect_bd_net [get_bd_pins xlslice_6/Dout] [get_bd_pins rst]
   connect_bd_net [get_bd_pins xlslice_7/Dout] [get_bd_pins stby]

   # Perform GUI Layout
   regenerate_bd_layout -hierarchy [get_bd_cells /GPIO]

   save_bd_design

   # Restore current instance
   current_bd_instance $oldCurInst
}

# Hierarchical cell: CAPTURE_PIPELINE
proc create_hier_cell_CAPTURE_PIPELINE { parentCell nameHier } {

   variable script_folder

   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_CAPTURE_PIPELINE() - Empty argument(s)!"}
      return
   }

   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
      return
   }

   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csirxss_s_axi
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl

   # Create pins
   create_bd_pin -dir O -type intr csirxss_csi_irq
   create_bd_pin -dir I dcm_locked
   create_bd_pin -dir I -type clk dphy_clk_200M
   create_bd_pin -dir I -type rst ext_reset_in
   create_bd_pin -dir I -type rst frmbuf_resetn
   create_bd_pin -dir O -type intr interrupt
   create_bd_pin -dir I -type rst video_aresetn
   create_bd_pin -dir I -type rst vpss_csc_resetn
   create_bd_pin -dir I -type rst vpss_scaler_resetn

   # Create instance: axis_subset_converter_1, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1
   set_property -dict [ list \
      CONFIG.M_HAS_TKEEP {0} \
      CONFIG.M_HAS_TLAST {1} \
      CONFIG.M_HAS_TREADY {1} \
      CONFIG.M_HAS_TSTRB {0} \
      CONFIG.M_TDATA_NUM_BYTES {6} \
      CONFIG.M_TDEST_WIDTH {0} \
      CONFIG.M_TID_WIDTH {0} \
      CONFIG.M_TUSER_WIDTH {1} \
      CONFIG.S_HAS_TKEEP {0} \
      CONFIG.S_HAS_TLAST {1} \
      CONFIG.S_HAS_TREADY {1} \
      CONFIG.S_HAS_TSTRB {0} \
      CONFIG.S_TDATA_NUM_BYTES {4} \
      CONFIG.S_TDEST_WIDTH {0} \
      CONFIG.S_TID_WIDTH {0} \
      CONFIG.S_TUSER_WIDTH {1} \
      CONFIG.TDATA_REMAP {16'b00000000,tdata[31:0]} \
      CONFIG.TDEST_REMAP {1'b0} \
      CONFIG.TKEEP_REMAP {1'b0} \
      CONFIG.TLAST_REMAP {tlast[0]} \
      CONFIG.TSTRB_REMAP {1'b0} \
      CONFIG.TUSER_REMAP {tuser[0:0]}] [get_bd_cells axis_subset_converter_1]

   # Create instance: mipi_csi2_rx_subsyst_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.4 mipi_csi2_rx_subsyst_0
   set_property -dict [ list \
      CONFIG.AXIS_TDEST_WIDTH {4} \
      CONFIG.CLK_LANE_IO_LOC {N2} \
      CONFIG.CLK_LANE_IO_LOC_NAME {IO_L7P_T1L_N0_QBC_AD13P_65} \
      CONFIG.CMN_INC_IIC {false} \
      CONFIG.CMN_INC_VFB {true} \
      CONFIG.CMN_NUM_LANES {4} \
      CONFIG.CMN_NUM_PIXELS {2} \
      CONFIG.CMN_PXL_FORMAT {YUV422_8bit} \
      CONFIG.CSI_BUF_DEPTH {8192} \
      CONFIG.CSI_EMB_NON_IMG {false} \
      CONFIG.C_CLK_LANE_IO_POSITION {13} \
      CONFIG.C_CSI_EN_ACTIVELANES {true} \
      CONFIG.C_CSI_EN_CRC {true} \
      CONFIG.C_CSI_FILTER_USERDATATYPE {false} \
      CONFIG.C_DATA_LANE0_IO_POSITION {15} \
      CONFIG.C_DATA_LANE1_IO_POSITION {17} \
      CONFIG.C_DATA_LANE2_IO_POSITION {19} \
      CONFIG.C_DATA_LANE3_IO_POSITION {21} \
      CONFIG.C_DPHY_LANES {4} \
      CONFIG.C_EN_BG0_PIN0 {false} \
      CONFIG.C_EN_CSI_V2_0 {false} \
      CONFIG.C_EN_TIMEOUT_REGS {true} \
      CONFIG.C_EN_VCX {false} \
      CONFIG.C_HS_LINE_RATE {896} \
      CONFIG.C_HS_SETTLE_NS {146} \
      CONFIG.C_STRETCH_LINE_RATE {2500} \
      CONFIG.DATA_LANE0_IO_LOC {N5} \
      CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L8P_T1L_N2_AD5P_65} \
      CONFIG.DATA_LANE1_IO_LOC {M2} \
      CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L9P_T1L_N4_AD12P_65} \
      CONFIG.DATA_LANE2_IO_LOC {M5} \
      CONFIG.DATA_LANE2_IO_LOC_NAME {IO_L10P_T1U_N6_QBC_AD4P_65} \
      CONFIG.DATA_LANE3_IO_LOC {L2} \
      CONFIG.DATA_LANE3_IO_LOC_NAME {IO_L11P_T1U_N8_GC_65} \
      CONFIG.DPY_EN_REG_IF {true} \
      CONFIG.DPY_LINE_RATE {896} \
      CONFIG.SupportLevel {1}] [get_bd_cells mipi_csi2_rx_subsyst_0]

   # Create instance: proc_sys_reset_1, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1

   # Create instance: proc_sys_reset_2, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2

   # Create instance: proc_sys_reset_3, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3

   # Create instance: v_frmbuf_wr_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.5 v_frmbuf_wr_0
   set_property -dict [ list \
      CONFIG.AXIMM_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {128} \
      CONFIG.HAS_BGR8 {1} \
      CONFIG.HAS_BGRX8 {0} \
      CONFIG.HAS_INTERLACED {0} \
      CONFIG.HAS_RGB8 {0} \
      CONFIG.HAS_RGBX8 {0} \
      CONFIG.HAS_UYVY8 {1} \
      CONFIG.HAS_Y8 {1} \
      CONFIG.HAS_YUV8 {0} \
      CONFIG.HAS_YUVX8 {0} \
      CONFIG.HAS_YUYV8 {1} \
      CONFIG.HAS_Y_UV8 {0} \
      CONFIG.HAS_Y_UV8_420 {0} \
      CONFIG.MAX_NR_PLANES {1} \
      CONFIG.SAMPLES_PER_CLOCK {2}] [get_bd_cells v_frmbuf_wr_0]

   # Create instance: v_proc_ss_csc_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_csc_0
   set_property -dict [ list \
      CONFIG.C_COLORSPACE_SUPPORT {1} \
      CONFIG.C_ENABLE_CSC {false} \
      CONFIG.C_ENABLE_DMA {false} \
      CONFIG.C_ENABLE_INTERLACED {false} \
      CONFIG.C_H_SCALER_TAPS {8} \
      CONFIG.C_MAX_DATA_WIDTH {8} \
      CONFIG.C_SAMPLES_PER_CLK {2} \
      CONFIG.C_SCALER_ALGORITHM {2} \
      CONFIG.C_TOPOLOGY {3} \
      CONFIG.C_V_SCALER_TAPS {8}] [get_bd_cells v_proc_ss_csc_0]

   # Create instance: v_proc_ss_scaler_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_scaler_0
   set_property -dict [ list \
      CONFIG.C_COLORSPACE_SUPPORT {1} \
      CONFIG.C_ENABLE_CSC {true} \
      CONFIG.C_ENABLE_DMA {false} \
      CONFIG.C_ENABLE_INTERLACED {false} \
      CONFIG.C_H_SCALER_TAPS {8} \
      CONFIG.C_MAX_DATA_WIDTH {8} \
      CONFIG.C_SAMPLES_PER_CLK {2} \
      CONFIG.C_SCALER_ALGORITHM {2} \
      CONFIG.C_TOPOLOGY {0} \
      CONFIG.C_V_SCALER_TAPS {8}] [get_bd_cells v_proc_ss_scaler_0]

   save_bd_design

   # Create interface connections
   connect_bd_intf_net [get_bd_intf_pins csc_ctrl] [get_bd_intf_pins v_proc_ss_csc_0/s_axi_ctrl]
   connect_bd_intf_net [get_bd_intf_pins m_axi_mm_video] [get_bd_intf_pins v_frmbuf_wr_0/m_axi_mm_video]
   connect_bd_intf_net [get_bd_intf_pins frmbuf_ctrl] [get_bd_intf_pins v_frmbuf_wr_0/s_axi_CTRL]
   connect_bd_intf_net [get_bd_intf_pins csirxss_s_axi] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/csirxss_s_axi]
   connect_bd_intf_net [get_bd_intf_pins scaler_ctrl] [get_bd_intf_pins v_proc_ss_scaler_0/s_axi_ctrl]
   connect_bd_intf_net [get_bd_intf_pins axis_subset_converter_1/M_AXIS] [get_bd_intf_pins v_proc_ss_csc_0/s_axis]
   connect_bd_intf_net [get_bd_intf_pins axis_subset_converter_1/S_AXIS] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/video_out]
   connect_bd_intf_net [get_bd_intf_pins mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_rx_subsyst_0/mipi_phy_if]
   connect_bd_intf_net [get_bd_intf_pins v_frmbuf_wr_0/s_axis_video] [get_bd_intf_pins v_proc_ss_scaler_0/m_axis]
   connect_bd_intf_net [get_bd_intf_pins v_proc_ss_csc_0/m_axis] [get_bd_intf_pins v_proc_ss_scaler_0/s_axis]

   # Create port connections
   connect_bd_net [get_bd_pins axis_subset_converter_1/aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins v_frmbuf_wr_0/ap_rst_n]
   connect_bd_net [get_bd_pins interrupt] [get_bd_pins v_frmbuf_wr_0/interrupt]
   connect_bd_net [get_bd_pins frmbuf_resetn] [get_bd_pins proc_sys_reset_1/aux_reset_in]
   connect_bd_net [get_bd_pins dphy_clk_200M] [get_bd_pins axis_subset_converter_1/aclk] [get_bd_pins mipi_csi2_rx_subsyst_0/dphy_clk_200M] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aclk] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aclk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins proc_sys_reset_2/slowest_sync_clk] [get_bd_pins proc_sys_reset_3/slowest_sync_clk] [get_bd_pins v_frmbuf_wr_0/ap_clk] [get_bd_pins v_proc_ss_csc_0/aclk] [get_bd_pins v_proc_ss_scaler_0/aclk_axis] [get_bd_pins v_proc_ss_scaler_0/aclk_ctrl]
   connect_bd_net [get_bd_pins dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked] [get_bd_pins proc_sys_reset_2/dcm_locked] [get_bd_pins proc_sys_reset_3/dcm_locked]
   connect_bd_net [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins proc_sys_reset_2/ext_reset_in] [get_bd_pins proc_sys_reset_3/ext_reset_in]
   connect_bd_net [get_bd_pins csirxss_csi_irq] [get_bd_pins mipi_csi2_rx_subsyst_0/csirxss_csi_irq]

   connect_bd_net [get_bd_pins proc_sys_reset_2/peripheral_aresetn] [get_bd_pins v_proc_ss_scaler_0/aresetn_ctrl]
   connect_bd_net [get_bd_pins proc_sys_reset_3/peripheral_aresetn] [get_bd_pins v_proc_ss_csc_0/aresetn]
   connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins mipi_csi2_rx_subsyst_0/lite_aresetn] [get_bd_pins mipi_csi2_rx_subsyst_0/video_aresetn]
   connect_bd_net [get_bd_pins vpss_csc_resetn] [get_bd_pins proc_sys_reset_3/aux_reset_in]
   connect_bd_net [get_bd_pins vpss_scaler_resetn] [get_bd_pins proc_sys_reset_2/aux_reset_in]

   # Perform GUI Layout
   regenerate_bd_layout -hierarchy [get_bd_cells /CAPTURE_PIPELINE]

   save_bd_design

   # Restore current instance
   current_bd_instance $oldCurInst
}

# Hierarchical cell: DISPLAY_PIPELINE
proc create_hier_cell_DISPLAY_PIPELINE { parentCell nameHier } {

   variable script_folder

   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_DISPLAY_PIPELINE() - Empty argument(s)!"}
      return
   }

   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
      return
   }

   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 dsi_mipi_phy_if
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 v_frmbuf_rd_s_axi_CTRL
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 dsi_tx_s_axi

   # Create pins
   create_bd_pin -dir I -type clk dphy_clk_200M
   create_bd_pin -dir I -type rst aux_reset_in
   create_bd_pin -dir I -type rst ext_reset_in
   create_bd_pin -dir I -type rst video_aresetn
   create_bd_pin -dir I dcm_locked
   create_bd_pin -dir O -type intr frame_buf_rd_int
   create_bd_pin -dir O -type intr dsi_tx_int

   # Create instance: proc_sys_reset, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0

   # Create instance: v_frmbuf_rd_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_rd:2.3 v_frmbuf_rd_0
   set_property -dict [list \
      CONFIG.HAS_RGB8 {0} \
      CONFIG.HAS_RGBX8 {0} \
      CONFIG.HAS_YUYV8 {1} \
      CONFIG.HAS_UYVY8 {1}] [get_bd_cells v_frmbuf_rd_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_dsi_tx_subsystem:2.2 mipi_dsi_tx_subsystem_0
   set_property -dict [list \
      CONFIG.DSI_LANES {2} \
      CONFIG.C_DPHY_LANES {2} \
      CONFIG.DPHY_EN_REG_IF {false} \
      CONFIG.AXIS_TDATA_WIDTH {48} \
      CONFIG.DSI_PIXELS {2} \
      CONFIG.CLK_LANE_IO_LOC {J5} \
      CONFIG.DATA_LANE0_IO_LOC {G1} \
      CONFIG.DATA_LANE1_IO_LOC {E4} \
      CONFIG.CLK_LANE_IO_LOC_NAME {IO_L16P_T2U_N6_QBC_AD3P_65} \
      CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L19P_T3L_N0_DBC_AD9P_65} \
      CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L20P_T3L_N2_AD1P_65} \
      CONFIG.SupportLevel {1} \
      CONFIG.C_CLK_LANE_IO_POSITION {32} \
      CONFIG.C_DATA_LANE0_IO_POSITION {39} \
      CONFIG.C_DATA_LANE1_IO_POSITION {41}] [get_bd_cells mipi_dsi_tx_subsystem_0]

   # Create interface connections
   connect_bd_intf_net [get_bd_intf_pins v_frmbuf_rd_s_axi_CTRL] [get_bd_intf_pins v_frmbuf_rd_0/s_axi_CTRL]
   connect_bd_intf_net [get_bd_intf_pins dsi_tx_s_axi] [get_bd_intf_pins mipi_dsi_tx_subsystem_0/s_axi]
   connect_bd_intf_net [get_bd_intf_pins m_axi_mm_video] [get_bd_intf_pins v_frmbuf_rd_0/m_axi_mm_video]
   connect_bd_intf_net [get_bd_intf_pins dsi_mipi_phy_if] [get_bd_intf_pins mipi_dsi_tx_subsystem_0/mipi_phy_if]
   connect_bd_intf_net [get_bd_intf_pins v_frmbuf_rd_0/m_axis_video] [get_bd_intf_pins mipi_dsi_tx_subsystem_0/s_axis]

   # Create port connections
   connect_bd_net [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
   connect_bd_net [get_bd_pins aux_reset_in] [get_bd_pins proc_sys_reset_0/aux_reset_in]
   connect_bd_net [get_bd_pins dcm_locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
   connect_bd_net [get_bd_pins dphy_clk_200M] [get_bd_pins v_frmbuf_rd_0/ap_clk]
   connect_bd_net [get_bd_pins dphy_clk_200M] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   connect_bd_net [get_bd_pins dphy_clk_200M] [get_bd_pins mipi_dsi_tx_subsystem_0/s_axis_aclk]
   connect_bd_net [get_bd_pins dphy_clk_200M] [get_bd_pins mipi_dsi_tx_subsystem_0/dphy_clk_200M]
   connect_bd_net [get_bd_pins video_aresetn] [get_bd_pins mipi_dsi_tx_subsystem_0/s_axis_aresetn]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins v_frmbuf_rd_0/ap_rst_n]
   connect_bd_net [get_bd_pins frame_buf_rd_int] [get_bd_pins v_frmbuf_rd_0/interrupt]
   connect_bd_net [get_bd_pins dsi_tx_int] [get_bd_pins mipi_dsi_tx_subsystem_0/interrupt]

   # Perform GUI Layout
   regenerate_bd_layout -hierarchy [get_bd_cells /DISPLAY_PIPELINE]

   save_bd_design

   # Restore current instance
   current_bd_instance $oldCurInst
}

proc avnet_add_pl_dualcam {project projects_folder scriptdir} {
   #
   # Dual Camera Mezzanine specific logic
   # 
   set_property -dict [list \
      CONFIG.PSU__USE__M_AXI_GP1 {1} \
      CONFIG.PSU__USE__S_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]

   save_bd_design

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1
   set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_1]

   save_bd_design

   # Create instance: CAPTURE_PIPELINE
   create_hier_cell_CAPTURE_PIPELINE [current_bd_instance .] CAPTURE_PIPELINE

   # Create instance: GPIO
   create_hier_cell_GPIO [current_bd_instance .] GPIO

   # Create instance: xlconstant_0, and set properties
   set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
   set_property -dict [ list \
    CONFIG.CONST_VAL {0} \
   ] $xlconstant_0

   # MIPI - Create interface ports
   create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0

   save_bd_design

   # MIPI - Create interface connections
   connect_bd_intf_net [get_bd_intf_ports mipi_phy_if_0] [get_bd_intf_pins CAPTURE_PIPELINE/mipi_phy_if_0]
   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins CAPTURE_PIPELINE/m_axi_mm_video] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
   connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD] -boundary_type upper [get_bd_intf_pins axi_interconnect_1/S00_AXI]

   save_bd_design

   create_bd_port -dir O -type clk clk48m
   set_property -dict [ list CONFIG.FREQ_HZ {48000000}] [get_bd_ports clk48m]
   
   # Make the PS SPI1 and I2C0 ports external and name them
   make_bd_intf_pins_external  [get_bd_intf_pins zynq_ultra_ps_e_0/IIC_0]
   set_property name ap1302_isp_i2c [get_bd_intf_ports IIC_0_0]

   make_bd_intf_pins_external  [get_bd_intf_pins zynq_ultra_ps_e_0/SPI_1]
   set_property name ap1302_isp_spi [get_bd_intf_ports SPI_1_0]
   
   # GPIO - Create ports
   create_bd_port -dir O -from 0 -to 0 icp3_i2c_id_select
   create_bd_port -dir O -from 0 -to 0 sp3
   create_bd_port -dir O -from 0 -to 0 trigger
   create_bd_port -dir O -from 0 -to 0 rst
   create_bd_port -dir O -from 0 -to 0 stby

   # GPIO - Create port connections
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_ports clk48m] 
   connect_bd_net [get_bd_pins GPIO/icp3_i2c_id_select] [get_bd_ports icp3_i2c_id_select] 
   connect_bd_net [get_bd_pins GPIO/sp3] [get_bd_ports sp3] 
   connect_bd_net [get_bd_pins GPIO/trigger] [get_bd_ports trigger] 
   connect_bd_net [get_bd_pins GPIO/rst] [get_bd_ports rst]
   connect_bd_net [get_bd_pins GPIO/stby] [get_bd_ports stby]

   save_bd_design

   # resets/dcm_locked - Create port connections
   connect_bd_net [get_bd_pins GPIO/frame_buffer_wr_resetn] [get_bd_pins CAPTURE_PIPELINE/frmbuf_resetn] 
   connect_bd_net [get_bd_pins GPIO/vpss_csc_resetn] [get_bd_pins CAPTURE_PIPELINE/vpss_csc_resetn] 
   connect_bd_net [get_bd_pins GPIO/vpss_scaler_resetn] [get_bd_pins CAPTURE_PIPELINE/vpss_scaler_resetn] 
   connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins CAPTURE_PIPELINE/dcm_locked] 
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins CAPTURE_PIPELINE/ext_reset_in] 

   save_bd_design

   # Interrupts - Create port connections
   connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins xlconcat_0/In0] [get_bd_pins xlconcat_0/In3] [get_bd_pins xlconcat_0/In4]
   connect_bd_net [get_bd_pins CAPTURE_PIPELINE/csirxss_csi_irq] [get_bd_pins xlconcat_0/In2]
   connect_bd_net [get_bd_pins CAPTURE_PIPELINE/interrupt] [get_bd_pins xlconcat_0/In1]

   connect_bd_net [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]

   save_bd_design

   # Connection Automation for GPIO cores (AXI_GPIO)
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/GPIO/axi_gpio_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}}  [get_bd_intf_pins GPIO/axi_gpio_0/S_AXI]

   save_bd_design

   # Connection Automation for CAPTURE_PIPELINE control interfaces (MIPI_CSI2_RX, VPSS, FRAMEBUF_WRITE)
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/clk_wiz_0/clk_out5 (200 MHz)} \
      Clk_slave {/clk_wiz_0/clk_out5 (200 MHz)} \
      Clk_xbar {/clk_wiz_0/clk_out5 (200 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} \
      Slave {/CAPTURE_PIPELINE/mipi_csi2_rx_subsyst_0/csirxss_s_axi} \
      ddr_seg {Auto} \
      intc_ip {axi_interconnect_1} \
      master_apm {0}}  [get_bd_intf_pins CAPTURE_PIPELINE/mipi_csi2_rx_subsyst_0/csirxss_s_axi]

   save_bd_design

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/clk_wiz_0/clk_out5 (200 MHz)} \
      Clk_slave {/clk_wiz_0/clk_out5 (200 MHz)} \
      Clk_xbar {/clk_wiz_0/clk_out5 (200 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} \
      Slave {/CAPTURE_PIPELINE/v_proc_ss_scaler_0/s_axi_ctrl} \
      ddr_seg {Auto} \
      intc_ip {axi_interconnect_1} \
      master_apm {0}}  [get_bd_intf_pins CAPTURE_PIPELINE/v_proc_ss_scaler_0/s_axi_ctrl]

   save_bd_design

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/clk_wiz_0/clk_out5 (200 MHz)} \
      Clk_slave {/clk_wiz_0/clk_out5 (200 MHz)} \
      Clk_xbar {/clk_wiz_0/clk_out5 (200 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} \
      Slave {/CAPTURE_PIPELINE/v_frmbuf_wr_0/s_axi_ctrl} \
      ddr_seg {Auto} \
      intc_ip {axi_interconnect_1} \
      master_apm {0}}  [get_bd_intf_pins CAPTURE_PIPELINE/v_frmbuf_wr_0/s_axi_ctrl]

   save_bd_design

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/clk_wiz_0/clk_out5 (200 MHz)} \
      Clk_slave {/clk_wiz_0/clk_out5 (200 MHz)} \
      Clk_xbar {/clk_wiz_0/clk_out5 (200 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} \
      Slave {/CAPTURE_PIPELINE/v_proc_ss_csc_0/s_axi_ctrl} \
      ddr_seg {Auto} \
      intc_ip {axi_interconnect_1} \
      master_apm {0}}  [get_bd_intf_pins CAPTURE_PIPELINE/v_proc_ss_csc_0/s_axi_ctrl]

   save_bd_design
}

