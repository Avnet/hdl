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
#  Create Date:         Dec 21, 2016
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96_v1 board
# 
#  Tool versions:       Vivado 2018.2
# 
#  Description:         Build Script for Ultra96_v1
# 
#  Dependencies:        To be called from a project build script
#
#  Revision:            Aug 01, 2018: 1.00 Initial version
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
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_1
   endgroup
   
   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_0/S_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_uart16550_0/S_AXI]
   endgroup
   
   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_1/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_uart16550_1/S_AXI]
   endgroup
   
   startgroup
   create_bd_port -dir I -type data mezz_uart_0_rxd
   connect_bd_net [get_bd_pins /axi_uart16550_0/sin] [get_bd_ports mezz_uart_0_rxd]
   endgroup
   
   startgroup
   create_bd_port -dir O -type data mezz_uart_0_txd
   connect_bd_net [get_bd_pins /axi_uart16550_0/sout] [get_bd_ports mezz_uart_0_txd]
   endgroup
   
   startgroup
   create_bd_port -dir I -type data mezz_uart_1_rxd
   connect_bd_net [get_bd_pins /axi_uart16550_1/sin] [get_bd_ports mezz_uart_1_rxd]
   endgroup
   
   startgroup
   create_bd_port -dir O -type data mezz_uart_1_txd
   connect_bd_net [get_bd_pins /axi_uart16550_1/sout] [get_bd_ports mezz_uart_1_txd]
   endgroup
   
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   endgroup
   set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   connect_bd_net [get_bd_pins axi_uart16550_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins axi_uart16550_1/ip2intc_irpt] [get_bd_pins xlconcat_0/In1]
   
   startgroup
   make_bd_pins_external  [get_bd_pins xlconcat_0/In2]
   endgroup
   
   startgroup
   make_bd_pins_external  [get_bd_pins xlconcat_0/In3]
   endgroup
   
   set_property name mezz_int_0 [get_bd_ports In2_0]
   set_property name mezz_int_1 [get_bd_ports In3_0]
   
   startgroup
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_rtsn]
   endgroup
   
   startgroup
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_ctsn]
   endgroup
   
   set_property name BT_ctsn [get_bd_ports emio_uart0_ctsn_0]
   set_property name BT_rtsn [get_bd_ports emio_uart0_rtsn_0]
   
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

}
