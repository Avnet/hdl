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
#                      Copyright(c) 2015 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         February 01, 2016
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     Show Eye Diagrams for IBERT
# 
#  Tool versions:       Vivado 2015.2.1
# 
#  Description:         Show Eye Diagrams for IBERT
# 
#  Dependencies:        To be called from TCL Command AFTER IBERT is running successfully
# 
# ----------------------------------------------------------------------------

set xil_newScan [create_hw_sio_scan -description {Scan 0} 2d_full_eye  [lindex [get_hw_sio_links localhost:3121/xilinx_tcf/Digilent/210249854250/1_1/IBERT/Quad_112/MGT_X0Y1/TX->localhost:3121/xilinx_tcf/Digilent/210249854250/1_1/IBERT/Quad_112/MGT_X0Y1/RX] 0 ]]
set_property HORIZONTAL_INCREMENT {5} [get_hw_sio_scans $xil_newScan]
set_property VERTICAL_INCREMENT {5} [get_hw_sio_scans $xil_newScan]

set xil_newScan2 [create_hw_sio_scan -description {Scan 1} 2d_full_eye  [lindex [get_hw_sio_links localhost:3121/xilinx_tcf/Digilent/210249854250/1_1/IBERT/Quad_112/MGT_X0Y2/TX->localhost:3121/xilinx_tcf/Digilent/210249854250/1_1/IBERT/Quad_112/MGT_X0Y2/RX] 0 ]]
set_property HORIZONTAL_INCREMENT {5} [get_hw_sio_scans $xil_newScan2]
set_property VERTICAL_INCREMENT {5} [get_hw_sio_scans $xil_newScan2]

set xil_newScan3 [create_hw_sio_scan -description {Scan 2} 2d_full_eye  [lindex [get_hw_sio_links localhost:3121/xilinx_tcf/Digilent/210249854250/1_1/IBERT/Quad_112/MGT_X0Y3/TX->localhost:3121/xilinx_tcf/Digilent/210249854250/1_1/IBERT/Quad_112/MGT_X0Y3/RX] 0 ]]
set_property HORIZONTAL_INCREMENT {5} [get_hw_sio_scans $xil_newScan3]
set_property VERTICAL_INCREMENT {5} [get_hw_sio_scans $xil_newScan3]
run_hw_sio_scan [get_hw_sio_scans $xil_newScan]
after 5000
run_hw_sio_scan [get_hw_sio_scans $xil_newScan3]
after 5000
run_hw_sio_scan [get_hw_sio_scans $xil_newScan2]

display_hw_sio_scan [get_hw_sio_scans {SCAN_0}]