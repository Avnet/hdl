#
# Set I/O standards
#
set_property IOSTANDARD LVCMOS18 [get_ports {rgb_led*}]
set_property IOSTANDARD LVCMOS18 [get_ports {click*}]
set_property IOSTANDARD LVCMOS18 [get_ports {MDIO*}]
set_property IOSTANDARD LVCMOS18 [get_ports {RGMII*}]
set_property IOSTANDARD LVCMOS18 [get_ports {syzygy*}]
set_property IOSTANDARD LVCMOS18 [get_ports {temp_sensor*}]
set_property IOSTANDARD LVDS [get_ports ref_clk_clk_p]

#
# Set I/O location constraints
#
set_property PACKAGE_PIN B2 [get_ports ref_clk_clk_p]; # HP_125MHZ_P 

set_property PACKAGE_PIN H3 [get_ports {rgb_led[0]}]; # HP_GPIO_RGB_R 
set_property PACKAGE_PIN E3 [get_ports {rgb_led[1]}]; # HP_GPIO_RGB_G 
set_property PACKAGE_PIN F4 [get_ports {rgb_led[2]}]; # HP_GPIO_RGB_B 

set_property PACKAGE_PIN F8 [get_ports click_i2c_scl_io]; # HD_CLICK_SCL_1V8 
set_property PACKAGE_PIN F7 [get_ports click_i2c_sda_io]; # HD_CLICK_SDA_1V8 

set_property PACKAGE_PIN F6 [get_ports click_spi_sck_io]; # HD_CLICK_SCK_1V8 
set_property PACKAGE_PIN G7 [get_ports {click_spi_ss_io[0]}]; # HD_CLICK_CS0_1V8 
set_property PACKAGE_PIN G5 [get_ports {click_spi_ss_io[1]}]; # HD_CLICK_CS1_1V8 
set_property PACKAGE_PIN E6 [get_ports click_spi_io1_io]; # HD_CLICK_MISO_1V8 
set_property PACKAGE_PIN E5 [get_ports click_spi_io0_io]; # HD_CLICK_MOSI_1V8 

set_property PACKAGE_PIN G6 [get_ports {click_pwm_tri_io[0]}]; # HD_CLICK_PWM_1V8 

set_property PACKAGE_PIN P2 [get_ports {click_rst[0]}]; # HP_CLICK_RST_1V8 

set_property PACKAGE_PIN N3 [get_ports click_int]; # HP_CLICK_INT_1V8 

set_property PACKAGE_PIN A2 [get_ports click_uart_rxd]; # HP_CLICK_RX_1V8 
set_property PACKAGE_PIN B4 [get_ports click_uart_txd]; # HP_CLICK_TX_1V8 

set_property PACKAGE_PIN T3 [get_ports MDIO_PHY_0_mdc]; # HP_ETH_MDC 
set_property PACKAGE_PIN T2 [get_ports MDIO_PHY_0_mdio_io]; # HP_ETH_MDIO 

set_property PACKAGE_PIN K1 [get_ports {RGMII_0_rd[0]}]; # HP_ETH_RX_D0 
set_property PACKAGE_PIN J1 [get_ports {RGMII_0_rd[1]}]; # HP_ETH_RX_D1 
set_property PACKAGE_PIN J5 [get_ports {RGMII_0_rd[2]}]; # HP_ETH_RX_D2 
set_property PACKAGE_PIN H5 [get_ports {RGMII_0_rd[3]}]; # HP_ETH_RX_D3 
set_property PACKAGE_PIN K4 [get_ports RGMII_0_rxc]; HP_ETH_RX_CLK 
set_property PACKAGE_PIN K3 [get_ports RGMII_0_rx_ctl]; # HP_ETH_RX_EN 
set_property PACKAGE_PIN H4 [get_ports {RGMII_0_td[0]}]; # HP_ETH_TX_D0 
set_property PACKAGE_PIN G4 [get_ports {RGMII_0_td[1]}]; # HP_ETH_TX_D1 
set_property PACKAGE_PIN G1 [get_ports {RGMII_0_td[2]}]; # HP_ETH_TX_D2 
set_property PACKAGE_PIN F1 [get_ports {RGMII_0_td[3]}]; # HP_ETH_TX_D3 
set_property PACKAGE_PIN H2 [get_ports RGMII_0_txc]; # HP_ETH_TX_CLK 
set_property PACKAGE_PIN G2 [get_ports RGMII_0_tx_ctl]; # HP_ETH_TX_EN 

set_property PACKAGE_PIN T4 [get_ports syzygy_i2c_scl_io]; # HP_SYZYGY_SCL_1V8 
set_property PACKAGE_PIN R4 [get_ports syzygy_i2c_sda_io]; # HP_SYZYGY_SDA_1V8 

set_property PACKAGE_PIN R5 [get_ports temp_sensor_scl_io]; # HP_SENSOR_SCL_1V8 
set_property PACKAGE_PIN P5 [get_ports temp_sensor_sda_io]; # HP_SENSOR_SDA_1V8 

set_property PACKAGE_PIN T4 [get_ports syzygy_i2c_scl_io]; # HP_SYZYGY_SCL_1V8 
set_property PACKAGE_PIN R4 [get_ports syzygy_i2c_sda_io]; # HP_SYZYGY_SDA_1V8 

set_property PACKAGE_PIN R5 [get_ports temp_sensor_scl_io]; # HP_SENSOR_SCL_1V8 
set_property PACKAGE_PIN P5 [get_ports temp_sensor_sda_io]; # HP_SENSOR_SDA_1V8 

set_property PACKAGE_PIN L4 [get_ports {syzygy_trx2_mio_out_tri_o[0]}]; # HP_DP_12_GC_P  
set_property PACKAGE_PIN D5 [get_ports {syzygy_trx2_mio_out_tri_o[1]}]; # HD_DP_07_GC_P 
set_property PACKAGE_PIN L3 [get_ports {syzygy_trx2_mio_in_tri_i[0]}]; # HP_DP_12_GC_N 
set_property PACKAGE_PIN C5 [get_ports {syzygy_trx2_mio_in_tri_i[1]}]; # HD_DP_07_GC_N 

set_property PACKAGE_PIN N2 [get_ports {syzygy_trx2_pl_out_tri_o[0]}]; # HP_DP_07_QBC_P  
set_property PACKAGE_PIN M2 [get_ports {syzygy_trx2_pl_out_tri_o[1]}]; # HP_DP_09_P 
set_property PACKAGE_PIN L2 [get_ports {syzygy_trx2_pl_out_tri_o[2]}]; # HP_DP_11_GC_P 
set_property PACKAGE_PIN E1 [get_ports {syzygy_trx2_pl_out_tri_o[3]}]; # HP_DP_21_P 
set_property PACKAGE_PIN D3 [get_ports {syzygy_trx2_pl_out_tri_o[4]}]; # HP_DP_22_P 
set_property PACKAGE_PIN F3 [get_ports {syzygy_trx2_pl_out_tri_o[5]}]; # HP_DP_23_P 
set_property PACKAGE_PIN D2 [get_ports {syzygy_trx2_pl_out_tri_o[6]}]; # HP_DP_24_P 
set_property PACKAGE_PIN J3 [get_ports {syzygy_trx2_pl_out_tri_o[7]}]; # HP_DP_13_GC_P 
set_property PACKAGE_PIN A4 [get_ports {syzygy_trx2_pl_out_tri_o[8]}]; # HP_DP_12_GC_66_P 
set_property PACKAGE_PIN M4 [get_ports {syzygy_trx2_pl_out_tri_o[9]}]; # HP_DP_10_QBC_N 
set_property PACKAGE_PIN P1 [get_ports {syzygy_trx2_pl_in_tri_i[0]}]; # HP_DP_07_QBC_N 
set_property PACKAGE_PIN M1 [get_ports {syzygy_trx2_pl_in_tri_i[1]}]; # HP_DP_09_N 
set_property PACKAGE_PIN L1 [get_ports {syzygy_trx2_pl_in_tri_i[2]}]; # HP_DP_11_GC_N 
set_property PACKAGE_PIN D1 [get_ports {syzygy_trx2_pl_in_tri_i[3]}]; # HP_DP_23_N 
set_property PACKAGE_PIN C3 [get_ports {syzygy_trx2_pl_in_tri_i[4]}]; # HP_DP_22_N 
set_property PACKAGE_PIN F2 [get_ports {syzygy_trx2_pl_in_tri_i[5]}]; # HP_DP_23_N 
set_property PACKAGE_PIN C2 [get_ports {syzygy_trx2_pl_in_tri_i[6]}]; # HP_DP_24_N 
set_property PACKAGE_PIN J2 [get_ports {syzygy_trx2_pl_in_tri_i[7]}]; # HP_DP_13_GC_N 
set_property PACKAGE_PIN A3 [get_ports {syzygy_trx2_pl_in_tri_i[8]}]; # HP_DP_12_GC_66_N 
set_property PACKAGE_PIN N5 [get_ports {syzygy_trx2_pl_in_tri_i[9]}]; # HP_DP_08_P 
set_property PACKAGE_PIN N4 [get_ports {syzygy_trx2_pl_in_tri_i[10]}]; # HP_DP_08_N 
set_property PACKAGE_PIN M5 [get_ports {syzygy_trx2_pl_in_tri_i[11]}]; # HP_DP_10_QBC_P 

set_property PACKAGE_PIN B6 [get_ports {syzygy_std_out_tri_o[0]}]; # HD_DP_11_P 
set_property PACKAGE_PIN B9 [get_ports {syzygy_std_out_tri_o[1]}]; # HD_DP_09_P 
set_property PACKAGE_PIN C8 [get_ports {syzygy_std_out_tri_o[2]}]; # HD_DP_08_GC_P 
set_property PACKAGE_PIN P3 [get_ports {syzygy_std_out_tri_o[3]}]; # HP_DP_02_P 
set_property PACKAGE_PIN U2 [get_ports {syzygy_std_out_tri_o[4]}]; # HP_DP_03_P 
set_property PACKAGE_PIN R1 [get_ports {syzygy_std_out_tri_o[5]}]; # HP_DP_05_P 
set_property PACKAGE_PIN E8 [get_ports {syzygy_std_out_tri_o[6]}]; # HD_DP_06_GC_P 
set_property PACKAGE_PIN D7 [get_ports {syzygy_std_out_tri_o[7]}]; # HD_DP_05_GC_P 
set_property PACKAGE_PIN A7 [get_ports {syzygy_std_out_tri_o[8]}]; # HD_DP_10_N 
set_property PACKAGE_PIN B5 [get_ports {syzygy_std_in_tri_i[0]}]; # HD_DP_11_N 
set_property PACKAGE_PIN A9 [get_ports {syzygy_std_in_tri_i[1]}]; # HD_DP_09_N 
set_property PACKAGE_PIN C7 [get_ports {syzygy_std_in_tri_i[2]}]; # HD_DP_08_GC_N 
set_property PACKAGE_PIN R3 [get_ports {syzygy_std_in_tri_i[3]}]; # HP_DP_02_N 
set_property PACKAGE_PIN U1 [get_ports {syzygy_std_in_tri_i[4]}]; # HP_DP_03_N 
set_property PACKAGE_PIN T1 [get_ports {syzygy_std_in_tri_i[5]}]; # HP_DP_05_N 
set_property PACKAGE_PIN D8 [get_ports {syzygy_std_in_tri_i[6]}]; # HD_DP_06_GC_N 
set_property PACKAGE_PIN D6 [get_ports {syzygy_std_in_tri_i[7]}]; # HD_DP_05_GC_N 
set_property PACKAGE_PIN B7 [get_ports {syzygy_std_in_tri_i[8]}]; # HD_DP_12_P 
set_property PACKAGE_PIN A6 [get_ports {syzygy_std_in_tri_i[9]}]; # HD_DP_12_N 
set_property PACKAGE_PIN A8 [get_ports {syzygy_std_in_tri_i[10]}]; # HD_DP_10_P 

# Enable internal termination resistor on LVDS 125MHz ref_clk
set_property DIFF_TERM_ADV TERM_100 [get_ports ref_clk_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports ref_clk_clk_n]

# Since Vivado 2019.2, when we connect a GEM MDIO interface to EMIO, this sets parameter PSU__ENET0__GRP_MDIO_INTERNAL to 1
# (see file "<vivado-path>\2019.2\data\PS\8series\data\zynqconfig\enet\enet0_preset.xml")
# which in turn enables a new create_clock constraint for the MDIO clock output
# (see file "<vivad-path>\2019.2\data\PS\8series\data\zynqconfig\code\ucfgen.xml").
# The name of the clock is mdioX_mdc_clock and the frequency is specified by parameter PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ.
# The constraint is added to this automatically generated file:
# "<prj_name>\<prj_name>.srcs\sources_1\bd\<prj_name>\ip\<prj_name>_zynq_ultra_ps_e_0_0\<prj_name>_zynq_ultra_ps_e_0_0.xdc"
# The new clock causes Vivado to analyze some non-critical paths that it was not analyzing before, and it has difficulty achieving timing closure.
# To prevent this problem, we declare false path from Clock wizard's 375MHz clock to the Zynq PS GEM's MDIO clock output
set_false_path -from [get_clocks clk_out1_xbzu1_sbc_valtest_clk_wiz_0_0] -to [get_clocks mdio3_mdc_clock]

# Create the clocks for the RGMII RX CLK inputs
create_clock -period 8.000 -name RGMII_0_rx_clk -waveform {0.000 4.000} [get_ports RGMII_0_rxc]


