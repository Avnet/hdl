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
#     http://avnet.me/uzevforum
#
#  Product information is available at:
#     http://avnet.me/ultrazed-ev
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
#  Create Date:         Nov 10, 2017
#  Design Name:         UltraZed-EV NVME HW Platform
#  Module Name:         uz7ev_evcc_nvme.tcl
#  Project Name:        UltraZed-EV NVME HW
#  Target Devices:      Xilinx Zynq UltraScale+ 7EV
#  Hardware Boards:     UltraZed-EV SOM + EV Carrier + NVME FMC
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu7ev-fbvb900-1-i -force
}

proc avnet_import_constraints {boards_folder board project} {

   #import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/pcie_nvme.xdc

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
  connect_bd_net -net xlconstant_gnd_dout [get_bd_pins xlconcat_interrupt_0/In0] [get_bd_pins xlconcat_interrupt_0/In1] [get_bd_pins xlconcat_interrupt_0/In2] [get_bd_pins xlconcat_interrupt_0/In3] [get_bd_pins xlconcat_interrupt_0/In4] [get_bd_pins xlconcat_interrupt_0/In5] [get_bd_pins xlconcat_interrupt_0/In6] [get_bd_pins xlconcat_interrupt_0/In7] [get_bd_pins xlconcat_interrupt_0/In8] [get_bd_pins xlconcat_interrupt_0/In9] [get_bd_pins xlconcat_interrupt_0/In10] [get_bd_pins xlconcat_interrupt_0/In11] [get_bd_pins xlconcat_interrupt_0/In12] [get_bd_pins xlconcat_interrupt_0/In13] [get_bd_pins xlconcat_interrupt_0/In14] [get_bd_pins xlconcat_interrupt_0/In15] [get_bd_pins xlconcat_interrupt_0/In16] [get_bd_pins xlconcat_interrupt_0/In17] [get_bd_pins xlconcat_interrupt_0/In18] [get_bd_pins xlconcat_interrupt_0/In19] [get_bd_pins xlconcat_interrupt_0/In20] [get_bd_pins xlconcat_interrupt_0/In21] [get_bd_pins xlconcat_interrupt_0/In22] [get_bd_pins xlconcat_interrupt_0/In23] [get_bd_pins xlconcat_interrupt_0/In24] [get_bd_pins xlconcat_interrupt_0/In25] [get_bd_pins xlconcat_interrupt_0/In26] [get_bd_pins xlconcat_interrupt_0/In27] [get_bd_pins xlconcat_interrupt_0/In28] [get_bd_pins xlconcat_interrupt_0/In29] [get_bd_pins xlconcat_interrupt_0/In30] [get_bd_pins xlconcat_interrupt_0/In31] [get_bd_pins xlconstant_gnd/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the UZ SOM which is derived from the 
   # board definition file downloadable from the UltraZed.org community site.
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   apply_board_connection -board_interface "dip_switches_8bits" -ip_intf "axi_gpio_0/GPIO" -diagram $project 
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   apply_board_connection -board_interface "led_8bits" -ip_intf "axi_gpio_1/GPIO" -diagram $project 
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2
   apply_board_connection -board_interface "push_buttons_3bits" -ip_intf "axi_gpio_2/GPIO" -diagram $project
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_gpio_1/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_gpio_2/S_AXI]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk]
   
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   endgroup
   startgroup
   set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] [get_bd_cells axi_gpio_2]
   endgroup
   startgroup
   set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] [get_bd_cells axi_gpio_0]
   endgroup
   startgroup
   set_property -dict [list CONFIG.PSU__USE__IRQ0 {1}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup
   set_property -dict [list CONFIG.NUM_PORTS {2}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   connect_bd_net [get_bd_pins axi_gpio_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins axi_gpio_2/ip2intc_irpt] [get_bd_pins xlconcat_0/In1]

   set_property name rst_ps8_0_100M [get_bd_cells rst_ps8_0_99M]

   #
   # VITIS ADDITIONS - START
   #  

   # Disable M_AXI_HPM1_FPD (keep available to VITIS for control interface)
   set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {0}] [get_bd_cells zynq_ultra_ps_e_0]

   # Add AXI interrupt controller (for VITIS XRT interrupt support)
   set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
   set_property -dict [ list \
      CONFIG.C_IRQ_IS_LEVEL {1} \
   ] $axi_intc_0
   #
   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   #create_hier_cell_interrupt_concat [current_bd_instance .] interrupt_concat
   #connect_bd_net -net interrupt_concat_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins interrupt_concat/dout]
   #
   set_property -dict [list CONFIG.NUM_PORTS {6}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/In5] [get_bd_pins axi_intc_0/irq]
   #
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_intc_0/s_axi} ddr_seg {Auto} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_intc_0/s_axi]

   #delete_bd_objs [get_bd_nets proc_sys_reset_0_peripheral_aresetn1]
   #connect_bd_net [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn]

   #disconnect_bd_net /zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   #disconnect_bd_net /zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins proc_sys_reset_0/ext_reset_in]


   # Create clock wizard (with same clock frequencies as in zcu102_base/zcu104_base VITIS platforms)
   #   [0] 150 MHz
   #   [1] 300 MHz
   #   [2]  75 MHz
   #   [3] 100 MHz
   #   [4] 200 MHz
   #   [5] 400 MHz
   #   [6] 600 MHz
   set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
   set_property -dict [ list \
      CONFIG.CLKOUT1_JITTER {107.567} \
      CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150} \
      CONFIG.CLKOUT2_JITTER {94.862} \
      CONFIG.CLKOUT2_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300} \
      CONFIG.CLKOUT2_USED {true} \
      CONFIG.CLKOUT3_JITTER {122.158} \
      CONFIG.CLKOUT3_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {75} \
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
      CONFIG.MMCM_CLKOUT2_DIVIDE {16} \
      CONFIG.MMCM_CLKOUT3_DIVIDE {12} \
      CONFIG.MMCM_CLKOUT4_DIVIDE {6} \
      CONFIG.MMCM_CLKOUT5_DIVIDE {3} \
      CONFIG.MMCM_CLKOUT6_DIVIDE {2} \
      CONFIG.NUM_OUT_CLKS {7} \
      CONFIG.RESET_PORT {resetn} \
      CONFIG.RESET_TYPE {ACTIVE_LOW} \
   ] $clk_wiz_0
   #
   set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
   set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
   set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]
   set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3 ]
   set proc_sys_reset_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_4 ]
   set proc_sys_reset_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_5 ]
   set proc_sys_reset_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_6 ]
   #
   connect_bd_net [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   #
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out5 [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins proc_sys_reset_4/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out6 [get_bd_pins clk_wiz_0/clk_out6] [get_bd_pins proc_sys_reset_5/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out7 [get_bd_pins clk_wiz_0/clk_out7] [get_bd_pins proc_sys_reset_6/slowest_sync_clk]
   #
   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked] [get_bd_pins proc_sys_reset_2/dcm_locked] [get_bd_pins proc_sys_reset_3/dcm_locked] [get_bd_pins proc_sys_reset_4/dcm_locked] [get_bd_pins proc_sys_reset_5/dcm_locked] [get_bd_pins proc_sys_reset_6/dcm_locked]
   #
   connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins clk_wiz_0/resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins proc_sys_reset_2/ext_reset_in] [get_bd_pins proc_sys_reset_3/ext_reset_in] [get_bd_pins proc_sys_reset_4/ext_reset_in] [get_bd_pins proc_sys_reset_5/ext_reset_in] [get_bd_pins proc_sys_reset_6/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]


   #
   # VITIS ADDITIONS - END
   #  
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]

   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]
   
   # Connect the SD card WP pin to MIO44 and pull it down to enable software (PetaLinux) 
   # to mount and write the SD card
   set_property -dict [list CONFIG.PSU__SD1__GRP_WP__ENABLE {1} CONFIG.PSU_MIO_44_PULLUPDOWN {pulldown}] [get_bd_cells zynq_ultra_ps_e_0]

}

# This will add AXI interconnect and xdma blocks, etc. to support using NVME SSDs
# The xdma block is configured for 2 PCIe lanes
# This will support M.2 NVME SSDs that are "B" keyed (2 PCIe lanes) or "M" keyed (4 PCIe lanes)
proc avnet_add_nvme {project projects_folder scriptdir} {
  create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0
  set_property -dict [list \
    CONFIG.functional_mode {AXI_Bridge} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.device_port_type {Root_Port_of_PCI_Express_Root_Complex} \
    CONFIG.pcie_blk_locn {X0Y1} \
    CONFIG.select_quad {GTH_Quad_225} \
    CONFIG.pl_link_cap_max_link_width {X2} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.axi_addr_width {49} \
    CONFIG.axi_data_width {64_bit} \
    CONFIG.axisten_freq {250} \
    CONFIG.dedicate_perst {false} \
    CONFIG.sys_reset_polarity {ACTIVE_LOW} \
    CONFIG.pf0_device_id {9132} \
    CONFIG.pf0_base_class_menu {Bridge_device} \
    CONFIG.pf0_class_code_base {06} \
    CONFIG.pf0_sub_class_interface_menu {PCI_to_PCI_bridge} \
    CONFIG.pf0_class_code_sub {04} \
    CONFIG.pf0_class_code_interface {00} \
    CONFIG.pf0_class_code {060400} \
    CONFIG.xdma_axilite_slave {true} \
    CONFIG.en_gt_selection {true} \
    CONFIG.INS_LOSS_NYQ {5} \
    CONFIG.plltype {QPLL1} \
    CONFIG.ins_loss_profile {Chip-to-Chip} \
    CONFIG.type1_membase_memlimit_enable {Enabled} \
    CONFIG.type1_prefetchable_membase_memlimit {64bit_Enabled} \
    CONFIG.axibar_num {1} \
    CONFIG.axibar2pciebar_0 {0x00000000A0000000} \
    CONFIG.BASEADDR {0x00000000} \
    CONFIG.HIGHADDR {0x001FFFFF} \
    CONFIG.pf0_bar0_enabled {false} \
    CONFIG.pf1_class_code {060700} \
    CONFIG.pf1_base_class_menu {Bridge_device} \
    CONFIG.pf1_class_code_base {06} \
    CONFIG.pf1_class_code_sub {07} \
    CONFIG.pf1_sub_class_interface_menu {CardBus_bridge} \
    CONFIG.pf1_class_code_interface {00} \
    CONFIG.pf1_bar2_enabled {false} \
    CONFIG.pf1_bar2_64bit {false} \
    CONFIG.pf1_bar4_enabled {false} \
    CONFIG.pf1_bar4_64bit {false} \
    CONFIG.dma_reset_source_sel {Phy_Ready} \
    CONFIG.pf0_bar0_type_mqdma {Memory} \
    CONFIG.pf1_bar0_type_mqdma {Memory} \
    CONFIG.pf2_bar0_type_mqdma {Memory} \
    CONFIG.pf3_bar0_type_mqdma {Memory} \
    CONFIG.pf0_sriov_bar0_type {Memory} \
    CONFIG.pf1_sriov_bar0_type {Memory} \
    CONFIG.pf2_sriov_bar0_type {Memory} \
    CONFIG.pf3_sriov_bar0_type {Memory} \
    CONFIG.PF0_DEVICE_ID_mqdma {9132} \
    CONFIG.PF2_DEVICE_ID_mqdma {9132} \
    CONFIG.PF3_DEVICE_ID_mqdma {9132} \
    CONFIG.pf0_base_class_menu_mqdma {Bridge_device} \
    CONFIG.pf0_class_code_base_mqdma {06} \
    CONFIG.pf0_class_code_mqdma {068000} \
    CONFIG.pf1_base_class_menu_mqdma {Bridge_device} \
    CONFIG.pf1_class_code_base_mqdma {06} \
    CONFIG.pf1_class_code_mqdma {068000} \
    CONFIG.pf2_base_class_menu_mqdma {Bridge_device} \
    CONFIG.pf2_class_code_base_mqdma {06} \
    CONFIG.pf2_class_code_mqdma {068000} \
    CONFIG.pf3_base_class_menu_mqdma {Bridge_device} \
    CONFIG.pf3_class_code_base_mqdma {06} \
    CONFIG.pf3_class_code_mqdma {068000} \
    CONFIG.msi_rx_pin_en {TRUE}] [get_bd_cells xdma_0]

  make_bd_intf_pins_external  [get_bd_intf_pins xdma_0/pcie_mgt]
  set_property name pci_exp_0 [get_bd_intf_ports pcie_mgt_0]

  create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_1
  set_property -dict [list \
    CONFIG.functional_mode {AXI_Bridge} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.device_port_type {Root_Port_of_PCI_Express_Root_Complex} \
    CONFIG.pcie_blk_locn {X0Y0} \
    CONFIG.select_quad {GTH_Quad_224} \
    CONFIG.pl_link_cap_max_link_width {X2} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.axi_addr_width {49} \
    CONFIG.axi_data_width {64_bit} \
    CONFIG.axisten_freq {250} \
    CONFIG.dedicate_perst {false} \
    CONFIG.sys_reset_polarity {ACTIVE_LOW} \
    CONFIG.pf0_device_id {9132} \
    CONFIG.pf0_base_class_menu {Bridge_device} \
    CONFIG.pf0_class_code_base {06} \
    CONFIG.pf0_sub_class_interface_menu {PCI_to_PCI_bridge} \
    CONFIG.pf0_class_code_sub {04} \
    CONFIG.pf0_class_code_interface {00} \
    CONFIG.pf0_class_code {060400} \
    CONFIG.xdma_axilite_slave {true} \
    CONFIG.en_gt_selection {true} \
    CONFIG.INS_LOSS_NYQ {5} \
    CONFIG.plltype {QPLL1} \
    CONFIG.ins_loss_profile {Chip-to-Chip} \
    CONFIG.type1_membase_memlimit_enable {Enabled} \
    CONFIG.type1_prefetchable_membase_memlimit {64bit_Enabled} \
    CONFIG.axibar_num {1} \
    CONFIG.axibar2pciebar_0 {0x00000000B0000000} \
    CONFIG.BASEADDR {0x00000000} \
    CONFIG.HIGHADDR {0x001FFFFF} \
    CONFIG.pf0_bar0_enabled {false} \
    CONFIG.pf1_class_code {060700} \
    CONFIG.pf1_base_class_menu {Bridge_device} \
    CONFIG.pf1_class_code_base {06} \
    CONFIG.pf1_class_code_sub {07} \
    CONFIG.pf1_sub_class_interface_menu {CardBus_bridge} \
    CONFIG.pf1_class_code_interface {00} \
    CONFIG.pf1_bar2_enabled {false} \
    CONFIG.pf1_bar2_64bit {false} \
    CONFIG.pf1_bar4_enabled {false} \
    CONFIG.pf1_bar4_64bit {false} \
    CONFIG.dma_reset_source_sel {Phy_Ready} \
    CONFIG.pf0_bar0_type_mqdma {Memory} \
    CONFIG.pf1_bar0_type_mqdma {Memory} \
    CONFIG.pf2_bar0_type_mqdma {Memory} \
    CONFIG.pf3_bar0_type_mqdma {Memory} \
    CONFIG.pf0_sriov_bar0_type {Memory} \
    CONFIG.pf1_sriov_bar0_type {Memory} \
    CONFIG.pf2_sriov_bar0_type {Memory} \
    CONFIG.pf3_sriov_bar0_type {Memory} \
    CONFIG.PF0_DEVICE_ID_mqdma {9132} \
    CONFIG.PF2_DEVICE_ID_mqdma {9132} \
    CONFIG.PF3_DEVICE_ID_mqdma {9132} \
    CONFIG.pf0_base_class_menu_mqdma {Bridge_device} \
    CONFIG.pf0_class_code_base_mqdma {06} \
    CONFIG.pf0_class_code_mqdma {068000} \
    CONFIG.pf1_base_class_menu_mqdma {Bridge_device} \
    CONFIG.pf1_class_code_base_mqdma {06} \
    CONFIG.pf1_class_code_mqdma {068000} \
    CONFIG.pf2_base_class_menu_mqdma {Bridge_device} \
    CONFIG.pf2_class_code_base_mqdma {06} \
    CONFIG.pf2_class_code_mqdma {068000} \
    CONFIG.pf3_base_class_menu_mqdma {Bridge_device} \
    CONFIG.pf3_class_code_base_mqdma {06} \
    CONFIG.pf3_class_code_mqdma {068000} \
    CONFIG.msi_rx_pin_en {TRUE}] [get_bd_cells xdma_1]

  make_bd_intf_pins_external  [get_bd_intf_pins xdma_1/pcie_mgt]
  set_property name pci_exp_1 [get_bd_intf_ports pcie_mgt_0]

  create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 ref_clk_0_buf
  make_bd_intf_pins_external  [get_bd_intf_pins ref_clk_0_buf/CLK_IN_D]
  set_property name ref_clk_0 [get_bd_intf_ports CLK_IN_D_0]
  set_property -dict [list CONFIG.C_BUF_TYPE {IBUFDSGTE}] [get_bd_cells ref_clk_0_buf]
  connect_bd_net [get_bd_pins ref_clk_0_buf/IBUF_DS_ODIV2] [get_bd_pins xdma_0/sys_clk]
  connect_bd_net [get_bd_pins ref_clk_0_buf/IBUF_OUT] [get_bd_pins xdma_0/sys_clk_gt]

  create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 ref_clk_1_buf
  make_bd_intf_pins_external  [get_bd_intf_pins ref_clk_1_buf/CLK_IN_D]
  set_property name ref_clk_1 [get_bd_intf_ports CLK_IN_D_0]
  set_property -dict [list CONFIG.C_BUF_TYPE {IBUFDSGTE}] [get_bd_cells ref_clk_1_buf]
  connect_bd_net [get_bd_pins ref_clk_1_buf/IBUF_DS_ODIV2] [get_bd_pins xdma_1/sys_clk]
  connect_bd_net [get_bd_pins ref_clk_1_buf/IBUF_OUT] [get_bd_pins xdma_1/sys_clk_gt]

  create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_pcie_0_axi_aclk
  make_bd_pins_external  [get_bd_pins rst_pcie_0_axi_aclk/peripheral_reset]
  set_property name perst_0 [get_bd_ports peripheral_reset_0]

  create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_pcie_1_axi_aclk
  make_bd_pins_external  [get_bd_pins rst_pcie_1_axi_aclk/peripheral_reset]
  set_property name perst_1 [get_bd_ports peripheral_reset_0]

  create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 constant_dis_ssd2_pwr
  make_bd_pins_external  [get_bd_pins constant_dis_ssd2_pwr/dout]
  set_property name disable_ssd2_pwr [get_bd_ports dout_0]
  # Set to 0 to ENABLE SSD2
  set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells constant_dis_ssd2_pwr]
  
  save_bd_design

  set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__USE__S_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__USE__S_AXI_GP3 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  
  save_bd_design

  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon_0
  set_property -dict [list CONFIG.NUM_SI {1} \
    CONFIG.NUM_MI {1}] [get_bd_cells axi_mem_intercon_0]

  save_bd_design

  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon_1
  set_property -dict [list CONFIG.NUM_SI {1} \
    CONFIG.NUM_MI {1}] [get_bd_cells axi_mem_intercon_1]

  save_bd_design

  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_mem_intercon_0/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_mem_intercon_1/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP1_FPD]

  save_bd_design

  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 periph_intercon_1
  set_property -dict [list CONFIG.NUM_SI {1} \
    CONFIG.NUM_MI {2}] [get_bd_cells periph_intercon_1]

  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD] [get_bd_intf_pins periph_intercon_1/S00_AXI] 

  set_property -dict [list CONFIG.NUM_MI {6}] [get_bd_cells ps8_0_axi_periph]

  save_bd_design

  set_property -dict [list CONFIG.PSU__USE__IRQ1 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1
  set_property -dict [list CONFIG.NUM_PORTS {6}] [get_bd_cells xlconcat_1]

  save_bd_design

  # Connect clocks, resets, and PS int input [from] [to]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/saxihp1_fpd_aclk]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_mem_intercon_0/M00_ACLK]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_mem_intercon_1/M00_ACLK]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins periph_intercon_1/S00_ACLK]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins periph_intercon_1/ACLK]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins xdma_0/sys_rst_n] 
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins xdma_1/sys_rst_n] 
  connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins axi_mem_intercon_0/M00_ARESETN]
  connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins axi_mem_intercon_1/M00_ARESETN]
  connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins periph_intercon_1/ARESETN]
  connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins periph_intercon_1/S00_ARESETN]
  connect_bd_net [get_bd_pins xlconcat_1/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1]

  save_bd_design

  # Connect PCIE channel 0 [from] [to]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M04_AXI] [get_bd_intf_pins xdma_0/S_AXI_B]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M05_AXI] [get_bd_intf_pins xdma_0/S_AXI_LITE]
  connect_bd_intf_net [get_bd_intf_pins xdma_0/M_AXI_B] -boundary_type upper [get_bd_intf_pins axi_mem_intercon_0/S00_AXI]

  connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins rst_pcie_0_axi_aclk/slowest_sync_clk]
  connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins axi_mem_intercon_0/ACLK]
  connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins axi_mem_intercon_0/S00_ACLK]
  connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins ps8_0_axi_periph/M04_ACLK]
  connect_bd_net [get_bd_pins xdma_0/axi_aclk] [get_bd_pins ps8_0_axi_periph/M05_ACLK]

  connect_bd_net [get_bd_pins xdma_0/axi_ctl_aresetn] [get_bd_pins ps8_0_axi_periph/M05_ARESETN]
  connect_bd_net [get_bd_pins xdma_0/axi_ctl_aresetn] [get_bd_pins rst_pcie_0_axi_aclk/ext_reset_in]

  connect_bd_net [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins axi_mem_intercon_0/ARESETN]
  connect_bd_net [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins axi_mem_intercon_0/S00_ARESETN]
  connect_bd_net [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins ps8_0_axi_periph/M04_ARESETN]

  connect_bd_net [get_bd_pins xdma_0/interrupt_out] [get_bd_pins xlconcat_1/In0]
  connect_bd_net [get_bd_pins xdma_0/interrupt_out_msi_vec0to31] [get_bd_pins xlconcat_1/In1]
  connect_bd_net [get_bd_pins xdma_0/interrupt_out_msi_vec32to63] [get_bd_pins xlconcat_1/In2]

  save_bd_design

# Connect PCIE channel 1 [from] [to]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins periph_intercon_1/M00_AXI] [get_bd_intf_pins xdma_1/S_AXI_B]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins periph_intercon_1/M01_AXI] [get_bd_intf_pins xdma_1/S_AXI_LITE]
  connect_bd_intf_net [get_bd_intf_pins xdma_1/M_AXI_B] -boundary_type upper [get_bd_intf_pins axi_mem_intercon_1/S00_AXI]

  connect_bd_net [get_bd_pins xdma_1/axi_aclk] [get_bd_pins rst_pcie_1_axi_aclk/slowest_sync_clk]
  connect_bd_net [get_bd_pins xdma_1/axi_aclk] [get_bd_pins axi_mem_intercon_1/ACLK]
  connect_bd_net [get_bd_pins xdma_1/axi_aclk] [get_bd_pins axi_mem_intercon_1/S00_ACLK]
  connect_bd_net [get_bd_pins xdma_1/axi_aclk] [get_bd_pins periph_intercon_1/M00_ACLK]
  connect_bd_net [get_bd_pins xdma_1/axi_aclk] [get_bd_pins periph_intercon_1/M01_ACLK]

  connect_bd_net [get_bd_pins xdma_1/axi_ctl_aresetn] [get_bd_pins periph_intercon_1/M01_ARESETN]
  connect_bd_net [get_bd_pins xdma_1/axi_ctl_aresetn] [get_bd_pins rst_pcie_1_axi_aclk/ext_reset_in]

  connect_bd_net [get_bd_pins xdma_1/axi_aresetn] [get_bd_pins axi_mem_intercon_1/ARESETN]
  connect_bd_net [get_bd_pins xdma_1/axi_aresetn] [get_bd_pins axi_mem_intercon_1/S00_ARESETN]
  connect_bd_net [get_bd_pins xdma_1/axi_aresetn] [get_bd_pins periph_intercon_1/M00_ARESETN]

  connect_bd_net [get_bd_pins xdma_1/interrupt_out] [get_bd_pins xlconcat_1/In3]
  connect_bd_net [get_bd_pins xdma_1/interrupt_out_msi_vec0to31] [get_bd_pins xlconcat_1/In4]
  connect_bd_net [get_bd_pins xdma_1/interrupt_out_msi_vec32to63] [get_bd_pins xlconcat_1/In5]

  regenerate_bd_layout
  save_bd_design
}

proc avnet_add_sdsoc_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   #set_property PFM_NAME "em.avnet.com:av:${design_name}:1.0" [get_files ./${design_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd]
   set_property PFM_NAME "em.avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]


   # define clock and reset ports
   set_property PFM.CLOCK { \
      pl_clk0 {id "0" is_default "true" proc_sys_reset "rst_ps8_0_100M"} \
   } [get_bd_cells /zynq_ultra_ps_e_0]
   

   # define AXI ports
   # HPM0
   set parVal []
   set cnt [get_property CONFIG.NUM_MI [get_bd_cells /ps8_0_axi_periph]]
   for {set i $cnt} {$i < 64} {incr i} {
      lappend parVal M[format %02d $i]_AXI {memport "M_AXI_GP"}
   }
   set_property PFM.AXI_PORT $parVal [get_bd_cells /ps8_0_axi_periph]
   # HPM1
   set_property PFM.AXI_PORT { \
      M_AXI_HPM1_FPD {memport "M_AXI_GP"} \
      M_AXI_HPM0_LPD {memport "M_AXI_GP"} \
   } [get_bd_cells /zynq_ultra_ps_e_0]
   # HP1-HP3
   set_property PFM.AXI_PORT { \
      S_AXI_HP1_FPD {memport "S_AXI_HP"} \
      S_AXI_HP2_FPD {memport "S_AXI_HP"} \
      S_AXI_HP3_FPD {memport "S_AXI_HP"} \
   } [get_bd_cells /zynq_ultra_ps_e_0]
   
   # define interrupt ports
   # interrupts0
   set parVal []
   set cnt [get_property CONFIG.NUM_PORTS [get_bd_cell /xlconcat_0]]
   for {set i $cnt} {$i < 8} {incr i} {
      lappend parVal In$i {}
   }
   set_property PFM.IRQ $parVal [get_bd_cells /xlconcat_0]
}

proc avnet_assign_addresses {project projects_folder scriptdir} {
    # Unassign all address segments
  delete_bd_objs [get_bd_addr_segs]
  delete_bd_objs [get_bd_addr_segs -excluded]

  # Hard-code specific address segments (used in device-tree or applications)
  assign_bd_address -offset 0xa0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force

  assign_bd_address -target_address_space /zynq_ultra_ps_e_0/Data [get_bd_addr_segs xdma_0/S_AXI_B/BAR0] -force
  assign_bd_address -target_address_space /zynq_ultra_ps_e_0/Data [get_bd_addr_segs xdma_0/S_AXI_LITE/CTL0] -force
  set_property offset 0x00A1000000 [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_xdma_0_BAR0}]
  set_property range 16M [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_xdma_0_BAR0}]
  set_property offset 0x0400000000 [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_xdma_0_CTL0}]
  set_property range 512M [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_xdma_0_CTL0}]
  
  assign_bd_address -target_address_space /zynq_ultra_ps_e_0/Data [get_bd_addr_segs xdma_1/S_AXI_B/BAR0] -force
  assign_bd_address -target_address_space /zynq_ultra_ps_e_0/Data [get_bd_addr_segs xdma_1/S_AXI_LITE/CTL0] -force
  set_property offset 0x00B1000000 [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_xdma_1_BAR0}]
  set_property range 16M [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_xdma_1_BAR0}]
  set_property offset 0x0500000000 [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_xdma_1_CTL0}]
  set_property range 512M [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_xdma_1_CTL0}]

  
  assign_bd_address

}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   set_property PFM_NAME "em.avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

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
	M_AXI_HPM1_FPD {memport "M_AXI_GP"} \
	S_AXI_HPC0_FPD {memport "S_AXI_HPC" sptag "HPC0" memory "zynq_ultra_ps_e_0 HPC0_DDR_LOW"} \
	S_AXI_HPC1_FPD {memport "S_AXI_HPC" sptag "HPC1" memory "zynq_ultra_ps_e_0 HPC1_DDR_LOW"} \
	S_AXI_HP0_FPD {memport "S_AXI_HP" sptag "HP0" memory "zynq_ultra_ps_e_0 HP0_DDR_LOW"} \
	S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "zynq_ultra_ps_e_0 HP1_DDR_LOW"} \
	S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "zynq_ultra_ps_e_0 HP2_DDR_LOW"} \
	S_AXI_HP3_FPD {memport "S_AXI_HP" sptag "HP3" memory "zynq_ultra_ps_e_0 HP3_DDR_LOW"} \
   } [get_bd_cells /zynq_ultra_ps_e_0]

   # required for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   # define interrupt ports
   set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]
  
   # Set platform project properties
   set_property platform.description                   "Base UZ7EV_EVCC development platform" [current_project]
   set_property platform.uses_pr                       false         [current_project]

   set_property platform.design_intent.server_managed  "false" [current_project]
   set_property platform.design_intent.external_host   "false" [current_project]
   set_property platform.design_intent.embedded        "true" [current_project]
   set_property platform.design_intent.datacenter      "false" [current_proj]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   #set_property platform.post_sys_link_tcl_hook        ${projects_folder}/../../../boards/uz7ev_evcc/uz7ev_evcc_dynamic_postlink.tcl [current_project]

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

