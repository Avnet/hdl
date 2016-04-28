//----------------------------------------------------------------------------
//      _____
//     *     *
//    *____   *____
//   * *===*   *==*
//  *___*===*___**  AVNET
//       *======*
//        *====*
//----------------------------------------------------------------------------
//
// This design is the property of Avnet.  Publication of this
// design is not authorized without written consent from Avnet.
//
// Please direct any questions to the PicoZed community support forum:
//    http://www.picozed.org/forum
//
// Product information is available at:
//    http://www.picozed.org/product/picozed
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2016 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Feb 10, 2016
// Design Name:         MicroZed SPI Temperature Sensor MAX31723
// Module Name:         PmodUtilities.h
// Project Name:        MicroZed Sensor Fusion Demo
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     MicroZed, MicroZed I/O Carrier
//
// Tool versions:       Xilinx Vivado 2015.2
//
// Description:         Used to communicate with MAX31723 SPI device.
//
// Dependencies:
//
// Revision:            Feb 10, 2016: 1.00 Initial version
//
//----------------------------------------------------------------------------

#ifndef __PMODUTILITES_H_
#define __PMODUTILITES_H_
#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xstatus.h"
#include "xspi_l.h"
#include "sleep.h"

#define SPI_BASEADDR			XPAR_AXI_QUAD_SPI_0_BASEADDR  // Base address for AXI SPI controller

#define SPI_CHANNEL_SEL_0		0xFFFFFFFE					// Select spi channel 0
#define SPI_CHANNEL_SEL_1		0xFFFFFFFD					// Select spi channel 1
#define SPI_CHANNEL_SEL_NONE	0xFFFFFFFF					// Deselect all SPI channels

// Initialization settings for the AXI SPI controller's Control Register when addressing the MAX31723
// 0x196 = b1_1001_0110
//			1	Inhibited to hold off transactions starting
//			1	Manually select the slave
//			0	Do not reset the receive FIFO at this time
//			0	Do not reset the transmit FIFO at this time
//			1	Clock phase of 1
//			0	Clock polarity of low
//			1	Enable master mode
//			1	Enable the SPI Controller
//			0	Do not put in loopback mode

#define MAX31723_CR_INIT_MODE		XSP_CR_TRANS_INHIBIT_MASK | XSP_CR_MANUAL_SS_MASK   | \
									XSP_CR_CLK_PHASE_MASK     | XSP_CR_MASTER_MODE_MASK | \
									XSP_CR_ENABLE_MASK
#define MAX31723_CR_UNINHIBIT_MODE	                            XSP_CR_MANUAL_SS_MASK   | \
									XSP_CR_CLK_PHASE_MASK     | XSP_CR_MASTER_MODE_MASK | \
									XSP_CR_ENABLE_MASK
#define AXI_SPI_RESET_VALUE			0x0A  //!< Reset value for the AXI SPI Controller

#define MAX31723_CSR_READ 			0x00  //!< Read address for Config/Status register
#define MAX31723_TEMP_READ 			0x01  //!< Read address for Temperature LSB register (MSB=0x02)
#define MAX31723_HIGH_ALARM_READ 	0x03  //!< Read address for High Temperature Alarm LSB register (MSB=0x04)
#define MAX31723_LOW_ALARM_READ 	0x05  //!< Read address for Low Temperature Alarm LSB register (MSB=0x06)
#define MAX31723_CSR_WRITE 			0x80  //!< Write address for Config/Status register
#define MAX31723_HIGH_ALARM_WRITE 	0x83  //!< Write address for High Temperature Alarm LSB register (MSB=0x84)
#define MAX31723_LOW_ALARM_WRITE 	0x85  //!< Write address for Low Temperature Alarm LSB register (MSB=0x86)

#define MAX31723_12BIT_MODE			0x06  //!< CSR setting for 12-bit resolution
/************************** Function Prototypes *******************************/

int XSpi_MAX31723_INIT(u32 BaseAddress);
int XSpi_LowLevelExecute(u32 BaseAddress, u32 SPI_Channel, u32 *TxBuffer, u32 *RxBuffer, u32 TxByteCount);

#endif
