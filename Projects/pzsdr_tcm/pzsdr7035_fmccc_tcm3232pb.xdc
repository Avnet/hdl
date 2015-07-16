########################
# Physical Constraints #
########################

# I2C Chain on PZSDR-FMCCC
set_property PACKAGE_PIN AF24 [get_ports pzsdr_fmccc_iic_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports pzsdr_fmccc_iic_scl_io]
set_property SLEW SLOW [get_ports pzsdr_fmccc_iic_scl_io]
set_property DRIVE 8 [get_ports pzsdr_fmccc_iic_scl_io]

set_property PACKAGE_PIN AF25 [get_ports pzsdr_fmccc_iic_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports pzsdr_fmccc_iic_sda_io]
set_property SLEW SLOW [get_ports pzsdr_fmccc_iic_sda_io]
set_property DRIVE 8 [get_ports pzsdr_fmccc_iic_sda_io]

# AVNET TCM3232PB MODULE interface
set_property PACKAGE_PIN J4 [get_ports cam_extclk]; 		# CAM_REFCLK
set_property IOSTANDARD LVCMOS18 [get_ports cam_extclk];

set_property PACKAGE_PIN M6 [get_ports io_tcm_clk_in_p];	# CAM_CLK_P
set_property PACKAGE_PIN M5 [get_ports io_tcm_clk_in_n];	# CAM_CLK_N
set_property IOSTANDARD LVDS [get_ports io_tcm_clk_in_p];
set_property IOSTANDARD LVDS [get_ports io_tcm_clk_in_n];
set_property PACKAGE_PIN N3 [get_ports {io_tcm_data_in_p[0]}];	# CAM_DATA0_P
set_property PACKAGE_PIN N2 [get_ports {io_tcm_data_in_n[0]}];	# CAM_DATA0_N
set_property PACKAGE_PIN M2 [get_ports {io_tcm_data_in_p[1]}];	# CAM_DATA1_P
set_property PACKAGE_PIN L2 [get_ports {io_tcm_data_in_n[1]}];	# CAM_DATA1_N
set_property IOSTANDARD LVDS [get_ports {io_tcm_data_in_p[0]}];
set_property IOSTANDARD LVDS [get_ports {io_tcm_data_in_n[0]}];
set_property IOSTANDARD LVDS [get_ports {io_tcm_data_in_p[1]}];
set_property IOSTANDARD LVDS [get_ports {io_tcm_data_in_n[1]}];

set_property DIFF_TERM TRUE [get_ports {io_tcm_data_in_p[1]}]
set_property DIFF_TERM TRUE [get_ports {io_tcm_data_in_n[1]}]
set_property DIFF_TERM TRUE [get_ports {io_tcm_data_in_p[0]}]
set_property DIFF_TERM TRUE [get_ports {io_tcm_data_in_n[0]}]
set_property DIFF_TERM TRUE [get_ports io_tcm_clk_in_p]
set_property DIFF_TERM TRUE [get_ports io_tcm_clk_in_n]

# HDMI Output (ADV7511) on PZSDR-FMCCC
set_property PACKAGE_PIN L3 [get_ports IO_HDMIO_clk];		# HDMI_CLK
set_property PACKAGE_PIN G2 [get_ports {IO_HDMIO_data[0]}];	# HDMI_D20
set_property PACKAGE_PIN F2 [get_ports {IO_HDMIO_data[1]}]; 	# HDMI_D21
set_property PACKAGE_PIN D1 [get_ports {IO_HDMIO_data[2]}];	# HDMI_D22
set_property PACKAGE_PIN C1 [get_ports {IO_HDMIO_data[3]}];	# HDMI_D23
set_property PACKAGE_PIN E2 [get_ports {IO_HDMIO_data[4]}];	# HDMI_D24
set_property PACKAGE_PIN E1 [get_ports {IO_HDMIO_data[5]}];	# HDMI_D25
set_property PACKAGE_PIN F3 [get_ports {IO_HDMIO_data[6]}];	# HDMI_D26
set_property PACKAGE_PIN E3 [get_ports {IO_HDMIO_data[7]}];	# HDMI_D27
set_property PACKAGE_PIN J1 [get_ports {IO_HDMIO_data[8]}];	# HDMI_D28
set_property PACKAGE_PIN H1 [get_ports {IO_HDMIO_data[9]}];	# HDMI_D29
set_property PACKAGE_PIN H4 [get_ports {IO_HDMIO_data[10]}];	# HDMI_D30
set_property PACKAGE_PIN H3 [get_ports {IO_HDMIO_data[11]}];	# HDMI_D31
set_property PACKAGE_PIN K2 [get_ports {IO_HDMIO_data[12]}];	# HDMI_D32
set_property PACKAGE_PIN K1 [get_ports {IO_HDMIO_data[13]}];	# HDMI_D33
set_property PACKAGE_PIN H2 [get_ports {IO_HDMIO_data[14]}];	# HDMI_D34
set_property PACKAGE_PIN G1 [get_ports {IO_HDMIO_data[15]}];	# HDMI_D35
set_property PACKAGE_PIN G4 [get_ports IO_HDMIO_spdif];		# HDMI_SPDIF
#set_property PACKAGE_PIN F4 [get_ports IO_HDMIO_spdif];	# HDMI_SPDIF_OUT

set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_data*]
set_property IOB TRUE [get_ports IO_HDMIO_data*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_spdif]

######################
#  Clock Constraints #
######################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 10.000 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period  6.667 -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]
#create_clock -period  5.000 -name clk_fpga_2 [get_nets -hierarchical FCLK_CLK2]

# Rename auto-generated clocks
create_clock -period 2.000 -name io_tcm_clk_in [get_ports io_tcm_clk_in_p]

# Define asynchronous clock domains
set_clock_groups -asynchronous -group [get_clocks clk_fpga_0] \
                               -group [get_clocks clk_fpga_1] \
                               -group [get_clocks clk_out1_embv_tcm_clk_wiz_1_0_1] \
                               -group [get_clocks io_tcm_clk_out]
