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
#  Create Date:         Oct 3, 2024
#  Design Name:         K24 IOCC Duo HW Platform
#  Module Name:         k24_iocc_duo.tcl
#  Project Name:        K24 IOCC Duo HW
#  Target Devices:      Xilinx Zynq UltraScale+ XCK24
#  Hardware Boards:     K24C SOM + I/O Carrier + DualCam HSIO + DP-eMMC HSIO
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

   set_property -dict [list \
      CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
      CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
      CONFIG.PSU__DPAUX__PERIPHERAL__IO {EMIO} \
   ] [get_bd_cells zynq_ultra_ps_e_0]


      # CONFIG.PSU__SD0__PERIPHERAL__ENABLE {1} \
      # CONFIG.PSU__SD0__PERIPHERAL__IO {EMIO} \

# set_property -dict [list \
#   CONFIG.PSU__SD0__RESET__ENABLE {1} \
#   CONFIG.PSU__SD0__SLOT_TYPE {eMMC} \
# ] [get_bd_cells zynq_ultra_ps_e_0]


   # Set the DisplayPort reference clock to 135 MHz
   set_property -dict [list \
      CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk0} \
      CONFIG.PSU__DP__REF_CLK_FREQ {135} \
      CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {1} \
      CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {DPLL} \
      CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
      CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
  ] [get_bd_cells zynq_ultra_ps_e_0]

set_property -dict [list \
  CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {1} \
  CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {DPLL} \
  CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
  CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
] [get_bd_cells zynq_ultra_ps_e_0]
# create_bd_intf_port -mode Master -vlnv xilinx.com:interface:sdio_rtl:1.0 sdio
# connect_bd_intf_net [get_bd_intf_ports sdio] [get_bd_intf_pins zynq_ultra_ps_e_0/SDIO_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
     CONFIG.C_OPERATION {not} \
     CONFIG.C_SIZE {1}] [get_bd_cells util_vector_logic_0]
   
   connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_oe_n] [get_bd_pins util_vector_logic_0/Op1]
   make_bd_pins_external  [get_bd_pins util_vector_logic_0/Res]
   set_property name dp_aux_data_oe [get_bd_ports Res_0]

   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_out]
   set_property name dp_aux_data_out [get_bd_ports dp_aux_data_out_0]

   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/dp_aux_data_in]
   set_property name dp_aux_data_in [get_bd_ports dp_aux_data_in_0]

   make_bd_pins_external  [get_bd_pins zynq_ultra_ps_e_0/dp_hot_plug_detect]
   set_property name dp_hot_plug_detect [get_bd_ports dp_hot_plug_detect_0]

   
   #
   # HSIO I2C
   #
   # create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0
   # make_bd_intf_pins_external  [get_bd_intf_pins axi_iic_0/IIC]
   # set_property name hsio_i2c [get_bd_intf_ports IIC_0]

   # apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
   #    Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
   #    Clk_slave {Auto} \
   #    Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (99 MHz)} \
   #    Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_FPD} \
   #    Slave {/axi_iic_0/S_AXI} \
   #    ddr_seg {Auto} \
   #    intc_ip {/ps8_0_axi_periph} \
   #    master_apm {0}} [get_bd_intf_pins /axi_iic_0/S_AXI]


   #
   # Add the Concat block for the interrupts
   #
   # create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   # set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells xlconcat_0]
   # connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0]


   # connect_bd_net [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins xlconcat_0/In0]

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
