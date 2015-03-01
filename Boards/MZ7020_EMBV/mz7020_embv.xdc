
########################
# Physical Constraints #
########################

# HDMI Output (ADV7511) on Embedded Vision Carrier Card 
set_property PACKAGE_PIN U14 [get_ports hdmio_io_clk]
set_property IOSTANDARD LVCMOS33 [get_ports hdmio_io_clk]

set_property PACKAGE_PIN W16 [get_ports {hdmio_io_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[0]}]

set_property PACKAGE_PIN V16 [get_ports {hdmio_io_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[1]}]

set_property PACKAGE_PIN Y19 [get_ports {hdmio_io_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[2]}]

set_property PACKAGE_PIN Y18 [get_ports {hdmio_io_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[3]}]

set_property PACKAGE_PIN U19 [get_ports {hdmio_io_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[4]}]

set_property PACKAGE_PIN U15 [get_ports {hdmio_io_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[5]}]

set_property PACKAGE_PIN U17 [get_ports {hdmio_io_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[6]}]

set_property PACKAGE_PIN T16 [get_ports {hdmio_io_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[7]}]

set_property PACKAGE_PIN P18 [get_ports {hdmio_io_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[8]}]

set_property PACKAGE_PIN N17 [get_ports {hdmio_io_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[9]}]

set_property PACKAGE_PIN P16 [get_ports {hdmio_io_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[10]}]

set_property PACKAGE_PIN P15 [get_ports {hdmio_io_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmio_io_data[11]}]

set_property PACKAGE_PIN J14 [get_ports {hdmio_io_data[12]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hdmio_io_data[12]}]

set_property PACKAGE_PIN K14 [get_ports {hdmio_io_data[13]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hdmio_io_data[13]}]

set_property PACKAGE_PIN G15 [get_ports {hdmio_io_data[14]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hdmio_io_data[14]}]

set_property PACKAGE_PIN H15 [get_ports {hdmio_io_data[15]}]
set_property IOSTANDARD LVCMOS25 [get_ports {hdmio_io_data[15]}]

set_property PACKAGE_PIN L15 [get_ports hdmio_io_spdif]
set_property IOSTANDARD LVCMOS25 [get_ports hdmio_io_spdif]

# HDMI Input (ADV7611) on Embedded Vision Carrier Card
set_property PACKAGE_PIN U18 [get_ports hdmii_clk]
set_property IOSTANDARD LVCMOS33 [get_ports hdmii_clk]

set_property PACKAGE_PIN R14  [get_ports {hdmii_io_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[0]}]

set_property PACKAGE_PIN P14  [get_ports {hdmii_io_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[1]}]

set_property PACKAGE_PIN W13  [get_ports {hdmii_io_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[2]}]

set_property PACKAGE_PIN V12  [get_ports {hdmii_io_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[3]}]

set_property PACKAGE_PIN U12  [get_ports {hdmii_io_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[4]}]

set_property PACKAGE_PIN T12  [get_ports {hdmii_io_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[5]}]

set_property PACKAGE_PIN T10  [get_ports {hdmii_io_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[6]}]

set_property PACKAGE_PIN T11 [get_ports {hdmii_io_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[7]}]

set_property PACKAGE_PIN W15  [get_ports {hdmii_io_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[8]}]

set_property PACKAGE_PIN V15  [get_ports {hdmii_io_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[9]}]

set_property PACKAGE_PIN Y17 [get_ports {hdmii_io_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[10]}]

set_property PACKAGE_PIN Y16  [get_ports {hdmii_io_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[11]}]

set_property PACKAGE_PIN Y14  [get_ports {hdmii_io_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[12]}]

set_property PACKAGE_PIN W14 [get_ports {hdmii_io_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[13]}]

set_property PACKAGE_PIN T15  [get_ports {hdmii_io_data[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[14]}]

set_property PACKAGE_PIN T14  [get_ports {hdmii_io_data[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmii_io_data[15]}]

set_property PACKAGE_PIN L14  [get_ports {hdmii_io_spdif}]
set_property IOSTANDARD LVCMOS25 [get_ports {hdmii_io_spdif}]

##################
# Primary Clocks #
##################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 20.000 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period 7.000 -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]

create_clock -period 6.730 -name hdmii_clk [get_ports hdmii_clk]

set_clock_groups -asynchronous -group [get_clocks "clk_fpga_0" ] -group [get_clocks "clk_fpga_1" ]  -group [get_clocks -include_generated_clocks "hdmii_clk" ]
