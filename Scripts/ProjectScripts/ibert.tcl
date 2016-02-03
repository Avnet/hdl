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
#  Create Date:         October 08, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     PicoZed 7015 SOM + FMC Carrier Card
# 
#  Tool versions:       Vivado 2015.2.1
# 
#  Description:         uild Script for PicoZed 7015 SOM + FMC Carrier Card IBERT
# 
#  Dependencies:        To be called from a configured make script call
#                       Calls support scripts, such as board configuration scripts
#                       IP generation scripts or others as needed
# 
# ----------------------------------------------------------------------------

#3.75Gbps_onb250Mhz

# 'private' used to allow this project to be privately tagged
# 'public' used to allow this project to be publicly tagged
set release_state public

# Generate Avnet IP
puts "***** Generating IP..."

# Create Vivado project
puts "***** Creating Vivado Project..."
source ../Boards/$board/$board.tcl -notrace
avnet_create_project $project $projects_folder $scriptdir
remove_files -fileset constrs_1 *.xdc
if {[string match -nocase "PZ7015_FMCCC" $board]} {
   add_files -fileset constrs_1 -norecurse ${projects_folder}/../pz7015_ibert_7series_gtp_0.xdc
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   add_files -fileset constrs_1 -norecurse ${projects_folder}/../pz7030_ibert_7series_gtx_0.xdc
} elseif {[string match -nocase "PZ7015_FMC2" $board]} {
   add_files -fileset constrs_1 -norecurse ${projects_folder}/../pz7015_fmc2_ibert_7series_gtp_0.xdc
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}

# Add Avnet IP Repository
puts "***** Updating Vivado to include IP Folder"
cd ../Projects/$project/$board
if {[string match -nocase "PZ7015_FMCCC" $board]} {
   create_ip -name ibert_7series_gtp -vendor xilinx.com -library ip -version 3.0 -module_name ibert_7series_gtp_0
   set_property -dict [list CONFIG.C_PROTOCOL_MAXLINERATE_1 {3.75} CONFIG.C_PROTOCOL_RXREFCLK_FREQUENCY_1 {250.000} CONFIG.C_PROTOCOL_QUAD0 {Custom_1_/_3.75_Gbps} CONFIG.C_REFCLK_SOURCE_QUAD_0 {MGTREFCLK1_112} CONFIG.C_SYSCLOCK_SOURCE_INT {QUAD112_1} CONFIG.C_PROTOCOL_MAXLINERATE_1 {3.75} CONFIG.C_PROTOCOL_MAXLINERATE_2 {3.125} CONFIG.C_PROTOCOL_MAXLINERATE_3 {3.125} CONFIG.C_PROTOCOL_QUAD0 {Custom_1_/_3.75_Gbps} CONFIG.C_PROTOCOL_QUAD1 {None} CONFIG.C_PROTOCOL_QUAD2 {None} CONFIG.C_PROTOCOL_QUAD3 {None} CONFIG.C_REFCLK_SOURCE_QUAD_1 {None} CONFIG.C_REFCLK_SOURCE_QUAD_2 {None} CONFIG.C_REFCLK_SOURCE_QUAD_3 {None} CONFIG.C_CHANNEL_QUAD_0 {Channel_0} CONFIG.C_CHANNEL_QUAD_1 {Channel_0} CONFIG.C_CHANNEL_QUAD_2 {Channel_0} CONFIG.C_CHANNEL_QUAD_3 {Channel_0} CONFIG.C_RXOUTCLK_GT_LOCATION {QUAD_112} CONFIG.C_RXOUTCLK_PIN_STD {DIFF_SSTL15} CONFIG.C_RXOUTCLK_FREQUENCY {234.375} CONFIG.C_SYSCLK_MODE_EXTERNAL {0} CONFIG.C_SYSCLK_IO_PIN_STD {DIFF_SSTL15} CONFIG.C_SYSCLK_IO_PIN_LOC_P {UNASSIGNED} CONFIG.C_SYSCLK_IO_PIN_LOC_N {UNASSIGNED} CONFIG.C_SYSCLK_FREQUENCY {250.000}] [get_ips ibert_7series_gtp_0]
   generate_target {instantiation_template} [get_files ./$project.srcs/sources_1/ip/ibert_7series_gtp_0/ibert_7series_gtp_0.xci]
   generate_target all [get_files  ./$project.srcs/sources_1/ip/ibert_7series_gtp_0/ibert_7series_gtp_0.xci]
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   create_ip -name ibert_7series_gtx -vendor xilinx.com -library ip -version 3.0 -module_name ibert_7series_gtx_0
   set_property -dict [list CONFIG.C_PROTOCOL_MAXLINERATE_1 {6.25} CONFIG.C_PROTOCOL_RXREFCLK_FREQUENCY_1 {250.000} CONFIG.C_PROTOCOL_QUAD0 {Custom_1_/_6.25_Gbps} CONFIG.C_REFCLK_SOURCE_QUAD_0 {MGTREFCLK1_112} CONFIG.C_SYSCLOCK_SOURCE_INT {QUAD112_1} CONFIG.C_PROTOCOL_QUAD0 {Custom_1_/_6.25_Gbps} CONFIG.C_PROTOCOL_QUAD1 {None} CONFIG.C_PROTOCOL_QUAD2 {None} CONFIG.C_PROTOCOL_QUAD3 {None} CONFIG.C_PROTOCOL_QUAD4 {None} CONFIG.C_PROTOCOL_QUAD5 {None} CONFIG.C_PROTOCOL_QUAD6 {None} CONFIG.C_PROTOCOL_QUAD7 {None} CONFIG.C_PROTOCOL_QUAD8 {None} CONFIG.C_PROTOCOL_QUAD9 {None} CONFIG.C_PROTOCOL_QUAD10 {None} CONFIG.C_PROTOCOL_QUAD11 {None} CONFIG.C_PROTOCOL_QUAD12 {None} CONFIG.C_PROTOCOL_QUAD13 {None} CONFIG.C_PROTOCOL_QUAD14 {None} CONFIG.C_PROTOCOL_QUAD15 {None} CONFIG.C_REFCLK_SOURCE_QUAD_1 {None} CONFIG.C_REFCLK_SOURCE_QUAD_2 {None} CONFIG.C_REFCLK_SOURCE_QUAD_3 {None} CONFIG.C_REFCLK_SOURCE_QUAD_4 {None} CONFIG.C_REFCLK_SOURCE_QUAD_5 {None} CONFIG.C_REFCLK_SOURCE_QUAD_6 {None} CONFIG.C_REFCLK_SOURCE_QUAD_7 {None} CONFIG.C_REFCLK_SOURCE_QUAD_8 {None} CONFIG.C_REFCLK_SOURCE_QUAD_9 {None} CONFIG.C_REFCLK_SOURCE_QUAD_10 {None} CONFIG.C_REFCLK_SOURCE_QUAD_11 {None} CONFIG.C_REFCLK_SOURCE_QUAD_12 {None} CONFIG.C_REFCLK_SOURCE_QUAD_13 {None} CONFIG.C_REFCLK_SOURCE_QUAD_14 {None} CONFIG.C_REFCLK_SOURCE_QUAD_15 {None} CONFIG.C_CHANNEL_QUAD_0 {Channel_0} CONFIG.C_CHANNEL_QUAD_1 {Channel_0} CONFIG.C_CHANNEL_QUAD_2 {Channel_0} CONFIG.C_CHANNEL_QUAD_3 {Channel_0} CONFIG.C_CHANNEL_QUAD_4 {Channel_0} CONFIG.C_CHANNEL_QUAD_5 {Channel_0} CONFIG.C_CHANNEL_QUAD_6 {Channel_0} CONFIG.C_CHANNEL_QUAD_7 {Channel_0} CONFIG.C_CHANNEL_QUAD_8 {Channel_0} CONFIG.C_CHANNEL_QUAD_9 {Channel_0} CONFIG.C_CHANNEL_QUAD_10 {Channel_0} CONFIG.C_CHANNEL_QUAD_11 {Channel_0} CONFIG.C_CHANNEL_QUAD_12 {Channel_0} CONFIG.C_CHANNEL_QUAD_13 {Channel_0} CONFIG.C_CHANNEL_QUAD_14 {Channel_0} CONFIG.C_CHANNEL_QUAD_15 {Channel_0} CONFIG.C_RXOUTCLK_GT_LOCATION {QUAD_112} CONFIG.C_RXOUTCLK_PIN_STD {DIFF_SSTL15} CONFIG.C_RXOUTCLK_FREQUENCY {195.3125} CONFIG.C_SYSCLK_MODE_EXTERNAL {0} CONFIG.C_SYSCLK_IO_PIN_STD {DIFF_SSTL15} CONFIG.C_SYSCLK_FREQUENCY {250.000} CONFIG.C_SYSCLK_IO_PIN_LOC_N {UNASSIGNED} CONFIG.C_SYSCLK_IO_PIN_LOC_P {UNASSIGNED}] [get_ips ibert_7series_gtx_0]
   generate_target {instantiation_template} [get_files ./$project.srcs/sources_1/ip/ibert_7series_gtx_0/ibert_7series_gtx_0.xci]
   generate_target all [get_files  ./$project.srcs/sources_1/ip/ibert_7series_gtx_0/ibert_7series_gtx_0.xci]
} elseif {[string match -nocase "PZ7015_FMC2" $board]} {
   create_ip -name ibert_7series_gtp -vendor xilinx.com -library ip -version 3.0 -module_name ibert_7series_gtp_0
   set_property -dict [list CONFIG.C_PROTOCOL_MAXLINERATE_1 {3.125} CONFIG.C_PROTOCOL_RXREFCLK_FREQUENCY_1 {250.000} CONFIG.C_PROTOCOL_QUAD0 {Custom_1_/_3.125_Gbps} CONFIG.C_REFCLK_SOURCE_QUAD_0 {MGTREFCLK1_112} CONFIG.C_PROTOCOL_MAXLINERATE_1 {3.125} CONFIG.C_PROTOCOL_MAXLINERATE_2 {3.125} CONFIG.C_PROTOCOL_MAXLINERATE_3 {3.125} CONFIG.C_PROTOCOL_QUAD0 {Custom_1_/_3.125_Gbps} CONFIG.C_PROTOCOL_QUAD1 {None} CONFIG.C_PROTOCOL_QUAD2 {None} CONFIG.C_PROTOCOL_QUAD3 {None} CONFIG.C_REFCLK_SOURCE_QUAD_1 {None} CONFIG.C_REFCLK_SOURCE_QUAD_2 {None} CONFIG.C_REFCLK_SOURCE_QUAD_3 {None} CONFIG.C_CHANNEL_QUAD_0 {Channel_0} CONFIG.C_CHANNEL_QUAD_1 {Channel_0} CONFIG.C_CHANNEL_QUAD_2 {Channel_0} CONFIG.C_CHANNEL_QUAD_3 {Channel_0} CONFIG.C_RXOUTCLK_GT_LOCATION {QUAD_112} CONFIG.C_RXOUTCLK_PIN_STD {DIFF_SSTL15} CONFIG.C_SYSCLOCK_SOURCE_INT {External}] [get_ips ibert_7series_gtp_0]
   generate_target {instantiation_template} [get_files ./$project.srcs/sources_1/ip/ibert_7series_gtp_0/ibert_7series_gtp_0.xci]
   generate_target all [get_files  ./$project.srcs/sources_1/ip/ibert_7series_gtp_0/ibert_7series_gtp_0.xci]
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}
set_property ip_repo_paths  ../../../IP [current_fileset]
update_ip_catalog
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
close_project

# now the fun part, build the example!
if {[string match -nocase "PZ7015_FMCCC" $board]} {
   # change to 3.75Gbps_onb250Mhz
   create_project ibert_7series_gtp_0_example ./example -force
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   # change to 6.25Gbps_onb250Mhz
   create_project ibert_7series_gtx_0_example ./example -force
} elseif {[string match -nocase "PZ7015_FMC2" $board]} {
   # change to 3.125Gbps_onb250Mhz
   create_project ibert_7series_gtx_0_example ./example -force
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}
cd ./example
if {[string match -nocase "PZ7015_FMCCC" $board]} {
   set_property part xc7z015clg485-1 [current_project]
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   set_property part xc7z030sbg485-1 [current_project]
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   set_property part xc7z015clg485-1 [current_project]
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}
set_property target_language verilog [current_project]
set_property simulator_language MIXED [current_project]
set_property enable_core_container false [current_project]

set returnCode 0
if {[string match -nocase "PZ7015_FMCCC" $board]} {
   import_ip -files [list [file join ../$project.srcs/sources_1/ip/ibert_7series_gtp_0 ibert_7series_gtp_0.xci]] -name ibert_7series_gtp_0
   reset_target {example} [get_ips ibert_7series_gtp_0]
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   import_ip -files [list [file join ../$project.srcs/sources_1/ip/ibert_7series_gtx_0 ibert_7series_gtx_0.xci]] -name ibert_7series_gtx_0
   reset_target {example} [get_ips ibert_7series_gtx_0]
} elseif {[string match -nocase "PZ7015_FMC2" $board]} {
   import_ip -files [list [file join ../$project.srcs/sources_1/ip/ibert_7series_gtp_0 ibert_7series_gtp_0.xci]] -name ibert_7series_gtp_0
   reset_target {example} [get_ips ibert_7series_gtp_0]
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}
proc _filter_supported_targets {targets ip} {
  set res {}
  set all [get_property SUPPORTED_TARGETS $ip]
  foreach target $targets {
    lappend res {*}[lsearch -all -inline -nocase $all $target]
  }
  return $res
}

if {[string match -nocase "PZ7015_FMCCC" $board]} {
   generate_target [_filter_supported_targets {instantiation_template synthesis simulation implementation shared_logic} [get_ips ibert_7series_gtp_0]] [get_ips ibert_7series_gtp_0]
   add_files -norecurse ../../pz7015_ibert_7series_gtp_0.v
   add_files -fileset constrs_1 -norecurse ../../pz7015_ibert_7series_gtp_0.xdc
   set_property top pz7015_ibert_7series_gtp_0 [current_fileset]
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   generate_target [_filter_supported_targets {instantiation_template synthesis simulation implementation shared_logic} [get_ips ibert_7series_gtx_0]] [get_ips ibert_7series_gtx_0]
   add_files -norecurse ../../pz7030_ibert_7series_gtx_0.v
   add_files -fileset constrs_1 -norecurse ../../pz7030_ibert_7series_gtx_0.xdc
   set_property top pz7030_ibert_7series_gtx_0 [current_fileset]
} elseif {[string match -nocase "PZ7015_FMC2" $board]} {
   generate_target [_filter_supported_targets {instantiation_template synthesis simulation implementation shared_logic} [get_ips ibert_7series_gtp_0]] [get_ips ibert_7series_gtp_0]
   add_files -norecurse ../../pz7015_fmc2_ibert_7series_gtp_0.v
   add_files -fileset constrs_1 -norecurse ../../pz7015_fmc2_ibert_7series_gtp_0.xdc
   set_property top pz7015_fmc2_ibert_7series_gtp_0 [current_fileset]
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}
update_ip_catalog
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
if {[string match -nocase "PZ7015_FMCCC" $board]} {
   set dfile ./ibert_7series_gtp_0_example.srcs/sources_1/ip/ibert_7series_gtp_0/oepdone.txt
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   set dfile ./ibert_7series_gtx_0_example.srcs/sources_1/ip/ibert_7series_gtx_0/oepdone.txt
} elseif {[string match -nocase "PZ7015_FMC2" $board]} {
   set dfile ./ibert_7series_gtp_0_example.srcs/sources_1/ip/ibert_7series_gtp_0/oepdone.txt
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}
set doneFile [open $dfile w]
puts $doneFile "Open Example Project DONE"
close $doneFile
if { $returnCode != 0 } {
  error "Problems were encountered while executing the example design script, please review the log files."
}

# Build the binary
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#*- KEEP OUT, do not touch this section unless you know what you are doing! -*
#*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
puts "***** Building Binary..."
# add this to allow up+enter rebuild capability 
cd $scripts_folder
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
# need to shift the build point to example
set projects_folder $projects_folder/example
if {[string match -nocase "PZ7015_FMCCC" $board]} {
   set project ibert_7series_gtp_0_example
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   set project ibert_7series_gtx_0_example
} elseif {[string match -nocase "PZ7015_FMC2" $board]} {
   set project ibert_7series_gtp_0_example
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}
launch_runs impl_1 -to_step write_bitstream
# #*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# #*- KEEP OUT, do not touch this section unless you know what you are doing! -*
# #*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


puts "Generating Binary..."
source ./bin_helper.tcl -notrace
# JTAG bitstream 
if {[string match -nocase "PZ7015_FMCCC" $board]} {
   set jtagFilename $projects_folder/ibert_7series_gtp_0_example.runs/impl_1/example_ibert_7series_gtp_0.bit
} elseif {[string match -nocase "PZ7030_FMCCC" $board]} {
   set jtagFilename $projects_folder/ibert_7series_gtx_0_example.runs/impl_1/example_ibert_7series_gtp_0.bit
} elseif {[string match -nocase "PZ7015_FMC2" $board]} {
   set jtagFilename $projects_folder/ibert_7series_gtp_0_example.runs/impl_1/pz7015_fmc2_ibert_7series_gtp_0.bit
} else {
   error "Problems were encountered while executing the example design script, please review the log files."
}
source ./jtag.tcl -notrace
# Start Serial IO Links
#after 10000
detect_hw_sio_links