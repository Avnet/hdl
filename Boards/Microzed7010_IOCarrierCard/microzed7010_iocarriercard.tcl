proc avnet_create_project {project scriptdir} {

   create_project $project $scriptdir/../Projects/$project -part xc7z010clg400-1 -force
   # add selection for proper xdc based on needs
   # if IO carrier, then use that xdc
   # if FMC, choose that one
   add_files -fileset constrs_1 -norecurse $scriptdir/../Boards/Microzed7010_IOCarrierCard/design_1_wrapper.xdc

}

proc avnet_add_ps {project scriptdir} {

   # add selection for customization depending on board choice (or none)
   # 2013.4 create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.3 processing_system7_0
   create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" }  [get_bd_cells processing_system7_0]
   set M_AXI_GP0_ACLK [ create_bd_port -dir I -type clk M_AXI_GP0_ACLK ]
   connect_bd_net -net M_AXI_GP0_ACLK_1 [get_bd_ports M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]

}
