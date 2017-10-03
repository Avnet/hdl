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
#  Please direct any questions or issues to the UltraZed Community Forums:
#      http://www.ultrazed.org
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
#  Create Date:         Oct 02, 2017
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     UltraZed SOM
# 
#  Tool versions:       Vivado 2017.2
# 
#  Description:         SDK Build Script for PicoZed PetaLinux hardware 
#                       platform used for Xilinx CCD
# 
#  Dependencies:        To be called from a configured make script call
#
#  Revision:            Oct 02, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#!/usr/bin/tclsh
set project  "uz_pciec_ccd"
set hw_name  "uz_pciec_ccd_hw"
set bsp_name "uz_pciec_ccd_bsp"
set tpm_pmod_test_name "tpm_pmod_test"

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

# Create TPM Pmod Test application
puts "\n#\n#\n# Creating ${tpm_pmod_test_name} ...\n#\n#\n"
sdk create_app_project -name ${tpm_pmod_test_name} -hwproject ${hw_name} -proc psu_cortexa53_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Import revision controlled source code into the application projects
puts "\n#\n#\n# Importing application code into projects ...\n#\n#\n"
sdk import_sources -name ${tpm_pmod_test_name} -path ../software/${tpm_pmod_test_name}/src

# Build TPM Pmod Test application
puts "\n#\n#\n# Build ${tpm_pmod_test_name} ...\n#\n#\n"
sdk build_project -type app -name ${tpm_pmod_test_name}

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
