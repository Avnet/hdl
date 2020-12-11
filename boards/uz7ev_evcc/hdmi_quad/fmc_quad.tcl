
################################################################
# This is a generated script based on design: UZ7EV_EVCC_HDMI_QUAD
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
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source UZ7EV_EVCC_HDMI_QUAD_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axi_iic:2.0\
xilinx.com:ip:xlslice:1.0\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:axis_switch:1.1\
xilinx.com:ip:mipi_csi2_rx_subsystem:5.1\
xilinx.com:ip:v_demosaic:1.1\
xilinx.com:ip:v_frmbuf_wr:2.2\
xilinx.com:ip:v_proc_ss:2.3\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: capture_pipeline_3
proc create_hier_cell_capture_pipeline_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_capture_pipeline_3() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir O -type intr s2mm_introut

  # Create instance: demosaic_rst_gpio_3, and set properties
  set demosaic_rst_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 demosaic_rst_gpio_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {26} \
   CONFIG.DIN_TO {26} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $demosaic_rst_gpio_3

  # Create instance: frmbuf_wr_rst_gpio_3, and set properties
  set frmbuf_wr_rst_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 frmbuf_wr_rst_gpio_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {28} \
   CONFIG.DIN_TO {28} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $frmbuf_wr_rst_gpio_3

  # Create instance: v_demosaic_3, and set properties
  set v_demosaic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 v_demosaic_3 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ZIPPER_REMOVAL {false} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
   CONFIG.USE_URAM {0} \
 ] $v_demosaic_3

  # Create instance: v_frmbuf_wr_3, and set properties
  set v_frmbuf_wr_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.2 v_frmbuf_wr_3 ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_BGR8 {1} \
   CONFIG.HAS_RGB8 {0} \
   CONFIG.HAS_RGBX8 {0} \
   CONFIG.HAS_UYVY8 {1} \
   CONFIG.HAS_Y8 {1} \
   CONFIG.HAS_YUV8 {0} \
   CONFIG.HAS_YUVX8 {0} \
   CONFIG.HAS_YUYV8 {1} \
   CONFIG.HAS_Y_UV8 {0} \
   CONFIG.HAS_Y_UV8_420 {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_NR_PLANES {1} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_wr_3

  # Create instance: v_proc_ss_csc_3, and set properties
  set v_proc_ss_csc_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_csc_3 ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {1} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {1920} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {1080} \
   CONFIG.C_SAMPLES_PER_CLK {1} \
   CONFIG.C_TOPOLOGY {3} \
   CONFIG.C_USE_URAM {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_csc_3

  # Create instance: v_proc_ss_scaler_3, and set properties
  set v_proc_ss_scaler_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_scaler_3 ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {1} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {1920} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {1080} \
   CONFIG.C_SAMPLES_PER_CLK {1} \
   CONFIG.C_TOPOLOGY {0} \
   CONFIG.C_USE_URAM {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_scaler_3

  # Create instance: vpss_csc_rst_gpio_3, and set properties
  set vpss_csc_rst_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_csc_rst_gpio_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {16} \
   CONFIG.DIN_TO {16} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_csc_rst_gpio_3

  # Create instance: vpss_scaler_rst_gpio_3, and set properties
  set vpss_scaler_rst_gpio_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_scaler_rst_gpio_3 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {27} \
   CONFIG.DIN_TO {27} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_scaler_rst_gpio_3

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins csc_ctrl] [get_bd_intf_pins v_proc_ss_csc_3/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins scaler_ctrl] [get_bd_intf_pins v_proc_ss_scaler_3/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins frmbuf_ctrl] [get_bd_intf_pins v_frmbuf_wr_3/s_axi_CTRL]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins s_axis_video] [get_bd_intf_pins v_demosaic_3/s_axis_video]
  connect_bd_intf_net -intf_net ctrl_1 [get_bd_intf_pins demosaic_ctrl] [get_bd_intf_pins v_demosaic_3/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_demosaic_0_m_axis_video [get_bd_intf_pins v_demosaic_3/m_axis_video] [get_bd_intf_pins v_proc_ss_csc_3/s_axis]
  connect_bd_intf_net -intf_net v_frmbuf_wr_3_m_axi_mm_video [get_bd_intf_pins M_AXI] [get_bd_intf_pins v_frmbuf_wr_3/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_proc_ss_csc_3_m_axis [get_bd_intf_pins v_proc_ss_csc_3/m_axis] [get_bd_intf_pins v_proc_ss_scaler_3/s_axis]
  connect_bd_intf_net -intf_net v_proc_ss_scaler_3_m_axis [get_bd_intf_pins v_frmbuf_wr_3/s_axis_video] [get_bd_intf_pins v_proc_ss_scaler_3/m_axis]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins demosaic_rst_gpio_3/Din] [get_bd_pins frmbuf_wr_rst_gpio_3/Din] [get_bd_pins vpss_csc_rst_gpio_3/Din] [get_bd_pins vpss_scaler_rst_gpio_3/Din]
  connect_bd_net -net clk_150mhz [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins v_demosaic_3/ap_clk] [get_bd_pins v_frmbuf_wr_3/ap_clk] [get_bd_pins v_proc_ss_csc_3/aclk] [get_bd_pins v_proc_ss_scaler_3/aclk_axis] [get_bd_pins v_proc_ss_scaler_3/aclk_ctrl]
  connect_bd_net -net demosaic_rst_gpio_Dout [get_bd_pins demosaic_rst_gpio_3/Dout] [get_bd_pins v_demosaic_3/ap_rst_n]
  connect_bd_net -net frmbuf_wr_rst_gpio_Dout [get_bd_pins frmbuf_wr_rst_gpio_3/Dout] [get_bd_pins v_frmbuf_wr_3/ap_rst_n]
  connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins s2mm_introut] [get_bd_pins v_frmbuf_wr_3/interrupt]
  connect_bd_net -net vpss_scaler_rst_gpio_3_Dout [get_bd_pins v_proc_ss_csc_3/aresetn] [get_bd_pins vpss_csc_rst_gpio_3/Dout]
  connect_bd_net -net vpss_scaler_rst_gpio_4_Dout [get_bd_pins v_proc_ss_scaler_3/aresetn_ctrl] [get_bd_pins vpss_scaler_rst_gpio_3/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: capture_pipeline_2
proc create_hier_cell_capture_pipeline_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_capture_pipeline_2() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir O -type intr s2mm_introut

  # Create instance: demosaic_rst_gpio_2, and set properties
  set demosaic_rst_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 demosaic_rst_gpio_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {23} \
   CONFIG.DIN_TO {23} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $demosaic_rst_gpio_2

  # Create instance: frmbuf_wr_rst_gpio_2, and set properties
  set frmbuf_wr_rst_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 frmbuf_wr_rst_gpio_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {25} \
   CONFIG.DIN_TO {25} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $frmbuf_wr_rst_gpio_2

  # Create instance: v_demosaic_2, and set properties
  set v_demosaic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 v_demosaic_2 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ZIPPER_REMOVAL {false} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
   CONFIG.USE_URAM {0} \
 ] $v_demosaic_2

  # Create instance: v_frmbuf_wr_2, and set properties
  set v_frmbuf_wr_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.2 v_frmbuf_wr_2 ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_BGR8 {1} \
   CONFIG.HAS_RGB8 {0} \
   CONFIG.HAS_RGBX8 {0} \
   CONFIG.HAS_UYVY8 {1} \
   CONFIG.HAS_Y8 {1} \
   CONFIG.HAS_YUV8 {0} \
   CONFIG.HAS_YUVX8 {0} \
   CONFIG.HAS_YUYV8 {1} \
   CONFIG.HAS_Y_UV8 {0} \
   CONFIG.HAS_Y_UV8_420 {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_NR_PLANES {1} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_wr_2

  # Create instance: v_proc_ss_csc_2, and set properties
  set v_proc_ss_csc_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_csc_2 ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {1} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {1920} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {1080} \
   CONFIG.C_SAMPLES_PER_CLK {1} \
   CONFIG.C_TOPOLOGY {3} \
   CONFIG.C_USE_URAM {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_csc_2

  # Create instance: v_proc_ss_scaler_2, and set properties
  set v_proc_ss_scaler_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_scaler_2 ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {1} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {1920} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {1080} \
   CONFIG.C_SAMPLES_PER_CLK {1} \
   CONFIG.C_TOPOLOGY {0} \
   CONFIG.C_USE_URAM {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_scaler_2

  # Create instance: vpss_csc_rst_gpio_2, and set properties
  set vpss_csc_rst_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_csc_rst_gpio_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {15} \
   CONFIG.DIN_TO {15} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_csc_rst_gpio_2

  # Create instance: vpss_scaler_rst_gpio_2, and set properties
  set vpss_scaler_rst_gpio_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_scaler_rst_gpio_2 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {24} \
   CONFIG.DIN_TO {24} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_scaler_rst_gpio_2

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins csc_ctrl] [get_bd_intf_pins v_proc_ss_csc_2/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins scaler_ctrl] [get_bd_intf_pins v_proc_ss_scaler_2/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins frmbuf_ctrl] [get_bd_intf_pins v_frmbuf_wr_2/s_axi_CTRL]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins s_axis_video] [get_bd_intf_pins v_demosaic_2/s_axis_video]
  connect_bd_intf_net -intf_net ctrl_1 [get_bd_intf_pins demosaic_ctrl] [get_bd_intf_pins v_demosaic_2/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_demosaic_0_m_axis_video [get_bd_intf_pins v_demosaic_2/m_axis_video] [get_bd_intf_pins v_proc_ss_csc_2/s_axis]
  connect_bd_intf_net -intf_net v_frmbuf_wr_2_m_axi_mm_video [get_bd_intf_pins M_AXI] [get_bd_intf_pins v_frmbuf_wr_2/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_proc_ss_csc_2_m_axis [get_bd_intf_pins v_proc_ss_csc_2/m_axis] [get_bd_intf_pins v_proc_ss_scaler_2/s_axis]
  connect_bd_intf_net -intf_net v_proc_ss_scaler_2_m_axis [get_bd_intf_pins v_frmbuf_wr_2/s_axis_video] [get_bd_intf_pins v_proc_ss_scaler_2/m_axis]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins demosaic_rst_gpio_2/Din] [get_bd_pins frmbuf_wr_rst_gpio_2/Din] [get_bd_pins vpss_csc_rst_gpio_2/Din] [get_bd_pins vpss_scaler_rst_gpio_2/Din]
  connect_bd_net -net clk_150mhz [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins v_demosaic_2/ap_clk] [get_bd_pins v_frmbuf_wr_2/ap_clk] [get_bd_pins v_proc_ss_csc_2/aclk] [get_bd_pins v_proc_ss_scaler_2/aclk_axis] [get_bd_pins v_proc_ss_scaler_2/aclk_ctrl]
  connect_bd_net -net demosaic_rst_gpio_Dout [get_bd_pins demosaic_rst_gpio_2/Dout] [get_bd_pins v_demosaic_2/ap_rst_n]
  connect_bd_net -net frmbuf_wr_rst_gpio_Dout [get_bd_pins frmbuf_wr_rst_gpio_2/Dout] [get_bd_pins v_frmbuf_wr_2/ap_rst_n]
  connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins s2mm_introut] [get_bd_pins v_frmbuf_wr_2/interrupt]
  connect_bd_net -net vpss_scaler_rst_gpio_2_Dout [get_bd_pins v_proc_ss_csc_2/aresetn] [get_bd_pins vpss_csc_rst_gpio_2/Dout]
  connect_bd_net -net vpss_scaler_rst_gpio_2_Dout1 [get_bd_pins v_proc_ss_scaler_2/aresetn_ctrl] [get_bd_pins vpss_scaler_rst_gpio_2/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: capture_pipeline_1
proc create_hier_cell_capture_pipeline_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_capture_pipeline_1() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir O -type intr s2mm_introut

  # Create instance: demosaic_rst_gpio_1, and set properties
  set demosaic_rst_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 demosaic_rst_gpio_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {20} \
   CONFIG.DIN_TO {20} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $demosaic_rst_gpio_1

  # Create instance: frmbuf_wr_rst_gpio_1, and set properties
  set frmbuf_wr_rst_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 frmbuf_wr_rst_gpio_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {22} \
   CONFIG.DIN_TO {22} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $frmbuf_wr_rst_gpio_1

  # Create instance: v_demosaic_1, and set properties
  set v_demosaic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 v_demosaic_1 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ZIPPER_REMOVAL {false} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
   CONFIG.USE_URAM {0} \
 ] $v_demosaic_1

  # Create instance: v_frmbuf_wr_1, and set properties
  set v_frmbuf_wr_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.2 v_frmbuf_wr_1 ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_BGR8 {1} \
   CONFIG.HAS_RGB8 {0} \
   CONFIG.HAS_RGBX8 {0} \
   CONFIG.HAS_UYVY8 {1} \
   CONFIG.HAS_Y8 {1} \
   CONFIG.HAS_YUV8 {0} \
   CONFIG.HAS_YUVX8 {0} \
   CONFIG.HAS_YUYV8 {1} \
   CONFIG.HAS_Y_UV8 {0} \
   CONFIG.HAS_Y_UV8_420 {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_NR_PLANES {1} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_wr_1

  # Create instance: v_proc_ss_csc_1, and set properties
  set v_proc_ss_csc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_csc_1 ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {1} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {1920} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {1080} \
   CONFIG.C_SAMPLES_PER_CLK {1} \
   CONFIG.C_TOPOLOGY {3} \
   CONFIG.C_USE_URAM {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_csc_1

  # Create instance: v_proc_ss_scaler_1, and set properties
  set v_proc_ss_scaler_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_scaler_1 ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {1} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {1920} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {1080} \
   CONFIG.C_SAMPLES_PER_CLK {1} \
   CONFIG.C_TOPOLOGY {0} \
   CONFIG.C_USE_URAM {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_scaler_1

  # Create instance: vpss_csc_rst_gpio_1, and set properties
  set vpss_csc_rst_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_csc_rst_gpio_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {14} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_csc_rst_gpio_1

  # Create instance: vpss_scaler_rst_gpio_1, and set properties
  set vpss_scaler_rst_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_scaler_rst_gpio_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {21} \
   CONFIG.DIN_TO {21} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_scaler_rst_gpio_1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins csc_ctrl] [get_bd_intf_pins v_proc_ss_csc_1/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins scaler_ctrl] [get_bd_intf_pins v_proc_ss_scaler_1/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins frmbuf_ctrl] [get_bd_intf_pins v_frmbuf_wr_1/s_axi_CTRL]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins s_axis_video] [get_bd_intf_pins v_demosaic_1/s_axis_video]
  connect_bd_intf_net -intf_net ctrl_1 [get_bd_intf_pins demosaic_ctrl] [get_bd_intf_pins v_demosaic_1/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_demosaic_0_m_axis_video [get_bd_intf_pins v_demosaic_1/m_axis_video] [get_bd_intf_pins v_proc_ss_csc_1/s_axis]
  connect_bd_intf_net -intf_net v_frmbuf_wr_1_m_axi_mm_video [get_bd_intf_pins M_AXI] [get_bd_intf_pins v_frmbuf_wr_1/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_proc_ss_csc_1_m_axis [get_bd_intf_pins v_proc_ss_csc_1/m_axis] [get_bd_intf_pins v_proc_ss_scaler_1/s_axis]
  connect_bd_intf_net -intf_net v_proc_ss_scaler_1_m_axis [get_bd_intf_pins v_frmbuf_wr_1/s_axis_video] [get_bd_intf_pins v_proc_ss_scaler_1/m_axis]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins demosaic_rst_gpio_1/Din] [get_bd_pins frmbuf_wr_rst_gpio_1/Din] [get_bd_pins vpss_csc_rst_gpio_1/Din] [get_bd_pins vpss_scaler_rst_gpio_1/Din]
  connect_bd_net -net clk_150mhz [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins v_demosaic_1/ap_clk] [get_bd_pins v_frmbuf_wr_1/ap_clk] [get_bd_pins v_proc_ss_csc_1/aclk] [get_bd_pins v_proc_ss_scaler_1/aclk_axis] [get_bd_pins v_proc_ss_scaler_1/aclk_ctrl]
  connect_bd_net -net demosaic_rst_gpio_Dout [get_bd_pins demosaic_rst_gpio_1/Dout] [get_bd_pins v_demosaic_1/ap_rst_n]
  connect_bd_net -net frmbuf_wr_rst_gpio_Dout [get_bd_pins frmbuf_wr_rst_gpio_1/Dout] [get_bd_pins v_frmbuf_wr_1/ap_rst_n]
  connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins s2mm_introut] [get_bd_pins v_frmbuf_wr_1/interrupt]
  connect_bd_net -net vpss_scaler_rst_gpio_1_Dout [get_bd_pins v_proc_ss_csc_1/aresetn] [get_bd_pins vpss_csc_rst_gpio_1/Dout]
  connect_bd_net -net vpss_scaler_rst_gpio_1_Dout1 [get_bd_pins v_proc_ss_scaler_1/aresetn_ctrl] [get_bd_pins vpss_scaler_rst_gpio_1/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: capture_pipeline_0
proc create_hier_cell_capture_pipeline_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_capture_pipeline_0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir O -type intr s2mm_introut

  # Create instance: demosaic_rst_gpio_0, and set properties
  set demosaic_rst_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 demosaic_rst_gpio_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {7} \
   CONFIG.DIN_TO {7} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $demosaic_rst_gpio_0

  # Create instance: frmbuf_wr_rst_gpio_0, and set properties
  set frmbuf_wr_rst_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 frmbuf_wr_rst_gpio_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {5} \
   CONFIG.DIN_TO {5} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $frmbuf_wr_rst_gpio_0

  # Create instance: v_demosaic_0, and set properties
  set v_demosaic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_demosaic:1.1 v_demosaic_0 ]
  set_property -dict [ list \
   CONFIG.ENABLE_ZIPPER_REMOVAL {false} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
   CONFIG.USE_URAM {0} \
 ] $v_demosaic_0

  # Create instance: v_frmbuf_wr_0, and set properties
  set v_frmbuf_wr_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_frmbuf_wr:2.2 v_frmbuf_wr_0 ]
  set_property -dict [ list \
   CONFIG.AXIMM_DATA_WIDTH {64} \
   CONFIG.C_M_AXI_MM_VIDEO_DATA_WIDTH {64} \
   CONFIG.HAS_BGR8 {1} \
   CONFIG.HAS_RGB8 {0} \
   CONFIG.HAS_RGBX8 {0} \
   CONFIG.HAS_UYVY8 {1} \
   CONFIG.HAS_Y8 {1} \
   CONFIG.HAS_YUV8 {0} \
   CONFIG.HAS_YUVX8 {0} \
   CONFIG.HAS_YUYV8 {1} \
   CONFIG.HAS_Y_UV8 {0} \
   CONFIG.HAS_Y_UV8_420 {0} \
   CONFIG.MAX_COLS {1920} \
   CONFIG.MAX_NR_PLANES {1} \
   CONFIG.MAX_ROWS {1080} \
   CONFIG.SAMPLES_PER_CLOCK {1} \
 ] $v_frmbuf_wr_0

  # Create instance: v_proc_ss_csc_0, and set properties
  set v_proc_ss_csc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_csc_0 ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {1} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {1920} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {1080} \
   CONFIG.C_SAMPLES_PER_CLK {1} \
   CONFIG.C_TOPOLOGY {3} \
   CONFIG.C_USE_URAM {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_csc_0

  # Create instance: v_proc_ss_scaler_0, and set properties
  set v_proc_ss_scaler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_proc_ss:2.3 v_proc_ss_scaler_0 ]
  set_property -dict [ list \
   CONFIG.C_COLORSPACE_SUPPORT {1} \
   CONFIG.C_ENABLE_CSC {true} \
   CONFIG.C_H_SCALER_TAPS {8} \
   CONFIG.C_MAX_COLS {1920} \
   CONFIG.C_MAX_DATA_WIDTH {8} \
   CONFIG.C_MAX_ROWS {1080} \
   CONFIG.C_SAMPLES_PER_CLK {1} \
   CONFIG.C_SCALER_ALGORITHM {2} \
   CONFIG.C_TOPOLOGY {0} \
   CONFIG.C_USE_URAM {0} \
   CONFIG.C_V_SCALER_TAPS {8} \
 ] $v_proc_ss_scaler_0

  # Create instance: vpss_csc_rst_gpio_0, and set properties
  set vpss_csc_rst_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_csc_rst_gpio_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {6} \
   CONFIG.DIN_TO {6} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_csc_rst_gpio_0

  # Create instance: vpss_scaler_rst_gpio_0, and set properties
  set vpss_scaler_rst_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vpss_scaler_rst_gpio_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {4} \
   CONFIG.DIN_TO {4} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $vpss_scaler_rst_gpio_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins csc_ctrl] [get_bd_intf_pins v_proc_ss_csc_0/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins scaler_ctrl] [get_bd_intf_pins v_proc_ss_scaler_0/s_axi_ctrl]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins frmbuf_ctrl] [get_bd_intf_pins v_frmbuf_wr_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins s_axis_video] [get_bd_intf_pins v_demosaic_0/s_axis_video]
  connect_bd_intf_net -intf_net ctrl_1 [get_bd_intf_pins demosaic_ctrl] [get_bd_intf_pins v_demosaic_0/s_axi_CTRL]
  connect_bd_intf_net -intf_net v_demosaic_0_m_axis_video [get_bd_intf_pins v_demosaic_0/m_axis_video] [get_bd_intf_pins v_proc_ss_csc_0/s_axis]
  connect_bd_intf_net -intf_net v_frmbuf_wr_0_m_axi_mm_video [get_bd_intf_pins M_AXI] [get_bd_intf_pins v_frmbuf_wr_0/m_axi_mm_video]
  connect_bd_intf_net -intf_net v_proc_ss_scaler_0_m_axis [get_bd_intf_pins v_proc_ss_csc_0/m_axis] [get_bd_intf_pins v_proc_ss_scaler_0/s_axis]
  connect_bd_intf_net -intf_net v_proc_ss_scaler_1_m_axis [get_bd_intf_pins v_frmbuf_wr_0/s_axis_video] [get_bd_intf_pins v_proc_ss_scaler_0/m_axis]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins demosaic_rst_gpio_0/Din] [get_bd_pins frmbuf_wr_rst_gpio_0/Din] [get_bd_pins vpss_csc_rst_gpio_0/Din] [get_bd_pins vpss_scaler_rst_gpio_0/Din]
  connect_bd_net -net clk_150mhz [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins v_demosaic_0/ap_clk] [get_bd_pins v_frmbuf_wr_0/ap_clk] [get_bd_pins v_proc_ss_csc_0/aclk] [get_bd_pins v_proc_ss_scaler_0/aclk_axis] [get_bd_pins v_proc_ss_scaler_0/aclk_ctrl]
  connect_bd_net -net demosaic_rst_gpio_Dout [get_bd_pins demosaic_rst_gpio_0/Dout] [get_bd_pins v_demosaic_0/ap_rst_n]
  connect_bd_net -net frmbuf_wr_rst_gpio_Dout [get_bd_pins frmbuf_wr_rst_gpio_0/Dout] [get_bd_pins v_frmbuf_wr_0/ap_rst_n]
  connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins s2mm_introut] [get_bd_pins v_frmbuf_wr_0/interrupt]
  connect_bd_net -net vpss_scaler_rst_gpio_0_Dout [get_bd_pins v_proc_ss_csc_0/aresetn] [get_bd_pins vpss_csc_rst_gpio_0/Dout]
  connect_bd_net -net vpss_scaler_rst_gpio_1_Dout [get_bd_pins v_proc_ss_scaler_0/aresetn_ctrl] [get_bd_pins vpss_scaler_rst_gpio_0/Dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mipi_csi2_rx
proc create_hier_cell_mipi_csi2_rx { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mipi_csi2_rx() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl_3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csirxss_s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl_3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl_3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_s2mm_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_s2mm_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_s2mm_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_s2mm_3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 mipi_phy_if_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl_3


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I bg1_pin0_nc_0
  create_bd_pin -dir I bg3_pin0_nc_0
  create_bd_pin -dir O -type intr csirxss_csi_irq
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir O -type intr frmbuf_irq_0
  create_bd_pin -dir O -type intr frmbuf_irq_1
  create_bd_pin -dir O -type intr frmbuf_irq_2
  create_bd_pin -dir O -type intr frmbuf_irq_3
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir O -from 0 -to 0 sensor_rst_gpio
  create_bd_pin -dir I -type rst video_aresetn

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [ list \
   CONFIG.M_HAS_TKEEP {0} \
   CONFIG.M_HAS_TLAST {1} \
   CONFIG.M_HAS_TREADY {1} \
   CONFIG.M_HAS_TSTRB {0} \
   CONFIG.M_TDATA_NUM_BYTES {1} \
   CONFIG.M_TDEST_WIDTH {2} \
   CONFIG.M_TID_WIDTH {0} \
   CONFIG.M_TUSER_WIDTH {1} \
   CONFIG.S_HAS_TKEEP {0} \
   CONFIG.S_HAS_TLAST {1} \
   CONFIG.S_HAS_TREADY {1} \
   CONFIG.S_HAS_TSTRB {0} \
   CONFIG.S_TDATA_NUM_BYTES {2} \
   CONFIG.S_TDEST_WIDTH {8} \
   CONFIG.S_TID_WIDTH {0} \
   CONFIG.S_TUSER_WIDTH {1} \
   CONFIG.TDATA_REMAP {tdata[11:4]} \
   CONFIG.TDEST_REMAP {tdest[1:0]} \
   CONFIG.TLAST_REMAP {tlast[0]} \
   CONFIG.TUSER_REMAP {tuser[0:0]} \
 ] $axis_subset_converter_0

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.NUM_MI {4} \
   CONFIG.NUM_SI {1} \
   CONFIG.ROUTING_MODE {0} \
 ] $axis_switch_0

  # Create instance: capture_pipeline_0
  create_hier_cell_capture_pipeline_0 $hier_obj capture_pipeline_0

  # Create instance: capture_pipeline_1
  create_hier_cell_capture_pipeline_1 $hier_obj capture_pipeline_1

  # Create instance: capture_pipeline_2
  create_hier_cell_capture_pipeline_2 $hier_obj capture_pipeline_2

  # Create instance: capture_pipeline_3
  create_hier_cell_capture_pipeline_3 $hier_obj capture_pipeline_3

  # Create instance: mipi_csi2_rx_subsystem_0, and set properties
  set mipi_csi2_rx_subsystem_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mipi_csi2_rx_subsystem:5.1 mipi_csi2_rx_subsystem_0 ]
  set_property -dict [ list \
   CONFIG.CLK_LANE_IO_LOC {AF16} \
   CONFIG.CLK_LANE_IO_LOC_NAME {IO_L13P_T2L_N0_GC_QBC_64} \
   CONFIG.CMN_NUM_LANES {4} \
   CONFIG.CMN_PXL_FORMAT {RAW12} \
   CONFIG.CSI_BUF_DEPTH {4096} \
   CONFIG.C_CLK_LANE_IO_POSITION {26} \
   CONFIG.C_CSI_EN_ACTIVELANES {true} \
   CONFIG.C_CSI_FILTER_USERDATATYPE {true} \
   CONFIG.C_DATA_LANE0_IO_POSITION {28} \
   CONFIG.C_DATA_LANE1_IO_POSITION {45} \
   CONFIG.C_DATA_LANE2_IO_POSITION {17} \
   CONFIG.C_DATA_LANE3_IO_POSITION {19} \
   CONFIG.C_DPHY_LANES {4} \
   CONFIG.C_EN_BG0_PIN0 {false} \
   CONFIG.C_EN_BG1_PIN0 {true} \
   CONFIG.C_EN_BG3_PIN0 {true} \
   CONFIG.C_HS_LINE_RATE {1500} \
   CONFIG.C_HS_SETTLE_NS {141} \
   CONFIG.DATA_LANE0_IO_LOC {AD17} \
   CONFIG.DATA_LANE0_IO_LOC_NAME {IO_L14P_T2L_N2_GC_64} \
   CONFIG.DATA_LANE1_IO_LOC {AK17} \
   CONFIG.DATA_LANE1_IO_LOC_NAME {IO_L22P_T3U_N6_DBC_AD0P_64} \
   CONFIG.DATA_LANE2_IO_LOC {AJ14} \
   CONFIG.DATA_LANE2_IO_LOC_NAME {IO_L9P_T1L_N4_AD12P_64} \
   CONFIG.DATA_LANE3_IO_LOC {AJ15} \
   CONFIG.DATA_LANE3_IO_LOC_NAME {IO_L10P_T1U_N6_QBC_AD4P_64} \
   CONFIG.DPY_EN_REG_IF {true} \
   CONFIG.DPY_LINE_RATE {1500} \
   CONFIG.SupportLevel {1} \
 ] $mipi_csi2_rx_subsystem_0

  # Create instance: sensor_rst_gpio, and set properties
  set sensor_rst_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 sensor_rst_gpio ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {12} \
   CONFIG.DIN_TO {12} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $sensor_rst_gpio

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins demosaic_ctrl_1] [get_bd_intf_pins capture_pipeline_1/demosaic_ctrl]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins frmbuf_ctrl_0] [get_bd_intf_pins capture_pipeline_0/frmbuf_ctrl]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins mipi_phy_if_0] [get_bd_intf_pins mipi_csi2_rx_subsystem_0/mipi_phy_if]
  connect_bd_intf_net -intf_net axi_data_fifo_0_M_AXI [get_bd_intf_pins frmbuf_s2mm_0] [get_bd_intf_pins capture_pipeline_0/M_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_hpm0_M05_AXI [get_bd_intf_pins csirxss_s_axi] [get_bd_intf_pins mipi_csi2_rx_subsystem_0/csirxss_s_axi]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axis_subset_converter_0/M_AXIS] [get_bd_intf_pins axis_switch_0/S00_AXIS]
  connect_bd_intf_net -intf_net capture_pipeline_1_M_AXI [get_bd_intf_pins frmbuf_s2mm_1] [get_bd_intf_pins capture_pipeline_1/M_AXI]
  connect_bd_intf_net -intf_net capture_pipeline_2_M_AXI [get_bd_intf_pins frmbuf_s2mm_2] [get_bd_intf_pins capture_pipeline_2/M_AXI]
  connect_bd_intf_net -intf_net capture_pipeline_3_M_AXI [get_bd_intf_pins frmbuf_s2mm_3] [get_bd_intf_pins capture_pipeline_3/M_AXI]
  connect_bd_intf_net -intf_net ctrl_1 [get_bd_intf_pins demosaic_ctrl_0] [get_bd_intf_pins capture_pipeline_0/demosaic_ctrl]
  connect_bd_intf_net -intf_net demosaic_ctrl_2_1 [get_bd_intf_pins demosaic_ctrl_2] [get_bd_intf_pins capture_pipeline_2/demosaic_ctrl]
  connect_bd_intf_net -intf_net demosaic_ctrl_3_1 [get_bd_intf_pins demosaic_ctrl_3] [get_bd_intf_pins capture_pipeline_3/demosaic_ctrl]
  connect_bd_intf_net -intf_net frmbuf_ctrl_1_1 [get_bd_intf_pins frmbuf_ctrl_1] [get_bd_intf_pins capture_pipeline_1/frmbuf_ctrl]
  connect_bd_intf_net -intf_net frmbuf_ctrl_2_1 [get_bd_intf_pins frmbuf_ctrl_2] [get_bd_intf_pins capture_pipeline_2/frmbuf_ctrl]
  connect_bd_intf_net -intf_net frmbuf_ctrl_3_1 [get_bd_intf_pins frmbuf_ctrl_3] [get_bd_intf_pins capture_pipeline_3/frmbuf_ctrl]
  connect_bd_intf_net -intf_net mipi_csi2_rx_subsystem_0_video_out [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins mipi_csi2_rx_subsystem_0/video_out]
  connect_bd_intf_net -intf_net s_axi_ctrl_0_1 [get_bd_intf_pins csc_ctrl_0] [get_bd_intf_pins capture_pipeline_0/csc_ctrl]
  connect_bd_intf_net -intf_net s_axi_ctrl_1_1 [get_bd_intf_pins csc_ctrl_1] [get_bd_intf_pins capture_pipeline_1/csc_ctrl]
  connect_bd_intf_net -intf_net s_axi_ctrl_2_1 [get_bd_intf_pins csc_ctrl_2] [get_bd_intf_pins capture_pipeline_2/csc_ctrl]
  connect_bd_intf_net -intf_net s_axi_ctrl_3_1 [get_bd_intf_pins csc_ctrl_3] [get_bd_intf_pins capture_pipeline_3/csc_ctrl]
  connect_bd_intf_net -intf_net s_axis_video_0 [get_bd_intf_pins axis_switch_0/M00_AXIS] [get_bd_intf_pins capture_pipeline_0/s_axis_video]
  connect_bd_intf_net -intf_net s_axis_video_1 [get_bd_intf_pins axis_switch_0/M01_AXIS] [get_bd_intf_pins capture_pipeline_1/s_axis_video]
  connect_bd_intf_net -intf_net s_axis_video_2 [get_bd_intf_pins axis_switch_0/M02_AXIS] [get_bd_intf_pins capture_pipeline_2/s_axis_video]
  connect_bd_intf_net -intf_net s_axis_video_3 [get_bd_intf_pins axis_switch_0/M03_AXIS] [get_bd_intf_pins capture_pipeline_3/s_axis_video]
  connect_bd_intf_net -intf_net scaler_ctrl_0_1 [get_bd_intf_pins scaler_ctrl_0] [get_bd_intf_pins capture_pipeline_0/scaler_ctrl]
  connect_bd_intf_net -intf_net scaler_ctrl_1_1 [get_bd_intf_pins scaler_ctrl_1] [get_bd_intf_pins capture_pipeline_1/scaler_ctrl]
  connect_bd_intf_net -intf_net scaler_ctrl_2_1 [get_bd_intf_pins scaler_ctrl_2] [get_bd_intf_pins capture_pipeline_2/scaler_ctrl]
  connect_bd_intf_net -intf_net scaler_ctrl_3_1 [get_bd_intf_pins scaler_ctrl_3] [get_bd_intf_pins capture_pipeline_3/scaler_ctrl]

  # Create port connections
  connect_bd_net -net Din_1 [get_bd_pins Din] [get_bd_pins capture_pipeline_0/Din] [get_bd_pins capture_pipeline_1/Din] [get_bd_pins capture_pipeline_2/Din] [get_bd_pins capture_pipeline_3/Din] [get_bd_pins sensor_rst_gpio/Din]
  connect_bd_net -net M06_ARESETN_1 [get_bd_pins video_aresetn] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_switch_0/aresetn] [get_bd_pins mipi_csi2_rx_subsystem_0/video_aresetn]
  connect_bd_net -net bg1_pin0_nc_0_1 [get_bd_pins bg1_pin0_nc_0] [get_bd_pins mipi_csi2_rx_subsystem_0/bg1_pin0_nc]
  connect_bd_net -net bg3_pin0_nc_0_1 [get_bd_pins bg3_pin0_nc_0] [get_bd_pins mipi_csi2_rx_subsystem_0/bg3_pin0_nc]
  connect_bd_net -net clk_150mhz [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_switch_0/aclk] [get_bd_pins capture_pipeline_0/m_axi_s2mm_aclk] [get_bd_pins capture_pipeline_1/m_axi_s2mm_aclk] [get_bd_pins capture_pipeline_2/m_axi_s2mm_aclk] [get_bd_pins capture_pipeline_3/m_axi_s2mm_aclk] [get_bd_pins mipi_csi2_rx_subsystem_0/video_aclk]
  connect_bd_net -net clk_50mhz [get_bd_pins s_axi_lite_aclk] [get_bd_pins mipi_csi2_rx_subsystem_0/lite_aclk]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins dphy_clk_200M] [get_bd_pins mipi_csi2_rx_subsystem_0/dphy_clk_200M]
  connect_bd_net -net mipi_csi2_rx_subsystem_0_csirxss_csi_irq [get_bd_pins csirxss_csi_irq] [get_bd_pins mipi_csi2_rx_subsystem_0/csirxss_csi_irq]
  connect_bd_net -net proc_sys_reset_clk50_peripheral_aresetn [get_bd_pins axi_resetn] [get_bd_pins mipi_csi2_rx_subsystem_0/lite_aresetn]
  connect_bd_net -net sensor_rst_gpio_Dout [get_bd_pins sensor_rst_gpio] [get_bd_pins sensor_rst_gpio/Dout]
  connect_bd_net -net v_frmbuf_wr_0_interrupt [get_bd_pins frmbuf_irq_0] [get_bd_pins capture_pipeline_0/s2mm_introut]
  connect_bd_net -net v_frmbuf_wr_1_interrupt [get_bd_pins frmbuf_irq_1] [get_bd_pins capture_pipeline_1/s2mm_introut]
  connect_bd_net -net v_frmbuf_wr_2_interrupt [get_bd_pins frmbuf_irq_2] [get_bd_pins capture_pipeline_2/s2mm_introut]
  connect_bd_net -net v_frmbuf_wr_3_interrupt [get_bd_pins frmbuf_irq_3] [get_bd_pins capture_pipeline_3/s2mm_introut]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: fmc_multicam_control
proc create_hier_cell_fmc_multicam_control { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_fmc_multicam_control() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 fmc_multicam_iic


  # Create pins
  create_bd_pin -dir O -type intr fmc_multicam_iic_irq
  create_bd_pin -dir O -from 0 -to 0 iic_mux_rst_n
  create_bd_pin -dir O -from 0 -to 0 max9286_fsync
  create_bd_pin -dir O -from 0 -to 0 max9286_pwdn_n
  create_bd_pin -dir O -from 0 -to 0 max9296_pwdn_n
  create_bd_pin -dir O -from 0 -to 0 poc1_en
  create_bd_pin -dir I poc1_int
  create_bd_pin -dir O -from 0 -to 0 poc2_en
  create_bd_pin -dir I poc2_int
  create_bd_pin -dir I -from 94 -to 0 ps_gpio
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: fmc_multicam_gpi, and set properties
  set fmc_multicam_gpi [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 fmc_multicam_gpi ]

  # Create instance: fmc_multicam_iic, and set properties
  set fmc_multicam_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 fmc_multicam_iic ]
  set_property -dict [ list \
   CONFIG.IIC_FREQ_KHZ {400} \
 ] $fmc_multicam_iic

  # Create instance: ps_gpio_30, and set properties
  set ps_gpio_30 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ps_gpio_30 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {30} \
   CONFIG.DIN_TO {30} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ps_gpio_30

  # Create instance: ps_gpio_31, and set properties
  set ps_gpio_31 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ps_gpio_31 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {31} \
   CONFIG.DIN_TO {31} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ps_gpio_31

  # Create instance: ps_gpio_32, and set properties
  set ps_gpio_32 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ps_gpio_32 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {32} \
   CONFIG.DIN_TO {32} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ps_gpio_32

  # Create instance: ps_gpio_33, and set properties
  set ps_gpio_33 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ps_gpio_33 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {33} \
   CONFIG.DIN_TO {33} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ps_gpio_33

  # Create instance: ps_gpio_34, and set properties
  set ps_gpio_34 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ps_gpio_34 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {34} \
   CONFIG.DIN_TO {34} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ps_gpio_34

  # Create instance: ps_gpio_35, and set properties
  set ps_gpio_35 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 ps_gpio_35 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {35} \
   CONFIG.DIN_TO {35} \
   CONFIG.DIN_WIDTH {95} \
   CONFIG.DOUT_WIDTH {1} \
 ] $ps_gpio_35

  # Create interface connections
  connect_bd_intf_net -intf_net axi_interconnect_hpm0_M04_AXI [get_bd_intf_pins S_AXI] [get_bd_intf_pins fmc_multicam_iic/S_AXI]
  connect_bd_intf_net -intf_net sensor_iic_IIC [get_bd_intf_pins fmc_multicam_iic] [get_bd_intf_pins fmc_multicam_iic/IIC]

  # Create port connections
  connect_bd_net -net clk_50mhz [get_bd_pins s_axi_aclk] [get_bd_pins fmc_multicam_iic/s_axi_aclk]
  connect_bd_net -net fmc_multicam_gpio_0_Dout [get_bd_pins poc1_en] [get_bd_pins ps_gpio_30/Dout]
  connect_bd_net -net fmc_multicam_gpio_1_Dout [get_bd_pins poc2_en] [get_bd_pins ps_gpio_31/Dout]
  connect_bd_net -net fmc_multicam_gpio_2_Dout [get_bd_pins max9286_pwdn_n] [get_bd_pins ps_gpio_32/Dout]
  connect_bd_net -net fmc_multicam_gpio_3_Dout [get_bd_pins max9296_pwdn_n] [get_bd_pins ps_gpio_33/Dout]
  connect_bd_net -net fmc_multicam_gpio_4_Dout [get_bd_pins iic_mux_rst_n] [get_bd_pins ps_gpio_34/Dout]
  connect_bd_net -net fmc_multicam_gpio_gpio_io_o [get_bd_pins ps_gpio] [get_bd_pins ps_gpio_30/Din] [get_bd_pins ps_gpio_31/Din] [get_bd_pins ps_gpio_32/Din] [get_bd_pins ps_gpio_33/Din] [get_bd_pins ps_gpio_34/Din] [get_bd_pins ps_gpio_35/Din]
  connect_bd_net -net fmc_multicam_poc1_int_1 [get_bd_pins poc1_int] [get_bd_pins fmc_multicam_gpi/In0]
  connect_bd_net -net fmc_multicam_poc2_int_1 [get_bd_pins poc2_int] [get_bd_pins fmc_multicam_gpi/In1]
  connect_bd_net -net ps_gpio_25_Dout [get_bd_pins max9286_fsync] [get_bd_pins ps_gpio_35/Dout]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins fmc_multicam_iic/s_axi_aresetn]
  connect_bd_net -net sensor_iic_iic2intc_irpt [get_bd_pins fmc_multicam_iic_irq] [get_bd_pins fmc_multicam_iic/iic2intc_irpt]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: fmc_quad
proc create_hier_cell_fmc_quad { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_fmc_quad() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_iic

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csc_ctrl_3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mipi_phy_rtl:1.0 csi_mipi_phy_if

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 csirxss_s_axi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 demosaic_ctrl_3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 fmc_multicam_iic

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_ctrl_3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_s2mm_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_s2mm_1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_s2mm_2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 frmbuf_s2mm_3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl_1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl_2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 scaler_ctrl_3


  # Create pins
  create_bd_pin -dir I -from 94 -to 0 Din
  create_bd_pin -dir I bg1_pin0_nc_0
  create_bd_pin -dir I bg3_pin0_nc_0
  create_bd_pin -dir O -type intr csirxss_csi_irq
  create_bd_pin -dir I -type clk dphy_clk_200M
  create_bd_pin -dir O -type intr fmc_multicam_iic_irq
  create_bd_pin -dir O -from 0 -to 0 fmc_multicam_iic_mux_rst_n
  create_bd_pin -dir O -from 0 -to 0 fmc_multicam_max9286_pwdn_n
  create_bd_pin -dir O -from 0 -to 0 fmc_multicam_max9296_pwdn_n
  create_bd_pin -dir O -from 0 -to 0 fmc_multicam_poc1_en
  create_bd_pin -dir I fmc_multicam_poc1_int
  create_bd_pin -dir O -from 0 -to 0 fmc_multicam_poc2_en
  create_bd_pin -dir I fmc_multicam_poc2_int
  create_bd_pin -dir O -type intr frmbuf_irq_0
  create_bd_pin -dir O -type intr frmbuf_irq_1
  create_bd_pin -dir O -type intr frmbuf_irq_2
  create_bd_pin -dir O -type intr frmbuf_irq_3
  create_bd_pin -dir I -type clk m_axi_s2mm_aclk
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir I -type rst s_axi_lite_aresetn
  create_bd_pin -dir I -type rst video_aresetn

  # Create instance: fmc_multicam_control
  create_hier_cell_fmc_multicam_control $hier_obj fmc_multicam_control

  # Create instance: mipi_csi2_rx
  create_hier_cell_mipi_csi2_rx $hier_obj mipi_csi2_rx

  # Create interface connections
  connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins frmbuf_s2mm_1] [get_bd_intf_pins mipi_csi2_rx/frmbuf_s2mm_1]
  connect_bd_intf_net -intf_net axi_interconnect_hpm0_M01_AXI [get_bd_intf_pins csirxss_s_axi] [get_bd_intf_pins mipi_csi2_rx/csirxss_s_axi]
  connect_bd_intf_net -intf_net axi_interconnect_hpm0_M04_AXI [get_bd_intf_pins S_AXI_iic] [get_bd_intf_pins fmc_multicam_control/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M04_AXI [get_bd_intf_pins demosaic_ctrl_1] [get_bd_intf_pins mipi_csi2_rx/demosaic_ctrl_1]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M05_AXI [get_bd_intf_pins frmbuf_ctrl_0] [get_bd_intf_pins mipi_csi2_rx/frmbuf_ctrl_0]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M07_AXI [get_bd_intf_pins scaler_ctrl_1] [get_bd_intf_pins mipi_csi2_rx/scaler_ctrl_1]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M09_AXI [get_bd_intf_pins demosaic_ctrl_2] [get_bd_intf_pins mipi_csi2_rx/demosaic_ctrl_2]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M10_AXI [get_bd_intf_pins scaler_ctrl_2] [get_bd_intf_pins mipi_csi2_rx/scaler_ctrl_2]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M11_AXI [get_bd_intf_pins frmbuf_ctrl_2] [get_bd_intf_pins mipi_csi2_rx/frmbuf_ctrl_2]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M13_AXI [get_bd_intf_pins scaler_ctrl_3] [get_bd_intf_pins mipi_csi2_rx/scaler_ctrl_3]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M15_AXI [get_bd_intf_pins csc_ctrl_0] [get_bd_intf_pins mipi_csi2_rx/csc_ctrl_0]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M16_AXI [get_bd_intf_pins csc_ctrl_1] [get_bd_intf_pins mipi_csi2_rx/csc_ctrl_1]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M17_AXI [get_bd_intf_pins csc_ctrl_2] [get_bd_intf_pins mipi_csi2_rx/csc_ctrl_2]
  connect_bd_intf_net -intf_net axi_interconnect_hpm1_M18_AXI [get_bd_intf_pins csc_ctrl_3] [get_bd_intf_pins mipi_csi2_rx/csc_ctrl_3]
  connect_bd_intf_net -intf_net ctrl_2 [get_bd_intf_pins demosaic_ctrl_0] [get_bd_intf_pins mipi_csi2_rx/demosaic_ctrl_0]
  connect_bd_intf_net -intf_net demosaic_ctrl_3_1 [get_bd_intf_pins demosaic_ctrl_3] [get_bd_intf_pins mipi_csi2_rx/demosaic_ctrl_3]
  connect_bd_intf_net -intf_net fmc_multicam_control_fmc_multicam_iic [get_bd_intf_pins fmc_multicam_iic] [get_bd_intf_pins fmc_multicam_control/fmc_multicam_iic]
  connect_bd_intf_net -intf_net frmbuf_ctrl_1_1 [get_bd_intf_pins frmbuf_ctrl_1] [get_bd_intf_pins mipi_csi2_rx/frmbuf_ctrl_1]
  connect_bd_intf_net -intf_net frmbuf_ctrl_3_1 [get_bd_intf_pins frmbuf_ctrl_3] [get_bd_intf_pins mipi_csi2_rx/frmbuf_ctrl_3]
  connect_bd_intf_net -intf_net mipi_csi2_rx_M_AXI_S2MM [get_bd_intf_pins frmbuf_s2mm_0] [get_bd_intf_pins mipi_csi2_rx/frmbuf_s2mm_0]
  connect_bd_intf_net -intf_net mipi_csi2_rx_frmbuf_s2mm_2 [get_bd_intf_pins frmbuf_s2mm_2] [get_bd_intf_pins mipi_csi2_rx/frmbuf_s2mm_2]
  connect_bd_intf_net -intf_net mipi_csi2_rx_frmbuf_s2mm_3 [get_bd_intf_pins frmbuf_s2mm_3] [get_bd_intf_pins mipi_csi2_rx/frmbuf_s2mm_3]
  connect_bd_intf_net -intf_net mipi_phy_if_0_1 [get_bd_intf_pins csi_mipi_phy_if] [get_bd_intf_pins mipi_csi2_rx/mipi_phy_if_0]
  connect_bd_intf_net -intf_net s_axi_ctrl_1 [get_bd_intf_pins scaler_ctrl_0] [get_bd_intf_pins mipi_csi2_rx/scaler_ctrl_0]

  # Create port connections
  connect_bd_net -net bg1_pin0_nc_0_1 [get_bd_pins bg1_pin0_nc_0] [get_bd_pins mipi_csi2_rx/bg1_pin0_nc_0]
  connect_bd_net -net bg3_pin0_nc_0_1 [get_bd_pins bg3_pin0_nc_0] [get_bd_pins mipi_csi2_rx/bg3_pin0_nc_0]
  connect_bd_net -net clk_300mhz [get_bd_pins m_axi_s2mm_aclk] [get_bd_pins mipi_csi2_rx/m_axi_s2mm_aclk]
  connect_bd_net -net clk_50mhz [get_bd_pins s_axi_lite_aclk] [get_bd_pins fmc_multicam_control/s_axi_aclk] [get_bd_pins mipi_csi2_rx/s_axi_lite_aclk]
  connect_bd_net -net clk_wiz_1_clk_out5 [get_bd_pins dphy_clk_200M] [get_bd_pins mipi_csi2_rx/dphy_clk_200M]
  connect_bd_net -net fmc_multicam_control_fmc_multicam_iic_irq [get_bd_pins fmc_multicam_iic_irq] [get_bd_pins fmc_multicam_control/fmc_multicam_iic_irq]
  connect_bd_net -net fmc_multicam_control_iic_mux_rst_n [get_bd_pins fmc_multicam_iic_mux_rst_n] [get_bd_pins fmc_multicam_control/iic_mux_rst_n]
  connect_bd_net -net fmc_multicam_control_max9286_pwdn_n [get_bd_pins fmc_multicam_max9286_pwdn_n] [get_bd_pins fmc_multicam_control/max9286_pwdn_n]
  connect_bd_net -net fmc_multicam_control_max9296_pwdn_n [get_bd_pins fmc_multicam_max9296_pwdn_n] [get_bd_pins fmc_multicam_control/max9296_pwdn_n]
  connect_bd_net -net fmc_multicam_control_poc1_en [get_bd_pins fmc_multicam_poc1_en] [get_bd_pins fmc_multicam_control/poc1_en]
  connect_bd_net -net fmc_multicam_control_poc2_en [get_bd_pins fmc_multicam_poc2_en] [get_bd_pins fmc_multicam_control/poc2_en]
  connect_bd_net -net mipi_csi2_rx_csirxss_csi_irq [get_bd_pins csirxss_csi_irq] [get_bd_pins mipi_csi2_rx/csirxss_csi_irq]
  connect_bd_net -net mipi_csi2_rx_frmbuf_irq_0 [get_bd_pins frmbuf_irq_0] [get_bd_pins mipi_csi2_rx/frmbuf_irq_0]
  connect_bd_net -net mipi_csi2_rx_frmbuf_irq_1 [get_bd_pins frmbuf_irq_1] [get_bd_pins mipi_csi2_rx/frmbuf_irq_1]
  connect_bd_net -net mipi_csi2_rx_frmbuf_irq_2 [get_bd_pins frmbuf_irq_2] [get_bd_pins mipi_csi2_rx/frmbuf_irq_2]
  connect_bd_net -net mipi_csi2_rx_frmbuf_irq_3 [get_bd_pins frmbuf_irq_3] [get_bd_pins mipi_csi2_rx/frmbuf_irq_3]
  connect_bd_net -net poc1_int_0_1 [get_bd_pins fmc_multicam_poc1_int] [get_bd_pins fmc_multicam_control/poc1_int]
  connect_bd_net -net poc2_int_0_1 [get_bd_pins fmc_multicam_poc2_int] [get_bd_pins fmc_multicam_control/poc2_int]
  connect_bd_net -net proc_sys_reset_clk50_peripheral_aresetn [get_bd_pins s_axi_lite_aresetn] [get_bd_pins fmc_multicam_control/s_axi_aresetn] [get_bd_pins mipi_csi2_rx/axi_resetn]
  connect_bd_net -net video_aresetn_1 [get_bd_pins video_aresetn] [get_bd_pins mipi_csi2_rx/video_aresetn]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_gpio_o [get_bd_pins Din] [get_bd_pins fmc_multicam_control/ps_gpio] [get_bd_pins mipi_csi2_rx/Din]

  # Restore current instance
  current_bd_instance $oldCurInst
}


proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_fmc_quad parentCell nameHier"
   puts "#    create_hier_cell_fmc_multicam_control parentCell nameHier"
   puts "#    create_hier_cell_mipi_csi2_rx parentCell nameHier"
   puts "#    create_hier_cell_capture_pipeline_0 parentCell nameHier"
   puts "#    create_hier_cell_capture_pipeline_1 parentCell nameHier"
   puts "#    create_hier_cell_capture_pipeline_2 parentCell nameHier"
   puts "#    create_hier_cell_capture_pipeline_3 parentCell nameHier"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
