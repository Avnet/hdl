########################
# Physical Constraints #
########################

#
# MicroZed with IO Carrier - Display Kit I/O constraints
#

# ALI3 (Avnet LCD Interface) Interface on PMOD-ALI3 which is on the VADJ 
# powered Bank 34 JA and JB Pmod pair.
set_property PACKAGE_PIN V12 [get_ports ali3_video_ali_rst_n]; # JX1_JA4-5_P
set_property PACKAGE_PIN T11 [get_ports ali3_video_ali_clk_p];  # JX1_JA0-1_P
set_property PACKAGE_PIN T10 [get_ports ali3_video_ali_clk_n];  # JX1_JA0-1_N
set_property PACKAGE_PIN Y16 [get_ports {ali3_video_ali_data_p[0]}];  # JX1_JB0-1_P
set_property PACKAGE_PIN Y17 [get_ports {ali3_video_ali_data_n[0]}];  # JX1_JB0-1_N
set_property PACKAGE_PIN W14 [get_ports {ali3_video_ali_data_p[1]}];  # JX1_JB2-3_P
set_property PACKAGE_PIN Y14 [get_ports {ali3_video_ali_data_n[1]}];  # JX1_JB2-3_N
set_property PACKAGE_PIN T16 [get_ports {ali3_video_ali_data_p[2]}];  # JX1_JB4-5_P
set_property PACKAGE_PIN U17 [get_ports {ali3_video_ali_data_n[2]}];  # JX1_JB4-5_N
set_property PACKAGE_PIN V15 [get_ports {ali3_video_ali_data_p[3]}];  # JX1_JB6-7_P
set_property PACKAGE_PIN W15 [get_ports {ali3_video_ali_data_n[3]}];  # JX1_JB6-7_N
set_property PACKAGE_PIN W13 [get_ports ali3_touch_irq];  # X1_JA4-5_N
set_property PACKAGE_PIN T14 [get_ports ali3_iic_scl_io];  # JX1_JA6-7_P
set_property PACKAGE_PIN T15 [get_ports ali3_iic_sda_io];  # JX1_JA6-7_N
set_property IOSTANDARD LVCMOS33 [get_ports ali3_video_ali_rst_n*];
set_property IOSTANDARD TMDS_33  [get_ports ali3_video_ali_clk*];
set_property IOSTANDARD TMDS_33  [get_ports ali3_video_ali_data*];
set_property IOSTANDARD LVCMOS33 [get_ports ali3_touch_irq*];
set_property IOSTANDARD LVCMOS33 [get_ports ali3_iic*];


#
# MicroZed with IO Carrier - User I/O constraints
#

# User PL LEDs which are on the VADJ powered Bank 34
set_property PACKAGE_PIN U14 [get_ports {emio_user_tri_io[0]}];  # "JX1_LED1"
set_property PACKAGE_PIN U15 [get_ports {emio_user_tri_io[1]}];  # "JX1_LED2"
set_property PACKAGE_PIN U18 [get_ports {emio_user_tri_io[2]}];  # "JX1_LED3"
set_property PACKAGE_PIN U19 [get_ports {emio_user_tri_io[3]}];  # "JX1_LED4"
set_property PACKAGE_PIN R19 [get_ports {emio_user_tri_io[4]}];  # "JX1_LED5"
set_property PACKAGE_PIN V13 [get_ports {emio_user_tri_io[5]}];  # "JX1_LED6"
set_property PACKAGE_PIN P14 [get_ports {emio_user_tri_io[6]}];  # "JX1_LED7"
set_property PACKAGE_PIN R14 [get_ports {emio_user_tri_io[7]}];  # "JX1_LED8"

# User PL DIP Switches which are on the VADJ powered Bank 35
set_property PACKAGE_PIN M14 [get_ports {emio_user_tri_io[8]}];  # "JX2_DIP_SW1"

set_property PACKAGE_PIN M15 [get_ports {emio_user_tri_io[9]}];  # "JX2_DIP_SW2"

set_property PACKAGE_PIN K16 [get_ports {emio_user_tri_io[10]}];  # "JX2_DIP_SW3"

set_property PACKAGE_PIN J16 [get_ports {emio_user_tri_io[11]}];  # "JX2_DIP_SW4"


# User PL Push Buttons which are on the VADJ powered Bank 35
set_property PACKAGE_PIN G19 [get_ports {emio_user_tri_io[12]}];  # "JX2_PB0"

set_property PACKAGE_PIN G20 [get_ports {emio_user_tri_io[13]}];  # "JX2_PB1"
set_property PACKAGE_PIN J20 [get_ports {emio_user_tri_io[14]}];  # "JX2_PB2"
set_property PACKAGE_PIN H20 [get_ports {emio_user_tri_io[15]}];  # "JX2_PB3"

set_property IOSTANDARD LVCMOS33 [get_ports emio_user_tri_io*];


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
create_generated_clock -name ali3_clk [get_pins microzed_iocc_ali3_amp10_i/clk_wiz_0/U0/mmcm_adv_inst/CLKOUT0]

################
# Clock Groups #
################

set_clock_groups -asynchronous -group [get_clocks "clk_fpga_0" ] -group [get_clocks "clk_fpga_1" ] -group [get_clocks "ali3_clk" ]

