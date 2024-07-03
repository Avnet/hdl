set_property PACKAGE_PIN F12 [get_ports {click_out_1_tri_o[0]}]; #CLICK1_RST_3V3 : HDA09
set_property PACKAGE_PIN H9 [get_ports {click_out_1_tri_o[1]}]; #CLICK1_CS0_3V3 : HDA03
set_property PACKAGE_PIN H10 [get_ports {click_out_1_tri_o[2]}]; #CLICK1_SCK_3V3 : HDA02
set_property PACKAGE_PIN G13 [get_ports {click_out_1_tri_o[3]}]; #CLICK1_MISO_3V3 : HDA01
set_property PACKAGE_PIN H13 [get_ports {click_out_1_tri_o[4]}]; #CLICK1_MOSI_3V3 : HDA00_CC
set_property PACKAGE_PIN G9 [get_ports {click_out_1_tri_o[5]}]; #CLICK1_PWM_3V3 : HDA05
set_property PACKAGE_PIN G12 [get_ports {click_out_1_tri_o[6]}]; #CLICK1_INT_3V3 : HDA08_CC
set_property PACKAGE_PIN F10 [get_ports {click_out_1_tri_o[7]}]; #CLICK1_RX_3V3 : HDA06
set_property PACKAGE_PIN F9 [get_ports {click_out_1_tri_o[8]}]; #CLICK1_TX_3V3 : HDA07
set_property IOSTANDARD LVCMOS33 [get_ports {click_out_1_tri_o[*]}];

set_property PACKAGE_PIN B9 [get_ports {click_out_2_tri_o[0]}]; #CLICK2_RST_3V3 : HDA20
set_property PACKAGE_PIN D10 [get_ports {click_out_2_tri_o[1]}]; #CLICK2_CS0_3V3 : HDA14
set_property PACKAGE_PIN E12 [get_ports {click_out_2_tri_o[2]}]; #CLICK2_SCK_3V3 : HDA13
set_property PACKAGE_PIN F13 [get_ports {click_out_2_tri_o[3]}]; #CLICK2_MISO_3V3 : HDA12
set_property PACKAGE_PIN E9 [get_ports {click_out_2_tri_o[4]}]; #CLICK2_MOSI_3V3 : HDA11
set_property PACKAGE_PIN D13 [get_ports {click_out_2_tri_o[5]}]; #CLICK2_PWM_3V3 : HDA16_CC
set_property PACKAGE_PIN B10 [get_ports {click_out_2_tri_o[6]}]; #CLICK2_INT_3V3 : HDA19
set_property PACKAGE_PIN C13 [get_ports {click_out_2_tri_o[7]}]; #CLICK2_RX_3V3 : HDA17
set_property PACKAGE_PIN C10 [get_ports {click_out_2_tri_o[8]}]; #CLICK2_TX_3V3 : HDA18
set_property IOSTANDARD LVCMOS33 [get_ports {click_out_2_tri_o[*]}];

# HSIOs - WHEN TESTING HSIO LOOPBACKS ON I/O
set_property PACKAGE_PIN L2 [get_ports {hsio_txr2_in_1_tri_i[0]}]; # HSIO-1-14 : HPA11_P
set_property PACKAGE_PIN J1 [get_ports {hsio_txr2_in_1_tri_i[1]}]; # HSIO-1-18 : HPA13_P
set_property PACKAGE_PIN F7 [get_ports {hsio_txr2_in_1_tri_i[2]}]; # HSIO-1-22 : HPA16_P
set_property PACKAGE_PIN E1 [get_ports {hsio_txr2_in_1_tri_i[3]}]; # HSIO-1-25 : HPA17_P
set_property PACKAGE_PIN C1 [get_ports {hsio_txr2_in_1_tri_i[4]}]; # HSIO-1-26 : HPA18_P
set_property PACKAGE_PIN D2 [get_ports {hsio_txr2_in_1_tri_i[5]}]; # HSIO-1-29 : HPA19_P
set_property PACKAGE_PIN V6 [get_ports {hsio_txr2_in_1_tri_i[6]}]; # HSIO-1-30 : HPA22_P
set_property PACKAGE_PIN P2 [get_ports {hsio_txr2_in_1_tri_i[7]}]; # HSIO-1-33 : HPA_CLK0_P
set_property PACKAGE_PIN H2 [get_ports {hsio_txr2_in_1_tri_i[8]}]; # HSIO-1-34 : HPA15_CC_P
set_property IOSTANDARD LVCMOS18 [get_ports {hsio_txr2_in_1_tri_i[*]}];

# HSIOs - WHEN TESTING HSIO LOOPBACKS ON I/O
set_property PACKAGE_PIN M1 [get_ports {hsio_txr2_out_1_tri_o[0]}]; # HSIO-1-16 : HPA11_N
set_property PACKAGE_PIN K1 [get_ports {hsio_txr2_out_1_tri_o[1]}]; # HSIO-1-20 : HPA13_N
set_property PACKAGE_PIN G6 [get_ports {hsio_txr2_out_1_tri_o[2]}]; # HSIO-1-24 : HPA16_N
set_property PACKAGE_PIN F1 [get_ports {hsio_txr2_out_1_tri_o[3]}]; # HSIO-1-27 : HPA17_N
set_property PACKAGE_PIN D1 [get_ports {hsio_txr2_out_1_tri_o[4]}]; # HSIO-1-28 : HPA18_N
set_property PACKAGE_PIN E2 [get_ports {hsio_txr2_out_1_tri_o[5]}]; # HSIO-1-31 : HPA19_N
set_property PACKAGE_PIN V5 [get_ports {hsio_txr2_out_1_tri_o[6]}]; # HSIO-1-32 : HPA22_N
set_property PACKAGE_PIN P1 [get_ports {hsio_txr2_out_1_tri_o[7]}]; # HSIO-1-35 : HPA_CLK0_N
set_property PACKAGE_PIN H1 [get_ports {hsio_txr2_out_1_tri_o[8]}]; # HSIO-1-36 : HPA15_CC_N
set_property IOSTANDARD LVCMOS18 [get_ports {hsio_txr2_out_1_tri_o[*]}];

# HSIOs - WHEN TESTING HSIO LOOPBACKS ON I/O
set_property PACKAGE_PIN N6 [get_ports {hsio_txr2_in_2_tri_i[0]}]; # HSIO-2-14 : HPA00_CC_P
set_property PACKAGE_PIN M7 [get_ports {hsio_txr2_in_2_tri_i[1]}]; # HSIO-2-18 : HPA02_P
set_property PACKAGE_PIN T4 [get_ports {hsio_txr2_in_2_tri_i[2]}]; # HSIO-2-22 : HPA04_P
set_property PACKAGE_PIN V4 [get_ports {hsio_txr2_in_2_tri_i[3]}]; # HSIO-2-25 : HPA06_P
set_property PACKAGE_PIN K7 [get_ports {hsio_txr2_in_2_tri_i[4]}]; # HSIO-2-26 : HPA07_P
set_property PACKAGE_PIN R1 [get_ports {hsio_txr2_in_2_tri_i[5]}]; # HSIO-2-29 : HPA08_P
set_property PACKAGE_PIN N2 [get_ports {hsio_txr2_in_2_tri_i[6]}]; # HSIO-2-30 : HPA09_P
set_property PACKAGE_PIN T2 [get_ports {hsio_txr2_in_2_tri_i[7]}]; # HSIO-2-33 : HPA05_CC_P
set_property PACKAGE_PIN K2 [get_ports {hsio_txr2_in_2_tri_i[8]}]; # HSIO-2-34 : HPA10_CC_P
set_property IOSTANDARD LVCMOS18 [get_ports {hsio_txr2_in_2_tri_i[*]}];

# HSIOs - WHEN TESTING HSIO LOOPBACKS ON I/O
set_property PACKAGE_PIN P6 [get_ports {hsio_txr2_out_2_tri_o[0]}]; # HSIO-2-16 : HPA00_CC_N
set_property PACKAGE_PIN N7 [get_ports {hsio_txr2_out_2_tri_o[1]}]; # HSIO-2-20 : HPA02_N
set_property PACKAGE_PIN U4 [get_ports {hsio_txr2_out_2_tri_o[2]}]; # HSIO-2-24 : HPA04_N
set_property PACKAGE_PIN V3 [get_ports {hsio_txr2_out_2_tri_o[3]}]; # HSIO-2-27 : HPA06_N
set_property PACKAGE_PIN K6 [get_ports {hsio_txr2_out_2_tri_o[4]}]; # HSIO-2-28 : HPA07_N
set_property PACKAGE_PIN T1 [get_ports {hsio_txr2_out_2_tri_o[5]}]; # HSIO-2-31 : HPA08_N
set_property PACKAGE_PIN N1 [get_ports {hsio_txr2_out_2_tri_o[6]}]; # HSIO-2-32 : HPA09_N
set_property PACKAGE_PIN U2 [get_ports {hsio_txr2_out_2_tri_o[7]}]; # HSIO-2-35 : HPA05_CC_N
set_property PACKAGE_PIN L1 [get_ports {hsio_txr2_out_2_tri_o[8]}]; # HSIO-2-36 : HPA10_CC_N
set_property IOSTANDARD LVCMOS18 [get_ports {hsio_txr2_out_2_tri_o[*]}];

set_property PACKAGE_PIN A4 [get_ports {pl_pmod_in_tri_i[0]}]; # HPA20_CCP_CLK
set_property PACKAGE_PIN A3 [get_ports {pl_pmod_in_tri_i[1]}]; # HPA20_CCN
set_property PACKAGE_PIN C4 [get_ports {pl_pmod_in_tri_i[2]}]; # HPA21_P
set_property PACKAGE_PIN B4 [get_ports {pl_pmod_in_tri_i[3]}]; # HPA21_N
set_property IOSTANDARD LVCMOS18 [get_ports {pl_pmod_in_tri_i[*]}];

set_property PACKAGE_PIN D4 [get_ports {pl_pmod_out_tri_o[0]}]; # HPA28
set_property IOSTANDARD LVCMOS18 [get_ports {pl_pmod_out_tri_o[0]}];

set_property PACKAGE_PIN E10 [get_ports {pl_pmod_out_tri_o[1]}]; # HDA10
set_property PACKAGE_PIN A9 [get_ports {pl_pmod_out_tri_o[2]}]; # HDA21
set_property PACKAGE_PIN A11 [get_ports {pl_pmod_out_tri_o[3]}]; # HDA22
set_property IOSTANDARD LVCMOS33 [get_ports {pl_pmod_out_tri_o[1]}];
set_property IOSTANDARD LVCMOS33 [get_ports {pl_pmod_out_tri_o[2]}];
set_property IOSTANDARD LVCMOS33 [get_ports {pl_pmod_out_tri_o[3]}];
