#
# Set I/O standards
#
set_property IOSTANDARD LVCMOS18 [get_ports {pl_pb*}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgb_led*}]
set_property IOSTANDARD LVCMOS18 [get_ports {click*}]
set_property IOSTANDARD LVCMOS18 [get_ports {syzygydna*}]
set_property IOSTANDARD LVCMOS18 [get_ports {tempsensor*}]
set_property IOSTANDARD LVCMOS18 [get_ports {szg*}]

#
# Set I/O location constraints
#
set_property PACKAGE_PIN A8 [get_ports pl_pb_tri_i ]; # HD_GPIO_PB1 

set_property PACKAGE_PIN A7 [get_ports {rgb_led_0_tri_o[0]}]; # HD_GPIO_RGB1_R 
set_property PACKAGE_PIN B6 [get_ports {rgb_led_0_tri_o[1]}]; # HD_GPIO_RGB1_G 
set_property PACKAGE_PIN B5 [get_ports {rgb_led_0_tri_o[2]}]; # HD_GPIO_RGB1_B 

set_property PACKAGE_PIN B4 [get_ports {rgb_led_1_tri_o[0]}]; # HP_GPIO_RGB2_R 
set_property PACKAGE_PIN A2 [get_ports {rgb_led_1_tri_o[1]}]; # HP_GPIO_RGB2_G 
set_property PACKAGE_PIN F4 [get_ports {rgb_led_1_tri_o[2]}]; # HP_GPIO_RGB2_B 

# SYZYGY TRX2 MIO loopback OUTPUTS
set_property PACKAGE_PIN C8 [get_ports {szg_trx2_mio_lb_out_tri_o[0]}]; # HD_DP_08_GC_P  J2.34
set_property PACKAGE_PIN D5 [get_ports {szg_trx2_mio_lb_out_tri_o[1]}]; # HD_DP_07_GC_P  J2.33

# SYZYGY TRX2 MIO loopback INPUTS
set_property PACKAGE_PIN C7 [get_ports {szg_trx2_mio_lb_in_tri_i[0]}]; # HD_DP_08_GC_N  J2.36
set_property PACKAGE_PIN C5 [get_ports {szg_trx2_mio_lb_in_tri_i[1]}]; # HD_DP_07_GC_N  J2.35

# SYZYGY TRX2 PL loopback OUTPUTS
set_property PACKAGE_PIN P5 [get_ports {szg_trx2_pl_lb_out_tri_o[0]}]; # HP_DP_06_P  J1.25
set_property PACKAGE_PIN K1 [get_ports {szg_trx2_pl_lb_out_tri_o[1]}]; # HP_DP_15_P  J1.29
set_property PACKAGE_PIN B2 [get_ports {szg_trx2_pl_lb_out_tri_o[2]}]; # HP_DP_11_GC_66_P  J1.33
set_property PACKAGE_PIN T3 [get_ports {szg_trx2_pl_lb_out_tri_o[3]}]; # HP_DP_01_DBC_P  J1.14
set_property PACKAGE_PIN U2 [get_ports {szg_trx2_pl_lb_out_tri_o[4]}]; # HP_DP_03_P  J1.18
set_property PACKAGE_PIN R1 [get_ports {szg_trx2_pl_lb_out_tri_o[5]}]; # HP_DP_05_P  J1.22
set_property PACKAGE_PIN K4 [get_ports {szg_trx2_pl_lb_out_tri_o[6]}]; # HP_DP_14_GC_P  J1.26
set_property PACKAGE_PIN D2 [get_ports {szg_trx2_pl_lb_out_tri_o[7]}]; # HP_DP_24_P  J1.30
set_property PACKAGE_PIN A4 [get_ports {szg_trx2_pl_lb_out_tri_o[8]}]; # HP_DP_12_GC_66_P  J1.34

# SYZYGY TRX2 PL loopback INPUTS
set_property PACKAGE_PIN R5 [get_ports {szg_trx2_pl_lb_in_tri_i[0]}]; # HP_DP_06_N  J1.27
set_property PACKAGE_PIN J1 [get_ports {szg_trx2_pl_lb_in_tri_i[1]}]; # HP_DP_15_N  J1.31
set_property PACKAGE_PIN B1 [get_ports {szg_trx2_pl_lb_in_tri_i[2]}]; # HP_DP_11_GC_66_N  J1.35
set_property PACKAGE_PIN T2 [get_ports {szg_trx2_pl_lb_in_tri_i[3]}]; # HP_DP_01_DBC_N  J1.16
set_property PACKAGE_PIN U1 [get_ports {szg_trx2_pl_lb_in_tri_i[4]}]; # HP_DP_03_N  J1.20
set_property PACKAGE_PIN T1 [get_ports {szg_trx2_pl_lb_in_tri_i[5]}]; # HP_DP_05_N  J1.24
set_property PACKAGE_PIN K3 [get_ports {szg_trx2_pl_lb_in_tri_i[6]}]; # HP_DP_14_GC_N  J1.28
set_property PACKAGE_PIN C2 [get_ports {szg_trx2_pl_lb_in_tri_i[7]}]; # HP_DP_24_N  J1.32
set_property PACKAGE_PIN A3 [get_ports {szg_trx2_pl_lb_in_tri_i[8]}]; # HP_DP_12_GC_66_N  J1.36

# SYZYGY TRX2 PL power
set_property PACKAGE_PIN T4 [get_ports {szg_trx2_pl_pwr_out_tri_o[0]}]; # HP_DP_04_N  J1.23  TEST_MODE_0  (AVR #PA7)
set_property PACKAGE_PIN R4 [get_ports {szg_trx2_pl_pwr_in_tri_i[0]}]; # HP_DP_04_P  J1.21  TEST_MODE_1  (AVR #PB2)
set_property PACKAGE_PIN R3 [get_ports {szg_trx2_pl_pwr_in_tri_i[1]}]; # HP_DP_02_N  J1.19  TEST_MODE_2  (AVR #PB1)
set_property PACKAGE_PIN P3 [get_ports {szg_trx2_pl_pwr_in_tri_i[2]}]; # HP_DP_02_P  J1.17  TEST_MODE_3  (AVR #PB0)
 
# SYZYGY STD loopback OUTPUTS
set_property PACKAGE_PIN J5 [get_ports {szg_std_lb_out_tri_o[0]}]; # HP_DP_16_QBC_P  J6.13
set_property PACKAGE_PIN G1 [get_ports {szg_std_lb_out_tri_o[1]}]; # HP_DP_19_DBC_P  J6.17
set_property PACKAGE_PIN E4 [get_ports {szg_std_lb_out_tri_o[2]}]; # HP_DP_20_P  J6.21
set_property PACKAGE_PIN E1 [get_ports {szg_std_lb_out_tri_o[3]}]; # HP_DP_21_P  J6.25
set_property PACKAGE_PIN D3 [get_ports {szg_std_lb_out_tri_o[4]}]; # HP_DP_22_P  J6.29
set_property PACKAGE_PIN L4 [get_ports {szg_std_lb_out_tri_o[5]}]; # HP_DP_12_GC_P  J6.33
set_property PACKAGE_PIN N2 [get_ports {szg_std_lb_out_tri_o[6]}]; # HP_DP_07_QBC_P  J6.6
set_property PACKAGE_PIN N5 [get_ports {szg_std_lb_out_tri_o[7]}]; # HP_DP_08_P  J6.10
set_property PACKAGE_PIN M2 [get_ports {szg_std_lb_out_tri_o[8]}]; # HP_DP_09_P  J6.14
set_property PACKAGE_PIN M5 [get_ports {szg_std_lb_out_tri_o[9]}]; # HP_DP_10_QBC_P  J6.18
set_property PACKAGE_PIN L2 [get_ports {szg_std_lb_out_tri_o[10]}]; # HP_DP_11_GC_P  J6.22
set_property PACKAGE_PIN F3 [get_ports {szg_std_lb_out_tri_o[11]}]; # HP_DP_23_P  J6.26
set_property PACKAGE_PIN N3 [get_ports {szg_std_lb_out_tri_o[12]}]; # HP_SE_01  J6.30
set_property PACKAGE_PIN J3 [get_ports {szg_std_lb_out_tri_o[13]}]; # HP_DP_13_GC_P  J6.34

# SYZYGY STD loopback INPUTS
set_property PACKAGE_PIN H5 [get_ports {szg_std_lb_in_tri_i[0]}]; # HP_DP_16_QBC_N  J6.15
set_property PACKAGE_PIN F1 [get_ports {szg_std_lb_in_tri_i[1]}]; # HP_DP_19_DBC_N  J6.19
set_property PACKAGE_PIN E3 [get_ports {szg_std_lb_in_tri_i[2]}]; # HP_DP_20_N  J6.23
set_property PACKAGE_PIN D1 [get_ports {szg_std_lb_in_tri_i[3]}]; # HP_DP_21_N  J6.27
set_property PACKAGE_PIN C3 [get_ports {szg_std_lb_in_tri_i[4]}]; # HP_DP_22_N  J6.31
set_property PACKAGE_PIN L3 [get_ports {szg_std_lb_in_tri_i[5]}]; # HP_DP_12_GC_N  J6.35
set_property PACKAGE_PIN P1 [get_ports {szg_std_lb_in_tri_i[6]}]; # HP_DP_07_QBC_N  J6.8
set_property PACKAGE_PIN N4 [get_ports {szg_std_lb_in_tri_i[7]}]; # HP_DP_08_N  J6.12
set_property PACKAGE_PIN M1 [get_ports {szg_std_lb_in_tri_i[8]}]; # HP_DP_09_N  J6.16
set_property PACKAGE_PIN M4 [get_ports {szg_std_lb_in_tri_i[9]}]; # HP_DP_10_QBC_N  J6.20
set_property PACKAGE_PIN L1 [get_ports {szg_std_lb_in_tri_i[10]}]; # HP_DP_11_GC_N  J6.24
set_property PACKAGE_PIN F2 [get_ports {szg_std_lb_in_tri_i[11]}]; # HP_DP_23_N  J6.28
set_property PACKAGE_PIN H3 [get_ports {szg_std_lb_in_tri_i[12]}]; # HP_SE_01  J6.32
set_property PACKAGE_PIN J2 [get_ports {szg_std_lb_in_tri_i[13]}]; # HP_DP_13_GC_N  J6.36

# SYZYGY STD power
set_property PACKAGE_PIN G4 [get_ports {szg_std_pwr_out_tri_o[0]}]; # HP_DP_18_N  J6.11  TEST_MODE_0  (AVR #PA7)
set_property PACKAGE_PIN H4 [get_ports {szg_std_pwr_in_tri_i[0]}]; # HP_DP_18_P  J6.9  TEST_MODE_1  (AVR #PB2)
set_property PACKAGE_PIN G2 [get_ports {szg_std_pwr_in_tri_i[1]}]; # HP_DP_17_N  J6.7  TEST_MODE_2  (AVR #PB1)
set_property PACKAGE_PIN H2 [get_ports {szg_std_pwr_in_tri_i[2]}]; # HP_DP_17_P  J6.5  TEST_MODE_3  (AVR #PB0)
