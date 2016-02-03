# ----------------------------------------------------------------------------
#       _____
#      *     *
#     *____   *____
#    * *===*   *==*
#   *___*===*___**  AVNET
#        *======*
#         *====*
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions to the PicoZed community support forum:
#     http://www.picozed.org/forum
# 
#  Product information is available at:
#     http://www.picozed.org/product/picozed
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2015 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Dec 28, 2015
#  Design Name:         PicoZed + FMC2 Carrier
#  Module Name:         pz_fmc2_valtest_sdk.tcl
#  Project Name:        PicoZed FMC2 Carrier HW Validation Test
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed + FMC Carrier 2
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         Build Script for PicoZed FMC2 HW Validation Test design
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Dec 28, 2015: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set project  "pz_fmc2_valtest"
set hw_name  "pz_fmc2_hw"
set bsp_name "pz_fmc2_bsp"
set pzcc_fmc_eeprom_test_name "pzcc_fmc_eeprom_test"
set pzcc_fmc_test_name "pzcc_fmc_test"
set pzcc_hdmi_test_name "pzcc_hdmi_test"
set pzcc_idt8t49N242_test_name "pzcc_idt8t49N242_test"
set pzcc_iic_eeprom_test_name "pzcc_iic_eeprom_test"
set pzcc_iic_rtc_test_name "pzcc_iic_rtc_test"
set pzcc_mac_eeprom_test_name "pzcc_mac_eeprom_test"
set pzcc_unio_eeprom_test_name "pzcc_unio_eeprom_test"

# Set workspace and import hardware platform
sdk set_workspace ${project}.sdk
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
sdk create_hw_project -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
sdk create_bsp_project -name ${bsp_name} -proc ps7_cortexa9_0 -hwproject ${hw_name} -os standalone
sdk build_project -type bsp -name ${bsp_name}

# Create FMC EEPROM Test application
puts "\n#\n#\n# Creating ${pzcc_fmc_eeprom_test_name} ...\n#\n#\n"
sdk create_app_project -name ${pzcc_fmc_eeprom_test_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Create FMC Test application
puts "\n#\n#\n# Creating ${pzcc_fmc_test_name} ...\n#\n#\n"
sdk create_app_project -name ${pzcc_fmc_test_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang c -app {Empty Application} -bsp ${bsp_name} 

# Create HDMI Test application
puts "\n#\n#\n# Creating ${pzcc_hdmi_test_name} ...\n#\n#\n"
sdk create_app_project -name ${pzcc_hdmi_test_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Create Clock Synthesizer Test application
puts "\n#\n#\n# Creating ${pzcc_idt8t49N242_test_name} ...\n#\n#\n"
sdk create_app_project -name ${pzcc_idt8t49N242_test_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Create I2C EEPROM Test application
puts "\n#\n#\n# Creating ${pzcc_iic_eeprom_test_name} ...\n#\n#\n"
sdk create_app_project -name ${pzcc_iic_eeprom_test_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang c -app {Empty Application} -bsp ${bsp_name} 

# Create I2C RTC Test application
puts "\n#\n#\n# Creating ${pzcc_iic_rtc_test_name} ...\n#\n#\n"
sdk create_app_project -name ${pzcc_iic_rtc_test_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Create I2C MAC ID Test application
puts "\n#\n#\n# Creating ${pzcc_mac_eeprom_test_name} ...\n#\n#\n"
sdk create_app_project -name ${pzcc_mac_eeprom_test_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Create UNIO MAC ID Test application
puts "\n#\n#\n# Creating ${pzcc_unio_eeprom_test_name} ...\n#\n#\n"
sdk create_app_project -name ${pzcc_unio_eeprom_test_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
sdk import_sources -name ${pzcc_fmc_eeprom_test_name} -path ../software/${pzcc_fmc_eeprom_test_name}/src
sdk import_sources -name ${pzcc_fmc_test_name} -path ../software/${pzcc_fmc_test_name}/src
sdk import_sources -name ${pzcc_hdmi_test_name} -path ../software/${pzcc_hdmi_test_name}/src
sdk import_sources -name ${pzcc_idt8t49N242_test_name} -path ../software/${pzcc_idt8t49N242_test_name}/src
sdk import_sources -name ${pzcc_iic_eeprom_test_name} -path ../software/${pzcc_iic_eeprom_test_name}/src
sdk import_sources -name ${pzcc_iic_rtc_test_name} -path ../software/${pzcc_iic_rtc_test_name}/src
sdk import_sources -name ${pzcc_mac_eeprom_test_name} -path ../software/${pzcc_mac_eeprom_test_name}/src
sdk import_sources -name ${pzcc_unio_eeprom_test_name} -path ../software/${pzcc_unio_eeprom_test_name}/src

# Build FMC EEPROM Test application
puts "\n#\n#\n# Build ${pzcc_fmc_eeprom_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${pzcc_fmc_eeprom_test_name}

# Build FMC Test application
puts "\n#\n#\n# Build ${pzcc_fmc_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${pzcc_fmc_test_name}

# Build HDMI Test application
puts "\n#\n#\n# Build ${pzcc_hdmi_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${pzcc_hdmi_test_name}

# Build Clock Synthesizer Testapplication
puts "\n#\n#\n# Build ${pzcc_fmc_eeprom_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${pzcc_idt8t49N242_test_name}

# Build I2C EEPROM Test application
puts "\n#\n#\n# Build ${pzcc_iic_eeprom_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${pzcc_iic_eeprom_test_name}

# Build I2C RTC Test application
puts "\n#\n#\n# Build ${pzcc_iic_rtc_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${pzcc_iic_rtc_test_name}

# Build I2C MAC ID Test application
puts "\n#\n#\n# Build ${pzcc_mac_eeprom_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${pzcc_mac_eeprom_test_name}

# Build UNIO MAC ID Test application
puts "\n#\n#\n# Build ${pzcc_unio_eeprom_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${pzcc_unio_eeprom_test_name}

# Create FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
sdk create_app_project -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
sdk build_project -type bsp -name zynq_fsbl_bsp
sdk build_project -type app -name zynq_fsbl_app

# done
exit