########################
# Physical Constraints #
########################

# I2C Chain on FMC-HDMI-CAM
set_property PACKAGE_PIN AB14 [get_ports fmc_imageon_iic_scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_imageon_iic_scl_io]
set_property SLEW SLOW [get_ports fmc_imageon_iic_scl_io]
set_property DRIVE 8 [get_ports fmc_imageon_iic_scl_io]

set_property PACKAGE_PIN AB15 [get_ports fmc_imageon_iic_sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_imageon_iic_sda_io]
set_property SLEW SLOW [get_ports fmc_imageon_iic_sda_io]
set_property DRIVE 8 [get_ports fmc_imageon_iic_sda_io]

set_property PACKAGE_PIN Y16 [get_ports {fmc_imageon_iic_rst_n[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {fmc_imageon_iic_rst_n[0]}]
set_property SLEW SLOW [get_ports {fmc_imageon_iic_rst_n[0]}]
set_property DRIVE 8 [get_ports {fmc_imageon_iic_rst_n[0]}]

# HDMI Input (ADV7611) on FMC-HDMI-CAM
set_property PACKAGE_PIN Y6 [get_ports IO_HDMII_clk]
set_property PACKAGE_PIN AB4  [get_ports {IO_HDMII_data[0]}]
set_property PACKAGE_PIN AB5  [get_ports {IO_HDMII_data[1]}]
set_property PACKAGE_PIN AB11 [get_ports {IO_HDMII_data[2]}]
set_property PACKAGE_PIN AB1  [get_ports {IO_HDMII_data[3]}]
set_property PACKAGE_PIN U11  [get_ports {IO_HDMII_data[4]}]
set_property PACKAGE_PIN AA11 [get_ports {IO_HDMII_data[5]}]
set_property PACKAGE_PIN AB2  [get_ports {IO_HDMII_data[6]}]
set_property PACKAGE_PIN U12  [get_ports {IO_HDMII_data[7]}]
set_property PACKAGE_PIN AA4  [get_ports {IO_HDMII_data[8]}]
set_property PACKAGE_PIN Y4   [get_ports {IO_HDMII_data[9]}]
set_property PACKAGE_PIN Y10  [get_ports {IO_HDMII_data[10]}]
set_property PACKAGE_PIN Y11  [get_ports {IO_HDMII_data[11]}]
set_property PACKAGE_PIN AB6  [get_ports {IO_HDMII_data[12]}]
set_property PACKAGE_PIN AB7  [get_ports {IO_HDMII_data[13]}]
set_property PACKAGE_PIN AB9  [get_ports {IO_HDMII_data[14]}]
set_property PACKAGE_PIN AB10 [get_ports {IO_HDMII_data[15]}]
set_property PACKAGE_PIN U5  [get_ports {IO_HDMII_spdif}]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMII_clk]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_data*}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_spdif}]

# HDMI Output (ADV7511) on FMC-HDMI-CAM
set_property PACKAGE_PIN Y5 [get_ports IO_HDMIO_clk]
set_property PACKAGE_PIN AB12 [get_ports {IO_HDMIO_data[0]}]
set_property PACKAGE_PIN AA12 [get_ports {IO_HDMIO_data[1]}]
set_property PACKAGE_PIN V4 [get_ports {IO_HDMIO_data[2]}]
set_property PACKAGE_PIN W12 [get_ports {IO_HDMIO_data[3]}]
set_property PACKAGE_PIN V5 [get_ports {IO_HDMIO_data[4]}]
set_property PACKAGE_PIN U9 [get_ports {IO_HDMIO_data[5]}]
set_property PACKAGE_PIN AA8 [get_ports {IO_HDMIO_data[6]}]
set_property PACKAGE_PIN V12 [get_ports {IO_HDMIO_data[7]}]
set_property PACKAGE_PIN U10 [get_ports {IO_HDMIO_data[8]}]
set_property PACKAGE_PIN T6 [get_ports {IO_HDMIO_data[9]}]
set_property PACKAGE_PIN AA9 [get_ports {IO_HDMIO_data[10]}]
set_property PACKAGE_PIN AA6 [get_ports {IO_HDMIO_data[11]}]
set_property PACKAGE_PIN R6 [get_ports {IO_HDMIO_data[12]}]
set_property PACKAGE_PIN U4 [get_ports {IO_HDMIO_data[13]}]
set_property PACKAGE_PIN AA7 [get_ports {IO_HDMIO_data[14]}]
set_property PACKAGE_PIN T4 [get_ports {IO_HDMIO_data[15]}]
set_property PACKAGE_PIN U6 [get_ports IO_HDMIO_spdif]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_data*]
set_property IOB TRUE [get_ports IO_HDMIO_data*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_spdif]


# Camera interface (PYTHON-1300) on FMC-HDMI-CAM
set_property PACKAGE_PIN V22 [get_ports IO_PYTHON_CAM_clk_pll]
set_property PACKAGE_PIN AA18 [get_ports IO_PYTHON_CAM_reset_n]
set_property PACKAGE_PIN W22 [get_ports {IO_PYTHON_CAM_trigger[2]}]
set_property PACKAGE_PIN T22 [get_ports {IO_PYTHON_CAM_trigger[1]}]
set_property PACKAGE_PIN U22 [get_ports {IO_PYTHON_CAM_trigger[0]}]
set_property PACKAGE_PIN Y13 [get_ports {IO_PYTHON_CAM_monitor[0]}]
set_property PACKAGE_PIN AA13 [get_ports {IO_PYTHON_CAM_monitor[1]}]
set_property PACKAGE_PIN W15 [get_ports IO_PYTHON_SPI_spi_sclk]
set_property PACKAGE_PIN Y15 [get_ports IO_PYTHON_SPI_spi_ssel_n]
set_property PACKAGE_PIN Y14 [get_ports IO_PYTHON_SPI_spi_mosi]
set_property PACKAGE_PIN AA14 [get_ports IO_PYTHON_SPI_spi_miso]
set_property PACKAGE_PIN AA19 [get_ports IO_PYTHON_CAM_clk_out_n]
set_property PACKAGE_PIN Y21 [get_ports IO_PYTHON_CAM_sync_n]
#set_property PACKAGE_PIN U16 [get_ports {IO_PYTHON_CAM_data_n[7]}]
#set_property PACKAGE_PIN U21 [get_ports {IO_PYTHON_CAM_data_n[6]}]
#set_property PACKAGE_PIN AB17 [get_ports {IO_PYTHON_CAM_data_n[5]}]
#set_property PACKAGE_PIN AB20 [get_ports {IO_PYTHON_CAM_data_n[4]}]
set_property PACKAGE_PIN V13 [get_ports {IO_PYTHON_CAM_data_p[3]}];
set_property PACKAGE_PIN W13 [get_ports {IO_PYTHON_CAM_data_n[3]}];
set_property PACKAGE_PIN U17 [get_ports {IO_PYTHON_CAM_data_p[2]}];
set_property PACKAGE_PIN V17 [get_ports {IO_PYTHON_CAM_data_n[2]}];
set_property PACKAGE_PIN AA16 [get_ports {IO_PYTHON_CAM_data_p[1]}];
set_property PACKAGE_PIN AB16 [get_ports {IO_PYTHON_CAM_data_n[1]}];
set_property PACKAGE_PIN V14 [get_ports {IO_PYTHON_CAM_data_p[0]}];
set_property PACKAGE_PIN V15 [get_ports {IO_PYTHON_CAM_data_n[0]}];

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
set_property PACKAGE_PIN Y18 [get_ports fmc_imageon_vclk]
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

create_clock -period 2.692 -name vita_ser_clk [get_ports IO_PYTHON_CAM_clk_out_p]


# Define asynchronous clock domains
#set_clock_groups -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks clk_fpga_1] -group [get_clocks clk_fpga_2] -group [get_clocks -include_generated_clocks video_clk] -group [get_clocks -include_generated_clocks vita_ser_clk] -group [get_clocks hdmii_clk] 
set_clock_groups -asynchronous  -group [get_clocks clk_fpga_0] \
                                -group [get_clocks clk_fpga_1] \
                                -group [get_clocks {n_3_serdesclockgen[0].ic}] \
                                -group [get_clocks video_clk] \
				-group [get_clocks hdmii_clk] 
