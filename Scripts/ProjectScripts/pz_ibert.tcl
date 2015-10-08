# create variables with absolute folders for all necessary folders
# cd C:/workingFolder/jtag_work/temp_test
# source ./jtag.tcl -notrace
set project "6.25Gbps_onb250MHz"
set board "7030"
set boards_folder [file normalize [pwd]/../Boards]
set ip_folder [file normalize [pwd]/../IP]
set projects_folder [file normalize [pwd]/../Projects/$project/$board]
set scripts_folder [file normalize [pwd]]
set repo_folder [file normalize [pwd]../../]

# create GREP process
# From: http://wiki.tcl.tk/9395
# Modified to set a variable, instead of only printing locations
proc grep {pattern args} {
    global found
    set found "false"
    if {[llength $args] == 0} {
        grep0 "" $pattern stdin
    } else {
        foreach filename $args {
            if {[file exists $filename]} {
               set file [open $filename r]
               grep0 ${filename}: $pattern $file
               close $file
            } else {
               puts "File $filename does not exist"
            }
        }
    }
}
proc grep0 {prefix pattern handle} {
    set lnum 0
    while {[gets $handle line] >= 0} {
        incr lnum
        if {[regexp $pattern $line]} {
            global found
            set found "true"
            puts "$prefix${lnum}:${line}"
        }
    }
}

#start_gui
create_project $board\_$project $scripts_folder/$board\_$project -part xc7z030sbg485-1 -force
create_ip -name ibert_7series_gtx -vendor xilinx.com -library ip -version 3.0 -module_name ibert_7series_gtx_0
set_property -dict [list CONFIG.C_PROTOCOL_MAXLINERATE_1 {6.25} CONFIG.C_PROTOCOL_RXREFCLK_FREQUENCY_1 {250.000} CONFIG.C_PROTOCOL_QUAD0 {Custom_1_/_6.25_Gbps} CONFIG.C_REFCLK_SOURCE_QUAD_0 {MGTREFCLK1_112} CONFIG.C_SYSCLOCK_SOURCE_INT {QUAD112_1} CONFIG.C_PROTOCOL_QUAD0 {Custom_1_/_6.25_Gbps} CONFIG.C_PROTOCOL_QUAD1 {None} CONFIG.C_PROTOCOL_QUAD2 {None} CONFIG.C_PROTOCOL_QUAD3 {None} CONFIG.C_PROTOCOL_QUAD4 {None} CONFIG.C_PROTOCOL_QUAD5 {None} CONFIG.C_PROTOCOL_QUAD6 {None} CONFIG.C_PROTOCOL_QUAD7 {None} CONFIG.C_PROTOCOL_QUAD8 {None} CONFIG.C_PROTOCOL_QUAD9 {None} CONFIG.C_PROTOCOL_QUAD10 {None} CONFIG.C_PROTOCOL_QUAD11 {None} CONFIG.C_PROTOCOL_QUAD12 {None} CONFIG.C_PROTOCOL_QUAD13 {None} CONFIG.C_PROTOCOL_QUAD14 {None} CONFIG.C_PROTOCOL_QUAD15 {None} CONFIG.C_REFCLK_SOURCE_QUAD_1 {None} CONFIG.C_REFCLK_SOURCE_QUAD_2 {None} CONFIG.C_REFCLK_SOURCE_QUAD_3 {None} CONFIG.C_REFCLK_SOURCE_QUAD_4 {None} CONFIG.C_REFCLK_SOURCE_QUAD_5 {None} CONFIG.C_REFCLK_SOURCE_QUAD_6 {None} CONFIG.C_REFCLK_SOURCE_QUAD_7 {None} CONFIG.C_REFCLK_SOURCE_QUAD_8 {None} CONFIG.C_REFCLK_SOURCE_QUAD_9 {None} CONFIG.C_REFCLK_SOURCE_QUAD_10 {None} CONFIG.C_REFCLK_SOURCE_QUAD_11 {None} CONFIG.C_REFCLK_SOURCE_QUAD_12 {None} CONFIG.C_REFCLK_SOURCE_QUAD_13 {None} CONFIG.C_REFCLK_SOURCE_QUAD_14 {None} CONFIG.C_REFCLK_SOURCE_QUAD_15 {None} CONFIG.C_CHANNEL_QUAD_0 {Channel_0} CONFIG.C_CHANNEL_QUAD_1 {Channel_0} CONFIG.C_CHANNEL_QUAD_2 {Channel_0} CONFIG.C_CHANNEL_QUAD_3 {Channel_0} CONFIG.C_CHANNEL_QUAD_4 {Channel_0} CONFIG.C_CHANNEL_QUAD_5 {Channel_0} CONFIG.C_CHANNEL_QUAD_6 {Channel_0} CONFIG.C_CHANNEL_QUAD_7 {Channel_0} CONFIG.C_CHANNEL_QUAD_8 {Channel_0} CONFIG.C_CHANNEL_QUAD_9 {Channel_0} CONFIG.C_CHANNEL_QUAD_10 {Channel_0} CONFIG.C_CHANNEL_QUAD_11 {Channel_0} CONFIG.C_CHANNEL_QUAD_12 {Channel_0} CONFIG.C_CHANNEL_QUAD_13 {Channel_0} CONFIG.C_CHANNEL_QUAD_14 {Channel_0} CONFIG.C_CHANNEL_QUAD_15 {Channel_0} CONFIG.C_RXOUTCLK_GT_LOCATION {QUAD_112} CONFIG.C_RXOUTCLK_PIN_STD {DIFF_SSTL15} CONFIG.C_RXOUTCLK_FREQUENCY {195.3125} CONFIG.C_SYSCLK_MODE_EXTERNAL {0} CONFIG.C_SYSCLK_IO_PIN_STD {DIFF_SSTL15} CONFIG.C_SYSCLK_FREQUENCY {250.000} CONFIG.C_SYSCLK_IO_PIN_LOC_N {UNASSIGNED} CONFIG.C_SYSCLK_IO_PIN_LOC_P {UNASSIGNED}] [get_ips ibert_7series_gtx_0]
generate_target {instantiation_template} [get_files $scripts_folder/$board\_$project/$board\_$project.srcs/sources_1/ip/ibert_7series_gtx_0/ibert_7series_gtx_0.xci]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target all [get_files  $scripts_folder/$board\_$project/$board\_$project.srcs/sources_1/ip/ibert_7series_gtx_0/ibert_7series_gtx_0.xci]
#edit files for pulling pins properly for REV C03 boards
#open_example_project -force -in_process -dir $scripts_folder/$board\_$project/example [get_ips  ibert_7series_gtx_0]
close_project

set srcIpDir $scripts_folder/$board\_$project/$board\_$project.srcs/sources_1/ip/ibert_7series_gtx_0
create_project ibert_7series_gtx_0_example $scripts_folder/$board\_$project/example -force
cd $scripts_folder/$board\_$project/example
set_property part xc7z030sbg485-1 [current_project]
set_property target_language verilog [current_project]
set_property simulator_language MIXED [current_project]
set_property enable_core_container false [current_project]

set returnCode 0
import_ip -files [list [file join $srcIpDir ibert_7series_gtx_0.xci]] -name ibert_7series_gtx_0
reset_target {example} [get_ips ibert_7series_gtx_0]
proc _filter_supported_targets {targets ip} {
  set res {}
  set all [get_property SUPPORTED_TARGETS $ip]
  foreach target $targets {
    lappend res {*}[lsearch -all -inline -nocase $all $target]
  }
  return $res
}

generate_target [_filter_supported_targets {instantiation_template synthesis simulation implementation shared_logic} [get_ips ibert_7series_gtx_0]] [get_ips ibert_7series_gtx_0]
add_files -norecurse $scripts_folder/example_ibert_7series_gtx_0.v
add_files -fileset constrs_1 -norecurse $scripts_folder/ibert_7series_gtx_0.xdc
set_property top example_ibert_7series_gtx_0 [current_fileset]
update_ip_catalog
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
set dfile $scripts_folder/$board\_$project/$board\_$project.srcs/sources_1/ip/ibert_7series_gtx_0/oepdone.txt
set doneFile [open $dfile w]
puts $doneFile "Open Example Project DONE"
close $doneFile
if { $returnCode != 0 } {
  error "Problems were encountered while executing the example design script, please review the log files."
}

##
#start_gui
#source $scripts_folder/$board\_$project/$board\_$project.srcs/sources_1/ip/ibert_7series_gtx_0/ibert_7series_gtx_0_ex.tcl
#puts "waiting 20 seconds"
after 20000
launch_runs impl_1 -to_step write_bitstream

set updown "up"
set dot_count 1
set x 0

puts "Generating Binary..."
while {1} {
   # stop if an error is detected
   if {[file exists $scripts_folder/$board\_$project/example/ibert_7series_gtx_0_example.runs/synth_1/runme.log]} {
      grep "ERROR:" $scripts_folder/$board\_$project/example/ibert_7series_gtx_0_example.runs/synth_1/runme.log
      if {[string match -nocase "true" $found]} { 
         puts "Found Error in Synthesis..."
         break
      }
   }
   # stop if an error is detected
   if {[file exists $scripts_folder/$board\_$project/example/ibert_7series_gtx_0_example.runs/impl_1/runme.log]} {
      grep "ERROR:" $scripts_folder/$board\_$project/example/ibert_7series_gtx_0_example.runs/impl_1/runme.log
      if {[string match -nocase "true" $found]} { 
         puts "Found Error in Bitstream Creation..."
         break
      }
   }
   # stop if end of run detected
   if {[file exists $scripts_folder/$board\_$project/example/ibert_7series_gtx_0_example.runs/impl_1/.vivado.end.rst]} { 
      puts "Found End of Bitstream Creation..."
      break 
   }
   # paint pretty picture - shows still running
   if {[string match -nocase "up" $updown]} {
      if {$dot_count < 10} { 
         incr dot_count
      } else {
         incr dot_count -1
         set updown "down"
      }
   } elseif {[string match -nocase "down" $updown]} {
      if {$dot_count > 0} { 
         incr dot_count -1
      } else {
         incr dot_count
         set updown "up"
      }
   } else {
      set dot_count 1
      set updown "down"
   }
   for {set y 0} {$y< $dot_count} {incr y} {
      puts -nonewline "."
   }
   puts "."
   # wait 1 second to check
   after 1000
}
puts "finished!"

open_hw
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets */xilinx_tcf/*]
# read only?? set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/*]
open_hw_target
current_hw_device [lindex [get_hw_devices] 1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 1]
after 10000
set_property PROBES.FILE {} [lindex [get_hw_devices] 1]
set_property PROGRAM.FILE $scripts_folder/$board\_$project/example/ibert_7series_gtx_0_example.runs/impl_1/example_ibert_7series_gtx_0.bit [lindex [get_hw_devices] 1]
program_hw_devices [lindex [get_hw_devices] 1]
refresh_hw_device [lindex [get_hw_devices] 1]
detect_hw_sio_links
