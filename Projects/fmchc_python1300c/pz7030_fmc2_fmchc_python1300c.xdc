########################
# Physical Constraints #
########################

# I2C Chain on FMC-HDMI-CAM
set_property PACKAGE_PIN B7    [get_ports fmc_hdmi_cam_iic_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports fmc_hdmi_cam_iic_scl_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_scl_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_scl_io]

set_property PACKAGE_PIN B6    [get_ports fmc_hdmi_cam_iic_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports fmc_hdmi_cam_iic_sda_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_sda_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_sda_io]

set_property PACKAGE_PIN C3    [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property SLEW SLOW [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property DRIVE 8 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]

# HDMI Input (ADV7611) on FMC-HDMI-CAM
set_property PACKAGE_PIN L5    [get_ports IO_HDMII_clk]
set_property PACKAGE_PIN M6    [get_ports {IO_HDMII_data[0]}]
set_property PACKAGE_PIN L6    [get_ports {IO_HDMII_data[1]}] 
set_property PACKAGE_PIN R4    [get_ports {IO_HDMII_data[2]}]
set_property PACKAGE_PIN R2    [get_ports {IO_HDMII_data[3]}]
set_property PACKAGE_PIN P1    [get_ports {IO_HDMII_data[4]}]
set_property PACKAGE_PIN R5    [get_ports {IO_HDMII_data[5]}]
set_property PACKAGE_PIN R3    [get_ports {IO_HDMII_data[6]}]
set_property PACKAGE_PIN N1    [get_ports {IO_HDMII_data[7]}]
set_property PACKAGE_PIN K8    [get_ports {IO_HDMII_data[8]}]
set_property PACKAGE_PIN J8    [get_ports {IO_HDMII_data[9]}]
set_property PACKAGE_PIN N5    [get_ports {IO_HDMII_data[10]}]
set_property PACKAGE_PIN N6    [get_ports {IO_HDMII_data[11]}]
set_property PACKAGE_PIN J6    [get_ports {IO_HDMII_data[12]}]
set_property PACKAGE_PIN J7    [get_ports {IO_HDMII_data[13]}]
set_property PACKAGE_PIN P5    [get_ports {IO_HDMII_data[14]}]
set_property PACKAGE_PIN P6    [get_ports {IO_HDMII_data[15]}]
set_property PACKAGE_PIN P2    [get_ports {IO_HDMII_spdif}]

set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMII_clk]
set_property IOSTANDARD LVCMOS18 [get_ports {IO_HDMII_data*}]
set_property IOSTANDARD LVCMOS18 [get_ports {IO_HDMII_spdif}]

# HDMI Output (ADV7511) on FMC-HDMI-CAM
set_property PACKAGE_PIN L4    [get_ports IO_HDMIO_clk]
set_property PACKAGE_PIN M1    [get_ports {IO_HDMIO_data[0]}]
set_property PACKAGE_PIN M2    [get_ports {IO_HDMIO_data[1]}]
set_property PACKAGE_PIN R7    [get_ports {IO_HDMIO_data[2]}]
set_property PACKAGE_PIN N3    [get_ports {IO_HDMIO_data[3]}]
set_property PACKAGE_PIN P7    [get_ports {IO_HDMIO_data[4]}]
set_property PACKAGE_PIN L1    [get_ports {IO_HDMIO_data[5]}]
set_property PACKAGE_PIN U1    [get_ports {IO_HDMIO_data[6]}]
set_property PACKAGE_PIN N4    [get_ports {IO_HDMIO_data[7]}]
set_property PACKAGE_PIN L2    [get_ports {IO_HDMIO_data[8]}]
set_property PACKAGE_PIN J1    [get_ports {IO_HDMIO_data[9]}]
set_property PACKAGE_PIN U2    [get_ports {IO_HDMIO_data[10]}]
set_property PACKAGE_PIN T1    [get_ports {IO_HDMIO_data[11]}]
set_property PACKAGE_PIN J2    [get_ports {IO_HDMIO_data[12]}]
set_property PACKAGE_PIN K2    [get_ports {IO_HDMIO_data[13]}]
set_property PACKAGE_PIN T2    [get_ports {IO_HDMIO_data[14]}]
set_property PACKAGE_PIN J3    [get_ports {IO_HDMIO_data[15]}]
set_property PACKAGE_PIN P3    [get_ports IO_HDMIO_spdif]

set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_data*]
set_property IOB TRUE [get_ports IO_HDMIO_data*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_spdif]


# Camera interface (PYTHON-1300) on FMC-HDMI-CAM
set_property PACKAGE_PIN A5    [get_ports IO_PYTHON_CAM_clk_pll]
set_property PACKAGE_PIN C4    [get_ports IO_PYTHON_CAM_reset_n]
set_property PACKAGE_PIN A4    [get_ports {IO_PYTHON_CAM_trigger[2]}]
set_property PACKAGE_PIN G8    [get_ports {IO_PYTHON_CAM_trigger[1]}]
set_property PACKAGE_PIN G7    [get_ports {IO_PYTHON_CAM_trigger[0]}]
set_property PACKAGE_PIN A7    [get_ports {IO_PYTHON_CAM_monitor[0]}]
set_property PACKAGE_PIN A6    [get_ports {IO_PYTHON_CAM_monitor[1]}]
set_property PACKAGE_PIN F7    [get_ports IO_PYTHON_SPI_spi_sclk]
set_property PACKAGE_PIN E7    [get_ports IO_PYTHON_SPI_spi_ssel_n]
set_property PACKAGE_PIN D7    [get_ports IO_PYTHON_SPI_spi_mosi]
set_property PACKAGE_PIN D6    [get_ports IO_PYTHON_SPI_spi_miso]
set_property PACKAGE_PIN B4    [get_ports IO_PYTHON_CAM_clk_out_p]; #CAM_CLK_P
set_property PACKAGE_PIN B3    [get_ports IO_PYTHON_CAM_clk_out_n]; #CAM_CLK_N
set_property PACKAGE_PIN E2    [get_ports IO_PYTHON_CAM_sync_p]; #CAM_SYNC_P
set_property PACKAGE_PIN D2    [get_ports IO_PYTHON_CAM_sync_n]; #CAM_SYNC_N
#set_property PACKAGE_PIN A2    [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA7_P
#set_property PACKAGE_PIN A1    [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA7_N
#set_property PACKAGE_PIN D1    [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA6_P
#set_property PACKAGE_PIN C1    [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA6_N
set_property PACKAGE_PIN C6    [get_ports {IO_PYTHON_CAM_data_p[3]}]; #CAM_DATA5_P
set_property PACKAGE_PIN C5    [get_ports {IO_PYTHON_CAM_data_n[3]}]; #CAM_DATA5_N
set_property PACKAGE_PIN E8    [get_ports {IO_PYTHON_CAM_data_p[2]}]; #CAM_DATA4_P
set_property PACKAGE_PIN D8    [get_ports {IO_PYTHON_CAM_data_n[2]}]; #CAM_DATA4_N
set_property PACKAGE_PIN B2    [get_ports {IO_PYTHON_CAM_data_p[1]}]; #CAM_DATA3_P
set_property PACKAGE_PIN B1    [get_ports {IO_PYTHON_CAM_data_n[1]}]; #CAM_DATA3_N
set_property PACKAGE_PIN H1    [get_ports {IO_PYTHON_CAM_data_p[0]}]; #CAM_DATA2_P
set_property PACKAGE_PIN G1    [get_ports {IO_PYTHON_CAM_data_n[0]}]; #CAM_DATA2_N
#set_property PACKAGE_PIN G6    [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA1_P
#set_property PACKAGE_PIN F6    [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA1_N
#set_property PACKAGE_PIN E4    [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA0_P
#set_property PACKAGE_PIN E3    [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA0_N

set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_CAM_clk_pll]
set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_CAM_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_CAM_trigger*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_CAM_monitor*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_PYTHON_SPI_spi_*]

set_property IOSTANDARD LVDS [get_ports IO_PYTHON_CAM_clk_out_*]
set_property IOSTANDARD LVDS [get_ports IO_PYTHON_CAM_sync_*]
set_property IOSTANDARD LVDS [get_ports IO_PYTHON_CAM_data_*]

set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_clk_out_*]
set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_sync_*]
set_property DIFF_TERM true [get_ports IO_PYTHON_CAM_data_*]


# Video Clock Synthesizer on FMC-HDMI-CAM
set_property PACKAGE_PIN D5    [get_ports fmc_hdmi_cam_vclk]
set_property IOSTANDARD LVCMOS18 [get_ports fmc_hdmi_cam_vclk]

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
                               -group [get_clocks clk_out1_*_clk_wiz_*] \
                               -group [get_clocks clk_out2_*_clk_wiz_*] \
                               -group [get_clocks video_clk] \
                               -group [get_clocks hdmii_clk] \
                               -group [get_clocks *CLKDIV*] \
                               -group [get_clocks vita_clk*]

set_input_delay -clock [get_clocks hdmii_clk] -clock_fall -min -add_delay 0.500 [get_ports {fmc_hdmii_data[*]}]
set_input_delay -clock [get_clocks hdmii_clk] -clock_fall -max -add_delay 1.300 [get_ports {fmc_hdmii_data[*]}]

