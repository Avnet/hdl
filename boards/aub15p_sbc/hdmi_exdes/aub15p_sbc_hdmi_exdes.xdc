set_property PACKAGE_PIN AF15 [get_ports sys_uart_txd]
set_property IOSTANDARD LVCMOS18 [get_ports sys_uart_txd]

set_property PACKAGE_PIN AF14 [get_ports sys_uart_rxd]
set_property IOSTANDARD LVCMOS18 [get_ports sys_uart_rxd]

set_property PACKAGE_PIN A10 [get_ports HDMI_TX_LOCKED_LED]
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_TX_LOCKED_LED]

set_property PACKAGE_PIN P7 [get_ports HDMI_RX_CLK_P_IN]

set_property PACKAGE_PIN T24 [get_ports {RX_HPD_OUT[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {RX_HPD_OUT[0]}]

set_property PACKAGE_PIN N26 [get_ports RX_DDC_OUT_scl_io]
set_property IOSTANDARD LVCMOS12 [get_ports RX_DDC_OUT_scl_io]
set_property DRIVE 8 [get_ports RX_DDC_OUT_scl_io]

set_property PACKAGE_PIN T19 [get_ports RX_DDC_OUT_sda_io]
set_property IOSTANDARD LVCMOS12 [get_ports RX_DDC_OUT_sda_io]
set_property DRIVE 8 [get_ports RX_DDC_OUT_sda_io]

set_property PACKAGE_PIN U24 [get_ports RX_DET_IN]
set_property IOSTANDARD LVCMOS12 [get_ports RX_DET_IN]

set_property PACKAGE_PIN L18 [get_ports RX_REFCLK_P_OUT]
set_property IOSTANDARD DIFF_HSUL_12 [get_ports RX_REFCLK_P_OUT]
set_property SLEW SLOW [get_ports RX_REFCLK_P_OUT]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports RX_REFCLK_P_OUT]

set_property PACKAGE_PIN P25 [get_ports {CLK297_clk_p[0]}]
set_property IOSTANDARD DIFF_HSUL_12 [get_ports {CLK297_clk_p[0]}]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports {CLK297_clk_p[0]}]

set_property PACKAGE_PIN R22 [get_ports fmch_iic_scl_io]
set_property IOSTANDARD LVCMOS12 [get_ports fmch_iic_scl_io]
set_property DRIVE 8 [get_ports fmch_iic_scl_io]

set_property PACKAGE_PIN R23 [get_ports fmch_iic_sda_io]
set_property IOSTANDARD LVCMOS12 [get_ports fmch_iic_sda_io]
set_property DRIVE 8 [get_ports fmch_iic_sda_io]

set_property PACKAGE_PIN T25 [get_ports HDMI_TX_CLK_P_OUT]
set_property IOSTANDARD DIFF_HSUL_12 [get_ports HDMI_TX_CLK_P_OUT]
set_property OUTPUT_IMPEDANCE RDRV_40_40 [get_ports HDMI_TX_CLK_P_OUT]
set_property SLEW SLOW [get_ports HDMI_TX_CLK_P_OUT]

set_property PACKAGE_PIN AD14 [get_ports {RX_I2C_EN_N_OUT[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {RX_I2C_EN_N_OUT[0]}]

set_property PACKAGE_PIN AD21 [get_ports system_clock_300mhz_clk_p]
set_property IOSTANDARD DIFF_SSTL12 [get_ports system_clock_300mhz_clk_p]

set_property PACKAGE_PIN V19 [get_ports system_resetn]
set_property IOSTANDARD LVCMOS12 [get_ports system_resetn]

set_property PACKAGE_PIN AA23 [get_ports {TX_CLKSEL_OUT[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {TX_CLKSEL_OUT[0]}]

set_property PACKAGE_PIN Y23 [get_ports {TX_EN_OUT[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {TX_EN_OUT[0]}]

set_property PACKAGE_PIN W21 [get_ports TX_HPD_IN]
set_property IOSTANDARD LVCMOS12 [get_ports TX_HPD_IN]

set_property PACKAGE_PIN R25 [get_ports TX_DDC_OUT_scl_io]
set_property IOSTANDARD LVCMOS12 [get_ports TX_DDC_OUT_scl_io]
set_property DRIVE 8 [get_ports TX_DDC_OUT_scl_io]

set_property PACKAGE_PIN R26 [get_ports TX_DDC_OUT_sda_io]
set_property IOSTANDARD LVCMOS12 [get_ports TX_DDC_OUT_sda_io]
set_property DRIVE 8 [get_ports TX_DDC_OUT_sda_io]

set_property PACKAGE_PIN M7 [get_ports TX_REFCLK_P_IN]

set_property PACKAGE_PIN C11 [get_ports {BLINKY_LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {BLINKY_LED[0]}]

