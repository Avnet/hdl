# ----------------------------------------------------------------------------
#     _____
#    /     \
#   /____   \____
#  / \===\   \==/
# /___\===\___\/  AVNET Design Resource Center
#      \======/         www.em.avnet.com/drc
#       \====/    
# ----------------------------------------------------------------------------
# 
#  Created With Avnet UCF Generator V0.4.0 
#     Date: Saturday, June 30, 2012 
#     Time: 12:18:55 AM 
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
#  
#  Please direct any questions to:
#     Avnet Centralized Technical Support
#     Centralized-Support@avnet.com
#     1-800-422-9023
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2012 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Notes:
# 
#  10 August 2012
#     IO standards based upon Bank 34 and Bank 35 Vcco supply options of 1.8V, 
#     2.5V, or 3.3V are possible based upon the Vadj jumper (J18) settings.  
#     By default, Vadj is expected to be set to 1.8V but if a different 
#     voltage is used for a particular design, then the corresponding IO 
#     standard within this UCF should also be updated to reflect the actual 
#     Vadj jumper selection.
# 
#  09 September 2012
#     Net names are not allowed to contain hyphen characters '-' since this
#     is not a legal VHDL87 or Verilog character within an identifier.  
#     HDL net names are adjusted to contain no hyphen characters '-' but 
#     rather use underscore '_' characters.  Comment net name with the hyphen 
#     characters will remain in place since these are intended to match the 
#     schematic net names in order to better enable schematic search.
#
#  17 April 2014
#     Pin constraint for toggle switch SW7 was corrected to M15 location.
#
# ----------------------------------------------------------------------------
#set_property PACKAGE_PIN H20 [get_ports {wbInputData[9]}]  RMME
# Bank 13, Vcco = 3.3V
#Set the bank voltage for bank 13.
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 13 } ]
#In the following the XDC constraint is matched to the origanal UCF constraint, XDC above, UCF below # Commented
set_property PACKAGE_PIN AB1 [get_ports {AC_ADR0}]
#NET AC_ADR0       LOC = AB1  | IOSTANDARD=LVCMOS33;  # "AC-ADR0"
#
set_property PACKAGE_PIN Y5 [get_ports {AC_ADR1}]
#NET AC_ADR1       LOC = Y5   | IOSTANDARD=LVCMOS33;  # "AC-ADR1"
set_property PACKAGE_PIN Y8 [get_ports {AC_GPIO0}]
#NET AC_GPIO0      LOC = Y8   | IOSTANDARD=LVCMOS33;  # "AC-GPIO0"
set_property PACKAGE_PIN AA7 [get_ports {AC_GPIO1}]
#NET AC_GPIO1      LOC = AA7  | IOSTANDARD=LVCMOS33;  # "AC-GPIO1"
set_property PACKAGE_PIN AA6 [get_ports {AC_GPIO2}]
#NET AC_GPIO2      LOC = AA6  | IOSTANDARD=LVCMOS33;  # "AC-GPIO2"
set_property PACKAGE_PIN Y6 [get_ports {AC_GPIO3}]
#NET AC_GPIO3      LOC = Y6   | IOSTANDARD=LVCMOS33;  # "AC-GPIO3"
set_property PACKAGE_PIN AB2 [get_ports {AC_MCLK}]
#NET AC_MCLK       LOC = AB2  | IOSTANDARD=LVCMOS33;  # "AC-MCLK"
set_property PACKAGE_PIN AB4 [get_ports {AC_SCK}]
#NET AC_SCK        LOC = AB4  | IOSTANDARD=LVCMOS33;  # "AC-SCK"
set_property PACKAGE_PIN AB5 [get_ports {AC_SDA}]
#NET AC_SDA        LOC = AB5  | IOSTANDARD=LVCMOS33;  # "AC-SDA"
set_property PACKAGE_PIN R7 [get_ports {FMC_SCL}]
#NET FMC_SCL       LOC = R7   | IOSTANDARD=LVCMOS33;  # "FMC-SCL"
set_property PACKAGE_PIN U7 [get_ports {FMC_SDA}]
#NET FMC_SDA       LOC = U7   | IOSTANDARD=LVCMOS33;  # "FMC-SDA"
set_property PACKAGE_PIN Y9 [get_ports {GCLK}]
#NET GCLK          LOC = Y9   | IOSTANDARD=LVCMOS33;  # "GCLK"
set_property PACKAGE_PIN Y11 [get_ports {JA1}]
#NET JA1           LOC = Y11  | IOSTANDARD=LVCMOS33;  # "JA1"
set_property PACKAGE_PIN AA8 [get_ports {JA10}]
#NET JA10          LOC = AA8  | IOSTANDARD=LVCMOS33;  # "JA10"
set_property PACKAGE_PIN AA11 [get_ports {JA2}]
#NET JA2           LOC = AA11 | IOSTANDARD=LVCMOS33;  # "JA2"
set_property PACKAGE_PIN Y10 [get_ports {JA3}]
#NET JA3           LOC = Y10  | IOSTANDARD=LVCMOS33;  # "JA3"
set_property PACKAGE_PIN AA9 [get_ports {JA4}]
#NET JA4           LOC = AA9  | IOSTANDARD=LVCMOS33;  # "JA4"
set_property PACKAGE_PIN AB11 [get_ports {JA7}]
#NET JA7           LOC = AB11 | IOSTANDARD=LVCMOS33;  # "JA7"
set_property PACKAGE_PIN AB10 [get_ports {JA8}]
#NET JA8           LOC = AB10 | IOSTANDARD=LVCMOS33;  # "JA8"
set_property PACKAGE_PIN AB9 [get_ports {JA9}]
#NET JA9           LOC = AB9  | IOSTANDARD=LVCMOS33;  # "JA9"
set_property PACKAGE_PIN W12 [get_ports {JB1}]
#NET JB1           LOC = W12  | IOSTANDARD=LVCMOS33;  # "JB1"
set_property PACKAGE_PIN V8 [get_ports {JB10}]
#NET JB10          LOC = V8   | IOSTANDARD=LVCMOS33;  # "JB10"
set_property PACKAGE_PIN W11 [get_ports {JB2}]
#NET JB2           LOC = W11  | IOSTANDARD=LVCMOS33;  # "JB2"
set_property PACKAGE_PIN V10 [get_ports {JB3}]
#NET JB3           LOC = V10  | IOSTANDARD=LVCMOS33;  # "JB3"
set_property PACKAGE_PIN W8 [get_ports {JB4}]
#NET JB4           LOC = W8   | IOSTANDARD=LVCMOS33;  # "JB4"
set_property PACKAGE_PIN V12 [get_ports {JB7}]
#NET JB7           LOC = V12  | IOSTANDARD=LVCMOS33;  # "JB7"
set_property PACKAGE_PIN W10 [get_ports {JB8}]
#NET JB8           LOC = W10  | IOSTANDARD=LVCMOS33;  # "JB8"
set_property PACKAGE_PIN V9 [get_ports {JB9}]
#NET JB9           LOC = V9   | IOSTANDARD=LVCMOS33;  # "JB9"
set_property PACKAGE_PIN AB6 [get_ports {JC1_N}]
#NET JC1_N         LOC = AB6  | IOSTANDARD=LVCMOS33;  # "JC1_N"
set_property PACKAGE_PIN AB7 [get_ports {JC1_P}]
#NET JC1_P         LOC = AB7  | IOSTANDARD=LVCMOS33;  # "JC1_P"
set_property PACKAGE_PIN AA4 [get_ports {JC2_N}]
#NET JC2_N         LOC = AA4  | IOSTANDARD=LVCMOS33;  # "JC2_N"
set_property PACKAGE_PIN Y4 [get_ports {JC2_P}]
#NET JC2_P         LOC = Y4   | IOSTANDARD=LVCMOS33;  # "JC2_P"
set_property PACKAGE_PIN T6 [get_ports {JC3_N}]
#NET JC3_N         LOC = T6   | IOSTANDARD=LVCMOS33;  # "JC3_N"
set_property PACKAGE_PIN R6 [get_ports {JC3_P}]
#NET JC3_P         LOC = R6   | IOSTANDARD=LVCMOS33;  # "JC3_P"
set_property PACKAGE_PIN U4 [get_ports {JC4_N}]
#NET JC4_N         LOC = U4   | IOSTANDARD=LVCMOS33;  # "JC4_N"
set_property PACKAGE_PIN T4 [get_ports {JC4_P}]
#NET JC4_P         LOC = T4   | IOSTANDARD=LVCMOS33;  # "JC4_P"
set_property PACKAGE_PIN W7 [get_ports {JD1_N}]
#NET JD1_N         LOC = W7   | IOSTANDARD=LVCMOS33;  # "JD1_N"
set_property PACKAGE_PIN V7 [get_ports {JD1_P}]
#NET JD1_P         LOC = V7   | IOSTANDARD=LVCMOS33;  # "JD1_P"
set_property PACKAGE_PIN V4 [get_ports {JD2_N}]
#NET JD2_N         LOC = V4   | IOSTANDARD=LVCMOS33;  # "JD2_N"
set_property PACKAGE_PIN V5 [get_ports {JD2_P}]
#NET JD2_P         LOC = V5   | IOSTANDARD=LVCMOS33;  # "JD2_P"
set_property PACKAGE_PIN W5 [get_ports {JD3_N}]
#NET JD3_N         LOC = W5   | IOSTANDARD=LVCMOS33;  # "JD3_N"
set_property PACKAGE_PIN W6 [get_ports {JD3_P}]
#NET JD3_P         LOC = W6   | IOSTANDARD=LVCMOS33;  # "JD3_P"
set_property PACKAGE_PIN U5 [get_ports {JD4_N}]
#NET JD4_N         LOC = U5   | IOSTANDARD=LVCMOS33;  # "JD4_N"
set_property PACKAGE_PIN U6 [get_ports {JD4_P}]
#NET JD4_P         LOC = U6   | IOSTANDARD=LVCMOS33;  # "JD4_P"
set_property PACKAGE_PIN U10 [get_ports {OLED_DC}]
#NET OLED_DC       LOC = U10  | IOSTANDARD=LVCMOS33;  # "OLED-DC"
set_property PACKAGE_PIN U9 [get_ports {OLED_RES}]
#NET OLED_RES      LOC = U9   | IOSTANDARD=LVCMOS33;  # "OLED-RES"
set_property PACKAGE_PIN AB12 [get_ports {OLED_SCLK}]
#NET OLED_SCLK     LOC = AB12 | IOSTANDARD=LVCMOS33;  # "OLED-SCLK"
set_property PACKAGE_PIN AA12 [get_ports {OLED_SDIN}]
#NET OLED_SDIN     LOC = AA12 | IOSTANDARD=LVCMOS33;  # "OLED-SDIN"
set_property PACKAGE_PIN U11 [get_ports {OLED_VBAT}]
#NET OLED_VBAT     LOC = U11  | IOSTANDARD=LVCMOS33;  # "OLED-VBAT"
set_property PACKAGE_PIN U12 [get_ports {OLED_VDD}]
#NET OLED_VDD      LOC = U12  | IOSTANDARD=LVCMOS33;  # "OLED-VDD"

# Bank 33, Vcco = 3.3V
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 33 } ]
set_property PACKAGE_PIN AB14 [get_ports {FMC_PRSNT}]
#NET FMC_PRSNT     LOC = AB14 | IOSTANDARD=LVCMOS33;  # "FMC-PRSNT"
set_property PACKAGE_PIN W18 [get_ports {HD_CLK}]
#NET HD_CLK        LOC = W18  | IOSTANDARD=LVCMOS33;  # "HD-CLK"
set_property PACKAGE_PIN Y13 [get_ports {HD_D0}]
#NET HD_D0         LOC = Y13  | IOSTANDARD=LVCMOS33;  # "HD-D0"
set_property PACKAGE_PIN AA13 [get_ports {HD_D1}]
#NET HD_D1         LOC = AA13 | IOSTANDARD=LVCMOS33;  # "HD-D1"
set_property PACKAGE_PIN W13 [get_ports {HD_D10}]
#NET HD_D10        LOC = W13  | IOSTANDARD=LVCMOS33;  # "HD-D10"
set_property PACKAGE_PIN W15 [get_ports {HD_D11}]
#NET HD_D11        LOC = W15  | IOSTANDARD=LVCMOS33;  # "HD-D11"
set_property PACKAGE_PIN V15 [get_ports {HD_D12}]
#NET HD_D12        LOC = V15  | IOSTANDARD=LVCMOS33;  # "HD-D12"
set_property PACKAGE_PIN U17 [get_ports {HD_D13}]
#NET HD_D13        LOC = U17  | IOSTANDARD=LVCMOS33;  # "HD-D13"
set_property PACKAGE_PIN V14 [get_ports {HD_D14}]
#NET HD_D14        LOC = V14  | IOSTANDARD=LVCMOS33;  # "HD-D14"
set_property PACKAGE_PIN V13 [get_ports {HS_D15}]
#NET HD_D15        LOC = V13  | IOSTANDARD=LVCMOS33;  # "HD-D15"
set_property PACKAGE_PIN AA14 [get_ports {HD_D2}]
#NET HD_D2         LOC = AA14 | IOSTANDARD=LVCMOS33;  # "HD-D2"
set_property PACKAGE_PIN Y14 [get_ports {HD_D3}]
#NET HD_D3         LOC = Y14  | IOSTANDARD=LVCMOS33;  # "HD-D3"
set_property PACKAGE_PIN AB15 [get_ports {HD_D4}]
#NET HD_D4         LOC = AB15 | IOSTANDARD=LVCMOS33;  # "HD-D4"
set_property PACKAGE_PIN AB16 [get_ports {HD_D5}]
#NET HD_D5         LOC = AB16 | IOSTANDARD=LVCMOS33;  # "HD-D5"
set_property PACKAGE_PIN AA16 [get_ports {HD_D6}]
#NET HD_D6         LOC = AA16 | IOSTANDARD=LVCMOS33;  # "HD-D6"
set_property PACKAGE_PIN AB17 [get_ports {HD_D7}]
#NET HD_D7         LOC = AB17 | IOSTANDARD=LVCMOS33;  # "HD-D7"
set_property PACKAGE_PIN AA17 [get_ports {HD_D8}]
#NET HD_D8         LOC = AA17 | IOSTANDARD=LVCMOS33;  # "HD-D8"
set_property PACKAGE_PIN Y15 [get_ports {HD_D9}]
#NET HD_D9         LOC = Y15  | IOSTANDARD=LVCMOS33;  # "HD-D9"
set_property PACKAGE_PIN U16 [get_ports {HD_DE}]
#NET HD_DE         LOC = U16  | IOSTANDARD=LVCMOS33;  # "HD-DE"
set_property PACKAGE_PIN V17 [get_ports {HD_HSYNC}]
#NET HD_HSYNC      LOC = V17  | IOSTANDARD=LVCMOS33;  # "HD-HSYNC"
set_property PACKAGE_PIN W16 [get_ports {HD_INT}]
#NET HD_INT        LOC = W16  | IOSTANDARD=LVCMOS33;  # "HD-INT"
set_property PACKAGE_PIN AA18 [get_ports {HD_SCL}]
#NET HD_SCL        LOC = AA18 | IOSTANDARD=LVCMOS33;  # "HD-SCL"
set_property PACKAGE_PIN Y16 [get_ports {HD_SDA}]
#NET HD_SDA        LOC = Y16  | IOSTANDARD=LVCMOS33;  # "HD-SDA"
set_property PACKAGE_PIN U15 [get_ports {HD_SPDIF}]
#NET HD_SPDIF      LOC = U15  | IOSTANDARD=LVCMOS33;  # "HD-SPDIF"
set_property PACKAGE_PIN Y18 [get_ports {HD_SPDIFO}]
#NET HD_SPDIFO     LOC = Y18  | IOSTANDARD=LVCMOS33;  # "HD-SPDIFO"
set_property PACKAGE_PIN W17 [get_ports {HD_VSYNC}]
#NET HD_VSYNC      LOC = W17  | IOSTANDARD=LVCMOS33;  # "HD-VSYNC"
set_property PACKAGE_PIN T22 [get_ports {LD0}]
#NET LD0           LOC = T22  | IOSTANDARD=LVCMOS33;  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {LD1}]
#NET LD1           LOC = T21  | IOSTANDARD=LVCMOS33;  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {LD2}]
#NET LD2           LOC = U22  | IOSTANDARD=LVCMOS33;  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {LD3}]
#NET LD3           LOC = U21  | IOSTANDARD=LVCMOS33;  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {LD4}]
#NET LD4           LOC = V22  | IOSTANDARD=LVCMOS33;  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {LD5}]
#NET LD5           LOC = W22  | IOSTANDARD=LVCMOS33;  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {LD6}]
#NET LD6           LOC = U19  | IOSTANDARD=LVCMOS33;  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {LD7}]
#NET LD7           LOC = U14  | IOSTANDARD=LVCMOS33;  # "LD7"
set_property PACKAGE_PIN W20 [get_ports {NetIC16_W20}]
#NET NetIC16_W20   LOC = W20  | IOSTANDARD=LVCMOS33;  # "NetIC16_W20"
set_property PACKAGE_PIN W21 [get_ports {NetIC16_W21}]
#NET NetIC16_W21   LOC = W21  | IOSTANDARD=LVCMOS33;  # "NetIC16_W21"
set_property PACKAGE_PIN Y21 [get_ports {VGA_B1}]
#NET VGA_B1        LOC = Y21  | IOSTANDARD=LVCMOS33;  # "VGA-B1"
set_property PACKAGE_PIN Y20 [get_ports {VGA_B2}]
NET VGA_B2        LOC = Y20  | IOSTANDARD=LVCMOS33;  # "VGA-B2"
set_property PACKAGE_PIN AB20 [get_ports {VGA_B3}]
#NET VGA_B3        LOC = AB20 | IOSTANDARD=LVCMOS33;  # "VGA-B3"
set_property PACKAGE_PIN AB19 [get_ports {VGA_B4}]
#NET VGA_B4        LOC = AB19 | IOSTANDARD=LVCMOS33;  # "VGA-B4"
set_property PACKAGE_PIN AB22 [get_ports {VGA_G1}]
#NET VGA_G1        LOC = AB22 | IOSTANDARD=LVCMOS33;  # "VGA-G1"
set_property PACKAGE_PIN AA22 [get_ports {VGA_G2}]
#NET VGA_G2        LOC = AA22 | IOSTANDARD=LVCMOS33;  # "VGA-G2"
set_property PACKAGE_PIN AB21 [get_ports {VGA_G3}]
#NET VGA_G3        LOC = AB21 | IOSTANDARD=LVCMOS33;  # "VGA-G3"
set_property PACKAGE_PIN AA21 [get_ports {VGA_G4}]
#NET VGA_G4        LOC = AA21 | IOSTANDARD=LVCMOS33;  # "VGA-G4"
set_property PACKAGE_PIN AA19 [get_ports {VGA_HS}]
#NET VGA_HS        LOC = AA19 | IOSTANDARD=LVCMOS33;  # "VGA-HS"
set_property PACKAGE_PIN V20 [get_ports {VGA_R1}]
#NET VGA_R1        LOC = V20  | IOSTANDARD=LVCMOS33;  # "VGA-R1"
set_property PACKAGE_PIN U20 [get_ports {VGA_R2}]
#NET VGA_R2        LOC = U20  | IOSTANDARD=LVCMOS33;  # "VGA-R2"
set_property PACKAGE_PIN V19 [get_ports {VGA_R3}]
#NET VGA_R3        LOC = V19  | IOSTANDARD=LVCMOS33;  # "VGA-R3"
set_property PACKAGE_PIN V18 [get_ports {VGA_R4}]
#NET VGA_R4        LOC = V18  | IOSTANDARD=LVCMOS33;  # "VGA-R4"
set_property PACKAGE_PIN Y19 [get_ports {VGA_VS}]
NET VGA_VS        LOC = Y19  | IOSTANDARD=LVCMOS33;  # "VGA-VS"

# Bank 34, Vcco = Vadj
set_property IOSTANDARD LVCMOS18 [get_ports -filter { IOBANK == 34 } ]
set_property PACKAGE_PIN P16 [get_ports {BTNC}]
#NET BTNC          LOC = P16  | IOSTANDARD=LVCMOS18;  # "BTNC"
set_property PACKAGE_PIN R16 [get_ports {BTND}]
#NET BTND          LOC = R16  | IOSTANDARD=LVCMOS18;  # "BTND"
set_property PACKAGE_PIN N15 [get_ports {BTNL}]
#NET BTNL          LOC = N15  | IOSTANDARD=LVCMOS18;  # "BTNL"
set_property PACKAGE_PIN R18 [get_ports {BTNR}]
#NET BTNR          LOC = R18  | IOSTANDARD=LVCMOS18;  # "BTNR"
set_property PACKAGE_PIN T18 [get_ports {BTNU}]
#NET BTNU          LOC = T18  | IOSTANDARD=LVCMOS18;  # "BTNU"
set_property PACKAGE_PIN L19 [get_ports {FMC_CLK0_N}]
#NET FMC_CLK0_N    LOC = L19  | IOSTANDARD=LVCMOS18;  # "FMC-CLK0_N"
set_property PACKAGE_PIN L18 [get_ports {FMC_CLK0_P}]
#NET FMC_CLK0_P    LOC = L18  | IOSTANDARD=LVCMOS18;  # "FMC-CLK0_P"
set_property PACKAGE_PIN M20 [get_ports {FMC_LA00_CC_N}]
#NET FMC_LA00_CC_N LOC = M20  | IOSTANDARD=LVCMOS18;  # "FMC-LA00_CC_N"
set_property PACKAGE_PIN M19 [get_ports {FMC_LA00_CC_P}]
#NET FMC_LA00_CC_P LOC = M19  | IOSTANDARD=LVCMOS18;  # "FMC-LA00_CC_P"
set_property PACKAGE_PIN N20 [get_ports {FMC_LA01_CC_N}]
#NET FMC_LA01_CC_N LOC = N20  | IOSTANDARD=LVCMOS18;  # "FMC-LA01_CC_N"
set_property PACKAGE_PIN N19 [get_ports {FMC_LA00_CC_P}]
#NET FMC_LA01_CC_P LOC = N19  | IOSTANDARD=LVCMOS18;  # "FMC-LA01_CC_P"
set_property PACKAGE_PIN P18 [get_ports {FMC_LA02_N}]
#NET FMC_LA02_N    LOC = P18  | IOSTANDARD=LVCMOS18;  # "FMC-LA02_N"
set_property PACKAGE_PIN P17 [get_ports {FMC_LA02_P}]
#NET FMC_LA02_P    LOC = P17  | IOSTANDARD=LVCMOS18;  # "FMC-LA02_P"
set_property PACKAGE_PIN P22 [get_ports {FMC_LA03_N}]
#NET FMC_LA03_N    LOC = P22  | IOSTANDARD=LVCMOS18;  # "FMC-LA03_N"
set_property PACKAGE_PIN N22 [get_ports {FMC_LA03_P}]
#NET FMC_LA03_P    LOC = N22  | IOSTANDARD=LVCMOS18;  # "FMC-LA03_P"
set_property PACKAGE_PIN M22 [get_ports {FMC_LA04_N}]
#NET FMC_LA04_N    LOC = M22  | IOSTANDARD=LVCMOS18;  # "FMC-LA04_N"
set_property PACKAGE_PIN M21 [get_ports {FMC_LA04_P}]
#NET FMC_LA04_P    LOC = M21  | IOSTANDARD=LVCMOS18;  # "FMC-LA04_P"
set_property PACKAGE_PIN K18 [get_ports {FMC_LA05_N}]
#NET FMC_LA05_N    LOC = K18  | IOSTANDARD=LVCMOS18;  # "FMC-LA05_N"
set_property PACKAGE_PIN J18 [get_ports {FMC_LA05_P}]
#NET FMC_LA05_P    LOC = J18  | IOSTANDARD=LVCMOS18;  # "FMC-LA05_P"
set_property PACKAGE_PIN L22 [get_ports {FMC_LA06_N}]
#NET FMC_LA06_N    LOC = L22  | IOSTANDARD=LVCMOS18;  # "FMC-LA06_N"
set_property PACKAGE_PIN L21 [get_ports {FMC_LA06_P}]
#NET FMC_LA06_P    LOC = L21  | IOSTANDARD=LVCMOS18;  # "FMC-LA06_P"
set_property PACKAGE_PIN T17 [get_ports {FMC_LA07_N}]
#NET FMC_LA07_N    LOC = T17  | IOSTANDARD=LVCMOS18;  # "FMC-LA07_N"
set_property PACKAGE_PIN T16 [get_ports {FMC_LA07_P}]
#NET FMC_LA07_P    LOC = T16  | IOSTANDARD=LVCMOS18;  # "FMC-LA07_P"
set_property PACKAGE_PIN J22 [get_ports {FMC_LA08_N}]
#NET FMC_LA08_N    LOC = J22  | IOSTANDARD=LVCMOS18;  # "FMC-LA08_N"
set_property PACKAGE_PIN J21 [get_ports {FMC_LA08_P}]
#NET FMC_LA08_P    LOC = J21  | IOSTANDARD=LVCMOS18;  # "FMC-LA08_P"
set_property PACKAGE_PIN R21 [get_ports {FMC_LA09_N}]
#NET FMC_LA09_N    LOC = R21  | IOSTANDARD=LVCMOS18;  # "FMC-LA09_N"
set_property PACKAGE_PIN R20 [get_ports {FMC_LA09_P}]
#NET FMC_LA09_P    LOC = R20  | IOSTANDARD=LVCMOS18;  # "FMC-LA09_P"
set_property PACKAGE_PIN T19 [get_ports {FMC_LA10_N}]
#NET FMC_LA10_N    LOC = T19  | IOSTANDARD=LVCMOS18;  # "FMC-LA10_N"
set_property PACKAGE_PIN R19 [get_ports {FMC_LA10_P}]
#NET FMC_LA10_P    LOC = R19  | IOSTANDARD=LVCMOS18;  # "FMC-LA10_P"
set_property PACKAGE_PIN N18 [get_ports {FMC_LA11_N}]
#NET FMC_LA11_N    LOC = N18  | IOSTANDARD=LVCMOS18;  # "FMC-LA11_N"
set_property PACKAGE_PIN N17 [get_ports {FMC_LA11_P}]
#NET FMC_LA11_P    LOC = N17  | IOSTANDARD=LVCMOS18;  # "FMC-LA11_P"
set_property PACKAGE_PIN P21 [get_ports {FMC_LA12_N}]
#NET FMC_LA12_N    LOC = P21  | IOSTANDARD=LVCMOS18;  # "FMC-LA12_N"
set_property PACKAGE_PIN P20 [get_ports {FMC_LA12_P}]
#NET FMC_LA12_P    LOC = P20  | IOSTANDARD=LVCMOS18;  # "FMC-LA12_P"
set_property PACKAGE_PIN M17 [get_ports {FMC_LA13_N}]
#NET FMC_LA13_N    LOC = M17  | IOSTANDARD=LVCMOS18;  # "FMC-LA13_N"
set_property PACKAGE_PIN L17 [get_ports {FMC_LA13_P}]
#NET FMC_LA13_P    LOC = L17  | IOSTANDARD=LVCMOS18;  # "FMC-LA13_P"
set_property PACKAGE_PIN K20 [get_ports {FMC_LA14_N}]
#NET FMC_LA14_N    LOC = K20  | IOSTANDARD=LVCMOS18;  # "FMC-LA14_N"
set_property PACKAGE_PIN K19 [get_ports {FMC_LA14_P}]
#NET FMC_LA14_P    LOC = K19  | IOSTANDARD=LVCMOS18;  # "FMC-LA14_P"
set_property PACKAGE_PIN J17 [get_ports {FMC_LA15_N}]
#NET FMC_LA15_N    LOC = J17  | IOSTANDARD=LVCMOS18;  # "FMC-LA15_N"
set_property PACKAGE_PIN J16 [get_ports {FMC_LA15_P}]
#NET FMC_LA15_P    LOC = J16  | IOSTANDARD=LVCMOS18;  # "FMC-LA15_P"
set_property PACKAGE_PIN K21 [get_ports {FMC_LA16_N}]
#NET FMC_LA16_N    LOC = K21  | IOSTANDARD=LVCMOS18;  # "FMC-LA16_N"
set_property PACKAGE_PIN J20 [get_ports {FMC_LA16_P}]
#NET FMC_LA16_P    LOC = J20  | IOSTANDARD=LVCMOS18;  # "FMC-LA16_P"
set_property PACKAGE_PIN L16 [get_ports {OTG_VBUSOC}]
#NET OTG_VBUSOC    LOC = L16  | IOSTANDARD=LVCMOS18;  # "OTG-VBUSOC"
set_property PACKAGE_PIN K16 [get_ports {PUDC_B}]
#NET PUDC_B        LOC = K16  | IOSTANDARD=LVCMOS18;  # "PUDC_B"
set_property PACKAGE_PIN H15 [get_ports {XADC_GIO0}]
#NET XADC_GIO0     LOC = H15;  # "XADC-GIO0"
set_property PACKAGE_PIN R15 [get_ports {XADC_GIO1}]
#NET XADC_GIO1     LOC = R15;  # "XADC-GIO1"
set_property PACKAGE_PIN K15 [get_ports {XADC_GIO2}]
#NET XADC_GIO2     LOC = K15;  # "XADC-GIO2"
set_property PACKAGE_PIN J15 [get_ports {XADC_GIO3}]
#NET XADC_GIO3     LOC = J15;  # "XADC-GIO3"

# Bank 35, Vcco = Vadj
set_property IOSTANDARD LVCMOS18 [get_ports -filter { IOBANK == 35 } ]
set_property PACKAGE_PIN C19 [get_ports {FMC_CLK1_N}]
#NET FMC_CLK1_N    LOC = C19  | IOSTANDARD=LVCMOS18;  # "FMC-CLK1_N"
set_property PACKAGE_PIN D18 [get_ports {FMC_CLK1_P}]
#NET FMC_CLK1_P    LOC = D18  | IOSTANDARD=LVCMOS18;  # "FMC-CLK1_P"
set_property PACKAGE_PIN B20 [get_ports {FMC_LA17_CC_N}]
#NET FMC_LA17_CC_N LOC = B20  | IOSTANDARD=LVCMOS18;  # "FMC-LA17_CC_N"
set_property PACKAGE_PIN B19 [get_ports {FMC_LA17_CC_P}]
#NET FMC_LA17_CC_P LOC = B19  | IOSTANDARD=LVCMOS18;  # "FMC-LA17_CC_P"
set_property PACKAGE_PIN C20 [get_ports {FMC_LA18_CC_N}]
#NET FMC_LA18_CC_N LOC = C20  | IOSTANDARD=LVCMOS18;  # "FMC-LA18_CC_N"
set_property PACKAGE_PIN D20 [get_ports {FMC_LA18_CC_P}]
#NET FMC_LA18_CC_P LOC = D20  | IOSTANDARD=LVCMOS18;  # "FMC-LA18_CC_P"
set_property PACKAGE_PIN G16 [get_ports {FMC_LA19_N}]
#NET FMC_LA19_N    LOC = G16  | IOSTANDARD=LVCMOS18;  # "FMC-LA19_N"
set_property PACKAGE_PIN G15 [get_ports {FMC_LA19_P}]
#NET FMC_LA19_P    LOC = G15  | IOSTANDARD=LVCMOS18;  # "FMC-LA19_P"
set_property PACKAGE_PIN G21 [get_ports {FMC_LA20_N}]
#NET FMC_LA20_N    LOC = G21  | IOSTANDARD=LVCMOS18;  # "FMC-LA20_N"
set_property PACKAGE_PIN G20 [get_ports {FMC_LA20_P}]
#NET FMC_LA20_P    LOC = G20  | IOSTANDARD=LVCMOS18;  # "FMC-LA20_P"
set_property PACKAGE_PIN E20 [get_ports {FMC_LA21_N}]
#NET FMC_LA21_N    LOC = E20  | IOSTANDARD=LVCMOS18;  # "FMC-LA21_N"
set_property PACKAGE_PIN E19 [get_ports {FMC_LA21_P}]
#NET FMC_LA21_P    LOC = E19  | IOSTANDARD=LVCMOS18;  # "FMC-LA21_P"
set_property PACKAGE_PIN F19 [get_ports {FMC_LA22_N}]
#NET FMC_LA22_N    LOC = F19  | IOSTANDARD=LVCMOS18;  # "FMC-LA22_N"
set_property PACKAGE_PIN G19 [get_ports {FMC_LA22_P}]
#NET FMC_LA22_P    LOC = G19  | IOSTANDARD=LVCMOS18;  # "FMC-LA22_P"
set_property PACKAGE_PIN D15 [get_ports {FMC_LA23_N}]
#NET FMC_LA23_N    LOC = D15  | IOSTANDARD=LVCMOS18;  # "FMC-LA23_N"
set_property PACKAGE_PIN E15 [get_ports {FMC_LA23_P}]
#NET FMC_LA23_P    LOC = E15  | IOSTANDARD=LVCMOS18;  # "FMC-LA23_P"
set_property PACKAGE_PIN A19 [get_ports {FMC_LA24_N}]
#NET FMC_LA24_N    LOC = A19  | IOSTANDARD=LVCMOS18;  # "FMC-LA24_N"
set_property PACKAGE_PIN A18 [get_ports {FMC_LA24_P}]
#NET FMC_LA24_P    LOC = A18  | IOSTANDARD=LVCMOS18;  # "FMC-LA24_P"
set_property PACKAGE_PIN C22 [get_ports {FMC_LA25_N}]
#NET FMC_LA25_N    LOC = C22  | IOSTANDARD=LVCMOS18;  # "FMC-LA25_N"
set_property PACKAGE_PIN D22 [get_ports {FMC_LA25_P}]
#NET FMC_LA25_P    LOC = D22  | IOSTANDARD=LVCMOS18;  # "FMC-LA25_P"
set_property PACKAGE_PIN E18 [get_ports {FMC_LA26_N}]
#NET FMC_LA26_N    LOC = E18  | IOSTANDARD=LVCMOS18;  # "FMC-LA26_N"
set_property PACKAGE_PIN F18 [get_ports {FMC_LA26_P}]
#NET FMC_LA26_P    LOC = F18  | IOSTANDARD=LVCMOS18;  # "FMC-LA26_P"
set_property PACKAGE_PIN D21 [get_ports {FMC_LA27_N}]
#NET FMC_LA27_N    LOC = D21  | IOSTANDARD=LVCMOS18;  # "FMC-LA27_N"
set_property PACKAGE_PIN E21 [get_ports {FMC_LA27_P}]
#NET FMC_LA27_P    LOC = E21  | IOSTANDARD=LVCMOS18;  # "FMC-LA27_P"
set_property PACKAGE_PIN A17 [get_ports {FMC_LA28_N}]
#NET FMC_LA28_N    LOC = A17  | IOSTANDARD=LVCMOS18;  # "FMC-LA28_N"
set_property PACKAGE_PIN A16 [get_ports {FMC_LA28_P}]
#NET FMC_LA28_P    LOC = A16  | IOSTANDARD=LVCMOS18;  # "FMC-LA28_P"
set_property PACKAGE_PIN C18 [get_ports {FMC_LA29_N}]
#NET FMC_LA29_N    LOC = C18  | IOSTANDARD=LVCMOS18;  # "FMC-LA29_N"
set_property PACKAGE_PIN C17 [get_ports {FMC_LA29_P}]
#NET FMC_LA29_P    LOC = C17  | IOSTANDARD=LVCMOS18;  # "FMC-LA29_P"
set_property PACKAGE_PIN B15 [get_ports {FMC_LA30_N}]
#NET FMC_LA30_N    LOC = B15  | IOSTANDARD=LVCMOS18;  # "FMC-LA30_N"
set_property PACKAGE_PIN C15 [get_ports {FMC_LA30_P}]
#NET FMC_LA30_P    LOC = C15  | IOSTANDARD=LVCMOS18;  # "FMC-LA30_P"
set_property PACKAGE_PIN B17 [get_ports {FMC_LA31_N}]
#NET FMC_LA31_N    LOC = B17  | IOSTANDARD=LVCMOS18;  # "FMC-LA31_N"
set_property PACKAGE_PIN B16 [get_ports {FMC_LA31_P}]
#NET FMC_LA31_P    LOC = B16  | IOSTANDARD=LVCMOS18;  # "FMC-LA31_P"
set_property PACKAGE_PIN A22 [get_ports {FMC_LA32_N}]
#NET FMC_LA32_N    LOC = A22  | IOSTANDARD=LVCMOS18;  # "FMC-LA32_N"
set_property PACKAGE_PIN A21 [get_ports {FMC_LA32_P}]
#NET FMC_LA32_P    LOC = A21  | IOSTANDARD=LVCMOS18;  # "FMC-LA32_P"
set_property PACKAGE_PIN B22 [get_ports {FMC_LA33_N}]
#NET FMC_LA33_N    LOC = B22  | IOSTANDARD=LVCMOS18;  # "FMC-LA33_N"
set_property PACKAGE_PIN B21 [get_ports {FMC_LA33_P}]
#NET FMC_LA33_P    LOC = B21  | IOSTANDARD=LVCMOS18;  # "FMC-LA33_P"
set_property PACKAGE_PIN G17 [get_ports {OTG_RESETN}]
#NET OTG_RESETN    LOC = G17  | IOSTANDARD=LVCMOS18;  # "OTG-RESETN"
set_property PACKAGE_PIN F22 [get_ports {SW0}]
#NET SW0           LOC = F22  | IOSTANDARD=LVCMOS18;  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {SW1}]
#NET SW1           LOC = G22  | IOSTANDARD=LVCMOS18;  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {SW2}]
#NET SW2           LOC = H22  | IOSTANDARD=LVCMOS18;  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {SW3}]
#NET SW3           LOC = F21  | IOSTANDARD=LVCMOS18;  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {SW4}]
#NET SW4           LOC = H19  | IOSTANDARD=LVCMOS18;  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {SW5}]
#NET SW5           LOC = H18  | IOSTANDARD=LVCMOS18;  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {SW6}]
#NET SW6           LOC = H17  | IOSTANDARD=LVCMOS18;  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {SW7}]
#NET SW7           LOC = M15  | IOSTANDARD=LVCMOS18;  # "SW7"
set_property PACKAGE_PIN E16 [get_ports {AD0N_R}]
#NET XADC_AD0N_R   LOC = E16;  # "XADC-AD0N-R"
set_property PACKAGE_PIN F16 [get_ports {AD0P_R}]
#NET XADC_AD0P_R   LOC = F16;  # "XADC-AD0P-R"
set_property PACKAGE_PIN D17 [get_ports {AD8N_N}]
#NET XADC_AD8N_R   LOC = D17;  # "XADC-AD8N-R"
set_property PACKAGE_PIN D16 [get_ports {AD8P_R}]
#NET XADC_AD8P_R   LOC = D16;  # "XADC-AD8P-R"

