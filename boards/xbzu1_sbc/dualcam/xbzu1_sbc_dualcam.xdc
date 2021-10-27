#
# Set I/O standards
#
set_property IOSTANDARD LVCMOS18 [get_ports rgb_led*]
set_property IOSTANDARD LVCMOS18 [get_ports {click*}]
set_property IOSTANDARD LVCMOS18 [get_ports click*]
set_property IOSTANDARD LVCMOS18 [get_ports syzygy*]
set_property IOSTANDARD LVCMOS18 [get_ports temp_sensor*]

set_property DRIVE 12 [get_ports syzygy*]
set_property DRIVE 12 [get_ports temp_sensor*]

#
# Set I/O location constraints
#
set_property PACKAGE_PIN A7 [get_ports {rgb_led[0]}]; # HD_GPIO_RGB_R
set_property PACKAGE_PIN B6 [get_ports {rgb_led[1]}]; # HD_GPIO_RGB_G
set_property PACKAGE_PIN B5 [get_ports {rgb_led[2]}]; # HD_GPIO_RGB_B

set_property PACKAGE_PIN F8 [get_ports click_i2c_scl_io]; # HD_CLICK_SCL_1V8
set_property PACKAGE_PIN F7 [get_ports click_i2c_sda_io]; # HD_CLICK_SDA_1V8

set_property PACKAGE_PIN F6 [get_ports click_spi_sck_io]; # HD_CLICK_SCK_1V8
set_property PACKAGE_PIN G7 [get_ports {click_spi_ss_io[0]}]; # HD_CLICK_CS0_1V8
set_property PACKAGE_PIN G5 [get_ports {click_spi_ss_io[1]}]; # HD_CLICK_CS1_AN_1V8
set_property PACKAGE_PIN E6 [get_ports click_spi_io1_io]; # HD_CLICK_MISO_1V8
set_property PACKAGE_PIN E5 [get_ports click_spi_io0_io]; # HD_CLICK_MOSI_1V8

set_property PACKAGE_PIN G6 [get_ports {click_pwm_tri_io[0]}]; # HD_CLICK_PWM_1V8

set_property PACKAGE_PIN D8 [get_ports {click_rst[0]}]; # HD_CLICK_RST_1V8

set_property PACKAGE_PIN E8 [get_ports click_int]; # HD_CLICK_INT_1V8

set_property PACKAGE_PIN D7 [get_ports click_uart_rxd]; # HD_CLICK_RX_1V8
set_property PACKAGE_PIN D6 [get_ports click_uart_txd]; # HD_CLICK_TX_1V8

set_property PACKAGE_PIN B9 [get_ports syzygy_i2c_scl_io]; # HD_SYZYGY_SCL_1V8
set_property PACKAGE_PIN A9 [get_ports syzygy_i2c_sda_io]; # HD_SYZYGY_SDA_1V8

set_property PACKAGE_PIN A6 [get_ports temp_sensor_scl_io]; # HD_SENSOR_I2C_SCL
set_property PACKAGE_PIN B7 [get_ports temp_sensor_sda_io]; # HD_SENSOR_I2C_SDA


#######################################################################
# XBoard-ZU1 Dual Camera SYZYGY Pod
#######################################################################
set_property PACKAGE_PIN J2 [get_ports {trigger[0]}]; # HP_DP_13_GC_N
set_property PACKAGE_PIN J3 [get_ports {icp3_i2c_id_select[0]}]; # HP_DP_13_GC_P
set_property PACKAGE_PIN N3 [get_ports {sp3[0]}]; # HP_SE_01
set_property PACKAGE_PIN L3 [get_ports clk48m]; # HP_DP_12_GC_N

set_property IOSTANDARD LVCMOS12 [get_ports {icp3_i2c_id_select[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {sp3[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {trigger[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports clk48m]

#set_false_path -from [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins {xbzu1_sbc_dualcam_i/mipi_csi2_rx_subsyst_0/inst/phy/inst/inst/bd_d10d_phy_0_rx_support_i/slave_rx.bd_d10d_phy_0_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[13].rx_bitslice_if_bs/FIFO_WRCLK_OUT}]]
#set_false_path -from [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]]
set_false_path -from [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins {xbzu1_sbc_dualcam_i/mipi_csi2_rx_subsyst_0/inst/phy/inst/inst/bd_d10d_phy_0_rx_support_i/slave_rx.bd_d10d_phy_0_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[13].rx_bitslice_if_bs/FIFO_WRCLK_OUT}]]
set_false_path -from [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]]
set_false_path -from [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT4]]
# machine generated below
#set_false_path -from [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins xbzu1_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT2]]

