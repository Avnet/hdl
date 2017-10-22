
################################################################
# This is a generated script based on design: uz3eg_iocc_dp
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
# source uz3eg_iocc_dp_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

#set list_projs [get_projects -quiet]
#if { $list_projs eq "" } {
#   create_project project_1 myproj -part xczu3eg-sfva625-1-i
#   set_property BOARD_PART em.avnet.com:ultrazed_eg_iocc_production:part0:1.0 [current_project]
#}


# CHANGE DESIGN NAME HERE
#set design_name uz3eg_iocc_dp

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

  # Create ports


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
  set_property -dict [list CONFIG.PSU__USE__IRQ0 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__USE__IRQ1 {1}] [get_bd_cells zynq_ultra_ps_e_0]
  # EMIO GPIO configuration
  #set_property -dict [list CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE {1}] [get_bd_cells zynq_ultra_ps_e_0]  
  # PL fabric clocks
  set_property -dict [list CONFIG.PSU__NUM_FABRIC_RESETS {2}] [get_bd_cells zynq_ultra_ps_e_0]
  set_property -dict [list CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ {100}] [get_bd_cells zynq_ultra_ps_e_0]

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

  # Create instance: interrupts0
  set interrupts0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat interrupts0 ]
  set_property -dict [ list CONFIG.NUM_PORTS {1} ] $interrupts0

  # Create instance: interrupts1
  set interrupts1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat interrupts1 ]
  set_property -dict [ list CONFIG.NUM_PORTS {1} ] $interrupts1

  # Create interface connections
  #connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]  

  # Create port connections
  # clock wizard + resets
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk1] [get_bd_pins clk_wiz_1/clk_in1]
  connect_bd_net -net clk_50mhz [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins proc_sys_reset_clk50/slowest_sync_clk]
  connect_bd_net -net clk_75mhz [get_bd_pins clk_wiz_1/clk_out2] [get_bd_pins proc_sys_reset_clk75/slowest_sync_clk]
  connect_bd_net -net clk_150mhz [get_bd_pins clk_wiz_1/clk_out3] [get_bd_pins proc_sys_reset_clk150/slowest_sync_clk]
  connect_bd_net -net clk_300mhz [get_bd_pins clk_wiz_1/clk_out4] [get_bd_pins proc_sys_reset_clk300/slowest_sync_clk]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins proc_sys_reset_clk50/dcm_locked] [get_bd_pins proc_sys_reset_clk75/dcm_locked] [get_bd_pins proc_sys_reset_clk150/dcm_locked] [get_bd_pins proc_sys_reset_clk300/dcm_locked]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn1] [get_bd_pins proc_sys_reset_clk50/ext_reset_in] [get_bd_pins proc_sys_reset_clk75/ext_reset_in] [get_bd_pins proc_sys_reset_clk150/ext_reset_in] [get_bd_pins proc_sys_reset_clk300/ext_reset_in]
  # interrupts
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq0] [get_bd_pins interrupts0/dout]
  connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_ps_irq1] [get_bd_pins interrupts1/dout]

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


