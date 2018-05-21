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
#  Create Date:         July 07, 2016
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq UltraScale+ 3EG
#  Hardware Boards:     Xilinx ZCU102
# 
#  Tool versions:       Vivado 2016.2
# 
#  Description:         Build Script for Xilinx ZCU102 Board
# 
#  Dependencies:        To be called from a project build script
# 
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu9eg-ffvb1156-1-i-es1 -force
   # add selection for proper xdc based on needs
   # if IO carrier, then use that xdc
   # if FMC, choose that one

}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the ZCU102 development board.
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   apply_board_connection -board_interface "dip_switches_8bits" -ip_intf "axi_gpio_0/GPIO" -diagram $project 
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   apply_board_connection -board_interface "led_8bits" -ip_intf "axi_gpio_1/GPIO" -diagram $project 
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2
   apply_board_connection -board_interface "push_buttons_5bits" -ip_intf "axi_gpio_2/GPIO" -diagram $project
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD" Clk "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]
   # </axi_gpio_0/S_AXI/Reg> is being mapped into </zynq_ultra_ps_e_0/Data> at <0x80000000 [ 64K ]>
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD" Clk "Auto" }  [get_bd_intf_pins axi_gpio_1/S_AXI]
   # </axi_gpio_1/S_AXI/Reg> is being mapped into </zynq_ultra_ps_e_0/Data> at <0x80010000 [ 64K ]>
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD" Clk "Auto" }  [get_bd_intf_pins axi_gpio_2/S_AXI]
   # </axi_gpio_2/S_AXI/Reg> is being mapped into </zynq_ultra_ps_e_0/Data> at <0x80020000 [ 64K ]>
   
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:1.2 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]

   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]
   
   # Not seeing the watchdog or TTC settings being implemented by the board 
   # definition settings from the official 2016.2 board definition from
   # Xilinx.  Forcing this controller to be enabled.
   set_property -dict [list CONFIG.PSU__CSU__PERIPHERAL__ENABLE {1} CONFIG.PSU__CSU__PERIPHERAL__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]
   set_property -dict [list CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} CONFIG.PSU__SWDT0__PERIPHERAL__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]
   set_property -dict [list CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} CONFIG.PSU__SWDT1__PERIPHERAL__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]
   set_property -dict [list CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} CONFIG.PSU__TTC0__PERIPHERAL__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]
   set_property -dict [list CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} CONFIG.PSU__TTC1__PERIPHERAL__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]
   set_property -dict [list CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} CONFIG.PSU__TTC2__PERIPHERAL__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]
   set_property -dict [list CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} CONFIG.PSU__TTC3__PERIPHERAL__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]
  
}

proc avnet_add_ps_displayport {project projects_folder scriptdir} {

   # DisplayPort GTR option is not enabled in 2016.2 board definition
   # file so this must be done manually (at least for this version)
   
   # Add proper XDC based on DisplayPort needs.
   add_files -fileset constrs_1 -norecurse $scriptdir/../Boards/ZCU102/zcu102_displayport.xdc
   
   # First disable the PCIE Port.
   set_property -dict [list CONFIG.PSU__PCIE__LANE0__ENABLE {0} CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
   
   # Enable the two DisplayPort GTRs.
   set_property -dict [list CONFIG.PSU__DP__LANE_SEL {Dual Lower} CONFIG.PSU__USB3_0__EMIO__ENABLE {0} CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
   
   # Create the DisplayPort AUX channel output enable inverter workaround.
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 dp_aux_data_oe_n_invert
   set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not} CONFIG.LOGO_FILE {data/sym_notgate.png}] [get_bd_cells dp_aux_data_oe_n_invert]
   
   # Connect the output enable inverter from the Zynq PS OE and then to an
   # external port.
   create_bd_port -dir O -from 0 -to 0 dp_aux_data_oe
   connect_bd_net [get_bd_pins /dp_aux_data_oe_n_invert/Res] [get_bd_ports dp_aux_data_oe]
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_oe_n] [get_bd_pins dp_aux_data_oe_n_invert/Op1]
   
   # Connect the DisplayPort AUX channel data externally.
   create_bd_port -dir O dp_aux_data_out
   connect_bd_net [get_bd_pins /zynq_ultra_ps_e_0/dp_aux_data_out] [get_bd_ports dp_aux_data_out]
}
