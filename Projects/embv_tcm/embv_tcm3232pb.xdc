set_property PACKAGE_PIN C20 [get_ports cam_extclk]
set_property IOSTANDARD LVCMOS25 [get_ports cam_extclk]

set_property PACKAGE_PIN H16 [get_ports io_tcm_clk_in_p]
set_property IOSTANDARD LVDS_25 [get_ports io_tcm_clk_in_p]
set_property IOSTANDARD LVDS_25 [get_ports io_tcm_clk_in_n]
set_property PACKAGE_PIN M18 [get_ports {io_tcm_data_in_n[0]}]
set_property PACKAGE_PIN J19 [get_ports {io_tcm_data_in_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {io_tcm_data_in_p[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {io_tcm_data_in_n[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {io_tcm_data_in_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {io_tcm_data_in_n[0]}]

set_property DIFF_TERM TRUE [get_ports {io_tcm_data_in_p[1]}]
set_property DIFF_TERM TRUE [get_ports {io_tcm_data_in_n[1]}]
set_property DIFF_TERM TRUE [get_ports {io_tcm_data_in_p[0]}]
set_property DIFF_TERM TRUE [get_ports {io_tcm_data_in_n[0]}]
set_property DIFF_TERM TRUE [get_ports io_tcm_clk_in_p]
set_property DIFF_TERM TRUE [get_ports io_tcm_clk_in_n]

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
