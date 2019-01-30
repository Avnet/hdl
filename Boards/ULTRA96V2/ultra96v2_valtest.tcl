# ----------------------------------------------------------------------------
#       _____
#      *     *
#     *____   *____
#    * *===*   *==*
#   *___*===*___**  AVNET
#        *======*
#         *====*
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions to the UltraZed community support forum:
#     http://www.ultrazed.org/forum
# 
#  Product information is available at:
#     http://www.ultrazed.org/product/ultrazed
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Oct 12, 2018
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96v2 board
# 
#  Tool versions:       Vivado 2018.2
# 
#  Description:         Build Script for Ultra96v2
# 
#  Dependencies:        To be called from a project build script
#
#  Revision:            Oct 12, 2018: 1.00 Initial version
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu3eg-sbva484-1-e -force
   # add selection for proper xdc based on needs
   # if IO carrier, then use that xdc
   # if FMC, choose that one

}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0
   endgroup
   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_0/S_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_uart16550_0/S_AXI]
   endgroup
   startgroup
   create_bd_port -dir I -type data ls_mezz_uart_rxd
   connect_bd_net [get_bd_pins /axi_uart16550_0/sin] [get_bd_ports ls_mezz_uart_rxd]
   endgroup
   startgroup
   create_bd_port -dir O -type data ls_mezz_uart_txd
   connect_bd_net [get_bd_pins /axi_uart16550_0/sout] [get_bd_ports ls_mezz_uart_txd]
   endgroup
   
   startgroup
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_ctsn]
   endgroup
   set_property name BT_ctsn [get_bd_ports emio_uart0_ctsn_0]
   startgroup
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_rtsn]
   endgroup
   set_property name BT_rtsn [get_bd_ports emio_uart0_rtsn_0]

   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   endgroup
   set_property -dict [list CONFIG.C_GPIO_WIDTH {8} CONFIG.C_GPIO2_WIDTH {8} CONFIG.C_IS_DUAL {1}] [get_bd_cells axi_gpio_0]
   startgroup
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_0/GPIO]
   endgroup
   set_property name ls_mezz_loop_in [get_bd_intf_ports GPIO_0]
   startgroup
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_0/GPIO2]
   endgroup
   set_property name ls_mezz_loop_out [get_bd_intf_ports GPIO2_0]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_0/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]

   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   endgroup
   set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   connect_bd_net [get_bd_pins axi_uart16550_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]

   startgroup
   set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {1}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup

   # Comment the following 4 lines if the WiFi radio reset is driven via MIO7 (JT5 set to pins 2-3)
   # Un-comment these lines if the WiFi radio reset is driven via EMIO (ZU+ device pin A3) (JT5 set to pins 1-2)
   # This setting has implications for the device tree, so be sure to make sure this setting matches the device tree
   startgroup
   make_bd_intf_pins_external  [get_bd_intf_pins zynq_ultra_ps_e_0/GPIO_0]
   endgroup
   set_property name wifi_radio_rstn [get_bd_intf_ports GPIO_0_0]

   regenerate_bd_layout
   validate_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]

   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]
   
   # The 2017.2 and later BDF enables SWDT and TTC peripherals by default
   # so these do not need to be explicitly enabled.
   #set_property -dict [list CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   #set_property -dict [list CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   #set_property -dict [list CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   #set_property -dict [list CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   #set_property -dict [list CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   #set_property -dict [list CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]

   # Disable SPI0 so we can use MIO[38:43] as GPIO to test the LS mezzanine loopback
   startgroup
   set_property -dict [list CONFIG.PSU__SPI0__PERIPHERAL__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup
   
   # MIO25 is used as GPIO for USB Vbus detect.  Change to pullup instead of default pulldown
   startgroup
   set_property -dict [list CONFIG.PSU_MIO_25_PULLUPDOWN {pullup}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup

   # Add the modem flow control pins to PSU UART0
   startgroup
   set_property -dict [list CONFIG.PSU__UART0__MODEM__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   
   # Disable PMU GPO2 (disconnect MIO34) (work-around for PMU power-off issue)
   #~ startgroup
   #~ set_property -dict [list CONFIG.PSU__PMU__GPO2__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
   #~ endgroup

   startgroup
   set_property -dict [list CONFIG.PSU__PMU__GPO2__POLARITY {high}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup

}
