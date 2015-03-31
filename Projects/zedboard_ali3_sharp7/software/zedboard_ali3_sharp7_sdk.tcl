#Example test.tcl

#!/usr/bin/tclsh
set project  "zedboard_ali3_sharp7"
set hw_name  "zed_ali3_hw"
set bsp_name "zed_ali3_bsp"
set console_app_name "zed_ali3_console_app"
set controller_app_name "zed_ali3_controller_app"

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

puts "\n#\n#\n# Importing hardware ${hw_name} ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
create_project -type hw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

hsi::open_hw_design ${project}.sdk/${hw_name}/system.hdf

# Create ALI3 display console application
puts "\n#\n#\n# Creating ${console_app_name} ...\n#\n#\n"
create_project -type app -name ${console_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Create ALI3 display controller application
puts "\n#\n#\n# Creating ${controller_app_name} ...\n#\n#\n"
create_project -type app -name ${controller_app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 

# Generate BSP
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
param_name ${project}.sdk/${bsp_name}/system.mss "system"
open_sw_design ${project}.sdk/${bsp_name}/system.mss
generate_bsp -compile -sw [current_sw_design] -dir ${project}.sdk/${bsp_name}
close_sw_design [current_sw_design]

# APP : copy console application sources to the empty application project
exec cp -f -r ../software/${console_app_name}/src ${project}.sdk/${console_app_name}
# APP : copy controller application sources to the empty application project
exec cp -f -r ../software/${controller_app_name}/src ${project}.sdk/${controller_app_name}

# Build ALI3 display controller application
puts "\n#\n#\n# Build ${console_app_name} ...\n#\n#\n"
build -type app -name ${console_app_name}

# Build ALI3 display controller application
puts "\n#\n#\n# Build ${controller_app_name} ...\n#\n#\n"
build -type app -name ${controller_app_name}

# Create FSBL application
puts "\n#\n#\n# Creating zynq_fsbl ...\n#\n#\n"
create_project -type app -name zynq_fsbl_app -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Zynq FSBL} -bsp zynq_fsbl_bsp

# Build FSBL application
puts "\n#\n#\n Building zynq_fsbl ...\n#\n#\n"
build -type bsp -name zynq_fsbl_bsp
build -type app -name zynq_fsbl_app

# done
exit