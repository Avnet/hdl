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

#######################################################################
# Ultra96 Dual Camera Mezzanine
#######################################################################
set_property PACKAGE_PIN A7 [get_ports {TRG_INPUT[0]}]
set_property PACKAGE_PIN A6 [get_ports {ICP3_I2C_ID_SELECT[0]}]
set_property PACKAGE_PIN G6 [get_ports {SP3[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {ICP3_I2C_ID_SELECT[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {SP3[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {TRG_INPUT[0]}]
set_property PACKAGE_PIN E8 [get_ports CLK48M]
set_property IOSTANDARD LVCMOS18 [get_ports CLK48M]
#set_false_path -from [get_clocks -of_objects [get_pins u96v2_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins {u96v2_sbc_dualcam_i/mipi_csi2_rx_subsyst_0/inst/phy/inst/inst/bd_d10d_phy_0_rx_support_i/slave_rx.bd_d10d_phy_0_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[13].rx_bitslice_if_bs/FIFO_WRCLK_OUT}]]
#set_false_path -from [get_clocks -of_objects [get_pins u96v2_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins u96v2_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]]
set_false_path -from [get_clocks -of_objects [get_pins u96v2_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins {u96v2_sbc_dualcam_i/mipi_csi2_rx_subsyst_0/inst/phy/inst/inst/bd_d10d_phy_0_rx_support_i/slave_rx.bd_d10d_phy_0_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[13].rx_bitslice_if_bs/FIFO_WRCLK_OUT}]]
set_false_path -from [get_clocks -of_objects [get_pins u96v2_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins u96v2_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]]
set_false_path -from [get_clocks -of_objects [get_pins u96v2_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins u96v2_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT4]]
# machine generated below
#set_false_path -from [get_clocks -of_objects [get_pins ultra96v2_dualcam_i/clk_wiz/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins ultra96v2_dualcam_i/clk_wiz/inst/mmcme4_adv_inst/CLKOUT2]]
