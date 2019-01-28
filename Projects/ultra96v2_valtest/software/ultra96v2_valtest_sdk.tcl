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
#  Create Date:         Oct 30, 2018
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     Ultra96v2
# 
#  Tool versions:       Vivado 2018.2
# 
#  Description:         SDK Build Script for Ultra96v2 hardware platform
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Oct 30, 2018: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set project  "ultra96v2_valtest"
set hw_name  "ultra96v2_valtest_hw"
set bsp_name "ultra96v2_valtest_bsp"
set mem_test_short_app_name "mem_test_short_app"
set mem_test_long_app_name "mem_test_long_app"
set zynqmp_dram_diag_app_name "zynqmp_dram_diag_app"

# Set workspace and import hardware platform
setws ${project}.sdk
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
createhw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

# Generate BSP and change the STDIO UART to psu_uart_1
# https://www.xilinx.com/html_docs/xilinx2018_2/SDK_Doc/xsct/use_cases/xsct_modify_bsp_settings.html
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
createbsp -name ${bsp_name} -proc psu_cortexa53_0 -hwproject ${hw_name} -os standalone
configbsp -bsp ${bsp_name} stdin psu_uart_1
configbsp -bsp ${bsp_name} stdout psu_uart_1
updatemss -mss ${project}.sdk/${bsp_name}/system.mss
regenbsp -bsp ${bsp_name}
projects -build -type bsp -name ${bsp_name}

# Create Zynq MP FSBL application
puts "\n#\n#\n# Creating zynqmp_fsbl ...\n#\n#\n"
createapp -name zynqmp_fsbl_app -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Zynq MP FSBL} -bsp zynqmp_fsbl_bsp

# Set the build type to release
configapp -app zynqmp_fsbl_app build-config release

# Build FSBL application
puts "\n#\n#\n Building zynqmp_fsbl ...\n#\n#\n"
projects -build -type bsp -name zynqmp_fsbl_bsp
projects -build -type app -name zynqmp_fsbl_app

###
# Create short memory test application
puts "\n#\n#\n# Creating ${mem_test_short_app_name} ...\n#\n#\n"
createapp -name ${mem_test_short_app_name} -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
importsources -name ${mem_test_short_app_name} -path ../software/${mem_test_short_app_name}/src
file copy -force ../software/${mem_test_short_app_name}/src/lscript.ld ${project}.sdk/${mem_test_short_app_name}/src/.

# Build short memory test application
puts "\n#\n#\n# Build ${mem_test_short_app_name} ...\n#\n#\n"
projects -build -type app -name ${mem_test_short_app_name}


###
# Create long memory test application
puts "\n#\n#\n# Creating ${mem_test_long_app_name} ...\n#\n#\n"
createapp -name ${mem_test_long_app_name} -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
importsources -name ${mem_test_long_app_name} -path ../software/${mem_test_long_app_name}/src
file copy -force ../software/${mem_test_long_app_name}/src/lscript.ld ${project}.sdk/${mem_test_long_app_name}/src/.

# Build long memory test application
puts "\n#\n#\n# Build ${mem_test_long_app_name} ...\n#\n#\n"
projects -build -type app -name ${mem_test_long_app_name}


###
# Create Xilinx ZynqMP DRAM diag application
puts "\n#\n#\n# Creating ${zynqmp_dram_diag_app_name} ...\n#\n#\n"
createapp -name ${zynqmp_dram_diag_app_name} -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
importsources -name ${zynqmp_dram_diag_app_name} -path ../software/${zynqmp_dram_diag_app_name}/src
file copy -force ../software/${zynqmp_dram_diag_app_name}/src/lscript.ld ${project}.sdk/${zynqmp_dram_diag_app_name}/src/.

# Build Xilinx ZynqMP DRAM diag application
puts "\n#\n#\n# Build ${zynqmp_dram_diag_app_name} ...\n#\n#\n"
projects -build -type app -name ${zynqmp_dram_diag_app_name}

