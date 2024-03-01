set_property IOSTANDARD LVCMOS18 [get_ports BT*]

#BT_HCI_RTS on FPGA / emio_uart0_ctsn
set_property PACKAGE_PIN B7 [get_ports BT_ctsn]
#BT_HCI_CTS on FPGA / emio_uart0_rtsn
set_property PACKAGE_PIN B5 [get_ports BT_rtsn]


set_property IOSTANDARD LVCMOS18   [get_ports loopback_in*]
set_property IOSTANDARD LVCMOS18   [get_ports loopback_out*]

set_property PACKAGE_PIN D7    [get_ports {loopback_in[0]}]
set_property PACKAGE_PIN F7    [get_ports {loopback_in[1]}]
set_property PACKAGE_PIN F6    [get_ports {loopback_in[2]}]
set_property PACKAGE_PIN E6    [get_ports {loopback_in[3]}]
set_property PACKAGE_PIN D6    [get_ports {loopback_in[4]}]
set_property PACKAGE_PIN B6    [get_ports {loopback_in[5]}]
set_property PACKAGE_PIN E8    [get_ports {loopback_in[6]}]
set_property PACKAGE_PIN D8    [get_ports {loopback_in[7]}]
set_property PACKAGE_PIN G1    [get_ports {loopback_in[8]}]
set_property PACKAGE_PIN F1    [get_ports {loopback_in[9]}]
set_property PACKAGE_PIN E1    [get_ports {loopback_in[10]}]
set_property PACKAGE_PIN D1    [get_ports {loopback_in[11]}]
set_property PACKAGE_PIN N2    [get_ports {loopback_in[12]}]
set_property PACKAGE_PIN P1    [get_ports {loopback_in[13]}]
set_property PACKAGE_PIN N5    [get_ports {loopback_in[14]}]
set_property PACKAGE_PIN N4    [get_ports {loopback_in[15]}]
set_property PACKAGE_PIN M2    [get_ports {loopback_in[16]}]
set_property PACKAGE_PIN M1    [get_ports {loopback_in[17]}]
set_property PACKAGE_PIN M5    [get_ports {loopback_in[18]}]
set_property PACKAGE_PIN M4    [get_ports {loopback_in[19]}]
set_property PACKAGE_PIN A2    [get_ports {loopback_in[20]}]

set_property PACKAGE_PIN F8    [get_ports {loopback_out[0]}]
set_property PACKAGE_PIN G7    [get_ports {loopback_out[1]}]
set_property PACKAGE_PIN G5    [get_ports {loopback_out[2]}]
set_property PACKAGE_PIN E5    [get_ports {loopback_out[3]}]
set_property PACKAGE_PIN D5    [get_ports {loopback_out[4]}]
set_property PACKAGE_PIN C5    [get_ports {loopback_out[5]}]
set_property PACKAGE_PIN H5    [get_ports {loopback_out[6]}]
set_property PACKAGE_PIN J5    [get_ports {loopback_out[7]}]
set_property PACKAGE_PIN E4    [get_ports {loopback_out[8]}]
set_property PACKAGE_PIN E3    [get_ports {loopback_out[9]}]
set_property PACKAGE_PIN D3    [get_ports {loopback_out[10]}]
set_property PACKAGE_PIN C3    [get_ports {loopback_out[11]}]
set_property PACKAGE_PIN T3    [get_ports {loopback_out[12]}]
set_property PACKAGE_PIN T2    [get_ports {loopback_out[13]}] 
set_property PACKAGE_PIN P3    [get_ports {loopback_out[14]}]
set_property PACKAGE_PIN R3    [get_ports {loopback_out[15]}]
set_property PACKAGE_PIN U2    [get_ports {loopback_out[16]}]
set_property PACKAGE_PIN U1    [get_ports {loopback_out[17]}]
set_property PACKAGE_PIN L2    [get_ports {loopback_out[18]}]
set_property PACKAGE_PIN L1    [get_ports {loopback_out[19]}]
set_property PACKAGE_PIN C2    [get_ports {loopback_out[20]}]
set_property PACKAGE_PIN A6    [get_ports {loopback_out[21]}]
set_property PACKAGE_PIN C7    [get_ports {loopback_out[22]}]


set_property IOSTANDARD LVCMOS18 [get_ports ls_mezz_uart*]

#HD_GPIO_7 on FPGA / Connector pin 31 / ls_mezz_uart_rxd
set_property PACKAGE_PIN A7 [get_ports ls_mezz_uart_rxd]
#HD_GPIO_8 on FPGA / Connector pin 33 / ls_mezz_uart_txd
set_property PACKAGE_PIN G6 [get_ports ls_mezz_uart_txd]


set_property IOSTANDARD LVCMOS18 [get_ports *_en_led*]

#RADIO_LED0 / LED D9 / WiFi LED
set_property PACKAGE_PIN A9 [get_ports {wifi_en_led_tri_o[0]}]
#RADIO_LED1 / LED D10 / Bluetooth LED
set_property PACKAGE_PIN B9 [get_ports {bt_en_led_tri_o[0]}]



