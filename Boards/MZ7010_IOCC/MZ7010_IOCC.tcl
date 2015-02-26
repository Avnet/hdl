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
#  Please direct any questions or issues to the MicroZed Community Forums:
#      http://www.microzed.org
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2014 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         December 02, 2014
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      Zynq-7010
#  Hardware Boards:     MicroZed, IO Carrier
# 
#  Tool versions:       Vivado 2014.4
# 
#  Description:         Build Script for MicroZed IO Carrier
# 
#  Dependencies:        To be called from a project build script
# 
# ----------------------------------------------------------------------------

proc avnet_create_project {project projects_folder scriptdir} {

   create_project $project $projects_folder -part xc7z010clg400-1 -force
   # add selection for proper xdc based on needs
   # if IO carrier, then use that xdc
   # if FMC, choose that one
   add_files -fileset constrs_1 -norecurse $scriptdir/../Boards/MZ7010_IOCC/design_1_wrapper.xdc

}

proc avnet_add_ps {project projects_folder scriptdir} {

   # add selection for customization depending on board choice (or none)
   create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
   apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" }  [get_bd_cells processing_system7_0]
   set M_AXI_GP0_ACLK [ create_bd_port -dir I -type clk M_AXI_GP0_ACLK ]
   connect_bd_net -net M_AXI_GP0_ACLK_1 [get_bd_ports M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]

}
