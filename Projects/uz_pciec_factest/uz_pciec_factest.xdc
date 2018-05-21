# ----------------------------------------------------------------------------
#        UltraZed-3EG Rev. 1 SOM with PCIe Carrier Rev. 1
#     _____
#    /     \
#   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET ELECTRONICS MARKETING
#      \======/         www.em.avnet.com/drc
#       \====/    
# ----------------------------------------------------------------------------
# 
#  Created With Avnet Constraints Generator V0.8.0 
#     Date: Sunday, July 17, 2016 
#     Time: 07:57:54 AM 
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
#  Sunday, July 17, 2016
#
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
# 
# ----------------------------------------------------------------------------

# SYSMON
set_property IOSTANDARD ANALOG [get_ports Vp_Vn_v_p]
set_property IOSTANDARD ANALOG [get_ports Vp_Vn_v_n]


# PL DIP Switches

set_property PACKAGE_PIN H1 [get_ports {dip_switches_8bits_tri_i[0]}]		;# JX2_HP_DP_17_P
set_property PACKAGE_PIN G1 [get_ports {dip_switches_8bits_tri_i[1]}]		;# JX2_HP_DP_17_N
set_property PACKAGE_PIN G7 [get_ports {dip_switches_8bits_tri_i[2]}]		;# JX2_HP_DP_19_P
set_property PACKAGE_PIN F7 [get_ports {dip_switches_8bits_tri_i[3]}]		;# JX2_HP_DP_19_N
set_property PACKAGE_PIN G8 [get_ports {dip_switches_8bits_tri_i[4]}]		;# JX2_HP_DP_21_P
set_property PACKAGE_PIN F8 [get_ports {dip_switches_8bits_tri_i[5]}]		;# JX2_HP_DP_21_N
set_property PACKAGE_PIN B3 [get_ports {dip_switches_8bits_tri_i[6]}]		;# JX2_HP_DP_23_P
set_property PACKAGE_PIN B2 [get_ports {dip_switches_8bits_tri_i[7]}]		;# JX2_HP_DP_23_N

set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[7]}]


# PL LEDs 

set_property PACKAGE_PIN C8 [get_ports {led_8bits_tri_o[0]}]		;# JX2_HP_DP_16_P
set_property PACKAGE_PIN B8 [get_ports {led_8bits_tri_o[1]}]		;# JX2_HP_DP_16_N
set_property PACKAGE_PIN A6 [get_ports {led_8bits_tri_o[2]}]		;# JX2_HP_DP_18_P
set_property PACKAGE_PIN A5 [get_ports {led_8bits_tri_o[3]}]		;# JX2_HP_DP_18_N
set_property PACKAGE_PIN H6 [get_ports {led_8bits_tri_o[4]}]		;# JX2_HP_DP_20_P
set_property PACKAGE_PIN G6 [get_ports {led_8bits_tri_o[5]}]		;# JX2_HP_DP_20_N
set_property PACKAGE_PIN G5 [get_ports {led_8bits_tri_o[6]}]		;# JX2_HP_DP_22_P
set_property PACKAGE_PIN F5 [get_ports {led_8bits_tri_o[7]}]		;# JX2_HP_DP_22_N

set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[7]}]


# PL Push Switches

set_property PACKAGE_PIN D8 [get_ports {push_buttons_4bits_tri_i[0]}]		;# JX2_HP_SE_00
set_property PACKAGE_PIN E7 [get_ports {push_buttons_4bits_tri_i[1]}]		;# JX2_HP_SE_01
set_property PACKAGE_PIN A4 [get_ports {push_buttons_4bits_tri_i[2]}]		;# JX2_HP_SE_02
set_property PACKAGE_PIN H5 [get_ports {push_buttons_4bits_tri_i[3]}]		;# JX2_HP_SE_03

set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[3]}]   


# PMOD Loopback Test

# JA Pins 1, 2, 3, and 4
set_property PACKAGE_PIN B12 [get_ports {output_to_pmods_tri_io[0]}]   ;# JX2_HD_SE_03_P
set_property PACKAGE_PIN F9  [get_ports {output_to_pmods_tri_io[1]}]    ;# JX2_HD_SE_05_GC_P
set_property PACKAGE_PIN D11 [get_ports {output_to_pmods_tri_io[2]}]   ;# JX2_HD_SE_07_GC_P
set_property PACKAGE_PIN G12 [get_ports {output_to_pmods_tri_io[3]}]   ;# JX2_HD_SE_09_P

# JB Pins 1, 2, 3, and 4
set_property PACKAGE_PIN B11 [get_ports {output_to_pmods_tri_io[4]}]   ;# JX2_HD_SE_02_P
set_property PACKAGE_PIN E11 [get_ports {output_to_pmods_tri_io[5]}]   ;# JX2_HD_SE_04_GC_P
set_property PACKAGE_PIN D9  [get_ports {output_to_pmods_tri_io[6]}]    ;# JX2_HD_SE_06_GC_P
set_property PACKAGE_PIN E12 [get_ports {output_to_pmods_tri_io[7]}]   ;# JX2_HD_SE_08_P

# JA Pins 7, 8, 9, and 10
set_property PACKAGE_PIN A12 [get_ports {input_from_pmods_tri_io[0]}]  ;# JX2_HD_SE_03_N
set_property PACKAGE_PIN E9  [get_ports {input_from_pmods_tri_io[1]}]   ;# JX2_HD_SE_05_GC_N
set_property PACKAGE_PIN C11 [get_ports {input_from_pmods_tri_io[2]}]  ;# JX2_HD_SE_07_GC_N
set_property PACKAGE_PIN F12 [get_ports {input_from_pmods_tri_io[3]}]  ;# JX2_HD_SE_09_N

# JB Pins 7, 8, 9, and 10
set_property PACKAGE_PIN A10 [get_ports {input_from_pmods_tri_io[4]}]  ;# JX2_HD_SE_02_N
set_property PACKAGE_PIN E10 [get_ports {input_from_pmods_tri_io[5]}]  ;# JX2_HD_SE_04_GC_N
set_property PACKAGE_PIN C9  [get_ports {input_from_pmods_tri_io[6]}]   ;# JX2_HD_SE_06_GC_N
set_property PACKAGE_PIN D12 [get_ports {input_from_pmods_tri_io[7]}]  ;# JX2_HD_SE_08_N

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
 
 
# FMC LPC loopback test - high order LA paired I/O pins
#
#FMC-LA33_N
set_property PACKAGE_PIN AA8 [get_ports {fmc_lpc_se_high_ch1_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[17]}]
#FMC-LA32_N
set_property PACKAGE_PIN AB7 [get_ports {fmc_lpc_se_high_ch1_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[16]}]
#FMC-LA31_N
set_property PACKAGE_PIN AE6 [get_ports {fmc_lpc_se_high_ch1_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[15]}]
#FMC-LA30_N
set_property PACKAGE_PIN AD5 [get_ports {fmc_lpc_se_high_ch1_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[14]}]
#FMC-LA29_N
set_property PACKAGE_PIN Y4 [get_ports {fmc_lpc_se_high_ch1_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[13]}]
#FMC-LA28_N
set_property PACKAGE_PIN AA3 [get_ports {fmc_lpc_se_high_ch1_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[12]}]
#FMC-LA27_N
set_property PACKAGE_PIN AA2 [get_ports {fmc_lpc_se_high_ch1_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[11]}]
#FMC-LA26_N
set_property PACKAGE_PIN W2 [get_ports {fmc_lpc_se_high_ch1_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[10]}]
#FMC-LA25_N
set_property PACKAGE_PIN Y1 [get_ports {fmc_lpc_se_high_ch1_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[9]}]
#FMC-LA24_N
set_property PACKAGE_PIN AD7 [get_ports {fmc_lpc_se_high_ch1_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[8]}]
#FMC-LA23_N
set_property PACKAGE_PIN AE1 [get_ports {fmc_lpc_se_high_ch1_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[7]}]
#FMC-LA22_N
set_property PACKAGE_PIN AC6 [get_ports {fmc_lpc_se_high_ch1_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[6]}]
#FMC-LA21_N
set_property PACKAGE_PIN AB1 [get_ports {fmc_lpc_se_high_ch1_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[5]}]
#FMC-LA20_N
set_property PACKAGE_PIN AD3 [get_ports {fmc_lpc_se_high_ch1_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[4]}]
#FMC-LA19_N
set_property PACKAGE_PIN AE3 [get_ports {fmc_lpc_se_high_ch1_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[3]}]
#FMC-LA18_CC_N
set_property PACKAGE_PIN AC3 [get_ports {fmc_lpc_se_high_ch1_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[2]}]
#FMC-LA17_CC_N
set_property PACKAGE_PIN AC4 [get_ports {fmc_lpc_se_high_ch1_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[1]}]
#FMC-CLK1_M2C_N
set_property PACKAGE_PIN Y6 [get_ports {fmc_lpc_se_high_ch1_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch1_tri_io[0]}]
#
# FMC LPC loopback test - high order LA paired I/O pins
#
#FMC-LA33_P
set_property PACKAGE_PIN AA9 [get_ports {fmc_lpc_se_high_ch2_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[17]}]
#FMC-LA32_P
set_property PACKAGE_PIN AB8 [get_ports {fmc_lpc_se_high_ch2_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[16]}]
#FMC-LA31_P
set_property PACKAGE_PIN AE7 [get_ports {fmc_lpc_se_high_ch2_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[15]}]
#FMC-LA30_P
set_property PACKAGE_PIN AD6 [get_ports {fmc_lpc_se_high_ch2_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[14]}]
#FMC-LA29_P
set_property PACKAGE_PIN W4 [get_ports {fmc_lpc_se_high_ch2_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[13]}]
#FMC-LA28_P
set_property PACKAGE_PIN AA4 [get_ports {fmc_lpc_se_high_ch2_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[12]}]
#FMC-LA27_P
set_property PACKAGE_PIN Y2 [get_ports {fmc_lpc_se_high_ch2_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[11]}]
#FMC-LA26_P
set_property PACKAGE_PIN W3 [get_ports {fmc_lpc_se_high_ch2_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[10]}]
#FMC-LA25_P
set_property PACKAGE_PIN W1 [get_ports {fmc_lpc_se_high_ch2_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[9]}]
#FMC-LA24_P
set_property PACKAGE_PIN AD8 [get_ports {fmc_lpc_se_high_ch2_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[8]}]
#FMC-LA23_P
set_property PACKAGE_PIN AD1 [get_ports {fmc_lpc_se_high_ch2_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[7]}]
#FMC-LA22_P
set_property PACKAGE_PIN AB6 [get_ports {fmc_lpc_se_high_ch2_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[6]}]
#FMC-LA21_P
set_property PACKAGE_PIN AB2 [get_ports {fmc_lpc_se_high_ch2_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[5]}]
#FMC-LA20_P
set_property PACKAGE_PIN AD4 [get_ports {fmc_lpc_se_high_ch2_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[4]}]
#FMC-LA19_P
set_property PACKAGE_PIN AE4 [get_ports {fmc_lpc_se_high_ch2_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[3]}]
#FMC-LA18_CC_P
set_property PACKAGE_PIN AB3 [get_ports {fmc_lpc_se_high_ch2_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[2]}]
#FMC-LA17_CC_P
set_property PACKAGE_PIN AB5 [get_ports {fmc_lpc_se_high_ch2_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[1]}]
#FMC-CLK1_M2C_P
set_property PACKAGE_PIN W6 [get_ports {fmc_lpc_se_high_ch2_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_high_ch2_tri_io[0]}]
#
# FMC LPC loopback test - low order LA paired I/O pins
#
#FMC-LA16_N
set_property PACKAGE_PIN T7 [get_ports {fmc_lpc_se_low_ch1_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[17]}]
#FMC-LA15_N
set_property PACKAGE_PIN W7 [get_ports {fmc_lpc_se_low_ch1_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[16]}]
#FMC-LA14_N
set_property PACKAGE_PIN P2 [get_ports {fmc_lpc_se_low_ch1_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[15]}]
#FMC-LA13_N
set_property PACKAGE_PIN P1 [get_ports {fmc_lpc_se_low_ch1_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[14]}]
#FMC-LA12_N
set_property PACKAGE_PIN V3 [get_ports {fmc_lpc_se_low_ch1_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[13]}]
#FMC-LA11_N
set_property PACKAGE_PIN U2 [get_ports {fmc_lpc_se_low_ch1_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[12]}]
#FMC-LA10_N
set_property PACKAGE_PIN K7 [get_ports {fmc_lpc_se_low_ch1_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[11]}]
#FMC-LA09_N
set_property PACKAGE_PIN J6 [get_ports {fmc_lpc_se_low_ch1_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[10]}]
#FMC-LA08_N
set_property PACKAGE_PIN J4 [get_ports {fmc_lpc_se_low_ch1_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[9]}]
#FMC-LA07_N
set_property PACKAGE_PIN V1 [get_ports {fmc_lpc_se_low_ch1_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[8]}]
#FMC-LA06_N
set_property PACKAGE_PIN L5 [get_ports {fmc_lpc_se_low_ch1_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[7]}]
#FMC-LA05_N
set_property PACKAGE_PIN M5 [get_ports {fmc_lpc_se_low_ch1_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[6]}]
#FMC-LA04_N
set_property PACKAGE_PIN K5 [get_ports {fmc_lpc_se_low_ch1_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[5]}]
#FMC-LA03_N
set_property PACKAGE_PIN R1 [get_ports {fmc_lpc_se_low_ch1_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[4]}]
#FMC-LA02_N
set_property PACKAGE_PIN K2 [get_ports {fmc_lpc_se_low_ch1_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[3]}]
#FMC-LA01_CC_N
set_property PACKAGE_PIN N3 [get_ports {fmc_lpc_se_low_ch1_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[2]}]
#FMC-LA00_CC_N
set_property PACKAGE_PIN L3 [get_ports {fmc_lpc_se_low_ch1_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[1]}]
#FMC-CLK0_M2C_N
set_property PACKAGE_PIN R4 [get_ports {fmc_lpc_se_low_ch1_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch1_tri_io[0]}]
#
# FMC LPC loopback test - low order LA paired I/O pins
#
#FMC-LA16_P
set_property PACKAGE_PIN R7 [get_ports {fmc_lpc_se_low_ch2_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[17]}]
#FMC-LA15_P
set_property PACKAGE_PIN W8 [get_ports {fmc_lpc_se_low_ch2_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[16]}]
#FMC-LA14_P
set_property PACKAGE_PIN P3 [get_ports {fmc_lpc_se_low_ch2_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[15]}]
#FMC-LA13_P
set_property PACKAGE_PIN N1 [get_ports {fmc_lpc_se_low_ch2_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[14]}]
#FMC-LA12_P
set_property PACKAGE_PIN U3 [get_ports {fmc_lpc_se_low_ch2_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[13]}]
#FMC-LA11_P
set_property PACKAGE_PIN T3 [get_ports {fmc_lpc_se_low_ch2_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[12]}]
#FMC-LA10_P
set_property PACKAGE_PIN L7 [get_ports {fmc_lpc_se_low_ch2_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[11]}]
#FMC-LA09_P
set_property PACKAGE_PIN J7 [get_ports {fmc_lpc_se_low_ch2_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[10]}]
#FMC-LA08_P
set_property PACKAGE_PIN K4 [get_ports {fmc_lpc_se_low_ch2_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[9]}]
#FMC-LA07_P
set_property PACKAGE_PIN U1 [get_ports {fmc_lpc_se_low_ch2_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[8]}]
#FMC-LA06_P
set_property PACKAGE_PIN M6 [get_ports {fmc_lpc_se_low_ch2_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[7]}]
#FMC-LA05_P
set_property PACKAGE_PIN N5 [get_ports {fmc_lpc_se_low_ch2_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[6]}]
#FMC-LA04_P
set_property PACKAGE_PIN K6 [get_ports {fmc_lpc_se_low_ch2_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[5]}]
#FMC-LA03_P
set_property PACKAGE_PIN R2 [get_ports {fmc_lpc_se_low_ch2_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[4]}]
#FMC-LA02_P
set_property PACKAGE_PIN L2 [get_ports {fmc_lpc_se_low_ch2_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[3]}]
#FMC-LA01_CC_P
set_property PACKAGE_PIN N4 [get_ports {fmc_lpc_se_low_ch2_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[2]}]
#FMC-LA00_CC_P
set_property PACKAGE_PIN M3 [get_ports {fmc_lpc_se_low_ch2_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[1]}]
#FMC-CLK0_M2C_P
set_property PACKAGE_PIN P4 [get_ports {fmc_lpc_se_low_ch2_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_lpc_se_low_ch2_tri_io[0]}]

 