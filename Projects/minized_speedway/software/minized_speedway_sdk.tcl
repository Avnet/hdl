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
#  Create Date:         Aug 14, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Vivado 2017.1
# 
#  Description:         SDK Build Script for MiniZed PetaLinux hardware 
#                       platform
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Aug 14, 2017: 1.00 Initial version
#                       Jan 10, 2018: 1.01 Added configuration parameters so
#                                          that UART can be chagned from 
#                                          default setting in the BSP which is
#                                          useful for MiniZed projects also
#                                          updated deprecated XSCT commands to
#                                          latest commands as specified in
#                                          most recent Xilinx doucmentation 
#                                          UG1208
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh

##############################################################################
#
# Begin SDK project configuration parameters section used for the remainder 
# of this script.
#
##############################################################################

# This is the project name and should match the name of the Vivado HW project 
# folder.
set project                  "minized_speedway"

# This is the Hardware Definition and will contain the exported HDF file from
# the Vivado HW project and can be named anything but for historical purposes
# you should consider naming it "${project}_hw" to keep it simple.
set hw_name                  "${project}_hw"

# This is the Board Support Package name and will contain the generated BSP 
# based upon the Vivado HW project.  Although it can be named anything you 
# fancy, for historical purposes consider naming it "${project}_bsp" to keep 
# it simple. It is NOT to be confused with the BSP that gets generated for the
# FSBL which should have its own BSP due to library dependencies upon xilffs 
# and xilrsa libraries which may not be desired in the application BSP.
set bsp_name                 "${project}_bsp"

# This is the Standalone application that tests the LED_w_Int AXI IP instance
# which proves that the Custom IP functions as expected from a processor 
# perspective.
set led_dimmer_test_app_name "LED_Dimmer_Int"

# For project created by people who like to use UARTs other than ps7_uart_0, 
# we have the following option now available which will be set for the BSPs
# that get generated.
set uart_port_name           "ps7_uart_1"

# The name of the FSBL application that is created from the Zynq FSBL 
# application template.
set fsbl_app_name            "zynq_fsbl_app"

# The name of the FSBL application that is generated.
set fsbl_bsp_name            "zynq_fsbl_bsp"

##############################################################################
#
# End SDK project configuration parameters section.
#
##############################################################################


##############################################################################
#
# Create the Hardware Platform Specification project which is derived from
# the Hardware Defininition File exported by Vivado.
#
##############################################################################

# Set workspace and import hardware platform
setws ${project}.sdk
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
createhw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

##############################################################################
#
# Create the Board Support Package project which is derived from the Hardware
# Platform Specification project.
#
##############################################################################

# Create the BSP project
puts "\n#\n#\n# Creating BSP ${bsp_name} project ...\n#\n#\n"
createbsp -name ${bsp_name} -proc ps7_cortexa9_0 -hwproject ${hw_name} -os standalone

# Update BSP settings for standalone application.
puts "\n#\n#\n# Configuring MSS file for BSP ${bsp_name} ...\n#\n#\n"
configbsp -bsp ${project}.sdk/${bsp_name}/system.mss stdin ${uart_port_name}
configbsp -bsp ${project}.sdk/${bsp_name}/system.mss stdout ${uart_port_name}
updatemss -mss ${project}.sdk/${bsp_name}/system.mss
regenbsp -bsp ${bsp_name}

# Build the standalone BSP needed for applications
puts "\n#\n#\n# Building BSP ${bsp_name} project ...\n#\n#\n"
sdk projects -build -type bsp -name ${bsp_name}

##############################################################################
#
# Create the Standalone applications which depend upon the Board Support 
# Package project.
#
##############################################################################

# Create LED Dimmer Test application
puts "\n#\n#\n# Creating ${led_dimmer_test_app_name} ...\n#\n#\n"
createapp -name ${led_dimmer_test_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
importsources -name ${led_dimmer_test_app_name} -path ../software/${led_dimmer_test_app_name}/src

# Build LED Dimmer Test application
puts "\n#\n#\n# Building APP ${led_dimmer_test_app_name} ...\n#\n#\n"
projects -build -type app -name ${led_dimmer_test_app_name}

##############################################################################
#
# Create the First Stage Boot Loader (FSBL) project which will be used to
# create boot images for Standalone applications.
#
##############################################################################

# Create FSBL application
puts "\n#\n#\n# Creating Zynq FSBL project ${fsbl_app_name} ...\n#\n#\n"
createapp -name ${fsbl_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp ${fsbl_bsp_name}

# Set the build type to release
configapp -app ${fsbl_app_name} build-config release

# Build FSBL application
puts "\n#\n#\n# Building FSBL APP ${fsbl_app_name} ...\n#\n#\n"
projects -build -type bsp -name ${fsbl_bsp_name}
projects -build -type app -name ${fsbl_app_name}

# done
exit