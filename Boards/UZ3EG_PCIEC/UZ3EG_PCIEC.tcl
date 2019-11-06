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
#  Hardware Boards:     UltraZed, PCIe Carrier
# 
#  Tool versions:       Vivado 2017.2
# 
#  Description:         Build Script for UltraZed PCIe Carrier
# 
#  Dependencies:        To be called from a project build script
#
#  Revision:            Dec 21, 2016: 1.00 Initial version
#                       Aug 25, 2017: 1.01 Updated to remove ES1 for 2017.2
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
   
   startgroup
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   endgroup
   startgroup
   set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] [get_bd_cells axi_gpio_2]
   endgroup
   startgroup
   set_property -dict [list CONFIG.C_INTERRUPT_PRESENT {1}] [get_bd_cells axi_gpio_0]
   endgroup
   startgroup
   set_property -dict [list CONFIG.PSU__USE__IRQ0 {1}] [get_bd_cells zynq_ultra_ps_e_0]
   endgroup
   set_property -dict [list CONFIG.NUM_PORTS {2}] [get_bd_cells xlconcat_0]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]
   connect_bd_net [get_bd_pins axi_gpio_0/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins axi_gpio_2/ip2intc_irpt] [get_bd_pins xlconcat_0/In1]

   set_property name rst_ps8_0_100M [get_bd_cells rst_ps8_0_99M]

   # Redraw the BD and validate the design
   regenerate_bd_layout
   validate_bd_design
   
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]

   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]
   
   # Turn off the DisplayPort for the basic PetaLinux platform since having 
   # it enabled is causing 2017.2 PetaLinux to complain about PLL sharing 
   # when turning the DisplayPort audio on.
   #set_property -dict [list CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
   #set_property -dict [list CONFIG.PSU__PSS_ALT_REF_CLK__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
   set_property -dict [list CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]

   # Disable PCIe controller as well.
   set_property -dict [list CONFIG.PSU__PCIE__PERIPHERAL__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
   
   # Connect the SD card WP pin to MIO44 and pull it down to enable software (PetaLinux) 
   # to mount and write the SD card
   set_property -dict [list CONFIG.PSU__SD1__GRP_WP__ENABLE {1} CONFIG.PSU_MIO_44_PULLUPDOWN {pulldown}] [get_bd_cells zynq_ultra_ps_e_0]

}

proc avnet_add_sdsoc_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   #set_property PFM_NAME "em.avnet.com:av:${design_name}:1.0" [get_files ./${design_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd]
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