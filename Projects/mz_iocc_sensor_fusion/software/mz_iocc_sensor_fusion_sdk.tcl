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
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Mar 27, 2016
#  Design Name:         MicroZed Sensor Fusion SDK Application
#  Module Name:         mz_iocc_sensor_fusion_sdk.tcl
#  Project Name:        MicroZed Sensor Fusion 
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MicroZed SOM
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         Build Script for MicroZed Sensor Fusion SDK App
# 
#  Dependencies:        None
#
#  Revision:            Mar 27, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set project  "mz_iocc_sensor_fusion"
set hw_name  "sensor_fusion_hw"
set bsp_name "sensor_fusion_bsp"
set test_app_name "SPI_TempSensor_MAX31723"

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

# Create SPI TempSensor Test application
puts "\n#\n#\n# Creating ${test_app_name} ...\n#\n#\n"
sdk create_app_project -name ${test_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
sdk import_sources -name ${test_app_name} -path ../software/${test_app_name}/src

# Build SPI TempSensor Test application
puts "\n#\n#\n# Build ${test_app_name} ...\n#\n#\n"
sdk build_project -type app -name ${test_app_name}

# Create FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
sdk create_app_project -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
sdk build_project -type bsp -name zynq_fsbl_bsp
sdk build_project -type app -name zynq_fsbl_app

# done
exit
