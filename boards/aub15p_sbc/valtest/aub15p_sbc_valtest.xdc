#
# Set I/O standards
#
set_property IOSTANDARD LVCMOS18 [get_ports {fmc*}]

#
# Set I/O location constraints
#
# FMC Row C GPIO loopback.  Out on the '_P' and in on the '_N'
set_property PACKAGE_PIN D26 [get_ports {fmc_c_o_tri_o[0]}]; # HP_DP_23_P  LA06_P  C10
set_property PACKAGE_PIN E25 [get_ports {fmc_c_o_tri_o[1]}]; # HP_DP_19_P  LA10_P  C14
set_property PACKAGE_PIN L20 [get_ports {fmc_c_o_tri_o[2]}]; # HP_DP_06_P  LA14_P  C18
set_property PACKAGE_PIN G24 [get_ports {fmc_c_o_tri_o[3]}]; # HP_DP_13_GC_P  LA18_P  C22
set_property PACKAGE_PIN J15 [get_ports {fmc_c_o_tri_o[4]}]; # HD_DP_04_P  LA27_P  C26

set_property PACKAGE_PIN C26 [get_ports {fmc_c_i_tri_i[0]}]; # HP_DP_23_N  LA06_N  C11
set_property PACKAGE_PIN E26 [get_ports {fmc_c_i_tri_i[1]}]; # HP_DP_19_N  LA10_N  C15
set_property PACKAGE_PIN K20 [get_ports {fmc_c_i_tri_i[2]}]; # HP_DP_06_N  LA14_N  C19
set_property PACKAGE_PIN G25 [get_ports {fmc_c_i_tri_i[3]}]; # HP_DP_13_GC_N  LA18_N  C23
set_property PACKAGE_PIN J14 [get_ports {fmc_c_i_tri_i[4]}]; # HD_DP_04_N  LA27_N  C27

# FMC Row D GPIO loopback.  Out on the '_P' and in on the '_N'
set_property PACKAGE_PIN J23 [get_ports {fmc_d_o_tri_o[0]}]; # HP_DP_12_GC_P  LA01_P_CC  D8
set_property PACKAGE_PIN M19 [get_ports {fmc_d_o_tri_o[1]}]; # HP_DP_04_P  LA05_P  D11
set_property PACKAGE_PIN H21 [get_ports {fmc_d_o_tri_o[2]}]; # HP_DP_18_P  LA09_P  D14
set_property PACKAGE_PIN K22 [get_ports {fmc_d_o_tri_o[3]}]; # HP_DP_11_GC_P  LA13_P  D17
set_property PACKAGE_PIN J25 [get_ports {fmc_d_o_tri_o[4]}]; # HP_DP_15_P  LA17_P_CC  D20
set_property PACKAGE_PIN B25 [get_ports {fmc_d_o_tri_o[5]}]; # HP_DP_24_P  LA23_P  D23
set_property PACKAGE_PIN L22 [get_ports {fmc_d_o_tri_o[6]}]; # HP_DP_07_P  LA26_P  D26

set_property PACKAGE_PIN J24 [get_ports {fmc_d_i_tri_i[0]}]; # HP_DP_12_GC_N  LA01_N_CC  D9
set_property PACKAGE_PIN L19 [get_ports {fmc_d_i_tri_i[1]}]; # HP_DP_04_N  LA05_N  D12
set_property PACKAGE_PIN H22 [get_ports {fmc_d_i_tri_i[2]}]; # HP_DP_18_N  LA09_N  D15
set_property PACKAGE_PIN K23 [get_ports {fmc_d_i_tri_i[3]}]; # HP_DP_11_GC_N  LA13_N  D18
set_property PACKAGE_PIN J26 [get_ports {fmc_d_i_tri_i[4]}]; # HP_DP_15_N  LA17_N_CC  D21
set_property PACKAGE_PIN B26 [get_ports {fmc_d_i_tri_i[5]}]; # HP_DP_24_N  LA23_N  D24
set_property PACKAGE_PIN L23 [get_ports {fmc_d_i_tri_i[6]}]; # HP_DP_07_N  LA26_N  D27

# FMC Row G GPIO loopback.  Out on the '_P' and in on the '_N'
set_property PACKAGE_PIN F14 [get_ports {fmc_g_o_tri_o[0]}]; # HD_DP_06_GC_P  CLK0_M2C_P  G2
set_property PACKAGE_PIN F24 [get_ports {fmc_g_o_tri_o[1]}]; # HP_DP_16_P  LA00_P_CC  G6
set_property PACKAGE_PIN M20 [get_ports {fmc_g_o_tri_o[2]}]; # HP_DP_02_P  LA03_P  G9
set_property PACKAGE_PIN K25 [get_ports {fmc_g_o_tri_o[3]}]; # HP_DP_09_P  LA08_P  G12
set_property PACKAGE_PIN L18 [get_ports {fmc_g_o_tri_o[4]}]; # HP_DP_01_P  LA12_P  G15
set_property PACKAGE_PIN L24 [get_ports {fmc_g_o_tri_o[5]}]; # HP_DP_10_P  LA16_P  G18
set_property PACKAGE_PIN D24 [get_ports {fmc_g_o_tri_o[6]}]; # HP_DP_21_P  LA20_P  G21
set_property PACKAGE_PIN B14 [get_ports {fmc_g_o_tri_o[7]}]; # HD_DP_12_P  LA22_P  G24
set_property PACKAGE_PIN J13 [get_ports {fmc_g_o_tri_o[8]}]; # HD_DP_02_P  LA25_P  G27
set_property PACKAGE_PIN D14 [get_ports {fmc_g_o_tri_o[9]}]; # HD_DP_08_GC_P  LA29_P  G30
set_property PACKAGE_PIN C12 [get_ports {fmc_g_o_tri_o[10]}]; # HD_DP_10_P  LA31_P  G33
set_property PACKAGE_PIN M25 [get_ports {fmc_g_o_tri_o[11]}]; # HP_DP_08_P  LA33_P  G36

set_property PACKAGE_PIN F13 [get_ports {fmc_g_i_tri_i[0]}]; # HD_DP_06_GC_N  CLK0_M2C_N  G3
set_property PACKAGE_PIN F25 [get_ports {fmc_g_i_tri_i[1]}]; # HP_DP_16_N  LA00_N_CC  G7
set_property PACKAGE_PIN M21 [get_ports {fmc_g_i_tri_i[2]}]; # HP_DP_02_N  LA03_N  G10
set_property PACKAGE_PIN K26 [get_ports {fmc_g_i_tri_i[3]}]; # HP_DP_09_N  LA08_N  G13
set_property PACKAGE_PIN K18 [get_ports {fmc_g_i_tri_i[4]}]; # HP_DP_01_N  LA12_N  G16
set_property PACKAGE_PIN L25 [get_ports {fmc_g_i_tri_i[5]}]; # HP_DP_10_N  LA16_N  G19
set_property PACKAGE_PIN D25 [get_ports {fmc_g_i_tri_i[6]}]; # HP_DP_21_N  LA20_N  G22
set_property PACKAGE_PIN A14 [get_ports {fmc_g_i_tri_i[7]}]; # HD_DP_12_N  LA22_N  G25
set_property PACKAGE_PIN H13 [get_ports {fmc_g_i_tri_i[8]}]; # HD_DP_02_N  LA25_N  G28
set_property PACKAGE_PIN D13 [get_ports {fmc_g_i_tri_i[9]}]; # HD_DP_08_GC_N  LA29_N  G31
set_property PACKAGE_PIN B12 [get_ports {fmc_g_i_tri_i[10]}]; # HD_DP_10_N  LA31_N  G34
set_property PACKAGE_PIN M26 [get_ports {fmc_g_i_tri_i[11]}]; # HP_DP_08_N  LA33_N  G37

# FMC Row H GPIO loopback.  Out on the '_P' and in on the '_N'
set_property PACKAGE_PIN G12 [get_ports {fmc_h_o_tri_o[0]}]; # HD_DP_05_GC_P  CLK0_M2C_P  H4
set_property PACKAGE_PIN H26 [get_ports {fmc_h_o_tri_o[1]}]; # HP_DP_17_P  LA02_P  H7
set_property PACKAGE_PIN J19 [get_ports {fmc_h_o_tri_o[2]}]; # HP_DP_03_P  LA04_P  H10
set_property PACKAGE_PIN J12 [get_ports {fmc_h_o_tri_o[3]}]; # HD_DP_01_P  LA07_P  H13
set_property PACKAGE_PIN E13 [get_ports {fmc_h_o_tri_o[4]}]; # HD_DP_07_GC_P  LA11_P  H16
set_property PACKAGE_PIN K21 [get_ports {fmc_h_o_tri_o[5]}]; # HP_DP_05_P  LA15_P  H19
set_property PACKAGE_PIN F23 [get_ports {fmc_h_o_tri_o[6]}]; # HP_DP_20_P  LA19_P  H22
set_property PACKAGE_PIN D23 [get_ports {fmc_h_o_tri_o[7]}]; # HP_DP_22_P  LA21_P  H25
set_property PACKAGE_PIN H23 [get_ports {fmc_h_o_tri_o[8]}]; # HP_DP_14_GC_P  LA24_P  H28
set_property PACKAGE_PIN H14 [get_ports {fmc_h_o_tri_o[9]}]; # HD_DP_03_P  LA28_P  H31
set_property PACKAGE_PIN C14 [get_ports {fmc_h_o_tri_o[10]}]; # HD_DP_09_P  LA30_P  H34
set_property PACKAGE_PIN A13 [get_ports {fmc_h_o_tri_o[11]}]; # HD_DP_11_P  LA32_P  H37

set_property PACKAGE_PIN F12 [get_ports {fmc_h_i_tri_i[0]}]; # HD_DP_05_GC_N  CLK0_M2C_N  H5
set_property PACKAGE_PIN G26 [get_ports {fmc_h_i_tri_i[1]}]; # HP_DP_17_N  LA02_N  H8
set_property PACKAGE_PIN J20 [get_ports {fmc_h_i_tri_i[2]}]; # HP_DP_03_N  LA04_N  H11
set_property PACKAGE_PIN H12 [get_ports {fmc_h_i_tri_i[3]}]; # HD_DP_01_N  LA07_N  H14
set_property PACKAGE_PIN E12 [get_ports {fmc_h_i_tri_i[4]}]; # HD_DP_07_GC_N  LA11_N  H17
set_property PACKAGE_PIN J21 [get_ports {fmc_h_i_tri_i[5]}]; # HP_DP_05_N  LA15_N  H20
set_property PACKAGE_PIN E23 [get_ports {fmc_h_i_tri_i[6]}]; # HP_DP_20_N  LA19_N  H23
set_property PACKAGE_PIN C24 [get_ports {fmc_h_i_tri_i[7]}]; # HP_DP_22_N  LA21_N  H26
set_property PACKAGE_PIN H24 [get_ports {fmc_h_i_tri_i[8]}]; # HP_DP_14_GC_N  LA24_N  H29
set_property PACKAGE_PIN G14 [get_ports {fmc_h_i_tri_i[9]}]; # HD_DP_03_N  LA28_N  H32
set_property PACKAGE_PIN C13 [get_ports {fmc_h_i_tri_i[10]}]; # HD_DP_09_N  LA30_N  H35
set_property PACKAGE_PIN A12 [get_ports {fmc_h_i_tri_i[11]}]; # HD_DP_11_N  LA32_N  H38


