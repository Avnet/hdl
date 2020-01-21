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
#  Please direct any questions or issues to the MiniZed Community Forums:
#      http://www.minized.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2017 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Feb 06, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Vivado 2016.4
# 
#  Description:         SDK Build Script for MiniZed PetaLinux hardware 
#                       platform
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Feb 06, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set board  "MINIZED"
set project  "minized_petalinux"
set hw_name  "${board}_hw"
set bsp_name "${board}_bsp"

# Set workspace and import hardware platform
#TC sdk setws ${project}.sdk
sdk setws ${board}.sdk
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
#TC file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
file copy -force ${board}.runs/impl_1/${board}_wrapper.sysdef ${board}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
#TC sdk createhw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf
sdk createhw -name ${hw_name} -hwspec ${board}.sdk/${hw_name}.hdf

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
sdk createbsp -name ${bsp_name} -proc ps7_cortexa9_0 -hwproject ${hw_name} -os standalone
sdk projects -type bsp -name ${bsp_name}

# Create FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
sdk createapp -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp

# Set the build type to release
configapp -app zynq_fsbl_app build-config release

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
sdk build_project -type bsp -name zynq_fsbl_bsp
sdk build_project -type app -name zynq_fsbl_app

# done
exit
