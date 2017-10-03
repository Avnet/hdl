
/************************************************************************
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
************************************************************************/
/***********************************************************************/
/**
*
* @file tpm_spi.c
*
* The file is used in the SLB9670 TPM SPI Driver 
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver	Who	Date		Changes
* ----- ---- -------- -------------------------------------------------------
* 1.00a lss	09/04/16	Initial release
*
************************************************************************/

#include "slb9670_tpm_spi.h"

/************************************************************************/
/** XSpiPS_SLB9670_INIT
*
* @param	BaseAddress is the BaseAddress of the SPI device
*
* @return	XST_SUCCESS
*
* @note		None
*
*************************************************************************/
int XSpiPS_SLB9670_INIT(u32 BaseAddress)
{
	//Reset the SPI Peripheral
	XSpiPs_ResetHw(SPI_BASEADDR);
	usleep(100);

	// Initialize the PS SPI Controller with settings compatible with the SLB9670 and
	// deselect all slaves
	XSpiPs_WriteReg(SPI_BASEADDR, XSPIPS_CR_OFFSET, SLB9670_CR_INIT_MODE);
	//Enable the SPI peripheral
	XSpiPs_WriteReg(SPI_BASEADDR,XSPIPS_ER_OFFSET,XSPIPS_ER_ENABLE_MASK);
	usleep(100);

	return XST_SUCCESS;
}

/************************************************************************/
/** XSpiPS_tx_rx
*
* @param	BaseAddress is the BaseAddress of the SPI device
* @param	SPI_Channel is the slave select to be asserted
* @param	TxBuffer is an array pointer where the data to transmit is stored
* @param	RxBuffer is an array pointer where the received data will be stored
* @param	TxByteCount is the number of bytes in the transaction
*
* @return	XST_SUCCESS if successful, XST_FAILURE if unsuccessful
*
* @note		None
*
*************************************************************************/
int XSpiPS_tx_rx(u32 BaseAddress, u32 SPI_Channel, u8* TxBuffer, u8* RxBuffer, u32 TxByteCount)
{
	int NumBytesRcvd = 0;
	u32 Count = 0;
	u32 Debug = 0;

	/*
	 * Initialize the Tx FIFO in the PS SPI Controller with the transmit
	 * data contained in TxBuffer
	 */
	for (Count = 0; Count < TxByteCount; Count++)
	{
		XSpiPs_WriteReg((BaseAddress), XSPIPS_TXD_OFFSET, TxBuffer[Count]);
	}

	// Assert Slave Select 0, then wait a bit so it takes affect
	XSpiPs_WriteReg(BaseAddress, XSPIPS_CR_OFFSET, SLB9670_CR_SS0_SELECT);
	usleep(100);

	//start the SPI transaction by writing a 1 to the Man_start_com bit
	XSpiPs_WriteReg(BaseAddress,XSPIPS_CR_OFFSET,(XSPIPS_CR_MANSTRT_MASK | SLB9670_CR_SS0_SELECT));

	/*
	 * While the PS SPI controller's status register TX_FIFO_not_full (IXR_TXOW)
	 * bit shows that the FIFO has more than or equal to THRESHOLD entries (default = 1)
	 * then continue to loop.
	 *
	 * Or, in simpler terms, wait for the TX FIFO to empty
	 */
	while((XSpiPs_ReadReg(BaseAddress,XSPIPS_SR_OFFSET) & XSPIPS_IXR_TXOW_MASK) == 0);

	/*
	 * If TxByteCount number of bytes is sent, then by design, there must be
	 * TxByteCount number of bytes received
	 *
	 * Set the RX FIFO Threshold to TxByteCount, then wait while the status register's
	 * RX_FIFO_not_empty (IXR_RXNEMPTY) bit shows the FIFO has less than RX THRESHOLD entries
	 */
	XSpiPs_WriteReg(BaseAddress,XSPIPS_RXWR_OFFSET, TxByteCount);
	while((XSpiPs_ReadReg(BaseAddress,XSPIPS_SR_OFFSET) & XSPIPS_IXR_RXNEMPTY_MASK) == 0);

	// Disable all SS#[x] chip-selects and turn off Manual Start
	XSpiPs_WriteReg(BaseAddress,XSPIPS_CR_OFFSET,SLB9670_CR_INIT_MODE);

	/*
	 * The PS SPI Controller's Rx FIFO has now received TxByteCount number
	 * of bytes off the SPI bus and is ready to be read.
	 *
	 * Transfer the Rx bytes out of the Controller's Rx FIFO into our code
	 * Keep reading one byte at a time until the Rx FIFO is empty
	 */
	XSpiPs_WriteReg(BaseAddress,XSPIPS_RXWR_OFFSET, 0x1);
	Debug = XSpiPs_ReadReg(BaseAddress,XSPIPS_RXWR_OFFSET);
	Debug = XSpiPs_ReadReg(BaseAddress, XSPIPS_SR_OFFSET) & XSPIPS_IXR_RXNEMPTY_MASK;
	NumBytesRcvd = 0;
	while ((XSpiPs_ReadReg(BaseAddress, XSPIPS_SR_OFFSET) & XSPIPS_IXR_RXNEMPTY_MASK) == XSPIPS_IXR_RXNEMPTY_MASK)
	{
		RxBuffer[NumBytesRcvd] = XSpiPs_ReadReg((BaseAddress), XSPIPS_RXD_OFFSET);
		NumBytesRcvd++;
	}

	/*
	 * If no data was sent or if we didn't receive as many bytes as
	 * were transmitted, then flag a failure
	 */
	if ((TxByteCount != NumBytesRcvd) || (TxByteCount == 0)) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

