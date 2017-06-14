#######################################################################
# MiniZed LEDs
# ->->->-> this should use board automation, but can't get it to work (May 3, 2017) -- see line 62 .\boards\MINIZED\MINIZED.tcl
# ...      C:\Xilinx\Vivado\2016.4\data\boards\board_files\minized\1.1\part0_pins.xml
#######################################################################
set_property PACKAGE_PIN E12 [get_ports pl_led_r_tri_o]
set_property IOSTANDARD LVCMOS33 [get_ports pl_led_r_tri_o]

set_property PACKAGE_PIN E13 [get_ports pl_led_g_tri_o]
set_property IOSTANDARD LVCMOS33 [get_ports pl_led_g_tri_o]
