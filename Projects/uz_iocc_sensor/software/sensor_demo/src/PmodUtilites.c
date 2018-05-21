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

int MAX44000_write(u32 ZynqIicAddress, u8 register_offset, u8 write_value)
/*
 * \brief       Use the Zynq IIC Controller to write a value to a
 *              MAX44000 register at a given offset
 *
 * \param[in]   ZynqIicAddress    - address of the I2C Controller
 * \param[in]   register_offset   - offset of register inside the MAX44000
 * \param[in]   write_value       - value to be written to MAX44000 register
 *
 * \return      XST_SUCCESS if operation succeeded
 */
{
	int Status = XST_SUCCESS;
	u8 TxBuffer[4]; // Only need this to be size 2, but making larger for future use
	int ByteCount;

	TxBuffer[0] = register_offset;  // Offset of register to write
	TxBuffer[1] = write_value;  // value to write there
	/* ADD HERE
	 *  Add code to send the 2 bytes contained in TxBuffer over I2C to
	 *  the device responding to I2C address MAX44000_IIC_ADDRESS.
	 *  The first byte of TxBuffer contains the offset to the register
	 *  inside the MAX44000. The second byte contains the data to be
	 *  written to that register. If the transfer fails, then
	 *  set Status to XST_FAILURE
	 */
	ByteCount = XIic_Send(ZynqIicAddress, MAX44000_IIC_ADDRESS,
			TxBuffer, 2, XIIC_STOP);
	if(ByteCount!=2)
		Status=XST_FAILURE;

	return(Status);
}

int MAX44000_read(u32 ZynqIicAddress, u8 register_offset, u8 *read_value)
/*
 * \brief       Use the Zynq IIC Controller to read a value from a
 *              MAX44000 register at a given offset
 *
 * \param[in]   ZynqIicAddress    - address of the I2C Controller
 * \param[in]   register_offset   - offset of register inside the MAX44000
 * \param[in]   *read_value       - pointer to data read from MAX44000 register
 *
 * \return      XST_SUCCESS if operation succeeded
 */
{
	int Status = XST_SUCCESS;
	u8 TxBuffer[4]; // Only need this to be size 1, but making larger for future use
	u8 RxBuffer[4]; // Only need this to be size 1, but making larger for future use
	int ByteCount;

	TxBuffer[0] = register_offset;
	/* ADD HERE
	 *  Add code to send 1 byte contained in TxBuffer over I2C to
	 *  the device responding to I2C address MAX44000_IIC_ADDRESS.
	 *  TxBuffer contains the offset to the register
	 *  inside the MAX44000. If the transfer fails, then
	 *  set Status to XST_FAILURE
	 */
	ByteCount = XIic_Send(ZynqIicAddress, MAX44000_IIC_ADDRESS,
			TxBuffer, 1, XIIC_STOP);
	if(ByteCount!=1)
		Status=XST_FAILURE;

	/* ADD HERE
	 *  Add code to receive 1 byte into RxBuffer over I2C from
	 *  the device responding to I2C address MAX44000_IIC_ADDRESS.
	 *  Since we previously sent the offset to the register
	 *  inside the MAX44000, the MAX44000 will now return the data
	 *  contained within that register. If the transfer fails, then
	 *  set Status to XST_FAILURE
	 */
	ByteCount = XIic_Recv(ZynqIicAddress, MAX44000_IIC_ADDRESS,
			RxBuffer, 1, XIIC_STOP);
	if(ByteCount!=1)
		Status=XST_FAILURE;

	if(Status==XST_SUCCESS)
		*read_value = RxBuffer[0];

	return(Status);
}

int max_MAX44000_readLux(u32 unPeripheralAddressI2C, unsigned int *unLuxReading)
/*
 * Copyright (C) 2012 Maxim Integrated Products, All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY,  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL MAXIM INTEGRATED PRODUCTS BE LIABLE FOR ANY CLAIM, DAMAGES
 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * Except as contained in this notice, the name of Maxim Integrated Products
 * shall not be used except as stated in the Maxim Integrated Products
 * Branding Policy.
 *
 * The mere transfer of this software does not imply any licenses
 * of trade secrets, proprietary technology, copyrights, patents,
 * trademarks, maskwork rights, or any other form of intellectual
 * property whatsoever. Maxim Integrated Products retains all ownership rights.
 *
 ***************************************************************************/
/**
* \brief       Return the Lux value from the MAX44000.
* \par         Details
*              This function implements a state machine to manage the transaction.  The state
*              machine handles error cases, including bit overflow, changing the gain setting
*              and then re-reading the lux value.  See source for additional comments/theory.
*              This sets up the transmit configuration register (reg addr 0x03) as follows:
* \n           DRV [3:0] = 001 : "ALS-G-IR". (difference between green and IR.)
*
* \param[in]   unPeripheralAddressI2C    - address of the I2C peripheral in Microblaze memory map
* \param[out]  *unLuxReading             - lux reading is stored at unLuxReading
*
* \retval      TRUE if operation succeeded
*/
{
	int nReturnVal = TRUE;
	u8 auchTxBuffer[2];
	u8 auchRxBuffer[2];
	int nByteCount=0;
	unsigned int unTempLux=0;
	u8 uchStateMachineActive=TRUE;
	int nState=0;
	u8 uchALSPGA=0;
	u8 uchHighByte=0;
	u8 uchLowByte=0;
	int nNumberFailedReadWrites=0;

	// Device Theory

	// The ambient light sensor reading is retrieved by reading a 14 bit unsigned integer value held in
	//   bits [5:0] of register 0x04 and [7:0] of 0x05.
	// To convert the ALSDATA[13:0] to lux, it is scaled by (1/32, 1/8, 1/2, or 4) depending on the value of ALSPGA
	// ALSPGA[1:0] = register 0x02, bits [1:0]
	// Additionally, the light sensor can overflow (bit 6 of register 0x04), in which case the reading is invalid
	//   and the ALSPGA setting needs to be increased

	// This function attempts to read register 0x04, then checks for the overflow bit.
	// If overflow is set, it increases ALSPGA, delays, re-reads 0x04.
	// If overflow remains set, it returns FALSE.

	// In 14 bit mode, the MAX44000 device requires 100mS to refresh its internal registers.
	// Since this function uses polling mode (instead of interrupt mode), to be conservative,
	//   all delays are chosen to be ~250mS.

	while(uchStateMachineActive==TRUE)
	{
		switch(nState)
		{
			case MAX44000_STATE_BEGIN:
				nState = MAX44000_STATE_SET_ALSPGA;
				break;
			case MAX44000_STATE_SET_ALSPGA:
				auchTxBuffer[0] = 0x02;  // Receive configuration register
				auchTxBuffer[1] = 0x00;
				uchALSPGA = 0x00;		 // Sets up 14-bit resolution, gain = 0.03125 LUX/lsb
				nByteCount = XIic_Send(unPeripheralAddressI2C, MAX44000_IIC_ADDRESS,
					(u8 *)&auchTxBuffer, 2, XIIC_STOP);

				if(nByteCount==2)
					nState = MAX44000_STATE_READ_04;
				else
					nState = MAX44000_STATE_FAILED_RW;

//				delay(ABOUT_ONE_SECOND/2); // 500mS
				usleep(500000);
				break;
			case MAX44000_STATE_READ_04:
				auchTxBuffer[0] = 0x04;  // Lux High-Byte register (overflow bit + bits 13:8 of lux reading)
				nByteCount = XIic_Send(unPeripheralAddressI2C, MAX44000_IIC_ADDRESS,
						(u8 *)&auchTxBuffer, 1, XIIC_STOP);

				if(nByteCount==1)
				{
					nByteCount = XIic_Recv(unPeripheralAddressI2C, MAX44000_IIC_ADDRESS,
							(u8 *)&auchRxBuffer, 1, XIIC_STOP);
					if(nByteCount==1)
					{
						// Check for overflow bit first
						if((auchRxBuffer[0] & 0x40)==0x40)
							nState = MAX44000_STATE_INCREASE_ALSPGA;
						else
						{
							uchHighByte=auchRxBuffer[0];
							nState = MAX44000_STATE_READ_05;
						}
					}
					else
						nState = MAX44000_STATE_FAILED_RW;
				}
				else
					nState = MAX44000_STATE_FAILED_RW;

				break;
			case MAX44000_STATE_READ_05:
				auchTxBuffer[0] = 0x05;  // Lux Low-Byte register (bits 7:0 of lux reading)
				nByteCount = XIic_Send(unPeripheralAddressI2C, MAX44000_IIC_ADDRESS,
						(u8 *)&auchTxBuffer, 1, XIIC_STOP);

				if(nByteCount==1)
				{
					nByteCount = XIic_Recv(unPeripheralAddressI2C, MAX44000_IIC_ADDRESS,
							(u8 *)&auchRxBuffer, 1, XIIC_STOP);
					if(nByteCount==1)
					{
						uchLowByte=auchRxBuffer[0];
						nState = MAX44000_STATE_PROCESS_LUX;
					}
					else
						nState = MAX44000_STATE_FAILED_RW;
				}
				else
					nState = MAX44000_STATE_FAILED_RW;
				break;
			case MAX44000_STATE_INCREASE_ALSPGA:
				uchALSPGA++;
				if(uchALSPGA >=4)
				{
					unTempLux = 16383;  // (maximum value for a 14 bit unsigned int number)
					nState = MAX44000_STATE_EXIT_SUCCESS;
				}
				else
				{
					auchTxBuffer[0] = 0x02;  // Recv config register (ADC conv time and PGA gain setting
					auchTxBuffer[1] = (uchALSPGA & 0x03);
					nByteCount = XIic_Send(unPeripheralAddressI2C, MAX44000_IIC_ADDRESS,
							(u8 *)&auchTxBuffer, 2, XIIC_STOP);

					if(nByteCount==2)
						nState = MAX44000_STATE_READ_04;
					else
						nState = MAX44000_STATE_FAILED_RW;

					// 100mS per reading, so we'll delay signficantly more than that before progressing
//					delay(ABOUT_ONE_SECOND/2);
					usleep(500000);
				}
				break;
			case MAX44000_STATE_PROCESS_LUX:
				unTempLux=0;
				unTempLux = (uchHighByte & 0x3F);
				unTempLux = unTempLux << 8;
				unTempLux += uchLowByte;

				nState =MAX44000_STATE_EXIT_SUCCESS;
				if(uchALSPGA==0)
					unTempLux /= 32;
				else if(uchALSPGA==1)
					unTempLux /= 8;
				else if(uchALSPGA==2)
					unTempLux /= 2;
				else if(uchALSPGA==3)
					unTempLux *= 4;
				else
				{
					nState = MAX44000_STATE_EXIT_FAILED;
				}

				break;
			case MAX44000_STATE_FAILED_RW:
				nNumberFailedReadWrites++;
				printf("Error.  Failed to read or write I2C device:\r\n");
				if(nNumberFailedReadWrites>10)  // arbitrary 10 attempts
					nState = MAX44000_STATE_EXIT_FAILED;
				else
					nState = MAX44000_STATE_DELAY;
				break;
			case MAX44000_STATE_DELAY:
//				delay(ABOUT_ONE_SECOND / 4);
				usleep(250000);
				nState = MAX44000_STATE_BEGIN;
				break;
			case MAX44000_STATE_EXIT_FAILED:
				uchStateMachineActive=FALSE;
				nReturnVal=FALSE;
				break;
			case MAX44000_STATE_EXIT_SUCCESS:
				uchStateMachineActive=FALSE;
				*unLuxReading = unTempLux;
				nReturnVal=TRUE;
				break;
		}
	}

	return(nReturnVal);
}


void print_banner() {
    print("\n\r********************************************************");
    print("\n\r********************************************************");
    print("\n\r**        Avnet UltraZed-EG SOM and I/O Carrier       **");
    print("\n\r**        Maxim MAX44000 Proximity Sensor Pmod        **");
    print("\n\r**                          and                       **");
    print("\n\r**          Maxim MAX31855 Thermocouple Pmod          **");
    print("\n\r**             LED Brightness Control and             **");
    print("\n\r**         Temperature Sensing Demonstration          **");
    print("\n\r********************************************************");
    print("\n\r********************************************************\r\n");
    print("**\r\n");
    print("Press SW2 (near JX2 JF Pmod) to print the sensor values.\r\n");
    print("**\r\n");
}

