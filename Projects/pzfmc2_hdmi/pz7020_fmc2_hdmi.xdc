########################
# Physical Constraints #
########################

# I2C Chain on PicoZed FMC Carrier V2
set_property PACKAGE_PIN R19 [get_ports pzfmc2_iic_scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports pzfmc2_iic_scl_io]
set_property SLEW SLOW [get_ports pzfmc2_iic_scl_io]
set_property DRIVE 8 [get_ports pzfmc2_iic_scl_io]

set_property PACKAGE_PIN T19 [get_ports pzfmc2_iic_sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports pzfmc2_iic_sda_io]
set_property SLEW SLOW [get_ports pzfmc2_iic_sda_io]
set_property DRIVE 8 [get_ports pzfmc2_iic_sda_io]

# # ----------------------------------------------------------------------------
# # I2C Peripherals - RTC, EEPROM, Clock Generator, HDMI Output - Bank 34
# # ---------------------------------------------------------------------------- 
# set_property PACKAGE_PIN R19 [get_ports {HDMIO_SCL       }];  # "R19.JX1_SE_0.JX1.9.HDMIO_SCL"
# set_property PACKAGE_PIN T19 [get_ports {HDMIO_SDA       }];  # "T19.JX1_SE_1.JX1.10.HDMIO_SDA"


# HDMI Output (ADV7511) on PicoZed FMC Carrier V2
set_property PACKAGE_PIN V12 [get_ports IO_HDMIO_1_clk]
set_property PACKAGE_PIN L17 [get_ports {IO_HDMIO_1_data[0]}]
set_property PACKAGE_PIN L16 [get_ports {IO_HDMIO_1_data[1]}]
set_property PACKAGE_PIN G20 [get_ports {IO_HDMIO_1_data[2]}]
set_property PACKAGE_PIN G19 [get_ports {IO_HDMIO_1_data[3]}]
set_property PACKAGE_PIN M15 [get_ports {IO_HDMIO_1_data[4]}]
set_property PACKAGE_PIN M14 [get_ports {IO_HDMIO_1_data[5]}]
set_property PACKAGE_PIN J16 [get_ports {IO_HDMIO_1_data[6]}]
set_property PACKAGE_PIN K16 [get_ports {IO_HDMIO_1_data[7]}]
set_property PACKAGE_PIN G14 [get_ports {IO_HDMIO_1_data[8]}]
set_property PACKAGE_PIN J15 [get_ports {IO_HDMIO_1_data[9]}]
set_property PACKAGE_PIN B20 [get_ports {IO_HDMIO_1_data[10]}]
set_property PACKAGE_PIN C20 [get_ports {IO_HDMIO_1_data[11]}]
set_property PACKAGE_PIN T10 [get_ports {IO_HDMIO_1_data[12]}]
set_property PACKAGE_PIN T11 [get_ports {IO_HDMIO_1_data[13]}]
set_property PACKAGE_PIN U12 [get_ports {IO_HDMIO_1_data[14]}]
set_property PACKAGE_PIN T12 [get_ports {IO_HDMIO_1_data[15]}]
set_property PACKAGE_PIN W13 [get_ports IO_HDMIO_1_spdif]
set_property PACKAGE_PIN T15 [get_ports {pzfmc2_hdmio_pd[0]}]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_1_clk]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_1_data*]
set_property IOB TRUE [get_ports IO_HDMIO_1_data*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_1_spdif]
set_property IOSTANDARD LVCMOS25 [get_ports {pzfmc2_hdmio_pd[0]}]

# # ----------------------------------------------------------------------------
# # ADV7511 HDMI Output - Bank 34 (JX1) and Bank 35 (JX2)
# # ---------------------------------------------------------------------------- 
# # Bank 34
# set_property PACKAGE_PIN T10 [get_ports {HDMIO_CBCR4_D32 }];  # "T10.JX1_LVDS_0_N.JX1.13.HDMIO_CBCR4_D32"
# set_property PACKAGE_PIN T11 [get_ports {HDMIO_CBCR5_D33 }];  # "T11.JX1_LVDS_0_P.JX1.11.HDMIO_CBCR5_D33"
# set_property PACKAGE_PIN U12 [get_ports {HDMIO_CBCR6_D34 }];  # "U12.JX1_LVDS_1_N.JX1.14.HDMIO_CBCR6_D34"
# set_property PACKAGE_PIN T12 [get_ports {HDMIO_CBCR7_D35 }];  # "T12.JX1_LVDS_1_P.JX1.12.HDMIO_CBCR7_D35"
# set_property PACKAGE_PIN V12 [get_ports {HDMIO_CLK       }];  # "V12.JX1_LVDS_3_P.JX1.18.HDMIO_CLK"
# set_property PACKAGE_PIN T14 [get_ports {HDMIO_HPD       }];  # "T14.JX1_LVDS_4_P.JX1.23.HDMIO_HPD"
# set_property PACKAGE_PIN T15 [get_ports {HDMIO_PD        }];  # "T15.JX1_LVDS_4_N.JX1.25.HDMIO_PD"
# set_property PACKAGE_PIN W13 [get_ports {HDMIO_SPDIF     }];  # "W13.JX1_LVDS_3_N.JX1.20.HDMIO_SPDIF"
# # Bank 35
# set_property PACKAGE_PIN G14 [get_ports {HDMIO_CBCR0_D28 }];  # "G14.JX2_SE_0.JX2.13.HDMIO_CBCR0_D28"
# set_property PACKAGE_PIN J15 [get_ports {HDMIO_CBCR1_D29 }];  # "J15.JX2_SE_1.JX2.14.HDMIO_CBCR1_D29"
# set_property PACKAGE_PIN B20 [get_ports {HDMIO_CBCR2_D30 }];  # "B20.JX2_LVDS_0_N.JX2.19.HDMIO_CBCR2_D30"
# set_property PACKAGE_PIN C20 [get_ports {HDMIO_CBCR3_D31 }];  # "C20.JX2_LVDS_0_P.JX2.17.HDMIO_CBCR3_D31"
# set_property PACKAGE_PIN E17 [get_ports {HDMIO_INT       }];  # "E17.JX2_LVDS_2_P.JX2.23.HDMIO_INT"
# set_property PACKAGE_PIN L17 [get_ports {HDMIO_Y0_D20    }];  # "L17.JX2_LVDS_10_N.JX2.49.HDMIO_Y0_D20"
# set_property PACKAGE_PIN L16 [get_ports {HDMIO_Y1_D21    }];  # "L16.JX2_LVDS_10_P.JX2.47.HDMIO_Y1_D21"
# set_property PACKAGE_PIN G20 [get_ports {HDMIO_Y2_D22    }];  # "G20.JX2_LVDS_16_N.JX2.69.HDMIO_Y2_D22"
# set_property PACKAGE_PIN G19 [get_ports {HDMIO_Y3_D23    }];  # "G19.JX2_LVDS_16_P.JX2.67.HDMIO_Y3_D23"
# set_property PACKAGE_PIN M15 [get_ports {HDMIO_Y4_D24    }];  # "M15.JX2_LVDS_22_N.JX2.89.HDMIO_Y4_D24"
# set_property PACKAGE_PIN M14 [get_ports {HDMIO_Y5_D25    }];  # "M14.JX2_LVDS_22_P.JX2.87.HDMIO_Y5_D25"
# set_property PACKAGE_PIN J16 [get_ports {HDMIO_Y6_D26    }];  # "J16.JX2_LVDS_23_N.JX2.90.HDMIO_Y6_D26"
# set_property PACKAGE_PIN K16 [get_ports {HDMIO_Y7_D27    }];  # "K16.JX2_LVDS_23_P.JX2.88.HDMIO_Y7_D27"


# I2C Chain on FMC-HDMI-CAM
set_property PACKAGE_PIN N17  [get_ports fmc_hdmi_cam_iic_scl_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_hdmi_cam_iic_scl_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_scl_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_scl_io]

set_property PACKAGE_PIN P18  [get_ports fmc_hdmi_cam_iic_sda_io]
set_property IOSTANDARD LVCMOS25 [get_ports fmc_hdmi_cam_iic_sda_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_sda_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_sda_io]

set_property PACKAGE_PIN P20  [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property SLEW SLOW [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property DRIVE 8 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]

# HDMI Input (ADV7611) on FMC-HDMI-CAM
set_property PACKAGE_PIN K17  [get_ports IO_HDMII_clk]
set_property PACKAGE_PIN F20  [get_ports {IO_HDMII_data[0]}]
set_property PACKAGE_PIN F19  [get_ports {IO_HDMII_data[1]}] 
set_property PACKAGE_PIN H20  [get_ports {IO_HDMII_data[2]}]
set_property PACKAGE_PIN G18  [get_ports {IO_HDMII_data[3]}]
set_property PACKAGE_PIN J19  [get_ports {IO_HDMII_data[4]}]
set_property PACKAGE_PIN J20  [get_ports {IO_HDMII_data[5]}]
set_property PACKAGE_PIN G17  [get_ports {IO_HDMII_data[6]}]
set_property PACKAGE_PIN K19  [get_ports {IO_HDMII_data[7]}]
set_property PACKAGE_PIN N16  [get_ports {IO_HDMII_data[8]}]
set_property PACKAGE_PIN N15  [get_ports {IO_HDMII_data[9]}]
set_property PACKAGE_PIN L15  [get_ports {IO_HDMII_data[10]}]
set_property PACKAGE_PIN L14  [get_ports {IO_HDMII_data[11]}]
set_property PACKAGE_PIN J14  [get_ports {IO_HDMII_data[12]}]
set_property PACKAGE_PIN K14  [get_ports {IO_HDMII_data[13]}]
set_property PACKAGE_PIN G15  [get_ports {IO_HDMII_data[14]}]
set_property PACKAGE_PIN H15  [get_ports {IO_HDMII_data[15]}]
set_property PACKAGE_PIN M20  [get_ports {IO_HDMII_spdif}]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMII_clk]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_data*}]
set_property IOSTANDARD LVCMOS25 [get_ports {IO_HDMII_spdif}]

# HDMI Output (ADV7511) on FMC-HDMI-CAM
set_property PACKAGE_PIN K18  [get_ports IO_HDMIO_clk]
set_property PACKAGE_PIN M18  [get_ports {IO_HDMIO_data[0]}]
set_property PACKAGE_PIN M17  [get_ports {IO_HDMIO_data[1]}]
set_property PACKAGE_PIN E19  [get_ports {IO_HDMIO_data[2]}]
set_property PACKAGE_PIN L20  [get_ports {IO_HDMIO_data[3]}]
set_property PACKAGE_PIN E18  [get_ports {IO_HDMIO_data[4]}]
set_property PACKAGE_PIN F17  [get_ports {IO_HDMIO_data[5]}]
set_property PACKAGE_PIN H18  [get_ports {IO_HDMIO_data[6]}]
set_property PACKAGE_PIN L19  [get_ports {IO_HDMIO_data[7]}]
set_property PACKAGE_PIN F16  [get_ports {IO_HDMIO_data[8]}]
set_property PACKAGE_PIN A20  [get_ports {IO_HDMIO_data[9]}]
set_property PACKAGE_PIN J18  [get_ports {IO_HDMIO_data[10]}]
set_property PACKAGE_PIN H17  [get_ports {IO_HDMIO_data[11]}]
set_property PACKAGE_PIN B19  [get_ports {IO_HDMIO_data[12]}]
set_property PACKAGE_PIN D20  [get_ports {IO_HDMIO_data[13]}]
set_property PACKAGE_PIN H16  [get_ports {IO_HDMIO_data[14]}]
set_property PACKAGE_PIN D19  [get_ports {IO_HDMIO_data[15]}]
set_property PACKAGE_PIN M19  [get_ports IO_HDMIO_spdif]

set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_data*]
set_property IOB TRUE [get_ports IO_HDMIO_data*]
set_property IOSTANDARD LVCMOS25 [get_ports IO_HDMIO_spdif]


# Camera interface (PYTHON-1300) on FMC-HDMI-CAM
set_property PACKAGE_PIN T17  [get_ports IO_PYTHON_CAM_clk_pll]
set_property PACKAGE_PIN U19  [get_ports IO_PYTHON_CAM_reset_n]
set_property PACKAGE_PIN R18  [get_ports {IO_PYTHON_CAM_trigger[2]}]
set_property PACKAGE_PIN V17  [get_ports {IO_PYTHON_CAM_trigger[1]}]
set_property PACKAGE_PIN V18  [get_ports {IO_PYTHON_CAM_trigger[0]}]
set_property PACKAGE_PIN W18  [get_ports {IO_PYTHON_CAM_monitor[0]}]
set_property PACKAGE_PIN W19  [get_ports {IO_PYTHON_CAM_monitor[1]}]
set_property PACKAGE_PIN R16  [get_ports IO_PYTHON_SPI_spi_sclk]
set_property PACKAGE_PIN R17  [get_ports IO_PYTHON_SPI_spi_ssel_n]
set_property PACKAGE_PIN V16  [get_ports IO_PYTHON_SPI_spi_mosi]
set_property PACKAGE_PIN W16  [get_ports IO_PYTHON_SPI_spi_miso]
set_property PACKAGE_PIN N18  [get_ports IO_PYTHON_CAM_clk_out_p]; #CAM_CLK_P
set_property PACKAGE_PIN P19  [get_ports IO_PYTHON_CAM_clk_out_n]; #CAM_CLK_N
set_property PACKAGE_PIN Y18  [get_ports IO_PYTHON_CAM_sync_p]; #CAM_SYNC_P
set_property PACKAGE_PIN Y19  [get_ports IO_PYTHON_CAM_sync_n]; #CAM_SYNC_N
#set_property PACKAGE_PIN V20  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA7_P
#set_property PACKAGE_PIN W20  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA7_N
#set_property PACKAGE_PIN T20  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA6_P
#set_property PACKAGE_PIN U20  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA6_N
set_property PACKAGE_PIN U14  [get_ports {IO_PYTHON_CAM_data_p[3]}]; #CAM_DATA5_P
set_property PACKAGE_PIN U15  [get_ports {IO_PYTHON_CAM_data_n[3]}]; #CAM_DATA5_N
set_property PACKAGE_PIN T16  [get_ports {IO_PYTHON_CAM_data_p[2]}]; #CAM_DATA4_P
set_property PACKAGE_PIN U17  [get_ports {IO_PYTHON_CAM_data_n[2]}]; #CAM_DATA4_N
set_property PACKAGE_PIN W14  [get_ports {IO_PYTHON_CAM_data_p[1]}]; #CAM_DATA3_P
set_property PACKAGE_PIN Y14  [get_ports {IO_PYTHON_CAM_data_n[1]}]; #CAM_DATA3_N
set_property PACKAGE_PIN V15  [get_ports {IO_PYTHON_CAM_data_p[0]}]; #CAM_DATA2_P
set_property PACKAGE_PIN W15  [get_ports {IO_PYTHON_CAM_data_n[0]}]; #CAM_DATA2_N
#set_property PACKAGE_PIN Y16  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA1_P
#set_property PACKAGE_PIN Y17  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA1_N
#set_property PACKAGE_PIN P14  [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA0_P
#set_property PACKAGE_PIN R14  [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA0_N

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
set_property PACKAGE_PIN U18  [get_ports fmc_hdmi_cam_vclk]
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
                               -group [get_clocks clk_out1_pzfmc2_hdmi_clk_wiz_0_0_1] \
                               -group [get_clocks clk_out2_pzfmc2_hdmi_clk_wiz_1_0_1] \
                               -group [get_clocks hdmii_clk] \
                               -group [get_clocks {*serdesclockgen[0].ic*}] \
                               -group [get_clocks vita_clk_1]

