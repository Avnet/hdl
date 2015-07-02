/*
 * xrgb2ycrcb_ext.h
 *
 *  Created on: Jun 23, 2015
 *      Author: 910560
 */

#ifndef XRGB2YCRCB_EXT_H_
#define XRGB2YCRCB_EXT_H_

#include "xrgb2ycrcb.h"

void XRgb2YCrCb_Configuration(XRgb2YCrCb *InstancePtr,
				enum XRgb_Standards StandardSel,
				enum XRgb_OutputRanges InputRange, u32 DataWidth);

#endif /* XRGB2YCRCB_EXT_H_ */
