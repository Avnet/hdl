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
   
# Hierarchical cell: v_tpg_ss_0
proc create_hier_cell_v_tpg_ss_0 { parentCell nameHier } {
   
   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_v_tpg_ss_0() - Empty argument(s)!"}
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
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_CTRL
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_video
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI
   
   # Create pins
   create_bd_pin -dir I -type clk s_axi_aclk
   create_bd_pin -dir I -type rst s_axi_aresetn
   
   # Create instance: v_tpg, and set properties
   set v_tpg [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tpg:8.2 v_tpg ]
   set_property -dict [list \
      CONFIG.COLOR_SWEEP {0} \
      CONFIG.DISPLAY_PORT {0} \
      CONFIG.FOREGROUND {0} \
      CONFIG.HAS_AXI4S_SLAVE {1} \
      CONFIG.MAX_DATA_WIDTH {8} \
      CONFIG.RAMP {0} \
      CONFIG.SAMPLES_PER_CLOCK {2} \
      CONFIG.SOLID_COLOR {0} \
      CONFIG.ZONE_PLATE {0} ] $v_tpg
   
   
   # Create instance: axi_gpio, and set properties
   set axi_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio ]
   set_property -dict [list \
      CONFIG.C_ALL_OUTPUTS {1} \
      CONFIG.C_GPIO_WIDTH {1} ] $axi_gpio
   
   
   # Create interface connections
   connect_bd_intf_net -intf_net mb_ss_0_M05_AXI [get_bd_intf_pins s_axi_CTRL] [get_bd_intf_pins v_tpg/s_axi_CTRL]
   connect_bd_intf_net -intf_net mb_ss_0_M08_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_gpio/S_AXI]
   connect_bd_intf_net -intf_net rx_video_axis_reg_slice_M_AXIS [get_bd_intf_pins s_axis_video] [get_bd_intf_pins v_tpg/s_axis_video]
   connect_bd_intf_net -intf_net v_tpg_m_axis_video [get_bd_intf_pins m_axis_video] [get_bd_intf_pins v_tpg/m_axis_video]
   
   # Create port connections
   connect_bd_net -net mb_ss_0_dcm_locked [get_bd_pins s_axi_aresetn] [get_bd_pins axi_gpio/s_axi_aresetn]
   connect_bd_net -net mb_ss_0_hdmi_clk_out [get_bd_pins s_axi_aclk] [get_bd_pins axi_gpio/s_axi_aclk]
   connect_bd_net -net mb_ss_0_hdmi_clk_out [get_bd_pins s_axi_aclk] [get_bd_pins v_tpg/ap_clk]
   connect_bd_net -net net_axi_gpio_gpio_io_o [get_bd_pins axi_gpio/gpio_io_o] [get_bd_pins v_tpg/ap_rst_n]
   
   # Restore current instance
   current_bd_instance $oldCurInst
}

# Hierarchical cell: audio_ss_0
proc create_hier_cell_audio_ss_0 { parentCell nameHier } {

   variable script_folder
   
   if { $parentCell eq "" || $nameHier eq "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_audio_ss_0() - Empty argument(s)!"}
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
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 axis_audio_in
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_audio_out
   
   # Create pins
   create_bd_pin -dir I -type clk ACLK
   create_bd_pin -dir I -type rst ARESETN
   create_bd_pin -dir I -type clk hdmi_clk
   create_bd_pin -dir I -from 19 -to 0 aud_acr_cts_in
   create_bd_pin -dir I -from 19 -to 0 aud_acr_n_in
   create_bd_pin -dir I aud_acr_valid_in
   create_bd_pin -dir O -from 19 -to 0 aud_acr_cts_out
   create_bd_pin -dir O -from 19 -to 0 aud_acr_n_out
   create_bd_pin -dir O aud_acr_valid_out
   create_bd_pin -dir O -type rst aud_rstn
   create_bd_pin -dir O -type clk audio_clk
   
   # Create instance: aud_pat_gen, and set properties
   set aud_pat_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:aud_pat_gen:1.0 aud_pat_gen ]
   
   # Create instance: axi_interconnect, and set properties
   set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
   set_property CONFIG.NUM_MI {3} $axi_interconnect
   
   
   # Create instance: clk_wiz, and set properties
   set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
   set_property -dict [list \
      CONFIG.AUTO_PRIMITIVE {PLL} \
      CONFIG.CLKOUT1_DRIVES {Buffer} \
      CONFIG.CLKOUT1_JITTER {144.780} \
      CONFIG.CLKOUT1_PHASE_ERROR {114.254} \
      CONFIG.CLKOUT2_DRIVES {Buffer} \
      CONFIG.CLKOUT3_DRIVES {Buffer} \
      CONFIG.CLKOUT4_DRIVES {Buffer} \
      CONFIG.CLKOUT5_DRIVES {Buffer} \
      CONFIG.CLKOUT6_DRIVES {Buffer} \
      CONFIG.CLKOUT7_DRIVES {Buffer} \
      CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
      CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
      CONFIG.MMCM_CLKFBOUT_MULT_F {8} \
      CONFIG.MMCM_CLKOUT0_DIVIDE_F {8} \
      CONFIG.MMCM_COMPENSATION {AUTO} \
      CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {false} \
      CONFIG.PRIMITIVE {Auto} \
      CONFIG.PRIM_SOURCE {No_buffer} \
      CONFIG.USE_DYN_RECONFIG {true} \
      CONFIG.USE_LOCKED {true} \
      CONFIG.USE_RESET {true} ] $clk_wiz
   
   
   # Create instance: hdmi_acr_ctrl, and set properties
   set hdmi_acr_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:hdmi_acr_ctrl:1.0 hdmi_acr_ctrl ]
   set_property -dict [list \
      CONFIG.C_EXDES_TOPOLOGY {0} \
      CONFIG.C_HDMI_VERSION {0} ] $hdmi_acr_ctrl
   
   
   # Create interface connections
   connect_bd_intf_net -intf_net intf_net_aud_pat_gen_axis_audio_out [get_bd_intf_pins aud_pat_gen/axis_audio_out] [get_bd_intf_pins axis_audio_out]
   connect_bd_intf_net -intf_net intf_net_axi_interconnect_M00_AXI [get_bd_intf_pins axi_interconnect/M00_AXI] [get_bd_intf_pins aud_pat_gen/axi]
   connect_bd_intf_net -intf_net intf_net_axi_interconnect_M01_AXI [get_bd_intf_pins axi_interconnect/M01_AXI] [get_bd_intf_pins hdmi_acr_ctrl/axi]
   connect_bd_intf_net -intf_net intf_net_axi_interconnect_M02_AXI [get_bd_intf_pins axi_interconnect/M02_AXI] [get_bd_intf_pins clk_wiz/s_axi_lite]
   connect_bd_intf_net -intf_net intf_net_bdry_in_S00_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect/S00_AXI]
   connect_bd_intf_net -intf_net intf_net_bdry_in_axis_audio_in [get_bd_intf_pins axis_audio_in] [get_bd_intf_pins aud_pat_gen/axis_audio_in]
   
   # Create port connections
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins aud_pat_gen/axi_aclk]
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins axi_interconnect/ACLK]
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins axi_interconnect/S00_ACLK]
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins axi_interconnect/M00_ACLK]
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins axi_interconnect/M01_ACLK]
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins axi_interconnect/M02_ACLK]
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins clk_wiz/s_axi_aclk]
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins clk_wiz/clk_in1]
   connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins hdmi_acr_ctrl/axi_aclk]
   
   connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins axi_interconnect/ARESETN]
   connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN]
   connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins axi_interconnect/M00_ARESETN]
   connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins axi_interconnect/M01_ARESETN]
   connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins axi_interconnect/M02_ARESETN]
   connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins clk_wiz/s_axi_aresetn]
   connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins aud_pat_gen/axi_aresetn]
   connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins hdmi_acr_ctrl/axi_aresetn]
   
   connect_bd_net -net net_bdry_in_aud_acr_cts_in [get_bd_pins aud_acr_cts_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_cts_in]
   connect_bd_net -net net_bdry_in_aud_acr_n_in [get_bd_pins aud_acr_n_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_n_in]
   connect_bd_net -net net_bdry_in_aud_acr_valid_in [get_bd_pins aud_acr_valid_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_valid_in]
   connect_bd_net -net net_bdry_in_hdmi_clk [get_bd_pins hdmi_clk] [get_bd_pins hdmi_acr_ctrl/hdmi_clk]
   
   connect_bd_net -net net_clk_wiz_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins audio_clk]
   connect_bd_net -net net_clk_wiz_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins aud_pat_gen/aud_clk]
   connect_bd_net -net net_clk_wiz_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins aud_pat_gen/axis_clk]
   connect_bd_net -net net_clk_wiz_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins hdmi_acr_ctrl/aud_clk]
   
   connect_bd_net -net net_hdmi_acr_ctrl_aud_acr_cts_out [get_bd_pins hdmi_acr_ctrl/aud_acr_cts_out] [get_bd_pins aud_acr_cts_out]
   connect_bd_net -net net_hdmi_acr_ctrl_aud_acr_n_out [get_bd_pins hdmi_acr_ctrl/aud_acr_n_out] [get_bd_pins aud_acr_n_out]
   connect_bd_net -net net_hdmi_acr_ctrl_aud_acr_valid_out [get_bd_pins hdmi_acr_ctrl/aud_acr_valid_out] [get_bd_pins aud_acr_valid_out]
   
   connect_bd_net -net net_hdmi_acr_ctrl_aud_resetn_out [get_bd_pins hdmi_acr_ctrl/aud_resetn_out] [get_bd_pins aud_rstn]
   connect_bd_net -net net_hdmi_acr_ctrl_aud_resetn_out [get_bd_pins hdmi_acr_ctrl/aud_resetn_out] [get_bd_pins aud_pat_gen/axis_resetn]
   
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
   create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 system_clock_300mhz
   create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 sys_uart
   
   # Create pins
   create_bd_pin -dir I hdmi_rx_irq
   create_bd_pin -dir I hdmi_tx_irq
   create_bd_pin -dir I vphy_irq
   create_bd_pin -dir O -type clk hdmi_clk_out
   create_bd_pin -dir O -from 0 -to 0 dcm_locked
   create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
   create_bd_pin -dir O -type clk s_axi_aclk
   create_bd_pin -dir I -from 0 -to 0 system_resetn
   
   # Create instance: microblaze_0, and set properties
   set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
   set_property -dict [list \
      CONFIG.C_AREA_OPTIMIZED {0} \
      CONFIG.C_DEBUG_ENABLED {1} \
      CONFIG.C_D_AXI {1} \
      CONFIG.C_D_LMB {1} \
      CONFIG.C_I_LMB {1} \
      CONFIG.G_TEMPLATE_LIST {8} ] $microblaze_0
   
   
   # Create instance: microblaze_0_local_memory
   create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory
   
   # Create instance: microblaze_0_axi_periph, and set properties
   set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
   set_property CONFIG.NUM_MI {9} $microblaze_0_axi_periph
   
   
   # Create instance: microblaze_0_axi_intc, and set properties
   set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 microblaze_0_axi_intc ]
   set_property -dict [list \
      CONFIG.C_HAS_FAST {1} \
      CONFIG.C_PROCESSOR_CLK_FREQ_MHZ {99.951923} ] $microblaze_0_axi_intc
   
   
   # Create instance: microblaze_0_xlconcat, and set properties
   set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]
   set_property CONFIG.NUM_PORTS {5} $microblaze_0_xlconcat
   
   
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
   
   
   # Create interface connections
   connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_pins fmch_axi_iic/IIC] [get_bd_intf_pins IIC]
   connect_bd_intf_net -intf_net axi_uartlite_UART [get_bd_intf_pins axi_uartlite/UART] [get_bd_intf_pins sys_uart]
   connect_bd_intf_net -intf_net mdm_1_MBDEBUG_0  [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
   connect_bd_intf_net -intf_net microblaze_0_axi_dp [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
   
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins M00_AXI] 
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI] [get_bd_intf_pins M01_AXI] 
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI] [get_bd_intf_pins M02_AXI]
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI] [get_bd_intf_pins axi_uartlite/S_AXI]
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins fmch_axi_iic/S_AXI]
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI] [get_bd_intf_pins M05_AXI]
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI] [get_bd_intf_pins M06_AXI]
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI] [get_bd_intf_pins microblaze_0_axi_intc/s_axi]
   connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins M08_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI]
   
   connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
   connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
   connect_bd_intf_net -intf_net microblaze_0_interrupt [get_bd_intf_pins microblaze_0_axi_intc/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
   connect_bd_intf_net -intf_net system_clock_300mhz_1 [get_bd_intf_pins system_clock_300mhz] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
   
   # Create port connections
   connect_bd_net -net Reset_1 [get_bd_pins proc_sys_reset_0/mb_reset] [get_bd_pins microblaze_0/Reset]
   connect_bd_net -net Reset_1 [get_bd_pins proc_sys_reset_0/mb_reset] [get_bd_pins microblaze_0_axi_intc/processor_rst]
   
   connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins fmch_axi_iic/iic2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In4]
   connect_bd_net -net axi_uartlite_interrupt [get_bd_pins axi_uartlite/interrupt] [get_bd_pins microblaze_0_xlconcat/In3]
   
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins microblaze_0_axi_periph/M05_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins microblaze_0_axi_periph/M08_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins hdmi_clk_out]
   
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0/Clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/S00_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/M00_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/M01_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/M02_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/M03_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/M04_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/M06_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_periph/M07_ACLK]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_axi_intc/processor_clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins microblaze_0_local_memory/LMB_Clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins fmch_axi_iic/s_axi_aclk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_uartlite/s_axi_aclk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
   connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins s_axi_aclk]
   
   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked]
   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_0/aux_reset_in]
   
   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_1/dcm_locked]
   connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins proc_sys_reset_1/aux_reset_in]
   
   connect_bd_net -net vphy_irq_1 [get_bd_pins vphy_irq] [get_bd_pins microblaze_0_xlconcat/In0]
   connect_bd_net -net hdmi_rx_irq_1 [get_bd_pins hdmi_rx_irq] [get_bd_pins microblaze_0_xlconcat/In1]
   connect_bd_net -net hdmi_tx_irq_1 [get_bd_pins hdmi_tx_irq] [get_bd_pins microblaze_0_xlconcat/In2]
   
   connect_bd_net -net mdm_1_Debug_SYS_Rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins proc_sys_reset_0/mb_debug_sys_rst]
   connect_bd_net -net microblaze_0_intr [get_bd_pins microblaze_0_xlconcat/dout] [get_bd_pins microblaze_0_axi_intc/intr]
   connect_bd_net -net proc_sys_reset_0_bus_struct_reset [get_bd_pins proc_sys_reset_0/bus_struct_reset] [get_bd_pins microblaze_0_local_memory/SYS_Rst]
   connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins microblaze_0_axi_periph/ARESETN]
   connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins dcm_locked]
   connect_bd_net -net rst_processor_0_100M_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins peripheral_aresetn] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins fmch_axi_iic/s_axi_aresetn] [get_bd_pins axi_uartlite/s_axi_aresetn]
   
   connect_bd_net -net rst_processor_1_300M_interconnect_aresetn [get_bd_pins proc_sys_reset_1/interconnect_aresetn] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN]
   connect_bd_net -net rst_processor_1_300M_interconnect_aresetn [get_bd_pins proc_sys_reset_1/interconnect_aresetn] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN]
   
   connect_bd_net -net system_resetn_1 [get_bd_pins system_resetn] [get_bd_pins system_resetn_inv_0/Op1]
   connect_bd_net -net system_resetn_1 [get_bd_pins system_resetn] [get_bd_pins proc_sys_reset_0/ext_reset_in]
   connect_bd_net -net system_resetn_1 [get_bd_pins system_resetn] [get_bd_pins proc_sys_reset_1/ext_reset_in]
   
   connect_bd_net -net system_resetn_inv_0_Res [get_bd_pins system_resetn_inv_0/Res] [get_bd_pins clk_wiz_0/reset]
   
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
   
   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 fmch_iic
   
   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK297
   
   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT
   
   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT
   
   # Create ports
   create_bd_port -dir I -type rst system_resetn
   set_property -dict [ list \
      CONFIG.POLARITY {ACTIVE_LOW} ] [get_bd_port system_resetn]
    
   create_bd_port -dir I RX_DET_IN
   create_bd_port -dir I -type clk TX_REFCLK_P_IN
   create_bd_port -dir I -type clk TX_REFCLK_N_IN
   create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN
   create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN
   create_bd_port -dir I TX_HPD_IN
   create_bd_port -dir I -type clk HDMI_RX_CLK_N_IN
   create_bd_port -dir I -type clk HDMI_RX_CLK_P_IN
   create_bd_port -dir O HDMI_TX_LOCKED_LED
   create_bd_port -dir O -from 0 -to 0 RX_HPD_OUT
   create_bd_port -dir O -type clk HDMI_TX_CLK_P_OUT
   create_bd_port -dir O -type clk HDMI_TX_CLK_N_OUT
   create_bd_port -dir O -type clk RX_REFCLK_P_OUT
   create_bd_port -dir O -type clk RX_REFCLK_N_OUT
   create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT
   create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT
   create_bd_port -dir O -from 0 -to 0 TX_CLKSEL_OUT
   create_bd_port -dir O -from 0 -to 0 TX_EN_OUT
   create_bd_port -dir O -from 0 -to 0 RX_I2C_EN_N_OUT
   
   create_bd_port -dir O -from 0 -to 0 BLINKY_LED
   
   # Create instance: mb_ss_0
   create_hier_cell_mb_ss_0 [current_bd_instance .] mb_ss_0
   
   # Create instance: audio_ss_0
   create_hier_cell_audio_ss_0 [current_bd_instance .] audio_ss_0
   
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
      
   # Create instance: v_hdmi_tx_ss, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_tx_ss:3.2 v_hdmi_tx_ss
   set_property -dict [list \
      CONFIG.C_ADDR_WIDTH {10} \
      CONFIG.C_ADD_MARK_DBG {0} \
      CONFIG.C_EXDES_NIDRU {true} \
      CONFIG.C_EXDES_TX_PLL_SELECTION {6} \
      CONFIG.C_HDMI_FAST_SWITCH {true} \
      CONFIG.C_HDMI_VERSION {3} \
      CONFIG.C_HPD_INVERT {false} \
      CONFIG.C_HYSTERESIS_LEVEL {12} \
      CONFIG.C_INCLUDE_HDCP_1_4 {false} \
      CONFIG.C_INCLUDE_HDCP_2_2 {false} \
      CONFIG.C_INCLUDE_LOW_RESO_VID {true} \
      CONFIG.C_INCLUDE_YUV420_SUP {true} \
      CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
      CONFIG.C_MAX_BITS_PER_COMPONENT {8} \
      CONFIG.C_VALIDATION_ENABLE {false} \
      CONFIG.C_VID_INTERFACE {0} ] [get_bd_cells v_hdmi_tx_ss]
      
   # Create instance: v_hdmi_rx_ss, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_rx_ss:3.2 v_hdmi_rx_ss
   set_property -dict [list \
      CONFIG.C_ADDR_WIDTH {10} \
      CONFIG.C_ADD_MARK_DBG {0} \
      CONFIG.C_CD_INVERT {true} \
      CONFIG.C_EDID_RAM_SIZE {256} \
      CONFIG.C_EXDES_AXILITE_FREQ {100} \
      CONFIG.C_EXDES_NIDRU {true} \
      CONFIG.C_EXDES_RX_PLL_SELECTION {0} \
      CONFIG.C_EXDES_TOPOLOGY {0} \
      CONFIG.C_EXDES_TX_PLL_SELECTION {6} \
      CONFIG.C_HDMI_FAST_SWITCH {true} \
      CONFIG.C_HDMI_VERSION {3} \
      CONFIG.C_HPD_INVERT {true} \
      CONFIG.C_INCLUDE_HDCP_1_4 {false} \
      CONFIG.C_INCLUDE_HDCP_2_2 {false} \
      CONFIG.C_INCLUDE_LOW_RESO_VID {true} \
      CONFIG.C_INCLUDE_YUV420_SUP {true} \
      CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
      CONFIG.C_MAX_BITS_PER_COMPONENT {8} \
      CONFIG.C_VALIDATION_ENABLE {false} \
      CONFIG.C_VID_INTERFACE {0} ] [get_bd_cells v_hdmi_rx_ss]
   
   # Create instance: util_ds_buf_0, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0
   set_property CONFIG.C_BUF_TYPE {OBUFDS} [get_bd_cells util_ds_buf_0]
   
   # Create instance: vcc_const, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc_const
   
   # Create instance: rx_video_axis_reg_slice, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 rx_video_axis_reg_slice
   
   # Create instance: tx_video_axis_reg_slice, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 tx_video_axis_reg_slice
   
   # Create instance: v_tpg_ss_0
   create_hier_cell_v_tpg_ss_0 [current_bd_instance .] v_tpg_ss_0
   
   # Create instance: gnd_const, and set properties
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd_const
   set_property CONFIG.CONST_VAL {0} [get_bd_cells gnd_const]
   
   # Create interface connections
   connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins audio_ss_0/S00_AXI] [get_bd_intf_pins mb_ss_0/M06_AXI]
   connect_bd_intf_net -intf_net audio_ss_0_axis_audio_out [get_bd_intf_pins audio_ss_0/axis_audio_out] [get_bd_intf_pins v_hdmi_tx_ss/AUDIO_IN]
   connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA0_OUT [get_bd_intf_pins v_hdmi_tx_ss/LINK_DATA0_OUT] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch0]
   connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch0] [get_bd_intf_pins v_hdmi_rx_ss/LINK_DATA0_IN]
   connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_rx [get_bd_intf_pins vid_phy_controller/vid_phy_status_sb_rx] [get_bd_intf_pins v_hdmi_rx_ss/SB_STATUS_IN]
   connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_tx [get_bd_intf_pins vid_phy_controller/vid_phy_status_sb_tx] [get_bd_intf_pins v_hdmi_tx_ss/SB_STATUS_IN]
   connect_bd_intf_net -intf_net mb_ss_0_IIC [get_bd_intf_ports fmch_iic] [get_bd_intf_pins mb_ss_0/IIC]
   connect_bd_intf_net -intf_net mb_ss_0_M00_AXI [get_bd_intf_pins vid_phy_controller/vid_phy_axi4lite] [get_bd_intf_pins mb_ss_0/M00_AXI]
   connect_bd_intf_net -intf_net mb_ss_0_M01_AXI [get_bd_intf_pins v_hdmi_rx_ss/S_AXI_CPU_IN] [get_bd_intf_pins mb_ss_0/M01_AXI]
   connect_bd_intf_net -intf_net mb_ss_0_M02_AXI [get_bd_intf_pins mb_ss_0/M02_AXI] [get_bd_intf_pins v_hdmi_tx_ss/S_AXI_CPU_IN]
   connect_bd_intf_net -intf_net mb_ss_0_M05_AXI [get_bd_intf_pins mb_ss_0/M05_AXI] [get_bd_intf_pins v_tpg_ss_0/s_axi_CTRL]
   connect_bd_intf_net -intf_net mb_ss_0_M08_AXI [get_bd_intf_pins mb_ss_0/M08_AXI] [get_bd_intf_pins v_tpg_ss_0/S_AXI]
   connect_bd_intf_net -intf_net mb_ss_sys_uart [get_bd_intf_ports sys_uart] [get_bd_intf_pins mb_ss_0/sys_uart]
   connect_bd_intf_net -intf_net rx_video_axis_reg_slice_M_AXIS [get_bd_intf_pins v_tpg_ss_0/s_axis_video] [get_bd_intf_pins rx_video_axis_reg_slice/M_AXIS]
   connect_bd_intf_net -intf_net system_clock_300mhz_1 [get_bd_intf_ports system_clock_300mhz] [get_bd_intf_pins mb_ss_0/system_clock_300mhz]
   connect_bd_intf_net -intf_net util_ds_buf_0_CLK_OUT_D3 [get_bd_intf_ports CLK297] [get_bd_intf_pins util_ds_buf_0/CLK_OUT_D3]
   connect_bd_intf_net -intf_net v_hdmi_rx_ss_AUDIO_OUT [get_bd_intf_pins v_hdmi_rx_ss/AUDIO_OUT] [get_bd_intf_pins audio_ss_0/axis_audio_in]
   connect_bd_intf_net -intf_net v_hdmi_rx_ss_DDC_OUT [get_bd_intf_ports RX_DDC_OUT] [get_bd_intf_pins v_hdmi_rx_ss/DDC_OUT]
   connect_bd_intf_net -intf_net v_hdmi_rx_ss_VIDEO_OUT [get_bd_intf_pins v_hdmi_rx_ss/VIDEO_OUT] [get_bd_intf_pins rx_video_axis_reg_slice/S_AXIS]
   connect_bd_intf_net -intf_net v_hdmi_tx_ss_DDC_OUT [get_bd_intf_ports TX_DDC_OUT] [get_bd_intf_pins v_hdmi_tx_ss/DDC_OUT]
   connect_bd_intf_net -intf_net v_hdmi_tx_ss_LINK_DATA1_OUT [get_bd_intf_pins v_hdmi_tx_ss/LINK_DATA1_OUT] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch1]
   connect_bd_intf_net -intf_net v_hdmi_tx_ss_LINK_DATA2_OUT [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch2] [get_bd_intf_pins v_hdmi_tx_ss/LINK_DATA2_OUT]
   connect_bd_intf_net -intf_net v_tpg_m_axis_video [get_bd_intf_pins v_tpg_ss_0/m_axis_video] [get_bd_intf_pins tx_video_axis_reg_slice/S_AXIS]
   connect_bd_intf_net -intf_net v_tpg_ss_0_M_AXIS [get_bd_intf_pins v_hdmi_tx_ss/VIDEO_IN] [get_bd_intf_pins tx_video_axis_reg_slice/M_AXIS]
   connect_bd_intf_net -intf_net vid_phy_controller_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch1] [get_bd_intf_pins v_hdmi_rx_ss/LINK_DATA1_IN]
   connect_bd_intf_net -intf_net vid_phy_controller_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch2] [get_bd_intf_pins v_hdmi_rx_ss/LINK_DATA2_IN]
   
   # Create port connections
   connect_bd_net -net audio_ss_0_aud_acr_cts_out [get_bd_pins audio_ss_0/aud_acr_cts_out] [get_bd_pins v_hdmi_tx_ss/acr_cts]
   connect_bd_net -net audio_ss_0_aud_acr_n_out [get_bd_pins audio_ss_0/aud_acr_n_out] [get_bd_pins v_hdmi_tx_ss/acr_n]
   connect_bd_net -net audio_ss_0_aud_acr_valid_out [get_bd_pins audio_ss_0/aud_acr_valid_out] [get_bd_pins v_hdmi_tx_ss/acr_valid]
   
   connect_bd_net -net audio_ss_0_aud_rstn [get_bd_pins audio_ss_0/aud_rstn] [get_bd_pins v_hdmi_tx_ss/s_axis_audio_aresetn]
   connect_bd_net -net audio_ss_0_aud_rstn [get_bd_pins audio_ss_0/aud_rstn] [get_bd_pins v_hdmi_rx_ss/s_axis_audio_aresetn]
   
   connect_bd_net -net audio_ss_0_audio_clk [get_bd_pins audio_ss_0/audio_clk] [get_bd_pins v_hdmi_tx_ss/s_axis_audio_aclk]
   connect_bd_net -net audio_ss_0_audio_clk [get_bd_pins audio_ss_0/audio_clk] [get_bd_pins v_hdmi_rx_ss/s_axis_audio_aclk]
   
   connect_bd_net -net cable_detect_0_1 [get_bd_ports RX_DET_IN] [get_bd_pins v_hdmi_rx_ss/cable_detect]
   connect_bd_net -net hpd_0_1 [get_bd_ports TX_HPD_IN] [get_bd_pins v_hdmi_tx_ss/hpd]
   
   connect_bd_net -net mb_ss_0_dcm_locked [get_bd_pins mb_ss_0/dcm_locked] [get_bd_pins v_hdmi_tx_ss/s_axis_video_aresetn]
   connect_bd_net -net mb_ss_0_dcm_locked [get_bd_pins mb_ss_0/dcm_locked] [get_bd_pins v_hdmi_rx_ss/s_axis_video_aresetn]
   connect_bd_net -net mb_ss_0_dcm_locked [get_bd_pins mb_ss_0/dcm_locked] [get_bd_pins rx_video_axis_reg_slice/aresetn]
   connect_bd_net -net mb_ss_0_dcm_locked [get_bd_pins mb_ss_0/dcm_locked] [get_bd_pins tx_video_axis_reg_slice/aresetn]
   connect_bd_net -net mb_ss_0_dcm_locked [get_bd_pins mb_ss_0/dcm_locked] [get_bd_pins v_tpg_ss_0/s_axi_aresetn]
   
   connect_bd_net -net mb_ss_0_hdmi_clk_out [get_bd_pins mb_ss_0/hdmi_clk_out] [get_bd_pins v_hdmi_tx_ss/s_axis_video_aclk]
   connect_bd_net -net mb_ss_0_hdmi_clk_out [get_bd_pins mb_ss_0/hdmi_clk_out] [get_bd_pins v_hdmi_rx_ss/s_axis_video_aclk]
   connect_bd_net -net mb_ss_0_hdmi_clk_out [get_bd_pins mb_ss_0/hdmi_clk_out] [get_bd_pins util_ds_buf_0/OBUF_IN]
   connect_bd_net -net mb_ss_0_hdmi_clk_out [get_bd_pins mb_ss_0/hdmi_clk_out] [get_bd_pins rx_video_axis_reg_slice/aclk]
   connect_bd_net -net mb_ss_0_hdmi_clk_out [get_bd_pins mb_ss_0/hdmi_clk_out] [get_bd_pins tx_video_axis_reg_slice/aclk]
   connect_bd_net -net mb_ss_0_hdmi_clk_out [get_bd_pins mb_ss_0/hdmi_clk_out] [get_bd_pins v_tpg_ss_0/s_axi_aclk]
   
   connect_bd_net -net mb_ss_0_peripheral_aresetn [get_bd_pins mb_ss_0/peripheral_aresetn] [get_bd_pins audio_ss_0/ARESETN]
   connect_bd_net -net mb_ss_0_peripheral_aresetn [get_bd_pins mb_ss_0/peripheral_aresetn] [get_bd_pins v_hdmi_tx_ss/s_axi_cpu_aresetn]
   connect_bd_net -net mb_ss_0_peripheral_aresetn [get_bd_pins mb_ss_0/peripheral_aresetn] [get_bd_pins vid_phy_controller/vid_phy_axi4lite_aresetn]
   connect_bd_net -net mb_ss_0_peripheral_aresetn [get_bd_pins mb_ss_0/peripheral_aresetn] [get_bd_pins vid_phy_controller/vid_phy_sb_aresetn]
   connect_bd_net -net mb_ss_0_peripheral_aresetn [get_bd_pins mb_ss_0/peripheral_aresetn] [get_bd_pins v_hdmi_rx_ss/s_axi_cpu_aresetn]
   
   connect_bd_net -net mb_ss_0_peripheral_aresetn [get_bd_pins mb_ss_0/peripheral_aresetn] [get_bd_pins blinky_counter_0/aresetn]
   
   connect_bd_net -net mb_ss_0_s_axi_aclk [get_bd_pins mb_ss_0/s_axi_aclk] [get_bd_pins audio_ss_0/ACLK]
   connect_bd_net -net mb_ss_0_s_axi_aclk [get_bd_pins mb_ss_0/s_axi_aclk] [get_bd_pins v_hdmi_tx_ss/s_axi_cpu_aclk]
   connect_bd_net -net mb_ss_0_s_axi_aclk [get_bd_pins mb_ss_0/s_axi_aclk] [get_bd_pins vid_phy_controller/vid_phy_sb_aclk]
   connect_bd_net -net mb_ss_0_s_axi_aclk [get_bd_pins mb_ss_0/s_axi_aclk] [get_bd_pins vid_phy_controller/vid_phy_axi4lite_aclk]
   connect_bd_net -net mb_ss_0_s_axi_aclk [get_bd_pins mb_ss_0/s_axi_aclk] [get_bd_pins vid_phy_controller/drpclk]
   connect_bd_net -net mb_ss_0_s_axi_aclk [get_bd_pins mb_ss_0/s_axi_aclk] [get_bd_pins v_hdmi_rx_ss/s_axi_cpu_aclk]
   
   connect_bd_net -net mb_ss_0_s_axi_aclk [get_bd_pins mb_ss_0/s_axi_aclk] [get_bd_pins blinky_counter_0/clk]
   
   connect_bd_net -net mgtrefclk0_pad_n_in_0_1 [get_bd_ports HDMI_RX_CLK_N_IN] [get_bd_pins vid_phy_controller/mgtrefclk0_pad_n_in]
   connect_bd_net -net mgtrefclk0_pad_p_in_0_1 [get_bd_ports HDMI_RX_CLK_P_IN] [get_bd_pins vid_phy_controller/mgtrefclk0_pad_p_in]
   connect_bd_net -net mgtrefclk1_pad_n_in_0_1 [get_bd_ports TX_REFCLK_N_IN] [get_bd_pins vid_phy_controller/mgtrefclk1_pad_n_in]
   connect_bd_net -net mgtrefclk1_pad_p_in_0_1 [get_bd_ports TX_REFCLK_P_IN] [get_bd_pins vid_phy_controller/mgtrefclk1_pad_p_in]
   connect_bd_net -net net_v_hdmi_rx_ss_fid [get_bd_pins v_hdmi_rx_ss/fid] [get_bd_pins v_hdmi_tx_ss/fid]
   
   connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins vid_phy_controller/rxoutclk] [get_bd_pins v_hdmi_rx_ss/link_clk]
   connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins vid_phy_controller/rxoutclk] [get_bd_pins vid_phy_controller/vid_phy_rx_axi4s_aclk]
   
   connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins vid_phy_controller/txoutclk] [get_bd_pins v_hdmi_tx_ss/link_clk]
   connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins vid_phy_controller/txoutclk] [get_bd_pins vid_phy_controller/vid_phy_tx_axi4s_aclk]
   
   connect_bd_net -net phy_rxn_in_0_1 [get_bd_ports HDMI_RX_DAT_N_IN] [get_bd_pins vid_phy_controller/phy_rxn_in]
   connect_bd_net -net phy_rxp_in_0_1 [get_bd_ports HDMI_RX_DAT_P_IN] [get_bd_pins vid_phy_controller/phy_rxp_in]
   connect_bd_net -net system_resetn_1 [get_bd_ports system_resetn] [get_bd_pins mb_ss_0/system_resetn]
   connect_bd_net -net v_hdmi_rx_ss_acr_cts [get_bd_pins v_hdmi_rx_ss/acr_cts] [get_bd_pins audio_ss_0/aud_acr_cts_in]
   connect_bd_net -net v_hdmi_rx_ss_acr_n [get_bd_pins v_hdmi_rx_ss/acr_n] [get_bd_pins audio_ss_0/aud_acr_n_in]
   connect_bd_net -net v_hdmi_rx_ss_acr_valid [get_bd_pins v_hdmi_rx_ss/acr_valid] [get_bd_pins audio_ss_0/aud_acr_valid_in]
   connect_bd_net -net v_hdmi_rx_ss_hpd [get_bd_pins v_hdmi_rx_ss/hpd] [get_bd_ports RX_HPD_OUT]
   connect_bd_net -net v_hdmi_rx_ss_irq [get_bd_pins v_hdmi_rx_ss/irq] [get_bd_pins mb_ss_0/hdmi_rx_irq]
   connect_bd_net -net v_hdmi_tx_ss_irq [get_bd_pins v_hdmi_tx_ss/irq] [get_bd_pins mb_ss_0/hdmi_tx_irq]
   connect_bd_net -net v_hdmi_tx_ss_locked [get_bd_pins v_hdmi_tx_ss/locked] [get_bd_ports HDMI_TX_LOCKED_LED]
   
   connect_bd_net -net vcc_const_dout [get_bd_pins vcc_const/dout] [get_bd_pins vid_phy_controller/vid_phy_tx_axi4s_aresetn]
   connect_bd_net -net vcc_const_dout [get_bd_pins vcc_const/dout] [get_bd_pins vid_phy_controller/vid_phy_rx_axi4s_aresetn]
   #~ connect_bd_net -net vcc_const_dout [get_bd_pins vcc_const/dout] [get_bd_ports TX_EN_OUT]
   connect_bd_net -net vcc_const_dout [get_bd_pins vcc_const/dout] [get_bd_ports TX_CLKSEL_OUT]
   
   connect_bd_net -net vid_phy_controller_irq [get_bd_pins vid_phy_controller/irq] [get_bd_pins mb_ss_0/vphy_irq]

   connect_bd_net -net vid_phy_controller_phy_txn_out [get_bd_pins vid_phy_controller/phy_txn_out] [get_bd_ports HDMI_TX_DAT_N_OUT]
   connect_bd_net -net vid_phy_controller_phy_txp_out [get_bd_pins vid_phy_controller/phy_txp_out] [get_bd_ports HDMI_TX_DAT_P_OUT]

   connect_bd_net -net vid_phy_controller_rx_tmds_clk_n [get_bd_pins vid_phy_controller/rx_tmds_clk_n] [get_bd_ports RX_REFCLK_N_OUT]
   connect_bd_net -net vid_phy_controller_rx_tmds_clk_p [get_bd_pins vid_phy_controller/rx_tmds_clk_p] [get_bd_ports RX_REFCLK_P_OUT]
   connect_bd_net -net vid_phy_controller_rx_video_clk [get_bd_pins vid_phy_controller/rx_video_clk] [get_bd_pins v_hdmi_rx_ss/video_clk]

   connect_bd_net -net vid_phy_controller_tx_tmds_clk [get_bd_pins vid_phy_controller/tx_tmds_clk] [get_bd_pins audio_ss_0/hdmi_clk]
   connect_bd_net -net vid_phy_controller_tx_tmds_clk_n [get_bd_pins vid_phy_controller/tx_tmds_clk_n] [get_bd_ports HDMI_TX_CLK_N_OUT]
   connect_bd_net -net vid_phy_controller_tx_tmds_clk_p [get_bd_pins vid_phy_controller/tx_tmds_clk_p] [get_bd_ports HDMI_TX_CLK_P_OUT]

   connect_bd_net -net vid_phy_controller_tx_video_clk [get_bd_pins vid_phy_controller/tx_video_clk] [get_bd_pins v_hdmi_tx_ss/video_clk]

   connect_bd_net -net gnd_const_dout [get_bd_pins gnd_const/dout] [get_bd_pins vid_phy_controller/tx_refclk_rdy]
   connect_bd_net -net gnd_const_dout [get_bd_pins gnd_const/dout] [get_bd_ports RX_I2C_EN_N_OUT]
   connect_bd_net -net gnd_const_dout [get_bd_pins gnd_const/dout] [get_bd_ports TX_EN_OUT] 
   
   connect_bd_net [get_bd_pins blinky_counter_0/blinky_led] [get_bd_ports BLINKY_LED]

   regenerate_bd_layout
   validate_bd_design
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
   #assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

   # Instruction (2G)
   #assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

  # Create address segments
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs audio_ss_0/aud_pat_gen/axi/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs v_tpg_ss_0/axi_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs mb_ss_0/fmch_axi_iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs mb_ss_0/axi_uartlite/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs audio_ss_0/clk_wiz/s_axi_lite/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs mb_ss_0/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x44A50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs audio_ss_0/hdmi_acr_ctrl/axi/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs mb_ss_0/microblaze_0_axi_intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs v_hdmi_rx_ss/S_AXI_CPU_IN/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00020000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs v_hdmi_tx_ss/S_AXI_CPU_IN/Reg] -force
  assign_bd_address -offset 0x44A60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs v_tpg_ss_0/v_tpg/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x44A70000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Data] [get_bd_addr_segs vid_phy_controller/vid_phy_axi4lite/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces mb_ss_0/microblaze_0/Instruction] [get_bd_addr_segs mb_ss_0/microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force
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

