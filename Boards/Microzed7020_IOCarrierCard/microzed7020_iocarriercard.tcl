#add in proc for each board?
proc avnet_create_project {project scriptdir} {

   create_project $project $scriptdir/../Projects/$project -part xc7z020clg400-1 -force
   # add selection for proper xdc based on needs
   # if IO carrier, then use that xdc
   # if FMC, choose that one
   add_files -fileset constrs_1 -norecurse $scriptdir/../Boards/Microzed7020_IOCarrierCard/microzed_io_carrier_pmod_ali3.xdc

}

proc avnet_add_ps {project scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.3 processing_system7_0
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" }  [get_bd_cells processing_system7_0]

}
