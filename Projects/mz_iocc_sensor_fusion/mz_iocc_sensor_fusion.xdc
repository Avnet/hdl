########################
# Physical Constraints #
########################

#
# MicroZed with IO Carrier - Sensor Fusion I/O constraints
#

# ----------------------------------------------------------------------------
# PL Pmod JA
# ---------------------------------------------------------------------------- 
# SPI Interface on the VADJ 
# powered Bank 34 JB Pmod expansion connector.

set_property PACKAGE_PIN T11 [ get_ports spi0_ss_inv_o ];    # "T11.JX1_LVDS_0_P.JX1.11.JA0-1_P" - Pin 1
set_property IOSTANDARD LVCMOS33 [ get_ports spi0_ss_inv_o ];    

set_property PACKAGE_PIN T10 [ get_ports spi0_io0_o ];       # "T10.JX1_LVDS_0_N.JX1.13.JA0-1_N" - Pin 2
set_property IOSTANDARD LVCMOS33 [ get_ports spi0_io0_o ];

set_property PACKAGE_PIN T12 [ get_ports spi0_io1_i ];       # "T12.JX1_LVDS_1_P.JX1.12.JA2-3_P" - Pin 3
set_property IOSTANDARD LVCMOS33 [ get_ports spi0_io1_i ];

set_property PACKAGE_PIN U12 [ get_ports spi0_sck_o ];       # "U12.JX1_LVDS_1_N.JX1.14.JA2-3_N" - Pin 4
set_property IOSTANDARD LVCMOS33 [ get_ports spi0_sck_o ];


# ----------------------------------------------------------------------------
# PL Pmod JB
# ---------------------------------------------------------------------------- 
# SPI Interface on the VADJ 
# powered Bank 34 JB Pmod expansion connector.

#set_property PACKAGE_PIN Y16 [ get_ports spi0_ss_inv_o ];    # "Y16.JX1_LVDS_6_P.JX1.29.JB0-1_P" - Pin 1
#set_property IOSTANDARD LVCMOS33 [ get_ports spi0_ss_inv_o ];    

#set_property PACKAGE_PIN Y17 [ get_ports spi0_io0_o ];       # "Y17.JX1_LVDS_6_N.JX1.31.JB0-1_N" - Pin 2
#set_property IOSTANDARD LVCMOS33 [ get_ports spi0_io0_o ];

#set_property PACKAGE_PIN W14 [ get_ports spi0_io1_i ];       # "W14.JX1_LVDS_7_P.JX1.30.JB2-3_P" - Pin 3
#set_property IOSTANDARD LVCMOS33 [ get_ports spi0_io1_i ];

#set_property PACKAGE_PIN Y14 [ get_ports spi0_sck_o ];       # "Y14.JX1_LVDS_7_N.JX1.32.JB2-3_N" - Pin 4
#set_property IOSTANDARD LVCMOS33 [ get_ports spi0_sck_o ];


