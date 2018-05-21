

set_property PACKAGE_PIN Y11 [get_ports {pixel_in[2]}]
set_property PACKAGE_PIN AB11 [get_ports {pixel_in[3]}]
set_property PACKAGE_PIN AA11 [get_ports {pixel_in[4]}]
set_property PACKAGE_PIN AB10 [get_ports {pixel_in[5]}]
set_property PACKAGE_PIN Y10 [get_ports {pixel_in[6]}]
set_property PACKAGE_PIN AB9 [get_ports {pixel_in[7]}]
set_property PACKAGE_PIN AA9 [get_ports {pixel_in[8]}]
set_property PACKAGE_PIN AA8 [get_ports {pixel_in[9]}]

set_property PACKAGE_PIN W12 [get_ports {pixel_in[0]}]
set_property PACKAGE_PIN V12 [get_ports {pixel_in[1]}]

set_property PACKAGE_PIN W11 [get_ports hs_in]

set_property PACKAGE_PIN W10 [get_ports vs_in]

set_property PACKAGE_PIN W8 [get_ports pclk]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets pclk_IBUF]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets design_1_i/clk_wiz_0/inst/clk_in1_design_1_clk_wiz_0_0]



set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pixel_in[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports XCLK]
set_property PACKAGE_PIN V8 [get_ports XCLK]

#set_property IOSTANDARD LVCMOS18 [get_ports XCLK]
#set_property PACKAGE_PIN D21 [get_ports XCLK]

set_property IOSTANDARD LVCMOS33 [get_ports vs_in]
set_property IOSTANDARD LVCMOS33 [get_ports pclk]
set_property IOSTANDARD LVCMOS33 [get_ports hs_in]



#set_property PACKAGE_PIN V9 [get_ports cam_iic_sda_io]
#set_property PACKAGE_PIN V10 [get_ports cam_iic_scl_io]

set_property PACKAGE_PIN V10 [get_ports cam_iic_sda_io]
set_property PACKAGE_PIN V9 [get_ports cam_iic_scl_io]

set_property IOSTANDARD LVCMOS33 [get_ports cam_iic_sda_io]

set_property IOSTANDARD LVCMOS33 [get_ports cam_iic_scl_io]


#set_property PACKAGE_PIN Y21 [get_ports {vga_data[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[0]}]
#set_property PACKAGE_PIN Y20 [get_ports {vga_data[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[1]}]
#set_property PACKAGE_PIN AB20 [get_ports {vga_data[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[2]}]
#set_property PACKAGE_PIN AB19 [get_ports {vga_data[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[3]}]

#set_property PACKAGE_PIN AB22 [get_ports {vga_data[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[4]}]
#set_property PACKAGE_PIN AA22 [get_ports {vga_data[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[5]}]
#set_property PACKAGE_PIN AB21 [get_ports {vga_data[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[6]}]
#set_property PACKAGE_PIN AA21 [get_ports {vga_data[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[7]}]

#set_property PACKAGE_PIN V20 [get_ports {vga_data[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[8]}]
#set_property PACKAGE_PIN U20 [get_ports {vga_data[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[9]}]
#set_property PACKAGE_PIN V19 [get_ports {vga_data[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[10]}]
#set_property PACKAGE_PIN V18 [get_ports {vga_data[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {vga_data[11]}]

#set_property PACKAGE_PIN Y19 [get_ports vga_vs]
#set_property IOSTANDARD LVCMOS33 [get_ports vga_vs]
#set_property PACKAGE_PIN AA19 [get_ports vga_hs]
#set_property IOSTANDARD LVCMOS33 [get_ports vga_hs]





#NET HD_CLK       LOC = W18  | IOSTANDARD=LVCMOS33;  # "HD-CLK"
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports HDMI_CLK]
#NET HD_D0          LOC = Y13  | IOSTANDARD=LVCMOS33;  # "HD-D0"
set_property -dict {PACKAGE_PIN Y13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[0]}]
#NET HD_D1          LOC = AA13 | IOSTANDARD=LVCMOS33;  # "HD-D1"
set_property -dict {PACKAGE_PIN AA13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[1]}]
#NET HD_D10        LOC = W13  | IOSTANDARD=LVCMOS33;  # "HD-D10"
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[10]}]
#NET HD_D11        LOC = W15  | IOSTANDARD=LVCMOS33;  # "HD-D11"
set_property -dict {PACKAGE_PIN W15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[11]}]
#NET HD_D12        LOC = V15  | IOSTANDARD=LVCMOS33;  # "HD-D12"
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[12]}]
#NET HD_D13        LOC = U17  | IOSTANDARD=LVCMOS33;  # "HD-D13"
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[13]}]
#NET HD_D14        LOC = V14  | IOSTANDARD=LVCMOS33;  # "HD-D14"
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[14]}]
#NET HD_D15        LOC = V13  | IOSTANDARD=LVCMOS33;  # "HD-D15"
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[15]}]
#NET HD_D2          LOC = AA14 | IOSTANDARD=LVCMOS33;  # "HD-D2"
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[2]}]
#NET HD_D3           LOC = Y14  | IOSTANDARD=LVCMOS33;  # "HD-D3"
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[3]}]
#NET HD_D4          LOC = AB15 | IOSTANDARD=LVCMOS33;  # "HD-D4"
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[4]}]
#NET HD_D5          LOC = AB16 | IOSTANDARD=LVCMOS33;  # "HD-D5"
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[5]}]
#NET HD_D6          LOC = AA16 | IOSTANDARD=LVCMOS33;  # "HD-D6"
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[6]}]
#NET HD_D7          LOC = AB17 | IOSTANDARD=LVCMOS33;  # "HD-D7"
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[7]}]
#NET HD_D8          LOC = AA17 | IOSTANDARD=LVCMOS33;  # "HD-D8"
set_property -dict {PACKAGE_PIN AA17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[8]}]
#NET HD_D9          LOC = Y15  | IOSTANDARD=LVCMOS33;  # "HD-D9"
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports {HDMI_DATA[9]}]
#NET HD_DE          LOC = U16  | IOSTANDARD=LVCMOS33;  # "HD-DE"
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports HDMI_DE]
#NET HD_HSYNC      LOC = V17  | IOSTANDARD=LVCMOS33;  # "HD-HSYNC"
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports HDMI_HSYNC]
#NET HD_INT        LOC = W16  | IOSTANDARD=LVCMOS33;  # "HD-INT"
#NET HD_SCL        LOC = AA18 | IOSTANDARD=LVCMOS33;  # "HD-SCL"
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports iic_scl_io]
#NET HD_SDA        LOC = Y16  | IOSTANDARD=LVCMOS33;  # "HD-SDA"
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports iic_sda_io]
#NET HD_SPDIF      LOC = U15  | IOSTANDARD=LVCMOS33;  # "HD-SPDIF"
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports HDMI_SPDIF]

#NET HD_VSYNC      LOC = W17  | IOSTANDARD=LVCMOS33;  # "HD-VSYNC"
set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33 IOB TRUE} [get_ports HDMI_VSYNC]



set_property PULLUP true [get_ports iic_sda_io]
set_property PULLUP true [get_ports iic_scl_io]




create_clock -period 23.810 -name pclk -waveform {0.000 11.905} [get_ports pclk]
create_generated_clock -name HDMI_CLK -source [get_pins design_1_i/HDMI_OUT/zed_hdmi_out_0/U0/V6_GEN.ODDR_hdmi_clk_o/C] -divide_by 1 -invert [get_ports HDMI_CLK]
set_clock_groups -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks clk_fpga_1] -group [get_clocks [get_clocks -of_objects [get_pins design_1_i/CAM_IN_PIPE/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]] -group [get_clocks [get_clocks -of_objects [get_pins design_1_i/CAM_IN_PIPE/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT1]]] -group [get_clocks pclk]
