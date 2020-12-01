#####
## Constraints for HDMI UZ7EVCC
## Version 1.0
#####


#####
## Pins
#####

# HDMI RX
set_property PACKAGE_PIN B10 [get_ports HDMI_RX_CLK_P_IN]
#create_clock -name rx_mgt_refclk -period 3.367 [get_ports HDMI_RX_CLK_P_IN]

#set_property PACKAGE_PIN ??L27 [get_ports DRU_CLK_IN_clk_p]
#create_clock -name dru_mgt_refclk -period 6.400 [get_ports DRU_CLK_IN_clk_p]

set_property PACKAGE_PIN H14 [get_ports RX_HPD_OUT]
set_property IOSTANDARD LVCMOS33 [get_ports RX_HPD_OUT]

set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_OUT_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_OUT_sda_io]
set_property PACKAGE_PIN E12 [get_ports RX_DDC_OUT_scl_io]
set_property PACKAGE_PIN F12 [get_ports RX_DDC_OUT_sda_io]

#NO REC CLOCK
#set_property IOSTANDARD LVDS [get_ports RX_REFCLK_P_OUT]
#set_property PACKAGE_PIN ??AG5 [get_ports RX_REFCLK_P_OUT]

set_property PACKAGE_PIN G14 [get_ports RX_DET_IN]
set_property IOSTANDARD LVCMOS33 [get_ports RX_DET_IN]



# HDMI TX
set_property PACKAGE_PIN D10 [get_ports TX_REFCLK_P_IN]
#create_clock -name tx_mgt_refclk -period 3.367 [get_ports TX_REFCLK_P_IN]

set_property IOSTANDARD LVDS [get_ports HDMI_TX_CLK_P_OUT]
set_property PACKAGE_PIN AD15 [get_ports HDMI_TX_CLK_P_OUT]

set_property IOSTANDARD LVCMOS33 [get_ports TX_HPD_IN]
set_property PACKAGE_PIN C14 [get_ports TX_HPD_IN]

set_property PACKAGE_PIN A14 [get_ports {TX_EN_OUT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TX_EN_OUT[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_OUT_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_OUT_sda_io]
set_property PACKAGE_PIN E13 [get_ports TX_DDC_OUT_scl_io]
set_property PACKAGE_PIN E14 [get_ports TX_DDC_OUT_sda_io]
set_property PULLUP true [get_ports TX_DDC_OUT_scl_io]
set_property PULLUP true [get_ports TX_DDC_OUT_sda_io]

#
# HDMI Control I2C
#
# UZ7EV CC => HDMI_CTL_SDL/SDA (HD_SE_18_GC_N/P) => DP159 (U9) / M24C24 (U10)
set_property IOSTANDARD LVCMOS33 [get_ports fmch_iic_scl_io]
set_property PACKAGE_PIN F13 [get_ports fmch_iic_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports fmch_iic_sda_io]
set_property PACKAGE_PIN G13 [get_ports fmch_iic_sda_io]
set_property PULLUP true [get_ports fmch_iic_scl_io]
set_property PULLUP true [get_ports fmch_iic_sda_io]

# Misc
#GPIO_LED_1_LS
set_property PACKAGE_PIN AC14 [get_ports LED1]
set_property IOSTANDARD LVCMOS18 [get_ports LED1]

#GPIO_LED_7_LS
set_property PACKAGE_PIN AG4 [get_ports TX_HPD_LED]
set_property IOSTANDARD LVCMOS18 [get_ports TX_HPD_LED]

#PB SW1
set_property PACKAGE_PIN AA13 [get_ports TX_REFCLK_RDY_PB]
set_property IOSTANDARD LVCMOS18 [get_ports TX_REFCLK_RDY_PB]

#NOT SURE: already HW connected to  CC_RESET_OUT_N
#set_property PACKAGE_PIN J12 [get_ports SI5324_RST_OUT]
#set_property IOSTANDARD LVCMOS33 [get_ports SI5324_RST_OUT]


#####
## End
#####

