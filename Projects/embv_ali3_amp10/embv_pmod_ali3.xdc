########################
# Physical Constraints #
########################

#
# MicroZed with EMBV Carrier - Display Kit I/O constraints
#

# ALI3 (Avnet LCD Interface) Interface on PMOD-ALI3 which is on the VADJ 
# powered Bank 34 and 35 JC and JD Pmod pair.
set_property PACKAGE_PIN T20 [get_ports ali3_video_ali_rst_n];  # JX2_JC4-5_P
set_property PACKAGE_PIN N18 [get_ports ali3_video_ali_clk_p];  # JX1_JC0-1_P
set_property PACKAGE_PIN P19 [get_ports ali3_video_ali_clk_n];  # JX1_JC0-1_N
set_property PACKAGE_PIN R16 [get_ports {ali3_video_ali_data_p[0]}];  # JX1_JD0-1_P
set_property PACKAGE_PIN R17 [get_ports {ali3_video_ali_data_n[0]}];  # JX1_JD0-1_N
set_property PACKAGE_PIN T17 [get_ports {ali3_video_ali_data_p[1]}];  # JX1_JD2-3_P
set_property PACKAGE_PIN R18 [get_ports {ali3_video_ali_data_n[1]}];  # JX1_JD2-3_N
set_property PACKAGE_PIN V17 [get_ports {ali3_video_ali_data_p[2]}];  # JX1_JD4-5_P
set_property PACKAGE_PIN V18 [get_ports {ali3_video_ali_data_n[2]}];  # JX1_JD4-5_N
set_property PACKAGE_PIN W18 [get_ports {ali3_video_ali_data_p[3]}];  # JX1_JD6-7_P
set_property PACKAGE_PIN W19 [get_ports {ali3_video_ali_data_n[3]}];  # JX1_JD6-7_N
set_property PACKAGE_PIN U20 [get_ports ali3_touch_irq];  # JX1_JC4-5_N
set_property PACKAGE_PIN V20 [get_ports ali3_iic_scl_io];  # JX1_JC6-7_P
set_property PACKAGE_PIN W20 [get_ports ali3_iic_sda_io];  # JX1_JC6-7_N
set_property IOSTANDARD LVCMOS33 [get_ports ali3_video_ali_rst_n*];
set_property IOSTANDARD TMDS_33  [get_ports ali3_video_ali_clk*];
set_property IOSTANDARD TMDS_33  [get_ports ali3_video_ali_data*];
set_property IOSTANDARD LVCMOS33 [get_ports ali3_touch_irq*];
set_property IOSTANDARD LVCMOS33 [get_ports ali3_iic*];

##################
# Primary Clocks #
##################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 12.999 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period  7.000 -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]
#create_clock -period 10.000 -name clk_fpga_2 [get_nets -hierarchical FCLK_CLK2]

####################
# Generated Clocks #
####################

# Rename auto-generated clocks from MMCM
create_generated_clock -name ali3_clk [get_pins embv_ali3_amp10_i/clk_wiz_0/U0/mmcm_adv_inst/CLKOUT0]

################
# Clock Groups #
################

set_clock_groups -asynchronous -group [get_clocks "clk_fpga_0" ] -group [get_clocks "clk_fpga_1" ] -group [get_clocks "ali3_clk" ]

