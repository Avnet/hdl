/*
 * pca9534.c
 *
 *  Created on: Jun 30, 2014
 *      Author: 910560
 */

// address used on production hardware
#define IIC_CAT9554_SADR   0x24
// address used on prototype hardware
#define IIC_CAT9554A_SADR   0x3C

static unsigned int cat9554_iic_address = 0;


#include "cat9554.h"
#include "xiicps_ext.h"

void cat9554_detect(XIicPs *pInstance) {
	u8 status = 0;

	//xil_printf("Detecting CAT9554 I2C address\n\r" );

	if ( XIicPs_Read(pInstance, IIC_CAT9554_SADR, 0x01, &status, 1) == XST_SUCCESS )
	{
		// detected production hardware
		//xil_printf( "Detected production hardware, using IIC_CAT9554_SADR\n\r");
		cat9554_iic_address = IIC_CAT9554_SADR;
	}
	else if ( XIicPs_Read(pInstance, IIC_CAT9554A_SADR, 0x01, &status, 1) == XST_SUCCESS )
	{
		// detected prototype hardware
		//xil_printf( "Detected prototype hardware, using IIC_CAT9554A_SADR\n\r");
		xil_printf( "CAT9554 : using IIC_CAT9554A_SADR instead of IIC_CAT9554_SADR\n\r");
		cat9554_iic_address = IIC_CAT9554A_SADR;
	}
	else
	{
		// assuming production hardware
		cat9554_iic_address = IIC_CAT9554_SADR;
	}
}

void cat9554_initialize(XIicPs *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	XIicPs_Write(pInstance, cat9554_iic_address, 0x01, &status, 1);

	XIicPs_Read(pInstance, cat9554_iic_address, 0x03, &status, 1);
	status &= 0xF8;
	XIicPs_Write(pInstance, cat9554_iic_address, 0x03, &status, 1);
}

void cat9554_vdd18_en(XIicPs *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	XIicPs_Read(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status |= 0x01;
	XIicPs_Write(pInstance, cat9554_iic_address, 0x01, &status, 1);
}

void cat9554_vdd18_off(XIicPs *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	XIicPs_Read(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status &= ~0x01;
	XIicPs_Write(pInstance, cat9554_iic_address, 0x01, &status, 1);
}


void cat9554_vdd33_en(XIicPs *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	XIicPs_Read(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status |= 0x02;
	XIicPs_Write(pInstance, cat9554_iic_address, 0x01, &status, 1);
}

void cat9554_vdd33_off(XIicPs *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	XIicPs_Read(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status &= ~0x02;
	XIicPs_Write(pInstance, cat9554_iic_address, 0x01, &status, 1);
}

void cat9554_vddpix_en(XIicPs *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	XIicPs_Read(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status |= 0x04;
	XIicPs_Write(pInstance, cat9554_iic_address, 0x01, &status, 1);

}

void cat9554_vddpix_off(XIicPs *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	XIicPs_Read(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status &= ~0x04;
	XIicPs_Write(pInstance, cat9554_iic_address, 0x01, &status, 1);

}



