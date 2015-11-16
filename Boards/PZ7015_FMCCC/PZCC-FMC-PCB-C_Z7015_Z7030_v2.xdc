
#     _____
#    /     \
#   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET ELECTRONICS MARKETING
#      \======/         www.picozed.org
#       \====/    
# ----------------------------------------------------------------------------
# 
#  Created With Avnet Constraints Generator V0.8.0 
#     Date: Thursday, April 2, 2015 
#     Time: 5:29:46 PM 
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#  
#  Please direct any questions to:
#     Avnet Technical Community Forums
#     http://picozed.org/forum
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2015 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Notes: 
#
#  Thursday, April 16, 2015
#
#     IO standards based upon Bank 34, Bank 35 Vcco supply 
#     of 1.8V requires bank VCCO voltage to be set to 1.8V.  Bank 13 Vcco
#     supply is set at 3.3V
#
#     WARNING!! Bank 34 and Bank 35 on the 7030 device are High Performance
#     banks so VADJ must be limited to 1.8V for 7030. Failure to limit Bank 34
#     and Bank 35 to 1.8V signals can damage the Zynq 7030!
#
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
#
#     The string provided in the comment field provides the Zynq device pin 
#     mapping through the expansion connector to the carrier card net name
#     according to the following format:
#
#     "<Zynq Pin>.<SOM Net>.<Connector Ref>.<Connector Pin>.<Carrier Net>"
# 
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# FMC Expansion Connector - Bank 35
# ---------------------------------------------------------------------------- 

set_property PACKAGE_PIN B3   [get_ports {CLK0_C2M_N      }];  # "B3.JX1_LVDS_12_N.JX1.49.CLK0_C2M_N"
set_property PACKAGE_PIN B4   [get_ports {CLK0_C2M_P      }];  # "B4.JX1_LVDS_12_P.JX1.47.CLK0_C2M_P"
set_property PACKAGE_PIN H6   [get_ports {FMC_SCL         }];  # "H6.JX1_SE_0.JX1.9.FMC_SCL"
set_property PACKAGE_PIN H5   [get_ports {FMC_SDA         }];  # "H5.JX1_SE_1.JX1.10.FMC_SDA"
set_property PACKAGE_PIN C4   [get_ports {LA00_CC_N       }];  # "C4.JX1_LVDS_11_N.JX1.44.LA00_CC_N"
set_property PACKAGE_PIN D5   [get_ports {LA00_CC_P       }];  # "D5.JX1_LVDS_11_P.JX1.42.LA00_CC_P"
set_property PACKAGE_PIN C5   [get_ports {LA01_CC_N       }];  # "C5.JX1_LVDS_10_N.JX1.43.LA01_CC_N"
set_property PACKAGE_PIN C6   [get_ports {LA01_CC_P       }];  # "C6.JX1_LVDS_10_P.JX1.41.LA01_CC_P"
set_property PACKAGE_PIN E5   [get_ports {LA02_N          }];  # "E5.JX1_LVDS_1_N.JX1.14.LA02_N"
set_property PACKAGE_PIN F5   [get_ports {LA02_P          }];  # "F5.JX1_LVDS_1_P.JX1.12.LA02_P"
set_property PACKAGE_PIN H3   [get_ports {LA03_N          }];  # "H3.JX1_LVDS_0_N.JX1.13.LA03_N"
set_property PACKAGE_PIN H4   [get_ports {LA03_P          }];  # "H4.JX1_LVDS_0_P.JX1.11.LA03_P"
set_property PACKAGE_PIN F1   [get_ports {LA04_N          }];  # "F1.JX1_LVDS_3_N.JX1.20.LA04_N"
set_property PACKAGE_PIN F2   [get_ports {LA04_P          }];  # "F2.JX1_LVDS_3_P.JX1.18.LA04_P"
set_property PACKAGE_PIN E3   [get_ports {LA07_N          }];  # "E3.JX1_LVDS_5_N.JX1.26.LA07_N"
set_property PACKAGE_PIN E4   [get_ports {LA07_P          }];  # "E4.JX1_LVDS_5_P.JX1.24.LA07_P"
set_property PACKAGE_PIN G2   [get_ports {LA08_N          }];  # "G2.JX1_LVDS_2_N.JX1.19.LA08_N"
set_property PACKAGE_PIN G3   [get_ports {LA08_P          }];  # "G3.JX1_LVDS_2_P.JX1.17.LA08_P"
set_property PACKAGE_PIN B1   [get_ports {LA11_N          }];  # "B1.JX1_LVDS_7_N.JX1.32.LA11_N"
set_property PACKAGE_PIN B2   [get_ports {LA11_P          }];  # "B2.JX1_LVDS_7_P.JX1.30.LA11_P"
set_property PACKAGE_PIN F4   [get_ports {LA12_N          }];  # "F4.JX1_LVDS_4_N.JX1.25.LA12_N"
set_property PACKAGE_PIN G4   [get_ports {LA12_P          }];  # "G4.JX1_LVDS_4_P.JX1.23.LA12_P"
set_property PACKAGE_PIN G1   [get_ports {LA15_N          }];  # "G1.JX1_LVDS_9_N.JX1.38.LA15_N"
set_property PACKAGE_PIN H1   [get_ports {LA15_P          }];  # "H1.JX1_LVDS_9_P.JX1.36.LA15_P"
set_property PACKAGE_PIN F6   [get_ports {LA16_N          }];  # "F6.JX1_LVDS_6_N.JX1.31.LA16_N"
set_property PACKAGE_PIN G6   [get_ports {LA16_P          }];  # "G6.JX1_LVDS_6_P.JX1.29.LA16_P"
set_property PACKAGE_PIN C3   [get_ports {LA19_N          }];  # "C3.JX1_LVDS_13_N.JX1.50.LA19_N"
set_property PACKAGE_PIN D3   [get_ports {LA19_P          }];  # "D3.JX1_LVDS_13_P.JX1.48.LA19_P"
set_property PACKAGE_PIN D8   [get_ports {LA20_N          }];  # "D8.JX1_LVDS_8_N.JX1.37.LA20_N"
set_property PACKAGE_PIN E8   [get_ports {LA20_P          }];  # "E8.JX1_LVDS_8_P.JX1.35.LA20_P"
set_property PACKAGE_PIN A1   [get_ports {LA21_N          }];  # "A1.JX1_LVDS_15_N.JX1.56.LA21_N"
set_property PACKAGE_PIN A2   [get_ports {LA21_P          }];  # "A2.JX1_LVDS_15_P.JX1.54.LA21_P"
set_property PACKAGE_PIN C1   [get_ports {LA22_N          }];  # "C1.JX1_LVDS_14_N.JX1.55.LA22_N"
set_property PACKAGE_PIN D1   [get_ports {LA22_P          }];  # "D1.JX1_LVDS_14_P.JX1.53.LA22_P"
set_property PACKAGE_PIN D6   [get_ports {LA24_N          }];  # "D6.JX1_LVDS_17_N.JX1.64.LA24_N"
set_property PACKAGE_PIN D7   [get_ports {LA24_P          }];  # "D7.JX1_LVDS_17_P.JX1.62.LA24_P"
set_property PACKAGE_PIN D2   [get_ports {LA25_N          }];  # "D2.JX1_LVDS_16_N.JX1.63.LA25_N"
set_property PACKAGE_PIN E2   [get_ports {LA25_P          }];  # "E2.JX1_LVDS_16_P.JX1.61.LA25_P"
set_property PACKAGE_PIN A4   [get_ports {LA28_N          }];  # "A4.JX1_LVDS_19_N.JX1.70.LA28_N"
set_property PACKAGE_PIN A5   [get_ports {LA28_P          }];  # "A5.JX1_LVDS_19_P.JX1.68.LA28_P"
set_property PACKAGE_PIN E7   [get_ports {LA29_N          }];  # "E7.JX1_LVDS_18_N.JX1.69.LA29_N"
set_property PACKAGE_PIN F7   [get_ports {LA29_P          }];  # "F7.JX1_LVDS_18_P.JX1.67.LA29_P"
set_property PACKAGE_PIN A6   [get_ports {LA30_N          }];  # "A6.JX1_LVDS_21_N.JX1.76.LA30_N"
set_property PACKAGE_PIN A7   [get_ports {LA30_P          }];  # "A7.JX1_LVDS_21_P.JX1.74.LA30_P"
set_property PACKAGE_PIN G7   [get_ports {LA31_N          }];  # "G7.JX1_LVDS_20_N.JX1.75.LA31_N"
set_property PACKAGE_PIN G8   [get_ports {LA31_P          }];  # "G8.JX1_LVDS_20_P.JX1.73.LA31_P"
set_property PACKAGE_PIN B8   [get_ports {LA32_N          }];  # "B8.JX1_LVDS_23_N.JX1.84.LA32_N"
set_property PACKAGE_PIN C8   [get_ports {LA32_P          }];  # "C8.JX1_LVDS_23_P.JX1.82.LA32_P"
set_property PACKAGE_PIN B6   [get_ports {LA33_N          }];  # "B6.JX1_LVDS_22_N.JX1.83.LA33_N"
set_property PACKAGE_PIN B7   [get_ports {LA33_P          }];  # "B7.JX1_LVDS_22_P.JX1.81.LA33_P"
  
# ----------------------------------------------------------------------------
# FMC Expansion Connector - Bank 34
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN T1   [get_ports {CLK0_M2C_N      }];  # "T1.JX2_LVDS_12_N.JX2.55.CLK0_M2C_N"
set_property PACKAGE_PIN T2   [get_ports {CLK0_M2C_P      }];  # "T2.JX2_LVDS_12_P.JX2.53.CLK0_M2C_P"
set_property PACKAGE_PIN R8   [get_ports {FMC_PRSNT       }];  # "R8.JX2_SE_1.JX2.14.FMC_PRSNT"
set_property PACKAGE_PIN R2   [get_ports {LA05_N          }];  # "R2.JX2_LVDS_14_N.JX2.63.LA05_N"
set_property PACKAGE_PIN R3   [get_ports {LA05_P          }];  # "R3.JX2_LVDS_14_P.JX2.61.LA05_P"
set_property PACKAGE_PIN M6   [get_ports {LA06_N          }];  # "M6.JX2_LVDS_15_N.JX2.64.LA06_N"
set_property PACKAGE_PIN L6   [get_ports {LA06_P          }];  # "L6.JX2_LVDS_15_P.JX2.62.LA06_P"
set_property PACKAGE_PIN K5   [get_ports {LA09_N          }];  # "K5.JX2_LVDS_16_N.JX2.69.LA09_N"
set_property PACKAGE_PIN J5   [get_ports {LA09_P          }];  # "J5.JX2_LVDS_16_P.JX2.67.LA09_P"
set_property PACKAGE_PIN R4   [get_ports {LA10_N          }];  # "R4.JX2_LVDS_17_N.JX2.70.LA10_N"
set_property PACKAGE_PIN R5   [get_ports {LA10_P          }];  # "R5.JX2_LVDS_17_P.JX2.68.LA10_P"
set_property PACKAGE_PIN J6   [get_ports {LA13_N          }];  # "J6.JX2_LVDS_18_N.JX2.75.LA13_N"
set_property PACKAGE_PIN J7   [get_ports {LA13_P          }];  # "J7.JX2_LVDS_18_P.JX2.73.LA13_P"
set_property PACKAGE_PIN P5   [get_ports {LA14_N          }];  # "P5.JX2_LVDS_19_N.JX2.76.LA14_N"
set_property PACKAGE_PIN P6   [get_ports {LA14_P          }];  # "P6.JX2_LVDS_19_P.JX2.74.LA14_P"
set_property PACKAGE_PIN L4   [get_ports {LA17_CC_N       }];  # "L4.JX2_LVDS_11_N.JX2.50.LA17_CC_N"
set_property PACKAGE_PIN L5   [get_ports {LA17_CC_P       }];  # "L5.JX2_LVDS_11_P.JX2.48.LA17_CC_P"
set_property PACKAGE_PIN U1   [get_ports {LA18_CC_N       }];  # "U1.JX2_LVDS_13_N.JX2.56.LA18_CC_N"
set_property PACKAGE_PIN U2   [get_ports {LA18_CC_P       }];  # "U2.JX2_LVDS_13_P.JX2.54.LA18_CC_P"
set_property PACKAGE_PIN K8   [get_ports {LA23_N          }];  # "K8.JX2_LVDS_20_N.JX2.83.LA23_N"
set_property PACKAGE_PIN J8   [get_ports {LA23_P          }];  # "J8.JX2_LVDS_20_P.JX2.81.LA23_P"
set_property PACKAGE_PIN M7   [get_ports {LA26_N          }];  # "M7.JX2_LVDS_22_N.JX2.89.LA26_N"
set_property PACKAGE_PIN M8   [get_ports {LA26_P          }];  # "M8.JX2_LVDS_22_P.JX2.87.LA26_P"
set_property PACKAGE_PIN N5   [get_ports {LA27_N          }];  # "N5.JX2_LVDS_21_N.JX2.84.LA27_N"
set_property PACKAGE_PIN N6   [get_ports {LA27_P          }];  # "N6.JX2_LVDS_21_P.JX2.82.LA27_P"

# ----------------------------------------------------------------------------
# ADV7511 HDMI Output - Bank 35
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN P7   [get_ports {ADV7511_D20     }];  # "P7.JX2_LVDS_4_P.JX2.29.ADV7511_D20"
set_property PACKAGE_PIN R7   [get_ports {ADV7511_D21     }];  # "R7.JX2_LVDS_4_N.JX2.31.ADV7511_D21"
set_property PACKAGE_PIN N4   [get_ports {ADV7511_D22     }];  # "N4.JX2_LVDS_6_P.JX2.35.ADV7511_D22"
set_property PACKAGE_PIN N3   [get_ports {ADV7511_D23     }];  # "N3.JX2_LVDS_6_N.JX2.37.ADV7511_D23"
set_property PACKAGE_PIN M2   [get_ports {ADV7511_D24     }];  # "M2.JX2_LVDS_8_P.JX2.41.ADV7511_D24"
set_property PACKAGE_PIN M1   [get_ports {ADV7511_D25     }];  # "M1.JX2_LVDS_8_N.JX2.43.ADV7511_D25"
set_property PACKAGE_PIN K4   [get_ports {ADV7511_D26     }];  # "K4.JX2_LVDS_10_P.JX2.47.ADV7511_D26"
set_property PACKAGE_PIN K3   [get_ports {ADV7511_D27     }];  # "K3.JX2_LVDS_10_N.JX2.49.ADV7511_D27"
set_property PACKAGE_PIN J3   [get_ports {ADV7511_D28     }];  # "J3.JX2_LVDS_3_P.JX2.24.ADV7511_D28"
set_property PACKAGE_PIN K2   [get_ports {ADV7511_D29     }];  # "K2.JX2_LVDS_3_N.JX2.26.ADV7511_D29"
set_property PACKAGE_PIN L2   [get_ports {ADV7511_D30     }];  # "L2.JX2_LVDS_5_P.JX2.30.ADV7511_D30"
set_property PACKAGE_PIN L1   [get_ports {ADV7511_D31     }];  # "L1.JX2_LVDS_5_N.JX2.32.ADV7511_D31"
set_property PACKAGE_PIN P3   [get_ports {ADV7511_D32     }];  # "P3.JX2_LVDS_7_P.JX2.36.ADV7511_D32"
set_property PACKAGE_PIN P2   [get_ports {ADV7511_D33     }];  # "P2.JX2_LVDS_7_N.JX2.38.ADV7511_D33"
set_property PACKAGE_PIN N1   [get_ports {ADV7511_D34     }];  # "N1.JX2_LVDS_9_P.JX2.42.ADV7511_D34"
set_property PACKAGE_PIN P1   [get_ports {ADV7511_D35     }];  # "P1.JX2_LVDS_9_N.JX2.44.ADV7511_D35"
set_property PACKAGE_PIN K7   [get_ports {ADV7511_HPD     }];  # "K7.JX2_LVDS_2_P.JX2.23.ADV7511_HPD"
set_property PACKAGE_PIN L7   [get_ports {ADV7511_INT_N   }];  # "L7.JX2_LVDS_2_N.JX2.25.ADV7511_INT_N"
set_property PACKAGE_PIN H8   [get_ports {HDMI_DE         }];  # "H8.JX2_SE_0.JX2.13.HDMI_DE"
set_property PACKAGE_PIN N8   [get_ports {HDMI_HSYNC      }];  # "N8.JX2_LVDS_23_P.JX2.88.HDMI_HSYNC"
set_property PACKAGE_PIN J1   [get_ports {HDMI_PPICLK     }];  # "J1.JX2_LVDS_1_N.JX2.20.HDMI_PPICLK"
set_property PACKAGE_PIN M4   [get_ports {HDMI_SCLK       }];  # "M4.JX2_LVDS_0_P.JX2.17.HDMI_SCLK"
set_property PACKAGE_PIN M3   [get_ports {HDMI_SDATA      }];  # "M3.JX2_LVDS_0_N.JX2.19.HDMI_SDATA"
set_property PACKAGE_PIN J2   [get_ports {HDMI_SPDIF      }];  # "J2.JX2_LVDS_1_P.JX2.18.HDMI_SPDIF"
set_property PACKAGE_PIN P8   [get_ports {HDMI_VSYNC      }];  # "P8.JX2_LVDS_23_N.JX2.90.HDMI_VSYNC"


# ----------------------------------------------------------------------------
# Ethernet - Bank 13
# ---------------------------------------------------------------------------- 

set_property PACKAGE_PIN Y14  [get_ports {ETH_MDC         }];  # "Y14.BANK13_LVDS_1_P.JX1.88.ETH_MDC"
set_property PACKAGE_PIN Y15  [get_ports {ETH_MDIO        }];  # "Y15.BANK13_LVDS_1_N.JX1.90.ETH_MDIO"
set_property PACKAGE_PIN V18  [get_ports {ETH_TX_CLK      }];  # "V18.BANK13_LVDS_3_P.JX1.92.ETH_TX_CLK"
set_property PACKAGE_PIN W18  [get_ports {ETH_TX_CTRL     }];  # "W18.BANK13_LVDS_3_N.JX1.94.ETH_TX_CTRL"
set_property PACKAGE_PIN AA14 [get_ports {ETH_TXD0        }];  # "AA14.BANK13_LVDS_0_P.JX1.87.ETH_TXD0"
set_property PACKAGE_PIN AA15 [get_ports {ETH_TXD1        }];  # "AA15.BANK13_LVDS_0_N.JX1.89.ETH_TXD1"
set_property PACKAGE_PIN U19  [get_ports {ETH_TXD2        }];  # "U19.BANK13_LVDS_2_P.JX1.91.ETH_TXD2"
set_property PACKAGE_PIN V19  [get_ports {ETH_TXD3        }];  # "V19.BANK13_LVDS_2_N.JX1.93.ETH_TXD3"
set_property PACKAGE_PIN AB18 [get_ports {ETH_RX_CLK      }];  # "AB18.BANK13_LVDS_5_P.JX2.94.ETH_RX_CLK"
set_property PACKAGE_PIN AB19 [get_ports {ETH_RX_CTRL     }];  # "AB19.BANK13_LVDS_5_N.JX2.96.ETH_RX_CTRL"
set_property PACKAGE_PIN AB21 [get_ports {ETH_RXD0        }];  # "AB21.BANK13_LVDS_4_P.JX2.93.ETH_RXD0"
set_property PACKAGE_PIN AB22 [get_ports {ETH_RXD1        }];  # "AB22.BANK13_LVDS_4_N.JX2.95.ETH_RXD1"
set_property PACKAGE_PIN AA19 [get_ports {ETH_RXD2        }];  # "AA19.BANK13_LVDS_6_P.JX2.97.ETH_RXD2"
set_property PACKAGE_PIN AA20 [get_ports {ETH_RXD3        }];  # "AA20.BANK13_LVDS_6_N.JX2.99.ETH_RXD3"

# ----------------------------------------------------------------------------
# SPF / PMOD2 Multiplexer - Bank 13
# ---------------------------------------------------------------------------- 

set_property PACKAGE_PIN T17  [get_ports {MUX_D0_N        }];  # "T17.BANK13_LVDS_14_N.JX3.94.MUX_D0_N"
set_property PACKAGE_PIN R17  [get_ports {MUX_D0_P        }];  # "R17.BANK13_LVDS_14_P.JX3.92.MUX_D0_P"
set_property PACKAGE_PIN W13  [get_ports {MUX_D1_N        }];  # "W13.BANK13_LVDS_13_N.JX3.93.MUX_D1_N"
set_property PACKAGE_PIN W12  [get_ports {MUX_D1_P        }];  # "W12.BANK13_LVDS_13_P.JX3.91.MUX_D1_P"
set_property PACKAGE_PIN W16  [get_ports {MUX_D2_N        }];  # "W16.BANK13_LVDS_16_N.JX3.100.MUX_D2_N"
set_property PACKAGE_PIN V16  [get_ports {MUX_D2_P        }];  # "V16.BANK13_LVDS_16_P.JX3.98.MUX_D2_P"
set_property PACKAGE_PIN W15  [get_ports {MUX_D3_N        }];  # "W15.BANK13_LVDS_15_N.JX3.99.MUX_D3_N"
set_property PACKAGE_PIN V15  [get_ports {MUX_D3_P        }];  # "V15.BANK13_LVDS_15_P.JX3.97.MUX_D3_P"

# ----------------------------------------------------------------------------
# PCIe Reset - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN V13  [get_ports {PCIE_RST_N      }];  # "V13.BANK13_LVDS_12_P.JX3.86.PCIE_RST_N"

# ----------------------------------------------------------------------------
# FMC MGTs - Bank 112
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y6   [get_ports {FMC_MGT_RX_N    }];  # "Y6.MGTRX3_N.JX3.28.FMC_MGT_RX_N"
set_property PACKAGE_PIN W6   [get_ports {FMC_MGT_RX_P    }];  # "W6.MGTRX3_P.JX3.26.FMC_MGT_RX_P"
set_property PACKAGE_PIN Y2   [get_ports {FMC_MGT_TX_N    }];  # "Y2.MGTTX3_N.JX3.33.FMC_MGT_TX_N"
set_property PACKAGE_PIN W2   [get_ports {FMC_MGT_TX_P    }];  # "W2.MGTTX3_P.JX3.31.FMC_MGT_TX_P"


# ----------------------------------------------------------------------------
# PCIe MGTs - Bank 112
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN AB7  [get_ports {PCIE_RX0_N      }];  # "AB7.MGTRX0_N.JX3.10.PCIE-RX0_N"
set_property PACKAGE_PIN AA7  [get_ports {PCIE_RX0_P      }];  # "AA7.MGTRX0_P.JX3.8.PCIE-RX0_P"
set_property PACKAGE_PIN AB3  [get_ports {PCIE_TX0_N      }];  # "AB3.MGTTX0_N.JX3.15.PCIE-TX0_N"
set_property PACKAGE_PIN AA3  [get_ports {PCIE_TX0_P      }];  # "AA3.MGTTX0_P.JX3.13.PCIE-TX0_P"

# ----------------------------------------------------------------------------
# SMA MGTs - Bank 112
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y8   [get_ports {MGTRX1_N        }];  # "Y8.MGTRX1_N.JX3.16.MGTRX1_N"
set_property PACKAGE_PIN W8   [get_ports {MGTRX1_P        }];  # "W8.MGTRX1_P.JX3.14.MGTRX1_P"
set_property PACKAGE_PIN Y4   [get_ports {MGTTX1_N        }];  # "Y4.MGTTX1_N.JX3.21.MGTTX1_N"
set_property PACKAGE_PIN W4   [get_ports {MGTTX1_P        }];  # "W4.MGTTX1_P.JX3.19.MGTTX1_P"

# ----------------------------------------------------------------------------
# SFP MGTs - Bank 112
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN AB9  [get_ports {MGTRX2_N        }];  # "AB9.MGTRX2_N.JX3.22.MGTRX2_N"
set_property PACKAGE_PIN AA9  [get_ports {MGTRX2_P        }];  # "AA9.MGTRX2_P.JX3.20.MGTRX2_P"
set_property PACKAGE_PIN AB5  [get_ports {MGTTX2_N        }];  # "AB5.MGTTX2_N.JX3.27.MGTTX2_N"
set_property PACKAGE_PIN AA5  [get_ports {MGTTX2_P        }];  # "AA5.MGTTX2_P.JX3.25.MGTTX2_P"

# ----------------------------------------------------------------------------
# MGT REF CLKS - Bank 112 -- added manually due to capacitors
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN V9   [get_ports {MGTREFCLKC0_N   }];  # "V9.MGTREFCLKC0_N.JX3.3.PCIE-JREFCLK_N"
set_property PACKAGE_PIN U9   [get_ports {MGTREFCLKC0_P   }];  # "U9.MGTREFCLKC0_P.JX3.1.PCIE-JREFCLK_P"
set_property PACKAGE_PIN V5   [get_ports {MGTREFCLKC1_N   }];  # "V5.MGTREFCLKC1_N.JX3.4.MGTREFCLK1_N"
set_property PACKAGE_PIN U5   [get_ports {MGTREFCLKC1_P   }];  # "U5.MGTREFCLKC1_P.JX3.2.MGTREFCLK1_P"

# ----------------------------------------------------------------------------
# PS MIO - PS Push Button - SD interface - USB-UART RX/TX - PS Ethernet Reset
# For reference only - these should be assigned automatically
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN D11  [get_ports {SD_CD           }];  # "D11.PS_MIO46.JX3.41.SD_CD"
#set_property PACKAGE_PIN E9   [get_ports {SD_CLK          }];  # "E9.PS_MIO40.JX3.43.SD_CLK"
#set_property PACKAGE_PIN C15  [get_ports {SD_CMD          }];  # "C15.PS_MIO41.JX3.34.SD_CMD"
#set_property PACKAGE_PIN D15  [get_ports {SD_D0           }];  # "D15.PS_MIO42.JX3.37.SD_D0"
#set_property PACKAGE_PIN B12  [get_ports {SD_D1           }];  # "B12.PS_MIO43.JX3.36.SD_D1"
#set_property PACKAGE_PIN E10  [get_ports {SD_D2           }];  # "E10.PS_MIO44.JX3.39.SD_D2"
#set_property PACKAGE_PIN B14  [get_ports {SD_D3           }];  # "B14.PS_MIO45.JX3.38.SD_D3"
#set_property PACKAGE_PIN D12  [get_ports {USB_UART_RXD    }];  # "D12.PS_MIO48.JX3.42.USB_UART_RXD"
#set_property PACKAGE_PIN C9   [get_ports {USB_UART_TXD    }];  # "C9.PS_MIO49.JX3.44.USB_UART_TXD"
#set_property PACKAGE_PIN D10  [get_ports {PS_ETHRST_N     }];  # "D10.PS_MIO50.JX3.66.PS_ETHRST_N"

# ----------------------------------------------------------------------------
# PL User Push Buttons - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN T16  [get_ports {PL_PB1          }];  # "T16.BANK13_SE_0.JX2.100.PL_PB1"
set_property PACKAGE_PIN V14  [get_ports {PL_PB2          }];  # "V14.BANK13_LVDS_12_N.JX3.88.PL_PB2"

# ----------------------------------------------------------------------------
# PL User LEDs - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y18  [get_ports {PL_LED1         }];  # "Y18.BANK13_LVDS_7_P.JX3.73.PL_LED1"
set_property PACKAGE_PIN Y19  [get_ports {PL_LED2         }];  # "Y19.BANK13_LVDS_7_N.JX3.75.PL_LED2"

# ----------------------------------------------------------------------------
# PL PMOD 1 - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN AA17 [get_ports {PMOD1_D0_N      }];  # "AA17.BANK13_LVDS_8_N.JX3.76.PMOD1_D0_N"
set_property PACKAGE_PIN AA16 [get_ports {PMOD1_D0_P      }];  # "AA16.BANK13_LVDS_8_P.JX3.74.PMOD1_D0_P"
set_property PACKAGE_PIN AB11 [get_ports {PMOD1_D1_N      }];  # "AB11.BANK13_LVDS_9_N.JX3.81.PMOD1_D1_N"
set_property PACKAGE_PIN AA11 [get_ports {PMOD1_D1_P      }];  # "AA11.BANK13_LVDS_9_P.JX3.79.PMOD1_D1_P"
set_property PACKAGE_PIN Y13  [get_ports {PMOD1_D2_N      }];  # "Y13.BANK13_LVDS_10_N.JX3.82.PMOD1_D2_N"
set_property PACKAGE_PIN Y12  [get_ports {PMOD1_D2_P      }];  # "Y12.BANK13_LVDS_10_P.JX3.80.PMOD1_D2_P"
set_property PACKAGE_PIN W11  [get_ports {PMOD1_D3_N      }];  # "W11.BANK13_LVDS_11_N.JX3.87.PMOD1_D3_N"
set_property PACKAGE_PIN V11  [get_ports {PMOD1_D3_P      }];  # "V11.BANK13_LVDS_11_P.JX3.85.PMOD1_D3_P"

# ----------------------------------------------------------------------------
# IOSTANDARD Constraints
#
# Note that these IOSTANDARD constraints are applied to all IOs currently
# assigned within an I/O bank.  If these IOSTANDARD constraints are 
# evaluated prior to other PACKAGE_PIN constraints being applied, then 
# the IOSTANDARD specified will likely not be applied properly to those 
# pins.  Therefore, bank wide IOSTANDARD constraints should be placed 
# within the XDC file in a location that is evaluated AFTER all 
# PACKAGE_PIN constraints within the target bank have been evaluated.
#
# Un-comment one or more of the following IOSTANDARD constraints according to
# the bank pin assignments that are required within a design.
# ---------------------------------------------------------------------------- 
#
#     WARNING!! Bank 34 and Bank 35 on the 7030 device are High Performance
#     banks and will only accept 1.8V level signals. Failure to limit Bank 34
#     and Bank 35 to 1.8V signals can damage the Zynq 7030!
#

# Set the bank voltage for IO Bank 34 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on the PZCC board. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];

