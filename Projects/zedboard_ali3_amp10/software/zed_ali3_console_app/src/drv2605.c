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
// Create Date:         Jun 04, 2015
// Design Name:         ZedBoard ALI3 Controller Demonstration
// Module Name:         drv2605.c
// Project Name:        ZedBoard ALI3 Display Kit
//
// Tool versions:       Vivado 2014.4
//
// Description:         Implementation for TI DRV2605 haptic driver
//
// Dependencies:        
//
// Revision:            Jun 04, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "zed_ali3_controller_demo.h"
#include "types.h"
#include "drv2605.h"

int32u haptic_driver_init(zed_ali3_controller_demo_t *pDemo){

	// Initialization process is defined in the datasheet (page 51)

    int8u ChipAddress = DRV2605_SLAVE_ADDR;
    int8u RegAddress  = DRV2605_MODE_REG;
    int8u RegData     = 0x07;
    int8u ByteCount   = 1;
    int32u ret;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	RegAddress  = DRV2605_FBK_CNTRL_REG;
	RegData     = DRV2605_AUTOCAL_FBK_CNTL_VAL;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	// Rated voltage setting is actuator specific - Must be recalculated for any actuator other than Samsung DMJBRN0934BW
	RegAddress  = DRV2605_RATED_VOLT_REG;
	RegData     = DRV2605_AUTOCAL_RATED_VOLT_VAL;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	// Rated voltage setting is actuator specific - Must be recalculated for any actuator other than Samsung DMJBRN0934BW
	RegAddress  = DRV2605_OD_CLAMP_REG;
	RegData     = DRV2605_AUTOCAL_OD_CLAMP_VAL;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	RegAddress  = DRV2605_CNTL_4_REG;
	RegData     = DRV2605_AUTOCAL_CNTL_4_VAL;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	RegAddress  = DRV2605_CNTL_1_REG;
	RegData     = DRV2605_AUTOCAL_CNTL_1_VAL;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	RegAddress  = DRV2605_CNTL_2_REG;
	RegData     = DRV2605_AUTOCAL_CNTL_2_VAL;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	RegAddress  = DRV2605_GO_REG;
	RegData     = 0x01;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}


	return 0;
}

int32u haptic_trigger_effect(zed_ali3_controller_demo_t *pDemo, HAPTIC_EFFECT effect){
	int8u ChipAddress = DRV2605_SLAVE_ADDR;
	int8u RegAddress  = DRV2605_MODE_REG;
	int8u RegData     = 0x00;
	int8u ByteCount   = 1;
	int32u ret;

	ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	RegAddress  = DRV2605_WAVEFORM_1;
	RegData     = effect;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}

	RegAddress  = DRV2605_GO_REG;
	RegData     = 0x01;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write to Haptic Driver\n\r");
		return -1;
	}


	return 0;
}
