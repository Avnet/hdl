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
#  Design Name:         ZUBoard-1CG Base HW Platform
#  Module Name:         zub1cg_sbc_base.tcl
#  Project Name:        ZUBoard-1CG Base
#  Target Devices:      Xilinx Zynq UltraScale+ 1CG
#  Hardware Boards:     ZUBoard-1CG Board
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu1cg-sbva484-1-e -force
}

proc avnet_import_constraints {boards_folder board project} {

   set bdf_path [file normalize [pwd]/../../bdf]
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
   import_files -fileset constrs_1 -norecurse ${bdf_path}/zub1cg/1.0/ZUBoard_temp.xdc
}

proc create_hier_cell_mux2to1 { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux2to1() - Empty argument(s)!"}
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
   create_bd_pin -dir I -from 2 -to 0 In1
   create_bd_pin -dir I -from 2 -to 0 In2
   create_bd_pin -dir I Sel
   create_bd_pin -dir O -from 2 -to 0 Mux_out
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
      CONFIG.C_OPERATION {and} \
      CONFIG.LOGO_FILE {data/sym_andgate.png} \
      CONFIG.C_SIZE {3}] [get_bd_cells util_vector_logic_0]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1
   set_property -dict [list \
      CONFIG.C_OPERATION {and} \
      CONFIG.LOGO_FILE {data/sym_andgate.png} \
      CONFIG.C_SIZE {3}] [get_bd_cells util_vector_logic_1]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2
   set_property -dict [list \
      CONFIG.C_OPERATION {or} \
      CONFIG.LOGO_FILE {data/sym_orgate.png} \
      CONFIG.C_SIZE {3}] [get_bd_cells util_vector_logic_2]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3
   set_property -dict [list \
      CONFIG.C_OPERATION {not} \
      CONFIG.LOGO_FILE {data/sym_notgate.png} \
      CONFIG.C_SIZE {3}] [get_bd_cells util_vector_logic_3]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   set_property -dict [list CONFIG.NUM_PORTS {3}] [get_bd_cells xlconcat_0]
   
   connect_bd_net [get_bd_pins Sel] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins Sel] [get_bd_pins xlconcat_0/In1]
   connect_bd_net [get_bd_pins Sel] [get_bd_pins xlconcat_0/In2]
   
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins util_vector_logic_3/Op1]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins util_vector_logic_1/Op2]
   
   connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_2/Op1]
   connect_bd_net [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_2/Op2]
   connect_bd_net [get_bd_pins util_vector_logic_3/Res] [get_bd_pins util_vector_logic_0/Op2]
   
   connect_bd_net [get_bd_pins In1] [get_bd_pins util_vector_logic_0/Op1]
   connect_bd_net [get_bd_pins In2] [get_bd_pins util_vector_logic_1/Op1]
   connect_bd_net [get_bd_pins util_vector_logic_2/Res] [get_bd_pins Mux_out]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

proc create_hier_cell_or2b1 { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_or2b1() - Empty argument(s)!"}
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
   
   create_bd_pin -dir I -from 0 -to 0 In1
   create_bd_pin -dir I -from 0 -to 0 In2_B
   create_bd_pin -dir O -from 0 -to 0 Or_out
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
      CONFIG.C_SIZE {1} \
      CONFIG.C_OPERATION {or} \
      CONFIG.LOGO_FILE {data/sym_orgate.png}] [get_bd_cells util_vector_logic_0]
   
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1
   set_property -dict [list \
      CONFIG.C_OPERATION {not} \
      CONFIG.LOGO_FILE {data/sym_notgate.png} \
      CONFIG.C_SIZE {1}] [get_bd_cells util_vector_logic_1]
   

   connect_bd_net [get_bd_pins In1] [get_bd_pins util_vector_logic_0/Op1]
   connect_bd_net [get_bd_pins In2_B] [get_bd_pins util_vector_logic_1/Op1]
   connect_bd_net [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_0/Op2]
   
   connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins Or_out]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

proc create_hier_cell_or2 { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_or2() - Empty argument(s)!"}
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
   create_bd_pin -dir I -from 0 -to 0 In1
   create_bd_pin -dir I -from 0 -to 0 In2
   create_bd_pin -dir O -from 0 -to 0 Or_out
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
      CONFIG.C_SIZE {1} \
      CONFIG.C_OPERATION {or} \
      CONFIG.LOGO_FILE {data/sym_orgate.png}] [get_bd_cells util_vector_logic_0]
   
   connect_bd_net [get_bd_pins In1] [get_bd_pins util_vector_logic_0/Op1]
   connect_bd_net [get_bd_pins In2] [get_bd_pins util_vector_logic_0/Op2]
   connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins Or_out]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
   set_property -dict [list CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0

   connect_bd_net [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   connect_bd_net [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]

   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   set_property -dict [list CONFIG.NUM_PORTS {5}] [get_bd_cells xlconcat_0]
   
   #
   # System monitor
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0
   set_property -dict [list \
      CONFIG.CHANNEL_ENABLE_VP_VN {false} \
      CONFIG.ENABLE_VCCPSAUX_ALARM {false} \
      CONFIG.ENABLE_VCCPSINTFP_ALARM {false} \
      CONFIG.ENABLE_VCCPSINTLP_ALARM {false} \
      CONFIG.OT_ALARM {false} \
      CONFIG.USER_TEMP_ALARM {false} \
      CONFIG.VCCAUX_ALARM {false} \
      CONFIG.VCCINT_ALARM {false}] [get_bd_cells system_management_wiz_0]
   save_bd_design

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
   # RGB LED 0
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {3} \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_DOUT_DEFAULT {0x00000000} \
      CONFIG.C_IS_DUAL {0}] [get_bd_cells axi_gpio_0]
   make_bd_intf_pins_external [get_bd_intf_pins axi_gpio_0/GPIO]
   set_property name rgb_led_0 [get_bd_intf_ports GPIO_0]
   save_bd_design

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_gpio_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]
   save_bd_design

   #
   # RGB LED 1
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {3} \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_DOUT_DEFAULT {0x00000000} \
      CONFIG.C_IS_DUAL {0}] [get_bd_cells axi_gpio_1]
   make_bd_intf_pins_external [get_bd_intf_pins axi_gpio_1/GPIO]
   set_property name rgb_led_1 [get_bd_intf_ports GPIO_0]
   save_bd_design

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_gpio_1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}}  [get_bd_intf_pins axi_gpio_1/S_AXI]
   save_bd_design

   #
   # PL PB switch input
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {1} \
      CONFIG.C_ALL_INPUTS {1} \
      CONFIG.C_IS_DUAL {0}] [get_bd_cells axi_gpio_2]
   make_bd_intf_pins_external [get_bd_intf_pins axi_gpio_2/GPIO]
   set_property name pl_pb [get_bd_intf_ports GPIO_0]
   save_bd_design

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_gpio_2/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}}  [get_bd_intf_pins axi_gpio_2/S_AXI]

   #
   # Temperature sensor IIC from BDF
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0
   apply_board_connection -board_interface "tempsensor_i2c_pl" -ip_intf "axi_iic_0/IIC" -diagram "${project}"
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_iic_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}} [get_bd_intf_pins axi_iic_0/S_AXI]
   save_bd_design

   #
   # HSIO DNA IIC from BDF
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_1
   apply_board_connection -board_interface "hsio_dna_i2c_pl" -ip_intf "axi_iic_1/IIC" -diagram "${project}"
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_iic_1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}} [get_bd_intf_pins axi_iic_1/S_AXI]
   save_bd_design

   #
   # Click IIC from BDF
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_2
   apply_board_connection -board_interface "click_i2c_pl" -ip_intf "axi_iic_2/IIC" -diagram "${project}"
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_iic_2/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}} [get_bd_intf_pins axi_iic_2/S_AXI]
   save_bd_design

   #
   # Click SPI from BDF
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0
   apply_board_connection -board_interface "click_spi_pl" -ip_intf "axi_quad_spi_0/SPI_0" -diagram "${project}"
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_quad_spi_0/AXI_LITE} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}} [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_quad_spi_0/ext_spi_clk]
   save_bd_design

   #
   # Click UART from BDF
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
   apply_board_connection -board_interface "click_uart_pl" -ip_intf "axi_uartlite_0/UART" -diagram "${project}"
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_uartlite_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}} [get_bd_intf_pins axi_uartlite_0/S_AXI]
   set_property -dict [list CONFIG.C_BAUDRATE {115200}] [get_bd_cells axi_uartlite_0]
   save_bd_design

   #
   # Connect the remaining nets and ports
   #
   connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI]
   
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins axi_iic_1/iic2intc_irpt] [get_bd_pins xlconcat_0/In1]
   connect_bd_net [get_bd_pins axi_iic_2/iic2intc_irpt] [get_bd_pins xlconcat_0/In2]
   connect_bd_net [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins xlconcat_0/In3]
   connect_bd_net [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In4]

   #
   # VITIS ADDITIONS - START
   #  

   # Disable M_AXI_HPM1_FPD (keep available to VITIS for control interface)
   set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {0}] [get_bd_cells zynq_ultra_ps_e_0]

   # Add AXI interrupt controller (for VITIS XRT interrupt support)
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_intc_0/s_axi} \
      ddr_seg {Auto} \
      intc_ip {/axi_interconnect_0} \
      master_apm {0}}  [get_bd_intf_pins axi_intc_0/s_axi]

   # Set IRQ type to 'EDGE' and connection to 'SINGLE'
   set_property -dict [ list \
      CONFIG.C_IRQ_IS_LEVEL {0} \
      CONFIG.C_IRQ_CONNECTION {1}] [get_bd_cells axi_intc_0]

   set_property -dict [list CONFIG.NUM_PORTS {6}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/In5] [get_bd_pins axi_intc_0/irq]

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
      CONFIG.RESET_TYPE {ACTIVE_LOW}] [get_bd_cells clk_wiz_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_4
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_5
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_6
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_7

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins clk_wiz_0/clk_in1]

   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins proc_sys_reset_4/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out5 [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins proc_sys_reset_5/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out6 [get_bd_pins clk_wiz_0/clk_out6] [get_bd_pins proc_sys_reset_6/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out7 [get_bd_pins clk_wiz_0/clk_out7] [get_bd_pins proc_sys_reset_7/slowest_sync_clk]

   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] \
      [get_bd_pins proc_sys_reset_1/dcm_locked] \
      [get_bd_pins proc_sys_reset_2/dcm_locked] \
      [get_bd_pins proc_sys_reset_3/dcm_locked] \
      [get_bd_pins proc_sys_reset_4/dcm_locked] \
      [get_bd_pins proc_sys_reset_5/dcm_locked] \
      [get_bd_pins proc_sys_reset_6/dcm_locked] \
      [get_bd_pins proc_sys_reset_7/dcm_locked]

   connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] \
      [get_bd_pins clk_wiz_0/resetn] \
      [get_bd_pins proc_sys_reset_1/ext_reset_in] \
      [get_bd_pins proc_sys_reset_2/ext_reset_in] \
      [get_bd_pins proc_sys_reset_3/ext_reset_in] \
      [get_bd_pins proc_sys_reset_4/ext_reset_in] \
      [get_bd_pins proc_sys_reset_5/ext_reset_in] \
      [get_bd_pins proc_sys_reset_6/ext_reset_in] \
      [get_bd_pins proc_sys_reset_7/ext_reset_in]

   #
   # VITIS ADDITIONS - END
   #

   regenerate_bd_layout
   save_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]
   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]

   set_property -dict [list \
      CONFIG.PSU__USE__M_AXI_GP0 {1} \
      CONFIG.PSU__USE__M_AXI_GP1 {0} \
      CONFIG.PSU__USE__IRQ0 {0} \
      CONFIG.PSU__USE__IRQ1 {0}] [get_bd_cells zynq_ultra_ps_e_0]
      

   # Set PMU GPO2 (connected to on/off controller KILL_N signal) initial state to '1'
   set_property -dict [list CONFIG.PSU__PMU__GPO2__POLARITY {high}] [get_bd_cells zynq_ultra_ps_e_0]
   
   # Enable the PL-to-PS IRQ port
   set_property -dict [list CONFIG.PSU__USE__IRQ0 {1}] [get_bd_cells zynq_ultra_ps_e_0]
   
   # Pull up the MIO12_ETH_RST_N (default is pulldown in the BDF, but this is not working)
   set_property -dict [list CONFIG.PSU_MIO_12_PULLUPDOWN {pullup}] [get_bd_cells zynq_ultra_ps_e_0]
      
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
   # axi_gpio_0
   assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force

   # axi_gpio_1
   assign_bd_address -offset 0xA0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] -force

   # axi_gpio_2
   assign_bd_address -offset 0xA0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_2/S_AXI/Reg] -force
  
   assign_bd_address
}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   set_property PFM_NAME "avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

   # define clock and reset ports
   set_property PFM.CLOCK { \
	clk_out1 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_1" status "fixed"} \
	clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_2" status "fixed"} \
	clk_out3 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_3" status "fixed"} \
	clk_out4 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_4" status "fixed"} \
	clk_out5 {id "4" is_default "false" proc_sys_reset "/proc_sys_reset_5" status "fixed"} \
	clk_out6 {id "5" is_default "false" proc_sys_reset "/proc_sys_reset_6" status "fixed"} \
	clk_out7 {id "6" is_default "false" proc_sys_reset "/proc_sys_reset_7" status "fixed"} \
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
   set_property platform.description                   "Base ZUB1CG development platform" [current_project]
   set_property platform.uses_pr                       false         [current_project]

   set_property platform.design_intent.server_managed  "false" [current_project]
   set_property platform.design_intent.external_host   "false" [current_project]
   set_property platform.design_intent.embedded        "true" [current_project]
   set_property platform.design_intent.datacenter      "false" [current_proj]

   set_property platform.vendor                        "avnet.com" [current_project]
   set_property platform.board_id                      ${project} [current_project]
   set_property platform.name                          ${design_name} [current_project]
   set_property platform.version                       "1.0" [current_project]
   set_property platform.platform_state                "pre_synth" [current_project]
   set_property platform.ip_cache_dir                  [get_property ip_output_repo [current_project]] [current_project]

   # recommnded to use "sd_card" for Vitis 2020.1 onwards
   # reference : https://github.com/Xilinx/Vitis_Embedded_Platform_Source/blob/2020.1/Xilinx_Official_Platforms/zcu104_base/vivado/xilinx_zcu104_base_202010_1_xsa.tcl
   #set_property platform.default_output_type           "xclbin" [current_project]
   set_property platform.default_output_type           "sd_card" [current_project]

   set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
   set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
   set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
}

