proc make_ip {ip_name} {

   # Collect the names of the HDL source files that are used by this IP here.
   set file_list [list  "hdl/vhdl/led_mgr.vhd" ]
   
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
   set_property name {microphone_mgr} [ipx::current_core]
   set_property version {1.0} [ipx::current_core]
   set_property display_name {Input Signal microphone_mgr} [ipx::current_core]
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
   ipx::add_file misc/avnet_logo.png [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]
   set_property type LOGO [ipx::get_files misc/avnet_logo.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
   set_property is_include false [ipx::get_files misc/avnet_logo.png -of_objects [ipx::get_file_groups xilinx_utilityxitfiles -of_objects [ipx::current_core]]]
   
   # Generate the XGUI files to accompany this IP core.
   ipx::create_xgui_files [ipx::current_core]
   
   # Save the IP core.
   ipx::save_core [ipx::current_core]
   
   # Close the current project.
   close_project
}
