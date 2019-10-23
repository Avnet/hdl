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
#  Create Date:         Aug 01, 2018
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq UltraScale+ 3EG
#  Hardware Boards:     Ultra96v1 board
# 
#  Tool versions:       Vivado 2018.2
# 
#  Description:         Build Script for Ultra96v1
# 
#  Dependencies:        To be called from a project build script
#
#  Revision:            Aug 01, 2018: 1.00 Initial version
#                       Oct 14, 2019: 1.01 Updated for Vivado 2019.1
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
   # Add the AXI SmartConnect and Processor System Reset blocks
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
   endgroup
   
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
   endgroup
   
   connect_bd_net [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   connect_bd_net [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
   connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn]
   
   connect_bd_intf_net [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
   connect_bd_net [get_bd_pins smartconnect_0/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   
   set_property name axi_smc [get_bd_cells smartconnect_0]
   set_property name rst_ps8_0_100M [get_bd_cells proc_sys_reset_0]
   
   #
   # Add the Block Memory Controller and BRAM
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
   endgroup
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_bram_ctrl_0/S_AXI} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
   
   startgroup
   set_property -dict [ list CONFIG.DATA_WIDTH {128} CONFIG.ECC_TYPE {0} CONFIG.SUPPORTS_NARROW_BURST {1} ]  [get_bd_cells axi_bram_ctrl_0]
   endgroup

   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
   endgroup
   set_property name axi_bram_ctrl_0_bram [get_bd_cells blk_mem_gen_0]

   startgroup
   set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} ] [get_bd_cells axi_bram_ctrl_0_bram]
   endgroup

   startgroup
   apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
   apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "/axi_bram_ctrl_0_bram" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]
   endgroup
   
   #
   # Add the PWM IP blocks
   #
   startgroup
   create_bd_cell -type ip -vlnv avnet.com:ip:PWM_w_Int:1.0 PWM_w_Int_0
   endgroup
   
   startgroup
   make_bd_pins_external  [get_bd_pins PWM_w_Int_0/PWM_out]
   endgroup
   
   set_property name ls_mezz_pwm_out1 [get_bd_ports PWM_out_0]
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/PWM_w_Int_0/s00_axi} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins PWM_w_Int_0/s00_axi]
   
   startgroup
   create_bd_cell -type ip -vlnv avnet.com:ip:PWM_w_Int:1.0 PWM_w_Int_1
   endgroup
   
   startgroup
   make_bd_pins_external  [get_bd_pins PWM_w_Int_1/PWM_out]
   endgroup
   set_property name ls_mezz_pwm_out2 [get_bd_ports PWM_out_0]
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/PWM_w_Int_1/s00_axi} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins PWM_w_Int_1/s00_axi]
   
   #
   # Add the LS Mezzanine UARTs
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0
   endgroup
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_0/S_AXI} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins axi_uart16550_0/S_AXI]
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_uart16550_0/sin]
   endgroup
   
   set_property name ls_mezz_uart1_rx [get_bd_ports sin_0]
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_uart16550_0/sout]
   endgroup
   
   set_property name ls_mezz_uart1_tx [get_bd_ports sout_0]
   
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_1
   endgroup
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_uart16550_1/S_AXI} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins axi_uart16550_1/S_AXI]
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_uart16550_1/sin]
   endgroup
   
   set_property name ls_mezz_uart2_rx [get_bd_ports sin_0]
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_uart16550_1/sout]
   endgroup
   
   set_property name ls_mezz_uart2_tx [get_bd_ports sout_0]
   
   #
   # Add the GPIO block for the LS mezzanine INT inputs and RST outputs
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   endgroup
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_0/S_AXI} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins axi_gpio_0/S_AXI]
   
   startgroup
   set_property -dict [list CONFIG.C_GPIO_WIDTH {2} CONFIG.C_GPIO2_WIDTH {2} CONFIG.C_IS_DUAL {1} CONFIG.C_ALL_INPUTS {1} CONFIG.C_ALL_OUTPUTS_2 {1}] [get_bd_cells axi_gpio_0]
   endgroup
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_gpio_0/gpio_io_i]
   endgroup
   
   set_property name ls_mezz_int [get_bd_ports gpio_io_i_0]
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_gpio_0/gpio2_io_o]
   endgroup
   
   set_property name ls_mezz_rst [get_bd_ports gpio2_io_o_0]
   
   #
   # Add the GPIO block for the fan control
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   endgroup
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/axi_gpio_1/S_AXI} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins axi_gpio_1/S_AXI]
   
   startgroup
   set_property -dict [list CONFIG.C_GPIO_WIDTH {1} CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_DOUT_DEFAULT {0xFFFFFFFF}] [get_bd_cells axi_gpio_1]
   endgroup
   
   startgroup
   make_bd_pins_external  [get_bd_pins axi_gpio_1/gpio_io_o]
   endgroup
   
   set_property name fan_pwm [get_bd_ports gpio_io_o_0]
   
   #
   # Add the System Management Wizard 
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz_0
   endgroup
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (100 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} Slave {/system_management_wiz_0/S_AXI_LITE} intc_ip {/axi_smc} master_apm {0}}  [get_bd_intf_pins system_management_wiz_0/S_AXI_LITE]

   startgroup
   set_property -dict [ list CONFIG.CHANNEL_ENABLE_VP_VN {false} CONFIG.ENABLE_VCCPSAUX_ALARM {false} CONFIG.ENABLE_VCCPSINTFP_ALARM {false} CONFIG.ENABLE_VCCPSINTLP_ALARM {false} CONFIG.OT_ALARM {false} CONFIG.USER_TEMP_ALARM {false} CONFIG.VCCAUX_ALARM {false} CONFIG.VCCINT_ALARM {false} ] [get_bd_cells system_management_wiz_0]
   endgroup
   
   #
   # Add the Concat block for the interrupts
   #
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   endgroup
   
   set_property -dict [list CONFIG.NUM_PORTS {5}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins PWM_w_Int_0/Interrupt_Out] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins PWM_w_Int_1/Interrupt_Out] [get_bd_pins xlconcat_0/In1]
   connect_bd_net [get_bd_pins axi_uart16550_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In2]
   connect_bd_net [get_bd_pins axi_uart16550_1/ip2intc_irpt] [get_bd_pins xlconcat_0/In3]
   connect_bd_net [get_bd_ports ls_mezz_int] [get_bd_pins xlconcat_0/In4]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   
   #
   # Connect the UART modem signals for PS UART0
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
   # Re-draw the design and validate it
   #
   regenerate_bd_layout
   validate_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0
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

   # Enable the slave selects for PS SPI0
   startgroup
   set_property -dict [list CONFIG.PSU__SPI0__GRP_SS1__ENABLE {1} CONFIG.PSU__SPI0__GRP_SS2__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup
}
