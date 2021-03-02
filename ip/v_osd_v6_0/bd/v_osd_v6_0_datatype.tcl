# Data type definitions and update procs
source_subcore_ipfile xilinx.com:ip:v_tc:6.1 "bd/video_types_v1_0.tcl"

proc v_osd_v6_0_datatype_def {} {
  variable vf_v1_0_typedefs
  set type_defs [list]
  
  # VIDEO_IN
  # - TDATA
  lappend type_defs video_s0_in
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  lappend type_defs video_s1_in
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  lappend type_defs video_s2_in
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  lappend type_defs video_s3_in
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  lappend type_defs video_s4_in
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  lappend type_defs video_s5_in
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  lappend type_defs video_s6_in
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  lappend type_defs video_s7_in
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  # VIDEO_OUT
  # - TDATA
  lappend type_defs video_out
  lappend type_defs TDATA
  lappend type_defs [lindex $vf_v1_0_typedefs 0] ;# Default type YCbCr 422
  
  return $type_defs
}

########################################################################################
# Data type and bus parameter dependency functions
# - Use the helper functions in video_types_v1_0 to generate all the call back functions
# - Type map for this core
set v_osd_v6_0_type_map [list YUV_422 0 YUV_444 1 RGB 2 YUV_420 3 YUVa_422 4 YUVa_444 5 RGBa 6 YUVa_420 7]

# VIDEO_IN - TDATA
vf_v1_0_gen_type_cbs video_s0_in S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE
vf_v1_0_gen_type_cbs video_s1_in S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE
vf_v1_0_gen_type_cbs video_s2_in S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE
vf_v1_0_gen_type_cbs video_s3_in S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE
vf_v1_0_gen_type_cbs video_s4_in S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE
vf_v1_0_gen_type_cbs video_s5_in S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE
vf_v1_0_gen_type_cbs video_s6_in S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE
vf_v1_0_gen_type_cbs video_s7_in S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE

# VIDEO_OUT - TDATA - need to transform the S_AXIS_VIDEO_FORMAT for the output to remove alpha
vf_v1_0_gen_type_cbs video_out S_AXIS_VIDEO_FORMAT "" $v_osd_v6_0_type_map "" Data_Channel_Width "" "" HAS_AXI4_LITE



