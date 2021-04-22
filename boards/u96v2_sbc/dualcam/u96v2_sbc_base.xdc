#######################################################################
# Ultra96 Bluetooth UART Modem Signals
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports bt*]

#BT_HCI_RTS on FPGA / emio_uart0_ctsn
set_property PACKAGE_PIN B7 [get_ports bt_ctsn]
#BT_HCI_CTS on FPGA / emio_uart0_rtsn
set_property PACKAGE_PIN B5 [get_ports bt_rtsn]

#######################################################################
# Ultra96 WiFi & BT LEDs
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports *_en_led*]

#RADIO_LED0 on FPGA / LED D9 / WiFi LED
set_property PACKAGE_PIN A9 [get_ports {wifi_en_led_tri_o[0]}]
#RADIO_LED1 on FPGA / LED D10 / Bluetooth LED
set_property PACKAGE_PIN B9 [get_ports {bt_en_led_tri_o[0]}]

#######################################################################
# Ultra96 Fan
#######################################################################
set_property IOSTANDARD LVCMOS12 [get_ports {fan_pwm_tri_o[0]}]

#FAN_PWM on FPGA
set_property PACKAGE_PIN F4 [get_ports {fan_pwm_tri_o[0]}]

