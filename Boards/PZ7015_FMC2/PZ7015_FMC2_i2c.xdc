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
#  Create Date:         Apr 18, 2016
#  Design Name:         PicoZed FMC2 I2C
#  Module Name:         PZ7015_FMC2_i2c.xdc
#  Project Name:        PicoZed FMC2 I2C
#  Target Devices:      Xilinx Zynq-7000
#  Hardware Boards:     PicoZed, PicoZed FMC2 Carrier
# 
#  Tool versions:       Xilinx Vivado 2015.2
# 
#  Description:         I/O Constraints used for implementing I2C interface 
#                       on a PicoZed FMC2 design.
# 
#  Dependencies:        
#
#  Revision:            Apr 18, 2016: 1.00 Initial version
# 
# ----------------------------------------------------------------------------

#
# PicoZed with FMC Carrier 2 - I2C I/O constraints
#

# PicoZed FMC Carrier Card Gen2 Pinout - 7015

# ----------------------------------------------------------------------------
# I2C Peripherals - RTC, EEPROM, Clock Generator, HDMI Output - Bank 34
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN H6 [get_ports {hdmi_i2c_scl_io     }];  # "H6.JX1_SE_0.JX1.9.HDMIO_SCL"
set_property PACKAGE_PIN H5 [get_ports {hdmi_i2c_sda_io     }];  # "H5.JX1_SE_1.JX1.10.HDMIO_SDA"

set_property IOSTANDARD LVCMOS18 [get_ports hdmi_*]
