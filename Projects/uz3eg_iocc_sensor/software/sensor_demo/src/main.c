#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "sleep.h"
#include "xgpio.h"
#include "xstatus.h"
#include "xiic_l.h"
#include "PmodUtilities.h"

int main()
{
	unsigned int LuxReading=0;
	u32 brightness = 0;

	int Status;

	u8 line_count = 0;
	u8 pb_hit = 0;

	int i;
	// TxBuffer is not used to communicate with the MAX31855 but it is still necessary
	//      for the XSPI utilities to function
	u32 TxBuffer[6] = {0,0,0,0,0,0};
	u32 RxBuffer[6];
	int nTemporaryValue=0;
	int nTemporaryValue2=0;
	float MAX31855_internal_temp=0.0f;
	float MAX31855_thermocouple_temp=0.0f;

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

	// Set up the AXI SPI Controller to operate with the MAX31855
	XSpi_MAX31855_INIT(SPI_BASEADDR);

	while (1)
	{
		// Read the ambient light sensor
		max_MAX44000_readLux(XPAR_IIC_1_BASEADDR, &LuxReading);

		// Execute 5-byte read transaction to fetch the temp sensor data
		XSpi_LowLevelExecute(SPI_BASEADDR, SPI_CHANNEL_SEL_0, TxBuffer, RxBuffer, 4);

		if(
			((RxBuffer[3] & 0x01)==0x01) ||		// Open Circuit
			((RxBuffer[3] & 0x02)==0x02) ||		// Short to GND
			((RxBuffer[3] & 0x04)==0x04) ||		// Short to VCC
			((RxBuffer[1] & 0x01)==0x01)		// Fault
			)
		{
			print("Temperature Sensor Error Detected!\n\r");
			line_count++;
		}
		else
		{
			// Internal Temp
			nTemporaryValue = RxBuffer[2];  			// bits 11..4
			nTemporaryValue = nTemporaryValue << 4;		// shift left to make room for bits 3..0
			nTemporaryValue2 = RxBuffer[3];				// bits 3..0 in the most significant spots
			nTemporaryValue2 = nTemporaryValue2 >> 4;	// shift right to get rid of extra bits and position
			nTemporaryValue |= nTemporaryValue2;		// Combine to get bits 11..0
			if((RxBuffer[2] & 0x80)==0x80)				// Check the sign bit and sign-extend if need be
				nTemporaryValue |= 0xFFFFF800;
			MAX31855_internal_temp = (float)nTemporaryValue / 16.0f;

			// Thermocouple Temp
			nTemporaryValue = RxBuffer[0];  			// bits 13..6
			nTemporaryValue = nTemporaryValue << 6;		// shift left to make room for bits 5..0
			nTemporaryValue2 = RxBuffer[1];				// bits 5..0 in the most significant spots
			nTemporaryValue2 = nTemporaryValue2 >> 2;	// shift right to get rid of extra bits and position
			nTemporaryValue |= nTemporaryValue2;		// Combine to get bits 13..0
			if((RxBuffer[0] & 0x80)==0x80)				// Check the sign bit and sign-extend if need be
				nTemporaryValue |= 0xFFFFE000;
			MAX31855_thermocouple_temp = (float)nTemporaryValue / 4.0f;
		}

 		pb_hit = XGpio_DiscreteRead(&GpioInput, PB_GPIO_CHANNEL); // Capture PB press
 		if (pb_hit ==1) {
 			if (line_count == 10) {
 				line_count = 0;
 				print("\033[2J"); // Clear the screen
 				print_banner();
 			}

 			printf("Internal temp. = %3.1fC, Thermocouple temp. = %3.1fC \r\n",MAX31855_internal_temp, MAX31855_thermocouple_temp);
 			line_count++;
 			xil_printf("Lux Value = %4d\r\n",LuxReading);
 			line_count++;
 		}

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

