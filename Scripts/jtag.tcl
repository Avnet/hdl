# make certain the GUI is open for JTAG

open_hw
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets */xilinx_tcf/*]
# read only?? set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/*]
open_hw_target
current_hw_device [lindex [get_hw_devices] 1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 1]
after 10000
set_property PROBES.FILE {} [lindex [get_hw_devices] 1]
set_property PROGRAM.FILE $scripts_folder/$board\_$project/$jtagFilename [lindex [get_hw_devices] 1]
program_hw_devices [lindex [get_hw_devices] 1]
refresh_hw_device [lindex [get_hw_devices] 1]