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
#  Create Date:         June 22, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     PicoZed SDR SOM + PYTHON-1300-C Camera
# 
#  Tool versions:       Vivado 2014.4
# 
#  Description:         Build Script for PicoZed SDR SOM + PYTHON-1300-C Camera
# 
#  Dependencies:        make.tcl
# 
# ----------------------------------------------------------------------------

# Build PYTHON-1300-C Getting Started design for the PicoZed SDR SOM + FMC Carrier Card
set argv [list board=PZSDR7035_FMCCC project=pzsdr_p13c sdk=yes version_override=yes]
set argc [llength $argv]
source ./make.tcl -notrace


