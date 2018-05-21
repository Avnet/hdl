
################################################################
# This is a generated script based on design: uz3eg_iocc_dp_only
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
# source uz3eg_iocc_dp_only_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

#set list_projs [get_projects -quiet]
#if { $list_projs eq "" } {
#   create_project project_1 myproj -part xczu3eg-sfva625-1-i-es1
#   set_property BOARD_PART em.avnet.com:ultrazed_eg_iocc:part0:1.0 [current_project]
#}


# CHANGE DESIGN NAME HERE
#set design_name uz3eg_iocc_dp_only

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

  # Create ports

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
  #set_property -dict [list CONFIG.PSU__HIGH_ADDRESS__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]
  # IRQ configuration
  #set_property -dict [list CONFIG.PSU__USE__IRQ0 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  # EMIO GPIO configuration
  #set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]  

  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_1 [get_bd_intf_ports idt5901] [get_bd_intf_pins idt5901_clk/CLK_IN_D]

  #connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

  # Create port connections
  connect_bd_net -net video_clk_1 [get_bd_pins idt5901_clk/BUFG_O] [get_bd_pins zynq_ultra_ps_e_0/dp_video_in_clk]

  # Create address segments

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


