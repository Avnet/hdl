# ----------------------------------------------------------------------------
#        UltraZed-3EG Rev. 1 SOM with I/O Carrier Rev. 1
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

set_property PACKAGE_PIN P3 [get_ports {dip_switches_8bits_tri_i[0]}]		;# JX1_HP_DP_28_P
set_property PACKAGE_PIN P2 [get_ports {dip_switches_8bits_tri_i[1]}]		;# JX1_HP_DP_28_N
set_property PACKAGE_PIN N1 [get_ports {dip_switches_8bits_tri_i[2]}]		;# JX1_HP_DP_30_P
set_property PACKAGE_PIN P1 [get_ports {dip_switches_8bits_tri_i[3]}]		;# JX1_HP_DP_30_N
set_property PACKAGE_PIN J7 [get_ports {dip_switches_8bits_tri_i[4]}]		;# JX1_HP_DP_32_P
set_property PACKAGE_PIN J6 [get_ports {dip_switches_8bits_tri_i[5]}]		;# JX1_HP_DP_32_N
set_property PACKAGE_PIN L7 [get_ports {dip_switches_8bits_tri_i[6]}]		;# JX1_HP_DP_34_P
set_property PACKAGE_PIN K7 [get_ports {dip_switches_8bits_tri_i[7]}]		;# JX1_HP_DP_34_N

set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {dip_switches_8bits_tri_i[7]}]


# PL LEDs 

set_property PACKAGE_PIN R7 [get_ports {led_8bits_tri_o[0]}]		;# JX1_HP_DP_25_P
set_property PACKAGE_PIN T5 [get_ports {led_8bits_tri_o[1]}]		;# JX1_HP_DP_24_P
set_property PACKAGE_PIN T7 [get_ports {led_8bits_tri_o[2]}]		;# JX1_HP_DP_25_N
set_property PACKAGE_PIN T4 [get_ports {led_8bits_tri_o[3]}]		;# JX1_HP_DP_24_N
set_property PACKAGE_PIN T3 [get_ports {led_8bits_tri_o[4]}]		;# JX1_HP_DP_27_P
set_property PACKAGE_PIN U2 [get_ports {led_8bits_tri_o[5]}]		;# JX1_HP_DP_27_N
set_property PACKAGE_PIN U6 [get_ports {led_8bits_tri_o[6]}]		;# JX1_HP_DP_26_P
set_property PACKAGE_PIN U5 [get_ports {led_8bits_tri_o[7]}]		;# JX1_HP_DP_26_N

set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_8bits_tri_o[7]}]


# PL Push Switches

set_property PACKAGE_PIN R2 [get_ports {push_buttons_4bits_tri_i[0]}]		;# JX1_HP_DP_39_P
set_property PACKAGE_PIN R1 [get_ports {push_buttons_4bits_tri_i[1]}]		;# JX1_HP_DP_39_N
set_property PACKAGE_PIN L2 [get_ports {push_buttons_4bits_tri_i[2]}]		;# JX1_HP_DP_41_P
set_property PACKAGE_PIN K2 [get_ports {push_buttons_4bits_tri_i[3]}]		;# JX1_HP_DP_41_N

set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {push_buttons_4bits_tri_i[3]}]   
 

# PMOD Loopback Test

# JA1 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN AB8 [get_ports {outputs_to_pmods_1_8_tri_io[0]}]		;# JX1_HP_DP_00_P
set_property PACKAGE_PIN AB7 [get_ports {outputs_to_pmods_1_8_tri_io[1]}]		;# JX1_HP_DP_00_N
set_property PACKAGE_PIN Y7 [get_ports {outputs_to_pmods_1_8_tri_io[2]}]		;# JX1_HP_DP_01_P
set_property PACKAGE_PIN AA7 [get_ports {outputs_to_pmods_1_8_tri_io[3]}]		;# JX1_HP_DP_01_N
# JA1 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN AA9 [get_ports {inputs_from_pmods_1_8_tri_io[0]}]		;# JX1_HP_DP_02_P
set_property PACKAGE_PIN AA8 [get_ports {inputs_from_pmods_1_8_tri_io[1]}]		;# JX1_HP_DP_02_N
set_property PACKAGE_PIN AC9 [get_ports {inputs_from_pmods_1_8_tri_io[2]}]		;# JX1_HP_DP_03_P
set_property PACKAGE_PIN AC8 [get_ports {inputs_from_pmods_1_8_tri_io[3]}]		;# JX1_HP_DP_03_N

# JA2 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN AD6 [get_ports {outputs_to_pmods_1_8_tri_io[4]}]		;# JX1_HP_DP_04_P
set_property PACKAGE_PIN AD5 [get_ports {outputs_to_pmods_1_8_tri_io[5]}]		;# JX1_HP_DP_04_N
set_property PACKAGE_PIN AD9 [get_ports {outputs_to_pmods_1_8_tri_io[6]}]		;# JX1_HP_DP_05_P
set_property PACKAGE_PIN AE9 [get_ports {outputs_to_pmods_1_8_tri_io[7]}]		;# JX1_HP_DP_05_N
# JA2 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN AE7 [get_ports {inputs_from_pmods_1_8_tri_io[4]}]		;# JX1_HP_DP_06_P
set_property PACKAGE_PIN AE6 [get_ports {inputs_from_pmods_1_8_tri_io[5]}]		;# JX1_HP_DP_06_N
set_property PACKAGE_PIN AD8 [get_ports {inputs_from_pmods_1_8_tri_io[6]}]		;# JX1_HP_DP_07_P
set_property PACKAGE_PIN AD7 [get_ports {inputs_from_pmods_1_8_tri_io[7]}]		;# JX1_HP_DP_07_N

# JA3 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN AA4 [get_ports {outputs_to_pmods_1_8_tri_io[8]}]		;# JX1_HP_DP_08_P
set_property PACKAGE_PIN AA3 [get_ports {outputs_to_pmods_1_8_tri_io[9]}]		;# JX1_HP_DP_08_N
set_property PACKAGE_PIN W1 [get_ports {outputs_to_pmods_1_8_tri_io[10]}]		;# JX1_HP_DP_09_P
set_property PACKAGE_PIN Y1 [get_ports {outputs_to_pmods_1_8_tri_io[11]}]		;# JX1_HP_DP_09_N
# JA3 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN W4 [get_ports {inputs_from_pmods_1_8_tri_io[8]}]		;# JX1_HP_DP_10_P
set_property PACKAGE_PIN Y4 [get_ports {inputs_from_pmods_1_8_tri_io[9]}]		;# JX1_HP_DP_10_N
set_property PACKAGE_PIN AB2 [get_ports {inputs_from_pmods_1_8_tri_io[10]}]	    ;# JX1_HP_DP_11_P
set_property PACKAGE_PIN AB1 [get_ports {inputs_from_pmods_1_8_tri_io[11]}]	    ;# JX1_HP_DP_11_N

# JA4 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN W3 [get_ports {outputs_to_pmods_1_8_tri_io[12]}]		;# JX1_HP_DP_12_P
set_property PACKAGE_PIN W2 [get_ports {outputs_to_pmods_1_8_tri_io[13]}]		;# JX1_HP_DP_12_N
set_property PACKAGE_PIN AB6 [get_ports {outputs_to_pmods_1_8_tri_io[14]}]		;# JX1_HP_DP_13_P
set_property PACKAGE_PIN AC6 [get_ports {outputs_to_pmods_1_8_tri_io[15]}]		;# JX1_HP_DP_13_N
# JA4 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN Y2 [get_ports {inputs_from_pmods_1_8_tri_io[12]}]	    ;# JX1_HP_DP_14_P
set_property PACKAGE_PIN AA2 [get_ports {inputs_from_pmods_1_8_tri_io[13]}]	    ;# JX1_HP_DP_14_N
set_property PACKAGE_PIN AE4 [get_ports {inputs_from_pmods_1_8_tri_io[14]}]	    ;# JX1_HP_DP_15_P
set_property PACKAGE_PIN AE3 [get_ports {inputs_from_pmods_1_8_tri_io[15]}]	    ;# JX1_HP_DP_15_N

# JA5 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN AD1 [get_ports {outputs_to_pmods_1_8_tri_io[16]}]		;# JX1_HP_DP_16_P
set_property PACKAGE_PIN AE1 [get_ports {outputs_to_pmods_1_8_tri_io[17]}]		;# JX1_HP_DP_16_N
set_property PACKAGE_PIN AD4 [get_ports {outputs_to_pmods_1_8_tri_io[18]}]		;# JX1_HP_DP_17_P
set_property PACKAGE_PIN AD3 [get_ports {outputs_to_pmods_1_8_tri_io[19]}]		;# JX1_HP_DP_17_N
# JA5 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN AB5 [get_ports {inputs_from_pmods_1_8_tri_io[16]}]	    ;# JX1_HP_DP_18_GC_P
set_property PACKAGE_PIN AC4 [get_ports {inputs_from_pmods_1_8_tri_io[17]}]	    ;# JX1_HP_DP_18_GC_N
set_property PACKAGE_PIN AB3 [get_ports {inputs_from_pmods_1_8_tri_io[18]}]	    ;# JX1_HP_DP_19_GC_P
set_property PACKAGE_PIN AC3 [get_ports {inputs_from_pmods_1_8_tri_io[19]}]	    ;# JX1_HP_DP_19_GC_N

# JA6 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN W6 [get_ports {outputs_to_pmods_1_8_tri_io[20]}]		;# JX1_HP_DP_20_GC_P
set_property PACKAGE_PIN Y6 [get_ports {outputs_to_pmods_1_8_tri_io[21]}]		;# JX1_HP_DP_20_GC_N
set_property PACKAGE_PIN Y5 [get_ports {outputs_to_pmods_1_8_tri_io[22]}]		;# JX1_HP_DP_21_GC_P
set_property PACKAGE_PIN AA5 [get_ports {outputs_to_pmods_1_8_tri_io[23]}]		;# JX1_HP_DP_21_GC_N
# JA6 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN AD2 [get_ports {inputs_from_pmods_1_8_tri_io[20]}]		;# JX1_HP_DP_22_P
set_property PACKAGE_PIN AE2 [get_ports {inputs_from_pmods_1_8_tri_io[21]}]		;# JX1_HP_DP_22_N
set_property PACKAGE_PIN W8 [get_ports {inputs_from_pmods_1_8_tri_io[22]}]		;# JX1_HP_DP_23_P
set_property PACKAGE_PIN W7 [get_ports {inputs_from_pmods_1_8_tri_io[23]}]		;# JX1_HP_DP_23_N

# JA7 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN D2 [get_ports {outputs_to_pmods_1_8_tri_io[24]}]		;# JX2_HP_DP_00_P
set_property PACKAGE_PIN D1 [get_ports {outputs_to_pmods_1_8_tri_io[25]}]		;# JX2_HP_DP_00_N
set_property PACKAGE_PIN A3 [get_ports {outputs_to_pmods_1_8_tri_io[26]}]		;# JX2_HP_DP_01_P
set_property PACKAGE_PIN A2 [get_ports {outputs_to_pmods_1_8_tri_io[27]}]		;# JX2_HP_DP_01_N
# JA7 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN C1 [get_ports {inputs_from_pmods_1_8_tri_io[24]}]	    ;# JX2_HP_DP_02_P
set_property PACKAGE_PIN B1 [get_ports {inputs_from_pmods_1_8_tri_io[25]}]	    ;# JX2_HP_DP_02_N
set_property PACKAGE_PIN H4 [get_ports {inputs_from_pmods_1_8_tri_io[26]}]	    ;# JX2_HP_DP_03_P
set_property PACKAGE_PIN H3 [get_ports {inputs_from_pmods_1_8_tri_io[27]}]	    ;# JX2_HP_DP_03_N

# JA8 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN G2 [get_ports {outputs_to_pmods_1_8_tri_io[28]}]		;# JX2_HP_DP_04_P
set_property PACKAGE_PIN F2 [get_ports {outputs_to_pmods_1_8_tri_io[29]}]		;# JX2_HP_DP_04_N
set_property PACKAGE_PIN G3 [get_ports {outputs_to_pmods_1_8_tri_io[30]}]		;# JX2_HP_DP_05_P
set_property PACKAGE_PIN F3 [get_ports {outputs_to_pmods_1_8_tri_io[31]}]		;# JX2_HP_DP_05_N
# JA8 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN E2 [get_ports {inputs_from_pmods_1_8_tri_io[28]}]	    ;# JX2_HP_DP_06_P
set_property PACKAGE_PIN E1 [get_ports {inputs_from_pmods_1_8_tri_io[29]}]	    ;# JX2_HP_DP_06_N
set_property PACKAGE_PIN F4 [get_ports {inputs_from_pmods_1_8_tri_io[30]}]	    ;# JX2_HP_DP_07_P
set_property PACKAGE_PIN E4 [get_ports {inputs_from_pmods_1_8_tri_io[31]}]	    ;# JX2_HP_DP_07_N

# JA9 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN B7 [get_ports {outputs_to_pmods_9_12_tri_io[0]}]		;# JX2_HP_DP_08_P
set_property PACKAGE_PIN A7 [get_ports {outputs_to_pmods_9_12_tri_io[1]}]		;# JX2_HP_DP_08_N
set_property PACKAGE_PIN C6 [get_ports {outputs_to_pmods_9_12_tri_io[2]}]		;# JX2_HP_DP_09_P
set_property PACKAGE_PIN B6 [get_ports {outputs_to_pmods_9_12_tri_io[3]}]		;# JX2_HP_DP_09_N
# JA9 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN D7 [get_ports {inputs_from_pmods_9_12_tri_io[0]}]	    ;# JX2_HP_DP_10_GC_P
set_property PACKAGE_PIN D6 [get_ports {inputs_from_pmods_9_12_tri_io[1]}]	    ;# JX2_HP_DP_10_GC_N
set_property PACKAGE_PIN E6 [get_ports {inputs_from_pmods_9_12_tri_io[2]}]	    ;# JX2_HP_DP_11_GC_P
set_property PACKAGE_PIN E5 [get_ports {inputs_from_pmods_9_12_tri_io[3]}]	    ;# JX2_HP_DP_11_GC_N

# JA10 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN C4 [get_ports {outputs_to_pmods_9_12_tri_io[4]}]		;# JX2_HP_DP_12_GC_P
set_property PACKAGE_PIN C3 [get_ports {outputs_to_pmods_9_12_tri_io[5]}]		;# JX2_HP_DP_12_GC_N
set_property PACKAGE_PIN D4 [get_ports {outputs_to_pmods_9_12_tri_io[6]}]		;# JX2_HP_DP_13_GC_P
set_property PACKAGE_PIN D3 [get_ports {outputs_to_pmods_9_12_tri_io[7]}]		;# JX2_HP_DP_13_GC_N
# JA10 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN A9 [get_ports {inputs_from_pmods_9_12_tri_io[4]}]	    ;# JX2_HP_DP_14_P
set_property PACKAGE_PIN A8 [get_ports {inputs_from_pmods_9_12_tri_io[5]}]	    ;# JX2_HP_DP_14_N
set_property PACKAGE_PIN C5 [get_ports {inputs_from_pmods_9_12_tri_io[6]}]	    ;# JX2_HP_DP_15_P
set_property PACKAGE_PIN B5 [get_ports {inputs_from_pmods_9_12_tri_io[7]}]	    ;# JX2_HP_DP_15_N

# JA11 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN C8 [get_ports {outputs_to_pmods_9_12_tri_io[8]}]		;# JX2_HP_DP_16_P
set_property PACKAGE_PIN B8 [get_ports {outputs_to_pmods_9_12_tri_io[9]}]		;# JX2_HP_DP_16_N
set_property PACKAGE_PIN H1 [get_ports {outputs_to_pmods_9_12_tri_io[10]}]	    ;# JX2_HP_DP_17_P
set_property PACKAGE_PIN G1 [get_ports {outputs_to_pmods_9_12_tri_io[11]}]	    ;# JX2_HP_DP_17_N
# JA11 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN A6 [get_ports {inputs_from_pmods_9_12_tri_io[8]}]	    ;# JX2_HP_DP_18_P
set_property PACKAGE_PIN A5 [get_ports {inputs_from_pmods_9_12_tri_io[9]}]	    ;# JX2_HP_DP_18_N
set_property PACKAGE_PIN G7 [get_ports {inputs_from_pmods_9_12_tri_io[10]}]	    ;# JX2_HP_DP_19_P
set_property PACKAGE_PIN F7 [get_ports {inputs_from_pmods_9_12_tri_io[11]}]	    ;# JX2_HP_DP_19_N

# JA12 Pins 1, 2, 3, and 4
set_property PACKAGE_PIN H6 [get_ports {outputs_to_pmods_9_12_tri_io[12]}]	    ;# JX2_HP_DP_20_P
set_property PACKAGE_PIN G6 [get_ports {outputs_to_pmods_9_12_tri_io[13]}]	    ;# JX2_HP_DP_20_N
set_property PACKAGE_PIN G8 [get_ports {outputs_to_pmods_9_12_tri_io[14]}]	    ;# JX2_HP_DP_21_P
set_property PACKAGE_PIN F8 [get_ports {outputs_to_pmods_9_12_tri_io[15]}]	    ;# JX2_HP_DP_21_N
# JA12 Pins 7, 8, 9, and 10
set_property PACKAGE_PIN G5 [get_ports {inputs_from_pmods_9_12_tri_io[12]}]	    ;# JX2_HP_DP_22_P
set_property PACKAGE_PIN F5 [get_ports {inputs_from_pmods_9_12_tri_io[13]}]	    ;# JX2_HP_DP_22_N
set_property PACKAGE_PIN B3 [get_ports {inputs_from_pmods_9_12_tri_io[14]}]	    ;# JX2_HP_DP_23_P
set_property PACKAGE_PIN B2 [get_ports {inputs_from_pmods_9_12_tri_io[15]}]	    ;# JX2_HP_DP_23_N


set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[3]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[11]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[15]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[18]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[19]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[20]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[21]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[22]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[23]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[24]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[25]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[26]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[27]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[28]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[29]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[30]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_1_8_tri_io[31]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[3]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[11]}]

set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_pmods_9_12_tri_io[15]}]



set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[3]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[11]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[15]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[18]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[19]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[20]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[21]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[22]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[23]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[24]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[25]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[26]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[27]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[28]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[29]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[30]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_1_8_tri_io[31]}]


set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[3]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[11]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_pmods_9_12_tri_io[15]}]



# JX1/JX2 Unused Pins Loopback Test

set_property PACKAGE_PIN U3 [get_ports {outputs_to_jx1_jx2_tri_io[0]}]		;# JX1_HP_DP_29_P
set_property PACKAGE_PIN U1 [get_ports {outputs_to_jx1_jx2_tri_io[1]}]		;# JX1_HP_DP_31_P
set_property PACKAGE_PIN K4 [get_ports {outputs_to_jx1_jx2_tri_io[2]}]		;# JX1_HP_DP_33_P
set_property PACKAGE_PIN K6 [get_ports {outputs_to_jx1_jx2_tri_io[3]}]		;# JX1_HP_DP_35_P
set_property PACKAGE_PIN M3 [get_ports {outputs_to_jx1_jx2_tri_io[4]}]		;# JX1_HP_DP_37_GC_P
set_property PACKAGE_PIN N5 [get_ports {outputs_to_jx1_jx2_tri_io[5]}]		;# JX1_HP_DP_38_P
set_property PACKAGE_PIN M6 [get_ports {outputs_to_jx1_jx2_tri_io[6]}]		;# JX1_HP_DP_40_P
set_property PACKAGE_PIN AC1 [get_ports {outputs_to_jx1_jx2_tri_io[7]}]		;# JX1_HP_SE_01
set_property PACKAGE_PIN M7 [get_ports {outputs_to_jx1_jx2_tri_io[8]}]		;# JX1_HP_SE_04
set_property PACKAGE_PIN V4 [get_ports {outputs_to_jx1_jx2_tri_io[9]}]		;# JX1_HP_SE_00
set_property PACKAGE_PIN E7 [get_ports {outputs_to_jx1_jx2_tri_io[10]}]	    ;# JX2_HP_SE_01
set_property PACKAGE_PIN D8 [get_ports {outputs_to_jx1_jx2_tri_io[11]}]	    ;# JX2_HP_SE_00
set_property PACKAGE_PIN T2 [get_ports {outputs_to_jx1_jx2_tri_io[12]}]	    ;# JX2_HP_SE_05

set_property PACKAGE_PIN V3 [get_ports {inputs_from_jx1_jx2_tri_io[0]}]	    ;# JX1_HP_DP_29_N
set_property PACKAGE_PIN V1 [get_ports {inputs_from_jx1_jx2_tri_io[1]}]	    ;# JX1_HP_DP_31_N
set_property PACKAGE_PIN J4 [get_ports {inputs_from_jx1_jx2_tri_io[2]}]	    ;# JX1_HP_DP_33_N
set_property PACKAGE_PIN K5 [get_ports {inputs_from_jx1_jx2_tri_io[3]}]	    ;# JX1_HP_DP_35_N
set_property PACKAGE_PIN L3 [get_ports {inputs_from_jx1_jx2_tri_io[4]}]	    ;# JX1_HP_DP_37_GC_N
set_property PACKAGE_PIN M5 [get_ports {inputs_from_jx1_jx2_tri_io[5]}]	    ;# JX1_HP_DP_38_N
set_property PACKAGE_PIN L5 [get_ports {inputs_from_jx1_jx2_tri_io[6]}]	    ;# JX1_HP_DP_40_N
set_property PACKAGE_PIN AC5 [get_ports {inputs_from_jx1_jx2_tri_io[7]}]	;# JX1_HP_SE_03
set_property PACKAGE_PIN L4 [get_ports {inputs_from_jx1_jx2_tri_io[8]}]	    ;# JX1_HP_SE_05
set_property PACKAGE_PIN V5 [get_ports {inputs_from_jx1_jx2_tri_io[9]}]	    ;# JX1_HP_SE_02
set_property PACKAGE_PIN H5 [get_ports {inputs_from_jx1_jx2_tri_io[10]}]	;# JX2_HP_SE_03
set_property PACKAGE_PIN A4 [get_ports {inputs_from_jx1_jx2_tri_io[11]}]	;# JX2_HP_SE_02
set_property PACKAGE_PIN F10 [get_ports {inputs_from_jx1_jx2_tri_io[12]}]	;# JX2_HD_SE_11_N



set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {outputs_to_jx1_jx2_tri_io[12]}]

set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {inputs_from_jx1_jx2_tri_io[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_jx1_jx2_tri_io[12]}]




# Arduino Loopback Test

set_property PACKAGE_PIN E12 [get_ports {outputs_to_arduino_tri_io[0]}]		;# JX2_HD_SE_08_P
set_property PACKAGE_PIN G12 [get_ports {outputs_to_arduino_tri_io[1]}]		;# JX2_HD_SE_09_P
set_property PACKAGE_PIN H11 [get_ports {outputs_to_arduino_tri_io[2]}]		;# JX2_HD_SE_10_P
set_property PACKAGE_PIN H10 [get_ports {outputs_to_arduino_tri_io[3]}]		;# JX2_HD_SE_00_P
set_property PACKAGE_PIN C10 [get_ports {outputs_to_arduino_tri_io[4]}]		;# JX2_HD_SE_01_P
set_property PACKAGE_PIN B11 [get_ports {outputs_to_arduino_tri_io[5]}]		;# JX2_HD_SE_02_P
set_property PACKAGE_PIN B12 [get_ports {outputs_to_arduino_tri_io[6]}]		;# JX2_HD_SE_03_P
set_property PACKAGE_PIN E11 [get_ports {outputs_to_arduino_tri_io[7]}]		;# JX2_HD_SE_04_GC_P
set_property PACKAGE_PIN F9 [get_ports {outputs_to_arduino_tri_io[8]}]		;# JX2_HD_SE_05_GC_P
set_property PACKAGE_PIN D9 [get_ports {outputs_to_arduino_tri_io[9]}]		;# JX2_HD_SE_06_GC_P
set_property PACKAGE_PIN D11 [get_ports {outputs_to_arduino_tri_io[10]}]	;# JX2_HD_SE_07_GC_P

set_property PACKAGE_PIN D12 [get_ports {inputs_from_arduino_tri_io[0]}]	 ;# JX2_HD_SE_08_N
set_property PACKAGE_PIN F12 [get_ports {inputs_from_arduino_tri_io[1]}]	 ;# JX2_HD_SE_09_N
set_property PACKAGE_PIN G11 [get_ports {inputs_from_arduino_tri_io[2]}]	 ;# JX2_HD_SE_10_N
set_property PACKAGE_PIN H9 [get_ports {inputs_from_arduino_tri_io[3]}]	     ;# JX2_HD_SE_00_N
set_property PACKAGE_PIN B10 [get_ports {inputs_from_arduino_tri_io[4]}]	 ;# JX2_HD_SE_01_N
set_property PACKAGE_PIN A10 [get_ports {inputs_from_arduino_tri_io[5]}]	 ;# JX2_HD_SE_02_N
set_property PACKAGE_PIN A12 [get_ports {inputs_from_arduino_tri_io[6]}]	 ;# JX2_HD_SE_03_N
set_property PACKAGE_PIN E10 [get_ports {inputs_from_arduino_tri_io[7]}]	 ;# JX2_HD_SE_04_GC_N
set_property PACKAGE_PIN E9 [get_ports {inputs_from_arduino_tri_io[8]}]	     ;# JX2_HD_SE_05_GC_N
set_property PACKAGE_PIN C9 [get_ports {inputs_from_arduino_tri_io[9]}]	     ;# JX2_HD_SE_06_GC_N
set_property PACKAGE_PIN C11 [get_ports {inputs_from_arduino_tri_io[10]}]	 ;# JX2_HD_SE_07_GC_N



set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {outputs_to_arduino_tri_io[10]}]

set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {inputs_from_arduino_tri_io[10]}]
