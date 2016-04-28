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
// Module Name:         main.c
// Project Name:        MicroZed Sensor Fusion Demo
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     MicroZed, MicroZed I/O Carrier
//
// Tool versions:       Xilinx Vivado 2015.2
//
// Description:         SPI_TempSensor_MAX31723: simple test application to 
//                      drive SPI comands to MAX31723 PMOD placed on MicroZed
//                      I/O Carrier PMOD connector J1 top row.
//
// Dependencies:
//
// Revision:            Feb 10, 2016: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include "PmodUtilities.h"

int main()
{

	int i;
	int nTemp;
	int result;
	float fTemp;
	u32 TxBuffer[5];
	u32 RxBuffer[5];

	//Set up the ARM PS
	init_platform();

	// Set up the AXI SPI Controller to operate with the MAX31723
	XSpi_MAX31723_INIT(SPI_BASEADDR);
	
	print("     - MicroZed I/O Carrier Card\n\r");
	print("     -    PMOD JA MAX31723 Temp Sensor\n\r");

	while(1)
	{
		fflush(stdin);

		// Set up the TxBuffer to continuously perform temperature conversions with 12-bit resolution
		TxBuffer[0] = MAX31723_CSR_WRITE;
		TxBuffer[1] = MAX31723_12BIT_MODE;
		// Execute 2-byte write transaction.
		// Data returned in RxBuffer is expected to be garbage since we were only writing data
		// By design, the SPI protocol will return data anyway
		XSpi_LowLevelExecute(SPI_BASEADDR, SPI_CHANNEL_SEL_0, TxBuffer, RxBuffer, 2);
		sleep(1);

		// Initialize RxBuffer with all 1's
		for(i = 0; i < 5; i++) RxBuffer[i] = 0xFFFFFFFF; // init RxBuffer with 0xFFs
		// Set up the TxBuffer to read a 2-byte LSB/MSB temperature
		// Data in TxBuffer[1:2] should be ignored but setting to 0x0 anyway
		TxBuffer[0] = MAX31723_TEMP_READ;
		TxBuffer[1] = 0x00;
		TxBuffer[2] = 0x00;
		// Execute 3-byte read transaction.
		// Data in RxBuffer[0] is garbage since it is populated while the Read Command in TxBuffer[0] is being sent
		// RxBuffer[1] = LSB
		// RxBuffer[2] = MSB
		result = XSpi_LowLevelExecute(SPI_BASEADDR, SPI_CHANNEL_SEL_0, TxBuffer, RxBuffer, 3);

		if (result == XST_FAILURE)
		{
			printf("No communications with MAX31723 device, check connection.\n\r");
		}

		// Convert to approximate floating point
		// The 31723 temperature readings are signed 12 bits long, and each bit represents 1/16th of a degree C
		nTemp = 0;
		// Extract the MSB
		nTemp = (int)RxBuffer[2];
		// Shift left by 4 to make room for the LS nibble
		nTemp = nTemp << 4;
		// Combine the MSB with the LS nibble. Lower 4 bits of the LSB are always 0.
		nTemp |= (int)((RxBuffer[1] & 0xF0)>>4);
		// Is the 12bit bit set?  If so, set the other bits for the 2s complement negative value
		if((nTemp & 0x00000800)==0x00000800)
			nTemp |= 0xFFFFF000;
		// Convert to floating point
		fTemp = (float)nTemp;
		// Each count of nTemp = 1/16th of a degree C
		fTemp = fTemp / 16.0f;
		printf("%.1f deg C\n\r",fTemp);
		sleep(1);
	}
    return 0;
}
