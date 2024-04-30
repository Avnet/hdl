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
#     http://avnet.me/auboard-15p-forum
#
#  Product information is available at:
#     http://avnet.me/auboard-15p
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
#  Create Date:         Apr 11, 2024
#  Design Name:         AUBoard-15P HDMI HW Platform
#  Module Name:         aub15p_sbc_hdmi.tcl
#  Project Name:        AUBoard-15P HDMI
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


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {
   
   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
      return
   }
   
   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
      return
   }
   
   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
   create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
   create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB
   
   # Create pins
   create_bd_pin -dir I -type clk LMB_Clk
   create_bd_pin -dir I -type rst SYS_Rst
   
   # Create instance: dlmb_v10, and set properties
   set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]
   
   # Create instance: ilmb_v10, and set properties
   set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]
   
   # Create instance: dlmb_bram_if_cntlr, and set properties
   set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
   set_property CONFIG.C_ECC {0} $dlmb_bram_if_cntlr
   
   # Create instance: ilmb_bram_if_cntlr, and set properties
   set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
   set_property CONFIG.C_ECC {0} $ilmb_bram_if_cntlr
   
   # Create instance: lmb_bram, and set properties
   set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
   set_property -dict [list \
      CONFIG.Memory_Type {True_Dual_Port_RAM} \
      CONFIG.use_bram_block {BRAM_Controller} ] $lmb_bram
   
   # Create interface connections
   connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins dlmb_v10/LMB_M] [get_bd_intf_pins DLMB]
   connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB]
   connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
   connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ilmb_v10/LMB_M] [get_bd_intf_pins ILMB]
   connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB]
   connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
   
   # Create port connections
   connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst]
   connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
   connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst]
   connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst]
   
   connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk]
   connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]
   connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk]
   connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}


# Hierarchical cell: mb_ss_0
proc create_hier_cell_mb_ss_0 { parentCell nameHier } {
   
   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mb_ss_0() - Empty argument(s)!"}
      return
   }
   
   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
      return
   }
   
   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M06_AXI
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M08_AXI
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 sys_uart

save_bd_design
   
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 system_clock_300mhz
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S02_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S03_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S04_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S05_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S06_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S07_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S08_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S09_AXI

save_bd_design

   # Create pins
   create_bd_pin -dir I hdmi_rx_irq
   create_bd_pin -dir I hdmi_tx_irq
   create_bd_pin -dir I vphy_irq
   create_bd_pin -dir O -type clk hdmi_clk_out
   create_bd_pin -dir O -from 0 -to 0 dcm_locked
   create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
   create_bd_pin -dir O -type clk s_axi_aclk
   create_bd_pin -dir I -from 0 -to 0 system_resetn
   
   # Add DDR4 and connect defined board interfaces
   create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0
   apply_board_connection -board_interface "ddr4_sdram" -ip_intf "ddr4_0/C0_DDR4" -diagram "aub15p_sbc_hdmi" 
   apply_board_connection -board_interface "system_clock_300mhz" -ip_intf "ddr4_0/C0_SYS_CLK" -diagram "aub15p_sbc_hdmi" 

save_bd_design

   # Create instance: microblaze_0, and set properties
   set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]

save_bd_design

   apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { \
      axi_intc {1} \
      axi_periph {Enabled} \
      cache {32KB} \
      clk {/mb_ss_0/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      cores {1} \
      debug_module {Debug Only} \
      ecc {None} \
      local_mem {8KB} \
      preset {Application}}  [get_bd_cells microblaze_0]

save_bd_design

   #~ set_property -dict [list \
      #~ CONFIG.C_AREA_OPTIMIZED {0} \
      #~ CONFIG.C_DEBUG_ENABLED {1} \
      #~ CONFIG.C_D_AXI {1} \
      #~ CONFIG.C_D_LMB {1} \
      #~ CONFIG.C_I_LMB {1} \
      #~ CONFIG.C_FSL_LINKS {1} \
      #~ CONFIG.G_TEMPLATE_LIST {8} ] $microblaze_0
      
   # Create instance: microblaze_0_local_memory
   #~ create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory
   
   apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
      Clk_master {/mb_ss_0/ddr4_0/addn_ui_clkout1 (100 MHz)} \
      Clk_slave {/mb_ss_0/ddr4_0/c0_ddr4_ui_clk (300 MHz)} \
      Clk_xbar {Auto} \
      Master {/mb_ss_0/microblaze_0 (Cached)} \
      Slave {/mb_ss_0/ddr4_0/C0_DDR4_S_AXI} \
      ddr_seg {Auto} \
      intc_ip {New AXI SmartConnect} \
      master_apm {0}}  [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]

save_bd_design

   # Create instance: axi_interconnect_0, and set properties
   set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
   set_property CONFIG.NUM_MI {9} $axi_interconnect_0
   
   # Create instance: axi_interconnect_1, and set properties
   set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_1 ]
   set_property -dict [list \
      CONFIG.NUM_MI {1} \
      CONFIG=NUM_SI {10} ] $axi_interconnect_1

   # Create instance: microblaze_0_axi_intc, and set properties
   #~ set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 microblaze_0_axi_intc ]
   #~ set_property -dict [list \
      #~ CONFIG.C_HAS_FAST {1} \
      #~ CONFIG.C_PROCESSOR_CLK_FREQ_MHZ {99.951923} ] $microblaze_0_axi_intc
   
   # Create instance: microblaze_0_xlconcat, and set properties
   #~ set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]
   #~ set_property CONFIG.NUM_PORTS {5} $microblaze_0_xlconcat
   
move_bd_cells [get_bd_cells mb_ss_0] [get_bd_cells rst_ddr4_0_300M]
move_bd_cells [get_bd_cells mb_ss_0] [get_bd_cells mdm_1]
move_bd_cells [get_bd_cells mb_ss_0] [get_bd_cells rst_ddr4_0_100M]

save_bd_design

   # Create instance: mdm_1, and set properties
   set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
   
   # Create instance: system_resetn_inv_0, and set properties
   set system_resetn_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 system_resetn_inv_0 ]
   set_property -dict [list \
      CONFIG.C_OPERATION {not} \
      CONFIG.C_SIZE {1} ] $system_resetn_inv_0
   
   # Create instance: fmch_axi_iic, and set properties
   set fmch_axi_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 fmch_axi_iic ]
   
   # Create instance: clk_wiz_0, and set properties
   set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
   set_property -dict [list \
      CONFIG.CLKIN1_JITTER_PS {33.330000000000005} \
      CONFIG.CLKOUT1_JITTER {155.662} \
      CONFIG.CLKOUT1_PHASE_ERROR {313.647} \
      CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {297} \
      CONFIG.CLKOUT1_USED {true} \
      CONFIG.CLKOUT2_JITTER {180.541} \
      CONFIG.CLKOUT2_PHASE_ERROR {313.647} \
      CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100} \
      CONFIG.CLKOUT2_USED {true} \
      CONFIG.MMCM_CLKFBOUT_MULT_F {86.625} \
      CONFIG.MMCM_CLKIN1_PERIOD {3.333} \
      CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
      CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.375} \
      CONFIG.MMCM_CLKOUT1_DIVIDE {13} \
      CONFIG.MMCM_DIVCLK_DIVIDE {20} \
      CONFIG.NUM_OUT_CLKS {2} \
      CONFIG.PRIM_IN_FREQ {300.000} \
      CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} ] $clk_wiz_0
   
   # Create instance: axi_uartlite, and set properties
   set axi_uartlite [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite ]
   set_property CONFIG.C_BAUDRATE {115200} $axi_uartlite
   
   # Create instance: proc_sys_reset_0, and set properties
   set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
   set_property CONFIG.C_AUX_RESET_HIGH {0} $proc_sys_reset_0
   
   # Create instance: proc_sys_reset_1, and set properties
   set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]
   set_property CONFIG.C_AUX_RESET_HIGH {0} $proc_sys_reset_1
   
save_bd_design

   # Create interface connections
   connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_pins fmch_axi_iic/IIC] [get_bd_intf_pins IIC]
   connect_bd_intf_net -intf_net axi_uartlite_UART [get_bd_intf_pins axi_uartlite/UART] [get_bd_intf_pins sys_uart]
   connect_bd_intf_net -intf_net mdm_1_MBDEBUG_0  [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
   connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
   
save_bd_design

   connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins M00_AXI] 
   connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins M01_AXI] 
   connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins axi_interconnect_0/M02_AXI] [get_bd_intf_pins M02_AXI]
   connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins axi_uartlite/S_AXI]
   connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins fmch_axi_iic/S_AXI]
   connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins M05_AXI]
   connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins axi_interconnect_0/M06_AXI] [get_bd_intf_pins M06_AXI]
   connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_interconnect_0/M07_AXI] [get_bd_intf_pins microblaze_0_axi_intc/s_axi]
   connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins M08_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
   
save_bd_design

   connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
   connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
   connect_bd_intf_net -intf_net microblaze_0_interrupt [get_bd_intf_pins microblaze_0_axi_intc/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
   connect_bd_intf_net -intf_net system_clock_300mhz_1 [get_bd_intf_pins system_clock_300mhz] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
   
   # Create port connections
   connect_bd_net -net Reset_1 [get_bd_pins proc_sys_reset_0/mb_reset] [get_bd_pins microblaze_0/Reset]
   connect_bd_net -net Reset_1 [get_bd_pins proc_sys_reset_0/mb_reset] [get_bd_pins microblaze_0_axi_intc/processor_rst]
   
save_bd_design

   connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins fmch_axi_iic/iic2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In4]
   connect_bd_net -net axi_uartlite_interrupt [get_bd_pins axi_uartlite/interrupt] [get_bd_pins microblaze_0_xlconcat/In3]
   
save_bd_design

   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins axi_interconnect_0/M05_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins axi_interconnect_0/M08_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins hdmi_clk_out]
   
save_bd_design

   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0/Clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/S00_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/M00_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/M01_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/M02_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/M03_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/M04_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/M06_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_interconnect_0/M07_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_intc/processor_clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_local_memory/LMB_Clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins fmch_axi_iic/s_axi_aclk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_uartlite/s_axi_aclk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins s_axi_aclk]
   
save_bd_design

   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/aux_reset_in]
   
save_bd_design

   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_1/aux_reset_in]
   
save_bd_design

   connect_bd_net -net vphy_irq_1 [get_bd_pins vphy_irq] [get_bd_pins microblaze_0_xlconcat/In0]
   connect_bd_net -net hdmi_rx_irq_1 [get_bd_pins hdmi_rx_irq] [get_bd_pins microblaze_0_xlconcat/In1]
   connect_bd_net -net hdmi_tx_irq_1 [get_bd_pins hdmi_tx_irq] [get_bd_pins microblaze_0_xlconcat/In2]
   
save_bd_design

   connect_bd_net -net mdm_1_Debug_SYS_Rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst]
   connect_bd_net -net microblaze_0_intr [get_bd_pins microblaze_0_xlconcat/dout] [get_bd_pins microblaze_0_axi_intc/intr]
   connect_bd_net -net proc_sys_reset_0_bus_struct_reset [get_bd_pins proc_sys_reset_0/bus_struct_reset] [get_bd_pins microblaze_0_local_memory/SYS_Rst]
   connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]
   connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins dcm_locked]
   connect_bd_net -net rst_processor_0_100M_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins peripheral_aresetn] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins fmch_axi_iic/s_axi_aresetn] [get_bd_pins axi_uartlite/s_axi_aresetn]
   
save_bd_design

   connect_bd_net -net rst_processor_1_300M_interconnect_aresetn [get_bd_pins proc_sys_reset_1/interconnect_aresetn] [get_bd_pins axi_interconnect_0/M05_ARESETN]
   connect_bd_net -net rst_processor_1_300M_interconnect_aresetn [get_bd_pins proc_sys_reset_1/interconnect_aresetn] [get_bd_pins axi_interconnect_0/M08_ARESETN]
   
save_bd_design

   connect_bd_net -net system_resetn_1 [get_bd_pins system_resetn] [get_bd_pins system_resetn_inv_0/Op1]
   connect_bd_net -net system_resetn_1 [get_bd_pins system_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
   connect_bd_net -net system_resetn_1 [get_bd_pins system_resetn] [get_bd_pins proc_sys_reset_1/ext_reset_in]
   
save_bd_design

   connect_bd_net -net system_resetn_inv_0_Res [get_bd_pins system_resetn_inv_0/Res] [get_bd_pins clk_wiz_0/reset]
   
save_bd_design

   # Restore current instance
   current_bd_instance $oldCurInst
}


# Hierarchical cell: hdmi_tx
proc create_hier_cell_hdmi_tx { parentCell nameHier } {
   
   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hdmi_tx() - Empty argument(s)!"}
      return
   }
   
   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
      return
   }
   
   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA0_OUT
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA1_OUT
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA2_OUT
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 SB_STATUS_IN
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video1
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video2
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video3
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video4
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video5
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video6
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video7
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video8
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video9
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL
   
   # Create pins
   create_bd_pin -dir O LED1
   create_bd_pin -dir I TX_HPD_IN
   create_bd_pin -dir I -type clk ap_clk
   create_bd_pin -dir I -type rst ap_rst_n
   create_bd_pin -dir O -type intr interrupt
   create_bd_pin -dir O -type intr irq
   create_bd_pin -dir I -type clk link_clk
   create_bd_pin -dir I -type rst s_axi_cpu_aresetn
   create_bd_pin -dir I -type clk s_axis_audio_aclk
   create_bd_pin -dir I -type rst s_axis_video_aresetn
   create_bd_pin -dir I -type clk video_clk
   
   # Create instance: v_hdmi_tx_ss_0, and set properties
   set v_hdmi_tx_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_tx_ss:3.2 v_hdmi_tx_ss_0 ]
   set_property -dict [ list \
      CONFIG.C_INCLUDE_LOW_RESO_VID {true} \
      CONFIG.C_INCLUDE_YUV420_SUP {true} \
      CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} ] $v_hdmi_tx_ss_0
   
   # Create instance: v_mix_0, and set properties
   set v_mix_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_mix:5.2 v_mix_0 ]
   set_property -dict [ list \
      CONFIG.AXIMM_ADDR_WIDTH {64} \
      CONFIG.AXIMM_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO10_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO11_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO12_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO13_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO14_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO15_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO16_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO1_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO2_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO3_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO4_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO5_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO6_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO7_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO8_DATA_WIDTH {128} \
      CONFIG.C_M_AXI_MM_VIDEO9_DATA_WIDTH {128} \
      CONFIG.LAYER1_ALPHA {true} \
      CONFIG.LAYER1_VIDEO_FORMAT {28} \
      CONFIG.LAYER2_ALPHA {true} \
      CONFIG.LAYER2_VIDEO_FORMAT {28} \
      CONFIG.LAYER3_ALPHA {true} \
      CONFIG.LAYER3_VIDEO_FORMAT {28} \
      CONFIG.LAYER4_ALPHA {true} \
      CONFIG.LAYER4_VIDEO_FORMAT {28} \
      CONFIG.LAYER5_ALPHA {true} \
      CONFIG.LAYER5_VIDEO_FORMAT {29} \
      CONFIG.LAYER6_ALPHA {true} \
      CONFIG.LAYER6_VIDEO_FORMAT {29} \
      CONFIG.LAYER7_ALPHA {true} \
      CONFIG.LAYER7_UPSAMPLE {false} \
      CONFIG.LAYER7_VIDEO_FORMAT {29} \
      CONFIG.LAYER8_ALPHA {true} \
      CONFIG.LAYER8_VIDEO_FORMAT {29} \
      CONFIG.LAYER9_ALPHA {true} \
      CONFIG.LAYER9_VIDEO_FORMAT {26} \
      CONFIG.LOGO_LAYER {false} \
      CONFIG.NR_LAYERS {10} \
      CONFIG.SAMPLES_PER_CLOCK {2} ] $v_mix_0
   
   # Create instance: xlconstant_0, and set properties
   set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
   set_property -dict [ list \
      CONFIG.CONST_VAL {0} \
      CONFIG.CONST_WIDTH {48} ] $xlconstant_0
   
   # Create interface connections
   connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins m_axi_mm_video8] [get_bd_intf_pins v_mix_0/m_axi_mm_video8]
   connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins m_axi_mm_video9] [get_bd_intf_pins v_mix_0/m_axi_mm_video9]
   connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins m_axi_mm_video1] [get_bd_intf_pins v_mix_0/m_axi_mm_video1]
   connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins m_axi_mm_video2] [get_bd_intf_pins v_mix_0/m_axi_mm_video2]
   connect_bd_intf_net -intf_net S03_AXI_1 [get_bd_intf_pins m_axi_mm_video3] [get_bd_intf_pins v_mix_0/m_axi_mm_video3]
   connect_bd_intf_net -intf_net S04_AXI_1 [get_bd_intf_pins m_axi_mm_video4] [get_bd_intf_pins v_mix_0/m_axi_mm_video4]
   connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins S_AXI_CPU_IN] [get_bd_intf_pins v_hdmi_tx_ss_0/S_AXI_CPU_IN]
   connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins s_axi_CTRL] [get_bd_intf_pins v_mix_0/s_axi_CTRL]
   connect_bd_intf_net -intf_net v_hdmi_tx_ss_0_DDC_OUT [get_bd_intf_pins TX_DDC_OUT] [get_bd_intf_pins v_hdmi_tx_ss_0/DDC_OUT]
   connect_bd_intf_net -intf_net v_hdmi_tx_ss_0_LINK_DATA0_OUT [get_bd_intf_pins LINK_DATA0_OUT] [get_bd_intf_pins v_hdmi_tx_ss_0/LINK_DATA0_OUT]
   connect_bd_intf_net -intf_net v_hdmi_tx_ss_0_LINK_DATA1_OUT [get_bd_intf_pins LINK_DATA1_OUT] [get_bd_intf_pins v_hdmi_tx_ss_0/LINK_DATA1_OUT]
   connect_bd_intf_net -intf_net v_hdmi_tx_ss_0_LINK_DATA2_OUT [get_bd_intf_pins LINK_DATA2_OUT] [get_bd_intf_pins v_hdmi_tx_ss_0/LINK_DATA2_OUT]
   connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video5 [get_bd_intf_pins m_axi_mm_video5] [get_bd_intf_pins v_mix_0/m_axi_mm_video5]
   connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video6 [get_bd_intf_pins m_axi_mm_video6] [get_bd_intf_pins v_mix_0/m_axi_mm_video6]
   connect_bd_intf_net -intf_net v_mix_0_m_axi_mm_video7 [get_bd_intf_pins m_axi_mm_video7] [get_bd_intf_pins v_mix_0/m_axi_mm_video7]
   connect_bd_intf_net -intf_net v_mix_0_m_axis_video [get_bd_intf_pins v_hdmi_tx_ss_0/VIDEO_IN] [get_bd_intf_pins v_mix_0/m_axis_video]
   connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_status_sb_tx [get_bd_intf_pins SB_STATUS_IN] [get_bd_intf_pins v_hdmi_tx_ss_0/SB_STATUS_IN]
   
   # Create port connections
   connect_bd_net -net M06_ACLK_1 [get_bd_pins ap_clk] [get_bd_pins v_hdmi_tx_ss_0/s_axis_video_aclk] [get_bd_pins v_mix_0/ap_clk]
   connect_bd_net -net M06_ARESETN_1 [get_bd_pins s_axis_video_aresetn] [get_bd_pins v_hdmi_tx_ss_0/s_axis_video_aresetn]
   connect_bd_net -net Net [get_bd_pins link_clk] [get_bd_pins v_hdmi_tx_ss_0/link_clk]
   connect_bd_net -net TX_HPD_IN_1 [get_bd_pins TX_HPD_IN] [get_bd_pins v_hdmi_tx_ss_0/hpd]
   connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins v_hdmi_tx_ss_0/s_axi_cpu_aresetn]
   connect_bd_net -net v_hdmi_tx_ss_0_irq [get_bd_pins irq] [get_bd_pins v_hdmi_tx_ss_0/irq]
   connect_bd_net -net v_hdmi_tx_ss_0_locked [get_bd_pins LED1] [get_bd_pins v_hdmi_tx_ss_0/locked]
   connect_bd_net -net v_mix_0_interrupt [get_bd_pins interrupt] [get_bd_pins v_mix_0/interrupt]
   connect_bd_net -net vid_phy_controller_0_tx_video_clk [get_bd_pins video_clk] [get_bd_pins v_hdmi_tx_ss_0/video_clk]
   connect_bd_net -net xlconstant_0_dout [get_bd_pins v_mix_0/s_axis_video_TDATA] [get_bd_pins v_mix_0/s_axis_video_TVALID] [get_bd_pins xlconstant_0/dout]
   connect_bd_net -net xlslice_0_Dout [get_bd_pins ap_rst_n] [get_bd_pins v_mix_0/ap_rst_n]
   connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_axis_audio_aclk] [get_bd_pins v_hdmi_tx_ss_0/s_axi_cpu_aclk] [get_bd_pins v_hdmi_tx_ss_0/s_axis_audio_aclk]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}


# Hierarchical cell: hdmi_rx
proc create_hier_cell_hdmi_rx { parentCell nameHier } {
   
   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_hdmi_rx() - Empty argument(s)!"}
      return
   }
   
   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
      return
   }
   
   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA0_IN
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA1_IN
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 LINK_DATA2_IN
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 SB_STATUS_IN
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CPU_IN
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mm_video
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL1
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl
   
   # Create pins
   create_bd_pin -dir I RX_DET_IN
   create_bd_pin -dir O RX_HPD_OUT
   create_bd_pin -dir I -type clk aclk_axis
   create_bd_pin -dir I -type rst ap_rst_n
   create_bd_pin -dir I -type rst aresetn_ctrl
   create_bd_pin -dir O -type intr interrupt
   create_bd_pin -dir O -type intr irq
   create_bd_pin -dir I -type clk link_clk
   create_bd_pin -dir I -type rst s_axi_cpu_aresetn
   create_bd_pin -dir I -type clk s_axis_audio_aclk
   create_bd_pin -dir I -type rst s_axis_video_aresetn
   create_bd_pin -dir I -type clk video_clk
   
   # Create instance: v_frmbuf_wr_0, and set properties
   set v_frmbuf_wr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.4 v_frmbuf_wr_0 ]
   set_property -dict [ list \
      CONFIG.AXIMM_ADDR_WIDTH {64} \
      CONFIG.HAS_BGR8 {0} \
      CONFIG.HAS_BGRX8 {0} \
      CONFIG.HAS_INTERLACED {0} \
      CONFIG.HAS_RGB8 {0} \
      CONFIG.HAS_RGBX8 {0} \
      CONFIG.HAS_UYVY8 {1} \
      CONFIG.HAS_Y8 {1} \
      CONFIG.HAS_YUV8 {0} \
      CONFIG.HAS_YUVX8 {0} \
      CONFIG.HAS_YUYV8 {1} \
      CONFIG.HAS_Y_UV8 {0} \
      CONFIG.HAS_Y_UV8_420 {0} \
      CONFIG.MAX_NR_PLANES {1} ] $v_frmbuf_wr_0
   
   # Create instance: v_hdmi_rx_ss_0, and set properties
   set v_hdmi_rx_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_rx_ss:3.2 v_hdmi_rx_ss_0 ]
   set_property -dict [ list \
      CONFIG.C_CD_INVERT {true} \
      CONFIG.C_EXDES_NIDRU {false} ] $v_hdmi_rx_ss_0
   
   # Create instance: v_proc_ss_0, and set properties
   set v_proc_ss_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_0 ]
   set_property -dict [ list \
      CONFIG.C_ENABLE_CSC {true} \
      CONFIG.C_H_SCALER_TAPS {8} \
      CONFIG.C_MAX_DATA_WIDTH {8} \
      CONFIG.C_TOPOLOGY {0} \
      CONFIG.C_V_SCALER_TAPS {8} ] $v_proc_ss_0
   
   # Create interface connections
   connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins m_axi_mm_video] [get_bd_intf_pins v_frmbuf_wr_0/m_axi_mm_video]
   connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins S_AXI_CPU_IN] [get_bd_intf_pins v_hdmi_rx_ss_0/S_AXI_CPU_IN]
   connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins s_axi_CTRL1] [get_bd_intf_pins v_frmbuf_wr_0/s_axi_CTRL]
   connect_bd_intf_net -intf_net ps8_0_axi_periph_M10_AXI [get_bd_intf_pins s_axi_ctrl] [get_bd_intf_pins v_proc_ss_0/s_axi_ctrl]
   connect_bd_intf_net -intf_net v_hdmi_rx_ss_0_DDC_OUT [get_bd_intf_pins RX_DDC_OUT] [get_bd_intf_pins v_hdmi_rx_ss_0/DDC_OUT]
   connect_bd_intf_net -intf_net v_hdmi_rx_ss_0_VIDEO_OUT [get_bd_intf_pins v_hdmi_rx_ss_0/VIDEO_OUT] [get_bd_intf_pins v_proc_ss_0/s_axis]
   connect_bd_intf_net -intf_net v_proc_ss_0_m_axis [get_bd_intf_pins v_frmbuf_wr_0/s_axis_video] [get_bd_intf_pins v_proc_ss_0/m_axis]
   connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins LINK_DATA0_IN] [get_bd_intf_pins v_hdmi_rx_ss_0/LINK_DATA0_IN]
   connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins LINK_DATA1_IN] [get_bd_intf_pins v_hdmi_rx_ss_0/LINK_DATA1_IN]
   connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins LINK_DATA2_IN] [get_bd_intf_pins v_hdmi_rx_ss_0/LINK_DATA2_IN]
   connect_bd_intf_net -intf_net vid_phy_controller_0_vid_phy_status_sb_rx [get_bd_intf_pins SB_STATUS_IN] [get_bd_intf_pins v_hdmi_rx_ss_0/SB_STATUS_IN]
   
   # Create port connections
   connect_bd_net -net M06_ACLK_1 [get_bd_pins aclk_axis] [get_bd_pins v_frmbuf_wr_0/ap_clk] [get_bd_pins v_hdmi_rx_ss_0/s_axis_video_aclk] [get_bd_pins v_proc_ss_0/aclk_axis] [get_bd_pins v_proc_ss_0/aclk_ctrl]
   connect_bd_net -net M06_ARESETN_1 [get_bd_pins s_axis_video_aresetn] [get_bd_pins v_hdmi_rx_ss_0/s_axis_video_aresetn]
   connect_bd_net -net RX_DET_IN_1 [get_bd_pins RX_DET_IN] [get_bd_pins v_hdmi_rx_ss_0/cable_detect]
   connect_bd_net -net rst_ps8_0_99M_peripheral_aresetn [get_bd_pins s_axi_cpu_aresetn] [get_bd_pins v_hdmi_rx_ss_0/s_axi_cpu_aresetn]
   connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins interrupt] [get_bd_pins v_frmbuf_wr_0/interrupt]
   connect_bd_net -net v_hdmi_rx_ss_0_hpd [get_bd_pins RX_HPD_OUT] [get_bd_pins v_hdmi_rx_ss_0/hpd]
   connect_bd_net -net v_hdmi_rx_ss_0_irq [get_bd_pins irq] [get_bd_pins v_hdmi_rx_ss_0/irq]
   connect_bd_net -net vid_phy_controller_0_rx_video_clk [get_bd_pins video_clk] [get_bd_pins v_hdmi_rx_ss_0/video_clk]
   connect_bd_net -net vid_phy_controller_0_rxoutclk [get_bd_pins link_clk] [get_bd_pins v_hdmi_rx_ss_0/link_clk]
   connect_bd_net -net xlslice_1_Dout [get_bd_pins ap_rst_n] [get_bd_pins v_frmbuf_wr_0/ap_rst_n]
   connect_bd_net -net xlslice_4_Dout [get_bd_pins aresetn_ctrl] [get_bd_pins v_proc_ss_0/aresetn_ctrl]
   connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins s_axis_audio_aclk] [get_bd_pins v_hdmi_rx_ss_0/s_axi_cpu_aclk] [get_bd_pins v_hdmi_rx_ss_0/s_axis_audio_aclk]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}


# Hierarchical cell: blinky_counter_0
proc create_hier_cell_blinky_counter_0 { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_blinky_counter_0() - Empty argument(s)!"}
      return
   }
   
   # Get object for parentCell
   set parentObj [get_bd_cells $parentCell]
   if { $parentObj == "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
      return
   }
   
   # Make sure parentObj is hier blk
   set parentType [get_property TYPE $parentObj]
   if { $parentType ne "hier" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
      return
   }
   
   # Save current instance; Restore later
   set oldCurInst [current_bd_instance .]
   
   # Set parent object as current
   current_bd_instance $parentObj
   
   # Create cell and set as current instance
   set hier_obj [create_bd_cell -type hier $nameHier]
   current_bd_instance $hier_obj
   
   # Create pins
   create_bd_pin -dir I -type clk clk
   create_bd_pin -dir I -type rst aresetn
   create_bd_pin -dir O -from 0 -to 0 blinky_led
   
   # Create instance: c_counter_binary, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:c_counter_binary:12.0 c_counter_binary_0
   set_property -dict [list \
      CONFIG.Output_Width {25} \
      CONFIG.SCLR {true} ] [get_bd_cells c_counter_binary_0]
   
   # Create instance: xslice_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
   set_property -dict [list \
      CONFIG.DIN_FROM {24} \
      CONFIG.DIN_TO {24} \
      CONFIG.DIN_WIDTH {25} ] [get_bd_cells xlslice_0]
   
   # Create instance: util_vector_logic_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0
   set_property -dict [list \
      CONFIG.C_OPERATION {not} \
      CONFIG.C_SIZE {1} ] [get_bd_cells util_vector_logic_0]
   
   # Create port connections
   connect_bd_net [get_bd_pins aresetn] [get_bd_pins util_vector_logic_0/Op1]
   connect_bd_net [get_bd_pins clk] [get_bd_pins c_counter_binary_0/CLK]
   
   connect_bd_net [get_bd_pins util_vector_logic_0/Res] [get_bd_pins c_counter_binary_0/SCLR]
   
   connect_bd_net [get_bd_pins c_counter_binary_0/Q] [get_bd_pins xlslice_0/Din]
   
   connect_bd_net [get_bd_pins xlslice_0/Dout] [get_bd_pins blinky_led]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}





proc avnet_add_user_io_preset {project projects_folder scriptdir} {

   # Create interface ports
   create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 system_clock_300mhz
   set_property -dict [ list \
      CONFIG.FREQ_HZ {300000000} ] [get_bd_intf_port system_clock_300mhz]
   
   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 sys_uart
   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK297
   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT
   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT
   
   # Create ports
   create_bd_port -dir I -type rst system_resetn
   set_property -dict [ list \
      CONFIG.POLARITY {ACTIVE_LOW} ] [get_bd_port system_resetn]
    
   save_bd_design

   # Create instance: mb_ss_0
   create_hier_cell_mb_ss_0 [current_bd_instance .] mb_ss_0

   save_bd_design
   
   # Create instance: hdmi_tx
   create_hier_cell_hdmi_tx [current_bd_instance .] hdmi_tx

   save_bd_design
   
   # Create instance: hdmi_rx
   create_hier_cell_hdmi_rx [current_bd_instance .] hdmi_rx
   
   save_bd_design

   # Create instance: blinky_counter_0
   create_hier_cell_blinky_counter_0 [current_bd_instance .] blinky_counter_0
   
   # Create instance: vid_phy_controller, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:vid_phy_controller:2.2 vid_phy_controller
   set_property -dict [list \
      CONFIG.Adv_Clk_Mode {false} \
      CONFIG.CHANNEL_ENABLE {X0Y8 X0Y9 X0Y10} \
      CONFIG.CHANNEL_SITE {X0Y8} \
      CONFIG.C_FOR_UPGRADE_ARCHITECTURE {virtexuplus} \
      CONFIG.C_FOR_UPGRADE_DEVICE {xcvu9p} \
      CONFIG.C_FOR_UPGRADE_PACKAGE {flga2104} \
      CONFIG.C_FOR_UPGRADE_PART {xcvu9p-flga2104-2L-e} \
      CONFIG.C_FOR_UPGRADE_SPEEDGRADE {-2L} \
      CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
      CONFIG.C_INT_HDMI_VER_CMPTBLE {3} \
      CONFIG.C_NIDRU {false} \
      CONFIG.C_RX_PLL_SELECTION {0} \
      CONFIG.C_RX_REFCLK_SEL {1} \
      CONFIG.C_Rx_Protocol {HDMI} \
      CONFIG.C_TX_PLL_SELECTION {6} \
      CONFIG.C_TX_REFCLK_SEL {0} \
      CONFIG.C_Tx_Protocol {HDMI} \
      CONFIG.C_Txrefclk_Rdy_Invert {true} \
      CONFIG.C_Use_Oddr_for_Tmds_Clkout {true} \
      CONFIG.C_vid_phy_rx_axi4s_ch_INT_TDATA_WIDTH {20} \
      CONFIG.C_vid_phy_rx_axi4s_ch_TDATA_WIDTH {20} \
      CONFIG.C_vid_phy_rx_axi4s_ch_TUSER_WIDTH {1} \
      CONFIG.C_vid_phy_tx_axi4s_ch_INT_TDATA_WIDTH {20} \
      CONFIG.C_vid_phy_tx_axi4s_ch_TDATA_WIDTH {20} \
      CONFIG.C_vid_phy_tx_axi4s_ch_TUSER_WIDTH {1} \
      CONFIG.Rx_GT_Line_Rate {5.94} \
      CONFIG.Rx_GT_Ref_Clock_Freq {297} \
      CONFIG.Transceiver {GTHE4} \
      CONFIG.Tx_GT_Line_Rate {5.94} \
      CONFIG.Tx_GT_Ref_Clock_Freq {297} ] [get_bd_cells vid_phy_controller]
      
   
   save_bd_design
   #~ validate_bd_design
   #~ regenerate_bd_design
   #~ save_bd_design
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
   #assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

   # Instruction (2G)
   #assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

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

