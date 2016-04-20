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
#  Please direct any questions to the PicoZed community support forum:
#     http://www.picozed.org/forum
# 
#  Product information is available at:
#     http://www.picozed.org/product/picozed
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2016 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         Apr 19, 2016
#  Design Name:         PicoZed FMC2 Carrier Factory Acceptance Test
#  Module Name:         hdmi_720p.tcl
#  Project Name:        PicoZed FMC2 Carrier Factory Acceptance Test
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed, PicoZed FMC2 Carrier
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         IPI script to generate the hdmi_720p IP from source.
# 
#  Dependencies:        make.tcl
#
#  Revision:            Apr 19, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

proc make_ip {ip_name} {

   # Collect the names of the HDL source files that are used by this IP here.
   set file_list [list  "hdl/vhdl/adv7511_embed_syncs.vhd" \
						"hdl/vhdl/colour_space_conversion.vhd" \
						"hdl/vhdl/convert_444_422.vhd" \
						"hdl/vhdl/hdmi.vhd" \
						"hdl/vhdl/hdmi_ddr_output.vhd" \
						"hdl/vhdl/video_generator.vhd" ]
   
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
   set_property name {hdmi_720p} [ipx::current_core]
   set_property version {1.0} [ipx::current_core]
   set_property display_name {HDMI 720p Test Pattern} [ipx::current_core]
   set_property vendor_display_name {Avnet} [ipx::current_core]
   set_property company_url {http://em.avnet.com} [ipx::current_core]
   set_property taxonomy {{/FPGA_Features_and_Design/IO_Interfaces}} [ipx::current_core]
   set_property supported_families {{virtex7} {Pre-Production}\
                                    {qzynq} {Pre-Production}\
                                    {qvirtex7} {Pre-Production}\
                                    {qkintex7l} {Pre-Production}\
                                    {qkintex7} {Pre-Production}\
                                    {qartix7} {Pre-Production}\
                                    {kintex7l} {Pre-Production}\
                                    {kintex7} {Pre-Production}\
                                    {azynq} {Pre-Production}\
                                    {artix7l} {Pre-Production}\
                                    {aartix7} {Pre-Production}\
                                    {artix7} {Pre-Production}\
                                    {zynq} {Production}} [ipx::current_core]

   # Set the File Groups for this IP core.
   ipx::add_file_group -type utility xilinx_utilityxitfiles [ipx::current_core]
   ipx::add_file misc/AVNET_EM_sRGB_150x53px.png [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]
   set_property type LOGO [ipx::get_files misc/AVNET_EM_sRGB_150x53px.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
   set_property is_include false [ipx::get_files misc/AVNET_EM_sRGB_150x53px.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
     
   # Generate the XGUI files to accompany this IP core.
   ipx::create_xgui_files [ipx::current_core]
   
   # Save the IP core.
   ipx::save_core [ipx::current_core]
   
   # Close the current project.
   close_project
}
