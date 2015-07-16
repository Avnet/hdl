/*
 * demo.h
 *
 *  Created on: Dec 23, 2014
 *      Author: 910560
 */

#ifndef DEMO_H_
#define DEM

#include "fmc_iic.h"
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
    fmc_iic_t pzsdr_fmccc_iic;
	XCfa cfa;
	XCcm ccm;
	XAxiVdma axivdma;
	XOSD osd;

    fmc_iic_t *ppzsdr_fmccc_iic;
	XCfa *pcfa;
	XCcm *pccm;
	XAxiVdma *paxivdma;
	XOSD *posd;
} demo_t;

#endif /* DEMO_H_ */
