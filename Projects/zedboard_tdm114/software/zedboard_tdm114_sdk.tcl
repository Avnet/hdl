# ----------------------------------------------------------------------------
#  
#        ** **        **          **  ****      **  **********  ********** ® 
#       **   **        **        **   ** **     **  **              ** 
#      **     **        **      **    **  **    **  **              ** 
#     **       **        **    **     **   **   **  *********       ** 
#    **         **        **  **      **    **  **  **              ** 
#   **           **        ****       **     ** **  **              ** 
#  **  .........  **        **        **      ****  **********      ** 
#     ........... 
#                                     Reach Further™ 
#  
# ----------------------------------------------------------------------------
# 
# This design is the property of Avnet.  Publication of this 
# design is not authorized without written consent from Avnet. 
# 
# Please direct any questions to the PicoZed community support forum: 
#    http://www.zedboard.org/forum 
# 
# Disclaimer: 
#    Avnet, Inc. makes no warranty for the use of this code or design. 
#    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
#    any errors, which may appear in this code, nor does it make a commitment 
#    to update the information contained herein. Avnet, Inc specifically 
#    disclaims any implied warranties of fitness for a particular purpose. 
#                     Copyright(c) 2017 Avnet, Inc. 
#                             All rights reserved. 
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         June 7, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     ZedBoard + TDM114 Camera
# 
#  Tool versions:       Vivado 2016.4
# 
#  Description:         SDK Build Script for ZedBaord, and TDM114 Camera Module
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            June 7, 2017: 1.00 Initial version for Vivado 2016.4
# 
# ----------------------------------------------------------------------------


#!/usr/bin/tclsh
set project  "zedboard_tdm114"
set hw_name  "zedboard_tdm114_hw"
set bsp_name "zedboard_tdm114_bsp"
set app_name "zedboard_tdm114_app"

# Set workspace and import hardware platform
setws ${project}.sdk

#puts "\n#\n#\n# Adding local user repository ...\n#\n#\n"
#repo -set ../software/sw_repository

puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
sdk createhw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
createbsp -name ${bsp_name} -proc ps7_cortexa9_0 -hwproject ${hw_name} -os standalone
# add libraries for FSBL
setlib -bsp ${bsp_name} -lib xilffs
setlib -bsp ${bsp_name} -lib xilrsa
# regen and build
regenbsp -hw ${hw_name} -bsp ${bsp_name}
projects -build -type bsp -name ${bsp_name}

# Create APP
puts "\n#\n#\n# Creating ${app_name} ...\n#\n#\n"
createapp -name ${app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# APP : copy sources to empty application
importsources -name ${app_name} -path ../software/${app_name}/src

# build APP
puts "\n#\n#\n# Build ${app_name} ...\n#\n#\n"
projects -build -type app -name ${app_name}

# Create Zynq FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
#createapp -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp
createapp -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp ${bsp_name}

# Set the build type to release
#configapp -app zynq_fsbl_app build-config release

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
#projects -build -type bsp -name zynq_fsbl_bsp
projects -build -type app -name zynq_fsbl_app

# done
exit