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
#                      Copyright(c) 2021 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Create Date:         Apr 04, 2019
#  Design Name:         Ultra96v2 Base HW Platform
#  Module Name:         u96v2_sbc_base.tcl
#  Project Name:        Ultra96v2 Base HW
#  Target Devices:      Xilinx Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96v2 Board
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu3eg-sbva484-1-i -force
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

   #
   # Add the AXI Interconnect and Processor System Reset blocks
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
   
   connect_bd_net [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   connect_bd_net [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
   
   save_bd_design
   
   connect_bd_intf_net [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
   connect_bd_net [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   
   set_property name ps8_0_axi_periph [get_bd_cells axi_interconnect_0]
   set_property name rst_ps8_0_100M [get_bd_cells proc_sys_reset_0]
   
   #
   # Add the Block Memory Controller and BRAM
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_bram_ctrl_0/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
   
   set_property -dict [ list CONFIG.DATA_WIDTH {128} CONFIG.ECC_TYPE {0} CONFIG.SUPPORTS_NARROW_BURST {1} ]  [get_bd_cells axi_bram_ctrl_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
   set_property name axi_bram_ctrl_0_bram [get_bd_cells blk_mem_gen_0]

   set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} ] [get_bd_cells axi_bram_ctrl_0_bram]

   apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
   apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "/axi_bram_ctrl_0_bram" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]
   
   #
   # Add LS Mezzanine UARTs
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_0/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_uart16550_0/S_AXI]

   make_bd_pins_external  [get_bd_pins axi_uart16550_0/sin]
   set_property name ls_mezz_uart0_rx [get_bd_ports sin_0]

   make_bd_pins_external  [get_bd_pins axi_uart16550_0/sout]
   set_property name ls_mezz_uart0_tx [get_bd_ports sout_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_1

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_1/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_uart16550_1/S_AXI]

   make_bd_pins_external  [get_bd_pins axi_uart16550_1/sin]
   set_property name ls_mezz_uart1_rx [get_bd_ports sin_0]

   make_bd_pins_external  [get_bd_pins axi_uart16550_1/sout]
   set_property name ls_mezz_uart1_tx [get_bd_ports sout_0]

   #
   # Add the GPIO block for the LS mezzanine INT inputs and RST outputs
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_0/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]
   set_property -dict [list CONFIG.C_GPIO_WIDTH {2} CONFIG.C_GPIO2_WIDTH {2} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_0]
   make_bd_pins_external  [get_bd_pins axi_gpio_0/gpio_io_i]
   set_property name ls_mezz_int [get_bd_ports gpio_io_i_0]
   make_bd_pins_external  [get_bd_pins axi_gpio_0/gpio2_io_o]
   set_property name ls_mezz_rst [get_bd_ports gpio2_io_o_0]
   
   #
   # Add the GPIO block for the fan control
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_1/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_1/S_AXI]
   set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_IS_DUAL {0} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_DOUT_DEFAULT {0x00000001}] [get_bd_cells axi_gpio_1]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_1/GPIO]
   set_property name fan_pwm [get_bd_intf_ports GPIO_0]

   #
   # Add the GPIO block for the WiFi and BT LEDs
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_2/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_2/S_AXI]
   set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_GPIO2_WIDTH {1} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_2]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_2/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_2/GPIO2]
   set_property name wifi_en_led [get_bd_intf_ports GPIO_0]
   set_property name bt_en_led [get_bd_intf_ports GPIO2_0]

   #
   # Add the PWM IP blocks
   #
   
   create_bd_cell -type ip -vlnv avnet.com:ip:PWM_w_Int:1.0 PWM_w_Int_0
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/PWM_w_Int_0/s00_axi} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins PWM_w_Int_0/s00_axi]
   make_bd_pins_external  [get_bd_pins PWM_w_Int_0/PWM_out]
   set_property name ls_mezz_pwm0 [get_bd_ports PWM_out_0]

   create_bd_cell -type ip -vlnv avnet.com:ip:PWM_w_Int:1.0 PWM_w_Int_1
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/PWM_w_Int_1/s00_axi} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins PWM_w_Int_1/s00_axi]
   make_bd_pins_external  [get_bd_pins PWM_w_Int_1/PWM_out]
   set_property name ls_mezz_pwm1 [get_bd_ports PWM_out_0]

   #
   # Add the System Management Wizard 
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/system_management_wiz_0/S_AXI_LITE} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE]
   set_property -dict [ list CONFIG.CHANNEL_ENABLE_VP_VN {false} CONFIG.ENABLE_VCCPSAUX_ALARM {false} CONFIG.ENABLE_VCCPSINTFP_ALARM {false} CONFIG.ENABLE_VCCPSINTLP_ALARM {false} CONFIG.OT_ALARM {false} CONFIG.USER_TEMP_ALARM {false} CONFIG.VCCAUX_ALARM {false} CONFIG.VCCINT_ALARM {false} ] [get_bd_cells system_management_wiz_0]
   
   #
   # Add the Concat block for the interrupts
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   set_property -dict [list CONFIG.NUM_PORTS {5}] [get_bd_cells xlconcat_0]
   
   save_bd_design
   
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   connect_bd_net [get_bd_pins axi_uart16550_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins axi_uart16550_1/ip2intc_irpt] [get_bd_pins xlconcat_0/In1]
   connect_bd_net [get_bd_pins PWM_w_Int_0/Interrupt_Out] [get_bd_pins xlconcat_0/In2]
   connect_bd_net [get_bd_pins PWM_w_Int_1/Interrupt_Out] [get_bd_pins xlconcat_0/In3]
   connect_bd_net [get_bd_ports ls_mezz_int] [get_bd_pins xlconcat_0/In4]
   
   #
   # Connect the UART modem signals for PS UART0 (Bluetooth UART)
   #
   
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_ctsn]
   set_property name bt_ctsn [get_bd_ports emio_uart0_ctsn_0]
   
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_rtsn]
   set_property name bt_rtsn [get_bd_ports emio_uart0_rtsn_0]

   #
   # Add XLSLICE blocks to carve the 30 bits of PS EMIO GPIO into smaller chunks
   # Add XLSLICE 0 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {28} CONFIG.DIN_FROM {29} CONFIG.DOUT_WIDTH {2}] [get_bd_cells xlslice_0]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_0/Din]
   make_bd_pins_external  [get_bd_pins xlslice_0/Dout]
   set_property name hs_mezz_csi0_c [get_bd_ports Dout_0]

   #
   # Add XLSLICE 1 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {20} CONFIG.DIN_FROM {27} CONFIG.DOUT_WIDTH {8}] [get_bd_cells xlslice_1]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_1/Din]
   make_bd_pins_external  [get_bd_pins xlslice_1/Dout]
   set_property name hs_mezz_csi0_d [get_bd_ports Dout_0]

   #
   # Add XLSLICE 2 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {18} CONFIG.DIN_FROM {19} CONFIG.DOUT_WIDTH {2}] [get_bd_cells xlslice_2]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_2/Din]
   make_bd_pins_external  [get_bd_pins xlslice_2/Dout]
   set_property name hs_mezz_csi1_c [get_bd_ports Dout_0]

   #
   # Add XLSLICE 3 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {14} CONFIG.DIN_FROM {17} CONFIG.DOUT_WIDTH {4}] [get_bd_cells xlslice_3]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_3/Din]
   make_bd_pins_external  [get_bd_pins xlslice_3/Dout]
   set_property name hs_mezz_csi1_d [get_bd_ports Dout_0]

   #
   # Add XLSLICE 4 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {13} CONFIG.DIN_FROM {13} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_4]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_4/Din]
   make_bd_pins_external  [get_bd_pins xlslice_4/Dout]
   set_property name hs_mezz_csi0_mclk [get_bd_ports Dout_0]

   #
   # Add XLSLICE 5 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {12} CONFIG.DIN_FROM {12} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_5]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_5/Din]
   make_bd_pins_external  [get_bd_pins xlslice_5/Dout]
   set_property name hs_mezz_csi1_mclk [get_bd_ports Dout_0]

   #
   # Add XLSLICE 6 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {10} CONFIG.DIN_FROM {11} CONFIG.DOUT_WIDTH {2}] [get_bd_cells xlslice_6]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_6/Din]
   make_bd_pins_external  [get_bd_pins xlslice_6/Dout]
   set_property name hs_mezz_dsi_clk [get_bd_ports Dout_0]

   #
   # Add XLSLICE 7 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {2} CONFIG.DIN_FROM {9} CONFIG.DOUT_WIDTH {8}] [get_bd_cells xlslice_7]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_7/Din]
   make_bd_pins_external  [get_bd_pins xlslice_7/Dout]
   set_property name hs_mezz_dsi_d [get_bd_ports Dout_0]

   #
   # Add XLSLICE 8 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {1} CONFIG.DIN_FROM {1} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_8]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_8/Din]
   make_bd_pins_external  [get_bd_pins xlslice_8/Dout]
   set_property name hs_mezz_hsic_str [get_bd_ports Dout_0]

   #
   # Add XLSLICE 9 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {0} CONFIG.DIN_FROM {0} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_9]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_9/Din]
   make_bd_pins_external  [get_bd_pins xlslice_9/Dout]
   set_property name hs_mezz_hsic_d [get_bd_ports Dout_0]


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
   
   # MIO25 is used as GPIO for USB Vbus detect.  Change to pullup instead of default pulldown
   
   set_property -dict [list CONFIG.PSU_MIO_25_PULLUPDOWN {pullup}] [get_bd_cells zynq_ultra_ps_e_0]
   
   # Add the modem flow control pins to PSU UART0 (Bluetooth UART)
   
   set_property -dict [list CONFIG.PSU__UART0__MODEM__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
   #connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   
   # Set PMU GPO2 (connected to on/off controller KILL_N signal) initial state to '1'
   
   set_property -dict [list CONFIG.PSU__PMU__GPO2__POLARITY {high}] [get_bd_cells zynq_ultra_ps_e_0]
   
   # Enable the EMIO GPIO and set the width to 30 bits
   
   set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {30}] [get_bd_cells zynq_ultra_ps_e_0]
      
   # Enable the SS1 and SS2 slave select signals for the PS SPI0 peripehral
   set_property -dict [list CONFIG.PSU__SPI0__GRP_SS1__ENABLE {1} CONFIG.PSU__SPI0__GRP_SS2__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   
}

proc avnet_add_sdsoc_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   #set_property PFM_NAME "em.avnet.com:av:${design_name}:1.0" [get_files ./${design_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd]
   set_property PFM_NAME "avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]


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
  assign_bd_address -offset 0xA0090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  
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
   set_property platform.description                   "Base Ultra96-V2 development platform" [current_project]
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

