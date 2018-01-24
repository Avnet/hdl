
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
set scripts_vivado_version 2017.2
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
  set arduino_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 arduino_iic ]
  set dip_switches_8bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 dip_switches_8bits ]
  set jx2_je_pmod_spi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 jx2_je_pmod_spi ]
  set jx2_jf_pmod_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 jx2_jf_pmod_iic ]
  set led_2bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_2bits ]
  set push_buttons_3bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_buttons_3bits ]

  # Create ports
  set HTS221_DRDY [ create_bd_port -dir I -from 0 -to 0 HTS221_DRDY ]
  set LIS3MDL_DRDY [ create_bd_port -dir I -from 0 -to 0 LIS3MDL_DRDY ]
  set LIS3MDL_INT1 [ create_bd_port -dir I -from 0 -to 0 LIS3MDL_INT1 ]
  set LPS25H_INT1 [ create_bd_port -dir I -from 0 -to 0 LPS25H_INT1 ]
  set LSM6DS0_INT1 [ create_bd_port -dir I -from 0 -to 0 LSM6DS0_INT1 ]
  set led_6bits [ create_bd_port -dir O -from 5 -to 0 led_6bits ]

  # Create instance: PWM_w_Int_0, and set properties
  set PWM_w_Int_0 [ create_bd_cell -type ip -vlnv avnet.com:ip:PWM_w_Int:1.0 PWM_w_Int_0 ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_GPIO_WIDTH {8} \
CONFIG.GPIO_BOARD_INTERFACE {dip_switches_8bits} \
 ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_ALL_OUTPUTS_2 {1} \
CONFIG.C_GPIO2_WIDTH {2} \
CONFIG.C_GPIO_WIDTH {3} \
CONFIG.C_IS_DUAL {1} \
CONFIG.GPIO_BOARD_INTERFACE {push_buttons_3bits} \
 ] $axi_gpio_1

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_iic_1, and set properties
  set axi_iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1 ]

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]

  # Create instance: rst_zynq_ultra_ps_e_0_100M, and set properties
  set rst_zynq_ultra_ps_e_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_zynq_ultra_ps_e_0_100M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {8} \
 ] $xlconcat_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {5} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {8} \
CONFIG.DOUT_WIDTH {6} \
 ] $xlslice_0

  # Create instance: zynq_ultra_ps_e_0_axi_periph, and set properties
  set zynq_ultra_ps_e_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 zynq_ultra_ps_e_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {6} \
 ] $zynq_ultra_ps_e_0_axi_periph

  # Create interface connections
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports dip_switches_8bits] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_ports push_buttons_3bits] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO2 [get_bd_intf_ports led_2bits] [get_bd_intf_pins axi_gpio_1/GPIO2]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports arduino_iic] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_iic_1_IIC [get_bd_intf_ports jx2_jf_pmod_iic] [get_bd_intf_pins axi_iic_1/IIC]
  connect_bd_intf_net -intf_net axi_quad_spi_0_SPI_0 [get_bd_intf_ports jx2_je_pmod_spi] [get_bd_intf_pins axi_quad_spi_0/SPI_0]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_LPD [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M01_AXI [get_bd_intf_pins PWM_w_Int_0/s00_axi] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M02_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M03_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M04_AXI [get_bd_intf_pins axi_iic_1/S_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_axi_periph_M05_AXI [get_bd_intf_pins axi_quad_spi_0/AXI_LITE] [get_bd_intf_pins zynq_ultra_ps_e_0_axi_periph/M05_AXI]

  # Create port connections
  connect_bd_net -net In3_1 [get_bd_ports LSM6DS0_INT1] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net In4_1 [get_bd_ports LPS25H_INT1] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net In5_1 [get_bd_ports HTS221_DRDY] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net In6_1 [get_bd_ports LIS3MDL_INT1] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net In7_1 [get_bd_ports LIS3MDL_DRDY] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net PWM_w_Int_0_LEDs [get_bd_pins PWM_w_Int_0/LEDs] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_iic_1_iic2intc_irpt [get_bd_pins axi_iic_1/iic2intc_irpt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_quad_spi_0_ip2intc_irpt [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net rst_zynq_ultra_ps_e_0_100M_interconnect_aresetn [get_bd_pins rst_zynq_ultra_ps_e_0_100M/interconnect_aresetn] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/ARESETN]
  connect_bd_net -net rst_zynq_ultra_ps_e_0_100M_peripheral_aresetn [get_bd_pins PWM_w_Int_0/s00_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins rst_zynq_ultra_ps_e_0_100M/peripheral_aresetn] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M00_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M01_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M02_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M03_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M04_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M05_ARESETN] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/S00_ARESETN]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net xlslice_0_Dout [get_bd_ports led_6bits] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins PWM_w_Int_0/s00_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_iic_1/s_axi_aclk] [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins rst_zynq_ultra_ps_e_0_100M/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M00_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M01_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M02_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M03_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M04_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/M05_ACLK] [get_bd_pins zynq_ultra_ps_e_0_axi_periph/S00_ACLK]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins rst_zynq_ultra_ps_e_0_100M/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x80010000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs PWM_w_Int_0/s00_axi/reg0] SEG_PWM_w_Int_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x80000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80020000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80030000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80040000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_iic_1/S_AXI/Reg] SEG_axi_iic_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x80050000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_quad_spi_0/AXI_LITE/Reg] SEG_axi_quad_spi_0_Reg

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



  
