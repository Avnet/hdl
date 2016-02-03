/*
 * pca9534.h
 *
 *  Created on: Jun 30, 2014
 *      Author: 910560
 */

#ifndef PCA9534_H_
#define PCA9534_H_

#include "fmc_iic.h"

#define PCA9534_INPUT_REG  0x00
#define PCA9534_OUTPUT_REG  0x01
#define PCA9534_POLINV_REG  0x02
#define PCA9534_CONFIG_REG  0x03

void cat9554_initialize(fmc_iic_t *pInstance);
void cat9554_vdd18_en(fmc_iic_t *pInstance);
void cat9554_vdd33_en(fmc_iic_t *pInstance);
void cat9554_vddpix_en(fmc_iic_t *pInstance);

void cat9554_vdd18_off(fmc_iic_t *pInstance);
void cat9554_vdd33_off(fmc_iic_t *pInstance);
void cat9554_vddpix_off(fmc_iic_t *pInstance);

#endif /* PCA9534_H_ */
