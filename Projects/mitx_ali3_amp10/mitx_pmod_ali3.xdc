########################
# Physical Constraints #
########################

#
# Zynq Mini-ITX - Display Kit I/O constraints
#

# Native ALI3 (Avnet LCD Interface) Interface on the 3.3V powered bank 9,
# VADJ powered bank 13, and 1.8V powered bank 32.
set_property PACKAGE_PIN V21  [get_ports ali3_video_ali_rst_n];  # N/C
set_property PACKAGE_PIN P23  [get_ports ali3_video_ali_clk_p];  # CLK_P
set_property PACKAGE_PIN P24  [get_ports ali3_video_ali_clk_n];  # CLK_N
set_property PACKAGE_PIN T24  [get_ports {ali3_video_ali_data_p[0]}];  # D0_P
set_property PACKAGE_PIN T25  [get_ports {ali3_video_ali_data_n[0]}];  # D0_N
set_property PACKAGE_PIN U22  [get_ports {ali3_video_ali_data_p[1]}];  # D1_P
set_property PACKAGE_PIN V22  [get_ports {ali3_video_ali_data_n[1]}];  # D1_N
set_property PACKAGE_PIN T22  [get_ports {ali3_video_ali_data_p[2]}];  # D2_P
set_property PACKAGE_PIN T23  [get_ports {ali3_video_ali_data_n[2]}];  # D2_N
set_property PACKAGE_PIN P25  [get_ports {ali3_video_ali_data_p[3]}];  # D3_P
set_property PACKAGE_PIN P26  [get_ports {ali3_video_ali_data_n[3]}];  # D3_N
set_property IOSTANDARD LVCMOS25 [get_ports ali3_video_ali_rst_n*];
set_property IOSTANDARD LVDS_25  [get_ports ali3_video_ali_clk*];
set_property IOSTANDARD LVDS_25  [get_ports ali3_video_ali_data*];

set_property PACKAGE_PIN B15  [get_ports ali3_iic_scl_io];  # I2C_SCL
set_property PACKAGE_PIN A15  [get_ports ali3_iic_sda_io];  # I2C_SDA
set_property IOSTANDARD LVCMOS18 [get_ports ali3_iic*];

set_property PACKAGE_PIN AA20 [get_ports ali3_touch_irq];  # LVDS_IRQ_N
set_property IOSTANDARD LVCMOS33 [get_ports ali3_touch_irq*];


# User PL LEDs which are on the 1.5V powered Bank 34
set_property LOC C6 [ get_ports emio_user_tri_io[0]]; # "LED0" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[0]]

set_property LOC B6 [ get_ports emio_user_tri_io[1]]; # "LED1" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[1]]

set_property LOC L9 [ get_ports emio_user_tri_io[2]]; # "LED2" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[2]]

set_property LOC L10 [ get_ports emio_user_tri_io[3]]; # "LED3" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[3]]

set_property LOC K10 [ get_ports emio_user_tri_io[4]]; # "LED4" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[4]]

set_property LOC K11 [ get_ports emio_user_tri_io[5]]; # "LED5" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[5]]

set_property LOC L12 [ get_ports emio_user_tri_io[6]]; # "LED6" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[6]]

set_property LOC K12 [ get_ports emio_user_tri_io[7]]; # "LED7" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[7]]


## User DIP Switches which are on the 1.5V powered Bank 34
set_property LOC C7 [ get_ports emio_user_tri_io[8]]; # "SW0" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[8]]

set_property LOC B7 [ get_ports emio_user_tri_io[9]]; # "SW1" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[9]]

set_property LOC A7 [ get_ports emio_user_tri_io[10]]; # "SW2" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[10]]

set_property LOC B9 [ get_ports emio_user_tri_io[11]]; # "SW3" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[11]]

set_property LOC A8 [ get_ports emio_user_tri_io[12]]; # "SW4" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[12]]

set_property LOC A9 [ get_ports emio_user_tri_io[13]]; # "SW5" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[13]]

set_property LOC B10 [ get_ports emio_user_tri_io[14]]; # "SW6" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[14]]

set_property LOC A10 [ get_ports emio_user_tri_io[15]]; # "SW7" 
set_property IOSTANDARD LVCMOS15 [ get_ports emio_user_tri_io[15]]


# User PL Push Buttons which are on the 1.8V powered Bank 35
set_property LOC B14 [ get_ports emio_user_tri_io[16]]; # "PB0" 
set_property IOSTANDARD LVCMOS18 [ get_ports emio_user_tri_io[16]]

set_property LOC A14 [ get_ports emio_user_tri_io[17]]; # "PB1" 
set_property IOSTANDARD LVCMOS18 [ get_ports emio_user_tri_io[17]]

set_property LOC A13 [ get_ports emio_user_tri_io[18]]; # "PB2" 
set_property IOSTANDARD LVCMOS18 [ get_ports emio_user_tri_io[18]]

set_property LOC A12 [ get_ports emio_user_tri_io[19]]; # "PB3" 
set_property IOSTANDARD LVCMOS18 [ get_ports emio_user_tri_io[19]]


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
create_generated_clock -name ali3_clk [get_pins mitx_ali3_amp10_i/clk_wiz_0/U0/mmcm_adv_inst/CLKOUT0]

################
# Clock Groups #
################

set_clock_groups -asynchronous -group [get_clocks "clk_fpga_0" ] -group [get_clocks "clk_fpga_1" ] -group [get_clocks "ali3_clk" ]
