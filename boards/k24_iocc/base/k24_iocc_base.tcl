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
#  Please direct any questions to the K24 community support forum:
#     http://avnet.me/k24-dk-forum
#
#  Product information is available at:
#     http://avnet.me/k24-dk
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
#  Create Date:         May 23, 2024
#  Design Name:         K24 IOCC Base HW Platform
#  Module Name:         k24_iocc_base.tcl
#  Project Name:        K24 IOCC Base HW
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
   apply_board_connection -board_interface "som_connectors_pl_led_2bits" -ip_intf "axi_gpio_0/GPIO" -diagram "${project}"
   apply_board_connection -board_interface "som_connectors_pl_rgb_3bits" -ip_intf "axi_gpio_0/GPIO2" -diagram "${project}"
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
   apply_board_connection -board_interface "som_connectors_pl_pb_2bits" -ip_intf "axi_gpio_1/GPIO" -diagram "${project}"
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
      Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
      Slave {/axi_gpio_1/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/ps8_0_axi_periph} \
      master_apm {0}} [get_bd_intf_pins axi_gpio_1/S_AXI]

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
