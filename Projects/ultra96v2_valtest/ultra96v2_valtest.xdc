set_property IOSTANDARD LVCMOS18 [get_ports BT*]

#BT_HCI_RTS on FPGA / emio_uart0_ctsn
set_property PACKAGE_PIN B7 [get_ports BT_ctsn]
#BT_HCI_CTS on FPGA / emio_uart0_rtsn
set_property PACKAGE_PIN B5 [get_ports BT_rtsn]

set_property IOSTANDARD LVCMOS18 [get_ports ls_mezz*]
set_property PACKAGE_PIN F8 [get_ports {ls_mezz_loop_in_tri_io[0]}]
set_property PACKAGE_PIN G7 [get_ports {ls_mezz_loop_in_tri_io[1]}]
set_property PACKAGE_PIN G5 [get_ports {ls_mezz_loop_in_tri_io[2]}]
set_property PACKAGE_PIN A6 [get_ports {ls_mezz_loop_in_tri_io[3]}]
set_property PACKAGE_PIN E5 [get_ports {ls_mezz_loop_in_tri_io[4]}]
set_property PACKAGE_PIN D5 [get_ports {ls_mezz_loop_in_tri_io[5]}]
set_property PACKAGE_PIN C7 [get_ports {ls_mezz_loop_in_tri_io[6]}]
set_property PACKAGE_PIN C5 [get_ports {ls_mezz_loop_in_tri_io[7]}]

set_property PACKAGE_PIN D7 [get_ports {ls_mezz_loop_out_tri_io[0]}]
set_property PACKAGE_PIN F7 [get_ports {ls_mezz_loop_out_tri_io[1]}]
set_property PACKAGE_PIN F6 [get_ports {ls_mezz_loop_out_tri_io[2]}]
set_property PACKAGE_PIN A8 [get_ports {ls_mezz_loop_out_tri_io[3]}]
set_property PACKAGE_PIN E6 [get_ports {ls_mezz_loop_out_tri_io[4]}]
set_property PACKAGE_PIN D6 [get_ports {ls_mezz_loop_out_tri_io[5]}]
set_property PACKAGE_PIN C8 [get_ports {ls_mezz_loop_out_tri_io[6]}]
set_property PACKAGE_PIN B6 [get_ports {ls_mezz_loop_out_tri_io[7]}]
#HD_GPIO_7 on FPGA / Connector pin 31 / ls_mezz_uart_rxd
set_property PACKAGE_PIN A7 [get_ports ls_mezz_uart_rxd]
#HD_GPIO_8 on FPGA / Connector pin 33 / ls_mezz_uart_txd
set_property PACKAGE_PIN G6 [get_ports ls_mezz_uart_txd]

set_property IOSTANDARD LVCMOS12 [get_ports fan_pwm]
set_property PACKAGE_PIN F4 [get_ports fan_pwm]

set_property PACKAGE_PIN A3 [get_ports {wifi_radio_rstn_tri_io[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {wifi_radio_rstn_tri_io[0]}]
set_property PULLUP true [get_ports {wifi_radio_rstn_tri_io[0]}]
set_property DRIVE 8 [get_ports {wifi_radio_rstn_tri_io[0]}]

