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
#                      Copyright(c) 2015 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------
# 
#  Create Date:         May 2, 2017
#  Design Name:         MiniZed with microphone
#  Module Name:         minized_mic.xdc
#  Project Name:        MiniZed with microphone
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     MiniZed
# 
#  Tool versions:       Xilinx Vivado 2017.1
# 
#  Description:         Timing constraints used for adding microphone support to MiniZed
# 
#  Dependencies:        
#
#  Revision:            May 2, 2017: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#
# MiniZed with microphone Timing Constraints
#

##################
# Primary Clocks #
##################

# The following constraints are already created by the "ZYNQ7 Processing System" core
#create_clock -period 20 -name clk_fpga_0 [get_nets -hierarchical FCLK_CLK0]
#create_clock -period <TBD> -name clk_fpga_1 [get_nets -hierarchical FCLK_CLK1]
#create_clock -period 6.25 -name clk_fpga_2 [get_nets -hierarchical FCLK_CLK2]
	# 160 MHz clock domain for signal processing with 64X decimation to 2.5 MSPS sampling rate of PDM mic
	# Allows MAC-based polyphase decimation low-pass FIR with single DSP48

####################
# Generated Clocks #
####################

# Rename auto-generated clocks from MMCM
create_generated_clock -name <TBD> [get_pins <TBD>/clk_wiz_0/U0/mmcm_adv_inst/CLKOUT0]

################
# Clock Groups #
################

set_clock_groups -asynchronous -group [get_clocks "clk_fpga_0" ] -group [get_clocks "clk_fpga_2" ]
# ->->->-> ensure multi-cycle path exception for mic IP with 64X over-clock

