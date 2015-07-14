
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
#    create_project project_1 myproj -part xc7z020clg400-1


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
  set IO_PYTHON_CAM [ create_bd_intf_port -mode Slave -vlnv avnet.com:interface:onsemi_vita_cam_rtl:1.0 IO_PYTHON_CAM ]
  set IO_PYTHON_SPI [ create_bd_intf_port -mode Master -vlnv avnet.com:interface:onsemi_vita_spi_rtl:1.0 IO_PYTHON_SPI ]

  # Create ports

  # Create instance: avnet_hdmi_out_0, and set properties
  set avnet_hdmi_out_0 [ create_bd_cell -type ip -vlnv avnet:avnet_hdmi:avnet_hdmi_out:3.1 avnet_hdmi_out_0 ]

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list CONFIG.NUM_MI {1} CONFIG.NUM_SI {4}  ] $axi_mem_intercon

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_vdma_0 ]
  set_property -dict [ list CONFIG.c_m_axi_s2mm_data_width {64} CONFIG.c_m_axis_mm2s_tdata_width {16} ] $axi_vdma_0

  # Create instance: axi_vdma_1, and set properties
  set axi_vdma_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.2 axi_vdma_1 ]
  set_property -dict [ list CONFIG.c_m_axi_s2mm_data_width {64} CONFIG.c_m_axis_mm2s_tdata_width {16} ] $axi_vdma_1

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.1 clk_wiz_0 ]
  set_property -dict [ list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {108} CONFIG.CLKOUT1_USED {true} CONFIG.CLKOUT2_USED {false} CONFIG.NUM_OUT_CLKS {1} CONFIG.PRIMITIVE {PLL} CONFIG.USE_LOCKED {false} CONFIG.USE_RESET {false}  ] $clk_wiz_0

  # Create instance: onsemi_python_cam_0, and set properties
  set onsemi_python_cam_0 [ create_bd_cell -type ip -vlnv avnet:onsemi_vita:onsemi_vita_cam:3.1 onsemi_python_cam_0 ]

  # Create instance: onsemi_python_spi_0, and set properties
  set onsemi_python_spi_0 [ create_bd_cell -type ip -vlnv avnet:onsemi_vita:onsemi_vita_spi:3.1 onsemi_python_spi_0 ]

  # Create instance: processing_system7_0, and set properties
  #set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set processing_system7_0 [get_bd_cells processing_system7_0]
  set_property -dict [ list CONFIG.PCW_EN_CLK1_PORT {1} CONFIG.PCW_EN_CLK2_PORT {1} CONFIG.PCW_EN_RST1_PORT {1} CONFIG.PCW_EN_RST2_PORT {1} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {75} CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} CONFIG.PCW_I2C0_I2C0_IO {MIO 14 .. 15} CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} CONFIG.PCW_USE_M_AXI_GP0 {1} CONFIG.PCW_USE_S_AXI_HP0 {1} CONFIG.preset {Microzed*}  ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {7}  ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_108M, and set properties
  set rst_processing_system7_0_108M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_108M ]

  # Create instance: rst_processing_system7_0_149M, and set properties
  set rst_processing_system7_0_149M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_149M ]

  # Create instance: rst_processing_system7_0_76M, and set properties
  set rst_processing_system7_0_76M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_76M ]

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:3.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list CONFIG.RAM_ADDR_BITS {12} CONFIG.VTG_MASTER_SLAVE {1}  ] $v_axi4s_vid_out_0

  # Create instance: v_cfa_0, and set properties
  #set v_cfa_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cfa:7.0 v_cfa_0 ]
  set v_cfa_0 [get_bd_cells v_cfa_0]
  set_property -dict [ list CONFIG.active_cols {1280} CONFIG.active_rows {1024} CONFIG.has_axi4_lite {true} CONFIG.max_cols {1280}  ] $v_cfa_0

  # Create instance: v_cresample_0, and set properties
  #set v_cresample_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_cresample:4.0 v_cresample_0 ]
  set v_cresample_0 [get_bd_cells v_cresample_0]
  set_property -dict [ list CONFIG.active_cols {1280} CONFIG.active_rows {1024} CONFIG.m_axis_video_format {2} CONFIG.s_axis_video_format {3}  ] $v_cresample_0

  # Create instance: v_osd_0, and set properties
  #set v_osd_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_osd:6.0 v_osd_0 ]
  set v_osd_0 [get_bd_cells v_osd_0]
  set_property -dict [ list CONFIG.NUMBER_OF_LAYERS {2}  ] $v_osd_0

  # Create instance: v_rgb2ycrcb_0, and set properties
  #set v_rgb2ycrcb_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_rgb2ycrcb:7.1 v_rgb2ycrcb_0 ]
  set v_rgb2ycrcb_0 [get_bd_cells v_rgb2ycrcb_0]
  set_property -dict [ list CONFIG.ACTIVE_COLS {1280} CONFIG.ACTIVE_ROWS {1024}  ] $v_rgb2ycrcb_0

  # Create instance: v_tc_0, and set properties
  #set v_tc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 v_tc_0 ]
  set v_tc_0 [get_bd_cells v_tc_0]
  set_property -dict [ list CONFIG.HAS_AXI4_LITE {false} CONFIG.VIDEO_MODE {1280x1024p} CONFIG.enable_detection {false}  ] $v_tc_0

  # Create instance: v_tpg_0, and set properties
  #set v_tpg_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tpg:6.0 v_tpg_0 ]
  set v_tpg_0 [get_bd_cells v_tpg_0]
  set_property -dict [ list CONFIG.active_cols {1280} CONFIG.active_rows {1024} CONFIG.has_axi4s_slave {false} CONFIG.m_video_format {0} CONFIG.pattern_control {11}  ] $v_tpg_0

  # Create instance: v_vid_in_axi4s_0, and set properties
  set v_vid_in_axi4s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:3.0 v_vid_in_axi4s_0 ]
  set_property -dict [ list CONFIG.C_M_AXIS_VIDEO_FORMAT {12} CONFIG.RAM_ADDR_BITS {12}  ] $v_vid_in_axi4s_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list CONFIG.CONST_VAL {0}  ] $xlconstant_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net IO_CAM_IN_1 [get_bd_intf_ports IO_PYTHON_CAM] [get_bd_intf_pins onsemi_python_cam_0/IO_CAM_IN]
  connect_bd_intf_net -intf_net avnet_hdmi_out_0_IO_HDMIO [get_bd_intf_ports IO_HDMIO] [get_bd_intf_pins avnet_hdmi_out_0/IO_HDMIO]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins v_osd_0/video_s0_in]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_1/M_AXIS_MM2S] [get_bd_intf_pins v_osd_0/video_s1_in]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S02_AXI] [get_bd_intf_pins axi_vdma_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_1_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon/S03_AXI] [get_bd_intf_pins axi_vdma_1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net onsemi_python_cam_0_VID_IO_OUT [get_bd_intf_pins onsemi_python_cam_0/VID_IO_OUT] [get_bd_intf_pins v_vid_in_axi4s_0/vid_io_in]
  connect_bd_intf_net -intf_net onsemi_python_spi_0_IO_SPI_OUT [get_bd_intf_ports IO_PYTHON_SPI] [get_bd_intf_pins onsemi_python_spi_0/IO_SPI_OUT]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI] [get_bd_intf_pins v_tpg_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI] [get_bd_intf_pins v_osd_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins onsemi_python_cam_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI] [get_bd_intf_pins v_cfa_0/ctrl]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins axi_vdma_1/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins onsemi_python_spi_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins avnet_hdmi_out_0/VID_IO_IN] [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out]
  connect_bd_intf_net -intf_net v_cfa_0_video_out [get_bd_intf_pins v_cfa_0/video_out] [get_bd_intf_pins v_rgb2ycrcb_0/video_in]
  connect_bd_intf_net -intf_net v_cresample_0_video_out [get_bd_intf_pins axi_vdma_1/S_AXIS_S2MM] [get_bd_intf_pins v_cresample_0/video_out]
  connect_bd_intf_net -intf_net v_osd_0_video_out [get_bd_intf_pins v_axi4s_vid_out_0/video_in] [get_bd_intf_pins v_osd_0/video_out]
  connect_bd_intf_net -intf_net v_rgb2ycrcb_0_video_out [get_bd_intf_pins v_cresample_0/video_in] [get_bd_intf_pins v_rgb2ycrcb_0/video_out]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]
  connect_bd_intf_net -intf_net v_tpg_0_video_out [get_bd_intf_pins axi_vdma_0/S_AXIS_S2MM] [get_bd_intf_pins v_tpg_0/video_out]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_0_video_out [get_bd_intf_pins v_cfa_0/video_in] [get_bd_intf_pins v_vid_in_axi4s_0/video_out]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins avnet_hdmi_out_0/clk] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins onsemi_python_cam_0/clk] [get_bd_pins rst_processing_system7_0_108M/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins axi_vdma_1/s_axi_lite_aclk] [get_bd_pins onsemi_python_cam_0/s00_axi_aclk] [get_bd_pins onsemi_python_spi_0/s00_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_76M/slowest_sync_clk] [get_bd_pins v_cfa_0/s_axi_aclk] [get_bd_pins v_osd_0/s_axi_aclk] [get_bd_pins v_tpg_0/s_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins axi_mem_intercon/S03_ACLK] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axi_vdma_1/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_1/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_1/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_1/s_axis_s2mm_aclk] [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins rst_processing_system7_0_149M/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins v_cfa_0/aclk] [get_bd_pins v_cresample_0/aclk] [get_bd_pins v_osd_0/aclk] [get_bd_pins v_rgb2ycrcb_0/aclk] [get_bd_pins v_tpg_0/aclk] [get_bd_pins v_vid_in_axi4s_0/aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins onsemi_python_cam_0/clk200] [get_bd_pins processing_system7_0/FCLK_CLK2]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_76M/ext_reset_in]
  connect_bd_net -net processing_system7_0_FCLK_RESET1_N [get_bd_pins processing_system7_0/FCLK_RESET1_N] [get_bd_pins rst_processing_system7_0_149M/ext_reset_in]
  connect_bd_net -net processing_system7_0_FCLK_RESET2_N [get_bd_pins processing_system7_0/FCLK_RESET2_N] [get_bd_pins rst_processing_system7_0_108M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_108M_peripheral_aresetn [get_bd_pins rst_processing_system7_0_108M/peripheral_aresetn] [get_bd_pins v_tc_0/resetn]
  connect_bd_net -net rst_processing_system7_0_108M_peripheral_reset [get_bd_pins onsemi_python_cam_0/reset] [get_bd_pins rst_processing_system7_0_108M/peripheral_reset]
  connect_bd_net -net rst_processing_system7_0_149M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins rst_processing_system7_0_149M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_149M_peripheral_aresetn [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins axi_mem_intercon/S03_ARESETN] [get_bd_pins rst_processing_system7_0_149M/peripheral_aresetn] [get_bd_pins v_cfa_0/aresetn] [get_bd_pins v_cresample_0/aresetn] [get_bd_pins v_osd_0/aresetn] [get_bd_pins v_rgb2ycrcb_0/aresetn] [get_bd_pins v_tpg_0/aresetn]
  connect_bd_net -net rst_processing_system7_0_76M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_76M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_76M_peripheral_aresetn [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins axi_vdma_1/axi_resetn] [get_bd_pins onsemi_python_cam_0/s00_axi_aresetn] [get_bd_pins onsemi_python_spi_0/s00_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_76M/peripheral_aresetn] [get_bd_pins v_axi4s_vid_out_0/aresetn] [get_bd_pins v_cfa_0/s_axi_aresetn] [get_bd_pins v_osd_0/s_axi_aresetn] [get_bd_pins v_tpg_0/s_axi_aresetn] [get_bd_pins v_vid_in_axi4s_0/aresetn]
  connect_bd_net -net rst_processing_system7_0_76M_peripheral_reset [get_bd_pins avnet_hdmi_out_0/reset] [get_bd_pins rst_processing_system7_0_76M/peripheral_reset] [get_bd_pins v_axi4s_vid_out_0/rst] [get_bd_pins v_vid_in_axi4s_0/rst]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins avnet_hdmi_out_0/audio_spdif] [get_bd_pins onsemi_python_cam_0/trigger1] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins avnet_hdmi_out_0/embed_syncs] [get_bd_pins avnet_hdmi_out_0/oe] [get_bd_pins onsemi_python_cam_0/oe] [get_bd_pins onsemi_python_spi_0/oe] [get_bd_pins v_axi4s_vid_out_0/aclken] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce] [get_bd_pins v_cfa_0/aclken] [get_bd_pins v_cfa_0/s_axi_aclken] [get_bd_pins v_cresample_0/aclken] [get_bd_pins v_osd_0/aclken] [get_bd_pins v_osd_0/s_axi_aclken] [get_bd_pins v_rgb2ycrcb_0/aclken] [get_bd_pins v_tc_0/clken] [get_bd_pins v_tc_0/gen_clken] [get_bd_pins v_tpg_0/aclken] [get_bd_pins v_tpg_0/s_axi_aclken] [get_bd_pins v_vid_in_axi4s_0/aclken] [get_bd_pins v_vid_in_axi4s_0/axis_enable] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_ce] [get_bd_pins xlconstant_1/dout]

  # Create address segments
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_1/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_vdma_1/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43010000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_1/S_AXI_LITE/Reg] SEG_axi_vdma_1_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs onsemi_python_cam_0/S00_AXI/Reg] SEG_onsemi_python_cam_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs onsemi_python_spi_0/S00_AXI/Reg] SEG_onsemi_python_spi_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_cfa_0/ctrl/Reg] SEG_v_cfa_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_osd_0/ctrl/Reg] SEG_v_osd_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_tpg_0/ctrl/Reg] SEG_v_tpg_0_Reg
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


