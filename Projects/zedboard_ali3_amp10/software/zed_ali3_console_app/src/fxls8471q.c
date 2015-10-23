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
// Please direct any questions or issues to the MicroZed Community Forums:
//     http://www.microzed.org
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
// Create Date:         May 08, 2015
// Design Name:         ZedBoard ALI3 Controller Demonstration
// Module Name:         fxls8471.c
// Project Name:        ZedBoard ALI3 Display Kit
//
// Tool versions:       Vivado 2014.4
//
// Description:         Implementation for Freescale FXLS8471 accelerometer
//
// Dependencies:        
//
// Revision:            May 08, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "zed_ali3_controller_demo.h"
#include "types.h"
#include "fxls8471q.h"

int32u accelerometer_init(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = FXLS8471Q_SLAVE_ADDR;
    int8u RegAddress  = FXLS8471Q_WHOAMI;
    int8u RegData     = 0x00;
    int8u ByteCount   = 1;
    int32u ret;

    // Write the control message to the FXLS8471 controller.
    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

    if (!ret)
    {
        xil_printf("ERROR : Failed to read from Accelerometer\n\r");
        return -1;
    }

    xil_printf("ACCEL INIT: WHOAMI=0x%02X\n\r", RegData);


    RegAddress = FXLS8471Q_CTRL_REG1;
    RegData     = 0x00;
    ByteCount   = 1;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to read from Accelerometer\n\r");
		return -1;
	}

	RegAddress = FXLS8471Q_XYZ_DATA_CFG;
	RegData     = 0x01;
	ByteCount   = 1;

	ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to read from Accelerometer\n\r");
		return -1;
	}

    RegAddress = FXLS8471Q_CTRL_REG1;
    RegData     = 0x15;
    ByteCount   = 1;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to read from Accelerometer\n\r");
		return -1;
	}

	 return 0;
}

int32u accelerometer_poll(zed_ali3_controller_demo_t *pDemo)
{
	int8u ChipAddress = FXLS8471Q_SLAVE_ADDR;
	int8u RegAddress  = FXLS8471Q_STATUS;
	int8u RegData[7];
	int8u ByteCount   = 7;
	int32u ret;

	// Write the control message to the TMG120 controller.
	ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to read from Accelerometer\n\r");
		return -1;
	}

	pDemo->accel_x = (RegData[1]);//<<8) + (RegData[2]>>2);
	pDemo->accel_y = (RegData[3]);//<<8) + (RegData[4]>>2);
	pDemo->accel_z = (RegData[5]);//<<8) + (RegData[6]>>2);

	return 0;
}


