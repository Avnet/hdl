
################################################################
# This is a generated script based on design: uz3eg_iocc_ev
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_msg_id "BD_TCL-1002" "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source uz3eg_iocc_ev_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

#set list_projs [get_projects -quiet]
#if { $list_projs eq "" } {
#   create_project project_1 myproj -part xczu3eg-sfva625-1-i-es1
#   set_property BOARD_PART em.avnet.com:ultrazed_eg_iocc:part0:1.0 [current_project]
#}


# CHANGE DESIGN NAME HERE
#set design_name uz3eg_iocc_ev

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

#set cur_design [current_bd_design -quiet]
#set list_cells [get_bd_cells -quiet]
#
#if { ${design_name} eq "" } {
#   # USE CASES:
#   #    1) Design_name not set
#
#   set errMsg "Please set the variable <design_name> to a non-empty value."
#   set nRet 1
#
#} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
#   # USE CASES:
#   #    2): Current design opened AND is empty AND names same.
#   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
#   #    4): Current design opened AND is empty AND names diff; design_name exists in project.
#
#   if { $cur_design ne $design_name } {
#      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
#      set design_name [get_property NAME $cur_design]
#   }
#   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."
#
#} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
#   # USE CASES:
#   #    5) Current design opened AND has components AND same names.
#
#   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
#   set nRet 1
#} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
#   # USE CASES: 
#   #    6) Current opened design, has components, but diff names, design_name exists in project.
#   #    7) No opened design, design_name exists in project.
#
#   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
#   set nRet 2
#
#} else {
#   # USE CASES:
#   #    8) No opened design, design_name not in project.
#   #    9) Current opened design, has components, but diff names, design_name not in project.
#
#   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."
#
#   create_bd_design $design_name
#
#   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
#   current_bd_design $design_name
#
#}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: idt5901_clk
proc create_hier_cell_idt5901_clk { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_idt5901_clk() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D

  # Create pins
  create_bd_pin -dir O -from 0 -to 0 BUFG_O

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf util_ds_buf_0 ]
  set_property -dict [ list \
CONFIG.C_BUF_TYPE {IBUFDS} \
 ] $util_ds_buf_0

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf util_ds_buf_1 ]
  set_property -dict [ list \
CONFIG.C_BUF_TYPE {BUFG} \
 ] $util_ds_buf_1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins CLK_IN_D] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]

  # Create port connections
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins util_ds_buf_1/BUFG_I]
  connect_bd_net -net util_ds_buf_1_BUFG_O [get_bd_pins BUFG_O] [get_bd_pins util_ds_buf_1/BUFG_O]

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /idt5901_clk] -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port CLK_IN_D -pg 1 -y 50 -defaultsOSRD
preplace portBus BUFG_O -pg 1 -y 50 -defaultsOSRD
preplace inst util_ds_buf_1 -pg 1 -lvl 2 -y 50 -defaultsOSRD
preplace inst util_ds_buf_0 -pg 1 -lvl 1 -y 50 -defaultsOSRD
preplace netloc Conn1 1 0 1 NJ
preplace netloc util_ds_buf_0_IBUF_OUT 1 1 1 NJ
preplace netloc util_ds_buf_1_BUFG_O 1 2 1 NJ
levelinfo -pg 1 0 140 380 510 -top 0 -bot 100
",
}

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TDnext_capture
proc create_hier_cell_TDnext_capture { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_TDnext_capture() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ctrl_cfa
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ctrl_cresample
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ctrl_rgb2yuv
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 ctrl_vdma

  # Create pins
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir O -type clk xclk
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I frame_valid_in
  create_bd_pin -dir I line_valid_in
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir I pclk
  create_bd_pin -dir I -from 9 -to 0 pixel_in
  create_bd_pin -dir O -type intr s2mm_introut
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]

  # Create instance: tc_clk_wiz_0, and set properties
  set tc_clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz tc_clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {125.0} \
CONFIG.CLKOUT1_JITTER {338.272} \
CONFIG.CLKOUT1_PHASE_ERROR {431.259} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {24.000} \
CONFIG.MMCM_CLKFBOUT_MULT_F {62.625} \
CONFIG.MMCM_CLKIN1_PERIOD {12.500} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {41.750} \
CONFIG.MMCM_DIVCLK_DIVIDE {5} \
CONFIG.USE_LOCKED {true} \
CONFIG.USE_RESET {false} \
 ] $tc_clk_wiz_0

  # Create instance: tc_v_cfa_0, and set properties
  set tc_v_cfa_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cfa tc_v_cfa_0 ]
  set_property -dict [ list \
CONFIG.active_cols {1280} \
CONFIG.active_rows {720} \
CONFIG.bayer_phase {1} \
CONFIG.has_axi4_lite {true} \
CONFIG.max_cols {1280} \
 ] $tc_v_cfa_0

  # Create instance: tc_v_cresample_0, and set properties
  set tc_v_cresample_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cresample tc_v_cresample_0 ]
  set_property -dict [ list \
CONFIG.active_cols {1280} \
CONFIG.active_rows {720} \
CONFIG.has_axi4_lite {true} \
CONFIG.m_axis_video_format {2} \
CONFIG.max_cols {1280} \
CONFIG.num_h_taps {3} \
CONFIG.num_v_taps {0} \
CONFIG.s_axis_video_format {3} \
 ] $tc_v_cresample_0

  # Create instance: tc_v_rgb2ycrcb_0, and set properties
  set tc_v_rgb2ycrcb_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_rgb2ycrcb tc_v_rgb2ycrcb_0 ]
  set_property -dict [ list \
CONFIG.ACTIVE_COLS {1280} \
CONFIG.ACTIVE_ROWS {720} \
CONFIG.HAS_AXI4_LITE {true} \
 ] $tc_v_rgb2ycrcb_0

  # Create instance: tc_v_vid_in_axi4s_0, and set properties
  set tc_v_vid_in_axi4s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s tc_v_vid_in_axi4s_0 ]
  set_property -dict [ list \
CONFIG.C_ADDR_WIDTH {12} \
CONFIG.C_HAS_ASYNC_CLK {1} \
CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
 ] $tc_v_vid_in_axi4s_0

  # Create instance: tc_vdma_0, and set properties
  set tc_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma tc_vdma_0 ]
  set_property -dict [ list \
CONFIG.c_include_mm2s {0} \
CONFIG.c_m_axi_s2mm_data_width {64} \
CONFIG.c_mm2s_genlock_mode {0} \
CONFIG.c_num_fstores {1} \
CONFIG.c_s2mm_linebuffer_depth {4096} \
CONFIG.c_s2mm_max_burst_length {256} \
CONFIG.c_use_s2mm_fsync {1} \
 ] $tc_vdma_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_1 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: xlconstant_high, and set properties
  set xlconstant_high [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant xlconstant_high ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {9} \
CONFIG.DIN_TO {2} \
CONFIG.DIN_WIDTH {10} \
CONFIG.DOUT_WIDTH {8} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ctrl_vdma] [get_bd_intf_pins tc_vdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins ctrl_cfa] [get_bd_intf_pins tc_v_cfa_0/ctrl]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins ctrl_cresample] [get_bd_intf_pins tc_v_cresample_0/ctrl]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins ctrl_rgb2yuv] [get_bd_intf_pins tc_v_rgb2ycrcb_0/ctrl]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins tc_vdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net v_cfa_0_video_out [get_bd_intf_pins tc_v_cfa_0/video_out] [get_bd_intf_pins tc_v_rgb2ycrcb_0/video_in]
  connect_bd_intf_net -intf_net v_cresample_0_video_out [get_bd_intf_pins tc_v_cresample_0/video_out] [get_bd_intf_pins tc_vdma_0/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net v_rgb2ycrcb_0_video_out [get_bd_intf_pins tc_v_cresample_0/video_in] [get_bd_intf_pins tc_v_rgb2ycrcb_0/video_out]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_0_video_out [get_bd_intf_pins tc_v_cfa_0/video_in] [get_bd_intf_pins tc_v_vid_in_axi4s_0/video_out]

  # Create port connections
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins tc_v_cfa_0/aresetn] [get_bd_pins tc_v_cresample_0/aresetn] [get_bd_pins tc_v_rgb2ycrcb_0/aresetn]
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins tc_v_cfa_0/s_axi_aresetn] [get_bd_pins tc_v_cresample_0/s_axi_aresetn] [get_bd_pins tc_v_rgb2ycrcb_0/s_axi_aresetn] [get_bd_pins tc_v_vid_in_axi4s_0/aresetn] [get_bd_pins tc_vdma_0/axi_resetn]
  connect_bd_net -net axi_vdma_0_s2mm_introut [get_bd_pins s2mm_introut] [get_bd_pins tc_vdma_0/s2mm_introut]
  connect_bd_net -net clk_wiz_0_xclk [get_bd_pins xclk] [get_bd_pins tc_clk_wiz_0/clk_out1]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net frame_valid_in_1 [get_bd_pins frame_valid_in] [get_bd_pins tc_vdma_0/s2mm_fsync] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net line_valid_in_1 [get_bd_pins line_valid_in] [get_bd_pins tc_v_vid_in_axi4s_0/vid_active_video] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net m_axi_s2mm_aclk_1 [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins tc_v_cfa_0/aclk] [get_bd_pins tc_v_cresample_0/aclk] [get_bd_pins tc_v_rgb2ycrcb_0/aclk] [get_bd_pins tc_v_vid_in_axi4s_0/aclk] [get_bd_pins tc_vdma_0/m_axi_s2mm_aclk] [get_bd_pins tc_vdma_0/s_axis_s2mm_aclk]
  connect_bd_net -net pclk_1 [get_bd_pins pclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins tc_v_vid_in_axi4s_0/vid_io_in_clk]
  connect_bd_net -net pixel_in_1 [get_bd_pins pixel_in] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins tc_v_vid_in_axi4s_0/vid_io_in_reset]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins tc_clk_wiz_0/clk_in1] [get_bd_pins tc_v_cfa_0/s_axi_aclk] [get_bd_pins tc_v_cresample_0/s_axi_aclk] [get_bd_pins tc_v_rgb2ycrcb_0/s_axi_aclk] [get_bd_pins tc_vdma_0/s_axi_lite_aclk]
  connect_bd_net -net tc_clk_wiz_0_locked [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins tc_clk_wiz_0/locked]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins tc_v_vid_in_axi4s_0/vid_hblank] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins tc_v_vid_in_axi4s_0/vid_vblank] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net xlconstant_high_dout [get_bd_pins tc_v_cfa_0/aclken] [get_bd_pins tc_v_cfa_0/s_axi_aclken] [get_bd_pins tc_v_cresample_0/aclken] [get_bd_pins tc_v_cresample_0/s_axi_aclken] [get_bd_pins tc_v_rgb2ycrcb_0/aclken] [get_bd_pins tc_v_rgb2ycrcb_0/s_axi_aclken] [get_bd_pins tc_v_vid_in_axi4s_0/aclken] [get_bd_pins tc_v_vid_in_axi4s_0/axis_enable] [get_bd_pins tc_v_vid_in_axi4s_0/vid_io_in_ce] [get_bd_pins xlconstant_high/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins tc_v_vid_in_axi4s_0/vid_data] [get_bd_pins xlslice_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
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


  # Create interface ports
  set idt5901 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 idt5901 ]
  set cam1_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 cam1_iic ]
  set cam2_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 cam2_iic ]
  set lepton_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 lepton_iic ]
  set lepton_spi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 lepton_spi ]

  # Create ports
  set cam1_xclk [ create_bd_port -dir O -type clk cam1_xclk ]
  set cam1_pclk [ create_bd_port -dir I cam1_pclk ]
  set cam1_hsync [ create_bd_port -dir I cam1_hsync ]
  set cam1_vsync [ create_bd_port -dir I cam1_vsync ]
  set cam1_pixel [ create_bd_port -dir I -from 9 -to 0 cam1_pixel ]
  set cam2_xclk [ create_bd_port -dir O -type clk cam2_xclk ]
  set cam2_pclk [ create_bd_port -dir I cam2_pclk ]
  set cam2_hsync [ create_bd_port -dir I cam2_hsync ]
  set cam2_vsync [ create_bd_port -dir I cam2_vsync ]
  set cam2_pixel [ create_bd_port -dir I -from 9 -to 0 cam2_pixel ]


  # Create instance: idt5901_clk
  create_hier_cell_idt5901_clk [current_bd_instance .] idt5901_clk

  # Create instance: zynq_ultra_ps_e_0, and set properties
  #set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.0 zynq_ultra_ps_e_0 ]
  set zynq_ultra_ps_e_0 [get_bd_cells zynq_ultra_ps_e_0]
  # Apply default board preset
  apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1" }  [get_bd_cells zynq_ultra_ps_e_0]
  # DP configuration
  set_property -dict [list CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__USE__VIDEO {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__VIDEO_REF_CLK__ENABLE {0}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__VIDEO_REF_CLK__IO {<Select>}] [get_bd_cells zynq_ultra_ps_e_0]
  # GT Ref Clocks
  set_property -dict [list CONFIG.PSU__USB0__REF_CLK_FREQ {26}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk0}] [get_bd_cells zynq_ultra_ps_e_0]
  #set_property -dict [list CONFIG.PSU__USB1__REF_CLK_FREQ {<Select>}] [get_bd_cells zynq_ultra_ps_e_0]
  #set_property -dict [list CONFIG.PSU__USB1__REF_CLK_SEL {<Select>}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__SATA__REF_CLK_FREQ {125}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1}] [get_bd_cells zynq_ultra_ps_e_0] 
  set_property -dict [list CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__DP__REF_CLK_FREQ {27}] [get_bd_cells zynq_ultra_ps_e_0]
  # PS clock configuration
  set_property -dict [list CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL}] [get_bd_cells zynq_ultra_ps_e_0]
  # PL clock configuration
  set_property -dict [list CONFIG.PSU__FPGA_PL0_ENABLE {1} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__FPGA_PL1_ENABLE {1} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL {IOPLL} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {15} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {4} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__FPGA_PL2_ENABLE {1} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {RPLL} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__FPGA_PL3_ENABLE {1} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL3_REF_CTRL__SRCSEL {RPLL} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {3} ] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} ] [get_bd_cells zynq_ultra_ps_e_0]
  # PS-PL interface configuration
  set_property -dict [list CONFIG.PSU__USE__M_AXI_GP0 {0}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__USE__M_AXI_GP1 {0}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__USE__M_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__USE__S_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  #set_property -dict [list CONFIG.PSU__HIGH_ADDRESS__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
  # IRQ configuration
  set_property -dict [list CONFIG.PSU__USE__IRQ0 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  # EMIO GPIO configuration
  #set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]  
  # PL fabric clocks
  set_property -dict [list CONFIG.PSU__NUM_FABRIC_RESETS {2}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {200}] [get_bd_cells zynq_ultra_ps_e_0]

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz clk_wiz_1 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {200.02} \
CONFIG.CLKOUT1_DRIVES {Buffer} \
CONFIG.CLKOUT1_JITTER {163.726} \
CONFIG.CLKOUT1_PHASE_ERROR {154.695} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} \
CONFIG.CLKOUT2_DRIVES {Buffer} \
CONFIG.CLKOUT2_JITTER {148.390} \
CONFIG.CLKOUT2_PHASE_ERROR {154.695} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {75.000} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.CLKOUT3_DRIVES {Buffer} \
CONFIG.CLKOUT3_JITTER {129.940} \
CONFIG.CLKOUT3_PHASE_ERROR {154.695} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {150.000} \
CONFIG.CLKOUT3_USED {true} \
CONFIG.CLKOUT4_DRIVES {Buffer} \
CONFIG.CLKOUT4_JITTER {116.512} \
CONFIG.CLKOUT4_PHASE_ERROR {154.695} \
CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {300.000} \
CONFIG.CLKOUT4_USED {true} \
CONFIG.CLKOUT5_DRIVES {Buffer} \
CONFIG.CLKOUT5_JITTER {124.151} \
CONFIG.CLKOUT5_PHASE_ERROR {154.695} \
CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {200.000} \
CONFIG.CLKOUT5_USED {true} \
CONFIG.CLKOUT6_DRIVES {Buffer} \
CONFIG.CLKOUT7_DRIVES {Buffer} \
CONFIG.MMCM_CLKFBOUT_MULT_F {24.000} \
CONFIG.MMCM_CLKIN1_PERIOD {20.002} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {24.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {16} \
CONFIG.MMCM_CLKOUT2_DIVIDE {8} \
CONFIG.MMCM_CLKOUT3_DIVIDE {4} \
CONFIG.MMCM_CLKOUT4_DIVIDE {6} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {5} \
CONFIG.PHASESHIFT_MODE {LATENCY} \
CONFIG.PRIM_SOURCE {No_buffer} \
CONFIG.USE_INCLK_SWITCHOVER {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_1

  # Create instance: proc_sys_reset_clk50, and set properties
  set proc_sys_reset_clk50 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_clk50 ]
  set_property -dict [ list \
CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_clk50

  # Create instance: proc_sys_reset_clk75, and set properties
  set proc_sys_reset_clk75 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_clk75 ]
  set_property -dict [ list \
CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_clk75

  # Create instance: proc_sys_reset_clk150, and set properties
  set proc_sys_reset_clk150 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_clk150 ]
  set_property -dict [ list \
CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_clk150

  # Create instance: proc_sys_reset_clk300, and set properties
  set proc_sys_reset_clk300 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_clk300 ]
  set_property -dict [ list \
CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_clk300

  # Create instance: xlconcat_0
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list CONFIG.NUM_PORTS {6} ] $xlconcat_0

  # Create instance: TDnext_capture_1
  create_hier_cell_TDnext_capture [current_bd_instance .] TDnext_capture_1

  # Create instance: TDnext_capture_2
  create_hier_cell_TDnext_capture [current_bd_instance .] TDnext_capture_2

  # Create instance: cam1_iic
  set cam1_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic cam1_iic ]
  # for axi_lite_clk=100Mhz, SCL_INERTIAL_DELAY=30 for 300ns hold time, SDA_INERTIAL_DELAY=5 for 50ns pulse rejection
  set_property -dict [list CONFIG.C_SCL_INERTIAL_DELAY {30} CONFIG.C_SDA_INERTIAL_DELAY {5}] [get_bd_cells cam1_iic]

  # Create instance: cam2_iic
  set cam2_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic cam2_iic ]
  # for axi_lite_clk=100Mhz, SCL_INERTIAL_DELAY=30 for 300ns hold time, SDA_INERTIAL_DELAY=5 for 50ns pulse rejection
  set_property -dict [list CONFIG.C_SCL_INERTIAL_DELAY {30} CONFIG.C_SDA_INERTIAL_DELAY {5}] [get_bd_cells cam2_iic]

  # Create instance: lepton_iic
  set lepton_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic lepton_iic ]
  # for axi_lite_clk=100Mhz, SCL_INERTIAL_DELAY=30 for 300ns hold time, SDA_INERTIAL_DELAY=5 for 50ns pulse rejection
  set_property -dict [list CONFIG.C_SCL_INERTIAL_DELAY {30} CONFIG.C_SDA_INERTIAL_DELAY {5}] [get_bd_cells lepton_iic]

  # Create instance: lepton_spi, and set properties
  set lepton_spi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi lepton_spi ]
  set_property -dict [ list \
CONFIG.C_USE_STARTUP {0} \
CONFIG.C_USE_STARTUP_INT {0} \
 ] $lepton_spi

  # ps8_0_axi_periph
  set_property -dict [list CONFIG.NUM_MI {15}] [get_bd_cells ps8_0_axi_periph]

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {2} \
 ] $axi_mem_intercon


  # Create interface connections
  #connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_ports idt5901] [get_bd_intf_pins idt5901_clk/CLK_IN_D]
  #
  connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD] -boundary_type upper [get_bd_intf_pins axi_mem_intercon/M00_AXI]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins TDnext_capture_1/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins TDnext_capture_2/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S01_AXI]
  #
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M03_AXI] [get_bd_intf_pins TDnext_capture_1/ctrl_cfa]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M04_AXI] [get_bd_intf_pins TDnext_capture_1/ctrl_cresample]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M05_AXI] [get_bd_intf_pins TDnext_capture_1/ctrl_rgb2yuv]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M06_AXI] [get_bd_intf_pins TDnext_capture_1/ctrl_vdma]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M07_AXI] [get_bd_intf_pins TDnext_capture_2/ctrl_cfa]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M08_AXI] [get_bd_intf_pins TDnext_capture_2/ctrl_cresample]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M09_AXI] [get_bd_intf_pins TDnext_capture_2/ctrl_rgb2yuv]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M10_AXI] [get_bd_intf_pins TDnext_capture_2/ctrl_vdma]
  #
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M11_AXI] [get_bd_intf_pins cam1_iic/S_AXI]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M12_AXI] [get_bd_intf_pins cam2_iic/S_AXI]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M13_AXI] [get_bd_intf_pins lepton_iic/S_AXI]
  connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M14_AXI] [get_bd_intf_pins lepton_spi/AXI_LITE]
  #
  connect_bd_intf_net [get_bd_intf_ports cam1_iic] [get_bd_intf_pins cam1_iic/IIC]
  connect_bd_intf_net [get_bd_intf_ports cam2_iic] [get_bd_intf_pins cam2_iic/IIC]
  #
  connect_bd_intf_net [get_bd_intf_ports lepton_iic] [get_bd_intf_pins lepton_iic/IIC]
  connect_bd_intf_net [get_bd_intf_ports lepton_spi] [get_bd_intf_pins lepton_spi/SPI_0]

  # Create port connections
  # IDT5901
  connect_bd_net -net video_clk_1 [get_bd_pins idt5901_clk/BUFG_O] [get_bd_pins zynq_ultra_ps_e_0/dp_video_in_clk]
  # clock wizard + resets
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk1] [get_bd_pins clk_wiz_1/clk_in1]
  connect_bd_net -net clk_50mhz [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins proc_sys_reset_clk50/slowest_sync_clk]
  connect_bd_net -net clk_75mhz [get_bd_pins clk_wiz_1/clk_out2] [get_bd_pins proc_sys_reset_clk75/slowest_sync_clk]
  connect_bd_net -net clk_150mhz [get_bd_pins clk_wiz_1/clk_out3] [get_bd_pins proc_sys_reset_clk150/slowest_sync_clk]
  connect_bd_net -net clk_300mhz [get_bd_pins clk_wiz_1/clk_out4] [get_bd_pins proc_sys_reset_clk300/slowest_sync_clk]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins proc_sys_reset_clk50/dcm_locked] [get_bd_pins proc_sys_reset_clk75/dcm_locked] [get_bd_pins proc_sys_reset_clk150/dcm_locked] [get_bd_pins proc_sys_reset_clk300/dcm_locked]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn1] [get_bd_pins proc_sys_reset_clk50/ext_reset_in] [get_bd_pins proc_sys_reset_clk75/ext_reset_in] [get_bd_pins proc_sys_reset_clk150/ext_reset_in] [get_bd_pins proc_sys_reset_clk300/ext_reset_in]
  # interrupts
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0] [get_bd_pins xlconcat_0/dout]
  connect_bd_net [get_bd_pins TDnext_capture_1/s2mm_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net [get_bd_pins TDnext_capture_2/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  # TDNext_capture
  connect_bd_net [get_bd_pins TDnext_capture_1/s_axi_lite_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins TDnext_capture_2/s_axi_lite_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins TDnext_capture_1/axi_resetn] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins TDnext_capture_2/axi_resetn] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins TDnext_capture_2/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
  connect_bd_net [get_bd_pins TDnext_capture_1/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]
  connect_bd_net [get_bd_pins TDnext_capture_1/aresetn] [get_bd_pins proc_sys_reset_clk150/peripheral_aresetn]
  connect_bd_net [get_bd_pins TDnext_capture_2/aresetn] [get_bd_pins proc_sys_reset_clk150/peripheral_aresetn]
  connect_bd_net [get_bd_pins TDnext_capture_1/m_axi_s2mm_aclk] [get_bd_pins clk_wiz_1/clk_out3]
  connect_bd_net [get_bd_pins TDnext_capture_2/m_axi_s2mm_aclk] [get_bd_pins clk_wiz_1/clk_out3]
  #
  connect_bd_net [get_bd_ports cam1_xclk] [get_bd_pins TDnext_capture_1/xclk]
  connect_bd_net [get_bd_ports cam1_pclk] [get_bd_pins TDnext_capture_1/pclk]
  connect_bd_net [get_bd_ports cam1_hsync] [get_bd_pins TDnext_capture_1/line_valid_in]
  connect_bd_net [get_bd_ports cam1_vsync] [get_bd_pins TDnext_capture_1/frame_valid_in]
  connect_bd_net [get_bd_ports cam1_pixel] [get_bd_pins TDnext_capture_1/pixel_in]
  #
  connect_bd_net [get_bd_ports cam2_xclk] [get_bd_pins TDnext_capture_2/xclk]
  connect_bd_net [get_bd_ports cam2_pclk] [get_bd_pins TDnext_capture_2/pclk]
  connect_bd_net [get_bd_ports cam2_hsync] [get_bd_pins TDnext_capture_2/line_valid_in]
  connect_bd_net [get_bd_ports cam2_vsync] [get_bd_pins TDnext_capture_2/frame_valid_in]
  connect_bd_net [get_bd_ports cam2_pixel] [get_bd_pins TDnext_capture_2/pixel_in]
  # GP AXI interconnect
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M03_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M04_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M05_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M06_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M07_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M08_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M09_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M10_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M03_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M04_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M05_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M06_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M07_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M08_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M09_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M10_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M11_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M12_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M13_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M14_ACLK] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M11_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M12_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M13_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins ps8_0_axi_periph/M14_ARESETN] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  # HP AXI interconnect
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] [get_bd_pins clk_wiz_1/clk_out3]
  connect_bd_net [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins clk_wiz_1/clk_out3]
  connect_bd_net [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins clk_wiz_1/clk_out3]
  connect_bd_net [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins clk_wiz_1/clk_out3]
  connect_bd_net [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins clk_wiz_1/clk_out3]
  connect_bd_net [get_bd_pins proc_sys_reset_clk150/interconnect_aresetn] [get_bd_pins axi_mem_intercon/ARESETN]
  connect_bd_net [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins proc_sys_reset_clk150/peripheral_aresetn]
  connect_bd_net [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins proc_sys_reset_clk150/peripheral_aresetn]
  connect_bd_net [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins proc_sys_reset_clk150/peripheral_aresetn]
  # interrupts
  connect_bd_net [get_bd_pins cam1_iic/iic2intc_irpt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net [get_bd_pins cam2_iic/iic2intc_irpt] [get_bd_pins xlconcat_0/In3]
  connect_bd_net [get_bd_pins lepton_iic/iic2intc_irpt] [get_bd_pins xlconcat_0/In4]
  connect_bd_net [get_bd_pins lepton_spi/ip2intc_irpt] [get_bd_pins xlconcat_0/In5]
  #
  connect_bd_net [get_bd_pins cam1_iic/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins cam1_iic/s_axi_aresetn] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins cam2_iic/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins cam2_iic/s_axi_aresetn] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  #
  connect_bd_net [get_bd_pins lepton_iic/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins lepton_iic/s_axi_aresetn] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins lepton_spi/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
  connect_bd_net [get_bd_pins lepton_spi/s_axi_aresetn] [get_bd_pins rst_ps8_0_99M/peripheral_aresetn]
  connect_bd_net [get_bd_pins lepton_spi/ext_spi_clk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

  # Create address segments
  # cam1 pipeline
  create_bd_addr_seg -range 0x00010000 -offset 0x0080110000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TDnext_capture_1/tc_v_cfa_0/ctrl/Reg] SEG_cam1_v_cfa_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x0080120000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TDnext_capture_1/tc_v_rgb2ycrcb_0/ctrl/Reg] SEG_cam1_v_rgb2ycrcb_0_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x0080130000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TDnext_capture_1/tc_v_cresample_0/ctrl/Reg] SEG_cam1_v_cresample_0_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x0080140000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TDnext_capture_1/tc_vdma_0/S_AXI_LITE/Reg] SEG_cam1_axi_vdma_0_Reg1
  # cam2 pipeline
  create_bd_addr_seg -range 0x00010000 -offset 0x0080210000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TDnext_capture_2/tc_v_cfa_0/ctrl/Reg] SEG_cam2_v_cfa_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x0080220000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TDnext_capture_2/tc_v_rgb2ycrcb_0/ctrl/Reg] SEG_cam2_v_rgb2ycrcb_0_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x0080230000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TDnext_capture_2/tc_v_cresample_0/ctrl/Reg] SEG_cam2_v_cresample_0_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x0080240000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TDnext_capture_2/tc_vdma_0/S_AXI_LITE/Reg] SEG_cam2_axi_vdma_0_Reg1
  #
  create_bd_addr_seg -range 0x00010000 -offset 0x0080100000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs cam1_iic/S_AXI/Reg] SEG_cam1_iic_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x0080200000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs cam2_iic/S_AXI/Reg] SEG_cam2_iic_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x0080300000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs lepton_iic/S_AXI/Reg] SEG_lepton_iic_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x0080310000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs lepton_spi/AXI_LITE/Reg] SEG_lepton_spi_Reg
  #
  #assign_bd_address

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


