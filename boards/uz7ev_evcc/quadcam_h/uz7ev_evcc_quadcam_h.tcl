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
#  Please direct any questions to the UltraZed community support forum:
#     http://avnet.me/uzevforum
#
#  Product information is available at:
#     http://avnet.me/ultrazed-ev
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
#  Create Date:         Dec 11, 2020
#  Design Name:         UltraZed-EV QUADCAM (+HDMI) HW Platform
#  Module Name:         uz7ev_evcc_quadcam_h.tcl
#  Project Name:        UltraZed-EV QUADCAM_H HW
#  Target Devices:      Xilinx Zynq UltraScale+ 7EV
#  Hardware Boards:     UltraZed-EV SOM + EV Carrier + Quad Camera FMC
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu7ev-fbvb900-1-i -force
}

proc avnet_import_constraints {boards_folder board project} {

   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/hdmi.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/fmc_quad.xdc
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
  connect_bd_net -net xlconstant_gnd_dout [get_bd_pins xlconcat_interrupt_0/In0] [get_bd_pins xlconcat_interrupt_0/In1] [get_bd_pins xlconcat_interrupt_0/In2] [get_bd_pins xlconcat_interrupt_0/In3] [get_bd_pins xlconcat_interrupt_0/In4] [get_bd_pins xlconcat_interrupt_0/In5] [get_bd_pins xlconcat_interrupt_0/In6] [get_bd_pins xlconcat_interrupt_0/In7] [get_bd_pins xlconcat_interrupt_0/In8] [get_bd_pins xlconcat_interrupt_0/In9] [get_bd_pins xlconcat_interrupt_0/In10] [get_bd_pins xlconcat_interrupt_0/In11] [get_bd_pins xlconcat_interrupt_0/In12] [get_bd_pins xlconcat_interrupt_0/In13] [get_bd_pins xlconcat_interrupt_0/In14] [get_bd_pins xlconcat_interrupt_0/In15] [get_bd_pins xlconcat_interrupt_0/In16] [get_bd_pins xlconcat_interrupt_0/In17] [get_bd_pins xlconcat_interrupt_0/In18] [get_bd_pins xlconcat_interrupt_0/In19] [get_bd_pins xlconcat_interrupt_0/In20] [get_bd_pins xlconcat_interrupt_0/In21] [get_bd_pins xlconcat_interrupt_0/In22] [get_bd_pins xlconcat_interrupt_0/In23] [get_bd_pins xlconcat_interrupt_0/In24] [get_bd_pins xlconcat_interrupt_0/In25] [get_bd_pins xlconcat_interrupt_0/In26] [get_bd_pins xlconcat_interrupt_0/In27] [get_bd_pins xlconcat_interrupt_0/In28] [get_bd_pins xlconcat_interrupt_0/In29] [get_bd_pins xlconcat_interrupt_0/In30] [get_bd_pins xlconcat_interrupt_0/In31] [get_bd_pins xlconstant_gnd/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   endgroup
   startgroup
   set_property -dict [list CONFIG.PSU__USE__IRQ0 {1}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup
   set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]

   #

   #
   # VITIS ADDITIONS - START
   #  

   # Disable M_AXI_HPM1_FPD (keep available to VITIS for control interface)
   set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {0}] [get_bd_cells zynq_ultra_ps_e_0]

   # Add AXI interrupt controller (for VITIS XRT interrupt support)
   set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
   set_property -dict [ list \
      CONFIG.C_IRQ_IS_LEVEL {1} \
   ] $axi_intc_0
   #
   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   #create_hier_cell_interrupt_concat [current_bd_instance .] interrupt_concat
   #connect_bd_net -net interrupt_concat_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins interrupt_concat/dout]
   #
   set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/In0] [get_bd_pins axi_intc_0/irq]
   #
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins axi_intc_0/s_axi]
   
   set_property name rst_ps8_0_100M [get_bd_cells rst_ps8_0_99M]

   #delete_bd_objs [get_bd_nets proc_sys_reset_0_peripheral_aresetn1]
   #connect_bd_net [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn]

   #disconnect_bd_net /zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   #disconnect_bd_net /zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins proc_sys_reset_0/ext_reset_in]


   # Create clock wizard (with same clock frequencies as in zcu102_base/zcu104_base VITIS platforms)
   #   [0] 150 MHz
   #   [1] 300 MHz
   #   [2]  75 MHz
   #   [3] 100 MHz
   #   [4] 200 MHz
   #   [5] 400 MHz
   #   [6] 600 MHz
   set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
   set_property -dict [ list \
      CONFIG.CLKOUT1_JITTER {107.567} \
      CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150} \
      CONFIG.CLKOUT2_JITTER {94.862} \
      CONFIG.CLKOUT2_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300} \
      CONFIG.CLKOUT2_USED {true} \
      CONFIG.CLKOUT3_JITTER {122.158} \
      CONFIG.CLKOUT3_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {75} \
      CONFIG.CLKOUT3_USED {true} \
      CONFIG.CLKOUT4_JITTER {115.831} \
      CONFIG.CLKOUT4_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {100.000} \
      CONFIG.CLKOUT4_USED {true} \
      CONFIG.CLKOUT5_JITTER {102.086} \
      CONFIG.CLKOUT5_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {200.000} \
      CONFIG.CLKOUT5_USED {true} \
      CONFIG.CLKOUT6_JITTER {90.074} \
      CONFIG.CLKOUT6_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {400.000} \
      CONFIG.CLKOUT6_USED {true} \
      CONFIG.CLKOUT7_JITTER {83.768} \
      CONFIG.CLKOUT7_PHASE_ERROR {87.180} \
      CONFIG.CLKOUT7_REQUESTED_OUT_FREQ {600.000} \
      CONFIG.CLKOUT7_USED {true} \
      CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
      CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
      CONFIG.MMCM_CLKOUT2_DIVIDE {16} \
      CONFIG.MMCM_CLKOUT3_DIVIDE {12} \
      CONFIG.MMCM_CLKOUT4_DIVIDE {6} \
      CONFIG.MMCM_CLKOUT5_DIVIDE {3} \
      CONFIG.MMCM_CLKOUT6_DIVIDE {2} \
      CONFIG.NUM_OUT_CLKS {7} \
      CONFIG.RESET_PORT {resetn} \
      CONFIG.RESET_TYPE {ACTIVE_LOW} \
   ] $clk_wiz_0
   #
   set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
   set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
   set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]
   set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3 ]
   set proc_sys_reset_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_4 ]
   set proc_sys_reset_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_5 ]
   set proc_sys_reset_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_6 ]
   #
   connect_bd_net [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
   #
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out4 [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out5 [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins proc_sys_reset_4/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out6 [get_bd_pins clk_wiz_0/clk_out6] [get_bd_pins proc_sys_reset_5/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out7 [get_bd_pins clk_wiz_0/clk_out7] [get_bd_pins proc_sys_reset_6/slowest_sync_clk]
   #
   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked] [get_bd_pins proc_sys_reset_2/dcm_locked] [get_bd_pins proc_sys_reset_3/dcm_locked] [get_bd_pins proc_sys_reset_4/dcm_locked] [get_bd_pins proc_sys_reset_5/dcm_locked] [get_bd_pins proc_sys_reset_6/dcm_locked]
   #
   connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins clk_wiz_0/resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins proc_sys_reset_2/ext_reset_in] [get_bd_pins proc_sys_reset_3/ext_reset_in] [get_bd_pins proc_sys_reset_4/ext_reset_in] [get_bd_pins proc_sys_reset_5/ext_reset_in] [get_bd_pins proc_sys_reset_6/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]


   #
   # VITIS ADDITIONS - END
   #  
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]

   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]
   
   # Connect the SD card WP pin to MIO44 and pull it down to enable software (PetaLinux) 
   # to mount and write the SD card
   set_property -dict [list CONFIG.PSU__SD1__GRP_WP__ENABLE {1} CONFIG.PSU_MIO_44_PULLUPDOWN {pulldown}] [get_bd_cells zynq_ultra_ps_e_0]

}


proc avnet_add_hdmi {project projects_folder scriptdir} {

  # hdmi_rx blocks
  source $projects_folder/../../boards/uz7ev_evcc/hdmi/hdmi_rx.tcl
  create_hier_cell_hdmi_rx ./ hdmi_rx

  # hdmi_tx blocks
  source $projects_folder/../../boards/uz7ev_evcc/hdmi/hdmi_tx.tcl
  create_hier_cell_hdmi_tx ./ hdmi_tx

  #set_property -dict [list CONFIG.NUM_MI {9}] [get_bd_cells ps8_0_axi_periph]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins axi_intc_0/s_axi]

  # Create interface ports
  set RX_DDC_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT ]

  set TX_DDC_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT ]

  set fmch_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 fmch_iic ]


  # Create ports
  set HDMI_RX_CLK_N_IN [ create_bd_port -dir I HDMI_RX_CLK_N_IN ]
  set HDMI_RX_CLK_P_IN [ create_bd_port -dir I HDMI_RX_CLK_P_IN ]
  set HDMI_RX_DAT_N_IN [ create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN ]
  set HDMI_RX_DAT_P_IN [ create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN ]
  set HDMI_TX_CLK_N_OUT [ create_bd_port -dir O HDMI_TX_CLK_N_OUT ]
  set HDMI_TX_CLK_P_OUT [ create_bd_port -dir O HDMI_TX_CLK_P_OUT ]
  set HDMI_TX_DAT_N_OUT [ create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT ]
  set HDMI_TX_DAT_P_OUT [ create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT ]
  set LED1 [ create_bd_port -dir O LED1 ]
  set RX_DET_IN [ create_bd_port -dir I RX_DET_IN ]
  set RX_HPD_OUT [ create_bd_port -dir O RX_HPD_OUT ]
  set TX_EN_OUT [ create_bd_port -dir O -from 0 -to 0 TX_EN_OUT ]
  set TX_HPD_IN [ create_bd_port -dir I TX_HPD_IN ]
  set TX_HPD_LED [ create_bd_port -dir O TX_HPD_LED ]
  set TX_REFCLK_N_IN [ create_bd_port -dir I TX_REFCLK_N_IN ]
  set TX_REFCLK_P_IN [ create_bd_port -dir I TX_REFCLK_P_IN ]
  set TX_REFCLK_RDY_PB [ create_bd_port -dir I TX_REFCLK_RDY_PB ]

  create_bd_cell -type ip -vlnv xilinx.com:ip:vid_phy_controller:2.2 vid_phy_controller_0

  set_property -dict [list CONFIG.CHANNEL_ENABLE {X0Y16 X0Y17 X0Y18} CONFIG.Tx_GT_Line_Rate {5.94} CONFIG.Tx_Max_GT_Line_Rate {5.94} CONFIG.Tx_GT_Ref_Clock_Freq {297} CONFIG.Rx_GT_Line_Rate {5.94} CONFIG.Rx_Max_GT_Line_Rate {5.94} CONFIG.C_Tx_No_Of_Channels {3} CONFIG.C_Tx_Protocol {HDMI} CONFIG.C_Rx_No_Of_Channels {3} CONFIG.C_Rx_Protocol {HDMI} CONFIG.C_TX_REFCLK_SEL {0} CONFIG.C_RX_REFCLK_SEL {1} CONFIG.C_vid_phy_tx_axi4s_ch_TDATA_WIDTH {20} CONFIG.C_vid_phy_tx_axi4s_ch_INT_TDATA_WIDTH {20} CONFIG.C_vid_phy_rx_axi4s_ch_TDATA_WIDTH {20} CONFIG.C_vid_phy_rx_axi4s_ch_INT_TDATA_WIDTH {20} CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} CONFIG.C_Use_Oddr_for_Tmds_Clkout {true} CONFIG.C_Txrefclk_Rdy_Invert {true}  CONFIG.C_NIDRU {false}] [get_bd_cells vid_phy_controller_0]

  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hdmi_rx/LINK_DATA0_IN] [get_bd_intf_pins vid_phy_controller_0/vid_phy_rx_axi4s_ch0]
  connect_bd_intf_net [get_bd_intf_pins vid_phy_controller_0/vid_phy_rx_axi4s_ch1] -boundary_type upper [get_bd_intf_pins hdmi_rx/LINK_DATA1_IN]
  connect_bd_intf_net [get_bd_intf_pins vid_phy_controller_0/vid_phy_rx_axi4s_ch2] -boundary_type upper [get_bd_intf_pins hdmi_rx/LINK_DATA2_IN]
  connect_bd_intf_net [get_bd_intf_pins vid_phy_controller_0/vid_phy_status_sb_rx] -boundary_type upper [get_bd_intf_pins hdmi_rx/SB_STATUS_IN]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins vid_phy_controller_0/vid_phy_axi4lite]

  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hdmi_tx/LINK_DATA0_OUT] [get_bd_intf_pins vid_phy_controller_0/vid_phy_tx_axi4s_ch0]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hdmi_tx/LINK_DATA1_OUT] [get_bd_intf_pins vid_phy_controller_0/vid_phy_tx_axi4s_ch1]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hdmi_tx/LINK_DATA2_OUT] [get_bd_intf_pins vid_phy_controller_0/vid_phy_tx_axi4s_ch2]

  connect_bd_net [get_bd_ports TX_REFCLK_RDY_PB] [get_bd_pins vid_phy_controller_0/tx_refclk_rdy]

  connect_bd_net [get_bd_ports TX_REFCLK_P_IN] [get_bd_pins vid_phy_controller_0/mgtrefclk0_pad_p_in]
  connect_bd_net [get_bd_ports TX_REFCLK_N_IN] [get_bd_pins vid_phy_controller_0/mgtrefclk0_pad_n_in]
  connect_bd_net [get_bd_ports HDMI_RX_CLK_P_IN] [get_bd_pins vid_phy_controller_0/mgtrefclk1_pad_p_in]
  connect_bd_net [get_bd_ports HDMI_RX_CLK_N_IN] [get_bd_pins vid_phy_controller_0/mgtrefclk1_pad_n_in]

  connect_bd_net [get_bd_ports HDMI_RX_DAT_N_IN] [get_bd_pins vid_phy_controller_0/phy_rxn_in]
  connect_bd_net [get_bd_ports HDMI_RX_DAT_P_IN] [get_bd_pins vid_phy_controller_0/phy_rxp_in]
  connect_bd_net [get_bd_pins hdmi_tx/link_clk] [get_bd_pins vid_phy_controller_0/vid_phy_tx_axi4s_aclk]
  connect_bd_net [get_bd_pins vid_phy_controller_0/txoutclk] [get_bd_pins vid_phy_controller_0/vid_phy_tx_axi4s_aclk]

  # Create instance: vcc_const, and set properties
  set vcc_const [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc_const ]

  connect_bd_net [get_bd_ports TX_EN_OUT] [get_bd_pins vcc_const/dout]
  connect_bd_net [get_bd_pins vid_phy_controller_0/vid_phy_tx_axi4s_aresetn] [get_bd_pins vcc_const/dout]
  connect_bd_net [get_bd_pins vid_phy_controller_0/vid_phy_rx_axi4s_aresetn] [get_bd_pins vcc_const/dout]

  connect_bd_net [get_bd_pins vid_phy_controller_0/vid_phy_rx_axi4s_aclk] [get_bd_pins vid_phy_controller_0/rxoutclk]
  connect_bd_net [get_bd_pins hdmi_rx/link_clk] [get_bd_pins vid_phy_controller_0/rxoutclk]

  connect_bd_net [get_bd_pins vid_phy_controller_0/vid_phy_sb_aclk] [get_bd_pins vid_phy_controller_0/drpclk]
  connect_bd_net [get_bd_pins vid_phy_controller_0/vid_phy_axi4lite_aclk] [get_bd_pins vid_phy_controller_0/vid_phy_sb_aclk]
  connect_bd_net [get_bd_pins hdmi_rx/s_axis_audio_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins vid_phy_controller_0/vid_phy_sb_aresetn] [get_bd_pins vid_phy_controller_0/vid_phy_axi4lite_aresetn]
  connect_bd_net [get_bd_pins hdmi_tx/s_axi_cpu_aresetn] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn]
  connect_bd_net [get_bd_pins hdmi_rx/s_axi_cpu_aresetn] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn]

  connect_bd_net [get_bd_pins hdmi_tx/video_clk] [get_bd_pins vid_phy_controller_0/tx_video_clk]
  connect_bd_net [get_bd_ports HDMI_TX_CLK_P_OUT] [get_bd_pins vid_phy_controller_0/tx_tmds_clk_p]
  connect_bd_net [get_bd_ports HDMI_TX_CLK_N_OUT] [get_bd_pins vid_phy_controller_0/tx_tmds_clk_n]
  connect_bd_net [get_bd_pins hdmi_rx/video_clk] [get_bd_pins vid_phy_controller_0/rx_video_clk]
  connect_bd_net [get_bd_ports HDMI_TX_DAT_N_OUT] [get_bd_pins vid_phy_controller_0/phy_txn_out]
  connect_bd_net [get_bd_ports HDMI_TX_DAT_P_OUT] [get_bd_pins vid_phy_controller_0/phy_txp_out]

  set_property -dict [list CONFIG.PSU__USE__IRQ1 {1}] [get_bd_cells zynq_ultra_ps_e_0]

  create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1
  set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells xlconcat_1]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1] [get_bd_pins xlconcat_1/dout]
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_1
  set_property -dict [list CONFIG.C_IRQ_CONNECTION {1}] [get_bd_cells axi_intc_1]
  connect_bd_net [get_bd_pins axi_intc_1/irq] [get_bd_pins xlconcat_1/In0]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins axi_intc_1/s_axi]

  create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2
  set_property -dict [list CONFIG.NUM_PORTS {6}] [get_bd_cells xlconcat_2]
  connect_bd_net [get_bd_pins xlconcat_2/dout] [get_bd_pins axi_intc_1/intr]
  connect_bd_net [get_bd_pins xlconcat_2/In0] [get_bd_pins vid_phy_controller_0/irq]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins hdmi_tx/S_AXI_CPU_IN]

  connect_bd_intf_net [get_bd_intf_pins vid_phy_controller_0/vid_phy_status_sb_tx] -boundary_type upper [get_bd_intf_pins hdmi_tx/SB_STATUS_IN]

  set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]

  connect_bd_net [get_bd_ports TX_HPD_IN] [get_bd_pins hdmi_tx/TX_HPD_IN]
  connect_bd_net [get_bd_ports TX_HPD_LED] [get_bd_ports TX_HPD_IN]
  set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]

  create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
  create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1
  create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2
  set_property -dict [list CONFIG.DIN_WIDTH {95}] [get_bd_cells xlslice_0]
  set_property -dict [list CONFIG.DIN_TO {1} CONFIG.DIN_FROM {1} CONFIG.DIN_WIDTH {95} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_1]
  set_property -dict [list CONFIG.DIN_TO {2} CONFIG.DIN_FROM {2} CONFIG.DIN_WIDTH {95} CONFIG.DOUT_WIDTH {1}] [get_bd_cells xlslice_2]

  connect_bd_net [get_bd_pins xlslice_2/Din] [get_bd_pins xlslice_0/Din]
  connect_bd_net [get_bd_pins xlslice_1/Din] [get_bd_pins xlslice_2/Din]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o] [get_bd_pins xlslice_0/Din]

  # WARNING: Connect first the rst signals, before bd_automation. Otherwise will be connected to sys proc rst
  connect_bd_net [get_bd_pins hdmi_tx/ap_rst_n] [get_bd_pins xlslice_0/Dout]
  connect_bd_net [get_bd_pins hdmi_rx/aresetn_ctrl] [get_bd_pins xlslice_1/Dout]
  connect_bd_net [get_bd_pins hdmi_rx/ap_rst_n] [get_bd_pins xlslice_2/Dout]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins hdmi_tx/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins hdmi_rx/s_axi_CTRL1]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins hdmi_rx/s_axi_ctrl]

  connect_bd_net [get_bd_pins hdmi_tx/s_axis_video_aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]

  connect_bd_intf_net [get_bd_intf_ports TX_DDC_OUT] -boundary_type upper [get_bd_intf_pins hdmi_tx/TX_DDC_OUT]

  set_property -dict [list CONFIG.PSU__USE__S_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] [get_bd_pins clk_wiz_0/clk_out2]

  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1
  set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {1}] [get_bd_cells axi_interconnect_1]

  connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_1/ACLK]
  connect_bd_net [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect_1/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]

  connect_bd_net [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins clk_wiz_0/clk_out2]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video1]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video2]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video3]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video4]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video5]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video6]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video7]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video8]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_tx/m_axi_mm_video9]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins hdmi_rx/m_axi_mm_video]

  connect_bd_net [get_bd_ports LED1] [get_bd_pins hdmi_tx/LED1]
  connect_bd_net [get_bd_pins hdmi_tx/interrupt] [get_bd_pins xlconcat_2/In1]
  connect_bd_net [get_bd_pins hdmi_tx/irq] [get_bd_pins xlconcat_2/In2]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins hdmi_rx/S_AXI_CPU_IN]

  connect_bd_net [get_bd_ports RX_DET_IN] [get_bd_pins hdmi_rx/RX_DET_IN]
  connect_bd_net [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins hdmi_rx/s_axis_video_aresetn]
  connect_bd_intf_net [get_bd_intf_ports RX_DDC_OUT] -boundary_type upper [get_bd_intf_pins hdmi_rx/RX_DDC_OUT]
  connect_bd_net [get_bd_ports RX_HPD_OUT] [get_bd_pins hdmi_rx/RX_HPD_OUT]
  connect_bd_net [get_bd_pins xlconcat_2/In3] [get_bd_pins hdmi_rx/interrupt]
  connect_bd_net [get_bd_pins hdmi_rx/irq] [get_bd_pins xlconcat_2/In4]

  create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0
  connect_bd_intf_net [get_bd_intf_ports fmch_iic] [get_bd_intf_pins axi_iic_0/IIC]
  connect_bd_net [get_bd_pins xlconcat_2/In5] [get_bd_pins axi_iic_0/iic2intc_irpt]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins axi_iic_0/S_AXI]

  # modify axi interconnect strategy, seems to fix 'Bus Interface property DATA_WIDTH does not match ...' error
  # Removed as we now have a critical warning concerning SUPPORTS_NARROW_BURST
  #set_property -dict [list CONFIG.STRATEGY {2} CONFIG.S00_HAS_DATA_FIFO {2}] [get_bd_cells axi_interconnect_0]
}

proc avnet_add_fmc_quad {project projects_folder scriptdir} {

  # fmc_quad blocks
  source $projects_folder/../../boards/uz7ev_evcc/quadcam_h/fmc_quad.tcl
  create_hier_cell_fmc_quad ./ fmc_quad

  # Create interface ports
  set carrier_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 carrier_iic ]

  set csi_mipi_phy_if [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 csi_mipi_phy_if ]

  set fmc_multicam_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 fmc_multicam_iic ]

  # Create ports
  set bg1_pin0_nc_0 [ create_bd_port -dir I bg1_pin0_nc_0 ]
  set bg3_pin0_nc_0 [ create_bd_port -dir I bg3_pin0_nc_0 ]
  set fmc_multicam_iic_mux_rst_n [ create_bd_port -dir O -from 0 -to 0 fmc_multicam_iic_mux_rst_n ]
  set fmc_multicam_max9286_pwdn_n [ create_bd_port -dir O -from 0 -to 0 fmc_multicam_max9286_pwdn_n ]
  set fmc_multicam_max9296_pwdn_n [ create_bd_port -dir O -from 0 -to 0 fmc_multicam_max9296_pwdn_n ]
  set fmc_multicam_poc1_en [ create_bd_port -dir O -from 0 -to 0 fmc_multicam_poc1_en ]
  set fmc_multicam_poc1_int [ create_bd_port -dir I fmc_multicam_poc1_int ]
  set fmc_multicam_poc2_en [ create_bd_port -dir O -from 0 -to 0 fmc_multicam_poc2_en ]
  set fmc_multicam_poc2_int [ create_bd_port -dir I fmc_multicam_poc2_int ]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_0/v_demosaic_0/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_0/v_frmbuf_wr_0/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_0/v_proc_ss_csc_0/s_axi_ctrl]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_0/v_proc_ss_scaler_0/s_axi_ctrl]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_1/v_demosaic_1/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_1/v_frmbuf_wr_1/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_1/v_proc_ss_csc_1/s_axi_ctrl]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_1/v_proc_ss_scaler_1/s_axi_ctrl]


  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_2/v_demosaic_2/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_2/v_frmbuf_wr_2/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_2/v_proc_ss_csc_2/s_axi_ctrl]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_2/v_proc_ss_scaler_2/s_axi_ctrl]


  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_3/v_demosaic_3/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_3/v_frmbuf_wr_3/s_axi_CTRL]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_3/v_proc_ss_csc_3/s_axi_ctrl]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD" }  [get_bd_intf_pins fmc_quad/mipi_csi2_rx/capture_pipeline_3/v_proc_ss_scaler_3/s_axi_ctrl]
  

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins fmc_quad/S_AXI_iic]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins fmc_quad/csirxss_s_axi]
  
  connect_bd_intf_net [get_bd_intf_ports csi_mipi_phy_if] -boundary_type upper [get_bd_intf_pins fmc_quad/csi_mipi_phy_if]

  connect_bd_net [get_bd_pins fmc_quad/Din] [get_bd_pins zynq_ultra_ps_e_0/emio_gpio_o]
  connect_bd_net [get_bd_ports bg1_pin0_nc_0] [get_bd_pins fmc_quad/bg1_pin0_nc_0]
  connect_bd_net [get_bd_ports bg3_pin0_nc_0] [get_bd_pins fmc_quad/bg3_pin0_nc_0]
  connect_bd_net [get_bd_pins fmc_quad/dphy_clk_200M] [get_bd_pins clk_wiz_0/clk_out5]
  connect_bd_net [get_bd_ports fmc_multicam_poc1_int] [get_bd_pins fmc_quad/fmc_multicam_poc1_int]
  connect_bd_net [get_bd_ports fmc_multicam_poc2_int] [get_bd_pins fmc_quad/fmc_multicam_poc2_int]
  connect_bd_net [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins fmc_quad/video_aresetn]

  connect_bd_intf_net [get_bd_intf_ports fmc_multicam_iic] -boundary_type upper [get_bd_intf_pins fmc_quad/fmc_multicam_iic]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins fmc_quad/frmbuf_s2mm_0]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins fmc_quad/frmbuf_s2mm_1]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins fmc_quad/frmbuf_s2mm_2]
  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Slave "/zynq_ultra_ps_e_0/S_AXI_HP0_FPD" }  [get_bd_intf_pins fmc_quad/frmbuf_s2mm_3]

  set_property -dict [list CONFIG.NUM_PORTS {13}] [get_bd_cells xlconcat_2]

  connect_bd_net [get_bd_pins fmc_quad/csirxss_csi_irq] [get_bd_pins xlconcat_2/In6]
  connect_bd_net [get_bd_pins fmc_quad/fmc_multicam_iic_irq] [get_bd_pins xlconcat_2/In7]
  connect_bd_net [get_bd_pins fmc_quad/frmbuf_irq_0] [get_bd_pins xlconcat_2/In8]
  connect_bd_net [get_bd_pins fmc_quad/frmbuf_irq_1] [get_bd_pins xlconcat_2/In9]
  connect_bd_net [get_bd_pins fmc_quad/frmbuf_irq_2] [get_bd_pins xlconcat_2/In10]
  connect_bd_net [get_bd_pins fmc_quad/frmbuf_irq_3] [get_bd_pins xlconcat_2/In11]

  connect_bd_net [get_bd_ports fmc_multicam_max9286_pwdn_n] [get_bd_pins fmc_quad/fmc_multicam_max9286_pwdn_n]
  connect_bd_net [get_bd_ports fmc_multicam_iic_mux_rst_n] [get_bd_pins fmc_quad/fmc_multicam_iic_mux_rst_n]
  connect_bd_net [get_bd_ports fmc_multicam_max9296_pwdn_n] [get_bd_pins fmc_quad/fmc_multicam_max9296_pwdn_n]
  connect_bd_net [get_bd_ports fmc_multicam_poc1_en] [get_bd_pins fmc_quad/fmc_multicam_poc1_en]
  connect_bd_net [get_bd_ports fmc_multicam_poc2_en] [get_bd_pins fmc_quad/fmc_multicam_poc2_en]

  # Create instance: axi_iic_1, and set properties
  set axi_iic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1 ]

  apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD" }  [get_bd_intf_pins axi_iic_1/S_AXI]
  connect_bd_intf_net [get_bd_intf_ports carrier_iic] [get_bd_intf_pins axi_iic_1/IIC]
  connect_bd_net [get_bd_pins axi_iic_1/iic2intc_irpt] [get_bd_pins xlconcat_2/In12]

}

proc avnet_add_comments {project projects_folder scriptdir} {
  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_0 "GPIOs
  -----
  [00] - 78: Video Mixer rst
  [01] - 79: HDMI Rx VPSS Scaler rst
  [02] - 80: HDMI Rx FB WR rst
  [03] - 81:
  [04] - 82: CSI VPSS Scaler rst
  [05] - 83: CSI FB WR rst
  [06] - 84: CSI VPSS CSC rst
  [07] - 85: CSI Demosaic rst
  [08] - 86:
  [09] - 87:
  [10] - 88:
  [11] - 89:
  [12] - 90: Sensor rst
  [13] - 91: 
  [14] - 92: CSI VPSS CSC 1 rst
  [15] - 93: CSI VPSS CSC 2 rst
  [16] - 94: CSI VPSS CSC 3 rst
  ----
  [20] - 98: CSI Demosaic 1 rst
  [21] - 99: CSI Scaler 1 rst
  [22] - 100: CSI FB WR 1 rst
  [23] - 101: CSI Demosaic 2 rst
  [24] - 102: CSI Scaler 2 rst
  [25] - 103: CSI FB WR 2 rst
  [26] - 104: CSI Demosaic 3 rst
  [27] - 105: CSI Scaler 3 rst
  [28] - 106: CSI FB WR 3 rst
  ----
  [30] - 108: FMC_MULTICAM_POC1_EN
  [31] - 109: FMC_MULTICAM_POC2_EN
  [32] - 110: FMC_MULTICAM_MAX9286_PWDN_N
  [33] - 111: FMC_MULTICAM_MAX9296_PWDN_N
  [34] - 112: FMC_MULTICAM_I2C_MUX_RST_N
  [35] - 113: FMC_MULTICAM_MAX9286_GPI/FSYNC
  "   [current_bd_design]
}

proc avnet_assign_addresses {project projects_folder scriptdir} {
    # Unassign all address segments
  delete_bd_objs [get_bd_addr_segs]
  delete_bd_objs [get_bd_addr_segs -excluded]

  # Hard-code specific address segments (used in device-tree or applications)
  assign_bd_address -offset 0xa0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xB0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hdmi_tx/v_mix_0/s_axi_CTRL/Reg] -force
  
  assign_bd_address

}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   set_property PFM_NAME "em.avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

   # define clock and reset ports
   set_property PFM.CLOCK { \
	clk_out1 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_0" status "fixed"} \
	clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_1" status "fixed"} \
	clk_out3 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_2" status "fixed"} \
	clk_out4 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_3" status "fixed"} \
	clk_out5 {id "4" is_default "false" proc_sys_reset "/proc_sys_reset_4" status "fixed"} \
	clk_out6 {id "5" is_default "false" proc_sys_reset "/proc_sys_reset_5" status "fixed"} \
	clk_out7 {id "6" is_default "false" proc_sys_reset "/proc_sys_reset_6" status "fixed"} \
   } [get_bd_cells /clk_wiz_0]


   # define AXI ports
   set_property PFM.AXI_PORT { \
	M_AXI_HPM0_LPD {memport "M_AXI_GP" sptag "HPM0_LPD"} \
	S_AXI_HPC0_FPD {memport "S_AXI_HP" sptag "HPC0" memory "zynq_ultra_ps_e_0 HPC0_DDR_LOW"} \
	S_AXI_HPC1_FPD {memport "S_AXI_HP" sptag "HPC1" memory "zynq_ultra_ps_e_0 HPC1_DDR_LOW"} \
	S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "zynq_ultra_ps_e_0 HP1_DDR_LOW"} \
	S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "zynq_ultra_ps_e_0 HP2_DDR_LOW"} \
	S_AXI_HP3_FPD {memport "S_AXI_HP" sptag "HP3" memory "zynq_ultra_ps_e_0 HP3_DDR_LOW"} \
   } [get_bd_cells /zynq_ultra_ps_e_0]

   set_property PFM.AXI_PORT { \
  M09_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
  M10_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
  M11_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
  M12_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
  M13_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
  M14_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
  M15_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
  M16_AXI {memport "M_AXI_GP" sptag "HPM0_FPD" memory ""} \
   } [get_bd_cells /ps8_0_axi_periph]

   # required for Vitis 2020.1
   # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   # define interrupt ports
   set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]
  
   # Set platform project properties
   set_property platform.description                   "UZ7EV_EVCC_QUADCAM_H development platform" [current_project]
   set_property platform.uses_pr                       false         [current_project]

   set_property platform.design_intent.server_managed  "false" [current_project]
   set_property platform.design_intent.external_host   "false" [current_project]
   set_property platform.design_intent.embedded        "true" [current_project]
   set_property platform.design_intent.datacenter      "false" [current_proj]

   # specific to Vitis 2019.2, no longer applicable for Vitis 2020.1
   #set_property platform.post_sys_link_tcl_hook        ${projects_folder}/../../../Boards/UZ7EV_EVCC/UZ7EV_EVCC_dynamic_postlink.tcl [current_project]

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

