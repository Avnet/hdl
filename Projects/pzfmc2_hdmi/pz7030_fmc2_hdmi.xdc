########################
# Physical Constraints #
########################

# I2C Chain on PicoZed FMC Carrier V2
set_property PACKAGE_PIN H6 [get_ports pzfmc2_iic_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports pzfmc2_iic_scl_io]
set_property SLEW SLOW [get_ports pzfmc2_iic_scl_io]
set_property DRIVE 8 [get_ports pzfmc2_iic_scl_io]

set_property PACKAGE_PIN H5 [get_ports pzfmc2_iic_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports pzfmc2_iic_sda_io]
set_property SLEW SLOW [get_ports pzfmc2_iic_sda_io]
set_property DRIVE 8 [get_ports pzfmc2_iic_sda_io]

# # ----------------------------------------------------------------------------
# # I2C Peripherals - RTC, EEPROM, Clock Generator, HDMI Output - Bank 35
# # ----------------------------------------------------------------------------
# set_property PACKAGE_PIN H6   [get_ports {HDMIO_SCL       }];  # "H6.JX1_SE_0.JX1.9.HDMIO_SCL"
# set_property PACKAGE_PIN H5   [get_ports {HDMIO_SDA       }];  # "H5.JX1_SE_1.JX1.10.HDMIO_SDA"

# HDMI Output (ADV7511) on PicoZed FMC Carrier V2
set_property PACKAGE_PIN F2 [get_ports IO_HDMIO_1_clk]
set_property PACKAGE_PIN K3 [get_ports {IO_HDMIO_1_data[0]}]
set_property PACKAGE_PIN K4 [get_ports {IO_HDMIO_1_data[1]}]
set_property PACKAGE_PIN K5 [get_ports {IO_HDMIO_1_data[2]}]
set_property PACKAGE_PIN J5 [get_ports {IO_HDMIO_1_data[3]}]
set_property PACKAGE_PIN M7 [get_ports {IO_HDMIO_1_data[4]}]
set_property PACKAGE_PIN M8 [get_ports {IO_HDMIO_1_data[5]}]
set_property PACKAGE_PIN P8 [get_ports {IO_HDMIO_1_data[6]}]
set_property PACKAGE_PIN N8 [get_ports {IO_HDMIO_1_data[7]}]
set_property PACKAGE_PIN H8 [get_ports {IO_HDMIO_1_data[8]}]
set_property PACKAGE_PIN R8 [get_ports {IO_HDMIO_1_data[9]}]
set_property PACKAGE_PIN M3 [get_ports {IO_HDMIO_1_data[10]}]
set_property PACKAGE_PIN M4 [get_ports {IO_HDMIO_1_data[11]}]
set_property PACKAGE_PIN H3 [get_ports {IO_HDMIO_1_data[12]}]
set_property PACKAGE_PIN H4 [get_ports {IO_HDMIO_1_data[13]}]
set_property PACKAGE_PIN E5 [get_ports {IO_HDMIO_1_data[14]}]
set_property PACKAGE_PIN F5 [get_ports {IO_HDMIO_1_data[15]}]
set_property PACKAGE_PIN F1 [get_ports IO_HDMIO_1_spdif]
set_property PACKAGE_PIN F4 [get_ports {pzfmc2_hdmio_pd[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_1_clk]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_1_data*]
set_property IOB TRUE [get_ports IO_HDMIO_1_data*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_1_spdif]
set_property IOSTANDARD LVCMOS18 [get_ports {pzfmc2_hdmio_pd[0]}]

# # ----------------------------------------------------------------------------
# # ADV7511 HDMI Output - Bank 35 (JX1) and Bank 34 (JX2)
# # ----------------------------------------------------------------------------
# # Bank 35
# set_property PACKAGE_PIN H3   [get_ports {HDMIO_CBCR4_D32 }];  # "H3.JX1_LVDS_0_N.JX1.13.HDMIO_CBCR4_D32"
# set_property PACKAGE_PIN H4   [get_ports {HDMIO_CBCR5_D33 }];  # "H4.JX1_LVDS_0_P.JX1.11.HDMIO_CBCR5_D33"
# set_property PACKAGE_PIN E5   [get_ports {HDMIO_CBCR6_D34 }];  # "E5.JX1_LVDS_1_N.JX1.14.HDMIO_CBCR6_D34"
# set_property PACKAGE_PIN F5   [get_ports {HDMIO_CBCR7_D35 }];  # "F5.JX1_LVDS_1_P.JX1.12.HDMIO_CBCR7_D35"
# set_property PACKAGE_PIN F2   [get_ports {HDMIO_CLK       }];  # "F2.JX1_LVDS_3_P.JX1.18.HDMIO_CLK"
# set_property PACKAGE_PIN G4   [get_ports {HDMIO_HPD       }];  # "G4.JX1_LVDS_4_P.JX1.23.HDMIO_HPD"
# set_property PACKAGE_PIN F4   [get_ports {HDMIO_PD        }];  # "F4.JX1_LVDS_4_N.JX1.25.HDMIO_PD"
# set_property PACKAGE_PIN F1   [get_ports {HDMIO_SPDIF     }];  # "F1.JX1_LVDS_3_N.JX1.20.HDMIO_SPDIF"
# # Bank 34
# set_property PACKAGE_PIN H8   [get_ports {HDMIO_CBCR0_D28 }];  # "H8.JX2_SE_0.JX2.13.HDMIO_CBCR0_D28"
# set_property PACKAGE_PIN R8   [get_ports {HDMIO_CBCR1_D29 }];  # "R8.JX2_SE_1.JX2.14.HDMIO_CBCR1_D29"
# set_property PACKAGE_PIN M3   [get_ports {HDMIO_CBCR2_D30 }];  # "M3.JX2_LVDS_0_N.JX2.19.HDMIO_CBCR2_D30"
# set_property PACKAGE_PIN M4   [get_ports {HDMIO_CBCR3_D31 }];  # "M4.JX2_LVDS_0_P.JX2.17.HDMIO_CBCR3_D31"
# set_property PACKAGE_PIN K7   [get_ports {HDMIO_INT       }];  # "K7.JX2_LVDS_2_P.JX2.23.HDMIO_INT"
# set_property PACKAGE_PIN K3   [get_ports {HDMIO_Y0_D20    }];  # "K3.JX2_LVDS_10_N.JX2.49.HDMIO_Y0_D20"
# set_property PACKAGE_PIN K4   [get_ports {HDMIO_Y1_D21    }];  # "K4.JX2_LVDS_10_P.JX2.47.HDMIO_Y1_D21"
# set_property PACKAGE_PIN K5   [get_ports {HDMIO_Y2_D22    }];  # "K5.JX2_LVDS_16_N.JX2.69.HDMIO_Y2_D22"
# set_property PACKAGE_PIN J5   [get_ports {HDMIO_Y3_D23    }];  # "J5.JX2_LVDS_16_P.JX2.67.HDMIO_Y3_D23"
# set_property PACKAGE_PIN M7   [get_ports {HDMIO_Y4_D24    }];  # "M7.JX2_LVDS_22_N.JX2.89.HDMIO_Y4_D24"
# set_property PACKAGE_PIN M8   [get_ports {HDMIO_Y5_D25    }];  # "M8.JX2_LVDS_22_P.JX2.87.HDMIO_Y5_D25"
# set_property PACKAGE_PIN P8   [get_ports {HDMIO_Y6_D26    }];  # "P8.JX2_LVDS_23_N.JX2.90.HDMIO_Y6_D26"
# set_property PACKAGE_PIN N8   [get_ports {HDMIO_Y7_D27    }];  # "N8.JX2_LVDS_23_P.JX2.88.HDMIO_Y7_D27"

# I2C Chain on FMC-HDMI-CAM
set_property PACKAGE_PIN B7 [get_ports fmc_hdmi_cam_iic_scl_io]
set_property IOSTANDARD LVCMOS18 [get_ports fmc_hdmi_cam_iic_scl_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_scl_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_scl_io]

set_property PACKAGE_PIN B6 [get_ports fmc_hdmi_cam_iic_sda_io]
set_property IOSTANDARD LVCMOS18 [get_ports fmc_hdmi_cam_iic_sda_io]
set_property SLEW SLOW [get_ports fmc_hdmi_cam_iic_sda_io]
set_property DRIVE 8 [get_ports fmc_hdmi_cam_iic_sda_io]

set_property PACKAGE_PIN C3 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property SLEW SLOW [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]
set_property DRIVE 8 [get_ports {fmc_hdmi_cam_iic_rst_n[0]}]

# HDMI Input (ADV7611) on FMC-HDMI-CAM
set_property PACKAGE_PIN L5 [get_ports IO_HDMII_clk]
set_property PACKAGE_PIN M6 [get_ports {IO_HDMII_data[0]}]
set_property PACKAGE_PIN L6 [get_ports {IO_HDMII_data[1]}]
set_property PACKAGE_PIN R4 [get_ports {IO_HDMII_data[2]}]
set_property PACKAGE_PIN R2 [get_ports {IO_HDMII_data[3]}]
set_property PACKAGE_PIN P1 [get_ports {IO_HDMII_data[4]}]
set_property PACKAGE_PIN R5 [get_ports {IO_HDMII_data[5]}]
set_property PACKAGE_PIN R3 [get_ports {IO_HDMII_data[6]}]
set_property PACKAGE_PIN N1 [get_ports {IO_HDMII_data[7]}]
set_property PACKAGE_PIN K8 [get_ports {IO_HDMII_data[8]}]
set_property PACKAGE_PIN J8 [get_ports {IO_HDMII_data[9]}]
set_property PACKAGE_PIN N5 [get_ports {IO_HDMII_data[10]}]
set_property PACKAGE_PIN N6 [get_ports {IO_HDMII_data[11]}]
set_property PACKAGE_PIN J6 [get_ports {IO_HDMII_data[12]}]
set_property PACKAGE_PIN J7 [get_ports {IO_HDMII_data[13]}]
set_property PACKAGE_PIN P5 [get_ports {IO_HDMII_data[14]}]
set_property PACKAGE_PIN P6 [get_ports {IO_HDMII_data[15]}]
set_property PACKAGE_PIN P2 [get_ports IO_HDMII_spdif]

set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMII_clk]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMII_data*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMII_spdif]

# HDMI Output (ADV7511) on FMC-HDMI-CAM
set_property PACKAGE_PIN L4 [get_ports IO_HDMIO_clk]
set_property PACKAGE_PIN M1 [get_ports {IO_HDMIO_data[0]}]
set_property PACKAGE_PIN M2 [get_ports {IO_HDMIO_data[1]}]
set_property PACKAGE_PIN R7 [get_ports {IO_HDMIO_data[2]}]
set_property PACKAGE_PIN N3 [get_ports {IO_HDMIO_data[3]}]
set_property PACKAGE_PIN P7 [get_ports {IO_HDMIO_data[4]}]
set_property PACKAGE_PIN L1 [get_ports {IO_HDMIO_data[5]}]
set_property PACKAGE_PIN U1 [get_ports {IO_HDMIO_data[6]}]
set_property PACKAGE_PIN N4 [get_ports {IO_HDMIO_data[7]}]
set_property PACKAGE_PIN L2 [get_ports {IO_HDMIO_data[8]}]
set_property PACKAGE_PIN J1 [get_ports {IO_HDMIO_data[9]}]
set_property PACKAGE_PIN U2 [get_ports {IO_HDMIO_data[10]}]
set_property PACKAGE_PIN T1 [get_ports {IO_HDMIO_data[11]}]
set_property PACKAGE_PIN J2 [get_ports {IO_HDMIO_data[12]}]
set_property PACKAGE_PIN K2 [get_ports {IO_HDMIO_data[13]}]
set_property PACKAGE_PIN T2 [get_ports {IO_HDMIO_data[14]}]
set_property PACKAGE_PIN J3 [get_ports {IO_HDMIO_data[15]}]
set_property PACKAGE_PIN P3 [get_ports IO_HDMIO_spdif]

set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_clk]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_data*]
set_property IOB TRUE [get_ports IO_HDMIO_data*]
set_property IOSTANDARD LVCMOS18 [get_ports IO_HDMIO_spdif]

# Camera interface (PYTHON-1300) on FMC-HDMI-CAM
set_property PACKAGE_PIN A5 [get_ports IO_PYTHON_CAM_clk_pll]
set_property PACKAGE_PIN C4 [get_ports IO_PYTHON_CAM_reset_n]
set_property PACKAGE_PIN A4 [get_ports {IO_PYTHON_CAM_trigger[2]}]
set_property PACKAGE_PIN G8 [get_ports {IO_PYTHON_CAM_trigger[1]}]
set_property PACKAGE_PIN G7 [get_ports {IO_PYTHON_CAM_trigger[0]}]
set_property PACKAGE_PIN A7 [get_ports {IO_PYTHON_CAM_monitor[0]}]
set_property PACKAGE_PIN A6 [get_ports {IO_PYTHON_CAM_monitor[1]}]
set_property PACKAGE_PIN F7 [get_ports IO_PYTHON_SPI_spi_sclk]
set_property PACKAGE_PIN E7 [get_ports IO_PYTHON_SPI_spi_ssel_n]
set_property PACKAGE_PIN D7 [get_ports IO_PYTHON_SPI_spi_mosi]
set_property PACKAGE_PIN D6 [get_ports IO_PYTHON_SPI_spi_miso]
set_property PACKAGE_PIN B4 [get_ports IO_PYTHON_CAM_clk_out_p]
set_property PACKAGE_PIN B3 [get_ports IO_PYTHON_CAM_clk_out_n]
set_property PACKAGE_PIN E2 [get_ports IO_PYTHON_CAM_sync_p]
set_property PACKAGE_PIN D2 [get_ports IO_PYTHON_CAM_sync_n]
#set_property PACKAGE_PIN A2    [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA7_P
#set_property PACKAGE_PIN A1    [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA7_N
#set_property PACKAGE_PIN D1    [get_ports {IO_PYTHON_CAM_data_p[]}]; #CAM_DATA6_P
#set_property PACKAGE_PIN C1    [get_ports {IO_PYTHON_CAM_data_n[]}]; #CAM_DATA6_N
set_property PACKAGE_PIN C6 [get_ports {IO_PYTHON_CAM_data_p[3]}]
set_property PACKAGE_PIN C5 [get_ports {IO_PYTHON_CAM_data_n[3]}]
set_property PACKAGE_PIN E8 [get_ports {IO_PYTHON_CAM_data_p[2]}]
set_property PACKAGE_PIN D8 [get_ports {IO_PYTHON_CAM_data_n[2]}]
set_property PACKAGE_PIN B2 [get_ports {IO_PYTHON_CAM_data_p[1]}]
set_property PACKAGE_PIN B1 [get_ports {IO_PYTHON_CAM_data_n[1]}]
set_property PACKAGE_PIN H1 [get_ports {IO_PYTHON_CAM_data_p[0]}]
set_property PACKAGE_PIN G1 [get_ports {IO_PYTHON_CAM_data_n[0]}]
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
set_property PACKAGE_PIN D5 [get_ports fmc_hdmi_cam_vclk]
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
                               -group [get_clocks clk_out1_pzfmc2_hdmi_clk_wiz_0_0_1] \
                               -group [get_clocks clk_out2_pzfmc2_hdmi_clk_wiz_1_0_1] \
                               -group [get_clocks hdmii_clk] \
                               -group [get_clocks {*serdesclockgen[0].ic*}] \
                               -group [get_clocks vita_clk_1]


