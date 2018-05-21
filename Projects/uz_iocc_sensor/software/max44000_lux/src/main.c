#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "sleep.h"
#include "xgpio.h"
#include "xstatus.h"
#include "xiic_l.h"

/************************** Constant Definitions *****************************/
/*
 * The following constant maps to the name of the hardware instances that
 * were created in the Vivado system design.
 */

#define PWM_BASE_ADDRESS				XPAR_PWM_W_INT_0_BASEADDR

#define MAX44000_IIC_ADDRESS            0x4A   // The actual address is 8'b1001 010x (0x94)
#define MAX44000_MAIN_CONFIG_REG        0x01   // Main configuration register
#define MAX44000_RECV_CONFIG_REG        0x02   // Receive configuration register
#define MAX44000_LED_DRIVE_CURRENT_REG  0x03   // LED Drive Current register
#define MAX44000_LUX_HIGH_BYTE_REG      0x04   // Lux High-Byte register (overflow bit + bits 13:8 of lux reading)
#define MAX44000_LUX_LOW_BYTE_REG       0x05   // Lux Low-Byte register (bits 7:0 of lux reading)

#define MAX44000_STATE_BEGIN 0           //!< LUX measurement state: Beginning state.
#define MAX44000_STATE_SET_ALSPGA 1      //!< LUX measurement state: Set ADC resolution and amplifier gain.
#define MAX44000_STATE_READ_04 2         //!< LUX measurement state: Read LUX high and overflow.
#define MAX44000_STATE_READ_05 3         //!< LUX measurement state: Read LUX low byte
#define MAX44000_STATE_INCREASE_ALSPGA 4 //!< LUX measurement state: Increase PGA setting (lower gain)
#define MAX44000_STATE_PROCESS_LUX 5     //!< LUX measurement state: Scale the LUX value per PGA setting
#define MAX44000_STATE_FAILED_RW 6       //!< LUX measurement state: Abort, I2C failure
#define MAX44000_STATE_DELAY 7           //!< LUX measurement state: Delay one state
#define MAX44000_STATE_EXIT_FAILED 8     //!< LUX measurement state: Failure, exit
#define MAX44000_STATE_EXIT_SUCCESS 9    //!< LUX measurement state: Process completed, exit

/* following constant is used to determine which channel of the GPIO is
 * used if there are 2 channels supported in the GPIO.
 */
#define LED_GPIO_CHANNEL 2
#define PB_GPIO_CHANNEL 1
#define DEVICE_ID 	XPAR_GPIO_1_DEVICE_ID

/************************** Variable Definitions **************************/
/*
 * The following are declared globally so they are zeroed and so they are
 * easily accessible from a debugger
 */
XGpio GpioOutput; /* The driver instance for GPIO Device configured as O/P */
XGpio GpioInput;  /* The driver instance for GPIO Device configured as I/P */

/*****************************************************************************/

int MAX44000_write(u32 ZynqIicAddress, u8 register_offset, u8 write_value);
int MAX44000_read(u32 ZynqIicAddress, u8 register_offset, u8 *read_value);
int max_MAX44000_readLux(u32 unPeripheralAddressI2C, unsigned int *unLuxReading);
void print_banner();

int main()
{
//	u8 LuxHighByte=0;
//	u8 LuxLowByte=0;
	unsigned int LuxReading=0;
	u32 brightness = 0;

	int Status;

//	u8 line_count = 0;
//	u32 pb_hit = 0;
//	u32 dont_repeat = 0;

	init_platform();

	print("\033[2J"); // Clear the screen

	print_banner();

	/*
	 * Initialize the GPIO driver so that it's ready to use,
	 * specify the device ID that is generated in xparameters.h
	 */
	Status = XGpio_Initialize(&GpioOutput, DEVICE_ID);
	if (Status != XST_SUCCESS)  {
		return XST_FAILURE;
	}

	/*
	 * Initialize the GPIO driver so that it's ready to use,
	 * specify the device ID that is generated in xparameters.h
	 */
	Status = XGpio_Initialize(&GpioInput, DEVICE_ID);
	if (Status != XST_SUCCESS)  {
		return XST_FAILURE;
	}


	/*
	 * Set the direction for all signals to be inputs for the PBs
	 */
	XGpio_SetDataDirection(&GpioInput, PB_GPIO_CHANNEL, 0xFFFFFFFF);

	/*
	 * Set the direction for all signals to be outputs for the LEDs
	 */
	XGpio_SetDataDirection(&GpioOutput, LED_GPIO_CHANNEL, 0x0);

	/*
	 * Set the GPIO outputs to low
	 */
	XGpio_DiscreteWrite(&GpioOutput, LED_GPIO_CHANNEL, 0x3);

	/* Initialize the LED Dimmer controller to a safe PWM value. */
	Xil_Out32(PWM_BASE_ADDRESS, 0);

	// Set to Ambient Light Sensor mode
	MAX44000_write(XPAR_IIC_1_BASEADDR, MAX44000_MAIN_CONFIG_REG, 0x24);

	// Set the Ambient Light Sensor programmable gain
	// Value = 0x00 sets up 14-bit resolution, gain = 0.03125 LUX/lsb
	MAX44000_write(XPAR_IIC_1_BASEADDR, MAX44000_RECV_CONFIG_REG, 0x00);

	while (1)
	{
/*
		MAX44000_read(XPAR_IIC_1_BASEADDR, MAX44000_LUX_HIGH_BYTE_REG, &LuxHighByte);
		MAX44000_read(XPAR_IIC_1_BASEADDR, MAX44000_LUX_LOW_BYTE_REG, &LuxLowByte);
//        if((LuxHighByte & 0x40)==0x40)
//        	print("Overflow occurred!\r\n");
		LuxReading = (LuxHighByte & 0x3F);
		LuxReading = LuxReading << 8;
		LuxReading += LuxLowByte;
		LuxReading /= 32; // Undo the previous gain entered
*/

		max_MAX44000_readLux(XPAR_IIC_1_BASEADDR, &LuxReading);

/*
 		dont_repeat = pb_hit <<1; // Set the dont_repeat flag if the PB is still pressed
 		pb_hit = XGpio_DiscreteRead(&GpioInput, PB_GPIO_CHANNEL); // Capture PB press
 		if (pb_hit == 0x1 && dont_repeat != 0x2) { // PB and dont_repeat flag cleared
			if (line_count == 12) {
				line_count = 0;
				print("\033[2J"); // Clear the screen
				print_banner();
			}

	        if((LuxHighByte & 0x40)==0x40)
	        	xil_printf("Overflow occurred\r\n");

			xil_printf("Lux Value = %d\r\n",LuxReading);
			line_count++;
		}
*/

		xil_printf("Lux Value = %4d\r",LuxReading);
		if (LuxReading < 0xa) // Turn on D16 LED for dim light threshold
			XGpio_DiscreteWrite(&GpioOutput, LED_GPIO_CHANNEL, 0x1);
		else if (LuxReading > 0x100) // Turn on D17 LED for bright light threshold
			XGpio_DiscreteWrite(&GpioOutput, LED_GPIO_CHANNEL, 0x2);
		else // LEDs off if neither too dim nor too bright
			XGpio_DiscreteWrite(&GpioOutput, LED_GPIO_CHANNEL, 0x0);

 		// Write the duty_cycle width (Period) out to the PL PWM peripheral.
		brightness = LuxReading * 1000;
		Xil_Out32(PWM_BASE_ADDRESS, brightness);

	}

return 0;
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
    print("\n\r**        LED Brightness Control Demonstration        **");
    print("\n\r********************************************************");
    print("\n\r********************************************************\r\n");
    print("**\r\n");
/*
    print("Press SW2 (near the JX2 JF Pmod) \r\n");
    print("to print the MAX44000 Lux value.\r\n");
    print("**\r\n");
*/
}
