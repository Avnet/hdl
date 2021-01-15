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
#  Create Date:         Mar 11, 2016
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     PicoZed SOM
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         SDK Build Script for PicoZed PetaLinux hardware 
#                       platform
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Mar 11, 2016: 1.00 Initial version
#                       May 12, 2016: 1.01 Updated for Vivado 2015.4
#                       Apr 05, 2018: 1.02 Updated for Vivado 2017.4
#                                          Replace deprecated commands with new
# 
# ----------------------------------------------------------------------------

##############################################################################
#
# Begin SDK project configuration parameters section used for the remainder 
# of this script.
#
##############################################################################

# Fetch the $board name from the make.tcl command line
# The command line is $project\_sdk.tcl -notrace $board $vivado_ver
set board                   [lindex $argv 0]
set vivado_ver              [lindex $argv 1]

# This is the project name and should match the name of the Vivado HW project 
# folder.
set project  "pz_petalinux"

# This is the Hardware Definition and will contain the exported HDF file from
# the Vivado HW project and can be named anything but for historical purposes
# you should consider naming it "${project}_hw" to keep it simple.
set hw_name  "${board}_hw"

# This is the Board Support Package name and will contain the generated BSP 
# based upon the Vivado HW project.  Although it can be named anything you 
# fancy, for historical purposes consider naming it "${project}_bsp" to keep 
# it simple. It is NOT to be confused with the BSP that gets generated for the
# FSBL which should have its own BSP due to library dependencies upon xilffs 
# and xilrsa libraries which may not be desired in the application BSP.
set bsp_name "${board}_bsp"

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
setws ${board}.sdk
puts "\n#\n# ${board} \n#\n#"
puts "\n#\n#\n# Importing hardware definition ${hw_name} from impl_1 folder ...\n#\n#\n"
file mkdir ./${board}.sdk
file copy -force ${board}.runs/impl_1/${board}_wrapper.sysdef ${board}.sdk/${hw_name}.hdf
puts "\n#\n#\n# Create hardware definition project ...\n#\n#\n"
createhw -name ${hw_name} -hwspec ${board}.sdk/${hw_name}.hdf


##############################################################################
#
# Create the First Stage Boot Loader (FSBL) project which will be used to
# create boot images for Standalone applications.
#
##############################################################################

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
createbsp -name ${bsp_name} -proc ps7_cortexa9_0 -hwproject ${hw_name} -os standalone
projects -build -type bsp -name ${bsp_name}

# Create Zynq FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
createapp -name ${fsbl_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp ${fsbl_bsp_name}

# Set the build type to release
configapp -app ${fsbl_app_name} build-config release

# Build FSBL application
puts "\n#\n#\n# Building zynq_fsbl ...\n#\n#\n"
projects -build -type bsp -name ${fsbl_bsp_name}
projects -build -type app -name ${fsbl_app_name}

# done
exit
