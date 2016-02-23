
########################
# Physical Constraints #
########################

# HDMI Output (ADV7511) on Embedded Vision Carrier Card
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMIO_data[15]}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMIO_data[14]}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMIO_data[13]}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMIO_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {IO_HDMIO_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_spdif]
set_property PACKAGE_PIN U14 [get_ports IO_HDMIO_clk]
set_property PACKAGE_PIN L15 [get_ports IO_HDMIO_spdif]
set_property PACKAGE_PIN H15 [get_ports {IO_HDMIO_data[15]}]
set_property PACKAGE_PIN G15 [get_ports {IO_HDMIO_data[14]}]
set_property PACKAGE_PIN K14 [get_ports {IO_HDMIO_data[13]}]
set_property PACKAGE_PIN J14 [get_ports {IO_HDMIO_data[12]}]
set_property PACKAGE_PIN P15 [get_ports {IO_HDMIO_data[11]}]
set_property PACKAGE_PIN P16 [get_ports {IO_HDMIO_data[10]}]
set_property PACKAGE_PIN N17 [get_ports {IO_HDMIO_data[9]}]
set_property PACKAGE_PIN P18 [get_ports {IO_HDMIO_data[8]}]
set_property PACKAGE_PIN T16 [get_ports {IO_HDMIO_data[7]}]
set_property PACKAGE_PIN U17 [get_ports {IO_HDMIO_data[6]}]
set_property PACKAGE_PIN U15 [get_ports {IO_HDMIO_data[5]}]
set_property PACKAGE_PIN U19 [get_ports {IO_HDMIO_data[4]}]
set_property PACKAGE_PIN Y18 [get_ports {IO_HDMIO_data[3]}]
set_property PACKAGE_PIN Y19 [get_ports {IO_HDMIO_data[2]}]
set_property PACKAGE_PIN V16 [get_ports {IO_HDMIO_data[1]}]
set_property PACKAGE_PIN W16 [get_ports {IO_HDMIO_data[0]}]

# PYTHON-1300 Camera Module
set_property PACKAGE_PIN G14 [get_ports {IO_PYTHON_CAM_trigger[0]}]
set_property PACKAGE_PIN J15 [get_ports {IO_PYTHON_CAM_trigger[1]}]
set_property PACKAGE_PIN B20 [get_ports {IO_PYTHON_CAM_trigger[2]}]
set_property PACKAGE_PIN U13 [get_ports IO_PYTHON_CAM_reset_n]
set_property PACKAGE_PIN M15 [get_ports IO_PYTHON_SPI_spi_mosi]
set_property PACKAGE_PIN M14 [get_ports IO_PYTHON_SPI_spi_sclk]
set_property PACKAGE_PIN N15 [get_ports IO_PYTHON_SPI_spi_ssel_n]
set_property PACKAGE_PIN B19 [get_ports {IO_PYTHON_CAM_monitor[0]}]
set_property PACKAGE_PIN A20 [get_ports {IO_PYTHON_CAM_monitor[1]}]
set_property PACKAGE_PIN C20 [get_ports IO_PYTHON_CAM_clk_pll]
set_property PACKAGE_PIN N16 [get_ports IO_PYTHON_SPI_spi_miso]
set_property PACKAGE_PIN H16 [get_ports IO_PYTHON_CAM_clk_out_p]; # CAM_CLK_P
set_property PACKAGE_PIN H17 [get_ports IO_PYTHON_CAM_clk_out_n]; # CAM_CLK_N
set_property PACKAGE_PIN K17 [get_ports IO_PYTHON_CAM_sync_p]; # CAM_SYNC_P
set_property PACKAGE_PIN K18 [get_ports IO_PYTHON_CAM_sync_n]; # CAM_SYNC_N
#set_property PACKAGE_PIN M17 [get_ports {IO_PYTHON_CAM_data_p[]}]; # CAM_DATA0_P
#set_property PACKAGE_PIN M18 [get_ports {IO_PYTHON_CAM_data_n[]}]; # CAM_DATA0_N
#set_property PACKAGE_PIN K19 [get_ports {IO_PYTHON_CAM_data_p[]}]; # CAM_DATA1_P
#set_property PACKAGE_PIN L19 [get_ports {IO_PYTHON_CAM_data_n[]}]; # CAM_DATA1_N
set_property PACKAGE_PIN M19 [get_ports {IO_PYTHON_CAM_data_p[0]}]; # CAM_DATA2_P
set_property PACKAGE_PIN M20 [get_ports {IO_PYTHON_CAM_data_n[0]}]; # CAM_DATA2_N
set_property PACKAGE_PIN L19 [get_ports {IO_PYTHON_CAM_data_p[1]}]; # CAM_DATA3_P
set_property PACKAGE_PIN L20 [get_ports {IO_PYTHON_CAM_data_n[1]}]; # CAM_DATA3_N
set_property PACKAGE_PIN F16 [get_ports {IO_PYTHON_CAM_data_p[2]}]; # CAM_DATA4_P
set_property PACKAGE_PIN F17 [get_ports {IO_PYTHON_CAM_data_n[2]}]; # CAM_DATA4_N
set_property PACKAGE_PIN E18 [get_ports {IO_PYTHON_CAM_data_p[3]}]; # CAM_DATA5_P
set_property PACKAGE_PIN E19 [get_ports {IO_PYTHON_CAM_data_n[3]}]; # CAM_DATA5_N
#set_property PACKAGE_PIN D19 [get_ports {IO_PYTHON_CAM_data_p[]}]; # CAM_DATA6_P
#set_property PACKAGE_PIN D20 [get_ports {IO_PYTHON_CAM_data_n[]}]; # CAM_DATA6_N
#set_property PACKAGE_PIN E17 [get_ports {IO_PYTHON_CAM_data_p[]}]; # CAM_DATA7_P
#set_property PACKAGE_PIN D18 [get_ports {IO_PYTHON_CAM_data_n[]}]; # CAM_DATA7_N

set_property IOSTANDARD LVCMOS25 [get_ports {IO_PYTHON_CAM_trigger[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_PYTHON_CAM_trigger[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_PYTHON_CAM_trigger[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports IO_PYTHON_CAM_reset_n]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_SPI_spi_mosi]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_SPI_spi_sclk]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_SPI_spi_ssel_n]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_PYTHON_CAM_monitor[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_PYTHON_CAM_monitor[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_CAM_clk_pll]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_SPI_spi_miso]
set_property IOSTANDARD LVDS_25 [get_ports IO_PYTHON_CAM_clk_out_*]
set_property IOSTANDARD LVDS_25 [get_ports IO_PYTHON_CAM_sync_*]
set_property IOSTANDARD LVDS_25 [get_ports IO_PYTHON_CAM_data_*]

set_property DIFF_TERM TRUE [get_ports IO_PYTHON_CAM_clk_out_*]
set_property DIFF_TERM TRUE [get_ports IO_PYTHON_CAM_sync_*]
set_property DIFF_TERM TRUE [get_ports IO_PYTHON_CAM_data_*]


######################
#  Clock Constraints #
######################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 13.333 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period  6.667 -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]
#create_clock -period  5.000 -name clk_fpga_2 [get_nets -hierarchical FCLK_CLK2]

create_clock -period 3.703 -name vita_ser_clk [get_ports IO_PYTHON_CAM_clk_out_p]

# Define asynchronous clock domains
set_clock_groups -asynchronous  -group [get_clocks clk_fpga_0] \
                                -group [get_clocks clk_fpga_1] \
                                -group [get_clocks clk_out1_embv_python1300c_fb_clk_wiz_0_0] \
                                -group [get_clocks vita_clk_div4_l_n_0_1] \
                                -group [get_clocks CLKDIV_c_0]
