set_property IOSTANDARD LVCMOS18 [get_ports mezz*]

#HD_GPIO_2 on FPGA / Connector pin 7 / mezz_uart_0_txd
set_property PACKAGE_PIN F8 [get_ports mezz_uart_0_txd]
#HD_GPIO_1 on FPGA / Connector pin 5 / mezz_uart_0_rxd
set_property PACKAGE_PIN F7 [get_ports mezz_uart_0_rxd]

#HD_GPIO_5 on FPGA / Connector pin 13 / mezz_uart_1_rxd
set_property PACKAGE_PIN G5 [get_ports mezz_uart_1_rxd]
#HD_GPIO_4 on FPGA / Connector pin 11 / mezz_uart_1_txd
set_property PACKAGE_PIN F6 [get_ports mezz_uart_1_txd]

#HD_GPIO_11 on FPGA / Connector pin 20 / mezz_int_0
set_property PACKAGE_PIN D6 [get_ports {mezz_int_0[0]}]

#HD_GPIO_12 on FPGA / Connector pin 22 / mezz_int_1
set_property PACKAGE_PIN D5 [get_ports {mezz_int_1[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports BT*]

#BT_HCI_RTS on FPGA / emio_uart0_ctsn 
set_property PACKAGE_PIN B7 [get_ports BT_ctsn]
#BT_HCI_CTS on FPGA / emio_uart0_rtsn
set_property PACKAGE_PIN B5 [get_ports BT_rtsn]

