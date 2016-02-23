/*
 * tca9548.c
 *
 *  Created on: Jun 30, 2014
 *      Author: 910560
 */

#include "tca9548.h"

#define IIC_TCA9548_SADR   0x70

void tca9548_i2c_mux_select(XIicPs *pInstance, u8 i2c_select) {
	XIicPs_Write(pInstance, IIC_TCA9548_SADR, i2c_select, NULL, 0);
	usleep(10000);
}
