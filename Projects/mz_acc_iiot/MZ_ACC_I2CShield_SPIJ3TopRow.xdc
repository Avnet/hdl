# ----------------------------------------------------------------------------
# PL Pmod J3
# ---------------------------------------------------------------------------- 
# Bank 35 / JX2
set_property PACKAGE_PIN G17 [ get_ports spi_rtl_ss_io ];        # "G17.JX2_LVDS_14_P.JX2.61.D0_P"
set_property PACKAGE_PIN G18 [ get_ports spi_rtl_io0_io ];       # "G18.JX2_LVDS_14_N.JX2.63.D0_N"
set_property PACKAGE_PIN F19 [ get_ports spi_rtl_io1_io ];       # "F19.JX2_LVDS_15_P.JX2.62.D1_P"
set_property PACKAGE_PIN F20 [ get_ports spi_rtl_sck_io ];       # "F20.JX2_LVDS_15_N.JX2.64.D1_N"

# ----------------------------------------------------------------------------
# Arduino Shield Connector JA1 / X-NUCLEO CN9
# ---------------------------------------------------------------------------- 
# Bank 34 / JX1
#set_property PACKAGE_PIN W20 [get_ports {NetJA1_1       }];  # "W20.JX1_LVDS_15_N.JX1.56.NetJA1_1"
#set_property PACKAGE_PIN V20 [get_ports {NetJA1_2       }];  # "V20.JX1_LVDS_15_P.JX1.54.NetJA1_2"
#set_property PACKAGE_PIN U20 [get_ports {USER_INT       }];  # "U20.JX1_LVDS_14_N.JX1.55.NetJA1_3"
#set_property PACKAGE_PIN T20 [get_ports {NetJA1_4       }];  # "T20.JX1_LVDS_14_P.JX1.53.NetJA1_4"
set_property PACKAGE_PIN P20 [get_ports {LSM6DS0_INT1       }];  # "P20.JX1_LVDS_13_N.JX1.50.NetJA1_5"
set_property PACKAGE_PIN N20 [get_ports {LPS25H_INT1       }];  # "N20.JX1_LVDS_13_P.JX1.48.NetJA1_6"
set_property PACKAGE_PIN P19 [get_ports {HTS221_DRDY       }];  # "P19.JX1_LVDS_12_N.JX1.49.NetJA1_7"
#set_property PACKAGE_PIN N18 [get_ports {NetJA1_8       }];  # "N18.JX1_LVDS_12_P.JX1.47.NetJA1_8"

# ----------------------------------------------------------------------------
# Arduino Shield Connector JA2 / X-NUCLEO CN5
# ---------------------------------------------------------------------------- 
# Bank 34 / JX1
#set_property PACKAGE_PIN W15 [get_ports {NetJA2_1       }];  # "W15.JX1_LVDS_9_N.JX1.38.NetJA2_1"
#set_property PACKAGE_PIN V15 [get_ports {NetJA2_2       }];  # "V15.JX1_LVDS_9_P.JX1.36.NetJA2_2"
#set_property PACKAGE_PIN U17 [get_ports {NetJA2_3       }];  # "U17.JX1_LVDS_8_N.JX1.37.NetJA2_3"
#set_property PACKAGE_PIN T16 [get_ports {NetJA2_4       }];  # "T16.JX1_LVDS_8_P.JX1.35.NetJA2_4"
#set_property PACKAGE_PIN Y14 [get_ports {NetJA2_5       }];  # "Y14.JX1_LVDS_7_N.JX1.32.NetJA2_5"
#set_property PACKAGE_PIN W14 [get_ports {NetJA2_6       }];  # "W14.JX1_LVDS_7_P.JX1.30.NetJA2_6"
set_property PACKAGE_PIN Y17 [get_ports {iic_rtl_sda_io       }];  # "Y17.JX1_LVDS_6_N.JX1.31.NetJA2_9"
set_property PACKAGE_PIN Y16 [get_ports {iic_rtl_scl_io      }];  # "Y16.JX1_LVDS_6_P.JX1.29.NetJA2_10"

# ----------------------------------------------------------------------------
# Arduino Shield Connector JA4 / X-NUCLEO CN8
# ---------------------------------------------------------------------------- 
# Bank 34 / JX1
#set_property PACKAGE_PIN K9  [get_ports {NetJA4_1       }];  # "K9.NetJX1_97.JX1.97.NetJA4_1"
#set_property PACKAGE_PIN L10 [get_ports {NetJA4_2       }];  # "L10.NetJX1_99.JX1.99.NetJA4_2"
#set_property PACKAGE_PIN M9  [get_ports {M_INT1       }];  # "M9.NetJX1_98.JX1.98.NetJA4_3"
#set_property PACKAGE_PIN M10 [get_ports {M_INT2       }];  # "M10.NetJX1_100.JX1.100.NetJA4_4"
# Bank 35 / JX2
set_property PACKAGE_PIN J15 [get_ports {LIS3MDL_INT1       }];  # "J15.JX2_SE_1.JX2.14.NetJA4_5"
set_property PACKAGE_PIN B19 [get_ports {LIS3MDL_DRDY       }];  # "B19.JX2_LVDS_1_P.JX2.18.NetJA4_6"

# Set the bank voltage for IO Bank 34 to 3.3V
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 3.3V
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
