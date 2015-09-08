########################
# Physical Constraints #
########################

# I2C Chain on FMC-IMAGEON
set_property PACKAGE_PIN N17 [get_ports fmc_imageon_iic_scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_imageon_iic_scl_io]
set_property SLEW SLOW [get_ports fmc_imageon_iic_scl_io]
set_property DRIVE 8 [get_ports fmc_imageon_iic_scl_io]

set_property PACKAGE_PIN P18 [get_ports fmc_imageon_iic_sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_imageon_iic_sda_io]
set_property SLEW SLOW [get_ports fmc_imageon_iic_sda_io]
set_property DRIVE 8 [get_ports fmc_imageon_iic_sda_io]

set_property PACKAGE_PIN P20 [get_ports {fmc_imageon_iic_rst_n[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {fmc_imageon_iic_rst_n[0]}]
set_property SLEW SLOW [get_ports {fmc_imageon_iic_rst_n[0]}]
set_property DRIVE 8 [get_ports {fmc_imageon_iic_rst_n[0]}]

# HDMI Input (ADV7611) on FMC-IMAGEON
set_property PACKAGE_PIN K17 [get_ports IO_HDMII_clk]
set_property PACKAGE_PIN F20 [get_ports {IO_HDMII_data[0]}]
set_property PACKAGE_PIN F19 [get_ports {IO_HDMII_data[1]}]
set_property PACKAGE_PIN H20 [get_ports {IO_HDMII_data[2]}]
set_property PACKAGE_PIN G18 [get_ports {IO_HDMII_data[3]}]
set_property PACKAGE_PIN J19 [get_ports {IO_HDMII_data[4]}]
set_property PACKAGE_PIN J20 [get_ports {IO_HDMII_data[5]}]
set_property PACKAGE_PIN G17 [get_ports {IO_HDMII_data[6]}]
set_property PACKAGE_PIN K19 [get_ports {IO_HDMII_data[7]}]
set_property PACKAGE_PIN N16 [get_ports {IO_HDMII_data[8]}]
set_property PACKAGE_PIN N15 [get_ports {IO_HDMII_data[9]}]
set_property PACKAGE_PIN L15 [get_ports {IO_HDMII_data[10]}]
set_property PACKAGE_PIN L14 [get_ports {IO_HDMII_data[11]}]
set_property PACKAGE_PIN J14 [get_ports {IO_HDMII_data[12]}]
set_property PACKAGE_PIN K14 [get_ports {IO_HDMII_data[13]}]
set_property PACKAGE_PIN G15 [get_ports {IO_HDMII_data[14]}]
set_property PACKAGE_PIN H15 [get_ports {IO_HDMII_data[15]}]
set_property PACKAGE_PIN M20 [get_ports {IO_HDMII_spdif}]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMII_clk]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_data*}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_spdif}]

# HDMI Output (ADV7511) on FMC-IMAGEON
set_property PACKAGE_PIN K18 [get_ports IO_HDMIO_clk]
set_property PACKAGE_PIN M18 [get_ports {IO_HDMIO_data[0]}]
set_property PACKAGE_PIN M17 [get_ports {IO_HDMIO_data[1]}]
set_property PACKAGE_PIN E19 [get_ports {IO_HDMIO_data[2]}]
set_property PACKAGE_PIN L20 [get_ports {IO_HDMIO_data[3]}]
set_property PACKAGE_PIN E18 [get_ports {IO_HDMIO_data[4]}]
set_property PACKAGE_PIN F17 [get_ports {IO_HDMIO_data[5]}]
set_property PACKAGE_PIN H18 [get_ports {IO_HDMIO_data[6]}]
set_property PACKAGE_PIN L19 [get_ports {IO_HDMIO_data[7]}]
set_property PACKAGE_PIN F16 [get_ports {IO_HDMIO_data[8]}]
set_property PACKAGE_PIN D18 [get_ports {IO_HDMIO_data[9]}]
set_property PACKAGE_PIN J18 [get_ports {IO_HDMIO_data[10]}]
set_property PACKAGE_PIN H17 [get_ports {IO_HDMIO_data[11]}]
set_property PACKAGE_PIN E17 [get_ports {IO_HDMIO_data[12]}]
set_property PACKAGE_PIN D20 [get_ports {IO_HDMIO_data[13]}]
set_property PACKAGE_PIN H16 [get_ports {IO_HDMIO_data[14]}]
set_property PACKAGE_PIN D19 [get_ports {IO_HDMIO_data[15]}]
set_property PACKAGE_PIN M19 [get_ports IO_HDMIO_spdif]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_data*]
set_property IOB TRUE [get_ports IO_HDMIO_data*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_spdif]


# VITA interface
set_property PACKAGE_PIN T17 [get_ports IO_VITA_CAM_clk_pll]
set_property PACKAGE_PIN U19 [get_ports IO_VITA_CAM_reset_n]
set_property PACKAGE_PIN R18 [get_ports {IO_VITA_CAM_trigger[2]}]
set_property PACKAGE_PIN V17 [get_ports {IO_VITA_CAM_trigger[1]}]
set_property PACKAGE_PIN V18 [get_ports {IO_VITA_CAM_trigger[0]}]
set_property PACKAGE_PIN W18 [get_ports {IO_VITA_CAM_monitor[0]}]
set_property PACKAGE_PIN W19 [get_ports {IO_VITA_CAM_monitor[1]}]
set_property PACKAGE_PIN R16 [get_ports IO_VITA_SPI_spi_sclk]
set_property PACKAGE_PIN R17 [get_ports IO_VITA_SPI_spi_ssel_n]
set_property PACKAGE_PIN V16 [get_ports IO_VITA_SPI_spi_mosi]
set_property PACKAGE_PIN W16 [get_ports IO_VITA_SPI_spi_miso]
set_property PACKAGE_PIN N18 [get_ports IO_VITA_CAM_clk_out_p]
set_property PACKAGE_PIN P19 [get_ports IO_VITA_CAM_clk_out_n]
set_property PACKAGE_PIN Y18 [get_ports IO_VITA_CAM_sync_p]
set_property PACKAGE_PIN Y19 [get_ports IO_VITA_CAM_sync_n]
set_property PACKAGE_PIN V20 [get_ports {IO_VITA_CAM_data_p[0]}]
set_property PACKAGE_PIN W20 [get_ports {IO_VITA_CAM_data_n[0]}]
set_property PACKAGE_PIN U14 [get_ports {IO_VITA_CAM_data_p[1]}]
set_property PACKAGE_PIN U15 [get_ports {IO_VITA_CAM_data_n[1]}]
set_property PACKAGE_PIN T20 [get_ports {IO_VITA_CAM_data_p[2]}]
set_property PACKAGE_PIN U20 [get_ports {IO_VITA_CAM_data_n[2]}]
set_property PACKAGE_PIN T16 [get_ports {IO_VITA_CAM_data_p[3]}]
set_property PACKAGE_PIN U17 [get_ports {IO_VITA_CAM_data_n[3]}]
#set_property PACKAGE_PIN W14 [get_ports {IO_VITA_CAM_data_p[4]}];
#set_property PACKAGE_PIN Y14 [get_ports {IO_VITA_CAM_data_n[4]}];
#set_property PACKAGE_PIN V15 [get_ports {IO_VITA_CAM_data_p[5]}];
#set_property PACKAGE_PIN W15 [get_ports {IO_VITA_CAM_data_n[5]}];
#set_property PACKAGE_PIN Y16 [get_ports {IO_VITA_CAM_data_p[6]}];
#set_property PACKAGE_PIN Y17 [get_ports {IO_VITA_CAM_data_n[6]}];
#set_property PACKAGE_PIN P14 [get_ports {IO_VITA_CAM_data_p[7]}];
#set_property PACKAGE_PIN R14 [get_ports {IO_VITA_CAM_data_n[7]}];

set_property IOSTANDARD LVCMOS25 [get_ports IO_VITA_CAM_clk_pll]
set_property IOSTANDARD LVCMOS25 [get_ports IO_VITA_CAM_reset_n]
set_property IOSTANDARD LVCMOS25 [get_ports IO_VITA_CAM_trigger*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_VITA_CAM_monitor*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_VITA_SPI_spi_*]

set_property IOSTANDARD LVDS_25 [get_ports IO_VITA_CAM_clk_out_*]
set_property IOSTANDARD LVDS_25 [get_ports IO_VITA_CAM_sync_*]
set_property IOSTANDARD LVDS_25 [get_ports IO_VITA_CAM_data_*]

set_property DIFF_TERM true [get_ports IO_VITA_CAM_clk_out_*]
set_property DIFF_TERM true [get_ports IO_VITA_CAM_sync_*]
set_property DIFF_TERM true [get_ports IO_VITA_CAM_data_*]


# Video Clock Synthesizer
set_property PACKAGE_PIN U18 [get_ports fmc_imageon_vclk]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_imageon_vclk]

######################
#  Clock Constraints #
######################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 13.333 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period  6.667 -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]
#create_clock -period  5.000 -name clk_fpga_2 [get_nets -hierarchical FCLK_CLK2]

create_clock -period 6.730 -name video_clk [get_ports fmc_imageon_vclk]

create_clock -period 6.730 -name hdmii_clk [get_ports IO_HDMII_clk]

create_clock -period 2.692 -name vita_ser_clk [get_ports IO_VITA_CAM_clk_out_p]


# Define asynchronous clock domains
set_clock_groups -asynchronous  -group [get_clocks clk_fpga_0] \
                                -group [get_clocks clk_fpga_1] \
                                -group [get_clocks {n_3_serdesclockgen[0].ic}] \
                                -group [get_clocks video_clk] \
                                -group [get_clocks vita_clk] \
                                -group [get_clocks hdmii_clk] 
