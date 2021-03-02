# IP Integrator call-backs

# HACK: Recreate XGUI/XIT source_subcore_ipfile and source_ipfile
source -notrace [file join [file dirname [get_property XML_FILE_NAME [get_ipdefs -all -quiet xilinx.com:ip:xbip_utils:3.0]]] "common_tcl/common.tcl"]
common_tcl::gen_procs xilinx.com:ip:v_osd:6.0

source_subcore_ipfile xilinx.com:ip:xbip_utils:3.0 "common_tcl/vip.tcl"

proc init {cellpath otherInfo } {
  set cellobj [get_bd_cells $cellpath]
  
  vip_set_datatype_file "bd/v_osd_v6_0_datatype.tcl" ;# Override default location
  
  vip $cellobj puts_debug "INIT ..............." ;# This will create the Virtual IP object
  
  # Specify how the parameters updated in propagate should be displayed in the GUI. i.e. greyed out but overridable
  bd::mark_propagate_overrideable $cellobj [list Data_Channel_Width s_axis_video_format]
}

proc post_config_ip {cellpath otherInfo } {
   # Any updates to interface properties based on user configuration
  set cellobj [get_bd_cells $cellpath]

  vip $cellobj puts_debug "POST_CONFIG_IP Starting..............."
  
  vip $cellobj update_busparams true
  vip $cellobj update_datatypes
  
  vip $cellobj puts_debug "...........POST_CONFIG_IP Complete"
}

proc propagate { cellpath otherInfo } {
  set cellobj [get_bd_cells $cellpath]
  
  vip $cellobj puts_debug "$cellpath: PROPAGATE Starting..............."

  set last_format 0
  set last_width 0

  # Video domain specific #######
  # Check to see if we've been passed a video type
  foreach interface [get_bd_intf_pin -of_objects [get_bd_cells $cellpath] -filter "path =~ $cellpath/video_s*"] {
    regsub "$cellpath/" $interface {} interface
    set prop_type [vip $cellobj get_datatype $interface TDATA PROP]
    if { [vip $cellobj vf_v1_0_is_vf_type $prop_type] } {
      
      # This checks strength before setting the value (if final arg true then it forces set) 
      vip $cellobj set_param_value s_axis_video_format [vip $cellobj $interface\_get_video_format $prop_type] false

      if {$last_format != 0 && $last_format != [vip $cellobj $interface\_get_video_format $prop_type]} {
        send_msg "[vip $cellobj get_msgid]_propagate-6" ERROR "Video format of interface $interface is [vip $cellobj $interface\_get_video_format $prop_type].  This does not match video format of other input interfaces of $last_format."
      }
      if {$last_width != 0 && $last_width != [vip $cellobj vf_v1_0_get_video_data_width $prop_type]} {
        send_msg "[vip $cellobj get_msgid]_propagate-7" ERROR "Video component width of interface $interface is [vip $cellobj vf_v1_0_get_video_data_width $prop_type].  This does not match video compnent width of other input interfaces of $last_width."
      }

      set last_format [vip $cellobj $interface\_get_video_format $prop_type]
      set last_width [vip $cellobj vf_v1_0_get_video_data_width $prop_type]

      # This checks strength before setting the value (if final arg true then it forces set) 
       vip $cellobj set_param_value Data_Channel_Width [vip $cellobj vf_v1_0_get_video_data_width $prop_type] false
    } 
  }
  # Re-evaluate bus params, inc data type defs
  vip $cellobj update_busparams
  vip $cellobj update_datatypes
}

proc post_propagate { cellpath otherInfo } {
  set cellobj [get_bd_cells $cellpath]

  vip $cellobj puts_debug "POST_PROPAGATE Starting..............."
  vip $cellobj validate_datatypes
  vip $cellobj puts_debug "...........POST_PROPAGATE Complete"
}
