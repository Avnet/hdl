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
#  Create Date:         July 01, 2016
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq UltraScale+ 3EG
#  Hardware Boards:     UltraZed, IO Carrier
# 
#  Tool versions:       Vivado 2017.2
# 
#  Description:         Build Script for UltraZed IO Carrier
# 
#  Dependencies:        To be called from a project build script
# 
#  Revision:            Jul 01, 2016: 1.00 Initial version
#                       Aug 23, 2017: 1.01 Updated to remove ES1 for 2017.2
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xczu3eg-sfva625-1-i -force
   # add selection for proper xdc based on needs
   # if IO carrier, then use that xdc
   # if FMC, choose that one

}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the UZ SOM which is derived from the 
   # board definition file downloadable from the UltraZed.org community site.
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   apply_board_connection -board_interface "dip_switches_8bits" -ip_intf "axi_gpio_0/GPIO" -diagram $project 
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   apply_board_connection -board_interface "led_8bits" -ip_intf "axi_gpio_1/GPIO" -diagram $project 
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2
   apply_board_connection -board_interface "push_buttons_3bits" -ip_intf "axi_gpio_2/GPIO" -diagram $project
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD" Clk "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]
   # </axi_gpio_0/S_AXI/Reg> is being mapped into </zynq_ultra_ps_e_0/Data> at <0x80000000 [ 64K ]>
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD" Clk "Auto" }  [get_bd_intf_pins axi_gpio_1/S_AXI]
   # </axi_gpio_1/S_AXI/Reg> is being mapped into </zynq_ultra_ps_e_0/Data> at <0x80010000 [ 64K ]>
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD" Clk "Auto" }  [get_bd_intf_pins axi_gpio_2/S_AXI]
   # </axi_gpio_2/S_AXI/Reg> is being mapped into </zynq_ultra_ps_e_0/Data> at <0x80020000 [ 64K ]>
   
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.1 zynq_ultra_ps_e_0
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

   # Turn off the DisplayPort for the basic PetaLinux platform since having 
   # it enabled is causing 2017.2 PetaLinux to complain about PLL sharing 
   # when turning the DisplayPort audio on.
   #set_property -dict [list CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
   #set_property -dict [list CONFIG.PSU__PSS_ALT_REF_CLK__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
   set_property -dict [list CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]

   # The eMMC and SD card interfaces run at 50 MHz rates so the frequency 
   # specified in the 2017.2 BDF should be overridden here.
   #set_property -dict [list CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__FREQMHZ {50}] [get_bd_cells zynq_ultra_ps_e_0]
   #set_property -dict [list CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {50}] [get_bd_cells zynq_ultra_ps_e_0]
}
