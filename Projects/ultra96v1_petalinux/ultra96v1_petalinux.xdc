#######################################################################
# Ultra96 LS Mezzanine PWMs
#######################################################################
# These constraints are used for when connecting the LS Mezzanine PWM to 
# the PWM_w_Int custom IP block.
set_property IOSTANDARD LVCMOS18 [get_ports ls_mezz_pwm_out*]

set_property PACKAGE_PIN A6 [get_ports {ls_mezz_pwm_out1[0]}]
set_property PACKAGE_PIN C7 [get_ports {ls_mezz_pwm_out2[0]}]

#######################################################################
# Ultra96 LS Mezzanine UARTs
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports ls_mezz_uart*]

#HD_GPIO_2 on Ultra96 / Connector pin 7
set_property PACKAGE_PIN F8 [get_ports ls_mezz_uart1_rx]
#HD_GPIO_1 on Ultra96 / Connector pin 5
set_property PACKAGE_PIN F7 [get_ports ls_mezz_uart1_tx]

#HD_GPIO_5 on Ultra96 / Connector pin 13
set_property PACKAGE_PIN G5 [get_ports ls_mezz_uart2_rx]
#HD_GPIO_4 on Ultra96 / Connector pin 11
set_property PACKAGE_PIN F6 [get_ports ls_mezz_uart2_tx]

#######################################################################
# Ultra96 LS Mezzanine Resets
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports {ls_mezz_rst*}]
#HD_GPIO_7 on Ultra96
set_property PACKAGE_PIN A7 [get_ports {ls_mezz_rst[0]}]
#HD_GPIO_14 on Ultra96
set_property PACKAGE_PIN B6 [get_ports {ls_mezz_rst[1]}]

#######################################################################
# Ultra96 LS Mezzanine Interrupts
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports {ls_mezz_int*}]
#HD_GPIO_8 on Ultra96
set_property PACKAGE_PIN G6 [get_ports {ls_mezz_int[0]}]
#HD_GPIO_15 on Ultra96
set_property PACKAGE_PIN C5 [get_ports {ls_mezz_int[1]}]

#######################################################################
# Ultra96 Fan
#######################################################################
set_property IOSTANDARD LVCMOS12 [get_ports {fan_pwm[0]}]
#FAN_PWM on Ultra96
set_property PACKAGE_PIN F4 [get_ports {fan_pwm[0]}]

#######################################################################
# Ultra96 Bluetooth UART Modem Signals
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports bt*]
#BT_HCI_RTS on Ultra96 / emio_uart0_ctsn
set_property PACKAGE_PIN B7 [get_ports bt_ctsn]
#BT_HCI_CTS on Ultra96 / emio_uart0_rtsn
set_property PACKAGE_PIN B5 [get_ports bt_rtsn]
