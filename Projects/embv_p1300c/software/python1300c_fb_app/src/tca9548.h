/*
 * tca9548.h
 *
 *  Created on: Jun 30, 2014
 *      Author: 910560
 */

#ifndef TCA9548_H_
#define TCA9548_H_

#include "xiicps_ext.h"

#define	TCA9548_I2C0_SEL   0x01
#define	TCA9548_I2C1_SEL   0x02
#define	TCA9548_I2C2_SEL   0x04
#define	TCA9548_I2C3_SEL   0x08
#define	TCA9548_I2C4_SEL   0x10
#define	TCA9548_I2C5_SEL   0x20
#define	TCA9548_I2C6_SEL   0x40
#define	TCA9548_I2C7_SEL   0x80

void tca9548_i2c_mux_select(XIicPs *pInstance, u8 i2c_select);

#endif /* TCA9548_H_ */
