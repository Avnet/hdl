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
#     http://avnet.me/Ultra96_Forum
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
#  Create Date:         Apr 04, 2019
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96v2 board
# 
#  Tool versions:       Vivado 2018.3
# 
#  Description:         Build Script for Ultra96v2
# 
#  Dependencies:        To be called from a project build script
#
#  Revision:            Apr 04, 2019: 1.00 Initial version
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu3eg-sbva484-1-e -force
   # add selection for proper xdc based on needs
   # if IO carrier, then use that xdc
   # if FMC, choose that one

}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   #
   # Add LS Mezzanine UARTs
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0
   endgroup

   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {Auto} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_0/S_AXI} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins axi_uart16550_0/S_AXI]
   endgroup

   startgroup
   make_bd_pins_external  [get_bd_pins axi_uart16550_0/sin]
   endgroup
   set_property name ls_mezz_uart0_rx [get_bd_ports sin_0]

   startgroup
   make_bd_pins_external  [get_bd_pins axi_uart16550_0/sout]
   endgroup
   set_property name ls_mezz_uart0_tx [get_bd_ports sout_0]

   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_1
   endgroup

   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_1/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_uart16550_1/S_AXI]
   endgroup

   startgroup
   make_bd_pins_external  [get_bd_pins axi_uart16550_1/sin]
   endgroup
   set_property name ls_mezz_uart1_rx [get_bd_ports sin_0]

   startgroup
   make_bd_pins_external  [get_bd_pins axi_uart16550_1/sout]
   endgroup
   set_property name ls_mezz_uart1_tx [get_bd_ports sout_0]

   #
   # Add the GPIO block for the WiFi and BT LEDs
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   endgroup

   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_0/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]
   endgroup

   startgroup
   set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_GPIO2_WIDTH {1} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_0]
   endgroup

   startgroup
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_0/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_0/GPIO2]
   endgroup
   set_property name wifi_en_led [get_bd_intf_ports GPIO_0]
   set_property name bt_en_led [get_bd_intf_ports GPIO2_0]

   #
   # Add the GPIO block for the fan control
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   endgroup

   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_1/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_1/S_AXI]
   endgroup

   startgroup
   set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_IS_DUAL {0} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_DOUT_DEFAULT {0x00000001}] [get_bd_cells axi_gpio_1]
   endgroup

   startgroup
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_1/GPIO]
   endgroup
   set_property name fan_pwm [get_bd_intf_ports GPIO_0]

   #
   # Add the GPIO block for the LS mezzanine INT inputs and RST outputs
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2
   endgroup
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_2/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_gpio_2/S_AXI]
   
   startgroup
   set_property -dict [list CONFIG.C_GPIO_WIDTH {2} CONFIG.C_GPIO2_WIDTH {2} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_2]
   endgroup
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_gpio_2/gpio_io_i]
   endgroup
   
   set_property name ls_mezz_int [get_bd_ports gpio_io_i_0]
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_gpio_2/gpio2_io_o]
   endgroup
   
   set_property name ls_mezz_rst [get_bd_ports gpio2_io_o_0]
   
   #
   # Add the PWM IP blocks
   #
   startgroup
   create_bd_cell -type ip -vlnv avnet.com:ip:PWM_w_Int:1.0 PWM_w_Int_0
   endgroup

   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/PWM_w_Int_0/s00_axi} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins PWM_w_Int_0/s00_axi]
   endgroup

   startgroup
   make_bd_pins_external  [get_bd_pins PWM_w_Int_0/PWM_out]
   endgroup
   set_property name ls_mezz_pwm0 [get_bd_ports PWM_out_0]

   startgroup
   create_bd_cell -type ip -vlnv avnet.com:ip:PWM_w_Int:1.0 PWM_w_Int_1
   endgroup

   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/PWM_w_Int_1/s00_axi} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins PWM_w_Int_1/s00_axi]
   endgroup

   startgroup
   make_bd_pins_external  [get_bd_pins PWM_w_Int_1/PWM_out]
   endgroup
   set_property name ls_mezz_pwm1 [get_bd_ports PWM_out_0]

   #
   # Add the System Management Wizard 
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0
   endgroup
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/system_management_wiz_0/S_AXI_LITE} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE]

   startgroup
   set_property -dict [ list CONFIG.CHANNEL_ENABLE_VP_VN {false} CONFIG.ENABLE_VCCPSAUX_ALARM {false} CONFIG.ENABLE_VCCPSINTFP_ALARM {false} CONFIG.ENABLE_VCCPSINTLP_ALARM {false} CONFIG.OT_ALARM {false} CONFIG.USER_TEMP_ALARM {false} CONFIG.VCCAUX_ALARM {false} CONFIG.VCCINT_ALARM {false} ] [get_bd_cells system_management_wiz_0]
   endgroup

   #
   # Add the Concat block for the interrupts
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   endgroup

   set_property -dict [list CONFIG.NUM_PORTS {4}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   connect_bd_net [get_bd_pins axi_uart16550_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins axi_uart16550_1/ip2intc_irpt] [get_bd_pins xlconcat_0/In1]
   connect_bd_net [get_bd_pins PWM_w_Int_0/Interrupt_Out] [get_bd_pins xlconcat_0/In2]
   connect_bd_net [get_bd_pins PWM_w_Int_1/Interrupt_Out] [get_bd_pins xlconcat_0/In3]

   #
   # Connect the UART modem signals for PS UART0 (Bluetooth UART)
   #
   startgroup
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_ctsn]
   endgroup
   set_property name bt_ctsn [get_bd_ports emio_uart0_ctsn_0]
   startgroup
   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/emio_uart0_rtsn]
   endgroup
   set_property name bt_rtsn [get_bd_ports emio_uart0_rtsn_0]

   #
   # Add XLSLICE blocks to carve the 30 bits of PS EMIO GPIO into smaller chunks
   # Add XLSLICE 0 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {28} CONFIG.DIN_FROM {29} CONFIG.DOUT_WIDTH {2}] [get_bd_cells xlslice_0]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_0/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_0/Dout]
   endgroup
   set_property name hs_mezz_csi0_c [get_bd_ports Dout_0]

   #
   # Add XLSLICE 1 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {20} CONFIG.DIN_FROM {27} CONFIG.DOUT_WIDTH {8}] [get_bd_cells xlslice_1]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_1/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_1/Dout]
   endgroup
   set_property name hs_mezz_csi0_d [get_bd_ports Dout_0]

   #
   # Add XLSLICE 2 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {18} CONFIG.DIN_FROM {19} CONFIG.DOUT_WIDTH {2}] [get_bd_cells xlslice_2]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_2/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_2/Dout]
   endgroup
   set_property name hs_mezz_csi1_c [get_bd_ports Dout_0]

   #
   # Add XLSLICE 3 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_3
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {14} CONFIG.DIN_FROM {17} CONFIG.DOUT_WIDTH {4}] [get_bd_cells xlslice_3]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_3/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_3/Dout]
   endgroup
   set_property name hs_mezz_csi1_d [get_bd_ports Dout_0]

   #
   # Add XLSLICE 4 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_4
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {13} CONFIG.DIN_FROM {13} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_4]
   
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_4/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_4/Dout]
   endgroup
   set_property name hs_mezz_csi0_mclk [get_bd_ports Dout_0]

   #
   # Add XLSLICE 5 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_5
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {12} CONFIG.DIN_FROM {12} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_5]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_5/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_5/Dout]
   endgroup
   set_property name hs_mezz_csi1_mclk [get_bd_ports Dout_0]

   #
   # Add XLSLICE 6 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_6
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {10} CONFIG.DIN_FROM {11} CONFIG.DOUT_WIDTH {2}] [get_bd_cells xlslice_6]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_6/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_6/Dout]
   endgroup
   set_property name hs_mezz_dsi_clk [get_bd_ports Dout_0]

   #
   # Add XLSLICE 7 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_7
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {2} CONFIG.DIN_FROM {9} CONFIG.DOUT_WIDTH {8}] [get_bd_cells xlslice_7]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_7/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_7/Dout]
   endgroup
   set_property name hs_mezz_dsi_d [get_bd_ports Dout_0]

   #
   # Add XLSLICE 8 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_8
   endgroup
   
   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {1} CONFIG.DIN_FROM {1} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_8]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_8/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_8/Dout]
   endgroup
   set_property name hs_mezz_hsic_str [get_bd_ports Dout_0]

   #
   # Add XLSLICE 9 to the BD, set the XLSLICE properties, connect it to the PS block, make the I/Os external and name them
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_9
   endgroup

   set_property -dict [list CONFIG.DIN_WIDTH {30} CONFIG.DIN_TO {0} CONFIG.DIN_FROM {0} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_9]

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_9/Din]

   startgroup
   make_bd_pins_external  [get_bd_pins xlslice_9/Dout]
   endgroup
   set_property name hs_mezz_hsic_d [get_bd_ports Dout_0]

   # Redraw the BD and validate the design
   regenerate_bd_layout
   validate_bd_design

}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.2 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]

   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]
   
   # MIO25 is used as GPIO for USB Vbus detect.  Change to pullup instead of default pulldown
   startgroup
   set_property -dict [list CONFIG.PSU_MIO_25_PULLUPDOWN {pullup}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup

   # Add the modem flow control pins to PSU UART0 (Bluetooth UART)
   startgroup
   set_property -dict [list CONFIG.PSU__UART0__MODEM__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup

   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   
   # Set PMU GPO2 (connected to on/off controller KILL_N signal) initial state to '1'
   startgroup
   set_property -dict [list CONFIG.PSU__PMU__GPO2__POLARITY {high}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup

   # Enable the EMIO GPIO and set the width to 30 bits
   startgroup
   set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1} CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO {30}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup
   
   # Enable the SS1 and SS2 signals for the PS SPI0 peripehral
   startgroup
   set_property -dict [list CONFIG.PSU__SPI0__GRP_SS1__ENABLE {1} CONFIG.PSU__SPI0__GRP_SS2__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup
   

}

proc avnet_add_sdsoc_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
#   set_property PFM_NAME "em.avnet.com:av:${design_name}:1.0" [get_files ./${design_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd]
   set_property PFM_NAME "em.avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]


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

