/*
 * pca9534.c
 *
 *  Created on: Jun 30, 2014
 *      Author: 910560
 */

#define IIC_PCA9534_SADR   0x20

#include "pca9534.h"
#include "xiicps_ext.h"

void pca9534_set_pins_direction(XIicPs *pInstance, u8 direction) {
	u8 status = direction;
	XIicPs_Write(pInstance, IIC_PCA9534_SADR, PCA9534_CONFIG_REG, &status, 1);
}

void pca9534_set_pin_direction(XIicPs *pInstance, u8 pinno, u8 direction) {
	u8 status;
	u8 mask;

	XIicPs_Read(pInstance, IIC_PCA9534_SADR, PCA9534_CONFIG_REG, &status, 1);

	mask = (0x01 << pinno);
	status = status & ~mask;
	mask = (direction << pinno);
	status = status | mask;

	XIicPs_Write(pInstance, IIC_PCA9534_SADR, PCA9534_CONFIG_REG, &status, 1);
}


void pca9534_set_pin_value(XIicPs *pInstance, u8 pinno, u8 value) {
	u8 status;
	u8 mask;

	XIicPs_Read(pInstance, IIC_PCA9534_SADR, PCA9534_OUTPUT_REG, &status, 1);
	mask = (0x01 << pinno);
	status = status & ~mask;
	mask = (value << pinno);
	status = status | mask;

	XIicPs_Write(pInstance, IIC_PCA9534_SADR, PCA9534_OUTPUT_REG, &status, 1);
}


int pca9534_get_pin_value(XIicPs *pInstance, u8 pinno) {
	u8 status;
	u8 mask;

	XIicPs_Read(pInstance, IIC_PCA9534_SADR, PCA9534_INPUT_REG, &status, 1);
	mask = (0x01 << pinno);
	status = status & mask;
	status = (status >> pinno);

	return status;
}
