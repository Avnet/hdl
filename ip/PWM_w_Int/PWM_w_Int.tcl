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
#  Please direct any questions to the MiniZed community support forum:
#     http://www.minized.org/forum
# 
#  Product information is available at:
#     http://www.minized.org/product/minized
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
#  Create Date:         Jan 06, 2017
#  Design Name:         Pulse Width Modulator with Interrupt
#  Module Name:         PWM_w_Int.tcl
#  Project Name:        MiniZed
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Xilinx Vivado 2017.1
# 
#  Description:         IPI script to generate the PWM_w_Int IP from source.
# 
#  Dependencies:        make.tcl
#
#  Revision:            Jan 06, 2017: 1.00 Initial version
#                       Aug 14, 2017: 1.01 Updated Avnet logo
#                       Jan 08, 2018: 1.02 Updated to latest SpeedWay source
#                                          code files
# 
# ----------------------------------------------------------------------------

proc make_ip {ip_name} {

   # Collect the names of the HDL source files that are used by this IP here.
   set file_list [list  "hdl/verilog/PWM_Controller_Int.v" \
                  "hdl/vhdl/PWM_w_Int.vhd" \
                  "hdl/vhdl/PWM_w_Int_S00_AXI.vhd" ]
   
   # Create a new Vivado project for this IP and add the source files.
   create_project $ip_name . -force
   set proj_dir [get_property directory [current_project]]
   set proj_name [get_projects $ip_name]
   set proj_fileset [get_filesets sources_1]
   add_files -norecurse -scan_for_includes -fileset $proj_fileset $file_list
   set_property "top" "$ip_name" $proj_fileset
   ipx::package_project -root_dir .
   
   # Set the IP core information properties.
   set_property vendor {avnet.com} [ipx::current_core]
   set_property library {ip} [ipx::current_core]
   set_property name {PWM_w_Int} [ipx::current_core]
   set_property version {1.0} [ipx::current_core]
   set_property display_name {PWM_w_Int} [ipx::current_core]
   set_property description {PWM with Interrupt option} [ipx::current_core]
   set_property vendor_display_name {Avnet} [ipx::current_core]
   set_property company_url {http://avnet.com} [ipx::current_core]
   set_property taxonomy {{/FPGA_Features_and_Design/IO_Interfaces}} [ipx::current_core]
   set_property supported_families { \
                                    {qzynq} {Pre-Production}\
                                    {qkintex7l} {Pre-Production}\
                                    {qkintex7} {Pre-Production}\
                                    {qartix7} {Pre-Production}\
                                    {kintex7l} {Pre-Production}\
                                    {kintex7} {Pre-Production}\
                                    {azynq} {Pre-Production}\
                                    {artix7l} {Pre-Production}\
                                    {aartix7} {Pre-Production}\
                                    {artix7} {Pre-Production}\
                                    {zynq} {Production}\
                           {ZYNQUPLUS} {Production}} [ipx::current_core]

   # Set the File Groups for this IP core.
   ipx::add_file_group -type utility xilinx_utilityxitfiles [ipx::current_core]
   ipx::add_file misc/avnet_logo.png [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]
   set_property type LOGO [ipx::get_files misc/avnet_logo.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
   set_property is_include false [ipx::get_files misc/avnet_logo.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
   
   # Create the port map assignments for this IP core.
   ipx::add_ports_from_hdl [ipx::current_core] -top_level_hdl_file hdl/vhdl/PWM_w_Int.vhd -top_module_name PWM_w_Int
   ipx::infer_bus_interface Interrupt_out xilinx.com:signal:interrupt_rtl:1.0 [ipx::current_core]
   
   # Generate the XGUI files to accompany this IP core.
   ipx::create_xgui_files [ipx::current_core]
   
   # Save the IP core.
   ipx::save_core [ipx::current_core]
   
   # Close the current project.
   close_project
}
