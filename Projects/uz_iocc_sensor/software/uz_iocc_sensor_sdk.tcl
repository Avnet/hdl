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
#  Please direct any questions or issues to the UltraZed Community Forums:
#      http://www.ultrazed.org
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
#  Create Date:         Jan 06, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     UltraZed SOM
# 
#  Tool versions:       Vivado 2016.2
# 
#  Description:         SDK Build Script for UltraZed SOM + I/O CC hardware 
#                       platform
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Jan 06, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set project  "uz_iocc_sensor"
set hw_name  "uz_iocc_sensor_hw"
set bsp_name "uz_iocc_sensor_bsp"
set max31855_app_name "max31855_thermocouple"
set max44000_app_name "max44000_lux"
set sensor_demo_app_name "sensor_demo"


# Set workspace and import hardware platform
sdk setws ${project}.sdk
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
sdk createhw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
sdk createbsp -name ${bsp_name} -proc psu_cortexa53_0 -hwproject ${hw_name} -os standalone
sdk projects -build -type bsp -name ${bsp_name}

# Create max31855 temperature sensor application
puts "\n#\n#\n# Creating ${max31855_app_name} ...\n#\n#\n"
sdk create_app_project -name ${max31855_app_name} -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Create max44000 light sensor application
puts "\n#\n#\n# Creating ${max44000_app_name} ...\n#\n#\n"
sdk create_app_project -name ${max44000_app_name} -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang c -app {Empty Application} -bsp ${bsp_name} 

# Create sensor demo application
puts "\n#\n#\n# Creating ${sensor_demo_app_name} ...\n#\n#\n"
sdk create_app_project -name ${sensor_demo_app_name} -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
sdk import_sources -name ${max31855_app_name} -path ../software/${max31855_app_name}/src
sdk import_sources -name ${max44000_app_name} -path ../software/${max44000_app_name}/src
sdk import_sources -name ${sensor_demo_app_name} -path ../software/${sensor_demo_app_name}/src

# Build max31855 temperature sensor application
puts "\n#\n#\n# Build ${max31855_app_name} ...\n#\n#\n"
sdk build_project -type app -name ${max31855_app_name}

# Build max44000 light sensor application
puts "\n#\n#\n# Build ${max44000_app_name} ...\n#\n#\n"
sdk build_project -type app -name ${max44000_app_name}

# Build sensor demo pplication
puts "\n#\n#\n# Build ${sensor_demo_app_name} ...\n#\n#\n"
sdk build_project -type app -name ${sensor_demo_app_name}

# Create Zynq MP FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
sdk createapp -name zynq_fsbl_app -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Zynq MP FSBL} -bsp zynq_fsbl_bsp

# Set the build type to release
configapp -app zynq_fsbl_app build-config release

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
sdk projects -build -type bsp -name zynq_fsbl_bsp
sdk projects -build -type app -name zynq_fsbl_app

# done
exit
