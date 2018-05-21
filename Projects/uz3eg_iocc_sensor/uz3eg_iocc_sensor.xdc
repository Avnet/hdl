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
#  Jan 06, 2017
#
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
# 
# ----------------------------------------------------------------------------

# Arduino IIC

set_property PACKAGE_PIN C11 [get_ports arduino_iic_scl_io]				;# JX2_HD_SE_07_GC_N
set_property PACKAGE_PIN D11 [get_ports arduino_iic_sda_io]             ;# JX2_HD_SE_07_GC_P
set_property IOSTANDARD LVCMOS33 [get_ports arduino_iic_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports arduino_iic_sda_io]

# JX2 JE Pmod (SPI)

set_property PACKAGE_PIN C8 [get_ports {jx2_je_pmod_spi_ss_io[0]}]		;# JX2_HP_DP_16_P
set_property PACKAGE_PIN B8 [get_ports jx2_je_pmod_spi_io0_io]			;# JX2_HP_DP_16_N
set_property PACKAGE_PIN H1 [get_ports jx2_je_pmod_spi_io1_io]          ;# JX2_HP_DP_17_P
set_property PACKAGE_PIN G1 [get_ports jx2_je_pmod_spi_sck_io]          ;# JX2_HP_DP_17_N
set_property IOSTANDARD LVCMOS18 [get_ports {jx2_je_pmod_spi_ss_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports jx2_je_pmod_spi_io0_io]
set_property IOSTANDARD LVCMOS18 [get_ports jx2_je_pmod_spi_io1_io]
set_property IOSTANDARD LVCMOS18 [get_ports jx2_je_pmod_spi_sck_io]

# JX2 JF Pmod (IIC)

set_property PACKAGE_PIN F8 [get_ports jx2_jf_pmod_iic_sda_io]			;# JX2_HP_DP_21_N
set_property PACKAGE_PIN G8 [get_ports jx2_jf_pmod_iic_scl_io]			;# JX2_HP_DP_21_P
set_property IOSTANDARD LVCMOS18 [get_ports jx2_jf_pmod_iic_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports jx2_jf_pmod_iic_scl_io]

# PL LEDs 

set_property PACKAGE_PIN R7 [get_ports {led_6bits[0]}]              	;# JX1_HP_DP_25_P
set_property PACKAGE_PIN T5 [get_ports {led_6bits[1]}]              	;# JX1_HP_DP_24_P
set_property PACKAGE_PIN T7 [get_ports {led_6bits[2]}]              	;# JX1_HP_DP_25_N
set_property PACKAGE_PIN T4 [get_ports {led_6bits[3]}]              	;# JX1_HP_DP_24_N
set_property PACKAGE_PIN T3 [get_ports {led_6bits[4]}]              	;# JX1_HP_DP_27_P
set_property PACKAGE_PIN U2 [get_ports {led_6bits[5]}]              	;# JX1_HP_DP_27_N
set_property PACKAGE_PIN U6 [get_ports {led_2bits_tri_o[0]}]        	;# JX1_HP_DP_26_P
set_property PACKAGE_PIN U5 [get_ports {led_2bits_tri_o[1]}]        	;# JX1_HP_DP_26_N
set_property IOSTANDARD LVCMOS18 [get_ports {led_6bits[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_6bits[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_6bits[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_6bits[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_6bits[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_6bits[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_2bits_tri_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_2bits_tri_o[1]}]


# ST Micro X-NUCLEO-IKS01A1 Sensor Arduino shield data DRDY and INT inputs

set_property PACKAGE_PIN B12 [get_ports {HTS221_DRDY[0]}]				;# JX2_HD_SE_03_P
set_property PACKAGE_PIN A10 [get_ports {LPS25H_INT1[0]}]				;# JX2_HD_SE_02_N
set_property PACKAGE_PIN B11 [get_ports {LSM6DS0_INT1[0]}]				;# JX2_HD_SE_02_P
set_property PACKAGE_PIN H11 [get_ports {LIS3MDL_INT1[0]}]				;# JX2_HD_SE_10_P
set_property PACKAGE_PIN G11 [get_ports {LIS3MDL_DRDY[0]}]				;# JX2_HD_SE_10_N
set_property IOSTANDARD LVCMOS33 [get_ports {LIS3MDL_DRDY[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LSM6DS0_INT1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LPS25H_INT1[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HTS221_DRDY[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LIS3MDL_INT1[0]}]
