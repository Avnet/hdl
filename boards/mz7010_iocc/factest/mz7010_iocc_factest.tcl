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
#  Please direct any questions to the MicroZed community support forum:
#     http://avnet.me/microzed_forum
#
#  Product information is available at:
#     http://avnet.me/microzed
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
#  Create Date:         Oct 14, 2022
#  Design Name:         MicroZed Factory Test HW Platform
#  Module Name:         mz7020_iocc_factest.tcl
#  Project Name:        MicroZed Factory Test HW
#  Target Devices:      Xilinx Zynq-7020
#  Hardware Boards:     MicroZed SOM + I/O Carrier
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xc7z020clg400-1 -force
}

proc avnet_import_constraints {boards_folder board project} {

   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/bitstream_compression_enable.xdc
}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # this uses board automation for the MicroZed which is derived from the 
   # board definition file downloadable from the github.com/avnet/bdf git repository.

   # Create instance: proc_sys_reset_100MHz, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_100MHz

   # Create instance: xlconcat_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   set_property -dict [ list \
   CONFIG.NUM_PORTS {1} \
   ] [get_bd_cells xlconcat_0]

   # Create instance: xl_constant_0 and set to '0'.  We will connect this to the PS SDIO_0 WP input
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
   set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells xlconstant_0]

   # Create interface connections
   connect_bd_intf_net [get_bd_intf_pins ps7/M_AXI_GP0] [get_bd_intf_pins ps7_axi_periph/S00_AXI]
      
   # Connect the IP blocks, clocks, resets, etc.
   connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins ps7/SDIO0_WP]

   connect_bd_net [get_bd_pins proc_sys_reset_100MHz/interconnect_aresetn] [get_bd_pins ps7_axi_periph/ARESETN] 

   connect_bd_net [get_bd_pins ps7/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

   # Pmod_JA
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_0/S_AXI]
      
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_0]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_0/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_0/GPIO2]
   set_property name pmod_ja_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_ja_in [get_bd_intf_ports GPIO2_0]
   save_bd_design
   
   # Pmod_JB
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_1/S_AXI]
   
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_1]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_1/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_1/GPIO2]
   set_property name pmod_jb_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_jb_in [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # Pmod_JC
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_2

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_2/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_2/S_AXI]

   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_2]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_2/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_2/GPIO2]
   set_property name pmod_jc_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_jc_in [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # Pmod_JD
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_3/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_3/S_AXI]

   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_3]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_3/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_3/GPIO2]
   set_property name pmod_jd_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_jd_in [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # Pmod_JE
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_4

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_4/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_4/S_AXI]

   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_4]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_4/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_4/GPIO2]
   set_property name pmod_je_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_je_in [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # Pmod_JF
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_5

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_5/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_5/S_AXI]

   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_5]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_5/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_5/GPIO2]
   set_property name pmod_jf_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_jf_in [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # Pmod_JG
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_6

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_6/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_6/S_AXI]

   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_6]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_6/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_6/GPIO2]
   set_property name pmod_jg_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_jg_in [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # Pmod_JH
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_7

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_7/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_7/S_AXI]

   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_7]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_7/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_7/GPIO2]
   set_property name pmod_jh_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_jh_in [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # Pmod_JK
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_8

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_8/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_8/S_AXI]

   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_8]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_8/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_8/GPIO2]
   set_property name pmod_jk_out [get_bd_intf_ports GPIO_0]
   set_property name pmod_jk_in [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # PB Switches 4-bits (GPIO1) and DIP switches 4-bits (GPIO2)
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_9

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_9/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_9/S_AXI]

   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_GPIO2_WIDTH {4} \
      CONFIG.C_IS_DUAL {1} \
      CONFIG.C_ALL_INPUTS {1} \
      CONFIG.C_ALL_INPUTS_2 {1} \
      CONFIG.C_INTERRUPT_PRESENT {1}] [get_bd_cells axi_gpio_9]
      
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_9/GPIO]
   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_9/GPIO2]
   set_property name dip_sw_4bits [get_bd_intf_ports GPIO_0]
   set_property name pb_sw_4bits [get_bd_intf_ports GPIO2_0]
   save_bd_design

   # LEDs 8-bits
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_10

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/ps7/M_AXI_GP0} \
      Slave {/axi_gpio_10/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps7_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_10/S_AXI]
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {8} \
      CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_10]

   make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_10/GPIO]
   set_property name leds_8bits [get_bd_intf_ports GPIO_0]
  
   connect_bd_net [get_bd_pins axi_gpio_9/ip2intc_irpt] [get_bd_pins xlconcat_0/In0]

   save_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7 
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config { \
      make_external "FIXED_IO, DDR" \
      apply_board_preset "1" \
      Master "Disable" \
      Slave "Disable" }  [get_bd_cells ps7]

   # Enable the M_AXI_GP0 port on the PS
   set_property -dict [list CONFIG.PCW_USE_M_AXI_GP0 {1}] [get_bd_cells ps7]

   # Enable the PL-to-PS interrupts on the PS
   set_property -dict [list CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1}] [get_bd_cells ps7]

   # Bring the SDIO WP pin out to EMIO
   set_property -dict [list CONFIG.PCW_SD0_GRP_WP_ENABLE {1} CONFIG.PCW_SD0_GRP_WP_IO {EMIO}] [get_bd_cells ps7]

   # Set the SDIO to 50MHz instead of default 25 MHz
   set_property -dict [list CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50}] [get_bd_cells ps7]

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_axi_periph
   
   set_property -dict [ list \
      CONFIG.NUM_MI {01} ] [get_bd_cells ps7_axi_periph]

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
   # set_property PFM.AXI_PORT { M01_AXI {memport "M_AXI_GP" }} [get_bd_cells /ps7_axi_periph]
   # for all the interfaces M01_AXI to M31_AXI
   set parVal []
   for {set i 1} {$i < 32} {incr i} {
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
   #set_property platform.post_sys_link_tcl_hook        ${projects_folder}/../../../boards/mz7020_som/mz7020_som_dynamic_postlink.tcl [current_project]
   #set_property platform.post_sys_link_overlay_tcl_hook        ${projects_folder}/../../../boards/mz7020_som/mz7020_som_dynamic_postlink.tcl [current_project]

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

