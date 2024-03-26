#
# Set I/O location constraints
#
set_property PACKAGE_PIN B9 [get_ports hsio_i2c_scl_io]; # HD_HSIO_SCL_1V8
set_property PACKAGE_PIN A9 [get_ports hsio_i2c_sda_io]; # HD_HSIO_SDA_1V8

#
# Set I/O standards
#
set_property IOSTANDARD LVCMOS18 [get_ports hsio*]
set_property DRIVE 12 [get_ports hsio*]

#######################################################################
# PS UART1 modem signals (M.2 HSIO Bluetooth)
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports emio_uart1*]
set_property PACKAGE_PIN C5 [get_ports emio_uart1_ctsn]
set_property PACKAGE_PIN D5 [get_ports emio_uart1_rtsn]

#######################################################################
# DisplayPort HPD & AUX
#######################################################################
set_property IOSTANDARD LVCMOS12 [get_ports {dp_hot_plug_detect*}]
set_property IOSTANDARD LVCMOS12 [get_ports {dp_aux_data*}]
set_property PACKAGE_PIN K1 [get_ports dp_aux_data_out ]; # HP_DP_15_P
set_property PACKAGE_PIN J1 [get_ports dp_hot_plug_detect ]; # HP_DP_15_N
set_property PACKAGE_PIN D2 [get_ports dp_aux_data_oe ]; # HP_DP_24_P
set_property PACKAGE_PIN C2 [get_ports dp_aux_data_in ]; # HP_DP_24_N

#######################################################################
# Dual Camera High Speed I/O
#######################################################################
#
# ISP GPIO & clock
#
set_property PACKAGE_PIN J2 [get_ports {trigger[0]}]; # HP_DP_13_GC_N
set_property PACKAGE_PIN J3 [get_ports {icp3_i2c_id_select[0]}]; # HP_DP_13_GC_P
set_property PACKAGE_PIN N3 [get_ports {sp3[0]}]; # HP_SE_01
set_property PACKAGE_PIN L3 [get_ports clk48m]; # HP_DP_12_GC_N
set_property PACKAGE_PIN C3 [get_ports {rst[0]}]; # HP_DP_22_N
set_property PACKAGE_PIN L4 [get_ports {stby[0]}]; # HP_DP_12_GC_P

set_property IOSTANDARD LVCMOS12 [get_ports {icp3_i2c_id_select[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {sp3[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {trigger[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports clk48m]
set_property IOSTANDARD LVCMOS12 [get_ports {rst[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {stby[0]}]

set_property DRIVE 8 [get_ports {icp3_i2c_id_select[0]}]
set_property DRIVE 8 [get_ports {sp3[0]}]
set_property DRIVE 8 [get_ports {trigger[0]}]
set_property DRIVE 8 [get_ports clk48m]
set_property DRIVE 8 [get_ports {rst[0]}]
set_property DRIVE 8 [get_ports {stby[0]}]

#
# ISP I2C & SPI
#
set_property PACKAGE_PIN F3 [get_ports ap1302_isp_i2c_scl_io]; # HP_DP_23_P
set_property PACKAGE_PIN F2 [get_ports ap1302_isp_i2c_sda_io]; # HP_DP_23_N
set_property PACKAGE_PIN H2 [get_ports ap1302_isp_spi_io0_io]; # HP_DP_17_P
set_property PACKAGE_PIN G4 [get_ports ap1302_isp_spi_io1_io]; # HP_DP_18_N
set_property PACKAGE_PIN H4 [get_ports ap1302_isp_spi_sck_io]; # HP_DP_18_P 
set_property PACKAGE_PIN G2 [get_ports ap1302_isp_spi_ss_io]; # HP_DP_17_N

set_property IOSTANDARD LVCMOS12 [get_ports ap1302_isp*]
set_property DRIVE 8 [get_ports ap1302_isp*]

#
# Timing paths & constraints
#
#set_false_path -from [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins {zub1cg_sbc_dualcam_i/mipi_csi2_rx_subsyst_0/inst/phy/inst/inst/bd_d10d_phy_0_rx_support_i/slave_rx.bd_d10d_phy_0_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[13].rx_bitslice_if_bs/FIFO_WRCLK_OUT}]]
#set_false_path -from [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]]
set_false_path -from [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins {zub1cg_sbc_dualcam_i/mipi_csi2_rx_subsyst_0/inst/phy/inst/inst/bd_d10d_phy_0_rx_support_i/slave_rx.bd_d10d_phy_0_rx_hssio_i/inst/top_inst/bs_top_inst/u_rx_bs/RX_BS[13].rx_bitslice_if_bs/FIFO_WRCLK_OUT}]]
set_false_path -from [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]]
set_false_path -from [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT3]] -to [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT4]]
# machine generated below
#set_false_path -from [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks -of_objects [get_pins zub1cg_sbc_dualcam_i/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT2]]

