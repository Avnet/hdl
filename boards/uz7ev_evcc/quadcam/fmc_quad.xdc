#####
## Constraints for FMC QUAD UZ7EVCC
## Version 1.0
#####


#####
## Pins
#####

#
# The VRP pin in Bank 64 (AC13) is used as an IO. To use MIPI_DPHY_DCI
# on this bank, DCI Cascade must be used. Since Bank 66 has a 240 ohm resistor
# connected to the VRP pin, use Bank 66 as a DCI cascade master bank for Bank 64
# (see AR# 67565).
#
#set_property DCI_CASCADE {64} [get_iobanks 66]


##########################
# CARRIER IIC
##########################

#UZ7EV CC IIC
# FMC_SCL - HD_SE_22_N - J12 
# FMC_SDA - HD_SE_22_P - K13
set_property PACKAGE_PIN J12 [get_ports carrier_iic_scl_io]
set_property PACKAGE_PIN K13 [get_ports carrier_iic_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports carrier_iic_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports carrier_iic_sda_io]



##########################
# HPC0 - Multi-Camera FMC
##########################

#IIC
set_property PACKAGE_PIN AG18 [get_ports fmc_multicam_iic_scl_io]
set_property PACKAGE_PIN AH18 [get_ports fmc_multicam_iic_sda_io]
set_property PULLUP true [get_ports fmc_multicam_iic_scl_io]
set_property PULLUP true [get_ports fmc_multicam_iic_sda_io]
set_property IOSTANDARD LVCMOS12 [get_ports fmc_multicam_iic_scl_io]
set_property IOSTANDARD LVCMOS12 [get_ports fmc_multicam_iic_sda_io]
set_property DRIVE 8 [get_ports fmc_multicam_iic_scl_io]
set_property DRIVE 8 [get_ports fmc_multicam_iic_sda_io]

set_property PACKAGE_PIN AE18 [get_ports {fmc_multicam_iic_mux_rst_n[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {fmc_multicam_iic_mux_rst_n[0]}]

#POC1 CONTROL

set_property PACKAGE_PIN AA16 [get_ports {fmc_multicam_poc1_en[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {fmc_multicam_poc1_en[0]}]

set_property PACKAGE_PIN AJ17 [get_ports fmc_multicam_poc1_int]
set_property IOSTANDARD LVCMOS12 [get_ports fmc_multicam_poc1_int]

#POC2 CONTROL

set_property PACKAGE_PIN AC16 [get_ports {fmc_multicam_poc2_en[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {fmc_multicam_poc2_en[0]}]

set_property PACKAGE_PIN AB16 [get_ports fmc_multicam_poc2_int]
set_property IOSTANDARD LVCMOS12 [get_ports fmc_multicam_poc2_int]

#GMSL CONTROL

set_property PACKAGE_PIN AH17 [get_ports {fmc_multicam_max9286_pwdn_n[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {fmc_multicam_max9286_pwdn_n[0]}]

set_property PACKAGE_PIN AF18 [get_ports {fmc_multicam_max9286_fsync}]
set_property IOSTANDARD LVCMOS12 [get_ports {fmc_multicam_max9286_fsync}]

#GMSL2 CONTROL

set_property PACKAGE_PIN AD16 [get_ports {fmc_multicam_max9296_pwdn_n[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {fmc_multicam_max9296_pwdn_n[0]}]



#MIPI input termination
set_property DIFF_TERM true [get_ports {csi_mipi_phy_if_clk_*}]
set_property DIFF_TERM true [get_ports {csi_mipi_phy_if_data_*}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {csi_mipi_phy_if_clk_*}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {csi_mipi_phy_if_data_*}]
