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
#  Please direct any questions or issues to the PicoZed Community Forums:
#      http://www.picozed.org
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
#  Create Date:         Mar 26, 2016
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     MicroZed SOM
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         SDK Build Script for MicroZed PetaLinux hardware 
#                       platform
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Mar 26, 2016: 1.00 Initial version
#  Revision:            Jun 16, 2016: 1.01 Updated for Vivado 2015.4
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set project  "mz_petalinux"
set hw_name  "mz_petalinux_hw"
set bsp_name "mz_petalinux_bsp"

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

# Create FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
sdk create_app_project -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp

# Set the build type
sdk set_build_config -app zynq_fsbl_app -type release

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
sdk build_project -type bsp -name zynq_fsbl_bsp
sdk build_project -type app -name zynq_fsbl_app

# done
exit