########################
# Physical Constraints #
########################

# I2C Chain on FMC-HDMI-CAM
set_property PACKAGE_PIN AA24  [get_ports fmc_hdmi_cam_iic_scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_hdmi_cam_iic_scl_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_scl_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_scl_io]

set_property PACKAGE_PIN AB24  [get_ports fmc_hdmi_cam_iic_sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_hdmi_cam_iic_sda_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_sda_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_sda_io]

set_property PACKAGE_PIN AH21  [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property SLEW SLOW [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property DRIVE 8 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]

# HDMI Input (ADV7611) on FMC-HDMI-CAM
set_property PACKAGE_PIN U26  [get_ports IO_HDMII_clk]
set_property PACKAGE_PIN R30  [get_ports {IO_HDMII_data[0]}]
set_property PACKAGE_PIN P30  [get_ports {IO_HDMII_data[1]}] 
set_property PACKAGE_PIN R26  [get_ports {IO_HDMII_data[2]}]
set_property PACKAGE_PIN V29  [get_ports {IO_HDMII_data[3]}]
set_property PACKAGE_PIN T28  [get_ports {IO_HDMII_data[4]}]
set_property PACKAGE_PIN R25  [get_ports {IO_HDMII_data[5]}]
set_property PACKAGE_PIN V28  [get_ports {IO_HDMII_data[6]}]
set_property PACKAGE_PIN R28  [get_ports {IO_HDMII_data[7]}]
set_property PACKAGE_PIN R21  [get_ports {IO_HDMII_data[8]}]
set_property PACKAGE_PIN P21  [get_ports {IO_HDMII_data[9]}]
set_property PACKAGE_PIN N27  [get_ports {IO_HDMII_data[10]}]
set_property PACKAGE_PIN N26  [get_ports {IO_HDMII_data[11]}]
set_property PACKAGE_PIN P24  [get_ports {IO_HDMII_data[12]}]
set_property PACKAGE_PIN P23  [get_ports {IO_HDMII_data[13]}]
set_property PACKAGE_PIN P29  [get_ports {IO_HDMII_data[14]}]
set_property PACKAGE_PIN N29  [get_ports {IO_HDMII_data[15]}]
set_property PACKAGE_PIN U30  [get_ports {IO_HDMII_spdif}]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMII_clk]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_data*}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_spdif}]

# HDMI Output (ADV7511) on FMC-HDMI-CAM
set_property PACKAGE_PIN U27  [get_ports IO_HDMIO_clk]
set_property PACKAGE_PIN U29  [get_ports {IO_HDMIO_data[0]}]
set_property PACKAGE_PIN T29  [get_ports {IO_HDMIO_data[1]}]
set_property PACKAGE_PIN W30  [get_ports {IO_HDMIO_data[2]}]
set_property PACKAGE_PIN P26  [get_ports {IO_HDMIO_data[3]}]
set_property PACKAGE_PIN W29  [get_ports {IO_HDMIO_data[4]}]
set_property PACKAGE_PIN W28  [get_ports {IO_HDMIO_data[5]}]
set_property PACKAGE_PIN W26  [get_ports {IO_HDMIO_data[6]}]
set_property PACKAGE_PIN P25  [get_ports {IO_HDMIO_data[7]}]
set_property PACKAGE_PIN V27  [get_ports {IO_HDMIO_data[8]}]
set_property PACKAGE_PIN T25  [get_ports {IO_HDMIO_data[9]}]
set_property PACKAGE_PIN W25  [get_ports {IO_HDMIO_data[10]}]
set_property PACKAGE_PIN W24  [get_ports {IO_HDMIO_data[11]}]
set_property PACKAGE_PIN T24  [get_ports {IO_HDMIO_data[12]}]
set_property PACKAGE_PIN V26  [get_ports {IO_HDMIO_data[13]}]
set_property PACKAGE_PIN V23  [get_ports {IO_HDMIO_data[14]}]
set_property PACKAGE_PIN U25  [get_ports {IO_HDMIO_data[15]}]
set_property PACKAGE_PIN T30  [get_ports IO_HDMIO_spdif]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_data*]
set_property IOB TRUE [get_ports IO_HDMIO_data*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_spdif]


# Camera interface (PYTHON-1300) on FMC-HDMI-CAM
set_property PACKAGE_PIN AA22  [get_ports IO_PYTHON_CAM_clk_pll]
set_property PACKAGE_PIN AF22  [get_ports IO_PYTHON_CAM_reset_n]
set_property PACKAGE_PIN AA23  [get_ports {IO_PYTHON_CAM_trigger[2]}]
set_property PACKAGE_PIN AC24  [get_ports {IO_PYTHON_CAM_trigger[1]}]
set_property PACKAGE_PIN AD24  [get_ports {IO_PYTHON_CAM_trigger[0]}]
set_property PACKAGE_PIN Y22  [get_ports {IO_PYTHON_CAM_monitor[0]}]
set_property PACKAGE_PIN Y23  [get_ports {IO_PYTHON_CAM_monitor[1]}]
set_property PACKAGE_PIN AF23  [get_ports IO_PYTHON_SPI_spi_sclk]
set_property PACKAGE_PIN AF24  [get_ports IO_PYTHON_SPI_spi_ssel_n]
set_property PACKAGE_PIN AD23  [get_ports IO_PYTHON_SPI_spi_mosi]
set_property PACKAGE_PIN AE23  [get_ports IO_PYTHON_SPI_spi_miso]
set_property PACKAGE_PIN AF20  [get_ports IO_PYTHON_CAM_clk_out_p]; #CAM_CLK_P
set_property PACKAGE_PIN AG20  [get_ports IO_PYTHON_CAM_clk_out_n]; #CAM_CLK_N
set_property PACKAGE_PIN AG24  [get_ports IO_PYTHON_CAM_sync_p]; #CAM_SYNC_P
set_property PACKAGE_PIN AG25  [get_ports IO_PYTHON_CAM_sync_n]; #CAM_SYNC_N
#set_property PACKAGE_PIN AD21  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA7_P
#set_property PACKAGE_PIN AE21  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA7_N
#set_property PACKAGE_PIN AF19  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA6_P
#set_property PACKAGE_PIN AG19  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA6_N
set_property PACKAGE_PIN AJ23  [get_ports {IO_PYTHON_CAM_data_p[3]}]; #CAM_DATA5_P
set_property PACKAGE_PIN AJ24  [get_ports {IO_PYTHON_CAM_data_n[3]}]; #CAM_DATA5_N
set_property PACKAGE_PIN AH23  [get_ports {IO_PYTHON_CAM_data_p[2]}]; #CAM_DATA4_P
set_property PACKAGE_PIN AH24  [get_ports {IO_PYTHON_CAM_data_n[2]}]; #CAM_DATA4_N
set_property PACKAGE_PIN AJ20  [get_ports {IO_PYTHON_CAM_data_p[1]}]; #CAM_DATA3_P
set_property PACKAGE_PIN AK20  [get_ports {IO_PYTHON_CAM_data_n[1]}]; #CAM_DATA3_N
set_property PACKAGE_PIN AG22  [get_ports {IO_PYTHON_CAM_data_p[0]}]; #CAM_DATA2_P
set_property PACKAGE_PIN AH22  [get_ports {IO_PYTHON_CAM_data_n[0]}]; #CAM_DATA2_N
#set_property PACKAGE_PIN AH19  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA1_P
#set_property PACKAGE_PIN AJ19  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA1_N
#set_property PACKAGE_PIN AK17  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA0_P
#set_property PACKAGE_PIN AK18  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA0_N

set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_CAM_clk_pll]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_CAM_reset_n]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_CAM_trigger*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_CAM_monitor*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_PYTHON_SPI_spi_*]

set_property IOSTANDARD LVDS_25 [get_ports IO_PYTHON_CAM_clk_out_*]
set_property IOSTANDARD LVDS_25 [get_ports IO_PYTHON_CAM_sync_*]
set_property IOSTANDARD LVDS_25 [get_ports IO_PYTHON_CAM_data_*]

set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_clk_out_*]
set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_sync_*]
set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_data_*]


# Video Clock Synthesizer on FMC-HDMI-CAM
set_property PACKAGE_PIN AE22  [get_ports fmc_hdmi_cam_vclk]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_hdmi_cam_vclk]

######################
#  Clock Constraints #
######################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 13.333 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period  6.667 -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]
#create_clock -period  5.000 -name clk_fpga_2 [get_nets -hierarchical FCLK_CLK2]

create_clock -period 6.730 -name video_clk [get_ports fmc_hdmi_cam_vclk]

create_clock -period 6.730 -name hdmii_clk [get_ports IO_HDMII_clk]

create_clock -period 3.703 -name vita_ser_clk [get_ports IO_PYTHON_CAM_clk_out_p]


# Define asynchronous clock domains
set_clock_groups -asynchronous -group [get_clocks clk_fpga_0] \
                               -group [get_clocks clk_fpga_1] \
                               -group [get_clocks clk_out1_fmchc_python1300c_clk_wiz_0_0_1] \
                               -group [get_clocks clk_out2_fmchc_python1300c_clk_wiz_0_0_1] \
                               -group [get_clocks hdmii_clk] \
                               -group [get_clocks CLKDIV_c_0] \
                               -group [get_clocks vita_clk_div4_l_n_0_1]

