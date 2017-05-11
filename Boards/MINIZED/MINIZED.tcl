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
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xc7z007sclg225-1 -force
   # add selection for proper xdc based on needs

}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the MiniZed which is derived from the 
   # board definition file downloadable from the MiniZed.org community site.
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   apply_board_connection -board_interface "pl_sw_1bit" -ip_intf "axi_gpio_0/GPIO" -diagram $project 
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   apply_board_connection -board_interface "pl_leds_2bits" -ip_intf "axi_gpio_1/GPIO" -diagram $project 
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_gpio_0/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins axi_gpio_1/S_AXI]
   
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

   set processing_system7_0 [get_bd_cells processing_system7_0]
   
   set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {1}] [get_bd_cells processing_system7_0]

}
