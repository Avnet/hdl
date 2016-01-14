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
// Create Date:         Nov 24, 2015
// Design Name:         PicoZed IIC MAC EEPROM Demonstration
// Module Name:         mac_eeprom_demo.c
// Project Name:        PicoZed + FMC2 Carrier
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     PicoZed + FMC2 Carrier
//
// Tool versions:       Xilinx Vivado 2015.2
//
// Description:         PicoZed IIC MAC EEPROM Demonstration
//
// Dependencies:
//
// Revision:            Nov 24, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "xil_cache.h"

#include "mac_eeprom_demo.h"

#define MAC_EEPROM_SLAVE_ADDRESS                    0x51

int zed_mac_eeprom_demo_init(iic_eeprom_demo_t *pDemo)
{
   int ret;

   /* IIC initialization for communicating with the RTC slave hardware.
    */
   xil_printf("MAC EEPROM Initialization ...\n\r");
   ret = zed_iic_axi_init(&(pDemo->eeprom_iic),"RTC I2C", pDemo->uBaseAddr_IIC_RTC);
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
* Read the contents of the EEPROM memory and dump it to the terminal.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int dump_mac_eeprom_memory(iic_eeprom_demo_t *pDemo)
{
	int8u ChipAddress = MAC_EEPROM_SLAVE_ADDRESS;
	int8u RegAddress  = 0x00;
	int8u RegData[10];
	int8u ByteCount   = 0;
	int8u page = 0;
	int ret;

    // Begin printing the content table to the terminal.
    xil_printf("+----------------------------------------------------------------------------+\r\n");
    xil_printf("|                   Dumping IIC MAC EEPROM Contents                          |\r\n");
    xil_printf("|----------------------------------------------------------------------------|\r\n");
    xil_printf("|Offset:         0       1       2       3       4       5       6       7   |\r\n");
    xil_printf("|----------------------------------------------------------------------------|\r\n");

    ByteCount   = 8;

    // Display all of the data from the EEPROM memory to the terminal.
	while (page < 32)
	{
		RegAddress = page*8;


		ret = pDemo->eeprom_iic.fpIicRead(&(pDemo->eeprom_iic), ChipAddress, RegAddress, RegData, ByteCount+1);
		if (!ret)
		{
			xil_printf("ERROR : Failed to Read from MAC EEPROM\n\r");
			return -1;
		}

		xil_printf("|    0x%02X    |  0x%02X |  0x%02X |  0x%02X |  0x%02X |  0x%02X |  0x%02X |  0x%02X |  0x%02X |\r\n",
				page,
		RegData[0],
		RegData[1],
		RegData[2],
		RegData[3],
		RegData[4],
		RegData[5],
		RegData[6],
		RegData[7]);

		page++;
    }

    // Finish printing the content table to the terminal.
	xil_printf("+----------------------------------------------------------------------------+\r\n");
    xil_printf("\r\n");
    xil_printf("\r\n");

    xil_printf("Stored MAC Address is: %02X:%02X:%02X:%02X:%02X:%02X",
    		RegData[2],
        	RegData[3],
        	RegData[4],
        	RegData[5],
        	RegData[6],
        	RegData[7]);
    xil_printf("\r\n");
    xil_printf("\r\n");


    return 0;
}


/*****************************************************************************
*
* Read the contents of the EEPROM memory and dump it to the terminal.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int validate_mac_eeprom_memory(iic_eeprom_demo_t *pDemo)
{
	int8u ChipAddress = MAC_EEPROM_SLAVE_ADDRESS;
	int8u RegAddress  = 0x00;
	int8u WriteData[8], ReadData[8];
	int8u ByteCount   = 0;
	int8u page = 0;
	int ret, i;

    // Begin printing the content table to the terminal.
	xil_printf("+----------------------------------------------------------------------------+\r\n");
	xil_printf("|                      Validating IIC MAC EEPROM Contents                    |\r\n");
	xil_printf("|----------------------------------------------------------------------------|\r\n");

    ByteCount   = 8;

    // Display all of the data from the EEPROM memory to the terminal.
	while (page < 16)
	{
		RegAddress = page*8;

		for (i=0;i<8;i++){
			WriteData[i] = RegAddress+i;
		}

		ret = pDemo->eeprom_iic.fpIicWrite(&(pDemo->eeprom_iic), ChipAddress, RegAddress, WriteData, ByteCount);
		if (!ret)
		{
			xil_printf("ERROR : Failed to Write to EEPROM\n\r");
			return -1;
		}
		millisleep(5);

		ret = pDemo->eeprom_iic.fpIicRead(&(pDemo->eeprom_iic), ChipAddress, RegAddress, ReadData, ByteCount);
		if (!ret)
		{
			xil_printf("ERROR : Failed to Read from EEPROM\n\r");
			return -1;
		}

		for (i=0; i<8;i++){
			if (WriteData[i] != ReadData[i]){
				xil_printf("ERROR : Validation failed at Address: 0x%02X\n\r", RegAddress + i);
				return -1;
			}
		}

		xil_printf("Data write and read verified for address range 0x%02X - 0x%02X\n\r", RegAddress, RegAddress + i);

		page++;
    }

    // Finish printing the content table to the terminal.
    xil_printf("+----------------------------------------------------------------------------+\r\n");
    xil_printf("\r\n");

    return 0;
}

/*****************************************************************************
*
* Read the contents of the EEPROM memory and dump it to the terminal.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int erase_mac_eeprom_memory(iic_eeprom_demo_t *pDemo)
{
	int8u ChipAddress = MAC_EEPROM_SLAVE_ADDRESS;
	int8u RegAddress  = 0x00;
	int8u WriteData[8];
	int8u ByteCount   = 0;
	int8u page = 0;
	int ret, i;

	xil_printf("Erasing MAC EEPROM...");

    ByteCount   = 8;

    // Display all of the data from the EEPROM memory to the terminal.
        while (page < 16)
        {
        	RegAddress = page*8;

        	for (i=0;i<8;i++){
        		WriteData[i] = 0xFF;
        	}

        	ret = pDemo->eeprom_iic.fpIicWrite(&(pDemo->eeprom_iic), ChipAddress, RegAddress, WriteData, ByteCount);
			if (!ret)
			{
				xil_printf("\n\rERROR : Failed to Write to EEPROM\n\r");
				return -1;
			}
			millisleep(5);

			page++;
    }

    // Finish printing the content table to the terminal.
    xil_printf("Done!");
    xil_printf("\r\n");

    return 0;
}
