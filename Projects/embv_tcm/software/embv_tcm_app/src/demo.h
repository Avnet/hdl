/*
 * demo.h
 *
 *  Created on: Jun 26, 2015
 *      Author: 910560
 */

#ifndef DEMO_H_
#define DEMO_H_

#include "xgpiops.h"
#include "xiicps.h"
#include "xcfa.h"
#include "xccm.h"
#include "xrgb2ycrcb.h"
#include "xcresample.h"
#include "xaxivdma.h"
#include "xosd.h"
#include "xvtc.h"

#define EMBV_IIC_MUX_I2CIO      TCA9548_I2C0_SEL
#define EMBV_IIC_MUX_HDMII      TCA9548_I2C1_SEL
#define EMBV_IIC_MUX_HDMIO      TCA9548_I2C2_SEL
#define EMBV_IIC_MUX_HDMIO_DDC  TCA9548_I2C3_SEL
#define EMBV_IIC_MUX_AUD        TCA9548_I2C4_SEL
#define EMBV_IIC_MUX_CAM        TCA9548_I2C5_SEL

typedef struct {
	XGpioPs *pgpiops;
	XIicPs *piicps;
	XCfa *pcfa;
	XCcm *pccm;
	XRgb2YCrCb *prgb2ycrcb;
	XCresample *pcresample;
	XAxiVdma *paxivdma;
	XOsd *posd;
	XVtc *pvtc;
} demo_t;

#endif /* DEMO_H_ */
