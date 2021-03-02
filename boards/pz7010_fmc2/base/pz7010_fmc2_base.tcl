# ----------------------------------------------------------------------------
#
#        ** **        **          **  ****      **  **********  ********** ®
#       **   **        **        **   ** **     **  **              **
#      **     **        **      **    **  **    **  **              **
#     **       **        **    **     **   **   **  *********       **
#    **         **        **  **      **    **  **  **              **
#   **           **        ****       **     ** **  **              **
#  **  .........  **        **        **      ****  **********      **
#     ...........
#                                     Reach Further™
#
# ----------------------------------------------------------------------------
#
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#
#  Please direct any questions to the PicoZed community support forum:
#     http://avnet.me/picozed_forum
#
#  Product information is available at:
#     http://avnet.me/picozed
#
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2021 Avnet, Inc.
#                              All rights reserved.
#
# ----------------------------------------------------------------------------
#
#  Create Date:         Nov 23, 2015
#  Design Name:         PicoZed Base HW Platform
#  Module Name:         pz7010_fmc2_base.tcl
#  Project Name:        PicoZed Base HW
#  Target Devices:      Xilinx Zynq-7010
#  Hardware Boards:     PicoZed SOM + FMC2 Carrier
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xc7z010clg400-1 -force
}

proc avnet_import_constraints {boards_folder board project} {

   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/pz7010_revc_fmcv2_reva_v1.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_i2c.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_user_io.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/bitstream_compression_enable.xdc
}

proc create_hier_cell_interrupt_concat { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_interrupt_concat() - Empty argument(s)!"}
     return
   }
   
   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
   }
   
   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
   
   # Create pins
   create_bd_pin -dir O -from 31 -to 0 dout
   
   # Create instance: xlconcat_interrupt_0, and set properties
   set xlconcat_interrupt_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_interrupt_0 ]
   set_property -dict [ list \
      CONFIG.NUM_PORTS {32} \
   ] $xlconcat_interrupt_0
   
   # Create instance: xlconstant_gnd, and set properties
   set xlconstant_gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_gnd ]
   set_property -dict [ list \
      CONFIG.CONST_VAL {0} \
   ] $xlconstant_gnd
   
   # Create port connections
   connect_bd_net -net xlconcat_interrupt_0_dout [get_bd_pins dout] [get_bd_pins xlconcat_interrupt_0/dout]
   connect_bd_net -net xlconstant_gnd_dout [get_bd_pins xlconcat_interrupt_0/In0] \
      [get_bd_pins xlconcat_interrupt_0/In1] \
      [get_bd_pins xlconcat_interrupt_0/In2] \
      [get_bd_pins xlconcat_interrupt_0/In3] \
      [get_bd_pins xlconcat_interrupt_0/In4] \
      [get_bd_pins xlconcat_interrupt_0/In5] \
      [get_bd_pins xlconcat_interrupt_0/In6] \
      [get_bd_pins xlconcat_interrupt_0/In7] \
      [get_bd_pins xlconcat_interrupt_0/In8] \
      [get_bd_pins xlconcat_interrupt_0/In9] \
      [get_bd_pins xlconcat_interrupt_0/In10] \
      [get_bd_pins xlconcat_interrupt_0/In11] \
      [get_bd_pins xlconcat_interrupt_0/In12] \
      [get_bd_pins xlconcat_interrupt_0/In13] \
      [get_bd_pins xlconcat_interrupt_0/In14] \
      [get_bd_pins xlconcat_interrupt_0/In15] \
      [get_bd_pins xlconcat_interrupt_0/In16] \
      [get_bd_pins xlconcat_interrupt_0/In17] \
      [get_bd_pins xlconcat_interrupt_0/In18] \
      [get_bd_pins xlconcat_interrupt_0/In19] \
      [get_bd_pins xlconcat_interrupt_0/In20] \
      [get_bd_pins xlconcat_interrupt_0/In21] \
      [get_bd_pins xlconcat_interrupt_0/In22] \
      [get_bd_pins xlconcat_interrupt_0/In23] \
      [get_bd_pins xlconcat_interrupt_0/In24] \
      [get_bd_pins xlconcat_interrupt_0/In25] \
      [get_bd_pins xlconcat_interrupt_0/In26] \
      [get_bd_pins xlconcat_interrupt_0/In27] \
      [get_bd_pins xlconcat_interrupt_0/In28] \
      [get_bd_pins xlconcat_interrupt_0/In29] \
      [get_bd_pins xlconcat_interrupt_0/In30] \
      [get_bd_pins xlconcat_interrupt_0/In31] \
      [get_bd_pins xlconstant_gnd/dout]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

proc avnet_add_user_io {project projects_folder scriptdir} {

   # add selection for proper xdc based on needs
   import_files -fileset constrs_1 -norecurse $scriptdir/../boards/PZ7010_FMC2/PZ7010_FMC2_user_io.xdc
   import_files -fileset constrs_1 -norecurse $scriptdir/../boards/PZ7010_FMC2/PZ7010_FMC2_i2c.xdc

}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the PicoZed which is derived from the 
   # board definition file downloadable from the github.com/avnet/bdf git repository.

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   apply_board_connection -board_interface "pl_led_1bit" -ip_intf "axi_gpio_0/GPIO" -diagram $project 
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/ps7/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   apply_board_connection -board_interface "pl_pb_1bit" -ip_intf "axi_gpio_1/GPIO" -diagram $project
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/ps7/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_gpio_1/S_AXI]

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0
   apply_bd_automation -rule xilinx.com:bd_rule:board  [get_bd_intf_pins axi_iic_0/IIC]
   set_property name hdmi_i2c [get_bd_intf_ports iic_rtl]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Master "/ps7/M_AXI_GP0" intc_ip "/ps7_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins axi_iic_0/S_AXI]

   # Board automation instantiates a proc sys reset block and connects the clocks, resets, and ints
   # but we need to change these later in this script so delete them for now
   delete_bd_objs [get_bd_nets ps7_FCLK_RESET0_N] [get_bd_cells rst_ps7_100M]
   delete_bd_objs [get_bd_nets rst_ps7_100M_peripheral_aresetn]
   delete_bd_objs [get_bd_nets ps7_FCLK_CLK0]
   delete_bd_objs [get_bd_nets axi_iic_0_iic2intc_irpt]

   save_bd_design

   # Create instance: xlconcat_0, and set properties
   set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
   set_property -dict [ list \
      CONFIG.NUM_PORTS {2} \
   ] [get_bd_cells xlconcat_0]
   
   set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

   # Add another master port to the AXI interconnect clock so we can connect the axi_intc to it
   set_property -dict [list CONFIG.NUM_MI {4}] [get_bd_cells ps7_axi_periph]

   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
   set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   # Create instance: interrupt_concat
   #create_hier_cell_interrupt_concat [current_bd_instance .] interrupt_concat
   
   # Create instance: proc_sys_reset_100MHz, and set properties
   set proc_sys_reset_100MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_100MHz ]
   
   # Create instance: proc_sys_reset_142MHz, and set properties
   set proc_sys_reset_142MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_142MHz ]
   
   # Create instance: proc_sys_reset_166MHz, and set properties
   set proc_sys_reset_166MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_166MHz ]
   
   # Create instance: proc_sys_reset_200MHz, and set properties
   set proc_sys_reset_200MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_200MHz ]
   
   # Create instance: proc_sys_reset_41MHz, and set properties
   set proc_sys_reset_41MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_41MHz ]
   
   # Create instance: proc_sys_reset_50MHz, and set properties
   set proc_sys_reset_50MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_50MHz ]
   
   # Create instance: clk_wiz_0, and set properties
   set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
   set_property -dict [ list \
      CONFIG.CLKOUT1_JITTER {162.035} \
      CONFIG.CLKOUT1_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
      CONFIG.CLKOUT2_JITTER {150.257} \
      CONFIG.CLKOUT2_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {142} \
      CONFIG.CLKOUT2_USED {true} \
      CONFIG.CLKOUT3_JITTER {146.458} \
      CONFIG.CLKOUT3_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {166} \
      CONFIG.CLKOUT3_USED {true} \
      CONFIG.CLKOUT4_JITTER {142.107} \
      CONFIG.CLKOUT4_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {200} \
      CONFIG.CLKOUT4_USED {true} \
      CONFIG.CLKOUT5_JITTER {192.113} \
      CONFIG.CLKOUT5_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {50} \
      CONFIG.CLKOUT5_USED {true} \
      CONFIG.CLKOUT6_JITTER {202.017} \
      CONFIG.CLKOUT6_PHASE_ERROR {164.985} \
      CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {41} \
      CONFIG.CLKOUT6_USED {true} \
      CONFIG.MMCM_CLKFBOUT_MULT_F {20.000} \
      CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
      CONFIG.MMCM_CLKOUT1_DIVIDE {7} \
      CONFIG.MMCM_CLKOUT2_DIVIDE {6} \
      CONFIG.MMCM_CLKOUT3_DIVIDE {5} \
      CONFIG.MMCM_CLKOUT4_DIVIDE {20} \
      CONFIG.MMCM_CLKOUT5_DIVIDE {24} \
      CONFIG.NUM_OUT_CLKS {6} \
      CONFIG.RESET_TYPE {ACTIVE_LOW} \
   ] $clk_wiz_0

   save_bd_design

   # Create interface connections
   connect_bd_intf_net [get_bd_intf_pins ps7/M_AXI_GP0] [get_bd_intf_pins ps7_axi_periph/S00_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins ps7_axi_periph/M03_AXI] 
      
   # Connect the IP blocks, clocks, resets, etc.
   connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins ps7/SDIO0_WP]

   connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
      [get_bd_pins ps7_axi_periph/S00_ACLK] \
      [get_bd_pins ps7_axi_periph/M00_ACLK] \
      [get_bd_pins ps7_axi_periph/M01_ACLK] \
      [get_bd_pins ps7_axi_periph/M02_ACLK] \
      [get_bd_pins ps7_axi_periph/M03_ACLK] \
      [get_bd_pins ps7/M_AXI_GP0_ACLK] \
      [get_bd_pins ps7_axi_periph/ACLK] \
      [get_bd_pins axi_intc_0/s_axi_aclk] \
      [get_bd_pins axi_gpio_0/s_axi_aclk] \
      [get_bd_pins axi_iic_0/s_axi_aclk] \
      [get_bd_pins axi_gpio_1/s_axi_aclk]

   connect_bd_net [get_bd_pins ps7/FCLK_CLK0] [get_bd_pins clk_wiz_0/clk_in1]

   connect_bd_net [get_bd_pins proc_sys_reset_100MHz/interconnect_aresetn] [get_bd_pins ps7_axi_periph/ARESETN] 

   connect_bd_net [get_bd_pins proc_sys_reset_100MHz/peripheral_aresetn] \
      [get_bd_pins ps7_axi_periph/S00_ARESETN] \
      [get_bd_pins ps7_axi_periph/M00_ARESETN] \
      [get_bd_pins ps7_axi_periph/M01_ARESETN] \
      [get_bd_pins ps7_axi_periph/M02_ARESETN] \
      [get_bd_pins ps7_axi_periph/M03_ARESETN] \
      [get_bd_pins axi_iic_0/s_axi_aresetn] \
      [get_bd_pins axi_gpio_0/s_axi_aresetn] \
      [get_bd_pins axi_gpio_1/s_axi_aresetn] \
      [get_bd_pins axi_intc_0/s_axi_aresetn]

   connect_bd_net [get_bd_pins ps7/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
   connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins xlconcat_0/In1]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   #connect_bd_net [get_bd_pins interrupt_concat/dout] [get_bd_pins axi_intc_0/intr]

   connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_100MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_142MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins proc_sys_reset_166MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins proc_sys_reset_200MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins proc_sys_reset_50MHz/slowest_sync_clk]
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out6] [get_bd_pins proc_sys_reset_41MHz/slowest_sync_clk]

   connect_bd_net [get_bd_pins clk_wiz_0/locked] \
      [get_bd_pins proc_sys_reset_100MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_142MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_166MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_200MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_50MHz/dcm_locked] \
      [get_bd_pins proc_sys_reset_41MHz/dcm_locked]


   connect_bd_net [get_bd_pins ps7/FCLK_RESET0_N] \
      [get_bd_pins proc_sys_reset_41MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_50MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_100MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_200MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_142MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_166MHz/ext_reset_in] \
      [get_bd_pins clk_wiz_0/resetn]

   save_bd_design
}

proc avnet_add_ps {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config \
      {make_external "FIXED_IO, DDR" }  [get_bd_cells ps7]
   create_bd_port -dir I -type clk M_AXI_GP0_ACLK
   connect_bd_net [get_bd_pins /ps7/M_AXI_GP0_ACLK] [get_bd_ports M_AXI_GP0_ACLK]

   save_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   set ps7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7 ]
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config { \
      make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells ps7]

   # Enable the M_AXI_GP0 port on the PS
   set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {1}] [get_bd_cells ps7]

   # Enable the PL-to-PS interrupts on the PS
   set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1}] [get_bd_cells ps7]

   set_property -dict [list CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0}] [get_bd_cells ps7]

   # Bring the SDIO WP pin out to EMIO
   set_property -dict [list CONFIG.PCW_SD0_GRP_WP_ENABLE {1} CONFIG.PCW_SD0_GRP_WP_IO {EMIO}] [get_bd_cells ps7]

   save_bd_design
}

proc avnet_add_custom_ps {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   set ps7 [create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7]
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" }  [get_bd_cells ps7_axi_periph]

############################################################################
# PS Bank Voltage, Busses, Clocks 
############################################################################
set_property -dict [ list \
CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_PACKAGE_NAME {clg400} \
CONFIG.PCW_USE_M_AXI_GP0 {0} \
CONFIG.PCW_USE_M_AXI_GP1 {0} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333333} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
] $ps7

############################################################################
# Fabric Clocks - CLK0 enabled, CLK[3:1] disabled by default
############################################################################
set_property -dict [ list \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK_CLK0_BUF {true} \
CONFIG.PCW_FCLK_CLK1_BUF {false} \
CONFIG.PCW_FCLK_CLK2_BUF {false} \
CONFIG.PCW_FCLK_CLK3_BUF {false} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_EN_CLK0_PORT {1} \
CONFIG.PCW_EN_CLK1_PORT {0} \
CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_EN_CLK3_PORT {0} \
CONFIG.PCW_EN_RST0_PORT {1} \
CONFIG.PCW_EN_RST1_PORT {0} \
CONFIG.PCW_EN_RST2_PORT {0} \
CONFIG.PCW_EN_RST3_PORT {0} \
] $ps7

############################################################################
# DDR3 
############################################################################
set_property -dict [ list \
CONFIG.PCW_EN_DDR {1} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
CONFIG.PCW_UIPARAM_DDR_CWL {6} \
CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {39.7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {39.7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {54.14} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {54.14} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {49.59} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {51.74} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {50.32} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {48.55} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {50.05} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {50.43} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {50.10} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {50.01} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.294} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.298} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.338} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.334} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
] $ps7

############################################################################
# Peripheral assignments
#   with the exception of GPIO:
#        eMMC/Pmod Mux Select:        0
#        Pmod:                        9
#        LED:                         47
#        Carrier Ethernet Reset:      50
#        PB:                          51 
############################################################################
set_property -dict [ list \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
CONFIG.PCW_SD1_SD1_IO {MIO 10 .. 15} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
] $ps7

############################################################################
# Enable Peripherals 
############################################################################
set_property -dict [ list \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD1_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
] $ps7

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
] $ps7

############################################################################
# Connect eMMC CD to a constant 0
############################################################################
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 GND
set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells GND]
connect_bd_net [get_bd_pins GND/dout] [get_bd_pins ps7/SDIO1_CDN]

############################################################################
# Enable USB Reset last
############################################################################
set_property -dict [ list \
   CONFIG.PCW_USB0_RESET_ENABLE {1} \
] $ps7

}

proc avnet_assign_addresses {project projects_folder scriptdir} {
    # Unassign all address segments
  delete_bd_objs [get_bd_addr_segs]
  delete_bd_objs [get_bd_addr_segs -excluded]

  # Hard-code specific address segments (used in device-tree or applications)
  #assign_bd_address -offset 0xA0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  
  assign_bd_address

}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   set_property PFM_NAME "em.avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

   # define clock and reset ports
   set_property PFM.CLOCK { \
      clk_out1 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_100MHz" status "fixed"} \
      clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_142MHz" status "fixed"} \
      clk_out3 {id "2" is_default "false" proc_sys_reset "proc_sys_reset_166MHz" status "fixed"} \
      clk_out4 {id "3" is_default "false" proc_sys_reset "proc_sys_reset_200MHz" status "fixed"} \
      clk_out5 {id "4" is_default "false" proc_sys_reset "proc_sys_reset_50MHz" status "fixed"} \
      clk_out6 {id "5" is_default "false" proc_sys_reset "proc_sys_reset_41MHz" status "fixed"} \
   } [get_bd_cells /clk_wiz_0]

   set_property PFM.AXI_PORT { \
      M_AXI_GP1 {memport "M_AXI_GP" sptag "GP" memory ""} \
      S_AXI_HP1 {memport "S_AXI_HP" sptag "HP1" memory "ps7 HP1_DDR_LOWOCM"} \
      S_AXI_HP2 {memport "S_AXI_HP" sptag "HP2" memory "ps7 HP2_DDR_LOWOCM"} \
      S_AXI_HP3 {memport "S_AXI_HP" sptag "HP3" memory "ps7 HP3_DDR_LOWOCM"} \
   } [get_bd_cells /ps7]
   
   
   # The following creates the equivalent of
   # set_property PFM.AXI_PORT { M04_AXI {memport "M_AXI_GP" }} [get_bd_cells /ps7_axi_periph]
   # for all the interfaces M04_AXI to M31_AXI
   set parVal []
   for {set i 4} {$i < 32} {incr i} {
      lappend parVal M[format %02d $i]_AXI \
   {memport "M_AXI_GP"}
   }
   set_property PFM.AXI_PORT $parVal [get_bd_cells /ps7_axi_periph]

   #set_property PFM.AXI_PORT {M04_AXI {memport "M_AXI_GP" sptag "" memory ""} M05_AXI {memport "M_AXI_GP" sptag "" memory ""} M06_AXI {memport "M_AXI_GP" sptag "" memory ""} M07_AXI {memport "M_AXI_GP" sptag "" memory ""} M08_AXI {memport "M_AXI_GP" sptag "" memory ""} M09_AXI {memport "M_AXI_GP" sptag "" memory ""} M10_AXI {memport "M_AXI_GP" sptag "" memory ""} M11_AXI {memport "M_AXI_GP" sptag "" memory ""} M12_AXI {memport "M_AXI_GP" sptag "" memory ""} M13_AXI {memport "M_AXI_GP" sptag "" memory ""} M14_AXI {memport "M_AXI_GP" sptag "" memory ""} M15_AXI {memport "M_AXI_GP" sptag "" memory ""} M16_AXI {memport "M_AXI_GP" sptag "" memory ""} M17_AXI {memport "M_AXI_GP" sptag "" memory ""} M18_AXI {memport "M_AXI_GP" sptag "" memory ""} M19_AXI {memport "M_AXI_GP" sptag "" memory ""} M20_AXI {memport "M_AXI_GP" sptag "" memory ""} M21_AXI {memport "M_AXI_GP" sptag "" memory ""} M22_AXI {memport "M_AXI_GP" sptag "" memory ""} M23_AXI {memport "M_AXI_GP" sptag "" memory ""} M24_AXI {memport "M_AXI_GP" sptag "" memory ""} M25_AXI {memport "M_AXI_GP" sptag "" memory ""} M26_AXI {memport "M_AXI_GP" sptag "" memory ""} M27_AXI {memport "M_AXI_GP" sptag "" memory ""} M28_AXI {memport "M_AXI_GP" sptag "" memory ""} M29_AXI {memport "M_AXI_GP" sptag "" memory ""} M30_AXI {memport "M_AXI_GP" sptag "" memory ""} M31_AXI {memport "M_AXI_GP" sptag "" memory ""}} [get_bd_cells /ps7_axi_periph]
 
   # required for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   # define interrupt ports
   set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]

   # Set platform project properties
   set_property platform.description                   "Base MiniZed development platform" [current_project]
   set_property platform.uses_pr                       false         [current_project]

   set_property platform.design_intent.server_managed  "false" [current_project]
   set_property platform.design_intent.external_host   "false" [current_project]
   set_property platform.design_intent.embedded        "true" [current_project]
   set_property platform.design_intent.datacenter      "false" [current_proj]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   #set_property platform.post_sys_link_tcl_hook        ./scripts/dynamic_postlink.tcl [current_project]
   #set_property platform.post_sys_link_tcl_hook        ${projects_folder}/../../../boards/pz7010_fmc2/pz7010_fmc2_dynamic_postlink.tcl [current_project]
   #set_property platform.post_sys_link_overlay_tcl_hook        ${projects_folder}/../../../boards/pz7010_fmc2/pz7010_fmc2_dynamic_postlink.tcl [current_project]

   set_property platform.vendor                        "em.avnet.com" [current_project]
   set_property platform.board_id                      ${project} [current_project]
   set_property platform.name                          ${design_name} [current_project]
   set_property platform.version                       "1.0" [current_project]
   set_property platform.platform_state                "pre_synth" [current_project]
   set_property platform.ip_cache_dir                  [get_property ip_output_repo [current_project]] [current_project]

   # recommnded to use "sd_card" for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis_Embedded_Platform_Source/blob/2020.1/Xilinx_Official_Platforms/zcu104_base/vivado/xilinx_zcu104_base_202010_1_xsa.tcl
   #set_property platform.default_output_type           "xclbin" [current_project]
   set_property platform.default_output_type           "sd_card" [current_project]

   set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
   set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
   set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
}

