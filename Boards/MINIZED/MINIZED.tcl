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
#  Please direct any questions to the MiniZed community support forum:
#     http://www.minized.org/forum
# 
#  Product information is available at:
#     http://www.minized.org/product/minized
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2017 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Feb 03, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq-7007
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Vivado 2016.4
# 
#  Description:         Build Script for MiniZed
# 
#  Dependencies:        To be called from a project build script
#
#  Revision:            Apr 30, 2017: Update to Vivado 2017.1
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xc7z007sclg225-1 -force
   # add selection for proper xdc based on needs

}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the MiniZed which is derived from the 
   # board definition file downloadable from the MiniZed.org community site.
   # Create interface ports
   set iic_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_rtl_0 ]
   set pl_led_g [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_led_g ]
   set pl_led_r [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_led_r ]
   set pl_sw_1bit [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_sw_1bit ]
   
   # Create ports
   set BT_CTS_IN_N [ create_bd_port -dir O BT_CTS_IN_N ]
   set BT_HOST_WAKE [ create_bd_port -dir I BT_HOST_WAKE ]
   set BT_REG_ON [ create_bd_port -dir O BT_REG_ON ]
   set BT_RTS_OUT_N [ create_bd_port -dir I BT_RTS_OUT_N ]
   set BT_RXD_IN [ create_bd_port -dir O BT_RXD_IN ]
   set BT_TXD_OUT [ create_bd_port -dir I BT_TXD_OUT ]
   set WL_HOST_WAKE [ create_bd_port -dir I WL_HOST_WAKE ]
   set WL_REG_ON [ create_bd_port -dir O WL_REG_ON ]
   set WL_SDIO_CLK [ create_bd_port -dir O -type clk WL_SDIO_CLK ]
   set WL_SDIO_CMD [ create_bd_port -dir IO WL_SDIO_CMD ]
   set WL_SDIO_DAT [ create_bd_port -dir IO -from 3 -to 0 WL_SDIO_DAT ]

   # Create instance: axi_gpio_0, and set properties
   #create_bd_cell -type module -reference wireless_mgr wireless_mgr_0
   
   # Create instance: axi_gpio_0, and set properties
   set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
   set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_IS_DUAL {1} \
   CONFIG.GPIO_BOARD_INTERFACE {Custom} \
   CONFIG.USE_BOARD_FLOW {true} \
   ] [get_bd_cells axi_gpio_0]
   
   # Create instance: axi_gpio_1, and set properties
   set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
   set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.GPIO_BOARD_INTERFACE {pl_sw_1bit} \
   CONFIG.USE_BOARD_FLOW {true} \
   ] [get_bd_cells axi_gpio_1]
   
   # Create instance: axi_iic_0, and set properties
   set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0 ]
   
   # Create AXI UART 16550 instance and set properties
   set bluetooth_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uart16550:2.0 axi_uart16550_0 ]
   set_property name bluetooth_uart [get_bd_cells axi_uart16550_0]
   set_property -dict [ list \
   CONFIG.C_HAS_EXTERNAL_XIN {1} \
   CONFIG.C_EXTERNAL_XIN_CLK_HZ_d {48} \
   CONFIG.C_EXTERNAL_XIN_CLK_HZ {48000000}
   ] [get_bd_cells bluetooth_uart]

   # Create instance: xlconcat_0, and set properties
   set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
   set_property -dict [ list \
   CONFIG.NUM_PORTS {2} \
   ] [get_bd_cells xlconcat_0]
   
   # Create instance: xlconstant_1, and set properties
   set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
   set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   ] [get_bd_cells xlconstant_1]

   save_bd_design
   
   # Create interface connections
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_0/GPIO] [get_bd_intf_ports pl_led_g]
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_0/GPIO2] [get_bd_intf_ports pl_led_r]
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_1/GPIO] [get_bd_intf_ports pl_sw_1bit]
   connect_bd_intf_net [get_bd_intf_pins axi_iic_0/IIC] [get_bd_intf_ports iic_rtl_0]
   connect_bd_intf_net [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
   connect_bd_intf_net [get_bd_intf_pins bluetooth_uart/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
      
   connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins bluetooth_uart/s_axi_aclk] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins rst_ps7_0_50M/slowest_sync_clk]
   connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins bluetooth_uart/xin] 
   connect_bd_net [get_bd_pins rst_ps7_0_50M/interconnect_aresetn] [get_bd_pins ps7_0_axi_periph/ARESETN] 
   connect_bd_net [get_bd_pins rst_ps7_0_50M/peripheral_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins bluetooth_uart/s_axi_aresetn] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN]
   connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In1]
   connect_bd_net [get_bd_pins bluetooth_uart/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO1_CDN] [get_bd_pins processing_system7_0/SDIO1_WP] [get_bd_pins xlconstant_1/dout]

   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_CLK] [get_bd_pins wireless_mgr_0/SDIO_CLK]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_CLK_FB] [get_bd_pins wireless_mgr_0/SDIO_CLK_FB]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_CMD_O] [get_bd_pins wireless_mgr_0/SDIO_CMD_from_Zynq]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_CMD_I] [get_bd_pins wireless_mgr_0/SDIO_CMD_to_Zynq]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_CMD_T] [get_bd_pins wireless_mgr_0/SDIO_CMD_dir]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_DATA_O] [get_bd_pins wireless_mgr_0/SDIO_DATA_from_Zynq]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_DATA_I] [get_bd_pins wireless_mgr_0/SDIO_DATA_to_Zynq]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_DATA_T] [get_bd_pins wireless_mgr_0/SDIO_DATA_dir]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_WP] [get_bd_pins wireless_mgr_0/SDIO_WP]
   connect_bd_net [get_bd_pins processing_system7_0/SDIO0_CDN] [get_bd_pins wireless_mgr_0/SDIO_CDN]
   connect_bd_net [get_bd_pins processing_system7_0/GPIO_O] [get_bd_pins wireless_mgr_0/GPIO_from_Zynq]
   connect_bd_net [get_bd_pins processing_system7_0/GPIO_I] [get_bd_pins wireless_mgr_0/GPIO_to_Zynq]
   connect_bd_net [get_bd_pins processing_system7_0/GPIO_T] [get_bd_pins wireless_mgr_0/GPIO_dir]
   connect_bd_net [get_bd_pins bluetooth_uart/sout] [get_bd_pins wireless_mgr_0/ZYNQ_UART_TX]
   connect_bd_net [get_bd_pins bluetooth_uart/sin] [get_bd_pins wireless_mgr_0/ZYNQ_UART_RX]
   connect_bd_net [get_bd_pins bluetooth_uart/rtsn] [get_bd_pins wireless_mgr_0/ZYNQ_UART_RTS]
   connect_bd_net [get_bd_pins bluetooth_uart/ctsn] [get_bd_pins wireless_mgr_0/ZYNQ_UART_CTS]
   connect_bd_net [get_bd_ports WL_HOST_WAKE] [get_bd_pins wireless_mgr_0/WL_HOST_WAKE]
   connect_bd_net [get_bd_ports BT_TXD_OUT] [get_bd_pins wireless_mgr_0/BT_TXD_OUT]
   connect_bd_net [get_bd_ports BT_RTS_OUT_N] [get_bd_pins wireless_mgr_0/BT_RTS_OUT_N]
   connect_bd_net [get_bd_ports BT_HOST_WAKE] [get_bd_pins wireless_mgr_0/BT_HOST_WAKE]
   connect_bd_net [get_bd_ports WL_SDIO_DAT] [get_bd_pins wireless_mgr_0/WL_SDIO_DAT]
   connect_bd_net [get_bd_ports WL_SDIO_CLK] [get_bd_pins wireless_mgr_0/WL_SDIO_CLK]
   connect_bd_net [get_bd_ports WL_SDIO_CMD] [get_bd_pins wireless_mgr_0/WL_SDIO_CMD]
   connect_bd_net [get_bd_ports WL_REG_ON] [get_bd_pins wireless_mgr_0/WL_REG_ON]
   connect_bd_net [get_bd_ports BT_RXD_IN] [get_bd_pins wireless_mgr_0/BT_RXD_IN]
   connect_bd_net [get_bd_ports BT_REG_ON] [get_bd_pins wireless_mgr_0/BT_REG_ON]
   connect_bd_net [get_bd_ports BT_CTS_IN_N] [get_bd_pins wireless_mgr_0/BT_CTS_IN_N]
   
   save_bd_design

   assign_bd_address
   regenerate_bd_layout
   validate_bd_design
   
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

   set processing_system7_0 [get_bd_cells processing_system7_0]
   
   # Add selection for customized PS settings
	set_property -dict [ list \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {1} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {48} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {160} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
	] [get_bd_cells processing_system7_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_50M
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph
   set_property -dict [ list \
   CONFIG.NUM_MI {04} \
   ] [get_bd_cells ps7_0_axi_periph]

   apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/processing_system7_0/FCLK_CLK0 (50 MHz)" }  [get_bd_pins ps7_0_axi_periph/ACLK]

   # board automation incorrectly connects [rst_ps7_0_50M/peripheral_aresetn] to [ps7_0_axi_periph/ARESETN]
   # the connection should be [rst_ps7_0_50M/interconnect_aresetn] to [ps7_0_axi_periph/ARESETN]
   # this is corrected in avnet_add_user_io_preset 
   delete_bd_objs [get_bd_nets rst_ps7_0_50M_peripheral_aresetn]

   save_bd_design
}

proc avnet_add_sdsoc_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   #set_property PFM_NAME "em.avnet.com:av:${design_name}:1.0" [get_files ./${design_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd]
   set_property PFM_NAME "em.avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]


   # define clock and reset ports
   set_property PFM.CLOCK { \
      FCLK_CLK0 {id "0" is_default "true" proc_sys_reset "rst_ps7_0_50M"} \
   } [get_bd_cells /processing_system7_0]
   

   # define AXI ports
   # HPM0
   set parVal []
   set cnt [get_property CONFIG.NUM_MI [get_bd_cells /ps7_0_axi_periph]]
   for {set i $cnt} {$i < 64} {incr i} {
      lappend parVal M[format %02d $i]_AXI {memport "M_AXI_GP"}
   }
   set_property PFM.AXI_PORT $parVal [get_bd_cells /ps7_0_axi_periph]
   # M_AXI ports
   set_property PFM.AXI_PORT { \
      M_AXI_GP1 {memport "M_AXI_GP"} \
      M_AXI_GP0 {memport "M_AXI_GP"} \
   } [get_bd_cells /processing_system7_0]
   # S_AXI ports
   set_property PFM.AXI_PORT { \
      S_AXI_HP0 {memport "S_AXI_HP"} \
      S_AXI_HP1 {memport "S_AXI_HP"} \
      S_AXI_HP2 {memport "S_AXI_HP"} \
      S_AXI_HP3 {memport "S_AXI_HP"} \
   } [get_bd_cells /processing_system7_0]
   
   # define interrupt ports
   # interrupts0
   set parVal []
   set cnt [get_property CONFIG.NUM_PORTS [get_bd_cell /xlconcat_0]]
   for {set i $cnt} {$i < 8} {incr i} {
      lappend parVal In$i {}
   }
   set_property PFM.IRQ $parVal [get_bd_cells /xlconcat_0]
}
