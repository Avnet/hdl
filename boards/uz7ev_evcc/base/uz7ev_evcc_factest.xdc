# ----------------------------------------------------------------------------
#        UltraZed-7EV Rev. 1 SOM with EV Carrier Rev. 1
#     _____
#    /     \
#   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET ELECTRONICS MARKETING
#      \======/         www.em.avnet.com/drc
#       \====/    
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#  
#  Please direct any questions to:
#     Avnet Technical Community Forums
#     http://community.em.avnet.com
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2009 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Notes: 
# 
#  Dec 21, 2017
#
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
# 
# ----------------------------------------------------------------------------

## ---------------------------------------------------
## UltraZed-EV SOM Clock Output #4 - 300MHz OSC Y4 on Bank 66
## ---------------------------------------------------
set_property PACKAGE_PIN AC8 [ get_ports "user_sys_clk_p" ]; # SYS_CLK_P
set_property PACKAGE_PIN AC7 [ get_ports "user_sys_clk_n" ]; # SYS_CLK_N
##
set_property IOSTANDARD LVDS [ get_ports "user_sys_clk_p" ];
set_property IOSTANDARD LVDS [ get_ports "user_sys_clk_n" ];

## ---------------------------------------------------
## UltraZed-EV SOM User Push Button 
## ---------------------------------------------------
## HP_DP_18_P - Location SW1 (VCCO_1V8)
## ---------------------------------------------------
set_property PACKAGE_PIN AA13 [get_ports RSTBTN];  # HP_DP_18_P
set_property IOSTANDARD LVCMOS18 [get_ports RSTBTN];

## ---------------------------------------------------
## ALI3 interface 
## Native ALI3 (Avnet LCD Interface) Interface on the 1.8V powered bank 65
## ---------------------------------------------------
##
## set_property PACKAGE_PIN XXXX  	[get_ports ALI_RST_N];  # N/C
## set_property IOSTANDARD LVCMOS25 [get_ports ALI_RST_N];
##
set_property PACKAGE_PIN AG1  [get_ports ALI_CLK_P];  			# CLK_P - HP_DP_46_P
set_property PACKAGE_PIN AH1  [get_ports ALI_CLK_N];  			# CLK_N - HP_DP_46_N
set_property PACKAGE_PIN AH12 [get_ports {ALI_DATA_P[0]}];  	# D0_P  - HP_DP_42_P
set_property PACKAGE_PIN AJ12 [get_ports {ALI_DATA_N[0]}];  	# D0_N  - HP_DP_42_N
set_property PACKAGE_PIN AE9  [get_ports {ALI_DATA_P[1]}];  	# D1_P  - HP_DP_43_P
set_property PACKAGE_PIN AE8  [get_ports {ALI_DATA_N[1]}];  	# D1_N  - HP_DP_43_N
set_property PACKAGE_PIN AH3  [get_ports {ALI_DATA_P[2]}];  	# D2_P  - HP_DP_44_P
set_property PACKAGE_PIN AH2  [get_ports {ALI_DATA_N[2]}];  	# D2_N  - HP_DP_44_N
set_property PACKAGE_PIN AK3  [get_ports {ALI_DATA_P[3]}];  	# D3_P  - HP_DP_45_P
set_property PACKAGE_PIN AK2  [get_ports {ALI_DATA_N[3]}];  	# D3_N  - HP_DP_45_N

set_property IOSTANDARD LVDS  [get_ports ALI_CLK*];
set_property IOSTANDARD LVDS  [get_ports ALI_DATA*];

## ---------------------------------------------------
## UltraZed-EV Standard IO Constraints
## ---------------------------------------------------

# SYSMON
set_property IOSTANDARD ANALOG [get_ports Vp_Vn_v_p]
set_property IOSTANDARD ANALOG [get_ports Vp_Vn_v_n]

# PMOD Loopback Test

# JA Pins 1, 2, 3, and 4
set_property PACKAGE_PIN B15 [get_ports {output_to_pmods_tri_io[0]}]   ;# HD_SE_00_P
set_property PACKAGE_PIN A15 [get_ports {output_to_pmods_tri_io[1]}]   ;# HD_SE_00_N
set_property PACKAGE_PIN A17 [get_ports {output_to_pmods_tri_io[2]}]   ;# HD_SE_01_P
set_property PACKAGE_PIN A16 [get_ports {output_to_pmods_tri_io[3]}]   ;# HD_SE_01_N

# JB Pins 1, 2, 3, and 4
set_property PACKAGE_PIN G16 [get_ports {output_to_pmods_tri_io[4]}]   ;# HD_SE_04_GC_P
set_property PACKAGE_PIN G15 [get_ports {output_to_pmods_tri_io[5]}]   ;# HD_SE_04_GC_N
set_property PACKAGE_PIN E15 [get_ports {output_to_pmods_tri_io[6]}]   ;# HD_SE_05_GC_P
set_property PACKAGE_PIN D15 [get_ports {output_to_pmods_tri_io[7]}]   ;# HD_SE_05_GC_N

# JA Pins 7, 8, 9, and 10
set_property PACKAGE_PIN J16 [get_ports {input_from_pmods_tri_io[0]}]  ;# HD_SE_02_P
set_property PACKAGE_PIN H16 [get_ports {input_from_pmods_tri_io[1]}]  ;# HD_SE_02_N
set_property PACKAGE_PIN K15 [get_ports {input_from_pmods_tri_io[2]}]  ;# HD_SE_03_P
set_property PACKAGE_PIN K14 [get_ports {input_from_pmods_tri_io[3]}]  ;# HD_SE_03_N

# JB Pins 7, 8, 9, and 10
set_property PACKAGE_PIN F16 [get_ports {input_from_pmods_tri_io[4]}]  ;# HD_SE_06_GC_P
set_property PACKAGE_PIN F15 [get_ports {input_from_pmods_tri_io[5]}]  ;# HD_SE_06_GC_N
set_property PACKAGE_PIN E17 [get_ports {input_from_pmods_tri_io[6]}]  ;# HD_SE_07_GC_P
set_property PACKAGE_PIN D17 [get_ports {input_from_pmods_tri_io[7]}]  ;# HD_SE_07_GC_N

set_property IOSTANDARD LVCMOS33 [get_ports {output_to_pmods_tri_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_to_pmods_tri_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_to_pmods_tri_io[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_to_pmods_tri_io[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {output_to_pmods_tri_io[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_to_pmods_tri_io[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_to_pmods_tri_io[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {output_to_pmods_tri_io[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {input_from_pmods_tri_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_from_pmods_tri_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_from_pmods_tri_io[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_from_pmods_tri_io[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {input_from_pmods_tri_io[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_from_pmods_tri_io[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_from_pmods_tri_io[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {input_from_pmods_tri_io[7]}]
 
 # FMC HPC loopback test - high order LA paired I/O pins
#
#FMC-LA33_N, HP_DP_41_N
set_property PACKAGE_PIN AH11 [get_ports {fmc_lpc_se_high_ch1_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[17]}]
#FMC-LA32_N, HP_DP_40_N
set_property PACKAGE_PIN AJ9 [get_ports {fmc_lpc_se_high_ch1_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[16]}]
#FMC-LA31_N, HP_DP_39_N
set_property PACKAGE_PIN AF2 [get_ports {fmc_lpc_se_high_ch1_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[15]}]
#FMC-LA30_N, HP_DP_38_N
set_property PACKAGE_PIN AJ1 [get_ports {fmc_lpc_se_high_ch1_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[14]}]
#FMC-LA29_N, HP_DP_37_N
set_property PACKAGE_PIN AK4 [get_ports {fmc_lpc_se_high_ch1_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[13]}]
#FMC-LA28_N, HP_DP_36_N
set_property PACKAGE_PIN AK11 [get_ports {fmc_lpc_se_high_ch1_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[12]}]
#FMC-LA27_N, HP_DP_35_GC_N
set_property PACKAGE_PIN AH8 [get_ports {fmc_lpc_se_high_ch1_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[11]}]
#FMC-LA26_N, HP_DP_31_N
set_property PACKAGE_PIN AK8 [get_ports {fmc_lpc_se_high_ch1_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[10]}]
#FMC-LA25_N, HP_DP_30_N
set_property PACKAGE_PIN AF5 [get_ports {fmc_lpc_se_high_ch1_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[9]}]
#FMC-LA24_N, HP_DP_29_N
set_property PACKAGE_PIN AK6 [get_ports {fmc_lpc_se_high_ch1_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[8]}]
#FMC-LA23_N, HP_DP_28_N
set_property PACKAGE_PIN AK5 [get_ports {fmc_lpc_se_high_ch1_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[7]}]
#FMC-LA22_N, HP_DP_27_N
set_property PACKAGE_PIN AF11 [get_ports {fmc_lpc_se_high_ch1_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[6]}]
#FMC-LA21_N, HP_DP_26_N
set_property PACKAGE_PIN AF7 [get_ports {fmc_lpc_se_high_ch1_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[5]}]
#FMC-LA20_N, HP_DP_25_N
set_property PACKAGE_PIN AK10 [get_ports {fmc_lpc_se_high_ch1_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[4]}]
#FMC-LA19_N, HP_DP_24_N
set_property PACKAGE_PIN AG10 [get_ports {fmc_lpc_se_high_ch1_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[3]}]
#FMC-LA18_CC_N, HP_DP_33_GC_N
set_property PACKAGE_PIN AJ6 [get_ports {fmc_lpc_se_high_ch1_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[2]}]
#FMC-LA17_CC_N, HP_DP_32_GC_N
set_property PACKAGE_PIN AG5 [get_ports {fmc_lpc_se_high_ch1_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[1]}]
#FMC-CLK1_M2C_N, HP_DP_34_GC_N
set_property PACKAGE_PIN AJ7 [get_ports {fmc_lpc_se_high_ch1_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[0]}]
#
# FMC HPC loopback test - high order LA paired I/O pins
#
#FMC-LA33_P, HP_DP_41_P
set_property PACKAGE_PIN AG11 [get_ports {fmc_lpc_se_high_ch2_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[17]}]
#FMC-LA32_P, HP_DP_40_P
set_property PACKAGE_PIN AH9 [get_ports {fmc_lpc_se_high_ch2_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[16]}]
#FMC-LA31_P, HP_DP_39_P
set_property PACKAGE_PIN AF3 [get_ports {fmc_lpc_se_high_ch2_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[15]}]
#FMC-LA30_P, HP_DP_38_P
set_property PACKAGE_PIN AJ2 [get_ports {fmc_lpc_se_high_ch2_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[14]}]
#FMC-LA29_P, HP_DP_37_P
set_property PACKAGE_PIN AJ4 [get_ports {fmc_lpc_se_high_ch2_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[13]}]
#FMC-LA28_P, HP_DP_36_P
set_property PACKAGE_PIN AJ11 [get_ports {fmc_lpc_se_high_ch2_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[12]}]
#FMC-LA27_P, HP_DP_35_GC_P
set_property PACKAGE_PIN AG8 [get_ports {fmc_lpc_se_high_ch2_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[11]}]
#FMC-LA26_P, HP_DP_31_P
set_property PACKAGE_PIN AK9 [get_ports {fmc_lpc_se_high_ch2_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[10]}]
#FMC-LA25_P, HP_DP_30_P
set_property PACKAGE_PIN AF6 [get_ports {fmc_lpc_se_high_ch2_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[9]}]
#FMC-LA24_P, HP_DP_29_P
set_property PACKAGE_PIN AK7 [get_ports {fmc_lpc_se_high_ch2_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[8]}]
#FMC-LA23_P, HP_DP_28_P
set_property PACKAGE_PIN AJ5 [get_ports {fmc_lpc_se_high_ch2_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[7]}]
#FMC-LA22_P, HP_DP_27_P
set_property PACKAGE_PIN AF12 [get_ports {fmc_lpc_se_high_ch2_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[6]}]
#FMC-LA21_P, HP_DP_26_P
set_property PACKAGE_PIN AF8 [get_ports {fmc_lpc_se_high_ch2_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[5]}]
#FMC-LA20_P, HP_DP_25_P
set_property PACKAGE_PIN AJ10 [get_ports {fmc_lpc_se_high_ch2_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[4]}]
#FMC-LA19_P, HP_DP_24_P
set_property PACKAGE_PIN AF10 [get_ports {fmc_lpc_se_high_ch2_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[3]}]
#FMC-LA18_CC_P, HP_DP_33_GC_P
set_property PACKAGE_PIN AH6 [get_ports {fmc_lpc_se_high_ch2_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[2]}]
#FMC-LA17_CC_P, HP_DP_32_GC_P
set_property PACKAGE_PIN AG6 [get_ports {fmc_lpc_se_high_ch2_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[1]}]
#FMC-CLK1_M2C_P, HP_DP_34_GC_P
set_property PACKAGE_PIN AH7 [get_ports {fmc_lpc_se_high_ch2_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[0]}]
#
# FMC HPC loopback test - low order LA paired I/O pins
#
#FMC-LA16_N, HP_DP_17_N
set_property PACKAGE_PIN AH13 [get_ports {fmc_lpc_se_low_ch1_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[17]}]
#FMC-LA15_N, HP_DP_16_N
set_property PACKAGE_PIN AK12 [get_ports {fmc_lpc_se_low_ch1_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[16]}]
#FMC-LA14_N, HP_DP_15_GC_N
set_property PACKAGE_PIN AG15 [get_ports {fmc_lpc_se_low_ch1_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[15]}]
#FMC-LA13_N, HP_DP_11_N
set_property PACKAGE_PIN AK15 [get_ports {fmc_lpc_se_low_ch1_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[14]}]
#FMC-LA12_N, HP_DP_10_N
set_property PACKAGE_PIN AK14 [get_ports {fmc_lpc_se_low_ch1_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[13]}]
#FMC-LA11_N, HP_DP_09_N
set_property PACKAGE_PIN AD16 [get_ports {fmc_lpc_se_low_ch1_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[12]}]
#FMC-LA10_N, HP_DP_08_N
set_property PACKAGE_PIN AH16 [get_ports {fmc_lpc_se_low_ch1_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[11]}]
#FMC-LA09_N, HP_DP_07_N
set_property PACKAGE_PIN AK18 [get_ports {fmc_lpc_se_low_ch1_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[10]}]
#FMC-LA08_N, HP_DP_06_N
set_property PACKAGE_PIN AK16 [get_ports {fmc_lpc_se_low_ch1_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[9]}]
#FMC-LA07_N, HP_DP_05_N
set_property PACKAGE_PIN AB16 [get_ports {fmc_lpc_se_low_ch1_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[8]}]
#FMC-LA06_N, HP_DP_04_N
set_property PACKAGE_PIN AC18 [get_ports {fmc_lpc_se_low_ch1_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[7]}]
#FMC-LA05_N, HP_DP_03_N
set_property PACKAGE_PIN AE19 [get_ports {fmc_lpc_se_low_ch1_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[6]}]
#FMC-LA04_N, HP_DP_02_N
set_property PACKAGE_PIN AJ17 [get_ports {fmc_lpc_se_low_ch1_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[5]}]
#FMC-LA03_N, HP_DP_01_N
set_property PACKAGE_PIN AF18 [get_ports {fmc_lpc_se_low_ch1_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[4]}]
#FMC-LA02_N, HP_DP_00_N
set_property PACKAGE_PIN AH18 [get_ports {fmc_lpc_se_low_ch1_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[3]}]
#FMC-LA01_CC_N, HP_DP_13_GC_N
set_property PACKAGE_PIN AE17 [get_ports {fmc_lpc_se_low_ch1_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[2]}]
#FMC-LA00_CC_N, HP_DP_12_GC_N
set_property PACKAGE_PIN AF17 [get_ports {fmc_lpc_se_low_ch1_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[1]}]
#FMC-CLK0_M2C_N, HP_DP_14_GC_N
set_property PACKAGE_PIN AH14 [get_ports {fmc_lpc_se_low_ch1_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[0]}]
#
# FMC HPC loopback test - low order LA paired I/O pins
#
#FMC-LA16_P, HP_DP_17_P
set_property PACKAGE_PIN AG13 [get_ports {fmc_lpc_se_low_ch2_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[17]}]
#FMC-LA15_P, HP_DP_16_P
set_property PACKAGE_PIN AK13 [get_ports {fmc_lpc_se_low_ch2_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[16]}]
#FMC-LA14_P, HP_DP_15_GC_P
set_property PACKAGE_PIN AF15 [get_ports {fmc_lpc_se_low_ch2_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[15]}]
#FMC-LA13_P, HP_DP_11_P
set_property PACKAGE_PIN AJ15 [get_ports {fmc_lpc_se_low_ch2_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[14]}]
#FMC-LA12_P, HP_DP_10_P
set_property PACKAGE_PIN AJ14 [get_ports {fmc_lpc_se_low_ch2_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[13]}]
#FMC-LA11_P, HP_DP_09_P
set_property PACKAGE_PIN AC16 [get_ports {fmc_lpc_se_low_ch2_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[12]}]
#FMC-LA10_P, HP_DP_08_P
set_property PACKAGE_PIN AG16 [get_ports {fmc_lpc_se_low_ch2_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[11]}]
#FMC-LA09_P, HP_DP_07_P
set_property PACKAGE_PIN AK17 [get_ports {fmc_lpc_se_low_ch2_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[10]}]
#FMC-LA08_P, HP_DP_06_P
set_property PACKAGE_PIN AJ16 [get_ports {fmc_lpc_se_low_ch2_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[9]}]
#FMC-LA07_P, HP_DP_05_P
set_property PACKAGE_PIN AA16 [get_ports {fmc_lpc_se_low_ch2_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[8]}]
#FMC-LA06_P, HP_DP_04_P
set_property PACKAGE_PIN AC17 [get_ports {fmc_lpc_se_low_ch2_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[7]}]
#FMC-LA05_P, HP_DP_03_P
set_property PACKAGE_PIN AD19 [get_ports {fmc_lpc_se_low_ch2_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[6]}]
#FMC-LA04_P, HP_DP_02_P
set_property PACKAGE_PIN AH17 [get_ports {fmc_lpc_se_low_ch2_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[5]}]
#FMC-LA03_P, HP_DP_01_P
set_property PACKAGE_PIN AE18 [get_ports {fmc_lpc_se_low_ch2_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[4]}]
#FMC-LA02_P, HP_DP_00_P
set_property PACKAGE_PIN AG18 [get_ports {fmc_lpc_se_low_ch2_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[3]}]
#FMC-LA01_CC_P, HP_DP_13_GC_P
set_property PACKAGE_PIN AD17 [get_ports {fmc_lpc_se_low_ch2_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[2]}]
#FMC-LA00_CC_P, HP_DP_12_GC_P
set_property PACKAGE_PIN AF16 [get_ports {fmc_lpc_se_low_ch2_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[1]}]
#FMC-CLK0_M2C_P, HP_DP_14_GC_P
set_property PACKAGE_PIN AG14 [get_ports {fmc_lpc_se_low_ch2_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[0]}]



 
