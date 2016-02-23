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
#  Create Date:         June 22, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     FMC-HDMI-CAM + PYTHON-1300-C
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         SDK Build Script for FMC-HDMI-CAM + PYTHON-1300-C Design
# 
#  Dependencies:        To be called from a configured make script call

#
#  Revision:            Jun 22, 2015: 1.00 Initial version for Vivado 2014.4
#                       Nov 16, 2015: 1.01 Updated for Vivado 2015.2
# 
# ----------------------------------------------------------------------------


#!/usr/bin/tclsh
set project  "fmchc_python1300c"
set hw_name  "fmchc_python1300c_hw"
set bsp_name "fmchc_python1300c_bsp"
set app_name "fmchc_python1300c_app"

# The param_name proc works around a bug In the tools where the MSS file isn't getting updated correctly. 
# This is fixed in 2015.2 (or 1 hopefully). 
# This will allow you to open the SDK project and keeps the Changes made in the HSI
proc param_name {mss name} {

        set fp [open $mss r]
        set file_data [read $fp]
        close $fp

        set fileout [open $mss "w"]
        set data [split $file_data "\n"]
        for {set i 0} {$i < [llength $data]} {incr i} {
                if {[string first "PARAMETER NAME" [lindex $data $i]] != -1 } {
                                puts $fileout "PARAMETER NAME = ${name}"
                } else {
                        puts $fileout [lindex $data $i]
                }
        }
        close $fileout
}

# Set workspace and import hardware platform
sdk set_workspace ${project}.sdk

puts "\n#\n#\n# Adding local user repository ...\n#\n#\n"
sdk set_user_repo_path  ../software/sw_repository

puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
sdk create_hw_project -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

# Create fmchc_python1300c application
puts "\n#\n#\n# Creating ${app_name} ...\n#\n#\n"
sdk create_app_project -name ${app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Modify fmchc_python1300c BSP (with HSI commands)
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
#
hsi::set_repo_path ../software/sw_repository
hsi::open_hw_design ${project}.sdk/${hw_name}/system.hdf
hsi::open_sw_design ${project}.sdk/${bsp_name}/system.mss
# Add FMC_HDMI_CAM_SW library
hsi::add_library fmc_iic_sw
hsi::add_library fmc_hdmi_cam_sw
# Add ONSEMI_PYTHON_SW library
hsi::add_library onsemi_python_sw
# Build BSP
hsi::generate_bsp -compile -sw [hsi::current_sw_design] -dir ${project}.sdk/${bsp_name}
#
hsi::close_sw_design [hsi::current_sw_design]
hsi::close_hw_design [hsi::current_hw_design]

# APP : copy sources to empty application
sdk import_sources -name ${app_name} -path ../software/${app_name}/src

# build EMBV application
puts "\n#\n#\n# Build ${app_name} ...\n#\n#\n"
#sdk build_project -type bsp -name ${bsp_name}
sdk build_project -type app -name ${app_name}

# # Create FSBL application
# puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
# sdk create_app_project -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp
# # SDK 2015.4 => no longer works, throws an error ...

# # Build FSBL application
# puts "\n#\n#\n# Building zynq_fsbl ...\n#\n#\n"
# sdk build_project -type bsp -name zynq_fsbl_bsp
# sdk build_project -type app -name zynq_fsbl_app

# Create FSBL application (with HSI, will not be visible in SDK GUI)
puts "\n#\n#\n# Creating zynq_fsbl_app ...\n#\n#\n"
hsi::open_hw_design ${project}.sdk/${hw_name}/system.hdf
hsi::generate_app -app zynq_fsbl -proc ps7_cortexa9_0 -dir ${project}.sdk/zynq_fsbl_app -compile
hsi::close_hw_design [hsi::current_hw_design]

# done
exit