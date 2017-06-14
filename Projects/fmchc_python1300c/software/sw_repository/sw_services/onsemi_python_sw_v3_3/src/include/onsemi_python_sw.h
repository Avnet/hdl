// ----------------------------------------------------------------------------
//  
//        ** **        **          **  ****      **  **********  ********** ® 
//       **   **        **        **   ** **     **  **              ** 
//      **     **        **      **    **  **    **  **              ** 
//     **       **        **    **     **   **   **  *********       ** 
//    **         **        **  **      **    **  **  **              ** 
//   **           **        ****       **     ** **  **              ** 
//  **  .........  **        **        **      ****  **********      ** 
//     ........... 
//                                     Reach Further™ 
//  
// ----------------------------------------------------------------------------
// 
// This design is the property of Avnet.  Publication of this 
// design is not authorized without written consent from Avnet. 
// 
// Please direct any questions to the PicoZed community support forum: 
//    http://www.zedboard.org/forum 
// 
// Disclaimer: 
//    Avnet, Inc. makes no warranty for the use of this code or design. 
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
//    any errors, which may appear in this code, nor does it make a commitment 
//    to update the information contained herein. Avnet, Inc specifically 
//    disclaims any implied warranties of fitness for a particular purpose. 
//                     Copyright(c) 2017 Avnet, Inc. 
//                             All rights reserved. 
// 
// ----------------------------------------------------------------------------
//
// Create Date:         Sep 19, 2011
// Design Name:         ON Semiconductor VITA Receiver
// Module Name:         onsemi_vita_sw.h
// Project Name:        ON Semiconductor VITA Receiver
// Target Devices:      Spartan-6, Virtex-6, Kintex-7, Zynq-7000
// Avnet Boards:        FMC-IMAGEON
//
// Tool versions:       Vivado 2014.4
//
// Description:         VITA Software Library.
//                      Initial version generated with EDK Create Peripheral Wizard
//                      - contained generic macros to access 32 registers
//                      Driver modified to add:
//                      - Data structure for driver context
//                      - Init routine
//                      - SPI Read routine
//                      - SPI Write routine
//
// Dependencies:        
//
// Revision:            Sep 15, 2011: 1.00 Initial version:
//                                         - VITA SPI controller 
//                      Sep 22, 2011: 1.01 Added:
//                                         - ISERDES interface
//                      Sep 28, 2011: 1.02 Added:
//                                         - sync channel decoder
//                                         - crc checker
//                                         - data remapper
//                      Oct 20, 2011: 1.03 Modify:
//                                         - iserdes (use BUFR)
//                      Oct 21, 2011: 1.04 Added:
//                                         - fpn prnu correction
//                      Nov 03, 2011: 1.05 Added:
//                                         - trigger generator
//                      Dec 19, 2011: 1.06 Modified:
//                                         - port to Kintex-7
//                      Feb 09, 2011: 1.08 Add VITA configuration functions
//                                         - init
//                                         - get_status
//                                         - set_exposure
//                                         - set_analog_gain
//                                         - set_digital_gain
//                      Jun 01, 2012: 1.12 Change syncgen configuration code
//                      Dec 17, 2013: 2.01 Port to Vivado 2013.3
//----------------------------------------------------------------
//                      Jan 29, 2015: 3.1  Rename to onsemi_vita_sw
//                                         Now uses two cores:
//                                         - onsemi_vita_spi
//                                         - onsemi_vita_cam
//                      Feb 23, 2015: 3.1  Add core_version/core_id registers
//                      Jul 09, 2015: 3.2  Change sensor's sample point to fix
//                                         sampling issue (intermittent across different hw)
//                      Nov 17, 2015: 3.3  Update driver 
//                                         - Update code to detect PYTHON-1300 image sensor
//                                         - Update init sequence to resolve intermittent issues
//                                            - Reset the camera receiver before starting the sensor 
//                                            - Move start of capture to new SENSOR_INIT_STREAMON sequence
//                                              (corresponds to linux V4L VIDIOC_STREAMON)
//----------------------------------------------------------------

#ifndef ONSEMI_PYTHON_SW_H
#define ONSEMI_PYTHON_SW_H

// Definitions to reuse VITA defines/functions for PYTHON receiver
#define onsemi_python_t	onsemi_vita_t
#define onsemi_python_status_t onsemi_vita_status_t

#define onsemi_python_init                  onsemi_vita_init
#define onsemi_python_spi_reg_read          onsemi_vita_spi_reg_read
#define onsemi_python_cam_reg_read          onsemi_vita_cam_reg_read
#define onsemi_python_spi_reg_write         onsemi_vita_spi_reg_write
#define onsemi_python_cam_reg_write         onsemi_vita_cam_reg_write
#define onsemi_python_reset                 onsemi_vita_reset
#define onsemi_python_spi_config            onsemi_vita_spi_config
#define onsemi_python_spi_read              onsemi_vita_spi_read
#define onsemi_python_spi_write             onsemi_vita_spi_write
#define onsemi_python_spi_nop               onsemi_vita_spi_nop
#define onsemi_python_spi_write_sequence    onsemi_vita_spi_write_sequence	
#define onsemi_python_spi_display_sequence  onsemi_vita_spi_display_sequence
#define onsemi_python_sensor_initialize     onsemi_vita_sensor_initialize
#define onsemi_python_get_status            onsemi_vita_get_status
#define onsemi_python_sensor_1080P60        onsemi_vita_sensor_1080P60
#define onsemi_python_set_analog_gain       onsemi_vita_set_analog_gain
#define onsemi_python_set_digital_gain      onsemi_vita_set_digital_gain
#define onsemi_python_set_exposure_time     onsemi_vita_set_exposure_time
#define onsemi_python_sensor_initialize     onsemi_vita_sensor_initialize
#define onsemi_python_sensor_cds            onsemi_vita_sensor_cds

#define onsemi_python_	onsemi_vita_

#define ONSEMI_PYTHON_CAM_SYNCGEN_HTIMING1_REG	ONSEMI_VITA_CAM_SYNCGEN_HTIMING1_REG
#define ONSEMI_PYTHON_CAM_SYNCGEN_HTIMING2_REG	ONSEMI_VITA_CAM_SYNCGEN_HTIMING2_REG
#define ONSEMI_PYTHON_CAM_SYNCGEN_VTIMING1_REG	ONSEMI_VITA_CAM_SYNCGEN_VTIMING1_REG
#define ONSEMI_PYTHON_CAM_SYNCGEN_VTIMING2_REG	ONSEMI_VITA_CAM_SYNCGEN_VTIMING2_REG
#define ONSEMI_PYTHON_ 	ONSEMI_VITA_

/***************************** Include Files *******************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xil_io.h"


// ONSEMI_VITA_SPI definitions
#define ONSEMI_VITA_SPI_S00_AXI_SLV_REG0_OFFSET 0
#define ONSEMI_VITA_SPI_S00_AXI_SLV_REG1_OFFSET 4
#define ONSEMI_VITA_SPI_S00_AXI_SLV_REG2_OFFSET 8
#define ONSEMI_VITA_SPI_S00_AXI_SLV_REG3_OFFSET 12

// ONSEMI_VITA_CAM definitions
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG0_OFFSET 0
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG1_OFFSET 4
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG2_OFFSET 8
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG3_OFFSET 12
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG4_OFFSET 16
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG5_OFFSET 20
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG6_OFFSET 24
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG7_OFFSET 28
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG8_OFFSET 32
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG9_OFFSET 36
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG10_OFFSET 40
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG11_OFFSET 44
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG12_OFFSET 48
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG13_OFFSET 52
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG14_OFFSET 56
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG15_OFFSET 60
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG16_OFFSET 64
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG17_OFFSET 68
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG18_OFFSET 72
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG19_OFFSET 76
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG20_OFFSET 80
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG21_OFFSET 84
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG22_OFFSET 88
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG23_OFFSET 92
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG24_OFFSET 96
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG25_OFFSET 100
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG26_OFFSET 104
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG27_OFFSET 108
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG28_OFFSET 112
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG29_OFFSET 116
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG30_OFFSET 120
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG31_OFFSET 124
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG32_OFFSET 128
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG33_OFFSET 132
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG34_OFFSET 136
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG35_OFFSET 140
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG36_OFFSET 144
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG37_OFFSET 148
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG38_OFFSET 152
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG39_OFFSET 156
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG40_OFFSET 160
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG41_OFFSET 164
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG42_OFFSET 168
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG43_OFFSET 172
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG44_OFFSET 176
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG45_OFFSET 180
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG46_OFFSET 184
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG47_OFFSET 188
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG48_OFFSET 192
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG49_OFFSET 196
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG50_OFFSET 200
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG51_OFFSET 204
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG52_OFFSET 208
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG53_OFFSET 212
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG54_OFFSET 216
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG55_OFFSET 220
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG56_OFFSET 224
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG57_OFFSET 228
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG58_OFFSET 232
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG59_OFFSET 236
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG60_OFFSET 240
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG61_OFFSET 244
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG62_OFFSET 248
#define ONSEMI_VITA_CAM_S00_AXI_SLV_REG63_OFFSET 252

/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a ONSEMI_VITA_SPI/CAM register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the ONSEMI_VITA_SPI/CAM core.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void ONSEMI_VITA_SPI/CAM_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define ONSEMI_VITA_SPI_mWriteReg(BaseAddress, RegOffset, Data) \
 	Xil_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))
#define ONSEMI_VITA_CAM_mWriteReg(BaseAddress, RegOffset, Data) \
 	Xil_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a ONSEMI_VITA_SPI/CAM register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the ONSEMI_VITA_SPI/CAM core.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 ONSEMI_VITA_SPI/CAM_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define ONSEMI_VITA_SPI_mReadReg(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadReg(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read 32 bit value to/from ONSEMI_VITA_SPI/CAM user logic slave registers.
 *
 * @param   BaseAddress is the base address of the ONSEMI_VITA_SPI/CAM core.
 * @param   RegOffset is the offset from the slave register to write to or read from.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	void ONSEMI_VITA_SPI/CAM_mWriteSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Value)
 * 	Xuint32 ONSEMI_VITA_SPI/CAM_mReadSlaveRegn(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */

// ONSEMI_VITA_SPI definitions
#define ONSEMI_VITA_SPI_mWriteSlaveReg0(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_SPI_S00_AXI_SLV_REG0_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_SPI_mWriteSlaveReg1(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_SPI_S00_AXI_SLV_REG1_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_SPI_mWriteSlaveReg2(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_SPI_S00_AXI_SLV_REG2_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_SPI_mWriteSlaveReg3(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_SPI_S00_AXI_SLV_REG3_OFFSET) + (RegOffset), (Xuint32)(Value))
//
#define ONSEMI_VITA_SPI_mReadSlaveReg0(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_SPI_S00_AXI_SLV_REG0_OFFSET) + (RegOffset))
#define ONSEMI_VITA_SPI_mReadSlaveReg1(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_SPI_S00_AXI_SLV_REG1_OFFSET) + (RegOffset))
#define ONSEMI_VITA_SPI_mReadSlaveReg2(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_SPI_S00_AXI_SLV_REG2_OFFSET) + (RegOffset))
#define ONSEMI_VITA_SPI_mReadSlaveReg3(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_SPI_S00_AXI_SLV_REG3_OFFSET) + (RegOffset))

// ONSEMI_VITA_CAM definitions
#define ONSEMI_VITA_CAM_mWriteSlaveReg0(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG0_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg1(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG1_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg2(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG2_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg3(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG3_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg4(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG4_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg5(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG5_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg6(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG6_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg7(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_LV_REG7_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg8(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG8_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg9(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG9_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg10(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG10_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg11(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG11_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg12(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG12_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg13(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG13_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg14(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG14_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg15(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG15_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg16(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG16_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg17(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG17_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg18(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG18_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg19(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG19_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg20(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG20_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg21(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG21_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg22(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG22_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg23(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG23_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg24(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG24_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg25(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG25_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg26(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG26_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg27(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG27_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg28(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG28_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg29(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG29_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg30(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG30_OFFSET) + (RegOffset), (Xuint32)(Value))
#define ONSEMI_VITA_CAM_mWriteSlaveReg31(BaseAddress, RegOffset, Value) \
 	Xil_Out32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG31_OFFSET) + (RegOffset), (Xuint32)(Value))
//
#define ONSEMI_VITA_CAM_mReadSlaveReg0(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG0_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg1(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG1_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg2(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG2_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg3(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG3_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg4(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG4_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg5(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG5_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg6(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG6_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg7(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG7_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg8(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG8_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg9(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG9_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg10(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG10_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg11(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG11_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg12(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG12_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg13(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG13_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg14(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG14_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg15(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG15_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg16(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG16_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg17(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG17_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg18(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG18_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg19(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG19_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg20(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG20_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg21(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG21_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg22(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG22_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg23(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG23_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg24(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG24_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg25(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG25_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg26(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG26_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg27(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG27_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg28(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG28_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg29(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG29_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg30(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG30_OFFSET) + (RegOffset))
#define ONSEMI_VITA_CAM_mReadSlaveReg31(BaseAddress, RegOffset) \
 	Xil_In32((BaseAddress) + (ONSEMI_VITA_CAM_S00_AXI_SLV_REG31_OFFSET) + (RegOffset))

/************************** Function Prototypes ****************************/

/*  Defines the number of registers available for read and write*/
#define ONSEMI_VITA_SPI_USER_NUM_REG            8
#define ONSEMI_VITA_CAM_USER_NUM_REG           64


/*****************************************************************************
*
* User Content Added Here
*
*****************************************************************************/

// ONSEMI_VITA_SPI definitions

#define ONSEMI_VITA_SPI_CORE_VERSION_REG    0x00000000
   #define ONSEMI_VITA_SPI_CORE_VERSION_VAL 0x03030000 // 3.3.0
#define ONSEMI_VITA_SPI_CORE_ID_REG         0x00000004
   #define ONSEMI_VITA_SPI_CORE_ID_VAL      0x4F4E5653 // ASCI for "ONVS"

#define ONSEMI_VITA_SPI_CONTROL_REG         0x00000010
#define ONSEMI_VITA_SPI_STATUS_REG          0x00000010
   #define ONSEMI_VITA_SPI_RESET_BIT        0x00000002
   #define ONSEMI_VITA_SPI_ERROR_BIT        0x00000100
   #define ONSEMI_VITA_SPI_BUSY_BIT         0x00000200
   #define ONSEMI_VITA_SPI_TXFIFO_FULL_BIT  0x00010000
   #define ONSEMI_VITA_SPI_RXFIFO_EMPTY_BIT 0x01000000
#define ONSEMI_VITA_SPI_TIMING_REG          0x00000014
#define ONSEMI_VITA_SPI_TXFIFO_REG          0x00000018
#define ONSEMI_VITA_SPI_RXFIFO_REG          0x0000001C
   #define ONSEMI_VITA_SPI_SYNC2_BIT        0x80000000
   #define ONSEMI_VITA_SPI_SYNC1_BIT        0x40000000
   #define ONSEMI_VITA_SPI_NOP_BIT          0x20000000
   #define ONSEMI_VITA_SPI_READ_BIT         0x10000000
   #define ONSEMI_VITA_SPI_WRITE_BIT        0x00000000

// ONSEMI_VITA_CAM definition

#define ONSEMI_VITA_CAM_CORE_VERSION_REG              0x00000000
   #define ONSEMI_VITA_CAM_CORE_VERSION_VAL           0x03030000 // 3.3.0
#define ONSEMI_VITA_CAM_CORE_ID_REG                   0x00000004
   #define ONSEMI_VITA_CAM_CORE_ID_VAL                0x4F4E5643 // ASCI for "ONVC"
   
#define ONSEMI_VITA_CAM_CONTROL_REG                   0x0000000C
#define ONSEMI_VITA_CAM_STATUS_REG                    0x0000000C
   #define ONSEMI_VITA_CAM_VITA_RESET_BIT             0x00000001

#define ONSEMI_VITA_CAM_ISERDES_CONTROL_REG           0x00000010
   #define ONSEMI_VITA_CAM_ISERDES_RESET_BIT          0x00000001
   #define ONSEMI_VITA_CAM_ISERDES_AUTO_ALIGN_BIT     0x00000002
   #define ONSEMI_VITA_CAM_ISERDES_ALIGN_START_BIT    0x00000004
   #define ONSEMI_VITA_CAM_ISERDES_FIFO_ENABLE_BIT    0x00000008
#define ONSEMI_VITA_CAM_ISERDES_STATUS_REG            0x00000010
#define ONSEMI_VITA_CAM_ISERDES_TRAINING_REG          0x00000014
#define ONSEMI_VITA_CAM_ISERDES_MANUAL_TAP_REG        0x00000018

#define ONSEMI_VITA_CAM_DECODER_CONTROL_REG           0x00000020
   #define ONSEMI_VITA_CAM_DECODER_RESET_BIT          0x00000001
   #define ONSEMI_VITA_CAM_DECODER_ENABLE_BIT         0x00000002
#define ONSEMI_VITA_CAM_DECODER_STARTODDEVEN_REG      0x00000024
#define ONSEMI_VITA_CAM_DECODER_CODES_LS_LE_REG       0x00000028
#define ONSEMI_VITA_CAM_DECODER_CODES_FS_FE_REG       0x0000002C
#define ONSEMI_VITA_CAM_DECODER_CODES_BL_IMG_REG      0x00000030
#define ONSEMI_VITA_CAM_DECODER_CODES_TR_CRC_REG      0x00000034
#define ONSEMI_VITA_CAM_DECODER_CNT_BLACK_LINES_REG   0x00000038
#define ONSEMI_VITA_CAM_DECODER_CNT_IMAGE_LINES_REG   0x0000003C
#define ONSEMI_VITA_CAM_DECODER_CNT_BLACK_PIXELS_REG  0x00000040
#define ONSEMI_VITA_CAM_DECODER_CNT_IMAGE_PIXELS_REG  0x00000044
#define ONSEMI_VITA_CAM_DECODER_CNT_FRAMES_REG        0x00000048
#define ONSEMI_VITA_CAM_DECODER_CNT_WINDOWS_REG       0x0000004C
#define ONSEMI_VITA_CAM_DECODER_CNT_CLOCKS_REG        0x00000050
#define ONSEMI_VITA_CAM_DECODER_CNT_START_LINES_REG   0x00000054
#define ONSEMI_VITA_CAM_DECODER_CNT_END_LINES_REG     0x00000058
#define ONSEMI_VITA_CAM_SYNCGEN_DELAY_REG             0x0000005C
#define ONSEMI_VITA_CAM_SYNCGEN_HTIMING1_REG          0x00000060
#define ONSEMI_VITA_CAM_SYNCGEN_HTIMING2_REG          0x00000064
#define ONSEMI_VITA_CAM_SYNCGEN_VTIMING1_REG          0x00000068
#define ONSEMI_VITA_CAM_SYNCGEN_VTIMING2_REG          0x0000006C

#define ONSEMI_VITA_CAM_CRC_CONTROL_REG               0x00000070
   #define ONSEMI_VITA_CAM_CRC_RESET_BIT              0x00000001
   #define ONSEMI_VITA_CAM_CRC_INITVALUE_BIT          0x00000002
#define ONSEMI_VITA_CAM_CRC_STATUS_REG                0x00000074

#define ONSEMI_VITA_CAM_REMAPPER_CONTROL_REG          0x00000078

#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG           0x00000080
#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG0          (ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG + 0x00000000)
#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG1          (ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG + 0x00000004)
#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG2          (ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG + 0x00000008)
#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG3          (ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG + 0x0000000C)
#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG4          (ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG + 0x00000010)
#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG5          (ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG + 0x00000014)
#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG6          (ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG + 0x00000018)
#define ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG7          (ONSEMI_VITA_CAM_FPN_PRNU_VALUES_REG + 0x0000001C)

#define ONSEMI_VITA_CAM_DECODER_CNT_MONITOR0_HIGH_REG 0x000000C0
#define ONSEMI_VITA_CAM_DECODER_CNT_MONITOR0_LOW_REG  0x000000C4
#define ONSEMI_VITA_CAM_DECODER_CNT_MONITOR1_HIGH_REG 0x000000C8
#define ONSEMI_VITA_CAM_DECODER_CNT_MONITOR1_LOW_REG  0x000000CC

#define ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG           0x000000E0
#define ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG      0x000000E4
#define ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG        0x000000E8
#define ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG         0x000000EC
#define ONSEMI_VITA_CAM_TRIGGEN_TRIG1_HIGH_REG        0x000000F0
#define ONSEMI_VITA_CAM_TRIGGEN_TRIG1_LOW_REG         0x000000F4
#define ONSEMI_VITA_CAM_TRIGGEN_TRIG2_HIGH_REG        0x000000F8
#define ONSEMI_VITA_CAM_TRIGGEN_TRIG2_LOW_REG         0x000000FC


struct struct_onsemi_vita_t
{
   // software library version
   Xuint32 uVersion;

   // instantiation-specific name
   char szName[32];

   // Base Address
   Xuint32 uBaseAddr_SPI;
   Xuint32 uBaseAddr_CAM;

   // Manual Tap
   Xuint32 uManualTap;

   // Gain/Exposure
   Xuint32 uAnalogGain;
   Xuint32 uDigitalGain;
   Xuint32 uExposureTime;
};
typedef struct struct_onsemi_vita_t onsemi_vita_t;


struct struct_fpn_prnu_value_t
{
   Xuint8 fpn;  // offset
   Xuint8 prnu; // gain (decimal part of 1.xxx)
};
typedef struct struct_fpn_prnu_value_t fpn_prnu_value_t;

struct struct_onsemi_vita_status_t
{
   // Sync Channel Decoder status
   Xuint32 cntBlackLines;
   Xuint32 cntImageLines;
   Xuint32 cntBlackPixels;
   Xuint32 cntImagePixels;
   Xuint32 cntFrames;
   Xuint32 cntWindows;
   Xuint32 cntStartLines;
   Xuint32 cntEndLines;
   Xuint32 cntClocks;

   // CRC status
   Xuint32 crcStatus;

};
typedef struct struct_onsemi_vita_status_t onsemi_vita_status_t;

/******************************************************************************
* This function initializes the ON Semiconductor VITA Receiver.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    szName contains a string describing the new VITA instance.
* @param    uBaseAddr contains the base address of the VITA pcore.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_init( onsemi_vita_t *pContext, char szName[], Xuint32 uBaseAddr_SPI, Xuint32 uBaseAddr_CAM );

/******************************************************************************
* This function performs an register read transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uOffset contains the register offset (in bytes)
*
* @return   32 bit register value.
*
* @note     None.
*
******************************************************************************/
Xuint32 onsemi_vita_spi_reg_read( onsemi_vita_t *pContext, Xuint32 uRegOffset );
Xuint32 onsemi_vita_cam_reg_read( onsemi_vita_t *pContext, Xuint32 uRegOffset );

/******************************************************************************
* This function performs an register write transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uOffset contains the register offset (in bytes)
* @param    uData contains the 32 bit register value
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
void onsemi_vita_spi_reg_write( onsemi_vita_t *pContext, Xuint32 uRegOffset, Xuint32 uData );
void onsemi_vita_cam_reg_write( onsemi_vita_t *pContext, Xuint32 uRegOffset, Xuint32 uData );

/******************************************************************************
* This function resets the VITA image sensor.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uReset contains the value of the reset.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_reset( onsemi_vita_t *pContext, Xuint32 uReset );

/******************************************************************************
* This function configures the SPI controller.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uTiming contains the 16 bit value to adjust the SPI timing.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_config( onsemi_vita_t *pContext, Xuint16 uTiming );

/******************************************************************************
* This function performs an SPI read transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uAddr contains the 10 bit SPI address.
* @param    pData contains a pointer to the 16 SPI data value.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_read( onsemi_vita_t *pContext, Xuint16 uAddr, Xuint16 *pData );

/******************************************************************************
* This function performs an SPI write transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uAddr contains the 10 bit SPI address.
* @param    uData contains the 16 bit SPI data value.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_write( onsemi_vita_t *pContext, Xuint16 uAddr, Xuint16 uData );

/******************************************************************************
* This function performs an SPI nop transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_nop( onsemi_vita_t *pContext );

/******************************************************************************
* This function performs a sequence of SPI write transactions.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    pConfig contains a sequence of address/mask/value sets.
* @param    uLength contains the number of address/mask/value sets in sequence.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_write_sequence( onsemi_vita_t *pContext, Xuint16 pConfig[][3], Xuint32 uLength );

/******************************************************************************
* This function performs a sequence of SPI write transactions.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    pConfig contains a sequence of address/mask/value sets.
* @param    uLength contains the number of address/mask/value sets in sequence.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_display_sequence( onsemi_vita_t *pContext, Xuint16 pConfig[][3], Xuint32 uLength );


/******************************************************************************
* This function performs VITA initialization sequences.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    initId identifies which portion of the initialization is to be performed.
*              The initialization sequences correspond to the VITA datasheet
*
*              - SENSOR_INIT_SEQ00 => Assert/Deassert RESET_N pin
*              - SENSOR_INIT_SEQ01 => Enable Clock Management - Part 1
*              - SENSOR_INIT_SEQ02 => Verify PLL Lock Indicator
*              - SENSOR_INIT_SEQ03 => Enable Clock Management - Part 2
*              - SENSOR_INIT_SEQ04 => Required Register Upload
*              - SENSOR_INIT_SEQ05 => Soft Power-Up
*              - SENSOR_INIT_SEQ06 => Enable Sequencer
*
*              - SENSOR_INIT_SEQ07 => Disable Sequencer
*              - SENSOR_INIT_SEQ08 => Soft Power-Down
*              - SENSOR_INIT_SEQ09 => Disable Clock Management - Part 2
*              - SENSOR_INIT_SEQ10 => Disable Clock Management - Part 1
*
*              - SENSOR_INIT_ENABLE  => perform SEQ00 to SEQ06
*              - SENSOR_INIT_DISABLE => perform SEQ06 to SEQ10
*
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
#define SENSOR_INIT_SEQ00	  0
#define SENSOR_INIT_SEQ01	  1
#define SENSOR_INIT_SEQ02	  2
#define SENSOR_INIT_SEQ03	  3
#define SENSOR_INIT_SEQ04	  4
#define SENSOR_INIT_SEQ05	  5
#define SENSOR_INIT_SEQ06	  6
#define SENSOR_INIT_SEQ07	  7
#define SENSOR_INIT_SEQ08	  8
#define SENSOR_INIT_SEQ09	  9
#define SENSOR_INIT_SEQ10	 10
#define SENSOR_INIT_SEQ06A	 11
#define SENSOR_INIT_ENABLE   101 // Execute sequences 0,1,2,3,4,5,6
#define SENSOR_INIT_DISABLE  102 // Execute sequences 7, 8, 9, 10
#define SENSOR_INIT_STREAMON 103 // Start capture (corresponds to linux V4L VIDIOC_STREAMON)
int onsemi_vita_sensor_initialize( onsemi_vita_t *pContext, int initID, int bVerbose );

/******************************************************************************
* This function returns the status of the VITA receiver.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    pStatus contains a pointer to the VITA's status.
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_get_status( onsemi_vita_t *pContext, onsemi_vita_status_t *pStatus, int bVerbose );

/******************************************************************************
* This function configures the VITA-2000 to generate 1080P60 timing.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_sensor_1080P60( onsemi_vita_t *pContext, int bVerbose );

/******************************************************************************
* This function configures the VITA-2000's analog gain.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uAnalogGain contains the value of the analog gain.
*              00 => 1.00 : gain_state1=0x02(1.00), gain_stage2=0xF(1.00)
*              01 => 1.14 : gain_state1=0x02(1.00), gain_stage2=0x7(1.14)
*              02 => 1.33 : gain_state1=0x02(1.00), gain_stage2=0x3(1.33)
*              03 => 1.60 : gain_state1=0x02(1.00), gain_stage2=0x5(1.60)
*              04 => 2.00 : gain_state1=0x02(1.00), gain_stage2=0x1(2.00)
*              05 => 2.29 : gain_state1=0x01(2.00), gain_stage2=0x7(1.14)
*              06 => 2.67 : gain_state1=0x01(2.00), gain_stage2=0x3(1.33)
*              07 => 3.20 : gain_state1=0x01(2.00), gain_stage2=0x5(1.60)
*              08 => 4.00 : gain_state1=0x01(2.00), gain_stage2=0x1(2.00)
*              09 => 5.33 : gain_state1=0x01(2.00), gain_stage2=0x6(2.67)
*              10 => 8.00 : gain_state1=0x01(2.00), gain_stage2=0x2(4.00)
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_set_analog_gain( onsemi_vita_t *pContext, Xuint32 uAnalogGain, int bVerbose );

/******************************************************************************
* This function configures the VITA-2000's digital gain.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    digitalGain contains the value of the digital gain.
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_set_digital_gain( onsemi_vita_t *pContext, Xuint32 uDigitalGain, int bVerbose );

/******************************************************************************
* This function configures the VITA-2000's exposure time.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    analogGain contains the value of the exposure time (in usec)
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_set_exposure_time( onsemi_vita_t *pContext, Xuint32 exposureTime, int bVerbose );

/******************************************************************************
******************************************************************************/
#define SENSOR_BLACK_ON   0
#define SENSOR_BLACK_OFF  1
#define SENSOR_GREY_ON    2
#define SENSOR_GREY_OFF   3

int onsemi_vita_sensor_initialize( onsemi_vita_t *pContext, int initID, int bVerbose );

/******************************************************************************
******************************************************************************/
int onsemi_vita_sensor_cds(onsemi_vita_t *pContext, int bVerbose);

#endif /** ONSEMI_VITA_SW_H */
