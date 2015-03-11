/*
 * demo.h
 *
 *  Created on: Dec 23, 2014
 *      Author: 910560
 */

#ifndef DEMO_H_
#define DEM

#include "xiicps.h"
#include "xcfa.h"
#include "xccm.h"
#include "xaxivdma.h"
#include "xosd.h"

#define EMBV_IIC_MUX_I2CIO      TCA9548_I2C0_SEL
#define EMBV_IIC_MUX_HDMII      TCA9548_I2C1_SEL
#define EMBV_IIC_MUX_HDMIO      TCA9548_I2C2_SEL
#define EMBV_IIC_MUX_HDMIO_DDC  TCA9548_I2C3_SEL
#define EMBV_IIC_MUX_AUD        TCA9548_I2C4_SEL
#define EMBV_IIC_MUX_CAM        TCA9548_I2C5_SEL

typedef struct  {
	XIicPs iicps0;
	XCfa cfa;
	XCcm ccm;
	XAxiVdma axivdma;
	XOSD osd;

	XIicPs *piicps0;
	XCfa *pcfa;
	XCcm *pccm;
	XAxiVdma *paxivdma;
	XOSD *posd;
} demo_t;

#endif /* DEMO_H_ */
