
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
set scripts_vivado_version 2017.4
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

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axi_ethernet:7.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_iic:2.0\
xilinx.com:ip:axi_interconnect:2.1\
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:c_counter_binary:12.0\
xilinx.com:ip:clk_wiz:5.4\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:system_management_wiz:1.3\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:zynq_ultra_ps_e:3.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
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
  set iic_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_rtl_0 ]
  set iic_rtl_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_rtl_1 ]
  set iic_rtl_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_rtl_2 ]
  set led_8bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 led_8bits ]
  set mdio_io_port_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_0 ]
  set mdio_io_port_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_io:1.0 mdio_io_port_1 ]
  set push_buttons_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_buttons_4bits ]
  set rgmii_port_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_0 ]
  set rgmii_port_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_port_1 ]
  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

  # Create ports
  set ref_clk_fsel [ create_bd_port -dir O -from 0 -to 0 ref_clk_fsel ]
  set ref_clk_n [ create_bd_port -dir I -from 0 -to 0 -type clk ref_clk_n ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $ref_clk_n
  set ref_clk_oe [ create_bd_port -dir O -from 0 -to 0 ref_clk_oe ]
  set ref_clk_p [ create_bd_port -dir I -from 0 -to 0 -type clk ref_clk_p ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $ref_clk_p
  set reset_port_0 [ create_bd_port -dir O -from 0 -to 0 -type rst reset_port_0 ]
  set reset_port_1 [ create_bd_port -dir O -from 0 -to 0 -type rst reset_port_1 ]
  
  # Create instance: axi_ethernet_0, and set properties
  set axi_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet_0 ]
  set_property -dict [ list \
   CONFIG.PHY_TYPE {RGMII} \
   CONFIG.SupportLevel {0} \
 ] $axi_ethernet_0

  set_property -dict [ list \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.ADDR_WIDTH {18} \
 ] [get_bd_intf_pins /axi_ethernet_0/s_axi]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /axi_ethernet_0/axis_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet_0/gtx_clk]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /axi_ethernet_0/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /axi_ethernet_0/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/phy_rst_n]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /axi_ethernet_0/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_0/s_axi_lite_resetn]

  # Create instance: axi_ethernet_0_dma, and set properties
  set axi_ethernet_0_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_ethernet_0_dma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
 ] $axi_ethernet_0_dma

  # Create instance: axi_ethernet_1, and set properties
  set axi_ethernet_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.1 axi_ethernet_1 ]
  set_property -dict [ list \
   CONFIG.PHY_TYPE {RGMII} \
   CONFIG.SupportLevel {1} \
 ] $axi_ethernet_1

  set_property -dict [ list \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.ADDR_WIDTH {18} \
 ] [get_bd_intf_pins /axi_ethernet_1/s_axi]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/axi_rxd_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/axi_rxs_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/axi_txc_arstn]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/axi_txd_arstn]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rxd:m_axis_rxs:s_axis_txc:s_axis_txd} \
   CONFIG.ASSOCIATED_RESET {axi_rxd_arstn:axi_rxs_arstn:axi_txc_arstn:axi_txd_arstn} \
 ] [get_bd_pins /axi_ethernet_1/axis_clk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] [get_bd_pins /axi_ethernet_1/gtx_clk]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {LEVEL_HIGH} \
 ] [get_bd_pins /axi_ethernet_1/interrupt]

  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] [get_bd_pins /axi_ethernet_1/mac_irq]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/phy_rst_n]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {s_axi} \
   CONFIG.ASSOCIATED_RESET {s_axi_lite_resetn} \
 ] [get_bd_pins /axi_ethernet_1/s_axi_lite_clk]

  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] [get_bd_pins /axi_ethernet_1/s_axi_lite_resetn]

  # Create instance: axi_ethernet_1_dma, and set properties
  set axi_ethernet_1_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_ethernet_1_dma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s_dre {1} \
   CONFIG.c_include_s2mm_dre {1} \
 ] $axi_ethernet_1_dma
 
  # Create instance: axi_iic_0, used for IPMI EEPROM, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]

  # Create instance: axi_iic_1, used for MAC1 EEPROM, and set properties
  set axi_iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1 ]

  # Create instance: axi_iic_2, used for MAC2 EEPROM, and set properties
  set axi_iic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_2 ] 

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
   CONFIG.NUM_SI {6} \
 ] $axi_smc

  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.4 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_JITTER {119.348} \
   CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
   CONFIG.CLKOUT2_JITTER {109.241} \
   CONFIG.CLKOUT2_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {12.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.000} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {5} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.PRIM_IN_FREQ {125} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {12} \
 ] $ps8_0_axi_periph

  # Create instance: ref_clk_fsel, and set properties
  set ref_clk_fsel [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ref_clk_fsel ]

  # Create instance: ref_clk_oe, and set properties
  set ref_clk_oe [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 ref_clk_oe ]

  # Create instance: rst_ps8_0_99M, and set properties
  set rst_ps8_0_99M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_99M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $xlconcat_0

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO_WIDTH {8} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_0

  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {8} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_1

  # Create instance: axi_gpio_2, and set properties
  set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
  set_property -dict [ list CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS {0} CONFIG.C_GPIO_WIDTH {4} CONFIG.GPIO_BOARD_INTERFACE {Custom} CONFIG.USE_BOARD_FLOW {true} ] $axi_gpio_2

  # Create instance: system_management_wiz_0, and set properties
  set system_management_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0 ]

  # Set additional zynq_ultra_ps_e_0 properties
  set_property -dict [ list \
   CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__IRQ1 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   ] [get_bd_cells zynq_ultra_ps_e_0] 
  
  # Enable the PSU SPI interface on the Pmod expansion port so that the TPM Pmod
  # can be connected to the system.
  set_property -dict [list \
   CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SPI0__PERIPHERAL__IO {MIO 38 .. 43} \
   CONFIG.PSU__SPI1__PERIPHERAL__ENABLE {0} \
   ] [get_bd_cells zynq_ultra_ps_e_0] 

   
  # Create interface connections
  connect_bd_intf_net [get_bd_intf_ports dip_switches_8bits] [get_bd_intf_pins axi_gpio_0/GPIO]
  connect_bd_intf_net [get_bd_intf_ports led_8bits] [get_bd_intf_pins axi_gpio_1/GPIO]
  connect_bd_intf_net [get_bd_intf_ports push_buttons_4bits] [get_bd_intf_pins axi_gpio_2/GPIO]
  connect_bd_intf_net [get_bd_intf_ports Vp_Vn] [get_bd_intf_pins system_management_wiz_0/Vp_Vn]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXIS_CNTRL [get_bd_intf_pins axi_ethernet_0/s_axis_txc] [get_bd_intf_pins axi_ethernet_0_dma/M_AXIS_CNTRL]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXIS_MM2S [get_bd_intf_pins axi_ethernet_0/s_axis_txd] [get_bd_intf_pins axi_ethernet_0_dma/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_MM2S [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S01_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_S2MM [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S02_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_dma_M_AXI_SG [get_bd_intf_pins axi_ethernet_0_dma/M_AXI_SG] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd [get_bd_intf_pins axi_ethernet_0/m_axis_rxd] [get_bd_intf_pins axi_ethernet_0_dma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxs [get_bd_intf_pins axi_ethernet_0/m_axis_rxs] [get_bd_intf_pins axi_ethernet_0_dma/S_AXIS_STS]
  connect_bd_intf_net -intf_net axi_ethernet_0_mdio [get_bd_intf_ports mdio_io_port_0] [get_bd_intf_pins axi_ethernet_0/mdio]
  connect_bd_intf_net -intf_net axi_ethernet_0_rgmii [get_bd_intf_ports rgmii_port_0] [get_bd_intf_pins axi_ethernet_0/rgmii]
  connect_bd_intf_net -intf_net axi_ethernet_1_dma_M_AXIS_CNTRL [get_bd_intf_pins axi_ethernet_1/s_axis_txc] [get_bd_intf_pins axi_ethernet_1_dma/M_AXIS_CNTRL]
  connect_bd_intf_net -intf_net axi_ethernet_1_dma_M_AXIS_MM2S [get_bd_intf_pins axi_ethernet_1/s_axis_txd] [get_bd_intf_pins axi_ethernet_1_dma/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axi_ethernet_1_dma_M_AXI_MM2S [get_bd_intf_pins axi_ethernet_1_dma/M_AXI_MM2S] [get_bd_intf_pins axi_smc/S04_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_1_dma_M_AXI_S2MM [get_bd_intf_pins axi_ethernet_1_dma/M_AXI_S2MM] [get_bd_intf_pins axi_smc/S05_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_1_dma_M_AXI_SG [get_bd_intf_pins axi_ethernet_1_dma/M_AXI_SG] [get_bd_intf_pins axi_smc/S03_AXI]
  connect_bd_intf_net -intf_net axi_ethernet_1_m_axis_rxd [get_bd_intf_pins axi_ethernet_1/m_axis_rxd] [get_bd_intf_pins axi_ethernet_1_dma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_ethernet_1_m_axis_rxs [get_bd_intf_pins axi_ethernet_1/m_axis_rxs] [get_bd_intf_pins axi_ethernet_1_dma/S_AXIS_STS]
  connect_bd_intf_net -intf_net axi_ethernet_1_mdio [get_bd_intf_ports mdio_io_port_1] [get_bd_intf_pins axi_ethernet_1/mdio]
  connect_bd_intf_net -intf_net axi_ethernet_1_rgmii [get_bd_intf_ports rgmii_port_1] [get_bd_intf_pins axi_ethernet_1/rgmii]
  connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports iic_rtl_0] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_intf_net -intf_net axi_iic_1_IIC [get_bd_intf_ports iic_rtl_1] [get_bd_intf_pins axi_iic_1/IIC]
  connect_bd_intf_net -intf_net axi_iic_2_IIC [get_bd_intf_ports iic_rtl_2] [get_bd_intf_pins axi_iic_2/IIC]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins axi_ethernet_0/s_axi] [get_bd_intf_pins ps8_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins axi_ethernet_0_dma/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins axi_ethernet_1/s_axi] [get_bd_intf_pins ps8_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins axi_ethernet_1_dma/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins axi_timer_0/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M05_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M07_AXI [get_bd_intf_pins axi_gpio_2/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M08_AXI [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M09_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M10_AXI [get_bd_intf_pins axi_iic_1/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M11_AXI [get_bd_intf_pins axi_iic_2/S_AXI] [get_bd_intf_pins ps8_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
  
  # Connect port connections
  connect_bd_net -net axi_ethernet_0_dma_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_0/axi_txc_arstn] [get_bd_pins axi_ethernet_0_dma/mm2s_cntrl_reset_out_n]
  connect_bd_net -net axi_ethernet_0_dma_mm2s_introut [get_bd_pins axi_ethernet_0_dma/mm2s_introut] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net axi_ethernet_0_dma_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_0/axi_txd_arstn] [get_bd_pins axi_ethernet_0_dma/mm2s_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_0_dma_s2mm_introut [get_bd_pins axi_ethernet_0_dma/s2mm_introut] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net axi_ethernet_0_dma_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_0/axi_rxd_arstn] [get_bd_pins axi_ethernet_0_dma/s2mm_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_0_dma_s2mm_sts_reset_out_n [get_bd_pins axi_ethernet_0/axi_rxs_arstn] [get_bd_pins axi_ethernet_0_dma/s2mm_sts_reset_out_n]
  connect_bd_net -net axi_ethernet_0_interrupt [get_bd_pins axi_ethernet_0/interrupt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_ethernet_0_mac_irq [get_bd_pins axi_ethernet_0/mac_irq] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_ethernet_0_phy_rst_n [get_bd_ports reset_port_0] [get_bd_pins axi_ethernet_0/phy_rst_n]
  connect_bd_net -net axi_ethernet_1_dma_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_1/axi_txc_arstn] [get_bd_pins axi_ethernet_1_dma/mm2s_cntrl_reset_out_n]
  connect_bd_net -net axi_ethernet_1_dma_mm2s_introut [get_bd_pins axi_ethernet_1_dma/mm2s_introut] [get_bd_pins xlconcat_0/In6]
  connect_bd_net -net axi_ethernet_1_dma_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_1/axi_txd_arstn] [get_bd_pins axi_ethernet_1_dma/mm2s_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_1_dma_s2mm_introut [get_bd_pins axi_ethernet_1_dma/s2mm_introut] [get_bd_pins xlconcat_0/In7]
  connect_bd_net -net axi_ethernet_1_dma_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_1/axi_rxd_arstn] [get_bd_pins axi_ethernet_1_dma/s2mm_prmry_reset_out_n]
  connect_bd_net -net axi_ethernet_1_dma_s2mm_sts_reset_out_n [get_bd_pins axi_ethernet_1/axi_rxs_arstn] [get_bd_pins axi_ethernet_1_dma/s2mm_sts_reset_out_n]
  connect_bd_net -net axi_ethernet_1_interrupt [get_bd_pins axi_ethernet_1/interrupt] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net axi_ethernet_1_mac_irq [get_bd_pins axi_ethernet_1/mac_irq] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_ethernet_1_phy_rst_n [get_bd_ports reset_port_1] [get_bd_pins axi_ethernet_1/phy_rst_n]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net axi_iic_1_iic2intc_irpt [get_bd_pins axi_iic_1/iic2intc_irpt] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net axi_iic_2_iic2intc_irpt [get_bd_pins axi_iic_2/iic2intc_irpt] [get_bd_pins xlconcat_1/In3]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axi_ethernet_0/gtx_clk] [get_bd_pins axi_ethernet_1/gtx_clk] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins axi_ethernet_1/ref_clk] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net -net ref_clk_fsel_dout [get_bd_ports ref_clk_fsel] [get_bd_pins ref_clk_fsel/dout]
  connect_bd_net -net ref_clk_n_1 [get_bd_ports ref_clk_n] [get_bd_pins clk_wiz_0/clk_in1_n]
  connect_bd_net -net ref_clk_oe_dout [get_bd_ports ref_clk_oe] [get_bd_pins ref_clk_oe/dout]
  connect_bd_net -net ref_clk_p_1 [get_bd_ports ref_clk_p] [get_bd_pins clk_wiz_0/clk_in1_p]
  connect_bd_net -net rst_ps8_0_99M_interconnect_aresetn [get_bd_pins ps8_0_axi_periph/ARESETN] [get_bd_pins rst_ps8_0_99M/interconnect_aresetn]
  connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn [get_bd_pins axi_ethernet_0/s_axi_lite_resetn] [get_bd_pins axi_ethernet_0_dma/axi_resetn] [get_bd_pins axi_ethernet_1/s_axi_lite_resetn] [get_bd_pins axi_ethernet_1_dma/axi_resetn] [get_bd_pins axi_smc/aresetn] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_gpio_2/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn] [get_bd_pins axi_iic_2/s_axi_aresetn] [get_bd_pins system_management_wiz_0/s_axi_aresetn] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/M01_ARESETN] [get_bd_pins ps8_0_axi_periph/M02_ARESETN] [get_bd_pins ps8_0_axi_periph/M03_ARESETN] [get_bd_pins ps8_0_axi_periph/M04_ARESETN] [get_bd_pins ps8_0_axi_periph/M05_ARESETN] [get_bd_pins ps8_0_axi_periph/M06_ARESETN] [get_bd_pins ps8_0_axi_periph/M07_ARESETN] [get_bd_pins ps8_0_axi_periph/M08_ARESETN] [get_bd_pins ps8_0_axi_periph/M09_ARESETN] [get_bd_pins ps8_0_axi_periph/M10_ARESETN] [get_bd_pins ps8_0_axi_periph/M11_ARESETN] [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins xlconcat_1/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconcat_1/In4] [get_bd_pins xlconcat_1/In5] [get_bd_pins xlconcat_1/In6] [get_bd_pins xlconcat_1/In7] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_ethernet_0/axis_clk] [get_bd_pins axi_ethernet_0/s_axi_lite_clk] [get_bd_pins axi_ethernet_0_dma/m_axi_mm2s_aclk] [get_bd_pins axi_ethernet_0_dma/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet_0_dma/m_axi_sg_aclk] [get_bd_pins axi_ethernet_0_dma/s_axi_lite_aclk] [get_bd_pins axi_ethernet_1/axis_clk] [get_bd_pins axi_ethernet_1/s_axi_lite_clk] [get_bd_pins axi_ethernet_1_dma/m_axi_mm2s_aclk] [get_bd_pins axi_ethernet_1_dma/m_axi_s2mm_aclk] [get_bd_pins axi_ethernet_1_dma/m_axi_sg_aclk] [get_bd_pins axi_ethernet_1_dma/s_axi_lite_aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_gpio_2/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_iic_1/s_axi_aclk] [get_bd_pins axi_iic_2/s_axi_aclk] [get_bd_pins system_management_wiz_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/M01_ACLK] [get_bd_pins ps8_0_axi_periph/M02_ACLK] [get_bd_pins ps8_0_axi_periph/M03_ACLK] [get_bd_pins ps8_0_axi_periph/M04_ACLK] [get_bd_pins ps8_0_axi_periph/M05_ACLK] [get_bd_pins ps8_0_axi_periph/M06_ACLK] [get_bd_pins ps8_0_axi_periph/M07_ACLK] [get_bd_pins ps8_0_axi_periph/M08_ACLK] [get_bd_pins ps8_0_axi_periph/M09_ACLK] [get_bd_pins ps8_0_axi_periph/M10_ACLK] [get_bd_pins ps8_0_axi_periph/M11_ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps8_0_99M/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins rst_ps8_0_99M/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
  
  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_ethernet_0_dma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  create_bd_addr_seg -range 0x10000000 -offset 0xE0000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_PCIE_LOW] SEG_zynq_ultra_ps_e_0_HP0_PCIE_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_SG] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces axi_ethernet_1_dma/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x00040000 -offset 0xA0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] SEG_axi_ethernet_0_Reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xA0040000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_ethernet_0_dma/S_AXI_LITE/Reg] SEG_axi_ethernet_0_dma_Reg
  create_bd_addr_seg -range 0x00040000 -offset 0xA0080000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_ethernet_1/s_axi/Reg0] SEG_axi_ethernet_1_Reg0
  create_bd_addr_seg -range 0x00001000 -offset 0xA0041000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_ethernet_1_dma/S_AXI_LITE/Reg] SEG_axi_ethernet_1_dma_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0042000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_timer_0/S_AXI/Reg] SEG_axi_timer_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0043000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0044000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] SEG_axi_gpio_1_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0045000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_2/S_AXI/Reg] SEG_axi_gpio_2_Reg
  create_bd_addr_seg -range 0x00002000 -offset 0xA0046000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs system_management_wiz_0/S_AXI_LITE/Reg] SEG_system_management_wiz_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0048000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0049000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_iic_1/S_AXI/Reg] SEG_axi_iic_1_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA004A000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_iic_2/S_AXI/Reg] SEG_axi_iic_2_Reg

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


