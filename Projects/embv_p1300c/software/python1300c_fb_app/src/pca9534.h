/*
 * pca9534.h
 *
 *  Created on: Jun 30, 2014
 *      Author: 910560
 */

#ifndef PCA9534_H_
#define PCA9534_H_

#include "xiicps.h"

#define PCA9534_INPUT_REG  0x00
#define PCA9534_OUTPUT_REG  0x01
#define PCA9534_POLINV_REG  0x02
#define PCA9534_CONFIG_REG  0x03

void pca9534_set_pins_direction(XIicPs *pInstance, u8 direction);
void pca9534_set_pin_direction(XIicPs *pInstance, u8 pinno, u8 direction);
void pca9534_set_pin_value(XIicPs *pInstance, u8 pinno, u8 value);
int pca9534_get_pin_value(XIicPs *pInstance, u8 pinno);

#endif /* PCA9534_H_ */
