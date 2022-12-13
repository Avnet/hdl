# ----------------------------------------------------------------------------
#
#        ** **        **          **  ****      **  **********  ********** ®
#       **   **        **        **   ** **     **  **              **
#      **     **        **      **    **  **    **  **              **
#     **       **        **    **     **   **   **  *********       **
#    **         **        **  **      **    **  **  **              **
#   **           **        ****       **     ** **  **              **
#  **  .........  **        **        **      ****  **********      **
#     ...........
#                                     Reach Further™
#
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions to the MicroZed community support forum:
#     http://avnet.me/microzed_forum
#
#  Product information is available at:
#     http://avnet.me/microzed
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2017 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# DIP switches 4-bits - Bank 35
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN J16 [get_ports {dip_sw_4bits_tri_i[3]}]
set_property PACKAGE_PIN K16 [get_ports {dip_sw_4bits_tri_i[2]}]
set_property PACKAGE_PIN M15 [get_ports {dip_sw_4bits_tri_i[1]}]
set_property PACKAGE_PIN M14 [get_ports {dip_sw_4bits_tri_i[0]}]

# ----------------------------------------------------------------------------
# Pushbutton switches 4-bits - Bank 35
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN H20 [get_ports {pb_sw_4bits_tri_i[3]}]
set_property PACKAGE_PIN J20 [get_ports {pb_sw_4bits_tri_i[2]}]
set_property PACKAGE_PIN G20 [get_ports {pb_sw_4bits_tri_i[1]}]
set_property PACKAGE_PIN G19 [get_ports {pb_sw_4bits_tri_i[0]}]

# ----------------------------------------------------------------------------
# LEDs 8-bits - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN R14 [get_ports {leds_8bits_tri_o[7]}]
set_property PACKAGE_PIN P14 [get_ports {leds_8bits_tri_o[6]}]
set_property PACKAGE_PIN V13 [get_ports {leds_8bits_tri_o[5]}]
set_property PACKAGE_PIN R19 [get_ports {leds_8bits_tri_o[4]}]
set_property PACKAGE_PIN U19 [get_ports {leds_8bits_tri_o[3]}]
set_property PACKAGE_PIN U18 [get_ports {leds_8bits_tri_o[2]}]
set_property PACKAGE_PIN U15 [get_ports {leds_8bits_tri_o[1]}]
set_property PACKAGE_PIN U14 [get_ports {leds_8bits_tri_o[0]}]

# ----------------------------------------------------------------------------
# JA Pmod - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN T15 [get_ports {pmod_ja_in_tri_i[3]}]
set_property PACKAGE_PIN T14 [get_ports {pmod_ja_in_tri_i[2]}]
set_property PACKAGE_PIN W13 [get_ports {pmod_ja_in_tri_i[1]}]
set_property PACKAGE_PIN V12 [get_ports {pmod_ja_in_tri_i[0]}]
set_property PACKAGE_PIN U12 [get_ports {pmod_ja_out_tri_o[3]}]
set_property PACKAGE_PIN T12 [get_ports {pmod_ja_out_tri_o[2]}]
set_property PACKAGE_PIN T10 [get_ports {pmod_ja_out_tri_o[1]}]
set_property PACKAGE_PIN T11 [get_ports {pmod_ja_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JB Pmod - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN W15 [get_ports {pmod_jb_in_tri_i[3]}]
set_property PACKAGE_PIN V15 [get_ports {pmod_jb_in_tri_i[2]}]
set_property PACKAGE_PIN U17 [get_ports {pmod_jb_in_tri_i[1]}]
set_property PACKAGE_PIN T16 [get_ports {pmod_jb_in_tri_i[0]}]
set_property PACKAGE_PIN Y14 [get_ports {pmod_jb_out_tri_o[3]}]
set_property PACKAGE_PIN W14 [get_ports {pmod_jb_out_tri_o[2]}]
set_property PACKAGE_PIN Y17 [get_ports {pmod_jb_out_tri_o[1]}]
set_property PACKAGE_PIN Y16 [get_ports {pmod_jb_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JC Pmod - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN W20 [get_ports {pmod_jc_in_tri_i[3]}]
set_property PACKAGE_PIN V20 [get_ports {pmod_jc_in_tri_i[2]}]
set_property PACKAGE_PIN U20 [get_ports {pmod_jc_in_tri_i[1]}]
set_property PACKAGE_PIN T20 [get_ports {pmod_jc_in_tri_i[0]}]
set_property PACKAGE_PIN P20 [get_ports {pmod_jc_out_tri_o[3]}]
set_property PACKAGE_PIN N20 [get_ports {pmod_jc_out_tri_o[2]}]
set_property PACKAGE_PIN P19 [get_ports {pmod_jc_out_tri_o[1]}]
set_property PACKAGE_PIN N18 [get_ports {pmod_jc_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JD Pmod - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN W19 [get_ports {pmod_jd_in_tri_i[3]}]
set_property PACKAGE_PIN W18 [get_ports {pmod_jd_in_tri_i[2]}]
set_property PACKAGE_PIN V18 [get_ports {pmod_jd_in_tri_i[1]}]
set_property PACKAGE_PIN V17 [get_ports {pmod_jd_in_tri_i[0]}]
set_property PACKAGE_PIN R18 [get_ports {pmod_jd_out_tri_o[3]}]
set_property PACKAGE_PIN T17 [get_ports {pmod_jd_out_tri_o[2]}]
set_property PACKAGE_PIN R17 [get_ports {pmod_jd_out_tri_o[1]}]
set_property PACKAGE_PIN R16 [get_ports {pmod_jd_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JE Pmod - Bank 35
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN F17 [get_ports {pmod_je_in_tri_i[3]}]
set_property PACKAGE_PIN F16 [get_ports {pmod_je_in_tri_i[2]}]
set_property PACKAGE_PIN E19 [get_ports {pmod_je_in_tri_i[1]}]
set_property PACKAGE_PIN E18 [get_ports {pmod_je_in_tri_i[0]}]
set_property PACKAGE_PIN D20 [get_ports {pmod_je_out_tri_o[3]}]
set_property PACKAGE_PIN D19 [get_ports {pmod_je_out_tri_o[2]}]
set_property PACKAGE_PIN D18 [get_ports {pmod_je_out_tri_o[1]}]
set_property PACKAGE_PIN E17 [get_ports {pmod_je_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JF Pmod - Bank 35
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN J19 [get_ports {pmod_jf_in_tri_i[3]}]
set_property PACKAGE_PIN K19 [get_ports {pmod_jf_in_tri_i[2]}]
set_property PACKAGE_PIN M18 [get_ports {pmod_jf_in_tri_i[1]}]
set_property PACKAGE_PIN M17 [get_ports {pmod_jf_in_tri_i[0]}]
set_property PACKAGE_PIN M20 [get_ports {pmod_jf_out_tri_o[3]}]
set_property PACKAGE_PIN M19 [get_ports {pmod_jf_out_tri_o[2]}]
set_property PACKAGE_PIN L20 [get_ports {pmod_jf_out_tri_o[1]}]
set_property PACKAGE_PIN L19 [get_ports {pmod_jf_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JG Pmod - Bank 35
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN H18 [get_ports {pmod_jg_in_tri_i[3]}]
set_property PACKAGE_PIN J18 [get_ports {pmod_jg_in_tri_i[2]}]
set_property PACKAGE_PIN H17 [get_ports {pmod_jg_in_tri_i[1]}]
set_property PACKAGE_PIN H16 [get_ports {pmod_jg_in_tri_i[0]}]
set_property PACKAGE_PIN F20 [get_ports {pmod_jg_out_tri_o[3]}]
set_property PACKAGE_PIN F19 [get_ports {pmod_jg_out_tri_o[2]}]
set_property PACKAGE_PIN G18 [get_ports {pmod_jg_out_tri_o[1]}]
set_property PACKAGE_PIN G17 [get_ports {pmod_jg_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JH Pmod - Bank 35
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN L15 [get_ports {pmod_jh_in_tri_i[3]}]
set_property PACKAGE_PIN L14 [get_ports {pmod_jh_in_tri_i[2]}]
set_property PACKAGE_PIN N16 [get_ports {pmod_jh_in_tri_i[1]}]
set_property PACKAGE_PIN N15 [get_ports {pmod_jh_in_tri_i[0]}]
set_property PACKAGE_PIN G15 [get_ports {pmod_jh_out_tri_o[3]}]
set_property PACKAGE_PIN H15 [get_ports {pmod_jh_out_tri_o[2]}]
set_property PACKAGE_PIN J14 [get_ports {pmod_jh_out_tri_o[1]}]
set_property PACKAGE_PIN K14 [get_ports {pmod_jh_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JK Pmod - Bank 34
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN P16 [get_ports {pmod_jk_in_tri_i[3]}]
set_property PACKAGE_PIN P15 [get_ports {pmod_jk_in_tri_i[2]}]
set_property PACKAGE_PIN P18 [get_ports {pmod_jk_in_tri_i[1]}]
set_property PACKAGE_PIN N17 [get_ports {pmod_jk_in_tri_i[0]}]
set_property PACKAGE_PIN W16 [get_ports {pmod_jk_out_tri_o[3]}]
set_property PACKAGE_PIN V16 [get_ports {pmod_jk_out_tri_o[2]}]
set_property PACKAGE_PIN Y19 [get_ports {pmod_jk_out_tri_o[1]}]
set_property PACKAGE_PIN Y18 [get_ports {pmod_jk_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JY Pmod - Bank 13 (Available on Z7020 device only)
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN U5 [get_ports {pmod_jy_in_tri_i[3]}]
set_property PACKAGE_PIN T5 [get_ports {pmod_jy_in_tri_i[2]}]
set_property PACKAGE_PIN W8 [get_ports {pmod_jy_in_tri_i[1]}]
set_property PACKAGE_PIN V8 [get_ports {pmod_jy_in_tri_i[0]}]
set_property PACKAGE_PIN U10 [get_ports {pmod_jy_out_tri_o[3]}]
set_property PACKAGE_PIN T9 [get_ports {pmod_jy_out_tri_o[2]}]
set_property PACKAGE_PIN V7 [get_ports {pmod_jy_out_tri_o[1]}]
set_property PACKAGE_PIN U7 [get_ports {pmod_jy_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# JZ Pmod - Bank 13 (Available on Z7020 device only)
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN W6 [get_ports {pmod_jz_in_tri_i[2]}]
set_property PACKAGE_PIN V6 [get_ports {pmod_jz_in_tri_i[1]}]
set_property PACKAGE_PIN V5 [get_ports {pmod_jz_in_tri_i[0]}]
set_property PACKAGE_PIN V10 [get_ports {pmod_jz_out_tri_o[2]}]
set_property PACKAGE_PIN V11 [get_ports {pmod_jz_out_tri_o[1]}]
set_property PACKAGE_PIN Y13 [get_ports {pmod_jz_out_tri_o[0]}]

# ----------------------------------------------------------------------------
# IOSTANDARD Constraints
# ----------------------------------------------------------------------------
set_property IOSTANDARD LVCMOS33 [get_ports {dip_sw_4bits*}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_8bits*}]
set_property IOSTANDARD LVCMOS33 [get_ports {pb_sw_4bits*}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_j*}]
