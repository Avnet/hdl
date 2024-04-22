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
#  Please direct any questions to the Ultra96 community support forum:
#     http://avnet.me/Ultra96_Forum
#
#  Product information is available at:
#     http://avnet.me/ultra96-v2
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2024 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Create Date:         Mar 01, 2024
#  Design Name:         Ultra96v2 FacTest HW Platform
#  Module Name:         u96v2_sbc_factest.tcl
#  Project Name:        Ultra96v2 FacTest HW
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96v2 Board
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu3eg-sbva484-1-i -force
   set_property platform.extensible false [current_project]
}

proc avnet_import_constraints {boards_folder board project} {

   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
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

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_0/S_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_uart16550_0/S_AXI]

   create_bd_port -dir I -type data ls_mezz_uart_rxd
   connect_bd_net [get_bd_pins /axi_uart16550_0/sin] [get_bd_ports ls_mezz_uart_rxd]

   create_bd_port -dir O -type data ls_mezz_uart_txd
   connect_bd_net [get_bd_pins /axi_uart16550_0/sout] [get_bd_ports ls_mezz_uart_txd]
   
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_ctsn]
   set_property name BT_ctsn [get_bd_ports emio_uart0_ctsn_0]

   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_rtsn]

   set_property name BT_rtsn [get_bd_ports emio_uart0_rtsn_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0

   set_property -dict [list CONFIG.DIN_FROM {43} CONFIG.DIN_WIDTH {44} CONFIG.DOUT_WIDTH {23} CONFIG.DIN_TO {0}] [get_bd_cells xlslice_0]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_0/Din]

   set_property -dict [list CONFIG.DIN_FROM {22} CONFIG.DOUT_WIDTH {23}] [get_bd_cells xlslice_0]

   make_bd_pins_external  [get_bd_pins xlslice_0/Dout]

   set_property name loopback_out [get_bd_ports Dout_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0

   set_property -dict [list CONFIG.IN1_WIDTH.VALUE_SRC USER CONFIG.IN0_WIDTH.VALUE_SRC USER] [get_bd_cells xlconcat_0]
   set_property -dict [list CONFIG.IN0_WIDTH {23} CONFIG.IN1_WIDTH {21}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_i]

   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0

   set_property -dict [list CONFIG.CONST_WIDTH {23} CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]
   connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins xlconcat_0/In0]

   make_bd_pins_external  [get_bd_pins xlconcat_0/In1]

   set_property name loopback_in [get_bd_ports In1_0]


   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1

   set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells xlconcat_1]
   connect_bd_net [get_bd_pins xlconcat_1/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   connect_bd_net [get_bd_pins axi_uart16550_0/ip2intc_irpt] [get_bd_pins xlconcat_1/In0]


   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" intc_ip "Auto" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:board  [get_bd_intf_pins axi_gpio_0/GPIO]

   set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_GPIO2_WIDTH {1} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_0]

   set_property name wifi_en_led [get_bd_intf_ports gpio_rtl]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_0/GPIO2]

   set_property name bt_en_led [get_bd_intf_ports GPIO2_0]

   regenerate_bd_layout
   validate_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]

   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]

   # Disable M_AXI_HPM1_FPD (not used)
   set_property CONFIG.PSU__USE__M_AXI_GP1 {0} [get_bd_cells zynq_ultra_ps_e_0]

   # MIO25 is used as GPIO for USB Vbus detect.  Change to pullup instead of default pulldown
   set_property -dict [list CONFIG.PSU_MIO_25_PULLUPDOWN {pullup}] [get_bd_cells zynq_ultra_ps_e_0]

   # Add the modem flow control pins to PSU UART0
   set_property -dict [list CONFIG.PSU__UART0__MODEM__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
   
   # Disable PMU GPO2 (disconnect MIO34) (work-around for PMU power-off issue)
   set_property -dict [list CONFIG.PSU__PMU__GPO2__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]

   #set_property -dict [list CONFIG.PSU__PMU__GPO2__POLARITY {high}] [get_bd_cells zynq_ultra_ps_e_0]

   set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {44}] [get_bd_cells zynq_ultra_ps_e_0]

}

proc avnet_assign_addresses {project projects_folder scriptdir} {
    # Unassign all address segments
  delete_bd_objs [get_bd_addr_segs]
  delete_bd_objs [get_bd_addr_segs -excluded]

  # Hard-code specific address segments (used in device-tree or applications)
  assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  
  assign_bd_address

}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   #~ set_property PFM_NAME "avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

   #~ # define clock and reset ports
   #~ set_property PFM.CLOCK { \
      #~ clk_out1 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_0" status "fixed"} \
      #~ clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_1" status "fixed"} \
      #~ clk_out3 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_2" status "fixed"} \
      #~ clk_out4 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_3" status "fixed"} \
      #~ clk_out5 {id "4" is_default "false" proc_sys_reset "/proc_sys_reset_4" status "fixed"} \
      #~ clk_out6 {id "5" is_default "false" proc_sys_reset "/proc_sys_reset_5" status "fixed"} \
      #~ clk_out7 {id "6" is_default "false" proc_sys_reset "/proc_sys_reset_6" status "fixed"} \
   #~ } [get_bd_cells /clk_wiz_0]


   #~ # define AXI ports
   #~ set_property PFM.AXI_PORT { \
      #~ M_AXI_HPM1_FPD {memport "M_AXI_GP"} \
      #~ S_AXI_HPC0_FPD {memport "S_AXI_HPC" sptag "HPC0" memory "zynq_ultra_ps_e_0 HPC0_DDR_LOW"} \
      #~ S_AXI_HPC1_FPD {memport "S_AXI_HPC" sptag "HPC1" memory "zynq_ultra_ps_e_0 HPC1_DDR_LOW"} \
      #~ S_AXI_HP0_FPD {memport "S_AXI_HP" sptag "HP0" memory "zynq_ultra_ps_e_0 HP0_DDR_LOW"} \
      #~ S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "zynq_ultra_ps_e_0 HP1_DDR_LOW"} \
      #~ S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "zynq_ultra_ps_e_0 HP2_DDR_LOW"} \
      #~ S_AXI_HP3_FPD {memport "S_AXI_HP" sptag "HP3" memory "zynq_ultra_ps_e_0 HP3_DDR_LOW"} \
   #~ } [get_bd_cells /zynq_ultra_ps_e_0]

   #~ # required for Vitis 2020.1 onwards
   #~ # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   #~ # define interrupt ports
   #~ set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells microblaze_0_axi_intc]
  
   #~ # Set platform project properties
   #~ set_property platform.description                   "Valtest AUBoard-15P development platform" [current_project]
   #~ set_property platform.uses_pr                       false         [current_project]

   #~ set_property platform.design_intent.server_managed  "false" [current_project]
   #~ set_property platform.design_intent.external_host   "false" [current_project]
   #~ set_property platform.design_intent.embedded        "true" [current_project]
   #~ set_property platform.design_intent.datacenter      "false" [current_proj]

   #~ set_property platform.vendor                        "avnet.com" [current_project]
   #~ set_property platform.board_id                      ${project} [current_project]
   #~ set_property platform.name                          ${design_name} [current_project]
   #~ set_property platform.version                       "1.0" [current_project]
   #~ set_property platform.platform_state                "pre_synth" [current_project]
   #~ set_property platform.ip_cache_dir                  [get_property ip_output_repo [current_project]] [current_project]

   #~ # recommnded to use "sd_card" for Vitis 2020.1 onwards
   #~ # reference : https://github.com/Xilinx/Vitis_Embedded_Platform_Source/blob/2020.1/Xilinx_Official_Platforms/zcu104_base/vivado/xilinx_zcu104_base_202010_1_xsa.tcl
   #~ #set_property platform.default_output_type           "xclbin" [current_project]
   #~ set_property platform.default_output_type           "sd_card" [current_project]

   #~ set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
   #~ set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
   #~ set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
}
