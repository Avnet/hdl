#######################################################################
# Ultra96 Bluetooth UART Modem Signals
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports bt*]

#BT_HCI_RTS on FPGA / emio_uart0_ctsn
set_property PACKAGE_PIN B7 [get_ports bt_ctsn]
#BT_HCI_CTS on FPGA / emio_uart0_rtsn
set_property PACKAGE_PIN B5 [get_ports bt_rtsn]

#######################################################################
# Ultra96 LS Mezzanine UARTs
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports ls_mezz_uart*]

#HD_GPIO_2 on FPGA / Connector pin 7
set_property PACKAGE_PIN F8 [get_ports ls_mezz_uart0_rx]
#HD_GPIO_1 on FPGA / Connector pin 5
set_property PACKAGE_PIN F7 [get_ports ls_mezz_uart0_tx]

#HD_GPIO_5 on FPGA / Connector pin 13
set_property PACKAGE_PIN G5 [get_ports ls_mezz_uart1_rx]
#HD_GPIO_4 on FPGA / Connector pin 11
set_property PACKAGE_PIN F6 [get_ports ls_mezz_uart1_tx]

#######################################################################
# Ultra96 LS Mezzanine Resets
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports ls_mezz_rst*]

#HD_GPIO_7 on FPGA / Connector pin 31
set_property PACKAGE_PIN B6 [get_ports {ls_mezz_rst[1]}]
#HD_GPIO_14 on FPGA / Connector pin 32
set_property PACKAGE_PIN A7 [get_ports {ls_mezz_rst[0]}]

#######################################################################
# Ultra96 LS Mezzanine Interrupts
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports ls_mezz_int*]

#HD_GPIO_8 on FPGA / Connector pin 33
set_property PACKAGE_PIN G6 [get_ports {ls_mezz_int[0]}]
#HD_GPIO_15 on FPGA / Connector pin 34
set_property PACKAGE_PIN C5 [get_ports {ls_mezz_int[1]}]

#######################################################################
# Ultra96 LS Mezzanine PWMs
#######################################################################
# These constraints are used for when connecting the LS Mezzanine PWM to 
# the PWM_w_Int custom IP block.
set_property IOSTANDARD LVCMOS18 [get_ports ls_mezz_pwm*]

#HD_GPIO_6 on FPGA / Connector pin 29 / PWM1
set_property PACKAGE_PIN A6 [get_ports {ls_mezz_pwm0[0]}]
#HD_GPIO_13 on FPGA / Connector pin 30 / PWM2
set_property PACKAGE_PIN C7 [get_ports {ls_mezz_pwm1[0]}]

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

#######################################################################
# Ultra96 High Speed Mezzanine Connections
#######################################################################
set_property IOSTANDARD LVCMOS12 [get_ports hs_mezz_csi0_c*]

#CSI0_C_P on FPGA / Connector pin 2
set_property PACKAGE_PIN N2 [get_ports {hs_mezz_csi0_c[0]}]
#CSI0_C_N on FPGA / Connector pin 4
set_property PACKAGE_PIN P1 [get_ports {hs_mezz_csi0_c[1]}]

###

set_property IOSTANDARD LVCMOS12 [get_ports hs_mezz_csi0_d*]

#CSI0_D0_P on FPGA / Connector pin 8
set_property PACKAGE_PIN N5 [get_ports {hs_mezz_csi0_d[0]}]
#CSI0_D0_N on FPGA / Connector pin 10
set_property PACKAGE_PIN N4 [get_ports {hs_mezz_csi0_d[1]}]
#CSI0_D1_P on FPGA / Connector pin 14
set_property PACKAGE_PIN M2 [get_ports {hs_mezz_csi0_d[2]}]
#CSI0_D1_N on FPGA / Connector pin 16
set_property PACKAGE_PIN M1 [get_ports {hs_mezz_csi0_d[3]}]
#CSI0_D2_P on FPGA / Connector pin 20
set_property PACKAGE_PIN M5 [get_ports {hs_mezz_csi0_d[4]}]
#CSI0_D2_N on FPGA / Connector pin 22
set_property PACKAGE_PIN M4 [get_ports {hs_mezz_csi0_d[5]}]
#CSI0_D3_P on FPGA / Connector pin 26
set_property PACKAGE_PIN L2 [get_ports {hs_mezz_csi0_d[6]}]
#CSI0_D3_N on FPGA / Connector pin 28
set_property PACKAGE_PIN L1 [get_ports {hs_mezz_csi0_d[7]}]

###

set_property IOSTANDARD LVCMOS12 [get_ports hs_mezz_csi1_c*]

#CSI1_C_P on FPGA / Connector pin 54
set_property PACKAGE_PIN T3 [get_ports {hs_mezz_csi1_c[0]}]
#CSI1_C_N on FPGA / Connector pin 56
set_property PACKAGE_PIN T2 [get_ports {hs_mezz_csi1_c[1]}]

###

set_property IOSTANDARD LVCMOS12 [get_ports hs_mezz_csi1_d*]

#CSI1_D0_P on FPGA / Connector pin 42
set_property PACKAGE_PIN P3 [get_ports {hs_mezz_csi1_d[0]}]
#CSI1_D0_N on FPGA / Connector pin 44
set_property PACKAGE_PIN R3 [get_ports {hs_mezz_csi1_d[1]}]
#CSI1_D1_P on FPGA / Connector pin 48
set_property PACKAGE_PIN U2 [get_ports {hs_mezz_csi1_d[2]}]
#CSI1_D1_N on FPGA / Connector pin 50
set_property PACKAGE_PIN U1 [get_ports {hs_mezz_csi1_d[3]}]

###

set_property IOSTANDARD LVCMOS18 [get_ports hs_mezz_csi*_mclk*]

#CSI0_MCLK on FPGA / Connector pin 15
set_property PACKAGE_PIN E8 [get_ports {hs_mezz_csi0_mclk[0]}]
#CSI1_MCLK on FPGA / Connector pin 17
set_property PACKAGE_PIN D8 [get_ports {hs_mezz_csi1_mclk[0]}]

###

set_property IOSTANDARD LVCMOS12 [get_ports hs_mezz_dsi_clk*]

#DSI_CLK_P on FPGA / Connector pin 21
set_property PACKAGE_PIN J5 [get_ports {hs_mezz_dsi_clk[1]}]
#DSI_CLK_N on FPGA / Connector pin 23
set_property PACKAGE_PIN H5 [get_ports {hs_mezz_dsi_clk[0]}]

###

set_property IOSTANDARD LVCMOS12 [get_ports hs_mezz_dsi_d*]

#DSI_D0_P on FPGA / Connector pin 27
set_property PACKAGE_PIN G1 [get_ports {hs_mezz_dsi_d[0]}]
#DSI_D0_N on FPGA / Connector pin 29
set_property PACKAGE_PIN F1 [get_ports {hs_mezz_dsi_d[1]}]
#DSI_D1_P on FPGA / Connector pin 33
set_property PACKAGE_PIN E4 [get_ports {hs_mezz_dsi_d[2]}]
#DSI_D1_N on FPGA / Connector pin 35
set_property PACKAGE_PIN E3 [get_ports {hs_mezz_dsi_d[3]}]
#DSI_D2_P on FPGA / Connector pin 39
set_property PACKAGE_PIN E1 [get_ports {hs_mezz_dsi_d[4]}]
#DSI_D2_N on FPGA / Connector pin 41
set_property PACKAGE_PIN D1 [get_ports {hs_mezz_dsi_d[5]}]
#DSI_D3_P on FPGA / Connector pin 45
set_property PACKAGE_PIN D3 [get_ports {hs_mezz_dsi_d[6]}]
#DSI_D3_N on FPGA / Connector pin 47
set_property PACKAGE_PIN C3 [get_ports {hs_mezz_dsi_d[7]}]

###

set_property IOSTANDARD LVCMOS12 [get_ports {hs_mezz_hsic_str[0]}]

#HSIC_STR on FPGA / Connector pin 57
set_property PACKAGE_PIN A2 [get_ports {hs_mezz_hsic_str[0]}]

###

set_property IOSTANDARD LVCMOS12 [get_ports {hs_mezz_hsic_d[0]}]

#HSIC_DATA on FPGA / Connector pin 59
set_property PACKAGE_PIN C2 [get_ports {hs_mezz_hsic_d[0]}]


