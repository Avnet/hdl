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
set_property PACKAGE_PIN N4 [get_ports {idt5901_clk_p[0]}]
set_property PACKAGE_PIN N3 [get_ports {idt5901_clk_n[0]}]
set_property IOSTANDARD LVDS [get_ports {idt5901_clk_p[0]}]
set_property IOSTANDARD LVDS [get_ports {idt5901_clk_n[0]}]

#
# TDnext TDM114 - CAM1 - PMOD8 JX2 JB / PMOD7 JX2 JA
#
# PMOD8_0 / JA8.1 - G2 - pixel[2]
# PMOD8_1 / JA8.2 - F2 - pixel[4]
# PMOD8_2 / JA8.3 - G3 - pixel[6]
# PMOD8_3 / JA8.4 - F3 - pixel[8]
#
# PMOD8_4 / JA8.7 - E2 - pixel[3]
# PMOD8_5 / JA8.8 - E1 - pixel[5]
# PMOD8_6 / JA8.9 - F4 - pixel[7]
# PMOD8_7 / JA8.10- E4 - pixel[9]
#
# PMOD7_0 / JA7.1 - D2 - pixel[0]
# PMOD7_1 / JA7.2 - D1 - hsync
# PMOD7_2 / JA7.3 - A3 - iic_sda
# PMOD7_3 / JA7.4 - A2 - pclk
#
# PMOD7_4 / JA7.7 - C1 - pixel[1]
# PMOD7_5 / JA7.8 - B1 - vsync
# PMOD7_6 / JA7.9 - H4 - iic_scl
# PMOD7_7 / JA7.10- H3 - xclk

set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam1_pixel[0]}]
set_property PACKAGE_PIN D2 [get_ports {cam1_pixel[0]}]
set_property PACKAGE_PIN C1 [get_ports {cam1_pixel[1]}]
set_property PACKAGE_PIN G2 [get_ports {cam1_pixel[2]}]
set_property PACKAGE_PIN E2 [get_ports {cam1_pixel[3]}]
set_property PACKAGE_PIN F2 [get_ports {cam1_pixel[4]}]
set_property PACKAGE_PIN E1 [get_ports {cam1_pixel[5]}]
set_property PACKAGE_PIN G3 [get_ports {cam1_pixel[6]}]
set_property PACKAGE_PIN F4 [get_ports {cam1_pixel[7]}]
set_property PACKAGE_PIN F3 [get_ports {cam1_pixel[8]}]
set_property PACKAGE_PIN E4 [get_ports {cam1_pixel[9]}]

set_property IOSTANDARD LVCMOS18 [get_ports cam1_vsync]
set_property IOSTANDARD LVCMOS18 [get_ports cam1_hsync]
set_property IOSTANDARD LVCMOS18 [get_ports cam1_pclk]
set_property PACKAGE_PIN D1 [get_ports cam1_hsync]
set_property PACKAGE_PIN B1 [get_ports cam1_vsync]
set_property PACKAGE_PIN A2 [get_ports cam1_pclk]

set_property IOSTANDARD LVCMOS18 [get_ports cam1_xclk]
set_property PACKAGE_PIN H3 [get_ports cam1_xclk]

set_property IOSTANDARD LVCMOS18 [get_ports cam1_iic_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports cam1_iic_sda_io]
set_property PACKAGE_PIN A3 [get_ports cam1_iic_sda_io]
set_property PACKAGE_PIN H4 [get_ports cam1_iic_scl_io]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cam1_pclk_IBUF_inst/O]

set_property PULLUP true [get_ports cam1_iic_scl_io]
set_property PULLUP true [get_ports cam1_iic_sda_io]

#
# TDnext TDM114 - CAM2 - PMOD12 JX2 JF / PMOD11 JX2 JE
#
# PMOD12_0 / JA12.1 - H6 - pixel[2]
# PMOD12_1 / JA12.2 - G6 - pixel[4]
# PMOD12_2 / JA12.3 - G8 - pixel[6]
# PMOD12_3 / JA12.4 - F8 - pixel[8]
#
# PMOD12_4 / JA12.7 - G5 - pixel[3]
# PMOD12_5 / JA12.8 - F5 - pixel[5]
# PMOD12_6 / JA12.9 - B3 - pixel[7]
# PMOD12_7 / JA12.10- B2 - pixel[9]
#
# PMOD11_0 / JA11.1 - C8 - pixel[0]
# PMOD11_1 / JA11.2 - B8 - hsync
# PMOD11_2 / JA11.3 - H1 - iic_sda
# PMOD11_3 / JA11.4 - G1 - pclk
#
# PMOD11_4 / JA11.7 - A6 - pixel[1]
# PMOD11_5 / JA11.8 - A5 - vsync
# PMOD11_6 / JA11.9 - G7 - iic_scl
# PMOD11_7 / JA11.10- F7 - xclk

set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {cam2_pixel[0]}]
set_property PACKAGE_PIN C8 [get_ports {cam2_pixel[0]}]
set_property PACKAGE_PIN A6 [get_ports {cam2_pixel[1]}]
set_property PACKAGE_PIN H6 [get_ports {cam2_pixel[2]}]
set_property PACKAGE_PIN G5 [get_ports {cam2_pixel[3]}]
set_property PACKAGE_PIN G6 [get_ports {cam2_pixel[4]}]
set_property PACKAGE_PIN F5 [get_ports {cam2_pixel[5]}]
set_property PACKAGE_PIN G8 [get_ports {cam2_pixel[6]}]
set_property PACKAGE_PIN B3 [get_ports {cam2_pixel[7]}]
set_property PACKAGE_PIN F8 [get_ports {cam2_pixel[8]}]
set_property PACKAGE_PIN B2 [get_ports {cam2_pixel[9]}]

set_property IOSTANDARD LVCMOS18 [get_ports cam2_vsync]
set_property IOSTANDARD LVCMOS18 [get_ports cam2_hsync]
set_property IOSTANDARD LVCMOS18 [get_ports cam2_pclk]
set_property PACKAGE_PIN B8 [get_ports cam2_hsync]
set_property PACKAGE_PIN A5 [get_ports cam2_vsync]
set_property PACKAGE_PIN G1 [get_ports cam2_pclk]

set_property IOSTANDARD LVCMOS18 [get_ports cam2_xclk]
set_property PACKAGE_PIN F7 [get_ports cam2_xclk]

set_property IOSTANDARD LVCMOS18 [get_ports cam2_iic_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports cam2_iic_sda_io]
set_property PACKAGE_PIN H1 [get_ports cam2_iic_sda_io]
set_property PACKAGE_PIN G7 [get_ports cam2_iic_scl_io]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cam2_pclk_IBUF_inst/O]

set_property PULLUP true [get_ports cam2_iic_scl_io]
set_property PULLUP true [get_ports cam2_iic_sda_io]

#
# Lepton SPI interface on PMOD10 JX2 JD
#
# PMOD10_0 / JA10.1 - C4 - CS
# PMOD10_1 / JA10.2 - C3 - MOSI (io0)
# PMOD10_2 / JA10.3 - D4 - MISO (io1)
# PMOD10_3 / JA10.4 - D3 - CLK
set_property PACKAGE_PIN C4 [get_ports {lepton_spi_ss_io[0]}]
set_property PACKAGE_PIN C3 [get_ports lepton_spi_io0_io]
set_property PACKAGE_PIN D4 [get_ports lepton_spi_io1_io]
set_property PACKAGE_PIN D3 [get_ports lepton_spi_sck_io]

set_property IOSTANDARD LVCMOS18 [get_ports lepton_spi*]

#
# Lepton IIC interface on PMOD JA1
#
# PMOD10_4 / JA10.7 - A9 - SCL
# PMOD10_5 / JA10.8 - A8 - SDA
# PMOD10_6 / JA10.9 - C5 -
# PMOD10_7 / JA10.10- B5 -
set_property PACKAGE_PIN A9 [get_ports lepton_iic_scl_io]
set_property PACKAGE_PIN A8 [get_ports lepton_iic_sda_io]

set_property IOSTANDARD LVCMOS18 [get_ports lepton_iic*]
set_property PULLUP true [get_ports lepton_iic_scl_io]
set_property PULLUP true [get_ports lepton_iic_sda_io]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 65536 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list uz3eg_iocc_ev_i/clk_wiz_1/inst/clk_out3]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list cam2_iic_scl_i]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 65536 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list uz3eg_iocc_ev_i/zynq_ultra_ps_e_0/U0/pl_clk0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 1 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list cam1_iic_scl_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list cam2_iic_scl_o]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list cam2_iic_scl_t]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list cam2_iic_sda_i]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list cam2_iic_sda_o]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 1 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list cam1_iic_scl_o]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 1 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list cam1_iic_scl_t]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 1 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list cam1_iic_sda_i]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list cam1_iic_sda_t]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_1_pl_clk0]
