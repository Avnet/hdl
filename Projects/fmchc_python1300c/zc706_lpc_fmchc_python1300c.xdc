########################
# Physical Constraints #
########################

# I2C Chain on FMC-HDMI-CAM
set_property PACKAGE_PIN AE18  [get_ports fmc_hdmi_cam_iic_scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_hdmi_cam_iic_scl_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_scl_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_scl_io]

set_property PACKAGE_PIN AE17  [get_ports fmc_hdmi_cam_iic_sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_hdmi_cam_iic_sda_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_sda_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_sda_io]

set_property PACKAGE_PIN AG15  [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property SLEW SLOW [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property DRIVE 8 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]

# HDMI Input (ADV7611) on FMC-HDMI-CAM
set_property PACKAGE_PIN AC28  [get_ports IO_HDMII_clk]
set_property PACKAGE_PIN AE26  [get_ports {IO_HDMII_data[0]}]
set_property PACKAGE_PIN AD25  [get_ports {IO_HDMII_data[1]}] 
set_property PACKAGE_PIN AF25  [get_ports {IO_HDMII_data[2]}]
set_property PACKAGE_PIN AJ29  [get_ports {IO_HDMII_data[3]}]
set_property PACKAGE_PIN AK30  [get_ports {IO_HDMII_data[4]}]
set_property PACKAGE_PIN AE25  [get_ports {IO_HDMII_data[5]}]
set_property PACKAGE_PIN AJ28  [get_ports {IO_HDMII_data[6]}]
set_property PACKAGE_PIN AJ30  [get_ports {IO_HDMII_data[7]}]
set_property PACKAGE_PIN Y27  [get_ports {IO_HDMII_data[8]}]
set_property PACKAGE_PIN Y26  [get_ports {IO_HDMII_data[9]}]
set_property PACKAGE_PIN AA30  [get_ports {IO_HDMII_data[10]}]
set_property PACKAGE_PIN Y30  [get_ports {IO_HDMII_data[11]}]
set_property PACKAGE_PIN AB30  [get_ports {IO_HDMII_data[12]}]
set_property PACKAGE_PIN AB29  [get_ports {IO_HDMII_data[13]}]
set_property PACKAGE_PIN AD29  [get_ports {IO_HDMII_data[14]}]
set_property PACKAGE_PIN AC29  [get_ports {IO_HDMII_data[15]}]
set_property PACKAGE_PIN AG30  [get_ports {IO_HDMII_spdif}]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMII_clk]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_data*}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_spdif}]

# HDMI Output (ADV7511) on FMC-HDMI-CAM
set_property PACKAGE_PIN AD28  [get_ports IO_HDMIO_clk]
set_property PACKAGE_PIN AG29  [get_ports {IO_HDMIO_data[0]}]
set_property PACKAGE_PIN AF29  [get_ports {IO_HDMIO_data[1]}]
set_property PACKAGE_PIN AH29  [get_ports {IO_HDMIO_data[2]}]
set_property PACKAGE_PIN AK26  [get_ports {IO_HDMIO_data[3]}]
set_property PACKAGE_PIN AH28  [get_ports {IO_HDMIO_data[4]}]
set_property PACKAGE_PIN AK28  [get_ports {IO_HDMIO_data[5]}]
set_property PACKAGE_PIN AF27  [get_ports {IO_HDMIO_data[6]}]
set_property PACKAGE_PIN AJ26  [get_ports {IO_HDMIO_data[7]}]
set_property PACKAGE_PIN AK27  [get_ports {IO_HDMIO_data[8]}]
set_property PACKAGE_PIN AH27  [get_ports {IO_HDMIO_data[9]}]
set_property PACKAGE_PIN AE27  [get_ports {IO_HDMIO_data[10]}]
set_property PACKAGE_PIN AC27  [get_ports {IO_HDMIO_data[11]}]
set_property PACKAGE_PIN AH26  [get_ports {IO_HDMIO_data[12]}]
set_property PACKAGE_PIN AG27  [get_ports {IO_HDMIO_data[13]}]
set_property PACKAGE_PIN AB27  [get_ports {IO_HDMIO_data[14]}]
set_property PACKAGE_PIN AG26  [get_ports {IO_HDMIO_data[15]}]
set_property PACKAGE_PIN AF30  [get_ports IO_HDMIO_spdif]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_data*]
set_property IOB TRUE [get_ports IO_HDMIO_data*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_spdif]


# Camera interface (PYTHON-1300) on FMC-HDMI-CAM
set_property PACKAGE_PIN AH17  [get_ports IO_PYTHON_CAM_clk_pll]
set_property PACKAGE_PIN AG16  [get_ports IO_PYTHON_CAM_reset_n]
set_property PACKAGE_PIN AH16  [get_ports {IO_PYTHON_CAM_trigger[2]}]
set_property PACKAGE_PIN AF18  [get_ports {IO_PYTHON_CAM_trigger[1]}]
set_property PACKAGE_PIN AF17  [get_ports {IO_PYTHON_CAM_trigger[0]}]
set_property PACKAGE_PIN AB15  [get_ports {IO_PYTHON_CAM_monitor[0]}]
set_property PACKAGE_PIN AB14  [get_ports {IO_PYTHON_CAM_monitor[1]}]
set_property PACKAGE_PIN AD16  [get_ports IO_PYTHON_SPI_spi_sclk]
set_property PACKAGE_PIN AD15  [get_ports IO_PYTHON_SPI_spi_ssel_n]
set_property PACKAGE_PIN AJ16  [get_ports IO_PYTHON_SPI_spi_mosi]
set_property PACKAGE_PIN AK16  [get_ports IO_PYTHON_SPI_spi_miso]
set_property PACKAGE_PIN AE13  [get_ports IO_PYTHON_CAM_clk_out_p]; #CAM_CLK_P
set_property PACKAGE_PIN AF13  [get_ports IO_PYTHON_CAM_clk_out_n]; #CAM_CLK_N
set_property PACKAGE_PIN AC14  [get_ports IO_PYTHON_CAM_sync_p]; #CAM_SYNC_P
set_property PACKAGE_PIN AC13  [get_ports IO_PYTHON_CAM_sync_n]; #CAM_SYNC_N
#set_property PACKAGE_PIN AH14  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA7_P
#set_property PACKAGE_PIN AH13  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA7_N
#set_property PACKAGE_PIN AD14  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA6_P
#set_property PACKAGE_PIN AD13  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA6_N
set_property PACKAGE_PIN AA15  [get_ports {IO_PYTHON_CAM_data_p[3]}]; #CAM_DATA5_P
set_property PACKAGE_PIN AA14  [get_ports {IO_PYTHON_CAM_data_n[3]}]; #CAM_DATA5_N
set_property PACKAGE_PIN AE16  [get_ports {IO_PYTHON_CAM_data_p[2]}]; #CAM_DATA4_P
set_property PACKAGE_PIN AE15  [get_ports {IO_PYTHON_CAM_data_n[2]}]; #CAM_DATA4_N
set_property PACKAGE_PIN AJ15  [get_ports {IO_PYTHON_CAM_data_p[1]}]; #CAM_DATA3_P
set_property PACKAGE_PIN AK15  [get_ports {IO_PYTHON_CAM_data_n[1]}]; #CAM_DATA3_N
set_property PACKAGE_PIN AB12  [get_ports {IO_PYTHON_CAM_data_p[0]}]; #CAM_DATA2_P
set_property PACKAGE_PIN AC12  [get_ports {IO_PYTHON_CAM_data_n[0]}]; #CAM_DATA2_N
#set_property PACKAGE_PIN AG12  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA1_P
#set_property PACKAGE_PIN AH12  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA1_N
#set_property PACKAGE_PIN AE12  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA0_P
#set_property PACKAGE_PIN AF12  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA0_N

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
set_property PACKAGE_PIN AG17  [get_ports fmc_hdmi_cam_vclk]
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
			       -group [get_clocks vita_clk_1] \
			       -group [get_clocks hdmii_clk] \
			       -group [get_clocks {*serdesclockgen[0].ic*}]

