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
#  Create Date:         November 16, 2015
#  Design Name:         
#  Module Name:         
#  Project Name:        
#  Target Devices:      
#  Hardware Boards:     MicroZed Preset Configuration
# 
#  Tool versions:       Vivado 2015.2
# 
#  Description:         Configuration Preset for MicroZed SOM
# 
#  Dependencies:        To be called from a project script
#                       After instantiation of processing_system_ps7 module
# 
# ----------------------------------------------------------------------------

set processing_system7_0 [get_bd_cells processing_system7_0]
set_property -dict [ list CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
	CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
	CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
	CONFIG.PCW_ENET_RESET_ENABLE {0} \
	CONFIG.PCW_EN_CLK0_PORT {0} \
	CONFIG.PCW_EN_CLK1_PORT {0} \
	CONFIG.PCW_EN_CLK2_PORT {0} \
	CONFIG.PCW_EN_CLK3_PORT {0} \
	CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
	CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} \
	CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {25} \
	CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
	CONFIG.PCW_I2C_RESET_ENABLE {0} \
	CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
	CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
	CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
	CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
	CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
	CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
	CONFIG.PCW_SD0_GRP_WP_IO {MIO 50} \
	CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
	CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
	CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
	CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {.294} \
	CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {.298} \
	CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {.338} \
	CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {.334} \
	CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
	CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
	CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
	CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
	CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
	CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
	CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
	CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
	CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
	CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
	CONFIG.PCW_USB_RESET_ENABLE {1} \
	CONFIG.PCW_USB0_RESET_ENABLE {1} \
	CONFIG.PCW_USB0_RESET_IO {MIO 7} \
	CONFIG.PCW_USE_M_AXI_GP0 {1} \
	] $processing_system7_0
	# Override any of the basic PS7 settings made above with the settings that
	# are specific to the demands of this project.
	set_property -dict [ list CONFIG.PCW_EN_CLK1_PORT {1} \
	CONFIG.PCW_EN_CLK0_PORT {1} \
	CONFIG.PCW_EN_CLK1_PORT {1} \
	CONFIG.PCW_EN_CLK2_PORT {1} \
	CONFIG.PCW_EN_RST0_PORT {1} \
	CONFIG.PCW_EN_RST1_PORT {1} \
	CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {75.000} \
	CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} \
	CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {100.000000} \
	CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
	CONFIG.PCW_GPIO_EMIO_GPIO_IO {6} \
	CONFIG.PCW_IRQ_F2P_INTR {1} \
	CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
	CONFIG.PCW_USE_S_AXI_HP0 {1} ] $processing_system7_0

############################################################################
# Configure MIOs
#   - disable all pull-ups
#   - slew set to SLOW
############################################################################
set_property -dict [ list \
	CONFIG.PCW_MIO_0_PULLUP {disabled} \
	CONFIG.PCW_MIO_1_PULLUP {disabled} \
	CONFIG.PCW_MIO_2_PULLUP {disabled} \
	CONFIG.PCW_MIO_3_PULLUP {disabled} \
	CONFIG.PCW_MIO_4_PULLUP {disabled} \
	CONFIG.PCW_MIO_5_PULLUP {disabled} \
	CONFIG.PCW_MIO_6_PULLUP {disabled} \
	CONFIG.PCW_MIO_7_PULLUP {disabled} \
	CONFIG.PCW_MIO_8_PULLUP {disabled} \
	CONFIG.PCW_MIO_9_PULLUP {disabled} \
	CONFIG.PCW_MIO_10_PULLUP {disabled} \
	CONFIG.PCW_MIO_11_PULLUP {disabled} \
	CONFIG.PCW_MIO_12_PULLUP {disabled} \
	CONFIG.PCW_MIO_13_PULLUP {disabled} \
	CONFIG.PCW_MIO_14_PULLUP {disabled} \
	CONFIG.PCW_MIO_15_PULLUP {disabled} \
	CONFIG.PCW_MIO_16_PULLUP {disabled} \
	CONFIG.PCW_MIO_17_PULLUP {disabled} \
	CONFIG.PCW_MIO_18_PULLUP {disabled} \
	CONFIG.PCW_MIO_19_PULLUP {disabled} \
	CONFIG.PCW_MIO_20_PULLUP {disabled} \
	CONFIG.PCW_MIO_21_PULLUP {disabled} \
	CONFIG.PCW_MIO_22_PULLUP {disabled} \
	CONFIG.PCW_MIO_23_PULLUP {disabled} \
	CONFIG.PCW_MIO_24_PULLUP {disabled} \
	CONFIG.PCW_MIO_25_PULLUP {disabled} \
	CONFIG.PCW_MIO_26_PULLUP {disabled} \
	CONFIG.PCW_MIO_27_PULLUP {disabled} \
	CONFIG.PCW_MIO_28_PULLUP {disabled} \
	CONFIG.PCW_MIO_29_PULLUP {disabled} \
	CONFIG.PCW_MIO_30_PULLUP {disabled} \
	CONFIG.PCW_MIO_31_PULLUP {disabled} \
	CONFIG.PCW_MIO_32_PULLUP {disabled} \
	CONFIG.PCW_MIO_33_PULLUP {disabled} \
	CONFIG.PCW_MIO_34_PULLUP {disabled} \
	CONFIG.PCW_MIO_35_PULLUP {disabled} \
	CONFIG.PCW_MIO_36_PULLUP {disabled} \
	CONFIG.PCW_MIO_37_PULLUP {disabled} \
	CONFIG.PCW_MIO_38_PULLUP {disabled} \
	CONFIG.PCW_MIO_39_PULLUP {disabled} \
	CONFIG.PCW_MIO_40_PULLUP {disabled} \
	CONFIG.PCW_MIO_41_PULLUP {disabled} \
	CONFIG.PCW_MIO_42_PULLUP {disabled} \
	CONFIG.PCW_MIO_43_PULLUP {disabled} \
	CONFIG.PCW_MIO_44_PULLUP {disabled} \
	CONFIG.PCW_MIO_45_PULLUP {disabled} \
	CONFIG.PCW_MIO_46_PULLUP {disabled} \
	CONFIG.PCW_MIO_47_PULLUP {disabled} \
	CONFIG.PCW_MIO_48_PULLUP {disabled} \
	CONFIG.PCW_MIO_49_PULLUP {disabled} \
	CONFIG.PCW_MIO_50_PULLUP {disabled} \
	CONFIG.PCW_MIO_51_PULLUP {disabled} \
	CONFIG.PCW_MIO_52_PULLUP {disabled} \
	CONFIG.PCW_MIO_53_PULLUP {disabled} \
	CONFIG.PCW_MIO_0_SLEW {slow} \
	CONFIG.PCW_MIO_1_SLEW {slow} \
	CONFIG.PCW_MIO_2_SLEW {slow} \
	CONFIG.PCW_MIO_3_SLEW {slow} \
	CONFIG.PCW_MIO_4_SLEW {slow} \
	CONFIG.PCW_MIO_5_SLEW {slow} \
	CONFIG.PCW_MIO_6_SLEW {slow} \
	CONFIG.PCW_MIO_7_SLEW {slow} \
	CONFIG.PCW_MIO_8_SLEW {slow} \
	CONFIG.PCW_MIO_9_SLEW {slow} \
	CONFIG.PCW_MIO_10_SLEW {slow} \
	CONFIG.PCW_MIO_11_SLEW {slow} \
	CONFIG.PCW_MIO_12_SLEW {slow} \
	CONFIG.PCW_MIO_13_SLEW {slow} \
	CONFIG.PCW_MIO_14_SLEW {slow} \
	CONFIG.PCW_MIO_15_SLEW {slow} \
	CONFIG.PCW_MIO_16_SLEW {slow} \
	CONFIG.PCW_MIO_17_SLEW {slow} \
	CONFIG.PCW_MIO_18_SLEW {slow} \
	CONFIG.PCW_MIO_19_SLEW {slow} \
	CONFIG.PCW_MIO_20_SLEW {slow} \
	CONFIG.PCW_MIO_21_SLEW {slow} \
	CONFIG.PCW_MIO_22_SLEW {slow} \
	CONFIG.PCW_MIO_23_SLEW {slow} \
	CONFIG.PCW_MIO_24_SLEW {slow} \
	CONFIG.PCW_MIO_25_SLEW {slow} \
	CONFIG.PCW_MIO_26_SLEW {slow} \
	CONFIG.PCW_MIO_27_SLEW {slow} \
	CONFIG.PCW_MIO_28_SLEW {slow} \
	CONFIG.PCW_MIO_29_SLEW {slow} \
	CONFIG.PCW_MIO_30_SLEW {slow} \
	CONFIG.PCW_MIO_31_SLEW {slow} \
	CONFIG.PCW_MIO_32_SLEW {slow} \
	CONFIG.PCW_MIO_33_SLEW {slow} \
	CONFIG.PCW_MIO_34_SLEW {slow} \
	CONFIG.PCW_MIO_35_SLEW {slow} \
	CONFIG.PCW_MIO_36_SLEW {slow} \
	CONFIG.PCW_MIO_37_SLEW {slow} \
	CONFIG.PCW_MIO_38_SLEW {slow} \
	CONFIG.PCW_MIO_39_SLEW {slow} \
	CONFIG.PCW_MIO_40_SLEW {slow} \
	CONFIG.PCW_MIO_41_SLEW {slow} \
	CONFIG.PCW_MIO_42_SLEW {slow} \
	CONFIG.PCW_MIO_43_SLEW {slow} \
	CONFIG.PCW_MIO_44_SLEW {slow} \
	CONFIG.PCW_MIO_45_SLEW {slow} \
	CONFIG.PCW_MIO_46_SLEW {slow} \
	CONFIG.PCW_MIO_47_SLEW {slow} \
	CONFIG.PCW_MIO_48_SLEW {slow} \
	CONFIG.PCW_MIO_49_SLEW {slow} \
	CONFIG.PCW_MIO_50_SLEW {slow} \
	CONFIG.PCW_MIO_51_SLEW {slow} \
	CONFIG.PCW_MIO_52_SLEW {slow} \
	CONFIG.PCW_MIO_53_SLEW {slow} \
	] $processing_system7_0
