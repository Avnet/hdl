#Example test.tcl

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

set_workspace ${project}.sdk

puts "\n#\n#\n# Adding local user repository ...\n#\n#\n"
hsi::set_repo_path ../software/sw_repository

puts "\n#\n#\n# Importing hardware ${hw_name} ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
create_project -type hw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

hsi::open_hw_design ${project}.sdk/${hw_name}/system.hdf

# Create fmchc_python1300c application
puts "\n#\n#\n# Creating ${app_name} ...\n#\n#\n"
create_project -type app -name ${app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Modify fmchc_python1300c BSP (with HSI commands)
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
param_name ${project}.sdk/${bsp_name}/system.mss "system"
open_sw_design ${project}.sdk/${bsp_name}/system.mss
# Add FMC_HDMI_CAM_SW library
add_library fmc_iic_sw
add_library fmc_hdmi_cam_sw
# Add ONSEMI_PYTHON_SW library
add_library onsemi_python_sw
#
generate_bsp -compile -sw [current_sw_design] -dir ${project}.sdk/${bsp_name}
close_sw_design [current_sw_design]

# APP : copy sources to empty application
#file copy ../software/${app_name}/src ${project}.sdk/${app_name}/src
exec cp -f -r ../software/${app_name}/src ${project}.sdk/${app_name}

# build EMBV application
puts "\n#\n#\n# Build ${app_name} ...\n#\n#\n"
#build -type bsp -name ${bsp_name}
build -type app -name ${app_name}

# Create FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
create_project -type app -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp

# Build FSBL application
puts "\n#\n#\n# Building zynq_fsbl ...\n#\n#\n"
build -type bsp -name zynq_fsbl_bsp
build -type app -name zynq_fsbl_app

# done
exit