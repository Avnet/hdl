proc make_ip {ip_name} {

   # Collect the names of the HDL source files that are used by this IP here.
   set file_list [list  "hdl/verilog/timing.v" \
                        "hdl/vhdl/vtiming_gen.vhd" ]
   
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
   set_property name {vtiming_gen} [ipx::current_core]
   set_property version {1.6} [ipx::current_core]
   set_property display_name {Static Video Timing Generator} [ipx::current_core]
   set_property vendor_display_name {Avnet} [ipx::current_core]
   set_property company_url {http://em.avnet.com} [ipx::current_core]
   set_property taxonomy {{/Video_&amp;_Image_Processing}} [ipx::current_core]
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
   
   # Set the Customization Parameters for this IP core.
   ipx::add_user_parameter C_DEBUG_PORT [ipx::current_core]
   set_property value_resolve_type user [ipx::get_user_parameters C_DEBUG_PORT -of_objects [ipx::current_core]]
   set_property display_name {Enable Debug Port} [ipx::get_user_parameters C_DEBUG_PORT -of_objects [ipx::current_core]]
   set_property value false [ipx::get_user_parameters C_DEBUG_PORT -of_objects [ipx::current_core]]
   set_property value_format bool [ipx::get_user_parameters C_DEBUG_PORT -of_objects [ipx::current_core]]
   
   ipx::add_user_parameter C_VIDEO_RESOLUTION [ipx::current_core]
   set_property value_resolve_type user [ipx::get_user_parameters C_VIDEO_RESOLUTION -of_objects [ipx::current_core]]
   
   # Assign the bus interfaces used for this IP core.
   ipx::add_bus_interface {VTIMING} [ipx::current_core]
   set_property interface_mode {master} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property display_name {VTIMING} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property description {Video Timing Reference} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property abstraction_type_vlnv {xilinx.com:interface:video_timing_rtl:2.0} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property bus_type_vlnv {xilinx.com:interface:video_timing:2.0} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
    
   # Create the port map assignments for this IP core.
   ipx::add_port_map {HSYNC} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property physical_name {hsync_out} [ipx::get_port_maps HSYNC -of_objects [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]]
   ipx::add_port_map {VSYNC} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property physical_name {vsync_out} [ipx::get_port_maps VSYNC -of_objects [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]]
   ipx::add_port_map {HBLANK} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property physical_name {hblank_out} [ipx::get_port_maps HBLANK -of_objects [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]]
   ipx::add_port_map {VBLANK} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property physical_name {vblank_out} [ipx::get_port_maps VBLANK -of_objects [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]]
   ipx::add_port_map {ACTIVE_VIDEO} [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]
   set_property physical_name {active_video_out} [ipx::get_port_maps ACTIVE_VIDEO -of_objects [ipx::get_bus_interfaces VTIMING -of_objects [ipx::current_core]]]
   
   # Setup the Customization GUI for this IP core.
   ipgui::add_param -name {C_DEBUG_PORT} -component [ipx::current_core] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core] ] -display_name {C_DEBUG_PORT}
   set_property tooltip {Enable Debug Port} [ipgui::get_guiparamspec -name "C_DEBUG_PORT" -component [ipx::current_core] ]
   
   ipgui::add_param -name {C_VIDEO_RESOLUTION} -component [ipx::current_core] -parent [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core] ] -display_name {C_VIDEO_RESOLUTION}
   set_property tooltip {Select resolution of the targeted display panel} [ipgui::get_guiparamspec -name "C_VIDEO_RESOLUTION" -component [ipx::current_core] ]
   set_property widget {comboBox} [ipgui::get_guiparamspec -name "C_VIDEO_RESOLUTION" -component [ipx::current_core] ]
   set_property value_validation_type pairs [ipx::get_user_parameters C_VIDEO_RESOLUTION -of_objects [ipx::current_core]]
   set_property value_validation_pairs {640x480 0 800x480 1 800x600 2 1024x768 3 1280x720 4 1280x1024 5 1024x600 6 1280x800 7} [ipx::get_user_parameters C_VIDEO_RESOLUTION -of_objects [ipx::current_core]]
   
   # Generate the XGUI files to accompany this IP core.
   ipx::create_xgui_files [ipx::current_core]
   
   # Save the IP core.
   ipx::save_core [ipx::current_core]
   
   # Close the current project.
   close_project
}