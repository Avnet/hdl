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
#     http://avnet.me/zuboard-1cg-forum
#
#  Product information is available at:
#     http://avnet.me/zuboard-1cg
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
#  Create Date:         Dec 05, 2023
#  Design Name:         AUBoard-15P Validation Test HW Platform
#  Module Name:         aub15p_sbc_valtest.tcl
#  Project Name:        AUBoard-15P Validation Test
#  Target Devices:      Xilinx Artix UltraScale+ 15P
#  Hardware Boards:     AUBoard-15P Board
#
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xcau15p-ffvb676-2-e -force
   set_property platform.extensible false [current_project]
}

proc avnet_import_constraints {boards_folder board project} {

   set bdf_path [file normalize [pwd]/../../bdf]
   import_files -fileset constrs_1 -norecurse ${boards_folder}/${board}/${project}/${board}_${project}.xdc
   import_files -fileset constrs_1 -norecurse ${bdf_path}/aub15p/1.0/AUBoard_temp.xdc
}

proc create_hier_cell_mux2to1 { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_mux2to1() - Empty argument(s)!"}
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
   create_bd_pin -dir I -from 2 -to 0 In1
   create_bd_pin -dir I -from 2 -to 0 In2
   create_bd_pin -dir I Sel
   create_bd_pin -dir O -from 2 -to 0 Mux_out
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
      CONFIG.C_OPERATION {and} \
      CONFIG.LOGO_FILE {data/sym_andgate.png} \
      CONFIG.C_SIZE {3}] [get_bd_cells util_vector_logic_0]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1
   set_property -dict [list \
      CONFIG.C_OPERATION {and} \
      CONFIG.LOGO_FILE {data/sym_andgate.png} \
      CONFIG.C_SIZE {3}] [get_bd_cells util_vector_logic_1]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2
   set_property -dict [list \
      CONFIG.C_OPERATION {or} \
      CONFIG.LOGO_FILE {data/sym_orgate.png} \
      CONFIG.C_SIZE {3}] [get_bd_cells util_vector_logic_2]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3
   set_property -dict [list \
      CONFIG.C_OPERATION {not} \
      CONFIG.LOGO_FILE {data/sym_notgate.png} \
      CONFIG.C_SIZE {3}] [get_bd_cells util_vector_logic_3]
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
   set_property -dict [list CONFIG.NUM_PORTS {3}] [get_bd_cells xlconcat_0]
   
   connect_bd_net [get_bd_pins Sel] [get_bd_pins xlconcat_0/In0]
   connect_bd_net [get_bd_pins Sel] [get_bd_pins xlconcat_0/In1]
   connect_bd_net [get_bd_pins Sel] [get_bd_pins xlconcat_0/In2]
   
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins util_vector_logic_3/Op1]
   connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins util_vector_logic_1/Op2]
   
   connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_2/Op1]
   connect_bd_net [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_2/Op2]
   connect_bd_net [get_bd_pins util_vector_logic_3/Res] [get_bd_pins util_vector_logic_0/Op2]
   
   connect_bd_net [get_bd_pins In1] [get_bd_pins util_vector_logic_0/Op1]
   connect_bd_net [get_bd_pins In2] [get_bd_pins util_vector_logic_1/Op1]
   connect_bd_net [get_bd_pins util_vector_logic_2/Res] [get_bd_pins Mux_out]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

proc create_hier_cell_or2b1 { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_or2b1() - Empty argument(s)!"}
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
   
   create_bd_pin -dir I -from 0 -to 0 In1
   create_bd_pin -dir I -from 0 -to 0 In2_B
   create_bd_pin -dir O -from 0 -to 0 Or_out
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
      CONFIG.C_SIZE {1} \
      CONFIG.C_OPERATION {or} \
      CONFIG.LOGO_FILE {data/sym_orgate.png}] [get_bd_cells util_vector_logic_0]
   
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1
   set_property -dict [list \
      CONFIG.C_OPERATION {not} \
      CONFIG.LOGO_FILE {data/sym_notgate.png} \
      CONFIG.C_SIZE {1}] [get_bd_cells util_vector_logic_1]
   

   connect_bd_net [get_bd_pins In1] [get_bd_pins util_vector_logic_0/Op1]
   connect_bd_net [get_bd_pins In2_B] [get_bd_pins util_vector_logic_1/Op1]
   connect_bd_net [get_bd_pins util_vector_logic_1/Res] [get_bd_pins util_vector_logic_0/Op2]
   
   connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins Or_out]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

proc create_hier_cell_or2 { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_or2() - Empty argument(s)!"}
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
   create_bd_pin -dir I -from 0 -to 0 In1
   create_bd_pin -dir I -from 0 -to 0 In2
   create_bd_pin -dir O -from 0 -to 0 Or_out
   
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
      CONFIG.C_SIZE {1} \
      CONFIG.C_OPERATION {or} \
      CONFIG.LOGO_FILE {data/sym_orgate.png}] [get_bd_cells util_vector_logic_0]
   
   connect_bd_net [get_bd_pins In1] [get_bd_pins util_vector_logic_0/Op1]
   connect_bd_net [get_bd_pins In2] [get_bd_pins util_vector_logic_0/Op2]
   connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins Or_out]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   #
   # Add DDR4 and connect defined board interfaces
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0
   apply_board_connection -board_interface "ddr4_sdram" -ip_intf "ddr4_0/C0_DDR4" -diagram "aub15p_sbc_valtest" 
   apply_board_connection -board_interface "system_clock_300mhz" -ip_intf "ddr4_0/C0_SYS_CLK" -diagram "aub15p_sbc_valtest" 

   #
   # Add MicroBlaze and connect defined board interfaces
   #
   create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0

   apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { \
      axi_intc {1} \
      axi_periph {Enabled} \
      cache {32KB} \
      clk {/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      cores {1} \
      debug_module {Debug Only} \
      ecc {None} \
      local_mem {8KB} \
      preset {Application}}  [get_bd_cells microblaze_0]

   apply_bd_automation -rule xilinx.com:bd_rule:board -config { \
      Board_Interface {system_reset ( FPGA Reset ) } \
      Manual_Source {Auto}}  [get_bd_pins ddr4_0/sys_rst]

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      Clk_slave {/ddr4_0/c0_ddr4_ui_clk (300 MHz)} \
      Clk_xbar {Auto} \
      Master {/microblaze_0 (Cached)} \
      Slave {/ddr4_0/C0_DDR4_S_AXI} \
      ddr_seg {Auto} \
      intc_ip {New AXI SmartConnect} \
      master_apm {0}}  [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]

   apply_bd_automation -rule xilinx.com:bd_rule:board -config { \
      Board_Interface {Custom} \
      Manual_Source {/ddr4_0/c0_ddr4_ui_clk_sync_rst (ACTIVE_HIGH)}}  [get_bd_pins rst_ddr4_0_100M/ext_reset_in]

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
   apply_board_connection -board_interface "sys_uart" -ip_intf "axi_uartlite_0/UART" -diagram "aub15p_sbc_valtest" 
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      Master {/microblaze_0 (Periph)} \
      Slave {/axi_uartlite_0/S_AXI} \
      ddr_seg {Auto} \
      intc_ip {/microblaze_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins axi_uartlite_0/S_AXI]
   
   set_property CONFIG.C_BAUDRATE {115200} [get_bd_cells axi_uartlite_0]

   set_property CONFIG.ADDN_UI_CLKOUT2_FREQ_HZ {125} [get_bd_cells ddr4_0]

   create_bd_cell -type ip -vlnv xilinx.com:ip:tri_mode_ethernet_mac:9.0 tri_mode_ethernet_mac_0
   apply_board_connection -board_interface "mii_ethernet" -ip_intf "tri_mode_ethernet_mac_0/mii" -diagram "aub15p_sbc_valtest" 
   apply_board_connection -board_interface "mdio_io" -ip_intf "tri_mode_ethernet_mac_0/mdio_internal" -diagram "aub15p_sbc_valtest" 
   
   apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { \
      Clk {/ddr4_0/addn_ui_clkout2 (125 MHz)} \
      Freq {100} \
      Ref_Clk0 {} \
      Ref_Clk1 {} \
      Ref_Clk2 {}}  [get_bd_pins tri_mode_ethernet_mac_0/gtx_clk]

   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      Clk_slave {Auto} \
      Clk_xbar {/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      Master {/microblaze_0 (Periph)} \
      Slave {/tri_mode_ethernet_mac_0/s_axi} \
      ddr_seg {Auto} \
      intc_ip {/microblaze_0_axi_periph} \
      master_apm {0}}  [get_bd_intf_pins tri_mode_ethernet_mac_0/s_axi]

   connect_bd_net [get_bd_pins rst_ddr4_0_100M/peripheral_aresetn] [get_bd_pins tri_mode_ethernet_mac_0/tx_axi_rstn]
   connect_bd_net [get_bd_pins rst_ddr4_0_100M/peripheral_aresetn] [get_bd_pins tri_mode_ethernet_mac_0/glbl_rstn]
   connect_bd_net [get_bd_pins rst_ddr4_0_100M/peripheral_aresetn] [get_bd_pins tri_mode_ethernet_mac_0/rx_axi_rstn]
   connect_bd_net [get_bd_pins rst_ddr4_0_100M/peripheral_aresetn] [get_bd_pins tri_mode_ethernet_mac_0/s_axi_resetn]
   connect_bd_net [get_bd_pins tri_mode_ethernet_mac_0/mac_irq] [get_bd_pins microblaze_0_xlconcat/In0]
   connect_bd_net [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In1]

   validate_bd_design

   save_bd_design







   #~ #
   #~ # VITIS ADDITIONS - START
   #~ #
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
   #~ set_property -dict [list \
      #~ CONFIG.CLKOUT1_JITTER {107.567} \
      #~ CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {150.000} \
      #~ CONFIG.CLKOUT2_JITTER {94.862} \
      #~ CONFIG.CLKOUT2_PHASE_ERROR {87.180} \
      #~ CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300.000} \
      #~ CONFIG.CLKOUT2_USED {true} \
      #~ CONFIG.CLKOUT3_JITTER {122.158} \
      #~ CONFIG.CLKOUT3_PHASE_ERROR {87.180} \
      #~ CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {75.000} \
      #~ CONFIG.CLKOUT3_USED {true} \
      #~ CONFIG.CLKOUT4_JITTER {115.831} \
      #~ CONFIG.CLKOUT4_PHASE_ERROR {87.180} \
      #~ CONFIG.CLKOUT4_USED {true} \
      #~ CONFIG.CLKOUT5_JITTER {102.086} \
      #~ CONFIG.CLKOUT5_PHASE_ERROR {87.180} \
      #~ CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {200.000} \
      #~ CONFIG.CLKOUT5_USED {true} \
      #~ CONFIG.CLKOUT6_JITTER {90.074} \
      #~ CONFIG.CLKOUT6_PHASE_ERROR {87.180} \
      #~ CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {400.000} \
      #~ CONFIG.CLKOUT6_USED {true} \
      #~ CONFIG.CLKOUT7_JITTER {83.768} \
      #~ CONFIG.CLKOUT7_PHASE_ERROR {87.180} \
      #~ CONFIG.CLKOUT7_REQUESTED_OUT_FREQ {600.000} \
      #~ CONFIG.CLKOUT7_USED {true} \
      #~ CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
      #~ CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
      #~ CONFIG.MMCM_CLKOUT2_DIVIDE {16} \
      #~ CONFIG.MMCM_CLKOUT3_DIVIDE {12} \
      #~ CONFIG.MMCM_CLKOUT4_DIVIDE {6} \
      #~ CONFIG.MMCM_CLKOUT5_DIVIDE {3} \
      #~ CONFIG.MMCM_CLKOUT6_DIVIDE {2} \
      #~ CONFIG.NUM_OUT_CLKS {7} \
      #~ CONFIG.RESET_PORT {reset} \
      #~ CONFIG.RESET_TYPE {ACTIVE_HIGH} \
      #~ CONFIG.USE_LOCKED {true} ] [get_bd_cells clk_wiz_0]
      
   #~ apply_bd_automation -rule xilinx.com:bd_rule:board -config { \
      #~ Clk {/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      #~ Manual_Source {Auto}}  [get_bd_pins clk_wiz_0/clk_in1]

   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_4
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_5
   #~ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_6

   #~ connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/clk_out3] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/clk_out4] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/clk_out5] [get_bd_pins proc_sys_reset_4/slowest_sync_clk]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/clk_out6] [get_bd_pins proc_sys_reset_5/slowest_sync_clk]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/clk_out7] [get_bd_pins proc_sys_reset_6/slowest_sync_clk]

   #~ connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_2/dcm_locked]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_3/dcm_locked]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_4/dcm_locked]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_5/dcm_locked]
   #~ connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_6/dcm_locked]

   #~ connect_bd_net [get_bd_pins rst_ddr4_0_100M/mb_reset] [get_bd_pins proc_sys_reset_0/ext_reset_in]
   #~ connect_bd_net [get_bd_pins rst_ddr4_0_100M/mb_reset] [get_bd_pins proc_sys_reset_1/ext_reset_in]
   #~ connect_bd_net [get_bd_pins rst_ddr4_0_100M/mb_reset] [get_bd_pins proc_sys_reset_2/ext_reset_in]
   #~ connect_bd_net [get_bd_pins rst_ddr4_0_100M/mb_reset] [get_bd_pins proc_sys_reset_3/ext_reset_in]
   #~ connect_bd_net [get_bd_pins rst_ddr4_0_100M/mb_reset] [get_bd_pins proc_sys_reset_4/ext_reset_in]
   #~ connect_bd_net [get_bd_pins rst_ddr4_0_100M/mb_reset] [get_bd_pins proc_sys_reset_5/ext_reset_in]
   #~ connect_bd_net [get_bd_pins rst_ddr4_0_100M/mb_reset] [get_bd_pins proc_sys_reset_6/ext_reset_in]

   #~ connect_bd_net [get_bd_pins rst_ddr4_0_100M/mb_reset] [get_bd_pins clk_wiz_0/reset]

   #~ #
   #~ # VITIS ADDITIONS - END
   #~ #

   regenerate_bd_layout
   save_bd_design
}

proc avnet_add_ps_preset {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   save_bd_design
}


proc avnet_assign_addresses {project projects_folder scriptdir} {
   # Unassign all address segments
   delete_bd_objs [get_bd_addr_segs]
   delete_bd_objs [get_bd_addr_segs -excluded]

   # Hard-code specific address segments (used in device-tree or applications)
   #Slave segment '/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK' is being assigned into address space '/microblaze_0/Data' at <0x8000_0000 [ 2G ]>.
   #Slave segment '/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK' is being assigned into address space '/microblaze_0/Instruction' at <0x8000_0000 [ 2G ]>.

   # Data (2G)
   assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

   # Instruction (2G)
   assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

   assign_bd_address
}

proc avnet_add_vitis_directives {project projects_folder scriptdir} {
   set design_name ${project}
   
   #~ set_property PFM_NAME "avnet.com:av:${project}:1.0" [get_files ${projects_folder}/${project}.srcs/sources_1/bd/${project}/${project}.bd]

   #~ # define clock and reset ports
   #~ set_property PFM.CLOCK { \
      #~ clk_out1 {id "0" is_default "true" proc_sys_reset "proc_sys_reset_0" status "fixed"} \
      #~ clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_1" status "fixed"} \
      #~ clk_out3 {id "2" is_default "false" proc_sys_reset "/proc_sys_reset_2" status "fixed"} \
      #~ clk_out4 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_3" status "fixed"} \
      #~ clk_out5 {id "4" is_default "false" proc_sys_reset "/proc_sys_reset_4" status "fixed"} \
      #~ clk_out6 {id "5" is_default "false" proc_sys_reset "/proc_sys_reset_5" status "fixed"} \
      #~ clk_out7 {id "6" is_default "false" proc_sys_reset "/proc_sys_reset_6" status "fixed"} \
   #~ } [get_bd_cells /clk_wiz_0]


   #~ # define AXI ports
   #~ set_property PFM.AXI_PORT { \
      #~ M_AXI_HPM1_FPD {memport "M_AXI_GP"} \
      #~ S_AXI_HPC0_FPD {memport "S_AXI_HPC" sptag "HPC0" memory "zynq_ultra_ps_e_0 HPC0_DDR_LOW"} \
      #~ S_AXI_HPC1_FPD {memport "S_AXI_HPC" sptag "HPC1" memory "zynq_ultra_ps_e_0 HPC1_DDR_LOW"} \
      #~ S_AXI_HP0_FPD {memport "S_AXI_HP" sptag "HP0" memory "zynq_ultra_ps_e_0 HP0_DDR_LOW"} \
      #~ S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "zynq_ultra_ps_e_0 HP1_DDR_LOW"} \
      #~ S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "zynq_ultra_ps_e_0 HP2_DDR_LOW"} \
      #~ S_AXI_HP3_FPD {memport "S_AXI_HP" sptag "HP3" memory "zynq_ultra_ps_e_0 HP3_DDR_LOW"} \
   #~ } [get_bd_cells /zynq_ultra_ps_e_0]

   #~ # required for Vitis 2020.1 onwards
   #~ # reference : https://github.com/Xilinx/Vitis-In-Depth-Tutorial/blob/master/Vitis_Platform_Creation/Introduction/02-Edge-AI-ZCU104/step1.md
   #~ # define interrupt ports
   #~ set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells microblaze_0_axi_intc]
  
   #~ # Set platform project properties
   #~ set_property platform.description                   "Valtest AUBoard-15P development platform" [current_project]
   #~ set_property platform.uses_pr                       false         [current_project]

   #~ set_property platform.design_intent.server_managed  "false" [current_project]
   #~ set_property platform.design_intent.external_host   "false" [current_project]
   #~ set_property platform.design_intent.embedded        "true" [current_project]
   #~ set_property platform.design_intent.datacenter      "false" [current_proj]

   #~ set_property platform.vendor                        "avnet.com" [current_project]
   #~ set_property platform.board_id                      ${project} [current_project]
   #~ set_property platform.name                          ${design_name} [current_project]
   #~ set_property platform.version                       "1.0" [current_project]
   #~ set_property platform.platform_state                "pre_synth" [current_project]
   #~ set_property platform.ip_cache_dir                  [get_property ip_output_repo [current_project]] [current_project]

   #~ # recommnded to use "sd_card" for Vitis 2020.1 onwards
   #~ # reference : https://github.com/Xilinx/Vitis_Embedded_Platform_Source/blob/2020.1/Xilinx_Official_Platforms/zcu104_base/vivado/xilinx_zcu104_base_202010_1_xsa.tcl
   #~ #set_property platform.default_output_type           "xclbin" [current_project]
   #~ set_property platform.default_output_type           "sd_card" [current_project]

   #~ set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
   #~ set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
   #~ set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
}

