###################
# Pin Constraints #
###################

# Video Clock IDT5901
#
# PL Port      Pin  Schematic
#
# idt5901_clk_n  N3  PIXEL_CLK_N
# idt5901_clk_p  N4  PIXEL_CLK_P
#
set_property PACKAGE_PIN N3  [get_ports {idt5901_clk_n}]
set_property PACKAGE_PIN N4  [get_ports {idt5901_clk_p}]
set_property IOSTANDARD LVDS [get_ports {idt5901_clk_p idt5901_clk_n}]
