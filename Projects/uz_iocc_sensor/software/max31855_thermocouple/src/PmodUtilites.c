/*
 * Copyright (c) 2016 Avnet, Inc.  All rights reserved.
 *
 * Avnet, Inc.
 * Avnet IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, Avnet IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * Avnet EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

#include "PmodUtilities.h"

/******************************************************************************/
/** XSpi_MAX31855_INIT
*
* @param	BaseAddress is the BaseAddress of the SPI device
*
* @return	XST_SUCCESS
*
* @note		None
*
*******************************************************************************/
int XSpi_MAX31855_INIT(u32 BaseAddress)
{
	//Reset the SPI Peripheral, which takes 4 cycles, so wait a bit after reset
	XSpi_WriteReg(SPI_BASEADDR, XSP_SRR_OFFSET, AXI_SPI_RESET_VALUE);
	usleep(100);
	// Initialize the AXI SPI Controller with settings compatible with the MAX31855
	XSpi_WriteReg(SPI_BASEADDR, XSP_CR_OFFSET, MAX31855_CR_INIT_MODE);
	// Deselect all slaves to start, then wait a bit for it to take affect
	XSpi_WriteReg(SPI_BASEADDR, XSP_SSR_OFFSET, SPI_CHANNEL_SEL_NONE);
	usleep(100);

	return XST_SUCCESS;
}

/******************************************************************************/
/** XSpi_LowLevelExecute
* Based on Xilinx XSpi_LowLevelExample
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
*******************************************************************************/
int XSpi_LowLevelExecute(u32 BaseAddress, u32 SPI_Channel, u32* TxBuffer, u32* RxBuffer, u32 TxByteCount)
{
	int NumBytesRcvd = 0;
	u32 Count;

	/*
	 * Initialize the Tx FIFO in the AXI SPI Controller with the transmit
	 * data contained in TxBuffer
	 */
	for (Count = 0; Count < TxByteCount; Count++)
	{
		XSpi_WriteReg((BaseAddress), XSP_DTR_OFFSET, TxBuffer[Count]);
	}

	// Assert the Slave Select, then wait a bit so it takes affect
	XSpi_WriteReg(BaseAddress, XSP_SSR_OFFSET, SPI_Channel);
	usleep(100);

	/*
	 * Disable the Inhibit bit in the AXI SPI Controller's controler register
	 * This will release the AXI SPI Controller to release the transaction onto the bus
	 */
	XSpi_WriteReg(BaseAddress, XSP_CR_OFFSET, MAX31855_CR_UNINHIBIT_MODE);


	/*
	 * Wait for the AXI SPI controller's transmit FIFO to transition to empty
	 * to make sure all the transmit data gets sent
	 */
	while (!(XSpi_ReadReg(BaseAddress, XSP_SR_OFFSET) & XSP_SR_TX_EMPTY_MASK));

	/*
	 * Wait for the AXI SPI controller's Receive FIFO Occupancy register to
	 * show the expected number of receive bytes before attempting to read
	 * the Rx FIFO. Note the Occupancy Register shows Rx Bytes - 1
	 *
	 * If TxByteCount number of bytes is sent, then by design, there must be
	 * TxByteCount number of bytes received
	 */
	Count = 0;
	while (Count != (TxByteCount-1))
	{
		Count = XSpi_ReadReg(BaseAddress, XSP_RFO_OFFSET);
	}

	/*
	 * The AXI SPI Controller's Rx FIFO has now received TxByteCount number
	 * of bytes off the SPI bus and is ready to be read.
	 *
	 * Transfer the Rx bytes out of the Controller's Rx FIFO into our code
	 * Keep reading one byte at a time until the Rx FIFO is empty
	 */
	NumBytesRcvd = 0;
	while ((XSpi_ReadReg(BaseAddress, XSP_SR_OFFSET) & XSP_SR_RX_EMPTY_MASK) == 0)
	{
		RxBuffer[NumBytesRcvd] = XSpi_ReadReg((BaseAddress), XSP_DRR_OFFSET);
		NumBytesRcvd++;
	}

	// Now that the Rx Data is retrieved, inhibit the AXI SPI Controller
	XSpi_WriteReg(BaseAddress, XSP_CR_OFFSET, MAX31855_CR_INIT_MODE);
	// Deassert the Slave Select
	XSpi_WriteReg(BaseAddress, XSP_SSR_OFFSET, SPI_CHANNEL_SEL_NONE);


	/*
	 * If no data was sent or if we didn't receive as many bytes as
	 * were transmitted, then flag a failure
	 */
	if ((TxByteCount != NumBytesRcvd) || (TxByteCount == 0)) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

