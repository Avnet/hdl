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
//                     Copyright(c) 2015 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Nov 27, 2015
// Design Name:         PicoZed IIC Clock Synthesizer Demonstration
// Module Name:         idt8t49N242_demo.c
// Project Name:        PicoZed + FMC2 Carrier
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     PicoZed + FMC2 Carrier
//
// Tool versions:       Xilinx Vivado 2015.2
//
// Description:         PicoZed IIC Clock Synthesizer Demonstration
//
// Dependencies:
//
// Revision:            Nov 27, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "xil_cache.h"

#include "idt8t49N242_demo.h"

// Slave address of the IDT UFT 242 Clock Synthesizer when it has not loaded
// an valid configuration from the EEPROM.
//
// This is in the 7-bit form required by the IIC library which represents
// the 0xF8 value specified by the IDT datasheet.
//
// Here is the actual representation of the 7-bit slave address this
// represents:
//
// -------------------------------------
// | 1 | 1 | 1 | 1 | 1 | A1 | A0 | R/W |
// -------------------------------------
#define IDT8T49N242_SLAVE_ADDRESS_DEFAULT            0x7C

// Slave address of the IDT UFT 242 Clock Synthesizer after it has loaded
// the Avnet factory default load for the configuration EEPROM.
//
// This is in the 7-bit form required by the IIC library which represents
// the 0xD8 value specified by the IDT datasheet.
//
// Here is the actual representation of the 7-bit slave address this
// represents:
//
// -------------------------------------
// | 1 | 1 | 0 | 1 | 1 | A1 | A0 | R/W |
// -------------------------------------
#define IDT8T49N242_SLAVE_ADDRESS_CONFIG             0x6C

int idt8t49N242_demo_init(iic_eeprom_demo_t *pDemo)
{
   int ret;

   /* IIC initialization for communicating with the RTC slave hardware.
    */
   xil_printf("Clock Generator Initialization ...\n\r");
   ret = zed_iic_axi_init(&(pDemo->uft242_iic),"UFT I2C", pDemo->uBaseAddr_IIC_UFT);
   if (!ret)
   {
      xil_printf("ERROR : Failed to open AXI IIC device driver\n\r");
      return -1;
   }

   /* Check to see how the device has been configured. */
   //zed_rtc_demo_status(pDemo);

   return 0;
}


/*****************************************************************************
*
* Read from select IDT UFT 242 registers and output to the terminal.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int validate_idt8t49N242(iic_eeprom_demo_t *pDemo)
{
	int8u ChipAddress = IDT8T49N242_SLAVE_ADDRESS_DEFAULT;
	int16u RegAddress  = 0x0002;
	int8u ReadData[8];
	int8u ByteCount   = 0;
	int8u Rev_ID = 0;
	int16u Dev_ID = 0;
	int16u Dash_Code = 0;

	int ret;

    // Begin printing the content table to the terminal.
    xil_printf("+----------------------------------------------------------------------------+\r\n");
    xil_printf("|                         Validating IDT8T49N242                             |\r\n");
    xil_printf("|----------------------------------------------------------------------------|\r\n");

    ReadData[0] = 0;
    ReadData[1] = 0;
    ReadData[2] = 0;
    ReadData[3] = 0;

    ByteCount   = 4;

    ret = pDemo->uft242_iic.fpIicRead(&(pDemo->uft242_iic), ChipAddress, RegAddress, ReadData, ByteCount);
	if (!ret)
	{
		xil_printf("|                                                                            |\r\n");
		xil_printf("| Failed to Read from IDT8T49N242 at the default address,                    |\r\n");
		xil_printf("| checking for Avnet default EEPROM config address.                          |\n\r");
		xil_printf("|                                                                            |\r\n");

		ChipAddress = IDT8T49N242_SLAVE_ADDRESS_CONFIG;

	    ReadData[0] = 0;
	    ReadData[1] = 0;
	    ReadData[2] = 0;
	    ReadData[3] = 0;

	    ByteCount   = 4;

	    ret = pDemo->uft242_iic.fpIicRead(&(pDemo->uft242_iic), ChipAddress, RegAddress, ReadData, ByteCount);
		if (!ret)
		{
			xil_printf("ERROR:  Failed to Read from IDT8T49N242 at the Avnet default EEPROM config address\n\r");
			return -1;
		}
	}

	Rev_ID = ReadData[0] >> 4;
	Dev_ID = (((int16u)ReadData[0]) << 12) | (((int16u)ReadData[1])<<4) | (((int16u)ReadData[2])>>4);
	Dash_Code = (((int16u)ReadData[2] & 0x0F)<<7) | (((int16u)ReadData[3])>>1);

	xil_printf("| Rev_ID: 0x%04X                                                             |\r\n",Rev_ID);
	xil_printf("| Dev_ID: 0x%04X                                                             |\r\n",Dev_ID);
	xil_printf("| Dash_Code: 0x%04X                                                          |\r\n",Dash_Code);

    // Finish printing the content table to the terminal.
    xil_printf("+----------------------------------------------------------------------------+\r\n");
    xil_printf("\r\n");

    return 0;
}

