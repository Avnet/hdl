#Example test.tcl

#!/usr/bin/tclsh
set project  "embv_hdmi_passthrough"
set hw_name  "hdmi_passthrough_hw"
set bsp_name "hdmi_passthrough_bsp"
set app_name "hdmi_passthrough_app"

set_workspace ${project}.sdk

puts "\n#\n#\n# Adding local user repository ...\n#\n#\n"
set_repo_path ../software/sw_repository

puts "\n#\n#\n# Importing hardware ${hw_name} ...\n#\n#\n"
file copy -force ${project}.runs/impl_1/${project}_wrapper.sysdef ${project}.sdk/${hw_name}.hdf
create_project -type hw -name ${hw_name} -hwspec ${project}.sdk/${hw_name}.hdf

cd ${project}.sdk/${hw_name}
open_hw_design system.hdf

# Create BSP for EMBV application (using MSS which specifies iicps_v2_2 driver)
puts "\n#\n#\n# Creating ${bsp_name} ...\n#\n#\n"
generate_bsp -sw_mss ../../../software/${bsp_name}.mss -dir ../${bsp_name}_ref -compile

cd ../..

puts "\n#\n#\n# Adding local user repository ...\n#\n#\n"
set_user_repo_path ../software/sw_repository

# Create EMBV application
puts "\n#\n#\n# Creating ${app_name} ...\n#\n#\n"
#create_project -type app -name ${app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -mss ${bsp_name}.mss -lang C -app {Empty Application} -bsp ${bsp_name}
create_project -type app -name ${app_name} -hwproject ${hw_name} -proc ps7_cortexa9_0 -os standalone -lang C -app {Empty Application} -bsp ${bsp_name} 
# BSP : did not use custom .mss file, replace with correctly generated BSP
file copy   -force ../software/${bsp_name}.mss ${project}.sdk/${bsp_name}/system.mss
file delete -force ${project}.sdk/${bsp_name}/ps7_cortexa9_0
file copy   -force ${project}.sdk/${bsp_name}_ref/ps7_cortexa9_0 ${project}.sdk/${bsp_name}/.
# APP : copy sources to empty application
file copy ../software/${app_name}/src ${project}.sdk/${app_name}/src

# build EMBV application
puts "\n#\n#\n# Build ${app_name} ...\n#\n#\n"
build -type bsp -name ${bsp_name}
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