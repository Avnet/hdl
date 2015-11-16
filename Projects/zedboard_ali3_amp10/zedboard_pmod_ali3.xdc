########################
# Physical Constraints #
########################

#
# ZedBoard Display Kit I/O constraints
#

# ALI3 (Avnet LCD Interface) Interface on PMOD-ALI3 which is on the 3.3V powered Bank 13
set_property PACKAGE_PIN R6 [get_ports ali3_video_ali_rst_n]; # PMOD-JC3P
set_property PACKAGE_PIN AB7 [get_ports ali3_video_ali_clk_p];  # PMOD-JC1P
set_property PACKAGE_PIN AB6 [get_ports ali3_video_ali_clk_n];  # PMOD-JC1N
set_property PACKAGE_PIN V7 [get_ports {ali3_video_ali_data_p[0]}];  # PMOD-JD1P
set_property PACKAGE_PIN W7 [get_ports {ali3_video_ali_data_n[0]}];  # PMOD-JD1N
set_property PACKAGE_PIN V5 [get_ports {ali3_video_ali_data_p[1]}];  # PMOD-JD2P
set_property PACKAGE_PIN V4 [get_ports {ali3_video_ali_data_n[1]}];  # PMOD-JD2N
set_property PACKAGE_PIN W6 [get_ports {ali3_video_ali_data_p[2]}];  # PMOD-JD3P
set_property PACKAGE_PIN W5 [get_ports {ali3_video_ali_data_n[2]}];  # PMOD-JD3N
set_property PACKAGE_PIN U6 [get_ports {ali3_video_ali_data_p[3]}];  # PMOD-JD4P
set_property PACKAGE_PIN U5 [get_ports {ali3_video_ali_data_n[3]}];  # PMOD-JD4N
set_property PACKAGE_PIN T6 [get_ports ali3_touch_irq]; # PMOD-JC3N
set_property PACKAGE_PIN T4 [get_ports ali3_iic_scl_io]; # PMOD-JC4P
set_property PACKAGE_PIN U4 [get_ports ali3_iic_sda_io]; # PMOD-JC4N
set_property IOSTANDARD LVCMOS33 [get_ports ali3_video_ali_rst_n*];
set_property IOSTANDARD TMDS_33  [get_ports ali3_video_ali_clk*];
set_property IOSTANDARD TMDS_33  [get_ports ali3_video_ali_data*];
set_property IOSTANDARD LVCMOS33 [get_ports ali3_touch_irq*];
set_property IOSTANDARD LVCMOS33 [get_ports ali3_iic*];


#
# ZedBoard User I/O constraints
#

# User PL LEDs which are on the 3.3V powered Bank 33
set_property PACKAGE_PIN T22 [get_ports {emio_user_tri_io[0]}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {emio_user_tri_io[1]}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {emio_user_tri_io[2]}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {emio_user_tri_io[3]}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {emio_user_tri_io[4]}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {emio_user_tri_io[5]}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {emio_user_tri_io[6]}];  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {emio_user_tri_io[7]}];  # "LD7"

# User PL DIP Switches which are on the VADJ powered Bank 35
set_property PACKAGE_PIN F22 [get_ports {emio_user_tri_io[8]}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {emio_user_tri_io[9]}];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {emio_user_tri_io[10]}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {emio_user_tri_io[11]}];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {emio_user_tri_io[12]}];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {emio_user_tri_io[13]}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {emio_user_tri_io[14]}];  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {emio_user_tri_io[15]}];  # "SW7"

# User PL Push Buttons which are on the VADJ powered Bank 34
set_property PACKAGE_PIN P16 [get_ports {emio_user_tri_io[16]}];  # "BTNC"
set_property PACKAGE_PIN R16 [get_ports {emio_user_tri_io[17]}];  # "BTND"
set_property PACKAGE_PIN N15 [get_ports {emio_user_tri_io[18]}];  # "BTNL"
set_property PACKAGE_PIN R18 [get_ports {emio_user_tri_io[19]}];  # "BTNR"
set_property PACKAGE_PIN T18 [get_ports {emio_user_tri_io[20]}];  # "BTNU"

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
create_generated_clock -name ali3_clk [get_pins zedboard_ali3_ampire10_i/clk_wiz_0/U0/mmcm_adv_inst/CLKOUT0]

################
# Clock Groups #
################

set_clock_groups -asynchronous -group [get_clocks "clk_fpga_0" ] -group [get_clocks "clk_fpga_1" ] -group [get_clocks "ali3_clk" ]
