
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
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set FMC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 FMC ]
  set GPIO [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO ]
  set GPIO_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_1 ]
  set GPIO2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO2 ]
  set GPIO2_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO2_1 ]
  set HDMI_I2C [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 HDMI_I2C ]
  set EMIO_USER [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 EMIO_USER ]
  
  # Create interface ports.
  create_bd_port -dir O -type clk hdmi_clk
  create_bd_port -dir O -from 15 -to 0 hdmi_d
  
  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO2_WIDTH {18} CONFIG.C_GPIO_WIDTH {18} CONFIG.C_IS_DUAL {1} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true}  ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO2_WIDTH {18} CONFIG.C_GPIO_WIDTH {18} CONFIG.C_IS_DUAL {1} CONFIG.GPIO2_BOARD_INTERFACE {Custom} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true}  ] $axi_gpio_1

  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]
  set_property -dict [ list CONFIG.IIC_FREQ_KHZ {400} ] $axi_iic_0
  
  # Create instance: hdmi_720p_0, and set properties
  set vtiming_gen_0 [ create_bd_cell -type ip -vlnv avnet.com:ip:hdmi_720p:1.0 hdmi_720p_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {667} CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} CONFIG.PCW_EN_CLK0_PORT {1} \
CONFIG.PCW_EN_CLK1_PORT {0} CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_EN_CLK3_PORT {0} CONFIG.PCW_EN_DDR {1} \
CONFIG.PCW_EN_RST0_PORT {1} CONFIG.PCW_EN_RST1_PORT {0} \
CONFIG.PCW_EN_RST2_PORT {0} CONFIG.PCW_EN_RST3_PORT {0} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK_CLK0_BUF {true} CONFIG.PCW_FCLK_CLK1_BUF {false} \
CONFIG.PCW_FCLK_CLK2_BUF {false} CONFIG.PCW_FCLK_CLK3_BUF {false} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {33.333333} CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_IO {9} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C_RESET_ENABLE {0} CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_PULLUP {disabled} CONFIG.PCW_MIO_0_SLEW {slow} \
CONFIG.PCW_MIO_10_PULLUP {disabled} CONFIG.PCW_MIO_10_SLEW {slow} \
CONFIG.PCW_MIO_11_PULLUP {disabled} CONFIG.PCW_MIO_11_SLEW {slow} \
CONFIG.PCW_MIO_12_PULLUP {disabled} CONFIG.PCW_MIO_12_SLEW {slow} \
CONFIG.PCW_MIO_13_PULLUP {disabled} CONFIG.PCW_MIO_13_SLEW {slow} \
CONFIG.PCW_MIO_14_PULLUP {disabled} CONFIG.PCW_MIO_14_SLEW {slow} \
CONFIG.PCW_MIO_15_PULLUP {disabled} CONFIG.PCW_MIO_15_SLEW {slow} \
CONFIG.PCW_MIO_16_PULLUP {disabled} CONFIG.PCW_MIO_16_SLEW {slow} \
CONFIG.PCW_MIO_17_PULLUP {disabled} CONFIG.PCW_MIO_17_SLEW {slow} \
CONFIG.PCW_MIO_18_PULLUP {disabled} CONFIG.PCW_MIO_18_SLEW {slow} \
CONFIG.PCW_MIO_19_PULLUP {disabled} CONFIG.PCW_MIO_19_SLEW {slow} \
CONFIG.PCW_MIO_1_PULLUP {disabled} CONFIG.PCW_MIO_1_SLEW {slow} \
CONFIG.PCW_MIO_20_PULLUP {disabled} CONFIG.PCW_MIO_20_SLEW {slow} \
CONFIG.PCW_MIO_21_PULLUP {disabled} CONFIG.PCW_MIO_21_SLEW {slow} \
CONFIG.PCW_MIO_22_PULLUP {disabled} CONFIG.PCW_MIO_22_SLEW {slow} \
CONFIG.PCW_MIO_23_PULLUP {disabled} CONFIG.PCW_MIO_23_SLEW {slow} \
CONFIG.PCW_MIO_24_PULLUP {disabled} CONFIG.PCW_MIO_24_SLEW {slow} \
CONFIG.PCW_MIO_25_PULLUP {disabled} CONFIG.PCW_MIO_25_SLEW {slow} \
CONFIG.PCW_MIO_26_PULLUP {disabled} CONFIG.PCW_MIO_26_SLEW {slow} \
CONFIG.PCW_MIO_27_PULLUP {disabled} CONFIG.PCW_MIO_27_SLEW {slow} \
CONFIG.PCW_MIO_28_PULLUP {disabled} CONFIG.PCW_MIO_28_SLEW {slow} \
CONFIG.PCW_MIO_29_PULLUP {disabled} CONFIG.PCW_MIO_29_SLEW {slow} \
CONFIG.PCW_MIO_2_PULLUP {disabled} CONFIG.PCW_MIO_2_SLEW {slow} \
CONFIG.PCW_MIO_30_PULLUP {disabled} CONFIG.PCW_MIO_30_SLEW {slow} \
CONFIG.PCW_MIO_31_PULLUP {disabled} CONFIG.PCW_MIO_31_SLEW {slow} \
CONFIG.PCW_MIO_32_PULLUP {disabled} CONFIG.PCW_MIO_32_SLEW {slow} \
CONFIG.PCW_MIO_33_PULLUP {disabled} CONFIG.PCW_MIO_33_SLEW {slow} \
CONFIG.PCW_MIO_34_PULLUP {disabled} CONFIG.PCW_MIO_34_SLEW {slow} \
CONFIG.PCW_MIO_35_PULLUP {disabled} CONFIG.PCW_MIO_35_SLEW {slow} \
CONFIG.PCW_MIO_36_PULLUP {disabled} CONFIG.PCW_MIO_36_SLEW {slow} \
CONFIG.PCW_MIO_37_PULLUP {disabled} CONFIG.PCW_MIO_37_SLEW {slow} \
CONFIG.PCW_MIO_38_PULLUP {disabled} CONFIG.PCW_MIO_38_SLEW {slow} \
CONFIG.PCW_MIO_39_PULLUP {disabled} CONFIG.PCW_MIO_39_SLEW {slow} \
CONFIG.PCW_MIO_3_PULLUP {disabled} CONFIG.PCW_MIO_3_SLEW {slow} \
CONFIG.PCW_MIO_40_PULLUP {disabled} CONFIG.PCW_MIO_40_SLEW {slow} \
CONFIG.PCW_MIO_41_PULLUP {disabled} CONFIG.PCW_MIO_41_SLEW {slow} \
CONFIG.PCW_MIO_42_PULLUP {disabled} CONFIG.PCW_MIO_42_SLEW {slow} \
CONFIG.PCW_MIO_43_PULLUP {disabled} CONFIG.PCW_MIO_43_SLEW {slow} \
CONFIG.PCW_MIO_44_PULLUP {disabled} CONFIG.PCW_MIO_44_SLEW {slow} \
CONFIG.PCW_MIO_45_PULLUP {disabled} CONFIG.PCW_MIO_45_SLEW {slow} \
CONFIG.PCW_MIO_46_PULLUP {disabled} CONFIG.PCW_MIO_46_SLEW {slow} \
CONFIG.PCW_MIO_47_PULLUP {disabled} CONFIG.PCW_MIO_47_SLEW {slow} \
CONFIG.PCW_MIO_48_PULLUP {disabled} CONFIG.PCW_MIO_48_SLEW {slow} \
CONFIG.PCW_MIO_49_PULLUP {disabled} CONFIG.PCW_MIO_49_SLEW {slow} \
CONFIG.PCW_MIO_4_PULLUP {disabled} CONFIG.PCW_MIO_4_SLEW {slow} \
CONFIG.PCW_MIO_50_PULLUP {disabled} CONFIG.PCW_MIO_50_SLEW {slow} \
CONFIG.PCW_MIO_51_PULLUP {disabled} CONFIG.PCW_MIO_51_SLEW {slow} \
CONFIG.PCW_MIO_52_PULLUP {disabled} CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_PULLUP {disabled} CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_PULLUP {disabled} CONFIG.PCW_MIO_5_SLEW {slow} \
CONFIG.PCW_MIO_6_PULLUP {disabled} CONFIG.PCW_MIO_6_SLEW {slow} \
CONFIG.PCW_MIO_7_PULLUP {disabled} CONFIG.PCW_MIO_7_SLEW {slow} \
CONFIG.PCW_MIO_8_PULLUP {disabled} CONFIG.PCW_MIO_8_SLEW {slow} \
CONFIG.PCW_MIO_9_PULLUP {disabled} CONFIG.PCW_MIO_9_SLEW {slow} \
CONFIG.PCW_PACKAGE_NAME {sbg485} CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {0} CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} CONFIG.PCW_SD1_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD1_GRP_WP_ENABLE {0} CONFIG.PCW_SD1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD1_SD1_IO {MIO 10 .. 15} CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC0_TTC0_IO {EMIO} CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
CONFIG.PCW_UIPARAM_DDR_BL {8} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.240} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.238} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.283} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.284} CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {33.621} CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {33.621} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {48.166} CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {48.166} \
CONFIG.PCW_UIPARAM_DDR_CWL {6} CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {38.200} CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {38.692} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {38.778} CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {38.635} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.036} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.036} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.058} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.057} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {38.671} CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {38.635} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {38.671} CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {38.679} \
CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3 (Low Voltage)} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_USE_M_AXI_GP0 {1} \
CONFIG.PCW_USE_M_AXI_GP1 {0}  ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {4}  ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports GPIO] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO2 [get_bd_intf_ports GPIO2] [get_bd_intf_pins axi_gpio_0/GPIO2]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO [get_bd_intf_ports GPIO_1] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_1_GPIO2 [get_bd_intf_ports GPIO2_1] [get_bd_intf_pins axi_gpio_1/GPIO2]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports HDMI_I2C] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_GPIO_0 [get_bd_intf_ports EMIO_USER] [get_bd_intf_pins processing_system7_0/GPIO_0]
# connect_bd_intf_net -intf_net hdmi_720p_0_HDMI [get_bd_intf_ports HDMI] [get_bd_intf_pins hdmi_720p_0/HDMI]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
 
  # Connect port connections
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins hdmi_720p_0/clk_100]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn]  [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net [get_bd_pins /hdmi_720p_0/hdmi_clk] [get_bd_ports hdmi_clk]
  connect_bd_net [get_bd_pins /hdmi_720p_0/hdmi_d] [get_bd_ports hdmi_d]
  
  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


