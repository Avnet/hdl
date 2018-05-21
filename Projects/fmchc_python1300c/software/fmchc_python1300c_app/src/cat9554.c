// ----------------------------------------------------------------------------
//  
//        ** **        **          **  ****      **  **********  ********** ® 
//       **   **        **        **   ** **     **  **              ** 
//      **     **        **      **    **  **    **  **              ** 
//     **       **        **    **     **   **   **  *********       ** 
//    **         **        **  **      **    **  **  **              ** 
//   **           **        ****       **     ** **  **              ** 
//  **  .........  **        **        **      ****  **********      ** 
//     ........... 
//                                     Reach Further™ 
//  
// ----------------------------------------------------------------------------
// 
// This design is the property of Avnet.  Publication of this 
// design is not authorized without written consent from Avnet. 
// 
// Please direct any questions to the PicoZed community support forum: 
//    http://www.zedboard.org/forum 
// 
// Disclaimer: 
//    Avnet, Inc. makes no warranty for the use of this code or design. 
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
//    any errors, which may appear in this code, nor does it make a commitment 
//    to update the information contained herein. Avnet, Inc specifically 
//    disclaims any implied warranties of fitness for a particular purpose. 
//                     Copyright(c) 2017 Avnet, Inc. 
//                             All rights reserved. 
// 
// ----------------------------------------------------------------------------

// address used on production hardware
#define IIC_CAT9554_SADR   0x24
// address used on prototype hardware
#define IIC_CAT9554A_SADR   0x3C

static unsigned int cat9554_iic_address = 0;


#include "cat9554.h"

void cat9554_detect(fmc_iic_t *pInstance) {
	u8 status = 0;

	//xil_printf("Detecting CAT9554 I2C address\n\r" );

	if ( pInstance->fpIicRead( pInstance, IIC_CAT9554_SADR, 0x01, &status, 1) > 0 )
	{
		// detected production hardware
		//xil_printf( "Detected production hardware, using IIC_CAT9554_SADR\n\r");
		cat9554_iic_address = IIC_CAT9554_SADR;
	}
	else if ( pInstance->fpIicRead( pInstance, IIC_CAT9554A_SADR, 0x01, &status, 1) > 0 )
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

void cat9554_initialize(fmc_iic_t *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	pInstance->fpIicWrite( pInstance, cat9554_iic_address, 0x01, &status, 1);

	pInstance->fpIicRead( pInstance, cat9554_iic_address, 0x03, &status, 1);
	status &= 0xF8;
	pInstance->fpIicWrite( pInstance, cat9554_iic_address, 0x03, &status, 1);
}

void cat9554_vdd18_en(fmc_iic_t *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	pInstance->fpIicRead( pInstance, cat9554_iic_address, 0x01, &status, 1);
	status |= 0x01;
	pInstance->fpIicWrite( pInstance, cat9554_iic_address, 0x01, &status, 1);
}

void cat9554_vdd18_off(fmc_iic_t *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	pInstance->fpIicRead(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status &= ~0x01;
	pInstance->fpIicWrite(pInstance, cat9554_iic_address, 0x01, &status, 1);
}

void cat9554_vdd33_en(fmc_iic_t *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	pInstance->fpIicRead( pInstance, cat9554_iic_address, 0x01, &status, 1);
	status |= 0x02;
	pInstance->fpIicWrite( pInstance, cat9554_iic_address, 0x01, &status, 1);
}

void cat9554_vdd33_off(fmc_iic_t *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	pInstance->fpIicRead(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status &= ~0x02;
	pInstance->fpIicWrite(pInstance, cat9554_iic_address, 0x01, &status, 1);
}

void cat9554_vddpix_en(fmc_iic_t *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	pInstance->fpIicRead( pInstance, cat9554_iic_address, 0x01, &status, 1);
	status |= 0x04;
	pInstance->fpIicWrite( pInstance, cat9554_iic_address, 0x01, &status, 1);

}

void cat9554_vddpix_off(fmc_iic_t *pInstance) {
	u8 status = 0;

	if ( !cat9554_iic_address )	{ cat9554_detect(pInstance); }

	pInstance->fpIicRead(pInstance, cat9554_iic_address, 0x01, &status, 1);
	status &= ~0x04;
	pInstance->fpIicWrite(pInstance, cat9554_iic_address, 0x01, &status, 1);

}

