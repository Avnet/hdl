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


# AVNET PYTHON1300 MODULE interface
set_property PACKAGE_PIN J4 [get_ports IO_PYTHON_CAM_clk_pll]; 		# CAM_REFCLK
set_property PACKAGE_PIN J11 [get_ports IO_PYTHON_CAM_reset_n];		# CAM_GPIO_0
set_property PACKAGE_PIN G9 [get_ports {IO_PYTHON_CAM_trigger[2]}];	# CAM_GPIO_5
set_property PACKAGE_PIN H9 [get_ports {IO_PYTHON_CAM_trigger[1]}];	# CAM_GPIO_4
set_property PACKAGE_PIN G6 [get_ports {IO_PYTHON_CAM_trigger[0]}];	# CAM_GPIO_2
set_property PACKAGE_PIN H7 [get_ports {IO_PYTHON_CAM_monitor[0]}];	# CAM_GPIO_6
set_property PACKAGE_PIN G5 [get_ports {IO_PYTHON_CAM_monitor[1]}];	# CAM_GPIO_3
set_property PACKAGE_PIN N6 [get_ports IO_PYTHON_SPI_spi_sclk];		# CAM_SPI_CLK
set_property PACKAGE_PIN N7 [get_ports IO_PYTHON_SPI_spi_ssel_n];	# CAM_SPI_EN
set_property PACKAGE_PIN K7 [get_ports IO_PYTHON_SPI_spi_mosi];		# CAM_SPI_MOSI
set_property PACKAGE_PIN K8 [get_ports IO_PYTHON_SPI_spi_miso];		# CAM_SPI_MISO
set_property PACKAGE_PIN M6 [get_ports IO_PYTHON_CAM_clk_out_p];	# CAM_CLK_P
set_property PACKAGE_PIN M5 [get_ports IO_PYTHON_CAM_clk_out_n];	# CAM_CLK_N
set_property PACKAGE_PIN L5 [get_ports IO_PYTHON_CAM_sync_p];		# CAM_SYNC_P
set_property PACKAGE_PIN L4 [get_ports IO_PYTHON_CAM_sync_n];		# CAM_SYNC_N
#set_property PACKAGE_PIN N3 [get_ports {IO_PYTHON_CAM_data_p[]}];	# CAM_DATA0_P
#set_property PACKAGE_PIN N2 [get_ports {IO_PYTHON_CAM_data_n[]}];	# CAM_DATA0_N
#set_property PACKAGE_PIN M2 [get_ports {IO_PYTHON_CAM_data_p[]}];	# CAM_DATA1_P
#set_property PACKAGE_PIN L2 [get_ports {IO_PYTHON_CAM_data_n[]}];	# CAM_DATA1_N
set_property PACKAGE_PIN N4 [get_ports {IO_PYTHON_CAM_data_p[0]}];	# CAM_DATA2_P
set_property PACKAGE_PIN M4 [get_ports {IO_PYTHON_CAM_data_n[0]}];	# CAM_DATA2_N
set_property PACKAGE_PIN N1 [get_ports {IO_PYTHON_CAM_data_p[1]}];	# CAM_DATA3_P
set_property PACKAGE_PIN M1 [get_ports {IO_PYTHON_CAM_data_n[1]}];	# CAM_DATA3_N
set_property PACKAGE_PIN M7 [get_ports {IO_PYTHON_CAM_data_p[2]}];	# CAM_DATA4_P
set_property PACKAGE_PIN L7 [get_ports {IO_PYTHON_CAM_data_n[2]}];	# CAM_DATA4_N
set_property PACKAGE_PIN K5 [get_ports {IO_PYTHON_CAM_data_p[3]}];	# CAM_DATA5_P
set_property PACKAGE_PIN J5 [get_ports {IO_PYTHON_CAM_data_n[3]}];	# CAM_DATA5_N
#set_property PACKAGE_PIN M8 [get_ports {IO_PYTHON_CAM_data_p[]}];	# CAM_DATA6_P
#set_property PACKAGE_PIN L8 [get_ports {IO_PYTHON_CAM_data_n[]}];	# CAM_DATA6_N
#set_property PACKAGE_PIN K6 [get_ports {IO_PYTHON_CAM_data_p[]}];	# CAM_DATA7_P
#set_property PACKAGE_PIN J6 [get_ports {IO_PYTHON_CAM_data_n[]}];	# CAM_DATA7_N

set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_CAM_clk_pll]
set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_CAM_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_CAM_trigger*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_CAM_monitor*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_SPI_spi_*]

set_property IOSTANDARD LVDS [get_ports IO_PYTHON_CAM_clk_out_*]
set_property IOSTANDARD LVDS [get_ports IO_PYTHON_CAM_sync_*]
set_property IOSTANDARD LVDS [get_ports IO_PYTHON_CAM_data_*]

set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_clk_out_*]
set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_sync_*]
set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_data_*]


######################
#  Clock Constraints #
######################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 13.333 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period  6.667 -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]
#create_clock -period  5.000 -name clk_fpga_2 [get_nets -hierarchical FCLK_CLK2]

create_clock -period 2.692 -name vita_ser_clk [get_ports IO_PYTHON_CAM_clk_out_p]


# Define asynchronous clock domains
set_clock_groups -asynchronous  -group [get_clocks clk_fpga_0] \
                                -group [get_clocks clk_fpga_1] \
                                -group [get_clocks {*serdesclockgen[0].ic*}] \
                                -group [get_clocks clk_out1_pzsdr_python1300c_clk_wiz_0_0] \
                                -group [get_clocks vita_ser_clk] \
                                -group [get_clocks vita_clk]
