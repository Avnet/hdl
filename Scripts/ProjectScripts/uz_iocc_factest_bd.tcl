
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# Creating design if needed
set errMsg ""
set nRet 0

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create interface ports
  set dip_switches_8bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 dip_switches_8bits ]
  set led_8bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_8bits ]
  set push_buttons_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_buttons_4bits ]
  set inputs_from_pmods_1_8 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 inputs_from_pmods_1_8 ]
  set outputs_to_pmods_1_8 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 outputs_to_pmods_1_8 ]
  set inputs_from_pmods_9_12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 inputs_from_pmods_9_12 ]
  set outputs_to_pmods_9_12 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 outputs_to_pmods_9_12 ]
  set inputs_from_jx1_jx2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 inputs_from_jx1_jx2 ]
  set outputs_to_jx1_jx2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 outputs_to_jx1_jx2 ]
  set inputs_from_arduino [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 inputs_from_arduino ]
  set outputs_to_arduino [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 outputs_to_arduino ]
  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]
  
  # Create instance: axi_gpio_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] [get_bd_cells xlconstant_0]
  
  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO_WIDTH {8} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {8} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_1

  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
  set_property -dict [ list CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO_WIDTH {4} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_2

  # Create instance: axi_gpio_3, and set properties
  set axi_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO2_WIDTH {32} CONFIG.C_GPIO_WIDTH {32} CONFIG.C_IS_DUAL {1} CONFIG.GPIO2_BOARD_INTERFACE {Custom} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_3

  # Create instance: axi_gpio_4, and set properties
  set axi_gpio_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_4 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO2_WIDTH {16} CONFIG.C_GPIO_WIDTH {16} CONFIG.C_IS_DUAL {1} CONFIG.GPIO2_BOARD_INTERFACE {Custom} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_4

  # Create instance: axi_gpio_5, and set properties
  set axi_gpio_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_5 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO2_WIDTH {13} CONFIG.C_GPIO_WIDTH {13} CONFIG.C_IS_DUAL {1} CONFIG.GPIO2_BOARD_INTERFACE {Custom} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_5

  # Create instance: axi_gpio_6, and set properties
  set axi_gpio_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_6 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO2_WIDTH {11} CONFIG.C_GPIO_WIDTH {11} CONFIG.C_IS_DUAL {1} CONFIG.GPIO2_BOARD_INTERFACE {Custom} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_6
  
  # Create instance: zynq_ultra_ps_e_0_axi_periph, and set properties
  set zynq_ultra_ps_e_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 zynq_ultra_ps_e_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {8}  ] $zynq_ultra_ps_e_0_axi_periph

  # Create instance: system_management_wiz_0, and set properties
  set system_management_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0 ]

  # Create instance: rst_zynq_ultra_ps_e_0_100M, and set properties
  set rst_zynq_ultra_ps_e_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_zynq_ultra_ps_e_0_100M ]
  
  # Create interface connections
  connect_bd_intf_net [get_bd_intf_ports dip_switches_8bits] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net [get_bd_intf_ports led_8bits] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net [get_bd_intf_ports push_buttons_4bits] [get_bd_intf_pins axi_gpio_2/GPIO]
  connect_bd_intf_net [get_bd_intf_ports inputs_from_pmods_1_8] [get_bd_intf_pins axi_gpio_3/GPIO]
  connect_bd_intf_net [get_bd_intf_ports outputs_to_pmods_1_8] [get_bd_intf_pins axi_gpio_3/GPIO2]
  connect_bd_intf_net [get_bd_intf_ports inputs_from_pmods_9_12] [get_bd_intf_pins axi_gpio_4/GPIO]
  connect_bd_intf_net [get_bd_intf_ports outputs_to_pmods_9_12] [get_bd_intf_pins axi_gpio_4/GPIO2]
  connect_bd_intf_net [get_bd_intf_ports inputs_from_jx1_jx2] [get_bd_intf_pins axi_gpio_5/GPIO]
  connect_bd_intf_net [get_bd_intf_ports outputs_to_jx1_jx2] [get_bd_intf_pins axi_gpio_5/GPIO2]
  connect_bd_intf_net [get_bd_intf_ports inputs_from_arduino] [get_bd_intf_pins axi_gpio_6/GPIO]
  connect_bd_intf_net [get_bd_intf_ports outputs_to_arduino] [get_bd_intf_pins axi_gpio_6/GPIO2]
  connect_bd_intf_net [get_bd_intf_ports Vp_Vn] [get_bd_intf_pins system_management_wiz_0/Vp_Vn]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M01_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M02_AXI [get_bd_intf_pins axi_gpio_2/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M03_AXI [get_bd_intf_pins axi_gpio_3/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M04_AXI [get_bd_intf_pins axi_gpio_4/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M05_AXI [get_bd_intf_pins axi_gpio_5/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M06_AXI [get_bd_intf_pins axi_gpio_6/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M07_AXI [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M07_AXI]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD]
  
  # Connect port connections
  connect_bd_net -net reset_rtl_1 [get_bd_pins xlconstant_0/dout] [get_bd_pins rst_zynq_ultra_ps_e_0_100M/ext_reset_in] 
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk] [get_bd_pins axi_gpio_3/s_axi_aclk] [get_bd_pins axi_gpio_4/s_axi_aclk] [get_bd_pins axi_gpio_5/s_axi_aclk] [get_bd_pins axi_gpio_6/s_axi_aclk] [get_bd_pins system_management_wiz_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M00_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M01_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M02_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M03_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M04_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M05_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M06_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M07_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/S00_ACLK] [get_bd_pins rst_zynq_ultra_ps_e_0_100M/slowest_sync_clk]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins zynq_ultra_ps_e_0_axi_periph/ARESETN] [get_bd_pins rst_zynq_ultra_ps_e_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn] [get_bd_pins axi_gpio_3/s_axi_aresetn] [get_bd_pins axi_gpio_4/s_axi_aresetn] [get_bd_pins axi_gpio_5/s_axi_aresetn] [get_bd_pins axi_gpio_6/s_axi_aresetn] [get_bd_pins system_management_wiz_0/s_axi_aresetn] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M00_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M01_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M02_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M03_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M04_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M05_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M06_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M07_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/S00_ARESETN] [get_bd_pins rst_zynq_ultra_ps_e_0_100M/peripheral_aresetn]
  
  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x0080000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x0080010000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x0080020000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_2/S_AXI/Reg] SEG_axi_gpio_2_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x0080030000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_3/S_AXI/Reg] SEG_axi_gpio_3_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x0080040000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_4/S_AXI/Reg] SEG_axi_gpio_4_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x0080050000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_5/S_AXI/Reg] SEG_axi_gpio_5_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x0080060000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_6/S_AXI/Reg] SEG_axi_gpio_6_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x0080070000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs system_management_wiz_0/S_AXI_LITE/Reg] SEG_system_management_wiz_0_Reg

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


