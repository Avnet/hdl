/******************************************************************************
*
* Copyright (C) 2012 - 2016 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

#ifndef __PMODUTILITES_H_
#define __PMODUTILITES_H_
#include <stdio.h>
#include "xparameters.h"
#include "xstatus.h"
#include "xspips_hw.h"		/* SPI device driver */
#include "sleep.h"
#include "tpm.h" 
#define SPI_BASEADDR			0xFF040000  // Base address for PS SPI1 controller

#define SPI_CHANNEL_SEL_0		0x0					// Select spi channel 0
#define SPI_CHANNEL_SEL_1		0x1					// Select spi channel 1
#define SPI_CHANNEL_SEL_2		0x3					// Select spi channel 1
#define SPI_CHANNEL_SEL_NONE	0xF					// Deselect all SPI channels

// Initialization settings for the PS SPI controller's Control Register when addressing the SLB9670
// 0x0FC21 = b00_1111_1100_0010_0001
//			0	ModeFail Generation Enable = 0 Bit[17]
//			0	Manual Start Command = 0 Bit [16]
//		-----
//			1	Manual Start Enable = 1 Bit [15]
//			1	Manual Chip Select = 1 Bit [14]
//		 1111	Chip Select Lines => [13:10] 1111 no chip select selected
//					xxx0 - slave 0 selected
//					xx01 - slave 1 selected
//					x011 - slave 2 selected
//					0111 - reserved
//					1111 - No slave selected
//			0	Peripheral select decode = 0, only 1 of 3 selects, Bit [9]
//			0	Master reference clock select = 0, use SPI REFERENCE CLOCK, Bit [8]
//		   00	Reserved = 00, => Bits [7:6]
//		  100	Baud rate = clk / 32 = 100, => Bits [5:3]
//			0	CPHA=0 => Bit[2], the SPI clock is active outside the word
//			0	CPOL=0, => Bit[1], the SPI clock is quiescent low
//			1	Enable master mode = 1, => Bit [0]


#define SLB9670_CLOCK_PHASE_CPHA		0
#define SLB9670_CLOCK_POLARITY_CPOL	0

#define SLB9670_CR_INIT_MODE		0x0FC21
#define SLB9670_CR_SS0_SELECT		0x0C021
#define SLB9670_CR_SS1_SELECT		0x0C421
#define SLB9670_CR_SS2_SELECT		0x0CC21

#define TPM_ACTIVE_LOCALITY 0x80
#define TPM_STS_COMMANDREADY   0x40
#define TPM_STS_VALID 0x80
#define TPM_STS_EXPECT 0x08
#define TPM_STS_DATA_AVAILABLE 0x10
#define TPM_STS_GO 0x20


/************************** Function Prototypes *******************************/
int XSpiPS_SLB9670_INIT(u32 BaseAddress);
int XSpiPS_tx_rx(u32 BaseAddress, u32 SPI_Channel, u8 *TxBuffer, u8 *RxBuffer, u32 TxByteCount);

#endif
