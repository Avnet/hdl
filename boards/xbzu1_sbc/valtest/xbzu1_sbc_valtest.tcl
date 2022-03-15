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

   create_project $project $projects_folder -part xczu1cg-sbva484-1-e -force
}

proc avnet_import_constraints {boards_folder board project} {

   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
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
      CONFIG.C_SIZE {3} \
   ] [get_bd_cells util_vector_logic_0]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1
   set_property -dict [list \
      CONFIG.C_OPERATION {and} \
      CONFIG.LOGO_FILE {data/sym_andgate.png} \
      CONFIG.C_SIZE {3} \
   ] [get_bd_cells util_vector_logic_1]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2
   set_property -dict [list \
      CONFIG.C_OPERATION {or} \
      CONFIG.LOGO_FILE {data/sym_orgate.png} \
      CONFIG.C_SIZE {3} \
   ] [get_bd_cells util_vector_logic_2]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3
   set_property -dict [list \
      CONFIG.C_OPERATION {not} \
      CONFIG.LOGO_FILE {data/sym_notgate.png} \
      CONFIG.C_SIZE {3} \
      ] [get_bd_cells util_vector_logic_3]
   
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
   
   create_bd_pin -dir I -from 0 -to 0 In1
   create_bd_pin -dir I -from 0 -to 0 In2_B
   create_bd_pin -dir O -from 0 -to 0 Or_out
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
      CONFIG.C_SIZE {1} \
      CONFIG.C_OPERATION {or} \
      CONFIG.LOGO_FILE {data/sym_orgate.png}
   ] [get_bd_cells util_vector_logic_0]
   
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1
   set_property -dict [list \
      CONFIG.C_OPERATION {not} \
      CONFIG.LOGO_FILE {data/sym_notgate.png} \
      CONFIG.C_SIZE {1} \
   ] [get_bd_cells util_vector_logic_1]
   

   connect_bd_net [get_bd_pins In1] [get_bd_pins util_vector_logic_0/Op1]
   connect_bd_net [get_bd_pins In2_B] [get_bd_pins util_vector_logic_1/Op1]
   connect_bd_net [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_0/Op2]
   
   connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins Or_out]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
   set_property -dict [list CONFIG.NUM_MI {4}] [get_bd_cells axi_interconnect_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0

   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   #~ set_property -dict [list CONFIG.NUM_PORTS {5}] [get_bd_cells xlconcat_0]
   
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
   save_bd_design

   #
   # RGB LED 0
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {3} \
      CONFIG.C_ALL_INPUTS {0} \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_GPIO2_WIDTH {1} \
      CONFIG.C_ALL_OUTPUTS_2 {1} \
      CONFIG.C_DOUT_DEFAULT_2 {0x00000000}] [get_bd_cells axi_gpio_0]
   save_bd_design

   #
   # RGB LED 1
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {3} \
      CONFIG.C_ALL_INPUTS {0} \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_GPIO2_WIDTH {1} \
      CONFIG.C_ALL_OUTPUTS_2 {1} \
      CONFIG.C_DOUT_DEFAULT_2 {0x00000000}] [get_bd_cells axi_gpio_1]
   save_bd_design

   #~ #
   #~ # Click PWM
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2
   #~ set_property -dict [list CONFIG.C_GPIO_WIDTH {1}] [get_bd_cells axi_gpio_2]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_2/GPIO]
   #~ set_property name click_pwm [get_bd_intf_ports GPIO_0]
   #~ save_bd_design

   #~ #
   #~ # Syzygy TRX2 (MIO) loopback
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3
   #~ set_property -dict [list \
      #~ CONFIG.C_GPIO_WIDTH {2} \
      #~ CONFIG.C_GPIO2_WIDTH {2} \
      #~ CONFIG.C_IS_DUAL {1} \
      #~ CONFIG.C_ALL_INPUTS_2 {1} \
      #~ CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_3]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_3/GPIO]
   #~ set_property name syzygy_trx2_mio_out [get_bd_intf_ports GPIO_0]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_3/GPIO2]
   #~ set_property name syzygy_trx2_mio_in [get_bd_intf_ports GPIO2_0]
   #~ save_bd_design

   #~ #
   #~ # Syzygy TRX2 (PL) loopback
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_4
   #~ set_property -dict [list \
      #~ CONFIG.C_GPIO_WIDTH {10} \
      #~ CONFIG.C_GPIO2_WIDTH {12} \
      #~ CONFIG.C_IS_DUAL {1} \
      #~ CONFIG.C_ALL_INPUTS_2 {1} \
      #~ CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_4]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_4/GPIO]
   #~ set_property name syzygy_trx2_pl_out [get_bd_intf_ports GPIO_0]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_4/GPIO2]
   #~ set_property name syzygy_trx2_pl_in [get_bd_intf_ports GPIO2_0]
   #~ save_bd_design

   #~ #
   #~ # Syzygy STD (PL) loopback
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_5
   #~ set_property -dict [list \
      #~ CONFIG.C_GPIO_WIDTH {9} \
      #~ CONFIG.C_GPIO2_WIDTH {11} \
      #~ CONFIG.C_IS_DUAL {1} \
      #~ CONFIG.C_ALL_INPUTS_2 {1} \
      #~ CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_5]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_5/GPIO]
   #~ set_property name syzygy_std_out [get_bd_intf_ports GPIO_0]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_5/GPIO2]
   #~ set_property name syzygy_std_in [get_bd_intf_ports GPIO2_0]
   #~ save_bd_design

   #~ #
   #~ # Syzygy I2C
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_iic_0/IIC]
   #~ set_property name syzygy_i2c [get_bd_intf_ports IIC_0]

   #~ #
   #~ # Click I2C
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_1
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_iic_1/IIC]
   #~ set_property name click_i2c [get_bd_intf_ports IIC_0]

   #~ #
   #~ # Temperature sensor
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_2
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_iic_2/IIC]
   #~ set_property name temp_sensor [get_bd_intf_ports IIC_0]

   #~ #
   #~ # Click SPI
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0
   #~ set_property -dict [list CONFIG.C_NUM_SS_BITS {2}] [get_bd_cells axi_quad_spi_0]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_quad_spi_0/SPI_0]
   #~ set_property name click_spi [get_bd_intf_ports SPI_0_0]

   #~ #
   #~ # Click UART (115200,n,8,1)
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
   #~ set_property -dict [list CONFIG.C_BAUDRATE {115200}] [get_bd_cells axi_uartlite_0]
   #~ make_bd_intf_pins_external  [get_bd_intf_pins axi_uartlite_0/UART]
   #~ set_property name click_uart [get_bd_intf_ports UART_0]

   #~ #
   #~ # Click interrupt
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0
   #~ save_bd_design

   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1
   #~ save_bd_design

   #
   # Binary counter to toggle RGB LED colors
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0
   set_property -dict [list \
   CONFIG.Output_Width {30} \
   CONFIG.SCLR {true}] [get_bd_cells c_counter_binary_0]
   save_bd_design

   #
   # Slice off upper bits of binary counter
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
   set_property -dict [list \
      CONFIG.DIN_TO {27} \
      CONFIG.DIN_FROM {29} \
      CONFIG.DIN_WIDTH {30} \
      CONFIG.DOUT_WIDTH {3}] [get_bd_cells xlslice_0]
   save_bd_design

   #
   # RGB LED output either counter bits OR GPIO (axi_gpio_0)
   #
   create_hier_cell_mux2to1 [current_bd_instance .] mux2to1_0
   save_bd_design

   #
   # RGB LED output either counter bits OR GPIO (axi_gpio_1)
   #
   create_hier_cell_mux2to1 [current_bd_instance .] mux2to1_1
   save_bd_design

   #
   # Mux Sel either GPIO OR inverted PB input (mux2to1_0)
   #
   create_hier_cell_or2b1 [current_bd_instance .] or2b1_0
   save_bd_design

   #
   # Mux Sel either GPIO OR inverted PB input (mux2to1_1)
   #
   create_hier_cell_or2b1 [current_bd_instance .] or2b1_1
   save_bd_design

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {1} \
      CONFIG.C_ALL_INPUTS {1}
   ] [get_bd_cells axi_gpio_2]
   
   save_bd_design

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
   #~ connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]

   connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI]
   save_bd_design

   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins axi_gpio_1/S_AXI]
   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins axi_gpio_2/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axi_gpio_3/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins axi_gpio_4/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins axi_gpio_5/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins axi_gpio_6/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins axi_iic_0/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M08_AXI] [get_bd_intf_pins axi_iic_1/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M09_AXI] [get_bd_intf_pins axi_iic_2/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M10_AXI] [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M11_AXI] [get_bd_intf_pins axi_uart16550_0/S_AXI]
   #~ connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M12_AXI] [get_bd_intf_pins axi_intc_0/s_axi]
   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE]
   #~ save_bd_design

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/ACLK]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/S00_ACLK]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M00_ACLK]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M01_ACLK]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M02_ACLK]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M03_ACLK]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M04_ACLK]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M05_ACLK]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M06_ACLK]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M07_ACLK]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M08_ACLK]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M09_ACLK]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M10_ACLK]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_interconnect_0/M11_ACLK]
   
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M01_ARESETN]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M02_ARESETN]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M03_ARESETN]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M04_ARESETN]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M05_ARESETN]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M06_ARESETN]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M07_ARESETN]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M08_ARESETN]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M09_ARESETN]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M10_ARESETN]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_interconnect_0/M11_ARESETN]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_gpio_0/s_axi_aclk]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_gpio_1/s_axi_aclk]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_gpio_2/s_axi_aclk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_gpio_3/s_axi_aclk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_gpio_4/s_axi_aclk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_iic_0/s_axi_aclk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_iic_1/s_axi_aclk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_iic_2/s_axi_aclk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_quad_spi_0/s_axi_aclk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_quad_spi_0/ext_spi_clk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_uartlite_0/s_axi_aclk]
   #~ connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_intc_0/s_axi_aclk]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins c_counter_binary_0/CLK]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins system_management_wiz_0/s_axi_aclk]

   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_gpio_3/s_axi_aresetn]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_gpio_4/s_axi_aresetn]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_iic_2/s_axi_aresetn]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_quad_spi_0/s_axi_aresetn]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn]
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins system_management_wiz_0/s_axi_aresetn]

   #~ connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In0]
   #~ connect_bd_net [get_bd_pins axi_iic_1/iic2intc_irpt] [get_bd_pins xlconcat_0/In1]
   #~ connect_bd_net [get_bd_pins axi_iic_2/iic2intc_irpt] [get_bd_pins xlconcat_0/In2]
   #~ connect_bd_net [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In3]
   #~ connect_bd_net [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins xlconcat_0/In4]

   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins c_counter_binary_0/SCLR]
   
   #~ connect_bd_net [get_bd_pins xlconcat_1/dout] [get_bd_pins axi_intc_0/intr]

   #~ connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1]
   #~ create_bd_port -dir I -type intr click_int
   #~ connect_bd_net [get_bd_ports click_int] [get_bd_pins xlconcat_1/In0]

   #~ create_bd_port -dir O -type rst click_rst
   #~ connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_ports click_rst] 

   connect_bd_net [get_bd_pins c_counter_binary_0/Q] [get_bd_pins xlslice_0/Din]

   create_bd_port -dir O -from 2 -to 0 -type data rgb_led_0
   create_bd_port -dir O -from 2 -to 0 -type data rgb_led_1

   connect_bd_net [get_bd_pins xlslice_0/Dout] [get_bd_pins mux2to1_0/In1]
   connect_bd_net [get_bd_pins xlslice_0/Dout] [get_bd_pins mux2to1_1/In1]
   
   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins mux2to1_0/In2]
   connect_bd_net [get_bd_pins axi_gpio_1/gpio_io_o] [get_bd_pins mux2to1_1/In2]

   connect_bd_net [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins or2b1_0/In1]
   connect_bd_net [get_bd_pins axi_gpio_1/gpio2_io_o] [get_bd_pins or2b1_1/In1]
   
   connect_bd_net [get_bd_pins or2b1_0/Or_out] [get_bd_pins mux2to1_0/Sel]
   connect_bd_net [get_bd_pins or2b1_1/Or_out] [get_bd_pins mux2to1_1/Sel]

   create_bd_port -dir I -type data push_button_1bit
   connect_bd_net [get_bd_ports push_button_1bit] [get_bd_pins axi_gpio_2/gpio_io_i]

   connect_bd_net [get_bd_ports push_button_1bit] [get_bd_pins or2b1_0/In2_B]
   connect_bd_net [get_bd_ports push_button_1bit] [get_bd_pins or2b1_1/In2_B]
   
   connect_bd_net [get_bd_pins mux2to1_0/Mux_out] [get_bd_ports rgb_led_0]
   connect_bd_net [get_bd_pins mux2to1_1/Mux_out] [get_bd_ports rgb_led_1]

   regenerate_bd_layout
   save_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]
   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]

   set_property -dict [list \
      CONFIG.PSU__USE__M_AXI_GP0 {1} \
      CONFIG.PSU__USE__M_AXI_GP1 {0} \
      CONFIG.PSU__USE__IRQ0 {0} \
      CONFIG.PSU__USE__IRQ1 {0} \
   ] [get_bd_cells zynq_ultra_ps_e_0]
      

   # Set PMU GPO2 (connected to on/off controller KILL_N signal) initial state to '1'
   set_property -dict [list CONFIG.PSU__PMU__GPO2__POLARITY {high}] [get_bd_cells zynq_ultra_ps_e_0]
   
   # Enable the EMIO GPIO and set the width to 30 bits
   set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {30}] [get_bd_cells zynq_ultra_ps_e_0]
      
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]

   save_bd_design
}

proc avnet_assign_addresses {project projects_folder scriptdir} {
   # Unassign all address segments
   delete_bd_objs [get_bd_addr_segs]
   delete_bd_objs [get_bd_addr_segs -excluded]

   # Hard-code specific address segments (used in device-tree or applications)
   #assign_bd_address -offset 0xA0090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  
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

