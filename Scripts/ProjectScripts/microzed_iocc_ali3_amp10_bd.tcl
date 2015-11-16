
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
set scripts_vivado_version 2015.2
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


# Hierarchical cell: zed_ali3_display
proc create_hier_cell_zed_ali3_display { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_zed_ali3_display() - Empty argument(s)!"
     return
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

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI
  create_bd_intf_pin -mode Master -vlnv avnet.com:interface:avnet_ali3_rtl:1.0 ali3_video
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 vdma_ctrl

  # Create pins
  create_bd_pin -dir I ali3_clk_in
  create_bd_pin -dir I ali3_iic_irq
  create_bd_pin -dir O -from 2 -to 0 ali3_interrupt_vector
  create_bd_pin -dir I ali3_touch_irq
  create_bd_pin -dir I axi4lite_clk
  create_bd_pin -dir I -type clk axi4s_clk
  create_bd_pin -dir I axi4s_resetn

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list CONFIG.NUM_MI {1}  ] $axi_mem_intercon

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_vdma_0 ]
  set_property -dict [ list CONFIG.c_include_mm2s_dre {1} CONFIG.c_include_s2mm {0} CONFIG.c_mm2s_genlock_mode {0} CONFIG.c_mm2s_linebuffer_depth {4096} CONFIG.c_mm2s_max_burst_length {16}  ] $axi_vdma_0

  # Create instance: gnd_const_0, and set properties
  set gnd_const_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd_const_0 ]
  set_property -dict [ list CONFIG.CONST_VAL {0}  ] $gnd_const_0

  # Create instance: proc_sys_reset, and set properties
  set proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list CONFIG.C_OPERATION {not} CONFIG.C_SIZE {1}  ] $util_vector_logic_0

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:3.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list CONFIG.C_S_AXIS_VIDEO_FORMAT {6} CONFIG.VTG_MASTER_SLAVE {1}  ] $v_axi4s_vid_out_0

  # Create instance: vcc_const_0, and set properties
  set vcc_const_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc_const_0 ]
  set_property -dict [ list CONFIG.CONST_VAL {1}  ] $vcc_const_0

  # Create instance: vtiming_gen_0, and set properties
  set vtiming_gen_0 [ create_bd_cell -type ip -vlnv avnet.com:ip:vtiming_gen:1.6 vtiming_gen_0 ]
  set_property -dict [list CONFIG.C_VIDEO_RESOLUTION {7}] $vtiming_gen_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list CONFIG.NUM_PORTS {3}  ] $xlconcat_0

  # Create instance: zed_ali3_controller_0, and set properties
  set zed_ali3_controller_0 [ create_bd_cell -type ip -vlnv avnet.com:ip:zed_ali3_controller:1.7 zed_ali3_controller_0 ]
  set_property -dict [list CONFIG.C_PIXEL_CLOCK_RATE {5}] $zed_ali3_controller_0
  
  # Create instance: debounce_0, and set properties
  set debounce_0 [ create_bd_cell -type ip -vlnv avnet.com:ip:debounce:1.0 debounce_0 ]
  
  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_mem_intercon/M00_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins vdma_ctrl] [get_bd_intf_pins axi_vdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins ali3_video] [get_bd_intf_pins zed_ali3_controller_0/ALI3]
  connect_bd_intf_net -intf_net axi_vdma_0_m_axi_mm2s [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_m_axis_mm2s [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out] [get_bd_intf_pins zed_ali3_controller_0/VID_IO_IN]
  connect_bd_intf_net -intf_net vtiming_gen_0_vtiming [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins vtiming_gen_0/VTIMING]

  # Create port connections
  connect_bd_net -net ali3_clk_in_1 [get_bd_pins ali3_clk_in] [get_bd_pins zed_ali3_controller_0/clk_in] [get_bd_pins debounce_0/clk]
  connect_bd_net -net ali3_i2c_irq_1 [get_bd_pins ali3_iic_irq] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net ali3_t_irq_1 [get_bd_pins ali3_touch_irq] [get_bd_pins debounce_0/signal_in]
  connect_bd_net -net ali3_db_irq_1 [get_bd_pins debounce_0/signal_out] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net aresetn_1 [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins proc_sys_reset/interconnect_aresetn]
  connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins axi_vdma_0/mm2s_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins axi4s_resetn] [get_bd_pins proc_sys_reset/ext_reset_in]
  connect_bd_net -net gnd_const [get_bd_pins gnd_const_0/dout] [get_bd_pins v_axi4s_vid_out_0/rst] [get_bd_pins zed_ali3_controller_0/reset_in]
  connect_bd_net -net proc_sys_reset_peripheral_aresetn [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins proc_sys_reset/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_fclk_clk1 [get_bd_pins axi4s_clk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins proc_sys_reset/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/aclk]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins axi4lite_clk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk]
  connect_bd_net -net util_vector_logic_0_res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins vtiming_gen_0/enable]
  connect_bd_net -net vcc_const [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins v_axi4s_vid_out_0/aclken] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce] [get_bd_pins vcc_const_0/dout] [get_bd_pins vtiming_gen_0/resetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins ali3_interrupt_vector] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net zed_ali3_controller_0_clk_out [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins vtiming_gen_0/clk] [get_bd_pins zed_ali3_controller_0/clk_out]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

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

  # Create remaining interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set ali3_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 ali3_iic ]
  set ali3_video [ create_bd_intf_port -mode Master -vlnv avnet.com:interface:avnet_ali3_rtl:1.0 ali3_video ]
  set emio_user [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 emio_user ]

  # Create ports
  set ali3_touch_irq [ create_bd_port -dir I ali3_touch_irq ]

  # Create instance: ali3_iic_0, and set properties
  set ali3_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 ali3_iic_0 ]
  set_property -dict [ list CONFIG.IIC_FREQ_KHZ {400} CONFIG.C_SCL_INERTIAL_DELAY {30} CONFIG.C_SDA_INERTIAL_DELAY {5} ] $ali3_iic_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0 ]
  set_property -dict [ list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {71.1} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false} ] $clk_wiz_0

  # Create instance: proc_sys_reset, and set properties
  set proc_sys_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  # Rather than use the built in MicroZed presets, use the PS7 settings from 
  # the 2014.4 Zynq Hardware SpeedWay training so that they can be overridden
  # within this project if needed.
  set_property -dict [ list CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET_RESET_ENABLE {0} \
CONFIG.PCW_EN_CLK0_PORT {0} \
CONFIG.PCW_EN_CLK1_PORT {0} \
CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_EN_CLK3_PORT {0} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {25} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_I2C_RESET_ENABLE {0} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_IO {MIO 50} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {.294} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {.298} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {.338} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {.334} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} \
CONFIG.PCW_USE_M_AXI_GP0 {1} \
 ] $processing_system7_0
  # Override any of the basic PS7 settings made above with the settings that
  # are specific to the demands of this project.
  set_property -dict [ list CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK0_PORT {1} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} \
CONFIG.PCW_EN_RST0_PORT {1} \
CONFIG.PCW_EN_RST1_PORT {1} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {75.000} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {16} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} ] $processing_system7_0

############################################################################
# Configure MIOs
#   - disable all pull-ups
#   - slew set to SLOW
############################################################################
set_property -dict [ list \
	CONFIG.PCW_MIO_0_PULLUP {disabled} \
	CONFIG.PCW_MIO_1_PULLUP {disabled} \
	CONFIG.PCW_MIO_2_PULLUP {disabled} \
	CONFIG.PCW_MIO_3_PULLUP {disabled} \
	CONFIG.PCW_MIO_4_PULLUP {disabled} \
	CONFIG.PCW_MIO_5_PULLUP {disabled} \
	CONFIG.PCW_MIO_6_PULLUP {disabled} \
	CONFIG.PCW_MIO_7_PULLUP {disabled} \
	CONFIG.PCW_MIO_8_PULLUP {disabled} \
	CONFIG.PCW_MIO_9_PULLUP {disabled} \
	CONFIG.PCW_MIO_10_PULLUP {disabled} \
	CONFIG.PCW_MIO_11_PULLUP {disabled} \
	CONFIG.PCW_MIO_12_PULLUP {disabled} \
	CONFIG.PCW_MIO_13_PULLUP {disabled} \
	CONFIG.PCW_MIO_14_PULLUP {disabled} \
	CONFIG.PCW_MIO_15_PULLUP {disabled} \
	CONFIG.PCW_MIO_16_PULLUP {disabled} \
	CONFIG.PCW_MIO_17_PULLUP {disabled} \
	CONFIG.PCW_MIO_18_PULLUP {disabled} \
	CONFIG.PCW_MIO_19_PULLUP {disabled} \
	CONFIG.PCW_MIO_20_PULLUP {disabled} \
	CONFIG.PCW_MIO_21_PULLUP {disabled} \
	CONFIG.PCW_MIO_22_PULLUP {disabled} \
	CONFIG.PCW_MIO_23_PULLUP {disabled} \
	CONFIG.PCW_MIO_24_PULLUP {disabled} \
	CONFIG.PCW_MIO_25_PULLUP {disabled} \
	CONFIG.PCW_MIO_26_PULLUP {disabled} \
	CONFIG.PCW_MIO_27_PULLUP {disabled} \
	CONFIG.PCW_MIO_28_PULLUP {disabled} \
	CONFIG.PCW_MIO_29_PULLUP {disabled} \
	CONFIG.PCW_MIO_30_PULLUP {disabled} \
	CONFIG.PCW_MIO_31_PULLUP {disabled} \
	CONFIG.PCW_MIO_32_PULLUP {disabled} \
	CONFIG.PCW_MIO_33_PULLUP {disabled} \
	CONFIG.PCW_MIO_34_PULLUP {disabled} \
	CONFIG.PCW_MIO_35_PULLUP {disabled} \
	CONFIG.PCW_MIO_36_PULLUP {disabled} \
	CONFIG.PCW_MIO_37_PULLUP {disabled} \
	CONFIG.PCW_MIO_38_PULLUP {disabled} \
	CONFIG.PCW_MIO_39_PULLUP {disabled} \
	CONFIG.PCW_MIO_40_PULLUP {disabled} \
	CONFIG.PCW_MIO_41_PULLUP {disabled} \
	CONFIG.PCW_MIO_42_PULLUP {disabled} \
	CONFIG.PCW_MIO_43_PULLUP {disabled} \
	CONFIG.PCW_MIO_44_PULLUP {disabled} \
	CONFIG.PCW_MIO_45_PULLUP {disabled} \
	CONFIG.PCW_MIO_46_PULLUP {disabled} \
	CONFIG.PCW_MIO_47_PULLUP {disabled} \
	CONFIG.PCW_MIO_48_PULLUP {disabled} \
	CONFIG.PCW_MIO_49_PULLUP {disabled} \
	CONFIG.PCW_MIO_50_PULLUP {disabled} \
	CONFIG.PCW_MIO_51_PULLUP {disabled} \
	CONFIG.PCW_MIO_52_PULLUP {disabled} \
	CONFIG.PCW_MIO_53_PULLUP {disabled} \
	CONFIG.PCW_MIO_0_SLEW {slow} \
	CONFIG.PCW_MIO_1_SLEW {slow} \
	CONFIG.PCW_MIO_2_SLEW {slow} \
	CONFIG.PCW_MIO_3_SLEW {slow} \
	CONFIG.PCW_MIO_4_SLEW {slow} \
	CONFIG.PCW_MIO_5_SLEW {slow} \
	CONFIG.PCW_MIO_6_SLEW {slow} \
	CONFIG.PCW_MIO_7_SLEW {slow} \
	CONFIG.PCW_MIO_8_SLEW {slow} \
	CONFIG.PCW_MIO_9_SLEW {slow} \
	CONFIG.PCW_MIO_10_SLEW {slow} \
	CONFIG.PCW_MIO_11_SLEW {slow} \
	CONFIG.PCW_MIO_12_SLEW {slow} \
	CONFIG.PCW_MIO_13_SLEW {slow} \
	CONFIG.PCW_MIO_14_SLEW {slow} \
	CONFIG.PCW_MIO_15_SLEW {slow} \
	CONFIG.PCW_MIO_16_SLEW {slow} \
	CONFIG.PCW_MIO_17_SLEW {slow} \
	CONFIG.PCW_MIO_18_SLEW {slow} \
	CONFIG.PCW_MIO_19_SLEW {slow} \
	CONFIG.PCW_MIO_20_SLEW {slow} \
	CONFIG.PCW_MIO_21_SLEW {slow} \
	CONFIG.PCW_MIO_22_SLEW {slow} \
	CONFIG.PCW_MIO_23_SLEW {slow} \
	CONFIG.PCW_MIO_24_SLEW {slow} \
	CONFIG.PCW_MIO_25_SLEW {slow} \
	CONFIG.PCW_MIO_26_SLEW {slow} \
	CONFIG.PCW_MIO_27_SLEW {slow} \
	CONFIG.PCW_MIO_28_SLEW {slow} \
	CONFIG.PCW_MIO_29_SLEW {slow} \
	CONFIG.PCW_MIO_30_SLEW {slow} \
	CONFIG.PCW_MIO_31_SLEW {slow} \
	CONFIG.PCW_MIO_32_SLEW {slow} \
	CONFIG.PCW_MIO_33_SLEW {slow} \
	CONFIG.PCW_MIO_34_SLEW {slow} \
	CONFIG.PCW_MIO_35_SLEW {slow} \
	CONFIG.PCW_MIO_36_SLEW {slow} \
	CONFIG.PCW_MIO_37_SLEW {slow} \
	CONFIG.PCW_MIO_38_SLEW {slow} \
	CONFIG.PCW_MIO_39_SLEW {slow} \
	CONFIG.PCW_MIO_40_SLEW {slow} \
	CONFIG.PCW_MIO_41_SLEW {slow} \
	CONFIG.PCW_MIO_42_SLEW {slow} \
	CONFIG.PCW_MIO_43_SLEW {slow} \
	CONFIG.PCW_MIO_44_SLEW {slow} \
	CONFIG.PCW_MIO_45_SLEW {slow} \
	CONFIG.PCW_MIO_46_SLEW {slow} \
	CONFIG.PCW_MIO_47_SLEW {slow} \
	CONFIG.PCW_MIO_48_SLEW {slow} \
	CONFIG.PCW_MIO_49_SLEW {slow} \
	CONFIG.PCW_MIO_50_SLEW {slow} \
	CONFIG.PCW_MIO_51_SLEW {slow} \
	CONFIG.PCW_MIO_52_SLEW {slow} \
	CONFIG.PCW_MIO_53_SLEW {slow} \
] [get_bd_cells processing_system7_0]

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {2}  ] $processing_system7_0_axi_periph

  # Create instance: zed_ali3_display
  create_hier_cell_zed_ali3_display [current_bd_instance .] zed_ali3_display

  # Create interface connections
  connect_bd_intf_net -intf_net ali3_iic_0_iic [get_bd_intf_ports ali3_iic] [get_bd_intf_pins ali3_iic_0/IIC]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_m00_axi [get_bd_intf_pins ali3_iic_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_m01_axi [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI] [get_bd_intf_pins zed_ali3_display/vdma_ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_ddr [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_fixed_io [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_gpio_0 [get_bd_intf_ports emio_user] [get_bd_intf_pins processing_system7_0/GPIO_0]
  connect_bd_intf_net -intf_net processing_system7_0_m_axi_gp0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net zed_ali3_display_ali3_video [get_bd_intf_ports ali3_video] [get_bd_intf_pins zed_ali3_display/ali3_video]
  connect_bd_intf_net -intf_net zed_ali3_display_m00_axi [get_bd_intf_pins processing_system7_0/S_AXI_HP0] [get_bd_intf_pins zed_ali3_display/M00_AXI]

  # Create port connections
  connect_bd_net -net ali3_clk_in_1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins zed_ali3_display/ali3_clk_in]
  connect_bd_net -net ali3_iic_irq_1 [get_bd_pins ali3_iic_0/iic2intc_irpt] [get_bd_pins zed_ali3_display/ali3_iic_irq]
  connect_bd_net -net ali3_touch_irq_1 [get_bd_ports ali3_touch_irq] [get_bd_pins zed_ali3_display/ali3_touch_irq]
  connect_bd_net -net axi4s_clk_1 [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins zed_ali3_display/axi4s_clk]
  connect_bd_net -net axi4s_resetn_1 [get_bd_pins processing_system7_0/FCLK_RESET1_N] [get_bd_pins zed_ali3_display/axi4s_resetn]
  connect_bd_net -net proc_sys_reset_interconnect_aresetn [get_bd_pins proc_sys_reset/interconnect_aresetn] [get_bd_pins processing_system7_0_axi_periph/ARESETN]
  connect_bd_net -net proc_sys_reset_peripheral_aresetn [get_bd_pins ali3_iic_0/s_axi_aresetn] [get_bd_pins proc_sys_reset/peripheral_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN]
  connect_bd_net -net processing_system7_0_fclk_clk0 [get_bd_pins ali3_iic_0/s_axi_aclk] [get_bd_pins proc_sys_reset/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins zed_ali3_display/axi4lite_clk]
  connect_bd_net -net processing_system7_0_fclk_clk2 [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK2]
  connect_bd_net -net processing_system7_0_fclk_reset0_n [get_bd_pins proc_sys_reset/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N]
  connect_bd_net -net zed_ali3_display_ali3_interrupt_vector [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins zed_ali3_display/ali3_interrupt_vector]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ali3_iic_0/S_AXI/Reg] SEG_ali3_iic_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs zed_ali3_display/axi_vdma_0/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces zed_ali3_display/axi_vdma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


