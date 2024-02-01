#
# Set I/O standards
#
set_property IOSTANDARD LVCMOS33 [get_ports {click_spi*}]

#
# Set I/O location constraints
#
set_property PACKAGE_PIN H9 [get_ports {click_spi_ss_io[1]}]
set_property PACKAGE_PIN H11 [get_ports {click_spi_ss_io[0]}]
