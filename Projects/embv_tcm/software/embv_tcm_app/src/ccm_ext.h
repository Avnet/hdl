/*
 * ccm_ext.h
 *
 *  Created on: Jun 10, 2014
 *      Author: 910560
 */

#ifndef CCM_EXT_H_
#define CCM_EXT_H_

#include "xccm.h"
#include "xbasic_types.h"

#define XCfa_Disable(InstancePtr) \
	XCfa_WriteReg((InstancePtr)->Config.BaseAddress, \
				(XCFA_CONTROL_OFFSET), \
		((XCfa_ReadReg((InstancePtr)->Config.BaseAddress, \
			(XCFA_CONTROL_OFFSET))) & (~(XCFA_CTL_SW_EN_MASK))))

#define Integer(Input) \
	(int)(Input)

#define Fraction(Input, Precision) \
	(Input > Integer(Input)) ? \
	(int)((Input - Integer(Input)) * Precision) : \
	(int)((Integer(Input) - Input) * Precision)

static XCcm_Coefs CCM_IDENTITY = {
		1.0, 0.0, 0.0,
		0.0, 1.0, 0.0,
		0.0, 0.0, 1.0
};

static XCcm_Coefs CCM_RGB_DAY = {
		2.4, 0.3, -0.8,
		-0.7, 3.2, -0.9,
		-0.1, -1.1, 3.8
};

static XCcm_Coefs CCM_RGB_CWF = {
		3.8, -0.7, -0.9,
		-0.8, 2.7, -0.2,
		-0.3, -0.8, 5.0
};

static XCcm_Coefs CCM_RGB_U30 = {
		2.5, -0.5, -0.5,
		-0.8, 3.8, -1.4,
		-0.1, -1.4, 6.5
};

static XCcm_Coefs CCM_RGB_INC = {
		1.7, 1.6, -1.6,
		-1.9, 7.9, -3.8,
		-1.0, 1.3, 4.5
};

#endif /* CCM_EXT_H_ */
