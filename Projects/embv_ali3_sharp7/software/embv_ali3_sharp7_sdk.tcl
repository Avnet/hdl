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
#  Please direct any questions or issues to the MicroZed Community Forums:
#      http://www.microzed.org
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
#  Create Date:         Jun 03, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     MicroZed Display Kit
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         SDK Build Script for Zed Display Kit design
# 
#  Dependencies:        To be called from a configured make script call

#
#  Revision:            Jun 03, 2015: 1.00 Initial version
#                       Sep 17, 2015: 1.01 Updated for Vivado 2015.2
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set project  "embv_ali3_sharp7"
set hw_name  "zed_ali3_hw"
set bsp_name "zed_ali3_bsp"
set console_app_name "zed_ali3_console_app"
set clicktouch_controller_app_name "zed_ali3_clicktouch_controller_app"
set dh_controller_app_name "zed_ali3_dh_controller_app"

# Set workspace and import hardware platform
sdk set_workspace ${project}.sdk
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
sdk create_hw_project -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
sdk create_bsp_project -name ${bsp_name} -proc ps7_cortexa9_0 -hwproject zed_ali3_hw -os standalone
sdk build_project -type bsp -name ${bsp_name}

# Create ALI3 display console application
puts "\n#\n#\n# Creating ${console_app_name} ...\n#\n#\n"
sdk create_app_project -name ${console_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Create ALI3 Clicktouch display controller application
puts "\n#\n#\n# Creating ${clicktouch_controller_app_name} ...\n#\n#\n"
sdk create_app_project -name ${clicktouch_controller_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang c -app {Empty Application} -bsp ${bsp_name} 

# Create ALI3 DH display controller application
puts "\n#\n#\n# Creating ${dh_controller_app_name} ...\n#\n#\n"
sdk create_app_project -name ${dh_controller_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
sdk import_sources -name ${console_app_name} -path ../software/${console_app_name}/src
sdk import_sources -name ${clicktouch_controller_app_name} -path ../software/${clicktouch_controller_app_name}/src
sdk import_sources -name ${dh_controller_app_name} -path ../software/${dh_controller_app_name}/src

# Build ALI3 display console application
puts "\n#\n#\n# Build ${console_app_name} ...\n#\n#\n"
sdk build_project -type app -name ${console_app_name}

# Build Clicktouch ALI3 display controller application
puts "\n#\n#\n# Build ${clicktouch_controller_app_name} ...\n#\n#\n"
sdk build_project -type app -name ${clicktouch_controller_app_name}

# Build DH ALI3 display controller application
puts "\n#\n#\n# Build ${dh_controller_app_name} ...\n#\n#\n"
sdk build_project -type app -name ${dh_controller_app_name}

# Create FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
sdk create_app_project -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
sdk build_project -type bsp -name zynq_fsbl_bsp
sdk build_project -type app -name zynq_fsbl_app

# done
exit