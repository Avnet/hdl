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
#  Please direct any questions to the MiniZed community support forum:
#     http://avnet.me/minized_forum
# 
#  Product information is available at:
#     http://avnet.me/minized
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
#  Create Date:         Feb 03, 2017
#  Design Name:         MiniZed Base HW Platform
#  Module Name:         minized_sbc_base.tcl
#  Project Name:        MiniZed Base HW
#  Target Devices:      Xilinx Zynq-7007
#  Hardware Boards:     MiniZed
# 
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xc7z007sclg225-1 -force
}

proc avnet_import_constraints {boards_folder board project} {

   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/bitstream_compression_enable.xdc
}

# Hierarchical cell: interrupt_concat
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


proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the MiniZed which is derived from the 
   # board definition file downloadable from the github.com/avnet/bdf git repository.

   # Create interface ports
   set iic_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 iic_rtl_0 ]
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
   set PL_LED_G [ create_bd_port -dir O PL_LED_G ]
   set PL_LED_R [ create_bd_port -dir O PL_LED_R ]
   set AUDIO_CLK [ create_bd_port -dir O AUDIO_CLK ]
   set AUDIO_DAT [ create_bd_port -dir I AUDIO_DAT ]

   # Create instance: axi_gpio_0, and set properties
   set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
   set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {0} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {1} \
   CONFIG.C_GPIO2_WIDTH {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_IS_DUAL {1} \
   ] [get_bd_cells axi_gpio_0]
   
   # Create instance: axi_gpio_1, and set properties
   set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
   set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.GPIO_BOARD_INTERFACE {pl_sw_1bit} \
   CONFIG.USE_BOARD_FLOW {true} \
   ] [get_bd_cells axi_gpio_1]

   # Create instance: axi_gpio_2, and set properties
   set axi_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2 ]
   set_property -dict [list CONFIG.C_GPIO_WIDTH {8}] [get_bd_cells axi_gpio_2]
   
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
   CONFIG.NUM_PORTS {4} \
   ] [get_bd_cells xlconcat_0]
   
   # Create instance: xlconstant_1, and set properties
   set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
   set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   ] [get_bd_cells xlconstant_1]

   # Create instance: axi_intc_0
   set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

   # Create instance: pdm_filt_0
   set pdm_filt_0 [ create_bd_cell -type ip -vlnv Avnet_Inc:SysGen:pdm_filt:1.0 pdm_filt_0 ]

   # Create instance: xadc_wiz_0, and set properties
   set xadc_wiz_0 [create_bd_cell -type ip -vlnv xilinx.com:ip:xadc_wiz:3.3 xadc_wiz_0 ]
   set_property -dict [list \
   CONFIG.XADC_STARUP_SELECTION {channel_sequencer} \
   CONFIG.CHANNEL_ENABLE_CALIBRATION {true} \
   CONFIG.CHANNEL_ENABLE_TEMPERATURE {true} \
   CONFIG.CHANNEL_ENABLE_VCCINT {true} \
   CONFIG.CHANNEL_ENABLE_VCCAUX {true} \
   CONFIG.CHANNEL_ENABLE_VBRAM {true} \
   CONFIG.SEQUENCER_MODE {Continuous} \
   CONFIG.EXTERNAL_MUX_CHANNEL {VP_VN} \
   CONFIG.SINGLE_CHANNEL_SELECTION {TEMPERATURE} \
   CONFIG.CHANNEL_ENABLE_VP_VN {true} \
   ] [get_bd_cells xadc_wiz_0]

   save_bd_design
   
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
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_1/GPIO] [get_bd_intf_ports pl_sw_1bit]
   connect_bd_intf_net [get_bd_intf_pins axi_iic_0/IIC] [get_bd_intf_ports iic_rtl_0]
   connect_bd_intf_net [get_bd_intf_pins ps7/M_AXI_GP0] [get_bd_intf_pins ps7_axi_periph/S00_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins ps7_axi_periph/M00_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins ps7_axi_periph/M01_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins ps7_axi_periph/M02_AXI]
   connect_bd_intf_net [get_bd_intf_pins bluetooth_uart/S_AXI] [get_bd_intf_pins ps7_axi_periph/M03_AXI]
   connect_bd_intf_net [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins ps7_axi_periph/M04_AXI] 
   connect_bd_intf_net [get_bd_intf_pins axi_gpio_2/S_AXI] [get_bd_intf_pins ps7_axi_periph/M05_AXI] 
   connect_bd_intf_net [get_bd_intf_pins xadc_wiz_0/s_axi_lite] [get_bd_intf_pins ps7_axi_periph/M06_AXI] 
      
   save_bd_design

   # Connect the IP blocks, clocks, resets, etc.
   connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
      [get_bd_pins ps7_axi_periph/S00_ACLK] \
      [get_bd_pins ps7_axi_periph/M00_ACLK] \
      [get_bd_pins ps7_axi_periph/M01_ACLK] \
      [get_bd_pins ps7_axi_periph/M02_ACLK] \
      [get_bd_pins ps7_axi_periph/M03_ACLK] \
      [get_bd_pins ps7_axi_periph/M04_ACLK] \
      [get_bd_pins ps7_axi_periph/M05_ACLK] \
      [get_bd_pins ps7_axi_periph/M06_ACLK] \
      [get_bd_pins axi_gpio_0/s_axi_aclk] \
      [get_bd_pins axi_gpio_1/s_axi_aclk] \
      [get_bd_pins axi_gpio_2/s_axi_aclk] \
      [get_bd_pins axi_iic_0/s_axi_aclk] \
      [get_bd_pins bluetooth_uart/s_axi_aclk] \
      [get_bd_pins ps7/M_AXI_GP0_ACLK] \
      [get_bd_pins ps7_axi_periph/ACLK] \
      [get_bd_pins axi_intc_0/s_axi_aclk] \
      [get_bd_pins xadc_wiz_0/s_axi_aclk]

   connect_bd_net [get_bd_pins ps7/FCLK_CLK1] [get_bd_pins bluetooth_uart/xin] 
   connect_bd_net [get_bd_pins proc_sys_reset_100MHz/interconnect_aresetn] [get_bd_pins ps7_axi_periph/ARESETN] 
   connect_bd_net [get_bd_pins proc_sys_reset_100MHz/peripheral_aresetn] \
      [get_bd_pins axi_gpio_0/s_axi_aresetn] \
      [get_bd_pins axi_gpio_1/s_axi_aresetn] \
      [get_bd_pins axi_gpio_2/s_axi_aresetn] \
      [get_bd_pins axi_iic_0/s_axi_aresetn] \
      [get_bd_pins bluetooth_uart/s_axi_aresetn] \
      [get_bd_pins axi_intc_0/s_axi_aresetn] \
      [get_bd_pins xadc_wiz_0/s_axi_aresetn] \
      [get_bd_pins ps7_axi_periph/S00_ARESETN] \
      [get_bd_pins ps7_axi_periph/M00_ARESETN] \
      [get_bd_pins ps7_axi_periph/M01_ARESETN] \
      [get_bd_pins ps7_axi_periph/M02_ARESETN] \
      [get_bd_pins ps7_axi_periph/M03_ARESETN] \
      [get_bd_pins ps7_axi_periph/M04_ARESETN] \
      [get_bd_pins ps7_axi_periph/M05_ARESETN] \
      [get_bd_pins ps7_axi_periph/M06_ARESETN] 

   connect_bd_net [get_bd_pins ps7/FCLK_CLK2] \
      [get_bd_pins microphone_mgr_0/clk_in] \
      [get_bd_pins pdm_filt_0/clk] \
      [get_bd_pins led_mgr_0/clk_in]

   connect_bd_net [get_bd_pins ps7/FCLK_RESET2_N] [get_bd_pins microphone_mgr_0/resetn_in] 

   connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins led_mgr_0/CPU_PL_LED_G]
   connect_bd_net [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins led_mgr_0/CPU_PL_LED_R]

   connect_bd_net [get_bd_pins microphone_mgr_0/AUDIO_PDM] [get_bd_pins pdm_filt_0/pdm_in]

   connect_bd_net [get_bd_pins pdm_filt_0/audio_out] [get_bd_pins led_mgr_0/AUDIO_RAW]

   connect_bd_net [get_bd_pins axi_gpio_2/gpio_io_t] [get_bd_pins led_mgr_0/GPIO_dir]
   connect_bd_net [get_bd_pins axi_gpio_2/gpio_io_o] [get_bd_pins led_mgr_0/GPIO_from_Zynq]
   connect_bd_net [get_bd_pins axi_gpio_2/gpio_io_i] [get_bd_pins led_mgr_0/GPIO_to_Zynq]

   connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In1]
   connect_bd_net [get_bd_pins bluetooth_uart/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins ps7/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
   connect_bd_net [get_bd_pins ps7/SDIO1_CDN] [get_bd_pins ps7/SDIO1_WP] [get_bd_pins xlconstant_1/dout]
   connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins xlconcat_0/In2]
   connect_bd_net [get_bd_pins xadc_wiz_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In3]

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
      [get_bd_pins clk_wiz_0/resetn] \
      [get_bd_pins led_mgr_0/resetn_in]

   connect_bd_net [get_bd_pins ps7/FCLK_RESET0_N] \
      [get_bd_pins proc_sys_reset_41MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_50MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_100MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_200MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_142MHz/ext_reset_in] \
      [get_bd_pins proc_sys_reset_166MHz/ext_reset_in] 

   connect_bd_net [get_bd_pins ps7/FCLK_CLK0] [get_bd_pins clk_wiz_0/clk_in1]

   connect_bd_net [get_bd_pins ps7/SDIO0_CLK] [get_bd_pins wireless_mgr_0/SDIO_CLK]
   connect_bd_net [get_bd_pins ps7/SDIO0_CLK_FB] [get_bd_pins wireless_mgr_0/SDIO_CLK_FB]
   connect_bd_net [get_bd_pins ps7/SDIO0_CMD_O] [get_bd_pins wireless_mgr_0/SDIO_CMD_from_Zynq]
   connect_bd_net [get_bd_pins ps7/SDIO0_CMD_I] [get_bd_pins wireless_mgr_0/SDIO_CMD_to_Zynq]
   connect_bd_net [get_bd_pins ps7/SDIO0_CMD_T] [get_bd_pins wireless_mgr_0/SDIO_CMD_dir]
   connect_bd_net [get_bd_pins ps7/SDIO0_DATA_O] [get_bd_pins wireless_mgr_0/SDIO_DATA_from_Zynq]
   connect_bd_net [get_bd_pins ps7/SDIO0_DATA_I] [get_bd_pins wireless_mgr_0/SDIO_DATA_to_Zynq]
   connect_bd_net [get_bd_pins ps7/SDIO0_DATA_T] [get_bd_pins wireless_mgr_0/SDIO_DATA_dir]
   connect_bd_net [get_bd_pins ps7/SDIO0_WP] [get_bd_pins wireless_mgr_0/SDIO_WP]
   connect_bd_net [get_bd_pins ps7/SDIO0_CDN] [get_bd_pins wireless_mgr_0/SDIO_CDN]
   connect_bd_net [get_bd_pins ps7/GPIO_O] [get_bd_pins wireless_mgr_0/GPIO_from_Zynq]
   connect_bd_net [get_bd_pins ps7/GPIO_I] [get_bd_pins wireless_mgr_0/GPIO_to_Zynq]
   connect_bd_net [get_bd_pins ps7/GPIO_T] [get_bd_pins wireless_mgr_0/GPIO_dir]
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
   
   connect_bd_net [get_bd_ports PL_LED_G] [get_bd_pins led_mgr_0/PL_LED_G]
   connect_bd_net [get_bd_ports PL_LED_R] [get_bd_pins led_mgr_0/PL_LED_R]
   connect_bd_net [get_bd_ports AUDIO_CLK] [get_bd_pins microphone_mgr_0/AUDIO_CLK]
   connect_bd_net [get_bd_ports AUDIO_DAT] [get_bd_pins microphone_mgr_0/AUDIO_DAT]

   save_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   set ps7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7 ]
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config { \
      make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells ps7]

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
      CONFIG.PCW_EN_CLK2_PORT {1} \
      CONFIG.PCW_EN_RST2_PORT {1} \
	] [get_bd_cells ps7]

   set ps7_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_axi_periph ]
   
   set_property -dict [ list \
   CONFIG.NUM_MI {07} \
   ] [get_bd_cells ps7_axi_periph]

   save_bd_design
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
   # set_property PFM.AXI_PORT { M0<x>_AXI {memport "M_AXI_GP" }} [get_bd_cells /ps7_axi_periph]
   # for all the interfaces M05_AXI to M31_AXI
   set parVal []
   for {set i 7} {$i < 32} {incr i} {
      lappend parVal M[format %02d $i]_AXI \
   {memport "M_AXI_GP"}
   }
   set_property PFM.AXI_PORT $parVal [get_bd_cells /ps7_axi_periph]

   #set_property PFM.AXI_PORT {M05_AXI {memport "M_AXI_GP" sptag "" memory ""} M06_AXI {memport "M_AXI_GP" sptag "" memory ""} M07_AXI {memport "M_AXI_GP" sptag "" memory ""} M08_AXI {memport "M_AXI_GP" sptag "" memory ""} M09_AXI {memport "M_AXI_GP" sptag "" memory ""} M10_AXI {memport "M_AXI_GP" sptag "" memory ""} M11_AXI {memport "M_AXI_GP" sptag "" memory ""} M12_AXI {memport "M_AXI_GP" sptag "" memory ""} M13_AXI {memport "M_AXI_GP" sptag "" memory ""} M14_AXI {memport "M_AXI_GP" sptag "" memory ""} M15_AXI {memport "M_AXI_GP" sptag "" memory ""} M16_AXI {memport "M_AXI_GP" sptag "" memory ""} M17_AXI {memport "M_AXI_GP" sptag "" memory ""} M18_AXI {memport "M_AXI_GP" sptag "" memory ""} M19_AXI {memport "M_AXI_GP" sptag "" memory ""} M20_AXI {memport "M_AXI_GP" sptag "" memory ""} M21_AXI {memport "M_AXI_GP" sptag "" memory ""} M22_AXI {memport "M_AXI_GP" sptag "" memory ""} M23_AXI {memport "M_AXI_GP" sptag "" memory ""} M24_AXI {memport "M_AXI_GP" sptag "" memory ""} M25_AXI {memport "M_AXI_GP" sptag "" memory ""} M26_AXI {memport "M_AXI_GP" sptag "" memory ""} M27_AXI {memport "M_AXI_GP" sptag "" memory ""} M28_AXI {memport "M_AXI_GP" sptag "" memory ""} M29_AXI {memport "M_AXI_GP" sptag "" memory ""} M30_AXI {memport "M_AXI_GP" sptag "" memory ""} M31_AXI {memport "M_AXI_GP" sptag "" memory ""}} [get_bd_cells /ps7_axi_periph]
 
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
   #set_property platform.post_sys_link_tcl_hook        ${projects_folder}/../../../boards/minized/minized_dynamic_postlink.tcl [current_project]
   #set_property platform.post_sys_link_overlay_tcl_hook        ${projects_folder}/../../../boards/minized/minized_dynamic_postlink.tcl [current_project]

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

