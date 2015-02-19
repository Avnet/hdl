proc make_ip {ip_name} {
   set file_list [list  "sck_logic.vhd" \
                        "spi_interface.vhd" \
                        "spi_rcv_shift_reg.vhd" \
                        "spi_xmit_shift_reg.vhd" \
                        "upcnt5.vhd" ]
   create_project $ip_name . -force
   set proj_dir [get_property directory [current_project]]
   set proj_name [get_projects $ip_name]
   set proj_fileset [get_filesets sources_1]
   add_files -norecurse -scan_for_includes -fileset $proj_fileset $file_list
   set_property "top" "$ip_name" $proj_fileset
   ipx::package_project -root_dir .
   set_property vendor {Avnet.com} [ipx::current_core]
   set_property library {interface} [ipx::current_core]
   set_property name {pl_spi_engine_v1_0} [ipx::current_core]
   set_property version {1.0} [ipx::current_core]
   set_property display_name {PL Spi Engine} [ipx::current_core]
   set_property vendor_display_name {Avnet} [ipx::current_core]
   set_property company_url {http://em.avnet.com} [ipx::current_core]
   set_property taxonomy {{/BaseIP}} [ipx::current_core]
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
   ipx::save_core [ipx::current_core]
   close_project
}