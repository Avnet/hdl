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
#  Please direct any questions to the ZUBoard community support forum:
#     http://avnet.me/??
#
#  Product information is available at:
#     http://avnet.me/??
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
#  Create Date:         May 28, 2024
#  Design Name:         K24 IOCC Factory Test HW Platform
#  Module Name:         k24_iocc_factest.tcl
#  Project Name:        K24 IOCC Factory Test HW
#  Target Devices:      Xilinx Zynq UltraScale+ XCK24
#  Hardware Boards:     K24C SOM + I/O Carrier
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xck24-ubva530-2LV-c -force
}

proc avnet_import_constraints {boards_folder board project} {

   set bdf_path [file normalize [pwd]/../../bdf]
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.5 zynq_ultra_ps_e_0
   apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config { \
      apply_board_preset "1" } [get_bd_cells zynq_ultra_ps_e_0]
   set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]

   save_bd_design
}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # Add PL LEDs and RGB LED
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
   apply_board_connection -board_interface "som40_2_connector_pl_led_2bits" -ip_intf "axi_gpio_0/GPIO" -diagram "${project}"
   apply_board_connection -board_interface "som40_2_connector_pl_rgb_3bits" -ip_intf "axi_gpio_0/GPIO2" -diagram "${project}"
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {Auto} \
      Clk_xbar {Auto} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_gpio_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {New AXI Interconnect} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_0/S_AXI]

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {Auto} \
      Clk_slave {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM1_FPD} \
      Slave {/axi_gpio_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}} [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD]

   # Add PL Push Buttons
   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
   apply_board_connection -board_interface "som40_2_connector_pl_pb_2bits" -ip_intf "axi_gpio_1/GPIO" -diagram "${project}"
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_gpio_1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_1/S_AXI]

   # Create interface ports
   set click_out_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 click_out_1 ]
   set click_out_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 click_out_2 ]
   set pl_pmod_in [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_pmod_in ]
   set pl_pmod_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 pl_pmod_out ]
   set hsio_txr2_in_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 hsio_txr2_in_1 ]
   set hsio_txr2_in_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 hsio_txr2_in_2 ]
   set hsio_txr2_out_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 hsio_txr2_out_1 ]
   set hsio_txr2_out_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 hsio_txr2_out_2 ]


   # Create instance: click1, and set properties
   set click1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 click1 ]
   set_property -dict [list \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_GPIO_WIDTH {9} \
      CONFIG.C_IS_DUAL {0} \
   ] $click1

   # Create instance: click2, and set properties
   set click2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 click2 ]
   set_property -dict [list \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_GPIO_WIDTH {9} \
      CONFIG.C_IS_DUAL {0} \
   ] $click2

   # Create instance: pl_pmod_1, and set properties
   set pl_pmod_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_pmod_1 ]
   set_property -dict [list \
      CONFIG.C_ALL_INPUTS {1} \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_IS_DUAL {0} \
   ] $pl_pmod_1

   # Create instance: pl_pmod_2, and set properties
   set pl_pmod_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 pl_pmod_2 ]
   set_property -dict [list \
      CONFIG.C_ALL_INPUTS {0} \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_GPIO_WIDTH {4} \
      CONFIG.C_IS_DUAL {0} \
   ] $pl_pmod_2

   # Create instance: hsio_txr2_in1, and set properties
   set hsio_txr2_in1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 hsio_txr2_in1 ]
   set_property -dict [list \
      CONFIG.C_ALL_INPUTS {1} \
      CONFIG.C_GPIO_WIDTH {9} \
   ] $hsio_txr2_in1

   # Create instance: hsio_txr2_out1, and set properties
   set hsio_txr2_out1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 hsio_txr2_out1 ]
   set_property -dict [list \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_GPIO_WIDTH {9} \
   ] $hsio_txr2_out1


   # Create instance: hsio_txr2_in2, and set properties
   set hsio_txr2_in2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 hsio_txr2_in2 ]
   set_property -dict [list \
      CONFIG.C_ALL_INPUTS {1} \
      CONFIG.C_GPIO_WIDTH {9} \
   ] $hsio_txr2_in2

   # Create instance: hsio_txr2_out2, and set properties
   set hsio_txr2_out2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 hsio_txr2_out2 ]
   set_property -dict [list \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_GPIO_WIDTH {9} \
   ] $hsio_txr2_out2

   # Create interface connections
   connect_bd_intf_net -intf_net pl_pmod_1_GPIO [get_bd_intf_ports pl_pmod_in] [get_bd_intf_pins pl_pmod_1/GPIO]
   connect_bd_intf_net -intf_net pl_pmod_2_GPIO [get_bd_intf_ports pl_pmod_out] [get_bd_intf_pins pl_pmod_2/GPIO]
   connect_bd_intf_net -intf_net click2_GPIO [get_bd_intf_ports click_out_2] [get_bd_intf_pins click2/GPIO]
   connect_bd_intf_net -intf_net click1_GPIO [get_bd_intf_ports click_out_1] [get_bd_intf_pins click1/GPIO]
   connect_bd_intf_net -intf_net hsio_txr2_in1_GPIO [get_bd_intf_ports hsio_txr2_in_1] [get_bd_intf_pins hsio_txr2_in1/GPIO]
   connect_bd_intf_net -intf_net hsio_txr2_in2_GPIO [get_bd_intf_ports hsio_txr2_in_2] [get_bd_intf_pins hsio_txr2_in2/GPIO]
   connect_bd_intf_net -intf_net hsio_txr2_out1_GPIO [get_bd_intf_ports hsio_txr2_out_1] [get_bd_intf_pins hsio_txr2_out1/GPIO]
   connect_bd_intf_net -intf_net hsio_txr2_out2_GPIO [get_bd_intf_ports hsio_txr2_out_2] [get_bd_intf_pins hsio_txr2_out2/GPIO]


   # Apply BD automation
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/click1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins click1/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/click2/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins click2/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/hsio_txr2_in1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins hsio_txr2_in1/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/hsio_txr2_in2/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins hsio_txr2_in2/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/hsio_txr2_out1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins hsio_txr2_out1/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/hsio_txr2_out2/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins hsio_txr2_out2/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/pl_pmod_1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins pl_pmod_1/S_AXI]
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/pl_pmod_2/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins pl_pmod_2/S_AXI]

   regenerate_bd_layout
   save_bd_design
}

proc avnet_assign_addresses {project projects_folder scriptdir} {
   # Unassign all address segments
   delete_bd_objs [get_bd_addr_segs]
   delete_bd_objs [get_bd_addr_segs -excluded]

   # Hard-code specific address segments (used in device-tree or applications)
   # axi_gpio_0
   assign_bd_address -offset 0xA0000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force

   # axi_gpio_1
   assign_bd_address -offset 0xA0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] -force

   # click1
   assign_bd_address -offset 0xA0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs click1/S_AXI/Reg] -force

   # click2
   assign_bd_address -offset 0xA0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs click2/S_AXI/Reg] -force

   # hsio_txr2_in1
   assign_bd_address -offset 0xA0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hsio_txr2_in1/S_AXI/Reg] -force

   # hsio_txr2_in2
   assign_bd_address -offset 0xA0050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hsio_txr2_in2/S_AXI/Reg] -force

   # hsio_txr2_out1
   assign_bd_address -offset 0xA0060000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hsio_txr2_out1/S_AXI/Reg] -force

   # hsio_txr2_out2
   assign_bd_address -offset 0xA0070000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs hsio_txr2_out2/S_AXI/Reg] -force

   # pl_pmod_1
   assign_bd_address -offset 0xA0080000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_pmod_1/S_AXI/Reg] -force

   # pl_pmod_2
   assign_bd_address -offset 0xA0090000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs pl_pmod_2/S_AXI/Reg] -force

   assign_bd_address
}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}

   set_property platform.vendor                        "avnet.com" [current_project]
   set_property platform.board_id                      ${project} [current_project]
   set_property platform.name                          ${design_name} [current_project]
   set_property platform.version                       "1.0" [current_project]
   set_property platform.platform_state                "pre_synth" [current_project]
   set_property platform.ip_cache_dir                  [get_property ip_output_repo [current_project]] [current_project]
}
