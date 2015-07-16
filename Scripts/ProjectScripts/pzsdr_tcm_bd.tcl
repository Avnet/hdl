
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2014.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg400-2


# # CHANGE DESIGN NAME HERE
# set design_name design_1
# 
# # If you do not already have an existing IP Integrator design open,
# # you can create a design using the following command:
# #    create_bd_design $design_name
# 
# # CHECKING IF PROJECT EXISTS
# if { [get_projects -quiet] eq "" } {
#    puts "ERROR: Please open or create a project!"
#    return 1
# }


# Creating design if needed
set errMsg ""
set nRet 0

# set cur_design [current_bd_design -quiet]
# set list_cells [get_bd_cells -quiet]
# 
# if { ${design_name} eq "" } {
#    # USE CASES:
#    #    1) Design_name not set
# 
#    set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
#    set nRet 1
# 
# } elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
#    # USE CASES:
#    #    2): Current design opened AND is empty AND names same.
#    #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
#    #    4): Current design opened AND is empty AND names diff; design_name exists in project.
# 
#    if { $cur_design ne $design_name } {
#       puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
#       set design_name [get_property NAME $cur_design]
#    }
#    puts "INFO: Constructing design in IPI design <$cur_design>..."
# 
# } elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
#    # USE CASES:
#    #    5) Current design opened AND has components AND same names.
# 
#    set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
#    set nRet 1
# } elseif { [get_files -quiet ${design_name}.bd] ne "" } {
#    # USE CASES: 
#    #    6) Current opened design, has components, but diff names, design_name exists in project.
#    #    7) No opened design, design_name exists in project.
# 
#    set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
#    set nRet 2
# 
# } else {
#    # USE CASES:
#    #    8) No opened design, design_name not in project.
#    #    9) Current opened design, has components, but diff names, design_name not in project.
# 
#    puts "INFO: Currently there is no design <$design_name> in project, so creating one..."
# 
#    create_bd_design $design_name
# 
#    puts "INFO: Making design <$design_name> as current_bd_design."
#    current_bd_design $design_name
# 
# }

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  #set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  #set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set IO_HDMIO [ create_bd_intf_port -mode Master -vlnv avnet.com:interface:avnet_hdmi_rtl:1.0 IO_HDMIO ]
  set pzsdr_fmccc_iic [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 pzsdr_fmccc_iic ]

  # Create ports
  set cam_extclk [ create_bd_port -dir O -type clk cam_extclk ]
  set io_tcm_clk_in_n [ create_bd_port -dir I -type clk io_tcm_clk_in_n ]
  set_property -dict [ list CONFIG.FREQ_HZ {100000000}  ] $io_tcm_clk_in_n
  set io_tcm_clk_in_p [ create_bd_port -dir I -type clk io_tcm_clk_in_p ]
  set_property -dict [ list CONFIG.FREQ_HZ {100000000}  ] $io_tcm_clk_in_p
  set io_tcm_data_in_n [ create_bd_port -dir I -from 1 -to 0 io_tcm_data_in_n ]
  set io_tcm_data_in_p [ create_bd_port -dir I -from 1 -to 0 io_tcm_data_in_p ]

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list CONFIG.NUM_MI {1} CONFIG.NUM_SI {2}  ] $axi_mem_intercon

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_vdma_0 ]
  set_property -dict [ list CONFIG.c_include_mm2s {1} CONFIG.c_m_axi_s2mm_data_width {64} CONFIG.c_m_axis_mm2s_tdata_width {16} ] $axi_vdma_0

  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  # need to explicitly set input width to 3 bytes first, prior to changing output width to 2 bytes
  set_property -dict [ list CONFIG.S_TDATA_NUM_BYTES.VALUE_SRC USER ] $axis_subset_converter_0
  set_property -dict [ list CONFIG.S_TDATA_NUM_BYTES {3} ] $axis_subset_converter_0
  set_property -dict [ list CONFIG.M_TDATA_NUM_BYTES {2} CONFIG.TDATA_REMAP {{tdata[19:12],tdata[9:2]}}] $axis_subset_converter_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0 ]
  set_property -dict [ list CONFIG.CLKOUT1_JITTER {305.592} CONFIG.CLKOUT1_PHASE_ERROR {298.923} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {24} CONFIG.CLKOUT2_USED {false} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false}  ] $clk_wiz_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_1 ]
  set_property -dict [ list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {148.5} CONFIG.PRIMITIVE {MMCM} CONFIG.USE_LOCKED {false} CONFIG.USE_POWER_DOWN {false} CONFIG.USE_RESET {false}  ] $clk_wiz_1

  # Create instance: avnet_hdmi_out_0, and set properties
  set avnet_hdmi_out_0 [ create_bd_cell -type ip -vlnv avnet:avnet_hdmi:avnet_hdmi_out:3.1 avnet_hdmi_out_0 ]

  # Create instance: processing_system7_0, and set properties
  #set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set processing_system7_0 [get_bd_cells processing_system7_0]
  set_property -dict [ list CONFIG.PCW_EN_CLK0_PORT {1} CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_EN_CLK2_PORT {1} CONFIG.PCW_EN_RST0_PORT {1} CONFIG.PCW_EN_RST1_PORT {1} CONFIG.PCW_EN_RST2_PORT {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {24} CONFIG.PCW_USE_M_AXI_GP0 {1} CONFIG.PCW_USE_S_AXI_HP0 {1} ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {6}  ] $processing_system7_0_axi_periph

  # Create instance: pzsdr_fmccc_iic_0, and set properties
  set pzsdr_fmccc_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 pzsdr_fmccc_iic_0 ]

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: rst_processing_system7_0_200M, and set properties
  set rst_processing_system7_0_200M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_200M ]

  # Create instance: tcm_receiver_0, and set properties
  set tcm_receiver_0 [ create_bd_cell -type ip -vlnv avnet.com:ip:tcm_receiver:1.1 tcm_receiver_0 ]
  set_property -dict [ list CONFIG.C_PIXEL_WIDTH {10}  ] $tcm_receiver_0

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:3.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list CONFIG.C_S_AXIS_VIDEO_FORMAT {0} CONFIG.RAM_ADDR_BITS {12} CONFIG.VTG_MASTER_SLAVE {1}  ] $v_axi4s_vid_out_0

  # Create instance: v_ccm_0, and set properties
  #set v_ccm_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_ccm:6.0 v_ccm_0 ]
  set v_ccm_0 [get_bd_cells v_ccm_0]
  set_property -dict [ list CONFIG.HAS_AXI4_LITE {true}  ] $v_ccm_0
  # auto-propagation of data_width does not work in scripting mode, so need to explicitly set this to 10
  set_property -dict [ list CONFIG.S_AXIS_VIDEO_DATA_WIDTH.VALUE_SRC USER CONFIG.M_AXIS_VIDEO_DATA_WIDTH.VALUE_SRC USER ] $v_ccm_0
  set_property -dict [ list CONFIG.S_AXIS_VIDEO_DATA_WIDTH {10} CONFIG.M_AXIS_VIDEO_DATA_WIDTH {10} CONFIG.CLIP {1023} ] $v_ccm_0

  # Create instance: v_cfa_0, and set properties
  #set v_cfa_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cfa:7.0 v_cfa_0 ]
  set v_cfa_0 [get_bd_cells v_cfa_0]
  set_property -dict [ list CONFIG.has_axi4_lite {true}  ] $v_cfa_0
  # auto-propagation of data_width does not work in scripting mode, so need to explicitly set this to 10
  set_property -dict [ list CONFIG.data_width.VALUE_SRC USER ] $v_cfa_0
  set_property -dict [ list CONFIG.data_width {10} ] $v_cfa_0

  # Create instance: v_cresample_0, and set properties
  #set v_cresample_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cresample:4.0 v_cresample_0 ]
  set v_cresample_0 [get_bd_cells v_cresample_0]
  set_property -dict [ list CONFIG.m_axis_video_format {2} CONFIG.s_axis_video_format {3}  ] $v_cresample_0
  # auto-propagation of data_width does not work in scripting mode, so need to explicitly set this to 10
  set_property -dict [ list CONFIG.s_axis_video_data_width.VALUE_SRC USER ] $v_cresample_0
  set_property -dict [ list CONFIG.s_axis_video_data_width {10} ] $v_cresample_0

  # Create instance: v_osd_0, and set properties
  #set v_osd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_osd:6.0 v_osd_0 ]
  set v_osd_0 [get_bd_cells v_osd_0]
  set_property -dict [ list CONFIG.SCREEN_WIDTH {1920} CONFIG.S_AXIS_VIDEO_FORMAT {YUV_422}  ] $v_osd_0

  # Create instance: v_rgb2ycrcb_0, and set properties
  #set v_rgb2ycrcb_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_rgb2ycrcb:7.1 v_rgb2ycrcb_0 ]
  set v_rgb2ycrcb_0 [get_bd_cells v_rgb2ycrcb_0]
  # auto-propagation of data_width does not work in scripting mode, so need to explicitly set this to 10
  set_property -dict [ list CONFIG.S_AXIS_VIDEO_DATA_WIDTH.VALUE_SRC USER ] $v_rgb2ycrcb_0
  set_property -dict [ list CONFIG.S_AXIS_VIDEO_DATA_WIDTH {10} CONFIG.yoffset {64} CONFIG.cboffset {512} CONFIG.croffset {512} CONFIG.ymax {960} CONFIG.cbmax {960} CONFIG.crmax {960} CONFIG.ymin {64} CONFIG.cbmin {64} CONFIG.crmin {64} ] $v_rgb2ycrcb_0

  # Create instance: v_tc_0, and set properties
  #set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 v_tc_0 ]
  set v_tc_0 [get_bd_cells v_tc_0]
  set_property -dict [ list CONFIG.HAS_AXI4_LITE {false} CONFIG.VIDEO_MODE {1080p} CONFIG.enable_detection {false}  ] $v_tc_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins v_osd_0/video_s0_in]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axis_subset_converter_0_M_AXIS [get_bd_intf_pins axi_vdma_0/S_AXIS_S2MM] [get_bd_intf_pins axis_subset_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net avnet_hdmi_out_0_IO_HDMIO [get_bd_intf_ports IO_HDMIO] [get_bd_intf_pins avnet_hdmi_out_0/IO_HDMIO]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI] [get_bd_intf_pins tcm_receiver_0/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI] [get_bd_intf_pins v_osd_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI] [get_bd_intf_pins v_cfa_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI] [get_bd_intf_pins v_ccm_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI] [get_bd_intf_pins pzsdr_fmccc_iic_0/S_AXI]
  connect_bd_intf_net -intf_net pzsdr_fmccc_iic_0_IIC [get_bd_intf_ports pzsdr_fmccc_iic] [get_bd_intf_pins pzsdr_fmccc_iic_0/IIC]
  connect_bd_intf_net -intf_net tcm_receiver_0_m_axis [get_bd_intf_pins tcm_receiver_0/m_axis] [get_bd_intf_pins v_cfa_0/video_in]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins avnet_hdmi_out_0/VID_IO_IN] [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out]
  connect_bd_intf_net -intf_net v_ccm_0_video_out [get_bd_intf_pins v_ccm_0/video_out] [get_bd_intf_pins v_rgb2ycrcb_0/video_in]
  connect_bd_intf_net -intf_net v_cfa_0_video_out [get_bd_intf_pins v_ccm_0/video_in] [get_bd_intf_pins v_cfa_0/video_out]
  connect_bd_intf_net -intf_net v_cresample_0_video_out [get_bd_intf_pins axis_subset_converter_0/S_AXIS] [get_bd_intf_pins v_cresample_0/video_out]
  connect_bd_intf_net -intf_net v_osd_0_video_out [get_bd_intf_pins v_axi4s_vid_out_0/video_in] [get_bd_intf_pins v_osd_0/video_out]
  connect_bd_intf_net -intf_net v_rgb2ycrcb_0_video_out [get_bd_intf_pins v_cresample_0/video_in] [get_bd_intf_pins v_rgb2ycrcb_0/video_out]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports cam_extclk] [get_bd_pins clk_wiz_0/clk_out1]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins avnet_hdmi_out_0/clk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk]
  connect_bd_net -net io_tcm_clk_in_n_1 [get_bd_ports io_tcm_clk_in_n] [get_bd_pins tcm_receiver_0/io_tcm_clk_in_n]
  connect_bd_net -net io_tcm_clk_in_p_1 [get_bd_ports io_tcm_clk_in_p] [get_bd_pins tcm_receiver_0/io_tcm_clk_in_p]
  connect_bd_net -net io_tcm_data_in_n_1 [get_bd_ports io_tcm_data_in_n] [get_bd_pins tcm_receiver_0/io_tcm_data_in_n]
  connect_bd_net -net io_tcm_data_in_p_1 [get_bd_ports io_tcm_data_in_p] [get_bd_pins tcm_receiver_0/io_tcm_data_in_p]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins clk_wiz_1/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins tcm_receiver_0/s00_axi_aclk] [get_bd_pins v_ccm_0/s_axi_aclk] [get_bd_pins v_cfa_0/s_axi_aclk] [get_bd_pins v_osd_0/s_axi_aclk] [get_bd_pins pzsdr_fmccc_iic_0/s_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins rst_processing_system7_0_200M/slowest_sync_clk] [get_bd_pins tcm_receiver_0/aclk] [get_bd_pins tcm_receiver_0/ref_200_clk_in] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins v_ccm_0/aclk] [get_bd_pins v_cfa_0/aclk] [get_bd_pins v_cresample_0/aclk] [get_bd_pins v_osd_0/aclk] [get_bd_pins v_rgb2ycrcb_0/aclk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in] [get_bd_pins rst_processing_system7_0_200M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn] [get_bd_pins tcm_receiver_0/s00_axi_aresetn] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins v_ccm_0/aresetn] [get_bd_pins v_ccm_0/s_axi_aresetn] [get_bd_pins v_cfa_0/aresetn] [get_bd_pins v_cfa_0/s_axi_aresetn] [get_bd_pins v_cresample_0/aresetn] [get_bd_pins v_osd_0/s_axi_aresetn] [get_bd_pins v_rgb2ycrcb_0/aresetn] [get_bd_pins v_tc_0/resetn] [get_bd_pins pzsdr_fmccc_iic_0/s_axi_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_reset [get_bd_pins avnet_hdmi_out_0/reset] [get_bd_pins rst_processing_system7_0_100M/peripheral_reset] [get_bd_pins v_axi4s_vid_out_0/rst]
  connect_bd_net -net rst_processing_system7_0_200M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins rst_processing_system7_0_200M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_200M_peripheral_aresetn [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins rst_processing_system7_0_200M/peripheral_aresetn] [get_bd_pins v_osd_0/aresetn]
  connect_bd_net -net rst_processing_system7_0_200M_peripheral_reset [get_bd_pins rst_processing_system7_0_200M/peripheral_reset] [get_bd_pins tcm_receiver_0/reset]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins avnet_hdmi_out_0/embed_syncs] [get_bd_pins avnet_hdmi_out_0/oe] [get_bd_pins v_axi4s_vid_out_0/aclken] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce] [get_bd_pins v_ccm_0/aclken] [get_bd_pins v_ccm_0/s_axi_aclken] [get_bd_pins v_cfa_0/aclken] [get_bd_pins v_cfa_0/s_axi_aclken] [get_bd_pins v_cresample_0/aclken] [get_bd_pins v_osd_0/aclken] [get_bd_pins v_osd_0/s_axi_aclken] [get_bd_pins v_rgb2ycrcb_0/aclken] [get_bd_pins v_tc_0/clken] [get_bd_pins v_tc_0/gen_clken] [get_bd_pins xlconstant_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs pzsdr_fmccc_iic_0/S_AXI/Reg] SEG_pzsdr_fmccc_iic_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs tcm_receiver_0/S00_AXI/S00_AXI_reg] SEG_tcm_receiver_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_ccm_0/ctrl/Reg] SEG_v_ccm_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_cfa_0/ctrl/Reg] SEG_v_cfa_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_osd_0/ctrl/Reg] SEG_v_osd_0_Reg
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


